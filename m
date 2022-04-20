Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9A0650828B
	for <lists+stable@lfdr.de>; Wed, 20 Apr 2022 09:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235079AbiDTHtm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Apr 2022 03:49:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376361AbiDTHtf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Apr 2022 03:49:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC8C0340C5;
        Wed, 20 Apr 2022 00:46:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1C46618FA;
        Wed, 20 Apr 2022 07:46:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8321C385A1;
        Wed, 20 Apr 2022 07:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650440806;
        bh=SNVacqsHdt2sBlkhj8da222mFrJL5nhTh/baSqqqd8o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nPVCzvwpd4PCRmh+j+SYN+G26EE/kdqvSGlpeICBtFM4Gde5fzDIQxCG71ygug1qI
         VipYnAy1l4+V1CJ9CAwB59m88WtcsHWGB6T6tYgqs+A5wsUvXF/wtwCugMWqHVwDOD
         /QymvHx4quGirchazJjzd6h8c1EjO8bJTJZAUCYg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.15.35
Date:   Wed, 20 Apr 2022 09:46:37 +0200
Message-Id: <165044079634151@kroah.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <165044079665151@kroah.com>
References: <165044079665151@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Documentation/devicetree/bindings/net/qcom,ipa.yaml b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
index b8a0b392b24e..c52ec1ee7df6 100644
--- a/Documentation/devicetree/bindings/net/qcom,ipa.yaml
+++ b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
@@ -106,6 +106,10 @@ properties:
           - const: imem
           - const: config
 
+  qcom,qmp:
+    $ref: /schemas/types.yaml#/definitions/phandle
+    description: phandle to the AOSS side-channel message RAM
+
   qcom,smem-states:
     $ref: /schemas/types.yaml#/definitions/phandle-array
     description: State bits used in by the AP to signal the modem.
@@ -221,6 +225,8 @@ examples:
                                      "imem",
                                      "config";
 
+                qcom,qmp = <&aoss_qmp>;
+
                 qcom,smem-states = <&ipa_smp2p_out 0>,
                                    <&ipa_smp2p_out 1>;
                 qcom,smem-state-names = "ipa-clock-enabled-valid",
diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
index c115c95ee584..5b8db76b6cdd 100644
--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -53,20 +53,18 @@ properties:
         - allwinner,sun8i-r40-emac
         - allwinner,sun8i-v3s-emac
         - allwinner,sun50i-a64-emac
-        - loongson,ls2k-dwmac
-        - loongson,ls7a-dwmac
         - amlogic,meson6-dwmac
         - amlogic,meson8b-dwmac
         - amlogic,meson8m2-dwmac
         - amlogic,meson-gxbb-dwmac
         - amlogic,meson-axg-dwmac
-        - loongson,ls2k-dwmac
-        - loongson,ls7a-dwmac
         - ingenic,jz4775-mac
         - ingenic,x1000-mac
         - ingenic,x1600-mac
         - ingenic,x1830-mac
         - ingenic,x2000-mac
+        - loongson,ls2k-dwmac
+        - loongson,ls7a-dwmac
         - rockchip,px30-gmac
         - rockchip,rk3128-gmac
         - rockchip,rk3228-gmac
diff --git a/Makefile b/Makefile
index b6920025dfa3..e5440c513f5a 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 15
-SUBLEVEL = 34
+SUBLEVEL = 35
 EXTRAVERSION =
 NAME = Trick or Treat
 
diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
index 428012687a80..7f7f6bae21c2 100644
--- a/arch/arm/mach-davinci/board-da850-evm.c
+++ b/arch/arm/mach-davinci/board-da850-evm.c
@@ -1101,11 +1101,13 @@ static int __init da850_evm_config_emac(void)
 	int ret;
 	u32 val;
 	struct davinci_soc_info *soc_info = &davinci_soc_info;
-	u8 rmii_en = soc_info->emac_pdata->rmii_en;
+	u8 rmii_en;
 
 	if (!machine_is_davinci_da850_evm())
 		return 0;
 
+	rmii_en = soc_info->emac_pdata->rmii_en;
+
 	cfg_chip3_base = DA8XX_SYSCFG0_VIRT(DA8XX_CFGCHIP3_REG);
 
 	val = __raw_readl(cfg_chip3_base);
diff --git a/arch/arm64/kernel/alternative.c b/arch/arm64/kernel/alternative.c
index 3fb79b76e9d9..7bbf5104b7b7 100644
--- a/arch/arm64/kernel/alternative.c
+++ b/arch/arm64/kernel/alternative.c
@@ -42,7 +42,7 @@ bool alternative_is_applied(u16 cpufeature)
 /*
  * Check if the target PC is within an alternative block.
  */
-static bool branch_insn_requires_update(struct alt_instr *alt, unsigned long pc)
+static __always_inline bool branch_insn_requires_update(struct alt_instr *alt, unsigned long pc)
 {
 	unsigned long replptr = (unsigned long)ALT_REPL_PTR(alt);
 	return !(pc >= replptr && pc <= (replptr + alt->alt_len));
@@ -50,7 +50,7 @@ static bool branch_insn_requires_update(struct alt_instr *alt, unsigned long pc)
 
 #define align_down(x, a)	((unsigned long)(x) & ~(((unsigned long)(a)) - 1))
 
-static u32 get_alt_insn(struct alt_instr *alt, __le32 *insnptr, __le32 *altinsnptr)
+static __always_inline u32 get_alt_insn(struct alt_instr *alt, __le32 *insnptr, __le32 *altinsnptr)
 {
 	u32 insn;
 
@@ -95,7 +95,7 @@ static u32 get_alt_insn(struct alt_instr *alt, __le32 *insnptr, __le32 *altinsnp
 	return insn;
 }
 
-static void patch_alternative(struct alt_instr *alt,
+static noinstr void patch_alternative(struct alt_instr *alt,
 			      __le32 *origptr, __le32 *updptr, int nr_inst)
 {
 	__le32 *replptr;
diff --git a/arch/arm64/kernel/cpuidle.c b/arch/arm64/kernel/cpuidle.c
index 03991eeff643..3006f4324808 100644
--- a/arch/arm64/kernel/cpuidle.c
+++ b/arch/arm64/kernel/cpuidle.c
@@ -54,6 +54,9 @@ static int psci_acpi_cpu_init_idle(unsigned int cpu)
 	struct acpi_lpi_state *lpi;
 	struct acpi_processor *pr = per_cpu(processors, cpu);
 
+	if (unlikely(!pr || !pr->flags.has_lpi))
+		return -EINVAL;
+
 	/*
 	 * If the PSCI cpu_suspend function hook has not been initialized
 	 * idle states must not be enabled, so bail out
@@ -61,9 +64,6 @@ static int psci_acpi_cpu_init_idle(unsigned int cpu)
 	if (!psci_ops.cpu_suspend)
 		return -EOPNOTSUPP;
 
-	if (unlikely(!pr || !pr->flags.has_lpi))
-		return -EINVAL;
-
 	count = pr->power.count - 1;
 	if (count <= 0)
 		return -ENODEV;
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d9bb5cdb5db2..49d814b2a341 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1559,8 +1559,9 @@ static inline int kvm_arch_flush_remote_tlb(struct kvm *kvm)
 		return -ENOTSUPP;
 }
 
-int kvm_mmu_module_init(void);
-void kvm_mmu_module_exit(void);
+void kvm_mmu_x86_module_init(void);
+int kvm_mmu_vendor_module_init(void);
+void kvm_mmu_vendor_module_exit(void);
 
 void kvm_mmu_destroy(struct kvm_vcpu *vcpu);
 int kvm_mmu_create(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index a7c413432b33..66ae309840fe 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -128,9 +128,9 @@
 #define TSX_CTRL_RTM_DISABLE		BIT(0)	/* Disable RTM feature */
 #define TSX_CTRL_CPUID_CLEAR		BIT(1)	/* Disable TSX enumeration */
 
-/* SRBDS support */
 #define MSR_IA32_MCU_OPT_CTRL		0x00000123
-#define RNGDS_MITG_DIS			BIT(0)
+#define RNGDS_MITG_DIS			BIT(0)	/* SRBDS support */
+#define RTM_ALLOW			BIT(1)	/* TSX development mode */
 
 #define MSR_IA32_SYSENTER_CS		0x00000174
 #define MSR_IA32_SYSENTER_ESP		0x00000175
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 58b1416c05da..ec7d3ff5c662 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1714,6 +1714,8 @@ void identify_secondary_cpu(struct cpuinfo_x86 *c)
 	validate_apic_and_package_id(c);
 	x86_spec_ctrl_setup_ap();
 	update_srbds_msr();
+
+	tsx_ap_init();
 }
 
 static __init int setup_noclflush(char *arg)
diff --git a/arch/x86/kernel/cpu/cpu.h b/arch/x86/kernel/cpu/cpu.h
index ee6f23f7587d..2a8e584fc991 100644
--- a/arch/x86/kernel/cpu/cpu.h
+++ b/arch/x86/kernel/cpu/cpu.h
@@ -55,11 +55,10 @@ enum tsx_ctrl_states {
 extern __ro_after_init enum tsx_ctrl_states tsx_ctrl_state;
 
 extern void __init tsx_init(void);
-extern void tsx_enable(void);
-extern void tsx_disable(void);
-extern void tsx_clear_cpuid(void);
+void tsx_ap_init(void);
 #else
 static inline void tsx_init(void) { }
+static inline void tsx_ap_init(void) { }
 #endif /* CONFIG_CPU_SUP_INTEL */
 
 extern void get_cpu_cap(struct cpuinfo_x86 *c);
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 8321c43554a1..f7a5370a9b3b 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -717,13 +717,6 @@ static void init_intel(struct cpuinfo_x86 *c)
 
 	init_intel_misc_features(c);
 
-	if (tsx_ctrl_state == TSX_CTRL_ENABLE)
-		tsx_enable();
-	else if (tsx_ctrl_state == TSX_CTRL_DISABLE)
-		tsx_disable();
-	else if (tsx_ctrl_state == TSX_CTRL_RTM_ALWAYS_ABORT)
-		tsx_clear_cpuid();
-
 	split_lock_init();
 	bus_lock_init();
 
diff --git a/arch/x86/kernel/cpu/tsx.c b/arch/x86/kernel/cpu/tsx.c
index 9c7a5f049292..ec7bbac3a9f2 100644
--- a/arch/x86/kernel/cpu/tsx.c
+++ b/arch/x86/kernel/cpu/tsx.c
@@ -19,7 +19,7 @@
 
 enum tsx_ctrl_states tsx_ctrl_state __ro_after_init = TSX_CTRL_NOT_SUPPORTED;
 
-void tsx_disable(void)
+static void tsx_disable(void)
 {
 	u64 tsx;
 
@@ -39,7 +39,7 @@ void tsx_disable(void)
 	wrmsrl(MSR_IA32_TSX_CTRL, tsx);
 }
 
-void tsx_enable(void)
+static void tsx_enable(void)
 {
 	u64 tsx;
 
@@ -58,7 +58,7 @@ void tsx_enable(void)
 	wrmsrl(MSR_IA32_TSX_CTRL, tsx);
 }
 
-static bool __init tsx_ctrl_is_supported(void)
+static bool tsx_ctrl_is_supported(void)
 {
 	u64 ia32_cap = x86_read_arch_cap_msr();
 
@@ -84,7 +84,45 @@ static enum tsx_ctrl_states x86_get_tsx_auto_mode(void)
 	return TSX_CTRL_ENABLE;
 }
 
-void tsx_clear_cpuid(void)
+/*
+ * Disabling TSX is not a trivial business.
+ *
+ * First of all, there's a CPUID bit: X86_FEATURE_RTM_ALWAYS_ABORT
+ * which says that TSX is practically disabled (all transactions are
+ * aborted by default). When that bit is set, the kernel unconditionally
+ * disables TSX.
+ *
+ * In order to do that, however, it needs to dance a bit:
+ *
+ * 1. The first method to disable it is through MSR_TSX_FORCE_ABORT and
+ * the MSR is present only when *two* CPUID bits are set:
+ *
+ * - X86_FEATURE_RTM_ALWAYS_ABORT
+ * - X86_FEATURE_TSX_FORCE_ABORT
+ *
+ * 2. The second method is for CPUs which do not have the above-mentioned
+ * MSR: those use a different MSR - MSR_IA32_TSX_CTRL and disable TSX
+ * through that one. Those CPUs can also have the initially mentioned
+ * CPUID bit X86_FEATURE_RTM_ALWAYS_ABORT set and for those the same strategy
+ * applies: TSX gets disabled unconditionally.
+ *
+ * When either of the two methods are present, the kernel disables TSX and
+ * clears the respective RTM and HLE feature flags.
+ *
+ * An additional twist in the whole thing presents late microcode loading
+ * which, when done, may cause for the X86_FEATURE_RTM_ALWAYS_ABORT CPUID
+ * bit to be set after the update.
+ *
+ * A subsequent hotplug operation on any logical CPU except the BSP will
+ * cause for the supported CPUID feature bits to get re-detected and, if
+ * RTM and HLE get cleared all of a sudden, but, userspace did consult
+ * them before the update, then funny explosions will happen. Long story
+ * short: the kernel doesn't modify CPUID feature bits after booting.
+ *
+ * That's why, this function's call in init_intel() doesn't clear the
+ * feature flags.
+ */
+static void tsx_clear_cpuid(void)
 {
 	u64 msr;
 
@@ -97,6 +135,39 @@ void tsx_clear_cpuid(void)
 		rdmsrl(MSR_TSX_FORCE_ABORT, msr);
 		msr |= MSR_TFA_TSX_CPUID_CLEAR;
 		wrmsrl(MSR_TSX_FORCE_ABORT, msr);
+	} else if (tsx_ctrl_is_supported()) {
+		rdmsrl(MSR_IA32_TSX_CTRL, msr);
+		msr |= TSX_CTRL_CPUID_CLEAR;
+		wrmsrl(MSR_IA32_TSX_CTRL, msr);
+	}
+}
+
+/*
+ * Disable TSX development mode
+ *
+ * When the microcode released in Feb 2022 is applied, TSX will be disabled by
+ * default on some processors. MSR 0x122 (TSX_CTRL) and MSR 0x123
+ * (IA32_MCU_OPT_CTRL) can be used to re-enable TSX for development, doing so is
+ * not recommended for production deployments. In particular, applying MD_CLEAR
+ * flows for mitigation of the Intel TSX Asynchronous Abort (TAA) transient
+ * execution attack may not be effective on these processors when Intel TSX is
+ * enabled with updated microcode.
+ */
+static void tsx_dev_mode_disable(void)
+{
+	u64 mcu_opt_ctrl;
+
+	/* Check if RTM_ALLOW exists */
+	if (!boot_cpu_has_bug(X86_BUG_TAA) || !tsx_ctrl_is_supported() ||
+	    !cpu_feature_enabled(X86_FEATURE_SRBDS_CTRL))
+		return;
+
+	rdmsrl(MSR_IA32_MCU_OPT_CTRL, mcu_opt_ctrl);
+
+	if (mcu_opt_ctrl & RTM_ALLOW) {
+		mcu_opt_ctrl &= ~RTM_ALLOW;
+		wrmsrl(MSR_IA32_MCU_OPT_CTRL, mcu_opt_ctrl);
+		setup_force_cpu_cap(X86_FEATURE_RTM_ALWAYS_ABORT);
 	}
 }
 
@@ -105,14 +176,14 @@ void __init tsx_init(void)
 	char arg[5] = {};
 	int ret;
 
+	tsx_dev_mode_disable();
+
 	/*
-	 * Hardware will always abort a TSX transaction if both CPUID bits
-	 * RTM_ALWAYS_ABORT and TSX_FORCE_ABORT are set. In this case, it is
-	 * better not to enumerate CPUID.RTM and CPUID.HLE bits. Clear them
-	 * here.
+	 * Hardware will always abort a TSX transaction when the CPUID bit
+	 * RTM_ALWAYS_ABORT is set. In this case, it is better not to enumerate
+	 * CPUID.RTM and CPUID.HLE bits. Clear them here.
 	 */
-	if (boot_cpu_has(X86_FEATURE_RTM_ALWAYS_ABORT) &&
-	    boot_cpu_has(X86_FEATURE_TSX_FORCE_ABORT)) {
+	if (boot_cpu_has(X86_FEATURE_RTM_ALWAYS_ABORT)) {
 		tsx_ctrl_state = TSX_CTRL_RTM_ALWAYS_ABORT;
 		tsx_clear_cpuid();
 		setup_clear_cpu_cap(X86_FEATURE_RTM);
@@ -175,3 +246,16 @@ void __init tsx_init(void)
 		setup_force_cpu_cap(X86_FEATURE_HLE);
 	}
 }
+
+void tsx_ap_init(void)
+{
+	tsx_dev_mode_disable();
+
+	if (tsx_ctrl_state == TSX_CTRL_ENABLE)
+		tsx_enable();
+	else if (tsx_ctrl_state == TSX_CTRL_DISABLE)
+		tsx_disable();
+	else if (tsx_ctrl_state == TSX_CTRL_RTM_ALWAYS_ABORT)
+		/* See comment over that function for more details. */
+		tsx_clear_cpuid();
+}
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index d6579bae25ca..34e828badc51 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6105,12 +6105,24 @@ static int set_nx_huge_pages(const char *val, const struct kernel_param *kp)
 	return 0;
 }
 
-int kvm_mmu_module_init(void)
+/*
+ * nx_huge_pages needs to be resolved to true/false when kvm.ko is loaded, as
+ * its default value of -1 is technically undefined behavior for a boolean.
+ */
+void kvm_mmu_x86_module_init(void)
 {
-	int ret = -ENOMEM;
-
 	if (nx_huge_pages == -1)
 		__set_nx_huge_pages(get_nx_auto_mode());
+}
+
+/*
+ * The bulk of the MMU initialization is deferred until the vendor module is
+ * loaded as many of the masks/values may be modified by VMX or SVM, i.e. need
+ * to be reset when a potentially different vendor module is loaded.
+ */
+int kvm_mmu_vendor_module_init(void)
+{
+	int ret = -ENOMEM;
 
 	/*
 	 * MMU roles use union aliasing which is, generally speaking, an
@@ -6182,7 +6194,7 @@ void kvm_mmu_destroy(struct kvm_vcpu *vcpu)
 	mmu_free_memory_caches(vcpu);
 }
 
-void kvm_mmu_module_exit(void)
+void kvm_mmu_vendor_module_exit(void)
 {
 	mmu_destroy_caches();
 	percpu_counter_destroy(&kvm_total_used_mmu_pages);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5e2983959f23..5b1d2f656b45 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8562,7 +8562,7 @@ int kvm_arch_init(void *opaque)
 	}
 	kvm_nr_uret_msrs = 0;
 
-	r = kvm_mmu_module_init();
+	r = kvm_mmu_vendor_module_init();
 	if (r)
 		goto out_free_percpu;
 
@@ -8612,7 +8612,7 @@ void kvm_arch_exit(void)
 	cancel_work_sync(&pvclock_gtod_work);
 #endif
 	kvm_x86_ops.hardware_enable = NULL;
-	kvm_mmu_module_exit();
+	kvm_mmu_vendor_module_exit();
 	free_percpu(user_return_msrs);
 	kmem_cache_destroy(x86_emulator_cache);
 	kmem_cache_destroy(x86_fpu_cache);
@@ -12618,3 +12618,19 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_enter);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_exit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_msr_protocol_enter);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_msr_protocol_exit);
+
+static int __init kvm_x86_init(void)
+{
+	kvm_mmu_x86_module_init();
+	return 0;
+}
+module_init(kvm_x86_init);
+
+static void __exit kvm_x86_exit(void)
+{
+	/*
+	 * If module_init() is implemented, module_exit() must also be
+	 * implemented to allow module unload.
+	 */
+}
+module_exit(kvm_x86_exit);
diff --git a/block/bio.c b/block/bio.c
index 25f1ed261100..8906c9856a7d 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1552,7 +1552,7 @@ EXPORT_SYMBOL(bio_split);
 void bio_trim(struct bio *bio, sector_t offset, sector_t size)
 {
 	if (WARN_ON_ONCE(offset > BIO_MAX_SECTORS || size > BIO_MAX_SECTORS ||
-			 offset + size > bio->bi_iter.bi_size))
+			 offset + size > bio_sectors(bio)))
 		return;
 
 	size <<= 9;
diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index f37fba9e5ba0..1fd6a4a34c15 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -95,6 +95,11 @@ static const struct dmi_system_id processor_power_dmi_table[] = {
 	  DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK Computer Inc."),
 	  DMI_MATCH(DMI_PRODUCT_NAME,"L8400B series Notebook PC")},
 	 (void *)1},
+	/* T40 can not handle C3 idle state */
+	{ set_max_cstate, "IBM ThinkPad T40", {
+	  DMI_MATCH(DMI_SYS_VENDOR, "IBM"),
+	  DMI_MATCH(DMI_PRODUCT_NAME, "23737CU")},
+	 (void *)2},
 	{},
 };
 
@@ -789,7 +794,8 @@ static int acpi_processor_setup_cstates(struct acpi_processor *pr)
 		state->enter = acpi_idle_enter;
 
 		state->flags = 0;
