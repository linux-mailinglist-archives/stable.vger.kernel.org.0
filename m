Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C75FF5419
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 19:55:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732826AbfKHSyN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 13:54:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:50860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732757AbfKHSyM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 13:54:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3124F20865;
        Fri,  8 Nov 2019 18:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239237;
        bh=3noFGW8Pm/o5hVE6Hpp9E/Fq3VyYfeQjanBRA8WH0H8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2N72eW0wDdhgPvCRLDAaWiimss/iY3MCpxGZSKI8jM2WYyKNW9FBLz6rHHLMgSxgr
         /ejYyKQXA0oha8UiIzhSHi46HFsTnbpSZIT+KgT1kfHJdoeWUeOkPEkzasEH7sosjg
         pYKjt0eN2ZV7dGRc/0WRtRljlWKH0wyN1cSg36bQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linus.walleij@linaro.org, rmk+kernel@armlinux.org.uk, Ard Biesheuvel" 
        <ardb@kernel.org>, Russell King <rmk+kernel@armlinux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        "David A. Long" <dave.long@linaro.org>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 4.4 47/75] ARM: spectre-v2: harden user aborts in kernel space
Date:   Fri,  8 Nov 2019 19:50:04 +0100
Message-Id: <20191108174752.269412572@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174708.135680837@linuxfoundation.org>
References: <20191108174708.135680837@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

Commit f5fe12b1eaee220ce62ff9afb8b90929c396595f upstream.

In order to prevent aliasing attacks on the branch predictor,
invalidate the BTB or instruction cache on CPUs that are known to be
affected when taking an abort on a address that is outside of a user
task limit:

Cortex A8, A9, A12, A17, A73, A75: flush BTB.
Cortex A15, Brahma B15: invalidate icache.

If the IBE bit is not set, then there is little point to enabling the
workaround.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Boot-tested-by: Tony Lindgren <tony@atomide.com>
Reviewed-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: David A. Long <dave.long@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/include/asm/cp15.h        |    3 +
 arch/arm/include/asm/system_misc.h |   15 +++++++
 arch/arm/mm/fault.c                |    3 +
 arch/arm/mm/proc-v7-bugs.c         |   73 ++++++++++++++++++++++++++++++++++---
 arch/arm/mm/proc-v7.S              |    8 ++--
 5 files changed, 94 insertions(+), 8 deletions(-)

--- a/arch/arm/include/asm/cp15.h
+++ b/arch/arm/include/asm/cp15.h
@@ -64,6 +64,9 @@
 #define __write_sysreg(v, r, w, c, t)	asm volatile(w " " c : : "r" ((t)(v)))
 #define write_sysreg(v, ...)		__write_sysreg(v, __VA_ARGS__)
 
+#define BPIALL				__ACCESS_CP15(c7, 0, c5, 6)
+#define ICIALLU				__ACCESS_CP15(c7, 0, c5, 0)
+
 extern unsigned long cr_alignment;	/* defined in entry-armv.S */
 
 static inline unsigned long get_cr(void)
--- a/arch/arm/include/asm/system_misc.h
+++ b/arch/arm/include/asm/system_misc.h
@@ -7,6 +7,7 @@
 #include <linux/linkage.h>
 #include <linux/irqflags.h>
 #include <linux/reboot.h>
+#include <linux/percpu.h>
 
 extern void cpu_init(void);
 
@@ -14,6 +15,20 @@ void soft_restart(unsigned long);
 extern void (*arm_pm_restart)(enum reboot_mode reboot_mode, const char *cmd);
 extern void (*arm_pm_idle)(void);
 
+#ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
+typedef void (*harden_branch_predictor_fn_t)(void);
+DECLARE_PER_CPU(harden_branch_predictor_fn_t, harden_branch_predictor_fn);
+static inline void harden_branch_predictor(void)
+{
+	harden_branch_predictor_fn_t fn = per_cpu(harden_branch_predictor_fn,
+						  smp_processor_id());
+	if (fn)
+		fn();
+}
+#else
+#define harden_branch_predictor() do { } while (0)
+#endif
+
 #define UDBG_UNDEFINED	(1 << 0)
 #define UDBG_SYSCALL	(1 << 1)
 #define UDBG_BADABORT	(1 << 2)
