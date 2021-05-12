Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB1D837EEAE
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 01:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235435AbhELWE6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 18:04:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390369AbhELVGd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 17:06:33 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0CD5C061574;
        Wed, 12 May 2021 14:05:23 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id b7so31367310ljr.4;
        Wed, 12 May 2021 14:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pkOa5LLtAUcCqmRrACIIvJQpohQ3v/pu1wF935eJD/4=;
        b=Agl6Yn+BPQv9iwAE0JwFkTlRg597a8FxyQWWjbQ8jGK+wrVMesU3n4y8Gky11vbxL7
         nQ6ImKHv0YzkS459Lwbz/DnD77LsisXMGq1ExAV9NzBTAVCYk1paR8RU2gwYHHafRvgM
         fNwyGptW9hKCJERFtLKQWxeAcM4rmu9zinYCLM1DGMp4XVpHT3Ar2fogr0efKqyAfPmw
         NmKf+AEaOvwXzpi/RsGw8SoP6t9zjaLSjuROlbBvHl1nkihE1O11XjWmyuwydyS4fAO3
         R6FZNg1T4UmvIuCWpwFnNiwCOtnqaMjB5PimrFKp2BPptgvcQW4C+8H2ebd3M5ZeszxP
         2QXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pkOa5LLtAUcCqmRrACIIvJQpohQ3v/pu1wF935eJD/4=;
        b=BjbkzfP24Rh0aESDmrohRZiIfASci1f5HVBal1fmwLzfiKA/FGJhq+rtGx59r1QzDP
         uywtf/xT6heFupTMFHgDtr3CkaIyRk31ES0B7IFa4rCvaew+CEp7aLU+dLkCe2eMvmPG
         f64YJ7cpiRUj+037ShVYkgBDv6rfJw1gZ4cIuokGOyWnZEZRMzr/XUv1qyovMZGl4V9o
         ThoGPNlENHHsT1rbl/6hNdLGIMZyJP4z+t++R5Phbgxopz+j5sSGZe42TAudmXg9+9Tw
         htCGhmw0zIONa7GMs/tQ8b82STElpsOFh2m7OYegb4PYEvpJdad/FYpwgJazTIHd7JUn
         mF7g==
X-Gm-Message-State: AOAM530G0NHTCUEeXlccgZDQtJ1lyjckgGM7+2DO9MHsLMn0zW79cD9X
        7K86sooJLGSPHL0F+yMSrsZHPpOuIrs=
X-Google-Smtp-Source: ABdhPJyj1E84ldx8eit6zvz1H2giJeKydg+aa1SZVozM61rKK2oEXdL4ko3dnMiHJGwMkWEb+13vlg==
X-Received: by 2002:a2e:8e99:: with SMTP id z25mr31411823ljk.146.1620853522346;
        Wed, 12 May 2021 14:05:22 -0700 (PDT)
Received: from xws.localdomain ([37.58.58.229])
        by smtp.gmail.com with ESMTPSA id u12sm140958ljo.82.2021.05.12.14.05.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 14:05:21 -0700 (PDT)
From:   Maximilian Luz <luzmaximilian@gmail.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>
Cc:     Maximilian Luz <luzmaximilian@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Sachi King <nakato@nakato.io>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] x86/i8259: Work around buggy legacy PIC
Date:   Wed, 12 May 2021 23:04:59 +0200
Message-Id: <20210512210459.1983026-1-luzmaximilian@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The legacy PIC on the AMD variant of the Microsoft Surface Laptop 4 has
some problems on boot. For some reason it consistently does not respond
on the first try, requiring a couple more tries before it finally
responds.

This currently leads to the PIC not being properly recognized, which
prevents interrupt handling down the line. Ultimately, this also leads
to the pinctrl-amd driver failing to probe due to platform_get_irq()
returning -EINVAL for its base IRQ. That, in turn, means that several
interrupts are not available and device drivers relying on those will
defer probing indefinitely, as querying those interrupts returns
-EPROBE_DEFER.

