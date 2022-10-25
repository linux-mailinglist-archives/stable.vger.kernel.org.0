Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6BED60D77C
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 00:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232675AbiJYW6b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 18:58:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232786AbiJYW63 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 18:58:29 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFA6ACA8B8
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 15:58:26 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id x15so10015030qvp.1
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 15:58:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=798LcvIiFEuIEp5YJL9L8G4cQqenMPNygdZPLcgBQws=;
        b=oBF/3Vy/zoNa9Gdj2vUmGP9olvsV9Iq2ad63jWelSgFEQAfgCD9DNtHX8VgFTGIrom
         /OSpocFAYYYMh+m+OpqVQPFMAWGQXuNWaahRl6M9NoybBZgGxUDPwTVR4Qs6/KPLqThA
         UEfbGWhsbBWVhrCaaTXbPlvQVCUb0b6tK+xjG3xISffj2JqgDXhPi1wB+nnKkkklqHWe
         8hwz72vtMIZdBrCCU5EyafhOAVIre680CsmtaVqYeLkoaObzeSJNWnw3+aPGFXn9qOC3
         BwQ0ZsU+ZiLCmMjK+s7E7nN8DuMH+AlmJDvepal811wgPctwoBDzNTtnkudOt4hR3Pu3
         U1ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=798LcvIiFEuIEp5YJL9L8G4cQqenMPNygdZPLcgBQws=;
        b=y9rWBEaOeO3d8y4KJ5H2O84dnrBlNTZ+anIpfFwSeWLZTHtdzbi//xjNM3X1uAogtF
         kapr0hfRfR7Buw65u47SoMqG+LZEcZQpOAncRoqoV8+5Ir4hf6RnifQYNqjg51LISf21
         3E3AEmF9s5cpfrn0b9NHQ+xWNspqrj2algdz34atyVe1b/Sm8gIkEJok9lM3kfXyGrcw
         zARoJlSuv0qqsB7lViv+yPcHNM0fZJhUydT64l2WKyX6MGtH7swGgM7JYhLaK4gzjuL8
         G+5HGqfN3t1XyRKRW41MHAseQCQS3dbq9c7zM25pTbIbNPVqKY9VEeDWVJuphrqXbWzB
         V/rw==
X-Gm-Message-State: ACrzQf0nnIUttgZikTeH5GzN/56Ao0J60i/OvKzHTFXrvp18VYaDBegu
        Xg/WD1y8xrY90jUCCihkV7aF4joVwuk=
X-Google-Smtp-Source: AMsMyM7oOH742pYy0jWix3g8My4Mig73Dvm+W0fH1CLRFh9fNE9OlB9i0kMpPyl9AJiu+0ERyuR+dg==
X-Received: by 2002:a05:6214:e8b:b0:4bb:7847:6617 with SMTP id hf11-20020a0562140e8b00b004bb78476617mr9173824qvb.95.1666738705216;
        Tue, 25 Oct 2022 15:58:25 -0700 (PDT)
Received: from mail-ash-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r12-20020ae9d60c000000b006ecdfcf9d81sm2823766qkk.84.2022.10.25.15.58.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 15:58:24 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     stable@vger.kernel.org
Cc:     jsmart2021@gmail.com, justintee8345@gmail.com,
        martin.petersen@oracle.com, gregkh@linuxfoundation.org,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 11/33] scsi: lpfc: SLI path split: Refactor base ELS paths and the FLOGI path
Date:   Tue, 25 Oct 2022 15:57:17 -0700
Message-Id: <20221025225739.85182-12-jsmart2021@gmail.com>
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

The patch refactors the general ELS handling paths to migrate to SLI-4
structures or common element abstractions. The fabric login paths are
revised as part of this patch:

 - New generic lpfc_sli_prep_els_req_rsp jump table routine

 - Introduce ls_rjt_error_be and ulp_bde64_le unions to correct legacy
   endianness assignments

 - Conversion away from using SLI-3 iocb structures to set/access fields in
   common routines. Use the new generic get/set routines that were added.
   This move changes code from indirect structure references to using local
   variables with the generic routines.

 - Refactor routines when setting non-generic fields, to have both SLI3 and
   SLI4 specific sections. This replaces the set-as-SLI3 then translate to
   SLI4 behavior of the past.

 - Clean up poor indentation on some of the ELS paths

Link: https://lore.kernel.org/r/20220225022308.16486-5-jsmart2021@gmail.com
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/lpfc/lpfc.h      |  17 +-
 drivers/scsi/lpfc/lpfc_crtn.h |   5 +
 drivers/scsi/lpfc/lpfc_ct.c   |   4 +-
 drivers/scsi/lpfc/lpfc_els.c  | 440 ++++++++++++++++++----------------
 drivers/scsi/lpfc/lpfc_hw.h   |  14 +-
 drivers/scsi/lpfc/lpfc_hw4.h  |  29 +++
 drivers/scsi/lpfc/lpfc_sli.c  | 184 ++++++++++++--
 7 files changed, 453 insertions(+), 240 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 266d980667b8..2c304fd2c4a7 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -965,7 +965,13 @@ struct lpfc_hba {
 
 	int (*lpfc_bg_scsi_prep_dma_buf)
 		(struct lpfc_hba *, struct lpfc_io_buf *);
-	/* Add new entries here */
+
+	/* Prep SLI WQE/IOCB jump table entries */
+	void (*__lpfc_sli_prep_els_req_rsp)(struct lpfc_iocbq *cmdiocbq,
+					    struct lpfc_vport *vport,
+					    struct lpfc_dmabuf *bmp,
+					    u16 cmd_size, u32 did, u32 elscmd,
+					    u8 tmo, u8 expect_rsp);
 
 	/* expedite pool */
 	struct lpfc_epd_pool epd_pool;
@@ -1839,3 +1845,12 @@ u16 get_job_ulpcontext(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq)
 	else
 		return iocbq->iocb.ulpContext;
 }
+
+static inline
+u32 get_job_els_rsp64_did(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq)
+{
+	if (phba->sli_rev == LPFC_SLI_REV4)
+		return bf_get(wqe_els_did, &iocbq->wqe.els_req.wqe_dest);
+	else
+		return iocbq->iocb.un.elsreq64.remoteID;
+}
diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index 6b384104e4e7..257f23fbdb5f 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -352,6 +352,11 @@ int lpfc_sli4_issue_wqe(struct lpfc_hba *phba, struct lpfc_sli4_hdw_queue *qp,
 			struct lpfc_iocbq *pwqe);
 int lpfc_sli4_issue_abort_iotag(struct lpfc_hba *phba,
 			struct lpfc_iocbq *cmdiocb, void *cmpl);
+void lpfc_sli_prep_els_req_rsp(struct lpfc_hba *phba,
+			       struct lpfc_iocbq *cmdiocbq,
+			       struct lpfc_vport *vport,
+			       struct lpfc_dmabuf *bmp, u16 cmd_size, u32 did,
+			       u32 elscmd, u8 tmo, u8 expect_rsp);
 struct lpfc_sglq *__lpfc_clear_active_sglq(struct lpfc_hba *phba, uint16_t xri);
 struct lpfc_sglq *__lpfc_sli_get_nvmet_sglq(struct lpfc_hba *phba,
 					    struct lpfc_iocbq *piocbq);
diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 8a19e9908811..95e7651163da 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -982,7 +982,7 @@ lpfc_cmpl_ct_cmd_gid_ft(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		lpfc_vport_set_state(vport, FC_VPORT_FAILED);
 		goto out;
 	}
