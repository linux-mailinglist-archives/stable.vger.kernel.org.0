Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9942E5A0D1C
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 11:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240854AbiHYJuN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Aug 2022 05:50:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240881AbiHYJsK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Aug 2022 05:48:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF252ABF06;
        Thu, 25 Aug 2022 02:47:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 894A660A14;
        Thu, 25 Aug 2022 09:47:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86D69C433B5;
        Thu, 25 Aug 2022 09:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661420875;
        bh=m9BLK22MT7V/N9ETMc7oRvo3Es7buGuWev39GB+D7a0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wJC6e9wsHceXM3rCKwmZ2QmECqmgumJSWJ9stwARdxSjB4pGuYBVhcCXv7Rep5ORa
         0LTYYLBuVlDzayu3rMxz+LQ02lYfGMCgbAzyUd7Z+aZ7qJsj2UZs6QLuMDMDtIEc8z
         I7He/Z/ggSClUmQCbV9hpGlDDpLTmQEkajxllIFQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.15.63
Date:   Thu, 25 Aug 2022 11:47:41 +0200
Message-Id: <1661420860146164@kroah.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <1661420860207244@kroah.com>
References: <1661420860207244@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Documentation/atomic_bitops.txt b/Documentation/atomic_bitops.txt
index 093cdaefdb37..d8b101c97031 100644
--- a/Documentation/atomic_bitops.txt
+++ b/Documentation/atomic_bitops.txt
@@ -59,7 +59,7 @@ Like with atomic_t, the rule of thumb is:
  - RMW operations that have a return value are fully ordered.
 
  - RMW operations that are conditional are unordered on FAILURE,
-   otherwise the above rules apply. In the case of test_and_{}_bit() operations,
+   otherwise the above rules apply. In the case of test_and_set_bit_lock(),
    if the bit in memory is unchanged by the operation then it is deemed to have
    failed.
 
diff --git a/Documentation/devicetree/bindings/arm/qcom.yaml b/Documentation/devicetree/bindings/arm/qcom.yaml
index 880ddafc634e..a702a18d845e 100644
--- a/Documentation/devicetree/bindings/arm/qcom.yaml
+++ b/Documentation/devicetree/bindings/arm/qcom.yaml
@@ -135,28 +135,34 @@ properties:
           - const: qcom,msm8974
 
       - items:
-          - enum:
-              - alcatel,idol347
-          - const: qcom,msm8916-mtp/1
           - const: qcom,msm8916-mtp
+          - const: qcom,msm8916-mtp/1
           - const: qcom,msm8916
 
       - items:
           - enum:
-              - longcheer,l8150
+              - alcatel,idol347
               - samsung,a3u-eur
               - samsung,a5u-eur
           - const: qcom,msm8916
 
+      - items:
+          - const: longcheer,l8150
+          - const: qcom,msm8916-v1-qrd/9-v1
+          - const: qcom,msm8916
+
       - items:
           - enum:
               - sony,karin_windy
+          - const: qcom,apq8094
+
+      - items:
+          - enum:
               - sony,karin-row
               - sony,satsuki-row
               - sony,sumire-row
               - sony,suzuran-row
-              - qcom,msm8994
-          - const: qcom,apq8094
+          - const: qcom,msm8994
 
       - items:
           - const: qcom,msm8996-mtp
diff --git a/Documentation/devicetree/bindings/clock/qcom,gcc-msm8996.yaml b/Documentation/devicetree/bindings/clock/qcom,gcc-msm8996.yaml
index 5a5b2214f0ca..005e0edd4609 100644
--- a/Documentation/devicetree/bindings/clock/qcom,gcc-msm8996.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,gcc-msm8996.yaml
@@ -22,16 +22,32 @@ properties:
     const: qcom,gcc-msm8996
 
   clocks:
+    minItems: 3
     items:
       - description: XO source
       - description: Second XO source
       - description: Sleep clock source
+      - description: PCIe 0 PIPE clock (optional)
+      - description: PCIe 1 PIPE clock (optional)
+      - description: PCIe 2 PIPE clock (optional)
+      - description: USB3 PIPE clock (optional)
+      - description: UFS RX symbol 0 clock (optional)
+      - description: UFS RX symbol 1 clock (optional)
+      - description: UFS TX symbol 0 clock (optional)
 
   clock-names:
+    minItems: 3
     items:
       - const: cxo
       - const: cxo2
       - const: sleep_clk
+      - const: pcie_0_pipe_clk_src
+      - const: pcie_1_pipe_clk_src
+      - const: pcie_2_pipe_clk_src
+      - const: usb3_phy_pipe_clk_src
+      - const: ufs_rx_symbol_0_clk_src
+      - const: ufs_rx_symbol_1_clk_src
+      - const: ufs_tx_symbol_0_clk_src
 
   '#clock-cells':
     const: 1
diff --git a/Documentation/devicetree/bindings/gpio/gpio-zynq.yaml b/Documentation/devicetree/bindings/gpio/gpio-zynq.yaml
index 378da2649e66..980f92ad9eba 100644
--- a/Documentation/devicetree/bindings/gpio/gpio-zynq.yaml
+++ b/Documentation/devicetree/bindings/gpio/gpio-zynq.yaml
@@ -11,7 +11,11 @@ maintainers:
 
 properties:
   compatible:
-    const: xlnx,zynq-gpio-1.0
+    enum:
+      - xlnx,zynq-gpio-1.0
+      - xlnx,zynqmp-gpio-1.0
+      - xlnx,versal-gpio-1.0
+      - xlnx,pmc-gpio-1.0
 
   reg:
     maxItems: 1
diff --git a/Documentation/devicetree/bindings/regulator/nxp,pca9450-regulator.yaml b/Documentation/devicetree/bindings/regulator/nxp,pca9450-regulator.yaml
index f70f2e758a00..e66aac0ad735 100644
--- a/Documentation/devicetree/bindings/regulator/nxp,pca9450-regulator.yaml
+++ b/Documentation/devicetree/bindings/regulator/nxp,pca9450-regulator.yaml
@@ -47,12 +47,6 @@ properties:
         description:
           Properties for single LDO regulator.
 
-        properties:
-          regulator-name:
-            pattern: "^LDO[1-5]$"
-            description:
-              should be "LDO1", ..., "LDO5"
-
         unevaluatedProperties: false
 
       "^BUCK[1-6]$":
@@ -62,11 +56,6 @@ properties:
           Properties for single BUCK regulator.
 
         properties:
-          regulator-name:
-            pattern: "^BUCK[1-6]$"
-            description:
-              should be "BUCK1", ..., "BUCK6"
-
           nxp,dvs-run-voltage:
             $ref: "/schemas/types.yaml#/definitions/uint32"
             minimum: 600000
diff --git a/Documentation/devicetree/bindings/spi/spi-cadence.yaml b/Documentation/devicetree/bindings/spi/spi-cadence.yaml
index 9787be21318e..82d0ca5c00f3 100644
--- a/Documentation/devicetree/bindings/spi/spi-cadence.yaml
+++ b/Documentation/devicetree/bindings/spi/spi-cadence.yaml
@@ -49,6 +49,13 @@ properties:
     enum: [ 0, 1 ]
     default: 0
 
+required:
+  - compatible
+  - reg
+  - interrupts
+  - clock-names
+  - clocks
+
 unevaluatedProperties: false
 
 examples:
diff --git a/Documentation/devicetree/bindings/spi/spi-zynqmp-qspi.yaml b/Documentation/devicetree/bindings/spi/spi-zynqmp-qspi.yaml
index ea72c8001256..fafde1c06be6 100644
--- a/Documentation/devicetree/bindings/spi/spi-zynqmp-qspi.yaml
+++ b/Documentation/devicetree/bindings/spi/spi-zynqmp-qspi.yaml
@@ -30,6 +30,13 @@ properties:
   clocks:
     maxItems: 2
 
+required:
+  - compatible
+  - reg
+  - interrupts
+  - clock-names
+  - clocks
+
 unevaluatedProperties: false
 
 examples:
diff --git a/Documentation/devicetree/bindings/usb/mediatek,mtk-xhci.yaml b/Documentation/devicetree/bindings/usb/mediatek,mtk-xhci.yaml
index 11f7bacd4e2b..620cbf00bedb 100644
--- a/Documentation/devicetree/bindings/usb/mediatek,mtk-xhci.yaml
+++ b/Documentation/devicetree/bindings/usb/mediatek,mtk-xhci.yaml
@@ -56,6 +56,7 @@ properties:
       - description: optional, wakeup interrupt used to support runtime PM
 
   interrupt-names:
+    minItems: 1
     items:
       - const: host
       - const: wakeup
diff --git a/Documentation/firmware-guide/acpi/apei/einj.rst b/Documentation/firmware-guide/acpi/apei/einj.rst
index c042176e1707..50ac87fa2295 100644
--- a/Documentation/firmware-guide/acpi/apei/einj.rst
+++ b/Documentation/firmware-guide/acpi/apei/einj.rst
@@ -168,7 +168,7 @@ An error injection example::
   0x00000008	Memory Correctable
   0x00000010	Memory Uncorrectable non-fatal
   # echo 0x12345000 > param1		# Set memory address for injection
-  # echo $((-1 << 12)) > param2		# Mask 0xfffffffffffff000 - anywhere in this page
+  # echo 0xfffffffffffff000 > param2		# Mask - anywhere in this page
   # echo 0x8 > error_type			# Choose correctable memory error
   # echo 1 > error_inject			# Inject now
 
diff --git a/Makefile b/Makefile
index 5b4f8f8851bf..ea669530ec86 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 15
-SUBLEVEL = 62
+SUBLEVEL = 63
 EXTRAVERSION =
 NAME = Trick or Treat
 
@@ -1155,13 +1155,11 @@ vmlinux-alldirs	:= $(sort $(vmlinux-dirs) Documentation \
 		     $(patsubst %/,%,$(filter %/, $(core-) \
 			$(drivers-) $(libs-))))
 
-subdir-modorder := $(addsuffix modules.order,$(filter %/, \
-			$(core-y) $(core-m) $(libs-y) $(libs-m) \
-			$(drivers-y) $(drivers-m)))
-
 build-dirs	:= $(vmlinux-dirs)
 clean-dirs	:= $(vmlinux-alldirs)
 
+subdir-modorder := $(addsuffix /modules.order, $(build-dirs))
+
 # Externally visible symbols (used by link-vmlinux.sh)
 KBUILD_VMLINUX_OBJS := $(head-y) $(patsubst %/,%/built-in.a, $(core-y))
 KBUILD_VMLINUX_OBJS += $(addsuffix built-in.a, $(filter %/, $(libs-y)))
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index fc6ee6c5972d..1713630bf8f5 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -795,6 +795,10 @@ bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
 #define kvm_vcpu_has_pmu(vcpu)					\
 	(test_bit(KVM_ARM_VCPU_PMU_V3, (vcpu)->arch.features))
 
+#define kvm_supports_32bit_el0()				\
+	(system_supports_32bit_el0() &&				\
+	 !static_branch_unlikely(&arm64_mismatched_32bit_el0))
+
 int kvm_trng_call(struct kvm_vcpu *vcpu);
 #ifdef CONFIG_KVM
 extern phys_addr_t hyp_mem_base;
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index f181527f9d43..4cb265e15361 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -712,8 +712,7 @@ static bool vcpu_mode_is_bad_32bit(struct kvm_vcpu *vcpu)
 	if (likely(!vcpu_mode_is_32bit(vcpu)))
 		return false;
 
-	return !system_supports_32bit_el0() ||
-		static_branch_unlikely(&arm64_mismatched_32bit_el0);
+	return !kvm_supports_32bit_el0();
 }
 
 /**
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 5ce26bedf23c..94108e2e0917 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -242,7 +242,7 @@ static int set_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 		u64 mode = (*(u64 *)valp) & PSR_AA32_MODE_MASK;
 		switch (mode) {
 		case PSR_AA32_MODE_USR:
-			if (!system_supports_32bit_el0())
+			if (!kvm_supports_32bit_el0())
 				return -EINVAL;
 			break;
 		case PSR_AA32_MODE_FIQ:
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 7c18e429b449..c11612db4a37 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -649,7 +649,7 @@ static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 	 */
 	val = ((pmcr & ~ARMV8_PMU_PMCR_MASK)
 	       | (ARMV8_PMU_PMCR_MASK & 0xdecafbad)) & (~ARMV8_PMU_PMCR_E);
-	if (!system_supports_32bit_el0())
+	if (!kvm_supports_32bit_el0())
 		val |= ARMV8_PMU_PMCR_LC;
 	__vcpu_sys_reg(vcpu, r->reg) = val;
 }
@@ -698,7 +698,7 @@ static bool access_pmcr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 		val = __vcpu_sys_reg(vcpu, PMCR_EL0);
 		val &= ~ARMV8_PMU_PMCR_MASK;
 		val |= p->regval & ARMV8_PMU_PMCR_MASK;
-		if (!system_supports_32bit_el0())
+		if (!kvm_supports_32bit_el0())
 			val |= ARMV8_PMU_PMCR_LC;
 		__vcpu_sys_reg(vcpu, PMCR_EL0) = val;
 		kvm_pmu_handle_pmcr(vcpu, val);
diff --git a/arch/csky/kernel/probes/kprobes.c b/arch/csky/kernel/probes/kprobes.c
index 4045894d9280..584ed9f36290 100644
--- a/arch/csky/kernel/probes/kprobes.c
+++ b/arch/csky/kernel/probes/kprobes.c
@@ -124,6 +124,10 @@ void __kprobes arch_disarm_kprobe(struct kprobe *p)
 
 void __kprobes arch_remove_kprobe(struct kprobe *p)
 {
+	if (p->ainsn.api.insn) {
+		free_insn_slot(p->ainsn.api.insn, 0);
+		p->ainsn.api.insn = NULL;
+	}
 }
 
 static void __kprobes save_previous_kprobe(struct kprobe_ctlblk *kcb)
diff --git a/arch/m68k/coldfire/device.c b/arch/m68k/coldfire/device.c
index 4218750414bb..7dab46728aed 100644
--- a/arch/m68k/coldfire/device.c
+++ b/arch/m68k/coldfire/device.c
@@ -581,7 +581,7 @@ static struct platform_device mcf_esdhc = {
 };
 #endif /* MCFSDHC_BASE */
 
-#if IS_ENABLED(CONFIG_CAN_FLEXCAN)
+#ifdef MCFFLEXCAN_SIZE
 
 #include <linux/can/platform/flexcan.h>
 
@@ -620,7 +620,7 @@ static struct platform_device mcf_flexcan0 = {
 	.resource = mcf5441x_flexcan0_resource,
 	.dev.platform_data = &mcf5441x_flexcan_info,
 };
-#endif /* IS_ENABLED(CONFIG_CAN_FLEXCAN) */
+#endif /* MCFFLEXCAN_SIZE */
 
 static struct platform_device *mcf_devices[] __initdata = {
 	&mcf_uart,
@@ -657,7 +657,7 @@ static struct platform_device *mcf_devices[] __initdata = {
 #ifdef MCFSDHC_BASE
 	&mcf_esdhc,
 #endif
-#if IS_ENABLED(CONFIG_CAN_FLEXCAN)
+#ifdef MCFFLEXCAN_SIZE
 	&mcf_flexcan0,
 #endif
 };
diff --git a/arch/mips/cavium-octeon/octeon-platform.c b/arch/mips/cavium-octeon/octeon-platform.c
index a994022e32c9..ce05c0dd3acd 100644
--- a/arch/mips/cavium-octeon/octeon-platform.c
+++ b/arch/mips/cavium-octeon/octeon-platform.c
@@ -86,11 +86,12 @@ static void octeon2_usb_clocks_start(struct device *dev)
 					 "refclk-frequency", &clock_rate);
 		if (i) {
 			dev_err(dev, "No UCTL \"refclk-frequency\"\n");
+			of_node_put(uctl_node);
 			goto exit;
 		}
 		i = of_property_read_string(uctl_node,
 					    "refclk-type", &clock_type);
-
+		of_node_put(uctl_node);
 		if (!i && strcmp("crystal", clock_type) == 0)
 			is_crystal_clock = true;
 	}
diff --git a/arch/mips/mm/tlbex.c b/arch/mips/mm/tlbex.c
index 046d51a454af..3471a089bc05 100644
--- a/arch/mips/mm/tlbex.c
+++ b/arch/mips/mm/tlbex.c
@@ -634,7 +634,7 @@ static __maybe_unused void build_convert_pte_to_entrylo(u32 **p,
 		return;
 	}
 
-	if (cpu_has_rixi && !!_PAGE_NO_EXEC) {
+	if (cpu_has_rixi && _PAGE_NO_EXEC != 0) {
 		if (fill_includes_sw_bits) {
 			UASM_i_ROTR(p, reg, reg, ilog2(_PAGE_GLOBAL));
 		} else {
@@ -2573,7 +2573,7 @@ static void check_pabits(void)
 	unsigned long entry;
 	unsigned pabits, fillbits;
 
-	if (!cpu_has_rixi || !_PAGE_NO_EXEC) {
+	if (!cpu_has_rixi || _PAGE_NO_EXEC == 0) {
 		/*
 		 * We'll only be making use of the fact that we can rotate bits
 		 * into the fill if the CPU supports RIXI, so don't bother
diff --git a/arch/nios2/include/asm/entry.h b/arch/nios2/include/asm/entry.h
index cf37f55efbc2..bafb7b2ca59f 100644
--- a/arch/nios2/include/asm/entry.h
+++ b/arch/nios2/include/asm/entry.h
@@ -50,7 +50,8 @@
 	stw	r13, PT_R13(sp)
 	stw	r14, PT_R14(sp)
 	stw	r15, PT_R15(sp)
-	stw	r2, PT_ORIG_R2(sp)
+	movi	r24, -1
+	stw	r24, PT_ORIG_R2(sp)
 	stw	r7, PT_ORIG_R7(sp)
 
 	stw	ra, PT_RA(sp)
diff --git a/arch/nios2/include/asm/ptrace.h b/arch/nios2/include/asm/ptrace.h
index 642462144872..9da34c3022a2 100644
--- a/arch/nios2/include/asm/ptrace.h
+++ b/arch/nios2/include/asm/ptrace.h
@@ -74,6 +74,8 @@ extern void show_regs(struct pt_regs *);
 	((struct pt_regs *)((unsigned long)current_thread_info() + THREAD_SIZE)\
 		- 1)
 
+#define force_successful_syscall_return() (current_pt_regs()->orig_r2 = -1)
+
 int do_syscall_trace_enter(void);
 void do_syscall_trace_exit(void);
 #endif /* __ASSEMBLY__ */
diff --git a/arch/nios2/kernel/entry.S b/arch/nios2/kernel/entry.S
index 0794cd7803df..99f0a65e6234 100644
--- a/arch/nios2/kernel/entry.S
+++ b/arch/nios2/kernel/entry.S
@@ -185,6 +185,7 @@ ENTRY(handle_system_call)
 	ldw	r5, PT_R5(sp)
 
 local_restart:
+	stw	r2, PT_ORIG_R2(sp)
 	/* Check that the requested system call is within limits */
 	movui	r1, __NR_syscalls
 	bgeu	r2, r1, ret_invsyscall
@@ -192,7 +193,6 @@ local_restart:
 	movhi	r11, %hiadj(sys_call_table)
 	add	r1, r1, r11
 	ldw	r1, %lo(sys_call_table)(r1)
-	beq	r1, r0, ret_invsyscall
 
 	/* Check if we are being traced */
 	GET_THREAD_INFO r11
@@ -213,6 +213,9 @@ local_restart:
 translate_rc_and_ret:
 	movi	r1, 0
 	bge	r2, zero, 3f
+	ldw	r1, PT_ORIG_R2(sp)
+	addi	r1, r1, 1
+	beq	r1, zero, 3f
 	sub	r2, zero, r2
 	movi	r1, 1
 3:
@@ -255,9 +258,9 @@ traced_system_call:
 	ldw	r6, PT_R6(sp)
 	ldw	r7, PT_R7(sp)
 
-	/* Fetch the syscall function, we don't need to check the boundaries
-	 * since this is already done.
-	 */
+	/* Fetch the syscall function. */
+	movui	r1, __NR_syscalls
+	bgeu	r2, r1, traced_invsyscall
 	slli	r1, r2, 2
 	movhi	r11,%hiadj(sys_call_table)
 	add	r1, r1, r11
@@ -276,6 +279,9 @@ traced_system_call:
 translate_rc_and_ret2:
 	movi	r1, 0
 	bge	r2, zero, 4f
+	ldw	r1, PT_ORIG_R2(sp)
+	addi	r1, r1, 1
+	beq	r1, zero, 4f
 	sub	r2, zero, r2
 	movi	r1, 1
 4:
@@ -287,6 +293,11 @@ end_translate_rc_and_ret2:
 	RESTORE_SWITCH_STACK
 	br	ret_from_exception
 
+	/* If the syscall number was invalid return ENOSYS */
+traced_invsyscall:
+	movi	r2, -ENOSYS
+	br	translate_rc_and_ret2
+
 Luser_return:
 	GET_THREAD_INFO	r11			/* get thread_info pointer */
 	ldw	r10, TI_FLAGS(r11)		/* get thread_info->flags */
@@ -336,9 +347,6 @@ external_interrupt:
 	/* skip if no interrupt is pending */
 	beq	r12, r0, ret_from_interrupt
 
-	movi	r24, -1
-	stw	r24, PT_ORIG_R2(sp)
-
 	/*
 	 * Process an external hardware interrupt.
 	 */
diff --git a/arch/nios2/kernel/signal.c b/arch/nios2/kernel/signal.c
index 386e46443b60..68d626c4f1ba 100644
--- a/arch/nios2/kernel/signal.c
+++ b/arch/nios2/kernel/signal.c
@@ -242,7 +242,7 @@ static int do_signal(struct pt_regs *regs)
 	/*
 	 * If we were from a system call, check for system call restarting...
 	 */
-	if (regs->orig_r2 >= 0) {
+	if (regs->orig_r2 >= 0 && regs->r1) {
 		continue_addr = regs->ea;
 		restart_addr = continue_addr - 4;
 		retval = regs->r2;
@@ -264,6 +264,7 @@ static int do_signal(struct pt_regs *regs)
 			regs->ea = restart_addr;
 			break;
 		}
+		regs->orig_r2 = -1;
 	}
 
 	if (get_signal(&ksig)) {
diff --git a/arch/nios2/kernel/syscall_table.c b/arch/nios2/kernel/syscall_table.c
index 6176d63023c1..c2875a6dd5a4 100644
--- a/arch/nios2/kernel/syscall_table.c
+++ b/arch/nios2/kernel/syscall_table.c
@@ -13,5 +13,6 @@
 #define __SYSCALL(nr, call) [nr] = (call),
 
 void *sys_call_table[__NR_syscalls] = {
+	[0 ... __NR_syscalls-1] = sys_ni_syscall,
 #include <asm/unistd.h>
 };
diff --git a/arch/openrisc/include/asm/io.h b/arch/openrisc/include/asm/io.h
index c298061c70a7..8aa3e78181e9 100644
--- a/arch/openrisc/include/asm/io.h
+++ b/arch/openrisc/include/asm/io.h
@@ -31,7 +31,7 @@
 void __iomem *ioremap(phys_addr_t offset, unsigned long size);
 
 #define iounmap iounmap
-extern void iounmap(void __iomem *addr);
+extern void iounmap(volatile void __iomem *addr);
 
 #include <asm-generic/io.h>
 
diff --git a/arch/openrisc/mm/ioremap.c b/arch/openrisc/mm/ioremap.c
index daae13a76743..8ec0dafecf25 100644
--- a/arch/openrisc/mm/ioremap.c
+++ b/arch/openrisc/mm/ioremap.c
@@ -77,7 +77,7 @@ void __iomem *__ref ioremap(phys_addr_t addr, unsigned long size)
 }
 EXPORT_SYMBOL(ioremap);
 
-void iounmap(void __iomem *addr)
+void iounmap(volatile void __iomem *addr)
 {
 	/* If the page is from the fixmap pool then we just clear out
 	 * the fixmap mapping.
diff --git a/arch/powerpc/Makefile b/arch/powerpc/Makefile
index 72610e2d6176..2bb0fe9b2058 100644
--- a/arch/powerpc/Makefile
+++ b/arch/powerpc/Makefile
@@ -17,23 +17,6 @@ HAS_BIARCH	:= $(call cc-option-yn, -m32)
 # Set default 32 bits cross compilers for vdso and boot wrapper
 CROSS32_COMPILE ?=
 
-ifeq ($(HAS_BIARCH),y)
-ifeq ($(CROSS32_COMPILE),)
-ifdef CONFIG_PPC32
-# These options will be overridden by any -mcpu option that the CPU
-# or platform code sets later on the command line, but they are needed
-# to set a sane 32-bit cpu target for the 64-bit cross compiler which
-# may default to the wrong ISA.
-KBUILD_CFLAGS		+= -mcpu=powerpc
-KBUILD_AFLAGS		+= -mcpu=powerpc
-endif
-endif
-endif
-
-ifdef CONFIG_PPC_BOOK3S_32
-KBUILD_CFLAGS		+= -mcpu=powerpc
-endif
-
 # If we're on a ppc/ppc64/ppc64le machine use that defconfig, otherwise just use
 # ppc64_defconfig because we have nothing better to go on.
 uname := $(shell uname -m)
@@ -185,6 +168,7 @@ endif
 endif
 
 CFLAGS-$(CONFIG_TARGET_CPU_BOOL) += $(call cc-option,-mcpu=$(CONFIG_TARGET_CPU))
+AFLAGS-$(CONFIG_TARGET_CPU_BOOL) += $(call cc-option,-mcpu=$(CONFIG_TARGET_CPU))
 
 # Altivec option not allowed with e500mc64 in GCC.
 ifdef CONFIG_ALTIVEC
@@ -195,14 +179,6 @@ endif
 CFLAGS-$(CONFIG_E5500_CPU) += $(E5500_CPU)
 CFLAGS-$(CONFIG_E6500_CPU) += $(call cc-option,-mcpu=e6500,$(E5500_CPU))
 
-ifdef CONFIG_PPC32
-ifdef CONFIG_PPC_E500MC
-CFLAGS-y += $(call cc-option,-mcpu=e500mc,-mcpu=powerpc)
-else
-CFLAGS-$(CONFIG_E500) += $(call cc-option,-mcpu=8540 -msoft-float,-mcpu=powerpc)
-endif
-endif
-
 asinstr := $(call as-instr,lis 9$(comma)foo@high,-DHAVE_AS_ATHIGH=1)
 
 KBUILD_CPPFLAGS	+= -I $(srctree)/arch/$(ARCH) $(asinstr)
diff --git a/arch/powerpc/kernel/head_book3s_32.S b/arch/powerpc/kernel/head_book3s_32.S
index 2e2a8211b17b..68e5c0a7e99d 100644
--- a/arch/powerpc/kernel/head_book3s_32.S
+++ b/arch/powerpc/kernel/head_book3s_32.S
@@ -421,14 +421,14 @@ InstructionTLBMiss:
  */
 	/* Get PTE (linux-style) and check access */
 	mfspr	r3,SPRN_IMISS
-#if defined(CONFIG_MODULES) || defined(CONFIG_DEBUG_PAGEALLOC) || defined(CONFIG_KFENCE)
+#ifdef CONFIG_MODULES
 	lis	r1, TASK_SIZE@h		/* check if kernel address */
 	cmplw	0,r1,r3
 #endif
 	mfspr	r2, SPRN_SDR1
 	li	r1,_PAGE_PRESENT | _PAGE_ACCESSED | _PAGE_EXEC | _PAGE_USER
 	rlwinm	r2, r2, 28, 0xfffff000
-#if defined(CONFIG_MODULES) || defined(CONFIG_DEBUG_PAGEALLOC) || defined(CONFIG_KFENCE)
+#ifdef CONFIG_MODULES
 	bgt-	112f
 	lis	r2, (swapper_pg_dir - PAGE_OFFSET)@ha	/* if kernel address, use */
 	li	r1,_PAGE_PRESENT | _PAGE_ACCESSED | _PAGE_EXEC
diff --git a/arch/powerpc/kernel/pci-common.c b/arch/powerpc/kernel/pci-common.c
index fc5187c6559a..1aabb82b5f37 100644
--- a/arch/powerpc/kernel/pci-common.c
+++ b/arch/powerpc/kernel/pci-common.c
@@ -67,10 +67,6 @@ void set_pci_dma_ops(const struct dma_map_ops *dma_ops)
 	pci_dma_ops = dma_ops;
 }
 
-/*
- * This function should run under locking protection, specifically
- * hose_spinlock.
- */
 static int get_phb_number(struct device_node *dn)
 {
 	int ret, phb_id = -1;
@@ -107,15 +103,20 @@ static int get_phb_number(struct device_node *dn)
 	if (!ret)
 		phb_id = (int)(prop & (MAX_PHBS - 1));
 
+	spin_lock(&hose_spinlock);
+
 	/* We need to be sure to not use the same PHB number twice. */
 	if ((phb_id >= 0) && !test_and_set_bit(phb_id, phb_bitmap))
-		return phb_id;
+		goto out_unlock;
 
 	/* If everything fails then fallback to dynamic PHB numbering. */
 	phb_id = find_first_zero_bit(phb_bitmap, MAX_PHBS);
 	BUG_ON(phb_id >= MAX_PHBS);
 	set_bit(phb_id, phb_bitmap);
 
+out_unlock:
+	spin_unlock(&hose_spinlock);
+
 	return phb_id;
 }
 
@@ -126,10 +127,13 @@ struct pci_controller *pcibios_alloc_controller(struct device_node *dev)
 	phb = zalloc_maybe_bootmem(sizeof(struct pci_controller), GFP_KERNEL);
 	if (phb == NULL)
 		return NULL;
-	spin_lock(&hose_spinlock);
+
 	phb->global_number = get_phb_number(dev);
+
+	spin_lock(&hose_spinlock);
 	list_add_tail(&phb->list_node, &hose_list);
 	spin_unlock(&hose_spinlock);
+
 	phb->dn = dev;
 	phb->is_dynamic = slab_is_available();
 #ifdef CONFIG_PPC64
diff --git a/arch/powerpc/kernel/prom.c b/arch/powerpc/kernel/prom.c
index 2e67588f6f6e..86ffbabd26c6 100644
--- a/arch/powerpc/kernel/prom.c
+++ b/arch/powerpc/kernel/prom.c
@@ -751,6 +751,13 @@ void __init early_init_devtree(void *params)
 	of_scan_flat_dt(early_init_dt_scan_root, NULL);
 	of_scan_flat_dt(early_init_dt_scan_memory_ppc, NULL);
 
+	/*
+	 * As generic code authors expect to be able to use static keys
+	 * in early_param() handlers, we initialize the static keys just
+	 * before parsing early params (it's fine to call jump_label_init()
+	 * more than once).
+	 */
+	jump_label_init();
 	parse_early_param();
 
 	/* make sure we've parsed cmdline for mem= before this */
diff --git a/arch/powerpc/kvm/book3s_hv_p9_entry.c b/arch/powerpc/kvm/book3s_hv_p9_entry.c
index 961b3d70483c..a0e0c28408c0 100644
--- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
+++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
@@ -7,15 +7,6 @@
 #include <asm/ppc-opcode.h>
 
 #ifdef CONFIG_KVM_BOOK3S_HV_EXIT_TIMING
-static void __start_timing(struct kvm_vcpu *vcpu, struct kvmhv_tb_accumulator *next)
-{
-	struct kvmppc_vcore *vc = vcpu->arch.vcore;
-	u64 tb = mftb() - vc->tb_offset_applied;
-
-	vcpu->arch.cur_activity = next;
-	vcpu->arch.cur_tb_start = tb;
-}
-
 static void __accumulate_time(struct kvm_vcpu *vcpu, struct kvmhv_tb_accumulator *next)
 {
 	struct kvmppc_vcore *vc = vcpu->arch.vcore;
@@ -47,8 +38,8 @@ static void __accumulate_time(struct kvm_vcpu *vcpu, struct kvmhv_tb_accumulator
 	curr->seqcount = seq + 2;
 }
 
-#define start_timing(vcpu, next) __start_timing(vcpu, next)
-#define end_timing(vcpu) __start_timing(vcpu, NULL)
+#define start_timing(vcpu, next) __accumulate_time(vcpu, next)
+#define end_timing(vcpu) __accumulate_time(vcpu, NULL)
 #define accumulate_time(vcpu, next) __accumulate_time(vcpu, next)
 #else
 #define start_timing(vcpu, next) do {} while (0)
diff --git a/arch/powerpc/mm/book3s32/mmu.c b/arch/powerpc/mm/book3s32/mmu.c
index 203735caf691..bfca0afe9112 100644
--- a/arch/powerpc/mm/book3s32/mmu.c
+++ b/arch/powerpc/mm/book3s32/mmu.c
@@ -160,7 +160,10 @@ unsigned long __init mmu_mapin_ram(unsigned long base, unsigned long top)
 {
 	unsigned long done;
 	unsigned long border = (unsigned long)__init_begin - PAGE_OFFSET;
+	unsigned long size;
 
+	size = roundup_pow_of_two((unsigned long)_einittext - PAGE_OFFSET);
+	setibat(0, PAGE_OFFSET, 0, size, PAGE_KERNEL_X);
 
 	if (debug_pagealloc_enabled_or_kfence() || __map_without_bats) {
 		pr_debug_once("Read-Write memory mapped without BATs\n");
@@ -246,10 +249,9 @@ void mmu_mark_rodata_ro(void)
 }
 
 /*
- * Set up one of the I/D BAT (block address translation) register pairs.
+ * Set up one of the D BAT (block address translation) register pairs.
  * The parameters are not checked; in particular size must be a power
  * of 2 between 128k and 256M.
- * On 603+, only set IBAT when _PAGE_EXEC is set
  */
 void __init setbat(int index, unsigned long virt, phys_addr_t phys,
 		   unsigned int size, pgprot_t prot)
@@ -285,10 +287,6 @@ void __init setbat(int index, unsigned long virt, phys_addr_t phys,
 		/* G bit must be zero in IBATs */
 		flags &= ~_PAGE_EXEC;
 	}
-	if (flags & _PAGE_EXEC)
-		bat[0] = bat[1];
-	else
-		bat[0].batu = bat[0].batl = 0;
 
 	bat_addrs[index].start = virt;
 	bat_addrs[index].limit = virt + ((bl + 1) << 17) - 1;
diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
index 81f8c9634832..1b1e67ff9d21 100644
--- a/arch/powerpc/platforms/Kconfig.cputype
+++ b/arch/powerpc/platforms/Kconfig.cputype
@@ -137,9 +137,9 @@ config GENERIC_CPU
 	depends on PPC64 && CPU_LITTLE_ENDIAN
 	select ARCH_HAS_FAST_MULTIPLIER
 
-config GENERIC_CPU
+config POWERPC_CPU
 	bool "Generic 32 bits powerpc"
-	depends on PPC32 && !PPC_8xx
+	depends on PPC32 && !PPC_8xx && !PPC_85xx
 
 config CELL_CPU
 	bool "Cell Broadband Engine"
@@ -193,11 +193,23 @@ config G4_CPU
 	depends on PPC_BOOK3S_32
 	select ALTIVEC
 
+config E500_CPU
+	bool "e500 (8540)"
+	depends on PPC_85xx && !PPC_E500MC
+
+config E500MC_CPU
+	bool "e500mc"
+	depends on PPC_85xx && PPC_E500MC
+
+config TOOLCHAIN_DEFAULT_CPU
+	bool "Rely on the toolchain's implicit default CPU"
+	depends on PPC32
+
 endchoice
 
 config TARGET_CPU_BOOL
 	bool
-	default !GENERIC_CPU
+	default !GENERIC_CPU && !TOOLCHAIN_DEFAULT_CPU
 
 config TARGET_CPU
 	string
@@ -212,6 +224,9 @@ config TARGET_CPU
 	default "e300c2" if E300C2_CPU
 	default "e300c3" if E300C3_CPU
 	default "G4" if G4_CPU
+	default "8540" if E500_CPU
+	default "e500mc" if E500MC_CPU
+	default "powerpc" if POWERPC_CPU
 
 config PPC_BOOK3S
 	def_bool y
diff --git a/arch/powerpc/platforms/powernv/pci-ioda.c b/arch/powerpc/platforms/powernv/pci-ioda.c
index 3dd35c327d1c..624822a81019 100644
--- a/arch/powerpc/platforms/powernv/pci-ioda.c
+++ b/arch/powerpc/platforms/powernv/pci-ioda.c
@@ -1618,6 +1618,7 @@ static void pnv_pci_ioda1_setup_dma_pe(struct pnv_phb *phb,
 	tbl->it_ops = &pnv_ioda1_iommu_ops;
 	pe->table_group.tce32_start = tbl->it_offset << tbl->it_page_shift;
 	pe->table_group.tce32_size = tbl->it_size << tbl->it_page_shift;
+	tbl->it_index = (phb->hose->global_number << 16) | pe->pe_number;
 	if (!iommu_init_table(tbl, phb->hose->node, 0, 0))
 		panic("Failed to initialize iommu table");
 
@@ -1788,6 +1789,7 @@ static long pnv_pci_ioda2_setup_default_config(struct pnv_ioda_pe *pe)
 		res_end = min(window_size, SZ_4G) >> tbl->it_page_shift;
 	}
 
+	tbl->it_index = (pe->phb->hose->global_number << 16) | pe->pe_number;
 	if (iommu_init_table(tbl, pe->phb->hose->node, res_start, res_end))
 		rc = pnv_pci_ioda2_set_window(&pe->table_group, 0, tbl);
 	else
diff --git a/arch/riscv/boot/dts/canaan/k210.dtsi b/arch/riscv/boot/dts/canaan/k210.dtsi
index 780416d489aa..fa9162e3afa3 100644
--- a/arch/riscv/boot/dts/canaan/k210.dtsi
+++ b/arch/riscv/boot/dts/canaan/k210.dtsi
@@ -65,6 +65,18 @@ cpu1_intc: interrupt-controller {
 				compatible = "riscv,cpu-intc";
 			};
 		};
+
+		cpu-map {
+			cluster0 {
+				core0 {
+					cpu = <&cpu0>;
+				};
+
+				core1 {
+					cpu = <&cpu1>;
+				};
+			};
+		};
 	};
 
 	sram: memory@80000000 {
diff --git a/arch/riscv/boot/dts/sifive/fu740-c000.dtsi b/arch/riscv/boot/dts/sifive/fu740-c000.dtsi
index abbb960f90a0..454079a69ab4 100644
--- a/arch/riscv/boot/dts/sifive/fu740-c000.dtsi
+++ b/arch/riscv/boot/dts/sifive/fu740-c000.dtsi
@@ -134,6 +134,30 @@ cpu4_intc: interrupt-controller {
 				interrupt-controller;
 			};
 		};
+
+		cpu-map {
+			cluster0 {
+				core0 {
+					cpu = <&cpu0>;
+				};
+
+				core1 {
+					cpu = <&cpu1>;
+				};
+
+				core2 {
+					cpu = <&cpu2>;
+				};
+
+				core3 {
+					cpu = <&cpu3>;
+				};
+
+				core4 {
+					cpu = <&cpu4>;
+				};
+			};
+		};
 	};
 	soc {
 		#address-cells = <2>;
diff --git a/arch/riscv/kernel/sys_riscv.c b/arch/riscv/kernel/sys_riscv.c
index 12f8a7fce78b..8a7880b9c433 100644
--- a/arch/riscv/kernel/sys_riscv.c
+++ b/arch/riscv/kernel/sys_riscv.c
@@ -18,9 +18,8 @@ static long riscv_sys_mmap(unsigned long addr, unsigned long len,
 	if (unlikely(offset & (~PAGE_MASK >> page_shift_offset)))
 		return -EINVAL;
 
-	if ((prot & PROT_WRITE) && (prot & PROT_EXEC))
-		if (unlikely(!(prot & PROT_READ)))
-			return -EINVAL;
+	if (unlikely((prot & PROT_WRITE) && !(prot & PROT_READ)))
+		return -EINVAL;
 
 	return ksys_mmap_pgoff(addr, len, prot, flags, fd,
 			       offset >> (PAGE_SHIFT - page_shift_offset));
diff --git a/arch/riscv/kernel/traps.c b/arch/riscv/kernel/traps.c
index 0daaa3e4630d..b938ffe129d6 100644
--- a/arch/riscv/kernel/traps.c
+++ b/arch/riscv/kernel/traps.c
@@ -16,6 +16,7 @@
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/irq.h>
+#include <linux/kexec.h>
 
 #include <asm/asm-prototypes.h>
 #include <asm/bug.h>
@@ -44,6 +45,9 @@ void die(struct pt_regs *regs, const char *str)
 
 	ret = notify_die(DIE_OOPS, str, regs, 0, regs->cause, SIGSEGV);
 
+	if (regs && kexec_should_crash(current))
+		crash_kexec(regs);
+
 	bust_spinlocks(0);
 	add_taint(TAINT_DIE, LOCKDEP_NOW_UNRELIABLE);
 	spin_unlock_irq(&die_lock);
diff --git a/arch/um/os-Linux/skas/process.c b/arch/um/os-Linux/skas/process.c
index 87d3129e7362..0df2ebcc97c0 100644
--- a/arch/um/os-Linux/skas/process.c
+++ b/arch/um/os-Linux/skas/process.c
@@ -5,6 +5,7 @@
  */
 
 #include <stdlib.h>
+#include <stdbool.h>
 #include <unistd.h>
 #include <sched.h>
 #include <errno.h>
@@ -707,10 +708,24 @@ void halt_skas(void)
 	UML_LONGJMP(&initial_jmpbuf, INIT_JMP_HALT);
 }
 
+static bool noreboot;
+
+static int __init noreboot_cmd_param(char *str, int *add)
+{
+	noreboot = true;
+	return 0;
+}
+
+__uml_setup("noreboot", noreboot_cmd_param,
+"noreboot\n"
+"    Rather than rebooting, exit always, akin to QEMU's -no-reboot option.\n"
+"    This is useful if you're using CONFIG_PANIC_TIMEOUT in order to catch\n"
+"    crashes in CI\n");
+
 void reboot_skas(void)
 {
 	block_signals_trace();
-	UML_LONGJMP(&initial_jmpbuf, INIT_JMP_REBOOT);
+	UML_LONGJMP(&initial_jmpbuf, noreboot ? INIT_JMP_HALT : INIT_JMP_REBOOT);
 }
 
 void __switch_mm(struct mm_id *mm_idp)
diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index 7a7f671c60b4..6872f3834668 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -495,7 +495,7 @@ static void kprobe_emulate_jcc(struct kprobe *p, struct pt_regs *regs)
 		match = ((regs->flags & X86_EFLAGS_SF) >> X86_EFLAGS_SF_BIT) ^
 			((regs->flags & X86_EFLAGS_OF) >> X86_EFLAGS_OF_BIT);
 		if (p->ainsn.jcc.type >= 0xe)
-			match = match && (regs->flags & X86_EFLAGS_ZF);
+			match = match || (regs->flags & X86_EFLAGS_ZF);
 	}
 	__kprobe_emulate_jmp(p, regs, (match && !invert) || (!match && invert));
 }
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index b01f5d2caad0..200ad5ceeb43 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -646,7 +646,7 @@ phys_pud_init(pud_t *pud_page, unsigned long paddr, unsigned long paddr_end,
 			pages++;
 			spin_lock(&init_mm.page_table_lock);
 
-			prot = __pgprot(pgprot_val(prot) | __PAGE_KERNEL_LARGE);
+			prot = __pgprot(pgprot_val(prot) | _PAGE_PSE);
 
 			set_pte_init((pte_t *)pud,
 				     pfn_pte((paddr & PUD_MASK) >> PAGE_SHIFT,
diff --git a/drivers/acpi/pci_mcfg.c b/drivers/acpi/pci_mcfg.c
index 53cab975f612..63b98eae5e75 100644
--- a/drivers/acpi/pci_mcfg.c
+++ b/drivers/acpi/pci_mcfg.c
@@ -41,6 +41,8 @@ struct mcfg_fixup {
 static struct mcfg_fixup mcfg_quirks[] = {
 /*	{ OEM_ID, OEM_TABLE_ID, REV, SEGMENT, BUS_RANGE, ops, cfgres }, */
 
+#ifdef CONFIG_ARM64
+
 #define AL_ECAM(table_id, rev, seg, ops) \
 	{ "AMAZON", table_id, rev, seg, MCFG_BUS_ANY, ops }
 
@@ -169,6 +171,7 @@ static struct mcfg_fixup mcfg_quirks[] = {
 	ALTRA_ECAM_QUIRK(1, 13),
 	ALTRA_ECAM_QUIRK(1, 14),
 	ALTRA_ECAM_QUIRK(1, 15),
+#endif /* ARM64 */
 };
 
 static char mcfg_oem_id[ACPI_OEM_ID_SIZE];
diff --git a/drivers/acpi/property.c b/drivers/acpi/property.c
index b86d3b869a58..488915328646 100644
--- a/drivers/acpi/property.c
+++ b/drivers/acpi/property.c
@@ -155,10 +155,10 @@ static bool acpi_nondev_subnode_ok(acpi_handle scope,
 	return acpi_nondev_subnode_data_ok(handle, link, list, parent);
 }
 
-static int acpi_add_nondev_subnodes(acpi_handle scope,
-				    const union acpi_object *links,
-				    struct list_head *list,
-				    struct fwnode_handle *parent)
+static bool acpi_add_nondev_subnodes(acpi_handle scope,
+				     const union acpi_object *links,
+				     struct list_head *list,
+				     struct fwnode_handle *parent)
 {
 	bool ret = false;
 	int i;
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 1d4a6f1e88cd..7aea631edb27 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -2130,6 +2130,7 @@ const char *ata_get_cmd_descript(u8 command)
 		{ ATA_CMD_WRITE_QUEUED_FUA_EXT, "WRITE DMA QUEUED FUA EXT" },
 		{ ATA_CMD_FPDMA_READ,		"READ FPDMA QUEUED" },
 		{ ATA_CMD_FPDMA_WRITE,		"WRITE FPDMA QUEUED" },
+		{ ATA_CMD_NCQ_NON_DATA,		"NCQ NON-DATA" },
 		{ ATA_CMD_FPDMA_SEND,		"SEND FPDMA QUEUED" },
 		{ ATA_CMD_FPDMA_RECV,		"RECEIVE FPDMA QUEUED" },
 		{ ATA_CMD_PIO_READ,		"READ SECTOR(S)" },
diff --git a/drivers/atm/idt77252.c b/drivers/atm/idt77252.c
index 81ce81a75fc6..681cb3786794 100644
--- a/drivers/atm/idt77252.c
+++ b/drivers/atm/idt77252.c
@@ -3752,6 +3752,7 @@ static void __exit idt77252_exit(void)
 		card = idt77252_chain;
 		dev = card->atmdev;
 		idt77252_chain = card->next;
+		del_timer_sync(&card->tst_timer);
 
 		if (dev->phy->stop)
 			dev->phy->stop(dev);
diff --git a/drivers/block/zram/zcomp.c b/drivers/block/zram/zcomp.c
index 052aa3f65514..0916de952e09 100644
--- a/drivers/block/zram/zcomp.c
+++ b/drivers/block/zram/zcomp.c
@@ -63,12 +63,6 @@ static int zcomp_strm_init(struct zcomp_strm *zstrm, struct zcomp *comp)
 
 bool zcomp_available_algorithm(const char *comp)
 {
-	int i;
-
-	i = sysfs_match_string(backends, comp);
-	if (i >= 0)
-		return true;
-
 	/*
 	 * Crypto does not ignore a trailing new line symbol,
 	 * so make sure you don't supply a string containing
@@ -217,6 +211,11 @@ struct zcomp *zcomp_create(const char *compress)
 	struct zcomp *comp;
 	int error;
 
+	/*
+	 * Crypto API will execute /sbin/modprobe if the compression module
+	 * is not loaded yet. We must do it here, otherwise we are about to
+	 * call /sbin/modprobe under CPU hot-plug lock.
+	 */
 	if (!zcomp_available_algorithm(compress))
 		return ERR_PTR(-EINVAL);
 
diff --git a/drivers/clk/qcom/clk-alpha-pll.c b/drivers/clk/qcom/clk-alpha-pll.c
index 8f65b9bdafce..5e44ceb730ad 100644
--- a/drivers/clk/qcom/clk-alpha-pll.c
+++ b/drivers/clk/qcom/clk-alpha-pll.c
@@ -1420,7 +1420,7 @@ const struct clk_ops clk_alpha_pll_postdiv_fabia_ops = {
 EXPORT_SYMBOL_GPL(clk_alpha_pll_postdiv_fabia_ops);
 
 /**
- * clk_lucid_pll_configure - configure the lucid pll
+ * clk_trion_pll_configure - configure the trion pll
  *
  * @pll: clk alpha pll
  * @regmap: register map
diff --git a/drivers/clk/qcom/gcc-ipq8074.c b/drivers/clk/qcom/gcc-ipq8074.c
index 2c2ecfc5e61f..d6d5defb82c9 100644
--- a/drivers/clk/qcom/gcc-ipq8074.c
+++ b/drivers/clk/qcom/gcc-ipq8074.c
@@ -662,6 +662,7 @@ static struct clk_branch gcc_sleep_clk_src = {
 			},
 			.num_parents = 1,
 			.ops = &clk_branch2_ops,
+			.flags = CLK_IS_CRITICAL,
 		},
 	},
 };
diff --git a/drivers/clk/ti/clk-44xx.c b/drivers/clk/ti/clk-44xx.c
index d078e5d73ed9..868bc7af21b0 100644
--- a/drivers/clk/ti/clk-44xx.c
+++ b/drivers/clk/ti/clk-44xx.c
@@ -56,7 +56,7 @@ static const struct omap_clkctrl_bit_data omap4_aess_bit_data[] __initconst = {
 };
 
 static const char * const omap4_func_dmic_abe_gfclk_parents[] __initconst = {
-	"abe_cm:clk:0018:26",
+	"abe-clkctrl:0018:26",
 	"pad_clks_ck",
 	"slimbus_clk",
 	NULL,
@@ -76,7 +76,7 @@ static const struct omap_clkctrl_bit_data omap4_dmic_bit_data[] __initconst = {
 };
 
 static const char * const omap4_func_mcasp_abe_gfclk_parents[] __initconst = {
-	"abe_cm:clk:0020:26",
+	"abe-clkctrl:0020:26",
 	"pad_clks_ck",
 	"slimbus_clk",
 	NULL,
@@ -89,7 +89,7 @@ static const struct omap_clkctrl_bit_data omap4_mcasp_bit_data[] __initconst = {
 };
 
 static const char * const omap4_func_mcbsp1_gfclk_parents[] __initconst = {
-	"abe_cm:clk:0028:26",
+	"abe-clkctrl:0028:26",
 	"pad_clks_ck",
 	"slimbus_clk",
 	NULL,
@@ -102,7 +102,7 @@ static const struct omap_clkctrl_bit_data omap4_mcbsp1_bit_data[] __initconst =
 };
 
 static const char * const omap4_func_mcbsp2_gfclk_parents[] __initconst = {
-	"abe_cm:clk:0030:26",
+	"abe-clkctrl:0030:26",
 	"pad_clks_ck",
 	"slimbus_clk",
 	NULL,
@@ -115,7 +115,7 @@ static const struct omap_clkctrl_bit_data omap4_mcbsp2_bit_data[] __initconst =
 };
 
 static const char * const omap4_func_mcbsp3_gfclk_parents[] __initconst = {
-	"abe_cm:clk:0038:26",
+	"abe-clkctrl:0038:26",
 	"pad_clks_ck",
 	"slimbus_clk",
 	NULL,
@@ -183,18 +183,18 @@ static const struct omap_clkctrl_bit_data omap4_timer8_bit_data[] __initconst =
 
 static const struct omap_clkctrl_reg_data omap4_abe_clkctrl_regs[] __initconst = {
 	{ OMAP4_L4_ABE_CLKCTRL, NULL, 0, "ocp_abe_iclk" },
-	{ OMAP4_AESS_CLKCTRL, omap4_aess_bit_data, CLKF_SW_SUP, "abe_cm:clk:0008:24" },
+	{ OMAP4_AESS_CLKCTRL, omap4_aess_bit_data, CLKF_SW_SUP, "abe-clkctrl:0008:24" },
 	{ OMAP4_MCPDM_CLKCTRL, NULL, CLKF_SW_SUP, "pad_clks_ck" },
-	{ OMAP4_DMIC_CLKCTRL, omap4_dmic_bit_data, CLKF_SW_SUP, "abe_cm:clk:0018:24" },
-	{ OMAP4_MCASP_CLKCTRL, omap4_mcasp_bit_data, CLKF_SW_SUP, "abe_cm:clk:0020:24" },
-	{ OMAP4_MCBSP1_CLKCTRL, omap4_mcbsp1_bit_data, CLKF_SW_SUP, "abe_cm:clk:0028:24" },
-	{ OMAP4_MCBSP2_CLKCTRL, omap4_mcbsp2_bit_data, CLKF_SW_SUP, "abe_cm:clk:0030:24" },
-	{ OMAP4_MCBSP3_CLKCTRL, omap4_mcbsp3_bit_data, CLKF_SW_SUP, "abe_cm:clk:0038:24" },
-	{ OMAP4_SLIMBUS1_CLKCTRL, omap4_slimbus1_bit_data, CLKF_SW_SUP, "abe_cm:clk:0040:8" },
-	{ OMAP4_TIMER5_CLKCTRL, omap4_timer5_bit_data, CLKF_SW_SUP, "abe_cm:clk:0048:24" },
-	{ OMAP4_TIMER6_CLKCTRL, omap4_timer6_bit_data, CLKF_SW_SUP, "abe_cm:clk:0050:24" },
-	{ OMAP4_TIMER7_CLKCTRL, omap4_timer7_bit_data, CLKF_SW_SUP, "abe_cm:clk:0058:24" },
-	{ OMAP4_TIMER8_CLKCTRL, omap4_timer8_bit_data, CLKF_SW_SUP, "abe_cm:clk:0060:24" },
+	{ OMAP4_DMIC_CLKCTRL, omap4_dmic_bit_data, CLKF_SW_SUP, "abe-clkctrl:0018:24" },
+	{ OMAP4_MCASP_CLKCTRL, omap4_mcasp_bit_data, CLKF_SW_SUP, "abe-clkctrl:0020:24" },
+	{ OMAP4_MCBSP1_CLKCTRL, omap4_mcbsp1_bit_data, CLKF_SW_SUP, "abe-clkctrl:0028:24" },
+	{ OMAP4_MCBSP2_CLKCTRL, omap4_mcbsp2_bit_data, CLKF_SW_SUP, "abe-clkctrl:0030:24" },
+	{ OMAP4_MCBSP3_CLKCTRL, omap4_mcbsp3_bit_data, CLKF_SW_SUP, "abe-clkctrl:0038:24" },
+	{ OMAP4_SLIMBUS1_CLKCTRL, omap4_slimbus1_bit_data, CLKF_SW_SUP, "abe-clkctrl:0040:8" },
+	{ OMAP4_TIMER5_CLKCTRL, omap4_timer5_bit_data, CLKF_SW_SUP, "abe-clkctrl:0048:24" },
+	{ OMAP4_TIMER6_CLKCTRL, omap4_timer6_bit_data, CLKF_SW_SUP, "abe-clkctrl:0050:24" },
+	{ OMAP4_TIMER7_CLKCTRL, omap4_timer7_bit_data, CLKF_SW_SUP, "abe-clkctrl:0058:24" },
+	{ OMAP4_TIMER8_CLKCTRL, omap4_timer8_bit_data, CLKF_SW_SUP, "abe-clkctrl:0060:24" },
 	{ OMAP4_WD_TIMER3_CLKCTRL, NULL, CLKF_SW_SUP, "sys_32k_ck" },
 	{ 0 },
 };
@@ -287,7 +287,7 @@ static const struct omap_clkctrl_bit_data omap4_fdif_bit_data[] __initconst = {
 
 static const struct omap_clkctrl_reg_data omap4_iss_clkctrl_regs[] __initconst = {
 	{ OMAP4_ISS_CLKCTRL, omap4_iss_bit_data, CLKF_SW_SUP, "ducati_clk_mux_ck" },
-	{ OMAP4_FDIF_CLKCTRL, omap4_fdif_bit_data, CLKF_SW_SUP, "iss_cm:clk:0008:24" },
+	{ OMAP4_FDIF_CLKCTRL, omap4_fdif_bit_data, CLKF_SW_SUP, "iss-clkctrl:0008:24" },
 	{ 0 },
 };
 
@@ -320,7 +320,7 @@ static const struct omap_clkctrl_bit_data omap4_dss_core_bit_data[] __initconst
 };
 
 static const struct omap_clkctrl_reg_data omap4_l3_dss_clkctrl_regs[] __initconst = {
-	{ OMAP4_DSS_CORE_CLKCTRL, omap4_dss_core_bit_data, CLKF_SW_SUP, "l3_dss_cm:clk:0000:8" },
+	{ OMAP4_DSS_CORE_CLKCTRL, omap4_dss_core_bit_data, CLKF_SW_SUP, "l3-dss-clkctrl:0000:8" },
 	{ 0 },
 };
 
@@ -336,7 +336,7 @@ static const struct omap_clkctrl_bit_data omap4_gpu_bit_data[] __initconst = {
 };
 
 static const struct omap_clkctrl_reg_data omap4_l3_gfx_clkctrl_regs[] __initconst = {
-	{ OMAP4_GPU_CLKCTRL, omap4_gpu_bit_data, CLKF_SW_SUP, "l3_gfx_cm:clk:0000:24" },
+	{ OMAP4_GPU_CLKCTRL, omap4_gpu_bit_data, CLKF_SW_SUP, "l3-gfx-clkctrl:0000:24" },
 	{ 0 },
 };
 
@@ -372,12 +372,12 @@ static const struct omap_clkctrl_bit_data omap4_hsi_bit_data[] __initconst = {
 };
 
 static const char * const omap4_usb_host_hs_utmi_p1_clk_parents[] __initconst = {
-	"l3_init_cm:clk:0038:24",
+	"l3-init-clkctrl:0038:24",
 	NULL,
 };
 
 static const char * const omap4_usb_host_hs_utmi_p2_clk_parents[] __initconst = {
-	"l3_init_cm:clk:0038:25",
+	"l3-init-clkctrl:0038:25",
 	NULL,
 };
 
@@ -418,7 +418,7 @@ static const struct omap_clkctrl_bit_data omap4_usb_host_hs_bit_data[] __initcon
 };
 
 static const char * const omap4_usb_otg_hs_xclk_parents[] __initconst = {
-	"l3_init_cm:clk:0040:24",
+	"l3-init-clkctrl:0040:24",
 	NULL,
 };
 
@@ -452,14 +452,14 @@ static const struct omap_clkctrl_bit_data omap4_ocp2scp_usb_phy_bit_data[] __ini
 };
 
 static const struct omap_clkctrl_reg_data omap4_l3_init_clkctrl_regs[] __initconst = {
-	{ OMAP4_MMC1_CLKCTRL, omap4_mmc1_bit_data, CLKF_SW_SUP, "l3_init_cm:clk:0008:24" },
-	{ OMAP4_MMC2_CLKCTRL, omap4_mmc2_bit_data, CLKF_SW_SUP, "l3_init_cm:clk:0010:24" },
-	{ OMAP4_HSI_CLKCTRL, omap4_hsi_bit_data, CLKF_HW_SUP, "l3_init_cm:clk:0018:24" },
+	{ OMAP4_MMC1_CLKCTRL, omap4_mmc1_bit_data, CLKF_SW_SUP, "l3-init-clkctrl:0008:24" },
+	{ OMAP4_MMC2_CLKCTRL, omap4_mmc2_bit_data, CLKF_SW_SUP, "l3-init-clkctrl:0010:24" },
+	{ OMAP4_HSI_CLKCTRL, omap4_hsi_bit_data, CLKF_HW_SUP, "l3-init-clkctrl:0018:24" },
 	{ OMAP4_USB_HOST_HS_CLKCTRL, omap4_usb_host_hs_bit_data, CLKF_SW_SUP, "init_60m_fclk" },
 	{ OMAP4_USB_OTG_HS_CLKCTRL, omap4_usb_otg_hs_bit_data, CLKF_HW_SUP, "l3_div_ck" },
 	{ OMAP4_USB_TLL_HS_CLKCTRL, omap4_usb_tll_hs_bit_data, CLKF_HW_SUP, "l4_div_ck" },
 	{ OMAP4_USB_HOST_FS_CLKCTRL, NULL, CLKF_SW_SUP, "func_48mc_fclk" },
-	{ OMAP4_OCP2SCP_USB_PHY_CLKCTRL, omap4_ocp2scp_usb_phy_bit_data, CLKF_HW_SUP, "l3_init_cm:clk:00c0:8" },
+	{ OMAP4_OCP2SCP_USB_PHY_CLKCTRL, omap4_ocp2scp_usb_phy_bit_data, CLKF_HW_SUP, "l3-init-clkctrl:00c0:8" },
 	{ 0 },
 };
 
@@ -530,7 +530,7 @@ static const struct omap_clkctrl_bit_data omap4_gpio6_bit_data[] __initconst = {
 };
 
 static const char * const omap4_per_mcbsp4_gfclk_parents[] __initconst = {
-	"l4_per_cm:clk:00c0:26",
+	"l4-per-clkctrl:00c0:26",
 	"pad_clks_ck",
 	NULL,
 };
@@ -570,12 +570,12 @@ static const struct omap_clkctrl_bit_data omap4_slimbus2_bit_data[] __initconst
 };
 
 static const struct omap_clkctrl_reg_data omap4_l4_per_clkctrl_regs[] __initconst = {
-	{ OMAP4_TIMER10_CLKCTRL, omap4_timer10_bit_data, CLKF_SW_SUP, "l4_per_cm:clk:0008:24" },
-	{ OMAP4_TIMER11_CLKCTRL, omap4_timer11_bit_data, CLKF_SW_SUP, "l4_per_cm:clk:0010:24" },
-	{ OMAP4_TIMER2_CLKCTRL, omap4_timer2_bit_data, CLKF_SW_SUP, "l4_per_cm:clk:0018:24" },
-	{ OMAP4_TIMER3_CLKCTRL, omap4_timer3_bit_data, CLKF_SW_SUP, "l4_per_cm:clk:0020:24" },
-	{ OMAP4_TIMER4_CLKCTRL, omap4_timer4_bit_data, CLKF_SW_SUP, "l4_per_cm:clk:0028:24" },
-	{ OMAP4_TIMER9_CLKCTRL, omap4_timer9_bit_data, CLKF_SW_SUP, "l4_per_cm:clk:0030:24" },
+	{ OMAP4_TIMER10_CLKCTRL, omap4_timer10_bit_data, CLKF_SW_SUP, "l4-per-clkctrl:0008:24" },
+	{ OMAP4_TIMER11_CLKCTRL, omap4_timer11_bit_data, CLKF_SW_SUP, "l4-per-clkctrl:0010:24" },
+	{ OMAP4_TIMER2_CLKCTRL, omap4_timer2_bit_data, CLKF_SW_SUP, "l4-per-clkctrl:0018:24" },
+	{ OMAP4_TIMER3_CLKCTRL, omap4_timer3_bit_data, CLKF_SW_SUP, "l4-per-clkctrl:0020:24" },
+	{ OMAP4_TIMER4_CLKCTRL, omap4_timer4_bit_data, CLKF_SW_SUP, "l4-per-clkctrl:0028:24" },
+	{ OMAP4_TIMER9_CLKCTRL, omap4_timer9_bit_data, CLKF_SW_SUP, "l4-per-clkctrl:0030:24" },
 	{ OMAP4_ELM_CLKCTRL, NULL, 0, "l4_div_ck" },
 	{ OMAP4_GPIO2_CLKCTRL, omap4_gpio2_bit_data, CLKF_HW_SUP, "l4_div_ck" },
 	{ OMAP4_GPIO3_CLKCTRL, omap4_gpio3_bit_data, CLKF_HW_SUP, "l4_div_ck" },
@@ -588,14 +588,14 @@ static const struct omap_clkctrl_reg_data omap4_l4_per_clkctrl_regs[] __initcons
 	{ OMAP4_I2C3_CLKCTRL, NULL, CLKF_SW_SUP, "func_96m_fclk" },
 	{ OMAP4_I2C4_CLKCTRL, NULL, CLKF_SW_SUP, "func_96m_fclk" },
 	{ OMAP4_L4_PER_CLKCTRL, NULL, 0, "l4_div_ck" },
-	{ OMAP4_MCBSP4_CLKCTRL, omap4_mcbsp4_bit_data, CLKF_SW_SUP, "l4_per_cm:clk:00c0:24" },
+	{ OMAP4_MCBSP4_CLKCTRL, omap4_mcbsp4_bit_data, CLKF_SW_SUP, "l4-per-clkctrl:00c0:24" },
 	{ OMAP4_MCSPI1_CLKCTRL, NULL, CLKF_SW_SUP, "func_48m_fclk" },
 	{ OMAP4_MCSPI2_CLKCTRL, NULL, CLKF_SW_SUP, "func_48m_fclk" },
 	{ OMAP4_MCSPI3_CLKCTRL, NULL, CLKF_SW_SUP, "func_48m_fclk" },
 	{ OMAP4_MCSPI4_CLKCTRL, NULL, CLKF_SW_SUP, "func_48m_fclk" },
 	{ OMAP4_MMC3_CLKCTRL, NULL, CLKF_SW_SUP, "func_48m_fclk" },
 	{ OMAP4_MMC4_CLKCTRL, NULL, CLKF_SW_SUP, "func_48m_fclk" },
-	{ OMAP4_SLIMBUS2_CLKCTRL, omap4_slimbus2_bit_data, CLKF_SW_SUP, "l4_per_cm:clk:0118:8" },
+	{ OMAP4_SLIMBUS2_CLKCTRL, omap4_slimbus2_bit_data, CLKF_SW_SUP, "l4-per-clkctrl:0118:8" },
 	{ OMAP4_UART1_CLKCTRL, NULL, CLKF_SW_SUP, "func_48m_fclk" },
 	{ OMAP4_UART2_CLKCTRL, NULL, CLKF_SW_SUP, "func_48m_fclk" },
 	{ OMAP4_UART3_CLKCTRL, NULL, CLKF_SW_SUP, "func_48m_fclk" },
@@ -630,7 +630,7 @@ static const struct omap_clkctrl_reg_data omap4_l4_wkup_clkctrl_regs[] __initcon
 	{ OMAP4_L4_WKUP_CLKCTRL, NULL, 0, "l4_wkup_clk_mux_ck" },
 	{ OMAP4_WD_TIMER2_CLKCTRL, NULL, CLKF_SW_SUP, "sys_32k_ck" },
 	{ OMAP4_GPIO1_CLKCTRL, omap4_gpio1_bit_data, CLKF_HW_SUP, "l4_wkup_clk_mux_ck" },
-	{ OMAP4_TIMER1_CLKCTRL, omap4_timer1_bit_data, CLKF_SW_SUP, "l4_wkup_cm:clk:0020:24" },
+	{ OMAP4_TIMER1_CLKCTRL, omap4_timer1_bit_data, CLKF_SW_SUP, "l4-wkup-clkctrl:0020:24" },
 	{ OMAP4_COUNTER_32K_CLKCTRL, NULL, 0, "sys_32k_ck" },
 	{ OMAP4_KBD_CLKCTRL, NULL, CLKF_SW_SUP, "sys_32k_ck" },
 	{ 0 },
@@ -644,7 +644,7 @@ static const char * const omap4_pmd_stm_clock_mux_ck_parents[] __initconst = {
 };
 
 static const char * const omap4_trace_clk_div_div_ck_parents[] __initconst = {
-	"emu_sys_cm:clk:0000:22",
+	"emu-sys-clkctrl:0000:22",
 	NULL,
 };
 
@@ -662,7 +662,7 @@ static const struct omap_clkctrl_div_data omap4_trace_clk_div_div_ck_data __init
 };
 
 static const char * const omap4_stm_clk_div_ck_parents[] __initconst = {
-	"emu_sys_cm:clk:0000:20",
+	"emu-sys-clkctrl:0000:20",
 	NULL,
 };
 
@@ -716,73 +716,73 @@ static struct ti_dt_clk omap44xx_clks[] = {
 	 * hwmod support. Once hwmod is removed, these can be removed
 	 * also.
 	 */
-	DT_CLK(NULL, "aess_fclk", "abe_cm:0008:24"),
-	DT_CLK(NULL, "cm2_dm10_mux", "l4_per_cm:0008:24"),
-	DT_CLK(NULL, "cm2_dm11_mux", "l4_per_cm:0010:24"),
-	DT_CLK(NULL, "cm2_dm2_mux", "l4_per_cm:0018:24"),
-	DT_CLK(NULL, "cm2_dm3_mux", "l4_per_cm:0020:24"),
-	DT_CLK(NULL, "cm2_dm4_mux", "l4_per_cm:0028:24"),
-	DT_CLK(NULL, "cm2_dm9_mux", "l4_per_cm:0030:24"),
-	DT_CLK(NULL, "dmic_sync_mux_ck", "abe_cm:0018:26"),
-	DT_CLK(NULL, "dmt1_clk_mux", "l4_wkup_cm:0020:24"),
-	DT_CLK(NULL, "dss_48mhz_clk", "l3_dss_cm:0000:9"),
-	DT_CLK(NULL, "dss_dss_clk", "l3_dss_cm:0000:8"),
-	DT_CLK(NULL, "dss_sys_clk", "l3_dss_cm:0000:10"),
-	DT_CLK(NULL, "dss_tv_clk", "l3_dss_cm:0000:11"),
-	DT_CLK(NULL, "fdif_fck", "iss_cm:0008:24"),
-	DT_CLK(NULL, "func_dmic_abe_gfclk", "abe_cm:0018:24"),
-	DT_CLK(NULL, "func_mcasp_abe_gfclk", "abe_cm:0020:24"),
-	DT_CLK(NULL, "func_mcbsp1_gfclk", "abe_cm:0028:24"),
-	DT_CLK(NULL, "func_mcbsp2_gfclk", "abe_cm:0030:24"),
-	DT_CLK(NULL, "func_mcbsp3_gfclk", "abe_cm:0038:24"),
-	DT_CLK(NULL, "gpio1_dbclk", "l4_wkup_cm:0018:8"),
-	DT_CLK(NULL, "gpio2_dbclk", "l4_per_cm:0040:8"),
-	DT_CLK(NULL, "gpio3_dbclk", "l4_per_cm:0048:8"),
-	DT_CLK(NULL, "gpio4_dbclk", "l4_per_cm:0050:8"),
-	DT_CLK(NULL, "gpio5_dbclk", "l4_per_cm:0058:8"),
-	DT_CLK(NULL, "gpio6_dbclk", "l4_per_cm:0060:8"),
-	DT_CLK(NULL, "hsi_fck", "l3_init_cm:0018:24"),
-	DT_CLK(NULL, "hsmmc1_fclk", "l3_init_cm:0008:24"),
-	DT_CLK(NULL, "hsmmc2_fclk", "l3_init_cm:0010:24"),
-	DT_CLK(NULL, "iss_ctrlclk", "iss_cm:0000:8"),
-	DT_CLK(NULL, "mcasp_sync_mux_ck", "abe_cm:0020:26"),
-	DT_CLK(NULL, "mcbsp1_sync_mux_ck", "abe_cm:0028:26"),
-	DT_CLK(NULL, "mcbsp2_sync_mux_ck", "abe_cm:0030:26"),
-	DT_CLK(NULL, "mcbsp3_sync_mux_ck", "abe_cm:0038:26"),
-	DT_CLK(NULL, "mcbsp4_sync_mux_ck", "l4_per_cm:00c0:26"),
-	DT_CLK(NULL, "ocp2scp_usb_phy_phy_48m", "l3_init_cm:00c0:8"),
-	DT_CLK(NULL, "otg_60m_gfclk", "l3_init_cm:0040:24"),
-	DT_CLK(NULL, "per_mcbsp4_gfclk", "l4_per_cm:00c0:24"),
-	DT_CLK(NULL, "pmd_stm_clock_mux_ck", "emu_sys_cm:0000:20"),
-	DT_CLK(NULL, "pmd_trace_clk_mux_ck", "emu_sys_cm:0000:22"),
-	DT_CLK(NULL, "sgx_clk_mux", "l3_gfx_cm:0000:24"),
-	DT_CLK(NULL, "slimbus1_fclk_0", "abe_cm:0040:8"),
-	DT_CLK(NULL, "slimbus1_fclk_1", "abe_cm:0040:9"),
-	DT_CLK(NULL, "slimbus1_fclk_2", "abe_cm:0040:10"),
-	DT_CLK(NULL, "slimbus1_slimbus_clk", "abe_cm:0040:11"),
-	DT_CLK(NULL, "slimbus2_fclk_0", "l4_per_cm:0118:8"),
-	DT_CLK(NULL, "slimbus2_fclk_1", "l4_per_cm:0118:9"),
-	DT_CLK(NULL, "slimbus2_slimbus_clk", "l4_per_cm:0118:10"),
-	DT_CLK(NULL, "stm_clk_div_ck", "emu_sys_cm:0000:27"),
-	DT_CLK(NULL, "timer5_sync_mux", "abe_cm:0048:24"),
-	DT_CLK(NULL, "timer6_sync_mux", "abe_cm:0050:24"),
-	DT_CLK(NULL, "timer7_sync_mux", "abe_cm:0058:24"),
-	DT_CLK(NULL, "timer8_sync_mux", "abe_cm:0060:24"),
-	DT_CLK(NULL, "trace_clk_div_div_ck", "emu_sys_cm:0000:24"),
-	DT_CLK(NULL, "usb_host_hs_func48mclk", "l3_init_cm:0038:15"),
-	DT_CLK(NULL, "usb_host_hs_hsic480m_p1_clk", "l3_init_cm:0038:13"),
-	DT_CLK(NULL, "usb_host_hs_hsic480m_p2_clk", "l3_init_cm:0038:14"),
-	DT_CLK(NULL, "usb_host_hs_hsic60m_p1_clk", "l3_init_cm:0038:11"),
-	DT_CLK(NULL, "usb_host_hs_hsic60m_p2_clk", "l3_init_cm:0038:12"),
-	DT_CLK(NULL, "usb_host_hs_utmi_p1_clk", "l3_init_cm:0038:8"),
-	DT_CLK(NULL, "usb_host_hs_utmi_p2_clk", "l3_init_cm:0038:9"),
-	DT_CLK(NULL, "usb_host_hs_utmi_p3_clk", "l3_init_cm:0038:10"),
-	DT_CLK(NULL, "usb_otg_hs_xclk", "l3_init_cm:0040:8"),
-	DT_CLK(NULL, "usb_tll_hs_usb_ch0_clk", "l3_init_cm:0048:8"),
-	DT_CLK(NULL, "usb_tll_hs_usb_ch1_clk", "l3_init_cm:0048:9"),
-	DT_CLK(NULL, "usb_tll_hs_usb_ch2_clk", "l3_init_cm:0048:10"),
-	DT_CLK(NULL, "utmi_p1_gfclk", "l3_init_cm:0038:24"),
-	DT_CLK(NULL, "utmi_p2_gfclk", "l3_init_cm:0038:25"),
+	DT_CLK(NULL, "aess_fclk", "abe-clkctrl:0008:24"),
+	DT_CLK(NULL, "cm2_dm10_mux", "l4-per-clkctrl:0008:24"),
+	DT_CLK(NULL, "cm2_dm11_mux", "l4-per-clkctrl:0010:24"),
+	DT_CLK(NULL, "cm2_dm2_mux", "l4-per-clkctrl:0018:24"),
+	DT_CLK(NULL, "cm2_dm3_mux", "l4-per-clkctrl:0020:24"),
+	DT_CLK(NULL, "cm2_dm4_mux", "l4-per-clkctrl:0028:24"),
+	DT_CLK(NULL, "cm2_dm9_mux", "l4-per-clkctrl:0030:24"),
+	DT_CLK(NULL, "dmic_sync_mux_ck", "abe-clkctrl:0018:26"),
+	DT_CLK(NULL, "dmt1_clk_mux", "l4-wkup-clkctrl:0020:24"),
+	DT_CLK(NULL, "dss_48mhz_clk", "l3-dss-clkctrl:0000:9"),
+	DT_CLK(NULL, "dss_dss_clk", "l3-dss-clkctrl:0000:8"),
+	DT_CLK(NULL, "dss_sys_clk", "l3-dss-clkctrl:0000:10"),
+	DT_CLK(NULL, "dss_tv_clk", "l3-dss-clkctrl:0000:11"),
+	DT_CLK(NULL, "fdif_fck", "iss-clkctrl:0008:24"),
+	DT_CLK(NULL, "func_dmic_abe_gfclk", "abe-clkctrl:0018:24"),
+	DT_CLK(NULL, "func_mcasp_abe_gfclk", "abe-clkctrl:0020:24"),
+	DT_CLK(NULL, "func_mcbsp1_gfclk", "abe-clkctrl:0028:24"),
+	DT_CLK(NULL, "func_mcbsp2_gfclk", "abe-clkctrl:0030:24"),
+	DT_CLK(NULL, "func_mcbsp3_gfclk", "abe-clkctrl:0038:24"),
+	DT_CLK(NULL, "gpio1_dbclk", "l4-wkup-clkctrl:0018:8"),
+	DT_CLK(NULL, "gpio2_dbclk", "l4-per-clkctrl:0040:8"),
+	DT_CLK(NULL, "gpio3_dbclk", "l4-per-clkctrl:0048:8"),
+	DT_CLK(NULL, "gpio4_dbclk", "l4-per-clkctrl:0050:8"),
+	DT_CLK(NULL, "gpio5_dbclk", "l4-per-clkctrl:0058:8"),
+	DT_CLK(NULL, "gpio6_dbclk", "l4-per-clkctrl:0060:8"),
+	DT_CLK(NULL, "hsi_fck", "l3-init-clkctrl:0018:24"),
+	DT_CLK(NULL, "hsmmc1_fclk", "l3-init-clkctrl:0008:24"),
+	DT_CLK(NULL, "hsmmc2_fclk", "l3-init-clkctrl:0010:24"),
+	DT_CLK(NULL, "iss_ctrlclk", "iss-clkctrl:0000:8"),
+	DT_CLK(NULL, "mcasp_sync_mux_ck", "abe-clkctrl:0020:26"),
+	DT_CLK(NULL, "mcbsp1_sync_mux_ck", "abe-clkctrl:0028:26"),
+	DT_CLK(NULL, "mcbsp2_sync_mux_ck", "abe-clkctrl:0030:26"),
+	DT_CLK(NULL, "mcbsp3_sync_mux_ck", "abe-clkctrl:0038:26"),
+	DT_CLK(NULL, "mcbsp4_sync_mux_ck", "l4-per-clkctrl:00c0:26"),
+	DT_CLK(NULL, "ocp2scp_usb_phy_phy_48m", "l3-init-clkctrl:00c0:8"),
+	DT_CLK(NULL, "otg_60m_gfclk", "l3-init-clkctrl:0040:24"),
+	DT_CLK(NULL, "per_mcbsp4_gfclk", "l4-per-clkctrl:00c0:24"),
+	DT_CLK(NULL, "pmd_stm_clock_mux_ck", "emu-sys-clkctrl:0000:20"),
+	DT_CLK(NULL, "pmd_trace_clk_mux_ck", "emu-sys-clkctrl:0000:22"),
+	DT_CLK(NULL, "sgx_clk_mux", "l3-gfx-clkctrl:0000:24"),
+	DT_CLK(NULL, "slimbus1_fclk_0", "abe-clkctrl:0040:8"),
+	DT_CLK(NULL, "slimbus1_fclk_1", "abe-clkctrl:0040:9"),
+	DT_CLK(NULL, "slimbus1_fclk_2", "abe-clkctrl:0040:10"),
+	DT_CLK(NULL, "slimbus1_slimbus_clk", "abe-clkctrl:0040:11"),
+	DT_CLK(NULL, "slimbus2_fclk_0", "l4-per-clkctrl:0118:8"),
+	DT_CLK(NULL, "slimbus2_fclk_1", "l4-per-clkctrl:0118:9"),
+	DT_CLK(NULL, "slimbus2_slimbus_clk", "l4-per-clkctrl:0118:10"),
+	DT_CLK(NULL, "stm_clk_div_ck", "emu-sys-clkctrl:0000:27"),
+	DT_CLK(NULL, "timer5_sync_mux", "abe-clkctrl:0048:24"),
+	DT_CLK(NULL, "timer6_sync_mux", "abe-clkctrl:0050:24"),
+	DT_CLK(NULL, "timer7_sync_mux", "abe-clkctrl:0058:24"),
+	DT_CLK(NULL, "timer8_sync_mux", "abe-clkctrl:0060:24"),
+	DT_CLK(NULL, "trace_clk_div_div_ck", "emu-sys-clkctrl:0000:24"),
+	DT_CLK(NULL, "usb_host_hs_func48mclk", "l3-init-clkctrl:0038:15"),
+	DT_CLK(NULL, "usb_host_hs_hsic480m_p1_clk", "l3-init-clkctrl:0038:13"),
+	DT_CLK(NULL, "usb_host_hs_hsic480m_p2_clk", "l3-init-clkctrl:0038:14"),
+	DT_CLK(NULL, "usb_host_hs_hsic60m_p1_clk", "l3-init-clkctrl:0038:11"),
+	DT_CLK(NULL, "usb_host_hs_hsic60m_p2_clk", "l3-init-clkctrl:0038:12"),
+	DT_CLK(NULL, "usb_host_hs_utmi_p1_clk", "l3-init-clkctrl:0038:8"),
+	DT_CLK(NULL, "usb_host_hs_utmi_p2_clk", "l3-init-clkctrl:0038:9"),
+	DT_CLK(NULL, "usb_host_hs_utmi_p3_clk", "l3_init-clkctrl:0038:10"),
+	DT_CLK(NULL, "usb_otg_hs_xclk", "l3-init-clkctrl:0040:8"),
+	DT_CLK(NULL, "usb_tll_hs_usb_ch0_clk", "l3-init-clkctrl:0048:8"),
+	DT_CLK(NULL, "usb_tll_hs_usb_ch1_clk", "l3-init-clkctrl:0048:9"),
+	DT_CLK(NULL, "usb_tll_hs_usb_ch2_clk", "l3-init-clkctrl:0048:10"),
+	DT_CLK(NULL, "utmi_p1_gfclk", "l3-init-clkctrl:0038:24"),
+	DT_CLK(NULL, "utmi_p2_gfclk", "l3-init-clkctrl:0038:25"),
 	{ .node_name = NULL },
 };
 
diff --git a/drivers/clk/ti/clk-54xx.c b/drivers/clk/ti/clk-54xx.c
index 90e0a9ea6351..b4aff76eb373 100644
--- a/drivers/clk/ti/clk-54xx.c
+++ b/drivers/clk/ti/clk-54xx.c
@@ -50,7 +50,7 @@ static const struct omap_clkctrl_bit_data omap5_aess_bit_data[] __initconst = {
 };
 
 static const char * const omap5_dmic_gfclk_parents[] __initconst = {
-	"abe_cm:clk:0018:26",
+	"abe-clkctrl:0018:26",
 	"pad_clks_ck",
 	"slimbus_clk",
 	NULL,
@@ -70,7 +70,7 @@ static const struct omap_clkctrl_bit_data omap5_dmic_bit_data[] __initconst = {
 };
 
 static const char * const omap5_mcbsp1_gfclk_parents[] __initconst = {
-	"abe_cm:clk:0028:26",
+	"abe-clkctrl:0028:26",
 	"pad_clks_ck",
 	"slimbus_clk",
 	NULL,
@@ -83,7 +83,7 @@ static const struct omap_clkctrl_bit_data omap5_mcbsp1_bit_data[] __initconst =
 };
 
 static const char * const omap5_mcbsp2_gfclk_parents[] __initconst = {
-	"abe_cm:clk:0030:26",
+	"abe-clkctrl:0030:26",
 	"pad_clks_ck",
 	"slimbus_clk",
 	NULL,
@@ -96,7 +96,7 @@ static const struct omap_clkctrl_bit_data omap5_mcbsp2_bit_data[] __initconst =
 };
 
 static const char * const omap5_mcbsp3_gfclk_parents[] __initconst = {
-	"abe_cm:clk:0038:26",
+	"abe-clkctrl:0038:26",
 	"pad_clks_ck",
 	"slimbus_clk",
 	NULL,
@@ -136,16 +136,16 @@ static const struct omap_clkctrl_bit_data omap5_timer8_bit_data[] __initconst =
 
 static const struct omap_clkctrl_reg_data omap5_abe_clkctrl_regs[] __initconst = {
 	{ OMAP5_L4_ABE_CLKCTRL, NULL, 0, "abe_iclk" },
-	{ OMAP5_AESS_CLKCTRL, omap5_aess_bit_data, CLKF_SW_SUP, "abe_cm:clk:0008:24" },
+	{ OMAP5_AESS_CLKCTRL, omap5_aess_bit_data, CLKF_SW_SUP, "abe-clkctrl:0008:24" },
 	{ OMAP5_MCPDM_CLKCTRL, NULL, CLKF_SW_SUP, "pad_clks_ck" },
-	{ OMAP5_DMIC_CLKCTRL, omap5_dmic_bit_data, CLKF_SW_SUP, "abe_cm:clk:0018:24" },
-	{ OMAP5_MCBSP1_CLKCTRL, omap5_mcbsp1_bit_data, CLKF_SW_SUP, "abe_cm:clk:0028:24" },
-	{ OMAP5_MCBSP2_CLKCTRL, omap5_mcbsp2_bit_data, CLKF_SW_SUP, "abe_cm:clk:0030:24" },
-	{ OMAP5_MCBSP3_CLKCTRL, omap5_mcbsp3_bit_data, CLKF_SW_SUP, "abe_cm:clk:0038:24" },
-	{ OMAP5_TIMER5_CLKCTRL, omap5_timer5_bit_data, CLKF_SW_SUP, "abe_cm:clk:0048:24" },
-	{ OMAP5_TIMER6_CLKCTRL, omap5_timer6_bit_data, CLKF_SW_SUP, "abe_cm:clk:0050:24" },
-	{ OMAP5_TIMER7_CLKCTRL, omap5_timer7_bit_data, CLKF_SW_SUP, "abe_cm:clk:0058:24" },
-	{ OMAP5_TIMER8_CLKCTRL, omap5_timer8_bit_data, CLKF_SW_SUP, "abe_cm:clk:0060:24" },
+	{ OMAP5_DMIC_CLKCTRL, omap5_dmic_bit_data, CLKF_SW_SUP, "abe-clkctrl:0018:24" },
+	{ OMAP5_MCBSP1_CLKCTRL, omap5_mcbsp1_bit_data, CLKF_SW_SUP, "abe-clkctrl:0028:24" },
+	{ OMAP5_MCBSP2_CLKCTRL, omap5_mcbsp2_bit_data, CLKF_SW_SUP, "abe-clkctrl:0030:24" },
+	{ OMAP5_MCBSP3_CLKCTRL, omap5_mcbsp3_bit_data, CLKF_SW_SUP, "abe-clkctrl:0038:24" },
+	{ OMAP5_TIMER5_CLKCTRL, omap5_timer5_bit_data, CLKF_SW_SUP, "abe-clkctrl:0048:24" },
+	{ OMAP5_TIMER6_CLKCTRL, omap5_timer6_bit_data, CLKF_SW_SUP, "abe-clkctrl:0050:24" },
+	{ OMAP5_TIMER7_CLKCTRL, omap5_timer7_bit_data, CLKF_SW_SUP, "abe-clkctrl:0058:24" },
+	{ OMAP5_TIMER8_CLKCTRL, omap5_timer8_bit_data, CLKF_SW_SUP, "abe-clkctrl:0060:24" },
 	{ 0 },
 };
 
@@ -268,12 +268,12 @@ static const struct omap_clkctrl_bit_data omap5_gpio8_bit_data[] __initconst = {
 };
 
 static const struct omap_clkctrl_reg_data omap5_l4per_clkctrl_regs[] __initconst = {
-	{ OMAP5_TIMER10_CLKCTRL, omap5_timer10_bit_data, CLKF_SW_SUP, "l4per_cm:clk:0008:24" },
-	{ OMAP5_TIMER11_CLKCTRL, omap5_timer11_bit_data, CLKF_SW_SUP, "l4per_cm:clk:0010:24" },
-	{ OMAP5_TIMER2_CLKCTRL, omap5_timer2_bit_data, CLKF_SW_SUP, "l4per_cm:clk:0018:24" },
-	{ OMAP5_TIMER3_CLKCTRL, omap5_timer3_bit_data, CLKF_SW_SUP, "l4per_cm:clk:0020:24" },
-	{ OMAP5_TIMER4_CLKCTRL, omap5_timer4_bit_data, CLKF_SW_SUP, "l4per_cm:clk:0028:24" },
-	{ OMAP5_TIMER9_CLKCTRL, omap5_timer9_bit_data, CLKF_SW_SUP, "l4per_cm:clk:0030:24" },
+	{ OMAP5_TIMER10_CLKCTRL, omap5_timer10_bit_data, CLKF_SW_SUP, "l4per-clkctrl:0008:24" },
+	{ OMAP5_TIMER11_CLKCTRL, omap5_timer11_bit_data, CLKF_SW_SUP, "l4per-clkctrl:0010:24" },
+	{ OMAP5_TIMER2_CLKCTRL, omap5_timer2_bit_data, CLKF_SW_SUP, "l4per-clkctrl:0018:24" },
+	{ OMAP5_TIMER3_CLKCTRL, omap5_timer3_bit_data, CLKF_SW_SUP, "l4per-clkctrl:0020:24" },
+	{ OMAP5_TIMER4_CLKCTRL, omap5_timer4_bit_data, CLKF_SW_SUP, "l4per-clkctrl:0028:24" },
+	{ OMAP5_TIMER9_CLKCTRL, omap5_timer9_bit_data, CLKF_SW_SUP, "l4per-clkctrl:0030:24" },
 	{ OMAP5_GPIO2_CLKCTRL, omap5_gpio2_bit_data, CLKF_HW_SUP, "l4_root_clk_div" },
 	{ OMAP5_GPIO3_CLKCTRL, omap5_gpio3_bit_data, CLKF_HW_SUP, "l4_root_clk_div" },
 	{ OMAP5_GPIO4_CLKCTRL, omap5_gpio4_bit_data, CLKF_HW_SUP, "l4_root_clk_div" },
@@ -345,7 +345,7 @@ static const struct omap_clkctrl_bit_data omap5_dss_core_bit_data[] __initconst
 };
 
 static const struct omap_clkctrl_reg_data omap5_dss_clkctrl_regs[] __initconst = {
-	{ OMAP5_DSS_CORE_CLKCTRL, omap5_dss_core_bit_data, CLKF_SW_SUP, "dss_cm:clk:0000:8" },
+	{ OMAP5_DSS_CORE_CLKCTRL, omap5_dss_core_bit_data, CLKF_SW_SUP, "dss-clkctrl:0000:8" },
 	{ 0 },
 };
 
@@ -378,7 +378,7 @@ static const struct omap_clkctrl_bit_data omap5_gpu_core_bit_data[] __initconst
 };
 
 static const struct omap_clkctrl_reg_data omap5_gpu_clkctrl_regs[] __initconst = {
-	{ OMAP5_GPU_CLKCTRL, omap5_gpu_core_bit_data, CLKF_SW_SUP, "gpu_cm:clk:0000:24" },
+	{ OMAP5_GPU_CLKCTRL, omap5_gpu_core_bit_data, CLKF_SW_SUP, "gpu-clkctrl:0000:24" },
 	{ 0 },
 };
 
@@ -389,7 +389,7 @@ static const char * const omap5_mmc1_fclk_mux_parents[] __initconst = {
 };
 
 static const char * const omap5_mmc1_fclk_parents[] __initconst = {
-	"l3init_cm:clk:0008:24",
+	"l3init-clkctrl:0008:24",
 	NULL,
 };
 
@@ -405,7 +405,7 @@ static const struct omap_clkctrl_bit_data omap5_mmc1_bit_data[] __initconst = {
 };
 
 static const char * const omap5_mmc2_fclk_parents[] __initconst = {
-	"l3init_cm:clk:0010:24",
+	"l3init-clkctrl:0010:24",
 	NULL,
 };
 
@@ -430,12 +430,12 @@ static const char * const omap5_usb_host_hs_hsic480m_p3_clk_parents[] __initcons
 };
 
 static const char * const omap5_usb_host_hs_utmi_p1_clk_parents[] __initconst = {
-	"l3init_cm:clk:0038:24",
+	"l3init-clkctrl:0038:24",
 	NULL,
 };
 
 static const char * const omap5_usb_host_hs_utmi_p2_clk_parents[] __initconst = {
-	"l3init_cm:clk:0038:25",
+	"l3init-clkctrl:0038:25",
 	NULL,
 };
 
@@ -494,8 +494,8 @@ static const struct omap_clkctrl_bit_data omap5_usb_otg_ss_bit_data[] __initcons
 };
 
 static const struct omap_clkctrl_reg_data omap5_l3init_clkctrl_regs[] __initconst = {
-	{ OMAP5_MMC1_CLKCTRL, omap5_mmc1_bit_data, CLKF_SW_SUP, "l3init_cm:clk:0008:25" },
-	{ OMAP5_MMC2_CLKCTRL, omap5_mmc2_bit_data, CLKF_SW_SUP, "l3init_cm:clk:0010:25" },
+	{ OMAP5_MMC1_CLKCTRL, omap5_mmc1_bit_data, CLKF_SW_SUP, "l3init-clkctrl:0008:25" },
+	{ OMAP5_MMC2_CLKCTRL, omap5_mmc2_bit_data, CLKF_SW_SUP, "l3init-clkctrl:0010:25" },
 	{ OMAP5_USB_HOST_HS_CLKCTRL, omap5_usb_host_hs_bit_data, CLKF_SW_SUP, "l3init_60m_fclk" },
 	{ OMAP5_USB_TLL_HS_CLKCTRL, omap5_usb_tll_hs_bit_data, CLKF_HW_SUP, "l4_root_clk_div" },
 	{ OMAP5_SATA_CLKCTRL, omap5_sata_bit_data, CLKF_SW_SUP, "func_48m_fclk" },
@@ -519,7 +519,7 @@ static const struct omap_clkctrl_reg_data omap5_wkupaon_clkctrl_regs[] __initcon
 	{ OMAP5_L4_WKUP_CLKCTRL, NULL, 0, "wkupaon_iclk_mux" },
 	{ OMAP5_WD_TIMER2_CLKCTRL, NULL, CLKF_SW_SUP, "sys_32k_ck" },
 	{ OMAP5_GPIO1_CLKCTRL, omap5_gpio1_bit_data, CLKF_HW_SUP, "wkupaon_iclk_mux" },
-	{ OMAP5_TIMER1_CLKCTRL, omap5_timer1_bit_data, CLKF_SW_SUP, "wkupaon_cm:clk:0020:24" },
+	{ OMAP5_TIMER1_CLKCTRL, omap5_timer1_bit_data, CLKF_SW_SUP, "wkupaon-clkctrl:0020:24" },
 	{ OMAP5_COUNTER_32K_CLKCTRL, NULL, 0, "wkupaon_iclk_mux" },
 	{ OMAP5_KBD_CLKCTRL, NULL, CLKF_SW_SUP, "sys_32k_ck" },
 	{ 0 },
@@ -549,58 +549,58 @@ const struct omap_clkctrl_data omap5_clkctrl_data[] __initconst = {
 static struct ti_dt_clk omap54xx_clks[] = {
 	DT_CLK(NULL, "timer_32k_ck", "sys_32k_ck"),
 	DT_CLK(NULL, "sys_clkin_ck", "sys_clkin"),
-	DT_CLK(NULL, "dmic_gfclk", "abe_cm:0018:24"),
-	DT_CLK(NULL, "dmic_sync_mux_ck", "abe_cm:0018:26"),
-	DT_CLK(NULL, "dss_32khz_clk", "dss_cm:0000:11"),
-	DT_CLK(NULL, "dss_48mhz_clk", "dss_cm:0000:9"),
-	DT_CLK(NULL, "dss_dss_clk", "dss_cm:0000:8"),
-	DT_CLK(NULL, "dss_sys_clk", "dss_cm:0000:10"),
-	DT_CLK(NULL, "gpio1_dbclk", "wkupaon_cm:0018:8"),
-	DT_CLK(NULL, "gpio2_dbclk", "l4per_cm:0040:8"),
-	DT_CLK(NULL, "gpio3_dbclk", "l4per_cm:0048:8"),
-	DT_CLK(NULL, "gpio4_dbclk", "l4per_cm:0050:8"),
-	DT_CLK(NULL, "gpio5_dbclk", "l4per_cm:0058:8"),
-	DT_CLK(NULL, "gpio6_dbclk", "l4per_cm:0060:8"),
-	DT_CLK(NULL, "gpio7_dbclk", "l4per_cm:00f0:8"),
-	DT_CLK(NULL, "gpio8_dbclk", "l4per_cm:00f8:8"),
-	DT_CLK(NULL, "mcbsp1_gfclk", "abe_cm:0028:24"),
-	DT_CLK(NULL, "mcbsp1_sync_mux_ck", "abe_cm:0028:26"),
-	DT_CLK(NULL, "mcbsp2_gfclk", "abe_cm:0030:24"),
-	DT_CLK(NULL, "mcbsp2_sync_mux_ck", "abe_cm:0030:26"),
-	DT_CLK(NULL, "mcbsp3_gfclk", "abe_cm:0038:24"),
-	DT_CLK(NULL, "mcbsp3_sync_mux_ck", "abe_cm:0038:26"),
-	DT_CLK(NULL, "mmc1_32khz_clk", "l3init_cm:0008:8"),
-	DT_CLK(NULL, "mmc1_fclk", "l3init_cm:0008:25"),
-	DT_CLK(NULL, "mmc1_fclk_mux", "l3init_cm:0008:24"),
-	DT_CLK(NULL, "mmc2_fclk", "l3init_cm:0010:25"),
-	DT_CLK(NULL, "mmc2_fclk_mux", "l3init_cm:0010:24"),
-	DT_CLK(NULL, "sata_ref_clk", "l3init_cm:0068:8"),
-	DT_CLK(NULL, "timer10_gfclk_mux", "l4per_cm:0008:24"),
-	DT_CLK(NULL, "timer11_gfclk_mux", "l4per_cm:0010:24"),
-	DT_CLK(NULL, "timer1_gfclk_mux", "wkupaon_cm:0020:24"),
-	DT_CLK(NULL, "timer2_gfclk_mux", "l4per_cm:0018:24"),
-	DT_CLK(NULL, "timer3_gfclk_mux", "l4per_cm:0020:24"),
-	DT_CLK(NULL, "timer4_gfclk_mux", "l4per_cm:0028:24"),
-	DT_CLK(NULL, "timer5_gfclk_mux", "abe_cm:0048:24"),
-	DT_CLK(NULL, "timer6_gfclk_mux", "abe_cm:0050:24"),
-	DT_CLK(NULL, "timer7_gfclk_mux", "abe_cm:0058:24"),
-	DT_CLK(NULL, "timer8_gfclk_mux", "abe_cm:0060:24"),
-	DT_CLK(NULL, "timer9_gfclk_mux", "l4per_cm:0030:24"),
-	DT_CLK(NULL, "usb_host_hs_hsic480m_p1_clk", "l3init_cm:0038:13"),
-	DT_CLK(NULL, "usb_host_hs_hsic480m_p2_clk", "l3init_cm:0038:14"),
-	DT_CLK(NULL, "usb_host_hs_hsic480m_p3_clk", "l3init_cm:0038:7"),
-	DT_CLK(NULL, "usb_host_hs_hsic60m_p1_clk", "l3init_cm:0038:11"),
-	DT_CLK(NULL, "usb_host_hs_hsic60m_p2_clk", "l3init_cm:0038:12"),
-	DT_CLK(NULL, "usb_host_hs_hsic60m_p3_clk", "l3init_cm:0038:6"),
-	DT_CLK(NULL, "usb_host_hs_utmi_p1_clk", "l3init_cm:0038:8"),
-	DT_CLK(NULL, "usb_host_hs_utmi_p2_clk", "l3init_cm:0038:9"),
-	DT_CLK(NULL, "usb_host_hs_utmi_p3_clk", "l3init_cm:0038:10"),
-	DT_CLK(NULL, "usb_otg_ss_refclk960m", "l3init_cm:00d0:8"),
-	DT_CLK(NULL, "usb_tll_hs_usb_ch0_clk", "l3init_cm:0048:8"),
-	DT_CLK(NULL, "usb_tll_hs_usb_ch1_clk", "l3init_cm:0048:9"),
-	DT_CLK(NULL, "usb_tll_hs_usb_ch2_clk", "l3init_cm:0048:10"),
-	DT_CLK(NULL, "utmi_p1_gfclk", "l3init_cm:0038:24"),
-	DT_CLK(NULL, "utmi_p2_gfclk", "l3init_cm:0038:25"),
+	DT_CLK(NULL, "dmic_gfclk", "abe-clkctrl:0018:24"),
+	DT_CLK(NULL, "dmic_sync_mux_ck", "abe-clkctrl:0018:26"),
+	DT_CLK(NULL, "dss_32khz_clk", "dss-clkctrl:0000:11"),
+	DT_CLK(NULL, "dss_48mhz_clk", "dss-clkctrl:0000:9"),
+	DT_CLK(NULL, "dss_dss_clk", "dss-clkctrl:0000:8"),
+	DT_CLK(NULL, "dss_sys_clk", "dss-clkctrl:0000:10"),
+	DT_CLK(NULL, "gpio1_dbclk", "wkupaon-clkctrl:0018:8"),
+	DT_CLK(NULL, "gpio2_dbclk", "l4per-clkctrl:0040:8"),
+	DT_CLK(NULL, "gpio3_dbclk", "l4per-clkctrl:0048:8"),
+	DT_CLK(NULL, "gpio4_dbclk", "l4per-clkctrl:0050:8"),
+	DT_CLK(NULL, "gpio5_dbclk", "l4per-clkctrl:0058:8"),
+	DT_CLK(NULL, "gpio6_dbclk", "l4per-clkctrl:0060:8"),
+	DT_CLK(NULL, "gpio7_dbclk", "l4per-clkctrl:00f0:8"),
+	DT_CLK(NULL, "gpio8_dbclk", "l4per-clkctrl:00f8:8"),
+	DT_CLK(NULL, "mcbsp1_gfclk", "abe-clkctrl:0028:24"),
+	DT_CLK(NULL, "mcbsp1_sync_mux_ck", "abe-clkctrl:0028:26"),
+	DT_CLK(NULL, "mcbsp2_gfclk", "abe-clkctrl:0030:24"),
+	DT_CLK(NULL, "mcbsp2_sync_mux_ck", "abe-clkctrl:0030:26"),
+	DT_CLK(NULL, "mcbsp3_gfclk", "abe-clkctrl:0038:24"),
+	DT_CLK(NULL, "mcbsp3_sync_mux_ck", "abe-clkctrl:0038:26"),
+	DT_CLK(NULL, "mmc1_32khz_clk", "l3init-clkctrl:0008:8"),
+	DT_CLK(NULL, "mmc1_fclk", "l3init-clkctrl:0008:25"),
+	DT_CLK(NULL, "mmc1_fclk_mux", "l3init-clkctrl:0008:24"),
+	DT_CLK(NULL, "mmc2_fclk", "l3init-clkctrl:0010:25"),
+	DT_CLK(NULL, "mmc2_fclk_mux", "l3init-clkctrl:0010:24"),
+	DT_CLK(NULL, "sata_ref_clk", "l3init-clkctrl:0068:8"),
+	DT_CLK(NULL, "timer10_gfclk_mux", "l4per-clkctrl:0008:24"),
+	DT_CLK(NULL, "timer11_gfclk_mux", "l4per-clkctrl:0010:24"),
+	DT_CLK(NULL, "timer1_gfclk_mux", "wkupaon-clkctrl:0020:24"),
+	DT_CLK(NULL, "timer2_gfclk_mux", "l4per-clkctrl:0018:24"),
+	DT_CLK(NULL, "timer3_gfclk_mux", "l4per-clkctrl:0020:24"),
+	DT_CLK(NULL, "timer4_gfclk_mux", "l4per-clkctrl:0028:24"),
+	DT_CLK(NULL, "timer5_gfclk_mux", "abe-clkctrl:0048:24"),
+	DT_CLK(NULL, "timer6_gfclk_mux", "abe-clkctrl:0050:24"),
+	DT_CLK(NULL, "timer7_gfclk_mux", "abe-clkctrl:0058:24"),
+	DT_CLK(NULL, "timer8_gfclk_mux", "abe-clkctrl:0060:24"),
+	DT_CLK(NULL, "timer9_gfclk_mux", "l4per-clkctrl:0030:24"),
+	DT_CLK(NULL, "usb_host_hs_hsic480m_p1_clk", "l3init-clkctrl:0038:13"),
+	DT_CLK(NULL, "usb_host_hs_hsic480m_p2_clk", "l3init-clkctrl:0038:14"),
+	DT_CLK(NULL, "usb_host_hs_hsic480m_p3_clk", "l3init-clkctrl:0038:7"),
+	DT_CLK(NULL, "usb_host_hs_hsic60m_p1_clk", "l3init-clkctrl:0038:11"),
+	DT_CLK(NULL, "usb_host_hs_hsic60m_p2_clk", "l3init-clkctrl:0038:12"),
+	DT_CLK(NULL, "usb_host_hs_hsic60m_p3_clk", "l3init-clkctrl:0038:6"),
+	DT_CLK(NULL, "usb_host_hs_utmi_p1_clk", "l3init-clkctrl:0038:8"),
+	DT_CLK(NULL, "usb_host_hs_utmi_p2_clk", "l3init-clkctrl:0038:9"),
+	DT_CLK(NULL, "usb_host_hs_utmi_p3_clk", "l3init-clkctrl:0038:10"),
+	DT_CLK(NULL, "usb_otg_ss_refclk960m", "l3init-clkctrl:00d0:8"),
+	DT_CLK(NULL, "usb_tll_hs_usb_ch0_clk", "l3init-clkctrl:0048:8"),
+	DT_CLK(NULL, "usb_tll_hs_usb_ch1_clk", "l3init-clkctrl:0048:9"),
+	DT_CLK(NULL, "usb_tll_hs_usb_ch2_clk", "l3init-clkctrl:0048:10"),
+	DT_CLK(NULL, "utmi_p1_gfclk", "l3init-clkctrl:0038:24"),
+	DT_CLK(NULL, "utmi_p2_gfclk", "l3init-clkctrl:0038:25"),
 	{ .node_name = NULL },
 };
 
diff --git a/drivers/clk/ti/clkctrl.c b/drivers/clk/ti/clkctrl.c
index 864c484bde1b..08a85c559f79 100644
--- a/drivers/clk/ti/clkctrl.c
+++ b/drivers/clk/ti/clkctrl.c
@@ -511,10 +511,6 @@ static void __init _ti_omap4_clkctrl_setup(struct device_node *node)
 	char *c;
 	u16 soc_mask = 0;
 
-	if (!(ti_clk_get_features()->flags & TI_CLK_CLKCTRL_COMPAT) &&
-	    of_node_name_eq(node, "clk"))
-		ti_clk_features.flags |= TI_CLK_CLKCTRL_COMPAT;
-
 	addrp = of_get_address(node, 0, NULL, NULL);
 	addr = (u32)of_translate_address(node, addrp);
 
diff --git a/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c b/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
index 35993ab92154..48de8d2b32f2 100644
--- a/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
+++ b/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
@@ -944,6 +944,11 @@ static int dw_axi_dma_chan_slave_config(struct dma_chan *dchan,
 static void axi_chan_dump_lli(struct axi_dma_chan *chan,
 			      struct axi_dma_hw_desc *desc)
 {
+	if (!desc->lli) {
+		dev_err(dchan2dev(&chan->vc.chan), "NULL LLI\n");
+		return;
+	}
+
 	dev_err(dchan2dev(&chan->vc.chan),
 		"SAR: 0x%llx DAR: 0x%llx LLP: 0x%llx BTS 0x%x CTL: 0x%x:%08x",
 		le64_to_cpu(desc->lli->sar),
@@ -1011,6 +1016,11 @@ static void axi_chan_block_xfer_complete(struct axi_dma_chan *chan)
 
 	/* The completed descriptor currently is in the head of vc list */
 	vd = vchan_next_desc(&chan->vc);
+	if (!vd) {
+		dev_err(chan2dev(chan), "BUG: %s, IRQ with no descriptors\n",
+			axi_chan_name(chan));
+		goto out;
+	}
 
 	if (chan->cyclic) {
 		desc = vd_to_axi_desc(vd);
@@ -1040,6 +1050,7 @@ static void axi_chan_block_xfer_complete(struct axi_dma_chan *chan)
 		axi_chan_start_first_queued(chan);
 	}
 
+out:
 	spin_unlock_irqrestore(&chan->vc.lock, flags);
 }
 
diff --git a/drivers/dma/sprd-dma.c b/drivers/dma/sprd-dma.c
index 4357d2395e6b..60115d8d4083 100644
--- a/drivers/dma/sprd-dma.c
+++ b/drivers/dma/sprd-dma.c
@@ -1236,11 +1236,8 @@ static int sprd_dma_remove(struct platform_device *pdev)
 {
 	struct sprd_dma_dev *sdev = platform_get_drvdata(pdev);
 	struct sprd_dma_chn *c, *cn;
-	int ret;
 
-	ret = pm_runtime_get_sync(&pdev->dev);
-	if (ret < 0)
-		return ret;
+	pm_runtime_get_sync(&pdev->dev);
 
 	/* explicitly free the irq */
 	if (sdev->irq > 0)
diff --git a/drivers/gpu/drm/amd/display/dc/dcn303/dcn303_resource.c b/drivers/gpu/drm/amd/display/dc/dcn303/dcn303_resource.c
index 589ddab61c2a..7aad0340f794 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn303/dcn303_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn303/dcn303_resource.c
@@ -500,7 +500,7 @@ static struct stream_encoder *dcn303_stream_encoder_create(enum engine_id eng_id
 	int afmt_inst;
 
 	/* Mapping of VPG, AFMT, DME register blocks to DIO block instance */
-	if (eng_id <= ENGINE_ID_DIGE) {
+	if (eng_id <= ENGINE_ID_DIGB) {
 		vpg_inst = eng_id;
 		afmt_inst = eng_id;
 	} else
diff --git a/drivers/gpu/drm/imx/dcss/dcss-kms.c b/drivers/gpu/drm/imx/dcss/dcss-kms.c
index 9b84df34a6a1..8cf3352d8858 100644
--- a/drivers/gpu/drm/imx/dcss/dcss-kms.c
+++ b/drivers/gpu/drm/imx/dcss/dcss-kms.c
@@ -142,8 +142,6 @@ struct dcss_kms_dev *dcss_kms_attach(struct dcss_dev *dcss)
 
 	drm_kms_helper_poll_init(drm);
 
-	drm_bridge_connector_enable_hpd(kms->connector);
-
 	ret = drm_dev_register(drm, 0);
 	if (ret)
 		goto cleanup_crtc;
diff --git a/drivers/gpu/drm/meson/meson_drv.c b/drivers/gpu/drm/meson/meson_drv.c
index c98525d60df5..a56607501d36 100644
--- a/drivers/gpu/drm/meson/meson_drv.c
+++ b/drivers/gpu/drm/meson/meson_drv.c
@@ -114,8 +114,11 @@ static bool meson_vpu_has_available_connectors(struct device *dev)
 	for_each_endpoint_of_node(dev->of_node, ep) {
 		/* If the endpoint node exists, consider it enabled */
 		remote = of_graph_get_remote_port(ep);
-		if (remote)
+		if (remote) {
+			of_node_put(remote);
+			of_node_put(ep);
 			return true;
+		}
 	}
 
 	return false;
diff --git a/drivers/gpu/drm/meson/meson_viu.c b/drivers/gpu/drm/meson/meson_viu.c
index 259f3e6bec90..bb7e109534de 100644
--- a/drivers/gpu/drm/meson/meson_viu.c
+++ b/drivers/gpu/drm/meson/meson_viu.c
@@ -469,17 +469,17 @@ void meson_viu_init(struct meson_drm *priv)
 			priv->io_base + _REG(VD2_IF0_LUMA_FIFO_SIZE));
 
 	if (meson_vpu_is_compatible(priv, VPU_COMPATIBLE_G12A)) {
-		writel_relaxed(VIU_OSD_BLEND_REORDER(0, 1) |
-			       VIU_OSD_BLEND_REORDER(1, 0) |
-			       VIU_OSD_BLEND_REORDER(2, 0) |
-			       VIU_OSD_BLEND_REORDER(3, 0) |
-			       VIU_OSD_BLEND_DIN_EN(1) |
-			       VIU_OSD_BLEND1_DIN3_BYPASS_TO_DOUT1 |
-			       VIU_OSD_BLEND1_DOUT_BYPASS_TO_BLEND2 |
-			       VIU_OSD_BLEND_DIN0_BYPASS_TO_DOUT0 |
-			       VIU_OSD_BLEND_BLEN2_PREMULT_EN(1) |
-			       VIU_OSD_BLEND_HOLD_LINES(4),
-			       priv->io_base + _REG(VIU_OSD_BLEND_CTRL));
+		u32 val = (u32)VIU_OSD_BLEND_REORDER(0, 1) |
+			  (u32)VIU_OSD_BLEND_REORDER(1, 0) |
+			  (u32)VIU_OSD_BLEND_REORDER(2, 0) |
+			  (u32)VIU_OSD_BLEND_REORDER(3, 0) |
+			  (u32)VIU_OSD_BLEND_DIN_EN(1) |
+			  (u32)VIU_OSD_BLEND1_DIN3_BYPASS_TO_DOUT1 |
+			  (u32)VIU_OSD_BLEND1_DOUT_BYPASS_TO_BLEND2 |
+			  (u32)VIU_OSD_BLEND_DIN0_BYPASS_TO_DOUT0 |
+			  (u32)VIU_OSD_BLEND_BLEN2_PREMULT_EN(1) |
+			  (u32)VIU_OSD_BLEND_HOLD_LINES(4);
+		writel_relaxed(val, priv->io_base + _REG(VIU_OSD_BLEND_CTRL));
 
 		writel_relaxed(OSD_BLEND_PATH_SEL_ENABLE,
 			       priv->io_base + _REG(OSD1_BLEND_SRC_CTRL));
diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/device/base.c b/drivers/gpu/drm/nouveau/nvkm/engine/device/base.c
index 88d262ba648c..76156833a832 100644
--- a/drivers/gpu/drm/nouveau/nvkm/engine/device/base.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/device/base.c
@@ -2605,6 +2605,27 @@ nv172_chipset = {
 	.fifo     = { 0x00000001, ga102_fifo_new },
 };
 
+static const struct nvkm_device_chip
+nv173_chipset = {
+	.name = "GA103",
+	.bar      = { 0x00000001, tu102_bar_new },
+	.bios     = { 0x00000001, nvkm_bios_new },
+	.devinit  = { 0x00000001, ga100_devinit_new },
+	.fb       = { 0x00000001, ga102_fb_new },
+	.gpio     = { 0x00000001, ga102_gpio_new },
+	.i2c      = { 0x00000001, gm200_i2c_new },
+	.imem     = { 0x00000001, nv50_instmem_new },
+	.mc       = { 0x00000001, ga100_mc_new },
+	.mmu      = { 0x00000001, tu102_mmu_new },
+	.pci      = { 0x00000001, gp100_pci_new },
+	.privring = { 0x00000001, gm200_privring_new },
+	.timer    = { 0x00000001, gk20a_timer_new },
+	.top      = { 0x00000001, ga100_top_new },
+	.disp     = { 0x00000001, ga102_disp_new },
+	.dma      = { 0x00000001, gv100_dma_new },
+	.fifo     = { 0x00000001, ga102_fifo_new },
+};
+
 static const struct nvkm_device_chip
 nv174_chipset = {
 	.name = "GA104",
@@ -3092,6 +3113,7 @@ nvkm_device_ctor(const struct nvkm_device_func *func,
 		case 0x167: device->chip = &nv167_chipset; break;
 		case 0x168: device->chip = &nv168_chipset; break;
 		case 0x172: device->chip = &nv172_chipset; break;
+		case 0x173: device->chip = &nv173_chipset; break;
 		case 0x174: device->chip = &nv174_chipset; break;
 		case 0x176: device->chip = &nv176_chipset; break;
 		case 0x177: device->chip = &nv177_chipset; break;
diff --git a/drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c b/drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c
index 4f5efcace68e..51edb4244af7 100644
--- a/drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c
+++ b/drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c
@@ -531,7 +531,7 @@ static void sun6i_dsi_setup_timings(struct sun6i_dsi *dsi,
 				    struct drm_display_mode *mode)
 {
 	struct mipi_dsi_device *device = dsi->device;
-	unsigned int Bpp = mipi_dsi_pixel_format_to_bpp(device->format) / 8;
+	int Bpp = mipi_dsi_pixel_format_to_bpp(device->format) / 8;
 	u16 hbp = 0, hfp = 0, hsa = 0, hblk = 0, vblk = 0;
 	u32 basic_ctl = 0;
 	size_t bytes;
@@ -555,7 +555,7 @@ static void sun6i_dsi_setup_timings(struct sun6i_dsi *dsi,
 		 * (4 bytes). Its minimal size is therefore 10 bytes
 		 */
 #define HSA_PACKET_OVERHEAD	10
-		hsa = max((unsigned int)HSA_PACKET_OVERHEAD,
+		hsa = max(HSA_PACKET_OVERHEAD,
 			  (mode->hsync_end - mode->hsync_start) * Bpp - HSA_PACKET_OVERHEAD);
 
 		/*
@@ -564,7 +564,7 @@ static void sun6i_dsi_setup_timings(struct sun6i_dsi *dsi,
 		 * therefore 6 bytes
 		 */
 #define HBP_PACKET_OVERHEAD	6
-		hbp = max((unsigned int)HBP_PACKET_OVERHEAD,
+		hbp = max(HBP_PACKET_OVERHEAD,
 			  (mode->htotal - mode->hsync_end) * Bpp - HBP_PACKET_OVERHEAD);
 
 		/*
@@ -574,7 +574,7 @@ static void sun6i_dsi_setup_timings(struct sun6i_dsi *dsi,
 		 * 16 bytes
 		 */
 #define HFP_PACKET_OVERHEAD	16
-		hfp = max((unsigned int)HFP_PACKET_OVERHEAD,
+		hfp = max(HFP_PACKET_OVERHEAD,
 			  (mode->hsync_start - mode->hdisplay) * Bpp - HFP_PACKET_OVERHEAD);
 
 		/*
@@ -583,7 +583,7 @@ static void sun6i_dsi_setup_timings(struct sun6i_dsi *dsi,
 		 * bytes). Its minimal size is therefore 10 bytes.
 		 */
 #define HBLK_PACKET_OVERHEAD	10
-		hblk = max((unsigned int)HBLK_PACKET_OVERHEAD,
+		hblk = max(HBLK_PACKET_OVERHEAD,
 			   (mode->htotal - (mode->hsync_end - mode->hsync_start)) * Bpp -
 			   HBLK_PACKET_OVERHEAD);
 
diff --git a/drivers/gpu/drm/ttm/ttm_bo.c b/drivers/gpu/drm/ttm/ttm_bo.c
index 900edaf5d68e..33e78f56123e 100644
--- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -987,7 +987,7 @@ int ttm_bo_validate(struct ttm_buffer_object *bo,
 	/*
 	 * We might need to add a TTM.
 	 */
-	if (bo->resource->mem_type == TTM_PL_SYSTEM) {
+	if (!bo->resource || bo->resource->mem_type == TTM_PL_SYSTEM) {
 		ret = ttm_tt_create(bo, true);
 		if (ret)
 			return ret;
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index f382444dc2db..a14c48de4446 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -194,6 +194,7 @@ static void mt_post_parse(struct mt_device *td, struct mt_application *app);
 #define MT_CLS_WIN_8_FORCE_MULTI_INPUT		0x0015
 #define MT_CLS_WIN_8_DISABLE_WAKEUP		0x0016
 #define MT_CLS_WIN_8_NO_STICKY_FINGERS		0x0017
+#define MT_CLS_WIN_8_FORCE_MULTI_INPUT_NSMU	0x0018
 
 /* vendor specific classes */
 #define MT_CLS_3M				0x0101
@@ -286,6 +287,15 @@ static const struct mt_class mt_classes[] = {
 			MT_QUIRK_WIN8_PTP_BUTTONS |
 			MT_QUIRK_FORCE_MULTI_INPUT,
 		.export_all_inputs = true },
+	{ .name = MT_CLS_WIN_8_FORCE_MULTI_INPUT_NSMU,
+		.quirks = MT_QUIRK_IGNORE_DUPLICATES |
+			MT_QUIRK_HOVERING |
+			MT_QUIRK_CONTACT_CNT_ACCURATE |
+			MT_QUIRK_STICKY_FINGERS |
+			MT_QUIRK_WIN8_PTP_BUTTONS |
+			MT_QUIRK_FORCE_MULTI_INPUT |
+			MT_QUIRK_NOT_SEEN_MEANS_UP,
+		.export_all_inputs = true },
 	{ .name = MT_CLS_WIN_8_DISABLE_WAKEUP,
 		.quirks = MT_QUIRK_ALWAYS_VALID |
 			MT_QUIRK_IGNORE_DUPLICATES |
@@ -783,6 +793,7 @@ static int mt_touch_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		case HID_DG_CONFIDENCE:
 			if ((cls->name == MT_CLS_WIN_8 ||
 			     cls->name == MT_CLS_WIN_8_FORCE_MULTI_INPUT ||
+			     cls->name == MT_CLS_WIN_8_FORCE_MULTI_INPUT_NSMU ||
 			     cls->name == MT_CLS_WIN_8_DISABLE_WAKEUP) &&
 				(field->application == HID_DG_TOUCHPAD ||
 				 field->application == HID_DG_TOUCHSCREEN))
@@ -2033,7 +2044,7 @@ static const struct hid_device_id mt_devices[] = {
 			   USB_DEVICE_ID_LENOVO_X1_TAB3) },
 
 	/* Lenovo X12 TAB Gen 1 */
-	{ .driver_data = MT_CLS_WIN_8_FORCE_MULTI_INPUT,
+	{ .driver_data = MT_CLS_WIN_8_FORCE_MULTI_INPUT_NSMU,
 		HID_DEVICE(BUS_USB, HID_GROUP_MULTITOUCH_WIN_8,
 			   USB_VENDOR_ID_LENOVO,
 			   USB_DEVICE_ID_LENOVO_X12_TAB) },
diff --git a/drivers/hwtracing/coresight/coresight-etm4x.h b/drivers/hwtracing/coresight/coresight-etm4x.h
index e5b79bdb9851..794b29639035 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x.h
+++ b/drivers/hwtracing/coresight/coresight-etm4x.h
@@ -7,6 +7,7 @@
 #define _CORESIGHT_CORESIGHT_ETM_H
 
 #include <asm/local.h>
+#include <linux/const.h>
 #include <linux/spinlock.h>
 #include <linux/types.h>
 #include "coresight-priv.h"
@@ -417,7 +418,7 @@
 	({									\
 		u64 __val;							\
 										\
-		if (__builtin_constant_p((offset)))				\
+		if (__is_constexpr((offset)))					\
 			__val = read_etm4x_sysreg_const_offset((offset));	\
 		else								\
 			__val = etm4x_sysreg_read((offset), true, (_64bit));	\
diff --git a/drivers/i2c/busses/i2c-imx.c b/drivers/i2c/busses/i2c-imx.c
index 3576b63a6c03..3f40995c0ca9 100644
--- a/drivers/i2c/busses/i2c-imx.c
+++ b/drivers/i2c/busses/i2c-imx.c
@@ -1487,9 +1487,7 @@ static int i2c_imx_remove(struct platform_device *pdev)
 	struct imx_i2c_struct *i2c_imx = platform_get_drvdata(pdev);
 	int irq, ret;
 
-	ret = pm_runtime_resume_and_get(&pdev->dev);
-	if (ret < 0)
-		return ret;
+	ret = pm_runtime_get_sync(&pdev->dev);
 
 	/* remove adapter */
 	dev_dbg(&i2c_imx->adapter.dev, "adapter removed\n");
@@ -1498,17 +1496,21 @@ static int i2c_imx_remove(struct platform_device *pdev)
 	if (i2c_imx->dma)
 		i2c_imx_dma_free(i2c_imx);
 
-	/* setup chip registers to defaults */
-	imx_i2c_write_reg(0, i2c_imx, IMX_I2C_IADR);
-	imx_i2c_write_reg(0, i2c_imx, IMX_I2C_IFDR);
-	imx_i2c_write_reg(0, i2c_imx, IMX_I2C_I2CR);
-	imx_i2c_write_reg(0, i2c_imx, IMX_I2C_I2SR);
+	if (ret == 0) {
+		/* setup chip registers to defaults */
+		imx_i2c_write_reg(0, i2c_imx, IMX_I2C_IADR);
+		imx_i2c_write_reg(0, i2c_imx, IMX_I2C_IFDR);
+		imx_i2c_write_reg(0, i2c_imx, IMX_I2C_I2CR);
+		imx_i2c_write_reg(0, i2c_imx, IMX_I2C_I2SR);
+		clk_disable(i2c_imx->clk);
+	}
 
 	clk_notifier_unregister(i2c_imx->clk, &i2c_imx->clk_change_nb);
 	irq = platform_get_irq(pdev, 0);
 	if (irq >= 0)
 		free_irq(irq, i2c_imx);
-	clk_disable_unprepare(i2c_imx->clk);
+
+	clk_unprepare(i2c_imx->clk);
 
 	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
diff --git a/drivers/infiniband/sw/rxe/rxe_param.h b/drivers/infiniband/sw/rxe/rxe_param.h
index b5a70cbe94aa..872389870106 100644
--- a/drivers/infiniband/sw/rxe/rxe_param.h
+++ b/drivers/infiniband/sw/rxe/rxe_param.h
@@ -103,6 +103,12 @@ enum rxe_device_param {
 	RXE_INFLIGHT_SKBS_PER_QP_HIGH	= 64,
 	RXE_INFLIGHT_SKBS_PER_QP_LOW	= 16,
 
+	/* Max number of interations of each tasklet
+	 * before yielding the cpu to let other
+	 * work make progress
+	 */
+	RXE_MAX_ITERATIONS		= 1024,
+
 	/* Delay before calling arbiter timer */
 	RXE_NSEC_ARB_TIMER_DELAY	= 200,
 
diff --git a/drivers/infiniband/sw/rxe/rxe_task.c b/drivers/infiniband/sw/rxe/rxe_task.c
index 6951fdcb31bf..568cf56c236b 100644
--- a/drivers/infiniband/sw/rxe/rxe_task.c
+++ b/drivers/infiniband/sw/rxe/rxe_task.c
@@ -8,7 +8,7 @@
 #include <linux/interrupt.h>
 #include <linux/hardirq.h>
 
-#include "rxe_task.h"
+#include "rxe.h"
 
 int __rxe_do_task(struct rxe_task *task)
 
@@ -34,6 +34,7 @@ void rxe_do_task(struct tasklet_struct *t)
 	int ret;
 	unsigned long flags;
 	struct rxe_task *task = from_tasklet(task, t, tasklet);
+	unsigned int iterations = RXE_MAX_ITERATIONS;
 
 	spin_lock_irqsave(&task->state_lock, flags);
 	switch (task->state) {
@@ -62,13 +63,20 @@ void rxe_do_task(struct tasklet_struct *t)
 		spin_lock_irqsave(&task->state_lock, flags);
 		switch (task->state) {
 		case TASK_STATE_BUSY:
-			if (ret)
+			if (ret) {
 				task->state = TASK_STATE_START;
-			else
+			} else if (iterations--) {
 				cont = 1;
+			} else {
+				/* reschedule the tasklet and exit
+				 * the loop to give up the cpu
+				 */
+				tasklet_schedule(&task->tasklet);
+				task->state = TASK_STATE_START;
+			}
 			break;
 
-		/* soneone tried to run the task since the last time we called
+		/* someone tried to run the task since the last time we called
 		 * func, so we will call one more time regardless of the
 		 * return value
 		 */
diff --git a/drivers/input/touchscreen/exc3000.c b/drivers/input/touchscreen/exc3000.c
index cbe0dd412912..4b7eee01c6aa 100644
--- a/drivers/input/touchscreen/exc3000.c
+++ b/drivers/input/touchscreen/exc3000.c
@@ -220,6 +220,7 @@ static int exc3000_vendor_data_request(struct exc3000_data *data, u8 *request,
 {
 	u8 buf[EXC3000_LEN_VENDOR_REQUEST] = { 0x67, 0x00, 0x42, 0x00, 0x03 };
 	int ret;
+	unsigned long time_left;
 
 	mutex_lock(&data->query_lock);
 
@@ -233,9 +234,9 @@ static int exc3000_vendor_data_request(struct exc3000_data *data, u8 *request,
 		goto out_unlock;
 
 	if (response) {
-		ret = wait_for_completion_timeout(&data->wait_event,
-						  timeout * HZ);
-		if (ret <= 0) {
+		time_left = wait_for_completion_timeout(&data->wait_event,
+							timeout * HZ);
+		if (time_left == 0) {
 			ret = -ETIMEDOUT;
 			goto out_unlock;
 		}
diff --git a/drivers/iommu/io-pgtable-arm-v7s.c b/drivers/iommu/io-pgtable-arm-v7s.c
index be066c1503d3..ba3115fd0f86 100644
--- a/drivers/iommu/io-pgtable-arm-v7s.c
+++ b/drivers/iommu/io-pgtable-arm-v7s.c
@@ -182,14 +182,8 @@ static bool arm_v7s_is_mtk_enabled(struct io_pgtable_cfg *cfg)
 		(cfg->quirks & IO_PGTABLE_QUIRK_ARM_MTK_EXT);
 }
 
-static arm_v7s_iopte paddr_to_iopte(phys_addr_t paddr, int lvl,
-				    struct io_pgtable_cfg *cfg)
+static arm_v7s_iopte to_mtk_iopte(phys_addr_t paddr, arm_v7s_iopte pte)
 {
-	arm_v7s_iopte pte = paddr & ARM_V7S_LVL_MASK(lvl);
-
-	if (!arm_v7s_is_mtk_enabled(cfg))
-		return pte;
-
 	if (paddr & BIT_ULL(32))
 		pte |= ARM_V7S_ATTR_MTK_PA_BIT32;
 	if (paddr & BIT_ULL(33))
@@ -199,6 +193,17 @@ static arm_v7s_iopte paddr_to_iopte(phys_addr_t paddr, int lvl,
 	return pte;
 }
 
+static arm_v7s_iopte paddr_to_iopte(phys_addr_t paddr, int lvl,
+				    struct io_pgtable_cfg *cfg)
+{
+	arm_v7s_iopte pte = paddr & ARM_V7S_LVL_MASK(lvl);
+
+	if (arm_v7s_is_mtk_enabled(cfg))
+		return to_mtk_iopte(paddr, pte);
+
+	return pte;
+}
+
 static phys_addr_t iopte_to_paddr(arm_v7s_iopte pte, int lvl,
 				  struct io_pgtable_cfg *cfg)
 {
@@ -240,10 +245,17 @@ static void *__arm_v7s_alloc_table(int lvl, gfp_t gfp,
 	dma_addr_t dma;
 	size_t size = ARM_V7S_TABLE_SIZE(lvl, cfg);
 	void *table = NULL;
+	gfp_t gfp_l1;
+
+	/*
+	 * ARM_MTK_TTBR_EXT extend the translation table base support larger
+	 * memory address.
+	 */
+	gfp_l1 = cfg->quirks & IO_PGTABLE_QUIRK_ARM_MTK_TTBR_EXT ?
+		 GFP_KERNEL : ARM_V7S_TABLE_GFP_DMA;
 
 	if (lvl == 1)
-		table = (void *)__get_free_pages(
-			__GFP_ZERO | ARM_V7S_TABLE_GFP_DMA, get_order(size));
+		table = (void *)__get_free_pages(gfp_l1 | __GFP_ZERO, get_order(size));
 	else if (lvl == 2)
 		table = kmem_cache_zalloc(data->l2_tables, gfp);
 
@@ -251,7 +263,8 @@ static void *__arm_v7s_alloc_table(int lvl, gfp_t gfp,
 		return NULL;
 
 	phys = virt_to_phys(table);
-	if (phys != (arm_v7s_iopte)phys) {
+	if (cfg->quirks & IO_PGTABLE_QUIRK_ARM_MTK_TTBR_EXT ?
+	    phys >= (1ULL << cfg->oas) : phys != (arm_v7s_iopte)phys) {
 		/* Doesn't fit in PTE */
 		dev_err(dev, "Page table does not fit in PTE: %pa", &phys);
 		goto out_free;
@@ -457,9 +470,14 @@ static arm_v7s_iopte arm_v7s_install_table(arm_v7s_iopte *table,
 					   arm_v7s_iopte curr,
 					   struct io_pgtable_cfg *cfg)
 {
+	phys_addr_t phys = virt_to_phys(table);
 	arm_v7s_iopte old, new;
 
-	new = virt_to_phys(table) | ARM_V7S_PTE_TYPE_TABLE;
+	new = phys | ARM_V7S_PTE_TYPE_TABLE;
+
+	if (cfg->quirks & IO_PGTABLE_QUIRK_ARM_MTK_TTBR_EXT)
+		new = to_mtk_iopte(phys, new);
+
 	if (cfg->quirks & IO_PGTABLE_QUIRK_ARM_NS)
 		new |= ARM_V7S_ATTR_NS_TABLE;
 
@@ -779,6 +797,8 @@ static struct io_pgtable *arm_v7s_alloc_pgtable(struct io_pgtable_cfg *cfg,
 						void *cookie)
 {
 	struct arm_v7s_io_pgtable *data;
+	slab_flags_t slab_flag;
+	phys_addr_t paddr;
 
 	if (cfg->ias > (arm_v7s_is_mtk_enabled(cfg) ? 34 : ARM_V7S_ADDR_BITS))
 		return NULL;
@@ -788,7 +808,8 @@ static struct io_pgtable *arm_v7s_alloc_pgtable(struct io_pgtable_cfg *cfg,
 
 	if (cfg->quirks & ~(IO_PGTABLE_QUIRK_ARM_NS |
 			    IO_PGTABLE_QUIRK_NO_PERMS |
-			    IO_PGTABLE_QUIRK_ARM_MTK_EXT))
+			    IO_PGTABLE_QUIRK_ARM_MTK_EXT |
+			    IO_PGTABLE_QUIRK_ARM_MTK_TTBR_EXT))
 		return NULL;
 
 	/* If ARM_MTK_4GB is enabled, the NO_PERMS is also expected. */
@@ -796,15 +817,27 @@ static struct io_pgtable *arm_v7s_alloc_pgtable(struct io_pgtable_cfg *cfg,
 	    !(cfg->quirks & IO_PGTABLE_QUIRK_NO_PERMS))
 			return NULL;
 
+	if ((cfg->quirks & IO_PGTABLE_QUIRK_ARM_MTK_TTBR_EXT) &&
+	    !arm_v7s_is_mtk_enabled(cfg))
+		return NULL;
+
 	data = kmalloc(sizeof(*data), GFP_KERNEL);
 	if (!data)
 		return NULL;
 
 	spin_lock_init(&data->split_lock);
+
+	/*
+	 * ARM_MTK_TTBR_EXT extend the translation table base support larger
+	 * memory address.
+	 */
+	slab_flag = cfg->quirks & IO_PGTABLE_QUIRK_ARM_MTK_TTBR_EXT ?
+		    0 : ARM_V7S_TABLE_SLAB_FLAGS;
+
 	data->l2_tables = kmem_cache_create("io-pgtable_armv7s_l2",
 					    ARM_V7S_TABLE_SIZE(2, cfg),
 					    ARM_V7S_TABLE_SIZE(2, cfg),
-					    ARM_V7S_TABLE_SLAB_FLAGS, NULL);
+					    slab_flag, NULL);
 	if (!data->l2_tables)
 		goto out_free_data;
 
@@ -850,12 +883,16 @@ static struct io_pgtable *arm_v7s_alloc_pgtable(struct io_pgtable_cfg *cfg,
 	wmb();
 
 	/* TTBR */
-	cfg->arm_v7s_cfg.ttbr = virt_to_phys(data->pgd) | ARM_V7S_TTBR_S |
-				(cfg->coherent_walk ? (ARM_V7S_TTBR_NOS |
-				 ARM_V7S_TTBR_IRGN_ATTR(ARM_V7S_RGN_WBWA) |
-				 ARM_V7S_TTBR_ORGN_ATTR(ARM_V7S_RGN_WBWA)) :
-				(ARM_V7S_TTBR_IRGN_ATTR(ARM_V7S_RGN_NC) |
-				 ARM_V7S_TTBR_ORGN_ATTR(ARM_V7S_RGN_NC)));
+	paddr = virt_to_phys(data->pgd);
+	if (arm_v7s_is_mtk_enabled(cfg))
+		cfg->arm_v7s_cfg.ttbr = paddr | upper_32_bits(paddr);
+	else
+		cfg->arm_v7s_cfg.ttbr = paddr | ARM_V7S_TTBR_S |
+					(cfg->coherent_walk ? (ARM_V7S_TTBR_NOS |
+					 ARM_V7S_TTBR_IRGN_ATTR(ARM_V7S_RGN_WBWA) |
+					 ARM_V7S_TTBR_ORGN_ATTR(ARM_V7S_RGN_WBWA)) :
+					(ARM_V7S_TTBR_IRGN_ATTR(ARM_V7S_RGN_NC) |
+					 ARM_V7S_TTBR_ORGN_ATTR(ARM_V7S_RGN_NC)));
 	return &data->iop;
 
 out_free_data:
diff --git a/drivers/irqchip/irq-tegra.c b/drivers/irqchip/irq-tegra.c
index e1f771c72fc4..ad3e2c1b3c87 100644
--- a/drivers/irqchip/irq-tegra.c
+++ b/drivers/irqchip/irq-tegra.c
@@ -148,10 +148,10 @@ static int tegra_ictlr_suspend(void)
 		lic->cop_iep[i] = readl_relaxed(ictlr + ICTLR_COP_IEP_CLASS);
 
 		/* Disable COP interrupts */
-		writel_relaxed(~0ul, ictlr + ICTLR_COP_IER_CLR);
+		writel_relaxed(GENMASK(31, 0), ictlr + ICTLR_COP_IER_CLR);
 
 		/* Disable CPU interrupts */
-		writel_relaxed(~0ul, ictlr + ICTLR_CPU_IER_CLR);
+		writel_relaxed(GENMASK(31, 0), ictlr + ICTLR_CPU_IER_CLR);
 
 		/* Enable the wakeup sources of ictlr */
 		writel_relaxed(lic->ictlr_wake_mask[i], ictlr + ICTLR_CPU_IER_SET);
@@ -172,12 +172,12 @@ static void tegra_ictlr_resume(void)
 
 		writel_relaxed(lic->cpu_iep[i],
 			       ictlr + ICTLR_CPU_IEP_CLASS);
-		writel_relaxed(~0ul, ictlr + ICTLR_CPU_IER_CLR);
+		writel_relaxed(GENMASK(31, 0), ictlr + ICTLR_CPU_IER_CLR);
 		writel_relaxed(lic->cpu_ier[i],
 			       ictlr + ICTLR_CPU_IER_SET);
 		writel_relaxed(lic->cop_iep[i],
 			       ictlr + ICTLR_COP_IEP_CLASS);
-		writel_relaxed(~0ul, ictlr + ICTLR_COP_IER_CLR);
+		writel_relaxed(GENMASK(31, 0), ictlr + ICTLR_COP_IER_CLR);
 		writel_relaxed(lic->cop_ier[i],
 			       ictlr + ICTLR_COP_IER_SET);
 	}
@@ -312,7 +312,7 @@ static int __init tegra_ictlr_init(struct device_node *node,
 		lic->base[i] = base;
 
 		/* Disable all interrupts */
-		writel_relaxed(~0UL, base + ICTLR_CPU_IER_CLR);
+		writel_relaxed(GENMASK(31, 0), base + ICTLR_CPU_IER_CLR);
 		/* All interrupts target IRQ */
 		writel_relaxed(0, base + ICTLR_CPU_IEP_CLASS);
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 4bfaf7d4977d..33946adb0d6f 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9467,6 +9467,7 @@ void md_reap_sync_thread(struct mddev *mddev)
 	wake_up(&resync_wait);
 	/* flag recovery needed just to double check */
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+	sysfs_notify_dirent_safe(mddev->sysfs_completed);
 	sysfs_notify_dirent_safe(mddev->sysfs_action);
 	md_new_event(mddev);
 	if (mddev->event_work.func)
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index b58984ddca13..19e497a7e747 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2864,10 +2864,10 @@ static void raid5_end_write_request(struct bio *bi)
 	if (!test_and_clear_bit(R5_DOUBLE_LOCKED, &sh->dev[i].flags))
 		clear_bit(R5_LOCKED, &sh->dev[i].flags);
 	set_bit(STRIPE_HANDLE, &sh->state);
-	raid5_release_stripe(sh);
 
 	if (sh->batch_head && sh != sh->batch_head)
 		raid5_release_stripe(sh->batch_head);
+	raid5_release_stripe(sh);
 }
 
 static void raid5_error(struct mddev *mddev, struct md_rdev *rdev)
diff --git a/drivers/media/platform/qcom/venus/pm_helpers.c b/drivers/media/platform/qcom/venus/pm_helpers.c
index a591dd315ebc..03fc82cb3fea 100644
--- a/drivers/media/platform/qcom/venus/pm_helpers.c
+++ b/drivers/media/platform/qcom/venus/pm_helpers.c
@@ -875,7 +875,7 @@ static int vcodec_domains_get(struct venus_core *core)
 	}
 
 skip_pmdomains:
-	if (!core->has_opp_table)
+	if (!core->res->opp_pmdomain)
 		return 0;
 
 	/* Attach the power domain for setting performance state */
@@ -1007,6 +1007,10 @@ static int core_get_v4(struct venus_core *core)
 	if (ret)
 		return ret;
 
+	ret = vcodec_domains_get(core);
+	if (ret)
+		return ret;
+
 	if (core->res->opp_pmdomain) {
 		ret = devm_pm_opp_of_add_table(dev);
 		if (!ret) {
@@ -1017,10 +1021,6 @@ static int core_get_v4(struct venus_core *core)
 		}
 	}
 
-	ret = vcodec_domains_get(core);
-	if (ret)
-		return ret;
-
 	return 0;
 }
 
diff --git a/drivers/misc/cxl/irq.c b/drivers/misc/cxl/irq.c
index 4cb829d5d873..2e4dcfebf19a 100644
--- a/drivers/misc/cxl/irq.c
+++ b/drivers/misc/cxl/irq.c
@@ -349,6 +349,7 @@ int afu_allocate_irqs(struct cxl_context *ctx, u32 count)
 
 out:
 	cxl_ops->release_irq_ranges(&ctx->irqs, ctx->afu->adapter);
+	bitmap_free(ctx->irq_bitmap);
 	afu_irq_name_free(ctx);
 	return -ENOMEM;
 }
diff --git a/drivers/misc/habanalabs/gaudi/gaudi.c b/drivers/misc/habanalabs/gaudi/gaudi.c
index 14da87b38e83..8132200dca67 100644
--- a/drivers/misc/habanalabs/gaudi/gaudi.c
+++ b/drivers/misc/habanalabs/gaudi/gaudi.c
@@ -3318,19 +3318,19 @@ static void gaudi_init_nic_qman(struct hl_device *hdev, u32 nic_offset,
 	u32 nic_qm_err_cfg, irq_handler_offset;
 	u32 q_off;
 
-	mtr_base_en_lo = lower_32_bits(CFG_BASE +
+	mtr_base_en_lo = lower_32_bits((CFG_BASE & U32_MAX) +
 			mmSYNC_MNGR_E_N_SYNC_MNGR_OBJS_MON_PAY_ADDRL_0);
 	mtr_base_en_hi = upper_32_bits(CFG_BASE +
 				mmSYNC_MNGR_E_N_SYNC_MNGR_OBJS_MON_PAY_ADDRL_0);
-	so_base_en_lo = lower_32_bits(CFG_BASE +
+	so_base_en_lo = lower_32_bits((CFG_BASE & U32_MAX) +
 				mmSYNC_MNGR_E_N_SYNC_MNGR_OBJS_SOB_OBJ_0);
 	so_base_en_hi = upper_32_bits(CFG_BASE +
 				mmSYNC_MNGR_E_N_SYNC_MNGR_OBJS_SOB_OBJ_0);
-	mtr_base_ws_lo = lower_32_bits(CFG_BASE +
+	mtr_base_ws_lo = lower_32_bits((CFG_BASE & U32_MAX) +
 				mmSYNC_MNGR_W_S_SYNC_MNGR_OBJS_MON_PAY_ADDRL_0);
 	mtr_base_ws_hi = upper_32_bits(CFG_BASE +
 				mmSYNC_MNGR_W_S_SYNC_MNGR_OBJS_MON_PAY_ADDRL_0);
-	so_base_ws_lo = lower_32_bits(CFG_BASE +
+	so_base_ws_lo = lower_32_bits((CFG_BASE & U32_MAX) +
 				mmSYNC_MNGR_W_S_SYNC_MNGR_OBJS_SOB_OBJ_0);
 	so_base_ws_hi = upper_32_bits(CFG_BASE +
 				mmSYNC_MNGR_W_S_SYNC_MNGR_OBJS_SOB_OBJ_0);
@@ -5744,15 +5744,17 @@ static int gaudi_parse_cb_no_ext_queue(struct hl_device *hdev,
 {
 	struct asic_fixed_properties *asic_prop = &hdev->asic_prop;
 	struct gaudi_device *gaudi = hdev->asic_specific;
-	u32 nic_mask_q_id = 1 << (HW_CAP_NIC_SHIFT +
-		((parser->hw_queue_id - GAUDI_QUEUE_ID_NIC_0_0) >> 2));
+	u32 nic_queue_offset, nic_mask_q_id;
 
 	if ((parser->hw_queue_id >= GAUDI_QUEUE_ID_NIC_0_0) &&
-			(parser->hw_queue_id <= GAUDI_QUEUE_ID_NIC_9_3) &&
-			(!(gaudi->hw_cap_initialized & nic_mask_q_id))) {
-		dev_err(hdev->dev, "h/w queue %d is disabled\n",
-				parser->hw_queue_id);
-		return -EINVAL;
+			(parser->hw_queue_id <= GAUDI_QUEUE_ID_NIC_9_3)) {
+		nic_queue_offset = parser->hw_queue_id - GAUDI_QUEUE_ID_NIC_0_0;
+		nic_mask_q_id = 1 << (HW_CAP_NIC_SHIFT + (nic_queue_offset >> 2));
+
+		if (!(gaudi->hw_cap_initialized & nic_mask_q_id)) {
+			dev_err(hdev->dev, "h/w queue %d is disabled\n", parser->hw_queue_id);
+			return -EINVAL;
+		}
 	}
 
 	/* For internal queue jobs just check if CB address is valid */
diff --git a/drivers/misc/uacce/uacce.c b/drivers/misc/uacce/uacce.c
index 488eeb2811ae..976d051071dc 100644
--- a/drivers/misc/uacce/uacce.c
+++ b/drivers/misc/uacce/uacce.c
@@ -9,43 +9,38 @@
 
 static struct class *uacce_class;
 static dev_t uacce_devt;
-static DEFINE_MUTEX(uacce_mutex);
 static DEFINE_XARRAY_ALLOC(uacce_xa);
 
-static int uacce_start_queue(struct uacce_queue *q)
+/*
+ * If the parent driver or the device disappears, the queue state is invalid and
+ * ops are not usable anymore.
+ */
+static bool uacce_queue_is_valid(struct uacce_queue *q)
 {
-	int ret = 0;
+	return q->state == UACCE_Q_INIT || q->state == UACCE_Q_STARTED;
+}
 
-	mutex_lock(&uacce_mutex);
+static int uacce_start_queue(struct uacce_queue *q)
+{
+	int ret;
 
-	if (q->state != UACCE_Q_INIT) {
-		ret = -EINVAL;
-		goto out_with_lock;
-	}
+	if (q->state != UACCE_Q_INIT)
+		return -EINVAL;
 
 	if (q->uacce->ops->start_queue) {
 		ret = q->uacce->ops->start_queue(q);
 		if (ret < 0)
-			goto out_with_lock;
+			return ret;
 	}
 
 	q->state = UACCE_Q_STARTED;
-
-out_with_lock:
-	mutex_unlock(&uacce_mutex);
-
-	return ret;
+	return 0;
 }
 
 static int uacce_put_queue(struct uacce_queue *q)
 {
 	struct uacce_device *uacce = q->uacce;
 
-	mutex_lock(&uacce_mutex);
-
-	if (q->state == UACCE_Q_ZOMBIE)
-		goto out;
-
 	if ((q->state == UACCE_Q_STARTED) && uacce->ops->stop_queue)
 		uacce->ops->stop_queue(q);
 
@@ -54,8 +49,6 @@ static int uacce_put_queue(struct uacce_queue *q)
 		uacce->ops->put_queue(q);
 
 	q->state = UACCE_Q_ZOMBIE;
-out:
-	mutex_unlock(&uacce_mutex);
 
 	return 0;
 }
@@ -65,20 +58,36 @@ static long uacce_fops_unl_ioctl(struct file *filep,
 {
 	struct uacce_queue *q = filep->private_data;
 	struct uacce_device *uacce = q->uacce;
+	long ret = -ENXIO;
+
+	/*
+	 * uacce->ops->ioctl() may take the mmap_lock when copying arg to/from
+	 * user. Avoid a circular lock dependency with uacce_fops_mmap(), which
+	 * gets called with mmap_lock held, by taking uacce->mutex instead of
+	 * q->mutex. Doing this in uacce_fops_mmap() is not possible because
+	 * uacce_fops_open() calls iommu_sva_bind_device(), which takes
+	 * mmap_lock, while holding uacce->mutex.
+	 */
+	mutex_lock(&uacce->mutex);
+	if (!uacce_queue_is_valid(q))
+		goto out_unlock;
 
 	switch (cmd) {
 	case UACCE_CMD_START_Q:
-		return uacce_start_queue(q);
-
+		ret = uacce_start_queue(q);
+		break;
 	case UACCE_CMD_PUT_Q:
-		return uacce_put_queue(q);
-
+		ret = uacce_put_queue(q);
+		break;
 	default:
-		if (!uacce->ops->ioctl)
-			return -EINVAL;
-
-		return uacce->ops->ioctl(q, cmd, arg);
+		if (uacce->ops->ioctl)
+			ret = uacce->ops->ioctl(q, cmd, arg);
+		else
+			ret = -EINVAL;
 	}
+out_unlock:
+	mutex_unlock(&uacce->mutex);
+	return ret;
 }
 
 #ifdef CONFIG_COMPAT
@@ -136,6 +145,13 @@ static int uacce_fops_open(struct inode *inode, struct file *filep)
 	if (!q)
 		return -ENOMEM;
 
+	mutex_lock(&uacce->mutex);
+
+	if (!uacce->parent) {
+		ret = -EINVAL;
+		goto out_with_mem;
+	}
+
 	ret = uacce_bind_queue(uacce, q);
 	if (ret)
 		goto out_with_mem;
@@ -152,10 +168,9 @@ static int uacce_fops_open(struct inode *inode, struct file *filep)
 	filep->private_data = q;
 	uacce->inode = inode;
 	q->state = UACCE_Q_INIT;
-
-	mutex_lock(&uacce->queues_lock);
+	mutex_init(&q->mutex);
 	list_add(&q->list, &uacce->queues);
-	mutex_unlock(&uacce->queues_lock);
+	mutex_unlock(&uacce->mutex);
 
 	return 0;
 
@@ -163,18 +178,20 @@ static int uacce_fops_open(struct inode *inode, struct file *filep)
 	uacce_unbind_queue(q);
 out_with_mem:
 	kfree(q);
+	mutex_unlock(&uacce->mutex);
 	return ret;
 }
 
 static int uacce_fops_release(struct inode *inode, struct file *filep)
 {
 	struct uacce_queue *q = filep->private_data;
+	struct uacce_device *uacce = q->uacce;
 
-	mutex_lock(&q->uacce->queues_lock);
-	list_del(&q->list);
-	mutex_unlock(&q->uacce->queues_lock);
+	mutex_lock(&uacce->mutex);
 	uacce_put_queue(q);
 	uacce_unbind_queue(q);
+	list_del(&q->list);
+	mutex_unlock(&uacce->mutex);
 	kfree(q);
 
 	return 0;
@@ -217,10 +234,9 @@ static int uacce_fops_mmap(struct file *filep, struct vm_area_struct *vma)
 	vma->vm_private_data = q;
 	qfr->type = type;
 
-	mutex_lock(&uacce_mutex);
-
-	if (q->state != UACCE_Q_INIT && q->state != UACCE_Q_STARTED) {
-		ret = -EINVAL;
+	mutex_lock(&q->mutex);
+	if (!uacce_queue_is_valid(q)) {
+		ret = -ENXIO;
 		goto out_with_lock;
 	}
 
@@ -248,12 +264,12 @@ static int uacce_fops_mmap(struct file *filep, struct vm_area_struct *vma)
 	}
 
 	q->qfrs[type] = qfr;
-	mutex_unlock(&uacce_mutex);
+	mutex_unlock(&q->mutex);
 
 	return ret;
 
 out_with_lock:
-	mutex_unlock(&uacce_mutex);
+	mutex_unlock(&q->mutex);
 	kfree(qfr);
 	return ret;
 }
@@ -262,12 +278,20 @@ static __poll_t uacce_fops_poll(struct file *file, poll_table *wait)
 {
 	struct uacce_queue *q = file->private_data;
 	struct uacce_device *uacce = q->uacce;
+	__poll_t ret = 0;
+
+	mutex_lock(&q->mutex);
+	if (!uacce_queue_is_valid(q))
+		goto out_unlock;
 
 	poll_wait(file, &q->wait, wait);
+
 	if (uacce->ops->is_q_updated && uacce->ops->is_q_updated(q))
-		return EPOLLIN | EPOLLRDNORM;
+		ret = EPOLLIN | EPOLLRDNORM;
 
-	return 0;
+out_unlock:
+	mutex_unlock(&q->mutex);
+	return ret;
 }
 
 static const struct file_operations uacce_fops = {
@@ -450,7 +474,7 @@ struct uacce_device *uacce_alloc(struct device *parent,
 		goto err_with_uacce;
 
 	INIT_LIST_HEAD(&uacce->queues);
-	mutex_init(&uacce->queues_lock);
+	mutex_init(&uacce->mutex);
 	device_initialize(&uacce->dev);
 	uacce->dev.devt = MKDEV(MAJOR(uacce_devt), uacce->dev_id);
 	uacce->dev.class = uacce_class;
@@ -507,13 +531,23 @@ void uacce_remove(struct uacce_device *uacce)
 	if (uacce->inode)
 		unmap_mapping_range(uacce->inode->i_mapping, 0, 0, 1);
 
+	/*
+	 * uacce_fops_open() may be running concurrently, even after we remove
+	 * the cdev. Holding uacce->mutex ensures that open() does not obtain a
+	 * removed uacce device.
+	 */
+	mutex_lock(&uacce->mutex);
 	/* ensure no open queue remains */
-	mutex_lock(&uacce->queues_lock);
 	list_for_each_entry_safe(q, next_q, &uacce->queues, list) {
+		/*
+		 * Taking q->mutex ensures that fops do not use the defunct
+		 * uacce->ops after the queue is disabled.
+		 */
+		mutex_lock(&q->mutex);
 		uacce_put_queue(q);
+		mutex_unlock(&q->mutex);
 		uacce_unbind_queue(q);
 	}
-	mutex_unlock(&uacce->queues_lock);
 
 	/* disable sva now since no opened queues */
 	uacce_disable_sva(uacce);
@@ -521,6 +555,13 @@ void uacce_remove(struct uacce_device *uacce)
 	if (uacce->cdev)
 		cdev_device_del(uacce->cdev, &uacce->dev);
 	xa_erase(&uacce_xa, uacce->dev_id);
+	/*
+	 * uacce exists as long as there are open fds, but ops will be freed
+	 * now. Ensure that bugs cause NULL deref rather than use-after-free.
+	 */
+	uacce->ops = NULL;
+	uacce->parent = NULL;
+	mutex_unlock(&uacce->mutex);
 	put_device(&uacce->dev);
 }
 EXPORT_SYMBOL_GPL(uacce_remove);
diff --git a/drivers/mmc/host/meson-gx-mmc.c b/drivers/mmc/host/meson-gx-mmc.c
index 58ab9d90bc8b..9b2e2548bd18 100644
--- a/drivers/mmc/host/meson-gx-mmc.c
+++ b/drivers/mmc/host/meson-gx-mmc.c
@@ -1172,8 +1172,10 @@ static int meson_mmc_probe(struct platform_device *pdev)
 	}
 
 	ret = device_reset_optional(&pdev->dev);
-	if (ret)
-		return dev_err_probe(&pdev->dev, ret, "device reset failed\n");
+	if (ret) {
+		dev_err_probe(&pdev->dev, ret, "device reset failed\n");
+		goto free_host;
+	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	host->regs = devm_ioremap_resource(&pdev->dev, res);
diff --git a/drivers/mmc/host/pxamci.c b/drivers/mmc/host/pxamci.c
index 316393c694d7..55868b6b8658 100644
--- a/drivers/mmc/host/pxamci.c
+++ b/drivers/mmc/host/pxamci.c
@@ -648,7 +648,7 @@ static int pxamci_probe(struct platform_device *pdev)
 
 	ret = pxamci_of_init(pdev, mmc);
 	if (ret)
-		return ret;
+		goto out;
 
 	host = mmc_priv(mmc);
 	host->mmc = mmc;
@@ -672,7 +672,7 @@ static int pxamci_probe(struct platform_device *pdev)
 
 	ret = pxamci_init_ocr(host);
 	if (ret < 0)
-		return ret;
+		goto out;
 
 	mmc->caps = 0;
 	host->cmdat = 0;
diff --git a/drivers/mmc/host/renesas_sdhi_core.c b/drivers/mmc/host/renesas_sdhi_core.c
index 791e180a0617..387f2a4f693a 100644
--- a/drivers/mmc/host/renesas_sdhi_core.c
+++ b/drivers/mmc/host/renesas_sdhi_core.c
@@ -51,9 +51,6 @@
 #define HOST_MODE_GEN3_32BIT	(HOST_MODE_GEN3_WMODE | HOST_MODE_GEN3_BUSWIDTH)
 #define HOST_MODE_GEN3_64BIT	0
 
-#define CTL_SDIF_MODE	0xe6
-#define SDIF_MODE_HS400		BIT(0)
-
 #define SDHI_VER_GEN2_SDR50	0x490c
 #define SDHI_VER_RZ_A1		0x820b
 /* very old datasheets said 0x490c for SDR104, too. They are wrong! */
@@ -550,23 +547,25 @@ static void renesas_sdhi_scc_reset(struct tmio_mmc_host *host, struct renesas_sd
 }
 
 /* only populated for TMIO_MMC_MIN_RCAR2 */
-static void renesas_sdhi_reset(struct tmio_mmc_host *host)
+static void renesas_sdhi_reset(struct tmio_mmc_host *host, bool preserve)
 {
 	struct renesas_sdhi *priv = host_to_priv(host);
 	int ret;
 	u16 val;
 
-	if (priv->rstc) {
-		reset_control_reset(priv->rstc);
-		/* Unknown why but without polling reset status, it will hang */
-		read_poll_timeout(reset_control_status, ret, ret == 0, 1, 100,
-				  false, priv->rstc);
-		/* At least SDHI_VER_GEN2_SDR50 needs manual release of reset */
-		sd_ctrl_write16(host, CTL_RESET_SD, 0x0001);
-		priv->needs_adjust_hs400 = false;
-		renesas_sdhi_set_clock(host, host->clk_cache);
-	} else if (priv->scc_ctl) {
-		renesas_sdhi_scc_reset(host, priv);
+	if (!preserve) {
+		if (priv->rstc) {
+			reset_control_reset(priv->rstc);
+			/* Unknown why but without polling reset status, it will hang */
+			read_poll_timeout(reset_control_status, ret, ret == 0, 1, 100,
+					  false, priv->rstc);
+			/* At least SDHI_VER_GEN2_SDR50 needs manual release of reset */
+			sd_ctrl_write16(host, CTL_RESET_SD, 0x0001);
+			priv->needs_adjust_hs400 = false;
+			renesas_sdhi_set_clock(host, host->clk_cache);
+		} else if (priv->scc_ctl) {
+			renesas_sdhi_scc_reset(host, priv);
+		}
 	}
 
 	if (sd_ctrl_read16(host, CTL_VERSION) >= SDHI_VER_GEN3_SD) {
diff --git a/drivers/mmc/host/tmio_mmc.c b/drivers/mmc/host/tmio_mmc.c
index b55a29c53d9c..53a2ad9a24b8 100644
--- a/drivers/mmc/host/tmio_mmc.c
+++ b/drivers/mmc/host/tmio_mmc.c
@@ -75,7 +75,7 @@ static void tmio_mmc_set_clock(struct tmio_mmc_host *host,
 	tmio_mmc_clk_start(host);
 }
 
-static void tmio_mmc_reset(struct tmio_mmc_host *host)
+static void tmio_mmc_reset(struct tmio_mmc_host *host, bool preserve)
 {
 	sd_ctrl_write16(host, CTL_RESET_SDIO, 0x0000);
 	usleep_range(10000, 11000);
diff --git a/drivers/mmc/host/tmio_mmc.h b/drivers/mmc/host/tmio_mmc.h
index f936aad945ce..da63193dd45b 100644
--- a/drivers/mmc/host/tmio_mmc.h
+++ b/drivers/mmc/host/tmio_mmc.h
@@ -42,6 +42,7 @@
 #define CTL_DMA_ENABLE 0xd8
 #define CTL_RESET_SD 0xe0
 #define CTL_VERSION 0xe2
+#define CTL_SDIF_MODE 0xe6 /* only known on R-Car 2+ */
 
 /* Definitions for values the CTL_STOP_INTERNAL_ACTION register can take */
 #define TMIO_STOP_STP		BIT(0)
@@ -98,6 +99,9 @@
 /* Definitions for values the CTL_DMA_ENABLE register can take */
 #define DMA_ENABLE_DMASDRW	BIT(1)
 
+/* Definitions for values the CTL_SDIF_MODE register can take */
+#define SDIF_MODE_HS400		BIT(0) /* only known on R-Car 2+ */
+
 /* Define some IRQ masks */
 /* This is the mask used at reset by the chip */
 #define TMIO_MASK_ALL           0x837f031d
@@ -181,7 +185,7 @@ struct tmio_mmc_host {
 	int (*multi_io_quirk)(struct mmc_card *card,
 			      unsigned int direction, int blk_size);
 	int (*write16_hook)(struct tmio_mmc_host *host, int addr);
-	void (*reset)(struct tmio_mmc_host *host);
+	void (*reset)(struct tmio_mmc_host *host, bool preserve);
 	bool (*check_retune)(struct tmio_mmc_host *host, struct mmc_request *mrq);
 	void (*fixup_request)(struct tmio_mmc_host *host, struct mmc_request *mrq);
 	unsigned int (*get_timeout_cycles)(struct tmio_mmc_host *host);
diff --git a/drivers/mmc/host/tmio_mmc_core.c b/drivers/mmc/host/tmio_mmc_core.c
index a5850d83908b..437048bb8027 100644
--- a/drivers/mmc/host/tmio_mmc_core.c
+++ b/drivers/mmc/host/tmio_mmc_core.c
@@ -179,8 +179,17 @@ static void tmio_mmc_set_bus_width(struct tmio_mmc_host *host,
 	sd_ctrl_write16(host, CTL_SD_MEM_CARD_OPT, reg);
 }
 
-static void tmio_mmc_reset(struct tmio_mmc_host *host)
+static void tmio_mmc_reset(struct tmio_mmc_host *host, bool preserve)
 {
+	u16 card_opt, clk_ctrl, sdif_mode;
+
+	if (preserve) {
+		card_opt = sd_ctrl_read16(host, CTL_SD_MEM_CARD_OPT);
+		clk_ctrl = sd_ctrl_read16(host, CTL_SD_CARD_CLK_CTL);
+		if (host->pdata->flags & TMIO_MMC_MIN_RCAR2)
+			sdif_mode = sd_ctrl_read16(host, CTL_SDIF_MODE);
+	}
+
 	/* FIXME - should we set stop clock reg here */
 	sd_ctrl_write16(host, CTL_RESET_SD, 0x0000);
 	usleep_range(10000, 11000);
@@ -190,7 +199,7 @@ static void tmio_mmc_reset(struct tmio_mmc_host *host)
 	tmio_mmc_abort_dma(host);
 
 	if (host->reset)
-		host->reset(host);
+		host->reset(host, preserve);
 
 	sd_ctrl_write32_as_16_and_16(host, CTL_IRQ_MASK, host->sdcard_irq_mask_all);
 	host->sdcard_irq_mask = host->sdcard_irq_mask_all;
@@ -206,6 +215,13 @@ static void tmio_mmc_reset(struct tmio_mmc_host *host)
 		sd_ctrl_write16(host, CTL_TRANSACTION_CTL, 0x0001);
 	}
 
+	if (preserve) {
+		sd_ctrl_write16(host, CTL_SD_MEM_CARD_OPT, card_opt);
+		sd_ctrl_write16(host, CTL_SD_CARD_CLK_CTL, clk_ctrl);
+		if (host->pdata->flags & TMIO_MMC_MIN_RCAR2)
+			sd_ctrl_write16(host, CTL_SDIF_MODE, sdif_mode);
+	}
+
 	if (host->mmc->card)
 		mmc_retune_needed(host->mmc);
 }
@@ -248,7 +264,7 @@ static void tmio_mmc_reset_work(struct work_struct *work)
 
 	spin_unlock_irqrestore(&host->lock, flags);
 
-	tmio_mmc_reset(host);
+	tmio_mmc_reset(host, true);
 
 	/* Ready for new calls */
 	host->mrq = NULL;
@@ -961,7 +977,7 @@ static void tmio_mmc_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 		tmio_mmc_power_off(host);
 		/* For R-Car Gen2+, we need to reset SDHI specific SCC */
 		if (host->pdata->flags & TMIO_MMC_MIN_RCAR2)
-			tmio_mmc_reset(host);
+			tmio_mmc_reset(host, false);
 
 		host->set_clock(host, 0);
 		break;
@@ -1189,7 +1205,7 @@ int tmio_mmc_host_probe(struct tmio_mmc_host *_host)
 		_host->sdcard_irq_mask_all = TMIO_MASK_ALL;
 
 	_host->set_clock(_host, 0);
-	tmio_mmc_reset(_host);
+	tmio_mmc_reset(_host, false);
 
 	spin_lock_init(&_host->lock);
 	mutex_init(&_host->ios_lock);
@@ -1285,7 +1301,7 @@ int tmio_mmc_host_runtime_resume(struct device *dev)
 	struct tmio_mmc_host *host = dev_get_drvdata(dev);
 
 	tmio_mmc_clk_enable(host);
-	tmio_mmc_reset(host);
+	tmio_mmc_reset(host, false);
 
 	if (host->clk_cache)
 		host->set_clock(host, host->clk_cache);
diff --git a/drivers/net/can/spi/mcp251x.c b/drivers/net/can/spi/mcp251x.c
index 0579ab74f728..baab3adc34bc 100644
--- a/drivers/net/can/spi/mcp251x.c
+++ b/drivers/net/can/spi/mcp251x.c
@@ -1074,9 +1074,6 @@ static irqreturn_t mcp251x_can_ist(int irq, void *dev_id)
 
 		mcp251x_read_2regs(spi, CANINTF, &intf, &eflag);
 
-		/* mask out flags we don't care about */
-		intf &= CANINTF_RX | CANINTF_TX | CANINTF_ERR;
-
 		/* receive buffer 0 */
 		if (intf & CANINTF_RX0IF) {
 			mcp251x_hw_rx(spi, 0);
@@ -1086,6 +1083,18 @@ static irqreturn_t mcp251x_can_ist(int irq, void *dev_id)
 			if (mcp251x_is_2510(spi))
 				mcp251x_write_bits(spi, CANINTF,
 						   CANINTF_RX0IF, 0x00);
+
+			/* check if buffer 1 is already known to be full, no need to re-read */
+			if (!(intf & CANINTF_RX1IF)) {
+				u8 intf1, eflag1;
+
+				/* intf needs to be read again to avoid a race condition */
+				mcp251x_read_2regs(spi, CANINTF, &intf1, &eflag1);
+
+				/* combine flags from both operations for error handling */
+				intf |= intf1;
+				eflag |= eflag1;
+			}
 		}
 
 		/* receive buffer 1 */
@@ -1096,6 +1105,9 @@ static irqreturn_t mcp251x_can_ist(int irq, void *dev_id)
 				clear_intf |= CANINTF_RX1IF;
 		}
 
+		/* mask out flags we don't care about */
+		intf &= CANINTF_RX | CANINTF_TX | CANINTF_ERR;
+
 		/* any error or tx interrupt we need to clear? */
 		if (intf & (CANINTF_ERR | CANINTF_TX))
 			clear_intf |= intf & (CANINTF_ERR | CANINTF_TX);
diff --git a/drivers/net/can/usb/ems_usb.c b/drivers/net/can/usb/ems_usb.c
index c9552846fe25..a1b7c1a451c0 100644
--- a/drivers/net/can/usb/ems_usb.c
+++ b/drivers/net/can/usb/ems_usb.c
@@ -194,7 +194,7 @@ struct __packed ems_cpc_msg {
 	__le32 ts_sec;	/* timestamp in seconds */
 	__le32 ts_nsec;	/* timestamp in nano seconds */
 
-	union {
+	union __packed {
 		u8 generic[64];
 		struct cpc_can_msg can_msg;
 		struct cpc_can_params can_params;
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 854e25f43fa7..379b38c5844f 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -759,6 +759,9 @@ static int ksz9477_port_fdb_dump(struct dsa_switch *ds, int port,
 			goto exit;
 		}
 
+		if (!(ksz_data & ALU_VALID))
+			continue;
+
 		/* read ALU table */
 		ksz9477_read_table(dev, alu_table);
 
diff --git a/drivers/net/dsa/mv88e6060.c b/drivers/net/dsa/mv88e6060.c
index a4c6eb9a52d0..83dca9179aa0 100644
--- a/drivers/net/dsa/mv88e6060.c
+++ b/drivers/net/dsa/mv88e6060.c
@@ -118,6 +118,9 @@ static int mv88e6060_setup_port(struct mv88e6060_priv *priv, int p)
 	int addr = REG_PORT(p);
 	int ret;
 
+	if (dsa_is_unused_port(priv->ds, p))
+		return 0;
+
 	/* Do not force flow control, disable Ingress and Egress
 	 * Header tagging, disable VLAN tunneling, and set the port
 	 * state to Forwarding.  Additionally, if this is the CPU
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index a9c7ada890d8..5ba7e5c820dd 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -578,7 +578,8 @@ static const struct ocelot_stat_layout vsc9959_stats_layout[] = {
 	{ .offset = 0x87,	.name = "tx_frames_below_65_octets", },
 	{ .offset = 0x88,	.name = "tx_frames_65_to_127_octets", },
 	{ .offset = 0x89,	.name = "tx_frames_128_255_octets", },
-	{ .offset = 0x8B,	.name = "tx_frames_256_511_octets", },
+	{ .offset = 0x8A,	.name = "tx_frames_256_511_octets", },
+	{ .offset = 0x8B,	.name = "tx_frames_512_1023_octets", },
 	{ .offset = 0x8C,	.name = "tx_frames_1024_1526_octets", },
 	{ .offset = 0x8D,	.name = "tx_frames_over_1526_octets", },
 	{ .offset = 0x8E,	.name = "tx_yellow_prio_0", },
diff --git a/drivers/net/dsa/sja1105/sja1105_devlink.c b/drivers/net/dsa/sja1105/sja1105_devlink.c
index 0569ff066634..10c6fea1227f 100644
--- a/drivers/net/dsa/sja1105/sja1105_devlink.c
+++ b/drivers/net/dsa/sja1105/sja1105_devlink.c
@@ -93,7 +93,7 @@ static int sja1105_setup_devlink_regions(struct dsa_switch *ds)
 
 		region = dsa_devlink_region_create(ds, ops, 1, size);
 		if (IS_ERR(region)) {
-			while (i-- >= 0)
+			while (--i >= 0)
 				dsa_devlink_region_destroy(priv->regions[i]);
 			return PTR_ERR(region);
 		}
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index fbb1e05d5878..ea2e7cd8946d 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -265,12 +265,10 @@ static void aq_nic_service_timer_cb(struct timer_list *t)
 static void aq_nic_polling_timer_cb(struct timer_list *t)
 {
 	struct aq_nic_s *self = from_timer(self, t, polling_timer);
-	struct aq_vec_s *aq_vec = NULL;
 	unsigned int i = 0U;
 
-	for (i = 0U, aq_vec = self->aq_vec[0];
-		self->aq_vecs > i; ++i, aq_vec = self->aq_vec[i])
-		aq_vec_isr(i, (void *)aq_vec);
+	for (i = 0U; self->aq_vecs > i; ++i)
+		aq_vec_isr(i, (void *)self->aq_vec[i]);
 
 	mod_timer(&self->polling_timer, jiffies +
 		  AQ_CFG_POLLING_TIMER_INTERVAL);
@@ -872,7 +870,6 @@ int aq_nic_get_regs_count(struct aq_nic_s *self)
 
 u64 *aq_nic_get_stats(struct aq_nic_s *self, u64 *data)
 {
-	struct aq_vec_s *aq_vec = NULL;
 	struct aq_stats_s *stats;
 	unsigned int count = 0U;
 	unsigned int i = 0U;
@@ -922,11 +919,11 @@ u64 *aq_nic_get_stats(struct aq_nic_s *self, u64 *data)
 	data += i;
 
 	for (tc = 0U; tc < self->aq_nic_cfg.tcs; tc++) {
-		for (i = 0U, aq_vec = self->aq_vec[0];
-		     aq_vec && self->aq_vecs > i;
-		     ++i, aq_vec = self->aq_vec[i]) {
+		for (i = 0U; self->aq_vecs > i; ++i) {
+			if (!self->aq_vec[i])
+				break;
 			data += count;
-			count = aq_vec_get_sw_stats(aq_vec, tc, data);
+			count = aq_vec_get_sw_stats(self->aq_vec[i], tc, data);
 		}
 	}
 
@@ -1240,7 +1237,6 @@ int aq_nic_set_loopback(struct aq_nic_s *self)
 
 int aq_nic_stop(struct aq_nic_s *self)
 {
-	struct aq_vec_s *aq_vec = NULL;
 	unsigned int i = 0U;
 
 	netif_tx_disable(self->ndev);
@@ -1258,9 +1254,8 @@ int aq_nic_stop(struct aq_nic_s *self)
 
 	aq_ptp_irq_free(self);
 
-	for (i = 0U, aq_vec = self->aq_vec[0];
-		self->aq_vecs > i; ++i, aq_vec = self->aq_vec[i])
-		aq_vec_stop(aq_vec);
+	for (i = 0U; self->aq_vecs > i; ++i)
+		aq_vec_stop(self->aq_vec[i]);
 
 	aq_ptp_ring_stop(self);
 
diff --git a/drivers/net/ethernet/broadcom/bgmac.c b/drivers/net/ethernet/broadcom/bgmac.c
index fe4d99abd548..6e8bc6726031 100644
--- a/drivers/net/ethernet/broadcom/bgmac.c
+++ b/drivers/net/ethernet/broadcom/bgmac.c
@@ -189,8 +189,8 @@ static netdev_tx_t bgmac_dma_tx_add(struct bgmac *bgmac,
 	}
 
 	slot->skb = skb;
-	ring->end += nr_frags + 1;
 	netdev_sent_queue(net_dev, skb->len);
+	ring->end += nr_frags + 1;
 
 	wmb();
 
diff --git a/drivers/net/ethernet/broadcom/genet/bcmmii.c b/drivers/net/ethernet/broadcom/genet/bcmmii.c
index 89d16c587bb7..dbd2ede53f94 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
@@ -361,6 +361,9 @@ int bcmgenet_mii_probe(struct net_device *dev)
 	if (priv->internal_phy && !GENET_IS_V5(priv))
 		dev->phydev->irq = PHY_MAC_INTERRUPT;
 
+	/* Indicate that the MAC is responsible for PHY PM */
+	dev->phydev->mac_managed_pm = true;
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 8b7a29e1e221..5899139aec97 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -1389,8 +1389,8 @@ static int dpaa2_eth_add_bufs(struct dpaa2_eth_priv *priv,
 		buf_array[i] = addr;
 
 		/* tracing point */
-		trace_dpaa2_eth_buf_seed(priv->net_dev,
-					 page, DPAA2_ETH_RX_BUF_RAW_SIZE,
+		trace_dpaa2_eth_buf_seed(priv->net_dev, page_address(page),
+					 DPAA2_ETH_RX_BUF_RAW_SIZE,
 					 addr, priv->rx_buf_size,
 					 bpid);
 	}
diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/ethernet/freescale/fec_ptp.c
index d71eac7e1924..c5ae67300590 100644
--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -136,11 +136,7 @@ static int fec_ptp_enable_pps(struct fec_enet_private *fep, uint enable)
 		 * NSEC_PER_SEC - ts.tv_nsec. Add the remaining nanoseconds
 		 * to current timer would be next second.
 		 */
-		tempval = readl(fep->hwp + FEC_ATIME_CTRL);
-		tempval |= FEC_T_CTRL_CAPTURE;
-		writel(tempval, fep->hwp + FEC_ATIME_CTRL);
-
-		tempval = readl(fep->hwp + FEC_ATIME);
+		tempval = fep->cc.read(&fep->cc);
 		/* Convert the ptp local counter to 1588 timestamp */
 		ns = timecounter_cyc2time(&fep->tc, tempval);
 		ts = ns_to_timespec64(ns);
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index b07d55c99317..536f9198bd47 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -383,7 +383,9 @@ static void i40e_tx_timeout(struct net_device *netdev, unsigned int txqueue)
 		set_bit(__I40E_GLOBAL_RESET_REQUESTED, pf->state);
 		break;
 	default:
-		netdev_err(netdev, "tx_timeout recovery unsuccessful\n");
+		netdev_err(netdev, "tx_timeout recovery unsuccessful, device is in non-recoverable state.\n");
+		set_bit(__I40E_DOWN_REQUESTED, pf->state);
+		set_bit(__I40E_VSI_DOWN_REQUESTED, vsi->state);
 		break;
 	}
 
diff --git a/drivers/net/ethernet/intel/iavf/iavf_adminq.c b/drivers/net/ethernet/intel/iavf/iavf_adminq.c
index 9fa3fa99b4c2..897b349cdaf1 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_adminq.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_adminq.c
@@ -324,6 +324,7 @@ static enum iavf_status iavf_config_arq_regs(struct iavf_hw *hw)
 static enum iavf_status iavf_init_asq(struct iavf_hw *hw)
 {
 	enum iavf_status ret_code = 0;
+	int i;
 
 	if (hw->aq.asq.count > 0) {
 		/* queue already initialized */
@@ -354,12 +355,17 @@ static enum iavf_status iavf_init_asq(struct iavf_hw *hw)
 	/* initialize base registers */
 	ret_code = iavf_config_asq_regs(hw);
 	if (ret_code)
-		goto init_adminq_free_rings;
+		goto init_free_asq_bufs;
 
 	/* success! */
 	hw->aq.asq.count = hw->aq.num_asq_entries;
 	goto init_adminq_exit;
 
+init_free_asq_bufs:
+	for (i = 0; i < hw->aq.num_asq_entries; i++)
+		iavf_free_dma_mem(hw, &hw->aq.asq.r.asq_bi[i]);
+	iavf_free_virt_mem(hw, &hw->aq.asq.dma_head);
+
 init_adminq_free_rings:
 	iavf_free_adminq_asq(hw);
 
@@ -383,6 +389,7 @@ static enum iavf_status iavf_init_asq(struct iavf_hw *hw)
 static enum iavf_status iavf_init_arq(struct iavf_hw *hw)
 {
 	enum iavf_status ret_code = 0;
+	int i;
 
 	if (hw->aq.arq.count > 0) {
 		/* queue already initialized */
@@ -413,12 +420,16 @@ static enum iavf_status iavf_init_arq(struct iavf_hw *hw)
 	/* initialize base registers */
 	ret_code = iavf_config_arq_regs(hw);
 	if (ret_code)
-		goto init_adminq_free_rings;
+		goto init_free_arq_bufs;
 
 	/* success! */
 	hw->aq.arq.count = hw->aq.num_arq_entries;
 	goto init_adminq_exit;
 
+init_free_arq_bufs:
+	for (i = 0; i < hw->aq.num_arq_entries; i++)
+		iavf_free_dma_mem(hw, &hw->aq.arq.r.arq_bi[i]);
+	iavf_free_virt_mem(hw, &hw->aq.arq.dma_head);
 init_adminq_free_rings:
 	iavf_free_adminq_arq(hw);
 
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index e2349131a428..db95786c3419 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -2414,12 +2414,15 @@ static void iavf_reset_task(struct work_struct *work)
 
 	return;
 reset_err:
+	if (running) {
+		set_bit(__IAVF_VSI_DOWN, adapter->vsi.state);
+		iavf_free_traffic_irqs(adapter);
+	}
+	iavf_disable_vf(adapter);
+
 	mutex_unlock(&adapter->client_lock);
 	mutex_unlock(&adapter->crit_lock);
-	if (running)
-		iavf_change_state(adapter, __IAVF_RUNNING);
 	dev_err(&adapter->pdev->dev, "failed to allocate resources during reinit\n");
-	iavf_close(netdev);
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index 3b6c1420aa7b..deb828e761fa 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -2614,7 +2614,7 @@ ice_set_vlan_vsi_promisc(struct ice_hw *hw, u16 vsi_handle, u8 promisc_mask,
 		else
 			status = ice_set_vsi_promisc(hw, vsi_handle,
 						     promisc_mask, vlan_id);
-		if (status)
+		if (status && status != -EEXIST)
 			break;
 	}
 
diff --git a/drivers/net/ethernet/intel/igb/igb.h b/drivers/net/ethernet/intel/igb/igb.h
index 2d3daf022651..015b78144114 100644
--- a/drivers/net/ethernet/intel/igb/igb.h
+++ b/drivers/net/ethernet/intel/igb/igb.h
@@ -664,6 +664,8 @@ struct igb_adapter {
 	struct igb_mac_addr *mac_table;
 	struct vf_mac_filter vf_macs;
 	struct vf_mac_filter *vf_mac_list;
+	/* lock for VF resources */
+	spinlock_t vfs_lock;
 };
 
 /* flags controlling PTP/1588 function */
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index db11a1c278f6..f19e64830739 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -3637,6 +3637,7 @@ static int igb_disable_sriov(struct pci_dev *pdev)
 	struct net_device *netdev = pci_get_drvdata(pdev);
 	struct igb_adapter *adapter = netdev_priv(netdev);
 	struct e1000_hw *hw = &adapter->hw;
+	unsigned long flags;
 
 	/* reclaim resources allocated to VFs */
 	if (adapter->vf_data) {
@@ -3649,12 +3650,13 @@ static int igb_disable_sriov(struct pci_dev *pdev)
 			pci_disable_sriov(pdev);
 			msleep(500);
 		}
-
+		spin_lock_irqsave(&adapter->vfs_lock, flags);
 		kfree(adapter->vf_mac_list);
 		adapter->vf_mac_list = NULL;
 		kfree(adapter->vf_data);
 		adapter->vf_data = NULL;
 		adapter->vfs_allocated_count = 0;
+		spin_unlock_irqrestore(&adapter->vfs_lock, flags);
 		wr32(E1000_IOVCTL, E1000_IOVCTL_REUSE_VFQ);
 		wrfl();
 		msleep(100);
@@ -3814,7 +3816,9 @@ static void igb_remove(struct pci_dev *pdev)
 	igb_release_hw_control(adapter);
 
 #ifdef CONFIG_PCI_IOV
+	rtnl_lock();
 	igb_disable_sriov(pdev);
+	rtnl_unlock();
 #endif
 
 	unregister_netdev(netdev);
@@ -3974,6 +3978,9 @@ static int igb_sw_init(struct igb_adapter *adapter)
 
 	spin_lock_init(&adapter->nfc_lock);
 	spin_lock_init(&adapter->stats64_lock);
+
+	/* init spinlock to avoid concurrency of VF resources */
+	spin_lock_init(&adapter->vfs_lock);
 #ifdef CONFIG_PCI_IOV
 	switch (hw->mac.type) {
 	case e1000_82576:
@@ -7846,8 +7853,10 @@ static void igb_rcv_msg_from_vf(struct igb_adapter *adapter, u32 vf)
 static void igb_msg_task(struct igb_adapter *adapter)
 {
 	struct e1000_hw *hw = &adapter->hw;
+	unsigned long flags;
 	u32 vf;
 
+	spin_lock_irqsave(&adapter->vfs_lock, flags);
 	for (vf = 0; vf < adapter->vfs_allocated_count; vf++) {
 		/* process any reset requests */
 		if (!igb_check_for_rst(hw, vf))
@@ -7861,6 +7870,7 @@ static void igb_msg_task(struct igb_adapter *adapter)
 		if (!igb_check_for_ack(hw, vf))
 			igb_rcv_ack_from_vf(adapter, vf);
 	}
+	spin_unlock_irqrestore(&adapter->vfs_lock, flags);
 }
 
 /**
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index 11ef46e72ddd..bd33b90aaa67 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -2504,6 +2504,12 @@ static void __rvu_flr_handler(struct rvu *rvu, u16 pcifunc)
 	rvu_blklf_teardown(rvu, pcifunc, BLKADDR_NPA);
 	rvu_reset_lmt_map_tbl(rvu, pcifunc);
 	rvu_detach_rsrcs(rvu, NULL, pcifunc);
+	/* In scenarios where PF/VF drivers detach NIXLF without freeing MCAM
+	 * entries, check and free the MCAM entries explicitly to avoid leak.
+	 * Since LF is detached use LF number as -1.
+	 */
+	rvu_npc_free_mcam_entries(rvu, pcifunc, -1);
+
 	mutex_unlock(&rvu->flr_lock);
 }
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index c4a46b295d40..d1249da7a18f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -1096,6 +1096,9 @@ static void npc_enadis_default_entries(struct rvu *rvu, u16 pcifunc,
 
 void rvu_npc_disable_default_entries(struct rvu *rvu, u16 pcifunc, int nixlf)
 {
+	if (nixlf < 0)
+		return;
+
 	npc_enadis_default_entries(rvu, pcifunc, nixlf, false);
 
 	/* Delete multicast and promisc MCAM entries */
@@ -1107,6 +1110,9 @@ void rvu_npc_disable_default_entries(struct rvu *rvu, u16 pcifunc, int nixlf)
 
 void rvu_npc_enable_default_entries(struct rvu *rvu, u16 pcifunc, int nixlf)
 {
+	if (nixlf < 0)
+		return;
+
 	/* Enables only broadcast match entry. Promisc/Allmulti are enabled
 	 * in set_rx_mode mbox handler.
 	 */
@@ -1650,7 +1656,7 @@ static void npc_load_kpu_profile(struct rvu *rvu)
 	 * Firmware database method.
 	 * Default KPU profile.
 	 */
-	if (!request_firmware(&fw, kpu_profile, rvu->dev)) {
+	if (!request_firmware_direct(&fw, kpu_profile, rvu->dev)) {
 		dev_info(rvu->dev, "Loading KPU profile from firmware: %s\n",
 			 kpu_profile);
 		rvu->kpu_fwdata = kzalloc(fw->size, GFP_KERNEL);
@@ -1915,6 +1921,7 @@ static void rvu_npc_hw_init(struct rvu *rvu, int blkaddr)
 
 static void rvu_npc_setup_interfaces(struct rvu *rvu, int blkaddr)
 {
+	struct npc_mcam_kex *mkex = rvu->kpu.mkex;
 	struct npc_mcam *mcam = &rvu->hw->mcam;
 	struct rvu_hwinfo *hw = rvu->hw;
 	u64 nibble_ena, rx_kex, tx_kex;
@@ -1927,15 +1934,15 @@ static void rvu_npc_setup_interfaces(struct rvu *rvu, int blkaddr)
 	mcam->counters.max--;
 	mcam->rx_miss_act_cntr = mcam->counters.max;
 
-	rx_kex = npc_mkex_default.keyx_cfg[NIX_INTF_RX];
-	tx_kex = npc_mkex_default.keyx_cfg[NIX_INTF_TX];
+	rx_kex = mkex->keyx_cfg[NIX_INTF_RX];
+	tx_kex = mkex->keyx_cfg[NIX_INTF_TX];
 	nibble_ena = FIELD_GET(NPC_PARSE_NIBBLE, rx_kex);
 
 	nibble_ena = rvu_npc_get_tx_nibble_cfg(rvu, nibble_ena);
 	if (nibble_ena) {
 		tx_kex &= ~NPC_PARSE_NIBBLE;
 		tx_kex |= FIELD_PREP(NPC_PARSE_NIBBLE, nibble_ena);
-		npc_mkex_default.keyx_cfg[NIX_INTF_TX] = tx_kex;
+		mkex->keyx_cfg[NIX_INTF_TX] = tx_kex;
 	}
 
 	/* Configure RX interfaces */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
index ca404d51d9f5..750aaa167687 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
@@ -445,7 +445,8 @@ do {									       \
 	NPC_SCAN_HDR(NPC_VLAN_TAG1, NPC_LID_LB, NPC_LT_LB_CTAG, 2, 2);
 	NPC_SCAN_HDR(NPC_VLAN_TAG2, NPC_LID_LB, NPC_LT_LB_STAG_QINQ, 2, 2);
 	NPC_SCAN_HDR(NPC_DMAC, NPC_LID_LA, la_ltype, la_start, 6);
-	NPC_SCAN_HDR(NPC_SMAC, NPC_LID_LA, la_ltype, la_start, 6);
+	/* SMAC follows the DMAC(which is 6 bytes) */
+	NPC_SCAN_HDR(NPC_SMAC, NPC_LID_LA, la_ltype, la_start + 6, 6);
 	/* PF_FUNC is 2 bytes at 0th byte of NPC_LT_LA_IH_NIX_ETHER */
 	NPC_SCAN_HDR(NPC_PF_FUNC, NPC_LID_LA, NPC_LT_LA_IH_NIX_ETHER, 0, 2);
 }
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 78df173e6df2..7cf24dd5c878 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -631,6 +631,12 @@ int otx2_txschq_config(struct otx2_nic *pfvf, int lvl)
 		req->num_regs++;
 		req->reg[1] = NIX_AF_TL3X_SCHEDULE(schq);
 		req->regval[1] = dwrr_val;
+		if (lvl == hw->txschq_link_cfg_lvl) {
+			req->num_regs++;
+			req->reg[2] = NIX_AF_TL3_TL2X_LINKX_CFG(schq, hw->tx_link);
+			/* Enable this queue and backpressure */
+			req->regval[2] = BIT_ULL(13) | BIT_ULL(12);
+		}
 	} else if (lvl == NIX_TXSCH_LVL_TL2) {
 		parent =  hw->txschq_list[NIX_TXSCH_LVL_TL1][0];
 		req->reg[0] = NIX_AF_TL2X_PARENT(schq);
@@ -640,11 +646,12 @@ int otx2_txschq_config(struct otx2_nic *pfvf, int lvl)
 		req->reg[1] = NIX_AF_TL2X_SCHEDULE(schq);
 		req->regval[1] = TXSCH_TL1_DFLT_RR_PRIO << 24 | dwrr_val;
 
-		req->num_regs++;
-		req->reg[2] = NIX_AF_TL3_TL2X_LINKX_CFG(schq, hw->tx_link);
-		/* Enable this queue and backpressure */
-		req->regval[2] = BIT_ULL(13) | BIT_ULL(12);
-
+		if (lvl == hw->txschq_link_cfg_lvl) {
+			req->num_regs++;
+			req->reg[2] = NIX_AF_TL3_TL2X_LINKX_CFG(schq, hw->tx_link);
+			/* Enable this queue and backpressure */
+			req->regval[2] = BIT_ULL(13) | BIT_ULL(12);
+		}
 	} else if (lvl == NIX_TXSCH_LVL_TL1) {
 		/* Default config for TL1.
 		 * For VF this is always ignored.
@@ -1563,6 +1570,8 @@ void mbox_handler_nix_txsch_alloc(struct otx2_nic *pf,
 		for (schq = 0; schq < rsp->schq[lvl]; schq++)
 			pf->hw.txschq_list[lvl][schq] =
 				rsp->schq_list[lvl][schq];
+
+	pf->hw.txschq_link_cfg_lvl = rsp->link_cfg_lvl;
 }
 EXPORT_SYMBOL(mbox_handler_nix_txsch_alloc);
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 637450de189c..4ecd0ef05f3b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -182,6 +182,7 @@ struct otx2_hw {
 	u16			sqb_size;
 
 	/* NIX */
+	u8			txschq_link_cfg_lvl;
 	u16		txschq_list[NIX_TXSCH_LVL_CNT][MAX_TXSCHQ_PER_FUNC];
 	u16			matchall_ipolicer;
 	u32			dwrr_mtu;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
index cf03297c8471..d90c6dc41c9f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
@@ -497,7 +497,7 @@ int mlx5e_tc_tun_create_header_ipv6(struct mlx5e_priv *priv,
 	int err;
 
 	attr.ttl = tun_key->ttl;
-	attr.fl.fl6.flowlabel = ip6_make_flowinfo(RT_TOS(tun_key->tos), tun_key->label);
+	attr.fl.fl6.flowlabel = ip6_make_flowinfo(tun_key->tos, tun_key->label);
 	attr.fl.fl6.daddr = tun_key->u.ipv6.dst;
 	attr.fl.fl6.saddr = tun_key->u.ipv6.src;
 
@@ -611,7 +611,7 @@ int mlx5e_tc_tun_update_header_ipv6(struct mlx5e_priv *priv,
 
 	attr.ttl = tun_key->ttl;
 
-	attr.fl.fl6.flowlabel = ip6_make_flowinfo(RT_TOS(tun_key->tos), tun_key->label);
+	attr.fl.fl6.flowlabel = ip6_make_flowinfo(tun_key->tos, tun_key->label);
 	attr.fl.fl6.daddr = tun_key->u.ipv6.dst;
 	attr.fl.fl6.saddr = tun_key->u.ipv6.src;
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index edfdd44de579..35908a8c640a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -1730,9 +1730,9 @@ static void mlxsw_sp_port_remove(struct mlxsw_sp *mlxsw_sp, u8 local_port)
 
 	cancel_delayed_work_sync(&mlxsw_sp_port->periodic_hw_stats.update_dw);
 	cancel_delayed_work_sync(&mlxsw_sp_port->ptp.shaper_dw);
-	mlxsw_sp_port_ptp_clear(mlxsw_sp_port);
 	mlxsw_core_port_clear(mlxsw_sp->core, local_port, mlxsw_sp);
 	unregister_netdev(mlxsw_sp_port->dev); /* This calls ndo_stop */
+	mlxsw_sp_port_ptp_clear(mlxsw_sp_port);
 	mlxsw_sp_port_vlan_classification_set(mlxsw_sp_port, true, true);
 	mlxsw_sp->ports[local_port] = NULL;
 	mlxsw_sp_port_vlan_flush(mlxsw_sp_port, true);
diff --git a/drivers/net/ethernet/moxa/moxart_ether.c b/drivers/net/ethernet/moxa/moxart_ether.c
index 49def6934cad..54a91d2b33b5 100644
--- a/drivers/net/ethernet/moxa/moxart_ether.c
+++ b/drivers/net/ethernet/moxa/moxart_ether.c
@@ -77,7 +77,7 @@ static void moxart_mac_free_memory(struct net_device *ndev)
 	int i;
 
 	for (i = 0; i < RX_DESC_NUM; i++)
-		dma_unmap_single(&ndev->dev, priv->rx_mapping[i],
+		dma_unmap_single(&priv->pdev->dev, priv->rx_mapping[i],
 				 priv->rx_buf_size, DMA_FROM_DEVICE);
 
 	if (priv->tx_desc_base)
@@ -147,11 +147,11 @@ static void moxart_mac_setup_desc_ring(struct net_device *ndev)
 		       desc + RX_REG_OFFSET_DESC1);
 
 		priv->rx_buf[i] = priv->rx_buf_base + priv->rx_buf_size * i;
-		priv->rx_mapping[i] = dma_map_single(&ndev->dev,
+		priv->rx_mapping[i] = dma_map_single(&priv->pdev->dev,
 						     priv->rx_buf[i],
 						     priv->rx_buf_size,
 						     DMA_FROM_DEVICE);
-		if (dma_mapping_error(&ndev->dev, priv->rx_mapping[i]))
+		if (dma_mapping_error(&priv->pdev->dev, priv->rx_mapping[i]))
 			netdev_err(ndev, "DMA mapping error\n");
 
 		moxart_desc_write(priv->rx_mapping[i],
@@ -240,7 +240,7 @@ static int moxart_rx_poll(struct napi_struct *napi, int budget)
 		if (len > RX_BUF_SIZE)
 			len = RX_BUF_SIZE;
 
-		dma_sync_single_for_cpu(&ndev->dev,
+		dma_sync_single_for_cpu(&priv->pdev->dev,
 					priv->rx_mapping[rx_head],
 					priv->rx_buf_size, DMA_FROM_DEVICE);
 		skb = netdev_alloc_skb_ip_align(ndev, len);
@@ -294,7 +294,7 @@ static void moxart_tx_finished(struct net_device *ndev)
 	unsigned int tx_tail = priv->tx_tail;
 
 	while (tx_tail != tx_head) {
-		dma_unmap_single(&ndev->dev, priv->tx_mapping[tx_tail],
+		dma_unmap_single(&priv->pdev->dev, priv->tx_mapping[tx_tail],
 				 priv->tx_len[tx_tail], DMA_TO_DEVICE);
 
 		ndev->stats.tx_packets++;
@@ -358,9 +358,9 @@ static netdev_tx_t moxart_mac_start_xmit(struct sk_buff *skb,
 
 	len = skb->len > TX_BUF_SIZE ? TX_BUF_SIZE : skb->len;
 
-	priv->tx_mapping[tx_head] = dma_map_single(&ndev->dev, skb->data,
+	priv->tx_mapping[tx_head] = dma_map_single(&priv->pdev->dev, skb->data,
 						   len, DMA_TO_DEVICE);
-	if (dma_mapping_error(&ndev->dev, priv->tx_mapping[tx_head])) {
+	if (dma_mapping_error(&priv->pdev->dev, priv->tx_mapping[tx_head])) {
 		netdev_err(ndev, "DMA mapping error\n");
 		goto out_unlock;
 	}
@@ -379,7 +379,7 @@ static netdev_tx_t moxart_mac_start_xmit(struct sk_buff *skb,
 		len = ETH_ZLEN;
 	}
 
-	dma_sync_single_for_device(&ndev->dev, priv->tx_mapping[tx_head],
+	dma_sync_single_for_device(&priv->pdev->dev, priv->tx_mapping[tx_head],
 				   priv->tx_buf_size, DMA_TO_DEVICE);
 
 	txdes1 = TX_DESC1_LTS | TX_DESC1_FTS | (len & TX_DESC1_BUF_SIZE_MASK);
@@ -493,7 +493,7 @@ static int moxart_mac_probe(struct platform_device *pdev)
 	priv->tx_buf_size = TX_BUF_SIZE;
 	priv->rx_buf_size = RX_BUF_SIZE;
 
-	priv->tx_desc_base = dma_alloc_coherent(&pdev->dev, TX_REG_DESC_SIZE *
+	priv->tx_desc_base = dma_alloc_coherent(p_dev, TX_REG_DESC_SIZE *
 						TX_DESC_NUM, &priv->tx_base,
 						GFP_DMA | GFP_KERNEL);
 	if (!priv->tx_desc_base) {
@@ -501,7 +501,7 @@ static int moxart_mac_probe(struct platform_device *pdev)
 		goto init_fail;
 	}
 
-	priv->rx_desc_base = dma_alloc_coherent(&pdev->dev, RX_REG_DESC_SIZE *
+	priv->rx_desc_base = dma_alloc_coherent(p_dev, RX_REG_DESC_SIZE *
 						RX_DESC_NUM, &priv->rx_base,
 						GFP_DMA | GFP_KERNEL);
 	if (!priv->rx_desc_base) {
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index 8b614b0201e7..ae72cde71343 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -1219,6 +1219,8 @@ nfp_port_get_module_info(struct net_device *netdev,
 	u8 data;
 
 	port = nfp_port_from_netdev(netdev);
+	/* update port state to get latest interface */
+	set_bit(NFP_PORT_CHANGED, &port->flags);
 	eth_port = nfp_port_get_eth_port(port);
 	if (!eth_port)
 		return -EOPNOTSUPP;
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
index 502fbbc082fb..b32f1f5d841f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -1098,6 +1098,7 @@ static void intel_eth_pci_remove(struct pci_dev *pdev)
 
 	stmmac_dvr_remove(&pdev->dev);
 
+	clk_disable_unprepare(priv->plat->stmmac_clk);
 	clk_unregister_fixed_rate(priv->plat->stmmac_clk);
 
 	pcim_iounmap_regions(pdev, BIT(0));
diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index 1ab94b5f9bbf..605332f36d9d 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -774,7 +774,8 @@ static struct rtable *geneve_get_v4_rt(struct sk_buff *skb,
 				       struct geneve_sock *gs4,
 				       struct flowi4 *fl4,
 				       const struct ip_tunnel_info *info,
-				       __be16 dport, __be16 sport)
+				       __be16 dport, __be16 sport,
+				       __u8 *full_tos)
 {
 	bool use_cache = ip_tunnel_dst_cache_usable(skb, info);
 	struct geneve_dev *geneve = netdev_priv(dev);
@@ -799,6 +800,8 @@ static struct rtable *geneve_get_v4_rt(struct sk_buff *skb,
 		use_cache = false;
 	}
 	fl4->flowi4_tos = RT_TOS(tos);
+	if (full_tos)
+		*full_tos = tos;
 
 	dst_cache = (struct dst_cache *)&info->dst_cache;
 	if (use_cache) {
@@ -852,8 +855,7 @@ static struct dst_entry *geneve_get_v6_dst(struct sk_buff *skb,
 		use_cache = false;
 	}
 
-	fl6->flowlabel = ip6_make_flowinfo(RT_TOS(prio),
-					   info->key.label);
+	fl6->flowlabel = ip6_make_flowinfo(prio, info->key.label);
 	dst_cache = (struct dst_cache *)&info->dst_cache;
 	if (use_cache) {
 		dst = dst_cache_get_ip6(dst_cache, &fl6->saddr);
@@ -887,6 +889,7 @@ static int geneve_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 	const struct ip_tunnel_key *key = &info->key;
 	struct rtable *rt;
 	struct flowi4 fl4;
+	__u8 full_tos;
 	__u8 tos, ttl;
 	__be16 df = 0;
 	__be16 sport;
@@ -897,7 +900,7 @@ static int geneve_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 
 	sport = udp_flow_src_port(geneve->net, skb, 1, USHRT_MAX, true);
 	rt = geneve_get_v4_rt(skb, dev, gs4, &fl4, info,
-			      geneve->cfg.info.key.tp_dst, sport);
+			      geneve->cfg.info.key.tp_dst, sport, &full_tos);
 	if (IS_ERR(rt))
 		return PTR_ERR(rt);
 
@@ -941,7 +944,7 @@ static int geneve_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 
 		df = key->tun_flags & TUNNEL_DONT_FRAGMENT ? htons(IP_DF) : 0;
 	} else {
-		tos = ip_tunnel_ecn_encap(fl4.flowi4_tos, ip_hdr(skb), skb);
+		tos = ip_tunnel_ecn_encap(full_tos, ip_hdr(skb), skb);
 		if (geneve->cfg.ttl_inherit)
 			ttl = ip_tunnel_get_ttl(ip_hdr(skb), skb);
 		else
@@ -1123,7 +1126,7 @@ static int geneve_fill_metadata_dst(struct net_device *dev, struct sk_buff *skb)
 					  1, USHRT_MAX, true);
 
 		rt = geneve_get_v4_rt(skb, dev, gs4, &fl4, info,
-				      geneve->cfg.info.key.tp_dst, sport);
+				      geneve->cfg.info.key.tp_dst, sport, NULL);
 		if (IS_ERR(rt))
 			return PTR_ERR(rt);
 
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 0d3f8fe8e42c..834a68d75832 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -315,6 +315,12 @@ static __maybe_unused int mdio_bus_phy_resume(struct device *dev)
 
 	phydev->suspended_by_mdio_bus = 0;
 
+	/* If we managed to get here with the PHY state machine in a state other
+	 * than PHY_HALTED this is an indication that something went wrong and
+	 * we should most likely be using MAC managed PM and we are not.
+	 */
+	WARN_ON(phydev->state != PHY_HALTED && !phydev->mac_managed_pm);
+
 	ret = phy_init_hw(phydev);
 	if (ret < 0)
 		return ret;
diff --git a/drivers/net/plip/plip.c b/drivers/net/plip/plip.c
index 82d609401711..2a2cb9d453e8 100644
--- a/drivers/net/plip/plip.c
+++ b/drivers/net/plip/plip.c
@@ -1107,7 +1107,7 @@ plip_open(struct net_device *dev)
 		/* Any address will do - we take the first. We already
 		   have the first two bytes filled with 0xfc, from
 		   plip_init_dev(). */
-		const struct in_ifaddr *ifa = rcu_dereference(in_dev->ifa_list);
+		const struct in_ifaddr *ifa = rtnl_dereference(in_dev->ifa_list);
 		if (ifa != NULL) {
 			memcpy(dev->dev_addr+2, &ifa->ifa_local, 4);
 		}
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 53cefad2a79d..48fb7bdc0f0b 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1017,8 +1017,11 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 		case XDP_TX:
 			stats->xdp_tx++;
 			xdpf = xdp_convert_buff_to_frame(&xdp);
-			if (unlikely(!xdpf))
+			if (unlikely(!xdpf)) {
+				if (unlikely(xdp_page != page))
+					put_page(xdp_page);
 				goto err_xdp;
+			}
 			err = virtnet_xdp_xmit(dev, 1, &xdpf, 0);
 			if (unlikely(!err)) {
 				xdp_return_frame_rx_napi(xdpf);
diff --git a/drivers/ntb/test/ntb_tool.c b/drivers/ntb/test/ntb_tool.c
index b7bf3f863d79..5ee0afa621a9 100644
--- a/drivers/ntb/test/ntb_tool.c
+++ b/drivers/ntb/test/ntb_tool.c
@@ -367,14 +367,16 @@ static ssize_t tool_fn_write(struct tool_ctx *tc,
 	u64 bits;
 	int n;
 
+	if (*offp)
+		return 0;
+
 	buf = kmalloc(size + 1, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 
-	ret = simple_write_to_buffer(buf, size, offp, ubuf, size);
-	if (ret < 0) {
+	if (copy_from_user(buf, ubuf, size)) {
 		kfree(buf);
-		return ret;
+		return -EFAULT;
 	}
 
 	buf[size] = 0;
diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index f592e5f7f5f3..889c5433c94d 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -1834,7 +1834,8 @@ static int __init nvmet_tcp_init(void)
 {
 	int ret;
 
-	nvmet_tcp_wq = alloc_workqueue("nvmet_tcp_wq", WQ_HIGHPRI, 0);
+	nvmet_tcp_wq = alloc_workqueue("nvmet_tcp_wq",
+				WQ_MEM_RECLAIM | WQ_HIGHPRI, 0);
 	if (!nvmet_tcp_wq)
 		return -ENOMEM;
 
diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
index 7cc2c54daad0..215f7510de9a 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -8,6 +8,7 @@
  * Author: Hezi Shahmoon <hezi.shahmoon@marvell.com>
  */
 
+#include <linux/bitfield.h>
 #include <linux/delay.h>
 #include <linux/gpio/consumer.h>
 #include <linux/interrupt.h>
@@ -857,14 +858,11 @@ advk_pci_bridge_emul_pcie_conf_read(struct pci_bridge_emul *bridge,
 
 
 	switch (reg) {
-	case PCI_EXP_SLTCTL:
-		*value = PCI_EXP_SLTSTA_PDS << 16;
-		return PCI_BRIDGE_EMUL_HANDLED;
-
 	/*
-	 * PCI_EXP_RTCTL and PCI_EXP_RTSTA are also supported, but do not need
-	 * to be handled here, because their values are stored in emulated
-	 * config space buffer, and we read them from there when needed.
+	 * PCI_EXP_SLTCAP, PCI_EXP_SLTCTL, PCI_EXP_RTCTL and PCI_EXP_RTSTA are
+	 * also supported, but do not need to be handled here, because their
+	 * values are stored in emulated config space buffer, and we read them
+	 * from there when needed.
 	 */
 
 	case PCI_EXP_LNKCAP: {
@@ -977,8 +975,25 @@ static int advk_sw_pci_bridge_init(struct advk_pcie *pcie)
 	/* Support interrupt A for MSI feature */
 	bridge->conf.intpin = PCI_INTERRUPT_INTA;
 
-	/* Aardvark HW provides PCIe Capability structure in version 2 */
-	bridge->pcie_conf.cap = cpu_to_le16(2);
+	/*
+	 * Aardvark HW provides PCIe Capability structure in version 2 and
+	 * indicate slot support, which is emulated.
+	 */
+	bridge->pcie_conf.cap = cpu_to_le16(2 | PCI_EXP_FLAGS_SLOT);
+
+	/*
+	 * Set Presence Detect State bit permanently since there is no support
+	 * for unplugging the card nor detecting whether it is plugged. (If a
+	 * platform exists in the future that supports it, via a GPIO for
+	 * example, it should be implemented via this bit.)
+	 *
+	 * Set physical slot number to 1 since there is only one port and zero
+	 * value is reserved for ports within the same silicon as Root Port
+	 * which is not our case.
+	 */
+	bridge->pcie_conf.slotcap = cpu_to_le32(FIELD_PREP(PCI_EXP_SLTCAP_PSN,
+							   1));
+	bridge->pcie_conf.slotsta = cpu_to_le16(PCI_EXP_SLTSTA_PDS);
 
 	/* Indicates supports for Completion Retry Status */
 	bridge->pcie_conf.rootcap = cpu_to_le16(PCI_EXP_RTCAP_CRSVIS);
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 4893b1e82403..a531064233f9 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4923,6 +4923,9 @@ static const struct pci_dev_acs_enabled {
 	{ PCI_VENDOR_ID_AMPERE, 0xE00C, pci_quirk_xgene_acs },
 	/* Broadcom multi-function device */
 	{ PCI_VENDOR_ID_BROADCOM, 0x16D7, pci_quirk_mf_endpoint_acs },
+	{ PCI_VENDOR_ID_BROADCOM, 0x1750, pci_quirk_mf_endpoint_acs },
+	{ PCI_VENDOR_ID_BROADCOM, 0x1751, pci_quirk_mf_endpoint_acs },
+	{ PCI_VENDOR_ID_BROADCOM, 0x1752, pci_quirk_mf_endpoint_acs },
 	{ PCI_VENDOR_ID_BROADCOM, 0xD714, pci_quirk_brcm_acs },
 	/* Amazon Annapurna Labs */
 	{ PCI_VENDOR_ID_AMAZON_ANNAPURNA_LABS, 0x0031, pci_quirk_al_acs },
diff --git a/drivers/phy/samsung/phy-exynos-pcie.c b/drivers/phy/samsung/phy-exynos-pcie.c
index 578cfe07d07a..53c9230c2907 100644
--- a/drivers/phy/samsung/phy-exynos-pcie.c
+++ b/drivers/phy/samsung/phy-exynos-pcie.c
@@ -51,6 +51,13 @@ static int exynos5433_pcie_phy_init(struct phy *phy)
 {
 	struct exynos_pcie_phy *ep = phy_get_drvdata(phy);
 
+	regmap_update_bits(ep->pmureg, EXYNOS5433_PMU_PCIE_PHY_OFFSET,
+			   BIT(0), 1);
+	regmap_update_bits(ep->fsysreg, PCIE_EXYNOS5433_PHY_GLOBAL_RESET,
+			   PCIE_APP_REQ_EXIT_L1_MODE, 0);
+	regmap_update_bits(ep->fsysreg, PCIE_EXYNOS5433_PHY_L1SUB_CM_CON,
+			   PCIE_REFCLK_GATING_EN, 0);
+
 	regmap_update_bits(ep->fsysreg,	PCIE_EXYNOS5433_PHY_COMMON_RESET,
 			   PCIE_PHY_RESET, 1);
 	regmap_update_bits(ep->fsysreg, PCIE_EXYNOS5433_PHY_MAC_RESET,
@@ -109,20 +116,7 @@ static int exynos5433_pcie_phy_init(struct phy *phy)
 	return 0;
 }
 
-static int exynos5433_pcie_phy_power_on(struct phy *phy)
-{
-	struct exynos_pcie_phy *ep = phy_get_drvdata(phy);
-
-	regmap_update_bits(ep->pmureg, EXYNOS5433_PMU_PCIE_PHY_OFFSET,
-			   BIT(0), 1);
-	regmap_update_bits(ep->fsysreg, PCIE_EXYNOS5433_PHY_GLOBAL_RESET,
-			   PCIE_APP_REQ_EXIT_L1_MODE, 0);
-	regmap_update_bits(ep->fsysreg, PCIE_EXYNOS5433_PHY_L1SUB_CM_CON,
-			   PCIE_REFCLK_GATING_EN, 0);
-	return 0;
-}
-
-static int exynos5433_pcie_phy_power_off(struct phy *phy)
+static int exynos5433_pcie_phy_exit(struct phy *phy)
 {
 	struct exynos_pcie_phy *ep = phy_get_drvdata(phy);
 
@@ -135,8 +129,7 @@ static int exynos5433_pcie_phy_power_off(struct phy *phy)
 
 static const struct phy_ops exynos5433_phy_ops = {
 	.init		= exynos5433_pcie_phy_init,
-	.power_on	= exynos5433_pcie_phy_power_on,
-	.power_off	= exynos5433_pcie_phy_power_off,
+	.exit		= exynos5433_pcie_phy_exit,
 	.owner		= THIS_MODULE,
 };
 
diff --git a/drivers/pinctrl/intel/pinctrl-intel.c b/drivers/pinctrl/intel/pinctrl-intel.c
index 826d494f3cc6..48f55991ae8c 100644
--- a/drivers/pinctrl/intel/pinctrl-intel.c
+++ b/drivers/pinctrl/intel/pinctrl-intel.c
@@ -1626,16 +1626,14 @@ EXPORT_SYMBOL_GPL(intel_pinctrl_probe_by_uid);
 
 const struct intel_pinctrl_soc_data *intel_pinctrl_get_soc_data(struct platform_device *pdev)
 {
+	const struct intel_pinctrl_soc_data * const *table;
 	const struct intel_pinctrl_soc_data *data = NULL;
-	const struct intel_pinctrl_soc_data **table;
-	struct acpi_device *adev;
-	unsigned int i;
 
-	adev = ACPI_COMPANION(&pdev->dev);
-	if (adev) {
-		const void *match = device_get_match_data(&pdev->dev);
+	table = device_get_match_data(&pdev->dev);
+	if (table) {
+		struct acpi_device *adev = ACPI_COMPANION(&pdev->dev);
+		unsigned int i;
 
-		table = (const struct intel_pinctrl_soc_data **)match;
 		for (i = 0; table[i]; i++) {
 			if (!strcmp(adev->pnp.unique_id, table[i]->uid)) {
 				data = table[i];
@@ -1649,7 +1647,7 @@ const struct intel_pinctrl_soc_data *intel_pinctrl_get_soc_data(struct platform_
 		if (!id)
 			return ERR_PTR(-ENODEV);
 
-		table = (const struct intel_pinctrl_soc_data **)id->driver_data;
+		table = (const struct intel_pinctrl_soc_data * const *)id->driver_data;
 		data = table[pdev->id];
 	}
 
diff --git a/drivers/pinctrl/nomadik/pinctrl-nomadik.c b/drivers/pinctrl/nomadik/pinctrl-nomadik.c
index 4757bf964d3c..6dd930a839ec 100644
--- a/drivers/pinctrl/nomadik/pinctrl-nomadik.c
+++ b/drivers/pinctrl/nomadik/pinctrl-nomadik.c
@@ -1421,8 +1421,10 @@ static int nmk_pinctrl_dt_subnode_to_map(struct pinctrl_dev *pctldev,
 
 	has_config = nmk_pinctrl_dt_get_config(np, &configs);
 	np_config = of_parse_phandle(np, "ste,config", 0);
-	if (np_config)
+	if (np_config) {
 		has_config |= nmk_pinctrl_dt_get_config(np_config, &configs);
+		of_node_put(np_config);
+	}
 	if (has_config) {
 		const char *gpio_name;
 		const char *pin;
diff --git a/drivers/pinctrl/pinctrl-amd.c b/drivers/pinctrl/pinctrl-amd.c
index ecab9064a845..5c4acf2308d4 100644
--- a/drivers/pinctrl/pinctrl-amd.c
+++ b/drivers/pinctrl/pinctrl-amd.c
@@ -912,6 +912,7 @@ static int amd_gpio_suspend(struct device *dev)
 {
 	struct amd_gpio *gpio_dev = dev_get_drvdata(dev);
 	struct pinctrl_desc *desc = gpio_dev->pctrl->desc;
+	unsigned long flags;
 	int i;
 
 	for (i = 0; i < desc->npins; i++) {
@@ -920,7 +921,9 @@ static int amd_gpio_suspend(struct device *dev)
 		if (!amd_gpio_should_save(gpio_dev, pin))
 			continue;
 
-		gpio_dev->saved_regs[i] = readl(gpio_dev->base + pin*4);
+		raw_spin_lock_irqsave(&gpio_dev->lock, flags);
+		gpio_dev->saved_regs[i] = readl(gpio_dev->base + pin * 4) & ~PIN_IRQ_PENDING;
+		raw_spin_unlock_irqrestore(&gpio_dev->lock, flags);
 	}
 
 	return 0;
@@ -930,6 +933,7 @@ static int amd_gpio_resume(struct device *dev)
 {
 	struct amd_gpio *gpio_dev = dev_get_drvdata(dev);
 	struct pinctrl_desc *desc = gpio_dev->pctrl->desc;
+	unsigned long flags;
 	int i;
 
 	for (i = 0; i < desc->npins; i++) {
@@ -938,7 +942,10 @@ static int amd_gpio_resume(struct device *dev)
 		if (!amd_gpio_should_save(gpio_dev, pin))
 			continue;
 
-		writel(gpio_dev->saved_regs[i], gpio_dev->base + pin*4);
+		raw_spin_lock_irqsave(&gpio_dev->lock, flags);
+		gpio_dev->saved_regs[i] |= readl(gpio_dev->base + pin * 4) & PIN_IRQ_PENDING;
+		writel(gpio_dev->saved_regs[i], gpio_dev->base + pin * 4);
+		raw_spin_unlock_irqrestore(&gpio_dev->lock, flags);
 	}
 
 	return 0;
diff --git a/drivers/pinctrl/qcom/pinctrl-msm8916.c b/drivers/pinctrl/qcom/pinctrl-msm8916.c
index 396db12ae904..bf68913ba821 100644
--- a/drivers/pinctrl/qcom/pinctrl-msm8916.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm8916.c
@@ -844,8 +844,8 @@ static const struct msm_pingroup msm8916_groups[] = {
 	PINGROUP(28, pwr_modem_enabled_a, NA, NA, NA, NA, NA, qdss_tracedata_b, NA, atest_combodac),
 	PINGROUP(29, cci_i2c, NA, NA, NA, NA, NA, qdss_tracedata_b, NA, atest_combodac),
 	PINGROUP(30, cci_i2c, NA, NA, NA, NA, NA, NA, NA, qdss_tracedata_b),
-	PINGROUP(31, cci_timer0, NA, NA, NA, NA, NA, NA, NA, NA),
-	PINGROUP(32, cci_timer1, NA, NA, NA, NA, NA, NA, NA, NA),
+	PINGROUP(31, cci_timer0, flash_strobe, NA, NA, NA, NA, NA, NA, NA),
+	PINGROUP(32, cci_timer1, flash_strobe, NA, NA, NA, NA, NA, NA, NA),
 	PINGROUP(33, cci_async, NA, NA, NA, NA, NA, NA, NA, qdss_tracedata_b),
 	PINGROUP(34, pwr_nav_enabled_a, NA, NA, NA, NA, NA, NA, NA, qdss_tracedata_b),
 	PINGROUP(35, pwr_crypto_enabled_a, NA, NA, NA, NA, NA, NA, NA, qdss_tracedata_b),
diff --git a/drivers/pinctrl/qcom/pinctrl-sm8250.c b/drivers/pinctrl/qcom/pinctrl-sm8250.c
index af144e724bd9..3bd7f9fedcc3 100644
--- a/drivers/pinctrl/qcom/pinctrl-sm8250.c
+++ b/drivers/pinctrl/qcom/pinctrl-sm8250.c
@@ -1316,7 +1316,7 @@ static const struct msm_pingroup sm8250_groups[] = {
 static const struct msm_gpio_wakeirq_map sm8250_pdc_map[] = {
 	{ 0, 79 }, { 1, 84 }, { 2, 80 }, { 3, 82 }, { 4, 107 }, { 7, 43 },
 	{ 11, 42 }, { 14, 44 }, { 15, 52 }, { 19, 67 }, { 23, 68 }, { 24, 105 },
-	{ 27, 92 }, { 28, 106 }, { 31, 69 }, { 35, 70 }, { 39, 37 },
+	{ 27, 92 }, { 28, 106 }, { 31, 69 }, { 35, 70 }, { 39, 73 },
 	{ 40, 108 }, { 43, 71 }, { 45, 72 }, { 47, 83 }, { 51, 74 }, { 55, 77 },
 	{ 59, 78 }, { 63, 75 }, { 64, 81 }, { 65, 87 }, { 66, 88 }, { 67, 89 },
 	{ 68, 54 }, { 70, 85 }, { 77, 46 }, { 80, 90 }, { 81, 91 }, { 83, 97 },
diff --git a/drivers/pinctrl/sunxi/pinctrl-sun50i-h6-r.c b/drivers/pinctrl/sunxi/pinctrl-sun50i-h6-r.c
index c7d90c44e87a..7b4b9f3d4555 100644
--- a/drivers/pinctrl/sunxi/pinctrl-sun50i-h6-r.c
+++ b/drivers/pinctrl/sunxi/pinctrl-sun50i-h6-r.c
@@ -107,6 +107,7 @@ static const struct sunxi_pinctrl_desc sun50i_h6_r_pinctrl_data = {
 	.npins = ARRAY_SIZE(sun50i_h6_r_pins),
 	.pin_base = PL_BASE,
 	.irq_banks = 2,
+	.io_bias_cfg_variant = BIAS_VOLTAGE_PIO_POW_MODE_SEL,
 };
 
 static int sun50i_h6_r_pinctrl_probe(struct platform_device *pdev)
diff --git a/drivers/pinctrl/sunxi/pinctrl-sunxi.c b/drivers/pinctrl/sunxi/pinctrl-sunxi.c
index 1431ab21aca6..30ca0fe5c31a 100644
--- a/drivers/pinctrl/sunxi/pinctrl-sunxi.c
+++ b/drivers/pinctrl/sunxi/pinctrl-sunxi.c
@@ -624,7 +624,7 @@ static int sunxi_pinctrl_set_io_bias_cfg(struct sunxi_pinctrl *pctl,
 					 unsigned pin,
 					 struct regulator *supply)
 {
-	unsigned short bank = pin / PINS_PER_BANK;
+	unsigned short bank;
 	unsigned long flags;
 	u32 val, reg;
 	int uV;
@@ -640,6 +640,9 @@ static int sunxi_pinctrl_set_io_bias_cfg(struct sunxi_pinctrl *pctl,
 	if (uV == 0)
 		return 0;
 
+	pin -= pctl->desc->pin_base;
+	bank = pin / PINS_PER_BANK;
+
 	switch (pctl->desc->io_bias_cfg_variant) {
 	case BIAS_VOLTAGE_GRP_CONFIG:
 		/*
@@ -657,8 +660,6 @@ static int sunxi_pinctrl_set_io_bias_cfg(struct sunxi_pinctrl *pctl,
 		else
 			val = 0xD; /* 3.3V */
 
-		pin -= pctl->desc->pin_base;
-
 		reg = readl(pctl->membase + sunxi_grp_config_reg(pin));
 		reg &= ~IO_BIAS_MASK;
 		writel(reg | val, pctl->membase + sunxi_grp_config_reg(pin));
diff --git a/drivers/platform/chrome/cros_ec_proto.c b/drivers/platform/chrome/cros_ec_proto.c
index ed2b4807328d..1575d603d3ff 100644
--- a/drivers/platform/chrome/cros_ec_proto.c
+++ b/drivers/platform/chrome/cros_ec_proto.c
@@ -507,13 +507,13 @@ int cros_ec_query_all(struct cros_ec_device *ec_dev)
 	ret = cros_ec_get_host_command_version_mask(ec_dev,
 						    EC_CMD_GET_NEXT_EVENT,
 						    &ver_mask);
-	if (ret < 0 || ver_mask == 0)
+	if (ret < 0 || ver_mask == 0) {
 		ec_dev->mkbp_event_supported = 0;
-	else
+	} else {
 		ec_dev->mkbp_event_supported = fls(ver_mask);
 
-	dev_dbg(ec_dev->dev, "MKBP support version %u\n",
-		ec_dev->mkbp_event_supported - 1);
+		dev_dbg(ec_dev->dev, "MKBP support version %u\n", ec_dev->mkbp_event_supported - 1);
+	}
 
 	/* Probe if host sleep v1 is supported for S0ix failure detection. */
 	ret = cros_ec_get_host_command_version_mask(ec_dev,
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index 08b2e85dcd7d..79bc86ba59b3 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -2607,8 +2607,8 @@ lpfc_debugfs_multixripools_write(struct file *file, const char __user *buf,
 	struct lpfc_sli4_hdw_queue *qp;
 	struct lpfc_multixri_pool *multixri_pool;
 
-	if (nbytes > 64)
-		nbytes = 64;
+	if (nbytes > sizeof(mybuf) - 1)
+		nbytes = sizeof(mybuf) - 1;
 
 	memset(mybuf, 0, sizeof(mybuf));
 
@@ -2688,8 +2688,8 @@ lpfc_debugfs_nvmestat_write(struct file *file, const char __user *buf,
 	if (!phba->targetport)
 		return -ENXIO;
 
-	if (nbytes > 64)
-		nbytes = 64;
+	if (nbytes > sizeof(mybuf) - 1)
+		nbytes = sizeof(mybuf) - 1;
 
 	memset(mybuf, 0, sizeof(mybuf));
 
@@ -2826,8 +2826,8 @@ lpfc_debugfs_ioktime_write(struct file *file, const char __user *buf,
 	char mybuf[64];
 	char *pbuf;
 
-	if (nbytes > 64)
-		nbytes = 64;
+	if (nbytes > sizeof(mybuf) - 1)
+		nbytes = sizeof(mybuf) - 1;
 
 	memset(mybuf, 0, sizeof(mybuf));
 
@@ -2954,8 +2954,8 @@ lpfc_debugfs_nvmeio_trc_write(struct file *file, const char __user *buf,
 	char mybuf[64];
 	char *pbuf;
 
-	if (nbytes > 63)
-		nbytes = 63;
+	if (nbytes > sizeof(mybuf) - 1)
+		nbytes = sizeof(mybuf) - 1;
 
 	memset(mybuf, 0, sizeof(mybuf));
 
@@ -3060,8 +3060,8 @@ lpfc_debugfs_hdwqstat_write(struct file *file, const char __user *buf,
 	char *pbuf;
 	int i;
 
-	if (nbytes > 64)
-		nbytes = 64;
+	if (nbytes > sizeof(mybuf) - 1)
+		nbytes = sizeof(mybuf) - 1;
 
 	memset(mybuf, 0, sizeof(mybuf));
 
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index fb69416c9623..f594a006d04c 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -2012,10 +2012,12 @@ lpfc_issue_cmf_sync_wqe(struct lpfc_hba *phba, u32 ms, u64 total)
 
 	sync_buf->cmd_flag |= LPFC_IO_CMF;
 	ret_val = lpfc_sli4_issue_wqe(phba, &phba->sli4_hba.hdwq[0], sync_buf);
-	if (ret_val)
+	if (ret_val) {
 		lpfc_printf_log(phba, KERN_INFO, LOG_CGN_MGMT,
 				"6214 Cannot issue CMF_SYNC_WQE: x%x\n",
 				ret_val);
+		__lpfc_sli_release_iocbq(phba, sync_buf);
+	}
 out_unlock:
 	spin_unlock_irqrestore(&phba->hbalock, iflags);
 	return ret_val;
diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-mediatek.c
index 4e53857605de..a9ddb50d593c 100644
--- a/drivers/scsi/ufs/ufs-mediatek.c
+++ b/drivers/scsi/ufs/ufs-mediatek.c
@@ -949,7 +949,6 @@ static int ufs_mtk_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 		 * ufshcd_suspend() re-enabling regulators while vreg is still
 		 * in low-power mode.
 		 */
-		ufs_mtk_vreg_set_lpm(hba, true);
 		err = ufs_mtk_mphy_power_on(hba, false);
 		if (err)
 			goto fail;
@@ -973,12 +972,13 @@ static int ufs_mtk_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 {
 	int err;
 
+	if (hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL)
+		ufs_mtk_vreg_set_lpm(hba, false);
+
 	err = ufs_mtk_mphy_power_on(hba, true);
 	if (err)
 		goto fail;
 
-	ufs_mtk_vreg_set_lpm(hba, false);
-
 	if (ufshcd_is_link_hibern8(hba)) {
 		err = ufs_mtk_link_set_hpm(hba);
 		if (err)
@@ -1139,9 +1139,59 @@ static int ufs_mtk_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_PM_SLEEP
+int ufs_mtk_system_suspend(struct device *dev)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	int ret;
+
+	ret = ufshcd_system_suspend(dev);
+	if (ret)
+		return ret;
+
+	ufs_mtk_vreg_set_lpm(hba, true);
+
+	return 0;
+}
+
+int ufs_mtk_system_resume(struct device *dev)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+
+	ufs_mtk_vreg_set_lpm(hba, false);
+
+	return ufshcd_system_resume(dev);
+}
+#endif
+
+int ufs_mtk_runtime_suspend(struct device *dev)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	int ret = 0;
+
+	ret = ufshcd_runtime_suspend(dev);
+	if (ret)
+		return ret;
+
+	ufs_mtk_vreg_set_lpm(hba, true);
+
+	return 0;
+}
+
+int ufs_mtk_runtime_resume(struct device *dev)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+
+	ufs_mtk_vreg_set_lpm(hba, false);
+
+	return ufshcd_runtime_resume(dev);
+}
+
 static const struct dev_pm_ops ufs_mtk_pm_ops = {
-	SET_SYSTEM_SLEEP_PM_OPS(ufshcd_system_suspend, ufshcd_system_resume)
-	SET_RUNTIME_PM_OPS(ufshcd_runtime_suspend, ufshcd_runtime_resume, NULL)
+	SET_SYSTEM_SLEEP_PM_OPS(ufs_mtk_system_suspend,
+				ufs_mtk_system_resume)
+	SET_RUNTIME_PM_OPS(ufs_mtk_runtime_suspend,
+			   ufs_mtk_runtime_resume, NULL)
 	.prepare	 = ufshcd_suspend_prepare,
 	.complete	 = ufshcd_resume_complete,
 };
diff --git a/drivers/spi/spi-meson-spicc.c b/drivers/spi/spi-meson-spicc.c
index 0bc7daa7afc8..e4cb52e1fe26 100644
--- a/drivers/spi/spi-meson-spicc.c
+++ b/drivers/spi/spi-meson-spicc.c
@@ -156,6 +156,7 @@ struct meson_spicc_device {
 	void __iomem			*base;
 	struct clk			*core;
 	struct clk			*pclk;
+	struct clk_divider		pow2_div;
 	struct clk			*clk;
 	struct spi_message		*message;
 	struct spi_transfer		*xfer;
@@ -168,6 +169,8 @@ struct meson_spicc_device {
 	unsigned long			xfer_remain;
 };
 
+#define pow2_clk_to_spicc(_div) container_of(_div, struct meson_spicc_device, pow2_div)
+
 static void meson_spicc_oen_enable(struct meson_spicc_device *spicc)
 {
 	u32 conf;
@@ -421,7 +424,7 @@ static int meson_spicc_prepare_message(struct spi_master *master,
 {
 	struct meson_spicc_device *spicc = spi_master_get_devdata(master);
 	struct spi_device *spi = message->spi;
-	u32 conf = 0;
+	u32 conf = readl_relaxed(spicc->base + SPICC_CONREG) & SPICC_DATARATE_MASK;
 
 	/* Store current message */
 	spicc->message = message;
@@ -458,8 +461,6 @@ static int meson_spicc_prepare_message(struct spi_master *master,
 	/* Select CS */
 	conf |= FIELD_PREP(SPICC_CS_MASK, spi->chip_select);
 
-	/* Default Clock rate core/4 */
-
 	/* Default 8bit word */
 	conf |= FIELD_PREP(SPICC_BITLENGTH_MASK, 8 - 1);
 
@@ -476,12 +477,16 @@ static int meson_spicc_prepare_message(struct spi_master *master,
 static int meson_spicc_unprepare_transfer(struct spi_master *master)
 {
 	struct meson_spicc_device *spicc = spi_master_get_devdata(master);
+	u32 conf = readl_relaxed(spicc->base + SPICC_CONREG) & SPICC_DATARATE_MASK;
 
 	/* Disable all IRQs */
 	writel(0, spicc->base + SPICC_INTREG);
 
 	device_reset_optional(&spicc->pdev->dev);
 
+	/* Set default configuration, keeping datarate field */
+	writel_relaxed(conf, spicc->base + SPICC_CONREG);
+
 	return 0;
 }
 
@@ -518,14 +523,60 @@ static void meson_spicc_cleanup(struct spi_device *spi)
  * Clk path for G12A series:
  *    pclk -> pow2 fixed div -> pow2 div -> mux -> out
  *    pclk -> enh fixed div -> enh div -> mux -> out
+ *
+ * The pow2 divider is tied to the controller HW state, and the
+ * divider is only valid when the controller is initialized.
+ *
+ * A set of clock ops is added to make sure we don't read/set this
+ * clock rate while the controller is in an unknown state.
  */
 
-static int meson_spicc_clk_init(struct meson_spicc_device *spicc)
+static unsigned long meson_spicc_pow2_recalc_rate(struct clk_hw *hw,
+						  unsigned long parent_rate)
+{
+	struct clk_divider *divider = to_clk_divider(hw);
+	struct meson_spicc_device *spicc = pow2_clk_to_spicc(divider);
+
+	if (!spicc->master->cur_msg || !spicc->master->busy)
+		return 0;
+
+	return clk_divider_ops.recalc_rate(hw, parent_rate);
+}
+
+static int meson_spicc_pow2_determine_rate(struct clk_hw *hw,
+					   struct clk_rate_request *req)
+{
+	struct clk_divider *divider = to_clk_divider(hw);
+	struct meson_spicc_device *spicc = pow2_clk_to_spicc(divider);
+
+	if (!spicc->master->cur_msg || !spicc->master->busy)
+		return -EINVAL;
+
+	return clk_divider_ops.determine_rate(hw, req);
+}
+
+static int meson_spicc_pow2_set_rate(struct clk_hw *hw, unsigned long rate,
+				     unsigned long parent_rate)
+{
+	struct clk_divider *divider = to_clk_divider(hw);
+	struct meson_spicc_device *spicc = pow2_clk_to_spicc(divider);
+
+	if (!spicc->master->cur_msg || !spicc->master->busy)
+		return -EINVAL;
+
+	return clk_divider_ops.set_rate(hw, rate, parent_rate);
+}
+
+const struct clk_ops meson_spicc_pow2_clk_ops = {
+	.recalc_rate = meson_spicc_pow2_recalc_rate,
+	.determine_rate = meson_spicc_pow2_determine_rate,
+	.set_rate = meson_spicc_pow2_set_rate,
+};
+
+static int meson_spicc_pow2_clk_init(struct meson_spicc_device *spicc)
 {
 	struct device *dev = &spicc->pdev->dev;
-	struct clk_fixed_factor *pow2_fixed_div, *enh_fixed_div;
-	struct clk_divider *pow2_div, *enh_div;
-	struct clk_mux *mux;
+	struct clk_fixed_factor *pow2_fixed_div;
 	struct clk_init_data init;
 	struct clk *clk;
 	struct clk_parent_data parent_data[2];
@@ -560,31 +611,45 @@ static int meson_spicc_clk_init(struct meson_spicc_device *spicc)
 	if (WARN_ON(IS_ERR(clk)))
 		return PTR_ERR(clk);
 
-	pow2_div = devm_kzalloc(dev, sizeof(*pow2_div), GFP_KERNEL);
-	if (!pow2_div)
-		return -ENOMEM;
-
 	snprintf(name, sizeof(name), "%s#pow2_div", dev_name(dev));
 	init.name = name;
-	init.ops = &clk_divider_ops;
-	init.flags = CLK_SET_RATE_PARENT;
+	init.ops = &meson_spicc_pow2_clk_ops;
+	/*
+	 * Set NOCACHE here to make sure we read the actual HW value
+	 * since we reset the HW after each transfer.
+	 */
+	init.flags = CLK_SET_RATE_PARENT | CLK_GET_RATE_NOCACHE;
 	parent_data[0].hw = &pow2_fixed_div->hw;
 	init.num_parents = 1;
 
-	pow2_div->shift = 16,
-	pow2_div->width = 3,
-	pow2_div->flags = CLK_DIVIDER_POWER_OF_TWO,
-	pow2_div->reg = spicc->base + SPICC_CONREG;
-	pow2_div->hw.init = &init;
+	spicc->pow2_div.shift = 16,
+	spicc->pow2_div.width = 3,
+	spicc->pow2_div.flags = CLK_DIVIDER_POWER_OF_TWO,
+	spicc->pow2_div.reg = spicc->base + SPICC_CONREG;
+	spicc->pow2_div.hw.init = &init;
 
-	clk = devm_clk_register(dev, &pow2_div->hw);
-	if (WARN_ON(IS_ERR(clk)))
-		return PTR_ERR(clk);
+	spicc->clk = devm_clk_register(dev, &spicc->pow2_div.hw);
+	if (WARN_ON(IS_ERR(spicc->clk)))
+		return PTR_ERR(spicc->clk);
 
-	if (!spicc->data->has_enhance_clk_div) {
-		spicc->clk = clk;
-		return 0;
-	}
+	return 0;
+}
+
+static int meson_spicc_enh_clk_init(struct meson_spicc_device *spicc)
+{
+	struct device *dev = &spicc->pdev->dev;
+	struct clk_fixed_factor *enh_fixed_div;
+	struct clk_divider *enh_div;
+	struct clk_mux *mux;
+	struct clk_init_data init;
+	struct clk *clk;
+	struct clk_parent_data parent_data[2];
+	char name[64];
+
+	memset(&init, 0, sizeof(init));
+	memset(&parent_data, 0, sizeof(parent_data));
+
+	init.parent_data = parent_data;
 
 	/* algorithm for enh div: rate = freq / 2 / (N + 1) */
 
@@ -637,7 +702,7 @@ static int meson_spicc_clk_init(struct meson_spicc_device *spicc)
 	snprintf(name, sizeof(name), "%s#sel", dev_name(dev));
 	init.name = name;
 	init.ops = &clk_mux_ops;
-	parent_data[0].hw = &pow2_div->hw;
+	parent_data[0].hw = &spicc->pow2_div.hw;
 	parent_data[1].hw = &enh_div->hw;
 	init.num_parents = 2;
 	init.flags = CLK_SET_RATE_PARENT;
@@ -754,12 +819,20 @@ static int meson_spicc_probe(struct platform_device *pdev)
 
 	meson_spicc_oen_enable(spicc);
 
-	ret = meson_spicc_clk_init(spicc);
+	ret = meson_spicc_pow2_clk_init(spicc);
 	if (ret) {
-		dev_err(&pdev->dev, "clock registration failed\n");
+		dev_err(&pdev->dev, "pow2 clock registration failed\n");
 		goto out_clk;
 	}
 
+	if (spicc->data->has_enhance_clk_div) {
+		ret = meson_spicc_enh_clk_init(spicc);
+		if (ret) {
+			dev_err(&pdev->dev, "clock registration failed\n");
+			goto out_clk;
+		}
+	}
+
 	ret = devm_spi_register_master(&pdev->dev, master);
 	if (ret) {
 		dev_err(&pdev->dev, "spi master registration failed\n");
diff --git a/drivers/tty/serial/ucc_uart.c b/drivers/tty/serial/ucc_uart.c
index 6000853973c1..3cc9ef08455c 100644
--- a/drivers/tty/serial/ucc_uart.c
+++ b/drivers/tty/serial/ucc_uart.c
@@ -1137,6 +1137,8 @@ static unsigned int soc_info(unsigned int *rev_h, unsigned int *rev_l)
 		/* No compatible property, so try the name. */
 		soc_string = np->name;
 
+	of_node_put(np);
+
 	/* Extract the SOC number from the "PowerPC," string */
 	if ((sscanf(soc_string, "PowerPC,%u", &soc) != 1) || !soc)
 		return 0;
diff --git a/drivers/usb/cdns3/cdns3-gadget.c b/drivers/usb/cdns3/cdns3-gadget.c
index ae049eb28b93..3f1ce8911077 100644
--- a/drivers/usb/cdns3/cdns3-gadget.c
+++ b/drivers/usb/cdns3/cdns3-gadget.c
@@ -220,7 +220,7 @@ int cdns3_allocate_trb_pool(struct cdns3_endpoint *priv_ep)
 
 	if (!priv_ep->trb_pool) {
 		priv_ep->trb_pool = dma_pool_alloc(priv_dev->eps_dma_pool,
-						   GFP_DMA32 | GFP_ATOMIC,
+						   GFP_ATOMIC,
 						   &priv_ep->trb_pool_dma);
 
 		if (!priv_ep->trb_pool)
@@ -625,9 +625,9 @@ static void cdns3_wa2_remove_old_request(struct cdns3_endpoint *priv_ep)
 		trace_cdns3_wa2(priv_ep, "removes eldest request");
 
 		kfree(priv_req->request.buf);
+		list_del_init(&priv_req->list);
 		cdns3_gadget_ep_free_request(&priv_ep->endpoint,
 					     &priv_req->request);
-		list_del_init(&priv_req->list);
 		--priv_ep->wa2_counter;
 
 		if (!chain)
diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
index e1cebf581a4a..519bb82b00e8 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -3594,7 +3594,8 @@ void dwc2_hsotg_core_disconnect(struct dwc2_hsotg *hsotg)
 void dwc2_hsotg_core_connect(struct dwc2_hsotg *hsotg)
 {
 	/* remove the soft-disconnect and let's go */
-	dwc2_clear_bit(hsotg, DCTL, DCTL_SFTDISCON);
+	if (!hsotg->role_sw || (dwc2_readl(hsotg, GOTGCTL) & GOTGCTL_BSESVLD))
+		dwc2_clear_bit(hsotg, DCTL, DCTL_SFTDISCON);
 }
 
 /**
diff --git a/drivers/usb/gadget/function/uvc_queue.c b/drivers/usb/gadget/function/uvc_queue.c
index 99dc9adf56ef..a64b842665b9 100644
--- a/drivers/usb/gadget/function/uvc_queue.c
+++ b/drivers/usb/gadget/function/uvc_queue.c
@@ -44,7 +44,8 @@ static int uvc_queue_setup(struct vb2_queue *vq,
 {
 	struct uvc_video_queue *queue = vb2_get_drv_priv(vq);
 	struct uvc_video *video = container_of(queue, struct uvc_video, queue);
-	struct usb_composite_dev *cdev = video->uvc->func.config->cdev;
+	unsigned int req_size;
+	unsigned int nreq;
 
 	if (*nbuffers > UVC_MAX_VIDEO_BUFFERS)
 		*nbuffers = UVC_MAX_VIDEO_BUFFERS;
@@ -53,10 +54,16 @@ static int uvc_queue_setup(struct vb2_queue *vq,
 
 	sizes[0] = video->imagesize;
 
-	if (cdev->gadget->speed < USB_SPEED_SUPER)
-		video->uvc_num_requests = 4;
-	else
-		video->uvc_num_requests = 64;
+	req_size = video->ep->maxpacket
+		 * max_t(unsigned int, video->ep->maxburst, 1)
+		 * (video->ep->mult);
+
+	/* We divide by two, to increase the chance to run
+	 * into fewer requests for smaller framesizes.
+	 */
+	nreq = DIV_ROUND_UP(DIV_ROUND_UP(sizes[0], 2), req_size);
+	nreq = clamp(nreq, 4U, 64U);
+	video->uvc_num_requests = nreq;
 
 	return 0;
 }
diff --git a/drivers/usb/gadget/function/uvc_video.c b/drivers/usb/gadget/function/uvc_video.c
index b4a763e5f70e..e170e88abf3a 100644
--- a/drivers/usb/gadget/function/uvc_video.c
+++ b/drivers/usb/gadget/function/uvc_video.c
@@ -225,7 +225,7 @@ uvc_video_complete(struct usb_ep *ep, struct usb_request *req)
 		break;
 
 	default:
-		uvcg_info(&video->uvc->func,
+		uvcg_warn(&video->uvc->func,
 			  "VS request completed with status %d.\n",
 			  req->status);
 		uvcg_queue_cancel(queue, 0);
diff --git a/drivers/usb/gadget/legacy/inode.c b/drivers/usb/gadget/legacy/inode.c
index 3279b4767424..9e8b678f0548 100644
--- a/drivers/usb/gadget/legacy/inode.c
+++ b/drivers/usb/gadget/legacy/inode.c
@@ -362,6 +362,7 @@ ep_io (struct ep_data *epdata, void *buf, unsigned len)
 				spin_unlock_irq (&epdata->dev->lock);
 
 				DBG (epdata->dev, "endpoint gone\n");
+				wait_for_completion(&done);
 				epdata->status = -ENODEV;
 			}
 		}
diff --git a/drivers/usb/host/ohci-ppc-of.c b/drivers/usb/host/ohci-ppc-of.c
index 45f7cceb6df3..98e46725999e 100644
--- a/drivers/usb/host/ohci-ppc-of.c
+++ b/drivers/usb/host/ohci-ppc-of.c
@@ -169,6 +169,7 @@ static int ohci_hcd_ppc_of_probe(struct platform_device *op)
 				release_mem_region(res.start, 0x4);
 		} else
 			pr_debug("%s: cannot get ehci offset from fdt\n", __FILE__);
+		of_node_put(np);
 	}
 
 	irq_dispose_mapping(irq);
diff --git a/drivers/usb/renesas_usbhs/rza.c b/drivers/usb/renesas_usbhs/rza.c
index 24de64edb674..2d77edefb4b3 100644
--- a/drivers/usb/renesas_usbhs/rza.c
+++ b/drivers/usb/renesas_usbhs/rza.c
@@ -23,6 +23,10 @@ static int usbhs_rza1_hardware_init(struct platform_device *pdev)
 	extal_clk = of_find_node_by_name(NULL, "extal");
 	of_property_read_u32(usb_x1_clk, "clock-frequency", &freq_usb);
 	of_property_read_u32(extal_clk, "clock-frequency", &freq_extal);
+
+	of_node_put(usb_x1_clk);
+	of_node_put(extal_clk);
+
 	if (freq_usb == 0) {
 		if (freq_extal == 12000000) {
 			/* Select 12MHz XTAL */
diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 3c034fe14ccb..818e47fc0896 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1850,6 +1850,7 @@ struct vfio_info_cap_header *vfio_info_cap_add(struct vfio_info_cap *caps,
 	buf = krealloc(caps->buf, caps->size + size, GFP_KERNEL);
 	if (!buf) {
 		kfree(caps->buf);
+		caps->buf = NULL;
 		caps->size = 0;
 		return ERR_PTR(-ENOMEM);
 	}
diff --git a/drivers/video/fbdev/i740fb.c b/drivers/video/fbdev/i740fb.c
index 52cce0db8bd3..ad5ced4ef972 100644
--- a/drivers/video/fbdev/i740fb.c
+++ b/drivers/video/fbdev/i740fb.c
@@ -400,7 +400,7 @@ static int i740fb_decode_var(const struct fb_var_screeninfo *var,
 	u32 xres, right, hslen, left, xtotal;
 	u32 yres, lower, vslen, upper, ytotal;
 	u32 vxres, xoffset, vyres, yoffset;
-	u32 bpp, base, dacspeed24, mem;
+	u32 bpp, base, dacspeed24, mem, freq;
 	u8 r7;
 	int i;
 
@@ -643,7 +643,12 @@ static int i740fb_decode_var(const struct fb_var_screeninfo *var,
 	par->atc[VGA_ATC_OVERSCAN] = 0;
 
 	/* Calculate VCLK that most closely matches the requested dot clock */
-	i740_calc_vclk((((u32)1e9) / var->pixclock) * (u32)(1e3), par);
+	freq = (((u32)1e9) / var->pixclock) * (u32)(1e3);
+	if (freq < I740_RFREQ_FIX) {
+		fb_dbg(info, "invalid pixclock\n");
+		freq = I740_RFREQ_FIX;
+	}
+	i740_calc_vclk(freq, par);
 
 	/* Since we program the clocks ourselves, always use VCLK2. */
 	par->misc |= 0x0C;
diff --git a/drivers/virt/vboxguest/vboxguest_linux.c b/drivers/virt/vboxguest/vboxguest_linux.c
index 73eb34849eab..4ccfd30c2a30 100644
--- a/drivers/virt/vboxguest/vboxguest_linux.c
+++ b/drivers/virt/vboxguest/vboxguest_linux.c
@@ -356,8 +356,8 @@ static int vbg_pci_probe(struct pci_dev *pci, const struct pci_device_id *id)
 		goto err_vbg_core_exit;
 	}
 
-	ret = devm_request_irq(dev, pci->irq, vbg_core_isr, IRQF_SHARED,
-			       DEVICE_NAME, gdev);
+	ret = request_irq(pci->irq, vbg_core_isr, IRQF_SHARED, DEVICE_NAME,
+			  gdev);
 	if (ret) {
 		vbg_err("vboxguest: Error requesting irq: %d\n", ret);
 		goto err_vbg_core_exit;
@@ -367,7 +367,7 @@ static int vbg_pci_probe(struct pci_dev *pci, const struct pci_device_id *id)
 	if (ret) {
 		vbg_err("vboxguest: Error misc_register %s failed: %d\n",
 			DEVICE_NAME, ret);
-		goto err_vbg_core_exit;
+		goto err_free_irq;
 	}
 
 	ret = misc_register(&gdev->misc_device_user);
@@ -403,6 +403,8 @@ static int vbg_pci_probe(struct pci_dev *pci, const struct pci_device_id *id)
 	misc_deregister(&gdev->misc_device_user);
 err_unregister_misc_device:
 	misc_deregister(&gdev->misc_device);
+err_free_irq:
+	free_irq(pci->irq, gdev);
 err_vbg_core_exit:
 	vbg_core_exit(gdev);
 err_disable_pcidev:
@@ -419,6 +421,7 @@ static void vbg_pci_remove(struct pci_dev *pci)
 	vbg_gdev = NULL;
 	mutex_unlock(&vbg_gdev_mutex);
 
+	free_irq(pci->irq, gdev);
 	device_remove_file(gdev->dev, &dev_attr_host_features);
 	device_remove_file(gdev->dev, &dev_attr_host_version);
 	misc_deregister(&gdev->misc_device_user);
diff --git a/drivers/xen/xenbus/xenbus_dev_frontend.c b/drivers/xen/xenbus/xenbus_dev_frontend.c
index 597af455a522..0792fda49a15 100644
--- a/drivers/xen/xenbus/xenbus_dev_frontend.c
+++ b/drivers/xen/xenbus/xenbus_dev_frontend.c
@@ -128,7 +128,7 @@ static ssize_t xenbus_file_read(struct file *filp,
 {
 	struct xenbus_file_priv *u = filp->private_data;
 	struct read_buffer *rb;
-	unsigned i;
+	ssize_t i;
 	int ret;
 
 	mutex_lock(&u->reply_mutex);
@@ -148,7 +148,7 @@ static ssize_t xenbus_file_read(struct file *filp,
 	rb = list_entry(u->read_buffers.next, struct read_buffer, list);
 	i = 0;
 	while (i < len) {
-		unsigned sz = min((unsigned)len - i, rb->len - rb->cons);
+		size_t sz = min_t(size_t, len - i, rb->len - rb->cons);
 
 		ret = copy_to_user(ubuf + i, &rb->msg[rb->cons], sz);
 
diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 4b2282aa274e..909cc00ef5ce 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -1575,9 +1575,11 @@ void btrfs_reclaim_bgs_work(struct work_struct *work)
 				div64_u64(zone_unusable * 100, bg->length));
 		trace_btrfs_reclaim_block_group(bg);
 		ret = btrfs_relocate_chunk(fs_info, bg->start);
-		if (ret)
+		if (ret) {
+			btrfs_dec_block_group_ro(bg);
 			btrfs_err(fs_info, "error relocating chunk %llu",
 				  bg->start);
+		}
 
 next:
 		btrfs_put_block_group(bg);
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 429a198f8937..673e11fcf3fc 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3576,7 +3576,12 @@ int prepare_to_relocate(struct reloc_control *rc)
 		 */
 		return PTR_ERR(trans);
 	}
-	return btrfs_commit_transaction(trans);
+
+	ret = btrfs_commit_transaction(trans);
+	if (ret)
+		unset_reloc_control(rc);
+
+	return ret;
 }
 
 static noinline_for_stack int relocate_block_group(struct reloc_control *rc)
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index bed6811476b0..e9e1aae89030 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1119,7 +1119,9 @@ static inline int __add_inode_ref(struct btrfs_trans_handle *trans,
 	extref = btrfs_lookup_inode_extref(NULL, root, path, name, namelen,
 					   inode_objectid, parent_objectid, 0,
 					   0);
-	if (!IS_ERR_OR_NULL(extref)) {
+	if (IS_ERR(extref)) {
+		return PTR_ERR(extref);
+	} else if (extref) {
 		u32 item_size;
 		u32 cur_offset = 0;
 		unsigned long base;
diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index d1faa9d2f1e8..883bb91ee257 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -3543,24 +3543,23 @@ static void handle_cap_grant(struct inode *inode,
 			fill_inline = true;
 	}
 
-	if (ci->i_auth_cap == cap &&
-	    le32_to_cpu(grant->op) == CEPH_CAP_OP_IMPORT) {
-		if (newcaps & ~extra_info->issued)
-			wake = true;
+	if (le32_to_cpu(grant->op) == CEPH_CAP_OP_IMPORT) {
+		if (ci->i_auth_cap == cap) {
+			if (newcaps & ~extra_info->issued)
+				wake = true;
+
+			if (ci->i_requested_max_size > max_size ||
+			    !(le32_to_cpu(grant->wanted) & CEPH_CAP_ANY_FILE_WR)) {
+				/* re-request max_size if necessary */
+				ci->i_requested_max_size = 0;
+				wake = true;
+			}
 
-		if (ci->i_requested_max_size > max_size ||
-		    !(le32_to_cpu(grant->wanted) & CEPH_CAP_ANY_FILE_WR)) {
-			/* re-request max_size if necessary */
-			ci->i_requested_max_size = 0;
-			wake = true;
+			ceph_kick_flushing_inode_caps(session, ci);
 		}
-
-		ceph_kick_flushing_inode_caps(session, ci);
-		spin_unlock(&ci->i_ceph_lock);
 		up_read(&session->s_mdsc->snap_rwsem);
-	} else {
-		spin_unlock(&ci->i_ceph_lock);
 	}
+	spin_unlock(&ci->i_ceph_lock);
 
 	if (fill_inline)
 		ceph_fill_inline_data(inode, NULL, extra_info->inline_data,
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 912903de4de4..78d052dc1798 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1196,14 +1196,17 @@ static int encode_supported_features(void **p, void *end)
 	if (count > 0) {
 		size_t i;
 		size_t size = FEATURE_BYTES(count);
+		unsigned long bit;
 
 		if (WARN_ON_ONCE(*p + 4 + size > end))
 			return -ERANGE;
 
 		ceph_encode_32(p, size);
 		memset(*p, 0, size);
-		for (i = 0; i < count; i++)
-			((unsigned char*)(*p))[i / 8] |= BIT(feature_bits[i] % 8);
+		for (i = 0; i < count; i++) {
+			bit = feature_bits[i];
+			((unsigned char *)(*p))[bit / 8] |= BIT(bit % 8);
+		}
 		*p += size;
 	} else {
 		if (WARN_ON_ONCE(*p + 4 > end))
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 97c7f7bfa55f..2667350eb72c 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -33,10 +33,6 @@ enum ceph_feature_type {
 	CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_METRIC_COLLECT,
 };
 
-/*
- * This will always have the highest feature bit value
- * as the last element of the array.
- */
 #define CEPHFS_FEATURES_CLIENT_SUPPORTED {	\
 	0, 1, 2, 3, 4, 5, 6, 7,			\
 	CEPHFS_FEATURE_MIMIC,			\
@@ -45,8 +41,6 @@ enum ceph_feature_type {
 	CEPHFS_FEATURE_MULTI_RECONNECT,		\
 	CEPHFS_FEATURE_DELEG_INO,		\
 	CEPHFS_FEATURE_METRIC_COLLECT,		\
-						\
-	CEPHFS_FEATURE_MAX,			\
 }
 #define CEPHFS_FEATURES_CLIENT_REQUIRED {}
 
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 5906f7f140eb..699f676ded47 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -736,6 +736,8 @@ cifs_close_deferred_file(struct cifsInodeInfo *cifs_inode)
 	list_for_each_entry(cfile, &cifs_inode->openFileList, flist) {
 		if (delayed_work_pending(&cfile->deferred)) {
 			if (cancel_delayed_work(&cfile->deferred)) {
+				cifs_del_deferred_close(cfile);
+
 				tmp_list = kmalloc(sizeof(struct file_list), GFP_ATOMIC);
 				if (tmp_list == NULL)
 					break;
@@ -767,6 +769,8 @@ cifs_close_all_deferred_files(struct cifs_tcon *tcon)
 		cfile = list_entry(tmp, struct cifsFileInfo, tlist);
 		if (delayed_work_pending(&cfile->deferred)) {
 			if (cancel_delayed_work(&cfile->deferred)) {
+				cifs_del_deferred_close(cfile);
+
 				tmp_list = kmalloc(sizeof(struct file_list), GFP_ATOMIC);
 				if (tmp_list == NULL)
 					break;
@@ -802,6 +806,8 @@ cifs_close_deferred_file_under_dentry(struct cifs_tcon *tcon, const char *path)
 		if (strstr(full_path, path)) {
 			if (delayed_work_pending(&cfile->deferred)) {
 				if (cancel_delayed_work(&cfile->deferred)) {
+					cifs_del_deferred_close(cfile);
+
 					tmp_list = kmalloc(sizeof(struct file_list), GFP_ATOMIC);
 					if (tmp_list == NULL)
 						break;
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 735aafee63be..07895e9d537c 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1105,9 +1105,7 @@ move_smb2_ea_to_cifs(char *dst, size_t dst_size,
 	size_t name_len, value_len, user_name_len;
 
 	while (src_size > 0) {
-		name = &src->ea_data[0];
 		name_len = (size_t)src->ea_name_length;
-		value = &src->ea_data[src->ea_name_length + 1];
 		value_len = (size_t)le16_to_cpu(src->ea_value_length);
 
 		if (name_len == 0)
@@ -1119,6 +1117,9 @@ move_smb2_ea_to_cifs(char *dst, size_t dst_size,
 			goto out;
 		}
 
+		name = &src->ea_data[0];
+		value = &src->ea_data[src->ea_name_length + 1];
+
 		if (ea_name) {
 			if (ea_name_len == name_len &&
 			    memcmp(ea_name, name, name_len) == 0) {
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 5821638cb893..7d3ec39121f7 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3090,11 +3090,8 @@ bool ext4_empty_dir(struct inode *inode)
 		de = (struct ext4_dir_entry_2 *) (bh->b_data +
 					(offset & (sb->s_blocksize - 1)));
 		if (ext4_check_dir_entry(inode, NULL, de, bh,
-					 bh->b_data, bh->b_size, offset)) {
-			offset = (offset | (sb->s_blocksize - 1)) + 1;
-			continue;
-		}
-		if (le32_to_cpu(de->inode)) {
+					 bh->b_data, bh->b_size, offset) ||
+		    le32_to_cpu(de->inode)) {
 			brelse(bh);
 			return false;
 		}
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index fa3c854125bb..862cbbc01d6e 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1977,6 +1977,16 @@ int ext4_resize_fs(struct super_block *sb, ext4_fsblk_t n_blocks_count)
 	}
 	brelse(bh);
 
+	/*
+	 * For bigalloc, trim the requested size to the nearest cluster
+	 * boundary to avoid creating an unusable filesystem. We do this
+	 * silently, instead of returning an error, to avoid breaking
+	 * callers that blindly resize the filesystem to the full size of
+	 * the underlying block device.
+	 */
+	if (ext4_has_feature_bigalloc(sb))
+		n_blocks_count &= ~((1 << EXT4_CLUSTER_BITS(sb)) - 1);
+
 retry:
 	o_blocks_count = ext4_blocks_count(es);
 
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 69c6bcaf5aae..0e6e73bc42d4 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1291,7 +1291,11 @@ struct page *f2fs_new_node_page(struct dnode_of_data *dn, unsigned int ofs)
 		dec_valid_node_count(sbi, dn->inode, !ofs);
 		goto fail;
 	}
-	f2fs_bug_on(sbi, new_ni.blk_addr != NULL_ADDR);
+	if (unlikely(new_ni.blk_addr != NULL_ADDR)) {
+		err = -EFSCORRUPTED;
+		set_sbi_flag(sbi, SBI_NEED_FSCK);
+		goto fail;
+	}
 #endif
 	new_ni.nid = dn->nid;
 	new_ni.ino = dn->inode->i_ino;
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 841a978da083..e98c90bd8ef6 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -4537,6 +4537,12 @@ static int build_sit_entries(struct f2fs_sb_info *sbi)
 				return err;
 			seg_info_from_raw_sit(se, &sit);
 
+			if (se->type >= NR_PERSISTENT_LOG) {
+				f2fs_err(sbi, "Invalid segment type: %u, segno: %u",
+							se->type, start);
+				return -EFSCORRUPTED;
+			}
+
 			sit_valid_blocks[SE_PAGETYPE(se)] += se->valid_blocks;
 
 			if (f2fs_block_unit_discard(sbi)) {
@@ -4585,6 +4591,13 @@ static int build_sit_entries(struct f2fs_sb_info *sbi)
 			break;
 		seg_info_from_raw_sit(se, &sit);
 
+		if (se->type >= NR_PERSISTENT_LOG) {
+			f2fs_err(sbi, "Invalid segment type: %u, segno: %u",
+							se->type, start);
+			err = -EFSCORRUPTED;
+			break;
+		}
+
 		sit_valid_blocks[SE_PAGETYPE(se)] += se->valid_blocks;
 
 		if (f2fs_block_unit_discard(sbi)) {
diff --git a/fs/nfs/nfs4idmap.c b/fs/nfs/nfs4idmap.c
index f331866dd418..ec6afd3c4bca 100644
--- a/fs/nfs/nfs4idmap.c
+++ b/fs/nfs/nfs4idmap.c
@@ -561,22 +561,20 @@ nfs_idmap_prepare_pipe_upcall(struct idmap *idmap,
 	return true;
 }
 
-static void
-nfs_idmap_complete_pipe_upcall_locked(struct idmap *idmap, int ret)
+static void nfs_idmap_complete_pipe_upcall(struct idmap_legacy_upcalldata *data,
+					   int ret)
 {
-	struct key *authkey = idmap->idmap_upcall_data->authkey;
-
-	kfree(idmap->idmap_upcall_data);
-	idmap->idmap_upcall_data = NULL;
-	complete_request_key(authkey, ret);
-	key_put(authkey);
+	complete_request_key(data->authkey, ret);
+	key_put(data->authkey);
+	kfree(data);
 }
 
-static void
-nfs_idmap_abort_pipe_upcall(struct idmap *idmap, int ret)
+static void nfs_idmap_abort_pipe_upcall(struct idmap *idmap,
+					struct idmap_legacy_upcalldata *data,
+					int ret)
 {
-	if (idmap->idmap_upcall_data != NULL)
-		nfs_idmap_complete_pipe_upcall_locked(idmap, ret);
+	if (cmpxchg(&idmap->idmap_upcall_data, data, NULL) == data)
+		nfs_idmap_complete_pipe_upcall(data, ret);
 }
 
 static int nfs_idmap_legacy_upcall(struct key *authkey, void *aux)
@@ -613,7 +611,7 @@ static int nfs_idmap_legacy_upcall(struct key *authkey, void *aux)
 
 	ret = rpc_queue_upcall(idmap->idmap_pipe, msg);
 	if (ret < 0)
-		nfs_idmap_abort_pipe_upcall(idmap, ret);
+		nfs_idmap_abort_pipe_upcall(idmap, data, ret);
 
 	return ret;
 out2:
@@ -669,6 +667,7 @@ idmap_pipe_downcall(struct file *filp, const char __user *src, size_t mlen)
 	struct request_key_auth *rka;
 	struct rpc_inode *rpci = RPC_I(file_inode(filp));
 	struct idmap *idmap = (struct idmap *)rpci->private;
+	struct idmap_legacy_upcalldata *data;
 	struct key *authkey;
 	struct idmap_msg im;
 	size_t namelen_in;
@@ -678,10 +677,11 @@ idmap_pipe_downcall(struct file *filp, const char __user *src, size_t mlen)
 	 * will have been woken up and someone else may now have used
 	 * idmap_key_cons - so after this point we may no longer touch it.
 	 */
-	if (idmap->idmap_upcall_data == NULL)
+	data = xchg(&idmap->idmap_upcall_data, NULL);
+	if (data == NULL)
 		goto out_noupcall;
 
-	authkey = idmap->idmap_upcall_data->authkey;
+	authkey = data->authkey;
 	rka = get_request_key_auth(authkey);
 
 	if (mlen != sizeof(im)) {
@@ -703,18 +703,17 @@ idmap_pipe_downcall(struct file *filp, const char __user *src, size_t mlen)
 	if (namelen_in == 0 || namelen_in == IDMAP_NAMESZ) {
 		ret = -EINVAL;
 		goto out;
-}
+	}
 
-	ret = nfs_idmap_read_and_verify_message(&im,
-			&idmap->idmap_upcall_data->idmap_msg,
-			rka->target_key, authkey);
+	ret = nfs_idmap_read_and_verify_message(&im, &data->idmap_msg,
+						rka->target_key, authkey);
 	if (ret >= 0) {
 		key_set_timeout(rka->target_key, nfs_idmap_cache_timeout);
 		ret = mlen;
 	}
 
 out:
-	nfs_idmap_complete_pipe_upcall_locked(idmap, ret);
+	nfs_idmap_complete_pipe_upcall(data, ret);
 out_noupcall:
 	return ret;
 }
@@ -728,7 +727,7 @@ idmap_pipe_destroy_msg(struct rpc_pipe_msg *msg)
 	struct idmap *idmap = data->idmap;
 
 	if (msg->errno)
-		nfs_idmap_abort_pipe_upcall(idmap, msg->errno);
+		nfs_idmap_abort_pipe_upcall(idmap, data, msg->errno);
 }
 
 static void
@@ -736,8 +735,11 @@ idmap_release_pipe(struct inode *inode)
 {
 	struct rpc_inode *rpci = RPC_I(inode);
 	struct idmap *idmap = (struct idmap *)rpci->private;
+	struct idmap_legacy_upcalldata *data;
 
-	nfs_idmap_abort_pipe_upcall(idmap, -EPIPE);
+	data = xchg(&idmap->idmap_upcall_data, NULL);
+	if (data)
+		nfs_idmap_complete_pipe_upcall(data, -EPIPE);
 }
 
 int nfs_map_name_to_uid(const struct nfs_server *server, const char *name, size_t namelen, kuid_t *uid)
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index cbb39aff8182..a808763c52c1 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -787,10 +787,9 @@ static void nfs4_slot_sequence_record_sent(struct nfs4_slot *slot,
 	if ((s32)(seqnr - slot->seq_nr_highest_sent) > 0)
 		slot->seq_nr_highest_sent = seqnr;
 }
-static void nfs4_slot_sequence_acked(struct nfs4_slot *slot,
-		u32 seqnr)
+static void nfs4_slot_sequence_acked(struct nfs4_slot *slot, u32 seqnr)
 {
-	slot->seq_nr_highest_sent = seqnr;
+	nfs4_slot_sequence_record_sent(slot, seqnr);
 	slot->seq_nr_last_acked = seqnr;
 }
 
@@ -857,7 +856,6 @@ static int nfs41_sequence_process(struct rpc_task *task,
 			__func__,
 			slot->slot_nr,
 			slot->seq_nr);
-		nfs4_slot_sequence_acked(slot, slot->seq_nr);
 		goto out_retry;
 	case -NFS4ERR_RETRY_UNCACHED_REP:
 	case -NFS4ERR_SEQ_FALSE_RETRY:
@@ -3108,12 +3106,13 @@ static int _nfs4_open_and_get_state(struct nfs4_opendata *opendata,
 	}
 
 out:
-	if (opendata->lgp) {
-		nfs4_lgopen_release(opendata->lgp);
-		opendata->lgp = NULL;
-	}
-	if (!opendata->cancelled)
+	if (!opendata->cancelled) {
+		if (opendata->lgp) {
+			nfs4_lgopen_release(opendata->lgp);
+			opendata->lgp = NULL;
+		}
 		nfs4_sequence_free_slot(&opendata->o_res.seq_res);
+	}
 	return ret;
 }
 
@@ -9410,6 +9409,9 @@ static int nfs41_reclaim_complete_handle_errors(struct rpc_task *task, struct nf
 		rpc_delay(task, NFS4_POLL_RETRY_MAX);
 		fallthrough;
 	case -NFS4ERR_RETRY_UNCACHED_REP:
+	case -EACCES:
+		dprintk("%s: failed to reclaim complete error %d for server %s, retrying\n",
+			__func__, task->tk_status, clp->cl_hostname);
 		return -EAGAIN;
 	case -NFS4ERR_BADSESSION:
 	case -NFS4ERR_DEADSESSION:
diff --git a/fs/ntfs3/fslog.c b/fs/ntfs3/fslog.c
index 49b7df616778..614513460b8e 100644
--- a/fs/ntfs3/fslog.c
+++ b/fs/ntfs3/fslog.c
@@ -5057,7 +5057,7 @@ int log_replay(struct ntfs_inode *ni, bool *initialized)
 		goto add_allocated_vcns;
 
 	vcn = le64_to_cpu(lrh->target_vcn);
-	vcn &= ~(log->clst_per_page - 1);
+	vcn &= ~(u64)(log->clst_per_page - 1);
 
 add_allocated_vcns:
 	for (i = 0, vcn = le64_to_cpu(lrh->target_vcn),
diff --git a/fs/ntfs3/fsntfs.c b/fs/ntfs3/fsntfs.c
index 4de9acb16968..24b57c3cc625 100644
--- a/fs/ntfs3/fsntfs.c
+++ b/fs/ntfs3/fsntfs.c
@@ -831,10 +831,15 @@ int ntfs_update_mftmirr(struct ntfs_sb_info *sbi, int wait)
 {
 	int err;
 	struct super_block *sb = sbi->sb;
-	u32 blocksize = sb->s_blocksize;
+	u32 blocksize;
 	sector_t block1, block2;
 	u32 bytes;
 
+	if (!sb)
+		return -EINVAL;
+
+	blocksize = sb->s_blocksize;
+
 	if (!(sbi->flags & NTFS_FLAGS_MFTMIRR))
 		return 0;
 
diff --git a/fs/ntfs3/index.c b/fs/ntfs3/index.c
index 6f81e3a49abf..76ebea253fa2 100644
--- a/fs/ntfs3/index.c
+++ b/fs/ntfs3/index.c
@@ -1994,7 +1994,7 @@ static int indx_free_children(struct ntfs_index *indx, struct ntfs_inode *ni,
 			      const struct NTFS_DE *e, bool trim)
 {
 	int err;
-	struct indx_node *n;
+	struct indx_node *n = NULL;
 	struct INDEX_HDR *hdr;
 	CLST vbn = de_get_vbn(e);
 	size_t i;
diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index 879952254071..b2cc1191be69 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -430,6 +430,7 @@ static struct inode *ntfs_read_mft(struct inode *inode,
 	} else if (fname && fname->home.low == cpu_to_le32(MFT_REC_EXTEND) &&
 		   fname->home.seq == cpu_to_le16(MFT_REC_EXTEND)) {
 		/* Records in $Extend are not a files or general directories. */
+		inode->i_op = &ntfs_file_inode_operations;
 	} else {
 		err = -EINVAL;
 		goto out;
diff --git a/fs/ntfs3/super.c b/fs/ntfs3/super.c
index 7f85ec83e196..f3b88c7e35f7 100644
--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -30,6 +30,7 @@
 #include <linux/fs_context.h>
 #include <linux/fs_parser.h>
 #include <linux/log2.h>
+#include <linux/minmax.h>
 #include <linux/module.h>
 #include <linux/nls.h>
 #include <linux/seq_file.h>
@@ -390,7 +391,7 @@ static int ntfs_fs_reconfigure(struct fs_context *fc)
 		return -EINVAL;
 	}
 
-	memcpy(sbi->options, new_opts, sizeof(*new_opts));
+	swap(sbi->options, fc->fs_private);
 
 	return 0;
 }
@@ -901,6 +902,8 @@ static int ntfs_fill_super(struct super_block *sb, struct fs_context *fc)
 	ref.high = 0;
 
 	sbi->sb = sb;
+	sbi->options = fc->fs_private;
+	fc->fs_private = NULL;
 	sb->s_flags |= SB_NODIRATIME;
 	sb->s_magic = 0x7366746e; // "ntfs"
 	sb->s_op = &ntfs_sops;
@@ -1264,8 +1267,6 @@ static int ntfs_fill_super(struct super_block *sb, struct fs_context *fc)
 		goto put_inode_out;
 	}
 
-	fc->fs_private = NULL;
-
 	return 0;
 
 put_inode_out:
@@ -1418,7 +1419,6 @@ static int ntfs_init_fs_context(struct fs_context *fc)
 	mutex_init(&sbi->compress.mtx_lzx);
 #endif
 
-	sbi->options = opts;
 	fc->s_fs_info = sbi;
 ok:
 	fc->fs_private = opts;
diff --git a/fs/ntfs3/xattr.c b/fs/ntfs3/xattr.c
index 0968565ff2ca..872eb56bb170 100644
--- a/fs/ntfs3/xattr.c
+++ b/fs/ntfs3/xattr.c
@@ -545,28 +545,23 @@ static noinline int ntfs_set_acl_ex(struct user_namespace *mnt_userns,
 {
 	const char *name;
 	size_t size, name_len;
-	void *value = NULL;
-	int err = 0;
+	void *value;
+	int err;
 	int flags;
+	umode_t mode;
 
 	if (S_ISLNK(inode->i_mode))
 		return -EOPNOTSUPP;
 
+	mode = inode->i_mode;
 	switch (type) {
 	case ACL_TYPE_ACCESS:
 		/* Do not change i_mode if we are in init_acl */
 		if (acl && !init_acl) {
-			umode_t mode;
-
 			err = posix_acl_update_mode(mnt_userns, inode, &mode,
 						    &acl);
 			if (err)
-				goto out;
-
-			if (inode->i_mode != mode) {
-				inode->i_mode = mode;
-				mark_inode_dirty(inode);
-			}
+				return err;
 		}
 		name = XATTR_NAME_POSIX_ACL_ACCESS;
 		name_len = sizeof(XATTR_NAME_POSIX_ACL_ACCESS) - 1;
@@ -602,8 +597,13 @@ static noinline int ntfs_set_acl_ex(struct user_namespace *mnt_userns,
 	err = ntfs_set_ea(inode, name, name_len, value, size, flags);
 	if (err == -ENODATA && !size)
 		err = 0; /* Removing non existed xattr. */
-	if (!err)
+	if (!err) {
 		set_cached_acl(inode, type, acl);
+		if (inode->i_mode != mode) {
+			inode->i_mode = mode;
+			mark_inode_dirty(inode);
+		}
+	}
 
 out:
 	kfree(value);
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 7bb0a47cb615..9837aaf9caf1 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1413,11 +1413,12 @@ static int ovl_make_workdir(struct super_block *sb, struct ovl_fs *ofs,
 	 */
 	err = ovl_do_setxattr(ofs, ofs->workdir, OVL_XATTR_OPAQUE, "0", 1);
 	if (err) {
+		pr_warn("failed to set xattr on upper\n");
 		ofs->noxattr = true;
 		if (ofs->config.index || ofs->config.metacopy) {
 			ofs->config.index = false;
 			ofs->config.metacopy = false;
-			pr_warn("upper fs does not support xattr, falling back to index=off,metacopy=off.\n");
+			pr_warn("...falling back to index=off,metacopy=off.\n");
 		}
 		/*
 		 * xattr support is required for persistent st_ino.
@@ -1425,8 +1426,10 @@ static int ovl_make_workdir(struct super_block *sb, struct ovl_fs *ofs,
 		 */
 		if (ofs->config.xino == OVL_XINO_AUTO) {
 			ofs->config.xino = OVL_XINO_OFF;
-			pr_warn("upper fs does not support xattr, falling back to xino=off.\n");
+			pr_warn("...falling back to xino=off.\n");
 		}
+		if (err == -EPERM && !ofs->config.userxattr)
+			pr_info("try mounting with 'userxattr' option\n");
 		err = 0;
 	} else {
 		ovl_do_removexattr(ofs, ofs->workdir, OVL_XATTR_OPAQUE);
diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index 6a3ce0f6dc9e..be9bcf8a1f99 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -128,11 +128,12 @@ xfs_filestream_pick_ag(
 		if (!pag->pagf_init) {
 			err = xfs_alloc_pagf_init(mp, NULL, ag, trylock);
 			if (err) {
-				xfs_perag_put(pag);
-				if (err != -EAGAIN)
+				if (err != -EAGAIN) {
+					xfs_perag_put(pag);
 					return err;
+				}
 				/* Couldn't lock the AGF, skip this AG. */
-				continue;
+				goto next_ag;
 			}
 		}
 
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 710e857bb825..5b5b68affe66 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -430,46 +430,36 @@ xfs_reserve_blocks(
 	 * If the request is larger than the current reservation, reserve the
 	 * blocks before we update the reserve counters. Sample m_fdblocks and
 	 * perform a partial reservation if the request exceeds free space.
+	 *
+	 * The code below estimates how many blocks it can request from
+	 * fdblocks to stash in the reserve pool.  This is a classic TOCTOU
+	 * race since fdblocks updates are not always coordinated via
+	 * m_sb_lock.  Set the reserve size even if there's not enough free
+	 * space to fill it because mod_fdblocks will refill an undersized
+	 * reserve when it can.
 	 */
-	error = -ENOSPC;
-	do {
-		free = percpu_counter_sum(&mp->m_fdblocks) -
+	free = percpu_counter_sum(&mp->m_fdblocks) -
 						xfs_fdblocks_unavailable(mp);
-		if (free <= 0)
-			break;
-
-		delta = request - mp->m_resblks;
-		lcounter = free - delta;
-		if (lcounter < 0)
-			/* We can't satisfy the request, just get what we can */
-			fdblks_delta = free;
-		else
-			fdblks_delta = delta;
-
+	delta = request - mp->m_resblks;
+	mp->m_resblks = request;
+	if (delta > 0 && free > 0) {
 		/*
 		 * We'll either succeed in getting space from the free block
-		 * count or we'll get an ENOSPC. If we get a ENOSPC, it means
-		 * things changed while we were calculating fdblks_delta and so
-		 * we should try again to see if there is anything left to
-		 * reserve.
+		 * count or we'll get an ENOSPC.  Don't set the reserved flag
+		 * here - we don't want to reserve the extra reserve blocks
+		 * from the reserve.
 		 *
-		 * Don't set the reserved flag here - we don't want to reserve
-		 * the extra reserve blocks from the reserve.....
+		 * The desired reserve size can change after we drop the lock.
+		 * Use mod_fdblocks to put the space into the reserve or into
+		 * fdblocks as appropriate.
 		 */
+		fdblks_delta = min(free, delta);
 		spin_unlock(&mp->m_sb_lock);
 		error = xfs_mod_fdblocks(mp, -fdblks_delta, 0);
+		if (!error)
+			xfs_mod_fdblocks(mp, fdblks_delta, 0);
 		spin_lock(&mp->m_sb_lock);
-	} while (error == -ENOSPC);
-
-	/*
-	 * Update the reserve counters if blocks have been successfully
-	 * allocated.
-	 */
-	if (!error && fdblks_delta) {
-		mp->m_resblks += fdblks_delta;
-		mp->m_resblks_avail += fdblks_delta;
 	}
-
 out:
 	if (outval) {
 		outval->resblks = mp->m_resblks;
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index f2210d927481..5e44d7bbd8fc 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1872,28 +1872,20 @@ xfs_inodegc_worker(
 }
 
 /*
- * Force all currently queued inode inactivation work to run immediately, and
- * wait for the work to finish. Two pass - queue all the work first pass, wait
- * for it in a second pass.
+ * Force all currently queued inode inactivation work to run immediately and
+ * wait for the work to finish.
  */
 void
 xfs_inodegc_flush(
 	struct xfs_mount	*mp)
 {
-	struct xfs_inodegc	*gc;
-	int			cpu;
-
 	if (!xfs_is_inodegc_enabled(mp))
 		return;
 
 	trace_xfs_inodegc_flush(mp, __return_address);
 
 	xfs_inodegc_queue_all(mp);
-
-	for_each_online_cpu(cpu) {
-		gc = per_cpu_ptr(mp->m_inodegc, cpu);
-		flush_work(&gc->work);
-	}
+	flush_workqueue(mp->m_inodegc_wq);
 }
 
 /*
@@ -1904,18 +1896,12 @@ void
 xfs_inodegc_stop(
 	struct xfs_mount	*mp)
 {
-	struct xfs_inodegc	*gc;
-	int			cpu;
-
 	if (!xfs_clear_inodegc_enabled(mp))
 		return;
 
 	xfs_inodegc_queue_all(mp);
+	drain_workqueue(mp->m_inodegc_wq);
 
-	for_each_online_cpu(cpu) {
-		gc = per_cpu_ptr(mp->m_inodegc, cpu);
-		cancel_work_sync(&gc->work);
-	}
 	trace_xfs_inodegc_stop(mp, __return_address);
 }
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index c19f3ca605af..fb7a97cdf99f 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1223,7 +1223,7 @@ xfs_link(
 {
 	xfs_mount_t		*mp = tdp->i_mount;
 	xfs_trans_t		*tp;
-	int			error;
+	int			error, nospace_error = 0;
 	int			resblks;
 
 	trace_xfs_link(tdp, target_name);
@@ -1242,19 +1242,11 @@ xfs_link(
 		goto std_return;
 
 	resblks = XFS_LINK_SPACE_RES(mp, target_name->len);
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_link, resblks, 0, 0, &tp);
-	if (error == -ENOSPC) {
-		resblks = 0;
-		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_link, 0, 0, 0, &tp);
-	}
+	error = xfs_trans_alloc_dir(tdp, &M_RES(mp)->tr_link, sip, &resblks,
+			&tp, &nospace_error);
 	if (error)
 		goto std_return;
 
-	xfs_lock_two_inodes(sip, XFS_ILOCK_EXCL, tdp, XFS_ILOCK_EXCL);
-
-	xfs_trans_ijoin(tp, sip, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, tdp, XFS_ILOCK_EXCL);
-
 	error = xfs_iext_count_may_overflow(tdp, XFS_DATA_FORK,
 			XFS_IEXT_DIR_MANIP_CNT(mp));
 	if (error)
@@ -1312,6 +1304,8 @@ xfs_link(
  error_return:
 	xfs_trans_cancel(tp);
  std_return:
+	if (error == -ENOSPC && nospace_error)
+		error = nospace_error;
 	return error;
 }
 
@@ -2761,6 +2755,7 @@ xfs_remove(
 	xfs_mount_t		*mp = dp->i_mount;
 	xfs_trans_t             *tp = NULL;
 	int			is_dir = S_ISDIR(VFS_I(ip)->i_mode);
+	int			dontcare;
 	int                     error = 0;
 	uint			resblks;
 
@@ -2778,31 +2773,24 @@ xfs_remove(
 		goto std_return;
 
 	/*
-	 * We try to get the real space reservation first,
-	 * allowing for directory btree deletion(s) implying
-	 * possible bmap insert(s).  If we can't get the space
-	 * reservation then we use 0 instead, and avoid the bmap
-	 * btree insert(s) in the directory code by, if the bmap
-	 * insert tries to happen, instead trimming the LAST
-	 * block from the directory.
+	 * We try to get the real space reservation first, allowing for
+	 * directory btree deletion(s) implying possible bmap insert(s).  If we
+	 * can't get the space reservation then we use 0 instead, and avoid the
+	 * bmap btree insert(s) in the directory code by, if the bmap insert
+	 * tries to happen, instead trimming the LAST block from the directory.
+	 *
+	 * Ignore EDQUOT and ENOSPC being returned via nospace_error because
+	 * the directory code can handle a reservationless update and we don't
+	 * want to prevent a user from trying to free space by deleting things.
 	 */
 	resblks = XFS_REMOVE_SPACE_RES(mp);
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_remove, resblks, 0, 0, &tp);
-	if (error == -ENOSPC) {
-		resblks = 0;
-		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_remove, 0, 0, 0,
-				&tp);
-	}
+	error = xfs_trans_alloc_dir(dp, &M_RES(mp)->tr_remove, ip, &resblks,
+			&tp, &dontcare);
 	if (error) {
 		ASSERT(error != -ENOSPC);
 		goto std_return;
 	}
 
-	xfs_lock_two_inodes(dp, XFS_ILOCK_EXCL, ip, XFS_ILOCK_EXCL);
-
-	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
-
 	/*
 	 * If we're removing a directory perform some additional validation.
 	 */
@@ -3115,7 +3103,8 @@ xfs_rename(
 	bool			new_parent = (src_dp != target_dp);
 	bool			src_is_directory = S_ISDIR(VFS_I(src_ip)->i_mode);
 	int			spaceres;
-	int			error;
+	bool			retried = false;
+	int			error, nospace_error = 0;
 
 	trace_xfs_rename(src_dp, target_dp, src_name, target_name);
 
@@ -3139,9 +3128,12 @@ xfs_rename(
 	xfs_sort_for_rename(src_dp, target_dp, src_ip, target_ip, wip,
 				inodes, &num_inodes);
 
+retry:
+	nospace_error = 0;
 	spaceres = XFS_RENAME_SPACE_RES(mp, target_name->len);
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_rename, spaceres, 0, 0, &tp);
 	if (error == -ENOSPC) {
+		nospace_error = error;
 		spaceres = 0;
 		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_rename, 0, 0, 0,
 				&tp);
@@ -3195,6 +3187,31 @@ xfs_rename(
 					target_dp, target_name, target_ip,
 					spaceres);
 
+	/*
+	 * Try to reserve quota to handle an expansion of the target directory.
+	 * We'll allow the rename to continue in reservationless mode if we hit
+	 * a space usage constraint.  If we trigger reservationless mode, save
+	 * the errno if there isn't any free space in the target directory.
+	 */
+	if (spaceres != 0) {
+		error = xfs_trans_reserve_quota_nblks(tp, target_dp, spaceres,
+				0, false);
+		if (error == -EDQUOT || error == -ENOSPC) {
+			if (!retried) {
+				xfs_trans_cancel(tp);
+				xfs_blockgc_free_quota(target_dp, 0);
+				retried = true;
+				goto retry;
+			}
+
+			nospace_error = error;
+			spaceres = 0;
+			error = 0;
+		}
+		if (error)
+			goto out_trans_cancel;
+	}
+
 	/*
 	 * Check for expected errors before we dirty the transaction
 	 * so we can return an error without a transaction abort.
@@ -3441,6 +3458,8 @@ xfs_rename(
 out_release_wip:
 	if (wip)
 		xfs_irele(wip);
+	if (error == -ENOSPC && nospace_error)
+		error = nospace_error;
 	return error;
 }
 
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index fba52e75e98b..bcc3c18c8080 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1545,7 +1545,7 @@ xfs_ioc_getbmap(
 
 	if (bmx.bmv_count < 2)
 		return -EINVAL;
-	if (bmx.bmv_count > ULONG_MAX / recsize)
+	if (bmx.bmv_count >= INT_MAX / recsize)
 		return -ENOMEM;
 
 	buf = kvzalloc(bmx.bmv_count * sizeof(*buf), GFP_KERNEL);
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 67dec11e34c7..95c183072e7a 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -1201,3 +1201,89 @@ xfs_trans_alloc_ichange(
 	xfs_trans_cancel(tp);
 	return error;
 }
+
+/*
+ * Allocate an transaction, lock and join the directory and child inodes to it,
+ * and reserve quota for a directory update.  If there isn't sufficient space,
+ * @dblocks will be set to zero for a reservationless directory update and
+ * @nospace_error will be set to a negative errno describing the space
+ * constraint we hit.
+ *
+ * The caller must ensure that the on-disk dquots attached to this inode have
+ * already been allocated and initialized.  The ILOCKs will be dropped when the
+ * transaction is committed or cancelled.
+ */
+int
+xfs_trans_alloc_dir(
+	struct xfs_inode	*dp,
+	struct xfs_trans_res	*resv,
+	struct xfs_inode	*ip,
+	unsigned int		*dblocks,
+	struct xfs_trans	**tpp,
+	int			*nospace_error)
+{
+	struct xfs_trans	*tp;
+	struct xfs_mount	*mp = ip->i_mount;
+	unsigned int		resblks;
+	bool			retried = false;
+	int			error;
+
+retry:
+	*nospace_error = 0;
+	resblks = *dblocks;
+	error = xfs_trans_alloc(mp, resv, resblks, 0, 0, &tp);
+	if (error == -ENOSPC) {
+		*nospace_error = error;
+		resblks = 0;
+		error = xfs_trans_alloc(mp, resv, resblks, 0, 0, &tp);
+	}
+	if (error)
+		return error;
+
+	xfs_lock_two_inodes(dp, XFS_ILOCK_EXCL, ip, XFS_ILOCK_EXCL);
+
+	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+
+	error = xfs_qm_dqattach_locked(dp, false);
+	if (error) {
+		/* Caller should have allocated the dquots! */
+		ASSERT(error != -ENOENT);
+		goto out_cancel;
+	}
+
+	error = xfs_qm_dqattach_locked(ip, false);
+	if (error) {
+		/* Caller should have allocated the dquots! */
+		ASSERT(error != -ENOENT);
+		goto out_cancel;
+	}
+
+	if (resblks == 0)
+		goto done;
+
+	error = xfs_trans_reserve_quota_nblks(tp, dp, resblks, 0, false);
+	if (error == -EDQUOT || error == -ENOSPC) {
+		if (!retried) {
+			xfs_trans_cancel(tp);
+			xfs_blockgc_free_quota(dp, 0);
+			retried = true;
+			goto retry;
+		}
+
+		*nospace_error = error;
+		resblks = 0;
+		error = 0;
+	}
+	if (error)
+		goto out_cancel;
+
+done:
+	*tpp = tp;
+	*dblocks = resblks;
+	return 0;
+
+out_cancel:
+	xfs_trans_cancel(tp);
+	return error;
+}
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 50da47f23a07..faba74d4c702 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -265,6 +265,9 @@ int xfs_trans_alloc_icreate(struct xfs_mount *mp, struct xfs_trans_res *resv,
 int xfs_trans_alloc_ichange(struct xfs_inode *ip, struct xfs_dquot *udqp,
 		struct xfs_dquot *gdqp, struct xfs_dquot *pdqp, bool force,
 		struct xfs_trans **tpp);
+int xfs_trans_alloc_dir(struct xfs_inode *dp, struct xfs_trans_res *resv,
+		struct xfs_inode *ip, unsigned int *dblocks,
+		struct xfs_trans **tpp, int *nospace_error);
 
 static inline void
 xfs_trans_set_context(
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 3872ce671411..955c457e585a 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -603,7 +603,6 @@ xfs_dqresv_check(
 			return QUOTA_NL_ISOFTLONGWARN;
 		}
 
-		res->warnings++;
 		return QUOTA_NL_ISOFTWARN;
 	}
 
diff --git a/include/asm-generic/bitops/atomic.h b/include/asm-generic/bitops/atomic.h
index 3096f086b5a3..71ab4ba9c25d 100644
--- a/include/asm-generic/bitops/atomic.h
+++ b/include/asm-generic/bitops/atomic.h
@@ -39,9 +39,6 @@ arch_test_and_set_bit(unsigned int nr, volatile unsigned long *p)
 	unsigned long mask = BIT_MASK(nr);
 
 	p += BIT_WORD(nr);
-	if (READ_ONCE(*p) & mask)
-		return 1;
-
 	old = arch_atomic_long_fetch_or(mask, (atomic_long_t *)p);
 	return !!(old & mask);
 }
@@ -53,9 +50,6 @@ arch_test_and_clear_bit(unsigned int nr, volatile unsigned long *p)
 	unsigned long mask = BIT_MASK(nr);
 
 	p += BIT_WORD(nr);
-	if (!(READ_ONCE(*p) & mask))
-		return 0;
-
 	old = arch_atomic_long_fetch_andnot(mask, (atomic_long_t *)p);
 	return !!(old & mask);
 }
diff --git a/include/linux/bpfptr.h b/include/linux/bpfptr.h
index 546e27fc6d46..ee28d2b0a309 100644
--- a/include/linux/bpfptr.h
+++ b/include/linux/bpfptr.h
@@ -48,7 +48,9 @@ static inline void bpfptr_add(bpfptr_t *bpfptr, size_t val)
 static inline int copy_from_bpfptr_offset(void *dst, bpfptr_t src,
 					  size_t offset, size_t size)
 {
-	return copy_from_sockptr_offset(dst, (sockptr_t) src, offset, size);
+	if (!bpfptr_is_kernel(src))
+		return copy_from_user(dst, src.user + offset, size);
+	return copy_from_kernel_nofault(dst, src.kernel + offset, size);
 }
 
 static inline int copy_from_bpfptr(void *dst, bpfptr_t src, size_t size)
@@ -77,7 +79,9 @@ static inline void *kvmemdup_bpfptr(bpfptr_t src, size_t len)
 
 static inline long strncpy_from_bpfptr(char *dst, bpfptr_t src, size_t count)
 {
-	return strncpy_from_sockptr(dst, (sockptr_t) src, count);
+	if (bpfptr_is_kernel(src))
+		return strncpy_from_kernel_nofault(dst, src.kernel, count);
+	return strncpy_from_user(dst, src.user, count);
 }
 
 #endif /* _LINUX_BPFPTR_H */
diff --git a/include/linux/io-pgtable.h b/include/linux/io-pgtable.h
index 86af6f0a00a2..ca98aeadcc80 100644
--- a/include/linux/io-pgtable.h
+++ b/include/linux/io-pgtable.h
@@ -74,17 +74,22 @@ struct io_pgtable_cfg {
 	 *	to support up to 35 bits PA where the bit32, bit33 and bit34 are
 	 *	encoded in the bit9, bit4 and bit5 of the PTE respectively.
 	 *
+	 * IO_PGTABLE_QUIRK_ARM_MTK_TTBR_EXT: (ARM v7s format) MediaTek IOMMUs
+	 *	extend the translation table base support up to 35 bits PA, the
+	 *	encoding format is same with IO_PGTABLE_QUIRK_ARM_MTK_EXT.
+	 *
 	 * IO_PGTABLE_QUIRK_ARM_TTBR1: (ARM LPAE format) Configure the table
 	 *	for use in the upper half of a split address space.
 	 *
 	 * IO_PGTABLE_QUIRK_ARM_OUTER_WBWA: Override the outer-cacheability
 	 *	attributes set in the TCR for a non-coherent page-table walker.
 	 */
-	#define IO_PGTABLE_QUIRK_ARM_NS		BIT(0)
-	#define IO_PGTABLE_QUIRK_NO_PERMS	BIT(1)
-	#define IO_PGTABLE_QUIRK_ARM_MTK_EXT	BIT(3)
-	#define IO_PGTABLE_QUIRK_ARM_TTBR1	BIT(5)
-	#define IO_PGTABLE_QUIRK_ARM_OUTER_WBWA	BIT(6)
+	#define IO_PGTABLE_QUIRK_ARM_NS			BIT(0)
+	#define IO_PGTABLE_QUIRK_NO_PERMS		BIT(1)
+	#define IO_PGTABLE_QUIRK_ARM_MTK_EXT		BIT(3)
+	#define IO_PGTABLE_QUIRK_ARM_MTK_TTBR_EXT	BIT(4)
+	#define IO_PGTABLE_QUIRK_ARM_TTBR1		BIT(5)
+	#define IO_PGTABLE_QUIRK_ARM_OUTER_WBWA		BIT(6)
 	unsigned long			quirks;
 	unsigned long			pgsize_bitmap;
 	unsigned int			ias;
diff --git a/include/linux/nmi.h b/include/linux/nmi.h
index 750c7f395ca9..f700ff2df074 100644
--- a/include/linux/nmi.h
+++ b/include/linux/nmi.h
@@ -122,6 +122,8 @@ int watchdog_nmi_probe(void);
 int watchdog_nmi_enable(unsigned int cpu);
 void watchdog_nmi_disable(unsigned int cpu);
 
+void lockup_detector_reconfigure(void);
+
 /**
  * touch_nmi_watchdog - restart NMI watchdog timeout.
  *
diff --git a/include/linux/sunrpc/xdr.h b/include/linux/sunrpc/xdr.h
index 4417f667c757..3a2c714d6b62 100644
--- a/include/linux/sunrpc/xdr.h
+++ b/include/linux/sunrpc/xdr.h
@@ -405,8 +405,8 @@ static inline int xdr_stream_encode_item_absent(struct xdr_stream *xdr)
  */
 static inline __be32 *xdr_encode_bool(__be32 *p, u32 n)
 {
-	*p = n ? xdr_one : xdr_zero;
-	return p++;
+	*p++ = n ? xdr_one : xdr_zero;
+	return p;
 }
 
 /**
diff --git a/include/linux/uacce.h b/include/linux/uacce.h
index 48e319f40275..9ce88c28b0a8 100644
--- a/include/linux/uacce.h
+++ b/include/linux/uacce.h
@@ -70,6 +70,7 @@ enum uacce_q_state {
  * @wait: wait queue head
  * @list: index into uacce queues list
  * @qfrs: pointer of qfr regions
+ * @mutex: protects queue state
  * @state: queue state machine
  * @pasid: pasid associated to the mm
  * @handle: iommu_sva handle returned by iommu_sva_bind_device()
@@ -80,6 +81,7 @@ struct uacce_queue {
 	wait_queue_head_t wait;
 	struct list_head list;
 	struct uacce_qfile_region *qfrs[UACCE_MAX_REGION];
+	struct mutex mutex;
 	enum uacce_q_state state;
 	u32 pasid;
 	struct iommu_sva *handle;
@@ -97,9 +99,9 @@ struct uacce_queue {
  * @dev_id: id of the uacce device
  * @cdev: cdev of the uacce
  * @dev: dev of the uacce
+ * @mutex: protects uacce operation
  * @priv: private pointer of the uacce
  * @queues: list of queues
- * @queues_lock: lock for queues list
  * @inode: core vfs
  */
 struct uacce_device {
@@ -113,9 +115,9 @@ struct uacce_device {
 	u32 dev_id;
 	struct cdev *cdev;
 	struct device dev;
+	struct mutex mutex;
 	void *priv;
 	struct list_head queues;
-	struct mutex queues_lock;
 	struct inode *inode;
 };
 
diff --git a/include/sound/control.h b/include/sound/control.h
index 985c51a8fb74..a1fc7e0a47d9 100644
--- a/include/sound/control.h
+++ b/include/sound/control.h
@@ -109,7 +109,7 @@ struct snd_ctl_file {
 	int preferred_subdevice[SND_CTL_SUBDEV_ITEMS];
 	wait_queue_head_t change_sleep;
 	spinlock_t read_lock;
-	struct fasync_struct *fasync;
+	struct snd_fasync *fasync;
 	int subscribed;			/* read interface is activated */
 	struct list_head events;	/* waiting events for read */
 };
diff --git a/include/sound/core.h b/include/sound/core.h
index 6d4cc49584c6..39cee40ac22e 100644
--- a/include/sound/core.h
+++ b/include/sound/core.h
@@ -501,4 +501,12 @@ snd_pci_quirk_lookup_id(u16 vendor, u16 device,
 }
 #endif
 
+/* async signal helpers */
+struct snd_fasync;
+
+int snd_fasync_helper(int fd, struct file *file, int on,
+		      struct snd_fasync **fasyncp);
+void snd_kill_fasync(struct snd_fasync *fasync, int signal, int poll);
+void snd_fasync_free(struct snd_fasync *fasync);
+
 #endif /* __SOUND_CORE_H */
diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index 447def540544..88014cd31b28 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -620,6 +620,11 @@ static int bpf_iter_init_array_map(void *priv_data,
 		seq_info->percpu_value_buf = value_buf;
 	}
 
+	/* bpf_iter_attach_map() acquires a map uref, and the uref may be
+	 * released before or in the middle of iterating map elements, so
+	 * acquire an extra map uref for iterator.
+	 */
+	bpf_map_inc_with_uref(map);
 	seq_info->map = map;
 	return 0;
 }
@@ -628,6 +633,7 @@ static void bpf_iter_fini_array_map(void *priv_data)
 {
 	struct bpf_iter_seq_array_map_info *seq_info = priv_data;
 
+	bpf_map_put_with_uref(seq_info->map);
 	kfree(seq_info->percpu_value_buf);
 }
 
diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 32471ba02708..47eebb88695e 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -291,12 +291,8 @@ static struct htab_elem *prealloc_lru_pop(struct bpf_htab *htab, void *key,
 	struct htab_elem *l;
 
 	if (node) {
-		u32 key_size = htab->map.key_size;
-
 		l = container_of(node, struct htab_elem, lru_node);
-		memcpy(l->key, key, key_size);
-		check_and_init_map_value(&htab->map,
-					 l->key + round_up(key_size, 8));
+		memcpy(l->key, key, htab->map.key_size);
 		return l;
 	}
 
@@ -2023,6 +2019,7 @@ static int bpf_iter_init_hash_map(void *priv_data,
 		seq_info->percpu_value_buf = value_buf;
 	}
 
+	bpf_map_inc_with_uref(map);
 	seq_info->map = map;
 	seq_info->htab = container_of(map, struct bpf_htab, map);
 	return 0;
@@ -2032,6 +2029,7 @@ static void bpf_iter_fini_hash_map(void *priv_data)
 {
 	struct bpf_iter_seq_hash_map_info *seq_info = priv_data;
 
+	bpf_map_put_with_uref(seq_info->map);
 	kfree(seq_info->percpu_value_buf);
 }
 
diff --git a/kernel/trace/trace_eprobe.c b/kernel/trace/trace_eprobe.c
index 928867f527e7..32688357c6da 100644
--- a/kernel/trace/trace_eprobe.c
+++ b/kernel/trace/trace_eprobe.c
@@ -226,6 +226,7 @@ static int trace_eprobe_tp_arg_update(struct trace_eprobe *ep, int i)
 	struct probe_arg *parg = &ep->tp.args[i];
 	struct ftrace_event_field *field;
 	struct list_head *head;
+	int ret = -ENOENT;
 
 	head = trace_get_fields(ep->event);
 	list_for_each_entry(field, head, link) {
@@ -235,9 +236,20 @@ static int trace_eprobe_tp_arg_update(struct trace_eprobe *ep, int i)
 			return 0;
 		}
 	}
+
+	/*
+	 * Argument not found on event. But allow for comm and COMM
+	 * to be used to get the current->comm.
+	 */
+	if (strcmp(parg->code->data, "COMM") == 0 ||
+	    strcmp(parg->code->data, "comm") == 0) {
+		parg->code->op = FETCH_OP_COMM;
+		ret = 0;
+	}
+
 	kfree(parg->code->data);
 	parg->code->data = NULL;
-	return -ENOENT;
+	return ret;
 }
 
 static int eprobe_event_define_fields(struct trace_event_call *event_call)
@@ -308,6 +320,24 @@ static unsigned long get_event_field(struct fetch_insn *code, void *rec)
 
 	addr = rec + field->offset;
 
+	if (is_string_field(field)) {
+		switch (field->filter_type) {
+		case FILTER_DYN_STRING:
+			val = (unsigned long)(rec + (*(unsigned int *)addr & 0xffff));
+			break;
+		case FILTER_STATIC_STRING:
+			val = (unsigned long)addr;
+			break;
+		case FILTER_PTR_STRING:
+			val = (unsigned long)(*(char *)addr);
+			break;
+		default:
+			WARN_ON_ONCE(1);
+			return 0;
+		}
+		return val;
+	}
+
 	switch (field->size) {
 	case 1:
 		if (field->is_signed)
@@ -339,16 +369,38 @@ static unsigned long get_event_field(struct fetch_insn *code, void *rec)
 
 static int get_eprobe_size(struct trace_probe *tp, void *rec)
 {
+	struct fetch_insn *code;
 	struct probe_arg *arg;
 	int i, len, ret = 0;
 
 	for (i = 0; i < tp->nr_args; i++) {
 		arg = tp->args + i;
-		if (unlikely(arg->dynamic)) {
+		if (arg->dynamic) {
 			unsigned long val;
 
-			val = get_event_field(arg->code, rec);
-			len = process_fetch_insn_bottom(arg->code + 1, val, NULL, NULL);
+			code = arg->code;
+ retry:
+			switch (code->op) {
+			case FETCH_OP_TP_ARG:
+				val = get_event_field(code, rec);
+				break;
+			case FETCH_OP_IMM:
+				val = code->immediate;
+				break;
+			case FETCH_OP_COMM:
+				val = (unsigned long)current->comm;
+				break;
+			case FETCH_OP_DATA:
+				val = (unsigned long)code->data;
+				break;
+			case FETCH_NOP_SYMBOL:	/* Ignore a place holder */
+				code++;
+				goto retry;
+			default:
+				continue;
+			}
+			code++;
+			len = process_fetch_insn_bottom(code, val, NULL, NULL);
 			if (len > 0)
 				ret += len;
 		}
@@ -366,8 +418,28 @@ process_fetch_insn(struct fetch_insn *code, void *rec, void *dest,
 {
 	unsigned long val;
 
-	val = get_event_field(code, rec);
-	return process_fetch_insn_bottom(code + 1, val, dest, base);
+ retry:
+	switch (code->op) {
+	case FETCH_OP_TP_ARG:
+		val = get_event_field(code, rec);
+		break;
+	case FETCH_OP_IMM:
+		val = code->immediate;
+		break;
+	case FETCH_OP_COMM:
+		val = (unsigned long)current->comm;
+		break;
+	case FETCH_OP_DATA:
+		val = (unsigned long)code->data;
+		break;
+	case FETCH_NOP_SYMBOL:	/* Ignore a place holder */
+		code++;
+		goto retry;
+	default:
+		return -EILSEQ;
+	}
+	code++;
+	return process_fetch_insn_bottom(code, val, dest, base);
 }
 NOKPROBE_SYMBOL(process_fetch_insn)
 
@@ -849,6 +921,10 @@ static int trace_eprobe_tp_update_arg(struct trace_eprobe *ep, const char *argv[
 	if (ep->tp.args[i].code->op == FETCH_OP_TP_ARG)
 		ret = trace_eprobe_tp_arg_update(ep, i);
 
+	/* Handle symbols "@" */
+	if (!ret)
+		ret = traceprobe_update_arg(&ep->tp.args[i]);
+
 	return ret;
 }
 
diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index fba8cb77a73a..083f648e3265 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -157,7 +157,7 @@ static void perf_trace_event_unreg(struct perf_event *p_event)
 	int i;
 
 	if (--tp_event->perf_refcount > 0)
-		goto out;
+		return;
 
 	tp_event->class->reg(tp_event, TRACE_REG_PERF_UNREGISTER, NULL);
 
@@ -176,8 +176,6 @@ static void perf_trace_event_unreg(struct perf_event *p_event)
 			perf_trace_buf[i] = NULL;
 		}
 	}
-out:
-	trace_event_put_ref(tp_event);
 }
 
 static int perf_trace_event_open(struct perf_event *p_event)
@@ -241,6 +239,7 @@ void perf_trace_destroy(struct perf_event *p_event)
 	mutex_lock(&event_mutex);
 	perf_trace_event_close(p_event);
 	perf_trace_event_unreg(p_event);
+	trace_event_put_ref(p_event->tp_event);
 	mutex_unlock(&event_mutex);
 }
 
@@ -292,6 +291,7 @@ void perf_kprobe_destroy(struct perf_event *p_event)
 	mutex_lock(&event_mutex);
 	perf_trace_event_close(p_event);
 	perf_trace_event_unreg(p_event);
+	trace_event_put_ref(p_event->tp_event);
 	mutex_unlock(&event_mutex);
 
 	destroy_local_trace_kprobe(p_event->tp_event);
@@ -347,6 +347,7 @@ void perf_uprobe_destroy(struct perf_event *p_event)
 	mutex_lock(&event_mutex);
 	perf_trace_event_close(p_event);
 	perf_trace_event_unreg(p_event);
+	trace_event_put_ref(p_event->tp_event);
 	mutex_unlock(&event_mutex);
 	destroy_local_trace_uprobe(p_event->tp_event);
 }
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index c4f654efb77a..c84c94334a60 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -176,6 +176,7 @@ static int trace_define_generic_fields(void)
 
 	__generic_field(int, CPU, FILTER_CPU);
 	__generic_field(int, cpu, FILTER_CPU);
+	__generic_field(int, common_cpu, FILTER_CPU);
 	__generic_field(char *, COMM, FILTER_COMM);
 	__generic_field(char *, comm, FILTER_COMM);
 
diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index bb4605b60de7..2bbe4a7c6a2b 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -279,7 +279,14 @@ static int parse_probe_vars(char *arg, const struct fetch_type *t,
 	int ret = 0;
 	int len;
 
-	if (strcmp(arg, "retval") == 0) {
+	if (flags & TPARG_FL_TPOINT) {
+		if (code->data)
+			return -EFAULT;
+		code->data = kstrdup(arg, GFP_KERNEL);
+		if (!code->data)
+			return -ENOMEM;
+		code->op = FETCH_OP_TP_ARG;
+	} else if (strcmp(arg, "retval") == 0) {
 		if (flags & TPARG_FL_RETURN) {
 			code->op = FETCH_OP_RETVAL;
 		} else {
@@ -303,7 +310,7 @@ static int parse_probe_vars(char *arg, const struct fetch_type *t,
 			}
 		} else
 			goto inval_var;
-	} else if (strcmp(arg, "comm") == 0) {
+	} else if (strcmp(arg, "comm") == 0 || strcmp(arg, "COMM") == 0) {
 		code->op = FETCH_OP_COMM;
 #ifdef CONFIG_HAVE_FUNCTION_ARG_ACCESS_API
 	} else if (((flags & TPARG_FL_MASK) ==
@@ -319,13 +326,6 @@ static int parse_probe_vars(char *arg, const struct fetch_type *t,
 		code->op = FETCH_OP_ARG;
 		code->param = (unsigned int)param - 1;
 #endif
-	} else if (flags & TPARG_FL_TPOINT) {
-		if (code->data)
-			return -EFAULT;
-		code->data = kstrdup(arg, GFP_KERNEL);
-		if (!code->data)
-			return -ENOMEM;
-		code->op = FETCH_OP_TP_ARG;
 	} else
 		goto inval_var;
 
@@ -380,6 +380,11 @@ parse_probe_arg(char *arg, const struct fetch_type *type,
 		break;
 
 	case '%':	/* named register */
+		if (flags & TPARG_FL_TPOINT) {
+			/* eprobes do not handle registers */
+			trace_probe_log_err(offs, BAD_VAR);
+			break;
+		}
 		ret = regs_query_register_offset(arg + 1);
 		if (ret >= 0) {
 			code->op = FETCH_OP_REG;
@@ -613,9 +618,11 @@ static int traceprobe_parse_probe_arg_body(const char *argv, ssize_t *size,
 
 	/*
 	 * Since $comm and immediate string can not be dereferenced,
-	 * we can find those by strcmp.
+	 * we can find those by strcmp. But ignore for eprobes.
 	 */
-	if (strcmp(arg, "$comm") == 0 || strncmp(arg, "\\\"", 2) == 0) {
+	if (!(flags & TPARG_FL_TPOINT) &&
+	    (strcmp(arg, "$comm") == 0 || strcmp(arg, "$COMM") == 0 ||
+	     strncmp(arg, "\\\"", 2) == 0)) {
 		/* The type of $comm must be "string", and not an array. */
 		if (parg->count || (t && strcmp(t, "string")))
 			goto out;
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index ad912511a0c0..1cfa269bd448 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -537,7 +537,7 @@ int lockup_detector_offline_cpu(unsigned int cpu)
 	return 0;
 }
 
-static void lockup_detector_reconfigure(void)
+static void __lockup_detector_reconfigure(void)
 {
 	cpus_read_lock();
 	watchdog_nmi_stop();
@@ -557,6 +557,13 @@ static void lockup_detector_reconfigure(void)
 	__lockup_detector_cleanup();
 }
 
+void lockup_detector_reconfigure(void)
+{
+	mutex_lock(&watchdog_mutex);
+	__lockup_detector_reconfigure();
+	mutex_unlock(&watchdog_mutex);
+}
+
 /*
  * Create the watchdog infrastructure and configure the detector(s).
  */
@@ -573,13 +580,13 @@ static __init void lockup_detector_setup(void)
 		return;
 
 	mutex_lock(&watchdog_mutex);
-	lockup_detector_reconfigure();
+	__lockup_detector_reconfigure();
 	softlockup_initialized = true;
 	mutex_unlock(&watchdog_mutex);
 }
 
 #else /* CONFIG_SOFTLOCKUP_DETECTOR */
-static void lockup_detector_reconfigure(void)
+static void __lockup_detector_reconfigure(void)
 {
 	cpus_read_lock();
 	watchdog_nmi_stop();
@@ -587,9 +594,13 @@ static void lockup_detector_reconfigure(void)
 	watchdog_nmi_start();
 	cpus_read_unlock();
 }
+void lockup_detector_reconfigure(void)
+{
+	__lockup_detector_reconfigure();
+}
 static inline void lockup_detector_setup(void)
 {
-	lockup_detector_reconfigure();
+	__lockup_detector_reconfigure();
 }
 #endif /* !CONFIG_SOFTLOCKUP_DETECTOR */
 
@@ -629,7 +640,7 @@ static void proc_watchdog_update(void)
 {
 	/* Remove impossible cpus to keep sysctl output clean. */
 	cpumask_and(&watchdog_cpumask, &watchdog_cpumask, cpu_possible_mask);
-	lockup_detector_reconfigure();
+	__lockup_detector_reconfigure();
 }
 
 /*
diff --git a/lib/list_debug.c b/lib/list_debug.c
index 5d5424b51b74..413daa72a3d8 100644
--- a/lib/list_debug.c
+++ b/lib/list_debug.c
@@ -20,7 +20,11 @@
 bool __list_add_valid(struct list_head *new, struct list_head *prev,
 		      struct list_head *next)
 {
-	if (CHECK_DATA_CORRUPTION(next->prev != prev,
+	if (CHECK_DATA_CORRUPTION(prev == NULL,
+			"list_add corruption. prev is NULL.\n") ||
+	    CHECK_DATA_CORRUPTION(next == NULL,
+			"list_add corruption. next is NULL.\n") ||
+	    CHECK_DATA_CORRUPTION(next->prev != prev,
 			"list_add corruption. next->prev should be prev (%px), but was %px. (next=%px).\n",
 			prev, next->prev, next) ||
 	    CHECK_DATA_CORRUPTION(prev->next != next,
@@ -42,7 +46,11 @@ bool __list_del_entry_valid(struct list_head *entry)
 	prev = entry->prev;
 	next = entry->next;
 
-	if (CHECK_DATA_CORRUPTION(next == LIST_POISON1,
+	if (CHECK_DATA_CORRUPTION(next == NULL,
+			"list_del corruption, %px->next is NULL\n", entry) ||
+	    CHECK_DATA_CORRUPTION(prev == NULL,
+			"list_del corruption, %px->prev is NULL\n", entry) ||
+	    CHECK_DATA_CORRUPTION(next == LIST_POISON1,
 			"list_del corruption, %px->next is LIST_POISON1 (%px)\n",
 			entry, LIST_POISON1) ||
 	    CHECK_DATA_CORRUPTION(prev == LIST_POISON2,
diff --git a/net/can/j1939/socket.c b/net/can/j1939/socket.c
index 6dff4510687a..41016aff21c5 100644
--- a/net/can/j1939/socket.c
+++ b/net/can/j1939/socket.c
@@ -178,7 +178,10 @@ static void j1939_sk_queue_activate_next_locked(struct j1939_session *session)
 	if (!first)
 		return;
 
-	if (WARN_ON_ONCE(j1939_session_activate(first))) {
+	if (j1939_session_activate(first)) {
+		netdev_warn_once(first->priv->ndev,
+				 "%s: 0x%p: Identical session is already activated.\n",
+				 __func__, first);
 		first->err = -EBUSY;
 		goto activate_next;
 	} else {
diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index 307ee1174a6e..d7d86c944d76 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -260,6 +260,8 @@ static void __j1939_session_drop(struct j1939_session *session)
 
 static void j1939_session_destroy(struct j1939_session *session)
 {
+	struct sk_buff *skb;
+
 	if (session->transmission) {
 		if (session->err)
 			j1939_sk_errqueue(session, J1939_ERRQUEUE_TX_ABORT);
@@ -274,7 +276,11 @@ static void j1939_session_destroy(struct j1939_session *session)
 	WARN_ON_ONCE(!list_empty(&session->sk_session_queue_entry));
 	WARN_ON_ONCE(!list_empty(&session->active_session_list_entry));
 
-	skb_queue_purge(&session->skb_queue);
+	while ((skb = skb_dequeue(&session->skb_queue)) != NULL) {
+		/* drop ref taken in j1939_session_skb_queue() */
+		skb_unref(skb);
+		kfree_skb(skb);
+	}
 	__j1939_session_drop(session);
 	j1939_priv_put(session->priv);
 	kfree(session);
diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
index ea61dfe19c86..d2745c54737e 100644
--- a/net/core/bpf_sk_storage.c
+++ b/net/core/bpf_sk_storage.c
@@ -865,10 +865,18 @@ static int bpf_iter_init_sk_storage_map(void *priv_data,
 {
 	struct bpf_iter_seq_sk_storage_map_info *seq_info = priv_data;
 
+	bpf_map_inc_with_uref(aux->map);
 	seq_info->map = aux->map;
 	return 0;
 }
 
+static void bpf_iter_fini_sk_storage_map(void *priv_data)
+{
+	struct bpf_iter_seq_sk_storage_map_info *seq_info = priv_data;
+
+	bpf_map_put_with_uref(seq_info->map);
+}
+
 static int bpf_iter_attach_map(struct bpf_prog *prog,
 			       union bpf_iter_link_info *linfo,
 			       struct bpf_iter_aux_info *aux)
@@ -886,7 +894,7 @@ static int bpf_iter_attach_map(struct bpf_prog *prog,
 	if (map->map_type != BPF_MAP_TYPE_SK_STORAGE)
 		goto put_map;
 
-	if (prog->aux->max_rdonly_access > map->value_size) {
+	if (prog->aux->max_rdwr_access > map->value_size) {
 		err = -EACCES;
 		goto put_map;
 	}
@@ -914,7 +922,7 @@ static const struct seq_operations bpf_sk_storage_map_seq_ops = {
 static const struct bpf_iter_seq_info iter_seq_info = {
 	.seq_ops		= &bpf_sk_storage_map_seq_ops,
 	.init_seq_private	= bpf_iter_init_sk_storage_map,
-	.fini_seq_private	= NULL,
+	.fini_seq_private	= bpf_iter_fini_sk_storage_map,
 	.seq_priv_size		= sizeof(struct bpf_iter_seq_sk_storage_map_info),
 };
 
diff --git a/net/core/devlink.c b/net/core/devlink.c
index db76c55e1a6d..b4d7a7f749c1 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4413,7 +4413,7 @@ static int devlink_param_get(struct devlink *devlink,
 			     const struct devlink_param *param,
 			     struct devlink_param_gset_ctx *ctx)
 {
-	if (!param->get)
+	if (!param->get || devlink->reload_failed)
 		return -EOPNOTSUPP;
 	return param->get(devlink, param->id, ctx);
 }
@@ -4422,7 +4422,7 @@ static int devlink_param_set(struct devlink *devlink,
 			     const struct devlink_param *param,
 			     struct devlink_param_gset_ctx *ctx)
 {
-	if (!param->set)
+	if (!param->set || devlink->reload_failed)
 		return -EOPNOTSUPP;
 	return param->set(devlink, param->id, ctx);
 }
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 6351b6af7aca..795b3acfb9fd 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -789,13 +789,22 @@ static int sock_map_init_seq_private(void *priv_data,
 {
 	struct sock_map_seq_info *info = priv_data;
 
+	bpf_map_inc_with_uref(aux->map);
 	info->map = aux->map;
 	return 0;
 }
 
+static void sock_map_fini_seq_private(void *priv_data)
+{
+	struct sock_map_seq_info *info = priv_data;
+
+	bpf_map_put_with_uref(info->map);
+}
+
 static const struct bpf_iter_seq_info sock_map_iter_seq_info = {
 	.seq_ops		= &sock_map_seq_ops,
 	.init_seq_private	= sock_map_init_seq_private,
+	.fini_seq_private	= sock_map_fini_seq_private,
 	.seq_priv_size		= sizeof(struct sock_map_seq_info),
 };
 
@@ -1376,18 +1385,27 @@ static const struct seq_operations sock_hash_seq_ops = {
 };
 
 static int sock_hash_init_seq_private(void *priv_data,
-				     struct bpf_iter_aux_info *aux)
+				      struct bpf_iter_aux_info *aux)
 {
 	struct sock_hash_seq_info *info = priv_data;
 
+	bpf_map_inc_with_uref(aux->map);
 	info->map = aux->map;
 	info->htab = container_of(aux->map, struct bpf_shtab, map);
 	return 0;
 }
 
+static void sock_hash_fini_seq_private(void *priv_data)
+{
+	struct sock_hash_seq_info *info = priv_data;
+
+	bpf_map_put_with_uref(info->map);
+}
+
 static const struct bpf_iter_seq_info sock_hash_iter_seq_info = {
 	.seq_ops		= &sock_hash_seq_ops,
 	.init_seq_private	= sock_hash_init_seq_private,
+	.fini_seq_private	= sock_hash_fini_seq_private,
 	.seq_priv_size		= sizeof(struct sock_hash_seq_info),
 };
 
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 63e88de96393..a21015d6bd36 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -111,11 +111,14 @@ int dsa_port_set_state(struct dsa_port *dp, u8 state, bool do_fast_age)
 static void dsa_port_set_state_now(struct dsa_port *dp, u8 state,
 				   bool do_fast_age)
 {
+	struct dsa_switch *ds = dp->ds;
 	int err;
 
 	err = dsa_port_set_state(dp, state, do_fast_age);
-	if (err)
-		pr_err("DSA: failed to set STP state %u (%d)\n", state, err);
+	if (err && err != -EOPNOTSUPP) {
+		dev_err(ds->dev, "port %d failed to set STP state %u: %pe\n",
+			dp->index, state, ERR_PTR(err));
+	}
 }
 
 int dsa_port_enable_rt(struct dsa_port *dp, struct phy_device *phy)
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 04c3cb4c5fec..7951ade74d14 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1289,8 +1289,7 @@ struct dst_entry *ip6_dst_lookup_tunnel(struct sk_buff *skb,
 	fl6.daddr = info->key.u.ipv6.dst;
 	fl6.saddr = info->key.u.ipv6.src;
 	prio = info->key.tos;
-	fl6.flowlabel = ip6_make_flowinfo(RT_TOS(prio),
-					  info->key.label);
+	fl6.flowlabel = ip6_make_flowinfo(prio, info->key.label);
 
 	dst = ipv6_stub->ipv6_dst_lookup_flow(net, sock->sk, &fl6,
 					      NULL);
diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index 4b098521a44c..8108e9a941d0 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -1317,6 +1317,9 @@ static void ndisc_router_discovery(struct sk_buff *skb)
 	if (!rt && lifetime) {
 		ND_PRINTK(3, info, "RA: adding default router\n");
 
+		if (neigh)
+			neigh_release(neigh);
+
 		rt = rt6_add_dflt_router(net, &ipv6_hdr(skb)->saddr,
 					 skb->dev, pref, defrtr_usr_metric);
 		if (!rt) {
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 13d14fcc2371..2f22a172a27e 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -837,7 +837,7 @@ static int nf_tables_dump_tables(struct sk_buff *skb,
 
 	rcu_read_lock();
 	nft_net = nft_pernet(net);
-	cb->seq = nft_net->base_seq;
+	cb->seq = READ_ONCE(nft_net->base_seq);
 
 	list_for_each_entry_rcu(table, &nft_net->tables, list) {
 		if (family != NFPROTO_UNSPEC && family != table->family)
@@ -1626,7 +1626,7 @@ static int nf_tables_dump_chains(struct sk_buff *skb,
 
 	rcu_read_lock();
 	nft_net = nft_pernet(net);
-	cb->seq = nft_net->base_seq;
+	cb->seq = READ_ONCE(nft_net->base_seq);
 
 	list_for_each_entry_rcu(table, &nft_net->tables, list) {
 		if (family != NFPROTO_UNSPEC && family != table->family)
@@ -3054,7 +3054,7 @@ static int nf_tables_dump_rules(struct sk_buff *skb,
 
 	rcu_read_lock();
 	nft_net = nft_pernet(net);
-	cb->seq = nft_net->base_seq;
+	cb->seq = READ_ONCE(nft_net->base_seq);
 
 	list_for_each_entry_rcu(table, &nft_net->tables, list) {
 		if (family != NFPROTO_UNSPEC && family != table->family)
@@ -3810,7 +3810,7 @@ static int nf_tables_set_alloc_name(struct nft_ctx *ctx, struct nft_set *set,
 		list_for_each_entry(i, &ctx->table->sets, list) {
 			int tmp;
 
-			if (!nft_is_active_next(ctx->net, set))
+			if (!nft_is_active_next(ctx->net, i))
 				continue;
 			if (!sscanf(i->name, name, &tmp))
 				continue;
@@ -4036,7 +4036,7 @@ static int nf_tables_dump_sets(struct sk_buff *skb, struct netlink_callback *cb)
 
 	rcu_read_lock();
 	nft_net = nft_pernet(net);
-	cb->seq = nft_net->base_seq;
+	cb->seq = READ_ONCE(nft_net->base_seq);
 
 	list_for_each_entry_rcu(table, &nft_net->tables, list) {
 		if (ctx->family != NFPROTO_UNSPEC &&
@@ -4354,6 +4354,11 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 		err = nf_tables_set_desc_parse(&desc, nla[NFTA_SET_DESC]);
 		if (err < 0)
 			return err;
+
+		if (desc.field_count > 1 && !(flags & NFT_SET_CONCAT))
+			return -EINVAL;
+	} else if (flags & NFT_SET_CONCAT) {
+		return -EINVAL;
 	}
 
 	if (nla[NFTA_SET_EXPR] || nla[NFTA_SET_EXPRESSIONS])
@@ -4964,6 +4969,8 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
 
 	rcu_read_lock();
 	nft_net = nft_pernet(net);
+	cb->seq = READ_ONCE(nft_net->base_seq);
+
 	list_for_each_entry_rcu(table, &nft_net->tables, list) {
 		if (dump_ctx->ctx.family != NFPROTO_UNSPEC &&
 		    dump_ctx->ctx.family != table->family)
@@ -5099,6 +5106,9 @@ static int nft_setelem_parse_flags(const struct nft_set *set,
 	if (!(set->flags & NFT_SET_INTERVAL) &&
 	    *flags & NFT_SET_ELEM_INTERVAL_END)
 		return -EINVAL;
+	if ((*flags & (NFT_SET_ELEM_INTERVAL_END | NFT_SET_ELEM_CATCHALL)) ==
+	    (NFT_SET_ELEM_INTERVAL_END | NFT_SET_ELEM_CATCHALL))
+		return -EINVAL;
 
 	return 0;
 }
@@ -5477,7 +5487,7 @@ int nft_set_elem_expr_clone(const struct nft_ctx *ctx, struct nft_set *set,
 
 		err = nft_expr_clone(expr, set->exprs[i]);
 		if (err < 0) {
-			nft_expr_destroy(ctx, expr);
+			kfree(expr);
 			goto err_expr;
 		}
 		expr_array[i] = expr;
@@ -5709,6 +5719,24 @@ static void nft_setelem_remove(const struct net *net,
 		set->ops->remove(net, set, elem);
 }
 
+static bool nft_setelem_valid_key_end(const struct nft_set *set,
+				      struct nlattr **nla, u32 flags)
+{
+	if ((set->flags & (NFT_SET_CONCAT | NFT_SET_INTERVAL)) ==
+			  (NFT_SET_CONCAT | NFT_SET_INTERVAL)) {
+		if (flags & NFT_SET_ELEM_INTERVAL_END)
+			return false;
+		if (!nla[NFTA_SET_ELEM_KEY_END] &&
+		    !(flags & NFT_SET_ELEM_CATCHALL))
+			return false;
+	} else {
+		if (nla[NFTA_SET_ELEM_KEY_END])
+			return false;
+	}
+
+	return true;
+}
+
 static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			    const struct nlattr *attr, u32 nlmsg_flags)
 {
@@ -5759,6 +5787,18 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			return -EINVAL;
 	}
 
+	if (set->flags & NFT_SET_OBJECT) {
+		if (!nla[NFTA_SET_ELEM_OBJREF] &&
+		    !(flags & NFT_SET_ELEM_INTERVAL_END))
+			return -EINVAL;
+	} else {
+		if (nla[NFTA_SET_ELEM_OBJREF])
+			return -EINVAL;
+	}
+
+	if (!nft_setelem_valid_key_end(set, nla, flags))
+		return -EINVAL;
+
 	if ((flags & NFT_SET_ELEM_INTERVAL_END) &&
 	     (nla[NFTA_SET_ELEM_DATA] ||
 	      nla[NFTA_SET_ELEM_OBJREF] ||
@@ -5766,6 +5806,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	      nla[NFTA_SET_ELEM_EXPIRATION] ||
 	      nla[NFTA_SET_ELEM_USERDATA] ||
 	      nla[NFTA_SET_ELEM_EXPR] ||
+	      nla[NFTA_SET_ELEM_KEY_END] ||
 	      nla[NFTA_SET_ELEM_EXPRESSIONS]))
 		return -EINVAL;
 
@@ -5896,10 +5937,6 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	}
 
 	if (nla[NFTA_SET_ELEM_OBJREF] != NULL) {
-		if (!(set->flags & NFT_SET_OBJECT)) {
-			err = -EINVAL;
-			goto err_parse_key_end;
-		}
 		obj = nft_obj_lookup(ctx->net, ctx->table,
 				     nla[NFTA_SET_ELEM_OBJREF],
 				     set->objtype, genmask);
@@ -6184,6 +6221,9 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
 	if (!nla[NFTA_SET_ELEM_KEY] && !(flags & NFT_SET_ELEM_CATCHALL))
 		return -EINVAL;
 
+	if (!nft_setelem_valid_key_end(set, nla, flags))
+		return -EINVAL;
+
 	nft_set_ext_prepare(&tmpl);
 
 	if (flags != 0) {
@@ -6796,7 +6836,7 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 
 	rcu_read_lock();
 	nft_net = nft_pernet(net);
-	cb->seq = nft_net->base_seq;
+	cb->seq = READ_ONCE(nft_net->base_seq);
 
 	list_for_each_entry_rcu(table, &nft_net->tables, list) {
 		if (family != NFPROTO_UNSPEC && family != table->family)
@@ -7728,7 +7768,7 @@ static int nf_tables_dump_flowtable(struct sk_buff *skb,
 
 	rcu_read_lock();
 	nft_net = nft_pernet(net);
-	cb->seq = nft_net->base_seq;
+	cb->seq = READ_ONCE(nft_net->base_seq);
 
 	list_for_each_entry_rcu(table, &nft_net->tables, list) {
 		if (family != NFPROTO_UNSPEC && family != table->family)
@@ -8612,6 +8652,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 	struct nft_trans_elem *te;
 	struct nft_chain *chain;
 	struct nft_table *table;
+	unsigned int base_seq;
 	LIST_HEAD(adl);
 	int err;
 
@@ -8661,9 +8702,12 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 	 * Bump generation counter, invalidate any dump in progress.
 	 * Cannot fail after this point.
 	 */
-	while (++nft_net->base_seq == 0)
+	base_seq = READ_ONCE(nft_net->base_seq);
+	while (++base_seq == 0)
 		;
 
+	WRITE_ONCE(nft_net->base_seq, base_seq);
+
 	/* step 3. Start new generation, rules_gen_X now in use. */
 	net->nft.gencursor = nft_gencursor_next(net);
 
diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 1afca2a6c2ac..57010927e20a 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -1174,13 +1174,17 @@ static int ctrl_dumppolicy_start(struct netlink_callback *cb)
 							     op.policy,
 							     op.maxattr);
 			if (err)
-				return err;
+				goto err_free_state;
 		}
 	}
 
 	if (!ctx->state)
 		return -ENODATA;
 	return 0;
+
+err_free_state:
+	netlink_policy_dump_free(ctx->state);
+	return err;
 }
 
 static void *ctrl_dumppolicy_prep(struct sk_buff *skb,
diff --git a/net/netlink/policy.c b/net/netlink/policy.c
index 8d7c900e27f4..87e3de0fde89 100644
--- a/net/netlink/policy.c
+++ b/net/netlink/policy.c
@@ -144,7 +144,7 @@ int netlink_policy_dump_add_policy(struct netlink_policy_dump_state **pstate,
 
 	err = add_policy(&state, policy, maxtype);
 	if (err)
-		return err;
+		goto err_try_undo;
 
 	for (policy_idx = 0;
 	     policy_idx < state->n_alloc && state->policies[policy_idx].policy;
@@ -164,7 +164,7 @@ int netlink_policy_dump_add_policy(struct netlink_policy_dump_state **pstate,
 						 policy[type].nested_policy,
 						 policy[type].len);
 				if (err)
-					return err;
+					goto err_try_undo;
 				break;
 			default:
 				break;
@@ -174,6 +174,16 @@ int netlink_policy_dump_add_policy(struct netlink_policy_dump_state **pstate,
 
 	*pstate = state;
 	return 0;
+
+err_try_undo:
+	/* Try to preserve reasonable unwind semantics - if we're starting from
+	 * scratch clean up fully, otherwise record what we got and caller will.
+	 */
+	if (!*pstate)
+		netlink_policy_dump_free(state);
+	else
+		*pstate = state;
+	return err;
 }
 
 static bool
diff --git a/net/qrtr/mhi.c b/net/qrtr/mhi.c
index fa611678af05..49e7cab43d24 100644
--- a/net/qrtr/mhi.c
+++ b/net/qrtr/mhi.c
@@ -78,11 +78,6 @@ static int qcom_mhi_qrtr_probe(struct mhi_device *mhi_dev,
 	struct qrtr_mhi_dev *qdev;
 	int rc;
 
-	/* start channels */
-	rc = mhi_prepare_for_transfer(mhi_dev);
-	if (rc)
-		return rc;
-
 	qdev = devm_kzalloc(&mhi_dev->dev, sizeof(*qdev), GFP_KERNEL);
 	if (!qdev)
 		return -ENOMEM;
@@ -96,6 +91,13 @@ static int qcom_mhi_qrtr_probe(struct mhi_device *mhi_dev,
 	if (rc)
 		return rc;
 
+	/* start channels */
+	rc = mhi_prepare_for_transfer(mhi_dev);
+	if (rc) {
+		qrtr_endpoint_unregister(&qdev->ep);
+		return rc;
+	}
+
 	dev_dbg(qdev->dev, "Qualcomm MHI QRTR driver probed\n");
 
 	return 0;
diff --git a/net/rds/ib_recv.c b/net/rds/ib_recv.c
index 6fdedd9dbbc2..cfbf0e129cba 100644
--- a/net/rds/ib_recv.c
+++ b/net/rds/ib_recv.c
@@ -363,6 +363,7 @@ static int acquire_refill(struct rds_connection *conn)
 static void release_refill(struct rds_connection *conn)
 {
 	clear_bit(RDS_RECV_REFILL, &conn->c_flags);
+	smp_mb__after_atomic();
 
 	/* We don't use wait_on_bit()/wake_up_bit() because our waking is in a
 	 * hot path and finding waiters is very rare.  We don't want to walk
diff --git a/net/sunrpc/auth.c b/net/sunrpc/auth.c
index a9f0d17fdb0d..1bae32c48284 100644
--- a/net/sunrpc/auth.c
+++ b/net/sunrpc/auth.c
@@ -445,7 +445,7 @@ rpcauth_prune_expired(struct list_head *free, int nr_to_scan)
 		 * Enforce a 60 second garbage collection moratorium
 		 * Note that the cred_unused list must be time-ordered.
 		 */
-		if (!time_in_range(cred->cr_expire, expired, jiffies))
+		if (time_in_range(cred->cr_expire, expired, jiffies))
 			continue;
 		if (!rpcauth_unhash_cred(cred))
 			continue;
diff --git a/net/sunrpc/backchannel_rqst.c b/net/sunrpc/backchannel_rqst.c
index 22a2c235abf1..77e347a45344 100644
--- a/net/sunrpc/backchannel_rqst.c
+++ b/net/sunrpc/backchannel_rqst.c
@@ -64,6 +64,17 @@ static void xprt_free_allocation(struct rpc_rqst *req)
 	kfree(req);
 }
 
+static void xprt_bc_reinit_xdr_buf(struct xdr_buf *buf)
+{
+	buf->head[0].iov_len = PAGE_SIZE;
+	buf->tail[0].iov_len = 0;
+	buf->pages = NULL;
+	buf->page_len = 0;
+	buf->flags = 0;
+	buf->len = 0;
+	buf->buflen = PAGE_SIZE;
+}
+
 static int xprt_alloc_xdr_buf(struct xdr_buf *buf, gfp_t gfp_flags)
 {
 	struct page *page;
@@ -292,6 +303,9 @@ void xprt_free_bc_rqst(struct rpc_rqst *req)
 	 */
 	spin_lock_bh(&xprt->bc_pa_lock);
 	if (xprt_need_to_requeue(xprt)) {
+		xprt_bc_reinit_xdr_buf(&req->rq_snd_buf);
+		xprt_bc_reinit_xdr_buf(&req->rq_rcv_buf);
+		req->rq_rcv_buf.len = PAGE_SIZE;
 		list_add_tail(&req->rq_bc_pa_list, &xprt->bc_pa_list);
 		xprt->bc_alloc_count++;
 		atomic_inc(&xprt->bc_slot_count);
diff --git a/net/sunrpc/sysfs.c b/net/sunrpc/sysfs.c
index 326a31422a3c..a7020b1f3ec7 100644
--- a/net/sunrpc/sysfs.c
+++ b/net/sunrpc/sysfs.c
@@ -282,8 +282,10 @@ static ssize_t rpc_sysfs_xprt_state_change(struct kobject *kobj,
 	int offline = 0, online = 0, remove = 0;
 	struct rpc_xprt_switch *xps = rpc_sysfs_xprt_kobj_get_xprt_switch(kobj);
 
-	if (!xprt)
-		return 0;
+	if (!xprt || !xps) {
+		count = 0;
+		goto out_put;
+	}
 
 	if (!strncmp(buf, "offline", 7))
 		offline = 1;
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 5df530e89e5a..5d46036f3ad7 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1285,6 +1285,7 @@ static void vsock_connect_timeout(struct work_struct *work)
 	if (sk->sk_state == TCP_SYN_SENT &&
 	    (sk->sk_shutdown != SHUTDOWN_MASK)) {
 		sk->sk_state = TCP_CLOSE;
+		sk->sk_socket->state = SS_UNCONNECTED;
 		sk->sk_err = ETIMEDOUT;
 		sk_error_report(sk);
 		vsock_transport_cancel_pkt(vsk);
@@ -1390,7 +1391,14 @@ static int vsock_connect(struct socket *sock, struct sockaddr *addr,
 			 * timeout fires.
 			 */
 			sock_hold(sk);
-			schedule_delayed_work(&vsk->connect_work, timeout);
+
+			/* If the timeout function is already scheduled,
+			 * reschedule it, then ungrab the socket refcount to
+			 * keep it balanced.
+			 */
+			if (mod_delayed_work(system_wq, &vsk->connect_work,
+					     timeout))
+				sock_put(sk);
 
 			/* Skip ahead to preserve error code set above. */
 			goto out_wait;
diff --git a/scripts/Makefile.gcc-plugins b/scripts/Makefile.gcc-plugins
index 4aad28480035..36814be80264 100644
--- a/scripts/Makefile.gcc-plugins
+++ b/scripts/Makefile.gcc-plugins
@@ -6,7 +6,7 @@ gcc-plugin-$(CONFIG_GCC_PLUGIN_LATENT_ENTROPY)	+= latent_entropy_plugin.so
 gcc-plugin-cflags-$(CONFIG_GCC_PLUGIN_LATENT_ENTROPY)		\
 		+= -DLATENT_ENTROPY_PLUGIN
 ifdef CONFIG_GCC_PLUGIN_LATENT_ENTROPY
-    DISABLE_LATENT_ENTROPY_PLUGIN += -fplugin-arg-latent_entropy_plugin-disable
+    DISABLE_LATENT_ENTROPY_PLUGIN += -fplugin-arg-latent_entropy_plugin-disable -ULATENT_ENTROPY_PLUGIN
 endif
 export DISABLE_LATENT_ENTROPY_PLUGIN
 
diff --git a/scripts/dummy-tools/dummy-plugin-dir/include/plugin-version.h b/scripts/dummy-tools/dummy-plugin-dir/include/plugin-version.h
new file mode 100644
index 000000000000..e69de29bb2d1
diff --git a/scripts/dummy-tools/gcc b/scripts/dummy-tools/gcc
index b2483149bbe5..7db825843435 100755
--- a/scripts/dummy-tools/gcc
+++ b/scripts/dummy-tools/gcc
@@ -96,12 +96,8 @@ fi
 
 # To set GCC_PLUGINS
 if arg_contain -print-file-name=plugin "$@"; then
-	plugin_dir=$(mktemp -d)
-
-	mkdir -p $plugin_dir/include
-	touch $plugin_dir/include/plugin-version.h
-
-	echo $plugin_dir
+	# Use $0 to find the in-tree dummy directory
+	echo "$(dirname "$(readlink -f "$0")")/dummy-plugin-dir"
 	exit 0
 fi
 
diff --git a/scripts/module.lds.S b/scripts/module.lds.S
index 1d0e1e4dc3d2..3a3aa2354ed8 100644
--- a/scripts/module.lds.S
+++ b/scripts/module.lds.S
@@ -27,6 +27,8 @@ SECTIONS {
 	.ctors			0 : ALIGN(8) { *(SORT(.ctors.*)) *(.ctors) }
 	.init_array		0 : ALIGN(8) { *(SORT(.init_array.*)) *(.init_array) }
 
+	.altinstructions	0 : ALIGN(8) { KEEP(*(.altinstructions)) }
+	__bug_table		0 : ALIGN(8) { KEEP(*(__bug_table)) }
 	__jump_table		0 : ALIGN(8) { KEEP(*(__jump_table)) }
 
 	__patchable_function_entries : { *(__patchable_function_entries) }
diff --git a/security/apparmor/apparmorfs.c b/security/apparmor/apparmorfs.c
index 2ee3b3d29f10..a891705b1d57 100644
--- a/security/apparmor/apparmorfs.c
+++ b/security/apparmor/apparmorfs.c
@@ -401,7 +401,7 @@ static struct aa_loaddata *aa_simple_write_to_buffer(const char __user *userbuf,
 
 	data->size = copy_size;
 	if (copy_from_user(data->data, userbuf, copy_size)) {
-		kvfree(data);
+		aa_put_loaddata(data);
 		return ERR_PTR(-EFAULT);
 	}
 
diff --git a/security/apparmor/audit.c b/security/apparmor/audit.c
index f7e97c7e80f3..704b0c895605 100644
--- a/security/apparmor/audit.c
+++ b/security/apparmor/audit.c
@@ -137,7 +137,7 @@ int aa_audit(int type, struct aa_profile *profile, struct common_audit_data *sa,
 	}
 	if (AUDIT_MODE(profile) == AUDIT_QUIET ||
 	    (type == AUDIT_APPARMOR_DENIED &&
-	     AUDIT_MODE(profile) == AUDIT_QUIET))
+	     AUDIT_MODE(profile) == AUDIT_QUIET_DENIED))
 		return aad(sa)->error;
 
 	if (KILL_MODE(profile) && type == AUDIT_APPARMOR_DENIED)
diff --git a/security/apparmor/domain.c b/security/apparmor/domain.c
index 583680f6cd81..a7b3d8e58ed8 100644
--- a/security/apparmor/domain.c
+++ b/security/apparmor/domain.c
@@ -467,7 +467,7 @@ static struct aa_label *find_attach(const struct linux_binprm *bprm,
 				 * xattrs, or a longer match
 				 */
 				candidate = profile;
-				candidate_len = profile->xmatch_len;
+				candidate_len = max(count, profile->xmatch_len);
 				candidate_xattrs = ret;
 				conflict = false;
 			}
diff --git a/security/apparmor/include/lib.h b/security/apparmor/include/lib.h
index 7d27db740bc2..ac5054899f6f 100644
--- a/security/apparmor/include/lib.h
+++ b/security/apparmor/include/lib.h
@@ -22,6 +22,11 @@
  */
 
 #define DEBUG_ON (aa_g_debug)
+/*
+ * split individual debug cases out in preparation for finer grained
+ * debug controls in the future.
+ */
+#define AA_DEBUG_LABEL DEBUG_ON
 #define dbg_printk(__fmt, __args...) pr_debug(__fmt, ##__args)
 #define AA_DEBUG(fmt, args...)						\
 	do {								\
diff --git a/security/apparmor/include/policy.h b/security/apparmor/include/policy.h
index b5b4b8190e65..b5aa4231af68 100644
--- a/security/apparmor/include/policy.h
+++ b/security/apparmor/include/policy.h
@@ -135,7 +135,7 @@ struct aa_profile {
 
 	const char *attach;
 	struct aa_dfa *xmatch;
-	int xmatch_len;
+	unsigned int xmatch_len;
 	enum audit_mode audit;
 	long mode;
 	u32 path_flags;
diff --git a/security/apparmor/label.c b/security/apparmor/label.c
index 6222fdfebe4e..66bc4704f804 100644
--- a/security/apparmor/label.c
+++ b/security/apparmor/label.c
@@ -1632,9 +1632,9 @@ int aa_label_snxprint(char *str, size_t size, struct aa_ns *ns,
 	AA_BUG(!str && size != 0);
 	AA_BUG(!label);
 
-	if (flags & FLAG_ABS_ROOT) {
+	if (AA_DEBUG_LABEL && (flags & FLAG_ABS_ROOT)) {
 		ns = root_ns;
-		len = snprintf(str, size, "=");
+		len = snprintf(str, size, "_");
 		update_for_len(total, len, size, str);
 	} else if (!ns) {
 		ns = labels_ns(label);
@@ -1745,7 +1745,7 @@ void aa_label_xaudit(struct audit_buffer *ab, struct aa_ns *ns,
 	if (!use_label_hname(ns, label, flags) ||
 	    display_mode(ns, label, flags)) {
 		len  = aa_label_asxprint(&name, ns, label, flags, gfp);
-		if (len == -1) {
+		if (len < 0) {
 			AA_DEBUG("label print error");
 			return;
 		}
@@ -1773,7 +1773,7 @@ void aa_label_seq_xprint(struct seq_file *f, struct aa_ns *ns,
 		int len;
 
 		len = aa_label_asxprint(&str, ns, label, flags, gfp);
-		if (len == -1) {
+		if (len < 0) {
 			AA_DEBUG("label print error");
 			return;
 		}
@@ -1796,7 +1796,7 @@ void aa_label_xprintk(struct aa_ns *ns, struct aa_label *label, int flags,
 		int len;
 
 		len = aa_label_asxprint(&str, ns, label, flags, gfp);
-		if (len == -1) {
+		if (len < 0) {
 			AA_DEBUG("label print error");
 			return;
 		}
@@ -1896,7 +1896,8 @@ struct aa_label *aa_label_strn_parse(struct aa_label *base, const char *str,
 	AA_BUG(!str);
 
 	str = skipn_spaces(str, n);
-	if (str == NULL || (*str == '=' && base != &root_ns->unconfined->label))
+	if (str == NULL || (AA_DEBUG_LABEL && *str == '_' &&
+			    base != &root_ns->unconfined->label))
 		return ERR_PTR(-EINVAL);
 
 	len = label_count_strn_entries(str, end - str);
diff --git a/security/apparmor/mount.c b/security/apparmor/mount.c
index aa6fcfde3051..f7bb47daf2ad 100644
--- a/security/apparmor/mount.c
+++ b/security/apparmor/mount.c
@@ -229,7 +229,8 @@ static const char * const mnt_info_table[] = {
 	"failed srcname match",
 	"failed type match",
 	"failed flags match",
-	"failed data match"
+	"failed data match",
+	"failed perms check"
 };
 
 /*
@@ -284,8 +285,8 @@ static int do_match_mnt(struct aa_dfa *dfa, unsigned int start,
 			return 0;
 	}
 
-	/* failed at end of flags match */
-	return 4;
+	/* failed at perms check, don't confuse with flags match */
+	return 6;
 }
 
 
@@ -718,6 +719,7 @@ int aa_pivotroot(struct aa_label *label, const struct path *old_path,
 			aa_put_label(target);
 			goto out;
 		}
+		aa_put_label(target);
 	} else
 		/* already audited error */
 		error = PTR_ERR(target);
diff --git a/security/apparmor/policy_unpack.c b/security/apparmor/policy_unpack.c
index 4e1f96b216a8..03c9609ca407 100644
--- a/security/apparmor/policy_unpack.c
+++ b/security/apparmor/policy_unpack.c
@@ -746,16 +746,18 @@ static struct aa_profile *unpack_profile(struct aa_ext *e, char **ns_name)
 		profile->label.flags |= FLAG_HAT;
 	if (!unpack_u32(e, &tmp, NULL))
 		goto fail;
-	if (tmp == PACKED_MODE_COMPLAIN || (e->version & FORCE_COMPLAIN_FLAG))
+	if (tmp == PACKED_MODE_COMPLAIN || (e->version & FORCE_COMPLAIN_FLAG)) {
 		profile->mode = APPARMOR_COMPLAIN;
-	else if (tmp == PACKED_MODE_ENFORCE)
+	} else if (tmp == PACKED_MODE_ENFORCE) {
 		profile->mode = APPARMOR_ENFORCE;
-	else if (tmp == PACKED_MODE_KILL)
+	} else if (tmp == PACKED_MODE_KILL) {
 		profile->mode = APPARMOR_KILL;
-	else if (tmp == PACKED_MODE_UNCONFINED)
+	} else if (tmp == PACKED_MODE_UNCONFINED) {
 		profile->mode = APPARMOR_UNCONFINED;
-	else
+		profile->label.flags |= FLAG_UNCONFINED;
+	} else {
 		goto fail;
+	}
 	if (!unpack_u32(e, &tmp, NULL))
 		goto fail;
 	if (tmp)
diff --git a/sound/core/control.c b/sound/core/control.c
index a25c0d64d104..f66fe4be30d3 100644
--- a/sound/core/control.c
+++ b/sound/core/control.c
@@ -127,6 +127,7 @@ static int snd_ctl_release(struct inode *inode, struct file *file)
 			if (control->vd[idx].owner == ctl)
 				control->vd[idx].owner = NULL;
 	up_write(&card->controls_rwsem);
+	snd_fasync_free(ctl->fasync);
 	snd_ctl_empty_read_queue(ctl);
 	put_pid(ctl->pid);
 	kfree(ctl);
@@ -181,7 +182,7 @@ void snd_ctl_notify(struct snd_card *card, unsigned int mask,
 	_found:
 		wake_up(&ctl->change_sleep);
 		spin_unlock(&ctl->read_lock);
-		kill_fasync(&ctl->fasync, SIGIO, POLL_IN);
+		snd_kill_fasync(ctl->fasync, SIGIO, POLL_IN);
 	}
 	read_unlock_irqrestore(&card->ctl_files_rwlock, flags);
 }
@@ -2002,7 +2003,7 @@ static int snd_ctl_fasync(int fd, struct file * file, int on)
 	struct snd_ctl_file *ctl;
 
 	ctl = file->private_data;
-	return fasync_helper(fd, file, on, &ctl->fasync);
+	return snd_fasync_helper(fd, file, on, &ctl->fasync);
 }
 
 /* return the preferred subdevice number if already assigned;
@@ -2170,7 +2171,7 @@ static int snd_ctl_dev_disconnect(struct snd_device *device)
 	read_lock_irqsave(&card->ctl_files_rwlock, flags);
 	list_for_each_entry(ctl, &card->ctl_files, list) {
 		wake_up(&ctl->change_sleep);
-		kill_fasync(&ctl->fasync, SIGIO, POLL_ERR);
+		snd_kill_fasync(ctl->fasync, SIGIO, POLL_ERR);
 	}
 	read_unlock_irqrestore(&card->ctl_files_rwlock, flags);
 
diff --git a/sound/core/info.c b/sound/core/info.c
index a451b24199c3..9f6714e29bbc 100644
--- a/sound/core/info.c
+++ b/sound/core/info.c
@@ -111,9 +111,9 @@ static loff_t snd_info_entry_llseek(struct file *file, loff_t offset, int orig)
 	entry = data->entry;
 	mutex_lock(&entry->access);
 	if (entry->c.ops->llseek) {
-		offset = entry->c.ops->llseek(entry,
-					      data->file_private_data,
-					      file, offset, orig);
+		ret = entry->c.ops->llseek(entry,
+					   data->file_private_data,
+					   file, offset, orig);
 		goto out;
 	}
 
diff --git a/sound/core/misc.c b/sound/core/misc.c
index 50e4aaa6270d..d32a19976a2b 100644
--- a/sound/core/misc.c
+++ b/sound/core/misc.c
@@ -10,6 +10,7 @@
 #include <linux/time.h>
 #include <linux/slab.h>
 #include <linux/ioport.h>
+#include <linux/fs.h>
 #include <sound/core.h>
 
 #ifdef CONFIG_SND_DEBUG
@@ -145,3 +146,96 @@ snd_pci_quirk_lookup(struct pci_dev *pci, const struct snd_pci_quirk *list)
 }
 EXPORT_SYMBOL(snd_pci_quirk_lookup);
 #endif
+
+/*
+ * Deferred async signal helpers
+ *
+ * Below are a few helper functions to wrap the async signal handling
+ * in the deferred work.  The main purpose is to avoid the messy deadlock
+ * around tasklist_lock and co at the kill_fasync() invocation.
+ * fasync_helper() and kill_fasync() are replaced with snd_fasync_helper()
+ * and snd_kill_fasync(), respectively.  In addition, snd_fasync_free() has
+ * to be called at releasing the relevant file object.
+ */
+struct snd_fasync {
+	struct fasync_struct *fasync;
+	int signal;
+	int poll;
+	int on;
+	struct list_head list;
+};
+
+static DEFINE_SPINLOCK(snd_fasync_lock);
+static LIST_HEAD(snd_fasync_list);
+
+static void snd_fasync_work_fn(struct work_struct *work)
+{
+	struct snd_fasync *fasync;
+
+	spin_lock_irq(&snd_fasync_lock);
+	while (!list_empty(&snd_fasync_list)) {
+		fasync = list_first_entry(&snd_fasync_list, struct snd_fasync, list);
+		list_del_init(&fasync->list);
+		spin_unlock_irq(&snd_fasync_lock);
+		if (fasync->on)
+			kill_fasync(&fasync->fasync, fasync->signal, fasync->poll);
+		spin_lock_irq(&snd_fasync_lock);
+	}
+	spin_unlock_irq(&snd_fasync_lock);
+}
+
+static DECLARE_WORK(snd_fasync_work, snd_fasync_work_fn);
+
+int snd_fasync_helper(int fd, struct file *file, int on,
+		      struct snd_fasync **fasyncp)
+{
+	struct snd_fasync *fasync = NULL;
+
+	if (on) {
+		fasync = kzalloc(sizeof(*fasync), GFP_KERNEL);
+		if (!fasync)
+			return -ENOMEM;
+		INIT_LIST_HEAD(&fasync->list);
+	}
+
+	spin_lock_irq(&snd_fasync_lock);
+	if (*fasyncp) {
+		kfree(fasync);
+		fasync = *fasyncp;
+	} else {
+		if (!fasync) {
+			spin_unlock_irq(&snd_fasync_lock);
+			return 0;
+		}
+		*fasyncp = fasync;
+	}
+	fasync->on = on;
+	spin_unlock_irq(&snd_fasync_lock);
+	return fasync_helper(fd, file, on, &fasync->fasync);
+}
+EXPORT_SYMBOL_GPL(snd_fasync_helper);
+
+void snd_kill_fasync(struct snd_fasync *fasync, int signal, int poll)
+{
+	unsigned long flags;
+
+	if (!fasync || !fasync->on)
+		return;
+	spin_lock_irqsave(&snd_fasync_lock, flags);
+	fasync->signal = signal;
+	fasync->poll = poll;
+	list_move(&fasync->list, &snd_fasync_list);
+	schedule_work(&snd_fasync_work);
+	spin_unlock_irqrestore(&snd_fasync_lock, flags);
+}
+EXPORT_SYMBOL_GPL(snd_kill_fasync);
+
+void snd_fasync_free(struct snd_fasync *fasync)
+{
+	if (!fasync)
+		return;
+	fasync->on = 0;
+	flush_work(&snd_fasync_work);
+	kfree(fasync);
+}
+EXPORT_SYMBOL_GPL(snd_fasync_free);
diff --git a/sound/core/timer.c b/sound/core/timer.c
index b3214baa8919..e08a37c23add 100644
--- a/sound/core/timer.c
+++ b/sound/core/timer.c
@@ -83,7 +83,7 @@ struct snd_timer_user {
 	unsigned int filter;
 	struct timespec64 tstamp;		/* trigger tstamp */
 	wait_queue_head_t qchange_sleep;
-	struct fasync_struct *fasync;
+	struct snd_fasync *fasync;
 	struct mutex ioctl_lock;
 };
 
@@ -1345,7 +1345,7 @@ static void snd_timer_user_interrupt(struct snd_timer_instance *timeri,
 	}
       __wake:
 	spin_unlock(&tu->qlock);
-	kill_fasync(&tu->fasync, SIGIO, POLL_IN);
+	snd_kill_fasync(tu->fasync, SIGIO, POLL_IN);
 	wake_up(&tu->qchange_sleep);
 }
 
@@ -1383,7 +1383,7 @@ static void snd_timer_user_ccallback(struct snd_timer_instance *timeri,
 	spin_lock_irqsave(&tu->qlock, flags);
 	snd_timer_user_append_to_tqueue(tu, &r1);
 	spin_unlock_irqrestore(&tu->qlock, flags);
-	kill_fasync(&tu->fasync, SIGIO, POLL_IN);
+	snd_kill_fasync(tu->fasync, SIGIO, POLL_IN);
 	wake_up(&tu->qchange_sleep);
 }
 
@@ -1453,7 +1453,7 @@ static void snd_timer_user_tinterrupt(struct snd_timer_instance *timeri,
 	spin_unlock(&tu->qlock);
 	if (append == 0)
 		return;
-	kill_fasync(&tu->fasync, SIGIO, POLL_IN);
+	snd_kill_fasync(tu->fasync, SIGIO, POLL_IN);
 	wake_up(&tu->qchange_sleep);
 }
 
@@ -1521,6 +1521,7 @@ static int snd_timer_user_release(struct inode *inode, struct file *file)
 			snd_timer_instance_free(tu->timeri);
 		}
 		mutex_unlock(&tu->ioctl_lock);
+		snd_fasync_free(tu->fasync);
 		kfree(tu->queue);
 		kfree(tu->tqueue);
 		kfree(tu);
@@ -2135,7 +2136,7 @@ static int snd_timer_user_fasync(int fd, struct file * file, int on)
 	struct snd_timer_user *tu;
 
 	tu = file->private_data;
-	return fasync_helper(fd, file, on, &tu->fasync);
+	return snd_fasync_helper(fd, file, on, &tu->fasync);
 }
 
 static ssize_t snd_timer_user_read(struct file *file, char __user *buffer,
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index f7ab620d0e30..600ba91f7703 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9034,6 +9034,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1558, 0x70f4, "Clevo NH77EPY", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x70f6, "Clevo NH77DPQ-Y", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x7716, "Clevo NS50PU", ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1558, 0x7717, "Clevo NS70PU", ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x7718, "Clevo L140PU", ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x8228, "Clevo NR40BU", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x8520, "Clevo NH50D[CD]", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
diff --git a/sound/soc/codecs/tas2770.c b/sound/soc/codecs/tas2770.c
index c5ea3b115966..b8cda6b14b49 100644
--- a/sound/soc/codecs/tas2770.c
+++ b/sound/soc/codecs/tas2770.c
@@ -46,34 +46,22 @@ static void tas2770_reset(struct tas2770_priv *tas2770)
 	usleep_range(1000, 2000);
 }
 
-static int tas2770_set_bias_level(struct snd_soc_component *component,
-				 enum snd_soc_bias_level level)
+static int tas2770_update_pwr_ctrl(struct tas2770_priv *tas2770)
 {
-	struct tas2770_priv *tas2770 =
-			snd_soc_component_get_drvdata(component);
+	struct snd_soc_component *component = tas2770->component;
+	unsigned int val;
+	int ret;
 
-	switch (level) {
-	case SND_SOC_BIAS_ON:
-		snd_soc_component_update_bits(component, TAS2770_PWR_CTRL,
-					      TAS2770_PWR_CTRL_MASK,
-					      TAS2770_PWR_CTRL_ACTIVE);
-		break;
-	case SND_SOC_BIAS_STANDBY:
-	case SND_SOC_BIAS_PREPARE:
-		snd_soc_component_update_bits(component, TAS2770_PWR_CTRL,
-					      TAS2770_PWR_CTRL_MASK,
-					      TAS2770_PWR_CTRL_MUTE);
-		break;
-	case SND_SOC_BIAS_OFF:
-		snd_soc_component_update_bits(component, TAS2770_PWR_CTRL,
-					      TAS2770_PWR_CTRL_MASK,
-					      TAS2770_PWR_CTRL_SHUTDOWN);
-		break;
+	if (tas2770->dac_powered)
+		val = tas2770->unmuted ?
+			TAS2770_PWR_CTRL_ACTIVE : TAS2770_PWR_CTRL_MUTE;
+	else
+		val = TAS2770_PWR_CTRL_SHUTDOWN;
 
-	default:
-		dev_err(tas2770->dev, "wrong power level setting %d\n", level);
-		return -EINVAL;
-	}
+	ret = snd_soc_component_update_bits(component, TAS2770_PWR_CTRL,
+					    TAS2770_PWR_CTRL_MASK, val);
+	if (ret < 0)
+		return ret;
 
 	return 0;
 }
@@ -114,9 +102,7 @@ static int tas2770_codec_resume(struct snd_soc_component *component)
 		gpiod_set_value_cansleep(tas2770->sdz_gpio, 1);
 		usleep_range(1000, 2000);
 	} else {
-		ret = snd_soc_component_update_bits(component, TAS2770_PWR_CTRL,
-						    TAS2770_PWR_CTRL_MASK,
-						    TAS2770_PWR_CTRL_ACTIVE);
+		ret = tas2770_update_pwr_ctrl(tas2770);
 		if (ret < 0)
 			return ret;
 	}
@@ -152,24 +138,19 @@ static int tas2770_dac_event(struct snd_soc_dapm_widget *w,
 
 	switch (event) {
 	case SND_SOC_DAPM_POST_PMU:
-		ret = snd_soc_component_update_bits(component, TAS2770_PWR_CTRL,
-						    TAS2770_PWR_CTRL_MASK,
-						    TAS2770_PWR_CTRL_MUTE);
+		tas2770->dac_powered = 1;
+		ret = tas2770_update_pwr_ctrl(tas2770);
 		break;
 	case SND_SOC_DAPM_PRE_PMD:
-		ret = snd_soc_component_update_bits(component, TAS2770_PWR_CTRL,
-						    TAS2770_PWR_CTRL_MASK,
-						    TAS2770_PWR_CTRL_SHUTDOWN);
+		tas2770->dac_powered = 0;
+		ret = tas2770_update_pwr_ctrl(tas2770);
 		break;
 	default:
 		dev_err(tas2770->dev, "Not supported evevt\n");
 		return -EINVAL;
 	}
 
-	if (ret < 0)
-		return ret;
-
-	return 0;
+	return ret;
 }
 
 static const struct snd_kcontrol_new isense_switch =
@@ -203,21 +184,11 @@ static const struct snd_soc_dapm_route tas2770_audio_map[] = {
 static int tas2770_mute(struct snd_soc_dai *dai, int mute, int direction)
 {
 	struct snd_soc_component *component = dai->component;
-	int ret;
-
-	if (mute)
-		ret = snd_soc_component_update_bits(component, TAS2770_PWR_CTRL,
-						    TAS2770_PWR_CTRL_MASK,
-						    TAS2770_PWR_CTRL_MUTE);
-	else
-		ret = snd_soc_component_update_bits(component, TAS2770_PWR_CTRL,
-						    TAS2770_PWR_CTRL_MASK,
-						    TAS2770_PWR_CTRL_ACTIVE);
-
-	if (ret < 0)
-		return ret;
+	struct tas2770_priv *tas2770 =
+			snd_soc_component_get_drvdata(component);
 
-	return 0;
+	tas2770->unmuted = !mute;
+	return tas2770_update_pwr_ctrl(tas2770);
 }
 
 static int tas2770_set_bitwidth(struct tas2770_priv *tas2770, int bitwidth)
@@ -337,7 +308,7 @@ static int tas2770_set_fmt(struct snd_soc_dai *dai, unsigned int fmt)
 	struct snd_soc_component *component = dai->component;
 	struct tas2770_priv *tas2770 =
 			snd_soc_component_get_drvdata(component);
-	u8 tdm_rx_start_slot = 0, asi_cfg_1 = 0;
+	u8 tdm_rx_start_slot = 0, invert_fpol = 0, fpol_preinv = 0, asi_cfg_1 = 0;
 	int ret;
 
 	switch (fmt & SND_SOC_DAIFMT_MASTER_MASK) {
@@ -349,9 +320,15 @@ static int tas2770_set_fmt(struct snd_soc_dai *dai, unsigned int fmt)
 	}
 
 	switch (fmt & SND_SOC_DAIFMT_INV_MASK) {
+	case SND_SOC_DAIFMT_NB_IF:
+		invert_fpol = 1;
+		fallthrough;
 	case SND_SOC_DAIFMT_NB_NF:
 		asi_cfg_1 |= TAS2770_TDM_CFG_REG1_RX_RSING;
 		break;
+	case SND_SOC_DAIFMT_IB_IF:
+		invert_fpol = 1;
+		fallthrough;
 	case SND_SOC_DAIFMT_IB_NF:
 		asi_cfg_1 |= TAS2770_TDM_CFG_REG1_RX_FALING;
 		break;
@@ -369,15 +346,19 @@ static int tas2770_set_fmt(struct snd_soc_dai *dai, unsigned int fmt)
 	switch (fmt & SND_SOC_DAIFMT_FORMAT_MASK) {
 	case SND_SOC_DAIFMT_I2S:
 		tdm_rx_start_slot = 1;
+		fpol_preinv = 0;
 		break;
 	case SND_SOC_DAIFMT_DSP_A:
 		tdm_rx_start_slot = 0;
+		fpol_preinv = 1;
 		break;
 	case SND_SOC_DAIFMT_DSP_B:
 		tdm_rx_start_slot = 1;
+		fpol_preinv = 1;
 		break;
 	case SND_SOC_DAIFMT_LEFT_J:
 		tdm_rx_start_slot = 0;
+		fpol_preinv = 1;
 		break;
 	default:
 		dev_err(tas2770->dev,
@@ -391,6 +372,14 @@ static int tas2770_set_fmt(struct snd_soc_dai *dai, unsigned int fmt)
 	if (ret < 0)
 		return ret;
 
+	ret = snd_soc_component_update_bits(component, TAS2770_TDM_CFG_REG0,
+					    TAS2770_TDM_CFG_REG0_FPOL_MASK,
+					    (fpol_preinv ^ invert_fpol)
+					     ? TAS2770_TDM_CFG_REG0_FPOL_RSING
+					     : TAS2770_TDM_CFG_REG0_FPOL_FALING);
+	if (ret < 0)
+		return ret;
+
 	return 0;
 }
 
@@ -489,7 +478,7 @@ static struct snd_soc_dai_driver tas2770_dai_driver[] = {
 		.id = 0,
 		.playback = {
 			.stream_name    = "ASI1 Playback",
-			.channels_min   = 2,
+			.channels_min   = 1,
 			.channels_max   = 2,
 			.rates      = TAS2770_RATES,
 			.formats    = TAS2770_FORMATS,
@@ -537,7 +526,6 @@ static const struct snd_soc_component_driver soc_component_driver_tas2770 = {
 	.probe			= tas2770_codec_probe,
 	.suspend		= tas2770_codec_suspend,
 	.resume			= tas2770_codec_resume,
-	.set_bias_level = tas2770_set_bias_level,
 	.controls		= tas2770_snd_controls,
 	.num_controls		= ARRAY_SIZE(tas2770_snd_controls),
 	.dapm_widgets		= tas2770_dapm_widgets,
diff --git a/sound/soc/codecs/tas2770.h b/sound/soc/codecs/tas2770.h
index d156666bcc55..f75f40781ab1 100644
--- a/sound/soc/codecs/tas2770.h
+++ b/sound/soc/codecs/tas2770.h
@@ -41,6 +41,9 @@
 #define TAS2770_TDM_CFG_REG0_31_44_1_48KHZ  0x6
 #define TAS2770_TDM_CFG_REG0_31_88_2_96KHZ  0x8
 #define TAS2770_TDM_CFG_REG0_31_176_4_192KHZ  0xa
+#define TAS2770_TDM_CFG_REG0_FPOL_MASK  BIT(0)
+#define TAS2770_TDM_CFG_REG0_FPOL_RSING  0
+#define TAS2770_TDM_CFG_REG0_FPOL_FALING  1
     /* TDM Configuration Reg1 */
 #define TAS2770_TDM_CFG_REG1  TAS2770_REG(0X0, 0x0B)
 #define TAS2770_TDM_CFG_REG1_MASK	GENMASK(5, 1)
@@ -135,6 +138,8 @@ struct tas2770_priv {
 	struct device *dev;
 	int v_sense_slot;
 	int i_sense_slot;
+	bool dac_powered;
+	bool unmuted;
 };
 
 #endif /* __TAS2770__ */
diff --git a/sound/soc/codecs/tlv320aic32x4.c b/sound/soc/codecs/tlv320aic32x4.c
index d39c7d52ecfd..9f4a629b032b 100644
--- a/sound/soc/codecs/tlv320aic32x4.c
+++ b/sound/soc/codecs/tlv320aic32x4.c
@@ -49,6 +49,8 @@ struct aic32x4_priv {
 	struct aic32x4_setup_data *setup;
 	struct device *dev;
 	enum aic32x4_type type;
+
+	unsigned int fmt;
 };
 
 static int aic32x4_reset_adc(struct snd_soc_dapm_widget *w,
@@ -611,6 +613,7 @@ static int aic32x4_set_dai_sysclk(struct snd_soc_dai *codec_dai,
 static int aic32x4_set_dai_fmt(struct snd_soc_dai *codec_dai, unsigned int fmt)
 {
 	struct snd_soc_component *component = codec_dai->component;
+	struct aic32x4_priv *aic32x4 = snd_soc_component_get_drvdata(component);
 	u8 iface_reg_1 = 0;
 	u8 iface_reg_2 = 0;
 	u8 iface_reg_3 = 0;
@@ -654,6 +657,8 @@ static int aic32x4_set_dai_fmt(struct snd_soc_dai *codec_dai, unsigned int fmt)
 		return -EINVAL;
 	}
 
+	aic32x4->fmt = fmt;
+
 	snd_soc_component_update_bits(component, AIC32X4_IFACE1,
 				AIC32X4_IFACE1_DATATYPE_MASK |
 				AIC32X4_IFACE1_MASTER_MASK, iface_reg_1);
@@ -758,6 +763,10 @@ static int aic32x4_setup_clocks(struct snd_soc_component *component,
 		return -EINVAL;
 	}
 
+	/* PCM over I2S is always 2-channel */
+	if ((aic32x4->fmt & SND_SOC_DAIFMT_FORMAT_MASK) == SND_SOC_DAIFMT_I2S)
+		channels = 2;
+
 	madc = DIV_ROUND_UP((32 * adc_resource_class), aosr);
 	max_dosr = (AIC32X4_MAX_DOSR_FREQ / sample_rate / dosr_increment) *
 			dosr_increment;
diff --git a/sound/soc/sh/rcar/ssiu.c b/sound/soc/sh/rcar/ssiu.c
index 4b8a63e336c7..d7f4646ee029 100644
--- a/sound/soc/sh/rcar/ssiu.c
+++ b/sound/soc/sh/rcar/ssiu.c
@@ -67,6 +67,8 @@ static void rsnd_ssiu_busif_err_irq_ctrl(struct rsnd_mod *mod, int enable)
 		shift  = 1;
 		offset = 1;
 		break;
+	default:
+		return;
 	}
 
 	for (i = 0; i < 4; i++) {
diff --git a/sound/soc/sof/debug.c b/sound/soc/sof/debug.c
index a51a928ea40a..5f780ef9581a 100644
--- a/sound/soc/sof/debug.c
+++ b/sound/soc/sof/debug.c
@@ -668,9 +668,9 @@ static int memory_info_update(struct snd_sof_dev *sdev, char *buf, size_t buff_s
 	}
 
 	for (i = 0, len = 0; i < reply->num_elems; i++) {
-		ret = snprintf(buf + len, buff_size - len, "zone %d.%d used %#8x free %#8x\n",
-			       reply->elems[i].zone, reply->elems[i].id,
-			       reply->elems[i].used, reply->elems[i].free);
+		ret = scnprintf(buf + len, buff_size - len, "zone %d.%d used %#8x free %#8x\n",
+				reply->elems[i].zone, reply->elems[i].id,
+				reply->elems[i].used, reply->elems[i].free);
 		if (ret < 0)
 			goto error;
 		len += ret;
diff --git a/sound/soc/sof/intel/apl.c b/sound/soc/sof/intel/apl.c
index c7ed2b3d6abc..0a42034c4655 100644
--- a/sound/soc/sof/intel/apl.c
+++ b/sound/soc/sof/intel/apl.c
@@ -139,6 +139,7 @@ const struct sof_intel_dsp_desc apl_chip_info = {
 	.ipc_ack = HDA_DSP_REG_HIPCIE,
 	.ipc_ack_mask = HDA_DSP_REG_HIPCIE_DONE,
 	.ipc_ctl = HDA_DSP_REG_HIPCCTL,
+	.rom_status_reg = HDA_DSP_SRAM_REG_ROM_STATUS,
 	.rom_init_timeout	= 150,
 	.ssp_count = APL_SSP_COUNT,
 	.ssp_base_offset = APL_SSP_BASE_OFFSET,
diff --git a/sound/soc/sof/intel/cnl.c b/sound/soc/sof/intel/cnl.c
index e115e12a856f..a63b235763ed 100644
--- a/sound/soc/sof/intel/cnl.c
+++ b/sound/soc/sof/intel/cnl.c
@@ -344,6 +344,7 @@ const struct sof_intel_dsp_desc cnl_chip_info = {
 	.ipc_ack = CNL_DSP_REG_HIPCIDA,
 	.ipc_ack_mask = CNL_DSP_REG_HIPCIDA_DONE,
 	.ipc_ctl = CNL_DSP_REG_HIPCCTL,
+	.rom_status_reg = HDA_DSP_SRAM_REG_ROM_STATUS,
 	.rom_init_timeout	= 300,
 	.ssp_count = CNL_SSP_COUNT,
 	.ssp_base_offset = CNL_SSP_BASE_OFFSET,
@@ -363,6 +364,7 @@ const struct sof_intel_dsp_desc jsl_chip_info = {
 	.ipc_ack = CNL_DSP_REG_HIPCIDA,
 	.ipc_ack_mask = CNL_DSP_REG_HIPCIDA_DONE,
 	.ipc_ctl = CNL_DSP_REG_HIPCCTL,
+	.rom_status_reg = HDA_DSP_SRAM_REG_ROM_STATUS,
 	.rom_init_timeout	= 300,
 	.ssp_count = ICL_SSP_COUNT,
 	.ssp_base_offset = CNL_SSP_BASE_OFFSET,
diff --git a/sound/soc/sof/intel/hda-loader.c b/sound/soc/sof/intel/hda-loader.c
index ee09393d42cb..439cb33d2a71 100644
--- a/sound/soc/sof/intel/hda-loader.c
+++ b/sound/soc/sof/intel/hda-loader.c
@@ -163,7 +163,7 @@ static int cl_dsp_init(struct snd_sof_dev *sdev, int stream_tag)
 
 	/* step 7: wait for ROM init */
 	ret = snd_sof_dsp_read_poll_timeout(sdev, HDA_DSP_BAR,
-					HDA_DSP_SRAM_REG_ROM_STATUS, status,
+					chip->rom_status_reg, status,
 					((status & HDA_DSP_ROM_STS_MASK)
 						== HDA_DSP_ROM_INIT),
 					HDA_DSP_REG_POLL_INTERVAL_US,
@@ -174,8 +174,8 @@ static int cl_dsp_init(struct snd_sof_dev *sdev, int stream_tag)
 
 	if (hda->boot_iteration == HDA_FW_BOOT_ATTEMPTS)
 		dev_err(sdev->dev,
-			"error: %s: timeout HDA_DSP_SRAM_REG_ROM_STATUS read\n",
-			__func__);
+			"%s: timeout with rom_status_reg (%#x) read\n",
+			__func__, chip->rom_status_reg);
 
 err:
 	flags = SOF_DBG_DUMP_REGS | SOF_DBG_DUMP_PCI | SOF_DBG_DUMP_MBOX;
@@ -251,6 +251,8 @@ static int cl_cleanup(struct snd_sof_dev *sdev, struct snd_dma_buffer *dmab,
 
 static int cl_copy_fw(struct snd_sof_dev *sdev, struct hdac_ext_stream *stream)
 {
+	struct sof_intel_hda_dev *hda = sdev->pdata->hw_pdata;
+	const struct sof_intel_dsp_desc *chip = hda->desc;
 	unsigned int reg;
 	int ret, status;
 
@@ -261,7 +263,7 @@ static int cl_copy_fw(struct snd_sof_dev *sdev, struct hdac_ext_stream *stream)
 	}
 
 	status = snd_sof_dsp_read_poll_timeout(sdev, HDA_DSP_BAR,
-					HDA_DSP_SRAM_REG_ROM_STATUS, reg,
+					chip->rom_status_reg, reg,
 					((reg & HDA_DSP_ROM_STS_MASK)
 						== HDA_DSP_ROM_FW_ENTERED),
 					HDA_DSP_REG_POLL_INTERVAL_US,
@@ -274,8 +276,8 @@ static int cl_copy_fw(struct snd_sof_dev *sdev, struct hdac_ext_stream *stream)
 
 	if (status < 0) {
 		dev_err(sdev->dev,
-			"error: %s: timeout HDA_DSP_SRAM_REG_ROM_STATUS read\n",
-			__func__);
+			"%s: timeout with rom_status_reg (%#x) read\n",
+			__func__, chip->rom_status_reg);
 	}
 
 	ret = cl_trigger(sdev, stream, SNDRV_PCM_TRIGGER_STOP);
diff --git a/sound/soc/sof/intel/hda.c b/sound/soc/sof/intel/hda.c
index ddf70902e53c..35cbef171f4a 100644
--- a/sound/soc/sof/intel/hda.c
+++ b/sound/soc/sof/intel/hda.c
@@ -353,11 +353,13 @@ static const struct hda_dsp_msg_code hda_dsp_rom_msg[] = {
 
 static void hda_dsp_get_status(struct snd_sof_dev *sdev)
 {
+	const struct sof_intel_dsp_desc *chip;
 	u32 status;
 	int i;
 
+	chip = get_chip_info(sdev->pdata);
 	status = snd_sof_dsp_read(sdev, HDA_DSP_BAR,
-				  HDA_DSP_SRAM_REG_ROM_STATUS);
+				  chip->rom_status_reg);
 
 	for (i = 0; i < ARRAY_SIZE(hda_dsp_rom_msg); i++) {
 		if (status == hda_dsp_rom_msg[i].code) {
@@ -402,14 +404,16 @@ static void hda_dsp_get_registers(struct snd_sof_dev *sdev,
 /* dump the first 8 dwords representing the extended ROM status */
 static void hda_dsp_dump_ext_rom_status(struct snd_sof_dev *sdev, u32 flags)
 {
+	const struct sof_intel_dsp_desc *chip;
 	char msg[128];
 	int len = 0;
 	u32 value;
 	int i;
 
+	chip = get_chip_info(sdev->pdata);
 	for (i = 0; i < HDA_EXT_ROM_STATUS_SIZE; i++) {
-		value = snd_sof_dsp_read(sdev, HDA_DSP_BAR, HDA_DSP_SRAM_REG_ROM_STATUS + i * 0x4);
-		len += snprintf(msg + len, sizeof(msg) - len, " 0x%x", value);
+		value = snd_sof_dsp_read(sdev, HDA_DSP_BAR, chip->rom_status_reg + i * 0x4);
+		len += scnprintf(msg + len, sizeof(msg) - len, " 0x%x", value);
 	}
 
 	sof_dev_dbg_or_err(sdev->dev, flags & SOF_DBG_DUMP_FORCE_ERR_LEVEL,
diff --git a/sound/soc/sof/intel/icl.c b/sound/soc/sof/intel/icl.c
index ee095b8f2d01..4065c4d3912a 100644
--- a/sound/soc/sof/intel/icl.c
+++ b/sound/soc/sof/intel/icl.c
@@ -139,6 +139,7 @@ const struct sof_intel_dsp_desc icl_chip_info = {
 	.ipc_ack = CNL_DSP_REG_HIPCIDA,
 	.ipc_ack_mask = CNL_DSP_REG_HIPCIDA_DONE,
 	.ipc_ctl = CNL_DSP_REG_HIPCCTL,
+	.rom_status_reg = HDA_DSP_SRAM_REG_ROM_STATUS,
 	.rom_init_timeout	= 300,
 	.ssp_count = ICL_SSP_COUNT,
 	.ssp_base_offset = CNL_SSP_BASE_OFFSET,
diff --git a/sound/soc/sof/intel/shim.h b/sound/soc/sof/intel/shim.h
index e9f7d4d7fcce..96707758ebc5 100644
--- a/sound/soc/sof/intel/shim.h
+++ b/sound/soc/sof/intel/shim.h
@@ -161,6 +161,7 @@ struct sof_intel_dsp_desc {
 	int ipc_ack;
 	int ipc_ack_mask;
 	int ipc_ctl;
+	int rom_status_reg;
 	int rom_init_timeout;
 	int ssp_count;			/* ssp count of the platform */
 	int ssp_base_offset;		/* base address of the SSPs */
diff --git a/sound/soc/sof/intel/tgl.c b/sound/soc/sof/intel/tgl.c
index 199d41a7dc9b..aba52d8628aa 100644
--- a/sound/soc/sof/intel/tgl.c
+++ b/sound/soc/sof/intel/tgl.c
@@ -134,6 +134,7 @@ const struct sof_intel_dsp_desc tgl_chip_info = {
 	.ipc_ack = CNL_DSP_REG_HIPCIDA,
 	.ipc_ack_mask = CNL_DSP_REG_HIPCIDA_DONE,
 	.ipc_ctl = CNL_DSP_REG_HIPCCTL,
+	.rom_status_reg = HDA_DSP_SRAM_REG_ROM_STATUS,
 	.rom_init_timeout	= 300,
 	.ssp_count = ICL_SSP_COUNT,
 	.ssp_base_offset = CNL_SSP_BASE_OFFSET,
@@ -153,6 +154,7 @@ const struct sof_intel_dsp_desc tglh_chip_info = {
 	.ipc_ack = CNL_DSP_REG_HIPCIDA,
 	.ipc_ack_mask = CNL_DSP_REG_HIPCIDA_DONE,
 	.ipc_ctl = CNL_DSP_REG_HIPCCTL,
+	.rom_status_reg = HDA_DSP_SRAM_REG_ROM_STATUS,
 	.rom_init_timeout	= 300,
 	.ssp_count = ICL_SSP_COUNT,
 	.ssp_base_offset = CNL_SSP_BASE_OFFSET,
@@ -172,6 +174,7 @@ const struct sof_intel_dsp_desc ehl_chip_info = {
 	.ipc_ack = CNL_DSP_REG_HIPCIDA,
 	.ipc_ack_mask = CNL_DSP_REG_HIPCIDA_DONE,
 	.ipc_ctl = CNL_DSP_REG_HIPCCTL,
+	.rom_status_reg = HDA_DSP_SRAM_REG_ROM_STATUS,
 	.rom_init_timeout	= 300,
 	.ssp_count = ICL_SSP_COUNT,
 	.ssp_base_offset = CNL_SSP_BASE_OFFSET,
@@ -191,6 +194,7 @@ const struct sof_intel_dsp_desc adls_chip_info = {
 	.ipc_ack = CNL_DSP_REG_HIPCIDA,
 	.ipc_ack_mask = CNL_DSP_REG_HIPCIDA_DONE,
 	.ipc_ctl = CNL_DSP_REG_HIPCCTL,
+	.rom_status_reg = HDA_DSP_SRAM_REG_ROM_STATUS,
 	.rom_init_timeout	= 300,
 	.ssp_count = ICL_SSP_COUNT,
 	.ssp_base_offset = CNL_SSP_BASE_OFFSET,
diff --git a/sound/usb/card.c b/sound/usb/card.c
index 1764b9302d46..ff5f8de1bc54 100644
--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -387,6 +387,14 @@ static const struct usb_audio_device_name usb_audio_names[] = {
 	DEVICE_NAME(0x05e1, 0x0408, "Syntek", "STK1160"),
 	DEVICE_NAME(0x05e1, 0x0480, "Hauppauge", "Woodbury"),
 
+	/* ASUS ROG Zenith II: this machine has also two devices, one for
+	 * the front headphone and another for the rest
+	 */
+	PROFILE_NAME(0x0b05, 0x1915, "ASUS", "Zenith II Front Headphone",
+		     "Zenith-II-Front-Headphone"),
+	PROFILE_NAME(0x0b05, 0x1916, "ASUS", "Zenith II Main Audio",
+		     "Zenith-II-Main-Audio"),
+
 	/* ASUS ROG Strix */
 	PROFILE_NAME(0x0b05, 0x1917,
 		     "Realtek", "ALC1220-VB-DT", "Realtek-ALC1220-VB-Desktop"),
diff --git a/sound/usb/mixer_maps.c b/sound/usb/mixer_maps.c
index 997425ef0a29..3f8f6056ff6a 100644
--- a/sound/usb/mixer_maps.c
+++ b/sound/usb/mixer_maps.c
@@ -366,13 +366,28 @@ static const struct usbmix_name_map corsair_virtuoso_map[] = {
 	{ 0 }
 };
 
-/* Some mobos shipped with a dummy HD-audio show the invalid GET_MIN/GET_MAX
- * response for Input Gain Pad (id=19, control=12) and the connector status
- * for SPDIF terminal (id=18).  Skip them.
- */
-static const struct usbmix_name_map asus_rog_map[] = {
-	{ 18, NULL }, /* OT, connector control */
-	{ 19, NULL, 12 }, /* FU, Input Gain Pad */
+/* ASUS ROG Zenith II with Realtek ALC1220-VB */
+static const struct usbmix_name_map asus_zenith_ii_map[] = {
+	{ 19, NULL, 12 }, /* FU, Input Gain Pad - broken response, disabled */
+	{ 16, "Speaker" },		/* OT */
+	{ 22, "Speaker Playback" },	/* FU */
+	{ 7, "Line" },			/* IT */
+	{ 19, "Line Capture" },		/* FU */
+	{ 8, "Mic" },			/* IT */
+	{ 20, "Mic Capture" },		/* FU */
+	{ 9, "Front Mic" },		/* IT */
+	{ 21, "Front Mic Capture" },	/* FU */
+	{ 17, "IEC958" },		/* OT */
+	{ 23, "IEC958 Playback" },	/* FU */
+	{}
+};
+
+static const struct usbmix_connector_map asus_zenith_ii_connector_map[] = {
+	{ 10, 16 },	/* (Back) Speaker */
+	{ 11, 17 },	/* SPDIF */
+	{ 13, 7 },	/* Line */
+	{ 14, 8 },	/* Mic */
+	{ 15, 9 },	/* Front Mic */
 	{}
 };
 
@@ -568,9 +583,10 @@ static const struct usbmix_ctl_map usbmix_ctl_maps[] = {
 		.map = trx40_mobo_map,
 		.connector_map = trx40_mobo_connector_map,
 	},
-	{	/* ASUS ROG Zenith II */
+	{	/* ASUS ROG Zenith II (main audio) */
 		.id = USB_ID(0x0b05, 0x1916),
-		.map = asus_rog_map,
+		.map = asus_zenith_ii_map,
+		.connector_map = asus_zenith_ii_connector_map,
 	},
 	{	/* ASUS ROG Strix */
 		.id = USB_ID(0x0b05, 0x1917),
diff --git a/tools/build/feature/test-libcrypto.c b/tools/build/feature/test-libcrypto.c
index a98174e0569c..bc34a5bbb504 100644
--- a/tools/build/feature/test-libcrypto.c
+++ b/tools/build/feature/test-libcrypto.c
@@ -1,16 +1,23 @@
 // SPDX-License-Identifier: GPL-2.0
+#include <openssl/evp.h>
 #include <openssl/sha.h>
 #include <openssl/md5.h>
 
 int main(void)
 {
-	MD5_CTX context;
+	EVP_MD_CTX *mdctx;
 	unsigned char md[MD5_DIGEST_LENGTH + SHA_DIGEST_LENGTH];
 	unsigned char dat[] = "12345";
+	unsigned int digest_len;
 
-	MD5_Init(&context);
-	MD5_Update(&context, &dat[0], sizeof(dat));
-	MD5_Final(&md[0], &context);
+	mdctx = EVP_MD_CTX_new();
+	if (!mdctx)
+		return 0;
+
+	EVP_DigestInit_ex(mdctx, EVP_md5(), NULL);
+	EVP_DigestUpdate(mdctx, &dat[0], sizeof(dat));
+	EVP_DigestFinal_ex(mdctx, &md[0], &digest_len);
+	EVP_MD_CTX_free(mdctx);
 
 	SHA1(&dat[0], sizeof(dat), &md[0]);
 
diff --git a/tools/perf/tests/switch-tracking.c b/tools/perf/tests/switch-tracking.c
index 62c0ec21aaa8..72abf5d86f71 100644
--- a/tools/perf/tests/switch-tracking.c
+++ b/tools/perf/tests/switch-tracking.c
@@ -324,6 +324,7 @@ static int process_events(struct evlist *evlist,
 int test__switch_tracking(struct test *test __maybe_unused, int subtest __maybe_unused)
 {
 	const char *sched_switch = "sched:sched_switch";
+	const char *cycles = "cycles:u";
 	struct switch_tracking switch_tracking = { .tids = NULL, };
 	struct record_opts opts = {
 		.mmap_pages	     = UINT_MAX,
@@ -372,12 +373,19 @@ int test__switch_tracking(struct test *test __maybe_unused, int subtest __maybe_
 	cpu_clocks_evsel = evlist__last(evlist);
 
 	/* Second event */
-	if (perf_pmu__has_hybrid())
-		err = parse_events(evlist, "cpu_core/cycles/u", NULL);
-	else
-		err = parse_events(evlist, "cycles:u", NULL);
+	if (perf_pmu__has_hybrid()) {
+		cycles = "cpu_core/cycles/u";
+		err = parse_events(evlist, cycles, NULL);
+		if (err) {
+			cycles = "cpu_atom/cycles/u";
+			pr_debug("Trying %s\n", cycles);
+			err = parse_events(evlist, cycles, NULL);
+		}
+	} else {
+		err = parse_events(evlist, cycles, NULL);
+	}
 	if (err) {
-		pr_debug("Failed to parse event cycles:u\n");
+		pr_debug("Failed to parse event %s\n", cycles);
 		goto out_err;
 	}
 
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 3bfe099d8643..b93a36ffeb9e 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -196,9 +196,12 @@ static int tp_event_has_id(const char *dir_path, struct dirent *evt_dir)
 void parse_events__handle_error(struct parse_events_error *err, int idx,
 				char *str, char *help)
 {
-	if (WARN(!str, "WARNING: failed to provide error string\n")) {
-		free(help);
-		return;
+	if (WARN(!str, "WARNING: failed to provide error string\n"))
+		goto out_free;
+	if (!err) {
+		/* Assume caller does not want message printed */
+		pr_debug("event syntax error: %s\n", str);
+		goto out_free;
 	}
 	switch (err->num_errors) {
 	case 0:
@@ -224,6 +227,11 @@ void parse_events__handle_error(struct parse_events_error *err, int idx,
 		break;
 	}
 	err->num_errors++;
+	return;
+
+out_free:
+	free(str);
+	free(help);
 }
 
 struct tracepoint_path *tracepoint_id_to_path(u64 config)
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index a834918a0a0d..68844c48f688 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -1775,8 +1775,10 @@ int parse_perf_probe_command(const char *cmd, struct perf_probe_event *pev)
 	if (!pev->event && pev->point.function && pev->point.line
 			&& !pev->point.lazy_line && !pev->point.offset) {
 		if (asprintf(&pev->event, "%s_L%d", pev->point.function,
-			pev->point.line) < 0)
-			return -ENOMEM;
+			pev->point.line) < 0) {
+			ret = -ENOMEM;
+			goto out;
+		}
 	}
 
 	/* Copy arguments and ensure return probe has no C argument */
diff --git a/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_syntax_errors.tc b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_syntax_errors.tc
index fa928b431555..7c02509c71d0 100644
--- a/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_syntax_errors.tc
+++ b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_syntax_errors.tc
@@ -21,7 +21,6 @@ check_error 'p:^/bar vfs_read'		# NO_GROUP_NAME
 check_error 'p:^12345678901234567890123456789012345678901234567890123456789012345/bar vfs_read'	# GROUP_TOO_LONG
 
 check_error 'p:^foo.1/bar vfs_read'	# BAD_GROUP_NAME
-check_error 'p:foo/^ vfs_read'		# NO_EVENT_NAME
 check_error 'p:foo/^12345678901234567890123456789012345678901234567890123456789012345 vfs_read'	# EVENT_TOO_LONG
 check_error 'p:foo/^bar.1 vfs_read'	# BAD_EVENT_NAME
 
diff --git a/tools/testing/selftests/net/forwarding/custom_multipath_hash.sh b/tools/testing/selftests/net/forwarding/custom_multipath_hash.sh
index a15d21dc035a..56eb83d1a3bd 100755
--- a/tools/testing/selftests/net/forwarding/custom_multipath_hash.sh
+++ b/tools/testing/selftests/net/forwarding/custom_multipath_hash.sh
@@ -181,37 +181,43 @@ ping_ipv6()
 
 send_src_ipv4()
 {
-	$MZ $h1 -q -p 64 -A "198.51.100.2-198.51.100.253" -B 203.0.113.2 \
+	ip vrf exec v$h1 $MZ $h1 -q -p 64 \
+		-A "198.51.100.2-198.51.100.253" -B 203.0.113.2 \
 		-d 1msec -c 50 -t udp "sp=20000,dp=30000"
 }
 
 send_dst_ipv4()
 {
-	$MZ $h1 -q -p 64 -A 198.51.100.2 -B "203.0.113.2-203.0.113.253" \
+	ip vrf exec v$h1 $MZ $h1 -q -p 64 \
+		-A 198.51.100.2 -B "203.0.113.2-203.0.113.253" \
 		-d 1msec -c 50 -t udp "sp=20000,dp=30000"
 }
 
 send_src_udp4()
 {
-	$MZ $h1 -q -p 64 -A 198.51.100.2 -B 203.0.113.2 \
+	ip vrf exec v$h1 $MZ $h1 -q -p 64 \
+		-A 198.51.100.2 -B 203.0.113.2 \
 		-d 1msec -t udp "sp=0-32768,dp=30000"
 }
 
 send_dst_udp4()
 {
-	$MZ $h1 -q -p 64 -A 198.51.100.2 -B 203.0.113.2 \
+	ip vrf exec v$h1 $MZ $h1 -q -p 64 \
+		-A 198.51.100.2 -B 203.0.113.2 \
 		-d 1msec -t udp "sp=20000,dp=0-32768"
 }
 
 send_src_ipv6()
 {
-	$MZ -6 $h1 -q -p 64 -A "2001:db8:1::2-2001:db8:1::fd" -B 2001:db8:4::2 \
+	ip vrf exec v$h1 $MZ -6 $h1 -q -p 64 \
+		-A "2001:db8:1::2-2001:db8:1::fd" -B 2001:db8:4::2 \
 		-d 1msec -c 50 -t udp "sp=20000,dp=30000"
 }
 
 send_dst_ipv6()
 {
-	$MZ -6 $h1 -q -p 64 -A 2001:db8:1::2 -B "2001:db8:4::2-2001:db8:4::fd" \
+	ip vrf exec v$h1 $MZ -6 $h1 -q -p 64 \
+		-A 2001:db8:1::2 -B "2001:db8:4::2-2001:db8:4::fd" \
 		-d 1msec -c 50 -t udp "sp=20000,dp=30000"
 }
 
@@ -226,13 +232,15 @@ send_flowlabel()
 
 send_src_udp6()
 {
-	$MZ -6 $h1 -q -p 64 -A 2001:db8:1::2 -B 2001:db8:4::2 \
+	ip vrf exec v$h1 $MZ -6 $h1 -q -p 64 \
+		-A 2001:db8:1::2 -B 2001:db8:4::2 \
 		-d 1msec -t udp "sp=0-32768,dp=30000"
 }
 
 send_dst_udp6()
 {
-	$MZ -6 $h1 -q -p 64 -A 2001:db8:1::2 -B 2001:db8:4::2 \
+	ip vrf exec v$h1 $MZ -6 $h1 -q -p 64 \
+		-A 2001:db8:1::2 -B 2001:db8:4::2 \
 		-d 1msec -t udp "sp=20000,dp=0-32768"
 }
 
diff --git a/tools/testing/selftests/net/forwarding/gre_custom_multipath_hash.sh b/tools/testing/selftests/net/forwarding/gre_custom_multipath_hash.sh
index a73f52efcb6c..0446db9c6f74 100755
--- a/tools/testing/selftests/net/forwarding/gre_custom_multipath_hash.sh
+++ b/tools/testing/selftests/net/forwarding/gre_custom_multipath_hash.sh
@@ -276,37 +276,43 @@ ping_ipv6()
 
 send_src_ipv4()
 {
-	$MZ $h1 -q -p 64 -A "198.51.100.2-198.51.100.253" -B 203.0.113.2 \
+	ip vrf exec v$h1 $MZ $h1 -q -p 64 \
+		-A "198.51.100.2-198.51.100.253" -B 203.0.113.2 \
 		-d 1msec -c 50 -t udp "sp=20000,dp=30000"
 }
 
 send_dst_ipv4()
 {
-	$MZ $h1 -q -p 64 -A 198.51.100.2 -B "203.0.113.2-203.0.113.253" \
+	ip vrf exec v$h1 $MZ $h1 -q -p 64 \
+		-A 198.51.100.2 -B "203.0.113.2-203.0.113.253" \
 		-d 1msec -c 50 -t udp "sp=20000,dp=30000"
 }
 
 send_src_udp4()
 {
-	$MZ $h1 -q -p 64 -A 198.51.100.2 -B 203.0.113.2 \
+	ip vrf exec v$h1 $MZ $h1 -q -p 64 \
+		-A 198.51.100.2 -B 203.0.113.2 \
 		-d 1msec -t udp "sp=0-32768,dp=30000"
 }
 
 send_dst_udp4()
 {
-	$MZ $h1 -q -p 64 -A 198.51.100.2 -B 203.0.113.2 \
+	ip vrf exec v$h1 $MZ $h1 -q -p 64 \
+		-A 198.51.100.2 -B 203.0.113.2 \
 		-d 1msec -t udp "sp=20000,dp=0-32768"
 }
 
 send_src_ipv6()
 {
-	$MZ -6 $h1 -q -p 64 -A "2001:db8:1::2-2001:db8:1::fd" -B 2001:db8:2::2 \
+	ip vrf exec v$h1 $MZ -6 $h1 -q -p 64 \
+		-A "2001:db8:1::2-2001:db8:1::fd" -B 2001:db8:2::2 \
 		-d 1msec -c 50 -t udp "sp=20000,dp=30000"
 }
 
 send_dst_ipv6()
 {
-	$MZ -6 $h1 -q -p 64 -A 2001:db8:1::2 -B "2001:db8:2::2-2001:db8:2::fd" \
+	ip vrf exec v$h1 $MZ -6 $h1 -q -p 64 \
+		-A 2001:db8:1::2 -B "2001:db8:2::2-2001:db8:2::fd" \
 		-d 1msec -c 50 -t udp "sp=20000,dp=30000"
 }
 
@@ -321,13 +327,15 @@ send_flowlabel()
 
 send_src_udp6()
 {
-	$MZ -6 $h1 -q -p 64 -A 2001:db8:1::2 -B 2001:db8:2::2 \
+	ip vrf exec v$h1 $MZ -6 $h1 -q -p 64 \
+		-A 2001:db8:1::2 -B 2001:db8:2::2 \
 		-d 1msec -t udp "sp=0-32768,dp=30000"
 }
 
 send_dst_udp6()
 {
-	$MZ -6 $h1 -q -p 64 -A 2001:db8:1::2 -B 2001:db8:2::2 \
+	ip vrf exec v$h1 $MZ -6 $h1 -q -p 64 \
+		-A 2001:db8:1::2 -B 2001:db8:2::2 \
 		-d 1msec -t udp "sp=20000,dp=0-32768"
 }
 
diff --git a/tools/testing/selftests/net/forwarding/ip6gre_custom_multipath_hash.sh b/tools/testing/selftests/net/forwarding/ip6gre_custom_multipath_hash.sh
index 8fea2c2e0b25..d40183b4eccc 100755
--- a/tools/testing/selftests/net/forwarding/ip6gre_custom_multipath_hash.sh
+++ b/tools/testing/selftests/net/forwarding/ip6gre_custom_multipath_hash.sh
@@ -278,37 +278,43 @@ ping_ipv6()
 
 send_src_ipv4()
 {
-	$MZ $h1 -q -p 64 -A "198.51.100.2-198.51.100.253" -B 203.0.113.2 \
+	ip vrf exec v$h1 $MZ $h1 -q -p 64 \
+		-A "198.51.100.2-198.51.100.253" -B 203.0.113.2 \
 		-d 1msec -c 50 -t udp "sp=20000,dp=30000"
 }
 
 send_dst_ipv4()
 {
-	$MZ $h1 -q -p 64 -A 198.51.100.2 -B "203.0.113.2-203.0.113.253" \
+	ip vrf exec v$h1 $MZ $h1 -q -p 64 \
+		-A 198.51.100.2 -B "203.0.113.2-203.0.113.253" \
 		-d 1msec -c 50 -t udp "sp=20000,dp=30000"
 }
 
 send_src_udp4()
 {
-	$MZ $h1 -q -p 64 -A 198.51.100.2 -B 203.0.113.2 \
+	ip vrf exec v$h1 $MZ $h1 -q -p 64 \
+		-A 198.51.100.2 -B 203.0.113.2 \
 		-d 1msec -t udp "sp=0-32768,dp=30000"
 }
 
 send_dst_udp4()
 {
-	$MZ $h1 -q -p 64 -A 198.51.100.2 -B 203.0.113.2 \
+	ip vrf exec v$h1 $MZ $h1 -q -p 64 \
+		-A 198.51.100.2 -B 203.0.113.2 \
 		-d 1msec -t udp "sp=20000,dp=0-32768"
 }
 
 send_src_ipv6()
 {
-	$MZ -6 $h1 -q -p 64 -A "2001:db8:1::2-2001:db8:1::fd" -B 2001:db8:2::2 \
+	ip vrf exec v$h1 $MZ -6 $h1 -q -p 64 \
+		-A "2001:db8:1::2-2001:db8:1::fd" -B 2001:db8:2::2 \
 		-d 1msec -c 50 -t udp "sp=20000,dp=30000"
 }
 
 send_dst_ipv6()
 {
-	$MZ -6 $h1 -q -p 64 -A 2001:db8:1::2 -B "2001:db8:2::2-2001:db8:2::fd" \
+	ip vrf exec v$h1 $MZ -6 $h1 -q -p 64 \
+		-A 2001:db8:1::2 -B "2001:db8:2::2-2001:db8:2::fd" \
 		-d 1msec -c 50 -t udp "sp=20000,dp=30000"
 }
 
@@ -323,13 +329,15 @@ send_flowlabel()
 
 send_src_udp6()
 {
-	$MZ -6 $h1 -q -p 64 -A 2001:db8:1::2 -B 2001:db8:2::2 \
+	ip vrf exec v$h1 $MZ -6 $h1 -q -p 64 \
+		-A 2001:db8:1::2 -B 2001:db8:2::2 \
 		-d 1msec -t udp "sp=0-32768,dp=30000"
 }
 
 send_dst_udp6()
 {
-	$MZ -6 $h1 -q -p 64 -A 2001:db8:1::2 -B 2001:db8:2::2 \
+	ip vrf exec v$h1 $MZ -6 $h1 -q -p 64 \
+		-A 2001:db8:1::2 -B 2001:db8:2::2 \
 		-d 1msec -t udp "sp=20000,dp=0-32768"
 }
 
diff --git a/tools/vm/slabinfo.c b/tools/vm/slabinfo.c
index 5b98f3ee58a5..0fffaeedee76 100644
--- a/tools/vm/slabinfo.c
+++ b/tools/vm/slabinfo.c
@@ -125,7 +125,7 @@ static void usage(void)
 		"-n|--numa              Show NUMA information\n"
 		"-N|--lines=K           Show the first K slabs\n"
 		"-o|--ops               Show kmem_cache_ops\n"
-		"-P|--partial		Sort by number of partial slabs\n"
+		"-P|--partial           Sort by number of partial slabs\n"
 		"-r|--report            Detailed report on single slabs\n"
 		"-s|--shrink            Shrink slabs\n"
 		"-S|--Size              Sort by size\n"
@@ -1067,15 +1067,27 @@ static void sort_slabs(void)
 		for (s2 = s1 + 1; s2 < slabinfo + slabs; s2++) {
 			int result;
 
-			if (sort_size)
-				result = slab_size(s1) < slab_size(s2);
-			else if (sort_active)
-				result = slab_activity(s1) < slab_activity(s2);
-			else if (sort_loss)
-				result = slab_waste(s1) < slab_waste(s2);
-			else if (sort_partial)
-				result = s1->partial < s2->partial;
-			else
+			if (sort_size) {
+				if (slab_size(s1) == slab_size(s2))
+					result = strcasecmp(s1->name, s2->name);
+				else
+					result = slab_size(s1) < slab_size(s2);
+			} else if (sort_active) {
+				if (slab_activity(s1) == slab_activity(s2))
+					result = strcasecmp(s1->name, s2->name);
+				else
+					result = slab_activity(s1) < slab_activity(s2);
+			} else if (sort_loss) {
+				if (slab_waste(s1) == slab_waste(s2))
+					result = strcasecmp(s1->name, s2->name);
+				else
+					result = slab_waste(s1) < slab_waste(s2);
+			} else if (sort_partial) {
+				if (s1->partial == s2->partial)
+					result = strcasecmp(s1->name, s2->name);
+				else
+					result = s1->partial < s2->partial;
+			} else
 				result = strcasecmp(s1->name, s2->name);
 
 			if (show_inverted)
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 251b4143f505..86fc429a0e43 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1034,6 +1034,9 @@ static struct kvm *kvm_create_vm(unsigned long type)
 	if (!kvm)
 		return ERR_PTR(-ENOMEM);
 
+	/* KVM is pinned via open("/dev/kvm"), the fd passed to this ioctl(). */
+	__module_get(kvm_chardev_ops.owner);
+
 	KVM_MMU_LOCK_INIT(kvm);
 	mmgrab(current->mm);
 	kvm->mm = current->mm;
@@ -1107,16 +1110,6 @@ static struct kvm *kvm_create_vm(unsigned long type)
 	preempt_notifier_inc();
 	kvm_init_pm_notifier(kvm);
 
-	/*
-	 * When the fd passed to this ioctl() is opened it pins the module,
-	 * but try_module_get() also prevents getting a reference if the module
-	 * is in MODULE_STATE_GOING (e.g. if someone ran "rmmod --wait").
-	 */
-	if (!try_module_get(kvm_chardev_ops.owner)) {
-		r = -ENODEV;
-		goto out_err;
-	}
-
 	return kvm;
 
 out_err:
@@ -1140,6 +1133,7 @@ static struct kvm *kvm_create_vm(unsigned long type)
 out_err_no_srcu:
 	kvm_arch_free_vm(kvm);
 	mmdrop(current->mm);
+	module_put(kvm_chardev_ops.owner);
 	return ERR_PTR(r);
 }
 
