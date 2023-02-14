Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11AD2696CCD
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 19:25:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232939AbjBNSZv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 13:25:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232825AbjBNSZt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 13:25:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3F0B2BF3E;
        Tue, 14 Feb 2023 10:25:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2AFF3B81EC4;
        Tue, 14 Feb 2023 18:25:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30C14C433EF;
        Tue, 14 Feb 2023 18:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676399121;
        bh=zn2HM0mlxA0MPgPe1iaPwZk97Bp1WuauTN+J3ARXHcw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2mukI7QrT2gBL5+8GAQ/Os3c3tRO8Y9EmWu8TBCWEWQr+ekS9ydN2TdOVvIqpErr1
         44Oh/aLeqDNJAJrS6VlwQKkSrk3c7r+f8+Zzu7Ih0bbzIIDL2FlJOJrO1tL2tseP86
         h1HwNR0Eco7Tmha53spkNfCMUcJJ0R1HmGZah3vY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.15.94
Date:   Tue, 14 Feb 2023 19:25:10 +0100
Message-Id: <1676399110123144@kroah.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <1676399110121196@kroah.com>
References: <1676399110121196@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Documentation/admin-guide/hw-vuln/cross-thread-rsb.rst b/Documentation/admin-guide/hw-vuln/cross-thread-rsb.rst
new file mode 100644
index 000000000000..ec6e9f5bcf9e
--- /dev/null
+++ b/Documentation/admin-guide/hw-vuln/cross-thread-rsb.rst
@@ -0,0 +1,92 @@
+
+.. SPDX-License-Identifier: GPL-2.0
+
+Cross-Thread Return Address Predictions
+=======================================
+
+Certain AMD and Hygon processors are subject to a cross-thread return address
+predictions vulnerability. When running in SMT mode and one sibling thread
+transitions out of C0 state, the other sibling thread could use return target
+predictions from the sibling thread that transitioned out of C0.
+
+The Spectre v2 mitigations protect the Linux kernel, as it fills the return
+address prediction entries with safe targets when context switching to the idle
+thread. However, KVM does allow a VMM to prevent exiting guest mode when
+transitioning out of C0. This could result in a guest-controlled return target
+being consumed by the sibling thread.
+
+Affected processors
+-------------------
+
+The following CPUs are vulnerable:
+
+    - AMD Family 17h processors
+    - Hygon Family 18h processors
+
+Related CVEs
+------------
+
+The following CVE entry is related to this issue:
+
+   ==============  =======================================
+   CVE-2022-27672  Cross-Thread Return Address Predictions
+   ==============  =======================================
+
+Problem
+-------
+
+Affected SMT-capable processors support 1T and 2T modes of execution when SMT
+is enabled. In 2T mode, both threads in a core are executing code. For the
+processor core to enter 1T mode, it is required that one of the threads
+requests to transition out of the C0 state. This can be communicated with the
+HLT instruction or with an MWAIT instruction that requests non-C0.
+When the thread re-enters the C0 state, the processor transitions back
+to 2T mode, assuming the other thread is also still in C0 state.
+
+In affected processors, the return address predictor (RAP) is partitioned
+depending on the SMT mode. For instance, in 2T mode each thread uses a private
+16-entry RAP, but in 1T mode, the active thread uses a 32-entry RAP. Upon
+transition between 1T/2T mode, the RAP contents are not modified but the RAP
+pointers (which control the next return target to use for predictions) may
+change. This behavior may result in return targets from one SMT thread being
+used by RET predictions in the sibling thread following a 1T/2T switch. In
+particular, a RET instruction executed immediately after a transition to 1T may
+use a return target from the thread that just became idle. In theory, this
+could lead to information disclosure if the return targets used do not come
+from trustworthy code.
+
+Attack scenarios
+----------------
+
+An attack can be mounted on affected processors by performing a series of CALL
+instructions with targeted return locations and then transitioning out of C0
+state.
+
+Mitigation mechanism
+--------------------
+
+Before entering idle state, the kernel context switches to the idle thread. The
+context switch fills the RAP entries (referred to as the RSB in Linux) with safe
+targets by performing a sequence of CALL instructions.
+
+Prevent a guest VM from directly putting the processor into an idle state by
+intercepting HLT and MWAIT instructions.
+
+Both mitigations are required to fully address this issue.
+
+Mitigation control on the kernel command line
+---------------------------------------------
+
+Use existing Spectre v2 mitigations that will fill the RSB on context switch.
+
+Mitigation control for KVM - module parameter
+---------------------------------------------
+
+By default, the KVM hypervisor mitigates this issue by intercepting guest
+attempts to transition out of C0. A VMM can use the KVM_CAP_X86_DISABLE_EXITS
+capability to override those interceptions, but since this is not common, the
+mitigation that covers this path is not enabled by default.
+
+The mitigation for the KVM_CAP_X86_DISABLE_EXITS capability can be turned on
+using the boolean module parameter mitigate_smt_rsb, e.g.:
+        kvm.mitigate_smt_rsb=1
diff --git a/Documentation/admin-guide/hw-vuln/index.rst b/Documentation/admin-guide/hw-vuln/index.rst
index 4df436e7c417..e0614760a99e 100644
--- a/Documentation/admin-guide/hw-vuln/index.rst
+++ b/Documentation/admin-guide/hw-vuln/index.rst
@@ -18,3 +18,4 @@ are configurable at compile, boot or run time.
    core-scheduling.rst
    l1d_flush.rst
    processor_mmio_stale_data.rst
+   cross-thread-rsb.rst
diff --git a/Makefile b/Makefile
index cea0bf97fd59..fcee25420bf9 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 15
-SUBLEVEL = 93
+SUBLEVEL = 94
 EXTRAVERSION =
 NAME = Trick or Treat
 
