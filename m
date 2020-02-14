Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B611C15ED5E
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:33:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389065AbgBNRdh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:33:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:56842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390027AbgBNQGW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:06:22 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 479E824650;
        Fri, 14 Feb 2020 16:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696382;
        bh=SCVRKuEAGMM0bp7RoFRaC32vJKNwWSfFNJc+9Rx3xMw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TL34ghD8jrpg7JABNu1VPSUql/ah7ZuteY8fD11MXLADwqZ4WK+m5nlAx1f5Zfaj0
         P7KfBYaLA77xI0hbcWm6hj3gDrqUyO4/tF328Had3LjL2NdvIDlRD8qqB0/AC7Q2K1
         ru0XlCBF1iiVnaOD4vip4sH7HY/etWT/WZmqgv5c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chen Zhou <chenzhou10@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 209/459] scsi: ibmvscsi_tgt: remove set but not used variables 'iue' and 'sd'
Date:   Fri, 14 Feb 2020 10:57:39 -0500
Message-Id: <20200214160149.11681-209-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen Zhou <chenzhou10@huawei.com>

[ Upstream commit 4aca8fe7716669e39f7857b2e1fc5dfd4475b7e5 ]

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c: In function ibmvscsis_send_messages:
drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c:1888:19: warning: variable iue set but not used [-Wunused-but-set-variable]
drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c: In function ibmvscsis_queue_data_in:
drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c:3806:8: warning: variable sd set but not used [-Wunused-but-set-variable]

Link: https://lore.kernel.org/r/20191213064042.161840-1-chenzhou10@huawei.com
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Chen Zhou <chenzhou10@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
index a929fe76102b0..db2df02214d43 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -1877,7 +1877,6 @@ static void ibmvscsis_send_messages(struct scsi_info *vscsi)
 	 */
 	struct viosrp_crq *crq = (struct viosrp_crq *)&msg_hi;
 	struct ibmvscsis_cmd *cmd, *nxt;
-	struct iu_entry *iue;
 	long rc = ADAPT_SUCCESS;
 	bool retry = false;
 
@@ -1931,8 +1930,6 @@ static void ibmvscsis_send_messages(struct scsi_info *vscsi)
 					 */
 					vscsi->credit += 1;
 				} else {
-					iue = cmd->iue;
-
 					crq->valid = VALID_CMD_RESP_EL;
 					crq->format = cmd->rsp.format;
 
@@ -3797,7 +3794,6 @@ static int ibmvscsis_queue_data_in(struct se_cmd *se_cmd)
 						 se_cmd);
 	struct iu_entry *iue = cmd->iue;
 	struct scsi_info *vscsi = cmd->adapter;
-	char *sd;
 	uint len = 0;
 	int rc;
 
@@ -3805,7 +3801,6 @@ static int ibmvscsis_queue_data_in(struct se_cmd *se_cmd)
 			       1);
 	if (rc) {
 		dev_err(&vscsi->dev, "srp_transfer_data failed: %d\n", rc);
-		sd = se_cmd->sense_buffer;
 		se_cmd->scsi_sense_length = 18;
 		memset(se_cmd->sense_buffer, 0, se_cmd->scsi_sense_length);
 		/* Logical Unit Communication Time-out asc/ascq = 0x0801 */
-- 
2.20.1

