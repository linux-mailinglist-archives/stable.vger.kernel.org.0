Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 692FE2EE7B0
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 22:37:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727009AbhAGVg5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 16:36:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726541AbhAGVg5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jan 2021 16:36:57 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8CD2C0612F9
        for <stable@vger.kernel.org>; Thu,  7 Jan 2021 13:36:11 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id 190so6306209wmz.0
        for <stable@vger.kernel.org>; Thu, 07 Jan 2021 13:36:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kresin-me.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VvOCmj+9eKTgcp69Yq+M+KAzZiZk937sl5Sjur3l8dk=;
        b=QX0fey78f2iupaSHbloW8o5y1t2hIfEeZ+ljJkz1jr8MfuoQzk0vUe/DX22GK8Ik6P
         jGrDLOoKVHTj5qM5kCoMnEGLspWFyxsThr3BAjEhfDa02WUWRz3F2d+60LPZCZQBmLiJ
         tIFA6Fu6ks3Lc+Y1Dq11VLV5PcFd+QcO4vnb9uFJOT2reqrurAXggd+g+e1I/VcEJsvR
         kEQGmogH4p2ZuoQdrRgk3XJnNGG035Q5dTlZJsgnoOfySXNw6yQMEk0mQrKliWto1Ask
         kMyrVm79LCni8s/hyy1QVhDm9T/MyrFaYBiATfYkba5KqvAskOkYZdnCZ4HD0sE8R5aF
         S0pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VvOCmj+9eKTgcp69Yq+M+KAzZiZk937sl5Sjur3l8dk=;
        b=nl2xJcpCeqvaWElIuJED5nQ1ZGmT2Yz5e13PA3p/Gd9tSEGdq8adGQhdSAkspjkmcO
         +6uXITMgyev5LsZB9AAl3JieGQRAhhNzZ0G+bYj+S2TI9nGrb0yvnbdmkcDDVSXKVg2R
         wCwDWplF7Eqo9SkYMhCGDFPNjIR1mabHFFA0anGx3JNLjEy80ZCZ+vw2ph4uWxVnCORM
         qyuD0Q8oVawaQHLVX07LPRJdgwhGwPeNZhZCiZLwQUs0+1915emSOIrag2I5Tt/ng/Yd
         te5T3tpxHrZ+mOVxSGfppqskxu98TZd8HNkzuitLisPSDUfgbOj5N2Ke/iMMDcxdoaXE
         sPtA==
X-Gm-Message-State: AOAM533H8TezUwWG4feCKet84E3rES0yEVvkk8pzBRIf5cb+LUwHcgSA
        opUb98w0saCCYUFPZWgPBXt78g==
X-Google-Smtp-Source: ABdhPJzonrcK+TRLtg6V6Hw1Cuq1ymKGIgjegQsieAocQ6k0Tl+1tM6tQIh9TN3pB+I2vzl29IbsTQ==
X-Received: by 2002:a1c:3d86:: with SMTP id k128mr401927wma.66.1610055370266;
        Thu, 07 Jan 2021 13:36:10 -0800 (PST)
Received: from desktop.wvd.kresin.me (p200300ec2f1543005c3547d24e99751a.dip0.t-ipconnect.de. [2003:ec:2f15:4300:5c35:47d2:4e99:751a])
        by smtp.gmail.com with ESMTPSA id 138sm10291098wma.41.2021.01.07.13.36.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 13:36:09 -0800 (PST)
From:   Mathias Kresin <dev@kresin.me>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Serge Semin <fancer.lancer@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>, stable@vger.kernel.org
Subject: [PATCH] irqchip: mips-cpu: set IPI domain parent chip
Date:   Thu,  7 Jan 2021 22:36:03 +0100
Message-Id: <20210107213603.1637781-1-dev@kresin.me>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since commit 55567976629e ("genirq/irqdomain: Allow partial trimming of
irq_data hierarchy") the irq_data chain is valided.

The irq_domain_trim_hierarchy() function doesn't consider the irq + ipi
domain hierarchy as valid, since the ipi domain has the irq domain set
as parent, but the parent domain has no chip set. Hence the boot ends in
a kernel panic.

Set the chip for the parent domain as it is done in the mips gic irq
driver, to have a valid irq_data chain.

Fixes: 3838a547fda2 ("irqchip: mips-cpu: Introduce IPI IRQ domain support")
Cc: <stable@vger.kernel.org> # v5.10+
Signed-off-by: Mathias Kresin <dev@kresin.me>
---
 drivers/irqchip/irq-mips-cpu.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/irqchip/irq-mips-cpu.c b/drivers/irqchip/irq-mips-cpu.c
index 95d4fd8f7a96..0bbb0b2d0dd5 100644
--- a/drivers/irqchip/irq-mips-cpu.c
+++ b/drivers/irqchip/irq-mips-cpu.c
@@ -197,6 +197,13 @@ static int mips_cpu_ipi_alloc(struct irq_domain *domain, unsigned int virq,
 		if (ret)
 			return ret;
 
+		ret = irq_domain_set_hwirq_and_chip(domain->parent, virq + i, hwirq,
+						    &mips_mt_cpu_irq_controller,
+						    NULL);
+
+		if (ret)
+			return ret;
+
 		ret = irq_set_irq_type(virq + i, IRQ_TYPE_LEVEL_HIGH);
 		if (ret)
 			return ret;
-- 
2.25.1

