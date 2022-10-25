Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21FCC60D780
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 00:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232788AbiJYW6e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 18:58:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232798AbiJYW6c (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 18:58:32 -0400
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B283CABC4
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 15:58:32 -0700 (PDT)
Received: by mail-qv1-xf2f.google.com with SMTP id ml12so8967189qvb.0
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 15:58:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Eei4zt5laM2dpinJrZbBF76+eywa3VaGG2G5YuOdhEg=;
        b=fmm3zngy9XfI8zYk7jTlY8nqRQa4eN4VEhUW3YrwXOWnfiFnqXt+m1l6u4JXqu8HlE
         t0LgnEI3x6G9XUgTGhEU81CaAtQk1AiAPqMb6ly5gjxWugI+CNwAbC0y4K36qigQ1YCj
         zgC8KFbfSaSY45oMXlb/6u+4RoeKXpxAEnxBkVb8XFVJuknqWqx4Irg+5pxi+8RJvMR+
         2hRysmiUdF/dkwRHSSyi4IhK9vb5OhQCAypWakHicPhsKIjYRQfj8TilnfO4BseuXJhb
         CW/WJvaAh+1bi5g58PUvZ95br4Pu00unfZSzeSFE+pG6hytDjVHYsNgB3zacBB7OAcZ/
         J+Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Eei4zt5laM2dpinJrZbBF76+eywa3VaGG2G5YuOdhEg=;
        b=R3XVBKU/HypIpqMrpMZ5Yn0DUQVPm10zuBl+3ugPGo4tDjIYqnOGo+e3ZW+Q8qNU86
         RQFmDUWAMT2qhXeLJ5DZ786+vhnNsBWd6ICq7jGf+LKktEBnL8PjOYyeFD8EPf9hOtJY
         qE4RDTJ+WP/8VAE514YL/X2zklrBd48GCHnwgfOfOWG0M32ylvito3r+/QVZQHqUqGIn
         OYAWw30XEhdsZS7tPTbVra4YB4Uk5YCYaYKA3ES2QoXOmHIhxQsT8yPWKSgA2YGvcmJO
         88qiYX6yEyz5uCQw6KsPtUBB9JxC0hD4nIifSkM1toeq1vGJTKE6jo1J2xdHLswW572V
         yrew==
X-Gm-Message-State: ACrzQf2OS8xXWgMbHXIqT0H6QVhTwjgwq2XL0yJmKoaVJdAAb1mvgYPo
        Z4uFe6XRapZaDDPBL57sP0cMrRpJG1s=
X-Google-Smtp-Source: AMsMyM5YPhnq0VuCnGV8vA0+7b2xX6C0TH4DMeTo/KFPe/b6wEZgEo1TL1gukEWTuYnPHyfGd++oUg==
X-Received: by 2002:a05:6214:2346:b0:496:ba45:bdb0 with SMTP id hu6-20020a056214234600b00496ba45bdb0mr35000014qvb.47.1666738711099;
        Tue, 25 Oct 2022 15:58:31 -0700 (PDT)
Received: from mail-ash-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r12-20020ae9d60c000000b006ecdfcf9d81sm2823766qkk.84.2022.10.25.15.58.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 15:58:30 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     stable@vger.kernel.org
Cc:     jsmart2021@gmail.com, justintee8345@gmail.com,
        martin.petersen@oracle.com, gregkh@linuxfoundation.org,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 15/33] scsi: lpfc: SLI path split: Refactor LS_RJT paths
Date:   Tue, 25 Oct 2022 15:57:21 -0700
Message-Id: <20221025225739.85182-16-jsmart2021@gmail.com>
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

This patch refactors the LS_RJT paths to use SLI-4 as the primary
interface:

 - Conversion away from using SLI-3 iocb structures to set/access fields in
   common routines. Use the new generic get/set routines that were added.
   This move changes code from indirect structure references to using local
   variables with the generic routines.

 - Refactor routines when setting non-generic fields, to have both SLI3 and
   SLI4 specific sections. This replaces the set-as-SLI3 then translate to
   SLI4 behavior of the past.

Link: https://lore.kernel.org/r/20220225022308.16486-9-jsmart2021@gmail.com
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 23cdd1d0c700..1376dd486aa3 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -5701,6 +5701,7 @@ lpfc_els_rsp_reject(struct lpfc_vport *vport, uint32_t rejectError,
 	struct lpfc_hba  *phba = vport->phba;
 	IOCB_t *icmd;
 	IOCB_t *oldcmd;
+	union lpfc_wqe128 *wqe;
 	struct lpfc_iocbq *elsiocb;
 	uint8_t *pcmd;
 	uint16_t cmdsize;
@@ -5711,10 +5712,19 @@ lpfc_els_rsp_reject(struct lpfc_vport *vport, uint32_t rejectError,
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
+		bf_set(wqe_rcvoxid, &wqe->xmit_els_rsp.wqe_com,
+		       get_job_rcvoxid(phba, oldiocb));
+	} else {
+		icmd = &elsiocb->iocb;
+		oldcmd = &oldiocb->iocb;
+		icmd->ulpContext = oldcmd->ulpContext; /* Xri / rx_id */
+		icmd->unsli3.rcvsli3.ox_id = oldcmd->unsli3.rcvsli3.ox_id;
+	}
+
 	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
 
 	*((uint32_t *) (pcmd)) = ELS_CMD_LS_RJT;
@@ -5730,7 +5740,7 @@ lpfc_els_rsp_reject(struct lpfc_vport *vport, uint32_t rejectError,
 			 "xri x%x, did x%x, nlp_flag x%x, nlp_state x%x, "
 			 "rpi x%x\n",
 			 rejectError, elsiocb->iotag,
-			 elsiocb->iocb.ulpContext, ndlp->nlp_DID,
+			 get_job_ulpcontext(phba, elsiocb), ndlp->nlp_DID,
 			 ndlp->nlp_flag, ndlp->nlp_state, ndlp->nlp_rpi);
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_RSP,
 		"Issue LS_RJT:    did:x%x flg:x%x err:x%x",
-- 
2.35.3

