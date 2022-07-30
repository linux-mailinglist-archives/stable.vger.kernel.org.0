Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 302E5585AF8
	for <lists+stable@lfdr.de>; Sat, 30 Jul 2022 17:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234809AbiG3PYj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Jul 2022 11:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234460AbiG3PYi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 30 Jul 2022 11:24:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B3EE13F8D
        for <stable@vger.kernel.org>; Sat, 30 Jul 2022 08:24:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 223C360DE6
        for <stable@vger.kernel.org>; Sat, 30 Jul 2022 15:24:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A1E2C433C1;
        Sat, 30 Jul 2022 15:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659194676;
        bh=5wFsTa9L3ImgyNyTKMZJBWjUZP8NVUJjQG4p1i7KlIE=;
        h=Subject:To:Cc:From:Date:From;
        b=klNRSuHlhSunPYAfwV2YPhTdQ3OrFsdjUGlMr+zh/BQjE1AuTowfeq14geHTys3Yb
         sRsWZJmO9z0ueq2liq1nVtx7mWXGn5t6Bflz2fNE1fyhFo+r5Ugp1sp2lTf0GsVh3h
         xA6zakoter+4R5zWIeUSsOf4LZdhJK/uWtS69L/I=
Subject: FAILED: patch "[PATCH] scsi: ufs: core: Fix a race condition related to device" failed to apply to 5.15-stable tree
To:     bvanassche@acm.org, adrian.hunter@intel.com, avri.altman@wdc.com,
        beanhuo@micron.com, martin.petersen@oracle.com,
        stanley.chu@mediatek.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 30 Jul 2022 17:24:27 +0200
Message-ID: <1659194667188248@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f5c2976e0cb0f6236013bfb479868531b04f61d4 Mon Sep 17 00:00:00 2001
From: Bart Van Assche <bvanassche@acm.org>
Date: Wed, 20 Jul 2022 10:02:23 -0700
Subject: [PATCH] scsi: ufs: core: Fix a race condition related to device
 management

If a device management command completion happens after
wait_for_completion_timeout() times out and before ufshcd_clear_cmds() is
called, then the completion code may crash on the complete() call in
__ufshcd_transfer_req_compl().

Fix the following crash:

  Unable to handle kernel NULL pointer dereference at virtual address 0000000000000008
  Call trace:
   complete+0x64/0x178
   __ufshcd_transfer_req_compl+0x30c/0x9c0
   ufshcd_poll+0xf0/0x208
   ufshcd_sl_intr+0xb8/0xf0
   ufshcd_intr+0x168/0x2f4
   __handle_irq_event_percpu+0xa0/0x30c
   handle_irq_event+0x84/0x178
   handle_fasteoi_irq+0x150/0x2e8
   __handle_domain_irq+0x114/0x1e4
   gic_handle_irq.31846+0x58/0x300
   el1_irq+0xe4/0x1c0
   efi_header_end+0x110/0x680
   __irq_exit_rcu+0x108/0x124
   __handle_domain_irq+0x118/0x1e4
   gic_handle_irq.31846+0x58/0x300
   el1_irq+0xe4/0x1c0
   cpuidle_enter_state+0x3ac/0x8c4
   do_idle+0x2fc/0x55c
   cpu_startup_entry+0x84/0x90
   kernel_init+0x0/0x310
   start_kernel+0x0/0x608
   start_kernel+0x4ec/0x608

Link: https://lore.kernel.org/r/20220720170228.1598842-1-bvanassche@acm.org
Fixes: 5a0b0cb9bee7 ("[SCSI] ufs: Add support for sending NOP OUT UPIU")
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: Bean Huo <beanhuo@micron.com>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index c7b337480e3e..3d367be71728 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2953,37 +2953,59 @@ ufshcd_dev_cmd_completion(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 static int ufshcd_wait_for_dev_cmd(struct ufs_hba *hba,
 		struct ufshcd_lrb *lrbp, int max_timeout)
 {
-	int err = 0;
-	unsigned long time_left;
+	unsigned long time_left = msecs_to_jiffies(max_timeout);
 	unsigned long flags;
+	bool pending;
+	int err;
 
+retry:
 	time_left = wait_for_completion_timeout(hba->dev_cmd.complete,
-			msecs_to_jiffies(max_timeout));
+						time_left);
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
-	hba->dev_cmd.complete = NULL;
 	if (likely(time_left)) {
+		/*
+		 * The completion handler called complete() and the caller of
+		 * this function still owns the @lrbp tag so the code below does
+		 * not trigger any race conditions.
+		 */
+		hba->dev_cmd.complete = NULL;
 		err = ufshcd_get_tr_ocs(lrbp);
 		if (!err)
 			err = ufshcd_dev_cmd_completion(hba, lrbp);
-	}
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
-
-	if (!time_left) {
+	} else {
 		err = -ETIMEDOUT;
 		dev_dbg(hba->dev, "%s: dev_cmd request timedout, tag %d\n",
 			__func__, lrbp->task_tag);
-		if (!ufshcd_clear_cmds(hba, 1U << lrbp->task_tag))
+		if (ufshcd_clear_cmds(hba, 1U << lrbp->task_tag) == 0) {
 			/* successfully cleared the command, retry if needed */
 			err = -EAGAIN;
-		/*
-		 * in case of an error, after clearing the doorbell,
-		 * we also need to clear the outstanding_request
-		 * field in hba
-		 */
-		spin_lock_irqsave(&hba->outstanding_lock, flags);
-		__clear_bit(lrbp->task_tag, &hba->outstanding_reqs);
-		spin_unlock_irqrestore(&hba->outstanding_lock, flags);
+			/*
+			 * Since clearing the command succeeded we also need to
+			 * clear the task tag bit from the outstanding_reqs
+			 * variable.
+			 */
+			spin_lock_irqsave(&hba->outstanding_lock, flags);
+			pending = test_bit(lrbp->task_tag,
+					   &hba->outstanding_reqs);
+			if (pending) {
+				hba->dev_cmd.complete = NULL;
+				__clear_bit(lrbp->task_tag,
+					    &hba->outstanding_reqs);
+			}
+			spin_unlock_irqrestore(&hba->outstanding_lock, flags);
+
+			if (!pending) {
+				/*
+				 * The completion handler ran while we tried to
+				 * clear the command.
+				 */
+				time_left = 1;
+				goto retry;
+			}
+		} else {
+			dev_err(hba->dev, "%s: failed to clear tag %d\n",
+				__func__, lrbp->task_tag);
+		}
 	}
 
 	return err;

