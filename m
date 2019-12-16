Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39B2D121625
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:27:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731468AbfLPSQI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:16:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:38150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731186AbfLPSQH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:16:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25CB02082E;
        Mon, 16 Dec 2019 18:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576520166;
        bh=Ds3sX30r1NoxeJY4lwGPNSczYWtJPa3hIhgE/xYjZ74=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g0cmr8dBm6en0kfsiX9FHHZbxk/wrbE7r5l/GhclYDAKnQQFgeW0SfXIF3q3CpDLD
         SdgszUFjLFzcUrcCRambat9tzPAqaEQHmb08IFQTJuryI17fBN8yddcdPK9aY25Yo2
         VPElSD7e2W0i6gUDEBceKkV9PJzrcvSpgYEeqDLw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.4 005/177] scsi: lpfc: Fix bad ndlp ptr in xri aborted handling
Date:   Mon, 16 Dec 2019 18:47:41 +0100
Message-Id: <20191216174812.316462243@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174811.158424118@linuxfoundation.org>
References: <20191216174811.158424118@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

commit 324e1c402069e8d277d2a2b18ce40bde1265b96a upstream.

In cases where I/O may be aborted, such as driver unload or link bounces,
the system will crash based on a bad ndlp pointer.

Example:
  RIP: 0010:lpfc_sli4_abts_err_handler+0x15/0x140 [lpfc]
  ...
  lpfc_sli4_io_xri_aborted+0x20d/0x270 [lpfc]
  lpfc_sli4_sp_handle_abort_xri_wcqe.isra.54+0x84/0x170 [lpfc]
  lpfc_sli4_fp_handle_cqe+0xc2/0x480 [lpfc]
  __lpfc_sli4_process_cq+0xc6/0x230 [lpfc]
  __lpfc_sli4_hba_process_cq+0x29/0xc0 [lpfc]
  process_one_work+0x14c/0x390

Crash was caused by a bad ndlp address passed to I/O indicated by the XRI
aborted CQE.  The address was not NULL so the routine deferenced the ndlp
ptr. The bad ndlp also caused the lpfc_sli4_io_xri_aborted to call an
erroneous io handler.  Root cause for the bad ndlp was an lpfc_ncmd that
was aborted, put on the abort_io list, completed, taken off the abort_io
list, sent to lpfc_release_nvme_buf where it was put back on the abort_io
list because the lpfc_ncmd->flags setting LPFC_SBUF_XBUSY was not cleared
on the final completion.

Rework the exchange busy handling to ensure the flags are properly set for
both scsi and nvme.

Fixes: c490850a0947 ("scsi: lpfc: Adapt partitioned XRI lists to efficient sharing")
Cc: <stable@vger.kernel.org> # v5.1+
Link: https://lore.kernel.org/r/20191018211832.7917-6-jsmart2021@gmail.com
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/lpfc/lpfc_scsi.c |   11 +++++++----
 drivers/scsi/lpfc/lpfc_sli.c  |    5 ++++-
 drivers/scsi/lpfc/lpfc_sli.h  |    3 +--
 3 files changed, 12 insertions(+), 7 deletions(-)

--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -526,7 +526,7 @@ lpfc_sli4_io_xri_aborted(struct lpfc_hba
 		&qp->lpfc_abts_io_buf_list, list) {
 		if (psb->cur_iocbq.sli4_xritag == xri) {
 			list_del_init(&psb->list);
-			psb->exch_busy = 0;
+			psb->flags &= ~LPFC_SBUF_XBUSY;
 			psb->status = IOSTAT_SUCCESS;
 			if (psb->cur_iocbq.iocb_flag == LPFC_IO_NVME) {
 				qp->abts_nvme_io_bufs--;
@@ -566,7 +566,7 @@ lpfc_sli4_io_xri_aborted(struct lpfc_hba
 		if (iocbq->sli4_xritag != xri)
 			continue;
 		psb = container_of(iocbq, struct lpfc_io_buf, cur_iocbq);
-		psb->exch_busy = 0;
+		psb->flags &= ~LPFC_SBUF_XBUSY;
 		spin_unlock_irqrestore(&phba->hbalock, iflag);
 		if (!list_empty(&pring->txq))
 			lpfc_worker_wake_up(phba);
@@ -786,7 +786,7 @@ lpfc_release_scsi_buf_s4(struct lpfc_hba
 	psb->prot_seg_cnt = 0;
 
 	qp = psb->hdwq;
-	if (psb->exch_busy) {
+	if (psb->flags & LPFC_SBUF_XBUSY) {
 		spin_lock_irqsave(&qp->abts_io_buf_list_lock, iflag);
 		psb->pCmd = NULL;
 		list_add_tail(&psb->list, &qp->lpfc_abts_io_buf_list);
@@ -3835,7 +3835,10 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba
 	lpfc_cmd->result = (pIocbOut->iocb.un.ulpWord[4] & IOERR_PARAM_MASK);
 	lpfc_cmd->status = pIocbOut->iocb.ulpStatus;
 	/* pick up SLI4 exhange busy status from HBA */
-	lpfc_cmd->exch_busy = pIocbOut->iocb_flag & LPFC_EXCHANGE_BUSY;
+	if (pIocbOut->iocb_flag & LPFC_EXCHANGE_BUSY)
+		lpfc_cmd->flags |= LPFC_SBUF_XBUSY;
+	else
+		lpfc_cmd->flags &= ~LPFC_SBUF_XBUSY;
 
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	if (lpfc_cmd->prot_data_type) {
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -11736,7 +11736,10 @@ lpfc_sli_wake_iocb_wait(struct lpfc_hba
 		!(cmdiocbq->iocb_flag & LPFC_IO_LIBDFC)) {
 		lpfc_cmd = container_of(cmdiocbq, struct lpfc_io_buf,
 			cur_iocbq);
-		lpfc_cmd->exch_busy = rspiocbq->iocb_flag & LPFC_EXCHANGE_BUSY;
+		if (rspiocbq && (rspiocbq->iocb_flag & LPFC_EXCHANGE_BUSY))
+			lpfc_cmd->flags |= LPFC_SBUF_XBUSY;
+		else
+			lpfc_cmd->flags &= ~LPFC_SBUF_XBUSY;
 	}
 
 	pdone_q = cmdiocbq->context_un.wait_queue;
--- a/drivers/scsi/lpfc/lpfc_sli.h
+++ b/drivers/scsi/lpfc/lpfc_sli.h
@@ -384,14 +384,13 @@ struct lpfc_io_buf {
 
 	struct lpfc_nodelist *ndlp;
 	uint32_t timeout;
-	uint16_t flags;  /* TBD convert exch_busy to flags */
+	uint16_t flags;
 #define LPFC_SBUF_XBUSY		0x1	/* SLI4 hba reported XB on WCQE cmpl */
 #define LPFC_SBUF_BUMP_QDEPTH	0x2	/* bumped queue depth counter */
 					/* External DIF device IO conversions */
 #define LPFC_SBUF_NORMAL_DIF	0x4	/* normal mode to insert/strip */
 #define LPFC_SBUF_PASS_DIF	0x8	/* insert/strip mode to passthru */
 #define LPFC_SBUF_NOT_POSTED    0x10    /* SGL failed post to FW. */
-	uint16_t exch_busy;     /* SLI4 hba reported XB on complete WCQE */
 	uint16_t status;	/* From IOCB Word 7- ulpStatus */
 	uint32_t result;	/* From IOCB Word 4. */
 


