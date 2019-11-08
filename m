Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8008FF4BD1
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:37:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725995AbfKHMgu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 07:36:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:44378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726036AbfKHMgu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 07:36:50 -0500
Received: from localhost.localdomain (lfbn-mar-1-550-151.w90-118.abo.wanadoo.fr [90.118.131.151])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D1EC224D3;
        Fri,  8 Nov 2019 12:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573216609;
        bh=ubBAeQa9bb+Uz+ocCIWNyCnkD2m3VFK5kWYzCMVncS0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ufRYIMX9WfwQbsJPwPFfJhMMh8TZYAMP3AfkSsqvlb8FyTK37TILUxVpLOklfp2GC
         vw3s9ZNgozfdmHGnyZ7Y+qGw8xlGT1DDzS3w9IwxXFSrl5LhXcmZ7x0+phHB5V6Wkt
         tQ+uG6rAgC7msacZxV4/l9eho9mAS18zPjLt/Y9c=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     stable@vger.kernel.org
Cc:     linus.walleij@linaro.org, rmk+kernel@armlinux.org.uk,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH for-stable-4.4 23/50] ARM: spectre-v2: add Cortex A8 and A15 validation of the IBE bit
Date:   Fri,  8 Nov 2019 13:35:27 +0100
Message-Id: <20191108123554.29004-24-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108123554.29004-1-ardb@kernel.org>
References: <20191108123554.29004-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

Commit e388b80288aade31135aca23d32eee93dd106795 upstream.

When the branch predictor hardening is enabled, firmware must have set
the IBE bit in the auxiliary control register.  If this bit has not
been set, the Spectre workarounds will not be functional.

Add validation that this bit is set, and print a warning at alert level
if this is not the case.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Boot-tested-by: Tony Lindgren <tony@atomide.com>
Reviewed-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: David A. Long <dave.long@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm/mm/Makefile       |  2 +-
 arch/arm/mm/proc-v7-bugs.c | 36 ++++++++++++++++++++
 arch/arm/mm/proc-v7.S      |  4 +--
 3 files changed, 39 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mm/Makefile b/arch/arm/mm/Makefile
index 7f76d96ce546..35307176e46c 100644
--- a/arch/arm/mm/Makefile
+++ b/arch/arm/mm/Makefile
@@ -92,7 +92,7 @@ obj-$(CONFIG_CPU_MOHAWK)	+= proc-mohawk.o
 obj-$(CONFIG_CPU_FEROCEON)	+= proc-feroceon.o
 obj-$(CONFIG_CPU_V6)		+= proc-v6.o
 obj-$(CONFIG_CPU_V6K)		+= proc-v6.o
-obj-$(CONFIG_CPU_V7)		+= proc-v7.o
+obj-$(CONFIG_CPU_V7)		+= proc-v7.o proc-v7-bugs.o
 obj-$(CONFIG_CPU_V7M)		+= proc-v7m.o
 
 AFLAGS_proc-v6.o	:=-Wa,-march=armv6
diff --git a/arch/arm/mm/proc-v7-bugs.c b/arch/arm/mm/proc-v7-bugs.c
new file mode 100644
index 000000000000..e46557db6446
--- /dev/null
+++ b/arch/arm/mm/proc-v7-bugs.c
@@ -0,0 +1,36 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/kernel.h>
+#include <linux/smp.h>
+
+static __maybe_unused void cpu_v7_check_auxcr_set(bool *warned,
+						  u32 mask, const char *msg)
+{
+	u32 aux_cr;
+
+	asm("mrc p15, 0, %0, c1, c0, 1" : "=r" (aux_cr));
+
+	if ((aux_cr & mask) != mask) {
+		if (!*warned)
+			pr_err("CPU%u: %s", smp_processor_id(), msg);
+		*warned = true;
+	}
+}
+
+static DEFINE_PER_CPU(bool, spectre_warned);
+
+static void check_spectre_auxcr(bool *warned, u32 bit)
+{
+	if (IS_ENABLED(CONFIG_HARDEN_BRANCH_PREDICTOR) &&
+		cpu_v7_check_auxcr_set(warned, bit,
+				       "Spectre v2: firmware did not set auxiliary control register IBE bit, system vulnerable\n");
+}
+
+void cpu_v7_ca8_ibe(void)
+{
+	check_spectre_auxcr(this_cpu_ptr(&spectre_warned), BIT(6));
+}
+
+void cpu_v7_ca15_ibe(void)
+{
+	check_spectre_auxcr(this_cpu_ptr(&spectre_warned), BIT(0));
+}
diff --git a/arch/arm/mm/proc-v7.S b/arch/arm/mm/proc-v7.S
index c2950317c7c2..1436ad424f2a 100644
--- a/arch/arm/mm/proc-v7.S
+++ b/arch/arm/mm/proc-v7.S
@@ -511,7 +511,7 @@ __v7_setup_stack:
 	globl_equ	cpu_ca8_do_suspend,	cpu_v7_do_suspend
 	globl_equ	cpu_ca8_do_resume,	cpu_v7_do_resume
 #endif
-	define_processor_functions ca8, dabort=v7_early_abort, pabort=v7_pabort, suspend=1
+	define_processor_functions ca8, dabort=v7_early_abort, pabort=v7_pabort, suspend=1, bugs=cpu_v7_ca8_ibe
 
 	@ Cortex-A9 - needs more registers preserved across suspend/resume
 	@ and bpiall switch_mm for hardening
@@ -544,7 +544,7 @@ __v7_setup_stack:
 	globl_equ	cpu_ca15_suspend_size,	cpu_v7_suspend_size
 	globl_equ	cpu_ca15_do_suspend,	cpu_v7_do_suspend
 	globl_equ	cpu_ca15_do_resume,	cpu_v7_do_resume
-	define_processor_functions ca15, dabort=v7_early_abort, pabort=v7_pabort, suspend=1
+	define_processor_functions ca15, dabort=v7_early_abort, pabort=v7_pabort, suspend=1, bugs=cpu_v7_ca15_ibe
 #ifdef CONFIG_CPU_PJ4B
 	define_processor_functions pj4b, dabort=v7_early_abort, pabort=v7_pabort, suspend=1
 #endif
-- 
2.20.1