--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -163,6 +163,9 @@ __do_user_fault(struct task_struct *tsk,
 {
 	struct siginfo si;
 
+	if (addr > TASK_SIZE)
+		harden_branch_predictor();
+
 #ifdef CONFIG_DEBUG_USER
 	if (((user_debug & UDBG_SEGV) && (sig == SIGSEGV)) ||
 	    ((user_debug & UDBG_BUS)  && (sig == SIGBUS))) {
--- a/arch/arm/mm/proc-v7-bugs.c
+++ b/arch/arm/mm/proc-v7-bugs.c
@@ -2,7 +2,61 @@
 #include <linux/kernel.h>
 #include <linux/smp.h>
 
-static __maybe_unused void cpu_v7_check_auxcr_set(bool *warned,
+#include <asm/cp15.h>
+#include <asm/cputype.h>
+#include <asm/system_misc.h>
+
+#ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
+DEFINE_PER_CPU(harden_branch_predictor_fn_t, harden_branch_predictor_fn);
+
+static void harden_branch_predictor_bpiall(void)
+{
+	write_sysreg(0, BPIALL);
+}
+
+static void harden_branch_predictor_iciallu(void)
+{
+	write_sysreg(0, ICIALLU);
+}
+
+static void cpu_v7_spectre_init(void)
+{
+	const char *spectre_v2_method = NULL;
+	int cpu = smp_processor_id();
+
+	if (per_cpu(harden_branch_predictor_fn, cpu))
+		return;
+
+	switch (read_cpuid_part()) {
+	case ARM_CPU_PART_CORTEX_A8:
+	case ARM_CPU_PART_CORTEX_A9:
+	case ARM_CPU_PART_CORTEX_A12:
+	case ARM_CPU_PART_CORTEX_A17:
+	case ARM_CPU_PART_CORTEX_A73:
+	case ARM_CPU_PART_CORTEX_A75:
+		per_cpu(harden_branch_predictor_fn, cpu) =
+			harden_branch_predictor_bpiall;
+		spectre_v2_method = "BPIALL";
+		break;
+
+	case ARM_CPU_PART_CORTEX_A15:
+	case ARM_CPU_PART_BRAHMA_B15:
+		per_cpu(harden_branch_predictor_fn, cpu) =
+			harden_branch_predictor_iciallu;
+		spectre_v2_method = "ICIALLU";
+		break;
+	}
+	if (spectre_v2_method)
+		pr_info("CPU%u: Spectre v2: using %s workaround\n",
+			smp_processor_id(), spectre_v2_method);
+}
+#else
+static void cpu_v7_spectre_init(void)
+{
+}
+#endif
+
+static __maybe_unused bool cpu_v7_check_auxcr_set(bool *warned,
 						  u32 mask, const char *msg)
 {
 	u32 aux_cr;
@@ -13,24 +67,33 @@ static __maybe_unused void cpu_v7_check_
 		if (!*warned)
 			pr_err("CPU%u: %s", smp_processor_id(), msg);
 		*warned = true;
+		return false;
 	}
+	return true;
 }
 
 static DEFINE_PER_CPU(bool, spectre_warned);
 
-static void check_spectre_auxcr(bool *warned, u32 bit)
+static bool check_spectre_auxcr(bool *warned, u32 bit)
 {
-	if (IS_ENABLED(CONFIG_HARDEN_BRANCH_PREDICTOR) &&
+	return IS_ENABLED(CONFIG_HARDEN_BRANCH_PREDICTOR) &&
 		cpu_v7_check_auxcr_set(warned, bit,
 				       "Spectre v2: firmware did not set auxiliary control register IBE bit, system vulnerable\n");
 }
 
 void cpu_v7_ca8_ibe(void)
 {
-	check_spectre_auxcr(this_cpu_ptr(&spectre_warned), BIT(6));
+	if (check_spectre_auxcr(this_cpu_ptr(&spectre_warned), BIT(6)))
+		cpu_v7_spectre_init();
 }
 
 void cpu_v7_ca15_ibe(void)
 {
-	check_spectre_auxcr(this_cpu_ptr(&spectre_warned), BIT(0));
+	if (check_spectre_auxcr(this_cpu_ptr(&spectre_warned), BIT(0)))
+		cpu_v7_spectre_init();
+}
+
+void cpu_v7_bugs_init(void)
+{
+	cpu_v7_spectre_init();
 }
--- a/arch/arm/mm/proc-v7.S
+++ b/arch/arm/mm/proc-v7.S
@@ -474,8 +474,10 @@ __v7_setup_stack:
 
 	__INITDATA
 
+	.weak cpu_v7_bugs_init
+
 	@ define struct processor (see <asm/proc-fns.h> and proc-macros.S)
-	define_processor_functions v7, dabort=v7_early_abort, pabort=v7_pabort, suspend=1
+	define_processor_functions v7, dabort=v7_early_abort, pabort=v7_pabort, suspend=1, bugs=cpu_v7_bugs_init
 
 #ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
 	@ generic v7 bpiall on context switch
@@ -490,7 +492,7 @@ __v7_setup_stack:
 	globl_equ	cpu_v7_bpiall_do_suspend,	cpu_v7_do_suspend
 	globl_equ	cpu_v7_bpiall_do_resume,	cpu_v7_do_resume
 #endif
-	define_processor_functions v7_bpiall, dabort=v7_early_abort, pabort=v7_pabort, suspend=1
+	define_processor_functions v7_bpiall, dabort=v7_early_abort, pabort=v7_pabort, suspend=1, bugs=cpu_v7_bugs_init
 
 #define HARDENED_BPIALL_PROCESSOR_FUNCTIONS v7_bpiall_processor_functions
 #else
@@ -526,7 +528,7 @@ __v7_setup_stack:
 	globl_equ	cpu_ca9mp_switch_mm,	cpu_v7_switch_mm
 #endif
 	globl_equ	cpu_ca9mp_set_pte_ext,	cpu_v7_set_pte_ext
-	define_processor_functions ca9mp, dabort=v7_early_abort, pabort=v7_pabort, suspend=1
+	define_processor_functions ca9mp, dabort=v7_early_abort, pabort=v7_pabort, suspend=1, bugs=cpu_v7_bugs_init
 #endif
 
 	@ Cortex-A15 - needs iciallu switch_mm for hardening


