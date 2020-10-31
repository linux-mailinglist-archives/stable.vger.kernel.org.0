Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40DB92A1715
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:51:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727498AbgJaLuj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:50:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:40062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727557AbgJaLlG (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:41:06 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6682A20719;
        Sat, 31 Oct 2020 11:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144465;
        bh=+dV7zKMCtQeqweqoZJb+NFUfm5NUKGcJfJ2EYFpQNPM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iDA7neaQmRaA/sZD7s14lxQnko9vxYemkwkDRNfmFWW9xEDjgRbik4gPCFwI3AkS5
         uaWEiSAbv9C0UlMR7M1QaTgNALsABavtg0NQ84/HyQLdML+OsVrSmrnEg4JngvaOW0
         /ObZTC+VV9SvImnoymK3DCuiCM1+iPaphkN/W9hg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavan Chebbi <pavan.chebbi@broadcom.com>,
        Andy Gospodarek <gospo@broadcom.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.8 29/70] bnxt_en: Invoke cancel_delayed_work_sync() for PFs also.
Date:   Sat, 31 Oct 2020 12:36:01 +0100
Message-Id: <20201031113500.899120794@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201031113459.481803250@linuxfoundation.org>
References: <20201031113459.481803250@linuxfoundation.org>
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
@@ -11514,7 +11504,8 @@ static void bnxt_remove_one(struct pci_d
 	unregister_netdev(dev);
 	clear_bit(BNXT_STATE_IN_FW_RESET, &bp->state);
 	/* Flush any pending tasks */
-	bnxt_cancel_sp_work(bp);
+	cancel_work_sync(&bp->sp_task);
+	cancel_delayed_work_sync(&bp->fw_reset_task);
 	bp->sp_event = 0;
 
 	bnxt_dl_fw_reporters_destroy(bp, true);


