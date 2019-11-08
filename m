Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78CACF4BF0
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:38:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727178AbfKHMh3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 07:37:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:45106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726192AbfKHMh3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 07:37:29 -0500
Received: from localhost.localdomain (lfbn-mar-1-550-151.w90-118.abo.wanadoo.fr [90.118.131.151])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 503002245B;
        Fri,  8 Nov 2019 12:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573216648;
        bh=eGxt1g5I5gmPAONVXazyBWrm7rHV8z3TeRE5FaDF4PQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W/o/smjt6rCwd7FxD5AL/nS40oeOPCHSXsAiGP24yh38GBdKQUs4kQCDUhXIpzIQe
         1vk247TBwgQ6I+ly5w63TE7VPlgQ4Q9p1/C//5fybU7Vxw6XuYY1CX7YNkWJMT4rwI
         zPBP8gtDG3/feiT2QDeVtX3SfUWPyQKCQKsIZAAk=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     stable@vger.kernel.org
Cc:     linus.walleij@linaro.org, rmk+kernel@armlinux.org.uk,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH for-stable-4.4 48/50] ARM: spectre-v2: per-CPU vtables to work around big.Little systems
Date:   Fri,  8 Nov 2019 13:35:52 +0100
Message-Id: <20191108123554.29004-49-ardb@kernel.org>
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

Commit 383fb3ee8024d596f488d2dbaf45e572897acbdb upstream.

In big.Little systems, some CPUs require the Spectre workarounds in
paths such as the context switch, but other CPUs do not.  In order
to handle these differences, we need per-CPU vtables.

We are unable to use the kernel's per-CPU variables to support this
as per-CPU is not initialised at times when we need access to the
vtables, so we have to use an array indexed by logical CPU number.

We use an array-of-pointers to avoid having function pointers in
the kernel's read/write .data section.

Note: Added include of linux/slab.h in arch/arm/smp.c.

Reviewed-by: Julien Thierry <julien.thierry@arm.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: David A. Long <dave.long@linaro.org>
Reviewed-by: Julien Thierry <julien.thierry@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm/include/asm/proc-fns.h | 23 ++++++++++++++
 arch/arm/kernel/setup.c         |  5 +++
 arch/arm/kernel/smp.c           | 32 ++++++++++++++++++++
 arch/arm/mm/proc-v7-bugs.c      | 17 ++---------
 4 files changed, 62 insertions(+), 15 deletions(-)

diff --git a/arch/arm/include/asm/proc-fns.h b/arch/arm/include/asm/proc-fns.h
index a1a71b068edc..1bfcc3bcfc6d 100644
--- a/arch/arm/include/asm/proc-fns.h
+++ b/arch/arm/include/asm/proc-fns.h
@@ -104,12 +104,35 @@ extern void cpu_do_resume(void *);
 #else
 
 extern struct processor processor;
+#if defined(CONFIG_BIG_LITTLE) && defined(CONFIG_HARDEN_BRANCH_PREDICTOR)
+#include <linux/smp.h>
+/*
+ * This can't be a per-cpu variable because we need to access it before
+ * per-cpu has been initialised.  We have a couple of functions that are
+ * called in a pre-emptible context, and so can't use smp_processor_id()
+ * there, hence PROC_TABLE().  We insist in init_proc_vtable() that the
+ * function pointers for these are identical across all CPUs.
+ */
+extern struct processor *cpu_vtable[];
+#define PROC_VTABLE(f)			cpu_vtable[smp_processor_id()]->f
+#define PROC_TABLE(f)			cpu_vtable[0]->f
+static inline void init_proc_vtable(const struct processor *p)
+{
+	unsigned int cpu = smp_processor_id();
+	*cpu_vtable[cpu] = *p;
+	WARN_ON_ONCE(cpu_vtable[cpu]->dcache_clean_area !=
+		     cpu_vtable[0]->dcache_clean_area);
+	WARN_ON_ONCE(cpu_vtable[cpu]->set_pte_ext !=
+		     cpu_vtable[0]->set_pte_ext);
+}
+#else
 #define PROC_VTABLE(f)			processor.f
 #define PROC_TABLE(f)			processor.f
 static inline void init_proc_vtable(const struct processor *p)
 {
 	processor = *p;
 }
+#endif
 
 #define cpu_proc_init			PROC_VTABLE(_proc_init)
 #define cpu_check_bugs			PROC_VTABLE(check_bugs)
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 13bda9574e18..e9c3d38d995d 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -113,6 +113,11 @@ EXPORT_SYMBOL(elf_hwcap2);
 
 #ifdef MULTI_CPU
 struct processor processor __read_mostly;
+#if defined(CONFIG_BIG_LITTLE) && defined(CONFIG_HARDEN_BRANCH_PREDICTOR)
+struct processor *cpu_vtable[NR_CPUS] = {
+	[0] = &processor,
+};
+#endif
 #endif
 #ifdef MULTI_TLB
 struct cpu_tlb_fns cpu_tlb __read_mostly;
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index bafbd29c6e64..d2033d09125f 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -27,6 +27,7 @@
 #include <linux/completion.h>
 #include <linux/cpufreq.h>
 #include <linux/irq_work.h>
