Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D567460D781
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 00:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232802AbiJYW6e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 18:58:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232799AbiJYW6e (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 18:58:34 -0400
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82F38CABC4
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 15:58:33 -0700 (PDT)
Received: by mail-qv1-xf2d.google.com with SMTP id ml12so8967239qvb.0
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 15:58:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1Sv4Fx5Rj397vXSOhMpI8b/zvhjHE5q3miq2p5jRGFc=;
        b=oj0nwjznPk8byi5BZ6TPeyD0bw2x9+FMyuHTRDq+ZWmYCheVOyAHDDqevCQtq41b63
         cK+Hp2C5qozgy/7ZZlFyLG1o6Jsi1nicvJDAOh1iGkRAiyVSICxdkXY83uSzzgASOnjs
         XRLePkjW822kCOueO/OM36vu/huo4Kz3OpB39cVZneEqt86OIlWcDp+sfP+NCUxL8HD8
         un/T7fulNowQsTTP7fROCmyJgtAyV20gMpD8wzT1MP+EUcZp+ZgWZdM0OwTDMCf5vqwA
         3zCi1iwrwop6JMnDcCyJN8JS7S7O3KLgOiWCRS/vLKqBKn0DhoTS3zrewSZhlrwWogbm
         oZ+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1Sv4Fx5Rj397vXSOhMpI8b/zvhjHE5q3miq2p5jRGFc=;
        b=yCuzyJuXpb/TeG2/zgRQkp43ngeQEUIsb0ZL4Z/u8eNT7wmi2om7MRWIIEkVjLYQFS
         USlu3uTlw8M3th3X5DyVh4ekOoYr9Ld0Oj7Umck6G+lpfhW0LoeHjMVOXiUFgL3qgSPj
         w57Oe7hwiai6B76qqOctF2ZGO80KfeClxMJ+nQeKaZ/ODfxkWTl3WIwYAuH4wYeyySBF
         X+OKTFQWxMYqeNz9Yul+8f+oN7OsbatSa7xKKsgnhxRtnzSKWjhhWvrydY/ff5Sqep8x
         JGTUINqMQI3CtjgWlwzfxNfzdAWhQxxjry2r+hUbFNfFRK9JvMjQoCNF+fhH4zjbOD3n
         CJAw==
X-Gm-Message-State: ACrzQf3Vtc2AwaTYZYg4KxNuNLc+5Xu0qEqRHC7ptK1xF2+WVv7dxRLr
        EyS6GKYBydvYB3Aow6BgLHnb4m+8e7I=
X-Google-Smtp-Source: AMsMyM4e6SCpBwDNTh5JB8Lk2M9PCbcNgdDh8tQ8J8etV6uifzMMaMjlavLJtFDZE/A/5n5bmgfKMw==
X-Received: by 2002:a0c:8041:0:b0:4af:b13b:2624 with SMTP id 59-20020a0c8041000000b004afb13b2624mr34260243qva.92.1666738712503;
        Tue, 25 Oct 2022 15:58:32 -0700 (PDT)
Received: from mail-ash-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r12-20020ae9d60c000000b006ecdfcf9d81sm2823766qkk.84.2022.10.25.15.58.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 15:58:32 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     stable@vger.kernel.org
Cc:     jsmart2021@gmail.com, justintee8345@gmail.com,
        martin.petersen@oracle.com, gregkh@linuxfoundation.org,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 16/33] scsi: lpfc: SLI path split: Refactor FDISC paths
Date:   Tue, 25 Oct 2022 15:57:22 -0700
Message-Id: <20221025225739.85182-17-jsmart2021@gmail.com>
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

This patch refactors the FDISC paths to use SLI-4 as the primary interface:

 - Conversion away from using SLI-3 iocb structures to set/access fields in
   common routines. Use the new generic get/set routines that were added.
   This move changes code from indirect structure references to using local
   variables with the generic routines.

 - Refactor routines when setting non-generic fields, to have both SLI3 and
   SLI4 specific sections. This replaces the set-as-SLI3 then translate to
   SLI4 behavior of the past.

