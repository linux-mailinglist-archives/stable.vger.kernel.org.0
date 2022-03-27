Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E036A4E8615
	for <lists+stable@lfdr.de>; Sun, 27 Mar 2022 07:42:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233353AbiC0Fo0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Mar 2022 01:44:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232608AbiC0FoZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Mar 2022 01:44:25 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CCF1388E;
        Sat, 26 Mar 2022 22:42:47 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id mp6-20020a17090b190600b001c6841b8a52so15813117pjb.5;
        Sat, 26 Mar 2022 22:42:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=BIgAFzY5xSuxnHp/6XHLLEysD/f28qmospLNaTnTvsI=;
        b=qf2GfyYRBlOjnfVWkgGEnpfA8ZUDTkU//NaUMXmvTpvdSnkgPI9T5LZ9nDdQKmEBsa
         8jwc3SNQYoYY1W7wwlsNDH4r3aVov4Izx0jH1wZZrh+02vNfbH2Onwg2mbRCHsy8pO92
         9jvCtyuer3iPixcerEMygNlBozwGYH+4/hZaixj2YT8sjkx6fan8/HOfwBSv+jzvtCYt
         4uolNsFxidroFYwD/V7pG6Yx1beOhscjrNXwJ/CPaePF4n4WAMIy56+xuMKd0NmqFmTf
         4LBNN0b2xDbWqSJsr4AyKYz1R6fPhMh7G6z6Pa/xMg4Xxrxyt0n5I8amMwkHCUu06ljW
         /TuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=BIgAFzY5xSuxnHp/6XHLLEysD/f28qmospLNaTnTvsI=;
        b=DIZtI5he6frIU/28dh9QiBvM/yYy2Yklun+CymiGfk+8XNbpOze7LEhm+k9NZTESaH
         ZBuxeldGuQ0OwbDdLIniy9HAgg5Vw1K3d9KIJPf/c997VKsbYiCfG0Y6c0k4t2Tu7qcW
         voE8VXQnPBx1ZaiWqvDnOCM9Oulyc3+QZhRRD0i/mf5cpDGOJI8+Qim1CEJTfcOjzQR4
         iFpafHyxpKIc3Pdk89E+ibYjucU3j5flAyu4ogBB1R0M9joh9A/4rPPfPT12o+HrI0jI
         t///h6jnHppgC9UbiavK1pegPNSJ+YFuWLnKhaioQLErGnuUdQx+kyhyL/h0KuXouumR
         ZMsg==
X-Gm-Message-State: AOAM530ypJKA8bWHfbihGXPlXafe0EEmeOka4a8SebdKhIkLNqz0u3ef
        hRBsOhnr+xPj4btvO8BNZ0g=
X-Google-Smtp-Source: ABdhPJyq0CTbnGoZLO1ehTFMJoJbrbYZfQdvuXifqtPDbWycjs2djMGABZcqNvBalVp4kqzCUE3Hng==
X-Received: by 2002:a17:903:120c:b0:154:c135:60d3 with SMTP id l12-20020a170903120c00b00154c13560d3mr18898830plh.48.1648359767042;
        Sat, 26 Mar 2022 22:42:47 -0700 (PDT)
Received: from localhost.localdomain ([115.220.243.108])
        by smtp.googlemail.com with ESMTPSA id l4-20020a056a0016c400b004f79504ef9csm11409179pfc.3.2022.03.26.22.42.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Mar 2022 22:42:46 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     jejb@linux.ibm.com
Cc:     martin.petersen@oracle.com, linux@rainbow-software.org,
        hare@suse.de, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] scsi: wd719x: fix a missing check on list iterator
Date:   Sun, 27 Mar 2022 13:42:40 +0800
Message-Id: <20220327054240.3205-1-xiam0nd.tong@gmail.com>
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

