Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5361960D78E
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 00:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231861AbiJYW6x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 18:58:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232807AbiJYW6w (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 18:58:52 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FF48CAE6C
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 15:58:51 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id x15so10015988qvp.1
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 15:58:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i+9uBJ8pK3efz2Sp5pVap5qdEYHCVUG2NxU7rHG0AOI=;
        b=aEsi4fvJEzn6+usXwFL8G/z3NNFhUbnTuB9mD15aIs1ZO/hZ6xarl9mKaTl+Ashv1O
         FcT5QypBZp8emMH4Pvg8wspvaApEAqGk59lMY1CJxQk9n3fiDP/0EQtTGdaDIXSAMu/Y
         Gr4uhCdyaqMwSd/4hQV5Wtn2QN8jRCcywJ2VVZHobqnDx/s1W9HZXdVwU9rPWpMgWiMM
         kDRRLc9xMLEUziUy6StEp2SFIYuL9MUsuq8mt/9TuvGKZJtRSrlPadCVjflHNvjRpi/l
         BVn8LrnkiJOwJ11S0No9E9/QB17K7BU1JiCLAGnYpB6pKgg9pzbhXcx1AydU7hYABjnq
         49Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i+9uBJ8pK3efz2Sp5pVap5qdEYHCVUG2NxU7rHG0AOI=;
        b=1f4ZrqkbAd/ZTxIxQAAk+1Qna/H7b3H+RTCGIY2Mwzv2HuNNzpJO5RZFCjyxpYeMKe
         /Ftf3Ao+lWxO/pXxoYMRyBFp8kFu7oPrE+umbEYlfDJD7b49QMDTkkV8RXZ30EjCLAoa
         6tZxgFeqxGonczDFTTphZFHBBKFXsAWuQgv5OzGi11tn24RwGsyqKlHe+GaHuyo7rGhz
         /WsyQYisArLFuuJ7FLGOHvUAiK6Shb7w0/YIOFPQB1gMIZLewDC2RI+7z4K0ohp9MqWZ
         82u24GK4kdsnDb7vBwu63JAkldGMKnwKj2K2BVjQVlBPSBsIAldeli1WmxkBBmOEKgAX
         VAFA==
X-Gm-Message-State: ACrzQf0+C8ErdFQhhyUA+gIBAJ9eX7PMWpVYBbT6qUcy3+1vRW2yDMy9
        UyXxK1+F6EzrCfyrZth2Pb20GoyAPCA=
X-Google-Smtp-Source: AMsMyM5cGZYUw/W/WpWyIWa2CAxRUXnkK4TIuk1eg6oozcVBZk1XXVLEYThqnZht3eSfOS3Yjtfb2g==
X-Received: by 2002:a05:6214:ac5:b0:4b3:203b:7393 with SMTP id g5-20020a0562140ac500b004b3203b7393mr33692283qvi.63.1666738730955;
        Tue, 25 Oct 2022 15:58:50 -0700 (PDT)
Received: from mail-ash-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r12-20020ae9d60c000000b006ecdfcf9d81sm2823766qkk.84.2022.10.25.15.58.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 15:58:50 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     stable@vger.kernel.org
Cc:     jsmart2021@gmail.com, justintee8345@gmail.com,
        martin.petersen@oracle.com, gregkh@linuxfoundation.org,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 29/33] scsi: lpfc: Fix element offset in __lpfc_sli_release_iocbq_s4()
Date:   Tue, 25 Oct 2022 15:57:35 -0700
Message-Id: <20221025225739.85182-30-jsmart2021@gmail.com>
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

The prior commit that moved from iocb elements to explicit wqe elements
missed a name change.

Correct __lpfc_sli_release_iocbq_s4() to reference wqe rather than iocb.

Link: https://lore.kernel.org/r/20220506035519.50908-2-jsmart2021@gmail.com
Fixes: a680a9298e7b ("scsi: lpfc: SLI path split: Refactor lpfc_iocbq")
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 0da462ba9077..f38ac537649b 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -1373,7 +1373,7 @@ static void
 __lpfc_sli_release_iocbq_s4(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq)
 {
 	struct lpfc_sglq *sglq;
-	size_t start_clean = offsetof(struct lpfc_iocbq, iocb);
+	size_t start_clean = offsetof(struct lpfc_iocbq, wqe);
 	unsigned long iflag = 0;
 	struct lpfc_sli_ring *pring;
 
-- 
2.35.3

