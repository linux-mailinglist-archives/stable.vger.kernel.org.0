Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0CE75004F9
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 06:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238735AbiDNETV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 00:19:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbiDNETU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 00:19:20 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4C9232ECD;
        Wed, 13 Apr 2022 21:16:57 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id e8-20020a17090a118800b001cb13402ea2so4571859pja.0;
        Wed, 13 Apr 2022 21:16:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=BIgAFzY5xSuxnHp/6XHLLEysD/f28qmospLNaTnTvsI=;
        b=G9Ulm2hp/FC95oIWoG+QcBJp0I7+ujG8ETqGU7crjc+cLm//GwAaAg1fRGHmIdA2Vm
         LtAWAOZtpU8p42CBFBtyL++1rBoXSNbS5l8TCrtegEE+u28AMa7VCZ9JbtrNScFuM2Qz
         R1D9AJD5KMXTz6vCz0Bl+oj7OmNqQ7LH/0G1WoLPy4pG8Mkkf/QXvkd+GMI3FKYRlGVT
         eZBAYfuZvRUEThS0Var0tEAvwxFr+JIHaCr7SqNEmqNU20HRQDfimT6u2O19edQ4661Z
         1wy73HuOCC6ZecIctZ826gK8h1Cyigcul99MxSGkcdS89ydbZHiJ9fv/cAAnAvK8d+gA
         IsHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=BIgAFzY5xSuxnHp/6XHLLEysD/f28qmospLNaTnTvsI=;
        b=ZOhKeldXji+TK6Yp6jhBXVLx7lm3bEy39JxuUBRCGHoppYkreJGuiHZp+c6+Azwx2g
         rCeAI2tQX5dFpqdNoP0GRr4TVV49HKyRn9664DU3gSWq7hsjyK7NFfDj2aQEzLJHADoW
         GmVU/AlDEKrp4wj09DT8v0d9PM3vO4X6KP9tIq6Hwnf69FalhS+jKcmGqkaOeoHKCVXb
         jv93ELwBbexkwJyXzHCaSZRdVwCRdJZj81DC0reNyrpI5i8RHvf74Q40pBJQ39VgiVux
         Db6xGlf1gHE8Ms0ngsg69PdrFB6oMnabuGXQSD0l1yAat6JNkD9IF94OT8gySvxYbCDt
         3x1w==
X-Gm-Message-State: AOAM531CyaeBhkBvLe8nKFhw7fjpiBy5SA0krbQ7gVgtxFoBMzVVU5Jr
        goF4KwThW97dgh6Pxjs6C2o=
X-Google-Smtp-Source: ABdhPJxjX/K6Ga3KLvwGRTrOp8TKKRgBbDwr3l0xZT8z8QcQVKLiD/nyNSgCwRmazXlUTBnEEnvmdw==
X-Received: by 2002:a17:902:a981:b0:156:229d:6834 with SMTP id bh1-20020a170902a98100b00156229d6834mr44078326plb.128.1649909817005;
        Wed, 13 Apr 2022 21:16:57 -0700 (PDT)
Received: from localhost.localdomain ([119.3.119.18])
        by smtp.gmail.com with ESMTPSA id ne24-20020a17090b375800b001cb62235013sm556992pjb.5.2022.04.13.21.16.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 21:16:56 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux@rainbow-software.org, hare@suse.de
Cc:     linux-kernel@vger.kernel.org,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>, stable@vger.kernel.org
Subject: [RESEND][PATCH] scsi: wd719x: fix a missing check on list iterator
Date:   Thu, 14 Apr 2022 12:16:48 +0800
Message-Id: <20220414041648.3543-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The bug is here:
    if (SCB_out == scb->phys)

The list iterator 'scb' will point to a bogus position containing
HEAD if the list is empty or no element is found. This case must
be checked before any use of the iterator, otherwise it will lead
to a invalid memory access.

To fix this bug, add an check. Use a new variable 'iter' as the
list iterator, while use the old variable 'scb' as a dedicated
pointer to point to the found element.

Cc: stable@vger.kernel.org
Fixes: 48a3103006631 ("wd719x: Introduce Western Digital WD7193/7197/7296 PCI SCSI card driver")
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
---
 drivers/scsi/wd719x.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/wd719x.c b/drivers/scsi/wd719x.c
index 1a7947554581..6087ff4c05da 100644
--- a/drivers/scsi/wd719x.c
+++ b/drivers/scsi/wd719x.c
@@ -684,11 +684,15 @@ static irqreturn_t wd719x_interrupt(int irq, void *dev_id)
 	case WD719X_INT_SPIDERFAILED:
 		/* was the cmd completed a direct or SCB command? */
 		if (regs.bytes.OPC == WD719X_CMD_PROCESS_SCB) {
-			struct wd719x_scb *scb;
-			list_for_each_entry(scb, &wd->active_scbs, list)
-				if (SCB_out == scb->phys)
+			struct wd719x_scb *scb = NULL, *iter;
+
+			list_for_each_entry(iter, &wd->active_scbs, list)
+				if (SCB_out == iter->phys) {
+					scb = iter;
 					break;
-			if (SCB_out == scb->phys)
+				}
+
+			if (scb)
 				wd719x_interrupt_SCB(wd, regs, scb);
 			else
 				dev_err(&wd->pdev->dev, "card returned invalid SCB pointer\n");
-- 
2.17.1

