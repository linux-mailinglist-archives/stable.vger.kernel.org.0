Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF327D732
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 10:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731060AbfHAIUT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 04:20:19 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:36561 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731078AbfHAIUT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Aug 2019 04:20:19 -0400
Received: by mail-pf1-f196.google.com with SMTP id r7so33605755pfl.3
        for <stable@vger.kernel.org>; Thu, 01 Aug 2019 01:20:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GWBuoPEcurWKDak0e2m8FiUiWeWYmr8zikb3n4XMh3U=;
        b=q7HiAZVZ6w5XCi6JSITNXUus7qf13R3ZdtvYRfcXZcnyLiUbMa19jlxI+YQsssbQnp
         dTSvKRuCi+Tj09bq1F9qTFCXl81fsijJJ7N1pq02NN5s/rQIhPKVtXdlhGGEuuQgDv2z
         rMwg9oNemkqd5GDkC3rGmX8Z09VgYs4QjyHL13/AUnpgmcuhOCC0kMCl9TT/wQ3Vl8Pw
         lZc6ThzJ/QKqYZ0P5viIspI3Z1XT1SuUy9ZrBAk5OgSL5u8lqem2enkByuCLX+aRf5nj
         sj1rXj/CTfB9ex5rzvzWOFBuaYHdRi7IhozL3jsKrYve0lC8PeNBaQ7UbfuUUltJ+okf
         qk6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GWBuoPEcurWKDak0e2m8FiUiWeWYmr8zikb3n4XMh3U=;
        b=o6w+10RfFo0OTkSLc5RyO2j1F5MTcuVB5um/YboxXROGJirE3sPNIrBOT5xMtZ0VQt
         3r323BZUDDT5YwSD15tWk+fqVvt9Y/KFuGak4miNexMj8ZSO6rPnNlb42HVpKYVRlLmj
         qgs22UAxSbctuXOEtYGFlSNpzm9z8J+ynXBpyWrsWVt1yhxHwk/jRowKN6QWPB5QxC7m
         j+5YU98azZlv6CxMmwE16qOIgSFwPv3PRYabEao9D0mxRdHbXUeFF6XU6ydbGn1ZUz4R
         2QjgX0+FRbzvSOFclNX1WCZVfEw+6ybn3UcSa7opepA9dBbMvBGFAkoDtqxR5AzPc1Yx
         3fRA==
X-Gm-Message-State: APjAAAWUdet65QEdX5JDnhlOQHbh7KJjIhk1jStB41IR5+AcB5wNY35K
        Xenkr8BA+UhatUO0YVUABKMWmYE1XEw=
X-Google-Smtp-Source: APXvYqzUs6xXAR8vli7Y6u/duOBSv+NXtmY1ZNerLWGK1KQ3lzsmuL+hJxb/eg8xSZb4AkZnl877/w==
X-Received: by 2002:a62:1ac8:: with SMTP id a191mr51954060pfa.164.1564647617513;
        Thu, 01 Aug 2019 01:20:17 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id i7sm3393542pjk.24.2019.08.01.01.20.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 01:20:17 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     stable@vger.kernel.org
Cc:     Viresh Kumar <viresh.kumar@linaro.org>,
        Julien Thierry <Julien.Thierry@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com, guohanjun@huawei.com
Subject: [PATCH ARM32 v4.4 V2 16/47] ARM: spectre-v2: harden user aborts in kernel space
Date:   Thu,  1 Aug 2019 13:46:00 +0530
Message-Id: <2c11c43187dae2179ccb3bb4cf9e1b8040a01bc5.1564646727.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1564646727.git.viresh.kumar@linaro.org>
References: <cover.1564646727.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

Commit f5fe12b1eaee220ce62ff9afb8b90929c396595f upstream.

This required some additional defines be brought back.

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
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David A. Long <dave.long@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm/include/asm/cp15.h        | 18 ++++++++
 arch/arm/include/asm/system_misc.h | 15 ++++++
 arch/arm/mm/fault.c                |  3 ++
 arch/arm/mm/proc-v7-bugs.c         | 73 ++++++++++++++++++++++++++++--
 arch/arm/mm/proc-v7.S              |  8 ++--
 5 files changed, 109 insertions(+), 8 deletions(-)

diff --git a/arch/arm/include/asm/cp15.h b/arch/arm/include/asm/cp15.h
index c3f11524f10c..b74b174ac9fc 100644
--- a/arch/arm/include/asm/cp15.h
+++ b/arch/arm/include/asm/cp15.h
@@ -49,6 +49,24 @@
 
 #ifdef CONFIG_CPU_CP15
 
