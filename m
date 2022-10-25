Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A689660D77E
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 00:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231381AbiJYW6c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 18:58:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232793AbiJYW6a (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 18:58:30 -0400
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E689D01A1
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 15:58:29 -0700 (PDT)
Received: by mail-qv1-xf34.google.com with SMTP id t16so9976893qvm.9
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 15:58:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JVBdyevL+0VnQAP5PYe68hHjS1xofpdpYjTTxdsYdUg=;
        b=IeJLRLvjb5/n33I1i2kHFK+hX0YlON/S5yLRYfYrN2hIk8YZb8hcf+N2i/azURi9VI
         nZwFarJMnpQu0faMp75r3wGPDCQxDhepYFv52hBhlm+Q/U4cn7RRV8pNCU7jzueT2PU/
         xIPCSCSATkCfMjXQHGrDztH3vsKZgnpRbDaW+RlIvn0Uw5DI5exbTb7tFbr2RdIY/wTE
         0WkfMZr53GpQog5ct1lbQnNPWKx7KPZGMEVrquywoEfk4ciQvKUa9X5snJXlG5CVTbh9
         giLEaTIieDyEz/x+qQad7EiTNMqhTZIfYhrkNlVq/2lRGM8SNEdkZeNX7aM6KtIHGyE8
         aRKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JVBdyevL+0VnQAP5PYe68hHjS1xofpdpYjTTxdsYdUg=;
        b=Fe5rOzqWzc+4LYp7xT2R5GZ5jgQX8NzMfdbS/Nu6S90wDnM4b9A93oHOz+7nNItlfK
         cIqQsOMJxApjl2qr7hdwcAe+r9SRYm8U9ZcSXFo0mve0g+LEOyLXmsDy4Cjh66Bp/l0e
         groqcnVnLNmqggtYQ8op7ms4VITPAkO2XPHdRXMcK6Ehk0RPnskQ9+Xsxv1nStawUpr5
         96DVz59OfGnZYbWEqt0Le+wkmnbY+AWqZvO2aCXhTspmtKA+1oGiQ+/XR9RoJED6rMjI
         miEp4vweR/8WCuJ7agzS8KXVAqJDu/aY9Mf+jeRXNkFR1qTeeMWzZMzdkwk6XCgoERsu
         s4vw==
X-Gm-Message-State: ACrzQf05clMxRgAo+FK2g06aBNtP2KBYA+vEW5DPUMF/x09UR96KduGP
        4ryvyN+Axvlloz/zmvdE23QufiMetDw=
X-Google-Smtp-Source: AMsMyM75HlzynMbedsrQzLNWzOMFvBGNT/vDA0ME0CyPmHKdnkIp6i7dcXAhun/MJcxEDLRyx9ZmiQ==
X-Received: by 2002:a05:6214:c4e:b0:4b1:aa37:f4c1 with SMTP id r14-20020a0562140c4e00b004b1aa37f4c1mr34053182qvj.107.1666738708196;
        Tue, 25 Oct 2022 15:58:28 -0700 (PDT)
Received: from mail-ash-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r12-20020ae9d60c000000b006ecdfcf9d81sm2823766qkk.84.2022.10.25.15.58.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 15:58:27 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     stable@vger.kernel.org
Cc:     jsmart2021@gmail.com, justintee8345@gmail.com,
        martin.petersen@oracle.com, gregkh@linuxfoundation.org,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 13/33] scsi: lpfc: SLI path split: Refactor the RSCN/SCR/RDF/EDC/FARPR paths
Date:   Tue, 25 Oct 2022 15:57:19 -0700
Message-Id: <20221025225739.85182-14-jsmart2021@gmail.com>
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

This patch refactors the SLI3/SLI4 RSCN/SCR/RDF/EDC/FARPR paths to use
SLI-4 as the primary interface:

 - Conversion away from using SLI-3 iocb structures to set/access fields in
   common routines. Use the new generic get/set routines that were added.
   This move changes code from indirect structure references to using local
   variables with the generic routines.

 - Refactor routines when setting non-generic fields, to have both SLI3 and
   SLI4 specific sections. This replaces the set-as-SLI3 then translate to
   SLI4 behavior of the past.

