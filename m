Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0885310EFE
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 18:44:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231991AbhBEQBe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 11:01:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:54422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233461AbhBEP7b (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 10:59:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3FDA065071;
        Fri,  5 Feb 2021 14:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534388;
        bh=Bmz+88J6KbyvxEg5Rr1e3c7ZoiMhZVsQRiznE0tpD5A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E+YAy6fMnLKyEHZ6+r+uKMNfpP0qWvaZMjHB1ppSpoRXcAAAB670+Z9pojTZ6yURt
         OCJhVBKH76CyYocmO81ek0r6TNrjS18w+Ajozj0bYCyAI+J+unhl6TZVUWIq3dN2Ya
         hYnq+YPQMfZ2PU3gPiVZeENFT9mEmzzSC4iUbNIU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Javed Hasan <jhasan@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 19/32] scsi: libfc: Avoid invoking response handler twice if ep is already completed
Date:   Fri,  5 Feb 2021 15:07:34 +0100
Message-Id: <20210205140653.164018254@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205140652.348864025@linuxfoundation.org>
References: <20210205140652.348864025@linuxfoundation.org>
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
index 52e8666598531..e5b18e5d46dac 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -1619,8 +1619,13 @@ static void fc_exch_recv_seq_resp(struct fc_exch_mgr *mp, struct fc_frame *fp)
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
@@ -1639,6 +1644,7 @@ static void fc_exch_recv_seq_resp(struct fc_exch_mgr *mp, struct fc_frame *fp)
 	if (!fc_invoke_resp(ep, sp, fp))
 		fc_frame_free(fp);
 
+skip_resp:
 	fc_exch_release(ep);
 	return;
 rel:
@@ -1895,10 +1901,16 @@ static void fc_exch_reset(struct fc_exch *ep)
 
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



