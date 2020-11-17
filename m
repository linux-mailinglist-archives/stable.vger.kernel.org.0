Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F5AF2B5FEF
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728500AbgKQM5G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 07:57:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:53850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728479AbgKQM5E (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 07:57:04 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 802342464E;
        Tue, 17 Nov 2020 12:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605617823;
        bh=bmntKh40Rt/hnMj496EtbyZ+MsWTcvjmdL9eQkWgf1s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k+Ezn9+SsaOH8msl9HgFsAwY37VhcqnEVfE1aiL2lVjum4O/DKdbWGA8e+kQbADDW
         fcOLusTLisAO0jIvrShHtclrvsR8R9BND7E0HY6rHWLASxobinB7YZDaas/CvIxzqO
         tmPEdwUMLzMC3+6JkrMNk5OP0nBUUufF5dgU/ZqY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.9 06/21] scsi: ufs: Try to save power mode change and UIC cmd completion timeout
Date:   Tue, 17 Nov 2020 07:56:37 -0500
Message-Id: <20201117125652.599614-6-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201117125652.599614-1-sashal@kernel.org>
References: <20201117125652.599614-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Can Guo <cang@codeaurora.org>

[ Upstream commit 0f52fcb99ea2738a0a0f28e12cf4dd427069dd2a ]

Use the uic_cmd->cmd_active as a flag to track the lifecycle of an UIC cmd.
The flag is set before sending the UIC cmd and cleared in IRQ handler. When
a PMC or UIC cmd completion timeout happens, if the flag is not set,
instead of returning timeout error, we still treat it as a successful
operation.  This is to deal with the scenario in which completion has been
raised but the one waiting for the completion cannot be awaken in time due
to kernel scheduling problem.

Link: https://lore.kernel.org/r/1604384682-15837-3-git-send-email-cang@codeaurora.org
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
Signed-off-by: Can Guo <cang@codeaurora.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 26 ++++++++++++++++++++++++--
 drivers/scsi/ufs/ufshcd.h |  2 ++
 2 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 0cb3e71f30ffb..54928a837dad0 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2100,10 +2100,20 @@ ufshcd_wait_for_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
 	unsigned long flags;
 
 	if (wait_for_completion_timeout(&uic_cmd->done,
-					msecs_to_jiffies(UIC_CMD_TIMEOUT)))
+					msecs_to_jiffies(UIC_CMD_TIMEOUT))) {
 		ret = uic_cmd->argument2 & MASK_UIC_COMMAND_RESULT;
-	else
+	} else {
 		ret = -ETIMEDOUT;
+		dev_err(hba->dev,
+			"uic cmd 0x%x with arg3 0x%x completion timeout\n",
+			uic_cmd->command, uic_cmd->argument3);
+
+		if (!uic_cmd->cmd_active) {
+			dev_err(hba->dev, "%s: UIC cmd has been completed, return the result\n",
+				__func__);
+			ret = uic_cmd->argument2 & MASK_UIC_COMMAND_RESULT;
+		}
+	}
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	hba->active_uic_cmd = NULL;
@@ -2135,6 +2145,7 @@ __ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd,
 	if (completion)
 		init_completion(&uic_cmd->done);
 
+	uic_cmd->cmd_active = 1;
 	ufshcd_dispatch_uic_cmd(hba, uic_cmd);
 
 	return 0;
@@ -3774,10 +3785,18 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
 		dev_err(hba->dev,
 			"pwr ctrl cmd 0x%x with mode 0x%x completion timeout\n",
 			cmd->command, cmd->argument3);
+
+		if (!cmd->cmd_active) {
+			dev_err(hba->dev, "%s: Power Mode Change operation has been completed, go check UPMCRS\n",
+				__func__);
+			goto check_upmcrs;
+		}
+
 		ret = -ETIMEDOUT;
 		goto out;
 	}
 
+check_upmcrs:
 	status = ufshcd_get_upmcrs(hba);
 	if (status != PWR_LOCAL) {
 		dev_err(hba->dev,
@@ -4887,11 +4906,14 @@ static irqreturn_t ufshcd_uic_cmd_compl(struct ufs_hba *hba, u32 intr_status)
 			ufshcd_get_uic_cmd_result(hba);
 		hba->active_uic_cmd->argument3 =
 			ufshcd_get_dme_attr_val(hba);
+		if (!hba->uic_async_done)
+			hba->active_uic_cmd->cmd_active = 0;
 		complete(&hba->active_uic_cmd->done);
 		retval = IRQ_HANDLED;
 	}
 
 	if ((intr_status & UFSHCD_UIC_PWR_MASK) && hba->uic_async_done) {
+		hba->active_uic_cmd->cmd_active = 0;
 		complete(hba->uic_async_done);
 		retval = IRQ_HANDLED;
 	}
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 363589c0bd370..23f46c7b8cb28 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -64,6 +64,7 @@ enum dev_cmd_type {
  * @argument1: UIC command argument 1
  * @argument2: UIC command argument 2
  * @argument3: UIC command argument 3
+ * @cmd_active: Indicate if UIC command is outstanding
  * @done: UIC command completion
  */
 struct uic_command {
@@ -71,6 +72,7 @@ struct uic_command {
 	u32 argument1;
 	u32 argument2;
 	u32 argument3;
+	int cmd_active;
 	struct completion done;
 };
 
-- 
2.27.0

