Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A33761217E
	for <lists+stable@lfdr.de>; Sat, 29 Oct 2022 10:42:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbiJ2ImY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Oct 2022 04:42:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiJ2ImW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Oct 2022 04:42:22 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED1F718D447;
        Sat, 29 Oct 2022 01:42:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1721FCE306A;
        Sat, 29 Oct 2022 08:42:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FE06C433D6;
        Sat, 29 Oct 2022 08:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667032933;
        bh=SxtM1vYeWk4ynDrOf+2qyYGziNqMqNJrGF/df59u0mU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gF5AVgbLWB8jkziy7suc0q76byux7Albh5bvjBYEPG9cB/ZuwonY0zQExdU7ReYLx
         30LKt+uV2eKWtDSgst8SpaSs73eZVHsg9g5/Efwo5DUrroeYI6Yf3dIBfiGsiLRigc
         t9enc5PwNFinxqTgXR6Z1nEVHGyao6tETQDF8T2U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.15.76
Date:   Sat, 29 Oct 2022 10:43:00 +0200
Message-Id: <16670329791828@kroah.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <1667032979148189@kroah.com>
References: <1667032979148189@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Documentation/arm64/silicon-errata.rst b/Documentation/arm64/silicon-errata.rst
index 21715d1e538d..1cee230338a2 100644
--- a/Documentation/arm64/silicon-errata.rst
+++ b/Documentation/arm64/silicon-errata.rst
@@ -78,10 +78,14 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A57      | #1319537        | ARM64_ERRATUM_1319367       |
 +----------------+-----------------+-----------------+-----------------------------+
+| ARM            | Cortex-A57      | #1742098        | ARM64_ERRATUM_1742098       |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A72      | #853709         | N/A                         |
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A72      | #1319367        | ARM64_ERRATUM_1319367       |
 +----------------+-----------------+-----------------+-----------------------------+
+| ARM            | Cortex-A72      | #1655431        | ARM64_ERRATUM_1742098       |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A73      | #858921         | ARM64_ERRATUM_858921        |
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A76      | #1188873,1418040| ARM64_ERRATUM_1418040       |
diff --git a/Makefile b/Makefile
index e3d63d529e0d..e7293e7a7ee9 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 15
-SUBLEVEL = 75
+SUBLEVEL = 76
 EXTRAVERSION =
 NAME = Trick or Treat
 
@@ -870,7 +870,9 @@ else
 DEBUG_CFLAGS	+= -g
 endif
 
-ifndef CONFIG_AS_IS_LLVM
+ifdef CONFIG_AS_IS_LLVM
+KBUILD_AFLAGS	+= -g
+else
 KBUILD_AFLAGS	+= -Wa,-gdwarf-2
 endif
 
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 1e5a03d51d46..9d3cbe786f8d 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -487,6 +487,22 @@ config ARM64_ERRATUM_834220
 
 	  If unsure, say Y.
 
+config ARM64_ERRATUM_1742098
+	bool "Cortex-A57/A72: 1742098: ELR recorded incorrectly on interrupt taken between cryptographic instructions in a sequence"
+	depends on COMPAT
+	default y
+	help
+	  This option removes the AES hwcap for aarch32 user-space to
+	  workaround erratum 1742098 on Cortex-A57 and Cortex-A72.
+
+	  Affected parts may corrupt the AES state if an interrupt is
+	  taken between a pair of AES instructions. These instructions
+	  are only present if the cryptography extensions are present.
+	  All software should have a fallback implementation for CPUs
+	  that don't implement the cryptography extensions.
+
+	  If unsure, say Y.
+
 config ARM64_ERRATUM_845719
 	bool "Cortex-A53: 845719: a load might read incorrect data"
 	depends on COMPAT
diff --git a/arch/arm64/include/asm/mte.h b/arch/arm64/include/asm/mte.h
index 02511650cffe..3e368ca66623 100644
--- a/arch/arm64/include/asm/mte.h
+++ b/arch/arm64/include/asm/mte.h
@@ -40,7 +40,9 @@ void mte_sync_tags(pte_t old_pte, pte_t pte);
 void mte_copy_page_tags(void *kto, const void *kfrom);
 void mte_thread_init_user(void);
 void mte_thread_switch(struct task_struct *next);
+void mte_cpu_setup(void);
 void mte_suspend_enter(void);
