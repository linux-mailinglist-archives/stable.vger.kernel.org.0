Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1F4460D791
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 00:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbiJYW7B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 18:59:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232834AbiJYW65 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 18:58:57 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACA1ECA8B8
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 15:58:55 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id z6so854855qtv.5
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 15:58:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EI1QRzKDjZBmgxdcTcWxpvG2xSHI/qCQGlJXaGl1oOw=;
        b=eadhrtvfNeMT+bmJw3kG0xaNY6zKzo1dGiO/5oOE/cRpaf4p+ARZtOTck3X0DhE51Q
         DKPty3yaxRcfiSZ38wmSE/PS+2EySybds6lEAKkwFyOWZEyIslNp0po47/cWFs5NW+Al
         1z1SyS7RKxzo5MJ5lcYctRorkS4VnGq6bLtNEFoAcB2LuvANP3aIC+d1xoUj1JJD66q3
         TnYqu3aTWhUi8TG8syL2RnoqyYfPF5p4hO5vzAGAMmouk/ktjqduh3lPhMFm8HVa9Bos
         gyhxLnHCOfngM3Dr/xXyWYEXVR3VJt2kcbA2/F5LemGPWNi3ROSXcQzM3WHUGWH+xirV
         kTFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EI1QRzKDjZBmgxdcTcWxpvG2xSHI/qCQGlJXaGl1oOw=;
        b=hY+ae2X9BqU2rx3VRhevhmj+3GqrlVQkXfx8zNGIA9P5XdtTwRIUBZ9dFP0FndJNr5
         qIo/pd9NzLLT/4w/WEvtPbt+9xeZauQZZE1rTggFH7oHzlVbx0+q7+Wg8ISF69pFJCjy
         FOgCo6la0NoeVRTdhLQI8bknfI3PCtd64DxrRG5va3QI2viYTxQd2eM1nDZBzZcN2rxa
         OLCBS65vGhfmZ+KlpK1uQ5q2if4yUOrs4SzLWav3Ju2/bJyRSJziG8HOEQi743TyHuYA
         QBa9pacZXajb3GekYE8khLa5tctvgnCE7Ee79X6PD4UvZO+CEspDULyeMfVZ2Z/yu0ny
         xlfA==
X-Gm-Message-State: ACrzQf352ikTDhovcG7vTWNcsOZX/ahSPejkqB34rmbpHxrJwDIpYfWU
        iA8guvRfg04bjjbGNJGDEXk0HAB8E+A=
X-Google-Smtp-Source: AMsMyM4q9QuUKR07UlFXQ1vDMd7pFW9xTlb6Ds9cPGGADU1eJn/bR41UKDuN1vS1n802efjZ044OAg==
X-Received: by 2002:a05:622a:1109:b0:39c:1d87:3b6c with SMTP id e9-20020a05622a110900b0039c1d873b6cmr33246516qty.139.1666738734660;
        Tue, 25 Oct 2022 15:58:54 -0700 (PDT)
Received: from mail-ash-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r12-20020ae9d60c000000b006ecdfcf9d81sm2823766qkk.84.2022.10.25.15.58.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 15:58:54 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     stable@vger.kernel.org
Cc:     jsmart2021@gmail.com, justintee8345@gmail.com,
        martin.petersen@oracle.com, gregkh@linuxfoundation.org,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 32/33] scsi: lpfc: Resolve some cleanup issues following abort path refactoring
Date:   Tue, 25 Oct 2022 15:57:38 -0700
Message-Id: <20221025225739.85182-33-jsmart2021@gmail.com>
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

Refactoring and consolidation of abort paths:

 - lpfc_sli4_abort_fcp_cmpl() and lpfc_sli_abort_fcp_cmpl() are combined
  into a single generic lpfc_sli_abort_fcp_cmpl() routine.  Thus, remove
  extraneous lpfc_sli4_abort_fcp_cmpl() prototype declaration.

 - lpfc_nvme_abort_fcreq_cmpl() abort completion routine is called with a
  mismatched argument type.  This may result in misleading log message
  content.  Update to the correct argument type of lpfc_iocbq instead of
  lpfc_wcqe_complete.  The lpfc_wcqe_complete should be derived from the
  lpfc_iocbq structure.

Link: https://lore.kernel.org/r/20220603174329.63777-3-jsmart2021@gmail.com
Fixes: 31a59f75702f ("scsi: lpfc: SLI path split: Refactor Abort paths")
Cc: <stable@vger.kernel.org> # v5.18
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/lpfc/lpfc_crtn.h | 4 +---
 drivers/scsi/lpfc/lpfc_nvme.c | 6 ++++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index 6f69dfc82096..c34446992cfb 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -417,8 +417,6 @@ int lpfc_sli_issue_iocb_wait(struct lpfc_hba *, uint32_t,
 			     uint32_t);
 void lpfc_sli_abort_fcp_cmpl(struct lpfc_hba *, struct lpfc_iocbq *,
 			     struct lpfc_iocbq *);
-void lpfc_sli4_abort_fcp_cmpl(struct lpfc_hba *h, struct lpfc_iocbq *i,
-			      struct lpfc_wcqe_complete *w);
 
 void lpfc_sli_free_hbq(struct lpfc_hba *, struct hbq_dmabuf *);
 
@@ -626,7 +624,7 @@ void lpfc_nvmet_invalidate_host(struct lpfc_hba *phba,
 			struct lpfc_nodelist *ndlp);
 void lpfc_nvme_abort_fcreq_cmpl(struct lpfc_hba *phba,
 				struct lpfc_iocbq *cmdiocb,
-				struct lpfc_wcqe_complete *abts_cmpl);
+				struct lpfc_iocbq *rspiocb);
 void lpfc_create_multixri_pools(struct lpfc_hba *phba);
 void lpfc_create_destroy_pools(struct lpfc_hba *phba);
 void lpfc_move_xri_pvt_to_pbl(struct lpfc_hba *phba, u32 hwqid);
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index d1264ed60b6e..4ef6e435e210 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -1738,7 +1738,7 @@ lpfc_nvme_fcp_io_submit(struct nvme_fc_local_port *pnvme_lport,
  * lpfc_nvme_abort_fcreq_cmpl - Complete an NVME FCP abort request.
  * @phba: Pointer to HBA context object
  * @cmdiocb: Pointer to command iocb object.
- * @abts_cmpl: Pointer to wcqe complete object.
+ * @rspiocb: Pointer to response iocb object.
  *
  * This is the callback function for any NVME FCP IO that was aborted.
  *
@@ -1747,8 +1747,10 @@ lpfc_nvme_fcp_io_submit(struct nvme_fc_local_port *pnvme_lport,
  **/
 void
 lpfc_nvme_abort_fcreq_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
-			   struct lpfc_wcqe_complete *abts_cmpl)
+			   struct lpfc_iocbq *rspiocb)
 {
+	struct lpfc_wcqe_complete *abts_cmpl = &rspiocb->wcqe_cmpl;
+
 	lpfc_printf_log(phba, KERN_INFO, LOG_NVME,
 			"6145 ABORT_XRI_CN completing on rpi x%x "
 			"original iotag x%x, abort cmd iotag x%x "
-- 
2.35.3

