Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57192618078
	for <lists+stable@lfdr.de>; Thu,  3 Nov 2022 16:04:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232026AbiKCPEr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Nov 2022 11:04:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231951AbiKCPDk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Nov 2022 11:03:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8115C1A387;
        Thu,  3 Nov 2022 08:02:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD6CE61F1E;
        Thu,  3 Nov 2022 15:02:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DC52C433C1;
        Thu,  3 Nov 2022 15:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667487764;
        bh=xkteydpzaHmeB43SWqjbWIYj+px2C7oxYLp7zDIDU/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E40QAP1T0Fa4CnT1TwpYgW8KFfEBsFbDoJpdaiBih5CkErDSt0P9pntR943RnhujX
         PiwWo7CbVpRHyMQTSDTDoHgiiLutwitaBTN6uPHpG9C5sRn+DcmLTh4B4DCVzqIwSm
         RIJN8ZHeScnxOCbuCr67fOCofSNXGVgwmQQUoS0s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.15.77
Date:   Fri,  4 Nov 2022 00:03:14 +0900
Message-Id: <1667487794110102@kroah.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <1667487794254161@kroah.com>
References: <1667487794254161@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index e7293e7a7ee9..3e712ea4c745 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 15
-SUBLEVEL = 76
+SUBLEVEL = 77
 EXTRAVERSION =
 NAME = Trick or Treat
 
diff --git a/arch/arc/include/asm/io.h b/arch/arc/include/asm/io.h
index 8f777d6441a5..80347382a380 100644
--- a/arch/arc/include/asm/io.h
+++ b/arch/arc/include/asm/io.h
@@ -32,7 +32,7 @@ static inline void ioport_unmap(void __iomem *addr)
 {
 }
 
-extern void iounmap(const void __iomem *addr);
+extern void iounmap(const volatile void __iomem *addr);
 
 /*
  * io{read,write}{16,32}be() macros
diff --git a/arch/arc/include/asm/pgtable-levels.h b/arch/arc/include/asm/pgtable-levels.h
index 8084ef2f6491..4e7a19cb8e52 100644
--- a/arch/arc/include/asm/pgtable-levels.h
+++ b/arch/arc/include/asm/pgtable-levels.h
@@ -163,7 +163,7 @@
 #define pmd_page_vaddr(pmd)	(pmd_val(pmd) & PAGE_MASK)
 #define pmd_page(pmd)		virt_to_page(pmd_page_vaddr(pmd))
 #define set_pmd(pmdp, pmd)	(*(pmdp) = pmd)
-#define pmd_pgtable(pmd)	((pgtable_t) pmd_page_vaddr(pmd))
+#define pmd_pgtable(pmd)	((pgtable_t) pmd_page(pmd))
 
 /*
  * 4th level paging: pte
diff --git a/arch/arc/mm/ioremap.c b/arch/arc/mm/ioremap.c
index 0ee75aca6e10..712c2311daef 100644
--- a/arch/arc/mm/ioremap.c
+++ b/arch/arc/mm/ioremap.c
@@ -94,7 +94,7 @@ void __iomem *ioremap_prot(phys_addr_t paddr, unsigned long size,
 EXPORT_SYMBOL(ioremap_prot);
 
 
-void iounmap(const void __iomem *addr)
+void iounmap(const volatile void __iomem *addr)
 {
 	/* weird double cast to handle phys_addr_t > 32 bits */
 	if (arc_uncached_addr_space((phys_addr_t)(u32)addr))
diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index 39f5c1672f48..457b6bb276bb 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -60,6 +60,7 @@
 #define ARM_CPU_IMP_FUJITSU		0x46
 #define ARM_CPU_IMP_HISI		0x48
 #define ARM_CPU_IMP_APPLE		0x61
+#define ARM_CPU_IMP_AMPERE		0xC0
 
 #define ARM_CPU_PART_AEM_V8		0xD0F
 #define ARM_CPU_PART_FOUNDATION		0xD00
@@ -112,6 +113,8 @@
 #define APPLE_CPU_PART_M1_ICESTORM	0x022
 #define APPLE_CPU_PART_M1_FIRESTORM	0x023
 
+#define AMPERE_CPU_PART_AMPERE1		0xAC3
+
 #define MIDR_CORTEX_A53 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A53)
 #define MIDR_CORTEX_A57 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A57)
 #define MIDR_CORTEX_A72 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A72)
@@ -151,6 +154,7 @@
 #define MIDR_HISI_TSV110 MIDR_CPU_MODEL(ARM_CPU_IMP_HISI, HISI_CPU_PART_TSV110)
 #define MIDR_APPLE_M1_ICESTORM MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M1_ICESTORM)
 #define MIDR_APPLE_M1_FIRESTORM MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M1_FIRESTORM)
+#define MIDR_AMPERE1 MIDR_CPU_MODEL(ARM_CPU_IMP_AMPERE, AMPERE_CPU_PART_AMPERE1)
 
 /* Fujitsu Erratum 010001 affects A64FX 1.0 and 1.1, (v0r0 and v1r0) */
 #define MIDR_FUJITSU_ERRATUM_010001		MIDR_FUJITSU_A64FX
diff --git a/arch/arm64/kernel/proton-pack.c b/arch/arm64/kernel/proton-pack.c
index 40be3a7c2c53..428cfabd11c4 100644
--- a/arch/arm64/kernel/proton-pack.c
+++ b/arch/arm64/kernel/proton-pack.c
@@ -868,6 +868,10 @@ u8 spectre_bhb_loop_affected(int scope)
 			MIDR_ALL_VERSIONS(MIDR_NEOVERSE_N1),
 			{},
 		};
+		static const struct midr_range spectre_bhb_k11_list[] = {
+			MIDR_ALL_VERSIONS(MIDR_AMPERE1),
+			{},
+		};
 		static const struct midr_range spectre_bhb_k8_list[] = {
 			MIDR_ALL_VERSIONS(MIDR_CORTEX_A72),
 			MIDR_ALL_VERSIONS(MIDR_CORTEX_A57),
@@ -878,6 +882,8 @@ u8 spectre_bhb_loop_affected(int scope)
 			k = 32;
 		else if (is_midr_in_range_list(read_cpuid_id(), spectre_bhb_k24_list))
 			k = 24;
+		else if (is_midr_in_range_list(read_cpuid_id(), spectre_bhb_k11_list))
+			k = 11;
 		else if (is_midr_in_range_list(read_cpuid_id(), spectre_bhb_k8_list))
 			k =  8;
 
diff --git a/arch/s390/include/asm/futex.h b/arch/s390/include/asm/futex.h
index c22debfcebf1..bf15767b729f 100644
--- a/arch/s390/include/asm/futex.h
+++ b/arch/s390/include/asm/futex.h
@@ -16,7 +16,8 @@
 		"3: jl    1b\n"						\
 		"   lhi   %0,0\n"					\
 		"4: sacf  768\n"					\
-		EX_TABLE(0b,4b) EX_TABLE(2b,4b) EX_TABLE(3b,4b)		\
+		EX_TABLE(0b,4b) EX_TABLE(1b,4b)				\
+		EX_TABLE(2b,4b) EX_TABLE(3b,4b)				\
 		: "=d" (ret), "=&d" (oldval), "=&d" (newval),		\
 		  "=m" (*uaddr)						\
 		: "0" (-EFAULT), "d" (oparg), "a" (uaddr),		\
diff --git a/arch/s390/pci/pci_mmio.c b/arch/s390/pci/pci_mmio.c
index c5b35ea129cf..b94163ee5632 100644
--- a/arch/s390/pci/pci_mmio.c
+++ b/arch/s390/pci/pci_mmio.c
@@ -63,7 +63,7 @@ static inline int __pcistg_mio_inuser(
 	asm volatile (
 		"       sacf    256\n"
 		"0:     llgc    %[tmp],0(%[src])\n"
-		"       sllg    %[val],%[val],8\n"
+		"4:	sllg	%[val],%[val],8\n"
 		"       aghi    %[src],1\n"
 		"       ogr     %[val],%[tmp]\n"
 		"       brctg   %[cnt],0b\n"
@@ -71,7 +71,7 @@ static inline int __pcistg_mio_inuser(
 		"2:     ipm     %[cc]\n"
 		"       srl     %[cc],28\n"
 		"3:     sacf    768\n"
-		EX_TABLE(0b, 3b) EX_TABLE(1b, 3b) EX_TABLE(2b, 3b)
+		EX_TABLE(0b, 3b) EX_TABLE(4b, 3b) EX_TABLE(1b, 3b) EX_TABLE(2b, 3b)
 		:
 		[src] "+a" (src), [cnt] "+d" (cnt),
 		[val] "+d" (val), [tmp] "=d" (tmp),
@@ -214,10 +214,10 @@ static inline int __pcilg_mio_inuser(
 		"2:     ahi     %[shift],-8\n"
 		"       srlg    %[tmp],%[val],0(%[shift])\n"
 		"3:     stc     %[tmp],0(%[dst])\n"
-		"       aghi    %[dst],1\n"
+		"5:	aghi	%[dst],1\n"
 		"       brctg   %[cnt],2b\n"
 		"4:     sacf    768\n"
-		EX_TABLE(0b, 4b) EX_TABLE(1b, 4b) EX_TABLE(3b, 4b)
+		EX_TABLE(0b, 4b) EX_TABLE(1b, 4b) EX_TABLE(3b, 4b) EX_TABLE(5b, 4b)
 		:
 		[ioaddr_len] "+&d" (ioaddr_len.pair),
 		[cc] "+d" (cc), [val] "=d" (val),
diff --git a/arch/x86/events/intel/lbr.c b/arch/x86/events/intel/lbr.c
index 673721387391..b3f92255cbd2 100644
--- a/arch/x86/events/intel/lbr.c
+++ b/arch/x86/events/intel/lbr.c
@@ -1847,7 +1847,7 @@ void __init intel_pmu_arch_lbr_init(void)
 	return;
 
 clear_arch_lbr:
-	clear_cpu_cap(&boot_cpu_data, X86_FEATURE_ARCH_LBR);
+	setup_clear_cpu_cap(X86_FEATURE_ARCH_LBR);
 }
 
 /**
diff --git a/arch/x86/kernel/unwind_orc.c b/arch/x86/kernel/unwind_orc.c
index 3423aaea4ad8..8488966da5f1 100644
--- a/arch/x86/kernel/unwind_orc.c
+++ b/arch/x86/kernel/unwind_orc.c
@@ -700,7 +700,7 @@ void __unwind_start(struct unwind_state *state, struct task_struct *task,
 	/* Otherwise, skip ahead to the user-specified starting frame: */
 	while (!unwind_done(state) &&
 	       (!on_stack(&state->stack_info, first_frame, sizeof(long)) ||
-			state->sp < (unsigned long)first_frame))
+			state->sp <= (unsigned long)first_frame))
 		unwind_next_frame(state);
 
 	return;
diff --git a/drivers/base/power/domain.c b/drivers/base/power/domain.c
index 7f3d21e6fdfb..94fe30c187ad 100644
--- a/drivers/base/power/domain.c
+++ b/drivers/base/power/domain.c
@@ -2889,6 +2889,10 @@ static int genpd_iterate_idle_states(struct device_node *dn,
 		np = it.node;
 		if (!of_match_node(idle_state_match, np))
 			continue;
+
+		if (!of_device_is_available(np))
+			continue;
+
 		if (states) {
 			ret = genpd_parse_state(&states[i], np);
 			if (ret) {
diff --git a/drivers/counter/microchip-tcb-capture.c b/drivers/counter/microchip-tcb-capture.c
index 1aa70b9c4833..22563dcded75 100644
--- a/drivers/counter/microchip-tcb-capture.c
+++ b/drivers/counter/microchip-tcb-capture.c
@@ -29,7 +29,6 @@ struct mchp_tc_data {
 	int qdec_mode;
 	int num_channels;
 	int channel[2];
-	bool trig_inverted;
 };
 
 enum mchp_tc_count_function {
@@ -166,7 +165,7 @@ static int mchp_tc_count_signal_read(struct counter_device *counter,
 
 	regmap_read(priv->regmap, ATMEL_TC_REG(priv->channel[0], SR), &sr);
 
-	if (priv->trig_inverted)
+	if (signal->id == 1)
 		sigstatus = (sr & ATMEL_TC_MTIOB);
 	else
 		sigstatus = (sr & ATMEL_TC_MTIOA);
@@ -184,6 +183,17 @@ static int mchp_tc_count_action_get(struct counter_device *counter,
 	struct mchp_tc_data *const priv = counter->priv;
 	u32 cmr;
 
+	if (priv->qdec_mode) {
+		*action = COUNTER_SYNAPSE_ACTION_BOTH_EDGES;
+		return 0;
+	}
+
+	/* Only TIOA signal is evaluated in non-QDEC mode */
+	if (synapse->signal->id != 0) {
+		*action = COUNTER_SYNAPSE_ACTION_NONE;
+		return 0;
+	}
+
 	regmap_read(priv->regmap, ATMEL_TC_REG(priv->channel[0], CMR), &cmr);
 
 	switch (cmr & ATMEL_TC_ETRGEDG) {
@@ -212,8 +222,8 @@ static int mchp_tc_count_action_set(struct counter_device *counter,
 	struct mchp_tc_data *const priv = counter->priv;
 	u32 edge = ATMEL_TC_ETRGEDG_NONE;
 
-	/* QDEC mode is rising edge only */
-	if (priv->qdec_mode)
+	/* QDEC mode is rising edge only; only TIOA handled in non-QDEC mode */
+	if (priv->qdec_mode || synapse->signal->id != 0)
 		return -EINVAL;
 
 	switch (action) {
diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index c57229c108a7..eee74a2fe317 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -27,6 +27,7 @@
 #include <linux/pm_qos.h>
 #include <trace/events/power.h>
 
+#include <asm/cpu.h>
 #include <asm/div64.h>
 #include <asm/msr.h>
 #include <asm/cpu_device_id.h>
@@ -277,10 +278,10 @@ static struct cpudata **all_cpu_data;
  * structure is used to store those callbacks.
  */
 struct pstate_funcs {
-	int (*get_max)(void);
-	int (*get_max_physical)(void);
-	int (*get_min)(void);
-	int (*get_turbo)(void);
+	int (*get_max)(int cpu);
+	int (*get_max_physical)(int cpu);
+	int (*get_min)(int cpu);
+	int (*get_turbo)(int cpu);
 	int (*get_scaling)(void);
 	int (*get_cpu_scaling)(int cpu);
 	int (*get_aperf_mperf_shift)(void);
@@ -395,16 +396,6 @@ static int intel_pstate_get_cppc_guaranteed(int cpu)
 
 	return cppc_perf.nominal_perf;
 }
-
-static u32 intel_pstate_cppc_nominal(int cpu)
-{
-	u64 nominal_perf;
-
-	if (cppc_get_nominal_perf(cpu, &nominal_perf))
-		return 0;
-
-	return nominal_perf;
-}
 #else /* CONFIG_ACPI_CPPC_LIB */
 static inline void intel_pstate_set_itmt_prio(int cpu)
 {
@@ -528,35 +519,18 @@ static void intel_pstate_hybrid_hwp_adjust(struct cpudata *cpu)
 {
 	int perf_ctl_max_phys = cpu->pstate.max_pstate_physical;
 	int perf_ctl_scaling = cpu->pstate.perf_ctl_scaling;
-	int perf_ctl_turbo = pstate_funcs.get_turbo();
-	int turbo_freq = perf_ctl_turbo * perf_ctl_scaling;
+	int perf_ctl_turbo = pstate_funcs.get_turbo(cpu->cpu);
 	int scaling = cpu->pstate.scaling;
 
 	pr_debug("CPU%d: perf_ctl_max_phys = %d\n", cpu->cpu, perf_ctl_max_phys);
-	pr_debug("CPU%d: perf_ctl_max = %d\n", cpu->cpu, pstate_funcs.get_max());
 	pr_debug("CPU%d: perf_ctl_turbo = %d\n", cpu->cpu, perf_ctl_turbo);
 	pr_debug("CPU%d: perf_ctl_scaling = %d\n", cpu->cpu, perf_ctl_scaling);
 	pr_debug("CPU%d: HWP_CAP guaranteed = %d\n", cpu->cpu, cpu->pstate.max_pstate);
 	pr_debug("CPU%d: HWP_CAP highest = %d\n", cpu->cpu, cpu->pstate.turbo_pstate);
 	pr_debug("CPU%d: HWP-to-frequency scaling factor: %d\n", cpu->cpu, scaling);
 
-	/*
-	 * If the product of the HWP performance scaling factor and the HWP_CAP
-	 * highest performance is greater than the maximum turbo frequency
-	 * corresponding to the pstate_funcs.get_turbo() return value, the
-	 * scaling factor is too high, so recompute it to make the HWP_CAP
-	 * highest performance correspond to the maximum turbo frequency.
-	 */
-	cpu->pstate.turbo_freq = cpu->pstate.turbo_pstate * scaling;
-	if (turbo_freq < cpu->pstate.turbo_freq) {
-		cpu->pstate.turbo_freq = turbo_freq;
-		scaling = DIV_ROUND_UP(turbo_freq, cpu->pstate.turbo_pstate);
-		cpu->pstate.scaling = scaling;
-
-		pr_debug("CPU%d: refined HWP-to-frequency scaling factor: %d\n",
-			 cpu->cpu, scaling);
-	}
-
+	cpu->pstate.turbo_freq = rounddown(cpu->pstate.turbo_pstate * scaling,
+					   perf_ctl_scaling);
 	cpu->pstate.max_freq = rounddown(cpu->pstate.max_pstate * scaling,
 					 perf_ctl_scaling);
 
@@ -1581,7 +1555,7 @@ static void intel_pstate_hwp_enable(struct cpudata *cpudata)
 		cpudata->epp_default = intel_pstate_get_epp(cpudata, 0);
 }
 
-static int atom_get_min_pstate(void)
+static int atom_get_min_pstate(int not_used)
 {
 	u64 value;
 
@@ -1589,7 +1563,7 @@ static int atom_get_min_pstate(void)
 	return (value >> 8) & 0x7F;
 }
 
-static int atom_get_max_pstate(void)
+static int atom_get_max_pstate(int not_used)
 {
 	u64 value;
 
@@ -1597,7 +1571,7 @@ static int atom_get_max_pstate(void)
 	return (value >> 16) & 0x7F;
 }
 
-static int atom_get_turbo_pstate(void)
+static int atom_get_turbo_pstate(int not_used)
 {
 	u64 value;
 
@@ -1675,23 +1649,23 @@ static void atom_get_vid(struct cpudata *cpudata)
 	cpudata->vid.turbo = value & 0x7f;
 }
 
-static int core_get_min_pstate(void)
+static int core_get_min_pstate(int cpu)
 {
 	u64 value;
 
-	rdmsrl(MSR_PLATFORM_INFO, value);
+	rdmsrl_on_cpu(cpu, MSR_PLATFORM_INFO, &value);
 	return (value >> 40) & 0xFF;
 }
 
-static int core_get_max_pstate_physical(void)
+static int core_get_max_pstate_physical(int cpu)
 {
 	u64 value;
 
-	rdmsrl(MSR_PLATFORM_INFO, value);
+	rdmsrl_on_cpu(cpu, MSR_PLATFORM_INFO, &value);
 	return (value >> 8) & 0xFF;
 }
 
-static int core_get_tdp_ratio(u64 plat_info)
+static int core_get_tdp_ratio(int cpu, u64 plat_info)
 {
 	/* Check how many TDP levels present */
 	if (plat_info & 0x600000000) {
@@ -1701,13 +1675,13 @@ static int core_get_tdp_ratio(u64 plat_info)
 		int err;
 
 		/* Get the TDP level (0, 1, 2) to get ratios */
-		err = rdmsrl_safe(MSR_CONFIG_TDP_CONTROL, &tdp_ctrl);
+		err = rdmsrl_safe_on_cpu(cpu, MSR_CONFIG_TDP_CONTROL, &tdp_ctrl);
 		if (err)
 			return err;
 
 		/* TDP MSR are continuous starting at 0x648 */
 		tdp_msr = MSR_CONFIG_TDP_NOMINAL + (tdp_ctrl & 0x03);
-		err = rdmsrl_safe(tdp_msr, &tdp_ratio);
+		err = rdmsrl_safe_on_cpu(cpu, tdp_msr, &tdp_ratio);
 		if (err)
 			return err;
 
@@ -1724,7 +1698,7 @@ static int core_get_tdp_ratio(u64 plat_info)
 	return -ENXIO;
 }
 
-static int core_get_max_pstate(void)
+static int core_get_max_pstate(int cpu)
 {
 	u64 tar;
 	u64 plat_info;
@@ -1732,10 +1706,10 @@ static int core_get_max_pstate(void)
 	int tdp_ratio;
 	int err;
 
-	rdmsrl(MSR_PLATFORM_INFO, plat_info);
+	rdmsrl_on_cpu(cpu, MSR_PLATFORM_INFO, &plat_info);
 	max_pstate = (plat_info >> 8) & 0xFF;
 
-	tdp_ratio = core_get_tdp_ratio(plat_info);
+	tdp_ratio = core_get_tdp_ratio(cpu, plat_info);
 	if (tdp_ratio <= 0)
 		return max_pstate;
 
@@ -1744,7 +1718,7 @@ static int core_get_max_pstate(void)
 		return tdp_ratio;
 	}
 
-	err = rdmsrl_safe(MSR_TURBO_ACTIVATION_RATIO, &tar);
+	err = rdmsrl_safe_on_cpu(cpu, MSR_TURBO_ACTIVATION_RATIO, &tar);
 	if (!err) {
 		int tar_levels;
 
@@ -1759,13 +1733,13 @@ static int core_get_max_pstate(void)
 	return max_pstate;
 }
 
-static int core_get_turbo_pstate(void)
+static int core_get_turbo_pstate(int cpu)
 {
 	u64 value;
 	int nont, ret;
 
-	rdmsrl(MSR_TURBO_RATIO_LIMIT, value);
-	nont = core_get_max_pstate();
+	rdmsrl_on_cpu(cpu, MSR_TURBO_RATIO_LIMIT, &value);
+	nont = core_get_max_pstate(cpu);
 	ret = (value) & 255;
 	if (ret <= nont)
 		ret = nont;
@@ -1793,50 +1767,37 @@ static int knl_get_aperf_mperf_shift(void)
 	return 10;
 }
 
-static int knl_get_turbo_pstate(void)
+static int knl_get_turbo_pstate(int cpu)
 {
 	u64 value;
 	int nont, ret;
 
-	rdmsrl(MSR_TURBO_RATIO_LIMIT, value);
-	nont = core_get_max_pstate();
+	rdmsrl_on_cpu(cpu, MSR_TURBO_RATIO_LIMIT, &value);
+	nont = core_get_max_pstate(cpu);
 	ret = (((value) >> 8) & 0xFF);
 	if (ret <= nont)
 		ret = nont;
 	return ret;
 }
 
-#ifdef CONFIG_ACPI_CPPC_LIB
-static u32 hybrid_ref_perf;
-
-static int hybrid_get_cpu_scaling(int cpu)
+static void hybrid_get_type(void *data)
 {
-	return DIV_ROUND_UP(core_get_scaling() * hybrid_ref_perf,
-			    intel_pstate_cppc_nominal(cpu));
+	u8 *cpu_type = data;
+
+	*cpu_type = get_this_hybrid_cpu_type();
 }
 
-static void intel_pstate_cppc_set_cpu_scaling(void)
+static int hybrid_get_cpu_scaling(int cpu)
 {
-	u32 min_nominal_perf = U32_MAX;
-	int cpu;
+	u8 cpu_type = 0;
 
-	for_each_present_cpu(cpu) {
-		u32 nominal_perf = intel_pstate_cppc_nominal(cpu);
+	smp_call_function_single(cpu, hybrid_get_type, &cpu_type, 1);
+	/* P-cores have a smaller perf level-to-freqency scaling factor. */
+	if (cpu_type == 0x40)
+		return 78741;
 
-		if (nominal_perf && nominal_perf < min_nominal_perf)
-			min_nominal_perf = nominal_perf;
-	}
-
-	if (min_nominal_perf < U32_MAX) {
-		hybrid_ref_perf = min_nominal_perf;
-		pstate_funcs.get_cpu_scaling = hybrid_get_cpu_scaling;
-	}
+	return core_get_scaling();
 }
-#else
-static inline void intel_pstate_cppc_set_cpu_scaling(void)
-{
-}
-#endif /* CONFIG_ACPI_CPPC_LIB */
 
 static void intel_pstate_set_pstate(struct cpudata *cpu, int pstate)
 {
@@ -1866,10 +1827,10 @@ static void intel_pstate_max_within_limits(struct cpudata *cpu)
 
 static void intel_pstate_get_cpu_pstates(struct cpudata *cpu)
 {
-	int perf_ctl_max_phys = pstate_funcs.get_max_physical();
+	int perf_ctl_max_phys = pstate_funcs.get_max_physical(cpu->cpu);
 	int perf_ctl_scaling = pstate_funcs.get_scaling();
 
-	cpu->pstate.min_pstate = pstate_funcs.get_min();
+	cpu->pstate.min_pstate = pstate_funcs.get_min(cpu->cpu);
 	cpu->pstate.max_pstate_physical = perf_ctl_max_phys;
 	cpu->pstate.perf_ctl_scaling = perf_ctl_scaling;
 
@@ -1885,8 +1846,8 @@ static void intel_pstate_get_cpu_pstates(struct cpudata *cpu)
 		}
 	} else {
 		cpu->pstate.scaling = perf_ctl_scaling;
-		cpu->pstate.max_pstate = pstate_funcs.get_max();
-		cpu->pstate.turbo_pstate = pstate_funcs.get_turbo();
+		cpu->pstate.max_pstate = pstate_funcs.get_max(cpu->cpu);
+		cpu->pstate.turbo_pstate = pstate_funcs.get_turbo(cpu->cpu);
 	}
 
 	if (cpu->pstate.scaling == perf_ctl_scaling) {
@@ -3063,9 +3024,9 @@ static unsigned int force_load __initdata;
 
 static int __init intel_pstate_msrs_not_valid(void)
 {
-	if (!pstate_funcs.get_max() ||
-	    !pstate_funcs.get_min() ||
-	    !pstate_funcs.get_turbo())
+	if (!pstate_funcs.get_max(0) ||
+	    !pstate_funcs.get_min(0) ||
+	    !pstate_funcs.get_turbo(0))
 		return -ENODEV;
 
 	return 0;
@@ -3281,7 +3242,7 @@ static int __init intel_pstate_init(void)
 				default_driver = &intel_pstate;
 
 			if (boot_cpu_has(X86_FEATURE_HYBRID_CPU))
-				intel_pstate_cppc_set_cpu_scaling();
+				pstate_funcs.get_cpu_scaling = hybrid_get_cpu_scaling;
 
 			goto hwp_cpu_matched;
 		}
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
index c904269b3e14..477ab3551177 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -476,13 +476,13 @@ kfd_mem_dmamap_userptr(struct kgd_mem *mem,
 	struct ttm_tt *ttm = bo->tbo.ttm;
 	int ret;
 
+	if (WARN_ON(ttm->num_pages != src_ttm->num_pages))
+		return -EINVAL;
+
 	ttm->sg = kmalloc(sizeof(*ttm->sg), GFP_KERNEL);
 	if (unlikely(!ttm->sg))
 		return -ENOMEM;
 
-	if (WARN_ON(ttm->num_pages != src_ttm->num_pages))
-		return -EINVAL;
-
 	/* Same sequence as in amdgpu_ttm_tt_pin_userptr */
 	ret = sg_alloc_table_from_pages(ttm->sg, src_ttm->pages,
 					ttm->num_pages, 0,
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index ac4dabcde33f..36cc89f56cea 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -3185,6 +3185,15 @@ static int amdgpu_device_ip_resume_phase2(struct amdgpu_device *adev)
 			return r;
 		}
 		adev->ip_blocks[i].status.hw = true;
+
+		if (adev->in_s0ix && adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_SMC) {
+			/* disable gfxoff for IP resume. The gfxoff will be re-enabled in
+			 * amdgpu_device_resume() after IP resume.
+			 */
+			amdgpu_gfx_off_ctrl(adev, false);
+			DRM_DEBUG("will disable gfxoff for re-initializing other blocks\n");
+		}
+
 	}
 
 	return 0;
@@ -4114,6 +4123,13 @@ int amdgpu_device_resume(struct drm_device *dev, bool fbcon)
 	/* Make sure IB tests flushed */
 	flush_delayed_work(&adev->delayed_init_work);
 
+	if (adev->in_s0ix) {
+		/* re-enable gfxoff after IP resume. This re-enables gfxoff after
+		 * it was disabled for IP resume in amdgpu_device_ip_resume_phase2().
+		 */
+		amdgpu_gfx_off_ctrl(adev, true);
+		DRM_DEBUG("will enable gfxoff for the mission mode\n");
+	}
 	if (fbcon)
 		amdgpu_fbdev_set_suspend(adev, 0);
 
diff --git a/drivers/gpu/drm/i915/display/intel_dp.c b/drivers/gpu/drm/i915/display/intel_dp.c
index f87e4d510ea5..1ccdf2da042b 100644
--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -3497,6 +3497,8 @@ intel_dp_handle_hdmi_link_status_change(struct intel_dp *intel_dp)
 
 		drm_dp_pcon_hdmi_frl_link_error_count(&intel_dp->aux, &intel_dp->attached_connector->base);
 
+		intel_dp->frl.is_trained = false;
+
 		/* Restart FRL training or fall back to TMDS mode */
 		intel_dp_check_frl_training(intel_dp);
 	}
diff --git a/drivers/gpu/drm/msm/disp/mdp4/mdp4_lvds_connector.c b/drivers/gpu/drm/msm/disp/mdp4/mdp4_lvds_connector.c
index 7288041dd86a..7444b75c4215 100644
--- a/drivers/gpu/drm/msm/disp/mdp4/mdp4_lvds_connector.c
+++ b/drivers/gpu/drm/msm/disp/mdp4/mdp4_lvds_connector.c
@@ -56,8 +56,9 @@ static int mdp4_lvds_connector_get_modes(struct drm_connector *connector)
 	return ret;
 }
 
-static int mdp4_lvds_connector_mode_valid(struct drm_connector *connector,
-				 struct drm_display_mode *mode)
+static enum drm_mode_status
+mdp4_lvds_connector_mode_valid(struct drm_connector *connector,
+			       struct drm_display_mode *mode)
 {
 	struct mdp4_lvds_connector *mdp4_lvds_connector =
 			to_mdp4_lvds_connector(connector);
diff --git a/drivers/gpu/drm/msm/dp/dp_display.c b/drivers/gpu/drm/msm/dp/dp_display.c
index b141ccb527b0..d13fd39f05de 100644
--- a/drivers/gpu/drm/msm/dp/dp_display.c
+++ b/drivers/gpu/drm/msm/dp/dp_display.c
@@ -1229,7 +1229,7 @@ int dp_display_request_irq(struct msm_dp *dp_display)
 		return -EINVAL;
 	}
 
-	rc = devm_request_irq(&dp->pdev->dev, dp->irq,
+	rc = devm_request_irq(dp_display->drm_dev->dev, dp->irq,
 			dp_display_irq_handler,
 			IRQF_TRIGGER_HIGH, "dp_display_isr", dp);
 	if (rc < 0) {
diff --git a/drivers/gpu/drm/msm/dsi/dsi.c b/drivers/gpu/drm/msm/dsi/dsi.c
index 122fadcf7cc1..fb8b21837c29 100644
--- a/drivers/gpu/drm/msm/dsi/dsi.c
+++ b/drivers/gpu/drm/msm/dsi/dsi.c
@@ -212,6 +212,12 @@ int msm_dsi_modeset_init(struct msm_dsi *msm_dsi, struct drm_device *dev,
 		return -EINVAL;
 
 	priv = dev->dev_private;
+
+	if (priv->num_bridges == ARRAY_SIZE(priv->bridges)) {
+		DRM_DEV_ERROR(dev->dev, "too many bridges\n");
+		return -ENOSPC;
+	}
+
 	msm_dsi->dev = dev;
 
 	ret = msm_dsi_host_modeset_init(msm_dsi->host, dev);
diff --git a/drivers/gpu/drm/msm/hdmi/hdmi.c b/drivers/gpu/drm/msm/hdmi/hdmi.c
index 23fb88b53324..e082e01b5e8d 100644
--- a/drivers/gpu/drm/msm/hdmi/hdmi.c
+++ b/drivers/gpu/drm/msm/hdmi/hdmi.c
@@ -295,6 +295,11 @@ int msm_hdmi_modeset_init(struct hdmi *hdmi,
 	struct platform_device *pdev = hdmi->pdev;
 	int ret;
 
+	if (priv->num_bridges == ARRAY_SIZE(priv->bridges)) {
+		DRM_DEV_ERROR(dev->dev, "too many bridges\n");
+		return -ENOSPC;
+	}
+
 	hdmi->dev = dev;
 	hdmi->encoder = encoder;
 
diff --git a/drivers/hwtracing/coresight/coresight-cti-core.c b/drivers/hwtracing/coresight/coresight-cti-core.c
index 8988b2ed2ea6..dcd607a0c41a 100644
--- a/drivers/hwtracing/coresight/coresight-cti-core.c
+++ b/drivers/hwtracing/coresight/coresight-cti-core.c
@@ -90,11 +90,9 @@ void cti_write_all_hw_regs(struct cti_drvdata *drvdata)
 static int cti_enable_hw(struct cti_drvdata *drvdata)
 {
 	struct cti_config *config = &drvdata->config;
-	struct device *dev = &drvdata->csdev->dev;
 	unsigned long flags;
 	int rc = 0;
 
-	pm_runtime_get_sync(dev->parent);
 	spin_lock_irqsave(&drvdata->spinlock, flags);
 
 	/* no need to do anything if enabled or unpowered*/
@@ -119,7 +117,6 @@ static int cti_enable_hw(struct cti_drvdata *drvdata)
 	/* cannot enable due to error */
 cti_err_not_enabled:
 	spin_unlock_irqrestore(&drvdata->spinlock, flags);
-	pm_runtime_put(dev->parent);
 	return rc;
 }
 
@@ -153,7 +150,6 @@ static void cti_cpuhp_enable_hw(struct cti_drvdata *drvdata)
 static int cti_disable_hw(struct cti_drvdata *drvdata)
 {
 	struct cti_config *config = &drvdata->config;
-	struct device *dev = &drvdata->csdev->dev;
 	struct coresight_device *csdev = drvdata->csdev;
 
 	spin_lock(&drvdata->spinlock);
@@ -175,7 +171,6 @@ static int cti_disable_hw(struct cti_drvdata *drvdata)
 	coresight_disclaim_device_unlocked(csdev);
 	CS_LOCK(drvdata->base);
 	spin_unlock(&drvdata->spinlock);
-	pm_runtime_put(dev->parent);
 	return 0;
 
 	/* not disabled this call */
diff --git a/drivers/iio/accel/adxl372.c b/drivers/iio/accel/adxl372.c
index fc9592407717..4a358f8c27f3 100644
--- a/drivers/iio/accel/adxl372.c
+++ b/drivers/iio/accel/adxl372.c
@@ -998,17 +998,30 @@ static ssize_t adxl372_get_fifo_watermark(struct device *dev,
 	return sprintf(buf, "%d\n", st->watermark);
 }
 
-static IIO_CONST_ATTR(hwfifo_watermark_min, "1");
-static IIO_CONST_ATTR(hwfifo_watermark_max,
-		      __stringify(ADXL372_FIFO_SIZE));
+static ssize_t hwfifo_watermark_min_show(struct device *dev,
+					 struct device_attribute *attr,
+					 char *buf)
+{
+	return sysfs_emit(buf, "%s\n", "1");
+}
+
+static ssize_t hwfifo_watermark_max_show(struct device *dev,
+					 struct device_attribute *attr,
+					 char *buf)
+{
+	return sysfs_emit(buf, "%s\n", __stringify(ADXL372_FIFO_SIZE));
+}
+
+static IIO_DEVICE_ATTR_RO(hwfifo_watermark_min, 0);
+static IIO_DEVICE_ATTR_RO(hwfifo_watermark_max, 0);
 static IIO_DEVICE_ATTR(hwfifo_watermark, 0444,
 		       adxl372_get_fifo_watermark, NULL, 0);
 static IIO_DEVICE_ATTR(hwfifo_enabled, 0444,
 		       adxl372_get_fifo_enabled, NULL, 0);
 
 static const struct attribute *adxl372_fifo_attributes[] = {
-	&iio_const_attr_hwfifo_watermark_min.dev_attr.attr,
-	&iio_const_attr_hwfifo_watermark_max.dev_attr.attr,
+	&iio_dev_attr_hwfifo_watermark_min.dev_attr.attr,
+	&iio_dev_attr_hwfifo_watermark_max.dev_attr.attr,
 	&iio_dev_attr_hwfifo_watermark.dev_attr.attr,
 	&iio_dev_attr_hwfifo_enabled.dev_attr.attr,
 	NULL,
diff --git a/drivers/iio/light/tsl2583.c b/drivers/iio/light/tsl2583.c
index 7e101d5f72ee..d696d19e2e8e 100644
--- a/drivers/iio/light/tsl2583.c
+++ b/drivers/iio/light/tsl2583.c
@@ -858,7 +858,7 @@ static int tsl2583_probe(struct i2c_client *clientp,
 					 TSL2583_POWER_OFF_DELAY_MS);
 	pm_runtime_use_autosuspend(&clientp->dev);
 
-	ret = devm_iio_device_register(indio_dev->dev.parent, indio_dev);
+	ret = iio_device_register(indio_dev);
 	if (ret) {
 		dev_err(&clientp->dev, "%s: iio registration failed\n",
 			__func__);
diff --git a/drivers/iio/temperature/ltc2983.c b/drivers/iio/temperature/ltc2983.c
index 3b4a0e60e605..8306daa77908 100644
--- a/drivers/iio/temperature/ltc2983.c
+++ b/drivers/iio/temperature/ltc2983.c
@@ -1376,13 +1376,6 @@ static int ltc2983_setup(struct ltc2983_data *st, bool assign_iio)
 		return ret;
 	}
 
-	st->iio_chan = devm_kzalloc(&st->spi->dev,
-				    st->iio_channels * sizeof(*st->iio_chan),
-				    GFP_KERNEL);
-
-	if (!st->iio_chan)
-		return -ENOMEM;
-
 	ret = regmap_update_bits(st->regmap, LTC2983_GLOBAL_CONFIG_REG,
 				 LTC2983_NOTCH_FREQ_MASK,
 				 LTC2983_NOTCH_FREQ(st->filter_notch_freq));
@@ -1494,6 +1487,12 @@ static int ltc2983_probe(struct spi_device *spi)
 	if (ret)
 		return ret;
 
+	st->iio_chan = devm_kzalloc(&spi->dev,
+				    st->iio_channels * sizeof(*st->iio_chan),
+				    GFP_KERNEL);
+	if (!st->iio_chan)
+		return -ENOMEM;
+
 	ret = ltc2983_setup(st, true);
 	if (ret)
 		return ret;
diff --git a/drivers/media/test-drivers/vivid/vivid-core.c b/drivers/media/test-drivers/vivid/vivid-core.c
index d2bd2653cf54..065bdc33f049 100644
--- a/drivers/media/test-drivers/vivid/vivid-core.c
+++ b/drivers/media/test-drivers/vivid/vivid-core.c
@@ -330,6 +330,28 @@ static int vidioc_g_fbuf(struct file *file, void *fh, struct v4l2_framebuffer *a
 	return vivid_vid_out_g_fbuf(file, fh, a);
 }
 
+/*
+ * Only support the framebuffer of one of the vivid instances.
+ * Anything else is rejected.
+ */
+bool vivid_validate_fb(const struct v4l2_framebuffer *a)
+{
+	struct vivid_dev *dev;
+	int i;
+
+	for (i = 0; i < n_devs; i++) {
+		dev = vivid_devs[i];
+		if (!dev || !dev->video_pbase)
+			continue;
+		if ((unsigned long)a->base == dev->video_pbase &&
+		    a->fmt.width <= dev->display_width &&
+		    a->fmt.height <= dev->display_height &&
+		    a->fmt.bytesperline <= dev->display_byte_stride)
+			return true;
+	}
+	return false;
+}
+
 static int vidioc_s_fbuf(struct file *file, void *fh, const struct v4l2_framebuffer *a)
 {
 	struct video_device *vdev = video_devdata(file);
@@ -910,8 +932,12 @@ static int vivid_detect_feature_set(struct vivid_dev *dev, int inst,
 
 	/* how many inputs do we have and of what type? */
 	dev->num_inputs = num_inputs[inst];
-	if (dev->num_inputs < 1)
-		dev->num_inputs = 1;
+	if (node_type & 0x20007) {
+		if (dev->num_inputs < 1)
+			dev->num_inputs = 1;
+	} else {
+		dev->num_inputs = 0;
+	}
 	if (dev->num_inputs >= MAX_INPUTS)
 		dev->num_inputs = MAX_INPUTS;
 	for (i = 0; i < dev->num_inputs; i++) {
@@ -928,8 +954,12 @@ static int vivid_detect_feature_set(struct vivid_dev *dev, int inst,
 
 	/* how many outputs do we have and of what type? */
 	dev->num_outputs = num_outputs[inst];
-	if (dev->num_outputs < 1)
-		dev->num_outputs = 1;
+	if (node_type & 0x40300) {
+		if (dev->num_outputs < 1)
+			dev->num_outputs = 1;
+	} else {
+		dev->num_outputs = 0;
+	}
 	if (dev->num_outputs >= MAX_OUTPUTS)
 		dev->num_outputs = MAX_OUTPUTS;
 	for (i = 0; i < dev->num_outputs; i++) {
diff --git a/drivers/media/test-drivers/vivid/vivid-core.h b/drivers/media/test-drivers/vivid/vivid-core.h
index 1e3c4f5a9413..7ceaf9bac2f0 100644
--- a/drivers/media/test-drivers/vivid/vivid-core.h
+++ b/drivers/media/test-drivers/vivid/vivid-core.h
@@ -610,4 +610,6 @@ static inline bool vivid_is_hdmi_out(const struct vivid_dev *dev)
 	return dev->output_type[dev->output] == HDMI;
 }
 
+bool vivid_validate_fb(const struct v4l2_framebuffer *a);
+
 #endif
diff --git a/drivers/media/test-drivers/vivid/vivid-vid-cap.c b/drivers/media/test-drivers/vivid/vivid-vid-cap.c
index b9caa4b26209..99139a8cd4c4 100644
--- a/drivers/media/test-drivers/vivid/vivid-vid-cap.c
+++ b/drivers/media/test-drivers/vivid/vivid-vid-cap.c
@@ -452,6 +452,12 @@ void vivid_update_format_cap(struct vivid_dev *dev, bool keep_controls)
 	tpg_reset_source(&dev->tpg, dev->src_rect.width, dev->src_rect.height, dev->field_cap);
 	dev->crop_cap = dev->src_rect;
 	dev->crop_bounds_cap = dev->src_rect;
+	if (dev->bitmap_cap &&
+	    (dev->compose_cap.width != dev->crop_cap.width ||
+	     dev->compose_cap.height != dev->crop_cap.height)) {
+		vfree(dev->bitmap_cap);
+		dev->bitmap_cap = NULL;
+	}
 	dev->compose_cap = dev->crop_cap;
 	if (V4L2_FIELD_HAS_T_OR_B(dev->field_cap))
 		dev->compose_cap.height /= 2;
@@ -909,6 +915,8 @@ int vivid_vid_cap_s_selection(struct file *file, void *fh, struct v4l2_selection
 	struct vivid_dev *dev = video_drvdata(file);
 	struct v4l2_rect *crop = &dev->crop_cap;
 	struct v4l2_rect *compose = &dev->compose_cap;
+	unsigned orig_compose_w = compose->width;
+	unsigned orig_compose_h = compose->height;
 	unsigned factor = V4L2_FIELD_HAS_T_OR_B(dev->field_cap) ? 2 : 1;
 	int ret;
 
@@ -1025,17 +1033,17 @@ int vivid_vid_cap_s_selection(struct file *file, void *fh, struct v4l2_selection
 			s->r.height /= factor;
 		}
 		v4l2_rect_map_inside(&s->r, &dev->fmt_cap_rect);
-		if (dev->bitmap_cap && (compose->width != s->r.width ||
-					compose->height != s->r.height)) {
-			vfree(dev->bitmap_cap);
-			dev->bitmap_cap = NULL;
-		}
 		*compose = s->r;
 		break;
 	default:
 		return -EINVAL;
 	}
 
+	if (dev->bitmap_cap && (compose->width != orig_compose_w ||
+				compose->height != orig_compose_h)) {
+		vfree(dev->bitmap_cap);
+		dev->bitmap_cap = NULL;
+	}
 	tpg_s_crop_compose(&dev->tpg, crop, compose);
 	return 0;
 }
@@ -1272,7 +1280,14 @@ int vivid_vid_cap_s_fbuf(struct file *file, void *fh,
 		return -EINVAL;
 	if (a->fmt.bytesperline < (a->fmt.width * fmt->bit_depth[0]) / 8)
 		return -EINVAL;
-	if (a->fmt.height * a->fmt.bytesperline < a->fmt.sizeimage)
+	if (a->fmt.bytesperline > a->fmt.sizeimage / a->fmt.height)
+		return -EINVAL;
+
+	/*
+	 * Only support the framebuffer of one of the vivid instances.
+	 * Anything else is rejected.
+	 */
+	if (!vivid_validate_fb(a))
 		return -EINVAL;
 
 	dev->fb_vbase_cap = phys_to_virt((unsigned long)a->base);
diff --git a/drivers/media/v4l2-core/v4l2-dv-timings.c b/drivers/media/v4l2-core/v4l2-dv-timings.c
index af48705c704f..003c32fed3f7 100644
--- a/drivers/media/v4l2-core/v4l2-dv-timings.c
+++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
@@ -161,6 +161,20 @@ bool v4l2_valid_dv_timings(const struct v4l2_dv_timings *t,
 	    (bt->interlaced && !(caps & V4L2_DV_BT_CAP_INTERLACED)) ||
 	    (!bt->interlaced && !(caps & V4L2_DV_BT_CAP_PROGRESSIVE)))
 		return false;
+
+	/* sanity checks for the blanking timings */
+	if (!bt->interlaced &&
+	    (bt->il_vbackporch || bt->il_vsync || bt->il_vfrontporch))
+		return false;
+	if (bt->hfrontporch > 2 * bt->width ||
+	    bt->hsync > 1024 || bt->hbackporch > 1024)
+		return false;
+	if (bt->vfrontporch > 4096 ||
+	    bt->vsync > 128 || bt->vbackporch > 4096)
+		return false;
+	if (bt->interlaced && (bt->il_vfrontporch > 4096 ||
+	    bt->il_vsync > 128 || bt->il_vbackporch > 4096))
+		return false;
 	return fnc == NULL || fnc(t, fnc_handle);
 }
 EXPORT_SYMBOL_GPL(v4l2_valid_dv_timings);
diff --git a/drivers/mmc/core/block.c b/drivers/mmc/core/block.c
index b2533be3a453..ed034b93cb25 100644
--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -133,6 +133,7 @@ struct mmc_blk_data {
 	 * track of the current selected device partition.
 	 */
 	unsigned int	part_curr;
+#define MMC_BLK_PART_INVALID	UINT_MAX	/* Unknown partition active */
 	int	area_type;
 
 	/* debugfs files (only in main mmc_blk_data) */
@@ -984,9 +985,16 @@ static unsigned int mmc_blk_data_timeout_ms(struct mmc_host *host,
 	return ms;
 }
 
+/*
+ * Attempts to reset the card and get back to the requested partition.
+ * Therefore any error here must result in cancelling the block layer
+ * request, it must not be reattempted without going through the mmc_blk
+ * partition sanity checks.
+ */
 static int mmc_blk_reset(struct mmc_blk_data *md, struct mmc_host *host,
 			 int type)
 {
+	struct mmc_blk_data *main_md = dev_get_drvdata(&host->card->dev);
 	int err;
 
 	if (md->reset_done & type)
@@ -994,23 +1002,22 @@ static int mmc_blk_reset(struct mmc_blk_data *md, struct mmc_host *host,
 
 	md->reset_done |= type;
 	err = mmc_hw_reset(host);
+	/*
+	 * A successful reset will leave the card in the main partition, but
+	 * upon failure it might not be, so set it to MMC_BLK_PART_INVALID
+	 * in that case.
+	 */
+	main_md->part_curr = err ? MMC_BLK_PART_INVALID : main_md->part_type;
+	if (err)
+		return err;
 	/* Ensure we switch back to the correct partition */
-	if (err) {
-		struct mmc_blk_data *main_md =
-			dev_get_drvdata(&host->card->dev);
-		int part_err;
-
-		main_md->part_curr = main_md->part_type;
-		part_err = mmc_blk_part_switch(host->card, md->part_type);
-		if (part_err) {
-			/*
-			 * We have failed to get back into the correct
-			 * partition, so we need to abort the whole request.
-			 */
-			return -ENODEV;
-		}
-	}
-	return err;
+	if (mmc_blk_part_switch(host->card, md->part_type))
+		/*
+		 * We have failed to get back into the correct
+		 * partition, so we need to abort the whole request.
+		 */
+		return -ENODEV;
+	return 0;
 }
 
 static inline void mmc_blk_reset_success(struct mmc_blk_data *md, int type)
@@ -1855,8 +1862,9 @@ static void mmc_blk_mq_rw_recovery(struct mmc_queue *mq, struct request *req)
 		return;
 
 	/* Reset before last retry */
-	if (mqrq->retries + 1 == MMC_MAX_RETRIES)
-		mmc_blk_reset(md, card->host, type);
+	if (mqrq->retries + 1 == MMC_MAX_RETRIES &&
+	    mmc_blk_reset(md, card->host, type))
+		return;
 
 	/* Command errors fail fast, so use all MMC_MAX_RETRIES */
 	if (brq->sbc.error || brq->cmd.error)
diff --git a/drivers/mmc/core/sdio_bus.c b/drivers/mmc/core/sdio_bus.c
index fda03b35c14a..cac9e0f13320 100644
--- a/drivers/mmc/core/sdio_bus.c
+++ b/drivers/mmc/core/sdio_bus.c
@@ -290,7 +290,8 @@ static void sdio_release_func(struct device *dev)
 {
 	struct sdio_func *func = dev_to_sdio_func(dev);
 
-	sdio_free_func_cis(func);
+	if (!(func->card->quirks & MMC_QUIRK_NONSTD_SDIO))
+		sdio_free_func_cis(func);
 
 	kfree(func->info);
 	kfree(func->tmpbuf);
diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index ccc148cdb5ee..c167186085c8 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -1069,9 +1069,10 @@ config MMC_SDHCI_OMAP
 
 config MMC_SDHCI_AM654
 	tristate "Support for the SDHCI Controller in TI's AM654 SOCs"
-	depends on MMC_SDHCI_PLTFM && OF && REGMAP_MMIO
+	depends on MMC_SDHCI_PLTFM && OF
 	select MMC_SDHCI_IO_ACCESSORS
 	select MMC_CQHCI
+	select REGMAP_MMIO
 	help
 	  This selects the Secure Digital Host Controller Interface (SDHCI)
 	  support present in TI's AM654 SOCs. The controller supports
diff --git a/drivers/mmc/host/sdhci-esdhc-imx.c b/drivers/mmc/host/sdhci-esdhc-imx.c
index 60f19369de84..bbcbdc4327dc 100644
--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -1643,6 +1643,10 @@ static int sdhci_esdhc_imx_probe(struct platform_device *pdev)
 		host->mmc_host_ops.execute_tuning = usdhc_execute_tuning;
 	}
 
+	err = sdhci_esdhc_imx_probe_dt(pdev, host, imx_data);
+	if (err)
+		goto disable_ahb_clk;
+
 	if (imx_data->socdata->flags & ESDHC_FLAG_MAN_TUNING)
 		sdhci_esdhc_ops.platform_execute_tuning =
 					esdhc_executing_tuning;
@@ -1650,13 +1654,15 @@ static int sdhci_esdhc_imx_probe(struct platform_device *pdev)
 	if (imx_data->socdata->flags & ESDHC_FLAG_ERR004536)
 		host->quirks |= SDHCI_QUIRK_BROKEN_ADMA;
 
-	if (imx_data->socdata->flags & ESDHC_FLAG_HS400)
+	if (host->caps & MMC_CAP_8_BIT_DATA &&
+	    imx_data->socdata->flags & ESDHC_FLAG_HS400)
 		host->mmc->caps2 |= MMC_CAP2_HS400;
 
 	if (imx_data->socdata->flags & ESDHC_FLAG_BROKEN_AUTO_CMD23)
 		host->quirks2 |= SDHCI_QUIRK2_ACMD23_BROKEN;
 
-	if (imx_data->socdata->flags & ESDHC_FLAG_HS400_ES) {
+	if (host->caps & MMC_CAP_8_BIT_DATA &&
+	    imx_data->socdata->flags & ESDHC_FLAG_HS400_ES) {
 		host->mmc->caps2 |= MMC_CAP2_HS400_ES;
 		host->mmc_host_ops.hs400_enhanced_strobe =
 					esdhc_hs400_enhanced_strobe;
@@ -1678,10 +1684,6 @@ static int sdhci_esdhc_imx_probe(struct platform_device *pdev)
 			goto disable_ahb_clk;
 	}
 
-	err = sdhci_esdhc_imx_probe_dt(pdev, host, imx_data);
-	if (err)
-		goto disable_ahb_clk;
-
 	sdhci_esdhc_imx_hwinit(host);
 
 	err = sdhci_add_host(host);
diff --git a/drivers/mmc/host/sdhci-pci-core.c b/drivers/mmc/host/sdhci-pci-core.c
index c2b26ada104d..65e61cdac118 100644
--- a/drivers/mmc/host/sdhci-pci-core.c
+++ b/drivers/mmc/host/sdhci-pci-core.c
@@ -978,6 +978,12 @@ static bool glk_broken_cqhci(struct sdhci_pci_slot *slot)
 		dmi_match(DMI_SYS_VENDOR, "IRBIS"));
 }
 
+static bool jsl_broken_hs400es(struct sdhci_pci_slot *slot)
+{
+	return slot->chip->pdev->device == PCI_DEVICE_ID_INTEL_JSL_EMMC &&
+			dmi_match(DMI_BIOS_VENDOR, "ASUSTeK COMPUTER INC.");
+}
+
 static int glk_emmc_probe_slot(struct sdhci_pci_slot *slot)
 {
 	int ret = byt_emmc_probe_slot(slot);
@@ -986,9 +992,11 @@ static int glk_emmc_probe_slot(struct sdhci_pci_slot *slot)
 		slot->host->mmc->caps2 |= MMC_CAP2_CQE;
 
 	if (slot->chip->pdev->device != PCI_DEVICE_ID_INTEL_GLK_EMMC) {
-		slot->host->mmc->caps2 |= MMC_CAP2_HS400_ES;
-		slot->host->mmc_host_ops.hs400_enhanced_strobe =
-						intel_hs400_enhanced_strobe;
+		if (!jsl_broken_hs400es(slot)) {
+			slot->host->mmc->caps2 |= MMC_CAP2_HS400_ES;
+			slot->host->mmc_host_ops.hs400_enhanced_strobe =
+							intel_hs400_enhanced_strobe;
+		}
 		slot->host->mmc->caps2 |= MMC_CAP2_CQE_DCMD;
 	}
 
diff --git a/drivers/mtd/nand/raw/intel-nand-controller.c b/drivers/mtd/nand/raw/intel-nand-controller.c
index 056835fd4562..53071e791e17 100644
--- a/drivers/mtd/nand/raw/intel-nand-controller.c
+++ b/drivers/mtd/nand/raw/intel-nand-controller.c
@@ -614,11 +614,12 @@ static int ebu_nand_probe(struct platform_device *pdev)
 	ret = of_property_read_u32(chip_np, "reg", &cs);
 	if (ret) {
 		dev_err(dev, "failed to get chip select: %d\n", ret);
-		return ret;
+		goto err_of_node_put;
 	}
 	if (cs >= MAX_CS) {
 		dev_err(dev, "got invalid chip select: %d\n", cs);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err_of_node_put;
 	}
 
 	ebu_host->cs_num = cs;
@@ -627,18 +628,20 @@ static int ebu_nand_probe(struct platform_device *pdev)
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, resname);
 	ebu_host->cs[cs].chipaddr = devm_ioremap_resource(dev, res);
 	if (IS_ERR(ebu_host->cs[cs].chipaddr))
-		return PTR_ERR(ebu_host->cs[cs].chipaddr);
+		goto err_of_node_put;
 	ebu_host->cs[cs].nand_pa = res->start;
 
 	ebu_host->clk = devm_clk_get(dev, NULL);
-	if (IS_ERR(ebu_host->clk))
-		return dev_err_probe(dev, PTR_ERR(ebu_host->clk),
-				     "failed to get clock\n");
+	if (IS_ERR(ebu_host->clk)) {
+		ret = dev_err_probe(dev, PTR_ERR(ebu_host->clk),
+				    "failed to get clock\n");
+		goto err_of_node_put;
+	}
 
 	ret = clk_prepare_enable(ebu_host->clk);
 	if (ret) {
 		dev_err(dev, "failed to enable clock: %d\n", ret);
-		return ret;
+		goto err_of_node_put;
 	}
 	ebu_host->clk_rate = clk_get_rate(ebu_host->clk);
 
@@ -703,6 +706,8 @@ static int ebu_nand_probe(struct platform_device *pdev)
 	ebu_dma_cleanup(ebu_host);
 err_disable_unprepare_clk:
 	clk_disable_unprepare(ebu_host->clk);
+err_of_node_put:
+	of_node_put(chip_np);
 
 	return ret;
 }
diff --git a/drivers/mtd/nand/raw/marvell_nand.c b/drivers/mtd/nand/raw/marvell_nand.c
index 2455a581fd70..b248c5f657d5 100644
--- a/drivers/mtd/nand/raw/marvell_nand.c
+++ b/drivers/mtd/nand/raw/marvell_nand.c
@@ -2672,7 +2672,7 @@ static int marvell_nand_chip_init(struct device *dev, struct marvell_nfc *nfc,
 	chip->controller = &nfc->controller;
 	nand_set_flash_node(chip, np);
 
-	if (!of_property_read_bool(np, "marvell,nand-keep-config"))
+	if (of_property_read_bool(np, "marvell,nand-keep-config"))
 		chip->options |= NAND_KEEP_TIMINGS;
 
 	mtd = nand_to_mtd(chip);
diff --git a/drivers/net/can/mscan/mpc5xxx_can.c b/drivers/net/can/mscan/mpc5xxx_can.c
index 35892c1efef0..7d868b6eb579 100644
--- a/drivers/net/can/mscan/mpc5xxx_can.c
+++ b/drivers/net/can/mscan/mpc5xxx_can.c
@@ -322,14 +322,14 @@ static int mpc5xxx_can_probe(struct platform_device *ofdev)
 					       &mscan_clksrc);
 	if (!priv->can.clock.freq) {
 		dev_err(&ofdev->dev, "couldn't get MSCAN clock properties\n");
-		goto exit_free_mscan;
+		goto exit_put_clock;
 	}
 
 	err = register_mscandev(dev, mscan_clksrc);
 	if (err) {
 		dev_err(&ofdev->dev, "registering %s failed (err=%d)\n",
 			DRV_NAME, err);
-		goto exit_free_mscan;
+		goto exit_put_clock;
 	}
 
 	dev_info(&ofdev->dev, "MSCAN at 0x%p, irq %d, clock %d Hz\n",
@@ -337,7 +337,9 @@ static int mpc5xxx_can_probe(struct platform_device *ofdev)
 
 	return 0;
 
-exit_free_mscan:
+exit_put_clock:
+	if (data->put_clock)
+		data->put_clock(ofdev);
 	free_candev(dev);
 exit_dispose_irq:
 	irq_dispose_mapping(irq);
diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index 2f44c567ebd7..4e230e145664 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -1106,11 +1106,13 @@ static void rcar_canfd_handle_global_receive(struct rcar_canfd_global *gpriv, u3
 {
 	struct rcar_canfd_channel *priv = gpriv->ch[ch];
 	u32 ridx = ch + RCANFD_RFFIFO_IDX;
-	u32 sts;
+	u32 sts, cc;
 
 	/* Handle Rx interrupts */
 	sts = rcar_canfd_read(priv->base, RCANFD_RFSTS(ridx));
-	if (likely(sts & RCANFD_RFSTS_RFIF)) {
+	cc = rcar_canfd_read(priv->base, RCANFD_RFCC(ridx));
+	if (likely(sts & RCANFD_RFSTS_RFIF &&
+		   cc & RCANFD_RFCC_RFIE)) {
 		if (napi_schedule_prep(&priv->napi)) {
 			/* Disable Rx FIFO interrupts */
 			rcar_canfd_clear_bit(priv->base,
@@ -1195,11 +1197,9 @@ static void rcar_canfd_handle_channel_tx(struct rcar_canfd_global *gpriv, u32 ch
 
 static irqreturn_t rcar_canfd_channel_tx_interrupt(int irq, void *dev_id)
 {
-	struct rcar_canfd_global *gpriv = dev_id;
-	u32 ch;
+	struct rcar_canfd_channel *priv = dev_id;
 
-	for_each_set_bit(ch, &gpriv->channels_mask, RCANFD_NUM_CHANNELS)
-		rcar_canfd_handle_channel_tx(gpriv, ch);
+	rcar_canfd_handle_channel_tx(priv->gpriv, priv->channel);
 
 	return IRQ_HANDLED;
 }
@@ -1227,11 +1227,9 @@ static void rcar_canfd_handle_channel_err(struct rcar_canfd_global *gpriv, u32 c
 
 static irqreturn_t rcar_canfd_channel_err_interrupt(int irq, void *dev_id)
 {
-	struct rcar_canfd_global *gpriv = dev_id;
-	u32 ch;
+	struct rcar_canfd_channel *priv = dev_id;
 
-	for_each_set_bit(ch, &gpriv->channels_mask, RCANFD_NUM_CHANNELS)
-		rcar_canfd_handle_channel_err(gpriv, ch);
+	rcar_canfd_handle_channel_err(priv->gpriv, priv->channel);
 
 	return IRQ_HANDLED;
 }
@@ -1649,6 +1647,7 @@ static int rcar_canfd_channel_probe(struct rcar_canfd_global *gpriv, u32 ch,
 	priv->ndev = ndev;
 	priv->base = gpriv->base;
 	priv->channel = ch;
+	priv->gpriv = gpriv;
 	priv->can.clock.freq = fcan_freq;
 	dev_info(&pdev->dev, "can_clk rate is %u\n", priv->can.clock.freq);
 
@@ -1677,7 +1676,7 @@ static int rcar_canfd_channel_probe(struct rcar_canfd_global *gpriv, u32 ch,
 		}
 		err = devm_request_irq(&pdev->dev, err_irq,
 				       rcar_canfd_channel_err_interrupt, 0,
-				       irq_name, gpriv);
+				       irq_name, priv);
 		if (err) {
 			dev_err(&pdev->dev, "devm_request_irq CH Err(%d) failed, error %d\n",
 				err_irq, err);
@@ -1691,7 +1690,7 @@ static int rcar_canfd_channel_probe(struct rcar_canfd_global *gpriv, u32 ch,
 		}
 		err = devm_request_irq(&pdev->dev, tx_irq,
 				       rcar_canfd_channel_tx_interrupt, 0,
-				       irq_name, gpriv);
+				       irq_name, priv);
 		if (err) {
 			dev_err(&pdev->dev, "devm_request_irq Tx (%d) failed, error %d\n",
 				tx_irq, err);
@@ -1715,7 +1714,6 @@ static int rcar_canfd_channel_probe(struct rcar_canfd_global *gpriv, u32 ch,
 
 	priv->can.do_set_mode = rcar_canfd_do_set_mode;
 	priv->can.do_get_berr_counter = rcar_canfd_get_berr_counter;
-	priv->gpriv = gpriv;
 	SET_NETDEV_DEV(ndev, &pdev->dev);
 
 	netif_napi_add(ndev, &priv->napi, rcar_canfd_rx_poll,
diff --git a/drivers/net/can/spi/mcp251x.c b/drivers/net/can/spi/mcp251x.c
index baab3adc34bc..f02275f71e4d 100644
--- a/drivers/net/can/spi/mcp251x.c
+++ b/drivers/net/can/spi/mcp251x.c
@@ -1419,11 +1419,14 @@ static int mcp251x_can_probe(struct spi_device *spi)
 
 	ret = mcp251x_gpio_setup(priv);
 	if (ret)
-		goto error_probe;
+		goto out_unregister_candev;
 
 	netdev_info(net, "MCP%x successfully initialized.\n", priv->model);
 	return 0;
 
+out_unregister_candev:
+	unregister_candev(net);
+
 error_probe:
 	destroy_workqueue(priv->wq);
 	priv->wq = NULL;
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
index 45eb7e462ce9..3ff2cd9828d2 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
@@ -1873,7 +1873,7 @@ static int kvaser_usb_hydra_start_chip(struct kvaser_usb_net_priv *priv)
 {
 	int err;
 
-	init_completion(&priv->start_comp);
+	reinit_completion(&priv->start_comp);
 
 	err = kvaser_usb_hydra_send_simple_cmd(priv->dev, CMD_START_CHIP_REQ,
 					       priv->channel);
@@ -1891,7 +1891,7 @@ static int kvaser_usb_hydra_stop_chip(struct kvaser_usb_net_priv *priv)
 {
 	int err;
 
-	init_completion(&priv->stop_comp);
+	reinit_completion(&priv->stop_comp);
 
 	/* Make sure we do not report invalid BUS_OFF from CMD_CHIP_STATE_EVENT
 	 * see comment in kvaser_usb_hydra_update_state()
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
index 4312be05fc5b..7a71097281c2 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
@@ -1324,7 +1324,7 @@ static int kvaser_usb_leaf_start_chip(struct kvaser_usb_net_priv *priv)
 {
 	int err;
 
-	init_completion(&priv->start_comp);
+	reinit_completion(&priv->start_comp);
 
 	err = kvaser_usb_leaf_send_simple_cmd(priv->dev, CMD_START_CHIP,
 					      priv->channel);
@@ -1342,7 +1342,7 @@ static int kvaser_usb_leaf_stop_chip(struct kvaser_usb_net_priv *priv)
 {
 	int err;
 
-	init_completion(&priv->stop_comp);
+	reinit_completion(&priv->stop_comp);
 
 	err = kvaser_usb_leaf_send_simple_cmd(priv->dev, CMD_STOP_CHIP,
 					      priv->channel);
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
index 213769054391..a7166cd1179f 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
@@ -239,6 +239,7 @@ enum xgbe_sfp_speed {
 #define XGBE_SFP_BASE_BR_1GBE_MAX		0x0d
 #define XGBE_SFP_BASE_BR_10GBE_MIN		0x64
 #define XGBE_SFP_BASE_BR_10GBE_MAX		0x68
+#define XGBE_MOLEX_SFP_BASE_BR_10GBE_MAX	0x78
 
 #define XGBE_SFP_BASE_CU_CABLE_LEN		18
 
@@ -284,6 +285,8 @@ struct xgbe_sfp_eeprom {
 #define XGBE_BEL_FUSE_VENDOR	"BEL-FUSE        "
 #define XGBE_BEL_FUSE_PARTNO	"1GBT-SFP06      "
 
+#define XGBE_MOLEX_VENDOR	"Molex Inc.      "
+
 struct xgbe_sfp_ascii {
 	union {
 		char vendor[XGBE_SFP_BASE_VENDOR_NAME_LEN + 1];
@@ -834,7 +837,11 @@ static bool xgbe_phy_sfp_bit_rate(struct xgbe_sfp_eeprom *sfp_eeprom,
 		break;
 	case XGBE_SFP_SPEED_10000:
 		min = XGBE_SFP_BASE_BR_10GBE_MIN;
-		max = XGBE_SFP_BASE_BR_10GBE_MAX;
+		if (memcmp(&sfp_eeprom->base[XGBE_SFP_BASE_VENDOR_NAME],
+			   XGBE_MOLEX_VENDOR, XGBE_SFP_BASE_VENDOR_NAME_LEN) == 0)
+			max = XGBE_MOLEX_SFP_BASE_BR_10GBE_MAX;
+		else
+			max = XGBE_SFP_BASE_BR_10GBE_MAX;
 		break;
 	default:
 		return false;
@@ -1151,7 +1158,10 @@ static void xgbe_phy_sfp_parse_eeprom(struct xgbe_prv_data *pdata)
 	}
 
 	/* Determine the type of SFP */
-	if (sfp_base[XGBE_SFP_BASE_10GBE_CC] & XGBE_SFP_BASE_10GBE_CC_SR)
+	if (phy_data->sfp_cable == XGBE_SFP_CABLE_PASSIVE &&
+	    xgbe_phy_sfp_bit_rate(sfp_eeprom, XGBE_SFP_SPEED_10000))
+		phy_data->sfp_base = XGBE_SFP_BASE_10000_CR;
+	else if (sfp_base[XGBE_SFP_BASE_10GBE_CC] & XGBE_SFP_BASE_10GBE_CC_SR)
 		phy_data->sfp_base = XGBE_SFP_BASE_10000_SR;
 	else if (sfp_base[XGBE_SFP_BASE_10GBE_CC] & XGBE_SFP_BASE_10GBE_CC_LR)
 		phy_data->sfp_base = XGBE_SFP_BASE_10000_LR;
@@ -1167,9 +1177,6 @@ static void xgbe_phy_sfp_parse_eeprom(struct xgbe_prv_data *pdata)
 		phy_data->sfp_base = XGBE_SFP_BASE_1000_CX;
 	else if (sfp_base[XGBE_SFP_BASE_1GBE_CC] & XGBE_SFP_BASE_1GBE_CC_T)
 		phy_data->sfp_base = XGBE_SFP_BASE_1000_T;
-	else if ((phy_data->sfp_cable == XGBE_SFP_CABLE_PASSIVE) &&
-		 xgbe_phy_sfp_bit_rate(sfp_eeprom, XGBE_SFP_SPEED_10000))
-		phy_data->sfp_base = XGBE_SFP_BASE_10000_CR;
 
 	switch (phy_data->sfp_base) {
 	case XGBE_SFP_BASE_1000_T:
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c b/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
index 4a6dfac857ca..7c6e0811f2e6 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
@@ -1451,26 +1451,57 @@ static void aq_check_txsa_expiration(struct aq_nic_s *nic)
 			egress_sa_threshold_expired);
 }
 
+#define AQ_LOCKED_MDO_DEF(mdo)						\
+static int aq_locked_mdo_##mdo(struct macsec_context *ctx)		\
+{									\
+	struct aq_nic_s *nic = netdev_priv(ctx->netdev);		\
+	int ret;							\
+	mutex_lock(&nic->macsec_mutex);					\
+	ret = aq_mdo_##mdo(ctx);					\
+	mutex_unlock(&nic->macsec_mutex);				\
+	return ret;							\
+}
+
+AQ_LOCKED_MDO_DEF(dev_open)
+AQ_LOCKED_MDO_DEF(dev_stop)
+AQ_LOCKED_MDO_DEF(add_secy)
+AQ_LOCKED_MDO_DEF(upd_secy)
+AQ_LOCKED_MDO_DEF(del_secy)
+AQ_LOCKED_MDO_DEF(add_rxsc)
+AQ_LOCKED_MDO_DEF(upd_rxsc)
+AQ_LOCKED_MDO_DEF(del_rxsc)
+AQ_LOCKED_MDO_DEF(add_rxsa)
+AQ_LOCKED_MDO_DEF(upd_rxsa)
+AQ_LOCKED_MDO_DEF(del_rxsa)
+AQ_LOCKED_MDO_DEF(add_txsa)
+AQ_LOCKED_MDO_DEF(upd_txsa)
+AQ_LOCKED_MDO_DEF(del_txsa)
+AQ_LOCKED_MDO_DEF(get_dev_stats)
+AQ_LOCKED_MDO_DEF(get_tx_sc_stats)
+AQ_LOCKED_MDO_DEF(get_tx_sa_stats)
+AQ_LOCKED_MDO_DEF(get_rx_sc_stats)
+AQ_LOCKED_MDO_DEF(get_rx_sa_stats)
+
 const struct macsec_ops aq_macsec_ops = {
-	.mdo_dev_open = aq_mdo_dev_open,
-	.mdo_dev_stop = aq_mdo_dev_stop,
-	.mdo_add_secy = aq_mdo_add_secy,
-	.mdo_upd_secy = aq_mdo_upd_secy,
-	.mdo_del_secy = aq_mdo_del_secy,
-	.mdo_add_rxsc = aq_mdo_add_rxsc,
-	.mdo_upd_rxsc = aq_mdo_upd_rxsc,
-	.mdo_del_rxsc = aq_mdo_del_rxsc,
-	.mdo_add_rxsa = aq_mdo_add_rxsa,
-	.mdo_upd_rxsa = aq_mdo_upd_rxsa,
-	.mdo_del_rxsa = aq_mdo_del_rxsa,
-	.mdo_add_txsa = aq_mdo_add_txsa,
-	.mdo_upd_txsa = aq_mdo_upd_txsa,
-	.mdo_del_txsa = aq_mdo_del_txsa,
-	.mdo_get_dev_stats = aq_mdo_get_dev_stats,
-	.mdo_get_tx_sc_stats = aq_mdo_get_tx_sc_stats,
-	.mdo_get_tx_sa_stats = aq_mdo_get_tx_sa_stats,
-	.mdo_get_rx_sc_stats = aq_mdo_get_rx_sc_stats,
-	.mdo_get_rx_sa_stats = aq_mdo_get_rx_sa_stats,
+	.mdo_dev_open = aq_locked_mdo_dev_open,
+	.mdo_dev_stop = aq_locked_mdo_dev_stop,
+	.mdo_add_secy = aq_locked_mdo_add_secy,
+	.mdo_upd_secy = aq_locked_mdo_upd_secy,
+	.mdo_del_secy = aq_locked_mdo_del_secy,
+	.mdo_add_rxsc = aq_locked_mdo_add_rxsc,
+	.mdo_upd_rxsc = aq_locked_mdo_upd_rxsc,
+	.mdo_del_rxsc = aq_locked_mdo_del_rxsc,
+	.mdo_add_rxsa = aq_locked_mdo_add_rxsa,
+	.mdo_upd_rxsa = aq_locked_mdo_upd_rxsa,
+	.mdo_del_rxsa = aq_locked_mdo_del_rxsa,
+	.mdo_add_txsa = aq_locked_mdo_add_txsa,
+	.mdo_upd_txsa = aq_locked_mdo_upd_txsa,
+	.mdo_del_txsa = aq_locked_mdo_del_txsa,
+	.mdo_get_dev_stats = aq_locked_mdo_get_dev_stats,
+	.mdo_get_tx_sc_stats = aq_locked_mdo_get_tx_sc_stats,
+	.mdo_get_tx_sa_stats = aq_locked_mdo_get_tx_sa_stats,
+	.mdo_get_rx_sc_stats = aq_locked_mdo_get_rx_sc_stats,
+	.mdo_get_rx_sa_stats = aq_locked_mdo_get_rx_sa_stats,
 };
 
 int aq_macsec_init(struct aq_nic_s *nic)
@@ -1492,6 +1523,7 @@ int aq_macsec_init(struct aq_nic_s *nic)
 
 	nic->ndev->features |= NETIF_F_HW_MACSEC;
 	nic->ndev->macsec_ops = &aq_macsec_ops;
+	mutex_init(&nic->macsec_mutex);
 
 	return 0;
 }
@@ -1515,7 +1547,7 @@ int aq_macsec_enable(struct aq_nic_s *nic)
 	if (!nic->macsec_cfg)
 		return 0;
 
-	rtnl_lock();
+	mutex_lock(&nic->macsec_mutex);
 
 	if (nic->aq_fw_ops->send_macsec_req) {
 		struct macsec_cfg_request cfg = { 0 };
@@ -1564,7 +1596,7 @@ int aq_macsec_enable(struct aq_nic_s *nic)
 	ret = aq_apply_macsec_cfg(nic);
 
 unlock:
-	rtnl_unlock();
+	mutex_unlock(&nic->macsec_mutex);
 	return ret;
 }
 
@@ -1576,9 +1608,9 @@ void aq_macsec_work(struct aq_nic_s *nic)
 	if (!netif_carrier_ok(nic->ndev))
 		return;
 
-	rtnl_lock();
+	mutex_lock(&nic->macsec_mutex);
 	aq_check_txsa_expiration(nic);
-	rtnl_unlock();
+	mutex_unlock(&nic->macsec_mutex);
 }
 
 int aq_macsec_rx_sa_cnt(struct aq_nic_s *nic)
@@ -1589,21 +1621,30 @@ int aq_macsec_rx_sa_cnt(struct aq_nic_s *nic)
 	if (!cfg)
 		return 0;
 
+	mutex_lock(&nic->macsec_mutex);
+
 	for (i = 0; i < AQ_MACSEC_MAX_SC; i++) {
 		if (!test_bit(i, &cfg->rxsc_idx_busy))
 			continue;
 		cnt += hweight_long(cfg->aq_rxsc[i].rx_sa_idx_busy);
 	}
 
+	mutex_unlock(&nic->macsec_mutex);
 	return cnt;
 }
 
 int aq_macsec_tx_sc_cnt(struct aq_nic_s *nic)
 {
+	int cnt;
+
 	if (!nic->macsec_cfg)
 		return 0;
 
-	return hweight_long(nic->macsec_cfg->txsc_idx_busy);
+	mutex_lock(&nic->macsec_mutex);
+	cnt = hweight_long(nic->macsec_cfg->txsc_idx_busy);
+	mutex_unlock(&nic->macsec_mutex);
+
+	return cnt;
 }
 
 int aq_macsec_tx_sa_cnt(struct aq_nic_s *nic)
@@ -1614,12 +1655,15 @@ int aq_macsec_tx_sa_cnt(struct aq_nic_s *nic)
 	if (!cfg)
 		return 0;
 
+	mutex_lock(&nic->macsec_mutex);
+
 	for (i = 0; i < AQ_MACSEC_MAX_SC; i++) {
 		if (!test_bit(i, &cfg->txsc_idx_busy))
 			continue;
 		cnt += hweight_long(cfg->aq_txsc[i].tx_sa_idx_busy);
 	}
 
+	mutex_unlock(&nic->macsec_mutex);
 	return cnt;
 }
 
@@ -1691,6 +1735,8 @@ u64 *aq_macsec_get_stats(struct aq_nic_s *nic, u64 *data)
 	if (!cfg)
 		return data;
 
+	mutex_lock(&nic->macsec_mutex);
+
 	aq_macsec_update_stats(nic);
 
 	common_stats = &cfg->stats;
@@ -1773,5 +1819,7 @@ u64 *aq_macsec_get_stats(struct aq_nic_s *nic, u64 *data)
 
 	data += i;
 
+	mutex_unlock(&nic->macsec_mutex);
+
 	return data;
 }
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h b/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
index 1a7148041e3d..b7f7d6f66633 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
@@ -154,6 +154,8 @@ struct aq_nic_s {
 	struct mutex fwreq_mutex;
 #if IS_ENABLED(CONFIG_MACSEC)
 	struct aq_macsec_cfg *macsec_cfg;
+	/* mutex to protect data in macsec_cfg */
+	struct mutex macsec_mutex;
 #endif
 	/* PTP support */
 	struct aq_ptp_s *aq_ptp;
diff --git a/drivers/net/ethernet/broadcom/bcm4908_enet.c b/drivers/net/ethernet/broadcom/bcm4908_enet.c
index 376f81796a29..7e89664943ce 100644
--- a/drivers/net/ethernet/broadcom/bcm4908_enet.c
+++ b/drivers/net/ethernet/broadcom/bcm4908_enet.c
@@ -561,8 +561,6 @@ static int bcm4908_enet_start_xmit(struct sk_buff *skb, struct net_device *netde
 
 	if (++ring->write_idx == ring->length - 1)
 		ring->write_idx = 0;
-	enet->netdev->stats.tx_bytes += skb->len;
-	enet->netdev->stats.tx_packets++;
 
 	return NETDEV_TX_OK;
 }
@@ -646,13 +644,17 @@ static int bcm4908_enet_poll_tx(struct napi_struct *napi, int weight)
 
 		dma_unmap_single(dev, slot->dma_addr, slot->len, DMA_TO_DEVICE);
 		dev_kfree_skb(slot->skb);
+
+		handled++;
 		bytes += slot->len;
+
 		if (++tx_ring->read_idx == tx_ring->length)
 			tx_ring->read_idx = 0;
-
-		handled++;
 	}
 
+	enet->netdev->stats.tx_packets += handled;
+	enet->netdev->stats.tx_bytes += bytes;
+
 	if (handled < weight) {
 		napi_complete_done(napi, handled);
 		bcm4908_enet_dma_ring_intrs_on(enet, tx_ring);
diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
index ae541a9d1eee..4c7f828c69c6 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -1991,6 +1991,9 @@ static int bcm_sysport_open(struct net_device *dev)
 		goto out_clk_disable;
 	}
 
+	/* Indicate that the MAC is responsible for PHY PM */
+	phydev->mac_managed_pm = true;
+
 	/* Reset house keeping link status */
 	priv->old_duplex = -1;
 	priv->old_link = -1;
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 3ca3f9d0fd9b..61efb2350412 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -880,6 +880,7 @@ static int macb_mii_probe(struct net_device *dev)
 
 	bp->phylink_config.dev = &dev->dev;
 	bp->phylink_config.type = PHYLINK_NETDEV;
+	bp->phylink_config.mac_managed_pm = true;
 
 	if (bp->phy_interface == PHY_INTERFACE_MODE_SGMII) {
 		bp->phylink_config.poll_fixed_state = true;
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index c0265a6f10c0..77d765809c1e 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1800,7 +1800,12 @@ static void enetc_setup_rxbdr(struct enetc_hw *hw, struct enetc_bdr *rx_ring)
 	else
 		enetc_rxbdr_wr(hw, idx, ENETC_RBBSR, ENETC_RXB_DMA_SIZE);
 
+	/* Also prepare the consumer index in case page allocation never
+	 * succeeds. In that case, hardware will never advance producer index
+	 * to match consumer index, and will drop all frames.
+	 */
 	enetc_rxbdr_wr(hw, idx, ENETC_RBPIR, 0);
+	enetc_rxbdr_wr(hw, idx, ENETC_RBCIR, 1);
 
 	/* enable Rx ints by setting pkt thr to 1 */
 	enetc_rxbdr_wr(hw, idx, ENETC_RBICR0, ENETC_RBICR0_ICEN | 0x1);
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 67eb9b671244..313ae8112067 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -2336,6 +2336,31 @@ static u32 fec_enet_register_offset[] = {
 	IEEE_R_DROP, IEEE_R_FRAME_OK, IEEE_R_CRC, IEEE_R_ALIGN, IEEE_R_MACERR,
 	IEEE_R_FDXFC, IEEE_R_OCTETS_OK
 };
+/* for i.MX6ul */
+static u32 fec_enet_register_offset_6ul[] = {
+	FEC_IEVENT, FEC_IMASK, FEC_R_DES_ACTIVE_0, FEC_X_DES_ACTIVE_0,
+	FEC_ECNTRL, FEC_MII_DATA, FEC_MII_SPEED, FEC_MIB_CTRLSTAT, FEC_R_CNTRL,
+	FEC_X_CNTRL, FEC_ADDR_LOW, FEC_ADDR_HIGH, FEC_OPD, FEC_TXIC0, FEC_RXIC0,
+	FEC_HASH_TABLE_HIGH, FEC_HASH_TABLE_LOW, FEC_GRP_HASH_TABLE_HIGH,
+	FEC_GRP_HASH_TABLE_LOW, FEC_X_WMRK, FEC_R_DES_START_0,
+	FEC_X_DES_START_0, FEC_R_BUFF_SIZE_0, FEC_R_FIFO_RSFL, FEC_R_FIFO_RSEM,
+	FEC_R_FIFO_RAEM, FEC_R_FIFO_RAFL, FEC_RACC,
+	RMON_T_DROP, RMON_T_PACKETS, RMON_T_BC_PKT, RMON_T_MC_PKT,
+	RMON_T_CRC_ALIGN, RMON_T_UNDERSIZE, RMON_T_OVERSIZE, RMON_T_FRAG,
+	RMON_T_JAB, RMON_T_COL, RMON_T_P64, RMON_T_P65TO127, RMON_T_P128TO255,
+	RMON_T_P256TO511, RMON_T_P512TO1023, RMON_T_P1024TO2047,
+	RMON_T_P_GTE2048, RMON_T_OCTETS,
+	IEEE_T_DROP, IEEE_T_FRAME_OK, IEEE_T_1COL, IEEE_T_MCOL, IEEE_T_DEF,
+	IEEE_T_LCOL, IEEE_T_EXCOL, IEEE_T_MACERR, IEEE_T_CSERR, IEEE_T_SQE,
+	IEEE_T_FDXFC, IEEE_T_OCTETS_OK,
+	RMON_R_PACKETS, RMON_R_BC_PKT, RMON_R_MC_PKT, RMON_R_CRC_ALIGN,
+	RMON_R_UNDERSIZE, RMON_R_OVERSIZE, RMON_R_FRAG, RMON_R_JAB,
+	RMON_R_RESVD_O, RMON_R_P64, RMON_R_P65TO127, RMON_R_P128TO255,
+	RMON_R_P256TO511, RMON_R_P512TO1023, RMON_R_P1024TO2047,
+	RMON_R_P_GTE2048, RMON_R_OCTETS,
+	IEEE_R_DROP, IEEE_R_FRAME_OK, IEEE_R_CRC, IEEE_R_ALIGN, IEEE_R_MACERR,
+	IEEE_R_FDXFC, IEEE_R_OCTETS_OK
+};
 #else
 static __u32 fec_enet_register_version = 1;
 static u32 fec_enet_register_offset[] = {
@@ -2360,7 +2385,24 @@ static void fec_enet_get_regs(struct net_device *ndev,
 	u32 *buf = (u32 *)regbuf;
 	u32 i, off;
 	int ret;
+#if defined(CONFIG_M523x) || defined(CONFIG_M527x) || defined(CONFIG_M528x) || \
+	defined(CONFIG_M520x) || defined(CONFIG_M532x) || defined(CONFIG_ARM) || \
+	defined(CONFIG_ARM64) || defined(CONFIG_COMPILE_TEST)
+	u32 *reg_list;
+	u32 reg_cnt;
 
+	if (!of_machine_is_compatible("fsl,imx6ul")) {
+		reg_list = fec_enet_register_offset;
+		reg_cnt = ARRAY_SIZE(fec_enet_register_offset);
+	} else {
+		reg_list = fec_enet_register_offset_6ul;
+		reg_cnt = ARRAY_SIZE(fec_enet_register_offset_6ul);
+	}
+#else
+	/* coldfire */
+	static u32 *reg_list = fec_enet_register_offset;
+	static const u32 reg_cnt = ARRAY_SIZE(fec_enet_register_offset);
+#endif
 	ret = pm_runtime_resume_and_get(dev);
 	if (ret < 0)
 		return;
@@ -2369,8 +2411,8 @@ static void fec_enet_get_regs(struct net_device *ndev,
 
 	memset(buf, 0, regs->len);
 
-	for (i = 0; i < ARRAY_SIZE(fec_enet_register_offset); i++) {
-		off = fec_enet_register_offset[i];
+	for (i = 0; i < reg_cnt; i++) {
+		off = reg_list[i];
 
 		if ((off == FEC_R_BOUND || off == FEC_R_FSTART) &&
 		    !(fep->quirks & FEC_QUIRK_HAS_FRREG))
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_debugfs.c b/drivers/net/ethernet/huawei/hinic/hinic_debugfs.c
index 19eb839177ec..061952c6c21a 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_debugfs.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_debugfs.c
@@ -85,6 +85,7 @@ static int hinic_dbg_get_func_table(struct hinic_dev *nic_dev, int idx)
 	struct tag_sml_funcfg_tbl *funcfg_table_elem;
 	struct hinic_cmd_lt_rd *read_data;
 	u16 out_size = sizeof(*read_data);
+	int ret = ~0;
 	int err;
 
 	read_data = kzalloc(sizeof(*read_data), GFP_KERNEL);
@@ -111,20 +112,25 @@ static int hinic_dbg_get_func_table(struct hinic_dev *nic_dev, int idx)
 
 	switch (idx) {
 	case VALID:
-		return funcfg_table_elem->dw0.bs.valid;
+		ret = funcfg_table_elem->dw0.bs.valid;
+		break;
 	case RX_MODE:
-		return funcfg_table_elem->dw0.bs.nic_rx_mode;
+		ret = funcfg_table_elem->dw0.bs.nic_rx_mode;
+		break;
 	case MTU:
-		return funcfg_table_elem->dw1.bs.mtu;
+		ret = funcfg_table_elem->dw1.bs.mtu;
+		break;
 	case RQ_DEPTH:
-		return funcfg_table_elem->dw13.bs.cfg_rq_depth;
+		ret = funcfg_table_elem->dw13.bs.cfg_rq_depth;
+		break;
 	case QUEUE_NUM:
-		return funcfg_table_elem->dw13.bs.cfg_q_num;
+		ret = funcfg_table_elem->dw13.bs.cfg_q_num;
+		break;
 	}
 
 	kfree(read_data);
 
-	return ~0;
+	return ret;
 }
 
 static ssize_t hinic_dbg_cmd_read(struct file *filp, char __user *buffer, size_t count,
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c
index a627237f694b..afa816cfcdf4 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c
@@ -929,7 +929,7 @@ int hinic_init_cmdqs(struct hinic_cmdqs *cmdqs, struct hinic_hwif *hwif,
 
 err_set_cmdq_depth:
 	hinic_ceq_unregister_cb(&func_to_io->ceqs, HINIC_CEQ_CMDQ);
-
+	free_cmdq(&cmdqs->cmdq[HINIC_CMDQ_SYNC]);
 err_cmdq_ctxt:
 	hinic_wqs_cmdq_free(&cmdqs->cmdq_pages, cmdqs->saved_wqs,
 			    HINIC_MAX_CMDQ_TYPES);
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
index ca76896d9f1c..8b04d133b3c4 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
@@ -892,7 +892,7 @@ int hinic_set_interrupt_cfg(struct hinic_hwdev *hwdev,
 	if (err)
 		return -EINVAL;
 
-	interrupt_info->lli_credit_cnt = temp_info.lli_timer_cnt;
+	interrupt_info->lli_credit_cnt = temp_info.lli_credit_cnt;
 	interrupt_info->lli_timer_cnt = temp_info.lli_timer_cnt;
 
 	err = hinic_msg_to_mgmt(&pfhwdev->pf_to_mgmt, HINIC_MOD_COMM,
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_sriov.c b/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
index a78c398bf5b2..e81a7b28209b 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
@@ -1180,7 +1180,6 @@ int hinic_vf_func_init(struct hinic_hwdev *hwdev)
 			dev_err(&hwdev->hwif->pdev->dev,
 				"Failed to register VF, err: %d, status: 0x%x, out size: 0x%x\n",
 				err, register_info.status, out_size);
-			hinic_unregister_vf_mbox_cb(hwdev, HINIC_MOD_L2NIC);
 			return -EIO;
 		}
 	} else {
diff --git a/drivers/net/ethernet/ibm/ehea/ehea_main.c b/drivers/net/ethernet/ibm/ehea/ehea_main.c
index d5df131b183c..6c534b92aeed 100644
--- a/drivers/net/ethernet/ibm/ehea/ehea_main.c
+++ b/drivers/net/ethernet/ibm/ehea/ehea_main.c
@@ -2898,6 +2898,7 @@ static struct device *ehea_register_port(struct ehea_port *port,
 	ret = of_device_register(&port->ofdev);
 	if (ret) {
 		pr_err("failed to register device. ret=%d\n", ret);
+		put_device(&port->ofdev.dev);
 		goto out;
 	}
 
diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index 11a17ebfceef..4e3243287805 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -3085,10 +3085,17 @@ static int i40e_get_rss_hash_opts(struct i40e_pf *pf, struct ethtool_rxnfc *cmd)
 
 		if (cmd->flow_type == TCP_V4_FLOW ||
 		    cmd->flow_type == UDP_V4_FLOW) {
-			if (i_set & I40E_L3_SRC_MASK)
-				cmd->data |= RXH_IP_SRC;
-			if (i_set & I40E_L3_DST_MASK)
-				cmd->data |= RXH_IP_DST;
+			if (hw->mac.type == I40E_MAC_X722) {
+				if (i_set & I40E_X722_L3_SRC_MASK)
+					cmd->data |= RXH_IP_SRC;
+				if (i_set & I40E_X722_L3_DST_MASK)
+					cmd->data |= RXH_IP_DST;
+			} else {
+				if (i_set & I40E_L3_SRC_MASK)
+					cmd->data |= RXH_IP_SRC;
+				if (i_set & I40E_L3_DST_MASK)
+					cmd->data |= RXH_IP_DST;
+			}
 		} else if (cmd->flow_type == TCP_V6_FLOW ||
 			  cmd->flow_type == UDP_V6_FLOW) {
 			if (i_set & I40E_L3_V6_SRC_MASK)
@@ -3446,12 +3453,15 @@ static int i40e_get_rxnfc(struct net_device *netdev, struct ethtool_rxnfc *cmd,
 
 /**
  * i40e_get_rss_hash_bits - Read RSS Hash bits from register
+ * @hw: hw structure
  * @nfc: pointer to user request
  * @i_setc: bits currently set
  *
  * Returns value of bits to be set per user request
  **/
-static u64 i40e_get_rss_hash_bits(struct ethtool_rxnfc *nfc, u64 i_setc)
+static u64 i40e_get_rss_hash_bits(struct i40e_hw *hw,
+				  struct ethtool_rxnfc *nfc,
+				  u64 i_setc)
 {
 	u64 i_set = i_setc;
 	u64 src_l3 = 0, dst_l3 = 0;
@@ -3470,8 +3480,13 @@ static u64 i40e_get_rss_hash_bits(struct ethtool_rxnfc *nfc, u64 i_setc)
 		dst_l3 = I40E_L3_V6_DST_MASK;
 	} else if (nfc->flow_type == TCP_V4_FLOW ||
 		  nfc->flow_type == UDP_V4_FLOW) {
-		src_l3 = I40E_L3_SRC_MASK;
-		dst_l3 = I40E_L3_DST_MASK;
+		if (hw->mac.type == I40E_MAC_X722) {
+			src_l3 = I40E_X722_L3_SRC_MASK;
+			dst_l3 = I40E_X722_L3_DST_MASK;
+		} else {
+			src_l3 = I40E_L3_SRC_MASK;
+			dst_l3 = I40E_L3_DST_MASK;
+		}
 	} else {
 		/* Any other flow type are not supported here */
 		return i_set;
@@ -3489,6 +3504,7 @@ static u64 i40e_get_rss_hash_bits(struct ethtool_rxnfc *nfc, u64 i_setc)
 	return i_set;
 }
 
+#define FLOW_PCTYPES_SIZE 64
 /**
  * i40e_set_rss_hash_opt - Enable/Disable flow types for RSS hash
  * @pf: pointer to the physical function struct
@@ -3501,9 +3517,11 @@ static int i40e_set_rss_hash_opt(struct i40e_pf *pf, struct ethtool_rxnfc *nfc)
 	struct i40e_hw *hw = &pf->hw;
 	u64 hena = (u64)i40e_read_rx_ctl(hw, I40E_PFQF_HENA(0)) |
 		   ((u64)i40e_read_rx_ctl(hw, I40E_PFQF_HENA(1)) << 32);
-	u8 flow_pctype = 0;
+	DECLARE_BITMAP(flow_pctypes, FLOW_PCTYPES_SIZE);
 	u64 i_set, i_setc;
 
+	bitmap_zero(flow_pctypes, FLOW_PCTYPES_SIZE);
+
 	if (pf->flags & I40E_FLAG_MFP_ENABLED) {
 		dev_err(&pf->pdev->dev,
 			"Change of RSS hash input set is not supported when MFP mode is enabled\n");
@@ -3519,36 +3537,35 @@ static int i40e_set_rss_hash_opt(struct i40e_pf *pf, struct ethtool_rxnfc *nfc)
 
 	switch (nfc->flow_type) {
 	case TCP_V4_FLOW:
-		flow_pctype = I40E_FILTER_PCTYPE_NONF_IPV4_TCP;
+		set_bit(I40E_FILTER_PCTYPE_NONF_IPV4_TCP, flow_pctypes);
 		if (pf->hw_features & I40E_HW_MULTIPLE_TCP_UDP_RSS_PCTYPE)
-			hena |=
-			  BIT_ULL(I40E_FILTER_PCTYPE_NONF_IPV4_TCP_SYN_NO_ACK);
+			set_bit(I40E_FILTER_PCTYPE_NONF_IPV4_TCP_SYN_NO_ACK,
+				flow_pctypes);
 		break;
 	case TCP_V6_FLOW:
-		flow_pctype = I40E_FILTER_PCTYPE_NONF_IPV6_TCP;
-		if (pf->hw_features & I40E_HW_MULTIPLE_TCP_UDP_RSS_PCTYPE)
-			hena |=
-			  BIT_ULL(I40E_FILTER_PCTYPE_NONF_IPV4_TCP_SYN_NO_ACK);
+		set_bit(I40E_FILTER_PCTYPE_NONF_IPV6_TCP, flow_pctypes);
 		if (pf->hw_features & I40E_HW_MULTIPLE_TCP_UDP_RSS_PCTYPE)
-			hena |=
-			  BIT_ULL(I40E_FILTER_PCTYPE_NONF_IPV6_TCP_SYN_NO_ACK);
+			set_bit(I40E_FILTER_PCTYPE_NONF_IPV6_TCP_SYN_NO_ACK,
+				flow_pctypes);
 		break;
 	case UDP_V4_FLOW:
-		flow_pctype = I40E_FILTER_PCTYPE_NONF_IPV4_UDP;
-		if (pf->hw_features & I40E_HW_MULTIPLE_TCP_UDP_RSS_PCTYPE)
-			hena |=
-			  BIT_ULL(I40E_FILTER_PCTYPE_NONF_UNICAST_IPV4_UDP) |
-			  BIT_ULL(I40E_FILTER_PCTYPE_NONF_MULTICAST_IPV4_UDP);
-
+		set_bit(I40E_FILTER_PCTYPE_NONF_IPV4_UDP, flow_pctypes);
+		if (pf->hw_features & I40E_HW_MULTIPLE_TCP_UDP_RSS_PCTYPE) {
+			set_bit(I40E_FILTER_PCTYPE_NONF_UNICAST_IPV4_UDP,
+				flow_pctypes);
+			set_bit(I40E_FILTER_PCTYPE_NONF_MULTICAST_IPV4_UDP,
+				flow_pctypes);
+		}
 		hena |= BIT_ULL(I40E_FILTER_PCTYPE_FRAG_IPV4);
 		break;
 	case UDP_V6_FLOW:
-		flow_pctype = I40E_FILTER_PCTYPE_NONF_IPV6_UDP;
-		if (pf->hw_features & I40E_HW_MULTIPLE_TCP_UDP_RSS_PCTYPE)
-			hena |=
-			  BIT_ULL(I40E_FILTER_PCTYPE_NONF_UNICAST_IPV6_UDP) |
-			  BIT_ULL(I40E_FILTER_PCTYPE_NONF_MULTICAST_IPV6_UDP);
-
+		set_bit(I40E_FILTER_PCTYPE_NONF_IPV6_UDP, flow_pctypes);
+		if (pf->hw_features & I40E_HW_MULTIPLE_TCP_UDP_RSS_PCTYPE) {
+			set_bit(I40E_FILTER_PCTYPE_NONF_UNICAST_IPV6_UDP,
+				flow_pctypes);
+			set_bit(I40E_FILTER_PCTYPE_NONF_MULTICAST_IPV6_UDP,
+				flow_pctypes);
+		}
 		hena |= BIT_ULL(I40E_FILTER_PCTYPE_FRAG_IPV6);
 		break;
 	case AH_ESP_V4_FLOW:
@@ -3581,17 +3598,20 @@ static int i40e_set_rss_hash_opt(struct i40e_pf *pf, struct ethtool_rxnfc *nfc)
 		return -EINVAL;
 	}
 
-	if (flow_pctype) {
-		i_setc = (u64)i40e_read_rx_ctl(hw, I40E_GLQF_HASH_INSET(0,
-					       flow_pctype)) |
-			((u64)i40e_read_rx_ctl(hw, I40E_GLQF_HASH_INSET(1,
-					       flow_pctype)) << 32);
-		i_set = i40e_get_rss_hash_bits(nfc, i_setc);
-		i40e_write_rx_ctl(hw, I40E_GLQF_HASH_INSET(0, flow_pctype),
-				  (u32)i_set);
-		i40e_write_rx_ctl(hw, I40E_GLQF_HASH_INSET(1, flow_pctype),
-				  (u32)(i_set >> 32));
-		hena |= BIT_ULL(flow_pctype);
+	if (bitmap_weight(flow_pctypes, FLOW_PCTYPES_SIZE)) {
+		u8 flow_id;
+
+		for_each_set_bit(flow_id, flow_pctypes, FLOW_PCTYPES_SIZE) {
+			i_setc = (u64)i40e_read_rx_ctl(hw, I40E_GLQF_HASH_INSET(0, flow_id)) |
+				 ((u64)i40e_read_rx_ctl(hw, I40E_GLQF_HASH_INSET(1, flow_id)) << 32);
+			i_set = i40e_get_rss_hash_bits(&pf->hw, nfc, i_setc);
+
+			i40e_write_rx_ctl(hw, I40E_GLQF_HASH_INSET(0, flow_id),
+					  (u32)i_set);
+			i40e_write_rx_ctl(hw, I40E_GLQF_HASH_INSET(1, flow_id),
+					  (u32)(i_set >> 32));
+			hena |= BIT_ULL(flow_id);
+		}
 	}
 
 	i40e_write_rx_ctl(hw, I40E_PFQF_HENA(0), (u32)hena);
diff --git a/drivers/net/ethernet/intel/i40e/i40e_type.h b/drivers/net/ethernet/intel/i40e/i40e_type.h
index 7b3f30beb757..388c3d36d96a 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_type.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_type.h
@@ -1404,6 +1404,10 @@ struct i40e_lldp_variables {
 #define I40E_PFQF_CTL_0_HASHLUTSIZE_512	0x00010000
 
 /* INPUT SET MASK for RSS, flow director, and flexible payload */
+#define I40E_X722_L3_SRC_SHIFT		49
+#define I40E_X722_L3_SRC_MASK		(0x3ULL << I40E_X722_L3_SRC_SHIFT)
+#define I40E_X722_L3_DST_SHIFT		41
+#define I40E_X722_L3_DST_MASK		(0x3ULL << I40E_X722_L3_DST_SHIFT)
 #define I40E_L3_SRC_SHIFT		47
 #define I40E_L3_SRC_MASK		(0x3ULL << I40E_L3_SRC_SHIFT)
 #define I40E_L3_V6_SRC_SHIFT		43
diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index c078fbaf19fd..8f350792e823 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -1536,10 +1536,12 @@ bool i40e_reset_vf(struct i40e_vf *vf, bool flr)
 	if (test_bit(__I40E_VF_RESETS_DISABLED, pf->state))
 		return true;
 
-	/* If the VFs have been disabled, this means something else is
-	 * resetting the VF, so we shouldn't continue.
-	 */
-	if (test_and_set_bit(__I40E_VF_DISABLE, pf->state))
+	/* Bail out if VFs are disabled. */
+	if (test_bit(__I40E_VF_DISABLE, pf->state))
+		return true;
+
+	/* If VF is being reset already we don't need to continue. */
+	if (test_and_set_bit(I40E_VF_STATE_RESETTING, &vf->vf_states))
 		return true;
 
 	i40e_trigger_vf_reset(vf, flr);
@@ -1576,7 +1578,7 @@ bool i40e_reset_vf(struct i40e_vf *vf, bool flr)
 	i40e_cleanup_reset_vf(vf);
 
 	i40e_flush(hw);
-	clear_bit(__I40E_VF_DISABLE, pf->state);
+	clear_bit(I40E_VF_STATE_RESETTING, &vf->vf_states);
 
 	return true;
 }
@@ -1609,8 +1611,12 @@ bool i40e_reset_all_vfs(struct i40e_pf *pf, bool flr)
 		return false;
 
 	/* Begin reset on all VFs at once */
-	for (v = 0; v < pf->num_alloc_vfs; v++)
-		i40e_trigger_vf_reset(&pf->vf[v], flr);
+	for (v = 0; v < pf->num_alloc_vfs; v++) {
+		vf = &pf->vf[v];
+		/* If VF is being reset no need to trigger reset again */
+		if (!test_bit(I40E_VF_STATE_RESETTING, &vf->vf_states))
+			i40e_trigger_vf_reset(&pf->vf[v], flr);
+	}
 
 	/* HW requires some time to make sure it can flush the FIFO for a VF
 	 * when it resets it. Poll the VPGEN_VFRSTAT register for each VF in
@@ -1626,9 +1632,11 @@ bool i40e_reset_all_vfs(struct i40e_pf *pf, bool flr)
 		 */
 		while (v < pf->num_alloc_vfs) {
 			vf = &pf->vf[v];
-			reg = rd32(hw, I40E_VPGEN_VFRSTAT(vf->vf_id));
-			if (!(reg & I40E_VPGEN_VFRSTAT_VFRD_MASK))
-				break;
+			if (!test_bit(I40E_VF_STATE_RESETTING, &vf->vf_states)) {
+				reg = rd32(hw, I40E_VPGEN_VFRSTAT(vf->vf_id));
+				if (!(reg & I40E_VPGEN_VFRSTAT_VFRD_MASK))
+					break;
+			}
 
 			/* If the current VF has finished resetting, move on
 			 * to the next VF in sequence.
@@ -1656,6 +1664,10 @@ bool i40e_reset_all_vfs(struct i40e_pf *pf, bool flr)
 		if (pf->vf[v].lan_vsi_idx == 0)
 			continue;
 
+		/* If VF is reset in another thread just continue */
+		if (test_bit(I40E_VF_STATE_RESETTING, &vf->vf_states))
+			continue;
+
 		i40e_vsi_stop_rings_no_wait(pf->vsi[pf->vf[v].lan_vsi_idx]);
 	}
 
@@ -1667,6 +1679,10 @@ bool i40e_reset_all_vfs(struct i40e_pf *pf, bool flr)
 		if (pf->vf[v].lan_vsi_idx == 0)
 			continue;
 
+		/* If VF is reset in another thread just continue */
+		if (test_bit(I40E_VF_STATE_RESETTING, &vf->vf_states))
+			continue;
+
 		i40e_vsi_wait_queues_disabled(pf->vsi[pf->vf[v].lan_vsi_idx]);
 	}
 
@@ -1676,8 +1692,13 @@ bool i40e_reset_all_vfs(struct i40e_pf *pf, bool flr)
 	mdelay(50);
 
 	/* Finish the reset on each VF */
-	for (v = 0; v < pf->num_alloc_vfs; v++)
+	for (v = 0; v < pf->num_alloc_vfs; v++) {
+		/* If VF is reset in another thread just continue */
+		if (test_bit(I40E_VF_STATE_RESETTING, &vf->vf_states))
+			continue;
+
 		i40e_cleanup_reset_vf(&pf->vf[v]);
+	}
 
 	i40e_flush(hw);
 	clear_bit(__I40E_VF_DISABLE, pf->state);
diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h
index a554d0a0b09b..358bbdb58795 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h
@@ -39,6 +39,7 @@ enum i40e_vf_states {
 	I40E_VF_STATE_MC_PROMISC,
 	I40E_VF_STATE_UC_PROMISC,
 	I40E_VF_STATE_PRE_ENABLE,
+	I40E_VF_STATE_RESETTING
 };
 
 /* VF capabilities */
diff --git a/drivers/net/ethernet/lantiq_etop.c b/drivers/net/ethernet/lantiq_etop.c
index 62f8c5212182..057d655d1769 100644
--- a/drivers/net/ethernet/lantiq_etop.c
+++ b/drivers/net/ethernet/lantiq_etop.c
@@ -466,7 +466,6 @@ ltq_etop_tx(struct sk_buff *skb, struct net_device *dev)
 	len = skb->len < ETH_ZLEN ? ETH_ZLEN : skb->len;
 
 	if ((desc->ctl & (LTQ_DMA_OWN | LTQ_DMA_C)) || ch->skb[ch->dma.desc]) {
-		dev_kfree_skb_any(skb);
 		netdev_err(dev, "tx ring full\n");
 		netif_tx_stop_queue(txq);
 		return NETDEV_TX_BUSY;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index e06a6104e91f..8a3100f32d3b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -1865,7 +1865,7 @@ void mlx5_cmd_init_async_ctx(struct mlx5_core_dev *dev,
 	ctx->dev = dev;
 	/* Starts at 1 to avoid doing wake_up if we are not cleaning up */
 	atomic_set(&ctx->num_inflight, 1);
-	init_waitqueue_head(&ctx->wait);
+	init_completion(&ctx->inflight_done);
 }
 EXPORT_SYMBOL(mlx5_cmd_init_async_ctx);
 
@@ -1879,8 +1879,8 @@ EXPORT_SYMBOL(mlx5_cmd_init_async_ctx);
  */
 void mlx5_cmd_cleanup_async_ctx(struct mlx5_async_ctx *ctx)
 {
-	atomic_dec(&ctx->num_inflight);
-	wait_event(ctx->wait, atomic_read(&ctx->num_inflight) == 0);
+	if (!atomic_dec_and_test(&ctx->num_inflight))
+		wait_for_completion(&ctx->inflight_done);
 }
 EXPORT_SYMBOL(mlx5_cmd_cleanup_async_ctx);
 
@@ -1891,7 +1891,7 @@ static void mlx5_cmd_exec_cb_handler(int status, void *_work)
 
 	work->user_callback(status, work);
 	if (atomic_dec_and_test(&ctx->num_inflight))
-		wake_up(&ctx->wait);
+		complete(&ctx->inflight_done);
 }
 
 int mlx5_cmd_exec_cb(struct mlx5_async_ctx *ctx, void *in, int in_size,
@@ -1907,7 +1907,7 @@ int mlx5_cmd_exec_cb(struct mlx5_async_ctx *ctx, void *in, int in_size,
 	ret = cmd_exec(ctx->dev, in, in_size, out, out_size,
 		       mlx5_cmd_exec_cb_handler, work, false);
 	if (ret && atomic_dec_and_test(&ctx->num_inflight))
-		wake_up(&ctx->wait);
+		complete(&ctx->inflight_done);
 
 	return ret;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h
index a71a32e00ebb..dc7c57e6de77 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h
@@ -6,6 +6,7 @@
 
 #include "en.h"
 #include "en_stats.h"
+#include "en/txrx.h"
 #include <linux/ptp_classify.h>
 
 #define MLX5E_PTP_CHANNEL_IX 0
@@ -67,6 +68,14 @@ static inline bool mlx5e_use_ptpsq(struct sk_buff *skb)
 		fk.ports.dst == htons(PTP_EV_PORT));
 }
 
+static inline bool mlx5e_ptpsq_fifo_has_room(struct mlx5e_txqsq *sq)
+{
+	if (!sq->ptpsq)
+		return true;
+
+	return mlx5e_skb_fifo_has_room(&sq->ptpsq->skb_fifo);
+}
+
 int mlx5e_ptp_open(struct mlx5e_priv *priv, struct mlx5e_params *params,
 		   u8 lag_port, struct mlx5e_ptp **cp);
 void mlx5e_ptp_close(struct mlx5e_ptp *c);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index 055c3bc23733..f5c872043bcb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -73,6 +73,12 @@ netdev_tx_t mlx5e_xmit(struct sk_buff *skb, struct net_device *dev);
 bool mlx5e_poll_tx_cq(struct mlx5e_cq *cq, int napi_budget);
 void mlx5e_free_txqsq_descs(struct mlx5e_txqsq *sq);
 
+static inline bool
+mlx5e_skb_fifo_has_room(struct mlx5e_skb_fifo *fifo)
+{
+	return (*fifo->pc - *fifo->cc) < fifo->mask;
+}
+
 static inline bool
 mlx5e_wqc_has_room_for(struct mlx5_wq_cyc *wq, u16 cc, u16 pc, u16 n)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 7cab08a2f715..05882d1a4407 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -113,7 +113,6 @@ static bool mlx5e_ipsec_update_esn_state(struct mlx5e_ipsec_sa_entry *sa_entry)
 	struct xfrm_replay_state_esn *replay_esn;
 	u32 seq_bottom = 0;
 	u8 overlap;
-	u32 *esn;
 
 	if (!(sa_entry->x->props.flags & XFRM_STATE_ESN)) {
 		sa_entry->esn_state.trigger = 0;
@@ -128,11 +127,9 @@ static bool mlx5e_ipsec_update_esn_state(struct mlx5e_ipsec_sa_entry *sa_entry)
 
 	sa_entry->esn_state.esn = xfrm_replay_seqhi(sa_entry->x,
 						    htonl(seq_bottom));
-	esn = &sa_entry->esn_state.esn;
 
 	sa_entry->esn_state.trigger = 1;
 	if (unlikely(overlap && seq_bottom < MLX5E_IPSEC_ESN_SCOPE_MID)) {
-		++(*esn);
 		sa_entry->esn_state.overlap = 0;
 		return true;
 	} else if (unlikely(!overlap &&
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index 1544d4c2c636..e18fa5ae0fd8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -479,6 +479,11 @@ mlx5e_txwqe_complete(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 	if (unlikely(sq->ptpsq)) {
 		mlx5e_skb_cb_hwtstamp_init(skb);
 		mlx5e_skb_fifo_push(&sq->ptpsq->skb_fifo, skb);
+		if (!netif_tx_queue_stopped(sq->txq) &&
+		    !mlx5e_skb_fifo_has_room(&sq->ptpsq->skb_fifo)) {
+			netif_tx_stop_queue(sq->txq);
+			sq->stats->stopped++;
+		}
 		skb_get(skb);
 	}
 
@@ -906,6 +911,7 @@ bool mlx5e_poll_tx_cq(struct mlx5e_cq *cq, int napi_budget)
 
 	if (netif_tx_queue_stopped(sq->txq) &&
 	    mlx5e_wqc_has_room_for(&sq->wq, sq->cc, sq->pc, sq->stop_room) &&
+	    mlx5e_ptpsq_fifo_has_room(sq) &&
 	    !test_bit(MLX5E_SQ_STATE_RECOVERING, &sq->state)) {
 		netif_tx_wake_queue(sq->txq);
 		stats->wake++;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/mpfs.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/mpfs.c
index 839a01da110f..8ff16318e32d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/mpfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/mpfs.c
@@ -122,7 +122,7 @@ void mlx5_mpfs_cleanup(struct mlx5_core_dev *dev)
 {
 	struct mlx5_mpfs *mpfs = dev->priv.mpfs;
 
-	if (!MLX5_ESWITCH_MANAGER(dev))
+	if (!mpfs)
 		return;
 
 	WARN_ON(!hlist_empty(mpfs->hash));
@@ -137,7 +137,7 @@ int mlx5_mpfs_add_mac(struct mlx5_core_dev *dev, u8 *mac)
 	int err = 0;
 	u32 index;
 
-	if (!MLX5_ESWITCH_MANAGER(dev))
+	if (!mpfs)
 		return 0;
 
 	mutex_lock(&mpfs->lock);
@@ -185,7 +185,7 @@ int mlx5_mpfs_del_mac(struct mlx5_core_dev *dev, u8 *mac)
 	int err = 0;
 	u32 index;
 
-	if (!MLX5_ESWITCH_MANAGER(dev))
+	if (!mpfs)
 		return 0;
 
 	mutex_lock(&mpfs->lock);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 740065e21181..d092261e96c3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1576,12 +1576,28 @@ static void remove_one(struct pci_dev *pdev)
 	mlx5_devlink_free(devlink);
 }
 
+#define mlx5_pci_trace(dev, fmt, ...) ({ \
+	struct mlx5_core_dev *__dev = (dev); \
+	mlx5_core_info(__dev, "%s Device state = %d health sensors: %d pci_status: %d. " fmt, \
+		       __func__, __dev->state, mlx5_health_check_fatal_sensors(__dev), \
+		       __dev->pci_status, ##__VA_ARGS__); \
+})
+
+static const char *result2str(enum pci_ers_result result)
+{
+	return  result == PCI_ERS_RESULT_NEED_RESET ? "need reset" :
+		result == PCI_ERS_RESULT_DISCONNECT ? "disconnect" :
+		result == PCI_ERS_RESULT_RECOVERED  ? "recovered" :
+		"unknown";
+}
+
 static pci_ers_result_t mlx5_pci_err_detected(struct pci_dev *pdev,
 					      pci_channel_state_t state)
 {
 	struct mlx5_core_dev *dev = pci_get_drvdata(pdev);
+	enum pci_ers_result res;
 
-	mlx5_core_info(dev, "%s was called\n", __func__);
+	mlx5_pci_trace(dev, "Enter, pci channel state = %d\n", state);
 
 	mlx5_enter_error_state(dev, false);
 	mlx5_error_sw_reset(dev);
@@ -1589,8 +1605,11 @@ static pci_ers_result_t mlx5_pci_err_detected(struct pci_dev *pdev,
 	mlx5_drain_health_wq(dev);
 	mlx5_pci_disable_device(dev);
 
-	return state == pci_channel_io_perm_failure ?
+	res = state == pci_channel_io_perm_failure ?
 		PCI_ERS_RESULT_DISCONNECT : PCI_ERS_RESULT_NEED_RESET;
+
+	mlx5_pci_trace(dev, "Exit, result = %d, %s\n",  res, result2str(res));
+	return res;
 }
 
 /* wait for the device to show vital signs by waiting
@@ -1624,28 +1643,34 @@ static int wait_vital(struct pci_dev *pdev)
 
 static pci_ers_result_t mlx5_pci_slot_reset(struct pci_dev *pdev)
 {
+	enum pci_ers_result res = PCI_ERS_RESULT_DISCONNECT;
 	struct mlx5_core_dev *dev = pci_get_drvdata(pdev);
 	int err;
 
-	mlx5_core_info(dev, "%s was called\n", __func__);
+	mlx5_pci_trace(dev, "Enter\n");
 
 	err = mlx5_pci_enable_device(dev);
 	if (err) {
 		mlx5_core_err(dev, "%s: mlx5_pci_enable_device failed with error code: %d\n",
 			      __func__, err);
-		return PCI_ERS_RESULT_DISCONNECT;
+		goto out;
 	}
 
 	pci_set_master(pdev);
 	pci_restore_state(pdev);
 	pci_save_state(pdev);
 
-	if (wait_vital(pdev)) {
-		mlx5_core_err(dev, "%s: wait_vital timed out\n", __func__);
-		return PCI_ERS_RESULT_DISCONNECT;
+	err = wait_vital(pdev);
+	if (err) {
+		mlx5_core_err(dev, "%s: wait vital failed with error code: %d\n",
+			      __func__, err);
+		goto out;
 	}
 
-	return PCI_ERS_RESULT_RECOVERED;
+	res = PCI_ERS_RESULT_RECOVERED;
+out:
+	mlx5_pci_trace(dev, "Exit, err = %d, result = %d, %s\n", err, res, result2str(res));
+	return res;
 }
 
 static void mlx5_pci_resume(struct pci_dev *pdev)
@@ -1653,14 +1678,16 @@ static void mlx5_pci_resume(struct pci_dev *pdev)
 	struct mlx5_core_dev *dev = pci_get_drvdata(pdev);
 	int err;
 
-	mlx5_core_info(dev, "%s was called\n", __func__);
+	mlx5_pci_trace(dev, "Enter, loading driver..\n");
 
 	err = mlx5_load_one(dev);
-	if (err)
-		mlx5_core_err(dev, "%s: mlx5_load_one failed with error code: %d\n",
-			      __func__, err);
-	else
-		mlx5_core_info(dev, "%s: device recovered\n", __func__);
+
+	if (!err)
+		devlink_health_reporter_state_update(dev->priv.health.fw_fatal_reporter,
+						     DEVLINK_HEALTH_REPORTER_STATE_HEALTHY);
+
+	mlx5_pci_trace(dev, "Done, err = %d, device %s\n", err,
+		       !err ? "recovered" : "Failed");
 }
 
 static const struct pci_error_handlers mlx5_err_handler = {
diff --git a/drivers/net/ethernet/micrel/ksz884x.c b/drivers/net/ethernet/micrel/ksz884x.c
index a0ee155f9f51..f56bcd3e36d2 100644
--- a/drivers/net/ethernet/micrel/ksz884x.c
+++ b/drivers/net/ethernet/micrel/ksz884x.c
@@ -6848,7 +6848,7 @@ static int pcidev_init(struct pci_dev *pdev, const struct pci_device_id *id)
 	char banner[sizeof(version)];
 	struct ksz_switch *sw = NULL;
 
-	result = pci_enable_device(pdev);
+	result = pcim_enable_device(pdev);
 	if (result)
 		return result;
 
diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index 1f46af136aa8..f0451911ab8f 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -1964,11 +1964,13 @@ static int netsec_register_mdio(struct netsec_priv *priv, u32 phy_addr)
 			ret = PTR_ERR(priv->phydev);
 			dev_err(priv->dev, "get_phy_device err(%d)\n", ret);
 			priv->phydev = NULL;
+			mdiobus_unregister(bus);
 			return -ENODEV;
 		}
 
 		ret = phy_device_register(priv->phydev);
 		if (ret) {
+			phy_device_free(priv->phydev);
 			mdiobus_unregister(bus);
 			dev_err(priv->dev,
 				"phy_device_register err(%d)\n", ret);
diff --git a/drivers/net/ethernet/socionext/sni_ave.c b/drivers/net/ethernet/socionext/sni_ave.c
index ae31ed93aaf0..57dc9680ad50 100644
--- a/drivers/net/ethernet/socionext/sni_ave.c
+++ b/drivers/net/ethernet/socionext/sni_ave.c
@@ -1229,6 +1229,8 @@ static int ave_init(struct net_device *ndev)
 
 	phy_support_asym_pause(phydev);
 
+	phydev->mac_managed_pm = true;
+
 	phy_attached_info(phydev);
 
 	return 0;
@@ -1758,6 +1760,10 @@ static int ave_resume(struct device *dev)
 
 	ave_global_reset(ndev);
 
+	ret = phy_init_hw(ndev->phydev);
+	if (ret)
+		return ret;
+
 	ave_ethtool_get_wol(ndev, &wol);
 	wol.wolopts = priv->wolopts;
 	__ave_ethtool_set_wol(ndev, &wol);
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 54313bd57797..94490dfae656 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -229,8 +229,10 @@ static int nsim_dev_debugfs_init(struct nsim_dev *nsim_dev)
 	if (IS_ERR(nsim_dev->ddir))
 		return PTR_ERR(nsim_dev->ddir);
 	nsim_dev->ports_ddir = debugfs_create_dir("ports", nsim_dev->ddir);
-	if (IS_ERR(nsim_dev->ports_ddir))
-		return PTR_ERR(nsim_dev->ports_ddir);
+	if (IS_ERR(nsim_dev->ports_ddir)) {
+		err = PTR_ERR(nsim_dev->ports_ddir);
+		goto err_ddir;
+	}
 	debugfs_create_bool("fw_update_status", 0600, nsim_dev->ddir,
 			    &nsim_dev->fw_update_status);
 	debugfs_create_u32("fw_update_overwrite_mask", 0600, nsim_dev->ddir,
@@ -267,7 +269,7 @@ static int nsim_dev_debugfs_init(struct nsim_dev *nsim_dev)
 	nsim_dev->nodes_ddir = debugfs_create_dir("rate_nodes", nsim_dev->ddir);
 	if (IS_ERR(nsim_dev->nodes_ddir)) {
 		err = PTR_ERR(nsim_dev->nodes_ddir);
-		goto err_out;
+		goto err_ports_ddir;
 	}
 	debugfs_create_bool("fail_trap_drop_counter_get", 0600,
 			    nsim_dev->ddir,
@@ -275,8 +277,9 @@ static int nsim_dev_debugfs_init(struct nsim_dev *nsim_dev)
 	nsim_udp_tunnels_debugfs_create(nsim_dev);
 	return 0;
 
-err_out:
+err_ports_ddir:
 	debugfs_remove_recursive(nsim_dev->ports_ddir);
+err_ddir:
 	debugfs_remove_recursive(nsim_dev->ddir);
 	return err;
 }
diff --git a/drivers/nfc/virtual_ncidev.c b/drivers/nfc/virtual_ncidev.c
index 221fa3bb8705..6317e8505aaa 100644
--- a/drivers/nfc/virtual_ncidev.c
+++ b/drivers/nfc/virtual_ncidev.c
@@ -54,16 +54,19 @@ static int virtual_nci_send(struct nci_dev *ndev, struct sk_buff *skb)
 	mutex_lock(&nci_mutex);
 	if (state != virtual_ncidev_enabled) {
 		mutex_unlock(&nci_mutex);
+		kfree_skb(skb);
 		return 0;
 	}
 
 	if (send_buff) {
 		mutex_unlock(&nci_mutex);
+		kfree_skb(skb);
 		return -1;
 	}
 	send_buff = skb_copy(skb, GFP_KERNEL);
 	mutex_unlock(&nci_mutex);
 	wake_up_interruptible(&wq);
+	consume_skb(skb);
 
 	return 0;
 }
diff --git a/drivers/pinctrl/pinctrl-ingenic.c b/drivers/pinctrl/pinctrl-ingenic.c
index fa6becca1788..c973123e6de9 100644
--- a/drivers/pinctrl/pinctrl-ingenic.c
+++ b/drivers/pinctrl/pinctrl-ingenic.c
@@ -643,7 +643,7 @@ static u8 jz4755_lcd_24bit_funcs[] = { 1, 1, 1, 1, 0, 0, };
 static const struct group_desc jz4755_groups[] = {
 	INGENIC_PIN_GROUP("uart0-data", jz4755_uart0_data, 0),
 	INGENIC_PIN_GROUP("uart0-hwflow", jz4755_uart0_hwflow, 0),
-	INGENIC_PIN_GROUP("uart1-data", jz4755_uart1_data, 0),
+	INGENIC_PIN_GROUP("uart1-data", jz4755_uart1_data, 1),
 	INGENIC_PIN_GROUP("uart2-data", jz4755_uart2_data, 1),
 	INGENIC_PIN_GROUP("ssi-dt-b", jz4755_ssi_dt_b, 0),
 	INGENIC_PIN_GROUP("ssi-dt-f", jz4755_ssi_dt_f, 0),
@@ -697,7 +697,7 @@ static const char *jz4755_ssi_groups[] = {
 	"ssi-ce1-b", "ssi-ce1-f",
 };
 static const char *jz4755_mmc0_groups[] = { "mmc0-1bit", "mmc0-4bit", };
-static const char *jz4755_mmc1_groups[] = { "mmc0-1bit", "mmc0-4bit", };
+static const char *jz4755_mmc1_groups[] = { "mmc1-1bit", "mmc1-4bit", };
 static const char *jz4755_i2c_groups[] = { "i2c-data", };
 static const char *jz4755_cim_groups[] = { "cim-data", };
 static const char *jz4755_lcd_groups[] = {
diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index f3bcb56e9ef2..b2508a00bafd 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -920,10 +920,6 @@ struct lpfc_hba {
 		(struct lpfc_vport *vport,
 		 struct lpfc_io_buf *lpfc_cmd,
 		 uint8_t tmo);
-	int (*lpfc_scsi_prep_task_mgmt_cmd)
-		(struct lpfc_vport *vport,
-		 struct lpfc_io_buf *lpfc_cmd,
-		 u64 lun, u8 task_mgmt_cmd);
 
 	/* IOCB interface function jump table entries */
 	int (*__lpfc_sli_issue_iocb)
@@ -1807,39 +1803,3 @@ static inline int lpfc_is_vmid_enabled(struct lpfc_hba *phba)
 {
 	return phba->cfg_vmid_app_header || phba->cfg_vmid_priority_tagging;
 }
-
-static inline
-u8 get_job_ulpstatus(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq)
-{
-	if (phba->sli_rev == LPFC_SLI_REV4)
-		return bf_get(lpfc_wcqe_c_status, &iocbq->wcqe_cmpl);
-	else
-		return iocbq->iocb.ulpStatus;
-}
-
-static inline
-u32 get_job_word4(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq)
-{
-	if (phba->sli_rev == LPFC_SLI_REV4)
-		return iocbq->wcqe_cmpl.parameter;
-	else
-		return iocbq->iocb.un.ulpWord[4];
-}
-
-static inline
-u8 get_job_cmnd(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq)
-{
-	if (phba->sli_rev == LPFC_SLI_REV4)
-		return bf_get(wqe_cmnd, &iocbq->wqe.generic.wqe_com);
-	else
-		return iocbq->iocb.ulpCommand;
-}
-
-static inline
-u16 get_job_ulpcontext(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq)
-{
-	if (phba->sli_rev == LPFC_SLI_REV4)
-		return bf_get(wqe_ctxt_tag, &iocbq->wqe.generic.wqe_com);
-	else
-		return iocbq->iocb.ulpContext;
-}
diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 6688a575904f..fdf08cb57207 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -325,7 +325,7 @@ lpfc_bsg_send_mgmt_cmd_cmp(struct lpfc_hba *phba,
 
 	/* Close the timeout handler abort window */
 	spin_lock_irqsave(&phba->hbalock, flags);
-	cmdiocbq->cmd_flag &= ~LPFC_IO_CMD_OUTSTANDING;
+	cmdiocbq->iocb_flag &= ~LPFC_IO_CMD_OUTSTANDING;
 	spin_unlock_irqrestore(&phba->hbalock, flags);
 
 	iocb = &dd_data->context_un.iocb;
@@ -481,11 +481,11 @@ lpfc_bsg_send_mgmt_cmd(struct bsg_job *job)
 	cmd->ulpOwner = OWN_CHIP;
 	cmdiocbq->vport = phba->pport;
 	cmdiocbq->context3 = bmp;
-	cmdiocbq->cmd_flag |= LPFC_IO_LIBDFC;
+	cmdiocbq->iocb_flag |= LPFC_IO_LIBDFC;
 	timeout = phba->fc_ratov * 2;
 	cmd->ulpTimeout = timeout;
 
-	cmdiocbq->cmd_cmpl = lpfc_bsg_send_mgmt_cmd_cmp;
+	cmdiocbq->iocb_cmpl = lpfc_bsg_send_mgmt_cmd_cmp;
 	cmdiocbq->context1 = dd_data;
 	cmdiocbq->context2 = cmp;
 	cmdiocbq->context3 = bmp;
@@ -516,9 +516,9 @@ lpfc_bsg_send_mgmt_cmd(struct bsg_job *job)
 	if (iocb_stat == IOCB_SUCCESS) {
 		spin_lock_irqsave(&phba->hbalock, flags);
 		/* make sure the I/O had not been completed yet */
-		if (cmdiocbq->cmd_flag & LPFC_IO_LIBDFC) {
+		if (cmdiocbq->iocb_flag & LPFC_IO_LIBDFC) {
 			/* open up abort window to timeout handler */
-			cmdiocbq->cmd_flag |= LPFC_IO_CMD_OUTSTANDING;
+			cmdiocbq->iocb_flag |= LPFC_IO_CMD_OUTSTANDING;
 		}
 		spin_unlock_irqrestore(&phba->hbalock, flags);
 		return 0; /* done for now */
@@ -600,7 +600,7 @@ lpfc_bsg_rport_els_cmp(struct lpfc_hba *phba,
 
 	/* Close the timeout handler abort window */
 	spin_lock_irqsave(&phba->hbalock, flags);
-	cmdiocbq->cmd_flag &= ~LPFC_IO_CMD_OUTSTANDING;
+	cmdiocbq->iocb_flag &= ~LPFC_IO_CMD_OUTSTANDING;
 	spin_unlock_irqrestore(&phba->hbalock, flags);
 
 	rsp = &rspiocbq->iocb;
@@ -726,10 +726,10 @@ lpfc_bsg_rport_els(struct bsg_job *job)
 		cmdiocbq->iocb.ulpContext = phba->sli4_hba.rpi_ids[rpi];
 	else
 		cmdiocbq->iocb.ulpContext = rpi;
-	cmdiocbq->cmd_flag |= LPFC_IO_LIBDFC;
+	cmdiocbq->iocb_flag |= LPFC_IO_LIBDFC;
 	cmdiocbq->context1 = dd_data;
 	cmdiocbq->context_un.ndlp = ndlp;
-	cmdiocbq->cmd_cmpl = lpfc_bsg_rport_els_cmp;
+	cmdiocbq->iocb_cmpl = lpfc_bsg_rport_els_cmp;
 	dd_data->type = TYPE_IOCB;
 	dd_data->set_job = job;
 	dd_data->context_un.iocb.cmdiocbq = cmdiocbq;
@@ -757,9 +757,9 @@ lpfc_bsg_rport_els(struct bsg_job *job)
 	if (rc == IOCB_SUCCESS) {
 		spin_lock_irqsave(&phba->hbalock, flags);
 		/* make sure the I/O had not been completed/released */
-		if (cmdiocbq->cmd_flag & LPFC_IO_LIBDFC) {
+		if (cmdiocbq->iocb_flag & LPFC_IO_LIBDFC) {
 			/* open up abort window to timeout handler */
-			cmdiocbq->cmd_flag |= LPFC_IO_CMD_OUTSTANDING;
+			cmdiocbq->iocb_flag |= LPFC_IO_CMD_OUTSTANDING;
 		}
 		spin_unlock_irqrestore(&phba->hbalock, flags);
 		return 0; /* done for now */
@@ -1053,7 +1053,7 @@ lpfc_bsg_ct_unsol_event(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 							lpfc_in_buf_free(phba,
 									dmabuf);
 						} else {
-							lpfc_sli3_post_buffer(phba,
+							lpfc_post_buffer(phba,
 									 pring,
 									 1);
 						}
@@ -1061,7 +1061,7 @@ lpfc_bsg_ct_unsol_event(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 					default:
 						if (!(phba->sli3_options &
 						      LPFC_SLI3_HBQ_ENABLED))
-							lpfc_sli3_post_buffer(phba,
+							lpfc_post_buffer(phba,
 									 pring,
 									 1);
 						break;
@@ -1395,7 +1395,7 @@ lpfc_issue_ct_rsp_cmp(struct lpfc_hba *phba,
 
 	/* Close the timeout handler abort window */
 	spin_lock_irqsave(&phba->hbalock, flags);
-	cmdiocbq->cmd_flag &= ~LPFC_IO_CMD_OUTSTANDING;
+	cmdiocbq->iocb_flag &= ~LPFC_IO_CMD_OUTSTANDING;
 	spin_unlock_irqrestore(&phba->hbalock, flags);
 
 	ndlp = dd_data->context_un.iocb.ndlp;
@@ -1549,13 +1549,13 @@ lpfc_issue_ct_rsp(struct lpfc_hba *phba, struct bsg_job *job, uint32_t tag,
 		"2722 Xmit CT response on exchange x%x Data: x%x x%x x%x\n",
 		icmd->ulpContext, icmd->ulpIoTag, tag, phba->link_state);
 
-	ctiocb->cmd_flag |= LPFC_IO_LIBDFC;
+	ctiocb->iocb_flag |= LPFC_IO_LIBDFC;
 	ctiocb->vport = phba->pport;
 	ctiocb->context1 = dd_data;
 	ctiocb->context2 = cmp;
 	ctiocb->context3 = bmp;
 	ctiocb->context_un.ndlp = ndlp;
-	ctiocb->cmd_cmpl = lpfc_issue_ct_rsp_cmp;
+	ctiocb->iocb_cmpl = lpfc_issue_ct_rsp_cmp;
 
 	dd_data->type = TYPE_IOCB;
 	dd_data->set_job = job;
@@ -1582,9 +1582,9 @@ lpfc_issue_ct_rsp(struct lpfc_hba *phba, struct bsg_job *job, uint32_t tag,
 	if (rc == IOCB_SUCCESS) {
 		spin_lock_irqsave(&phba->hbalock, flags);
 		/* make sure the I/O had not been completed/released */
-		if (ctiocb->cmd_flag & LPFC_IO_LIBDFC) {
+		if (ctiocb->iocb_flag & LPFC_IO_LIBDFC) {
 			/* open up abort window to timeout handler */
-			ctiocb->cmd_flag |= LPFC_IO_CMD_OUTSTANDING;
+			ctiocb->iocb_flag |= LPFC_IO_CMD_OUTSTANDING;
 		}
 		spin_unlock_irqrestore(&phba->hbalock, flags);
 		return 0; /* done for now */
@@ -2713,9 +2713,9 @@ static int lpfcdiag_loop_get_xri(struct lpfc_hba *phba, uint16_t rpi,
 	cmd->ulpClass = CLASS3;
 	cmd->ulpContext = rpi;
 
-	cmdiocbq->cmd_flag |= LPFC_IO_LIBDFC;
+	cmdiocbq->iocb_flag |= LPFC_IO_LIBDFC;
 	cmdiocbq->vport = phba->pport;
-	cmdiocbq->cmd_cmpl = NULL;
+	cmdiocbq->iocb_cmpl = NULL;
 
 	iocb_stat = lpfc_sli_issue_iocb_wait(phba, LPFC_ELS_RING, cmdiocbq,
 				rspiocbq,
@@ -3286,10 +3286,10 @@ lpfc_bsg_diag_loopback_run(struct bsg_job *job)
 		cmdiocbq->sli4_xritag = NO_XRI;
 		cmd->unsli3.rcvsli3.ox_id = 0xffff;
 	}
-	cmdiocbq->cmd_flag |= LPFC_IO_LIBDFC;
-	cmdiocbq->cmd_flag |= LPFC_IO_LOOPBACK;
+	cmdiocbq->iocb_flag |= LPFC_IO_LIBDFC;
+	cmdiocbq->iocb_flag |= LPFC_IO_LOOPBACK;
 	cmdiocbq->vport = phba->pport;
-	cmdiocbq->cmd_cmpl = NULL;
+	cmdiocbq->iocb_cmpl = NULL;
 	iocb_stat = lpfc_sli_issue_iocb_wait(phba, LPFC_ELS_RING, cmdiocbq,
 					     rspiocbq, (phba->fc_ratov * 2) +
 					     LPFC_DRVR_TIMEOUT);
@@ -5273,11 +5273,11 @@ lpfc_menlo_cmd(struct bsg_job *job)
 	cmd->ulpClass = CLASS3;
 	cmd->ulpOwner = OWN_CHIP;
 	cmd->ulpLe = 1; /* Limited Edition */
-	cmdiocbq->cmd_flag |= LPFC_IO_LIBDFC;
+	cmdiocbq->iocb_flag |= LPFC_IO_LIBDFC;
 	cmdiocbq->vport = phba->pport;
 	/* We want the firmware to timeout before we do */
 	cmd->ulpTimeout = MENLO_TIMEOUT - 5;
-	cmdiocbq->cmd_cmpl = lpfc_bsg_menlo_cmd_cmp;
+	cmdiocbq->iocb_cmpl = lpfc_bsg_menlo_cmd_cmp;
 	cmdiocbq->context1 = dd_data;
 	cmdiocbq->context2 = cmp;
 	cmdiocbq->context3 = bmp;
@@ -6001,7 +6001,7 @@ lpfc_bsg_timeout(struct bsg_job *job)
 
 		spin_lock_irqsave(&phba->hbalock, flags);
 		/* make sure the I/O abort window is still open */
-		if (!(cmdiocb->cmd_flag & LPFC_IO_CMD_OUTSTANDING)) {
+		if (!(cmdiocb->iocb_flag & LPFC_IO_CMD_OUTSTANDING)) {
 			spin_unlock_irqrestore(&phba->hbalock, flags);
 			return -EAGAIN;
 		}
diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index f7bf589b63fb..c9770b1d2366 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -129,7 +129,6 @@ void lpfc_disc_list_loopmap(struct lpfc_vport *);
 void lpfc_disc_start(struct lpfc_vport *);
 void lpfc_cleanup_discovery_resources(struct lpfc_vport *);
 void lpfc_cleanup(struct lpfc_vport *);
-void lpfc_prep_embed_io(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_ncmd);
 void lpfc_disc_timeout(struct timer_list *);
 
 int lpfc_unregister_fcf_prep(struct lpfc_hba *);
@@ -211,7 +210,7 @@ int lpfc_config_port_post(struct lpfc_hba *);
 int lpfc_hba_down_prep(struct lpfc_hba *);
 int lpfc_hba_down_post(struct lpfc_hba *);
 void lpfc_hba_init(struct lpfc_hba *, uint32_t *);
-int lpfc_sli3_post_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring, int cnt);
+int lpfc_post_buffer(struct lpfc_hba *, struct lpfc_sli_ring *, int);
 void lpfc_decode_firmware_rev(struct lpfc_hba *, char *, int);
 int lpfc_online(struct lpfc_hba *);
 void lpfc_unblock_mgmt_io(struct lpfc_hba *);
diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 19e2f8086a6d..dfcb7d4bd7fa 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -239,7 +239,7 @@ lpfc_ct_reject_event(struct lpfc_nodelist *ndlp,
 	cmdiocbq->context1 = lpfc_nlp_get(ndlp);
 	cmdiocbq->context2 = (uint8_t *)mp;
 	cmdiocbq->context3 = (uint8_t *)bmp;
-	cmdiocbq->cmd_cmpl = lpfc_ct_unsol_cmpl;
+	cmdiocbq->iocb_cmpl = lpfc_ct_unsol_cmpl;
 	icmd->ulpContext = rx_id;  /* Xri / rx_id */
 	icmd->unsli3.rcvsli3.ox_id = ox_id;
 	icmd->un.ulpWord[3] =
@@ -370,7 +370,7 @@ lpfc_ct_unsol_event(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 		/* Not enough posted buffers; Try posting more buffers */
 		phba->fc_stat.NoRcvBuf++;
 		if (!(phba->sli3_options & LPFC_SLI3_HBQ_ENABLED))
-			lpfc_sli3_post_buffer(phba, pring, 2);
+			lpfc_post_buffer(phba, pring, 2);
 		return;
 	}
 
@@ -447,7 +447,7 @@ lpfc_ct_unsol_event(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 				lpfc_ct_unsol_buffer(phba, iocbq, mp, size);
 				lpfc_in_buf_free(phba, mp);
 			}
-			lpfc_sli3_post_buffer(phba, pring, i);
+			lpfc_post_buffer(phba, pring, i);
 		}
 		list_del(&head);
 	}
@@ -652,7 +652,7 @@ lpfc_gen_req(struct lpfc_vport *vport, struct lpfc_dmabuf *bmp,
 			 "Data: x%x x%x\n",
 			 ndlp->nlp_DID, icmd->ulpIoTag,
 			 vport->port_state);
-	geniocb->cmd_cmpl = cmpl;
+	geniocb->iocb_cmpl = cmpl;
 	geniocb->drvrTimeout = icmd->ulpTimeout + LPFC_DRVR_TIMEOUT;
 	geniocb->vport = vport;
 	geniocb->retry = retry;
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 0d34a03164f5..5f44a0763f37 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -192,23 +192,23 @@ lpfc_prep_els_iocb(struct lpfc_vport *vport, uint8_t expectRsp,
 		 (elscmd == ELS_CMD_LOGO)))
 		switch (elscmd) {
 		case ELS_CMD_FLOGI:
-		elsiocb->cmd_flag |=
+		elsiocb->iocb_flag |=
 			((LPFC_ELS_ID_FLOGI << LPFC_FIP_ELS_ID_SHIFT)
 					& LPFC_FIP_ELS_ID_MASK);
 		break;
 		case ELS_CMD_FDISC:
-		elsiocb->cmd_flag |=
+		elsiocb->iocb_flag |=
 			((LPFC_ELS_ID_FDISC << LPFC_FIP_ELS_ID_SHIFT)
 					& LPFC_FIP_ELS_ID_MASK);
 		break;
 		case ELS_CMD_LOGO:
-		elsiocb->cmd_flag |=
+		elsiocb->iocb_flag |=
 			((LPFC_ELS_ID_LOGO << LPFC_FIP_ELS_ID_SHIFT)
 					& LPFC_FIP_ELS_ID_MASK);
 		break;
 		}
 	else
-		elsiocb->cmd_flag &= ~LPFC_FIP_ELS_ID_MASK;
+		elsiocb->iocb_flag &= ~LPFC_FIP_ELS_ID_MASK;
 
 	icmd = &elsiocb->iocb;
 
@@ -1252,10 +1252,10 @@ lpfc_cmpl_els_link_down(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			"6445 ELS completes after LINK_DOWN: "
 			" Status %x/%x cmd x%x flg x%x\n",
 			irsp->ulpStatus, irsp->un.ulpWord[4], cmd,
-			cmdiocb->cmd_flag);
+			cmdiocb->iocb_flag);
 
-	if (cmdiocb->cmd_flag & LPFC_IO_FABRIC) {
-		cmdiocb->cmd_flag &= ~LPFC_IO_FABRIC;
+	if (cmdiocb->iocb_flag & LPFC_IO_FABRIC) {
+		cmdiocb->iocb_flag &= ~LPFC_IO_FABRIC;
 		atomic_dec(&phba->fabric_iocb_count);
 	}
 	lpfc_els_free_iocb(phba, cmdiocb);
@@ -1370,7 +1370,7 @@ lpfc_issue_els_flogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	phba->fc_ratov = tmo;
 
 	phba->fc_stat.elsXmitFLOGI++;
-	elsiocb->cmd_cmpl = lpfc_cmpl_els_flogi;
+	elsiocb->iocb_cmpl = lpfc_cmpl_els_flogi;
 
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
 		"Issue FLOGI:     opt:x%x",
@@ -1463,7 +1463,7 @@ lpfc_els_abort_flogi(struct lpfc_hba *phba)
 			if (ndlp && ndlp->nlp_DID == Fabric_DID) {
 				if ((phba->pport->fc_flag & FC_PT2PT) &&
 				    !(phba->pport->fc_flag & FC_PT2PT_PLOGI))
-					iocb->fabric_cmd_cmpl =
+					iocb->fabric_iocb_cmpl =
 						lpfc_ignore_els_cmpl;
 				lpfc_sli_issue_abort_iotag(phba, pring, iocb,
 							   NULL);
@@ -2226,7 +2226,7 @@ lpfc_issue_els_plogi(struct lpfc_vport *vport, uint32_t did, uint8_t retry)
 	}
 
 	phba->fc_stat.elsXmitPLOGI++;
-	elsiocb->cmd_cmpl = lpfc_cmpl_els_plogi;
+	elsiocb->iocb_cmpl = lpfc_cmpl_els_plogi;
 
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
 			      "Issue PLOGI:     did:x%x refcnt %d",
@@ -2478,7 +2478,7 @@ lpfc_issue_els_prli(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		/* For FCP support */
 		npr->prliType = PRLI_FCP_TYPE;
 		npr->initiatorFunc = 1;
-		elsiocb->cmd_flag |= LPFC_PRLI_FCP_REQ;
+		elsiocb->iocb_flag |= LPFC_PRLI_FCP_REQ;
 
 		/* Remove FCP type - processed. */
 		local_nlp_type &= ~NLP_FC4_FCP;
@@ -2512,14 +2512,14 @@ lpfc_issue_els_prli(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 
 		npr_nvme->word1 = cpu_to_be32(npr_nvme->word1);
 		npr_nvme->word4 = cpu_to_be32(npr_nvme->word4);
-		elsiocb->cmd_flag |= LPFC_PRLI_NVME_REQ;
+		elsiocb->iocb_flag |= LPFC_PRLI_NVME_REQ;
 
 		/* Remove NVME type - processed. */
 		local_nlp_type &= ~NLP_FC4_NVME;
 	}
 
 	phba->fc_stat.elsXmitPRLI++;
-	elsiocb->cmd_cmpl = lpfc_cmpl_els_prli;
+	elsiocb->iocb_cmpl = lpfc_cmpl_els_prli;
 	spin_lock_irq(&ndlp->lock);
 	ndlp->nlp_flag |= NLP_PRLI_SND;
 
@@ -2842,7 +2842,7 @@ lpfc_issue_els_adisc(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	ap->DID = be32_to_cpu(vport->fc_myDID);
 
 	phba->fc_stat.elsXmitADISC++;
-	elsiocb->cmd_cmpl = lpfc_cmpl_els_adisc;
+	elsiocb->iocb_cmpl = lpfc_cmpl_els_adisc;
 	spin_lock_irq(&ndlp->lock);
 	ndlp->nlp_flag |= NLP_ADISC_SND;
 	spin_unlock_irq(&ndlp->lock);
@@ -3065,7 +3065,7 @@ lpfc_issue_els_logo(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	memcpy(pcmd, &vport->fc_portname, sizeof(struct lpfc_name));
 
 	phba->fc_stat.elsXmitLOGO++;
-	elsiocb->cmd_cmpl = lpfc_cmpl_els_logo;
+	elsiocb->iocb_cmpl = lpfc_cmpl_els_logo;
 	spin_lock_irq(&ndlp->lock);
 	ndlp->nlp_flag |= NLP_LOGO_SND;
 	ndlp->nlp_flag &= ~NLP_ISSUE_LOGO;
@@ -3417,7 +3417,7 @@ lpfc_issue_els_scr(struct lpfc_vport *vport, uint8_t retry)
 		ndlp->nlp_DID, 0, 0);
 
 	phba->fc_stat.elsXmitSCR++;
-	elsiocb->cmd_cmpl = lpfc_cmpl_els_disc_cmd;
+	elsiocb->iocb_cmpl = lpfc_cmpl_els_disc_cmd;
 	elsiocb->context1 = lpfc_nlp_get(ndlp);
 	if (!elsiocb->context1) {
 		lpfc_els_free_iocb(phba, elsiocb);
@@ -3514,7 +3514,7 @@ lpfc_issue_els_rscn(struct lpfc_vport *vport, uint8_t retry)
 	event->portid.rscn_fid[2] = nportid & 0x000000FF;
 
 	phba->fc_stat.elsXmitRSCN++;
-	elsiocb->cmd_cmpl = lpfc_cmpl_els_cmd;
+	elsiocb->iocb_cmpl = lpfc_cmpl_els_cmd;
 	elsiocb->context1 = lpfc_nlp_get(ndlp);
 	if (!elsiocb->context1) {
 		lpfc_els_free_iocb(phba, elsiocb);
@@ -3613,7 +3613,7 @@ lpfc_issue_els_farpr(struct lpfc_vport *vport, uint32_t nportid, uint8_t retry)
 		ndlp->nlp_DID, 0, 0);
 
 	phba->fc_stat.elsXmitFARPR++;
-	elsiocb->cmd_cmpl = lpfc_cmpl_els_cmd;
+	elsiocb->iocb_cmpl = lpfc_cmpl_els_cmd;
 	elsiocb->context1 = lpfc_nlp_get(ndlp);
 	if (!elsiocb->context1) {
 		lpfc_els_free_iocb(phba, elsiocb);
@@ -3704,7 +3704,7 @@ lpfc_issue_els_rdf(struct lpfc_vport *vport, uint8_t retry)
 			 phba->cgn_reg_fpin);
 
 	phba->cgn_fpin_frequency = LPFC_FPIN_INIT_FREQ;
-	elsiocb->cmd_cmpl = lpfc_cmpl_els_disc_cmd;
+	elsiocb->iocb_cmpl = lpfc_cmpl_els_disc_cmd;
 	elsiocb->context1 = lpfc_nlp_get(ndlp);
 	if (!elsiocb->context1) {
 		lpfc_els_free_iocb(phba, elsiocb);
@@ -4154,7 +4154,7 @@ lpfc_issue_els_edc(struct lpfc_vport *vport, uint8_t retry)
 			 ndlp->nlp_DID, phba->cgn_reg_signal,
 			 phba->cgn_reg_fpin);
 
-	elsiocb->cmd_cmpl = lpfc_cmpl_els_disc_cmd;
+	elsiocb->iocb_cmpl = lpfc_cmpl_els_disc_cmd;
 	elsiocb->context1 = lpfc_nlp_get(ndlp);
 	if (!elsiocb->context1) {
 		lpfc_els_free_iocb(phba, elsiocb);
@@ -4968,12 +4968,12 @@ lpfc_els_free_iocb(struct lpfc_hba *phba, struct lpfc_iocbq *elsiocb)
 
 	/* context2  = cmd,  context2->next = rsp, context3 = bpl */
 	if (elsiocb->context2) {
-		if (elsiocb->cmd_flag & LPFC_DELAY_MEM_FREE) {
+		if (elsiocb->iocb_flag & LPFC_DELAY_MEM_FREE) {
 			/* Firmware could still be in progress of DMAing
 			 * payload, so don't free data buffer till after
 			 * a hbeat.
 			 */
-			elsiocb->cmd_flag &= ~LPFC_DELAY_MEM_FREE;
+			elsiocb->iocb_flag &= ~LPFC_DELAY_MEM_FREE;
 			buf_ptr = elsiocb->context2;
 			elsiocb->context2 = NULL;
 			if (buf_ptr) {
@@ -5480,9 +5480,9 @@ lpfc_els_rsp_acc(struct lpfc_vport *vport, uint32_t flag,
 			ndlp->nlp_flag & NLP_REG_LOGIN_SEND))
 			ndlp->nlp_flag &= ~NLP_LOGO_ACC;
 		spin_unlock_irq(&ndlp->lock);
-		elsiocb->cmd_cmpl = lpfc_cmpl_els_logo_acc;
+		elsiocb->iocb_cmpl = lpfc_cmpl_els_logo_acc;
 	} else {
-		elsiocb->cmd_cmpl = lpfc_cmpl_els_rsp;
+		elsiocb->iocb_cmpl = lpfc_cmpl_els_rsp;
 	}
 
 	phba->fc_stat.elsXmitACC++;
@@ -5577,7 +5577,7 @@ lpfc_els_rsp_reject(struct lpfc_vport *vport, uint32_t rejectError,
 		ndlp->nlp_DID, ndlp->nlp_flag, rejectError);
 
 	phba->fc_stat.elsXmitLSRJT++;
-	elsiocb->cmd_cmpl = lpfc_cmpl_els_rsp;
+	elsiocb->iocb_cmpl = lpfc_cmpl_els_rsp;
 	elsiocb->context1 = lpfc_nlp_get(ndlp);
 	if (!elsiocb->context1) {
 		lpfc_els_free_iocb(phba, elsiocb);
@@ -5657,7 +5657,7 @@ lpfc_issue_els_edc_rsp(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 			      "Issue EDC ACC:      did:x%x flg:x%x refcnt %d",
 			      ndlp->nlp_DID, ndlp->nlp_flag,
 			      kref_read(&ndlp->kref));
-	elsiocb->cmd_cmpl = lpfc_cmpl_els_rsp;
+	elsiocb->iocb_cmpl = lpfc_cmpl_els_rsp;
 
 	phba->fc_stat.elsXmitACC++;
 	elsiocb->context1 = lpfc_nlp_get(ndlp);
@@ -5750,7 +5750,7 @@ lpfc_els_rsp_adisc_acc(struct lpfc_vport *vport, struct lpfc_iocbq *oldiocb,
 		      ndlp->nlp_DID, ndlp->nlp_flag, kref_read(&ndlp->kref));
 
 	phba->fc_stat.elsXmitACC++;
-	elsiocb->cmd_cmpl = lpfc_cmpl_els_rsp;
+	elsiocb->iocb_cmpl = lpfc_cmpl_els_rsp;
 	elsiocb->context1 = lpfc_nlp_get(ndlp);
 	if (!elsiocb->context1) {
 		lpfc_els_free_iocb(phba, elsiocb);
@@ -5924,7 +5924,7 @@ lpfc_els_rsp_prli_acc(struct lpfc_vport *vport, struct lpfc_iocbq *oldiocb,
 		      ndlp->nlp_DID, ndlp->nlp_flag, kref_read(&ndlp->kref));
 
 	phba->fc_stat.elsXmitACC++;
-	elsiocb->cmd_cmpl = lpfc_cmpl_els_rsp;
+	elsiocb->iocb_cmpl = lpfc_cmpl_els_rsp;
 	elsiocb->context1 =  lpfc_nlp_get(ndlp);
 	if (!elsiocb->context1) {
 		lpfc_els_free_iocb(phba, elsiocb);
@@ -6025,7 +6025,7 @@ lpfc_els_rsp_rnid_acc(struct lpfc_vport *vport, uint8_t format,
 		      ndlp->nlp_DID, ndlp->nlp_flag, kref_read(&ndlp->kref));
 
 	phba->fc_stat.elsXmitACC++;
-	elsiocb->cmd_cmpl = lpfc_cmpl_els_rsp;
+	elsiocb->iocb_cmpl = lpfc_cmpl_els_rsp;
 	elsiocb->context1 = lpfc_nlp_get(ndlp);
 	if (!elsiocb->context1) {
 		lpfc_els_free_iocb(phba, elsiocb);
@@ -6139,7 +6139,7 @@ lpfc_els_rsp_echo_acc(struct lpfc_vport *vport, uint8_t *data,
 		      ndlp->nlp_DID, ndlp->nlp_flag, kref_read(&ndlp->kref));
 
 	phba->fc_stat.elsXmitACC++;
-	elsiocb->cmd_cmpl = lpfc_cmpl_els_rsp;
+	elsiocb->iocb_cmpl = lpfc_cmpl_els_rsp;
 	elsiocb->context1 =  lpfc_nlp_get(ndlp);
 	if (!elsiocb->context1) {
 		lpfc_els_free_iocb(phba, elsiocb);
@@ -6803,7 +6803,7 @@ lpfc_els_rdp_cmpl(struct lpfc_hba *phba, struct lpfc_rdp_context *rdp_context,
 				     rdp_context->page_a0, vport);
 
 	rdp_res->length = cpu_to_be32(len - 8);
-	elsiocb->cmd_cmpl = lpfc_cmpl_els_rsp;
+	elsiocb->iocb_cmpl = lpfc_cmpl_els_rsp;
 
 	/* Now that we know the true size of the payload, update the BPL */
 	bpl = (struct ulp_bde64 *)
@@ -6844,7 +6844,7 @@ lpfc_els_rdp_cmpl(struct lpfc_hba *phba, struct lpfc_rdp_context *rdp_context,
 	stat->un.b.lsRjtRsnCode = LSRJT_UNABLE_TPC;
 
 	phba->fc_stat.elsXmitLSRJT++;
-	elsiocb->cmd_cmpl = lpfc_cmpl_els_rsp;
+	elsiocb->iocb_cmpl = lpfc_cmpl_els_rsp;
 	elsiocb->context1 = lpfc_nlp_get(ndlp);
 	if (!elsiocb->context1) {
 		lpfc_els_free_iocb(phba, elsiocb);
@@ -7066,7 +7066,7 @@ lpfc_els_lcb_rsp(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	lcb_res->capability = lcb_context->capability;
 	lcb_res->lcb_frequency = lcb_context->frequency;
 	lcb_res->lcb_duration = lcb_context->duration;
-	elsiocb->cmd_cmpl = lpfc_cmpl_els_rsp;
+	elsiocb->iocb_cmpl = lpfc_cmpl_els_rsp;
 	phba->fc_stat.elsXmitACC++;
 
 	elsiocb->context1 = lpfc_nlp_get(ndlp);
@@ -7105,7 +7105,7 @@ lpfc_els_lcb_rsp(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	if (shdr_add_status == ADD_STATUS_OPERATION_ALREADY_ACTIVE)
 		stat->un.b.lsRjtRsnCodeExp = LSEXP_CMD_IN_PROGRESS;
 
-	elsiocb->cmd_cmpl = lpfc_cmpl_els_rsp;
+	elsiocb->iocb_cmpl = lpfc_cmpl_els_rsp;
 	phba->fc_stat.elsXmitLSRJT++;
 	elsiocb->context1 = lpfc_nlp_get(ndlp);
 	if (!elsiocb->context1) {
@@ -8172,7 +8172,7 @@ lpfc_els_rsp_rls_acc(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 			 elsiocb->iotag, elsiocb->iocb.ulpContext,
 			 ndlp->nlp_DID, ndlp->nlp_flag, ndlp->nlp_state,
 			 ndlp->nlp_rpi);
-	elsiocb->cmd_cmpl = lpfc_cmpl_els_rsp;
+	elsiocb->iocb_cmpl = lpfc_cmpl_els_rsp;
 	phba->fc_stat.elsXmitACC++;
 	elsiocb->context1 = lpfc_nlp_get(ndlp);
 	if (!elsiocb->context1) {
@@ -8324,7 +8324,7 @@ lpfc_els_rcv_rtv(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 			 ndlp->nlp_DID, ndlp->nlp_flag, ndlp->nlp_state,
 			 ndlp->nlp_rpi,
 			rtv_rsp->ratov, rtv_rsp->edtov, rtv_rsp->qtov);
-	elsiocb->cmd_cmpl = lpfc_cmpl_els_rsp;
+	elsiocb->iocb_cmpl = lpfc_cmpl_els_rsp;
 	phba->fc_stat.elsXmitACC++;
 	elsiocb->context1 = lpfc_nlp_get(ndlp);
 	if (!elsiocb->context1) {
@@ -8401,7 +8401,7 @@ lpfc_issue_els_rrq(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		"Issue RRQ:     did:x%x",
 		did, rrq->xritag, rrq->rxid);
 	elsiocb->context_un.rrq = rrq;
-	elsiocb->cmd_cmpl = lpfc_cmpl_els_rrq;
+	elsiocb->iocb_cmpl = lpfc_cmpl_els_rrq;
 
 	lpfc_nlp_get(ndlp);
 	elsiocb->context1 = ndlp;
@@ -8507,7 +8507,7 @@ lpfc_els_rsp_rpl_acc(struct lpfc_vport *vport, uint16_t cmdsize,
 			 elsiocb->iotag, elsiocb->iocb.ulpContext,
 			 ndlp->nlp_DID, ndlp->nlp_flag, ndlp->nlp_state,
 			 ndlp->nlp_rpi);
-	elsiocb->cmd_cmpl = lpfc_cmpl_els_rsp;
+	elsiocb->iocb_cmpl = lpfc_cmpl_els_rsp;
 	phba->fc_stat.elsXmitACC++;
 	elsiocb->context1 = lpfc_nlp_get(ndlp);
 	if (!elsiocb->context1) {
@@ -8947,7 +8947,7 @@ lpfc_els_timeout_handler(struct lpfc_vport *vport)
 	list_for_each_entry_safe(piocb, tmp_iocb, &pring->txcmplq, list) {
 		cmd = &piocb->iocb;
 
-		if ((piocb->cmd_flag & LPFC_IO_LIBDFC) != 0 ||
+		if ((piocb->iocb_flag & LPFC_IO_LIBDFC) != 0 ||
 		    piocb->iocb.ulpCommand == CMD_ABORT_XRI_CN ||
 		    piocb->iocb.ulpCommand == CMD_CLOSE_XRI_CN)
 			continue;
@@ -9060,13 +9060,13 @@ lpfc_els_flush_cmd(struct lpfc_vport *vport)
 
 	/* First we need to issue aborts to outstanding cmds on txcmpl */
 	list_for_each_entry_safe(piocb, tmp_iocb, &pring->txcmplq, list) {
-		if (piocb->cmd_flag & LPFC_IO_LIBDFC)
+		if (piocb->iocb_flag & LPFC_IO_LIBDFC)
 			continue;
 
 		if (piocb->vport != vport)
 			continue;
 
-		if (piocb->cmd_flag & LPFC_DRIVER_ABORTED)
+		if (piocb->iocb_flag & LPFC_DRIVER_ABORTED)
 			continue;
 
 		/* On the ELS ring we can have ELS_REQUESTs or
@@ -9084,7 +9084,7 @@ lpfc_els_flush_cmd(struct lpfc_vport *vport)
 			 * and avoid any retry logic.
 			 */
 			if (phba->link_state == LPFC_LINK_DOWN)
-				piocb->cmd_cmpl = lpfc_cmpl_els_link_down;
+				piocb->iocb_cmpl = lpfc_cmpl_els_link_down;
 		}
 		if (cmd->ulpCommand == CMD_GEN_REQUEST64_CR)
 			list_add_tail(&piocb->dlist, &abort_list);
@@ -9119,8 +9119,9 @@ lpfc_els_flush_cmd(struct lpfc_vport *vport)
 	list_for_each_entry_safe(piocb, tmp_iocb, &pring->txq, list) {
 		cmd = &piocb->iocb;
 
-		if (piocb->cmd_flag & LPFC_IO_LIBDFC)
+		if (piocb->iocb_flag & LPFC_IO_LIBDFC) {
 			continue;
+		}
 
 		/* Do not flush out the QUE_RING and ABORT/CLOSE iocbs */
 		if (cmd->ulpCommand == CMD_QUE_RING_BUF_CN ||
@@ -9765,7 +9766,7 @@ lpfc_els_unsol_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	payload_len = elsiocb->iocb.unsli3.rcvsli3.acc_len;
 	cmd = *payload;
 	if ((phba->sli3_options & LPFC_SLI3_HBQ_ENABLED) == 0)
-		lpfc_sli3_post_buffer(phba, pring, 1);
+		lpfc_post_buffer(phba, pring, 1);
 
 	did = icmd->un.rcvels.remoteID;
 	if (icmd->ulpStatus) {
@@ -10238,7 +10239,7 @@ lpfc_els_unsol_event(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 		phba->fc_stat.NoRcvBuf++;
 		/* Not enough posted buffers; Try posting more buffers */
 		if (!(phba->sli3_options & LPFC_SLI3_HBQ_ENABLED))
-			lpfc_sli3_post_buffer(phba, pring, 0);
+			lpfc_post_buffer(phba, pring, 0);
 		return;
 	}
 
@@ -10874,7 +10875,7 @@ lpfc_issue_els_fdisc(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	lpfc_set_disctmo(vport);
 
 	phba->fc_stat.elsXmitFDISC++;
-	elsiocb->cmd_cmpl = lpfc_cmpl_els_fdisc;
+	elsiocb->iocb_cmpl = lpfc_cmpl_els_fdisc;
 
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
 		"Issue FDISC:     did:x%x",
@@ -10998,7 +10999,7 @@ lpfc_issue_els_npiv_logo(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 		"Issue LOGO npiv  did:x%x flg:x%x",
 		ndlp->nlp_DID, ndlp->nlp_flag, 0);
 
-	elsiocb->cmd_cmpl = lpfc_cmpl_els_npiv_logo;
+	elsiocb->iocb_cmpl = lpfc_cmpl_els_npiv_logo;
 	spin_lock_irq(&ndlp->lock);
 	ndlp->nlp_flag |= NLP_LOGO_SND;
 	spin_unlock_irq(&ndlp->lock);
@@ -11083,9 +11084,9 @@ lpfc_resume_fabric_iocbs(struct lpfc_hba *phba)
 	}
 	spin_unlock_irqrestore(&phba->hbalock, iflags);
 	if (iocb) {
-		iocb->fabric_cmd_cmpl = iocb->cmd_cmpl;
-		iocb->cmd_cmpl = lpfc_cmpl_fabric_iocb;
-		iocb->cmd_flag |= LPFC_IO_FABRIC;
+		iocb->fabric_iocb_cmpl = iocb->iocb_cmpl;
+		iocb->iocb_cmpl = lpfc_cmpl_fabric_iocb;
+		iocb->iocb_flag |= LPFC_IO_FABRIC;
 
 		lpfc_debugfs_disc_trc(iocb->vport, LPFC_DISC_TRC_ELS_CMD,
 			"Fabric sched1:   ste:x%x",
@@ -11094,13 +11095,13 @@ lpfc_resume_fabric_iocbs(struct lpfc_hba *phba)
 		ret = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, iocb, 0);
 
 		if (ret == IOCB_ERROR) {
-			iocb->cmd_cmpl = iocb->fabric_cmd_cmpl;
-			iocb->fabric_cmd_cmpl = NULL;
-			iocb->cmd_flag &= ~LPFC_IO_FABRIC;
+			iocb->iocb_cmpl = iocb->fabric_iocb_cmpl;
+			iocb->fabric_iocb_cmpl = NULL;
+			iocb->iocb_flag &= ~LPFC_IO_FABRIC;
 			cmd = &iocb->iocb;
 			cmd->ulpStatus = IOSTAT_LOCAL_REJECT;
 			cmd->un.ulpWord[4] = IOERR_SLI_ABORTED;
-			iocb->cmd_cmpl(phba, iocb, iocb);
+			iocb->iocb_cmpl(phba, iocb, iocb);
 
 			atomic_dec(&phba->fabric_iocb_count);
 			goto repeat;
@@ -11156,8 +11157,8 @@ lpfc_block_fabric_iocbs(struct lpfc_hba *phba)
  * @rspiocb: pointer to lpfc response iocb data structure.
  *
  * This routine is the callback function that is put to the fabric iocb's
- * callback function pointer (iocb->cmd_cmpl). The original iocb's callback
- * function pointer has been stored in iocb->fabric_cmd_cmpl. This callback
+ * callback function pointer (iocb->iocb_cmpl). The original iocb's callback
+ * function pointer has been stored in iocb->fabric_iocb_cmpl. This callback
  * function first restores and invokes the original iocb's callback function
  * and then invokes the lpfc_resume_fabric_iocbs() routine to issue the next
  * fabric bound iocb from the driver internal fabric iocb list onto the wire.
@@ -11168,7 +11169,7 @@ lpfc_cmpl_fabric_iocb(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 {
 	struct ls_rjt stat;
 
-	WARN_ON((cmdiocb->cmd_flag & LPFC_IO_FABRIC) != LPFC_IO_FABRIC);
+	BUG_ON((cmdiocb->iocb_flag & LPFC_IO_FABRIC) != LPFC_IO_FABRIC);
 
 	switch (rspiocb->iocb.ulpStatus) {
 		case IOSTAT_NPORT_RJT:
@@ -11194,10 +11195,10 @@ lpfc_cmpl_fabric_iocb(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 
 	BUG_ON(atomic_read(&phba->fabric_iocb_count) == 0);
 
-	cmdiocb->cmd_cmpl = cmdiocb->fabric_cmd_cmpl;
-	cmdiocb->fabric_cmd_cmpl = NULL;
-	cmdiocb->cmd_flag &= ~LPFC_IO_FABRIC;
-	cmdiocb->cmd_cmpl(phba, cmdiocb, rspiocb);
+	cmdiocb->iocb_cmpl = cmdiocb->fabric_iocb_cmpl;
+	cmdiocb->fabric_iocb_cmpl = NULL;
+	cmdiocb->iocb_flag &= ~LPFC_IO_FABRIC;
+	cmdiocb->iocb_cmpl(phba, cmdiocb, rspiocb);
 
 	atomic_dec(&phba->fabric_iocb_count);
 	if (!test_bit(FABRIC_COMANDS_BLOCKED, &phba->bit_flags)) {
@@ -11248,9 +11249,9 @@ lpfc_issue_fabric_iocb(struct lpfc_hba *phba, struct lpfc_iocbq *iocb)
 		atomic_inc(&phba->fabric_iocb_count);
 	spin_unlock_irqrestore(&phba->hbalock, iflags);
 	if (ready) {
-		iocb->fabric_cmd_cmpl = iocb->cmd_cmpl;
-		iocb->cmd_cmpl = lpfc_cmpl_fabric_iocb;
-		iocb->cmd_flag |= LPFC_IO_FABRIC;
+		iocb->fabric_iocb_cmpl = iocb->iocb_cmpl;
+		iocb->iocb_cmpl = lpfc_cmpl_fabric_iocb;
+		iocb->iocb_flag |= LPFC_IO_FABRIC;
 
 		lpfc_debugfs_disc_trc(iocb->vport, LPFC_DISC_TRC_ELS_CMD,
 			"Fabric sched2:   ste:x%x",
@@ -11259,9 +11260,9 @@ lpfc_issue_fabric_iocb(struct lpfc_hba *phba, struct lpfc_iocbq *iocb)
 		ret = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, iocb, 0);
 
 		if (ret == IOCB_ERROR) {
-			iocb->cmd_cmpl = iocb->fabric_cmd_cmpl;
-			iocb->fabric_cmd_cmpl = NULL;
-			iocb->cmd_flag &= ~LPFC_IO_FABRIC;
+			iocb->iocb_cmpl = iocb->fabric_iocb_cmpl;
+			iocb->fabric_iocb_cmpl = NULL;
+			iocb->iocb_flag &= ~LPFC_IO_FABRIC;
 			atomic_dec(&phba->fabric_iocb_count);
 		}
 	} else {
@@ -11654,7 +11655,7 @@ int lpfc_issue_els_qfpa(struct lpfc_vport *vport)
 	*((u32 *)(pcmd)) = ELS_CMD_QFPA;
 	pcmd += 4;
 
-	elsiocb->cmd_cmpl = lpfc_cmpl_els_qfpa;
+	elsiocb->iocb_cmpl = lpfc_cmpl_els_qfpa;
 
 	elsiocb->context1 = lpfc_nlp_get(ndlp);
 	if (!elsiocb->context1) {
@@ -11737,7 +11738,7 @@ lpfc_vmid_uvem(struct lpfc_vport *vport,
 	}
 	inst_desc->word6 = cpu_to_be32(inst_desc->word6);
 
-	elsiocb->cmd_cmpl = lpfc_cmpl_els_uvem;
+	elsiocb->iocb_cmpl = lpfc_cmpl_els_uvem;
 
 	elsiocb->context1 = lpfc_nlp_get(ndlp);
 	if (!elsiocb->context1) {
diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index 215fbf1c777e..824fc8c08840 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -60,13 +60,6 @@
 	((ptr)->name##_WORD = ((((value) & name##_MASK) << name##_SHIFT) | \
 		 ((ptr)->name##_WORD & ~(name##_MASK << name##_SHIFT))))
 
-#define get_wqe_reqtag(x)	(((x)->wqe.words[9] >>  0) & 0xFFFF)
-
-#define get_job_ulpword(x, y)	((x)->iocb.un.ulpWord[y])
-
-#define set_job_ulpstatus(x, y)	bf_set(lpfc_wcqe_c_status, &(x)->wcqe_cmpl, y)
-#define set_job_ulpword4(x, y)	((&(x)->wcqe_cmpl)->parameter = y)
-
 struct dma_address {
 	uint32_t addr_lo;
 	uint32_t addr_hi;
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 48043e1ba485..fe8b4258cdc0 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -982,7 +982,7 @@ lpfc_hba_clean_txcmplq(struct lpfc_hba *phba)
 		spin_lock_irq(&pring->ring_lock);
 		list_for_each_entry_safe(piocb, next_iocb,
 					 &pring->txcmplq, list)
-			piocb->cmd_flag &= ~LPFC_IO_ON_TXCMPLQ;
+			piocb->iocb_flag &= ~LPFC_IO_ON_TXCMPLQ;
 		list_splice_init(&pring->txcmplq, &completions);
 		pring->txcmplq_cnt = 0;
 		spin_unlock_irq(&pring->ring_lock);
@@ -2643,7 +2643,7 @@ lpfc_get_hba_model_desc(struct lpfc_hba *phba, uint8_t *mdp, uint8_t *descp)
 }
 
 /**
- * lpfc_sli3_post_buffer - Post IOCB(s) with DMA buffer descriptor(s) to a IOCB ring
+ * lpfc_post_buffer - Post IOCB(s) with DMA buffer descriptor(s) to a IOCB ring
  * @phba: pointer to lpfc hba data structure.
  * @pring: pointer to a IOCB ring.
  * @cnt: the number of IOCBs to be posted to the IOCB ring.
@@ -2655,7 +2655,7 @@ lpfc_get_hba_model_desc(struct lpfc_hba *phba, uint8_t *mdp, uint8_t *descp)
  *   The number of IOCBs NOT able to be posted to the IOCB ring.
  **/
 int
-lpfc_sli3_post_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring, int cnt)
+lpfc_post_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring, int cnt)
 {
 	IOCB_t *icmd;
 	struct lpfc_iocbq *iocb;
@@ -2761,7 +2761,7 @@ lpfc_post_rcv_buf(struct lpfc_hba *phba)
 	struct lpfc_sli *psli = &phba->sli;
 
 	/* Ring 0, ELS / CT buffers */
-	lpfc_sli3_post_buffer(phba, &psli->sli3_ring[LPFC_ELS_RING], LPFC_BUF_RING0);
+	lpfc_post_buffer(phba, &psli->sli3_ring[LPFC_ELS_RING], LPFC_BUF_RING0);
 	/* Ring 2 - FCP no buffers needed */
 
 	return 0;
@@ -4215,7 +4215,8 @@ lpfc_io_buf_replenish(struct lpfc_hba *phba, struct list_head *cbuf)
 			qp = &phba->sli4_hba.hdwq[idx];
 			lpfc_cmd->hdwq_no = idx;
 			lpfc_cmd->hdwq = qp;
-			lpfc_cmd->cur_iocbq.cmd_cmpl = NULL;
+			lpfc_cmd->cur_iocbq.wqe_cmpl = NULL;
+			lpfc_cmd->cur_iocbq.iocb_cmpl = NULL;
 			spin_lock(&qp->io_buf_list_put_lock);
 			list_add_tail(&lpfc_cmd->list,
 				      &qp->lpfc_io_buf_list_put);
@@ -11968,7 +11969,7 @@ lpfc_sli_enable_msi(struct lpfc_hba *phba)
 	rc = pci_enable_msi(phba->pcidev);
 	if (!rc)
 		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-				"0012 PCI enable MSI mode success.\n");
+				"0462 PCI enable MSI mode success.\n");
 	else {
 		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
 				"0471 PCI enable MSI mode failed (%d)\n", rc);
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index e788610bc996..2bd35a7424c2 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -2139,9 +2139,9 @@ lpfc_cmpl_prli_prli_issue(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	npr = NULL;
 	nvpr = NULL;
 	temp_ptr = lpfc_check_elscmpl_iocb(phba, cmdiocb, rspiocb);
-	if (cmdiocb->cmd_flag & LPFC_PRLI_FCP_REQ)
+	if (cmdiocb->iocb_flag & LPFC_PRLI_FCP_REQ)
 		npr = (PRLI *) temp_ptr;
-	else if (cmdiocb->cmd_flag & LPFC_PRLI_NVME_REQ)
+	else if (cmdiocb->iocb_flag & LPFC_PRLI_NVME_REQ)
 		nvpr = (struct lpfc_nvme_prli *) temp_ptr;
 
 	irsp = &rspiocb->iocb;
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index c74b2187dbad..4e0c0b273e5f 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -352,12 +352,11 @@ __lpfc_nvme_ls_req_cmp(struct lpfc_hba *phba,  struct lpfc_vport *vport,
 
 static void
 lpfc_nvme_ls_req_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
-		     struct lpfc_iocbq *rspwqe)
+		       struct lpfc_wcqe_complete *wcqe)
 {
 	struct lpfc_vport *vport = cmdwqe->vport;
 	struct lpfc_nvme_lport *lport;
 	uint32_t status;
-	struct lpfc_wcqe_complete *wcqe = &rspwqe->wcqe_cmpl;
 
 	status = bf_get(lpfc_wcqe_c_status, wcqe) & LPFC_IOCB_STATUS_MASK;
 
@@ -381,7 +380,7 @@ lpfc_nvme_gen_req(struct lpfc_vport *vport, struct lpfc_dmabuf *bmp,
 		  struct lpfc_dmabuf *inp,
 		  struct nvmefc_ls_req *pnvme_lsreq,
 		  void (*cmpl)(struct lpfc_hba *, struct lpfc_iocbq *,
-			       struct lpfc_iocbq *),
+			       struct lpfc_wcqe_complete *),
 		  struct lpfc_nodelist *ndlp, uint32_t num_entry,
 		  uint32_t tmo, uint8_t retry)
 {
@@ -402,7 +401,7 @@ lpfc_nvme_gen_req(struct lpfc_vport *vport, struct lpfc_dmabuf *bmp,
 	memset(wqe, 0, sizeof(union lpfc_wqe));
 
 	genwqe->context3 = (uint8_t *)bmp;
-	genwqe->cmd_flag |= LPFC_IO_NVME_LS;
+	genwqe->iocb_flag |= LPFC_IO_NVME_LS;
 
 	/* Save for completion so we can release these resources */
 	genwqe->context1 = lpfc_nlp_get(ndlp);
@@ -433,7 +432,7 @@ lpfc_nvme_gen_req(struct lpfc_vport *vport, struct lpfc_dmabuf *bmp,
 			first_len = xmit_len;
 	}
 
-	genwqe->num_bdes = num_entry;
+	genwqe->rsvd2 = num_entry;
 	genwqe->hba_wqidx = 0;
 
 	/* Words 0 - 2 */
@@ -484,7 +483,8 @@ lpfc_nvme_gen_req(struct lpfc_vport *vport, struct lpfc_dmabuf *bmp,
 
 
 	/* Issue GEN REQ WQE for NPORT <did> */
-	genwqe->cmd_cmpl = cmpl;
+	genwqe->wqe_cmpl = cmpl;
+	genwqe->iocb_cmpl = NULL;
 	genwqe->drvrTimeout = tmo + LPFC_DRVR_TIMEOUT;
 	genwqe->vport = vport;
 	genwqe->retry = retry;
@@ -534,7 +534,7 @@ __lpfc_nvme_ls_req(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		      struct nvmefc_ls_req *pnvme_lsreq,
 		      void (*gen_req_cmp)(struct lpfc_hba *phba,
 				struct lpfc_iocbq *cmdwqe,
-				struct lpfc_iocbq *rspwqe))
+				struct lpfc_wcqe_complete *wcqe))
 {
 	struct lpfc_dmabuf *bmp;
 	struct ulp_bde64 *bpl;
@@ -722,7 +722,7 @@ __lpfc_nvme_ls_abort(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	spin_lock(&pring->ring_lock);
 	list_for_each_entry_safe(wqe, next_wqe, &pring->txcmplq, list) {
 		if (wqe->context2 == pnvme_lsreq) {
-			wqe->cmd_flag |= LPFC_DRIVER_ABORTED;
+			wqe->iocb_flag |= LPFC_DRIVER_ABORTED;
 			foundit = true;
 			break;
 		}
@@ -906,7 +906,7 @@ lpfc_nvme_adj_fcp_sgls(struct lpfc_vport *vport,
 
 
 /*
- * lpfc_nvme_io_cmd_cmpl - Complete an NVME-over-FCP IO
+ * lpfc_nvme_io_cmd_wqe_cmpl - Complete an NVME-over-FCP IO
  *
  * Driver registers this routine as it io request handler.  This
  * routine issues an fcp WQE with data from the @lpfc_nvme_fcpreq
@@ -917,12 +917,11 @@ lpfc_nvme_adj_fcp_sgls(struct lpfc_vport *vport,
  *   TODO: What are the failure codes.
  **/
 static void
-lpfc_nvme_io_cmd_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
-		      struct lpfc_iocbq *pwqeOut)
+lpfc_nvme_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
+			  struct lpfc_wcqe_complete *wcqe)
 {
 	struct lpfc_io_buf *lpfc_ncmd =
 		(struct lpfc_io_buf *)pwqeIn->context1;
-	struct lpfc_wcqe_complete *wcqe = &pwqeOut->wcqe_cmpl;
 	struct lpfc_vport *vport = pwqeIn->vport;
 	struct nvmefc_fcp_req *nCmd;
 	struct nvme_fc_ersp_iu *ep;
@@ -1874,7 +1873,7 @@ lpfc_nvme_fcp_abort(struct nvme_fc_local_port *pnvme_lport,
 	}
 
 	/* Don't abort IOs no longer on the pending queue. */
-	if (!(nvmereq_wqe->cmd_flag & LPFC_IO_ON_TXCMPLQ)) {
+	if (!(nvmereq_wqe->iocb_flag & LPFC_IO_ON_TXCMPLQ)) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
 				 "6142 NVME IO req x%px not queued - skipping "
 				 "abort req xri x%x\n",
@@ -1888,7 +1887,7 @@ lpfc_nvme_fcp_abort(struct nvme_fc_local_port *pnvme_lport,
 			 nvmereq_wqe->hba_wqidx, pnvme_rport->port_id);
 
 	/* Outstanding abort is in progress */
-	if (nvmereq_wqe->cmd_flag & LPFC_DRIVER_ABORTED) {
+	if (nvmereq_wqe->iocb_flag & LPFC_DRIVER_ABORTED) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
 				 "6144 Outstanding NVME I/O Abort Request "
 				 "still pending on nvme_fcreq x%px, "
@@ -1983,8 +1982,8 @@ lpfc_get_nvme_buf(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp,
 		/* Setup key fields in buffer that may have been changed
 		 * if other protocols used this buffer.
 		 */
-		pwqeq->cmd_flag = LPFC_IO_NVME;
-		pwqeq->cmd_cmpl = lpfc_nvme_io_cmd_cmpl;
+		pwqeq->iocb_flag = LPFC_IO_NVME;
+		pwqeq->wqe_cmpl = lpfc_nvme_io_cmd_wqe_cmpl;
 		lpfc_ncmd->start_time = jiffies;
 		lpfc_ncmd->flags = 0;
 
@@ -2750,7 +2749,6 @@ lpfc_nvme_cancel_iocb(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 	if (phba->sli.sli_flag & LPFC_SLI_ACTIVE)
 		bf_set(lpfc_wcqe_c_xb, wcqep, 1);
 
-	memcpy(&pwqeIn->wcqe_cmpl, wcqep, sizeof(*wcqep));
-	(pwqeIn->cmd_cmpl)(phba, pwqeIn, pwqeIn);
+	(pwqeIn->wqe_cmpl)(phba, pwqeIn, wcqep);
 #endif
 }
diff --git a/drivers/scsi/lpfc/lpfc_nvme.h b/drivers/scsi/lpfc/lpfc_nvme.h
index d7698977725e..cc54ffb5c205 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.h
+++ b/drivers/scsi/lpfc/lpfc_nvme.h
@@ -234,7 +234,7 @@ int __lpfc_nvme_ls_req(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		struct nvmefc_ls_req *pnvme_lsreq,
 		void (*gen_req_cmp)(struct lpfc_hba *phba,
 				struct lpfc_iocbq *cmdwqe,
-				struct lpfc_iocbq *rspwqe));
+				struct lpfc_wcqe_complete *wcqe));
 void __lpfc_nvme_ls_req_cmp(struct lpfc_hba *phba,  struct lpfc_vport *vport,
 		struct lpfc_iocbq *cmdwqe, struct lpfc_wcqe_complete *wcqe);
 int __lpfc_nvme_ls_abort(struct lpfc_vport *vport,
@@ -248,6 +248,6 @@ int __lpfc_nvme_xmt_ls_rsp(struct lpfc_async_xchg_ctx *axchg,
 			struct nvmefc_ls_rsp *ls_rsp,
 			void (*xmt_ls_rsp_cmp)(struct lpfc_hba *phba,
 				struct lpfc_iocbq *cmdwqe,
-				struct lpfc_iocbq *rspwqe));
+				struct lpfc_wcqe_complete *wcqe));
 void __lpfc_nvme_xmt_ls_rsp_cmp(struct lpfc_hba *phba,
-		struct lpfc_iocbq *cmdwqe, struct lpfc_iocbq *rspwqe);
+		struct lpfc_iocbq *cmdwqe, struct lpfc_wcqe_complete *wcqe);
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index 5188cc8e2413..6e3dd0b9bcfa 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -285,7 +285,7 @@ lpfc_nvmet_defer_release(struct lpfc_hba *phba,
  *         transmission of an NVME LS response.
  * @phba: Pointer to HBA context object.
  * @cmdwqe: Pointer to driver command WQE object.
- * @rspwqe: Pointer to driver response WQE object.
+ * @wcqe: Pointer to driver response CQE object.
  *
  * The function is called from SLI ring event handler with no
  * lock held. The function frees memory resources used for the command
@@ -293,10 +293,9 @@ lpfc_nvmet_defer_release(struct lpfc_hba *phba,
  **/
 void
 __lpfc_nvme_xmt_ls_rsp_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
-			   struct lpfc_iocbq *rspwqe)
+			   struct lpfc_wcqe_complete *wcqe)
 {
 	struct lpfc_async_xchg_ctx *axchg = cmdwqe->context2;
-	struct lpfc_wcqe_complete *wcqe = &rspwqe->wcqe_cmpl;
 	struct nvmefc_ls_rsp *ls_rsp = &axchg->ls_rsp;
 	uint32_t status, result;
 
@@ -332,7 +331,7 @@ __lpfc_nvme_xmt_ls_rsp_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
  * lpfc_nvmet_xmt_ls_rsp_cmp - Completion handler for LS Response
  * @phba: Pointer to HBA context object.
  * @cmdwqe: Pointer to driver command WQE object.
- * @rspwqe: Pointer to driver response WQE object.
+ * @wcqe: Pointer to driver response CQE object.
  *
  * The function is called from SLI ring event handler with no
  * lock held. This function is the completion handler for NVME LS commands
@@ -341,11 +340,10 @@ __lpfc_nvme_xmt_ls_rsp_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
  **/
 static void
 lpfc_nvmet_xmt_ls_rsp_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
-			  struct lpfc_iocbq *rspwqe)
+			  struct lpfc_wcqe_complete *wcqe)
 {
 	struct lpfc_nvmet_tgtport *tgtp;
 	uint32_t status, result;
-	struct lpfc_wcqe_complete *wcqe = &rspwqe->wcqe_cmpl;
 
 	if (!phba->targetport)
 		goto finish;
@@ -367,7 +365,7 @@ lpfc_nvmet_xmt_ls_rsp_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
 	}
 
 finish:
-	__lpfc_nvme_xmt_ls_rsp_cmp(phba, cmdwqe, rspwqe);
+	__lpfc_nvme_xmt_ls_rsp_cmp(phba, cmdwqe, wcqe);
 }
 
 /**
@@ -709,7 +707,7 @@ lpfc_nvmet_ktime(struct lpfc_hba *phba,
  * lpfc_nvmet_xmt_fcp_op_cmp - Completion handler for FCP Response
  * @phba: Pointer to HBA context object.
  * @cmdwqe: Pointer to driver command WQE object.
- * @rspwqe: Pointer to driver response WQE object.
+ * @wcqe: Pointer to driver response CQE object.
  *
  * The function is called from SLI ring event handler with no
  * lock held. This function is the completion handler for NVME FCP commands
@@ -717,13 +715,12 @@ lpfc_nvmet_ktime(struct lpfc_hba *phba,
  **/
 static void
 lpfc_nvmet_xmt_fcp_op_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
-			  struct lpfc_iocbq *rspwqe)
+			  struct lpfc_wcqe_complete *wcqe)
 {
 	struct lpfc_nvmet_tgtport *tgtp;
 	struct nvmefc_tgt_fcp_req *rsp;
 	struct lpfc_async_xchg_ctx *ctxp;
 	uint32_t status, result, op, start_clean, logerr;
-	struct lpfc_wcqe_complete *wcqe = &rspwqe->wcqe_cmpl;
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	int id;
 #endif
@@ -820,7 +817,7 @@ lpfc_nvmet_xmt_fcp_op_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
 		/* lpfc_nvmet_xmt_fcp_release() will recycle the context */
 	} else {
 		ctxp->entry_cnt++;
-		start_clean = offsetof(struct lpfc_iocbq, cmd_flag);
+		start_clean = offsetof(struct lpfc_iocbq, iocb_flag);
 		memset(((char *)cmdwqe) + start_clean, 0,
 		       (sizeof(struct lpfc_iocbq) - start_clean));
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
@@ -865,7 +862,7 @@ __lpfc_nvme_xmt_ls_rsp(struct lpfc_async_xchg_ctx *axchg,
 			struct nvmefc_ls_rsp *ls_rsp,
 			void (*xmt_ls_rsp_cmp)(struct lpfc_hba *phba,
 				struct lpfc_iocbq *cmdwqe,
-				struct lpfc_iocbq *rspwqe))
+				struct lpfc_wcqe_complete *wcqe))
 {
 	struct lpfc_hba *phba = axchg->phba;
 	struct hbq_dmabuf *nvmebuf = (struct hbq_dmabuf *)axchg->rqb_buffer;
@@ -901,7 +898,7 @@ __lpfc_nvme_xmt_ls_rsp(struct lpfc_async_xchg_ctx *axchg,
 	}
 
 	/* Save numBdes for bpl2sgl */
-	nvmewqeq->num_bdes = 1;
+	nvmewqeq->rsvd2 = 1;
 	nvmewqeq->hba_wqidx = 0;
 	nvmewqeq->context3 = &dmabuf;
 	dmabuf.virt = &bpl;
@@ -916,7 +913,8 @@ __lpfc_nvme_xmt_ls_rsp(struct lpfc_async_xchg_ctx *axchg,
 	 * be referenced after it returns back to this routine.
 	 */
 
-	nvmewqeq->cmd_cmpl = xmt_ls_rsp_cmp;
+	nvmewqeq->wqe_cmpl = xmt_ls_rsp_cmp;
+	nvmewqeq->iocb_cmpl = NULL;
 	nvmewqeq->context2 = axchg;
 
 	lpfc_nvmeio_data(phba, "NVMEx LS RSP: xri x%x wqidx x%x len x%x\n",
@@ -1074,9 +1072,10 @@ lpfc_nvmet_xmt_fcp_op(struct nvmet_fc_target_port *tgtport,
 		goto aerr;
 	}
 
-	nvmewqeq->cmd_cmpl = lpfc_nvmet_xmt_fcp_op_cmp;
+	nvmewqeq->wqe_cmpl = lpfc_nvmet_xmt_fcp_op_cmp;
+	nvmewqeq->iocb_cmpl = NULL;
 	nvmewqeq->context2 = ctxp;
-	nvmewqeq->cmd_flag |=  LPFC_IO_NVMET;
+	nvmewqeq->iocb_flag |=  LPFC_IO_NVMET;
 	ctxp->wqeq->hba_wqidx = rsp->hwqid;
 
 	lpfc_nvmeio_data(phba, "NVMET FCP CMND: xri x%x op x%x len x%x\n",
@@ -1276,7 +1275,7 @@ lpfc_nvmet_defer_rcv(struct nvmet_fc_target_port *tgtport,
  * lpfc_nvmet_ls_req_cmp - completion handler for a nvme ls request
  * @phba: Pointer to HBA context object
  * @cmdwqe: Pointer to driver command WQE object.
- * @rspwqe: Pointer to driver response WQE object.
+ * @wcqe: Pointer to driver response CQE object.
  *
  * This function is the completion handler for NVME LS requests.
  * The function updates any states and statistics, then calls the
@@ -1284,9 +1283,8 @@ lpfc_nvmet_defer_rcv(struct nvmet_fc_target_port *tgtport,
  **/
 static void
 lpfc_nvmet_ls_req_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
-		      struct lpfc_iocbq *rspwqe)
+		       struct lpfc_wcqe_complete *wcqe)
 {
-	struct lpfc_wcqe_complete *wcqe = &rspwqe->wcqe_cmpl;
 	__lpfc_nvme_ls_req_cmp(phba, cmdwqe->vport, cmdwqe, wcqe);
 }
 
@@ -1583,7 +1581,7 @@ lpfc_nvmet_setup_io_context(struct lpfc_hba *phba)
 					"6406 Ran out of NVMET iocb/WQEs\n");
 			return -ENOMEM;
 		}
-		ctx_buf->iocbq->cmd_flag = LPFC_IO_NVMET;
+		ctx_buf->iocbq->iocb_flag = LPFC_IO_NVMET;
 		nvmewqe = ctx_buf->iocbq;
 		wqe = &nvmewqe->wqe;
 
@@ -2029,10 +2027,8 @@ lpfc_nvmet_wqfull_flush(struct lpfc_hba *phba, struct lpfc_queue *wq,
 				list_del(&nvmewqeq->list);
 				spin_unlock_irqrestore(&pring->ring_lock,
 						       iflags);
-				memcpy(&nvmewqeq->wcqe_cmpl, wcqep,
-				       sizeof(*wcqep));
 				lpfc_nvmet_xmt_fcp_op_cmp(phba, nvmewqeq,
-							  nvmewqeq);
+							  wcqep);
 				return;
 			}
 			continue;
@@ -2040,8 +2036,7 @@ lpfc_nvmet_wqfull_flush(struct lpfc_hba *phba, struct lpfc_queue *wq,
 			/* Flush all IOs */
 			list_del(&nvmewqeq->list);
 			spin_unlock_irqrestore(&pring->ring_lock, iflags);
-			memcpy(&nvmewqeq->wcqe_cmpl, wcqep, sizeof(*wcqep));
-			lpfc_nvmet_xmt_fcp_op_cmp(phba, nvmewqeq, nvmewqeq);
+			lpfc_nvmet_xmt_fcp_op_cmp(phba, nvmewqeq, wcqep);
 			spin_lock_irqsave(&pring->ring_lock, iflags);
 		}
 	}
@@ -2681,7 +2676,7 @@ lpfc_nvmet_prep_ls_wqe(struct lpfc_hba *phba,
 	nvmewqe->retry = 1;
 	nvmewqe->vport = phba->pport;
 	nvmewqe->drvrTimeout = (phba->fc_ratov * 3) + LPFC_DRVR_TIMEOUT;
-	nvmewqe->cmd_flag |= LPFC_IO_NVME_LS;
+	nvmewqe->iocb_flag |= LPFC_IO_NVME_LS;
 
 	/* Xmit NVMET response to remote NPORT <did> */
 	lpfc_printf_log(phba, KERN_INFO, LOG_NVME_DISC,
@@ -3038,7 +3033,7 @@ lpfc_nvmet_prep_fcp_wqe(struct lpfc_hba *phba,
  * lpfc_nvmet_sol_fcp_abort_cmp - Completion handler for ABTS
  * @phba: Pointer to HBA context object.
  * @cmdwqe: Pointer to driver command WQE object.
- * @rspwqe: Pointer to driver response WQE object.
+ * @wcqe: Pointer to driver response CQE object.
  *
  * The function is called from SLI ring event handler with no
  * lock held. This function is the completion handler for NVME ABTS for FCP cmds
@@ -3046,14 +3041,13 @@ lpfc_nvmet_prep_fcp_wqe(struct lpfc_hba *phba,
  **/
 static void
 lpfc_nvmet_sol_fcp_abort_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
-			     struct lpfc_iocbq *rspwqe)
+			     struct lpfc_wcqe_complete *wcqe)
 {
 	struct lpfc_async_xchg_ctx *ctxp;
 	struct lpfc_nvmet_tgtport *tgtp;
 	uint32_t result;
 	unsigned long flags;
 	bool released = false;
-	struct lpfc_wcqe_complete *wcqe = &rspwqe->wcqe_cmpl;
 
 	ctxp = cmdwqe->context2;
 	result = wcqe->parameter;
@@ -3108,7 +3102,7 @@ lpfc_nvmet_sol_fcp_abort_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
  * lpfc_nvmet_unsol_fcp_abort_cmp - Completion handler for ABTS
  * @phba: Pointer to HBA context object.
  * @cmdwqe: Pointer to driver command WQE object.
- * @rspwqe: Pointer to driver response WQE object.
+ * @wcqe: Pointer to driver response CQE object.
  *
  * The function is called from SLI ring event handler with no
  * lock held. This function is the completion handler for NVME ABTS for FCP cmds
@@ -3116,14 +3110,13 @@ lpfc_nvmet_sol_fcp_abort_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
  **/
 static void
 lpfc_nvmet_unsol_fcp_abort_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
-			       struct lpfc_iocbq *rspwqe)
+			       struct lpfc_wcqe_complete *wcqe)
 {
 	struct lpfc_async_xchg_ctx *ctxp;
 	struct lpfc_nvmet_tgtport *tgtp;
 	unsigned long flags;
 	uint32_t result;
 	bool released = false;
-	struct lpfc_wcqe_complete *wcqe = &rspwqe->wcqe_cmpl;
 
 	ctxp = cmdwqe->context2;
 	result = wcqe->parameter;
@@ -3190,7 +3183,7 @@ lpfc_nvmet_unsol_fcp_abort_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
  * lpfc_nvmet_xmt_ls_abort_cmp - Completion handler for ABTS
  * @phba: Pointer to HBA context object.
  * @cmdwqe: Pointer to driver command WQE object.
- * @rspwqe: Pointer to driver response WQE object.
+ * @wcqe: Pointer to driver response CQE object.
  *
  * The function is called from SLI ring event handler with no
  * lock held. This function is the completion handler for NVME ABTS for LS cmds
@@ -3198,12 +3191,11 @@ lpfc_nvmet_unsol_fcp_abort_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
  **/
 static void
 lpfc_nvmet_xmt_ls_abort_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
-			    struct lpfc_iocbq *rspwqe)
+			    struct lpfc_wcqe_complete *wcqe)
 {
 	struct lpfc_async_xchg_ctx *ctxp;
 	struct lpfc_nvmet_tgtport *tgtp;
 	uint32_t result;
-	struct lpfc_wcqe_complete *wcqe = &rspwqe->wcqe_cmpl;
 
 	ctxp = cmdwqe->context2;
 	result = wcqe->parameter;
@@ -3327,7 +3319,7 @@ lpfc_nvmet_unsol_issue_abort(struct lpfc_hba *phba,
 	abts_wqeq->context1 = ndlp;
 	abts_wqeq->context2 = ctxp;
 	abts_wqeq->context3 = NULL;
-	abts_wqeq->num_bdes = 0;
+	abts_wqeq->rsvd2 = 0;
 	/* hba_wqidx should already be setup from command we are aborting */
 	abts_wqeq->iocb.ulpCommand = CMD_XMIT_SEQUENCE64_CR;
 	abts_wqeq->iocb.ulpLe = 1;
@@ -3456,7 +3448,7 @@ lpfc_nvmet_sol_fcp_issue_abort(struct lpfc_hba *phba,
 	}
 
 	/* Outstanding abort is in progress */
-	if (abts_wqeq->cmd_flag & LPFC_DRIVER_ABORTED) {
+	if (abts_wqeq->iocb_flag & LPFC_DRIVER_ABORTED) {
 		spin_unlock_irqrestore(&phba->hbalock, flags);
 		atomic_inc(&tgtp->xmt_abort_rsp_error);
 		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
@@ -3471,14 +3463,15 @@ lpfc_nvmet_sol_fcp_issue_abort(struct lpfc_hba *phba,
 	}
 
 	/* Ready - mark outstanding as aborted by driver. */
-	abts_wqeq->cmd_flag |= LPFC_DRIVER_ABORTED;
+	abts_wqeq->iocb_flag |= LPFC_DRIVER_ABORTED;
 
 	lpfc_nvmet_prep_abort_wqe(abts_wqeq, ctxp->wqeq->sli4_xritag, opt);
 
 	/* ABTS WQE must go to the same WQ as the WQE to be aborted */
 	abts_wqeq->hba_wqidx = ctxp->wqeq->hba_wqidx;
-	abts_wqeq->cmd_cmpl = lpfc_nvmet_sol_fcp_abort_cmp;
-	abts_wqeq->cmd_flag |= LPFC_IO_NVME;
+	abts_wqeq->wqe_cmpl = lpfc_nvmet_sol_fcp_abort_cmp;
+	abts_wqeq->iocb_cmpl = NULL;
+	abts_wqeq->iocb_flag |= LPFC_IO_NVME;
 	abts_wqeq->context2 = ctxp;
 	abts_wqeq->vport = phba->pport;
 	if (!ctxp->hdwq)
@@ -3535,8 +3528,9 @@ lpfc_nvmet_unsol_fcp_issue_abort(struct lpfc_hba *phba,
 
 	spin_lock_irqsave(&phba->hbalock, flags);
 	abts_wqeq = ctxp->wqeq;
-	abts_wqeq->cmd_cmpl = lpfc_nvmet_unsol_fcp_abort_cmp;
-	abts_wqeq->cmd_flag |= LPFC_IO_NVMET;
+	abts_wqeq->wqe_cmpl = lpfc_nvmet_unsol_fcp_abort_cmp;
+	abts_wqeq->iocb_cmpl = NULL;
+	abts_wqeq->iocb_flag |= LPFC_IO_NVMET;
 	if (!ctxp->hdwq)
 		ctxp->hdwq = &phba->sli4_hba.hdwq[abts_wqeq->hba_wqidx];
 
@@ -3620,8 +3614,9 @@ lpfc_nvme_unsol_ls_issue_abort(struct lpfc_hba *phba,
 	}
 
 	spin_lock_irqsave(&phba->hbalock, flags);
-	abts_wqeq->cmd_cmpl = lpfc_nvmet_xmt_ls_abort_cmp;
-	abts_wqeq->cmd_flag |=  LPFC_IO_NVME_LS;
+	abts_wqeq->wqe_cmpl = lpfc_nvmet_xmt_ls_abort_cmp;
+	abts_wqeq->iocb_cmpl = NULL;
+	abts_wqeq->iocb_flag |=  LPFC_IO_NVME_LS;
 	rc = lpfc_sli4_issue_wqe(phba, ctxp->hdwq, abts_wqeq);
 	spin_unlock_irqrestore(&phba->hbalock, flags);
 	if (rc == WQE_SUCCESS) {
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 41313fcaf84a..edae98a35fc3 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -362,7 +362,7 @@ lpfc_new_scsi_buf_s3(struct lpfc_vport *vport, int num_to_alloc)
 			kfree(psb);
 			break;
 		}
-		psb->cur_iocbq.cmd_flag |= LPFC_IO_FCP;
+		psb->cur_iocbq.iocb_flag |= LPFC_IO_FCP;
 
 		psb->fcp_cmnd = psb->data;
 		psb->fcp_rsp = psb->data + sizeof(struct fcp_cmnd);
@@ -468,7 +468,7 @@ lpfc_sli4_vport_delete_fcp_xri_aborted(struct lpfc_vport *vport)
 		spin_lock(&qp->abts_io_buf_list_lock);
 		list_for_each_entry_safe(psb, next_psb,
 					 &qp->lpfc_abts_io_buf_list, list) {
-			if (psb->cur_iocbq.cmd_flag & LPFC_IO_NVME)
+			if (psb->cur_iocbq.iocb_flag & LPFC_IO_NVME)
 				continue;
 
 			if (psb->rdata && psb->rdata->pnode &&
@@ -524,7 +524,7 @@ lpfc_sli4_io_xri_aborted(struct lpfc_hba *phba,
 			list_del_init(&psb->list);
 			psb->flags &= ~LPFC_SBUF_XBUSY;
 			psb->status = IOSTAT_SUCCESS;
-			if (psb->cur_iocbq.cmd_flag & LPFC_IO_NVME) {
+			if (psb->cur_iocbq.iocb_flag & LPFC_IO_NVME) {
 				qp->abts_nvme_io_bufs--;
 				spin_unlock(&qp->abts_io_buf_list_lock);
 				spin_unlock_irqrestore(&phba->hbalock, iflag);
@@ -571,7 +571,7 @@ lpfc_sli4_io_xri_aborted(struct lpfc_hba *phba,
 				 * for command completion wake up the thread.
 				 */
 				spin_lock_irqsave(&psb->buf_lock, iflag);
-				psb->cur_iocbq.cmd_flag &=
+				psb->cur_iocbq.iocb_flag &=
 					~LPFC_DRIVER_ABORTED;
 				if (psb->waitq)
 					wake_up(psb->waitq);
@@ -593,8 +593,8 @@ lpfc_sli4_io_xri_aborted(struct lpfc_hba *phba,
 		for (i = 1; i <= phba->sli.last_iotag; i++) {
 			iocbq = phba->sli.iocbq_lookup[i];
 
-			if (!(iocbq->cmd_flag & LPFC_IO_FCP) ||
-			    (iocbq->cmd_flag & LPFC_IO_LIBDFC))
+			if (!(iocbq->iocb_flag & LPFC_IO_FCP) ||
+			    (iocbq->iocb_flag & LPFC_IO_LIBDFC))
 				continue;
 			if (iocbq->sli4_xritag != xri)
 				continue;
@@ -695,7 +695,7 @@ lpfc_get_scsi_buf_s4(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp,
 	/* Setup key fields in buffer that may have been changed
 	 * if other protocols used this buffer.
 	 */
-	lpfc_cmd->cur_iocbq.cmd_flag = LPFC_IO_FCP;
+	lpfc_cmd->cur_iocbq.iocb_flag = LPFC_IO_FCP;
 	lpfc_cmd->prot_seg_cnt = 0;
 	lpfc_cmd->seg_cnt = 0;
 	lpfc_cmd->timeout = 0;
@@ -783,7 +783,7 @@ lpfc_release_scsi_buf_s3(struct lpfc_hba *phba, struct lpfc_io_buf *psb)
 
 	spin_lock_irqsave(&phba->scsi_buf_list_put_lock, iflag);
 	psb->pCmd = NULL;
-	psb->cur_iocbq.cmd_flag = LPFC_IO_FCP;
+	psb->cur_iocbq.iocb_flag = LPFC_IO_FCP;
 	list_add_tail(&psb->list, &phba->lpfc_scsi_buf_list_put);
 	spin_unlock_irqrestore(&phba->scsi_buf_list_put_lock, iflag);
 }
@@ -931,7 +931,7 @@ lpfc_scsi_prep_dma_buf_s3(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 			physaddr = sg_dma_address(sgel);
 			if (phba->sli_rev == 3 &&
 			    !(phba->sli3_options & LPFC_SLI3_BG_ENABLED) &&
-			    !(iocbq->cmd_flag & DSS_SECURITY_OP) &&
+			    !(iocbq->iocb_flag & DSS_SECURITY_OP) &&
 			    nseg <= LPFC_EXT_DATA_BDE_COUNT) {
 				data_bde->tus.f.bdeFlags = BUFF_TYPE_BDE_64;
 				data_bde->tus.f.bdeSize = sg_dma_len(sgel);
@@ -959,7 +959,7 @@ lpfc_scsi_prep_dma_buf_s3(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 	 */
 	if (phba->sli_rev == 3 &&
 	    !(phba->sli3_options & LPFC_SLI3_BG_ENABLED) &&
-	    !(iocbq->cmd_flag & DSS_SECURITY_OP)) {
+	    !(iocbq->iocb_flag & DSS_SECURITY_OP)) {
 		if (num_bde > LPFC_EXT_DATA_BDE_COUNT) {
 			/*
 			 * The extended IOCB format can only fit 3 BDE or a BPL.
@@ -2942,58 +2942,154 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
  * -1 - Internal error (bad profile, ...etc)
  */
 static int
-lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
-		  struct lpfc_iocbq *pIocbOut)
+lpfc_sli4_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
+		       struct lpfc_wcqe_complete *wcqe)
 {
 	struct scsi_cmnd *cmd = lpfc_cmd->pCmd;
-	struct sli3_bg_fields *bgf;
 	int ret = 0;
-	struct lpfc_wcqe_complete *wcqe;
-	u32 status;
+	u32 status = bf_get(lpfc_wcqe_c_status, wcqe);
 	u32 bghm = 0;
 	u32 bgstat = 0;
 	u64 failing_sector = 0;
 
-	if (phba->sli_rev == LPFC_SLI_REV4) {
-		wcqe = &pIocbOut->wcqe_cmpl;
-		status = bf_get(lpfc_wcqe_c_status, wcqe);
+	if (status == CQE_STATUS_DI_ERROR) {
+		if (bf_get(lpfc_wcqe_c_bg_ge, wcqe)) /* Guard Check failed */
+			bgstat |= BGS_GUARD_ERR_MASK;
+		if (bf_get(lpfc_wcqe_c_bg_ae, wcqe)) /* AppTag Check failed */
+			bgstat |= BGS_APPTAG_ERR_MASK;
+		if (bf_get(lpfc_wcqe_c_bg_re, wcqe)) /* RefTag Check failed */
+			bgstat |= BGS_REFTAG_ERR_MASK;
+
+		/* Check to see if there was any good data before the error */
+		if (bf_get(lpfc_wcqe_c_bg_tdpv, wcqe)) {
+			bgstat |= BGS_HI_WATER_MARK_PRESENT_MASK;
+			bghm = wcqe->total_data_placed;
+		}
 
-		if (status == CQE_STATUS_DI_ERROR) {
-			/* Guard Check failed */
-			if (bf_get(lpfc_wcqe_c_bg_ge, wcqe))
-				bgstat |= BGS_GUARD_ERR_MASK;
+		/*
+		 * Set ALL the error bits to indicate we don't know what
+		 * type of error it is.
+		 */
+		if (!bgstat)
+			bgstat |= (BGS_REFTAG_ERR_MASK | BGS_APPTAG_ERR_MASK |
+				BGS_GUARD_ERR_MASK);
+	}
 
-			/* AppTag Check failed */
-			if (bf_get(lpfc_wcqe_c_bg_ae, wcqe))
-				bgstat |= BGS_APPTAG_ERR_MASK;
+	if (lpfc_bgs_get_guard_err(bgstat)) {
+		ret = 1;
 
-			/* RefTag Check failed */
-			if (bf_get(lpfc_wcqe_c_bg_re, wcqe))
-				bgstat |= BGS_REFTAG_ERR_MASK;
+		scsi_build_sense(cmd, 1, ILLEGAL_REQUEST, 0x10, 0x1);
+		set_host_byte(cmd, DID_ABORT);
+		phba->bg_guard_err_cnt++;
+		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
+				"9059 BLKGRD: Guard Tag error in cmd"
+				" 0x%x lba 0x%llx blk cnt 0x%x "
+				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
+				(unsigned long long)scsi_get_lba(cmd),
+				scsi_logical_block_count(cmd), bgstat, bghm);
+	}
 
-			/* Check to see if there was any good data before the
-			 * error
-			 */
-			if (bf_get(lpfc_wcqe_c_bg_tdpv, wcqe)) {
-				bgstat |= BGS_HI_WATER_MARK_PRESENT_MASK;
-				bghm = wcqe->total_data_placed;
-			}
+	if (lpfc_bgs_get_reftag_err(bgstat)) {
+		ret = 1;
 
-			/*
-			 * Set ALL the error bits to indicate we don't know what
-			 * type of error it is.
-			 */
-			if (!bgstat)
-				bgstat |= (BGS_REFTAG_ERR_MASK |
-					   BGS_APPTAG_ERR_MASK |
-					   BGS_GUARD_ERR_MASK);
+		scsi_build_sense(cmd, 1, ILLEGAL_REQUEST, 0x10, 0x3);
+		set_host_byte(cmd, DID_ABORT);
+
+		phba->bg_reftag_err_cnt++;
+		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
+				"9060 BLKGRD: Ref Tag error in cmd"
+				" 0x%x lba 0x%llx blk cnt 0x%x "
+				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
+				(unsigned long long)scsi_get_lba(cmd),
+				scsi_logical_block_count(cmd), bgstat, bghm);
+	}
+
+	if (lpfc_bgs_get_apptag_err(bgstat)) {
+		ret = 1;
+
+		scsi_build_sense(cmd, 1, ILLEGAL_REQUEST, 0x10, 0x2);
+		set_host_byte(cmd, DID_ABORT);
+
+		phba->bg_apptag_err_cnt++;
+		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
+				"9062 BLKGRD: App Tag error in cmd"
+				" 0x%x lba 0x%llx blk cnt 0x%x "
+				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
+				(unsigned long long)scsi_get_lba(cmd),
+				scsi_logical_block_count(cmd), bgstat, bghm);
+	}
+
+	if (lpfc_bgs_get_hi_water_mark_present(bgstat)) {
+		/*
+		 * setup sense data descriptor 0 per SPC-4 as an information
+		 * field, and put the failing LBA in it.
+		 * This code assumes there was also a guard/app/ref tag error
+		 * indication.
+		 */
+		cmd->sense_buffer[7] = 0xc;   /* Additional sense length */
+		cmd->sense_buffer[8] = 0;     /* Information descriptor type */
+		cmd->sense_buffer[9] = 0xa;   /* Additional descriptor length */
+		cmd->sense_buffer[10] = 0x80; /* Validity bit */
+
+		/* bghm is a "on the wire" FC frame based count */
+		switch (scsi_get_prot_op(cmd)) {
+		case SCSI_PROT_READ_INSERT:
+		case SCSI_PROT_WRITE_STRIP:
+			bghm /= cmd->device->sector_size;
+			break;
+		case SCSI_PROT_READ_STRIP:
+		case SCSI_PROT_WRITE_INSERT:
+		case SCSI_PROT_READ_PASS:
+		case SCSI_PROT_WRITE_PASS:
+			bghm /= (cmd->device->sector_size +
+				sizeof(struct scsi_dif_tuple));
+			break;
 		}
 
-	} else {
-		bgf = &pIocbOut->iocb.unsli3.sli3_bg;
-		bghm = bgf->bghm;
-		bgstat = bgf->bgstat;
+		failing_sector = scsi_get_lba(cmd);
+		failing_sector += bghm;
+
+		/* Descriptor Information */
+		put_unaligned_be64(failing_sector, &cmd->sense_buffer[12]);
+	}
+
+	if (!ret) {
+		/* No error was reported - problem in FW? */
+		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
+				"9068 BLKGRD: Unknown error in cmd"
+				" 0x%x lba 0x%llx blk cnt 0x%x "
+				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
+				(unsigned long long)scsi_get_lba(cmd),
+				scsi_logical_block_count(cmd), bgstat, bghm);
+
+		/* Calculate what type of error it was */
+		lpfc_calc_bg_err(phba, lpfc_cmd);
 	}
+	return ret;
+}
+
+/*
+ * This function checks for BlockGuard errors detected by
+ * the HBA.  In case of errors, the ASC/ASCQ fields in the
+ * sense buffer will be set accordingly, paired with
+ * ILLEGAL_REQUEST to signal to the kernel that the HBA
+ * detected corruption.
+ *
+ * Returns:
+ *  0 - No error found
+ *  1 - BlockGuard error found
+ * -1 - Internal error (bad profile, ...etc)
+ */
+static int
+lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
+		  struct lpfc_iocbq *pIocbOut)
+{
+	struct scsi_cmnd *cmd = lpfc_cmd->pCmd;
+	struct sli3_bg_fields *bgf = &pIocbOut->iocb.unsli3.sli3_bg;
+	int ret = 0;
+	uint32_t bghm = bgf->bghm;
+	uint32_t bgstat = bgf->bgstat;
+	uint64_t failing_sector = 0;
 
 	if (lpfc_bgs_get_invalid_prof(bgstat)) {
 		cmd->result = DID_ERROR << 16;
@@ -3021,6 +3117,7 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 
 	if (lpfc_bgs_get_guard_err(bgstat)) {
 		ret = 1;
+
 		scsi_build_sense(cmd, 1, ILLEGAL_REQUEST, 0x10, 0x1);
 		set_host_byte(cmd, DID_ABORT);
 		phba->bg_guard_err_cnt++;
@@ -3034,8 +3131,10 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 
 	if (lpfc_bgs_get_reftag_err(bgstat)) {
 		ret = 1;
+
 		scsi_build_sense(cmd, 1, ILLEGAL_REQUEST, 0x10, 0x3);
 		set_host_byte(cmd, DID_ABORT);
+
 		phba->bg_reftag_err_cnt++;
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
 				"9056 BLKGRD: Ref Tag error in cmd "
@@ -3047,8 +3146,10 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 
 	if (lpfc_bgs_get_apptag_err(bgstat)) {
 		ret = 1;
+
 		scsi_build_sense(cmd, 1, ILLEGAL_REQUEST, 0x10, 0x2);
 		set_host_byte(cmd, DID_ABORT);
+
 		phba->bg_apptag_err_cnt++;
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
 				"9061 BLKGRD: App Tag error in cmd "
@@ -3333,7 +3434,7 @@ lpfc_scsi_prep_dma_buf_s4(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 	 */
 	if ((phba->cfg_fof) && ((struct lpfc_device_data *)
 		scsi_cmnd->device->hostdata)->oas_enabled) {
-		lpfc_cmd->cur_iocbq.cmd_flag |= (LPFC_IO_OAS | LPFC_IO_FOF);
+		lpfc_cmd->cur_iocbq.iocb_flag |= (LPFC_IO_OAS | LPFC_IO_FOF);
 		lpfc_cmd->cur_iocbq.priority = ((struct lpfc_device_data *)
 			scsi_cmnd->device->hostdata)->priority;
 
@@ -3490,15 +3591,15 @@ lpfc_bg_scsi_prep_dma_buf_s4(struct lpfc_hba *phba,
 	switch (scsi_get_prot_op(scsi_cmnd)) {
 	case SCSI_PROT_WRITE_STRIP:
 	case SCSI_PROT_READ_STRIP:
-		lpfc_cmd->cur_iocbq.cmd_flag |= LPFC_IO_DIF_STRIP;
+		lpfc_cmd->cur_iocbq.iocb_flag |= LPFC_IO_DIF_STRIP;
 		break;
 	case SCSI_PROT_WRITE_INSERT:
 	case SCSI_PROT_READ_INSERT:
-		lpfc_cmd->cur_iocbq.cmd_flag |= LPFC_IO_DIF_INSERT;
+		lpfc_cmd->cur_iocbq.iocb_flag |= LPFC_IO_DIF_INSERT;
 		break;
 	case SCSI_PROT_WRITE_PASS:
 	case SCSI_PROT_READ_PASS:
-		lpfc_cmd->cur_iocbq.cmd_flag |= LPFC_IO_DIF_PASS;
+		lpfc_cmd->cur_iocbq.iocb_flag |= LPFC_IO_DIF_PASS;
 		break;
 	}
 
@@ -3529,7 +3630,7 @@ lpfc_bg_scsi_prep_dma_buf_s4(struct lpfc_hba *phba,
 	 */
 	if ((phba->cfg_fof) && ((struct lpfc_device_data *)
 		scsi_cmnd->device->hostdata)->oas_enabled) {
-		lpfc_cmd->cur_iocbq.cmd_flag |= (LPFC_IO_OAS | LPFC_IO_FOF);
+		lpfc_cmd->cur_iocbq.iocb_flag |= (LPFC_IO_OAS | LPFC_IO_FOF);
 
 		/* Word 10 */
 		bf_set(wqe_oas, &wqe->generic.wqe_com, 1);
@@ -3539,14 +3640,14 @@ lpfc_bg_scsi_prep_dma_buf_s4(struct lpfc_hba *phba,
 	}
 
 	/* Word 7. DIF Flags */
-	if (lpfc_cmd->cur_iocbq.cmd_flag & LPFC_IO_DIF_PASS)
+	if (lpfc_cmd->cur_iocbq.iocb_flag & LPFC_IO_DIF_PASS)
 		bf_set(wqe_dif, &wqe->generic.wqe_com, LPFC_WQE_DIF_PASSTHRU);
-	else if (lpfc_cmd->cur_iocbq.cmd_flag & LPFC_IO_DIF_STRIP)
+	else if (lpfc_cmd->cur_iocbq.iocb_flag & LPFC_IO_DIF_STRIP)
 		bf_set(wqe_dif, &wqe->generic.wqe_com, LPFC_WQE_DIF_STRIP);
-	else if (lpfc_cmd->cur_iocbq.cmd_flag & LPFC_IO_DIF_INSERT)
+	else if (lpfc_cmd->cur_iocbq.iocb_flag & LPFC_IO_DIF_INSERT)
 		bf_set(wqe_dif, &wqe->generic.wqe_com, LPFC_WQE_DIF_INSERT);
 
-	lpfc_cmd->cur_iocbq.cmd_flag &= ~(LPFC_IO_DIF_PASS |
+	lpfc_cmd->cur_iocbq.iocb_flag &= ~(LPFC_IO_DIF_PASS |
 				 LPFC_IO_DIF_STRIP | LPFC_IO_DIF_INSERT);
 
 	return 0;
@@ -4071,7 +4172,7 @@ lpfc_handle_fcp_err(struct lpfc_vport *vport, struct lpfc_io_buf *lpfc_cmd,
  * lpfc_fcp_io_cmd_wqe_cmpl - Complete a FCP IO
  * @phba: The hba for which this call is being executed.
  * @pwqeIn: The command WQE for the scsi cmnd.
- * @pwqeOut: Pointer to driver response WQE object.
+ * @wcqe: Pointer to driver response CQE object.
  *
  * This routine assigns scsi command result by looking into response WQE
  * status field appropriately. This routine handles QUEUE FULL condition as
@@ -4079,11 +4180,10 @@ lpfc_handle_fcp_err(struct lpfc_vport *vport, struct lpfc_io_buf *lpfc_cmd,
  **/
 static void
 lpfc_fcp_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
-			 struct lpfc_iocbq *pwqeOut)
+			 struct lpfc_wcqe_complete *wcqe)
 {
 	struct lpfc_io_buf *lpfc_cmd =
 		(struct lpfc_io_buf *)pwqeIn->context1;
-	struct lpfc_wcqe_complete *wcqe = &pwqeOut->wcqe_cmpl;
 	struct lpfc_vport *vport = pwqeIn->vport;
 	struct lpfc_rport_data *rdata;
 	struct lpfc_nodelist *ndlp;
@@ -4093,6 +4193,7 @@ lpfc_fcp_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 	struct Scsi_Host *shost;
 	u32 logit = LOG_FCP;
 	u32 status, idx;
+	unsigned long iflags = 0;
 	u32 lat;
 	u8 wait_xb_clr = 0;
 
@@ -4107,16 +4208,30 @@ lpfc_fcp_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 	rdata = lpfc_cmd->rdata;
 	ndlp = rdata->pnode;
 
+	if (bf_get(lpfc_wcqe_c_xb, wcqe)) {
+		/* TOREMOVE - currently this flag is checked during
+		 * the release of lpfc_iocbq. Remove once we move
+		 * to lpfc_wqe_job construct.
+		 *
+		 * This needs to be done outside buf_lock
+		 */
+		spin_lock_irqsave(&phba->hbalock, iflags);
+		lpfc_cmd->cur_iocbq.iocb_flag |= LPFC_EXCHANGE_BUSY;
+		spin_unlock_irqrestore(&phba->hbalock, iflags);
+	}
+
+	/* Guard against abort handler being called at same time */
+	spin_lock(&lpfc_cmd->buf_lock);
+
 	/* Sanity check on return of outstanding command */
 	cmd = lpfc_cmd->pCmd;
 	if (!cmd) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
 				 "9042 I/O completion: Not an active IO\n");
+		spin_unlock(&lpfc_cmd->buf_lock);
 		lpfc_release_scsi_buf(phba, lpfc_cmd);
 		return;
 	}
-	/* Guard against abort handler being called at same time */
-	spin_lock(&lpfc_cmd->buf_lock);
 	idx = lpfc_cmd->cur_iocbq.hba_wqidx;
 	if (phba->sli4_hba.hdwq)
 		phba->sli4_hba.hdwq[idx].scsi_cstat.io_cmpls++;
@@ -4290,14 +4405,12 @@ lpfc_fcp_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 				 * This is a response for a BG enabled
 				 * cmd. Parse BG error
 				 */
-				lpfc_parse_bg_err(phba, lpfc_cmd, pwqeOut);
+				lpfc_sli4_parse_bg_err(phba, lpfc_cmd,
+						       wcqe);
 				break;
-			} else {
-				lpfc_printf_vlog(vport, KERN_WARNING,
-						 LOG_BG,
-						 "9040 non-zero BGSTAT "
-						 "on unprotected cmd\n");
 			}
+			lpfc_printf_vlog(vport, KERN_WARNING, LOG_BG,
+				 "9040 non-zero BGSTAT on unprotected cmd\n");
 		}
 		lpfc_printf_vlog(vport, KERN_WARNING, logit,
 				 "9036 Local Reject FCP cmd x%x failed"
@@ -4394,7 +4507,7 @@ lpfc_fcp_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 	 * wake up the thread.
 	 */
 	spin_lock(&lpfc_cmd->buf_lock);
-	lpfc_cmd->cur_iocbq.cmd_flag &= ~LPFC_DRIVER_ABORTED;
+	lpfc_cmd->cur_iocbq.iocb_flag &= ~LPFC_DRIVER_ABORTED;
 	if (lpfc_cmd->waitq)
 		wake_up(lpfc_cmd->waitq);
 	spin_unlock(&lpfc_cmd->buf_lock);
@@ -4454,7 +4567,7 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 	lpfc_cmd->status = pIocbOut->iocb.ulpStatus;
 	/* pick up SLI4 exchange busy status from HBA */
 	lpfc_cmd->flags &= ~LPFC_SBUF_XBUSY;
-	if (pIocbOut->cmd_flag & LPFC_EXCHANGE_BUSY)
+	if (pIocbOut->iocb_flag & LPFC_EXCHANGE_BUSY)
 		lpfc_cmd->flags |= LPFC_SBUF_XBUSY;
 
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
@@ -4663,7 +4776,7 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 	 * wake up the thread.
 	 */
 	spin_lock(&lpfc_cmd->buf_lock);
-	lpfc_cmd->cur_iocbq.cmd_flag &= ~LPFC_DRIVER_ABORTED;
+	lpfc_cmd->cur_iocbq.iocb_flag &= ~LPFC_DRIVER_ABORTED;
 	if (lpfc_cmd->waitq)
 		wake_up(lpfc_cmd->waitq);
 	spin_unlock(&lpfc_cmd->buf_lock);
@@ -4741,8 +4854,8 @@ static int lpfc_scsi_prep_cmnd_buf_s3(struct lpfc_vport *vport,
 
 	piocbq->iocb.ulpClass = (pnode->nlp_fcp_info & 0x0f);
 	piocbq->context1  = lpfc_cmd;
-	if (!piocbq->cmd_cmpl)
-		piocbq->cmd_cmpl = lpfc_scsi_cmd_iocb_cmpl;
+	if (!piocbq->iocb_cmpl)
+		piocbq->iocb_cmpl = lpfc_scsi_cmd_iocb_cmpl;
 	piocbq->iocb.ulpTimeout = tmo;
 	piocbq->vport = vport;
 	return 0;
@@ -4855,7 +4968,7 @@ static int lpfc_scsi_prep_cmnd_buf_s4(struct lpfc_vport *vport,
 	pwqeq->vport = vport;
 	pwqeq->context1 = lpfc_cmd;
 	pwqeq->hba_wqidx = lpfc_cmd->hdwq_no;
-	pwqeq->cmd_cmpl = lpfc_fcp_io_cmd_wqe_cmpl;
+	pwqeq->wqe_cmpl = lpfc_fcp_io_cmd_wqe_cmpl;
 
 	return 0;
 }
@@ -4902,7 +5015,7 @@ lpfc_scsi_prep_cmnd(struct lpfc_vport *vport, struct lpfc_io_buf *lpfc_cmd,
 }
 
 /**
- * lpfc_scsi_prep_task_mgmt_cmd_s3 - Convert SLI3 scsi TM cmd to FCP info unit
+ * lpfc_scsi_prep_task_mgmt_cmd - Convert SLI3 scsi TM cmd to FCP info unit
  * @vport: The virtual port for which this call is being executed.
  * @lpfc_cmd: Pointer to lpfc_io_buf data structure.
  * @lun: Logical unit number.
@@ -4916,9 +5029,10 @@ lpfc_scsi_prep_cmnd(struct lpfc_vport *vport, struct lpfc_io_buf *lpfc_cmd,
  *   1 - Success
  **/
 static int
-lpfc_scsi_prep_task_mgmt_cmd_s3(struct lpfc_vport *vport,
-				struct lpfc_io_buf *lpfc_cmd,
-				u64 lun, u8 task_mgmt_cmd)
+lpfc_scsi_prep_task_mgmt_cmd(struct lpfc_vport *vport,
+			     struct lpfc_io_buf *lpfc_cmd,
+			     uint64_t lun,
+			     uint8_t task_mgmt_cmd)
 {
 	struct lpfc_iocbq *piocbq;
 	IOCB_t *piocb;
@@ -4939,10 +5053,15 @@ lpfc_scsi_prep_task_mgmt_cmd_s3(struct lpfc_vport *vport,
 	memset(fcp_cmnd, 0, sizeof(struct fcp_cmnd));
 	int_to_scsilun(lun, &fcp_cmnd->fcp_lun);
 	fcp_cmnd->fcpCntl2 = task_mgmt_cmd;
-	if (!(vport->phba->sli3_options & LPFC_SLI3_BG_ENABLED))
+	if (vport->phba->sli_rev == 3 &&
+	    !(vport->phba->sli3_options & LPFC_SLI3_BG_ENABLED))
 		lpfc_fcpcmd_to_iocb(piocb->unsli3.fcp_ext.icd, fcp_cmnd);
 	piocb->ulpCommand = CMD_FCP_ICMND64_CR;
 	piocb->ulpContext = ndlp->nlp_rpi;
+	if (vport->phba->sli_rev == LPFC_SLI_REV4) {
+		piocb->ulpContext =
+		  vport->phba->sli4_hba.rpi_ids[ndlp->nlp_rpi];
+	}
 	piocb->ulpFCP2Rcvy = (ndlp->nlp_fcp_info & NLP_FCP_2_DEVICE) ? 1 : 0;
 	piocb->ulpClass = (ndlp->nlp_fcp_info & 0x0f);
 	piocb->ulpPU = 0;
@@ -4958,79 +5077,8 @@ lpfc_scsi_prep_task_mgmt_cmd_s3(struct lpfc_vport *vport,
 	} else
 		piocb->ulpTimeout = lpfc_cmd->timeout;
 
-	return 1;
-}
-
-/**
- * lpfc_scsi_prep_task_mgmt_cmd_s4 - Convert SLI4 scsi TM cmd to FCP info unit
- * @vport: The virtual port for which this call is being executed.
- * @lpfc_cmd: Pointer to lpfc_io_buf data structure.
- * @lun: Logical unit number.
- * @task_mgmt_cmd: SCSI task management command.
- *
- * This routine creates FCP information unit corresponding to @task_mgmt_cmd
- * for device with SLI-4 interface spec.
- *
- * Return codes:
- *   0 - Error
- *   1 - Success
- **/
-static int
-lpfc_scsi_prep_task_mgmt_cmd_s4(struct lpfc_vport *vport,
-				struct lpfc_io_buf *lpfc_cmd,
-				u64 lun, u8 task_mgmt_cmd)
-{
-	struct lpfc_iocbq *pwqeq = &lpfc_cmd->cur_iocbq;
-	union lpfc_wqe128 *wqe = &pwqeq->wqe;
-	struct fcp_cmnd *fcp_cmnd;
-	struct lpfc_rport_data *rdata = lpfc_cmd->rdata;
-	struct lpfc_nodelist *ndlp = rdata->pnode;
-
-	if (!ndlp || ndlp->nlp_state != NLP_STE_MAPPED_NODE)
-		return 0;
-
-	pwqeq->vport = vport;
-	/* Initialize 64 bytes only */
-	memset(wqe, 0, sizeof(union lpfc_wqe128));
-
-	/* From the icmnd template, initialize words 4 - 11 */
-	memcpy(&wqe->words[4], &lpfc_icmnd_cmd_template.words[4],
-	       sizeof(uint32_t) * 8);
-
-	fcp_cmnd = lpfc_cmd->fcp_cmnd;
-	/* Clear out any old data in the FCP command area */
-	memset(fcp_cmnd, 0, sizeof(struct fcp_cmnd));
-	int_to_scsilun(lun, &fcp_cmnd->fcp_lun);
-	fcp_cmnd->fcpCntl3 = 0;
-	fcp_cmnd->fcpCntl2 = task_mgmt_cmd;
-
-	bf_set(payload_offset_len, &wqe->fcp_icmd,
-	       sizeof(struct fcp_cmnd) + sizeof(struct fcp_rsp));
-	bf_set(cmd_buff_len, &wqe->fcp_icmd, 0);
-	bf_set(wqe_ctxt_tag, &wqe->generic.wqe_com,  /* ulpContext */
-	       vport->phba->sli4_hba.rpi_ids[ndlp->nlp_rpi]);
-	bf_set(wqe_erp, &wqe->fcp_icmd.wqe_com,
-	       ((ndlp->nlp_fcp_info & NLP_FCP_2_DEVICE) ? 1 : 0));
-	bf_set(wqe_class, &wqe->fcp_icmd.wqe_com,
-	       (ndlp->nlp_fcp_info & 0x0f));
-
-	/* ulpTimeout is only one byte */
-	if (lpfc_cmd->timeout > 0xff) {
-		/*
-		 * Do not timeout the command at the firmware level.
-		 * The driver will provide the timeout mechanism.
-		 */
-		bf_set(wqe_tmo, &wqe->fcp_icmd.wqe_com, 0);
-	} else {
-		bf_set(wqe_tmo, &wqe->fcp_icmd.wqe_com, lpfc_cmd->timeout);
-	}
-
-	lpfc_prep_embed_io(vport->phba, lpfc_cmd);
-	bf_set(wqe_xri_tag, &wqe->generic.wqe_com, pwqeq->sli4_xritag);
-	wqe->generic.wqe_com.abort_tag = pwqeq->iotag;
-	bf_set(wqe_reqtag, &wqe->generic.wqe_com, pwqeq->iotag);
-
-	lpfc_sli4_set_rsp_sgl_last(vport->phba, lpfc_cmd);
+	if (vport->phba->sli_rev == LPFC_SLI_REV4)
+		lpfc_sli4_set_rsp_sgl_last(vport->phba, lpfc_cmd);
 
 	return 1;
 }
@@ -5057,8 +5105,6 @@ lpfc_scsi_api_table_setup(struct lpfc_hba *phba, uint8_t dev_grp)
 		phba->lpfc_release_scsi_buf = lpfc_release_scsi_buf_s3;
 		phba->lpfc_get_scsi_buf = lpfc_get_scsi_buf_s3;
 		phba->lpfc_scsi_prep_cmnd_buf = lpfc_scsi_prep_cmnd_buf_s3;
-		phba->lpfc_scsi_prep_task_mgmt_cmd =
-					lpfc_scsi_prep_task_mgmt_cmd_s3;
 		break;
 	case LPFC_PCI_DEV_OC:
 		phba->lpfc_scsi_prep_dma_buf = lpfc_scsi_prep_dma_buf_s4;
@@ -5066,8 +5112,6 @@ lpfc_scsi_api_table_setup(struct lpfc_hba *phba, uint8_t dev_grp)
 		phba->lpfc_release_scsi_buf = lpfc_release_scsi_buf_s4;
 		phba->lpfc_get_scsi_buf = lpfc_get_scsi_buf_s4;
 		phba->lpfc_scsi_prep_cmnd_buf = lpfc_scsi_prep_cmnd_buf_s4;
-		phba->lpfc_scsi_prep_task_mgmt_cmd =
-					lpfc_scsi_prep_task_mgmt_cmd_s4;
 		break;
 	default:
 		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
@@ -5546,7 +5590,6 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 {
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
 	struct lpfc_hba   *phba = vport->phba;
-	struct lpfc_iocbq *cur_iocbq = NULL;
 	struct lpfc_rport_data *rdata;
 	struct lpfc_nodelist *ndlp;
 	struct lpfc_io_buf *lpfc_cmd;
@@ -5640,7 +5683,6 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 	}
 	lpfc_cmd->rx_cmd_start = start;
 
-	cur_iocbq = &lpfc_cmd->cur_iocbq;
 	/*
 	 * Store the midlayer's command structure for the completion phase
 	 * and complete the command initialization.
@@ -5648,7 +5690,7 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 	lpfc_cmd->pCmd  = cmnd;
 	lpfc_cmd->rdata = rdata;
 	lpfc_cmd->ndlp = ndlp;
-	cur_iocbq->cmd_cmpl = NULL;
+	lpfc_cmd->cur_iocbq.iocb_cmpl = NULL;
 	cmnd->host_scribble = (unsigned char *)lpfc_cmd;
 
 	err = lpfc_scsi_prep_cmnd(vport, lpfc_cmd, ndlp);
@@ -5690,6 +5732,7 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 		goto out_host_busy_free_buf;
 	}
 
+
 	/* check the necessary and sufficient condition to support VMID */
 	if (lpfc_is_vmid_enabled(phba) &&
 	    (ndlp->vmid_support ||
@@ -5702,9 +5745,9 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 		if (uuid) {
 			err = lpfc_vmid_get_appid(vport, uuid, cmnd,
 				(union lpfc_vmid_io_tag *)
-					&cur_iocbq->vmid_tag);
+					&lpfc_cmd->cur_iocbq.vmid_tag);
 			if (!err)
-				cur_iocbq->cmd_flag |= LPFC_IO_VMID;
+				lpfc_cmd->cur_iocbq.iocb_flag |= LPFC_IO_VMID;
 		}
 	}
 
@@ -5713,7 +5756,8 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 		this_cpu_inc(phba->sli4_hba.c_stat->xmt_io);
 #endif
 	/* Issue I/O to adapter */
-	err = lpfc_sli_issue_fcp_io(phba, LPFC_FCP_RING, cur_iocbq,
+	err = lpfc_sli_issue_fcp_io(phba, LPFC_FCP_RING,
+				    &lpfc_cmd->cur_iocbq,
 				    SLI_IOCB_RET_IOCB);
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	if (start) {
@@ -5726,25 +5770,25 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 #endif
 	if (err) {
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP,
-				 "3376 FCP could not issue iocb err %x "
-				 "FCP cmd x%x <%d/%llu> "
-				 "sid: x%x did: x%x oxid: x%x "
-				 "Data: x%x x%x x%x x%x\n",
-				 err, cmnd->cmnd[0],
-				 cmnd->device ? cmnd->device->id : 0xffff,
-				 cmnd->device ? cmnd->device->lun : (u64)-1,
-				 vport->fc_myDID, ndlp->nlp_DID,
-				 phba->sli_rev == LPFC_SLI_REV4 ?
-				 cur_iocbq->sli4_xritag : 0xffff,
-				 phba->sli_rev == LPFC_SLI_REV4 ?
-				 phba->sli4_hba.rpi_ids[ndlp->nlp_rpi] :
-				 cur_iocbq->iocb.ulpContext,
-				 cur_iocbq->iotag,
-				 phba->sli_rev == LPFC_SLI_REV4 ?
-				 bf_get(wqe_tmo,
-					&cur_iocbq->wqe.generic.wqe_com) :
-				 cur_iocbq->iocb.ulpTimeout,
-				 (uint32_t)(scsi_cmd_to_rq(cmnd)->timeout / 1000));
+				   "3376 FCP could not issue IOCB err %x "
+				   "FCP cmd x%x <%d/%llu> "
+				   "sid: x%x did: x%x oxid: x%x "
+				   "Data: x%x x%x x%x x%x\n",
+				   err, cmnd->cmnd[0],
+				   cmnd->device ? cmnd->device->id : 0xffff,
+				   cmnd->device ? cmnd->device->lun : (u64)-1,
+				   vport->fc_myDID, ndlp->nlp_DID,
+				   phba->sli_rev == LPFC_SLI_REV4 ?
+				   lpfc_cmd->cur_iocbq.sli4_xritag : 0xffff,
+				   phba->sli_rev == LPFC_SLI_REV4 ?
+				   phba->sli4_hba.rpi_ids[ndlp->nlp_rpi] :
+				   lpfc_cmd->cur_iocbq.iocb.ulpContext,
+				   lpfc_cmd->cur_iocbq.iotag,
+				   phba->sli_rev == LPFC_SLI_REV4 ?
+				   bf_get(wqe_tmo,
+				   &lpfc_cmd->cur_iocbq.wqe.generic.wqe_com) :
+				   lpfc_cmd->cur_iocbq.iocb.ulpTimeout,
+				   (uint32_t)(scsi_cmd_to_rq(cmnd)->timeout / 1000));
 
 		goto out_host_busy_free_buf;
 	}
@@ -5890,7 +5934,7 @@ lpfc_abort_handler(struct scsi_cmnd *cmnd)
 		spin_lock(&pring_s4->ring_lock);
 	}
 	/* the command is in process of being cancelled */
-	if (!(iocb->cmd_flag & LPFC_IO_ON_TXCMPLQ)) {
+	if (!(iocb->iocb_flag & LPFC_IO_ON_TXCMPLQ)) {
 		lpfc_printf_vlog(vport, KERN_WARNING, LOG_FCP,
 			"3169 SCSI Layer abort requested I/O has been "
 			"cancelled by LLD.\n");
@@ -5913,7 +5957,7 @@ lpfc_abort_handler(struct scsi_cmnd *cmnd)
 	BUG_ON(iocb->context1 != lpfc_cmd);
 
 	/* abort issued in recovery is still in progress */
-	if (iocb->cmd_flag & LPFC_DRIVER_ABORTED) {
+	if (iocb->iocb_flag & LPFC_DRIVER_ABORTED) {
 		lpfc_printf_vlog(vport, KERN_WARNING, LOG_FCP,
 			 "3389 SCSI Layer I/O Abort Request is pending\n");
 		if (phba->sli_rev == LPFC_SLI_REV4)
@@ -5954,7 +5998,7 @@ lpfc_abort_handler(struct scsi_cmnd *cmnd)
 
 wait_for_cmpl:
 	/*
-	 * cmd_flag is set to LPFC_DRIVER_ABORTED before we wait
+	 * iocb_flag is set to LPFC_DRIVER_ABORTED before we wait
 	 * for abort to complete.
 	 */
 	wait_event_timeout(waitq,
@@ -6121,7 +6165,7 @@ lpfc_send_taskmgmt(struct lpfc_vport *vport, struct scsi_cmnd *cmnd,
 		return FAILED;
 	pnode = rdata->pnode;
 
-	lpfc_cmd = lpfc_get_scsi_buf(phba, rdata->pnode, NULL);
+	lpfc_cmd = lpfc_get_scsi_buf(phba, pnode, NULL);
 	if (lpfc_cmd == NULL)
 		return FAILED;
 	lpfc_cmd->timeout = phba->cfg_task_mgmt_tmo;
@@ -6129,8 +6173,8 @@ lpfc_send_taskmgmt(struct lpfc_vport *vport, struct scsi_cmnd *cmnd,
 	lpfc_cmd->pCmd = cmnd;
 	lpfc_cmd->ndlp = pnode;
 
-	status = phba->lpfc_scsi_prep_task_mgmt_cmd(vport, lpfc_cmd, lun_id,
-						    task_mgmt_cmd);
+	status = lpfc_scsi_prep_task_mgmt_cmd(vport, lpfc_cmd, lun_id,
+					   task_mgmt_cmd);
 	if (!status) {
 		lpfc_release_scsi_buf(phba, lpfc_cmd);
 		return FAILED;
@@ -6142,41 +6186,38 @@ lpfc_send_taskmgmt(struct lpfc_vport *vport, struct scsi_cmnd *cmnd,
 		lpfc_release_scsi_buf(phba, lpfc_cmd);
 		return FAILED;
 	}
-	iocbq->cmd_cmpl = lpfc_tskmgmt_def_cmpl;
-	iocbq->vport = vport;
+	iocbq->iocb_cmpl = lpfc_tskmgmt_def_cmpl;
 
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP,
 			 "0702 Issue %s to TGT %d LUN %llu "
 			 "rpi x%x nlp_flag x%x Data: x%x x%x\n",
 			 lpfc_taskmgmt_name(task_mgmt_cmd), tgt_id, lun_id,
 			 pnode->nlp_rpi, pnode->nlp_flag, iocbq->sli4_xritag,
-			 iocbq->cmd_flag);
+			 iocbq->iocb_flag);
 
 	status = lpfc_sli_issue_iocb_wait(phba, LPFC_FCP_RING,
 					  iocbq, iocbqrsp, lpfc_cmd->timeout);
 	if ((status != IOCB_SUCCESS) ||
-	    (get_job_ulpstatus(phba, iocbqrsp) != IOSTAT_SUCCESS)) {
+	    (iocbqrsp->iocb.ulpStatus != IOSTAT_SUCCESS)) {
 		if (status != IOCB_SUCCESS ||
-		    get_job_ulpstatus(phba, iocbqrsp) != IOSTAT_FCP_RSP_ERROR)
+		    iocbqrsp->iocb.ulpStatus != IOSTAT_FCP_RSP_ERROR)
 			lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
 					 "0727 TMF %s to TGT %d LUN %llu "
-					 "failed (%d, %d) cmd_flag x%x\n",
+					 "failed (%d, %d) iocb_flag x%x\n",
 					 lpfc_taskmgmt_name(task_mgmt_cmd),
 					 tgt_id, lun_id,
-					 get_job_ulpstatus(phba, iocbqrsp),
-					 get_job_word4(phba, iocbqrsp),
-					 iocbq->cmd_flag);
+					 iocbqrsp->iocb.ulpStatus,
+					 iocbqrsp->iocb.un.ulpWord[4],
+					 iocbq->iocb_flag);
 		/* if ulpStatus != IOCB_SUCCESS, then status == IOCB_SUCCESS */
 		if (status == IOCB_SUCCESS) {
-			if (get_job_ulpstatus(phba, iocbqrsp) ==
-			    IOSTAT_FCP_RSP_ERROR)
+			if (iocbqrsp->iocb.ulpStatus == IOSTAT_FCP_RSP_ERROR)
 				/* Something in the FCP_RSP was invalid.
 				 * Check conditions */
 				ret = lpfc_check_fcp_rsp(vport, lpfc_cmd);
 			else
 				ret = FAILED;
-		} else if ((status == IOCB_TIMEDOUT) ||
-			   (status == IOCB_ABORTED)) {
+		} else if (status == IOCB_TIMEDOUT) {
 			ret = TIMEOUT_ERROR;
 		} else {
 			ret = FAILED;
@@ -6186,7 +6227,7 @@ lpfc_send_taskmgmt(struct lpfc_vport *vport, struct scsi_cmnd *cmnd,
 
 	lpfc_sli_release_iocbq(phba, iocbqrsp);
 
-	if (status != IOCB_TIMEDOUT)
+	if (ret != TIMEOUT_ERROR)
 		lpfc_release_scsi_buf(phba, lpfc_cmd);
 
 	return ret;
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index f594a006d04c..0024c0e0afd3 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -70,9 +70,8 @@ static int lpfc_sli_issue_mbox_s4(struct lpfc_hba *, LPFC_MBOXQ_t *,
 				  uint32_t);
 static int lpfc_sli4_read_rev(struct lpfc_hba *, LPFC_MBOXQ_t *,
 			      uint8_t *, uint32_t *);
-static struct lpfc_iocbq *
-lpfc_sli4_els_preprocess_rspiocbq(struct lpfc_hba *phba,
-				  struct lpfc_iocbq *rspiocbq);
+static struct lpfc_iocbq *lpfc_sli4_els_wcqe_to_rspiocbq(struct lpfc_hba *,
+							 struct lpfc_iocbq *);
 static void lpfc_sli4_send_seq_to_ulp(struct lpfc_vport *,
 				      struct hbq_dmabuf *);
 static void lpfc_sli4_handle_mds_loopback(struct lpfc_vport *vport,
@@ -90,9 +89,6 @@ static struct lpfc_cqe *lpfc_sli4_cq_get(struct lpfc_queue *q);
 static void __lpfc_sli4_consume_cqe(struct lpfc_hba *phba,
 				    struct lpfc_queue *cq,
 				    struct lpfc_cqe *cqe);
-static uint16_t lpfc_wqe_bpl2sgl(struct lpfc_hba *phba,
-				 struct lpfc_iocbq *pwqeq,
-				 struct lpfc_sglq *sglq);
 
 union lpfc_wqe128 lpfc_iread_cmd_template;
 union lpfc_wqe128 lpfc_iwrite_cmd_template;
@@ -1258,21 +1254,21 @@ __lpfc_sli_get_els_sglq(struct lpfc_hba *phba, struct lpfc_iocbq *piocbq)
 	struct lpfc_sli_ring *pring = NULL;
 	int found = 0;
 
-	if (piocbq->cmd_flag & LPFC_IO_NVME_LS)
+	if (piocbq->iocb_flag & LPFC_IO_NVME_LS)
 		pring =  phba->sli4_hba.nvmels_wq->pring;
 	else
 		pring = lpfc_phba_elsring(phba);
 
 	lockdep_assert_held(&pring->ring_lock);
 
-	if (piocbq->cmd_flag &  LPFC_IO_FCP) {
+	if (piocbq->iocb_flag &  LPFC_IO_FCP) {
 		lpfc_cmd = (struct lpfc_io_buf *) piocbq->context1;
 		ndlp = lpfc_cmd->rdata->pnode;
 	} else  if ((piocbq->iocb.ulpCommand == CMD_GEN_REQUEST64_CR) &&
-			!(piocbq->cmd_flag & LPFC_IO_LIBDFC)) {
+			!(piocbq->iocb_flag & LPFC_IO_LIBDFC)) {
 		ndlp = piocbq->context_un.ndlp;
-	} else  if (piocbq->cmd_flag & LPFC_IO_LIBDFC) {
-		if (piocbq->cmd_flag & LPFC_IO_LOOPBACK)
+	} else  if (piocbq->iocb_flag & LPFC_IO_LIBDFC) {
+		if (piocbq->iocb_flag & LPFC_IO_LOOPBACK)
 			ndlp = NULL;
 		else
 			ndlp = piocbq->context_un.ndlp;
@@ -1384,7 +1380,7 @@ static void
 __lpfc_sli_release_iocbq_s4(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq)
 {
 	struct lpfc_sglq *sglq;
-	size_t start_clean = offsetof(struct lpfc_iocbq, wqe);
+	size_t start_clean = offsetof(struct lpfc_iocbq, iocb);
 	unsigned long iflag = 0;
 	struct lpfc_sli_ring *pring;
 
@@ -1395,7 +1391,7 @@ __lpfc_sli_release_iocbq_s4(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq)
 
 
 	if (sglq)  {
-		if (iocbq->cmd_flag & LPFC_IO_NVMET) {
+		if (iocbq->iocb_flag & LPFC_IO_NVMET) {
 			spin_lock_irqsave(&phba->sli4_hba.sgl_list_lock,
 					  iflag);
 			sglq->state = SGL_FREED;
@@ -1407,7 +1403,7 @@ __lpfc_sli_release_iocbq_s4(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq)
 			goto out;
 		}
 
-		if ((iocbq->cmd_flag & LPFC_EXCHANGE_BUSY) &&
+		if ((iocbq->iocb_flag & LPFC_EXCHANGE_BUSY) &&
 		    (!(unlikely(pci_channel_offline(phba->pcidev)))) &&
 		    sglq->state != SGL_XRI_ABORTED) {
 			spin_lock_irqsave(&phba->sli4_hba.sgl_list_lock,
@@ -1444,7 +1440,7 @@ __lpfc_sli_release_iocbq_s4(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq)
 	memset((char *)iocbq + start_clean, 0, sizeof(*iocbq) - start_clean);
 	iocbq->sli4_lxritag = NO_XRI;
 	iocbq->sli4_xritag = NO_XRI;
-	iocbq->cmd_flag &= ~(LPFC_IO_NVME | LPFC_IO_NVMET | LPFC_IO_CMF |
+	iocbq->iocb_flag &= ~(LPFC_IO_NVME | LPFC_IO_NVMET | LPFC_IO_CMF |
 			      LPFC_IO_NVME_LS);
 	list_add_tail(&iocbq->list, &phba->lpfc_iocb_list);
 }
@@ -1534,17 +1530,17 @@ lpfc_sli_cancel_iocbs(struct lpfc_hba *phba, struct list_head *iocblist,
 
 	while (!list_empty(iocblist)) {
 		list_remove_head(iocblist, piocb, struct lpfc_iocbq, list);
-		if (piocb->cmd_cmpl) {
-			if (piocb->cmd_flag & LPFC_IO_NVME)
+		if (piocb->wqe_cmpl) {
+			if (piocb->iocb_flag & LPFC_IO_NVME)
 				lpfc_nvme_cancel_iocb(phba, piocb,
 						      ulpstatus, ulpWord4);
 			else
 				lpfc_sli_release_iocbq(phba, piocb);
 
-		} else if (piocb->cmd_cmpl) {
+		} else if (piocb->iocb_cmpl) {
 			piocb->iocb.ulpStatus = ulpstatus;
 			piocb->iocb.un.ulpWord[4] = ulpWord4;
-			(piocb->cmd_cmpl) (phba, piocb, piocb);
+			(piocb->iocb_cmpl) (phba, piocb, piocb);
 		} else {
 			lpfc_sli_release_iocbq(phba, piocb);
 		}
@@ -1736,7 +1732,7 @@ lpfc_sli_ringtxcmpl_put(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	BUG_ON(!piocb);
 
 	list_add_tail(&piocb->list, &pring->txcmplq);
-	piocb->cmd_flag |= LPFC_IO_ON_TXCMPLQ;
+	piocb->iocb_flag |= LPFC_IO_ON_TXCMPLQ;
 	pring->txcmplq_cnt++;
 
 	if ((unlikely(pring->ringno == LPFC_ELS_RING)) &&
@@ -1777,7 +1773,7 @@ lpfc_sli_ringtx_get(struct lpfc_hba *phba, struct lpfc_sli_ring *pring)
  * lpfc_cmf_sync_cmpl - Process a CMF_SYNC_WQE cmpl
  * @phba: Pointer to HBA context object.
  * @cmdiocb: Pointer to driver command iocb object.
- * @rspiocb: Pointer to driver response iocb object.
+ * @cmf_cmpl: Pointer to completed WCQE.
  *
  * This routine will inform the driver of any BW adjustments we need
  * to make. These changes will be picked up during the next CMF
@@ -1786,11 +1782,10 @@ lpfc_sli_ringtx_get(struct lpfc_hba *phba, struct lpfc_sli_ring *pring)
  **/
 static void
 lpfc_cmf_sync_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
-		   struct lpfc_iocbq *rspiocb)
+		   struct lpfc_wcqe_complete *cmf_cmpl)
 {
 	union lpfc_wqe128 *wqe;
 	uint32_t status, info;
-	struct lpfc_wcqe_complete *wcqe = &rspiocb->wcqe_cmpl;
 	uint64_t bw, bwdif, slop;
 	uint64_t pcent, bwpcent;
 	int asig, afpin, sigcnt, fpincnt;
@@ -1798,22 +1793,22 @@ lpfc_cmf_sync_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	char *s;
 
 	/* First check for error */
-	status = bf_get(lpfc_wcqe_c_status, wcqe);
+	status = bf_get(lpfc_wcqe_c_status, cmf_cmpl);
 	if (status) {
 		lpfc_printf_log(phba, KERN_INFO, LOG_CGN_MGMT,
 				"6211 CMF_SYNC_WQE Error "
 				"req_tag x%x status x%x hwstatus x%x "
 				"tdatap x%x parm x%x\n",
-				bf_get(lpfc_wcqe_c_request_tag, wcqe),
-				bf_get(lpfc_wcqe_c_status, wcqe),
-				bf_get(lpfc_wcqe_c_hw_status, wcqe),
-				wcqe->total_data_placed,
-				wcqe->parameter);
+				bf_get(lpfc_wcqe_c_request_tag, cmf_cmpl),
+				bf_get(lpfc_wcqe_c_status, cmf_cmpl),
+				bf_get(lpfc_wcqe_c_hw_status, cmf_cmpl),
+				cmf_cmpl->total_data_placed,
+				cmf_cmpl->parameter);
 		goto out;
 	}
 
 	/* Gather congestion information on a successful cmpl */
-	info = wcqe->parameter;
+	info = cmf_cmpl->parameter;
 	phba->cmf_active_info = info;
 
 	/* See if firmware info count is valid or has changed */
@@ -1822,15 +1817,15 @@ lpfc_cmf_sync_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	else
 		phba->cmf_info_per_interval = info;
 
-	tdp = bf_get(lpfc_wcqe_c_cmf_bw, wcqe);
-	cg = bf_get(lpfc_wcqe_c_cmf_cg, wcqe);
+	tdp = bf_get(lpfc_wcqe_c_cmf_bw, cmf_cmpl);
+	cg = bf_get(lpfc_wcqe_c_cmf_cg, cmf_cmpl);
 
 	/* Get BW requirement from firmware */
 	bw = (uint64_t)tdp * LPFC_CMF_BLK_SIZE;
 	if (!bw) {
 		lpfc_printf_log(phba, KERN_INFO, LOG_CGN_MGMT,
 				"6212 CMF_SYNC_WQE x%x: NULL bw\n",
-				bf_get(lpfc_wcqe_c_request_tag, wcqe));
+				bf_get(lpfc_wcqe_c_request_tag, cmf_cmpl));
 		goto out;
 	}
 
@@ -1939,7 +1934,7 @@ lpfc_issue_cmf_sync_wqe(struct lpfc_hba *phba, u32 ms, u64 total)
 	sync_buf = __lpfc_sli_get_iocbq(phba);
 	if (!sync_buf) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_CGN_MGMT,
-				"6244 No available WQEs for CMF_SYNC_WQE\n");
+				"6213 No available WQEs for CMF_SYNC_WQE\n");
 		ret_val = ENOMEM;
 		goto out_unlock;
 	}
@@ -2004,13 +1999,14 @@ lpfc_issue_cmf_sync_wqe(struct lpfc_hba *phba, u32 ms, u64 total)
 	bf_set(cmf_sync_cqid, &wqe->cmf_sync, LPFC_WQE_CQ_ID_DEFAULT);
 
 	sync_buf->vport = phba->pport;
-	sync_buf->cmd_cmpl = lpfc_cmf_sync_cmpl;
+	sync_buf->wqe_cmpl = lpfc_cmf_sync_cmpl;
+	sync_buf->iocb_cmpl = NULL;
 	sync_buf->context1 = NULL;
 	sync_buf->context2 = NULL;
 	sync_buf->context3 = NULL;
 	sync_buf->sli4_xritag = NO_XRI;
 
-	sync_buf->cmd_flag |= LPFC_IO_CMF;
+	sync_buf->iocb_flag |= LPFC_IO_CMF;
 	ret_val = lpfc_sli4_issue_wqe(phba, &phba->sli4_hba.hdwq[0], sync_buf);
 	if (ret_val) {
 		lpfc_printf_log(phba, KERN_INFO, LOG_CGN_MGMT,
@@ -2179,7 +2175,7 @@ lpfc_sli_submit_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	/*
 	 * Set up an iotag
 	 */
-	nextiocb->iocb.ulpIoTag = (nextiocb->cmd_cmpl) ? nextiocb->iotag : 0;
+	nextiocb->iocb.ulpIoTag = (nextiocb->iocb_cmpl) ? nextiocb->iotag : 0;
 
 
 	if (pring->ringno == LPFC_ELS_RING) {
@@ -2200,9 +2196,9 @@ lpfc_sli_submit_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	/*
 	 * If there is no completion routine to call, we can release the
 	 * IOCB buffer back right now. For IOCBs, like QUE_RING_BUF,
-	 * that have no rsp ring completion, cmd_cmpl MUST be NULL.
+	 * that have no rsp ring completion, iocb_cmpl MUST be NULL.
 	 */
-	if (nextiocb->cmd_cmpl)
+	if (nextiocb->iocb_cmpl)
 		lpfc_sli_ringtxcmpl_put(phba, pring, nextiocb);
 	else
 		__lpfc_sli_release_iocbq(phba, nextiocb);
@@ -3556,28 +3552,36 @@ lpfc_sli_iocbq_lookup(struct lpfc_hba *phba,
 		      struct lpfc_iocbq *prspiocb)
 {
 	struct lpfc_iocbq *cmd_iocb = NULL;
-	u16 iotag;
+	uint16_t iotag;
+	spinlock_t *temp_lock = NULL;
+	unsigned long iflag = 0;
 
 	if (phba->sli_rev == LPFC_SLI_REV4)
-		iotag = get_wqe_reqtag(prspiocb);
+		temp_lock = &pring->ring_lock;
 	else
-		iotag = prspiocb->iocb.ulpIoTag;
+		temp_lock = &phba->hbalock;
+
+	spin_lock_irqsave(temp_lock, iflag);
+	iotag = prspiocb->iocb.ulpIoTag;
 
 	if (iotag != 0 && iotag <= phba->sli.last_iotag) {
 		cmd_iocb = phba->sli.iocbq_lookup[iotag];
-		if (cmd_iocb->cmd_flag & LPFC_IO_ON_TXCMPLQ) {
+		if (cmd_iocb->iocb_flag & LPFC_IO_ON_TXCMPLQ) {
 			/* remove from txcmpl queue list */
 			list_del_init(&cmd_iocb->list);
-			cmd_iocb->cmd_flag &= ~LPFC_IO_ON_TXCMPLQ;
+			cmd_iocb->iocb_flag &= ~LPFC_IO_ON_TXCMPLQ;
 			pring->txcmplq_cnt--;
+			spin_unlock_irqrestore(temp_lock, iflag);
 			return cmd_iocb;
 		}
 	}
 
+	spin_unlock_irqrestore(temp_lock, iflag);
 	lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
 			"0317 iotag x%x is out of "
-			"range: max iotag x%x\n",
-			iotag, phba->sli.last_iotag);
+			"range: max iotag x%x wd0 x%x\n",
+			iotag, phba->sli.last_iotag,
+			*(((uint32_t *) &prspiocb->iocb) + 7));
 	return NULL;
 }
 
@@ -3598,23 +3602,33 @@ lpfc_sli_iocbq_lookup_by_tag(struct lpfc_hba *phba,
 			     struct lpfc_sli_ring *pring, uint16_t iotag)
 {
 	struct lpfc_iocbq *cmd_iocb = NULL;
+	spinlock_t *temp_lock = NULL;
+	unsigned long iflag = 0;
 
+	if (phba->sli_rev == LPFC_SLI_REV4)
+		temp_lock = &pring->ring_lock;
+	else
+		temp_lock = &phba->hbalock;
+
+	spin_lock_irqsave(temp_lock, iflag);
 	if (iotag != 0 && iotag <= phba->sli.last_iotag) {
 		cmd_iocb = phba->sli.iocbq_lookup[iotag];
-		if (cmd_iocb->cmd_flag & LPFC_IO_ON_TXCMPLQ) {
+		if (cmd_iocb->iocb_flag & LPFC_IO_ON_TXCMPLQ) {
 			/* remove from txcmpl queue list */
 			list_del_init(&cmd_iocb->list);
-			cmd_iocb->cmd_flag &= ~LPFC_IO_ON_TXCMPLQ;
+			cmd_iocb->iocb_flag &= ~LPFC_IO_ON_TXCMPLQ;
 			pring->txcmplq_cnt--;
+			spin_unlock_irqrestore(temp_lock, iflag);
 			return cmd_iocb;
 		}
 	}
 
+	spin_unlock_irqrestore(temp_lock, iflag);
 	lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
 			"0372 iotag x%x lookup error: max iotag (x%x) "
-			"cmd_flag x%x\n",
+			"iocb_flag x%x\n",
 			iotag, phba->sli.last_iotag,
-			cmd_iocb ? cmd_iocb->cmd_flag : 0xffff);
+			cmd_iocb ? cmd_iocb->iocb_flag : 0xffff);
 	return NULL;
 }
 
@@ -3642,37 +3656,18 @@ lpfc_sli_process_sol_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	struct lpfc_iocbq *cmdiocbp;
 	int rc = 1;
 	unsigned long iflag;
-	u32 ulp_command, ulp_status, ulp_word4, ulp_context, iotag;
 
-	if (phba->sli_rev == LPFC_SLI_REV4)
-		spin_lock_irqsave(&pring->ring_lock, iflag);
-	else
-		spin_lock_irqsave(&phba->hbalock, iflag);
 	cmdiocbp = lpfc_sli_iocbq_lookup(phba, pring, saveq);
-	if (phba->sli_rev == LPFC_SLI_REV4)
-		spin_unlock_irqrestore(&pring->ring_lock, iflag);
-	else
-		spin_unlock_irqrestore(&phba->hbalock, iflag);
-
-	ulp_command = get_job_cmnd(phba, saveq);
-	ulp_status = get_job_ulpstatus(phba, saveq);
-	ulp_word4 = get_job_word4(phba, saveq);
-	ulp_context = get_job_ulpcontext(phba, saveq);
-	if (phba->sli_rev == LPFC_SLI_REV4)
-		iotag = get_wqe_reqtag(saveq);
-	else
-		iotag = saveq->iocb.ulpIoTag;
-
 	if (cmdiocbp) {
-		ulp_command = get_job_cmnd(phba, cmdiocbp);
-		if (cmdiocbp->cmd_cmpl) {
+		if (cmdiocbp->iocb_cmpl) {
 			/*
 			 * If an ELS command failed send an event to mgmt
 			 * application.
 			 */
-			if (ulp_status &&
+			if (saveq->iocb.ulpStatus &&
 			     (pring->ringno == LPFC_ELS_RING) &&
-			     (ulp_command == CMD_ELS_REQUEST64_CR))
+			     (cmdiocbp->iocb.ulpCommand ==
+				CMD_ELS_REQUEST64_CR))
 				lpfc_send_els_failure_event(phba,
 					cmdiocbp, saveq);
 
@@ -3682,11 +3677,11 @@ lpfc_sli_process_sol_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 			 */
 			if (pring->ringno == LPFC_ELS_RING) {
 				if ((phba->sli_rev < LPFC_SLI_REV4) &&
-				    (cmdiocbp->cmd_flag &
+				    (cmdiocbp->iocb_flag &
 							LPFC_DRIVER_ABORTED)) {
 					spin_lock_irqsave(&phba->hbalock,
 							  iflag);
-					cmdiocbp->cmd_flag &=
+					cmdiocbp->iocb_flag &=
 						~LPFC_DRIVER_ABORTED;
 					spin_unlock_irqrestore(&phba->hbalock,
 							       iflag);
@@ -3701,12 +3696,12 @@ lpfc_sli_process_sol_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 					 */
 					spin_lock_irqsave(&phba->hbalock,
 							  iflag);
-					saveq->cmd_flag |= LPFC_DELAY_MEM_FREE;
+					saveq->iocb_flag |= LPFC_DELAY_MEM_FREE;
 					spin_unlock_irqrestore(&phba->hbalock,
 							       iflag);
 				}
 				if (phba->sli_rev == LPFC_SLI_REV4) {
-					if (saveq->cmd_flag &
+					if (saveq->iocb_flag &
 					    LPFC_EXCHANGE_BUSY) {
 						/* Set cmdiocb flag for the
 						 * exchange busy so sgl (xri)
@@ -3716,12 +3711,12 @@ lpfc_sli_process_sol_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 						 */
 						spin_lock_irqsave(
 							&phba->hbalock, iflag);
-						cmdiocbp->cmd_flag |=
+						cmdiocbp->iocb_flag |=
 							LPFC_EXCHANGE_BUSY;
 						spin_unlock_irqrestore(
 							&phba->hbalock, iflag);
 					}
-					if (cmdiocbp->cmd_flag &
+					if (cmdiocbp->iocb_flag &
 					    LPFC_DRIVER_ABORTED) {
 						/*
 						 * Clear LPFC_DRIVER_ABORTED
@@ -3730,34 +3725,34 @@ lpfc_sli_process_sol_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 						 */
 						spin_lock_irqsave(
 							&phba->hbalock, iflag);
-						cmdiocbp->cmd_flag &=
+						cmdiocbp->iocb_flag &=
 							~LPFC_DRIVER_ABORTED;
 						spin_unlock_irqrestore(
 							&phba->hbalock, iflag);
-						set_job_ulpstatus(cmdiocbp,
-								  IOSTAT_LOCAL_REJECT);
-						set_job_ulpword4(cmdiocbp,
-								 IOERR_ABORT_REQUESTED);
+						cmdiocbp->iocb.ulpStatus =
+							IOSTAT_LOCAL_REJECT;
+						cmdiocbp->iocb.un.ulpWord[4] =
+							IOERR_ABORT_REQUESTED;
 						/*
-						 * For SLI4, irspiocb contains
+						 * For SLI4, irsiocb contains
 						 * NO_XRI in sli_xritag, it
 						 * shall not affect releasing
 						 * sgl (xri) process.
 						 */
-						set_job_ulpstatus(saveq,
-								  IOSTAT_LOCAL_REJECT);
-						set_job_ulpword4(saveq,
-								 IOERR_SLI_ABORTED);
+						saveq->iocb.ulpStatus =
+							IOSTAT_LOCAL_REJECT;
+						saveq->iocb.un.ulpWord[4] =
+							IOERR_SLI_ABORTED;
 						spin_lock_irqsave(
 							&phba->hbalock, iflag);
-						saveq->cmd_flag |=
+						saveq->iocb_flag |=
 							LPFC_DELAY_MEM_FREE;
 						spin_unlock_irqrestore(
 							&phba->hbalock, iflag);
 					}
 				}
 			}
-			cmdiocbp->cmd_cmpl(phba, cmdiocbp, saveq);
+			(cmdiocbp->iocb_cmpl) (phba, cmdiocbp, saveq);
 		} else
 			lpfc_sli_release_iocbq(phba, cmdiocbp);
 	} else {
@@ -3775,8 +3770,12 @@ lpfc_sli_process_sol_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 					 "0322 Ring %d handler: "
 					 "unexpected completion IoTag x%x "
 					 "Data: x%x x%x x%x x%x\n",
-					 pring->ringno, iotag, ulp_status,
-					 ulp_word4, ulp_command, ulp_context);
+					 pring->ringno,
+					 saveq->iocb.ulpIoTag,
+					 saveq->iocb.ulpStatus,
+					 saveq->iocb.un.ulpWord[4],
+					 saveq->iocb.ulpCommand,
+					 saveq->iocb.ulpContext);
 		}
 	}
 
@@ -3989,15 +3988,18 @@ lpfc_sli_handle_fast_ring_event(struct lpfc_hba *phba,
 				break;
 			}
 
+			spin_unlock_irqrestore(&phba->hbalock, iflag);
 			cmdiocbq = lpfc_sli_iocbq_lookup(phba, pring,
 							 &rspiocbq);
+			spin_lock_irqsave(&phba->hbalock, iflag);
 			if (unlikely(!cmdiocbq))
 				break;
-			if (cmdiocbq->cmd_flag & LPFC_DRIVER_ABORTED)
-				cmdiocbq->cmd_flag &= ~LPFC_DRIVER_ABORTED;
-			if (cmdiocbq->cmd_cmpl) {
+			if (cmdiocbq->iocb_flag & LPFC_DRIVER_ABORTED)
+				cmdiocbq->iocb_flag &= ~LPFC_DRIVER_ABORTED;
+			if (cmdiocbq->iocb_cmpl) {
 				spin_unlock_irqrestore(&phba->hbalock, iflag);
-				cmdiocbq->cmd_cmpl(phba, cmdiocbq, &rspiocbq);
+				(cmdiocbq->iocb_cmpl)(phba, cmdiocbq,
+						      &rspiocbq);
 				spin_lock_irqsave(&phba->hbalock, iflag);
 			}
 			break;
@@ -4088,159 +4090,155 @@ lpfc_sli_sp_handle_rspiocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 			struct lpfc_iocbq *rspiocbp)
 {
 	struct lpfc_iocbq *saveq;
-	struct lpfc_iocbq *cmdiocb;
+	struct lpfc_iocbq *cmdiocbp;
 	struct lpfc_iocbq *next_iocb;
-	IOCB_t *irsp;
+	IOCB_t *irsp = NULL;
 	uint32_t free_saveq;
-	u8 cmd_type;
+	uint8_t iocb_cmd_type;
 	lpfc_iocb_type type;
 	unsigned long iflag;
-	u32 ulp_status = get_job_ulpstatus(phba, rspiocbp);
-	u32 ulp_word4 = get_job_word4(phba, rspiocbp);
-	u32 ulp_command = get_job_cmnd(phba, rspiocbp);
 	int rc;
 
 	spin_lock_irqsave(&phba->hbalock, iflag);
 	/* First add the response iocb to the countinueq list */
-	list_add_tail(&rspiocbp->list, &pring->iocb_continueq);
+	list_add_tail(&rspiocbp->list, &(pring->iocb_continueq));
 	pring->iocb_continueq_cnt++;
 
-	/*
-	 * By default, the driver expects to free all resources
-	 * associated with this iocb completion.
-	 */
-	free_saveq = 1;
-	saveq = list_get_first(&pring->iocb_continueq,
-			       struct lpfc_iocbq, list);
-	list_del_init(&pring->iocb_continueq);
-	pring->iocb_continueq_cnt = 0;
+	/* Now, determine whether the list is completed for processing */
+	irsp = &rspiocbp->iocb;
+	if (irsp->ulpLe) {
+		/*
+		 * By default, the driver expects to free all resources
+		 * associated with this iocb completion.
+		 */
+		free_saveq = 1;
+		saveq = list_get_first(&pring->iocb_continueq,
+				       struct lpfc_iocbq, list);
+		irsp = &(saveq->iocb);
+		list_del_init(&pring->iocb_continueq);
+		pring->iocb_continueq_cnt = 0;
 
-	pring->stats.iocb_rsp++;
+		pring->stats.iocb_rsp++;
 
-	/*
-	 * If resource errors reported from HBA, reduce
-	 * queuedepths of the SCSI device.
-	 */
-	if (ulp_status == IOSTAT_LOCAL_REJECT &&
-	    ((ulp_word4 & IOERR_PARAM_MASK) ==
-	     IOERR_NO_RESOURCES)) {
-		spin_unlock_irqrestore(&phba->hbalock, iflag);
-		phba->lpfc_rampdown_queue_depth(phba);
-		spin_lock_irqsave(&phba->hbalock, iflag);
-	}
+		/*
+		 * If resource errors reported from HBA, reduce
+		 * queuedepths of the SCSI device.
+		 */
+		if ((irsp->ulpStatus == IOSTAT_LOCAL_REJECT) &&
+		    ((irsp->un.ulpWord[4] & IOERR_PARAM_MASK) ==
+		     IOERR_NO_RESOURCES)) {
+			spin_unlock_irqrestore(&phba->hbalock, iflag);
+			phba->lpfc_rampdown_queue_depth(phba);
+			spin_lock_irqsave(&phba->hbalock, iflag);
+		}
 
-	if (ulp_status) {
-		/* Rsp ring <ringno> error: IOCB */
-		if (phba->sli_rev < LPFC_SLI_REV4) {
-			irsp = &rspiocbp->iocb;
-			lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
-					"0328 Rsp Ring %d error: ulp_status x%x "
-					"IOCB Data: "
-					"x%08x x%08x x%08x x%08x "
-					"x%08x x%08x x%08x x%08x "
-					"x%08x x%08x x%08x x%08x "
-					"x%08x x%08x x%08x x%08x\n",
-					pring->ringno, ulp_status,
-					get_job_ulpword(rspiocbp, 0),
-					get_job_ulpword(rspiocbp, 1),
-					get_job_ulpword(rspiocbp, 2),
-					get_job_ulpword(rspiocbp, 3),
-					get_job_ulpword(rspiocbp, 4),
-					get_job_ulpword(rspiocbp, 5),
-					*(((uint32_t *)irsp) + 6),
-					*(((uint32_t *)irsp) + 7),
-					*(((uint32_t *)irsp) + 8),
-					*(((uint32_t *)irsp) + 9),
-					*(((uint32_t *)irsp) + 10),
-					*(((uint32_t *)irsp) + 11),
-					*(((uint32_t *)irsp) + 12),
-					*(((uint32_t *)irsp) + 13),
-					*(((uint32_t *)irsp) + 14),
-					*(((uint32_t *)irsp) + 15));
-		} else {
+		if (irsp->ulpStatus) {
+			/* Rsp ring <ringno> error: IOCB */
 			lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
-					"0321 Rsp Ring %d error: "
+					"0328 Rsp Ring %d error: "
 					"IOCB Data: "
+					"x%x x%x x%x x%x "
+					"x%x x%x x%x x%x "
+					"x%x x%x x%x x%x "
 					"x%x x%x x%x x%x\n",
 					pring->ringno,
-					rspiocbp->wcqe_cmpl.word0,
-					rspiocbp->wcqe_cmpl.total_data_placed,
-					rspiocbp->wcqe_cmpl.parameter,
-					rspiocbp->wcqe_cmpl.word3);
+					irsp->un.ulpWord[0],
+					irsp->un.ulpWord[1],
+					irsp->un.ulpWord[2],
+					irsp->un.ulpWord[3],
+					irsp->un.ulpWord[4],
+					irsp->un.ulpWord[5],
+					*(((uint32_t *) irsp) + 6),
+					*(((uint32_t *) irsp) + 7),
+					*(((uint32_t *) irsp) + 8),
+					*(((uint32_t *) irsp) + 9),
+					*(((uint32_t *) irsp) + 10),
+					*(((uint32_t *) irsp) + 11),
+					*(((uint32_t *) irsp) + 12),
+					*(((uint32_t *) irsp) + 13),
+					*(((uint32_t *) irsp) + 14),
+					*(((uint32_t *) irsp) + 15));
 		}
-	}
 
+		/*
+		 * Fetch the IOCB command type and call the correct completion
+		 * routine. Solicited and Unsolicited IOCBs on the ELS ring
+		 * get freed back to the lpfc_iocb_list by the discovery
+		 * kernel thread.
+		 */
+		iocb_cmd_type = irsp->ulpCommand & CMD_IOCB_MASK;
+		type = lpfc_sli_iocb_cmd_type(iocb_cmd_type);
+		switch (type) {
+		case LPFC_SOL_IOCB:
+			spin_unlock_irqrestore(&phba->hbalock, iflag);
+			rc = lpfc_sli_process_sol_iocb(phba, pring, saveq);
+			spin_lock_irqsave(&phba->hbalock, iflag);
+			break;
 
-	/*
-	 * Fetch the iocb command type and call the correct completion
-	 * routine. Solicited and Unsolicited IOCBs on the ELS ring
-	 * get freed back to the lpfc_iocb_list by the discovery
-	 * kernel thread.
-	 */
-	cmd_type = ulp_command & CMD_IOCB_MASK;
-	type = lpfc_sli_iocb_cmd_type(cmd_type);
-	switch (type) {
-	case LPFC_SOL_IOCB:
-		spin_unlock_irqrestore(&phba->hbalock, iflag);
-		rc = lpfc_sli_process_sol_iocb(phba, pring, saveq);
-		spin_lock_irqsave(&phba->hbalock, iflag);
-		break;
-	case LPFC_UNSOL_IOCB:
-		spin_unlock_irqrestore(&phba->hbalock, iflag);
-		rc = lpfc_sli_process_unsol_iocb(phba, pring, saveq);
-		spin_lock_irqsave(&phba->hbalock, iflag);
-		if (!rc)
-			free_saveq = 0;
-		break;
-	case LPFC_ABORT_IOCB:
-		cmdiocb = NULL;
-		if (ulp_command != CMD_XRI_ABORTED_CX)
-			cmdiocb = lpfc_sli_iocbq_lookup(phba, pring,
-							saveq);
-		if (cmdiocb) {
-			/* Call the specified completion routine */
-			if (cmdiocb->cmd_cmpl) {
+		case LPFC_UNSOL_IOCB:
+			spin_unlock_irqrestore(&phba->hbalock, iflag);
+			rc = lpfc_sli_process_unsol_iocb(phba, pring, saveq);
+			spin_lock_irqsave(&phba->hbalock, iflag);
+			if (!rc)
+				free_saveq = 0;
+			break;
+
+		case LPFC_ABORT_IOCB:
+			cmdiocbp = NULL;
+			if (irsp->ulpCommand != CMD_XRI_ABORTED_CX) {
 				spin_unlock_irqrestore(&phba->hbalock, iflag);
-				cmdiocb->cmd_cmpl(phba, cmdiocb, saveq);
+				cmdiocbp = lpfc_sli_iocbq_lookup(phba, pring,
+								 saveq);
 				spin_lock_irqsave(&phba->hbalock, iflag);
+			}
+			if (cmdiocbp) {
+				/* Call the specified completion routine */
+				if (cmdiocbp->iocb_cmpl) {
+					spin_unlock_irqrestore(&phba->hbalock,
+							       iflag);
+					(cmdiocbp->iocb_cmpl)(phba, cmdiocbp,
+							      saveq);
+					spin_lock_irqsave(&phba->hbalock,
+							  iflag);
+				} else
+					__lpfc_sli_release_iocbq(phba,
+								 cmdiocbp);
+			}
+			break;
+
+		case LPFC_UNKNOWN_IOCB:
+			if (irsp->ulpCommand == CMD_ADAPTER_MSG) {
+				char adaptermsg[LPFC_MAX_ADPTMSG];
+				memset(adaptermsg, 0, LPFC_MAX_ADPTMSG);
+				memcpy(&adaptermsg[0], (uint8_t *)irsp,
+				       MAX_MSG_DATA);
+				dev_warn(&((phba->pcidev)->dev),
+					 "lpfc%d: %s\n",
+					 phba->brd_no, adaptermsg);
 			} else {
-				__lpfc_sli_release_iocbq(phba, cmdiocb);
+				/* Unknown IOCB command */
+				lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
+						"0335 Unknown IOCB "
+						"command Data: x%x "
+						"x%x x%x x%x\n",
+						irsp->ulpCommand,
+						irsp->ulpStatus,
+						irsp->ulpIoTag,
+						irsp->ulpContext);
 			}
+			break;
 		}
-		break;
-	case LPFC_UNKNOWN_IOCB:
-		if (ulp_command == CMD_ADAPTER_MSG) {
-			char adaptermsg[LPFC_MAX_ADPTMSG];
-
-			memset(adaptermsg, 0, LPFC_MAX_ADPTMSG);
-			memcpy(&adaptermsg[0], (uint8_t *)&rspiocbp->wqe,
-			       MAX_MSG_DATA);
-			dev_warn(&((phba->pcidev)->dev),
-				 "lpfc%d: %s\n",
-				 phba->brd_no, adaptermsg);
-		} else {
-			/* Unknown command */
-			lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
-					"0335 Unknown IOCB "
-					"command Data: x%x "
-					"x%x x%x x%x\n",
-					ulp_command,
-					ulp_status,
-					get_wqe_reqtag(rspiocbp),
-					get_job_ulpcontext(phba, rspiocbp));
-		}
-		break;
-	}
 
-	if (free_saveq) {
-		list_for_each_entry_safe(rspiocbp, next_iocb,
-					 &saveq->list, list) {
-			list_del_init(&rspiocbp->list);
-			__lpfc_sli_release_iocbq(phba, rspiocbp);
+		if (free_saveq) {
+			list_for_each_entry_safe(rspiocbp, next_iocb,
+						 &saveq->list, list) {
+				list_del_init(&rspiocbp->list);
+				__lpfc_sli_release_iocbq(phba, rspiocbp);
+			}
+			__lpfc_sli_release_iocbq(phba, saveq);
 		}
-		__lpfc_sli_release_iocbq(phba, saveq);
+		rspiocbp = NULL;
 	}
-	rspiocbp = NULL;
 	spin_unlock_irqrestore(&phba->hbalock, iflag);
 	return rspiocbp;
 }
@@ -4433,8 +4431,8 @@ lpfc_sli_handle_slow_ring_event_s4(struct lpfc_hba *phba,
 			irspiocbq = container_of(cq_event, struct lpfc_iocbq,
 						 cq_event);
 			/* Translate ELS WCQE to response IOCBQ */
-			irspiocbq = lpfc_sli4_els_preprocess_rspiocbq(phba,
-								      irspiocbq);
+			irspiocbq = lpfc_sli4_els_wcqe_to_rspiocbq(phba,
+								   irspiocbq);
 			if (irspiocbq)
 				lpfc_sli_sp_handle_rspiocb(phba, pring,
 							   irspiocbq);
@@ -4577,7 +4575,7 @@ lpfc_sli_flush_io_rings(struct lpfc_hba *phba)
 			list_splice_init(&pring->txq, &txq);
 			list_for_each_entry_safe(piocb, next_iocb,
 						 &pring->txcmplq, list)
-				piocb->cmd_flag &= ~LPFC_IO_ON_TXCMPLQ;
+				piocb->iocb_flag &= ~LPFC_IO_ON_TXCMPLQ;
 			/* Retrieve everything on the txcmplq */
 			list_splice_init(&pring->txcmplq, &txcmplq);
 			pring->txq_cnt = 0;
@@ -4603,7 +4601,7 @@ lpfc_sli_flush_io_rings(struct lpfc_hba *phba)
 		list_splice_init(&pring->txq, &txq);
 		list_for_each_entry_safe(piocb, next_iocb,
 					 &pring->txcmplq, list)
-			piocb->cmd_flag &= ~LPFC_IO_ON_TXCMPLQ;
+			piocb->iocb_flag &= ~LPFC_IO_ON_TXCMPLQ;
 		/* Retrieve everything on the txcmplq */
 		list_splice_init(&pring->txcmplq, &txcmplq);
 		pring->txq_cnt = 0;
@@ -10119,7 +10117,7 @@ __lpfc_sli_issue_iocb_s3(struct lpfc_hba *phba, uint32_t ring_number,
 
 	lockdep_assert_held(&phba->hbalock);
 
-	if (piocb->cmd_cmpl && (!piocb->vport) &&
+	if (piocb->iocb_cmpl && (!piocb->vport) &&
 	   (piocb->iocb.ulpCommand != CMD_ABORT_XRI_CN) &&
 	   (piocb->iocb.ulpCommand != CMD_CLOSE_XRI_CN)) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
@@ -10171,10 +10169,10 @@ __lpfc_sli_issue_iocb_s3(struct lpfc_hba *phba, uint32_t ring_number,
 		case CMD_QUE_RING_BUF64_CN:
 			/*
 			 * For IOCBs, like QUE_RING_BUF, that have no rsp ring
-			 * completion, cmd_cmpl MUST be 0.
+			 * completion, iocb_cmpl MUST be 0.
 			 */
-			if (piocb->cmd_cmpl)
-				piocb->cmd_cmpl = NULL;
+			if (piocb->iocb_cmpl)
+				piocb->iocb_cmpl = NULL;
 			fallthrough;
 		case CMD_CREATE_XRI_CR:
 		case CMD_CLOSE_XRI_CN:
@@ -10365,9 +10363,9 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
 
 	fip = phba->hba_flag & HBA_FIP_SUPPORT;
 	/* The fcp commands will set command type */
-	if (iocbq->cmd_flag &  LPFC_IO_FCP)
+	if (iocbq->iocb_flag &  LPFC_IO_FCP)
 		command_type = FCP_COMMAND;
-	else if (fip && (iocbq->cmd_flag & LPFC_FIP_ELS_ID_MASK))
+	else if (fip && (iocbq->iocb_flag & LPFC_FIP_ELS_ID_MASK))
 		command_type = ELS_COMMAND_FIP;
 	else
 		command_type = ELS_COMMAND_NON_FIP;
@@ -10412,7 +10410,7 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
 
 	switch (iocbq->iocb.ulpCommand) {
 	case CMD_ELS_REQUEST64_CR:
-		if (iocbq->cmd_flag & LPFC_IO_LIBDFC)
+		if (iocbq->iocb_flag & LPFC_IO_LIBDFC)
 			ndlp = iocbq->context_un.ndlp;
 		else
 			ndlp = (struct lpfc_nodelist *)iocbq->context1;
@@ -10439,7 +10437,7 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
 		bf_set(wqe_pu, &wqe->els_req.wqe_com, 0);
 		/* CCP CCPE PV PRI in word10 were set in the memcpy */
 		if (command_type == ELS_COMMAND_FIP)
-			els_id = ((iocbq->cmd_flag & LPFC_FIP_ELS_ID_MASK)
+			els_id = ((iocbq->iocb_flag & LPFC_FIP_ELS_ID_MASK)
 					>> LPFC_FIP_ELS_ID_SHIFT);
 		pcmd = (uint32_t *) (((struct lpfc_dmabuf *)
 					iocbq->context2)->virt);
@@ -10541,7 +10539,7 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
 		       LPFC_WQE_LENLOC_WORD4);
 		bf_set(wqe_pu, &wqe->fcp_iwrite.wqe_com, iocbq->iocb.ulpPU);
 		bf_set(wqe_dbde, &wqe->fcp_iwrite.wqe_com, 1);
-		if (iocbq->cmd_flag & LPFC_IO_OAS) {
+		if (iocbq->iocb_flag & LPFC_IO_OAS) {
 			bf_set(wqe_oas, &wqe->fcp_iwrite.wqe_com, 1);
 			bf_set(wqe_ccpe, &wqe->fcp_iwrite.wqe_com, 1);
 			if (iocbq->priority) {
@@ -10605,7 +10603,7 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
 		       LPFC_WQE_LENLOC_WORD4);
 		bf_set(wqe_pu, &wqe->fcp_iread.wqe_com, iocbq->iocb.ulpPU);
 		bf_set(wqe_dbde, &wqe->fcp_iread.wqe_com, 1);
-		if (iocbq->cmd_flag & LPFC_IO_OAS) {
+		if (iocbq->iocb_flag & LPFC_IO_OAS) {
 			bf_set(wqe_oas, &wqe->fcp_iread.wqe_com, 1);
 			bf_set(wqe_ccpe, &wqe->fcp_iread.wqe_com, 1);
 			if (iocbq->priority) {
@@ -10668,7 +10666,7 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
 		       LPFC_WQE_LENLOC_NONE);
 		bf_set(wqe_erp, &wqe->fcp_icmd.wqe_com,
 		       iocbq->iocb.ulpFCP2Rcvy);
-		if (iocbq->cmd_flag & LPFC_IO_OAS) {
+		if (iocbq->iocb_flag & LPFC_IO_OAS) {
 			bf_set(wqe_oas, &wqe->fcp_icmd.wqe_com, 1);
 			bf_set(wqe_ccpe, &wqe->fcp_icmd.wqe_com, 1);
 			if (iocbq->priority) {
@@ -10802,7 +10800,7 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
 		abrt_iotag = iocbq->iocb.un.acxri.abortContextTag;
 		if (abrt_iotag != 0 && abrt_iotag <= phba->sli.last_iotag) {
 			abrtiocbq = phba->sli.iocbq_lookup[abrt_iotag];
-			fip = abrtiocbq->cmd_flag & LPFC_FIP_ELS_ID_MASK;
+			fip = abrtiocbq->iocb_flag & LPFC_FIP_ELS_ID_MASK;
 		} else
 			fip = 0;
 
@@ -10911,13 +10909,13 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
 		return IOCB_ERROR;
 	}
 
-	if (iocbq->cmd_flag & LPFC_IO_DIF_PASS)
+	if (iocbq->iocb_flag & LPFC_IO_DIF_PASS)
 		bf_set(wqe_dif, &wqe->generic.wqe_com, LPFC_WQE_DIF_PASSTHRU);
-	else if (iocbq->cmd_flag & LPFC_IO_DIF_STRIP)
+	else if (iocbq->iocb_flag & LPFC_IO_DIF_STRIP)
 		bf_set(wqe_dif, &wqe->generic.wqe_com, LPFC_WQE_DIF_STRIP);
-	else if (iocbq->cmd_flag & LPFC_IO_DIF_INSERT)
+	else if (iocbq->iocb_flag & LPFC_IO_DIF_INSERT)
 		bf_set(wqe_dif, &wqe->generic.wqe_com, LPFC_WQE_DIF_INSERT);
-	iocbq->cmd_flag &= ~(LPFC_IO_DIF_PASS | LPFC_IO_DIF_STRIP |
+	iocbq->iocb_flag &= ~(LPFC_IO_DIF_PASS | LPFC_IO_DIF_STRIP |
 			      LPFC_IO_DIF_INSERT);
 	bf_set(wqe_xri_tag, &wqe->generic.wqe_com, xritag);
 	bf_set(wqe_reqtag, &wqe->generic.wqe_com, iocbq->iotag);
@@ -10937,7 +10935,7 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
  * @flag: Flag indicating if this command can be put into txq.
  *
  * __lpfc_sli_issue_fcp_io_s3 is wrapper function to invoke lockless func to
- * send  an iocb command to an HBA with SLI-3 interface spec.
+ * send  an iocb command to an HBA with SLI-4 interface spec.
  *
  * This function takes the hbalock before invoking the lockless version.
  * The function will return success after it successfully submit the wqe to
@@ -10978,17 +10976,7 @@ __lpfc_sli_issue_fcp_io_s4(struct lpfc_hba *phba, uint32_t ring_number,
 	int rc;
 	struct lpfc_io_buf *lpfc_cmd =
 		(struct lpfc_io_buf *)piocb->context1;
-
-	lpfc_prep_embed_io(phba, lpfc_cmd);
-	rc = lpfc_sli4_issue_wqe(phba, lpfc_cmd->hdwq, piocb);
-	return rc;
-}
-
-void
-lpfc_prep_embed_io(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
-{
-	struct lpfc_iocbq *piocb = &lpfc_cmd->cur_iocbq;
-	union lpfc_wqe128 *wqe = &lpfc_cmd->cur_iocbq.wqe;
+	union lpfc_wqe128 *wqe = &piocb->wqe;
 	struct sli4_sge *sgl;
 
 	/* 128 byte wqe support here */
@@ -11026,7 +11014,7 @@ lpfc_prep_embed_io(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 	}
 
 	/* add the VMID tags as per switch response */
-	if (unlikely(piocb->cmd_flag & LPFC_IO_VMID)) {
+	if (unlikely(piocb->iocb_flag & LPFC_IO_VMID)) {
 		if (phba->pport->vmid_priority_tagging) {
 			bf_set(wqe_ccpe, &wqe->fcp_iwrite.wqe_com, 1);
 			bf_set(wqe_ccp, &wqe->fcp_iwrite.wqe_com,
@@ -11037,6 +11025,8 @@ lpfc_prep_embed_io(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 			wqe->words[31] = piocb->vmid_tag.app_id;
 		}
 	}
+	rc = lpfc_sli4_issue_wqe(phba, lpfc_cmd->hdwq, piocb);
+	return rc;
 }
 
 /**
@@ -11058,14 +11048,13 @@ __lpfc_sli_issue_iocb_s4(struct lpfc_hba *phba, uint32_t ring_number,
 			 struct lpfc_iocbq *piocb, uint32_t flag)
 {
 	struct lpfc_sglq *sglq;
-	union lpfc_wqe128 *wqe;
+	union lpfc_wqe128 wqe;
 	struct lpfc_queue *wq;
 	struct lpfc_sli_ring *pring;
-	u32 ulp_command = get_job_cmnd(phba, piocb);
 
 	/* Get the WQ */
-	if ((piocb->cmd_flag & LPFC_IO_FCP) ||
-	    (piocb->cmd_flag & LPFC_USE_FCPWQIDX)) {
+	if ((piocb->iocb_flag & LPFC_IO_FCP) ||
+	    (piocb->iocb_flag & LPFC_USE_FCPWQIDX)) {
 		wq = phba->sli4_hba.hdwq[piocb->hba_wqidx].io_wq;
 	} else {
 		wq = phba->sli4_hba.els_wq;
@@ -11079,9 +11068,10 @@ __lpfc_sli_issue_iocb_s4(struct lpfc_hba *phba, uint32_t ring_number,
 	 */
 
 	lockdep_assert_held(&pring->ring_lock);
-	wqe = &piocb->wqe;
+
 	if (piocb->sli4_xritag == NO_XRI) {
-		if (ulp_command == CMD_ABORT_XRI_WQE)
+		if (piocb->iocb.ulpCommand == CMD_ABORT_XRI_CN ||
+		    piocb->iocb.ulpCommand == CMD_CLOSE_XRI_CN)
 			sglq = NULL;
 		else {
 			if (!list_empty(&pring->txq)) {
@@ -11105,7 +11095,7 @@ __lpfc_sli_issue_iocb_s4(struct lpfc_hba *phba, uint32_t ring_number,
 				}
 			}
 		}
-	} else if (piocb->cmd_flag &  LPFC_IO_FCP) {
+	} else if (piocb->iocb_flag &  LPFC_IO_FCP) {
 		/* These IO's already have an XRI and a mapped sgl. */
 		sglq = NULL;
 	}
@@ -11122,24 +11112,14 @@ __lpfc_sli_issue_iocb_s4(struct lpfc_hba *phba, uint32_t ring_number,
 	if (sglq) {
 		piocb->sli4_lxritag = sglq->sli4_lxritag;
 		piocb->sli4_xritag = sglq->sli4_xritag;
-
-		/* ABTS sent by initiator to CT exchange, the
-		 * RX_ID field will be filled with the newly
-		 * allocated responder XRI.
-		 */
-		if (ulp_command == CMD_XMIT_BLS_RSP64_CX &&
-		    piocb->abort_bls == LPFC_ABTS_UNSOL_INT)
-			bf_set(xmit_bls_rsp64_rxid, &wqe->xmit_bls_rsp,
-			       piocb->sli4_xritag);
-
-		bf_set(wqe_xri_tag, &wqe->generic.wqe_com,
-		       piocb->sli4_xritag);
-
-		if (lpfc_wqe_bpl2sgl(phba, piocb, sglq) == NO_XRI)
+		if (NO_XRI == lpfc_sli4_bpl2sgl(phba, piocb, sglq))
 			return IOCB_ERROR;
 	}
 
-	if (lpfc_sli4_wq_put(wq, wqe))
+	if (lpfc_sli4_iocb2wqe(phba, piocb, &wqe))
+		return IOCB_ERROR;
+
+	if (lpfc_sli4_wq_put(wq, &wqe))
 		return IOCB_ERROR;
 	lpfc_sli_ringtxcmpl_put(phba, pring, piocb);
 
@@ -11232,14 +11212,14 @@ lpfc_sli4_calc_ring(struct lpfc_hba *phba, struct lpfc_iocbq *piocb)
 {
 	struct lpfc_io_buf *lpfc_cmd;
 
-	if (piocb->cmd_flag & (LPFC_IO_FCP | LPFC_USE_FCPWQIDX)) {
+	if (piocb->iocb_flag & (LPFC_IO_FCP | LPFC_USE_FCPWQIDX)) {
 		if (unlikely(!phba->sli4_hba.hdwq))
 			return NULL;
 		/*
 		 * for abort iocb hba_wqidx should already
 		 * be setup based on what work queue we used.
 		 */
-		if (!(piocb->cmd_flag & LPFC_USE_FCPWQIDX)) {
+		if (!(piocb->iocb_flag & LPFC_USE_FCPWQIDX)) {
 			lpfc_cmd = (struct lpfc_io_buf *)piocb->context1;
 			piocb->hba_wqidx = lpfc_cmd->hdwq_no;
 		}
@@ -12381,14 +12361,14 @@ lpfc_sli_issue_abort_iotag(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	icmd = &cmdiocb->iocb;
 	if (icmd->ulpCommand == CMD_ABORT_XRI_CN ||
 	    icmd->ulpCommand == CMD_CLOSE_XRI_CN ||
-	    cmdiocb->cmd_flag & LPFC_DRIVER_ABORTED)
+	    cmdiocb->iocb_flag & LPFC_DRIVER_ABORTED)
 		return IOCB_ABORTING;
 
 	if (!pring) {
-		if (cmdiocb->cmd_flag & LPFC_IO_FABRIC)
-			cmdiocb->fabric_cmd_cmpl = lpfc_ignore_els_cmpl;
+		if (cmdiocb->iocb_flag & LPFC_IO_FABRIC)
+			cmdiocb->fabric_iocb_cmpl = lpfc_ignore_els_cmpl;
 		else
-			cmdiocb->cmd_cmpl = lpfc_ignore_els_cmpl;
+			cmdiocb->iocb_cmpl = lpfc_ignore_els_cmpl;
 		return retval;
 	}
 
@@ -12398,10 +12378,10 @@ lpfc_sli_issue_abort_iotag(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	 */
 	if ((vport->load_flag & FC_UNLOADING) &&
 	    pring->ringno == LPFC_ELS_RING) {
-		if (cmdiocb->cmd_flag & LPFC_IO_FABRIC)
-			cmdiocb->fabric_cmd_cmpl = lpfc_ignore_els_cmpl;
+		if (cmdiocb->iocb_flag & LPFC_IO_FABRIC)
+			cmdiocb->fabric_iocb_cmpl = lpfc_ignore_els_cmpl;
 		else
-			cmdiocb->cmd_cmpl = lpfc_ignore_els_cmpl;
+			cmdiocb->iocb_cmpl = lpfc_ignore_els_cmpl;
 		return retval;
 	}
 
@@ -12413,7 +12393,7 @@ lpfc_sli_issue_abort_iotag(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	/* This signals the response to set the correct status
 	 * before calling the completion handler
 	 */
-	cmdiocb->cmd_flag |= LPFC_DRIVER_ABORTED;
+	cmdiocb->iocb_flag |= LPFC_DRIVER_ABORTED;
 
 	iabt = &abtsiocbp->iocb;
 	iabt->un.acxri.abortType = ABORT_TYPE_ABTS;
@@ -12434,10 +12414,10 @@ lpfc_sli_issue_abort_iotag(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 
 	/* ABTS WQE must go to the same WQ as the WQE to be aborted */
 	abtsiocbp->hba_wqidx = cmdiocb->hba_wqidx;
-	if (cmdiocb->cmd_flag & LPFC_IO_FCP)
-		abtsiocbp->cmd_flag |= (LPFC_IO_FCP | LPFC_USE_FCPWQIDX);
-	if (cmdiocb->cmd_flag & LPFC_IO_FOF)
-		abtsiocbp->cmd_flag |= LPFC_IO_FOF;
+	if (cmdiocb->iocb_flag & LPFC_IO_FCP)
+		abtsiocbp->iocb_flag |= (LPFC_IO_FCP | LPFC_USE_FCPWQIDX);
+	if (cmdiocb->iocb_flag & LPFC_IO_FOF)
+		abtsiocbp->iocb_flag |= LPFC_IO_FOF;
 
 	if (phba->link_state < LPFC_LINK_UP ||
 	    (phba->sli_rev == LPFC_SLI_REV4 &&
@@ -12447,9 +12427,9 @@ lpfc_sli_issue_abort_iotag(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 		iabt->ulpCommand = CMD_ABORT_XRI_CN;
 
 	if (cmpl)
-		abtsiocbp->cmd_cmpl = cmpl;
+		abtsiocbp->iocb_cmpl = cmpl;
 	else
-		abtsiocbp->cmd_cmpl = lpfc_sli_abort_els_cmpl;
+		abtsiocbp->iocb_cmpl = lpfc_sli_abort_els_cmpl;
 	abtsiocbp->vport = vport;
 
 	if (phba->sli_rev == LPFC_SLI_REV4) {
@@ -12476,7 +12456,7 @@ lpfc_sli_issue_abort_iotag(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 			 abtsiocbp->iotag, retval);
 
 	if (retval) {
-		cmdiocb->cmd_flag &= ~LPFC_DRIVER_ABORTED;
+		cmdiocb->iocb_flag &= ~LPFC_DRIVER_ABORTED;
 		__lpfc_sli_release_iocbq(phba, abtsiocbp);
 	}
 
@@ -12544,9 +12524,9 @@ lpfc_sli_validate_fcp_iocb_for_abort(struct lpfc_iocbq *iocbq,
 	 * can't be premarked as driver aborted, nor be an ABORT iocb itself
 	 */
 	icmd = &iocbq->iocb;
-	if (!(iocbq->cmd_flag & LPFC_IO_FCP) ||
-	    !(iocbq->cmd_flag & LPFC_IO_ON_TXCMPLQ) ||
-	    (iocbq->cmd_flag & LPFC_DRIVER_ABORTED) ||
+	if (!(iocbq->iocb_flag & LPFC_IO_FCP) ||
+	    !(iocbq->iocb_flag & LPFC_IO_ON_TXCMPLQ) ||
+	    (iocbq->iocb_flag & LPFC_DRIVER_ABORTED) ||
 	    (icmd->ulpCommand == CMD_ABORT_XRI_CN ||
 	     icmd->ulpCommand == CMD_CLOSE_XRI_CN))
 		return -EINVAL;
@@ -12650,8 +12630,8 @@ lpfc_sli_sum_iocb(struct lpfc_vport *vport, uint16_t tgt_id, uint64_t lun_id,
 
 		if (!iocbq || iocbq->vport != vport)
 			continue;
-		if (!(iocbq->cmd_flag & LPFC_IO_FCP) ||
-		    !(iocbq->cmd_flag & LPFC_IO_ON_TXCMPLQ))
+		if (!(iocbq->iocb_flag & LPFC_IO_FCP) ||
+		    !(iocbq->iocb_flag & LPFC_IO_ON_TXCMPLQ))
 			continue;
 
 		/* Include counting outstanding aborts */
@@ -12877,8 +12857,8 @@ lpfc_sli_abort_taskmgmt(struct lpfc_vport *vport, struct lpfc_sli_ring *pring,
 		 * If the iocbq is already being aborted, don't take a second
 		 * action, but do count it.
 		 */
-		if ((iocbq->cmd_flag & LPFC_DRIVER_ABORTED) ||
-		    !(iocbq->cmd_flag & LPFC_IO_ON_TXCMPLQ)) {
+		if ((iocbq->iocb_flag & LPFC_DRIVER_ABORTED) ||
+		    !(iocbq->iocb_flag & LPFC_IO_ON_TXCMPLQ)) {
 			if (phba->sli_rev == LPFC_SLI_REV4)
 				spin_unlock(&pring_s4->ring_lock);
 			spin_unlock(&lpfc_cmd->buf_lock);
@@ -12908,10 +12888,10 @@ lpfc_sli_abort_taskmgmt(struct lpfc_vport *vport, struct lpfc_sli_ring *pring,
 
 		/* ABTS WQE must go to the same WQ as the WQE to be aborted */
 		abtsiocbq->hba_wqidx = iocbq->hba_wqidx;
-		if (iocbq->cmd_flag & LPFC_IO_FCP)
-			abtsiocbq->cmd_flag |= LPFC_USE_FCPWQIDX;
-		if (iocbq->cmd_flag & LPFC_IO_FOF)
-			abtsiocbq->cmd_flag |= LPFC_IO_FOF;
+		if (iocbq->iocb_flag & LPFC_IO_FCP)
+			abtsiocbq->iocb_flag |= LPFC_USE_FCPWQIDX;
+		if (iocbq->iocb_flag & LPFC_IO_FOF)
+			abtsiocbq->iocb_flag |= LPFC_IO_FOF;
 
 		ndlp = lpfc_cmd->rdata->pnode;
 
@@ -12922,13 +12902,13 @@ lpfc_sli_abort_taskmgmt(struct lpfc_vport *vport, struct lpfc_sli_ring *pring,
 			abtsiocbq->iocb.ulpCommand = CMD_CLOSE_XRI_CN;
 
 		/* Setup callback routine and issue the command. */
-		abtsiocbq->cmd_cmpl = lpfc_sli_abort_fcp_cmpl;
+		abtsiocbq->iocb_cmpl = lpfc_sli_abort_fcp_cmpl;
 
 		/*
 		 * Indicate the IO is being aborted by the driver and set
 		 * the caller's flag into the aborted IO.
 		 */
-		iocbq->cmd_flag |= LPFC_DRIVER_ABORTED;
+		iocbq->iocb_flag |= LPFC_DRIVER_ABORTED;
 
 		if (phba->sli_rev == LPFC_SLI_REV4) {
 			ret_val = __lpfc_sli_issue_iocb(phba, pring_s4->ringno,
@@ -12975,10 +12955,9 @@ lpfc_sli_wake_iocb_wait(struct lpfc_hba *phba,
 	wait_queue_head_t *pdone_q;
 	unsigned long iflags;
 	struct lpfc_io_buf *lpfc_cmd;
-	size_t offset = offsetof(struct lpfc_iocbq, wqe);
 
 	spin_lock_irqsave(&phba->hbalock, iflags);
-	if (cmdiocbq->cmd_flag & LPFC_IO_WAKE_TMO) {
+	if (cmdiocbq->iocb_flag & LPFC_IO_WAKE_TMO) {
 
 		/*
 		 * A time out has occurred for the iocb.  If a time out
@@ -12987,27 +12966,26 @@ lpfc_sli_wake_iocb_wait(struct lpfc_hba *phba,
 		 */
 
 		spin_unlock_irqrestore(&phba->hbalock, iflags);
-		cmdiocbq->cmd_cmpl = cmdiocbq->wait_cmd_cmpl;
-		cmdiocbq->wait_cmd_cmpl = NULL;
-		if (cmdiocbq->cmd_cmpl)
-			cmdiocbq->cmd_cmpl(phba, cmdiocbq, NULL);
+		cmdiocbq->iocb_cmpl = cmdiocbq->wait_iocb_cmpl;
+		cmdiocbq->wait_iocb_cmpl = NULL;
+		if (cmdiocbq->iocb_cmpl)
+			(cmdiocbq->iocb_cmpl)(phba, cmdiocbq, NULL);
 		else
 			lpfc_sli_release_iocbq(phba, cmdiocbq);
 		return;
 	}
 
-	/* Copy the contents of the local rspiocb into the caller's buffer. */
-	cmdiocbq->cmd_flag |= LPFC_IO_WAKE;
+	cmdiocbq->iocb_flag |= LPFC_IO_WAKE;
 	if (cmdiocbq->context2 && rspiocbq)
-		memcpy((char *)cmdiocbq->context2 + offset,
-		       (char *)rspiocbq + offset, sizeof(*rspiocbq) - offset);
+		memcpy(&((struct lpfc_iocbq *)cmdiocbq->context2)->iocb,
+		       &rspiocbq->iocb, sizeof(IOCB_t));
 
 	/* Set the exchange busy flag for task management commands */
-	if ((cmdiocbq->cmd_flag & LPFC_IO_FCP) &&
-	    !(cmdiocbq->cmd_flag & LPFC_IO_LIBDFC)) {
+	if ((cmdiocbq->iocb_flag & LPFC_IO_FCP) &&
+		!(cmdiocbq->iocb_flag & LPFC_IO_LIBDFC)) {
 		lpfc_cmd = container_of(cmdiocbq, struct lpfc_io_buf,
-					cur_iocbq);
-		if (rspiocbq && (rspiocbq->cmd_flag & LPFC_EXCHANGE_BUSY))
+			cur_iocbq);
+		if (rspiocbq && (rspiocbq->iocb_flag & LPFC_EXCHANGE_BUSY))
 			lpfc_cmd->flags |= LPFC_SBUF_XBUSY;
 		else
 			lpfc_cmd->flags &= ~LPFC_SBUF_XBUSY;
@@ -13026,7 +13004,7 @@ lpfc_sli_wake_iocb_wait(struct lpfc_hba *phba,
  * @piocbq: Pointer to command iocb.
  * @flag: Flag to test.
  *
- * This routine grabs the hbalock and then test the cmd_flag to
+ * This routine grabs the hbalock and then test the iocb_flag to
  * see if the passed in flag is set.
  * Returns:
  * 1 if flag is set.
@@ -13040,7 +13018,7 @@ lpfc_chk_iocb_flg(struct lpfc_hba *phba,
 	int ret;
 
 	spin_lock_irqsave(&phba->hbalock, iflags);
-	ret = piocbq->cmd_flag & flag;
+	ret = piocbq->iocb_flag & flag;
 	spin_unlock_irqrestore(&phba->hbalock, iflags);
 	return ret;
 
@@ -13055,14 +13033,14 @@ lpfc_chk_iocb_flg(struct lpfc_hba *phba,
  * @timeout: Timeout in number of seconds.
  *
  * This function issues the iocb to firmware and waits for the
- * iocb to complete. The cmd_cmpl field of the shall be used
+ * iocb to complete. The iocb_cmpl field of the shall be used
  * to handle iocbs which time out. If the field is NULL, the
  * function shall free the iocbq structure.  If more clean up is
  * needed, the caller is expected to provide a completion function
  * that will provide the needed clean up.  If the iocb command is
  * not completed within timeout seconds, the function will either
- * free the iocbq structure (if cmd_cmpl == NULL) or execute the
- * completion function set in the cmd_cmpl field and then return
+ * free the iocbq structure (if iocb_cmpl == NULL) or execute the
+ * completion function set in the iocb_cmpl field and then return
  * a status of IOCB_TIMEDOUT.  The caller should not free the iocb
  * resources if this function returns IOCB_TIMEDOUT.
  * The function waits for the iocb completion using an
@@ -13074,7 +13052,7 @@ lpfc_chk_iocb_flg(struct lpfc_hba *phba,
  * This function assumes that the iocb completions occur while
  * this function sleep. So, this function cannot be called from
  * the thread which process iocb completion for this ring.
- * This function clears the cmd_flag of the iocb object before
+ * This function clears the iocb_flag of the iocb object before
  * issuing the iocb and the iocb completion handler sets this
  * flag and wakes this thread when the iocb completes.
  * The contents of the response iocb will be copied to prspiocbq
@@ -13114,10 +13092,10 @@ lpfc_sli_issue_iocb_wait(struct lpfc_hba *phba,
 		piocb->context2 = prspiocbq;
 	}
 
-	piocb->wait_cmd_cmpl = piocb->cmd_cmpl;
-	piocb->cmd_cmpl = lpfc_sli_wake_iocb_wait;
+	piocb->wait_iocb_cmpl = piocb->iocb_cmpl;
+	piocb->iocb_cmpl = lpfc_sli_wake_iocb_wait;
 	piocb->context_un.wait_queue = &done_q;
-	piocb->cmd_flag &= ~(LPFC_IO_WAKE | LPFC_IO_WAKE_TMO);
+	piocb->iocb_flag &= ~(LPFC_IO_WAKE | LPFC_IO_WAKE_TMO);
 
 	if (phba->cfg_poll & DISABLE_FCP_RING_INT) {
 		if (lpfc_readl(phba->HCregaddr, &creg_val))
@@ -13135,7 +13113,7 @@ lpfc_sli_issue_iocb_wait(struct lpfc_hba *phba,
 				lpfc_chk_iocb_flg(phba, piocb, LPFC_IO_WAKE),
 				timeout_req);
 		spin_lock_irqsave(&phba->hbalock, iflags);
-		if (!(piocb->cmd_flag & LPFC_IO_WAKE)) {
+		if (!(piocb->iocb_flag & LPFC_IO_WAKE)) {
 
 			/*
 			 * IOCB timed out.  Inform the wake iocb wait
@@ -13143,7 +13121,7 @@ lpfc_sli_issue_iocb_wait(struct lpfc_hba *phba,
 			 */
 
 			iocb_completed = false;
-			piocb->cmd_flag |= LPFC_IO_WAKE_TMO;
+			piocb->iocb_flag |= LPFC_IO_WAKE_TMO;
 		}
 		spin_unlock_irqrestore(&phba->hbalock, iflags);
 		if (iocb_completed) {
@@ -13198,7 +13176,7 @@ lpfc_sli_issue_iocb_wait(struct lpfc_hba *phba,
 		piocb->context2 = NULL;
 
 	piocb->context_un.wait_queue = NULL;
-	piocb->cmd_cmpl = NULL;
+	piocb->iocb_cmpl = NULL;
 	return retval;
 }
 
@@ -14139,19 +14117,135 @@ void lpfc_sli4_els_xri_abort_event_proc(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_sli4_els_preprocess_rspiocbq - Get response iocbq from els wcqe
+ * lpfc_sli4_iocb_param_transfer - Transfer pIocbOut and cmpl status to pIocbIn
+ * @phba: pointer to lpfc hba data structure
+ * @pIocbIn: pointer to the rspiocbq
+ * @pIocbOut: pointer to the cmdiocbq
+ * @wcqe: pointer to the complete wcqe
+ *
+ * This routine transfers the fields of a command iocbq to a response iocbq
+ * by copying all the IOCB fields from command iocbq and transferring the
+ * completion status information from the complete wcqe.
+ **/
+static void
+lpfc_sli4_iocb_param_transfer(struct lpfc_hba *phba,
+			      struct lpfc_iocbq *pIocbIn,
+			      struct lpfc_iocbq *pIocbOut,
+			      struct lpfc_wcqe_complete *wcqe)
+{
+	int numBdes, i;
+	unsigned long iflags;
+	uint32_t status, max_response;
+	struct lpfc_dmabuf *dmabuf;
+	struct ulp_bde64 *bpl, bde;
+	size_t offset = offsetof(struct lpfc_iocbq, iocb);
+
+	memcpy((char *)pIocbIn + offset, (char *)pIocbOut + offset,
+	       sizeof(struct lpfc_iocbq) - offset);
+	/* Map WCQE parameters into irspiocb parameters */
+	status = bf_get(lpfc_wcqe_c_status, wcqe);
+	pIocbIn->iocb.ulpStatus = (status & LPFC_IOCB_STATUS_MASK);
+	if (pIocbOut->iocb_flag & LPFC_IO_FCP)
+		if (pIocbIn->iocb.ulpStatus == IOSTAT_FCP_RSP_ERROR)
+			pIocbIn->iocb.un.fcpi.fcpi_parm =
+					pIocbOut->iocb.un.fcpi.fcpi_parm -
+					wcqe->total_data_placed;
+		else
+			pIocbIn->iocb.un.ulpWord[4] = wcqe->parameter;
+	else {
+		pIocbIn->iocb.un.ulpWord[4] = wcqe->parameter;
+		switch (pIocbOut->iocb.ulpCommand) {
+		case CMD_ELS_REQUEST64_CR:
+			dmabuf = (struct lpfc_dmabuf *)pIocbOut->context3;
+			bpl  = (struct ulp_bde64 *)dmabuf->virt;
+			bde.tus.w = le32_to_cpu(bpl[1].tus.w);
+			max_response = bde.tus.f.bdeSize;
+			break;
+		case CMD_GEN_REQUEST64_CR:
+			max_response = 0;
+			if (!pIocbOut->context3)
+				break;
+			numBdes = pIocbOut->iocb.un.genreq64.bdl.bdeSize/
+					sizeof(struct ulp_bde64);
+			dmabuf = (struct lpfc_dmabuf *)pIocbOut->context3;
+			bpl = (struct ulp_bde64 *)dmabuf->virt;
+			for (i = 0; i < numBdes; i++) {
+				bde.tus.w = le32_to_cpu(bpl[i].tus.w);
+				if (bde.tus.f.bdeFlags != BUFF_TYPE_BDE_64)
+					max_response += bde.tus.f.bdeSize;
+			}
+			break;
+		default:
+			max_response = wcqe->total_data_placed;
+			break;
+		}
+		if (max_response < wcqe->total_data_placed)
+			pIocbIn->iocb.un.genreq64.bdl.bdeSize = max_response;
+		else
+			pIocbIn->iocb.un.genreq64.bdl.bdeSize =
+				wcqe->total_data_placed;
+	}
+
+	/* Convert BG errors for completion status */
+	if (status == CQE_STATUS_DI_ERROR) {
+		pIocbIn->iocb.ulpStatus = IOSTAT_LOCAL_REJECT;
+
+		if (bf_get(lpfc_wcqe_c_bg_edir, wcqe))
+			pIocbIn->iocb.un.ulpWord[4] = IOERR_RX_DMA_FAILED;
+		else
+			pIocbIn->iocb.un.ulpWord[4] = IOERR_TX_DMA_FAILED;
+
+		pIocbIn->iocb.unsli3.sli3_bg.bgstat = 0;
+		if (bf_get(lpfc_wcqe_c_bg_ge, wcqe)) /* Guard Check failed */
+			pIocbIn->iocb.unsli3.sli3_bg.bgstat |=
+				BGS_GUARD_ERR_MASK;
+		if (bf_get(lpfc_wcqe_c_bg_ae, wcqe)) /* App Tag Check failed */
+			pIocbIn->iocb.unsli3.sli3_bg.bgstat |=
+				BGS_APPTAG_ERR_MASK;
+		if (bf_get(lpfc_wcqe_c_bg_re, wcqe)) /* Ref Tag Check failed */
+			pIocbIn->iocb.unsli3.sli3_bg.bgstat |=
+				BGS_REFTAG_ERR_MASK;
+
+		/* Check to see if there was any good data before the error */
+		if (bf_get(lpfc_wcqe_c_bg_tdpv, wcqe)) {
+			pIocbIn->iocb.unsli3.sli3_bg.bgstat |=
+				BGS_HI_WATER_MARK_PRESENT_MASK;
+			pIocbIn->iocb.unsli3.sli3_bg.bghm =
+				wcqe->total_data_placed;
+		}
+
+		/*
+		* Set ALL the error bits to indicate we don't know what
+		* type of error it is.
+		*/
+		if (!pIocbIn->iocb.unsli3.sli3_bg.bgstat)
+			pIocbIn->iocb.unsli3.sli3_bg.bgstat |=
+				(BGS_REFTAG_ERR_MASK | BGS_APPTAG_ERR_MASK |
+				BGS_GUARD_ERR_MASK);
+	}
+
+	/* Pick up HBA exchange busy condition */
+	if (bf_get(lpfc_wcqe_c_xb, wcqe)) {
+		spin_lock_irqsave(&phba->hbalock, iflags);
+		pIocbIn->iocb_flag |= LPFC_EXCHANGE_BUSY;
+		spin_unlock_irqrestore(&phba->hbalock, iflags);
+	}
+}
+
+/**
+ * lpfc_sli4_els_wcqe_to_rspiocbq - Get response iocbq from els wcqe
  * @phba: Pointer to HBA context object.
  * @irspiocbq: Pointer to work-queue completion queue entry.
  *
  * This routine handles an ELS work-queue completion event and construct
- * a pseudo response ELS IOCBQ from the SLI4 ELS WCQE for the common
+ * a pseudo response ELS IODBQ from the SLI4 ELS WCQE for the common
  * discovery engine to handle.
  *
  * Return: Pointer to the receive IOCBQ, NULL otherwise.
  **/
 static struct lpfc_iocbq *
-lpfc_sli4_els_preprocess_rspiocbq(struct lpfc_hba *phba,
-				  struct lpfc_iocbq *irspiocbq)
+lpfc_sli4_els_wcqe_to_rspiocbq(struct lpfc_hba *phba,
+			       struct lpfc_iocbq *irspiocbq)
 {
 	struct lpfc_sli_ring *pring;
 	struct lpfc_iocbq *cmdiocbq;
@@ -14163,13 +14257,11 @@ lpfc_sli4_els_preprocess_rspiocbq(struct lpfc_hba *phba,
 		return NULL;
 
 	wcqe = &irspiocbq->cq_event.cqe.wcqe_cmpl;
-	spin_lock_irqsave(&pring->ring_lock, iflags);
 	pring->stats.iocb_event++;
 	/* Look up the ELS command IOCB and create pseudo response IOCB */
 	cmdiocbq = lpfc_sli_iocbq_lookup_by_tag(phba, pring,
 				bf_get(lpfc_wcqe_c_request_tag, wcqe));
 	if (unlikely(!cmdiocbq)) {
-		spin_unlock_irqrestore(&pring->ring_lock, iflags);
 		lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
 				"0386 ELS complete with no corresponding "
 				"cmdiocb: 0x%x 0x%x 0x%x 0x%x\n",
@@ -14179,18 +14271,13 @@ lpfc_sli4_els_preprocess_rspiocbq(struct lpfc_hba *phba,
 		return NULL;
 	}
 
-	memcpy(&irspiocbq->wqe, &cmdiocbq->wqe, sizeof(union lpfc_wqe128));
-	memcpy(&irspiocbq->wcqe_cmpl, wcqe, sizeof(*wcqe));
-
+	spin_lock_irqsave(&pring->ring_lock, iflags);
 	/* Put the iocb back on the txcmplq */
 	lpfc_sli_ringtxcmpl_put(phba, pring, cmdiocbq);
 	spin_unlock_irqrestore(&pring->ring_lock, iflags);
 
-	if (bf_get(lpfc_wcqe_c_xb, wcqe)) {
-		spin_lock_irqsave(&phba->hbalock, iflags);
-		irspiocbq->cmd_flag |= LPFC_EXCHANGE_BUSY;
-		spin_unlock_irqrestore(&phba->hbalock, iflags);
-	}
+	/* Fake the irspiocbq and copy necessary response information */
+	lpfc_sli4_iocb_param_transfer(phba, irspiocbq, cmdiocbq, wcqe);
 
 	return irspiocbq;
 }
@@ -14991,6 +15078,7 @@ lpfc_sli4_fp_handle_fcp_wcqe(struct lpfc_hba *phba, struct lpfc_queue *cq,
 {
 	struct lpfc_sli_ring *pring = cq->pring;
 	struct lpfc_iocbq *cmdiocbq;
+	struct lpfc_iocbq irspiocbq;
 	unsigned long iflags;
 
 	/* Check for response status */
@@ -15016,9 +15104,9 @@ lpfc_sli4_fp_handle_fcp_wcqe(struct lpfc_hba *phba, struct lpfc_queue *cq,
 	/* Look up the FCP command IOCB and create pseudo response IOCB */
 	spin_lock_irqsave(&pring->ring_lock, iflags);
 	pring->stats.iocb_event++;
+	spin_unlock_irqrestore(&pring->ring_lock, iflags);
 	cmdiocbq = lpfc_sli_iocbq_lookup_by_tag(phba, pring,
 				bf_get(lpfc_wcqe_c_request_tag, wcqe));
-	spin_unlock_irqrestore(&pring->ring_lock, iflags);
 	if (unlikely(!cmdiocbq)) {
 		lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
 				"0374 FCP complete with no corresponding "
@@ -15029,31 +15117,39 @@ lpfc_sli4_fp_handle_fcp_wcqe(struct lpfc_hba *phba, struct lpfc_queue *cq,
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	cmdiocbq->isr_timestamp = cq->isr_timestamp;
 #endif
-	if (bf_get(lpfc_wcqe_c_xb, wcqe)) {
-		spin_lock_irqsave(&phba->hbalock, iflags);
-		cmdiocbq->cmd_flag |= LPFC_EXCHANGE_BUSY;
-		spin_unlock_irqrestore(&phba->hbalock, iflags);
-	}
+	if (cmdiocbq->iocb_cmpl == NULL) {
+		if (cmdiocbq->wqe_cmpl) {
+			/* For FCP the flag is cleared in wqe_cmpl */
+			if (!(cmdiocbq->iocb_flag & LPFC_IO_FCP) &&
+			    cmdiocbq->iocb_flag & LPFC_DRIVER_ABORTED) {
+				spin_lock_irqsave(&phba->hbalock, iflags);
+				cmdiocbq->iocb_flag &= ~LPFC_DRIVER_ABORTED;
+				spin_unlock_irqrestore(&phba->hbalock, iflags);
+			}
 
-	if (cmdiocbq->cmd_cmpl) {
-		/* For FCP the flag is cleared in cmd_cmpl */
-		if (!(cmdiocbq->cmd_flag & LPFC_IO_FCP) &&
-		    cmdiocbq->cmd_flag & LPFC_DRIVER_ABORTED) {
-			spin_lock_irqsave(&phba->hbalock, iflags);
-			cmdiocbq->cmd_flag &= ~LPFC_DRIVER_ABORTED;
-			spin_unlock_irqrestore(&phba->hbalock, iflags);
+			/* Pass the cmd_iocb and the wcqe to the upper layer */
+			(cmdiocbq->wqe_cmpl)(phba, cmdiocbq, wcqe);
+			return;
 		}
-
-		/* Pass the cmd_iocb and the wcqe to the upper layer */
-		memcpy(&cmdiocbq->wcqe_cmpl, wcqe,
-		       sizeof(struct lpfc_wcqe_complete));
-		cmdiocbq->cmd_cmpl(phba, cmdiocbq, cmdiocbq);
-	} else {
 		lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
 				"0375 FCP cmdiocb not callback function "
 				"iotag: (%d)\n",
 				bf_get(lpfc_wcqe_c_request_tag, wcqe));
+		return;
+	}
+
+	/* Only SLI4 non-IO commands stil use IOCB */
+	/* Fake the irspiocb and copy necessary response information */
+	lpfc_sli4_iocb_param_transfer(phba, &irspiocbq, cmdiocbq, wcqe);
+
+	if (cmdiocbq->iocb_flag & LPFC_DRIVER_ABORTED) {
+		spin_lock_irqsave(&phba->hbalock, iflags);
+		cmdiocbq->iocb_flag &= ~LPFC_DRIVER_ABORTED;
+		spin_unlock_irqrestore(&phba->hbalock, iflags);
 	}
+
+	/* Pass the cmd_iocb and the rsp state to the upper layer */
+	(cmdiocbq->iocb_cmpl)(phba, cmdiocbq, &irspiocbq);
 }
 
 /**
@@ -18875,20 +18971,17 @@ lpfc_sli4_seq_abort_rsp(struct lpfc_vport *vport,
 	}
 
 	ctiocb->vport = phba->pport;
-	ctiocb->cmd_cmpl = lpfc_sli4_seq_abort_rsp_cmpl;
+	ctiocb->iocb_cmpl = lpfc_sli4_seq_abort_rsp_cmpl;
 	ctiocb->sli4_lxritag = NO_XRI;
 	ctiocb->sli4_xritag = NO_XRI;
 
-	if (fctl & FC_FC_EX_CTX) {
+	if (fctl & FC_FC_EX_CTX)
 		/* Exchange responder sent the abort so we
 		 * own the oxid.
 		 */
-		ctiocb->abort_bls = LPFC_ABTS_UNSOL_RSP;
 		xri = oxid;
-	} else {
-		ctiocb->abort_bls = LPFC_ABTS_UNSOL_INT;
+	else
 		xri = rxid;
-	}
 	lxri = lpfc_sli4_xri_inrange(phba, xri);
 	if (lxri != NO_XRI)
 		lpfc_set_rrq_active(phba, ndlp, lxri,
@@ -19211,7 +19304,7 @@ lpfc_sli4_send_seq_to_ulp(struct lpfc_vport *vport,
 
 	/* Free iocb created in lpfc_prep_seq */
 	list_for_each_entry_safe(curr_iocb, next_iocb,
-				 &iocbq->list, list) {
+		&iocbq->list, list) {
 		list_del_init(&curr_iocb->list);
 		lpfc_sli_release_iocbq(phba, curr_iocb);
 	}
@@ -19281,8 +19374,8 @@ lpfc_sli4_handle_mds_loopback(struct lpfc_vport *vport,
 
 	iocbq->context2 = pcmd;
 	iocbq->vport = vport;
-	iocbq->cmd_flag &= ~LPFC_FIP_ELS_ID_MASK;
-	iocbq->cmd_flag |= LPFC_USE_FCPWQIDX;
+	iocbq->iocb_flag &= ~LPFC_FIP_ELS_ID_MASK;
+	iocbq->iocb_flag |= LPFC_USE_FCPWQIDX;
 
 	/*
 	 * Setup rest of the iocb as though it were a WQE
@@ -19300,7 +19393,7 @@ lpfc_sli4_handle_mds_loopback(struct lpfc_vport *vport,
 
 	iocbq->iocb.ulpCommand = CMD_SEND_FRAME;
 	iocbq->iocb.ulpLe = 1;
-	iocbq->cmd_cmpl = lpfc_sli4_mds_loopback_cmpl;
+	iocbq->iocb_cmpl = lpfc_sli4_mds_loopback_cmpl;
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, iocbq, 0);
 	if (rc == IOCB_ERROR)
 		goto exit;
@@ -21142,7 +21235,7 @@ lpfc_wqe_bpl2sgl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeq,
 	cmd = bf_get(wqe_cmnd, &wqe->generic.wqe_com);
 	if (cmd == CMD_XMIT_BLS_RSP64_WQE)
 		return sglq->sli4_xritag;
-	numBdes = pwqeq->num_bdes;
+	numBdes = pwqeq->rsvd2;
 	if (numBdes) {
 		/* The addrHigh and addrLow fields within the WQE
 		 * have not been byteswapped yet so there is no
@@ -21243,7 +21336,7 @@ lpfc_sli4_issue_wqe(struct lpfc_hba *phba, struct lpfc_sli4_hdw_queue *qp,
 	uint32_t ret = 0;
 
 	/* NVME_LS and NVME_LS ABTS requests. */
-	if (pwqe->cmd_flag & LPFC_IO_NVME_LS) {
+	if (pwqe->iocb_flag & LPFC_IO_NVME_LS) {
 		pring =  phba->sli4_hba.nvmels_wq->pring;
 		lpfc_qp_spin_lock_irqsave(&pring->ring_lock, iflags,
 					  qp, wq_access);
@@ -21274,7 +21367,7 @@ lpfc_sli4_issue_wqe(struct lpfc_hba *phba, struct lpfc_sli4_hdw_queue *qp,
 	}
 
 	/* NVME_FCREQ and NVME_ABTS requests */
-	if (pwqe->cmd_flag & (LPFC_IO_NVME | LPFC_IO_FCP | LPFC_IO_CMF)) {
+	if (pwqe->iocb_flag & (LPFC_IO_NVME | LPFC_IO_FCP | LPFC_IO_CMF)) {
 		/* Get the IO distribution (hba_wqidx) for WQ assignment. */
 		wq = qp->io_wq;
 		pring = wq->pring;
@@ -21296,7 +21389,7 @@ lpfc_sli4_issue_wqe(struct lpfc_hba *phba, struct lpfc_sli4_hdw_queue *qp,
 	}
 
 	/* NVMET requests */
-	if (pwqe->cmd_flag & LPFC_IO_NVMET) {
+	if (pwqe->iocb_flag & LPFC_IO_NVMET) {
 		/* Get the IO distribution (hba_wqidx) for WQ assignment. */
 		wq = qp->io_wq;
 		pring = wq->pring;
@@ -21362,7 +21455,7 @@ lpfc_sli4_issue_abort_iotag(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		return WQE_NORESOURCE;
 
 	/* Indicate the IO is being aborted by the driver. */
-	cmdiocb->cmd_flag |= LPFC_DRIVER_ABORTED;
+	cmdiocb->iocb_flag |= LPFC_DRIVER_ABORTED;
 
 	abtswqe = &abtsiocb->wqe;
 	memset(abtswqe, 0, sizeof(*abtswqe));
@@ -21381,15 +21474,15 @@ lpfc_sli4_issue_abort_iotag(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 
 	/* ABTS WQE must go to the same WQ as the WQE to be aborted */
 	abtsiocb->hba_wqidx = cmdiocb->hba_wqidx;
-	abtsiocb->cmd_flag |= LPFC_USE_FCPWQIDX;
-	if (cmdiocb->cmd_flag & LPFC_IO_FCP)
-		abtsiocb->cmd_flag |= LPFC_IO_FCP;
-	if (cmdiocb->cmd_flag & LPFC_IO_NVME)
-		abtsiocb->cmd_flag |= LPFC_IO_NVME;
-	if (cmdiocb->cmd_flag & LPFC_IO_FOF)
-		abtsiocb->cmd_flag |= LPFC_IO_FOF;
+	abtsiocb->iocb_flag |= LPFC_USE_FCPWQIDX;
+	if (cmdiocb->iocb_flag & LPFC_IO_FCP)
+		abtsiocb->iocb_flag |= LPFC_IO_FCP;
+	if (cmdiocb->iocb_flag & LPFC_IO_NVME)
+		abtsiocb->iocb_flag |= LPFC_IO_NVME;
+	if (cmdiocb->iocb_flag & LPFC_IO_FOF)
+		abtsiocb->iocb_flag |= LPFC_IO_FOF;
 	abtsiocb->vport = vport;
-	abtsiocb->cmd_cmpl = cmpl;
+	abtsiocb->wqe_cmpl = cmpl;
 
 	lpfc_cmd = container_of(cmdiocb, struct lpfc_io_buf, cur_iocbq);
 	retval = lpfc_sli4_issue_wqe(phba, lpfc_cmd->hdwq, abtsiocb);
@@ -21400,7 +21493,7 @@ lpfc_sli4_issue_abort_iotag(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			 xritag, cmdiocb->iotag, abtsiocb->iotag, retval);
 
 	if (retval) {
-		cmdiocb->cmd_flag &= ~LPFC_DRIVER_ABORTED;
+		cmdiocb->iocb_flag &= ~LPFC_DRIVER_ABORTED;
 		__lpfc_sli_release_iocbq(phba, abtsiocb);
 	}
 
@@ -21762,7 +21855,8 @@ void lpfc_release_io_buf(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_ncmd,
 
 	/* MUST zero fields if buffer is reused by another protocol */
 	lpfc_ncmd->nvmeCmd = NULL;
-	lpfc_ncmd->cur_iocbq.cmd_cmpl = NULL;
+	lpfc_ncmd->cur_iocbq.wqe_cmpl = NULL;
+	lpfc_ncmd->cur_iocbq.iocb_cmpl = NULL;
 
 	if (phba->cfg_xpsgl && !phba->nvmet_support &&
 	    !list_empty(&lpfc_ncmd->dma_sgl_xtra_list))
diff --git a/drivers/scsi/lpfc/lpfc_sli.h b/drivers/scsi/lpfc/lpfc_sli.h
index 06682ad8bbe1..5161ccacea3e 100644
--- a/drivers/scsi/lpfc/lpfc_sli.h
+++ b/drivers/scsi/lpfc/lpfc_sli.h
@@ -35,7 +35,7 @@ typedef enum _lpfc_ctx_cmd {
 	LPFC_CTX_HOST
 } lpfc_ctx_cmd;
 
-union lpfc_vmid_tag {
+union lpfc_vmid_iocb_tag {
 	uint32_t app_id;
 	uint8_t cs_ctl_vmid;
 	struct lpfc_vmid_context *vmid_context;	/* UVEM context information */
@@ -69,18 +69,16 @@ struct lpfc_iocbq {
 	uint16_t sli4_xritag;   /* pre-assigned XRI, (OXID) tag. */
 	uint16_t hba_wqidx;     /* index to HBA work queue */
 	struct lpfc_cq_event cq_event;
+	struct lpfc_wcqe_complete wcqe_cmpl;	/* WQE cmpl */
 	uint64_t isr_timestamp;
 
 	union lpfc_wqe128 wqe;	/* SLI-4 */
 	IOCB_t iocb;		/* SLI-3 */
-	struct lpfc_wcqe_complete wcqe_cmpl;	/* WQE cmpl */
-
-	uint8_t num_bdes;
-	uint8_t abort_bls;	/* ABTS by initiator or responder */
 
+	uint8_t rsvd2;
 	uint8_t priority;	/* OAS priority */
 	uint8_t retry;		/* retry counter for IOCB cmd - if needed */
-	u32 cmd_flag;
+	uint32_t iocb_flag;
 #define LPFC_IO_LIBDFC		1	/* libdfc iocb */
 #define LPFC_IO_WAKE		2	/* Synchronous I/O completed */
 #define LPFC_IO_WAKE_TMO	LPFC_IO_WAKE /* Synchronous I/O timed out */
@@ -125,13 +123,15 @@ struct lpfc_iocbq {
 		struct lpfc_node_rrq *rrq;
 	} context_un;
 
-	union lpfc_vmid_tag vmid_tag;
-	void (*fabric_cmd_cmpl)(struct lpfc_hba *phba, struct lpfc_iocbq *cmd,
-				struct lpfc_iocbq *rsp);
-	void (*wait_cmd_cmpl)(struct lpfc_hba *phba, struct lpfc_iocbq *cmd,
-			      struct lpfc_iocbq *rsp);
-	void (*cmd_cmpl)(struct lpfc_hba *phba, struct lpfc_iocbq *cmd,
-			 struct lpfc_iocbq *rsp);
+	union lpfc_vmid_iocb_tag vmid_tag;
+	void (*fabric_iocb_cmpl)(struct lpfc_hba *, struct lpfc_iocbq *,
+			   struct lpfc_iocbq *);
+	void (*wait_iocb_cmpl)(struct lpfc_hba *, struct lpfc_iocbq *,
+			   struct lpfc_iocbq *);
+	void (*iocb_cmpl)(struct lpfc_hba *, struct lpfc_iocbq *,
+			   struct lpfc_iocbq *);
+	void (*wqe_cmpl)(struct lpfc_hba *, struct lpfc_iocbq *,
+			  struct lpfc_wcqe_complete *);
 };
 
 #define SLI_IOCB_RET_IOCB      1	/* Return IOCB if cmd ring full */
diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index a302ed8b610f..b6a427f0570e 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -3318,11 +3318,34 @@ struct fc_function_template qla2xxx_transport_vport_functions = {
 	.bsg_timeout = qla24xx_bsg_timeout,
 };
 
+static uint
+qla2x00_get_host_supported_speeds(scsi_qla_host_t *vha, uint speeds)
+{
+	uint supported_speeds = FC_PORTSPEED_UNKNOWN;
+
+	if (speeds & FDMI_PORT_SPEED_64GB)
+		supported_speeds |= FC_PORTSPEED_64GBIT;
+	if (speeds & FDMI_PORT_SPEED_32GB)
+		supported_speeds |= FC_PORTSPEED_32GBIT;
+	if (speeds & FDMI_PORT_SPEED_16GB)
+		supported_speeds |= FC_PORTSPEED_16GBIT;
+	if (speeds & FDMI_PORT_SPEED_8GB)
+		supported_speeds |= FC_PORTSPEED_8GBIT;
+	if (speeds & FDMI_PORT_SPEED_4GB)
+		supported_speeds |= FC_PORTSPEED_4GBIT;
+	if (speeds & FDMI_PORT_SPEED_2GB)
+		supported_speeds |= FC_PORTSPEED_2GBIT;
+	if (speeds & FDMI_PORT_SPEED_1GB)
+		supported_speeds |= FC_PORTSPEED_1GBIT;
+
+	return supported_speeds;
+}
+
 void
 qla2x00_init_host_attr(scsi_qla_host_t *vha)
 {
 	struct qla_hw_data *ha = vha->hw;
-	u32 speeds = FC_PORTSPEED_UNKNOWN;
+	u32 speeds = 0, fdmi_speed = 0;
 
 	fc_host_dev_loss_tmo(vha->host) = ha->port_down_retry_count;
 	fc_host_node_name(vha->host) = wwn_to_u64(vha->node_name);
@@ -3332,7 +3355,8 @@ qla2x00_init_host_attr(scsi_qla_host_t *vha)
 	fc_host_max_npiv_vports(vha->host) = ha->max_npiv_vports;
 	fc_host_npiv_vports_inuse(vha->host) = ha->cur_vport_count;
 
-	speeds = qla25xx_fdmi_port_speed_capability(ha);
+	fdmi_speed = qla25xx_fdmi_port_speed_capability(ha);
+	speeds = qla2x00_get_host_supported_speeds(vha, fdmi_speed);
 
 	fc_host_supported_speeds(vha->host) = speeds;
 }
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index de6640ad1943..1e887c11e83d 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1072,6 +1072,7 @@ static blk_status_t sd_setup_write_same_cmnd(struct scsi_cmnd *cmd)
 	struct bio *bio = rq->bio;
 	u64 lba = sectors_to_logical(sdp, blk_rq_pos(rq));
 	u32 nr_blocks = sectors_to_logical(sdp, blk_rq_sectors(rq));
+	unsigned int nr_bytes = blk_rq_bytes(rq);
 	blk_status_t ret;
 
 	if (sdkp->device->no_write_same)
@@ -1108,7 +1109,7 @@ static blk_status_t sd_setup_write_same_cmnd(struct scsi_cmnd *cmd)
 	 */
 	rq->__data_len = sdp->sector_size;
 	ret = scsi_alloc_sgtables(cmd);
-	rq->__data_len = blk_rq_bytes(rq);
+	rq->__data_len = nr_bytes;
 
 	return ret;
 }
diff --git a/drivers/staging/media/atomisp/pci/sh_css_params.c b/drivers/staging/media/atomisp/pci/sh_css_params.c
index ccc007879564..deecffd438ae 100644
--- a/drivers/staging/media/atomisp/pci/sh_css_params.c
+++ b/drivers/staging/media/atomisp/pci/sh_css_params.c
@@ -962,8 +962,8 @@ sh_css_set_black_frame(struct ia_css_stream *stream,
 		params->fpn_config.data = NULL;
 	}
 	if (!params->fpn_config.data) {
-		params->fpn_config.data = kvmalloc(height * width *
-						   sizeof(short), GFP_KERNEL);
+		params->fpn_config.data = kvmalloc(array3_size(height, width, sizeof(short)),
+						   GFP_KERNEL);
 		if (!params->fpn_config.data) {
 			IA_CSS_ERROR("out of memory");
 			IA_CSS_LEAVE_ERR_PRIVATE(-ENOMEM);
diff --git a/drivers/tty/serial/8250/8250_omap.c b/drivers/tty/serial/8250/8250_omap.c
index 73e5f1dbd075..806f7806d3ca 100644
--- a/drivers/tty/serial/8250/8250_omap.c
+++ b/drivers/tty/serial/8250/8250_omap.c
@@ -342,6 +342,9 @@ static void omap8250_restore_regs(struct uart_8250_port *up)
 	omap8250_update_mdr1(up, priv);
 
 	up->port.ops->set_mctrl(&up->port, up->port.mctrl);
+
+	if (up->port.rs485.flags & SER_RS485_ENABLED)
+		serial8250_em485_stop_tx(up);
 }
 
 /*
diff --git a/drivers/tty/serial/8250/8250_pci.c b/drivers/tty/serial/8250/8250_pci.c
index 1d37ff0ec85a..8f0dafbab3bf 100644
--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -1739,7 +1739,6 @@ static int pci_fintek_init(struct pci_dev *dev)
 	resource_size_t bar_data[3];
 	u8 config_base;
 	struct serial_private *priv = pci_get_drvdata(dev);
-	struct uart_8250_port *port;
 
 	if (!(pci_resource_flags(dev, 5) & IORESOURCE_IO) ||
 			!(pci_resource_flags(dev, 4) & IORESOURCE_IO) ||
@@ -1786,13 +1785,7 @@ static int pci_fintek_init(struct pci_dev *dev)
 
 		pci_write_config_byte(dev, config_base + 0x06, dev->irq);
 
-		if (priv) {
-			/* re-apply RS232/485 mode when
-			 * pciserial_resume_ports()
-			 */
-			port = serial8250_get_port(priv->line[i]);
-			pci_fintek_rs485_config(&port->port, NULL);
-		} else {
+		if (!priv) {
 			/* First init without port data
 			 * force init to RS232 Mode
 			 */
diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/8250/8250_port.c
index ec7846223f3a..edb975097c89 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -600,7 +600,7 @@ EXPORT_SYMBOL_GPL(serial8250_rpm_put);
 static int serial8250_em485_init(struct uart_8250_port *p)
 {
 	if (p->em485)
-		return 0;
+		goto deassert_rts;
 
 	p->em485 = kmalloc(sizeof(struct uart_8250_em485), GFP_ATOMIC);
 	if (!p->em485)
@@ -616,7 +616,9 @@ static int serial8250_em485_init(struct uart_8250_port *p)
 	p->em485->active_timer = NULL;
 	p->em485->tx_stopped = true;
 
-	p->rs485_stop_tx(p);
+deassert_rts:
+	if (p->em485->tx_stopped)
+		p->rs485_stop_tx(p);
 
 	return 0;
 }
@@ -2034,6 +2036,9 @@ EXPORT_SYMBOL_GPL(serial8250_do_set_mctrl);
 
 static void serial8250_set_mctrl(struct uart_port *port, unsigned int mctrl)
 {
+	if (port->rs485.flags & SER_RS485_ENABLED)
+		return;
+
 	if (port->set_mctrl)
 		port->set_mctrl(port, mctrl);
 	else
@@ -3191,9 +3196,6 @@ static void serial8250_config_port(struct uart_port *port, int flags)
 	if (flags & UART_CONFIG_TYPE)
 		autoconfig(up);
 
-	if (port->rs485.flags & SER_RS485_ENABLED)
-		port->rs485_config(port, &port->rs485);
-
 	/* if access method is AU, it is a 16550 with a quirk */
 	if (port->type == PORT_16550A && port->iotype == UPIO_AU)
 		up->bugs |= UART_BUG_NOMSR;
diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index 185dd417fc49..44ed4285e1ef 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -2733,10 +2733,6 @@ static int lpuart_probe(struct platform_device *pdev)
 	if (ret)
 		goto failed_reset;
 
-	ret = uart_add_one_port(&lpuart_reg, &sport->port);
-	if (ret)
-		goto failed_attach_port;
-
 	ret = uart_get_rs485_mode(&sport->port);
 	if (ret)
 		goto failed_get_rs485;
@@ -2748,7 +2744,9 @@ static int lpuart_probe(struct platform_device *pdev)
 	    sport->port.rs485.delay_rts_after_send)
 		dev_err(&pdev->dev, "driver doesn't support RTS delays\n");
 
-	sport->port.rs485_config(&sport->port, &sport->port.rs485);
+	ret = uart_add_one_port(&lpuart_reg, &sport->port);
+	if (ret)
+		goto failed_attach_port;
 
 	ret = devm_request_irq(&pdev->dev, sport->port.irq, handler, 0,
 				DRIVER_NAME, sport);
diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index b7ef075a4005..c6a93d6a9464 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -380,8 +380,7 @@ static void imx_uart_rts_active(struct imx_port *sport, u32 *ucr2)
 {
 	*ucr2 &= ~(UCR2_CTSC | UCR2_CTS);
 
-	sport->port.mctrl |= TIOCM_RTS;
-	mctrl_gpio_set(sport->gpios, sport->port.mctrl);
+	mctrl_gpio_set(sport->gpios, sport->port.mctrl | TIOCM_RTS);
 }
 
 /* called with port.lock taken and irqs caller dependent */
@@ -390,8 +389,7 @@ static void imx_uart_rts_inactive(struct imx_port *sport, u32 *ucr2)
 	*ucr2 &= ~UCR2_CTSC;
 	*ucr2 |= UCR2_CTS;
 
-	sport->port.mctrl &= ~TIOCM_RTS;
-	mctrl_gpio_set(sport->gpios, sport->port.mctrl);
+	mctrl_gpio_set(sport->gpios, sport->port.mctrl & ~TIOCM_RTS);
 }
 
 static void start_hrtimer_ms(struct hrtimer *hrt, unsigned long msec)
@@ -2318,8 +2316,6 @@ static int imx_uart_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev,
 			"low-active RTS not possible when receiver is off, enabling receiver\n");
 
-	imx_uart_rs485_config(&sport->port, &sport->port.rs485);
-
 	/* Disable interrupts before requesting them */
 	ucr1 = imx_uart_readl(sport, UCR1);
 	ucr1 &= ~(UCR1_ADEN | UCR1_TRDYEN | UCR1_IDEN | UCR1_RRDYEN | UCR1_RTSDEN);
diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 82ddbb92d07d..5f8f0a90ce55 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -42,6 +42,11 @@ static struct lock_class_key port_lock_key;
 
 #define HIGH_BITS_OFFSET	((sizeof(long)-sizeof(int))*8)
 
+/*
+ * Max time with active RTS before/after data is sent.
+ */
+#define RS485_MAX_RTS_DELAY	100 /* msecs */
+
 static void uart_change_speed(struct tty_struct *tty, struct uart_state *state,
 					struct ktermios *old_termios);
 static void uart_wait_until_sent(struct tty_struct *tty, int timeout);
@@ -144,15 +149,10 @@ uart_update_mctrl(struct uart_port *port, unsigned int set, unsigned int clear)
 	unsigned long flags;
 	unsigned int old;
 
-	if (port->rs485.flags & SER_RS485_ENABLED) {
-		set &= ~TIOCM_RTS;
-		clear &= ~TIOCM_RTS;
-	}
-
 	spin_lock_irqsave(&port->lock, flags);
 	old = port->mctrl;
 	port->mctrl = (old & ~clear) | set;
-	if (old != port->mctrl)
+	if (old != port->mctrl && !(port->rs485.flags & SER_RS485_ENABLED))
 		port->ops->set_mctrl(port, port->mctrl);
 	spin_unlock_irqrestore(&port->lock, flags);
 }
@@ -1299,8 +1299,41 @@ static int uart_set_rs485_config(struct uart_port *port,
 	if (copy_from_user(&rs485, rs485_user, sizeof(*rs485_user)))
 		return -EFAULT;
 
+	/* pick sane settings if the user hasn't */
+	if (!(rs485.flags & SER_RS485_RTS_ON_SEND) ==
+	    !(rs485.flags & SER_RS485_RTS_AFTER_SEND)) {
+		dev_warn_ratelimited(port->dev,
+			"%s (%d): invalid RTS setting, using RTS_ON_SEND instead\n",
+			port->name, port->line);
+		rs485.flags |= SER_RS485_RTS_ON_SEND;
+		rs485.flags &= ~SER_RS485_RTS_AFTER_SEND;
+	}
+
+	if (rs485.delay_rts_before_send > RS485_MAX_RTS_DELAY) {
+		rs485.delay_rts_before_send = RS485_MAX_RTS_DELAY;
+		dev_warn_ratelimited(port->dev,
+			"%s (%d): RTS delay before sending clamped to %u ms\n",
+			port->name, port->line, rs485.delay_rts_before_send);
+	}
+
+	if (rs485.delay_rts_after_send > RS485_MAX_RTS_DELAY) {
+		rs485.delay_rts_after_send = RS485_MAX_RTS_DELAY;
+		dev_warn_ratelimited(port->dev,
+			"%s (%d): RTS delay after sending clamped to %u ms\n",
+			port->name, port->line, rs485.delay_rts_after_send);
+	}
+	/* Return clean padding area to userspace */
+	memset(rs485.padding, 0, sizeof(rs485.padding));
+
 	spin_lock_irqsave(&port->lock, flags);
 	ret = port->rs485_config(port, &rs485);
+	if (!ret) {
+		port->rs485 = rs485;
+
+		/* Reset RTS and other mctrl lines when disabling RS485 */
+		if (!(rs485.flags & SER_RS485_ENABLED))
+			port->ops->set_mctrl(port, port->mctrl);
+	}
 	spin_unlock_irqrestore(&port->lock, flags);
 	if (ret)
 		return ret;
@@ -2273,7 +2306,8 @@ int uart_resume_port(struct uart_driver *drv, struct uart_port *uport)
 
 		uart_change_pm(state, UART_PM_STATE_ON);
 		spin_lock_irq(&uport->lock);
-		ops->set_mctrl(uport, 0);
+		if (!(uport->rs485.flags & SER_RS485_ENABLED))
+			ops->set_mctrl(uport, 0);
 		spin_unlock_irq(&uport->lock);
 		if (console_suspend_enabled || !uart_console(uport)) {
 			/* Protected by port mutex for now */
@@ -2284,7 +2318,10 @@ int uart_resume_port(struct uart_driver *drv, struct uart_port *uport)
 				if (tty)
 					uart_change_speed(tty, state, NULL);
 				spin_lock_irq(&uport->lock);
-				ops->set_mctrl(uport, uport->mctrl);
+				if (!(uport->rs485.flags & SER_RS485_ENABLED))
+					ops->set_mctrl(uport, uport->mctrl);
+				else
+					uport->rs485_config(uport, &uport->rs485);
 				ops->start_tx(uport);
 				spin_unlock_irq(&uport->lock);
 				tty_port_set_initialized(port, 1);
@@ -2390,10 +2427,10 @@ uart_configure_port(struct uart_driver *drv, struct uart_state *state,
 		 */
 		spin_lock_irqsave(&port->lock, flags);
 		port->mctrl &= TIOCM_DTR;
-		if (port->rs485.flags & SER_RS485_ENABLED &&
-		    !(port->rs485.flags & SER_RS485_RTS_AFTER_SEND))
-			port->mctrl |= TIOCM_RTS;
-		port->ops->set_mctrl(port, port->mctrl);
+		if (!(port->rs485.flags & SER_RS485_ENABLED))
+			port->ops->set_mctrl(port, port->mctrl);
+		else
+			port->rs485_config(port, &port->rs485);
 		spin_unlock_irqrestore(&port->lock, flags);
 
 		/*
diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index 999b7c9697fc..0722d2131305 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -388,6 +388,15 @@ static const struct usb_device_id usb_quirk_list[] = {
 	/* Kingston DataTraveler 3.0 */
 	{ USB_DEVICE(0x0951, 0x1666), .driver_info = USB_QUIRK_NO_LPM },
 
+	/* NVIDIA Jetson devices in Force Recovery mode */
+	{ USB_DEVICE(0x0955, 0x7018), .driver_info = USB_QUIRK_RESET_RESUME },
+	{ USB_DEVICE(0x0955, 0x7019), .driver_info = USB_QUIRK_RESET_RESUME },
+	{ USB_DEVICE(0x0955, 0x7418), .driver_info = USB_QUIRK_RESET_RESUME },
+	{ USB_DEVICE(0x0955, 0x7721), .driver_info = USB_QUIRK_RESET_RESUME },
+	{ USB_DEVICE(0x0955, 0x7c18), .driver_info = USB_QUIRK_RESET_RESUME },
+	{ USB_DEVICE(0x0955, 0x7e19), .driver_info = USB_QUIRK_RESET_RESUME },
+	{ USB_DEVICE(0x0955, 0x7f21), .driver_info = USB_QUIRK_RESET_RESUME },
+
 	/* X-Rite/Gretag-Macbeth Eye-One Pro display colorimeter */
 	{ USB_DEVICE(0x0971, 0x2000), .driver_info = USB_QUIRK_NO_SET_INTF },
 
diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 14dcdb923f40..c38418b4df90 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1263,8 +1263,8 @@ static void dwc3_prepare_one_trb(struct dwc3_ep *dep,
 			trb->ctrl = DWC3_TRBCTL_ISOCHRONOUS;
 		}
 
-		/* always enable Interrupt on Missed ISOC */
-		trb->ctrl |= DWC3_TRB_CTRL_ISP_IMI;
+		if (!no_interrupt && !chain)
+			trb->ctrl |= DWC3_TRB_CTRL_ISP_IMI;
 		break;
 
 	case USB_ENDPOINT_XFER_BULK:
@@ -3146,6 +3146,10 @@ static int dwc3_gadget_ep_reclaim_completed_trb(struct dwc3_ep *dep,
 	if (event->status & DEPEVT_STATUS_SHORT && !chain)
 		return 1;
 
+	if ((trb->ctrl & DWC3_TRB_CTRL_ISP_IMI) &&
+	    DWC3_TRB_SIZE_TRBSTS(trb->size) == DWC3_TRBSTS_MISSED_ISOC)
+		return 1;
+
 	if ((trb->ctrl & DWC3_TRB_CTRL_IOC) ||
 	    (trb->ctrl & DWC3_TRB_CTRL_LST))
 		return 1;
diff --git a/drivers/usb/gadget/function/uvc_queue.c b/drivers/usb/gadget/function/uvc_queue.c
index ec299f5cc65a..0cc8422afe4e 100644
--- a/drivers/usb/gadget/function/uvc_queue.c
+++ b/drivers/usb/gadget/function/uvc_queue.c
@@ -313,6 +313,7 @@ int uvcg_queue_enable(struct uvc_video_queue *queue, int enable)
 
 		queue->sequence = 0;
 		queue->buf_used = 0;
+		queue->flags &= ~UVC_QUEUE_DROP_INCOMPLETE;
 	} else {
 		ret = vb2_streamoff(&queue->queue, queue->queue.type);
 		if (ret < 0)
@@ -338,10 +339,11 @@ int uvcg_queue_enable(struct uvc_video_queue *queue, int enable)
 void uvcg_complete_buffer(struct uvc_video_queue *queue,
 					  struct uvc_buffer *buf)
 {
-	if ((queue->flags & UVC_QUEUE_DROP_INCOMPLETE) &&
-	     buf->length != buf->bytesused) {
-		buf->state = UVC_BUF_STATE_QUEUED;
+	if (queue->flags & UVC_QUEUE_DROP_INCOMPLETE) {
+		queue->flags &= ~UVC_QUEUE_DROP_INCOMPLETE;
+		buf->state = UVC_BUF_STATE_ERROR;
 		vb2_set_plane_payload(&buf->buf.vb2_buf, 0, 0);
+		vb2_buffer_done(&buf->buf.vb2_buf, VB2_BUF_STATE_ERROR);
 		return;
 	}
 
diff --git a/drivers/usb/gadget/function/uvc_video.c b/drivers/usb/gadget/function/uvc_video.c
index 1889d75f8788..0de7f11d1425 100644
--- a/drivers/usb/gadget/function/uvc_video.c
+++ b/drivers/usb/gadget/function/uvc_video.c
@@ -59,6 +59,7 @@ uvc_video_encode_bulk(struct usb_request *req, struct uvc_video *video,
 		struct uvc_buffer *buf)
 {
 	void *mem = req->buf;
+	struct uvc_request *ureq = req->context;
 	int len = video->req_size;
 	int ret;
 
@@ -84,13 +85,14 @@ uvc_video_encode_bulk(struct usb_request *req, struct uvc_video *video,
 		video->queue.buf_used = 0;
 		buf->state = UVC_BUF_STATE_DONE;
 		list_del(&buf->queue);
-		uvcg_complete_buffer(&video->queue, buf);
 		video->fid ^= UVC_STREAM_FID;
+		ureq->last_buf = buf;
 
 		video->payload_size = 0;
 	}
 
 	if (video->payload_size == video->max_payload_size ||
+	    video->queue.flags & UVC_QUEUE_DROP_INCOMPLETE ||
 	    buf->bytesused == video->queue.buf_used)
 		video->payload_size = 0;
 }
@@ -126,10 +128,10 @@ uvc_video_encode_isoc_sg(struct usb_request *req, struct uvc_video *video,
 	sg = sg_next(sg);
 
 	for_each_sg(sg, iter, ureq->sgt.nents - 1, i) {
-		if (!len || !buf->sg || !sg_dma_len(buf->sg))
+		if (!len || !buf->sg || !buf->sg->length)
 			break;
 
-		sg_left = sg_dma_len(buf->sg) - buf->offset;
+		sg_left = buf->sg->length - buf->offset;
 		part = min_t(unsigned int, len, sg_left);
 
 		sg_set_page(iter, sg_page(buf->sg), part, buf->offset);
@@ -151,7 +153,8 @@ uvc_video_encode_isoc_sg(struct usb_request *req, struct uvc_video *video,
 	req->length -= len;
 	video->queue.buf_used += req->length - header_len;
 
-	if (buf->bytesused == video->queue.buf_used || !buf->sg) {
+	if (buf->bytesused == video->queue.buf_used || !buf->sg ||
+			video->queue.flags & UVC_QUEUE_DROP_INCOMPLETE) {
 		video->queue.buf_used = 0;
 		buf->state = UVC_BUF_STATE_DONE;
 		buf->offset = 0;
@@ -166,6 +169,7 @@ uvc_video_encode_isoc(struct usb_request *req, struct uvc_video *video,
 		struct uvc_buffer *buf)
 {
 	void *mem = req->buf;
+	struct uvc_request *ureq = req->context;
 	int len = video->req_size;
 	int ret;
 
@@ -180,12 +184,13 @@ uvc_video_encode_isoc(struct usb_request *req, struct uvc_video *video,
 
 	req->length = video->req_size - len;
 
-	if (buf->bytesused == video->queue.buf_used) {
+	if (buf->bytesused == video->queue.buf_used ||
+			video->queue.flags & UVC_QUEUE_DROP_INCOMPLETE) {
 		video->queue.buf_used = 0;
 		buf->state = UVC_BUF_STATE_DONE;
 		list_del(&buf->queue);
-		uvcg_complete_buffer(&video->queue, buf);
 		video->fid ^= UVC_STREAM_FID;
+		ureq->last_buf = buf;
 	}
 }
 
@@ -222,6 +227,11 @@ uvc_video_complete(struct usb_ep *ep, struct usb_request *req)
 	case 0:
 		break;
 
+	case -EXDEV:
+		uvcg_dbg(&video->uvc->func, "VS request missed xfer.\n");
+		queue->flags |= UVC_QUEUE_DROP_INCOMPLETE;
+		break;
+
 	case -ESHUTDOWN:	/* disconnect from host. */
 		uvcg_dbg(&video->uvc->func, "VS request cancelled.\n");
 		uvcg_queue_cancel(queue, 1);
diff --git a/drivers/usb/gadget/udc/bdc/bdc_udc.c b/drivers/usb/gadget/udc/bdc/bdc_udc.c
index 5ac0ef88334e..53ffaf4e2e37 100644
--- a/drivers/usb/gadget/udc/bdc/bdc_udc.c
+++ b/drivers/usb/gadget/udc/bdc/bdc_udc.c
@@ -151,6 +151,7 @@ static void bdc_uspc_disconnected(struct bdc *bdc, bool reinit)
 	bdc->delayed_status = false;
 	bdc->reinit = reinit;
 	bdc->test_mode = false;
+	usb_gadget_set_state(&bdc->gadget, USB_STATE_NOTATTACHED);
 }
 
 /* TNotify wkaeup timer */
diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index 02cd4d7c3e7e..9d9ab7e3560a 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -898,15 +898,19 @@ void xhci_free_virt_device(struct xhci_hcd *xhci, int slot_id)
 		if (dev->eps[i].stream_info)
 			xhci_free_stream_info(xhci,
 					dev->eps[i].stream_info);
-		/* Endpoints on the TT/root port lists should have been removed
-		 * when usb_disable_device() was called for the device.
-		 * We can't drop them anyway, because the udev might have gone
-		 * away by this point, and we can't tell what speed it was.
+		/*
+		 * Endpoints are normally deleted from the bandwidth list when
+		 * endpoints are dropped, before device is freed.
+		 * If host is dying or being removed then endpoints aren't
+		 * dropped cleanly, so delete the endpoint from list here.
+		 * Only applicable for hosts with software bandwidth checking.
 		 */
-		if (!list_empty(&dev->eps[i].bw_endpoint_list))
-			xhci_warn(xhci, "Slot %u endpoint %u "
-					"not removed from BW list!\n",
-					slot_id, i);
+
+		if (!list_empty(&dev->eps[i].bw_endpoint_list)) {
+			list_del_init(&dev->eps[i].bw_endpoint_list);
+			xhci_dbg(xhci, "Slot %u endpoint %u not removed from BW list!\n",
+				 slot_id, i);
+		}
 	}
 	/* If this is a hub, free the TT(s) from the TT list */
 	xhci_free_tt_info(xhci, dev, slot_id);
diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 352626f9e451..fdf083196528 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -58,25 +58,13 @@
 #define PCI_DEVICE_ID_INTEL_CML_XHCI			0xa3af
 #define PCI_DEVICE_ID_INTEL_TIGER_LAKE_XHCI		0x9a13
 #define PCI_DEVICE_ID_INTEL_MAPLE_RIDGE_XHCI		0x1138
-#define PCI_DEVICE_ID_INTEL_ALDER_LAKE_XHCI		0x461e
-#define PCI_DEVICE_ID_INTEL_ALDER_LAKE_N_XHCI		0x464e
-#define PCI_DEVICE_ID_INTEL_ALDER_LAKE_PCH_XHCI	0x51ed
-#define PCI_DEVICE_ID_INTEL_RAPTOR_LAKE_XHCI		0xa71e
-#define PCI_DEVICE_ID_INTEL_METEOR_LAKE_XHCI		0x7ec0
+#define PCI_DEVICE_ID_INTEL_ALDER_LAKE_PCH_XHCI		0x51ed
 
 #define PCI_DEVICE_ID_AMD_RENOIR_XHCI			0x1639
 #define PCI_DEVICE_ID_AMD_PROMONTORYA_4			0x43b9
 #define PCI_DEVICE_ID_AMD_PROMONTORYA_3			0x43ba
 #define PCI_DEVICE_ID_AMD_PROMONTORYA_2			0x43bb
 #define PCI_DEVICE_ID_AMD_PROMONTORYA_1			0x43bc
-#define PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_1		0x161a
-#define PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_2		0x161b
-#define PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_3		0x161d
-#define PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_4		0x161e
-#define PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_5		0x15d6
-#define PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_6		0x15d7
-#define PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_7		0x161c
-#define PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_8		0x161f
 
 #define PCI_DEVICE_ID_ASMEDIA_1042_XHCI			0x1042
 #define PCI_DEVICE_ID_ASMEDIA_1042A_XHCI		0x1142
@@ -258,6 +246,10 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 	     pdev->device == PCI_DEVICE_ID_INTEL_DNV_XHCI))
 		xhci->quirks |= XHCI_MISSING_CAS;
 
+	if (pdev->vendor == PCI_VENDOR_ID_INTEL &&
+	    pdev->device == PCI_DEVICE_ID_INTEL_ALDER_LAKE_PCH_XHCI)
+		xhci->quirks |= XHCI_RESET_TO_DEFAULT;
+
 	if (pdev->vendor == PCI_VENDOR_ID_INTEL &&
 	    (pdev->device == PCI_DEVICE_ID_INTEL_ALPINE_RIDGE_2C_XHCI ||
 	     pdev->device == PCI_DEVICE_ID_INTEL_ALPINE_RIDGE_4C_XHCI ||
@@ -269,12 +261,7 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 	     pdev->device == PCI_DEVICE_ID_INTEL_TITAN_RIDGE_DD_XHCI ||
 	     pdev->device == PCI_DEVICE_ID_INTEL_ICE_LAKE_XHCI ||
 	     pdev->device == PCI_DEVICE_ID_INTEL_TIGER_LAKE_XHCI ||
-	     pdev->device == PCI_DEVICE_ID_INTEL_MAPLE_RIDGE_XHCI ||
-	     pdev->device == PCI_DEVICE_ID_INTEL_ALDER_LAKE_XHCI ||
-	     pdev->device == PCI_DEVICE_ID_INTEL_ALDER_LAKE_N_XHCI ||
-	     pdev->device == PCI_DEVICE_ID_INTEL_ALDER_LAKE_PCH_XHCI ||
-	     pdev->device == PCI_DEVICE_ID_INTEL_RAPTOR_LAKE_XHCI ||
-	     pdev->device == PCI_DEVICE_ID_INTEL_METEOR_LAKE_XHCI))
+	     pdev->device == PCI_DEVICE_ID_INTEL_MAPLE_RIDGE_XHCI))
 		xhci->quirks |= XHCI_DEFAULT_PM_RUNTIME_ALLOW;
 
 	if (pdev->vendor == PCI_VENDOR_ID_ETRON &&
@@ -307,8 +294,14 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 	}
 
 	if (pdev->vendor == PCI_VENDOR_ID_ASMEDIA &&
-		pdev->device == PCI_DEVICE_ID_ASMEDIA_1042_XHCI)
+		pdev->device == PCI_DEVICE_ID_ASMEDIA_1042_XHCI) {
+		/*
+		 * try to tame the ASMedia 1042 controller which reports 0.96
+		 * but appears to behave more like 1.0
+		 */
+		xhci->quirks |= XHCI_SPURIOUS_SUCCESS;
 		xhci->quirks |= XHCI_BROKEN_STREAMS;
+	}
 	if (pdev->vendor == PCI_VENDOR_ID_ASMEDIA &&
 		pdev->device == PCI_DEVICE_ID_ASMEDIA_1042A_XHCI) {
 		xhci->quirks |= XHCI_TRUST_TX_LENGTH;
@@ -337,15 +330,8 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 	     pdev->device == PCI_DEVICE_ID_AMD_PROMONTORYA_4))
 		xhci->quirks |= XHCI_NO_SOFT_RETRY;
 
-	if (pdev->vendor == PCI_VENDOR_ID_AMD &&
-	    (pdev->device == PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_1 ||
-	    pdev->device == PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_2 ||
-	    pdev->device == PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_3 ||
-	    pdev->device == PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_4 ||
-	    pdev->device == PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_5 ||
-	    pdev->device == PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_6 ||
-	    pdev->device == PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_7 ||
-	    pdev->device == PCI_DEVICE_ID_AMD_YELLOW_CARP_XHCI_8))
+	/* xHC spec requires PCI devices to support D3hot and D3cold */
+	if (xhci->hci_version >= 0x120)
 		xhci->quirks |= XHCI_DEFAULT_PM_RUNTIME_ALLOW;
 
 	if (xhci->quirks & XHCI_RESET_ON_RESUME)
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 8c7710698428..3636fa49285c 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -795,9 +795,15 @@ void xhci_shutdown(struct usb_hcd *hcd)
 
 	spin_lock_irq(&xhci->lock);
 	xhci_halt(xhci);
-	/* Workaround for spurious wakeups at shutdown with HSW */
-	if (xhci->quirks & XHCI_SPURIOUS_WAKEUP)
+
+	/*
+	 * Workaround for spurious wakeps at shutdown with HSW, and for boot
+	 * firmware delay in ADL-P PCH if port are left in U3 at shutdown
+	 */
+	if (xhci->quirks & XHCI_SPURIOUS_WAKEUP ||
+	    xhci->quirks & XHCI_RESET_TO_DEFAULT)
 		xhci_reset(xhci, XHCI_RESET_SHORT_USEC);
+
 	spin_unlock_irq(&xhci->lock);
 
 	xhci_cleanup_msix(xhci);
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 3b39501f26ea..d3c0766c1984 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1904,6 +1904,7 @@ struct xhci_hcd {
 #define XHCI_BROKEN_D3COLD	BIT_ULL(41)
 #define XHCI_EP_CTX_BROKEN_DCS	BIT_ULL(42)
 #define XHCI_SUSPEND_RESUME_CLKS	BIT_ULL(43)
+#define XHCI_RESET_TO_DEFAULT	BIT_ULL(44)
 
 	unsigned int		num_active_eps;
 	unsigned int		limit_active_eps;
diff --git a/drivers/video/fbdev/smscufx.c b/drivers/video/fbdev/smscufx.c
index 7673db5da26b..5fa3f1e5dfe8 100644
--- a/drivers/video/fbdev/smscufx.c
+++ b/drivers/video/fbdev/smscufx.c
@@ -97,7 +97,6 @@ struct ufx_data {
 	struct kref kref;
 	int fb_count;
 	bool virtualized; /* true when physical usb device not present */
-	struct delayed_work free_framebuffer_work;
 	atomic_t usb_active; /* 0 = update virtual buffer, but no usb traffic */
 	atomic_t lost_pixels; /* 1 = a render op failed. Need screen refresh */
 	u8 *edid; /* null until we read edid from hw or get from sysfs */
@@ -1116,15 +1115,24 @@ static void ufx_free(struct kref *kref)
 {
 	struct ufx_data *dev = container_of(kref, struct ufx_data, kref);
 
-	/* this function will wait for all in-flight urbs to complete */
-	if (dev->urbs.count > 0)
-		ufx_free_urb_list(dev);
+	kfree(dev);
+}
 
-	pr_debug("freeing ufx_data %p", dev);
+static void ufx_ops_destory(struct fb_info *info)
+{
+	struct ufx_data *dev = info->par;
+	int node = info->node;
 
-	kfree(dev);
+	/* Assume info structure is freed after this point */
+	framebuffer_release(info);
+
+	pr_debug("fb_info for /dev/fb%d has been freed", node);
+
+	/* release reference taken by kref_init in probe() */
+	kref_put(&dev->kref, ufx_free);
 }
 
+
 static void ufx_release_urb_work(struct work_struct *work)
 {
 	struct urb_node *unode = container_of(work, struct urb_node,
@@ -1133,14 +1141,9 @@ static void ufx_release_urb_work(struct work_struct *work)
 	up(&unode->dev->urbs.limit_sem);
 }
 
-static void ufx_free_framebuffer_work(struct work_struct *work)
+static void ufx_free_framebuffer(struct ufx_data *dev)
 {
-	struct ufx_data *dev = container_of(work, struct ufx_data,
-					    free_framebuffer_work.work);
 	struct fb_info *info = dev->info;
-	int node = info->node;
-
-	unregister_framebuffer(info);
 
 	if (info->cmap.len != 0)
 		fb_dealloc_cmap(&info->cmap);
@@ -1152,11 +1155,6 @@ static void ufx_free_framebuffer_work(struct work_struct *work)
 
 	dev->info = NULL;
 
-	/* Assume info structure is freed after this point */
-	framebuffer_release(info);
-
-	pr_debug("fb_info for /dev/fb%d has been freed", node);
-
 	/* ref taken in probe() as part of registering framebfufer */
 	kref_put(&dev->kref, ufx_free);
 }
@@ -1168,11 +1166,13 @@ static int ufx_ops_release(struct fb_info *info, int user)
 {
 	struct ufx_data *dev = info->par;
 
+	mutex_lock(&disconnect_mutex);
+
 	dev->fb_count--;
 
 	/* We can't free fb_info here - fbmem will touch it when we return */
 	if (dev->virtualized && (dev->fb_count == 0))
-		schedule_delayed_work(&dev->free_framebuffer_work, HZ);
+		ufx_free_framebuffer(dev);
 
 	if ((dev->fb_count == 0) && (info->fbdefio)) {
 		fb_deferred_io_cleanup(info);
@@ -1185,6 +1185,8 @@ static int ufx_ops_release(struct fb_info *info, int user)
 
 	kref_put(&dev->kref, ufx_free);
 
+	mutex_unlock(&disconnect_mutex);
+
 	return 0;
 }
 
@@ -1291,6 +1293,7 @@ static const struct fb_ops ufx_ops = {
 	.fb_blank = ufx_ops_blank,
 	.fb_check_var = ufx_ops_check_var,
 	.fb_set_par = ufx_ops_set_par,
+	.fb_destroy = ufx_ops_destory,
 };
 
 /* Assumes &info->lock held by caller
@@ -1672,9 +1675,6 @@ static int ufx_usb_probe(struct usb_interface *interface,
 		goto destroy_modedb;
 	}
 
-	INIT_DELAYED_WORK(&dev->free_framebuffer_work,
-			  ufx_free_framebuffer_work);
-
 	retval = ufx_reg_read(dev, 0x3000, &id_rev);
 	check_warn_goto_error(retval, "error %d reading 0x3000 register from device", retval);
 	dev_dbg(dev->gdev, "ID_REV register value 0x%08x", id_rev);
@@ -1747,10 +1747,12 @@ static int ufx_usb_probe(struct usb_interface *interface,
 static void ufx_usb_disconnect(struct usb_interface *interface)
 {
 	struct ufx_data *dev;
+	struct fb_info *info;
 
 	mutex_lock(&disconnect_mutex);
 
 	dev = usb_get_intfdata(interface);
+	info = dev->info;
 
 	pr_debug("USB disconnect starting\n");
 
@@ -1764,12 +1766,15 @@ static void ufx_usb_disconnect(struct usb_interface *interface)
 
 	/* if clients still have us open, will be freed on last close */
 	if (dev->fb_count == 0)
-		schedule_delayed_work(&dev->free_framebuffer_work, 0);
+		ufx_free_framebuffer(dev);
 
-	/* release reference taken by kref_init in probe() */
-	kref_put(&dev->kref, ufx_free);
+	/* this function will wait for all in-flight urbs to complete */
+	if (dev->urbs.count > 0)
+		ufx_free_urb_list(dev);
 
-	/* consider ufx_data freed */
+	pr_debug("freeing ufx_data %p", dev);
+
+	unregister_framebuffer(info);
 
 	mutex_unlock(&disconnect_mutex);
 }
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index c93150f36a52..30379c33ad20 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -910,7 +910,7 @@ static int load_elf_binary(struct linux_binprm *bprm)
 		interp_elf_ex = kmalloc(sizeof(*interp_elf_ex), GFP_KERNEL);
 		if (!interp_elf_ex) {
 			retval = -ENOMEM;
-			goto out_free_ph;
+			goto out_free_file;
 		}
 
 		/* Get the exec headers */
@@ -1331,6 +1331,7 @@ static int load_elf_binary(struct linux_binprm *bprm)
 out_free_dentry:
 	kfree(interp_elf_ex);
 	kfree(interp_elf_phdata);
+out_free_file:
 	allow_write_access(interpreter);
 	if (interpreter)
 		fput(interpreter);
diff --git a/fs/exec.c b/fs/exec.c
index 7d424337b4ec..881390b44cfd 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1198,11 +1198,11 @@ static int unshare_sighand(struct task_struct *me)
 			return -ENOMEM;
 
 		refcount_set(&newsighand->count, 1);
-		memcpy(newsighand->action, oldsighand->action,
-		       sizeof(newsighand->action));
 
 		write_lock_irq(&tasklist_lock);
 		spin_lock(&oldsighand->siglock);
+		memcpy(newsighand->action, oldsighand->action,
+		       sizeof(newsighand->action));
 		rcu_assign_pointer(me->sighand, newsighand);
 		spin_unlock(&oldsighand->siglock);
 		write_unlock_irq(&tasklist_lock);
diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 7bf1d5fc2e9c..90677cfbcf9c 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -1547,8 +1547,11 @@ int kernfs_remove_by_name_ns(struct kernfs_node *parent, const char *name,
 	down_write(&kernfs_rwsem);
 
 	kn = kernfs_find_ns(parent, name, ns);
-	if (kn)
+	if (kn) {
+		kernfs_get(kn);
 		__kernfs_remove(kn);
+		kernfs_put(kn);
+	}
 
 	up_write(&kernfs_rwsem);
 
diff --git a/fs/nfs/nfs4namespace.c b/fs/nfs/nfs4namespace.c
index 3680c8da510c..f2dbf904c598 100644
--- a/fs/nfs/nfs4namespace.c
+++ b/fs/nfs/nfs4namespace.c
@@ -417,6 +417,9 @@ static int nfs_do_refmount(struct fs_context *fc, struct rpc_clnt *client)
 	fs_locations = kmalloc(sizeof(struct nfs4_fs_locations), GFP_KERNEL);
 	if (!fs_locations)
 		goto out_free;
+	fs_locations->fattr = nfs_alloc_fattr();
+	if (!fs_locations->fattr)
+		goto out_free_2;
 
 	/* Get locations */
 	dentry = ctx->clone_data.dentry;
@@ -427,14 +430,16 @@ static int nfs_do_refmount(struct fs_context *fc, struct rpc_clnt *client)
 	err = nfs4_proc_fs_locations(client, d_inode(parent), &dentry->d_name, fs_locations, page);
 	dput(parent);
 	if (err != 0)
-		goto out_free_2;
+		goto out_free_3;
 
 	err = -ENOENT;
 	if (fs_locations->nlocations <= 0 ||
 	    fs_locations->fs_path.ncomponents <= 0)
-		goto out_free_2;
+		goto out_free_3;
 
 	err = nfs_follow_referral(fc, fs_locations);
+out_free_3:
+	kfree(fs_locations->fattr);
 out_free_2:
 	kfree(fs_locations);
 out_free:
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index a808763c52c1..b42e332775fe 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -3981,18 +3981,23 @@ static int _nfs4_discover_trunking(struct nfs_server *server,
 	}
 
 	page = alloc_page(GFP_KERNEL);
+	if (!page)
+		return -ENOMEM;
 	locations = kmalloc(sizeof(struct nfs4_fs_locations), GFP_KERNEL);
-	if (page == NULL || locations == NULL)
-		goto out;
+	if (!locations)
+		goto out_free;
+	locations->fattr = nfs_alloc_fattr();
+	if (!locations->fattr)
+		goto out_free_2;
 
 	status = nfs4_proc_get_locations(server, fhandle, locations, page,
 					 cred);
-	if (status)
-		goto out;
-out:
-	if (page)
-		__free_page(page);
+
+	kfree(locations->fattr);
+out_free_2:
 	kfree(locations);
+out_free:
+	__free_page(page);
 	return status;
 }
 
@@ -4213,6 +4218,8 @@ static int nfs4_get_referral(struct rpc_clnt *client, struct inode *dir,
 	if (locations == NULL)
 		goto out;
 
+	locations->fattr = fattr;
+
 	status = nfs4_proc_fs_locations(client, dir, name, locations, page);
 	if (status != 0)
 		goto out;
@@ -4222,17 +4229,14 @@ static int nfs4_get_referral(struct rpc_clnt *client, struct inode *dir,
 	 * referral.  Cause us to drop into the exception handler, which
 	 * will kick off migration recovery.
 	 */
-	if (nfs_fsid_equal(&NFS_SERVER(dir)->fsid, &locations->fattr.fsid)) {
+	if (nfs_fsid_equal(&NFS_SERVER(dir)->fsid, &fattr->fsid)) {
 		dprintk("%s: server did not return a different fsid for"
 			" a referral at %s\n", __func__, name->name);
 		status = -NFS4ERR_MOVED;
 		goto out;
 	}
 	/* Fixup attributes for the nfs_lookup() call to nfs_fhget() */
-	nfs_fixup_referral_attributes(&locations->fattr);
-
-	/* replace the lookup nfs_fattr with the locations nfs_fattr */
-	memcpy(fattr, &locations->fattr, sizeof(struct nfs_fattr));
+	nfs_fixup_referral_attributes(fattr);
 	memset(fhandle, 0, sizeof(struct nfs_fh));
 out:
 	if (page)
@@ -7917,7 +7921,7 @@ static int _nfs4_proc_fs_locations(struct rpc_clnt *client, struct inode *dir,
 	else
 		bitmask[1] &= ~FATTR4_WORD1_MOUNTED_ON_FILEID;
 
-	nfs_fattr_init(&fs_locations->fattr);
+	nfs_fattr_init(fs_locations->fattr);
 	fs_locations->server = server;
 	fs_locations->nlocations = 0;
 	status = nfs4_call_sync(client, server, &msg, &args.seq_args, &res.seq_res, 0);
@@ -7982,7 +7986,7 @@ static int _nfs40_proc_get_locations(struct nfs_server *server,
 	unsigned long now = jiffies;
 	int status;
 
-	nfs_fattr_init(&locations->fattr);
+	nfs_fattr_init(locations->fattr);
 	locations->server = server;
 	locations->nlocations = 0;
 
@@ -8035,7 +8039,7 @@ static int _nfs41_proc_get_locations(struct nfs_server *server,
 	};
 	int status;
 
-	nfs_fattr_init(&locations->fattr);
+	nfs_fattr_init(locations->fattr);
 	locations->server = server;
 	locations->nlocations = 0;
 
diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index 83c88b54d712..32ee79a99246 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -2096,6 +2096,11 @@ static int nfs4_try_migration(struct nfs_server *server, const struct cred *cred
 		dprintk("<-- %s: no memory\n", __func__);
 		goto out;
 	}
+	locations->fattr = nfs_alloc_fattr();
+	if (locations->fattr == NULL) {
+		dprintk("<-- %s: no memory\n", __func__);
+		goto out;
+	}
 
 	inode = d_inode(server->super->s_root);
 	result = nfs4_proc_get_locations(server, NFS_FH(inode), locations,
@@ -2110,7 +2115,7 @@ static int nfs4_try_migration(struct nfs_server *server, const struct cred *cred
 	if (!locations->nlocations)
 		goto out;
 
-	if (!(locations->fattr.valid & NFS_ATTR_FATTR_V4_LOCATIONS)) {
+	if (!(locations->fattr->valid & NFS_ATTR_FATTR_V4_LOCATIONS)) {
 		dprintk("<-- %s: No fs_locations data, migration skipped\n",
 			__func__);
 		goto out;
@@ -2135,6 +2140,8 @@ static int nfs4_try_migration(struct nfs_server *server, const struct cred *cred
 out:
 	if (page != NULL)
 		__free_page(page);
+	if (locations != NULL)
+		kfree(locations->fattr);
 	kfree(locations);
 	if (result) {
 		pr_err("NFS: migration recovery failed (server %s)\n",
diff --git a/fs/nfs/nfs4xdr.c b/fs/nfs/nfs4xdr.c
index 2a1bf0a72d5b..046788afb6d9 100644
--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -7028,7 +7028,7 @@ static int nfs4_xdr_dec_fs_locations(struct rpc_rqst *req,
 	if (res->migration) {
 		xdr_enter_page(xdr, PAGE_SIZE);
 		status = decode_getfattr_generic(xdr,
-					&res->fs_locations->fattr,
+					res->fs_locations->fattr,
 					 NULL, res->fs_locations,
 					 NULL, res->fs_locations->server);
 		if (status)
@@ -7041,7 +7041,7 @@ static int nfs4_xdr_dec_fs_locations(struct rpc_rqst *req,
 			goto out;
 		xdr_enter_page(xdr, PAGE_SIZE);
 		status = decode_getfattr_generic(xdr,
-					&res->fs_locations->fattr,
+					res->fs_locations->fattr,
 					 NULL, res->fs_locations,
 					 NULL, res->fs_locations->server);
 	}
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 4c678de4608d..26095c0fd781 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -966,7 +966,7 @@ void mlx5_cmd_allowed_opcode(struct mlx5_core_dev *dev, u16 opcode);
 struct mlx5_async_ctx {
 	struct mlx5_core_dev *dev;
 	atomic_t num_inflight;
-	struct wait_queue_head wait;
+	struct completion inflight_done;
 };
 
 struct mlx5_async_work;
diff --git a/include/linux/nfs_xdr.h b/include/linux/nfs_xdr.h
index ecd74cc34797..783f871b4e12 100644
--- a/include/linux/nfs_xdr.h
+++ b/include/linux/nfs_xdr.h
@@ -1219,7 +1219,7 @@ struct nfs4_fs_location {
 
 #define NFS4_FS_LOCATIONS_MAXENTRIES 10
 struct nfs4_fs_locations {
-	struct nfs_fattr fattr;
+	struct nfs_fattr *fattr;
 	const struct nfs_server *server;
 	struct nfs4_pathname fs_path;
 	int nlocations;
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 6cce33e7e7ac..014eb0a963fc 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -723,11 +723,14 @@ struct perf_event {
 	struct fasync_struct		*fasync;
 
 	/* delayed work for NMIs and such */
-	int				pending_wakeup;
-	int				pending_kill;
-	int				pending_disable;
+	unsigned int			pending_wakeup;
+	unsigned int			pending_kill;
+	unsigned int			pending_disable;
+	unsigned int			pending_sigtrap;
 	unsigned long			pending_addr;	/* SIGTRAP */
-	struct irq_work			pending;
+	struct irq_work			pending_irq;
+	struct callback_head		pending_task;
+	unsigned int			pending_work;
 
 	atomic_t			event_limit;
 
@@ -841,6 +844,14 @@ struct perf_event_context {
 #endif
 	void				*task_ctx_data; /* pmu specific data */
 	struct rcu_head			rcu_head;
+
+	/*
+	 * Sum (event->pending_sigtrap + event->pending_work)
+	 *
+	 * The SIGTRAP is targeted at ctx->task, as such it won't do changing
+	 * that until the signal is delivered.
+	 */
+	local_t				nr_pending;
 };
 
 /*
diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
index 3eb202259e8c..5e25a098e8ce 100644
--- a/include/media/v4l2-common.h
+++ b/include/media/v4l2-common.h
@@ -175,7 +175,8 @@ struct v4l2_subdev *v4l2_i2c_new_subdev_board(struct v4l2_device *v4l2_dev,
  *
  * @sd: pointer to &struct v4l2_subdev
  * @client: pointer to struct i2c_client
- * @devname: the name of the device; if NULL, the I²C device's name will be used
+ * @devname: the name of the device; if NULL, the I²C device drivers's name
+ *           will be used
  * @postfix: sub-device specific string to put right after the I²C device name;
  *	     may be NULL
  */
diff --git a/include/net/sock.h b/include/net/sock.h
index cb1a1bb64ed8..e1a303e4f0f7 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2472,7 +2472,7 @@ static inline gfp_t gfp_any(void)
 
 static inline gfp_t gfp_memcg_charge(void)
 {
-	return in_softirq() ? GFP_NOWAIT : GFP_KERNEL;
+	return in_softirq() ? GFP_ATOMIC : GFP_KERNEL;
 }
 
 static inline long sock_rcvtimeo(const struct sock *sk, bool noblock)
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 9260791b8438..61c5011dfc13 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1560,7 +1560,8 @@ struct v4l2_bt_timings {
 	((bt)->width + V4L2_DV_BT_BLANKING_WIDTH(bt))
 #define V4L2_DV_BT_BLANKING_HEIGHT(bt) \
 	((bt)->vfrontporch + (bt)->vsync + (bt)->vbackporch + \
-	 (bt)->il_vfrontporch + (bt)->il_vsync + (bt)->il_vbackporch)
+	 ((bt)->interlaced ? \
+	  ((bt)->il_vfrontporch + (bt)->il_vsync + (bt)->il_vbackporch) : 0))
 #define V4L2_DV_BT_FRAME_HEIGHT(bt) \
 	((bt)->height + V4L2_DV_BT_BLANKING_HEIGHT(bt))
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index c6c7a4d80573..59654c737168 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -54,6 +54,7 @@
 #include <linux/highmem.h>
 #include <linux/pgtable.h>
 #include <linux/buildid.h>
+#include <linux/task_work.h>
 
 #include "internal.h"
 
@@ -2352,11 +2353,26 @@ event_sched_out(struct perf_event *event,
 	event->pmu->del(event, 0);
 	event->oncpu = -1;
 
-	if (READ_ONCE(event->pending_disable) >= 0) {
-		WRITE_ONCE(event->pending_disable, -1);
+	if (event->pending_disable) {
+		event->pending_disable = 0;
 		perf_cgroup_event_disable(event, ctx);
 		state = PERF_EVENT_STATE_OFF;
 	}
+
+	if (event->pending_sigtrap) {
+		bool dec = true;
+
+		event->pending_sigtrap = 0;
+		if (state != PERF_EVENT_STATE_OFF &&
+		    !event->pending_work) {
+			event->pending_work = 1;
+			dec = false;
+			task_work_add(current, &event->pending_task, TWA_RESUME);
+		}
+		if (dec)
+			local_dec(&event->ctx->nr_pending);
+	}
+
 	perf_event_set_state(event, state);
 
 	if (!is_software_event(event))
@@ -2508,7 +2524,7 @@ static void __perf_event_disable(struct perf_event *event,
  * hold the top-level event's child_mutex, so any descendant that
  * goes to exit will block in perf_event_exit_event().
  *
- * When called from perf_pending_event it's OK because event->ctx
+ * When called from perf_pending_irq it's OK because event->ctx
  * is the current context on this CPU and preemption is disabled,
  * hence we can't get into perf_event_task_sched_out for this context.
  */
@@ -2547,9 +2563,8 @@ EXPORT_SYMBOL_GPL(perf_event_disable);
 
 void perf_event_disable_inatomic(struct perf_event *event)
 {
-	WRITE_ONCE(event->pending_disable, smp_processor_id());
-	/* can fail, see perf_pending_event_disable() */
-	irq_work_queue(&event->pending);
+	event->pending_disable = 1;
+	irq_work_queue(&event->pending_irq);
 }
 
 #define MAX_INTERRUPTS (~0ULL)
@@ -3506,11 +3521,23 @@ static void perf_event_context_sched_out(struct task_struct *task, int ctxn,
 		raw_spin_lock_nested(&next_ctx->lock, SINGLE_DEPTH_NESTING);
 		if (context_equiv(ctx, next_ctx)) {
 
+			perf_pmu_disable(pmu);
+
+			/* PMIs are disabled; ctx->nr_pending is stable. */
+			if (local_read(&ctx->nr_pending) ||
+			    local_read(&next_ctx->nr_pending)) {
+				/*
+				 * Must not swap out ctx when there's pending
+				 * events that rely on the ctx->task relation.
+				 */
+				raw_spin_unlock(&next_ctx->lock);
+				rcu_read_unlock();
+				goto inside_switch;
+			}
+
 			WRITE_ONCE(ctx->task, next);
 			WRITE_ONCE(next_ctx->task, task);
 
-			perf_pmu_disable(pmu);
-
 			if (cpuctx->sched_cb_usage && pmu->sched_task)
 				pmu->sched_task(ctx, false);
 
@@ -3551,6 +3578,7 @@ static void perf_event_context_sched_out(struct task_struct *task, int ctxn,
 		raw_spin_lock(&ctx->lock);
 		perf_pmu_disable(pmu);
 
+inside_switch:
 		if (cpuctx->sched_cb_usage && pmu->sched_task)
 			pmu->sched_task(ctx, false);
 		task_ctx_sched_out(cpuctx, ctx, EVENT_ALL);
@@ -5030,7 +5058,7 @@ static void perf_addr_filters_splice(struct perf_event *event,
 
 static void _free_event(struct perf_event *event)
 {
-	irq_work_sync(&event->pending);
+	irq_work_sync(&event->pending_irq);
 
 	unaccount_event(event);
 
@@ -6524,7 +6552,8 @@ static void perf_sigtrap(struct perf_event *event)
 		return;
 
 	/*
-	 * perf_pending_event() can race with the task exiting.
+	 * Both perf_pending_task() and perf_pending_irq() can race with the
+	 * task exiting.
 	 */
 	if (current->flags & PF_EXITING)
 		return;
@@ -6533,23 +6562,33 @@ static void perf_sigtrap(struct perf_event *event)
 		      event->attr.type, event->attr.sig_data);
 }
 
-static void perf_pending_event_disable(struct perf_event *event)
+/*
+ * Deliver the pending work in-event-context or follow the context.
+ */
+static void __perf_pending_irq(struct perf_event *event)
 {
-	int cpu = READ_ONCE(event->pending_disable);
+	int cpu = READ_ONCE(event->oncpu);
 
+	/*
+	 * If the event isn't running; we done. event_sched_out() will have
+	 * taken care of things.
+	 */
 	if (cpu < 0)
 		return;
 
+	/*
+	 * Yay, we hit home and are in the context of the event.
+	 */
 	if (cpu == smp_processor_id()) {
-		WRITE_ONCE(event->pending_disable, -1);
-
-		if (event->attr.sigtrap) {
+		if (event->pending_sigtrap) {
+			event->pending_sigtrap = 0;
 			perf_sigtrap(event);
-			atomic_set_release(&event->event_limit, 1); /* rearm event */
-			return;
+			local_dec(&event->ctx->nr_pending);
+		}
+		if (event->pending_disable) {
+			event->pending_disable = 0;
+			perf_event_disable_local(event);
 		}
-
-		perf_event_disable_local(event);
 		return;
 	}
 
@@ -6569,36 +6608,63 @@ static void perf_pending_event_disable(struct perf_event *event)
 	 *				  irq_work_queue(); // FAILS
 	 *
 	 *  irq_work_run()
-	 *    perf_pending_event()
+	 *    perf_pending_irq()
 	 *
 	 * But the event runs on CPU-B and wants disabling there.
 	 */
-	irq_work_queue_on(&event->pending, cpu);
+	irq_work_queue_on(&event->pending_irq, cpu);
 }
 
-static void perf_pending_event(struct irq_work *entry)
+static void perf_pending_irq(struct irq_work *entry)
 {
-	struct perf_event *event = container_of(entry, struct perf_event, pending);
+	struct perf_event *event = container_of(entry, struct perf_event, pending_irq);
 	int rctx;
 
-	rctx = perf_swevent_get_recursion_context();
 	/*
 	 * If we 'fail' here, that's OK, it means recursion is already disabled
 	 * and we won't recurse 'further'.
 	 */
+	rctx = perf_swevent_get_recursion_context();
 
-	perf_pending_event_disable(event);
-
+	/*
+	 * The wakeup isn't bound to the context of the event -- it can happen
+	 * irrespective of where the event is.
+	 */
 	if (event->pending_wakeup) {
 		event->pending_wakeup = 0;
 		perf_event_wakeup(event);
 	}
 
+	__perf_pending_irq(event);
+
 	if (rctx >= 0)
 		perf_swevent_put_recursion_context(rctx);
 }
 
-/*
+static void perf_pending_task(struct callback_head *head)
+{
+	struct perf_event *event = container_of(head, struct perf_event, pending_task);
+	int rctx;
+
+	/*
+	 * If we 'fail' here, that's OK, it means recursion is already disabled
+	 * and we won't recurse 'further'.
+	 */
+	preempt_disable_notrace();
+	rctx = perf_swevent_get_recursion_context();
+
+	if (event->pending_work) {
+		event->pending_work = 0;
+		perf_sigtrap(event);
+		local_dec(&event->ctx->nr_pending);
+	}
+
+	if (rctx >= 0)
+		perf_swevent_put_recursion_context(rctx);
+	preempt_enable_notrace();
+}
+
+/*              
  * We assume there is only KVM supporting the callbacks.
  * Later on, we might change it to a list if there is
  * another virtualization implementation supporting the callbacks.
@@ -9229,8 +9295,8 @@ int perf_event_account_interrupt(struct perf_event *event)
  */
 
 static int __perf_event_overflow(struct perf_event *event,
-				   int throttle, struct perf_sample_data *data,
-				   struct pt_regs *regs)
+				 int throttle, struct perf_sample_data *data,
+				 struct pt_regs *regs)
 {
 	int events = atomic_read(&event->event_limit);
 	int ret = 0;
@@ -9253,24 +9319,36 @@ static int __perf_event_overflow(struct perf_event *event,
 	if (events && atomic_dec_and_test(&event->event_limit)) {
 		ret = 1;
 		event->pending_kill = POLL_HUP;
-		event->pending_addr = data->addr;
-
 		perf_event_disable_inatomic(event);
 	}
 
+	if (event->attr.sigtrap) {
+		/*
+		 * Should not be able to return to user space without processing
+		 * pending_sigtrap (kernel events can overflow multiple times).
+		 */
+		WARN_ON_ONCE(event->pending_sigtrap && event->attr.exclude_kernel);
+		if (!event->pending_sigtrap) {
+			event->pending_sigtrap = 1;
+			local_inc(&event->ctx->nr_pending);
+		}
+		event->pending_addr = data->addr;
+		irq_work_queue(&event->pending_irq);
+	}
+
 	READ_ONCE(event->overflow_handler)(event, data, regs);
 
 	if (*perf_event_fasync(event) && event->pending_kill) {
 		event->pending_wakeup = 1;
-		irq_work_queue(&event->pending);
+		irq_work_queue(&event->pending_irq);
 	}
 
 	return ret;
 }
 
 int perf_event_overflow(struct perf_event *event,
-			  struct perf_sample_data *data,
-			  struct pt_regs *regs)
+			struct perf_sample_data *data,
+			struct pt_regs *regs)
 {
 	return __perf_event_overflow(event, 1, data, regs);
 }
@@ -11576,8 +11654,8 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 
 
 	init_waitqueue_head(&event->waitq);
-	event->pending_disable = -1;
-	init_irq_work(&event->pending, perf_pending_event);
+	init_irq_work(&event->pending_irq, perf_pending_irq);
+	init_task_work(&event->pending_task, perf_pending_task);
 
 	mutex_init(&event->mmap_mutex);
 	raw_spin_lock_init(&event->addr_filters.lock);
@@ -11599,9 +11677,6 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 	if (parent_event)
 		event->event_caps = parent_event->event_caps;
 
-	if (event->attr.sigtrap)
-		atomic_set(&event->event_limit, 1);
-
 	if (task) {
 		event->attach_state = PERF_ATTACH_TASK;
 		/*
diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index fb35b926024c..f40da32f5e75 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -22,7 +22,7 @@ static void perf_output_wakeup(struct perf_output_handle *handle)
 	atomic_set(&handle->rb->poll, EPOLLIN);
 
 	handle->event->pending_wakeup = 1;
-	irq_work_queue(&handle->event->pending);
+	irq_work_queue(&handle->event->pending_irq);
 }
 
 /*
diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index d926852f8119..9abc73d500fb 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -640,7 +640,7 @@ static void power_down(void)
 	int error;
 
 	if (hibernation_mode == HIBERNATION_SUSPEND) {
-		error = suspend_devices_and_enter(PM_SUSPEND_MEM);
+		error = suspend_devices_and_enter(mem_sleep_current);
 		if (error) {
 			hibernation_mode = hibernation_ops ?
 						HIBERNATION_PLATFORM :
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index e49902898253..7a3fcd70aa86 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1148,6 +1148,14 @@ static inline bool is_migration_disabled(struct task_struct *p)
 #endif
 }
 
+DECLARE_PER_CPU_SHARED_ALIGNED(struct rq, runqueues);
+
+#define cpu_rq(cpu)		(&per_cpu(runqueues, (cpu)))
+#define this_rq()		this_cpu_ptr(&runqueues)
+#define task_rq(p)		cpu_rq(task_cpu(p))
+#define cpu_curr(cpu)		(cpu_rq(cpu)->curr)
+#define raw_rq()		raw_cpu_ptr(&runqueues)
+
 struct sched_group;
 #ifdef CONFIG_SCHED_CORE
 static inline struct cpumask *sched_group_span(struct sched_group *sg);
@@ -1235,7 +1243,7 @@ static inline bool sched_group_cookie_match(struct rq *rq,
 		return true;
 
 	for_each_cpu_and(cpu, sched_group_span(group), p->cpus_ptr) {
-		if (sched_core_cookie_match(rq, p))
+		if (sched_core_cookie_match(cpu_rq(cpu), p))
 			return true;
 	}
 	return false;
@@ -1361,14 +1369,6 @@ static inline void update_idle_core(struct rq *rq)
 static inline void update_idle_core(struct rq *rq) { }
 #endif
 
-DECLARE_PER_CPU_SHARED_ALIGNED(struct rq, runqueues);
-
-#define cpu_rq(cpu)		(&per_cpu(runqueues, (cpu)))
-#define this_rq()		this_cpu_ptr(&runqueues)
-#define task_rq(p)		cpu_rq(task_cpu(p))
-#define cpu_curr(cpu)		(cpu_rq(cpu)->curr)
-#define raw_rq()		raw_cpu_ptr(&runqueues)
-
 #ifdef CONFIG_FAIR_GROUP_SCHED
 static inline struct task_struct *task_of(struct sched_entity *se)
 {
diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index d7d86c944d76..55f29c9f9e08 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -342,10 +342,12 @@ static void j1939_session_skb_drop_old(struct j1939_session *session)
 		__skb_unlink(do_skb, &session->skb_queue);
 		/* drop ref taken in j1939_session_skb_queue() */
 		skb_unref(do_skb);
+		spin_unlock_irqrestore(&session->skb_queue.lock, flags);
 
 		kfree_skb(do_skb);
+	} else {
+		spin_unlock_irqrestore(&session->skb_queue.lock, flags);
 	}
-	spin_unlock_irqrestore(&session->skb_queue.lock, flags);
 }
 
 void j1939_session_skb_queue(struct j1939_session *session,
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 9745cb6fdf51..982d06332007 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -117,6 +117,7 @@ static int net_assign_generic(struct net *net, unsigned int id, void *data)
 
 static int ops_init(const struct pernet_operations *ops, struct net *net)
 {
+	struct net_generic *ng;
 	int err = -ENOMEM;
 	void *data = NULL;
 
@@ -135,7 +136,13 @@ static int ops_init(const struct pernet_operations *ops, struct net *net)
 	if (!err)
 		return 0;
 
+	if (ops->id && ops->size) {
 cleanup:
+		ng = rcu_dereference_protected(net->gen,
+					       lockdep_is_held(&pernet_ops_rwsem));
+		ng->ptr[*ops->id] = NULL;
+	}
+
 	kfree(data);
 
 out:
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 3c193e7d4bc6..9cc607b2d3d2 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3821,7 +3821,7 @@ int skb_append_pagefrags(struct sk_buff *skb, struct page *page,
 		skb_frag_size_add(&skb_shinfo(skb)->frags[i - 1], size);
 	} else if (i < MAX_SKB_FRAGS) {
 		get_page(page);
-		skb_fill_page_desc(skb, i, page, offset, size);
+		skb_fill_page_desc_noacc(skb, i, page, offset, size);
 	} else {
 		return -EMSGSIZE;
 	}
diff --git a/net/ethtool/eeprom.c b/net/ethtool/eeprom.c
index 1c94bb8ea03f..49c0a2a77f02 100644
--- a/net/ethtool/eeprom.c
+++ b/net/ethtool/eeprom.c
@@ -124,7 +124,7 @@ static int eeprom_prepare_data(const struct ethnl_req_info *req_base,
 	if (ret)
 		goto err_free;
 
-	ret = get_module_eeprom_by_page(dev, &page_data, info->extack);
+	ret = get_module_eeprom_by_page(dev, &page_data, info ? info->extack : NULL);
 	if (ret < 0)
 		goto err_ops;
 
diff --git a/net/ieee802154/socket.c b/net/ieee802154/socket.c
index d0aaa0346cb1..c33f46c9b6b3 100644
--- a/net/ieee802154/socket.c
+++ b/net/ieee802154/socket.c
@@ -502,8 +502,10 @@ static int dgram_bind(struct sock *sk, struct sockaddr *uaddr, int len)
 	if (err < 0)
 		goto out;
 
-	if (addr->family != AF_IEEE802154)
+	if (addr->family != AF_IEEE802154) {
+		err = -EINVAL;
 		goto out;
+	}
 
 	ieee802154_addr_from_sa(&haddr, &addr->addr);
 	dev = ieee802154_get_dev(sock_net(sk), &haddr);
diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index cc8f120149f6..6cc7d347ec0a 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -2535,7 +2535,7 @@ static int nh_create_ipv4(struct net *net, struct nexthop *nh,
 	if (!err) {
 		nh->nh_flags = fib_nh->fib_nh_flags;
 		fib_info_update_nhc_saddr(net, &fib_nh->nh_common,
-					  fib_nh->fib_nh_scope);
+					  !fib_nh->fib_nh_scope ? 0 : fib_nh->fib_nh_scope - 1);
 	} else {
 		fib_nh_release(net, fib_nh);
 	}
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 686e210d89c2..102a0436eb29 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -2185,7 +2185,8 @@ void tcp_enter_loss(struct sock *sk)
  */
 static bool tcp_check_sack_reneging(struct sock *sk, int flag)
 {
-	if (flag & FLAG_SACK_RENEGING) {
+	if (flag & FLAG_SACK_RENEGING &&
+	    flag & FLAG_SND_UNA_ADVANCED) {
 		struct tcp_sock *tp = tcp_sk(sk);
 		unsigned long delay = max(usecs_to_jiffies(tp->srtt_us >> 4),
 					  msecs_to_jiffies(10));
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 88a45d5650da..42d4af632495 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1808,8 +1808,7 @@ int tcp_v4_early_demux(struct sk_buff *skb)
 
 bool tcp_add_backlog(struct sock *sk, struct sk_buff *skb)
 {
-	u32 limit = READ_ONCE(sk->sk_rcvbuf) + READ_ONCE(sk->sk_sndbuf);
-	u32 tail_gso_size, tail_gso_segs;
+	u32 limit, tail_gso_size, tail_gso_segs;
 	struct skb_shared_info *shinfo;
 	const struct tcphdr *th;
 	struct tcphdr *thtail;
@@ -1913,11 +1912,13 @@ bool tcp_add_backlog(struct sock *sk, struct sk_buff *skb)
 	__skb_push(skb, hdrlen);
 
 no_coalesce:
+	limit = (u32)READ_ONCE(sk->sk_rcvbuf) + (u32)(READ_ONCE(sk->sk_sndbuf) >> 1);
+
 	/* Only socket owner can try to collapse/prune rx queues
 	 * to reduce memory overhead, so add a little headroom here.
 	 * Few sockets backlog are possibly concurrently non empty.
 	 */
-	limit += 64*1024;
+	limit += 64 * 1024;
 
 	if (unlikely(sk_add_backlog(sk, skb, limit))) {
 		bh_unlock_sock(sk);
diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index 70ef4d4ebff4..13b1748b8b46 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -1153,14 +1153,16 @@ static void ip6gre_tnl_link_config_route(struct ip6_tnl *t, int set_mtu,
 				dev->needed_headroom = dst_len;
 
 			if (set_mtu) {
-				dev->mtu = rt->dst.dev->mtu - t_hlen;
+				int mtu = rt->dst.dev->mtu - t_hlen;
+
 				if (!(t->parms.flags & IP6_TNL_F_IGN_ENCAP_LIMIT))
-					dev->mtu -= 8;
+					mtu -= 8;
 				if (dev->type == ARPHRD_ETHER)
-					dev->mtu -= ETH_HLEN;
+					mtu -= ETH_HLEN;
 
-				if (dev->mtu < IPV6_MIN_MTU)
-					dev->mtu = IPV6_MIN_MTU;
+				if (mtu < IPV6_MIN_MTU)
+					mtu = IPV6_MIN_MTU;
+				WRITE_ONCE(dev->mtu, mtu);
 			}
 		}
 		ip6_rt_put(rt);
diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index fa8da8ff35b4..ea5077942871 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1446,8 +1446,8 @@ static void ip6_tnl_link_config(struct ip6_tnl *t)
 	struct net_device *tdev = NULL;
 	struct __ip6_tnl_parm *p = &t->parms;
 	struct flowi6 *fl6 = &t->fl.u.ip6;
-	unsigned int mtu;
 	int t_hlen;
+	int mtu;
 
 	memcpy(dev->dev_addr, &p->laddr, sizeof(struct in6_addr));
 	memcpy(dev->broadcast, &p->raddr, sizeof(struct in6_addr));
@@ -1494,12 +1494,13 @@ static void ip6_tnl_link_config(struct ip6_tnl *t)
 			dev->hard_header_len = tdev->hard_header_len + t_hlen;
 			mtu = min_t(unsigned int, tdev->mtu, IP6_MAX_MTU);
 
-			dev->mtu = mtu - t_hlen;
+			mtu = mtu - t_hlen;
 			if (!(t->parms.flags & IP6_TNL_F_IGN_ENCAP_LIMIT))
-				dev->mtu -= 8;
+				mtu -= 8;
 
-			if (dev->mtu < IPV6_MIN_MTU)
-				dev->mtu = IPV6_MIN_MTU;
+			if (mtu < IPV6_MIN_MTU)
+				mtu = IPV6_MIN_MTU;
+			WRITE_ONCE(dev->mtu, mtu);
 		}
 	}
 }
diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index 8a1c78f38508..b24e0e5d55f9 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -417,6 +417,12 @@ static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
 		rtnl_lock();
 	lock_sock(sk);
 
+	/* Another thread has converted the socket into IPv4 with
+	 * IPV6_ADDRFORM concurrently.
+	 */
+	if (unlikely(sk->sk_family != AF_INET6))
+		goto unlock;
+
 	switch (optname) {
 
 	case IPV6_ADDRFORM:
@@ -976,6 +982,7 @@ static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
 		break;
 	}
 
+unlock:
 	release_sock(sk);
 	if (needs_rtnl)
 		rtnl_unlock();
diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index 637cd99bd7a6..946871741f12 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -1130,10 +1130,12 @@ static void ipip6_tunnel_bind_dev(struct net_device *dev)
 
 	if (tdev && !netif_is_l3_master(tdev)) {
 		int t_hlen = tunnel->hlen + sizeof(struct iphdr);
+		int mtu;
 
-		dev->mtu = tdev->mtu - t_hlen;
-		if (dev->mtu < IPV6_MIN_MTU)
-			dev->mtu = IPV6_MIN_MTU;
+		mtu = tdev->mtu - t_hlen;
+		if (mtu < IPV6_MIN_MTU)
+			mtu = IPV6_MIN_MTU;
+		WRITE_ONCE(dev->mtu, mtu);
 	}
 }
 
diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
index f780fbe82e7d..a1478ad393f9 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -161,7 +161,8 @@ static void kcm_rcv_ready(struct kcm_sock *kcm)
 	/* Buffer limit is okay now, add to ready list */
 	list_add_tail(&kcm->wait_rx_list,
 		      &kcm->mux->kcm_rx_waiters);
-	kcm->rx_wait = true;
+	/* paired with lockless reads in kcm_rfree() */
+	WRITE_ONCE(kcm->rx_wait, true);
 }
 
 static void kcm_rfree(struct sk_buff *skb)
@@ -177,7 +178,7 @@ static void kcm_rfree(struct sk_buff *skb)
 	/* For reading rx_wait and rx_psock without holding lock */
 	smp_mb__after_atomic();
 
-	if (!kcm->rx_wait && !kcm->rx_psock &&
+	if (!READ_ONCE(kcm->rx_wait) && !READ_ONCE(kcm->rx_psock) &&
 	    sk_rmem_alloc_get(sk) < sk->sk_rcvlowat) {
 		spin_lock_bh(&mux->rx_lock);
 		kcm_rcv_ready(kcm);
@@ -236,7 +237,8 @@ static void requeue_rx_msgs(struct kcm_mux *mux, struct sk_buff_head *head)
 		if (kcm_queue_rcv_skb(&kcm->sk, skb)) {
 			/* Should mean socket buffer full */
 			list_del(&kcm->wait_rx_list);
-			kcm->rx_wait = false;
+			/* paired with lockless reads in kcm_rfree() */
+			WRITE_ONCE(kcm->rx_wait, false);
 
 			/* Commit rx_wait to read in kcm_free */
 			smp_wmb();
@@ -279,10 +281,12 @@ static struct kcm_sock *reserve_rx_kcm(struct kcm_psock *psock,
 	kcm = list_first_entry(&mux->kcm_rx_waiters,
 			       struct kcm_sock, wait_rx_list);
 	list_del(&kcm->wait_rx_list);
-	kcm->rx_wait = false;
+	/* paired with lockless reads in kcm_rfree() */
+	WRITE_ONCE(kcm->rx_wait, false);
 
 	psock->rx_kcm = kcm;
-	kcm->rx_psock = psock;
+	/* paired with lockless reads in kcm_rfree() */
+	WRITE_ONCE(kcm->rx_psock, psock);
 
 	spin_unlock_bh(&mux->rx_lock);
 
@@ -309,7 +313,8 @@ static void unreserve_rx_kcm(struct kcm_psock *psock,
 	spin_lock_bh(&mux->rx_lock);
 
 	psock->rx_kcm = NULL;
-	kcm->rx_psock = NULL;
+	/* paired with lockless reads in kcm_rfree() */
+	WRITE_ONCE(kcm->rx_psock, NULL);
 
 	/* Commit kcm->rx_psock before sk_rmem_alloc_get to sync with
 	 * kcm_rfree
@@ -833,7 +838,7 @@ static ssize_t kcm_sendpage(struct socket *sock, struct page *page,
 	}
 
 	get_page(page);
-	skb_fill_page_desc(skb, i, page, offset, size);
+	skb_fill_page_desc_noacc(skb, i, page, offset, size);
 	skb_shinfo(skb)->flags |= SKBFL_SHARED_FRAG;
 
 coalesced:
@@ -1239,7 +1244,8 @@ static void kcm_recv_disable(struct kcm_sock *kcm)
 	if (!kcm->rx_psock) {
 		if (kcm->rx_wait) {
 			list_del(&kcm->wait_rx_list);
-			kcm->rx_wait = false;
+			/* paired with lockless reads in kcm_rfree() */
+			WRITE_ONCE(kcm->rx_wait, false);
 		}
 
 		requeue_rx_msgs(mux, &kcm->sk.sk_receive_queue);
@@ -1792,7 +1798,8 @@ static void kcm_done(struct kcm_sock *kcm)
 
 	if (kcm->rx_wait) {
 		list_del(&kcm->wait_rx_list);
-		kcm->rx_wait = false;
+		/* paired with lockless reads in kcm_rfree() */
+		WRITE_ONCE(kcm->rx_wait, false);
 	}
 	/* Move any pending receive messages to other kcm sockets */
 	requeue_rx_msgs(mux, &sk->sk_receive_queue);
diff --git a/net/mac802154/rx.c b/net/mac802154/rx.c
index c439125ef2b9..726b47a4611b 100644
--- a/net/mac802154/rx.c
+++ b/net/mac802154/rx.c
@@ -132,7 +132,7 @@ static int
 ieee802154_parse_frame_start(struct sk_buff *skb, struct ieee802154_hdr *hdr)
 {
 	int hlen;
-	struct ieee802154_mac_cb *cb = mac_cb_init(skb);
+	struct ieee802154_mac_cb *cb = mac_cb(skb);
 
 	skb_reset_mac_header(skb);
 
@@ -294,8 +294,9 @@ void
 ieee802154_rx_irqsafe(struct ieee802154_hw *hw, struct sk_buff *skb, u8 lqi)
 {
 	struct ieee802154_local *local = hw_to_local(hw);
+	struct ieee802154_mac_cb *cb = mac_cb_init(skb);
 
-	mac_cb(skb)->lqi = lqi;
+	cb->lqi = lqi;
 	skb->pkt_type = IEEE802154_RX_MSG;
 	skb_queue_tail(&local->skb_queue, skb);
 	tasklet_schedule(&local->tasklet);
diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 46ef1525b2e5..94c48122fdc3 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -1605,7 +1605,8 @@ static void ovs_dp_reset_user_features(struct sk_buff *skb,
 	if (IS_ERR(dp))
 		return;
 
-	WARN(dp->user_features, "Dropping previously announced user features\n");
+	pr_warn("%s: Dropping previously announced user features\n",
+		ovs_dp_name(dp));
 	dp->user_features = 0;
 }
 
diff --git a/net/tipc/topsrv.c b/net/tipc/topsrv.c
index 14fd05fd6107..d92ec92f0b71 100644
--- a/net/tipc/topsrv.c
+++ b/net/tipc/topsrv.c
@@ -450,12 +450,19 @@ static void tipc_conn_data_ready(struct sock *sk)
 static void tipc_topsrv_accept(struct work_struct *work)
 {
 	struct tipc_topsrv *srv = container_of(work, struct tipc_topsrv, awork);
-	struct socket *lsock = srv->listener;
-	struct socket *newsock;
+	struct socket *newsock, *lsock;
 	struct tipc_conn *con;
 	struct sock *newsk;
 	int ret;
 
+	spin_lock_bh(&srv->idr_lock);
+	if (!srv->listener) {
+		spin_unlock_bh(&srv->idr_lock);
+		return;
+	}
+	lsock = srv->listener;
+	spin_unlock_bh(&srv->idr_lock);
+
 	while (1) {
 		ret = kernel_accept(lsock, &newsock, O_NONBLOCK);
 		if (ret < 0)
@@ -489,7 +496,7 @@ static void tipc_topsrv_listener_data_ready(struct sock *sk)
 
 	read_lock_bh(&sk->sk_callback_lock);
 	srv = sk->sk_user_data;
-	if (srv->listener)
+	if (srv)
 		queue_work(srv->rcv_wq, &srv->awork);
 	read_unlock_bh(&sk->sk_callback_lock);
 }
@@ -699,8 +706,9 @@ static void tipc_topsrv_stop(struct net *net)
 	__module_get(lsock->sk->sk_prot_creator->owner);
 	srv->listener = NULL;
 	spin_unlock_bh(&srv->idr_lock);
-	sock_release(lsock);
+
 	tipc_topsrv_work_stop(srv);
+	sock_release(lsock);
 	idr_destroy(&srv->conn_idr);
 	kfree(srv);
 }
diff --git a/sound/aoa/soundbus/i2sbus/core.c b/sound/aoa/soundbus/i2sbus/core.c
index faf6b03131ee..51ed2f34b276 100644
--- a/sound/aoa/soundbus/i2sbus/core.c
+++ b/sound/aoa/soundbus/i2sbus/core.c
@@ -147,6 +147,7 @@ static int i2sbus_get_and_fixup_rsrc(struct device_node *np, int index,
 	return rc;
 }
 
+/* Returns 1 if added, 0 for otherwise; don't return a negative value! */
 /* FIXME: look at device node refcounting */
 static int i2sbus_add_dev(struct macio_dev *macio,
 			  struct i2sbus_control *control,
@@ -213,7 +214,7 @@ static int i2sbus_add_dev(struct macio_dev *macio,
 	 * either as the second one in that case is just a modem. */
 	if (!ok) {
 		kfree(dev);
-		return -ENODEV;
+		return 0;
 	}
 
 	mutex_init(&dev->lock);
@@ -302,6 +303,10 @@ static int i2sbus_add_dev(struct macio_dev *macio,
 
 	if (soundbus_add_one(&dev->sound)) {
 		printk(KERN_DEBUG "i2sbus: device registration error!\n");
+		if (dev->sound.ofdev.dev.kobj.state_initialized) {
+			soundbus_dev_put(&dev->sound);
+			return 0;
+		}
 		goto err;
 	}
 
diff --git a/sound/pci/ac97/ac97_codec.c b/sound/pci/ac97/ac97_codec.c
index cb60a07d39a8..ceead55f13ab 100644
--- a/sound/pci/ac97/ac97_codec.c
+++ b/sound/pci/ac97/ac97_codec.c
@@ -2009,6 +2009,7 @@ static int snd_ac97_dev_register(struct snd_device *device)
 	err = device_register(&ac97->dev);
 	if (err < 0) {
 		ac97_err(ac97, "Can't register ac97 bus\n");
+		put_device(&ac97->dev);
 		ac97->dev.bus = NULL;
 		return err;
 	}
diff --git a/sound/pci/au88x0/au88x0.h b/sound/pci/au88x0/au88x0.h
index 0aa7af049b1b..6cbb2bc4a048 100644
--- a/sound/pci/au88x0/au88x0.h
+++ b/sound/pci/au88x0/au88x0.h
@@ -141,7 +141,7 @@ struct snd_vortex {
 #ifndef CHIP_AU8810
 	stream_t dma_wt[NR_WT];
 	wt_voice_t wt_voice[NR_WT];	/* WT register cache. */
-	char mixwt[(NR_WT / NR_WTPB) * 6];	/* WT mixin objects */
+	s8 mixwt[(NR_WT / NR_WTPB) * 6];	/* WT mixin objects */
 #endif
 
 	/* Global resources */
@@ -235,8 +235,8 @@ static int vortex_alsafmt_aspfmt(snd_pcm_format_t alsafmt, vortex_t *v);
 static void vortex_connect_default(vortex_t * vortex, int en);
 static int vortex_adb_allocroute(vortex_t * vortex, int dma, int nr_ch,
 				 int dir, int type, int subdev);
-static char vortex_adb_checkinout(vortex_t * vortex, int resmap[], int out,
-				  int restype);
+static int vortex_adb_checkinout(vortex_t * vortex, int resmap[], int out,
+				 int restype);
 #ifndef CHIP_AU8810
 static int vortex_wt_allocroute(vortex_t * vortex, int dma, int nr_ch);
 static void vortex_wt_connect(vortex_t * vortex, int en);
diff --git a/sound/pci/au88x0/au88x0_core.c b/sound/pci/au88x0/au88x0_core.c
index 2ed5100b8cae..f217c02dfdfa 100644
--- a/sound/pci/au88x0/au88x0_core.c
+++ b/sound/pci/au88x0/au88x0_core.c
@@ -1998,7 +1998,7 @@ static const int resnum[VORTEX_RESOURCE_LAST] =
  out: Mean checkout if != 0. Else mean Checkin resource.
  restype: Indicates type of resource to be checked in or out.
 */
-static char
+static int
 vortex_adb_checkinout(vortex_t * vortex, int resmap[], int out, int restype)
 {
 	int i, qty = resnum[restype], resinuse = 0;
diff --git a/sound/pci/rme9652/hdsp.c b/sound/pci/rme9652/hdsp.c
index 3db641318d3a..82c72e6c1375 100644
--- a/sound/pci/rme9652/hdsp.c
+++ b/sound/pci/rme9652/hdsp.c
@@ -433,7 +433,7 @@ struct hdsp_midi {
     struct snd_rawmidi           *rmidi;
     struct snd_rawmidi_substream *input;
     struct snd_rawmidi_substream *output;
-    char                     istimer; /* timer in use */
+    signed char		     istimer; /* timer in use */
     struct timer_list	     timer;
     spinlock_t               lock;
     int			     pending;
@@ -480,7 +480,7 @@ struct hdsp {
 	pid_t                 playback_pid;
 	int                   running;
 	int                   system_sample_rate;
-	const char           *channel_map;
+	const signed char    *channel_map;
 	int                   dev;
 	int                   irq;
 	unsigned long         port;
@@ -502,7 +502,7 @@ struct hdsp {
    where the data for that channel can be read/written from/to.
 */
 
-static const char channel_map_df_ss[HDSP_MAX_CHANNELS] = {
+static const signed char channel_map_df_ss[HDSP_MAX_CHANNELS] = {
 	0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17,
 	18, 19, 20, 21, 22, 23, 24, 25
 };
@@ -517,7 +517,7 @@ static const char channel_map_mf_ss[HDSP_MAX_CHANNELS] = { /* Multiface */
 	-1, -1, -1, -1, -1, -1, -1, -1
 };
 
-static const char channel_map_ds[HDSP_MAX_CHANNELS] = {
+static const signed char channel_map_ds[HDSP_MAX_CHANNELS] = {
 	/* ADAT channels are remapped */
 	1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23,
 	/* channels 12 and 13 are S/PDIF */
@@ -526,7 +526,7 @@ static const char channel_map_ds[HDSP_MAX_CHANNELS] = {
 	-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1
 };
 
-static const char channel_map_H9632_ss[HDSP_MAX_CHANNELS] = {
+static const signed char channel_map_H9632_ss[HDSP_MAX_CHANNELS] = {
 	/* ADAT channels */
 	0, 1, 2, 3, 4, 5, 6, 7,
 	/* SPDIF */
@@ -540,7 +540,7 @@ static const char channel_map_H9632_ss[HDSP_MAX_CHANNELS] = {
 	-1, -1
 };
 
-static const char channel_map_H9632_ds[HDSP_MAX_CHANNELS] = {
+static const signed char channel_map_H9632_ds[HDSP_MAX_CHANNELS] = {
 	/* ADAT */
 	1, 3, 5, 7,
 	/* SPDIF */
@@ -554,7 +554,7 @@ static const char channel_map_H9632_ds[HDSP_MAX_CHANNELS] = {
 	-1, -1, -1, -1, -1, -1
 };
 
-static const char channel_map_H9632_qs[HDSP_MAX_CHANNELS] = {
+static const signed char channel_map_H9632_qs[HDSP_MAX_CHANNELS] = {
 	/* ADAT is disabled in this mode */
 	/* SPDIF */
 	8, 9,
@@ -3939,7 +3939,7 @@ static snd_pcm_uframes_t snd_hdsp_hw_pointer(struct snd_pcm_substream *substream
 	return hdsp_hw_pointer(hdsp);
 }
 
-static char *hdsp_channel_buffer_location(struct hdsp *hdsp,
+static signed char *hdsp_channel_buffer_location(struct hdsp *hdsp,
 					     int stream,
 					     int channel)
 
@@ -3964,7 +3964,7 @@ static int snd_hdsp_playback_copy(struct snd_pcm_substream *substream,
 				  void __user *src, unsigned long count)
 {
 	struct hdsp *hdsp = snd_pcm_substream_chip(substream);
-	char *channel_buf;
+	signed char *channel_buf;
 
 	if (snd_BUG_ON(pos + count > HDSP_CHANNEL_BUFFER_BYTES))
 		return -EINVAL;
@@ -3982,7 +3982,7 @@ static int snd_hdsp_playback_copy_kernel(struct snd_pcm_substream *substream,
 					 void *src, unsigned long count)
 {
 	struct hdsp *hdsp = snd_pcm_substream_chip(substream);
-	char *channel_buf;
+	signed char *channel_buf;
 
 	channel_buf = hdsp_channel_buffer_location(hdsp, substream->pstr->stream, channel);
 	if (snd_BUG_ON(!channel_buf))
@@ -3996,7 +3996,7 @@ static int snd_hdsp_capture_copy(struct snd_pcm_substream *substream,
 				 void __user *dst, unsigned long count)
 {
 	struct hdsp *hdsp = snd_pcm_substream_chip(substream);
-	char *channel_buf;
+	signed char *channel_buf;
 
 	if (snd_BUG_ON(pos + count > HDSP_CHANNEL_BUFFER_BYTES))
 		return -EINVAL;
@@ -4014,7 +4014,7 @@ static int snd_hdsp_capture_copy_kernel(struct snd_pcm_substream *substream,
 					void *dst, unsigned long count)
 {
 	struct hdsp *hdsp = snd_pcm_substream_chip(substream);
-	char *channel_buf;
+	signed char *channel_buf;
 
 	channel_buf = hdsp_channel_buffer_location(hdsp, substream->pstr->stream, channel);
 	if (snd_BUG_ON(!channel_buf))
@@ -4028,7 +4028,7 @@ static int snd_hdsp_hw_silence(struct snd_pcm_substream *substream,
 			       unsigned long count)
 {
 	struct hdsp *hdsp = snd_pcm_substream_chip(substream);
-	char *channel_buf;
+	signed char *channel_buf;
 
 	channel_buf = hdsp_channel_buffer_location (hdsp, substream->pstr->stream, channel);
 	if (snd_BUG_ON(!channel_buf))
diff --git a/sound/pci/rme9652/rme9652.c b/sound/pci/rme9652/rme9652.c
index 1d614fe89a6a..e7c320afefe8 100644
--- a/sound/pci/rme9652/rme9652.c
+++ b/sound/pci/rme9652/rme9652.c
@@ -230,7 +230,7 @@ struct snd_rme9652 {
 	int last_spdif_sample_rate;	/* so that we can catch externally ... */
 	int last_adat_sample_rate;	/* ... induced rate changes            */
 
-	const char *channel_map;
+	const signed char *channel_map;
 
 	struct snd_card *card;
 	struct snd_pcm *pcm;
@@ -247,12 +247,12 @@ struct snd_rme9652 {
    where the data for that channel can be read/written from/to.
 */
 
-static const char channel_map_9652_ss[26] = {
+static const signed char channel_map_9652_ss[26] = {
 	0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17,
 	18, 19, 20, 21, 22, 23, 24, 25
 };
 
-static const char channel_map_9636_ss[26] = {
+static const signed char channel_map_9636_ss[26] = {
 	0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 
 	/* channels 16 and 17 are S/PDIF */
 	24, 25,
@@ -260,7 +260,7 @@ static const char channel_map_9636_ss[26] = {
 	-1, -1, -1, -1, -1, -1, -1, -1
 };
 
-static const char channel_map_9652_ds[26] = {
+static const signed char channel_map_9652_ds[26] = {
 	/* ADAT channels are remapped */
 	1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23,
 	/* channels 12 and 13 are S/PDIF */
@@ -269,7 +269,7 @@ static const char channel_map_9652_ds[26] = {
 	-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1
 };
 
-static const char channel_map_9636_ds[26] = {
+static const signed char channel_map_9636_ds[26] = {
 	/* ADAT channels are remapped */
 	1, 3, 5, 7, 9, 11, 13, 15,
 	/* channels 8 and 9 are S/PDIF */
@@ -1819,7 +1819,7 @@ static snd_pcm_uframes_t snd_rme9652_hw_pointer(struct snd_pcm_substream *substr
 	return rme9652_hw_pointer(rme9652);
 }
 
-static char *rme9652_channel_buffer_location(struct snd_rme9652 *rme9652,
+static signed char *rme9652_channel_buffer_location(struct snd_rme9652 *rme9652,
 					     int stream,
 					     int channel)
 
@@ -1847,7 +1847,7 @@ static int snd_rme9652_playback_copy(struct snd_pcm_substream *substream,
 				     void __user *src, unsigned long count)
 {
 	struct snd_rme9652 *rme9652 = snd_pcm_substream_chip(substream);
-	char *channel_buf;
+	signed char *channel_buf;
 
 	if (snd_BUG_ON(pos + count > RME9652_CHANNEL_BUFFER_BYTES))
 		return -EINVAL;
@@ -1867,7 +1867,7 @@ static int snd_rme9652_playback_copy_kernel(struct snd_pcm_substream *substream,
 					    void *src, unsigned long count)
 {
 	struct snd_rme9652 *rme9652 = snd_pcm_substream_chip(substream);
-	char *channel_buf;
+	signed char *channel_buf;
 
 	channel_buf = rme9652_channel_buffer_location(rme9652,
 						      substream->pstr->stream,
@@ -1883,7 +1883,7 @@ static int snd_rme9652_capture_copy(struct snd_pcm_substream *substream,
 				    void __user *dst, unsigned long count)
 {
 	struct snd_rme9652 *rme9652 = snd_pcm_substream_chip(substream);
-	char *channel_buf;
+	signed char *channel_buf;
 
 	if (snd_BUG_ON(pos + count > RME9652_CHANNEL_BUFFER_BYTES))
 		return -EINVAL;
@@ -1903,7 +1903,7 @@ static int snd_rme9652_capture_copy_kernel(struct snd_pcm_substream *substream,
 					   void *dst, unsigned long count)
 {
 	struct snd_rme9652 *rme9652 = snd_pcm_substream_chip(substream);
-	char *channel_buf;
+	signed char *channel_buf;
 
 	channel_buf = rme9652_channel_buffer_location(rme9652,
 						      substream->pstr->stream,
@@ -1919,7 +1919,7 @@ static int snd_rme9652_hw_silence(struct snd_pcm_substream *substream,
 				  unsigned long count)
 {
 	struct snd_rme9652 *rme9652 = snd_pcm_substream_chip(substream);
-	char *channel_buf;
+	signed char *channel_buf;
 
 	channel_buf = rme9652_channel_buffer_location (rme9652,
 						       substream->pstr->stream,
diff --git a/sound/soc/qcom/lpass-cpu.c b/sound/soc/qcom/lpass-cpu.c
index 5e89d280e355..5e8d045c1a06 100644
--- a/sound/soc/qcom/lpass-cpu.c
+++ b/sound/soc/qcom/lpass-cpu.c
@@ -779,10 +779,20 @@ static bool lpass_hdmi_regmap_volatile(struct device *dev, unsigned int reg)
 		return true;
 	if (reg == LPASS_HDMI_TX_LEGACY_ADDR(v))
 		return true;
+	if (reg == LPASS_HDMI_TX_VBIT_CTL_ADDR(v))
+		return true;
+	if (reg == LPASS_HDMI_TX_PARITY_ADDR(v))
+		return true;
 
 	for (i = 0; i < v->hdmi_rdma_channels; ++i) {
 		if (reg == LPAIF_HDMI_RDMACURR_REG(v, i))
 			return true;
+		if (reg == LPASS_HDMI_TX_DMA_ADDR(v, i))
+			return true;
+		if (reg == LPASS_HDMI_TX_CH_LSB_ADDR(v, i))
+			return true;
+		if (reg == LPASS_HDMI_TX_CH_MSB_ADDR(v, i))
+			return true;
 	}
 	return false;
 }
diff --git a/sound/synth/emux/emux.c b/sound/synth/emux/emux.c
index 5ed8e36d2e04..a870759d179e 100644
--- a/sound/synth/emux/emux.c
+++ b/sound/synth/emux/emux.c
@@ -126,15 +126,10 @@ EXPORT_SYMBOL(snd_emux_register);
  */
 int snd_emux_free(struct snd_emux *emu)
 {
-	unsigned long flags;
-
 	if (! emu)
 		return -EINVAL;
 
-	spin_lock_irqsave(&emu->voice_lock, flags);
-	if (emu->timer_active)
-		del_timer(&emu->tlist);
-	spin_unlock_irqrestore(&emu->voice_lock, flags);
+	del_timer_sync(&emu->tlist);
 
 	snd_emux_proc_free(emu);
 	snd_emux_delete_virmidi(emu);
diff --git a/sound/usb/implicit.c b/sound/usb/implicit.c
index e1bf1b5da423..f3e8484b3d9c 100644
--- a/sound/usb/implicit.c
+++ b/sound/usb/implicit.c
@@ -47,6 +47,8 @@ struct snd_usb_implicit_fb_match {
 static const struct snd_usb_implicit_fb_match playback_implicit_fb_quirks[] = {
 	/* Fixed EP */
 	/* FIXME: check the availability of generic matching */
+	IMPLICIT_FB_FIXED_DEV(0x0763, 0x2030, 0x81, 3), /* M-Audio Fast Track C400 */
+	IMPLICIT_FB_FIXED_DEV(0x0763, 0x2031, 0x81, 3), /* M-Audio Fast Track C600 */
 	IMPLICIT_FB_FIXED_DEV(0x0763, 0x2080, 0x81, 2), /* M-Audio FastTrack Ultra */
 	IMPLICIT_FB_FIXED_DEV(0x0763, 0x2081, 0x81, 2), /* M-Audio FastTrack Ultra */
 	IMPLICIT_FB_FIXED_DEV(0x2466, 0x8010, 0x81, 2), /* Fractal Audio Axe-Fx III */
diff --git a/tools/iio/iio_utils.c b/tools/iio/iio_utils.c
index aadee6d34c74..8d35893b2fa8 100644
--- a/tools/iio/iio_utils.c
+++ b/tools/iio/iio_utils.c
@@ -547,6 +547,10 @@ static int calc_digits(int num)
 {
 	int count = 0;
 
+	/* It takes a digit to represent zero */
+	if (!num)
+		return 1;
+
 	while (num != 0) {
 		num /= 10;
 		count++;
diff --git a/tools/perf/pmu-events/arch/arm64/hisilicon/hip08/metrics.json b/tools/perf/pmu-events/arch/arm64/hisilicon/hip08/metrics.json
index dda8e59149d2..be23d3c89a79 100644
--- a/tools/perf/pmu-events/arch/arm64/hisilicon/hip08/metrics.json
+++ b/tools/perf/pmu-events/arch/arm64/hisilicon/hip08/metrics.json
@@ -112,21 +112,21 @@
         "MetricName": "indirect_branch"
     },
     {
-        "MetricExpr": "(armv8_pmuv3_0@event\\=0x1014@ + armv8_pmuv3_0@event\\=0x1018@) / BR_MIS_PRED",
+        "MetricExpr": "(armv8_pmuv3_0@event\\=0x1013@ + armv8_pmuv3_0@event\\=0x1016@) / BR_MIS_PRED",
         "PublicDescription": "Push branch L3 topdown metric",
         "BriefDescription": "Push branch L3 topdown metric",
         "MetricGroup": "TopDownL3",
         "MetricName": "push_branch"
     },
     {
-        "MetricExpr": "armv8_pmuv3_0@event\\=0x100c@ / BR_MIS_PRED",
+        "MetricExpr": "armv8_pmuv3_0@event\\=0x100d@ / BR_MIS_PRED",
         "PublicDescription": "Pop branch L3 topdown metric",
         "BriefDescription": "Pop branch L3 topdown metric",
         "MetricGroup": "TopDownL3",
         "MetricName": "pop_branch"
     },
     {
-        "MetricExpr": "(BR_MIS_PRED - armv8_pmuv3_0@event\\=0x1010@ - armv8_pmuv3_0@event\\=0x1014@ - armv8_pmuv3_0@event\\=0x1018@ - armv8_pmuv3_0@event\\=0x100c@) / BR_MIS_PRED",
+        "MetricExpr": "(BR_MIS_PRED - armv8_pmuv3_0@event\\=0x1010@ - armv8_pmuv3_0@event\\=0x1013@ - armv8_pmuv3_0@event\\=0x1016@ - armv8_pmuv3_0@event\\=0x100d@) / BR_MIS_PRED",
         "PublicDescription": "Other branch L3 topdown metric",
         "BriefDescription": "Other branch L3 topdown metric",
         "MetricGroup": "TopDownL3",
diff --git a/tools/perf/pmu-events/arch/powerpc/power10/nest_metrics.json b/tools/perf/pmu-events/arch/powerpc/power10/nest_metrics.json
index 8ba3e81c9808..fe050d44374b 100644
--- a/tools/perf/pmu-events/arch/powerpc/power10/nest_metrics.json
+++ b/tools/perf/pmu-events/arch/powerpc/power10/nest_metrics.json
@@ -1,13 +1,13 @@
 [
     {
       "MetricName": "VEC_GROUP_PUMP_RETRY_RATIO_P01",
-      "MetricExpr": "(hv_24x7@PM_PB_RTY_VG_PUMP01\\,chip\\=?@ / hv_24x7@PM_PB_VG_PUMP01\\,chip\\=?@) * 100",
+      "MetricExpr": "(hv_24x7@PM_PB_RTY_VG_PUMP01\\,chip\\=?@ / (1 + hv_24x7@PM_PB_VG_PUMP01\\,chip\\=?@)) * 100",
       "ScaleUnit": "1%",
       "AggregationMode": "PerChip"
     },
     {
       "MetricName": "VEC_GROUP_PUMP_RETRY_RATIO_P23",
-      "MetricExpr": "(hv_24x7@PM_PB_RTY_VG_PUMP23\\,chip\\=?@ / hv_24x7@PM_PB_VG_PUMP23\\,chip\\=?@) * 100",
+      "MetricExpr": "(hv_24x7@PM_PB_RTY_VG_PUMP23\\,chip\\=?@ / (1 + hv_24x7@PM_PB_VG_PUMP23\\,chip\\=?@)) * 100",
       "ScaleUnit": "1%",
       "AggregationMode": "PerChip"
     },
@@ -61,13 +61,13 @@
     },
     {
       "MetricName": "REMOTE_NODE_PUMPS_RETRIES_RATIO_P01",
-      "MetricExpr": "(hv_24x7@PM_PB_RTY_RNS_PUMP01\\,chip\\=?@ / hv_24x7@PM_PB_RNS_PUMP01\\,chip\\=?@) * 100",
+      "MetricExpr": "(hv_24x7@PM_PB_RTY_RNS_PUMP01\\,chip\\=?@ / (1 + hv_24x7@PM_PB_RNS_PUMP01\\,chip\\=?@)) * 100",
       "ScaleUnit": "1%",
       "AggregationMode": "PerChip"
     },
     {
       "MetricName": "REMOTE_NODE_PUMPS_RETRIES_RATIO_P23",
-      "MetricExpr": "(hv_24x7@PM_PB_RTY_RNS_PUMP23\\,chip\\=?@ / hv_24x7@PM_PB_RNS_PUMP23\\,chip\\=?@) * 100",
+      "MetricExpr": "(hv_24x7@PM_PB_RTY_RNS_PUMP23\\,chip\\=?@ / (1 + hv_24x7@PM_PB_RNS_PUMP23\\,chip\\=?@)) * 100",
       "ScaleUnit": "1%",
       "AggregationMode": "PerChip"
     },
@@ -151,193 +151,193 @@
     },
     {
       "MetricName": "XLINK0_OUT_TOTAL_UTILIZATION",
-      "MetricExpr": "((hv_24x7@PM_XLINK0_OUT_ODD_TOTAL_UTIL\\,chip\\=?@ + hv_24x7@PM_XLINK0_OUT_EVEN_TOTAL_UTIL\\,chip\\=?@) / (hv_24x7@PM_XLINK0_OUT_ODD_AVLBL_CYCLES\\,chip\\=?@ + hv_24x7@PM_XLINK0_OUT_EVEN_AVLBL_CYCLES\\,chip\\=?@)) * 100",
+      "MetricExpr": "((hv_24x7@PM_XLINK0_OUT_ODD_TOTAL_UTIL\\,chip\\=?@ + hv_24x7@PM_XLINK0_OUT_EVEN_TOTAL_UTIL\\,chip\\=?@) / (1 + hv_24x7@PM_XLINK0_OUT_ODD_AVLBL_CYCLES\\,chip\\=?@ + hv_24x7@PM_XLINK0_OUT_EVEN_AVLBL_CYCLES\\,chip\\=?@)) * 100",
       "ScaleUnit": "1%",
       "AggregationMode": "PerChip"
     },
     {
       "MetricName": "XLINK1_OUT_TOTAL_UTILIZATION",
-      "MetricExpr": "((hv_24x7@PM_XLINK1_OUT_ODD_TOTAL_UTIL\\,chip\\=?@ + hv_24x7@PM_XLINK1_OUT_EVEN_TOTAL_UTIL\\,chip\\=?@) / (hv_24x7@PM_XLINK1_OUT_ODD_AVLBL_CYCLES\\,chip\\=?@ + hv_24x7@PM_XLINK1_OUT_EVEN_AVLBL_CYCLES\\,chip\\=?@)) * 100",
+      "MetricExpr": "((hv_24x7@PM_XLINK1_OUT_ODD_TOTAL_UTIL\\,chip\\=?@ + hv_24x7@PM_XLINK1_OUT_EVEN_TOTAL_UTIL\\,chip\\=?@) / (1 + hv_24x7@PM_XLINK1_OUT_ODD_AVLBL_CYCLES\\,chip\\=?@ + hv_24x7@PM_XLINK1_OUT_EVEN_AVLBL_CYCLES\\,chip\\=?@)) * 100",
       "ScaleUnit": "1%",
       "AggregationMode": "PerChip"
     },
     {
       "MetricName": "XLINK2_OUT_TOTAL_UTILIZATION",
-      "MetricExpr": "((hv_24x7@PM_XLINK2_OUT_ODD_TOTAL_UTIL\\,chip\\=?@ + hv_24x7@PM_XLINK2_OUT_EVEN_TOTAL_UTIL\\,chip\\=?@) / (hv_24x7@PM_XLINK2_OUT_ODD_AVLBL_CYCLES\\,chip\\=?@ + hv_24x7@PM_XLINK2_OUT_EVEN_AVLBL_CYCLES\\,chip\\=?@)) * 100",
+      "MetricExpr": "((hv_24x7@PM_XLINK2_OUT_ODD_TOTAL_UTIL\\,chip\\=?@ + hv_24x7@PM_XLINK2_OUT_EVEN_TOTAL_UTIL\\,chip\\=?@) / (1 + hv_24x7@PM_XLINK2_OUT_ODD_AVLBL_CYCLES\\,chip\\=?@ + hv_24x7@PM_XLINK2_OUT_EVEN_AVLBL_CYCLES\\,chip\\=?@)) * 100",
       "ScaleUnit": "1%",
       "AggregationMode": "PerChip"
     },
     {
       "MetricName": "XLINK3_OUT_TOTAL_UTILIZATION",
-      "MetricExpr": "((hv_24x7@PM_XLINK3_OUT_ODD_TOTAL_UTIL\\,chip\\=?@ + hv_24x7@PM_XLINK3_OUT_EVEN_TOTAL_UTIL\\,chip\\=?@) / (hv_24x7@PM_XLINK3_OUT_ODD_AVLBL_CYCLES\\,chip\\=?@ + hv_24x7@PM_XLINK3_OUT_EVEN_AVLBL_CYCLES\\,chip\\=?@)) * 100",
+      "MetricExpr": "((hv_24x7@PM_XLINK3_OUT_ODD_TOTAL_UTIL\\,chip\\=?@ + hv_24x7@PM_XLINK3_OUT_EVEN_TOTAL_UTIL\\,chip\\=?@) / (1 + hv_24x7@PM_XLINK3_OUT_ODD_AVLBL_CYCLES\\,chip\\=?@ + hv_24x7@PM_XLINK3_OUT_EVEN_AVLBL_CYCLES\\,chip\\=?@)) * 100",
       "ScaleUnit": "1%",
       "AggregationMode": "PerChip"
     },
     {
       "MetricName": "XLINK4_OUT_TOTAL_UTILIZATION",
-      "MetricExpr": "((hv_24x7@PM_XLINK4_OUT_ODD_TOTAL_UTIL\\,chip\\=?@ + hv_24x7@PM_XLINK4_OUT_EVEN_TOTAL_UTIL\\,chip\\=?@) / (hv_24x7@PM_XLINK4_OUT_ODD_AVLBL_CYCLES\\,chip\\=?@ + hv_24x7@PM_XLINK4_OUT_EVEN_AVLBL_CYCLES\\,chip\\=?@)) * 100",
+      "MetricExpr": "((hv_24x7@PM_XLINK4_OUT_ODD_TOTAL_UTIL\\,chip\\=?@ + hv_24x7@PM_XLINK4_OUT_EVEN_TOTAL_UTIL\\,chip\\=?@) / (1 + hv_24x7@PM_XLINK4_OUT_ODD_AVLBL_CYCLES\\,chip\\=?@ + hv_24x7@PM_XLINK4_OUT_EVEN_AVLBL_CYCLES\\,chip\\=?@)) * 100",
       "ScaleUnit": "1%",
       "AggregationMode": "PerChip"
     },
     {
       "MetricName": "XLINK5_OUT_TOTAL_UTILIZATION",
-      "MetricExpr": "((hv_24x7@PM_XLINK5_OUT_ODD_TOTAL_UTIL\\,chip\\=?@ + hv_24x7@PM_XLINK5_OUT_EVEN_TOTAL_UTIL\\,chip\\=?@) / (hv_24x7@PM_XLINK5_OUT_ODD_AVLBL_CYCLES\\,chip\\=?@ + hv_24x7@PM_XLINK5_OUT_EVEN_AVLBL_CYCLES\\,chip\\=?@)) * 100",
+      "MetricExpr": "((hv_24x7@PM_XLINK5_OUT_ODD_TOTAL_UTIL\\,chip\\=?@ + hv_24x7@PM_XLINK5_OUT_EVEN_TOTAL_UTIL\\,chip\\=?@) / (1 + hv_24x7@PM_XLINK5_OUT_ODD_AVLBL_CYCLES\\,chip\\=?@ + hv_24x7@PM_XLINK5_OUT_EVEN_AVLBL_CYCLES\\,chip\\=?@)) * 100",
       "ScaleUnit": "1%",
       "AggregationMode": "PerChip"
     },
     {
       "MetricName": "XLINK6_OUT_TOTAL_UTILIZATION",
-      "MetricExpr": "((hv_24x7@PM_XLINK6_OUT_ODD_TOTAL_UTIL\\,chip\\=?@ + hv_24x7@PM_XLINK6_OUT_EVEN_TOTAL_UTIL\\,chip\\=?@) / (hv_24x7@PM_XLINK6_OUT_ODD_AVLBL_CYCLES\\,chip\\=?@ + hv_24x7@PM_XLINK6_OUT_EVEN_AVLBL_CYCLES\\,chip\\=?@)) * 100",
+      "MetricExpr": "((hv_24x7@PM_XLINK6_OUT_ODD_TOTAL_UTIL\\,chip\\=?@ + hv_24x7@PM_XLINK6_OUT_EVEN_TOTAL_UTIL\\,chip\\=?@) / (1 + hv_24x7@PM_XLINK6_OUT_ODD_AVLBL_CYCLES\\,chip\\=?@ + hv_24x7@PM_XLINK6_OUT_EVEN_AVLBL_CYCLES\\,chip\\=?@)) * 100",
       "ScaleUnit": "1%",
       "AggregationMode": "PerChip"
     },
     {
       "MetricName": "XLINK7_OUT_TOTAL_UTILIZATION",
-      "MetricExpr": "((hv_24x7@PM_XLINK7_OUT_ODD_TOTAL_UTIL\\,chip\\=?@ + hv_24x7@PM_XLINK7_OUT_EVEN_TOTAL_UTIL\\,chip\\=?@) / (hv_24x7@PM_XLINK7_OUT_ODD_AVLBL_CYCLES\\,chip\\=?@ + hv_24x7@PM_XLINK7_OUT_EVEN_AVLBL_CYCLES\\,chip\\=?@)) * 100",
+      "MetricExpr": "((hv_24x7@PM_XLINK7_OUT_ODD_TOTAL_UTIL\\,chip\\=?@ + hv_24x7@PM_XLINK7_OUT_EVEN_TOTAL_UTIL\\,chip\\=?@) / (1 + hv_24x7@PM_XLINK7_OUT_ODD_AVLBL_CYCLES\\,chip\\=?@ + hv_24x7@PM_XLINK7_OUT_EVEN_AVLBL_CYCLES\\,chip\\=?@)) * 100",
       "ScaleUnit": "1%",
       "AggregationMode": "PerChip"
     },
     {
       "MetricName": "XLINK0_OUT_DATA_UTILIZATION",
-      "MetricExpr": "((hv_24x7@PM_XLINK0_OUT_ODD_DATA\\,chip\\=?@ + hv_24x7@PM_XLINK0_OUT_EVEN_DATA\\,chip\\=?@) / (hv_24x7@PM_XLINK0_OUT_ODD_AVLBL_CYCLES\\,chip\\=?@ + hv_24x7@PM_XLINK0_OUT_EVEN_AVLBL_CYCLES\\,chip\\=?@)) * 100",
+      "MetricExpr": "((hv_24x7@PM_XLINK0_OUT_ODD_DATA\\,chip\\=?@ + hv_24x7@PM_XLINK0_OUT_EVEN_DATA\\,chip\\=?@) / (1 + hv_24x7@PM_XLINK0_OUT_ODD_AVLBL_CYCLES\\,chip\\=?@ + hv_24x7@PM_XLINK0_OUT_EVEN_AVLBL_CYCLES\\,chip\\=?@)) * 100",
       "ScaleUnit": "1.063%",
       "AggregationMode": "PerChip"
     },
     {
       "MetricName": "XLINK1_OUT_DATA_UTILIZATION",
-      "MetricExpr": "((hv_24x7@PM_XLINK1_OUT_ODD_DATA\\,chip\\=?@ + hv_24x7@PM_XLINK1_OUT_EVEN_DATA\\,chip\\=?@) / (hv_24x7@PM_XLINK1_OUT_ODD_AVLBL_CYCLES\\,chip\\=?@ + hv_24x7@PM_XLINK1_OUT_EVEN_AVLBL_CYCLES\\,chip\\=?@)) * 100",
+      "MetricExpr": "((hv_24x7@PM_XLINK1_OUT_ODD_DATA\\,chip\\=?@ + hv_24x7@PM_XLINK1_OUT_EVEN_DATA\\,chip\\=?@) / (1 + hv_24x7@PM_XLINK1_OUT_ODD_AVLBL_CYCLES\\,chip\\=?@ + hv_24x7@PM_XLINK1_OUT_EVEN_AVLBL_CYCLES\\,chip\\=?@)) * 100",
       "ScaleUnit": "1.063%",
       "AggregationMode": "PerChip"
     },
     {
       "MetricName": "XLINK2_OUT_DATA_UTILIZATION",
-      "MetricExpr": "((hv_24x7@PM_XLINK2_OUT_ODD_DATA\\,chip\\=?@ + hv_24x7@PM_XLINK2_OUT_EVEN_DATA\\,chip\\=?@) / (hv_24x7@PM_XLINK2_OUT_ODD_AVLBL_CYCLES\\,chip\\=?@ + hv_24x7@PM_XLINK2_OUT_EVEN_AVLBL_CYCLES\\,chip\\=?@)) * 100",
+      "MetricExpr": "((hv_24x7@PM_XLINK2_OUT_ODD_DATA\\,chip\\=?@ + hv_24x7@PM_XLINK2_OUT_EVEN_DATA\\,chip\\=?@) / (1 + hv_24x7@PM_XLINK2_OUT_ODD_AVLBL_CYCLES\\,chip\\=?@ + hv_24x7@PM_XLINK2_OUT_EVEN_AVLBL_CYCLES\\,chip\\=?@)) * 100",
       "ScaleUnit": "1.063%",
       "AggregationMode": "PerChip"
     },
     {
       "MetricName": "XLINK3_OUT_DATA_UTILIZATION",
-      "MetricExpr": "((hv_24x7@PM_XLINK3_OUT_ODD_DATA\\,chip\\=?@ + hv_24x7@PM_XLINK3_OUT_EVEN_DATA\\,chip\\=?@) / (hv_24x7@PM_XLINK3_OUT_ODD_AVLBL_CYCLES\\,chip\\=?@ + hv_24x7@PM_XLINK3_OUT_EVEN_AVLBL_CYCLES\\,chip\\=?@)) * 100",
+      "MetricExpr": "((hv_24x7@PM_XLINK3_OUT_ODD_DATA\\,chip\\=?@ + hv_24x7@PM_XLINK3_OUT_EVEN_DATA\\,chip\\=?@) / (1 + hv_24x7@PM_XLINK3_OUT_ODD_AVLBL_CYCLES\\,chip\\=?@ + hv_24x7@PM_XLINK3_OUT_EVEN_AVLBL_CYCLES\\,chip\\=?@)) * 100",
       "ScaleUnit": "1.063%",
       "AggregationMode": "PerChip"
     },
     {
       "MetricName": "XLINK4_OUT_DATA_UTILIZATION",
-      "MetricExpr": "((hv_24x7@PM_XLINK4_OUT_ODD_DATA\\,chip\\=?@ + hv_24x7@PM_XLINK4_OUT_EVEN_DATA\\,chip\\=?@) / (hv_24x7@PM_XLINK4_OUT_ODD_AVLBL_CYCLES\\,chip\\=?@ + hv_24x7@PM_XLINK4_OUT_EVEN_AVLBL_CYCLES\\,chip\\=?@)) * 100",
+      "MetricExpr": "((hv_24x7@PM_XLINK4_OUT_ODD_DATA\\,chip\\=?@ + hv_24x7@PM_XLINK4_OUT_EVEN_DATA\\,chip\\=?@) / (1 + hv_24x7@PM_XLINK4_OUT_ODD_AVLBL_CYCLES\\,chip\\=?@ + hv_24x7@PM_XLINK4_OUT_EVEN_AVLBL_CYCLES\\,chip\\=?@)) * 100",
       "ScaleUnit": "1.063%",
       "AggregationMode": "PerChip"
     },
     {
       "MetricName": "XLINK5_OUT_DATA_UTILIZATION",
-      "MetricExpr": "((hv_24x7@PM_XLINK5_OUT_ODD_DATA\\,chip\\=?@ + hv_24x7@PM_XLINK5_OUT_EVEN_DATA\\,chip\\=?@) / (hv_24x7@PM_XLINK5_OUT_ODD_AVLBL_CYCLES\\,chip\\=?@ + hv_24x7@PM_XLINK5_OUT_EVEN_AVLBL_CYCLES\\,chip\\=?@)) * 100",
+      "MetricExpr": "((hv_24x7@PM_XLINK5_OUT_ODD_DATA\\,chip\\=?@ + hv_24x7@PM_XLINK5_OUT_EVEN_DATA\\,chip\\=?@) / (1 + hv_24x7@PM_XLINK5_OUT_ODD_AVLBL_CYCLES\\,chip\\=?@ + hv_24x7@PM_XLINK5_OUT_EVEN_AVLBL_CYCLES\\,chip\\=?@)) * 100",
       "ScaleUnit": "1.063%",
       "AggregationMode": "PerChip"
     },
     {
       "MetricName": "XLINK6_OUT_DATA_UTILIZATION",
-      "MetricExpr": "((hv_24x7@PM_XLINK6_OUT_ODD_DATA\\,chip\\=?@ + hv_24x7@PM_XLINK6_OUT_EVEN_DATA\\,chip\\=?@) / (hv_24x7@PM_XLINK6_OUT_ODD_AVLBL_CYCLES\\,chip\\=?@ + hv_24x7@PM_XLINK6_OUT_EVEN_AVLBL_CYCLES\\,chip\\=?@)) * 100",
+      "MetricExpr": "((hv_24x7@PM_XLINK6_OUT_ODD_DATA\\,chip\\=?@ + hv_24x7@PM_XLINK6_OUT_EVEN_DATA\\,chip\\=?@) / (1 + hv_24x7@PM_XLINK6_OUT_ODD_AVLBL_CYCLES\\,chip\\=?@ + hv_24x7@PM_XLINK6_OUT_EVEN_AVLBL_CYCLES\\,chip\\=?@)) * 100",
       "ScaleUnit": "1.063%",
       "AggregationMode": "PerChip"
     },
     {
       "MetricName": "XLINK7_OUT_DATA_UTILIZATION",
-      "MetricExpr": "((hv_24x7@PM_XLINK7_OUT_ODD_DATA\\,chip\\=?@ + hv_24x7@PM_XLINK7_OUT_EVEN_DATA\\,chip\\=?@) / (hv_24x7@PM_XLINK7_OUT_ODD_AVLBL_CYCLES\\,chip\\=?@ + hv_24x7@PM_XLINK7_OUT_EVEN_AVLBL_CYCLES\\,chip\\=?@)) * 100",
+      "MetricExpr": "((hv_24x7@PM_XLINK7_OUT_ODD_DATA\\,chip\\=?@ + hv_24x7@PM_XLINK7_OUT_EVEN_DATA\\,chip\\=?@) / (1 + hv_24x7@PM_XLINK7_OUT_ODD_AVLBL_CYCLES\\,chip\\=?@ + hv_24x7@PM_XLINK7_OUT_EVEN_AVLBL_CYCLES\\,chip\\=?@)) * 100",
       "ScaleUnit": "1.063%",
       "AggregationMode": "PerChip"
     },
     {
       "MetricName": "ALINK0_OUT_TOTAL_UTILIZATION",
-      "MetricExpr": "((hv_24x7@PM_ALINK0_OUT_ODD_TOTAL_UTIL\\,chip\\=?@ + hv_24x7@PM_ALINK0_OUT_EVEN_TOTAL_UTIL\\,chip\\=?@) / (hv_24x7@PM_ALINK0_OUT_ODD_AVLBL_CYCLES\\,chip\\=?@ + hv_24x7@PM_ALINK0_OUT_EVEN_AVLBL_CYCLES\\,chip\\=?@)) * 100",
+      "MetricExpr": "((hv_24x7@PM_ALINK0_OUT_ODD_TOTAL_UTIL\\,chip\\=?@ + hv_24x7@PM_ALINK0_OUT_EVEN_TOTAL_UTIL\\,chip\\=?@) / (1 + hv_24x7@PM_ALINK0_OUT_ODD_AVLBL_CYCLES\\,chip\\=?@ + hv_24x7@PM_ALINK0_OUT_EVEN_AVLBL_CYCLES\\,chip\\=?@)) * 100",
       "ScaleUnit": "1%",
       "AggregationMode": "PerChip"
     },
     {
       "MetricName": "ALINK1_OUT_TOTAL_UTILIZATION",
-      "MetricExpr": "((hv_24x7@PM_ALINK1_OUT_ODD_TOTAL_UTIL\\,chip\\=?@ + hv_24x7@PM_ALINK1_OUT_EVEN_TOTAL_UTIL\\,chip\\=?@) / (hv_24x7@PM_ALINK1_OUT_ODD_AVLBL_CYCLES\\,chip\\=?@ + hv_24x7@PM_ALINK1_OUT_EVEN_AVLBL_CYCLES\\,chip\\=?@)) * 100",
+      "MetricExpr": "((hv_24x7@PM_ALINK1_OUT_ODD_TOTAL_UTIL\\,chip\\=?@ + hv_24x7@PM_ALINK1_OUT_EVEN_TOTAL_UTIL\\,chip\\=?@) / (1 + hv_24x7@PM_ALINK1_OUT_ODD_AVLBL_CYCLES\\,chip\\=?@ + hv_24x7@PM_ALINK1_OUT_EVEN_AVLBL_CYCLES\\,chip\\=?@)) * 100",
       "ScaleUnit": "1%",
       "AggregationMode": "PerChip"
     },
     {
       "MetricName": "ALINK2_OUT_TOTAL_UTILIZATION",
-      "MetricExpr": "((hv_24x7@PM_ALINK2_OUT_ODD_TOTAL_UTIL\\,chip\\=?@ + hv_24x7@PM_ALINK2_OUT_EVEN_TOTAL_UTIL\\,chip\\=?@) / (hv_24x7@PM_ALINK2_OUT_ODD_AVLBL_CYCLES\\,chip\\=?@ + hv_24x7@PM_ALINK2_OUT_EVEN_AVLBL_CYCLES\\,chip\\=?@)) * 100",
+      "MetricExpr": "((hv_24x7@PM_ALINK2_OUT_ODD_TOTAL_UTIL\\,chip\\=?@ + hv_24x7@PM_ALINK2_OUT_EVEN_TOTAL_UTIL\\,chip\\=?@) / (1 + hv_24x7@PM_ALINK2_OUT_ODD_AVLBL_CYCLES\\,chip\\=?@ + hv_24x7@PM_ALINK2_OUT_EVEN_AVLBL_CYCLES\\,chip\\=?@)) * 100",
       "ScaleUnit": "1%",
       "AggregationMode": "PerChip"
     },
     {
       "MetricName": "ALINK3_OUT_TOTAL_UTILIZATION",
-      "MetricExpr": "((hv_24x7@PM_ALINK3_OUT_ODD_TOTAL_UTIL\\,chip\\=?@ + hv_24x7@PM_ALINK3_OUT_EVEN_TOTAL_UTIL\\,chip\\=?@) / (hv_24x7@PM_ALINK3_OUT_ODD_AVLBL_CYCLES\\,chip\\=?@ + hv_24x7@PM_ALINK3_OUT_EVEN_AVLBL_CYCLES\\,chip\\=?@)) * 100",
+      "MetricExpr": "((hv_24x7@PM_ALINK3_OUT_ODD_TOTAL_UTIL\\,chip\\=?@ + hv_24x7@PM_ALINK3_OUT_EVEN_TOTAL_UTIL\\,chip\\=?@) / (1 + hv_24x7@PM_ALINK3_OUT_ODD_AVLBL_CYCLES\\,chip\\=?@ + hv_24x7@PM_ALINK3_OUT_EVEN_AVLBL_CYCLES\\,chip\\=?@)) * 100",
       "ScaleUnit": "1%",
       "AggregationMode": "PerChip"
     },
     {
       "MetricName": "ALINK4_OUT_TOTAL_UTILIZATION",
-      "MetricExpr": "((hv_24x7@PM_ALINK4_OUT_ODD_TOTAL_UTIL\\,chip\\=?@ + hv_24x7@PM_ALINK4_OUT_EVEN_TOTAL_UTIL\\,chip\\=?@) / (hv_24x7@PM_ALINK4_OUT_ODD_AVLBL_CYCLES\\,chip\\=?@ + hv_24x7@PM_ALINK4_OUT_EVEN_AVLBL_CYCLES\\,chip\\=?@)) * 100",
+      "MetricExpr": "((hv_24x7@PM_ALINK4_OUT_ODD_TOTAL_UTIL\\,chip\\=?@ + hv_24x7@PM_ALINK4_OUT_EVEN_TOTAL_UTIL\\,chip\\=?@) / (1 + hv_24x7@PM_ALINK4_OUT_ODD_AVLBL_CYCLES\\,chip\\=?@ + hv_24x7@PM_ALINK4_OUT_EVEN_AVLBL_CYCLES\\,chip\\=?@)) * 100",
       "ScaleUnit": "1%",
       "AggregationMode": "PerChip"
     },
     {
       "MetricName": "ALINK5_OUT_TOTAL_UTILIZATION",
-      "MetricExpr": "((hv_24x7@PM_ALINK5_OUT_ODD_TOTAL_UTIL\\,chip\\=?@ + hv_24x7@PM_ALINK5_OUT_EVEN_TOTAL_UTIL\\,chip\\=?@) / (hv_24x7@PM_ALINK5_OUT_ODD_AVLBL_CYCLES\\,chip\\=?@ + hv_24x7@PM_ALINK5_OUT_EVEN_AVLBL_CYCLES\\,chip\\=?@)) * 100",
+      "MetricExpr": "((hv_24x7@PM_ALINK5_OUT_ODD_TOTAL_UTIL\\,chip\\=?@ + hv_24x7@PM_ALINK5_OUT_EVEN_TOTAL_UTIL\\,chip\\=?@) / (1 + hv_24x7@PM_ALINK5_OUT_ODD_AVLBL_CYCLES\\,chip\\=?@ + hv_24x7@PM_ALINK5_OUT_EVEN_AVLBL_CYCLES\\,chip\\=?@)) * 100",
       "ScaleUnit": "1%",
       "AggregationMode": "PerChip"
     },
     {
       "MetricName": "ALINK6_OUT_TOTAL_UTILIZATION",
-      "MetricExpr": "((hv_24x7@PM_ALINK6_OUT_ODD_TOTAL_UTIL\\,chip\\=?@ + hv_24x7@PM_ALINK6_OUT_EVEN_TOTAL_UTIL\\,chip\\=?@) / (hv_24x7@PM_ALINK6_OUT_ODD_AVLBL_CYCLES\\,chip\\=?@ + hv_24x7@PM_ALINK6_OUT_EVEN_AVLBL_CYCLES\\,chip\\=?@)) * 100",
+      "MetricExpr": "((hv_24x7@PM_ALINK6_OUT_ODD_TOTAL_UTIL\\,chip\\=?@ + hv_24x7@PM_ALINK6_OUT_EVEN_TOTAL_UTIL\\,chip\\=?@) / (1 + hv_24x7@PM_ALINK6_OUT_ODD_AVLBL_CYCLES\\,chip\\=?@ + hv_24x7@PM_ALINK6_OUT_EVEN_AVLBL_CYCLES\\,chip\\=?@)) * 100",
       "ScaleUnit": "1%",
       "AggregationMode": "PerChip"
     },
     {
       "MetricName": "ALINK7_OUT_TOTAL_UTILIZATION",
-      "MetricExpr": "((hv_24x7@PM_ALINK7_OUT_ODD_TOTAL_UTIL\\,chip\\=?@ + hv_24x7@PM_ALINK7_OUT_EVEN_TOTAL_UTIL\\,chip\\=?@) / (hv_24x7@PM_ALINK7_OUT_ODD_AVLBL_CYCLES\\,chip\\=?@ + hv_24x7@PM_ALINK7_OUT_EVEN_AVLBL_CYCLES\\,chip\\=?@)) * 100",
+      "MetricExpr": "((hv_24x7@PM_ALINK7_OUT_ODD_TOTAL_UTIL\\,chip\\=?@ + hv_24x7@PM_ALINK7_OUT_EVEN_TOTAL_UTIL\\,chip\\=?@) / (1 + hv_24x7@PM_ALINK7_OUT_ODD_AVLBL_CYCLES\\,chip\\=?@ + hv_24x7@PM_ALINK7_OUT_EVEN_AVLBL_CYCLES\\,chip\\=?@)) * 100",
       "ScaleUnit": "1%",
       "AggregationMode": "PerChip"
     },
     {
       "MetricName": "ALINK0_OUT_DATA_UTILIZATION",
-      "MetricExpr": "((hv_24x7@PM_ALINK0_OUT_ODD_DATA\\,chip\\=?@ + hv_24x7@PM_ALINK0_OUT_EVEN_DATA\\,chip\\=?@) / (hv_24x7@PM_ALINK0_OUT_ODD_AVLBL_CYCLES\\,chip\\=?@ + hv_24x7@PM_ALINK0_OUT_EVEN_AVLBL_CYCLES\\,chip\\=?@)) * 100",
+      "MetricExpr": "((hv_24x7@PM_ALINK0_OUT_ODD_DATA\\,chip\\=?@ + hv_24x7@PM_ALINK0_OUT_EVEN_DATA\\,chip\\=?@) / (1 + hv_24x7@PM_ALINK0_OUT_ODD_AVLBL_CYCLES\\,chip\\=?@ + hv_24x7@PM_ALINK0_OUT_EVEN_AVLBL_CYCLES\\,chip\\=?@)) * 100",
       "ScaleUnit": "1.063%",
       "AggregationMode": "PerChip"
     },
     {
       "MetricName": "ALINK1_OUT_DATA_UTILIZATION",
-      "MetricExpr": "((hv_24x7@PM_ALINK1_OUT_ODD_DATA\\,chip\\=?@ + hv_24x7@PM_ALINK1_OUT_EVEN_DATA\\,chip\\=?@) / (hv_24x7@PM_ALINK1_OUT_ODD_AVLBL_CYCLES\\,chip\\=?@ + hv_24x7@PM_ALINK1_OUT_EVEN_AVLBL_CYCLES\\,chip\\=?@)) * 100",
+      "MetricExpr": "((hv_24x7@PM_ALINK1_OUT_ODD_DATA\\,chip\\=?@ + hv_24x7@PM_ALINK1_OUT_EVEN_DATA\\,chip\\=?@) / (1 + hv_24x7@PM_ALINK1_OUT_ODD_AVLBL_CYCLES\\,chip\\=?@ + hv_24x7@PM_ALINK1_OUT_EVEN_AVLBL_CYCLES\\,chip\\=?@)) * 100",
       "ScaleUnit": "1.063%",
       "AggregationMode": "PerChip"
     },
     {
       "MetricName": "ALINK2_OUT_DATA_UTILIZATION",
-      "MetricExpr": "((hv_24x7@PM_ALINK2_OUT_ODD_DATA\\,chip\\=?@ + hv_24x7@PM_ALINK2_OUT_EVEN_DATA\\,chip\\=?@) / (hv_24x7@PM_ALINK2_OUT_ODD_AVLBL_CYCLES\\,chip\\=?@ + hv_24x7@PM_ALINK2_OUT_EVEN_AVLBL_CYCLES\\,chip\\=?@)) * 100",
+      "MetricExpr": "((hv_24x7@PM_ALINK2_OUT_ODD_DATA\\,chip\\=?@ + hv_24x7@PM_ALINK2_OUT_EVEN_DATA\\,chip\\=?@) / (1 + hv_24x7@PM_ALINK2_OUT_ODD_AVLBL_CYCLES\\,chip\\=?@ + hv_24x7@PM_ALINK2_OUT_EVEN_AVLBL_CYCLES\\,chip\\=?@)) * 100",
       "ScaleUnit": "1.063%",
       "AggregationMode": "PerChip"
     },
     {
       "MetricName": "ALINK3_OUT_DATA_UTILIZATION",
-      "MetricExpr": "((hv_24x7@PM_ALINK3_OUT_ODD_DATA\\,chip\\=?@ + hv_24x7@PM_ALINK3_OUT_EVEN_DATA\\,chip\\=?@) / (hv_24x7@PM_ALINK3_OUT_ODD_AVLBL_CYCLES\\,chip\\=?@ + hv_24x7@PM_ALINK3_OUT_EVEN_AVLBL_CYCLES\\,chip\\=?@)) * 100",
+      "MetricExpr": "((hv_24x7@PM_ALINK3_OUT_ODD_DATA\\,chip\\=?@ + hv_24x7@PM_ALINK3_OUT_EVEN_DATA\\,chip\\=?@) / (1 + hv_24x7@PM_ALINK3_OUT_ODD_AVLBL_CYCLES\\,chip\\=?@ + hv_24x7@PM_ALINK3_OUT_EVEN_AVLBL_CYCLES\\,chip\\=?@)) * 100",
       "ScaleUnit": "1.063%",
       "AggregationMode": "PerChip"
     },
     {
       "MetricName": "ALINK4_OUT_DATA_UTILIZATION",
-      "MetricExpr": "((hv_24x7@PM_ALINK4_OUT_ODD_DATA\\,chip\\=?@ + hv_24x7@PM_ALINK4_OUT_EVEN_DATA\\,chip\\=?@) / (hv_24x7@PM_ALINK4_OUT_ODD_AVLBL_CYCLES\\,chip\\=?@ + hv_24x7@PM_ALINK4_OUT_EVEN_AVLBL_CYCLES\\,chip\\=?@)) * 100",
+      "MetricExpr": "((hv_24x7@PM_ALINK4_OUT_ODD_DATA\\,chip\\=?@ + hv_24x7@PM_ALINK4_OUT_EVEN_DATA\\,chip\\=?@) / (1 + hv_24x7@PM_ALINK4_OUT_ODD_AVLBL_CYCLES\\,chip\\=?@ + hv_24x7@PM_ALINK4_OUT_EVEN_AVLBL_CYCLES\\,chip\\=?@)) * 100",
       "ScaleUnit": "1.063%",
       "AggregationMode": "PerChip"
     },
     {
       "MetricName": "ALINK5_OUT_DATA_UTILIZATION",
-      "MetricExpr": "((hv_24x7@PM_ALINK5_OUT_ODD_DATA\\,chip\\=?@ + hv_24x7@PM_ALINK5_OUT_EVEN_DATA\\,chip\\=?@) / (hv_24x7@PM_ALINK5_OUT_ODD_AVLBL_CYCLES\\,chip\\=?@ + hv_24x7@PM_ALINK5_OUT_EVEN_AVLBL_CYCLES\\,chip\\=?@)) * 100",
+      "MetricExpr": "((hv_24x7@PM_ALINK5_OUT_ODD_DATA\\,chip\\=?@ + hv_24x7@PM_ALINK5_OUT_EVEN_DATA\\,chip\\=?@) / (1 + hv_24x7@PM_ALINK5_OUT_ODD_AVLBL_CYCLES\\,chip\\=?@ + hv_24x7@PM_ALINK5_OUT_EVEN_AVLBL_CYCLES\\,chip\\=?@)) * 100",
       "ScaleUnit": "1.063%",
       "AggregationMode": "PerChip"
     },
     {
       "MetricName": "ALINK6_OUT_DATA_UTILIZATION",
-      "MetricExpr": "((hv_24x7@PM_ALINK6_OUT_ODD_DATA\\,chip\\=?@ + hv_24x7@PM_ALINK6_OUT_EVEN_DATA\\,chip\\=?@) / (hv_24x7@PM_ALINK6_OUT_ODD_AVLBL_CYCLES\\,chip\\=?@ + hv_24x7@PM_ALINK6_OUT_EVEN_AVLBL_CYCLES\\,chip\\=?@)) * 100",
+      "MetricExpr": "((hv_24x7@PM_ALINK6_OUT_ODD_DATA\\,chip\\=?@ + hv_24x7@PM_ALINK6_OUT_EVEN_DATA\\,chip\\=?@) / (1 + hv_24x7@PM_ALINK6_OUT_ODD_AVLBL_CYCLES\\,chip\\=?@ + hv_24x7@PM_ALINK6_OUT_EVEN_AVLBL_CYCLES\\,chip\\=?@)) * 100",
       "ScaleUnit": "1.063%",
       "AggregationMode": "PerChip"
     },
     {
       "MetricName": "ALINK7_OUT_DATA_UTILIZATION",
-      "MetricExpr": "((hv_24x7@PM_ALINK7_OUT_ODD_DATA\\,chip\\=?@ + hv_24x7@PM_ALINK7_OUT_EVEN_DATA\\,chip\\=?@) / (hv_24x7@PM_ALINK7_OUT_ODD_AVLBL_CYCLES\\,chip\\=?@ + hv_24x7@PM_ALINK7_OUT_EVEN_AVLBL_CYCLES\\,chip\\=?@)) * 100",
+      "MetricExpr": "((hv_24x7@PM_ALINK7_OUT_ODD_DATA\\,chip\\=?@ + hv_24x7@PM_ALINK7_OUT_EVEN_DATA\\,chip\\=?@) / (1 + hv_24x7@PM_ALINK7_OUT_ODD_AVLBL_CYCLES\\,chip\\=?@ + hv_24x7@PM_ALINK7_OUT_EVEN_AVLBL_CYCLES\\,chip\\=?@)) * 100",
       "ScaleUnit": "1.063%",
       "AggregationMode": "PerChip"
     },
diff --git a/tools/perf/util/auxtrace.c b/tools/perf/util/auxtrace.c
index 8d2865b9ade2..c7f78d589e1c 100644
--- a/tools/perf/util/auxtrace.c
+++ b/tools/perf/util/auxtrace.c
@@ -2260,11 +2260,19 @@ struct sym_args {
 	bool		near;
 };
 
+static bool kern_sym_name_match(const char *kname, const char *name)
+{
+	size_t n = strlen(name);
+
+	return !strcmp(kname, name) ||
+	       (!strncmp(kname, name, n) && kname[n] == '\t');
+}
+
 static bool kern_sym_match(struct sym_args *args, const char *name, char type)
 {
 	/* A function with the same name, and global or the n'th found or any */
 	return kallsyms__is_function(type) &&
-	       !strcmp(name, args->name) &&
+	       kern_sym_name_match(name, args->name) &&
 	       ((args->global && isupper(type)) ||
 		(args->selected && ++(args->cnt) == args->idx) ||
 		(!args->global && !args->selected));
diff --git a/tools/testing/selftests/kvm/memslot_modification_stress_test.c b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
index 4cfcafea9f5a..1d806b8ffee2 100644
--- a/tools/testing/selftests/kvm/memslot_modification_stress_test.c
+++ b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
@@ -72,7 +72,7 @@ struct memslot_antagonist_args {
 static void add_remove_memslot(struct kvm_vm *vm, useconds_t delay,
 			       uint64_t nr_modifications)
 {
-	const uint64_t pages = 1;
+	uint64_t pages = max_t(int, vm->page_size, getpagesize()) / vm->page_size;
 	uint64_t gpa;
 	int i;
 
