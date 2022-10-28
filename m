Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF2DA611C31
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 23:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbiJ1VJM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 17:09:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbiJ1VJB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 17:09:01 -0400
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0299424A54D
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 14:09:01 -0700 (PDT)
Received: by mail-qv1-xf31.google.com with SMTP id x15so4898710qvp.1
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 14:09:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y1hSeBOu2cOgFhT+r/sXFCenzZr2nzfDwyIVncbm1nY=;
        b=gShDwC1XxGZLEQPjWgoQ05eE9RWpSQe1JnNw2ofq1khXuz2BJ5ksrcKR9PjYmpOxxO
         6JcLql7ncnKM7i0CN6/VriRq5pr1TbepzE3vHbQqf/DGxSteF8JnvoQeMOLFtxq4W0Jr
         2UIN9fu+tcBhA2rEzMQG59gPR1zPVzbjG3+tKCkq+C9uogmmg3BMPgqMDkpgQHTtee90
         zI2L2nl76qAOuha8G48THxUxD45WD4307aebxH1FEV9J8nVHd7FHX924Wxc4pajYqoyO
         PC0AMvs9Cke/PDSVN+fHRA29rNwdbyHrXacJq6tZSkZh883AQXwYgqeLN3Ia0rV4Ohsg
         zaTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y1hSeBOu2cOgFhT+r/sXFCenzZr2nzfDwyIVncbm1nY=;
        b=wi76AIkYYLUBm9NBMj0hGoF620gkcJI+9JcWjviGjSYNz1cuzlc3zfT5w3b394QaEn
         pue7h/rrcJCLgxEwOMlKjBPi8Sd1lC08qurlpJUMKYFIe16m7gObWHHZTf/ReJL8mInf
         4oizr/5Xuw+KdjwyOob+sJ6xQSGzFVBn5qoWEHddV9+2FcHG/danrzg22EKqUwPWHJwr
         hZXPagnC+4EPSHq4lKBamVyA8P8B8nvCY7HZxRdvcFTmHhmzsSO2LOKYoUk+x7j5TiOR
         BEFd0d7SA8+fE9zol7RxbpI5BDCbYMWsSBvkJnLmrsYS4Rnnw+AMUrdt0HF65oWannIv
         9yow==
X-Gm-Message-State: ACrzQf1bC/uKxK/ahuHq4aOSzOnbLz2NDkaB6P9XYo+SleQCEr89l4kv
        7Gz+d90Nksvki2y/dKJkVjG+krEJsPY=
X-Google-Smtp-Source: AMsMyM5uPSAL+XcXEx+aotSocdV1dtAtxyASyQ2CbGXjUSqazvwzhX4a0dVJPTwEVQRMT9GvSVcWIw==
X-Received: by 2002:a05:6214:dac:b0:4bb:5901:38b1 with SMTP id h12-20020a0562140dac00b004bb590138b1mr1369590qvh.18.1666991340031;
        Fri, 28 Oct 2022 14:09:00 -0700 (PDT)
Received: from mail-lvn-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id fu36-20020a05622a5da400b0035cf31005e2sm2906808qtb.73.2022.10.28.14.08.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 14:08:59 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     stable@vger.kernel.org
Cc:     jsmart2021@gmail.com, justintee8345@gmail.com,
        martin.petersen@oracle.com, gregkh@linuxfoundation.org
Subject: [PATCH v2 2/6] Revert "scsi: lpfc: Fix element offset in __lpfc_sli_release_iocbq_s4()"
Date:   Fri, 28 Oct 2022 14:08:23 -0700
Message-Id: <20221028210827.23149-3-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20221028210827.23149-1-jsmart2021@gmail.com>
References: <20221028210827.23149-1-jsmart2021@gmail.com>
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

This reverts commit 6e99860de6f4e286c386f533c4d35e7e283803d4.

LTS 5.15 pulled in several lpfc "SLI Path split" patches.  The Path
Split mods were a 14-patch set, which refactors the driver from
to split the sli-3 hw (now eol) from the sli-4 hw and use sli4
structures natively. The patches are highly inter-related.

Given only some of the patches were included, it created a situation
where FLOGI's fail, thus SLI Ports can't start communication.

Reverting this patch as its a fix specific to the Path Split patches,
which were partially included and now being pulled from 5.15.

Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 85de54ba444b..400039c0e076 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -1384,7 +1384,7 @@ static void
 __lpfc_sli_release_iocbq_s4(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq)
 {
 	struct lpfc_sglq *sglq;
-	size_t start_clean = offsetof(struct lpfc_iocbq, wqe);
+	size_t start_clean = offsetof(struct lpfc_iocbq, iocb);
 	unsigned long iflag = 0;
 	struct lpfc_sli_ring *pring;
 
-- 
2.35.3