+#define __ACCESS_CP15(CRn, Op1, CRm, Op2)	\
+	"mrc", "mcr", __stringify(p15, Op1, %0, CRn, CRm, Op2), u32
+#define __ACCESS_CP15_64(Op1, CRm)		\
+	"mrrc", "mcrr", __stringify(p15, Op1, %Q0, %R0, CRm), u64
+
+#define __read_sysreg(r, w, c, t) ({				\
+	t __val;						\
+	asm volatile(r " " c : "=r" (__val));			\
+	__val;							\
+})
+#define read_sysreg(...)		__read_sysreg(__VA_ARGS__)
+
+#define __write_sysreg(v, r, w, c, t)	asm volatile(w " " c : : "r" ((t)(v)))
+#define write_sysreg(v, ...)		__write_sysreg(v, __VA_ARGS__)
+
+#define BPIALL				__ACCESS_CP15(c7, 0, c5, 6)
+#define ICIALLU				__ACCESS_CP15(c7, 0, c5, 0)
+
 extern unsigned long cr_alignment;	/* defined in entry-armv.S */
 
 static inline unsigned long get_cr(void)
diff --git a/arch/arm/include/asm/system_misc.h b/arch/arm/include/asm/system_misc.h
index a3d61ad984af..1fed41440af9 100644
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
diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
index 0d20cd594017..afc8d7cf7625 100644
--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -163,6 +163,9 @@ __do_user_fault(struct task_struct *tsk, unsigned long addr,
 {
 	struct siginfo si;
 
+	if (addr > TASK_SIZE)
+		harden_branch_predictor();
+
 #ifdef CONFIG_DEBUG_USER
 	if (((user_debug & UDBG_SEGV) && (sig == SIGSEGV)) ||
 	    ((user_debug & UDBG_BUS)  && (sig == SIGBUS))) {
diff --git a/arch/arm/mm/proc-v7-bugs.c b/arch/arm/mm/proc-v7-bugs.c
index e46557db6446..85a2e3d6263c 100644
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
@@ -13,24 +67,33 @@ static __maybe_unused void cpu_v7_check_auxcr_set(bool *warned,
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
diff --git a/arch/arm/mm/proc-v7.S b/arch/arm/mm/proc-v7.S
index 1436ad424f2a..f6a4589b4fd2 100644
--- a/arch/arm/mm/proc-v7.S
+++ b/arch/arm/mm/proc-v7.S
@@ -474,8 +474,10 @@ ENDPROC(__v7_setup)
 
 	__INITDATA
 
+	.weak cpu_v7_bugs_init
+
 	@ define struct processor (see <asm/proc-fns.h> and proc-macros.S)
-	define_processor_functions v7, dabort=v7_early_abort, pabort=v7_pabort, suspend=1
+	define_processor_functions v7, dabort=v7_early_abort, pabort=v7_pabort, suspend=1, bugs=cpu_v7_bugs_init
 
 #ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
 	@ generic v7 bpiall on context switch
@@ -490,7 +492,7 @@ ENDPROC(__v7_setup)
 	globl_equ	cpu_v7_bpiall_do_suspend,	cpu_v7_do_suspend
 	globl_equ	cpu_v7_bpiall_do_resume,	cpu_v7_do_resume
 #endif
-	define_processor_functions v7_bpiall, dabort=v7_early_abort, pabort=v7_pabort, suspend=1
+	define_processor_functions v7_bpiall, dabort=v7_early_abort, pabort=v7_pabort, suspend=1, bugs=cpu_v7_bugs_init
 
 #define HARDENED_BPIALL_PROCESSOR_FUNCTIONS v7_bpiall_processor_functions
 #else
@@ -526,7 +528,7 @@ ENDPROC(__v7_setup)
 	globl_equ	cpu_ca9mp_switch_mm,	cpu_v7_switch_mm
 #endif
 	globl_equ	cpu_ca9mp_set_pte_ext,	cpu_v7_set_pte_ext
-	define_processor_functions ca9mp, dabort=v7_early_abort, pabort=v7_pabort, suspend=1
+	define_processor_functions ca9mp, dabort=v7_early_abort, pabort=v7_pabort, suspend=1, bugs=cpu_v7_bugs_init
 #endif
 
 	@ Cortex-A15 - needs iciallu switch_mm for hardening
-- 
2.21.0.rc0.269.g1a574e7a288b

