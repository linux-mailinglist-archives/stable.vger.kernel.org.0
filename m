Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA7FD378474
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233188AbhEJKwL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:52:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:42240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233710AbhEJKuc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:50:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E39086162E;
        Mon, 10 May 2021 10:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643190;
        bh=wiEdH3EZ6Vc4WMLn5eAVRjArDaihvoWf2OeQJOffwUg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oQOAdPwOCTAhtmvXh25mFETmGJscf9Y2V2fB+NeDmHwXL3L1W5+2lljgHCSsFA4bB
         GVsQHlkyJUcA20pPnHJYZp+MX8hFkzw4G1Q/QP5VFvg7V3+DtVGRj2nVCUkNCLa+dY
         yvdX+KckSJy6Acs14+Hif1tz+d65NV23kO8tHdhM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Justin Tee <justin.tee@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 197/299] scsi: lpfc: Fix error handling for mailboxes completed in MBX_POLL mode
Date:   Mon, 10 May 2021 12:19:54 +0200
Message-Id: <20210510102011.457411572@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit 304ee43238fed517faa123e034b593905b8679f8 ]

In SLI-4, when performing a mailbox command with MBX_POLL, the driver uses
the BMBX register to send the command rather than the MQ. A flag is set
indicating the BMBX register is active and saves the mailbox job struct
(mboxq) in the mbox_active element of the adapter. The routine then waits
for completion or timeout. The mailbox job struct is not freed by the
routine. In cases of timeout, the adapter will be reset. The
lpfc_sli_mbox_sys_flush() routine will clean up the mbox in preparation for
the reset. It clears the BMBX active flag and marks the job structure as
MBX_NOT_FINISHED. But, it never frees the mboxq job structure. Expectation
in both normal completion and timeout cases is that the issuer of the mbx
command will free the structure.  Unfortunately, not all calling paths are
freeing the memory in cases of error.

All calling paths were looked at and updated, if missing, to free the mboxq
memory regardless of completion status.

Link: https://lore.kernel.org/r/20210412013127.2387-7-jsmart2021@gmail.com
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_attr.c | 75 +++++++++++++++++++++--------------
 drivers/scsi/lpfc/lpfc_init.c |  9 ++---
 drivers/scsi/lpfc/lpfc_sli.c  | 42 ++++++++++----------
 3 files changed, 70 insertions(+), 56 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index e94eac194676..bdea2867516c 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -1690,8 +1690,7 @@ lpfc_set_trunking(struct lpfc_hba *phba, char *buff_out)
 		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX,
 				"0071 Set trunk mode failed with status: %d",
 				rc);
-	if (rc != MBX_TIMEOUT)
-		mempool_free(mbox, phba->mbox_mem_pool);
+	mempool_free(mbox, phba->mbox_mem_pool);
 
 	return 0;
 }
@@ -6780,15 +6779,19 @@ lpfc_get_stats(struct Scsi_Host *shost)
 	pmboxq->ctx_buf = NULL;
 	pmboxq->vport = vport;
 