Link: https://lore.kernel.org/r/20220225022308.16486-10-jsmart2021@gmail.com
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 47 ++++++++++++++++++++++--------------
 1 file changed, 29 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 1376dd486aa3..41326d024318 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -11130,6 +11130,7 @@ lpfc_issue_els_fdisc(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 {
 	struct lpfc_hba *phba = vport->phba;
 	IOCB_t *icmd;
+	union lpfc_wqe128 *wqe = NULL;
 	struct lpfc_iocbq *elsiocb;
 	struct serv_parm *sp;
 	uint8_t *pcmd;
@@ -11149,15 +11150,14 @@ lpfc_issue_els_fdisc(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		return 1;
 	}
 
-	icmd = &elsiocb->iocb;
-	icmd->un.elsreq64.myID = 0;
-	icmd->un.elsreq64.fl = 1;
-
-	/*
-	 * SLI3 ports require a different context type value than SLI4.
-	 * Catch SLI3 ports here and override the prep.
-	 */
-	if (phba->sli_rev == LPFC_SLI_REV3) {
+	if (phba->sli_rev == LPFC_SLI_REV4) {
+		wqe = &elsiocb->wqe;
+		bf_set(els_req64_sid, &wqe->els_req, 0);
+		bf_set(els_req64_sp, &wqe->els_req, 1);
+	} else {
+		icmd = &elsiocb->iocb;
+		icmd->un.elsreq64.myID = 0;
+		icmd->un.elsreq64.fl = 1;
 		icmd->ulpCt_h = 1;
 		icmd->ulpCt_l = 0;
 	}
@@ -11195,14 +11195,11 @@ lpfc_issue_els_fdisc(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		did, 0, 0);
 
 	elsiocb->context1 = lpfc_nlp_get(ndlp);
-	if (!elsiocb->context1) {
-		lpfc_els_free_iocb(phba, elsiocb);
+	if (!elsiocb->context1)
 		goto err_out;
-	}
 
 	rc = lpfc_issue_fabric_iocb(phba, elsiocb);
 	if (rc == IOCB_ERROR) {
-		lpfc_els_free_iocb(phba, elsiocb);
 		lpfc_nlp_put(ndlp);
 		goto err_out;
 	}
@@ -11211,6 +11208,7 @@ lpfc_issue_els_fdisc(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	return 0;
 
  err_out:
+	lpfc_els_free_iocb(phba, elsiocb);
 	lpfc_vport_set_state(vport, FC_VPORT_FAILED);
 	lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
 			 "0256 Issue FDISC: Cannot send IOCB\n");
@@ -11239,23 +11237,36 @@ lpfc_cmpl_els_npiv_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	IOCB_t *irsp;
 	struct lpfc_nodelist *ndlp;
 	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
+	u32 ulp_status, ulp_word4, did, tmo;
 
 	ndlp = (struct lpfc_nodelist *)cmdiocb->context1;
-	irsp = &rspiocb->iocb;
+
+	ulp_status = get_job_ulpstatus(phba, rspiocb);
+	ulp_word4 = get_job_word4(phba, rspiocb);
+
+	if (phba->sli_rev == LPFC_SLI_REV4) {
+		did = get_job_els_rsp64_did(phba, cmdiocb);
+		tmo = get_wqe_tmo(cmdiocb);
+	} else {
+		irsp = &rspiocb->iocb;
+		did = get_job_els_rsp64_did(phba, rspiocb);
+		tmo = irsp->ulpTimeout;
+	}
+
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
 		"LOGO npiv cmpl:  status:x%x/x%x did:x%x",
-		irsp->ulpStatus, irsp->un.ulpWord[4], irsp->un.rcvels.remoteID);
+		ulp_status, ulp_word4, did);
 
 	/* NPIV LOGO completes to NPort <nlp_DID> */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
 			 "2928 NPIV LOGO completes to NPort x%x "
 			 "Data: x%x x%x x%x x%x x%x x%x x%x\n",
-			 ndlp->nlp_DID, irsp->ulpStatus, irsp->un.ulpWord[4],
-			 irsp->ulpTimeout, vport->num_disc_nodes,
+			 ndlp->nlp_DID, ulp_status, ulp_word4,
+			 tmo, vport->num_disc_nodes,
 			 kref_read(&ndlp->kref), ndlp->nlp_flag,
 			 ndlp->fc4_xpt_flags);
 
-	if (irsp->ulpStatus == IOSTAT_SUCCESS) {
+	if (ulp_status == IOSTAT_SUCCESS) {
 		spin_lock_irq(shost->host_lock);
 		vport->fc_flag &= ~FC_NDISC_ACTIVE;
 		vport->fc_flag &= ~FC_FABRIC;
-- 
2.35.3

