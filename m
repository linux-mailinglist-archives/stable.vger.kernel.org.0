Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DECD96EF497
	for <lists+stable@lfdr.de>; Wed, 26 Apr 2023 14:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241014AbjDZMok (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Apr 2023 08:44:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241016AbjDZMoa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Apr 2023 08:44:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEA7A6A58;
        Wed, 26 Apr 2023 05:44:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E16963651;
        Wed, 26 Apr 2023 12:43:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26FFFC433EF;
        Wed, 26 Apr 2023 12:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682512989;
        bh=KIIi6dTsxSoXQHSysz82U5GiBFkvAGhLe8W5vQih5gg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w4Zh7u4hss/xlIq2km+JM8/JyqrX2DYhysQ13PnD2lnb7ckBqBhECP9SvFCSb3j59
         HzLyyE1v94W0hJ67U0IoFG5phso0NCSevRwmtJjfudaEB6e0XRmTUpVtX3ddDxg+hL
         LkmiinOLsbUzCp6C1P9VIyViJhfYEZ17wjkB6pUY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 6.2.13
Date:   Wed, 26 Apr 2023 14:42:57 +0200
Message-Id: <2023042656-undercook-feminize-8128@gregkh>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <2023042656-sprain-lung-de64@gregkh>
References: <2023042656-sprain-lung-de64@gregkh>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Documentation/admin-guide/kernel-parameters.rst b/Documentation/admin-guide/kernel-parameters.rst
index 959f73a32712..426440f5d79f 100644
--- a/Documentation/admin-guide/kernel-parameters.rst
+++ b/Documentation/admin-guide/kernel-parameters.rst
@@ -128,6 +128,7 @@ parameter is applicable::
 	KVM	Kernel Virtual Machine support is enabled.
 	LIBATA  Libata driver is enabled
 	LP	Printer support is enabled.
+	LOONGARCH LoongArch architecture is enabled.
 	LOOP	Loopback device support is enabled.
 	M68k	M68k architecture is enabled.
 			These options have more detailed description inside of
diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 6cfa6e3996cf..8cf1595545ac 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -6874,6 +6874,12 @@
 			When enabled, memory and cache locality will be
 			impacted.
 
+	writecombine=	[LOONGARCH] Control the MAT (Memory Access Type) of
+			ioremap_wc().
+
+			on   - Enable writecombine, use WUC for ioremap_wc()
+			off  - Disable writecombine, use SUC for ioremap_wc()
+
 	x2apic_phys	[X86-64,APIC] Use x2apic physical mode instead of
 			default x2apic cluster mode on platforms
 			supporting x2apic.
diff --git a/Makefile b/Makefile
index 068374cc2601..f76a4a63aaf5 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 6
 PATCHLEVEL = 2
-SUBLEVEL = 12
+SUBLEVEL = 13
 EXTRAVERSION =
 NAME = Hurr durr I'ma ninja sloth
 
diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
index 2ca76b69add7..511ca864c1b2 100644
--- a/arch/arm/boot/dts/rk3288.dtsi
+++ b/arch/arm/boot/dts/rk3288.dtsi
@@ -942,7 +942,7 @@ wdt: watchdog@ff800000 {
 		status = "disabled";
 	};
 
-	spdif: sound@ff88b0000 {
+	spdif: sound@ff8b0000 {
 		compatible = "rockchip,rk3288-spdif", "rockchip,rk3066-spdif";
 		reg = <0x0 0xff8b0000 0x0 0x10000>;
 		#sound-dai-cells = <0>;
diff --git a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
index c063a144e0e7..42027c78c8de 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
@@ -1571,15 +1571,20 @@ usb2_phy0: phy@36000 {
 
 			dmc: bus@38000 {
 				compatible = "simple-bus";
-				reg = <0x0 0x38000 0x0 0x400>;
 				#address-cells = <2>;
 				#size-cells = <2>;
-				ranges = <0x0 0x0 0x0 0x38000 0x0 0x400>;
+				ranges = <0x0 0x0 0x0 0x38000 0x0 0x2000>;
 
 				canvas: video-lut@48 {
 					compatible = "amlogic,canvas";
 					reg = <0x0 0x48 0x0 0x14>;
 				};
+
+				pmu: pmu@80 {
+					reg = <0x0 0x80 0x0 0x40>,
+					      <0x0 0xc00 0x0 0x40>;
+					interrupts = <GIC_SPI 52 IRQ_TYPE_EDGE_RISING>;
+				};
 			};
 
 			usb2_phy1: phy@3a000 {
@@ -1705,12 +1710,6 @@ internal_ephy: ethernet-phy@8 {
 			};
 		};
 
-		pmu: pmu@ff638000 {
-			reg = <0x0 0xff638000 0x0 0x100>,
-			      <0x0 0xff638c00 0x0 0x100>;
-			interrupts = <GIC_SPI 52 IRQ_TYPE_EDGE_RISING>;
-		};
-
 		aobus: bus@ff800000 {
 			compatible = "simple-bus";
 			reg = <0x0 0xff800000 0x0 0x100000>;
diff --git a/arch/arm64/boot/dts/freescale/imx8mm-evk.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-evk.dtsi
index e0b604ac0da4..85661825b838 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-evk.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-evk.dtsi
@@ -194,7 +194,7 @@ pmic@4b {
 		rohm,reset-snvs-powered;
 
 		#clock-cells = <0>;
-		clocks = <&osc_32k 0>;
+		clocks = <&osc_32k>;
 		clock-output-names = "clk-32k-out";
 
 		regulators {
diff --git a/arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi
index 702d87621bb4..1381b9ce3d5e 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi
@@ -95,7 +95,7 @@ reg_ethphy: regulator-ethphy {
 		compatible = "regulator-fixed";
 		enable-active-high;
 		gpio = <&gpio2 20 GPIO_ACTIVE_HIGH>; /* PMIC_EN_ETH */
-		off-on-delay = <500000>;
+		off-on-delay-us = <500000>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&pinctrl_reg_eth>;
 		regulator-always-on;
@@ -135,7 +135,7 @@ reg_usdhc2_vmmc: regulator-usdhc2 {
 		enable-active-high;
 		/* Verdin SD_1_PWR_EN (SODIMM 76) */
 		gpio = <&gpio3 5 GPIO_ACTIVE_HIGH>;
-		off-on-delay = <100000>;
+		off-on-delay-us = <100000>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&pinctrl_usdhc2_pwr_en>;
 		regulator-max-microvolt = <3300000>;
diff --git a/arch/arm64/boot/dts/freescale/imx8mp-verdin-dev.dtsi b/arch/arm64/boot/dts/freescale/imx8mp-verdin-dev.dtsi
index cefabe65b252..c8b521d45fca 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-verdin-dev.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp-verdin-dev.dtsi
@@ -12,7 +12,7 @@ reg_eth2phy: regulator-eth2phy {
 		compatible = "regulator-fixed";
 		enable-active-high;
 		gpio = <&gpio_expander_21 4 GPIO_ACTIVE_HIGH>; /* ETH_PWR_EN */
-		off-on-delay = <500000>;
+		off-on-delay-us = <500000>;
 		regulator-max-microvolt = <3300000>;
 		regulator-min-microvolt = <3300000>;
 		regulator-name = "+V3.3_ETH";
diff --git a/arch/arm64/boot/dts/freescale/imx8mp-verdin.dtsi b/arch/arm64/boot/dts/freescale/imx8mp-verdin.dtsi
index 6a1890a4b5d8..947e4537303f 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-verdin.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp-verdin.dtsi
@@ -87,7 +87,7 @@ reg_module_eth1phy: regulator-module-eth1phy {
 		compatible = "regulator-fixed";
 		enable-active-high;
 		gpio = <&gpio2 20 GPIO_ACTIVE_HIGH>; /* PMIC_EN_ETH */
-		off-on-delay = <500000>;
+		off-on-delay-us = <500000>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&pinctrl_reg_eth>;
 		regulator-always-on;
@@ -128,7 +128,7 @@ reg_usdhc2_vmmc: regulator-usdhc2 {
 		enable-active-high;
 		/* Verdin SD_1_PWR_EN (SODIMM 76) */
 		gpio = <&gpio4 22 GPIO_ACTIVE_HIGH>;
-		off-on-delay = <100000>;
+		off-on-delay-us = <100000>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&pinctrl_usdhc2_pwr_en>;
 		regulator-max-microvolt = <3300000>;
diff --git a/arch/arm64/boot/dts/qcom/ipq8074-hk01.dts b/arch/arm64/boot/dts/qcom/ipq8074-hk01.dts
index ca3f96646b90..5cf07caf4103 100644
--- a/arch/arm64/boot/dts/qcom/ipq8074-hk01.dts
+++ b/arch/arm64/boot/dts/qcom/ipq8074-hk01.dts
@@ -62,11 +62,11 @@ &pcie1 {
 	perst-gpios = <&tlmm 58 GPIO_ACTIVE_LOW>;
 };
 
-&pcie_phy0 {
+&pcie_qmp0 {
 	status = "okay";
 };
 
-&pcie_phy1 {
+&pcie_qmp1 {
 	status = "okay";
 };
 
diff --git a/arch/arm64/boot/dts/qcom/ipq8074-hk10.dtsi b/arch/arm64/boot/dts/qcom/ipq8074-hk10.dtsi
index 651a231554e0..1b8379ba87f9 100644
--- a/arch/arm64/boot/dts/qcom/ipq8074-hk10.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq8074-hk10.dtsi
@@ -48,11 +48,11 @@ &pcie1 {
 	perst-gpios = <&tlmm 61 GPIO_ACTIVE_LOW>;
 };
 
-&pcie_phy0 {
+&pcie_qmp0 {
 	status = "okay";
 };
 
-&pcie_phy1 {
+&pcie_qmp1 {
 	status = "okay";
 };
 
diff --git a/arch/arm64/boot/dts/qcom/sc8280xp-pmics.dtsi b/arch/arm64/boot/dts/qcom/sc8280xp-pmics.dtsi
index f2c0b71b5d8e..896a6925bbc3 100644
--- a/arch/arm64/boot/dts/qcom/sc8280xp-pmics.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8280xp-pmics.dtsi
@@ -59,8 +59,9 @@ pmk8280: pmic@0 {
 		#size-cells = <0>;
 
 		pmk8280_pon: pon@1300 {
-			compatible = "qcom,pm8998-pon";
-			reg = <0x1300>;
+			compatible = "qcom,pmk8350-pon";
+			reg = <0x1300>, <0x800>;
+			reg-names = "hlos", "pbs";
 
 			pmk8280_pon_pwrkey: pwrkey {
 				compatible = "qcom,pmk8350-pwrkey";
diff --git a/arch/arm64/boot/dts/rockchip/rk3566-soquartz.dtsi b/arch/arm64/boot/dts/rockchip/rk3566-soquartz.dtsi
index ce7165d7f1a1..102e448bc026 100644
--- a/arch/arm64/boot/dts/rockchip/rk3566-soquartz.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3566-soquartz.dtsi
@@ -598,7 +598,7 @@ &sdmmc1 {
 	non-removable;
 	pinctrl-names = "default";
 	pinctrl-0 = <&sdmmc1_bus4 &sdmmc1_cmd &sdmmc1_clk>;
-	sd-uhs-sdr104;
+	sd-uhs-sdr50;
 	vmmc-supply = <&vcc3v3_sys>;
 	vqmmc-supply = <&vcc_1v8>;
 	status = "okay";
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 35a159d131b5..307a840b7886 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -533,9 +533,22 @@ struct kvm_vcpu_arch {
 	({							\
 		__build_check_flag(v, flagset, f, m);		\
 								\
-		v->arch.flagset & (m);				\
+		READ_ONCE(v->arch.flagset) & (m);		\
 	})
 
+/*
+ * Note that the set/clear accessors must be preempt-safe in order to
+ * avoid nesting them with load/put which also manipulate flags...
+ */
+#ifdef __KVM_NVHE_HYPERVISOR__
+/* the nVHE hypervisor is always non-preemptible */
+#define __vcpu_flags_preempt_disable()
+#define __vcpu_flags_preempt_enable()
+#else
+#define __vcpu_flags_preempt_disable()	preempt_disable()
+#define __vcpu_flags_preempt_enable()	preempt_enable()
+#endif
+
 #define __vcpu_set_flag(v, flagset, f, m)			\
 	do {							\
 		typeof(v->arch.flagset) *fset;			\
@@ -543,9 +556,11 @@ struct kvm_vcpu_arch {
 		__build_check_flag(v, flagset, f, m);		\
 								\
 		fset = &v->arch.flagset;			\
+		__vcpu_flags_preempt_disable();			\
 		if (HWEIGHT(m) > 1)				\
 			*fset &= ~(m);				\
 		*fset |= (f);					\
+		__vcpu_flags_preempt_enable();			\
 	} while (0)
 
 #define __vcpu_clear_flag(v, flagset, f, m)			\
@@ -555,7 +570,9 @@ struct kvm_vcpu_arch {
 		__build_check_flag(v, flagset, f, m);		\
 								\
 		fset = &v->arch.flagset;			\
+		__vcpu_flags_preempt_disable();			\
 		*fset &= ~(m);					\
+		__vcpu_flags_preempt_enable();			\
 	} while (0)
 
 #define vcpu_get_flag(v, ...)	__vcpu_get_flag((v), __VA_ARGS__)
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index c9f401fa01a9..950e35b993d2 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -397,6 +397,8 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	u64 val;
 	int wa_level;
 
+	if (KVM_REG_SIZE(reg->id) != sizeof(val))
+		return -ENOENT;
 	if (copy_from_user(&val, uaddr, KVM_REG_SIZE(reg->id)))
 		return -EFAULT;
 
diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
index 9cc8b84f7eb0..e349cc9e3c22 100644
--- a/arch/loongarch/Kconfig
+++ b/arch/loongarch/Kconfig
@@ -94,6 +94,7 @@ config LOONGARCH
 	select HAVE_DYNAMIC_FTRACE_WITH_ARGS
 	select HAVE_DYNAMIC_FTRACE_WITH_REGS
 	select HAVE_EBPF_JIT
+	select HAVE_EFFICIENT_UNALIGNED_ACCESS if !ARCH_STRICT_ALIGN
 	select HAVE_EXIT_THREAD
 	select HAVE_FAST_GUP
 	select HAVE_FTRACE_MCOUNT_RECORD
@@ -441,6 +442,40 @@ config ARCH_IOREMAP
 	  protection support. However, you can enable LoongArch DMW-based
 	  ioremap() for better performance.
 
+config ARCH_WRITECOMBINE
+	bool "Enable WriteCombine (WUC) for ioremap()"
+	help
+	  LoongArch maintains cache coherency in hardware, but when paired
+	  with LS7A chipsets the WUC attribute (Weak-ordered UnCached, which
+	  is similar to WriteCombine) is out of the scope of cache coherency
+	  machanism for PCIe devices (this is a PCIe protocol violation, which
+	  may be fixed in newer chipsets).
+
+	  This means WUC can only used for write-only memory regions now, so
+	  this option is disabled by default, making WUC silently fallback to
+	  SUC for ioremap(). You can enable this option if the kernel is ensured
+	  to run on hardware without this bug.
+
+	  You can override this setting via writecombine=on/off boot parameter.
+
+config ARCH_STRICT_ALIGN
+	bool "Enable -mstrict-align to prevent unaligned accesses" if EXPERT
+	default y
+	help
+	  Not all LoongArch cores support h/w unaligned access, we can use
+	  -mstrict-align build parameter to prevent unaligned accesses.
+
+	  CPUs with h/w unaligned access support:
+	  Loongson-2K2000/2K3000/3A5000/3C5000/3D5000.
+
+	  CPUs without h/w unaligned access support:
+	  Loongson-2K500/2K1000.
+
+	  This option is enabled by default to make the kernel be able to run
+	  on all LoongArch systems. But you can disable it manually if you want
+	  to run kernel only on systems with h/w unaligned access support in
+	  order to optimise for performance.
+
 config KEXEC
 	bool "Kexec system call"
 	select KEXEC_CORE
diff --git a/arch/loongarch/Makefile b/arch/loongarch/Makefile
index 4402387d2755..6e1c931a8507 100644
--- a/arch/loongarch/Makefile
+++ b/arch/loongarch/Makefile
@@ -91,10 +91,15 @@ KBUILD_CPPFLAGS += -DVMLINUX_LOAD_ADDRESS=$(load-y)
 # instead of .eh_frame so we don't discard them.
 KBUILD_CFLAGS += -fno-asynchronous-unwind-tables
 
+ifdef CONFIG_ARCH_STRICT_ALIGN
 # Don't emit unaligned accesses.
 # Not all LoongArch cores support unaligned access, and as kernel we can't
 # rely on others to provide emulation for these accesses.
 KBUILD_CFLAGS += $(call cc-option,-mstrict-align)
+else
+# Optimise for performance on hardware supports unaligned access.
+KBUILD_CFLAGS += $(call cc-option,-mno-strict-align)
+endif
 
 KBUILD_CFLAGS += -isystem $(shell $(CC) -print-file-name=include)
 
diff --git a/arch/loongarch/include/asm/acpi.h b/arch/loongarch/include/asm/acpi.h
index 4198753aa1d0..976a810352c6 100644
--- a/arch/loongarch/include/asm/acpi.h
+++ b/arch/loongarch/include/asm/acpi.h
@@ -41,8 +41,11 @@ extern void loongarch_suspend_enter(void);
 
 static inline unsigned long acpi_get_wakeup_address(void)
 {
+#ifdef CONFIG_SUSPEND
 	extern void loongarch_wakeup_start(void);
 	return (unsigned long)loongarch_wakeup_start;
+#endif
+	return 0UL;
 }
 
 #endif /* _ASM_LOONGARCH_ACPI_H */
diff --git a/arch/loongarch/include/asm/cpu-features.h b/arch/loongarch/include/asm/cpu-features.h
index b07974218393..f6177f133477 100644
--- a/arch/loongarch/include/asm/cpu-features.h
+++ b/arch/loongarch/include/asm/cpu-features.h
@@ -42,6 +42,7 @@
 #define cpu_has_fpu		cpu_opt(LOONGARCH_CPU_FPU)
 #define cpu_has_lsx		cpu_opt(LOONGARCH_CPU_LSX)
 #define cpu_has_lasx		cpu_opt(LOONGARCH_CPU_LASX)
+#define cpu_has_crc32		cpu_opt(LOONGARCH_CPU_CRC32)
 #define cpu_has_complex		cpu_opt(LOONGARCH_CPU_COMPLEX)
 #define cpu_has_crypto		cpu_opt(LOONGARCH_CPU_CRYPTO)
 #define cpu_has_lvz		cpu_opt(LOONGARCH_CPU_LVZ)
diff --git a/arch/loongarch/include/asm/cpu.h b/arch/loongarch/include/asm/cpu.h
index 754f28506791..927577055263 100644
--- a/arch/loongarch/include/asm/cpu.h
+++ b/arch/loongarch/include/asm/cpu.h
@@ -78,25 +78,26 @@ enum cpu_type_enum {
 #define CPU_FEATURE_FPU			3	/* CPU has FPU */
 #define CPU_FEATURE_LSX			4	/* CPU has LSX (128-bit SIMD) */
 #define CPU_FEATURE_LASX		5	/* CPU has LASX (256-bit SIMD) */
-#define CPU_FEATURE_COMPLEX		6	/* CPU has Complex instructions */
-#define CPU_FEATURE_CRYPTO		7	/* CPU has Crypto instructions */
-#define CPU_FEATURE_LVZ			8	/* CPU has Virtualization extension */
-#define CPU_FEATURE_LBT_X86		9	/* CPU has X86 Binary Translation */
-#define CPU_FEATURE_LBT_ARM		10	/* CPU has ARM Binary Translation */
-#define CPU_FEATURE_LBT_MIPS		11	/* CPU has MIPS Binary Translation */
-#define CPU_FEATURE_TLB			12	/* CPU has TLB */
-#define CPU_FEATURE_CSR			13	/* CPU has CSR */
-#define CPU_FEATURE_WATCH		14	/* CPU has watchpoint registers */
-#define CPU_FEATURE_VINT		15	/* CPU has vectored interrupts */
-#define CPU_FEATURE_CSRIPI		16	/* CPU has CSR-IPI */
-#define CPU_FEATURE_EXTIOI		17	/* CPU has EXT-IOI */
-#define CPU_FEATURE_PREFETCH		18	/* CPU has prefetch instructions */
-#define CPU_FEATURE_PMP			19	/* CPU has perfermance counter */
-#define CPU_FEATURE_SCALEFREQ		20	/* CPU supports cpufreq scaling */
-#define CPU_FEATURE_FLATMODE		21	/* CPU has flat mode */
-#define CPU_FEATURE_EIODECODE		22	/* CPU has EXTIOI interrupt pin decode mode */
-#define CPU_FEATURE_GUESTID		23	/* CPU has GuestID feature */
-#define CPU_FEATURE_HYPERVISOR		24	/* CPU has hypervisor (running in VM) */
+#define CPU_FEATURE_CRC32		6	/* CPU has CRC32 instructions */
+#define CPU_FEATURE_COMPLEX		7	/* CPU has Complex instructions */
+#define CPU_FEATURE_CRYPTO		8	/* CPU has Crypto instructions */
+#define CPU_FEATURE_LVZ			9	/* CPU has Virtualization extension */
+#define CPU_FEATURE_LBT_X86		10	/* CPU has X86 Binary Translation */
+#define CPU_FEATURE_LBT_ARM		11	/* CPU has ARM Binary Translation */
+#define CPU_FEATURE_LBT_MIPS		12	/* CPU has MIPS Binary Translation */
+#define CPU_FEATURE_TLB			13	/* CPU has TLB */
+#define CPU_FEATURE_CSR			14	/* CPU has CSR */
+#define CPU_FEATURE_WATCH		15	/* CPU has watchpoint registers */
+#define CPU_FEATURE_VINT		16	/* CPU has vectored interrupts */
+#define CPU_FEATURE_CSRIPI		17	/* CPU has CSR-IPI */
+#define CPU_FEATURE_EXTIOI		18	/* CPU has EXT-IOI */
+#define CPU_FEATURE_PREFETCH		19	/* CPU has prefetch instructions */
+#define CPU_FEATURE_PMP			20	/* CPU has perfermance counter */
+#define CPU_FEATURE_SCALEFREQ		21	/* CPU supports cpufreq scaling */
+#define CPU_FEATURE_FLATMODE		22	/* CPU has flat mode */
+#define CPU_FEATURE_EIODECODE		23	/* CPU has EXTIOI interrupt pin decode mode */
+#define CPU_FEATURE_GUESTID		24	/* CPU has GuestID feature */
+#define CPU_FEATURE_HYPERVISOR		25	/* CPU has hypervisor (running in VM) */
 
 #define LOONGARCH_CPU_CPUCFG		BIT_ULL(CPU_FEATURE_CPUCFG)
 #define LOONGARCH_CPU_LAM		BIT_ULL(CPU_FEATURE_LAM)
@@ -104,6 +105,7 @@ enum cpu_type_enum {
 #define LOONGARCH_CPU_FPU		BIT_ULL(CPU_FEATURE_FPU)
 #define LOONGARCH_CPU_LSX		BIT_ULL(CPU_FEATURE_LSX)
 #define LOONGARCH_CPU_LASX		BIT_ULL(CPU_FEATURE_LASX)
+#define LOONGARCH_CPU_CRC32		BIT_ULL(CPU_FEATURE_CRC32)
 #define LOONGARCH_CPU_COMPLEX		BIT_ULL(CPU_FEATURE_COMPLEX)
 #define LOONGARCH_CPU_CRYPTO		BIT_ULL(CPU_FEATURE_CRYPTO)
 #define LOONGARCH_CPU_LVZ		BIT_ULL(CPU_FEATURE_LVZ)
diff --git a/arch/loongarch/include/asm/io.h b/arch/loongarch/include/asm/io.h
index 402a7d9e3a53..545e2708fbf7 100644
--- a/arch/loongarch/include/asm/io.h
+++ b/arch/loongarch/include/asm/io.h
@@ -54,8 +54,10 @@ static inline void __iomem *ioremap_prot(phys_addr_t offset, unsigned long size,
  * @offset:    bus address of the memory
  * @size:      size of the resource to map
  */
+extern pgprot_t pgprot_wc;
+
 #define ioremap_wc(offset, size)	\
-	ioremap_prot((offset), (size), pgprot_val(PAGE_KERNEL_WUC))
+	ioremap_prot((offset), (size), pgprot_val(pgprot_wc))
 
 #define ioremap_cache(offset, size)	\
 	ioremap_prot((offset), (size), pgprot_val(PAGE_KERNEL))
diff --git a/arch/loongarch/include/asm/loongarch.h b/arch/loongarch/include/asm/loongarch.h
index 7f8d57a61c8b..62835d84a647 100644
--- a/arch/loongarch/include/asm/loongarch.h
+++ b/arch/loongarch/include/asm/loongarch.h
@@ -117,7 +117,7 @@ static inline u32 read_cpucfg(u32 reg)
 #define  CPUCFG1_EP			BIT(22)
 #define  CPUCFG1_RPLV			BIT(23)
 #define  CPUCFG1_HUGEPG			BIT(24)
-#define  CPUCFG1_IOCSRBRD		BIT(25)
+#define  CPUCFG1_CRC32			BIT(25)
 #define  CPUCFG1_MSGINT			BIT(26)
 
 #define LOONGARCH_CPUCFG2		0x2
diff --git a/arch/loongarch/include/asm/module.lds.h b/arch/loongarch/include/asm/module.lds.h
index 438f09d4ccf4..88554f92e010 100644
--- a/arch/loongarch/include/asm/module.lds.h
+++ b/arch/loongarch/include/asm/module.lds.h
@@ -2,8 +2,8 @@
 /* Copyright (C) 2020-2022 Loongson Technology Corporation Limited */
 SECTIONS {
 	. = ALIGN(4);
-	.got : { BYTE(0) }
-	.plt : { BYTE(0) }
-	.plt.idx : { BYTE(0) }
-	.ftrace_trampoline : { BYTE(0) }
+	.got 0 : { BYTE(0) }
+	.plt 0 : { BYTE(0) }
+	.plt.idx 0 : { BYTE(0) }
+	.ftrace_trampoline 0 : { BYTE(0) }
 }
diff --git a/arch/loongarch/kernel/Makefile b/arch/loongarch/kernel/Makefile
index c8cfbd562921..df5dbabfe7a6 100644
--- a/arch/loongarch/kernel/Makefile
+++ b/arch/loongarch/kernel/Makefile
@@ -8,13 +8,15 @@ extra-y		:= vmlinux.lds
 obj-y		+= head.o cpu-probe.o cacheinfo.o env.o setup.o entry.o genex.o \
 		   traps.o irq.o idle.o process.o dma.o mem.o io.o reset.o switch.o \
 		   elf.o syscall.o signal.o time.o topology.o inst.o ptrace.o vdso.o \
-		   alternative.o unaligned.o unwind.o
+		   alternative.o unwind.o
 
 obj-$(CONFIG_ACPI)		+= acpi.o
 obj-$(CONFIG_EFI) 		+= efi.o
 
 obj-$(CONFIG_CPU_HAS_FPU)	+= fpu.o
 
+obj-$(CONFIG_ARCH_STRICT_ALIGN)	+= unaligned.o
+
 ifdef CONFIG_FUNCTION_TRACER
   ifndef CONFIG_DYNAMIC_FTRACE
     obj-y += mcount.o ftrace.o
diff --git a/arch/loongarch/kernel/cpu-probe.c b/arch/loongarch/kernel/cpu-probe.c
index 3a3fce2d7846..5adf0f736c6d 100644
--- a/arch/loongarch/kernel/cpu-probe.c
+++ b/arch/loongarch/kernel/cpu-probe.c
@@ -60,7 +60,7 @@ static inline void set_elf_platform(int cpu, const char *plat)
 
 /* MAP BASE */
 unsigned long vm_map_base;
-EXPORT_SYMBOL_GPL(vm_map_base);
+EXPORT_SYMBOL(vm_map_base);
 
 static void cpu_probe_addrbits(struct cpuinfo_loongarch *c)
 {
@@ -94,13 +94,18 @@ static void cpu_probe_common(struct cpuinfo_loongarch *c)
 	c->options = LOONGARCH_CPU_CPUCFG | LOONGARCH_CPU_CSR |
 		     LOONGARCH_CPU_TLB | LOONGARCH_CPU_VINT | LOONGARCH_CPU_WATCH;
 
-	elf_hwcap = HWCAP_LOONGARCH_CPUCFG | HWCAP_LOONGARCH_CRC32;
+	elf_hwcap = HWCAP_LOONGARCH_CPUCFG;
 
 	config = read_cpucfg(LOONGARCH_CPUCFG1);
 	if (config & CPUCFG1_UAL) {
 		c->options |= LOONGARCH_CPU_UAL;
 		elf_hwcap |= HWCAP_LOONGARCH_UAL;
 	}
+	if (config & CPUCFG1_CRC32) {
+		c->options |= LOONGARCH_CPU_CRC32;
+		elf_hwcap |= HWCAP_LOONGARCH_CRC32;
+	}
+
 
 	config = read_cpucfg(LOONGARCH_CPUCFG2);
 	if (config & CPUCFG2_LAM) {
diff --git a/arch/loongarch/kernel/proc.c b/arch/loongarch/kernel/proc.c
index 5c67cc4fd56d..0d82907b5404 100644
--- a/arch/loongarch/kernel/proc.c
+++ b/arch/loongarch/kernel/proc.c
@@ -76,6 +76,7 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 	if (cpu_has_fpu)	seq_printf(m, " fpu");
 	if (cpu_has_lsx)	seq_printf(m, " lsx");
 	if (cpu_has_lasx)	seq_printf(m, " lasx");
+	if (cpu_has_crc32)	seq_printf(m, " crc32");
 	if (cpu_has_complex)	seq_printf(m, " complex");
 	if (cpu_has_crypto)	seq_printf(m, " crypto");
 	if (cpu_has_lvz)	seq_printf(m, " lvz");
diff --git a/arch/loongarch/kernel/setup.c b/arch/loongarch/kernel/setup.c
index 4344502c0b31..7ac1aecc7687 100644
--- a/arch/loongarch/kernel/setup.c
+++ b/arch/loongarch/kernel/setup.c
@@ -160,6 +160,27 @@ static void __init smbios_parse(void)
 	dmi_walk(find_tokens, NULL);
 }
 
+#ifdef CONFIG_ARCH_WRITECOMBINE
+pgprot_t pgprot_wc = PAGE_KERNEL_WUC;
+#else
+pgprot_t pgprot_wc = PAGE_KERNEL_SUC;
+#endif
+
+EXPORT_SYMBOL(pgprot_wc);
+
+static int __init setup_writecombine(char *p)
+{
+	if (!strcmp(p, "on"))
+		pgprot_wc = PAGE_KERNEL_WUC;
+	else if (!strcmp(p, "off"))
+		pgprot_wc = PAGE_KERNEL_SUC;
+	else
+		pr_warn("Unknown writecombine setting \"%s\".\n", p);
+
+	return 0;
+}
+early_param("writecombine", setup_writecombine);
+
 static int usermem __initdata;
 
 static int __init early_parse_mem(char *p)
diff --git a/arch/loongarch/kernel/stacktrace.c b/arch/loongarch/kernel/stacktrace.c
index 3a690f96f00c..2463d2fea21f 100644
--- a/arch/loongarch/kernel/stacktrace.c
+++ b/arch/loongarch/kernel/stacktrace.c
@@ -30,7 +30,7 @@ void arch_stack_walk(stack_trace_consume_fn consume_entry, void *cookie,
 
 	regs->regs[1] = 0;
 	for (unwind_start(&state, task, regs);
-	      !unwind_done(&state); unwind_next_frame(&state)) {
+	     !unwind_done(&state) && !unwind_error(&state); unwind_next_frame(&state)) {
 		addr = unwind_get_return_address(&state);
 		if (!addr || !consume_entry(cookie, addr))
 			break;
diff --git a/arch/loongarch/kernel/traps.c b/arch/loongarch/kernel/traps.c
index c38a146a973b..05511203732c 100644
--- a/arch/loongarch/kernel/traps.c
+++ b/arch/loongarch/kernel/traps.c
@@ -371,9 +371,14 @@ int no_unaligned_warning __read_mostly = 1;	/* Only 1 warning by default */
 
 asmlinkage void noinstr do_ale(struct pt_regs *regs)
 {
-	unsigned int *pc;
 	irqentry_state_t state = irqentry_enter(regs);
 
+#ifndef CONFIG_ARCH_STRICT_ALIGN
+	die_if_kernel("Kernel ale access", regs);
+	force_sig_fault(SIGBUS, BUS_ADRALN, (void __user *)regs->csr_badvaddr);
+#else
+	unsigned int *pc;
+
 	perf_sw_event(PERF_COUNT_SW_ALIGNMENT_FAULTS, 1, regs, regs->csr_badvaddr);
 
 	/*
@@ -397,8 +402,8 @@ asmlinkage void noinstr do_ale(struct pt_regs *regs)
 sigbus:
 	die_if_kernel("Kernel ale access", regs);
 	force_sig_fault(SIGBUS, BUS_ADRALN, (void __user *)regs->csr_badvaddr);
-
 out:
+#endif
 	irqentry_exit(regs, state);
 }
 
diff --git a/arch/loongarch/kernel/unwind.c b/arch/loongarch/kernel/unwind.c
index a463d6961344..ba324ba76fa1 100644
--- a/arch/loongarch/kernel/unwind.c
+++ b/arch/loongarch/kernel/unwind.c
@@ -28,5 +28,6 @@ bool default_next_frame(struct unwind_state *state)
 
 	} while (!get_stack_info(state->sp, state->task, info));
 
+	state->error = true;
 	return false;
 }
diff --git a/arch/loongarch/kernel/unwind_prologue.c b/arch/loongarch/kernel/unwind_prologue.c
index 9095fde8e55d..55afc27320e1 100644
--- a/arch/loongarch/kernel/unwind_prologue.c
+++ b/arch/loongarch/kernel/unwind_prologue.c
@@ -211,7 +211,7 @@ static bool next_frame(struct unwind_state *state)
 			pc = regs->csr_era;
 
 			if (user_mode(regs) || !__kernel_text_address(pc))
-				return false;
+				goto out;
 
 			state->first = true;
 			state->pc = pc;
@@ -226,6 +226,8 @@ static bool next_frame(struct unwind_state *state)
 
 	} while (!get_stack_info(state->sp, state->task, info));
 
+out:
+	state->error = true;
 	return false;
 }
 
diff --git a/arch/loongarch/mm/init.c b/arch/loongarch/mm/init.c
index e018aed34586..3b7d8129570b 100644
--- a/arch/loongarch/mm/init.c
+++ b/arch/loongarch/mm/init.c
@@ -41,7 +41,7 @@
  * don't have to care about aliases on other CPUs.
  */
 unsigned long empty_zero_page, zero_page_mask;
-EXPORT_SYMBOL_GPL(empty_zero_page);
+EXPORT_SYMBOL(empty_zero_page);
 EXPORT_SYMBOL(zero_page_mask);
 
 void setup_zero_pages(void)
@@ -270,7 +270,7 @@ pud_t invalid_pud_table[PTRS_PER_PUD] __page_aligned_bss;
 #endif
 #ifndef __PAGETABLE_PMD_FOLDED
 pmd_t invalid_pmd_table[PTRS_PER_PMD] __page_aligned_bss;
-EXPORT_SYMBOL_GPL(invalid_pmd_table);
+EXPORT_SYMBOL(invalid_pmd_table);
 #endif
 pte_t invalid_pte_table[PTRS_PER_PTE] __page_aligned_bss;
 EXPORT_SYMBOL(invalid_pte_table);
diff --git a/arch/mips/kernel/vmlinux.lds.S b/arch/mips/kernel/vmlinux.lds.S
index 1f98947fe715..91d6a5360bb9 100644
--- a/arch/mips/kernel/vmlinux.lds.S
+++ b/arch/mips/kernel/vmlinux.lds.S
@@ -15,6 +15,8 @@
 #define EMITS_PT_NOTE
 #endif
 
+#define RUNTIME_DISCARD_EXIT
+
 #include <asm-generic/vmlinux.lds.h>
 
 #undef mips
diff --git a/arch/riscv/purgatory/Makefile b/arch/riscv/purgatory/Makefile
index dd58e1d99397..659e21862077 100644
--- a/arch/riscv/purgatory/Makefile
+++ b/arch/riscv/purgatory/Makefile
@@ -74,9 +74,7 @@ CFLAGS_string.o			+= $(PURGATORY_CFLAGS)
 CFLAGS_REMOVE_ctype.o		+= $(PURGATORY_CFLAGS_REMOVE)
 CFLAGS_ctype.o			+= $(PURGATORY_CFLAGS)
 
-AFLAGS_REMOVE_entry.o		+= -Wa,-gdwarf-2
-AFLAGS_REMOVE_memcpy.o		+= -Wa,-gdwarf-2
-AFLAGS_REMOVE_memset.o		+= -Wa,-gdwarf-2
+asflags-remove-y		+= $(foreach x, -g -gdwarf-4 -gdwarf-5, $(x) -Wa,$(x))
 
 $(obj)/purgatory.ro: $(PURGATORY_OBJS) FORCE
 		$(call if_changed,ld)
diff --git a/arch/s390/kernel/ptrace.c b/arch/s390/kernel/ptrace.c
index 53e0209229f8..092b16b4dd4f 100644
--- a/arch/s390/kernel/ptrace.c
+++ b/arch/s390/kernel/ptrace.c
@@ -474,9 +474,7 @@ long arch_ptrace(struct task_struct *child, long request,
 		}
 		return 0;
 	case PTRACE_GET_LAST_BREAK:
-		put_user(child->thread.last_break,
-			 (unsigned long __user *) data);
-		return 0;
+		return put_user(child->thread.last_break, (unsigned long __user *)data);
 	case PTRACE_ENABLE_TE:
 		if (!MACHINE_HAS_TE)
 			return -EIO;
@@ -824,9 +822,7 @@ long compat_arch_ptrace(struct task_struct *child, compat_long_t request,
 		}
 		return 0;
 	case PTRACE_GET_LAST_BREAK:
-		put_user(child->thread.last_break,
-			 (unsigned int __user *) data);
-		return 0;
+		return put_user(child->thread.last_break, (unsigned int __user *)data);
 	}
 	return compat_ptrace_request(child, request, addr, data);
 }
diff --git a/arch/x86/purgatory/Makefile b/arch/x86/purgatory/Makefile
index 17f09dc26381..82fec66d46d2 100644
--- a/arch/x86/purgatory/Makefile
+++ b/arch/x86/purgatory/Makefile
@@ -69,8 +69,7 @@ CFLAGS_sha256.o			+= $(PURGATORY_CFLAGS)
 CFLAGS_REMOVE_string.o		+= $(PURGATORY_CFLAGS_REMOVE)
 CFLAGS_string.o			+= $(PURGATORY_CFLAGS)
 
-AFLAGS_REMOVE_setup-x86_$(BITS).o	+= -Wa,-gdwarf-2
-AFLAGS_REMOVE_entry64.o			+= -Wa,-gdwarf-2
+asflags-remove-y		+= $(foreach x, -g -gdwarf-4 -gdwarf-5, $(x) -Wa,$(x))
 
 $(obj)/purgatory.ro: $(PURGATORY_OBJS) FORCE
 		$(call if_changed,ld)
diff --git a/drivers/acpi/acpica/evevent.c b/drivers/acpi/acpica/evevent.c
index 82d1728b9bc6..df596d46dd97 100644
--- a/drivers/acpi/acpica/evevent.c
+++ b/drivers/acpi/acpica/evevent.c
@@ -142,9 +142,6 @@ static acpi_status acpi_ev_fixed_event_initialize(void)
 			status =
 			    acpi_write_bit_register(acpi_gbl_fixed_event_info
 						    [i].enable_register_id,
-						    (i ==
-						     ACPI_EVENT_PCIE_WAKE) ?
-						    ACPI_ENABLE_EVENT :
 						    ACPI_DISABLE_EVENT);
 			if (ACPI_FAILURE(status)) {
 				return (status);
@@ -188,11 +185,6 @@ u32 acpi_ev_fixed_event_detect(void)
 		return (int_status);
 	}
 
-	if (fixed_enable & ACPI_BITMASK_PCIEXP_WAKE_DISABLE)
-		fixed_enable &= ~ACPI_BITMASK_PCIEXP_WAKE_DISABLE;
-	else
-		fixed_enable |= ACPI_BITMASK_PCIEXP_WAKE_DISABLE;
-
 	ACPI_DEBUG_PRINT((ACPI_DB_INTERRUPTS,
 			  "Fixed Event Block: Enable %08X Status %08X\n",
 			  fixed_enable, fixed_status));
@@ -258,9 +250,6 @@ static u32 acpi_ev_fixed_event_dispatch(u32 event)
 	if (!acpi_gbl_fixed_event_handlers[event].handler) {
 		(void)acpi_write_bit_register(acpi_gbl_fixed_event_info[event].
 					      enable_register_id,
-					      (event ==
-					       ACPI_EVENT_PCIE_WAKE) ?
-					      ACPI_ENABLE_EVENT :
 					      ACPI_DISABLE_EVENT);
 
 		ACPI_ERROR((AE_INFO,
diff --git a/drivers/acpi/acpica/hwsleep.c b/drivers/acpi/acpica/hwsleep.c
index 37b3f641feaa..bd936476dda9 100644
--- a/drivers/acpi/acpica/hwsleep.c
+++ b/drivers/acpi/acpica/hwsleep.c
@@ -311,20 +311,6 @@ acpi_status acpi_hw_legacy_wake(u8 sleep_state)
 				    [ACPI_EVENT_SLEEP_BUTTON].
 				    status_register_id, ACPI_CLEAR_STATUS);
 
-	/* Enable pcie wake event if support */
-	if ((acpi_gbl_FADT.flags & ACPI_FADT_PCI_EXPRESS_WAKE)) {
-		(void)
-		    acpi_write_bit_register(acpi_gbl_fixed_event_info
-					    [ACPI_EVENT_PCIE_WAKE].
-					    enable_register_id,
-					    ACPI_DISABLE_EVENT);
-		(void)
-		    acpi_write_bit_register(acpi_gbl_fixed_event_info
-					    [ACPI_EVENT_PCIE_WAKE].
-					    status_register_id,
-					    ACPI_CLEAR_STATUS);
-	}
-
 	acpi_hw_execute_sleep_method(METHOD_PATHNAME__SST, ACPI_SST_WORKING);
 	return_ACPI_STATUS(status);
 }
diff --git a/drivers/acpi/acpica/utglobal.c b/drivers/acpi/acpica/utglobal.c
index 53afa5edb6ec..cda6e16dddf7 100644
--- a/drivers/acpi/acpica/utglobal.c
+++ b/drivers/acpi/acpica/utglobal.c
@@ -186,10 +186,6 @@ struct acpi_fixed_event_info acpi_gbl_fixed_event_info[ACPI_NUM_FIXED_EVENTS] =
 					ACPI_BITREG_RT_CLOCK_ENABLE,
 					ACPI_BITMASK_RT_CLOCK_STATUS,
 					ACPI_BITMASK_RT_CLOCK_ENABLE},
-	/* ACPI_EVENT_PCIE_WAKE     */ {ACPI_BITREG_PCIEXP_WAKE_STATUS,
-					ACPI_BITREG_PCIEXP_WAKE_DISABLE,
-					ACPI_BITMASK_PCIEXP_WAKE_STATUS,
-					ACPI_BITMASK_PCIEXP_WAKE_DISABLE},
 };
 #endif				/* !ACPI_REDUCED_HARDWARE */
 
diff --git a/drivers/fpga/fpga-bridge.c b/drivers/fpga/fpga-bridge.c
index 727704431f61..13918c8c839e 100644
--- a/drivers/fpga/fpga-bridge.c
+++ b/drivers/fpga/fpga-bridge.c
@@ -360,7 +360,6 @@ fpga_bridge_register(struct device *parent, const char *name,
 	bridge->dev.parent = parent;
 	bridge->dev.of_node = parent->of_node;
 	bridge->dev.id = id;
-	of_platform_populate(bridge->dev.of_node, NULL, NULL, &bridge->dev);
 
 	ret = dev_set_name(&bridge->dev, "br%d", id);
 	if (ret)
@@ -372,6 +371,8 @@ fpga_bridge_register(struct device *parent, const char *name,
 		return ERR_PTR(ret);
 	}
 
+	of_platform_populate(bridge->dev.of_node, NULL, NULL, &bridge->dev);
+
 	return bridge;
 
 error_device:
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c
index a6aef488a822..c8413470e057 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c
@@ -597,6 +597,9 @@ int amdgpu_irq_put(struct amdgpu_device *adev, struct amdgpu_irq_src *src,
 	if (!src->enabled_types || !src->funcs->set)
 		return -EINVAL;
 
+	if (WARN_ON(!amdgpu_irq_enabled(adev, src, type)))
+		return -EINVAL;
+
 	if (atomic_dec_and_test(&src->enabled_types[type]))
 		return amdgpu_irq_update(adev, src, type);
 
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
index 78c2ed59e87d..ad8fac86dc70 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
@@ -170,10 +170,21 @@ static inline int dm_set_vblank(struct drm_crtc *crtc, bool enable)
 	if (rc)
 		return rc;
 
-	irq_source = IRQ_TYPE_VBLANK + acrtc->otg_inst;
+	if (amdgpu_in_reset(adev)) {
+		irq_source = IRQ_TYPE_VBLANK + acrtc->otg_inst;
+		/* During gpu-reset we disable and then enable vblank irq, so
+		 * don't use amdgpu_irq_get/put() to avoid refcount change.
+		 */
+		if (!dc_interrupt_set(adev->dm.dc, irq_source, enable))
+			rc = -EBUSY;
+	} else {
+		rc = (enable)
+			? amdgpu_irq_get(adev, &adev->crtc_irq, acrtc->crtc_id)
+			: amdgpu_irq_put(adev, &adev->crtc_irq, acrtc->crtc_id);
+	}
 
-	if (!dc_interrupt_set(adev->dm.dc, irq_source, enable))
-		return -EBUSY;
+	if (rc)
+		return rc;
 
 skip:
 	if (amdgpu_in_reset(adev))
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn31/dcn31_fpu.c b/drivers/gpu/drm/amd/display/dc/dml/dcn31/dcn31_fpu.c
index b37d14369a62..59836570603a 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn31/dcn31_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn31/dcn31_fpu.c
@@ -222,7 +222,7 @@ struct _vcs_dpi_ip_params_st dcn3_15_ip = {
 	.maximum_dsc_bits_per_component = 10,
 	.dsc422_native_support = false,
 	.is_line_buffer_bpp_fixed = true,
-	.line_buffer_fixed_bpp = 49,
+	.line_buffer_fixed_bpp = 48,
 	.line_buffer_size_bits = 789504,
 	.max_line_buffer_lines = 12,
 	.writeback_interface_buffer_size_kbytes = 90,
diff --git a/drivers/gpu/drm/drm_buddy.c b/drivers/gpu/drm/drm_buddy.c
index 3d1f50f481cf..7098f125b54a 100644
--- a/drivers/gpu/drm/drm_buddy.c
+++ b/drivers/gpu/drm/drm_buddy.c
@@ -146,8 +146,8 @@ int drm_buddy_init(struct drm_buddy *mm, u64 size, u64 chunk_size)
 		unsigned int order;
 		u64 root_size;
 
-		root_size = rounddown_pow_of_two(size);
-		order = ilog2(root_size) - ilog2(chunk_size);
+		order = ilog2(size) - ilog2(chunk_size);
+		root_size = chunk_size << order;
 
 		root = drm_block_alloc(mm, NULL, order, offset);
 		if (!root)
diff --git a/drivers/gpu/drm/i915/display/intel_dp_aux.c b/drivers/gpu/drm/i915/display/intel_dp_aux.c
index 664bebdecea7..d5fed2eb66d2 100644
--- a/drivers/gpu/drm/i915/display/intel_dp_aux.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_aux.c
@@ -166,7 +166,7 @@ static u32 skl_get_aux_send_ctl(struct intel_dp *intel_dp,
 	      DP_AUX_CH_CTL_TIME_OUT_MAX |
 	      DP_AUX_CH_CTL_RECEIVE_ERROR |
 	      (send_bytes << DP_AUX_CH_CTL_MESSAGE_SIZE_SHIFT) |
-	      DP_AUX_CH_CTL_FW_SYNC_PULSE_SKL(32) |
+	      DP_AUX_CH_CTL_FW_SYNC_PULSE_SKL(24) |
 	      DP_AUX_CH_CTL_SYNC_PULSE_SKL(32);
 
 	if (intel_tc_port_in_tbt_alt_mode(dig_port))
diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
index 8cecf81a5ae0..3c05ce01f73b 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
@@ -840,6 +840,8 @@ static void vop2_enable(struct vop2 *vop2)
 		return;
 	}
 
+	regcache_sync(vop2->map);
+
 	if (vop2->data->soc_id == 3566)
 		vop2_writel(vop2, RK3568_OTP_WIN_EN, 1);
 
@@ -868,6 +870,8 @@ static void vop2_disable(struct vop2 *vop2)
 
 	pm_runtime_put_sync(vop2->dev);
 
+	regcache_mark_dirty(vop2->map);
+
 	clk_disable_unprepare(vop2->aclk);
 	clk_disable_unprepare(vop2->hclk);
 }
diff --git a/drivers/gpu/drm/tests/drm_buddy_test.c b/drivers/gpu/drm/tests/drm_buddy_test.c
index f8ee714df396..09ee6f6af896 100644
--- a/drivers/gpu/drm/tests/drm_buddy_test.c
+++ b/drivers/gpu/drm/tests/drm_buddy_test.c
@@ -89,7 +89,8 @@ static int check_block(struct kunit *test, struct drm_buddy *mm,
 		err = -EINVAL;
 	}
 
-	if (!is_power_of_2(block_size)) {
+	/* We can't use is_power_of_2() for a u64 on 32-bit systems. */
+	if (block_size & (block_size - 1)) {
 		kunit_err(test, "block size not power of two\n");
 		err = -EINVAL;
 	}
diff --git a/drivers/iio/adc/at91-sama5d2_adc.c b/drivers/iio/adc/at91-sama5d2_adc.c
index ed4f8501bda8..ed4961c29d5f 100644
--- a/drivers/iio/adc/at91-sama5d2_adc.c
+++ b/drivers/iio/adc/at91-sama5d2_adc.c
@@ -1409,7 +1409,7 @@ static struct iio_trigger *at91_adc_allocate_trigger(struct iio_dev *indio,
 	trig = devm_iio_trigger_alloc(&indio->dev, "%s-dev%d-%s", indio->name,
 				iio_device_id(indio), trigger_name);
 	if (!trig)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	trig->dev.parent = indio->dev.parent;
 	iio_trigger_set_drvdata(trig, indio);
diff --git a/drivers/iio/dac/ad5755.c b/drivers/iio/dac/ad5755.c
index beadfa938d2d..404865e35460 100644
--- a/drivers/iio/dac/ad5755.c
+++ b/drivers/iio/dac/ad5755.c
@@ -802,6 +802,7 @@ static struct ad5755_platform_data *ad5755_parse_fw(struct device *dev)
 	return pdata;
 
  error_out:
+	fwnode_handle_put(pp);
 	devm_kfree(dev, pdata);
 	return NULL;
 }
diff --git a/drivers/iio/light/tsl2772.c b/drivers/iio/light/tsl2772.c
index ad50baa0202c..e823c145f679 100644
--- a/drivers/iio/light/tsl2772.c
+++ b/drivers/iio/light/tsl2772.c
@@ -601,6 +601,7 @@ static int tsl2772_read_prox_diodes(struct tsl2772_chip *chip)
 			return -EINVAL;
 		}
 	}
+	chip->settings.prox_diode = prox_diode_mask;
 
 	return 0;
 }
diff --git a/drivers/input/tablet/pegasus_notetaker.c b/drivers/input/tablet/pegasus_notetaker.c
index d836d3dcc6a2..a68da2988f9c 100644
--- a/drivers/input/tablet/pegasus_notetaker.c
+++ b/drivers/input/tablet/pegasus_notetaker.c
@@ -296,6 +296,12 @@ static int pegasus_probe(struct usb_interface *intf,
 	pegasus->intf = intf;
 
 	pipe = usb_rcvintpipe(dev, endpoint->bEndpointAddress);
+	/* Sanity check that pipe's type matches endpoint's type */
+	if (usb_pipe_type_check(dev, pipe)) {
+		error = -EINVAL;
+		goto err_free_mem;
+	}
+
 	pegasus->data_len = usb_maxpacket(dev, pipe);
 
 	pegasus->data = usb_alloc_coherent(dev, pegasus->data_len, GFP_KERNEL,
diff --git a/drivers/input/touchscreen/cyttsp5.c b/drivers/input/touchscreen/cyttsp5.c
index 4a23d6231382..434a37317cbe 100644
--- a/drivers/input/touchscreen/cyttsp5.c
+++ b/drivers/input/touchscreen/cyttsp5.c
@@ -111,6 +111,7 @@ struct cyttsp5_sensing_conf_data_dev {
 	__le16 max_z;
 	u8 origin_x;
 	u8 origin_y;
+	u8 panel_id;
 	u8 btn;
 	u8 scan_mode;
 	u8 max_num_of_tch_per_refresh_cycle;
diff --git a/drivers/memstick/core/memstick.c b/drivers/memstick/core/memstick.c
index 660df7d269fa..d410e2e78a3d 100644
--- a/drivers/memstick/core/memstick.c
+++ b/drivers/memstick/core/memstick.c
@@ -410,6 +410,7 @@ static struct memstick_dev *memstick_alloc_card(struct memstick_host *host)
 	return card;
 err_out:
 	host->card = old_card;
+	kfree_const(card->dev.kobj.name);
 	kfree(card);
 	return NULL;
 }
@@ -468,8 +469,10 @@ static void memstick_check(struct work_struct *work)
 				put_device(&card->dev);
 				host->card = NULL;
 			}
-		} else
+		} else {
+			kfree_const(card->dev.kobj.name);
 			kfree(card);
+		}
 	}
 
 out_power_off:
diff --git a/drivers/mmc/host/sdhci_am654.c b/drivers/mmc/host/sdhci_am654.c
index 89953093e20c..672d37ea98d0 100644
--- a/drivers/mmc/host/sdhci_am654.c
+++ b/drivers/mmc/host/sdhci_am654.c
@@ -351,8 +351,6 @@ static void sdhci_am654_write_b(struct sdhci_host *host, u8 val, int reg)
 		 */
 		case MMC_TIMING_SD_HS:
 		case MMC_TIMING_MMC_HS:
-		case MMC_TIMING_UHS_SDR12:
-		case MMC_TIMING_UHS_SDR25:
 			val &= ~SDHCI_CTRL_HISPD;
 		}
 	}
diff --git a/drivers/mtd/spi-nor/core.c b/drivers/mtd/spi-nor/core.c
index 2ef2660f5818..4244c6fd9811 100644
--- a/drivers/mtd/spi-nor/core.c
+++ b/drivers/mtd/spi-nor/core.c
@@ -3344,7 +3344,19 @@ static struct spi_mem_driver spi_nor_driver = {
 	.remove = spi_nor_remove,
 	.shutdown = spi_nor_shutdown,
 };
-module_spi_mem_driver(spi_nor_driver);
+
+static int __init spi_nor_module_init(void)
+{
+	return spi_mem_driver_register(&spi_nor_driver);
+}
+module_init(spi_nor_module_init);
+
+static void __exit spi_nor_module_exit(void)
+{
+	spi_mem_driver_unregister(&spi_nor_driver);
+	spi_nor_debugfs_shutdown();
+}
+module_exit(spi_nor_module_exit);
 
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Huang Shijie <shijie8@gmail.com>");
diff --git a/drivers/mtd/spi-nor/core.h b/drivers/mtd/spi-nor/core.h
index 958cd143c934..f4246c52a1de 100644
--- a/drivers/mtd/spi-nor/core.h
+++ b/drivers/mtd/spi-nor/core.h
@@ -714,8 +714,10 @@ static inline struct spi_nor *mtd_to_spi_nor(struct mtd_info *mtd)
 
 #ifdef CONFIG_DEBUG_FS
 void spi_nor_debugfs_register(struct spi_nor *nor);
+void spi_nor_debugfs_shutdown(void);
 #else
 static inline void spi_nor_debugfs_register(struct spi_nor *nor) {}
+static inline void spi_nor_debugfs_shutdown(void) {}
 #endif
 
 #endif /* __LINUX_MTD_SPI_NOR_INTERNAL_H */
diff --git a/drivers/mtd/spi-nor/debugfs.c b/drivers/mtd/spi-nor/debugfs.c
index ff895f6758ea..558ffecf8ae6 100644
--- a/drivers/mtd/spi-nor/debugfs.c
+++ b/drivers/mtd/spi-nor/debugfs.c
@@ -226,13 +226,13 @@ static void spi_nor_debugfs_unregister(void *data)
 	nor->debugfs_root = NULL;
 }
 
+static struct dentry *rootdir;
+
 void spi_nor_debugfs_register(struct spi_nor *nor)
 {
-	struct dentry *rootdir, *d;
+	struct dentry *d;
 	int ret;
 
-	/* Create rootdir once. Will never be deleted again. */
-	rootdir = debugfs_lookup(SPI_NOR_DEBUGFS_ROOT, NULL);
 	if (!rootdir)
 		rootdir = debugfs_create_dir(SPI_NOR_DEBUGFS_ROOT, NULL);
 
@@ -247,3 +247,8 @@ void spi_nor_debugfs_register(struct spi_nor *nor)
 	debugfs_create_file("capabilities", 0444, d, nor,
 			    &spi_nor_capabilities_fops);
 }
+
+void spi_nor_debugfs_shutdown(void)
+{
+	debugfs_remove(rootdir);
+}
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 415cd95fb140..ddbf892e9b9c 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1775,14 +1775,15 @@ void bond_lower_state_changed(struct slave *slave)
 
 /* The bonding driver uses ether_setup() to convert a master bond device
  * to ARPHRD_ETHER, that resets the target netdevice's flags so we always
- * have to restore the IFF_MASTER flag, and only restore IFF_SLAVE if it was set
+ * have to restore the IFF_MASTER flag, and only restore IFF_SLAVE and IFF_UP
+ * if they were set
  */
 static void bond_ether_setup(struct net_device *bond_dev)
 {
-	unsigned int slave_flag = bond_dev->flags & IFF_SLAVE;
+	unsigned int flags = bond_dev->flags & (IFF_SLAVE | IFF_UP);
 
 	ether_setup(bond_dev);
-	bond_dev->flags |= IFF_MASTER | slave_flag;
+	bond_dev->flags |= IFF_MASTER | flags;
 	bond_dev->priv_flags &= ~IFF_TX_SKB_SHARING;
 }
 
diff --git a/drivers/net/dsa/b53/b53_mmap.c b/drivers/net/dsa/b53/b53_mmap.c
index 70887e0aece3..d9434ed9450d 100644
--- a/drivers/net/dsa/b53/b53_mmap.c
+++ b/drivers/net/dsa/b53/b53_mmap.c
@@ -216,6 +216,18 @@ static int b53_mmap_write64(struct b53_device *dev, u8 page, u8 reg,
 	return 0;
 }
 
+static int b53_mmap_phy_read16(struct b53_device *dev, int addr, int reg,
+			       u16 *value)
+{
+	return -EIO;
+}
+
+static int b53_mmap_phy_write16(struct b53_device *dev, int addr, int reg,
+				u16 value)
+{
+	return -EIO;
+}
+
 static const struct b53_io_ops b53_mmap_ops = {
 	.read8 = b53_mmap_read8,
 	.read16 = b53_mmap_read16,
@@ -227,6 +239,8 @@ static const struct b53_io_ops b53_mmap_ops = {
 	.write32 = b53_mmap_write32,
 	.write48 = b53_mmap_write48,
 	.write64 = b53_mmap_write64,
+	.phy_read16 = b53_mmap_phy_read16,
+	.phy_write16 = b53_mmap_phy_write16,
 };
 
 static int b53_mmap_probe_of(struct platform_device *pdev,
diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 3fffd5da8d3b..ffcad057d065 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -96,7 +96,7 @@ static int ksz8795_change_mtu(struct ksz_device *dev, int frame_size)
 
 	if (frame_size > KSZ8_LEGAL_PACKET_SIZE)
 		ctrl2 |= SW_LEGAL_PACKET_DISABLE;
-	else if (frame_size > KSZ8863_NORMAL_PACKET_SIZE)
+	if (frame_size > KSZ8863_NORMAL_PACKET_SIZE)
 		ctrl1 |= SW_HUGE_PACKET;
 
 	ret = ksz_rmw8(dev, REG_SW_CTRL_1, SW_HUGE_PACKET, ctrl1);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 015b5848b958..47617a95034c 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -2388,7 +2388,7 @@ static int bnxt_async_event_process(struct bnxt *bp,
 	case ASYNC_EVENT_CMPL_EVENT_ID_PHC_UPDATE: {
 		switch (BNXT_EVENT_PHC_EVENT_TYPE(data1)) {
 		case ASYNC_EVENT_CMPL_PHC_UPDATE_EVENT_DATA1_FLAGS_PHC_RTC_UPDATE:
-			if (bp->fw_cap & BNXT_FW_CAP_PTP_RTC) {
+			if (BNXT_PTP_USE_RTC(bp)) {
 				struct bnxt_ptp_cfg *ptp = bp->ptp_cfg;
 				u64 ns;
 
@@ -7628,7 +7628,7 @@ static int __bnxt_hwrm_ptp_qcfg(struct bnxt *bp)
 	u8 flags;
 	int rc;
 
-	if (bp->hwrm_spec_code < 0x10801) {
+	if (bp->hwrm_spec_code < 0x10801 || !BNXT_CHIP_P5_THOR(bp)) {
 		rc = -ENODEV;
 		goto no_ptp;
 	}
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
index dd9be229819a..d3541159487d 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
@@ -1135,7 +1135,7 @@ void cxgb4_cleanup_tc_flower(struct adapter *adap)
 		return;
 
 	if (adap->flower_stats_timer.function)
-		del_timer_sync(&adap->flower_stats_timer);
+		timer_shutdown_sync(&adap->flower_stats_timer);
 	cancel_work_sync(&adap->flower_stats_work);
 	rhashtable_destroy(&adap->flower_tbl);
 	adap->tc_flower_initialized = false;
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 04acd1a992fa..2146e7a13724 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -5288,31 +5288,6 @@ static void e1000_watchdog_task(struct work_struct *work)
 				ew32(TARC(0), tarc0);
 			}
 
-			/* disable TSO for pcie and 10/100 speeds, to avoid
-			 * some hardware issues
-			 */
-			if (!(adapter->flags & FLAG_TSO_FORCE)) {
-				switch (adapter->link_speed) {
-				case SPEED_10:
-				case SPEED_100:
-					e_info("10/100 speed: disabling TSO\n");
-					netdev->features &= ~NETIF_F_TSO;
-					netdev->features &= ~NETIF_F_TSO6;
-					break;
-				case SPEED_1000:
-					netdev->features |= NETIF_F_TSO;
-					netdev->features |= NETIF_F_TSO6;
-					break;
-				default:
-					/* oops */
-					break;
-				}
-				if (hw->mac.type == e1000_pch_spt) {
-					netdev->features &= ~NETIF_F_TSO;
-					netdev->features &= ~NETIF_F_TSO6;
-				}
-			}
-
 			/* enable transmits in the hardware, need to do this
 			 * after setting TARC(0)
 			 */
@@ -7529,6 +7504,32 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 			    NETIF_F_RXCSUM |
 			    NETIF_F_HW_CSUM);
 
+	/* disable TSO for pcie and 10/100 speeds to avoid
+	 * some hardware issues and for i219 to fix transfer
+	 * speed being capped at 60%
+	 */
+	if (!(adapter->flags & FLAG_TSO_FORCE)) {
+		switch (adapter->link_speed) {
+		case SPEED_10:
+		case SPEED_100:
+			e_info("10/100 speed: disabling TSO\n");
+			netdev->features &= ~NETIF_F_TSO;
+			netdev->features &= ~NETIF_F_TSO6;
+			break;
+		case SPEED_1000:
+			netdev->features |= NETIF_F_TSO;
+			netdev->features |= NETIF_F_TSO6;
+			break;
+		default:
+			/* oops */
+			break;
+		}
+		if (hw->mac.type == e1000_pch_spt) {
+			netdev->features &= ~NETIF_F_TSO;
+			netdev->features &= ~NETIF_F_TSO6;
+		}
+	}
+
 	/* Set user-changeable features (subset of all device features) */
 	netdev->hw_features = netdev->features;
 	netdev->hw_features |= NETIF_F_RXFCS;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 8328139db379..3ac7234a85bb 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -11059,8 +11059,11 @@ static void i40e_rebuild(struct i40e_pf *pf, bool reinit, bool lock_acquired)
 					     pf->hw.aq.asq_last_status));
 	}
 	/* reinit the misc interrupt */
-	if (pf->flags & I40E_FLAG_MSIX_ENABLED)
+	if (pf->flags & I40E_FLAG_MSIX_ENABLED) {
 		ret = i40e_setup_misc_vector(pf);
+		if (ret)
+			goto end_unlock;
+	}
 
 	/* Add a filter to drop all Flow control frames from any VSI from being
 	 * transmitted. By doing so we stop a malicious VF from sending out
@@ -14125,15 +14128,15 @@ static int i40e_add_vsi(struct i40e_vsi *vsi)
 		vsi->id = ctxt.vsi_number;
 	}
 
-	vsi->active_filters = 0;
-	clear_bit(__I40E_VSI_OVERFLOW_PROMISC, vsi->state);
 	spin_lock_bh(&vsi->mac_filter_hash_lock);
+	vsi->active_filters = 0;
 	/* If macvlan filters already exist, force them to get loaded */
 	hash_for_each_safe(vsi->mac_filter_hash, bkt, h, f, hlist) {
 		f->state = I40E_FILTER_NEW;
 		f_count++;
 	}
 	spin_unlock_bh(&vsi->mac_filter_hash_lock);
+	clear_bit(__I40E_VSI_OVERFLOW_PROMISC, vsi->state);
 
 	if (f_count) {
 		vsi->flags |= I40E_VSI_FLAG_FILTER_CHANGED;
diff --git a/drivers/net/ethernet/mellanox/mlxfw/mlxfw_mfa2_tlv_multi.c b/drivers/net/ethernet/mellanox/mlxfw/mlxfw_mfa2_tlv_multi.c
index 017d68f1e123..972c571b4158 100644
--- a/drivers/net/ethernet/mellanox/mlxfw/mlxfw_mfa2_tlv_multi.c
+++ b/drivers/net/ethernet/mellanox/mlxfw/mlxfw_mfa2_tlv_multi.c
@@ -31,6 +31,8 @@ mlxfw_mfa2_tlv_next(const struct mlxfw_mfa2_file *mfa2_file,
 
 	if (tlv->type == MLXFW_MFA2_TLV_MULTI_PART) {
 		multi = mlxfw_mfa2_tlv_multi_get(mfa2_file, tlv);
+		if (!multi)
+			return NULL;
 		tlv_len = NLA_ALIGN(tlv_len + be16_to_cpu(multi->total_len));
 	}
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h b/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h
index 48dbfea0a2a1..7cdf0ce24f28 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h
@@ -26,7 +26,7 @@
 #define MLXSW_PCI_CIR_TIMEOUT_MSECS		1000
 
 #define MLXSW_PCI_SW_RESET_TIMEOUT_MSECS	900000
-#define MLXSW_PCI_SW_RESET_WAIT_MSECS		200
+#define MLXSW_PCI_SW_RESET_WAIT_MSECS		400
 #define MLXSW_PCI_FW_READY			0xA1844
 #define MLXSW_PCI_FW_READY_MASK			0xFFFF
 #define MLXSW_PCI_FW_READY_MAGIC		0x5E
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 6a1bff54bc6c..e6aedd8ebd75 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -541,7 +541,6 @@ int efx_net_open(struct net_device *net_dev)
 	else
 		efx->state = STATE_NET_UP;
 
-	efx_selftest_async_start(efx);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index cc30524c2fe4..361687de308d 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -544,6 +544,8 @@ void efx_start_all(struct efx_nic *efx)
 	/* Start the hardware monitor if there is one */
 	efx_start_monitor(efx);
 
+	efx_selftest_async_start(efx);
+
 	/* Link state detection is normally event-driven; we have
 	 * to poll now because we could have missed a change
 	 */
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 61e33e4dd0cd..064406959221 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -728,8 +728,13 @@ static struct page *xdp_linearize_page(struct receive_queue *rq,
 				       int page_off,
 				       unsigned int *len)
 {
-	struct page *page = alloc_page(GFP_ATOMIC);
+	int tailroom = SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+	struct page *page;
 
+	if (page_off + *len + tailroom > PAGE_SIZE)
+		return NULL;
+
+	page = alloc_page(GFP_ATOMIC);
 	if (!page)
 		return NULL;
 
@@ -737,7 +742,6 @@ static struct page *xdp_linearize_page(struct receive_queue *rq,
 	page_off += *len;
 
 	while (--*num_buf) {
-		int tailroom = SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
 		unsigned int buflen;
 		void *buf;
 		int off;
diff --git a/drivers/net/wireless/ath/ath9k/mci.c b/drivers/net/wireless/ath/ath9k/mci.c
index 3363fc4e8966..a0845002d6fe 100644
--- a/drivers/net/wireless/ath/ath9k/mci.c
+++ b/drivers/net/wireless/ath/ath9k/mci.c
@@ -646,9 +646,7 @@ void ath9k_mci_update_wlan_channels(struct ath_softc *sc, bool allow_all)
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath9k_hw_mci *mci = &ah->btcoex_hw.mci;
 	struct ath9k_channel *chan = ah->curchan;
-	static const u32 channelmap[] = {
-		0x00000000, 0xffff0000, 0xffffffff, 0x7fffffff
-	};
+	u32 channelmap[] = {0x00000000, 0xffff0000, 0xffffffff, 0x7fffffff};
 	int i;
 	s16 chan_start, chan_end;
 	u16 wlan_chan;
diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index 5c266062c08f..c35c085dbc87 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -996,10 +996,8 @@ static void xenvif_tx_build_gops(struct xenvif_queue *queue,
 
 		/* No crossing a page as the payload mustn't fragment. */
 		if (unlikely((txreq.offset + txreq.size) > XEN_PAGE_SIZE)) {
-			netdev_err(queue->vif->dev,
-				   "txreq.offset: %u, size: %u, end: %lu\n",
-				   txreq.offset, txreq.size,
-				   (unsigned long)(txreq.offset&~XEN_PAGE_MASK) + txreq.size);
+			netdev_err(queue->vif->dev, "Cross page boundary, txreq.offset: %u, size: %u\n",
+				   txreq.offset, txreq.size);
 			xenvif_fatal_tx_err(queue->vif);
 			break;
 		}
diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 1ca52ac163c2..2c15412649ba 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1605,22 +1605,7 @@ static int nvme_tcp_alloc_queue(struct nvme_ctrl *nctrl, int qid)
 	if (ret)
 		goto err_init_connect;
 
-	queue->rd_enabled = true;
 	set_bit(NVME_TCP_Q_ALLOCATED, &queue->flags);
-	nvme_tcp_init_recv_ctx(queue);
-
-	write_lock_bh(&queue->sock->sk->sk_callback_lock);
-	queue->sock->sk->sk_user_data = queue;
-	queue->state_change = queue->sock->sk->sk_state_change;
-	queue->data_ready = queue->sock->sk->sk_data_ready;
-	queue->write_space = queue->sock->sk->sk_write_space;
-	queue->sock->sk->sk_data_ready = nvme_tcp_data_ready;
-	queue->sock->sk->sk_state_change = nvme_tcp_state_change;
-	queue->sock->sk->sk_write_space = nvme_tcp_write_space;
-#ifdef CONFIG_NET_RX_BUSY_POLL
-	queue->sock->sk->sk_ll_usec = 1;
-#endif
-	write_unlock_bh(&queue->sock->sk->sk_callback_lock);
 
 	return 0;
 
@@ -1640,7 +1625,7 @@ static int nvme_tcp_alloc_queue(struct nvme_ctrl *nctrl, int qid)
 	return ret;
 }
 
-static void nvme_tcp_restore_sock_calls(struct nvme_tcp_queue *queue)
+static void nvme_tcp_restore_sock_ops(struct nvme_tcp_queue *queue)
 {
 	struct socket *sock = queue->sock;
 
@@ -1655,7 +1640,7 @@ static void nvme_tcp_restore_sock_calls(struct nvme_tcp_queue *queue)
 static void __nvme_tcp_stop_queue(struct nvme_tcp_queue *queue)
 {
 	kernel_sock_shutdown(queue->sock, SHUT_RDWR);
-	nvme_tcp_restore_sock_calls(queue);
+	nvme_tcp_restore_sock_ops(queue);
 	cancel_work_sync(&queue->io_work);
 }
 
@@ -1673,21 +1658,42 @@ static void nvme_tcp_stop_queue(struct nvme_ctrl *nctrl, int qid)
 	mutex_unlock(&queue->queue_lock);
 }
 
+static void nvme_tcp_setup_sock_ops(struct nvme_tcp_queue *queue)
+{
+	write_lock_bh(&queue->sock->sk->sk_callback_lock);
+	queue->sock->sk->sk_user_data = queue;
+	queue->state_change = queue->sock->sk->sk_state_change;
+	queue->data_ready = queue->sock->sk->sk_data_ready;
+	queue->write_space = queue->sock->sk->sk_write_space;
+	queue->sock->sk->sk_data_ready = nvme_tcp_data_ready;
+	queue->sock->sk->sk_state_change = nvme_tcp_state_change;
+	queue->sock->sk->sk_write_space = nvme_tcp_write_space;
+#ifdef CONFIG_NET_RX_BUSY_POLL
+	queue->sock->sk->sk_ll_usec = 1;
+#endif
+	write_unlock_bh(&queue->sock->sk->sk_callback_lock);
+}
+
 static int nvme_tcp_start_queue(struct nvme_ctrl *nctrl, int idx)
 {
 	struct nvme_tcp_ctrl *ctrl = to_tcp_ctrl(nctrl);
+	struct nvme_tcp_queue *queue = &ctrl->queues[idx];
 	int ret;
 
+	queue->rd_enabled = true;
+	nvme_tcp_init_recv_ctx(queue);
+	nvme_tcp_setup_sock_ops(queue);
+
 	if (idx)
 		ret = nvmf_connect_io_queue(nctrl, idx);
 	else
 		ret = nvmf_connect_admin_queue(nctrl);
 
 	if (!ret) {
-		set_bit(NVME_TCP_Q_LIVE, &ctrl->queues[idx].flags);
+		set_bit(NVME_TCP_Q_LIVE, &queue->flags);
 	} else {
-		if (test_bit(NVME_TCP_Q_ALLOCATED, &ctrl->queues[idx].flags))
-			__nvme_tcp_stop_queue(&ctrl->queues[idx]);
+		if (test_bit(NVME_TCP_Q_ALLOCATED, &queue->flags))
+			__nvme_tcp_stop_queue(queue);
 		dev_err(nctrl->device,
 			"failed to connect queue: %d ret=%d\n", idx, ret);
 	}
diff --git a/drivers/pci/msi/msi.c b/drivers/pci/msi/msi.c
index 1f716624ca56..ef1d8857a51b 100644
--- a/drivers/pci/msi/msi.c
+++ b/drivers/pci/msi/msi.c
@@ -750,8 +750,7 @@ static int msix_capability_init(struct pci_dev *dev, struct msix_entry *entries,
 	return ret;
 }
 
-static bool pci_msix_validate_entries(struct pci_dev *dev, struct msix_entry *entries,
-				      int nvec, int hwsize)
+static bool pci_msix_validate_entries(struct pci_dev *dev, struct msix_entry *entries, int nvec)
 {
 	bool nogap;
 	int i, j;
@@ -762,10 +761,6 @@ static bool pci_msix_validate_entries(struct pci_dev *dev, struct msix_entry *en
 	nogap = pci_msi_domain_supports(dev, MSI_FLAG_MSIX_CONTIGUOUS, DENY_LEGACY);
 
 	for (i = 0; i < nvec; i++) {
-		/* Entry within hardware limit? */
-		if (entries[i].entry >= hwsize)
-			return false;
-
 		/* Check for duplicate entries */
 		for (j = i + 1; j < nvec; j++) {
 			if (entries[i].entry == entries[j].entry)
@@ -805,7 +800,7 @@ int __pci_enable_msix_range(struct pci_dev *dev, struct msix_entry *entries, int
 	if (hwsize < 0)
 		return hwsize;
 
-	if (!pci_msix_validate_entries(dev, entries, nvec, hwsize))
+	if (!pci_msix_validate_entries(dev, entries, nvec))
 		return -EINVAL;
 
 	if (hwsize < nvec) {
diff --git a/drivers/perf/amlogic/meson_g12_ddr_pmu.c b/drivers/perf/amlogic/meson_g12_ddr_pmu.c
index a78fdb15e26c..8b643888d503 100644
--- a/drivers/perf/amlogic/meson_g12_ddr_pmu.c
+++ b/drivers/perf/amlogic/meson_g12_ddr_pmu.c
@@ -21,23 +21,23 @@
 #define DMC_QOS_IRQ		BIT(30)
 
 /* DMC bandwidth monitor register address offset */
-#define DMC_MON_G12_CTRL0		(0x20  << 2)
-#define DMC_MON_G12_CTRL1		(0x21  << 2)
-#define DMC_MON_G12_CTRL2		(0x22  << 2)
-#define DMC_MON_G12_CTRL3		(0x23  << 2)
-#define DMC_MON_G12_CTRL4		(0x24  << 2)
-#define DMC_MON_G12_CTRL5		(0x25  << 2)
-#define DMC_MON_G12_CTRL6		(0x26  << 2)
-#define DMC_MON_G12_CTRL7		(0x27  << 2)
-#define DMC_MON_G12_CTRL8		(0x28  << 2)
-
-#define DMC_MON_G12_ALL_REQ_CNT		(0x29  << 2)
-#define DMC_MON_G12_ALL_GRANT_CNT	(0x2a  << 2)
-#define DMC_MON_G12_ONE_GRANT_CNT	(0x2b  << 2)
-#define DMC_MON_G12_SEC_GRANT_CNT	(0x2c  << 2)
-#define DMC_MON_G12_THD_GRANT_CNT	(0x2d  << 2)
-#define DMC_MON_G12_FOR_GRANT_CNT	(0x2e  << 2)
-#define DMC_MON_G12_TIMER		(0x2f  << 2)
+#define DMC_MON_G12_CTRL0		(0x0  << 2)
+#define DMC_MON_G12_CTRL1		(0x1  << 2)
+#define DMC_MON_G12_CTRL2		(0x2  << 2)
+#define DMC_MON_G12_CTRL3		(0x3  << 2)
+#define DMC_MON_G12_CTRL4		(0x4  << 2)
+#define DMC_MON_G12_CTRL5		(0x5  << 2)
+#define DMC_MON_G12_CTRL6		(0x6  << 2)
+#define DMC_MON_G12_CTRL7		(0x7  << 2)
+#define DMC_MON_G12_CTRL8		(0x8  << 2)
+
+#define DMC_MON_G12_ALL_REQ_CNT		(0x9  << 2)
+#define DMC_MON_G12_ALL_GRANT_CNT	(0xa  << 2)
+#define DMC_MON_G12_ONE_GRANT_CNT	(0xb  << 2)
+#define DMC_MON_G12_SEC_GRANT_CNT	(0xc  << 2)
+#define DMC_MON_G12_THD_GRANT_CNT	(0xd  << 2)
+#define DMC_MON_G12_FOR_GRANT_CNT	(0xe  << 2)
+#define DMC_MON_G12_TIMER		(0xf  << 2)
 
 /* Each bit represent a axi line */
 PMU_FORMAT_ATTR(event, "config:0-7");
diff --git a/drivers/platform/x86/asus-nb-wmi.c b/drivers/platform/x86/asus-nb-wmi.c
index cb15acdf14a3..e2c9a68d12df 100644
--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -464,7 +464,8 @@ static const struct dmi_system_id asus_quirks[] = {
 		.ident = "ASUS ROG FLOW X13",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "GV301Q"),
+			/* Match GV301** */
+			DMI_MATCH(DMI_PRODUCT_NAME, "GV301"),
 		},
 		.driver_data = &quirk_asus_tablet_mode,
 	},
diff --git a/drivers/platform/x86/gigabyte-wmi.c b/drivers/platform/x86/gigabyte-wmi.c
index 322cfaeda17b..2a426040f749 100644
--- a/drivers/platform/x86/gigabyte-wmi.c
+++ b/drivers/platform/x86/gigabyte-wmi.c
@@ -140,6 +140,7 @@ static u8 gigabyte_wmi_detect_sensor_usability(struct wmi_device *wdev)
 	}}
 
 static const struct dmi_system_id gigabyte_wmi_known_working_platforms[] = {
+	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("A320M-S2H V2-CF"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B450M DS3H-CF"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B450M DS3H WIFI-CF"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B450M S2H V2"),
@@ -150,6 +151,7 @@ static const struct dmi_system_id gigabyte_wmi_known_working_platforms[] = {
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B550I AORUS PRO AX"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B550M AORUS PRO-P"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B550M DS3H"),
+	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B650 AORUS ELITE AX"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B660 GAMING X DDR4"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B660I AORUS PRO DDR4"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("Z390 I AORUS PRO WIFI-CF"),
@@ -159,6 +161,7 @@ static const struct dmi_system_id gigabyte_wmi_known_working_platforms[] = {
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("X570 GAMING X"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("X570 I AORUS PRO WIFI"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("X570 UD"),
+	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("X570S AORUS ELITE"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("Z690M AORUS ELITE AX DDR4"),
 	{ }
 };
diff --git a/drivers/platform/x86/intel/vsec.c b/drivers/platform/x86/intel/vsec.c
index 89c5374e33b3..bcbd522d062b 100644
--- a/drivers/platform/x86/intel/vsec.c
+++ b/drivers/platform/x86/intel/vsec.c
@@ -141,6 +141,7 @@ static int intel_vsec_add_aux(struct pci_dev *pdev, struct intel_vsec_device *in
 
 	ret = ida_alloc(intel_vsec_dev->ida, GFP_KERNEL);
 	if (ret < 0) {
+		kfree(intel_vsec_dev->resource);
 		kfree(intel_vsec_dev);
 		return ret;
 	}
diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
index e01147f66e15..474725714a05 100644
--- a/drivers/pwm/core.c
+++ b/drivers/pwm/core.c
@@ -115,7 +115,14 @@ static int pwm_device_request(struct pwm_device *pwm, const char *label)
 	}
 
 	if (pwm->chip->ops->get_state) {
-		struct pwm_state state;
+		/*
+		 * Zero-initialize state because most drivers are unaware of
+		 * .usage_power. The other members of state are supposed to be
+		 * set by lowlevel drivers. We still initialize the whole
+		 * structure for simplicity even though this might paper over
+		 * faulty implementations of .get_state().
+		 */
+		struct pwm_state state = { 0, };
 
 		err = pwm->chip->ops->get_state(pwm->chip, pwm, &state);
 		trace_pwm_get(pwm, &state, err);
@@ -448,7 +455,7 @@ static void pwm_apply_state_debug(struct pwm_device *pwm,
 {
 	struct pwm_state *last = &pwm->last;
 	struct pwm_chip *chip = pwm->chip;
-	struct pwm_state s1, s2;
+	struct pwm_state s1 = { 0 }, s2 = { 0 };
 	int err;
 
 	if (!IS_ENABLED(CONFIG_PWM_DEBUG))
@@ -530,6 +537,7 @@ static void pwm_apply_state_debug(struct pwm_device *pwm,
 		return;
 	}
 
+	*last = (struct pwm_state){ 0 };
 	err = chip->ops->get_state(chip, pwm, last);
 	trace_pwm_get(pwm, last, err);
 	if (err)
diff --git a/drivers/regulator/fan53555.c b/drivers/regulator/fan53555.c
index 529963a7e4f5..41537c45f036 100644
--- a/drivers/regulator/fan53555.c
+++ b/drivers/regulator/fan53555.c
@@ -8,18 +8,19 @@
 // Copyright (c) 2012 Marvell Technology Ltd.
 // Yunfan Zhang <yfzhang@marvell.com>
 
+#include <linux/bits.h>
+#include <linux/err.h>
+#include <linux/i2c.h>
 #include <linux/module.h>
+#include <linux/of_device.h>
 #include <linux/param.h>
-#include <linux/err.h>
 #include <linux/platform_device.h>
+#include <linux/regmap.h>
 #include <linux/regulator/driver.h>
+#include <linux/regulator/fan53555.h>
 #include <linux/regulator/machine.h>
 #include <linux/regulator/of_regulator.h>
-#include <linux/of_device.h>
-#include <linux/i2c.h>
 #include <linux/slab.h>
-#include <linux/regmap.h>
-#include <linux/regulator/fan53555.h>
 
 /* Voltage setting */
 #define FAN53555_VSEL0		0x00
@@ -60,7 +61,7 @@
 #define TCS_VSEL1_MODE		(1 << 6)
 
 #define TCS_SLEW_SHIFT		3
-#define TCS_SLEW_MASK		(0x3 < 3)
+#define TCS_SLEW_MASK		GENMASK(4, 3)
 
 enum fan53555_vendor {
 	FAN53526_VENDOR_FAIRCHILD = 0,
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 3ceece988338..c895189375e2 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -3298,7 +3298,7 @@ fw_crash_buffer_show(struct device *cdev,
 
 	spin_lock_irqsave(&instance->crashdump_lock, flags);
 	buff_offset = instance->fw_crash_buffer_offset;
-	if (!instance->crash_dump_buf &&
+	if (!instance->crash_dump_buf ||
 		!((instance->fw_crash_state == AVAILABLE) ||
 		(instance->fw_crash_state == COPYING))) {
 		dev_err(&instance->pdev->dev,
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index dff1d692e756..b1f9c86ed211 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -314,11 +314,18 @@ static int scsi_vpd_inquiry(struct scsi_device *sdev, unsigned char *buffer,
 	if (result)
 		return -EIO;
 
-	/* Sanity check that we got the page back that we asked for */
+	/*
+	 * Sanity check that we got the page back that we asked for and that
+	 * the page size is not 0.
+	 */
 	if (buffer[1] != page)
 		return -EIO;
 
-	return get_unaligned_be16(&buffer[2]) + 4;
+	result = get_unaligned_be16(&buffer[2]);
+	if (!result)
+		return -EIO;
+
+	return result + 4;
 }
 
 static int scsi_get_vpd_size(struct scsi_device *sdev, u8 page)
diff --git a/drivers/spi/spi-rockchip-sfc.c b/drivers/spi/spi-rockchip-sfc.c
index bd87d3c92dd3..69347b6bf60c 100644
--- a/drivers/spi/spi-rockchip-sfc.c
+++ b/drivers/spi/spi-rockchip-sfc.c
@@ -632,7 +632,7 @@ static int rockchip_sfc_probe(struct platform_device *pdev)
 	if (ret) {
 		dev_err(dev, "Failed to request irq\n");
 
-		return ret;
+		goto err_irq;
 	}
 
 	ret = rockchip_sfc_init(sfc);
diff --git a/fs/btrfs/discard.c b/fs/btrfs/discard.c
index 317aeff6c1da..a6d77fe41e1a 100644
--- a/fs/btrfs/discard.c
+++ b/fs/btrfs/discard.c
@@ -56,11 +56,9 @@
 #define BTRFS_DISCARD_DELAY		(120ULL * NSEC_PER_SEC)
 #define BTRFS_DISCARD_UNUSED_DELAY	(10ULL * NSEC_PER_SEC)
 
-/* Target completion latency of discarding all discardable extents */
-#define BTRFS_DISCARD_TARGET_MSEC	(6 * 60 * 60UL * MSEC_PER_SEC)
 #define BTRFS_DISCARD_MIN_DELAY_MSEC	(1UL)
 #define BTRFS_DISCARD_MAX_DELAY_MSEC	(1000UL)
-#define BTRFS_DISCARD_MAX_IOPS		(10U)
+#define BTRFS_DISCARD_MAX_IOPS		(1000U)
 
 /* Monotonically decreasing minimum length filters after index 0 */
 static int discard_minlen[BTRFS_NR_DISCARD_LISTS] = {
@@ -577,6 +575,7 @@ void btrfs_discard_calc_delay(struct btrfs_discard_ctl *discard_ctl)
 	s32 discardable_extents;
 	s64 discardable_bytes;
 	u32 iops_limit;
+	unsigned long min_delay = BTRFS_DISCARD_MIN_DELAY_MSEC;
 	unsigned long delay;
 
 	discardable_extents = atomic_read(&discard_ctl->discardable_extents);
@@ -607,13 +606,19 @@ void btrfs_discard_calc_delay(struct btrfs_discard_ctl *discard_ctl)
 	}
 
 	iops_limit = READ_ONCE(discard_ctl->iops_limit);
-	if (iops_limit)
+
+	if (iops_limit) {
 		delay = MSEC_PER_SEC / iops_limit;
-	else
-		delay = BTRFS_DISCARD_TARGET_MSEC / discardable_extents;
+	} else {
+		/*
+		 * Unset iops_limit means go as fast as possible, so allow a
+		 * delay of 0.
+		 */
+		delay = 0;
+		min_delay = 0;
+	}
 
-	delay = clamp(delay, BTRFS_DISCARD_MIN_DELAY_MSEC,
-		      BTRFS_DISCARD_MAX_DELAY_MSEC);
+	delay = clamp(delay, min_delay, BTRFS_DISCARD_MAX_DELAY_MSEC);
 	discard_ctl->delay_ms = delay;
 
 	spin_unlock(&discard_ctl->lock);
diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
index cb40074feb3e..0329a907bdfe 100644
--- a/fs/cifs/cifs_dfs_ref.c
+++ b/fs/cifs/cifs_dfs_ref.c
@@ -171,8 +171,6 @@ static struct vfsmount *cifs_dfs_do_automount(struct path *path)
 		mnt = ERR_CAST(full_path);
 		goto out;
 	}
-
-	convert_delimiter(full_path, '/');
 	cifs_dbg(FYI, "%s: full_path: %s\n", __func__, full_path);
 
 	tmp = *cur_ctx;
diff --git a/fs/cifs/dfs.h b/fs/cifs/dfs.h
index 13f26e01f7b9..0b8cbf721fff 100644
--- a/fs/cifs/dfs.h
+++ b/fs/cifs/dfs.h
@@ -34,19 +34,33 @@ static inline int dfs_get_referral(struct cifs_mount_ctx *mnt_ctx, const char *p
 			      cifs_remap(cifs_sb), path, ref, tl);
 }
 
+/* Return DFS full path out of a dentry set for automount */
 static inline char *dfs_get_automount_devname(struct dentry *dentry, void *page)
 {
 	struct cifs_sb_info *cifs_sb = CIFS_SB(dentry->d_sb);
 	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
 	struct TCP_Server_Info *server = tcon->ses->server;
+	size_t len;
+	char *s;
 
 	if (unlikely(!server->origin_fullpath))
 		return ERR_PTR(-EREMOTE);
 
-	return __build_path_from_dentry_optional_prefix(dentry, page,
-							server->origin_fullpath,
-							strlen(server->origin_fullpath),
-							true);
+	s = dentry_path_raw(dentry, page, PATH_MAX);
+	if (IS_ERR(s))
+		return s;
+	/* for root, we want "" */
+	if (!s[1])
+		s++;
+
+	len = strlen(server->origin_fullpath);
+	if (s < (char *)page + len)
+		return ERR_PTR(-ENAMETOOLONG);
+
+	s -= len;
+	memcpy(s, server->origin_fullpath, len);
+	convert_delimiter(s, '/');
+	return s;
 }
 
 static inline void dfs_put_root_smb_sessions(struct list_head *head)
diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 6fba5a52127b..713e2d97935f 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -976,6 +976,16 @@ static void bdi_split_work_to_wbs(struct backing_dev_info *bdi,
 			continue;
 		}
 
+		/*
+		 * If wb_tryget fails, the wb has been shutdown, skip it.
+		 *
+		 * Pin @wb so that it stays on @bdi->wb_list.  This allows
+		 * continuing iteration from @wb after dropping and
+		 * regrabbing rcu read lock.
+		 */
+		if (!wb_tryget(wb))
+			continue;
+
 		/* alloc failed, execute synchronously using on-stack fallback */
 		work = &fallback_work;
 		*work = *base_work;
@@ -984,13 +994,6 @@ static void bdi_split_work_to_wbs(struct backing_dev_info *bdi,
 		work->done = &fallback_work_done;
 
 		wb_queue_work(wb, work);
-
-		/*
-		 * Pin @wb so that it stays on @bdi->wb_list.  This allows
-		 * continuing iteration from @wb after dropping and
-		 * regrabbing rcu read lock.
-		 */
-		wb_get(wb);
 		last_wb = wb;
 
 		rcu_read_unlock();
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 7aea13c33ddf..5b1574605592 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -430,6 +430,23 @@ static int nilfs_segctor_reset_segment_buffer(struct nilfs_sc_info *sci)
 	return 0;
 }
 
+/**
+ * nilfs_segctor_zeropad_segsum - zero pad the rest of the segment summary area
+ * @sci: segment constructor object
+ *
+ * nilfs_segctor_zeropad_segsum() zero-fills unallocated space at the end of
+ * the current segment summary block.
+ */
+static void nilfs_segctor_zeropad_segsum(struct nilfs_sc_info *sci)
+{
+	struct nilfs_segsum_pointer *ssp;
+
+	ssp = sci->sc_blk_cnt > 0 ? &sci->sc_binfo_ptr : &sci->sc_finfo_ptr;
+	if (ssp->offset < ssp->bh->b_size)
+		memset(ssp->bh->b_data + ssp->offset, 0,
+		       ssp->bh->b_size - ssp->offset);
+}
+
 static int nilfs_segctor_feed_segment(struct nilfs_sc_info *sci)
 {
 	sci->sc_nblk_this_inc += sci->sc_curseg->sb_sum.nblocks;
@@ -438,6 +455,7 @@ static int nilfs_segctor_feed_segment(struct nilfs_sc_info *sci)
 				* The current segment is filled up
 				* (internal code)
 				*/
+	nilfs_segctor_zeropad_segsum(sci);
 	sci->sc_curseg = NILFS_NEXT_SEGBUF(sci->sc_curseg);
 	return nilfs_segctor_reset_segment_buffer(sci);
 }
@@ -542,6 +560,7 @@ static int nilfs_segctor_add_file_block(struct nilfs_sc_info *sci,
 		goto retry;
 	}
 	if (unlikely(required)) {
+		nilfs_segctor_zeropad_segsum(sci);
 		err = nilfs_segbuf_extend_segsum(segbuf);
 		if (unlikely(err))
 			goto failed;
@@ -1531,6 +1550,7 @@ static int nilfs_segctor_collect(struct nilfs_sc_info *sci,
 		nadd = min_t(int, nadd << 1, SC_MAX_SEGDELTA);
 		sci->sc_stage = prev_stage;
 	}
+	nilfs_segctor_zeropad_segsum(sci);
 	nilfs_segctor_truncate_segments(sci, sci->sc_curseg, nilfs->ns_sufile);
 	return 0;
 
diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index cc694846617a..154c103eca75 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -1966,8 +1966,10 @@ static int userfaultfd_api(struct userfaultfd_ctx *ctx,
 	ret = -EFAULT;
 	if (copy_from_user(&uffdio_api, buf, sizeof(uffdio_api)))
 		goto out;
-	/* Ignore unsupported features (userspace built against newer kernel) */
-	features = uffdio_api.features & UFFD_API_FEATURES;
+	features = uffdio_api.features;
+	ret = -EINVAL;
+	if (uffdio_api.api != UFFD_API || (features & ~UFFD_API_FEATURES))
+		goto err_out;
 	ret = -EPERM;
 	if ((features & UFFD_FEATURE_EVENT_FORK) && !capable(CAP_SYS_PTRACE))
 		goto err_out;
diff --git a/include/acpi/actypes.h b/include/acpi/actypes.h
index 95e4f56f9754..1b4f81f1ac5d 100644
--- a/include/acpi/actypes.h
+++ b/include/acpi/actypes.h
@@ -723,8 +723,7 @@ typedef u32 acpi_event_type;
 #define ACPI_EVENT_POWER_BUTTON         2
 #define ACPI_EVENT_SLEEP_BUTTON         3
 #define ACPI_EVENT_RTC                  4
-#define ACPI_EVENT_PCIE_WAKE            5
-#define ACPI_EVENT_MAX                  5
+#define ACPI_EVENT_MAX                  4
 #define ACPI_NUM_FIXED_EVENTS           ACPI_EVENT_MAX + 1
 
 /*
diff --git a/include/linux/kmsan.h b/include/linux/kmsan.h
index e38ae3c34618..30b17647ce3c 100644
--- a/include/linux/kmsan.h
+++ b/include/linux/kmsan.h
@@ -134,11 +134,12 @@ void kmsan_kfree_large(const void *ptr);
  * @page_shift:	page_shift passed to vmap_range_noflush().
  *
  * KMSAN maps shadow and origin pages of @pages into contiguous ranges in
- * vmalloc metadata address range.
+ * vmalloc metadata address range. Returns 0 on success, callers must check
+ * for non-zero return value.
  */
-void kmsan_vmap_pages_range_noflush(unsigned long start, unsigned long end,
-				    pgprot_t prot, struct page **pages,
-				    unsigned int page_shift);
+int kmsan_vmap_pages_range_noflush(unsigned long start, unsigned long end,
+				   pgprot_t prot, struct page **pages,
+				   unsigned int page_shift);
 
 /**
  * kmsan_vunmap_kernel_range_noflush() - Notify KMSAN about a vunmap.
@@ -159,11 +160,12 @@ void kmsan_vunmap_range_noflush(unsigned long start, unsigned long end);
  * @page_shift:	page_shift argument passed to vmap_range_noflush().
  *
  * KMSAN creates new metadata pages for the physical pages mapped into the
- * virtual memory.
+ * virtual memory. Returns 0 on success, callers must check for non-zero return
+ * value.
  */
-void kmsan_ioremap_page_range(unsigned long addr, unsigned long end,
-			      phys_addr_t phys_addr, pgprot_t prot,
-			      unsigned int page_shift);
+int kmsan_ioremap_page_range(unsigned long addr, unsigned long end,
+			     phys_addr_t phys_addr, pgprot_t prot,
+			     unsigned int page_shift);
 
 /**
  * kmsan_iounmap_page_range() - Notify KMSAN about a iounmap_page_range() call.
@@ -281,12 +283,13 @@ static inline void kmsan_kfree_large(const void *ptr)
 {
 }
 
-static inline void kmsan_vmap_pages_range_noflush(unsigned long start,
-						  unsigned long end,
-						  pgprot_t prot,
-						  struct page **pages,
-						  unsigned int page_shift)
+static inline int kmsan_vmap_pages_range_noflush(unsigned long start,
+						 unsigned long end,
+						 pgprot_t prot,
+						 struct page **pages,
+						 unsigned int page_shift)
 {
+	return 0;
 }
 
 static inline void kmsan_vunmap_range_noflush(unsigned long start,
@@ -294,12 +297,12 @@ static inline void kmsan_vunmap_range_noflush(unsigned long start,
 {
 }
 
-static inline void kmsan_ioremap_page_range(unsigned long start,
-					    unsigned long end,
-					    phys_addr_t phys_addr,
-					    pgprot_t prot,
-					    unsigned int page_shift)
+static inline int kmsan_ioremap_page_range(unsigned long start,
+					   unsigned long end,
+					   phys_addr_t phys_addr, pgprot_t prot,
+					   unsigned int page_shift)
 {
+	return 0;
 }
 
 static inline void kmsan_iounmap_page_range(unsigned long start,
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 4c8492401a10..a1e7920f14eb 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -291,6 +291,7 @@ struct nf_bridge_info {
 	u8			pkt_otherhost:1;
 	u8			in_prerouting:1;
 	u8			bridged_dnat:1;
+	u8			sabotage_in_done:1;
 	__u16			frag_max_size;
 	struct net_device	*physindev;
 
@@ -4687,7 +4688,7 @@ static inline void nf_reset_ct(struct sk_buff *skb)
 
 static inline void nf_reset_trace(struct sk_buff *skb)
 {
-#if IS_ENABLED(CONFIG_NETFILTER_XT_TARGET_TRACE) || defined(CONFIG_NF_TABLES)
+#if IS_ENABLED(CONFIG_NETFILTER_XT_TARGET_TRACE) || IS_ENABLED(CONFIG_NF_TABLES)
 	skb->nf_trace = 0;
 #endif
 }
@@ -4707,7 +4708,7 @@ static inline void __nf_copy(struct sk_buff *dst, const struct sk_buff *src,
 	dst->_nfct = src->_nfct;
 	nf_conntrack_get(skb_nfct(src));
 #endif
-#if IS_ENABLED(CONFIG_NETFILTER_XT_TARGET_TRACE) || defined(CONFIG_NF_TABLES)
+#if IS_ENABLED(CONFIG_NETFILTER_XT_TARGET_TRACE) || IS_ENABLED(CONFIG_NF_TABLES)
 	if (copy)
 		dst->nf_trace = src->nf_trace;
 #endif
diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 9430128aae99..1b8e305bb54a 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1085,6 +1085,10 @@ struct nft_chain {
 };
 
 int nft_chain_validate(const struct nft_ctx *ctx, const struct nft_chain *chain);
+int nft_setelem_validate(const struct nft_ctx *ctx, struct nft_set *set,
+			 const struct nft_set_iter *iter,
+			 struct nft_set_elem *elem);
+int nft_set_catchall_validate(const struct nft_ctx *ctx, struct nft_set *set);
 
 enum nft_chain_types {
 	NFT_CHAIN_T_DEFAULT = 0,
diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
index 35ecb3118c7d..111fafe049f7 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -512,7 +512,7 @@ TRACE_EVENT(f2fs_truncate_partial_nodes,
 	TP_STRUCT__entry(
 		__field(dev_t,	dev)
 		__field(ino_t,	ino)
-		__field(nid_t,	nid[3])
+		__array(nid_t,	nid, 3)
 		__field(int,	depth)
 		__field(int,	err)
 	),
diff --git a/init/Kconfig b/init/Kconfig
index 44e90b28a30f..42d9771e04b7 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -894,18 +894,14 @@ config CC_IMPLICIT_FALLTHROUGH
 	default "-Wimplicit-fallthrough=5" if CC_IS_GCC && $(cc-option,-Wimplicit-fallthrough=5)
 	default "-Wimplicit-fallthrough" if CC_IS_CLANG && $(cc-option,-Wunreachable-code-fallthrough)
 
-# Currently, disable gcc-11,12 array-bounds globally.
-# We may want to target only particular configurations some day.
+# Currently, disable gcc-11+ array-bounds globally.
+# It's still broken in gcc-13, so no upper bound yet.
 config GCC11_NO_ARRAY_BOUNDS
 	def_bool y
 
-config GCC12_NO_ARRAY_BOUNDS
-	def_bool y
-
 config CC_NO_ARRAY_BOUNDS
 	bool
-	default y if CC_IS_GCC && GCC_VERSION >= 110000 && GCC_VERSION < 120000 && GCC11_NO_ARRAY_BOUNDS
-	default y if CC_IS_GCC && GCC_VERSION >= 120000 && GCC_VERSION < 130000 && GCC12_NO_ARRAY_BOUNDS
+	default y if CC_IS_GCC && GCC_VERSION >= 110000 && GCC11_NO_ARRAY_BOUNDS
 
 #
 # For architectures that know their GCC __int128 support is sound
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 68455fd56eea..9db6afc86733 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2905,6 +2905,21 @@ static int backtrack_insn(struct bpf_verifier_env *env, int idx,
 			}
 		} else if (opcode == BPF_EXIT) {
 			return -ENOTSUPP;
+		} else if (BPF_SRC(insn->code) == BPF_X) {
+			if (!(*reg_mask & (dreg | sreg)))
+				return 0;
+			/* dreg <cond> sreg
+			 * Both dreg and sreg need precision before
+			 * this insn. If only sreg was marked precise
+			 * before it would be equally necessary to
+			 * propagate it to dreg.
+			 */
+			*reg_mask |= (sreg | dreg);
+			 /* else dreg <cond> K
+			  * Only dreg still needs precision before
+			  * this insn, so for the K-based conditional
+			  * there is nothing new to be marked.
+			  */
 		}
 	} else if (class == BPF_LD) {
 		if (!(*reg_mask & dreg))
diff --git a/kernel/fork.c b/kernel/fork.c
index e8808ffbea61..3dea988aec54 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1177,6 +1177,7 @@ static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p,
 fail_pcpu:
 	while (i > 0)
 		percpu_counter_destroy(&mm->rss_stat[--i]);
+	destroy_context(mm);
 fail_nocontext:
 	mm_free_pgd(mm);
 fail_nopgd:
diff --git a/kernel/sys.c b/kernel/sys.c
index 88b31f096fb2..c85e1abf7b7c 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -664,6 +664,7 @@ long __sys_setresuid(uid_t ruid, uid_t euid, uid_t suid)
 	struct cred *new;
 	int retval;
 	kuid_t kruid, keuid, ksuid;
+	bool ruid_new, euid_new, suid_new;
 
 	kruid = make_kuid(ns, ruid);
 	keuid = make_kuid(ns, euid);
@@ -678,25 +679,29 @@ long __sys_setresuid(uid_t ruid, uid_t euid, uid_t suid)
 	if ((suid != (uid_t) -1) && !uid_valid(ksuid))
 		return -EINVAL;
 
+	old = current_cred();
+
+	/* check for no-op */
+	if ((ruid == (uid_t) -1 || uid_eq(kruid, old->uid)) &&
+	    (euid == (uid_t) -1 || (uid_eq(keuid, old->euid) &&
+				    uid_eq(keuid, old->fsuid))) &&
+	    (suid == (uid_t) -1 || uid_eq(ksuid, old->suid)))
+		return 0;
+
+	ruid_new = ruid != (uid_t) -1        && !uid_eq(kruid, old->uid) &&
+		   !uid_eq(kruid, old->euid) && !uid_eq(kruid, old->suid);
+	euid_new = euid != (uid_t) -1        && !uid_eq(keuid, old->uid) &&
+		   !uid_eq(keuid, old->euid) && !uid_eq(keuid, old->suid);
+	suid_new = suid != (uid_t) -1        && !uid_eq(ksuid, old->uid) &&
+		   !uid_eq(ksuid, old->euid) && !uid_eq(ksuid, old->suid);
+	if ((ruid_new || euid_new || suid_new) &&
+	    !ns_capable_setid(old->user_ns, CAP_SETUID))
+		return -EPERM;
+
 	new = prepare_creds();
 	if (!new)
 		return -ENOMEM;
 
-	old = current_cred();
-
-	retval = -EPERM;
-	if (!ns_capable_setid(old->user_ns, CAP_SETUID)) {
-		if (ruid != (uid_t) -1        && !uid_eq(kruid, old->uid) &&
-		    !uid_eq(kruid, old->euid) && !uid_eq(kruid, old->suid))
-			goto error;
-		if (euid != (uid_t) -1        && !uid_eq(keuid, old->uid) &&
-		    !uid_eq(keuid, old->euid) && !uid_eq(keuid, old->suid))
-			goto error;
-		if (suid != (uid_t) -1        && !uid_eq(ksuid, old->uid) &&
-		    !uid_eq(ksuid, old->euid) && !uid_eq(ksuid, old->suid))
-			goto error;
-	}
-
 	if (ruid != (uid_t) -1) {
 		new->uid = kruid;
 		if (!uid_eq(kruid, old->uid)) {
@@ -761,6 +766,7 @@ long __sys_setresgid(gid_t rgid, gid_t egid, gid_t sgid)
 	struct cred *new;
 	int retval;
 	kgid_t krgid, kegid, ksgid;
+	bool rgid_new, egid_new, sgid_new;
 
 	krgid = make_kgid(ns, rgid);
 	kegid = make_kgid(ns, egid);
@@ -773,23 +779,28 @@ long __sys_setresgid(gid_t rgid, gid_t egid, gid_t sgid)
 	if ((sgid != (gid_t) -1) && !gid_valid(ksgid))
 		return -EINVAL;
 
+	old = current_cred();
+
+	/* check for no-op */
+	if ((rgid == (gid_t) -1 || gid_eq(krgid, old->gid)) &&
+	    (egid == (gid_t) -1 || (gid_eq(kegid, old->egid) &&
+				    gid_eq(kegid, old->fsgid))) &&
+	    (sgid == (gid_t) -1 || gid_eq(ksgid, old->sgid)))
+		return 0;
+
+	rgid_new = rgid != (gid_t) -1        && !gid_eq(krgid, old->gid) &&
+		   !gid_eq(krgid, old->egid) && !gid_eq(krgid, old->sgid);
+	egid_new = egid != (gid_t) -1        && !gid_eq(kegid, old->gid) &&
+		   !gid_eq(kegid, old->egid) && !gid_eq(kegid, old->sgid);
+	sgid_new = sgid != (gid_t) -1        && !gid_eq(ksgid, old->gid) &&
+		   !gid_eq(ksgid, old->egid) && !gid_eq(ksgid, old->sgid);
+	if ((rgid_new || egid_new || sgid_new) &&
+	    !ns_capable_setid(old->user_ns, CAP_SETGID))
+		return -EPERM;
+
 	new = prepare_creds();
 	if (!new)
 		return -ENOMEM;
-	old = current_cred();
-
-	retval = -EPERM;
-	if (!ns_capable_setid(old->user_ns, CAP_SETGID)) {
-		if (rgid != (gid_t) -1        && !gid_eq(krgid, old->gid) &&
-		    !gid_eq(krgid, old->egid) && !gid_eq(krgid, old->sgid))
-			goto error;
-		if (egid != (gid_t) -1        && !gid_eq(kegid, old->gid) &&
-		    !gid_eq(kegid, old->egid) && !gid_eq(kegid, old->sgid))
-			goto error;
-		if (sgid != (gid_t) -1        && !gid_eq(ksgid, old->gid) &&
-		    !gid_eq(ksgid, old->egid) && !gid_eq(ksgid, old->sgid))
-			goto error;
-	}
 
 	if (rgid != (gid_t) -1)
 		new->gid = krgid;
diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 022573f49957..7091be30862d 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -1298,26 +1298,21 @@ static inline void mas_alloc_nodes(struct ma_state *mas, gfp_t gfp)
 	node = mas->alloc;
 	node->request_count = 0;
 	while (requested) {
-		max_req = MAPLE_ALLOC_SLOTS;
-		if (node->node_count) {
-			unsigned int offset = node->node_count;
-
-			slots = (void **)&node->slot[offset];
-			max_req -= offset;
-		} else {
-			slots = (void **)&node->slot;
-		}
-
+		max_req = MAPLE_ALLOC_SLOTS - node->node_count;
+		slots = (void **)&node->slot[node->node_count];
 		max_req = min(requested, max_req);
 		count = mt_alloc_bulk(gfp, max_req, slots);
 		if (!count)
 			goto nomem_bulk;
 
+		if (node->node_count == 0) {
+			node->slot[0]->node_count = 0;
+			node->slot[0]->request_count = 0;
+		}
+
 		node->node_count += count;
 		allocated += count;
 		node = node->slot[0];
-		node->node_count = 0;
-		node->request_count = 0;
 		requested -= count;
 	}
 	mas->alloc->total = allocated;
@@ -4973,7 +4968,8 @@ static inline void *mas_prev_entry(struct ma_state *mas, unsigned long min)
  * Return: True if found in a leaf, false otherwise.
  *
  */
-static bool mas_rev_awalk(struct ma_state *mas, unsigned long size)
+static bool mas_rev_awalk(struct ma_state *mas, unsigned long size,
+		unsigned long *gap_min, unsigned long *gap_max)
 {
 	enum maple_type type = mte_node_type(mas->node);
 	struct maple_node *node = mas_mn(mas);
@@ -5038,8 +5034,8 @@ static bool mas_rev_awalk(struct ma_state *mas, unsigned long size)
 
 	if (unlikely(ma_is_leaf(type))) {
 		mas->offset = offset;
-		mas->min = min;
-		mas->max = min + gap - 1;
+		*gap_min = min;
+		*gap_max = min + gap - 1;
 		return true;
 	}
 
@@ -5063,10 +5059,10 @@ static inline bool mas_anode_descend(struct ma_state *mas, unsigned long size)
 {
 	enum maple_type type = mte_node_type(mas->node);
 	unsigned long pivot, min, gap = 0;
-	unsigned char offset;
-	unsigned long *gaps;
-	unsigned long *pivots = ma_pivots(mas_mn(mas), type);
-	void __rcu **slots = ma_slots(mas_mn(mas), type);
+	unsigned char offset, data_end;
+	unsigned long *gaps, *pivots;
+	void __rcu **slots;
+	struct maple_node *node;
 	bool found = false;
 
 	if (ma_is_dense(type)) {
@@ -5074,13 +5070,15 @@ static inline bool mas_anode_descend(struct ma_state *mas, unsigned long size)
 		return true;
 	}
 
-	gaps = ma_gaps(mte_to_node(mas->node), type);
+	node = mas_mn(mas);
+	pivots = ma_pivots(node, type);
+	slots = ma_slots(node, type);
+	gaps = ma_gaps(node, type);
 	offset = mas->offset;
 	min = mas_safe_min(mas, pivots, offset);
-	for (; offset < mt_slots[type]; offset++) {
-		pivot = mas_safe_pivot(mas, pivots, offset, type);
-		if (offset && !pivot)
-			break;
+	data_end = ma_data_end(node, type, pivots, mas->max);
+	for (; offset <= data_end; offset++) {
+		pivot = mas_logical_pivot(mas, pivots, offset, type);
 
 		/* Not within lower bounds */
 		if (mas->index > pivot)
@@ -5315,6 +5313,9 @@ int mas_empty_area(struct ma_state *mas, unsigned long min,
 	unsigned long *pivots;
 	enum maple_type mt;
 
+	if (min >= max)
+		return -EINVAL;
+
 	if (mas_is_start(mas))
 		mas_start(mas);
 	else if (mas->offset >= 2)
@@ -5369,6 +5370,9 @@ int mas_empty_area_rev(struct ma_state *mas, unsigned long min,
 {
 	struct maple_enode *last = mas->node;
 
+	if (min >= max)
+		return -EINVAL;
+
 	if (mas_is_start(mas)) {
 		mas_start(mas);
 		mas->offset = mas_data_end(mas);
@@ -5388,7 +5392,7 @@ int mas_empty_area_rev(struct ma_state *mas, unsigned long min,
 	mas->index = min;
 	mas->last = max;
 
-	while (!mas_rev_awalk(mas, size)) {
+	while (!mas_rev_awalk(mas, size, &min, &max)) {
 		if (last == mas->node) {
 			if (!mas_rewind_node(mas))
 				return -EBUSY;
@@ -5403,17 +5407,9 @@ int mas_empty_area_rev(struct ma_state *mas, unsigned long min,
 	if (unlikely(mas->offset == MAPLE_NODE_SLOTS))
 		return -EBUSY;
 
-	/*
-	 * mas_rev_awalk() has set mas->min and mas->max to the gap values.  If
-	 * the maximum is outside the window we are searching, then use the last
-	 * location in the search.
-	 * mas->max and mas->min is the range of the gap.
-	 * mas->index and mas->last are currently set to the search range.
-	 */
-
 	/* Trim the upper limit to the max. */
-	if (mas->max <= mas->last)
-		mas->last = mas->max;
+	if (max <= mas->last)
+		mas->last = max;
 
 	mas->index = mas->last - size + 1;
 	return 0;
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index a53b9360b72e..30d2d0386fdb 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -507,6 +507,15 @@ static LIST_HEAD(offline_cgwbs);
 static void cleanup_offline_cgwbs_workfn(struct work_struct *work);
 static DECLARE_WORK(cleanup_offline_cgwbs_work, cleanup_offline_cgwbs_workfn);
 
+static void cgwb_free_rcu(struct rcu_head *rcu_head)
+{
+	struct bdi_writeback *wb = container_of(rcu_head,
+			struct bdi_writeback, rcu);
+
+	percpu_ref_exit(&wb->refcnt);
+	kfree(wb);
+}
+
 static void cgwb_release_workfn(struct work_struct *work)
 {
 	struct bdi_writeback *wb = container_of(work, struct bdi_writeback,
@@ -529,11 +538,10 @@ static void cgwb_release_workfn(struct work_struct *work)
 	list_del(&wb->offline_node);
 	spin_unlock_irq(&cgwb_lock);
 
-	percpu_ref_exit(&wb->refcnt);
 	wb_exit(wb);
 	bdi_put(bdi);
 	WARN_ON_ONCE(!list_empty(&wb->b_attached));
-	kfree_rcu(wb, rcu);
+	call_rcu(&wb->rcu, cgwb_free_rcu);
 }
 
 static void cgwb_release(struct percpu_ref *refcnt)
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 7624d22f9227..0c1ab7f7c102 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1845,10 +1845,10 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	if (is_swap_pmd(*pmd)) {
 		swp_entry_t entry = pmd_to_swp_entry(*pmd);
 		struct page *page = pfn_swap_entry_to_page(entry);
+		pmd_t newpmd;
 
 		VM_BUG_ON(!is_pmd_migration_entry(*pmd));
 		if (is_writable_migration_entry(entry)) {
-			pmd_t newpmd;
 			/*
 			 * A protection check is difficult so
 			 * just be safe and disable write
@@ -1862,8 +1862,16 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 				newpmd = pmd_swp_mksoft_dirty(newpmd);
 			if (pmd_swp_uffd_wp(*pmd))
 				newpmd = pmd_swp_mkuffd_wp(newpmd);
-			set_pmd_at(mm, addr, pmd, newpmd);
+		} else {
+			newpmd = *pmd;
 		}
+
+		if (uffd_wp)
+			newpmd = pmd_swp_mkuffd_wp(newpmd);
+		else if (uffd_wp_resolve)
+			newpmd = pmd_swp_clear_uffd_wp(newpmd);
+		if (!pmd_same(*pmd, newpmd))
+			set_pmd_at(mm, addr, pmd, newpmd);
 		goto unlock;
 	}
 #endif
@@ -2666,9 +2674,10 @@ int split_huge_page_to_list(struct page *page, struct list_head *list)
 	VM_BUG_ON_FOLIO(!folio_test_large(folio), folio);
 
 	is_hzp = is_huge_zero_page(&folio->page);
-	VM_WARN_ON_ONCE_FOLIO(is_hzp, folio);
-	if (is_hzp)
+	if (is_hzp) {
+		pr_warn_ratelimited("Called split_huge_page for huge zero page\n");
 		return -EBUSY;
+	}
 
 	if (folio_test_writeback(folio))
 		return -EBUSY;
@@ -3252,6 +3261,8 @@ int set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
 	pmdswp = swp_entry_to_pmd(entry);
 	if (pmd_soft_dirty(pmdval))
 		pmdswp = pmd_swp_mksoft_dirty(pmdswp);
+	if (pmd_uffd_wp(pmdval))
+		pmdswp = pmd_swp_mkuffd_wp(pmdswp);
 	set_pmd_at(mm, address, pvmw->pmd, pmdswp);
 	page_remove_rmap(page, vma, true);
 	put_page(page);
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index a26a28e3738c..7380c659e03a 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -561,6 +561,10 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
 			result = SCAN_PTE_NON_PRESENT;
 			goto out;
 		}
+		if (pte_uffd_wp(pteval)) {
+			result = SCAN_PTE_UFFD_WP;
+			goto out;
+		}
 		page = vm_normal_page(vma, address, pteval);
 		if (unlikely(!page) || unlikely(is_zone_device_page(page))) {
 			result = SCAN_PAGE_NULL;
diff --git a/mm/kmsan/hooks.c b/mm/kmsan/hooks.c
index 3807502766a3..ec0da72e65aa 100644
--- a/mm/kmsan/hooks.c
+++ b/mm/kmsan/hooks.c
@@ -148,35 +148,74 @@ void kmsan_vunmap_range_noflush(unsigned long start, unsigned long end)
  * into the virtual memory. If those physical pages already had shadow/origin,
  * those are ignored.
  */
-void kmsan_ioremap_page_range(unsigned long start, unsigned long end,
-			      phys_addr_t phys_addr, pgprot_t prot,
-			      unsigned int page_shift)
+int kmsan_ioremap_page_range(unsigned long start, unsigned long end,
+			     phys_addr_t phys_addr, pgprot_t prot,
+			     unsigned int page_shift)
 {
 	gfp_t gfp_mask = GFP_KERNEL | __GFP_ZERO;
 	struct page *shadow, *origin;
 	unsigned long off = 0;
-	int nr;
+	int nr, err = 0, clean = 0, mapped;
 
 	if (!kmsan_enabled || kmsan_in_runtime())
-		return;
+		return 0;
 
 	nr = (end - start) / PAGE_SIZE;
 	kmsan_enter_runtime();
-	for (int i = 0; i < nr; i++, off += PAGE_SIZE) {
+	for (int i = 0; i < nr; i++, off += PAGE_SIZE, clean = i) {
 		shadow = alloc_pages(gfp_mask, 1);
 		origin = alloc_pages(gfp_mask, 1);
-		__vmap_pages_range_noflush(
+		if (!shadow || !origin) {
+			err = -ENOMEM;
+			goto ret;
+		}
+		mapped = __vmap_pages_range_noflush(
 			vmalloc_shadow(start + off),
 			vmalloc_shadow(start + off + PAGE_SIZE), prot, &shadow,
 			PAGE_SHIFT);
-		__vmap_pages_range_noflush(
+		if (mapped) {
+			err = mapped;
+			goto ret;
+		}
+		shadow = NULL;
+		mapped = __vmap_pages_range_noflush(
 			vmalloc_origin(start + off),
 			vmalloc_origin(start + off + PAGE_SIZE), prot, &origin,
 			PAGE_SHIFT);
+		if (mapped) {
+			__vunmap_range_noflush(
+				vmalloc_shadow(start + off),
+				vmalloc_shadow(start + off + PAGE_SIZE));
+			err = mapped;
+			goto ret;
+		}
+		origin = NULL;
+	}
+	/* Page mapping loop finished normally, nothing to clean up. */
+	clean = 0;
+
+ret:
+	if (clean > 0) {
+		/*
+		 * Something went wrong. Clean up shadow/origin pages allocated
+		 * on the last loop iteration, then delete mappings created
+		 * during the previous iterations.
+		 */
+		if (shadow)
+			__free_pages(shadow, 1);
+		if (origin)
+			__free_pages(origin, 1);
+		__vunmap_range_noflush(
+			vmalloc_shadow(start),
+			vmalloc_shadow(start + clean * PAGE_SIZE));
+		__vunmap_range_noflush(
+			vmalloc_origin(start),
+			vmalloc_origin(start + clean * PAGE_SIZE));
 	}
 	flush_cache_vmap(vmalloc_shadow(start), vmalloc_shadow(end));
 	flush_cache_vmap(vmalloc_origin(start), vmalloc_origin(end));
 	kmsan_leave_runtime();
+	return err;
 }
 
 void kmsan_iounmap_page_range(unsigned long start, unsigned long end)
diff --git a/mm/kmsan/shadow.c b/mm/kmsan/shadow.c
index a787c04e9583..b8bb95eea5e3 100644
--- a/mm/kmsan/shadow.c
+++ b/mm/kmsan/shadow.c
@@ -216,27 +216,29 @@ void kmsan_free_page(struct page *page, unsigned int order)
 	kmsan_leave_runtime();
 }
 
-void kmsan_vmap_pages_range_noflush(unsigned long start, unsigned long end,
-				    pgprot_t prot, struct page **pages,
-				    unsigned int page_shift)
+int kmsan_vmap_pages_range_noflush(unsigned long start, unsigned long end,
+				   pgprot_t prot, struct page **pages,
+				   unsigned int page_shift)
 {
 	unsigned long shadow_start, origin_start, shadow_end, origin_end;
 	struct page **s_pages, **o_pages;
-	int nr, mapped;
+	int nr, mapped, err = 0;
 
 	if (!kmsan_enabled)
-		return;
+		return 0;
 
 	shadow_start = vmalloc_meta((void *)start, KMSAN_META_SHADOW);
 	shadow_end = vmalloc_meta((void *)end, KMSAN_META_SHADOW);
 	if (!shadow_start)
-		return;
+		return 0;
 
 	nr = (end - start) / PAGE_SIZE;
 	s_pages = kcalloc(nr, sizeof(*s_pages), GFP_KERNEL);
 	o_pages = kcalloc(nr, sizeof(*o_pages), GFP_KERNEL);
-	if (!s_pages || !o_pages)
+	if (!s_pages || !o_pages) {
+		err = -ENOMEM;
 		goto ret;
+	}
 	for (int i = 0; i < nr; i++) {
 		s_pages[i] = shadow_page_for(pages[i]);
 		o_pages[i] = origin_page_for(pages[i]);
@@ -249,10 +251,16 @@ void kmsan_vmap_pages_range_noflush(unsigned long start, unsigned long end,
 	kmsan_enter_runtime();
 	mapped = __vmap_pages_range_noflush(shadow_start, shadow_end, prot,
 					    s_pages, page_shift);
-	KMSAN_WARN_ON(mapped);
+	if (mapped) {
+		err = mapped;
+		goto ret;
+	}
 	mapped = __vmap_pages_range_noflush(origin_start, origin_end, prot,
 					    o_pages, page_shift);
-	KMSAN_WARN_ON(mapped);
+	if (mapped) {
+		err = mapped;
+		goto ret;
+	}
 	kmsan_leave_runtime();
 	flush_tlb_kernel_range(shadow_start, shadow_end);
 	flush_tlb_kernel_range(origin_start, origin_end);
@@ -262,6 +270,7 @@ void kmsan_vmap_pages_range_noflush(unsigned long start, unsigned long end,
 ret:
 	kfree(s_pages);
 	kfree(o_pages);
+	return err;
 }
 
 /* Allocate metadata for pages allocated at boot time. */
diff --git a/mm/mmap.c b/mm/mmap.c
index 1931da077b2f..a302f6a709ab 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1565,7 +1565,8 @@ static inline int accountable_mapping(struct file *file, vm_flags_t vm_flags)
  */
 static unsigned long unmapped_area(struct vm_unmapped_area_info *info)
 {
-	unsigned long length, gap;
+	unsigned long length, gap, low_limit;
+	struct vm_area_struct *tmp;
 
 	MA_STATE(mas, &current->mm->mm_mt, 0, 0);
 
@@ -1574,12 +1575,29 @@ static unsigned long unmapped_area(struct vm_unmapped_area_info *info)
 	if (length < info->length)
 		return -ENOMEM;
 
-	if (mas_empty_area(&mas, info->low_limit, info->high_limit - 1,
-				  length))
+	low_limit = info->low_limit;
+retry:
+	if (mas_empty_area(&mas, low_limit, info->high_limit - 1, length))
 		return -ENOMEM;
 
 	gap = mas.index;
 	gap += (info->align_offset - gap) & info->align_mask;
+	tmp = mas_next(&mas, ULONG_MAX);
+	if (tmp && (tmp->vm_flags & VM_GROWSDOWN)) { /* Avoid prev check if possible */
+		if (vm_start_gap(tmp) < gap + length - 1) {
+			low_limit = tmp->vm_end;
+			mas_reset(&mas);
+			goto retry;
+		}
+	} else {
+		tmp = mas_prev(&mas, 0);
+		if (tmp && vm_end_gap(tmp) > gap) {
+			low_limit = vm_end_gap(tmp);
+			mas_reset(&mas);
+			goto retry;
+		}
+	}
+
 	return gap;
 }
 
@@ -1595,7 +1613,8 @@ static unsigned long unmapped_area(struct vm_unmapped_area_info *info)
  */
 static unsigned long unmapped_area_topdown(struct vm_unmapped_area_info *info)
 {
-	unsigned long length, gap;
+	unsigned long length, gap, high_limit, gap_end;
+	struct vm_area_struct *tmp;
 
 	MA_STATE(mas, &current->mm->mm_mt, 0, 0);
 	/* Adjust search length to account for worst case alignment overhead */
@@ -1603,12 +1622,31 @@ static unsigned long unmapped_area_topdown(struct vm_unmapped_area_info *info)
 	if (length < info->length)
 		return -ENOMEM;
 
-	if (mas_empty_area_rev(&mas, info->low_limit, info->high_limit - 1,
+	high_limit = info->high_limit;
+retry:
+	if (mas_empty_area_rev(&mas, info->low_limit, high_limit - 1,
 				length))
 		return -ENOMEM;
 
 	gap = mas.last + 1 - info->length;
 	gap -= (gap - info->align_offset) & info->align_mask;
+	gap_end = mas.last;
+	tmp = mas_next(&mas, ULONG_MAX);
+	if (tmp && (tmp->vm_flags & VM_GROWSDOWN)) { /* Avoid prev check if possible */
+		if (vm_start_gap(tmp) <= gap_end) {
+			high_limit = vm_start_gap(tmp);
+			mas_reset(&mas);
+			goto retry;
+		}
+	} else {
+		tmp = mas_prev(&mas, 0);
+		if (tmp && vm_end_gap(tmp) > gap) {
+			high_limit = tmp->vm_start;
+			mas_reset(&mas);
+			goto retry;
+		}
+	}
+
 	return gap;
 }
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index dab67b14e178..9e4b33980914 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6590,7 +6590,21 @@ static void __build_all_zonelists(void *data)
 	int nid;
 	int __maybe_unused cpu;
 	pg_data_t *self = data;
+	unsigned long flags;
 
+	/*
+	 * Explicitly disable this CPU's interrupts before taking seqlock
+	 * to prevent any IRQ handler from calling into the page allocator
+	 * (e.g. GFP_ATOMIC) that could hit zonelist_iter_begin and livelock.
+	 */
+	local_irq_save(flags);
+	/*
+	 * Explicitly disable this CPU's synchronous printk() before taking
+	 * seqlock to prevent any printk() from trying to hold port->lock, for
+	 * tty_insert_flip_string_and_push_buffer() on other CPU might be
+	 * calling kmalloc(GFP_ATOMIC | __GFP_NOWARN) with port->lock held.
+	 */
+	printk_deferred_enter();
 	write_seqlock(&zonelist_update_seq);
 
 #ifdef CONFIG_NUMA
@@ -6629,6 +6643,8 @@ static void __build_all_zonelists(void *data)
 	}
 
 	write_sequnlock(&zonelist_update_seq);
+	printk_deferred_exit();
+	local_irq_restore(flags);
 }
 
 static noinline void __init
@@ -9407,6 +9423,9 @@ static bool pfn_range_valid_contig(struct zone *z, unsigned long start_pfn,
 
 		if (PageReserved(page))
 			return false;
+
+		if (PageHuge(page))
+			return false;
 	}
 	return true;
 }
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index b2249d01b3a2..f6b3c8850d15 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -324,8 +324,8 @@ int ioremap_page_range(unsigned long addr, unsigned long end,
 				 ioremap_max_page_shift);
 	flush_cache_vmap(addr, end);
 	if (!err)
-		kmsan_ioremap_page_range(addr, end, phys_addr, prot,
-					 ioremap_max_page_shift);
+		err = kmsan_ioremap_page_range(addr, end, phys_addr, prot,
+					       ioremap_max_page_shift);
 	return err;
 }
 
@@ -616,7 +616,11 @@ int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
 int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
 		pgprot_t prot, struct page **pages, unsigned int page_shift)
 {
-	kmsan_vmap_pages_range_noflush(addr, end, prot, pages, page_shift);
+	int ret = kmsan_vmap_pages_range_noflush(addr, end, prot, pages,
+						 page_shift);
+
+	if (ret)
+		return ret;
 	return __vmap_pages_range_noflush(addr, end, prot, pages, page_shift);
 }
 
diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index 9554abcfd5b4..812bd7e1750b 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -868,12 +868,17 @@ static unsigned int ip_sabotage_in(void *priv,
 {
 	struct nf_bridge_info *nf_bridge = nf_bridge_info_get(skb);
 
-	if (nf_bridge && !nf_bridge->in_prerouting &&
-	    !netif_is_l3_master(skb->dev) &&
-	    !netif_is_l3_slave(skb->dev)) {
-		nf_bridge_info_free(skb);
-		state->okfn(state->net, state->sk, skb);
-		return NF_STOLEN;
+	if (nf_bridge) {
+		if (nf_bridge->sabotage_in_done)
+			return NF_ACCEPT;
+
+		if (!nf_bridge->in_prerouting &&
+		    !netif_is_l3_master(skb->dev) &&
+		    !netif_is_l3_slave(skb->dev)) {
+			nf_bridge->sabotage_in_done = 1;
+			state->okfn(state->net, state->sk, skb);
+			return NF_STOLEN;
+		}
 	}
 
 	return NF_ACCEPT;
diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index 7eb6fd5bb917..0b5f8e1a7325 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -150,6 +150,17 @@ br_switchdev_fdb_notify(struct net_bridge *br,
 	if (test_bit(BR_FDB_LOCKED, &fdb->flags))
 		return;
 
+	/* Entries with these flags were created using ndm_state == NUD_REACHABLE,
+	 * ndm_flags == NTF_MASTER( | NTF_STICKY), ext_flags == 0 by something
+	 * equivalent to 'bridge fdb add ... master dynamic (sticky)'.
+	 * Drivers don't know how to deal with these, so don't notify them to
+	 * avoid confusing them.
+	 */
+	if (test_bit(BR_FDB_ADDED_BY_USER, &fdb->flags) &&
+	    !test_bit(BR_FDB_STATIC, &fdb->flags) &&
+	    !test_bit(BR_FDB_ADDED_BY_EXT_LEARN, &fdb->flags))
+		return;
+
 	br_switchdev_fdb_populate(br, &item, fdb, NULL);
 
 	switch (type) {
diff --git a/net/ipv6/rpl.c b/net/ipv6/rpl.c
index 488aec9e1a74..d1876f192225 100644
--- a/net/ipv6/rpl.c
+++ b/net/ipv6/rpl.c
@@ -32,7 +32,8 @@ static void *ipv6_rpl_segdata_pos(const struct ipv6_rpl_sr_hdr *hdr, int i)
 size_t ipv6_rpl_srh_size(unsigned char n, unsigned char cmpri,
 			 unsigned char cmpre)
 {
-	return (n * IPV6_PFXTAIL_LEN(cmpri)) + IPV6_PFXTAIL_LEN(cmpre);
+	return sizeof(struct ipv6_rpl_sr_hdr) + (n * IPV6_PFXTAIL_LEN(cmpri)) +
+		IPV6_PFXTAIL_LEN(cmpre);
 }
 
 void ipv6_rpl_srh_decompress(struct ipv6_rpl_sr_hdr *outhdr,
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 0fbcb8f4fd65..f20f6664b2ad 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2316,7 +2316,26 @@ static void __mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 			      unsigned int flags)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
-	bool need_push, dispose_it;
+	bool dispose_it, need_push = false;
+
+	/* If the first subflow moved to a close state before accept, e.g. due
+	 * to an incoming reset, mptcp either:
+	 * - if either the subflow or the msk are dead, destroy the context
+	 *   (the subflow socket is deleted by inet_child_forget) and the msk
+	 * - otherwise do nothing at the moment and take action at accept and/or
+	 *   listener shutdown - user-space must be able to accept() the closed
+	 *   socket.
+	 */
+	if (msk->in_accept_queue && msk->first == ssk) {
+		if (!sock_flag(sk, SOCK_DEAD) && !sock_flag(ssk, SOCK_DEAD))
+			return;
+
+		/* ensure later check in mptcp_worker() will dispose the msk */
+		sock_set_flag(sk, SOCK_DEAD);
+		lock_sock_nested(ssk, SINGLE_DEPTH_NESTING);
+		mptcp_subflow_drop_ctx(ssk);
+		goto out_release;
+	}
 
 	dispose_it = !msk->subflow || ssk != msk->subflow->sk;
 	if (dispose_it)
@@ -2352,28 +2371,22 @@ static void __mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 	if (!inet_csk(ssk)->icsk_ulp_ops) {
 		WARN_ON_ONCE(!sock_flag(ssk, SOCK_DEAD));
 		kfree_rcu(subflow, rcu);
-	} else if (msk->in_accept_queue && msk->first == ssk) {
-		/* if the first subflow moved to a close state, e.g. due to
-		 * incoming reset and we reach here before inet_child_forget()
-		 * the TCP stack could later try to close it via
-		 * inet_csk_listen_stop(), or deliver it to the user space via
-		 * accept().
-		 * We can't delete the subflow - or risk a double free - nor let
-		 * the msk survive - or will be leaked in the non accept scenario:
-		 * fallback and let TCP cope with the subflow cleanup.
-		 */
-		WARN_ON_ONCE(sock_flag(ssk, SOCK_DEAD));
-		mptcp_subflow_drop_ctx(ssk);
 	} else {
 		/* otherwise tcp will dispose of the ssk and subflow ctx */
-		if (ssk->sk_state == TCP_LISTEN)
+		if (ssk->sk_state == TCP_LISTEN) {
+			tcp_set_state(ssk, TCP_CLOSE);
+			mptcp_subflow_queue_clean(sk, ssk);
+			inet_csk_listen_stop(ssk);
 			mptcp_event_pm_listener(ssk, MPTCP_EVENT_LISTENER_CLOSED);
+		}
 
 		__tcp_close(ssk, 0);
 
 		/* close acquired an extra ref */
 		__sock_put(ssk);
 	}
+
+out_release:
 	release_sock(ssk);
 
 	sock_put(ssk);
@@ -2428,21 +2441,14 @@ static void __mptcp_close_subflow(struct sock *sk)
 		mptcp_close_ssk(sk, ssk, subflow);
 	}
 
-	/* if the MPC subflow has been closed before the msk is accepted,
-	 * msk will never be accept-ed, close it now
-	 */
-	if (!msk->first && msk->in_accept_queue) {
-		sock_set_flag(sk, SOCK_DEAD);
-		inet_sk_state_store(sk, TCP_CLOSE);
-	}
 }
 
-static bool mptcp_check_close_timeout(const struct sock *sk)
+static bool mptcp_should_close(const struct sock *sk)
 {
 	s32 delta = tcp_jiffies32 - inet_csk(sk)->icsk_mtup.probe_timestamp;
 	struct mptcp_subflow_context *subflow;
 
-	if (delta >= TCP_TIMEWAIT_LEN)
+	if (delta >= TCP_TIMEWAIT_LEN || mptcp_sk(sk)->in_accept_queue)
 		return true;
 
 	/* if all subflows are in closed status don't bother with additional
@@ -2650,7 +2656,7 @@ static void mptcp_worker(struct work_struct *work)
 	 * even if it is orphaned and in FIN_WAIT2 state
 	 */
 	if (sock_flag(sk, SOCK_DEAD)) {
-		if (mptcp_check_close_timeout(sk)) {
+		if (mptcp_should_close(sk)) {
 			inet_sk_state_store(sk, TCP_CLOSE);
 			mptcp_do_fastclose(sk);
 		}
@@ -2897,6 +2903,14 @@ static void __mptcp_destroy_sock(struct sock *sk)
 	sock_put(sk);
 }
 
+void __mptcp_unaccepted_force_close(struct sock *sk)
+{
+	sock_set_flag(sk, SOCK_DEAD);
+	inet_sk_state_store(sk, TCP_CLOSE);
+	mptcp_do_fastclose(sk);
+	__mptcp_destroy_sock(sk);
+}
+
 static __poll_t mptcp_check_readable(struct mptcp_sock *msk)
 {
 	/* Concurrent splices from sk_receive_queue into receive_queue will
@@ -3724,6 +3738,18 @@ static int mptcp_stream_accept(struct socket *sock, struct socket *newsock,
 			if (!ssk->sk_socket)
 				mptcp_sock_graft(ssk, newsock);
 		}
+
+		/* Do late cleanup for the first subflow as necessary. Also
+		 * deal with bad peers not doing a complete shutdown.
+		 */
+		if (msk->first &&
+		    unlikely(inet_sk_state_load(msk->first) == TCP_CLOSE)) {
+			__mptcp_close_ssk(newsk, msk->first,
+					  mptcp_subflow_ctx(msk->first), 0);
+			if (unlikely(list_empty(&msk->conn_list)))
+				inet_sk_state_store(newsk, TCP_CLOSE);
+		}
+
 		release_sock(newsk);
 	}
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 644cf0686f34..5918cea6a308 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -629,10 +629,12 @@ void mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 		     struct mptcp_subflow_context *subflow);
 void __mptcp_subflow_send_ack(struct sock *ssk);
 void mptcp_subflow_reset(struct sock *ssk);
+void mptcp_subflow_queue_clean(struct sock *sk, struct sock *ssk);
 void mptcp_sock_graft(struct sock *sk, struct socket *parent);
 struct socket *__mptcp_nmpc_socket(const struct mptcp_sock *msk);
 bool __mptcp_close(struct sock *sk, long timeout);
 void mptcp_cancel_work(struct sock *sk);
+void __mptcp_unaccepted_force_close(struct sock *sk);
 void mptcp_set_owner_r(struct sk_buff *skb, struct sock *sk);
 
 bool mptcp_addresses_equal(const struct mptcp_addr_info *a,
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index dbc02c2c57cc..670c88011014 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -722,9 +722,12 @@ void mptcp_subflow_drop_ctx(struct sock *ssk)
 	if (!ctx)
 		return;
 
-	subflow_ulp_fallback(ssk, ctx);
-	if (ctx->conn)
-		sock_put(ctx->conn);
+	list_del(&mptcp_subflow_ctx(ssk)->node);
+	if (inet_csk(ssk)->icsk_ulp_ops) {
+		subflow_ulp_fallback(ssk, ctx);
+		if (ctx->conn)
+			sock_put(ctx->conn);
+	}
 
 	kfree_rcu(ctx, rcu);
 }
@@ -1816,6 +1819,77 @@ static void subflow_state_change(struct sock *sk)
 	}
 }
 
+void mptcp_subflow_queue_clean(struct sock *listener_sk, struct sock *listener_ssk)
+{
+	struct request_sock_queue *queue = &inet_csk(listener_ssk)->icsk_accept_queue;
+	struct mptcp_sock *msk, *next, *head = NULL;
+	struct request_sock *req;
+	struct sock *sk;
+
+	/* build a list of all unaccepted mptcp sockets */
+	spin_lock_bh(&queue->rskq_lock);
+	for (req = queue->rskq_accept_head; req; req = req->dl_next) {
+		struct mptcp_subflow_context *subflow;
+		struct sock *ssk = req->sk;
+
+		if (!sk_is_mptcp(ssk))
+			continue;
+
+		subflow = mptcp_subflow_ctx(ssk);
+		if (!subflow || !subflow->conn)
+			continue;
+
+		/* skip if already in list */
+		sk = subflow->conn;
+		msk = mptcp_sk(sk);
+		if (msk->dl_next || msk == head)
+			continue;
+
+		sock_hold(sk);
+		msk->dl_next = head;
+		head = msk;
+	}
+	spin_unlock_bh(&queue->rskq_lock);
+	if (!head)
+		return;
+
+	/* can't acquire the msk socket lock under the subflow one,
+	 * or will cause ABBA deadlock
+	 */
+	release_sock(listener_ssk);
+
+	for (msk = head; msk; msk = next) {
+		sk = (struct sock *)msk;
+
+		lock_sock_nested(sk, SINGLE_DEPTH_NESTING);
+		next = msk->dl_next;
+		msk->dl_next = NULL;
+
+		__mptcp_unaccepted_force_close(sk);
+		release_sock(sk);
+
+		/* lockdep will report a false positive ABBA deadlock
+		 * between cancel_work_sync and the listener socket.
+		 * The involved locks belong to different sockets WRT
+		 * the existing AB chain.
+		 * Using a per socket key is problematic as key
+		 * deregistration requires process context and must be
+		 * performed at socket disposal time, in atomic
+		 * context.
+		 * Just tell lockdep to consider the listener socket
+		 * released here.
+		 */
+		mutex_release(&listener_sk->sk_lock.dep_map, _RET_IP_);
+		mptcp_cancel_work(sk);
+		mutex_acquire(&listener_sk->sk_lock.dep_map, 0, 0, _RET_IP_);
+
+		sock_put(sk);
+	}
+
+	/* we are still under the listener msk socket lock */
+	lock_sock_nested(listener_ssk, SINGLE_DEPTH_NESTING);
+}
+
 static int subflow_ulp_init(struct sock *sk)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 6023c9f72cdc..ce8a047ef830 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3439,6 +3439,64 @@ static int nft_table_validate(struct net *net, const struct nft_table *table)
 	return 0;
 }
 
+int nft_setelem_validate(const struct nft_ctx *ctx, struct nft_set *set,
+			 const struct nft_set_iter *iter,
+			 struct nft_set_elem *elem)
+{
+	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem->priv);
+	struct nft_ctx *pctx = (struct nft_ctx *)ctx;
+	const struct nft_data *data;
+	int err;
+
+	if (nft_set_ext_exists(ext, NFT_SET_EXT_FLAGS) &&
+	    *nft_set_ext_flags(ext) & NFT_SET_ELEM_INTERVAL_END)
+		return 0;
+
+	data = nft_set_ext_data(ext);
+	switch (data->verdict.code) {
+	case NFT_JUMP:
+	case NFT_GOTO:
+		pctx->level++;
+		err = nft_chain_validate(ctx, data->verdict.chain);
+		if (err < 0)
+			return err;
+		pctx->level--;
+		break;
+	default:
+		break;
+	}
+
+	return 0;
+}
+
+struct nft_set_elem_catchall {
+	struct list_head	list;
+	struct rcu_head		rcu;
+	void			*elem;
+};
+
+int nft_set_catchall_validate(const struct nft_ctx *ctx, struct nft_set *set)
+{
+	u8 genmask = nft_genmask_next(ctx->net);
+	struct nft_set_elem_catchall *catchall;
+	struct nft_set_elem elem;
+	struct nft_set_ext *ext;
+	int ret = 0;
+
+	list_for_each_entry_rcu(catchall, &set->catchall_list, list) {
+		ext = nft_set_elem_ext(set, catchall->elem);
+		if (!nft_set_elem_active(ext, genmask))
+			continue;
+
+		elem.priv = catchall->elem;
+		ret = nft_setelem_validate(ctx, set, NULL, &elem);
+		if (ret < 0)
+			return ret;
+	}
+
+	return ret;
+}
+
 static struct nft_rule *nft_rule_lookup_byid(const struct net *net,
 					     const struct nft_chain *chain,
 					     const struct nlattr *nla);
@@ -4743,12 +4801,6 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 	return err;
 }
 
-struct nft_set_elem_catchall {
-	struct list_head	list;
-	struct rcu_head		rcu;
-	void			*elem;
-};
-
 static void nft_set_catchall_destroy(const struct nft_ctx *ctx,
 				     struct nft_set *set)
 {
@@ -6036,7 +6088,8 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	if (err < 0)
 		return err;
 
-	if (!nla[NFTA_SET_ELEM_KEY] && !(flags & NFT_SET_ELEM_CATCHALL))
+	if (((flags & NFT_SET_ELEM_CATCHALL) && nla[NFTA_SET_ELEM_KEY]) ||
+	    (!(flags & NFT_SET_ELEM_CATCHALL) && !nla[NFTA_SET_ELEM_KEY]))
 		return -EINVAL;
 
 	if (flags != 0) {
@@ -7028,7 +7081,7 @@ static int nf_tables_newobj(struct sk_buff *skb, const struct nfnl_info *info,
 	}
 
 	if (nla[NFTA_OBJ_USERDATA]) {
-		obj->udata = nla_memdup(nla[NFTA_OBJ_USERDATA], GFP_KERNEL);
+		obj->udata = nla_memdup(nla[NFTA_OBJ_USERDATA], GFP_KERNEL_ACCOUNT);
 		if (obj->udata == NULL)
 			goto err_userdata;
 
diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index cae5a6724163..cecf8ab90e58 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -199,37 +199,6 @@ static int nft_lookup_dump(struct sk_buff *skb,
 	return -1;
 }
 
-static int nft_lookup_validate_setelem(const struct nft_ctx *ctx,
-				       struct nft_set *set,
-				       const struct nft_set_iter *iter,
-				       struct nft_set_elem *elem)
-{
-	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem->priv);
-	struct nft_ctx *pctx = (struct nft_ctx *)ctx;
-	const struct nft_data *data;
-	int err;
-
-	if (nft_set_ext_exists(ext, NFT_SET_EXT_FLAGS) &&
-	    *nft_set_ext_flags(ext) & NFT_SET_ELEM_INTERVAL_END)
-		return 0;
-
-	data = nft_set_ext_data(ext);
-	switch (data->verdict.code) {
-	case NFT_JUMP:
-	case NFT_GOTO:
-		pctx->level++;
-		err = nft_chain_validate(ctx, data->verdict.chain);
-		if (err < 0)
-			return err;
-		pctx->level--;
-		break;
-	default:
-		break;
-	}
-
-	return 0;
-}
-
 static int nft_lookup_validate(const struct nft_ctx *ctx,
 			       const struct nft_expr *expr,
 			       const struct nft_data **d)
@@ -245,9 +214,12 @@ static int nft_lookup_validate(const struct nft_ctx *ctx,
 	iter.skip	= 0;
 	iter.count	= 0;
 	iter.err	= 0;
-	iter.fn		= nft_lookup_validate_setelem;
+	iter.fn		= nft_setelem_validate;
 
 	priv->set->ops->walk(ctx, priv->set, &iter);
+	if (!iter.err)
+		iter.err = nft_set_catchall_validate(ctx, priv->set);
+
 	if (iter.err < 0)
 		return iter.err;
 
diff --git a/net/sched/sch_qfq.c b/net/sched/sch_qfq.c
index cf5ebe43b3b4..02098a02943e 100644
--- a/net/sched/sch_qfq.c
+++ b/net/sched/sch_qfq.c
@@ -421,15 +421,16 @@ static int qfq_change_class(struct Qdisc *sch, u32 classid, u32 parentid,
 	} else
 		weight = 1;
 
-	if (tb[TCA_QFQ_LMAX]) {
+	if (tb[TCA_QFQ_LMAX])
 		lmax = nla_get_u32(tb[TCA_QFQ_LMAX]);
-		if (lmax < QFQ_MIN_LMAX || lmax > (1UL << QFQ_MTU_SHIFT)) {
-			pr_notice("qfq: invalid max length %u\n", lmax);
-			return -EINVAL;
-		}
-	} else
+	else
 		lmax = psched_mtu(qdisc_dev(sch));
 
+	if (lmax < QFQ_MIN_LMAX || lmax > (1UL << QFQ_MTU_SHIFT)) {
+		pr_notice("qfq: invalid max length %u\n", lmax);
+		return -EINVAL;
+	}
+
 	inv_w = ONE_FP / weight;
 	weight = ONE_FP / inv_w;
 
diff --git a/rust/kernel/print.rs b/rust/kernel/print.rs
index 30103325696d..8009184bf6d7 100644
--- a/rust/kernel/print.rs
+++ b/rust/kernel/print.rs
@@ -18,7 +18,11 @@ use crate::bindings;
 
 // Called from `vsprintf` with format specifier `%pA`.
 #[no_mangle]
-unsafe fn rust_fmt_argument(buf: *mut c_char, end: *mut c_char, ptr: *const c_void) -> *mut c_char {
+unsafe extern "C" fn rust_fmt_argument(
+    buf: *mut c_char,
+    end: *mut c_char,
+    ptr: *const c_void,
+) -> *mut c_char {
     use fmt::Write;
     // SAFETY: The C contract guarantees that `buf` is valid if it's less than `end`.
     let mut w = unsafe { RawFormatter::from_ptrs(buf.cast(), end.cast()) };
diff --git a/rust/kernel/str.rs b/rust/kernel/str.rs
index b771310fa4a4..cd3d2a6cf1fc 100644
--- a/rust/kernel/str.rs
+++ b/rust/kernel/str.rs
@@ -408,7 +408,7 @@ impl RawFormatter {
     /// If `pos` is less than `end`, then the region between `pos` (inclusive) and `end`
     /// (exclusive) must be valid for writes for the lifetime of the returned [`RawFormatter`].
     pub(crate) unsafe fn from_ptrs(pos: *mut u8, end: *mut u8) -> Self {
-        // INVARIANT: The safety requierments guarantee the type invariants.
+        // INVARIANT: The safety requirements guarantee the type invariants.
         Self {
             beg: pos as _,
             pos: pos as _,
diff --git a/scripts/asn1_compiler.c b/scripts/asn1_compiler.c
index 71d4a7c87900..c3e501451b41 100644
--- a/scripts/asn1_compiler.c
+++ b/scripts/asn1_compiler.c
@@ -625,7 +625,7 @@ int main(int argc, char **argv)
 	p = strrchr(argv[1], '/');
 	p = p ? p + 1 : argv[1];
 	grammar_name = strdup(p);
-	if (!p) {
+	if (!grammar_name) {
 		perror(NULL);
 		exit(1);
 	}
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 6a6c72b5ea26..f70d6a33421d 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9468,6 +9468,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8b47, "HP", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8b5d, "HP", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8b5e, "HP", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
+	SND_PCI_QUIRK(0x103c, 0x8b65, "HP ProBook 455 15.6 inch G10 Notebook PC", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8b66, "HP", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8b7a, "HP", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8b7d, "HP", ALC236_FIXUP_HP_GPIO_LED),
diff --git a/sound/soc/fsl/fsl_asrc_dma.c b/sound/soc/fsl/fsl_asrc_dma.c
index 3b81a465814a..05a7d1588d20 100644
--- a/sound/soc/fsl/fsl_asrc_dma.c
+++ b/sound/soc/fsl/fsl_asrc_dma.c
@@ -209,14 +209,19 @@ static int fsl_asrc_dma_hw_params(struct snd_soc_component *component,
 		be_chan = soc_component_to_pcm(component_be)->chan[substream->stream];
 		tmp_chan = be_chan;
 	}
-	if (!tmp_chan)
-		tmp_chan = dma_request_slave_channel(dev_be, tx ? "tx" : "rx");
+	if (!tmp_chan) {
+		tmp_chan = dma_request_chan(dev_be, tx ? "tx" : "rx");
+		if (IS_ERR(tmp_chan)) {
+			dev_err(dev, "failed to request DMA channel for Back-End\n");
+			return -EINVAL;
+		}
+	}
 
 	/*
 	 * An EDMA DEV_TO_DEV channel is fixed and bound with DMA event of each
 	 * peripheral, unlike SDMA channel that is allocated dynamically. So no
 	 * need to configure dma_request and dma_request2, but get dma_chan of
-	 * Back-End device directly via dma_request_slave_channel.
+	 * Back-End device directly via dma_request_chan.
 	 */
 	if (!asrc->use_edma) {
 		/* Get DMA request of Back-End */
diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
index 4967f2daa6d9..96a2755b8747 100644
--- a/sound/soc/fsl/fsl_sai.c
+++ b/sound/soc/fsl/fsl_sai.c
@@ -1543,7 +1543,7 @@ static const struct fsl_sai_soc_data fsl_sai_imx8qm_data = {
 	.use_imx_pcm = true,
 	.use_edma = true,
 	.fifo_depth = 64,
-	.pins = 1,
+	.pins = 4,
 	.reg_offset = 0,
 	.mclk0_is_mclk1 = false,
 	.flags = 0,
diff --git a/sound/soc/sof/ipc4-topology.c b/sound/soc/sof/ipc4-topology.c
index 4f7adbe671f3..e0f92ab46889 100644
--- a/sound/soc/sof/ipc4-topology.c
+++ b/sound/soc/sof/ipc4-topology.c
@@ -1687,10 +1687,12 @@ static int sof_ipc4_route_setup(struct snd_sof_dev *sdev, struct snd_sof_route *
 	int ret;
 
 	if (!src_fw_module || !sink_fw_module) {
-		/* The NULL module will print as "(efault)" */
-		dev_err(sdev->dev, "source %s or sink %s widget weren't set up properly\n",
-			src_fw_module->man4_module_entry.name,
-			sink_fw_module->man4_module_entry.name);
+		dev_err(sdev->dev,
+			"cannot bind %s -> %s, no firmware module for: %s%s\n",
+			src_widget->widget->name, sink_widget->widget->name,
+			src_fw_module ? "" : " source",
+			sink_fw_module ? "" : " sink");
+
 		return -ENODEV;
 	}
 
diff --git a/sound/soc/sof/pm.c b/sound/soc/sof/pm.c
index 8722bbd7fd3d..26ffcbb6e30f 100644
--- a/sound/soc/sof/pm.c
+++ b/sound/soc/sof/pm.c
@@ -183,6 +183,7 @@ static int sof_suspend(struct device *dev, bool runtime_suspend)
 	const struct sof_ipc_tplg_ops *tplg_ops = sdev->ipc->ops->tplg;
 	pm_message_t pm_state;
 	u32 target_state = snd_sof_dsp_power_target(sdev);
+	u32 old_state = sdev->dsp_power_state.state;
 	int ret;
 
 	/* do nothing if dsp suspend callback is not set */
@@ -192,7 +193,12 @@ static int sof_suspend(struct device *dev, bool runtime_suspend)
 	if (runtime_suspend && !sof_ops(sdev)->runtime_suspend)
 		return 0;
 
-	if (tplg_ops && tplg_ops->tear_down_all_pipelines)
+	/* we need to tear down pipelines only if the DSP hardware is
+	 * active, which happens for PCI devices. if the device is
+	 * suspended, it is brought back to full power and then
+	 * suspended again
+	 */
+	if (tplg_ops && tplg_ops->tear_down_all_pipelines && (old_state == SOF_DSP_PM_D0))
 		tplg_ops->tear_down_all_pipelines(sdev, false);
 
 	if (sdev->fw_state != SOF_FW_BOOT_COMPLETE)
diff --git a/tools/testing/selftests/sigaltstack/current_stack_pointer.h b/tools/testing/selftests/sigaltstack/current_stack_pointer.h
new file mode 100644
index 000000000000..ea9bdf3a90b1
--- /dev/null
+++ b/tools/testing/selftests/sigaltstack/current_stack_pointer.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#if __alpha__
+register unsigned long sp asm("$30");
+#elif __arm__ || __aarch64__ || __csky__ || __m68k__ || __mips__ || __riscv
+register unsigned long sp asm("sp");
+#elif __i386__
+register unsigned long sp asm("esp");
+#elif __loongarch64
+register unsigned long sp asm("$sp");
+#elif __ppc__
+register unsigned long sp asm("r1");
+#elif __s390x__
+register unsigned long sp asm("%15");
+#elif __sh__
+register unsigned long sp asm("r15");
+#elif __x86_64__
+register unsigned long sp asm("rsp");
+#elif __XTENSA__
+register unsigned long sp asm("a1");
+#else
+#error "implement current_stack_pointer equivalent"
+#endif
diff --git a/tools/testing/selftests/sigaltstack/sas.c b/tools/testing/selftests/sigaltstack/sas.c
index c53b070755b6..98d37cb744fb 100644
--- a/tools/testing/selftests/sigaltstack/sas.c
+++ b/tools/testing/selftests/sigaltstack/sas.c
@@ -20,6 +20,7 @@
 #include <sys/auxv.h>
 
 #include "../kselftest.h"
+#include "current_stack_pointer.h"
 
 #ifndef SS_AUTODISARM
 #define SS_AUTODISARM  (1U << 31)
@@ -46,12 +47,6 @@ void my_usr1(int sig, siginfo_t *si, void *u)
 	stack_t stk;
 	struct stk_data *p;
 
-#if __s390x__
-	register unsigned long sp asm("%15");
-#else
-	register unsigned long sp asm("sp");
-#endif
-
 	if (sp < (unsigned long)sstack ||
 			sp >= (unsigned long)sstack + stack_size) {
 		ksft_exit_fail_msg("SP is not on sigaltstack\n");
diff --git a/tools/vm/page_owner_sort.c b/tools/vm/page_owner_sort.c
index ce860ab94162..58ebfe392402 100644
--- a/tools/vm/page_owner_sort.c
+++ b/tools/vm/page_owner_sort.c
@@ -847,7 +847,7 @@ int main(int argc, char **argv)
 			if (cull & CULL_PID || filter & FILTER_PID)
 				fprintf(fout, ", PID %d", list[i].pid);
 			if (cull & CULL_TGID || filter & FILTER_TGID)
-				fprintf(fout, ", TGID %d", list[i].pid);
+				fprintf(fout, ", TGID %d", list[i].tgid);
 			if (cull & CULL_COMM || filter & FILTER_COMM)
 				fprintf(fout, ", task_comm_name: %s", list[i].comm);
 			if (cull & CULL_ALLOCATOR) {