+void mte_suspend_exit(void);
 long set_mte_ctrl(struct task_struct *task, unsigned long arg);
 long get_mte_ctrl(struct task_struct *task);
 int mte_ptrace_copy_tags(struct task_struct *child, long request,
@@ -69,6 +71,9 @@ static inline void mte_thread_switch(struct task_struct *next)
 static inline void mte_suspend_enter(void)
 {
 }
+static inline void mte_suspend_exit(void)
+{
+}
 static inline long set_mte_ctrl(struct task_struct *task, unsigned long arg)
 {
 	return 0;
diff --git a/arch/arm64/include/asm/pgtable-hwdef.h b/arch/arm64/include/asm/pgtable-hwdef.h
index 40085e53f573..66671ff05183 100644
--- a/arch/arm64/include/asm/pgtable-hwdef.h
+++ b/arch/arm64/include/asm/pgtable-hwdef.h
@@ -273,6 +273,8 @@
 #define TCR_NFD1		(UL(1) << 54)
 #define TCR_E0PD0		(UL(1) << 55)
 #define TCR_E0PD1		(UL(1) << 56)
+#define TCR_TCMA0		(UL(1) << 57)
+#define TCR_TCMA1		(UL(1) << 58)
 
 /*
  * TTBR.
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 394fc5998a4b..f79f3720e4cb 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -1094,10 +1094,6 @@
 #define CPACR_EL1_ZEN_EL0EN	(BIT(17)) /* enable EL0 access, if EL1EN set */
 #define CPACR_EL1_ZEN		(CPACR_EL1_ZEN_EL1EN | CPACR_EL1_ZEN_EL0EN)
 
-/* TCR EL1 Bit Definitions */
-#define SYS_TCR_EL1_TCMA1	(BIT(58))
-#define SYS_TCR_EL1_TCMA0	(BIT(57))
-
 /* GCR_EL1 Definitions */
 #define SYS_GCR_EL1_RRND	(BIT(16))
 #define SYS_GCR_EL1_EXCL_MASK	0xffffUL
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index a3a9b1537329..ce59811616d8 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -355,6 +355,14 @@ static const struct midr_range erratum_1463225[] = {
 };
 #endif
 
+#ifdef CONFIG_ARM64_ERRATUM_1742098
+static struct midr_range broken_aarch32_aes[] = {
+	MIDR_RANGE(MIDR_CORTEX_A57, 0, 1, 0xf, 0xf),
+	MIDR_ALL_VERSIONS(MIDR_CORTEX_A72),
+	{},
+};
+#endif
+
 const struct arm64_cpu_capabilities arm64_errata[] = {
 #ifdef CONFIG_ARM64_WORKAROUND_CLEAN_CACHE
 	{
@@ -564,6 +572,14 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		/* Cortex-A510 r0p0-r1p1 */
 		CAP_MIDR_RANGE(MIDR_CORTEX_A510, 0, 0, 1, 1)
 	},
+#endif
+#ifdef CONFIG_ARM64_ERRATUM_1742098
+	{
+		.desc = "ARM erratum 1742098",
+		.capability = ARM64_WORKAROUND_1742098,
+		CAP_MIDR_RANGE_LIST(broken_aarch32_aes),
+		.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,
+	},
 #endif
 	{
 	}
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 3e52a9e8b50b..d4ee345ff429 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -79,6 +79,7 @@
 #include <asm/cpufeature.h>
 #include <asm/cpu_ops.h>
 #include <asm/fpsimd.h>
+#include <asm/hwcap.h>
 #include <asm/insn.h>
 #include <asm/kvm_host.h>
 #include <asm/mmu_context.h>
@@ -1902,7 +1903,8 @@ static void bti_enable(const struct arm64_cpu_capabilities *__unused)
 static void cpu_enable_mte(struct arm64_cpu_capabilities const *cap)
 {
 	sysreg_clear_set(sctlr_el1, 0, SCTLR_ELx_ATA | SCTLR_EL1_ATA0);
-	isb();
+
+	mte_cpu_setup();
 
 	/*
 	 * Clear the tags in the zero page. This needs to be done via the
@@ -1915,6 +1917,14 @@ static void cpu_enable_mte(struct arm64_cpu_capabilities const *cap)
 }
 #endif /* CONFIG_ARM64_MTE */
 
+static void elf_hwcap_fixup(void)
+{
+#ifdef CONFIG_ARM64_ERRATUM_1742098
+	if (cpus_have_const_cap(ARM64_WORKAROUND_1742098))
+		compat_elf_hwcap2 &= ~COMPAT_HWCAP2_AES;
+#endif /* ARM64_ERRATUM_1742098 */
+}
+
 #ifdef CONFIG_KVM
 static bool is_kvm_protected_mode(const struct arm64_cpu_capabilities *entry, int __unused)
 {
@@ -2942,8 +2952,10 @@ void __init setup_cpu_features(void)
 	setup_system_capabilities();
 	setup_elf_hwcaps(arm64_elf_hwcaps);
 
-	if (system_supports_32bit_el0())
+	if (system_supports_32bit_el0()) {
 		setup_elf_hwcaps(compat_elf_hwcaps);
+		elf_hwcap_fixup();
+	}
 
 	if (system_uses_ttbr0_pan())
 		pr_info("emulated: Privileged Access Never (PAN) using TTBR0_EL1 switching\n");
@@ -2995,6 +3007,7 @@ static int enable_mismatched_32bit_el0(unsigned int cpu)
 							 cpu_active_mask);
 	get_cpu_device(lucky_winner)->offline_disabled = true;
 	setup_elf_hwcaps(compat_elf_hwcaps);
+	elf_hwcap_fixup();
 	pr_info("Asymmetric 32-bit EL0 support detected on CPU %u; CPU hot-unplug disabled on CPU %u\n",
 		cpu, lucky_winner);
 	return 0;
diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
index 7c1c82c8115c..dacca0684ea3 100644
--- a/arch/arm64/kernel/mte.c
+++ b/arch/arm64/kernel/mte.c
@@ -213,6 +213,49 @@ void mte_thread_switch(struct task_struct *next)
 	mte_check_tfsr_el1();
 }
 
+void mte_cpu_setup(void)
+{
+	u64 rgsr;
+
+	/*
+	 * CnP must be enabled only after the MAIR_EL1 register has been set
+	 * up. Inconsistent MAIR_EL1 between CPUs sharing the same TLB may
+	 * lead to the wrong memory type being used for a brief window during
+	 * CPU power-up.
+	 *
+	 * CnP is not a boot feature so MTE gets enabled before CnP, but let's
+	 * make sure that is the case.
+	 */
+	BUG_ON(read_sysreg(ttbr0_el1) & TTBR_CNP_BIT);
+	BUG_ON(read_sysreg(ttbr1_el1) & TTBR_CNP_BIT);
+
+	/* Normal Tagged memory type at the corresponding MAIR index */
+	sysreg_clear_set(mair_el1,
+			 MAIR_ATTRIDX(MAIR_ATTR_MASK, MT_NORMAL_TAGGED),
+			 MAIR_ATTRIDX(MAIR_ATTR_NORMAL_TAGGED,
+				      MT_NORMAL_TAGGED));
+
+	write_sysreg_s(KERNEL_GCR_EL1, SYS_GCR_EL1);
+
+	/*
+	 * If GCR_EL1.RRND=1 is implemented the same way as RRND=0, then
+	 * RGSR_EL1.SEED must be non-zero for IRG to produce
+	 * pseudorandom numbers. As RGSR_EL1 is UNKNOWN out of reset, we
+	 * must initialize it.
+	 */
+	rgsr = (read_sysreg(CNTVCT_EL0) & SYS_RGSR_EL1_SEED_MASK) <<
+	       SYS_RGSR_EL1_SEED_SHIFT;
+	if (rgsr == 0)
+		rgsr = 1 << SYS_RGSR_EL1_SEED_SHIFT;
+	write_sysreg_s(rgsr, SYS_RGSR_EL1);
+
+	/* clear any pending tag check faults in TFSR*_EL1 */
+	write_sysreg_s(0, SYS_TFSR_EL1);
+	write_sysreg_s(0, SYS_TFSRE0_EL1);
+
+	local_flush_tlb_all();
+}
+
 void mte_suspend_enter(void)
 {
 	if (!system_supports_mte())
@@ -229,6 +272,14 @@ void mte_suspend_enter(void)
 	mte_check_tfsr_el1();
 }
 
+void mte_suspend_exit(void)
+{
+	if (!system_supports_mte())
+		return;
+
+	mte_cpu_setup();
+}
+
 long set_mte_ctrl(struct task_struct *task, unsigned long arg)
 {
 	u64 mte_ctrl = (~((arg & PR_MTE_TAG_MASK) >> PR_MTE_TAG_SHIFT) &
diff --git a/arch/arm64/kernel/suspend.c b/arch/arm64/kernel/suspend.c
index 19ee7c33769d..d473ec204fef 100644
--- a/arch/arm64/kernel/suspend.c
+++ b/arch/arm64/kernel/suspend.c
@@ -43,6 +43,8 @@ void notrace __cpu_suspend_exit(void)
 {
 	unsigned int cpu = smp_processor_id();
 
+	mte_suspend_exit();
+
 	/*
 	 * We are resuming from reset with the idmap active in TTBR0_EL1.
 	 * We must uninstall the idmap and restore the expected MMU
diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 61728c543eb9..1d534283378a 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -2096,7 +2096,7 @@ static int scan_its_table(struct vgic_its *its, gpa_t base, int size, u32 esz,
 
 	memset(entry, 0, esz);
 
-	while (len > 0) {
+	while (true) {
 		int next_offset;
 		size_t byte_offset;
 
@@ -2109,6 +2109,9 @@ static int scan_its_table(struct vgic_its *its, gpa_t base, int size, u32 esz,
 			return next_offset;
 
 		byte_offset = next_offset * esz;
+		if (byte_offset >= len)
+			break;
+
 		id += next_offset;
 		gpa += byte_offset;
 		len -= byte_offset;
diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
index d35c90d2e47a..1a9684b11474 100644
--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -46,18 +46,20 @@
 #endif
 
 #ifdef CONFIG_KASAN_HW_TAGS
-#define TCR_MTE_FLAGS SYS_TCR_EL1_TCMA1 | TCR_TBI1 | TCR_TBID1
-#else
+#define TCR_MTE_FLAGS TCR_TCMA1 | TCR_TBI1 | TCR_TBID1
+#elif defined(CONFIG_ARM64_MTE)
 /*
  * The mte_zero_clear_page_tags() implementation uses DC GZVA, which relies on
  * TBI being enabled at EL1.
  */
 #define TCR_MTE_FLAGS TCR_TBI1 | TCR_TBID1
+#else
+#define TCR_MTE_FLAGS 0
 #endif
 
 /*
  * Default MAIR_EL1. MT_NORMAL_TAGGED is initially mapped as Normal memory and
- * changed during __cpu_setup to Normal Tagged if the system supports MTE.
+ * changed during mte_cpu_setup to Normal Tagged if the system supports MTE.
  */
 #define MAIR_EL1_SET							\
 	(MAIR_ATTRIDX(MAIR_ATTR_DEVICE_nGnRnE, MT_DEVICE_nGnRnE) |	\
@@ -421,46 +423,8 @@ SYM_FUNC_START(__cpu_setup)
 	mov_q	mair, MAIR_EL1_SET
 	mov_q	tcr, TCR_TxSZ(VA_BITS) | TCR_CACHE_FLAGS | TCR_SMP_FLAGS | \
 			TCR_TG_FLAGS | TCR_KASLR_FLAGS | TCR_ASID16 | \
-			TCR_TBI0 | TCR_A1 | TCR_KASAN_SW_FLAGS
-
-#ifdef CONFIG_ARM64_MTE
-	/*
-	 * Update MAIR_EL1, GCR_EL1 and TFSR*_EL1 if MTE is supported
-	 * (ID_AA64PFR1_EL1[11:8] > 1).
-	 */
-	mrs	x10, ID_AA64PFR1_EL1
-	ubfx	x10, x10, #ID_AA64PFR1_MTE_SHIFT, #4
-	cmp	x10, #ID_AA64PFR1_MTE
-	b.lt	1f
-
-	/* Normal Tagged memory type at the corresponding MAIR index */
-	mov	x10, #MAIR_ATTR_NORMAL_TAGGED
-	bfi	mair, x10, #(8 *  MT_NORMAL_TAGGED), #8
+			TCR_TBI0 | TCR_A1 | TCR_KASAN_SW_FLAGS | TCR_MTE_FLAGS
 
-	mov	x10, #KERNEL_GCR_EL1
-	msr_s	SYS_GCR_EL1, x10
-
-	/*
-	 * If GCR_EL1.RRND=1 is implemented the same way as RRND=0, then
-	 * RGSR_EL1.SEED must be non-zero for IRG to produce
-	 * pseudorandom numbers. As RGSR_EL1 is UNKNOWN out of reset, we
-	 * must initialize it.
-	 */
-	mrs	x10, CNTVCT_EL0
-	ands	x10, x10, #SYS_RGSR_EL1_SEED_MASK
-	csinc	x10, x10, xzr, ne
-	lsl	x10, x10, #SYS_RGSR_EL1_SEED_SHIFT
-	msr_s	SYS_RGSR_EL1, x10
-
-	/* clear any pending tag check faults in TFSR*_EL1 */
-	msr_s	SYS_TFSR_EL1, xzr
-	msr_s	SYS_TFSRE0_EL1, xzr
-
-	/* set the TCR_EL1 bits */
-	mov_q	x10, TCR_MTE_FLAGS
-	orr	tcr, tcr, x10
-1:
-#endif
 	tcr_clear_errata_bits tcr, x9, x5
 
 #ifdef CONFIG_ARM64_VA_BITS_52
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index cfaffd3c8289..6b1e70aee8cf 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -54,6 +54,7 @@ WORKAROUND_1418040
 WORKAROUND_1463225
 WORKAROUND_1508412
 WORKAROUND_1542419
+WORKAROUND_1742098
 WORKAROUND_2457168
 WORKAROUND_CAVIUM_23154
 WORKAROUND_CAVIUM_27456
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 57f5e881791a..0f2234cd8453 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1926,7 +1926,6 @@ config EFI
 config EFI_STUB
 	bool "EFI stub support"
 	depends on EFI && !X86_USE_3DNOW
-	depends on $(cc-option,-mabi=ms) || X86_32
 	select RELOCATABLE
 	help
 	  This kernel feature allows a bzImage to be loaded directly
diff --git a/arch/x86/events/intel/pt.c b/arch/x86/events/intel/pt.c
index 215aed65e978..9ac205487804 100644
--- a/arch/x86/events/intel/pt.c
+++ b/arch/x86/events/intel/pt.c
@@ -13,6 +13,8 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/types.h>
+#include <linux/bits.h>
+#include <linux/limits.h>
 #include <linux/slab.h>
 #include <linux/device.h>
 
@@ -1348,11 +1350,37 @@ static void pt_addr_filters_fini(struct perf_event *event)
 	event->hw.addr_filters = NULL;
 }
 
-static inline bool valid_kernel_ip(unsigned long ip)
+#ifdef CONFIG_X86_64
+static u64 canonical_address(u64 vaddr, u8 vaddr_bits)
 {
-	return virt_addr_valid(ip) && kernel_ip(ip);
+	return ((s64)vaddr << (64 - vaddr_bits)) >> (64 - vaddr_bits);
 }
 
+static u64 is_canonical_address(u64 vaddr, u8 vaddr_bits)
+{
+	return canonical_address(vaddr, vaddr_bits) == vaddr;
+}
+
+/* Clamp to a canonical address greater-than-or-equal-to the address given */
+static u64 clamp_to_ge_canonical_addr(u64 vaddr, u8 vaddr_bits)
+{
+	return is_canonical_address(vaddr, vaddr_bits) ?
+	       vaddr :
+	       -BIT_ULL(vaddr_bits - 1);
+}
+
+/* Clamp to a canonical address less-than-or-equal-to the address given */
+static u64 clamp_to_le_canonical_addr(u64 vaddr, u8 vaddr_bits)
+{
+	return is_canonical_address(vaddr, vaddr_bits) ?
+	       vaddr :
+	       BIT_ULL(vaddr_bits - 1) - 1;
+}
+#else
+#define clamp_to_ge_canonical_addr(x, y) (x)
+#define clamp_to_le_canonical_addr(x, y) (x)
+#endif
+
 static int pt_event_addr_filters_validate(struct list_head *filters)
 {
 	struct perf_addr_filter *filter;
@@ -1367,14 +1395,6 @@ static int pt_event_addr_filters_validate(struct list_head *filters)
 		    filter->action == PERF_ADDR_FILTER_ACTION_START)
 			return -EOPNOTSUPP;
 
-		if (!filter->path.dentry) {
-			if (!valid_kernel_ip(filter->offset))
-				return -EINVAL;
-
-			if (!valid_kernel_ip(filter->offset + filter->size))
-				return -EINVAL;
-		}
-
 		if (++range > intel_pt_validate_hw_cap(PT_CAP_num_address_ranges))
 			return -EOPNOTSUPP;
 	}
@@ -1398,9 +1418,26 @@ static void pt_event_addr_filters_sync(struct perf_event *event)
 		if (filter->path.dentry && !fr[range].start) {
 			msr_a = msr_b = 0;
 		} else {
-			/* apply the offset */
-			msr_a = fr[range].start;
-			msr_b = msr_a + fr[range].size - 1;
+			unsigned long n = fr[range].size - 1;
+			unsigned long a = fr[range].start;
+			unsigned long b;
+
+			if (a > ULONG_MAX - n)
+				b = ULONG_MAX;
+			else
+				b = a + n;
+			/*
+			 * Apply the offset. 64-bit addresses written to the
+			 * MSRs must be canonical, but the range can encompass
+			 * non-canonical addresses. Since software cannot
+			 * execute at non-canonical addresses, adjusting to
+			 * canonical addresses does not affect the result of the
+			 * address filter.
+			 */
+			msr_a = clamp_to_ge_canonical_addr(a, boot_cpu_data.x86_virt_bits);
+			msr_b = clamp_to_le_canonical_addr(b, boot_cpu_data.x86_virt_bits);
+			if (msr_b < msr_a)
+				msr_a = msr_b = 0;
 		}
 
 		filters->filter[range].msr_a  = msr_a;
diff --git a/arch/x86/include/asm/iommu.h b/arch/x86/include/asm/iommu.h
index bf1ed2ddc74b..7a983119bc40 100644
--- a/arch/x86/include/asm/iommu.h
+++ b/arch/x86/include/asm/iommu.h
@@ -17,8 +17,10 @@ arch_rmrr_sanity_check(struct acpi_dmar_reserved_memory *rmrr)
 {
 	u64 start = rmrr->base_address;
 	u64 end = rmrr->end_address + 1;
+	int entry_type;
 
-	if (e820__mapped_all(start, end, E820_TYPE_RESERVED))
+	entry_type = e820__get_entry_type(start, end);
+	if (entry_type == E820_TYPE_RESERVED || entry_type == E820_TYPE_NVS)
 		return 0;
 
 	pr_err(FW_BUG "No firmware reserved region can cover this RMRR [%#018Lx-%#018Lx], contact BIOS vendor for fixes\n",
diff --git a/arch/x86/kernel/cpu/microcode/amd.c b/arch/x86/kernel/cpu/microcode/amd.c
index 5a16844b99d3..7c758f1afbf0 100644
--- a/arch/x86/kernel/cpu/microcode/amd.c
+++ b/arch/x86/kernel/cpu/microcode/amd.c
@@ -440,7 +440,13 @@ apply_microcode_early_amd(u32 cpuid_1_eax, void *ucode, size_t size, bool save_p
 		return ret;
 
 	native_rdmsr(MSR_AMD64_PATCH_LEVEL, rev, dummy);
-	if (rev >= mc->hdr.patch_id)
+
+	/*
+	 * Allow application of the same revision to pick up SMT-specific
+	 * changes even if the revision of the other SMT thread is already
+	 * up-to-date.
+	 */
+	if (rev > mc->hdr.patch_id)
 		return ret;
 
 	if (!__apply_microcode_amd(mc)) {
@@ -522,8 +528,12 @@ void load_ucode_amd_ap(unsigned int cpuid_1_eax)
 
 	native_rdmsr(MSR_AMD64_PATCH_LEVEL, rev, dummy);
 
-	/* Check whether we have saved a new patch already: */
-	if (*new_rev && rev < mc->hdr.patch_id) {
+	/*
+	 * Check whether a new patch has been saved already. Also, allow application of
+	 * the same revision in order to pick up SMT-thread-specific configuration even
+	 * if the sibling SMT thread already has an up-to-date revision.
+	 */
+	if (*new_rev && rev <= mc->hdr.patch_id) {
 		if (!__apply_microcode_amd(mc)) {
 			*new_rev = mc->hdr.patch_id;
 			return;
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index bb1c3f5f60c8..a5c51a14fbce 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -66,9 +66,6 @@ struct rdt_hw_resource rdt_resources_all[] = {
 			.rid			= RDT_RESOURCE_L3,
 			.name			= "L3",
 			.cache_level		= 3,
-			.cache = {
-				.min_cbm_bits	= 1,
-			},
 			.domains		= domain_init(RDT_RESOURCE_L3),
 			.parse_ctrlval		= parse_cbm,
 			.format_str		= "%d=%0*x",
@@ -83,9 +80,6 @@ struct rdt_hw_resource rdt_resources_all[] = {
 			.rid			= RDT_RESOURCE_L2,
 			.name			= "L2",
 			.cache_level		= 2,
-			.cache = {
-				.min_cbm_bits	= 1,
-			},
 			.domains		= domain_init(RDT_RESOURCE_L2),
 			.parse_ctrlval		= parse_cbm,
 			.format_str		= "%d=%0*x",
@@ -877,6 +871,7 @@ static __init void rdt_init_res_defs_intel(void)
 			r->cache.arch_has_sparse_bitmaps = false;
 			r->cache.arch_has_empty_bitmaps = false;
 			r->cache.arch_has_per_cpu_cfg = false;
+			r->cache.min_cbm_bits = 1;
 		} else if (r->rid == RDT_RESOURCE_MBA) {
 			hw_res->msr_base = MSR_IA32_MBA_THRTL_BASE;
 			hw_res->msr_update = mba_wrmsr_intel;
@@ -897,6 +892,7 @@ static __init void rdt_init_res_defs_amd(void)
 			r->cache.arch_has_sparse_bitmaps = true;
 			r->cache.arch_has_empty_bitmaps = true;
 			r->cache.arch_has_per_cpu_cfg = true;
+			r->cache.min_cbm_bits = 0;
 		} else if (r->rid == RDT_RESOURCE_MBA) {
 			hw_res->msr_base = MSR_IA32_MBA_BW_BASE;
 			hw_res->msr_update = mba_wrmsr_amd;
diff --git a/arch/x86/kernel/cpu/topology.c b/arch/x86/kernel/cpu/topology.c
index 132a2de44d2f..5e868b62a7c4 100644
--- a/arch/x86/kernel/cpu/topology.c
+++ b/arch/x86/kernel/cpu/topology.c
@@ -96,6 +96,7 @@ int detect_extended_topology(struct cpuinfo_x86 *c)
 	unsigned int ht_mask_width, core_plus_mask_width, die_plus_mask_width;
 	unsigned int core_select_mask, core_level_siblings;
 	unsigned int die_select_mask, die_level_siblings;
+	unsigned int pkg_mask_width;
 	bool die_level_present = false;
 	int leaf;
 
@@ -111,10 +112,10 @@ int detect_extended_topology(struct cpuinfo_x86 *c)
 	core_level_siblings = smp_num_siblings = LEVEL_MAX_SIBLINGS(ebx);
 	core_plus_mask_width = ht_mask_width = BITS_SHIFT_NEXT_LEVEL(eax);
 	die_level_siblings = LEVEL_MAX_SIBLINGS(ebx);
-	die_plus_mask_width = BITS_SHIFT_NEXT_LEVEL(eax);
+	pkg_mask_width = die_plus_mask_width = BITS_SHIFT_NEXT_LEVEL(eax);
 
 	sub_index = 1;
-	do {
+	while (true) {
 		cpuid_count(leaf, sub_index, &eax, &ebx, &ecx, &edx);
 
 		/*
@@ -132,10 +133,15 @@ int detect_extended_topology(struct cpuinfo_x86 *c)
 			die_plus_mask_width = BITS_SHIFT_NEXT_LEVEL(eax);
 		}
 
+		if (LEAFB_SUBTYPE(ecx) != INVALID_TYPE)
+			pkg_mask_width = BITS_SHIFT_NEXT_LEVEL(eax);
+		else
+			break;
+
 		sub_index++;
-	} while (LEAFB_SUBTYPE(ecx) != INVALID_TYPE);
+	}
 
-	core_select_mask = (~(-1 << core_plus_mask_width)) >> ht_mask_width;
+	core_select_mask = (~(-1 << pkg_mask_width)) >> ht_mask_width;
 	die_select_mask = (~(-1 << die_plus_mask_width)) >>
 				core_plus_mask_width;
 
@@ -148,7 +154,7 @@ int detect_extended_topology(struct cpuinfo_x86 *c)
 	}
 
 	c->phys_proc_id = apic->phys_pkg_id(c->initial_apicid,
-				die_plus_mask_width);
+				pkg_mask_width);
 	/*
 	 * Reinit the apicid, now that we have extended initial_apicid.
 	 */
diff --git a/drivers/acpi/acpi_extlog.c b/drivers/acpi/acpi_extlog.c
index 72f1fb77abcd..e648158368a7 100644
--- a/drivers/acpi/acpi_extlog.c
+++ b/drivers/acpi/acpi_extlog.c
@@ -12,6 +12,7 @@
 #include <linux/ratelimit.h>
 #include <linux/edac.h>
 #include <linux/ras.h>
+#include <acpi/ghes.h>
 #include <asm/cpu.h>
 #include <asm/mce.h>
 
@@ -138,8 +139,8 @@ static int extlog_print(struct notifier_block *nb, unsigned long val,
 	int	cpu = mce->extcpu;
 	struct acpi_hest_generic_status *estatus, *tmp;
 	struct acpi_hest_generic_data *gdata;
-	const guid_t *fru_id = &guid_null;
-	char *fru_text = "";
+	const guid_t *fru_id;
+	char *fru_text;
 	guid_t *sec_type;
 	static u32 err_seq;
 
@@ -160,17 +161,23 @@ static int extlog_print(struct notifier_block *nb, unsigned long val,
 
 	/* log event via trace */
 	err_seq++;
-	gdata = (struct acpi_hest_generic_data *)(tmp + 1);
-	if (gdata->validation_bits & CPER_SEC_VALID_FRU_ID)
-		fru_id = (guid_t *)gdata->fru_id;
-	if (gdata->validation_bits & CPER_SEC_VALID_FRU_TEXT)
-		fru_text = gdata->fru_text;
-	sec_type = (guid_t *)gdata->section_type;
-	if (guid_equal(sec_type, &CPER_SEC_PLATFORM_MEM)) {
-		struct cper_sec_mem_err *mem = (void *)(gdata + 1);
-		if (gdata->error_data_length >= sizeof(*mem))
-			trace_extlog_mem_event(mem, err_seq, fru_id, fru_text,
-					       (u8)gdata->error_severity);
+	apei_estatus_for_each_section(tmp, gdata) {
+		if (gdata->validation_bits & CPER_SEC_VALID_FRU_ID)
+			fru_id = (guid_t *)gdata->fru_id;
+		else
+			fru_id = &guid_null;
+		if (gdata->validation_bits & CPER_SEC_VALID_FRU_TEXT)
+			fru_text = gdata->fru_text;
+		else
+			fru_text = "";
+		sec_type = (guid_t *)gdata->section_type;
+		if (guid_equal(sec_type, &CPER_SEC_PLATFORM_MEM)) {
+			struct cper_sec_mem_err *mem = (void *)(gdata + 1);
+
+			if (gdata->error_data_length >= sizeof(*mem))
+				trace_extlog_mem_event(mem, err_seq, fru_id, fru_text,
+						       (u8)gdata->error_severity);
+		}
 	}
 
 out:
diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index e39d59ad6496..b13713199ad9 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -500,6 +500,70 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
 		DMI_MATCH(DMI_BOARD_NAME, "PF5LUXG"),
 		},
 	},
+	/*
+	 * More Tongfang devices with the same issue as the Clevo NL5xRU and
+	 * NL5xNU/TUXEDO Aura 15 Gen1 and Gen2. See the description above.
+	 */
+	{
+	.callback = video_detect_force_native,
+	.ident = "TongFang GKxNRxx",
+	.matches = {
+		DMI_MATCH(DMI_BOARD_NAME, "GKxNRxx"),
+		},
+	},
+	{
+	.callback = video_detect_force_native,
+	.ident = "TongFang GKxNRxx",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "TUXEDO"),
+		DMI_MATCH(DMI_BOARD_NAME, "POLARIS1501A1650TI"),
+		},
+	},
+	{
+	.callback = video_detect_force_native,
+	.ident = "TongFang GKxNRxx",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "TUXEDO"),
+		DMI_MATCH(DMI_BOARD_NAME, "POLARIS1501A2060"),
+		},
+	},
+	{
+	.callback = video_detect_force_native,
+	.ident = "TongFang GKxNRxx",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "TUXEDO"),
+		DMI_MATCH(DMI_BOARD_NAME, "POLARIS1701A1650TI"),
+		},
+	},
+	{
+	.callback = video_detect_force_native,
+	.ident = "TongFang GKxNRxx",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "TUXEDO"),
+		DMI_MATCH(DMI_BOARD_NAME, "POLARIS1701A2060"),
+		},
+	},
+	{
+	.callback = video_detect_force_native,
+	.ident = "TongFang GMxNGxx",
+	.matches = {
+		DMI_MATCH(DMI_BOARD_NAME, "GMxNGxx"),
+		},
+	},
+	{
+	.callback = video_detect_force_native,
+	.ident = "TongFang GMxZGxx",
+	.matches = {
+		DMI_MATCH(DMI_BOARD_NAME, "GMxZGxx"),
+		},
+	},
+	{
+	.callback = video_detect_force_native,
+	.ident = "TongFang GMxRGxx",
+	.matches = {
+		DMI_MATCH(DMI_BOARD_NAME, "GMxRGxx"),
+		},
+	},
 	/*
 	 * Desktops which falsely report a backlight and which our heuristics
 	 * for this do not catch.
diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
index 2e89499bd9c3..60ae707a88cc 100644
--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -254,7 +254,7 @@ enum {
 	PCS_7				= 0x94, /* 7+ port PCS (Denverton) */
 
 	/* em constants */
-	EM_MAX_SLOTS			= 8,
+	EM_MAX_SLOTS			= SATA_PMP_MAX_PORTS,
 	EM_MAX_RETRY			= 5,
 
 	/* em_ctl bits */
diff --git a/drivers/ata/ahci_imx.c b/drivers/ata/ahci_imx.c
index 388baf528fa8..189f75d53741 100644
--- a/drivers/ata/ahci_imx.c
+++ b/drivers/ata/ahci_imx.c
@@ -1230,4 +1230,4 @@ module_platform_driver(imx_ahci_driver);
 MODULE_DESCRIPTION("Freescale i.MX AHCI SATA platform driver");
 MODULE_AUTHOR("Richard Zhu <Hong-Xing.Zhu@freescale.com>");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS("ahci:imx");
+MODULE_ALIAS("platform:" DRV_NAME);
diff --git a/drivers/cpufreq/qcom-cpufreq-nvmem.c b/drivers/cpufreq/qcom-cpufreq-nvmem.c
index 6dfa86971a75..6e011e8bfb6a 100644
--- a/drivers/cpufreq/qcom-cpufreq-nvmem.c
+++ b/drivers/cpufreq/qcom-cpufreq-nvmem.c
@@ -215,6 +215,7 @@ static int qcom_cpufreq_krait_name_version(struct device *cpu_dev,
 	int speed = 0, pvs = 0, pvs_ver = 0;
 	u8 *speedbin;
 	size_t len;
+	int ret = 0;
 
 	speedbin = nvmem_cell_read(speedbin_nvmem, &len);
 
@@ -232,7 +233,8 @@ static int qcom_cpufreq_krait_name_version(struct device *cpu_dev,
 		break;
 	default:
 		dev_err(cpu_dev, "Unable to read nvmem data. Defaulting to 0!\n");
-		return -ENODEV;
+		ret = -ENODEV;
+		goto len_error;
 	}
 
 	snprintf(*pvs_name, sizeof("speedXX-pvsXX-vXX"), "speed%d-pvs%d-v%d",
@@ -240,8 +242,9 @@ static int qcom_cpufreq_krait_name_version(struct device *cpu_dev,
 
 	drv->versions = (1 << speed);
 
+len_error:
 	kfree(speedbin);
-	return 0;
+	return ret;
 }
 
 static const struct qcom_cpufreq_match_data match_data_kryo = {
@@ -264,7 +267,8 @@ static int qcom_cpufreq_probe(struct platform_device *pdev)
 	struct nvmem_cell *speedbin_nvmem;
 	struct device_node *np;
 	struct device *cpu_dev;
-	char *pvs_name = "speedXX-pvsXX-vXX";
+	char pvs_name_buffer[] = "speedXX-pvsXX-vXX";
+	char *pvs_name = pvs_name_buffer;
 	unsigned cpu;
 	const struct of_device_id *match;
 	int ret;
diff --git a/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c b/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
index 8b20326c4c05..9014f71d52dd 100644
--- a/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
@@ -1507,11 +1507,6 @@ static int sdma_v4_0_start(struct amdgpu_device *adev)
 		WREG32_SDMA(i, mmSDMA0_CNTL, temp);
 
 		if (!amdgpu_sriov_vf(adev)) {
-			ring = &adev->sdma.instance[i].ring;
-			adev->nbio.funcs->sdma_doorbell_range(adev, i,
-				ring->use_doorbell, ring->doorbell_index,
-				adev->doorbell_index.sdma_doorbell_range);
-
 			/* unhalt engine */
 			temp = RREG32_SDMA(i, mmSDMA0_F32_CNTL);
 			temp = REG_SET_FIELD(temp, SDMA0_F32_CNTL, HALT, 0);
diff --git a/drivers/gpu/drm/amd/amdgpu/soc15.c b/drivers/gpu/drm/amd/amdgpu/soc15.c
index 7d5ff50435e5..0cde8fb9e30d 100644
--- a/drivers/gpu/drm/amd/amdgpu/soc15.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc15.c
@@ -1416,6 +1416,20 @@ static int soc15_common_sw_fini(void *handle)
 	return 0;
 }
 
+static void soc15_sdma_doorbell_range_init(struct amdgpu_device *adev)
+{
+	int i;
+
+	/* sdma doorbell range is programed by hypervisor */
+	if (!amdgpu_sriov_vf(adev)) {
+		for (i = 0; i < adev->sdma.num_instances; i++) {
+			adev->nbio.funcs->sdma_doorbell_range(adev, i,
+				true, adev->doorbell_index.sdma_engine[i] << 1,
+				adev->doorbell_index.sdma_doorbell_range);
+		}
+	}
+}
+
 static int soc15_common_hw_init(void *handle)
 {
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
@@ -1435,6 +1449,13 @@ static int soc15_common_hw_init(void *handle)
 
 	/* enable the doorbell aperture */
 	soc15_enable_doorbell_aperture(adev, true);
+	/* HW doorbell routing policy: doorbell writing not
+	 * in SDMA/IH/MM/ACV range will be routed to CP. So
+	 * we need to init SDMA doorbell range prior
+	 * to CP ip block init and ring test.  IH already
+	 * happens before CP.
+	 */
+	soc15_sdma_doorbell_range_init(adev);
 
 	return 0;
 }
diff --git a/drivers/gpu/drm/vc4/vc4_drv.c b/drivers/gpu/drm/vc4/vc4_drv.c
index ef8fa2850ed6..d216a1fd057c 100644
--- a/drivers/gpu/drm/vc4/vc4_drv.c
+++ b/drivers/gpu/drm/vc4/vc4_drv.c
@@ -397,6 +397,7 @@ module_init(vc4_drm_register);
 module_exit(vc4_drm_unregister);
 
 MODULE_ALIAS("platform:vc4-drm");
+MODULE_SOFTDEP("pre: snd-soc-hdmi-codec");
 MODULE_DESCRIPTION("Broadcom VC4 DRM Driver");
 MODULE_AUTHOR("Eric Anholt <eric@anholt.net>");
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/hid/hid-magicmouse.c b/drivers/hid/hid-magicmouse.c
index b8b08f0a8c54..c6b8da716002 100644
--- a/drivers/hid/hid-magicmouse.c
+++ b/drivers/hid/hid-magicmouse.c
@@ -478,7 +478,7 @@ static int magicmouse_raw_event(struct hid_device *hdev,
 		magicmouse_raw_event(hdev, report, data + 2, data[1]);
 		magicmouse_raw_event(hdev, report, data + 2 + data[1],
 			size - 2 - data[1]);
-		break;
+		return 0;
 	default:
 		return 0;
 	}
diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index bb9211215a68..032129292957 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -46,9 +46,6 @@ MODULE_PARM_DESC(tjmax, "TjMax value in degrees Celsius");
 #define TOTAL_ATTRS		(MAX_CORE_ATTRS + 1)
 #define MAX_CORE_DATA		(NUM_REAL_CORES + BASE_SYSFS_ATTR_NO)
 
-#define TO_CORE_ID(cpu)		(cpu_data(cpu).cpu_core_id)
-#define TO_ATTR_NO(cpu)		(TO_CORE_ID(cpu) + BASE_SYSFS_ATTR_NO)
-
 #ifdef CONFIG_SMP
 #define for_each_sibling(i, cpu) \
 	for_each_cpu(i, topology_sibling_cpumask(cpu))
@@ -91,6 +88,8 @@ struct temp_data {
 struct platform_data {
 	struct device		*hwmon_dev;
 	u16			pkg_id;
+	u16			cpu_map[NUM_REAL_CORES];
+	struct ida		ida;
 	struct cpumask		cpumask;
 	struct temp_data	*core_data[MAX_CORE_DATA];
 	struct device_attribute name_attr;
@@ -441,7 +440,7 @@ static struct temp_data *init_temp_data(unsigned int cpu, int pkg_flag)
 							MSR_IA32_THERM_STATUS;
 	tdata->is_pkg_data = pkg_flag;
 	tdata->cpu = cpu;
-	tdata->cpu_core_id = TO_CORE_ID(cpu);
+	tdata->cpu_core_id = topology_core_id(cpu);
 	tdata->attr_size = MAX_CORE_ATTRS;
 	mutex_init(&tdata->update_lock);
 	return tdata;
@@ -454,7 +453,7 @@ static int create_core_data(struct platform_device *pdev, unsigned int cpu,
 	struct platform_data *pdata = platform_get_drvdata(pdev);
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
 	u32 eax, edx;
-	int err, attr_no;
+	int err, index, attr_no;
 
 	/*
 	 * Find attr number for sysfs:
@@ -462,14 +461,26 @@ static int create_core_data(struct platform_device *pdev, unsigned int cpu,
 	 * The attr number is always core id + 2
 	 * The Pkgtemp will always show up as temp1_*, if available
 	 */
-	attr_no = pkg_flag ? PKG_SYSFS_ATTR_NO : TO_ATTR_NO(cpu);
+	if (pkg_flag) {
+		attr_no = PKG_SYSFS_ATTR_NO;
+	} else {
+		index = ida_alloc(&pdata->ida, GFP_KERNEL);
+		if (index < 0)
+			return index;
+		pdata->cpu_map[index] = topology_core_id(cpu);
+		attr_no = index + BASE_SYSFS_ATTR_NO;
+	}
 
-	if (attr_no > MAX_CORE_DATA - 1)
-		return -ERANGE;
+	if (attr_no > MAX_CORE_DATA - 1) {
+		err = -ERANGE;
+		goto ida_free;
+	}
 
 	tdata = init_temp_data(cpu, pkg_flag);
-	if (!tdata)
-		return -ENOMEM;
+	if (!tdata) {
+		err = -ENOMEM;
+		goto ida_free;
+	}
 
 	/* Test if we can access the status register */
 	err = rdmsr_safe_on_cpu(cpu, tdata->status_reg, &eax, &edx);
@@ -505,6 +516,9 @@ static int create_core_data(struct platform_device *pdev, unsigned int cpu,
 exit_free:
 	pdata->core_data[attr_no] = NULL;
 	kfree(tdata);
+ida_free:
+	if (!pkg_flag)
+		ida_free(&pdata->ida, index);
 	return err;
 }
 
@@ -524,6 +538,9 @@ static void coretemp_remove_core(struct platform_data *pdata, int indx)
 
 	kfree(pdata->core_data[indx]);
 	pdata->core_data[indx] = NULL;
+
+	if (indx >= BASE_SYSFS_ATTR_NO)
+		ida_free(&pdata->ida, indx - BASE_SYSFS_ATTR_NO);
 }
 
 static int coretemp_probe(struct platform_device *pdev)
@@ -537,6 +554,7 @@ static int coretemp_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	pdata->pkg_id = pdev->id;
+	ida_init(&pdata->ida);
 	platform_set_drvdata(pdev, pdata);
 
 	pdata->hwmon_dev = devm_hwmon_device_register_with_groups(dev, DRVNAME,
@@ -553,6 +571,7 @@ static int coretemp_remove(struct platform_device *pdev)
 		if (pdata->core_data[i])
 			coretemp_remove_core(pdata, i);
 
+	ida_destroy(&pdata->ida);
 	return 0;
 }
 
@@ -647,7 +666,7 @@ static int coretemp_cpu_offline(unsigned int cpu)
 	struct platform_device *pdev = coretemp_get_pdev(cpu);
 	struct platform_data *pd;
 	struct temp_data *tdata;
-	int indx, target;
+	int i, indx = -1, target;
 
 	/*
 	 * Don't execute this on suspend as the device remove locks
@@ -660,12 +679,19 @@ static int coretemp_cpu_offline(unsigned int cpu)
 	if (!pdev)
 		return 0;
 
-	/* The core id is too big, just return */
-	indx = TO_ATTR_NO(cpu);
-	if (indx > MAX_CORE_DATA - 1)
+	pd = platform_get_drvdata(pdev);
+
+	for (i = 0; i < NUM_REAL_CORES; i++) {
+		if (pd->cpu_map[i] == topology_core_id(cpu)) {
+			indx = i + BASE_SYSFS_ATTR_NO;
+			break;
+		}
+	}
+
+	/* Too many cores and this core is not populated, just return */
+	if (indx < 0)
 		return 0;
 
-	pd = platform_get_drvdata(pdev);
 	tdata = pd->core_data[indx];
 
 	cpumask_clear_cpu(cpu, &pd->cpumask);
diff --git a/drivers/i2c/busses/i2c-qcom-cci.c b/drivers/i2c/busses/i2c-qcom-cci.c
index cf54f1cb4c57..2bdb86ab2ea8 100644
--- a/drivers/i2c/busses/i2c-qcom-cci.c
+++ b/drivers/i2c/busses/i2c-qcom-cci.c
@@ -638,6 +638,11 @@ static int cci_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto error;
 
+	pm_runtime_set_autosuspend_delay(dev, MSEC_PER_SEC);
+	pm_runtime_use_autosuspend(dev);
+	pm_runtime_set_active(dev);
+	pm_runtime_enable(dev);
+
 	for (i = 0; i < cci->data->num_masters; i++) {
 		if (!cci->master[i].cci)
 			continue;
@@ -649,14 +654,12 @@ static int cci_probe(struct platform_device *pdev)
 		}
 	}
 
-	pm_runtime_set_autosuspend_delay(dev, MSEC_PER_SEC);
-	pm_runtime_use_autosuspend(dev);
-	pm_runtime_set_active(dev);
-	pm_runtime_enable(dev);
-
 	return 0;
 
 error_i2c:
+	pm_runtime_disable(dev);
+	pm_runtime_dont_use_autosuspend(dev);
+
 	for (--i ; i >= 0; i--) {
 		if (cci->master[i].cci) {
 			i2c_del_adapter(&cci->master[i].adap);
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 71a932017772..b0a975e0a8cb 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -2761,6 +2761,7 @@ static int __init si_domain_init(int hw)
 
 	if (md_domain_init(si_domain, DEFAULT_DOMAIN_ADDRESS_WIDTH)) {
 		domain_exit(si_domain);
+		si_domain = NULL;
 		return -EFAULT;
 	}
 
@@ -3397,6 +3398,10 @@ static int __init init_dmars(void)
 		disable_dmar_iommu(iommu);
 		free_dmar_iommu(iommu);
 	}
+	if (si_domain) {
+		domain_exit(si_domain);
+		si_domain = NULL;
+	}
 
 	kfree(g_iommus);
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 41d2e1285c07..9dd2c2da075d 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1797,7 +1797,6 @@ static struct mapped_device *alloc_dev(int minor)
 	md->disk->first_minor = minor;
 	md->disk->minors = 1;
 	md->disk->fops = &dm_blk_dops;
-	md->disk->queue = md->queue;
 	md->disk->private_data = md;
 	sprintf(md->disk->disk_name, "dm-%d", minor);
 
diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
index 198e47eb63f4..9a4443a390b1 100644
--- a/drivers/media/platform/qcom/venus/vdec.c
+++ b/drivers/media/platform/qcom/venus/vdec.c
@@ -158,6 +158,8 @@ vdec_try_fmt_common(struct venus_inst *inst, struct v4l2_format *f)
 		else
 			return NULL;
 		fmt = find_format(inst, pixmp->pixelformat, f->type);
+		if (!fmt)
+			return NULL;
 	}
 
 	pixmp->width = clamp(pixmp->width, frame_width_min(inst),
diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index deb3db45a94c..391de68365f6 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -1077,7 +1077,7 @@ static int mceusb_set_timeout(struct rc_dev *dev, unsigned int timeout)
 	struct mceusb_dev *ir = dev->priv;
 	unsigned int units;
 
-	units = DIV_ROUND_CLOSEST(timeout, MCE_TIME_UNIT);
+	units = DIV_ROUND_UP(timeout, MCE_TIME_UNIT);
 
 	cmdbuf[2] = units >> 8;
 	cmdbuf[3] = units;
diff --git a/drivers/mmc/core/block.c b/drivers/mmc/core/block.c
index 3222a9d0c245..b2533be3a453 100644
--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -1107,6 +1107,11 @@ static void mmc_blk_issue_discard_rq(struct mmc_queue *mq, struct request *req)
 	nr = blk_rq_sectors(req);
 
 	do {
+		unsigned int erase_arg = card->erase_arg;
+
+		if (mmc_card_broken_sd_discard(card))
+			erase_arg = SD_ERASE_ARG;
+
 		err = 0;
 		if (card->quirks & MMC_QUIRK_INAND_CMD38) {
 			err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
@@ -1117,7 +1122,7 @@ static void mmc_blk_issue_discard_rq(struct mmc_queue *mq, struct request *req)
 					 card->ext_csd.generic_cmd6_time);
 		}
 		if (!err)
-			err = mmc_erase(card, from, nr, card->erase_arg);
+			err = mmc_erase(card, from, nr, erase_arg);
 	} while (err == -EIO && !mmc_blk_reset(md, card->host, type));
 	if (err)
 		status = BLK_STS_IOERR;
diff --git a/drivers/mmc/core/card.h b/drivers/mmc/core/card.h
index 7bd392d55cfa..5c6986131faf 100644
--- a/drivers/mmc/core/card.h
+++ b/drivers/mmc/core/card.h
@@ -70,6 +70,7 @@ struct mmc_fixup {
 #define EXT_CSD_REV_ANY (-1u)
 
 #define CID_MANFID_SANDISK      0x2
+#define CID_MANFID_SANDISK_SD   0x3
 #define CID_MANFID_ATP          0x9
 #define CID_MANFID_TOSHIBA      0x11
 #define CID_MANFID_MICRON       0x13
@@ -222,4 +223,9 @@ static inline int mmc_card_broken_hpi(const struct mmc_card *c)
 	return c->quirks & MMC_QUIRK_BROKEN_HPI;
 }
 
+static inline int mmc_card_broken_sd_discard(const struct mmc_card *c)
+{
+	return c->quirks & MMC_QUIRK_BROKEN_SD_DISCARD;
+}
+
 #endif
diff --git a/drivers/mmc/core/quirks.h b/drivers/mmc/core/quirks.h
index d68e6e513a4f..c8c0f50a2076 100644
--- a/drivers/mmc/core/quirks.h
+++ b/drivers/mmc/core/quirks.h
@@ -99,6 +99,12 @@ static const struct mmc_fixup __maybe_unused mmc_blk_fixups[] = {
 	MMC_FIXUP("V10016", CID_MANFID_KINGSTON, CID_OEMID_ANY, add_quirk_mmc,
 		  MMC_QUIRK_TRIM_BROKEN),
 
+	/*
+	 * Some SD cards reports discard support while they don't
+	 */
+	MMC_FIXUP(CID_NAME_ANY, CID_MANFID_SANDISK_SD, 0x5344, add_quirk_sd,
+		  MMC_QUIRK_BROKEN_SD_DISCARD),
+
 	END_FIXUP
 };
 
diff --git a/drivers/mmc/host/sdhci-tegra.c b/drivers/mmc/host/sdhci-tegra.c
index 9762ffab2e23..829a8bf7c77d 100644
--- a/drivers/mmc/host/sdhci-tegra.c
+++ b/drivers/mmc/host/sdhci-tegra.c
@@ -762,7 +762,7 @@ static void tegra_sdhci_set_clock(struct sdhci_host *host, unsigned int clock)
 	 */
 	host_clk = tegra_host->ddr_signaling ? clock * 2 : clock;
 	clk_set_rate(pltfm_host->clk, host_clk);
-	tegra_host->curr_clk_rate = host_clk;
+	tegra_host->curr_clk_rate = clk_get_rate(pltfm_host->clk);
 	if (tegra_host->ddr_signaling)
 		host->max_clk = host_clk;
 	else
diff --git a/drivers/net/ethernet/hisilicon/hns/hnae.c b/drivers/net/ethernet/hisilicon/hns/hnae.c
index 00fafc0f8512..430eccea8e5e 100644
--- a/drivers/net/ethernet/hisilicon/hns/hnae.c
+++ b/drivers/net/ethernet/hisilicon/hns/hnae.c
@@ -419,8 +419,10 @@ int hnae_ae_register(struct hnae_ae_dev *hdev, struct module *owner)
 	hdev->cls_dev.release = hnae_release;
 	(void)dev_set_name(&hdev->cls_dev, "hnae%d", hdev->id);
 	ret = device_register(&hdev->cls_dev);
-	if (ret)
+	if (ret) {
+		put_device(&hdev->cls_dev);
 		return ret;
+	}
 
 	__module_get(THIS_MODULE);
 
diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index 8e770c5e181e..11a17ebfceef 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -2081,9 +2081,6 @@ static int i40e_set_ringparam(struct net_device *netdev,
 			 */
 			rx_rings[i].tail = hw->hw_addr + I40E_PRTGEN_STATUS;
 			err = i40e_setup_rx_descriptors(&rx_rings[i]);
-			if (err)
-				goto rx_unwind;
-			err = i40e_alloc_rx_bi(&rx_rings[i]);
 			if (err)
 				goto rx_unwind;
 
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 5922520fdb01..ad6f6fe25057 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -3421,12 +3421,8 @@ static int i40e_configure_rx_ring(struct i40e_ring *ring)
 	if (ring->vsi->type == I40E_VSI_MAIN)
 		xdp_rxq_info_unreg_mem_model(&ring->xdp_rxq);
 
-	kfree(ring->rx_bi);
 	ring->xsk_pool = i40e_xsk_pool(ring);
 	if (ring->xsk_pool) {
-		ret = i40e_alloc_rx_bi_zc(ring);
-		if (ret)
-			return ret;
 		ring->rx_buf_len =
 		  xsk_pool_get_rx_frame_size(ring->xsk_pool);
 		/* For AF_XDP ZC, we disallow packets to span on
@@ -3444,9 +3440,6 @@ static int i40e_configure_rx_ring(struct i40e_ring *ring)
 			 ring->queue_index);
 
 	} else {
-		ret = i40e_alloc_rx_bi(ring);
-		if (ret)
-			return ret;
 		ring->rx_buf_len = vsi->rx_buf_len;
 		if (ring->vsi->type == I40E_VSI_MAIN) {
 			ret = xdp_rxq_info_reg_mem_model(&ring->xdp_rxq,
@@ -13161,6 +13154,14 @@ static int i40e_xdp_setup(struct i40e_vsi *vsi, struct bpf_prog *prog,
 		i40e_reset_and_rebuild(pf, true, true);
 	}
 
+	if (!i40e_enabled_xdp_vsi(vsi) && prog) {
+		if (i40e_realloc_rx_bi_zc(vsi, true))
+			return -ENOMEM;
+	} else if (i40e_enabled_xdp_vsi(vsi) && !prog) {
+		if (i40e_realloc_rx_bi_zc(vsi, false))
+			return -ENOMEM;
+	}
+
 	for (i = 0; i < vsi->num_queue_pairs; i++)
 		WRITE_ONCE(vsi->rx_rings[i]->xdp_prog, vsi->xdp_prog);
 
@@ -13393,6 +13394,7 @@ int i40e_queue_pair_disable(struct i40e_vsi *vsi, int queue_pair)
 
 	i40e_queue_pair_disable_irq(vsi, queue_pair);
 	err = i40e_queue_pair_toggle_rings(vsi, queue_pair, false /* off */);
+	i40e_clean_rx_ring(vsi->rx_rings[queue_pair]);
 	i40e_queue_pair_toggle_napi(vsi, queue_pair, false /* off */);
 	i40e_queue_pair_clean_rings(vsi, queue_pair);
 	i40e_queue_pair_reset_stats(vsi, queue_pair);
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index 326fd25d055f..8f5aad9bbba3 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -1459,14 +1459,6 @@ int i40e_setup_tx_descriptors(struct i40e_ring *tx_ring)
 	return -ENOMEM;
 }
 
-int i40e_alloc_rx_bi(struct i40e_ring *rx_ring)
-{
-	unsigned long sz = sizeof(*rx_ring->rx_bi) * rx_ring->count;
-
-	rx_ring->rx_bi = kzalloc(sz, GFP_KERNEL);
-	return rx_ring->rx_bi ? 0 : -ENOMEM;
-}
-
 static void i40e_clear_rx_bi(struct i40e_ring *rx_ring)
 {
 	memset(rx_ring->rx_bi, 0, sizeof(*rx_ring->rx_bi) * rx_ring->count);
@@ -1597,6 +1589,11 @@ int i40e_setup_rx_descriptors(struct i40e_ring *rx_ring)
 
 	rx_ring->xdp_prog = rx_ring->vsi->xdp_prog;
 
+	rx_ring->rx_bi =
+		kcalloc(rx_ring->count, sizeof(*rx_ring->rx_bi), GFP_KERNEL);
+	if (!rx_ring->rx_bi)
+		return -ENOMEM;
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.h b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
index f6d91fa1562e..f3b0b8151709 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
@@ -466,7 +466,6 @@ int __i40e_maybe_stop_tx(struct i40e_ring *tx_ring, int size);
 bool __i40e_chk_linearize(struct sk_buff *skb);
 int i40e_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
 		  u32 flags);
-int i40e_alloc_rx_bi(struct i40e_ring *rx_ring);
 
 /**
  * i40e_get_head - Retrieve head from head writeback
diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 54c91dc459dd..7e50b8fff9b5 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -10,14 +10,6 @@
 #include "i40e_txrx_common.h"
 #include "i40e_xsk.h"
 
-int i40e_alloc_rx_bi_zc(struct i40e_ring *rx_ring)
-{
-	unsigned long sz = sizeof(*rx_ring->rx_bi_zc) * rx_ring->count;
-
-	rx_ring->rx_bi_zc = kzalloc(sz, GFP_KERNEL);
-	return rx_ring->rx_bi_zc ? 0 : -ENOMEM;
-}
-
 void i40e_clear_rx_bi_zc(struct i40e_ring *rx_ring)
 {
 	memset(rx_ring->rx_bi_zc, 0,
@@ -29,6 +21,58 @@ static struct xdp_buff **i40e_rx_bi(struct i40e_ring *rx_ring, u32 idx)
 	return &rx_ring->rx_bi_zc[idx];
 }
 
+/**
+ * i40e_realloc_rx_xdp_bi - reallocate SW ring for either XSK or normal buffer
+ * @rx_ring: Current rx ring
+ * @pool_present: is pool for XSK present
+ *
+ * Try allocating memory and return ENOMEM, if failed to allocate.
+ * If allocation was successful, substitute buffer with allocated one.
+ * Returns 0 on success, negative on failure
+ */
+static int i40e_realloc_rx_xdp_bi(struct i40e_ring *rx_ring, bool pool_present)
+{
+	size_t elem_size = pool_present ? sizeof(*rx_ring->rx_bi_zc) :
+					  sizeof(*rx_ring->rx_bi);
+	void *sw_ring = kcalloc(rx_ring->count, elem_size, GFP_KERNEL);
+
+	if (!sw_ring)
+		return -ENOMEM;
+
+	if (pool_present) {
+		kfree(rx_ring->rx_bi);
+		rx_ring->rx_bi = NULL;
+		rx_ring->rx_bi_zc = sw_ring;
+	} else {
+		kfree(rx_ring->rx_bi_zc);
+		rx_ring->rx_bi_zc = NULL;
+		rx_ring->rx_bi = sw_ring;
+	}
+	return 0;
+}
+
+/**
+ * i40e_realloc_rx_bi_zc - reallocate rx SW rings
+ * @vsi: Current VSI
+ * @zc: is zero copy set
+ *
+ * Reallocate buffer for rx_rings that might be used by XSK.
+ * XDP requires more memory, than rx_buf provides.
+ * Returns 0 on success, negative on failure
+ */
+int i40e_realloc_rx_bi_zc(struct i40e_vsi *vsi, bool zc)
+{
+	struct i40e_ring *rx_ring;
+	unsigned long q;
+
+	for_each_set_bit(q, vsi->af_xdp_zc_qps, vsi->alloc_queue_pairs) {
+		rx_ring = vsi->rx_rings[q];
+		if (i40e_realloc_rx_xdp_bi(rx_ring, zc))
+			return -ENOMEM;
+	}
+	return 0;
+}
+
 /**
  * i40e_xsk_pool_enable - Enable/associate an AF_XDP buffer pool to a
  * certain ring/qid
@@ -69,6 +113,10 @@ static int i40e_xsk_pool_enable(struct i40e_vsi *vsi,
 		if (err)
 			return err;
 
+		err = i40e_realloc_rx_xdp_bi(vsi->rx_rings[qid], true);
+		if (err)
+			return err;
+
 		err = i40e_queue_pair_enable(vsi, qid);
 		if (err)
 			return err;
@@ -113,6 +161,9 @@ static int i40e_xsk_pool_disable(struct i40e_vsi *vsi, u16 qid)
 	xsk_pool_dma_unmap(pool, I40E_RX_DMA_ATTR);
 
 	if (if_running) {
+		err = i40e_realloc_rx_xdp_bi(vsi->rx_rings[qid], false);
+		if (err)
+			return err;
 		err = i40e_queue_pair_enable(vsi, qid);
 		if (err)
 			return err;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.h b/drivers/net/ethernet/intel/i40e/i40e_xsk.h
index ea88f4597a07..75103c992269 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.h
@@ -33,7 +33,7 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget);
 
 bool i40e_clean_xdp_tx_irq(struct i40e_vsi *vsi, struct i40e_ring *tx_ring);
 int i40e_xsk_wakeup(struct net_device *dev, u32 queue_id, u32 flags);
-int i40e_alloc_rx_bi_zc(struct i40e_ring *rx_ring);
+int i40e_realloc_rx_bi_zc(struct i40e_vsi *vsi, bool zc);
 void i40e_clear_rx_bi_zc(struct i40e_ring *rx_ring);
 
 #endif /* _I40E_XSK_H_ */
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index c713a3ee6571..886c997a3ad1 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -2880,11 +2880,15 @@ int ionic_reconfigure_queues(struct ionic_lif *lif,
 	 * than the full array, but leave the qcq shells in place
 	 */
 	for (i = lif->nxqs; i < lif->ionic->ntxqs_per_lif; i++) {
-		lif->txqcqs[i]->flags &= ~IONIC_QCQ_F_INTR;
-		ionic_qcq_free(lif, lif->txqcqs[i]);
+		if (lif->txqcqs && lif->txqcqs[i]) {
+			lif->txqcqs[i]->flags &= ~IONIC_QCQ_F_INTR;
+			ionic_qcq_free(lif, lif->txqcqs[i]);
+		}
 
-		lif->rxqcqs[i]->flags &= ~IONIC_QCQ_F_INTR;
-		ionic_qcq_free(lif, lif->rxqcqs[i]);
+		if (lif->rxqcqs && lif->rxqcqs[i]) {
+			lif->rxqcqs[i]->flags &= ~IONIC_QCQ_F_INTR;
+			ionic_qcq_free(lif, lif->rxqcqs[i]);
+		}
 	}
 
 	if (err)
diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index 056c24ec1249..c316a9eb5be3 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -3271,6 +3271,30 @@ static int efx_ef10_set_mac_address(struct efx_nic *efx)
 	bool was_enabled = efx->port_enabled;
 	int rc;
 
+#ifdef CONFIG_SFC_SRIOV
+	/* If this function is a VF and we have access to the parent PF,
+	 * then use the PF control path to attempt to change the VF MAC address.
+	 */
+	if (efx->pci_dev->is_virtfn && efx->pci_dev->physfn) {
+		struct efx_nic *efx_pf = pci_get_drvdata(efx->pci_dev->physfn);
+		struct efx_ef10_nic_data *nic_data = efx->nic_data;
+		u8 mac[ETH_ALEN];
+
+		/* net_dev->dev_addr can be zeroed by efx_net_stop in
+		 * efx_ef10_sriov_set_vf_mac, so pass in a copy.
+		 */
+		ether_addr_copy(mac, efx->net_dev->dev_addr);
+
+		rc = efx_ef10_sriov_set_vf_mac(efx_pf, nic_data->vf_index, mac);
+		if (!rc)
+			return 0;
+
+		netif_dbg(efx, drv, efx->net_dev,
+			  "Updating VF mac via PF failed (%d), setting directly\n",
+			  rc);
+	}
+#endif
+
 	efx_device_detach_sync(efx);
 	efx_net_stop(efx->net_dev);
 
@@ -3293,40 +3317,6 @@ static int efx_ef10_set_mac_address(struct efx_nic *efx)
 		efx_net_open(efx->net_dev);
 	efx_device_attach_if_not_resetting(efx);
 
-#ifdef CONFIG_SFC_SRIOV
-	if (efx->pci_dev->is_virtfn && efx->pci_dev->physfn) {
-		struct efx_ef10_nic_data *nic_data = efx->nic_data;
-		struct pci_dev *pci_dev_pf = efx->pci_dev->physfn;
-
-		if (rc == -EPERM) {
-			struct efx_nic *efx_pf;
-
-			/* Switch to PF and change MAC address on vport */
-			efx_pf = pci_get_drvdata(pci_dev_pf);
-
-			rc = efx_ef10_sriov_set_vf_mac(efx_pf,
-						       nic_data->vf_index,
-						       efx->net_dev->dev_addr);
-		} else if (!rc) {
-			struct efx_nic *efx_pf = pci_get_drvdata(pci_dev_pf);
-			struct efx_ef10_nic_data *nic_data = efx_pf->nic_data;
-			unsigned int i;
-
-			/* MAC address successfully changed by VF (with MAC
-			 * spoofing) so update the parent PF if possible.
-			 */
-			for (i = 0; i < efx_pf->vf_count; ++i) {
-				struct ef10_vf *vf = nic_data->vf + i;
-
-				if (vf->efx == efx) {
-					ether_addr_copy(vf->mac,
-							efx->net_dev->dev_addr);
-					return 0;
-				}
-			}
-		}
-	} else
-#endif
 	if (rc == -EPERM) {
 		netif_err(efx, drv, efx->net_dev,
 			  "Cannot change MAC address; use sfboot to enable"
diff --git a/drivers/net/ethernet/sfc/filter.h b/drivers/net/ethernet/sfc/filter.h
index 40b2af8bfb81..2ac3c8f1b04b 100644
--- a/drivers/net/ethernet/sfc/filter.h
+++ b/drivers/net/ethernet/sfc/filter.h
@@ -157,7 +157,8 @@ struct efx_filter_spec {
 	u32	flags:6;
 	u32	dmaq_id:12;
 	u32	rss_context;
-	__be16	outer_vid __aligned(4); /* allow jhash2() of match values */
+	u32	vport_id;
+	__be16	outer_vid;
 	__be16	inner_vid;
 	u8	loc_mac[ETH_ALEN];
 	u8	rem_mac[ETH_ALEN];
diff --git a/drivers/net/ethernet/sfc/rx_common.c b/drivers/net/ethernet/sfc/rx_common.c
index b925de9b4302..a804c754cd7d 100644
--- a/drivers/net/ethernet/sfc/rx_common.c
+++ b/drivers/net/ethernet/sfc/rx_common.c
@@ -676,17 +676,17 @@ bool efx_filter_spec_equal(const struct efx_filter_spec *left,
 	     (EFX_FILTER_FLAG_RX | EFX_FILTER_FLAG_TX)))
 		return false;
 
-	return memcmp(&left->outer_vid, &right->outer_vid,
+	return memcmp(&left->vport_id, &right->vport_id,
 		      sizeof(struct efx_filter_spec) -
-		      offsetof(struct efx_filter_spec, outer_vid)) == 0;
+		      offsetof(struct efx_filter_spec, vport_id)) == 0;
 }
 
 u32 efx_filter_spec_hash(const struct efx_filter_spec *spec)
 {
-	BUILD_BUG_ON(offsetof(struct efx_filter_spec, outer_vid) & 3);
-	return jhash2((const u32 *)&spec->outer_vid,
+	BUILD_BUG_ON(offsetof(struct efx_filter_spec, vport_id) & 3);
+	return jhash2((const u32 *)&spec->vport_id,
 		      (sizeof(struct efx_filter_spec) -
-		       offsetof(struct efx_filter_spec, outer_vid)) / 4,
+		       offsetof(struct efx_filter_spec, vport_id)) / 4,
 		      0);
 }
 
diff --git a/drivers/net/phy/dp83822.c b/drivers/net/phy/dp83822.c
index a792dd6d2ec3..0b511abb5422 100644
--- a/drivers/net/phy/dp83822.c
+++ b/drivers/net/phy/dp83822.c
@@ -253,8 +253,7 @@ static int dp83822_config_intr(struct phy_device *phydev)
 				DP83822_EEE_ERROR_CHANGE_INT_EN);
 
 		if (!dp83822->fx_enabled)
-			misr_status |= DP83822_MDI_XOVER_INT_EN |
-				       DP83822_ANEG_ERR_INT_EN |
+			misr_status |= DP83822_ANEG_ERR_INT_EN |
 				       DP83822_WOL_PKT_INT_EN;
 
 		err = phy_write(phydev, MII_DP83822_MISR2, misr_status);
diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index d097097c93c3..783e30451e30 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -791,6 +791,14 @@ static int dp83867_config_init(struct phy_device *phydev)
 		else
 			val &= ~DP83867_SGMII_TYPE;
 		phy_write_mmd(phydev, DP83867_DEVADDR, DP83867_SGMIICTL, val);
+
+		/* This is a SW workaround for link instability if RX_CTRL is
+		 * not strapped to mode 3 or 4 in HW. This is required for SGMII
+		 * in addition to clearing bit 7, handled above.
+		 */
+		if (dp83867->rxctrl_strap_quirk)
+			phy_set_bits_mmd(phydev, DP83867_DEVADDR, DP83867_CFG4,
+					 BIT(8));
 	}
 
 	val = phy_read(phydev, DP83867_CFG3);
diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index fef1416dcee4..7afcf6310d59 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1050,6 +1050,9 @@ static int phylink_bringup_phy(struct phylink *pl, struct phy_device *phy,
 	if (phy_interrupt_is_valid(phy))
 		phy_request_interrupt(phy);
 
+	if (pl->config->mac_managed_pm)
+		phy->mac_managed_pm = true;
+
 	return 0;
 }
 
diff --git a/drivers/net/usb/cdc_ether.c b/drivers/net/usb/cdc_ether.c
index 9b4dfa3001d6..c6b0de1b752f 100644
--- a/drivers/net/usb/cdc_ether.c
+++ b/drivers/net/usb/cdc_ether.c
@@ -776,6 +776,13 @@ static const struct usb_device_id	products[] = {
 },
 #endif
 
+/* Lenovo ThinkPad OneLink+ Dock (based on Realtek RTL8153) */
+{
+	USB_DEVICE_AND_INTERFACE_INFO(LENOVO_VENDOR_ID, 0x3054, USB_CLASS_COMM,
+			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
+	.driver_info = 0,
+},
+
 /* ThinkPad USB-C Dock (based on Realtek RTL8153) */
 {
 	USB_DEVICE_AND_INTERFACE_INFO(LENOVO_VENDOR_ID, 0x3062, USB_CLASS_COMM,
diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index c7169243aa6e..109c288d8b47 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -770,6 +770,7 @@ enum rtl8152_flags {
 	RX_EPROTO,
 };
 
+#define DEVICE_ID_THINKPAD_ONELINK_PLUS_DOCK		0x3054
 #define DEVICE_ID_THINKPAD_THUNDERBOLT3_DOCK_GEN2	0x3082
 #define DEVICE_ID_THINKPAD_USB_C_DOCK_GEN2		0xa387
 
@@ -9651,6 +9652,7 @@ static int rtl8152_probe(struct usb_interface *intf,
 
 	if (le16_to_cpu(udev->descriptor.idVendor) == VENDOR_ID_LENOVO) {
 		switch (le16_to_cpu(udev->descriptor.idProduct)) {
+		case DEVICE_ID_THINKPAD_ONELINK_PLUS_DOCK:
 		case DEVICE_ID_THINKPAD_THUNDERBOLT3_DOCK_GEN2:
 		case DEVICE_ID_THINKPAD_USB_C_DOCK_GEN2:
 			tp->lenovo_macpassthru = 1;
@@ -9809,6 +9811,7 @@ static const struct usb_device_id rtl8152_table[] = {
 	REALTEK_USB_DEVICE(VENDOR_ID_MICROSOFT, 0x0927),
 	REALTEK_USB_DEVICE(VENDOR_ID_SAMSUNG, 0xa101),
 	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x304f),
+	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x3054),
 	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x3062),
 	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x3069),
 	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x3082),
diff --git a/drivers/net/wwan/wwan_hwsim.c b/drivers/net/wwan/wwan_hwsim.c
index 5b62cf3b3c42..a4230a7376df 100644
--- a/drivers/net/wwan/wwan_hwsim.c
+++ b/drivers/net/wwan/wwan_hwsim.c
@@ -310,7 +310,7 @@ static struct wwan_hwsim_dev *wwan_hwsim_dev_new(void)
 	return ERR_PTR(err);
 
 err_free_dev:
-	kfree(dev);
+	put_device(&dev->dev);
 
 	return ERR_PTR(err);
 }
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 3527a0667568..92fe67bd2457 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3088,8 +3088,12 @@ int nvme_init_ctrl_finish(struct nvme_ctrl *ctrl)
 		return ret;
 
 	if (!ctrl->identified && !nvme_discovery_ctrl(ctrl)) {
+		/*
+		 * Do not return errors unless we are in a controller reset,
+		 * the controller works perfectly fine without hwmon.
+		 */
 		ret = nvme_hwmon_init(ctrl);
-		if (ret < 0)
+		if (ret == -EINTR)
 			return ret;
 	}
 
diff --git a/drivers/nvme/host/hwmon.c b/drivers/nvme/host/hwmon.c
index 0a586d712920..9e6e56c20ec9 100644
--- a/drivers/nvme/host/hwmon.c
+++ b/drivers/nvme/host/hwmon.c
@@ -12,7 +12,7 @@
 
 struct nvme_hwmon_data {
 	struct nvme_ctrl *ctrl;
-	struct nvme_smart_log log;
+	struct nvme_smart_log *log;
 	struct mutex read_lock;
 };
 
@@ -60,14 +60,14 @@ static int nvme_set_temp_thresh(struct nvme_ctrl *ctrl, int sensor, bool under,
 static int nvme_hwmon_get_smart_log(struct nvme_hwmon_data *data)
 {
 	return nvme_get_log(data->ctrl, NVME_NSID_ALL, NVME_LOG_SMART, 0,
-			   NVME_CSI_NVM, &data->log, sizeof(data->log), 0);
+			   NVME_CSI_NVM, data->log, sizeof(*data->log), 0);
 }
 
 static int nvme_hwmon_read(struct device *dev, enum hwmon_sensor_types type,
 			   u32 attr, int channel, long *val)
 {
 	struct nvme_hwmon_data *data = dev_get_drvdata(dev);
-	struct nvme_smart_log *log = &data->log;
+	struct nvme_smart_log *log = data->log;
 	int temp;
 	int err;
 
@@ -163,7 +163,7 @@ static umode_t nvme_hwmon_is_visible(const void *_data,
 	case hwmon_temp_max:
 	case hwmon_temp_min:
 		if ((!channel && data->ctrl->wctemp) ||
-		    (channel && data->log.temp_sensor[channel - 1])) {
+		    (channel && data->log->temp_sensor[channel - 1])) {
 			if (data->ctrl->quirks &
 			    NVME_QUIRK_NO_TEMP_THRESH_CHANGE)
 				return 0444;
@@ -176,7 +176,7 @@ static umode_t nvme_hwmon_is_visible(const void *_data,
 		break;
 	case hwmon_temp_input:
 	case hwmon_temp_label:
-		if (!channel || data->log.temp_sensor[channel - 1])
+		if (!channel || data->log->temp_sensor[channel - 1])
 			return 0444;
 		break;
 	default:
@@ -230,7 +230,13 @@ int nvme_hwmon_init(struct nvme_ctrl *ctrl)
 
 	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (!data)
-		return 0;
+		return -ENOMEM;
+
+	data->log = kzalloc(sizeof(*data->log), GFP_KERNEL);
+	if (!data->log) {
+		err = -ENOMEM;
+		goto err_free_data;
+	}
 
 	data->ctrl = ctrl;
 	mutex_init(&data->read_lock);
@@ -238,8 +244,7 @@ int nvme_hwmon_init(struct nvme_ctrl *ctrl)
 	err = nvme_hwmon_get_smart_log(data);
 	if (err) {
 		dev_warn(dev, "Failed to read smart log (error %d)\n", err);
-		kfree(data);
-		return err;
+		goto err_free_log;
 	}
 
 	hwmon = hwmon_device_register_with_info(dev, "nvme",
@@ -247,11 +252,17 @@ int nvme_hwmon_init(struct nvme_ctrl *ctrl)
 						NULL);
 	if (IS_ERR(hwmon)) {
 		dev_warn(dev, "Failed to instantiate hwmon device\n");
-		kfree(data);
-		return PTR_ERR(hwmon);
+		err = PTR_ERR(hwmon);
+		goto err_free_log;
 	}
 	ctrl->hwmon_device = hwmon;
 	return 0;
+
+err_free_log:
+	kfree(data->log);
+err_free_data:
+	kfree(data);
+	return err;
 }
 
 void nvme_hwmon_exit(struct nvme_ctrl *ctrl)
@@ -262,6 +273,7 @@ void nvme_hwmon_exit(struct nvme_ctrl *ctrl)
 
 		hwmon_device_unregister(ctrl->hwmon_device);
 		ctrl->hwmon_device = NULL;
+		kfree(data->log);
 		kfree(data);
 	}
 }
diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index 0a0c1d956c73..87a347248c38 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -1168,7 +1168,7 @@ static void nvmet_start_ctrl(struct nvmet_ctrl *ctrl)
 	 * reset the keep alive timer when the controller is enabled.
 	 */
 	if (ctrl->kato)
-		mod_delayed_work(system_wq, &ctrl->ka_work, ctrl->kato * HZ);
+		mod_delayed_work(nvmet_wq, &ctrl->ka_work, ctrl->kato * HZ);
 }
 
 static void nvmet_clear_ctrl(struct nvmet_ctrl *ctrl)
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 33e33fff8986..48043e1ba485 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -4666,7 +4666,7 @@ lpfc_create_port(struct lpfc_hba *phba, int instance, struct device *dev)
 	rc = lpfc_vmid_res_alloc(phba, vport);
 
 	if (rc)
-		goto out;
+		goto out_put_shost;
 
 	/* Initialize all internally managed lists. */
 	INIT_LIST_HEAD(&vport->fc_nodes);
@@ -4684,16 +4684,17 @@ lpfc_create_port(struct lpfc_hba *phba, int instance, struct device *dev)
 
 	error = scsi_add_host_with_dma(shost, dev, &phba->pcidev->dev);
 	if (error)
-		goto out_put_shost;
+		goto out_free_vmid;
 
 	spin_lock_irq(&phba->port_list_lock);
 	list_add_tail(&vport->listentry, &phba->port_list);
 	spin_unlock_irq(&phba->port_list_lock);
 	return vport;
 
-out_put_shost:
+out_free_vmid:
 	kfree(vport->vmid);
 	bitmap_free(vport->vmid_priority_range);
+out_put_shost:
 	scsi_host_put(shost);
 out:
 	return NULL;
diff --git a/drivers/staging/media/ipu3/ipu3-v4l2.c b/drivers/staging/media/ipu3/ipu3-v4l2.c
index 90c86ba5040e..f0e61c1b6ffd 100644
--- a/drivers/staging/media/ipu3/ipu3-v4l2.c
+++ b/drivers/staging/media/ipu3/ipu3-v4l2.c
@@ -192,33 +192,30 @@ static int imgu_subdev_get_selection(struct v4l2_subdev *sd,
 				     struct v4l2_subdev_state *sd_state,
 				     struct v4l2_subdev_selection *sel)
 {
-	struct v4l2_rect *try_sel, *r;
-	struct imgu_v4l2_subdev *imgu_sd = container_of(sd,
-							struct imgu_v4l2_subdev,
-							subdev);
+	struct imgu_v4l2_subdev *imgu_sd =
+		container_of(sd, struct imgu_v4l2_subdev, subdev);
 
 	if (sel->pad != IMGU_NODE_IN)
 		return -EINVAL;
 
 	switch (sel->target) {
 	case V4L2_SEL_TGT_CROP:
-		try_sel = v4l2_subdev_get_try_crop(sd, sd_state, sel->pad);
-		r = &imgu_sd->rect.eff;
-		break;
+		if (sel->which == V4L2_SUBDEV_FORMAT_TRY)
+			sel->r = *v4l2_subdev_get_try_crop(sd, sd_state,
+							   sel->pad);
+		else
+			sel->r = imgu_sd->rect.eff;
+		return 0;
 	case V4L2_SEL_TGT_COMPOSE:
-		try_sel = v4l2_subdev_get_try_compose(sd, sd_state, sel->pad);
-		r = &imgu_sd->rect.bds;
-		break;
+		if (sel->which == V4L2_SUBDEV_FORMAT_TRY)
+			sel->r = *v4l2_subdev_get_try_compose(sd, sd_state,
+							      sel->pad);
+		else
+			sel->r = imgu_sd->rect.bds;
+		return 0;
 	default:
 		return -EINVAL;
 	}
-
-	if (sel->which == V4L2_SUBDEV_FORMAT_TRY)
-		sel->r = *try_sel;
-	else
-		sel->r = *r;
-
-	return 0;
 }
 
 static int imgu_subdev_set_selection(struct v4l2_subdev *sd,
diff --git a/drivers/usb/gadget/function/uvc.h b/drivers/usb/gadget/function/uvc.h
index 0966c5aa2492..d1a4ef74742b 100644
--- a/drivers/usb/gadget/function/uvc.h
+++ b/drivers/usb/gadget/function/uvc.h
@@ -69,6 +69,8 @@ extern unsigned int uvc_gadget_trace_param;
 #define UVC_MAX_REQUEST_SIZE			64
 #define UVC_MAX_EVENTS				4
 
+#define UVCG_REQUEST_HEADER_LEN			2
+
 /* ------------------------------------------------------------------------
  * Structures
  */
@@ -77,7 +79,8 @@ struct uvc_request {
 	u8 *req_buffer;
 	struct uvc_video *video;
 	struct sg_table sgt;
-	u8 header[2];
+	u8 header[UVCG_REQUEST_HEADER_LEN];
+	struct uvc_buffer *last_buf;
 };
 
 struct uvc_video {
diff --git a/drivers/usb/gadget/function/uvc_queue.c b/drivers/usb/gadget/function/uvc_queue.c
index a64b842665b9..ec299f5cc65a 100644
--- a/drivers/usb/gadget/function/uvc_queue.c
+++ b/drivers/usb/gadget/function/uvc_queue.c
@@ -335,33 +335,22 @@ int uvcg_queue_enable(struct uvc_video_queue *queue, int enable)
 }
 
 /* called with &queue_irqlock held.. */
-struct uvc_buffer *uvcg_queue_next_buffer(struct uvc_video_queue *queue,
+void uvcg_complete_buffer(struct uvc_video_queue *queue,
 					  struct uvc_buffer *buf)
 {
-	struct uvc_buffer *nextbuf;
-
 	if ((queue->flags & UVC_QUEUE_DROP_INCOMPLETE) &&
 	     buf->length != buf->bytesused) {
 		buf->state = UVC_BUF_STATE_QUEUED;
 		vb2_set_plane_payload(&buf->buf.vb2_buf, 0, 0);
-		return buf;
+		return;
 	}
 
-	list_del(&buf->queue);
-	if (!list_empty(&queue->irqqueue))
-		nextbuf = list_first_entry(&queue->irqqueue, struct uvc_buffer,
-					   queue);
-	else
-		nextbuf = NULL;
-
 	buf->buf.field = V4L2_FIELD_NONE;
 	buf->buf.sequence = queue->sequence++;
 	buf->buf.vb2_buf.timestamp = ktime_get_ns();
 
 	vb2_set_plane_payload(&buf->buf.vb2_buf, 0, buf->bytesused);
 	vb2_buffer_done(&buf->buf.vb2_buf, VB2_BUF_STATE_DONE);
-
-	return nextbuf;
 }
 
 struct uvc_buffer *uvcg_queue_head(struct uvc_video_queue *queue)
diff --git a/drivers/usb/gadget/function/uvc_queue.h b/drivers/usb/gadget/function/uvc_queue.h
index 05360a0767f6..b668927b5d2c 100644
--- a/drivers/usb/gadget/function/uvc_queue.h
+++ b/drivers/usb/gadget/function/uvc_queue.h
@@ -93,7 +93,7 @@ void uvcg_queue_cancel(struct uvc_video_queue *queue, int disconnect);
 
 int uvcg_queue_enable(struct uvc_video_queue *queue, int enable);
 
-struct uvc_buffer *uvcg_queue_next_buffer(struct uvc_video_queue *queue,
+void uvcg_complete_buffer(struct uvc_video_queue *queue,
 					  struct uvc_buffer *buf);
 
 struct uvc_buffer *uvcg_queue_head(struct uvc_video_queue *queue);
diff --git a/drivers/usb/gadget/function/uvc_video.c b/drivers/usb/gadget/function/uvc_video.c
index e170e88abf3a..1889d75f8788 100644
--- a/drivers/usb/gadget/function/uvc_video.c
+++ b/drivers/usb/gadget/function/uvc_video.c
@@ -33,7 +33,7 @@ uvc_video_encode_header(struct uvc_video *video, struct uvc_buffer *buf,
 	if (buf->bytesused - video->queue.buf_used <= len - UVCG_REQUEST_HEADER_LEN)
 		data[1] |= UVC_STREAM_EOF;
 
-	return 2;
+	return UVCG_REQUEST_HEADER_LEN;
 }
 
 static int
@@ -83,7 +83,8 @@ uvc_video_encode_bulk(struct usb_request *req, struct uvc_video *video,
 	if (buf->bytesused == video->queue.buf_used) {
 		video->queue.buf_used = 0;
 		buf->state = UVC_BUF_STATE_DONE;
-		uvcg_queue_next_buffer(&video->queue, buf);
+		list_del(&buf->queue);
+		uvcg_complete_buffer(&video->queue, buf);
 		video->fid ^= UVC_STREAM_FID;
 
 		video->payload_size = 0;
@@ -104,28 +105,28 @@ uvc_video_encode_isoc_sg(struct usb_request *req, struct uvc_video *video,
 	unsigned int len = video->req_size;
 	unsigned int sg_left, part = 0;
 	unsigned int i;
-	int ret;
+	int header_len;
 
 	sg = ureq->sgt.sgl;
 	sg_init_table(sg, ureq->sgt.nents);
 
 	/* Init the header. */
-	ret = uvc_video_encode_header(video, buf, ureq->header,
+	header_len = uvc_video_encode_header(video, buf, ureq->header,
 				      video->req_size);
-	sg_set_buf(sg, ureq->header, UVCG_REQUEST_HEADER_LEN);
-	len -= ret;
+	sg_set_buf(sg, ureq->header, header_len);
+	len -= header_len;
 
 	if (pending <= len)
 		len = pending;
 
 	req->length = (len == pending) ?
-		len + UVCG_REQUEST_HEADER_LEN : video->req_size;
+		len + header_len : video->req_size;
 
 	/* Init the pending sgs with payload */
 	sg = sg_next(sg);
 
 	for_each_sg(sg, iter, ureq->sgt.nents - 1, i) {
-		if (!len || !buf->sg)
+		if (!len || !buf->sg || !sg_dma_len(buf->sg))
 			break;
 
 		sg_left = sg_dma_len(buf->sg) - buf->offset;
@@ -148,14 +149,15 @@ uvc_video_encode_isoc_sg(struct usb_request *req, struct uvc_video *video,
 	req->num_sgs = i + 1;
 
 	req->length -= len;
-	video->queue.buf_used += req->length - UVCG_REQUEST_HEADER_LEN;
+	video->queue.buf_used += req->length - header_len;
 
 	if (buf->bytesused == video->queue.buf_used || !buf->sg) {
 		video->queue.buf_used = 0;
 		buf->state = UVC_BUF_STATE_DONE;
 		buf->offset = 0;
-		uvcg_queue_next_buffer(&video->queue, buf);
+		list_del(&buf->queue);
 		video->fid ^= UVC_STREAM_FID;
+		ureq->last_buf = buf;
 	}
 }
 
@@ -181,7 +183,8 @@ uvc_video_encode_isoc(struct usb_request *req, struct uvc_video *video,
 	if (buf->bytesused == video->queue.buf_used) {
 		video->queue.buf_used = 0;
 		buf->state = UVC_BUF_STATE_DONE;
-		uvcg_queue_next_buffer(&video->queue, buf);
+		list_del(&buf->queue);
+		uvcg_complete_buffer(&video->queue, buf);
 		video->fid ^= UVC_STREAM_FID;
 	}
 }
@@ -231,6 +234,11 @@ uvc_video_complete(struct usb_ep *ep, struct usb_request *req)
 		uvcg_queue_cancel(queue, 0);
 	}
 
+	if (ureq->last_buf) {
+		uvcg_complete_buffer(&video->queue, ureq->last_buf);
+		ureq->last_buf = NULL;
+	}
+
 	spin_lock_irqsave(&video->req_lock, flags);
 	list_add_tail(&req->list, &video->req_free);
 	spin_unlock_irqrestore(&video->req_lock, flags);
@@ -298,12 +306,13 @@ uvc_video_alloc_requests(struct uvc_video *video)
 		video->ureq[i].req->complete = uvc_video_complete;
 		video->ureq[i].req->context = &video->ureq[i];
 		video->ureq[i].video = video;
+		video->ureq[i].last_buf = NULL;
 
 		list_add_tail(&video->ureq[i].req->list, &video->req_free);
 		/* req_size/PAGE_SIZE + 1 for overruns and + 1 for header */
 		sg_alloc_table(&video->ureq[i].sgt,
-			       DIV_ROUND_UP(req_size - 2, PAGE_SIZE) + 2,
-			       GFP_KERNEL);
+			       DIV_ROUND_UP(req_size - UVCG_REQUEST_HEADER_LEN,
+					    PAGE_SIZE) + 2, GFP_KERNEL);
 	}
 
 	video->req_size = req_size;
diff --git a/drivers/usb/gadget/function/uvc_video.h b/drivers/usb/gadget/function/uvc_video.h
index 9bf19475f6f9..03adeefa343b 100644
--- a/drivers/usb/gadget/function/uvc_video.h
+++ b/drivers/usb/gadget/function/uvc_video.h
@@ -12,8 +12,6 @@
 #ifndef __UVC_VIDEO_H__
 #define __UVC_VIDEO_H__
 
-#define UVCG_REQUEST_HEADER_LEN			2
-
 struct uvc_video;
 
 int uvcg_video_enable(struct uvc_video *video, int enable);
diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 8b090c40daf7..2e7c3e48bc9c 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -138,6 +138,7 @@ struct share_check {
 	u64 root_objectid;
 	u64 inum;
 	int share_count;
+	bool have_delayed_delete_refs;
 };
 
 static inline int extent_is_shared(struct share_check *sc)
@@ -818,16 +819,11 @@ static int add_delayed_refs(const struct btrfs_fs_info *fs_info,
 			    struct preftrees *preftrees, struct share_check *sc)
 {
 	struct btrfs_delayed_ref_node *node;
-	struct btrfs_delayed_extent_op *extent_op = head->extent_op;
 	struct btrfs_key key;
-	struct btrfs_key tmp_op_key;
 	struct rb_node *n;
 	int count;
 	int ret = 0;
 
-	if (extent_op && extent_op->update_key)
-		btrfs_disk_key_to_cpu(&tmp_op_key, &extent_op->key);
-
 	spin_lock(&head->lock);
 	for (n = rb_first_cached(&head->ref_tree); n; n = rb_next(n)) {
 		node = rb_entry(n, struct btrfs_delayed_ref_node,
@@ -853,10 +849,16 @@ static int add_delayed_refs(const struct btrfs_fs_info *fs_info,
 		case BTRFS_TREE_BLOCK_REF_KEY: {
 			/* NORMAL INDIRECT METADATA backref */
 			struct btrfs_delayed_tree_ref *ref;
+			struct btrfs_key *key_ptr = NULL;
+
+			if (head->extent_op && head->extent_op->update_key) {
+				btrfs_disk_key_to_cpu(&key, &head->extent_op->key);
+				key_ptr = &key;
+			}
 
 			ref = btrfs_delayed_node_to_tree_ref(node);
 			ret = add_indirect_ref(fs_info, preftrees, ref->root,
-					       &tmp_op_key, ref->level + 1,
+					       key_ptr, ref->level + 1,
 					       node->bytenr, count, sc,
 					       GFP_ATOMIC);
 			break;
@@ -882,13 +884,22 @@ static int add_delayed_refs(const struct btrfs_fs_info *fs_info,
 			key.offset = ref->offset;
 
 			/*
-			 * Found a inum that doesn't match our known inum, we
-			 * know it's shared.
+			 * If we have a share check context and a reference for
+			 * another inode, we can't exit immediately. This is
+			 * because even if this is a BTRFS_ADD_DELAYED_REF
+			 * reference we may find next a BTRFS_DROP_DELAYED_REF
+			 * which cancels out this ADD reference.
+			 *
+			 * If this is a DROP reference and there was no previous
+			 * ADD reference, then we need to signal that when we
+			 * process references from the extent tree (through
+			 * add_inline_refs() and add_keyed_refs()), we should
+			 * not exit early if we find a reference for another
+			 * inode, because one of the delayed DROP references
+			 * may cancel that reference in the extent tree.
 			 */
-			if (sc && sc->inum && ref->objectid != sc->inum) {
-				ret = BACKREF_FOUND_SHARED;
-				goto out;
-			}
+			if (sc && count < 0)
+				sc->have_delayed_delete_refs = true;
 
 			ret = add_indirect_ref(fs_info, preftrees, ref->root,
 					       &key, 0, node->bytenr, count, sc,
@@ -918,7 +929,7 @@ static int add_delayed_refs(const struct btrfs_fs_info *fs_info,
 	}
 	if (!ret)
 		ret = extent_is_shared(sc);
-out:
+
 	spin_unlock(&head->lock);
 	return ret;
 }
@@ -1021,7 +1032,8 @@ static int add_inline_refs(const struct btrfs_fs_info *fs_info,
 			key.type = BTRFS_EXTENT_DATA_KEY;
 			key.offset = btrfs_extent_data_ref_offset(leaf, dref);
 
-			if (sc && sc->inum && key.objectid != sc->inum) {
+			if (sc && sc->inum && key.objectid != sc->inum &&
+			    !sc->have_delayed_delete_refs) {
 				ret = BACKREF_FOUND_SHARED;
 				break;
 			}
@@ -1031,6 +1043,7 @@ static int add_inline_refs(const struct btrfs_fs_info *fs_info,
 			ret = add_indirect_ref(fs_info, preftrees, root,
 					       &key, 0, bytenr, count,
 					       sc, GFP_NOFS);
+
 			break;
 		}
 		default:
@@ -1120,7 +1133,8 @@ static int add_keyed_refs(struct btrfs_fs_info *fs_info,
 			key.type = BTRFS_EXTENT_DATA_KEY;
 			key.offset = btrfs_extent_data_ref_offset(leaf, dref);
 
-			if (sc && sc->inum && key.objectid != sc->inum) {
+			if (sc && sc->inum && key.objectid != sc->inum &&
+			    !sc->have_delayed_delete_refs) {
 				ret = BACKREF_FOUND_SHARED;
 				break;
 			}
@@ -1547,6 +1561,7 @@ int btrfs_check_shared(struct btrfs_root *root, u64 inum, u64 bytenr,
 		.root_objectid = root->root_key.objectid,
 		.inum = inum,
 		.share_count = 0,
+		.have_delayed_delete_refs = false,
 	};
 
 	ulist_init(roots);
@@ -1581,6 +1596,7 @@ int btrfs_check_shared(struct btrfs_root *root, u64 inum, u64 bytenr,
 			break;
 		bytenr = node->val;
 		shared.share_count = 0;
+		shared.have_delayed_delete_refs = false;
 		cond_resched();
 	}
 
diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 474dcc0540a8..5eea56789ccc 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -2139,7 +2139,16 @@ int btrfs_read_block_groups(struct btrfs_fs_info *info)
 	int need_clear = 0;
 	u64 cache_gen;
 
-	if (!info->extent_root)
+	/*
+	 * Either no extent root (with ibadroots rescue option) or we have
+	 * unsupported RO options. The fs can never be mounted read-write, so no
+	 * need to waste time searching block group items.
+	 *
+	 * This also allows new extent tree related changes to be RO compat,
+	 * no need for a full incompat flag.
+	 */
+	if (!info->extent_root || (btrfs_super_compat_ro_flags(info->super_copy) &
+		      ~BTRFS_FEATURE_COMPAT_RO_SUPP))
 		return fill_dummy_bgs(info);
 
 	key.objectid = 0;
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 442fcd1b14a6..61b84391be58 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2048,6 +2048,15 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 			ret = -EINVAL;
 			goto restore;
 		}
+		if (btrfs_super_compat_ro_flags(fs_info->super_copy) &
+		    ~BTRFS_FEATURE_COMPAT_RO_SUPP) {
+			btrfs_err(fs_info,
+		"can not remount read-write due to unsupported optional flags 0x%llx",
+				btrfs_super_compat_ro_flags(fs_info->super_copy) &
+				~BTRFS_FEATURE_COMPAT_RO_SUPP);
+			ret = -EINVAL;
+			goto restore;
+		}
 		if (fs_info->fs_devices->rw_devices == 0) {
 			ret = -EACCES;
 			goto restore;
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 8ec55bbd705d..668dd6a86295 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -1263,8 +1263,11 @@ static ssize_t cifs_copy_file_range(struct file *src_file, loff_t off,
 	ssize_t rc;
 	struct cifsFileInfo *cfile = dst_file->private_data;
 
-	if (cfile->swapfile)
-		return -EOPNOTSUPP;
+	if (cfile->swapfile) {
+		rc = -EOPNOTSUPP;
+		free_xid(xid);
+		return rc;
+	}
 
 	rc = cifs_file_copychunk_range(xid, src_file, off, dst_file, destoff,
 					len, flags);
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 6e8e7cc26ae2..83c929dd6ed5 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -538,8 +538,10 @@ int cifs_create(struct user_namespace *mnt_userns, struct inode *inode,
 	cifs_dbg(FYI, "cifs_create parent inode = 0x%p name is: %pd and dentry = 0x%p\n",
 		 inode, direntry, direntry);
 
-	if (unlikely(cifs_forced_shutdown(CIFS_SB(inode->i_sb))))
-		return -EIO;
+	if (unlikely(cifs_forced_shutdown(CIFS_SB(inode->i_sb)))) {
+		rc = -EIO;
+		goto out_free_xid;
+	}
 
 	tlink = cifs_sb_tlink(CIFS_SB(inode->i_sb));
 	rc = PTR_ERR(tlink);
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index ffec3a2f995d..aa422348824a 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1806,11 +1806,13 @@ int cifs_flock(struct file *file, int cmd, struct file_lock *fl)
 	struct cifsFileInfo *cfile;
 	__u32 type;
 
-	rc = -EACCES;
 	xid = get_xid();
 
-	if (!(fl->fl_flags & FL_FLOCK))
-		return -ENOLCK;
+	if (!(fl->fl_flags & FL_FLOCK)) {
+		rc = -ENOLCK;
+		free_xid(xid);
+		return rc;
+	}
 
 	cfile = (struct cifsFileInfo *)file->private_data;
 	tcon = tlink_tcon(cfile->tlink);
@@ -1829,8 +1831,9 @@ int cifs_flock(struct file *file, int cmd, struct file_lock *fl)
 		 * if no lock or unlock then nothing to do since we do not
 		 * know what it is
 		 */
+		rc = -EOPNOTSUPP;
 		free_xid(xid);
-		return -EOPNOTSUPP;
+		return rc;
 	}
 
 	rc = cifs_setlk(file, fl, type, wait_flag, posix_lck, lock, unlock,
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 5500ea783784..0fbd0f78f361 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -320,6 +320,7 @@ cifs_ses_add_channel(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses,
 	if (rc && chan->server)
 		cifs_put_tcp_session(chan->server, 0);
 
+	free_xid(xid);
 	return rc;
 }
 
diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index bcc7127c4c0a..862cb7a353c1 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -3632,7 +3632,7 @@ static void send_args(struct dlm_rsb *r, struct dlm_lkb *lkb,
 	case DLM_MSG_REQUEST_REPLY:
 	case DLM_MSG_CONVERT_REPLY:
 	case DLM_MSG_GRANT:
-		if (!lkb->lkb_lvbptr)
+		if (!lkb->lkb_lvbptr || !(lkb->lkb_exflags & DLM_LKF_VALBLK))
 			break;
 		memcpy(ms->m_extra, lkb->lkb_lvbptr, r->res_ls->ls_lvblen);
 		break;
diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index bec9a84572c0..65c85ca71ebe 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -3803,11 +3803,6 @@ static int __query_dir(struct dir_context *ctx, const char *name, int namlen,
 	return 0;
 }
 
-static void restart_ctx(struct dir_context *ctx)
-{
-	ctx->pos = 0;
-}
-
 static int verify_info_level(int info_level)
 {
 	switch (info_level) {
@@ -3921,7 +3916,6 @@ int smb2_query_dir(struct ksmbd_work *work)
 	if (srch_flag & SMB2_REOPEN || srch_flag & SMB2_RESTART_SCANS) {
 		ksmbd_debug(SMB, "Restart directory scan\n");
 		generic_file_llseek(dir_fp->filp, 0, SEEK_SET);
-		restart_ctx(&dir_fp->readdir_data.ctx);
 	}
 
 	memset(&d_info, 0, sizeof(struct ksmbd_dir_info));
@@ -3962,11 +3956,15 @@ int smb2_query_dir(struct ksmbd_work *work)
 	set_ctx_actor(&dir_fp->readdir_data.ctx, __query_dir);
 
 	rc = iterate_dir(dir_fp->filp, &dir_fp->readdir_data.ctx);
-	if (rc == 0)
-		restart_ctx(&dir_fp->readdir_data.ctx);
-	if (rc == -ENOSPC)
+	/*
+	 * req->OutputBufferLength is too small to contain even one entry.
+	 * In this case, it immediately returns OutputBufferLength 0 to client.
+	 */
+	if (!d_info.out_buf_len && !d_info.num_entry)
+		goto no_buf_len;
+	if (rc > 0 || rc == -ENOSPC)
 		rc = 0;
-	if (rc)
+	else if (rc)
 		goto err_out;
 
 	d_info.wptr = d_info.rptr;
@@ -3988,10 +3986,12 @@ int smb2_query_dir(struct ksmbd_work *work)
 		rsp->Buffer[0] = 0;
 		inc_rfc1001_len(rsp_org, 9);
 	} else {
+no_buf_len:
 		((struct file_directory_info *)
 		((char *)rsp->Buffer + d_info.last_entry_offset))
 		->NextEntryOffset = 0;
-		d_info.data_count -= d_info.last_entry_off_align;
+		if (d_info.data_count >= d_info.last_entry_off_align)
+			d_info.data_count -= d_info.last_entry_off_align;
 
 		rsp->StructureSize = cpu_to_le16(9);
 		rsp->OutputBufferOffset = cpu_to_le16(72);
@@ -4021,6 +4021,8 @@ int smb2_query_dir(struct ksmbd_work *work)
 		rsp->hdr.Status = STATUS_NO_MEMORY;
 	else if (rc == -EFAULT)
 		rsp->hdr.Status = STATUS_INVALID_INFO_CLASS;
+	else if (rc == -EIO)
+		rsp->hdr.Status = STATUS_FILE_CORRUPT_ERROR;
 	if (!rsp->hdr.Status)
 		rsp->hdr.Status = STATUS_UNEXPECTED_IO_ERROR;
 
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 2c46ff6ba4ea..11807034dd48 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -231,6 +231,7 @@ static int ocfs2_mknod(struct user_namespace *mnt_userns,
 	handle_t *handle = NULL;
 	struct ocfs2_super *osb;
 	struct ocfs2_dinode *dirfe;
+	struct ocfs2_dinode *fe = NULL;
 	struct buffer_head *new_fe_bh = NULL;
 	struct inode *inode = NULL;
 	struct ocfs2_alloc_context *inode_ac = NULL;
@@ -381,6 +382,7 @@ static int ocfs2_mknod(struct user_namespace *mnt_userns,
 		goto leave;
 	}
 
+	fe = (struct ocfs2_dinode *) new_fe_bh->b_data;
 	if (S_ISDIR(mode)) {
 		status = ocfs2_fill_new_dir(osb, handle, dir, inode,
 					    new_fe_bh, data_ac, meta_ac);
@@ -453,8 +455,11 @@ static int ocfs2_mknod(struct user_namespace *mnt_userns,
 leave:
 	if (status < 0 && did_quota_inode)
 		dquot_free_inode(inode);
-	if (handle)
+	if (handle) {
+		if (status < 0 && fe)
+			ocfs2_set_links_count(fe, 0);
 		ocfs2_commit_trans(osb, handle);
+	}
 
 	ocfs2_inode_unlock(dir, 1);
 	if (did_block_signals)
@@ -631,18 +636,9 @@ static int ocfs2_mknod_locked(struct ocfs2_super *osb,
 		return status;
 	}
 
-	status = __ocfs2_mknod_locked(dir, inode, dev, new_fe_bh,
+	return __ocfs2_mknod_locked(dir, inode, dev, new_fe_bh,
 				    parent_fe_bh, handle, inode_ac,
 				    fe_blkno, suballoc_loc, suballoc_bit);
-	if (status < 0) {
-		u64 bg_blkno = ocfs2_which_suballoc_group(fe_blkno, suballoc_bit);
-		int tmp = ocfs2_free_suballoc_bits(handle, inode_ac->ac_inode,
-				inode_ac->ac_bh, suballoc_bit, bg_blkno, 1);
-		if (tmp)
-			mlog_errno(tmp);
-	}
-
-	return status;
 }
 
 static int ocfs2_mkdir(struct user_namespace *mnt_userns,
@@ -2027,8 +2023,11 @@ static int ocfs2_symlink(struct user_namespace *mnt_userns,
 					ocfs2_clusters_to_bytes(osb->sb, 1));
 	if (status < 0 && did_quota_inode)
 		dquot_free_inode(inode);
-	if (handle)
+	if (handle) {
+		if (status < 0 && fe)
+			ocfs2_set_links_count(fe, 0);
 		ocfs2_commit_trans(osb, handle);
+	}
 
 	ocfs2_inode_unlock(dir, 1);
 	if (did_block_signals)
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index d9c07eecd787..c3b76746cce8 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -951,7 +951,7 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
 		vma = vma->vm_next;
 	}
 
-	show_vma_header_prefix(m, priv->mm->mmap->vm_start,
+	show_vma_header_prefix(m, priv->mm->mmap ? priv->mm->mmap->vm_start : 0,
 			       last_vma_end, 0, 0, 0, 0);
 	seq_pad(m, ' ');
 	seq_puts(m, "[rollup]\n");
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 725f8f13adb5..7e2423ffaf59 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1124,6 +1124,8 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 			    struct kvm_enable_cap *cap);
 long kvm_arch_vm_ioctl(struct file *filp,
 		       unsigned int ioctl, unsigned long arg);
+long kvm_arch_vm_compat_ioctl(struct file *filp, unsigned int ioctl,
+			      unsigned long arg);
 
 int kvm_arch_vcpu_ioctl_get_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu);
 int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu);
diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
index 37f975875102..12c7f2d3e210 100644
--- a/include/linux/mmc/card.h
+++ b/include/linux/mmc/card.h
@@ -292,6 +292,7 @@ struct mmc_card {
 #define MMC_QUIRK_BROKEN_IRQ_POLLING	(1<<11)	/* Polling SDIO_CCCR_INTx could create a fake interrupt */
 #define MMC_QUIRK_TRIM_BROKEN	(1<<12)		/* Skip trim */
 #define MMC_QUIRK_BROKEN_HPI	(1<<13)		/* Disable broken HPI support */
+#define MMC_QUIRK_BROKEN_SD_DISCARD	(1<<14)	/* Disable broken SD discard support */
 
 	bool			reenable_cmdq;	/* Re-enable Command Queue */
 
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index 237291196ce2..b306159c1fad 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -64,6 +64,7 @@ enum phylink_op_type {
  * @pcs_poll: MAC PCS cannot provide link change interrupt
  * @poll_fixed_state: if true, starts link_poll,
  *		      if MAC link is at %MLO_AN_FIXED mode.
+ * @mac_managed_pm: if true, indicate the MAC driver is responsible for PHY PM.
  * @ovr_an_inband: if true, override PCS to MLO_AN_INBAND
  * @get_fixed_state: callback to execute to determine the fixed link state,
  *		     if MAC link is at %MLO_AN_FIXED mode.
@@ -73,6 +74,7 @@ struct phylink_config {
 	enum phylink_op_type type;
 	bool pcs_poll;
 	bool poll_fixed_state;
+	bool mac_managed_pm;
 	bool ovr_an_inband;
 	void (*get_fixed_state)(struct phylink_config *config,
 				struct phylink_link_state *state);
diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 1958d1260fe9..891b44d80c98 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -1177,7 +1177,6 @@ static inline void __qdisc_reset_queue(struct qdisc_skb_head *qh)
 static inline void qdisc_reset_queue(struct Qdisc *sch)
 {
 	__qdisc_reset_queue(&sch->q);
-	sch->qstats.backlog = 0;
 }
 
 static inline struct Qdisc *qdisc_replace(struct Qdisc *sch, struct Qdisc *new,
diff --git a/include/net/sock_reuseport.h b/include/net/sock_reuseport.h
index 473b0b0fa4ab..efc9085c6892 100644
--- a/include/net/sock_reuseport.h
+++ b/include/net/sock_reuseport.h
@@ -43,21 +43,20 @@ struct sock *reuseport_migrate_sock(struct sock *sk,
 extern int reuseport_attach_prog(struct sock *sk, struct bpf_prog *prog);
 extern int reuseport_detach_prog(struct sock *sk);
 
-static inline bool reuseport_has_conns(struct sock *sk, bool set)
+static inline bool reuseport_has_conns(struct sock *sk)
 {
 	struct sock_reuseport *reuse;
 	bool ret = false;
 
 	rcu_read_lock();
 	reuse = rcu_dereference(sk->sk_reuseport_cb);
-	if (reuse) {
-		if (set)
-			reuse->has_conns = 1;
-		ret = reuse->has_conns;
-	}
+	if (reuse && reuse->has_conns)
+		ret = true;
 	rcu_read_unlock();
 
 	return ret;
 }
 
+void reuseport_has_conns_set(struct sock *sk);
+
 #endif  /* _SOCK_REUSEPORT_H */
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 0dc17fd96102..24a5ea9a2cc0 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -6399,12 +6399,12 @@ int tracing_set_tracer(struct trace_array *tr, const char *buf)
 	if (tr->current_trace->reset)
 		tr->current_trace->reset(tr);
 
+#ifdef CONFIG_TRACER_MAX_TRACE
+	had_max_tr = tr->current_trace->use_max_tr;
+
 	/* Current trace needs to be nop_trace before synchronize_rcu */
 	tr->current_trace = &nop_trace;
 
-#ifdef CONFIG_TRACER_MAX_TRACE
-	had_max_tr = tr->allocated_snapshot;
-
 	if (had_max_tr && !t->use_max_tr) {
 		/*
 		 * We need to make sure that the update_max_tr sees that
@@ -6416,14 +6416,14 @@ int tracing_set_tracer(struct trace_array *tr, const char *buf)
 		synchronize_rcu();
 		free_snapshot(tr);
 	}
-#endif
 
-#ifdef CONFIG_TRACER_MAX_TRACE
-	if (t->use_max_tr && !had_max_tr) {
+	if (t->use_max_tr && !tr->allocated_snapshot) {
 		ret = tracing_alloc_snapshot_instance(tr);
 		if (ret < 0)
 			goto out;
 	}
+#else
+	tr->current_trace = &nop_trace;
 #endif
 
 	if (t->init) {
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 23085498f5c8..f5f8929fad51 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2813,11 +2813,11 @@ struct page *alloc_huge_page(struct vm_area_struct *vma,
 		page = alloc_buddy_huge_page_with_mpol(h, vma, addr);
 		if (!page)
 			goto out_uncharge_cgroup;
+		spin_lock_irq(&hugetlb_lock);
 		if (!avoid_reserve && vma_has_reserves(vma, gbl_chg)) {
 			SetHPageRestoreReserve(page);
 			h->resv_huge_pages--;
 		}
-		spin_lock_irq(&hugetlb_lock);
 		list_add(&page->lru, &h->hugepage_activelist);
 		/* Fall through */
 	}
diff --git a/net/atm/mpoa_proc.c b/net/atm/mpoa_proc.c
index 829db9eba0cb..aaf64b953915 100644
--- a/net/atm/mpoa_proc.c
+++ b/net/atm/mpoa_proc.c
@@ -219,11 +219,12 @@ static ssize_t proc_mpc_write(struct file *file, const char __user *buff,
 	if (!page)
 		return -ENOMEM;
 
-	for (p = page, len = 0; len < nbytes; p++, len++) {
+	for (p = page, len = 0; len < nbytes; p++) {
 		if (get_user(*p, buff++)) {
 			free_page((unsigned long)page);
 			return -EFAULT;
 		}
+		len += 1;
 		if (*p == '\0' || *p == '\n')
 			break;
 	}
diff --git a/net/core/sock_reuseport.c b/net/core/sock_reuseport.c
index 5daa1fa54249..fb90e1e00773 100644
--- a/net/core/sock_reuseport.c
+++ b/net/core/sock_reuseport.c
@@ -21,6 +21,22 @@ static DEFINE_IDA(reuseport_ida);
 static int reuseport_resurrect(struct sock *sk, struct sock_reuseport *old_reuse,
 			       struct sock_reuseport *reuse, bool bind_inany);
 
+void reuseport_has_conns_set(struct sock *sk)
+{
+	struct sock_reuseport *reuse;
+
+	if (!rcu_access_pointer(sk->sk_reuseport_cb))
+		return;
+
+	spin_lock_bh(&reuseport_lock);
+	reuse = rcu_dereference_protected(sk->sk_reuseport_cb,
+					  lockdep_is_held(&reuseport_lock));
+	if (likely(reuse))
+		reuse->has_conns = 1;
+	spin_unlock_bh(&reuseport_lock);
+}
+EXPORT_SYMBOL(reuseport_has_conns_set);
+
 static int reuseport_sock_index(struct sock *sk,
 				const struct sock_reuseport *reuse,
 				bool closed)
diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
index ceb8afb2a62f..13f81c246f5f 100644
--- a/net/hsr/hsr_forward.c
+++ b/net/hsr/hsr_forward.c
@@ -108,15 +108,15 @@ struct sk_buff *hsr_get_untagged_frame(struct hsr_frame_info *frame,
 				       struct hsr_port *port)
 {
 	if (!frame->skb_std) {
-		if (frame->skb_hsr) {
+		if (frame->skb_hsr)
 			frame->skb_std =
 				create_stripped_skb_hsr(frame->skb_hsr, frame);
-		} else {
-			/* Unexpected */
-			WARN_ONCE(1, "%s:%d: Unexpected frame received (port_src %s)\n",
-				  __FILE__, __LINE__, port->dev->name);
+		else
+			netdev_warn_once(port->dev,
+					 "Unexpected frame received in hsr_get_untagged_frame()\n");
+
+		if (!frame->skb_std)
 			return NULL;
-		}
 	}
 
 	return skb_clone(frame->skb_std, GFP_ATOMIC);
diff --git a/net/ipv4/datagram.c b/net/ipv4/datagram.c
index 4a8550c49202..112c6e892d30 100644
--- a/net/ipv4/datagram.c
+++ b/net/ipv4/datagram.c
@@ -70,7 +70,7 @@ int __ip4_datagram_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len
 	}
 	inet->inet_daddr = fl4->daddr;
 	inet->inet_dport = usin->sin_port;
-	reuseport_has_conns(sk, true);
+	reuseport_has_conns_set(sk);
 	sk->sk_state = TCP_ESTABLISHED;
 	sk_set_txhash(sk);
 	inet->inet_id = prandom_u32();
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 75d1977ecc07..79d5425bed07 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -446,7 +446,7 @@ static struct sock *udp4_lib_lookup2(struct net *net,
 			result = lookup_reuseport(net, sk, skb,
 						  saddr, sport, daddr, hnum);
 			/* Fall back to scoring if group has connections */
-			if (result && !reuseport_has_conns(sk, false))
+			if (result && !reuseport_has_conns(sk))
 				return result;
 
 			result = result ? : sk;
diff --git a/net/ipv6/datagram.c b/net/ipv6/datagram.c
index 206f66310a88..f4559e5bc84b 100644
--- a/net/ipv6/datagram.c
+++ b/net/ipv6/datagram.c
@@ -256,7 +256,7 @@ int __ip6_datagram_connect(struct sock *sk, struct sockaddr *uaddr,
 		goto out;
 	}
 
-	reuseport_has_conns(sk, true);
+	reuseport_has_conns_set(sk);
 	sk->sk_state = TCP_ESTABLISHED;
 	sk_set_txhash(sk);
 out:
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 07726a51a3f0..19b6c4da0f42 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -180,7 +180,7 @@ static struct sock *udp6_lib_lookup2(struct net *net,
 			result = lookup_reuseport(net, sk, skb,
 						  saddr, sport, daddr, hnum);
 			/* Fall back to scoring if group has connections */
-			if (result && !reuseport_has_conns(sk, false))
+			if (result && !reuseport_has_conns(sk))
 				return result;
 
 			result = result ? : sk;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 460ad341d160..f7a5b8414423 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5720,8 +5720,9 @@ static bool nft_setelem_valid_key_end(const struct nft_set *set,
 			  (NFT_SET_CONCAT | NFT_SET_INTERVAL)) {
 		if (flags & NFT_SET_ELEM_INTERVAL_END)
 			return false;
-		if (!nla[NFTA_SET_ELEM_KEY_END] &&
-		    !(flags & NFT_SET_ELEM_CATCHALL))
+
+		if (nla[NFTA_SET_ELEM_KEY_END] &&
+		    flags & NFT_SET_ELEM_CATCHALL)
 			return false;
 	} else {
 		if (nla[NFTA_SET_ELEM_KEY_END])
diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index 0fb387c9d706..5ab20c764aa5 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -1081,12 +1081,13 @@ static int qdisc_graft(struct net_device *dev, struct Qdisc *parent,
 
 skip:
 		if (!ingress) {
-			notify_and_destroy(net, skb, n, classid,
-					   rtnl_dereference(dev->qdisc), new);
+			old = rtnl_dereference(dev->qdisc);
 			if (new && !new->ops->attach)
 				qdisc_refcount_inc(new);
 			rcu_assign_pointer(dev->qdisc, new ? : &noop_qdisc);
 
+			notify_and_destroy(net, skb, n, classid, old, new);
+
 			if (new && new->ops->attach)
 				new->ops->attach(new);
 		} else {
diff --git a/net/sched/sch_atm.c b/net/sched/sch_atm.c
index 7d8518176b45..70fe1c5e44ad 100644
--- a/net/sched/sch_atm.c
+++ b/net/sched/sch_atm.c
@@ -576,7 +576,6 @@ static void atm_tc_reset(struct Qdisc *sch)
 	pr_debug("atm_tc_reset(sch %p,[qdisc %p])\n", sch, p);
 	list_for_each_entry(flow, &p->flows, list)
 		qdisc_reset(flow->q);
-	sch->q.qlen = 0;
 }
 
 static void atm_tc_destroy(struct Qdisc *sch)
diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index 857aaebd49f4..6f6e74ce927f 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -2224,8 +2224,12 @@ static struct sk_buff *cake_dequeue(struct Qdisc *sch)
 
 static void cake_reset(struct Qdisc *sch)
 {
+	struct cake_sched_data *q = qdisc_priv(sch);
 	u32 c;
 
+	if (!q->tins)
+		return;
+
 	for (c = 0; c < CAKE_MAX_TINS; c++)
 		cake_clear_tin(sch, c);
 }
diff --git a/net/sched/sch_cbq.c b/net/sched/sch_cbq.c
index e0da15530f0e..fd7e10567371 100644
--- a/net/sched/sch_cbq.c
+++ b/net/sched/sch_cbq.c
@@ -1053,7 +1053,6 @@ cbq_reset(struct Qdisc *sch)
 			cl->cpriority = cl->priority;
 		}
 	}
-	sch->q.qlen = 0;
 }
 
 
diff --git a/net/sched/sch_choke.c b/net/sched/sch_choke.c
index 2adbd945bf15..25d2daaa8122 100644
--- a/net/sched/sch_choke.c
+++ b/net/sched/sch_choke.c
@@ -315,8 +315,6 @@ static void choke_reset(struct Qdisc *sch)
 		rtnl_qdisc_drop(skb, sch);
 	}
 
-	sch->q.qlen = 0;
-	sch->qstats.backlog = 0;
 	if (q->tab)
 		memset(q->tab, 0, (q->tab_mask + 1) * sizeof(struct sk_buff *));
 	q->head = q->tail = 0;
diff --git a/net/sched/sch_drr.c b/net/sched/sch_drr.c
index 642cd179b7a7..80a88e208d2b 100644
--- a/net/sched/sch_drr.c
+++ b/net/sched/sch_drr.c
@@ -444,8 +444,6 @@ static void drr_reset_qdisc(struct Qdisc *sch)
 			qdisc_reset(cl->qdisc);
 		}
 	}
-	sch->qstats.backlog = 0;
-	sch->q.qlen = 0;
 }
 
 static void drr_destroy_qdisc(struct Qdisc *sch)
diff --git a/net/sched/sch_dsmark.c b/net/sched/sch_dsmark.c
index 4c100d105269..7da6dc38a382 100644
--- a/net/sched/sch_dsmark.c
+++ b/net/sched/sch_dsmark.c
@@ -409,8 +409,6 @@ static void dsmark_reset(struct Qdisc *sch)
 	pr_debug("%s(sch %p,[qdisc %p])\n", __func__, sch, p);
 	if (p->q)
 		qdisc_reset(p->q);
-	sch->qstats.backlog = 0;
-	sch->q.qlen = 0;
 }
 
 static void dsmark_destroy(struct Qdisc *sch)
diff --git a/net/sched/sch_etf.c b/net/sched/sch_etf.c
index c48f91075b5c..d96103b0e2bf 100644
--- a/net/sched/sch_etf.c
+++ b/net/sched/sch_etf.c
@@ -445,9 +445,6 @@ static void etf_reset(struct Qdisc *sch)
 	timesortedlist_clear(sch);
 	__qdisc_reset_queue(&sch->q);
 
-	sch->qstats.backlog = 0;
-	sch->q.qlen = 0;
-
 	q->last = 0;
 }
 
diff --git a/net/sched/sch_ets.c b/net/sched/sch_ets.c
index 44fa2532a87c..175e07b3d25c 100644
--- a/net/sched/sch_ets.c
+++ b/net/sched/sch_ets.c
@@ -722,8 +722,6 @@ static void ets_qdisc_reset(struct Qdisc *sch)
 	}
 	for (band = 0; band < q->nbands; band++)
 		qdisc_reset(q->classes[band].qdisc);
-	sch->qstats.backlog = 0;
-	sch->q.qlen = 0;
 }
 
 static void ets_qdisc_destroy(struct Qdisc *sch)
diff --git a/net/sched/sch_fq_codel.c b/net/sched/sch_fq_codel.c
index bb0cd6d3d2c2..efda894bbb78 100644
--- a/net/sched/sch_fq_codel.c
+++ b/net/sched/sch_fq_codel.c
@@ -347,8 +347,6 @@ static void fq_codel_reset(struct Qdisc *sch)
 		codel_vars_init(&flow->cvars);
 	}
 	memset(q->backlogs, 0, q->flows_cnt * sizeof(u32));
-	sch->q.qlen = 0;
-	sch->qstats.backlog = 0;
 	q->memory_usage = 0;
 }
 
diff --git a/net/sched/sch_fq_pie.c b/net/sched/sch_fq_pie.c
index d6aba6edd16e..35c35465226b 100644
--- a/net/sched/sch_fq_pie.c
+++ b/net/sched/sch_fq_pie.c
@@ -521,9 +521,6 @@ static void fq_pie_reset(struct Qdisc *sch)
 		INIT_LIST_HEAD(&flow->flowchain);
 		pie_vars_init(&flow->vars);
 	}
-
-	sch->q.qlen = 0;
-	sch->qstats.backlog = 0;
 }
 
 static void fq_pie_destroy(struct Qdisc *sch)
diff --git a/net/sched/sch_hfsc.c b/net/sched/sch_hfsc.c
index b7ac30cca035..c802a027b4f3 100644
--- a/net/sched/sch_hfsc.c
+++ b/net/sched/sch_hfsc.c
@@ -1485,8 +1485,6 @@ hfsc_reset_qdisc(struct Qdisc *sch)
 	}
 	q->eligible = RB_ROOT;
 	qdisc_watchdog_cancel(&q->watchdog);
-	sch->qstats.backlog = 0;
-	sch->q.qlen = 0;
 }
 
 static void
diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index 5cbc32fee867..caabdaa2f30f 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -1008,8 +1008,6 @@ static void htb_reset(struct Qdisc *sch)
 	}
 	qdisc_watchdog_cancel(&q->watchdog);
 	__qdisc_reset_queue(&q->direct_queue);
-	sch->q.qlen = 0;
-	sch->qstats.backlog = 0;
 	memset(q->hlevel, 0, sizeof(q->hlevel));
 	memset(q->row_mask, 0, sizeof(q->row_mask));
 }
diff --git a/net/sched/sch_multiq.c b/net/sched/sch_multiq.c
index e282e7382117..8b99f07aa3a7 100644
--- a/net/sched/sch_multiq.c
+++ b/net/sched/sch_multiq.c
@@ -152,7 +152,6 @@ multiq_reset(struct Qdisc *sch)
 
 	for (band = 0; band < q->bands; band++)
 		qdisc_reset(q->queues[band]);
-	sch->q.qlen = 0;
 	q->curband = 0;
 }
 
diff --git a/net/sched/sch_prio.c b/net/sched/sch_prio.c
index 03fdf31ccb6a..2e0b1e7f5466 100644
--- a/net/sched/sch_prio.c
+++ b/net/sched/sch_prio.c
@@ -135,8 +135,6 @@ prio_reset(struct Qdisc *sch)
 
 	for (prio = 0; prio < q->bands; prio++)
 		qdisc_reset(q->queues[prio]);
-	sch->qstats.backlog = 0;
-	sch->q.qlen = 0;
 }
 
 static int prio_offload(struct Qdisc *sch, struct tc_prio_qopt *qopt)
diff --git a/net/sched/sch_qfq.c b/net/sched/sch_qfq.c
index aea435b0aeb3..50e51c1322fc 100644
--- a/net/sched/sch_qfq.c
+++ b/net/sched/sch_qfq.c
@@ -1459,8 +1459,6 @@ static void qfq_reset_qdisc(struct Qdisc *sch)
 			qdisc_reset(cl->qdisc);
 		}
 	}
-	sch->qstats.backlog = 0;
-	sch->q.qlen = 0;
 }
 
 static void qfq_destroy_qdisc(struct Qdisc *sch)
diff --git a/net/sched/sch_red.c b/net/sched/sch_red.c
index 40adf1f07a82..f1e013e3f04a 100644
--- a/net/sched/sch_red.c
+++ b/net/sched/sch_red.c
@@ -176,8 +176,6 @@ static void red_reset(struct Qdisc *sch)
 	struct red_sched_data *q = qdisc_priv(sch);
 
 	qdisc_reset(q->qdisc);
-	sch->qstats.backlog = 0;
-	sch->q.qlen = 0;
 	red_restart(&q->vars);
 }
 
diff --git a/net/sched/sch_sfb.c b/net/sched/sch_sfb.c
index 2829455211f8..0490eb5b98de 100644
--- a/net/sched/sch_sfb.c
+++ b/net/sched/sch_sfb.c
@@ -455,9 +455,8 @@ static void sfb_reset(struct Qdisc *sch)
 {
 	struct sfb_sched_data *q = qdisc_priv(sch);
 
-	qdisc_reset(q->qdisc);
-	sch->qstats.backlog = 0;
-	sch->q.qlen = 0;
+	if (likely(q->qdisc))
+		qdisc_reset(q->qdisc);
 	q->slot = 0;
 	q->double_buffering = false;
 	sfb_zero_all_buckets(q);
diff --git a/net/sched/sch_skbprio.c b/net/sched/sch_skbprio.c
index 7a5e4c454715..df72fb83d9c7 100644
--- a/net/sched/sch_skbprio.c
+++ b/net/sched/sch_skbprio.c
@@ -213,9 +213,6 @@ static void skbprio_reset(struct Qdisc *sch)
 	struct skbprio_sched_data *q = qdisc_priv(sch);
 	int prio;
 
-	sch->qstats.backlog = 0;
-	sch->q.qlen = 0;
-
 	for (prio = 0; prio < SKBPRIO_MAX_PRIORITY; prio++)
 		__skb_queue_purge(&q->qdiscs[prio]);
 
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index ae7ca68f2cf9..bd10a8eeb82d 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1637,8 +1637,6 @@ static void taprio_reset(struct Qdisc *sch)
 			if (q->qdiscs[i])
 				qdisc_reset(q->qdiscs[i]);
 	}
-	sch->qstats.backlog = 0;
-	sch->q.qlen = 0;
 }
 
 static void taprio_destroy(struct Qdisc *sch)
diff --git a/net/sched/sch_tbf.c b/net/sched/sch_tbf.c
index 6eb17004a9e4..7461e5c67d50 100644
--- a/net/sched/sch_tbf.c
+++ b/net/sched/sch_tbf.c
@@ -316,8 +316,6 @@ static void tbf_reset(struct Qdisc *sch)
 	struct tbf_sched_data *q = qdisc_priv(sch);
 
 	qdisc_reset(q->qdisc);
-	sch->qstats.backlog = 0;
-	sch->q.qlen = 0;
 	q->t_c = ktime_get_ns();
 	q->tokens = q->buffer;
 	q->ptokens = q->mtu;
diff --git a/net/sched/sch_teql.c b/net/sched/sch_teql.c
index 6af6b95bdb67..79aaab51cbf5 100644
--- a/net/sched/sch_teql.c
+++ b/net/sched/sch_teql.c
@@ -124,7 +124,6 @@ teql_reset(struct Qdisc *sch)
 	struct teql_sched_data *dat = qdisc_priv(sch);
 
 	skb_queue_purge(&dat->q);
-	sch->q.qlen = 0;
 }
 
 static void
diff --git a/net/tipc/discover.c b/net/tipc/discover.c
index da69e1abf68f..e8630707901e 100644
--- a/net/tipc/discover.c
+++ b/net/tipc/discover.c
@@ -148,8 +148,8 @@ static bool tipc_disc_addr_trial_msg(struct tipc_discoverer *d,
 {
 	struct net *net = d->net;
 	struct tipc_net *tn = tipc_net(net);
-	bool trial = time_before(jiffies, tn->addr_trial_end);
 	u32 self = tipc_own_addr(net);
+	bool trial = time_before(jiffies, tn->addr_trial_end) && !self;
 
 	if (mtyp == DSC_TRIAL_FAIL_MSG) {
 		if (!trial)
diff --git a/net/tipc/topsrv.c b/net/tipc/topsrv.c
index 5522865deae9..14fd05fd6107 100644
--- a/net/tipc/topsrv.c
+++ b/net/tipc/topsrv.c
@@ -568,7 +568,7 @@ bool tipc_topsrv_kern_subscr(struct net *net, u32 port, u32 type, u32 lower,
 	sub.seq.upper = upper;
 	sub.timeout = TIPC_WAIT_FOREVER;
 	sub.filter = filter;
-	*(u32 *)&sub.usr_handle = port;
+	*(u64 *)&sub.usr_handle = (u64)port;
 
 	con = tipc_conn_alloc(tipc_topsrv(net));
 	if (IS_ERR(con))
diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
index e8035e4876df..01716ed76592 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -2021,7 +2021,8 @@ static inline int convert_context_handle_invalid_context(
  * in `newc'.  Verify that the context is valid
  * under the new policy.
  */
-static int convert_context(struct context *oldc, struct context *newc, void *p)
+static int convert_context(struct context *oldc, struct context *newc, void *p,
+			   gfp_t gfp_flags)
 {
 	struct convert_context_args *args;
 	struct ocontext *oc;
@@ -2035,7 +2036,7 @@ static int convert_context(struct context *oldc, struct context *newc, void *p)
 	args = p;
 
 	if (oldc->str) {
-		s = kstrdup(oldc->str, GFP_KERNEL);
+		s = kstrdup(oldc->str, gfp_flags);
 		if (!s)
 			return -ENOMEM;
 
diff --git a/security/selinux/ss/sidtab.c b/security/selinux/ss/sidtab.c
index 656d50b09f76..1981c5af13e0 100644
--- a/security/selinux/ss/sidtab.c
+++ b/security/selinux/ss/sidtab.c
@@ -325,7 +325,7 @@ int sidtab_context_to_sid(struct sidtab *s, struct context *context,
 		}
 
 		rc = convert->func(context, &dst_convert->context,
-				   convert->args);
+				   convert->args, GFP_ATOMIC);
 		if (rc) {
 			context_destroy(&dst->context);
 			goto out_unlock;
@@ -404,7 +404,7 @@ static int sidtab_convert_tree(union sidtab_entry_inner *edst,
 		while (i < SIDTAB_LEAF_ENTRIES && *pos < count) {
 			rc = convert->func(&esrc->ptr_leaf->entries[i].context,
 					   &edst->ptr_leaf->entries[i].context,
-					   convert->args);
+					   convert->args, GFP_KERNEL);
 			if (rc)
 				return rc;
 			(*pos)++;
diff --git a/security/selinux/ss/sidtab.h b/security/selinux/ss/sidtab.h
index 4eff0e49dcb2..9fce0d553fe2 100644
--- a/security/selinux/ss/sidtab.h
+++ b/security/selinux/ss/sidtab.h
@@ -65,7 +65,7 @@ struct sidtab_isid_entry {
 };
 
 struct sidtab_convert_params {
-	int (*func)(struct context *oldc, struct context *newc, void *args);
+	int (*func)(struct context *oldc, struct context *newc, void *args, gfp_t gfp_flags);
 	void *args;
 	struct sidtab *target;
 };
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index b93a36ffeb9e..7e4939640196 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -373,6 +373,9 @@ __add_event(struct list_head *list, int *idx,
 	struct perf_cpu_map *cpus = pmu ? perf_cpu_map__get(pmu->cpus) :
 			       cpu_list ? perf_cpu_map__new(cpu_list) : NULL;
 
+	if (pmu)
+		perf_pmu__warn_invalid_formats(pmu);
+
 	if (pmu && attr->type == PERF_TYPE_RAW)
 		perf_pmu__warn_invalid_config(pmu, attr->config, name);
 
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index bdabd62170d2..26c0b88cef4c 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -1048,6 +1048,23 @@ static struct perf_pmu *pmu_lookup(const char *lookup_name)
 	return NULL;
 }
 
+void perf_pmu__warn_invalid_formats(struct perf_pmu *pmu)
+{
+	struct perf_pmu_format *format;
+
+	/* fake pmu doesn't have format list */
+	if (pmu == &perf_pmu__fake)
+		return;
+
+	list_for_each_entry(format, &pmu->format, list)
+		if (format->value >= PERF_PMU_FORMAT_VALUE_CONFIG_END) {
+			pr_warning("WARNING: '%s' format '%s' requires 'perf_event_attr::config%d'"
+				   "which is not supported by this version of perf!\n",
+				   pmu->name, format->name, format->value);
+			return;
+		}
+}
+
 static struct perf_pmu *pmu_find(const char *name)
 {
 	struct perf_pmu *pmu;
diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
index 394898b07fd9..822d914b07cc 100644
--- a/tools/perf/util/pmu.h
+++ b/tools/perf/util/pmu.h
@@ -17,6 +17,7 @@ enum {
 	PERF_PMU_FORMAT_VALUE_CONFIG,
 	PERF_PMU_FORMAT_VALUE_CONFIG1,
 	PERF_PMU_FORMAT_VALUE_CONFIG2,
+	PERF_PMU_FORMAT_VALUE_CONFIG_END,
 };
 
 #define PERF_PMU_FORMAT_BITS 64
@@ -135,6 +136,7 @@ int perf_pmu__caps_parse(struct perf_pmu *pmu);
 
 void perf_pmu__warn_invalid_config(struct perf_pmu *pmu, __u64 config,
 				   char *name);
+void perf_pmu__warn_invalid_formats(struct perf_pmu *pmu);
 
 bool perf_pmu__has_hybrid(void);
 int perf_pmu__match(char *pattern, char *name, char *tok);
diff --git a/tools/perf/util/pmu.l b/tools/perf/util/pmu.l
index a15d9fbd7c0e..58b4926cfaca 100644
--- a/tools/perf/util/pmu.l
+++ b/tools/perf/util/pmu.l
@@ -27,8 +27,6 @@ num_dec         [0-9]+
 
 {num_dec}	{ return value(10); }
 config		{ return PP_CONFIG; }
-config1		{ return PP_CONFIG1; }
-config2		{ return PP_CONFIG2; }
 -		{ return '-'; }
 :		{ return ':'; }
 ,		{ return ','; }
diff --git a/tools/perf/util/pmu.y b/tools/perf/util/pmu.y
index bfd7e8509869..283efe059819 100644
--- a/tools/perf/util/pmu.y
+++ b/tools/perf/util/pmu.y
@@ -20,7 +20,7 @@ do { \
 
 %}
 
-%token PP_CONFIG PP_CONFIG1 PP_CONFIG2
+%token PP_CONFIG
 %token PP_VALUE PP_ERROR
 %type <num> PP_VALUE
 %type <bits> bit_term
@@ -47,18 +47,11 @@ PP_CONFIG ':' bits
 				      $3));
 }
 |
-PP_CONFIG1 ':' bits
+PP_CONFIG PP_VALUE ':' bits
 {
 	ABORT_ON(perf_pmu__new_format(format, name,
-				      PERF_PMU_FORMAT_VALUE_CONFIG1,
-				      $3));
-}
-|
-PP_CONFIG2 ':' bits
-{
-	ABORT_ON(perf_pmu__new_format(format, name,
-				      PERF_PMU_FORMAT_VALUE_CONFIG2,
-				      $3));
+				      $2,
+				      $4));
 }
 
 bits:
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 3ae5f6a3eae4..3ffed093d3ea 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4609,6 +4609,12 @@ struct compat_kvm_clear_dirty_log {
 	};
 };
 
+long __weak kvm_arch_vm_compat_ioctl(struct file *filp, unsigned int ioctl,
+				     unsigned long arg)
+{
+	return -ENOTTY;
+}
+
 static long kvm_vm_compat_ioctl(struct file *filp,
 			   unsigned int ioctl, unsigned long arg)
 {
@@ -4617,6 +4623,11 @@ static long kvm_vm_compat_ioctl(struct file *filp,
 
 	if (kvm->mm != current->mm || kvm->vm_bugged)
 		return -EIO;
+
+	r = kvm_arch_vm_compat_ioctl(filp, ioctl, arg);
+	if (r != -ENOTTY)
+		return r;
+
 	switch (ioctl) {
 #ifdef CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT
 	case KVM_CLEAR_DIRTY_LOG: {