-	if (vport->fc_flag & FC_OFFLINE_MODE)
+	if (vport->fc_flag & FC_OFFLINE_MODE) {
 		rc = lpfc_sli_issue_mbox(phba, pmboxq, MBX_POLL);
-	else
-		rc = lpfc_sli_issue_mbox_wait(phba, pmboxq, phba->fc_ratov * 2);
-
-	if (rc != MBX_SUCCESS) {
-		if (rc != MBX_TIMEOUT)
+		if (rc != MBX_SUCCESS) {
 			mempool_free(pmboxq, phba->mbox_mem_pool);
-		return NULL;
+			return NULL;
+		}
+	} else {
+		rc = lpfc_sli_issue_mbox_wait(phba, pmboxq, phba->fc_ratov * 2);
+		if (rc != MBX_SUCCESS) {
+			if (rc != MBX_TIMEOUT)
+				mempool_free(pmboxq, phba->mbox_mem_pool);
+			return NULL;
+		}
 	}
 
 	memset(hs, 0, sizeof (struct fc_host_statistics));
@@ -6812,15 +6815,19 @@ lpfc_get_stats(struct Scsi_Host *shost)
 	pmboxq->ctx_buf = NULL;
 	pmboxq->vport = vport;
 
-	if (vport->fc_flag & FC_OFFLINE_MODE)
+	if (vport->fc_flag & FC_OFFLINE_MODE) {
 		rc = lpfc_sli_issue_mbox(phba, pmboxq, MBX_POLL);
-	else
-		rc = lpfc_sli_issue_mbox_wait(phba, pmboxq, phba->fc_ratov * 2);
-
-	if (rc != MBX_SUCCESS) {
-		if (rc != MBX_TIMEOUT)
+		if (rc != MBX_SUCCESS) {
 			mempool_free(pmboxq, phba->mbox_mem_pool);
-		return NULL;
+			return NULL;
+		}
+	} else {
+		rc = lpfc_sli_issue_mbox_wait(phba, pmboxq, phba->fc_ratov * 2);
+		if (rc != MBX_SUCCESS) {
+			if (rc != MBX_TIMEOUT)
+				mempool_free(pmboxq, phba->mbox_mem_pool);
+			return NULL;
+		}
 	}
 
 	hs->link_failure_count = pmb->un.varRdLnk.linkFailureCnt;
@@ -6893,15 +6900,19 @@ lpfc_reset_stats(struct Scsi_Host *shost)
 	pmboxq->vport = vport;
 
 	if ((vport->fc_flag & FC_OFFLINE_MODE) ||
-		(!(psli->sli_flag & LPFC_SLI_ACTIVE)))
+		(!(psli->sli_flag & LPFC_SLI_ACTIVE))) {
 		rc = lpfc_sli_issue_mbox(phba, pmboxq, MBX_POLL);
-	else
-		rc = lpfc_sli_issue_mbox_wait(phba, pmboxq, phba->fc_ratov * 2);
-
-	if (rc != MBX_SUCCESS) {
-		if (rc != MBX_TIMEOUT)
+		if (rc != MBX_SUCCESS) {
 			mempool_free(pmboxq, phba->mbox_mem_pool);
-		return;
+			return;
+		}
+	} else {
+		rc = lpfc_sli_issue_mbox_wait(phba, pmboxq, phba->fc_ratov * 2);
+		if (rc != MBX_SUCCESS) {
+			if (rc != MBX_TIMEOUT)
+				mempool_free(pmboxq, phba->mbox_mem_pool);
+			return;
+		}
 	}
 
 	memset(pmboxq, 0, sizeof(LPFC_MBOXQ_t));
@@ -6911,15 +6922,19 @@ lpfc_reset_stats(struct Scsi_Host *shost)
 	pmboxq->vport = vport;
 
 	if ((vport->fc_flag & FC_OFFLINE_MODE) ||
-	    (!(psli->sli_flag & LPFC_SLI_ACTIVE)))
+	    (!(psli->sli_flag & LPFC_SLI_ACTIVE))) {
 		rc = lpfc_sli_issue_mbox(phba, pmboxq, MBX_POLL);
-	else
+		if (rc != MBX_SUCCESS) {
+			mempool_free(pmboxq, phba->mbox_mem_pool);
+			return;
+		}
+	} else {
 		rc = lpfc_sli_issue_mbox_wait(phba, pmboxq, phba->fc_ratov * 2);
-
-	if (rc != MBX_SUCCESS) {
-		if (rc != MBX_TIMEOUT)
-			mempool_free( pmboxq, phba->mbox_mem_pool);
-		return;
+		if (rc != MBX_SUCCESS) {
+			if (rc != MBX_TIMEOUT)
+				mempool_free(pmboxq, phba->mbox_mem_pool);
+			return;
+		}
 	}
 
 	lso->link_failure_count = pmb->un.varRdLnk.linkFailureCnt;
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 40fe889033d4..b17a75216964 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -9636,8 +9636,7 @@ lpfc_sli4_queue_setup(struct lpfc_hba *phba)
 				"3250 QUERY_FW_CFG mailbox failed with status "
 				"x%x add_status x%x, mbx status x%x\n",
 				shdr_status, shdr_add_status, rc);
-		if (rc != MBX_TIMEOUT)
-			mempool_free(mboxq, phba->mbox_mem_pool);
+		mempool_free(mboxq, phba->mbox_mem_pool);
 		rc = -ENXIO;
 		goto out_error;
 	}