-		if (cx->type == ACPI_STATE_C1 || cx->type == ACPI_STATE_C2) {
+		if (cx->type == ACPI_STATE_C1 || cx->type == ACPI_STATE_C2 ||
+		    cx->type == ACPI_STATE_C3) {
 			state->enter_dead = acpi_idle_play_dead;
 			drv->safe_state_index = count;
 		}
@@ -1075,6 +1081,11 @@ static int flatten_lpi_states(struct acpi_processor *pr,
 	return 0;
 }
 
+int __weak acpi_processor_ffh_lpi_probe(unsigned int cpu)
+{
+	return -EOPNOTSUPP;
+}
+
 static int acpi_processor_get_lpi_info(struct acpi_processor *pr)
 {
 	int ret, i;
@@ -1083,6 +1094,11 @@ static int acpi_processor_get_lpi_info(struct acpi_processor *pr)
 	struct acpi_device *d = NULL;
 	struct acpi_lpi_states_array info[2], *tmp, *prev, *curr;
 
+	/* make sure our architecture has support */
+	ret = acpi_processor_ffh_lpi_probe(pr->id);
+	if (ret == -EOPNOTSUPP)
+		return ret;
+
 	if (!osc_pc_lpi_support_confirmed)
 		return -EOPNOTSUPP;
 
@@ -1134,11 +1150,6 @@ static int acpi_processor_get_lpi_info(struct acpi_processor *pr)
 	return 0;
 }
 
-int __weak acpi_processor_ffh_lpi_probe(unsigned int cpu)
-{
-	return -ENODEV;
-}
-
 int __weak acpi_processor_ffh_lpi_enter(struct acpi_lpi_state *lpi)
 {
 	return -ENODEV;
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 24b67d78cb83..a0343b7c9add 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -3999,6 +3999,9 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 						ATA_HORKAGE_ZERO_AFTER_TRIM, },
 	{ "Crucial_CT*MX100*",		"MU01",	ATA_HORKAGE_NO_NCQ_TRIM |
 						ATA_HORKAGE_ZERO_AFTER_TRIM, },
+	{ "Samsung SSD 840 EVO*",	NULL,	ATA_HORKAGE_NO_NCQ_TRIM |
+						ATA_HORKAGE_NO_DMA_LOG |
+						ATA_HORKAGE_ZERO_AFTER_TRIM, },
 	{ "Samsung SSD 840*",		NULL,	ATA_HORKAGE_NO_NCQ_TRIM |
 						ATA_HORKAGE_ZERO_AFTER_TRIM, },
 	{ "Samsung SSD 850*",		NULL,	ATA_HORKAGE_NO_NCQ_TRIM |
diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 64ce42b6c6b6..95ae347df137 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -296,6 +296,7 @@ int driver_deferred_probe_check_state(struct device *dev)
 
 	return -EPROBE_DEFER;
 }
+EXPORT_SYMBOL_GPL(driver_deferred_probe_check_state);
 
 static void deferred_probe_timeout_work_func(struct work_struct *work)
 {
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 55234a558e98..548e0dd53528 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2737,6 +2737,7 @@ enum drbd_ret_code drbd_create_device(struct drbd_config_context *adm_ctx, unsig
 	sprintf(disk->disk_name, "drbd%d", minor);
 	disk->private_data = device;
 
+	blk_queue_flag_set(QUEUE_FLAG_STABLE_WRITES, disk->queue);
 	blk_queue_write_cache(disk->queue, true, true);
 	/* Setting the max_hw_sectors to an odd value of 8kibyte here
 	   This triggers a max_bio_size message upon first attach or connect */
diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index e15c3bc17a55..8a2c6b58b652 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -335,6 +335,8 @@ static void intel_pstste_sched_itmt_work_fn(struct work_struct *work)
 
 static DECLARE_WORK(sched_itmt_work, intel_pstste_sched_itmt_work_fn);
 
+#define CPPC_MAX_PERF	U8_MAX
+
 static void intel_pstate_set_itmt_prio(int cpu)
 {
 	struct cppc_perf_caps cppc_perf;
@@ -345,6 +347,14 @@ static void intel_pstate_set_itmt_prio(int cpu)
 	if (ret)
 		return;
 
+	/*
+	 * On some systems with overclocking enabled, CPPC.highest_perf is hardcoded to 0xff.
+	 * In this case we can't use CPPC.highest_perf to enable ITMT.
+	 * In this case we can look at MSR_HWP_CAPABILITIES bits [8:0] to decide.
+	 */
+	if (cppc_perf.highest_perf == CPPC_MAX_PERF)
+		cppc_perf.highest_perf = HWP_HIGHEST_PERF(READ_ONCE(all_cpu_data[cpu]->hwp_cap_cached));
+
 	/*
 	 * The priorities can be set regardless of whether or not
 	 * sched_set_itmt_support(true) has been called and it is valid to
diff --git a/drivers/firmware/arm_scmi/clock.c b/drivers/firmware/arm_scmi/clock.c
index 35b56c8ba0c0..492f3a9197ec 100644
--- a/drivers/firmware/arm_scmi/clock.c
+++ b/drivers/firmware/arm_scmi/clock.c
@@ -204,7 +204,8 @@ scmi_clock_describe_rates_get(const struct scmi_protocol_handle *ph, u32 clk_id,
 
 	if (rate_discrete && rate) {
 		clk->list.num_rates = tot_rate_cnt;
-		sort(rate, tot_rate_cnt, sizeof(*rate), rate_cmp_func, NULL);
+		sort(clk->list.rates, tot_rate_cnt, sizeof(*rate),
+		     rate_cmp_func, NULL);
 	}
 
 	clk->rate_discrete = rate_discrete;
diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index d76bab3aaac4..e815b8f98739 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -652,7 +652,8 @@ static void scmi_handle_response(struct scmi_chan_info *cinfo,
 
 	xfer = scmi_xfer_command_acquire(cinfo, msg_hdr);
 	if (IS_ERR(xfer)) {
-		scmi_clear_channel(info, cinfo);
+		if (MSG_XTRACT_TYPE(msg_hdr) == MSG_TYPE_DELAYED_RESP)
+			scmi_clear_channel(info, cinfo);
 		return;
 	}
 
diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
index 4c2e32c38acc..53be0bdf2bc3 100644
--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -392,8 +392,8 @@ static acpi_status acpi_gpiochip_alloc_event(struct acpi_resource *ares,
 	pin = agpio->pin_table[0];
 
 	if (pin <= 255) {
-		char ev_name[5];
-		sprintf(ev_name, "_%c%02hhX",
+		char ev_name[8];
+		sprintf(ev_name, "_%c%02X",
 			agpio->triggering == ACPI_EDGE_SENSITIVE ? 'E' : 'L',
 			pin);
 		if (ACPI_SUCCESS(acpi_get_handle(handle, ev_name, &evt_handle)))
diff --git a/drivers/gpu/drm/amd/amdgpu/ObjectID.h b/drivers/gpu/drm/amd/amdgpu/ObjectID.h
index 5b393622f592..a0f0a17e224f 100644
--- a/drivers/gpu/drm/amd/amdgpu/ObjectID.h
+++ b/drivers/gpu/drm/amd/amdgpu/ObjectID.h
@@ -119,6 +119,7 @@
 #define CONNECTOR_OBJECT_ID_eDP                   0x14
 #define CONNECTOR_OBJECT_ID_MXM                   0x15
 #define CONNECTOR_OBJECT_ID_LVDS_eDP              0x16
+#define CONNECTOR_OBJECT_ID_USBC                  0x17
 
 /* deleted */
 
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 33026b3eafd2..2f2ae26a8068 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -5625,7 +5625,7 @@ void amdgpu_device_flush_hdp(struct amdgpu_device *adev,
 		struct amdgpu_ring *ring)
 {
 #ifdef CONFIG_X86_64
-	if (adev->flags & AMD_IS_APU)
+	if ((adev->flags & AMD_IS_APU) && !amdgpu_passthrough(adev))
 		return;
 #endif
 	if (adev->gmc.xgmi.connected_to_cpu)
@@ -5641,7 +5641,7 @@ void amdgpu_device_invalidate_hdp(struct amdgpu_device *adev,
 		struct amdgpu_ring *ring)
 {
 #ifdef CONFIG_X86_64
-	if (adev->flags & AMD_IS_APU)
+	if ((adev->flags & AMD_IS_APU) && !amdgpu_passthrough(adev))
 		return;
 #endif
 	if (adev->gmc.xgmi.connected_to_cpu)
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
index 5a7fef324c82..b517b76e96a1 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -680,7 +680,7 @@ MODULE_PARM_DESC(sched_policy,
  * Maximum number of processes that HWS can schedule concurrently. The maximum is the
  * number of VMIDs assigned to the HWS, which is also the default.
  */
-int hws_max_conc_proc = 8;
+int hws_max_conc_proc = -1;
 module_param(hws_max_conc_proc, int, 0444);
 MODULE_PARM_DESC(hws_max_conc_proc,
 	"Max # processes HWS can execute concurrently when sched_policy=0 (0 = no concurrency, #VMIDs for KFD = Maximum(default))");
diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
index c39e53a41f13..db27fcf87cd0 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -1272,6 +1272,8 @@ static const struct amdgpu_gfxoff_quirk amdgpu_gfxoff_quirk_list[] = {
 	{ 0x1002, 0x15dd, 0x103c, 0x83e7, 0xd3 },
 	/* GFXOFF is unstable on C6 parts with a VBIOS 113-RAVEN-114 */
 	{ 0x1002, 0x15dd, 0x1002, 0x15dd, 0xc6 },
+	/* Apple MacBook Pro (15-inch, 2019) Radeon Pro Vega 20 4 GB */
+	{ 0x1002, 0x69af, 0x106b, 0x019a, 0xc0 },
 	{ 0, 0, 0, 0, 0 },
 };
 
diff --git a/drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c b/drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c
index 3c01be661014..93a4da4284ed 100644
--- a/drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c
@@ -788,7 +788,7 @@ static int gmc_v10_0_mc_init(struct amdgpu_device *adev)
 	adev->gmc.aper_size = pci_resource_len(adev->pdev, 0);
 
 #ifdef CONFIG_X86_64
-	if (adev->flags & AMD_IS_APU) {
+	if ((adev->flags & AMD_IS_APU) && !amdgpu_passthrough(adev)) {
 		adev->gmc.aper_base = adev->gfxhub.funcs->get_mc_fb_offset(adev);
 		adev->gmc.aper_size = adev->gmc.real_vram_size;
 	}
diff --git a/drivers/gpu/drm/amd/amdgpu/gmc_v7_0.c b/drivers/gpu/drm/amd/amdgpu/gmc_v7_0.c
index 0a50fdaced7e..63c47f61d0df 100644
--- a/drivers/gpu/drm/amd/amdgpu/gmc_v7_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v7_0.c
@@ -381,8 +381,9 @@ static int gmc_v7_0_mc_init(struct amdgpu_device *adev)
 	adev->gmc.aper_size = pci_resource_len(adev->pdev, 0);
 
 #ifdef CONFIG_X86_64
-	if (adev->flags & AMD_IS_APU &&
-	    adev->gmc.real_vram_size > adev->gmc.aper_size) {
+	if ((adev->flags & AMD_IS_APU) &&
+	    adev->gmc.real_vram_size > adev->gmc.aper_size &&
+	    !amdgpu_passthrough(adev)) {
 		adev->gmc.aper_base = ((u64)RREG32(mmMC_VM_FB_OFFSET)) << 22;
 		adev->gmc.aper_size = adev->gmc.real_vram_size;
 	}
diff --git a/drivers/gpu/drm/amd/amdgpu/gmc_v8_0.c b/drivers/gpu/drm/amd/amdgpu/gmc_v8_0.c
index 63b890f1e8af..bef9610084f1 100644
--- a/drivers/gpu/drm/amd/amdgpu/gmc_v8_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v8_0.c
@@ -581,7 +581,7 @@ static int gmc_v8_0_mc_init(struct amdgpu_device *adev)
 	adev->gmc.aper_size = pci_resource_len(adev->pdev, 0);
 
 #ifdef CONFIG_X86_64
-	if (adev->flags & AMD_IS_APU) {
+	if ((adev->flags & AMD_IS_APU) && !amdgpu_passthrough(adev)) {
 		adev->gmc.aper_base = ((u64)RREG32(mmMC_VM_FB_OFFSET)) << 22;
 		adev->gmc.aper_size = adev->gmc.real_vram_size;
 	}
diff --git a/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
index c67e21244342..0e731016921b 100644
--- a/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
@@ -1387,7 +1387,7 @@ static int gmc_v9_0_mc_init(struct amdgpu_device *adev)
 	 */
 
 	/* check whether both host-gpu and gpu-gpu xgmi links exist */
-	if ((adev->flags & AMD_IS_APU) ||
+	if (((adev->flags & AMD_IS_APU) && !amdgpu_passthrough(adev)) ||
 	    (adev->gmc.xgmi.supported &&
 	     adev->gmc.xgmi.connected_to_cpu)) {
 		adev->gmc.aper_base =
@@ -1652,7 +1652,7 @@ static int gmc_v9_0_sw_fini(void *handle)
 	amdgpu_gem_force_release(adev);
 	amdgpu_vm_manager_fini(adev);
 	amdgpu_gart_table_vram_free(adev);
-	amdgpu_bo_unref(&adev->gmc.pdb0_bo);
+	amdgpu_bo_free_kernel(&adev->gmc.pdb0_bo, NULL, &adev->gmc.ptr_pdb0);
 	amdgpu_bo_fini(adev);
 
 	return 0;
diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c b/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
index 54b405fc600d..6e56bef4fdf8 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
@@ -1508,8 +1508,11 @@ static int vcn_v3_0_start_sriov(struct amdgpu_device *adev)
 
 static int vcn_v3_0_stop_dpg_mode(struct amdgpu_device *adev, int inst_idx)
 {
+	struct dpg_pause_state state = {.fw_based = VCN_DPG_STATE__UNPAUSE};
 	uint32_t tmp;
 
+	vcn_v3_0_pause_dpg_mode(adev, 0, &state);
+
 	/* Wait for power status to be 1 */
 	SOC15_WAIT_ON_RREG(VCN, inst_idx, mmUVD_POWER_STATUS, 1,
 		UVD_POWER_STATUS__UVD_POWER_STATUS_MASK);
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device.c b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
index 88c483f69989..660eb7097cfc 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
@@ -834,15 +834,10 @@ bool kgd2kfd_device_init(struct kfd_dev *kfd,
 	}
 
 	/* Verify module parameters regarding mapped process number*/
-	if ((hws_max_conc_proc < 0)
-			|| (hws_max_conc_proc > kfd->vm_info.vmid_num_kfd)) {
-		dev_err(kfd_device,
-			"hws_max_conc_proc %d must be between 0 and %d, use %d instead\n",
-			hws_max_conc_proc, kfd->vm_info.vmid_num_kfd,
-			kfd->vm_info.vmid_num_kfd);
+	if (hws_max_conc_proc >= 0)
+		kfd->max_proc_per_quantum = min((u32)hws_max_conc_proc, kfd->vm_info.vmid_num_kfd);
+	else
 		kfd->max_proc_per_quantum = kfd->vm_info.vmid_num_kfd;
-	} else
-		kfd->max_proc_per_quantum = hws_max_conc_proc;
 
 	/* calculate max size of mqds needed for queues */
 	size = max_num_of_queues_per_device *
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_events.c b/drivers/gpu/drm/amd/amdkfd/kfd_events.c
index 3eea4edee355..b8bdd796cd91 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_events.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_events.c
@@ -531,6 +531,8 @@ static struct kfd_event_waiter *alloc_event_waiters(uint32_t num_events)
 	event_waiters = kmalloc_array(num_events,
 					sizeof(struct kfd_event_waiter),
 					GFP_KERNEL);
+	if (!event_waiters)
+		return NULL;
 
 	for (i = 0; (event_waiters) && (i < num_events) ; i++) {
 		init_wait(&event_waiters[i].wait);
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 7e9e2eb85eca..ec75613618b1 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -2296,7 +2296,8 @@ static int dm_resume(void *handle)
 		 * this is the case when traversing through already created
 		 * MST connectors, should be skipped
 		 */
-		if (aconnector->mst_port)
+		if (aconnector->dc_link &&
+		    aconnector->dc_link->type == dc_connection_mst_branch)
 			continue;
 
 		mutex_lock(&aconnector->hpd_lock);
diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
index 108f3854cd2a..82f1f27baaf3 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -1626,8 +1626,8 @@ bool dc_is_stream_unchanged(
 	if (old_stream->ignore_msa_timing_param != stream->ignore_msa_timing_param)
 		return false;
 
-	// Only Have Audio left to check whether it is same or not. This is a corner case for Tiled sinks
-	if (old_stream->audio_info.mode_count != stream->audio_info.mode_count)
+	/*compare audio info*/
+	if (memcmp(&old_stream->audio_info, &stream->audio_info, sizeof(stream->audio_info)) != 0)
 		return false;
 
 	return true;
diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hubbub.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hubbub.c
index f4f423d0b8c3..80595d7f060c 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hubbub.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hubbub.c
@@ -940,6 +940,7 @@ static const struct hubbub_funcs hubbub1_funcs = {
 	.program_watermarks = hubbub1_program_watermarks,
 	.is_allow_self_refresh_enabled = hubbub1_is_allow_self_refresh_enabled,
 	.allow_self_refresh_control = hubbub1_allow_self_refresh_control,
+	.verify_allow_pstate_change_high = hubbub1_verify_allow_pstate_change_high,
 };
 
 void hubbub1_construct(struct hubbub *hubbub,
diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
index 3af49cdf89eb..93f31e4aeecb 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
@@ -1052,9 +1052,13 @@ static bool dcn10_hw_wa_force_recovery(struct dc *dc)
 
 void dcn10_verify_allow_pstate_change_high(struct dc *dc)
 {
+	struct hubbub *hubbub = dc->res_pool->hubbub;
 	static bool should_log_hw_state; /* prevent hw state log by default */
 
-	if (!hubbub1_verify_allow_pstate_change_high(dc->res_pool->hubbub)) {
+	if (!hubbub->funcs->verify_allow_pstate_change_high)
+		return;
+
+	if (!hubbub->funcs->verify_allow_pstate_change_high(hubbub)) {
 		int i = 0;
 
 		if (should_log_hw_state)
@@ -1063,8 +1067,8 @@ void dcn10_verify_allow_pstate_change_high(struct dc *dc)
 		TRACE_DC_PIPE_STATE(pipe_ctx, i, MAX_PIPES);
 		BREAK_TO_DEBUGGER();
 		if (dcn10_hw_wa_force_recovery(dc)) {
-		/*check again*/
-			if (!hubbub1_verify_allow_pstate_change_high(dc->res_pool->hubbub))
+			/*check again*/
+			if (!hubbub->funcs->verify_allow_pstate_change_high(hubbub))
 				BREAK_TO_DEBUGGER();
 		}
 	}
@@ -1435,6 +1439,9 @@ void dcn10_init_hw(struct dc *dc)
 		}
 	}
 
+	if (hws->funcs.enable_power_gating_plane)
+		hws->funcs.enable_power_gating_plane(dc->hwseq, true);
+
 	/* If taking control over from VBIOS, we may want to optimize our first
 	 * mode set, so we need to skip powering down pipes until we know which
 	 * pipes we want to use.
@@ -1487,8 +1494,6 @@ void dcn10_init_hw(struct dc *dc)
 
 		REG_UPDATE(DCFCLK_CNTL, DCFCLK_GATE_DIS, 0);
 	}
-	if (hws->funcs.enable_power_gating_plane)
-		hws->funcs.enable_power_gating_plane(dc->hwseq, true);
 
 	if (dc->clk_mgr->funcs->notify_wm_ranges)
 		dc->clk_mgr->funcs->notify_wm_ranges(dc->clk_mgr);
@@ -2455,14 +2460,18 @@ void dcn10_update_mpcc(struct dc *dc, struct pipe_ctx *pipe_ctx)
 	struct mpc *mpc = dc->res_pool->mpc;
 	struct mpc_tree *mpc_tree_params = &(pipe_ctx->stream_res.opp->mpc_tree_params);
 
-	if (per_pixel_alpha)
-		blnd_cfg.alpha_mode = MPCC_ALPHA_BLEND_MODE_PER_PIXEL_ALPHA;
-	else
-		blnd_cfg.alpha_mode = MPCC_ALPHA_BLEND_MODE_GLOBAL_ALPHA;
-
 	blnd_cfg.overlap_only = false;
 	blnd_cfg.global_gain = 0xff;
 
+	if (per_pixel_alpha && pipe_ctx->plane_state->global_alpha) {
+		blnd_cfg.alpha_mode = MPCC_ALPHA_BLEND_MODE_PER_PIXEL_ALPHA_COMBINED_GLOBAL_GAIN;
+		blnd_cfg.global_gain = pipe_ctx->plane_state->global_alpha_value;
+	} else if (per_pixel_alpha) {
+		blnd_cfg.alpha_mode = MPCC_ALPHA_BLEND_MODE_PER_PIXEL_ALPHA;
+	} else {
+		blnd_cfg.alpha_mode = MPCC_ALPHA_BLEND_MODE_GLOBAL_ALPHA;
+	}
+
 	if (pipe_ctx->plane_state->global_alpha)
 		blnd_cfg.global_alpha = pipe_ctx->plane_state->global_alpha_value;
 	else
diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
index a47ba1d45be9..9f8d7f92300b 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
@@ -2297,14 +2297,18 @@ void dcn20_update_mpcc(struct dc *dc, struct pipe_ctx *pipe_ctx)
 	struct mpc *mpc = dc->res_pool->mpc;
 	struct mpc_tree *mpc_tree_params = &(pipe_ctx->stream_res.opp->mpc_tree_params);
 
-	if (per_pixel_alpha)
-		blnd_cfg.alpha_mode = MPCC_ALPHA_BLEND_MODE_PER_PIXEL_ALPHA;
-	else
-		blnd_cfg.alpha_mode = MPCC_ALPHA_BLEND_MODE_GLOBAL_ALPHA;
-
 	blnd_cfg.overlap_only = false;
 	blnd_cfg.global_gain = 0xff;
 
+	if (per_pixel_alpha && pipe_ctx->plane_state->global_alpha) {
+		blnd_cfg.alpha_mode = MPCC_ALPHA_BLEND_MODE_PER_PIXEL_ALPHA_COMBINED_GLOBAL_GAIN;
+		blnd_cfg.global_gain = pipe_ctx->plane_state->global_alpha_value;
+	} else if (per_pixel_alpha) {
+		blnd_cfg.alpha_mode = MPCC_ALPHA_BLEND_MODE_PER_PIXEL_ALPHA;
+	} else {
+		blnd_cfg.alpha_mode = MPCC_ALPHA_BLEND_MODE_GLOBAL_ALPHA;
+	}
+
 	if (pipe_ctx->plane_state->global_alpha)
 		blnd_cfg.global_alpha = pipe_ctx->plane_state->global_alpha_value;
 	else
diff --git a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hubbub.c b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hubbub.c
index f4414de96acc..152c9c5733f1 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hubbub.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hubbub.c
@@ -448,6 +448,7 @@ static const struct hubbub_funcs hubbub30_funcs = {
 	.program_watermarks = hubbub3_program_watermarks,
 	.allow_self_refresh_control = hubbub1_allow_self_refresh_control,
 	.is_allow_self_refresh_enabled = hubbub1_is_allow_self_refresh_enabled,
+	.verify_allow_pstate_change_high = hubbub1_verify_allow_pstate_change_high,
 	.force_wm_propagate_to_pipes = hubbub3_force_wm_propagate_to_pipes,
 	.force_pstate_change_control = hubbub3_force_pstate_change_control,
 	.init_watermarks = hubbub3_init_watermarks,
diff --git a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c
index 0950784bafa4..f83457375811 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c
@@ -570,6 +570,9 @@ void dcn30_init_hw(struct dc *dc)
 		}
 	}
 
+	if (hws->funcs.enable_power_gating_plane)
+		hws->funcs.enable_power_gating_plane(dc->hwseq, true);
+
 	/* If taking control over from VBIOS, we may want to optimize our first
 	 * mode set, so we need to skip powering down pipes until we know which
 	 * pipes we want to use.
@@ -647,8 +650,6 @@ void dcn30_init_hw(struct dc *dc)
 
 		REG_UPDATE(DCFCLK_CNTL, DCFCLK_GATE_DIS, 0);
 	}
-	if (hws->funcs.enable_power_gating_plane)
-		hws->funcs.enable_power_gating_plane(dc->hwseq, true);
 
 	if (!dcb->funcs->is_accelerated_mode(dcb) && dc->res_pool->hubbub->funcs->init_watermarks)
 		dc->res_pool->hubbub->funcs->init_watermarks(dc->res_pool->hubbub);
diff --git a/drivers/gpu/drm/amd/display/dc/dcn301/dcn301_hubbub.c b/drivers/gpu/drm/amd/display/dc/dcn301/dcn301_hubbub.c
index 1e3bd2e9cdcc..a046664e2031 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn301/dcn301_hubbub.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn301/dcn301_hubbub.c
@@ -60,6 +60,7 @@ static const struct hubbub_funcs hubbub301_funcs = {
 	.program_watermarks = hubbub3_program_watermarks,
 	.allow_self_refresh_control = hubbub1_allow_self_refresh_control,
 	.is_allow_self_refresh_enabled = hubbub1_is_allow_self_refresh_enabled,
+	.verify_allow_pstate_change_high = hubbub1_verify_allow_pstate_change_high,
 	.force_wm_propagate_to_pipes = hubbub3_force_wm_propagate_to_pipes,
 	.force_pstate_change_control = hubbub3_force_pstate_change_control,
 	.hubbub_read_state = hubbub2_read_state,
diff --git a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hubbub.c b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hubbub.c
index 5e3bcaf12cac..208d2dc8b1d1 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hubbub.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hubbub.c
@@ -24,6 +24,7 @@
  */
 
 
+#include <linux/delay.h>
 #include "dcn30/dcn30_hubbub.h"
 #include "dcn31_hubbub.h"
 #include "dm_services.h"
@@ -949,6 +950,65 @@ static void hubbub31_get_dchub_ref_freq(struct hubbub *hubbub,
 	}
 }
 
+static bool hubbub31_verify_allow_pstate_change_high(struct hubbub *hubbub)
+{
+	struct dcn20_hubbub *hubbub2 = TO_DCN20_HUBBUB(hubbub);
+
+	/*
+	 * Pstate latency is ~20us so if we wait over 40us and pstate allow
+	 * still not asserted, we are probably stuck and going to hang
+	 */
+	const unsigned int pstate_wait_timeout_us = 100;
+	const unsigned int pstate_wait_expected_timeout_us = 40;
+
+	static unsigned int max_sampled_pstate_wait_us; /* data collection */
+	static bool forced_pstate_allow; /* help with revert wa */
+
+	unsigned int debug_data = 0;
+	unsigned int i;
+
+	if (forced_pstate_allow) {
+		/* we hacked to force pstate allow to prevent hang last time
+		 * we verify_allow_pstate_change_high.  so disable force
+		 * here so we can check status
+		 */
+		REG_UPDATE_2(DCHUBBUB_ARB_DRAM_STATE_CNTL,
+			     DCHUBBUB_ARB_ALLOW_PSTATE_CHANGE_FORCE_VALUE, 0,
+			     DCHUBBUB_ARB_ALLOW_PSTATE_CHANGE_FORCE_ENABLE, 0);
+		forced_pstate_allow = false;
+	}
+
+	REG_WRITE(DCHUBBUB_TEST_DEBUG_INDEX, hubbub2->debug_test_index_pstate);
+
+	for (i = 0; i < pstate_wait_timeout_us; i++) {
+		debug_data = REG_READ(DCHUBBUB_TEST_DEBUG_DATA);
+
+		/* Debug bit is specific to ASIC. */
+		if (debug_data & (1 << 26)) {
+			if (i > pstate_wait_expected_timeout_us)
+				DC_LOG_WARNING("pstate took longer than expected ~%dus\n", i);
+			return true;
+		}
+		if (max_sampled_pstate_wait_us < i)
+			max_sampled_pstate_wait_us = i;
+
+		udelay(1);
+	}
+
+	/* force pstate allow to prevent system hang
+	 * and break to debugger to investigate
+	 */
+	REG_UPDATE_2(DCHUBBUB_ARB_DRAM_STATE_CNTL,
+		     DCHUBBUB_ARB_ALLOW_PSTATE_CHANGE_FORCE_VALUE, 1,
+		     DCHUBBUB_ARB_ALLOW_PSTATE_CHANGE_FORCE_ENABLE, 1);
+	forced_pstate_allow = true;
+
+	DC_LOG_WARNING("pstate TEST_DEBUG_DATA: 0x%X\n",
+			debug_data);
+
+	return false;
+}
+
 static const struct hubbub_funcs hubbub31_funcs = {
 	.update_dchub = hubbub2_update_dchub,
 	.init_dchub_sys_ctx = hubbub31_init_dchub_sys_ctx,
@@ -961,6 +1021,7 @@ static const struct hubbub_funcs hubbub31_funcs = {
 	.program_watermarks = hubbub31_program_watermarks,
 	.allow_self_refresh_control = hubbub1_allow_self_refresh_control,
 	.is_allow_self_refresh_enabled = hubbub1_is_allow_self_refresh_enabled,
+	.verify_allow_pstate_change_high = hubbub31_verify_allow_pstate_change_high,
 	.program_det_size = dcn31_program_det_size,
 	.program_compbuf_size = dcn31_program_compbuf_size,
 	.init_crb = dcn31_init_crb,
@@ -982,5 +1043,7 @@ void hubbub31_construct(struct dcn20_hubbub *hubbub31,
 	hubbub31->detile_buf_size = det_size_kb * 1024;
 	hubbub31->pixel_chunk_size = pixel_chunk_size_kb * 1024;
 	hubbub31->crb_size_segs = config_return_buffer_size_kb / DCN31_CRB_SEGMENT_SIZE_KB;
+
+	hubbub31->debug_test_index_pstate = 0x6;
 }
 
diff --git a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hwseq.c
index 3afa1159a5f7..b72d080b302a 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hwseq.c
@@ -204,6 +204,9 @@ void dcn31_init_hw(struct dc *dc)
 		}
 	}
 
+	if (hws->funcs.enable_power_gating_plane)
+		hws->funcs.enable_power_gating_plane(dc->hwseq, true);
+
 	/* If taking control over from VBIOS, we may want to optimize our first
 	 * mode set, so we need to skip powering down pipes until we know which
 	 * pipes we want to use.
@@ -287,8 +290,6 @@ void dcn31_init_hw(struct dc *dc)
 
 		REG_UPDATE(DCFCLK_CNTL, DCFCLK_GATE_DIS, 0);
 	}
-	if (hws->funcs.enable_power_gating_plane)
-		hws->funcs.enable_power_gating_plane(dc->hwseq, true);
 
 	if (!dcb->funcs->is_accelerated_mode(dcb) && dc->res_pool->hubbub->funcs->init_watermarks)
 		dc->res_pool->hubbub->funcs->init_watermarks(dc->res_pool->hubbub);
diff --git a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c
index d4fe5352421f..a5ef9d5e7685 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c
@@ -940,7 +940,7 @@ static const struct dc_debug_options debug_defaults_drv = {
 	.max_downscale_src_width = 4096,/*upto true 4K*/
 	.disable_pplib_wm_range = false,
 	.scl_reset_length10 = true,
-	.sanity_checks = false,
+	.sanity_checks = true,
 	.underflow_assert_delay_us = 0xFFFFFFFF,
 	.dwb_fi_phase = -1, // -1 = disable,
 	.dmub_command_table = true,
diff --git a/drivers/gpu/drm/amd/display/dc/inc/hw/dchubbub.h b/drivers/gpu/drm/amd/display/dc/inc/hw/dchubbub.h
index 713f5558f5e1..9195dec294c2 100644
--- a/drivers/gpu/drm/amd/display/dc/inc/hw/dchubbub.h
+++ b/drivers/gpu/drm/amd/display/dc/inc/hw/dchubbub.h
@@ -154,6 +154,8 @@ struct hubbub_funcs {
 	bool (*is_allow_self_refresh_enabled)(struct hubbub *hubbub);
 	void (*allow_self_refresh_control)(struct hubbub *hubbub, bool allow);
 
+	bool (*verify_allow_pstate_change_high)(struct hubbub *hubbub);
+
 	void (*apply_DEDCN21_147_wa)(struct hubbub *hubbub);
 
 	void (*force_wm_propagate_to_pipes)(struct hubbub *hubbub);
diff --git a/drivers/gpu/drm/amd/display/modules/info_packet/info_packet.c b/drivers/gpu/drm/amd/display/modules/info_packet/info_packet.c
index 57f198de5e2c..4e075b01d48b 100644
--- a/drivers/gpu/drm/amd/display/modules/info_packet/info_packet.c
+++ b/drivers/gpu/drm/amd/display/modules/info_packet/info_packet.c
@@ -100,7 +100,8 @@ enum vsc_packet_revision {
 //PB7 = MD0
 #define MASK_VTEM_MD0__VRR_EN         0x01
 #define MASK_VTEM_MD0__M_CONST        0x02
-#define MASK_VTEM_MD0__RESERVED2      0x0C
+#define MASK_VTEM_MD0__QMS_EN         0x04
+#define MASK_VTEM_MD0__RESERVED2      0x08
 #define MASK_VTEM_MD0__FVA_FACTOR_M1  0xF0
 
 //MD1
@@ -109,7 +110,7 @@ enum vsc_packet_revision {
 //MD2
 #define MASK_VTEM_MD2__BASE_REFRESH_RATE_98  0x03
 #define MASK_VTEM_MD2__RB                    0x04
-#define MASK_VTEM_MD2__RESERVED3             0xF8
+#define MASK_VTEM_MD2__NEXT_TFR              0xF8
 
 //MD3
 #define MASK_VTEM_MD3__BASE_REFRESH_RATE_07  0xFF
diff --git a/drivers/gpu/drm/i915/gem/i915_gem_mman.c b/drivers/gpu/drm/i915/gem/i915_gem_mman.c
index bed496a0ddf1..28e07040cf47 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_mman.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_mman.c
@@ -66,7 +66,7 @@ i915_gem_mmap_ioctl(struct drm_device *dev, void *data,
 	 * mmap ioctl is disallowed for all discrete platforms,
 	 * and for all platforms with GRAPHICS_VER > 12.
 	 */
-	if (IS_DGFX(i915) || GRAPHICS_VER(i915) > 12)
+	if (IS_DGFX(i915) || GRAPHICS_VER_FULL(i915) > IP_VER(12, 0))
 		return -EOPNOTSUPP;
 
 	if (args->flags & ~(I915_MMAP_WC))
diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
index f54bfdb1ebff..9b41e2f82fc2 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -1711,7 +1711,7 @@ a6xx_create_private_address_space(struct msm_gpu *gpu)
 		return ERR_CAST(mmu);
 
 	return msm_gem_address_space_create(mmu,
-		"gpu", 0x100000000ULL, 0x1ffffffffULL);
+		"gpu", 0x100000000ULL, SZ_4G);
 }
 
 static uint32_t a6xx_get_rptr(struct msm_gpu *gpu, struct msm_ringbuffer *ring)
diff --git a/drivers/gpu/drm/msm/dp/dp_display.c b/drivers/gpu/drm/msm/dp/dp_display.c
index d5198b435638..a133f7e154e7 100644
--- a/drivers/gpu/drm/msm/dp/dp_display.c
+++ b/drivers/gpu/drm/msm/dp/dp_display.c
@@ -551,6 +551,12 @@ static int dp_hpd_plug_handle(struct dp_display_private *dp, u32 data)
 
 	mutex_unlock(&dp->event_mutex);
 
+	/*
+	 * add fail safe mode outside event_mutex scope
+	 * to avoid potiential circular lock with drm thread
+	 */
+	dp_panel_add_fail_safe_mode(dp->dp_display.connector);
+
 	/* uevent will complete connection part */
 	return 0;
 };
diff --git a/drivers/gpu/drm/msm/dp/dp_panel.c b/drivers/gpu/drm/msm/dp/dp_panel.c
index 5f23e6f09199..982f5e8c3546 100644
--- a/drivers/gpu/drm/msm/dp/dp_panel.c
+++ b/drivers/gpu/drm/msm/dp/dp_panel.c
@@ -151,6 +151,15 @@ static int dp_panel_update_modes(struct drm_connector *connector,
 	return rc;
 }
 
+void dp_panel_add_fail_safe_mode(struct drm_connector *connector)
+{
+	/* fail safe edid */
+	mutex_lock(&connector->dev->mode_config.mutex);
+	if (drm_add_modes_noedid(connector, 640, 480))
+		drm_set_preferred_mode(connector, 640, 480);
+	mutex_unlock(&connector->dev->mode_config.mutex);
+}
+
 int dp_panel_read_sink_caps(struct dp_panel *dp_panel,
 	struct drm_connector *connector)
 {
@@ -207,16 +216,7 @@ int dp_panel_read_sink_caps(struct dp_panel *dp_panel,
 			goto end;
 		}
 
-		/* fail safe edid */
-		mutex_lock(&connector->dev->mode_config.mutex);
-		if (drm_add_modes_noedid(connector, 640, 480))
-			drm_set_preferred_mode(connector, 640, 480);
-		mutex_unlock(&connector->dev->mode_config.mutex);
-	} else {
-		/* always add fail-safe mode as backup mode */
-		mutex_lock(&connector->dev->mode_config.mutex);
-		drm_add_modes_noedid(connector, 640, 480);
-		mutex_unlock(&connector->dev->mode_config.mutex);
+		dp_panel_add_fail_safe_mode(connector);
 	}
 
 	if (panel->aux_cfg_update_done) {
diff --git a/drivers/gpu/drm/msm/dp/dp_panel.h b/drivers/gpu/drm/msm/dp/dp_panel.h
index 9023e5bb4b8b..99739ea679a7 100644
--- a/drivers/gpu/drm/msm/dp/dp_panel.h
+++ b/drivers/gpu/drm/msm/dp/dp_panel.h
@@ -59,6 +59,7 @@ int dp_panel_init_panel_info(struct dp_panel *dp_panel);
 int dp_panel_deinit(struct dp_panel *dp_panel);
 int dp_panel_timing_cfg(struct dp_panel *dp_panel);
 void dp_panel_dump_regs(struct dp_panel *dp_panel);
+void dp_panel_add_fail_safe_mode(struct drm_connector *connector);
 int dp_panel_read_sink_caps(struct dp_panel *dp_panel,
 		struct drm_connector *connector);
 u32 dp_panel_get_mode_bpp(struct dp_panel *dp_panel, u32 mode_max_bpp,
diff --git a/drivers/gpu/drm/msm/dsi/dsi_manager.c b/drivers/gpu/drm/msm/dsi/dsi_manager.c
index fa4c396df6a9..6e43672f5807 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_manager.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_manager.c
@@ -643,7 +643,7 @@ struct drm_connector *msm_dsi_manager_connector_init(u8 id)
 	return connector;
 
 fail:
-	connector->funcs->destroy(msm_dsi->connector);
+	connector->funcs->destroy(connector);
 	return ERR_PTR(ret);
 }
 
diff --git a/drivers/gpu/drm/msm/msm_gem.c b/drivers/gpu/drm/msm/msm_gem.c
index cb52ac01e512..d280dd64744d 100644
--- a/drivers/gpu/drm/msm/msm_gem.c
+++ b/drivers/gpu/drm/msm/msm_gem.c
@@ -937,6 +937,7 @@ void msm_gem_describe(struct drm_gem_object *obj, struct seq_file *m,
 					get_pid_task(aspace->pid, PIDTYPE_PID);
 				if (task) {
 					comm = kstrdup(task->comm, GFP_KERNEL);
+					put_task_struct(task);
 				} else {
 					comm = NULL;
 				}
diff --git a/drivers/gpu/ipu-v3/ipu-di.c b/drivers/gpu/ipu-v3/ipu-di.c
index 666223c6bec4..0a34e0ab4fe6 100644
--- a/drivers/gpu/ipu-v3/ipu-di.c
+++ b/drivers/gpu/ipu-v3/ipu-di.c
@@ -447,8 +447,9 @@ static void ipu_di_config_clock(struct ipu_di *di,
 
 		error = rate / (sig->mode.pixelclock / 1000);
 
-		dev_dbg(di->ipu->dev, "  IPU clock can give %lu with divider %u, error %d.%u%%\n",
-			rate, div, (signed)(error - 1000) / 10, error % 10);
+		dev_dbg(di->ipu->dev, "  IPU clock can give %lu with divider %u, error %c%d.%d%%\n",
+			rate, div, error < 1000 ? '-' : '+',
+			abs(error - 1000) / 10, abs(error - 1000) % 10);
 
 		/* Allow a 1% error */
 		if (error < 1010 && error >= 990) {
diff --git a/drivers/hv/hv_balloon.c b/drivers/hv/hv_balloon.c
index 439f99b8b5de..3cf334c46c31 100644
--- a/drivers/hv/hv_balloon.c
+++ b/drivers/hv/hv_balloon.c
@@ -1653,6 +1653,38 @@ static void disable_page_reporting(void)
 	}
 }
 
+static int ballooning_enabled(void)
+{
+	/*
+	 * Disable ballooning if the page size is not 4k (HV_HYP_PAGE_SIZE),
+	 * since currently it's unclear to us whether an unballoon request can
+	 * make sure all page ranges are guest page size aligned.
+	 */
+	if (PAGE_SIZE != HV_HYP_PAGE_SIZE) {
+		pr_info("Ballooning disabled because page size is not 4096 bytes\n");
+		return 0;
+	}
+
+	return 1;
+}
+
+static int hot_add_enabled(void)
+{
+	/*
+	 * Disable hot add on ARM64, because we currently rely on
+	 * memory_add_physaddr_to_nid() to get a node id of a hot add range,
+	 * however ARM64's memory_add_physaddr_to_nid() always return 0 and
+	 * DM_MEM_HOT_ADD_REQUEST doesn't have the NUMA node information for
+	 * add_memory().
+	 */
+	if (IS_ENABLED(CONFIG_ARM64)) {
+		pr_info("Memory hot add disabled on ARM64\n");
+		return 0;
+	}
+
+	return 1;
+}
+
 static int balloon_connect_vsp(struct hv_device *dev)
 {
 	struct dm_version_request version_req;
@@ -1724,8 +1756,8 @@ static int balloon_connect_vsp(struct hv_device *dev)
 	 * currently still requires the bits to be set, so we have to add code
 	 * to fail the host's hot-add and balloon up/down requests, if any.
 	 */
-	cap_msg.caps.cap_bits.balloon = 1;
-	cap_msg.caps.cap_bits.hot_add = 1;
+	cap_msg.caps.cap_bits.balloon = ballooning_enabled();
+	cap_msg.caps.cap_bits.hot_add = hot_add_enabled();
 
 	/*
 	 * Specify our alignment requirements as it relates
diff --git a/drivers/hv/ring_buffer.c b/drivers/hv/ring_buffer.c
index 314015d9e912..f4091143213b 100644
--- a/drivers/hv/ring_buffer.c
+++ b/drivers/hv/ring_buffer.c
@@ -408,7 +408,16 @@ int hv_ringbuffer_read(struct vmbus_channel *channel,
 static u32 hv_pkt_iter_avail(const struct hv_ring_buffer_info *rbi)
 {
 	u32 priv_read_loc = rbi->priv_read_index;
-	u32 write_loc = READ_ONCE(rbi->ring_buffer->write_index);
+	u32 write_loc;
+
+	/*
+	 * The Hyper-V host writes the packet data, then uses
+	 * store_release() to update the write_index.  Use load_acquire()
+	 * here to prevent loads of the packet data from being re-ordered
+	 * before the read of the write_index and potentially getting
+	 * stale data.
+	 */
+	write_loc = virt_load_acquire(&rbi->ring_buffer->write_index);
 
 	if (write_loc >= priv_read_loc)
 		return write_loc - priv_read_loc;
diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index a939ca1a8d54..aea8125a4db8 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -76,8 +76,8 @@ static int hyperv_panic_event(struct notifier_block *nb, unsigned long val,
 
 	/*
 	 * Hyper-V should be notified only once about a panic.  If we will be
-	 * doing hyperv_report_panic_msg() later with kmsg data, don't do
-	 * the notification here.
+	 * doing hv_kmsg_dump() with kmsg data later, don't do the notification
+	 * here.
 	 */
 	if (ms_hyperv.misc_features & HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE
 	    && hyperv_report_reg()) {
@@ -99,8 +99,8 @@ static int hyperv_die_event(struct notifier_block *nb, unsigned long val,
 
 	/*
 	 * Hyper-V should be notified only once about a panic.  If we will be
-	 * doing hyperv_report_panic_msg() later with kmsg data, don't do
-	 * the notification here.
+	 * doing hv_kmsg_dump() with kmsg data later, don't do the notification
+	 * here.
 	 */
 	if (hyperv_report_reg())
 		hyperv_report_panic(regs, val, true);
@@ -1545,14 +1545,20 @@ static int vmbus_bus_init(void)
 	if (ret)
 		goto err_connect;
 
+	if (hv_is_isolation_supported())
+		sysctl_record_panic_msg = 0;
+
 	/*
 	 * Only register if the crash MSRs are available
 	 */
 	if (ms_hyperv.misc_features & HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE) {
 		u64 hyperv_crash_ctl;
 		/*
-		 * Sysctl registration is not fatal, since by default
-		 * reporting is enabled.
+		 * Panic message recording (sysctl_record_panic_msg)
+		 * is enabled by default in non-isolated guests and
+		 * disabled by default in isolated guests; the panic
+		 * message recording won't be available in isolated
+		 * guests should the following registration fail.
 		 */
 		hv_ctl_table_hdr = register_sysctl_table(hv_root_table);
 		if (!hv_ctl_table_hdr)
diff --git a/drivers/i2c/busses/i2c-pasemi.c b/drivers/i2c/busses/i2c-pasemi.c
index 20f2772c0e79..2c909522f0f3 100644
--- a/drivers/i2c/busses/i2c-pasemi.c
+++ b/drivers/i2c/busses/i2c-pasemi.c
@@ -137,6 +137,12 @@ static int pasemi_i2c_xfer_msg(struct i2c_adapter *adapter,
 
 		TXFIFO_WR(smbus, msg->buf[msg->len-1] |
 			  (stop ? MTXFIFO_STOP : 0));
+
+		if (stop) {
+			err = pasemi_smb_waitready(smbus);
+			if (err)
+				goto reset_out;
+		}
 	}
 
 	return 0;
diff --git a/drivers/i2c/i2c-dev.c b/drivers/i2c/i2c-dev.c
index cf5d049342ea..6fd2b6718b08 100644
--- a/drivers/i2c/i2c-dev.c
+++ b/drivers/i2c/i2c-dev.c
@@ -668,16 +668,21 @@ static int i2cdev_attach_adapter(struct device *dev, void *dummy)
 	i2c_dev->dev.class = i2c_dev_class;
 	i2c_dev->dev.parent = &adap->dev;
 	i2c_dev->dev.release = i2cdev_dev_release;
-	dev_set_name(&i2c_dev->dev, "i2c-%d", adap->nr);
+
+	res = dev_set_name(&i2c_dev->dev, "i2c-%d", adap->nr);
+	if (res)
+		goto err_put_i2c_dev;
 
 	res = cdev_device_add(&i2c_dev->cdev, &i2c_dev->dev);
-	if (res) {
-		put_i2c_dev(i2c_dev, false);
-		return res;
-	}
+	if (res)
+		goto err_put_i2c_dev;
 
 	pr_debug("adapter [%s] registered as minor %d\n", adap->name, adap->nr);
 	return 0;
+
+err_put_i2c_dev:
+	put_i2c_dev(i2c_dev, false);
+	return res;
 }
 
 static int i2cdev_detach_adapter(struct device *dev, void *dummy)
diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 32b9125337fb..e2a51c184a25 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -4383,6 +4383,7 @@ static int dm_integrity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	}
 
 	if (ic->internal_hash) {
+		size_t recalc_tags_size;
 		ic->recalc_wq = alloc_workqueue("dm-integrity-recalc", WQ_MEM_RECLAIM, 1);
 		if (!ic->recalc_wq ) {
 			ti->error = "Cannot allocate workqueue";
@@ -4396,8 +4397,10 @@ static int dm_integrity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 			r = -ENOMEM;
 			goto bad;
 		}
-		ic->recalc_tags = kvmalloc_array(RECALC_SECTORS >> ic->sb->log2_sectors_per_block,
-						 ic->tag_size, GFP_KERNEL);
+		recalc_tags_size = (RECALC_SECTORS >> ic->sb->log2_sectors_per_block) * ic->tag_size;
+		if (crypto_shash_digestsize(ic->internal_hash) > ic->tag_size)
+			recalc_tags_size += crypto_shash_digestsize(ic->internal_hash) - ic->tag_size;
+		ic->recalc_tags = kvmalloc(recalc_tags_size, GFP_KERNEL);
 		if (!ic->recalc_tags) {
 			ti->error = "Cannot allocate tags for recalculating";
 			r = -ENOMEM;
diff --git a/drivers/md/dm-ps-historical-service-time.c b/drivers/md/dm-ps-historical-service-time.c
index 1856a1b125cc..82f2a06153dc 100644
--- a/drivers/md/dm-ps-historical-service-time.c
+++ b/drivers/md/dm-ps-historical-service-time.c
@@ -432,7 +432,7 @@ static struct dm_path *hst_select_path(struct path_selector *ps,
 {
 	struct selector *s = ps->context;
 	struct path_info *pi = NULL, *best = NULL;
-	u64 time_now = sched_clock();
+	u64 time_now = ktime_get_ns();
 	struct dm_path *ret = NULL;
 	unsigned long flags;
 
@@ -473,7 +473,7 @@ static int hst_start_io(struct path_selector *ps, struct dm_path *path,
 
 static u64 path_service_time(struct path_info *pi, u64 start_time)
 {
-	u64 sched_now = ktime_get_ns();
+	u64 now = ktime_get_ns();
 
 	/* if a previous disk request has finished after this IO was
 	 * sent to the hardware, pretend the submission happened
@@ -482,11 +482,11 @@ static u64 path_service_time(struct path_info *pi, u64 start_time)
 	if (time_after64(pi->last_finish, start_time))
 		start_time = pi->last_finish;
 
-	pi->last_finish = sched_now;
-	if (time_before64(sched_now, start_time))
+	pi->last_finish = now;
+	if (time_before64(now, start_time))
 		return 0;
 
-	return sched_now - start_time;
+	return now - start_time;
 }
 
 static int hst_end_io(struct path_selector *ps, struct dm_path *path,
diff --git a/drivers/media/platform/rockchip/rga/rga.c b/drivers/media/platform/rockchip/rga/rga.c
index 6759091b15e0..d99ea8973b67 100644
--- a/drivers/media/platform/rockchip/rga/rga.c
+++ b/drivers/media/platform/rockchip/rga/rga.c
@@ -895,7 +895,7 @@ static int rga_probe(struct platform_device *pdev)
 	}
 	rga->dst_mmu_pages =
 		(unsigned int *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, 3);
-	if (rga->dst_mmu_pages) {
+	if (!rga->dst_mmu_pages) {
 		ret = -ENOMEM;
 		goto free_src_pages;
 	}
diff --git a/drivers/memory/atmel-ebi.c b/drivers/memory/atmel-ebi.c
index c267283b01fd..e749dcb3ddea 100644
--- a/drivers/memory/atmel-ebi.c
+++ b/drivers/memory/atmel-ebi.c
@@ -544,20 +544,27 @@ static int atmel_ebi_probe(struct platform_device *pdev)
 	smc_np = of_parse_phandle(dev->of_node, "atmel,smc", 0);
 
 	ebi->smc.regmap = syscon_node_to_regmap(smc_np);
-	if (IS_ERR(ebi->smc.regmap))
-		return PTR_ERR(ebi->smc.regmap);
+	if (IS_ERR(ebi->smc.regmap)) {
+		ret = PTR_ERR(ebi->smc.regmap);
+		goto put_node;
+	}
 
 	ebi->smc.layout = atmel_hsmc_get_reg_layout(smc_np);
-	if (IS_ERR(ebi->smc.layout))
-		return PTR_ERR(ebi->smc.layout);
+	if (IS_ERR(ebi->smc.layout)) {
+		ret = PTR_ERR(ebi->smc.layout);
+		goto put_node;
+	}
 
 	ebi->smc.clk = of_clk_get(smc_np, 0);
 	if (IS_ERR(ebi->smc.clk)) {
-		if (PTR_ERR(ebi->smc.clk) != -ENOENT)
-			return PTR_ERR(ebi->smc.clk);
+		if (PTR_ERR(ebi->smc.clk) != -ENOENT) {
+			ret = PTR_ERR(ebi->smc.clk);
+			goto put_node;
+		}
 
 		ebi->smc.clk = NULL;
 	}
+	of_node_put(smc_np);
 	ret = clk_prepare_enable(ebi->smc.clk);
 	if (ret)
 		return ret;
@@ -608,6 +615,10 @@ static int atmel_ebi_probe(struct platform_device *pdev)
 	}
 
 	return of_platform_populate(np, NULL, NULL, dev);
+
+put_node:
+	of_node_put(smc_np);
+	return ret;
 }
 
 static __maybe_unused int atmel_ebi_resume(struct device *dev)
diff --git a/drivers/memory/renesas-rpc-if.c b/drivers/memory/renesas-rpc-if.c
index 861870223300..2a4c1f94bfa0 100644
--- a/drivers/memory/renesas-rpc-if.c
+++ b/drivers/memory/renesas-rpc-if.c
@@ -579,6 +579,7 @@ static int rpcif_probe(struct platform_device *pdev)
 	struct platform_device *vdev;
 	struct device_node *flash;
 	const char *name;
+	int ret;
 
 	flash = of_get_next_child(pdev->dev.of_node, NULL);
 	if (!flash) {
@@ -602,7 +603,14 @@ static int rpcif_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	vdev->dev.parent = &pdev->dev;
 	platform_set_drvdata(pdev, vdev);
-	return platform_device_add(vdev);
+
+	ret = platform_device_add(vdev);
+	if (ret) {
+		platform_device_put(vdev);
+		return ret;
+	}
+
+	return 0;
 }
 
 static int rpcif_remove(struct platform_device *pdev)
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index e53ad283e259..a9c7ada890d8 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1455,7 +1455,7 @@ static int felix_pci_probe(struct pci_dev *pdev,
 
 	err = dsa_register_switch(ds);
 	if (err) {
-		dev_err(&pdev->dev, "Failed to register DSA switch: %d\n", err);
+		dev_err_probe(&pdev->dev, err, "Failed to register DSA switch\n");
 		goto err_register_ds;
 	}
 
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 510e0cf64fa9..b4f99dd284e5 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -76,7 +76,7 @@ static inline void bcmgenet_writel(u32 value, void __iomem *offset)
 	if (IS_ENABLED(CONFIG_MIPS) && IS_ENABLED(CONFIG_CPU_BIG_ENDIAN))
 		__raw_writel(value, offset);
 	else
-		writel(value, offset);
+		writel_relaxed(value, offset);
 }
 
 static inline u32 bcmgenet_readl(void __iomem *offset)
@@ -84,7 +84,7 @@ static inline u32 bcmgenet_readl(void __iomem *offset)
 	if (IS_ENABLED(CONFIG_MIPS) && IS_ENABLED(CONFIG_CPU_BIG_ENDIAN))
 		return __raw_readl(offset);
 	else
-		return readl(offset);
+		return readl_relaxed(offset);
 }
 
 static inline void dmadesc_set_length_status(struct bcmgenet_priv *priv,
diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
index ff76e401a014..e1df2dc810a2 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -1817,11 +1817,6 @@ static int ftgmac100_probe(struct platform_device *pdev)
 		priv->rxdes0_edorr_mask = BIT(30);
 		priv->txdes0_edotr_mask = BIT(30);
 		priv->is_aspeed = true;
-		/* Disable ast2600 problematic HW arbitration */
-		if (of_device_is_compatible(np, "aspeed,ast2600-mac")) {
-			iowrite32(FTGMAC100_TM_DEFAULT,
-				  priv->base + FTGMAC100_OFFSET_TM);
-		}
 	} else {
 		priv->rxdes0_edorr_mask = BIT(15);
 		priv->txdes0_edotr_mask = BIT(15);
@@ -1893,6 +1888,11 @@ static int ftgmac100_probe(struct platform_device *pdev)
 		err = ftgmac100_setup_clk(priv);
 		if (err)
 			goto err_phy_connect;
+
+		/* Disable ast2600 problematic HW arbitration */
+		if (of_device_is_compatible(np, "aspeed,ast2600-mac"))
+			iowrite32(FTGMAC100_TM_DEFAULT,
+				  priv->base + FTGMAC100_OFFSET_TM);
 	}
 
 	/* Default ring sizes */
diff --git a/drivers/net/ethernet/mellanox/mlxsw/i2c.c b/drivers/net/ethernet/mellanox/mlxsw/i2c.c
index 939b692ffc33..ce843ea91464 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/i2c.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/i2c.c
@@ -650,6 +650,7 @@ static int mlxsw_i2c_probe(struct i2c_client *client,
 	return 0;
 
 errout:
+	mutex_destroy(&mlxsw_i2c->cmd.lock);
 	i2c_set_clientdata(client, NULL);
 
 	return err;
diff --git a/drivers/net/ethernet/micrel/Kconfig b/drivers/net/ethernet/micrel/Kconfig
index 93df3049cdc0..1b632cdd7630 100644
--- a/drivers/net/ethernet/micrel/Kconfig
+++ b/drivers/net/ethernet/micrel/Kconfig
@@ -39,6 +39,7 @@ config KS8851
 config KS8851_MLL
 	tristate "Micrel KS8851 MLL"
 	depends on HAS_IOMEM
+	depends on PTP_1588_CLOCK_OPTIONAL
 	select MII
 	select CRC32
 	select EEPROM_93CX6
diff --git a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
index c1a75b08ced7..052696ce5096 100644
--- a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
+++ b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
@@ -2900,11 +2900,9 @@ static netdev_tx_t myri10ge_sw_tso(struct sk_buff *skb,
 		status = myri10ge_xmit(curr, dev);
 		if (status != 0) {
 			dev_kfree_skb_any(curr);
-			if (segs != NULL) {
-				curr = segs;
-				segs = next;
+			skb_list_walk_safe(next, curr, next) {
 				curr->next = NULL;
-				dev_kfree_skb_any(segs);
+				dev_kfree_skb_any(curr);
 			}
 			goto drop;
 		}
diff --git a/drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.c b/drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.c
index cd478d2cd871..00f6d347eaf7 100644
--- a/drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.c
+++ b/drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.c
@@ -57,10 +57,6 @@
 #define TSE_PCS_USE_SGMII_ENA				BIT(0)
 #define TSE_PCS_IF_USE_SGMII				0x03
 
-#define SGMII_ADAPTER_CTRL_REG				0x00
-#define SGMII_ADAPTER_DISABLE				0x0001
-#define SGMII_ADAPTER_ENABLE				0x0000
-
 #define AUTONEGO_LINK_TIMER				20
 
 static int tse_pcs_reset(void __iomem *base, struct tse_pcs *pcs)
@@ -202,12 +198,8 @@ void tse_pcs_fix_mac_speed(struct tse_pcs *pcs, struct phy_device *phy_dev,
 			   unsigned int speed)
 {
 	void __iomem *tse_pcs_base = pcs->tse_pcs_base;
-	void __iomem *sgmii_adapter_base = pcs->sgmii_adapter_base;
 	u32 val;
 
-	writew(SGMII_ADAPTER_ENABLE,
-	       sgmii_adapter_base + SGMII_ADAPTER_CTRL_REG);
-
 	pcs->autoneg = phy_dev->autoneg;
 
 	if (phy_dev->autoneg == AUTONEG_ENABLE) {
diff --git a/drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.h b/drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.h
index 442812c0a4bd..694ac25ef426 100644
--- a/drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.h
+++ b/drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.h
@@ -10,6 +10,10 @@
 #include <linux/phy.h>
 #include <linux/timer.h>
 
+#define SGMII_ADAPTER_CTRL_REG		0x00
+#define SGMII_ADAPTER_ENABLE		0x0000
+#define SGMII_ADAPTER_DISABLE		0x0001
+
 struct tse_pcs {
 	struct device *dev;
 	void __iomem *tse_pcs_base;
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
index b7c2579c963b..ac9e6c7a33b5 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
@@ -18,9 +18,6 @@
 
 #include "altr_tse_pcs.h"
 
-#define SGMII_ADAPTER_CTRL_REG                          0x00
-#define SGMII_ADAPTER_DISABLE                           0x0001
-
 #define SYSMGR_EMACGRP_CTRL_PHYSEL_ENUM_GMII_MII 0x0
 #define SYSMGR_EMACGRP_CTRL_PHYSEL_ENUM_RGMII 0x1
 #define SYSMGR_EMACGRP_CTRL_PHYSEL_ENUM_RMII 0x2
@@ -62,16 +59,14 @@ static void socfpga_dwmac_fix_mac_speed(void *priv, unsigned int speed)
 {
 	struct socfpga_dwmac *dwmac = (struct socfpga_dwmac *)priv;
 	void __iomem *splitter_base = dwmac->splitter_base;
-	void __iomem *tse_pcs_base = dwmac->pcs.tse_pcs_base;
 	void __iomem *sgmii_adapter_base = dwmac->pcs.sgmii_adapter_base;
 	struct device *dev = dwmac->dev;
 	struct net_device *ndev = dev_get_drvdata(dev);
 	struct phy_device *phy_dev = ndev->phydev;
 	u32 val;
 
-	if ((tse_pcs_base) && (sgmii_adapter_base))
-		writew(SGMII_ADAPTER_DISABLE,
-		       sgmii_adapter_base + SGMII_ADAPTER_CTRL_REG);
+	writew(SGMII_ADAPTER_DISABLE,
+	       sgmii_adapter_base + SGMII_ADAPTER_CTRL_REG);
 
 	if (splitter_base) {
 		val = readl(splitter_base + EMAC_SPLITTER_CTRL_REG);
@@ -93,7 +88,9 @@ static void socfpga_dwmac_fix_mac_speed(void *priv, unsigned int speed)
 		writel(val, splitter_base + EMAC_SPLITTER_CTRL_REG);
 	}
 
-	if (tse_pcs_base && sgmii_adapter_base)
+	writew(SGMII_ADAPTER_ENABLE,
+	       sgmii_adapter_base + SGMII_ADAPTER_CTRL_REG);
+	if (phy_dev)
 		tse_pcs_fix_mac_speed(&dwmac->pcs, phy_dev, speed);
 }
 
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 80637ffcca93..fbbbcfe0e891 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -2127,15 +2127,14 @@ static int axienet_probe(struct platform_device *pdev)
 	if (ret)
 		goto cleanup_clk;
 
-	lp->phy_node = of_parse_phandle(pdev->dev.of_node, "phy-handle", 0);
-	if (lp->phy_node) {
-		ret = axienet_mdio_setup(lp);
-		if (ret)
-			dev_warn(&pdev->dev,
-				 "error registering MDIO bus: %d\n", ret);
-	}
+	ret = axienet_mdio_setup(lp);
+	if (ret)
+		dev_warn(&pdev->dev,
+			 "error registering MDIO bus: %d\n", ret);
+
 	if (lp->phy_mode == PHY_INTERFACE_MODE_SGMII ||
 	    lp->phy_mode == PHY_INTERFACE_MODE_1000BASEX) {
+		lp->phy_node = of_parse_phandle(pdev->dev.of_node, "phy-handle", 0);
 		if (!lp->phy_node) {
 			dev_err(&pdev->dev, "phy-handle required for 1000BaseX/SGMII\n");
 			ret = -EINVAL;
diff --git a/drivers/net/hamradio/6pack.c b/drivers/net/hamradio/6pack.c
index 4650ca28a516..36a9fbb70402 100644
--- a/drivers/net/hamradio/6pack.c
+++ b/drivers/net/hamradio/6pack.c
@@ -306,7 +306,6 @@ static void sp_setup(struct net_device *dev)
 {
 	/* Finish setting up the DEVICE info. */
 	dev->netdev_ops		= &sp_netdev_ops;
-	dev->needs_free_netdev	= true;
 	dev->mtu		= SIXP_MTU;
 	dev->hard_header_len	= AX25_MAX_HEADER_LEN;
 	dev->header_ops 	= &ax25_header_ops;
@@ -674,9 +673,11 @@ static void sixpack_close(struct tty_struct *tty)
 	del_timer_sync(&sp->tx_t);
 	del_timer_sync(&sp->resync_t);
 
-	/* Free all 6pack frame buffers. */
+	/* Free all 6pack frame buffers after unreg. */
 	kfree(sp->rbuff);
 	kfree(sp->xbuff);
+
+	free_netdev(sp->dev);
 }
 
 /* Perform I/O control on an active 6pack channel. */
diff --git a/drivers/net/ipa/Kconfig b/drivers/net/ipa/Kconfig
index 3e0da1e76471..6782c2cbf542 100644
--- a/drivers/net/ipa/Kconfig
+++ b/drivers/net/ipa/Kconfig
@@ -4,6 +4,7 @@ config QCOM_IPA
 	depends on ARCH_QCOM || COMPILE_TEST
 	depends on INTERCONNECT
 	depends on QCOM_RPROC_COMMON || (QCOM_RPROC_COMMON=n && COMPILE_TEST)
+	depends on QCOM_AOSS_QMP || QCOM_AOSS_QMP=n
 	select QCOM_MDT_LOADER if ARCH_QCOM
 	select QCOM_SCM
 	select QCOM_QMI_HELPERS
diff --git a/drivers/net/ipa/ipa_power.c b/drivers/net/ipa/ipa_power.c
index b1c6c0fcb654..f2989aac47a6 100644
--- a/drivers/net/ipa/ipa_power.c
+++ b/drivers/net/ipa/ipa_power.c
@@ -11,6 +11,8 @@
 #include <linux/pm_runtime.h>
 #include <linux/bitops.h>
 
+#include "linux/soc/qcom/qcom_aoss.h"
+
 #include "ipa.h"
 #include "ipa_power.h"
 #include "ipa_endpoint.h"
@@ -64,6 +66,7 @@ enum ipa_power_flag {
  * struct ipa_power - IPA power management information
  * @dev:		IPA device pointer
  * @core:		IPA core clock
+ * @qmp:		QMP handle for AOSS communication
  * @spinlock:		Protects modem TX queue enable/disable
  * @flags:		Boolean state flags
  * @interconnect_count:	Number of elements in interconnect[]
@@ -72,6 +75,7 @@ enum ipa_power_flag {
 struct ipa_power {
 	struct device *dev;
 	struct clk *core;
+	struct qmp *qmp;
 	spinlock_t spinlock;	/* used with STOPPED/STARTED power flags */
 	DECLARE_BITMAP(flags, IPA_POWER_FLAG_COUNT);
 	u32 interconnect_count;
@@ -382,6 +386,47 @@ void ipa_power_modem_queue_active(struct ipa *ipa)
 	clear_bit(IPA_POWER_FLAG_STARTED, ipa->power->flags);
 }
 
+static int ipa_power_retention_init(struct ipa_power *power)
+{
+	struct qmp *qmp = qmp_get(power->dev);
+
+	if (IS_ERR(qmp)) {
+		if (PTR_ERR(qmp) == -EPROBE_DEFER)
+			return -EPROBE_DEFER;
+
+		/* We assume any other error means it's not defined/needed */
+		qmp = NULL;
+	}
+	power->qmp = qmp;
+
+	return 0;
+}
+
+static void ipa_power_retention_exit(struct ipa_power *power)
+{
+	qmp_put(power->qmp);
+	power->qmp = NULL;
+}
+
+/* Control register retention on power collapse */
+void ipa_power_retention(struct ipa *ipa, bool enable)
+{
+	static const char fmt[] = "{ class: bcm, res: ipa_pc, val: %c }";
+	struct ipa_power *power = ipa->power;
+	char buf[36];	/* Exactly enough for fmt[]; size a multiple of 4 */
+	int ret;
+
+	if (!power->qmp)
+		return;		/* Not needed on this platform */
+
+	(void)snprintf(buf, sizeof(buf), fmt, enable ? '1' : '0');
+
+	ret = qmp_send(power->qmp, buf, sizeof(buf));
+	if (ret)
+		dev_err(power->dev, "error %d sending QMP %sable request\n",
+			ret, enable ? "en" : "dis");
+}
+
 int ipa_power_setup(struct ipa *ipa)
 {
 	int ret;
@@ -438,12 +483,18 @@ ipa_power_init(struct device *dev, const struct ipa_power_data *data)
 	if (ret)
 		goto err_kfree;
 
+	ret = ipa_power_retention_init(power);
+	if (ret)
+		goto err_interconnect_exit;
+
 	pm_runtime_set_autosuspend_delay(dev, IPA_AUTOSUSPEND_DELAY);
 	pm_runtime_use_autosuspend(dev);
 	pm_runtime_enable(dev);
 
 	return power;
 
+err_interconnect_exit:
+	ipa_interconnect_exit(power);
 err_kfree:
 	kfree(power);
 err_clk_put:
@@ -460,6 +511,7 @@ void ipa_power_exit(struct ipa_power *power)
 
 	pm_runtime_disable(dev);
 	pm_runtime_dont_use_autosuspend(dev);
+	ipa_power_retention_exit(power);
 	ipa_interconnect_exit(power);
 	kfree(power);
 	clk_put(clk);
diff --git a/drivers/net/ipa/ipa_power.h b/drivers/net/ipa/ipa_power.h
index 2151805d7fbb..6f84f057a209 100644
--- a/drivers/net/ipa/ipa_power.h
+++ b/drivers/net/ipa/ipa_power.h
@@ -40,6 +40,13 @@ void ipa_power_modem_queue_wake(struct ipa *ipa);
  */
 void ipa_power_modem_queue_active(struct ipa *ipa);
 
+/**
+ * ipa_power_retention() - Control register retention on power collapse
+ * @ipa:	IPA pointer
+ * @enable:	Whether retention should be enabled or disabled
+ */
+void ipa_power_retention(struct ipa *ipa, bool enable);
+
 /**
  * ipa_power_setup() - Set up IPA power management
  * @ipa:	IPA pointer
diff --git a/drivers/net/ipa/ipa_uc.c b/drivers/net/ipa/ipa_uc.c
index 856e55a080a7..fe11910518d9 100644
--- a/drivers/net/ipa/ipa_uc.c
+++ b/drivers/net/ipa/ipa_uc.c
@@ -11,6 +11,7 @@
 
 #include "ipa.h"
 #include "ipa_uc.h"
+#include "ipa_power.h"
 
 /**
  * DOC:  The IPA embedded microcontroller
@@ -154,6 +155,7 @@ static void ipa_uc_response_hdlr(struct ipa *ipa, enum ipa_irq_id irq_id)
 	case IPA_UC_RESPONSE_INIT_COMPLETED:
 		if (ipa->uc_powered) {
 			ipa->uc_loaded = true;
+			ipa_power_retention(ipa, true);
 			pm_runtime_mark_last_busy(dev);
 			(void)pm_runtime_put_autosuspend(dev);
 			ipa->uc_powered = false;
@@ -184,6 +186,9 @@ void ipa_uc_deconfig(struct ipa *ipa)
 
 	ipa_interrupt_remove(ipa->interrupt, IPA_IRQ_UC_1);
 	ipa_interrupt_remove(ipa->interrupt, IPA_IRQ_UC_0);
+	if (ipa->uc_loaded)
+		ipa_power_retention(ipa, false);
+
 	if (!ipa->uc_powered)
 		return;
 
diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 35f46ad040b0..a9a515cf5a46 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -460,8 +460,10 @@ static rx_handler_result_t macvlan_handle_frame(struct sk_buff **pskb)
 			return RX_HANDLER_CONSUMED;
 		*pskb = skb;
 		eth = eth_hdr(skb);
-		if (macvlan_forward_source(skb, port, eth->h_source))
+		if (macvlan_forward_source(skb, port, eth->h_source)) {
+			kfree_skb(skb);
 			return RX_HANDLER_CONSUMED;
+		}
 		src = macvlan_hash_lookup(port, eth->h_source);
 		if (src && src->mode != MACVLAN_MODE_VEPA &&
 		    src->mode != MACVLAN_MODE_BRIDGE) {
@@ -480,8 +482,10 @@ static rx_handler_result_t macvlan_handle_frame(struct sk_buff **pskb)
 		return RX_HANDLER_PASS;
 	}
 
-	if (macvlan_forward_source(skb, port, eth->h_source))
+	if (macvlan_forward_source(skb, port, eth->h_source)) {
+		kfree_skb(skb);
 		return RX_HANDLER_CONSUMED;
+	}
 	if (macvlan_passthru(port))
 		vlan = list_first_or_null_rcu(&port->vlans,
 					      struct macvlan_dev, list);
diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdio.c
index 1becb1a731f6..1c1584fca632 100644
--- a/drivers/net/mdio/fwnode_mdio.c
+++ b/drivers/net/mdio/fwnode_mdio.c
@@ -43,6 +43,11 @@ int fwnode_mdiobus_phy_device_register(struct mii_bus *mdio,
 	int rc;
 
 	rc = fwnode_irq_get(child, 0);
+	/* Don't wait forever if the IRQ provider doesn't become available,
+	 * just fall back to poll mode
+	 */
+	if (rc == -EPROBE_DEFER)
+		rc = driver_deferred_probe_check_state(&phy->mdio.dev);
 	if (rc == -EPROBE_DEFER)
 		return rc;
 
diff --git a/drivers/net/slip/slip.c b/drivers/net/slip/slip.c
index 5435b5689ce6..2a3892528ec3 100644
--- a/drivers/net/slip/slip.c
+++ b/drivers/net/slip/slip.c
@@ -469,7 +469,7 @@ static void sl_tx_timeout(struct net_device *dev, unsigned int txqueue)
 	spin_lock(&sl->lock);
 
 	if (netif_queue_stopped(dev)) {
-		if (!netif_running(dev))
+		if (!netif_running(dev) || !sl->tty)
 			goto out;
 
 		/* May be we must check transmitter timeout here ?
diff --git a/drivers/net/usb/aqc111.c b/drivers/net/usb/aqc111.c
index 73b97f4cc1ec..e8d49886d695 100644
--- a/drivers/net/usb/aqc111.c
+++ b/drivers/net/usb/aqc111.c
@@ -1102,10 +1102,15 @@ static int aqc111_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 	if (start_of_descs != desc_offset)
 		goto err;
 
-	/* self check desc_offset from header*/
-	if (desc_offset >= skb_len)
+	/* self check desc_offset from header and make sure that the
+	 * bounds of the metadata array are inside the SKB
+	 */
+	if (pkt_count * 2 + desc_offset >= skb_len)
 		goto err;
 
+	/* Packets must not overlap the metadata array */
+	skb_trim(skb, desc_offset);
+
 	if (pkt_count == 0)
 		goto err;
 
diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index f478fe7e2b82..64fa8e9c0a22 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -327,7 +327,7 @@ static netdev_tx_t veth_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	rcu_read_lock();
 	rcv = rcu_dereference(priv->peer);
-	if (unlikely(!rcv)) {
+	if (unlikely(!rcv) || !pskb_may_pull(skb, ETH_HLEN)) {
 		kfree_skb(skb);
 		goto drop;
 	}
diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 3834be158705..07004564a3ec 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -2156,6 +2156,19 @@ static void ath11k_mac_op_bss_info_changed(struct ieee80211_hw *hw,
 		if (ret)
 			ath11k_warn(ar->ab, "failed to update bcn template: %d\n",
 				    ret);
+		if (vif->bss_conf.he_support) {
+			ret = ath11k_wmi_vdev_set_param_cmd(ar, arvif->vdev_id,
+							    WMI_VDEV_PARAM_BA_MODE,
+							    WMI_BA_MODE_BUFFER_SIZE_256);
+			if (ret)
+				ath11k_warn(ar->ab,
+					    "failed to set BA BUFFER SIZE 256 for vdev: %d\n",
+					    arvif->vdev_id);
+			else
+				ath11k_dbg(ar->ab, ATH11K_DBG_MAC,
+					   "Set BA BUFFER SIZE 256 for VDEV: %d\n",
+					   arvif->vdev_id);
+		}
 	}
 
 	if (changed & (BSS_CHANGED_BEACON_INFO | BSS_CHANGED_BEACON)) {
@@ -2191,14 +2204,6 @@ static void ath11k_mac_op_bss_info_changed(struct ieee80211_hw *hw,
 
 		if (arvif->is_up && vif->bss_conf.he_support &&
 		    vif->bss_conf.he_oper.params) {
-			ret = ath11k_wmi_vdev_set_param_cmd(ar, arvif->vdev_id,
-							    WMI_VDEV_PARAM_BA_MODE,
-							    WMI_BA_MODE_BUFFER_SIZE_256);
-			if (ret)
-				ath11k_warn(ar->ab,
-					    "failed to set BA BUFFER SIZE 256 for vdev: %d\n",
-					    arvif->vdev_id);
-
 			param_id = WMI_VDEV_PARAM_HEOPS_0_31;
 			param_value = vif->bss_conf.he_oper.params;
 			ret = ath11k_wmi_vdev_set_param_cmd(ar, arvif->vdev_id,
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 98090e40e1cf..e2791d45f5f5 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -839,7 +839,7 @@ static bool ath9k_txq_list_has_key(struct list_head *txq_list, u32 keyix)
 			continue;
 
 		txinfo = IEEE80211_SKB_CB(bf->bf_mpdu);
-		fi = (struct ath_frame_info *)&txinfo->rate_driver_data[0];
+		fi = (struct ath_frame_info *)&txinfo->status.status_driver_data[0];
 		if (fi->keyix == keyix)
 			return true;
 	}
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 5691bd6eb82c..6555abf02f18 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -141,8 +141,8 @@ static struct ath_frame_info *get_frame_info(struct sk_buff *skb)
 {
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 	BUILD_BUG_ON(sizeof(struct ath_frame_info) >
-		     sizeof(tx_info->rate_driver_data));
-	return (struct ath_frame_info *) &tx_info->rate_driver_data[0];
+		     sizeof(tx_info->status.status_driver_data));
+	return (struct ath_frame_info *) &tx_info->status.status_driver_data[0];
 }
 
 static void ath_send_bar(struct ath_atx_tid *tid, u16 seqno)
@@ -2501,6 +2501,16 @@ static void ath_tx_complete_buf(struct ath_softc *sc, struct ath_buf *bf,
 	spin_unlock_irqrestore(&sc->tx.txbuflock, flags);
 }
 
+static void ath_clear_tx_status(struct ieee80211_tx_info *tx_info)
+{
+	void *ptr = &tx_info->status;
+
+	memset(ptr + sizeof(tx_info->status.rates), 0,
+	       sizeof(tx_info->status) -
+	       sizeof(tx_info->status.rates) -
+	       sizeof(tx_info->status.status_driver_data));
+}
+
 static void ath_tx_rc_status(struct ath_softc *sc, struct ath_buf *bf,
 			     struct ath_tx_status *ts, int nframes, int nbad,
 			     int txok)
@@ -2512,6 +2522,8 @@ static void ath_tx_rc_status(struct ath_softc *sc, struct ath_buf *bf,
 	struct ath_hw *ah = sc->sc_ah;
 	u8 i, tx_rateindex;
 
+	ath_clear_tx_status(tx_info);
+
 	if (txok)
 		tx_info->status.ack_signal = ts->ts_rssi;
 
@@ -2526,6 +2538,13 @@ static void ath_tx_rc_status(struct ath_softc *sc, struct ath_buf *bf,
 	tx_info->status.ampdu_len = nframes;
 	tx_info->status.ampdu_ack_len = nframes - nbad;
 
+	tx_info->status.rates[tx_rateindex].count = ts->ts_longretry + 1;
+
+	for (i = tx_rateindex + 1; i < hw->max_rates; i++) {
+		tx_info->status.rates[i].count = 0;
+		tx_info->status.rates[i].idx = -1;
+	}
+
 	if ((ts->ts_status & ATH9K_TXERR_FILT) == 0 &&
 	    (tx_info->flags & IEEE80211_TX_CTL_NO_ACK) == 0) {
 		/*
@@ -2547,16 +2566,6 @@ static void ath_tx_rc_status(struct ath_softc *sc, struct ath_buf *bf,
 			tx_info->status.rates[tx_rateindex].count =
 				hw->max_rate_tries;
 	}
-
-	for (i = tx_rateindex + 1; i < hw->max_rates; i++) {
-		tx_info->status.rates[i].count = 0;
-		tx_info->status.rates[i].idx = -1;
-	}
-
-	tx_info->status.rates[tx_rateindex].count = ts->ts_longretry + 1;
-
-	/* we report airtime in ath_tx_count_airtime(), don't report twice */
-	tx_info->status.tx_time = 0;
 }
 
 static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controller/pci-hyperv.c
index 9dd4502d32a4..5b156c563e3a 100644
--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -3148,6 +3148,15 @@ static int hv_pci_probe(struct hv_device *hdev,
 	hbus->bridge->domain_nr = dom;
 #ifdef CONFIG_X86
 	hbus->sysdata.domain = dom;
+#elif defined(CONFIG_ARM64)
+	/*
+	 * Set the PCI bus parent to be the corresponding VMbus
+	 * device. Then the VMbus device will be assigned as the
+	 * ACPI companion in pcibios_root_bridge_prepare() and
+	 * pci_dma_configure() will propagate device coherence
+	 * information to devices created on the bus.
+	 */
+	hbus->sysdata.parent = hdev->device.parent;
 #endif
 
 	hbus->hdev = hdev;
diff --git a/drivers/perf/fsl_imx8_ddr_perf.c b/drivers/perf/fsl_imx8_ddr_perf.c
index 94ebc1ecace7..b1b2a55de77f 100644
--- a/drivers/perf/fsl_imx8_ddr_perf.c
+++ b/drivers/perf/fsl_imx8_ddr_perf.c
@@ -29,7 +29,7 @@
 #define CNTL_OVER_MASK		0xFFFFFFFE
 
 #define CNTL_CSV_SHIFT		24
-#define CNTL_CSV_MASK		(0xFF << CNTL_CSV_SHIFT)
+#define CNTL_CSV_MASK		(0xFFU << CNTL_CSV_SHIFT)
 
 #define EVENT_CYCLES_ID		0
 #define EVENT_CYCLES_COUNTER	0
diff --git a/drivers/regulator/wm8994-regulator.c b/drivers/regulator/wm8994-regulator.c
index cadea0344486..40befdd9dfa9 100644
--- a/drivers/regulator/wm8994-regulator.c
+++ b/drivers/regulator/wm8994-regulator.c
@@ -71,6 +71,35 @@ static const struct regulator_ops wm8994_ldo2_ops = {
 };
 
 static const struct regulator_desc wm8994_ldo_desc[] = {
+	{
+		.name = "LDO1",
+		.id = 1,
+		.type = REGULATOR_VOLTAGE,
+		.n_voltages = WM8994_LDO1_MAX_SELECTOR + 1,
+		.vsel_reg = WM8994_LDO_1,
+		.vsel_mask = WM8994_LDO1_VSEL_MASK,
+		.ops = &wm8994_ldo1_ops,
+		.min_uV = 2400000,
+		.uV_step = 100000,
+		.enable_time = 3000,
+		.off_on_delay = 36000,
+		.owner = THIS_MODULE,
+	},
+	{
+		.name = "LDO2",
+		.id = 2,
+		.type = REGULATOR_VOLTAGE,
+		.n_voltages = WM8994_LDO2_MAX_SELECTOR + 1,
+		.vsel_reg = WM8994_LDO_2,
+		.vsel_mask = WM8994_LDO2_VSEL_MASK,
+		.ops = &wm8994_ldo2_ops,
+		.enable_time = 3000,
+		.off_on_delay = 36000,
+		.owner = THIS_MODULE,
+	},
+};
+
+static const struct regulator_desc wm8958_ldo_desc[] = {
 	{
 		.name = "LDO1",
 		.id = 1,
@@ -172,9 +201,16 @@ static int wm8994_ldo_probe(struct platform_device *pdev)
 	 * regulator core and we need not worry about it on the
 	 * error path.
 	 */
-	ldo->regulator = devm_regulator_register(&pdev->dev,
-						 &wm8994_ldo_desc[id],
-						 &config);
+	if (ldo->wm8994->type == WM8994) {
+		ldo->regulator = devm_regulator_register(&pdev->dev,
+							 &wm8994_ldo_desc[id],
+							 &config);
+	} else {
+		ldo->regulator = devm_regulator_register(&pdev->dev,
+							 &wm8958_ldo_desc[id],
+							 &config);
+	}
+
 	if (IS_ERR(ldo->regulator)) {
 		ret = PTR_ERR(ldo->regulator);
 		dev_err(wm8994->dev, "Failed to register LDO%d: %d\n",
diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
index 10b6c6daaacd..d43bb18f58fd 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -36,7 +36,7 @@
 
 #define IBMVSCSIS_VERSION	"v0.2"
 
-#define	INITIAL_SRP_LIMIT	800
+#define	INITIAL_SRP_LIMIT	1024
 #define	DEFAULT_MAX_SECTORS	256
 #define MAX_TXU			1024 * 1024
 
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 3eebcae52784..16246526e4c1 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -15105,6 +15105,8 @@ lpfc_io_slot_reset_s4(struct pci_dev *pdev)
 	psli->sli_flag &= ~LPFC_SLI_ACTIVE;
 	spin_unlock_irq(&phba->hbalock);
 
+	/* Init cpu_map array */
+	lpfc_cpu_map_array_init(phba);
 	/* Configure and enable interrupt */
 	intr_mode = lpfc_sli4_enable_intr(phba, phba->intr_mode);
 	if (intr_mode == LPFC_INTR_ERROR) {
diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 7af2c23652b0..650210d2abb4 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -2558,6 +2558,9 @@ struct megasas_instance_template {
 #define MEGASAS_IS_LOGICAL(sdev)					\
 	((sdev->channel < MEGASAS_MAX_PD_CHANNELS) ? 0 : 1)
 
+#define MEGASAS_IS_LUN_VALID(sdev)					\
+	(((sdev)->lun == 0) ? 1 : 0)
+
 #define MEGASAS_DEV_INDEX(scp)						\
 	(((scp->device->channel % 2) * MEGASAS_MAX_DEV_PER_CHANNEL) +	\
 	scp->device->id)
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 39d8754e63ac..bb3f78013a13 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -2126,6 +2126,9 @@ static int megasas_slave_alloc(struct scsi_device *sdev)
 			goto scan_target;
 		}
 		return -ENXIO;
+	} else if (!MEGASAS_IS_LUN_VALID(sdev)) {
+		sdev_printk(KERN_INFO, sdev, "%s: invalid LUN\n", __func__);
+		return -ENXIO;
 	}
 
 scan_target:
@@ -2156,6 +2159,10 @@ static void megasas_slave_destroy(struct scsi_device *sdev)
 	instance = megasas_lookup_instance(sdev->host->host_no);
 
 	if (MEGASAS_IS_LOGICAL(sdev)) {
+		if (!MEGASAS_IS_LUN_VALID(sdev)) {
+			sdev_printk(KERN_INFO, sdev, "%s: invalid LUN\n", __func__);
+			return;
+		}
 		ld_tgt_id = MEGASAS_TARGET_ID(sdev);
 		instance->ld_tgtid_status[ld_tgt_id] = LD_TARGET_ID_DELETED;
 		if (megasas_dbg_lvl & LD_PD_DEBUG)
diff --git a/drivers/scsi/mpt3sas/mpt3sas_config.c b/drivers/scsi/mpt3sas/mpt3sas_config.c
index 0563078227de..a8dd14c91efd 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_config.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_config.c
@@ -394,10 +394,13 @@ _config_request(struct MPT3SAS_ADAPTER *ioc, Mpi2ConfigRequest_t
 		retry_count++;
 		if (ioc->config_cmds.smid == smid)
 			mpt3sas_base_free_smid(ioc, smid);
-		if ((ioc->shost_recovery) || (ioc->config_cmds.status &
-		    MPT3_CMD_RESET) || ioc->pci_error_recovery)
+		if (ioc->config_cmds.status & MPT3_CMD_RESET)
 			goto retry_config;
-		issue_host_reset = 1;
+		if (ioc->shost_recovery || ioc->pci_error_recovery) {
+			issue_host_reset = 0;
+			r = -EFAULT;
+		} else
+			issue_host_reset = 1;
 		goto free_mem;
 	}
 
diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index 787cf439ba57..f6f8ca3c8c7f 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -646,6 +646,7 @@ static struct pci_device_id mvs_pci_table[] = {
 	{ PCI_VDEVICE(ARECA, PCI_DEVICE_ID_ARECA_1300), chip_1300 },
 	{ PCI_VDEVICE(ARECA, PCI_DEVICE_ID_ARECA_1320), chip_1320 },
 	{ PCI_VDEVICE(ADAPTEC2, 0x0450), chip_6440 },
+	{ PCI_VDEVICE(TTI, 0x2640), chip_6440 },
 	{ PCI_VDEVICE(TTI, 0x2710), chip_9480 },
 	{ PCI_VDEVICE(TTI, 0x2720), chip_9480 },
 	{ PCI_VDEVICE(TTI, 0x2721), chip_9480 },
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 5561057109de..04746df26c6c 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -765,6 +765,10 @@ static void init_default_table_values(struct pm8001_hba_info *pm8001_ha)
 	pm8001_ha->main_cfg_tbl.pm80xx_tbl.pcs_event_log_severity	= 0x01;
 	pm8001_ha->main_cfg_tbl.pm80xx_tbl.fatal_err_interrupt		= 0x01;
 
+	/* Enable higher IQs and OQs, 32 to 63, bit 16 */
+	if (pm8001_ha->max_q_num > 32)
+		pm8001_ha->main_cfg_tbl.pm80xx_tbl.fatal_err_interrupt |=
+							1 << 16;
 	/* Disable end to end CRC checking */
 	pm8001_ha->main_cfg_tbl.pm80xx_tbl.crc_core_dump = (0x1 << 16);
 
@@ -1026,6 +1030,13 @@ static int mpi_init_check(struct pm8001_hba_info *pm8001_ha)
 	if (0x0000 != gst_len_mpistate)
 		return -EBUSY;
 
+	/*
+	 *  As per controller datasheet, after successful MPI
+	 *  initialization minimum 500ms delay is required before
+	 *  issuing commands.
+	 */
+	msleep(500);
+
 	return 0;
 }
 
@@ -1733,10 +1744,11 @@ static void
 pm80xx_chip_interrupt_enable(struct pm8001_hba_info *pm8001_ha, u8 vec)
 {
 #ifdef PM8001_USE_MSIX
-	u32 mask;
-	mask = (u32)(1 << vec);
-
-	pm8001_cw32(pm8001_ha, 0, MSGU_ODMR_CLR, (u32)(mask & 0xFFFFFFFF));
+	if (vec < 32)
+		pm8001_cw32(pm8001_ha, 0, MSGU_ODMR_CLR, 1U << vec);
+	else
+		pm8001_cw32(pm8001_ha, 0, MSGU_ODMR_CLR_U,
+			    1U << (vec - 32));
 	return;
 #endif
 	pm80xx_chip_intx_interrupt_enable(pm8001_ha);
@@ -1752,12 +1764,15 @@ static void
 pm80xx_chip_interrupt_disable(struct pm8001_hba_info *pm8001_ha, u8 vec)
 {
 #ifdef PM8001_USE_MSIX
-	u32 mask;
-	if (vec == 0xFF)
-		mask = 0xFFFFFFFF;
+	if (vec == 0xFF) {
+		/* disable all vectors 0-31, 32-63 */
+		pm8001_cw32(pm8001_ha, 0, MSGU_ODMR, 0xFFFFFFFF);
+		pm8001_cw32(pm8001_ha, 0, MSGU_ODMR_U, 0xFFFFFFFF);
+	} else if (vec < 32)
+		pm8001_cw32(pm8001_ha, 0, MSGU_ODMR, 1U << vec);
 	else
-		mask = (u32)(1 << vec);
-	pm8001_cw32(pm8001_ha, 0, MSGU_ODMR, (u32)(mask & 0xFFFFFFFF));
+		pm8001_cw32(pm8001_ha, 0, MSGU_ODMR_U,
+			    1U << (vec - 32));
 	return;
 #endif
 	pm80xx_chip_intx_interrupt_disable(pm8001_ha);
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 554b6f784223..c7b1b2e8bb02 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2221,10 +2221,10 @@ static void iscsi_stop_conn(struct iscsi_cls_conn *conn, int flag)
 
 	switch (flag) {
 	case STOP_CONN_RECOVER:
-		conn->state = ISCSI_CONN_FAILED;
+		WRITE_ONCE(conn->state, ISCSI_CONN_FAILED);
 		break;
 	case STOP_CONN_TERM:
-		conn->state = ISCSI_CONN_DOWN;
+		WRITE_ONCE(conn->state, ISCSI_CONN_DOWN);
 		break;
 	default:
 		iscsi_cls_conn_printk(KERN_ERR, conn, "invalid stop flag %d\n",
@@ -2236,6 +2236,49 @@ static void iscsi_stop_conn(struct iscsi_cls_conn *conn, int flag)
 	ISCSI_DBG_TRANS_CONN(conn, "Stopping conn done.\n");
 }
 
+static void iscsi_ep_disconnect(struct iscsi_cls_conn *conn, bool is_active)
+{
+	struct iscsi_cls_session *session = iscsi_conn_to_session(conn);
+	struct iscsi_endpoint *ep;
+
+	ISCSI_DBG_TRANS_CONN(conn, "disconnect ep.\n");
+	WRITE_ONCE(conn->state, ISCSI_CONN_FAILED);
+
+	if (!conn->ep || !session->transport->ep_disconnect)
+		return;
+
+	ep = conn->ep;
+	conn->ep = NULL;
+
+	session->transport->unbind_conn(conn, is_active);
+	session->transport->ep_disconnect(ep);
+	ISCSI_DBG_TRANS_CONN(conn, "disconnect ep done.\n");
+}
+
+static void iscsi_if_disconnect_bound_ep(struct iscsi_cls_conn *conn,
+					 struct iscsi_endpoint *ep,
+					 bool is_active)
+{
+	/* Check if this was a conn error and the kernel took ownership */
+	spin_lock_irq(&conn->lock);
+	if (!test_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags)) {
+		spin_unlock_irq(&conn->lock);
+		iscsi_ep_disconnect(conn, is_active);
+	} else {
+		spin_unlock_irq(&conn->lock);
+		ISCSI_DBG_TRANS_CONN(conn, "flush kernel conn cleanup.\n");
+		mutex_unlock(&conn->ep_mutex);
+
+		flush_work(&conn->cleanup_work);
+		/*
+		 * Userspace is now done with the EP so we can release the ref
+		 * iscsi_cleanup_conn_work_fn took.
+		 */
+		iscsi_put_endpoint(ep);
+		mutex_lock(&conn->ep_mutex);
+	}
+}
+
 static int iscsi_if_stop_conn(struct iscsi_transport *transport,
 			      struct iscsi_uevent *ev)
 {
@@ -2256,12 +2299,25 @@ static int iscsi_if_stop_conn(struct iscsi_transport *transport,
 		cancel_work_sync(&conn->cleanup_work);
 		iscsi_stop_conn(conn, flag);
 	} else {
+		/*
+		 * For offload, when iscsid is restarted it won't know about
+		 * existing endpoints so it can't do a ep_disconnect. We clean
+		 * it up here for userspace.
+		 */
+		mutex_lock(&conn->ep_mutex);
+		if (conn->ep)
+			iscsi_if_disconnect_bound_ep(conn, conn->ep, true);
+		mutex_unlock(&conn->ep_mutex);
+
 		/*
 		 * Figure out if it was the kernel or userspace initiating this.
 		 */
+		spin_lock_irq(&conn->lock);
 		if (!test_and_set_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags)) {
+			spin_unlock_irq(&conn->lock);
 			iscsi_stop_conn(conn, flag);
 		} else {
+			spin_unlock_irq(&conn->lock);
 			ISCSI_DBG_TRANS_CONN(conn,
 					     "flush kernel conn cleanup.\n");
 			flush_work(&conn->cleanup_work);
@@ -2270,31 +2326,14 @@ static int iscsi_if_stop_conn(struct iscsi_transport *transport,
 		 * Only clear for recovery to avoid extra cleanup runs during
 		 * termination.
 		 */
+		spin_lock_irq(&conn->lock);
 		clear_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags);
+		spin_unlock_irq(&conn->lock);
 	}
 	ISCSI_DBG_TRANS_CONN(conn, "iscsi if conn stop done.\n");
 	return 0;
 }
 
-static void iscsi_ep_disconnect(struct iscsi_cls_conn *conn, bool is_active)
-{
-	struct iscsi_cls_session *session = iscsi_conn_to_session(conn);
-	struct iscsi_endpoint *ep;
-
-	ISCSI_DBG_TRANS_CONN(conn, "disconnect ep.\n");
-	conn->state = ISCSI_CONN_FAILED;
-
-	if (!conn->ep || !session->transport->ep_disconnect)
-		return;
-
-	ep = conn->ep;
-	conn->ep = NULL;
-
-	session->transport->unbind_conn(conn, is_active);
-	session->transport->ep_disconnect(ep);
-	ISCSI_DBG_TRANS_CONN(conn, "disconnect ep done.\n");
-}
-
 static void iscsi_cleanup_conn_work_fn(struct work_struct *work)
 {
 	struct iscsi_cls_conn *conn = container_of(work, struct iscsi_cls_conn,
@@ -2303,18 +2342,11 @@ static void iscsi_cleanup_conn_work_fn(struct work_struct *work)
 
 	mutex_lock(&conn->ep_mutex);
 	/*
-	 * If we are not at least bound there is nothing for us to do. Userspace
-	 * will do a ep_disconnect call if offload is used, but will not be
-	 * doing a stop since there is nothing to clean up, so we have to clear
-	 * the cleanup bit here.
+	 * Get a ref to the ep, so we don't release its ID until after
+	 * userspace is done referencing it in iscsi_if_disconnect_bound_ep.
 	 */
-	if (conn->state != ISCSI_CONN_BOUND && conn->state != ISCSI_CONN_UP) {
-		ISCSI_DBG_TRANS_CONN(conn, "Got error while conn is already failed. Ignoring.\n");
-		clear_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags);
-		mutex_unlock(&conn->ep_mutex);
-		return;
-	}
-
+	if (conn->ep)
+		get_device(&conn->ep->dev);
 	iscsi_ep_disconnect(conn, false);
 
 	if (system_state != SYSTEM_RUNNING) {
@@ -2370,11 +2402,12 @@ iscsi_create_conn(struct iscsi_cls_session *session, int dd_size, uint32_t cid)
 		conn->dd_data = &conn[1];
 
 	mutex_init(&conn->ep_mutex);
+	spin_lock_init(&conn->lock);
 	INIT_LIST_HEAD(&conn->conn_list);
 	INIT_WORK(&conn->cleanup_work, iscsi_cleanup_conn_work_fn);
 	conn->transport = transport;
 	conn->cid = cid;
-	conn->state = ISCSI_CONN_DOWN;
+	WRITE_ONCE(conn->state, ISCSI_CONN_DOWN);
 
 	/* this is released in the dev's release function */
 	if (!get_device(&session->dev))
@@ -2561,9 +2594,32 @@ void iscsi_conn_error_event(struct iscsi_cls_conn *conn, enum iscsi_err error)
 	struct iscsi_uevent *ev;
 	struct iscsi_internal *priv;
 	int len = nlmsg_total_size(sizeof(*ev));
+	unsigned long flags;
+	int state;
 
-	if (!test_and_set_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags))
-		queue_work(iscsi_conn_cleanup_workq, &conn->cleanup_work);
+	spin_lock_irqsave(&conn->lock, flags);
+	/*
+	 * Userspace will only do a stop call if we are at least bound. And, we
+	 * only need to do the in kernel cleanup if in the UP state so cmds can
+	 * be released to upper layers. If in other states just wait for
+	 * userspace to avoid races that can leave the cleanup_work queued.
+	 */
+	state = READ_ONCE(conn->state);
+	switch (state) {
+	case ISCSI_CONN_BOUND:
+	case ISCSI_CONN_UP:
+		if (!test_and_set_bit(ISCSI_CLS_CONN_BIT_CLEANUP,
+				      &conn->flags)) {
+			queue_work(iscsi_conn_cleanup_workq,
+				   &conn->cleanup_work);
+		}
+		break;
+	default:
+		ISCSI_DBG_TRANS_CONN(conn, "Got conn error in state %d\n",
+				     state);
+		break;
+	}
+	spin_unlock_irqrestore(&conn->lock, flags);
 
 	priv = iscsi_if_transport_lookup(conn->transport);
 	if (!priv)
@@ -2913,7 +2969,7 @@ iscsi_set_param(struct iscsi_transport *transport, struct iscsi_uevent *ev)
 	char *data = (char*)ev + sizeof(*ev);
 	struct iscsi_cls_conn *conn;
 	struct iscsi_cls_session *session;
-	int err = 0, value = 0;
+	int err = 0, value = 0, state;
 
 	if (ev->u.set_param.len > PAGE_SIZE)
 		return -EINVAL;
@@ -2930,8 +2986,8 @@ iscsi_set_param(struct iscsi_transport *transport, struct iscsi_uevent *ev)
 			session->recovery_tmo = value;
 		break;
 	default:
-		if ((conn->state == ISCSI_CONN_BOUND) ||
-			(conn->state == ISCSI_CONN_UP)) {
+		state = READ_ONCE(conn->state);
+		if (state == ISCSI_CONN_BOUND || state == ISCSI_CONN_UP) {
 			err = transport->set_param(conn, ev->u.set_param.param,
 					data, ev->u.set_param.len);
 		} else {
@@ -3003,16 +3059,7 @@ static int iscsi_if_ep_disconnect(struct iscsi_transport *transport,
 	}
 
 	mutex_lock(&conn->ep_mutex);
-	/* Check if this was a conn error and the kernel took ownership */
-	if (test_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags)) {
-		ISCSI_DBG_TRANS_CONN(conn, "flush kernel conn cleanup.\n");
-		mutex_unlock(&conn->ep_mutex);
-
-		flush_work(&conn->cleanup_work);
-		goto put_ep;
-	}
-
-	iscsi_ep_disconnect(conn, false);
+	iscsi_if_disconnect_bound_ep(conn, ep, false);
 	mutex_unlock(&conn->ep_mutex);
 put_ep:
 	iscsi_put_endpoint(ep);
@@ -3715,24 +3762,17 @@ static int iscsi_if_transport_conn(struct iscsi_transport *transport,
 		return -EINVAL;
 
 	mutex_lock(&conn->ep_mutex);
+	spin_lock_irq(&conn->lock);
 	if (test_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags)) {
+		spin_unlock_irq(&conn->lock);
 		mutex_unlock(&conn->ep_mutex);
 		ev->r.retcode = -ENOTCONN;
 		return 0;
 	}
+	spin_unlock_irq(&conn->lock);
 
 	switch (nlh->nlmsg_type) {
 	case ISCSI_UEVENT_BIND_CONN:
-		if (conn->ep) {
-			/*
-			 * For offload boot support where iscsid is restarted
-			 * during the pivot root stage, the ep will be intact
-			 * here when the new iscsid instance starts up and
-			 * reconnects.
-			 */
-			iscsi_ep_disconnect(conn, true);
-		}
-
 		session = iscsi_session_lookup(ev->u.b_conn.sid);
 		if (!session) {
 			err = -EINVAL;
@@ -3743,7 +3783,7 @@ static int iscsi_if_transport_conn(struct iscsi_transport *transport,
 						ev->u.b_conn.transport_eph,
 						ev->u.b_conn.is_leading);
 		if (!ev->r.retcode)
-			conn->state = ISCSI_CONN_BOUND;
+			WRITE_ONCE(conn->state, ISCSI_CONN_BOUND);
 
 		if (ev->r.retcode || !transport->ep_connect)
 			break;
@@ -3762,7 +3802,8 @@ static int iscsi_if_transport_conn(struct iscsi_transport *transport,
 	case ISCSI_UEVENT_START_CONN:
 		ev->r.retcode = transport->start_conn(conn);
 		if (!ev->r.retcode)
-			conn->state = ISCSI_CONN_UP;
+			WRITE_ONCE(conn->state, ISCSI_CONN_UP);
+
 		break;
 	case ISCSI_UEVENT_SEND_PDU:
 		pdu_len = nlh->nlmsg_len - sizeof(*nlh) - sizeof(*ev);
@@ -4070,10 +4111,11 @@ static ssize_t show_conn_state(struct device *dev,
 {
 	struct iscsi_cls_conn *conn = iscsi_dev_to_conn(dev->parent);
 	const char *state = "unknown";
+	int conn_state = READ_ONCE(conn->state);
 
-	if (conn->state >= 0 &&
-	    conn->state < ARRAY_SIZE(connection_state_names))
-		state = connection_state_names[conn->state];
+	if (conn_state >= 0 &&
+	    conn_state < ARRAY_SIZE(connection_state_names))
+		state = connection_state_names[conn_state];
 
 	return sysfs_emit(buf, "%s\n", state);
 }
diff --git a/drivers/soc/qcom/qcom_aoss.c b/drivers/soc/qcom/qcom_aoss.c
index a0659cf27845..8583c1e558ae 100644
--- a/drivers/soc/qcom/qcom_aoss.c
+++ b/drivers/soc/qcom/qcom_aoss.c
@@ -8,10 +8,12 @@
 #include <linux/io.h>
 #include <linux/mailbox_client.h>
 #include <linux/module.h>
+#include <linux/of_platform.h>
 #include <linux/platform_device.h>
 #include <linux/pm_domain.h>
 #include <linux/thermal.h>
 #include <linux/slab.h>
+#include <linux/soc/qcom/qcom_aoss.h>
 
 #define QMP_DESC_MAGIC			0x0
 #define QMP_DESC_VERSION		0x4
@@ -223,11 +225,14 @@ static bool qmp_message_empty(struct qmp *qmp)
  *
  * Return: 0 on success, negative errno on failure
  */
-static int qmp_send(struct qmp *qmp, const void *data, size_t len)
+int qmp_send(struct qmp *qmp, const void *data, size_t len)
 {
 	long time_left;
 	int ret;
 
+	if (WARN_ON(IS_ERR_OR_NULL(qmp) || !data))
+		return -EINVAL;
+
 	if (WARN_ON(len + sizeof(u32) > qmp->size))
 		return -EINVAL;
 
@@ -261,6 +266,7 @@ static int qmp_send(struct qmp *qmp, const void *data, size_t len)
 
 	return ret;
 }
+EXPORT_SYMBOL(qmp_send);
 
 static int qmp_qdss_clk_prepare(struct clk_hw *hw)
 {
@@ -519,6 +525,55 @@ static void qmp_cooling_devices_remove(struct qmp *qmp)
 		thermal_cooling_device_unregister(qmp->cooling_devs[i].cdev);
 }
 
+/**
+ * qmp_get() - get a qmp handle from a device
+ * @dev: client device pointer
+ *
+ * Return: handle to qmp device on success, ERR_PTR() on failure
+ */
+struct qmp *qmp_get(struct device *dev)
+{
+	struct platform_device *pdev;
+	struct device_node *np;
+	struct qmp *qmp;
+
+	if (!dev || !dev->of_node)
+		return ERR_PTR(-EINVAL);
+
+	np = of_parse_phandle(dev->of_node, "qcom,qmp", 0);
+	if (!np)
+		return ERR_PTR(-ENODEV);
+
+	pdev = of_find_device_by_node(np);
+	of_node_put(np);
+	if (!pdev)
+		return ERR_PTR(-EINVAL);
+
+	qmp = platform_get_drvdata(pdev);
+
+	if (!qmp) {
+		put_device(&pdev->dev);
+		return ERR_PTR(-EPROBE_DEFER);
+	}
+	return qmp;
+}
+EXPORT_SYMBOL(qmp_get);
+
+/**
+ * qmp_put() - release a qmp handle
+ * @qmp: qmp handle obtained from qmp_get()
+ */
+void qmp_put(struct qmp *qmp)
+{
+	/*
+	 * Match get_device() inside of_find_device_by_node() in
+	 * qmp_get()
+	 */
+	if (!IS_ERR_OR_NULL(qmp))
+		put_device(qmp->dev);
+}
+EXPORT_SYMBOL(qmp_put);
+
 static int qmp_probe(struct platform_device *pdev)
 {
 	struct resource *res;
@@ -615,6 +670,7 @@ static struct platform_driver qmp_driver = {
 	.driver = {
 		.name		= "qcom_aoss_qmp",
 		.of_match_table	= qmp_dt_match,
+		.suppress_bind_attrs = true,
 	},
 	.probe = qmp_probe,
 	.remove	= qmp_remove,
diff --git a/drivers/spi/spi-cadence-quadspi.c b/drivers/spi/spi-cadence-quadspi.c
index 101cc71bffa7..1a6294a06e72 100644
--- a/drivers/spi/spi-cadence-quadspi.c
+++ b/drivers/spi/spi-cadence-quadspi.c
@@ -18,6 +18,7 @@
 #include <linux/iopoll.h>
 #include <linux/jiffies.h>
 #include <linux/kernel.h>
+#include <linux/log2.h>
 #include <linux/module.h>
 #include <linux/of_device.h>
 #include <linux/of.h>
@@ -93,12 +94,6 @@ struct cqspi_driver_platdata {
 #define CQSPI_TIMEOUT_MS			500
 #define CQSPI_READ_TIMEOUT_MS			10
 
-/* Instruction type */
-#define CQSPI_INST_TYPE_SINGLE			0
-#define CQSPI_INST_TYPE_DUAL			1
-#define CQSPI_INST_TYPE_QUAD			2
-#define CQSPI_INST_TYPE_OCTAL			3
-
 #define CQSPI_DUMMY_CLKS_PER_BYTE		8
 #define CQSPI_DUMMY_BYTES_MAX			4
 #define CQSPI_DUMMY_CLKS_MAX			31
@@ -322,10 +317,6 @@ static unsigned int cqspi_calc_dummy(const struct spi_mem_op *op, bool dtr)
 static int cqspi_set_protocol(struct cqspi_flash_pdata *f_pdata,
 			      const struct spi_mem_op *op)
 {
-	f_pdata->inst_width = CQSPI_INST_TYPE_SINGLE;
-	f_pdata->addr_width = CQSPI_INST_TYPE_SINGLE;
-	f_pdata->data_width = CQSPI_INST_TYPE_SINGLE;
-
 	/*
 	 * For an op to be DTR, cmd phase along with every other non-empty
 	 * phase should have dtr field set to 1. If an op phase has zero
@@ -335,32 +326,23 @@ static int cqspi_set_protocol(struct cqspi_flash_pdata *f_pdata,
 		       (!op->addr.nbytes || op->addr.dtr) &&
 		       (!op->data.nbytes || op->data.dtr);
 
-	switch (op->data.buswidth) {
-	case 0:
-		break;
-	case 1:
-		f_pdata->data_width = CQSPI_INST_TYPE_SINGLE;
-		break;
-	case 2:
-		f_pdata->data_width = CQSPI_INST_TYPE_DUAL;
-		break;
-	case 4:
-		f_pdata->data_width = CQSPI_INST_TYPE_QUAD;
-		break;
-	case 8:
-		f_pdata->data_width = CQSPI_INST_TYPE_OCTAL;
-		break;
-	default:
-		return -EINVAL;
-	}
+	f_pdata->inst_width = 0;
+	if (op->cmd.buswidth)
+		f_pdata->inst_width = ilog2(op->cmd.buswidth);
+
+	f_pdata->addr_width = 0;
+	if (op->addr.buswidth)
+		f_pdata->addr_width = ilog2(op->addr.buswidth);
+
+	f_pdata->data_width = 0;
+	if (op->data.buswidth)
+		f_pdata->data_width = ilog2(op->data.buswidth);
 
 	/* Right now we only support 8-8-8 DTR mode. */
 	if (f_pdata->dtr) {
 		switch (op->cmd.buswidth) {
 		case 0:
-			break;
 		case 8:
-			f_pdata->inst_width = CQSPI_INST_TYPE_OCTAL;
 			break;
 		default:
 			return -EINVAL;
@@ -368,9 +350,7 @@ static int cqspi_set_protocol(struct cqspi_flash_pdata *f_pdata,
 
 		switch (op->addr.buswidth) {
 		case 0:
-			break;
 		case 8:
-			f_pdata->addr_width = CQSPI_INST_TYPE_OCTAL;
 			break;
 		default:
 			return -EINVAL;
@@ -378,9 +358,7 @@ static int cqspi_set_protocol(struct cqspi_flash_pdata *f_pdata,
 
 		switch (op->data.buswidth) {
 		case 0:
-			break;
 		case 8:
-			f_pdata->data_width = CQSPI_INST_TYPE_OCTAL;
 			break;
 		default:
 			return -EINVAL;
diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 9f552f48084c..0ca5ec14d3db 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1821,6 +1821,7 @@ static struct page *tcmu_try_get_data_page(struct tcmu_dev *udev, uint32_t dpi)
 	mutex_lock(&udev->cmdr_lock);
 	page = xa_load(&udev->data_pages, dpi);
 	if (likely(page)) {
+		get_page(page);
 		mutex_unlock(&udev->cmdr_lock);
 		return page;
 	}
@@ -1877,6 +1878,7 @@ static vm_fault_t tcmu_vma_fault(struct vm_fault *vmf)
 		/* For the vmalloc()ed cmd area pages */
 		addr = (void *)(unsigned long)info->mem[mi].addr + offset;
 		page = vmalloc_to_page(addr);
+		get_page(page);
 	} else {
 		uint32_t dpi;
 
@@ -1887,7 +1889,6 @@ static vm_fault_t tcmu_vma_fault(struct vm_fault *vmf)
 			return VM_FAULT_SIGBUS;
 	}
 
-	get_page(page);
 	vmf->page = page;
 	return 0;
 }
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 15d158bdcde0..f3916e6b16b9 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -36,6 +36,10 @@ static bool nointxmask;
 static bool disable_vga;
 static bool disable_idle_d3;
 
+/* List of PF's that vfio_pci_core_sriov_configure() has been called on */
+static DEFINE_MUTEX(vfio_pci_sriov_pfs_mutex);
+static LIST_HEAD(vfio_pci_sriov_pfs);
+
 static inline bool vfio_vga_disabled(void)
 {
 #ifdef CONFIG_VFIO_PCI_VGA
@@ -434,47 +438,17 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_disable);
 
-static struct vfio_pci_core_device *get_pf_vdev(struct vfio_pci_core_device *vdev)
-{
-	struct pci_dev *physfn = pci_physfn(vdev->pdev);
-	struct vfio_device *pf_dev;
-
-	if (!vdev->pdev->is_virtfn)
-		return NULL;
-
-	pf_dev = vfio_device_get_from_dev(&physfn->dev);
-	if (!pf_dev)
-		return NULL;
-
-	if (pci_dev_driver(physfn) != pci_dev_driver(vdev->pdev)) {
-		vfio_device_put(pf_dev);
-		return NULL;
-	}
-
-	return container_of(pf_dev, struct vfio_pci_core_device, vdev);
-}
-
-static void vfio_pci_vf_token_user_add(struct vfio_pci_core_device *vdev, int val)
-{
-	struct vfio_pci_core_device *pf_vdev = get_pf_vdev(vdev);
-
-	if (!pf_vdev)
-		return;
-
-	mutex_lock(&pf_vdev->vf_token->lock);
-	pf_vdev->vf_token->users += val;
-	WARN_ON(pf_vdev->vf_token->users < 0);
-	mutex_unlock(&pf_vdev->vf_token->lock);
-
-	vfio_device_put(&pf_vdev->vdev);
-}
-
 void vfio_pci_core_close_device(struct vfio_device *core_vdev)
 {
 	struct vfio_pci_core_device *vdev =
 		container_of(core_vdev, struct vfio_pci_core_device, vdev);
 
-	vfio_pci_vf_token_user_add(vdev, -1);
+	if (vdev->sriov_pf_core_dev) {
+		mutex_lock(&vdev->sriov_pf_core_dev->vf_token->lock);
+		WARN_ON(!vdev->sriov_pf_core_dev->vf_token->users);
+		vdev->sriov_pf_core_dev->vf_token->users--;
+		mutex_unlock(&vdev->sriov_pf_core_dev->vf_token->lock);
+	}
 	vfio_spapr_pci_eeh_release(vdev->pdev);
 	vfio_pci_core_disable(vdev);
 
@@ -495,7 +469,12 @@ void vfio_pci_core_finish_enable(struct vfio_pci_core_device *vdev)
 {
 	vfio_pci_probe_mmaps(vdev);
 	vfio_spapr_pci_eeh_open(vdev->pdev);
-	vfio_pci_vf_token_user_add(vdev, 1);
+
+	if (vdev->sriov_pf_core_dev) {
+		mutex_lock(&vdev->sriov_pf_core_dev->vf_token->lock);
+		vdev->sriov_pf_core_dev->vf_token->users++;
+		mutex_unlock(&vdev->sriov_pf_core_dev->vf_token->lock);
+	}
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_finish_enable);
 
@@ -1603,11 +1582,8 @@ static int vfio_pci_validate_vf_token(struct vfio_pci_core_device *vdev,
 	 *
 	 * If the VF token is provided but unused, an error is generated.
 	 */
-	if (!vdev->pdev->is_virtfn && !vdev->vf_token && !vf_token)
-		return 0; /* No VF token provided or required */
-
 	if (vdev->pdev->is_virtfn) {
-		struct vfio_pci_core_device *pf_vdev = get_pf_vdev(vdev);
+		struct vfio_pci_core_device *pf_vdev = vdev->sriov_pf_core_dev;
 		bool match;
 
 		if (!pf_vdev) {
@@ -1620,7 +1596,6 @@ static int vfio_pci_validate_vf_token(struct vfio_pci_core_device *vdev,
 		}
 
 		if (!vf_token) {
-			vfio_device_put(&pf_vdev->vdev);
 			pci_info_ratelimited(vdev->pdev,
 				"VF token required to access device\n");
 			return -EACCES;
@@ -1630,8 +1605,6 @@ static int vfio_pci_validate_vf_token(struct vfio_pci_core_device *vdev,
 		match = uuid_equal(uuid, &pf_vdev->vf_token->uuid);
 		mutex_unlock(&pf_vdev->vf_token->lock);
 
-		vfio_device_put(&pf_vdev->vdev);
-
 		if (!match) {
 			pci_info_ratelimited(vdev->pdev,
 				"Incorrect VF token provided for device\n");
@@ -1752,8 +1725,30 @@ static int vfio_pci_bus_notifier(struct notifier_block *nb,
 static int vfio_pci_vf_init(struct vfio_pci_core_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
+	struct vfio_pci_core_device *cur;
+	struct pci_dev *physfn;
 	int ret;
 
+	if (pdev->is_virtfn) {
+		/*
+		 * If this VF was created by our vfio_pci_core_sriov_configure()
+		 * then we can find the PF vfio_pci_core_device now, and due to
+		 * the locking in pci_disable_sriov() it cannot change until
+		 * this VF device driver is removed.
+		 */
+		physfn = pci_physfn(vdev->pdev);
+		mutex_lock(&vfio_pci_sriov_pfs_mutex);
+		list_for_each_entry(cur, &vfio_pci_sriov_pfs, sriov_pfs_item) {
+			if (cur->pdev == physfn) {
+				vdev->sriov_pf_core_dev = cur;
+				break;
+			}
+		}
+		mutex_unlock(&vfio_pci_sriov_pfs_mutex);
+		return 0;
+	}
+
+	/* Not a SRIOV PF */
 	if (!pdev->is_physfn)
 		return 0;
 
@@ -1825,6 +1820,7 @@ void vfio_pci_core_init_device(struct vfio_pci_core_device *vdev,
 	INIT_LIST_HEAD(&vdev->ioeventfds_list);
 	mutex_init(&vdev->vma_lock);
 	INIT_LIST_HEAD(&vdev->vma_list);
+	INIT_LIST_HEAD(&vdev->sriov_pfs_item);
 	init_rwsem(&vdev->memory_lock);
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_init_device);
@@ -1923,7 +1919,7 @@ void vfio_pci_core_unregister_device(struct vfio_pci_core_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
 
-	pci_disable_sriov(pdev);
+	vfio_pci_core_sriov_configure(pdev, 0);
 
 	vfio_unregister_group_dev(&vdev->vdev);
 
@@ -1963,21 +1959,49 @@ static pci_ers_result_t vfio_pci_aer_err_detected(struct pci_dev *pdev,
 
 int vfio_pci_core_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
 {
+	struct vfio_pci_core_device *vdev;
 	struct vfio_device *device;
 	int ret = 0;
 
+	device_lock_assert(&pdev->dev);
+
 	device = vfio_device_get_from_dev(&pdev->dev);
 	if (!device)
 		return -ENODEV;
 
-	if (nr_virtfn == 0)
-		pci_disable_sriov(pdev);
-	else
+	vdev = container_of(device, struct vfio_pci_core_device, vdev);
+
+	if (nr_virtfn) {
+		mutex_lock(&vfio_pci_sriov_pfs_mutex);
+		/*
+		 * The thread that adds the vdev to the list is the only thread
+		 * that gets to call pci_enable_sriov() and we will only allow
+		 * it to be called once without going through
+		 * pci_disable_sriov()
+		 */
+		if (!list_empty(&vdev->sriov_pfs_item)) {
+			ret = -EINVAL;
+			goto out_unlock;
+		}
+		list_add_tail(&vdev->sriov_pfs_item, &vfio_pci_sriov_pfs);
+		mutex_unlock(&vfio_pci_sriov_pfs_mutex);
 		ret = pci_enable_sriov(pdev, nr_virtfn);
+		if (ret)
+			goto out_del;
+		ret = nr_virtfn;
+		goto out_put;
+	}
 
-	vfio_device_put(device);
+	pci_disable_sriov(pdev);
 
-	return ret < 0 ? ret : nr_virtfn;
+out_del:
+	mutex_lock(&vfio_pci_sriov_pfs_mutex);
+	list_del_init(&vdev->sriov_pfs_item);
+out_unlock:
+	mutex_unlock(&vfio_pci_sriov_pfs_mutex);
+out_put:
+	vfio_device_put(device);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_sriov_configure);
 
diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 53ff3db9640e..37418b183b07 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -2882,7 +2882,6 @@ int btrfs_start_dirty_block_groups(struct btrfs_trans_handle *trans)
 	struct btrfs_path *path = NULL;
 	LIST_HEAD(dirty);
 	struct list_head *io = &cur_trans->io_bgs;
-	int num_started = 0;
 	int loops = 0;
 
 	spin_lock(&cur_trans->dirty_bgs_lock);
@@ -2948,7 +2947,6 @@ int btrfs_start_dirty_block_groups(struct btrfs_trans_handle *trans)
 			cache->io_ctl.inode = NULL;
 			ret = btrfs_write_out_cache(trans, cache, path);
 			if (ret == 0 && cache->io_ctl.inode) {
-				num_started++;
 				should_put = 0;
 
 				/*
@@ -3049,7 +3047,6 @@ int btrfs_write_dirty_block_groups(struct btrfs_trans_handle *trans)
 	int should_put;
 	struct btrfs_path *path;
 	struct list_head *io = &cur_trans->io_bgs;
-	int num_started = 0;
 
 	path = btrfs_alloc_path();
 	if (!path)
@@ -3107,7 +3104,6 @@ int btrfs_write_dirty_block_groups(struct btrfs_trans_handle *trans)
 			cache->io_ctl.inode = NULL;
 			ret = btrfs_write_out_cache(trans, cache, path);
 			if (ret == 0 && cache->io_ctl.inode) {
-				num_started++;
 				should_put = 0;
 				list_add_tail(&cache->io_list, io);
 			} else {
diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 0913ee50e6c3..701fbd1b5676 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -550,7 +550,6 @@ static noinline int add_ra_bio_pages(struct inode *inode,
 	u64 isize = i_size_read(inode);
 	int ret;
 	struct page *page;
-	unsigned long nr_pages = 0;
 	struct extent_map *em;
 	struct address_space *mapping = inode->i_mapping;
 	struct extent_map_tree *em_tree;
@@ -646,7 +645,6 @@ static noinline int add_ra_bio_pages(struct inode *inode,
 				   PAGE_SIZE, 0);
 
 		if (ret == PAGE_SIZE) {
-			nr_pages++;
 			put_page(page);
 		} else {
 			unlock_extent(tree, last_offset, end);
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index aed1f26ca2b8..f1f7dbfa6ecd 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1738,9 +1738,10 @@ static struct btrfs_root *btrfs_get_root_ref(struct btrfs_fs_info *fs_info,
 
 	ret = btrfs_insert_fs_root(fs_info, root);
 	if (ret) {
-		btrfs_put_root(root);
-		if (ret == -EEXIST)
+		if (ret == -EEXIST) {
+			btrfs_put_root(root);
 			goto again;
+		}
 		goto fail;
 	}
 	return root;
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 50a5cc4fd25b..96aeb16bd65c 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3561,7 +3561,6 @@ int btrfs_do_readpage(struct page *page, struct extent_map **em_cached,
 	u64 cur_end;
 	struct extent_map *em;
 	int ret = 0;
-	int nr = 0;
 	size_t pg_offset = 0;
 	size_t iosize;
 	size_t blocksize = inode->i_sb->s_blocksize;
@@ -3727,9 +3726,7 @@ int btrfs_do_readpage(struct page *page, struct extent_map **em_cached,
 					 end_bio_extent_readpage, 0,
 					 this_bio_flag,
 					 force_bio_submit);
-		if (!ret) {
-			nr++;
-		} else {
+		if (ret) {
 			unlock_extent(tree, cur, cur + iosize - 1);
 			end_page_read(page, false, cur, iosize);
 			goto out;
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index a1762363f61f..dc1e4d1b7291 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2878,8 +2878,9 @@ int btrfs_replace_file_extents(struct btrfs_inode *inode,
 	return ret;
 }
 
-static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
+static int btrfs_punch_hole(struct file *file, loff_t offset, loff_t len)
 {
+	struct inode *inode = file_inode(file);
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct extent_state *cached_state = NULL;
@@ -2911,6 +2912,10 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 		goto out_only_mutex;
 	}
 
+	ret = file_modified(file);
+	if (ret)
+		goto out_only_mutex;
+
 	lockstart = round_up(offset, btrfs_inode_sectorsize(BTRFS_I(inode)));
 	lockend = round_down(offset + len,
 			     btrfs_inode_sectorsize(BTRFS_I(inode))) - 1;
@@ -3351,7 +3356,7 @@ static long btrfs_fallocate(struct file *file, int mode,
 		return -EOPNOTSUPP;
 
 	if (mode & FALLOC_FL_PUNCH_HOLE)
-		return btrfs_punch_hole(inode, offset, len);
+		return btrfs_punch_hole(file, offset, len);
 
 	/*
 	 * Only trigger disk allocation, don't trigger qgroup reserve
@@ -3373,6 +3378,10 @@ static long btrfs_fallocate(struct file *file, int mode,
 			goto out;
 	}
 
+	ret = file_modified(file);
+	if (ret)
+		goto out;
+
 	/*
 	 * TODO: Move these two operations after we have checked
 	 * accurate reserved space, or fallocate can still fail but
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e478fd916216..6266a706bff7 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1075,7 +1075,6 @@ static noinline int cow_file_range(struct btrfs_inode *inode,
 	int ret = 0;
 
 	if (btrfs_is_free_space_inode(inode)) {
-		WARN_ON_ONCE(1);
 		ret = -EINVAL;
 		goto out_unlock;
 	}
@@ -7772,6 +7771,7 @@ static int btrfs_get_blocks_direct_write(struct extent_map **map,
 	u64 block_start, orig_start, orig_block_len, ram_bytes;
 	bool can_nocow = false;
 	bool space_reserved = false;
+	u64 prev_len;
 	int ret = 0;
 
 	/*
@@ -7799,6 +7799,7 @@ static int btrfs_get_blocks_direct_write(struct extent_map **map,
 			can_nocow = true;
 	}
 
+	prev_len = len;
 	if (can_nocow) {
 		struct extent_map *em2;
 
@@ -7828,8 +7829,6 @@ static int btrfs_get_blocks_direct_write(struct extent_map **map,
 			goto out;
 		}
 	} else {
-		const u64 prev_len = len;
-
 		/* Our caller expects us to free the input extent map. */
 		free_extent_map(em);
 		*map = NULL;
@@ -7860,7 +7859,7 @@ static int btrfs_get_blocks_direct_write(struct extent_map **map,
 	 * We have created our ordered extent, so we can now release our reservation
 	 * for an outstanding extent.
 	 */
-	btrfs_delalloc_release_extents(BTRFS_I(inode), len);
+	btrfs_delalloc_release_extents(BTRFS_I(inode), prev_len);
 
 	/*
 	 * Need to update the i_size under the extent lock so buffered
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f6d6825f218a..471cc4706a07 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4389,10 +4389,12 @@ static int balance_kthread(void *data)
 	struct btrfs_fs_info *fs_info = data;
 	int ret = 0;
 
+	sb_start_write(fs_info->sb);
 	mutex_lock(&fs_info->balance_mutex);
 	if (fs_info->balance_ctl)
 		ret = btrfs_balance(fs_info, fs_info->balance_ctl, NULL);
 	mutex_unlock(&fs_info->balance_mutex);
+	sb_end_write(fs_info->sb);
 
 	return ret;
 }
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index ed220daca3e1..29a019cf1d5f 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -266,22 +266,24 @@ static void cifs_kill_sb(struct super_block *sb)
 	 * before we kill the sb.
 	 */
 	if (cifs_sb->root) {
+		for (node = rb_first(root); node; node = rb_next(node)) {
+			tlink = rb_entry(node, struct tcon_link, tl_rbnode);
+			tcon = tlink_tcon(tlink);
+			if (IS_ERR(tcon))
+				continue;
+			cfid = &tcon->crfid;
+			mutex_lock(&cfid->fid_mutex);
+			if (cfid->dentry) {
+				dput(cfid->dentry);
+				cfid->dentry = NULL;
+			}
+			mutex_unlock(&cfid->fid_mutex);
+		}
+
+		/* finally release root dentry */
 		dput(cifs_sb->root);
 		cifs_sb->root = NULL;
 	}
-	node = rb_first(root);
-	while (node != NULL) {
-		tlink = rb_entry(node, struct tcon_link, tl_rbnode);
-		tcon = tlink_tcon(tlink);
-		cfid = &tcon->crfid;
-		mutex_lock(&cfid->fid_mutex);
-		if (cfid->dentry) {
-			dput(cfid->dentry);
-			cfid->dentry = NULL;
-		}
-		mutex_unlock(&cfid->fid_mutex);
-		node = rb_next(node);
-	}
 
 	kill_anon_super(sb);
 	cifs_umount(cifs_sb);
diff --git a/fs/cifs/link.c b/fs/cifs/link.c
index 852e54ee82c2..bbdf3281559c 100644
--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -85,6 +85,9 @@ parse_mf_symlink(const u8 *buf, unsigned int buf_len, unsigned int *_link_len,
 	if (rc != 1)
 		return -EINVAL;
 
+	if (link_len > CIFS_MF_SYMLINK_LINK_MAXLEN)
+		return -EINVAL;
+
 	rc = symlink_hash(link_len, link_str, md5_hash);
 	if (rc) {
 		cifs_dbg(FYI, "%s: MD5 hash failure: %d\n", __func__, rc);
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3d44d48b35ea..1bf1ea2cd8b0 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6403,6 +6403,7 @@ static int io_files_update(struct io_kiocb *req, unsigned int issue_flags)
 	up.nr = 0;
 	up.tags = 0;
 	up.resv = 0;
+	up.resv2 = 0;
 
 	io_ring_submit_lock(ctx, !(issue_flags & IO_URING_F_NONBLOCK));
 	ret = __io_register_rsrc_update(ctx, IORING_RSRC_FILE,
@@ -8412,13 +8413,15 @@ static int io_sqe_file_register(struct io_ring_ctx *ctx, struct file *file,
 static int io_queue_rsrc_removal(struct io_rsrc_data *data, unsigned idx,
 				 struct io_rsrc_node *node, void *rsrc)
 {
+	u64 *tag_slot = io_get_tag_slot(data, idx);
 	struct io_rsrc_put *prsrc;
 
 	prsrc = kzalloc(sizeof(*prsrc), GFP_KERNEL);
 	if (!prsrc)
 		return -ENOMEM;
 
-	prsrc->tag = *io_get_tag_slot(data, idx);
+	prsrc->tag = *tag_slot;
+	*tag_slot = 0;
 	prsrc->rsrc = rsrc;
 	list_add(&prsrc->list, &node->rsrc_list);
 	return 0;
@@ -8486,7 +8489,7 @@ static int io_close_fixed(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_fixed_file *file_slot;
 	struct file *file;
-	int ret, i;
+	int ret;
 
 	io_ring_submit_lock(ctx, !(issue_flags & IO_URING_F_NONBLOCK));
 	ret = -ENXIO;
@@ -8499,8 +8502,8 @@ static int io_close_fixed(struct io_kiocb *req, unsigned int issue_flags)
 	if (ret)
 		goto out;
 
-	i = array_index_nospec(offset, ctx->nr_user_files);
-	file_slot = io_fixed_file_slot(&ctx->file_table, i);
+	offset = array_index_nospec(offset, ctx->nr_user_files);
+	file_slot = io_fixed_file_slot(&ctx->file_table, offset);
 	ret = -EBADF;
 	if (!file_slot->file_ptr)
 		goto out;
@@ -8556,8 +8559,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 
 		if (file_slot->file_ptr) {
 			file = (struct file *)(file_slot->file_ptr & FFS_MASK);
-			err = io_queue_rsrc_removal(data, up->offset + done,
-						    ctx->rsrc_node, file);
+			err = io_queue_rsrc_removal(data, i, ctx->rsrc_node, file);
 			if (err)
 				break;
 			file_slot->file_ptr = 0;
@@ -9226,7 +9228,7 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 
 		i = array_index_nospec(offset, ctx->nr_user_bufs);
 		if (ctx->user_bufs[i] != ctx->dummy_ubuf) {
-			err = io_queue_rsrc_removal(ctx->buf_data, offset,
+			err = io_queue_rsrc_removal(ctx->buf_data, i,
 						    ctx->rsrc_node, ctx->user_bufs[i]);
 			if (unlikely(err)) {
 				io_buffer_unmap(ctx, &imu);
@@ -9980,6 +9982,8 @@ static int io_get_ext_arg(unsigned flags, const void __user *argp, size_t *argsz
 		return -EINVAL;
 	if (copy_from_user(&arg, argp, sizeof(arg)))
 		return -EFAULT;
+	if (arg.pad)
+		return -EINVAL;
 	*sig = u64_to_user_ptr(arg.sigmask);
 	*argsz = arg.sigmask_sz;
 	*ts = u64_to_user_ptr(arg.ts);
@@ -10595,8 +10599,6 @@ static int __io_register_rsrc_update(struct io_ring_ctx *ctx, unsigned type,
 	__u32 tmp;
 	int err;
 
-	if (up->resv)
-		return -EINVAL;
 	if (check_add_overflow(up->offset, nr_args, &tmp))
 		return -EOVERFLOW;
 	err = io_rsrc_node_switch_start(ctx);
@@ -10622,6 +10624,8 @@ static int io_register_files_update(struct io_ring_ctx *ctx, void __user *arg,
 	memset(&up, 0, sizeof(up));
 	if (copy_from_user(&up, arg, sizeof(struct io_uring_rsrc_update)))
 		return -EFAULT;
+	if (up.resv || up.resv2)
+		return -EINVAL;
 	return __io_register_rsrc_update(ctx, IORING_RSRC_FILE, &up, nr_args);
 }
 
@@ -10634,7 +10638,7 @@ static int io_register_rsrc_update(struct io_ring_ctx *ctx, void __user *arg,
 		return -EINVAL;
 	if (copy_from_user(&up, arg, sizeof(up)))
 		return -EFAULT;
-	if (!up.nr || up.resv)
+	if (!up.nr || up.resv || up.resv2)
 		return -EINVAL;
 	return __io_register_rsrc_update(ctx, type, &up, up.nr);
 }
diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index 2c68a545ffa7..71942a1c642d 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -565,10 +565,14 @@ static inline void tlb_flush_p4d_range(struct mmu_gather *tlb,
 #define tlb_remove_huge_tlb_entry(h, tlb, ptep, address)	\
 	do {							\
 		unsigned long _sz = huge_page_size(h);		\
-		if (_sz == PMD_SIZE)				\
-			tlb_flush_pmd_range(tlb, address, _sz);	\
-		else if (_sz == PUD_SIZE)			\
+		if (_sz >= P4D_SIZE)				\
+			tlb_flush_p4d_range(tlb, address, _sz);	\
+		else if (_sz >= PUD_SIZE)			\
 			tlb_flush_pud_range(tlb, address, _sz);	\
+		else if (_sz >= PMD_SIZE)			\
+			tlb_flush_pmd_range(tlb, address, _sz);	\
+		else						\
+			tlb_flush_pte_range(tlb, address, _sz);	\
 		__tlb_remove_tlb_entry(tlb, ptep, address);	\
 	} while (0)
 
diff --git a/include/linux/soc/qcom/qcom_aoss.h b/include/linux/soc/qcom/qcom_aoss.h
new file mode 100644
index 000000000000..3c2a82e606f8
--- /dev/null
+++ b/include/linux/soc/qcom/qcom_aoss.h
@@ -0,0 +1,38 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2021, The Linux Foundation. All rights reserved.
+ */
+
+#ifndef __QCOM_AOSS_H__
+#define __QCOM_AOSS_H__
+
+#include <linux/err.h>
+#include <linux/device.h>
+
+struct qmp;
+
+#if IS_ENABLED(CONFIG_QCOM_AOSS_QMP)
+
+int qmp_send(struct qmp *qmp, const void *data, size_t len);
+struct qmp *qmp_get(struct device *dev);
+void qmp_put(struct qmp *qmp);
+
+#else
+
+static inline int qmp_send(struct qmp *qmp, const void *data, size_t len)
+{
+	return -ENODEV;
+}
+
+static inline struct qmp *qmp_get(struct device *dev)
+{
+	return ERR_PTR(-ENODEV);
+}
+
+static inline void qmp_put(struct qmp *qmp)
+{
+}
+
+#endif
+
+#endif
diff --git a/include/linux/sunrpc/svc.h b/include/linux/sunrpc/svc.h
index 6263410c948a..01f09adccc63 100644
--- a/include/linux/sunrpc/svc.h
+++ b/include/linux/sunrpc/svc.h
@@ -384,6 +384,7 @@ struct svc_deferred_req {
 	size_t			addrlen;
 	struct sockaddr_storage	daddr;	/* where reply must come from */
 	size_t			daddrlen;
+	void			*xprt_ctxt;
 	struct cache_deferred_req handle;
 	size_t			xprt_hlen;
 	int			argslen;
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index ae6f4838ab75..6e5db4edc335 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -133,6 +133,8 @@ struct vfio_pci_core_device {
 	struct mutex		ioeventfds_lock;
 	struct list_head	ioeventfds_list;
 	struct vfio_pci_vf_token	*vf_token;
+	struct list_head		sriov_pfs_item;
+	struct vfio_pci_core_device	*sriov_pf_core_dev;
 	struct notifier_block	nb;
 	struct mutex		vma_lock;
 	struct list_head	vma_list;
diff --git a/include/net/ax25.h b/include/net/ax25.h
index 8b7eb46ad72d..aadff553e4b7 100644
--- a/include/net/ax25.h
+++ b/include/net/ax25.h
@@ -236,6 +236,7 @@ typedef struct ax25_dev {
 #if defined(CONFIG_AX25_DAMA_SLAVE) || defined(CONFIG_AX25_DAMA_MASTER)
 	ax25_dama_info		dama;
 #endif
+	refcount_t		refcount;
 } ax25_dev;
 
 typedef struct ax25_cb {
@@ -290,6 +291,17 @@ static __inline__ void ax25_cb_put(ax25_cb *ax25)
 	}
 }
 
+static inline void ax25_dev_hold(ax25_dev *ax25_dev)
+{
+	refcount_inc(&ax25_dev->refcount);
+}
+
+static inline void ax25_dev_put(ax25_dev *ax25_dev)
+{
+	if (refcount_dec_and_test(&ax25_dev->refcount)) {
+		kfree(ax25_dev);
+	}
+}
 static inline __be16 ax25_type_trans(struct sk_buff *skb, struct net_device *dev)
 {
 	skb->dev      = dev;
diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.h
index ffd386ea0dbb..c8d1c5e187e4 100644
--- a/include/net/flow_dissector.h
+++ b/include/net/flow_dissector.h
@@ -59,6 +59,8 @@ struct flow_dissector_key_vlan {
 		__be16	vlan_tci;
 	};
 	__be16	vlan_tpid;
+	__be16	vlan_eth_type;
+	u16	padding;
 };
 
 struct flow_dissector_mpls_lse {
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index c5d7810fd792..037c77fb5dc5 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -211,6 +211,8 @@ struct iscsi_cls_conn {
 	struct mutex ep_mutex;
 	struct iscsi_endpoint *ep;
 
+	/* Used when accessing flags and queueing work. */
+	spinlock_t lock;
 	unsigned long flags;
 	struct work_struct cleanup_work;
 
diff --git a/include/sound/core.h b/include/sound/core.h
index b7e9b58d3c78..6d4cc49584c6 100644
--- a/include/sound/core.h
+++ b/include/sound/core.h
@@ -284,6 +284,7 @@ int snd_card_disconnect(struct snd_card *card);
 void snd_card_disconnect_sync(struct snd_card *card);
 int snd_card_free(struct snd_card *card);
 int snd_card_free_when_closed(struct snd_card *card);
+int snd_card_free_on_error(struct device *dev, int ret);
 void snd_card_set_id(struct snd_card *card, const char *id);
 int snd_card_register(struct snd_card *card);
 int snd_card_info_init(void);
diff --git a/include/trace/events/sunrpc.h b/include/trace/events/sunrpc.h
index 7c48613c1830..6bcb8c7a3175 100644
--- a/include/trace/events/sunrpc.h
+++ b/include/trace/events/sunrpc.h
@@ -1924,17 +1924,18 @@ DECLARE_EVENT_CLASS(svc_deferred_event,
 	TP_STRUCT__entry(
 		__field(const void *, dr)
 		__field(u32, xid)
-		__string(addr, dr->xprt->xpt_remotebuf)
+		__array(__u8, addr, INET6_ADDRSTRLEN + 10)
 	),
 
 	TP_fast_assign(
 		__entry->dr = dr;
 		__entry->xid = be32_to_cpu(*(__be32 *)(dr->args +
 						       (dr->xprt_hlen>>2)));
-		__assign_str(addr, dr->xprt->xpt_remotebuf);
+		snprintf(__entry->addr, sizeof(__entry->addr) - 1,
+			 "%pISpc", (struct sockaddr *)&dr->addr);
 	),
 
-	TP_printk("addr=%s dr=%p xid=0x%08x", __get_str(addr), __entry->dr,
+	TP_printk("addr=%s dr=%p xid=0x%08x", __entry->addr, __entry->dr,
 		__entry->xid)
 );
 
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 407a2568f35e..5601216eb51b 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -70,7 +70,6 @@ struct cpuhp_cpu_state {
 	bool			rollback;
 	bool			single;
 	bool			bringup;
-	int			cpu;
 	struct hlist_node	*node;
 	struct hlist_node	*last;
 	enum cpuhp_state	cb_state;
@@ -474,7 +473,7 @@ static inline bool cpu_smt_allowed(unsigned int cpu) { return true; }
 #endif
 
 static inline enum cpuhp_state
-cpuhp_set_state(struct cpuhp_cpu_state *st, enum cpuhp_state target)
+cpuhp_set_state(int cpu, struct cpuhp_cpu_state *st, enum cpuhp_state target)
 {
 	enum cpuhp_state prev_state = st->state;
 	bool bringup = st->state < target;
@@ -485,14 +484,15 @@ cpuhp_set_state(struct cpuhp_cpu_state *st, enum cpuhp_state target)
 	st->target = target;
 	st->single = false;
 	st->bringup = bringup;
-	if (cpu_dying(st->cpu) != !bringup)
-		set_cpu_dying(st->cpu, !bringup);
+	if (cpu_dying(cpu) != !bringup)
+		set_cpu_dying(cpu, !bringup);
 
 	return prev_state;
 }
 
 static inline void
-cpuhp_reset_state(struct cpuhp_cpu_state *st, enum cpuhp_state prev_state)
+cpuhp_reset_state(int cpu, struct cpuhp_cpu_state *st,
+		  enum cpuhp_state prev_state)
 {
 	bool bringup = !st->bringup;
 
@@ -519,8 +519,8 @@ cpuhp_reset_state(struct cpuhp_cpu_state *st, enum cpuhp_state prev_state)
 	}
 
 	st->bringup = bringup;
-	if (cpu_dying(st->cpu) != !bringup)
-		set_cpu_dying(st->cpu, !bringup);
+	if (cpu_dying(cpu) != !bringup)
+		set_cpu_dying(cpu, !bringup);
 }
 
 /* Regular hotplug invocation of the AP hotplug thread */
@@ -540,15 +540,16 @@ static void __cpuhp_kick_ap(struct cpuhp_cpu_state *st)
 	wait_for_ap_thread(st, st->bringup);
 }
 
-static int cpuhp_kick_ap(struct cpuhp_cpu_state *st, enum cpuhp_state target)
+static int cpuhp_kick_ap(int cpu, struct cpuhp_cpu_state *st,
+			 enum cpuhp_state target)
 {
 	enum cpuhp_state prev_state;
 	int ret;
 
-	prev_state = cpuhp_set_state(st, target);
+	prev_state = cpuhp_set_state(cpu, st, target);
 	__cpuhp_kick_ap(st);
 	if ((ret = st->result)) {
-		cpuhp_reset_state(st, prev_state);
+		cpuhp_reset_state(cpu, st, prev_state);
 		__cpuhp_kick_ap(st);
 	}
 
@@ -580,7 +581,7 @@ static int bringup_wait_for_ap(unsigned int cpu)
 	if (st->target <= CPUHP_AP_ONLINE_IDLE)
 		return 0;
 
-	return cpuhp_kick_ap(st, st->target);
+	return cpuhp_kick_ap(cpu, st, st->target);
 }
 
 static int bringup_cpu(unsigned int cpu)
@@ -703,7 +704,7 @@ static int cpuhp_up_callbacks(unsigned int cpu, struct cpuhp_cpu_state *st,
 			 ret, cpu, cpuhp_get_step(st->state)->name,
 			 st->state);
 
-		cpuhp_reset_state(st, prev_state);
+		cpuhp_reset_state(cpu, st, prev_state);
 		if (can_rollback_cpu(st))
 			WARN_ON(cpuhp_invoke_callback_range(false, cpu, st,
 							    prev_state));
@@ -720,7 +721,6 @@ static void cpuhp_create(unsigned int cpu)
 
 	init_completion(&st->done_up);
 	init_completion(&st->done_down);
-	st->cpu = cpu;
 }
 
 static int cpuhp_should_run(unsigned int cpu)
@@ -874,7 +874,7 @@ static int cpuhp_kick_ap_work(unsigned int cpu)
 	cpuhp_lock_release(true);
 
 	trace_cpuhp_enter(cpu, st->target, prev_state, cpuhp_kick_ap_work);
-	ret = cpuhp_kick_ap(st, st->target);
+	ret = cpuhp_kick_ap(cpu, st, st->target);
 	trace_cpuhp_exit(cpu, st->state, prev_state, ret);
 
 	return ret;
@@ -1106,7 +1106,7 @@ static int cpuhp_down_callbacks(unsigned int cpu, struct cpuhp_cpu_state *st,
 			 ret, cpu, cpuhp_get_step(st->state)->name,
 			 st->state);
 
-		cpuhp_reset_state(st, prev_state);
+		cpuhp_reset_state(cpu, st, prev_state);
 
 		if (st->state < prev_state)
 			WARN_ON(cpuhp_invoke_callback_range(true, cpu, st,
@@ -1133,7 +1133,7 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen,
 
 	cpuhp_tasks_frozen = tasks_frozen;
 
-	prev_state = cpuhp_set_state(st, target);
+	prev_state = cpuhp_set_state(cpu, st, target);
 	/*
 	 * If the current CPU state is in the range of the AP hotplug thread,
 	 * then we need to kick the thread.
@@ -1164,7 +1164,7 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen,
 	ret = cpuhp_down_callbacks(cpu, st, target);
 	if (ret && st->state < prev_state) {
 		if (st->state == CPUHP_TEARDOWN_CPU) {
-			cpuhp_reset_state(st, prev_state);
+			cpuhp_reset_state(cpu, st, prev_state);
 			__cpuhp_kick_ap(st);
 		} else {
 			WARN(1, "DEAD callback error for CPU%d", cpu);
@@ -1351,7 +1351,7 @@ static int _cpu_up(unsigned int cpu, int tasks_frozen, enum cpuhp_state target)
 
 	cpuhp_tasks_frozen = tasks_frozen;
 
-	cpuhp_set_state(st, target);
+	cpuhp_set_state(cpu, st, target);
 	/*
 	 * If the current CPU state is in the range of the AP hotplug thread,
 	 * then we need to kick the thread once more.
diff --git a/kernel/dma/direct.h b/kernel/dma/direct.h
index 4632b0f4f72e..8a6cd53dbe8c 100644
--- a/kernel/dma/direct.h
+++ b/kernel/dma/direct.h
@@ -114,6 +114,7 @@ static inline void dma_direct_unmap_page(struct device *dev, dma_addr_t addr,
 		dma_direct_sync_single_for_cpu(dev, addr, size, dir);
 
 	if (unlikely(is_swiotlb_buffer(dev, phys)))
-		swiotlb_tbl_unmap_single(dev, phys, size, dir, attrs);
+		swiotlb_tbl_unmap_single(dev, phys, size, dir,
+					 attrs | DMA_ATTR_SKIP_CPU_SYNC);
 }
 #endif /* _KERNEL_DMA_DIRECT_H */
diff --git a/kernel/irq/affinity.c b/kernel/irq/affinity.c
index f7ff8919dc9b..fdf170404650 100644
--- a/kernel/irq/affinity.c
+++ b/kernel/irq/affinity.c
@@ -269,8 +269,9 @@ static int __irq_build_affinity_masks(unsigned int startvec,
 	 */
 	if (numvecs <= nodes) {
 		for_each_node_mask(n, nodemsk) {
-			cpumask_or(&masks[curvec].mask, &masks[curvec].mask,
-				   node_to_cpumask[n]);
+			/* Ensure that only CPUs which are in both masks are set */
+			cpumask_and(nmsk, cpu_mask, node_to_cpumask[n]);
+			cpumask_or(&masks[curvec].mask, &masks[curvec].mask, nmsk);
 			if (++curvec == last_affv)
 				curvec = firstvec;
 		}
diff --git a/kernel/smp.c b/kernel/smp.c
index f43ede0ab183..b68d63e965db 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -579,7 +579,7 @@ static void flush_smp_call_function_queue(bool warn_cpu_offline)
 
 	/* There shouldn't be any pending callbacks on an offline CPU. */
 	if (unlikely(warn_cpu_offline && !cpu_online(smp_processor_id()) &&
-		     !warned && !llist_empty(head))) {
+		     !warned && entry != NULL)) {
 		warned = true;
 		WARN(1, "IPI on offline CPU %d\n", smp_processor_id());
 
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 6bffe5af8cb1..19e6b861de97 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -186,7 +186,7 @@ static void tick_sched_do_timer(struct tick_sched *ts, ktime_t now)
 	 */
 	if (unlikely(tick_do_timer_cpu == TICK_DO_TIMER_NONE)) {
 #ifdef CONFIG_NO_HZ_FULL
-		WARN_ON(tick_nohz_full_running);
+		WARN_ON_ONCE(tick_nohz_full_running);
 #endif
 		tick_do_timer_cpu = cpu;
 	}
diff --git a/kernel/time/timer.c b/kernel/time/timer.c
index 85f1021ad459..9dd2a39cb3b0 100644
--- a/kernel/time/timer.c
+++ b/kernel/time/timer.c
@@ -1722,11 +1722,14 @@ static inline void __run_timers(struct timer_base *base)
 	       time_after_eq(jiffies, base->next_expiry)) {
 		levels = collect_expired_timers(base, heads);
 		/*
-		 * The only possible reason for not finding any expired
-		 * timer at this clk is that all matching timers have been
-		 * dequeued.
+		 * The two possible reasons for not finding any expired
+		 * timer at this clk are that all matching timers have been
+		 * dequeued or no timer has been queued since
+		 * base::next_expiry was set to base::clk +
+		 * NEXT_TIMER_MAX_DELTA.
 		 */
-		WARN_ON_ONCE(!levels && !base->next_expiry_recalc);
+		WARN_ON_ONCE(!levels && !base->next_expiry_recalc
+			     && base->timers_pending);
 		base->clk++;
 		base->next_expiry = __next_timer_interrupt(base);
 
diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index b78861b8e013..859303aae180 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1125,7 +1125,7 @@ EXPORT_SYMBOL(kmemleak_no_scan);
 void __ref kmemleak_alloc_phys(phys_addr_t phys, size_t size, int min_count,
 			       gfp_t gfp)
 {
-	if (!IS_ENABLED(CONFIG_HIGHMEM) || PHYS_PFN(phys) < max_low_pfn)
+	if (PHYS_PFN(phys) >= min_low_pfn && PHYS_PFN(phys) < max_low_pfn)
 		kmemleak_alloc(__va(phys), size, min_count, gfp);
 }
 EXPORT_SYMBOL(kmemleak_alloc_phys);
@@ -1139,7 +1139,7 @@ EXPORT_SYMBOL(kmemleak_alloc_phys);
  */
 void __ref kmemleak_free_part_phys(phys_addr_t phys, size_t size)
 {
-	if (!IS_ENABLED(CONFIG_HIGHMEM) || PHYS_PFN(phys) < max_low_pfn)
+	if (PHYS_PFN(phys) >= min_low_pfn && PHYS_PFN(phys) < max_low_pfn)
 		kmemleak_free_part(__va(phys), size);
 }
 EXPORT_SYMBOL(kmemleak_free_part_phys);
@@ -1151,7 +1151,7 @@ EXPORT_SYMBOL(kmemleak_free_part_phys);
  */
 void __ref kmemleak_not_leak_phys(phys_addr_t phys)
 {
-	if (!IS_ENABLED(CONFIG_HIGHMEM) || PHYS_PFN(phys) < max_low_pfn)
+	if (PHYS_PFN(phys) >= min_low_pfn && PHYS_PFN(phys) < max_low_pfn)
 		kmemleak_not_leak(__va(phys));
 }
 EXPORT_SYMBOL(kmemleak_not_leak_phys);
@@ -1163,7 +1163,7 @@ EXPORT_SYMBOL(kmemleak_not_leak_phys);
  */
 void __ref kmemleak_ignore_phys(phys_addr_t phys)
 {
-	if (!IS_ENABLED(CONFIG_HIGHMEM) || PHYS_PFN(phys) < max_low_pfn)
+	if (PHYS_PFN(phys) >= min_low_pfn && PHYS_PFN(phys) < max_low_pfn)
 		kmemleak_ignore(__va(phys));
 }
 EXPORT_SYMBOL(kmemleak_ignore_phys);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a4b0d7c1da56..a373cd6326b0 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6092,7 +6092,7 @@ static int build_zonerefs_node(pg_data_t *pgdat, struct zoneref *zonerefs)
 	do {
 		zone_type--;
 		zone = pgdat->node_zones + zone_type;
-		if (managed_zone(zone)) {
+		if (populated_zone(zone)) {
 			zoneref_set_zone(zone, &zonerefs[nr_zones++]);
 			check_highest_zone(zone_type);
 		}
diff --git a/mm/page_io.c b/mm/page_io.c
index c493ce9ebcf5..66c6fbb07bc4 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -50,54 +50,6 @@ void end_swap_bio_write(struct bio *bio)
 	bio_put(bio);
 }
 
-static void swap_slot_free_notify(struct page *page)
-{
-	struct swap_info_struct *sis;
-	struct gendisk *disk;
-	swp_entry_t entry;
-
-	/*
-	 * There is no guarantee that the page is in swap cache - the software
-	 * suspend code (at least) uses end_swap_bio_read() against a non-
-	 * swapcache page.  So we must check PG_swapcache before proceeding with
-	 * this optimization.
-	 */
-	if (unlikely(!PageSwapCache(page)))
-		return;
-
-	sis = page_swap_info(page);
-	if (data_race(!(sis->flags & SWP_BLKDEV)))
-		return;
-
-	/*
-	 * The swap subsystem performs lazy swap slot freeing,
-	 * expecting that the page will be swapped out again.
-	 * So we can avoid an unnecessary write if the page
-	 * isn't redirtied.
-	 * This is good for real swap storage because we can
-	 * reduce unnecessary I/O and enhance wear-leveling
-	 * if an SSD is used as the as swap device.
-	 * But if in-memory swap device (eg zram) is used,
-	 * this causes a duplicated copy between uncompressed
-	 * data in VM-owned memory and compressed data in
-	 * zram-owned memory.  So let's free zram-owned memory
-	 * and make the VM-owned decompressed page *dirty*,
-	 * so the page should be swapped out somewhere again if
-	 * we again wish to reclaim it.
-	 */
-	disk = sis->bdev->bd_disk;
-	entry.val = page_private(page);
-	if (disk->fops->swap_slot_free_notify && __swap_count(entry) == 1) {
-		unsigned long offset;
-
-		offset = swp_offset(entry);
-
-		SetPageDirty(page);
-		disk->fops->swap_slot_free_notify(sis->bdev,
-				offset);
-	}
-}
-
 static void end_swap_bio_read(struct bio *bio)
 {
 	struct page *page = bio_first_page_all(bio);
@@ -113,7 +65,6 @@ static void end_swap_bio_read(struct bio *bio)
 	}
 
 	SetPageUptodate(page);
-	swap_slot_free_notify(page);
 out:
 	unlock_page(page);
 	WRITE_ONCE(bio->bi_private, NULL);
@@ -392,11 +343,6 @@ int swap_readpage(struct page *page, bool synchronous)
 	if (sis->flags & SWP_SYNCHRONOUS_IO) {
 		ret = bdev_read_page(sis->bdev, swap_page_sector(page), page);
 		if (!ret) {
-			if (trylock_page(page)) {
-				swap_slot_free_notify(page);
-				unlock_page(page);
-			}
-
 			count_vm_event(PSWPIN);
 			goto out;
 		}
diff --git a/mm/secretmem.c b/mm/secretmem.c
index 22b310adb53d..5a62ef3bcfcf 100644
--- a/mm/secretmem.c
+++ b/mm/secretmem.c
@@ -158,6 +158,22 @@ const struct address_space_operations secretmem_aops = {
 	.isolate_page	= secretmem_isolate_page,
 };
 
+static int secretmem_setattr(struct user_namespace *mnt_userns,
+			     struct dentry *dentry, struct iattr *iattr)
+{
+	struct inode *inode = d_inode(dentry);
+	unsigned int ia_valid = iattr->ia_valid;
+
+	if ((ia_valid & ATTR_SIZE) && inode->i_size)
+		return -EINVAL;
+
+	return simple_setattr(mnt_userns, dentry, iattr);
+}
+
+static const struct inode_operations secretmem_iops = {
+	.setattr = secretmem_setattr,
+};
+
 static struct vfsmount *secretmem_mnt;
 
 static struct file *secretmem_file_create(unsigned long flags)
@@ -177,6 +193,7 @@ static struct file *secretmem_file_create(unsigned long flags)
 	mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
 	mapping_set_unevictable(inode->i_mapping);
 
+	inode->i_op = &secretmem_iops;
 	inode->i_mapping->a_ops = &secretmem_aops;
 
 	/* pretend we are a normal file with zero size */
diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 735f29512163..7b69503dc46a 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -89,17 +89,21 @@ static void ax25_kill_by_device(struct net_device *dev)
 			sk = s->sk;
 			if (!sk) {
 				spin_unlock_bh(&ax25_list_lock);
-				s->ax25_dev = NULL;
 				ax25_disconnect(s, ENETUNREACH);
+				s->ax25_dev = NULL;
 				spin_lock_bh(&ax25_list_lock);
 				goto again;
 			}
 			sock_hold(sk);
 			spin_unlock_bh(&ax25_list_lock);
 			lock_sock(sk);
+			ax25_disconnect(s, ENETUNREACH);
 			s->ax25_dev = NULL;
+			if (sk->sk_socket) {
+				dev_put(ax25_dev->dev);
+				ax25_dev_put(ax25_dev);
+			}
 			release_sock(sk);
-			ax25_disconnect(s, ENETUNREACH);
 			spin_lock_bh(&ax25_list_lock);
 			sock_put(sk);
 			/* The entry could have been deleted from the
@@ -365,21 +369,25 @@ static int ax25_ctl_ioctl(const unsigned int cmd, void __user *arg)
 	if (copy_from_user(&ax25_ctl, arg, sizeof(ax25_ctl)))
 		return -EFAULT;
 
-	if ((ax25_dev = ax25_addr_ax25dev(&ax25_ctl.port_addr)) == NULL)
-		return -ENODEV;
-
 	if (ax25_ctl.digi_count > AX25_MAX_DIGIS)
 		return -EINVAL;
 
 	if (ax25_ctl.arg > ULONG_MAX / HZ && ax25_ctl.cmd != AX25_KILL)
 		return -EINVAL;
 
+	ax25_dev = ax25_addr_ax25dev(&ax25_ctl.port_addr);
+	if (!ax25_dev)
+		return -ENODEV;
+
 	digi.ndigi = ax25_ctl.digi_count;
 	for (k = 0; k < digi.ndigi; k++)
 		digi.calls[k] = ax25_ctl.digi_addr[k];
 
-	if ((ax25 = ax25_find_cb(&ax25_ctl.source_addr, &ax25_ctl.dest_addr, &digi, ax25_dev->dev)) == NULL)
+	ax25 = ax25_find_cb(&ax25_ctl.source_addr, &ax25_ctl.dest_addr, &digi, ax25_dev->dev);
+	if (!ax25) {
+		ax25_dev_put(ax25_dev);
 		return -ENOTCONN;
+	}
 
 	switch (ax25_ctl.cmd) {
 	case AX25_KILL:
@@ -446,6 +454,7 @@ static int ax25_ctl_ioctl(const unsigned int cmd, void __user *arg)
 	  }
 
 out_put:
+	ax25_dev_put(ax25_dev);
 	ax25_cb_put(ax25);
 	return ret;
 
@@ -972,14 +981,16 @@ static int ax25_release(struct socket *sock)
 {
 	struct sock *sk = sock->sk;
 	ax25_cb *ax25;
+	ax25_dev *ax25_dev;
 
 	if (sk == NULL)
 		return 0;
 
 	sock_hold(sk);
-	sock_orphan(sk);
 	lock_sock(sk);
+	sock_orphan(sk);
 	ax25 = sk_to_ax25(sk);
+	ax25_dev = ax25->ax25_dev;
 
 	if (sk->sk_type == SOCK_SEQPACKET) {
 		switch (ax25->state) {
@@ -1041,6 +1052,15 @@ static int ax25_release(struct socket *sock)
 		sk->sk_state_change(sk);
 		ax25_destroy_socket(ax25);
 	}
+	if (ax25_dev) {
+		del_timer_sync(&ax25->timer);
+		del_timer_sync(&ax25->t1timer);
+		del_timer_sync(&ax25->t2timer);
+		del_timer_sync(&ax25->t3timer);
+		del_timer_sync(&ax25->idletimer);
+		dev_put(ax25_dev->dev);
+		ax25_dev_put(ax25_dev);
+	}
 
 	sock->sk   = NULL;
 	release_sock(sk);
@@ -1117,8 +1137,10 @@ static int ax25_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 		}
 	}
 
-	if (ax25_dev != NULL)
+	if (ax25_dev) {
 		ax25_fillin_cb(ax25, ax25_dev);
+		dev_hold(ax25_dev->dev);
+	}
 
 done:
 	ax25_cb_add(ax25);
diff --git a/net/ax25/ax25_dev.c b/net/ax25/ax25_dev.c
index 4ac2e0847652..d2e0cc67d91a 100644
--- a/net/ax25/ax25_dev.c
+++ b/net/ax25/ax25_dev.c
@@ -37,6 +37,7 @@ ax25_dev *ax25_addr_ax25dev(ax25_address *addr)
 	for (ax25_dev = ax25_dev_list; ax25_dev != NULL; ax25_dev = ax25_dev->next)
 		if (ax25cmp(addr, (ax25_address *)ax25_dev->dev->dev_addr) == 0) {
 			res = ax25_dev;
+			ax25_dev_hold(ax25_dev);
 		}
 	spin_unlock_bh(&ax25_dev_lock);
 
@@ -56,6 +57,7 @@ void ax25_dev_device_up(struct net_device *dev)
 		return;
 	}
 
+	refcount_set(&ax25_dev->refcount, 1);
 	dev->ax25_ptr     = ax25_dev;
 	ax25_dev->dev     = dev;
 	dev_hold(dev);
@@ -84,6 +86,7 @@ void ax25_dev_device_up(struct net_device *dev)
 	ax25_dev->next = ax25_dev_list;
 	ax25_dev_list  = ax25_dev;
 	spin_unlock_bh(&ax25_dev_lock);
+	ax25_dev_hold(ax25_dev);
 
 	ax25_register_dev_sysctl(ax25_dev);
 }
@@ -113,9 +116,10 @@ void ax25_dev_device_down(struct net_device *dev)
 	if ((s = ax25_dev_list) == ax25_dev) {
 		ax25_dev_list = s->next;
 		spin_unlock_bh(&ax25_dev_lock);
+		ax25_dev_put(ax25_dev);
 		dev->ax25_ptr = NULL;
 		dev_put(dev);
-		kfree(ax25_dev);
+		ax25_dev_put(ax25_dev);
 		return;
 	}
 
@@ -123,9 +127,10 @@ void ax25_dev_device_down(struct net_device *dev)
 		if (s->next == ax25_dev) {
 			s->next = ax25_dev->next;
 			spin_unlock_bh(&ax25_dev_lock);
+			ax25_dev_put(ax25_dev);
 			dev->ax25_ptr = NULL;
 			dev_put(dev);
-			kfree(ax25_dev);
+			ax25_dev_put(ax25_dev);
 			return;
 		}
 
@@ -133,6 +138,7 @@ void ax25_dev_device_down(struct net_device *dev)
 	}
 	spin_unlock_bh(&ax25_dev_lock);
 	dev->ax25_ptr = NULL;
+	ax25_dev_put(ax25_dev);
 }
 
 int ax25_fwd_ioctl(unsigned int cmd, struct ax25_fwd_struct *fwd)
@@ -144,20 +150,32 @@ int ax25_fwd_ioctl(unsigned int cmd, struct ax25_fwd_struct *fwd)
 
 	switch (cmd) {
 	case SIOCAX25ADDFWD:
-		if ((fwd_dev = ax25_addr_ax25dev(&fwd->port_to)) == NULL)
+		fwd_dev = ax25_addr_ax25dev(&fwd->port_to);
+		if (!fwd_dev) {
+			ax25_dev_put(ax25_dev);
 			return -EINVAL;
-		if (ax25_dev->forward != NULL)
+		}
+		if (ax25_dev->forward) {
+			ax25_dev_put(fwd_dev);
+			ax25_dev_put(ax25_dev);
 			return -EINVAL;
+		}
 		ax25_dev->forward = fwd_dev->dev;
+		ax25_dev_put(fwd_dev);
+		ax25_dev_put(ax25_dev);
 		break;
 
 	case SIOCAX25DELFWD:
-		if (ax25_dev->forward == NULL)
+		if (!ax25_dev->forward) {
+			ax25_dev_put(ax25_dev);
 			return -EINVAL;
+		}
 		ax25_dev->forward = NULL;
+		ax25_dev_put(ax25_dev);
 		break;
 
 	default:
+		ax25_dev_put(ax25_dev);
 		return -EINVAL;
 	}
 
diff --git a/net/ax25/ax25_route.c b/net/ax25/ax25_route.c
index d0b2e094bd55..9751207f7757 100644
--- a/net/ax25/ax25_route.c
+++ b/net/ax25/ax25_route.c
@@ -75,11 +75,13 @@ static int __must_check ax25_rt_add(struct ax25_routes_struct *route)
 	ax25_dev *ax25_dev;
 	int i;
 
-	if ((ax25_dev = ax25_addr_ax25dev(&route->port_addr)) == NULL)
-		return -EINVAL;
 	if (route->digi_count > AX25_MAX_DIGIS)
 		return -EINVAL;
 
+	ax25_dev = ax25_addr_ax25dev(&route->port_addr);
+	if (!ax25_dev)
+		return -EINVAL;
+
 	write_lock_bh(&ax25_route_lock);
 
 	ax25_rt = ax25_route_list;
@@ -91,6 +93,7 @@ static int __must_check ax25_rt_add(struct ax25_routes_struct *route)
 			if (route->digi_count != 0) {
 				if ((ax25_rt->digipeat = kmalloc(sizeof(ax25_digi), GFP_ATOMIC)) == NULL) {
 					write_unlock_bh(&ax25_route_lock);
+					ax25_dev_put(ax25_dev);
 					return -ENOMEM;
 				}
 				ax25_rt->digipeat->lastrepeat = -1;
@@ -101,6 +104,7 @@ static int __must_check ax25_rt_add(struct ax25_routes_struct *route)
 				}
 			}
 			write_unlock_bh(&ax25_route_lock);
+			ax25_dev_put(ax25_dev);
 			return 0;
 		}
 		ax25_rt = ax25_rt->next;
@@ -108,6 +112,7 @@ static int __must_check ax25_rt_add(struct ax25_routes_struct *route)
 
 	if ((ax25_rt = kmalloc(sizeof(ax25_route), GFP_ATOMIC)) == NULL) {
 		write_unlock_bh(&ax25_route_lock);
+		ax25_dev_put(ax25_dev);
 		return -ENOMEM;
 	}
 
@@ -120,6 +125,7 @@ static int __must_check ax25_rt_add(struct ax25_routes_struct *route)
 		if ((ax25_rt->digipeat = kmalloc(sizeof(ax25_digi), GFP_ATOMIC)) == NULL) {
 			write_unlock_bh(&ax25_route_lock);
 			kfree(ax25_rt);
+			ax25_dev_put(ax25_dev);
 			return -ENOMEM;
 		}
 		ax25_rt->digipeat->lastrepeat = -1;
@@ -132,6 +138,7 @@ static int __must_check ax25_rt_add(struct ax25_routes_struct *route)
 	ax25_rt->next   = ax25_route_list;
 	ax25_route_list = ax25_rt;
 	write_unlock_bh(&ax25_route_lock);
+	ax25_dev_put(ax25_dev);
 
 	return 0;
 }
@@ -173,6 +180,7 @@ static int ax25_rt_del(struct ax25_routes_struct *route)
 		}
 	}
 	write_unlock_bh(&ax25_route_lock);
+	ax25_dev_put(ax25_dev);
 
 	return 0;
 }
@@ -215,6 +223,7 @@ static int ax25_rt_opt(struct ax25_route_opt_struct *rt_option)
 
 out:
 	write_unlock_bh(&ax25_route_lock);
+	ax25_dev_put(ax25_dev);
 	return err;
 }
 
diff --git a/net/ax25/ax25_subr.c b/net/ax25/ax25_subr.c
index 15ab812c4fe4..3a476e4f6cd0 100644
--- a/net/ax25/ax25_subr.c
+++ b/net/ax25/ax25_subr.c
@@ -261,12 +261,20 @@ void ax25_disconnect(ax25_cb *ax25, int reason)
 {
 	ax25_clear_queues(ax25);
 
-	if (!ax25->sk || !sock_flag(ax25->sk, SOCK_DESTROY))
-		ax25_stop_heartbeat(ax25);
-	ax25_stop_t1timer(ax25);
-	ax25_stop_t2timer(ax25);
-	ax25_stop_t3timer(ax25);
-	ax25_stop_idletimer(ax25);
+	if (reason == ENETUNREACH) {
+		del_timer_sync(&ax25->timer);
+		del_timer_sync(&ax25->t1timer);
+		del_timer_sync(&ax25->t2timer);
+		del_timer_sync(&ax25->t3timer);
+		del_timer_sync(&ax25->idletimer);
+	} else {
+		if (!ax25->sk || !sock_flag(ax25->sk, SOCK_DESTROY))
+			ax25_stop_heartbeat(ax25);
+		ax25_stop_t1timer(ax25);
+		ax25_stop_t2timer(ax25);
+		ax25_stop_t3timer(ax25);
+		ax25_stop_idletimer(ax25);
+	}
 
 	ax25->state = AX25_STATE_0;
 
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index edffdaa875f1..bc50bd331d5b 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -1181,6 +1181,7 @@ bool __skb_flow_dissect(const struct net *net,
 					 VLAN_PRIO_MASK) >> VLAN_PRIO_SHIFT;
 			}
 			key_vlan->vlan_tpid = saved_vlan_tpid;
+			key_vlan->vlan_eth_type = proto;
 		}
 
 		fdret = FLOW_DISSECT_RET_PROTO_AGAIN;
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 8aaf9cf3d74a..04c3cb4c5fec 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -485,7 +485,7 @@ int ip6_forward(struct sk_buff *skb)
 		goto drop;
 
 	if (!net->ipv6.devconf_all->disable_policy &&
-	    !idev->cnf.disable_policy &&
+	    (!idev || !idev->cnf.disable_policy) &&
 	    !xfrm6_policy_check(NULL, XFRM_POLICY_FWD, skb)) {
 		__IP6_INC_STATS(net, idev, IPSTATS_MIB_INDISCARDS);
 		goto drop;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 3e7f97a70721..2feb88ffcd81 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9208,7 +9208,7 @@ int nft_parse_u32_check(const struct nlattr *attr, int max, u32 *dest)
 }
 EXPORT_SYMBOL_GPL(nft_parse_u32_check);
 
-static unsigned int nft_parse_register(const struct nlattr *attr, u32 *preg)
+static int nft_parse_register(const struct nlattr *attr, u32 *preg)
 {
 	unsigned int reg;
 
diff --git a/net/netfilter/nft_socket.c b/net/netfilter/nft_socket.c
index d601974c9d2e..b8f011145765 100644
--- a/net/netfilter/nft_socket.c
+++ b/net/netfilter/nft_socket.c
@@ -36,12 +36,11 @@ static void nft_socket_wildcard(const struct nft_pktinfo *pkt,
 
 #ifdef CONFIG_SOCK_CGROUP_DATA
 static noinline bool
-nft_sock_get_eval_cgroupv2(u32 *dest, const struct nft_pktinfo *pkt, u32 level)
+nft_sock_get_eval_cgroupv2(u32 *dest, struct sock *sk, const struct nft_pktinfo *pkt, u32 level)
 {
-	struct sock *sk = skb_to_full_sk(pkt->skb);
 	struct cgroup *cgrp;
 
-	if (!sk || !sk_fullsock(sk) || !net_eq(nft_net(pkt), sock_net(sk)))
+	if (!sk_fullsock(sk))
 		return false;
 
 	cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
@@ -108,7 +107,7 @@ static void nft_socket_eval(const struct nft_expr *expr,
 		break;
 #ifdef CONFIG_SOCK_CGROUP_DATA
 	case NFT_SOCKET_CGROUPV2:
-		if (!nft_sock_get_eval_cgroupv2(dest, pkt, priv->level)) {
+		if (!nft_sock_get_eval_cgroupv2(dest, sk, pkt, priv->level)) {
 			regs->verdict.code = NFT_BREAK;
 			return;
 		}
diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index e41e2e9e5498..189c9f428a3c 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -560,6 +560,10 @@ static int nci_close_device(struct nci_dev *ndev)
 	mutex_lock(&ndev->req_lock);
 
 	if (!test_and_clear_bit(NCI_UP, &ndev->flags)) {
+		/* Need to flush the cmd wq in case
+		 * there is a queued/running cmd_work
+		 */
+		flush_workqueue(ndev->cmd_wq);
 		del_timer_sync(&ndev->cmd_timer);
 		del_timer_sync(&ndev->data_timer);
 		mutex_unlock(&ndev->req_lock);
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index cd44cac7fbcf..4b552c10e7b9 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -1653,10 +1653,10 @@ static int tcf_chain_tp_insert(struct tcf_chain *chain,
 	if (chain->flushing)
 		return -EAGAIN;
 
+	RCU_INIT_POINTER(tp->next, tcf_chain_tp_prev(chain, chain_info));
 	if (*chain_info->pprev == chain->filter_chain)
 		tcf_chain0_head_change(chain, tp);
 	tcf_proto_get(tp);
-	RCU_INIT_POINTER(tp->next, tcf_chain_tp_prev(chain, chain_info));
 	rcu_assign_pointer(*chain_info->pprev, tp);
 
 	return 0;
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 709348262410..32b03a13f9b2 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -1004,6 +1004,7 @@ static int fl_set_key_mpls(struct nlattr **tb,
 static void fl_set_key_vlan(struct nlattr **tb,
 			    __be16 ethertype,
 			    int vlan_id_key, int vlan_prio_key,
+			    int vlan_next_eth_type_key,
 			    struct flow_dissector_key_vlan *key_val,
 			    struct flow_dissector_key_vlan *key_mask)
 {
@@ -1022,6 +1023,11 @@ static void fl_set_key_vlan(struct nlattr **tb,
 	}
 	key_val->vlan_tpid = ethertype;
 	key_mask->vlan_tpid = cpu_to_be16(~0);
+	if (tb[vlan_next_eth_type_key]) {
+		key_val->vlan_eth_type =
+			nla_get_be16(tb[vlan_next_eth_type_key]);
+		key_mask->vlan_eth_type = cpu_to_be16(~0);
+	}
 }
 
 static void fl_set_key_flag(u32 flower_key, u32 flower_mask,
@@ -1518,8 +1524,9 @@ static int fl_set_key(struct net *net, struct nlattr **tb,
 
 		if (eth_type_vlan(ethertype)) {
 			fl_set_key_vlan(tb, ethertype, TCA_FLOWER_KEY_VLAN_ID,
-					TCA_FLOWER_KEY_VLAN_PRIO, &key->vlan,
-					&mask->vlan);
+					TCA_FLOWER_KEY_VLAN_PRIO,
+					TCA_FLOWER_KEY_VLAN_ETH_TYPE,
+					&key->vlan, &mask->vlan);
 
 			if (tb[TCA_FLOWER_KEY_VLAN_ETH_TYPE]) {
 				ethertype = nla_get_be16(tb[TCA_FLOWER_KEY_VLAN_ETH_TYPE]);
@@ -1527,6 +1534,7 @@ static int fl_set_key(struct net *net, struct nlattr **tb,
 					fl_set_key_vlan(tb, ethertype,
 							TCA_FLOWER_KEY_CVLAN_ID,
 							TCA_FLOWER_KEY_CVLAN_PRIO,
+							TCA_FLOWER_KEY_CVLAN_ETH_TYPE,
 							&key->cvlan, &mask->cvlan);
 					fl_set_key_val(tb, &key->basic.n_proto,
 						       TCA_FLOWER_KEY_CVLAN_ETH_TYPE,
@@ -2882,13 +2890,13 @@ static int fl_dump_key(struct sk_buff *skb, struct net *net,
 		goto nla_put_failure;
 
 	if (mask->basic.n_proto) {
-		if (mask->cvlan.vlan_tpid) {
+		if (mask->cvlan.vlan_eth_type) {
 			if (nla_put_be16(skb, TCA_FLOWER_KEY_CVLAN_ETH_TYPE,
 					 key->basic.n_proto))
 				goto nla_put_failure;
-		} else if (mask->vlan.vlan_tpid) {
+		} else if (mask->vlan.vlan_eth_type) {
 			if (nla_put_be16(skb, TCA_FLOWER_KEY_VLAN_ETH_TYPE,
-					 key->basic.n_proto))
+					 key->vlan.vlan_eth_type))
 				goto nla_put_failure;
 		}
 	}
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index a66398fb2d6d..474ba4db5de2 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -417,7 +417,8 @@ static int taprio_enqueue_one(struct sk_buff *skb, struct Qdisc *sch,
 {
 	struct taprio_sched *q = qdisc_priv(sch);
 
-	if (skb->sk && sock_flag(skb->sk, SOCK_TXTIME)) {
+	/* sk_flags are only safe to use on full sockets. */
+	if (skb->sk && sk_fullsock(skb->sk) && sock_flag(skb->sk, SOCK_TXTIME)) {
 		if (!is_valid_interval(skb, sch))
 			return qdisc_drop(skb, sch, to_free);
 	} else if (TXTIME_ASSIST_IS_ENABLED(q->flags)) {
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 6b3c32264cbc..5f6e6a6e91b3 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -5641,7 +5641,7 @@ int sctp_do_peeloff(struct sock *sk, sctp_assoc_t id, struct socket **sockp)
 	 * Set the daddr and initialize id to something more random and also
 	 * copy over any ip options.
 	 */
-	sp->pf->to_sk_daddr(&asoc->peer.primary_addr, sk);
+	sp->pf->to_sk_daddr(&asoc->peer.primary_addr, sock->sk);
 	sp->pf->copy_ip_options(sk, sock->sk);
 
 	/* Populate the fields of the newsk from the oldsk and migrate the
diff --git a/net/smc/smc_pnet.c b/net/smc/smc_pnet.c
index 707615809e5a..79ee0618d919 100644
--- a/net/smc/smc_pnet.c
+++ b/net/smc/smc_pnet.c
@@ -310,8 +310,9 @@ static struct smc_ib_device *smc_pnet_find_ib(char *ib_name)
 	list_for_each_entry(ibdev, &smc_ib_devices.list, list) {
 		if (!strncmp(ibdev->ibdev->name, ib_name,
 			     sizeof(ibdev->ibdev->name)) ||
-		    !strncmp(dev_name(ibdev->ibdev->dev.parent), ib_name,
-			     IB_DEVICE_NAME_MAX - 1)) {
+		    (ibdev->ibdev->dev.parent &&
+		     !strncmp(dev_name(ibdev->ibdev->dev.parent), ib_name,
+			     IB_DEVICE_NAME_MAX - 1))) {
 			goto out;
 		}
 	}
diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
index d4b663401be1..935bba065636 100644
--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -1213,6 +1213,8 @@ static struct cache_deferred_req *svc_defer(struct cache_req *req)
 		dr->daddr = rqstp->rq_daddr;
 		dr->argslen = rqstp->rq_arg.len >> 2;
 		dr->xprt_hlen = rqstp->rq_xprt_hlen;
+		dr->xprt_ctxt = rqstp->rq_xprt_ctxt;
+		rqstp->rq_xprt_ctxt = NULL;
 
 		/* back up head to the start of the buffer and copy */
 		skip = rqstp->rq_arg.len - rqstp->rq_arg.head[0].iov_len;
@@ -1251,6 +1253,7 @@ static noinline int svc_deferred_recv(struct svc_rqst *rqstp)
 	rqstp->rq_xprt_hlen   = dr->xprt_hlen;
 	rqstp->rq_daddr       = dr->daddr;
 	rqstp->rq_respages    = rqstp->rq_pages;
+	rqstp->rq_xprt_ctxt   = dr->xprt_ctxt;
 	svc_xprt_received(rqstp->rq_xprt);
 	return (dr->argslen<<2) - dr->xprt_hlen;
 }
diff --git a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
index 6be23ce7a93d..387a5da09daf 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
@@ -826,7 +826,7 @@ int svc_rdma_recvfrom(struct svc_rqst *rqstp)
 		goto out_err;
 	if (ret == 0)
 		goto out_drop;
-	rqstp->rq_xprt_hlen = ret;
+	rqstp->rq_xprt_hlen = 0;
 
 	if (svc_rdma_is_reverse_direction_reply(xprt, ctxt))
 		goto out_backchannel;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 2f9ead98a9da..fe9cade6b4fb 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -509,7 +509,8 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 				   .len = IEEE80211_MAX_MESH_ID_LEN },
 	[NL80211_ATTR_MPATH_NEXT_HOP] = NLA_POLICY_ETH_ADDR_COMPAT,
 
-	[NL80211_ATTR_REG_ALPHA2] = { .type = NLA_STRING, .len = 2 },
+	/* allow 3 for NUL-termination, we used to declare this NLA_STRING */
+	[NL80211_ATTR_REG_ALPHA2] = NLA_POLICY_RANGE(NLA_BINARY, 2, 3),
 	[NL80211_ATTR_REG_RULES] = { .type = NLA_NESTED },
 
 	[NL80211_ATTR_BSS_CTS_PROT] = { .type = NLA_U8 },
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 8e1e578d64bc..1a8b76c9dd56 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1978,11 +1978,13 @@ cfg80211_inform_single_bss_data(struct wiphy *wiphy,
 		/* this is a nontransmitting bss, we need to add it to
 		 * transmitting bss' list if it is not there
 		 */
+		spin_lock_bh(&rdev->bss_lock);
 		if (cfg80211_add_nontrans_list(non_tx_data->tx_bss,
 					       &res->pub)) {
 			if (__cfg80211_unlink_bss(rdev, res))
 				rdev->bss_generation++;
 		}
+		spin_unlock_bh(&rdev->bss_lock);
 	}
 
 	trace_cfg80211_return_bss(&res->pub);
diff --git a/scripts/gcc-plugins/latent_entropy_plugin.c b/scripts/gcc-plugins/latent_entropy_plugin.c
index 589454bce930..8425da41de0d 100644
--- a/scripts/gcc-plugins/latent_entropy_plugin.c
+++ b/scripts/gcc-plugins/latent_entropy_plugin.c
@@ -86,25 +86,31 @@ static struct plugin_info latent_entropy_plugin_info = {
 	.help		= "disable\tturn off latent entropy instrumentation\n",
 };
 
-static unsigned HOST_WIDE_INT seed;
-/*
- * get_random_seed() (this is a GCC function) generates the seed.
- * This is a simple random generator without any cryptographic security because
- * the entropy doesn't come from here.
- */
+static unsigned HOST_WIDE_INT deterministic_seed;
+static unsigned HOST_WIDE_INT rnd_buf[32];
+static size_t rnd_idx = ARRAY_SIZE(rnd_buf);
+static int urandom_fd = -1;
+
 static unsigned HOST_WIDE_INT get_random_const(void)
 {
-	unsigned int i;
-	unsigned HOST_WIDE_INT ret = 0;
-
-	for (i = 0; i < 8 * sizeof(ret); i++) {
-		ret = (ret << 1) | (seed & 1);
-		seed >>= 1;
-		if (ret & 1)
-			seed ^= 0xD800000000000000ULL;
+	if (deterministic_seed) {
+		unsigned HOST_WIDE_INT w = deterministic_seed;
+		w ^= w << 13;
+		w ^= w >> 7;
+		w ^= w << 17;
+		deterministic_seed = w;
+		return deterministic_seed;
 	}
 
-	return ret;
+	if (urandom_fd < 0) {
+		urandom_fd = open("/dev/urandom", O_RDONLY);
+		gcc_assert(urandom_fd >= 0);
+	}
+	if (rnd_idx >= ARRAY_SIZE(rnd_buf)) {
+		gcc_assert(read(urandom_fd, rnd_buf, sizeof(rnd_buf)) == sizeof(rnd_buf));
+		rnd_idx = 0;
+	}
+	return rnd_buf[rnd_idx++];
 }
 
 static tree tree_get_random_const(tree type)
@@ -537,8 +543,6 @@ static void latent_entropy_start_unit(void *gcc_data __unused,
 	tree type, id;
 	int quals;
 
-	seed = get_random_seed(false);
-
 	if (in_lto_p)
 		return;
 
@@ -573,6 +577,12 @@ __visible int plugin_init(struct plugin_name_args *plugin_info,
 	const struct plugin_argument * const argv = plugin_info->argv;
 	int i;
 
+	/*
+	 * Call get_random_seed() with noinit=true, so that this returns
+	 * 0 in the case where no seed has been passed via -frandom-seed.
+	 */
+	deterministic_seed = get_random_seed(true);
+
 	static const struct ggc_root_tab gt_ggc_r_gt_latent_entropy[] = {
 		{
 			.base = &latent_entropy_decl,
diff --git a/sound/core/init.c b/sound/core/init.c
index ac335f5906c6..362588e3a275 100644
--- a/sound/core/init.c
+++ b/sound/core/init.c
@@ -209,6 +209,12 @@ static void __snd_card_release(struct device *dev, void *data)
  * snd_card_register(), the very first devres action to call snd_card_free()
  * is added automatically.  In that way, the resource disconnection is assured
  * at first, then released in the expected order.
+ *
+ * If an error happens at the probe before snd_card_register() is called and
+ * there have been other devres resources, you'd need to free the card manually
+ * via snd_card_free() call in the error; otherwise it may lead to UAF due to
+ * devres call orders.  You can use snd_card_free_on_error() helper for
+ * handling it more easily.
  */
 int snd_devm_card_new(struct device *parent, int idx, const char *xid,
 		      struct module *module, size_t extra_size,
@@ -235,6 +241,28 @@ int snd_devm_card_new(struct device *parent, int idx, const char *xid,
 }
 EXPORT_SYMBOL_GPL(snd_devm_card_new);
 
+/**
+ * snd_card_free_on_error - a small helper for handling devm probe errors
+ * @dev: the managed device object
+ * @ret: the return code from the probe callback
+ *
+ * This function handles the explicit snd_card_free() call at the error from
+ * the probe callback.  It's just a small helper for simplifying the error
+ * handling with the managed devices.
+ */
+int snd_card_free_on_error(struct device *dev, int ret)
+{
+	struct snd_card *card;
+
+	if (!ret)
+		return 0;
+	card = devres_find(dev, __snd_card_release, NULL, NULL);
+	if (card)
+		snd_card_free(card);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(snd_card_free_on_error);
+
 static int snd_card_init(struct snd_card *card, struct device *parent,
 			 int idx, const char *xid, struct module *module,
 			 size_t extra_size)
diff --git a/sound/core/pcm_misc.c b/sound/core/pcm_misc.c
index 4866aed97aac..5588b6a1ee8b 100644
--- a/sound/core/pcm_misc.c
+++ b/sound/core/pcm_misc.c
@@ -433,7 +433,7 @@ int snd_pcm_format_set_silence(snd_pcm_format_t format, void *data, unsigned int
 		return 0;
 	width = pcm_formats[(INT)format].phys; /* physical width */
 	pat = pcm_formats[(INT)format].silence;
-	if (! width)
+	if (!width || !pat)
 		return -EINVAL;
 	/* signed or 1 byte data */
 	if (pcm_formats[(INT)format].signd == 1 || width <= 8) {
diff --git a/sound/drivers/mtpav.c b/sound/drivers/mtpav.c
index 11235baaf6fa..f212f233ea61 100644
--- a/sound/drivers/mtpav.c
+++ b/sound/drivers/mtpav.c
@@ -693,8 +693,6 @@ static int snd_mtpav_probe(struct platform_device *dev)
 	mtp_card->outmidihwport = 0xffffffff;
 	timer_setup(&mtp_card->timer, snd_mtpav_output_timer, 0);
 
-	card->private_free = snd_mtpav_free;
-
 	err = snd_mtpav_get_RAWMIDI(mtp_card);
 	if (err < 0)
 		return err;
@@ -716,6 +714,8 @@ static int snd_mtpav_probe(struct platform_device *dev)
 	if (err < 0)
 		return err;
 
+	card->private_free = snd_mtpav_free;
+
 	platform_set_drvdata(dev, card);
 	printk(KERN_INFO "Motu MidiTimePiece on parallel port irq: %d ioport: 0x%lx\n", irq, port);
 	return 0;
diff --git a/sound/isa/galaxy/galaxy.c b/sound/isa/galaxy/galaxy.c
index ea001c80149d..3164eb8510fa 100644
--- a/sound/isa/galaxy/galaxy.c
+++ b/sound/isa/galaxy/galaxy.c
@@ -478,7 +478,7 @@ static void snd_galaxy_free(struct snd_card *card)
 		galaxy_set_config(galaxy, galaxy->config);
 }
 
-static int snd_galaxy_probe(struct device *dev, unsigned int n)
+static int __snd_galaxy_probe(struct device *dev, unsigned int n)
 {
 	struct snd_galaxy *galaxy;
 	struct snd_wss *chip;
@@ -598,6 +598,11 @@ static int snd_galaxy_probe(struct device *dev, unsigned int n)
 	return 0;
 }
 
+static int snd_galaxy_probe(struct device *dev, unsigned int n)
+{
+	return snd_card_free_on_error(dev, __snd_galaxy_probe(dev, n));
+}
+
 static struct isa_driver snd_galaxy_driver = {
 	.match		= snd_galaxy_match,
 	.probe		= snd_galaxy_probe,
diff --git a/sound/isa/sc6000.c b/sound/isa/sc6000.c
index 26ab7ff80768..60398fced046 100644
--- a/sound/isa/sc6000.c
+++ b/sound/isa/sc6000.c
@@ -537,7 +537,7 @@ static void snd_sc6000_free(struct snd_card *card)
 		sc6000_setup_board(vport, 0);
 }
 
-static int snd_sc6000_probe(struct device *devptr, unsigned int dev)
+static int __snd_sc6000_probe(struct device *devptr, unsigned int dev)
 {
 	static const int possible_irqs[] = { 5, 7, 9, 10, 11, -1 };
 	static const int possible_dmas[] = { 1, 3, 0, -1 };
@@ -662,6 +662,11 @@ static int snd_sc6000_probe(struct device *devptr, unsigned int dev)
 	return 0;
 }
 
+static int snd_sc6000_probe(struct device *devptr, unsigned int dev)
+{
+	return snd_card_free_on_error(devptr, __snd_sc6000_probe(devptr, dev));
+}
+
 static struct isa_driver snd_sc6000_driver = {
 	.match		= snd_sc6000_match,
 	.probe		= snd_sc6000_probe,
diff --git a/sound/pci/ad1889.c b/sound/pci/ad1889.c
index bba4dae8dcc7..50e30704bf6f 100644
--- a/sound/pci/ad1889.c
+++ b/sound/pci/ad1889.c
@@ -844,8 +844,8 @@ snd_ad1889_create(struct snd_card *card, struct pci_dev *pci)
 }
 
 static int
-snd_ad1889_probe(struct pci_dev *pci,
-		 const struct pci_device_id *pci_id)
+__snd_ad1889_probe(struct pci_dev *pci,
+		   const struct pci_device_id *pci_id)
 {
 	int err;
 	static int devno;
@@ -904,6 +904,12 @@ snd_ad1889_probe(struct pci_dev *pci,
 	return 0;
 }
 
+static int snd_ad1889_probe(struct pci_dev *pci,
+			    const struct pci_device_id *pci_id)
+{
+	return snd_card_free_on_error(&pci->dev, __snd_ad1889_probe(pci, pci_id));
+}
+
 static const struct pci_device_id snd_ad1889_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_ANALOG_DEVICES, PCI_DEVICE_ID_AD1889JS) },
 	{ 0, },
diff --git a/sound/pci/ali5451/ali5451.c b/sound/pci/ali5451/ali5451.c
index 92eb59db106d..2378a39abaeb 100644
--- a/sound/pci/ali5451/ali5451.c
+++ b/sound/pci/ali5451/ali5451.c
@@ -2124,8 +2124,8 @@ static int snd_ali_create(struct snd_card *card,
 	return 0;
 }
 
-static int snd_ali_probe(struct pci_dev *pci,
-			 const struct pci_device_id *pci_id)
+static int __snd_ali_probe(struct pci_dev *pci,
+			   const struct pci_device_id *pci_id)
 {
 	struct snd_card *card;
 	struct snd_ali *codec;
@@ -2170,6 +2170,12 @@ static int snd_ali_probe(struct pci_dev *pci,
 	return 0;
 }
 
+static int snd_ali_probe(struct pci_dev *pci,
+			 const struct pci_device_id *pci_id)
+{
+	return snd_card_free_on_error(&pci->dev, __snd_ali_probe(pci, pci_id));
+}
+
 static struct pci_driver ali5451_driver = {
 	.name = KBUILD_MODNAME,
 	.id_table = snd_ali_ids,
diff --git a/sound/pci/als300.c b/sound/pci/als300.c
index b86565dcdbe4..c70aff060120 100644
--- a/sound/pci/als300.c
+++ b/sound/pci/als300.c
@@ -708,7 +708,7 @@ static int snd_als300_probe(struct pci_dev *pci,
 
 	err = snd_als300_create(card, pci, chip_type);
 	if (err < 0)
-		return err;
+		goto error;
 
 	strcpy(card->driver, "ALS300");
 	if (chip->chip_type == DEVICE_ALS300_PLUS)
@@ -723,11 +723,15 @@ static int snd_als300_probe(struct pci_dev *pci,
 
 	err = snd_card_register(card);
 	if (err < 0)
-		return err;
+		goto error;
 
 	pci_set_drvdata(pci, card);
 	dev++;
 	return 0;
+
+ error:
+	snd_card_free(card);
+	return err;
 }
 
 static struct pci_driver als300_driver = {
diff --git a/sound/pci/als4000.c b/sound/pci/als4000.c
index 535eccd124be..f33aeb692a11 100644
--- a/sound/pci/als4000.c
+++ b/sound/pci/als4000.c
@@ -806,8 +806,8 @@ static void snd_card_als4000_free( struct snd_card *card )
 	snd_als4000_free_gameport(acard);
 }
 
-static int snd_card_als4000_probe(struct pci_dev *pci,
-				  const struct pci_device_id *pci_id)
+static int __snd_card_als4000_probe(struct pci_dev *pci,
+				    const struct pci_device_id *pci_id)
 {
 	static int dev;
 	struct snd_card *card;
@@ -930,6 +930,12 @@ static int snd_card_als4000_probe(struct pci_dev *pci,
 	return 0;
 }
 
+static int snd_card_als4000_probe(struct pci_dev *pci,
+				  const struct pci_device_id *pci_id)
+{
+	return snd_card_free_on_error(&pci->dev, __snd_card_als4000_probe(pci, pci_id));
+}
+
 #ifdef CONFIG_PM_SLEEP
 static int snd_als4000_suspend(struct device *dev)
 {
diff --git a/sound/pci/atiixp.c b/sound/pci/atiixp.c
index b8e035d5930d..43d01f1847ed 100644
--- a/sound/pci/atiixp.c
+++ b/sound/pci/atiixp.c
@@ -1572,8 +1572,8 @@ static int snd_atiixp_init(struct snd_card *card, struct pci_dev *pci)
 }
 
 
-static int snd_atiixp_probe(struct pci_dev *pci,
-			    const struct pci_device_id *pci_id)
+static int __snd_atiixp_probe(struct pci_dev *pci,
+			      const struct pci_device_id *pci_id)
 {
 	struct snd_card *card;
 	struct atiixp *chip;
@@ -1623,6 +1623,12 @@ static int snd_atiixp_probe(struct pci_dev *pci,
 	return 0;
 }
 
+static int snd_atiixp_probe(struct pci_dev *pci,
+			    const struct pci_device_id *pci_id)
+{
+	return snd_card_free_on_error(&pci->dev, __snd_atiixp_probe(pci, pci_id));
+}
+
 static struct pci_driver atiixp_driver = {
 	.name = KBUILD_MODNAME,
 	.id_table = snd_atiixp_ids,
diff --git a/sound/pci/atiixp_modem.c b/sound/pci/atiixp_modem.c
index 178dce8ef1e9..8864c4c3c7e1 100644
--- a/sound/pci/atiixp_modem.c
+++ b/sound/pci/atiixp_modem.c
@@ -1201,8 +1201,8 @@ static int snd_atiixp_init(struct snd_card *card, struct pci_dev *pci)
 }
 
 
-static int snd_atiixp_probe(struct pci_dev *pci,
-			    const struct pci_device_id *pci_id)
+static int __snd_atiixp_probe(struct pci_dev *pci,
+			      const struct pci_device_id *pci_id)
 {
 	struct snd_card *card;
 	struct atiixp_modem *chip;
@@ -1247,6 +1247,12 @@ static int snd_atiixp_probe(struct pci_dev *pci,
 	return 0;
 }
 
+static int snd_atiixp_probe(struct pci_dev *pci,
+			    const struct pci_device_id *pci_id)
+{
+	return snd_card_free_on_error(&pci->dev, __snd_atiixp_probe(pci, pci_id));
+}
+
 static struct pci_driver atiixp_modem_driver = {
 	.name = KBUILD_MODNAME,
 	.id_table = snd_atiixp_ids,
diff --git a/sound/pci/au88x0/au88x0.c b/sound/pci/au88x0/au88x0.c
index 342ef2a6655e..eb234153691b 100644
--- a/sound/pci/au88x0/au88x0.c
+++ b/sound/pci/au88x0/au88x0.c
@@ -193,7 +193,7 @@ snd_vortex_create(struct snd_card *card, struct pci_dev *pci)
 
 // constructor -- see "Constructor" sub-section
 static int
-snd_vortex_probe(struct pci_dev *pci, const struct pci_device_id *pci_id)
+__snd_vortex_probe(struct pci_dev *pci, const struct pci_device_id *pci_id)
 {
 	static int dev;
 	struct snd_card *card;
@@ -310,6 +310,12 @@ snd_vortex_probe(struct pci_dev *pci, const struct pci_device_id *pci_id)
 	return 0;
 }
 
+static int
+snd_vortex_probe(struct pci_dev *pci, const struct pci_device_id *pci_id)
+{
+	return snd_card_free_on_error(&pci->dev, __snd_vortex_probe(pci, pci_id));
+}
+
 // pci_driver definition
 static struct pci_driver vortex_driver = {
 	.name = KBUILD_MODNAME,
diff --git a/sound/pci/aw2/aw2-alsa.c b/sound/pci/aw2/aw2-alsa.c
index d56f126d6fdd..29a4bcdec237 100644
--- a/sound/pci/aw2/aw2-alsa.c
+++ b/sound/pci/aw2/aw2-alsa.c
@@ -275,7 +275,7 @@ static int snd_aw2_probe(struct pci_dev *pci,
 	/* (3) Create main component */
 	err = snd_aw2_create(card, pci);
 	if (err < 0)
-		return err;
+		goto error;
 
 	/* initialize mutex */
 	mutex_init(&chip->mtx);
@@ -294,13 +294,17 @@ static int snd_aw2_probe(struct pci_dev *pci,
 	/* (6) Register card instance */
 	err = snd_card_register(card);
 	if (err < 0)
-		return err;
+		goto error;
 
 	/* (7) Set PCI driver data */
 	pci_set_drvdata(pci, card);
 
 	dev++;
 	return 0;
+
+ error:
+	snd_card_free(card);
+	return err;
 }
 
 /* open callback */
diff --git a/sound/pci/azt3328.c b/sound/pci/azt3328.c
index 089050470ff2..7f329dfc5404 100644
--- a/sound/pci/azt3328.c
+++ b/sound/pci/azt3328.c
@@ -2427,7 +2427,7 @@ snd_azf3328_create(struct snd_card *card,
 }
 
 static int
-snd_azf3328_probe(struct pci_dev *pci, const struct pci_device_id *pci_id)
+__snd_azf3328_probe(struct pci_dev *pci, const struct pci_device_id *pci_id)
 {
 	static int dev;
 	struct snd_card *card;
@@ -2520,6 +2520,12 @@ snd_azf3328_probe(struct pci_dev *pci, const struct pci_device_id *pci_id)
 	return 0;
 }
 
+static int
+snd_azf3328_probe(struct pci_dev *pci, const struct pci_device_id *pci_id)
+{
+	return snd_card_free_on_error(&pci->dev, __snd_azf3328_probe(pci, pci_id));
+}
+
 #ifdef CONFIG_PM_SLEEP
 static inline void
 snd_azf3328_suspend_regs(const struct snd_azf3328 *chip,
diff --git a/sound/pci/bt87x.c b/sound/pci/bt87x.c
index d23f93163841..621985bfee5d 100644
--- a/sound/pci/bt87x.c
+++ b/sound/pci/bt87x.c
@@ -805,8 +805,8 @@ static int snd_bt87x_detect_card(struct pci_dev *pci)
 	return SND_BT87X_BOARD_UNKNOWN;
 }
 
-static int snd_bt87x_probe(struct pci_dev *pci,
-			   const struct pci_device_id *pci_id)
+static int __snd_bt87x_probe(struct pci_dev *pci,
+			     const struct pci_device_id *pci_id)
 {
 	static int dev;
 	struct snd_card *card;
@@ -889,6 +889,12 @@ static int snd_bt87x_probe(struct pci_dev *pci,
 	return 0;
 }
 
+static int snd_bt87x_probe(struct pci_dev *pci,
+			   const struct pci_device_id *pci_id)
+{
+	return snd_card_free_on_error(&pci->dev, __snd_bt87x_probe(pci, pci_id));
+}
+
 /* default entries for all Bt87x cards - it's not exported */
 /* driver_data is set to 0 to call detection */
 static const struct pci_device_id snd_bt87x_default_ids[] = {
diff --git a/sound/pci/ca0106/ca0106_main.c b/sound/pci/ca0106/ca0106_main.c
index 36fb150b72fb..f4cc112bddf3 100644
--- a/sound/pci/ca0106/ca0106_main.c
+++ b/sound/pci/ca0106/ca0106_main.c
@@ -1725,8 +1725,8 @@ static int snd_ca0106_midi(struct snd_ca0106 *chip, unsigned int channel)
 }
 
 
-static int snd_ca0106_probe(struct pci_dev *pci,
-					const struct pci_device_id *pci_id)
+static int __snd_ca0106_probe(struct pci_dev *pci,
+			      const struct pci_device_id *pci_id)
 {
 	static int dev;
 	struct snd_card *card;
@@ -1786,6 +1786,12 @@ static int snd_ca0106_probe(struct pci_dev *pci,
 	return 0;
 }
 
+static int snd_ca0106_probe(struct pci_dev *pci,
+			    const struct pci_device_id *pci_id)
+{
+	return snd_card_free_on_error(&pci->dev, __snd_ca0106_probe(pci, pci_id));
+}
+
 #ifdef CONFIG_PM_SLEEP
 static int snd_ca0106_suspend(struct device *dev)
 {
diff --git a/sound/pci/cmipci.c b/sound/pci/cmipci.c
index dc4232bac749..42fcbed9220c 100644
--- a/sound/pci/cmipci.c
+++ b/sound/pci/cmipci.c
@@ -3249,15 +3249,19 @@ static int snd_cmipci_probe(struct pci_dev *pci,
 
 	err = snd_cmipci_create(card, pci, dev);
 	if (err < 0)
-		return err;
+		goto error;
 
 	err = snd_card_register(card);
 	if (err < 0)
-		return err;
+		goto error;
 
 	pci_set_drvdata(pci, card);
 	dev++;
 	return 0;
+
+ error:
+	snd_card_free(card);
+	return err;
 }
 
 #ifdef CONFIG_PM_SLEEP
diff --git a/sound/pci/cs4281.c b/sound/pci/cs4281.c
index e7367402b84a..0c9cadf7b3b8 100644
--- a/sound/pci/cs4281.c
+++ b/sound/pci/cs4281.c
@@ -1827,8 +1827,8 @@ static void snd_cs4281_opl3_command(struct snd_opl3 *opl3, unsigned short cmd,
 	spin_unlock_irqrestore(&opl3->reg_lock, flags);
 }
 
-static int snd_cs4281_probe(struct pci_dev *pci,
-			    const struct pci_device_id *pci_id)
+static int __snd_cs4281_probe(struct pci_dev *pci,
+			      const struct pci_device_id *pci_id)
 {
 	static int dev;
 	struct snd_card *card;
@@ -1888,6 +1888,12 @@ static int snd_cs4281_probe(struct pci_dev *pci,
 	return 0;
 }
 
+static int snd_cs4281_probe(struct pci_dev *pci,
+			    const struct pci_device_id *pci_id)
+{
+	return snd_card_free_on_error(&pci->dev, __snd_cs4281_probe(pci, pci_id));
+}
+
 /*
  * Power Management
  */
diff --git a/sound/pci/cs5535audio/cs5535audio.c b/sound/pci/cs5535audio/cs5535audio.c
index 499fa0148f9a..440b8f9b40c9 100644
--- a/sound/pci/cs5535audio/cs5535audio.c
+++ b/sound/pci/cs5535audio/cs5535audio.c
@@ -281,8 +281,8 @@ static int snd_cs5535audio_create(struct snd_card *card,
 	return 0;
 }
 
-static int snd_cs5535audio_probe(struct pci_dev *pci,
-				 const struct pci_device_id *pci_id)
+static int __snd_cs5535audio_probe(struct pci_dev *pci,
+				   const struct pci_device_id *pci_id)
 {
 	static int dev;
 	struct snd_card *card;
@@ -331,6 +331,12 @@ static int snd_cs5535audio_probe(struct pci_dev *pci,
 	return 0;
 }
 
+static int snd_cs5535audio_probe(struct pci_dev *pci,
+				 const struct pci_device_id *pci_id)
+{
+	return snd_card_free_on_error(&pci->dev, __snd_cs5535audio_probe(pci, pci_id));
+}
+
 static struct pci_driver cs5535audio_driver = {
 	.name = KBUILD_MODNAME,
 	.id_table = snd_cs5535audio_ids,
diff --git a/sound/pci/echoaudio/echoaudio.c b/sound/pci/echoaudio/echoaudio.c
index 25b012ef5c3e..c70c3ac4e99a 100644
--- a/sound/pci/echoaudio/echoaudio.c
+++ b/sound/pci/echoaudio/echoaudio.c
@@ -1970,8 +1970,8 @@ static int snd_echo_create(struct snd_card *card,
 }
 
 /* constructor */
-static int snd_echo_probe(struct pci_dev *pci,
-			  const struct pci_device_id *pci_id)
+static int __snd_echo_probe(struct pci_dev *pci,
+			    const struct pci_device_id *pci_id)
 {
 	static int dev;
 	struct snd_card *card;
@@ -2139,6 +2139,11 @@ static int snd_echo_probe(struct pci_dev *pci,
 	return 0;
 }
 
+static int snd_echo_probe(struct pci_dev *pci,
+			  const struct pci_device_id *pci_id)
+{
+	return snd_card_free_on_error(&pci->dev, __snd_echo_probe(pci, pci_id));
+}
 
 
 #if defined(CONFIG_PM_SLEEP)
diff --git a/sound/pci/emu10k1/emu10k1x.c b/sound/pci/emu10k1/emu10k1x.c
index c49c44dc1082..89043392f3ec 100644
--- a/sound/pci/emu10k1/emu10k1x.c
+++ b/sound/pci/emu10k1/emu10k1x.c
@@ -1491,8 +1491,8 @@ static int snd_emu10k1x_midi(struct emu10k1x *emu)
 	return 0;
 }
 
-static int snd_emu10k1x_probe(struct pci_dev *pci,
-			      const struct pci_device_id *pci_id)
+static int __snd_emu10k1x_probe(struct pci_dev *pci,
+				const struct pci_device_id *pci_id)
 {
 	static int dev;
 	struct snd_card *card;
@@ -1554,6 +1554,12 @@ static int snd_emu10k1x_probe(struct pci_dev *pci,
 	return 0;
 }
 
+static int snd_emu10k1x_probe(struct pci_dev *pci,
+			      const struct pci_device_id *pci_id)
+{
+	return snd_card_free_on_error(&pci->dev, __snd_emu10k1x_probe(pci, pci_id));
+}
+
 // PCI IDs
 static const struct pci_device_id snd_emu10k1x_ids[] = {
 	{ PCI_VDEVICE(CREATIVE, 0x0006), 0 },	/* Dell OEM version (EMU10K1) */
diff --git a/sound/pci/ens1370.c b/sound/pci/ens1370.c
index 2651f0c64c06..94efe347a97a 100644
--- a/sound/pci/ens1370.c
+++ b/sound/pci/ens1370.c
@@ -2304,8 +2304,8 @@ static irqreturn_t snd_audiopci_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static int snd_audiopci_probe(struct pci_dev *pci,
-			      const struct pci_device_id *pci_id)
+static int __snd_audiopci_probe(struct pci_dev *pci,
+				const struct pci_device_id *pci_id)
 {
 	static int dev;
 	struct snd_card *card;
@@ -2369,6 +2369,12 @@ static int snd_audiopci_probe(struct pci_dev *pci,
 	return 0;
 }
 
+static int snd_audiopci_probe(struct pci_dev *pci,
+			      const struct pci_device_id *pci_id)
+{
+	return snd_card_free_on_error(&pci->dev, __snd_audiopci_probe(pci, pci_id));
+}
+
 static struct pci_driver ens137x_driver = {
 	.name = KBUILD_MODNAME,
 	.id_table = snd_audiopci_ids,
diff --git a/sound/pci/es1938.c b/sound/pci/es1938.c
index 00b976f42a3d..e34ec6f89e7e 100644
--- a/sound/pci/es1938.c
+++ b/sound/pci/es1938.c
@@ -1716,8 +1716,8 @@ static int snd_es1938_mixer(struct es1938 *chip)
 }
        
 
-static int snd_es1938_probe(struct pci_dev *pci,
-			    const struct pci_device_id *pci_id)
+static int __snd_es1938_probe(struct pci_dev *pci,
+			      const struct pci_device_id *pci_id)
 {
 	static int dev;
 	struct snd_card *card;
@@ -1796,6 +1796,12 @@ static int snd_es1938_probe(struct pci_dev *pci,
 	return 0;
 }
 
+static int snd_es1938_probe(struct pci_dev *pci,
+			    const struct pci_device_id *pci_id)
+{
+	return snd_card_free_on_error(&pci->dev, __snd_es1938_probe(pci, pci_id));
+}
+
 static struct pci_driver es1938_driver = {
 	.name = KBUILD_MODNAME,
 	.id_table = snd_es1938_ids,
diff --git a/sound/pci/es1968.c b/sound/pci/es1968.c
index 6a8a02a9ecf4..4a7e20bb11bc 100644
--- a/sound/pci/es1968.c
+++ b/sound/pci/es1968.c
@@ -2741,8 +2741,8 @@ static int snd_es1968_create(struct snd_card *card,
 
 /*
  */
-static int snd_es1968_probe(struct pci_dev *pci,
-			    const struct pci_device_id *pci_id)
+static int __snd_es1968_probe(struct pci_dev *pci,
+			      const struct pci_device_id *pci_id)
 {
 	static int dev;
 	struct snd_card *card;
@@ -2848,6 +2848,12 @@ static int snd_es1968_probe(struct pci_dev *pci,
 	return 0;
 }
 
+static int snd_es1968_probe(struct pci_dev *pci,
+			    const struct pci_device_id *pci_id)
+{
+	return snd_card_free_on_error(&pci->dev, __snd_es1968_probe(pci, pci_id));
+}
+
 static struct pci_driver es1968_driver = {
 	.name = KBUILD_MODNAME,
 	.id_table = snd_es1968_ids,
diff --git a/sound/pci/fm801.c b/sound/pci/fm801.c
index 9c22ff19e56d..62b3cb126c6d 100644
--- a/sound/pci/fm801.c
+++ b/sound/pci/fm801.c
@@ -1268,8 +1268,8 @@ static int snd_fm801_create(struct snd_card *card,
 	return 0;
 }
 
-static int snd_card_fm801_probe(struct pci_dev *pci,
-				const struct pci_device_id *pci_id)
+static int __snd_card_fm801_probe(struct pci_dev *pci,
+				  const struct pci_device_id *pci_id)
 {
 	static int dev;
 	struct snd_card *card;
@@ -1333,6 +1333,12 @@ static int snd_card_fm801_probe(struct pci_dev *pci,
 	return 0;
 }
 
+static int snd_card_fm801_probe(struct pci_dev *pci,
+				const struct pci_device_id *pci_id)
+{
+	return snd_card_free_on_error(&pci->dev, __snd_card_fm801_probe(pci, pci_id));
+}
+
 #ifdef CONFIG_PM_SLEEP
 static const unsigned char saved_regs[] = {
 	FM801_PCM_VOL, FM801_I2S_VOL, FM801_FM_VOL, FM801_REC_SRC,
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index f6e5ed34dd09..5ae20cbbd5c0 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -2614,6 +2614,7 @@ static const struct snd_pci_quirk alc882_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1558, 0x65e1, "Clevo PB51[ED][DF]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x65e5, "Clevo PC50D[PRS](?:-D|-G)?", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x65f1, "Clevo PC50HS", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
+	SND_PCI_QUIRK(0x1558, 0x65f5, "Clevo PD50PN[NRT]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x67d1, "Clevo PB71[ER][CDF]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x67e1, "Clevo PB71[DE][CDF]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x67e5, "Clevo PC70D[PRS](?:-D|-G)?", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
@@ -9059,6 +9060,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x505d, "Thinkpad", ALC298_FIXUP_TPT470_DOCK),
 	SND_PCI_QUIRK(0x17aa, 0x505f, "Thinkpad", ALC298_FIXUP_TPT470_DOCK),
 	SND_PCI_QUIRK(0x17aa, 0x5062, "Thinkpad", ALC298_FIXUP_TPT470_DOCK),
+	SND_PCI_QUIRK(0x17aa, 0x508b, "Thinkpad X12 Gen 1", ALC287_FIXUP_LEGION_15IMHG05_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x5109, "Thinkpad", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x17aa, 0x511e, "Thinkpad", ALC298_FIXUP_TPT470_DOCK),
 	SND_PCI_QUIRK(0x17aa, 0x511f, "Thinkpad", ALC298_FIXUP_TPT470_DOCK),
diff --git a/sound/pci/ice1712/ice1724.c b/sound/pci/ice1712/ice1724.c
index f6275868877a..6fab2ad85bbe 100644
--- a/sound/pci/ice1712/ice1724.c
+++ b/sound/pci/ice1712/ice1724.c
@@ -2519,8 +2519,8 @@ static int snd_vt1724_create(struct snd_card *card,
  *
  */
 
-static int snd_vt1724_probe(struct pci_dev *pci,
-			    const struct pci_device_id *pci_id)
+static int __snd_vt1724_probe(struct pci_dev *pci,
+			      const struct pci_device_id *pci_id)
 {
 	static int dev;
 	struct snd_card *card;
@@ -2662,6 +2662,12 @@ static int snd_vt1724_probe(struct pci_dev *pci,
 	return 0;
 }
 
+static int snd_vt1724_probe(struct pci_dev *pci,
+			    const struct pci_device_id *pci_id)
+{
+	return snd_card_free_on_error(&pci->dev, __snd_vt1724_probe(pci, pci_id));
+}
+
 #ifdef CONFIG_PM_SLEEP
 static int snd_vt1724_suspend(struct device *dev)
 {
diff --git a/sound/pci/intel8x0.c b/sound/pci/intel8x0.c
index a51032b3ac4d..ae285c0a629c 100644
--- a/sound/pci/intel8x0.c
+++ b/sound/pci/intel8x0.c
@@ -3109,8 +3109,8 @@ static int check_default_spdif_aclink(struct pci_dev *pci)
 	return 0;
 }
 
-static int snd_intel8x0_probe(struct pci_dev *pci,
-			      const struct pci_device_id *pci_id)
+static int __snd_intel8x0_probe(struct pci_dev *pci,
+				const struct pci_device_id *pci_id)
 {
 	struct snd_card *card;
 	struct intel8x0 *chip;
@@ -3189,6 +3189,12 @@ static int snd_intel8x0_probe(struct pci_dev *pci,
 	return 0;
 }
 
+static int snd_intel8x0_probe(struct pci_dev *pci,
+			      const struct pci_device_id *pci_id)
+{
+	return snd_card_free_on_error(&pci->dev, __snd_intel8x0_probe(pci, pci_id));
+}
+
 static struct pci_driver intel8x0_driver = {
 	.name = KBUILD_MODNAME,
 	.id_table = snd_intel8x0_ids,
diff --git a/sound/pci/intel8x0m.c b/sound/pci/intel8x0m.c
index 7de3cb2f17b5..2845cc006d0c 100644
--- a/sound/pci/intel8x0m.c
+++ b/sound/pci/intel8x0m.c
@@ -1178,8 +1178,8 @@ static struct shortname_table {
 	{ 0 },
 };
 
-static int snd_intel8x0m_probe(struct pci_dev *pci,
-			       const struct pci_device_id *pci_id)
+static int __snd_intel8x0m_probe(struct pci_dev *pci,
+				 const struct pci_device_id *pci_id)
 {
 	struct snd_card *card;
 	struct intel8x0m *chip;
@@ -1225,6 +1225,12 @@ static int snd_intel8x0m_probe(struct pci_dev *pci,
 	return 0;
 }
 
+static int snd_intel8x0m_probe(struct pci_dev *pci,
+			       const struct pci_device_id *pci_id)
+{
+	return snd_card_free_on_error(&pci->dev, __snd_intel8x0m_probe(pci, pci_id));
+}
+
 static struct pci_driver intel8x0m_driver = {
 	.name = KBUILD_MODNAME,
 	.id_table = snd_intel8x0m_ids,
diff --git a/sound/pci/korg1212/korg1212.c b/sound/pci/korg1212/korg1212.c
index 5c9e240ff6a9..33b4f95d65b3 100644
--- a/sound/pci/korg1212/korg1212.c
+++ b/sound/pci/korg1212/korg1212.c
@@ -2355,7 +2355,7 @@ snd_korg1212_probe(struct pci_dev *pci,
 
 	err = snd_korg1212_create(card, pci);
 	if (err < 0)
-		return err;
+		goto error;
 
 	strcpy(card->driver, "korg1212");
 	strcpy(card->shortname, "korg1212");
@@ -2366,10 +2366,14 @@ snd_korg1212_probe(struct pci_dev *pci,
 
 	err = snd_card_register(card);
 	if (err < 0)
-		return err;
+		goto error;
 	pci_set_drvdata(pci, card);
 	dev++;
 	return 0;
+
+ error:
+	snd_card_free(card);
+	return err;
 }
 
 static struct pci_driver korg1212_driver = {
diff --git a/sound/pci/lola/lola.c b/sound/pci/lola/lola.c
index 5269a1d396a5..1aa30e90b86a 100644
--- a/sound/pci/lola/lola.c
+++ b/sound/pci/lola/lola.c
@@ -637,8 +637,8 @@ static int lola_create(struct snd_card *card, struct pci_dev *pci, int dev)
 	return 0;
 }
 
-static int lola_probe(struct pci_dev *pci,
-		      const struct pci_device_id *pci_id)
+static int __lola_probe(struct pci_dev *pci,
+			const struct pci_device_id *pci_id)
 {
 	static int dev;
 	struct snd_card *card;
@@ -687,6 +687,12 @@ static int lola_probe(struct pci_dev *pci,
 	return 0;
 }
 
+static int lola_probe(struct pci_dev *pci,
+		      const struct pci_device_id *pci_id)
+{
+	return snd_card_free_on_error(&pci->dev, __lola_probe(pci, pci_id));
+}
+
 /* PCI IDs */
 static const struct pci_device_id lola_ids[] = {
 	{ PCI_VDEVICE(DIGIGRAM, 0x0001) },
diff --git a/sound/pci/lx6464es/lx6464es.c b/sound/pci/lx6464es/lx6464es.c
index 168a1084f730..bd9b6148dd6f 100644
--- a/sound/pci/lx6464es/lx6464es.c
+++ b/sound/pci/lx6464es/lx6464es.c
@@ -1019,7 +1019,7 @@ static int snd_lx6464es_probe(struct pci_dev *pci,
 	err = snd_lx6464es_create(card, pci);
 	if (err < 0) {
 		dev_err(card->dev, "error during snd_lx6464es_create\n");
-		return err;
+		goto error;
 	}
 
 	strcpy(card->driver, "LX6464ES");
@@ -1036,12 +1036,16 @@ static int snd_lx6464es_probe(struct pci_dev *pci,
 
 	err = snd_card_register(card);
 	if (err < 0)
-		return err;
+		goto error;
 
 	dev_dbg(chip->card->dev, "initialization successful\n");
 	pci_set_drvdata(pci, card);
 	dev++;
 	return 0;
+
+ error:
+	snd_card_free(card);
+	return err;
 }
 
 static struct pci_driver lx6464es_driver = {
diff --git a/sound/pci/maestro3.c b/sound/pci/maestro3.c
index 056838ead21d..261850775c80 100644
--- a/sound/pci/maestro3.c
+++ b/sound/pci/maestro3.c
@@ -2637,7 +2637,7 @@ snd_m3_create(struct snd_card *card, struct pci_dev *pci,
 /*
  */
 static int
-snd_m3_probe(struct pci_dev *pci, const struct pci_device_id *pci_id)
+__snd_m3_probe(struct pci_dev *pci, const struct pci_device_id *pci_id)
 {
 	static int dev;
 	struct snd_card *card;
@@ -2702,6 +2702,12 @@ snd_m3_probe(struct pci_dev *pci, const struct pci_device_id *pci_id)
 	return 0;
 }
 
+static int
+snd_m3_probe(struct pci_dev *pci, const struct pci_device_id *pci_id)
+{
+	return snd_card_free_on_error(&pci->dev, __snd_m3_probe(pci, pci_id));
+}
+
 static struct pci_driver m3_driver = {
 	.name = KBUILD_MODNAME,
 	.id_table = snd_m3_ids,
diff --git a/sound/pci/nm256/nm256.c b/sound/pci/nm256/nm256.c
index c9c178504959..f99a1e96e923 100644
--- a/sound/pci/nm256/nm256.c
+++ b/sound/pci/nm256/nm256.c
@@ -1573,7 +1573,6 @@ snd_nm256_create(struct snd_card *card, struct pci_dev *pci)
 	chip->coeffs_current = 0;
 
 	snd_nm256_init_chip(chip);
-	card->private_free = snd_nm256_free;
 
 	// pci_set_master(pci); /* needed? */
 	return 0;
@@ -1680,6 +1679,7 @@ static int snd_nm256_probe(struct pci_dev *pci,
 	err = snd_card_register(card);
 	if (err < 0)
 		return err;
+	card->private_free = snd_nm256_free;
 
 	pci_set_drvdata(pci, card);
 	return 0;
diff --git a/sound/pci/oxygen/oxygen_lib.c b/sound/pci/oxygen/oxygen_lib.c
index 4fb3f2484fdb..92ffe9dc20c5 100644
--- a/sound/pci/oxygen/oxygen_lib.c
+++ b/sound/pci/oxygen/oxygen_lib.c
@@ -576,7 +576,7 @@ static void oxygen_card_free(struct snd_card *card)
 	mutex_destroy(&chip->mutex);
 }
 
-int oxygen_pci_probe(struct pci_dev *pci, int index, char *id,
+static int __oxygen_pci_probe(struct pci_dev *pci, int index, char *id,
 		     struct module *owner,
 		     const struct pci_device_id *ids,
 		     int (*get_model)(struct oxygen *chip,
@@ -701,6 +701,16 @@ int oxygen_pci_probe(struct pci_dev *pci, int index, char *id,
 	pci_set_drvdata(pci, card);
 	return 0;
 }
+
+int oxygen_pci_probe(struct pci_dev *pci, int index, char *id,
+		     struct module *owner,
+		     const struct pci_device_id *ids,
+		     int (*get_model)(struct oxygen *chip,
+				      const struct pci_device_id *id))
+{
+	return snd_card_free_on_error(&pci->dev,
+				      __oxygen_pci_probe(pci, index, id, owner, ids, get_model));
+}
 EXPORT_SYMBOL(oxygen_pci_probe);
 
 #ifdef CONFIG_PM_SLEEP
diff --git a/sound/pci/riptide/riptide.c b/sound/pci/riptide/riptide.c
index 5a987c683c41..b37c877c2c16 100644
--- a/sound/pci/riptide/riptide.c
+++ b/sound/pci/riptide/riptide.c
@@ -2023,7 +2023,7 @@ static void snd_riptide_joystick_remove(struct pci_dev *pci)
 #endif
 
 static int
-snd_card_riptide_probe(struct pci_dev *pci, const struct pci_device_id *pci_id)
+__snd_card_riptide_probe(struct pci_dev *pci, const struct pci_device_id *pci_id)
 {
 	static int dev;
 	struct snd_card *card;
@@ -2124,6 +2124,12 @@ snd_card_riptide_probe(struct pci_dev *pci, const struct pci_device_id *pci_id)
 	return 0;
 }
 
+static int
+snd_card_riptide_probe(struct pci_dev *pci, const struct pci_device_id *pci_id)
+{
+	return snd_card_free_on_error(&pci->dev, __snd_card_riptide_probe(pci, pci_id));
+}
+
 static struct pci_driver driver = {
 	.name = KBUILD_MODNAME,
 	.id_table = snd_riptide_ids,
diff --git a/sound/pci/rme32.c b/sound/pci/rme32.c
index 5b6bd9f0b2f7..9c0ac025e143 100644
--- a/sound/pci/rme32.c
+++ b/sound/pci/rme32.c
@@ -1875,7 +1875,7 @@ static void snd_rme32_card_free(struct snd_card *card)
 }
 
 static int
-snd_rme32_probe(struct pci_dev *pci, const struct pci_device_id *pci_id)
+__snd_rme32_probe(struct pci_dev *pci, const struct pci_device_id *pci_id)
 {
 	static int dev;
 	struct rme32 *rme32;
@@ -1927,6 +1927,12 @@ snd_rme32_probe(struct pci_dev *pci, const struct pci_device_id *pci_id)
 	return 0;
 }
 
+static int
+snd_rme32_probe(struct pci_dev *pci, const struct pci_device_id *pci_id)
+{
+	return snd_card_free_on_error(&pci->dev, __snd_rme32_probe(pci, pci_id));
+}
+
 static struct pci_driver rme32_driver = {
 	.name =		KBUILD_MODNAME,
 	.id_table =	snd_rme32_ids,
diff --git a/sound/pci/rme96.c b/sound/pci/rme96.c
index 8fc811504920..bccb7e0d3d11 100644
--- a/sound/pci/rme96.c
+++ b/sound/pci/rme96.c
@@ -2430,8 +2430,8 @@ static void snd_rme96_card_free(struct snd_card *card)
 }
 
 static int
-snd_rme96_probe(struct pci_dev *pci,
-		const struct pci_device_id *pci_id)
+__snd_rme96_probe(struct pci_dev *pci,
+		  const struct pci_device_id *pci_id)
 {
 	static int dev;
 	struct rme96 *rme96;
@@ -2498,6 +2498,12 @@ snd_rme96_probe(struct pci_dev *pci,
 	return 0;
 }
 
+static int snd_rme96_probe(struct pci_dev *pci,
+			   const struct pci_device_id *pci_id)
+{
+	return snd_card_free_on_error(&pci->dev, __snd_rme96_probe(pci, pci_id));
+}
+
 static struct pci_driver rme96_driver = {
 	.name = KBUILD_MODNAME,
 	.id_table = snd_rme96_ids,
diff --git a/sound/pci/rme9652/hdsp.c b/sound/pci/rme9652/hdsp.c
index 96c12dfb24cf..3db641318d3a 100644
--- a/sound/pci/rme9652/hdsp.c
+++ b/sound/pci/rme9652/hdsp.c
@@ -5444,17 +5444,21 @@ static int snd_hdsp_probe(struct pci_dev *pci,
 	hdsp->pci = pci;
 	err = snd_hdsp_create(card, hdsp);
 	if (err)
-		return err;
+		goto error;
 
 	strcpy(card->shortname, "Hammerfall DSP");
 	sprintf(card->longname, "%s at 0x%lx, irq %d", hdsp->card_name,
 		hdsp->port, hdsp->irq);
 	err = snd_card_register(card);
 	if (err)
-		return err;
+		goto error;
 	pci_set_drvdata(pci, card);
 	dev++;
 	return 0;
+
+ error:
+	snd_card_free(card);
+	return err;
 }
 
 static struct pci_driver hdsp_driver = {
diff --git a/sound/pci/rme9652/hdspm.c b/sound/pci/rme9652/hdspm.c
index ff06ee82607c..fa1812e7a49d 100644
--- a/sound/pci/rme9652/hdspm.c
+++ b/sound/pci/rme9652/hdspm.c
@@ -6895,7 +6895,7 @@ static int snd_hdspm_probe(struct pci_dev *pci,
 
 	err = snd_hdspm_create(card, hdspm);
 	if (err < 0)
-		return err;
+		goto error;
 
 	if (hdspm->io_type != MADIface) {
 		snprintf(card->shortname, sizeof(card->shortname), "%s_%x",
@@ -6914,12 +6914,16 @@ static int snd_hdspm_probe(struct pci_dev *pci,
 
 	err = snd_card_register(card);
 	if (err < 0)
-		return err;
+		goto error;
 
 	pci_set_drvdata(pci, card);
 
 	dev++;
 	return 0;
+
+ error:
+	snd_card_free(card);
+	return err;
 }
 
 static struct pci_driver hdspm_driver = {
diff --git a/sound/pci/rme9652/rme9652.c b/sound/pci/rme9652/rme9652.c
index 7755e19aa776..1d614fe89a6a 100644
--- a/sound/pci/rme9652/rme9652.c
+++ b/sound/pci/rme9652/rme9652.c
@@ -2572,7 +2572,7 @@ static int snd_rme9652_probe(struct pci_dev *pci,
 	rme9652->pci = pci;
 	err = snd_rme9652_create(card, rme9652, precise_ptr[dev]);
 	if (err)
-		return err;
+		goto error;
 
 	strcpy(card->shortname, rme9652->card_name);
 
@@ -2580,10 +2580,14 @@ static int snd_rme9652_probe(struct pci_dev *pci,
 		card->shortname, rme9652->port, rme9652->irq);
 	err = snd_card_register(card);
 	if (err)
-		return err;
+		goto error;
 	pci_set_drvdata(pci, card);
 	dev++;
 	return 0;
+
+ error:
+	snd_card_free(card);
+	return err;
 }
 
 static struct pci_driver rme9652_driver = {
diff --git a/sound/pci/sis7019.c b/sound/pci/sis7019.c
index 0b722b0e0604..fabe393607f8 100644
--- a/sound/pci/sis7019.c
+++ b/sound/pci/sis7019.c
@@ -1331,8 +1331,8 @@ static int sis_chip_create(struct snd_card *card,
 	return 0;
 }
 
-static int snd_sis7019_probe(struct pci_dev *pci,
-			     const struct pci_device_id *pci_id)
+static int __snd_sis7019_probe(struct pci_dev *pci,
+			       const struct pci_device_id *pci_id)
 {
 	struct snd_card *card;
 	struct sis7019 *sis;
@@ -1352,8 +1352,8 @@ static int snd_sis7019_probe(struct pci_dev *pci,
 	if (!codecs)
 		codecs = SIS_PRIMARY_CODEC_PRESENT;
 
-	rc = snd_card_new(&pci->dev, index, id, THIS_MODULE,
-			  sizeof(*sis), &card);
+	rc = snd_devm_card_new(&pci->dev, index, id, THIS_MODULE,
+			       sizeof(*sis), &card);
 	if (rc < 0)
 		return rc;
 
@@ -1386,6 +1386,12 @@ static int snd_sis7019_probe(struct pci_dev *pci,
 	return 0;
 }
 
+static int snd_sis7019_probe(struct pci_dev *pci,
+			     const struct pci_device_id *pci_id)
+{
+	return snd_card_free_on_error(&pci->dev, __snd_sis7019_probe(pci, pci_id));
+}
+
 static struct pci_driver sis7019_driver = {
 	.name = KBUILD_MODNAME,
 	.id_table = snd_sis7019_ids,
diff --git a/sound/pci/sonicvibes.c b/sound/pci/sonicvibes.c
index c8c49881008f..f91cbf6eeca0 100644
--- a/sound/pci/sonicvibes.c
+++ b/sound/pci/sonicvibes.c
@@ -1387,8 +1387,8 @@ static int snd_sonicvibes_midi(struct sonicvibes *sonic,
 	return 0;
 }
 
-static int snd_sonic_probe(struct pci_dev *pci,
-			   const struct pci_device_id *pci_id)
+static int __snd_sonic_probe(struct pci_dev *pci,
+			     const struct pci_device_id *pci_id)
 {
 	static int dev;
 	struct snd_card *card;
@@ -1459,6 +1459,12 @@ static int snd_sonic_probe(struct pci_dev *pci,
 	return 0;
 }
 
+static int snd_sonic_probe(struct pci_dev *pci,
+			   const struct pci_device_id *pci_id)
+{
+	return snd_card_free_on_error(&pci->dev, __snd_sonic_probe(pci, pci_id));
+}
+
 static struct pci_driver sonicvibes_driver = {
 	.name = KBUILD_MODNAME,
 	.id_table = snd_sonic_ids,
diff --git a/sound/pci/via82xx.c b/sound/pci/via82xx.c
index 65514f7e42d7..361b83fd721e 100644
--- a/sound/pci/via82xx.c
+++ b/sound/pci/via82xx.c
@@ -2458,8 +2458,8 @@ static int check_dxs_list(struct pci_dev *pci, int revision)
 	return VIA_DXS_48K;
 };
 
-static int snd_via82xx_probe(struct pci_dev *pci,
-			     const struct pci_device_id *pci_id)
+static int __snd_via82xx_probe(struct pci_dev *pci,
+			       const struct pci_device_id *pci_id)
 {
 	struct snd_card *card;
 	struct via82xx *chip;
@@ -2569,6 +2569,12 @@ static int snd_via82xx_probe(struct pci_dev *pci,
 	return 0;
 }
 
+static int snd_via82xx_probe(struct pci_dev *pci,
+			     const struct pci_device_id *pci_id)
+{
+	return snd_card_free_on_error(&pci->dev, __snd_via82xx_probe(pci, pci_id));
+}
+
 static struct pci_driver via82xx_driver = {
 	.name = KBUILD_MODNAME,
 	.id_table = snd_via82xx_ids,
diff --git a/sound/pci/via82xx_modem.c b/sound/pci/via82xx_modem.c
index 234f7fbed236..ca7f024bf8ec 100644
--- a/sound/pci/via82xx_modem.c
+++ b/sound/pci/via82xx_modem.c
@@ -1103,8 +1103,8 @@ static int snd_via82xx_create(struct snd_card *card,
 }
 
 
-static int snd_via82xx_probe(struct pci_dev *pci,
-			     const struct pci_device_id *pci_id)
+static int __snd_via82xx_probe(struct pci_dev *pci,
+			       const struct pci_device_id *pci_id)
 {
 	struct snd_card *card;
 	struct via82xx_modem *chip;
@@ -1157,6 +1157,12 @@ static int snd_via82xx_probe(struct pci_dev *pci,
 	return 0;
 }
 
+static int snd_via82xx_probe(struct pci_dev *pci,
+			     const struct pci_device_id *pci_id)
+{
+	return snd_card_free_on_error(&pci->dev, __snd_via82xx_probe(pci, pci_id));
+}
+
 static struct pci_driver via82xx_modem_driver = {
 	.name = KBUILD_MODNAME,
 	.id_table = snd_via82xx_modem_ids,
diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
index 2e51fb031ae0..729e26f5ac4c 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -669,9 +669,9 @@ static const struct snd_pcm_hardware snd_usb_hardware =
 				SNDRV_PCM_INFO_PAUSE,
 	.channels_min =		1,
 	.channels_max =		256,
-	.buffer_bytes_max =	1024 * 1024,
+	.buffer_bytes_max =	INT_MAX, /* limited by BUFFER_TIME later */
 	.period_bytes_min =	64,
-	.period_bytes_max =	512 * 1024,
+	.period_bytes_max =	INT_MAX, /* limited by PERIOD_TIME later */
 	.periods_min =		2,
 	.periods_max =		1024,
 };
@@ -1064,6 +1064,18 @@ static int setup_hw_info(struct snd_pcm_runtime *runtime, struct snd_usb_substre
 			return err;
 	}
 
+	/* set max period and buffer sizes for 1 and 2 seconds, respectively */
+	err = snd_pcm_hw_constraint_minmax(runtime,
+					   SNDRV_PCM_HW_PARAM_PERIOD_TIME,
+					   0, 1000000);
+	if (err < 0)
+		return err;
+	err = snd_pcm_hw_constraint_minmax(runtime,
+					   SNDRV_PCM_HW_PARAM_BUFFER_TIME,
+					   0, 2000000);
+	if (err < 0)
+		return err;
+
 	/* additional hw constraints for implicit fb */
 	err = snd_pcm_hw_rule_add(runtime, 0, SNDRV_PCM_HW_PARAM_FORMAT,
 				  hw_rule_format_implicit_fb, subs,
diff --git a/sound/x86/intel_hdmi_audio.c b/sound/x86/intel_hdmi_audio.c
index 7aa947274900..42add5df37fd 100644
--- a/sound/x86/intel_hdmi_audio.c
+++ b/sound/x86/intel_hdmi_audio.c
@@ -1665,7 +1665,7 @@ static void hdmi_lpe_audio_free(struct snd_card *card)
  * This function is called when the i915 driver creates the
  * hdmi-lpe-audio platform device.
  */
-static int hdmi_lpe_audio_probe(struct platform_device *pdev)
+static int __hdmi_lpe_audio_probe(struct platform_device *pdev)
 {
 	struct snd_card *card;
 	struct snd_intelhad_card *card_ctx;
@@ -1826,6 +1826,11 @@ static int hdmi_lpe_audio_probe(struct platform_device *pdev)
 	return 0;
 }
 
+static int hdmi_lpe_audio_probe(struct platform_device *pdev)
+{
+	return snd_card_free_on_error(&pdev->dev, __hdmi_lpe_audio_probe(pdev));
+}
+
 static const struct dev_pm_ops hdmi_lpe_audio_pm = {
 	SET_SYSTEM_SLEEP_PM_OPS(hdmi_lpe_audio_suspend, hdmi_lpe_audio_resume)
 };
diff --git a/tools/arch/x86/include/asm/msr-index.h b/tools/arch/x86/include/asm/msr-index.h
index a7c413432b33..66ae309840fe 100644
--- a/tools/arch/x86/include/asm/msr-index.h
+++ b/tools/arch/x86/include/asm/msr-index.h
@@ -128,9 +128,9 @@
 #define TSX_CTRL_RTM_DISABLE		BIT(0)	/* Disable RTM feature */
 #define TSX_CTRL_CPUID_CLEAR		BIT(1)	/* Disable TSX enumeration */
 
-/* SRBDS support */
 #define MSR_IA32_MCU_OPT_CTRL		0x00000123
-#define RNGDS_MITG_DIS			BIT(0)
+#define RNGDS_MITG_DIS			BIT(0)	/* SRBDS support */
+#define RTM_ALLOW			BIT(1)	/* TSX development mode */
 
 #define MSR_IA32_SYSENTER_CS		0x00000174
 #define MSR_IA32_SYSENTER_ESP		0x00000175
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 51a2219df601..3bfe099d8643 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -1529,7 +1529,9 @@ int parse_events_add_pmu(struct parse_events_state *parse_state,
 	bool use_uncore_alias;
 	LIST_HEAD(config_terms);
 
-	if (verbose > 1) {
+	pmu = parse_state->fake_pmu ?: perf_pmu__find(name);
+
+	if (verbose > 1 && !(pmu && pmu->selectable)) {
 		fprintf(stderr, "Attempting to add event pmu '%s' with '",
 			name);
 		if (head_config) {
@@ -1542,7 +1544,6 @@ int parse_events_add_pmu(struct parse_events_state *parse_state,
 		fprintf(stderr, "' that may result in non-fatal errors\n");
 	}
 
-	pmu = parse_state->fake_pmu ?: perf_pmu__find(name);
 	if (!pmu) {
 		char *err_str;
 
diff --git a/tools/testing/selftests/mqueue/mq_perf_tests.c b/tools/testing/selftests/mqueue/mq_perf_tests.c
index b019e0b8221c..84fda3b49073 100644
--- a/tools/testing/selftests/mqueue/mq_perf_tests.c
+++ b/tools/testing/selftests/mqueue/mq_perf_tests.c
@@ -180,6 +180,9 @@ void shutdown(int exit_val, char *err_cause, int line_no)
 	if (in_shutdown++)
 		return;
 
+	/* Free the cpu_set allocated using CPU_ALLOC in main function */
+	CPU_FREE(cpu_set);
+
 	for (i = 0; i < num_cpus_to_pin; i++)
 		if (cpu_threads[i]) {
 			pthread_kill(cpu_threads[i], SIGUSR1);
@@ -551,6 +554,12 @@ int main(int argc, char *argv[])
 		perror("sysconf(_SC_NPROCESSORS_ONLN)");
 		exit(1);
 	}
+
+	if (getuid() != 0)
+		ksft_exit_skip("Not running as root, but almost all tests "
+			"require root in order to modify\nsystem settings.  "
+			"Exiting.\n");
+
 	cpus_online = min(MAX_CPUS, sysconf(_SC_NPROCESSORS_ONLN));
 	cpu_set = CPU_ALLOC(cpus_online);
 	if (cpu_set == NULL) {
@@ -589,7 +598,7 @@ int main(int argc, char *argv[])
 						cpu_set)) {
 					fprintf(stderr, "Any given CPU may "
 						"only be given once.\n");
-					exit(1);
+					goto err_code;
 				} else
 					CPU_SET_S(cpus_to_pin[cpu],
 						  cpu_set_size, cpu_set);
@@ -607,7 +616,7 @@ int main(int argc, char *argv[])
 				queue_path = malloc(strlen(option) + 2);
 				if (!queue_path) {
 					perror("malloc()");
-					exit(1);
+					goto err_code;
 				}
 				queue_path[0] = '/';
 				queue_path[1] = 0;
@@ -622,17 +631,12 @@ int main(int argc, char *argv[])
 		fprintf(stderr, "Must pass at least one CPU to continuous "
 			"mode.\n");
 		poptPrintUsage(popt_context, stderr, 0);
-		exit(1);
+		goto err_code;
 	} else if (!continuous_mode) {
 		num_cpus_to_pin = 1;
 		cpus_to_pin[0] = cpus_online - 1;
 	}
 
-	if (getuid() != 0)
-		ksft_exit_skip("Not running as root, but almost all tests "
-			"require root in order to modify\nsystem settings.  "
-			"Exiting.\n");
-
 	max_msgs = fopen(MAX_MSGS, "r+");
 	max_msgsize = fopen(MAX_MSGSIZE, "r+");
 	if (!max_msgs)
@@ -740,4 +744,9 @@ int main(int argc, char *argv[])
 			sleep(1);
 	}
 	shutdown(0, "", 0);
+
+err_code:
+	CPU_FREE(cpu_set);
+	exit(1);
+
 }
