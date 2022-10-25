Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EED160D77D
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 00:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232786AbiJYW6b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 18:58:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231381AbiJYW6a (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 18:58:30 -0400
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B56CCABC4
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 15:58:28 -0700 (PDT)
Received: by mail-qv1-xf2c.google.com with SMTP id e15so9873701qvo.4
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 15:58:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+zvbNplWDoxpJ7Z0lHf/JpJSzgmoIUCawcecBboH3aQ=;
        b=Z37MxaGnAjPVcQKHILSA2+3OCfmS6IkH0Ub8XHeup+egoebpPKdrEcXtnKhZ/QWmUL
         JNQOn9uUqrZNOVEk1IUE2Oyu/2/G1T9le4dFyfSKwXTUvLJTVwiKTPtrSSURfQJ8Jk42
         fMylQcXPfhh2ERluL0w6jtcBQVllu9HGLnrXuRCPZh2iF32wKZkYOqlACsBL5tzpes4O
         f4Qfk8GMOHCOYWL7b7AWHDYs3msz7VKd7Nq9mYcEDT34qdoDgmEfZJ4MwLqtnKG0SaYy
         01dErD+QSE5wL5K57LsxrpQwrd+C6ksNLW+Q2XinCdoYZGFQWkoq9bt04NxYrO7KlrU4
         5FZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+zvbNplWDoxpJ7Z0lHf/JpJSzgmoIUCawcecBboH3aQ=;
        b=MSEq961AAE2FqY28k4Bso/gyU5qwMaq1/rIiQOAVlkWY3iDoZCnnk3huVf9+Gxk8IV
         k+HoRQKCmMJRApPU0mnzzDHgh8+MmBIMXbwpa6AMe96kLwSwLIl6Es1Al67ofSePCrnU
         nQcppqdWmoAXAs/tgprSK8VXCVPUwbI0OdwqDmF126BlUvc4uWPCXzkZ46urfdxh98na
         m23lJZw9Tz9FZ9IydplHzaw4Ue82n1NETtMUwYpV1z2UbRcjWAI6iV1se/xWgWDhJKt+
         XNjSfZ7z4T5IV3aGhXSq6JYpqzDyTV05FxbQxhZC6+HiOB0Ckc/q4FhRPQoKKXIz8SEm
         EyEQ==
X-Gm-Message-State: ACrzQf0esfh97dQ7/0QNFViwoDURZoO2lmwyl10zZufvvCv3QbwlSm8d
        uBfFqMBqhVE+XE3nw5Dq9VLt/SopoUk=
X-Google-Smtp-Source: AMsMyM7VGaAyGEfrrwCpFgjXdmF2nmKPMQCCvcTNwbsNuJ0Gv1gnq52Kt6WGjLyDlEWRYKHBo3ur0g==
X-Received: by 2002:ad4:4ea3:0:b0:4bb:6b59:9785 with SMTP id ed3-20020ad44ea3000000b004bb6b599785mr11624697qvb.118.1666738706802;
        Tue, 25 Oct 2022 15:58:26 -0700 (PDT)
Received: from mail-ash-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r12-20020ae9d60c000000b006ecdfcf9d81sm2823766qkk.84.2022.10.25.15.58.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 15:58:26 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     stable@vger.kernel.org
Cc:     jsmart2021@gmail.com, justintee8345@gmail.com,
        martin.petersen@oracle.com, gregkh@linuxfoundation.org,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 12/33] scsi: lpfc: SLI path split: Refactor PLOGI/PRLI/ADISC/LOGO paths
Date:   Tue, 25 Oct 2022 15:57:18 -0700
Message-Id: <20221025225739.85182-13-jsmart2021@gmail.com>
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

This patch refactors the PLOGI/PRLI/ADISC/LOGO paths to use SLI-4 as
the primary interface:

 - Conversion away from using SLI-3 iocb structures to set/access fields in
   common routines. Use the new generic get/set routines that were added.
   This move changes code from indirect structure references to using local
   variables with the generic routines.

 - Refactor routines when setting non-generic fields, to have both SLI3 and
   SLI4 specific sections. This replaces the set-as-SLI3 then translate to
   SLI4 behavior of the past.

Link: https://lore.kernel.org/r/20220225022308.16486-6-jsmart2021@gmail.com
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/lpfc/lpfc.h           |   9 +
 drivers/scsi/lpfc/lpfc_els.c       | 278 ++++++++++++++++++++---------
 drivers/scsi/lpfc/lpfc_nportdisc.c |  60 ++++---
 3 files changed, 242 insertions(+), 105 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 2c304fd2c4a7..779b06a9aecc 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -1846,6 +1846,15 @@ u16 get_job_ulpcontext(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq)
 		return iocbq->iocb.ulpContext;
 }
 
