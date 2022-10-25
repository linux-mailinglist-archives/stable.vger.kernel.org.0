Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ECE460D782
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 00:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232793AbiJYW6h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 18:58:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232798AbiJYW6f (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 18:58:35 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF80ACA8B8
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 15:58:34 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id c8so9287956qvn.10
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 15:58:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o1anvmVhMqfAVbGl1oB3u28b+mrhgpPlmM/SeEt3VLw=;
        b=eXzYPQqg3fP+xE/bltlBdhAzgC6A6V2h34YsANu+BYdNq5jFxwAhiDVJCGPgye9E+y
         IFZCZhDe11Q6ZjsofM2Y6rR19kUWLDmWyhXDamZYfDTDqkVRooBpW3n2xzffBKsEmpw2
         TzeZG+d17vxfWAzvx5oVGYrsLi/oFApRyXI1rR72liSHJAMEaKI+H6P/TpWcIxAHefaG
         fqRUsjHYzfUCvhZh05SLlz07ul3+K90n5BvnWYDw1Y65aKQtw9zdDSdYJKNo/tJfTQY2
         r8x7oEQf/EKTceEBb2s5GLTC7ZnXKGXZLmNaim/pHuYf+rqzCExQXCUu+XhM+fPSsDih
         awBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o1anvmVhMqfAVbGl1oB3u28b+mrhgpPlmM/SeEt3VLw=;
        b=kT2JcLIEw1D14iKbG23BhNFlrnBqDtJhMwP7dLekrAvwoFwAePAPoKdyTNfAvqMvXW
         XjmDHjTVAR4WcanqnWWnk+fwCTB/7dpG7lSgfWAdix2j8Khaxtcv2wnse3oCrZRP2L+S
         tUMfCfZ4yti0K6eTRuOPAxPYp+j4qs+o0yayGBMY4AStYHvxJM6RmDLfgweI40BkwwPI
         l4hMz8G5k86fI/EBXYzL76gqGx3PQrEZD5xsXGRGwfbD4GrAuPwxgaUkBaTxxCWxWrGY
         dVPQdA+jYlU5CjkTJUgKIABCLGokcQQSdj48DWaFgFa1olodS/fjpPr9WvYXjBc6RH92
         ugLg==
X-Gm-Message-State: ACrzQf09oPj3X7vWWNKjxmDkvcAJNfcwzR77IcmMhEceTBfuYW3I57Nq
        NRINQoDrzs///X/LzT0CmF8RwL6Cts8=
X-Google-Smtp-Source: AMsMyM7t3XrAvLCUhrMWiaXtWw7WM6KRYfApwaMUtccoWzJgZAuiCUiFeQX9VRImrjWOVCY/q6/f9Q==
X-Received: by 2002:ad4:5be6:0:b0:4b3:ff39:7ad4 with SMTP id k6-20020ad45be6000000b004b3ff397ad4mr34225277qvc.126.1666738713907;
        Tue, 25 Oct 2022 15:58:33 -0700 (PDT)
Received: from mail-ash-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r12-20020ae9d60c000000b006ecdfcf9d81sm2823766qkk.84.2022.10.25.15.58.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 15:58:33 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     stable@vger.kernel.org
Cc:     jsmart2021@gmail.com, justintee8345@gmail.com,
        martin.petersen@oracle.com, gregkh@linuxfoundation.org,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 17/33] scsi: lpfc: SLI path split: Refactor VMID paths
Date:   Tue, 25 Oct 2022 15:57:23 -0700
Message-Id: <20221025225739.85182-18-jsmart2021@gmail.com>
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

This patch refactors the VMID paths to use SLI-4 as the primary interface:

 - Conversion away from using SLI-3 iocb structures to set/access fields in
   common routines. Use the new generic get/set routines that were added.
   This move changes code from indirect structure references to using local
   variables with the generic routines.

 - Refactor routines when setting non-generic fields, to have both SLI3 and
   SLI4 specific sections. This replaces the set-as-SLI3 then translate to
   SLI4 behavior of the past.

Link: https://lore.kernel.org/r/20220225022308.16486-11-jsmart2021@gmail.com
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/lpfc/lpfc_ct.c  |  2 +-
 drivers/scsi/lpfc/lpfc_els.c | 14 ++++++++------
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 95e7651163da..b78823a305cc 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -3814,7 +3814,7 @@ lpfc_cmpl_ct_cmd_vmid(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	if (cmd == SLI_CTAS_DALLAPP_ID)
 		lpfc_ct_free_iocb(phba, cmdiocb);
 
-	if (lpfc_els_chk_latt(vport) || rspiocb->iocb.ulpStatus) {
+	if (lpfc_els_chk_latt(vport) || get_job_ulpstatus(phba, rspiocb)) {
 		if (cmd != SLI_CTAS_DALLAPP_ID)
 			return;
 	}
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 41326d024318..57ea04f45422 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -11874,7 +11874,8 @@ lpfc_cmpl_els_qfpa(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	struct lpfc_vmid_priority_range *vmid_range = NULL;
 	u32 *data;
 	struct lpfc_dmabuf *dmabuf = cmdiocb->context2;
-	IOCB_t *irsp = &rspiocb->iocb;
+	u32 ulp_status = get_job_ulpstatus(phba, rspiocb);
+	u32 ulp_word4 = get_job_word4(phba, rspiocb);
 	u8 *pcmd, max_desc;
 	u32 len, i;
 	struct lpfc_nodelist *ndlp = (struct lpfc_nodelist *)cmdiocb->context1;
@@ -11891,10 +11892,10 @@ lpfc_cmpl_els_qfpa(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 				 data[0], data[1]);
 		goto out;
 	}
-	if (irsp->ulpStatus) {
+	if (ulp_status) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_SLI,
 				 "6529 QFPA failed with status x%x  x%x\n",
-				 irsp->ulpStatus, irsp->un.ulpWord[4]);
+				 ulp_status, ulp_word4);
 		goto out;
 	}
 
@@ -12093,7 +12094,8 @@ lpfc_cmpl_els_uvem(struct lpfc_hba *phba, struct lpfc_iocbq *icmdiocb,
 	struct lpfc_nodelist *ndlp = icmdiocb->context1;
 	u8 *pcmd;
 	u32 *data;
-	IOCB_t *irsp = &rspiocb->iocb;
+	u32 ulp_status = get_job_ulpstatus(phba, rspiocb);
+	u32 ulp_word4 = get_job_word4(phba, rspiocb);
 	struct lpfc_dmabuf *dmabuf = icmdiocb->context2;
 	struct lpfc_vmid *vmid;
 
@@ -12111,10 +12113,10 @@ lpfc_cmpl_els_uvem(struct lpfc_hba *phba, struct lpfc_iocbq *icmdiocb,
 				 "4532 UVEM LS_RJT %x %x\n", data[0], data[1]);
 		goto out;
 	}
-	if (irsp->ulpStatus) {
+	if (ulp_status) {
 		lpfc_printf_vlog(vport, KERN_WARNING, LOG_SLI,
 				 "4533 UVEM error status %x: %x\n",
-				 irsp->ulpStatus, irsp->un.ulpWord[4]);
+				 ulp_status, ulp_word4);
 		goto out;
 	}
 	spin_lock(&phba->hbalock);
-- 
2.35.3

