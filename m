Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FDD460D77A
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 00:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232672AbiJYW62 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 18:58:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232521AbiJYW60 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 18:58:26 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC057CA895
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 15:58:24 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id g11so8751597qts.1
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 15:58:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mxLPmXTZGgSGjoFDnFT+PACk002qEvAV73gzlE7WyFk=;
        b=HPVdDVVlitYq76zOwOaJiLUKq/PfTxKBB9mSD8sGZPgAx0/b60Zdew6aDBY/lq/Jr6
         O/TmLp0izy5lfyp15d6eMnui7+9rMwysHMZZxex1GjG8yfmJkCSe91JHwvWsEuxJGwgQ
         XvAwa4Ku75uIch7Hey8woiqg8IxoW6oztdDZ42uTsEXi4JqLdIiBKaloQDKg6iwKtXnl
         EAG/us70J2JzOgu1emP1glRkmPJqlTg15DOVrsaFn4E4IfgbcGytxF1dSu7bfDQXbXav
         7pduxOPXpb/MpyBCCaRe3z1gN2g+IqmEyKOWcePoBHMiSimB/2hDXjKOg8lwtXq+s+bc
         PDyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mxLPmXTZGgSGjoFDnFT+PACk002qEvAV73gzlE7WyFk=;
        b=tu7eacz1z5pQlAi5285xZ8zfizaZNVD22HeR4o1yZT0alLwFbaLLNyo54rhaBt6/H0
         QVlOeXmmTmmHAYVf2TRc4hoCd3U+eOSc5MZ0I2YQ0wf1EaYkcBg7jaO8nrNu6QlaL2Yr
         1dwXTaGpU/Ds+yiG2zKs9JEGu28s5Z8T8ZlbiAtLSbT26bEH0MWyY5o7srO3kdndDLdH
         anG+XQ+WM7yPhdS4UJ8qVc9jK22YHVWfrL5fIqXeQ4OiIiZGwMJHKkTlXRsy2J0RoljE
         xRInNyW4rvrxDHPSMpPNB/cVAYwQ01/rS3kwm9FRUGv39R4XRwKCvGaLrMw4y2Hygsxu
         i5JQ==
X-Gm-Message-State: ACrzQf043ofUuIfmCUfNbLKFmPLb4fy1T/0q4u0p0y0OPElL0UV9trvN
        /zLPXIbu1CG65g3A5cfB7z1JjqFd2YQ=
X-Google-Smtp-Source: AMsMyM4ssFjjxTysILoHFrf4HhRWq9cHqAwkuO591ZHyDggWWk9G82K61k9Gn9nEzgO1vk4GdCCVAQ==
X-Received: by 2002:ac8:5981:0:b0:39c:e03e:86ed with SMTP id e1-20020ac85981000000b0039ce03e86edmr34601486qte.503.1666738703795;
        Tue, 25 Oct 2022 15:58:23 -0700 (PDT)
Received: from mail-ash-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r12-20020ae9d60c000000b006ecdfcf9d81sm2823766qkk.84.2022.10.25.15.58.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 15:58:23 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     stable@vger.kernel.org
Cc:     jsmart2021@gmail.com, justintee8345@gmail.com,
        martin.petersen@oracle.com, gregkh@linuxfoundation.org,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 10/33] scsi: lpfc: SLI path split: Introduce lpfc_prep_wqe
Date:   Tue, 25 Oct 2022 15:57:16 -0700
Message-Id: <20221025225739.85182-11-jsmart2021@gmail.com>
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

Introduce lpfc_prep_wqe routine.

The lpfc_prep_wqe() routine is used with lpfc_sli_issue_iocb() and
lpfc_sli_issue_iocb_wait(). The routine performs additional SLI-4 wqe field
setting that the generic routines did not perform as they kept their
actions compatible with both SLI3 and SLI4.

Link: https://lore.kernel.org/r/20220225022308.16486-4-jsmart2021@gmail.com
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/lpfc/lpfc_bsg.c  |   1 +
 drivers/scsi/lpfc/lpfc_crtn.h |   1 +
 drivers/scsi/lpfc/lpfc_ct.c   |   1 +
 drivers/scsi/lpfc/lpfc_els.c  |   2 +
 drivers/scsi/lpfc/lpfc_sli.c  | 197 +++++++++++++++++++++++++++++++++-
 5 files changed, 200 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 6688a575904f..1a97426e72de 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -3290,6 +3290,7 @@ lpfc_bsg_diag_loopback_run(struct bsg_job *job)
 	cmdiocbq->cmd_flag |= LPFC_IO_LOOPBACK;
 	cmdiocbq->vport = phba->pport;
 	cmdiocbq->cmd_cmpl = NULL;