+static inline
+u16 get_job_rcvoxid(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq)
+{
+	if (phba->sli_rev == LPFC_SLI_REV4)
+		return bf_get(wqe_rcvoxid, &iocbq->wqe.generic.wqe_com);
+	else
+		return iocbq->iocb.unsli3.rcvsli3.ox_id;
+}
+
 static inline
 u32 get_job_els_rsp64_did(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq)
 {
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 5bf57923d92e..1ad08e1f8baa 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1980,24 +1980,32 @@ lpfc_cmpl_els_plogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	struct lpfc_dmabuf *prsp;
 	int disc;
 	struct serv_parm *sp = NULL;
+	u32 ulp_status, ulp_word4, did, iotag;
 
 	/* we pass cmdiocb to state machine which needs rspiocb as well */
 	cmdiocb->context_un.rsp_iocb = rspiocb;
 
-	irsp = &rspiocb->iocb;
+	ulp_status = get_job_ulpstatus(phba, rspiocb);
+	ulp_word4 = get_job_word4(phba, rspiocb);
+	did = get_job_els_rsp64_did(phba, cmdiocb);
+
+	if (phba->sli_rev == LPFC_SLI_REV4) {
+		iotag = get_wqe_reqtag(cmdiocb);
+	} else {
+		irsp = &rspiocb->iocb;
+		iotag = irsp->ulpIoTag;
+	}
+
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
 		"PLOGI cmpl:      status:x%x/x%x did:x%x",
-		irsp->ulpStatus, irsp->un.ulpWord[4],
-		irsp->un.elsreq64.remoteID);
+		ulp_status, ulp_word4, did);
 
-	ndlp = lpfc_findnode_did(vport, irsp->un.elsreq64.remoteID);
+	ndlp = lpfc_findnode_did(vport, did);
 	if (!ndlp) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
 				 "0136 PLOGI completes to NPort x%x "
 				 "with no ndlp. Data: x%x x%x x%x\n",
-				 irsp->un.elsreq64.remoteID,
-				 irsp->ulpStatus, irsp->un.ulpWord[4],
-				 irsp->ulpIoTag);
+				 did, ulp_status, ulp_word4, iotag);
 		goto out_freeiocb;
 	}
 
@@ -2014,7 +2022,7 @@ lpfc_cmpl_els_plogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			 "0102 PLOGI completes to NPort x%06x "
 			 "Data: x%x x%x x%x x%x x%x\n",
 			 ndlp->nlp_DID, ndlp->nlp_fc4_type,
-			 irsp->ulpStatus, irsp->un.ulpWord[4],
+			 ulp_status, ulp_word4,
 			 disc, vport->num_disc_nodes);
 
 	/* Check to see if link went down during discovery */
@@ -2025,7 +2033,7 @@ lpfc_cmpl_els_plogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		goto out;
 	}
 
-	if (irsp->ulpStatus) {
+	if (ulp_status) {
 		/* Check for retry */
 		if (lpfc_els_retry(phba, cmdiocb, rspiocb)) {
 			/* ELS command is being retried */
@@ -2037,17 +2045,18 @@ lpfc_cmpl_els_plogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			goto out;
 		}
 		/* PLOGI failed Don't print the vport to vport rjts */
-		if (irsp->ulpStatus != IOSTAT_LS_RJT ||
-			(((irsp->un.ulpWord[4]) >> 16 != LSRJT_INVALID_CMD) &&
-			((irsp->un.ulpWord[4]) >> 16 != LSRJT_UNABLE_TPC)) ||
-			(phba)->pport->cfg_log_verbose & LOG_ELS)
+		if (ulp_status != IOSTAT_LS_RJT ||
+		    (((ulp_word4) >> 16 != LSRJT_INVALID_CMD) &&
+		     ((ulp_word4) >> 16 != LSRJT_UNABLE_TPC)) ||
+		    (phba)->pport->cfg_log_verbose & LOG_ELS)
 			lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
-				 "2753 PLOGI failure DID:%06X Status:x%x/x%x\n",
-				 ndlp->nlp_DID, irsp->ulpStatus,
-				 irsp->un.ulpWord[4]);
+					 "2753 PLOGI failure DID:%06X "
+					 "Status:x%x/x%x\n",
+					 ndlp->nlp_DID, ulp_status,
+					 ulp_word4);
 
 		/* Do not call DSM for lpfc_els_abort'ed ELS cmds */
-		if (!lpfc_error_lost_link(irsp->ulpStatus, irsp->un.ulpWord[4]))
+		if (!lpfc_error_lost_link(ulp_status, ulp_word4))
 			lpfc_disc_state_machine(vport, ndlp, cmdiocb,
 						NLP_EVT_CMPL_PLOGI);
 
