Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED3F040E5DF
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:28:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343623AbhIPRQH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:16:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:39748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345753AbhIPRN5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:13:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F68C619F9;
        Thu, 16 Sep 2021 16:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810355;
        bh=BUF7raAQO+4V6Z6SCUlfWa4jccsBKMbfkXwnEgJ9NbE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HHBeeOY8ZuusODljQQB0NJLNTGYNsm5WxPcvIAjfH2UQhezPVeKoXZ3rlFgiEXtW5
         405x+iogIMhR6kP4FO1eSK2vltEqUWq1y5ivGFB9fY87RnsecQoEMlnxNnvyqaFaYx
         Fe/y+PaFeHyiPgXZRyY/PyHGgWCwuOQ0jKBeJtxE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 093/432] scsi: ufs: Fix the SCSI abort handler
Date:   Thu, 16 Sep 2021 17:57:22 +0200
Message-Id: <20210916155813.935249339@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 64180742605f772d511903c9e50262afb13726c6 ]

Make the following changes in ufshcd_abort():

 - Return FAILED instead of SUCCESS if the abort handler notices that a
   SCSI command has already been completed. Returning SUCCESS in this case
   triggers a use-after-free and may trigger a kernel crash.

 - Fix the code for aborting SCSI commands submitted to a WLUN.

The current approach for aborting SCSI commands that have been submitted to
a WLUN and that timed out is as follows:

 - Report to the SCSI core that the command has completed successfully.
   Let the block layer free any data buffers associated with the command.

 - Mark the command as outstanding in 'outstanding_reqs'.

 - If the block layer tries to reuse the tag associated with the aborted
   command, busy-wait until the tag is freed.

This approach can result in:

 - Memory corruption if the controller accesses the data buffer after the
   block layer has freed the associated data buffers.

 - A race condition if ufshcd_queuecommand() or ufshcd_exec_dev_cmd()
   checks the bit that corresponds to an aborted command in
   'outstanding_reqs' after it has been cleared and before it is reset.

 - High energy consumption if ufshcd_queuecommand() repeatedly returns
   SCSI_MLQUEUE_HOST_BUSY.

Fix this by reporting to the SCSI error handler that aborting a SCSI
command failed if the SCSI command was submitted to a WLUN.

Link: https://lore.kernel.org/r/20210722033439.26550-15-bvanassche@acm.org
Fixes: 7a7e66c65d41 ("scsi: ufs: Fix a race condition between ufshcd_abort() and eh_work()")
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Can Guo <cang@codeaurora.org>
Cc: Asutosh Das <asutoshd@codeaurora.org>
Cc: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 54 ++++++++++++++-------------------------
 1 file changed, 19 insertions(+), 35 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 0fe559ddc789..1708d7ced527 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2766,15 +2766,6 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	WARN_ON(ufshcd_is_clkgating_allowed(hba) &&
 		(hba->clk_gating.state != CLKS_ON));
 
-	if (unlikely(test_bit(tag, &hba->outstanding_reqs))) {
-		if (hba->pm_op_in_progress)
-			set_host_byte(cmd, DID_BAD_TARGET);
-		else
-			err = SCSI_MLQUEUE_HOST_BUSY;
-		ufshcd_release(hba);
-		goto out;
-	}
-
 	lrbp = &hba->lrb[tag];
 	WARN_ON(lrbp->cmd);
 	lrbp->cmd = cmd;
@@ -2973,11 +2964,6 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 	req->timeout = msecs_to_jiffies(2 * timeout);
 	blk_mq_start_request(req);
 
-	if (unlikely(test_bit(tag, &hba->outstanding_reqs))) {
-		err = -EBUSY;
-		goto out;
-	}
-
 	lrbp = &hba->lrb[tag];
 	WARN_ON(lrbp->cmd);
 	err = ufshcd_compose_dev_cmd(hba, lrbp, cmd_type, tag);
@@ -6984,7 +6970,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 	struct ufs_hba *hba;
 	unsigned long flags;
 	unsigned int tag;
-	int err = 0;
+	int err = FAILED;
 	struct ufshcd_lrb *lrbp;
 	u32 reg;
 
@@ -7001,12 +6987,12 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 
 	ufshcd_hold(hba, false);
 	reg = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
-	/* If command is already aborted/completed, return SUCCESS */
+	/* If command is already aborted/completed, return FAILED. */
 	if (!(test_bit(tag, &hba->outstanding_reqs))) {
 		dev_err(hba->dev,
 			"%s: cmd at tag %d already completed, outstanding=0x%lx, doorbell=0x%x\n",
 			__func__, tag, hba->outstanding_reqs, reg);
-		goto out;
+		goto release;
 	}
 
 	/* Print Transfer Request of aborted task */
@@ -7035,7 +7021,8 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 		dev_err(hba->dev,
 		"%s: cmd was completed, but without a notifying intr, tag = %d",
 		__func__, tag);
-		goto cleanup;
+		__ufshcd_transfer_req_compl(hba, 1UL << tag);
+		goto release;
 	}
 
 	/*
@@ -7048,36 +7035,33 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 	 */
 	if (lrbp->lun == UFS_UPIU_UFS_DEVICE_WLUN) {
 		ufshcd_update_evt_hist(hba, UFS_EVT_ABORT, lrbp->lun);
-		__ufshcd_transfer_req_compl(hba, (1UL << tag));
-		set_bit(tag, &hba->outstanding_reqs);
+
 		spin_lock_irqsave(host->host_lock, flags);
 		hba->force_reset = true;
 		ufshcd_schedule_eh_work(hba);
 		spin_unlock_irqrestore(host->host_lock, flags);
-		goto out;
+		goto release;
 	}
 
 	/* Skip task abort in case previous aborts failed and report failure */
-	if (lrbp->req_abort_skip)
-		err = -EIO;
-	else
-		err = ufshcd_try_to_abort_task(hba, tag);
+	if (lrbp->req_abort_skip) {
+		dev_err(hba->dev, "%s: skipping abort\n", __func__);
+		ufshcd_set_req_abort_skip(hba, hba->outstanding_reqs);
+		goto release;
+	}
 
-	if (!err) {
-cleanup:
-		__ufshcd_transfer_req_compl(hba, (1UL << tag));
-out:
-		err = SUCCESS;
-	} else {
+	err = ufshcd_try_to_abort_task(hba, tag);
+	if (err) {
 		dev_err(hba->dev, "%s: failed with err %d\n", __func__, err);
 		ufshcd_set_req_abort_skip(hba, hba->outstanding_reqs);
 		err = FAILED;
+		goto release;
 	}
 
-	/*
-	 * This ufshcd_release() corresponds to the original scsi cmd that got
-	 * aborted here (as we won't get any IRQ for it).
-	 */
+	err = SUCCESS;
+
+release:
+	/* Matches the ufshcd_hold() call at the start of this function. */
 	ufshcd_release(hba);
 	return err;
 }
-- 
2.30.2



