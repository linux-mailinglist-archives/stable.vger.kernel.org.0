Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0DF653CEC4
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:47:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243524AbiFCRrE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:47:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345329AbiFCRqg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:46:36 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA15356C2C;
        Fri,  3 Jun 2022 10:43:37 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id 3-20020a17090a174300b001e426a02ac5so9456384pjm.2;
        Fri, 03 Jun 2022 10:43:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SFmo1YtzIJ9rmtpE/GhXgq77Pr76QMO7iRfjafIiLu0=;
        b=DOaMjOtD7xGK0cNLL5ZRRrHaBowV+EmnbJRuvIZOQnRjfBK35/MHWGGcgGI+ugA4Yc
         aeBIErNDmUc8+C6/HtbbsCk9Z1NljkrlVnthWrgBpKGm4jYXNILCqQUXBTiTpeqNMzR/
         XUfnlYjf8ZGcFA+kyPcRPQgftWRiuKjFmaKksyM3ja4FGDnbBXR4nulbkIR1bklPJszu
         r9vYqDeVoFEqZNXsuxo1tc1A7c/YM6h9hMf/pUMiH5c6KEfCquRmcsxjzXhBTb6IdlaT
         qxyU7pa1ibPn5ork30bJkoBX0fYwafqEvmeySvX1CFDsZJjVT80dPzJPzP5QbpM40Tmf
         7hiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SFmo1YtzIJ9rmtpE/GhXgq77Pr76QMO7iRfjafIiLu0=;
        b=EbmjM3kr593DsHCoqogbhrsk10galw3n8dMCgdx8qsaz0nlyS77hUwOj57PdgIUI+C
         W+BdAiwb5EOY7hqhLubMxMuagM45Z/nnVN0ZyCoZu/FnrFLJfY4MUC9ndQ0ouNOjmv7o
         duuKZ/U6WXd8CZ8M7nQiHIwJR5o6MxN3Vzq6Fo10twxKtub3A5pqWCduw8LbuxY5pipS
         8fYQIFuUQ7oFHuedf1CxUhF67B8MEZSObBqzy/63ctPBc4yu35VyfXND5E3ZQ2pehxij
         V8HV8wttMth3uw4w5SilsS45Dkh1Q64Vny5o62AOR0GVFmYi+0UPxPbrnpK5jAns7wlV
         cb1g==
X-Gm-Message-State: AOAM530FanN9cEqy9rDNWvsKFeRyez2OLlDmiiwkSu+frbb9rrz03xXO
        9SpnRqEr3aOqF9Eorm4V+3B4f/0KICs=
X-Google-Smtp-Source: ABdhPJw+XqpqJ8OB9TZASqA/8JeEhe8fyUMlPzwLT5FkwqeSDQAN1uyG8C1Kf16l2HiTGKm9QjDwhg==
X-Received: by 2002:a17:90b:4c52:b0:1e8:2af5:901e with SMTP id np18-20020a17090b4c5200b001e82af5901emr5568640pjb.180.1654278216714;
        Fri, 03 Jun 2022 10:43:36 -0700 (PDT)
Received: from localhost.localdomain (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id a13-20020a170902710d00b0015e8d4eb1d2sm5705047pll.28.2022.06.03.10.43.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jun 2022 10:43:36 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>, stable@vger.kernel.org,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 2/9] lpfc: Resolve some cleanup issues following abort path refactoring
Date:   Fri,  3 Jun 2022 10:43:22 -0700
Message-Id: <20220603174329.63777-3-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220603174329.63777-1-jsmart2021@gmail.com>
References: <20220603174329.63777-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Following refactoring and consolidation of abort paths,

- lpfc_sli4_abort_fcp_cmpl and lpfc_sli_abort_fcp_cmpl are combined into
  a single generic lpfc_sli_abort_fcp_cmpl routine.  Thus, remove
  extraneous lpfc_sli4_abort_fcp_cmpl prototype declaration.

- lpfc_nvme_abort_fcreq_cmpl abort completion routine is called with a
  mismatched argument type.  This may result in misleading log message
  content.  Update to the correct argument type of lpfc_iocbq instead
  of lpfc_wcqe_complete.  The lpfc_wcqe_complete should be derived from
  the lpfc_iocbq structure.

Fixes: 31a59f75702f ("scsi: lpfc: SLI path split: Refactor Abort paths")
Cc: <stable@vger.kernel.org> # v5.18
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_crtn.h | 4 +---
 drivers/scsi/lpfc/lpfc_nvme.c | 6 ++++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index b1be0dd0337a..f5d74958b664 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -420,8 +420,6 @@ int lpfc_sli_issue_iocb_wait(struct lpfc_hba *, uint32_t,
 			     uint32_t);
 void lpfc_sli_abort_fcp_cmpl(struct lpfc_hba *, struct lpfc_iocbq *,
 			     struct lpfc_iocbq *);
-void lpfc_sli4_abort_fcp_cmpl(struct lpfc_hba *h, struct lpfc_iocbq *i,
-			      struct lpfc_wcqe_complete *w);
 
 void lpfc_sli_free_hbq(struct lpfc_hba *, struct hbq_dmabuf *);
 
@@ -630,7 +628,7 @@ void lpfc_nvmet_invalidate_host(struct lpfc_hba *phba,
 			struct lpfc_nodelist *ndlp);
 void lpfc_nvme_abort_fcreq_cmpl(struct lpfc_hba *phba,
 				struct lpfc_iocbq *cmdiocb,
-				struct lpfc_wcqe_complete *abts_cmpl);
+				struct lpfc_iocbq *rspiocb);
 void lpfc_create_multixri_pools(struct lpfc_hba *phba);
 void lpfc_create_destroy_pools(struct lpfc_hba *phba);
 void lpfc_move_xri_pvt_to_pbl(struct lpfc_hba *phba, u32 hwqid);
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 335e90633933..88fa630ab93a 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -1787,7 +1787,7 @@ lpfc_nvme_fcp_io_submit(struct nvme_fc_local_port *pnvme_lport,
  * lpfc_nvme_abort_fcreq_cmpl - Complete an NVME FCP abort request.
  * @phba: Pointer to HBA context object
  * @cmdiocb: Pointer to command iocb object.
- * @abts_cmpl: Pointer to wcqe complete object.
+ * @rspiocb: Pointer to response iocb object.
  *
  * This is the callback function for any NVME FCP IO that was aborted.
  *
@@ -1796,8 +1796,10 @@ lpfc_nvme_fcp_io_submit(struct nvme_fc_local_port *pnvme_lport,
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
2.26.2