Link: https://lore.kernel.org/r/20220225022308.16486-7-jsmart2021@gmail.com
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 115 ++++++++++++++++++++++++-----------
 1 file changed, 81 insertions(+), 34 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 1ad08e1f8baa..c42555a2418b 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -3171,19 +3171,29 @@ lpfc_cmpl_els_cmd(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	struct lpfc_vport *vport = cmdiocb->vport;
 	struct lpfc_nodelist *free_ndlp;
 	IOCB_t *irsp;
+	u32 ulp_status, ulp_word4, tmo, did, iotag;
 
-	irsp = &rspiocb->iocb;
+	ulp_status = get_job_ulpstatus(phba, rspiocb);
+	ulp_word4 = get_job_word4(phba, rspiocb);
+	did = get_job_els_rsp64_did(phba, cmdiocb);
+
+	if (phba->sli_rev == LPFC_SLI_REV4) {
+		tmo = get_wqe_tmo(cmdiocb);
+		iotag = get_wqe_reqtag(cmdiocb);
+	} else {
+		irsp = &rspiocb->iocb;
+		tmo = irsp->ulpTimeout;
+		iotag = irsp->ulpIoTag;
+	}
 
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
 			      "ELS cmd cmpl:    status:x%x/x%x did:x%x",
-			      irsp->ulpStatus, irsp->un.ulpWord[4],
-			      irsp->un.elsreq64.remoteID);
+			      ulp_status, ulp_word4, did);
 
 	/* ELS cmd tag <ulpIoTag> completes */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
 			 "0106 ELS cmd tag x%x completes Data: x%x x%x x%x\n",
-			 irsp->ulpIoTag, irsp->ulpStatus,
-			 irsp->un.ulpWord[4], irsp->ulpTimeout);
+			 iotag, ulp_status, ulp_word4, tmo);
 
 	/* Check to see if link went down during discovery */
 	lpfc_els_chk_latt(vport);
@@ -3305,20 +3315,29 @@ lpfc_cmpl_els_disc_cmd(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	u32 *pdata;
 	u32 cmd;
 	struct lpfc_nodelist *ndlp = cmdiocb->context1;
+	u32 ulp_status, ulp_word4, tmo, did, iotag;
 
-	irsp = &rspiocb->iocb;
+	ulp_status = get_job_ulpstatus(phba, rspiocb);
+	ulp_word4 = get_job_word4(phba, rspiocb);
+	did = get_job_els_rsp64_did(phba, cmdiocb);
+
+	if (phba->sli_rev == LPFC_SLI_REV4) {
+		tmo = get_wqe_tmo(cmdiocb);
+		iotag = get_wqe_reqtag(cmdiocb);
+	} else {
+		irsp = &rspiocb->iocb;
+		tmo = irsp->ulpTimeout;
+		iotag = irsp->ulpIoTag;
+	}
 
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
 		"ELS cmd cmpl:    status:x%x/x%x did:x%x",
-		irsp->ulpStatus, irsp->un.ulpWord[4],
-		irsp->un.elsreq64.remoteID);
+		ulp_status, ulp_word4, did);
+
 	/* ELS cmd tag <ulpIoTag> completes */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS | LOG_CGN_MGMT,
-			 "0217 ELS cmd tag x%x completes Data: x%x x%x x%x "
-			 "x%x\n",
-			 irsp->ulpIoTag, irsp->ulpStatus,
-			 irsp->un.ulpWord[4], irsp->ulpTimeout,
-			 cmdiocb->retry);
+			 "0217 ELS cmd tag x%x completes Data: x%x x%x x%x x%x\n",
+			 iotag, ulp_status, ulp_word4, tmo, cmdiocb->retry);
 
 	pcmd = (struct lpfc_dmabuf *)cmdiocb->context2;
 	if (!pcmd)