diff --git a/arch/arm64/boot/dts/amlogic/meson-axg.dtsi b/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
index 3f5254eeb47b..e2ab338adb3c 100644
--- a/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
@@ -1885,7 +1885,7 @@ apb: bus@ffe00000 {
 			sd_emmc_b: sd@5000 {
 				compatible = "amlogic,meson-axg-mmc";
 				reg = <0x0 0x5000 0x0 0x800>;
-				interrupts = <GIC_SPI 217 IRQ_TYPE_EDGE_RISING>;
+				interrupts = <GIC_SPI 217 IRQ_TYPE_LEVEL_HIGH>;
 				status = "disabled";
 				clocks = <&clkc CLKID_SD_EMMC_B>,
 					<&clkc CLKID_SD_EMMC_B_CLK0>,
@@ -1897,7 +1897,7 @@ sd_emmc_b: sd@5000 {
 			sd_emmc_c: mmc@7000 {
 				compatible = "amlogic,meson-axg-mmc";
 				reg = <0x0 0x7000 0x0 0x800>;
-				interrupts = <GIC_SPI 218 IRQ_TYPE_EDGE_RISING>;
+				interrupts = <GIC_SPI 218 IRQ_TYPE_LEVEL_HIGH>;
 				status = "disabled";
 				clocks = <&clkc CLKID_SD_EMMC_C>,
 					<&clkc CLKID_SD_EMMC_C_CLK0>,
diff --git a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
index a3a1ea0f2134..2526d6e3a3dc 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
@@ -2330,7 +2330,7 @@ uart_A: serial@24000 {
 		sd_emmc_a: sd@ffe03000 {
 			compatible = "amlogic,meson-axg-mmc";
 			reg = <0x0 0xffe03000 0x0 0x800>;
-			interrupts = <GIC_SPI 189 IRQ_TYPE_EDGE_RISING>;
+			interrupts = <GIC_SPI 189 IRQ_TYPE_LEVEL_HIGH>;
 			status = "disabled";
 			clocks = <&clkc CLKID_SD_EMMC_A>,
 				 <&clkc CLKID_SD_EMMC_A_CLK0>,
@@ -2342,7 +2342,7 @@ sd_emmc_a: sd@ffe03000 {
 		sd_emmc_b: sd@ffe05000 {
 			compatible = "amlogic,meson-axg-mmc";
 			reg = <0x0 0xffe05000 0x0 0x800>;
-			interrupts = <GIC_SPI 190 IRQ_TYPE_EDGE_RISING>;
+			interrupts = <GIC_SPI 190 IRQ_TYPE_LEVEL_HIGH>;
 			status = "disabled";
 			clocks = <&clkc CLKID_SD_EMMC_B>,
 				 <&clkc CLKID_SD_EMMC_B_CLK0>,
@@ -2354,7 +2354,7 @@ sd_emmc_b: sd@ffe05000 {
 		sd_emmc_c: mmc@ffe07000 {
 			compatible = "amlogic,meson-axg-mmc";
 			reg = <0x0 0xffe07000 0x0 0x800>;
-			interrupts = <GIC_SPI 191 IRQ_TYPE_EDGE_RISING>;
+			interrupts = <GIC_SPI 191 IRQ_TYPE_LEVEL_HIGH>;
 			status = "disabled";
 			clocks = <&clkc CLKID_SD_EMMC_C>,
 				 <&clkc CLKID_SD_EMMC_C_CLK0>,
diff --git a/arch/arm64/boot/dts/amlogic/meson-gx.dtsi b/arch/arm64/boot/dts/amlogic/meson-gx.dtsi
index aa14ea017a61..ee623ead972e 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gx.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-gx.dtsi
@@ -602,21 +602,21 @@ apb: apb@d0000000 {
 			sd_emmc_a: mmc@70000 {
 				compatible = "amlogic,meson-gx-mmc", "amlogic,meson-gxbb-mmc";
 				reg = <0x0 0x70000 0x0 0x800>;
-				interrupts = <GIC_SPI 216 IRQ_TYPE_EDGE_RISING>;
+				interrupts = <GIC_SPI 216 IRQ_TYPE_LEVEL_HIGH>;
 				status = "disabled";
 			};
 
 			sd_emmc_b: mmc@72000 {
 				compatible = "amlogic,meson-gx-mmc", "amlogic,meson-gxbb-mmc";
 				reg = <0x0 0x72000 0x0 0x800>;
-				interrupts = <GIC_SPI 217 IRQ_TYPE_EDGE_RISING>;
+				interrupts = <GIC_SPI 217 IRQ_TYPE_LEVEL_HIGH>;
 				status = "disabled";
 			};
 
 			sd_emmc_c: mmc@74000 {
 				compatible = "amlogic,meson-gx-mmc", "amlogic,meson-gxbb-mmc";
 				reg = <0x0 0x74000 0x0 0x800>;
-				interrupts = <GIC_SPI 218 IRQ_TYPE_EDGE_RISING>;
+				interrupts = <GIC_SPI 218 IRQ_TYPE_LEVEL_HIGH>;
 				status = "disabled";
 			};
 		};
diff --git a/arch/powerpc/kernel/interrupt.c b/arch/powerpc/kernel/interrupt.c
index df048e331cbf..8703df709cce 100644
--- a/arch/powerpc/kernel/interrupt.c
+++ b/arch/powerpc/kernel/interrupt.c
@@ -53,16 +53,18 @@ static inline bool exit_must_hard_disable(void)
  */
 static notrace __always_inline bool prep_irq_for_enabled_exit(bool restartable)
 {
+	bool must_hard_disable = (exit_must_hard_disable() || !restartable);
+
 	/* This must be done with RI=1 because tracing may touch vmaps */
 	trace_hardirqs_on();
 
-	if (exit_must_hard_disable() || !restartable)
+	if (must_hard_disable)
 		__hard_EE_RI_disable();
 
 #ifdef CONFIG_PPC64
 	/* This pattern matches prep_irq_for_idle */
 	if (unlikely(lazy_irq_pending_nocheck())) {
-		if (exit_must_hard_disable() || !restartable) {
+		if (must_hard_disable) {
 			local_paca->irq_happened |= PACA_IRQ_HARD_DIS;
 			__hard_RI_enable();
 		}
diff --git a/arch/riscv/kernel/stacktrace.c b/arch/riscv/kernel/stacktrace.c
index 811e837a8c4e..ee8ef91c8aaf 100644
--- a/arch/riscv/kernel/stacktrace.c
+++ b/arch/riscv/kernel/stacktrace.c
@@ -32,6 +32,7 @@ void notrace walk_stackframe(struct task_struct *task, struct pt_regs *regs,
 		fp = (unsigned long)__builtin_frame_address(0);
 		sp = sp_in_global;
 		pc = (unsigned long)walk_stackframe;
+		level = -1;
 	} else {
 		/* task blocked in __switch_to */
 		fp = task->thread.s[0];
@@ -43,7 +44,7 @@ void notrace walk_stackframe(struct task_struct *task, struct pt_regs *regs,
 		unsigned long low, high;
 		struct stackframe *frame;
 
-		if (unlikely(!__kernel_text_address(pc) || (level++ >= 1 && !fn(arg, pc))))
+		if (unlikely(!__kernel_text_address(pc) || (level++ >= 0 && !fn(arg, pc))))
 			break;
 
 		/* Validate frame pointer */
diff --git a/arch/riscv/mm/cacheflush.c b/arch/riscv/mm/cacheflush.c
index 89f81067e09e..2ae1201cff88 100644
--- a/arch/riscv/mm/cacheflush.c
+++ b/arch/riscv/mm/cacheflush.c
@@ -85,7 +85,9 @@ void flush_icache_pte(pte_t pte)
 {
 	struct page *page = pte_page(pte);
 
-	if (!test_and_set_bit(PG_dcache_clean, &page->flags))
+	if (!test_bit(PG_dcache_clean, &page->flags)) {
 		flush_icache_all();
+		set_bit(PG_dcache_clean, &page->flags);
+	}
 }
 #endif /* CONFIG_MMU */
diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index f3cb8c8bf8d9..e31c7e75d6b0 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -452,5 +452,6 @@
 #define X86_BUG_MMIO_UNKNOWN		X86_BUG(26) /* CPU is too old and its MMIO Stale Data status is unknown */
 #define X86_BUG_RETBLEED		X86_BUG(27) /* CPU is affected by RETBleed */
 #define X86_BUG_EIBRS_PBRSB		X86_BUG(28) /* EIBRS is vulnerable to Post Barrier RSB Predictions */
+#define X86_BUG_SMT_RSB			X86_BUG(29) /* CPU is vulnerable to Cross-Thread Return Address Predictions */
 
 #endif /* _ASM_X86_CPUFEATURES_H */
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 9c1df6222df9..1698470dbea5 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1125,6 +1125,8 @@ static const __initconst struct x86_cpu_id cpu_vuln_whitelist[] = {
 #define MMIO_SBDS	BIT(2)
 /* CPU is affected by RETbleed, speculating where you would not expect it */
 #define RETBLEED	BIT(3)
+/* CPU is affected by SMT (cross-thread) return predictions */
+#define SMT_RSB		BIT(4)
 
 static const struct x86_cpu_id cpu_vuln_blacklist[] __initconst = {
 	VULNBL_INTEL_STEPPINGS(IVYBRIDGE,	X86_STEPPING_ANY,		SRBDS),
@@ -1156,8 +1158,8 @@ static const struct x86_cpu_id cpu_vuln_blacklist[] __initconst = {
 
 	VULNBL_AMD(0x15, RETBLEED),
 	VULNBL_AMD(0x16, RETBLEED),
-	VULNBL_AMD(0x17, RETBLEED),
-	VULNBL_HYGON(0x18, RETBLEED),
+	VULNBL_AMD(0x17, RETBLEED | SMT_RSB),
+	VULNBL_HYGON(0x18, RETBLEED | SMT_RSB),
 	{}
 };
 
@@ -1275,6 +1277,9 @@ static void __init cpu_set_bug_bits(struct cpuinfo_x86 *c)
 	    !(ia32_cap & ARCH_CAP_PBRSB_NO))
 		setup_force_cpu_bug(X86_BUG_EIBRS_PBRSB);
 
+	if (cpu_matches(cpu_vuln_blacklist, SMT_RSB))
+		setup_force_cpu_bug(X86_BUG_SMT_RSB);
+
 	if (cpu_matches(cpu_vuln_whitelist, NO_MELTDOWN))
 		return;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fcfa3fedf84f..45a3d11bb70d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -184,6 +184,10 @@ module_param(force_emulation_prefix, bool, S_IRUGO);
 int __read_mostly pi_inject_timer = -1;
 module_param(pi_inject_timer, bint, S_IRUGO | S_IWUSR);
 
+/* Enable/disable SMT_RSB bug mitigation */
+bool __read_mostly mitigate_smt_rsb;
+module_param(mitigate_smt_rsb, bool, 0444);
+
 /*
  * Restoring the host value for MSRs that are only consumed when running in
  * usermode, e.g. SYSCALL MSRs and TSC_AUX, can be deferred until the CPU
@@ -4164,10 +4168,15 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = KVM_CLOCK_TSC_STABLE;
 		break;
 	case KVM_CAP_X86_DISABLE_EXITS:
-		r |=  KVM_X86_DISABLE_EXITS_HLT | KVM_X86_DISABLE_EXITS_PAUSE |
-		      KVM_X86_DISABLE_EXITS_CSTATE;
-		if(kvm_can_mwait_in_guest())
-			r |= KVM_X86_DISABLE_EXITS_MWAIT;
+		r = KVM_X86_DISABLE_EXITS_PAUSE;
+
+		if (!mitigate_smt_rsb) {
+			r |= KVM_X86_DISABLE_EXITS_HLT |
+			     KVM_X86_DISABLE_EXITS_CSTATE;
+
+			if (kvm_can_mwait_in_guest())
+				r |= KVM_X86_DISABLE_EXITS_MWAIT;
+		}
 		break;
 	case KVM_CAP_X86_SMM:
 		/* SMBASE is usually relocated above 1M on modern chipsets,
@@ -5746,15 +5755,26 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		if (cap->args[0] & ~KVM_X86_DISABLE_VALID_EXITS)
 			break;
 
-		if ((cap->args[0] & KVM_X86_DISABLE_EXITS_MWAIT) &&
-			kvm_can_mwait_in_guest())
-			kvm->arch.mwait_in_guest = true;
-		if (cap->args[0] & KVM_X86_DISABLE_EXITS_HLT)
-			kvm->arch.hlt_in_guest = true;
 		if (cap->args[0] & KVM_X86_DISABLE_EXITS_PAUSE)
 			kvm->arch.pause_in_guest = true;
-		if (cap->args[0] & KVM_X86_DISABLE_EXITS_CSTATE)
-			kvm->arch.cstate_in_guest = true;
+
+#define SMT_RSB_MSG "This processor is affected by the Cross-Thread Return Predictions vulnerability. " \
+		    "KVM_CAP_X86_DISABLE_EXITS should only be used with SMT disabled or trusted guests."
+
+		if (!mitigate_smt_rsb) {
+			if (boot_cpu_has_bug(X86_BUG_SMT_RSB) && cpu_smt_possible() &&
+			    (cap->args[0] & ~KVM_X86_DISABLE_EXITS_PAUSE))
+				pr_warn_once(SMT_RSB_MSG);
+
+			if ((cap->args[0] & KVM_X86_DISABLE_EXITS_MWAIT) &&
+			    kvm_can_mwait_in_guest())
+				kvm->arch.mwait_in_guest = true;
+			if (cap->args[0] & KVM_X86_DISABLE_EXITS_HLT)
+				kvm->arch.hlt_in_guest = true;
+			if (cap->args[0] & KVM_X86_DISABLE_EXITS_CSTATE)
+				kvm->arch.cstate_in_guest = true;
+		}
+
 		r = 0;
 		break;
 	case KVM_CAP_MSR_PLATFORM_INFO:
@@ -12796,6 +12816,7 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_msr_protocol_exit);
 static int __init kvm_x86_init(void)
 {
 	kvm_mmu_x86_module_init();
+	mitigate_smt_rsb &= boot_cpu_has_bug(X86_BUG_SMT_RSB) && cpu_smt_possible();
 	return 0;
 }
 module_init(kvm_x86_init);
diff --git a/drivers/clk/ingenic/jz4760-cgu.c b/drivers/clk/ingenic/jz4760-cgu.c
index 14483797a4db..11906242e1d3 100644
--- a/drivers/clk/ingenic/jz4760-cgu.c
+++ b/drivers/clk/ingenic/jz4760-cgu.c
@@ -58,7 +58,7 @@ jz4760_cgu_calc_m_n_od(const struct ingenic_cgu_pll_info *pll_info,
 		       unsigned long rate, unsigned long parent_rate,
 		       unsigned int *pm, unsigned int *pn, unsigned int *pod)
 {
-	unsigned int m, n, od, m_max = (1 << pll_info->m_bits) - 2;
+	unsigned int m, n, od, m_max = (1 << pll_info->m_bits) - 1;
 
 	/* The frequency after the N divider must be between 1 and 50 MHz. */
 	n = parent_rate / (1 * MHZ);
@@ -66,19 +66,17 @@ jz4760_cgu_calc_m_n_od(const struct ingenic_cgu_pll_info *pll_info,
 	/* The N divider must be >= 2. */
 	n = clamp_val(n, 2, 1 << pll_info->n_bits);
 
-	for (;; n >>= 1) {
-		od = (unsigned int)-1;
+	rate /= MHZ;
+	parent_rate /= MHZ;
 
-		do {
-			m = (rate / MHZ) * (1 << ++od) * n / (parent_rate / MHZ);
-		} while ((m > m_max || m & 1) && (od < 4));
-
-		if (od < 4 && m >= 4 && m <= m_max)
-			break;
+	for (m = m_max; m >= m_max && n >= 2; n--) {
+		m = rate * n / parent_rate;
+		od = m & 1;
+		m <<= od;
 	}
 
 	*pm = m;
-	*pn = n;
+	*pn = n + 1;
 	*pod = 1 << od;
 }
 
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
index 14499f0de32d..bbd6f7a12303 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
@@ -579,7 +579,13 @@ void amdgpu_fence_driver_sw_fini(struct amdgpu_device *adev)
 		if (!ring || !ring->fence_drv.initialized)
 			continue;
 
-		if (!ring->no_scheduler)
+		/*
+		 * Notice we check for sched.ops since there's some
+		 * override on the meaning of sched.ready by amdgpu.
+		 * The natural check would be sched.ready, which is
+		 * set as drm_sched_init() finishes...
+		 */
+		if (ring->sched.ops)
 			drm_sched_fini(&ring->sched);
 
 		for (j = 0; j <= ring->fence_drv.num_fences_mask; ++j)
diff --git a/drivers/gpu/drm/i915/display/intel_bios.c b/drivers/gpu/drm/i915/display/intel_bios.c
index 32d5a556b7ea..aa0b93607559 100644
--- a/drivers/gpu/drm/i915/display/intel_bios.c
+++ b/drivers/gpu/drm/i915/display/intel_bios.c
@@ -1820,6 +1820,22 @@ static enum port dvo_port_to_port(struct drm_i915_private *i915,
 					  dvo_port);
 }
 
+static enum port
+dsi_dvo_port_to_port(struct drm_i915_private *i915, u8 dvo_port)
+{
+	switch (dvo_port) {
+	case DVO_PORT_MIPIA:
+		return PORT_A;
+	case DVO_PORT_MIPIC:
+		if (DISPLAY_VER(i915) >= 11)
+			return PORT_B;
+		else
+			return PORT_C;
+	default:
+		return PORT_NONE;
+	}
+}
+
 static int parse_bdb_230_dp_max_link_rate(const int vbt_max_link_rate)
 {
 	switch (vbt_max_link_rate) {
@@ -2733,19 +2749,16 @@ bool intel_bios_is_dsi_present(struct drm_i915_private *i915,
 
 		dvo_port = child->dvo_port;
 
-		if (dvo_port == DVO_PORT_MIPIA ||
-		    (dvo_port == DVO_PORT_MIPIB && DISPLAY_VER(i915) >= 11) ||
-		    (dvo_port == DVO_PORT_MIPIC && DISPLAY_VER(i915) < 11)) {
-			if (port)
-				*port = dvo_port - DVO_PORT_MIPIA;
-			return true;
-		} else if (dvo_port == DVO_PORT_MIPIB ||
-			   dvo_port == DVO_PORT_MIPIC ||
-			   dvo_port == DVO_PORT_MIPID) {
+		if (dsi_dvo_port_to_port(i915, dvo_port) == PORT_NONE) {
 			drm_dbg_kms(&i915->drm,
 				    "VBT has unsupported DSI port %c\n",
 				    port_name(dvo_port - DVO_PORT_MIPIA));
+			continue;
 		}
+
+		if (port)
+			*port = dsi_dvo_port_to_port(i915, dvo_port);
+		return true;
 	}
 
 	return false;
@@ -2830,7 +2843,7 @@ bool intel_bios_get_dsc_params(struct intel_encoder *encoder,
 		if (!(child->device_type & DEVICE_TYPE_MIPI_OUTPUT))
 			continue;
 
-		if (child->dvo_port - DVO_PORT_MIPIA == encoder->port) {
+		if (dsi_dvo_port_to_port(i915, child->dvo_port) == encoder->port) {
 			if (!devdata->dsc)
 				return false;
 
diff --git a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c b/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
index 11f072193f3b..827f2f9dcda6 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
@@ -533,7 +533,7 @@ static int shmem_object_init(struct intel_memory_region *mem,
 	mapping_set_gfp_mask(mapping, mask);
 	GEM_BUG_ON(!(mapping_gfp_mask(mapping) & __GFP_RECLAIM));
 
-	i915_gem_object_init(obj, &i915_gem_shmem_ops, &lock_class, 0);
+	i915_gem_object_init(obj, &i915_gem_shmem_ops, &lock_class, flags);
 	obj->mem_flags |= I915_BO_FLAG_STRUCT_PAGE;
 	obj->write_domain = I915_GEM_DOMAIN_CPU;
 	obj->read_domains = I915_GEM_DOMAIN_CPU;
diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/hw/hfi1/file_ops.c
index 686d170a5947..1c1172aeb36e 100644
--- a/drivers/infiniband/hw/hfi1/file_ops.c
+++ b/drivers/infiniband/hw/hfi1/file_ops.c
@@ -1318,12 +1318,15 @@ static int user_exp_rcv_setup(struct hfi1_filedata *fd, unsigned long arg,
 		addr = arg + offsetof(struct hfi1_tid_info, tidcnt);
 		if (copy_to_user((void __user *)addr, &tinfo.tidcnt,
 				 sizeof(tinfo.tidcnt)))
-			return -EFAULT;
+			ret = -EFAULT;
 
 		addr = arg + offsetof(struct hfi1_tid_info, length);
-		if (copy_to_user((void __user *)addr, &tinfo.length,
+		if (!ret && copy_to_user((void __user *)addr, &tinfo.length,
 				 sizeof(tinfo.length)))
 			ret = -EFAULT;
+
+		if (ret)
+			hfi1_user_exp_rcv_invalid(fd, &tinfo);
 	}
 
 	return ret;
diff --git a/drivers/infiniband/hw/irdma/cm.c b/drivers/infiniband/hw/irdma/cm.c
index b08c67bb264c..a8ec3d8f6e46 100644
--- a/drivers/infiniband/hw/irdma/cm.c
+++ b/drivers/infiniband/hw/irdma/cm.c
@@ -1723,6 +1723,9 @@ irdma_add_mqh_4(struct irdma_device *iwdev, struct irdma_cm_info *cm_info,
 			continue;
 
 		idev = in_dev_get(ip_dev);
+		if (!idev)
+			continue;
+
 		in_dev_for_each_ifa_rtnl(ifa, idev) {
 			ibdev_dbg(&iwdev->ibdev,
 				  "CM: Allocating child CM Listener forIP=%pI4, vlan_id=%d, MAC=%pM\n",
diff --git a/drivers/infiniband/hw/usnic/usnic_uiom.c b/drivers/infiniband/hw/usnic/usnic_uiom.c
index 760b254ba42d..48a57568cad6 100644
--- a/drivers/infiniband/hw/usnic/usnic_uiom.c
+++ b/drivers/infiniband/hw/usnic/usnic_uiom.c
@@ -281,8 +281,8 @@ static int usnic_uiom_map_sorted_intervals(struct list_head *intervals,
 				size = pa_end - pa_start + PAGE_SIZE;
 				usnic_dbg("va 0x%lx pa %pa size 0x%zx flags 0x%x",
 					va_start, &pa_start, size, flags);
-				err = iommu_map(pd->domain, va_start, pa_start,
-							size, flags);
+				err = iommu_map_atomic(pd->domain, va_start,
+						       pa_start, size, flags);
 				if (err) {
 					usnic_err("Failed to map va 0x%lx pa %pa size 0x%zx with err %d\n",
 						va_start, &pa_start, size, err);
@@ -298,8 +298,8 @@ static int usnic_uiom_map_sorted_intervals(struct list_head *intervals,
 				size = pa - pa_start + PAGE_SIZE;
 				usnic_dbg("va 0x%lx pa %pa size 0x%zx flags 0x%x\n",
 					va_start, &pa_start, size, flags);
-				err = iommu_map(pd->domain, va_start, pa_start,
-						size, flags);
+				err = iommu_map_atomic(pd->domain, va_start,
+						       pa_start, size, flags);
 				if (err) {
 					usnic_err("Failed to map va 0x%lx pa %pa size 0x%zx with err %d\n",
 						va_start, &pa_start, size, err);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 0aa8629fdf62..1ea95f8009b8 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -2197,6 +2197,14 @@ int ipoib_intf_init(struct ib_device *hca, u32 port, const char *name,
 		rn->attach_mcast = ipoib_mcast_attach;
 		rn->detach_mcast = ipoib_mcast_detach;
 		rn->hca = hca;
+
+		rc = netif_set_real_num_tx_queues(dev, 1);
+		if (rc)
+			goto out;
+
+		rc = netif_set_real_num_rx_queues(dev, 1);
+		if (rc)
+			goto out;
 	}
 
 	priv->rn_ops = dev->netdev_ops;
diff --git a/drivers/net/bonding/bond_debugfs.c b/drivers/net/bonding/bond_debugfs.c
index 4f9b4a18c74c..594094526648 100644
--- a/drivers/net/bonding/bond_debugfs.c
+++ b/drivers/net/bonding/bond_debugfs.c
@@ -76,7 +76,7 @@ void bond_debug_reregister(struct bonding *bond)
 
 	d = debugfs_rename(bonding_debug_root, bond->debug_dir,
 			   bonding_debug_root, bond->dev->name);
-	if (d) {
+	if (!IS_ERR(d)) {
 		bond->debug_dir = d;
 	} else {
 		netdev_warn(bond->dev, "failed to reregister, so just unregister old one\n");
diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 704ba461a600..c1505de23957 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1290,14 +1290,26 @@ mt7530_port_set_vlan_aware(struct dsa_switch *ds, int port)
 		if (!priv->ports[port].pvid)
 			mt7530_rmw(priv, MT7530_PVC_P(port), ACC_FRM_MASK,
 				   MT7530_VLAN_ACC_TAGGED);
-	}
 
-	/* Set the port as a user port which is to be able to recognize VID
-	 * from incoming packets before fetching entry within the VLAN table.
-	 */
-	mt7530_rmw(priv, MT7530_PVC_P(port), VLAN_ATTR_MASK | PVC_EG_TAG_MASK,
-		   VLAN_ATTR(MT7530_VLAN_USER) |
-		   PVC_EG_TAG(MT7530_VLAN_EG_DISABLED));
+		/* Set the port as a user port which is to be able to recognize
+		 * VID from incoming packets before fetching entry within the
+		 * VLAN table.
+		 */
+		mt7530_rmw(priv, MT7530_PVC_P(port),
+			   VLAN_ATTR_MASK | PVC_EG_TAG_MASK,
+			   VLAN_ATTR(MT7530_VLAN_USER) |
+			   PVC_EG_TAG(MT7530_VLAN_EG_DISABLED));
+	} else {
+		/* Also set CPU ports to the "user" VLAN port attribute, to
+		 * allow VLAN classification, but keep the EG_TAG attribute as
+		 * "consistent" (i.o.w. don't change its value) for packets
+		 * received by the switch from the CPU, so that tagged packets
+		 * are forwarded to user ports as tagged, and untagged as
+		 * untagged.
+		 */
+		mt7530_rmw(priv, MT7530_PVC_P(port), VLAN_ATTR_MASK,
+			   VLAN_ATTR(MT7530_VLAN_USER));
+	}
 }
 
 static void
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 348105aa5cf5..6f674cd117d3 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -5130,7 +5130,7 @@ static int __init ice_module_init(void)
 	pr_info("%s\n", ice_driver_string);
 	pr_info("%s\n", ice_copyright);
 
-	ice_wq = alloc_workqueue("%s", WQ_MEM_RECLAIM, 0, KBUILD_MODNAME);
+	ice_wq = alloc_workqueue("%s", 0, 0, KBUILD_MODNAME);
 	if (!ice_wq) {
 		pr_err("Failed to create workqueue\n");
 		return -ENOMEM;
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 3726c8413c74..bde3fea2c442 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -2892,7 +2892,9 @@ static bool igc_clean_tx_irq(struct igc_q_vector *q_vector, int napi_budget)
 		if (tx_buffer->next_to_watch &&
 		    time_after(jiffies, tx_buffer->time_stamp +
 		    (adapter->tx_timeout_factor * HZ)) &&
-		    !(rd32(IGC_STATUS) & IGC_STATUS_TXOFF)) {
+		    !(rd32(IGC_STATUS) & IGC_STATUS_TXOFF) &&
+		    (rd32(IGC_TDH(tx_ring->reg_idx)) !=
+		     readl(tx_ring->tail))) {
 			/* detected Tx unit hang */
 			netdev_err(tx_ring->netdev,
 				   "Detected Tx Unit Hang\n"
@@ -5019,6 +5021,24 @@ static int igc_change_mtu(struct net_device *netdev, int new_mtu)
 	return 0;
 }
 
+/**
+ * igc_tx_timeout - Respond to a Tx Hang
+ * @netdev: network interface device structure
+ * @txqueue: queue number that timed out
+ **/
+static void igc_tx_timeout(struct net_device *netdev,
+			   unsigned int __always_unused txqueue)
+{
+	struct igc_adapter *adapter = netdev_priv(netdev);
+	struct igc_hw *hw = &adapter->hw;
+
+	/* Do the reset outside of interrupt context */
+	adapter->tx_timeout_count++;
+	schedule_work(&adapter->reset_task);
+	wr32(IGC_EICS,
+	     (adapter->eims_enable_mask & ~adapter->eims_other));
+}
+
 /**
  * igc_get_stats64 - Get System Network Statistics
  * @netdev: network interface device structure
@@ -5446,7 +5466,7 @@ static void igc_watchdog_task(struct work_struct *work)
 			case SPEED_100:
 			case SPEED_1000:
 			case SPEED_2500:
-				adapter->tx_timeout_factor = 7;
+				adapter->tx_timeout_factor = 1;
 				break;
 			}
 
@@ -6264,6 +6284,7 @@ static const struct net_device_ops igc_netdev_ops = {
 	.ndo_set_rx_mode	= igc_set_rx_mode,
 	.ndo_set_mac_address	= igc_set_mac,
 	.ndo_change_mtu		= igc_change_mtu,
+	.ndo_tx_timeout		= igc_tx_timeout,
 	.ndo_get_stats64	= igc_get_stats64,
 	.ndo_fix_features	= igc_fix_features,
 	.ndo_set_features	= igc_set_features,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
index 326e0b170e36..1c72fc0b7b68 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
@@ -64,6 +64,7 @@ static int mlx5_query_mtrc_caps(struct mlx5_fw_tracer *tracer)
 			MLX5_GET(mtrc_cap, out, num_string_trace);
 	tracer->str_db.num_string_db = MLX5_GET(mtrc_cap, out, num_string_db);
 	tracer->owner = !!MLX5_GET(mtrc_cap, out, trace_owner);
+	tracer->str_db.loaded = false;
 
 	for (i = 0; i < tracer->str_db.num_string_db; i++) {
 		mtrc_cap_sp = MLX5_ADDR_OF(mtrc_cap, out, string_db_param[i]);
@@ -756,6 +757,7 @@ static int mlx5_fw_tracer_set_mtrc_conf(struct mlx5_fw_tracer *tracer)
 	if (err)
 		mlx5_core_warn(dev, "FWTracer: Failed to set tracer configurations %d\n", err);
 
+	tracer->buff.consumer_index = 0;
 	return err;
 }
 
@@ -820,7 +822,6 @@ static void mlx5_fw_tracer_ownership_change(struct work_struct *work)
 	mlx5_core_dbg(tracer->dev, "FWTracer: ownership changed, current=(%d)\n", tracer->owner);
 	if (tracer->owner) {
 		tracer->owner = false;
-		tracer->buff.consumer_index = 0;
 		return;
 	}
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index c22a38e5337b..c822c3ac0544 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -1002,7 +1002,7 @@ void mlx5e_activate_priv_channels(struct mlx5e_priv *priv);
 void mlx5e_deactivate_priv_channels(struct mlx5e_priv *priv);
 int mlx5e_ptp_rx_manage_fs_ctx(struct mlx5e_priv *priv, void *ctx);
 
-int mlx5e_modify_rq_state(struct mlx5e_rq *rq, int curr_state, int next_state);
+int mlx5e_flush_rq(struct mlx5e_rq *rq, int curr_state);
 void mlx5e_activate_rq(struct mlx5e_rq *rq);
 void mlx5e_deactivate_rq(struct mlx5e_rq *rq);
 void mlx5e_activate_icosq(struct mlx5e_icosq *icosq);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
index 8e7177d4539e..291bd5963904 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
@@ -432,10 +432,6 @@ static int mlx5_esw_bridge_switchdev_event(struct notifier_block *nb,
 
 	switch (event) {
 	case SWITCHDEV_FDB_ADD_TO_BRIDGE:
-		/* only handle the event on native eswtich of representor */
-		if (!mlx5_esw_bridge_is_local(dev, rep, esw))
-			break;
-
 		fdb_info = container_of(info,
 					struct switchdev_notifier_fdb_info,
 					info);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
index e329158fdc55..899a9a73eef6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
@@ -129,44 +129,20 @@ static int mlx5e_rx_reporter_err_icosq_cqe_recover(void *ctx)
 	return err;
 }
 
-static int mlx5e_rq_to_ready(struct mlx5e_rq *rq, int curr_state)
-{
-	struct net_device *dev = rq->netdev;
-	int err;
-
-	err = mlx5e_modify_rq_state(rq, curr_state, MLX5_RQC_STATE_RST);
-	if (err) {
-		netdev_err(dev, "Failed to move rq 0x%x to reset\n", rq->rqn);
-		return err;
-	}
-	err = mlx5e_modify_rq_state(rq, MLX5_RQC_STATE_RST, MLX5_RQC_STATE_RDY);
-	if (err) {
-		netdev_err(dev, "Failed to move rq 0x%x to ready\n", rq->rqn);
-		return err;
-	}
-
-	return 0;
-}
-
 static int mlx5e_rx_reporter_err_rq_cqe_recover(void *ctx)
 {
 	struct mlx5e_rq *rq = ctx;
 	int err;
 
 	mlx5e_deactivate_rq(rq);
-	mlx5e_free_rx_descs(rq);
-
-	err = mlx5e_rq_to_ready(rq, MLX5_RQC_STATE_ERR);
+	err = mlx5e_flush_rq(rq, MLX5_RQC_STATE_ERR);
+	clear_bit(MLX5E_RQ_STATE_RECOVERING, &rq->state);
 	if (err)
-		goto out;
+		return err;
 
-	clear_bit(MLX5E_RQ_STATE_RECOVERING, &rq->state);
 	mlx5e_activate_rq(rq);
 	rq->stats->recover++;
 	return 0;
-out:
-	clear_bit(MLX5E_RQ_STATE_RECOVERING, &rq->state);
-	return err;
 }
 
 static int mlx5e_rx_reporter_timeout_recover(void *ctx)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index be19f5cf9d15..f1dd966e2bdb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -392,7 +392,8 @@ static int mlx5e_init_rxq_rq(struct mlx5e_channel *c, struct mlx5e_params *param
 	rq->icosq        = &c->icosq;
 	rq->ix           = c->ix;
 	rq->mdev         = mdev;
-	rq->hw_mtu       = MLX5E_SW2HW_MTU(params, params->sw_mtu);
+	rq->hw_mtu =
+		MLX5E_SW2HW_MTU(params, params->sw_mtu) - ETH_FCS_LEN * !params->scatter_fcs_en;
 	rq->xdpsq        = &c->rq_xdpsq;
 	rq->stats        = &c->priv->channel_stats[c->ix].rq;
 	rq->ptp_cyc2time = mlx5_rq_ts_translator(mdev);
@@ -672,7 +673,7 @@ int mlx5e_create_rq(struct mlx5e_rq *rq, struct mlx5e_rq_param *param)
 	return err;
 }
 
-int mlx5e_modify_rq_state(struct mlx5e_rq *rq, int curr_state, int next_state)
+static int mlx5e_modify_rq_state(struct mlx5e_rq *rq, int curr_state, int next_state)
 {
 	struct mlx5_core_dev *mdev = rq->mdev;
 
@@ -701,33 +702,30 @@ int mlx5e_modify_rq_state(struct mlx5e_rq *rq, int curr_state, int next_state)
 	return err;
 }
 
-static int mlx5e_modify_rq_scatter_fcs(struct mlx5e_rq *rq, bool enable)
+static int mlx5e_rq_to_ready(struct mlx5e_rq *rq, int curr_state)
 {
-	struct mlx5_core_dev *mdev = rq->mdev;
-
-	void *in;
-	void *rqc;
-	int inlen;
+	struct net_device *dev = rq->netdev;
 	int err;
 
-	inlen = MLX5_ST_SZ_BYTES(modify_rq_in);
-	in = kvzalloc(inlen, GFP_KERNEL);
-	if (!in)
-		return -ENOMEM;
-
-	rqc = MLX5_ADDR_OF(modify_rq_in, in, ctx);
-
-	MLX5_SET(modify_rq_in, in, rq_state, MLX5_RQC_STATE_RDY);
-	MLX5_SET64(modify_rq_in, in, modify_bitmask,
-		   MLX5_MODIFY_RQ_IN_MODIFY_BITMASK_SCATTER_FCS);
-	MLX5_SET(rqc, rqc, scatter_fcs, enable);
-	MLX5_SET(rqc, rqc, state, MLX5_RQC_STATE_RDY);
+	err = mlx5e_modify_rq_state(rq, curr_state, MLX5_RQC_STATE_RST);
+	if (err) {
+		netdev_err(dev, "Failed to move rq 0x%x to reset\n", rq->rqn);
+		return err;
+	}
+	err = mlx5e_modify_rq_state(rq, MLX5_RQC_STATE_RST, MLX5_RQC_STATE_RDY);
+	if (err) {
+		netdev_err(dev, "Failed to move rq 0x%x to ready\n", rq->rqn);
+		return err;
+	}
 
-	err = mlx5_core_modify_rq(mdev, rq->rqn, in);
+	return 0;
+}
 
-	kvfree(in);
+int mlx5e_flush_rq(struct mlx5e_rq *rq, int curr_state)
+{
+	mlx5e_free_rx_descs(rq);
 
-	return err;
+	return mlx5e_rq_to_ready(rq, curr_state);
 }
 
 static int mlx5e_modify_rq_vsd(struct mlx5e_rq *rq, bool vsd)
@@ -2850,20 +2848,6 @@ static void mlx5e_cleanup_nic_tx(struct mlx5e_priv *priv)
 	mlx5e_destroy_tises(priv);
 }
 
-static int mlx5e_modify_channels_scatter_fcs(struct mlx5e_channels *chs, bool enable)
-{
-	int err = 0;
-	int i;
-
-	for (i = 0; i < chs->num; i++) {
-		err = mlx5e_modify_rq_scatter_fcs(&chs->c[i]->rq, enable);
-		if (err)
-			return err;
-	}
-
-	return 0;
-}
-
 static int mlx5e_modify_channels_vsd(struct mlx5e_channels *chs, bool vsd)
 {
 	int err;
@@ -3375,41 +3359,27 @@ static int mlx5e_set_rx_port_ts(struct mlx5_core_dev *mdev, bool enable)
 	return mlx5_set_ports_check(mdev, in, sizeof(in));
 }
 
+static int mlx5e_set_rx_port_ts_wrap(struct mlx5e_priv *priv, void *ctx)
+{
+	struct mlx5_core_dev *mdev = priv->mdev;
+	bool enable = *(bool *)ctx;
+
+	return mlx5e_set_rx_port_ts(mdev, enable);
+}
+
 static int set_feature_rx_fcs(struct net_device *netdev, bool enable)
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 	struct mlx5e_channels *chs = &priv->channels;
-	struct mlx5_core_dev *mdev = priv->mdev;
+	struct mlx5e_params new_params;
 	int err;
 
 	mutex_lock(&priv->state_lock);
 
-	if (enable) {
-		err = mlx5e_set_rx_port_ts(mdev, false);
-		if (err)
-			goto out;
-
-		chs->params.scatter_fcs_en = true;
-		err = mlx5e_modify_channels_scatter_fcs(chs, true);
-		if (err) {
-			chs->params.scatter_fcs_en = false;
-			mlx5e_set_rx_port_ts(mdev, true);
-		}
-	} else {
-		chs->params.scatter_fcs_en = false;
-		err = mlx5e_modify_channels_scatter_fcs(chs, false);
-		if (err) {
-			chs->params.scatter_fcs_en = true;
-			goto out;
-		}
-		err = mlx5e_set_rx_port_ts(mdev, true);
-		if (err) {
-			mlx5_core_warn(mdev, "Failed to set RX port timestamp %d\n", err);
-			err = 0;
-		}
-	}
-
-out:
+	new_params = chs->params;
+	new_params.scatter_fcs_en = enable;
+	err = mlx5e_safe_switch_params(priv, &new_params, mlx5e_set_rx_port_ts_wrap,
+				       &new_params.scatter_fcs_en, true);
 	mutex_unlock(&priv->state_lock);
 	return err;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
index 317d76b97c42..aec0f67cef00 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
@@ -1270,7 +1270,7 @@ void mlx5_esw_bridge_fdb_update_used(struct net_device *dev, u16 vport_num, u16
 	struct mlx5_esw_bridge *bridge;
 
 	port = mlx5_esw_bridge_port_lookup(vport_num, esw_owner_vhca_id, br_offloads);
-	if (!port || port->flags & MLX5_ESW_BRIDGE_PORT_FLAG_PEER)
+	if (!port)
 		return;
 
 	bridge = port->bridge;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
index 0c8594c7df21..908e5ee1a30f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
@@ -172,16 +172,16 @@ static inline int mlx5_ptys_rate_enum_to_int(enum mlx5_ptys_rate rate)
 	}
 }
 
-static int mlx5i_get_speed_settings(u16 ib_link_width_oper, u16 ib_proto_oper)
+static u32 mlx5i_get_speed_settings(u16 ib_link_width_oper, u16 ib_proto_oper)
 {
 	int rate, width;
 
 	rate = mlx5_ptys_rate_enum_to_int(ib_proto_oper);
 	if (rate < 0)
-		return -EINVAL;
+		return SPEED_UNKNOWN;
 	width = mlx5_ptys_width_enum_to_int(ib_link_width_oper);
 	if (width < 0)
-		return -EINVAL;
+		return SPEED_UNKNOWN;
 
 	return rate * width;
 }
@@ -204,16 +204,13 @@ static int mlx5i_get_link_ksettings(struct net_device *netdev,
 	ethtool_link_ksettings_zero_link_mode(link_ksettings, advertising);
 
 	speed = mlx5i_get_speed_settings(ib_link_width_oper, ib_proto_oper);
-	if (speed < 0)
-		return -EINVAL;
+	link_ksettings->base.speed = speed;
+	link_ksettings->base.duplex = speed == SPEED_UNKNOWN ? DUPLEX_UNKNOWN : DUPLEX_FULL;
 
-	link_ksettings->base.duplex = DUPLEX_FULL;
 	link_ksettings->base.port = PORT_OTHER;
 
 	link_ksettings->base.autoneg = AUTONEG_DISABLE;
 
-	link_ksettings->base.speed = speed;
-
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 9e15eea9743f..485a6a6220f6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1862,7 +1862,7 @@ static int __init mlx5_init(void)
 	mlx5_fpga_ipsec_build_fs_cmds();
 	mlx5_register_debugfs();
 
-	err = pci_register_driver(&mlx5_core_driver);
+	err = mlx5e_init();
 	if (err)
 		goto err_debug;
 
@@ -1870,16 +1870,16 @@ static int __init mlx5_init(void)
 	if (err)
 		goto err_sf;
 
-	err = mlx5e_init();
+	err = pci_register_driver(&mlx5_core_driver);
 	if (err)
-		goto err_en;
+		goto err_pci;
 
 	return 0;
 
-err_en:
+err_pci:
 	mlx5_sf_driver_unregister();
 err_sf:
-	pci_unregister_driver(&mlx5_core_driver);
+	mlx5e_cleanup();
 err_debug:
 	mlx5_unregister_debugfs();
 	return err;
@@ -1887,9 +1887,9 @@ static int __init mlx5_init(void)
 
 static void __exit mlx5_cleanup(void)
 {
-	mlx5e_cleanup();
-	mlx5_sf_driver_unregister();
 	pci_unregister_driver(&mlx5_core_driver);
+	mlx5_sf_driver_unregister();
+	mlx5e_cleanup();
 	mlx5_unregister_debugfs();
 }
 
diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index a3a5ad5dbb0e..b7e7bd744a1b 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -473,6 +473,18 @@ ocelot_flower_parse_key(struct ocelot *ocelot, int port, bool ingress,
 		flow_rule_match_control(rule, &match);
 	}
 
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_VLAN)) {
+		struct flow_match_vlan match;
+
+		flow_rule_match_vlan(rule, &match);
+		filter->key_type = OCELOT_VCAP_KEY_ANY;
+		filter->vlan.vid.value = match.key->vlan_id;
+		filter->vlan.vid.mask = match.mask->vlan_id;
+		filter->vlan.pcp.value[0] = match.key->vlan_priority;
+		filter->vlan.pcp.mask[0] = match.mask->vlan_priority;
+		match_protocol = false;
+	}
+
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ETH_ADDRS)) {
 		struct flow_match_eth_addrs match;
 
@@ -605,18 +617,6 @@ ocelot_flower_parse_key(struct ocelot *ocelot, int port, bool ingress,
 		match_protocol = false;
 	}
 
-	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_VLAN)) {
-		struct flow_match_vlan match;
-
-		flow_rule_match_vlan(rule, &match);
-		filter->key_type = OCELOT_VCAP_KEY_ANY;
-		filter->vlan.vid.value = match.key->vlan_id;
-		filter->vlan.vid.mask = match.mask->vlan_id;
-		filter->vlan.pcp.value[0] = match.key->vlan_priority;
-		filter->vlan.pcp.mask[0] = match.mask->vlan_priority;
-		match_protocol = false;
-	}
-
 finished_key_parsing:
 	if (match_protocol && proto != ETH_P_ALL) {
 		if (filter->block_id == VCAP_ES0) {
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 886c997a3ad1..6fbd2a51d66c 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -268,6 +268,7 @@ static int ionic_qcq_enable(struct ionic_qcq *qcq)
 			.oper = IONIC_Q_ENABLE,
 		},
 	};
+	int ret;
 
 	idev = &lif->ionic->idev;
 	dev = lif->ionic->dev;
@@ -275,16 +276,24 @@ static int ionic_qcq_enable(struct ionic_qcq *qcq)
 	dev_dbg(dev, "q_enable.index %d q_enable.qtype %d\n",
 		ctx.cmd.q_control.index, ctx.cmd.q_control.type);
 
+	if (qcq->flags & IONIC_QCQ_F_INTR)
+		ionic_intr_clean(idev->intr_ctrl, qcq->intr.index);
+
+	ret = ionic_adminq_post_wait(lif, &ctx);
+	if (ret)
+		return ret;
+
+	if (qcq->napi.poll)
+		napi_enable(&qcq->napi);
+
 	if (qcq->flags & IONIC_QCQ_F_INTR) {
 		irq_set_affinity_hint(qcq->intr.vector,
 				      &qcq->intr.affinity_mask);
-		napi_enable(&qcq->napi);
-		ionic_intr_clean(idev->intr_ctrl, qcq->intr.index);
 		ionic_intr_mask(idev->intr_ctrl, qcq->intr.index,
 				IONIC_INTR_MASK_CLEAR);
 	}
 
-	return ionic_adminq_post_wait(lif, &ctx);
+	return 0;
 }
 
 static int ionic_qcq_disable(struct ionic_qcq *qcq, bool send_to_hw)
diff --git a/drivers/net/phy/meson-gxl.c b/drivers/net/phy/meson-gxl.c
index 5e41658b1e2f..a6015cd03bff 100644
--- a/drivers/net/phy/meson-gxl.c
+++ b/drivers/net/phy/meson-gxl.c
@@ -261,6 +261,8 @@ static struct phy_driver meson_gxl_phy[] = {
 		.handle_interrupt = meson_gxl_handle_interrupt,
 		.suspend        = genphy_suspend,
 		.resume         = genphy_resume,
+		.read_mmd	= genphy_read_mmd_unsupported,
+		.write_mmd	= genphy_write_mmd_unsupported,
 	}, {
 		PHY_ID_MATCH_EXACT(0x01803301),
 		.name		= "Meson G12A Internal PHY",
diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 7afcf6310d59..422dc92ecac9 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1166,10 +1166,9 @@ int phylink_fwnode_phy_connect(struct phylink *pl,
 
 	ret = phy_attach_direct(pl->netdev, phy_dev, flags,
 				pl->link_interface);
-	if (ret) {
-		phy_device_free(phy_dev);
+	phy_device_free(phy_dev);
+	if (ret)
 		return ret;
-	}
 
 	ret = phylink_bringup_phy(pl, phy_dev, pl->link_config.interface);
 	if (ret)
diff --git a/drivers/net/usb/plusb.c b/drivers/net/usb/plusb.c
index 17c9c63b8eeb..ce7862dac2b7 100644
--- a/drivers/net/usb/plusb.c
+++ b/drivers/net/usb/plusb.c
@@ -57,9 +57,7 @@
 static inline int
 pl_vendor_req(struct usbnet *dev, u8 req, u8 val, u8 index)
 {
-	return usbnet_read_cmd(dev, req,
-				USB_DIR_IN | USB_TYPE_VENDOR |
-				USB_RECIP_DEVICE,
+	return usbnet_write_cmd(dev, req, USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 				val, index, NULL, 0);
 }
 
diff --git a/drivers/of/address.c b/drivers/of/address.c
index 94f017d808c4..586fb94005e2 100644
--- a/drivers/of/address.c
+++ b/drivers/of/address.c
@@ -963,8 +963,19 @@ int of_dma_get_range(struct device_node *np, const struct bus_dma_region **map)
 	}
 
 	of_dma_range_parser_init(&parser, node);
-	for_each_of_range(&parser, &range)
+	for_each_of_range(&parser, &range) {
+		if (range.cpu_addr == OF_BAD_ADDR) {
+			pr_err("translation of DMA address(%llx) to CPU address failed node(%pOF)\n",
+			       range.bus_addr, node);
+			continue;
+		}
 		num_ranges++;
+	}
+
+	if (!num_ranges) {
+		ret = -EINVAL;
+		goto out;
+	}
 
 	r = kcalloc(num_ranges + 1, sizeof(*r), GFP_KERNEL);
 	if (!r) {
@@ -973,18 +984,16 @@ int of_dma_get_range(struct device_node *np, const struct bus_dma_region **map)
 	}
 
 	/*
-	 * Record all info in the generic DMA ranges array for struct device.
+	 * Record all info in the generic DMA ranges array for struct device,
+	 * returning an error if we don't find any parsable ranges.
 	 */
 	*map = r;
 	of_dma_range_parser_init(&parser, node);
 	for_each_of_range(&parser, &range) {
 		pr_debug("dma_addr(%llx) cpu_addr(%llx) size(%llx)\n",
 			 range.bus_addr, range.cpu_addr, range.size);
-		if (range.cpu_addr == OF_BAD_ADDR) {
-			pr_err("translation of DMA address(%llx) to CPU address failed node(%pOF)\n",
-			       range.bus_addr, node);
+		if (range.cpu_addr == OF_BAD_ADDR)
 			continue;
-		}
 		r->cpu_start = range.cpu_addr;
 		r->dma_start = range.bus_addr;
 		r->size = range.size;
diff --git a/drivers/pinctrl/aspeed/pinctrl-aspeed.c b/drivers/pinctrl/aspeed/pinctrl-aspeed.c
index 83d47ff1cea8..5a12fc7cf91f 100644
--- a/drivers/pinctrl/aspeed/pinctrl-aspeed.c
+++ b/drivers/pinctrl/aspeed/pinctrl-aspeed.c
@@ -122,7 +122,7 @@ static int aspeed_disable_sig(struct aspeed_pinmux_data *ctx,
 	int ret = 0;
 
 	if (!exprs)
-		return true;
+		return -EINVAL;
 
 	while (*exprs && !ret) {
 		ret = aspeed_sig_expr_disable(ctx, *exprs);
diff --git a/drivers/pinctrl/intel/pinctrl-intel.c b/drivers/pinctrl/intel/pinctrl-intel.c
index 32807aab9343..cc64eda155f5 100644
--- a/drivers/pinctrl/intel/pinctrl-intel.c
+++ b/drivers/pinctrl/intel/pinctrl-intel.c
@@ -1661,6 +1661,12 @@ const struct intel_pinctrl_soc_data *intel_pinctrl_get_soc_data(struct platform_
 EXPORT_SYMBOL_GPL(intel_pinctrl_get_soc_data);
 
 #ifdef CONFIG_PM_SLEEP
+static bool __intel_gpio_is_direct_irq(u32 value)
+{
+	return (value & PADCFG0_GPIROUTIOXAPIC) && (value & PADCFG0_GPIOTXDIS) &&
+	       (__intel_gpio_get_gpio_mode(value) == PADCFG0_PMODE_GPIO);
+}
+
 static bool intel_pinctrl_should_save(struct intel_pinctrl *pctrl, unsigned int pin)
 {
 	const struct pin_desc *pd = pin_desc_get(pctrl->pctldev, pin);
@@ -1694,8 +1700,7 @@ static bool intel_pinctrl_should_save(struct intel_pinctrl *pctrl, unsigned int
 	 * See https://bugzilla.kernel.org/show_bug.cgi?id=214749.
 	 */
 	value = readl(intel_get_padcfg(pctrl, pin, PADCFG0));
-	if ((value & PADCFG0_GPIROUTIOXAPIC) && (value & PADCFG0_GPIOTXDIS) &&
-	    (__intel_gpio_get_gpio_mode(value) == PADCFG0_PMODE_GPIO))
+	if (__intel_gpio_is_direct_irq(value))
 		return true;
 
 	return false;
@@ -1825,7 +1830,12 @@ int intel_pinctrl_resume_noirq(struct device *dev)
 	for (i = 0; i < pctrl->soc->npins; i++) {
 		const struct pinctrl_pin_desc *desc = &pctrl->soc->pins[i];
 
-		if (!intel_pinctrl_should_save(pctrl, desc->number))
+		if (!(intel_pinctrl_should_save(pctrl, desc->number) ||
+		      /*
+		       * If the firmware mangled the register contents too much,
+		       * check the saved value for the Direct IRQ mode.
+		       */
+		      __intel_gpio_is_direct_irq(pads[i].padcfg0)))
 			continue;
 
 		intel_restore_padcfg(pctrl, desc->number, PADCFG0, pads[i].padcfg0);
diff --git a/drivers/pinctrl/mediatek/pinctrl-mt8195.c b/drivers/pinctrl/mediatek/pinctrl-mt8195.c
index a7500e18bb1d..c32884fc7de7 100644
--- a/drivers/pinctrl/mediatek/pinctrl-mt8195.c
+++ b/drivers/pinctrl/mediatek/pinctrl-mt8195.c
@@ -659,7 +659,7 @@ static const struct mtk_pin_field_calc mt8195_pin_drv_range[] = {
 	PIN_FIELD_BASE(10, 10, 4, 0x010, 0x10, 9, 3),
 	PIN_FIELD_BASE(11, 11, 4, 0x000, 0x10, 24, 3),
 	PIN_FIELD_BASE(12, 12, 4, 0x010, 0x10, 12, 3),
-	PIN_FIELD_BASE(13, 13, 4, 0x010, 0x10, 27, 3),
+	PIN_FIELD_BASE(13, 13, 4, 0x000, 0x10, 27, 3),
 	PIN_FIELD_BASE(14, 14, 4, 0x010, 0x10, 15, 3),
 	PIN_FIELD_BASE(15, 15, 4, 0x010, 0x10, 0, 3),
 	PIN_FIELD_BASE(16, 16, 4, 0x010, 0x10, 18, 3),
@@ -708,7 +708,7 @@ static const struct mtk_pin_field_calc mt8195_pin_drv_range[] = {
 	PIN_FIELD_BASE(78, 78, 3, 0x000, 0x10, 15, 3),
 	PIN_FIELD_BASE(79, 79, 3, 0x000, 0x10, 18, 3),
 	PIN_FIELD_BASE(80, 80, 3, 0x000, 0x10, 21, 3),
-	PIN_FIELD_BASE(81, 81, 3, 0x000, 0x10, 28, 3),
+	PIN_FIELD_BASE(81, 81, 3, 0x000, 0x10, 24, 3),
 	PIN_FIELD_BASE(82, 82, 3, 0x000, 0x10, 27, 3),
 	PIN_FIELD_BASE(83, 83, 3, 0x010, 0x10, 0, 3),
 	PIN_FIELD_BASE(84, 84, 3, 0x010, 0x10, 3, 3),
diff --git a/drivers/pinctrl/pinctrl-single.c b/drivers/pinctrl/pinctrl-single.c
index 414ee6bb8ac9..9ad8f7020614 100644
--- a/drivers/pinctrl/pinctrl-single.c
+++ b/drivers/pinctrl/pinctrl-single.c
@@ -372,6 +372,8 @@ static int pcs_set_mux(struct pinctrl_dev *pctldev, unsigned fselector,
 	if (!pcs->fmask)
 		return 0;
 	function = pinmux_generic_get_function(pctldev, fselector);
+	if (!function)
+		return -EINVAL;
 	func = function->data;
 	if (!func)
 		return -EINVAL;
diff --git a/drivers/spi/spi-dw-core.c b/drivers/spi/spi-dw-core.c
index a305074c482e..59e22c6b4b20 100644
--- a/drivers/spi/spi-dw-core.c
+++ b/drivers/spi/spi-dw-core.c
@@ -357,7 +357,7 @@ static void dw_spi_irq_setup(struct dw_spi *dws)
 	 * will be adjusted at the final stage of the IRQ-based SPI transfer
 	 * execution so not to lose the leftover of the incoming data.
 	 */
-	level = min_t(u16, dws->fifo_len / 2, dws->tx_len);
+	level = min_t(unsigned int, dws->fifo_len / 2, dws->tx_len);
 	dw_writel(dws, DW_SPI_TXFTLR, level);
 	dw_writel(dws, DW_SPI_RXFTLR, level - 1);
 
diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index 079e183cf3bf..934b3d997702 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -526,6 +526,9 @@ static const struct usb_device_id usb_quirk_list[] = {
 	/* DJI CineSSD */
 	{ USB_DEVICE(0x2ca3, 0x0031), .driver_info = USB_QUIRK_NO_LPM },
 
+	/* Alcor Link AK9563 SC Reader used in 2022 Lenovo ThinkPads */
+	{ USB_DEVICE(0x2ce3, 0x9563), .driver_info = USB_QUIRK_NO_LPM },
+
 	/* DELL USB GEN2 */
 	{ USB_DEVICE(0x413c, 0xb062), .driver_info = USB_QUIRK_NO_LPM | USB_QUIRK_RESET_RESUME },
 
diff --git a/drivers/usb/typec/altmodes/displayport.c b/drivers/usb/typec/altmodes/displayport.c
index ff3038047d38..c232a735a0c2 100644
--- a/drivers/usb/typec/altmodes/displayport.c
+++ b/drivers/usb/typec/altmodes/displayport.c
@@ -533,10 +533,10 @@ int dp_altmode_probe(struct typec_altmode *alt)
 	/* FIXME: Port can only be DFP_U. */
 
 	/* Make sure we have compatiple pin configurations */
-	if (!(DP_CAP_DFP_D_PIN_ASSIGN(port->vdo) &
-	      DP_CAP_UFP_D_PIN_ASSIGN(alt->vdo)) &&
-	    !(DP_CAP_UFP_D_PIN_ASSIGN(port->vdo) &
-	      DP_CAP_DFP_D_PIN_ASSIGN(alt->vdo)))
+	if (!(DP_CAP_PIN_ASSIGN_DFP_D(port->vdo) &
+	      DP_CAP_PIN_ASSIGN_UFP_D(alt->vdo)) &&
+	    !(DP_CAP_PIN_ASSIGN_UFP_D(port->vdo) &
+	      DP_CAP_PIN_ASSIGN_DFP_D(alt->vdo)))
 		return -ENODEV;
 
 	ret = sysfs_create_group(&alt->dev.kobj, &dp_altmode_group);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f01549b8c7c5..24f7ba1478ed 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -409,6 +409,7 @@ void btrfs_free_device(struct btrfs_device *device)
 static void free_fs_devices(struct btrfs_fs_devices *fs_devices)
 {
 	struct btrfs_device *device;
+
 	WARN_ON(fs_devices->opened);
 	while (!list_empty(&fs_devices->devices)) {
 		device = list_entry(fs_devices->devices.next,
@@ -1221,9 +1222,22 @@ void btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
 
 	mutex_lock(&uuid_mutex);
 	close_fs_devices(fs_devices);
-	if (!fs_devices->opened)
+	if (!fs_devices->opened) {
 		list_splice_init(&fs_devices->seed_list, &list);
 
+		/*
+		 * If the struct btrfs_fs_devices is not assembled with any
+		 * other device, it can be re-initialized during the next mount
+		 * without the needing device-scan step. Therefore, it can be
+		 * fully freed.
+		 */
+		if (fs_devices->num_devices == 1) {
+			list_del(&fs_devices->fs_list);
+			free_fs_devices(fs_devices);
+		}
+	}
+
+
 	list_for_each_entry_safe(fs_devices, tmp, &list, seed_list) {
 		close_fs_devices(fs_devices);
 		list_del(&fs_devices->seed_list);
@@ -1646,7 +1660,7 @@ static int find_free_dev_extent_start(struct btrfs_device *device,
 	if (ret < 0)
 		goto out;
 
-	while (1) {
+	while (search_start < search_end) {
 		l = path->nodes[0];
 		slot = path->slots[0];
 		if (slot >= btrfs_header_nritems(l)) {
@@ -1669,6 +1683,9 @@ static int find_free_dev_extent_start(struct btrfs_device *device,
 		if (key.type != BTRFS_DEV_EXTENT_KEY)
 			goto next;
 
+		if (key.offset > search_end)
+			break;
+
 		if (key.offset > search_start) {
 			hole_size = key.offset - search_start;
 			dev_extent_hole_check(device, &search_start, &hole_size,
@@ -1729,6 +1746,7 @@ static int find_free_dev_extent_start(struct btrfs_device *device,
 	else
 		ret = 0;
 
+	ASSERT(max_hole_start + max_hole_size <= search_end);
 out:
 	btrfs_free_path(path);
 	*start = max_hole_start;
diff --git a/fs/btrfs/zlib.c b/fs/btrfs/zlib.c
index 767a0c6c9694..12e674f10baf 100644
--- a/fs/btrfs/zlib.c
+++ b/fs/btrfs/zlib.c
@@ -63,7 +63,7 @@ struct list_head *zlib_alloc_workspace(unsigned int level)
 
 	workspacesize = max(zlib_deflate_workspacesize(MAX_WBITS, MAX_MEM_LEVEL),
 			zlib_inflate_workspacesize());
-	workspace->strm.workspace = kvmalloc(workspacesize, GFP_KERNEL);
+	workspace->strm.workspace = kvzalloc(workspacesize, GFP_KERNEL);
 	workspace->level = level;
 	workspace->buf = NULL;
 	/*
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 78d052dc1798..0dc8871a4b66 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -3543,6 +3543,12 @@ static void handle_session(struct ceph_mds_session *session,
 		break;
 
 	case CEPH_SESSION_FLUSHMSG:
+		/* flush cap releases */
+		spin_lock(&session->s_cap_lock);
+		if (session->s_num_cap_releases)
+			ceph_flush_cap_releases(mdsc, session);
+		spin_unlock(&session->s_cap_lock);
+
 		send_flushmsg_ack(mdsc, session, seq);
 		break;
 
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index aa422348824a..cca9ff01b30c 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -3613,7 +3613,7 @@ uncached_fill_pages(struct TCP_Server_Info *server,
 		rdata->got_bytes += result;
 	}
 
-	return rdata->got_bytes > 0 && result != -ECONNABORTED ?
+	return result != -ECONNABORTED && rdata->got_bytes > 0 ?
 						rdata->got_bytes : result;
 }
 
@@ -4388,7 +4388,7 @@ readpages_fill_pages(struct TCP_Server_Info *server,
 		rdata->got_bytes += result;
 	}
 
-	return rdata->got_bytes > 0 && result != -ECONNABORTED ?
+	return result != -ECONNABORTED && rdata->got_bytes > 0 ?
 						rdata->got_bytes : result;
 }
 
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index cac25ad9d643..f98d747f983b 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -166,7 +166,7 @@ bool hugetlb_reserve_pages(struct inode *inode, long from, long to,
 						vm_flags_t vm_flags);
 long hugetlb_unreserve_pages(struct inode *inode, long start, long end,
 						long freed);
-bool isolate_huge_page(struct page *page, struct list_head *list);
+int isolate_hugetlb(struct page *page, struct list_head *list);
 int get_hwpoison_huge_page(struct page *page, bool *hugetlb);
 int get_huge_page_for_hwpoison(unsigned long pfn, int flags);
 void putback_active_hugepage(struct page *page);
@@ -354,9 +354,9 @@ static inline pte_t *huge_pte_offset(struct mm_struct *mm, unsigned long addr,
 	return NULL;
 }
 
-static inline bool isolate_huge_page(struct page *page, struct list_head *list)
+static inline int isolate_hugetlb(struct page *page, struct list_head *list)
 {
-	return false;
+	return -EBUSY;
 }
 
 static inline int get_hwpoison_huge_page(struct page *page, bool *hugetlb)
diff --git a/include/uapi/linux/ip.h b/include/uapi/linux/ip.h
index d2f143393780..860bbf6bf29c 100644
--- a/include/uapi/linux/ip.h
+++ b/include/uapi/linux/ip.h
@@ -18,6 +18,7 @@
 #ifndef _UAPI_LINUX_IP_H
 #define _UAPI_LINUX_IP_H
 #include <linux/types.h>
+#include <linux/stddef.h>
 #include <asm/byteorder.h>
 
 #define IPTOS_TOS_MASK		0x1E
diff --git a/include/uapi/linux/ipv6.h b/include/uapi/linux/ipv6.h
index 62e5e16ef539..39c6add59a1a 100644
--- a/include/uapi/linux/ipv6.h
+++ b/include/uapi/linux/ipv6.h
@@ -4,6 +4,7 @@
 
 #include <linux/libc-compat.h>
 #include <linux/types.h>
+#include <linux/stddef.h>
 #include <linux/in6.h>
 #include <asm/byteorder.h>
 
diff --git a/kernel/locking/rtmutex.c b/kernel/locking/rtmutex.c
index ea5a701ab240..fcd9ad3f7f2e 100644
--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -855,8 +855,9 @@ static int __sched rt_mutex_adjust_prio_chain(struct task_struct *task,
 		 * then we need to wake the new top waiter up to try
 		 * to get the lock.
 		 */
-		if (prerequeue_top_waiter != rt_mutex_top_waiter(lock))
-			wake_up_state(waiter->task, waiter->wake_state);
+		top_waiter = rt_mutex_top_waiter(lock);
+		if (prerequeue_top_waiter != top_waiter)
+			wake_up_state(top_waiter->task, top_waiter->wake_state);
 		raw_spin_unlock_irq(&lock->wait_lock);
 		return 0;
 	}
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 06ff4dea34d0..161ffc56afa3 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -9089,9 +9089,6 @@ buffer_percent_write(struct file *filp, const char __user *ubuf,
 	if (val > 100)
 		return -EINVAL;
 
-	if (!val)
-		val = 1;
-
 	tr->buffer_percent = val;
 
 	(*ppos)++;
diff --git a/mm/gup.c b/mm/gup.c
index 2370565a81dc..0a1839b32574 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1877,7 +1877,7 @@ static long check_and_migrate_movable_pages(unsigned long nr_pages,
 		 */
 		if (!is_pinnable_page(head)) {
 			if (PageHuge(head)) {
-				if (!isolate_huge_page(head, &movable_page_list))
+				if (isolate_hugetlb(head, &movable_page_list))
 					isolation_error_count++;
 			} else {
 				if (!PageLRU(head) && drain_allow) {
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 8599f16d4aa4..2f5c1b2456ef 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2656,8 +2656,7 @@ static int alloc_and_dissolve_huge_page(struct hstate *h, struct page *old_page,
 		 * Fail with -EBUSY if not possible.
 		 */
 		spin_unlock_irq(&hugetlb_lock);
-		if (!isolate_huge_page(old_page, list))
-			ret = -EBUSY;
+		ret = isolate_hugetlb(old_page, list);
 		spin_lock_irq(&hugetlb_lock);
 		goto free_new;
 	} else if (!HPageFreed(old_page)) {
@@ -2733,7 +2732,7 @@ int isolate_or_dissolve_huge_page(struct page *page, struct list_head *list)
 	if (hstate_is_gigantic(h))
 		return -ENOMEM;
 
-	if (page_count(head) && isolate_huge_page(head, list))
+	if (page_count(head) && !isolate_hugetlb(head, list))
 		ret = 0;
 	else if (!page_count(head))
 		ret = alloc_and_dissolve_huge_page(h, head, list);
@@ -6277,15 +6276,15 @@ follow_huge_pgd(struct mm_struct *mm, unsigned long address, pgd_t *pgd, int fla
 	return pte_page(*(pte_t *)pgd) + ((address & ~PGDIR_MASK) >> PAGE_SHIFT);
 }
 
-bool isolate_huge_page(struct page *page, struct list_head *list)
+int isolate_hugetlb(struct page *page, struct list_head *list)
 {
-	bool ret = true;
+	int ret = 0;
 
 	spin_lock_irq(&hugetlb_lock);
 	if (!PageHeadHuge(page) ||
 	    !HPageMigratable(page) ||
 	    !get_page_unless_zero(page)) {
-		ret = false;
+		ret = -EBUSY;
 		goto unlock;
 	}
 	ClearHPageMigratable(page);
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 2ad0f4580091..9f9dd968fbe3 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -2106,7 +2106,7 @@ static bool isolate_page(struct page *page, struct list_head *pagelist)
 	bool lru = PageLRU(page);
 
 	if (PageHuge(page)) {
-		isolated = isolate_huge_page(page, pagelist);
+		isolated = !isolate_hugetlb(page, pagelist);
 	} else {
 		if (lru)
 			isolated = !isolate_lru_page(page);
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 9fd0be32a281..81f2a97c886c 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1704,7 +1704,7 @@ do_migrate_range(unsigned long start_pfn, unsigned long end_pfn)
 
 		if (PageHuge(page)) {
 			pfn = page_to_pfn(head) + compound_nr(head) - 1;
-			isolate_huge_page(head, &source);
+			isolate_hugetlb(head, &source);
 			continue;
 		} else if (PageTransHuge(page))
 			pfn = page_to_pfn(head) + thp_nr_pages(page) - 1;
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 4472be6f123d..818753635e42 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -603,8 +603,9 @@ static int queue_pages_hugetlb(pte_t *pte, unsigned long hmask,
 
 	/* With MPOL_MF_MOVE, we migrate only unshared hugepage. */
 	if (flags & (MPOL_MF_MOVE_ALL) ||
-	    (flags & MPOL_MF_MOVE && page_mapcount(page) == 1)) {
-		if (!isolate_huge_page(page, qp->pagelist) &&
+	    (flags & MPOL_MF_MOVE && page_mapcount(page) == 1 &&
+	     !hugetlb_pmd_shared(pte))) {
+		if (isolate_hugetlb(page, qp->pagelist) &&
 			(flags & MPOL_MF_STRICT))
 			/*
 			 * Failed to isolate page but allow migrating pages
diff --git a/mm/migrate.c b/mm/migrate.c
index 7da052c6cf1e..dd50b1cc089e 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -134,7 +134,7 @@ static void putback_movable_page(struct page *page)
  *
  * This function shall be used whenever the isolated pageset has been
  * built from lru, balloon, hugetlbfs page. See isolate_migratepages_range()
- * and isolate_huge_page().
+ * and isolate_hugetlb().
  */
 void putback_movable_pages(struct list_head *l)
 {
@@ -1722,8 +1722,9 @@ static int add_page_for_migration(struct mm_struct *mm, unsigned long addr,
 
 	if (PageHuge(page)) {
 		if (PageHead(page)) {
-			isolate_huge_page(page, pagelist);
-			err = 1;
+			err = isolate_hugetlb(page, pagelist);
+			if (!err)
+				err = 1;
 		}
 	} else {
 		struct page *head;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a71722b4e464..c929357fbefe 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5490,9 +5490,12 @@ EXPORT_SYMBOL(get_zeroed_page);
  */
 void __free_pages(struct page *page, unsigned int order)
 {
+	/* get PageHead before we drop reference */
+	int head = PageHead(page);
+
 	if (put_page_testzero(page))
 		free_the_page(page, order);
-	else if (!PageHead(page))
+	else if (!head)
 		while (order-- > 0)
 			free_the_page(page + (1 << order), order);
 }
diff --git a/net/can/j1939/address-claim.c b/net/can/j1939/address-claim.c
index f33c47327927..ca4ad6cdd5cb 100644
--- a/net/can/j1939/address-claim.c
+++ b/net/can/j1939/address-claim.c
@@ -165,6 +165,46 @@ static void j1939_ac_process(struct j1939_priv *priv, struct sk_buff *skb)
 	 * leaving this function.
 	 */
 	ecu = j1939_ecu_get_by_name_locked(priv, name);
+
+	if (ecu && ecu->addr == skcb->addr.sa) {
+		/* The ISO 11783-5 standard, in "4.5.2 - Address claim
+		 * requirements", states:
+		 *   d) No CF shall begin, or resume, transmission on the
+		 *      network until 250 ms after it has successfully claimed
+		 *      an address except when responding to a request for
+		 *      address-claimed.
+		 *
+		 * But "Figure 6" and "Figure 7" in "4.5.4.2 - Address-claim
+		 * prioritization" show that the CF begins the transmission
+		 * after 250 ms from the first AC (address-claimed) message
+		 * even if it sends another AC message during that time window
+		 * to resolve the address contention with another CF.
+		 *
+		 * As stated in "4.4.2.3 - Address-claimed message":
+		 *   In order to successfully claim an address, the CF sending
+		 *   an address claimed message shall not receive a contending
+		 *   claim from another CF for at least 250 ms.
+		 *
+		 * As stated in "4.4.3.2 - NAME management (NM) message":
+		 *   1) A commanding CF can
+		 *      d) request that a CF with a specified NAME transmit
+		 *         the address-claimed message with its current NAME.
+		 *   2) A target CF shall
+		 *      d) send an address-claimed message in response to a
+		 *         request for a matching NAME
+		 *
+		 * Taking the above arguments into account, the 250 ms wait is
+		 * requested only during network initialization.
+		 *
+		 * Do not restart the timer on AC message if both the NAME and
+		 * the address match and so if the address has already been
+		 * claimed (timer has expired) or the AC message has been sent
+		 * to resolve the contention with another CF (timer is still
+		 * running).
+		 */
+		goto out_ecu_put;
+	}
+
 	if (!ecu && j1939_address_is_unicast(skcb->addr.sa))
 		ecu = j1939_ecu_create_locked(priv, name);
 
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index ba4241d7c5ef..15dbaa202c7c 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1284,6 +1284,7 @@ void __mptcp_error_report(struct sock *sk)
 	mptcp_for_each_subflow(msk, subflow) {
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
 		int err = sock_error(ssk);
+		int ssk_state;
 
 		if (!err)
 			continue;
@@ -1294,7 +1295,14 @@ void __mptcp_error_report(struct sock *sk)
 		if (sk->sk_state != TCP_SYN_SENT && !__mptcp_check_fallback(msk))
 			continue;
 
-		inet_sk_state_store(sk, inet_sk_state_load(ssk));
+		/* We need to propagate only transition to CLOSE state.
+		 * Orphaned socket will see such state change via
+		 * subflow_sched_work_if_closed() and that path will properly
+		 * destroy the msk as needed.
+		 */
+		ssk_state = inet_sk_state_load(ssk);
+		if (ssk_state == TCP_CLOSE && !sock_flag(sk, SOCK_DEAD))
+			inet_sk_state_store(sk, ssk_state);
 		sk->sk_err = -err;
 
 		/* This barrier is coupled with smp_rmb() in mptcp_poll() */
diff --git a/net/rds/message.c b/net/rds/message.c
index 799034e0f513..b363ef13c75e 100644
--- a/net/rds/message.c
+++ b/net/rds/message.c
@@ -104,9 +104,9 @@ static void rds_rm_zerocopy_callback(struct rds_sock *rs,
 	spin_lock_irqsave(&q->lock, flags);
 	head = &q->zcookie_head;
 	if (!list_empty(head)) {
-		info = list_entry(head, struct rds_msg_zcopy_info,
-				  rs_zcookie_next);
-		if (info && rds_zcookie_add(info, cookie)) {
+		info = list_first_entry(head, struct rds_msg_zcopy_info,
+					rs_zcookie_next);
+		if (rds_zcookie_add(info, cookie)) {
 			spin_unlock_irqrestore(&q->lock, flags);
 			kfree(rds_info_from_znotifier(znotif));
 			/* caller invokes rds_wake_sk_sleep() */
diff --git a/net/xfrm/xfrm_compat.c b/net/xfrm/xfrm_compat.c
index a0f62fa02e06..8cbf45a8bcdc 100644
--- a/net/xfrm/xfrm_compat.c
+++ b/net/xfrm/xfrm_compat.c
@@ -5,6 +5,7 @@
  * Based on code and translator idea by: Florian Westphal <fw@strlen.de>
  */
 #include <linux/compat.h>
+#include <linux/nospec.h>
 #include <linux/xfrm.h>
 #include <net/xfrm.h>
 
@@ -302,7 +303,7 @@ static int xfrm_xlate64(struct sk_buff *dst, const struct nlmsghdr *nlh_src)
 	nla_for_each_attr(nla, attrs, len, remaining) {
 		int err;
 
-		switch (type) {
+		switch (nlh_src->nlmsg_type) {
 		case XFRM_MSG_NEWSPDINFO:
 			err = xfrm_nla_cpy(dst, nla, nla_len(nla));
 			break;
@@ -437,6 +438,7 @@ static int xfrm_xlate32_attr(void *dst, const struct nlattr *nla,
 		NL_SET_ERR_MSG(extack, "Bad attribute");
 		return -EOPNOTSUPP;
 	}
+	type = array_index_nospec(type, XFRMA_MAX + 1);
 	if (nla_len(nla) < compat_policy[type].len) {
 		NL_SET_ERR_MSG(extack, "Attribute bad length");
 		return -EOPNOTSUPP;
diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index 3d8668d62e63..7c5958a2eed4 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -278,8 +278,7 @@ static int xfrm6_remove_tunnel_encap(struct xfrm_state *x, struct sk_buff *skb)
 		goto out;
 
 	if (x->props.flags & XFRM_STATE_DECAP_DSCP)
-		ipv6_copy_dscp(ipv6_get_dsfield(ipv6_hdr(skb)),
-			       ipipv6_hdr(skb));
+		ipv6_copy_dscp(XFRM_MODE_SKB_CB(skb)->tos, ipipv6_hdr(skb));
 	if (!(x->props.flags & XFRM_STATE_NOECN))
 		ipip6_ecn_decapsulate(skb);
 
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 6a6ea25dc4ce..83c69d175493 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9072,6 +9072,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x89aa, "HP EliteBook 630 G9", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x89c3, "HP", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x89ca, "HP", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
+	SND_PCI_QUIRK(0x103c, 0x89d3, "HP EliteBook 645 G9 (MB 89D2)", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8a78, "HP Dev One", ALC285_FIXUP_HP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x103c, 0x8aa0, "HP ProBook 440 G9 (MB 8A9E)", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8aa3, "HP ProBook 450 G9 (MB 8AA1)", ALC236_FIXUP_HP_GPIO_LED),
@@ -9164,6 +9165,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x144d, 0xc812, "Samsung Notebook Pen S (NT950SBE-X58)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc830, "Samsung Galaxy Book Ion (NT950XCJ-X716A)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc832, "Samsung Galaxy Book Flex Alpha (NP730QCJ)", ALC256_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET),
+	SND_PCI_QUIRK(0x144d, 0xca03, "Samsung Galaxy Book2 Pro 360 (NP930QED)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x1458, 0xfa53, "Gigabyte BXBT-2807", ALC283_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1462, 0xb120, "MSI Cubi MS-B120", ALC283_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1462, 0xb171, "Cubi N 8GL (MS-B171)", ALC283_FIXUP_HEADSET_MIC),
@@ -9335,6 +9337,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1b7d, 0xa831, "Ordissimo EVE2 ", ALC269VB_FIXUP_ORDISSIMO_EVE2), /* Also known as Malata PC-B1303 */
 	SND_PCI_QUIRK(0x1c06, 0x2013, "Lemote A1802", ALC269_FIXUP_LEMOTE_A1802),
 	SND_PCI_QUIRK(0x1c06, 0x2015, "Lemote A190X", ALC269_FIXUP_LEMOTE_A190X),
+	SND_PCI_QUIRK(0x1c6c, 0x1251, "Positivo N14KP6-TG", ALC288_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1d05, 0x1132, "TongFang PHxTxX1", ALC256_FIXUP_SET_COEF_DEFAULTS),
 	SND_PCI_QUIRK(0x1d05, 0x1096, "TongFang GMxMRxx", ALC269_FIXUP_NO_SHUTUP),
 	SND_PCI_QUIRK(0x1d05, 0x1100, "TongFang GKxNRxx", ALC269_FIXUP_NO_SHUTUP),
diff --git a/sound/pci/lx6464es/lx_core.c b/sound/pci/lx6464es/lx_core.c
index d3f58a3d17fb..b5b0d43bb8dc 100644
--- a/sound/pci/lx6464es/lx_core.c
+++ b/sound/pci/lx6464es/lx_core.c
@@ -493,12 +493,11 @@ int lx_buffer_ask(struct lx6464es *chip, u32 pipe, int is_capture,
 		dev_dbg(chip->card->dev,
 			"CMD_08_ASK_BUFFERS: needed %d, freed %d\n",
 			    *r_needed, *r_freed);
-		for (i = 0; i < MAX_STREAM_BUFFER; ++i) {
-			for (i = 0; i != chip->rmh.stat_len; ++i)
-				dev_dbg(chip->card->dev,
-					"  stat[%d]: %x, %x\n", i,
-					    chip->rmh.stat[i],
-					    chip->rmh.stat[i] & MASK_DATA_SIZE);
+		for (i = 0; i < MAX_STREAM_BUFFER && i < chip->rmh.stat_len;
+		     ++i) {
+			dev_dbg(chip->card->dev, "  stat[%d]: %x, %x\n", i,
+				chip->rmh.stat[i],
+				chip->rmh.stat[i] & MASK_DATA_SIZE);
 		}
 	}
 
diff --git a/sound/soc/soc-topology.c b/sound/soc/soc-topology.c
index eff8d4f71561..55b69e3c6718 100644
--- a/sound/soc/soc-topology.c
+++ b/sound/soc/soc-topology.c
@@ -1480,13 +1480,17 @@ static int soc_tplg_dapm_widget_create(struct soc_tplg *tplg,
 
 	template.num_kcontrols = le32_to_cpu(w->num_kcontrols);
 	kc = devm_kcalloc(tplg->dev, le32_to_cpu(w->num_kcontrols), sizeof(*kc), GFP_KERNEL);
-	if (!kc)
+	if (!kc) {
+		ret = -ENOMEM;
 		goto hdr_err;
+	}
 
 	kcontrol_type = devm_kcalloc(tplg->dev, le32_to_cpu(w->num_kcontrols), sizeof(unsigned int),
 				     GFP_KERNEL);
-	if (!kcontrol_type)
+	if (!kcontrol_type) {
+		ret = -ENOMEM;
 		goto hdr_err;
+	}
 
 	for (i = 0; i < w->num_kcontrols; i++) {
 		control_hdr = (struct snd_soc_tplg_ctl_hdr *)tplg->pos;
diff --git a/sound/synth/emux/emux_nrpn.c b/sound/synth/emux/emux_nrpn.c
index 8056422ed7c5..0d6b82ae2955 100644
--- a/sound/synth/emux/emux_nrpn.c
+++ b/sound/synth/emux/emux_nrpn.c
@@ -349,6 +349,9 @@ int
 snd_emux_xg_control(struct snd_emux_port *port, struct snd_midi_channel *chan,
 		    int param)
 {
+	if (param >= ARRAY_SIZE(chan->control))
+		return -EINVAL;
+
 	return send_converted_effect(xg_effects, ARRAY_SIZE(xg_effects),
 				     port, chan, param,
 				     chan->control[param],
diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index c9507df9c05b..b7d946cf14eb 100644
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -817,14 +817,14 @@ sysctl_set()
 	local value=$1; shift
 
 	SYSCTL_ORIG[$key]=$(sysctl -n $key)
-	sysctl -qw $key=$value
+	sysctl -qw $key="$value"
 }
 
 sysctl_restore()
 {
 	local key=$1; shift
 
-	sysctl -qw $key=${SYSCTL_ORIG["$key"]}
+	sysctl -qw $key="${SYSCTL_ORIG[$key]}"
 }
 
 forwarding_enable()