+
 	iocb_stat = lpfc_sli_issue_iocb_wait(phba, LPFC_ELS_RING, cmdiocbq,
 					     rspiocbq, (phba->fc_ratov * 2) +
 					     LPFC_DRVR_TIMEOUT);
diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index f7bf589b63fb..6b384104e4e7 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -191,6 +191,7 @@ void lpfc_els_timeout_handler(struct lpfc_vport *);
 struct lpfc_iocbq *lpfc_prep_els_iocb(struct lpfc_vport *, uint8_t, uint16_t,
 				      uint8_t, struct lpfc_nodelist *,
 				      uint32_t, uint32_t);
+void lpfc_sli_prep_wqe(struct lpfc_hba *phba, struct lpfc_iocbq *job);
 void lpfc_hb_timeout_handler(struct lpfc_hba *);
 
 void lpfc_ct_unsol_event(struct lpfc_hba *, struct lpfc_sli_ring *,
diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 19e2f8086a6d..8a19e9908811 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -659,6 +659,7 @@ lpfc_gen_req(struct lpfc_vport *vport, struct lpfc_dmabuf *bmp,
 	geniocb->context_un.ndlp = lpfc_nlp_get(ndlp);
 	if (!geniocb->context_un.ndlp)
 		goto out;
+
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, geniocb, 0);
 
 	if (rc == IOCB_ERROR) {
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 0d34a03164f5..2946a8927ce9 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -2855,6 +2855,7 @@ lpfc_issue_els_adisc(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
 			      "Issue ADISC:   did:x%x refcnt %d",
 			      ndlp->nlp_DID, kref_read(&ndlp->kref), 0);
+
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
 	if (rc == IOCB_ERROR) {
 		lpfc_els_free_iocb(phba, elsiocb);
@@ -3079,6 +3080,7 @@ lpfc_issue_els_logo(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
 			      "Issue LOGO:      did:x%x refcnt %d",
 			      ndlp->nlp_DID, kref_read(&ndlp->kref), 0);
+
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
 	if (rc == IOCB_ERROR) {
 		lpfc_els_free_iocb(phba, elsiocb);
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index d5c221ade1be..43b0bc3f7e61 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -11270,6 +11270,8 @@ lpfc_sli_issue_iocb(struct lpfc_hba *phba, uint32_t ring_number,
 	int rc;
 
 	if (phba->sli_rev == LPFC_SLI_REV4) {
+		lpfc_sli_prep_wqe(phba, piocb);
+
 		eq = phba->sli4_hba.hdwq[piocb->hba_wqidx].hba_eq;
 
 		pring = lpfc_sli4_calc_ring(phba, piocb);
@@ -13093,9 +13095,11 @@ lpfc_sli_issue_iocb_wait(struct lpfc_hba *phba,
 	unsigned long iflags;
 	bool iocb_completed = true;
 
-	if (phba->sli_rev >= LPFC_SLI_REV4)
+	if (phba->sli_rev >= LPFC_SLI_REV4) {
+		lpfc_sli_prep_wqe(phba, piocb);
+
 		pring = lpfc_sli4_calc_ring(phba, piocb);
-	else
+	} else
 		pring = &phba->sli.sli3_ring[ring_number];
 	/*
 	 * If the caller has provided a response iocbq buffer, then context2
@@ -22469,3 +22473,192 @@ lpfc_free_cmd_rsp_buf_per_hdwq(struct lpfc_hba *phba,
 
 	spin_unlock_irqrestore(&hdwq->hdwq_lock, iflags);
 }
+
+/**
+ * lpfc_sli_prep_wqe - Prepare WQE for the command to be posted
+ * @phba: phba object
+ * @job: job entry of the command to be posted.
+ *
+ * Fill the common fields of the wqe for each of the command.
+ *
+ * Return codes:
+ *	None
+ **/
+void
+lpfc_sli_prep_wqe(struct lpfc_hba *phba, struct lpfc_iocbq *job)
+{
+	u8 cmnd;
+	u32 *pcmd;
+	u32 if_type = 0;
+	u32 fip, abort_tag;
+	struct lpfc_nodelist *ndlp = NULL;
+	union lpfc_wqe128 *wqe = &job->wqe;
+	struct lpfc_dmabuf *context2;
+	u32 els_id = LPFC_ELS_ID_DEFAULT;
+	u8 command_type = ELS_COMMAND_NON_FIP;
+
+	fip = phba->hba_flag & HBA_FIP_SUPPORT;
+	/* The fcp commands will set command type */
+	if (job->cmd_flag &  LPFC_IO_FCP)
+		command_type = FCP_COMMAND;
+	else if (fip && (job->cmd_flag & LPFC_FIP_ELS_ID_MASK))
+		command_type = ELS_COMMAND_FIP;
+	else
+		command_type = ELS_COMMAND_NON_FIP;
+
+	abort_tag = job->iotag;
+	cmnd = bf_get(wqe_cmnd, &wqe->els_req.wqe_com);
+
+	switch (cmnd) {
+	case CMD_ELS_REQUEST64_WQE:
+		if (job->cmd_flag & LPFC_IO_LIBDFC)
+			ndlp = job->context_un.ndlp;
+		else
+			ndlp = (struct lpfc_nodelist *)job->context1;
+
+		/* CCP CCPE PV PRI in word10 were set in the memcpy */
+		if (command_type == ELS_COMMAND_FIP)
+			els_id = ((job->cmd_flag & LPFC_FIP_ELS_ID_MASK)
+				  >> LPFC_FIP_ELS_ID_SHIFT);
+
+		if_type = bf_get(lpfc_sli_intf_if_type,
+				 &phba->sli4_hba.sli_intf);
+		if (if_type >= LPFC_SLI_INTF_IF_TYPE_2) {
+			context2 = (struct lpfc_dmabuf *)job->context2;
+			pcmd = (u32 *)context2->virt;
+			if (pcmd && (*pcmd == ELS_CMD_FLOGI ||
+				     *pcmd == ELS_CMD_SCR ||
+				     *pcmd == ELS_CMD_RDF ||
+				     *pcmd == ELS_CMD_EDC ||
+				     *pcmd == ELS_CMD_RSCN_XMT ||
+				     *pcmd == ELS_CMD_FDISC ||
+				     *pcmd == ELS_CMD_LOGO ||
+				     *pcmd == ELS_CMD_QFPA ||
+				     *pcmd == ELS_CMD_UVEM ||
+				     *pcmd == ELS_CMD_PLOGI)) {
+				bf_set(els_req64_sp, &wqe->els_req, 1);
+				bf_set(els_req64_sid, &wqe->els_req,
+				       job->vport->fc_myDID);
+
+				if ((*pcmd == ELS_CMD_FLOGI) &&
+				    !(phba->fc_topology ==
+				      LPFC_TOPOLOGY_LOOP))
+					bf_set(els_req64_sid, &wqe->els_req, 0);
+
+				bf_set(wqe_ct, &wqe->els_req.wqe_com, 1);
+				bf_set(wqe_ctxt_tag, &wqe->els_req.wqe_com,
+				       phba->vpi_ids[job->vport->vpi]);
+			} else if (pcmd) {
+				bf_set(wqe_ct, &wqe->els_req.wqe_com, 0);
+				bf_set(wqe_ctxt_tag, &wqe->els_req.wqe_com,
+				       phba->sli4_hba.rpi_ids[ndlp->nlp_rpi]);
+			}
+		}
+
+		bf_set(wqe_temp_rpi, &wqe->els_req.wqe_com,
+		       phba->sli4_hba.rpi_ids[ndlp->nlp_rpi]);
+
+		bf_set(wqe_els_id, &wqe->els_req.wqe_com, els_id);
+		bf_set(wqe_dbde, &wqe->els_req.wqe_com, 1);
+		bf_set(wqe_iod, &wqe->els_req.wqe_com, LPFC_WQE_IOD_READ);
+		bf_set(wqe_qosd, &wqe->els_req.wqe_com, 1);
+		bf_set(wqe_lenloc, &wqe->els_req.wqe_com, LPFC_WQE_LENLOC_NONE);
+		bf_set(wqe_ebde_cnt, &wqe->els_req.wqe_com, 0);
+		break;
+	case CMD_XMIT_ELS_RSP64_WQE:
+		ndlp = (struct lpfc_nodelist *)job->context1;
+
+		/* word4 */
+		wqe->xmit_els_rsp.word4 = 0;
+
+		if_type = bf_get(lpfc_sli_intf_if_type,
+				 &phba->sli4_hba.sli_intf);
+		if (if_type >= LPFC_SLI_INTF_IF_TYPE_2) {
+			if (job->vport->fc_flag & FC_PT2PT) {
+				bf_set(els_rsp64_sp, &wqe->xmit_els_rsp, 1);
+				bf_set(els_rsp64_sid, &wqe->xmit_els_rsp,
+				       job->vport->fc_myDID);
+				if (job->vport->fc_myDID == Fabric_DID) {
+					bf_set(wqe_els_did,
+					       &wqe->xmit_els_rsp.wqe_dest, 0);
+				}
+			}
+		}
+
+		bf_set(wqe_dbde, &wqe->xmit_els_rsp.wqe_com, 1);
+		bf_set(wqe_iod, &wqe->xmit_els_rsp.wqe_com, LPFC_WQE_IOD_WRITE);
+		bf_set(wqe_qosd, &wqe->xmit_els_rsp.wqe_com, 1);
+		bf_set(wqe_lenloc, &wqe->xmit_els_rsp.wqe_com,
+		       LPFC_WQE_LENLOC_WORD3);
+		bf_set(wqe_ebde_cnt, &wqe->xmit_els_rsp.wqe_com, 0);
+
+		if (phba->fc_topology == LPFC_TOPOLOGY_LOOP) {
+			bf_set(els_rsp64_sp, &wqe->xmit_els_rsp, 1);
+			bf_set(els_rsp64_sid, &wqe->xmit_els_rsp,
+			       job->vport->fc_myDID);
+			bf_set(wqe_ct, &wqe->xmit_els_rsp.wqe_com, 1);
+		}
+
+		if (phba->sli_rev == LPFC_SLI_REV4) {
+			bf_set(wqe_rsp_temp_rpi, &wqe->xmit_els_rsp,
+			       phba->sli4_hba.rpi_ids[ndlp->nlp_rpi]);
+
+			if (bf_get(wqe_ct, &wqe->xmit_els_rsp.wqe_com))
+				bf_set(wqe_ctxt_tag, &wqe->xmit_els_rsp.wqe_com,
+				       phba->vpi_ids[job->vport->vpi]);
+		}
+		command_type = OTHER_COMMAND;
+		break;
+	case CMD_GEN_REQUEST64_WQE:
+		/* Word 10 */
+		bf_set(wqe_dbde, &wqe->gen_req.wqe_com, 1);
+		bf_set(wqe_iod, &wqe->gen_req.wqe_com, LPFC_WQE_IOD_READ);
+		bf_set(wqe_qosd, &wqe->gen_req.wqe_com, 1);
+		bf_set(wqe_lenloc, &wqe->gen_req.wqe_com, LPFC_WQE_LENLOC_NONE);
+		bf_set(wqe_ebde_cnt, &wqe->gen_req.wqe_com, 0);
+		command_type = OTHER_COMMAND;
+		break;
+	case CMD_XMIT_SEQUENCE64_WQE:
+		if (phba->link_flag & LS_LOOPBACK_MODE)
+			bf_set(wqe_xo, &wqe->xmit_sequence.wge_ctl, 1);
+
+		wqe->xmit_sequence.rsvd3 = 0;
+		bf_set(wqe_pu, &wqe->xmit_sequence.wqe_com, 0);
+		bf_set(wqe_dbde, &wqe->xmit_sequence.wqe_com, 1);
+		bf_set(wqe_iod, &wqe->xmit_sequence.wqe_com,
+		       LPFC_WQE_IOD_WRITE);
+		bf_set(wqe_lenloc, &wqe->xmit_sequence.wqe_com,
+		       LPFC_WQE_LENLOC_WORD12);
+		bf_set(wqe_ebde_cnt, &wqe->xmit_sequence.wqe_com, 0);
+		command_type = OTHER_COMMAND;
+		break;
+	case CMD_XMIT_BLS_RSP64_WQE:
+		bf_set(xmit_bls_rsp64_seqcnthi, &wqe->xmit_bls_rsp, 0xffff);
+		bf_set(wqe_xmit_bls_pt, &wqe->xmit_bls_rsp.wqe_dest, 0x1);
+		bf_set(wqe_ct, &wqe->xmit_bls_rsp.wqe_com, 1);
+		bf_set(wqe_ctxt_tag, &wqe->xmit_bls_rsp.wqe_com,
+		       phba->vpi_ids[phba->pport->vpi]);
+		bf_set(wqe_qosd, &wqe->xmit_bls_rsp.wqe_com, 1);
+		bf_set(wqe_lenloc, &wqe->xmit_bls_rsp.wqe_com,
+		       LPFC_WQE_LENLOC_NONE);
+		/* Overwrite the pre-set comnd type with OTHER_COMMAND */
+		command_type = OTHER_COMMAND;
+		break;
+	case CMD_FCP_ICMND64_WQE:	/* task mgmt commands */
+	case CMD_ABORT_XRI_WQE:		/* abort iotag */
+	case CMD_SEND_FRAME:		/* mds loopback */
+		/* cases already formatted for sli4 wqe - no chgs necessary */
+		return;
+	default:
+		dump_stack();
+		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
+				"6207 Invalid command 0x%x\n",
+				cmnd);
+		break;
+	}
+
+	wqe->generic.wqe_com.abort_tag = abort_tag;
+	bf_set(wqe_reqtag, &wqe->generic.wqe_com, job->iotag);
+	bf_set(wqe_cmd_type, &wqe->generic.wqe_com, command_type);
+	bf_set(wqe_cqid, &wqe->generic.wqe_com, LPFC_WQE_CQ_ID_DEFAULT);
+}
-- 
2.35.3