@@ -3330,8 +3349,8 @@ lpfc_cmpl_els_disc_cmd(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	cmd = *pdata;
 
 	/* Only 1 retry for ELS Timeout only */
-	if (irsp->ulpStatus == IOSTAT_LOCAL_REJECT &&
-	    ((irsp->un.ulpWord[4] & IOERR_PARAM_MASK) ==
+	if (ulp_status == IOSTAT_LOCAL_REJECT &&
+	    ((ulp_word4 & IOERR_PARAM_MASK) ==
 	    IOERR_SEQUENCE_TIMEOUT)) {
 		cmdiocb->retry++;
 		if (cmdiocb->retry <= 1) {
@@ -3356,11 +3375,11 @@ lpfc_cmpl_els_disc_cmd(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		lpfc_cmpl_els_edc(phba, cmdiocb, rspiocb);
 		return;
 	}
-	if (irsp->ulpStatus) {
+	if (ulp_status) {
 		/* ELS discovery cmd completes with error */
-		lpfc_printf_vlog(vport, KERN_WARNING, LOG_ELS,
+		lpfc_printf_vlog(vport, KERN_WARNING, LOG_ELS | LOG_CGN_MGMT,
 				 "4203 ELS cmd x%x error: x%x x%X\n", cmd,
-				 irsp->ulpStatus, irsp->un.ulpWord[4]);
+				 ulp_status, ulp_word4);
 		goto out;
 	}
 
@@ -3385,7 +3404,7 @@ lpfc_cmpl_els_disc_cmd(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 					 "4677 Fabric RDF Notification Grant "
 					 "Data: 0x%08x Reg: %x %x\n",
 					 be32_to_cpu(
-						prdf->reg_d1.desc_tags[i]),
+						 prdf->reg_d1.desc_tags[i]),
 					 phba->cgn_reg_signal,
 					 phba->cgn_reg_fpin);
 	}
@@ -3630,7 +3649,7 @@ lpfc_issue_els_farpr(struct lpfc_vport *vport, uint32_t nportid, uint8_t retry)
 	}
 
 	elsiocb = lpfc_prep_els_iocb(vport, 1, cmdsize, retry, ndlp,
-				     ndlp->nlp_DID, ELS_CMD_RNID);
+				     ndlp->nlp_DID, ELS_CMD_FARPR);
 	if (!elsiocb)
 		return 1;
 
@@ -3911,7 +3930,7 @@ static void
 lpfc_cmpl_els_edc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		  struct lpfc_iocbq *rspiocb)
 {
-	IOCB_t *irsp;
+	IOCB_t *irsp_iocb;
 	struct fc_els_edc_resp *edc_rsp;
 	struct fc_tlv_desc *tlv;
 	struct fc_diag_cg_sig_desc *pcgd;
@@ -3922,20 +3941,31 @@ lpfc_cmpl_els_edc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	int desc_cnt = 0, bytes_remain;
 	bool rcv_cap_desc = false;
 	struct lpfc_nodelist *ndlp;
+	u32 ulp_status, ulp_word4, tmo, did, iotag;
 
-	irsp = &rspiocb->iocb;
 	ndlp = cmdiocb->context1;
 
+	ulp_status = get_job_ulpstatus(phba, rspiocb);
+	ulp_word4 = get_job_word4(phba, rspiocb);
+	did = get_job_els_rsp64_did(phba, rspiocb);
+
+	if (phba->sli_rev == LPFC_SLI_REV4) {
+		tmo = get_wqe_tmo(rspiocb);
+		iotag = get_wqe_reqtag(rspiocb);
+	} else {
+		irsp_iocb = &rspiocb->iocb;
+		tmo = irsp_iocb->ulpTimeout;
+		iotag = irsp_iocb->ulpIoTag;
+	}
+
 	lpfc_debugfs_disc_trc(phba->pport, LPFC_DISC_TRC_ELS_CMD,
 			      "EDC cmpl:    status:x%x/x%x did:x%x",
-			      irsp->ulpStatus, irsp->un.ulpWord[4],
-			      irsp->un.elsreq64.remoteID);
+			      ulp_status, ulp_word4, did);
 
 	/* ELS cmd tag <ulpIoTag> completes */
 	lpfc_printf_log(phba, KERN_INFO, LOG_ELS | LOG_CGN_MGMT,
 			"4201 EDC cmd tag x%x completes Data: x%x x%x x%x\n",
-			irsp->ulpIoTag, irsp->ulpStatus,
-			irsp->un.ulpWord[4], irsp->ulpTimeout);
+			iotag, ulp_status, ulp_word4, tmo);
 
 	pcmd = (struct lpfc_dmabuf *)cmdiocb->context2;
 	if (!pcmd)
