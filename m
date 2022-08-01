Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E1A7586A72
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 14:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234376AbiHAMQh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 08:16:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234600AbiHAMQJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 08:16:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 380657CB4D;
        Mon,  1 Aug 2022 04:58:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D3CB3B80E8F;
        Mon,  1 Aug 2022 11:58:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 305C0C433D6;
        Mon,  1 Aug 2022 11:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659355121;
        bh=t9K1ljGtuwOhs5uxy8grAgH4UHD7p6dHciwG8jNTmFI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BvMls7l8Yi7ZdhgeXDh1QLRESjxIqdGuvsW3M1oqv/D7450DkPfi5Z/sYhbJ48rfh
         qacb2/4yYZP87TJTGxYZEpELfutAjuLycAQVrhvA+ZPPMPt45N/wX39EGAXcngD1PK
         mCSUXPucDpF/IgLFtFT3TGRABZYBXbvF4RkJrl/M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 71/88] scsi: ufs: core: Fix a race condition related to device management
Date:   Mon,  1 Aug 2022 13:47:25 +0200
Message-Id: <20220801114141.269290284@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114138.041018499@linuxfoundation.org>
References: <20220801114138.041018499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit f5c2976e0cb0f6236013bfb479868531b04f61d4 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 58 +++++++++++++++++++++++++++------------
 1 file changed, 40 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index a34c1fab0246..874490f7f5e7 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2947,37 +2947,59 @@ ufshcd_dev_cmd_completion(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
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
-- 
2.35.1



