Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A27DDD107
	for <lists+stable@lfdr.de>; Fri, 18 Oct 2019 23:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502977AbfJRVTB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 17:19:01 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46598 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502569AbfJRVTB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Oct 2019 17:19:01 -0400
Received: by mail-pf1-f195.google.com with SMTP id q5so4597564pfg.13;
        Fri, 18 Oct 2019 14:19:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=2hk1cyD0kMaGlSNhh4PnDSsk8vcRe1zeMzT3dlbceiw=;
        b=PbYftGBBi3+va14bER+g/aF1mC44a4oaH4yS/DpX8EfLczTugQwCoVOgBUMx58dn5D
         geoaFrcUIjqnuQpXgSMSORcq4nXszBHYOYk9WQXwLVzKFgdLLPd5FNVc0rmZmoAjlrDb
         bv01+vHBXtQcW6vF3X03jQNkLCRJfzx+Ay+iGwpt1P8ZOGkbdgF+TQH7uW0M2DJzsKY6
         uk1WyV1xFU9pc9hqbokG/obrgdHqHWCuxkc7eFR4JYtyMY+r71IQmtzV83OKJvgpxA84
         r0mqLlin7HMfVadrNnx5D8yvo+tpunSZeCxFTs/rg+UFI9+T93FaViKQ8fetH+42GMEQ
         5CFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=2hk1cyD0kMaGlSNhh4PnDSsk8vcRe1zeMzT3dlbceiw=;
        b=m7PhAoEA1XbyhMrKBDTWn5YDKnXXlBvY2+YxZbKPo+JoGHHBNn+ZWhLKwW57kAatY/
         yZGsA8bvUjfhL4Axj+/6uwfycWTsBG4SehmozAfnjcFl4k09MBTX0iafy5HS4skmf5oY
         bX3s64e0SMqlxaGq5cwTpCg/qHazX/6GWCnPcfa4EJAyuCsOSv52mAvIJIYojUaien5j
         IvLR+i25vPriW7ZNculE6/5VE7TwfvW2oeNdCJVkQHIqkc4tUpFngspE001A93gwhgrh
         MaQAqOfnGFuF3Fowo4y1yA1tulIQxsHonrtdSbJquFmVzKu/meWoT3Ua/xx/mAV+jdgv
         1JYw==
X-Gm-Message-State: APjAAAWcacBurY6rhbg1brNJOwBmbvsJVXU2Z/hZ/7TahH6jzFYakbpK
        F84ojB9tis2MDcLwgQSy8KysXTm/
X-Google-Smtp-Source: APXvYqzlglAfNHLrxgTxmMBuW6CeHLn6o0jTVtFmwoqXNgg3QoaMpb8xMgoE/HjKov760oBo9J+cKg==
X-Received: by 2002:a63:5025:: with SMTP id e37mr12166787pgb.7.1571433539977;
        Fri, 18 Oct 2019 14:18:59 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 22sm7538878pfo.131.2019.10.18.14.18.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 18 Oct 2019 14:18:59 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>, stable@vger.kernel.org,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 05/16] lpfc: Fix bad ndlp ptr in xri aborted handling
Date:   Fri, 18 Oct 2019 14:18:21 -0700
Message-Id: <20191018211832.7917-6-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20191018211832.7917-1-jsmart2021@gmail.com>
References: <20191018211832.7917-1-jsmart2021@gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In cases where I/O may be aborted, such as driver unload or link
bounces, the system will crash based on a bad ndlp pointer.
Example:
  RIP: 0010:lpfc_sli4_abts_err_handler+0x15/0x140 [lpfc]
  ...
  lpfc_sli4_io_xri_aborted+0x20d/0x270 [lpfc]
  lpfc_sli4_sp_handle_abort_xri_wcqe.isra.54+0x84/0x170 [lpfc]
  lpfc_sli4_fp_handle_cqe+0xc2/0x480 [lpfc]
  __lpfc_sli4_process_cq+0xc6/0x230 [lpfc]
  __lpfc_sli4_hba_process_cq+0x29/0xc0 [lpfc]
  process_one_work+0x14c/0x390

Crash was caused by a bad ndlp address passed to I/O indicated
by the XRI aborted CQE.  The address was not NULL so the routine
deferenced the ndlp ptr. The bad ndlp also caused the
lpfc_sli4_io_xri_aborted to call an erroneous io handler.
Root cause for the bad ndlp was an lpfc_ncmd that was aborted,
put on the abort_io list, completed, taken off the abort_io list,
sent to lpfc_release_nvme_buf where it was put back on the
abort_io list because the lpfc_ncmd->flags setting LPFC_SBUF_XBUSY
was not cleared on the final completion.

Rework the exchange busy handling to ensure the flags are properly
set for both scsi and nvme.

Fixes: c490850a0947 ("scsi: lpfc: Adapt partitioned XRI lists to efficient sharing")
Cc: <stable@vger.kernel.org> # v5.1+
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 11 +++++++----
 drivers/scsi/lpfc/lpfc_sli.c  |  5 ++++-
 drivers/scsi/lpfc/lpfc_sli.h  |  3 +--
 3 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index f06f63e58596..13e3e14b43f9 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -526,7 +526,7 @@ lpfc_sli4_io_xri_aborted(struct lpfc_hba *phba,
 		&qp->lpfc_abts_io_buf_list, list) {
 		if (psb->cur_iocbq.sli4_xritag == xri) {
 			list_del_init(&psb->list);
-			psb->exch_busy = 0;
+			psb->flags &= ~LPFC_SBUF_XBUSY;
 			psb->status = IOSTAT_SUCCESS;
 #ifdef BUILD_NVME
 			if (psb->cur_iocbq.iocb_flag == LPFC_IO_NVME) {
@@ -568,7 +568,7 @@ lpfc_sli4_io_xri_aborted(struct lpfc_hba *phba,
 		if (iocbq->sli4_xritag != xri)
 			continue;
 		psb = container_of(iocbq, struct lpfc_io_buf, cur_iocbq);
-		psb->exch_busy = 0;
+		psb->flags &= ~LPFC_SBUF_XBUSY;
 		spin_unlock_irqrestore(&phba->hbalock, iflag);
 		if (!list_empty(&pring->txq))
 			lpfc_worker_wake_up(phba);
@@ -788,7 +788,7 @@ lpfc_release_scsi_buf_s4(struct lpfc_hba *phba, struct lpfc_io_buf *psb)
 	psb->prot_seg_cnt = 0;
 
 	qp = psb->hdwq;
-	if (psb->exch_busy) {
+	if (psb->flags & LPFC_SBUF_XBUSY) {
 		spin_lock_irqsave(&qp->abts_io_buf_list_lock, iflag);
 		psb->pCmd = NULL;
 		list_add_tail(&psb->list, &qp->lpfc_abts_io_buf_list);
@@ -3837,7 +3837,10 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
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
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 3a6520187ee5..bb0e155eb32c 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -11777,7 +11777,10 @@ lpfc_sli_wake_iocb_wait(struct lpfc_hba *phba,
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
diff --git a/drivers/scsi/lpfc/lpfc_sli.h b/drivers/scsi/lpfc/lpfc_sli.h
index 37fbcb46387e..7bcf922a8be2 100644
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
 
-- 
2.13.7

