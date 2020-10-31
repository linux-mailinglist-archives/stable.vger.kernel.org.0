Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C38D32A169F
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:47:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727687AbgJaLr0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:47:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:46560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727880AbgJaLpd (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:45:33 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7FC720739;
        Sat, 31 Oct 2020 11:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144731;
        bh=peeePRJgods2PYQpXPOoJBI7mDwCAABd2hYXp4gqP9s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UolZ1eYmOM+3gZ1efT+rXVKqRi5MyssTu61AzsUG/tszdDxh2uNCtvPjT6GuZ+R/6
         03Yj0Qz1Ds6mGPNjDhHwOp20TC//rE01eaOqFcypDpMTo8l4YdwN16sIDunW5roMMw
         tJKCQchS3Md7he3Gs2R4+oFSDyBt8Gv3c5xh/w0Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavan Chebbi <pavan.chebbi@broadcom.com>,
        Andy Gospodarek <gospo@broadcom.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 29/74] bnxt_en: Invoke cancel_delayed_work_sync() for PFs also.
Date:   Sat, 31 Oct 2020 12:36:11 +0100
Message-Id: <20201031113501.440846400@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201031113500.031279088@linuxfoundation.org>
References: <20201031113500.031279088@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

[ Upstream commit 631ce27a3006fc0b732bfd589c6df505f62eadd9 ]

As part of the commit b148bb238c02
("bnxt_en: Fix possible crash in bnxt_fw_reset_task()."),
cancel_delayed_work_sync() is called only for VFs to fix a possible
crash by cancelling any pending delayed work items. It was assumed
by mistake that the flush_workqueue() call on the PF would flush
delayed work items as well.

As flush_workqueue() does not cancel the delayed workqueue, extend
the fix for PFs. This fix will avoid the system crash, if there are
any pending delayed work items in fw_reset_task() during driver's
.remove() call.

Unify the workqueue cleanup logic for both PF and VF by calling
cancel_work_sync() and cancel_delayed_work_sync() directly in
bnxt_remove_one().

Fixes: b148bb238c02 ("bnxt_en: Fix possible crash in bnxt_fw_reset_task().")
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Reviewed-by: Andy Gospodarek <gospo@broadcom.com>
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -1158,16 +1158,6 @@ static void bnxt_queue_sp_work(struct bn
 		schedule_work(&bp->sp_task);
 }
 
-static void bnxt_cancel_sp_work(struct bnxt *bp)
-{
-	if (BNXT_PF(bp)) {
-		flush_workqueue(bnxt_pf_wq);
-	} else {
-		cancel_work_sync(&bp->sp_task);
-		cancel_delayed_work_sync(&bp->fw_reset_task);
-	}
-}
-
 static void bnxt_sched_reset(struct bnxt *bp, struct bnxt_rx_ring_info *rxr)
 {
 	if (!rxr->bnapi->in_reset) {
@@ -11796,7 +11786,8 @@ static void bnxt_remove_one(struct pci_d
 	unregister_netdev(dev);
 	clear_bit(BNXT_STATE_IN_FW_RESET, &bp->state);
 	/* Flush any pending tasks */
-	bnxt_cancel_sp_work(bp);
+	cancel_work_sync(&bp->sp_task);
+	cancel_delayed_work_sync(&bp->fw_reset_task);
 	bp->sp_event = 0;
 
 	bnxt_dl_fw_reporters_destroy(bp, true);


