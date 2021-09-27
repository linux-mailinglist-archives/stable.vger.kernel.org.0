Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32FEE419C2F
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236142AbhI0R0H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:26:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:40728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237985AbhI0RYI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:24:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 672E261401;
        Mon, 27 Sep 2021 17:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762928;
        bh=Z24D2o8RlHaR6Pf0WtQdmzY7dXJCcmwdGPXOfY/48D8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IWl/2w9aT93Ickl0waJef7nlISJ/NXsx0F/mUL+ghrWFcXHEjQj7She7zpV3CTt76
         u4P7ziwoxbQfPGLjtuqYAqUn4ZlBelUHE/SMzwUlIov2CL60SyX1SWlztXjUUFxnSB
         /yaQZxGsi0TRTdnbfSb0injZ4sFgPVIUkPUwZ6FA=
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
Subject: [PATCH 5.14 104/162] scsi: ufs: Retry aborted SCSI commands instead of completing these successfully
Date:   Mon, 27 Sep 2021 19:02:30 +0200
Message-Id: <20210927170237.041057258@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 73dc3c4ac703c6fea4b40e8ed1ddd80564da3dea ]

Neither SAM nor the UFS standard require that the UFS controller fills in
the completion status of commands that have been aborted (LUN RESET aborts
pending commands). Hence do not rely on the completion status provided by
the UFS controller for aborted commands but instead ask the SCSI core to
retry SCSI commands that have been aborted.

Link: https://lore.kernel.org/r/20210722033439.26550-18-bvanassche@acm.org
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
 drivers/scsi/ufs/ufshcd.c | 35 +++++++++++++++++++++++------------
 1 file changed, 23 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index b43abba84a6f..a858e7d998a6 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5229,10 +5229,12 @@ static irqreturn_t ufshcd_uic_cmd_compl(struct ufs_hba *hba, u32 intr_status)
 /**
  * __ufshcd_transfer_req_compl - handle SCSI and query command completion
  * @hba: per adapter instance
- * @completed_reqs: requests to complete
+ * @completed_reqs: bitmask that indicates which requests to complete
+ * @retry_requests: whether to ask the SCSI core to retry completed requests
  */
 static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
-					unsigned long completed_reqs)
+					unsigned long completed_reqs,
+					bool retry_requests)
 {
 	struct ufshcd_lrb *lrbp;
 	struct scsi_cmnd *cmd;
@@ -5250,7 +5252,8 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
 			if (unlikely(ufshcd_should_inform_monitor(hba, lrbp)))
 				ufshcd_update_monitor(hba, lrbp);
 			ufshcd_add_command_trace(hba, index, UFS_CMD_COMP);
-			result = ufshcd_transfer_rsp_status(hba, lrbp);
+			result = retry_requests ? DID_BUS_BUSY << 16 :
+				ufshcd_transfer_rsp_status(hba, lrbp);
 			scsi_dma_unmap(cmd);
 			cmd->result = result;
 			/* Mark completed command as NULL in LRB */
@@ -5276,12 +5279,14 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
 /**
  * ufshcd_transfer_req_compl - handle SCSI and query command completion
  * @hba: per adapter instance
+ * @retry_requests: whether or not to ask to retry requests
  *
  * Returns
  *  IRQ_HANDLED - If interrupt is valid
  *  IRQ_NONE    - If invalid interrupt
  */
-static irqreturn_t ufshcd_transfer_req_compl(struct ufs_hba *hba)
+static irqreturn_t ufshcd_transfer_req_compl(struct ufs_hba *hba,
+					     bool retry_requests)
 {
 	unsigned long completed_reqs, flags;
 	u32 tr_doorbell;
@@ -5303,7 +5308,8 @@ static irqreturn_t ufshcd_transfer_req_compl(struct ufs_hba *hba)
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
 	if (completed_reqs) {
-		__ufshcd_transfer_req_compl(hba, completed_reqs);
+		__ufshcd_transfer_req_compl(hba, completed_reqs,
+					    retry_requests);
 		return IRQ_HANDLED;
 	} else {
 		return IRQ_NONE;
@@ -5782,7 +5788,13 @@ out:
 /* Complete requests that have door-bell cleared */
 static void ufshcd_complete_requests(struct ufs_hba *hba)
 {
-	ufshcd_transfer_req_compl(hba);
+	ufshcd_transfer_req_compl(hba, /*retry_requests=*/false);
+	ufshcd_tmc_handler(hba);
+}
+
+static void ufshcd_retry_aborted_requests(struct ufs_hba *hba)
+{
+	ufshcd_transfer_req_compl(hba, /*retry_requests=*/true);
 	ufshcd_tmc_handler(hba);
 }
 
@@ -6124,8 +6136,7 @@ static void ufshcd_err_handler(struct work_struct *work)
 	}
 
 lock_skip_pending_xfer_clear:
-	/* Complete the requests that are cleared by s/w */
-	ufshcd_complete_requests(hba);
+	ufshcd_retry_aborted_requests(hba);
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	hba->silence_err_logs = false;
@@ -6423,7 +6434,7 @@ static irqreturn_t ufshcd_sl_intr(struct ufs_hba *hba, u32 intr_status)
 		retval |= ufshcd_tmc_handler(hba);
 
 	if (intr_status & UTP_TRANSFER_REQ_COMPL)
-		retval |= ufshcd_transfer_req_compl(hba);
+		retval |= ufshcd_transfer_req_compl(hba, /*retry_requests=*/false);
 
 	return retval;
 }
@@ -6847,7 +6858,7 @@ static int ufshcd_eh_device_reset_handler(struct scsi_cmnd *cmd)
 			err = ufshcd_clear_cmd(hba, pos);
 			if (err)
 				break;
-			__ufshcd_transfer_req_compl(hba, pos);
+			__ufshcd_transfer_req_compl(hba, pos, /*retry_requests=*/true);
 		}
 	}
 
@@ -7018,7 +7029,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 		dev_err(hba->dev,
 		"%s: cmd was completed, but without a notifying intr, tag = %d",
 		__func__, tag);
-		__ufshcd_transfer_req_compl(hba, 1UL << tag);
+		__ufshcd_transfer_req_compl(hba, 1UL << tag, /*retry_requests=*/false);
 		goto release;
 	}
 
@@ -7083,7 +7094,7 @@ static int ufshcd_host_reset_and_restore(struct ufs_hba *hba)
 	 */
 	ufshcd_hba_stop(hba);
 	hba->silence_err_logs = true;
-	ufshcd_complete_requests(hba);
+	ufshcd_retry_aborted_requests(hba);
 	hba->silence_err_logs = false;
 
 	/* scale up clocks to max frequency before full reinitialization */
-- 
2.33.0



