Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62DA860D78C
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 00:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232805AbiJYW6w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 18:58:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232799AbiJYW6u (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 18:58:50 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3257CABC4
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 15:58:48 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id d13so9327206qko.5
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 15:58:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WixtnkjIiakyjDMRRGYgga5pzScIBgbls6qg2ioGE5I=;
        b=OkdCWbdCs9EKfPdf/YHj9eghyLLdwO+gtZBC8j0e6/uWOstZwGaPfQruB+q2nTtwXy
         xLiAhusZs34Q3ZOGtMZ0OniwYCv3Xd36/O1qXsrMwM3ukCIHjsHGWJRyOUaAudTISuT3
         /37Ho7+rOqwK0eNJNOG0HETiYw2g+sDTnJGthbL98Vw98DL54B+Jwaz0ILuMl52AHDce
         T5s8UN8M3Peu4MeUoJMbxD9euxbNojyDlw5aHXHCn5CGnsk7VntwFe29aaamDZjzUmQK
         rMRG1dlwmuQ3fn7quSQ5pbHNHP04i9XOohXaxruEYH+eTZ9iZOHe329jGyC7k6h4OGJ0
         WE3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WixtnkjIiakyjDMRRGYgga5pzScIBgbls6qg2ioGE5I=;
        b=BB9CkjHiG6Vbo+nSbJc2o8k7PCeX10y+JA3r0LO2d/pR0gNZL2ZvUQtXUNs/aNLCA8
         YcNKeu7TobyjBTlJWIq6+g8etkk6ULy8q8TgdbfcLLMm+o3k0+w5gFQqqrghoDEk758I
         CxCNAZ2wD4vcNangPPD51DTbDac/MTeJDDnnLx6GV5eVHYrl286IUpJxOtrOPmGvRZ7v
         rQxCDF1DjEws/UX1YbRVDJMK+mUW7UY0ZpEI2ANtWYqmduDp8G7WujY3zXS2lEWM9uYF
         VT7vpHelu4FFj/FCAwIkz2+YG8mjsqiEi6n2Ej8QuoXC/Yg8b2bXu9TK9WRva+JPI0JF
         xhrg==
X-Gm-Message-State: ACrzQf3NWHK3HqCkUNU6c9MOi5cV/Teos8p07X6pTVd0NbcGbPGFeyW4
        eOMXsbTZ77ULDZeqRvC/9VsmSWLPpOk=
X-Google-Smtp-Source: AMsMyM7LNb9wTox4SYg71agtMo2ZXLFmIGxC1NYq/FH0lOg+NzQh81X9cAqR/aVQtfBoaIdeSD56Eg==
X-Received: by 2002:a05:620a:4114:b0:6ee:dfb7:1584 with SMTP id j20-20020a05620a411400b006eedfb71584mr28668364qko.262.1666738727807;
        Tue, 25 Oct 2022 15:58:47 -0700 (PDT)
Received: from mail-ash-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r12-20020ae9d60c000000b006ecdfcf9d81sm2823766qkk.84.2022.10.25.15.58.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 15:58:47 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     stable@vger.kernel.org
Cc:     jsmart2021@gmail.com, justintee8345@gmail.com,
        martin.petersen@oracle.com, gregkh@linuxfoundation.org,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 27/33] scsi: lpfc: Fix split code for FLOGI on FCoE
Date:   Tue, 25 Oct 2022 15:57:33 -0700
Message-Id: <20221025225739.85182-28-jsmart2021@gmail.com>
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

The refactoring code converted context information from SLI-3 to SLI-4.
The conversion for the SLI-4 bit field tried to use the old (hacky) SLI3
high/low bit settings.  Needless to say, it was incorrect.

Explicitly set the context field to type FCFI and set it in the wqe.
SLI-4 is now a proper bit field so no need for the shifting/anding.

Link: https://lore.kernel.org/r/20220506205528.61590-1-jsmart2021@gmail.com
Fixes: 6831ce129f19 ("scsi: lpfc: SLI path split: Refactor base ELS paths and the FLOGI path")
Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 0315662272de..7a2741d02b0f 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1330,7 +1330,7 @@ lpfc_issue_els_flogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		if (bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) ==
 		    LPFC_SLI_INTF_IF_TYPE_0) {
 			/* FLOGI needs to be 3 for WQE FCFI */
-			ct = ((SLI4_CT_FCFI >> 1) & 1) | (SLI4_CT_FCFI & 1);
+			ct = SLI4_CT_FCFI;
 			bf_set(wqe_ct, &wqe->els_req.wqe_com, ct);
 
 			/* Set the fcfi to the fcfi we registered with */
-- 
2.35.3

