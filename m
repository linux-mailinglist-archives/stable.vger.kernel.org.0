Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84284137CE3
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 10:51:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728828AbgAKJvR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 04:51:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:34442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728775AbgAKJvQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 04:51:16 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 38B1B2077C;
        Sat, 11 Jan 2020 09:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578736276;
        bh=5CE1USnu71Hv/oNenolRQ2uFdyAosDuhmJcQ/fMjlq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B6jXG/3v1gcJA8Xzeuq9YxZoWY89+bYh7EnCCTKrV6ogot0libW8V5dE9R8cIcP68
         Udl0xkA3dnxhuVz41nRLPZRO+GWFYIxvPXI9c+iXFuZICYARyqzZI9EXe2s62nCil+
         aG2fglsW6q3KXHXzCVenSAkLPMEZfnoiH2Oxst18=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bo Wu <wubo40@huawei.com>,
        Zhiqiang Liu <liuzhiqiang26@huawei.com>,
        James Smart <james.smart@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 03/59] scsi: lpfc: Fix memory leak on lpfc_bsg_write_ebuf_set func
Date:   Sat, 11 Jan 2020 10:49:12 +0100
Message-Id: <20200111094836.826166568@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094835.417654274@linuxfoundation.org>
References: <20200111094835.417654274@linuxfoundation.org>
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
index 05dcc2abd541..99f06ac7bf4c 100644
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



