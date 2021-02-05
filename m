Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE1A93110C6
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 20:12:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233597AbhBER16 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 12:27:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:54518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233480AbhBEQAH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 11:00:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 13D9964FE2;
        Fri,  5 Feb 2021 14:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534207;
        bh=LNGWqYpA7l/BONierlFYpiJfrjAGTnboreHJTsYSzyE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jFNS+unxfHBJrlMyMeCMB+5VxgFqBK4o7lfDtotPF+mvy3J2mEk4CHj9074M/P0fl
         nVHzRDUOD1x7ZJZYZSjhS4stbA0MrXh+AloXPsNS0fIE3Mlx8EyTu/jFiypYK7XKjq
         vevDa9GddW+oDgsczckMj4hz4rVWJ1u1YxZNUlVo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Javed Hasan <jhasan@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 27/57] scsi: libfc: Avoid invoking response handler twice if ep is already completed
Date:   Fri,  5 Feb 2021 15:06:53 +0100
Message-Id: <20210205140657.137294776@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205140655.982616732@linuxfoundation.org>
References: <20210205140655.982616732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Javed Hasan <jhasan@marvell.com>

[ Upstream commit b2b0f16fa65e910a3ec8771206bb49ee87a54ac5 ]

A race condition exists between the response handler getting called because
of exchange_mgr_reset() (which clears out all the active XIDs) and the
response we get via an interrupt.

Sequence of events:

	 rport ba0200: Port timeout, state PLOGI
	 rport ba0200: Port entered PLOGI state from PLOGI state
	 xid 1052: Exchange timer armed : 20000 msecs      xid timer armed here
	 rport ba0200: Received LOGO request while in state PLOGI
	 rport ba0200: Delete port
	 rport ba0200: work event 3
	 rport ba0200: lld callback ev 3
	 bnx2fc: rport_event_hdlr: event = 3, port_id = 0xba0200
	 bnx2fc: ba0200 - rport not created Yet!!
	 /* Here we reset any outstanding exchanges before
	 freeing rport using the exch_mgr_reset() */
	 xid 1052: Exchange timer canceled
	 /* Here we got two responses for one xid */
	 xid 1052: invoking resp(), esb 20000000 state 3
	 xid 1052: invoking resp(), esb 20000000 state 3
	 xid 1052: fc_rport_plogi_resp() : ep->resp_active 2
	 xid 1052: fc_rport_plogi_resp() : ep->resp_active 2

Skip the response if the exchange is already completed.

Link: https://lore.kernel.org/r/20201215194731.2326-1-jhasan@marvell.com
Signed-off-by: Javed Hasan <jhasan@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/libfc/fc_exch.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 96a2952cf626b..a50f1eef0e0cd 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -1624,8 +1624,13 @@ static void fc_exch_recv_seq_resp(struct fc_exch_mgr *mp, struct fc_frame *fp)
 		rc = fc_exch_done_locked(ep);
 		WARN_ON(fc_seq_exch(sp) != ep);
 		spin_unlock_bh(&ep->ex_lock);
-		if (!rc)
+		if (!rc) {
 			fc_exch_delete(ep);
+		} else {
+			FC_EXCH_DBG(ep, "ep is completed already,"
+					"hence skip calling the resp\n");
+			goto skip_resp;
+		}
 	}
 
 	/*
@@ -1644,6 +1649,7 @@ static void fc_exch_recv_seq_resp(struct fc_exch_mgr *mp, struct fc_frame *fp)
 	if (!fc_invoke_resp(ep, sp, fp))
 		fc_frame_free(fp);
 
+skip_resp:
 	fc_exch_release(ep);
 	return;
 rel:
@@ -1900,10 +1906,16 @@ static void fc_exch_reset(struct fc_exch *ep)
 
 	fc_exch_hold(ep);
 
-	if (!rc)
+	if (!rc) {
 		fc_exch_delete(ep);
+	} else {
+		FC_EXCH_DBG(ep, "ep is completed already,"
+				"hence skip calling the resp\n");
+		goto skip_resp;
+	}
 
 	fc_invoke_resp(ep, sp, ERR_PTR(-FC_EX_CLOSED));
+skip_resp:
 	fc_seq_set_resp(sp, NULL, ep->arg);
 	fc_exch_release(ep);
 }
-- 
2.27.0