-	if (lpfc_error_lost_link(irsp)) {
+	if (lpfc_error_lost_link(irsp->ulpStatus, irsp->un.ulpWord[4])) {
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
 				 "0226 NS query failed due to link event\n");
 		if (vport->fc_flag & FC_RSCN_MODE)
@@ -1199,7 +1199,7 @@ lpfc_cmpl_ct_cmd_gid_pt(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		lpfc_vport_set_state(vport, FC_VPORT_FAILED);
 		goto out;
 	}
-	if (lpfc_error_lost_link(irsp)) {
+	if (lpfc_error_lost_link(irsp->ulpStatus, irsp->un.ulpWord[4])) {
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
 				 "4166 NS query failed due to link event\n");
 		if (vport->fc_flag & FC_RSCN_MODE)
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 2946a8927ce9..5bf57923d92e 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -134,9 +134,9 @@ lpfc_els_chk_latt(struct lpfc_vport *vport)
 /**
  * lpfc_prep_els_iocb - Allocate and prepare a lpfc iocb data structure
  * @vport: pointer to a host virtual N_Port data structure.
- * @expectRsp: flag indicating whether response is expected.
- * @cmdSize: size of the ELS command.
- * @retry: number of retries to the command IOCB when it fails.
+ * @expect_rsp: flag indicating whether response is expected.
+ * @cmd_size: size of the ELS command.
+ * @retry: number of retries to the command when it fails.
  * @ndlp: pointer to a node-list data structure.
  * @did: destination identifier.
  * @elscmd: the ELS command code.
@@ -160,25 +160,23 @@ lpfc_els_chk_latt(struct lpfc_vport *vport)
  *   NULL - when els iocb data structure allocation/preparation failed
  **/
 struct lpfc_iocbq *
-lpfc_prep_els_iocb(struct lpfc_vport *vport, uint8_t expectRsp,
-		   uint16_t cmdSize, uint8_t retry,
-		   struct lpfc_nodelist *ndlp, uint32_t did,
-		   uint32_t elscmd)
+lpfc_prep_els_iocb(struct lpfc_vport *vport, u8 expect_rsp,
+		   u16 cmd_size, u8 retry,
+		   struct lpfc_nodelist *ndlp, u32 did,
+		   u32 elscmd)
 {
 	struct lpfc_hba  *phba = vport->phba;
 	struct lpfc_iocbq *elsiocb;
-	struct lpfc_dmabuf *pcmd, *prsp, *pbuflist;
-	struct ulp_bde64 *bpl;
-	IOCB_t *icmd;
-
+	struct lpfc_dmabuf *pcmd, *prsp, *pbuflist, *bmp;
+	struct ulp_bde64_le *bpl;
+	u32 timeout = 0;
 
 	if (!lpfc_is_link_up(phba))
 		return NULL;
 
 	/* Allocate buffer for  command iocb */
 	elsiocb = lpfc_sli_get_iocbq(phba);
-
-	if (elsiocb == NULL)
+	if (!elsiocb)
 		return NULL;
 
 	/*
@@ -186,35 +184,33 @@ lpfc_prep_els_iocb(struct lpfc_vport *vport, uint8_t expectRsp,
 	 * in FIP mode send FLOGI, FDISC and LOGO as FIP frames.
 	 */
 	if ((did == Fabric_DID) &&
-		(phba->hba_flag & HBA_FIP_SUPPORT) &&
-		((elscmd == ELS_CMD_FLOGI) ||
-		 (elscmd == ELS_CMD_FDISC) ||
-		 (elscmd == ELS_CMD_LOGO)))
+	    (phba->hba_flag & HBA_FIP_SUPPORT) &&
+	    ((elscmd == ELS_CMD_FLOGI) ||
+	     (elscmd == ELS_CMD_FDISC) ||
+	     (elscmd == ELS_CMD_LOGO)))
 		switch (elscmd) {
 		case ELS_CMD_FLOGI:
-		elsiocb->cmd_flag |=
-			((LPFC_ELS_ID_FLOGI << LPFC_FIP_ELS_ID_SHIFT)
-					& LPFC_FIP_ELS_ID_MASK);
-		break;
+			elsiocb->cmd_flag |=
+				((LPFC_ELS_ID_FLOGI << LPFC_FIP_ELS_ID_SHIFT)
+				 & LPFC_FIP_ELS_ID_MASK);
+			break;
 		case ELS_CMD_FDISC:
-		elsiocb->cmd_flag |=
-			((LPFC_ELS_ID_FDISC << LPFC_FIP_ELS_ID_SHIFT)
-					& LPFC_FIP_ELS_ID_MASK);
-		break;
+			elsiocb->cmd_flag |=
+				((LPFC_ELS_ID_FDISC << LPFC_FIP_ELS_ID_SHIFT)
+				 & LPFC_FIP_ELS_ID_MASK);
+			break;
 		case ELS_CMD_LOGO:
-		elsiocb->cmd_flag |=
-			((LPFC_ELS_ID_LOGO << LPFC_FIP_ELS_ID_SHIFT)
-					& LPFC_FIP_ELS_ID_MASK);
-		break;
+			elsiocb->cmd_flag |=
+				((LPFC_ELS_ID_LOGO << LPFC_FIP_ELS_ID_SHIFT)
+				 & LPFC_FIP_ELS_ID_MASK);
+			break;
 		}
 	else
 		elsiocb->cmd_flag &= ~LPFC_FIP_ELS_ID_MASK;
 
-	icmd = &elsiocb->iocb;
-
 	/* fill in BDEs for command */
 	/* Allocate buffer for command payload */
-	pcmd = kmalloc(sizeof(struct lpfc_dmabuf), GFP_KERNEL);
+	pcmd = kmalloc(sizeof(*pcmd), GFP_KERNEL);
 	if (pcmd)
 		pcmd->virt = lpfc_mbuf_alloc(phba, MEM_PRI, &pcmd->phys);
 	if (!pcmd || !pcmd->virt)
@@ -223,19 +219,20 @@ lpfc_prep_els_iocb(struct lpfc_vport *vport, uint8_t expectRsp,
 	INIT_LIST_HEAD(&pcmd->list);
 
 	/* Allocate buffer for response payload */
-	if (expectRsp) {
-		prsp = kmalloc(sizeof(struct lpfc_dmabuf), GFP_KERNEL);
+	if (expect_rsp) {
+		prsp = kmalloc(sizeof(*prsp), GFP_KERNEL);
 		if (prsp)
 			prsp->virt = lpfc_mbuf_alloc(phba, MEM_PRI,
 						     &prsp->phys);
 		if (!prsp || !prsp->virt)
 			goto els_iocb_free_prsp_exit;
 		INIT_LIST_HEAD(&prsp->list);
-	} else
+	} else {
 		prsp = NULL;
+	}
 
 	/* Allocate buffer for Buffer ptr list */
-	pbuflist = kmalloc(sizeof(struct lpfc_dmabuf), GFP_KERNEL);
+	pbuflist = kmalloc(sizeof(*pbuflist), GFP_KERNEL);
 	if (pbuflist)
 		pbuflist->virt = lpfc_mbuf_alloc(phba, MEM_PRI,
 						 &pbuflist->phys);
@@ -244,70 +241,42 @@ lpfc_prep_els_iocb(struct lpfc_vport *vport, uint8_t expectRsp,
 
 	INIT_LIST_HEAD(&pbuflist->list);
 
-	if (expectRsp) {
-		icmd->un.elsreq64.bdl.addrHigh = putPaddrHigh(pbuflist->phys);
-		icmd->un.elsreq64.bdl.addrLow = putPaddrLow(pbuflist->phys);
-		icmd->un.elsreq64.bdl.bdeFlags = BUFF_TYPE_BLP_64;
-		icmd->un.elsreq64.bdl.bdeSize = (2 * sizeof(struct ulp_bde64));
-
-		icmd->un.elsreq64.remoteID = did;		/* DID */
-		icmd->ulpCommand = CMD_ELS_REQUEST64_CR;
-		if (elscmd == ELS_CMD_FLOGI)
-			icmd->ulpTimeout = FF_DEF_RATOV * 2;
-		else if (elscmd == ELS_CMD_LOGO)
-			icmd->ulpTimeout = phba->fc_ratov;
-		else
-			icmd->ulpTimeout = phba->fc_ratov * 2;
-	} else {
-		icmd->un.xseq64.bdl.addrHigh = putPaddrHigh(pbuflist->phys);
-		icmd->un.xseq64.bdl.addrLow = putPaddrLow(pbuflist->phys);
-		icmd->un.xseq64.bdl.bdeFlags = BUFF_TYPE_BLP_64;
-		icmd->un.xseq64.bdl.bdeSize = sizeof(struct ulp_bde64);
-		icmd->un.xseq64.xmit_els_remoteID = did;	/* DID */
-		icmd->ulpCommand = CMD_XMIT_ELS_RSP64_CX;
-	}
-	icmd->ulpBdeCount = 1;
-	icmd->ulpLe = 1;
-	icmd->ulpClass = CLASS3;
-
-	/*
-	 * If we have NPIV enabled, we want to send ELS traffic by VPI.
-	 * For SLI4, since the driver controls VPIs we also want to include
-	 * all ELS pt2pt protocol traffic as well.
-	 */
-	if ((phba->sli3_options & LPFC_SLI3_NPIV_ENABLED) ||
-		((phba->sli_rev == LPFC_SLI_REV4) &&
-		    (vport->fc_flag & FC_PT2PT))) {
-
-		if (expectRsp) {
-			icmd->un.elsreq64.myID = vport->fc_myDID;
-
-			/* For ELS_REQUEST64_CR, use the VPI by default */
-			icmd->ulpContext = phba->vpi_ids[vport->vpi];
+	if (expect_rsp) {
+		switch (elscmd) {
+		case ELS_CMD_FLOGI:
+			timeout = FF_DEF_RATOV * 2;
+			break;
+		case ELS_CMD_LOGO:
+			timeout = phba->fc_ratov;
+			break;
+		default:
+			timeout = phba->fc_ratov * 2;
 		}
 
-		icmd->ulpCt_h = 0;
-		/* The CT field must be 0=INVALID_RPI for the ECHO cmd */
-		if (elscmd == ELS_CMD_ECHO)
-			icmd->ulpCt_l = 0; /* context = invalid RPI */
-		else
-			icmd->ulpCt_l = 1; /* context = VPI */
+		/* Fill SGE for the num bde count */
+		elsiocb->num_bdes = 2;
 	}
 
-	bpl = (struct ulp_bde64 *) pbuflist->virt;
-	bpl->addrLow = le32_to_cpu(putPaddrLow(pcmd->phys));
-	bpl->addrHigh = le32_to_cpu(putPaddrHigh(pcmd->phys));
-	bpl->tus.f.bdeSize = cmdSize;
-	bpl->tus.f.bdeFlags = 0;
-	bpl->tus.w = le32_to_cpu(bpl->tus.w);
+	if (phba->sli_rev == LPFC_SLI_REV4)
+		bmp = pcmd;
+	else
+		bmp = pbuflist;
+
+	lpfc_sli_prep_els_req_rsp(phba, elsiocb, vport, bmp, cmd_size, did,
+				  elscmd, timeout, expect_rsp);
 
-	if (expectRsp) {
+	bpl = (struct ulp_bde64_le *)pbuflist->virt;
+	bpl->addr_low = cpu_to_le32(putPaddrLow(pcmd->phys));
+	bpl->addr_high = cpu_to_le32(putPaddrHigh(pcmd->phys));
+	bpl->type_size = cpu_to_le32(cmd_size);
+	bpl->type_size |= cpu_to_le32(ULP_BDE64_TYPE_BDE_64);
+
+	if (expect_rsp) {
 		bpl++;
-		bpl->addrLow = le32_to_cpu(putPaddrLow(prsp->phys));
-		bpl->addrHigh = le32_to_cpu(putPaddrHigh(prsp->phys));
-		bpl->tus.f.bdeSize = FCELSSIZE;
-		bpl->tus.f.bdeFlags = BUFF_TYPE_BDE_64;
-		bpl->tus.w = le32_to_cpu(bpl->tus.w);
+		bpl->addr_low = cpu_to_le32(putPaddrLow(prsp->phys));
+		bpl->addr_high = cpu_to_le32(putPaddrHigh(prsp->phys));
+		bpl->type_size = cpu_to_le32(FCELSSIZE);
+		bpl->type_size |= cpu_to_le32(ULP_BDE64_TYPE_BDE_64);
 	}
 
 	elsiocb->context2 = pcmd;
@@ -316,18 +285,17 @@ lpfc_prep_els_iocb(struct lpfc_vport *vport, uint8_t expectRsp,
 	elsiocb->vport = vport;
 	elsiocb->drvrTimeout = (phba->fc_ratov << 1) + LPFC_DRVR_TIMEOUT;
 
-	if (prsp) {
+	if (prsp)
 		list_add(&prsp->list, &pcmd->list);
-	}
-	if (expectRsp) {
+	if (expect_rsp) {
 		/* Xmit ELS command <elsCmd> to remote NPORT <did> */
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
 				 "0116 Xmit ELS command x%x to remote "
 				 "NPORT x%x I/O tag: x%x, port state:x%x "
-				 "rpi x%x fc_flag:x%x nlp_flag:x%x vport:x%p\n",
+				 "rpi x%x fc_flag:x%x\n",
 				 elscmd, did, elsiocb->iotag,
 				 vport->port_state, ndlp->nlp_rpi,
-				 vport->fc_flag, ndlp->nlp_flag, vport);
+				 vport->fc_flag);
 	} else {
 		/* Xmit ELS response <elsCmd> to remote NPORT <did> */
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
@@ -335,13 +303,14 @@ lpfc_prep_els_iocb(struct lpfc_vport *vport, uint8_t expectRsp,
 				 "NPORT x%x I/O tag: x%x, size: x%x "
 				 "port_state x%x  rpi x%x fc_flag x%x\n",
 				 elscmd, ndlp->nlp_DID, elsiocb->iotag,
-				 cmdSize, vport->port_state,
+				 cmd_size, vport->port_state,
 				 ndlp->nlp_rpi, vport->fc_flag);
 	}
+
 	return elsiocb;
 
 els_iocb_free_pbuf_exit:
-	if (expectRsp)
+	if (expect_rsp)
 		lpfc_mbuf_free(phba, prsp->virt, prsp->phys);
 	kfree(pbuflist);
 
@@ -650,7 +619,7 @@ lpfc_check_clean_addr_bit(struct lpfc_vport *vport,
  * @vport: pointer to a host virtual N_Port data structure.
  * @ndlp: pointer to a node-list data structure.
  * @sp: pointer to service parameter data structure.
- * @irsp: pointer to the IOCB within the lpfc response IOCB.
+ * @ulp_word4: command response value
  *
  * This routine is invoked by the lpfc_cmpl_els_flogi() completion callback
  * function to handle the completion of a Fabric Login (FLOGI) into a fabric
@@ -667,7 +636,7 @@ lpfc_check_clean_addr_bit(struct lpfc_vport *vport,
  **/
 static int
 lpfc_cmpl_els_flogi_fabric(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
-			   struct serv_parm *sp, IOCB_t *irsp)
+			   struct serv_parm *sp, uint32_t ulp_word4)
 {
 	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 	struct lpfc_hba  *phba = vport->phba;
@@ -692,7 +661,7 @@ lpfc_cmpl_els_flogi_fabric(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		spin_unlock_irq(shost->host_lock);
 	}
 
-	vport->fc_myDID = irsp->un.ulpWord[4] & Mask_DID;
+	vport->fc_myDID = ulp_word4 & Mask_DID;
 	memcpy(&ndlp->nlp_portname, &sp->portName, sizeof(struct lpfc_name));
 	memcpy(&ndlp->nlp_nodename, &sp->nodeName, sizeof(struct lpfc_name));
 	ndlp->nlp_class_sup = 0;
@@ -903,10 +872,12 @@ lpfc_cmpl_els_flogi_nport(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		if (rc)
 			vport->fc_myDID = PT2PT_LocalID;
 
-		/* Decrement ndlp reference count indicating that ndlp can be
-		 * safely released when other references to it are done.
+		/* If not registered with a transport, decrement ndlp reference
+		 * count indicating that ndlp can be safely released when other
+		 * references are removed.
 		 */
-		lpfc_nlp_put(ndlp);
+		if (!(ndlp->fc4_xpt_flags & (SCSI_XPT_REGD | NVME_XPT_REGD)))
+			lpfc_nlp_put(ndlp);
 
 		ndlp = lpfc_findnode_did(vport, PT2PT_RemoteID);
 		if (!ndlp) {
@@ -943,11 +914,12 @@ lpfc_cmpl_els_flogi_nport(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 			goto fail;
 		}
 	} else {
-		/* This side will wait for the PLOGI, decrement ndlp reference
-		 * count indicating that ndlp can be released when other
-		 * references to it are done.
+		/* This side will wait for the PLOGI. If not registered with
+		 * a transport, decrement node reference count indicating that
+		 * ndlp can be released when other references are removed.
 		 */
-		lpfc_nlp_put(ndlp);
+		if (!(ndlp->fc4_xpt_flags & (SCSI_XPT_REGD | NVME_XPT_REGD)))
+			lpfc_nlp_put(ndlp);
 
 		/* Start discovery - this should just do CLEAR_LA */
 		lpfc_disc_start(vport);
@@ -987,28 +959,40 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 {
 	struct lpfc_vport *vport = cmdiocb->vport;
 	struct Scsi_Host  *shost = lpfc_shost_from_vport(vport);
-	IOCB_t *irsp = &rspiocb->iocb;
 	struct lpfc_nodelist *ndlp = cmdiocb->context1;
+	IOCB_t *irsp;
 	struct lpfc_dmabuf *pcmd = cmdiocb->context2, *prsp;
 	struct serv_parm *sp;
 	uint16_t fcf_index;
 	int rc;
+	u32 ulp_status, ulp_word4, tmo;
 
 	/* Check to see if link went down during discovery */
 	if (lpfc_els_chk_latt(vport)) {
 		/* One additional decrement on node reference count to
 		 * trigger the release of the node
 		 */
-		lpfc_nlp_put(ndlp);
+		if (!(ndlp->fc4_xpt_flags & SCSI_XPT_REGD))
+			lpfc_nlp_put(ndlp);
 		goto out;
 	}
 
+	ulp_status = get_job_ulpstatus(phba, rspiocb);
+	ulp_word4 = get_job_word4(phba, rspiocb);
+
+	if (phba->sli_rev == LPFC_SLI_REV4) {
+		tmo = get_wqe_tmo(cmdiocb);
+	} else {
+		irsp = &rspiocb->iocb;
+		tmo = irsp->ulpTimeout;
+	}
+
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
 		"FLOGI cmpl:      status:x%x/x%x state:x%x",
-		irsp->ulpStatus, irsp->un.ulpWord[4],
+		ulp_status, ulp_word4,
 		vport->port_state);
 
-	if (irsp->ulpStatus) {
+	if (ulp_status) {
 		/*
 		 * In case of FIP mode, perform roundrobin FCF failover
 		 * due to new FCF discovery
@@ -1019,8 +1003,8 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 				goto stop_rr_fcf_flogi;
 			if ((phba->fcoe_cvl_eventtag_attn ==
 			     phba->fcoe_cvl_eventtag) &&
-			    (irsp->ulpStatus == IOSTAT_LOCAL_REJECT) &&
-			    ((irsp->un.ulpWord[4] & IOERR_PARAM_MASK) ==
+			    (ulp_status == IOSTAT_LOCAL_REJECT) &&
+			    ((ulp_word4 & IOERR_PARAM_MASK) ==
 			    IOERR_SLI_ABORTED))
 				goto stop_rr_fcf_flogi;
 			else
@@ -1031,8 +1015,7 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 					"status:x%x/x%x, tmo:x%x, perform "
 					"roundrobin FCF failover\n",
 					phba->fcf.current_rec.fcf_indx,
-					irsp->ulpStatus, irsp->un.ulpWord[4],
-					irsp->ulpTimeout);
+					ulp_status, ulp_word4, tmo);
 			lpfc_sli4_set_fcf_flogi_fail(phba,
 					phba->fcf.current_rec.fcf_indx);
 			fcf_index = lpfc_sli4_fcf_rr_next_index_get(phba);
@@ -1043,15 +1026,14 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 
 stop_rr_fcf_flogi:
 		/* FLOGI failure */
-		if (!(irsp->ulpStatus == IOSTAT_LOCAL_REJECT &&
-		      ((irsp->un.ulpWord[4] & IOERR_PARAM_MASK) ==
+		if (!(ulp_status == IOSTAT_LOCAL_REJECT &&
+		      ((ulp_word4 & IOERR_PARAM_MASK) ==
 					IOERR_LOOP_OPEN_FAILURE)))
 			lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
 					 "2858 FLOGI failure Status:x%x/x%x TMO"
 					 ":x%x Data x%x x%x\n",
-					 irsp->ulpStatus, irsp->un.ulpWord[4],
-					 irsp->ulpTimeout, phba->hba_flag,
-					 phba->fcf.fcf_flag);
+					 ulp_status, ulp_word4, tmo,
+					 phba->hba_flag, phba->fcf.fcf_flag);
 
 		/* Check for retry */
 		if (lpfc_els_retry(phba, cmdiocb, rspiocb))
@@ -1060,15 +1042,20 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		lpfc_printf_vlog(vport, KERN_WARNING, LOG_TRACE_EVENT,
 				 "0150 FLOGI failure Status:x%x/x%x "
 				 "xri x%x TMO:x%x refcnt %d\n",
-				 irsp->ulpStatus, irsp->un.ulpWord[4],
-				 cmdiocb->sli4_xritag, irsp->ulpTimeout,
-				 kref_read(&ndlp->kref));
+				 ulp_status, ulp_word4, cmdiocb->sli4_xritag,
+				 tmo, kref_read(&ndlp->kref));
 
 		/* If this is not a loop open failure, bail out */
-		if (!(irsp->ulpStatus == IOSTAT_LOCAL_REJECT &&
-		      ((irsp->un.ulpWord[4] & IOERR_PARAM_MASK) ==
-					IOERR_LOOP_OPEN_FAILURE)))
+		if (!(ulp_status == IOSTAT_LOCAL_REJECT &&
+		      ((ulp_word4 & IOERR_PARAM_MASK) ==
+					IOERR_LOOP_OPEN_FAILURE))) {
+			/* FLOGI failure */
+			lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
+					 "0100 FLOGI failure Status:x%x/x%x "
+					 "TMO:x%x\n",
+					 ulp_status, ulp_word4, tmo);
 			goto flogifail;
+		}
 
 		/* FLOGI failed, so there is no fabric */
 		spin_lock_irq(shost->host_lock);
@@ -1099,7 +1086,7 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			}
 
 			/* Do not register VFI if the driver aborted FLOGI */
-			if (!lpfc_error_lost_link(irsp))
+			if (!lpfc_error_lost_link(ulp_status, ulp_word4))
 				lpfc_issue_reg_vfi(vport);
 
 			lpfc_nlp_put(ndlp);
@@ -1123,10 +1110,10 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 
 	/* FLOGI completes successfully */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
-			 "0101 FLOGI completes successfully, I/O tag:x%x, "
+			 "0101 FLOGI completes successfully, I/O tag:x%x "
 			 "xri x%x Data: x%x x%x x%x x%x x%x x%x x%x %d\n",
 			 cmdiocb->iotag, cmdiocb->sli4_xritag,
-			 irsp->un.ulpWord[4], sp->cmn.e_d_tov,
+			 ulp_word4, sp->cmn.e_d_tov,
 			 sp->cmn.w2.r_a_tov, sp->cmn.edtovResolution,
 			 vport->port_state, vport->fc_flag,
 			 sp->cmn.priority_tagging, kref_read(&ndlp->kref));
@@ -1140,7 +1127,8 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		 * we are point to point, if Fport we are Fabric.
 		 */
 		if (sp->cmn.fPort)
-			rc = lpfc_cmpl_els_flogi_fabric(vport, ndlp, sp, irsp);
+			rc = lpfc_cmpl_els_flogi_fabric(vport, ndlp, sp,
+							ulp_word4);
 		else if (!(phba->hba_flag & HBA_FCOE_MODE))
 			rc = lpfc_cmpl_els_flogi_nport(vport, ndlp, sp);
 		else {
@@ -1207,16 +1195,16 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	phba->fcf.fcf_flag &= ~FCF_DISCOVERY;
 	spin_unlock_irq(&phba->hbalock);
 
-	if (!lpfc_error_lost_link(irsp)) {
+	if (!lpfc_error_lost_link(ulp_status, ulp_word4)) {
 		/* FLOGI failed, so just use loop map to make discovery list */
 		lpfc_disc_list_loopmap(vport);
 
 		/* Start discovery */
 		lpfc_disc_start(vport);
-	} else if (((irsp->ulpStatus != IOSTAT_LOCAL_REJECT) ||
-			(((irsp->un.ulpWord[4] & IOERR_PARAM_MASK) !=
+	} else if (((ulp_status != IOSTAT_LOCAL_REJECT) ||
+			(((ulp_word4 & IOERR_PARAM_MASK) !=
 			 IOERR_SLI_ABORTED) &&
-			((irsp->un.ulpWord[4] & IOERR_PARAM_MASK) !=
+			((ulp_word4 & IOERR_PARAM_MASK) !=
 			 IOERR_SLI_DOWN))) &&
 			(phba->link_state != LPFC_CLEAR_LA)) {
 		/* If FLOGI failed enable link interrupt. */
@@ -1288,10 +1276,11 @@ lpfc_issue_els_flogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 {
 	struct lpfc_hba  *phba = vport->phba;
 	struct serv_parm *sp;
-	IOCB_t *icmd;
+	union lpfc_wqe128 *wqe = NULL;
+	IOCB_t *icmd = NULL;
 	struct lpfc_iocbq *elsiocb;
 	struct lpfc_iocbq defer_flogi_acc;
-	uint8_t *pcmd;
+	u8 *pcmd, ct;
 	uint16_t cmdsize;
 	uint32_t tmo, did;
 	int rc;
@@ -1303,8 +1292,9 @@ lpfc_issue_els_flogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	if (!elsiocb)
 		return 1;
 
-	icmd = &elsiocb->iocb;
+	wqe = &elsiocb->wqe;
 	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
+	icmd = &elsiocb->iocb;
 
 	/* For FLOGI request, remainder of payload is service parameters */
 	*((uint32_t *) (pcmd)) = ELS_CMD_FLOGI;
@@ -1337,12 +1327,15 @@ lpfc_issue_els_flogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	if  (phba->sli_rev == LPFC_SLI_REV4) {
 		if (bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) ==
 		    LPFC_SLI_INTF_IF_TYPE_0) {
-			elsiocb->iocb.ulpCt_h = ((SLI4_CT_FCFI >> 1) & 1);
-			elsiocb->iocb.ulpCt_l = (SLI4_CT_FCFI & 1);
 			/* FLOGI needs to be 3 for WQE FCFI */
+			ct = ((SLI4_CT_FCFI >> 1) & 1) | (SLI4_CT_FCFI & 1);
+			bf_set(wqe_ct, &wqe->els_req.wqe_com, ct);
+
 			/* Set the fcfi to the fcfi we registered with */
-			elsiocb->iocb.ulpContext = phba->fcf.fcfi;
+			bf_set(wqe_ctxt_tag, &wqe->els_req.wqe_com,
+			       phba->fcf.fcfi);
 		}
+
 		/* Can't do SLI4 class2 without support sequence coalescing */
 		sp->cls2.classValid = 0;
 		sp->cls2.seqDelivery = 0;
@@ -1355,13 +1348,14 @@ lpfc_issue_els_flogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 			/* For FLOGI, Let FLOGI rsp set the NPortID for VPI 0 */
 			icmd->ulpCt_h = 1;
 			icmd->ulpCt_l = 0;
-		} else
+		} else {
 			sp->cmn.request_multiple_Nport = 0;
-	}
+		}
 
-	if (phba->fc_topology != LPFC_TOPOLOGY_LOOP) {
-		icmd->un.elsreq64.myID = 0;
-		icmd->un.elsreq64.fl = 1;
+		if (phba->fc_topology != LPFC_TOPOLOGY_LOOP) {
+			icmd->un.elsreq64.myID = 0;
+			icmd->un.elsreq64.fl = 1;
+		}
 	}
 
 	tmo = phba->fc_ratov;
@@ -1393,14 +1387,29 @@ lpfc_issue_els_flogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 
 	/* Check for a deferred FLOGI ACC condition */
 	if (phba->defer_flogi_acc_flag) {
+		/* lookup ndlp for received FLOGI */
+		ndlp = lpfc_findnode_did(vport, 0);
+		if (!ndlp)
+			return 0;
+
 		did = vport->fc_myDID;
 		vport->fc_myDID = Fabric_DID;
 
 		memset(&defer_flogi_acc, 0, sizeof(struct lpfc_iocbq));
 
-		defer_flogi_acc.iocb.ulpContext = phba->defer_flogi_acc_rx_id;
-		defer_flogi_acc.iocb.unsli3.rcvsli3.ox_id =
-						phba->defer_flogi_acc_ox_id;
+		if (phba->sli_rev == LPFC_SLI_REV4) {
+			bf_set(wqe_ctxt_tag,
+			       &defer_flogi_acc.wqe.xmit_els_rsp.wqe_com,
+			       phba->defer_flogi_acc_rx_id);
+			bf_set(wqe_rcvoxid,
+			       &defer_flogi_acc.wqe.xmit_els_rsp.wqe_com,
+			       phba->defer_flogi_acc_ox_id);
+		} else {
+			icmd = &defer_flogi_acc.iocb;
+			icmd->ulpContext = phba->defer_flogi_acc_rx_id;
+			icmd->unsli3.rcvsli3.ox_id =
+				phba->defer_flogi_acc_ox_id;
+		}
 
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
 				 "3354 Xmit deferred FLOGI ACC: rx_id: x%x,"
@@ -1413,8 +1422,12 @@ lpfc_issue_els_flogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 				 ndlp, NULL);
 
 		phba->defer_flogi_acc_flag = false;
-
 		vport->fc_myDID = did;
+
+		/* Decrement ndlp reference count to indicate the node can be
+		 * released when other references are removed.
+		 */
+		lpfc_nlp_put(ndlp);
 	}
 
 	return 0;
@@ -1440,7 +1453,7 @@ lpfc_els_abort_flogi(struct lpfc_hba *phba)
 	struct lpfc_sli_ring *pring;
 	struct lpfc_iocbq *iocb, *next_iocb;
 	struct lpfc_nodelist *ndlp;
-	IOCB_t *icmd;
+	u32 ulp_command;
 
 	/* Abort outstanding I/O on NPort <nlp_DID> */
 	lpfc_printf_log(phba, KERN_INFO, LOG_DISCOVERY,
@@ -1457,8 +1470,8 @@ lpfc_els_abort_flogi(struct lpfc_hba *phba)
 	 */
 	spin_lock_irq(&phba->hbalock);
 	list_for_each_entry_safe(iocb, next_iocb, &pring->txcmplq, list) {
-		icmd = &iocb->iocb;
-		if (icmd->ulpCommand == CMD_ELS_REQUEST64_CR) {
+		ulp_command = get_job_cmnd(phba, iocb);
+		if (ulp_command == CMD_ELS_REQUEST64_CR) {
 			ndlp = (struct lpfc_nodelist *)(iocb->context1);
 			if (ndlp && ndlp->nlp_DID == Fabric_DID) {
 				if ((phba->pport->fc_flag & FC_PT2PT) &&
@@ -2034,7 +2047,7 @@ lpfc_cmpl_els_plogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 				 irsp->un.ulpWord[4]);
 
 		/* Do not call DSM for lpfc_els_abort'ed ELS cmds */
-		if (!lpfc_error_lost_link(irsp))
+		if (!lpfc_error_lost_link(irsp->ulpStatus, irsp->un.ulpWord[4]))
 			lpfc_disc_state_machine(vport, ndlp, cmdiocb,
 						NLP_EVT_CMPL_PLOGI);
 
@@ -2326,7 +2339,7 @@ lpfc_cmpl_els_prli(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 				 irsp->un.ulpWord[4], ndlp->fc4_prli_sent);
 
 		/* Do not call DSM for lpfc_els_abort'ed ELS cmds */
-		if (!lpfc_error_lost_link(irsp))
+		if (!lpfc_error_lost_link(irsp->ulpStatus, irsp->un.ulpWord[4]))
 			lpfc_disc_state_machine(vport, ndlp, cmdiocb,
 						NLP_EVT_CMPL_PRLI);
 
@@ -2936,7 +2949,7 @@ lpfc_cmpl_els_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 				 ndlp->nlp_DID, irsp->ulpStatus,
 				 irsp->un.ulpWord[4]);
 		/* Do not call DSM for lpfc_els_abort'ed ELS cmds */
-		if (lpfc_error_lost_link(irsp)) {
+		if (lpfc_error_lost_link(irsp->ulpStatus, irsp->un.ulpWord[4])) {
 			skip_recovery = 1;
 			goto out;
 		}
@@ -4435,7 +4448,7 @@ lpfc_els_retry(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	       struct lpfc_iocbq *rspiocb)
 {
 	struct lpfc_vport *vport = cmdiocb->vport;
-	IOCB_t *irsp = &rspiocb->iocb;
+	union lpfc_wqe128 *irsp = &rspiocb->wqe;
 	struct lpfc_nodelist *ndlp = (struct lpfc_nodelist *) cmdiocb->context1;
 	struct lpfc_dmabuf *pcmd = (struct lpfc_dmabuf *) cmdiocb->context2;
 	uint32_t *elscmd;
@@ -4445,6 +4458,8 @@ lpfc_els_retry(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	uint32_t cmd = 0;
 	uint32_t did;
 	int link_reset = 0, rc;
+	u32 ulp_status = get_job_ulpstatus(phba, rspiocb);
+	u32 ulp_word4 = get_job_word4(phba, rspiocb);
 
 
 	/* Note: context2 may be 0 for internal driver abort
@@ -4460,7 +4475,7 @@ lpfc_els_retry(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		did = ndlp->nlp_DID;
 	else {
 		/* We should only hit this case for retrying PLOGI */
-		did = irsp->un.elsreq64.remoteID;
+		did = get_job_els_rsp64_did(phba, rspiocb);
 		ndlp = lpfc_findnode_did(vport, did);
 		if (!ndlp && (cmd != ELS_CMD_PLOGI))
 			return 0;
@@ -4468,9 +4483,9 @@ lpfc_els_retry(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
 		"Retry ELS:       wd7:x%x wd4:x%x did:x%x",
-		*(((uint32_t *)irsp) + 7), irsp->un.ulpWord[4], did);
+		*(((uint32_t *)irsp) + 7), ulp_word4, did);
 
-	switch (irsp->ulpStatus) {
+	switch (ulp_status) {
 	case IOSTAT_FCP_RSP_ERROR:
 		break;
 	case IOSTAT_REMOTE_STOP:
@@ -4484,7 +4499,7 @@ lpfc_els_retry(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		}
 		break;
 	case IOSTAT_LOCAL_REJECT:
-		switch ((irsp->un.ulpWord[4] & IOERR_PARAM_MASK)) {
+		switch ((ulp_word4 & IOERR_PARAM_MASK)) {
 		case IOERR_LOOP_OPEN_FAILURE:
 			if (cmd == ELS_CMD_FLOGI) {
 				if (PCI_DEVICE_ID_HORNET ==
@@ -4552,7 +4567,7 @@ lpfc_els_retry(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 
 	case IOSTAT_NPORT_RJT:
 	case IOSTAT_FABRIC_RJT:
-		if (irsp->un.ulpWord[4] & RJT_UNAVAIL_TEMP) {
+		if (ulp_word4 & RJT_UNAVAIL_TEMP) {
 			retry = 1;
 			break;
 		}
@@ -4565,7 +4580,7 @@ lpfc_els_retry(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		break;
 
 	case IOSTAT_LS_RJT:
-		stat.un.lsRjtError = be32_to_cpu(irsp->un.ulpWord[4]);
+		stat.un.ls_rjt_error_be = cpu_to_be32(ulp_word4);
 		/* Added for Vendor specifc support
 		 * Just keep retrying for these Rsn / Exp codes
 		 */
@@ -4708,12 +4723,14 @@ lpfc_els_retry(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			 * on this rport.
 			 */
 			if (stat.un.b.lsRjtRsnCodeExp ==
-			    LSEXP_REQ_UNSUPPORTED && cmd == ELS_CMD_PRLI) {
-				spin_lock_irq(&ndlp->lock);
-				ndlp->nlp_flag |= NLP_FCP_PRLI_RJT;
-				spin_unlock_irq(&ndlp->lock);
-				retry = 0;
-				goto out_retry;
+			    LSEXP_REQ_UNSUPPORTED) {
+				if (cmd == ELS_CMD_PRLI) {
+					spin_lock_irq(&ndlp->lock);
+					ndlp->nlp_flag |= NLP_FCP_PRLI_RJT;
+					spin_unlock_irq(&ndlp->lock);
+					retry = 0;
+					goto out_retry;
+				}
 			}
 			break;
 		}
@@ -4745,7 +4762,7 @@ lpfc_els_retry(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 
 	if ((cmd == ELS_CMD_FLOGI) &&
 	    (phba->fc_topology != LPFC_TOPOLOGY_LOOP) &&
-	    !lpfc_error_lost_link(irsp)) {
+	    !lpfc_error_lost_link(ulp_status, ulp_word4)) {
 		/* FLOGI retry policy */
 		retry = 1;
 		/* retry FLOGI forever */
@@ -4758,7 +4775,8 @@ lpfc_els_retry(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			delay = 5000;
 		else if (cmdiocb->retry >= 32)
 			delay = 1000;
-	} else if ((cmd == ELS_CMD_FDISC) && !lpfc_error_lost_link(irsp)) {
+	} else if ((cmd == ELS_CMD_FDISC) &&
+	    !lpfc_error_lost_link(ulp_status, ulp_word4)) {
 		/* retry FDISCs every second up to devloss */
 		retry = 1;
 		maxretry = vport->cfg_devloss_tmo;
@@ -4795,8 +4813,8 @@ lpfc_els_retry(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 				 cmd, did, cmdiocb->retry, delay);
 
 		if (((cmd == ELS_CMD_PLOGI) || (cmd == ELS_CMD_ADISC)) &&
-			((irsp->ulpStatus != IOSTAT_LOCAL_REJECT) ||
-			((irsp->un.ulpWord[4] & IOERR_PARAM_MASK) !=
+			((ulp_status != IOSTAT_LOCAL_REJECT) ||
+			((ulp_word4 & IOERR_PARAM_MASK) !=
 			IOERR_NO_RESOURCES))) {
 			/* Don't reset timer for no resources */
 
@@ -4868,15 +4886,15 @@ lpfc_els_retry(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
 			 "0137 No retry ELS command x%x to remote "
 			 "NPORT x%x: Out of Resources: Error:x%x/%x\n",
-			 cmd, did, irsp->ulpStatus,
-			 irsp->un.ulpWord[4]);
+			 cmd, did, ulp_status,
+			 ulp_word4);
 	}
 	else {
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
 			 "0108 No retry ELS command x%x to remote "
 			 "NPORT x%x Retried:%d Error:x%x/%x\n",
-			 cmd, did, cmdiocb->retry, irsp->ulpStatus,
-			 irsp->un.ulpWord[4]);
+			 cmd, did, cmdiocb->retry, ulp_status,
+			 ulp_word4);
 	}
 	return 0;
 }
@@ -7825,7 +7843,7 @@ lpfc_els_rcv_flogi(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 	struct lpfc_hba  *phba = vport->phba;
 	struct lpfc_dmabuf *pcmd = (struct lpfc_dmabuf *) cmdiocb->context2;
 	uint32_t *lp = (uint32_t *) pcmd->virt;
-	IOCB_t *icmd = &cmdiocb->iocb;
+	union lpfc_wqe128 *wqe = &cmdiocb->wqe;
 	struct serv_parm *sp;
 	LPFC_MBOXQ_t *mbox;
 	uint32_t cmd, did;
@@ -7842,7 +7860,7 @@ lpfc_els_rcv_flogi(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 
 	if (phba->fc_topology == LPFC_TOPOLOGY_LOOP) {
 		/* We should never receive a FLOGI in loop mode, ignore it */
-		did = icmd->un.elsreq64.remoteID;
+		did =  bf_get(wqe_els_did, &wqe->xmit_els_rsp.wqe_dest);
 
 		/* An FLOGI ELS command <elsCmd> was received from DID <did> in
 		   Loop Mode */
@@ -7938,9 +7956,10 @@ lpfc_els_rcv_flogi(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 
 	/* Defer ACC response until AFTER we issue a FLOGI */
 	if (!(phba->hba_flag & HBA_FLOGI_ISSUED)) {
-		phba->defer_flogi_acc_rx_id = cmdiocb->iocb.ulpContext;
-		phba->defer_flogi_acc_ox_id =
-					cmdiocb->iocb.unsli3.rcvsli3.ox_id;
+		phba->defer_flogi_acc_rx_id = bf_get(wqe_ctxt_tag,
+						     &wqe->xmit_els_rsp.wqe_com);
+		phba->defer_flogi_acc_ox_id = bf_get(wqe_rcvoxid,
+						     &wqe->xmit_els_rsp.wqe_com);
 
 		vport->fc_myDID = did;
 
@@ -9912,6 +9931,9 @@ lpfc_els_unsol_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 		}
 
 		lpfc_els_rcv_flogi(vport, elsiocb, ndlp);
+		/* retain node if our response is deferred */
+		if (phba->defer_flogi_acc_flag)
+			break;
 		if (newnode)
 			lpfc_disc_state_machine(vport, ndlp, NULL,
 					NLP_EVT_DEVICE_RM);
@@ -10632,9 +10654,11 @@ lpfc_fabric_login_reqd(struct lpfc_hba *phba,
 		struct lpfc_iocbq *cmdiocb,
 		struct lpfc_iocbq *rspiocb)
 {
+	u32 ulp_status = get_job_ulpstatus(phba, rspiocb);
+	u32 ulp_word4 = get_job_word4(phba, rspiocb);
 
-	if ((rspiocb->iocb.ulpStatus != IOSTAT_FABRIC_RJT) ||
-		(rspiocb->iocb.un.ulpWord[4] != RJT_LOGIN_REQUIRED))
+	if (ulp_status != IOSTAT_FABRIC_RJT ||
+	    ulp_word4 != RJT_LOGIN_REQUIRED)
 		return 0;
 	else
 		return 1;
@@ -10669,15 +10693,18 @@ lpfc_cmpl_els_fdisc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	struct lpfc_nodelist *ndlp = (struct lpfc_nodelist *) cmdiocb->context1;
 	struct lpfc_nodelist *np;
 	struct lpfc_nodelist *next_np;
-	IOCB_t *irsp = &rspiocb->iocb;
 	struct lpfc_iocbq *piocb;
 	struct lpfc_dmabuf *pcmd = cmdiocb->context2, *prsp;
 	struct serv_parm *sp;
 	uint8_t fabric_param_changed;
+	u32 ulp_status, ulp_word4;
+
+	ulp_status = get_job_ulpstatus(phba, rspiocb);
+	ulp_word4 = get_job_word4(phba, rspiocb);
 
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
 			 "0123 FDISC completes. x%x/x%x prevDID: x%x\n",
-			 irsp->ulpStatus, irsp->un.ulpWord[4],
+			 ulp_status, ulp_word4,
 			 vport->fc_prevDID);
 	/* Since all FDISCs are being single threaded, we
 	 * must reset the discovery timer for ALL vports
@@ -10689,9 +10716,9 @@ lpfc_cmpl_els_fdisc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
 		"FDISC cmpl:      status:x%x/x%x prevdid:x%x",
-		irsp->ulpStatus, irsp->un.ulpWord[4], vport->fc_prevDID);
+		ulp_status, ulp_word4, vport->fc_prevDID);
 
-	if (irsp->ulpStatus) {
+	if (ulp_status) {
 
 		if (lpfc_fabric_login_reqd(phba, cmdiocb, rspiocb)) {
 			lpfc_retry_pport_discovery(phba);
@@ -10704,7 +10731,7 @@ lpfc_cmpl_els_fdisc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		/* FDISC failed */
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
 				 "0126 FDISC failed. (x%x/x%x)\n",
-				 irsp->ulpStatus, irsp->un.ulpWord[4]);
+				 ulp_status, ulp_word4);
 		goto fdisc_failed;
 	}
 
@@ -10718,7 +10745,7 @@ lpfc_cmpl_els_fdisc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		vport->fc_flag |=  FC_PUBLIC_LOOP;
 	spin_unlock_irq(shost->host_lock);
 
-	vport->fc_myDID = irsp->un.ulpWord[4] & Mask_DID;
+	vport->fc_myDID = ulp_word4 & Mask_DID;
 	lpfc_vport_set_state(vport, FC_VPORT_ACTIVE);
 	prsp = list_get_first(&pcmd->list, struct lpfc_dmabuf, list);
 	if (!prsp)
@@ -11070,7 +11097,6 @@ lpfc_resume_fabric_iocbs(struct lpfc_hba *phba)
 	struct lpfc_iocbq *iocb;
 	unsigned long iflags;
 	int ret;
-	IOCB_t *cmd;
 
 repeat:
 	iocb = NULL;
@@ -11090,8 +11116,8 @@ lpfc_resume_fabric_iocbs(struct lpfc_hba *phba)
 		iocb->cmd_flag |= LPFC_IO_FABRIC;
 
 		lpfc_debugfs_disc_trc(iocb->vport, LPFC_DISC_TRC_ELS_CMD,
-			"Fabric sched1:   ste:x%x",
-			iocb->vport->port_state, 0, 0);
+				      "Fabric sched1:   ste:x%x",
+				      iocb->vport->port_state, 0, 0);
 
 		ret = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, iocb, 0);
 
@@ -11099,9 +11125,8 @@ lpfc_resume_fabric_iocbs(struct lpfc_hba *phba)
 			iocb->cmd_cmpl = iocb->fabric_cmd_cmpl;
 			iocb->fabric_cmd_cmpl = NULL;
 			iocb->cmd_flag &= ~LPFC_IO_FABRIC;
-			cmd = &iocb->iocb;
-			cmd->ulpStatus = IOSTAT_LOCAL_REJECT;
-			cmd->un.ulpWord[4] = IOERR_SLI_ABORTED;
+			set_job_ulpstatus(iocb, IOSTAT_LOCAL_REJECT);
+			iocb->wcqe_cmpl.parameter = IOERR_SLI_ABORTED;
 			iocb->cmd_cmpl(phba, iocb, iocb);
 
 			atomic_dec(&phba->fabric_iocb_count);
@@ -11166,18 +11191,19 @@ lpfc_block_fabric_iocbs(struct lpfc_hba *phba)
  **/
 static void
 lpfc_cmpl_fabric_iocb(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
-	struct lpfc_iocbq *rspiocb)
+		      struct lpfc_iocbq *rspiocb)
 {
 	struct ls_rjt stat;
+	u32 ulp_status = get_job_ulpstatus(phba, rspiocb);
+	u32 ulp_word4 = get_job_word4(phba, rspiocb);
 
 	WARN_ON((cmdiocb->cmd_flag & LPFC_IO_FABRIC) != LPFC_IO_FABRIC);
 
-	switch (rspiocb->iocb.ulpStatus) {
+	switch (ulp_status) {
 		case IOSTAT_NPORT_RJT:
 		case IOSTAT_FABRIC_RJT:
-			if (rspiocb->iocb.un.ulpWord[4] & RJT_UNAVAIL_TEMP) {
+			if (ulp_word4 & RJT_UNAVAIL_TEMP)
 				lpfc_block_fabric_iocbs(phba);
-			}
 			break;
 
 		case IOSTAT_NPORT_BSY:
@@ -11186,8 +11212,8 @@ lpfc_cmpl_fabric_iocb(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			break;
 
 		case IOSTAT_LS_RJT:
-			stat.un.lsRjtError =
-				be32_to_cpu(rspiocb->iocb.un.ulpWord[4]);
+			stat.un.ls_rjt_error_be =
+				cpu_to_be32(ulp_word4);
 			if ((stat.un.b.lsRjtRsnCode == LSRJT_UNABLE_TPC) ||
 				(stat.un.b.lsRjtRsnCode == LSRJT_LOGICAL_BSY))
 				lpfc_block_fabric_iocbs(phba);
@@ -11255,8 +11281,8 @@ lpfc_issue_fabric_iocb(struct lpfc_hba *phba, struct lpfc_iocbq *iocb)
 		iocb->cmd_flag |= LPFC_IO_FABRIC;
 
 		lpfc_debugfs_disc_trc(iocb->vport, LPFC_DISC_TRC_ELS_CMD,
-			"Fabric sched2:   ste:x%x",
-			iocb->vport->port_state, 0, 0);
+				      "Fabric sched2:   ste:x%x",
+				      iocb->vport->port_state, 0, 0);
 
 		ret = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, iocb, 0);
 
diff --git a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
index 634f8fff7425..7c4479c0b697 100644
--- a/drivers/scsi/lpfc/lpfc_hw.h
+++ b/drivers/scsi/lpfc/lpfc_hw.h
@@ -664,6 +664,7 @@ struct fc_vft_header {
 
 struct ls_rjt {	/* Structure is in Big Endian format */
 	union {
+		__be32 ls_rjt_error_be;
 		uint32_t lsRjtError;
 		struct {
 			uint8_t lsRjtRsvd0;	/* FC Word 0, bit 24:31 */
@@ -4369,16 +4370,15 @@ lpfc_is_LC_HBA(unsigned short device)
 }
 
 /*
- * Determine if an IOCB failed because of a link event or firmware reset.
+ * Determine if failed because of a link event or firmware reset.
  */
-
 static inline int
-lpfc_error_lost_link(IOCB_t *iocbp)
+lpfc_error_lost_link(u32 ulp_status, u32 ulp_word4)
 {
-	return (iocbp->ulpStatus == IOSTAT_LOCAL_REJECT &&
-		(iocbp->un.ulpWord[4] == IOERR_SLI_ABORTED ||
-		 iocbp->un.ulpWord[4] == IOERR_LINK_DOWN ||
-		 iocbp->un.ulpWord[4] == IOERR_SLI_DOWN));
+	return (ulp_status == IOSTAT_LOCAL_REJECT &&
+		(ulp_word4 == IOERR_SLI_ABORTED ||
+		 ulp_word4 == IOERR_LINK_DOWN ||
+		 ulp_word4 == IOERR_SLI_DOWN));
 }
 
 #define MENLO_TRANSPORT_TYPE 0xfe
diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index 215fbf1c777e..8d2eda77afea 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -61,6 +61,7 @@
 		 ((ptr)->name##_WORD & ~(name##_MASK << name##_SHIFT))))
 
 #define get_wqe_reqtag(x)	(((x)->wqe.words[9] >>  0) & 0xFFFF)
+#define get_wqe_tmo(x)		(((x)->wqe.words[7] >> 24) & 0x00FF)
 
 #define get_job_ulpword(x, y)	((x)->iocb.un.ulpWord[y])
 
@@ -237,6 +238,34 @@ struct lpfc_sli_intf {
 /* PORT_CAPABILITIES constants. */
 #define LPFC_MAX_SUPPORTED_PAGES	8
 
+enum ulp_bde64_word3 {
+	ULP_BDE64_SIZE_MASK		= 0xffffff,
+
+	ULP_BDE64_TYPE_SHIFT		= 24,
+	ULP_BDE64_TYPE_MASK		= (0xff << ULP_BDE64_TYPE_SHIFT),
+
+	/* BDE (Host_resident) */
+	ULP_BDE64_TYPE_BDE_64		= (0x00 << ULP_BDE64_TYPE_SHIFT),
+	/* Immediate Data BDE */
+	ULP_BDE64_TYPE_BDE_IMMED	= (0x01 << ULP_BDE64_TYPE_SHIFT),
+	/* BDE (Port-resident) */
+	ULP_BDE64_TYPE_BDE_64P		= (0x02 << ULP_BDE64_TYPE_SHIFT),
+	/* Input BDE (Host-resident) */
+	ULP_BDE64_TYPE_BDE_64I		= (0x08 << ULP_BDE64_TYPE_SHIFT),
+	/* Input BDE (Port-resident) */
+	ULP_BDE64_TYPE_BDE_64IP		= (0x0A << ULP_BDE64_TYPE_SHIFT),
+	/* BLP (Host-resident) */
+	ULP_BDE64_TYPE_BLP_64		= (0x40 << ULP_BDE64_TYPE_SHIFT),
+	/* BLP (Port-resident) */
+	ULP_BDE64_TYPE_BLP_64P		= (0x42 << ULP_BDE64_TYPE_SHIFT),
+};
+
+struct ulp_bde64_le {
+	__le32 type_size; /* type 31:24, size 23:0 */
+	__le32 addr_low;
+	__le32 addr_high;
+};
+
 struct ulp_bde64 {
 	union ULP_BDE_TUS {
 		uint32_t w;
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 43b0bc3f7e61..3bd3b42c49b3 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -11178,6 +11178,130 @@ __lpfc_sli_issue_iocb(struct lpfc_hba *phba, uint32_t ring_number,
 	return phba->__lpfc_sli_issue_iocb(phba, ring_number, piocb, flag);
 }
 
+static void
+__lpfc_sli_prep_els_req_rsp_s3(struct lpfc_iocbq *cmdiocbq,
+			       struct lpfc_vport *vport,
+			       struct lpfc_dmabuf *bmp, u16 cmd_size, u32 did,
+			       u32 elscmd, u8 tmo, u8 expect_rsp)
+{
+	struct lpfc_hba *phba = vport->phba;
+	IOCB_t *cmd;
+
+	cmd = &cmdiocbq->iocb;
+	memset(cmd, 0, sizeof(*cmd));
+
+	cmd->un.elsreq64.bdl.addrHigh = putPaddrHigh(bmp->phys);
+	cmd->un.elsreq64.bdl.addrLow = putPaddrLow(bmp->phys);
+	cmd->un.elsreq64.bdl.bdeFlags = BUFF_TYPE_BLP_64;
+
+	if (expect_rsp) {
+		cmd->un.elsreq64.bdl.bdeSize = (2 * sizeof(struct ulp_bde64));
+		cmd->un.elsreq64.remoteID = did; /* DID */
+		cmd->ulpCommand = CMD_ELS_REQUEST64_CR;
+		cmd->ulpTimeout = tmo;
+	} else {
+		cmd->un.elsreq64.bdl.bdeSize = sizeof(struct ulp_bde64);
+		cmd->un.genreq64.xmit_els_remoteID = did; /* DID */
+		cmd->ulpCommand = CMD_XMIT_ELS_RSP64_CX;
+	}
+	cmd->ulpBdeCount = 1;
+	cmd->ulpLe = 1;
+	cmd->ulpClass = CLASS3;
+
+	/* If we have NPIV enabled, we want to send ELS traffic by VPI. */
+	if (phba->sli3_options & LPFC_SLI3_NPIV_ENABLED) {
+		if (expect_rsp) {
+			cmd->un.elsreq64.myID = vport->fc_myDID;
+
+			/* For ELS_REQUEST64_CR, use the VPI by default */
+			cmd->ulpContext = phba->vpi_ids[vport->vpi];
+		}
+
+		cmd->ulpCt_h = 0;
+		/* The CT field must be 0=INVALID_RPI for the ECHO cmd */
+		if (elscmd == ELS_CMD_ECHO)
+			cmd->ulpCt_l = 0; /* context = invalid RPI */
+		else
+			cmd->ulpCt_l = 1; /* context = VPI */
+	}
+}
+
+static void
+__lpfc_sli_prep_els_req_rsp_s4(struct lpfc_iocbq *cmdiocbq,
+			       struct lpfc_vport *vport,
+			       struct lpfc_dmabuf *bmp, u16 cmd_size, u32 did,
+			       u32 elscmd, u8 tmo, u8 expect_rsp)
+{
+	struct lpfc_hba  *phba = vport->phba;
+	union lpfc_wqe128 *wqe;
+	struct ulp_bde64_le *bde;
+
+	wqe = &cmdiocbq->wqe;
+	memset(wqe, 0, sizeof(*wqe));
+
+	/* Word 0 - 2 BDE */
+	bde = (struct ulp_bde64_le *)&wqe->generic.bde;
+	bde->addr_low = cpu_to_le32(putPaddrLow(bmp->phys));
+	bde->addr_high = cpu_to_le32(putPaddrHigh(bmp->phys));
+	bde->type_size = cpu_to_le32(cmd_size);
+	bde->type_size |= cpu_to_le32(ULP_BDE64_TYPE_BDE_64);
+
+	if (expect_rsp) {
+		bf_set(wqe_cmnd, &wqe->els_req.wqe_com, CMD_ELS_REQUEST64_CR);
+
+		/* Transfer length */
+		wqe->els_req.payload_len = cmd_size;
+		wqe->els_req.max_response_payload_len = FCELSSIZE;
+
+		/* DID */
+		bf_set(wqe_els_did, &wqe->els_req.wqe_dest, did);
+	} else {
+		/* DID */
+		bf_set(wqe_els_did, &wqe->xmit_els_rsp.wqe_dest, did);
+
+		/* Transfer length */
+		wqe->xmit_els_rsp.response_payload_len = cmd_size;
+
+		bf_set(wqe_cmnd, &wqe->xmit_els_rsp.wqe_com,
+		       CMD_XMIT_ELS_RSP64_CX);
+	}
+
+	bf_set(wqe_tmo, &wqe->generic.wqe_com, tmo);
+	bf_set(wqe_reqtag, &wqe->generic.wqe_com, cmdiocbq->iotag);
+	bf_set(wqe_class, &wqe->generic.wqe_com, CLASS3);
+
+	/* If we have NPIV enabled, we want to send ELS traffic by VPI.
+	 * For SLI4, since the driver controls VPIs we also want to include
+	 * all ELS pt2pt protocol traffic as well.
+	 */
+	if ((phba->sli3_options & LPFC_SLI3_NPIV_ENABLED) ||
+	    (vport->fc_flag & FC_PT2PT)) {
+		if (expect_rsp) {
+			bf_set(els_req64_sid, &wqe->els_req, vport->fc_myDID);
+
+			/* For ELS_REQUEST64_CR, use the VPI by default */
+			bf_set(wqe_ctxt_tag, &wqe->els_req.wqe_com,
+			       phba->vpi_ids[vport->vpi]);
+		}
+
+		/* The CT field must be 0=INVALID_RPI for the ECHO cmd */
+		if (elscmd == ELS_CMD_ECHO)
+			bf_set(wqe_ct, &wqe->generic.wqe_com, 0);
+		else
+			bf_set(wqe_ct, &wqe->generic.wqe_com, 1);
+	}
+}
+
+void
+lpfc_sli_prep_els_req_rsp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocbq,
+			  struct lpfc_vport *vport, struct lpfc_dmabuf *bmp,
+			  u16 cmd_size, u32 did, u32 elscmd, u8 tmo,
+			  u8 expect_rsp)
+{
+	phba->__lpfc_sli_prep_els_req_rsp(cmdiocbq, vport, bmp, cmd_size, did,
+					  elscmd, tmo, expect_rsp);
+}
+
 /**
  * lpfc_sli_api_table_setup - Set up sli api function jump table
  * @phba: The hba struct for which this call is being executed.
@@ -11196,11 +11320,13 @@ lpfc_sli_api_table_setup(struct lpfc_hba *phba, uint8_t dev_grp)
 		phba->__lpfc_sli_issue_iocb = __lpfc_sli_issue_iocb_s3;
 		phba->__lpfc_sli_release_iocbq = __lpfc_sli_release_iocbq_s3;
 		phba->__lpfc_sli_issue_fcp_io = __lpfc_sli_issue_fcp_io_s3;
+		phba->__lpfc_sli_prep_els_req_rsp = __lpfc_sli_prep_els_req_rsp_s3;
 		break;
 	case LPFC_PCI_DEV_OC:
 		phba->__lpfc_sli_issue_iocb = __lpfc_sli_issue_iocb_s4;
 		phba->__lpfc_sli_release_iocbq = __lpfc_sli_release_iocbq_s4;
 		phba->__lpfc_sli_issue_fcp_io = __lpfc_sli_issue_fcp_io_s4;
+		phba->__lpfc_sli_prep_els_req_rsp = __lpfc_sli_prep_els_req_rsp_s4;
 		break;
 	default:
 		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
@@ -19235,7 +19361,7 @@ lpfc_sli4_handle_mds_loopback(struct lpfc_vport *vport,
 	struct fc_frame_header *fc_hdr;
 	struct lpfc_hba *phba = vport->phba;
 	struct lpfc_iocbq *iocbq = NULL;
-	union  lpfc_wqe *wqe;
+	union  lpfc_wqe128 *pwqe;
 	struct lpfc_dmabuf *pcmd = NULL;
 	uint32_t frame_len;
 	int rc;
@@ -19270,34 +19396,46 @@ lpfc_sli4_handle_mds_loopback(struct lpfc_vport *vport,
 	/* copyin the payload */
 	memcpy(pcmd->virt, dmabuf->dbuf.virt, frame_len);
 
-	/* fill in BDE's for command */
-	iocbq->iocb.un.xseq64.bdl.addrHigh = putPaddrHigh(pcmd->phys);
-	iocbq->iocb.un.xseq64.bdl.addrLow = putPaddrLow(pcmd->phys);
-	iocbq->iocb.un.xseq64.bdl.bdeFlags = BUFF_TYPE_BDE_64;
-	iocbq->iocb.un.xseq64.bdl.bdeSize = frame_len;
-
 	iocbq->context2 = pcmd;
 	iocbq->vport = vport;
 	iocbq->cmd_flag &= ~LPFC_FIP_ELS_ID_MASK;
 	iocbq->cmd_flag |= LPFC_USE_FCPWQIDX;
+	iocbq->num_bdes = 0;
+
+	pwqe = &iocbq->wqe;
+	/* fill in BDE's for command */
+	pwqe->gen_req.bde.addrHigh = putPaddrHigh(pcmd->phys);
+	pwqe->gen_req.bde.addrLow = putPaddrLow(pcmd->phys);
+	pwqe->gen_req.bde.tus.f.bdeSize = frame_len;
+	pwqe->gen_req.bde.tus.f.bdeFlags = BUFF_TYPE_BDE_64;
+
+	pwqe->send_frame.frame_len = frame_len;
+	pwqe->send_frame.fc_hdr_wd0 = be32_to_cpu(*((__be32 *)fc_hdr));
+	pwqe->send_frame.fc_hdr_wd1 = be32_to_cpu(*((__be32 *)fc_hdr + 1));
+	pwqe->send_frame.fc_hdr_wd2 = be32_to_cpu(*((__be32 *)fc_hdr + 2));
+	pwqe->send_frame.fc_hdr_wd3 = be32_to_cpu(*((__be32 *)fc_hdr + 3));
+	pwqe->send_frame.fc_hdr_wd4 = be32_to_cpu(*((__be32 *)fc_hdr + 4));
+	pwqe->send_frame.fc_hdr_wd5 = be32_to_cpu(*((__be32 *)fc_hdr + 5));
+
+	pwqe->generic.wqe_com.word7 = 0;
+	pwqe->generic.wqe_com.word10 = 0;
+
+	bf_set(wqe_cmnd, &pwqe->generic.wqe_com, CMD_SEND_FRAME);
+	bf_set(wqe_sof, &pwqe->generic.wqe_com, 0x2E); /* SOF byte */
+	bf_set(wqe_eof, &pwqe->generic.wqe_com, 0x41); /* EOF byte */
+	bf_set(wqe_lenloc, &pwqe->generic.wqe_com, 1);
+	bf_set(wqe_xbl, &pwqe->generic.wqe_com, 1);
+	bf_set(wqe_dbde, &pwqe->generic.wqe_com, 1);
+	bf_set(wqe_xc, &pwqe->generic.wqe_com, 1);
+	bf_set(wqe_cmd_type, &pwqe->generic.wqe_com, 0xA);
+	bf_set(wqe_cqid, &pwqe->generic.wqe_com, LPFC_WQE_CQ_ID_DEFAULT);
+	bf_set(wqe_xri_tag, &pwqe->generic.wqe_com, iocbq->sli4_xritag);
+	bf_set(wqe_reqtag, &pwqe->generic.wqe_com, iocbq->iotag);
+	bf_set(wqe_class, &pwqe->generic.wqe_com, CLASS3);
+	pwqe->generic.wqe_com.abort_tag = iocbq->iotag;
 
-	/*
-	 * Setup rest of the iocb as though it were a WQE
-	 * Build the SEND_FRAME WQE
-	 */
-	wqe = (union lpfc_wqe *)&iocbq->iocb;
-
-	wqe->send_frame.frame_len = frame_len;
-	wqe->send_frame.fc_hdr_wd0 = be32_to_cpu(*((uint32_t *)fc_hdr));
-	wqe->send_frame.fc_hdr_wd1 = be32_to_cpu(*((uint32_t *)fc_hdr + 1));
-	wqe->send_frame.fc_hdr_wd2 = be32_to_cpu(*((uint32_t *)fc_hdr + 2));
-	wqe->send_frame.fc_hdr_wd3 = be32_to_cpu(*((uint32_t *)fc_hdr + 3));
-	wqe->send_frame.fc_hdr_wd4 = be32_to_cpu(*((uint32_t *)fc_hdr + 4));
-	wqe->send_frame.fc_hdr_wd5 = be32_to_cpu(*((uint32_t *)fc_hdr + 5));
-
-	iocbq->iocb.ulpCommand = CMD_SEND_FRAME;
-	iocbq->iocb.ulpLe = 1;
 	iocbq->cmd_cmpl = lpfc_sli4_mds_loopback_cmpl;
+
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, iocbq, 0);
 	if (rc == IOCB_ERROR)
 		goto exit;
-- 
2.35.3