Add a quirk table and a retry-loop to work around that.

Also switch to pr_info() due to complaints by checkpatch and add a
pr_fmt() definition for completeness.

Cc: <stable@vger.kernel.org> # 5.10+
Co-developed-by: Sachi King <nakato@nakato.io>
Signed-off-by: Sachi King <nakato@nakato.io>
Signed-off-by: Maximilian Luz <luzmaximilian@gmail.com>
---
 arch/x86/kernel/i8259.c | 51 +++++++++++++++++++++++++++++++++++++----
 1 file changed, 46 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/i8259.c b/arch/x86/kernel/i8259.c
index 282b4ee1339f..0da757c6b292 100644
--- a/arch/x86/kernel/i8259.c
+++ b/arch/x86/kernel/i8259.c
@@ -1,4 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
+
+#define pr_fmt(fmt) "i8259: " fmt
+
 #include <linux/linkage.h>
 #include <linux/errno.h>
 #include <linux/signal.h>
@@ -16,6 +19,7 @@
 #include <linux/io.h>
 #include <linux/delay.h>
 #include <linux/pgtable.h>
+#include <linux/dmi.h>
 
 #include <linux/atomic.h>
 #include <asm/timer.h>
@@ -298,11 +302,39 @@ static void unmask_8259A(void)
 	raw_spin_unlock_irqrestore(&i8259A_lock, flags);
 }
 
+/*
+ * DMI table to identify devices with quirky probe behavior. See comment in
+ * probe_8259A() for more details.
+ */
+static const struct dmi_system_id retry_probe_quirk_table[] = {
+	{
+		.ident = "Microsoft Surface Laptop 4 (AMD)",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
+			DMI_MATCH(DMI_PRODUCT_SKU, "Surface_Laptop_4_1952:1953")
+		},
+	},
+	{}
+};
+
 static int probe_8259A(void)
 {
 	unsigned long flags;
 	unsigned char probe_val = ~(1 << PIC_CASCADE_IR);
 	unsigned char new_val;
+	unsigned int i, imax = 1;
+
+	/*
+	 * Some systems have a legacy PIC that doesn't immediately respond
+	 * after boot. We know it's there, we know it should respond and is
+	 * required for proper interrupt handling later on, so let's try a
+	 * couple of times.
+	 */
+	if (dmi_check_system(retry_probe_quirk_table)) {
+		pr_warn("system with broken legacy PIC detected, re-trying multiple times if necessary\n");
+		imax = 10;
+	}
+
 	/*
 	 * Check to see if we have a PIC.
 	 * Mask all except the cascade and read
@@ -312,15 +344,24 @@ static int probe_8259A(void)
 	 */
 	raw_spin_lock_irqsave(&i8259A_lock, flags);
 
-	outb(0xff, PIC_SLAVE_IMR);	/* mask all of 8259A-2 */
-	outb(probe_val, PIC_MASTER_IMR);
-	new_val = inb(PIC_MASTER_IMR);
-	if (new_val != probe_val) {
-		printk(KERN_INFO "Using NULL legacy PIC\n");
+	for (i = 0; i < imax; i++) {
+		outb(0xff, PIC_SLAVE_IMR);	/* mask all of 8259A-2 */
+		outb(probe_val, PIC_MASTER_IMR);
+		new_val = inb(PIC_MASTER_IMR);
+		if (new_val == probe_val)
+			break;
+	}
+
+	if (i == imax) {
+		pr_info("using NULL legacy PIC\n");
 		legacy_pic = &null_legacy_pic;
 	}
 
 	raw_spin_unlock_irqrestore(&i8259A_lock, flags);
+
+	if (imax > 1 && i < imax)
+		pr_info("got legacy PIC after %d tries\n", i + 1);
+
 	return nr_legacy_irqs();
 }
 
-- 
2.31.1

