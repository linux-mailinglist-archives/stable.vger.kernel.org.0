Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC2E60D789
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 00:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232566AbiJYW6q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 18:58:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232807AbiJYW6p (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 18:58:45 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAFCCCAE6C
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 15:58:44 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id o2so9309905qkk.10
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 15:58:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aFMEoA/54wGtOVBqLL015sE0WN8Pm0PYrkrPmKFbOWM=;
        b=m74ItWMGHhFbMGvZq3U4NAATYvY9EFTdL4VEa0Oc2Xg7j7ZKycVrJPRl841B92mMVk
         pNZ82hS6nCL9YroLVJW3NHEg4RTk+MHL82Lo3kpsoKRuv0pKuSrUNGH8C0n6V0ksKrIE
         NFTjvv98NeC1CTkRYxgZd593OSIv5+6yCq8QicWf8RaAraDs1MKbdcAI1gagEMPA4s84
         Znb2DA5TKaDObGCDiWeH64JofKeCiKXrxnbQj4uePq/wZKe2deBnqZQzYxbBpnOV5iiO
         BAZH8swpn7qj9vcOWL8L8Kh3w/q9XLmQC8heArIbyekRdvBxNaJGiAfFaYI5TWo6nedI
         83UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aFMEoA/54wGtOVBqLL015sE0WN8Pm0PYrkrPmKFbOWM=;
        b=v1SeUvGlKXzmYXug547gWr7wzRgjDS0oaNUfEVZ6Hi8uR0MKNqN7cWeVXd5uqe3T4P
         wi4uN1Sn31jdHTa+HtCqasLK14y8CXPd0KjGbz216G6aVGUOWL+43Tl/6czQuJt5AKla
         0dWjdpOKW+H1lD4gJNenkv6uLBOlaRhUCci+AGL4aI+S1Zcq311L1iVsEh57Zjh+JpsV
         FhkUIml1RY71GY4/NDGOHSmm2IMP4tP6bc6TW/R2mL/OBg5kH5+Sy28dHXkU10/nzi12
         u3hnZh23ktRqeZCcE40nqsP8gJj7T1faXOdLbxKJsLiVmWD0IngF13YAFt7lJv5pAT7r
         fDNw==
X-Gm-Message-State: ACrzQf3UYZ3t8HQgyFKESz3hq35al2hmq8X6BkbkQVO8ROT214uAjX9Q
        M5iyKpTRu25DrSWWF8Poa9snBD/aO2g=
X-Google-Smtp-Source: AMsMyM6buREKC+jAer1xq9x4ceJvDVNtv+7ZtLMKuangTe9GkZQioNUmcuumZrREapsZiby9XCUnRA==
X-Received: by 2002:a37:aa43:0:b0:6eb:f80:ec46 with SMTP id t64-20020a37aa43000000b006eb0f80ec46mr29452139qke.106.1666738723919;
        Tue, 25 Oct 2022 15:58:43 -0700 (PDT)
Received: from mail-ash-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r12-20020ae9d60c000000b006ecdfcf9d81sm2823766qkk.84.2022.10.25.15.58.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 15:58:43 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     stable@vger.kernel.org
Cc:     jsmart2021@gmail.com, justintee8345@gmail.com,
        martin.petersen@oracle.com, gregkh@linuxfoundation.org,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 24/33] scsi: lpfc: Fix broken SLI4 abort path
Date:   Tue, 25 Oct 2022 15:57:30 -0700
Message-Id: <20221025225739.85182-25-jsmart2021@gmail.com>
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

There was a merge error in ther 14.2.0.0 patches that resulted in the SLI4
path using the SLI3 issue_abort_iotag() routine. This resulted in txcmplq
corruption.

Fix to use the SLI4 routine when SLI4.

Link: https://lore.kernel.org/r/20220323205545.81814-2-jsmart2021@gmail.com
Fixes: 31a59f75702f ("scsi: lpfc: SLI path split: Refactor Abort paths")
Cc: <stable@vger.kernel.org> # v5.2+
Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index ac25ba9dfd6a..859c622d12d9 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5924,13 +5924,15 @@ lpfc_abort_handler(struct scsi_cmnd *cmnd)
 	}
 
 	lpfc_cmd->waitq = &waitq;
-	if (phba->sli_rev == LPFC_SLI_REV4)
+	if (phba->sli_rev == LPFC_SLI_REV4) {
 		spin_unlock(&pring_s4->ring_lock);
-	else
+		ret_val = lpfc_sli4_issue_abort_iotag(phba, iocb,
+						      lpfc_sli_abort_fcp_cmpl);
+	} else {
 		pring = &phba->sli.sli3_ring[LPFC_FCP_RING];
-
-	ret_val = lpfc_sli_issue_abort_iotag(phba, pring, iocb,
-					     lpfc_sli_abort_fcp_cmpl);
+		ret_val = lpfc_sli_issue_abort_iotag(phba, pring, iocb,
+						     lpfc_sli_abort_fcp_cmpl);
+	}
 
 	/* Make sure HBA is alive */
 	lpfc_issue_hb_tmo(phba);
-- 
2.35.3

