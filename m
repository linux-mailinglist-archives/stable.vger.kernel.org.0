Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D81815F26A
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:09:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392819AbgBNSJL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 13:09:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:33808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731412AbgBNPyG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:54:06 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 977F92465D;
        Fri, 14 Feb 2020 15:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695645;
        bh=ojdZBesU1mQCoDyStO8lDvN5/e3I9pTuYTAR3mRxsow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pjh6kO6BKofYqdQiFHxWOo/IgJqTkquR7A2KS9llwQyW/SWjAb96uqBOm+olrH9nr
         XpBr6BSL6xCxN8xu3HHQBEhCdhwrKrgHUQBMpgAEjDyvIfJnXDkbnzg141/410dHEs
         hNVT7sxvXzsnA/KMTbbSb4EHXCWV5V46W6b13RVg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Can Guo <cang@codeaurora.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Bean Huo <beanhuo@micron.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 239/542] scsi: ufs: Complete pending requests in host reset and restore path
Date:   Fri, 14 Feb 2020 10:43:51 -0500
Message-Id: <20200214154854.6746-239-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Can Guo <cang@codeaurora.org>

[ Upstream commit 2df74b6985b51e77756e2e8faa16c45ca3ba53c5 ]

In UFS host reset and restore path, before probe, we stop and start the
host controller once. After host controller is stopped, the pending
requests, if any, are cleared from the doorbell, but no completion IRQ
would be raised due to the hba is stopped.  These pending requests shall be
completed along with the first NOP_OUT command (as it is the first command
which can raise a transfer completion IRQ) sent during probe.  Since the
OCSs of these pending requests are not SUCCESS (because they are not yet
literally finished), their UPIUs shall be dumped. When there are multiple
pending requests, the UPIU dump can be overwhelming and may lead to
stability issues because it is in atomic context.  Therefore, before probe,
complete these pending requests right after host controller is stopped and
silence the UPIU dump from them.

Link: https://lore.kernel.org/r/1574751214-8321-5-git-send-email-cang@qti.qualcomm.com
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Tested-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Can Guo <cang@codeaurora.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 24 ++++++++++--------------
 drivers/scsi/ufs/ufshcd.h |  2 ++
 2 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 3fbf9ea16c64e..7d8300c9a0148 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4799,7 +4799,7 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 		break;
 	} /* end of switch */
 
-	if (host_byte(result) != DID_OK)
+	if ((host_byte(result) != DID_OK) && !hba->silence_err_logs)
 		ufshcd_print_trs(hba, 1 << lrbp->task_tag, true);
 	return result;
 }
@@ -5351,8 +5351,8 @@ static void ufshcd_err_handler(struct work_struct *work)
 
 	/*
 	 * if host reset is required then skip clearing the pending
-	 * transfers forcefully because they will automatically get
-	 * cleared after link startup.
+	 * transfers forcefully because they will get cleared during
+	 * host reset and restore
 	 */
 	if (needs_reset)
 		goto skip_pending_xfer_clear;
@@ -6282,9 +6282,15 @@ static int ufshcd_host_reset_and_restore(struct ufs_hba *hba)
 	int err;
 	unsigned long flags;
 
-	/* Reset the host controller */
+	/*
+	 * Stop the host controller and complete the requests
+	 * cleared by h/w
+	 */
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	ufshcd_hba_stop(hba, false);
+	hba->silence_err_logs = true;
+	ufshcd_complete_requests(hba);
+	hba->silence_err_logs = false;
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
 	/* scale up clocks to max frequency before full reinitialization */
@@ -6318,7 +6324,6 @@ static int ufshcd_host_reset_and_restore(struct ufs_hba *hba)
 static int ufshcd_reset_and_restore(struct ufs_hba *hba)
 {
 	int err = 0;
-	unsigned long flags;
 	int retries = MAX_HOST_RESET_RETRIES;
 
 	do {
@@ -6328,15 +6333,6 @@ static int ufshcd_reset_and_restore(struct ufs_hba *hba)
 		err = ufshcd_host_reset_and_restore(hba);
 	} while (err && --retries);
 
-	/*
-	 * After reset the door-bell might be cleared, complete
-	 * outstanding requests in s/w here.
-	 */
-	spin_lock_irqsave(hba->host->host_lock, flags);
-	ufshcd_transfer_req_compl(hba);
-	ufshcd_tmc_handler(hba);
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
-
 	return err;
 }
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 2740f6941ec69..2e59f9d8ab89e 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -513,6 +513,7 @@ struct ufs_stats {
  * @uic_error: UFS interconnect layer error status
  * @saved_err: sticky error mask
  * @saved_uic_err: sticky UIC error mask
+ * @silence_err_logs: flag to silence error logs
  * @dev_cmd: ufs device management command information
  * @last_dme_cmd_tstamp: time stamp of the last completed DME command
  * @auto_bkops_enabled: to track whether bkops is enabled in device
@@ -670,6 +671,7 @@ struct ufs_hba {
 	u32 saved_err;
 	u32 saved_uic_err;
 	struct ufs_stats ufs_stats;
+	bool silence_err_logs;
 
 	/* Device management request data */
 	struct ufs_dev_cmd dev_cmd;
-- 
2.20.1

