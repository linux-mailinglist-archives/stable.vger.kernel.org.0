Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05C31127EA7
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 15:49:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727739AbfLTOs2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Dec 2019 09:48:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:46184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727832AbfLTOrs (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Dec 2019 09:47:48 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9118E222C2;
        Fri, 20 Dec 2019 14:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576853268;
        bh=qy2Hj8Jihh6UUPtMjnlHVDEeTiIdr5Obn/PPl+H6i/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fr8j3kdl+4aqEcqzggcUClG8DxDa4f/b6TgfoKOfmz9tbVGbXz/IO50xTT+6/TF7b
         tHh1P2FMphWaRo//Axs6/ovffAR8wrc36WTag9o5gvNubXAOtTbjzKXrdEnuXfKdUl
         bmN6ZbRfudmN1SobLYsKs79JRKIHamoSN5Y4Ae7k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bo Wu <wubo40@huawei.com>, Zhiqiang Liu <liuzhiqiang26@huawei.com>,
        James Smart <james.smart@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 03/11] scsi: lpfc: Fix memory leak on lpfc_bsg_write_ebuf_set func
Date:   Fri, 20 Dec 2019 09:47:35 -0500
Message-Id: <20191220144744.10565-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191220144744.10565-1-sashal@kernel.org>
References: <20191220144744.10565-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bo Wu <wubo40@huawei.com>

[ Upstream commit 9a1b0b9a6dab452fb0e39fe96880c4faf3878369 ]

When phba->mbox_ext_buf_ctx.seqNum != phba->mbox_ext_buf_ctx.numBuf,
dd_data should be freed before return SLI_CONFIG_HANDLED.

When lpfc_sli_issue_mbox func return fails, pmboxq should be also freed in
job_error tag.

Link: https://lore.kernel.org/r/EDBAAA0BBBA2AC4E9C8B6B81DEEE1D6915E7A966@DGGEML525-MBS.china.huawei.com
Signed-off-by: Bo Wu <wubo40@huawei.com>
Reviewed-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Reviewed-by: James Smart <james.smart@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_bsg.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 05dcc2abd541a..99f06ac7bf4c5 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -4352,12 +4352,6 @@ lpfc_bsg_write_ebuf_set(struct lpfc_hba *phba, struct fc_bsg_job *job,
 	phba->mbox_ext_buf_ctx.seqNum++;
 	nemb_tp = phba->mbox_ext_buf_ctx.nembType;
 
-	dd_data = kmalloc(sizeof(struct bsg_job_data), GFP_KERNEL);
-	if (!dd_data) {
-		rc = -ENOMEM;
-		goto job_error;
-	}
-
 	pbuf = (uint8_t *)dmabuf->virt;
 	size = job->request_payload.payload_len;
 	sg_copy_to_buffer(job->request_payload.sg_list,
@@ -4394,6 +4388,13 @@ lpfc_bsg_write_ebuf_set(struct lpfc_hba *phba, struct fc_bsg_job *job,
 				"2968 SLI_CONFIG ext-buffer wr all %d "
 				"ebuffers received\n",
 				phba->mbox_ext_buf_ctx.numBuf);
+
+		dd_data = kmalloc(sizeof(struct bsg_job_data), GFP_KERNEL);
+		if (!dd_data) {
+			rc = -ENOMEM;
+			goto job_error;
+		}
+
 		/* mailbox command structure for base driver */
 		pmboxq = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 		if (!pmboxq) {
@@ -4441,6 +4442,8 @@ lpfc_bsg_write_ebuf_set(struct lpfc_hba *phba, struct fc_bsg_job *job,
 	return SLI_CONFIG_HANDLED;
 
 job_error:
+	if (pmboxq)
+		mempool_free(pmboxq, phba->mbox_mem_pool);
 	lpfc_bsg_dma_page_free(phba, dmabuf);
 	kfree(dd_data);
 
-- 
2.20.1

