Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDC84220C95
	for <lists+stable@lfdr.de>; Wed, 15 Jul 2020 14:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729795AbgGOMCa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jul 2020 08:02:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728263AbgGOMCa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jul 2020 08:02:30 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABE63C061755
        for <stable@vger.kernel.org>; Wed, 15 Jul 2020 05:02:29 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id 22so5322931wmg.1
        for <stable@vger.kernel.org>; Wed, 15 Jul 2020 05:02:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=1q9naME8Z7fmnrPEUn5qBaqeLMpv52pRM581fmdSY7c=;
        b=bI6/xgmDdLl1CYvhidaQxvatrhyjRmj76zy+BAn+Nogfq6Chu5oa8Bwrr6Wxci2DfD
         REq3n329UPvQgqhjoWGD39l4iW7NUUJr+PVOEEcNqOhwgiGgVKDQyZ/zKwdaWFMg6bwZ
         0NbONILkQ/D+SugIh9c1U9KuDzhm6Fad/wNWY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=1q9naME8Z7fmnrPEUn5qBaqeLMpv52pRM581fmdSY7c=;
        b=BkTvP7UIktMTLtSVjBLcHKDx4+cbnYlQYdpEz4ZBvew9hpX5qHeLiagQrBMXsqfdyp
         L1985ma9E5dVn2lTHAA18jJ6bbvBYHgMQd6J8O4eWG1fg1eemmFknm3JBDweehpjwlLK
         IIJH1vodK2rpOl3PtFp9bxWm4Af5skTMF7PRUhK3EyygOngL06r5blClERfEMrTHL9re
         9rMnCDoEyQPyFp3mOqfIq0E7RVW+E9OeE9ebagX/UhKyc8qFhKGEMmLriW2zLOFvJEMi
         0Z38nutPqgqcwJFyW1+63soHnQmWf/5SnvFvyq/h4b/8/tOwKdJhfObhxpnaUXI2xr+O
         EQAQ==
X-Gm-Message-State: AOAM5310mhkVKMErCB6OkR/Wftsd0BWWTsXtncMVg9hvCprefRjpj/Rt
        7g7nSq39ibd5k2C4MHUqI0SPUw==
X-Google-Smtp-Source: ABdhPJxpzCCTWfaSQGJ7J2T4VC0vrkpKvlNqlenAr0YScPOoHsP3N9Gn7hzOOfRzjyUBZxKoLDHXGg==
X-Received: by 2002:a1c:dcd5:: with SMTP id t204mr8178717wmg.17.1594814548309;
        Wed, 15 Jul 2020 05:02:28 -0700 (PDT)
Received: from it_dev_server1.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 65sm3969452wre.6.2020.07.15.05.02.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2020 05:02:27 -0700 (PDT)
From:   Chandrakanth Patil <chandrakanth.patil@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        kiran-kumar.kasturi@broadcom.com, sankar.patra@broadcom.com,
        sasikumar.pc@broadcom.com, shivasharan.srikanteshwara@broadcom.com,
        anand.lodnoor@broadcom.com,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
        "# v5 . 3+" <stable@vger.kernel.org>
Subject: [PATCH] megaraid_sas: remove undefined ENABLE_IRQ_POLL macro
Date:   Wed, 15 Jul 2020 17:31:53 +0530
Message-Id: <20200715120153.20512-1-chandrakanth.patil@broadcom.com>
X-Mailer: git-send-email 2.9.5
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Issue:
As ENABLE_IRQ_POLL macro is undefined, the check for ENABLE_IRQ_POLL
macro in ISR will always be false leads to irq polling non-functional.

Fix:
Remove ENABLE_IRQ_POLL check from isr

Fixes: a6ffd5bf6819 ("scsi: megaraid_sas: Call disable_irq from process IRQ")
Cc: <stable@vger.kernel.org> # v5.3+
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index bb34278..0824410 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -3740,10 +3740,8 @@ static irqreturn_t megasas_isr_fusion(int irq, void *devp)
 	if (instance->mask_interrupts)
 		return IRQ_NONE;
 
-#if defined(ENABLE_IRQ_POLL)
 	if (irq_context->irq_poll_scheduled)
 		return IRQ_HANDLED;
-#endif
 
 	if (!instance->msix_vectors) {
 		mfiStatus = instance->instancet->clear_intr(instance);
-- 
2.9.5