+#include <linux/slab.h>
 
 #include <linux/atomic.h>
 #include <asm/bugs.h>
@@ -40,6 +41,7 @@
 #include <asm/mmu_context.h>
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
+#include <asm/procinfo.h>
 #include <asm/processor.h>
 #include <asm/sections.h>
 #include <asm/tlbflush.h>
@@ -96,6 +98,30 @@ static unsigned long get_arch_pgd(pgd_t *pgd)
 #endif
 }
 
+#if defined(CONFIG_BIG_LITTLE) && defined(CONFIG_HARDEN_BRANCH_PREDICTOR)
+static int secondary_biglittle_prepare(unsigned int cpu)
+{
+	if (!cpu_vtable[cpu])
+		cpu_vtable[cpu] = kzalloc(sizeof(*cpu_vtable[cpu]), GFP_KERNEL);
+
+	return cpu_vtable[cpu] ? 0 : -ENOMEM;
+}
+
+static void secondary_biglittle_init(void)
+{
+	init_proc_vtable(lookup_processor(read_cpuid_id())->proc);
+}
+#else
+static int secondary_biglittle_prepare(unsigned int cpu)
+{
+	return 0;
+}
+
+static void secondary_biglittle_init(void)
+{
+}
+#endif
+
 int __cpu_up(unsigned int cpu, struct task_struct *idle)
 {
 	int ret;
@@ -103,6 +129,10 @@ int __cpu_up(unsigned int cpu, struct task_struct *idle)
 	if (!smp_ops.smp_boot_secondary)
 		return -ENOSYS;
 
+	ret = secondary_biglittle_prepare(cpu);
+	if (ret)
+		return ret;
+
 	/*
 	 * We need to tell the secondary core where to find
 	 * its stack and the page tables.
@@ -354,6 +384,8 @@ asmlinkage void secondary_start_kernel(void)
 	struct mm_struct *mm = &init_mm;
 	unsigned int cpu;
 
+	secondary_biglittle_init();
+
 	/*
 	 * The identity mapping is uncached (strongly ordered), so
 	 * switch away from it before attempting any exclusive accesses.
diff --git a/arch/arm/mm/proc-v7-bugs.c b/arch/arm/mm/proc-v7-bugs.c
index 5544b82a2e7a..9a07916af8dd 100644
--- a/arch/arm/mm/proc-v7-bugs.c
+++ b/arch/arm/mm/proc-v7-bugs.c
@@ -52,8 +52,6 @@ static void cpu_v7_spectre_init(void)
 	case ARM_CPU_PART_CORTEX_A17:
 	case ARM_CPU_PART_CORTEX_A73:
 	case ARM_CPU_PART_CORTEX_A75:
-		if (processor.switch_mm != cpu_v7_bpiall_switch_mm)
-			goto bl_error;
 		per_cpu(harden_branch_predictor_fn, cpu) =
 			harden_branch_predictor_bpiall;
 		spectre_v2_method = "BPIALL";
@@ -61,8 +59,6 @@ static void cpu_v7_spectre_init(void)
 
 	case ARM_CPU_PART_CORTEX_A15:
 	case ARM_CPU_PART_BRAHMA_B15:
-		if (processor.switch_mm != cpu_v7_iciallu_switch_mm)
-			goto bl_error;
 		per_cpu(harden_branch_predictor_fn, cpu) =
 			harden_branch_predictor_iciallu;
 		spectre_v2_method = "ICIALLU";
@@ -88,11 +84,9 @@ static void cpu_v7_spectre_init(void)
 					  ARM_SMCCC_ARCH_WORKAROUND_1, &res);
 			if ((int)res.a0 != 0)
 				break;
-			if (processor.switch_mm != cpu_v7_hvc_switch_mm && cpu)
-				goto bl_error;
 			per_cpu(harden_branch_predictor_fn, cpu) =
 				call_hvc_arch_workaround_1;
-			processor.switch_mm = cpu_v7_hvc_switch_mm;
+			cpu_do_switch_mm = cpu_v7_hvc_switch_mm;
 			spectre_v2_method = "hypervisor";
 			break;
 
@@ -101,11 +95,9 @@ static void cpu_v7_spectre_init(void)
 					  ARM_SMCCC_ARCH_WORKAROUND_1, &res);
 			if ((int)res.a0 != 0)
 				break;
-			if (processor.switch_mm != cpu_v7_smc_switch_mm && cpu)
-				goto bl_error;
 			per_cpu(harden_branch_predictor_fn, cpu) =
 				call_smc_arch_workaround_1;
-			processor.switch_mm = cpu_v7_smc_switch_mm;
+			cpu_do_switch_mm = cpu_v7_smc_switch_mm;
 			spectre_v2_method = "firmware";
 			break;
 
@@ -119,11 +111,6 @@ static void cpu_v7_spectre_init(void)
 	if (spectre_v2_method)
 		pr_info("CPU%u: Spectre v2: using %s workaround\n",
 			smp_processor_id(), spectre_v2_method);
-	return;
-
-bl_error:
-	pr_err("CPU%u: Spectre v2: incorrect context switching function, system vulnerable\n",
-		cpu);
 }
 #else
 static void cpu_v7_spectre_init(void)
-- 
2.20.1

