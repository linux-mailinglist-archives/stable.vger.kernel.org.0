Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B44A60D786
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 00:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232822AbiJYW6o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 18:58:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232706AbiJYW6n (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 18:58:43 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42071CA895
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 15:58:42 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id l9so6786016qkk.11
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 15:58:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/doKm426u7XHmiIQ8qJ2a76hj+uK2oEoMFDObOHWUNk=;
        b=YzZ1k9P9S8X7UvqeahCgeIR7+x2qjX8zeL6Q8CtwSu6/eF9niMaJO/kX3jtNC8yEaK
         envqgBD9TDzIZoNYmt6L8e+k+Vyn0ei8HspZ9yZjbpwt+yK5Q1kc+mhzmsN/Gt5pvDoY
         1Pl5PoRoitkRXOp7IY7v5QvXMxqOUIeaB75v1AFGmuLFkjRelpGRjmnhckfft9PGGZ9K
         W9h2PdXQtHg+x3H7N/57KvJ7OPoJtRabkpSXTIG0sAh0xvOCxSjybHgML3t8k5k5RUD/
         obFqgLmQj5HjMrl/aUiQPAFaNhNjSXV0SAVwdDAm43nTiq2+eZPhiUT413dstrZ2rhBL
         CzKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/doKm426u7XHmiIQ8qJ2a76hj+uK2oEoMFDObOHWUNk=;
        b=YQc2CaClH2ezPdaVc6tjeo3tMfKKVUWlWqRurgyCjzU1g1KDej7Q+LuEJawcSHiHUQ
         YeezmxCAmH80mG4OOZ/lbuSRvn1itX8Ki3fAnmCg+FFLnkyBCRdmRXRyg1EbYDIQJWZM
         PZW2v6Ara0NlRMil5B5+3tagLieM6I+Q7ZlL6rx6DsRpaeTb3VvBZ/0g4USsu0D8qbiU
         UJRP576+r3sn+1lANLgU3VETUHK3QuLINFaiBiP1mJM0BqZtfByIhVjSGeMFWLCVSuWl
         syCltkwE7DNW634lh/F0QvIK9j1fr8xqumIO1mMPmsDsTtCOl+PUZtT7QTmxMLu3O+5m
         fQ7Q==
X-Gm-Message-State: ACrzQf33QNbR5f+KrbD1cvB4VIK2qiY4dky57q1qyVjUjCtWnCB61YA0
        QQlLTYdzN35w0m/5Jjx2mBvY3sN5jng=
X-Google-Smtp-Source: AMsMyM4TFf3mBO87b3mXMkGh1WgVYxDx7HWU6ypduwFVSFqtnvUbnhlj1oatIVIwiCMrlH4586DYJg==
X-Received: by 2002:a05:620a:440a:b0:6ec:d931:652d with SMTP id v10-20020a05620a440a00b006ecd931652dmr27739630qkp.344.1666738721225;
        Tue, 25 Oct 2022 15:58:41 -0700 (PDT)
Received: from mail-ash-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r12-20020ae9d60c000000b006ecdfcf9d81sm2823766qkk.84.2022.10.25.15.58.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 15:58:40 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     stable@vger.kernel.org
Cc:     jsmart2021@gmail.com, justintee8345@gmail.com,
        martin.petersen@oracle.com, gregkh@linuxfoundation.org,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 22/33] scsi: lpfc: SLI path split: Refactor BSG paths
Date:   Tue, 25 Oct 2022 15:57:28 -0700
Message-Id: <20221025225739.85182-23-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20221025225739.85182-1-jsmart2021@gmail.com>
References: <20221025225739.85182-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch refactors the BSG paths to use SLI-4 as the primary interface.

 - Conversion away from using SLI-3 iocb structures to set/access fields in
   common routines. Use the new generic get/set routines that were added.
   This move changes code from indirect structure references to using local
   variables with the generic routines.

 - Refactor routines when setting non-generic fields, to have both SLI3 and
   SLI4 specific sections. This replaces the set-as-SLI3 then translate to
   SLI4 behavior of the past.