@@ -2278,16 +2287,20 @@ lpfc_cmpl_els_prli(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		   struct lpfc_iocbq *rspiocb)
 {
 	struct lpfc_vport *vport = cmdiocb->vport;
-	IOCB_t *irsp;
 	struct lpfc_nodelist *ndlp;
 	char *mode;
 	u32 loglevel;
+	u32 ulp_status;
+	u32 ulp_word4;
 
 	/* we pass cmdiocb to state machine which needs rspiocb as well */
 	cmdiocb->context_un.rsp_iocb = rspiocb;
 
-	irsp = &(rspiocb->iocb);
 	ndlp = (struct lpfc_nodelist *) cmdiocb->context1;
+
+	ulp_status = get_job_ulpstatus(phba, rspiocb);
+	ulp_word4 = get_job_word4(phba, rspiocb);
+
 	spin_lock_irq(&ndlp->lock);
 	ndlp->nlp_flag &= ~NLP_PRLI_SND;
 
@@ -2298,21 +2311,21 @@ lpfc_cmpl_els_prli(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
 		"PRLI cmpl:       status:x%x/x%x did:x%x",
-		irsp->ulpStatus, irsp->un.ulpWord[4],
+		ulp_status, ulp_word4,
 		ndlp->nlp_DID);
 
 	/* PRLI completes to NPort <nlp_DID> */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
 			 "0103 PRLI completes to NPort x%06x "
 			 "Data: x%x x%x x%x x%x\n",
-			 ndlp->nlp_DID, irsp->ulpStatus, irsp->un.ulpWord[4],
+			 ndlp->nlp_DID, ulp_status, ulp_word4,
 			 vport->num_disc_nodes, ndlp->fc4_prli_sent);
 
 	/* Check to see if link went down during discovery */
 	if (lpfc_els_chk_latt(vport))
 		goto out;
 
