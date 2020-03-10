Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 655AD17FA60
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:05:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730580AbgCJNDZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:03:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:48104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729134AbgCJNDZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:03:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03CEC20409;
        Tue, 10 Mar 2020 13:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845404;
        bh=b2skDpvrPgPj6Xui4z2yZFFBz2z91dVTcftzBEEU42o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w73M4vL0nvxZR5MXufwsJ7qeXZMBdyeYKQJkE0LQBhjnNoBtOW93Z4eK7GimPfhBV
         ZSk816u/RWaHiWryhGitp1jlONthHNhckbq7ChL56DPc04SlX8+ZNInCP/2tfzoWA7
         OYW0lePQ6cgmsaO299wh9XliuLh4yhOrKb3ErgJk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucas Stach <l.stach@pengutronix.de>,
        Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Rouven Czerwinski <r.czerwinski@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 5.5 171/189] ARM: imx: build v7_cpu_resume() unconditionally
Date:   Tue, 10 Mar 2020 13:40:08 +0100
Message-Id: <20200310123657.154373551@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123639.608886314@linuxfoundation.org>
References: <20200310123639.608886314@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ahmad Fatoum <a.fatoum@pengutronix.de>

commit 512a928affd51c2dc631401e56ad5ee5d5dd68b6 upstream.

This function is not only needed by the platform suspend code, but is also
reused as the CPU resume function when the ARM cores can be powered down
completely in deep idle, which is the case on i.MX6SX and i.MX6UL(L).

Providing the static inline stub whenever CONFIG_SUSPEND is disabled means
that those platforms will hang on resume from cpuidle if suspend is disabled.

So there are two problems:

  - The static inline stub masks the linker error
  - The function is not available where needed

Fix both by just building the function unconditionally, when
CONFIG_SOC_IMX6 is enabled. The actual code is three instructions long,
so it's arguably ok to just leave it in for all i.MX6 kernel configurations.

Fixes: 05136f0897b5 ("ARM: imx: support arm power off in cpuidle for i.mx6sx")
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Signed-off-by: Rouven Czerwinski <r.czerwinski@pengutronix.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-imx/Makefile       |    2 ++
 arch/arm/mach-imx/common.h       |    4 ++--
 arch/arm/mach-imx/resume-imx6.S  |   24 ++++++++++++++++++++++++
 arch/arm/mach-imx/suspend-imx6.S |   14 --------------
 4 files changed, 28 insertions(+), 16 deletions(-)

--- a/arch/arm/mach-imx/Makefile
+++ b/arch/arm/mach-imx/Makefile
@@ -91,6 +91,8 @@ AFLAGS_suspend-imx6.o :=-Wa,-march=armv7
 obj-$(CONFIG_SOC_IMX6) += suspend-imx6.o
 obj-$(CONFIG_SOC_IMX53) += suspend-imx53.o
 endif
+AFLAGS_resume-imx6.o :=-Wa,-march=armv7-a
+obj-$(CONFIG_SOC_IMX6) += resume-imx6.o
 obj-$(CONFIG_SOC_IMX6) += pm-imx6.o
 
 obj-$(CONFIG_SOC_IMX1) += mach-imx1.o
--- a/arch/arm/mach-imx/common.h
+++ b/arch/arm/mach-imx/common.h
@@ -109,17 +109,17 @@ void imx_cpu_die(unsigned int cpu);
 int imx_cpu_kill(unsigned int cpu);
 
 #ifdef CONFIG_SUSPEND
-void v7_cpu_resume(void);
 void imx53_suspend(void __iomem *ocram_vbase);
 extern const u32 imx53_suspend_sz;
 void imx6_suspend(void __iomem *ocram_vbase);
 #else
-static inline void v7_cpu_resume(void) {}
 static inline void imx53_suspend(void __iomem *ocram_vbase) {}
 static const u32 imx53_suspend_sz;
 static inline void imx6_suspend(void __iomem *ocram_vbase) {}
 #endif
 
+void v7_cpu_resume(void);
+
 void imx6_pm_ccm_init(const char *ccm_compat);
 void imx6q_pm_init(void);
 void imx6dl_pm_init(void);
--- /dev/null
+++ b/arch/arm/mach-imx/resume-imx6.S
@@ -0,0 +1,24 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright 2014 Freescale Semiconductor, Inc.
+ */
+
+#include <linux/linkage.h>
+#include <asm/assembler.h>
+#include <asm/asm-offsets.h>
+#include <asm/hardware/cache-l2x0.h>
+#include "hardware.h"
+
+/*
+ * The following code must assume it is running from physical address
+ * where absolute virtual addresses to the data section have to be
+ * turned into relative ones.
+ */
+
+ENTRY(v7_cpu_resume)
+	bl	v7_invalidate_l1
+#ifdef CONFIG_CACHE_L2X0
+	bl	l2c310_early_resume
+#endif
+	b	cpu_resume
+ENDPROC(v7_cpu_resume)
--- a/arch/arm/mach-imx/suspend-imx6.S
+++ b/arch/arm/mach-imx/suspend-imx6.S
@@ -327,17 +327,3 @@ resume:
 
 	ret	lr
 ENDPROC(imx6_suspend)
-
-/*
- * The following code must assume it is running from physical address
- * where absolute virtual addresses to the data section have to be
- * turned into relative ones.
- */
-
-ENTRY(v7_cpu_resume)
-	bl	v7_invalidate_l1
-#ifdef CONFIG_CACHE_L2X0
-	bl	l2c310_early_resume
-#endif
-	b	cpu_resume
-ENDPROC(v7_cpu_resume)