Link: https://lore.kernel.org/r/20220225022308.16486-16-jsmart2021@gmail.com
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/lpfc/lpfc_bsg.c | 36 ++++++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 8d49e4b2ebfe..f1bb40fe8206 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -564,7 +564,6 @@ lpfc_bsg_rport_els_cmp(struct lpfc_hba *phba,
 	struct bsg_job_data *dd_data;
 	struct bsg_job *job;
 	struct fc_bsg_reply *bsg_reply;
-	IOCB_t *rsp;
 	struct lpfc_nodelist *ndlp;
 	struct lpfc_dmabuf *pcmd = NULL, *prsp = NULL;
 	struct fc_bsg_ctels_reply *els_reply;
@@ -572,6 +571,7 @@ lpfc_bsg_rport_els_cmp(struct lpfc_hba *phba,
 	unsigned long flags;
 	unsigned int rsp_size;
 	int rc = 0;
+	u32 ulp_status, ulp_word4, total_data_placed;
 
 	dd_data = cmdiocbq->context1;
 	ndlp = dd_data->context_un.iocb.ndlp;
@@ -592,7 +592,9 @@ lpfc_bsg_rport_els_cmp(struct lpfc_hba *phba,
 	cmdiocbq->cmd_flag &= ~LPFC_IO_CMD_OUTSTANDING;
 	spin_unlock_irqrestore(&phba->hbalock, flags);
 
-	rsp = &rspiocbq->iocb;
+	ulp_status = get_job_ulpstatus(phba, rspiocbq);
+	ulp_word4 = get_job_word4(phba, rspiocbq);
+	total_data_placed = get_job_data_placed(phba, rspiocbq);
 	pcmd = (struct lpfc_dmabuf *)cmdiocbq->context2;
 	prsp = (struct lpfc_dmabuf *)pcmd->list.next;
 
@@ -601,24 +603,28 @@ lpfc_bsg_rport_els_cmp(struct lpfc_hba *phba,
 	 */
 
 	if (job) {
-		if (rsp->ulpStatus == IOSTAT_SUCCESS) {
-			rsp_size = rsp->un.elsreq64.bdl.bdeSize;
+		if (ulp_status == IOSTAT_SUCCESS) {
+			rsp_size = total_data_placed;
 			bsg_reply->reply_payload_rcv_len =
 				sg_copy_from_buffer(job->reply_payload.sg_list,
 						    job->reply_payload.sg_cnt,
 						    prsp->virt,
 						    rsp_size);
-		} else if (rsp->ulpStatus == IOSTAT_LS_RJT) {
+		} else if (ulp_status == IOSTAT_LS_RJT) {
 			bsg_reply->reply_payload_rcv_len =
 				sizeof(struct fc_bsg_ctels_reply);
 			/* LS_RJT data returned in word 4 */
-			rjt_data = (uint8_t *)&rsp->un.ulpWord[4];
+			rjt_data = (uint8_t *)&ulp_word4;
 			els_reply = &bsg_reply->reply_data.ctels_reply;
 			els_reply->status = FC_CTELS_STATUS_REJECT;
 			els_reply->rjt_data.action = rjt_data[3];
 			els_reply->rjt_data.reason_code = rjt_data[2];
 			els_reply->rjt_data.reason_explanation = rjt_data[1];
 			els_reply->rjt_data.vendor_unique = rjt_data[0];
+		} else if (ulp_status == IOSTAT_LOCAL_REJECT &&
+			   (ulp_word4 & IOERR_PARAM_MASK) ==
+			   IOERR_SEQUENCE_TIMEOUT) {
+			rc = -ETIMEDOUT;
 		} else {
 			rc = -EIO;
 		}
@@ -695,7 +701,6 @@ lpfc_bsg_rport_els(struct bsg_job *job)
 	 * we won't be dma into memory that is no longer allocated to for the
 	 * request.
 	 */
-
 	cmdiocbq = lpfc_prep_els_iocb(vport, 1, cmdsize, 0, ndlp,
 				      ndlp->nlp_DID, elscmd);
 	if (!cmdiocbq) {
@@ -707,12 +712,13 @@ lpfc_bsg_rport_els(struct bsg_job *job)
 	sg_copy_to_buffer(job->request_payload.sg_list,
 			  job->request_payload.sg_cnt,
 			  ((struct lpfc_dmabuf *)cmdiocbq->context2)->virt,
-			  cmdsize);
+			  job->request_payload.payload_len);
 
 	rpi = ndlp->nlp_rpi;
 
 	if (phba->sli_rev == LPFC_SLI_REV4)
-		cmdiocbq->iocb.ulpContext = phba->sli4_hba.rpi_ids[rpi];
+		bf_set(wqe_ctxt_tag, &cmdiocbq->wqe.generic.wqe_com,
+		       phba->sli4_hba.rpi_ids[rpi]);
 	else
 		cmdiocbq->iocb.ulpContext = rpi;
 	cmdiocbq->cmd_flag |= LPFC_IO_LIBDFC;
@@ -1372,11 +1378,11 @@ lpfc_issue_ct_rsp_cmp(struct lpfc_hba *phba,
 	struct bsg_job_data *dd_data;
 	struct bsg_job *job;
 	struct fc_bsg_reply *bsg_reply;
-	IOCB_t *rsp;
 	struct lpfc_dmabuf *bmp, *cmp;
 	struct lpfc_nodelist *ndlp;
 	unsigned long flags;
 	int rc = 0;
+	u32 ulp_status, ulp_word4;
 
 	dd_data = cmdiocbq->context1;
 
@@ -1397,15 +1403,17 @@ lpfc_issue_ct_rsp_cmp(struct lpfc_hba *phba,
 	ndlp = dd_data->context_un.iocb.ndlp;
 	cmp = cmdiocbq->context2;
 	bmp = cmdiocbq->context3;
-	rsp = &rspiocbq->iocb;
+
+	ulp_status = get_job_ulpstatus(phba, rspiocbq);
+	ulp_word4 = get_job_word4(phba, rspiocbq);
 
 	/* Copy the completed job data or set the error status */
 
 	if (job) {
 		bsg_reply = job->reply;
-		if (rsp->ulpStatus) {
-			if (rsp->ulpStatus == IOSTAT_LOCAL_REJECT) {
-				switch (rsp->un.ulpWord[4] & IOERR_PARAM_MASK) {
+		if (ulp_status) {
+			if (ulp_status == IOSTAT_LOCAL_REJECT) {
+				switch (ulp_word4 & IOERR_PARAM_MASK) {
 				case IOERR_SEQUENCE_TIMEOUT:
 					rc = -ETIMEDOUT;
 					break;
-- 
2.35.3