-	if (irsp->ulpStatus) {
+	if (ulp_status) {
 		/* Check for retry */
 		if (lpfc_els_retry(phba, cmdiocb, rspiocb)) {
 			/* ELS command is being retried */
@@ -2335,11 +2348,11 @@ lpfc_cmpl_els_prli(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		lpfc_printf_vlog(vport, mode, loglevel,
 				 "2754 PRLI failure DID:%06X Status:x%x/x%x, "
 				 "data: x%x\n",
-				 ndlp->nlp_DID, irsp->ulpStatus,
-				 irsp->un.ulpWord[4], ndlp->fc4_prli_sent);
+				 ndlp->nlp_DID, ulp_status,
+				 ulp_word4, ndlp->fc4_prli_sent);
 
 		/* Do not call DSM for lpfc_els_abort'ed ELS cmds */
-		if (!lpfc_error_lost_link(irsp->ulpStatus, irsp->un.ulpWord[4]))
+		if (!lpfc_error_lost_link(ulp_status, ulp_word4))
 			lpfc_disc_state_machine(vport, ndlp, cmdiocb,
 						NLP_EVT_CMPL_PRLI);
 
@@ -2726,16 +2739,26 @@ lpfc_cmpl_els_adisc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	IOCB_t *irsp;
 	struct lpfc_nodelist *ndlp;
 	int  disc;
+	u32 ulp_status, ulp_word4, tmo;
 
 	/* we pass cmdiocb to state machine which needs rspiocb as well */
 	cmdiocb->context_un.rsp_iocb = rspiocb;
 
-	irsp = &(rspiocb->iocb);
 	ndlp = (struct lpfc_nodelist *) cmdiocb->context1;
 
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
 		"ADISC cmpl:      status:x%x/x%x did:x%x",
-		irsp->ulpStatus, irsp->un.ulpWord[4],
+		ulp_status, ulp_word4,
 		ndlp->nlp_DID);
 
 	/* Since ndlp can be freed in the disc state machine, note if this node
@@ -2749,8 +2772,8 @@ lpfc_cmpl_els_adisc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
 			 "0104 ADISC completes to NPort x%x "
 			 "Data: x%x x%x x%x x%x x%x\n",
-			 ndlp->nlp_DID, irsp->ulpStatus, irsp->un.ulpWord[4],
-			 irsp->ulpTimeout, disc, vport->num_disc_nodes);
+			 ndlp->nlp_DID, ulp_status, ulp_word4,
+			 tmo, disc, vport->num_disc_nodes);
 	/* Check to see if link went down during discovery */
 	if (lpfc_els_chk_latt(vport)) {
 		spin_lock_irq(&ndlp->lock);
@@ -2759,7 +2782,7 @@ lpfc_cmpl_els_adisc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		goto out;
 	}
 
-	if (irsp->ulpStatus) {
+	if (ulp_status) {
 		/* Check for retry */
 		if (lpfc_els_retry(phba, cmdiocb, rspiocb)) {
 			/* ELS command is being retried */
@@ -2774,11 +2797,10 @@ lpfc_cmpl_els_adisc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		/* ADISC failed */
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
 				 "2755 ADISC failure DID:%06X Status:x%x/x%x\n",
-				 ndlp->nlp_DID, irsp->ulpStatus,
-				 irsp->un.ulpWord[4]);
-
+				 ndlp->nlp_DID, ulp_status,
+				 ulp_word4);
 		lpfc_disc_state_machine(vport, ndlp, cmdiocb,
-				NLP_EVT_CMPL_ADISC);
+					NLP_EVT_CMPL_ADISC);
 
 		/* As long as this node is not registered with the SCSI or NVMe
 		 * transport, it is no longer an active node. Otherwise
@@ -2906,11 +2928,23 @@ lpfc_cmpl_els_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	unsigned long flags;
 	uint32_t skip_recovery = 0;
 	int wake_up_waiter = 0;
+	u32 ulp_status;
+	u32 ulp_word4;
+	u32 tmo;
 
 	/* we pass cmdiocb to state machine which needs rspiocb as well */
 	cmdiocb->context_un.rsp_iocb = rspiocb;
 
-	irsp = &(rspiocb->iocb);
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
 	spin_lock_irq(&ndlp->lock);
 	ndlp->nlp_flag &= ~NLP_LOGO_SND;
 	if (ndlp->save_flags & NLP_WAIT_FOR_LOGO) {
@@ -2921,7 +2955,7 @@ lpfc_cmpl_els_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
 		"LOGO cmpl:       status:x%x/x%x did:x%x",
-		irsp->ulpStatus, irsp->un.ulpWord[4],
+		ulp_status, ulp_word4,
 		ndlp->nlp_DID);
 
 	/* LOGO completes to NPort <nlp_DID> */
@@ -2929,8 +2963,8 @@ lpfc_cmpl_els_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			 "0105 LOGO completes to NPort x%x "
 			 "refcnt %d nflags x%x Data: x%x x%x x%x x%x\n",
 			 ndlp->nlp_DID, kref_read(&ndlp->kref), ndlp->nlp_flag,
-			 irsp->ulpStatus, irsp->un.ulpWord[4],
-			 irsp->ulpTimeout, vport->num_disc_nodes);
+			 ulp_status, ulp_word4,
+			 tmo, vport->num_disc_nodes);
 
 	if (lpfc_els_chk_latt(vport)) {
 		skip_recovery = 1;
@@ -2942,14 +2976,15 @@ lpfc_cmpl_els_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	 * all acceptable.  Note the failure and move forward with
 	 * discovery.  The PLOGI will retry.
 	 */
-	if (irsp->ulpStatus) {
+	if (ulp_status) {
 		/* LOGO failed */
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
-				 "2756 LOGO failure, No Retry DID:%06X Status:x%x/x%x\n",
-				 ndlp->nlp_DID, irsp->ulpStatus,
-				 irsp->un.ulpWord[4]);
-		/* Do not call DSM for lpfc_els_abort'ed ELS cmds */
-		if (lpfc_error_lost_link(irsp->ulpStatus, irsp->un.ulpWord[4])) {
+				 "2756 LOGO failure, No Retry DID:%06X "
+				 "Status:x%x/x%x\n",
+				 ndlp->nlp_DID, ulp_status,
+				 ulp_word4);
+
+		if (lpfc_error_lost_link(ulp_status, ulp_word4)) {
 			skip_recovery = 1;
 			goto out;
 		}
@@ -2996,8 +3031,8 @@ lpfc_cmpl_els_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
 				 "3187 LOGO completes to NPort x%x: Start "
 				 "Recovery Data: x%x x%x x%x x%x\n",
-				 ndlp->nlp_DID, irsp->ulpStatus,
-				 irsp->un.ulpWord[4], irsp->ulpTimeout,
+				 ndlp->nlp_DID, ulp_status,
+				 ulp_word4, tmo,
 				 vport->num_disc_nodes);
 
 		lpfc_els_free_iocb(phba, cmdiocb);
@@ -5350,6 +5385,8 @@ lpfc_els_rsp_acc(struct lpfc_vport *vport, uint32_t flag,
 	struct lpfc_hba  *phba = vport->phba;
 	IOCB_t *icmd;
 	IOCB_t *oldcmd;
+	union lpfc_wqe128 *wqe;
+	union lpfc_wqe128 *oldwqe = &oldiocb->wqe;
 	struct lpfc_iocbq *elsiocb;
 	uint8_t *pcmd;
 	struct serv_parm *sp;
@@ -5358,8 +5395,6 @@ lpfc_els_rsp_acc(struct lpfc_vport *vport, uint32_t flag,
 	ELS_PKT *els_pkt_ptr;
 	struct fc_els_rdf_resp *rdf_resp;
 
-	oldcmd = &oldiocb->iocb;
-
 	switch (flag) {
 	case ELS_CMD_ACC:
 		cmdsize = sizeof(uint32_t);
@@ -5372,9 +5407,25 @@ lpfc_els_rsp_acc(struct lpfc_vport *vport, uint32_t flag,
 			return 1;
 		}
 
-		icmd = &elsiocb->iocb;
-		icmd->ulpContext = oldcmd->ulpContext;	/* Xri / rx_id */
-		icmd->unsli3.rcvsli3.ox_id = oldcmd->unsli3.rcvsli3.ox_id;
+		if (phba->sli_rev == LPFC_SLI_REV4) {
+			wqe = &elsiocb->wqe;
+			/* XRI / rx_id */
+			bf_set(wqe_ctxt_tag, &wqe->xmit_els_rsp.wqe_com,
+			       bf_get(wqe_ctxt_tag,
+				      &oldwqe->xmit_els_rsp.wqe_com));
+
+			/* oxid */
+			bf_set(wqe_rcvoxid, &wqe->xmit_els_rsp.wqe_com,
+			       bf_get(wqe_rcvoxid,
+				      &oldwqe->xmit_els_rsp.wqe_com));
+		} else {
+			icmd = &elsiocb->iocb;
+			oldcmd = &oldiocb->iocb;
+			icmd->ulpContext = oldcmd->ulpContext; /* Xri / rx_id */
+			icmd->unsli3.rcvsli3.ox_id =
+				oldcmd->unsli3.rcvsli3.ox_id;
+		}
+
 		pcmd = (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
 		*((uint32_t *) (pcmd)) = ELS_CMD_ACC;
 		pcmd += sizeof(uint32_t);
@@ -5391,9 +5442,25 @@ lpfc_els_rsp_acc(struct lpfc_vport *vport, uint32_t flag,
 		if (!elsiocb)
 			return 1;
 
-		icmd = &elsiocb->iocb;
-		icmd->ulpContext = oldcmd->ulpContext;	/* Xri / rx_id */
-		icmd->unsli3.rcvsli3.ox_id = oldcmd->unsli3.rcvsli3.ox_id;
+		if (phba->sli_rev == LPFC_SLI_REV4) {
+			wqe = &elsiocb->wqe;
+			/* XRI / rx_id */
+			bf_set(wqe_ctxt_tag, &wqe->xmit_els_rsp.wqe_com,
+			       bf_get(wqe_ctxt_tag,
+				      &oldwqe->xmit_els_rsp.wqe_com));
+
+			/* oxid */
+			bf_set(wqe_rcvoxid, &wqe->xmit_els_rsp.wqe_com,
+			       bf_get(wqe_rcvoxid,
+				      &oldwqe->xmit_els_rsp.wqe_com));
+		} else {
+			icmd = &elsiocb->iocb;
+			oldcmd = &oldiocb->iocb;
+			icmd->ulpContext = oldcmd->ulpContext; /* Xri / rx_id */
+			icmd->unsli3.rcvsli3.ox_id =
+				oldcmd->unsli3.rcvsli3.ox_id;
+		}
+
 		pcmd = (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
 
 		if (mbox)
@@ -5453,9 +5520,25 @@ lpfc_els_rsp_acc(struct lpfc_vport *vport, uint32_t flag,
 		if (!elsiocb)
 			return 1;
 
-		icmd = &elsiocb->iocb;
-		icmd->ulpContext = oldcmd->ulpContext;	/* Xri / rx_id */
-		icmd->unsli3.rcvsli3.ox_id = oldcmd->unsli3.rcvsli3.ox_id;
+		if (phba->sli_rev == LPFC_SLI_REV4) {
+			wqe = &elsiocb->wqe;
+			/* XRI / rx_id */
+			bf_set(wqe_ctxt_tag, &wqe->xmit_els_rsp.wqe_com,
+			       bf_get(wqe_ctxt_tag,
+				      &oldwqe->xmit_els_rsp.wqe_com));
+
+			/* oxid */
+			bf_set(wqe_rcvoxid, &wqe->xmit_els_rsp.wqe_com,
+			       bf_get(wqe_rcvoxid,
+				      &oldwqe->xmit_els_rsp.wqe_com));
+		} else {
+			icmd = &elsiocb->iocb;
+			oldcmd = &oldiocb->iocb;
+			icmd->ulpContext = oldcmd->ulpContext; /* Xri / rx_id */
+			icmd->unsli3.rcvsli3.ox_id =
+				oldcmd->unsli3.rcvsli3.ox_id;
+		}
+
 		pcmd = (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
 
 		memcpy(pcmd, ((struct lpfc_dmabuf *) oldiocb->context2)->virt,
@@ -5475,9 +5558,25 @@ lpfc_els_rsp_acc(struct lpfc_vport *vport, uint32_t flag,
 		if (!elsiocb)
 			return 1;
 
-		icmd = &elsiocb->iocb;
-		icmd->ulpContext = oldcmd->ulpContext;	/* Xri / rx_id */
-		icmd->unsli3.rcvsli3.ox_id = oldcmd->unsli3.rcvsli3.ox_id;
+		if (phba->sli_rev == LPFC_SLI_REV4) {
+			wqe = &elsiocb->wqe;
+			/* XRI / rx_id */
+			bf_set(wqe_ctxt_tag, &wqe->xmit_els_rsp.wqe_com,
+			       bf_get(wqe_ctxt_tag,
+				      &oldwqe->xmit_els_rsp.wqe_com));
+
+			/* oxid */
+			bf_set(wqe_rcvoxid, &wqe->xmit_els_rsp.wqe_com,
+			       bf_get(wqe_rcvoxid,
+				      &oldwqe->xmit_els_rsp.wqe_com));
+		} else {
+			icmd = &elsiocb->iocb;
+			oldcmd = &oldiocb->iocb;
+			icmd->ulpContext = oldcmd->ulpContext; /* Xri / rx_id */
+			icmd->unsli3.rcvsli3.ox_id =
+				oldcmd->unsli3.rcvsli3.ox_id;
+		}
+
 		pcmd = (((struct lpfc_dmabuf *)elsiocb->context2)->virt);
 		rdf_resp = (struct fc_els_rdf_resp *)pcmd;
 		memset(rdf_resp, 0, sizeof(*rdf_resp));
@@ -5731,10 +5830,12 @@ lpfc_els_rsp_adisc_acc(struct lpfc_vport *vport, struct lpfc_iocbq *oldiocb,
 	struct lpfc_hba  *phba = vport->phba;
 	ADISC *ap;
 	IOCB_t *icmd, *oldcmd;
+	union lpfc_wqe128 *wqe;
 	struct lpfc_iocbq *elsiocb;
 	uint8_t *pcmd;
 	uint16_t cmdsize;
 	int rc;
+	u32 ulp_context;
 
 	cmdsize = sizeof(uint32_t) + sizeof(ADISC);
 	elsiocb = lpfc_prep_els_iocb(vport, 0, cmdsize, oldiocb->retry, ndlp,
@@ -5742,16 +5843,29 @@ lpfc_els_rsp_adisc_acc(struct lpfc_vport *vport, struct lpfc_iocbq *oldiocb,
 	if (!elsiocb)
 		return 1;
 
-	icmd = &elsiocb->iocb;
-	oldcmd = &oldiocb->iocb;
-	icmd->ulpContext = oldcmd->ulpContext;	/* Xri / rx_id */
-	icmd->unsli3.rcvsli3.ox_id = oldcmd->unsli3.rcvsli3.ox_id;
+	if (phba->sli_rev == LPFC_SLI_REV4) {
+		wqe = &elsiocb->wqe;
+		/* XRI / rx_id */
+		bf_set(wqe_ctxt_tag, &wqe->generic.wqe_com,
+		       get_job_ulpcontext(phba, oldiocb));
+		ulp_context = get_job_ulpcontext(phba, elsiocb);
+		/* oxid */
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
 
 	/* Xmit ADISC ACC response tag <ulpIoTag> */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
 			 "0130 Xmit ADISC ACC response iotag x%x xri: "
 			 "x%x, did x%x, nlp_flag x%x, nlp_state x%x rpi x%x\n",
-			 elsiocb->iotag, elsiocb->iocb.ulpContext,
+			 elsiocb->iotag, ulp_context,
 			 ndlp->nlp_DID, ndlp->nlp_flag, ndlp->nlp_state,
 			 ndlp->nlp_rpi);
 	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
@@ -5784,14 +5898,6 @@ lpfc_els_rsp_adisc_acc(struct lpfc_vport *vport, struct lpfc_iocbq *oldiocb,
 		return 1;
 	}
 
-	/* Xmit ELS ACC response tag <ulpIoTag> */
-	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
-			 "0128 Xmit ELS ACC response Status: x%x, IoTag: x%x, "
-			 "XRI: x%x, DID: x%x, nlp_flag: x%x nlp_state: x%x "
-			 "RPI: x%x, fc_flag x%x\n",
-			 rc, elsiocb->iotag, elsiocb->sli4_xritag,
-			 ndlp->nlp_DID, ndlp->nlp_flag, ndlp->nlp_state,
-			 ndlp->nlp_rpi, vport->fc_flag);
 	return 0;
 }
 
@@ -5824,13 +5930,14 @@ lpfc_els_rsp_prli_acc(struct lpfc_vport *vport, struct lpfc_iocbq *oldiocb,
 	lpfc_vpd_t *vpd;
 	IOCB_t *icmd;
 	IOCB_t *oldcmd;
+	union lpfc_wqe128 *wqe;
 	struct lpfc_iocbq *elsiocb;
 	uint8_t *pcmd;
 	uint16_t cmdsize;
 	uint32_t prli_fc4_req, *req_payload;
 	struct lpfc_dmabuf *req_buf;
 	int rc;
-	u32 elsrspcmd;
+	u32 elsrspcmd, ulp_context;
 
 	/* Need the incoming PRLI payload to determine if the ACC is for an
 	 * FC4 or NVME PRLI type.  The PRLI type is at word 1.
@@ -5856,20 +5963,31 @@ lpfc_els_rsp_prli_acc(struct lpfc_vport *vport, struct lpfc_iocbq *oldiocb,
 	}
 
 	elsiocb = lpfc_prep_els_iocb(vport, 0, cmdsize, oldiocb->retry, ndlp,
-		ndlp->nlp_DID, elsrspcmd);
+				     ndlp->nlp_DID, elsrspcmd);
 	if (!elsiocb)
 		return 1;
 
-	icmd = &elsiocb->iocb;
-	oldcmd = &oldiocb->iocb;
-	icmd->ulpContext = oldcmd->ulpContext;	/* Xri / rx_id */
-	icmd->unsli3.rcvsli3.ox_id = oldcmd->unsli3.rcvsli3.ox_id;
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
 
 	/* Xmit PRLI ACC response tag <ulpIoTag> */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
 			 "0131 Xmit PRLI ACC response tag x%x xri x%x, "
 			 "did x%x, nlp_flag x%x, nlp_state x%x, rpi x%x\n",
-			 elsiocb->iotag, elsiocb->iocb.ulpContext,
+			 elsiocb->iotag, ulp_context,
 			 ndlp->nlp_DID, ndlp->nlp_flag, ndlp->nlp_state,
 			 ndlp->nlp_rpi);
 	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index e788610bc996..e73c7921e3cf 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -680,13 +680,13 @@ static int
 lpfc_rcv_padisc(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		struct lpfc_iocbq *cmdiocb)
 {
+	struct lpfc_hba *phba = vport->phba;
 	struct lpfc_iocbq  *elsiocb;
 	struct lpfc_dmabuf *pcmd;
 	struct serv_parm   *sp;
 	struct lpfc_name   *pnn, *ppn;
 	struct ls_rjt stat;
 	ADISC *ap;
-	IOCB_t *icmd;
 	uint32_t *lp;
 	uint32_t cmd;
 
@@ -704,8 +704,8 @@ lpfc_rcv_padisc(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		ppn = (struct lpfc_name *) & sp->portName;
 	}
 
-	icmd = &cmdiocb->iocb;
-	if (icmd->ulpStatus == 0 && lpfc_check_adisc(vport, ndlp, pnn, ppn)) {
+	if (get_job_ulpstatus(phba, cmdiocb) == 0 &&
+	    lpfc_check_adisc(vport, ndlp, pnn, ppn)) {
 
 		/*
 		 * As soon as  we send ACC, the remote NPort can
@@ -716,7 +716,6 @@ lpfc_rcv_padisc(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 			elsiocb = kmalloc(sizeof(struct lpfc_iocbq),
 				GFP_KERNEL);
 			if (elsiocb) {
-
 				/* Save info from cmd IOCB used in rsp */
 				memcpy((uint8_t *)elsiocb, (uint8_t *)cmdiocb,
 					sizeof(struct lpfc_iocbq));
@@ -1313,23 +1312,24 @@ lpfc_cmpl_plogi_plogi_issue(struct lpfc_vport *vport,
 	struct lpfc_dmabuf *pcmd, *prsp, *mp;
 	uint32_t *lp;
 	uint32_t vid, flag;
-	IOCB_t *irsp;
 	struct serv_parm *sp;
 	uint32_t ed_tov;
 	LPFC_MBOXQ_t *mbox;
 	int rc;
+	u32 ulp_status;
+	u32 did;
 
 	cmdiocb = (struct lpfc_iocbq *) arg;
 	rspiocb = cmdiocb->context_un.rsp_iocb;
 
+	ulp_status = get_job_ulpstatus(phba, rspiocb);
+
 	if (ndlp->nlp_flag & NLP_ACC_REGLOGIN) {
 		/* Recovery from PLOGI collision logic */
 		return ndlp->nlp_state;
 	}
 
-	irsp = &rspiocb->iocb;
-
-	if (irsp->ulpStatus)
+	if (ulp_status)
 		goto out;
 
 	pcmd = (struct lpfc_dmabuf *) cmdiocb->context2;
@@ -1441,7 +1441,9 @@ lpfc_cmpl_plogi_plogi_issue(struct lpfc_vport *vport,
 		goto out;
 	}
 
-	if (lpfc_reg_rpi(phba, vport->vpi, irsp->un.elsreq64.remoteID,
+	did = get_job_els_rsp64_did(phba, cmdiocb);
+
+	if (lpfc_reg_rpi(phba, vport->vpi, did,
 			 (uint8_t *) sp, mbox, ndlp->nlp_rpi) == 0) {
 		switch (ndlp->nlp_DID) {
 		case NameServer_DID:
@@ -1671,17 +1673,18 @@ lpfc_cmpl_adisc_adisc_issue(struct lpfc_vport *vport,
 {
 	struct lpfc_hba   *phba = vport->phba;
 	struct lpfc_iocbq *cmdiocb, *rspiocb;
-	IOCB_t *irsp;
 	ADISC *ap;
 	int rc;
+	u32 ulp_status;
 
 	cmdiocb = (struct lpfc_iocbq *) arg;
 	rspiocb = cmdiocb->context_un.rsp_iocb;
 
+	ulp_status = get_job_ulpstatus(phba, rspiocb);
+
 	ap = (ADISC *)lpfc_check_elscmpl_iocb(phba, cmdiocb, rspiocb);
-	irsp = &rspiocb->iocb;
 
-	if ((irsp->ulpStatus) ||
+	if ((ulp_status) ||
 	    (!lpfc_check_adisc(vport, ndlp, &ap->nodeName, &ap->portName))) {
 		/* 1 sec timeout */
 		mod_timer(&ndlp->nlp_delayfunc,
@@ -2124,14 +2127,16 @@ lpfc_cmpl_prli_prli_issue(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 {
 	struct lpfc_iocbq *cmdiocb, *rspiocb;
 	struct lpfc_hba   *phba = vport->phba;
-	IOCB_t *irsp;
 	PRLI *npr;
 	struct lpfc_nvme_prli *nvpr;
 	void *temp_ptr;
+	u32 ulp_status;
 
 	cmdiocb = (struct lpfc_iocbq *) arg;
 	rspiocb = cmdiocb->context_un.rsp_iocb;
 
+	ulp_status = get_job_ulpstatus(phba, rspiocb);
+
 	/* A solicited PRLI is either FCP or NVME.  The PRLI cmd/rsp
 	 * format is different so NULL the two PRLI types so that the
 	 * driver correctly gets the correct context.
@@ -2144,8 +2149,7 @@ lpfc_cmpl_prli_prli_issue(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	else if (cmdiocb->cmd_flag & LPFC_PRLI_NVME_REQ)
 		nvpr = (struct lpfc_nvme_prli *) temp_ptr;
 
-	irsp = &rspiocb->iocb;
-	if (irsp->ulpStatus) {
+	if (ulp_status) {
 		if ((vport->port_type == LPFC_NPIV_PORT) &&
 		    vport->cfg_restrict_login) {
 			goto out;
@@ -2744,16 +2748,18 @@ static uint32_t
 lpfc_cmpl_plogi_npr_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 			 void *arg, uint32_t evt)
 {
+	struct lpfc_hba *phba = vport->phba;
 	struct lpfc_iocbq *cmdiocb, *rspiocb;
-	IOCB_t *irsp;
+	u32 ulp_status;
 
 	cmdiocb = (struct lpfc_iocbq *) arg;
 	rspiocb = cmdiocb->context_un.rsp_iocb;
 
-	irsp = &rspiocb->iocb;
-	if (irsp->ulpStatus) {
+	ulp_status = get_job_ulpstatus(phba, rspiocb);
+
+	if (ulp_status)
 		return NLP_STE_FREED_NODE;
-	}
+
 	return ndlp->nlp_state;
 }
 
@@ -2761,14 +2767,16 @@ static uint32_t
 lpfc_cmpl_prli_npr_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 			void *arg, uint32_t evt)
 {
+	struct lpfc_hba *phba = vport->phba;
 	struct lpfc_iocbq *cmdiocb, *rspiocb;
-	IOCB_t *irsp;
+	u32 ulp_status;
 
 	cmdiocb = (struct lpfc_iocbq *) arg;
 	rspiocb = cmdiocb->context_un.rsp_iocb;
 
-	irsp = &rspiocb->iocb;
-	if (irsp->ulpStatus && (ndlp->nlp_flag & NLP_NODEV_REMOVE)) {
+	ulp_status = get_job_ulpstatus(phba, rspiocb);
+
+	if (ulp_status && (ndlp->nlp_flag & NLP_NODEV_REMOVE)) {
 		lpfc_drop_node(vport, ndlp);
 		return NLP_STE_FREED_NODE;
 	}
@@ -2795,14 +2803,16 @@ static uint32_t
 lpfc_cmpl_adisc_npr_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 			 void *arg, uint32_t evt)
 {
+	struct lpfc_hba *phba = vport->phba;
 	struct lpfc_iocbq *cmdiocb, *rspiocb;
-	IOCB_t *irsp;
+	u32 ulp_status;
 
 	cmdiocb = (struct lpfc_iocbq *) arg;
 	rspiocb = cmdiocb->context_un.rsp_iocb;
 
-	irsp = &rspiocb->iocb;
-	if (irsp->ulpStatus && (ndlp->nlp_flag & NLP_NODEV_REMOVE)) {
+	ulp_status = get_job_ulpstatus(phba, rspiocb);
+
+	if (ulp_status && (ndlp->nlp_flag & NLP_NODEV_REMOVE)) {
 		lpfc_drop_node(vport, ndlp);
 		return NLP_STE_FREED_NODE;
 	}
-- 
2.35.3