@@ -9653,8 +9652,7 @@ lpfc_sli4_queue_setup(struct lpfc_hba *phba)
 			"ulp1_mode:x%x\n", phba->sli4_hba.fw_func_mode,
 			phba->sli4_hba.ulp0_mode, phba->sli4_hba.ulp1_mode);
 
-	if (rc != MBX_TIMEOUT)
-		mempool_free(mboxq, phba->mbox_mem_pool);
+	mempool_free(mboxq, phba->mbox_mem_pool);
 
 	/*
 	 * Set up HBA Event Queues (EQs)
@@ -10252,8 +10250,7 @@ lpfc_pci_function_reset(struct lpfc_hba *phba)
 		shdr_status = bf_get(lpfc_mbox_hdr_status, &shdr->response);
 		shdr_add_status = bf_get(lpfc_mbox_hdr_add_status,
 					 &shdr->response);
-		if (rc != MBX_TIMEOUT)
-			mempool_free(mboxq, phba->mbox_mem_pool);
+		mempool_free(mboxq, phba->mbox_mem_pool);
 		if (shdr_status || shdr_add_status || rc) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
 					"0495 SLI_FUNCTION_RESET mailbox "
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 5841d2523549..3e5c0718555a 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -5546,12 +5546,10 @@ lpfc_sli4_get_ctl_attr(struct lpfc_hba *phba)
 			phba->sli4_hba.lnk_info.lnk_no,
 			phba->BIOSVersion);
 out_free_mboxq:
-	if (rc != MBX_TIMEOUT) {
-		if (bf_get(lpfc_mqe_command, &mboxq->u.mqe) == MBX_SLI4_CONFIG)
-			lpfc_sli4_mbox_cmd_free(phba, mboxq);
-		else
-			mempool_free(mboxq, phba->mbox_mem_pool);
-	}
+	if (bf_get(lpfc_mqe_command, &mboxq->u.mqe) == MBX_SLI4_CONFIG)
+		lpfc_sli4_mbox_cmd_free(phba, mboxq);
+	else
+		mempool_free(mboxq, phba->mbox_mem_pool);
 	return rc;
 }
 
@@ -5652,12 +5650,10 @@ retrieve_ppname:
 	}
 
 out_free_mboxq:
-	if (rc != MBX_TIMEOUT) {
-		if (bf_get(lpfc_mqe_command, &mboxq->u.mqe) == MBX_SLI4_CONFIG)
-			lpfc_sli4_mbox_cmd_free(phba, mboxq);
-		else
-			mempool_free(mboxq, phba->mbox_mem_pool);
-	}
+	if (bf_get(lpfc_mqe_command, &mboxq->u.mqe) == MBX_SLI4_CONFIG)
+		lpfc_sli4_mbox_cmd_free(phba, mboxq);
+	else
+		mempool_free(mboxq, phba->mbox_mem_pool);
 	return rc;
 }
 
@@ -16844,8 +16840,7 @@ lpfc_rq_destroy(struct lpfc_hba *phba, struct lpfc_queue *hrq,
 				"2509 RQ_DESTROY mailbox failed with "
 				"status x%x add_status x%x, mbx status x%x\n",
 				shdr_status, shdr_add_status, rc);
-		if (rc != MBX_TIMEOUT)
-			mempool_free(mbox, hrq->phba->mbox_mem_pool);
+		mempool_free(mbox, hrq->phba->mbox_mem_pool);
 		return -ENXIO;
 	}
 	bf_set(lpfc_mbx_rq_destroy_q_id, &mbox->u.mqe.un.rq_destroy.u.request,
@@ -16942,7 +16937,9 @@ lpfc_sli4_post_sgl(struct lpfc_hba *phba,
 	shdr = (union lpfc_sli4_cfg_shdr *) &post_sgl_pages->header.cfg_shdr;
 	shdr_status = bf_get(lpfc_mbox_hdr_status, &shdr->response);
 	shdr_add_status = bf_get(lpfc_mbox_hdr_add_status, &shdr->response);
-	if (rc != MBX_TIMEOUT)
+	if (!phba->sli4_hba.intr_enable)
+		mempool_free(mbox, phba->mbox_mem_pool);
+	else if (rc != MBX_TIMEOUT)
 		mempool_free(mbox, phba->mbox_mem_pool);
 	if (shdr_status || shdr_add_status || rc) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
@@ -17139,7 +17136,9 @@ lpfc_sli4_post_sgl_list(struct lpfc_hba *phba,
 	shdr = (union lpfc_sli4_cfg_shdr *) &sgl->cfg_shdr;
 	shdr_status = bf_get(lpfc_mbox_hdr_status, &shdr->response);
 	shdr_add_status = bf_get(lpfc_mbox_hdr_add_status, &shdr->response);
-	if (rc != MBX_TIMEOUT)
+	if (!phba->sli4_hba.intr_enable)
+		lpfc_sli4_mbox_cmd_free(phba, mbox);
+	else if (rc != MBX_TIMEOUT)
 		lpfc_sli4_mbox_cmd_free(phba, mbox);
 	if (shdr_status || shdr_add_status || rc) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
@@ -17252,7 +17251,9 @@ lpfc_sli4_post_io_sgl_block(struct lpfc_hba *phba, struct list_head *nblist,
 	shdr = (union lpfc_sli4_cfg_shdr *)&sgl->cfg_shdr;
 	shdr_status = bf_get(lpfc_mbox_hdr_status, &shdr->response);
 	shdr_add_status = bf_get(lpfc_mbox_hdr_add_status, &shdr->response);
-	if (rc != MBX_TIMEOUT)
+	if (!phba->sli4_hba.intr_enable)
+		lpfc_sli4_mbox_cmd_free(phba, mbox);
+	else if (rc != MBX_TIMEOUT)
 		lpfc_sli4_mbox_cmd_free(phba, mbox);
 	if (shdr_status || shdr_add_status || rc) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
@@ -18607,8 +18608,7 @@ lpfc_sli4_post_rpi_hdr(struct lpfc_hba *phba, struct lpfc_rpi_hdr *rpi_page)
 	shdr = (union lpfc_sli4_cfg_shdr *) &hdr_tmpl->header.cfg_shdr;
 	shdr_status = bf_get(lpfc_mbox_hdr_status, &shdr->response);
 	shdr_add_status = bf_get(lpfc_mbox_hdr_add_status, &shdr->response);
-	if (rc != MBX_TIMEOUT)
-		mempool_free(mboxq, phba->mbox_mem_pool);
+	mempool_free(mboxq, phba->mbox_mem_pool);
 	if (shdr_status || shdr_add_status || rc) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
 				"2514 POST_RPI_HDR mailbox failed with "
@@ -19852,7 +19852,9 @@ lpfc_wr_object(struct lpfc_hba *phba, struct list_head *dmabuf_list,
 			break;
 		}
 	}
-	if (rc != MBX_TIMEOUT)
+	if (!phba->sli4_hba.intr_enable)
+		mempool_free(mbox, phba->mbox_mem_pool);
+	else if (rc != MBX_TIMEOUT)
 		mempool_free(mbox, phba->mbox_mem_pool);
 	if (shdr_status || shdr_add_status || rc) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
-- 
2.30.2



