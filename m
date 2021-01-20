Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 242D82FC97E
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 04:54:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729880AbhATC23 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 21:28:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:46630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729490AbhATB1f (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Jan 2021 20:27:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D534F23110;
        Wed, 20 Jan 2021 01:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611105976;
        bh=HL1b2C8yQOXcrkbm6rJdKvoCYwKhA7Bn9EFf9ewElnQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lDNLr2mfI7yyHJRC+BtPr2VnkgvDUnETBcoeHbxVm/DJVUeVdOPyQ4dikZLRnAIWw
         +eb1r90ZupUZZR2kxY+EEvHYO8CvytCx+pBLrbrn6aYhYwvnYk4GF+B9iPP4lyQguE
         8adJTWg13/3M6RNYtUyR65zXh8q37CMD10PjLrD6S9ctiU3Kcd1K8+ou1dKgQSfAjF
         YOV0Rr4OaWkf6pk6d1RaxCL/sIAAhJQN377L2dGy5lS4u5kCjwOj5kc+0LMhWOg2Bz
         XWETqW1nYP0MG+ufMaaSCDT3PBDyn+a+urSvoVXCma/eJxUlu8QL0/6AynzwO/mrXq
         ZLVfD3Mq6M8CQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Can Guo <cang@codeaurora.org>, Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 10/45] scsi: ufs: Correct the LUN used in eh_device_reset_handler() callback
Date:   Tue, 19 Jan 2021 20:25:27 -0500
Message-Id: <20210120012602.769683-10-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210120012602.769683-1-sashal@kernel.org>
References: <20210120012602.769683-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Can Guo <cang@codeaurora.org>

[ Upstream commit 35fc4cd34426c242ab015ef280853b7bff101f48 ]

Users can initiate resets to specific SCSI device/target/host through
IOCTL. When this happens, the SCSI cmd passed to eh_device/target/host
_reset_handler() callbacks is initialized with a request whose tag is -1.
In this case it is not right for eh_device_reset_handler() callback to
count on the LUN get from hba->lrb[-1]. Fix it by getting LUN from the SCSI
device associated with the SCSI cmd.

Link: https://lore.kernel.org/r/1609157080-26283-1-git-send-email-cang@codeaurora.org
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
Signed-off-by: Can Guo <cang@codeaurora.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index cc0aebf54b079..a90127488ed20 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6567,19 +6567,16 @@ static int ufshcd_eh_device_reset_handler(struct scsi_cmnd *cmd)
 {
 	struct Scsi_Host *host;
 	struct ufs_hba *hba;
-	unsigned int tag;
 	u32 pos;
 	int err;
-	u8 resp = 0xF;
-	struct ufshcd_lrb *lrbp;
+	u8 resp = 0xF, lun;
 	unsigned long flags;
 
 	host = cmd->device->host;
 	hba = shost_priv(host);
-	tag = cmd->request->tag;
 
-	lrbp = &hba->lrb[tag];
-	err = ufshcd_issue_tm_cmd(hba, lrbp->lun, 0, UFS_LOGICAL_RESET, &resp);
+	lun = ufshcd_scsi_to_upiu_lun(cmd->device->lun);
+	err = ufshcd_issue_tm_cmd(hba, lun, 0, UFS_LOGICAL_RESET, &resp);
 	if (err || resp != UPIU_TASK_MANAGEMENT_FUNC_COMPL) {
 		if (!err)
 			err = resp;
@@ -6588,7 +6585,7 @@ static int ufshcd_eh_device_reset_handler(struct scsi_cmnd *cmd)
 
 	/* clear the commands that were pending for corresponding LUN */
 	for_each_set_bit(pos, &hba->outstanding_reqs, hba->nutrs) {
-		if (hba->lrb[pos].lun == lrbp->lun) {
+		if (hba->lrb[pos].lun == lun) {
 			err = ufshcd_clear_cmd(hba, pos);
 			if (err)
 				break;
-- 
2.27.0

