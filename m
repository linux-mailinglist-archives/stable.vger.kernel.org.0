Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B82B91332D1
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:14:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729824AbgAGVJ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:09:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:34894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729821AbgAGVJ1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:09:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68F3020678;
        Tue,  7 Jan 2020 21:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578431366;
        bh=zOlqaQpxM1m/+KIGUD2u5e/3x76nbC70RLJUYZH/7qE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zh6BkSTurgiFzVkB5z8w282wQrjSf8vk0P27uPvow1OEivz+6iwwVrsm4Y4y0gK5u
         RXmNuzZTZ22zVJg3AQK6qvOBVw8b/9Jx0rdbkMAHFK+sLYMudMPfaed1ARrB+Z6AJn
         aCKAV62Wbncg2m9hQBW1hLPBL0MAbT4elDcCNTNg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bo Wu <wubo40@huawei.com>,
        Zhiqiang Liu <liuzhiqiang26@huawei.com>,
        James Smart <james.smart@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 06/74] scsi: lpfc: Fix memory leak on lpfc_bsg_write_ebuf_set func
Date:   Tue,  7 Jan 2020 21:54:31 +0100
Message-Id: <20200107205139.736438450@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205135.369001641@linuxfoundation.org>
References: <20200107205135.369001641@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 6dde21dc82a3..08ed27b0d4c6 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -4419,12 +4419,6 @@ lpfc_bsg_write_ebuf_set(struct lpfc_hba *phba, struct bsg_job *job,
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
@@ -4461,6 +4455,13 @@ lpfc_bsg_write_ebuf_set(struct lpfc_hba *phba, struct bsg_job *job,
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
@@ -4509,6 +4510,8 @@ lpfc_bsg_write_ebuf_set(struct lpfc_hba *phba, struct bsg_job *job,
 	return SLI_CONFIG_HANDLED;
 
 job_error:
+	if (pmboxq)
+		mempool_free(pmboxq, phba->mbox_mem_pool);
 	lpfc_bsg_dma_page_free(phba, dmabuf);
 	kfree(dd_data);
 
-- 
2.20.1