@@ -3946,7 +3976,7 @@ lpfc_cmpl_els_edc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		goto out;
 
 	/* Need to clear signal values, send features MB and RDF with FPIN. */
-	if (irsp->ulpStatus)
+	if (ulp_status)
 		goto out;
 
 	prsp = list_get_first(&pcmd->list, struct lpfc_dmabuf, list);
@@ -6243,12 +6273,18 @@ lpfc_els_rsp_echo_acc(struct lpfc_vport *vport, uint8_t *data,
 		      struct lpfc_iocbq *oldiocb, struct lpfc_nodelist *ndlp)
 {
 	struct lpfc_hba  *phba = vport->phba;
+	IOCB_t *icmd, *oldcmd;
+	union lpfc_wqe128 *wqe;
 	struct lpfc_iocbq *elsiocb;
 	uint8_t *pcmd;
 	uint16_t cmdsize;
 	int rc;
+	u32 ulp_context;
 
-	cmdsize = oldiocb->iocb.unsli3.rcvsli3.acc_len;
+	if (phba->sli_rev == LPFC_SLI_REV4)
+		cmdsize = oldiocb->wcqe_cmpl.total_data_placed;
+	else
+		cmdsize = oldiocb->iocb.unsli3.rcvsli3.acc_len;
 
 	/* The accumulated length can exceed the BPL_SIZE.  For
 	 * now, use this as the limit
@@ -6260,13 +6296,26 @@ lpfc_els_rsp_echo_acc(struct lpfc_vport *vport, uint8_t *data,
 	if (!elsiocb)
 		return 1;
 
-	elsiocb->iocb.ulpContext = oldiocb->iocb.ulpContext;  /* Xri / rx_id */
-	elsiocb->iocb.unsli3.rcvsli3.ox_id = oldiocb->iocb.unsli3.rcvsli3.ox_id;
+	if (phba->sli_rev == LPFC_SLI_REV4) {
+		wqe = &elsiocb->wqe;
+		bf_set(wqe_ctxt_tag, &wqe->generic.wqe_com,
+		       get_job_ulpcontext(phba, oldiocb)); /* Xri / rx_id */
+		ulp_context = get_job_ulpcontext(phba, elsiocb);
+		bf_set(wqe_rcvoxid, &wqe->xmit_els_rsp.wqe_com,
+		       get_job_rcvoxid(phba, oldiocb));
+	} else {
+		icmd = &elsiocb->iocb;
+		oldcmd = &oldiocb->iocb;
+		icmd->ulpContext = oldcmd->ulpContext; /* Xri / rx_id */
+		ulp_context = elsiocb->iocb.ulpContext;
+		icmd->unsli3.rcvsli3.ox_id =
+			oldcmd->unsli3.rcvsli3.ox_id;
+	}
 
 	/* Xmit ECHO ACC response tag <ulpIoTag> */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
 			 "2876 Xmit ECHO ACC response tag x%x xri x%x\n",
-			 elsiocb->iotag, elsiocb->iocb.ulpContext);
+			 elsiocb->iotag, ulp_context);
 	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
 	*((uint32_t *) (pcmd)) = ELS_CMD_ACC;
 	pcmd += sizeof(uint32_t);
@@ -8825,11 +8874,9 @@ lpfc_els_rcv_farpr(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 {
 	struct lpfc_dmabuf *pcmd;
 	uint32_t *lp;
-	IOCB_t *icmd;
 	uint32_t did;
 
-	icmd = &cmdiocb->iocb;
-	did = icmd->un.elsreq64.remoteID;
+	did = get_job_els_rsp64_did(vport->phba, cmdiocb);
 	pcmd = (struct lpfc_dmabuf *) cmdiocb->context2;
 	lp = (uint32_t *) pcmd->virt;
 
-- 
2.35.3

