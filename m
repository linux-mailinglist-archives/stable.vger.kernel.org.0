Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D22A760D78D
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 00:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232799AbiJYW6x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 18:58:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232824AbiJYW6v (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 18:58:51 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AD80D01A1
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 15:58:50 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id c8so9288505qvn.10
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 15:58:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wAIf/CBavaUf/S+u/b5V1FvUmNOSc2utRHhR6vAsJMI=;
        b=jCRDfuEgQmAr+8RzBsz8dUPih1QL1jiOklDXhp+AV40mvlVB5uhrxGllR5DF8Y1wuF
         Z1fIGcjux9H2c8sR1TTTCElW2KUiuBVVcykydrcSqqb1oztX5331yQ+c0iR5uXW7yYhb
         t75lcGb5SlDb1shRXGqoDYxzAEN0WUvoYS5YXy9t0qcqBxN9StkBuoNz5kqOdpS9Nt/Y
         ajY8J+C35hQhPoDSGOyNfcigbicJjBtZk/wa/Ndds1OQT/SprmaXvj7G1453/9vRKdh2
         Zr1dY2IaWfM3xTX4TSq7/7sQzs3R9LjnLvpp+mTfy0G1rNH0PSJOr+QVXvFDgOQWmx6T
         DZvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wAIf/CBavaUf/S+u/b5V1FvUmNOSc2utRHhR6vAsJMI=;
        b=Dj7sk2uzKtV9uVIhA+wP12NILJDn+Cc9cUaUQoXCscTJi1yq4Fxe3kFhjs+eHZM5oR
         ezZTJp+KOvJAJcItlp71K3InIarsP/JQyXNrZpmHM1qAeIJrYhGEYyMKLF8lKQm7EVse
         y1ngwmJP7YtXNK2t/xKlNz2MPiW+jYgrKVlyt4cEs/QTcDaH5xMPPdwQYnprk1kN5V+a
         SBWKaxYGD2WMHZq6j7Scp4rifhTneoa1VyxR4+SdnHTXvC7/Y36qWbMMi8K7hJoCdddx
         8M0TO4xT4nnzxblpXOk7dC1IaY5LuKV/d/j3Oucgl4f2TWiaoe1jk1Zwya20OyhuRrZv
         0BJQ==
X-Gm-Message-State: ACrzQf19fw4ioudxKYSR8G2Xg7QorBa71Lu8AZ3oIfdm49FgCdKc4zkK
        jpE3MfLW1EL9CEYaW9Ws7m8QIJa9zWo=
X-Google-Smtp-Source: AMsMyM7tTCDkMIRtfdG+QYqaIbPP+2nArX8RDIraMHElUY+0LAf70tIbKItkhlo1nVSgrU2JT+lsSQ==
X-Received: by 2002:a05:6214:e8b:b0:4bb:7847:6617 with SMTP id hf11-20020a0562140e8b00b004bb78476617mr9174823qvb.95.1666738729618;
        Tue, 25 Oct 2022 15:58:49 -0700 (PDT)
Received: from mail-ash-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r12-20020ae9d60c000000b006ecdfcf9d81sm2823766qkk.84.2022.10.25.15.58.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 15:58:49 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     stable@vger.kernel.org
Cc:     jsmart2021@gmail.com, justintee8345@gmail.com,
        martin.petersen@oracle.com, gregkh@linuxfoundation.org,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 28/33] scsi: lpfc: Correct BDE DMA address assignment for GEN_REQ_WQE
Date:   Tue, 25 Oct 2022 15:57:34 -0700
Message-Id: <20221025225739.85182-29-jsmart2021@gmail.com>
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

Garbage FCoE CT frames are transmitted on the wire because of bad DMA ptr
addresses filled in the GEN_REQ_WQE.

The __lpfc_sli_prep_gen_req_s4() routine is using the wrong buffer for the
payload address. Change the DMA buffer assignment from the bmp buffer to
the bpl buffer.

Link: https://lore.kernel.org/r/20220506205548.61644-1-jsmart2021@gmail.com
Fixes: 61910d6a5243 ("scsi: lpfc: SLI path split: Refactor CT paths")
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 534f9c163874..0da462ba9077 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -10718,10 +10718,10 @@ __lpfc_sli_prep_gen_req_s4(struct lpfc_iocbq *cmdiocbq, struct lpfc_dmabuf *bmp,
 
 	/* Words 0 - 2 */
 	bde = (struct ulp_bde64_le *)&cmdwqe->generic.bde;
-	bde->addr_low = cpu_to_le32(putPaddrLow(bmp->phys));
-	bde->addr_high = cpu_to_le32(putPaddrHigh(bmp->phys));
+	bde->addr_low = bpl->addr_low;
+	bde->addr_high = bpl->addr_high;
 	bde->type_size = cpu_to_le32(xmit_len);
-	bde->type_size |= cpu_to_le32(ULP_BDE64_TYPE_BLP_64);
+	bde->type_size |= cpu_to_le32(ULP_BDE64_TYPE_BDE_64);
 
 	/* Word 3 */
 	cmdwqe->gen_req.request_payload_len = xmit_len;
-- 
2.35.3

