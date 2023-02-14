Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E50E8696CC5
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 19:25:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232689AbjBNSZZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 13:25:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232730AbjBNSZV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 13:25:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92A9B2BF3C;
        Tue, 14 Feb 2023 10:25:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E26A161825;
        Tue, 14 Feb 2023 18:25:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDF17C4339B;
        Tue, 14 Feb 2023 18:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676399115;
        bh=o9wrjKXFFP2zOysSTSxXNC8ZdRXvnE6pukVyBqe4Rss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XQyfELR6B/9UCp2KKMwg+lQ6djtdwoygqiycBDm9+R2xwgrp6iy7NPXUAFTN+DC8Y
         CWT8Wq0wcHKZEmMuXMpbNWbWTPIO7AVZHDoq3nvuw506nwm4wf52j/n7neLlj2GGIa
         +5ZFIU/L06haXjSHMdNFxuf+D5WLwxGmJvUbqTfk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 6.1.12
Date:   Tue, 14 Feb 2023 19:25:05 +0100
Message-Id: <167639910518680@kroah.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <167639910576204@kroah.com>
References: <167639910576204@kroah.com>
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
index e039f2af1772..23390805e521 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 6
 PATCHLEVEL = 1
-SUBLEVEL = 11
+SUBLEVEL = 12
 EXTRAVERSION =
 NAME = Hurr durr I'ma ninja sloth
 
diff --git a/arch/arm64/boot/dts/amlogic/meson-axg.dtsi b/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
index 04f797b5a012..73cd1791a13f 100644
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
index 45947c1031c4..894cea697550 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
@@ -2318,7 +2318,7 @@ uart_A: serial@24000 {
 		sd_emmc_a: sd@ffe03000 {
 			compatible = "amlogic,meson-axg-mmc";
 			reg = <0x0 0xffe03000 0x0 0x800>;
-			interrupts = <GIC_SPI 189 IRQ_TYPE_EDGE_RISING>;
+			interrupts = <GIC_SPI 189 IRQ_TYPE_LEVEL_HIGH>;
 			status = "disabled";
 			clocks = <&clkc CLKID_SD_EMMC_A>,
 				 <&clkc CLKID_SD_EMMC_A_CLK0>,
@@ -2330,7 +2330,7 @@ sd_emmc_a: sd@ffe03000 {
 		sd_emmc_b: sd@ffe05000 {
 			compatible = "amlogic,meson-axg-mmc";
 			reg = <0x0 0xffe05000 0x0 0x800>;
-			interrupts = <GIC_SPI 190 IRQ_TYPE_EDGE_RISING>;
+			interrupts = <GIC_SPI 190 IRQ_TYPE_LEVEL_HIGH>;
 			status = "disabled";
 			clocks = <&clkc CLKID_SD_EMMC_B>,
 				 <&clkc CLKID_SD_EMMC_B_CLK0>,
@@ -2342,7 +2342,7 @@ sd_emmc_b: sd@ffe05000 {
 		sd_emmc_c: mmc@ffe07000 {
 			compatible = "amlogic,meson-axg-mmc";
 			reg = <0x0 0xffe07000 0x0 0x800>;
-			interrupts = <GIC_SPI 191 IRQ_TYPE_EDGE_RISING>;
+			interrupts = <GIC_SPI 191 IRQ_TYPE_LEVEL_HIGH>;
 			status = "disabled";
 			clocks = <&clkc CLKID_SD_EMMC_C>,
 				 <&clkc CLKID_SD_EMMC_C_CLK0>,
diff --git a/arch/arm64/boot/dts/amlogic/meson-gx.dtsi b/arch/arm64/boot/dts/amlogic/meson-gx.dtsi
index 023a52005494..fa6cff4a2ebc 100644
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
diff --git a/arch/arm64/boot/dts/mediatek/mt8195.dtsi b/arch/arm64/boot/dts/mediatek/mt8195.dtsi
index 0b85b5874a4f..6f5fa7ca4901 100644
--- a/arch/arm64/boot/dts/mediatek/mt8195.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8195.dtsi
@@ -1966,7 +1966,7 @@ vencsys_core1: clock-controller@1b000000 {
 		};
 
 		vdosys0: syscon@1c01a000 {
-			compatible = "mediatek,mt8195-mmsys", "syscon";
+			compatible = "mediatek,mt8195-vdosys0", "mediatek,mt8195-mmsys", "syscon";
 			reg = <0 0x1c01a000 0 0x1000>;
 			mboxes = <&gce0 0 CMDQ_THR_PRIO_4>;
 			#clock-cells = <1>;
@@ -2101,7 +2101,7 @@ larb1: larb@1c019000 {
 		};
 
 		vdosys1: syscon@1c100000 {
-			compatible = "mediatek,mt8195-mmsys", "syscon";
+			compatible = "mediatek,mt8195-vdosys1", "syscon";
 			reg = <0 0x1c100000 0 0x1000>;
 			#clock-cells = <1>;
 		};
diff --git a/arch/arm64/boot/dts/rockchip/rk3399.dtsi b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
index 92c2207e686c..59858f2dc8b9 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
@@ -2221,13 +2221,11 @@ pcfg_input_enable: pcfg-input-enable {
 		pcfg_input_pull_up: pcfg-input-pull-up {
 			input-enable;
 			bias-pull-up;
-			drive-strength = <2>;
 		};
 
 		pcfg_input_pull_down: pcfg-input-pull-down {
 			input-enable;
 			bias-pull-down;
-			drive-strength = <2>;
 		};
 
 		clock {
diff --git a/arch/arm64/boot/dts/rockchip/rk3568-rock-3a.dts b/arch/arm64/boot/dts/rockchip/rk3568-rock-3a.dts
index 539ef8cc7792..44313a18e484 100644
--- a/arch/arm64/boot/dts/rockchip/rk3568-rock-3a.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3568-rock-3a.dts
@@ -642,7 +642,7 @@ &sdmmc0 {
 	disable-wp;
 	pinctrl-names = "default";
 	pinctrl-0 = <&sdmmc0_bus4 &sdmmc0_clk &sdmmc0_cmd &sdmmc0_det>;
-	sd-uhs-sdr104;
+	sd-uhs-sdr50;
 	vmmc-supply = <&vcc3v3_sd>;
 	vqmmc-supply = <&vccio_sd>;
 	status = "okay";
diff --git a/arch/powerpc/kernel/interrupt.c b/arch/powerpc/kernel/interrupt.c
index fc6631a80527..0ec1581619db 100644
--- a/arch/powerpc/kernel/interrupt.c
+++ b/arch/powerpc/kernel/interrupt.c
@@ -50,16 +50,18 @@ static inline bool exit_must_hard_disable(void)
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
diff --git a/arch/riscv/kernel/probes/kprobes.c b/arch/riscv/kernel/probes/kprobes.c
index 388ecada500c..cca2b3a2135a 100644
--- a/arch/riscv/kernel/probes/kprobes.c
+++ b/arch/riscv/kernel/probes/kprobes.c
@@ -65,16 +65,18 @@ static bool __kprobes arch_check_kprobe(struct kprobe *p)
 
 int __kprobes arch_prepare_kprobe(struct kprobe *p)
 {
-	unsigned long probe_addr = (unsigned long)p->addr;
+	u16 *insn = (u16 *)p->addr;
 
-	if (probe_addr & 0x1)
+	if ((unsigned long)insn & 0x1)
 		return -EILSEQ;
 
 	if (!arch_check_kprobe(p))
 		return -EILSEQ;
 
 	/* copy instruction */
-	p->opcode = *p->addr;
+	p->opcode = (kprobe_opcode_t)(*insn++);
+	if (GET_INSN_LENGTH(p->opcode) == 4)
+		p->opcode |= (kprobe_opcode_t)(*insn) << 16;
 
 	/* decode instruction */
 	switch (riscv_probe_decode_insn(p->addr, &p->ainsn.api)) {
diff --git a/arch/riscv/kernel/stacktrace.c b/arch/riscv/kernel/stacktrace.c
index bcfe9eb55f80..85cd5442d2f8 100644
--- a/arch/riscv/kernel/stacktrace.c
+++ b/arch/riscv/kernel/stacktrace.c
@@ -30,6 +30,7 @@ void notrace walk_stackframe(struct task_struct *task, struct pt_regs *regs,
 		fp = (unsigned long)__builtin_frame_address(0);
 		sp = current_stack_pointer;
 		pc = (unsigned long)walk_stackframe;
+		level = -1;
 	} else {
 		/* task blocked in __switch_to */
 		fp = task->thread.s[0];
@@ -41,7 +42,7 @@ void notrace walk_stackframe(struct task_struct *task, struct pt_regs *regs,
 		unsigned long low, high;
 		struct stackframe *frame;
 
-		if (unlikely(!__kernel_text_address(pc) || (level++ >= 1 && !fn(arg, pc))))
+		if (unlikely(!__kernel_text_address(pc) || (level++ >= 0 && !fn(arg, pc))))
 			break;
 
 		/* Validate frame pointer */
diff --git a/arch/riscv/mm/cacheflush.c b/arch/riscv/mm/cacheflush.c
index 57b40a350420..8a2e7040f8fc 100644
--- a/arch/riscv/mm/cacheflush.c
+++ b/arch/riscv/mm/cacheflush.c
@@ -83,8 +83,10 @@ void flush_icache_pte(pte_t pte)
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
index b2da7cb64b31..92729c38853d 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -463,5 +463,6 @@
 #define X86_BUG_MMIO_UNKNOWN		X86_BUG(26) /* CPU is too old and its MMIO Stale Data status is unknown */
 #define X86_BUG_RETBLEED		X86_BUG(27) /* CPU is affected by RETBleed */
 #define X86_BUG_EIBRS_PBRSB		X86_BUG(28) /* EIBRS is vulnerable to Post Barrier RSB Predictions */
+#define X86_BUG_SMT_RSB			X86_BUG(29) /* CPU is vulnerable to Cross-Thread Return Address Predictions */
 
 #endif /* _ASM_X86_CPUFEATURES_H */
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 3e508f239098..e80572b674b7 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1235,6 +1235,8 @@ static const __initconst struct x86_cpu_id cpu_vuln_whitelist[] = {
 #define MMIO_SBDS	BIT(2)
 /* CPU is affected by RETbleed, speculating where you would not expect it */
 #define RETBLEED	BIT(3)
+/* CPU is affected by SMT (cross-thread) return predictions */
+#define SMT_RSB		BIT(4)
 
 static const struct x86_cpu_id cpu_vuln_blacklist[] __initconst = {
 	VULNBL_INTEL_STEPPINGS(IVYBRIDGE,	X86_STEPPING_ANY,		SRBDS),
@@ -1266,8 +1268,8 @@ static const struct x86_cpu_id cpu_vuln_blacklist[] __initconst = {
 
 	VULNBL_AMD(0x15, RETBLEED),
 	VULNBL_AMD(0x16, RETBLEED),
-	VULNBL_AMD(0x17, RETBLEED),
-	VULNBL_HYGON(0x18, RETBLEED),
+	VULNBL_AMD(0x17, RETBLEED | SMT_RSB),
+	VULNBL_HYGON(0x18, RETBLEED | SMT_RSB),
 	{}
 };
 
@@ -1385,6 +1387,9 @@ static void __init cpu_set_bug_bits(struct cpuinfo_x86 *c)
 	    !(ia32_cap & ARCH_CAP_PBRSB_NO))
 		setup_force_cpu_bug(X86_BUG_EIBRS_PBRSB);
 
+	if (cpu_matches(cpu_vuln_blacklist, SMT_RSB))
+		setup_force_cpu_bug(X86_BUG_SMT_RSB);
+
 	if (cpu_matches(cpu_vuln_whitelist, NO_MELTDOWN))
 		return;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 69227f77b201..a0c35b948c30 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -192,6 +192,10 @@ module_param(enable_pmu, bool, 0444);
 bool __read_mostly eager_page_split = true;
 module_param(eager_page_split, bool, 0644);
 
+/* Enable/disable SMT_RSB bug mitigation */
+bool __read_mostly mitigate_smt_rsb;
+module_param(mitigate_smt_rsb, bool, 0444);
+
 /*
  * Restoring the host value for MSRs that are only consumed when running in
  * usermode, e.g. SYSCALL MSRs and TSC_AUX, can be deferred until the CPU
@@ -4435,10 +4439,15 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = KVM_CLOCK_VALID_FLAGS;
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
@@ -6214,15 +6223,26 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
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
@@ -13730,6 +13750,7 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_msr_protocol_exit);
 static int __init kvm_x86_init(void)
 {
 	kvm_mmu_x86_module_init();
+	mitigate_smt_rsb &= boot_cpu_has_bug(X86_BUG_SMT_RSB) && cpu_smt_possible();
 	return 0;
 }
 module_init(kvm_x86_init);
diff --git a/drivers/clk/ingenic/jz4760-cgu.c b/drivers/clk/ingenic/jz4760-cgu.c
index ecd395ac8a28..e407f00bd594 100644
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
 
diff --git a/drivers/clk/microchip/clk-mpfs-ccc.c b/drivers/clk/microchip/clk-mpfs-ccc.c
index 32aae880a14f..0ddc73e07be4 100644
--- a/drivers/clk/microchip/clk-mpfs-ccc.c
+++ b/drivers/clk/microchip/clk-mpfs-ccc.c
@@ -164,12 +164,11 @@ static int mpfs_ccc_register_outputs(struct device *dev, struct mpfs_ccc_out_hw_
 
 	for (unsigned int i = 0; i < num_clks; i++) {
 		struct mpfs_ccc_out_hw_clock *out_hw = &out_hws[i];
-		char *name = devm_kzalloc(dev, 23, GFP_KERNEL);
+		char *name = devm_kasprintf(dev, GFP_KERNEL, "%s_out%u", parent->name, i);
 
 		if (!name)
 			return -ENOMEM;
 
-		snprintf(name, 23, "%s_out%u", parent->name, i);
 		out_hw->divider.hw.init = CLK_HW_INIT_HW(name, &parent->hw, &clk_divider_ops, 0);
 		out_hw->divider.reg = data->pll_base[i / MPFS_CCC_OUTPUTS_PER_PLL] +
 			out_hw->reg_offset;
@@ -201,14 +200,13 @@ static int mpfs_ccc_register_plls(struct device *dev, struct mpfs_ccc_pll_hw_clo
 
 	for (unsigned int i = 0; i < num_clks; i++) {
 		struct mpfs_ccc_pll_hw_clock *pll_hw = &pll_hws[i];
-		char *name = devm_kzalloc(dev, 18, GFP_KERNEL);
 
-		if (!name)
+		pll_hw->name = devm_kasprintf(dev, GFP_KERNEL, "ccc%s_pll%u",
+					      strchrnul(dev->of_node->full_name, '@'), i);
+		if (!pll_hw->name)
 			return -ENOMEM;
 
 		pll_hw->base = data->pll_base[i];
-		snprintf(name, 18, "ccc%s_pll%u", strchrnul(dev->of_node->full_name, '@'), i);
-		pll_hw->name = (const char *)name;
 		pll_hw->hw.init = CLK_HW_INIT_PARENTS_DATA_FIXED_SIZE(pll_hw->name,
 								      pll_hw->parents,
 								      &mpfs_ccc_pll_ops, 0);
diff --git a/drivers/cpufreq/qcom-cpufreq-hw.c b/drivers/cpufreq/qcom-cpufreq-hw.c
index 3c623a0bc147..d10bf7635a0d 100644
--- a/drivers/cpufreq/qcom-cpufreq-hw.c
+++ b/drivers/cpufreq/qcom-cpufreq-hw.c
@@ -137,40 +137,42 @@ static unsigned long qcom_lmh_get_throttle_freq(struct qcom_cpufreq_data *data)
 	return lval * xo_rate;
 }
 
-/* Get the current frequency of the CPU (after throttling) */
-static unsigned int qcom_cpufreq_hw_get(unsigned int cpu)
+/* Get the frequency requested by the cpufreq core for the CPU */
+static unsigned int qcom_cpufreq_get_freq(unsigned int cpu)
 {
 	struct qcom_cpufreq_data *data;
+	const struct qcom_cpufreq_soc_data *soc_data;
 	struct cpufreq_policy *policy;
+	unsigned int index;
 
 	policy = cpufreq_cpu_get_raw(cpu);
 	if (!policy)
 		return 0;
 
 	data = policy->driver_data;
+	soc_data = data->soc_data;
 
-	return qcom_lmh_get_throttle_freq(data) / HZ_PER_KHZ;
+	index = readl_relaxed(data->base + soc_data->reg_perf_state);
+	index = min(index, LUT_MAX_ENTRIES - 1);
+
+	return policy->freq_table[index].frequency;
 }
 
-/* Get the frequency requested by the cpufreq core for the CPU */
-static unsigned int qcom_cpufreq_get_freq(unsigned int cpu)
+static unsigned int qcom_cpufreq_hw_get(unsigned int cpu)
 {
 	struct qcom_cpufreq_data *data;
-	const struct qcom_cpufreq_soc_data *soc_data;
 	struct cpufreq_policy *policy;
-	unsigned int index;
 
 	policy = cpufreq_cpu_get_raw(cpu);
 	if (!policy)
 		return 0;
 
 	data = policy->driver_data;
-	soc_data = data->soc_data;
 
-	index = readl_relaxed(data->base + soc_data->reg_perf_state);
-	index = min(index, LUT_MAX_ENTRIES - 1);
+	if (data->throttle_irq >= 0)
+		return qcom_lmh_get_throttle_freq(data) / HZ_PER_KHZ;
 
-	return policy->freq_table[index].frequency;
+	return qcom_cpufreq_get_freq(cpu);
 }
 
 static unsigned int qcom_cpufreq_hw_fast_switch(struct cpufreq_policy *policy,
diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index c4f32c32dfd5..9709bbf773b7 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -131,7 +131,7 @@ static int cxl_region_decode_reset(struct cxl_region *cxlr, int count)
 		struct cxl_memdev *cxlmd = cxled_to_memdev(cxled);
 		struct cxl_port *iter = cxled_to_port(cxled);
 		struct cxl_ep *ep;
-		int rc;
+		int rc = 0;
 
 		while (!is_cxl_root(to_cxl_port(iter->dev.parent)))
 			iter = to_cxl_port(iter->dev.parent);
@@ -143,7 +143,8 @@ static int cxl_region_decode_reset(struct cxl_region *cxlr, int count)
 
 			cxl_rr = cxl_rr_load(iter, cxlr);
 			cxld = cxl_rr->decoder;
-			rc = cxld->reset(cxld);
+			if (cxld->reset)
+				rc = cxld->reset(cxld);
 			if (rc)
 				return rc;
 		}
@@ -186,7 +187,8 @@ static int cxl_region_decode_commit(struct cxl_region *cxlr)
 			     iter = ep->next, ep = cxl_ep_load(iter, cxlmd)) {
 				cxl_rr = cxl_rr_load(iter, cxlr);
 				cxld = cxl_rr->decoder;
-				cxld->reset(cxld);
+				if (cxld->reset)
+					cxld->reset(cxld);
 			}
 
 			cxled->cxld.reset(&cxled->cxld);
@@ -991,10 +993,10 @@ static int cxl_port_setup_targets(struct cxl_port *port,
 		int i, distance;
 
 		/*
-		 * Passthrough ports impose no distance requirements between
+		 * Passthrough decoders impose no distance requirements between
 		 * peers
 		 */
-		if (port->nr_dports == 1)
+		if (cxl_rr->nr_targets == 1)
 			distance = 0;
 		else
 			distance = p->nr_targets / cxl_rr->nr_targets;
diff --git a/drivers/firmware/efi/libstub/arm64-stub.c b/drivers/firmware/efi/libstub/arm64-stub.c
index f9de5217ea65..42282c5c3fe6 100644
--- a/drivers/firmware/efi/libstub/arm64-stub.c
+++ b/drivers/firmware/efi/libstub/arm64-stub.c
@@ -20,10 +20,13 @@ static bool system_needs_vamap(void)
 	const u8 *type1_family = efi_get_smbios_string(1, family);
 
 	/*
-	 * Ampere Altra machines crash in SetTime() if SetVirtualAddressMap()
-	 * has not been called prior.
+	 * Ampere eMAG, Altra, and Altra Max machines crash in SetTime() if
+	 * SetVirtualAddressMap() has not been called prior.
 	 */
-	if (!type1_family || strcmp(type1_family, "Altra"))
+	if (!type1_family || (
+	    strcmp(type1_family, "eMAG") &&
+	    strcmp(type1_family, "Altra") &&
+	    strcmp(type1_family, "Altra Max")))
 		return false;
 
 	efi_warn("Working around broken SetVirtualAddressMap()\n");
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
index d0d99ed607dd..6fdb679321d0 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
@@ -564,7 +564,13 @@ void amdgpu_fence_driver_sw_fini(struct amdgpu_device *adev)
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
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_pt.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_pt.c
index b5f3bba851db..01e42bdd8e4e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_pt.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_pt.c
@@ -974,7 +974,7 @@ int amdgpu_vm_ptes_update(struct amdgpu_vm_update_params *params,
 			trace_amdgpu_vm_update_ptes(params, frag_start, upd_end,
 						    min(nptes, 32u), dst, incr,
 						    upd_flags,
-						    vm->task_info.pid,
+						    vm->task_info.tgid,
 						    vm->immediate.fence_context);
 			amdgpu_vm_pte_update_flags(params, to_amdgpu_bo_vm(pt),
 						   cursor.level, pe_start, dst,
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index b425ec00817c..988b1c947aef 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1193,24 +1193,38 @@ static void mmhub_read_system_context(struct amdgpu_device *adev, struct dc_phy_
 
 	memset(pa_config, 0, sizeof(*pa_config));
 
-	logical_addr_low  = min(adev->gmc.fb_start, adev->gmc.agp_start) >> 18;
-	pt_base = amdgpu_gmc_pd_addr(adev->gart.bo);
-
-	if (adev->apu_flags & AMD_APU_IS_RAVEN2)
-		/*
-		 * Raven2 has a HW issue that it is unable to use the vram which
-		 * is out of MC_VM_SYSTEM_APERTURE_HIGH_ADDR. So here is the
-		 * workaround that increase system aperture high address (add 1)
-		 * to get rid of the VM fault and hardware hang.
-		 */
-		logical_addr_high = max((adev->gmc.fb_end >> 18) + 0x1, adev->gmc.agp_end >> 18);
-	else
-		logical_addr_high = max(adev->gmc.fb_end, adev->gmc.agp_end) >> 18;
-
 	agp_base = 0;
 	agp_bot = adev->gmc.agp_start >> 24;
 	agp_top = adev->gmc.agp_end >> 24;
 
+	/* AGP aperture is disabled */
+	if (agp_bot == agp_top) {
+		logical_addr_low  = adev->gmc.vram_start >> 18;
+		if (adev->apu_flags & AMD_APU_IS_RAVEN2)
+			/*
+			 * Raven2 has a HW issue that it is unable to use the vram which
+			 * is out of MC_VM_SYSTEM_APERTURE_HIGH_ADDR. So here is the
+			 * workaround that increase system aperture high address (add 1)
+			 * to get rid of the VM fault and hardware hang.
+			 */
+			logical_addr_high = (adev->gmc.fb_end >> 18) + 0x1;
+		else
+			logical_addr_high = adev->gmc.vram_end >> 18;
+	} else {
+		logical_addr_low  = min(adev->gmc.fb_start, adev->gmc.agp_start) >> 18;
+		if (adev->apu_flags & AMD_APU_IS_RAVEN2)
+			/*
+			 * Raven2 has a HW issue that it is unable to use the vram which
+			 * is out of MC_VM_SYSTEM_APERTURE_HIGH_ADDR. So here is the
+			 * workaround that increase system aperture high address (add 1)
+			 * to get rid of the VM fault and hardware hang.
+			 */
+			logical_addr_high = max((adev->gmc.fb_end >> 18) + 0x1, adev->gmc.agp_end >> 18);
+		else
+			logical_addr_high = max(adev->gmc.fb_end, adev->gmc.agp_end) >> 18;
+	}
+
+	pt_base = amdgpu_gmc_pd_addr(adev->gart.bo);
 
 	page_table_start.high_part = (u32)(adev->gmc.gart_start >> 44) & 0xF;
 	page_table_start.low_part = (u32)(adev->gmc.gart_start >> 12);
diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
index c06538c37a11..55d63d860ef1 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
@@ -3612,7 +3612,7 @@ void dcn10_set_cursor_position(struct pipe_ctx *pipe_ctx)
 						(int)hubp->curs_attr.width || pos_cpy.x
 						<= (int)hubp->curs_attr.width +
 						pipe_ctx->plane_state->src_rect.x) {
-						pos_cpy.x = temp_x + viewport_width;
+						pos_cpy.x = 2 * viewport_width - temp_x;
 					}
 				}
 			} else {
diff --git a/drivers/gpu/drm/amd/pm/amdgpu_pm.c b/drivers/gpu/drm/amd/pm/amdgpu_pm.c
index 236657eece47..41635694e521 100644
--- a/drivers/gpu/drm/amd/pm/amdgpu_pm.c
+++ b/drivers/gpu/drm/amd/pm/amdgpu_pm.c
@@ -1991,6 +1991,8 @@ static int default_attr_update(struct amdgpu_device *adev, struct amdgpu_device_
 		case IP_VERSION(9, 4, 2):
 		case IP_VERSION(10, 3, 0):
 		case IP_VERSION(11, 0, 0):
+		case IP_VERSION(11, 0, 1):
+		case IP_VERSION(11, 0, 2):
 			*states = ATTR_STATE_SUPPORTED;
 			break;
 		default:
diff --git a/drivers/gpu/drm/amd/pm/swsmu/inc/pmfw_if/smu13_driver_if_v13_0_0.h b/drivers/gpu/drm/amd/pm/swsmu/inc/pmfw_if/smu13_driver_if_v13_0_0.h
index d6b964cf73bd..4bc7aee4d44f 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/inc/pmfw_if/smu13_driver_if_v13_0_0.h
+++ b/drivers/gpu/drm/amd/pm/swsmu/inc/pmfw_if/smu13_driver_if_v13_0_0.h
@@ -123,7 +123,8 @@
 									(1 << FEATURE_DS_FCLK_BIT) | \
 									(1 << FEATURE_DS_LCLK_BIT) | \
 									(1 << FEATURE_DS_DCFCLK_BIT) | \
-									(1 << FEATURE_DS_UCLK_BIT))
+									(1 << FEATURE_DS_UCLK_BIT) | \
+									(1ULL << FEATURE_DS_VCN_BIT))
 
 //For use with feature control messages
 typedef enum {
@@ -522,9 +523,9 @@ typedef enum  {
   TEMP_HOTSPOT_M,
   TEMP_MEM,
   TEMP_VR_GFX,
-  TEMP_VR_SOC,
   TEMP_VR_MEM0,
   TEMP_VR_MEM1,
+  TEMP_VR_SOC,
   TEMP_VR_U,
   TEMP_LIQUID0,
   TEMP_LIQUID1,
diff --git a/drivers/gpu/drm/amd/pm/swsmu/inc/pmfw_if/smu13_driver_if_v13_0_7.h b/drivers/gpu/drm/amd/pm/swsmu/inc/pmfw_if/smu13_driver_if_v13_0_7.h
index d6b13933a98f..48a3a3952ceb 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/inc/pmfw_if/smu13_driver_if_v13_0_7.h
+++ b/drivers/gpu/drm/amd/pm/swsmu/inc/pmfw_if/smu13_driver_if_v13_0_7.h
@@ -113,20 +113,21 @@
 #define NUM_FEATURES                          64
 
 #define ALLOWED_FEATURE_CTRL_DEFAULT 0xFFFFFFFFFFFFFFFFULL
-#define ALLOWED_FEATURE_CTRL_SCPM        (1 << FEATURE_DPM_GFXCLK_BIT) | \
-                                         (1 << FEATURE_DPM_GFX_POWER_OPTIMIZER_BIT) | \
-                                         (1 << FEATURE_DPM_UCLK_BIT) | \
-                                         (1 << FEATURE_DPM_FCLK_BIT) | \
-                                         (1 << FEATURE_DPM_SOCCLK_BIT) | \
-                                         (1 << FEATURE_DPM_MP0CLK_BIT) | \
-                                         (1 << FEATURE_DPM_LINK_BIT) | \
-                                         (1 << FEATURE_DPM_DCN_BIT) | \
-                                         (1 << FEATURE_DS_GFXCLK_BIT) | \
-                                         (1 << FEATURE_DS_SOCCLK_BIT) | \
-                                         (1 << FEATURE_DS_FCLK_BIT) | \
-                                         (1 << FEATURE_DS_LCLK_BIT) | \
-                                         (1 << FEATURE_DS_DCFCLK_BIT) | \
-                                         (1 << FEATURE_DS_UCLK_BIT)
+#define ALLOWED_FEATURE_CTRL_SCPM	((1 << FEATURE_DPM_GFXCLK_BIT) | \
+					(1 << FEATURE_DPM_GFX_POWER_OPTIMIZER_BIT) | \
+					(1 << FEATURE_DPM_UCLK_BIT) | \
+					(1 << FEATURE_DPM_FCLK_BIT) | \
+					(1 << FEATURE_DPM_SOCCLK_BIT) | \
+					(1 << FEATURE_DPM_MP0CLK_BIT) | \
+					(1 << FEATURE_DPM_LINK_BIT) | \
+					(1 << FEATURE_DPM_DCN_BIT) | \
+					(1 << FEATURE_DS_GFXCLK_BIT) | \
+					(1 << FEATURE_DS_SOCCLK_BIT) | \
+					(1 << FEATURE_DS_FCLK_BIT) | \
+					(1 << FEATURE_DS_LCLK_BIT) | \
+					(1 << FEATURE_DS_DCFCLK_BIT) | \
+					(1 << FEATURE_DS_UCLK_BIT) | \
+					(1ULL << FEATURE_DS_VCN_BIT))
 
 //For use with feature control messages
 typedef enum {
diff --git a/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h b/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h
index e8c6febb8b64..992163e66f7b 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h
+++ b/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h
@@ -28,11 +28,11 @@
 #define SMU13_DRIVER_IF_VERSION_INV 0xFFFFFFFF
 #define SMU13_DRIVER_IF_VERSION_YELLOW_CARP 0x04
 #define SMU13_DRIVER_IF_VERSION_ALDE 0x08
-#define SMU13_DRIVER_IF_VERSION_SMU_V13_0_0_0 0x34
+#define SMU13_DRIVER_IF_VERSION_SMU_V13_0_0_0 0x37
 #define SMU13_DRIVER_IF_VERSION_SMU_V13_0_4 0x07
 #define SMU13_DRIVER_IF_VERSION_SMU_V13_0_5 0x04
 #define SMU13_DRIVER_IF_VERSION_SMU_V13_0_0_10 0x32
-#define SMU13_DRIVER_IF_VERSION_SMU_V13_0_7 0x35
+#define SMU13_DRIVER_IF_VERSION_SMU_V13_0_7 0x37
 #define SMU13_DRIVER_IF_VERSION_SMU_V13_0_10 0x1D
 
 #define SMU13_MODE1_RESET_WAIT_TIME_IN_MS 500  //500ms
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
index cf96c3f2affe..508e392547d7 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
@@ -407,6 +407,9 @@ static int smu_v13_0_0_setup_pptable(struct smu_context *smu)
 	struct amdgpu_device *adev = smu->adev;
 	int ret = 0;
 
+	if (amdgpu_sriov_vf(smu->adev))
+		return 0;
+
 	ret = smu_v13_0_0_get_pptable_from_pmfw(smu,
 						&smu_table->power_play_table,
 						&smu_table->power_play_table_size);
@@ -1257,6 +1260,9 @@ static int smu_v13_0_0_get_thermal_temperature_range(struct smu_context *smu,
 		table_context->power_play_table;
 	PPTable_t *pptable = smu->smu_table.driver_pptable;
 
+	if (amdgpu_sriov_vf(smu->adev))
+		return 0;
+
 	if (!range)
 		return -EINVAL;
 
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
index eea06939e7da..5dfeab7b999b 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
@@ -124,6 +124,7 @@ static struct cmn2asic_msg_mapping smu_v13_0_7_message_map[SMU_MSG_MAX_COUNT] =
 	MSG_MAP(DFCstateControl,		PPSMC_MSG_SetExternalClientDfCstateAllow, 0),
 	MSG_MAP(ArmD3,				PPSMC_MSG_ArmD3,                       0),
 	MSG_MAP(AllowGpo,			PPSMC_MSG_SetGpoAllow,           0),
+	MSG_MAP(GetPptLimit,			PPSMC_MSG_GetPptLimit,                 0),
 };
 
 static struct cmn2asic_mapping smu_v13_0_7_clk_map[SMU_CLK_COUNT] = {
diff --git a/drivers/gpu/drm/i915/display/intel_bios.c b/drivers/gpu/drm/i915/display/intel_bios.c
index edbdb949b6ce..178a8cbb7583 100644
--- a/drivers/gpu/drm/i915/display/intel_bios.c
+++ b/drivers/gpu/drm/i915/display/intel_bios.c
@@ -2466,6 +2466,22 @@ static enum port dvo_port_to_port(struct drm_i915_private *i915,
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
@@ -3406,19 +3422,16 @@ bool intel_bios_is_dsi_present(struct drm_i915_private *i915,
 
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
@@ -3503,7 +3516,7 @@ bool intel_bios_get_dsc_params(struct intel_encoder *encoder,
 		if (!(child->device_type & DEVICE_TYPE_MIPI_OUTPUT))
 			continue;
 
-		if (child->dvo_port - DVO_PORT_MIPIA == encoder->port) {
+		if (dsi_dvo_port_to_port(i915, child->dvo_port) == encoder->port) {
 			if (!devdata->dsc)
 				return false;
 
diff --git a/drivers/gpu/drm/i915/display/skl_watermark.c b/drivers/gpu/drm/i915/display/skl_watermark.c
index 18178b01375e..a7adf02476f6 100644
--- a/drivers/gpu/drm/i915/display/skl_watermark.c
+++ b/drivers/gpu/drm/i915/display/skl_watermark.c
@@ -1587,7 +1587,8 @@ skl_crtc_allocate_plane_ddb(struct intel_atomic_state *state,
 				skl_check_wm_level(&wm->wm[level], ddb);
 
 			if (icl_need_wm1_wa(i915, plane_id) &&
-			    level == 1 && wm->wm[0].enable) {
+			    level == 1 && !wm->wm[level].enable &&
+			    wm->wm[0].enable) {
 				wm->wm[level].blocks = wm->wm[0].blocks;
 				wm->wm[level].lines = wm->wm[0].lines;
 				wm->wm[level].ignore_lines = wm->wm[0].ignore_lines;
diff --git a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
index f461e34cc5f0..0a123bb44c9f 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
@@ -3478,6 +3478,13 @@ i915_gem_do_execbuffer(struct drm_device *dev,
 				   eb.composite_fence :
 				   &eb.requests[0]->fence);
 
+	if (unlikely(eb.gem_context->syncobj)) {
+		drm_syncobj_replace_fence(eb.gem_context->syncobj,
+					  eb.composite_fence ?
+					  eb.composite_fence :
+					  &eb.requests[0]->fence);
+	}
+
 	if (out_fence) {
 		if (err == 0) {
 			fd_install(out_fence_fd, out_fence->file);
@@ -3489,13 +3496,6 @@ i915_gem_do_execbuffer(struct drm_device *dev,
 		}
 	}
 
-	if (unlikely(eb.gem_context->syncobj)) {
-		drm_syncobj_replace_fence(eb.gem_context->syncobj,
-					  eb.composite_fence ?
-					  eb.composite_fence :
-					  &eb.requests[0]->fence);
-	}
-
 	if (!out_fence && eb.composite_fence)
 		dma_fence_put(eb.composite_fence);
 
diff --git a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c b/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
index 2f7804492cd5..b7eae3aee166 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
@@ -579,7 +579,7 @@ static int shmem_object_init(struct intel_memory_region *mem,
 	mapping_set_gfp_mask(mapping, mask);
 	GEM_BUG_ON(!(mapping_gfp_mask(mapping) & __GFP_RECLAIM));
 
-	i915_gem_object_init(obj, &i915_gem_shmem_ops, &lock_class, 0);
+	i915_gem_object_init(obj, &i915_gem_shmem_ops, &lock_class, flags);
 	obj->mem_flags |= I915_BO_FLAG_STRUCT_PAGE;
 	obj->write_domain = I915_GEM_DOMAIN_CPU;
 	obj->read_domains = I915_GEM_DOMAIN_CPU;
diff --git a/drivers/gpu/drm/virtio/virtgpu_ioctl.c b/drivers/gpu/drm/virtio/virtgpu_ioctl.c
index 9f4a90493aea..da45215a933d 100644
--- a/drivers/gpu/drm/virtio/virtgpu_ioctl.c
+++ b/drivers/gpu/drm/virtio/virtgpu_ioctl.c
@@ -126,7 +126,6 @@ static int virtio_gpu_execbuffer_ioctl(struct drm_device *dev, void *data,
 	void __user *user_bo_handles = NULL;
 	struct virtio_gpu_object_array *buflist = NULL;
 	struct sync_file *sync_file;
-	int in_fence_fd = exbuf->fence_fd;
 	int out_fence_fd = -1;
 	void *buf;
 	uint64_t fence_ctx;
@@ -152,13 +151,11 @@ static int virtio_gpu_execbuffer_ioctl(struct drm_device *dev, void *data,
 		ring_idx = exbuf->ring_idx;
 	}
 
-	exbuf->fence_fd = -1;
-
 	virtio_gpu_create_context(dev, file);
 	if (exbuf->flags & VIRTGPU_EXECBUF_FENCE_FD_IN) {
 		struct dma_fence *in_fence;
 
-		in_fence = sync_file_get_fence(in_fence_fd);
+		in_fence = sync_file_get_fence(exbuf->fence_fd);
 
 		if (!in_fence)
 			return -EINVAL;
diff --git a/drivers/hid/amd-sfh-hid/amd_sfh_client.c b/drivers/hid/amd-sfh-hid/amd_sfh_client.c
index 1fb0f7105fb2..c751d12f5df8 100644
--- a/drivers/hid/amd-sfh-hid/amd_sfh_client.c
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_client.c
@@ -227,6 +227,7 @@ int amd_sfh_hid_client_init(struct amd_mp2_dev *privdata)
 	cl_data->num_hid_devices = amd_mp2_get_sensor_num(privdata, &cl_data->sensor_idx[0]);
 	if (cl_data->num_hid_devices == 0)
 		return -ENODEV;
+	cl_data->is_any_sensor_enabled = false;
 
 	INIT_DELAYED_WORK(&cl_data->work, amd_sfh_work);
 	INIT_DELAYED_WORK(&cl_data->work_buffer, amd_sfh_work_buffer);
@@ -287,6 +288,7 @@ int amd_sfh_hid_client_init(struct amd_mp2_dev *privdata)
 		status = amd_sfh_wait_for_response
 				(privdata, cl_data->sensor_idx[i], SENSOR_ENABLED);
 		if (status == SENSOR_ENABLED) {
+			cl_data->is_any_sensor_enabled = true;
 			cl_data->sensor_sts[i] = SENSOR_ENABLED;
 			rc = amdtp_hid_probe(cl_data->cur_hid_dev, cl_data);
 			if (rc) {
@@ -301,19 +303,26 @@ int amd_sfh_hid_client_init(struct amd_mp2_dev *privdata)
 					cl_data->sensor_sts[i]);
 				goto cleanup;
 			}
+		} else {
+			cl_data->sensor_sts[i] = SENSOR_DISABLED;
+			dev_dbg(dev, "sid 0x%x (%s) status 0x%x\n",
+				cl_data->sensor_idx[i],
+				get_sensor_name(cl_data->sensor_idx[i]),
+				cl_data->sensor_sts[i]);
 		}
 		dev_dbg(dev, "sid 0x%x (%s) status 0x%x\n",
 			cl_data->sensor_idx[i], get_sensor_name(cl_data->sensor_idx[i]),
 			cl_data->sensor_sts[i]);
 	}
-	if (mp2_ops->discovery_status && mp2_ops->discovery_status(privdata) == 0) {
+	if (!cl_data->is_any_sensor_enabled ||
+	   (mp2_ops->discovery_status && mp2_ops->discovery_status(privdata) == 0)) {
 		amd_sfh_hid_client_deinit(privdata);
 		for (i = 0; i < cl_data->num_hid_devices; i++) {
 			devm_kfree(dev, cl_data->feature_report[i]);
 			devm_kfree(dev, in_data->input_report[i]);
 			devm_kfree(dev, cl_data->report_descr[i]);
 		}
-		dev_warn(dev, "Failed to discover, sensors not enabled\n");
+		dev_warn(dev, "Failed to discover, sensors not enabled is %d\n", cl_data->is_any_sensor_enabled);
 		return -EOPNOTSUPP;
 	}
 	schedule_delayed_work(&cl_data->work_buffer, msecs_to_jiffies(AMD_SFH_IDLE_LOOP));
diff --git a/drivers/hid/amd-sfh-hid/amd_sfh_hid.h b/drivers/hid/amd-sfh-hid/amd_sfh_hid.h
index 3754fb423e3a..528036892c9d 100644
--- a/drivers/hid/amd-sfh-hid/amd_sfh_hid.h
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_hid.h
@@ -32,6 +32,7 @@ struct amd_input_data {
 struct amdtp_cl_data {
 	u8 init_done;
 	u32 cur_hid_dev;
+	bool is_any_sensor_enabled;
 	u32 hid_dev_count;
 	u32 num_hid_devices;
 	struct device_info *hid_devices;
diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index 656757c79f6b..07b8506eecc4 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -3978,7 +3978,8 @@ static void hidpp_connect_event(struct hidpp_device *hidpp)
 	}
 
 	hidpp_initialize_battery(hidpp);
-	hidpp_initialize_hires_scroll(hidpp);
+	if (!hid_is_usb(hidpp->hid_dev))
+		hidpp_initialize_hires_scroll(hidpp);
 
 	/* forward current battery state */
 	if (hidpp->capabilities & HIDPP_CAPABILITY_HIDPP10_BATTERY) {
diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/hw/hfi1/file_ops.c
index f5f9269fdc16..7c5d487ec916 100644
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
index 7b086fe63a24..195aa9ea18b6 100644
--- a/drivers/infiniband/hw/irdma/cm.c
+++ b/drivers/infiniband/hw/irdma/cm.c
@@ -1722,6 +1722,9 @@ static int irdma_add_mqh_4(struct irdma_device *iwdev,
 			continue;
 
 		idev = in_dev_get(ip_dev);
+		if (!idev)
+			continue;
+
 		in_dev_for_each_ifa_rtnl(ifa, idev) {
 			ibdev_dbg(&iwdev->ibdev,
 				  "CM: Allocating child CM Listener forIP=%pI4, vlan_id=%d, MAC=%pM\n",
diff --git a/drivers/infiniband/hw/usnic/usnic_uiom.c b/drivers/infiniband/hw/usnic/usnic_uiom.c
index 67923ced6e2d..b343f6f1bda5 100644
--- a/drivers/infiniband/hw/usnic/usnic_uiom.c
+++ b/drivers/infiniband/hw/usnic/usnic_uiom.c
@@ -277,8 +277,8 @@ static int usnic_uiom_map_sorted_intervals(struct list_head *intervals,
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
@@ -294,8 +294,8 @@ static int usnic_uiom_map_sorted_intervals(struct list_head *intervals,
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
index ac25fc80fb33..f10d4bcf87d2 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -2200,6 +2200,14 @@ int ipoib_intf_init(struct ib_device *hca, u32 port, const char *name,
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
index e74c6b406172..a884f6f6a8c2 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1309,14 +1309,26 @@ mt7530_port_set_vlan_aware(struct dsa_switch *ds, int port)
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
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 300f47ca42e3..e255780f3867 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4614,25 +4614,26 @@ static int init_reset_optional(struct platform_device *pdev)
 		if (ret)
 			return dev_err_probe(&pdev->dev, ret,
 					     "failed to init SGMII PHY\n");
-	}
 
-	ret = zynqmp_pm_is_function_supported(PM_IOCTL, IOCTL_SET_GEM_CONFIG);
-	if (!ret) {
-		u32 pm_info[2];
+		ret = zynqmp_pm_is_function_supported(PM_IOCTL, IOCTL_SET_GEM_CONFIG);
+		if (!ret) {
+			u32 pm_info[2];
+
+			ret = of_property_read_u32_array(pdev->dev.of_node, "power-domains",
+							 pm_info, ARRAY_SIZE(pm_info));
+			if (ret) {
+				dev_err(&pdev->dev, "Failed to read power management information\n");
+				goto err_out_phy_exit;
+			}
+			ret = zynqmp_pm_set_gem_config(pm_info[1], GEM_CONFIG_FIXED, 0);
+			if (ret)
+				goto err_out_phy_exit;
 
-		ret = of_property_read_u32_array(pdev->dev.of_node, "power-domains",
-						 pm_info, ARRAY_SIZE(pm_info));
-		if (ret) {
-			dev_err(&pdev->dev, "Failed to read power management information\n");
-			goto err_out_phy_exit;
+			ret = zynqmp_pm_set_gem_config(pm_info[1], GEM_CONFIG_SGMII_MODE, 1);
+			if (ret)
+				goto err_out_phy_exit;
 		}
-		ret = zynqmp_pm_set_gem_config(pm_info[1], GEM_CONFIG_FIXED, 0);
-		if (ret)
-			goto err_out_phy_exit;
 
-		ret = zynqmp_pm_set_gem_config(pm_info[1], GEM_CONFIG_SGMII_MODE, 1);
-		if (ret)
-			goto err_out_phy_exit;
 	}
 
 	/* Fully reset controller at hardware level if mapped in device tree */
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 1ac5f0018c7e..333582dabba1 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -5518,7 +5518,7 @@ static int __init ice_module_init(void)
 	pr_info("%s\n", ice_driver_string);
 	pr_info("%s\n", ice_copyright);
 
-	ice_wq = alloc_workqueue("%s", WQ_MEM_RECLAIM, 0, KBUILD_MODNAME);
+	ice_wq = alloc_workqueue("%s", 0, 0, KBUILD_MODNAME);
 	if (!ice_wq) {
 		pr_err("Failed to create workqueue\n");
 		return -ENOMEM;
diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index 9b762f7972ce..61f844d22512 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -5420,7 +5420,7 @@ ice_add_adv_recipe(struct ice_hw *hw, struct ice_adv_lkup_elem *lkups,
 	 */
 	status = ice_add_special_words(rinfo, lkup_exts, ice_is_dvm_ena(hw));
 	if (status)
-		goto err_free_lkup_exts;
+		goto err_unroll;
 
 	/* Group match words into recipes using preferred recipe grouping
 	 * criteria.
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_vsi_vlan_ops.c b/drivers/net/ethernet/intel/ice/ice_vf_vsi_vlan_ops.c
index 5ecc0ee9a78e..b1ffb81893d4 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_vsi_vlan_ops.c
+++ b/drivers/net/ethernet/intel/ice/ice_vf_vsi_vlan_ops.c
@@ -44,13 +44,17 @@ void ice_vf_vsi_init_vlan_ops(struct ice_vsi *vsi)
 
 		/* outer VLAN ops regardless of port VLAN config */
 		vlan_ops->add_vlan = ice_vsi_add_vlan;
-		vlan_ops->dis_rx_filtering = ice_vsi_dis_rx_vlan_filtering;
 		vlan_ops->ena_tx_filtering = ice_vsi_ena_tx_vlan_filtering;
 		vlan_ops->dis_tx_filtering = ice_vsi_dis_tx_vlan_filtering;
 
 		if (ice_vf_is_port_vlan_ena(vf)) {
 			/* setup outer VLAN ops */
 			vlan_ops->set_port_vlan = ice_vsi_set_outer_port_vlan;
+			/* all Rx traffic should be in the domain of the
+			 * assigned port VLAN, so prevent disabling Rx VLAN
+			 * filtering
+			 */
+			vlan_ops->dis_rx_filtering = noop_vlan;
 			vlan_ops->ena_rx_filtering =
 				ice_vsi_ena_rx_vlan_filtering;
 
@@ -63,6 +67,9 @@ void ice_vf_vsi_init_vlan_ops(struct ice_vsi *vsi)
 			vlan_ops->ena_insertion = ice_vsi_ena_inner_insertion;
 			vlan_ops->dis_insertion = ice_vsi_dis_inner_insertion;
 		} else {
+			vlan_ops->dis_rx_filtering =
+				ice_vsi_dis_rx_vlan_filtering;
+
 			if (!test_bit(ICE_FLAG_VF_VLAN_PRUNING, pf->flags))
 				vlan_ops->ena_rx_filtering = noop_vlan;
 			else
@@ -96,7 +103,14 @@ void ice_vf_vsi_init_vlan_ops(struct ice_vsi *vsi)
 			vlan_ops->set_port_vlan = ice_vsi_set_inner_port_vlan;
 			vlan_ops->ena_rx_filtering =
 				ice_vsi_ena_rx_vlan_filtering;
+			/* all Rx traffic should be in the domain of the
+			 * assigned port VLAN, so prevent disabling Rx VLAN
+			 * filtering
+			 */
+			vlan_ops->dis_rx_filtering = noop_vlan;
 		} else {
+			vlan_ops->dis_rx_filtering =
+				ice_vsi_dis_rx_vlan_filtering;
 			if (!test_bit(ICE_FLAG_VF_VLAN_PRUNING, pf->flags))
 				vlan_ops->ena_rx_filtering = noop_vlan;
 			else
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 34db1c006b20..3b5b36206c44 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -2942,7 +2942,9 @@ static bool igc_clean_tx_irq(struct igc_q_vector *q_vector, int napi_budget)
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
@@ -5068,6 +5070,24 @@ static int igc_change_mtu(struct net_device *netdev, int new_mtu)
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
@@ -5495,7 +5515,7 @@ static void igc_watchdog_task(struct work_struct *work)
 			case SPEED_100:
 			case SPEED_1000:
 			case SPEED_2500:
-				adapter->tx_timeout_factor = 7;
+				adapter->tx_timeout_factor = 1;
 				break;
 			}
 
@@ -6313,6 +6333,7 @@ static const struct net_device_ops igc_netdev_ops = {
 	.ndo_set_rx_mode	= igc_set_rx_mode,
 	.ndo_set_mac_address	= igc_set_mac,
 	.ndo_change_mtu		= igc_change_mtu,
+	.ndo_tx_timeout		= igc_tx_timeout,
 	.ndo_get_stats64	= igc_get_stats64,
 	.ndo_fix_features	= igc_fix_features,
 	.ndo_set_features	= igc_set_features,
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 9aa1892a609c..53ee9dea6638 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -1495,8 +1495,8 @@ static struct page_pool *mtk_create_page_pool(struct mtk_eth *eth,
 	if (IS_ERR(pp))
 		return pp;
 
-	err = __xdp_rxq_info_reg(xdp_q, &eth->dummy_dev, eth->rx_napi.napi_id,
-				 id, PAGE_SIZE);
+	err = __xdp_rxq_info_reg(xdp_q, &eth->dummy_dev, id,
+				 eth->rx_napi.napi_id, PAGE_SIZE);
 	if (err < 0)
 		goto err_free_pp;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c b/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
index 3e232a65a0c3..bb95b40d25eb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
@@ -245,8 +245,9 @@ void mlx5_pages_debugfs_init(struct mlx5_core_dev *dev)
 	pages = dev->priv.dbg.pages_debugfs;
 
 	debugfs_create_u32("fw_pages_total", 0400, pages, &dev->priv.fw_pages);
-	debugfs_create_u32("fw_pages_vfs", 0400, pages, &dev->priv.vfs_pages);
-	debugfs_create_u32("fw_pages_host_pf", 0400, pages, &dev->priv.host_pf_pages);
+	debugfs_create_u32("fw_pages_vfs", 0400, pages, &dev->priv.page_counters[MLX5_VF]);
+	debugfs_create_u32("fw_pages_sfs", 0400, pages, &dev->priv.page_counters[MLX5_SF]);
+	debugfs_create_u32("fw_pages_host_pf", 0400, pages, &dev->priv.page_counters[MLX5_HOST_PF]);
 	debugfs_create_u32("fw_pages_alloc_failed", 0400, pages, &dev->priv.fw_pages_alloc_failed);
 	debugfs_create_u32("fw_pages_give_dropped", 0400, pages, &dev->priv.give_pages_dropped);
 	debugfs_create_u32("fw_pages_reclaim_discard", 0400, pages,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
index 21831386b26e..5b05b884b5fb 100644
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
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ecpf.c b/drivers/net/ethernet/mellanox/mlx5/core/ecpf.c
index 464eb3a18450..cdc87ecae5d3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ecpf.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ecpf.c
@@ -87,7 +87,7 @@ void mlx5_ec_cleanup(struct mlx5_core_dev *dev)
 
 	mlx5_host_pf_cleanup(dev);
 
-	err = mlx5_wait_for_pages(dev, &dev->priv.host_pf_pages);
+	err = mlx5_wait_for_pages(dev, &dev->priv.page_counters[MLX5_HOST_PF]);
 	if (err)
 		mlx5_core_warn(dev, "Timeout reclaiming external host PF pages err(%d)\n", err);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
index 8099a21e674c..ce85b48d327d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
@@ -438,10 +438,6 @@ static int mlx5_esw_bridge_switchdev_event(struct notifier_block *nb,
 
 	switch (event) {
 	case SWITCHDEV_FDB_ADD_TO_BRIDGE:
-		/* only handle the event on native eswtich of representor */
-		if (!mlx5_esw_bridge_is_local(dev, rep, esw))
-			break;
-
 		fdb_info = container_of(info,
 					struct switchdev_notifier_fdb_info,
 					info);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
index 1892ccb889b3..7cd36f4ac3ef 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@ -443,7 +443,7 @@ void mlx5e_enable_cvlan_filter(struct mlx5e_flow_steering *fs, bool promisc)
 
 void mlx5e_disable_cvlan_filter(struct mlx5e_flow_steering *fs, bool promisc)
 {
-	if (fs->vlan->cvlan_filter_disabled)
+	if (!fs->vlan || fs->vlan->cvlan_filter_disabled)
 		return;
 
 	fs->vlan->cvlan_filter_disabled = true;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 4dc149ef618c..142ed2d98cd5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -591,7 +591,8 @@ static int mlx5e_init_rxq_rq(struct mlx5e_channel *c, struct mlx5e_params *param
 	rq->ix           = c->ix;
 	rq->channel      = c;
 	rq->mdev         = mdev;
-	rq->hw_mtu       = MLX5E_SW2HW_MTU(params, params->sw_mtu);
+	rq->hw_mtu =
+		MLX5E_SW2HW_MTU(params, params->sw_mtu) - ETH_FCS_LEN * !params->scatter_fcs_en;
 	rq->xdpsq        = &c->rq_xdpsq;
 	rq->stats        = &c->priv->channel_stats[c->ix]->rq;
 	rq->ptp_cyc2time = mlx5_rq_ts_translator(mdev);
@@ -1014,35 +1015,6 @@ int mlx5e_flush_rq(struct mlx5e_rq *rq, int curr_state)
 	return mlx5e_rq_to_ready(rq, curr_state);
 }
 
-static int mlx5e_modify_rq_scatter_fcs(struct mlx5e_rq *rq, bool enable)
-{
-	struct mlx5_core_dev *mdev = rq->mdev;
-
-	void *in;
-	void *rqc;
-	int inlen;
-	int err;
-
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
-
-	err = mlx5_core_modify_rq(mdev, rq->rqn, in);
-
-	kvfree(in);
-
-	return err;
-}
-
 static int mlx5e_modify_rq_vsd(struct mlx5e_rq *rq, bool vsd)
 {
 	struct mlx5_core_dev *mdev = rq->mdev;
@@ -3301,20 +3273,6 @@ static void mlx5e_cleanup_nic_tx(struct mlx5e_priv *priv)
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
@@ -3890,41 +3848,27 @@ static int mlx5e_set_rx_port_ts(struct mlx5_core_dev *mdev, bool enable)
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
@@ -4061,6 +4005,10 @@ static netdev_features_t mlx5e_fix_uplink_rep_features(struct net_device *netdev
 	if (netdev->features & NETIF_F_GRO_HW)
 		netdev_warn(netdev, "Disabling HW_GRO, not supported in switchdev mode\n");
 
+	features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
+	if (netdev->features & NETIF_F_HW_VLAN_CTAG_FILTER)
+		netdev_warn(netdev, "Disabling HW_VLAN CTAG FILTERING, not supported in switchdev mode\n");
+
 	return features;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
index 4fbff7bcc155..d0b2676c3214 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
@@ -1715,7 +1715,7 @@ void mlx5_esw_bridge_fdb_update_used(struct net_device *dev, u16 vport_num, u16
 	struct mlx5_esw_bridge *bridge;
 
 	port = mlx5_esw_bridge_port_lookup(vport_num, esw_owner_vhca_id, br_offloads);
-	if (!port || port->flags & MLX5_ESW_BRIDGE_PORT_FLAG_PEER)
+	if (!port)
 		return;
 
 	bridge = port->bridge;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
index eff92dc0927c..e09518f887a0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
@@ -189,16 +189,16 @@ static inline int mlx5_ptys_rate_enum_to_int(enum mlx5_ptys_rate rate)
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
@@ -221,16 +221,13 @@ static int mlx5i_get_link_ksettings(struct net_device *netdev,
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
index d4db1adae3e3..f07175549a87 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -2094,7 +2094,7 @@ static int __init mlx5_init(void)
 	mlx5_core_verify_params();
 	mlx5_register_debugfs();
 
-	err = pci_register_driver(&mlx5_core_driver);
+	err = mlx5e_init();
 	if (err)
 		goto err_debug;
 
@@ -2102,16 +2102,16 @@ static int __init mlx5_init(void)
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
@@ -2119,9 +2119,9 @@ static int __init mlx5_init(void)
 
 static void __exit mlx5_cleanup(void)
 {
-	mlx5e_cleanup();
-	mlx5_sf_driver_unregister();
 	pci_unregister_driver(&mlx5_core_driver);
+	mlx5_sf_driver_unregister();
+	mlx5e_cleanup();
 	mlx5_unregister_debugfs();
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
index 60596357bfc7..0eb50be175cc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
@@ -74,6 +74,14 @@ static u32 get_function(u16 func_id, bool ec_function)
 	return (u32)func_id | (ec_function << 16);
 }
 
+static u16 func_id_to_type(struct mlx5_core_dev *dev, u16 func_id, bool ec_function)
+{
+	if (!func_id)
+		return mlx5_core_is_ecpf(dev) && !ec_function ? MLX5_HOST_PF : MLX5_PF;
+
+	return func_id <= mlx5_core_max_vfs(dev) ?  MLX5_VF : MLX5_SF;
+}
+
 static struct rb_root *page_root_per_function(struct mlx5_core_dev *dev, u32 function)
 {
 	struct rb_root *root;
@@ -332,6 +340,7 @@ static int give_pages(struct mlx5_core_dev *dev, u16 func_id, int npages,
 	u32 out[MLX5_ST_SZ_DW(manage_pages_out)] = {0};
 	int inlen = MLX5_ST_SZ_BYTES(manage_pages_in);
 	int notify_fail = event;
+	u16 func_type;
 	u64 addr;
 	int err;
 	u32 *in;
@@ -383,11 +392,9 @@ static int give_pages(struct mlx5_core_dev *dev, u16 func_id, int npages,
 		goto out_dropped;
 	}
 
+	func_type = func_id_to_type(dev, func_id, ec_function);
+	dev->priv.page_counters[func_type] += npages;
 	dev->priv.fw_pages += npages;
-	if (func_id)
-		dev->priv.vfs_pages += npages;
-	else if (mlx5_core_is_ecpf(dev) && !ec_function)
-		dev->priv.host_pf_pages += npages;
 
 	mlx5_core_dbg(dev, "npages %d, ec_function %d, func_id 0x%x, err %d\n",
 		      npages, ec_function, func_id, err);
@@ -414,6 +421,7 @@ static void release_all_pages(struct mlx5_core_dev *dev, u16 func_id,
 	struct rb_root *root;
 	struct rb_node *p;
 	int npages = 0;
+	u16 func_type;
 
 	root = xa_load(&dev->priv.page_root_xa, function);
 	if (WARN_ON_ONCE(!root))
@@ -428,11 +436,9 @@ static void release_all_pages(struct mlx5_core_dev *dev, u16 func_id,
 		free_fwp(dev, fwp, fwp->free_count);
 	}
 
+	func_type = func_id_to_type(dev, func_id, ec_function);
+	dev->priv.page_counters[func_type] -= npages;
 	dev->priv.fw_pages -= npages;
-	if (func_id)
-		dev->priv.vfs_pages -= npages;
-	else if (mlx5_core_is_ecpf(dev) && !ec_function)
-		dev->priv.host_pf_pages -= npages;
 
 	mlx5_core_dbg(dev, "npages %d, ec_function %d, func_id 0x%x\n",
 		      npages, ec_function, func_id);
@@ -498,6 +504,7 @@ static int reclaim_pages(struct mlx5_core_dev *dev, u16 func_id, int npages,
 	int outlen = MLX5_ST_SZ_BYTES(manage_pages_out);
 	u32 in[MLX5_ST_SZ_DW(manage_pages_in)] = {};
 	int num_claimed;
+	u16 func_type;
 	u32 *out;
 	int err;
 	int i;
@@ -549,11 +556,9 @@ static int reclaim_pages(struct mlx5_core_dev *dev, u16 func_id, int npages,
 	if (nclaimed)
 		*nclaimed = num_claimed;
 
+	func_type = func_id_to_type(dev, func_id, ec_function);
+	dev->priv.page_counters[func_type] -= num_claimed;
 	dev->priv.fw_pages -= num_claimed;
-	if (func_id)
-		dev->priv.vfs_pages -= num_claimed;
-	else if (mlx5_core_is_ecpf(dev) && !ec_function)
-		dev->priv.host_pf_pages -= num_claimed;
 
 out_free:
 	kvfree(out);
@@ -706,12 +711,12 @@ int mlx5_reclaim_startup_pages(struct mlx5_core_dev *dev)
 	WARN(dev->priv.fw_pages,
 	     "FW pages counter is %d after reclaiming all pages\n",
 	     dev->priv.fw_pages);
-	WARN(dev->priv.vfs_pages,
+	WARN(dev->priv.page_counters[MLX5_VF],
 	     "VFs FW pages counter is %d after reclaiming all pages\n",
-	     dev->priv.vfs_pages);
-	WARN(dev->priv.host_pf_pages,
+	     dev->priv.page_counters[MLX5_VF]);
+	WARN(dev->priv.page_counters[MLX5_HOST_PF],
 	     "External host PF FW pages counter is %d after reclaiming all pages\n",
-	     dev->priv.host_pf_pages);
+	     dev->priv.page_counters[MLX5_HOST_PF]);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
index c0e6c487c63c..3008e9ce2bbf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
@@ -147,7 +147,7 @@ mlx5_device_disable_sriov(struct mlx5_core_dev *dev, int num_vfs, bool clear_vf)
 
 	mlx5_eswitch_disable_sriov(dev->priv.eswitch, clear_vf);
 
-	if (mlx5_wait_for_pages(dev, &dev->priv.vfs_pages))
+	if (mlx5_wait_for_pages(dev, &dev->priv.page_counters[MLX5_VF]))
 		mlx5_core_warn(dev, "timeout reclaiming VFs pages\n");
 }
 
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c b/drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c
index 0ed1ea7727c5..69e76634f9aa 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c
@@ -633,7 +633,7 @@ int sparx5_ptp_init(struct sparx5 *sparx5)
 	/* Enable master counters */
 	spx5_wr(PTP_PTP_DOM_CFG_PTP_ENA_SET(0x7), sparx5, PTP_PTP_DOM_CFG);
 
-	for (i = 0; i < sparx5->port_count; i++) {
+	for (i = 0; i < SPX5_PORTS; i++) {
 		port = sparx5->ports[i];
 		if (!port)
 			continue;
@@ -649,7 +649,7 @@ void sparx5_ptp_deinit(struct sparx5 *sparx5)
 	struct sparx5_port *port;
 	int i;
 
-	for (i = 0; i < sparx5->port_count; i++) {
+	for (i = 0; i < SPX5_PORTS; i++) {
 		port = sparx5->ports[i];
 		if (!port)
 			continue;
diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index 7c0897e779dc..ee052404eb55 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -605,6 +605,18 @@ ocelot_flower_parse_key(struct ocelot *ocelot, int port, bool ingress,
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
 
@@ -737,18 +749,6 @@ ocelot_flower_parse_key(struct ocelot *ocelot, int port, bool ingress,
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
diff --git a/drivers/net/ethernet/mscc/ocelot_ptp.c b/drivers/net/ethernet/mscc/ocelot_ptp.c
index 1a82f10c8853..2180ae94c744 100644
--- a/drivers/net/ethernet/mscc/ocelot_ptp.c
+++ b/drivers/net/ethernet/mscc/ocelot_ptp.c
@@ -335,8 +335,8 @@ static void
 ocelot_populate_ipv6_ptp_event_trap_key(struct ocelot_vcap_filter *trap)
 {
 	trap->key_type = OCELOT_VCAP_KEY_IPV6;
-	trap->key.ipv4.proto.value[0] = IPPROTO_UDP;
-	trap->key.ipv4.proto.mask[0] = 0xff;
+	trap->key.ipv6.proto.value[0] = IPPROTO_UDP;
+	trap->key.ipv6.proto.mask[0] = 0xff;
 	trap->key.ipv6.dport.value = PTP_EV_PORT;
 	trap->key.ipv6.dport.mask = 0xffff;
 }
@@ -355,8 +355,8 @@ static void
 ocelot_populate_ipv6_ptp_general_trap_key(struct ocelot_vcap_filter *trap)
 {
 	trap->key_type = OCELOT_VCAP_KEY_IPV6;
-	trap->key.ipv4.proto.value[0] = IPPROTO_UDP;
-	trap->key.ipv4.proto.mask[0] = 0xff;
+	trap->key.ipv6.proto.value[0] = IPPROTO_UDP;
+	trap->key.ipv6.proto.mask[0] = 0xff;
 	trap->key.ipv6.dport.value = PTP_GEN_PORT;
 	trap->key.ipv6.dport.mask = 0xffff;
 }
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.c b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
index 9d0514cfeb5c..344a3924627d 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
@@ -694,9 +694,16 @@ void ionic_q_post(struct ionic_queue *q, bool ring_doorbell, ionic_desc_cb cb,
 		q->lif->index, q->name, q->hw_type, q->hw_index,
 		q->head_idx, ring_doorbell);
 
-	if (ring_doorbell)
+	if (ring_doorbell) {
 		ionic_dbell_ring(lif->kern_dbpage, q->hw_type,
 				 q->dbval | q->head_idx);
+
+		q->dbell_jiffies = jiffies;
+
+		if (q_to_qcq(q)->napi_qcq)
+			mod_timer(&q_to_qcq(q)->napi_qcq->napi_deadline,
+				  jiffies + IONIC_NAPI_DEADLINE);
+	}
 }
 
 static bool ionic_q_is_posted(struct ionic_queue *q, unsigned int pos)
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
index 563c302eb033..ad8a2a4453b7 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
@@ -25,6 +25,12 @@
 #define IONIC_DEV_INFO_REG_COUNT	32
 #define IONIC_DEV_CMD_REG_COUNT		32
 
+#define IONIC_NAPI_DEADLINE		(HZ / 200)	/* 5ms */
+#define IONIC_ADMIN_DOORBELL_DEADLINE	(HZ / 2)	/* 500ms */
+#define IONIC_TX_DOORBELL_DEADLINE	(HZ / 100)	/* 10ms */
+#define IONIC_RX_MIN_DOORBELL_DEADLINE	(HZ / 100)	/* 10ms */
+#define IONIC_RX_MAX_DOORBELL_DEADLINE	(HZ * 5)	/* 5s */
+
 struct ionic_dev_bar {
 	void __iomem *vaddr;
 	phys_addr_t bus_addr;
@@ -214,6 +220,8 @@ struct ionic_queue {
 	struct ionic_lif *lif;
 	struct ionic_desc_info *info;
 	u64 dbval;
+	unsigned long dbell_deadline;
+	unsigned long dbell_jiffies;
 	u16 head_idx;
 	u16 tail_idx;
 	unsigned int index;
@@ -358,4 +366,8 @@ void ionic_q_service(struct ionic_queue *q, struct ionic_cq_info *cq_info,
 int ionic_heartbeat_check(struct ionic *ionic);
 bool ionic_is_fw_running(struct ionic_dev *idev);
 
+bool ionic_adminq_poke_doorbell(struct ionic_queue *q);
+bool ionic_txq_poke_doorbell(struct ionic_queue *q);
+bool ionic_rxq_poke_doorbell(struct ionic_queue *q);
+
 #endif /* _IONIC_DEV_H_ */
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 19d4848df17d..159bfcc76498 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -16,6 +16,7 @@
 
 #include "ionic.h"
 #include "ionic_bus.h"
+#include "ionic_dev.h"
 #include "ionic_lif.h"
 #include "ionic_txrx.h"
 #include "ionic_ethtool.h"
@@ -200,6 +201,13 @@ void ionic_link_status_check_request(struct ionic_lif *lif, bool can_sleep)
 	}
 }
 
+static void ionic_napi_deadline(struct timer_list *timer)
+{
+	struct ionic_qcq *qcq = container_of(timer, struct ionic_qcq, napi_deadline);
+
+	napi_schedule(&qcq->napi);
+}
+
 static irqreturn_t ionic_isr(int irq, void *data)
 {
 	struct napi_struct *napi = data;
@@ -269,6 +277,7 @@ static int ionic_qcq_enable(struct ionic_qcq *qcq)
 			.oper = IONIC_Q_ENABLE,
 		},
 	};
+	int ret;
 
 	idev = &lif->ionic->idev;
 	dev = lif->ionic->dev;
@@ -276,16 +285,24 @@ static int ionic_qcq_enable(struct ionic_qcq *qcq)
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
 
 static int ionic_qcq_disable(struct ionic_lif *lif, struct ionic_qcq *qcq, int fw_err)
@@ -316,6 +333,7 @@ static int ionic_qcq_disable(struct ionic_lif *lif, struct ionic_qcq *qcq, int f
 		synchronize_irq(qcq->intr.vector);
 		irq_set_affinity_hint(qcq->intr.vector, NULL);
 		napi_disable(&qcq->napi);
+		del_timer_sync(&qcq->napi_deadline);
 	}
 
 	/* If there was a previous fw communcation error, don't bother with
@@ -451,6 +469,7 @@ static void ionic_link_qcq_interrupts(struct ionic_qcq *src_qcq,
 
 	n_qcq->intr.vector = src_qcq->intr.vector;
 	n_qcq->intr.index = src_qcq->intr.index;
+	n_qcq->napi_qcq = src_qcq->napi_qcq;
 }
 
 static int ionic_alloc_qcq_interrupt(struct ionic_lif *lif, struct ionic_qcq *qcq)
@@ -773,8 +792,14 @@ static int ionic_lif_txq_init(struct ionic_lif *lif, struct ionic_qcq *qcq)
 	dev_dbg(dev, "txq->hw_type %d\n", q->hw_type);
 	dev_dbg(dev, "txq->hw_index %d\n", q->hw_index);
 
-	if (test_bit(IONIC_LIF_F_SPLIT_INTR, lif->state))
+	q->dbell_deadline = IONIC_TX_DOORBELL_DEADLINE;
+	q->dbell_jiffies = jiffies;
+
+	if (test_bit(IONIC_LIF_F_SPLIT_INTR, lif->state)) {
 		netif_napi_add(lif->netdev, &qcq->napi, ionic_tx_napi);
+		qcq->napi_qcq = qcq;
+		timer_setup(&qcq->napi_deadline, ionic_napi_deadline, 0);
+	}
 
 	qcq->flags |= IONIC_QCQ_F_INITED;
 
@@ -828,11 +853,17 @@ static int ionic_lif_rxq_init(struct ionic_lif *lif, struct ionic_qcq *qcq)
 	dev_dbg(dev, "rxq->hw_type %d\n", q->hw_type);
 	dev_dbg(dev, "rxq->hw_index %d\n", q->hw_index);
 
+	q->dbell_deadline = IONIC_RX_MIN_DOORBELL_DEADLINE;
+	q->dbell_jiffies = jiffies;
+
 	if (test_bit(IONIC_LIF_F_SPLIT_INTR, lif->state))
 		netif_napi_add(lif->netdev, &qcq->napi, ionic_rx_napi);
 	else
 		netif_napi_add(lif->netdev, &qcq->napi, ionic_txrx_napi);
 
+	qcq->napi_qcq = qcq;
+	timer_setup(&qcq->napi_deadline, ionic_napi_deadline, 0);
+
 	qcq->flags |= IONIC_QCQ_F_INITED;
 
 	return 0;
@@ -1150,6 +1181,7 @@ static int ionic_adminq_napi(struct napi_struct *napi, int budget)
 	struct ionic_dev *idev = &lif->ionic->idev;
 	unsigned long irqflags;
 	unsigned int flags = 0;
+	bool resched = false;
 	int rx_work = 0;
 	int tx_work = 0;
 	int n_work = 0;
@@ -1187,6 +1219,16 @@ static int ionic_adminq_napi(struct napi_struct *napi, int budget)
 		ionic_intr_credits(idev->intr_ctrl, intr->index, credits, flags);
 	}
 
+	if (!a_work && ionic_adminq_poke_doorbell(&lif->adminqcq->q))
+		resched = true;
+	if (lif->hwstamp_rxq && !rx_work && ionic_rxq_poke_doorbell(&lif->hwstamp_rxq->q))
+		resched = true;
+	if (lif->hwstamp_txq && !tx_work && ionic_txq_poke_doorbell(&lif->hwstamp_txq->q))
+		resched = true;
+	if (resched)
+		mod_timer(&lif->adminqcq->napi_deadline,
+			  jiffies + IONIC_NAPI_DEADLINE);
+
 	return work_done;
 }
 
@@ -3166,8 +3208,14 @@ static int ionic_lif_adminq_init(struct ionic_lif *lif)
 	dev_dbg(dev, "adminq->hw_type %d\n", q->hw_type);
 	dev_dbg(dev, "adminq->hw_index %d\n", q->hw_index);
 
+	q->dbell_deadline = IONIC_ADMIN_DOORBELL_DEADLINE;
+	q->dbell_jiffies = jiffies;
+
 	netif_napi_add(lif->netdev, &qcq->napi, ionic_adminq_napi);
 
+	qcq->napi_qcq = qcq;
+	timer_setup(&qcq->napi_deadline, ionic_napi_deadline, 0);
+
 	napi_enable(&qcq->napi);
 
 	if (qcq->flags & IONIC_QCQ_F_INTR)
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index a53984bf3544..734519895614 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -74,8 +74,10 @@ struct ionic_qcq {
 	struct ionic_queue q;
 	struct ionic_cq cq;
 	struct ionic_intr_info intr;
+	struct timer_list napi_deadline;
 	struct napi_struct napi;
 	unsigned int flags;
+	struct ionic_qcq *napi_qcq;
 	struct dentry *dentry;
 };
 
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index 5456c2b15d9b..79272f5f380c 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -289,6 +289,35 @@ static void ionic_adminq_cb(struct ionic_queue *q,
 	complete_all(&ctx->work);
 }
 
+bool ionic_adminq_poke_doorbell(struct ionic_queue *q)
+{
+	struct ionic_lif *lif = q->lif;
+	unsigned long now, then, dif;
+	unsigned long irqflags;
+
+	spin_lock_irqsave(&lif->adminq_lock, irqflags);
+
+	if (q->tail_idx == q->head_idx) {
+		spin_unlock_irqrestore(&lif->adminq_lock, irqflags);
+		return false;
+	}
+
+	now = READ_ONCE(jiffies);
+	then = q->dbell_jiffies;
+	dif = now - then;
+
+	if (dif > q->dbell_deadline) {
+		ionic_dbell_ring(q->lif->kern_dbpage, q->hw_type,
+				 q->dbval | q->head_idx);
+
+		q->dbell_jiffies = now;
+	}
+
+	spin_unlock_irqrestore(&lif->adminq_lock, irqflags);
+
+	return true;
+}
+
 int ionic_adminq_post(struct ionic_lif *lif, struct ionic_admin_ctx *ctx)
 {
 	struct ionic_desc_info *desc_info;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index c03986bf2628..f8f5eb130768 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -22,6 +22,67 @@ static inline void ionic_rxq_post(struct ionic_queue *q, bool ring_dbell,
 	ionic_q_post(q, ring_dbell, cb_func, cb_arg);
 }
 
+bool ionic_txq_poke_doorbell(struct ionic_queue *q)
+{
+	unsigned long now, then, dif;
+	struct netdev_queue *netdev_txq;
+	struct net_device *netdev;
+
+	netdev = q->lif->netdev;
+	netdev_txq = netdev_get_tx_queue(netdev, q->index);
+
+	HARD_TX_LOCK(netdev, netdev_txq, smp_processor_id());
+
+	if (q->tail_idx == q->head_idx) {
+		HARD_TX_UNLOCK(netdev, netdev_txq);
+		return false;
+	}
+
+	now = READ_ONCE(jiffies);
+	then = q->dbell_jiffies;
+	dif = now - then;
+
+	if (dif > q->dbell_deadline) {
+		ionic_dbell_ring(q->lif->kern_dbpage, q->hw_type,
+				 q->dbval | q->head_idx);
+
+		q->dbell_jiffies = now;
+	}
+
+	HARD_TX_UNLOCK(netdev, netdev_txq);
+
+	return true;
+}
+
+bool ionic_rxq_poke_doorbell(struct ionic_queue *q)
+{
+	unsigned long now, then, dif;
+
+	/* no lock, called from rx napi or txrx napi, nothing else can fill */
+
+	if (q->tail_idx == q->head_idx)
+		return false;
+
+	now = READ_ONCE(jiffies);
+	then = q->dbell_jiffies;
+	dif = now - then;
+
+	if (dif > q->dbell_deadline) {
+		ionic_dbell_ring(q->lif->kern_dbpage, q->hw_type,
+				 q->dbval | q->head_idx);
+
+		q->dbell_jiffies = now;
+
+		dif = 2 * q->dbell_deadline;
+		if (dif > IONIC_RX_MAX_DOORBELL_DEADLINE)
+			dif = IONIC_RX_MAX_DOORBELL_DEADLINE;
+
+		q->dbell_deadline = dif;
+	}
+
+	return true;
+}
+
 static inline struct netdev_queue *q_to_ndq(struct ionic_queue *q)
 {
 	return netdev_get_tx_queue(q->lif->netdev, q->index);
@@ -348,16 +409,25 @@ void ionic_rx_fill(struct ionic_queue *q)
 	struct ionic_rxq_sg_desc *sg_desc;
 	struct ionic_rxq_sg_elem *sg_elem;
 	struct ionic_buf_info *buf_info;
+	unsigned int fill_threshold;
 	struct ionic_rxq_desc *desc;
 	unsigned int remain_len;
 	unsigned int frag_len;
 	unsigned int nfrags;
+	unsigned int n_fill;
 	unsigned int i, j;
 	unsigned int len;
 
+	n_fill = ionic_q_space_avail(q);
+
+	fill_threshold = min_t(unsigned int, IONIC_RX_FILL_THRESHOLD,
+			       q->num_descs / IONIC_RX_FILL_DIV);
+	if (n_fill < fill_threshold)
+		return;
+
 	len = netdev->mtu + ETH_HLEN + VLAN_HLEN;
 
-	for (i = ionic_q_space_avail(q); i; i--) {
+	for (i = n_fill; i; i--) {
 		nfrags = 0;
 		remain_len = len;
 		desc_info = &q->info[q->head_idx];
@@ -415,6 +485,12 @@ void ionic_rx_fill(struct ionic_queue *q)
 
 	ionic_dbell_ring(q->lif->kern_dbpage, q->hw_type,
 			 q->dbval | q->head_idx);
+
+	q->dbell_deadline = IONIC_RX_MIN_DOORBELL_DEADLINE;
+	q->dbell_jiffies = jiffies;
+
+	mod_timer(&q_to_qcq(q)->napi_qcq->napi_deadline,
+		  jiffies + IONIC_NAPI_DEADLINE);
 }
 
 void ionic_rx_empty(struct ionic_queue *q)
@@ -502,6 +578,9 @@ int ionic_tx_napi(struct napi_struct *napi, int budget)
 				   work_done, flags);
 	}
 
+	if (!work_done && ionic_txq_poke_doorbell(&qcq->q))
+		mod_timer(&qcq->napi_deadline, jiffies + IONIC_NAPI_DEADLINE);
+
 	return work_done;
 }
 
@@ -511,7 +590,6 @@ int ionic_rx_napi(struct napi_struct *napi, int budget)
 	struct ionic_cq *cq = napi_to_cq(napi);
 	struct ionic_dev *idev;
 	struct ionic_lif *lif;
-	u16 rx_fill_threshold;
 	u32 work_done = 0;
 	u32 flags = 0;
 
@@ -521,10 +599,7 @@ int ionic_rx_napi(struct napi_struct *napi, int budget)
 	work_done = ionic_cq_service(cq, budget,
 				     ionic_rx_service, NULL, NULL);
 
-	rx_fill_threshold = min_t(u16, IONIC_RX_FILL_THRESHOLD,
-				  cq->num_descs / IONIC_RX_FILL_DIV);
-	if (work_done && ionic_q_space_avail(cq->bound_q) >= rx_fill_threshold)
-		ionic_rx_fill(cq->bound_q);
+	ionic_rx_fill(cq->bound_q);
 
 	if (work_done < budget && napi_complete_done(napi, work_done)) {
 		ionic_dim_update(qcq, IONIC_LIF_F_RX_DIM_INTR);
@@ -539,24 +614,29 @@ int ionic_rx_napi(struct napi_struct *napi, int budget)
 				   work_done, flags);
 	}
 
+	if (!work_done && ionic_rxq_poke_doorbell(&qcq->q))
+		mod_timer(&qcq->napi_deadline, jiffies + IONIC_NAPI_DEADLINE);
+
 	return work_done;
 }
 
 int ionic_txrx_napi(struct napi_struct *napi, int budget)
 {
-	struct ionic_qcq *qcq = napi_to_qcq(napi);
+	struct ionic_qcq *rxqcq = napi_to_qcq(napi);
 	struct ionic_cq *rxcq = napi_to_cq(napi);
 	unsigned int qi = rxcq->bound_q->index;
+	struct ionic_qcq *txqcq;
 	struct ionic_dev *idev;
 	struct ionic_lif *lif;
 	struct ionic_cq *txcq;
-	u16 rx_fill_threshold;
+	bool resched = false;
 	u32 rx_work_done = 0;
 	u32 tx_work_done = 0;
 	u32 flags = 0;
 
 	lif = rxcq->bound_q->lif;
 	idev = &lif->ionic->idev;
+	txqcq = lif->txqcqs[qi];
 	txcq = &lif->txqcqs[qi]->cq;
 
 	tx_work_done = ionic_cq_service(txcq, IONIC_TX_BUDGET_DEFAULT,
@@ -565,13 +645,10 @@ int ionic_txrx_napi(struct napi_struct *napi, int budget)
 	rx_work_done = ionic_cq_service(rxcq, budget,
 					ionic_rx_service, NULL, NULL);
 
-	rx_fill_threshold = min_t(u16, IONIC_RX_FILL_THRESHOLD,
-				  rxcq->num_descs / IONIC_RX_FILL_DIV);
-	if (rx_work_done && ionic_q_space_avail(rxcq->bound_q) >= rx_fill_threshold)
-		ionic_rx_fill(rxcq->bound_q);
+	ionic_rx_fill(rxcq->bound_q);
 
 	if (rx_work_done < budget && napi_complete_done(napi, rx_work_done)) {
-		ionic_dim_update(qcq, 0);
+		ionic_dim_update(rxqcq, 0);
 		flags |= IONIC_INTR_CRED_UNMASK;
 		rxcq->bound_intr->rearm_count++;
 	}
@@ -582,6 +659,13 @@ int ionic_txrx_napi(struct napi_struct *napi, int budget)
 				   tx_work_done + rx_work_done, flags);
 	}
 
+	if (!rx_work_done && ionic_rxq_poke_doorbell(&rxqcq->q))
+		resched = true;
+	if (!tx_work_done && ionic_txq_poke_doorbell(&txqcq->q))
+		resched = true;
+	if (resched)
+		mod_timer(&rxqcq->napi_deadline, jiffies + IONIC_NAPI_DEADLINE);
+
 	return rx_work_done;
 }
 
diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index e02d1e3ef672..79f4e13620a4 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -1034,7 +1034,7 @@ static int netvsc_dma_map(struct hv_device *hv_dev,
 
 	packet->dma_range = kcalloc(page_count,
 				    sizeof(*packet->dma_range),
-				    GFP_KERNEL);
+				    GFP_ATOMIC);
 	if (!packet->dma_range)
 		return -ENOMEM;
 
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
index 2805b04d6402..a202ce6611fd 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1793,10 +1793,9 @@ int phylink_fwnode_phy_connect(struct phylink *pl,
 
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
index 2c82fbcaab22..7a2b0094de51 100644
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
 
diff --git a/drivers/nvdimm/Kconfig b/drivers/nvdimm/Kconfig
index 5a29046e3319..e4c20f0cb049 100644
--- a/drivers/nvdimm/Kconfig
+++ b/drivers/nvdimm/Kconfig
@@ -102,6 +102,25 @@ config NVDIMM_KEYS
 	depends on ENCRYPTED_KEYS
 	depends on (LIBNVDIMM=ENCRYPTED_KEYS) || LIBNVDIMM=m
 
+config NVDIMM_KMSAN
+	bool
+	depends on KMSAN
+	help
+	  KMSAN, and other memory debug facilities, increase the size of
+	  'struct page' to contain extra metadata. This collides with
+	  the NVDIMM capability to store a potentially
+	  larger-than-"System RAM" size 'struct page' array in a
+	  reservation of persistent memory rather than limited /
+	  precious DRAM. However, that reservation needs to persist for
+	  the life of the given NVDIMM namespace. If you are using KMSAN
+	  to debug an issue unrelated to NVDIMMs or DAX then say N to this
+	  option. Otherwise, say Y but understand that any namespaces
+	  (with the page array stored pmem) created with this build of
+	  the kernel will permanently reserve and strand excess
+	  capacity compared to the CONFIG_KMSAN=n case.
+
+	  Select N if unsure.
+
 config NVDIMM_TEST_BUILD
 	tristate "Build the unit test core"
 	depends on m
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 85ca5b4da3cf..ec5219680092 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -652,7 +652,7 @@ void devm_namespace_disable(struct device *dev,
 		struct nd_namespace_common *ndns);
 #if IS_ENABLED(CONFIG_ND_CLAIM)
 /* max struct page size independent of kernel config */
-#define MAX_STRUCT_PAGE_SIZE 128
+#define MAX_STRUCT_PAGE_SIZE 64
 int nvdimm_setup_pfn(struct nd_pfn *nd_pfn, struct dev_pagemap *pgmap);
 #else
 static inline int nvdimm_setup_pfn(struct nd_pfn *nd_pfn,
diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
index 61af072ac98f..af7d9301520c 100644
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -13,6 +13,8 @@
 #include "pfn.h"
 #include "nd.h"
 
+static const bool page_struct_override = IS_ENABLED(CONFIG_NVDIMM_KMSAN);
+
 static void nd_pfn_release(struct device *dev)
 {
 	struct nd_region *nd_region = to_nd_region(dev->parent);
@@ -758,12 +760,6 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
 		return -ENXIO;
 	}
 
-	/*
-	 * Note, we use 64 here for the standard size of struct page,
-	 * debugging options may cause it to be larger in which case the
-	 * implementation will limit the pfns advertised through
-	 * ->direct_access() to those that are included in the memmap.
-	 */
 	start = nsio->res.start;
 	size = resource_size(&nsio->res);
 	npfns = PHYS_PFN(size - SZ_8K);
@@ -782,20 +778,33 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
 	}
 	end_trunc = start + size - ALIGN_DOWN(start + size, align);
 	if (nd_pfn->mode == PFN_MODE_PMEM) {
+		unsigned long page_map_size = MAX_STRUCT_PAGE_SIZE * npfns;
+
 		/*
 		 * The altmap should be padded out to the block size used
 		 * when populating the vmemmap. This *should* be equal to
 		 * PMD_SIZE for most architectures.
 		 *
-		 * Also make sure size of struct page is less than 128. We
-		 * want to make sure we use large enough size here so that
-		 * we don't have a dynamic reserve space depending on
-		 * struct page size. But we also want to make sure we notice
-		 * when we end up adding new elements to struct page.
+		 * Also make sure size of struct page is less than
+		 * MAX_STRUCT_PAGE_SIZE. The goal here is compatibility in the
+		 * face of production kernel configurations that reduce the
+		 * 'struct page' size below MAX_STRUCT_PAGE_SIZE. For debug
+		 * kernel configurations that increase the 'struct page' size
+		 * above MAX_STRUCT_PAGE_SIZE, the page_struct_override allows
+		 * for continuing with the capacity that will be wasted when
+		 * reverting to a production kernel configuration. Otherwise,
+		 * those configurations are blocked by default.
 		 */
-		BUILD_BUG_ON(sizeof(struct page) > MAX_STRUCT_PAGE_SIZE);
-		offset = ALIGN(start + SZ_8K + MAX_STRUCT_PAGE_SIZE * npfns, align)
-			- start;
+		if (sizeof(struct page) > MAX_STRUCT_PAGE_SIZE) {
+			if (page_struct_override)
+				page_map_size = sizeof(struct page) * npfns;
+			else {
+				dev_err(&nd_pfn->dev,
+					"Memory debug options prevent using pmem for the page map\n");
+				return -EINVAL;
+			}
+		}
+		offset = ALIGN(start + SZ_8K + page_map_size, align) - start;
 	} else if (nd_pfn->mode == PFN_MODE_RAM)
 		offset = ALIGN(start + SZ_8K, align) - start;
 	else
@@ -818,7 +827,10 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
 	pfn_sb->version_minor = cpu_to_le16(4);
 	pfn_sb->end_trunc = cpu_to_le32(end_trunc);
 	pfn_sb->align = cpu_to_le32(nd_pfn->align);
-	pfn_sb->page_struct_size = cpu_to_le16(MAX_STRUCT_PAGE_SIZE);
+	if (sizeof(struct page) > MAX_STRUCT_PAGE_SIZE && page_struct_override)
+		pfn_sb->page_struct_size = cpu_to_le16(sizeof(struct page));
+	else
+		pfn_sb->page_struct_size = cpu_to_le16(MAX_STRUCT_PAGE_SIZE);
 	pfn_sb->page_size = cpu_to_le32(PAGE_SIZE);
 	checksum = nd_sb_checksum((struct nd_gen_sb *) pfn_sb);
 	pfn_sb->checksum = cpu_to_le64(checksum);
diff --git a/drivers/of/address.c b/drivers/of/address.c
index c34ac33b7338..67763e5b8c0e 100644
--- a/drivers/of/address.c
+++ b/drivers/of/address.c
@@ -965,8 +965,19 @@ int of_dma_get_range(struct device_node *np, const struct bus_dma_region **map)
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
@@ -975,18 +986,16 @@ int of_dma_get_range(struct device_node *np, const struct bus_dma_region **map)
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
diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index 3507095a69f6..6e93fd37ccd1 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -526,6 +526,7 @@ static int __init of_platform_default_populate_init(void)
 	if (IS_ENABLED(CONFIG_PPC)) {
 		struct device_node *boot_display = NULL;
 		struct platform_device *dev;
+		int display_number = 0;
 		int ret;
 
 		/* Check if we have a MacOS display without a node spec */
@@ -556,16 +557,23 @@ static int __init of_platform_default_populate_init(void)
 			if (!of_get_property(node, "linux,opened", NULL) ||
 			    !of_get_property(node, "linux,boot-display", NULL))
 				continue;
-			dev = of_platform_device_create(node, "of-display", NULL);
+			dev = of_platform_device_create(node, "of-display.0", NULL);
+			of_node_put(node);
 			if (WARN_ON(!dev))
 				return -ENOMEM;
 			boot_display = node;
+			display_number++;
 			break;
 		}
 		for_each_node_by_type(node, "display") {
+			char buf[14];
+			const char *of_display_format = "of-display.%d";
+
 			if (!of_get_property(node, "linux,opened", NULL) || node == boot_display)
 				continue;
-			of_platform_device_create(node, "of-display", NULL);
+			ret = snprintf(buf, sizeof(buf), of_display_format, display_number++);
+			if (ret < sizeof(buf))
+				of_platform_device_create(node, buf, NULL);
 		}
 
 	} else {
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index ab615ab4e440..6d81df459b2f 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1665,7 +1665,6 @@ int pci_save_state(struct pci_dev *dev)
 		return i;
 
 	pci_save_ltr_state(dev);
-	pci_save_aspm_l1ss_state(dev);
 	pci_save_dpc_state(dev);
 	pci_save_aer_state(dev);
 	pci_save_ptm_state(dev);
@@ -1772,7 +1771,6 @@ void pci_restore_state(struct pci_dev *dev)
 	 * LTR itself (in the PCIe capability).
 	 */
 	pci_restore_ltr_state(dev);
-	pci_restore_aspm_l1ss_state(dev);
 
 	pci_restore_pcie_state(dev);
 	pci_restore_pasid_state(dev);
@@ -3465,11 +3463,6 @@ void pci_allocate_cap_save_buffers(struct pci_dev *dev)
 	if (error)
 		pci_err(dev, "unable to allocate suspend buffer for LTR\n");
 
-	error = pci_add_ext_cap_save_buffer(dev, PCI_EXT_CAP_ID_L1SS,
-					    2 * sizeof(u32));
-	if (error)
-		pci_err(dev, "unable to allocate suspend buffer for ASPM-L1SS\n");
-
 	pci_allocate_vc_save_buffers(dev);
 }
 
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index b1ebb7ab8805..ce169b12a8f6 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -565,14 +565,10 @@ bool pcie_wait_for_link(struct pci_dev *pdev, bool active);
 void pcie_aspm_init_link_state(struct pci_dev *pdev);
 void pcie_aspm_exit_link_state(struct pci_dev *pdev);
 void pcie_aspm_powersave_config_link(struct pci_dev *pdev);
-void pci_save_aspm_l1ss_state(struct pci_dev *dev);
-void pci_restore_aspm_l1ss_state(struct pci_dev *dev);
 #else
 static inline void pcie_aspm_init_link_state(struct pci_dev *pdev) { }
 static inline void pcie_aspm_exit_link_state(struct pci_dev *pdev) { }
 static inline void pcie_aspm_powersave_config_link(struct pci_dev *pdev) { }
-static inline void pci_save_aspm_l1ss_state(struct pci_dev *dev) { }
-static inline void pci_restore_aspm_l1ss_state(struct pci_dev *dev) { }
 #endif
 
 #ifdef CONFIG_PCIE_ECRC
diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
index 53a1fa306e1e..4b4184563a92 100644
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -470,31 +470,6 @@ static void pci_clear_and_set_dword(struct pci_dev *pdev, int pos,
 	pci_write_config_dword(pdev, pos, val);
 }
 
-static void aspm_program_l1ss(struct pci_dev *dev, u32 ctl1, u32 ctl2)
-{
-	u16 l1ss = dev->l1ss;
-	u32 l1_2_enable;
-
-	/*
-	 * Per PCIe r6.0, sec 5.5.4, T_POWER_ON in PCI_L1SS_CTL2 must be
-	 * programmed prior to setting the L1.2 enable bits in PCI_L1SS_CTL1.
-	 */
-	pci_write_config_dword(dev, l1ss + PCI_L1SS_CTL2, ctl2);
-
-	/*
-	 * In addition, Common_Mode_Restore_Time and LTR_L1.2_THRESHOLD in
-	 * PCI_L1SS_CTL1 must be programmed *before* setting the L1.2
-	 * enable bits, even though they're all in PCI_L1SS_CTL1.
-	 */
-	l1_2_enable = ctl1 & PCI_L1SS_CTL1_L1_2_MASK;
-	ctl1 &= ~PCI_L1SS_CTL1_L1_2_MASK;
-
-	pci_write_config_dword(dev, l1ss + PCI_L1SS_CTL1, ctl1);
-	if (l1_2_enable)
-		pci_write_config_dword(dev, l1ss + PCI_L1SS_CTL1,
-				       ctl1 | l1_2_enable);
-}
-
 /* Calculate L1.2 PM substate timing parameters */
 static void aspm_calc_l1ss_info(struct pcie_link_state *link,
 				u32 parent_l1ss_cap, u32 child_l1ss_cap)
@@ -504,6 +479,7 @@ static void aspm_calc_l1ss_info(struct pcie_link_state *link,
 	u32 t_common_mode, t_power_on, l1_2_threshold, scale, value;
 	u32 ctl1 = 0, ctl2 = 0;
 	u32 pctl1, pctl2, cctl1, cctl2;
+	u32 pl1_2_enables, cl1_2_enables;
 
 	if (!(link->aspm_support & ASPM_STATE_L1_2_MASK))
 		return;
@@ -552,21 +528,39 @@ static void aspm_calc_l1ss_info(struct pcie_link_state *link,
 	    ctl2 == pctl2 && ctl2 == cctl2)
 		return;
 
-	pctl1 &= ~(PCI_L1SS_CTL1_CM_RESTORE_TIME |
-		   PCI_L1SS_CTL1_LTR_L12_TH_VALUE |
-		   PCI_L1SS_CTL1_LTR_L12_TH_SCALE);
-	pctl1 |= (ctl1 & (PCI_L1SS_CTL1_CM_RESTORE_TIME |
-			  PCI_L1SS_CTL1_LTR_L12_TH_VALUE |
-			  PCI_L1SS_CTL1_LTR_L12_TH_SCALE));
-	aspm_program_l1ss(parent, pctl1, ctl2);
-
-	cctl1 &= ~(PCI_L1SS_CTL1_CM_RESTORE_TIME |
-		   PCI_L1SS_CTL1_LTR_L12_TH_VALUE |
-		   PCI_L1SS_CTL1_LTR_L12_TH_SCALE);
-	cctl1 |= (ctl1 & (PCI_L1SS_CTL1_CM_RESTORE_TIME |
-			  PCI_L1SS_CTL1_LTR_L12_TH_VALUE |
-			  PCI_L1SS_CTL1_LTR_L12_TH_SCALE));
-	aspm_program_l1ss(child, cctl1, ctl2);
+	/* Disable L1.2 while updating.  See PCIe r5.0, sec 5.5.4, 7.8.3.3 */
+	pl1_2_enables = pctl1 & PCI_L1SS_CTL1_L1_2_MASK;
+	cl1_2_enables = cctl1 & PCI_L1SS_CTL1_L1_2_MASK;
+
+	if (pl1_2_enables || cl1_2_enables) {
+		pci_clear_and_set_dword(child, child->l1ss + PCI_L1SS_CTL1,
+					PCI_L1SS_CTL1_L1_2_MASK, 0);
+		pci_clear_and_set_dword(parent, parent->l1ss + PCI_L1SS_CTL1,
+					PCI_L1SS_CTL1_L1_2_MASK, 0);
+	}
+
+	/* Program T_POWER_ON times in both ports */
+	pci_write_config_dword(parent, parent->l1ss + PCI_L1SS_CTL2, ctl2);
+	pci_write_config_dword(child, child->l1ss + PCI_L1SS_CTL2, ctl2);
+
+	/* Program Common_Mode_Restore_Time in upstream device */
+	pci_clear_and_set_dword(parent, parent->l1ss + PCI_L1SS_CTL1,
+				PCI_L1SS_CTL1_CM_RESTORE_TIME, ctl1);
+
+	/* Program LTR_L1.2_THRESHOLD time in both ports */
+	pci_clear_and_set_dword(parent,	parent->l1ss + PCI_L1SS_CTL1,
+				PCI_L1SS_CTL1_LTR_L12_TH_VALUE |
+				PCI_L1SS_CTL1_LTR_L12_TH_SCALE, ctl1);
+	pci_clear_and_set_dword(child, child->l1ss + PCI_L1SS_CTL1,
+				PCI_L1SS_CTL1_LTR_L12_TH_VALUE |
+				PCI_L1SS_CTL1_LTR_L12_TH_SCALE, ctl1);
+
+	if (pl1_2_enables || cl1_2_enables) {
+		pci_clear_and_set_dword(parent, parent->l1ss + PCI_L1SS_CTL1, 0,
+					pl1_2_enables);
+		pci_clear_and_set_dword(child, child->l1ss + PCI_L1SS_CTL1, 0,
+					cl1_2_enables);
+	}
 }
 
 static void aspm_l1ss_init(struct pcie_link_state *link)
@@ -757,43 +751,6 @@ static void pcie_config_aspm_l1ss(struct pcie_link_state *link, u32 state)
 				PCI_L1SS_CTL1_L1SS_MASK, val);
 }
 
-void pci_save_aspm_l1ss_state(struct pci_dev *dev)
-{
-	struct pci_cap_saved_state *save_state;
-	u16 l1ss = dev->l1ss;
-	u32 *cap;
-
-	if (!l1ss)
-		return;
-
-	save_state = pci_find_saved_ext_cap(dev, PCI_EXT_CAP_ID_L1SS);
-	if (!save_state)
-		return;
-
-	cap = (u32 *)&save_state->cap.data[0];
-	pci_read_config_dword(dev, l1ss + PCI_L1SS_CTL2, cap++);
-	pci_read_config_dword(dev, l1ss + PCI_L1SS_CTL1, cap++);
-}
-
-void pci_restore_aspm_l1ss_state(struct pci_dev *dev)
-{
-	struct pci_cap_saved_state *save_state;
-	u32 *cap, ctl1, ctl2;
-	u16 l1ss = dev->l1ss;
-
-	if (!l1ss)
-		return;
-
-	save_state = pci_find_saved_ext_cap(dev, PCI_EXT_CAP_ID_L1SS);
-	if (!save_state)
-		return;
-
-	cap = (u32 *)&save_state->cap.data[0];
-	ctl2 = *cap++;
-	ctl1 = *cap;
-	aspm_program_l1ss(dev, ctl1, ctl2);
-}
-
 static void pcie_config_aspm_dev(struct pci_dev *pdev, u32 val)
 {
 	pcie_capability_clear_and_set_word(pdev, PCI_EXP_LNKCTL,
diff --git a/drivers/pinctrl/aspeed/pinctrl-aspeed.c b/drivers/pinctrl/aspeed/pinctrl-aspeed.c
index a30912a92f05..5a12fc7cf91f 100644
--- a/drivers/pinctrl/aspeed/pinctrl-aspeed.c
+++ b/drivers/pinctrl/aspeed/pinctrl-aspeed.c
@@ -92,10 +92,19 @@ static int aspeed_sig_expr_enable(struct aspeed_pinmux_data *ctx,
 static int aspeed_sig_expr_disable(struct aspeed_pinmux_data *ctx,
 				   const struct aspeed_sig_expr *expr)
 {
+	int ret;
+
 	pr_debug("Disabling signal %s for %s\n", expr->signal,
 		 expr->function);
 
-	return aspeed_sig_expr_set(ctx, expr, false);
+	ret = aspeed_sig_expr_eval(ctx, expr, true);
+	if (ret < 0)
+		return ret;
+
+	if (ret)
+		return aspeed_sig_expr_set(ctx, expr, false);
+
+	return 0;
 }
 
 /**
@@ -113,7 +122,7 @@ static int aspeed_disable_sig(struct aspeed_pinmux_data *ctx,
 	int ret = 0;
 
 	if (!exprs)
-		return true;
+		return -EINVAL;
 
 	while (*exprs && !ret) {
 		ret = aspeed_sig_expr_disable(ctx, *exprs);
diff --git a/drivers/pinctrl/intel/pinctrl-intel.c b/drivers/pinctrl/intel/pinctrl-intel.c
index 047a8374b4fd..954a41226740 100644
--- a/drivers/pinctrl/intel/pinctrl-intel.c
+++ b/drivers/pinctrl/intel/pinctrl-intel.c
@@ -1676,6 +1676,12 @@ const struct intel_pinctrl_soc_data *intel_pinctrl_get_soc_data(struct platform_
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
@@ -1709,8 +1715,7 @@ static bool intel_pinctrl_should_save(struct intel_pinctrl *pctrl, unsigned int
 	 * See https://bugzilla.kernel.org/show_bug.cgi?id=214749.
 	 */
 	value = readl(intel_get_padcfg(pctrl, pin, PADCFG0));
-	if ((value & PADCFG0_GPIROUTIOXAPIC) && (value & PADCFG0_GPIOTXDIS) &&
-	    (__intel_gpio_get_gpio_mode(value) == PADCFG0_PMODE_GPIO))
+	if (__intel_gpio_is_direct_irq(value))
 		return true;
 
 	return false;
@@ -1840,7 +1845,12 @@ int intel_pinctrl_resume_noirq(struct device *dev)
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
index 89557c7ed2ab..09c4dcef9338 100644
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
diff --git a/drivers/pinctrl/qcom/pinctrl-sm8450-lpass-lpi.c b/drivers/pinctrl/qcom/pinctrl-sm8450-lpass-lpi.c
index c3c8c34148f1..e22d03ce292e 100644
--- a/drivers/pinctrl/qcom/pinctrl-sm8450-lpass-lpi.c
+++ b/drivers/pinctrl/qcom/pinctrl-sm8450-lpass-lpi.c
@@ -105,7 +105,7 @@ static const struct pinctrl_pin_desc sm8450_lpi_pins[] = {
 static const char * const swr_tx_clk_groups[] = { "gpio0" };
 static const char * const swr_tx_data_groups[] = { "gpio1", "gpio2", "gpio14" };
 static const char * const swr_rx_clk_groups[] = { "gpio3" };
-static const char * const swr_rx_data_groups[] = { "gpio4", "gpio5", "gpio15" };
+static const char * const swr_rx_data_groups[] = { "gpio4", "gpio5" };
 static const char * const dmic1_clk_groups[] = { "gpio6" };
 static const char * const dmic1_data_groups[] = { "gpio7" };
 static const char * const dmic2_clk_groups[] = { "gpio8" };
diff --git a/drivers/spi/spi-dw-core.c b/drivers/spi/spi-dw-core.c
index 99edddf9958b..c3bfb6c84cab 100644
--- a/drivers/spi/spi-dw-core.c
+++ b/drivers/spi/spi-dw-core.c
@@ -366,7 +366,7 @@ static void dw_spi_irq_setup(struct dw_spi *dws)
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
index 80d8c6c3be36..3a42313d0d66 100644
--- a/drivers/usb/typec/altmodes/displayport.c
+++ b/drivers/usb/typec/altmodes/displayport.c
@@ -535,10 +535,10 @@ int dp_altmode_probe(struct typec_altmode *alt)
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
diff --git a/drivers/video/fbdev/nvidia/nvidia.c b/drivers/video/fbdev/nvidia/nvidia.c
index 329e2e8133c6..a6c3bc222246 100644
--- a/drivers/video/fbdev/nvidia/nvidia.c
+++ b/drivers/video/fbdev/nvidia/nvidia.c
@@ -1197,17 +1197,17 @@ static int nvidia_set_fbinfo(struct fb_info *info)
 	return nvidiafb_check_var(&info->var, info);
 }
 
-static u32 nvidia_get_chipset(struct fb_info *info)
+static u32 nvidia_get_chipset(struct pci_dev *pci_dev,
+			      volatile u32 __iomem *REGS)
 {
-	struct nvidia_par *par = info->par;
-	u32 id = (par->pci_dev->vendor << 16) | par->pci_dev->device;
+	u32 id = (pci_dev->vendor << 16) | pci_dev->device;
 
 	printk(KERN_INFO PFX "Device ID: %x \n", id);
 
 	if ((id & 0xfff0) == 0x00f0 ||
 	    (id & 0xfff0) == 0x02e0) {
 		/* pci-e */
-		id = NV_RD32(par->REGS, 0x1800);
+		id = NV_RD32(REGS, 0x1800);
 
 		if ((id & 0x0000ffff) == 0x000010DE)
 			id = 0x10DE0000 | (id >> 16);
@@ -1220,12 +1220,11 @@ static u32 nvidia_get_chipset(struct fb_info *info)
 	return id;
 }
 
-static u32 nvidia_get_arch(struct fb_info *info)
+static u32 nvidia_get_arch(u32 Chipset)
 {
-	struct nvidia_par *par = info->par;
 	u32 arch = 0;
 
-	switch (par->Chipset & 0x0ff0) {
+	switch (Chipset & 0x0ff0) {
 	case 0x0100:		/* GeForce 256 */
 	case 0x0110:		/* GeForce2 MX */
 	case 0x0150:		/* GeForce2 */
@@ -1278,16 +1277,44 @@ static int nvidiafb_probe(struct pci_dev *pd, const struct pci_device_id *ent)
 	struct fb_info *info;
 	unsigned short cmd;
 	int ret;
+	volatile u32 __iomem *REGS;
+	int Chipset;
+	u32 Architecture;
 
 	NVTRACE_ENTER();
 	assert(pd != NULL);
 
+	if (pci_enable_device(pd)) {
+		printk(KERN_ERR PFX "cannot enable PCI device\n");
+		return -ENODEV;
+	}
+
+	/* enable IO and mem if not already done */
+	pci_read_config_word(pd, PCI_COMMAND, &cmd);
+	cmd |= (PCI_COMMAND_IO | PCI_COMMAND_MEMORY);
+	pci_write_config_word(pd, PCI_COMMAND, cmd);
+
+	nvidiafb_fix.mmio_start = pci_resource_start(pd, 0);
+	nvidiafb_fix.mmio_len = pci_resource_len(pd, 0);
+
+	REGS = ioremap(nvidiafb_fix.mmio_start, nvidiafb_fix.mmio_len);
+	if (!REGS) {
+		printk(KERN_ERR PFX "cannot ioremap MMIO base\n");
+		return -ENODEV;
+	}
+
+	Chipset = nvidia_get_chipset(pd, REGS);
+	Architecture = nvidia_get_arch(Chipset);
+	if (Architecture == 0) {
+		printk(KERN_ERR PFX "unknown NV_ARCH\n");
+		goto err_out;
+	}
+
 	ret = aperture_remove_conflicting_pci_devices(pd, "nvidiafb");
 	if (ret)
-		return ret;
+		goto err_out;
 
 	info = framebuffer_alloc(sizeof(struct nvidia_par), &pd->dev);
-
 	if (!info)
 		goto err_out;
 
@@ -1298,11 +1325,6 @@ static int nvidiafb_probe(struct pci_dev *pd, const struct pci_device_id *ent)
 	if (info->pixmap.addr == NULL)
 		goto err_out_kfree;
 
-	if (pci_enable_device(pd)) {
-		printk(KERN_ERR PFX "cannot enable PCI device\n");
-		goto err_out_enable;
-	}
-
 	if (pci_request_regions(pd, "nvidiafb")) {
 		printk(KERN_ERR PFX "cannot request PCI regions\n");
 		goto err_out_enable;
@@ -1318,34 +1340,17 @@ static int nvidiafb_probe(struct pci_dev *pd, const struct pci_device_id *ent)
 	par->paneltweak = paneltweak;
 	par->reverse_i2c = reverse_i2c;
 
-	/* enable IO and mem if not already done */
-	pci_read_config_word(pd, PCI_COMMAND, &cmd);
-	cmd |= (PCI_COMMAND_IO | PCI_COMMAND_MEMORY);
-	pci_write_config_word(pd, PCI_COMMAND, cmd);
-
-	nvidiafb_fix.mmio_start = pci_resource_start(pd, 0);
 	nvidiafb_fix.smem_start = pci_resource_start(pd, 1);
-	nvidiafb_fix.mmio_len = pci_resource_len(pd, 0);
-
-	par->REGS = ioremap(nvidiafb_fix.mmio_start, nvidiafb_fix.mmio_len);
 
-	if (!par->REGS) {
-		printk(KERN_ERR PFX "cannot ioremap MMIO base\n");
-		goto err_out_free_base0;
-	}
+	par->REGS = REGS;
 
-	par->Chipset = nvidia_get_chipset(info);
-	par->Architecture = nvidia_get_arch(info);
-
-	if (par->Architecture == 0) {
-		printk(KERN_ERR PFX "unknown NV_ARCH\n");
-		goto err_out_arch;
-	}
+	par->Chipset = Chipset;
+	par->Architecture = Architecture;
 
 	sprintf(nvidiafb_fix.id, "NV%x", (pd->device & 0x0ff0) >> 4);
 
 	if (NVCommonSetup(info))
-		goto err_out_arch;
+		goto err_out_free_base0;
 
 	par->FbAddress = nvidiafb_fix.smem_start;
 	par->FbMapSize = par->RamAmountKBytes * 1024;
@@ -1401,7 +1406,6 @@ static int nvidiafb_probe(struct pci_dev *pd, const struct pci_device_id *ent)
 		goto err_out_iounmap_fb;
 	}
 
-
 	printk(KERN_INFO PFX
 	       "PCI nVidia %s framebuffer (%dMB @ 0x%lX)\n",
 	       info->fix.id,
@@ -1415,15 +1419,14 @@ static int nvidiafb_probe(struct pci_dev *pd, const struct pci_device_id *ent)
 err_out_free_base1:
 	fb_destroy_modedb(info->monspecs.modedb);
 	nvidia_delete_i2c_busses(par);
-err_out_arch:
-	iounmap(par->REGS);
- err_out_free_base0:
+err_out_free_base0:
 	pci_release_regions(pd);
 err_out_enable:
 	kfree(info->pixmap.addr);
 err_out_kfree:
 	framebuffer_release(info);
 err_out:
+	iounmap(REGS);
 	return -ENODEV;
 }
 
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 7535857f4c8f..e71464c0e466 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3607,17 +3607,19 @@ static noinline int insert_dir_log_key(struct btrfs_trans_handle *trans,
 }
 
 static int flush_dir_items_batch(struct btrfs_trans_handle *trans,
-				 struct btrfs_root *log,
+				 struct btrfs_inode *inode,
 				 struct extent_buffer *src,
 				 struct btrfs_path *dst_path,
 				 int start_slot,
 				 int count)
 {
+	struct btrfs_root *log = inode->root->log_root;
 	char *ins_data = NULL;
 	struct btrfs_item_batch batch;
 	struct extent_buffer *dst;
 	unsigned long src_offset;
 	unsigned long dst_offset;
+	u64 last_index;
 	struct btrfs_key key;
 	u32 item_size;
 	int ret;
@@ -3675,6 +3677,19 @@ static int flush_dir_items_batch(struct btrfs_trans_handle *trans,
 	src_offset = btrfs_item_ptr_offset(src, start_slot + count - 1);
 	copy_extent_buffer(dst, src, dst_offset, src_offset, batch.total_data_size);
 	btrfs_release_path(dst_path);
+
+	last_index = batch.keys[count - 1].offset;
+	ASSERT(last_index > inode->last_dir_index_offset);
+
+	/*
+	 * If for some unexpected reason the last item's index is not greater
+	 * than the last index we logged, warn and return an error to fallback
+	 * to a transaction commit.
+	 */
+	if (WARN_ON(last_index <= inode->last_dir_index_offset))
+		ret = -EUCLEAN;
+	else
+		inode->last_dir_index_offset = last_index;
 out:
 	kfree(ins_data);
 
@@ -3724,7 +3739,6 @@ static int process_dir_items_leaf(struct btrfs_trans_handle *trans,
 		}
 
 		di = btrfs_item_ptr(src, i, struct btrfs_dir_item);
-		ctx->last_dir_item_offset = key.offset;
 
 		/*
 		 * Skip ranges of items that consist only of dir item keys created
@@ -3787,7 +3801,7 @@ static int process_dir_items_leaf(struct btrfs_trans_handle *trans,
 	if (batch_size > 0) {
 		int ret;
 
-		ret = flush_dir_items_batch(trans, log, src, dst_path,
+		ret = flush_dir_items_batch(trans, inode, src, dst_path,
 					    batch_start, batch_size);
 		if (ret < 0)
 			return ret;
@@ -4075,7 +4089,6 @@ static noinline int log_directory_changes(struct btrfs_trans_handle *trans,
 
 	min_key = BTRFS_DIR_START_INDEX;
 	max_key = 0;
-	ctx->last_dir_item_offset = inode->last_dir_index_offset;
 
 	while (1) {
 		ret = log_dir_items(trans, inode, path, dst_path,
@@ -4087,8 +4100,6 @@ static noinline int log_directory_changes(struct btrfs_trans_handle *trans,
 		min_key = max_key + 1;
 	}
 
-	inode->last_dir_index_offset = ctx->last_dir_item_offset;
-
 	return 0;
 }
 
diff --git a/fs/btrfs/tree-log.h b/fs/btrfs/tree-log.h
index aed1e05e9879..bcca74128c3b 100644
--- a/fs/btrfs/tree-log.h
+++ b/fs/btrfs/tree-log.h
@@ -23,8 +23,6 @@ struct btrfs_log_ctx {
 	bool logging_new_delayed_dentries;
 	/* Indicate if the inode being logged was logged before. */
 	bool logged_before;
-	/* Tracks the last logged dir item/index key offset. */
-	u64 last_dir_item_offset;
 	struct inode *inode;
 	struct list_head list;
 	/* Only used for fast fsyncs. */
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 65e4e887605f..05f9cbbf6e1e 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -408,6 +408,7 @@ void btrfs_free_device(struct btrfs_device *device)
 static void free_fs_devices(struct btrfs_fs_devices *fs_devices)
 {
 	struct btrfs_device *device;
+
 	WARN_ON(fs_devices->opened);
 	while (!list_empty(&fs_devices->devices)) {
 		device = list_entry(fs_devices->devices.next,
@@ -1194,9 +1195,22 @@ void btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
 
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
@@ -1612,7 +1626,7 @@ static int find_free_dev_extent_start(struct btrfs_device *device,
 	if (ret < 0)
 		goto out;
 
-	while (1) {
+	while (search_start < search_end) {
 		l = path->nodes[0];
 		slot = path->slots[0];
 		if (slot >= btrfs_header_nritems(l)) {
@@ -1635,6 +1649,9 @@ static int find_free_dev_extent_start(struct btrfs_device *device,
 		if (key.type != BTRFS_DEV_EXTENT_KEY)
 			goto next;
 
+		if (key.offset > search_end)
+			break;
+
 		if (key.offset > search_start) {
 			hole_size = key.offset - search_start;
 			dev_extent_hole_check(device, &search_start, &hole_size,
@@ -1695,6 +1712,7 @@ static int find_free_dev_extent_start(struct btrfs_device *device,
 	else
 		ret = 0;
 
+	ASSERT(max_hole_start + max_hole_size <= search_end);
 out:
 	btrfs_free_path(path);
 	*start = max_hole_start;
diff --git a/fs/btrfs/zlib.c b/fs/btrfs/zlib.c
index b4f44662cda7..94d06a76edb1 100644
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
index 26a0a8b9975e..756560df3bdb 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -3662,6 +3662,12 @@ static void handle_session(struct ceph_mds_session *session,
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
index 209dfc06fd6d..542f22db5f46 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -3880,7 +3880,7 @@ uncached_fill_pages(struct TCP_Server_Info *server,
 		rdata->got_bytes += result;
 	}
 
-	return rdata->got_bytes > 0 && result != -ECONNABORTED ?
+	return result != -ECONNABORTED && rdata->got_bytes > 0 ?
 						rdata->got_bytes : result;
 }
 
@@ -4656,7 +4656,7 @@ readpages_fill_pages(struct TCP_Server_Info *server,
 		rdata->got_bytes += result;
 	}
 
-	return rdata->got_bytes > 0 && result != -ECONNABORTED ?
+	return result != -ECONNABORTED && rdata->got_bytes > 0 ?
 						rdata->got_bytes : result;
 }
 
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index ad55470a9fb9..fff61e6d6d4d 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -573,6 +573,14 @@ struct mlx5_debugfs_entries {
 	struct dentry *lag_debugfs;
 };
 
+enum mlx5_func_type {
+	MLX5_PF,
+	MLX5_VF,
+	MLX5_SF,
+	MLX5_HOST_PF,
+	MLX5_FUNC_TYPE_NUM,
+};
+
 struct mlx5_ft_pool;
 struct mlx5_priv {
 	/* IRQ table valid only for real pci devices PF or VF */
@@ -583,11 +591,10 @@ struct mlx5_priv {
 	struct mlx5_nb          pg_nb;
 	struct workqueue_struct *pg_wq;
 	struct xarray           page_root_xa;
-	u32			fw_pages;
 	atomic_t		reg_pages;
 	struct list_head	free_list;
-	u32			vfs_pages;
-	u32			host_pf_pages;
+	u32			fw_pages;
+	u32			page_counters[MLX5_FUNC_TYPE_NUM];
 	u32			fw_pages_alloc_failed;
 	u32			give_pages_dropped;
 	u32			reclaim_pages_discard;
diff --git a/include/linux/trace_events.h b/include/linux/trace_events.h
index 20749bd9db71..04c59f8d801f 100644
--- a/include/linux/trace_events.h
+++ b/include/linux/trace_events.h
@@ -270,6 +270,7 @@ struct trace_event_fields {
 			const int  align;
 			const int  is_signed;
 			const int  filter_type;
+			const int  len;
 		};
 		int (*define_fields)(struct trace_event_call *);
 	};
diff --git a/include/trace/stages/stage4_event_fields.h b/include/trace/stages/stage4_event_fields.h
index a8fb25f39a99..fae467ccd0c3 100644
--- a/include/trace/stages/stage4_event_fields.h
+++ b/include/trace/stages/stage4_event_fields.h
@@ -26,7 +26,8 @@
 #define __array(_type, _item, _len) {					\
 	.type = #_type"["__stringify(_len)"]", .name = #_item,		\
 	.size = sizeof(_type[_len]), .align = ALIGN_STRUCTFIELD(_type),	\
-	.is_signed = is_signed_type(_type), .filter_type = FILTER_OTHER },
+	.is_signed = is_signed_type(_type), .filter_type = FILTER_OTHER,\
+	.len = _len },
 
 #undef __dynamic_array
 #define __dynamic_array(_type, _item, _len) {				\
diff --git a/include/uapi/drm/virtgpu_drm.h b/include/uapi/drm/virtgpu_drm.h
index 0512fde5e697..7b158fcb02b4 100644
--- a/include/uapi/drm/virtgpu_drm.h
+++ b/include/uapi/drm/virtgpu_drm.h
@@ -64,6 +64,7 @@ struct drm_virtgpu_map {
 	__u32 pad;
 };
 
+/* fence_fd is modified on success if VIRTGPU_EXECBUF_FENCE_FD_OUT flag is set. */
 struct drm_virtgpu_execbuffer {
 	__u32 flags;
 	__u32 size;
diff --git a/include/uapi/linux/ip.h b/include/uapi/linux/ip.h
index 874a92349bf5..283dec7e3645 100644
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
index 81f4243bebb1..53326dfc59ec 100644
--- a/include/uapi/linux/ipv6.h
+++ b/include/uapi/linux/ipv6.h
@@ -4,6 +4,7 @@
 
 #include <linux/libc-compat.h>
 #include <linux/types.h>
+#include <linux/stddef.h>
 #include <linux/in6.h>
 #include <asm/byteorder.h>
 
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index a753adcbc7c7..fac426036620 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1201,12 +1201,13 @@ void rebuild_sched_domains(void)
 /**
  * update_tasks_cpumask - Update the cpumasks of tasks in the cpuset.
  * @cs: the cpuset in which each task's cpus_allowed mask needs to be changed
+ * @new_cpus: the temp variable for the new effective_cpus mask
  *
  * Iterate through each task of @cs updating its cpus_allowed to the
  * effective cpuset's.  As this function is called with cpuset_rwsem held,
  * cpuset membership stays stable.
  */
-static void update_tasks_cpumask(struct cpuset *cs)
+static void update_tasks_cpumask(struct cpuset *cs, struct cpumask *new_cpus)
 {
 	struct css_task_iter it;
 	struct task_struct *task;
@@ -1220,7 +1221,10 @@ static void update_tasks_cpumask(struct cpuset *cs)
 		if (top_cs && (task->flags & PF_KTHREAD) &&
 		    kthread_is_per_cpu(task))
 			continue;
-		set_cpus_allowed_ptr(task, cs->effective_cpus);
+
+		cpumask_and(new_cpus, cs->effective_cpus,
+			    task_cpu_possible_mask(task));
+		set_cpus_allowed_ptr(task, new_cpus);
 	}
 	css_task_iter_end(&it);
 }
@@ -1505,7 +1509,7 @@ static int update_parent_subparts_cpumask(struct cpuset *cs, int cmd,
 	spin_unlock_irq(&callback_lock);
 
 	if (adding || deleting)
-		update_tasks_cpumask(parent);
+		update_tasks_cpumask(parent, tmp->new_cpus);
 
 	/*
 	 * Set or clear CS_SCHED_LOAD_BALANCE when partcmd_update, if necessary.
@@ -1657,7 +1661,7 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
 		WARN_ON(!is_in_v2_mode() &&
 			!cpumask_equal(cp->cpus_allowed, cp->effective_cpus));
 
-		update_tasks_cpumask(cp);
+		update_tasks_cpumask(cp, tmp->new_cpus);
 
 		/*
 		 * On legacy hierarchy, if the effective cpumask of any non-
@@ -2305,7 +2309,7 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 		}
 	}
 
-	update_tasks_cpumask(parent);
+	update_tasks_cpumask(parent, tmpmask.new_cpus);
 
 	if (parent->child_ecpus_count)
 		update_sibling_cpumasks(parent, cs, &tmpmask);
@@ -3318,7 +3322,7 @@ hotplug_update_tasks_legacy(struct cpuset *cs,
 	 * as the tasks will be migrated to an ancestor.
 	 */
 	if (cpus_updated && !cpumask_empty(cs->cpus_allowed))
-		update_tasks_cpumask(cs);
+		update_tasks_cpumask(cs, new_cpus);
 	if (mems_updated && !nodes_empty(cs->mems_allowed))
 		update_tasks_nodemask(cs);
 
@@ -3355,7 +3359,7 @@ hotplug_update_tasks(struct cpuset *cs,
 	spin_unlock_irq(&callback_lock);
 
 	if (cpus_updated)
-		update_tasks_cpumask(cs);
+		update_tasks_cpumask(cs, new_cpus);
 	if (mems_updated)
 		update_tasks_nodemask(cs);
 }
diff --git a/kernel/locking/rtmutex.c b/kernel/locking/rtmutex.c
index 010cf4e6d0b8..728f434de2bb 100644
--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -901,8 +901,9 @@ static int __sched rt_mutex_adjust_prio_chain(struct task_struct *task,
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
index 546e84ae9993..a387bdc6af01 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -9144,9 +9144,6 @@ buffer_percent_write(struct file *filp, const char __user *ubuf,
 	if (val > 100)
 		return -EINVAL;
 
-	if (!val)
-		val = 1;
-
 	tr->buffer_percent = val;
 
 	(*ppos)++;
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 9e931f51328a..ac7af03ce837 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -1282,6 +1282,7 @@ struct ftrace_event_field {
 	int			offset;
 	int			size;
 	int			is_signed;
+	int			len;
 };
 
 struct prog_entry;
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index f71ea6e79b3c..2a2ea9b6f762 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -114,7 +114,7 @@ trace_find_event_field(struct trace_event_call *call, char *name)
 
 static int __trace_define_field(struct list_head *head, const char *type,
 				const char *name, int offset, int size,
-				int is_signed, int filter_type)
+				int is_signed, int filter_type, int len)
 {
 	struct ftrace_event_field *field;
 
@@ -133,6 +133,7 @@ static int __trace_define_field(struct list_head *head, const char *type,
 	field->offset = offset;
 	field->size = size;
 	field->is_signed = is_signed;
+	field->len = len;
 
 	list_add(&field->link, head);
 
@@ -150,14 +151,28 @@ int trace_define_field(struct trace_event_call *call, const char *type,
 
 	head = trace_get_fields(call);
 	return __trace_define_field(head, type, name, offset, size,
-				    is_signed, filter_type);
+				    is_signed, filter_type, 0);
 }
 EXPORT_SYMBOL_GPL(trace_define_field);
 
+int trace_define_field_ext(struct trace_event_call *call, const char *type,
+		       const char *name, int offset, int size, int is_signed,
+		       int filter_type, int len)
+{
+	struct list_head *head;
+
+	if (WARN_ON(!call->class))
+		return 0;
+
+	head = trace_get_fields(call);
+	return __trace_define_field(head, type, name, offset, size,
+				    is_signed, filter_type, len);
+}
+
 #define __generic_field(type, item, filter_type)			\
 	ret = __trace_define_field(&ftrace_generic_fields, #type,	\
 				   #item, 0, 0, is_signed_type(type),	\
-				   filter_type);			\
+				   filter_type, 0);			\
 	if (ret)							\
 		return ret;
 
@@ -166,7 +181,7 @@ EXPORT_SYMBOL_GPL(trace_define_field);
 				   "common_" #item,			\
 				   offsetof(typeof(ent), item),		\
 				   sizeof(ent.item),			\
-				   is_signed_type(type), FILTER_OTHER);	\
+				   is_signed_type(type), FILTER_OTHER, 0);	\
 	if (ret)							\
 		return ret;
 
@@ -1588,12 +1603,17 @@ static int f_show(struct seq_file *m, void *v)
 		seq_printf(m, "\tfield:%s %s;\toffset:%u;\tsize:%u;\tsigned:%d;\n",
 			   field->type, field->name, field->offset,
 			   field->size, !!field->is_signed);
-	else
-		seq_printf(m, "\tfield:%.*s %s%s;\toffset:%u;\tsize:%u;\tsigned:%d;\n",
+	else if (field->len)
+		seq_printf(m, "\tfield:%.*s %s[%d];\toffset:%u;\tsize:%u;\tsigned:%d;\n",
 			   (int)(array_descriptor - field->type),
 			   field->type, field->name,
-			   array_descriptor, field->offset,
+			   field->len, field->offset,
 			   field->size, !!field->is_signed);
+	else
+		seq_printf(m, "\tfield:%.*s %s[];\toffset:%u;\tsize:%u;\tsigned:%d;\n",
+				(int)(array_descriptor - field->type),
+				field->type, field->name,
+				field->offset, field->size, !!field->is_signed);
 
 	return 0;
 }
@@ -2379,9 +2399,10 @@ event_define_fields(struct trace_event_call *call)
 			}
 
 			offset = ALIGN(offset, field->align);
-			ret = trace_define_field(call, field->type, field->name,
+			ret = trace_define_field_ext(call, field->type, field->name,
 						 offset, field->size,
-						 field->is_signed, field->filter_type);
+						 field->is_signed, field->filter_type,
+						 field->len);
 			if (WARN_ON_ONCE(ret)) {
 				pr_err("error code is %d\n", ret);
 				break;
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index d960f6b11b5e..58f3946081e2 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -111,7 +111,8 @@ static void __always_unused ____ftrace_check_##name(void)		\
 #define __array(_type, _item, _len) {					\
 	.type = #_type"["__stringify(_len)"]", .name = #_item,		\
 	.size = sizeof(_type[_len]), .align = __alignof__(_type),	\
-	is_signed_type(_type), .filter_type = FILTER_OTHER },
+	is_signed_type(_type), .filter_type = FILTER_OTHER,			\
+	.len = _len },
 
 #undef __array_desc
 #define __array_desc(_type, _container, _item, _len) __array(_type, _item, _len)
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 6e60657875d3..b2877a84ed19 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5640,9 +5640,12 @@ EXPORT_SYMBOL(get_zeroed_page);
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
 
diff --git a/net/core/sock.c b/net/core/sock.c
index 30407b2dd2ac..ba6ea61b3458 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1524,6 +1524,8 @@ int sk_setsockopt(struct sock *sk, int level, int optname,
 			ret = -EINVAL;
 			break;
 		}
+		if ((u8)val == SOCK_TXREHASH_DEFAULT)
+			val = READ_ONCE(sock_net(sk)->core.sysctl_txrehash);
 		/* Paired with READ_ONCE() in tcp_rtx_synack() */
 		WRITE_ONCE(sk->sk_txrehash, (u8)val);
 		break;
@@ -3428,7 +3430,6 @@ void sock_init_data(struct socket *sock, struct sock *sk)
 	sk->sk_pacing_rate = ~0UL;
 	WRITE_ONCE(sk->sk_pacing_shift, 10);
 	sk->sk_incoming_cpu = -1;
-	sk->sk_txrehash = SOCK_TXREHASH_DEFAULT;
 
 	sk_rx_queue_clear(sk);
 	/*
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 92d423786251..5b19b77d5d75 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -347,6 +347,7 @@ static int inet_create(struct net *net, struct socket *sock, int protocol,
 	sk->sk_destruct	   = inet_sock_destruct;
 	sk->sk_protocol	   = protocol;
 	sk->sk_backlog_rcv = sk->sk_prot->backlog_rcv;
+	sk->sk_txrehash = READ_ONCE(net->core.sysctl_txrehash);
 
 	inet->uc_ttl	= -1;
 	inet->mc_loop	= 1;
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 647b3c6b575e..7152ede18f11 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -1225,9 +1225,6 @@ int inet_csk_listen_start(struct sock *sk)
 	sk->sk_ack_backlog = 0;
 	inet_csk_delack_init(sk);
 
-	if (sk->sk_txrehash == SOCK_TXREHASH_DEFAULT)
-		sk->sk_txrehash = READ_ONCE(sock_net(sk)->core.sysctl_txrehash);
-
 	/* There is race window here: we announce ourselves listening,
 	 * but this transition is still not validated by get_port().
 	 * It is OK, because this socket enters to hash table only
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index 7b0cd54da452..fb1bf6eb0ff8 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -221,6 +221,7 @@ static int inet6_create(struct net *net, struct socket *sock, int protocol,
 	np->pmtudisc	= IPV6_PMTUDISC_WANT;
 	np->repflow	= net->ipv6.sysctl.flowlabel_reflect & FLOWLABEL_REFLECT_ESTABLISHED;
 	sk->sk_ipv6only	= net->ipv6.sysctl.bindv6only;
+	sk->sk_txrehash = READ_ONCE(net->core.sysctl_txrehash);
 
 	/* Init the ipv4 part of the socket since we can have sockets
 	 * using v6 API for ipv4.
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 29849d77e4bf..938cccab331d 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2908,6 +2908,7 @@ bool __mptcp_close(struct sock *sk, long timeout)
 	struct mptcp_subflow_context *subflow;
 	struct mptcp_sock *msk = mptcp_sk(sk);
 	bool do_cancel_work = false;
+	int subflows_alive = 0;
 
 	sk->sk_shutdown = SHUTDOWN_MASK;
 
@@ -2933,6 +2934,8 @@ bool __mptcp_close(struct sock *sk, long timeout)
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
 		bool slow = lock_sock_fast_nested(ssk);
 
+		subflows_alive += ssk->sk_state != TCP_CLOSE;
+
 		/* since the close timeout takes precedence on the fail one,
 		 * cancel the latter
 		 */
@@ -2948,6 +2951,12 @@ bool __mptcp_close(struct sock *sk, long timeout)
 	}
 	sock_orphan(sk);
 
+	/* all the subflows are closed, only timeout can change the msk
+	 * state, let's not keep resources busy for no reasons
+	 */
+	if (subflows_alive == 0)
+		inet_sk_state_store(sk, TCP_CLOSE);
+
 	sock_hold(sk);
 	pr_debug("msk=%p state=%d", sk, sk->sk_state);
 	if (mptcp_sk(sk)->token)
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 5220435d8e34..929b0ee8b3d5 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1344,6 +1344,7 @@ void __mptcp_error_report(struct sock *sk)
 	mptcp_for_each_subflow(msk, subflow) {
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
 		int err = sock_error(ssk);
+		int ssk_state;
 
 		if (!err)
 			continue;
@@ -1354,7 +1355,14 @@ void __mptcp_error_report(struct sock *sk)
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
index 44dbc612ef54..9402bc941823 100644
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
index 97074f6f2bde..2defd89da700 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -279,8 +279,7 @@ static int xfrm6_remove_tunnel_encap(struct xfrm_state *x, struct sk_buff *skb)
 		goto out;
 
 	if (x->props.flags & XFRM_STATE_DECAP_DSCP)
-		ipv6_copy_dscp(ipv6_get_dsfield(ipv6_hdr(skb)),
-			       ipipv6_hdr(skb));
+		ipv6_copy_dscp(XFRM_MODE_SKB_CB(skb)->tos, ipipv6_hdr(skb));
 	if (!(x->props.flags & XFRM_STATE_NOECN))
 		ipip6_ecn_decapsulate(skb);
 
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index e392d8d05e0c..52538d536067 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -336,7 +336,7 @@ static void xfrm_policy_timer(struct timer_list *t)
 	}
 	if (xp->lft.hard_use_expires_seconds) {
 		time64_t tmo = xp->lft.hard_use_expires_seconds +
-			(xp->curlft.use_time ? : xp->curlft.add_time) - now;
+			(READ_ONCE(xp->curlft.use_time) ? : xp->curlft.add_time) - now;
 		if (tmo <= 0)
 			goto expired;
 		if (tmo < next)
@@ -354,7 +354,7 @@ static void xfrm_policy_timer(struct timer_list *t)
 	}
 	if (xp->lft.soft_use_expires_seconds) {
 		time64_t tmo = xp->lft.soft_use_expires_seconds +
-			(xp->curlft.use_time ? : xp->curlft.add_time) - now;
+			(READ_ONCE(xp->curlft.use_time) ? : xp->curlft.add_time) - now;
 		if (tmo <= 0) {
 			warn = 1;
 			tmo = XFRM_KM_TIMEOUT;
@@ -3586,7 +3586,8 @@ int __xfrm_policy_check(struct sock *sk, int dir, struct sk_buff *skb,
 		return 1;
 	}
 
-	pol->curlft.use_time = ktime_get_real_seconds();
+	/* This lockless write can happen from different cpus. */
+	WRITE_ONCE(pol->curlft.use_time, ktime_get_real_seconds());
 
 	pols[0] = pol;
 	npols++;
@@ -3601,7 +3602,9 @@ int __xfrm_policy_check(struct sock *sk, int dir, struct sk_buff *skb,
 				xfrm_pol_put(pols[0]);
 				return 0;
 			}
-			pols[1]->curlft.use_time = ktime_get_real_seconds();
+			/* This write can happen from different cpus. */
+			WRITE_ONCE(pols[1]->curlft.use_time,
+				   ktime_get_real_seconds());
 			npols++;
 		}
 	}
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 3d2fe7712ac5..0f88cb6fc3c2 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -572,7 +572,7 @@ static enum hrtimer_restart xfrm_timer_handler(struct hrtimer *me)
 	}
 	if (x->lft.hard_use_expires_seconds) {
 		long tmo = x->lft.hard_use_expires_seconds +
-			(x->curlft.use_time ? : now) - now;
+			(READ_ONCE(x->curlft.use_time) ? : now) - now;
 		if (tmo <= 0)
 			goto expired;
 		if (tmo < next)
@@ -594,7 +594,7 @@ static enum hrtimer_restart xfrm_timer_handler(struct hrtimer *me)
 	}
 	if (x->lft.soft_use_expires_seconds) {
 		long tmo = x->lft.soft_use_expires_seconds +
-			(x->curlft.use_time ? : now) - now;
+			(READ_ONCE(x->curlft.use_time) ? : now) - now;
 		if (tmo <= 0)
 			warn = 1;
 		else if (tmo < next)
@@ -1754,7 +1754,7 @@ int xfrm_state_update(struct xfrm_state *x)
 
 		hrtimer_start(&x1->mtimer, ktime_set(1, 0),
 			      HRTIMER_MODE_REL_SOFT);
-		if (x1->curlft.use_time)
+		if (READ_ONCE(x1->curlft.use_time))
 			xfrm_state_check_expire(x1);
 
 		if (x->props.smark.m || x->props.smark.v || x->if_id) {
@@ -1786,8 +1786,8 @@ EXPORT_SYMBOL(xfrm_state_update);
 
 int xfrm_state_check_expire(struct xfrm_state *x)
 {
-	if (!x->curlft.use_time)
-		x->curlft.use_time = ktime_get_real_seconds();
+	if (!READ_ONCE(x->curlft.use_time))
+		WRITE_ONCE(x->curlft.use_time, ktime_get_real_seconds());
 
 	if (x->curlft.bytes >= x->lft.hard_byte_limit ||
 	    x->curlft.packets >= x->lft.hard_packet_limit) {
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index db9518de9343..1134a493d225 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9423,6 +9423,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x89c3, "Zbook Studio G9", ALC245_FIXUP_CS35L41_SPI_4_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x89c6, "Zbook Fury 17 G9", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x89ca, "HP", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
+	SND_PCI_QUIRK(0x103c, 0x89d3, "HP EliteBook 645 G9 (MB 89D2)", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8a78, "HP Dev One", ALC285_FIXUP_HP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x103c, 0x8aa0, "HP ProBook 440 G9 (MB 8A9E)", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8aa3, "HP ProBook 450 G9 (MB 8AA1)", ALC236_FIXUP_HP_GPIO_LED),
@@ -9433,6 +9434,11 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8ad2, "HP EliteBook 860 16 inch G9 Notebook PC", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8b5d, "HP", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8b5e, "HP", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
+	SND_PCI_QUIRK(0x103c, 0x8b7a, "HP", ALC236_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8b7d, "HP", ALC236_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8b8a, "HP", ALC236_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8b8b, "HP", ALC236_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8b8d, "HP", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8b92, "HP", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8bf0, "HP", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x1043, 0x103e, "ASUS X540SA", ALC256_FIXUP_ASUS_MIC),
@@ -9480,6 +9486,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x1d4e, "ASUS TM420", ALC256_FIXUP_ASUS_HPE),
 	SND_PCI_QUIRK(0x1043, 0x1e02, "ASUS UX3402", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x1e11, "ASUS Zephyrus G15", ALC289_FIXUP_ASUS_GA502),
+	SND_PCI_QUIRK(0x1043, 0x1e12, "ASUS UM3402", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x1e51, "ASUS Zephyrus M15", ALC294_FIXUP_ASUS_GU502_PINS),
 	SND_PCI_QUIRK(0x1043, 0x1e5e, "ASUS ROG Strix G513", ALC294_FIXUP_ASUS_G513_PINS),
 	SND_PCI_QUIRK(0x1043, 0x1e8e, "ASUS Zephyrus G15", ALC289_FIXUP_ASUS_GA401),
@@ -9523,6 +9530,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x144d, 0xc812, "Samsung Notebook Pen S (NT950SBE-X58)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc830, "Samsung Galaxy Book Ion (NT950XCJ-X716A)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc832, "Samsung Galaxy Book Flex Alpha (NP730QCJ)", ALC256_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET),
+	SND_PCI_QUIRK(0x144d, 0xca03, "Samsung Galaxy Book2 Pro 360 (NP930QED)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x1458, 0xfa53, "Gigabyte BXBT-2807", ALC283_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1462, 0xb120, "MSI Cubi MS-B120", ALC283_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1462, 0xb171, "Cubi N 8GL (MS-B171)", ALC283_FIXUP_HEADSET_MIC),
@@ -9701,6 +9709,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
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
 
diff --git a/sound/soc/codecs/tas5805m.c b/sound/soc/codecs/tas5805m.c
index beb4ec629a03..4e38eb7acea1 100644
--- a/sound/soc/codecs/tas5805m.c
+++ b/sound/soc/codecs/tas5805m.c
@@ -154,6 +154,7 @@ static const uint32_t tas5805m_volume[] = {
 #define TAS5805M_VOLUME_MIN	0
 
 struct tas5805m_priv {
+	struct i2c_client		*i2c;
 	struct regulator		*pvdd;
 	struct gpio_desc		*gpio_pdn_n;
 
@@ -165,6 +166,9 @@ struct tas5805m_priv {
 	int				vol[2];
 	bool				is_powered;
 	bool				is_muted;
+
+	struct work_struct		work;
+	struct mutex			lock;
 };
 
 static void set_dsp_scale(struct regmap *rm, int offset, int vol)
@@ -181,13 +185,11 @@ static void set_dsp_scale(struct regmap *rm, int offset, int vol)
 	regmap_bulk_write(rm, offset, v, ARRAY_SIZE(v));
 }
 
-static void tas5805m_refresh(struct snd_soc_component *component)
+static void tas5805m_refresh(struct tas5805m_priv *tas5805m)
 {
-	struct tas5805m_priv *tas5805m =
-		snd_soc_component_get_drvdata(component);
 	struct regmap *rm = tas5805m->regmap;
 
-	dev_dbg(component->dev, "refresh: is_muted=%d, vol=%d/%d\n",
+	dev_dbg(&tas5805m->i2c->dev, "refresh: is_muted=%d, vol=%d/%d\n",
 		tas5805m->is_muted, tas5805m->vol[0], tas5805m->vol[1]);
 
 	regmap_write(rm, REG_PAGE, 0x00);
@@ -201,6 +203,9 @@ static void tas5805m_refresh(struct snd_soc_component *component)
 	set_dsp_scale(rm, 0x24, tas5805m->vol[0]);
 	set_dsp_scale(rm, 0x28, tas5805m->vol[1]);
 
+	regmap_write(rm, REG_PAGE, 0x00);
+	regmap_write(rm, REG_BOOK, 0x00);
+
 	/* Set/clear digital soft-mute */
 	regmap_write(rm, REG_DEVICE_CTRL_2,
 		(tas5805m->is_muted ? DCTRL2_MUTE : 0) |
@@ -226,8 +231,11 @@ static int tas5805m_vol_get(struct snd_kcontrol *kcontrol,
 	struct tas5805m_priv *tas5805m =
 		snd_soc_component_get_drvdata(component);
 
+	mutex_lock(&tas5805m->lock);
 	ucontrol->value.integer.value[0] = tas5805m->vol[0];
 	ucontrol->value.integer.value[1] = tas5805m->vol[1];
+	mutex_unlock(&tas5805m->lock);
+
 	return 0;
 }
 
@@ -243,11 +251,13 @@ static int tas5805m_vol_put(struct snd_kcontrol *kcontrol,
 		snd_soc_kcontrol_component(kcontrol);
 	struct tas5805m_priv *tas5805m =
 		snd_soc_component_get_drvdata(component);
+	int ret = 0;
 
 	if (!(volume_is_valid(ucontrol->value.integer.value[0]) &&
 	      volume_is_valid(ucontrol->value.integer.value[1])))
 		return -EINVAL;
 
+	mutex_lock(&tas5805m->lock);
 	if (tas5805m->vol[0] != ucontrol->value.integer.value[0] ||
 	    tas5805m->vol[1] != ucontrol->value.integer.value[1]) {
 		tas5805m->vol[0] = ucontrol->value.integer.value[0];
@@ -256,11 +266,12 @@ static int tas5805m_vol_put(struct snd_kcontrol *kcontrol,
 			tas5805m->vol[0], tas5805m->vol[1],
 			tas5805m->is_powered);
 		if (tas5805m->is_powered)
-			tas5805m_refresh(component);
-		return 1;
+			tas5805m_refresh(tas5805m);
+		ret = 1;
 	}
+	mutex_unlock(&tas5805m->lock);
 
-	return 0;
+	return ret;
 }
 
 static const struct snd_kcontrol_new tas5805m_snd_controls[] = {
@@ -294,54 +305,83 @@ static int tas5805m_trigger(struct snd_pcm_substream *substream, int cmd,
 	struct snd_soc_component *component = dai->component;
 	struct tas5805m_priv *tas5805m =
 		snd_soc_component_get_drvdata(component);
-	struct regmap *rm = tas5805m->regmap;
-	unsigned int chan, global1, global2;
 
 	switch (cmd) {
 	case SNDRV_PCM_TRIGGER_START:
 	case SNDRV_PCM_TRIGGER_RESUME:
 	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
-		dev_dbg(component->dev, "DSP startup\n");
-
-		/* We mustn't issue any I2C transactions until the I2S
-		 * clock is stable. Furthermore, we must allow a 5ms
-		 * delay after the first set of register writes to
-		 * allow the DSP to boot before configuring it.
-		 */
-		usleep_range(5000, 10000);
-		send_cfg(rm, dsp_cfg_preboot,
-			ARRAY_SIZE(dsp_cfg_preboot));
-		usleep_range(5000, 15000);
-		send_cfg(rm, tas5805m->dsp_cfg_data,
-			tas5805m->dsp_cfg_len);
-
-		tas5805m->is_powered = true;
-		tas5805m_refresh(component);
+		dev_dbg(component->dev, "clock start\n");
+		schedule_work(&tas5805m->work);
 		break;
 
 	case SNDRV_PCM_TRIGGER_STOP:
 	case SNDRV_PCM_TRIGGER_SUSPEND:
 	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
-		dev_dbg(component->dev, "DSP shutdown\n");
+		break;
 
-		tas5805m->is_powered = false;
+	default:
+		return -EINVAL;
+	}
 
-		regmap_write(rm, REG_PAGE, 0x00);
-		regmap_write(rm, REG_BOOK, 0x00);
+	return 0;
+}
 
-		regmap_read(rm, REG_CHAN_FAULT, &chan);
-		regmap_read(rm, REG_GLOBAL_FAULT1, &global1);
-		regmap_read(rm, REG_GLOBAL_FAULT2, &global2);
+static void do_work(struct work_struct *work)
+{
+	struct tas5805m_priv *tas5805m =
+	       container_of(work, struct tas5805m_priv, work);
+	struct regmap *rm = tas5805m->regmap;
 
-		dev_dbg(component->dev,
-			"fault regs: CHAN=%02x, GLOBAL1=%02x, GLOBAL2=%02x\n",
-			chan, global1, global2);
+	dev_dbg(&tas5805m->i2c->dev, "DSP startup\n");
 
-		regmap_write(rm, REG_DEVICE_CTRL_2, DCTRL2_MODE_HIZ);
-		break;
+	mutex_lock(&tas5805m->lock);
+	/* We mustn't issue any I2C transactions until the I2S
+	 * clock is stable. Furthermore, we must allow a 5ms
+	 * delay after the first set of register writes to
+	 * allow the DSP to boot before configuring it.
+	 */
+	usleep_range(5000, 10000);
+	send_cfg(rm, dsp_cfg_preboot, ARRAY_SIZE(dsp_cfg_preboot));
+	usleep_range(5000, 15000);
+	send_cfg(rm, tas5805m->dsp_cfg_data, tas5805m->dsp_cfg_len);
+
+	tas5805m->is_powered = true;
+	tas5805m_refresh(tas5805m);
+	mutex_unlock(&tas5805m->lock);
+}
 
-	default:
-		return -EINVAL;
+static int tas5805m_dac_event(struct snd_soc_dapm_widget *w,
+			      struct snd_kcontrol *kcontrol, int event)
+{
+	struct snd_soc_component *component = snd_soc_dapm_to_component(w->dapm);
+	struct tas5805m_priv *tas5805m =
+		snd_soc_component_get_drvdata(component);
+	struct regmap *rm = tas5805m->regmap;
+
+	if (event & SND_SOC_DAPM_PRE_PMD) {
+		unsigned int chan, global1, global2;
+
+		dev_dbg(component->dev, "DSP shutdown\n");
+		cancel_work_sync(&tas5805m->work);
+
+		mutex_lock(&tas5805m->lock);
+		if (tas5805m->is_powered) {
+			tas5805m->is_powered = false;
+
+			regmap_write(rm, REG_PAGE, 0x00);
+			regmap_write(rm, REG_BOOK, 0x00);
+
+			regmap_read(rm, REG_CHAN_FAULT, &chan);
+			regmap_read(rm, REG_GLOBAL_FAULT1, &global1);
+			regmap_read(rm, REG_GLOBAL_FAULT2, &global2);
+
+			dev_dbg(component->dev, "fault regs: CHAN=%02x, "
+				"GLOBAL1=%02x, GLOBAL2=%02x\n",
+				chan, global1, global2);
+
+			regmap_write(rm, REG_DEVICE_CTRL_2, DCTRL2_MODE_HIZ);
+		}
+		mutex_unlock(&tas5805m->lock);
 	}
 
 	return 0;
@@ -354,7 +394,8 @@ static const struct snd_soc_dapm_route tas5805m_audio_map[] = {
 
 static const struct snd_soc_dapm_widget tas5805m_dapm_widgets[] = {
 	SND_SOC_DAPM_AIF_IN("DAC IN", "Playback", 0, SND_SOC_NOPM, 0, 0),
-	SND_SOC_DAPM_DAC("DAC", NULL, SND_SOC_NOPM, 0, 0),
+	SND_SOC_DAPM_DAC_E("DAC", NULL, SND_SOC_NOPM, 0, 0,
+		tas5805m_dac_event, SND_SOC_DAPM_PRE_PMD),
 	SND_SOC_DAPM_OUTPUT("OUT")
 };
 
@@ -375,11 +416,14 @@ static int tas5805m_mute(struct snd_soc_dai *dai, int mute, int direction)
 	struct tas5805m_priv *tas5805m =
 		snd_soc_component_get_drvdata(component);
 
+	mutex_lock(&tas5805m->lock);
 	dev_dbg(component->dev, "set mute=%d (is_powered=%d)\n",
 		mute, tas5805m->is_powered);
+
 	tas5805m->is_muted = mute;
 	if (tas5805m->is_powered)
-		tas5805m_refresh(component);
+		tas5805m_refresh(tas5805m);
+	mutex_unlock(&tas5805m->lock);
 
 	return 0;
 }
@@ -434,6 +478,7 @@ static int tas5805m_i2c_probe(struct i2c_client *i2c)
 	if (!tas5805m)
 		return -ENOMEM;
 
+	tas5805m->i2c = i2c;
 	tas5805m->pvdd = devm_regulator_get(dev, "pvdd");
 	if (IS_ERR(tas5805m->pvdd)) {
 		dev_err(dev, "failed to get pvdd supply: %ld\n",
@@ -507,6 +552,9 @@ static int tas5805m_i2c_probe(struct i2c_client *i2c)
 	gpiod_set_value(tas5805m->gpio_pdn_n, 1);
 	usleep_range(10000, 15000);
 
+	INIT_WORK(&tas5805m->work, do_work);
+	mutex_init(&tas5805m->lock);
+
 	/* Don't register through devm. We need to be able to unregister
 	 * the component prior to deasserting PDN#
 	 */
@@ -527,6 +575,7 @@ static void tas5805m_i2c_remove(struct i2c_client *i2c)
 	struct device *dev = &i2c->dev;
 	struct tas5805m_priv *tas5805m = dev_get_drvdata(dev);
 
+	cancel_work_sync(&tas5805m->work);
 	snd_soc_unregister_component(dev);
 	gpiod_set_value(tas5805m->gpio_pdn_n, 0);
 	usleep_range(10000, 15000);
diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
index e60c7b344562..8205b3217149 100644
--- a/sound/soc/fsl/fsl_sai.c
+++ b/sound/soc/fsl/fsl_sai.c
@@ -1141,6 +1141,7 @@ static int fsl_sai_check_version(struct device *dev)
 
 	sai->verid.version = val &
 		(FSL_SAI_VERID_MAJOR_MASK | FSL_SAI_VERID_MINOR_MASK);
+	sai->verid.version >>= FSL_SAI_VERID_MINOR_SHIFT;
 	sai->verid.feature = val & FSL_SAI_VERID_FEATURE_MASK;
 
 	ret = regmap_read(sai->regmap, FSL_SAI_PARAM, &val);
diff --git a/sound/soc/soc-topology.c b/sound/soc/soc-topology.c
index c3be24b2fac5..a79a2fb260b8 100644
--- a/sound/soc/soc-topology.c
+++ b/sound/soc/soc-topology.c
@@ -1401,13 +1401,17 @@ static int soc_tplg_dapm_widget_create(struct soc_tplg *tplg,
 
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
 
 	for (i = 0; i < le32_to_cpu(w->num_kcontrols); i++) {
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
index 3ffb9d6c0950..f4721f1b2886 100755
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -906,14 +906,14 @@ sysctl_set()
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
diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index 2eeaf4aca644..76a197f7b813 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -472,6 +472,12 @@ kill_wait()
 	wait $1 2>/dev/null
 }
 
+kill_tests_wait()
+{
+	kill -SIGUSR1 $(ip netns pids $ns2) $(ip netns pids $ns1)
+	wait
+}
+
 pm_nl_set_limits()
 {
 	local ns=$1
@@ -1688,6 +1694,7 @@ chk_subflow_nr()
 	local subflow_nr=$3
 	local cnt1
 	local cnt2
+	local dump_stats
 
 	if [ -n "${need_title}" ]; then
 		printf "%03u %-36s %s" "${TEST_COUNT}" "${TEST_NAME}" "${msg}"
@@ -1705,7 +1712,12 @@ chk_subflow_nr()
 		echo "[ ok ]"
 	fi
 
-	[ "${dump_stats}" = 1 ] && ( ss -N $ns1 -tOni ; ss -N $ns1 -tOni | grep token; ip -n $ns1 mptcp endpoint )
+	if [ "${dump_stats}" = 1 ]; then
+		ss -N $ns1 -tOni
+		ss -N $ns1 -tOni | grep token
+		ip -n $ns1 mptcp endpoint
+		dump_stats
+	fi
 }
 
 chk_link_usage()
@@ -2985,7 +2997,7 @@ endpoint_tests()
 		pm_nl_set_limits $ns1 2 2
 		pm_nl_set_limits $ns2 2 2
 		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
-		run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow &
+		run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow 2>/dev/null &
 
 		wait_mpj $ns1
 		pm_nl_check_endpoint 1 "creation" \
@@ -2998,14 +3010,14 @@ endpoint_tests()
 		pm_nl_add_endpoint $ns2 10.0.2.2 flags signal
 		pm_nl_check_endpoint 0 "modif is allowed" \
 			$ns2 10.0.2.2 id 1 flags signal
-		wait
+		kill_tests_wait
 	fi
 
 	if reset "delete and re-add"; then
 		pm_nl_set_limits $ns1 1 1
 		pm_nl_set_limits $ns2 1 1
 		pm_nl_add_endpoint $ns2 10.0.2.2 id 2 dev ns2eth2 flags subflow
-		run_tests $ns1 $ns2 10.0.1.1 4 0 0 slow &
+		run_tests $ns1 $ns2 10.0.1.1 4 0 0 speed_20 2>/dev/null &
 
 		wait_mpj $ns2
 		pm_nl_del_endpoint $ns2 2 10.0.2.2
@@ -3015,7 +3027,7 @@ endpoint_tests()
 		pm_nl_add_endpoint $ns2 10.0.2.2 dev ns2eth2 flags subflow
 		wait_mpj $ns2
 		chk_subflow_nr "" "after re-add" 2
-		wait
+		kill_tests_wait
 	fi
 }
 
diff --git a/tools/testing/selftests/net/test_vxlan_vnifiltering.sh b/tools/testing/selftests/net/test_vxlan_vnifiltering.sh
index 704997ffc244..8c3ac0a72545 100755
--- a/tools/testing/selftests/net/test_vxlan_vnifiltering.sh
+++ b/tools/testing/selftests/net/test_vxlan_vnifiltering.sh
@@ -293,19 +293,11 @@ setup-vm() {
 	elif [[ -n $vtype && $vtype == "vnifilterg" ]]; then
 	   # Add per vni group config with 'bridge vni' api
 	   if [ -n "$group" ]; then
-	      if [ "$family" == "v4" ]; then
-		 if [ $mcast -eq 1 ]; then
-		    bridge -netns hv-$hvid vni add dev $vxlandev vni $tid group $group
-		 else
-		    bridge -netns hv-$hvid vni add dev $vxlandev vni $tid remote $group
-		 fi
-	      else
-		 if [ $mcast -eq 1 ]; then
-		    bridge -netns hv-$hvid vni add dev $vxlandev vni $tid group6 $group
-		 else
-		    bridge -netns hv-$hvid vni add dev $vxlandev vni $tid remote6 $group
-		 fi
-	      fi
+		if [ $mcast -eq 1 ]; then
+			bridge -netns hv-$hvid vni add dev $vxlandev vni $tid group $group
+		else
+			bridge -netns hv-$hvid vni add dev $vxlandev vni $tid remote $group
+		fi
 	   fi
 	fi
 	done
