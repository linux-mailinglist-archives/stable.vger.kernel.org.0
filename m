Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD33A60DFCD
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 13:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233600AbiJZLkz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 07:40:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233663AbiJZLjZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 07:39:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A02A8D8EE9;
        Wed, 26 Oct 2022 04:38:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A11FB821AB;
        Wed, 26 Oct 2022 11:38:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2710EC433C1;
        Wed, 26 Oct 2022 11:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666784302;
        bh=ipMht8KTPBMqrcYd6XGR61egqS2d+UaFf7O7Q2lbrBs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P9V7nL8tKjaXHFm7xTIdZK6IZkGoKvVjvh1b6JxwnHKsZgJU5Ban0YXCUpePkp9iP
         a6u6pmzlexxssveATD2eH5wAdpnFNboVXiUdpKLxK5Wg6xaImrrUHmMuYIaeoWiUwo
         YbKU/FLJpGhkI6CkCwT+lrql64pqHmf8Xo7phv+8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.10.150
Date:   Wed, 26 Oct 2022 13:38:06 +0200
Message-Id: <1666784285136167@kroah.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <1666784285170114@kroah.com>
References: <1666784285170114@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Documentation/ABI/testing/sysfs-bus-iio b/Documentation/ABI/testing/sysfs-bus-iio
index df42bed09f25..53f07fc41b96 100644
--- a/Documentation/ABI/testing/sysfs-bus-iio
+++ b/Documentation/ABI/testing/sysfs-bus-iio
@@ -142,7 +142,7 @@ Description:
 		Raw capacitance measurement from channel Y. Units after
 		application of scale and offset are nanofarads.
 
-What:		/sys/.../iio:deviceX/in_capacitanceY-in_capacitanceZ_raw
+What:		/sys/.../iio:deviceX/in_capacitanceY-capacitanceZ_raw
 KernelVersion:	3.2
 Contact:	linux-iio@vger.kernel.org
 Description:
diff --git a/Makefile b/Makefile
index b824bdb0457c..5c7075d3b2f6 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 10
-SUBLEVEL = 149
+SUBLEVEL = 150
 EXTRAVERSION =
 NAME = Dare mighty things
 
@@ -816,12 +816,12 @@ endif
 
 # Initialize all stack variables with a zero value.
 ifdef CONFIG_INIT_STACK_ALL_ZERO
-# Future support for zero initialization is still being debated, see
-# https://bugs.llvm.org/show_bug.cgi?id=45497. These flags are subject to being
-# renamed or dropped.
 KBUILD_CFLAGS	+= -ftrivial-auto-var-init=zero
+ifdef CONFIG_CC_HAS_AUTO_VAR_INIT_ZERO_ENABLER
+# https://github.com/llvm/llvm-project/issues/44842
 KBUILD_CFLAGS	+= -enable-trivial-auto-var-init-zero-knowing-it-will-be-removed-from-clang
 endif
+endif
 
 DEBUG_CFLAGS	:=
 
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index b587ecc6f949..985ab0b091a6 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1791,7 +1791,6 @@ config CMDLINE
 choice
 	prompt "Kernel command line type" if CMDLINE != ""
 	default CMDLINE_FROM_BOOTLOADER
-	depends on ATAGS
 
 config CMDLINE_FROM_BOOTLOADER
 	bool "Use bootloader kernel arguments if available"
diff --git a/arch/arm/boot/dts/armada-385-turris-omnia.dts b/arch/arm/boot/dts/armada-385-turris-omnia.dts
index fde4c302f08e..92e08486ec81 100644
--- a/arch/arm/boot/dts/armada-385-turris-omnia.dts
+++ b/arch/arm/boot/dts/armada-385-turris-omnia.dts
@@ -307,7 +307,7 @@ spi0cs0_pins: spi0cs0-pins {
 		marvell,function = "spi0";
 	};
 
-	spi0cs1_pins: spi0cs1-pins {
+	spi0cs2_pins: spi0cs2-pins {
 		marvell,pins = "mpp26";
 		marvell,function = "spi0";
 	};
@@ -342,7 +342,7 @@ partition@100000 {
 		};
 	};
 
-	/* MISO, MOSI, SCLK and CS1 are routed to pin header CN11 */
+	/* MISO, MOSI, SCLK and CS2 are routed to pin header CN11 */
 };
 
 &uart0 {
diff --git a/arch/arm/boot/dts/exynos4412-midas.dtsi b/arch/arm/boot/dts/exynos4412-midas.dtsi
index 06450066b178..255a13666edc 100644
--- a/arch/arm/boot/dts/exynos4412-midas.dtsi
+++ b/arch/arm/boot/dts/exynos4412-midas.dtsi
@@ -588,7 +588,7 @@ s5k6a3@10 {
 		clocks = <&camera 1>;
 		clock-names = "extclk";
 		samsung,camclk-out = <1>;
-		gpios = <&gpm1 6 GPIO_ACTIVE_HIGH>;
+		gpios = <&gpm1 6 GPIO_ACTIVE_LOW>;
 
 		port {
 			is_s5k6a3_ep: endpoint {
diff --git a/arch/arm/boot/dts/exynos4412-origen.dts b/arch/arm/boot/dts/exynos4412-origen.dts
index c2e793b69e7d..e2d76ea4404e 100644
--- a/arch/arm/boot/dts/exynos4412-origen.dts
+++ b/arch/arm/boot/dts/exynos4412-origen.dts
@@ -95,7 +95,7 @@ &exynos_usbphy {
 };
 
 &ehci {
-	samsung,vbus-gpio = <&gpx3 5 1>;
+	samsung,vbus-gpio = <&gpx3 5 GPIO_ACTIVE_HIGH>;
 	status = "okay";
 	phys = <&exynos_usbphy 2>, <&exynos_usbphy 3>;
 	phy-names = "hsic0", "hsic1";
diff --git a/arch/arm/boot/dts/imx6dl.dtsi b/arch/arm/boot/dts/imx6dl.dtsi
index fdd81fdc3f35..cd3183c36488 100644
--- a/arch/arm/boot/dts/imx6dl.dtsi
+++ b/arch/arm/boot/dts/imx6dl.dtsi
@@ -84,6 +84,9 @@ soc {
 		ocram: sram@900000 {
 			compatible = "mmio-sram";
 			reg = <0x00900000 0x20000>;
+			ranges = <0 0x00900000 0x20000>;
+			#address-cells = <1>;
+			#size-cells = <1>;
 			clocks = <&clks IMX6QDL_CLK_OCRAM>;
 		};
 
diff --git a/arch/arm/boot/dts/imx6q.dtsi b/arch/arm/boot/dts/imx6q.dtsi
index 5277e3903291..afec1677e6ba 100644
--- a/arch/arm/boot/dts/imx6q.dtsi
+++ b/arch/arm/boot/dts/imx6q.dtsi
@@ -163,6 +163,9 @@ soc {
 		ocram: sram@900000 {
 			compatible = "mmio-sram";
 			reg = <0x00900000 0x40000>;
+			ranges = <0 0x00900000 0x40000>;
+			#address-cells = <1>;
+			#size-cells = <1>;
 			clocks = <&clks IMX6QDL_CLK_OCRAM>;
 		};
 
diff --git a/arch/arm/boot/dts/imx6qp.dtsi b/arch/arm/boot/dts/imx6qp.dtsi
index b310f13a53f2..4d23c92aa8a6 100644
--- a/arch/arm/boot/dts/imx6qp.dtsi
+++ b/arch/arm/boot/dts/imx6qp.dtsi
@@ -9,12 +9,18 @@ soc {
 		ocram2: sram@940000 {
 			compatible = "mmio-sram";
 			reg = <0x00940000 0x20000>;
+			ranges = <0 0x00940000 0x20000>;
+			#address-cells = <1>;
+			#size-cells = <1>;
 			clocks = <&clks IMX6QDL_CLK_OCRAM>;
 		};
 
 		ocram3: sram@960000 {
 			compatible = "mmio-sram";
 			reg = <0x00960000 0x20000>;
+			ranges = <0 0x00960000 0x20000>;
+			#address-cells = <1>;
+			#size-cells = <1>;
 			clocks = <&clks IMX6QDL_CLK_OCRAM>;
 		};
 
diff --git a/arch/arm/boot/dts/imx6sl.dtsi b/arch/arm/boot/dts/imx6sl.dtsi
index 91a8c54d5e11..c184a6d5bc42 100644
--- a/arch/arm/boot/dts/imx6sl.dtsi
+++ b/arch/arm/boot/dts/imx6sl.dtsi
@@ -114,6 +114,9 @@ soc {
 		ocram: sram@900000 {
 			compatible = "mmio-sram";
 			reg = <0x00900000 0x20000>;
+			ranges = <0 0x00900000 0x20000>;
+			#address-cells = <1>;
+			#size-cells = <1>;
 			clocks = <&clks IMX6SL_CLK_OCRAM>;
 		};
 
diff --git a/arch/arm/boot/dts/imx6sll.dtsi b/arch/arm/boot/dts/imx6sll.dtsi
index 0b622201a1f3..bf5b262b91f9 100644
--- a/arch/arm/boot/dts/imx6sll.dtsi
+++ b/arch/arm/boot/dts/imx6sll.dtsi
@@ -115,6 +115,9 @@ soc {
 		ocram: sram@900000 {
 			compatible = "mmio-sram";
 			reg = <0x00900000 0x20000>;
+			ranges = <0 0x00900000 0x20000>;
+			#address-cells = <1>;
+			#size-cells = <1>;
 		};
 
 		intc: interrupt-controller@a01000 {
diff --git a/arch/arm/boot/dts/imx6sx.dtsi b/arch/arm/boot/dts/imx6sx.dtsi
index dfdca1804f9f..c399919943c3 100644
--- a/arch/arm/boot/dts/imx6sx.dtsi
+++ b/arch/arm/boot/dts/imx6sx.dtsi
@@ -161,12 +161,18 @@ soc {
 		ocram_s: sram@8f8000 {
 			compatible = "mmio-sram";
 			reg = <0x008f8000 0x4000>;
+			ranges = <0 0x008f8000 0x4000>;
+			#address-cells = <1>;
+			#size-cells = <1>;
 			clocks = <&clks IMX6SX_CLK_OCRAM_S>;
 		};
 
 		ocram: sram@900000 {
 			compatible = "mmio-sram";
 			reg = <0x00900000 0x20000>;
+			ranges = <0 0x00900000 0x20000>;
+			#address-cells = <1>;
+			#size-cells = <1>;
 			clocks = <&clks IMX6SX_CLK_OCRAM>;
 		};
 
diff --git a/arch/arm/boot/dts/imx7d-sdb.dts b/arch/arm/boot/dts/imx7d-sdb.dts
index 6823b9f1a2a3..6d562ebe9029 100644
--- a/arch/arm/boot/dts/imx7d-sdb.dts
+++ b/arch/arm/boot/dts/imx7d-sdb.dts
@@ -199,12 +199,7 @@ tsc2046@0 {
 		interrupt-parent = <&gpio2>;
 		interrupts = <29 0>;
 		pendown-gpio = <&gpio2 29 GPIO_ACTIVE_HIGH>;
-		ti,x-min = /bits/ 16 <0>;
-		ti,x-max = /bits/ 16 <0>;
-		ti,y-min = /bits/ 16 <0>;
-		ti,y-max = /bits/ 16 <0>;
-		ti,pressure-max = /bits/ 16 <0>;
-		ti,x-plate-ohms = /bits/ 16 <400>;
+		touchscreen-max-pressure = <255>;
 		wakeup-source;
 	};
 };
diff --git a/arch/arm/boot/dts/kirkwood-lsxl.dtsi b/arch/arm/boot/dts/kirkwood-lsxl.dtsi
index 7b151acb9984..88b70ba1c8fe 100644
--- a/arch/arm/boot/dts/kirkwood-lsxl.dtsi
+++ b/arch/arm/boot/dts/kirkwood-lsxl.dtsi
@@ -10,6 +10,11 @@ chosen {
 
 	ocp@f1000000 {
 		pinctrl: pin-controller@10000 {
+			/* Non-default UART pins */
+			pmx_uart0: pmx-uart0 {
+				marvell,pins = "mpp4", "mpp5";
+			};
+
 			pmx_power_hdd: pmx-power-hdd {
 				marvell,pins = "mpp10";
 				marvell,function = "gpo";
@@ -213,22 +218,11 @@ hdd_power: regulator@2 {
 &mdio {
 	status = "okay";
 
-	ethphy0: ethernet-phy@0 {
-		reg = <0>;
-	};
-
 	ethphy1: ethernet-phy@8 {
 		reg = <8>;
 	};
 };
 
-&eth0 {
-	status = "okay";
-	ethernet0-port@0 {
-		phy-handle = <&ethphy0>;
-	};
-};
-
 &eth1 {
 	status = "okay";
 	ethernet1-port@0 {
diff --git a/arch/arm/mm/dump.c b/arch/arm/mm/dump.c
index c18d23a5e5f1..9b9023a92d46 100644
--- a/arch/arm/mm/dump.c
+++ b/arch/arm/mm/dump.c
@@ -342,7 +342,7 @@ static void walk_pmd(struct pg_state *st, pud_t *pud, unsigned long start)
 		addr = start + i * PMD_SIZE;
 		domain = get_domain_name(pmd);
 		if (pmd_none(*pmd) || pmd_large(*pmd) || !pmd_present(*pmd))
-			note_page(st, addr, 3, pmd_val(*pmd), domain);
+			note_page(st, addr, 4, pmd_val(*pmd), domain);
 		else
 			walk_pte(st, pmd, addr, domain);
 
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index 86f213f1b44b..0d0c3bf23914 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -300,7 +300,11 @@ static struct mem_type mem_types[] __ro_after_init = {
 		.prot_pte  = L_PTE_PRESENT | L_PTE_YOUNG | L_PTE_DIRTY |
 			     L_PTE_XN | L_PTE_RDONLY,
 		.prot_l1   = PMD_TYPE_TABLE,
+#ifdef CONFIG_ARM_LPAE
+		.prot_sect = PMD_TYPE_SECT | L_PMD_SECT_RDONLY | PMD_SECT_AP2,
+#else
 		.prot_sect = PMD_TYPE_SECT,
+#endif
 		.domain    = DOMAIN_KERNEL,
 	},
 	[MT_ROM] = {
diff --git a/arch/arm64/boot/dts/freescale/imx8mq-librem5.dtsi b/arch/arm64/boot/dts/freescale/imx8mq-librem5.dtsi
index e3c6d1272198..325ea100969a 100644
--- a/arch/arm64/boot/dts/freescale/imx8mq-librem5.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mq-librem5.dtsi
@@ -899,6 +899,7 @@ bat: fuel-gauge@36 {
 		interrupts = <20 IRQ_TYPE_LEVEL_LOW>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&pinctrl_gauge>;
+		power-supplies = <&bq25895>;
 		maxim,over-heat-temp = <700>;
 		maxim,over-volt = <4500>;
 		maxim,rsns-microohm = <5000>;
diff --git a/arch/arm64/kernel/ftrace.c b/arch/arm64/kernel/ftrace.c
index 3724bab278b2..402a24f845b9 100644
--- a/arch/arm64/kernel/ftrace.c
+++ b/arch/arm64/kernel/ftrace.c
@@ -216,11 +216,26 @@ int ftrace_make_nop(struct module *mod, struct dyn_ftrace *rec,
 	unsigned long pc = rec->ip;
 	u32 old = 0, new;
 
+	new = aarch64_insn_gen_nop();
+
+	/*
+	 * When using mcount, callsites in modules may have been initalized to
+	 * call an arbitrary module PLT (which redirects to the _mcount stub)
+	 * rather than the ftrace PLT we'll use at runtime (which redirects to
+	 * the ftrace trampoline). We can ignore the old PLT when initializing
+	 * the callsite.
+	 *
+	 * Note: 'mod' is only set at module load time.
+	 */
+	if (!IS_ENABLED(CONFIG_DYNAMIC_FTRACE_WITH_REGS) &&
+	    IS_ENABLED(CONFIG_ARM64_MODULE_PLTS) && mod) {
+		return aarch64_insn_patch_text_nosync((void *)pc, new);
+	}
+
 	if (!ftrace_find_callable_addr(rec, mod, &addr))
 		return -EINVAL;
 
 	old = aarch64_insn_gen_branch_imm(pc, addr, AARCH64_INSN_BRANCH_LINK);
-	new = aarch64_insn_gen_nop();
 
 	return ftrace_modify_code(pc, old, new, true);
 }
diff --git a/arch/arm64/kernel/topology.c b/arch/arm64/kernel/topology.c
index 543c67cae02f..4358bc319306 100644
--- a/arch/arm64/kernel/topology.c
+++ b/arch/arm64/kernel/topology.c
@@ -158,7 +158,7 @@ static int validate_cpu_freq_invariance_counters(int cpu)
 	}
 
 	/* Convert maximum frequency from KHz to Hz and validate */
-	max_freq_hz = cpufreq_get_hw_max_freq(cpu) * 1000;
+	max_freq_hz = cpufreq_get_hw_max_freq(cpu) * 1000ULL;
 	if (unlikely(!max_freq_hz)) {
 		pr_debug("CPU%d: invalid maximum frequency.\n", cpu);
 		return -EINVAL;
diff --git a/arch/ia64/mm/numa.c b/arch/ia64/mm/numa.c
index f34964271101..6cd002e8163d 100644
--- a/arch/ia64/mm/numa.c
+++ b/arch/ia64/mm/numa.c
@@ -106,5 +106,6 @@ int memory_add_physaddr_to_nid(u64 addr)
 		return 0;
 	return nid;
 }
+EXPORT_SYMBOL(memory_add_physaddr_to_nid);
 #endif
 #endif
diff --git a/arch/mips/bcm47xx/prom.c b/arch/mips/bcm47xx/prom.c
index 3e2a8166377f..22509b5fab74 100644
--- a/arch/mips/bcm47xx/prom.c
+++ b/arch/mips/bcm47xx/prom.c
@@ -86,7 +86,7 @@ static __init void prom_init_mem(void)
 			pr_debug("Assume 128MB RAM\n");
 			break;
 		}
-		if (!memcmp(prom_init, prom_init + mem, 32))
+		if (!memcmp((void *)prom_init, (void *)prom_init + mem, 32))
 			break;
 	}
 	lowmem = mem;
@@ -163,7 +163,7 @@ void __init bcm47xx_prom_highmem_init(void)
 
 	off = EXTVBASE + __pa(off);
 	for (extmem = 128 << 20; extmem < 512 << 20; extmem <<= 1) {
-		if (!memcmp(prom_init, (void *)(off + extmem), 16))
+		if (!memcmp((void *)prom_init, (void *)(off + extmem), 16))
 			break;
 	}
 	extmem -= lowmem;
diff --git a/arch/mips/sgi-ip27/ip27-xtalk.c b/arch/mips/sgi-ip27/ip27-xtalk.c
index 000ede156bdc..5143d1cf8984 100644
--- a/arch/mips/sgi-ip27/ip27-xtalk.c
+++ b/arch/mips/sgi-ip27/ip27-xtalk.c
@@ -27,15 +27,18 @@ static void bridge_platform_create(nasid_t nasid, int widget, int masterwid)
 {
 	struct xtalk_bridge_platform_data *bd;
 	struct sgi_w1_platform_data *wd;
-	struct platform_device *pdev;
+	struct platform_device *pdev_wd;
+	struct platform_device *pdev_bd;
 	struct resource w1_res;
 	unsigned long offset;
 
 	offset = NODE_OFFSET(nasid);
 
 	wd = kzalloc(sizeof(*wd), GFP_KERNEL);
-	if (!wd)
-		goto no_mem;
+	if (!wd) {
+		pr_warn("xtalk:n%d/%x bridge create out of memory\n", nasid, widget);
+		return;
+	}
 
 	snprintf(wd->dev_id, sizeof(wd->dev_id), "bridge-%012lx",
 		 offset + (widget << SWIN_SIZE_BITS));
@@ -46,22 +49,35 @@ static void bridge_platform_create(nasid_t nasid, int widget, int masterwid)
 	w1_res.end = w1_res.start + 3;
 	w1_res.flags = IORESOURCE_MEM;
 
-	pdev = platform_device_alloc("sgi_w1", PLATFORM_DEVID_AUTO);
-	if (!pdev) {
-		kfree(wd);
-		goto no_mem;
+	pdev_wd = platform_device_alloc("sgi_w1", PLATFORM_DEVID_AUTO);
+	if (!pdev_wd) {
+		pr_warn("xtalk:n%d/%x bridge create out of memory\n", nasid, widget);
+		goto err_kfree_wd;
+	}
+	if (platform_device_add_resources(pdev_wd, &w1_res, 1)) {
+		pr_warn("xtalk:n%d/%x bridge failed to add platform resources.\n", nasid, widget);
+		goto err_put_pdev_wd;
+	}
+	if (platform_device_add_data(pdev_wd, wd, sizeof(*wd))) {
+		pr_warn("xtalk:n%d/%x bridge failed to add platform data.\n", nasid, widget);
+		goto err_put_pdev_wd;
+	}
+	if (platform_device_add(pdev_wd)) {
+		pr_warn("xtalk:n%d/%x bridge failed to add platform device.\n", nasid, widget);
+		goto err_put_pdev_wd;
 	}
-	platform_device_add_resources(pdev, &w1_res, 1);
-	platform_device_add_data(pdev, wd, sizeof(*wd));
-	platform_device_add(pdev);
+	/* platform_device_add_data() duplicates the data */
+	kfree(wd);
 
 	bd = kzalloc(sizeof(*bd), GFP_KERNEL);
-	if (!bd)
-		goto no_mem;
-	pdev = platform_device_alloc("xtalk-bridge", PLATFORM_DEVID_AUTO);
-	if (!pdev) {
-		kfree(bd);
-		goto no_mem;
+	if (!bd) {
+		pr_warn("xtalk:n%d/%x bridge create out of memory\n", nasid, widget);
+		goto err_unregister_pdev_wd;
+	}
+	pdev_bd = platform_device_alloc("xtalk-bridge", PLATFORM_DEVID_AUTO);
+	if (!pdev_bd) {
+		pr_warn("xtalk:n%d/%x bridge create out of memory\n", nasid, widget);
+		goto err_kfree_bd;
 	}
 
 
@@ -82,13 +98,31 @@ static void bridge_platform_create(nasid_t nasid, int widget, int masterwid)
 	bd->io.flags	= IORESOURCE_IO;
 	bd->io_offset	= offset;
 
-	platform_device_add_data(pdev, bd, sizeof(*bd));
-	platform_device_add(pdev);
+	if (platform_device_add_data(pdev_bd, bd, sizeof(*bd))) {
+		pr_warn("xtalk:n%d/%x bridge failed to add platform data.\n", nasid, widget);
+		goto err_put_pdev_bd;
+	}
+	if (platform_device_add(pdev_bd)) {
+		pr_warn("xtalk:n%d/%x bridge failed to add platform device.\n", nasid, widget);
+		goto err_put_pdev_bd;
+	}
+	/* platform_device_add_data() duplicates the data */
+	kfree(bd);
 	pr_info("xtalk:n%d/%x bridge widget\n", nasid, widget);
 	return;
 
-no_mem:
-	pr_warn("xtalk:n%d/%x bridge create out of memory\n", nasid, widget);
+err_put_pdev_bd:
+	platform_device_put(pdev_bd);
+err_kfree_bd:
+	kfree(bd);
+err_unregister_pdev_wd:
+	platform_device_unregister(pdev_wd);
+	return;
+err_put_pdev_wd:
+	platform_device_put(pdev_wd);
+err_kfree_wd:
+	kfree(wd);
+	return;
 }
 
 static int probe_one_port(nasid_t nasid, int widget, int masterwid)
diff --git a/arch/powerpc/Makefile b/arch/powerpc/Makefile
index 59175651f0b9..612254141296 100644
--- a/arch/powerpc/Makefile
+++ b/arch/powerpc/Makefile
@@ -153,7 +153,7 @@ CFLAGS-$(CONFIG_GENERIC_CPU) += -mcpu=power8
 CFLAGS-$(CONFIG_GENERIC_CPU) += $(call cc-option,-mtune=power9,-mtune=power8)
 else
 CFLAGS-$(CONFIG_GENERIC_CPU) += $(call cc-option,-mtune=power7,$(call cc-option,-mtune=power5))
-CFLAGS-$(CONFIG_GENERIC_CPU) += $(call cc-option,-mcpu=power5,-mcpu=power4)
+CFLAGS-$(CONFIG_GENERIC_CPU) += -mcpu=power4
 endif
 else ifdef CONFIG_PPC_BOOK3E_64
 CFLAGS-$(CONFIG_GENERIC_CPU) += -mcpu=powerpc64
diff --git a/arch/powerpc/boot/Makefile b/arch/powerpc/boot/Makefile
index e4b364b5da9e..8b78eba755f9 100644
--- a/arch/powerpc/boot/Makefile
+++ b/arch/powerpc/boot/Makefile
@@ -30,6 +30,7 @@ endif
 
 BOOTCFLAGS    := -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs \
 		 -fno-strict-aliasing -O2 -msoft-float -mno-altivec -mno-vsx \
+		 $(call cc-option,-mno-spe) $(call cc-option,-mspe=no) \
 		 -pipe -fomit-frame-pointer -fno-builtin -fPIC -nostdinc \
 		 $(LINUXINCLUDE)
 
diff --git a/arch/powerpc/boot/dts/fsl/e500v1_power_isa.dtsi b/arch/powerpc/boot/dts/fsl/e500v1_power_isa.dtsi
new file mode 100644
index 000000000000..7e2a90cde72e
--- /dev/null
+++ b/arch/powerpc/boot/dts/fsl/e500v1_power_isa.dtsi
@@ -0,0 +1,51 @@
+/*
+ * e500v1 Power ISA Device Tree Source (include)
+ *
+ * Copyright 2012 Freescale Semiconductor Inc.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions are met:
+ *     * Redistributions of source code must retain the above copyright
+ *       notice, this list of conditions and the following disclaimer.
+ *     * Redistributions in binary form must reproduce the above copyright
+ *       notice, this list of conditions and the following disclaimer in the
+ *       documentation and/or other materials provided with the distribution.
+ *     * Neither the name of Freescale Semiconductor nor the
+ *       names of its contributors may be used to endorse or promote products
+ *       derived from this software without specific prior written permission.
+ *
+ *
+ * ALTERNATIVELY, this software may be distributed under the terms of the
+ * GNU General Public License ("GPL") as published by the Free Software
+ * Foundation, either version 2 of that License or (at your option) any
+ * later version.
+ *
+ * THIS SOFTWARE IS PROVIDED BY Freescale Semiconductor "AS IS" AND ANY
+ * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
+ * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
+ * DISCLAIMED. IN NO EVENT SHALL Freescale Semiconductor BE LIABLE FOR ANY
+ * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
+ * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
+ * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
+ * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
+ * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+/ {
+	cpus {
+		power-isa-version = "2.03";
+		power-isa-b;		// Base
+		power-isa-e;		// Embedded
+		power-isa-atb;		// Alternate Time Base
+		power-isa-cs;		// Cache Specification
+		power-isa-e.le;		// Embedded.Little-Endian
+		power-isa-e.pm;		// Embedded.Performance Monitor
+		power-isa-ecl;		// Embedded Cache Locking
+		power-isa-mmc;		// Memory Coherence
+		power-isa-sp;		// Signal Processing Engine
+		power-isa-sp.fs;	// SPE.Embedded Float Scalar Single
+		power-isa-sp.fv;	// SPE.Embedded Float Vector
+		mmu-type = "power-embedded";
+	};
+};
diff --git a/arch/powerpc/boot/dts/fsl/mpc8540ads.dts b/arch/powerpc/boot/dts/fsl/mpc8540ads.dts
index 18a885130538..e03ae130162b 100644
--- a/arch/powerpc/boot/dts/fsl/mpc8540ads.dts
+++ b/arch/powerpc/boot/dts/fsl/mpc8540ads.dts
@@ -7,7 +7,7 @@
 
 /dts-v1/;
 
-/include/ "e500v2_power_isa.dtsi"
+/include/ "e500v1_power_isa.dtsi"
 
 / {
 	model = "MPC8540ADS";
diff --git a/arch/powerpc/boot/dts/fsl/mpc8541cds.dts b/arch/powerpc/boot/dts/fsl/mpc8541cds.dts
index ac381e7b1c60..a2a6c5cf852e 100644
--- a/arch/powerpc/boot/dts/fsl/mpc8541cds.dts
+++ b/arch/powerpc/boot/dts/fsl/mpc8541cds.dts
@@ -7,7 +7,7 @@
 
 /dts-v1/;
 
-/include/ "e500v2_power_isa.dtsi"
+/include/ "e500v1_power_isa.dtsi"
 
 / {
 	model = "MPC8541CDS";
diff --git a/arch/powerpc/boot/dts/fsl/mpc8555cds.dts b/arch/powerpc/boot/dts/fsl/mpc8555cds.dts
index 9f58db2a7e66..901b6ff06dfb 100644
--- a/arch/powerpc/boot/dts/fsl/mpc8555cds.dts
+++ b/arch/powerpc/boot/dts/fsl/mpc8555cds.dts
@@ -7,7 +7,7 @@
 
 /dts-v1/;
 
-/include/ "e500v2_power_isa.dtsi"
+/include/ "e500v1_power_isa.dtsi"
 
 / {
 	model = "MPC8555CDS";
diff --git a/arch/powerpc/boot/dts/fsl/mpc8560ads.dts b/arch/powerpc/boot/dts/fsl/mpc8560ads.dts
index a24722ccaebf..c2f9aea78b29 100644
--- a/arch/powerpc/boot/dts/fsl/mpc8560ads.dts
+++ b/arch/powerpc/boot/dts/fsl/mpc8560ads.dts
@@ -7,7 +7,7 @@
 
 /dts-v1/;
 
-/include/ "e500v2_power_isa.dtsi"
+/include/ "e500v1_power_isa.dtsi"
 
 / {
 	model = "MPC8560ADS";
diff --git a/arch/powerpc/kernel/pci_dn.c b/arch/powerpc/kernel/pci_dn.c
index e99b7c547d7e..b173ba342645 100644
--- a/arch/powerpc/kernel/pci_dn.c
+++ b/arch/powerpc/kernel/pci_dn.c
@@ -330,6 +330,7 @@ struct pci_dn *pci_add_device_node_info(struct pci_controller *hose,
 	INIT_LIST_HEAD(&pdn->list);
 	parent = of_get_parent(dn);
 	pdn->parent = parent ? PCI_DN(parent) : NULL;
+	of_node_put(parent);
 	if (pdn->parent)
 		list_add_tail(&pdn->list, &pdn->parent->child_list);
 
diff --git a/arch/powerpc/math-emu/math_efp.c b/arch/powerpc/math-emu/math_efp.c
index 0a05e51964c1..90111c9e7521 100644
--- a/arch/powerpc/math-emu/math_efp.c
+++ b/arch/powerpc/math-emu/math_efp.c
@@ -17,6 +17,7 @@
 
 #include <linux/types.h>
 #include <linux/prctl.h>
+#include <linux/module.h>
 
 #include <linux/uaccess.h>
 #include <asm/reg.h>
diff --git a/arch/powerpc/platforms/powernv/opal.c b/arch/powerpc/platforms/powernv/opal.c
index c61c3b62c8c6..1d05c168c8fb 100644
--- a/arch/powerpc/platforms/powernv/opal.c
+++ b/arch/powerpc/platforms/powernv/opal.c
@@ -892,6 +892,7 @@ static void opal_export_attrs(void)
 	kobj = kobject_create_and_add("exports", opal_kobj);
 	if (!kobj) {
 		pr_warn("kobject_create_and_add() of exports failed\n");
+		of_node_put(np);
 		return;
 	}
 
diff --git a/arch/powerpc/sysdev/fsl_msi.c b/arch/powerpc/sysdev/fsl_msi.c
index 808e7118abfc..d276c5e96445 100644
--- a/arch/powerpc/sysdev/fsl_msi.c
+++ b/arch/powerpc/sysdev/fsl_msi.c
@@ -211,8 +211,10 @@ static int fsl_setup_msi_irqs(struct pci_dev *pdev, int nvec, int type)
 			dev_err(&pdev->dev,
 				"node %pOF has an invalid fsl,msi phandle %u\n",
 				hose->dn, np->phandle);
+			of_node_put(np);
 			return -EINVAL;
 		}
+		of_node_put(np);
 	}
 
 	for_each_pci_msi_entry(entry, pdev) {
diff --git a/arch/riscv/Makefile b/arch/riscv/Makefile
index 3d3016092b31..1bb1bf1141cc 100644
--- a/arch/riscv/Makefile
+++ b/arch/riscv/Makefile
@@ -37,6 +37,7 @@ else
 endif
 
 ifeq ($(CONFIG_LD_IS_LLD),y)
+ifeq ($(shell test $(CONFIG_LLD_VERSION) -lt 150000; echo $$?),0)
 	KBUILD_CFLAGS += -mno-relax
 	KBUILD_AFLAGS += -mno-relax
 ifneq ($(LLVM_IAS),1)
@@ -44,6 +45,7 @@ ifneq ($(LLVM_IAS),1)
 	KBUILD_AFLAGS += -Wa,-mno-relax
 endif
 endif
+endif
 
 # ISA string setting
 riscv-march-$(CONFIG_ARCH_RV32I)	:= rv32ima
diff --git a/arch/riscv/include/asm/io.h b/arch/riscv/include/asm/io.h
index c025a746a148..391dd869db64 100644
--- a/arch/riscv/include/asm/io.h
+++ b/arch/riscv/include/asm/io.h
@@ -114,9 +114,9 @@ __io_reads_ins(reads, u32, l, __io_br(), __io_ar(addr))
 __io_reads_ins(ins,  u8, b, __io_pbr(), __io_par(addr))
 __io_reads_ins(ins, u16, w, __io_pbr(), __io_par(addr))
 __io_reads_ins(ins, u32, l, __io_pbr(), __io_par(addr))
-#define insb(addr, buffer, count) __insb((void __iomem *)(long)addr, buffer, count)
-#define insw(addr, buffer, count) __insw((void __iomem *)(long)addr, buffer, count)
-#define insl(addr, buffer, count) __insl((void __iomem *)(long)addr, buffer, count)
+#define insb(addr, buffer, count) __insb(PCI_IOBASE + (addr), buffer, count)
+#define insw(addr, buffer, count) __insw(PCI_IOBASE + (addr), buffer, count)
+#define insl(addr, buffer, count) __insl(PCI_IOBASE + (addr), buffer, count)
 
 __io_writes_outs(writes,  u8, b, __io_bw(), __io_aw())
 __io_writes_outs(writes, u16, w, __io_bw(), __io_aw())
@@ -128,22 +128,22 @@ __io_writes_outs(writes, u32, l, __io_bw(), __io_aw())
 __io_writes_outs(outs,  u8, b, __io_pbw(), __io_paw())
 __io_writes_outs(outs, u16, w, __io_pbw(), __io_paw())
 __io_writes_outs(outs, u32, l, __io_pbw(), __io_paw())
-#define outsb(addr, buffer, count) __outsb((void __iomem *)(long)addr, buffer, count)
-#define outsw(addr, buffer, count) __outsw((void __iomem *)(long)addr, buffer, count)
-#define outsl(addr, buffer, count) __outsl((void __iomem *)(long)addr, buffer, count)
+#define outsb(addr, buffer, count) __outsb(PCI_IOBASE + (addr), buffer, count)
+#define outsw(addr, buffer, count) __outsw(PCI_IOBASE + (addr), buffer, count)
+#define outsl(addr, buffer, count) __outsl(PCI_IOBASE + (addr), buffer, count)
 
 #ifdef CONFIG_64BIT
 __io_reads_ins(reads, u64, q, __io_br(), __io_ar(addr))
 #define readsq(addr, buffer, count) __readsq(addr, buffer, count)
 
 __io_reads_ins(ins, u64, q, __io_pbr(), __io_par(addr))
-#define insq(addr, buffer, count) __insq((void __iomem *)addr, buffer, count)
+#define insq(addr, buffer, count) __insq(PCI_IOBASE + (addr), buffer, count)
 
 __io_writes_outs(writes, u64, q, __io_bw(), __io_aw())
 #define writesq(addr, buffer, count) __writesq(addr, buffer, count)
 
 __io_writes_outs(outs, u64, q, __io_pbr(), __io_paw())
-#define outsq(addr, buffer, count) __outsq((void __iomem *)addr, buffer, count)
+#define outsq(addr, buffer, count) __outsq(PCI_IOBASE + (addr), buffer, count)
 #endif
 
 #include <asm-generic/io.h>
diff --git a/arch/riscv/kernel/sys_riscv.c b/arch/riscv/kernel/sys_riscv.c
index 8a7880b9c433..bb402685057a 100644
--- a/arch/riscv/kernel/sys_riscv.c
+++ b/arch/riscv/kernel/sys_riscv.c
@@ -18,9 +18,6 @@ static long riscv_sys_mmap(unsigned long addr, unsigned long len,
 	if (unlikely(offset & (~PAGE_MASK >> page_shift_offset)))
 		return -EINVAL;
 
-	if (unlikely((prot & PROT_WRITE) && !(prot & PROT_READ)))
-		return -EINVAL;
-
 	return ksys_mmap_pgoff(addr, len, prot, flags, fd,
 			       offset >> (PAGE_SHIFT - page_shift_offset));
 }
diff --git a/arch/riscv/mm/fault.c b/arch/riscv/mm/fault.c
index 3c8b9e433c67..8f84bbe0ac33 100644
--- a/arch/riscv/mm/fault.c
+++ b/arch/riscv/mm/fault.c
@@ -167,7 +167,8 @@ static inline bool access_error(unsigned long cause, struct vm_area_struct *vma)
 		}
 		break;
 	case EXC_LOAD_PAGE_FAULT:
-		if (!(vma->vm_flags & VM_READ)) {
+		/* Write implies read */
+		if (!(vma->vm_flags & (VM_READ | VM_WRITE))) {
 			return true;
 		}
 		break;
diff --git a/arch/sh/include/asm/sections.h b/arch/sh/include/asm/sections.h
index 8edb824049b9..0cb0ca149ac3 100644
--- a/arch/sh/include/asm/sections.h
+++ b/arch/sh/include/asm/sections.h
@@ -4,7 +4,7 @@
 
 #include <asm-generic/sections.h>
 
-extern long __machvec_start, __machvec_end;
+extern char __machvec_start[], __machvec_end[];
 extern char __uncached_start, __uncached_end;
 extern char __start_eh_frame[], __stop_eh_frame[];
 
diff --git a/arch/sh/kernel/machvec.c b/arch/sh/kernel/machvec.c
index d606679a211e..57efaf5b82ae 100644
--- a/arch/sh/kernel/machvec.c
+++ b/arch/sh/kernel/machvec.c
@@ -20,8 +20,8 @@
 #define MV_NAME_SIZE 32
 
 #define for_each_mv(mv) \
-	for ((mv) = (struct sh_machine_vector *)&__machvec_start; \
-	     (mv) && (unsigned long)(mv) < (unsigned long)&__machvec_end; \
+	for ((mv) = (struct sh_machine_vector *)__machvec_start; \
+	     (mv) && (unsigned long)(mv) < (unsigned long)__machvec_end; \
 	     (mv)++)
 
 static struct sh_machine_vector * __init get_mv_byname(const char *name)
@@ -87,8 +87,8 @@ void __init sh_mv_setup(void)
 	if (!machvec_selected) {
 		unsigned long machvec_size;
 
-		machvec_size = ((unsigned long)&__machvec_end -
-				(unsigned long)&__machvec_start);
+		machvec_size = ((unsigned long)__machvec_end -
+				(unsigned long)__machvec_start);
 
 		/*
 		 * Sanity check for machvec section alignment. Ensure
@@ -102,7 +102,7 @@ void __init sh_mv_setup(void)
 		 * vector (usually the only one) from .machvec.init.
 		 */
 		if (machvec_size >= sizeof(struct sh_machine_vector))
-			sh_mv = *(struct sh_machine_vector *)&__machvec_start;
+			sh_mv = *(struct sh_machine_vector *)__machvec_start;
 	}
 
 	pr_notice("Booting machvec: %s\n", get_system_type());
diff --git a/arch/um/kernel/um_arch.c b/arch/um/kernel/um_arch.c
index 52e2e2a3e4ae..00c6dce14bd2 100644
--- a/arch/um/kernel/um_arch.c
+++ b/arch/um/kernel/um_arch.c
@@ -77,7 +77,7 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 
 static void *c_start(struct seq_file *m, loff_t *pos)
 {
-	return *pos < NR_CPUS ? cpu_data + *pos : NULL;
+	return *pos < nr_cpu_ids ? cpu_data + *pos : NULL;
 }
 
 static void *c_next(struct seq_file *m, void *v, loff_t *pos)
diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
index 0ed20e8bba9e..ae7192b75136 100644
--- a/arch/x86/include/asm/hyperv-tlfs.h
+++ b/arch/x86/include/asm/hyperv-tlfs.h
@@ -474,7 +474,7 @@ struct hv_enlightened_vmcs {
 	u64 guest_rip;
 
 	u32 hv_clean_fields;
-	u32 hv_padding_32;
+	u32 padding32_1;
 	u32 hv_synthetic_controls;
 	struct {
 		u32 nested_flush_hypercall:1;
@@ -482,7 +482,7 @@ struct hv_enlightened_vmcs {
 		u32 reserved:30;
 	}  __packed hv_enlightenments_control;
 	u32 hv_vp_id;
-
+	u32 padding32_2;
 	u64 hv_vm_id;
 	u64 partition_assist_page;
 	u64 padding64_4[4];
diff --git a/arch/x86/include/asm/microcode.h b/arch/x86/include/asm/microcode.h
index 91a06cef50c1..f73327397b89 100644
--- a/arch/x86/include/asm/microcode.h
+++ b/arch/x86/include/asm/microcode.h
@@ -9,6 +9,7 @@
 struct ucode_patch {
 	struct list_head plist;
 	void *data;		/* Intel uses only this one */
+	unsigned int size;
 	u32 patch_id;
 	u16 equiv_cpu;
 };
diff --git a/arch/x86/kernel/cpu/feat_ctl.c b/arch/x86/kernel/cpu/feat_ctl.c
index 29a3bedabd06..d7541851288e 100644
--- a/arch/x86/kernel/cpu/feat_ctl.c
+++ b/arch/x86/kernel/cpu/feat_ctl.c
@@ -1,11 +1,11 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/tboot.h>
 
+#include <asm/cpu.h>
 #include <asm/cpufeature.h>
 #include <asm/msr-index.h>
 #include <asm/processor.h>
 #include <asm/vmx.h>
-#include "cpu.h"
 
 #undef pr_fmt
 #define pr_fmt(fmt)	"x86/cpu: " fmt
diff --git a/arch/x86/kernel/cpu/microcode/amd.c b/arch/x86/kernel/cpu/microcode/amd.c
index 3f6b137ef4e6..c87936441339 100644
--- a/arch/x86/kernel/cpu/microcode/amd.c
+++ b/arch/x86/kernel/cpu/microcode/amd.c
@@ -783,6 +783,7 @@ static int verify_and_add_patch(u8 family, u8 *fw, unsigned int leftover,
 		kfree(patch);
 		return -EINVAL;
 	}
+	patch->size = *patch_size;
 
 	mc_hdr      = (struct microcode_header_amd *)(fw + SECTION_HDR_SIZE);
 	proc_id     = mc_hdr->processor_rev_id;
@@ -864,7 +865,7 @@ load_microcode_amd(bool save, u8 family, const u8 *data, size_t size)
 		return ret;
 
 	memset(amd_ucode_patch, 0, PATCH_MAX_SIZE);
-	memcpy(amd_ucode_patch, p->data, min_t(u32, ksize(p->data), PATCH_MAX_SIZE));
+	memcpy(amd_ucode_patch, p->data, min_t(u32, p->size, PATCH_MAX_SIZE));
 
 	return ret;
 }
diff --git a/arch/x86/kernel/cpu/resctrl/pseudo_lock.c b/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
index 0daf2f1cf7a8..465dce141bfc 100644
--- a/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
+++ b/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
@@ -416,6 +416,7 @@ static int pseudo_lock_fn(void *_rdtgrp)
 	struct pseudo_lock_region *plr = rdtgrp->plr;
 	u32 rmid_p, closid_p;
 	unsigned long i;
+	u64 saved_msr;
 #ifdef CONFIG_KASAN
 	/*
 	 * The registers used for local register variables are also used
@@ -459,6 +460,7 @@ static int pseudo_lock_fn(void *_rdtgrp)
 	 * the buffer and evict pseudo-locked memory read earlier from the
 	 * cache.
 	 */
+	saved_msr = __rdmsr(MSR_MISC_FEATURE_CONTROL);
 	__wrmsr(MSR_MISC_FEATURE_CONTROL, prefetch_disable_bits, 0x0);
 	closid_p = this_cpu_read(pqr_state.cur_closid);
 	rmid_p = this_cpu_read(pqr_state.cur_rmid);
@@ -510,7 +512,7 @@ static int pseudo_lock_fn(void *_rdtgrp)
 	__wrmsr(IA32_PQR_ASSOC, rmid_p, closid_p);
 
 	/* Re-enable the hardware prefetcher(s) */
-	wrmsr(MSR_MISC_FEATURE_CONTROL, 0x0, 0x0);
+	wrmsrl(MSR_MISC_FEATURE_CONTROL, saved_msr);
 	local_irq_enable();
 
 	plr->thread_done = 1;
@@ -867,6 +869,7 @@ bool rdtgroup_pseudo_locked_in_hierarchy(struct rdt_domain *d)
 static int measure_cycles_lat_fn(void *_plr)
 {
 	struct pseudo_lock_region *plr = _plr;
+	u32 saved_low, saved_high;
 	unsigned long i;
 	u64 start, end;
 	void *mem_r;
@@ -875,6 +878,7 @@ static int measure_cycles_lat_fn(void *_plr)
 	/*
 	 * Disable hardware prefetchers.
 	 */
+	rdmsr(MSR_MISC_FEATURE_CONTROL, saved_low, saved_high);
 	wrmsr(MSR_MISC_FEATURE_CONTROL, prefetch_disable_bits, 0x0);
 	mem_r = READ_ONCE(plr->kmem);
 	/*
@@ -891,7 +895,7 @@ static int measure_cycles_lat_fn(void *_plr)
 		end = rdtsc_ordered();
 		trace_pseudo_lock_mem_latency((u32)(end - start));
 	}
-	wrmsr(MSR_MISC_FEATURE_CONTROL, 0x0, 0x0);
+	wrmsr(MSR_MISC_FEATURE_CONTROL, saved_low, saved_high);
 	local_irq_enable();
 	plr->thread_done = 1;
 	wake_up_interruptible(&plr->lock_thread_wq);
@@ -936,6 +940,7 @@ static int measure_residency_fn(struct perf_event_attr *miss_attr,
 	u64 hits_before = 0, hits_after = 0, miss_before = 0, miss_after = 0;
 	struct perf_event *miss_event, *hit_event;
 	int hit_pmcnum, miss_pmcnum;
+	u32 saved_low, saved_high;
 	unsigned int line_size;
 	unsigned int size;
 	unsigned long i;
@@ -969,6 +974,7 @@ static int measure_residency_fn(struct perf_event_attr *miss_attr,
 	/*
 	 * Disable hardware prefetchers.
 	 */
+	rdmsr(MSR_MISC_FEATURE_CONTROL, saved_low, saved_high);
 	wrmsr(MSR_MISC_FEATURE_CONTROL, prefetch_disable_bits, 0x0);
 
 	/* Initialize rest of local variables */
@@ -1027,7 +1033,7 @@ static int measure_residency_fn(struct perf_event_attr *miss_attr,
 	 */
 	rmb();
 	/* Re-enable hardware prefetchers */
-	wrmsr(MSR_MISC_FEATURE_CONTROL, 0x0, 0x0);
+	wrmsr(MSR_MISC_FEATURE_CONTROL, saved_low, saved_high);
 	local_irq_enable();
 out_hit:
 	perf_event_release_kernel(hit_event);
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 2aa41d682bb2..52a881d24070 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -2039,7 +2039,7 @@ static int em_pop_sreg(struct x86_emulate_ctxt *ctxt)
 	if (rc != X86EMUL_CONTINUE)
 		return rc;
 
-	if (ctxt->modrm_reg == VCPU_SREG_SS)
+	if (seg == VCPU_SREG_SS)
 		ctxt->interruptibility = KVM_X86_SHADOW_INT_MOV_SS;
 	if (ctxt->op_bytes > 2)
 		rsp_increment(ctxt, ctxt->op_bytes - 2);
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 6c4277e99d58..7f15e2b2a0d6 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3776,7 +3776,16 @@ static void nested_vmx_inject_exception_vmexit(struct kvm_vcpu *vcpu,
 	u32 intr_info = nr | INTR_INFO_VALID_MASK;
 
 	if (vcpu->arch.exception.has_error_code) {
-		vmcs12->vm_exit_intr_error_code = vcpu->arch.exception.error_code;
+		/*
+		 * Intel CPUs do not generate error codes with bits 31:16 set,
+		 * and more importantly VMX disallows setting bits 31:16 in the
+		 * injected error code for VM-Entry.  Drop the bits to mimic
+		 * hardware and avoid inducing failure on nested VM-Entry if L1
+		 * chooses to inject the exception back to L2.  AMD CPUs _do_
+		 * generate "full" 32-bit error codes, so KVM allows userspace
+		 * to inject exception error codes with bits 31:16 set.
+		 */
+		vmcs12->vm_exit_intr_error_code = (u16)vcpu->arch.exception.error_code;
 		intr_info |= INTR_INFO_DELIVER_CODE_MASK;
 	}
 
@@ -4183,14 +4192,6 @@ static void prepare_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 			nested_vmx_abort(vcpu,
 					 VMX_ABORT_SAVE_GUEST_MSR_FAIL);
 	}
-
-	/*
-	 * Drop what we picked up for L2 via vmx_complete_interrupts. It is
-	 * preserved above and would only end up incorrectly in L1.
-	 */
-	vcpu->arch.nmi_injected = false;
-	kvm_clear_exception_queue(vcpu);
-	kvm_clear_interrupt_queue(vcpu);
 }
 
 /*
@@ -4530,6 +4531,17 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 		WARN_ON_ONCE(nested_early_check);
 	}
 
+	/*
+	 * Drop events/exceptions that were queued for re-injection to L2
+	 * (picked up via vmx_complete_interrupts()), as well as exceptions
+	 * that were pending for L2.  Note, this must NOT be hoisted above
+	 * prepare_vmcs12(), events/exceptions queued for re-injection need to
+	 * be captured in vmcs12 (see vmcs12_save_pending_event()).
+	 */
+	vcpu->arch.nmi_injected = false;
+	kvm_clear_exception_queue(vcpu);
+	kvm_clear_interrupt_queue(vcpu);
+
 	vmx_switch_vmcs(vcpu, &vmx->vmcs01);
 
 	/* Update any VMCS fields that might have changed while L2 ran */
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b33d0f283d4f..af6742d11ca1 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1737,7 +1737,17 @@ static void vmx_queue_exception(struct kvm_vcpu *vcpu)
 	kvm_deliver_exception_payload(vcpu);
 
 	if (has_error_code) {
-		vmcs_write32(VM_ENTRY_EXCEPTION_ERROR_CODE, error_code);
+		/*
+		 * Despite the error code being architecturally defined as 32
+		 * bits, and the VMCS field being 32 bits, Intel CPUs and thus
+		 * VMX don't actually supporting setting bits 31:16.  Hardware
+		 * will (should) never provide a bogus error code, but AMD CPUs
+		 * do generate error codes with bits 31:16 set, and so KVM's
+		 * ABI lets userspace shove in arbitrary 32-bit values.  Drop
+		 * the upper bits to avoid VM-Fail, losing information that
+		 * does't really exist is preferable to killing the VM.
+		 */
+		vmcs_write32(VM_ENTRY_EXCEPTION_ERROR_CODE, (u16)error_code);
 		intr_info |= INTR_INFO_DELIVER_CODE_MASK;
 	}
 
diff --git a/arch/x86/xen/enlighten_pv.c b/arch/x86/xen/enlighten_pv.c
index 804c65d2b95f..815030b7f6fa 100644
--- a/arch/x86/xen/enlighten_pv.c
+++ b/arch/x86/xen/enlighten_pv.c
@@ -768,6 +768,7 @@ static void xen_load_idt(const struct desc_ptr *desc)
 {
 	static DEFINE_SPINLOCK(lock);
 	static struct trap_info traps[257];
+	static const struct trap_info zero = { };
 	unsigned out;
 
 	trace_xen_cpu_load_idt(desc);
@@ -777,7 +778,7 @@ static void xen_load_idt(const struct desc_ptr *desc)
 	memcpy(this_cpu_ptr(&idt_desc), desc, sizeof(idt_desc));
 
 	out = xen_convert_trap_info(desc, traps, false);
-	memset(&traps[out], 0, sizeof(traps[0]));
+	traps[out] = zero;
 
 	xen_mc_flush();
 	if (HYPERVISOR_set_trap_table(traps))
diff --git a/block/blk-mq.c b/block/blk-mq.c
index cfc039fabf8c..e37ba792902a 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -105,7 +105,8 @@ static bool blk_mq_check_inflight(struct blk_mq_hw_ctx *hctx,
 {
 	struct mq_inflight *mi = priv;
 
-	if (rq->part == mi->part && blk_mq_rq_state(rq) == MQ_RQ_IN_FLIGHT)
+	if ((!mi->part->partno || rq->part == mi->part) &&
+	    blk_mq_rq_state(rq) == MQ_RQ_IN_FLIGHT)
 		mi->inflight[rq_data_dir(rq)]++;
 
 	return true;
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index c53a254171a2..c526fdd0a7b9 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -944,7 +944,7 @@ static bool tg_with_in_bps_limit(struct throtl_grp *tg, struct bio *bio,
 				 u64 bps_limit, unsigned long *wait)
 {
 	bool rw = bio_data_dir(bio);
-	u64 bytes_allowed, extra_bytes, tmp;
+	u64 bytes_allowed, extra_bytes;
 	unsigned long jiffy_elapsed, jiffy_wait, jiffy_elapsed_rnd;
 	unsigned int bio_size = throtl_bio_data_size(bio);
 
@@ -961,10 +961,8 @@ static bool tg_with_in_bps_limit(struct throtl_grp *tg, struct bio *bio,
 		jiffy_elapsed_rnd = tg->td->throtl_slice;
 
 	jiffy_elapsed_rnd = roundup(jiffy_elapsed_rnd, tg->td->throtl_slice);
-
-	tmp = bps_limit * jiffy_elapsed_rnd;
-	do_div(tmp, HZ);
-	bytes_allowed = tmp;
+	bytes_allowed = mul_u64_u64_div_u64(bps_limit, (u64)jiffy_elapsed_rnd,
+					    (u64)HZ);
 
 	if (tg->bytes_disp[rw] + bio_size <= bytes_allowed) {
 		if (wait)
diff --git a/crypto/akcipher.c b/crypto/akcipher.c
index f866085c8a4a..ab975a420e1e 100644
--- a/crypto/akcipher.c
+++ b/crypto/akcipher.c
@@ -120,6 +120,12 @@ static int akcipher_default_op(struct akcipher_request *req)
 	return -ENOSYS;
 }
 
+static int akcipher_default_set_key(struct crypto_akcipher *tfm,
+				     const void *key, unsigned int keylen)
+{
+	return -ENOSYS;
+}
+
 int crypto_register_akcipher(struct akcipher_alg *alg)
 {
 	struct crypto_alg *base = &alg->base;
@@ -132,6 +138,8 @@ int crypto_register_akcipher(struct akcipher_alg *alg)
 		alg->encrypt = akcipher_default_op;
 	if (!alg->decrypt)
 		alg->decrypt = akcipher_default_op;
+	if (!alg->set_priv_key)
+		alg->set_priv_key = akcipher_default_set_key;
 
 	akcipher_prepare_alg(alg);
 	return crypto_register_alg(base);
diff --git a/drivers/acpi/acpi_video.c b/drivers/acpi/acpi_video.c
index eb04b2f828ee..cf6c9ffe04a2 100644
--- a/drivers/acpi/acpi_video.c
+++ b/drivers/acpi/acpi_video.c
@@ -498,6 +498,22 @@ static const struct dmi_system_id video_dmi_table[] = {
 		DMI_MATCH(DMI_PRODUCT_NAME, "SATELLITE R830"),
 		},
 	},
+	{
+	 .callback = video_disable_backlight_sysfs_if,
+	 .ident = "Toshiba Satellite Z830",
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "SATELLITE Z830"),
+		},
+	},
+	{
+	 .callback = video_disable_backlight_sysfs_if,
+	 .ident = "Toshiba Portege Z830",
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "PORTEGE Z830"),
+		},
+	},
 	/*
 	 * Some machine's _DOD IDs don't have bit 31(Device ID Scheme) set
 	 * but the IDs actually follow the Device ID Scheme.
diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 0c8330ed1ffd..5206fd3b7867 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -985,7 +985,7 @@ static void ghes_proc_in_irq(struct irq_work *irq_work)
 				ghes_estatus_cache_add(generic, estatus);
 		}
 
-		if (task_work_pending && current->mm != &init_mm) {
+		if (task_work_pending && current->mm) {
 			estatus_node->task_work.func = ghes_kick_task_work;
 			estatus_node->task_work_cpu = smp_processor_id();
 			ret = task_work_add(current, &estatus_node->task_work,
diff --git a/drivers/ata/libahci_platform.c b/drivers/ata/libahci_platform.c
index 0910441321f7..64d6da0a5303 100644
--- a/drivers/ata/libahci_platform.c
+++ b/drivers/ata/libahci_platform.c
@@ -451,14 +451,24 @@ struct ahci_host_priv *ahci_platform_get_resources(struct platform_device *pdev,
 		}
 	}
 
-	hpriv->nports = child_nodes = of_get_child_count(dev->of_node);
+	/*
+	 * Too many sub-nodes most likely means having something wrong with
+	 * the firmware.
+	 */
+	child_nodes = of_get_child_count(dev->of_node);
+	if (child_nodes > AHCI_MAX_PORTS) {
+		rc = -EINVAL;
+		goto err_out;
+	}
 
 	/*
 	 * If no sub-node was found, we still need to set nports to
 	 * one in order to be able to use the
 	 * ahci_platform_[en|dis]able_[phys|regulators] functions.
 	 */
-	if (!child_nodes)
+	if (child_nodes)
+		hpriv->nports = child_nodes;
+	else
 		hpriv->nports = 1;
 
 	hpriv->phys = devm_kcalloc(dev, hpriv->nports, sizeof(*hpriv->phys), GFP_KERNEL);
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 4a6b82d434ee..b0d3dadeb964 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -1342,10 +1342,12 @@ static int nbd_start_device_ioctl(struct nbd_device *nbd, struct block_device *b
 	mutex_unlock(&nbd->config_lock);
 	ret = wait_event_interruptible(config->recv_wq,
 					 atomic_read(&config->recv_threads) == 0);
-	if (ret)
+	if (ret) {
 		sock_shutdown(nbd);
-	flush_workqueue(nbd->recv_workq);
+		nbd_clear_que(nbd);
+	}
 
+	flush_workqueue(nbd->recv_workq);
 	mutex_lock(&nbd->config_lock);
 	nbd_bdev_reset(bdev);
 	/* user requested, ignore socket errors */
diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index a699e6166aef..6efd981979bd 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -2816,6 +2816,7 @@ enum {
 enum {
 	BTMTK_WMT_INVALID,
 	BTMTK_WMT_PATCH_UNDONE,
+	BTMTK_WMT_PATCH_PROGRESS,
 	BTMTK_WMT_PATCH_DONE,
 	BTMTK_WMT_ON_UNDONE,
 	BTMTK_WMT_ON_DONE,
@@ -2831,7 +2832,7 @@ struct btmtk_wmt_hdr {
 
 struct btmtk_hci_wmt_cmd {
 	struct btmtk_wmt_hdr hdr;
-	u8 data[256];
+	u8 data[];
 } __packed;
 
 struct btmtk_hci_wmt_evt {
@@ -2934,7 +2935,7 @@ static void btusb_mtk_wmt_recv(struct urb *urb)
 	 * to generate the event. Otherwise, the WMT event cannot return from
 	 * the device successfully.
 	 */
-	udelay(100);
+	udelay(500);
 
 	usb_anchor_urb(urb, &data->ctrl_anchor);
 	err = usb_submit_urb(urb, GFP_ATOMIC);
@@ -3010,7 +3011,7 @@ static int btusb_mtk_hci_wmt_sync(struct hci_dev *hdev,
 	struct btmtk_hci_wmt_evt_funcc *wmt_evt_funcc;
 	u32 hlen, status = BTMTK_WMT_INVALID;
 	struct btmtk_hci_wmt_evt *wmt_evt;
-	struct btmtk_hci_wmt_cmd wc;
+	struct btmtk_hci_wmt_cmd *wc;
 	struct btmtk_wmt_hdr *hdr;
 	int err;
 
@@ -3019,24 +3020,42 @@ static int btusb_mtk_hci_wmt_sync(struct hci_dev *hdev,
 	if (hlen > 255)
 		return -EINVAL;
 
-	hdr = (struct btmtk_wmt_hdr *)&wc;
+	wc = kzalloc(hlen, GFP_KERNEL);
+	if (!wc)
+		return -ENOMEM;
+
+	hdr = &wc->hdr;
 	hdr->dir = 1;
 	hdr->op = wmt_params->op;
 	hdr->dlen = cpu_to_le16(wmt_params->dlen + 1);
 	hdr->flag = wmt_params->flag;
-	memcpy(wc.data, wmt_params->data, wmt_params->dlen);
+	memcpy(wc->data, wmt_params->data, wmt_params->dlen);
 
 	set_bit(BTUSB_TX_WAIT_VND_EVT, &data->flags);
 
-	err = __hci_cmd_send(hdev, 0xfc6f, hlen, &wc);
+	/* WMT cmd/event doesn't follow up the generic HCI cmd/event handling,
+	 * it needs constantly polling control pipe until the host received the
+	 * WMT event, thus, we should require to specifically acquire PM counter
+	 * on the USB to prevent the interface from entering auto suspended
+	 * while WMT cmd/event in progress.
+	 */
+	err = usb_autopm_get_interface(data->intf);
+	if (err < 0)
+		goto err_free_wc;
+
+	err = __hci_cmd_send(hdev, 0xfc6f, hlen, wc);
 
 	if (err < 0) {
 		clear_bit(BTUSB_TX_WAIT_VND_EVT, &data->flags);
-		return err;
+		usb_autopm_put_interface(data->intf);
+		goto err_free_wc;
 	}
 
 	/* Submit control IN URB on demand to process the WMT event */
 	err = btusb_mtk_submit_wmt_recv_urb(hdev);
+
+	usb_autopm_put_interface(data->intf);
+
 	if (err < 0)
 		return err;
 
@@ -3054,13 +3073,14 @@ static int btusb_mtk_hci_wmt_sync(struct hci_dev *hdev,
 	if (err == -EINTR) {
 		bt_dev_err(hdev, "Execution of wmt command interrupted");
 		clear_bit(BTUSB_TX_WAIT_VND_EVT, &data->flags);
-		return err;
+		goto err_free_wc;
 	}
 
 	if (err) {
 		bt_dev_err(hdev, "Execution of wmt command timed out");
 		clear_bit(BTUSB_TX_WAIT_VND_EVT, &data->flags);
-		return -ETIMEDOUT;
+		err = -ETIMEDOUT;
+		goto err_free_wc;
 	}
 
 	/* Parse and handle the return WMT event */
@@ -3096,7 +3116,8 @@ static int btusb_mtk_hci_wmt_sync(struct hci_dev *hdev,
 err_free_skb:
 	kfree_skb(data->evt_skb);
 	data->evt_skb = NULL;
-
+err_free_wc:
+	kfree(wc);
 	return err;
 }
 
@@ -3238,9 +3259,9 @@ static int btusb_mtk_reg_read(struct btusb_data *data, u32 reg, u32 *val)
 	return err;
 }
 
-static int btusb_mtk_id_get(struct btusb_data *data, u32 *id)
+static int btusb_mtk_id_get(struct btusb_data *data, u32 reg, u32 *id)
 {
-	return btusb_mtk_reg_read(data, 0x80000008, id);
+	return btusb_mtk_reg_read(data, reg, id);
 }
 
 static int btusb_mtk_setup(struct hci_dev *hdev)
@@ -3258,7 +3279,7 @@ static int btusb_mtk_setup(struct hci_dev *hdev)
 
 	calltime = ktime_get();
 
-	err = btusb_mtk_id_get(data, &dev_id);
+	err = btusb_mtk_id_get(data, 0x80000008, &dev_id);
 	if (err < 0) {
 		bt_dev_err(hdev, "Failed to get device id (%d)", err);
 		return err;
diff --git a/drivers/bluetooth/hci_ldisc.c b/drivers/bluetooth/hci_ldisc.c
index 637c5b8c2aa1..726d5c83c550 100644
--- a/drivers/bluetooth/hci_ldisc.c
+++ b/drivers/bluetooth/hci_ldisc.c
@@ -490,6 +490,11 @@ static int hci_uart_tty_open(struct tty_struct *tty)
 		BT_ERR("Can't allocate control structure");
 		return -ENFILE;
 	}
+	if (percpu_init_rwsem(&hu->proto_lock)) {
+		BT_ERR("Can't allocate semaphore structure");
+		kfree(hu);
+		return -ENOMEM;
+	}
 
 	tty->disc_data = hu;
 	hu->tty = tty;
@@ -502,8 +507,6 @@ static int hci_uart_tty_open(struct tty_struct *tty)
 	INIT_WORK(&hu->init_ready, hci_uart_init_work);
 	INIT_WORK(&hu->write_work, hci_uart_write_work);
 
-	percpu_init_rwsem(&hu->proto_lock);
-
 	/* Flush any pending characters in the driver */
 	tty_driver_flush_buffer(tty);
 
diff --git a/drivers/bluetooth/hci_serdev.c b/drivers/bluetooth/hci_serdev.c
index e9a44ab3812d..f2e2e553d4de 100644
--- a/drivers/bluetooth/hci_serdev.c
+++ b/drivers/bluetooth/hci_serdev.c
@@ -301,11 +301,12 @@ int hci_uart_register_device(struct hci_uart *hu,
 
 	serdev_device_set_client_ops(hu->serdev, &hci_serdev_client_ops);
 
+	if (percpu_init_rwsem(&hu->proto_lock))
+		return -ENOMEM;
+
 	err = serdev_device_open(hu->serdev);
 	if (err)
-		return err;
-
-	percpu_init_rwsem(&hu->proto_lock);
+		goto err_rwsem;
 
 	err = p->open(hu);
 	if (err)
@@ -375,6 +376,8 @@ int hci_uart_register_device(struct hci_uart *hu,
 	p->close(hu);
 err_open:
 	serdev_device_close(hu->serdev);
+err_rwsem:
+	percpu_free_rwsem(&hu->proto_lock);
 	return err;
 }
 EXPORT_SYMBOL_GPL(hci_uart_register_device);
@@ -396,5 +399,6 @@ void hci_uart_unregister_device(struct hci_uart *hu)
 		clear_bit(HCI_UART_PROTO_READY, &hu->flags);
 		serdev_device_close(hu->serdev);
 	}
+	percpu_free_rwsem(&hu->proto_lock);
 }
 EXPORT_SYMBOL_GPL(hci_uart_unregister_device);
diff --git a/drivers/char/hw_random/imx-rngc.c b/drivers/char/hw_random/imx-rngc.c
index 61c844baf26e..9b182e5bfa87 100644
--- a/drivers/char/hw_random/imx-rngc.c
+++ b/drivers/char/hw_random/imx-rngc.c
@@ -272,13 +272,6 @@ static int imx_rngc_probe(struct platform_device *pdev)
 		goto err;
 	}
 
-	ret = devm_request_irq(&pdev->dev,
-			irq, imx_rngc_irq, 0, pdev->name, (void *)rngc);
-	if (ret) {
-		dev_err(rngc->dev, "Can't get interrupt working.\n");
-		goto err;
-	}
-
 	init_completion(&rngc->rng_op_done);
 
 	rngc->rng.name = pdev->name;
@@ -292,6 +285,13 @@ static int imx_rngc_probe(struct platform_device *pdev)
 
 	imx_rngc_irq_mask_clear(rngc);
 
+	ret = devm_request_irq(&pdev->dev,
+			irq, imx_rngc_irq, 0, pdev->name, (void *)rngc);
+	if (ret) {
+		dev_err(rngc->dev, "Can't get interrupt working.\n");
+		return ret;
+	}
+
 	if (self_test) {
 		ret = imx_rngc_self_test(rngc);
 		if (ret) {
diff --git a/drivers/clk/baikal-t1/ccu-div.c b/drivers/clk/baikal-t1/ccu-div.c
index 4062092d67f9..a6642f3d33d4 100644
--- a/drivers/clk/baikal-t1/ccu-div.c
+++ b/drivers/clk/baikal-t1/ccu-div.c
@@ -34,6 +34,7 @@
 #define CCU_DIV_CTL_CLKDIV_MASK(_width) \
 	GENMASK((_width) + CCU_DIV_CTL_CLKDIV_FLD - 1, CCU_DIV_CTL_CLKDIV_FLD)
 #define CCU_DIV_CTL_LOCK_SHIFTED	BIT(27)
+#define CCU_DIV_CTL_GATE_REF_BUF	BIT(28)
 #define CCU_DIV_CTL_LOCK_NORMAL		BIT(31)
 
 #define CCU_DIV_RST_DELAY_US		1
@@ -170,6 +171,40 @@ static int ccu_div_gate_is_enabled(struct clk_hw *hw)
 	return !!(val & CCU_DIV_CTL_EN);
 }
 
+static int ccu_div_buf_enable(struct clk_hw *hw)
+{
+	struct ccu_div *div = to_ccu_div(hw);
+	unsigned long flags;
+
+	spin_lock_irqsave(&div->lock, flags);
+	regmap_update_bits(div->sys_regs, div->reg_ctl,
+			   CCU_DIV_CTL_GATE_REF_BUF, 0);
+	spin_unlock_irqrestore(&div->lock, flags);
+
+	return 0;
+}
+
+static void ccu_div_buf_disable(struct clk_hw *hw)
+{
+	struct ccu_div *div = to_ccu_div(hw);
+	unsigned long flags;
+
+	spin_lock_irqsave(&div->lock, flags);
+	regmap_update_bits(div->sys_regs, div->reg_ctl,
+			   CCU_DIV_CTL_GATE_REF_BUF, CCU_DIV_CTL_GATE_REF_BUF);
+	spin_unlock_irqrestore(&div->lock, flags);
+}
+
+static int ccu_div_buf_is_enabled(struct clk_hw *hw)
+{
+	struct ccu_div *div = to_ccu_div(hw);
+	u32 val = 0;
+
+	regmap_read(div->sys_regs, div->reg_ctl, &val);
+
+	return !(val & CCU_DIV_CTL_GATE_REF_BUF);
+}
+
 static unsigned long ccu_div_var_recalc_rate(struct clk_hw *hw,
 					     unsigned long parent_rate)
 {
@@ -323,6 +358,7 @@ static const struct ccu_div_dbgfs_bit ccu_div_bits[] = {
 	CCU_DIV_DBGFS_BIT_ATTR("div_en", CCU_DIV_CTL_EN),
 	CCU_DIV_DBGFS_BIT_ATTR("div_rst", CCU_DIV_CTL_RST),
 	CCU_DIV_DBGFS_BIT_ATTR("div_bypass", CCU_DIV_CTL_SET_CLKDIV),
+	CCU_DIV_DBGFS_BIT_ATTR("div_buf", CCU_DIV_CTL_GATE_REF_BUF),
 	CCU_DIV_DBGFS_BIT_ATTR("div_lock", CCU_DIV_CTL_LOCK_NORMAL)
 };
 
@@ -441,6 +477,9 @@ static void ccu_div_var_debug_init(struct clk_hw *hw, struct dentry *dentry)
 			continue;
 		}
 
+		if (!strcmp("div_buf", name))
+			continue;
+
 		bits[didx] = ccu_div_bits[bidx];
 		bits[didx].div = div;
 
@@ -477,6 +516,21 @@ static void ccu_div_gate_debug_init(struct clk_hw *hw, struct dentry *dentry)
 				   &ccu_div_dbgfs_fixed_clkdiv_fops);
 }
 
+static void ccu_div_buf_debug_init(struct clk_hw *hw, struct dentry *dentry)
+{
+	struct ccu_div *div = to_ccu_div(hw);
+	struct ccu_div_dbgfs_bit *bit;
+
+	bit = kmalloc(sizeof(*bit), GFP_KERNEL);
+	if (!bit)
+		return;
+
+	*bit = ccu_div_bits[3];
+	bit->div = div;
+	debugfs_create_file_unsafe(bit->name, ccu_div_dbgfs_mode, dentry, bit,
+				   &ccu_div_dbgfs_bit_fops);
+}
+
 static void ccu_div_fixed_debug_init(struct clk_hw *hw, struct dentry *dentry)
 {
 	struct ccu_div *div = to_ccu_div(hw);
@@ -489,6 +543,7 @@ static void ccu_div_fixed_debug_init(struct clk_hw *hw, struct dentry *dentry)
 
 #define ccu_div_var_debug_init NULL
 #define ccu_div_gate_debug_init NULL
+#define ccu_div_buf_debug_init NULL
 #define ccu_div_fixed_debug_init NULL
 
 #endif /* !CONFIG_DEBUG_FS */
@@ -520,6 +575,13 @@ static const struct clk_ops ccu_div_gate_ops = {
 	.debug_init = ccu_div_gate_debug_init
 };
 
+static const struct clk_ops ccu_div_buf_ops = {
+	.enable = ccu_div_buf_enable,
+	.disable = ccu_div_buf_disable,
+	.is_enabled = ccu_div_buf_is_enabled,
+	.debug_init = ccu_div_buf_debug_init
+};
+
 static const struct clk_ops ccu_div_fixed_ops = {
 	.recalc_rate = ccu_div_fixed_recalc_rate,
 	.round_rate = ccu_div_fixed_round_rate,
@@ -566,6 +628,8 @@ struct ccu_div *ccu_div_hw_register(const struct ccu_div_init_data *div_init)
 	} else if (div_init->type == CCU_DIV_GATE) {
 		hw_init.ops = &ccu_div_gate_ops;
 		div->divider = div_init->divider;
+	} else if (div_init->type == CCU_DIV_BUF) {
+		hw_init.ops = &ccu_div_buf_ops;
 	} else if (div_init->type == CCU_DIV_FIXED) {
 		hw_init.ops = &ccu_div_fixed_ops;
 		div->divider = div_init->divider;
@@ -579,6 +643,7 @@ struct ccu_div *ccu_div_hw_register(const struct ccu_div_init_data *div_init)
 		goto err_free_div;
 	}
 	parent_data.fw_name = div_init->parent_name;
+	parent_data.name = div_init->parent_name;
 	hw_init.parent_data = &parent_data;
 	hw_init.num_parents = 1;
 
diff --git a/drivers/clk/baikal-t1/ccu-div.h b/drivers/clk/baikal-t1/ccu-div.h
index 795665caefbd..4eb49ff4803c 100644
--- a/drivers/clk/baikal-t1/ccu-div.h
+++ b/drivers/clk/baikal-t1/ccu-div.h
@@ -13,6 +13,14 @@
 #include <linux/bits.h>
 #include <linux/of.h>
 
+/*
+ * CCU Divider private clock IDs
+ * @CCU_SYS_SATA_CLK: CCU SATA internal clock
+ * @CCU_SYS_XGMAC_CLK: CCU XGMAC internal clock
+ */
+#define CCU_SYS_SATA_CLK		-1
+#define CCU_SYS_XGMAC_CLK		-2
+
 /*
  * CCU Divider private flags
  * @CCU_DIV_SKIP_ONE: Due to some reason divider can't be set to 1.
@@ -31,11 +39,13 @@
  * enum ccu_div_type - CCU Divider types
  * @CCU_DIV_VAR: Clocks gate with variable divider.
  * @CCU_DIV_GATE: Clocks gate with fixed divider.
+ * @CCU_DIV_BUF: Clock gate with no divider.
  * @CCU_DIV_FIXED: Ungateable clock with fixed divider.
  */
 enum ccu_div_type {
 	CCU_DIV_VAR,
 	CCU_DIV_GATE,
+	CCU_DIV_BUF,
 	CCU_DIV_FIXED
 };
 
diff --git a/drivers/clk/baikal-t1/clk-ccu-div.c b/drivers/clk/baikal-t1/clk-ccu-div.c
index f141fda12b09..90f4fda406ee 100644
--- a/drivers/clk/baikal-t1/clk-ccu-div.c
+++ b/drivers/clk/baikal-t1/clk-ccu-div.c
@@ -76,6 +76,16 @@
 		.divider = _divider				\
 	}
 
+#define CCU_DIV_BUF_INFO(_id, _name, _pname, _base, _flags)	\
+	{							\
+		.id = _id,					\
+		.name = _name,					\
+		.parent_name = _pname,				\
+		.base = _base,					\
+		.type = CCU_DIV_BUF,				\
+		.flags = _flags					\
+	}
+
 #define CCU_DIV_FIXED_INFO(_id, _name, _pname, _divider)	\
 	{							\
 		.id = _id,					\
@@ -188,11 +198,14 @@ static const struct ccu_div_rst_map axi_rst_map[] = {
  * for the SoC devices registers IO-operations.
  */
 static const struct ccu_div_info sys_info[] = {
-	CCU_DIV_VAR_INFO(CCU_SYS_SATA_REF_CLK, "sys_sata_ref_clk",
+	CCU_DIV_VAR_INFO(CCU_SYS_SATA_CLK, "sys_sata_clk",
 			 "sata_clk", CCU_SYS_SATA_REF_BASE, 4,
 			 CLK_SET_RATE_GATE,
 			 CCU_DIV_SKIP_ONE | CCU_DIV_LOCK_SHIFTED |
 			 CCU_DIV_RESET_DOMAIN),
+	CCU_DIV_BUF_INFO(CCU_SYS_SATA_REF_CLK, "sys_sata_ref_clk",
+			 "sys_sata_clk", CCU_SYS_SATA_REF_BASE,
+			 CLK_SET_RATE_PARENT),
 	CCU_DIV_VAR_INFO(CCU_SYS_APB_CLK, "sys_apb_clk",
 			 "pcie_clk", CCU_SYS_APB_BASE, 5,
 			 CLK_IS_CRITICAL, CCU_DIV_RESET_DOMAIN),
@@ -204,10 +217,12 @@ static const struct ccu_div_info sys_info[] = {
 			  "eth_clk", CCU_SYS_GMAC1_BASE, 5),
 	CCU_DIV_FIXED_INFO(CCU_SYS_GMAC1_PTP_CLK, "sys_gmac1_ptp_clk",
 			   "eth_clk", 10),
-	CCU_DIV_GATE_INFO(CCU_SYS_XGMAC_REF_CLK, "sys_xgmac_ref_clk",
-			  "eth_clk", CCU_SYS_XGMAC_BASE, 8),
+	CCU_DIV_GATE_INFO(CCU_SYS_XGMAC_CLK, "sys_xgmac_clk",
+			  "eth_clk", CCU_SYS_XGMAC_BASE, 1),
+	CCU_DIV_FIXED_INFO(CCU_SYS_XGMAC_REF_CLK, "sys_xgmac_ref_clk",
+			   "sys_xgmac_clk", 8),
 	CCU_DIV_FIXED_INFO(CCU_SYS_XGMAC_PTP_CLK, "sys_xgmac_ptp_clk",
-			   "eth_clk", 10),
+			   "sys_xgmac_clk", 8),
 	CCU_DIV_GATE_INFO(CCU_SYS_USB_CLK, "sys_usb_clk",
 			  "eth_clk", CCU_SYS_USB_BASE, 10),
 	CCU_DIV_VAR_INFO(CCU_SYS_PVT_CLK, "sys_pvt_clk",
@@ -396,6 +411,9 @@ static int ccu_div_clk_register(struct ccu_div_data *data)
 			init.base = info->base;
 			init.sys_regs = data->sys_regs;
 			init.divider = info->divider;
+		} else if (init.type == CCU_DIV_BUF) {
+			init.base = info->base;
+			init.sys_regs = data->sys_regs;
 		} else {
 			init.divider = info->divider;
 		}
diff --git a/drivers/clk/bcm/clk-bcm2835.c b/drivers/clk/bcm/clk-bcm2835.c
index 178886823b90..b7f89873fcf5 100644
--- a/drivers/clk/bcm/clk-bcm2835.c
+++ b/drivers/clk/bcm/clk-bcm2835.c
@@ -968,9 +968,9 @@ static u32 bcm2835_clock_choose_div(struct clk_hw *hw,
 	return div;
 }
 
-static long bcm2835_clock_rate_from_divisor(struct bcm2835_clock *clock,
-					    unsigned long parent_rate,
-					    u32 div)
+static unsigned long bcm2835_clock_rate_from_divisor(struct bcm2835_clock *clock,
+						     unsigned long parent_rate,
+						     u32 div)
 {
 	const struct bcm2835_clock_data *data = clock->data;
 	u64 temp;
@@ -1786,7 +1786,7 @@ static const struct bcm2835_clk_desc clk_desc_array[] = {
 		.load_mask = CM_PLLC_LOADPER,
 		.hold_mask = CM_PLLC_HOLDPER,
 		.fixed_divider = 1,
-		.flags = CLK_SET_RATE_PARENT),
+		.flags = CLK_IS_CRITICAL | CLK_SET_RATE_PARENT),
 
 	/*
 	 * PLLD is the display PLL, used to drive DSI display panels.
diff --git a/drivers/clk/berlin/bg2.c b/drivers/clk/berlin/bg2.c
index bccdfa00fd37..67a9edbba29c 100644
--- a/drivers/clk/berlin/bg2.c
+++ b/drivers/clk/berlin/bg2.c
@@ -500,12 +500,15 @@ static void __init berlin2_clock_setup(struct device_node *np)
 	int n, ret;
 
 	clk_data = kzalloc(struct_size(clk_data, hws, MAX_CLKS), GFP_KERNEL);
-	if (!clk_data)
+	if (!clk_data) {
+		of_node_put(parent_np);
 		return;
+	}
 	clk_data->num = MAX_CLKS;
 	hws = clk_data->hws;
 
 	gbase = of_iomap(parent_np, 0);
+	of_node_put(parent_np);
 	if (!gbase)
 		return;
 
diff --git a/drivers/clk/berlin/bg2q.c b/drivers/clk/berlin/bg2q.c
index e9518d35f262..dd2784bb75b6 100644
--- a/drivers/clk/berlin/bg2q.c
+++ b/drivers/clk/berlin/bg2q.c
@@ -286,19 +286,23 @@ static void __init berlin2q_clock_setup(struct device_node *np)
 	int n, ret;
 
 	clk_data = kzalloc(struct_size(clk_data, hws, MAX_CLKS), GFP_KERNEL);
-	if (!clk_data)
+	if (!clk_data) {
+		of_node_put(parent_np);
 		return;
+	}
 	clk_data->num = MAX_CLKS;
 	hws = clk_data->hws;
 
 	gbase = of_iomap(parent_np, 0);
 	if (!gbase) {
+		of_node_put(parent_np);
 		pr_err("%pOF: Unable to map global base\n", np);
 		return;
 	}
 
 	/* BG2Q CPU PLL is not part of global registers */
 	cpupll_base = of_iomap(parent_np, 1);
+	of_node_put(parent_np);
 	if (!cpupll_base) {
 		pr_err("%pOF: Unable to map cpupll base\n", np);
 		iounmap(gbase);
diff --git a/drivers/clk/clk-ast2600.c b/drivers/clk/clk-ast2600.c
index 24dab2312bc6..9c3305bcb27a 100644
--- a/drivers/clk/clk-ast2600.c
+++ b/drivers/clk/clk-ast2600.c
@@ -622,7 +622,7 @@ static int aspeed_g6_clk_probe(struct platform_device *pdev)
 	regmap_write(map, 0x308, 0x12000); /* 3x3 = 9 */
 
 	/* P-Bus (BCLK) clock divider */
-	hw = clk_hw_register_divider_table(dev, "bclk", "hpll", 0,
+	hw = clk_hw_register_divider_table(dev, "bclk", "epll", 0,
 			scu_g6_base + ASPEED_G6_CLK_SELECTION1, 20, 3, 0,
 			ast2600_div_table,
 			&aspeed_g6_clk_lock);
diff --git a/drivers/clk/clk-oxnas.c b/drivers/clk/clk-oxnas.c
index 78d5ea669fea..2fe36f579ac5 100644
--- a/drivers/clk/clk-oxnas.c
+++ b/drivers/clk/clk-oxnas.c
@@ -207,7 +207,7 @@ static const struct of_device_id oxnas_stdclk_dt_ids[] = {
 
 static int oxnas_stdclk_probe(struct platform_device *pdev)
 {
-	struct device_node *np = pdev->dev.of_node;
+	struct device_node *np = pdev->dev.of_node, *parent_np;
 	const struct oxnas_stdclk_data *data;
 	const struct of_device_id *id;
 	struct regmap *regmap;
@@ -219,7 +219,9 @@ static int oxnas_stdclk_probe(struct platform_device *pdev)
 		return -ENODEV;
 	data = id->data;
 
-	regmap = syscon_node_to_regmap(of_get_parent(np));
+	parent_np = of_get_parent(np);
+	regmap = syscon_node_to_regmap(parent_np);
+	of_node_put(parent_np);
 	if (IS_ERR(regmap)) {
 		dev_err(&pdev->dev, "failed to have parent regmap\n");
 		return PTR_ERR(regmap);
diff --git a/drivers/clk/clk-qoriq.c b/drivers/clk/clk-qoriq.c
index 46101c6a20f2..585b9ac11881 100644
--- a/drivers/clk/clk-qoriq.c
+++ b/drivers/clk/clk-qoriq.c
@@ -1038,8 +1038,13 @@ static void __init _clockgen_init(struct device_node *np, bool legacy);
  */
 static void __init legacy_init_clockgen(struct device_node *np)
 {
-	if (!clockgen.node)
-		_clockgen_init(of_get_parent(np), true);
+	if (!clockgen.node) {
+		struct device_node *parent_np;
+
+		parent_np = of_get_parent(np);
+		_clockgen_init(parent_np, true);
+		of_node_put(parent_np);
+	}
 }
 
 /* Legacy node */
@@ -1134,6 +1139,7 @@ static struct clk * __init create_sysclk(const char *name)
 	sysclk = of_get_child_by_name(clockgen.node, "sysclk");
 	if (sysclk) {
 		clk = sysclk_from_fixed(sysclk, name);
+		of_node_put(sysclk);
 		if (!IS_ERR(clk))
 			return clk;
 	}
diff --git a/drivers/clk/clk-versaclock5.c b/drivers/clk/clk-versaclock5.c
index 4e741f94baf0..eb597ea7bb87 100644
--- a/drivers/clk/clk-versaclock5.c
+++ b/drivers/clk/clk-versaclock5.c
@@ -1116,7 +1116,7 @@ static const struct vc5_chip_info idt_5p49v6901_info = {
 	.model = IDT_VC6_5P49V6901,
 	.clk_fod_cnt = 4,
 	.clk_out_cnt = 5,
-	.flags = VC5_HAS_PFD_FREQ_DBL,
+	.flags = VC5_HAS_PFD_FREQ_DBL | VC5_HAS_BYPASS_SYNC_BIT,
 };
 
 static const struct vc5_chip_info idt_5p49v6965_info = {
diff --git a/drivers/clk/mediatek/clk-mt8183-mfgcfg.c b/drivers/clk/mediatek/clk-mt8183-mfgcfg.c
index 37b4162c5882..3a33014eee7f 100644
--- a/drivers/clk/mediatek/clk-mt8183-mfgcfg.c
+++ b/drivers/clk/mediatek/clk-mt8183-mfgcfg.c
@@ -18,9 +18,9 @@ static const struct mtk_gate_regs mfg_cg_regs = {
 	.sta_ofs = 0x0,
 };
 
-#define GATE_MFG(_id, _name, _parent, _shift)			\
-	GATE_MTK(_id, _name, _parent, &mfg_cg_regs, _shift,	\
-		&mtk_clk_gate_ops_setclr)
+#define GATE_MFG(_id, _name, _parent, _shift)				\
+	GATE_MTK_FLAGS(_id, _name, _parent, &mfg_cg_regs, _shift,	\
+		       &mtk_clk_gate_ops_setclr, CLK_SET_RATE_PARENT)
 
 static const struct mtk_gate mfg_clks[] = {
 	GATE_MFG(CLK_MFG_BG3D, "mfg_bg3d", "mfg_sel", 0)
diff --git a/drivers/clk/meson/meson-aoclk.c b/drivers/clk/meson/meson-aoclk.c
index 3a6d84cd6601..67d8a0d30221 100644
--- a/drivers/clk/meson/meson-aoclk.c
+++ b/drivers/clk/meson/meson-aoclk.c
@@ -36,6 +36,7 @@ int meson_aoclkc_probe(struct platform_device *pdev)
 	struct meson_aoclk_reset_controller *rstc;
 	struct meson_aoclk_data *data;
 	struct device *dev = &pdev->dev;
+	struct device_node *np;
 	struct regmap *regmap;
 	int ret, clkid;
 
@@ -47,7 +48,9 @@ int meson_aoclkc_probe(struct platform_device *pdev)
 	if (!rstc)
 		return -ENOMEM;
 
-	regmap = syscon_node_to_regmap(of_get_parent(dev->of_node));
+	np = of_get_parent(dev->of_node);
+	regmap = syscon_node_to_regmap(np);
+	of_node_put(np);
 	if (IS_ERR(regmap)) {
 		dev_err(dev, "failed to get regmap\n");
 		return PTR_ERR(regmap);
diff --git a/drivers/clk/meson/meson-eeclk.c b/drivers/clk/meson/meson-eeclk.c
index a7cb1e7aedc4..18ae38787268 100644
--- a/drivers/clk/meson/meson-eeclk.c
+++ b/drivers/clk/meson/meson-eeclk.c
@@ -17,6 +17,7 @@ int meson_eeclkc_probe(struct platform_device *pdev)
 {
 	const struct meson_eeclkc_data *data;
 	struct device *dev = &pdev->dev;
+	struct device_node *np;
 	struct regmap *map;
 	int ret, i;
 
@@ -25,7 +26,9 @@ int meson_eeclkc_probe(struct platform_device *pdev)
 		return -EINVAL;
 
 	/* Get the hhi system controller node */
-	map = syscon_node_to_regmap(of_get_parent(dev->of_node));
+	np = of_get_parent(dev->of_node);
+	map = syscon_node_to_regmap(np);
+	of_node_put(np);
 	if (IS_ERR(map)) {
 		dev_err(dev,
 			"failed to get HHI regmap\n");
diff --git a/drivers/clk/meson/meson8b.c b/drivers/clk/meson/meson8b.c
index 862f0756b50f..1da9d212f8b7 100644
--- a/drivers/clk/meson/meson8b.c
+++ b/drivers/clk/meson/meson8b.c
@@ -3735,13 +3735,16 @@ static void __init meson8b_clkc_init_common(struct device_node *np,
 			struct clk_hw_onecell_data *clk_hw_onecell_data)
 {
 	struct meson8b_clk_reset *rstc;
+	struct device_node *parent_np;
 	const char *notifier_clk_name;
 	struct clk *notifier_clk;
 	void __iomem *clk_base;
 	struct regmap *map;
 	int i, ret;
 
-	map = syscon_node_to_regmap(of_get_parent(np));
+	parent_np = of_get_parent(np);
+	map = syscon_node_to_regmap(parent_np);
+	of_node_put(parent_np);
 	if (IS_ERR(map)) {
 		pr_info("failed to get HHI regmap - Trying obsolete regs\n");
 
diff --git a/drivers/clk/qcom/apss-ipq6018.c b/drivers/clk/qcom/apss-ipq6018.c
index d78ff2f310bf..b5d93657e1ee 100644
--- a/drivers/clk/qcom/apss-ipq6018.c
+++ b/drivers/clk/qcom/apss-ipq6018.c
@@ -57,7 +57,7 @@ static struct clk_branch apcs_alias0_core_clk = {
 			.parent_hws = (const struct clk_hw *[]){
 				&apcs_alias0_clk_src.clkr.hw },
 			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
+			.flags = CLK_SET_RATE_PARENT | CLK_IS_CRITICAL,
 			.ops = &clk_branch2_ops,
 		},
 	},
diff --git a/drivers/clk/sprd/common.c b/drivers/clk/sprd/common.c
index d620bbbcdfc8..ce81e4087a8f 100644
--- a/drivers/clk/sprd/common.c
+++ b/drivers/clk/sprd/common.c
@@ -41,7 +41,7 @@ int sprd_clk_regmap_init(struct platform_device *pdev,
 {
 	void __iomem *base;
 	struct device *dev = &pdev->dev;
-	struct device_node *node = dev->of_node;
+	struct device_node *node = dev->of_node, *np;
 	struct regmap *regmap;
 
 	if (of_find_property(node, "sprd,syscon", NULL)) {
@@ -50,9 +50,10 @@ int sprd_clk_regmap_init(struct platform_device *pdev,
 			pr_err("%s: failed to get syscon regmap\n", __func__);
 			return PTR_ERR(regmap);
 		}
-	} else if (of_device_is_compatible(of_get_parent(dev->of_node),
-			   "syscon")) {
-		regmap = device_node_to_regmap(of_get_parent(dev->of_node));
+	} else if (of_device_is_compatible(np =	of_get_parent(node), "syscon") ||
+		   (of_node_put(np), 0)) {
+		regmap = device_node_to_regmap(np);
+		of_node_put(np);
 		if (IS_ERR(regmap)) {
 			dev_err(dev, "failed to get regmap from its parent.\n");
 			return PTR_ERR(regmap);
diff --git a/drivers/clk/tegra/clk-tegra114.c b/drivers/clk/tegra/clk-tegra114.c
index bc9e47a4cb60..4e2b26e3e573 100644
--- a/drivers/clk/tegra/clk-tegra114.c
+++ b/drivers/clk/tegra/clk-tegra114.c
@@ -1317,6 +1317,7 @@ static void __init tegra114_clock_init(struct device_node *np)
 	}
 
 	pmc_base = of_iomap(node, 0);
+	of_node_put(node);
 	if (!pmc_base) {
 		pr_err("Can't map pmc registers\n");
 		WARN_ON(1);
diff --git a/drivers/clk/tegra/clk-tegra20.c b/drivers/clk/tegra/clk-tegra20.c
index 3efc651b42e3..d60ee6e318a5 100644
--- a/drivers/clk/tegra/clk-tegra20.c
+++ b/drivers/clk/tegra/clk-tegra20.c
@@ -1128,6 +1128,7 @@ static void __init tegra20_clock_init(struct device_node *np)
 	}
 
 	pmc_base = of_iomap(node, 0);
+	of_node_put(node);
 	if (!pmc_base) {
 		pr_err("Can't map pmc registers\n");
 		BUG();
diff --git a/drivers/clk/tegra/clk-tegra210.c b/drivers/clk/tegra/clk-tegra210.c
index 68cbb98af567..1a0016d07f88 100644
--- a/drivers/clk/tegra/clk-tegra210.c
+++ b/drivers/clk/tegra/clk-tegra210.c
@@ -3697,6 +3697,7 @@ static void __init tegra210_clock_init(struct device_node *np)
 	}
 
 	pmc_base = of_iomap(node, 0);
+	of_node_put(node);
 	if (!pmc_base) {
 		pr_err("Can't map pmc registers\n");
 		WARN_ON(1);
diff --git a/drivers/clk/ti/clk-dra7-atl.c b/drivers/clk/ti/clk-dra7-atl.c
index 8d4c08b034bd..e2e59d78c173 100644
--- a/drivers/clk/ti/clk-dra7-atl.c
+++ b/drivers/clk/ti/clk-dra7-atl.c
@@ -251,14 +251,16 @@ static int of_dra7_atl_clk_probe(struct platform_device *pdev)
 		if (rc) {
 			pr_err("%s: failed to lookup atl clock %d\n", __func__,
 			       i);
-			return -EINVAL;
+			ret = -EINVAL;
+			goto pm_put;
 		}
 
 		clk = of_clk_get_from_provider(&clkspec);
 		if (IS_ERR(clk)) {
 			pr_err("%s: failed to get atl clock %d from provider\n",
 			       __func__, i);
-			return PTR_ERR(clk);
+			ret = PTR_ERR(clk);
+			goto pm_put;
 		}
 
 		cdesc = to_atl_desc(__clk_get_hw(clk));
@@ -291,8 +293,9 @@ static int of_dra7_atl_clk_probe(struct platform_device *pdev)
 		if (cdesc->enabled)
 			atl_clk_enable(__clk_get_hw(clk));
 	}
-	pm_runtime_put_sync(cinfo->dev);
 
+pm_put:
+	pm_runtime_put_sync(cinfo->dev);
 	return ret;
 }
 
diff --git a/drivers/clk/zynqmp/clkc.c b/drivers/clk/zynqmp/clkc.c
index db8d0d7161ce..9c82ae240c40 100644
--- a/drivers/clk/zynqmp/clkc.c
+++ b/drivers/clk/zynqmp/clkc.c
@@ -687,6 +687,13 @@ static void zynqmp_get_clock_info(void)
 				  FIELD_PREP(CLK_ATTR_NODE_INDEX, i);
 
 		zynqmp_pm_clock_get_name(clock[i].clk_id, &name);
+
+		/*
+		 * Terminate with NULL character in case name provided by firmware
+		 * is longer and truncated due to size limit.
+		 */
+		name.name[sizeof(name.name) - 1] = '\0';
+
 		if (!strcmp(name.name, RESERVED_CLK_NAME))
 			continue;
 		strncpy(clock[i].clk_name, name.name, MAX_NAME_LEN);
diff --git a/drivers/clk/zynqmp/pll.c b/drivers/clk/zynqmp/pll.c
index abe6afbf3407..2ae7f9129b07 100644
--- a/drivers/clk/zynqmp/pll.c
+++ b/drivers/clk/zynqmp/pll.c
@@ -99,26 +99,25 @@ static long zynqmp_pll_round_rate(struct clk_hw *hw, unsigned long rate,
 				  unsigned long *prate)
 {
 	u32 fbdiv;
-	long rate_div, f;
+	u32 mult, div;
 
-	/* Enable the fractional mode if needed */
-	rate_div = (rate * FRAC_DIV) / *prate;
-	f = rate_div % FRAC_DIV;
-	if (f) {
-		if (rate > PS_PLL_VCO_MAX) {
-			fbdiv = rate / PS_PLL_VCO_MAX;
-			rate = rate / (fbdiv + 1);
-		}
-		if (rate < PS_PLL_VCO_MIN) {
-			fbdiv = DIV_ROUND_UP(PS_PLL_VCO_MIN, rate);
-			rate = rate * fbdiv;
-		}
-		return rate;
+	/* Let rate fall inside the range PS_PLL_VCO_MIN ~ PS_PLL_VCO_MAX */
+	if (rate > PS_PLL_VCO_MAX) {
+		div = DIV_ROUND_UP(rate, PS_PLL_VCO_MAX);
+		rate = rate / div;
+	}
+	if (rate < PS_PLL_VCO_MIN) {
+		mult = DIV_ROUND_UP(PS_PLL_VCO_MIN, rate);
+		rate = rate * mult;
 	}
 
 	fbdiv = DIV_ROUND_CLOSEST(rate, *prate);
-	fbdiv = clamp_t(u32, fbdiv, PLL_FBDIV_MIN, PLL_FBDIV_MAX);
-	return *prate * fbdiv;
+	if (fbdiv < PLL_FBDIV_MIN || fbdiv > PLL_FBDIV_MAX) {
+		fbdiv = clamp_t(u32, fbdiv, PLL_FBDIV_MIN, PLL_FBDIV_MAX);
+		rate = *prate * fbdiv;
+	}
+
+	return rate;
 }
 
 /**
diff --git a/drivers/crypto/cavium/cpt/cptpf_main.c b/drivers/crypto/cavium/cpt/cptpf_main.c
index 781949027451..d9362199423f 100644
--- a/drivers/crypto/cavium/cpt/cptpf_main.c
+++ b/drivers/crypto/cavium/cpt/cptpf_main.c
@@ -254,6 +254,7 @@ static int cpt_ucode_load_fw(struct cpt_device *cpt, const u8 *fw, bool is_ae)
 	const struct firmware *fw_entry;
 	struct device *dev = &cpt->pdev->dev;
 	struct ucode_header *ucode;
+	unsigned int code_length;
 	struct microcode *mcode;
 	int j, ret = 0;
 
@@ -264,11 +265,12 @@ static int cpt_ucode_load_fw(struct cpt_device *cpt, const u8 *fw, bool is_ae)
 	ucode = (struct ucode_header *)fw_entry->data;
 	mcode = &cpt->mcode[cpt->next_mc_idx];
 	memcpy(mcode->version, (u8 *)fw_entry->data, CPT_UCODE_VERSION_SZ);
-	mcode->code_size = ntohl(ucode->code_length) * 2;
-	if (!mcode->code_size) {
+	code_length = ntohl(ucode->code_length);
+	if (code_length == 0 || code_length >= INT_MAX / 2) {
 		ret = -EINVAL;
 		goto fw_release;
 	}
+	mcode->code_size = code_length * 2;
 
 	mcode->is_ae = is_ae;
 	mcode->core_mask = 0ULL;
diff --git a/drivers/crypto/ccp/ccp-dmaengine.c b/drivers/crypto/ccp/ccp-dmaengine.c
index b3eea329f840..b9299defb431 100644
--- a/drivers/crypto/ccp/ccp-dmaengine.c
+++ b/drivers/crypto/ccp/ccp-dmaengine.c
@@ -642,6 +642,10 @@ static void ccp_dma_release(struct ccp_device *ccp)
 	for (i = 0; i < ccp->cmd_q_count; i++) {
 		chan = ccp->ccp_dma_chan + i;
 		dma_chan = &chan->dma_chan;
+
+		if (dma_chan->client_count)
+			dma_release_channel(dma_chan);
+
 		tasklet_kill(&chan->cleanup_tasklet);
 		list_del_rcu(&dma_chan->device_node);
 	}
@@ -767,8 +771,8 @@ void ccp_dmaengine_unregister(struct ccp_device *ccp)
 	if (!dmaengine)
 		return;
 
-	dma_async_device_unregister(dma_dev);
 	ccp_dma_release(ccp);
+	dma_async_device_unregister(dma_dev);
 
 	kmem_cache_destroy(ccp->dma_desc_cache);
 	kmem_cache_destroy(ccp->dma_cmd_cache);
diff --git a/drivers/crypto/hisilicon/zip/zip_crypto.c b/drivers/crypto/hisilicon/zip/zip_crypto.c
index 08b4660b014c..5db7cdea994a 100644
--- a/drivers/crypto/hisilicon/zip/zip_crypto.c
+++ b/drivers/crypto/hisilicon/zip/zip_crypto.c
@@ -107,12 +107,12 @@ static int sgl_sge_nr_set(const char *val, const struct kernel_param *kp)
 	if (ret || n == 0 || n > HISI_ACC_SGL_SGE_NR_MAX)
 		return -EINVAL;
 
-	return param_set_int(val, kp);
+	return param_set_ushort(val, kp);
 }
 
 static const struct kernel_param_ops sgl_sge_nr_ops = {
 	.set = sgl_sge_nr_set,
-	.get = param_get_int,
+	.get = param_get_ushort,
 };
 
 static u16 sgl_sge_nr = HZIP_SGL_SGE_NR;
diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index 56d5ccb5cc00..1c9af02eb63b 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -381,7 +381,7 @@ static int safexcel_ahash_send_req(struct crypto_async_request *async, int ring,
 					u32 x;
 
 					x = ipad[i] ^ ipad[i + 4];
-					cache[i] ^= swab(x);
+					cache[i] ^= swab32(x);
 				}
 			}
 			cache_len = AES_BLOCK_SIZE;
@@ -819,7 +819,7 @@ static int safexcel_ahash_final(struct ahash_request *areq)
 			u32 *result = (void *)areq->result;
 
 			/* K3 */
-			result[i] = swab(ctx->base.ipad.word[i + 4]);
+			result[i] = swab32(ctx->base.ipad.word[i + 4]);
 		}
 		areq->result[0] ^= 0x80;			// 10- padding
 		crypto_cipher_encrypt_one(ctx->kaes, areq->result, areq->result);
@@ -2104,7 +2104,7 @@ static int safexcel_xcbcmac_setkey(struct crypto_ahash *tfm, const u8 *key,
 	crypto_cipher_encrypt_one(ctx->kaes, (u8 *)key_tmp + AES_BLOCK_SIZE,
 		"\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3");
 	for (i = 0; i < 3 * AES_BLOCK_SIZE / sizeof(u32); i++)
-		ctx->base.ipad.word[i] = swab(key_tmp[i]);
+		ctx->base.ipad.word[i] = swab32(key_tmp[i]);
 
 	crypto_cipher_clear_flags(ctx->kaes, CRYPTO_TFM_REQ_MASK);
 	crypto_cipher_set_flags(ctx->kaes, crypto_ahash_get_flags(tfm) &
@@ -2187,7 +2187,7 @@ static int safexcel_cmac_setkey(struct crypto_ahash *tfm, const u8 *key,
 		return ret;
 
 	for (i = 0; i < len / sizeof(u32); i++)
-		ctx->base.ipad.word[i + 8] = swab(aes.key_enc[i]);
+		ctx->base.ipad.word[i + 8] = swab32(aes.key_enc[i]);
 
 	/* precompute the CMAC key material */
 	crypto_cipher_clear_flags(ctx->kaes, CRYPTO_TFM_REQ_MASK);
diff --git a/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c b/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c
index 40b482198ebc..a765eefb18c2 100644
--- a/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c
+++ b/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c
@@ -286,6 +286,7 @@ static int process_tar_file(struct device *dev,
 	struct tar_ucode_info_t *tar_info;
 	struct otx_cpt_ucode_hdr *ucode_hdr;
 	int ucode_type, ucode_size;
+	unsigned int code_length;
 
 	/*
 	 * If size is less than microcode header size then don't report
@@ -303,7 +304,13 @@ static int process_tar_file(struct device *dev,
 	if (get_ucode_type(ucode_hdr, &ucode_type))
 		return 0;
 
-	ucode_size = ntohl(ucode_hdr->code_length) * 2;
+	code_length = ntohl(ucode_hdr->code_length);
+	if (code_length >= INT_MAX / 2) {
+		dev_err(dev, "Invalid code_length %u\n", code_length);
+		return -EINVAL;
+	}
+
+	ucode_size = code_length * 2;
 	if (!ucode_size || (size < round_up(ucode_size, 16) +
 	    sizeof(struct otx_cpt_ucode_hdr) + OTX_CPT_UCODE_SIGN_LEN)) {
 		dev_err(dev, "Ucode %s invalid size\n", filename);
@@ -886,6 +893,7 @@ static int ucode_load(struct device *dev, struct otx_cpt_ucode *ucode,
 {
 	struct otx_cpt_ucode_hdr *ucode_hdr;
 	const struct firmware *fw;
+	unsigned int code_length;
 	int ret;
 
 	set_ucode_filename(ucode, ucode_filename);
@@ -896,7 +904,13 @@ static int ucode_load(struct device *dev, struct otx_cpt_ucode *ucode,
 	ucode_hdr = (struct otx_cpt_ucode_hdr *) fw->data;
 	memcpy(ucode->ver_str, ucode_hdr->ver_str, OTX_CPT_UCODE_VER_STR_SZ);
 	ucode->ver_num = ucode_hdr->ver_num;
-	ucode->size = ntohl(ucode_hdr->code_length) * 2;
+	code_length = ntohl(ucode_hdr->code_length);
+	if (code_length >= INT_MAX / 2) {
+		dev_err(dev, "Ucode invalid code_length %u\n", code_length);
+		ret = -EINVAL;
+		goto release_fw;
+	}
+	ucode->size = code_length * 2;
 	if (!ucode->size || (fw->size < round_up(ucode->size, 16)
 	    + sizeof(struct otx_cpt_ucode_hdr) + OTX_CPT_UCODE_SIGN_LEN)) {
 		dev_err(dev, "Ucode %s invalid size\n", ucode_filename);
diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index 06abe1e2074e..5b71768fc0c7 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -34,19 +34,6 @@
 static DEFINE_MUTEX(algs_lock);
 static unsigned int active_devs;
 
-struct qat_alg_buf {
-	u32 len;
-	u32 resrvd;
-	u64 addr;
-} __packed;
-
-struct qat_alg_buf_list {
-	u64 resrvd;
-	u32 num_bufs;
-	u32 num_mapped_bufs;
-	struct qat_alg_buf bufers[];
-} __packed __aligned(64);
-
 /* Common content descriptor */
 struct qat_alg_cd {
 	union {
@@ -637,14 +624,20 @@ static void qat_alg_free_bufl(struct qat_crypto_instance *inst,
 	dma_addr_t blpout = qat_req->buf.bloutp;
 	size_t sz = qat_req->buf.sz;
 	size_t sz_out = qat_req->buf.sz_out;
+	int bl_dma_dir;
 	int i;
 
+	bl_dma_dir = blp != blpout ? DMA_TO_DEVICE : DMA_BIDIRECTIONAL;
+
 	for (i = 0; i < bl->num_bufs; i++)
 		dma_unmap_single(dev, bl->bufers[i].addr,
-				 bl->bufers[i].len, DMA_BIDIRECTIONAL);
+				 bl->bufers[i].len, bl_dma_dir);
 
 	dma_unmap_single(dev, blp, sz, DMA_TO_DEVICE);
-	kfree(bl);
+
+	if (!qat_req->buf.sgl_src_valid)
+		kfree(bl);
+
 	if (blp != blpout) {
 		/* If out of place operation dma unmap only data */
 		int bufless = blout->num_bufs - blout->num_mapped_bufs;
@@ -652,10 +645,12 @@ static void qat_alg_free_bufl(struct qat_crypto_instance *inst,
 		for (i = bufless; i < blout->num_bufs; i++) {
 			dma_unmap_single(dev, blout->bufers[i].addr,
 					 blout->bufers[i].len,
-					 DMA_BIDIRECTIONAL);
+					 DMA_FROM_DEVICE);
 		}
 		dma_unmap_single(dev, blpout, sz_out, DMA_TO_DEVICE);
-		kfree(blout);
+
+		if (!qat_req->buf.sgl_dst_valid)
+			kfree(blout);
 	}
 }
 
@@ -669,26 +664,34 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 	int n = sg_nents(sgl);
 	struct qat_alg_buf_list *bufl;
 	struct qat_alg_buf_list *buflout = NULL;
-	dma_addr_t blp;
-	dma_addr_t bloutp;
+	dma_addr_t blp = DMA_MAPPING_ERROR;
+	dma_addr_t bloutp = DMA_MAPPING_ERROR;
 	struct scatterlist *sg;
-	size_t sz_out, sz = struct_size(bufl, bufers, n + 1);
+	size_t sz_out, sz = struct_size(bufl, bufers, n);
+	int node = dev_to_node(&GET_DEV(inst->accel_dev));
+	int bufl_dma_dir;
 
 	if (unlikely(!n))
 		return -EINVAL;
 
-	bufl = kzalloc_node(sz, GFP_ATOMIC,
-			    dev_to_node(&GET_DEV(inst->accel_dev)));
-	if (unlikely(!bufl))
-		return -ENOMEM;
+	qat_req->buf.sgl_src_valid = false;
+	qat_req->buf.sgl_dst_valid = false;
+
+	if (n > QAT_MAX_BUFF_DESC) {
+		bufl = kzalloc_node(sz, GFP_ATOMIC, node);
+		if (unlikely(!bufl))
+			return -ENOMEM;
+	} else {
+		bufl = &qat_req->buf.sgl_src.sgl_hdr;
+		memset(bufl, 0, sizeof(struct qat_alg_buf_list));
+		qat_req->buf.sgl_src_valid = true;
+	}
+
+	bufl_dma_dir = sgl != sglout ? DMA_TO_DEVICE : DMA_BIDIRECTIONAL;
 
 	for_each_sg(sgl, sg, n, i)
 		bufl->bufers[i].addr = DMA_MAPPING_ERROR;
 
-	blp = dma_map_single(dev, bufl, sz, DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(dev, blp)))
-		goto err_in;
-
 	for_each_sg(sgl, sg, n, i) {
 		int y = sg_nctr;
 
@@ -697,13 +700,16 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 
 		bufl->bufers[y].addr = dma_map_single(dev, sg_virt(sg),
 						      sg->length,
-						      DMA_BIDIRECTIONAL);
+						      bufl_dma_dir);
 		bufl->bufers[y].len = sg->length;
 		if (unlikely(dma_mapping_error(dev, bufl->bufers[y].addr)))
 			goto err_in;
 		sg_nctr++;
 	}
 	bufl->num_bufs = sg_nctr;
+	blp = dma_map_single(dev, bufl, sz, DMA_TO_DEVICE);
+	if (unlikely(dma_mapping_error(dev, blp)))
+		goto err_in;
 	qat_req->buf.bl = bufl;
 	qat_req->buf.blp = blp;
 	qat_req->buf.sz = sz;
@@ -712,20 +718,23 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 		struct qat_alg_buf *bufers;
 
 		n = sg_nents(sglout);
-		sz_out = struct_size(buflout, bufers, n + 1);
+		sz_out = struct_size(buflout, bufers, n);
 		sg_nctr = 0;
-		buflout = kzalloc_node(sz_out, GFP_ATOMIC,
-				       dev_to_node(&GET_DEV(inst->accel_dev)));
-		if (unlikely(!buflout))
-			goto err_in;
+
+		if (n > QAT_MAX_BUFF_DESC) {
+			buflout = kzalloc_node(sz_out, GFP_ATOMIC, node);
+			if (unlikely(!buflout))
+				goto err_in;
+		} else {
+			buflout = &qat_req->buf.sgl_dst.sgl_hdr;
+			memset(buflout, 0, sizeof(struct qat_alg_buf_list));
+			qat_req->buf.sgl_dst_valid = true;
+		}
 
 		bufers = buflout->bufers;
 		for_each_sg(sglout, sg, n, i)
 			bufers[i].addr = DMA_MAPPING_ERROR;
 
-		bloutp = dma_map_single(dev, buflout, sz_out, DMA_TO_DEVICE);
-		if (unlikely(dma_mapping_error(dev, bloutp)))
-			goto err_out;
 		for_each_sg(sglout, sg, n, i) {
 			int y = sg_nctr;
 
@@ -734,7 +743,7 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 
 			bufers[y].addr = dma_map_single(dev, sg_virt(sg),
 							sg->length,
-							DMA_BIDIRECTIONAL);
+							DMA_FROM_DEVICE);
 			if (unlikely(dma_mapping_error(dev, bufers[y].addr)))
 				goto err_out;
 			bufers[y].len = sg->length;
@@ -742,6 +751,9 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 		}
 		buflout->num_bufs = sg_nctr;
 		buflout->num_mapped_bufs = sg_nctr;
+		bloutp = dma_map_single(dev, buflout, sz_out, DMA_TO_DEVICE);
+		if (unlikely(dma_mapping_error(dev, bloutp)))
+			goto err_out;
 		qat_req->buf.blout = buflout;
 		qat_req->buf.bloutp = bloutp;
 		qat_req->buf.sz_out = sz_out;
@@ -753,27 +765,32 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 	return 0;
 
 err_out:
+	if (!dma_mapping_error(dev, bloutp))
+		dma_unmap_single(dev, bloutp, sz_out, DMA_TO_DEVICE);
+
 	n = sg_nents(sglout);
 	for (i = 0; i < n; i++)
 		if (!dma_mapping_error(dev, buflout->bufers[i].addr))
 			dma_unmap_single(dev, buflout->bufers[i].addr,
 					 buflout->bufers[i].len,
-					 DMA_BIDIRECTIONAL);
-	if (!dma_mapping_error(dev, bloutp))
-		dma_unmap_single(dev, bloutp, sz_out, DMA_TO_DEVICE);
-	kfree(buflout);
+					 DMA_FROM_DEVICE);
+
+	if (!qat_req->buf.sgl_dst_valid)
+		kfree(buflout);
 
 err_in:
+	if (!dma_mapping_error(dev, blp))
+		dma_unmap_single(dev, blp, sz, DMA_TO_DEVICE);
+
 	n = sg_nents(sgl);
 	for (i = 0; i < n; i++)
 		if (!dma_mapping_error(dev, bufl->bufers[i].addr))
 			dma_unmap_single(dev, bufl->bufers[i].addr,
 					 bufl->bufers[i].len,
-					 DMA_BIDIRECTIONAL);
+					 bufl_dma_dir);
 
-	if (!dma_mapping_error(dev, blp))
-		dma_unmap_single(dev, blp, sz, DMA_TO_DEVICE);
-	kfree(bufl);
+	if (!qat_req->buf.sgl_src_valid)
+		kfree(bufl);
 
 	dev_err(dev, "Failed to map buf for dma\n");
 	return -ENOMEM;
diff --git a/drivers/crypto/qat/qat_common/qat_crypto.h b/drivers/crypto/qat/qat_common/qat_crypto.h
index 12682d1e9f5f..5f9328201ba4 100644
--- a/drivers/crypto/qat/qat_common/qat_crypto.h
+++ b/drivers/crypto/qat/qat_common/qat_crypto.h
@@ -20,6 +20,26 @@ struct qat_crypto_instance {
 	atomic_t refctr;
 };
 
+#define QAT_MAX_BUFF_DESC	4
+
+struct qat_alg_buf {
+	u32 len;
+	u32 resrvd;
+	u64 addr;
+} __packed;
+
+struct qat_alg_buf_list {
+	u64 resrvd;
+	u32 num_bufs;
+	u32 num_mapped_bufs;
+	struct qat_alg_buf bufers[];
+} __packed;
+
+struct qat_alg_fixed_buf_list {
+	struct qat_alg_buf_list sgl_hdr;
+	struct qat_alg_buf descriptors[QAT_MAX_BUFF_DESC];
+} __packed __aligned(64);
+
 struct qat_crypto_request_buffs {
 	struct qat_alg_buf_list *bl;
 	dma_addr_t blp;
@@ -27,6 +47,10 @@ struct qat_crypto_request_buffs {
 	dma_addr_t bloutp;
 	size_t sz;
 	size_t sz_out;
+	bool sgl_src_valid;
+	bool sgl_dst_valid;
+	struct qat_alg_fixed_buf_list sgl_src;
+	struct qat_alg_fixed_buf_list sgl_dst;
 };
 
 struct qat_crypto_request;
diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index d60679c79822..2043dd061121 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -25,10 +25,10 @@
 #include <linux/kernel.h>
 #include <linux/kthread.h>
 #include <linux/module.h>
-#include <linux/mutex.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/platform_device.h>
+#include <linux/spinlock.h>
 
 #define SHA_BUFFER_LEN		PAGE_SIZE
 #define SAHARA_MAX_SHA_BLOCK_SIZE	SHA256_BLOCK_SIZE
@@ -195,7 +195,7 @@ struct sahara_dev {
 	void __iomem		*regs_base;
 	struct clk		*clk_ipg;
 	struct clk		*clk_ahb;
-	struct mutex		queue_mutex;
+	spinlock_t		queue_spinlock;
 	struct task_struct	*kthread;
 	struct completion	dma_completion;
 
@@ -641,9 +641,9 @@ static int sahara_aes_crypt(struct skcipher_request *req, unsigned long mode)
 
 	rctx->mode = mode;
 
-	mutex_lock(&dev->queue_mutex);
+	spin_lock_bh(&dev->queue_spinlock);
 	err = crypto_enqueue_request(&dev->queue, &req->base);
-	mutex_unlock(&dev->queue_mutex);
+	spin_unlock_bh(&dev->queue_spinlock);
 
 	wake_up_process(dev->kthread);
 
@@ -1042,10 +1042,10 @@ static int sahara_queue_manage(void *data)
 	do {
 		__set_current_state(TASK_INTERRUPTIBLE);
 
-		mutex_lock(&dev->queue_mutex);
+		spin_lock_bh(&dev->queue_spinlock);
 		backlog = crypto_get_backlog(&dev->queue);
 		async_req = crypto_dequeue_request(&dev->queue);
-		mutex_unlock(&dev->queue_mutex);
+		spin_unlock_bh(&dev->queue_spinlock);
 
 		if (backlog)
 			backlog->complete(backlog, -EINPROGRESS);
@@ -1091,9 +1091,9 @@ static int sahara_sha_enqueue(struct ahash_request *req, int last)
 		rctx->first = 1;
 	}
 
-	mutex_lock(&dev->queue_mutex);
+	spin_lock_bh(&dev->queue_spinlock);
 	ret = crypto_enqueue_request(&dev->queue, &req->base);
-	mutex_unlock(&dev->queue_mutex);
+	spin_unlock_bh(&dev->queue_spinlock);
 
 	wake_up_process(dev->kthread);
 
@@ -1454,7 +1454,7 @@ static int sahara_probe(struct platform_device *pdev)
 
 	crypto_init_queue(&dev->queue, SAHARA_QUEUE_LENGTH);
 
-	mutex_init(&dev->queue_mutex);
+	spin_lock_init(&dev->queue_spinlock);
 
 	dev_ptr = dev;
 
diff --git a/drivers/dma-buf/udmabuf.c b/drivers/dma-buf/udmabuf.c
index b624f3d8f0e6..e359c5c6c4df 100644
--- a/drivers/dma-buf/udmabuf.c
+++ b/drivers/dma-buf/udmabuf.c
@@ -118,17 +118,20 @@ static int begin_cpu_udmabuf(struct dma_buf *buf,
 {
 	struct udmabuf *ubuf = buf->priv;
 	struct device *dev = ubuf->device->this_device;
+	int ret = 0;
 
 	if (!ubuf->sg) {
 		ubuf->sg = get_sg_table(dev, buf, direction);
-		if (IS_ERR(ubuf->sg))
-			return PTR_ERR(ubuf->sg);
+		if (IS_ERR(ubuf->sg)) {
+			ret = PTR_ERR(ubuf->sg);
+			ubuf->sg = NULL;
+		}
 	} else {
 		dma_sync_sg_for_cpu(dev, ubuf->sg->sgl, ubuf->sg->nents,
 				    direction);
 	}
 
-	return 0;
+	return ret;
 }
 
 static int end_cpu_udmabuf(struct dma_buf *buf,
diff --git a/drivers/dma/hisi_dma.c b/drivers/dma/hisi_dma.c
index 3e83769615d1..8f1651367310 100644
--- a/drivers/dma/hisi_dma.c
+++ b/drivers/dma/hisi_dma.c
@@ -185,7 +185,8 @@ static void hisi_dma_reset_qp_point(struct hisi_dma_dev *hdma_dev, u32 index)
 	hisi_dma_chan_write(hdma_dev->base, HISI_DMA_CQ_HEAD_PTR, index, 0);
 }
 
-static void hisi_dma_reset_hw_chan(struct hisi_dma_chan *chan)
+static void hisi_dma_reset_or_disable_hw_chan(struct hisi_dma_chan *chan,
+					      bool disable)
 {
 	struct hisi_dma_dev *hdma_dev = chan->hdma_dev;
 	u32 index = chan->qp_num, tmp;
@@ -206,8 +207,11 @@ static void hisi_dma_reset_hw_chan(struct hisi_dma_chan *chan)
 	hisi_dma_do_reset(hdma_dev, index);
 	hisi_dma_reset_qp_point(hdma_dev, index);
 	hisi_dma_pause_dma(hdma_dev, index, false);
-	hisi_dma_enable_dma(hdma_dev, index, true);
-	hisi_dma_unmask_irq(hdma_dev, index);
+
+	if (!disable) {
+		hisi_dma_enable_dma(hdma_dev, index, true);
+		hisi_dma_unmask_irq(hdma_dev, index);
+	}
 
 	ret = readl_relaxed_poll_timeout(hdma_dev->base +
 		HISI_DMA_Q_FSM_STS + index * HISI_DMA_OFFSET, tmp,
@@ -223,7 +227,7 @@ static void hisi_dma_free_chan_resources(struct dma_chan *c)
 	struct hisi_dma_chan *chan = to_hisi_dma_chan(c);
 	struct hisi_dma_dev *hdma_dev = chan->hdma_dev;
 
-	hisi_dma_reset_hw_chan(chan);
+	hisi_dma_reset_or_disable_hw_chan(chan, false);
 	vchan_free_chan_resources(&chan->vc);
 
 	memset(chan->sq, 0, sizeof(struct hisi_dma_sqe) * hdma_dev->chan_depth);
@@ -272,7 +276,6 @@ static void hisi_dma_start_transfer(struct hisi_dma_chan *chan)
 
 	vd = vchan_next_desc(&chan->vc);
 	if (!vd) {
-		dev_err(&hdma_dev->pdev->dev, "no issued task!\n");
 		chan->desc = NULL;
 		return;
 	}
@@ -304,7 +307,7 @@ static void hisi_dma_issue_pending(struct dma_chan *c)
 
 	spin_lock_irqsave(&chan->vc.lock, flags);
 
-	if (vchan_issue_pending(&chan->vc))
+	if (vchan_issue_pending(&chan->vc) && !chan->desc)
 		hisi_dma_start_transfer(chan);
 
 	spin_unlock_irqrestore(&chan->vc.lock, flags);
@@ -399,7 +402,7 @@ static void hisi_dma_enable_qp(struct hisi_dma_dev *hdma_dev, u32 qp_index)
 
 static void hisi_dma_disable_qp(struct hisi_dma_dev *hdma_dev, u32 qp_index)
 {
-	hisi_dma_reset_hw_chan(&hdma_dev->chan[qp_index]);
+	hisi_dma_reset_or_disable_hw_chan(&hdma_dev->chan[qp_index], true);
 }
 
 static void hisi_dma_enable_qps(struct hisi_dma_dev *hdma_dev)
@@ -438,18 +441,15 @@ static irqreturn_t hisi_dma_irq(int irq, void *data)
 	desc = chan->desc;
 	cqe = chan->cq + chan->cq_head;
 	if (desc) {
+		chan->cq_head = (chan->cq_head + 1) % hdma_dev->chan_depth;
+		hisi_dma_chan_write(hdma_dev->base, HISI_DMA_CQ_HEAD_PTR,
+				    chan->qp_num, chan->cq_head);
 		if (FIELD_GET(STATUS_MASK, cqe->w0) == STATUS_SUCC) {
-			chan->cq_head = (chan->cq_head + 1) %
-					hdma_dev->chan_depth;
-			hisi_dma_chan_write(hdma_dev->base,
-					    HISI_DMA_CQ_HEAD_PTR, chan->qp_num,
-					    chan->cq_head);
 			vchan_cookie_complete(&desc->vd);
+			hisi_dma_start_transfer(chan);
 		} else {
 			dev_err(&hdma_dev->pdev->dev, "task error!\n");
 		}
-
-		chan->desc = NULL;
 	}
 
 	spin_unlock_irqrestore(&chan->vc.lock, flags);
diff --git a/drivers/dma/ioat/dma.c b/drivers/dma/ioat/dma.c
index 37ff4ec7db76..e2070df6cad2 100644
--- a/drivers/dma/ioat/dma.c
+++ b/drivers/dma/ioat/dma.c
@@ -656,7 +656,7 @@ static void __cleanup(struct ioatdma_chan *ioat_chan, dma_addr_t phys_complete)
 	if (active - i == 0) {
 		dev_dbg(to_dev(ioat_chan), "%s: cancel completion timeout\n",
 			__func__);
-		mod_timer(&ioat_chan->timer, jiffies + IDLE_TIMEOUT);
+		mod_timer_pending(&ioat_chan->timer, jiffies + IDLE_TIMEOUT);
 	}
 
 	/* microsecond delay by sysfs variable  per pending descriptor */
@@ -682,7 +682,7 @@ static void ioat_cleanup(struct ioatdma_chan *ioat_chan)
 
 		if (chanerr &
 		    (IOAT_CHANERR_HANDLE_MASK | IOAT_CHANERR_RECOVER_MASK)) {
-			mod_timer(&ioat_chan->timer, jiffies + IDLE_TIMEOUT);
+			mod_timer_pending(&ioat_chan->timer, jiffies + IDLE_TIMEOUT);
 			ioat_eh(ioat_chan);
 		}
 	}
@@ -879,7 +879,7 @@ static void check_active(struct ioatdma_chan *ioat_chan)
 	}
 
 	if (test_and_clear_bit(IOAT_CHAN_ACTIVE, &ioat_chan->state))
-		mod_timer(&ioat_chan->timer, jiffies + IDLE_TIMEOUT);
+		mod_timer_pending(&ioat_chan->timer, jiffies + IDLE_TIMEOUT);
 }
 
 static void ioat_reboot_chan(struct ioatdma_chan *ioat_chan)
diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/efi/libstub/fdt.c
index 368cd60000ee..d48b0de05b62 100644
--- a/drivers/firmware/efi/libstub/fdt.c
+++ b/drivers/firmware/efi/libstub/fdt.c
@@ -281,14 +281,6 @@ efi_status_t allocate_new_fdt_and_exit_boot(void *handle,
 		goto fail;
 	}
 
-	/*
-	 * Now that we have done our final memory allocation (and free)
-	 * we can get the memory map key needed for exit_boot_services().
-	 */
-	status = efi_get_memory_map(&map);
-	if (status != EFI_SUCCESS)
-		goto fail_free_new_fdt;
-
 	status = update_fdt((void *)fdt_addr, fdt_size,
 			    (void *)*new_fdt_addr, MAX_FDT_SIZE, cmdline_ptr,
 			    initrd_addr, initrd_size);
diff --git a/drivers/firmware/google/gsmi.c b/drivers/firmware/google/gsmi.c
index 7d9367b22010..c1cd5ca875ca 100644
--- a/drivers/firmware/google/gsmi.c
+++ b/drivers/firmware/google/gsmi.c
@@ -680,6 +680,15 @@ static struct notifier_block gsmi_die_notifier = {
 static int gsmi_panic_callback(struct notifier_block *nb,
 			       unsigned long reason, void *arg)
 {
+
+	/*
+	 * Panic callbacks are executed with all other CPUs stopped,
+	 * so we must not attempt to spin waiting for gsmi_dev.lock
+	 * to be released.
+	 */
+	if (spin_is_locked(&gsmi_dev.lock))
+		return NOTIFY_DONE;
+
 	gsmi_shutdown_reason(GSMI_SHUTDOWN_PANIC);
 	return NOTIFY_DONE;
 }
diff --git a/drivers/fpga/dfl.c b/drivers/fpga/dfl.c
index b450870b75ed..eb8a6e329af9 100644
--- a/drivers/fpga/dfl.c
+++ b/drivers/fpga/dfl.c
@@ -1857,7 +1857,7 @@ long dfl_feature_ioctl_set_irq(struct platform_device *pdev,
 		return -EINVAL;
 
 	fds = memdup_user((void __user *)(arg + sizeof(hdr)),
-			  hdr.count * sizeof(s32));
+			  array_size(hdr.count, sizeof(s32)));
 	if (IS_ERR(fds))
 		return PTR_ERR(fds);
 
diff --git a/drivers/fsi/fsi-core.c b/drivers/fsi/fsi-core.c
index 59ddc9fd5bca..92e6eebd1851 100644
--- a/drivers/fsi/fsi-core.c
+++ b/drivers/fsi/fsi-core.c
@@ -1309,6 +1309,9 @@ int fsi_master_register(struct fsi_master *master)
 
 	mutex_init(&master->scan_lock);
 	master->idx = ida_simple_get(&master_ida, 0, INT_MAX, GFP_KERNEL);
+	if (master->idx < 0)
+		return master->idx;
+
 	dev_set_name(&master->dev, "fsi%d", master->idx);
 	master->dev.class = &fsi_master_class;
 
diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index ca868271f4c4..4e9b3a95fa7c 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -30,6 +30,7 @@ menuconfig DRM
 config DRM_MIPI_DBI
 	tristate
 	depends on DRM
+	select DRM_KMS_HELPER
 
 config DRM_MIPI_DSI
 	bool
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c
index df1f9b88a53f..98d3661336a4 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c
@@ -1671,10 +1671,12 @@ amdgpu_connector_add(struct amdgpu_device *adev,
 						   adev->mode_info.dither_property,
 						   AMDGPU_FMT_DITHER_DISABLE);
 
-			if (amdgpu_audio != 0)
+			if (amdgpu_audio != 0) {
 				drm_object_attach_property(&amdgpu_connector->base.base,
 							   adev->mode_info.audio_property,
 							   AMDGPU_AUDIO_AUTO);
+				amdgpu_connector->audio = AMDGPU_AUDIO_AUTO;
+			}
 
 			subpixel_order = SubPixelHorizontalRGB;
 			connector->interlace_allowed = true;
@@ -1796,6 +1798,7 @@ amdgpu_connector_add(struct amdgpu_device *adev,
 				drm_object_attach_property(&amdgpu_connector->base.base,
 							   adev->mode_info.audio_property,
 							   AMDGPU_AUDIO_AUTO);
+				amdgpu_connector->audio = AMDGPU_AUDIO_AUTO;
 			}
 			drm_object_attach_property(&amdgpu_connector->base.base,
 						   adev->mode_info.dither_property,
@@ -1849,6 +1852,7 @@ amdgpu_connector_add(struct amdgpu_device *adev,
 				drm_object_attach_property(&amdgpu_connector->base.base,
 							   adev->mode_info.audio_property,
 							   AMDGPU_AUDIO_AUTO);
+				amdgpu_connector->audio = AMDGPU_AUDIO_AUTO;
 			}
 			drm_object_attach_property(&amdgpu_connector->base.base,
 						   adev->mode_info.dither_property,
@@ -1899,6 +1903,7 @@ amdgpu_connector_add(struct amdgpu_device *adev,
 				drm_object_attach_property(&amdgpu_connector->base.base,
 							   adev->mode_info.audio_property,
 							   AMDGPU_AUDIO_AUTO);
+				amdgpu_connector->audio = AMDGPU_AUDIO_AUTO;
 			}
 			drm_object_attach_property(&amdgpu_connector->base.base,
 						   adev->mode_info.dither_property,
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 881045e600af..bde0496d2f15 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -2179,16 +2179,8 @@ static int amdgpu_device_ip_init(struct amdgpu_device *adev)
 		}
 		adev->ip_blocks[i].status.sw = true;
 
-		if (adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_COMMON) {
-			/* need to do common hw init early so everything is set up for gmc */
-			r = adev->ip_blocks[i].version->funcs->hw_init((void *)adev);
-			if (r) {
-				DRM_ERROR("hw_init %d failed %d\n", i, r);
-				goto init_failed;
-			}
-			adev->ip_blocks[i].status.hw = true;
-		} else if (adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_GMC) {
-			/* need to do gmc hw init early so we can allocate gpu mem */
+		/* need to do gmc hw init early so we can allocate gpu mem */
+		if (adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_GMC) {
 			/* Try to reserve bad pages early */
 			if (amdgpu_sriov_vf(adev))
 				amdgpu_virt_exchange_data(adev);
@@ -2770,8 +2762,8 @@ static int amdgpu_device_ip_reinit_early_sriov(struct amdgpu_device *adev)
 	int i, r;
 
 	static enum amd_ip_block_type ip_order[] = {
-		AMD_IP_BLOCK_TYPE_COMMON,
 		AMD_IP_BLOCK_TYPE_GMC,
+		AMD_IP_BLOCK_TYPE_COMMON,
 		AMD_IP_BLOCK_TYPE_PSP,
 		AMD_IP_BLOCK_TYPE_IH,
 	};
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
index 947f50e402ba..7cc7af2a6822 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
@@ -35,7 +35,6 @@
 #include <linux/pci.h>
 #include <linux/pm_runtime.h>
 #include <drm/drm_crtc_helper.h>
-#include <drm/drm_damage_helper.h>
 #include <drm/drm_edid.h>
 #include <drm/drm_gem_framebuffer_helper.h>
 #include <drm/drm_fb_helper.h>
@@ -499,7 +498,6 @@ bool amdgpu_display_ddc_probe(struct amdgpu_connector *amdgpu_connector,
 static const struct drm_framebuffer_funcs amdgpu_fb_funcs = {
 	.destroy = drm_gem_fb_destroy,
 	.create_handle = drm_gem_fb_create_handle,
-	.dirty = drm_atomic_helper_dirtyfb,
 };
 
 uint32_t amdgpu_display_supported_domains(struct amdgpu_device *adev,
diff --git a/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c b/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
index a1a8e026b9fa..1f2e2460e121 100644
--- a/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
@@ -1475,11 +1475,6 @@ static int sdma_v4_0_start(struct amdgpu_device *adev)
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
index abd649285a22..7212b9900e0a 100644
--- a/drivers/gpu/drm/amd/amdgpu/soc15.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc15.c
@@ -1332,6 +1332,25 @@ static int soc15_common_sw_fini(void *handle)
 	return 0;
 }
 
+static void soc15_doorbell_range_init(struct amdgpu_device *adev)
+{
+	int i;
+	struct amdgpu_ring *ring;
+
+	/* sdma/ih doorbell range are programed by hypervisor */
+	if (!amdgpu_sriov_vf(adev)) {
+		for (i = 0; i < adev->sdma.num_instances; i++) {
+			ring = &adev->sdma.instance[i].ring;
+			adev->nbio.funcs->sdma_doorbell_range(adev, i,
+				ring->use_doorbell, ring->doorbell_index,
+				adev->doorbell_index.sdma_doorbell_range);
+		}
+
+		adev->nbio.funcs->ih_doorbell_range(adev, adev->irq.ih.use_doorbell,
+						adev->irq.ih.doorbell_index);
+	}
+}
+
 static int soc15_common_hw_init(void *handle)
 {
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
@@ -1351,6 +1370,12 @@ static int soc15_common_hw_init(void *handle)
 
 	/* enable the doorbell aperture */
 	soc15_enable_doorbell_aperture(adev, true);
+	/* HW doorbell routing policy: doorbell writing not
+	 * in SDMA/IH/MM/ACV range will be routed to CP. So
+	 * we need to init SDMA/IH/MM/ACV doorbell range prior
+	 * to CP ip block init and ring test.
+	 */
+	soc15_doorbell_range_init(adev);
 
 	return 0;
 }
diff --git a/drivers/gpu/drm/amd/display/dc/calcs/bw_fixed.c b/drivers/gpu/drm/amd/display/dc/calcs/bw_fixed.c
index 6ca288fb5fb9..2d46bc527b21 100644
--- a/drivers/gpu/drm/amd/display/dc/calcs/bw_fixed.c
+++ b/drivers/gpu/drm/amd/display/dc/calcs/bw_fixed.c
@@ -26,12 +26,12 @@
 #include "bw_fixed.h"
 
 
-#define MIN_I64 \
-	(int64_t)(-(1LL << 63))
-
 #define MAX_I64 \
 	(int64_t)((1ULL << 63) - 1)
 
+#define MIN_I64 \
+	(-MAX_I64 - 1)
+
 #define FRACTIONAL_PART_MASK \
 	((1ULL << BW_FIXED_BITS_PER_FRACTIONAL_PART) - 1)
 
diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 93f5229c303e..99887bcfada0 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -2202,11 +2202,8 @@ static void copy_stream_update_to_stream(struct dc *dc,
 	if (update->abm_level)
 		stream->abm_level = *update->abm_level;
 
-	if (update->periodic_interrupt0)
-		stream->periodic_interrupt0 = *update->periodic_interrupt0;
-
-	if (update->periodic_interrupt1)
-		stream->periodic_interrupt1 = *update->periodic_interrupt1;
+	if (update->periodic_interrupt)
+		stream->periodic_interrupt = *update->periodic_interrupt;
 
 	if (update->gamut_remap)
 		stream->gamut_remap_matrix = *update->gamut_remap;
@@ -2288,13 +2285,8 @@ static void commit_planes_do_stream_update(struct dc *dc,
 
 		if (!pipe_ctx->top_pipe &&  !pipe_ctx->prev_odm_pipe && pipe_ctx->stream == stream) {
 
-			if (stream_update->periodic_interrupt0 &&
-					dc->hwss.setup_periodic_interrupt)
-				dc->hwss.setup_periodic_interrupt(dc, pipe_ctx, VLINE0);
-
-			if (stream_update->periodic_interrupt1 &&
-					dc->hwss.setup_periodic_interrupt)
-				dc->hwss.setup_periodic_interrupt(dc, pipe_ctx, VLINE1);
+			if (stream_update->periodic_interrupt && dc->hwss.setup_periodic_interrupt)
+				dc->hwss.setup_periodic_interrupt(dc, pipe_ctx);
 
 			if ((stream_update->hdr_static_metadata && !stream->use_dynamic_meta) ||
 					stream_update->vrr_infopacket ||
diff --git a/drivers/gpu/drm/amd/display/dc/dc_stream.h b/drivers/gpu/drm/amd/display/dc/dc_stream.h
index 205bedd1b196..0487c1b8957c 100644
--- a/drivers/gpu/drm/amd/display/dc/dc_stream.h
+++ b/drivers/gpu/drm/amd/display/dc/dc_stream.h
@@ -179,8 +179,7 @@ struct dc_stream_state {
 	/* DMCU info */
 	unsigned int abm_level;
 
-	struct periodic_interrupt_config periodic_interrupt0;
-	struct periodic_interrupt_config periodic_interrupt1;
+	struct periodic_interrupt_config periodic_interrupt;
 
 	/* from core_stream struct */
 	struct dc_context *ctx;
@@ -244,8 +243,7 @@ struct dc_stream_update {
 	struct dc_info_packet *hdr_static_metadata;
 	unsigned int *abm_level;
 
-	struct periodic_interrupt_config *periodic_interrupt0;
-	struct periodic_interrupt_config *periodic_interrupt1;
+	struct periodic_interrupt_config *periodic_interrupt;
 
 	struct dc_info_packet *vrr_infopacket;
 	struct dc_info_packet *vsc_infopacket;
diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
index 31a13daf4289..71a85c5306ed 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
@@ -3611,7 +3611,7 @@ void dcn10_calc_vupdate_position(
 {
 	const struct dc_crtc_timing *dc_crtc_timing = &pipe_ctx->stream->timing;
 	int vline_int_offset_from_vupdate =
-			pipe_ctx->stream->periodic_interrupt0.lines_offset;
+			pipe_ctx->stream->periodic_interrupt.lines_offset;
 	int vupdate_offset_from_vsync = dc->hwss.get_vupdate_offset_from_vsync(pipe_ctx);
 	int start_position;
 
@@ -3636,18 +3636,10 @@ void dcn10_calc_vupdate_position(
 static void dcn10_cal_vline_position(
 		struct dc *dc,
 		struct pipe_ctx *pipe_ctx,
-		enum vline_select vline,
 		uint32_t *start_line,
 		uint32_t *end_line)
 {
-	enum vertical_interrupt_ref_point ref_point = INVALID_POINT;
-
-	if (vline == VLINE0)
-		ref_point = pipe_ctx->stream->periodic_interrupt0.ref_point;
-	else if (vline == VLINE1)
-		ref_point = pipe_ctx->stream->periodic_interrupt1.ref_point;
-
-	switch (ref_point) {
+	switch (pipe_ctx->stream->periodic_interrupt.ref_point) {
 	case START_V_UPDATE:
 		dcn10_calc_vupdate_position(
 				dc,
@@ -3656,7 +3648,9 @@ static void dcn10_cal_vline_position(
 				end_line);
 		break;
 	case START_V_SYNC:
-		// Suppose to do nothing because vsync is 0;
+		// vsync is line 0 so start_line is just the requested line offset
+		*start_line = pipe_ctx->stream->periodic_interrupt.lines_offset;
+		*end_line = *start_line + 2;
 		break;
 	default:
 		ASSERT(0);
@@ -3666,24 +3660,15 @@ static void dcn10_cal_vline_position(
 
 void dcn10_setup_periodic_interrupt(
 		struct dc *dc,
-		struct pipe_ctx *pipe_ctx,
-		enum vline_select vline)
+		struct pipe_ctx *pipe_ctx)
 {
 	struct timing_generator *tg = pipe_ctx->stream_res.tg;
+	uint32_t start_line = 0;
+	uint32_t end_line = 0;
 
-	if (vline == VLINE0) {
-		uint32_t start_line = 0;
-		uint32_t end_line = 0;
+	dcn10_cal_vline_position(dc, pipe_ctx, &start_line, &end_line);
 
-		dcn10_cal_vline_position(dc, pipe_ctx, vline, &start_line, &end_line);
-
-		tg->funcs->setup_vertical_interrupt0(tg, start_line, end_line);
-
-	} else if (vline == VLINE1) {
-		pipe_ctx->stream_res.tg->funcs->setup_vertical_interrupt1(
-				tg,
-				pipe_ctx->stream->periodic_interrupt1.lines_offset);
-	}
+	tg->funcs->setup_vertical_interrupt0(tg, start_line, end_line);
 }
 
 void dcn10_setup_vupdate_interrupt(struct dc *dc, struct pipe_ctx *pipe_ctx)
diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.h b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.h
index e5691e499023..81b5057d5ff1 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.h
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.h
@@ -174,8 +174,7 @@ void dcn10_set_cursor_attribute(struct pipe_ctx *pipe_ctx);
 void dcn10_set_cursor_sdr_white_level(struct pipe_ctx *pipe_ctx);
 void dcn10_setup_periodic_interrupt(
 		struct dc *dc,
-		struct pipe_ctx *pipe_ctx,
-		enum vline_select vline);
+		struct pipe_ctx *pipe_ctx);
 enum dc_status dcn10_set_clock(struct dc *dc,
 		enum dc_clock_type clock_type,
 		uint32_t clk_khz,
diff --git a/drivers/gpu/drm/amd/display/dc/inc/hw_sequencer.h b/drivers/gpu/drm/amd/display/dc/inc/hw_sequencer.h
index 64c1be818b0e..3165a66c5362 100644
--- a/drivers/gpu/drm/amd/display/dc/inc/hw_sequencer.h
+++ b/drivers/gpu/drm/amd/display/dc/inc/hw_sequencer.h
@@ -32,11 +32,6 @@
 #include "inc/hw/link_encoder.h"
 #include "core_status.h"
 
-enum vline_select {
-	VLINE0,
-	VLINE1
-};
-
 struct pipe_ctx;
 struct dc_state;
 struct dc_stream_status;
@@ -112,8 +107,7 @@ struct hw_sequencer_funcs {
 			int group_index, int group_size,
 			struct pipe_ctx *grouped_pipes[]);
 	void (*setup_periodic_interrupt)(struct dc *dc,
-			struct pipe_ctx *pipe_ctx,
-			enum vline_select vline);
+			struct pipe_ctx *pipe_ctx);
 	void (*set_drr)(struct pipe_ctx **pipe_ctx, int num_pipes,
 			unsigned int vmin, unsigned int vmax,
 			unsigned int vmid, unsigned int vmid_frame_number);
diff --git a/drivers/gpu/drm/bridge/adv7511/adv7511.h b/drivers/gpu/drm/bridge/adv7511/adv7511.h
index a0f6ee15c248..711061bf3eb7 100644
--- a/drivers/gpu/drm/bridge/adv7511/adv7511.h
+++ b/drivers/gpu/drm/bridge/adv7511/adv7511.h
@@ -386,10 +386,7 @@ void adv7511_cec_irq_process(struct adv7511 *adv7511, unsigned int irq1);
 #else
 static inline int adv7511_cec_init(struct device *dev, struct adv7511 *adv7511)
 {
-	unsigned int offset = adv7511->type == ADV7533 ?
-						ADV7533_REG_CEC_OFFSET : 0;
-
-	regmap_write(adv7511->regmap, ADV7511_REG_CEC_CTRL + offset,
+	regmap_write(adv7511->regmap, ADV7511_REG_CEC_CTRL,
 		     ADV7511_CEC_CTRL_POWER_DOWN);
 	return 0;
 }
diff --git a/drivers/gpu/drm/bridge/adv7511/adv7511_cec.c b/drivers/gpu/drm/bridge/adv7511/adv7511_cec.c
index a20a45c0b353..ddd1305b82b2 100644
--- a/drivers/gpu/drm/bridge/adv7511/adv7511_cec.c
+++ b/drivers/gpu/drm/bridge/adv7511/adv7511_cec.c
@@ -316,7 +316,7 @@ int adv7511_cec_init(struct device *dev, struct adv7511 *adv7511)
 		goto err_cec_alloc;
 	}
 
-	regmap_write(adv7511->regmap, ADV7511_REG_CEC_CTRL + offset, 0);
+	regmap_write(adv7511->regmap, ADV7511_REG_CEC_CTRL, 0);
 	/* cec soft reset */
 	regmap_write(adv7511->regmap_cec,
 		     ADV7511_REG_CEC_SOFT_RESET + offset, 0x01);
@@ -343,7 +343,7 @@ int adv7511_cec_init(struct device *dev, struct adv7511 *adv7511)
 	dev_info(dev, "Initializing CEC failed with error %d, disabling CEC\n",
 		 ret);
 err_cec_parse_dt:
-	regmap_write(adv7511->regmap, ADV7511_REG_CEC_CTRL + offset,
+	regmap_write(adv7511->regmap, ADV7511_REG_CEC_CTRL,
 		     ADV7511_CEC_CTRL_POWER_DOWN);
 	return ret == -EPROBE_DEFER ? ret : 0;
 }
diff --git a/drivers/gpu/drm/bridge/lontium-lt9611.c b/drivers/gpu/drm/bridge/lontium-lt9611.c
index 29b1ce2140ab..1dcc28a4d853 100644
--- a/drivers/gpu/drm/bridge/lontium-lt9611.c
+++ b/drivers/gpu/drm/bridge/lontium-lt9611.c
@@ -816,13 +816,14 @@ static int lt9611_connector_init(struct drm_bridge *bridge, struct lt9611 *lt961
 
 	drm_connector_helper_add(&lt9611->connector,
 				 &lt9611_bridge_connector_helper_funcs);
-	drm_connector_attach_encoder(&lt9611->connector, bridge->encoder);
 
 	if (!bridge->encoder) {
 		DRM_ERROR("Parent encoder object not found");
 		return -ENODEV;
 	}
 
+	drm_connector_attach_encoder(&lt9611->connector, bridge->encoder);
+
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c b/drivers/gpu/drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c
index cce98bf2a4e7..72248a565579 100644
--- a/drivers/gpu/drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c
+++ b/drivers/gpu/drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c
@@ -296,7 +296,9 @@ static void ge_b850v3_lvds_remove(void)
 	 * This check is to avoid both the drivers
 	 * removing the bridge in their remove() function
 	 */
-	if (!ge_b850v3_lvds_ptr)
+	if (!ge_b850v3_lvds_ptr ||
+	    !ge_b850v3_lvds_ptr->stdp2690_i2c ||
+		!ge_b850v3_lvds_ptr->stdp4028_i2c)
 		goto out;
 
 	drm_bridge_remove(&ge_b850v3_lvds_ptr->bridge);
diff --git a/drivers/gpu/drm/bridge/parade-ps8640.c b/drivers/gpu/drm/bridge/parade-ps8640.c
index 7bd0affa057a..924851010400 100644
--- a/drivers/gpu/drm/bridge/parade-ps8640.c
+++ b/drivers/gpu/drm/bridge/parade-ps8640.c
@@ -333,8 +333,8 @@ static int ps8640_probe(struct i2c_client *client)
 	if (IS_ERR(ps_bridge->panel_bridge))
 		return PTR_ERR(ps_bridge->panel_bridge);
 
-	ps_bridge->supplies[0].supply = "vdd33";
-	ps_bridge->supplies[1].supply = "vdd12";
+	ps_bridge->supplies[0].supply = "vdd12";
+	ps_bridge->supplies[1].supply = "vdd33";
 	ret = devm_regulator_bulk_get(dev, ARRAY_SIZE(ps_bridge->supplies),
 				      ps_bridge->supplies);
 	if (ret)
diff --git a/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c b/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
index b10228b9e3a9..356c7d0bd035 100644
--- a/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
+++ b/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
@@ -2984,6 +2984,7 @@ static irqreturn_t dw_hdmi_irq(int irq, void *dev_id)
 {
 	struct dw_hdmi *hdmi = dev_id;
 	u8 intr_stat, phy_int_pol, phy_pol_mask, phy_stat;
+	enum drm_connector_status status = connector_status_unknown;
 
 	intr_stat = hdmi_readb(hdmi, HDMI_IH_PHY_STAT0);
 	phy_int_pol = hdmi_readb(hdmi, HDMI_PHY_POL0);
@@ -3022,13 +3023,15 @@ static irqreturn_t dw_hdmi_irq(int irq, void *dev_id)
 			cec_notifier_phys_addr_invalidate(hdmi->cec_notifier);
 			mutex_unlock(&hdmi->cec_notifier_mutex);
 		}
-	}
 
-	if (intr_stat & HDMI_IH_PHY_STAT0_HPD) {
-		enum drm_connector_status status = phy_int_pol & HDMI_PHY_HPD
-						 ? connector_status_connected
-						 : connector_status_disconnected;
+		if (phy_stat & HDMI_PHY_HPD)
+			status = connector_status_connected;
+
+		if (!(phy_stat & (HDMI_PHY_HPD | HDMI_PHY_RX_SENSE)))
+			status = connector_status_disconnected;
+	}
 
+	if (status != connector_status_unknown) {
 		dev_dbg(hdmi->dev, "EVENT=%s\n",
 			status == connector_status_connected ?
 			"plugin" : "plugout");
diff --git a/drivers/gpu/drm/drm_bridge.c b/drivers/gpu/drm/drm_bridge.c
index 044acd07c153..d799ec14fd7f 100644
--- a/drivers/gpu/drm/drm_bridge.c
+++ b/drivers/gpu/drm/drm_bridge.c
@@ -753,8 +753,8 @@ static int select_bus_fmt_recursive(struct drm_bridge *first_bridge,
 				    struct drm_connector_state *conn_state,
 				    u32 out_bus_fmt)
 {
+	unsigned int i, num_in_bus_fmts = 0;
 	struct drm_bridge_state *cur_state;
-	unsigned int num_in_bus_fmts, i;
 	struct drm_bridge *prev_bridge;
 	u32 *in_bus_fmts;
 	int ret;
@@ -875,7 +875,7 @@ drm_atomic_bridge_chain_select_bus_fmts(struct drm_bridge *bridge,
 	struct drm_connector *conn = conn_state->connector;
 	struct drm_encoder *encoder = bridge->encoder;
 	struct drm_bridge_state *last_bridge_state;
-	unsigned int i, num_out_bus_fmts;
+	unsigned int i, num_out_bus_fmts = 0;
 	struct drm_bridge *last_bridge;
 	u32 *out_bus_fmts;
 	int ret = 0;
diff --git a/drivers/gpu/drm/drm_dp_helper.c b/drivers/gpu/drm/drm_dp_helper.c
index 3c55753bab16..6ba16db77500 100644
--- a/drivers/gpu/drm/drm_dp_helper.c
+++ b/drivers/gpu/drm/drm_dp_helper.c
@@ -2172,17 +2172,8 @@ int drm_dp_set_phy_test_pattern(struct drm_dp_aux *aux,
 				struct drm_dp_phy_test_params *data, u8 dp_rev)
 {
 	int err, i;
-	u8 link_config[2];
 	u8 test_pattern;
 
-	link_config[0] = drm_dp_link_rate_to_bw_code(data->link_rate);
-	link_config[1] = data->num_lanes;
-	if (data->enhanced_frame_cap)
-		link_config[1] |= DP_LANE_COUNT_ENHANCED_FRAME_EN;
-	err = drm_dp_dpcd_write(aux, DP_LINK_BW_SET, link_config, 2);
-	if (err < 0)
-		return err;
-
 	test_pattern = data->phy_pattern;
 	if (dp_rev < 0x12) {
 		test_pattern = (test_pattern << 2) &
diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c b/drivers/gpu/drm/drm_dp_mst_topology.c
index ab423b0413ee..4272cd3622f8 100644
--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -4856,14 +4856,14 @@ void drm_dp_mst_dump_topology(struct seq_file *m,
 		seq_printf(m, "dpcd: %*ph\n", DP_RECEIVER_CAP_SIZE, buf);
 
 		ret = drm_dp_dpcd_read(mgr->aux, DP_FAUX_CAP, buf, 2);
-		if (ret) {
+		if (ret != 2) {
 			seq_printf(m, "faux/mst read failed\n");
 			goto out;
 		}
 		seq_printf(m, "faux/mst: %*ph\n", 2, buf);
 
 		ret = drm_dp_dpcd_read(mgr->aux, DP_MSTM_CTRL, buf, 1);
-		if (ret) {
+		if (ret != 1) {
 			seq_printf(m, "mst ctrl read failed\n");
 			goto out;
 		}
@@ -4871,7 +4871,7 @@ void drm_dp_mst_dump_topology(struct seq_file *m,
 
 		/* dump the standard OUI branch header */
 		ret = drm_dp_dpcd_read(mgr->aux, DP_BRANCH_OUI, buf, DP_BRANCH_OUI_HEADER_SIZE);
-		if (ret) {
+		if (ret != DP_BRANCH_OUI_HEADER_SIZE) {
 			seq_printf(m, "branch oui read failed\n");
 			goto out;
 		}
diff --git a/drivers/gpu/drm/drm_ioctl.c b/drivers/gpu/drm/drm_ioctl.c
index 4606cc938b36..c160a45a4274 100644
--- a/drivers/gpu/drm/drm_ioctl.c
+++ b/drivers/gpu/drm/drm_ioctl.c
@@ -473,7 +473,13 @@ EXPORT_SYMBOL(drm_invalid_op);
  */
 static int drm_copy_field(char __user *buf, size_t *buf_len, const char *value)
 {
-	int len;
+	size_t len;
+
+	/* don't attempt to copy a NULL pointer */
+	if (WARN_ONCE(!value, "BUG: the value to copy was not set!")) {
+		*buf_len = 0;
+		return 0;
+	}
 
 	/* don't overflow userbuf */
 	len = strlen(value);
diff --git a/drivers/gpu/drm/drm_mipi_dsi.c b/drivers/gpu/drm/drm_mipi_dsi.c
index 5dd475e82995..2c43d54766f3 100644
--- a/drivers/gpu/drm/drm_mipi_dsi.c
+++ b/drivers/gpu/drm/drm_mipi_dsi.c
@@ -300,6 +300,7 @@ static int mipi_dsi_remove_device_fn(struct device *dev, void *priv)
 {
 	struct mipi_dsi_device *dsi = to_mipi_dsi_device(dev);
 
+	mipi_dsi_detach(dsi);
 	mipi_dsi_device_unregister(dsi);
 
 	return 0;
diff --git a/drivers/gpu/drm/drm_panel_orientation_quirks.c b/drivers/gpu/drm/drm_panel_orientation_quirks.c
index f5ab891731d0..083273736c83 100644
--- a/drivers/gpu/drm/drm_panel_orientation_quirks.c
+++ b/drivers/gpu/drm/drm_panel_orientation_quirks.c
@@ -128,6 +128,12 @@ static const struct dmi_system_id orientation_data[] = {
 		  DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "One S1003"),
 		},
 		.driver_data = (void *)&lcd800x1280_rightside_up,
+	}, {	/* Anbernic Win600 */
+		.matches = {
+		  DMI_EXACT_MATCH(DMI_BOARD_VENDOR, "Anbernic"),
+		  DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Win600"),
+		},
+		.driver_data = (void *)&lcd720x1280_rightside_up,
 	}, {	/* Asus T100HA */
 		.matches = {
 		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
index 2f2dc029668b..1b5e8d3e45a9 100644
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -5145,10 +5145,14 @@ skl_compute_wm_params(const struct intel_crtc_state *crtc_state,
 	wp->y_tiled = modifier == I915_FORMAT_MOD_Y_TILED ||
 		      modifier == I915_FORMAT_MOD_Yf_TILED ||
 		      modifier == I915_FORMAT_MOD_Y_TILED_CCS ||
-		      modifier == I915_FORMAT_MOD_Yf_TILED_CCS;
+		      modifier == I915_FORMAT_MOD_Yf_TILED_CCS ||
+		      modifier == I915_FORMAT_MOD_Y_TILED_GEN12_RC_CCS ||
+		      modifier == I915_FORMAT_MOD_Y_TILED_GEN12_MC_CCS;
 	wp->x_tiled = modifier == I915_FORMAT_MOD_X_TILED;
 	wp->rc_surface = modifier == I915_FORMAT_MOD_Y_TILED_CCS ||
-			 modifier == I915_FORMAT_MOD_Yf_TILED_CCS;
+			 modifier == I915_FORMAT_MOD_Yf_TILED_CCS ||
+			 modifier == I915_FORMAT_MOD_Y_TILED_GEN12_RC_CCS ||
+			 modifier == I915_FORMAT_MOD_Y_TILED_GEN12_MC_CCS;
 	wp->is_planar = intel_format_info_is_yuv_semiplanar(format, modifier);
 
 	wp->width = width;
diff --git a/drivers/gpu/drm/meson/meson_drv.c b/drivers/gpu/drm/meson/meson_drv.c
index 2d022f3fb437..b0bfe85f5f6a 100644
--- a/drivers/gpu/drm/meson/meson_drv.c
+++ b/drivers/gpu/drm/meson/meson_drv.c
@@ -528,6 +528,13 @@ static int meson_drv_probe(struct platform_device *pdev)
 	return 0;
 };
 
+static int meson_drv_remove(struct platform_device *pdev)
+{
+	component_master_del(&pdev->dev, &meson_drv_master_ops);
+
+	return 0;
+}
+
 static struct meson_drm_match_data meson_drm_gxbb_data = {
 	.compat = VPU_COMPATIBLE_GXBB,
 };
@@ -565,6 +572,7 @@ static const struct dev_pm_ops meson_drv_pm_ops = {
 
 static struct platform_driver meson_drm_platform_driver = {
 	.probe      = meson_drv_probe,
+	.remove     = meson_drv_remove,
 	.shutdown   = meson_drv_shutdown,
 	.driver     = {
 		.name	= "meson-drm",
diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c
index 7503f093f3b6..b7841f7fc10a 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c
@@ -675,12 +675,10 @@ static void _dpu_kms_hw_destroy(struct dpu_kms *dpu_kms)
 	_dpu_kms_mmu_destroy(dpu_kms);
 
 	if (dpu_kms->catalog) {
-		for (i = 0; i < dpu_kms->catalog->vbif_count; i++) {
-			u32 vbif_idx = dpu_kms->catalog->vbif[i].id;
-
-			if ((vbif_idx < VBIF_MAX) && dpu_kms->hw_vbif[vbif_idx]) {
-				dpu_hw_vbif_destroy(dpu_kms->hw_vbif[vbif_idx]);
-				dpu_kms->hw_vbif[vbif_idx] = NULL;
+		for (i = 0; i < ARRAY_SIZE(dpu_kms->hw_vbif); i++) {
+			if (dpu_kms->hw_vbif[i]) {
+				dpu_hw_vbif_destroy(dpu_kms->hw_vbif[i]);
+				dpu_kms->hw_vbif[i] = NULL;
 			}
 		}
 	}
@@ -987,7 +985,7 @@ static int dpu_kms_hw_init(struct msm_kms *kms)
 	for (i = 0; i < dpu_kms->catalog->vbif_count; i++) {
 		u32 vbif_idx = dpu_kms->catalog->vbif[i].id;
 
-		dpu_kms->hw_vbif[i] = dpu_hw_vbif_init(vbif_idx,
+		dpu_kms->hw_vbif[vbif_idx] = dpu_hw_vbif_init(vbif_idx,
 				dpu_kms->vbif[vbif_idx], dpu_kms->catalog);
 		if (IS_ERR_OR_NULL(dpu_kms->hw_vbif[vbif_idx])) {
 			rc = PTR_ERR(dpu_kms->hw_vbif[vbif_idx]);
diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_vbif.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_vbif.c
index 5e8c3f3e6625..fc86d34aec80 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_vbif.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_vbif.c
@@ -11,6 +11,14 @@
 #include "dpu_hw_vbif.h"
 #include "dpu_trace.h"
 
+static struct dpu_hw_vbif *dpu_get_vbif(struct dpu_kms *dpu_kms, enum dpu_vbif vbif_idx)
+{
+	if (vbif_idx < ARRAY_SIZE(dpu_kms->hw_vbif))
+		return dpu_kms->hw_vbif[vbif_idx];
+
+	return NULL;
+}
+
 /**
  * _dpu_vbif_wait_for_xin_halt - wait for the xin to halt
  * @vbif:	Pointer to hardware vbif driver
@@ -148,20 +156,15 @@ static u32 _dpu_vbif_get_ot_limit(struct dpu_hw_vbif *vbif,
 void dpu_vbif_set_ot_limit(struct dpu_kms *dpu_kms,
 		struct dpu_vbif_set_ot_params *params)
 {
-	struct dpu_hw_vbif *vbif = NULL;
+	struct dpu_hw_vbif *vbif;
 	struct dpu_hw_mdp *mdp;
 	bool forced_on = false;
 	u32 ot_lim;
-	int ret, i;
+	int ret;
 
 	mdp = dpu_kms->hw_mdp;
 
-	for (i = 0; i < ARRAY_SIZE(dpu_kms->hw_vbif); i++) {
-		if (dpu_kms->hw_vbif[i] &&
-				dpu_kms->hw_vbif[i]->idx == params->vbif_idx)
-			vbif = dpu_kms->hw_vbif[i];
-	}
-
+	vbif = dpu_get_vbif(dpu_kms, params->vbif_idx);
 	if (!vbif || !mdp) {
 		DPU_DEBUG("invalid arguments vbif %d mdp %d\n",
 				vbif != NULL, mdp != NULL);
@@ -204,7 +207,7 @@ void dpu_vbif_set_ot_limit(struct dpu_kms *dpu_kms,
 void dpu_vbif_set_qos_remap(struct dpu_kms *dpu_kms,
 		struct dpu_vbif_set_qos_params *params)
 {
-	struct dpu_hw_vbif *vbif = NULL;
+	struct dpu_hw_vbif *vbif;
 	struct dpu_hw_mdp *mdp;
 	bool forced_on = false;
 	const struct dpu_vbif_qos_tbl *qos_tbl;
@@ -216,13 +219,7 @@ void dpu_vbif_set_qos_remap(struct dpu_kms *dpu_kms,
 	}
 	mdp = dpu_kms->hw_mdp;
 
-	for (i = 0; i < ARRAY_SIZE(dpu_kms->hw_vbif); i++) {
-		if (dpu_kms->hw_vbif[i] &&
-				dpu_kms->hw_vbif[i]->idx == params->vbif_idx) {
-			vbif = dpu_kms->hw_vbif[i];
-			break;
-		}
-	}
+	vbif = dpu_get_vbif(dpu_kms, params->vbif_idx);
 
 	if (!vbif || !vbif->cap) {
 		DPU_ERROR("invalid vbif %d\n", params->vbif_idx);
diff --git a/drivers/gpu/drm/msm/dp/dp_catalog.c b/drivers/gpu/drm/msm/dp/dp_catalog.c
index 2da6982efdbf..613348b022fe 100644
--- a/drivers/gpu/drm/msm/dp/dp_catalog.c
+++ b/drivers/gpu/drm/msm/dp/dp_catalog.c
@@ -416,7 +416,7 @@ void dp_catalog_ctrl_config_msa(struct dp_catalog *dp_catalog,
 
 	if (rate == link_rate_hbr3)
 		pixel_div = 6;
-	else if (rate == 1620000 || rate == 270000)
+	else if (rate == 162000 || rate == 270000)
 		pixel_div = 2;
 	else if (rate == link_rate_hbr2)
 		pixel_div = 4;
diff --git a/drivers/gpu/drm/nouveau/nouveau_bo.c b/drivers/gpu/drm/nouveau/nouveau_bo.c
index b4946b595d86..b57dcad8865f 100644
--- a/drivers/gpu/drm/nouveau/nouveau_bo.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
@@ -279,8 +279,10 @@ nouveau_bo_alloc(struct nouveau_cli *cli, u64 *size, int *align, u32 domain,
 			break;
 	}
 
-	if (WARN_ON(pi < 0))
+	if (WARN_ON(pi < 0)) {
+		kfree(nvbo);
 		return ERR_PTR(-EINVAL);
+	}
 
 	/* Disable compression if suitable settings couldn't be found. */
 	if (nvbo->comp && !vmm->page[pi].comp) {
diff --git a/drivers/gpu/drm/nouveau/nouveau_connector.c b/drivers/gpu/drm/nouveau/nouveau_connector.c
index 4c992fd5bd68..9542fc63e796 100644
--- a/drivers/gpu/drm/nouveau/nouveau_connector.c
+++ b/drivers/gpu/drm/nouveau/nouveau_connector.c
@@ -500,7 +500,8 @@ nouveau_connector_set_encoder(struct drm_connector *connector,
 			connector->interlace_allowed =
 				nv_encoder->caps.dp_interlace;
 		else
-			connector->interlace_allowed = true;
+			connector->interlace_allowed =
+				drm->client.device.info.family < NV_DEVICE_INFO_V0_VOLTA;
 		connector->doublescan_allowed = true;
 	} else
 	if (nv_encoder->dcb->type == DCB_OUTPUT_LVDS ||
diff --git a/drivers/gpu/drm/nouveau/nouveau_prime.c b/drivers/gpu/drm/nouveau/nouveau_prime.c
index 5f5b87f99546..f08bda533bd9 100644
--- a/drivers/gpu/drm/nouveau/nouveau_prime.c
+++ b/drivers/gpu/drm/nouveau/nouveau_prime.c
@@ -89,7 +89,6 @@ struct drm_gem_object *nouveau_gem_prime_import_sg_table(struct drm_device *dev,
 	ret = nouveau_bo_init(nvbo, size, align, NOUVEAU_GEM_DOMAIN_GART,
 			      sg, robj);
 	if (ret) {
-		nouveau_bo_ref(NULL, &nvbo);
 		obj = ERR_PTR(ret);
 		goto unlock;
 	}
diff --git a/drivers/gpu/drm/omapdrm/dss/dss.c b/drivers/gpu/drm/omapdrm/dss/dss.c
index 6ccbc29c4ce4..d5b3123ed081 100644
--- a/drivers/gpu/drm/omapdrm/dss/dss.c
+++ b/drivers/gpu/drm/omapdrm/dss/dss.c
@@ -1173,6 +1173,7 @@ static void __dss_uninit_ports(struct dss_device *dss, unsigned int num_ports)
 		default:
 			break;
 		}
+		of_node_put(port);
 	}
 }
 
@@ -1205,11 +1206,13 @@ static int dss_init_ports(struct dss_device *dss)
 		default:
 			break;
 		}
+		of_node_put(port);
 	}
 
 	return 0;
 
 error:
+	of_node_put(port);
 	__dss_uninit_ports(dss, i);
 	return r;
 }
diff --git a/drivers/gpu/drm/pl111/pl111_versatile.c b/drivers/gpu/drm/pl111/pl111_versatile.c
index bdd883f4f0da..963a5d5e6987 100644
--- a/drivers/gpu/drm/pl111/pl111_versatile.c
+++ b/drivers/gpu/drm/pl111/pl111_versatile.c
@@ -402,6 +402,7 @@ static int pl111_vexpress_clcd_init(struct device *dev, struct device_node *np,
 		if (of_device_is_compatible(child, "arm,pl111")) {
 			has_coretile_clcd = true;
 			ct_clcd = child;
+			of_node_put(child);
 			break;
 		}
 		if (of_device_is_compatible(child, "arm,hdlcd")) {
diff --git a/drivers/gpu/drm/udl/udl_modeset.c b/drivers/gpu/drm/udl/udl_modeset.c
index edcfd8c120c4..209b5ceba3e0 100644
--- a/drivers/gpu/drm/udl/udl_modeset.c
+++ b/drivers/gpu/drm/udl/udl_modeset.c
@@ -400,9 +400,6 @@ udl_simple_display_pipe_enable(struct drm_simple_display_pipe *pipe,
 
 	udl_handle_damage(fb, 0, 0, fb->width, fb->height);
 
-	if (!crtc_state->mode_changed)
-		return;
-
 	/* enable display */
 	udl_crtc_write_mode_to_hw(crtc);
 }
diff --git a/drivers/gpu/drm/vc4/vc4_vec.c b/drivers/gpu/drm/vc4/vc4_vec.c
index bd5b8eb58b18..c6bd168a5898 100644
--- a/drivers/gpu/drm/vc4/vc4_vec.c
+++ b/drivers/gpu/drm/vc4/vc4_vec.c
@@ -257,7 +257,7 @@ static void vc4_vec_ntsc_j_mode_set(struct vc4_vec *vec)
 static const struct drm_display_mode ntsc_mode = {
 	DRM_MODE("720x480", DRM_MODE_TYPE_DRIVER, 13500,
 		 720, 720 + 14, 720 + 14 + 64, 720 + 14 + 64 + 60, 0,
-		 480, 480 + 3, 480 + 3 + 3, 480 + 3 + 3 + 16, 0,
+		 480, 480 + 7, 480 + 7 + 6, 525, 0,
 		 DRM_MODE_FLAG_INTERLACE)
 };
 
@@ -279,7 +279,7 @@ static void vc4_vec_pal_m_mode_set(struct vc4_vec *vec)
 static const struct drm_display_mode pal_mode = {
 	DRM_MODE("720x576", DRM_MODE_TYPE_DRIVER, 13500,
 		 720, 720 + 20, 720 + 20 + 64, 720 + 20 + 64 + 60, 0,
-		 576, 576 + 2, 576 + 2 + 3, 576 + 2 + 3 + 20, 0,
+		 576, 576 + 4, 576 + 4 + 6, 625, 0,
 		 DRM_MODE_FLAG_INTERLACE)
 };
 
diff --git a/drivers/gpu/drm/virtio/virtgpu_vq.c b/drivers/gpu/drm/virtio/virtgpu_vq.c
index 5e40fa0f5e8f..e98a29d243c0 100644
--- a/drivers/gpu/drm/virtio/virtgpu_vq.c
+++ b/drivers/gpu/drm/virtio/virtgpu_vq.c
@@ -601,7 +601,7 @@ void virtio_gpu_cmd_transfer_to_host_2d(struct virtio_gpu_device *vgdev,
 	bool use_dma_api = !virtio_has_dma_quirk(vgdev->vdev);
 	struct virtio_gpu_object_shmem *shmem = to_virtio_gpu_shmem(bo);
 
-	if (use_dma_api)
+	if (virtio_gpu_is_shmem(bo) && use_dma_api)
 		dma_sync_sgtable_for_device(vgdev->vdev->dev.parent,
 					    shmem->pages, DMA_TO_DEVICE);
 
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index d686917cc3b1..a78ce16d4782 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -1155,7 +1155,7 @@ static void mt_touch_report(struct hid_device *hid,
 	int contact_count = -1;
 
 	/* sticky fingers release in progress, abort */
-	if (test_and_set_bit(MT_IO_FLAGS_RUNNING, &td->mt_io_flags))
+	if (test_and_set_bit_lock(MT_IO_FLAGS_RUNNING, &td->mt_io_flags))
 		return;
 
 	scantime = *app->scantime;
@@ -1236,7 +1236,7 @@ static void mt_touch_report(struct hid_device *hid,
 			del_timer(&td->release_timer);
 	}
 
-	clear_bit(MT_IO_FLAGS_RUNNING, &td->mt_io_flags);
+	clear_bit_unlock(MT_IO_FLAGS_RUNNING, &td->mt_io_flags);
 }
 
 static int mt_touch_input_configured(struct hid_device *hdev,
@@ -1671,11 +1671,11 @@ static void mt_expired_timeout(struct timer_list *t)
 	 * An input report came in just before we release the sticky fingers,
 	 * it will take care of the sticky fingers.
 	 */
-	if (test_and_set_bit(MT_IO_FLAGS_RUNNING, &td->mt_io_flags))
+	if (test_and_set_bit_lock(MT_IO_FLAGS_RUNNING, &td->mt_io_flags))
 		return;
 	if (test_bit(MT_IO_FLAGS_PENDING_SLOTS, &td->mt_io_flags))
 		mt_release_contacts(hdev);
-	clear_bit(MT_IO_FLAGS_RUNNING, &td->mt_io_flags);
+	clear_bit_unlock(MT_IO_FLAGS_RUNNING, &td->mt_io_flags);
 }
 
 static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
diff --git a/drivers/hid/hid-roccat.c b/drivers/hid/hid-roccat.c
index 26373b82fe81..6da80e442fdd 100644
--- a/drivers/hid/hid-roccat.c
+++ b/drivers/hid/hid-roccat.c
@@ -257,6 +257,8 @@ int roccat_report_event(int minor, u8 const *data)
 	if (!new_value)
 		return -ENOMEM;
 
+	mutex_lock(&device->cbuf_lock);
+
 	report = &device->cbuf[device->cbuf_end];
 
 	/* passing NULL is safe */
@@ -276,6 +278,8 @@ int roccat_report_event(int minor, u8 const *data)
 			reader->cbuf_start = (reader->cbuf_start + 1) % ROCCAT_CBUF_SIZE;
 	}
 
+	mutex_unlock(&device->cbuf_lock);
+
 	wake_up_interruptible(&device->wait);
 	return 0;
 }
diff --git a/drivers/hsi/controllers/omap_ssi_core.c b/drivers/hsi/controllers/omap_ssi_core.c
index 44a3f5660c10..eb9820158318 100644
--- a/drivers/hsi/controllers/omap_ssi_core.c
+++ b/drivers/hsi/controllers/omap_ssi_core.c
@@ -524,6 +524,7 @@ static int ssi_probe(struct platform_device *pd)
 		if (!childpdev) {
 			err = -ENODEV;
 			dev_err(&pd->dev, "failed to create ssi controller port\n");
+			of_node_put(child);
 			goto out3;
 		}
 	}
diff --git a/drivers/hsi/controllers/omap_ssi_port.c b/drivers/hsi/controllers/omap_ssi_port.c
index a0cb5be246e1..b9495b720f1b 100644
--- a/drivers/hsi/controllers/omap_ssi_port.c
+++ b/drivers/hsi/controllers/omap_ssi_port.c
@@ -230,10 +230,10 @@ static int ssi_start_dma(struct hsi_msg *msg, int lch)
 	if (msg->ttype == HSI_MSG_READ) {
 		err = dma_map_sg(&ssi->device, msg->sgt.sgl, msg->sgt.nents,
 							DMA_FROM_DEVICE);
-		if (err < 0) {
+		if (!err) {
 			dev_dbg(&ssi->device, "DMA map SG failed !\n");
 			pm_runtime_put_autosuspend(omap_port->pdev);
-			return err;
+			return -EIO;
 		}
 		csdp = SSI_DST_BURST_4x32_BIT | SSI_DST_MEMORY_PORT |
 			SSI_SRC_SINGLE_ACCESS0 | SSI_SRC_PERIPHERAL_PORT |
@@ -247,10 +247,10 @@ static int ssi_start_dma(struct hsi_msg *msg, int lch)
 	} else {
 		err = dma_map_sg(&ssi->device, msg->sgt.sgl, msg->sgt.nents,
 							DMA_TO_DEVICE);
-		if (err < 0) {
+		if (!err) {
 			dev_dbg(&ssi->device, "DMA map SG failed !\n");
 			pm_runtime_put_autosuspend(omap_port->pdev);
-			return err;
+			return -EIO;
 		}
 		csdp = SSI_SRC_BURST_4x32_BIT | SSI_SRC_MEMORY_PORT |
 			SSI_DST_SINGLE_ACCESS0 | SSI_DST_PERIPHERAL_PORT |
diff --git a/drivers/hwmon/gsc-hwmon.c b/drivers/hwmon/gsc-hwmon.c
index 1fe37418ff46..f29ce49294da 100644
--- a/drivers/hwmon/gsc-hwmon.c
+++ b/drivers/hwmon/gsc-hwmon.c
@@ -267,6 +267,7 @@ gsc_hwmon_get_devtree_pdata(struct device *dev)
 	pdata->nchannels = nchannels;
 
 	/* fan controller base address */
+	of_node_get(dev->parent->of_node);
 	fan = of_find_compatible_node(dev->parent->of_node, NULL, "gw,gsc-fan");
 	if (fan && of_property_read_u32(fan, "reg", &pdata->fan_base)) {
 		dev_err(dev, "fan node without base\n");
diff --git a/drivers/i2c/busses/i2c-mlxbf.c b/drivers/i2c/busses/i2c-mlxbf.c
index bea82a787b4f..90c488a60693 100644
--- a/drivers/i2c/busses/i2c-mlxbf.c
+++ b/drivers/i2c/busses/i2c-mlxbf.c
@@ -312,6 +312,7 @@ static u64 mlxbf_i2c_corepll_frequency;
  * exact.
  */
 #define MLXBF_I2C_SMBUS_TIMEOUT   (300 * 1000) /* 300ms */
+#define MLXBF_I2C_SMBUS_LOCK_POLL_TIMEOUT (300 * 1000) /* 300ms */
 
 /* Encapsulates timing parameters. */
 struct mlxbf_i2c_timings {
@@ -520,6 +521,25 @@ static bool mlxbf_smbus_master_wait_for_idle(struct mlxbf_i2c_priv *priv)
 	return false;
 }
 
+/*
+ * wait for the lock to be released before acquiring it.
+ */
+static bool mlxbf_i2c_smbus_master_lock(struct mlxbf_i2c_priv *priv)
+{
+	if (mlxbf_smbus_poll(priv->smbus->io, MLXBF_I2C_SMBUS_MASTER_GW,
+			   MLXBF_I2C_MASTER_LOCK_BIT, true,
+			   MLXBF_I2C_SMBUS_LOCK_POLL_TIMEOUT))
+		return true;
+
+	return false;
+}
+
+static void mlxbf_i2c_smbus_master_unlock(struct mlxbf_i2c_priv *priv)
+{
+	/* Clear the gw to clear the lock */
+	writel(0, priv->smbus->io + MLXBF_I2C_SMBUS_MASTER_GW);
+}
+
 static bool mlxbf_i2c_smbus_transaction_success(u32 master_status,
 						u32 cause_status)
 {
@@ -711,10 +731,19 @@ mlxbf_i2c_smbus_start_transaction(struct mlxbf_i2c_priv *priv,
 	slave = request->slave & GENMASK(6, 0);
 	addr = slave << 1;
 
-	/* First of all, check whether the HW is idle. */
-	if (WARN_ON(!mlxbf_smbus_master_wait_for_idle(priv)))
+	/*
+	 * Try to acquire the smbus gw lock before any reads of the GW register since
+	 * a read sets the lock.
+	 */
+	if (WARN_ON(!mlxbf_i2c_smbus_master_lock(priv)))
 		return -EBUSY;
 
+	/* Check whether the HW is idle */
+	if (WARN_ON(!mlxbf_smbus_master_wait_for_idle(priv))) {
+		ret = -EBUSY;
+		goto out_unlock;
+	}
+
 	/* Set first byte. */
 	data_desc[data_idx++] = addr;
 
@@ -738,8 +767,10 @@ mlxbf_i2c_smbus_start_transaction(struct mlxbf_i2c_priv *priv,
 			write_en = 1;
 			write_len += operation->length;
 			if (data_idx + operation->length >
-					MLXBF_I2C_MASTER_DATA_DESC_SIZE)
-				return -ENOBUFS;
+					MLXBF_I2C_MASTER_DATA_DESC_SIZE) {
+				ret = -ENOBUFS;
+				goto out_unlock;
+			}
 			memcpy(data_desc + data_idx,
 			       operation->buffer, operation->length);
 			data_idx += operation->length;
@@ -771,7 +802,7 @@ mlxbf_i2c_smbus_start_transaction(struct mlxbf_i2c_priv *priv,
 		ret = mlxbf_i2c_smbus_enable(priv, slave, write_len, block_en,
 					 pec_en, 0);
 		if (ret)
-			return ret;
+			goto out_unlock;
 	}
 
 	if (read_en) {
@@ -798,6 +829,9 @@ mlxbf_i2c_smbus_start_transaction(struct mlxbf_i2c_priv *priv,
 			priv->smbus->io + MLXBF_I2C_SMBUS_MASTER_FSM);
 	}
 
+out_unlock:
+	mlxbf_i2c_smbus_master_unlock(priv);
+
 	return ret;
 }
 
diff --git a/drivers/iio/adc/ad7923.c b/drivers/iio/adc/ad7923.c
index 8c1e866f72e8..96eeda433ad6 100644
--- a/drivers/iio/adc/ad7923.c
+++ b/drivers/iio/adc/ad7923.c
@@ -93,6 +93,7 @@ enum ad7923_id {
 			.sign = 'u',					\
 			.realbits = (bits),				\
 			.storagebits = 16,				\
+			.shift = 12 - (bits),				\
 			.endianness = IIO_BE,				\
 		},							\
 	}
@@ -274,7 +275,8 @@ static int ad7923_read_raw(struct iio_dev *indio_dev,
 			return ret;
 
 		if (chan->address == EXTRACT(ret, 12, 4))
-			*val = EXTRACT(ret, 0, 12);
+			*val = EXTRACT(ret, chan->scan_type.shift,
+				       chan->scan_type.realbits);
 		else
 			return -EIO;
 
diff --git a/drivers/iio/adc/at91-sama5d2_adc.c b/drivers/iio/adc/at91-sama5d2_adc.c
index 4ede7e766765..250b78ee1625 100644
--- a/drivers/iio/adc/at91-sama5d2_adc.c
+++ b/drivers/iio/adc/at91-sama5d2_adc.c
@@ -74,7 +74,7 @@
 #define	AT91_SAMA5D2_MR_ANACH		BIT(23)
 /* Tracking Time */
 #define	AT91_SAMA5D2_MR_TRACKTIM(v)	((v) << 24)
-#define	AT91_SAMA5D2_MR_TRACKTIM_MAX	0xff
+#define	AT91_SAMA5D2_MR_TRACKTIM_MAX	0xf
 /* Transfer Time */
 #define	AT91_SAMA5D2_MR_TRANSFER(v)	((v) << 28)
 #define	AT91_SAMA5D2_MR_TRANSFER_MAX	0x3
@@ -1353,10 +1353,12 @@ static int at91_adc_read_info_raw(struct iio_dev *indio_dev,
 		ret = at91_adc_read_position(st, chan->channel,
 					     &tmp_val);
 		*val = tmp_val;
+		if (ret > 0)
+			ret = at91_adc_adjust_val_osr(st, val);
 		mutex_unlock(&st->lock);
 		iio_device_release_direct_mode(indio_dev);
 
-		return at91_adc_adjust_val_osr(st, val);
+		return ret;
 	}
 	if (chan->type == IIO_PRESSURE) {
 		ret = iio_device_claim_direct_mode(indio_dev);
@@ -1367,10 +1369,12 @@ static int at91_adc_read_info_raw(struct iio_dev *indio_dev,
 		ret = at91_adc_read_pressure(st, chan->channel,
 					     &tmp_val);
 		*val = tmp_val;
+		if (ret > 0)
+			ret = at91_adc_adjust_val_osr(st, val);
 		mutex_unlock(&st->lock);
 		iio_device_release_direct_mode(indio_dev);
 
-		return at91_adc_adjust_val_osr(st, val);
+		return ret;
 	}
 
 	/* in this case we have a voltage channel */
@@ -1461,16 +1465,20 @@ static int at91_adc_write_raw(struct iio_dev *indio_dev,
 		/* if no change, optimize out */
 		if (val == st->oversampling_ratio)
 			return 0;
+		mutex_lock(&st->lock);
 		st->oversampling_ratio = val;
 		/* update ratio */
 		at91_adc_config_emr(st);
+		mutex_unlock(&st->lock);
 		return 0;
 	case IIO_CHAN_INFO_SAMP_FREQ:
 		if (val < st->soc_info.min_sample_rate ||
 		    val > st->soc_info.max_sample_rate)
 			return -EINVAL;
 
+		mutex_lock(&st->lock);
 		at91_adc_setup_samp_freq(indio_dev, val);
+		mutex_unlock(&st->lock);
 		return 0;
 	default:
 		return -EINVAL;
@@ -1899,6 +1907,9 @@ static __maybe_unused int at91_adc_suspend(struct device *dev)
 	struct iio_dev *indio_dev = dev_get_drvdata(dev);
 	struct at91_adc_state *st = iio_priv(indio_dev);
 
+	if (iio_buffer_enabled(indio_dev))
+		at91_adc_buffer_postdisable(indio_dev);
+
 	/*
 	 * Do a sofware reset of the ADC before we go to suspend.
 	 * this will ensure that all pins are free from being muxed by the ADC
@@ -1942,14 +1953,11 @@ static __maybe_unused int at91_adc_resume(struct device *dev)
 	if (!iio_buffer_enabled(indio_dev))
 		return 0;
 
-	/* check if we are enabling triggered buffer or the touchscreen */
-	if (at91_adc_current_chan_is_touch(indio_dev))
-		return at91_adc_configure_touch(st, true);
-	else
-		return at91_adc_configure_trigger(st->trig, true);
+	ret = at91_adc_buffer_prepare(indio_dev);
+	if (ret)
+		goto vref_disable_resume;
 
-	/* not needed but more explicit */
-	return 0;
+	return at91_adc_configure_trigger(st->trig, true);
 
 vref_disable_resume:
 	regulator_disable(st->vref);
diff --git a/drivers/iio/adc/ltc2497.c b/drivers/iio/adc/ltc2497.c
index 1adddf5a88a9..61f373fab9a1 100644
--- a/drivers/iio/adc/ltc2497.c
+++ b/drivers/iio/adc/ltc2497.c
@@ -41,6 +41,19 @@ static int ltc2497_result_and_measure(struct ltc2497core_driverdata *ddata,
 		}
 
 		*val = (be32_to_cpu(st->buf) >> 14) - (1 << 17);
+
+		/*
+		 * The part started a new conversion at the end of the above i2c
+		 * transfer, so if the address didn't change since the last call
+		 * everything is fine and we can return early.
+		 * If not (which should only happen when some sort of bulk
+		 * conversion is implemented) we have to program the new
+		 * address. Note that this probably fails as the conversion that
+		 * was triggered above is like not complete yet and the two
+		 * operations have to be done in a single transfer.
+		 */
+		if (ddata->addr_prev == address)
+			return 0;
 	}
 
 	ret = i2c_smbus_write_byte(st->client,
diff --git a/drivers/iio/dac/ad5593r.c b/drivers/iio/dac/ad5593r.c
index 5b4df36fdc2a..4cc855c78121 100644
--- a/drivers/iio/dac/ad5593r.c
+++ b/drivers/iio/dac/ad5593r.c
@@ -13,6 +13,8 @@
 #include <linux/module.h>
 #include <linux/mod_devicetable.h>
 
+#include <asm/unaligned.h>
+
 #define AD5593R_MODE_CONF		(0 << 4)
 #define AD5593R_MODE_DAC_WRITE		(1 << 4)
 #define AD5593R_MODE_ADC_READBACK	(4 << 4)
@@ -20,6 +22,24 @@
 #define AD5593R_MODE_GPIO_READBACK	(6 << 4)
 #define AD5593R_MODE_REG_READBACK	(7 << 4)
 
+static int ad5593r_read_word(struct i2c_client *i2c, u8 reg, u16 *value)
+{
+	int ret;
+	u8 buf[2];
+
+	ret = i2c_smbus_write_byte(i2c, reg);
+	if (ret < 0)
+		return ret;
+
+	ret = i2c_master_recv(i2c, buf, sizeof(buf));
+	if (ret < 0)
+		return ret;
+
+	*value = get_unaligned_be16(buf);
+
+	return 0;
+}
+
 static int ad5593r_write_dac(struct ad5592r_state *st, unsigned chan, u16 value)
 {
 	struct i2c_client *i2c = to_i2c_client(st->dev);
@@ -38,13 +58,7 @@ static int ad5593r_read_adc(struct ad5592r_state *st, unsigned chan, u16 *value)
 	if (val < 0)
 		return (int) val;
 
-	val = i2c_smbus_read_word_swapped(i2c, AD5593R_MODE_ADC_READBACK);
-	if (val < 0)
-		return (int) val;
-
-	*value = (u16) val;
-
-	return 0;
+	return ad5593r_read_word(i2c, AD5593R_MODE_ADC_READBACK, value);
 }
 
 static int ad5593r_reg_write(struct ad5592r_state *st, u8 reg, u16 value)
@@ -58,25 +72,19 @@ static int ad5593r_reg_write(struct ad5592r_state *st, u8 reg, u16 value)
 static int ad5593r_reg_read(struct ad5592r_state *st, u8 reg, u16 *value)
 {
 	struct i2c_client *i2c = to_i2c_client(st->dev);
-	s32 val;
-
-	val = i2c_smbus_read_word_swapped(i2c, AD5593R_MODE_REG_READBACK | reg);
-	if (val < 0)
-		return (int) val;
 
-	*value = (u16) val;
-
-	return 0;
+	return ad5593r_read_word(i2c, AD5593R_MODE_REG_READBACK | reg, value);
 }
 
 static int ad5593r_gpio_read(struct ad5592r_state *st, u8 *value)
 {
 	struct i2c_client *i2c = to_i2c_client(st->dev);
-	s32 val;
+	u16 val;
+	int ret;
 
-	val = i2c_smbus_read_word_swapped(i2c, AD5593R_MODE_GPIO_READBACK);
-	if (val < 0)
-		return (int) val;
+	ret = ad5593r_read_word(i2c, AD5593R_MODE_GPIO_READBACK, &val);
+	if (ret)
+		return ret;
 
 	*value = (u8) val;
 
diff --git a/drivers/iio/inkern.c b/drivers/iio/inkern.c
index 8c3faa797284..c32b2577dd99 100644
--- a/drivers/iio/inkern.c
+++ b/drivers/iio/inkern.c
@@ -136,9 +136,10 @@ static int __of_iio_channel_get(struct iio_channel *channel,
 
 	idev = bus_find_device(&iio_bus_type, NULL, iiospec.np,
 			       iio_dev_node_match);
-	of_node_put(iiospec.np);
-	if (idev == NULL)
+	if (idev == NULL) {
+		of_node_put(iiospec.np);
 		return -EPROBE_DEFER;
+	}
 
 	indio_dev = dev_to_iio_dev(idev);
 	channel->indio_dev = indio_dev;
@@ -146,6 +147,7 @@ static int __of_iio_channel_get(struct iio_channel *channel,
 		index = indio_dev->info->of_xlate(indio_dev, &iiospec);
 	else
 		index = __of_iio_simple_xlate(indio_dev, &iiospec);
+	of_node_put(iiospec.np);
 	if (index < 0)
 		goto err_put;
 	channel->channel = &indio_dev->channels[index];
diff --git a/drivers/iio/pressure/dps310.c b/drivers/iio/pressure/dps310.c
index 0730380ceb69..cf8b92fae1b3 100644
--- a/drivers/iio/pressure/dps310.c
+++ b/drivers/iio/pressure/dps310.c
@@ -89,6 +89,7 @@ struct dps310_data {
 	s32 c00, c10, c20, c30, c01, c11, c21;
 	s32 pressure_raw;
 	s32 temp_raw;
+	bool timeout_recovery_failed;
 };
 
 static const struct iio_chan_spec dps310_channels[] = {
@@ -159,6 +160,102 @@ static int dps310_get_coefs(struct dps310_data *data)
 	return 0;
 }
 
+/*
+ * Some versions of the chip will read temperatures in the ~60C range when
+ * it's actually ~20C. This is the manufacturer recommended workaround
+ * to correct the issue. The registers used below are undocumented.
+ */
+static int dps310_temp_workaround(struct dps310_data *data)
+{
+	int rc;
+	int reg;
+
+	rc = regmap_read(data->regmap, 0x32, &reg);
+	if (rc)
+		return rc;
+
+	/*
+	 * If bit 1 is set then the device is okay, and the workaround does not
+	 * need to be applied
+	 */
+	if (reg & BIT(1))
+		return 0;
+
+	rc = regmap_write(data->regmap, 0x0e, 0xA5);
+	if (rc)
+		return rc;
+
+	rc = regmap_write(data->regmap, 0x0f, 0x96);
+	if (rc)
+		return rc;
+
+	rc = regmap_write(data->regmap, 0x62, 0x02);
+	if (rc)
+		return rc;
+
+	rc = regmap_write(data->regmap, 0x0e, 0x00);
+	if (rc)
+		return rc;
+
+	return regmap_write(data->regmap, 0x0f, 0x00);
+}
+
+static int dps310_startup(struct dps310_data *data)
+{
+	int rc;
+	int ready;
+
+	/*
+	 * Set up pressure sensor in single sample, one measurement per second
+	 * mode
+	 */
+	rc = regmap_write(data->regmap, DPS310_PRS_CFG, 0);
+	if (rc)
+		return rc;
+
+	/*
+	 * Set up external (MEMS) temperature sensor in single sample, one
+	 * measurement per second mode
+	 */
+	rc = regmap_write(data->regmap, DPS310_TMP_CFG, DPS310_TMP_EXT);
+	if (rc)
+		return rc;
+
+	/* Temp and pressure shifts are disabled when PRC <= 8 */
+	rc = regmap_write_bits(data->regmap, DPS310_CFG_REG,
+			       DPS310_PRS_SHIFT_EN | DPS310_TMP_SHIFT_EN, 0);
+	if (rc)
+		return rc;
+
+	/* MEAS_CFG doesn't update correctly unless first written with 0 */
+	rc = regmap_write_bits(data->regmap, DPS310_MEAS_CFG,
+			       DPS310_MEAS_CTRL_BITS, 0);
+	if (rc)
+		return rc;
+
+	/* Turn on temperature and pressure measurement in the background */
+	rc = regmap_write_bits(data->regmap, DPS310_MEAS_CFG,
+			       DPS310_MEAS_CTRL_BITS, DPS310_PRS_EN |
+			       DPS310_TEMP_EN | DPS310_BACKGROUND);
+	if (rc)
+		return rc;
+
+	/*
+	 * Calibration coefficients required for reporting temperature.
+	 * They are available 40ms after the device has started
+	 */
+	rc = regmap_read_poll_timeout(data->regmap, DPS310_MEAS_CFG, ready,
+				      ready & DPS310_COEF_RDY, 10000, 40000);
+	if (rc)
+		return rc;
+
+	rc = dps310_get_coefs(data);
+	if (rc)
+		return rc;
+
+	return dps310_temp_workaround(data);
+}
+
 static int dps310_get_pres_precision(struct dps310_data *data)
 {
 	int rc;
@@ -297,11 +394,69 @@ static int dps310_get_temp_k(struct dps310_data *data)
 	return scale_factors[ilog2(rc)];
 }
 
+static int dps310_reset_wait(struct dps310_data *data)
+{
+	int rc;
+
+	rc = regmap_write(data->regmap, DPS310_RESET, DPS310_RESET_MAGIC);
+	if (rc)
+		return rc;
+
+	/* Wait for device chip access: 2.5ms in specification */
+	usleep_range(2500, 12000);
+	return 0;
+}
+
+static int dps310_reset_reinit(struct dps310_data *data)
+{
+	int rc;
+
+	rc = dps310_reset_wait(data);
+	if (rc)
+		return rc;
+
+	return dps310_startup(data);
+}
+
+static int dps310_ready_status(struct dps310_data *data, int ready_bit, int timeout)
+{
+	int sleep = DPS310_POLL_SLEEP_US(timeout);
+	int ready;
+
+	return regmap_read_poll_timeout(data->regmap, DPS310_MEAS_CFG, ready, ready & ready_bit,
+					sleep, timeout);
+}
+
+static int dps310_ready(struct dps310_data *data, int ready_bit, int timeout)
+{
+	int rc;
+
+	rc = dps310_ready_status(data, ready_bit, timeout);
+	if (rc) {
+		if (rc == -ETIMEDOUT && !data->timeout_recovery_failed) {
+			/* Reset and reinitialize the chip. */
+			if (dps310_reset_reinit(data)) {
+				data->timeout_recovery_failed = true;
+			} else {
+				/* Try again to get sensor ready status. */
+				if (dps310_ready_status(data, ready_bit, timeout))
+					data->timeout_recovery_failed = true;
+				else
+					return 0;
+			}
+		}
+
+		return rc;
+	}
+
+	data->timeout_recovery_failed = false;
+	return 0;
+}
+
 static int dps310_read_pres_raw(struct dps310_data *data)
 {
 	int rc;
 	int rate;
-	int ready;
 	int timeout;
 	s32 raw;
 	u8 val[3];
@@ -313,9 +468,7 @@ static int dps310_read_pres_raw(struct dps310_data *data)
 	timeout = DPS310_POLL_TIMEOUT_US(rate);
 
 	/* Poll for sensor readiness; base the timeout upon the sample rate. */
-	rc = regmap_read_poll_timeout(data->regmap, DPS310_MEAS_CFG, ready,
-				      ready & DPS310_PRS_RDY,
-				      DPS310_POLL_SLEEP_US(timeout), timeout);
+	rc = dps310_ready(data, DPS310_PRS_RDY, timeout);
 	if (rc)
 		goto done;
 
@@ -352,7 +505,6 @@ static int dps310_read_temp_raw(struct dps310_data *data)
 {
 	int rc;
 	int rate;
-	int ready;
 	int timeout;
 
 	if (mutex_lock_interruptible(&data->lock))
@@ -362,10 +514,8 @@ static int dps310_read_temp_raw(struct dps310_data *data)
 	timeout = DPS310_POLL_TIMEOUT_US(rate);
 
 	/* Poll for sensor readiness; base the timeout upon the sample rate. */
-	rc = regmap_read_poll_timeout(data->regmap, DPS310_MEAS_CFG, ready,
-				      ready & DPS310_TMP_RDY,
-				      DPS310_POLL_SLEEP_US(timeout), timeout);
-	if (rc < 0)
+	rc = dps310_ready(data, DPS310_TMP_RDY, timeout);
+	if (rc)
 		goto done;
 
 	rc = dps310_read_temp_ready(data);
@@ -660,7 +810,7 @@ static void dps310_reset(void *action_data)
 {
 	struct dps310_data *data = action_data;
 
-	regmap_write(data->regmap, DPS310_RESET, DPS310_RESET_MAGIC);
+	dps310_reset_wait(data);
 }
 
 static const struct regmap_config dps310_regmap_config = {
@@ -677,52 +827,12 @@ static const struct iio_info dps310_info = {
 	.write_raw = dps310_write_raw,
 };
 
-/*
- * Some verions of chip will read temperatures in the ~60C range when
- * its actually ~20C. This is the manufacturer recommended workaround
- * to correct the issue. The registers used below are undocumented.
- */
-static int dps310_temp_workaround(struct dps310_data *data)
-{
-	int rc;
-	int reg;
-
-	rc = regmap_read(data->regmap, 0x32, &reg);
-	if (rc < 0)
-		return rc;
-
-	/*
-	 * If bit 1 is set then the device is okay, and the workaround does not
-	 * need to be applied
-	 */
-	if (reg & BIT(1))
-		return 0;
-
-	rc = regmap_write(data->regmap, 0x0e, 0xA5);
-	if (rc < 0)
-		return rc;
-
-	rc = regmap_write(data->regmap, 0x0f, 0x96);
-	if (rc < 0)
-		return rc;
-
-	rc = regmap_write(data->regmap, 0x62, 0x02);
-	if (rc < 0)
-		return rc;
-
-	rc = regmap_write(data->regmap, 0x0e, 0x00);
-	if (rc < 0)
-		return rc;
-
-	return regmap_write(data->regmap, 0x0f, 0x00);
-}
-
 static int dps310_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
 	struct dps310_data *data;
 	struct iio_dev *iio;
-	int rc, ready;
+	int rc;
 
 	iio = devm_iio_device_alloc(&client->dev,  sizeof(*data));
 	if (!iio)
@@ -747,54 +857,8 @@ static int dps310_probe(struct i2c_client *client,
 	if (rc)
 		return rc;
 
-	/*
-	 * Set up pressure sensor in single sample, one measurement per second
-	 * mode
-	 */
-	rc = regmap_write(data->regmap, DPS310_PRS_CFG, 0);
-
-	/*
-	 * Set up external (MEMS) temperature sensor in single sample, one
-	 * measurement per second mode
-	 */
-	rc = regmap_write(data->regmap, DPS310_TMP_CFG, DPS310_TMP_EXT);
-	if (rc < 0)
-		return rc;
-
-	/* Temp and pressure shifts are disabled when PRC <= 8 */
-	rc = regmap_write_bits(data->regmap, DPS310_CFG_REG,
-			       DPS310_PRS_SHIFT_EN | DPS310_TMP_SHIFT_EN, 0);
-	if (rc < 0)
-		return rc;
-
-	/* MEAS_CFG doesn't update correctly unless first written with 0 */
-	rc = regmap_write_bits(data->regmap, DPS310_MEAS_CFG,
-			       DPS310_MEAS_CTRL_BITS, 0);
-	if (rc < 0)
-		return rc;
-
-	/* Turn on temperature and pressure measurement in the background */
-	rc = regmap_write_bits(data->regmap, DPS310_MEAS_CFG,
-			       DPS310_MEAS_CTRL_BITS, DPS310_PRS_EN |
-			       DPS310_TEMP_EN | DPS310_BACKGROUND);
-	if (rc < 0)
-		return rc;
-
-	/*
-	 * Calibration coefficients required for reporting temperature.
-	 * They are available 40ms after the device has started
-	 */
-	rc = regmap_read_poll_timeout(data->regmap, DPS310_MEAS_CFG, ready,
-				      ready & DPS310_COEF_RDY, 10000, 40000);
-	if (rc < 0)
-		return rc;
-
-	rc = dps310_get_coefs(data);
-	if (rc < 0)
-		return rc;
-
-	rc = dps310_temp_workaround(data);
-	if (rc < 0)
+	rc = dps310_startup(data);
+	if (rc)
 		return rc;
 
 	rc = devm_iio_device_register(&client->dev, iio);
diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 3cc7a23fa69f..3133b6be6cab 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -1643,14 +1643,13 @@ static void cm_path_set_rec_type(struct ib_device *ib_device, u8 port_num,
 
 static void cm_format_path_lid_from_req(struct cm_req_msg *req_msg,
 					struct sa_path_rec *primary_path,
-					struct sa_path_rec *alt_path)
+					struct sa_path_rec *alt_path,
+					struct ib_wc *wc)
 {
 	u32 lid;
 
 	if (primary_path->rec_type != SA_PATH_REC_TYPE_OPA) {
-		sa_path_set_dlid(primary_path,
-				 IBA_GET(CM_REQ_PRIMARY_LOCAL_PORT_LID,
-					 req_msg));
+		sa_path_set_dlid(primary_path, wc->slid);
 		sa_path_set_slid(primary_path,
 				 IBA_GET(CM_REQ_PRIMARY_REMOTE_PORT_LID,
 					 req_msg));
@@ -1687,7 +1686,8 @@ static void cm_format_path_lid_from_req(struct cm_req_msg *req_msg,
 
 static void cm_format_paths_from_req(struct cm_req_msg *req_msg,
 				     struct sa_path_rec *primary_path,
-				     struct sa_path_rec *alt_path)
+				     struct sa_path_rec *alt_path,
+				     struct ib_wc *wc)
 {
 	primary_path->dgid =
 		*IBA_GET_MEM_PTR(CM_REQ_PRIMARY_LOCAL_PORT_GID, req_msg);
@@ -1745,7 +1745,7 @@ static void cm_format_paths_from_req(struct cm_req_msg *req_msg,
 		if (sa_path_is_roce(alt_path))
 			alt_path->roce.route_resolved = false;
 	}
-	cm_format_path_lid_from_req(req_msg, primary_path, alt_path);
+	cm_format_path_lid_from_req(req_msg, primary_path, alt_path, wc);
 }
 
 static u16 cm_get_bth_pkey(struct cm_work *work)
@@ -2163,7 +2163,7 @@ static int cm_req_handler(struct cm_work *work)
 	if (cm_req_has_alt_path(req_msg))
 		work->path[1].rec_type = work->path[0].rec_type;
 	cm_format_paths_from_req(req_msg, &work->path[0],
-				 &work->path[1]);
+				 &work->path[1], work->mad_recv_wc->wc);
 	if (cm_id_priv->av.ah_attr.type == RDMA_AH_ATTR_TYPE_ROCE)
 		sa_path_set_dmac(&work->path[0],
 				 cm_id_priv->av.ah_attr.roce.dmac);
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 466026825dd7..d7c90da9ce7f 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -749,6 +749,7 @@ static int ib_uverbs_reg_mr(struct uverbs_attr_bundle *attrs)
 	mr->uobject = uobj;
 	atomic_inc(&pd->usecnt);
 	mr->iova = cmd.hca_va;
+	mr->length = cmd.length;
 
 	rdma_restrack_new(&mr->res, RDMA_RESTRACK_MR);
 	rdma_restrack_set_name(&mr->res, NULL);
@@ -832,8 +833,10 @@ static int ib_uverbs_rereg_mr(struct uverbs_attr_bundle *attrs)
 		atomic_dec(&old_pd->usecnt);
 	}
 
-	if (cmd.flags & IB_MR_REREG_TRANS)
+	if (cmd.flags & IB_MR_REREG_TRANS) {
 		mr->iova = cmd.hca_va;
+		mr->length = cmd.length;
+	}
 
 	memset(&resp, 0, sizeof(resp));
 	resp.lkey      = mr->lkey;
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 597e889ba831..5889639e90a1 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -2082,6 +2082,8 @@ struct ib_mr *ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	mr->pd = pd;
 	mr->dm = NULL;
 	atomic_inc(&pd->usecnt);
+	mr->iova =  virt_addr;
+	mr->length = length;
 
 	rdma_restrack_new(&mr->res, RDMA_RESTRACK_MR);
 	rdma_restrack_parent_name(&mr->res, &pd->res);
diff --git a/drivers/infiniband/hw/hns/hns_roce_mr.c b/drivers/infiniband/hw/hns/hns_roce_mr.c
index 027ec8413ac2..6d7cc724862f 100644
--- a/drivers/infiniband/hw/hns/hns_roce_mr.c
+++ b/drivers/infiniband/hw/hns/hns_roce_mr.c
@@ -286,7 +286,6 @@ struct ib_mr *hns_roce_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 		goto err_alloc_pbl;
 
 	mr->ibmr.rkey = mr->ibmr.lkey = mr->key;
-	mr->ibmr.length = length;
 
 	return &mr->ibmr;
 
diff --git a/drivers/infiniband/hw/mlx4/mr.c b/drivers/infiniband/hw/mlx4/mr.c
index 426fed005d53..811b4bb34524 100644
--- a/drivers/infiniband/hw/mlx4/mr.c
+++ b/drivers/infiniband/hw/mlx4/mr.c
@@ -439,7 +439,6 @@ struct ib_mr *mlx4_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 		goto err_mr;
 
 	mr->ibmr.rkey = mr->ibmr.lkey = mr->mmr.key;
-	mr->ibmr.length = length;
 	mr->ibmr.page_size = 1U << shift;
 
 	return &mr->ibmr;
diff --git a/drivers/infiniband/sw/rxe/rxe_qp.c b/drivers/infiniband/sw/rxe/rxe_qp.c
index 2847ab4d9a5f..2e4b008f0387 100644
--- a/drivers/infiniband/sw/rxe/rxe_qp.c
+++ b/drivers/infiniband/sw/rxe/rxe_qp.c
@@ -775,7 +775,9 @@ void rxe_qp_destroy(struct rxe_qp *qp)
 	rxe_cleanup_task(&qp->comp.task);
 
 	/* flush out any receive wr's or pending requests */
-	__rxe_do_task(&qp->req.task);
+	if (qp->req.task.func)
+		__rxe_do_task(&qp->req.task);
+
 	if (qp->sq.queue) {
 		__rxe_do_task(&qp->comp.task);
 		__rxe_do_task(&qp->req.task);
@@ -815,8 +817,10 @@ static void rxe_qp_do_cleanup(struct work_struct *work)
 
 	free_rd_atomic_resources(qp);
 
-	kernel_sock_shutdown(qp->sk, SHUT_RDWR);
-	sock_release(qp->sk);
+	if (qp->sk) {
+		kernel_sock_shutdown(qp->sk, SHUT_RDWR);
+		sock_release(qp->sk);
+	}
 }
 
 /* called when the last reference to the qp is dropped */
diff --git a/drivers/infiniband/sw/siw/siw_qp_rx.c b/drivers/infiniband/sw/siw/siw_qp_rx.c
index 875ea6f1b04a..fd721cc19682 100644
--- a/drivers/infiniband/sw/siw/siw_qp_rx.c
+++ b/drivers/infiniband/sw/siw/siw_qp_rx.c
@@ -961,27 +961,28 @@ int siw_proc_terminate(struct siw_qp *qp)
 static int siw_get_trailer(struct siw_qp *qp, struct siw_rx_stream *srx)
 {
 	struct sk_buff *skb = srx->skb;
+	int avail = min(srx->skb_new, srx->fpdu_part_rem);
 	u8 *tbuf = (u8 *)&srx->trailer.crc - srx->pad;
 	__wsum crc_in, crc_own = 0;
 
 	siw_dbg_qp(qp, "expected %d, available %d, pad %u\n",
 		   srx->fpdu_part_rem, srx->skb_new, srx->pad);
 
-	if (srx->skb_new < srx->fpdu_part_rem)
-		return -EAGAIN;
-
-	skb_copy_bits(skb, srx->skb_offset, tbuf, srx->fpdu_part_rem);
+	skb_copy_bits(skb, srx->skb_offset, tbuf, avail);
 
-	if (srx->mpa_crc_hd && srx->pad)
-		crypto_shash_update(srx->mpa_crc_hd, tbuf, srx->pad);
+	srx->skb_new -= avail;
+	srx->skb_offset += avail;
+	srx->skb_copied += avail;
+	srx->fpdu_part_rem -= avail;
 
-	srx->skb_new -= srx->fpdu_part_rem;
-	srx->skb_offset += srx->fpdu_part_rem;
-	srx->skb_copied += srx->fpdu_part_rem;
+	if (srx->fpdu_part_rem)
+		return -EAGAIN;
 
 	if (!srx->mpa_crc_hd)
 		return 0;
 
+	if (srx->pad)
+		crypto_shash_update(srx->mpa_crc_hd, tbuf, srx->pad);
 	/*
 	 * CRC32 is computed, transmitted and received directly in NBO,
 	 * so there's never a reason to convert byte order.
@@ -1083,10 +1084,9 @@ static int siw_get_hdr(struct siw_rx_stream *srx)
 	 * completely received.
 	 */
 	if (iwarp_pktinfo[opcode].hdr_len > sizeof(struct iwarp_ctrl_tagged)) {
-		bytes = iwarp_pktinfo[opcode].hdr_len - MIN_DDP_HDR;
+		int hdrlen = iwarp_pktinfo[opcode].hdr_len;
 
-		if (srx->skb_new < bytes)
-			return -EAGAIN;
+		bytes = min_t(int, hdrlen - MIN_DDP_HDR, srx->skb_new);
 
 		skb_copy_bits(skb, srx->skb_offset,
 			      (char *)c_hdr + srx->fpdu_part_rcvd, bytes);
@@ -1096,6 +1096,9 @@ static int siw_get_hdr(struct siw_rx_stream *srx)
 		srx->skb_new -= bytes;
 		srx->skb_offset += bytes;
 		srx->skb_copied += bytes;
+
+		if (srx->fpdu_part_rcvd < hdrlen)
+			return -EAGAIN;
 	}
 
 	/*
diff --git a/drivers/iommu/omap-iommu-debug.c b/drivers/iommu/omap-iommu-debug.c
index a99afb5d9011..259f65291d90 100644
--- a/drivers/iommu/omap-iommu-debug.c
+++ b/drivers/iommu/omap-iommu-debug.c
@@ -32,12 +32,12 @@ static inline bool is_omap_iommu_detached(struct omap_iommu *obj)
 		ssize_t bytes;						\
 		const char *str = "%20s: %08x\n";			\
 		const int maxcol = 32;					\
-		bytes = snprintf(p, maxcol, str, __stringify(name),	\
+		if (len < maxcol)					\
+			goto out;					\
+		bytes = scnprintf(p, maxcol, str, __stringify(name),	\
 				 iommu_read_reg(obj, MMU_##name));	\
 		p += bytes;						\
 		len -= bytes;						\
-		if (len < maxcol)					\
-			goto out;					\
 	} while (0)
 
 static ssize_t
diff --git a/drivers/isdn/mISDN/l1oip.h b/drivers/isdn/mISDN/l1oip.h
index 7ea10db20e3a..48133d022812 100644
--- a/drivers/isdn/mISDN/l1oip.h
+++ b/drivers/isdn/mISDN/l1oip.h
@@ -59,6 +59,7 @@ struct l1oip {
 	int			bundle;		/* bundle channels in one frm */
 	int			codec;		/* codec to use for transmis. */
 	int			limit;		/* limit number of bchannels */
+	bool			shutdown;	/* if card is released */
 
 	/* timer */
 	struct timer_list	keep_tl;
diff --git a/drivers/isdn/mISDN/l1oip_core.c b/drivers/isdn/mISDN/l1oip_core.c
index b57dcb834594..aec4f2a69c3b 100644
--- a/drivers/isdn/mISDN/l1oip_core.c
+++ b/drivers/isdn/mISDN/l1oip_core.c
@@ -275,7 +275,7 @@ l1oip_socket_send(struct l1oip *hc, u8 localcodec, u8 channel, u32 chanmask,
 	p = frame;
 
 	/* restart timer */
-	if (time_before(hc->keep_tl.expires, jiffies + 5 * HZ))
+	if (time_before(hc->keep_tl.expires, jiffies + 5 * HZ) && !hc->shutdown)
 		mod_timer(&hc->keep_tl, jiffies + L1OIP_KEEPALIVE * HZ);
 	else
 		hc->keep_tl.expires = jiffies + L1OIP_KEEPALIVE * HZ;
@@ -601,7 +601,9 @@ l1oip_socket_parse(struct l1oip *hc, struct sockaddr_in *sin, u8 *buf, int len)
 		goto multiframe;
 
 	/* restart timer */
-	if (time_before(hc->timeout_tl.expires, jiffies + 5 * HZ) || !hc->timeout_on) {
+	if ((time_before(hc->timeout_tl.expires, jiffies + 5 * HZ) ||
+	     !hc->timeout_on) &&
+	    !hc->shutdown) {
 		hc->timeout_on = 1;
 		mod_timer(&hc->timeout_tl, jiffies + L1OIP_TIMEOUT * HZ);
 	} else /* only adjust timer */
@@ -1232,11 +1234,10 @@ release_card(struct l1oip *hc)
 {
 	int	ch;
 
-	if (timer_pending(&hc->keep_tl))
-		del_timer(&hc->keep_tl);
+	hc->shutdown = true;
 
-	if (timer_pending(&hc->timeout_tl))
-		del_timer(&hc->timeout_tl);
+	del_timer_sync(&hc->keep_tl);
+	del_timer_sync(&hc->timeout_tl);
 
 	cancel_work_sync(&hc->workq);
 
diff --git a/drivers/leds/leds-lm3601x.c b/drivers/leds/leds-lm3601x.c
index d0e1d4814042..3d1272748201 100644
--- a/drivers/leds/leds-lm3601x.c
+++ b/drivers/leds/leds-lm3601x.c
@@ -444,8 +444,6 @@ static int lm3601x_remove(struct i2c_client *client)
 {
 	struct lm3601x_led *led = i2c_get_clientdata(client);
 
-	mutex_destroy(&led->lock);
-
 	return regmap_update_bits(led->regmap, LM3601X_ENABLE_REG,
 			   LM3601X_ENABLE_MASK,
 			   LM3601X_MODE_STANDBY);
diff --git a/drivers/mailbox/bcm-flexrm-mailbox.c b/drivers/mailbox/bcm-flexrm-mailbox.c
index bee33abb5308..e913ed1e34c6 100644
--- a/drivers/mailbox/bcm-flexrm-mailbox.c
+++ b/drivers/mailbox/bcm-flexrm-mailbox.c
@@ -632,15 +632,15 @@ static int flexrm_spu_dma_map(struct device *dev, struct brcm_message *msg)
 
 	rc = dma_map_sg(dev, msg->spu.src, sg_nents(msg->spu.src),
 			DMA_TO_DEVICE);
-	if (rc < 0)
-		return rc;
+	if (!rc)
+		return -EIO;
 
 	rc = dma_map_sg(dev, msg->spu.dst, sg_nents(msg->spu.dst),
 			DMA_FROM_DEVICE);
-	if (rc < 0) {
+	if (!rc) {
 		dma_unmap_sg(dev, msg->spu.src, sg_nents(msg->spu.src),
 			     DMA_TO_DEVICE);
-		return rc;
+		return -EIO;
 	}
 
 	return 0;
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index a878b959fbcd..3aa73da2c67b 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -119,6 +119,53 @@ static void __update_writeback_rate(struct cached_dev *dc)
 	dc->writeback_rate_target = target;
 }
 
+static bool idle_counter_exceeded(struct cache_set *c)
+{
+	int counter, dev_nr;
+
+	/*
+	 * If c->idle_counter is overflow (idel for really long time),
+	 * reset as 0 and not set maximum rate this time for code
+	 * simplicity.
+	 */
+	counter = atomic_inc_return(&c->idle_counter);
+	if (counter <= 0) {
+		atomic_set(&c->idle_counter, 0);
+		return false;
+	}
+
+	dev_nr = atomic_read(&c->attached_dev_nr);
+	if (dev_nr == 0)
+		return false;
+
+	/*
+	 * c->idle_counter is increased by writeback thread of all
+	 * attached backing devices, in order to represent a rough
+	 * time period, counter should be divided by dev_nr.
+	 * Otherwise the idle time cannot be larger with more backing
+	 * device attached.
+	 * The following calculation equals to checking
+	 *	(counter / dev_nr) < (dev_nr * 6)
+	 */
+	if (counter < (dev_nr * dev_nr * 6))
+		return false;
+
+	return true;
+}
+
+/*
+ * Idle_counter is increased every time when update_writeback_rate() is
+ * called. If all backing devices attached to the same cache set have
+ * identical dc->writeback_rate_update_seconds values, it is about 6
+ * rounds of update_writeback_rate() on each backing device before
+ * c->at_max_writeback_rate is set to 1, and then max wrteback rate set
+ * to each dc->writeback_rate.rate.
+ * In order to avoid extra locking cost for counting exact dirty cached
+ * devices number, c->attached_dev_nr is used to calculate the idle
+ * throushold. It might be bigger if not all cached device are in write-
+ * back mode, but it still works well with limited extra rounds of
+ * update_writeback_rate().
+ */
 static bool set_at_max_writeback_rate(struct cache_set *c,
 				       struct cached_dev *dc)
 {
@@ -129,21 +176,8 @@ static bool set_at_max_writeback_rate(struct cache_set *c,
 	/* Don't set max writeback rate if gc is running */
 	if (!c->gc_mark_valid)
 		return false;
-	/*
-	 * Idle_counter is increased everytime when update_writeback_rate() is
-	 * called. If all backing devices attached to the same cache set have
-	 * identical dc->writeback_rate_update_seconds values, it is about 6
-	 * rounds of update_writeback_rate() on each backing device before
-	 * c->at_max_writeback_rate is set to 1, and then max wrteback rate set
-	 * to each dc->writeback_rate.rate.
-	 * In order to avoid extra locking cost for counting exact dirty cached
-	 * devices number, c->attached_dev_nr is used to calculate the idle
-	 * throushold. It might be bigger if not all cached device are in write-
-	 * back mode, but it still works well with limited extra rounds of
-	 * update_writeback_rate().
-	 */
-	if (atomic_inc_return(&c->idle_counter) <
-	    atomic_read(&c->attached_dev_nr) * 6)
+
+	if (!idle_counter_exceeded(c))
 		return false;
 
 	if (atomic_read(&c->at_max_writeback_rate) != 1)
@@ -157,13 +191,10 @@ static bool set_at_max_writeback_rate(struct cache_set *c,
 	dc->writeback_rate_change = 0;
 
 	/*
-	 * Check c->idle_counter and c->at_max_writeback_rate agagain in case
-	 * new I/O arrives during before set_at_max_writeback_rate() returns.
-	 * Then the writeback rate is set to 1, and its new value should be
-	 * decided via __update_writeback_rate().
+	 * In case new I/O arrives during before
+	 * set_at_max_writeback_rate() returns.
 	 */
-	if ((atomic_read(&c->idle_counter) <
-	     atomic_read(&c->attached_dev_nr) * 6) ||
+	if (!idle_counter_exceeded(c) ||
 	    !atomic_read(&c->at_max_writeback_rate))
 		return false;
 
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index a4c0cafa6010..a20332e755e8 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -48,7 +48,7 @@ static void dump_zones(struct mddev *mddev)
 		int len = 0;
 
 		for (k = 0; k < conf->strip_zone[j].nb_dev; k++)
-			len += snprintf(line+len, 200-len, "%s%s", k?"/":"",
+			len += scnprintf(line+len, 200-len, "%s%s", k?"/":"",
 					bdevname(conf->devlist[j*raid_disks
 							       + k]->bdev, b));
 		pr_debug("md: zone%d=[%s]\n", j, line);
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 01c7edf32936..9f114b9d8dc6 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -36,6 +36,7 @@
  */
 
 #include <linux/blkdev.h>
+#include <linux/delay.h>
 #include <linux/kthread.h>
 #include <linux/raid/pq.h>
 #include <linux/async_tx.h>
@@ -3936,7 +3937,7 @@ static void handle_stripe_fill(struct stripe_head *sh,
 		 * back cache (prexor with orig_page, and then xor with
 		 * page) in the read path
 		 */
-		if (s->injournal && s->failed) {
+		if (s->to_read && s->injournal && s->failed) {
 			if (test_bit(STRIPE_R5C_CACHING, &sh->state))
 				r5c_make_stripe_write_out(sh);
 			goto out;
@@ -6519,7 +6520,18 @@ static void raid5d(struct md_thread *thread)
 			spin_unlock_irq(&conf->device_lock);
 			md_check_recovery(mddev);
 			spin_lock_irq(&conf->device_lock);
+
+			/*
+			 * Waiting on MD_SB_CHANGE_PENDING below may deadlock
+			 * seeing md_check_recovery() is needed to clear
+			 * the flag when using mdmon.
+			 */
+			continue;
 		}
+
+		wait_event_lock_irq(mddev->sb_wait,
+			!test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags),
+			conf->device_lock);
 	}
 	pr_debug("%d stripes handled\n", handled);
 
diff --git a/drivers/media/pci/cx88/cx88-vbi.c b/drivers/media/pci/cx88/cx88-vbi.c
index 58489ea0c1da..7cf2271866d0 100644
--- a/drivers/media/pci/cx88/cx88-vbi.c
+++ b/drivers/media/pci/cx88/cx88-vbi.c
@@ -144,11 +144,10 @@ static int buffer_prepare(struct vb2_buffer *vb)
 		return -EINVAL;
 	vb2_set_plane_payload(vb, 0, size);
 
-	cx88_risc_buffer(dev->pci, &buf->risc, sgt->sgl,
-			 0, VBI_LINE_LENGTH * lines,
-			 VBI_LINE_LENGTH, 0,
-			 lines);
-	return 0;
+	return cx88_risc_buffer(dev->pci, &buf->risc, sgt->sgl,
+				0, VBI_LINE_LENGTH * lines,
+				VBI_LINE_LENGTH, 0,
+				lines);
 }
 
 static void buffer_finish(struct vb2_buffer *vb)
diff --git a/drivers/media/pci/cx88/cx88-video.c b/drivers/media/pci/cx88/cx88-video.c
index 8cffdacf6007..e5adffa3a99a 100644
--- a/drivers/media/pci/cx88/cx88-video.c
+++ b/drivers/media/pci/cx88/cx88-video.c
@@ -431,6 +431,7 @@ static int queue_setup(struct vb2_queue *q,
 
 static int buffer_prepare(struct vb2_buffer *vb)
 {
+	int ret;
 	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct cx8800_dev *dev = vb->vb2_queue->drv_priv;
 	struct cx88_core *core = dev->core;
@@ -445,35 +446,35 @@ static int buffer_prepare(struct vb2_buffer *vb)
 
 	switch (core->field) {
 	case V4L2_FIELD_TOP:
-		cx88_risc_buffer(dev->pci, &buf->risc,
-				 sgt->sgl, 0, UNSET,
-				 buf->bpl, 0, core->height);
+		ret = cx88_risc_buffer(dev->pci, &buf->risc,
+				       sgt->sgl, 0, UNSET,
+				       buf->bpl, 0, core->height);
 		break;
 	case V4L2_FIELD_BOTTOM:
-		cx88_risc_buffer(dev->pci, &buf->risc,
-				 sgt->sgl, UNSET, 0,
-				 buf->bpl, 0, core->height);
+		ret = cx88_risc_buffer(dev->pci, &buf->risc,
+				       sgt->sgl, UNSET, 0,
+				       buf->bpl, 0, core->height);
 		break;
 	case V4L2_FIELD_SEQ_TB:
-		cx88_risc_buffer(dev->pci, &buf->risc,
-				 sgt->sgl,
-				 0, buf->bpl * (core->height >> 1),
-				 buf->bpl, 0,
-				 core->height >> 1);
+		ret = cx88_risc_buffer(dev->pci, &buf->risc,
+				       sgt->sgl,
+				       0, buf->bpl * (core->height >> 1),
+				       buf->bpl, 0,
+				       core->height >> 1);
 		break;
 	case V4L2_FIELD_SEQ_BT:
-		cx88_risc_buffer(dev->pci, &buf->risc,
-				 sgt->sgl,
-				 buf->bpl * (core->height >> 1), 0,
-				 buf->bpl, 0,
-				 core->height >> 1);
+		ret = cx88_risc_buffer(dev->pci, &buf->risc,
+				       sgt->sgl,
+				       buf->bpl * (core->height >> 1), 0,
+				       buf->bpl, 0,
+				       core->height >> 1);
 		break;
 	case V4L2_FIELD_INTERLACED:
 	default:
-		cx88_risc_buffer(dev->pci, &buf->risc,
-				 sgt->sgl, 0, buf->bpl,
-				 buf->bpl, buf->bpl,
-				 core->height >> 1);
+		ret = cx88_risc_buffer(dev->pci, &buf->risc,
+				       sgt->sgl, 0, buf->bpl,
+				       buf->bpl, buf->bpl,
+				       core->height >> 1);
 		break;
 	}
 	dprintk(2,
@@ -481,7 +482,7 @@ static int buffer_prepare(struct vb2_buffer *vb)
 		buf, buf->vb.vb2_buf.index, __func__,
 		core->width, core->height, dev->fmt->depth, dev->fmt->fourcc,
 		(unsigned long)buf->risc.dma);
-	return 0;
+	return ret;
 }
 
 static void buffer_finish(struct vb2_buffer *vb)
diff --git a/drivers/media/platform/exynos4-is/fimc-is.c b/drivers/media/platform/exynos4-is/fimc-is.c
index dc2a144cd29b..b52d2203eac5 100644
--- a/drivers/media/platform/exynos4-is/fimc-is.c
+++ b/drivers/media/platform/exynos4-is/fimc-is.c
@@ -213,6 +213,7 @@ static int fimc_is_register_subdevs(struct fimc_is *is)
 
 			if (ret < 0 || index >= FIMC_IS_SENSORS_NUM) {
 				of_node_put(child);
+				of_node_put(i2c_bus);
 				return ret;
 			}
 			index++;
diff --git a/drivers/media/platform/xilinx/xilinx-vipp.c b/drivers/media/platform/xilinx/xilinx-vipp.c
index cc2856efea59..f2b0c490187c 100644
--- a/drivers/media/platform/xilinx/xilinx-vipp.c
+++ b/drivers/media/platform/xilinx/xilinx-vipp.c
@@ -472,7 +472,7 @@ static int xvip_graph_dma_init(struct xvip_composite_device *xdev)
 {
 	struct device_node *ports;
 	struct device_node *port;
-	int ret;
+	int ret = 0;
 
 	ports = of_get_child_by_name(xdev->dev->of_node, "ports");
 	if (ports == NULL) {
@@ -482,13 +482,14 @@ static int xvip_graph_dma_init(struct xvip_composite_device *xdev)
 
 	for_each_child_of_node(ports, port) {
 		ret = xvip_graph_dma_init_one(xdev, port);
-		if (ret < 0) {
+		if (ret) {
 			of_node_put(port);
-			return ret;
+			break;
 		}
 	}
 
-	return 0;
+	of_node_put(ports);
+	return ret;
 }
 
 static void xvip_graph_cleanup(struct xvip_composite_device *xdev)
diff --git a/drivers/memory/of_memory.c b/drivers/memory/of_memory.c
index d9f5437d3bce..1791614f324b 100644
--- a/drivers/memory/of_memory.c
+++ b/drivers/memory/of_memory.c
@@ -134,6 +134,7 @@ const struct lpddr2_timings *of_get_ddr_timings(struct device_node *np_ddr,
 	for_each_child_of_node(np_ddr, np_tim) {
 		if (of_device_is_compatible(np_tim, tim_compat)) {
 			if (of_do_get_timings(np_tim, &timings[i])) {
+				of_node_put(np_tim);
 				devm_kfree(dev, timings);
 				goto default_timings;
 			}
@@ -282,6 +283,7 @@ const struct lpddr3_timings
 		if (of_device_is_compatible(np_tim, tim_compat)) {
 			if (of_lpddr3_do_get_timings(np_tim, &timings[i])) {
 				devm_kfree(dev, timings);
+				of_node_put(np_tim);
 				goto default_timings;
 			}
 			i++;
diff --git a/drivers/memory/pl353-smc.c b/drivers/memory/pl353-smc.c
index b0b251bb207f..1a6964f1ba6a 100644
--- a/drivers/memory/pl353-smc.c
+++ b/drivers/memory/pl353-smc.c
@@ -416,6 +416,7 @@ static int pl353_smc_probe(struct amba_device *adev, const struct amba_id *id)
 	if (init)
 		init(adev, child);
 	of_platform_device_create(child, NULL, &adev->dev);
+	of_node_put(child);
 
 	return 0;
 
diff --git a/drivers/mfd/fsl-imx25-tsadc.c b/drivers/mfd/fsl-imx25-tsadc.c
index a016b39fe9b0..5f1f6f3a0696 100644
--- a/drivers/mfd/fsl-imx25-tsadc.c
+++ b/drivers/mfd/fsl-imx25-tsadc.c
@@ -69,7 +69,7 @@ static int mx25_tsadc_setup_irq(struct platform_device *pdev,
 	int irq;
 
 	irq = platform_get_irq(pdev, 0);
-	if (irq <= 0)
+	if (irq < 0)
 		return irq;
 
 	tsadc->domain = irq_domain_add_simple(np, 2, 0, &mx25_tsadc_domain_ops,
@@ -84,6 +84,19 @@ static int mx25_tsadc_setup_irq(struct platform_device *pdev,
 	return 0;
 }
 
+static int mx25_tsadc_unset_irq(struct platform_device *pdev)
+{
+	struct mx25_tsadc *tsadc = platform_get_drvdata(pdev);
+	int irq = platform_get_irq(pdev, 0);
+
+	if (irq >= 0) {
+		irq_set_chained_handler_and_data(irq, NULL, NULL);
+		irq_domain_remove(tsadc->domain);
+	}
+
+	return 0;
+}
+
 static void mx25_tsadc_setup_clk(struct platform_device *pdev,
 				 struct mx25_tsadc *tsadc)
 {
@@ -171,18 +184,21 @@ static int mx25_tsadc_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, tsadc);
 
-	return devm_of_platform_populate(dev);
+	ret = devm_of_platform_populate(dev);
+	if (ret)
+		goto err_irq;
+
+	return 0;
+
+err_irq:
+	mx25_tsadc_unset_irq(pdev);
+
+	return ret;
 }
 
 static int mx25_tsadc_remove(struct platform_device *pdev)
 {
-	struct mx25_tsadc *tsadc = platform_get_drvdata(pdev);
-	int irq = platform_get_irq(pdev, 0);
-
-	if (irq) {
-		irq_set_chained_handler_and_data(irq, NULL, NULL);
-		irq_domain_remove(tsadc->domain);
-	}
+	mx25_tsadc_unset_irq(pdev);
 
 	return 0;
 }
diff --git a/drivers/mfd/intel_soc_pmic_core.c b/drivers/mfd/intel_soc_pmic_core.c
index ddd64f9e3341..926653e1f603 100644
--- a/drivers/mfd/intel_soc_pmic_core.c
+++ b/drivers/mfd/intel_soc_pmic_core.c
@@ -95,6 +95,7 @@ static int intel_soc_pmic_i2c_probe(struct i2c_client *i2c,
 	return 0;
 
 err_del_irq_chip:
+	pwm_remove_table(crc_pwm_lookup, ARRAY_SIZE(crc_pwm_lookup));
 	regmap_del_irq_chip(pmic->irq, pmic->irq_chip_data);
 	return ret;
 }
diff --git a/drivers/mfd/lp8788-irq.c b/drivers/mfd/lp8788-irq.c
index 348439a3fbbd..39006297f3d2 100644
--- a/drivers/mfd/lp8788-irq.c
+++ b/drivers/mfd/lp8788-irq.c
@@ -175,6 +175,7 @@ int lp8788_irq_init(struct lp8788 *lp, int irq)
 				IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
 				"lp8788-irq", irqd);
 	if (ret) {
+		irq_domain_remove(lp->irqdm);
 		dev_err(lp->dev, "failed to create a thread for IRQ_N\n");
 		return ret;
 	}
@@ -188,4 +189,6 @@ void lp8788_irq_exit(struct lp8788 *lp)
 {
 	if (lp->irq)
 		free_irq(lp->irq, lp->irqdm);
+	if (lp->irqdm)
+		irq_domain_remove(lp->irqdm);
 }
diff --git a/drivers/mfd/lp8788.c b/drivers/mfd/lp8788.c
index 768d556b3fe9..5c3d642c8e3a 100644
--- a/drivers/mfd/lp8788.c
+++ b/drivers/mfd/lp8788.c
@@ -195,8 +195,16 @@ static int lp8788_probe(struct i2c_client *cl, const struct i2c_device_id *id)
 	if (ret)
 		return ret;
 
-	return mfd_add_devices(lp->dev, -1, lp8788_devs,
-			       ARRAY_SIZE(lp8788_devs), NULL, 0, NULL);
+	ret = mfd_add_devices(lp->dev, -1, lp8788_devs,
+			      ARRAY_SIZE(lp8788_devs), NULL, 0, NULL);
+	if (ret)
+		goto err_exit_irq;
+
+	return 0;
+
+err_exit_irq:
+	lp8788_irq_exit(lp);
+	return ret;
 }
 
 static int lp8788_remove(struct i2c_client *cl)
diff --git a/drivers/mfd/sm501.c b/drivers/mfd/sm501.c
index 6d2f4a0a901d..37ad72d8cde2 100644
--- a/drivers/mfd/sm501.c
+++ b/drivers/mfd/sm501.c
@@ -1720,7 +1720,12 @@ static struct platform_driver sm501_plat_driver = {
 
 static int __init sm501_base_init(void)
 {
-	platform_driver_register(&sm501_plat_driver);
+	int ret;
+
+	ret = platform_driver_register(&sm501_plat_driver);
+	if (ret < 0)
+		return ret;
+
 	return pci_register_driver(&sm501_pci_driver);
 }
 
diff --git a/drivers/misc/ocxl/file.c b/drivers/misc/ocxl/file.c
index c742ab02ae18..e094809b54ff 100644
--- a/drivers/misc/ocxl/file.c
+++ b/drivers/misc/ocxl/file.c
@@ -259,6 +259,8 @@ static long afu_ioctl(struct file *file, unsigned int cmd,
 		if (IS_ERR(ev_ctx))
 			return PTR_ERR(ev_ctx);
 		rc = ocxl_irq_set_handler(ctx, irq_id, irq_handler, irq_free, ev_ctx);
+		if (rc)
+			eventfd_ctx_put(ev_ctx);
 		break;
 
 	case OCXL_IOCTL_GET_METADATA:
diff --git a/drivers/mmc/host/au1xmmc.c b/drivers/mmc/host/au1xmmc.c
index bd00515fbaba..56a3bf51d446 100644
--- a/drivers/mmc/host/au1xmmc.c
+++ b/drivers/mmc/host/au1xmmc.c
@@ -1097,8 +1097,9 @@ static int au1xmmc_probe(struct platform_device *pdev)
 	if (host->platdata && host->platdata->cd_setup &&
 	    !(mmc->caps & MMC_CAP_NEEDS_POLL))
 		host->platdata->cd_setup(mmc, 0);
-out_clk:
+
 	clk_disable_unprepare(host->clk);
+out_clk:
 	clk_put(host->clk);
 out_irq:
 	free_irq(host->irq, host);
diff --git a/drivers/mmc/host/sdhci-msm.c b/drivers/mmc/host/sdhci-msm.c
index 192cb8b20b47..ad2e73f9a58f 100644
--- a/drivers/mmc/host/sdhci-msm.c
+++ b/drivers/mmc/host/sdhci-msm.c
@@ -2182,6 +2182,7 @@ static const struct sdhci_msm_variant_info sm8250_sdhci_var = {
 static const struct of_device_id sdhci_msm_dt_match[] = {
 	{.compatible = "qcom,sdhci-msm-v4", .data = &sdhci_msm_mci_var},
 	{.compatible = "qcom,sdhci-msm-v5", .data = &sdhci_msm_v5_var},
+	{.compatible = "qcom,sdm670-sdhci", .data = &sdm845_sdhci_var},
 	{.compatible = "qcom,sdm845-sdhci", .data = &sdm845_sdhci_var},
 	{.compatible = "qcom,sm8250-sdhci", .data = &sm8250_sdhci_var},
 	{.compatible = "qcom,sc7180-sdhci", .data = &sdm845_sdhci_var},
diff --git a/drivers/mmc/host/sdhci-sprd.c b/drivers/mmc/host/sdhci-sprd.c
index 9cd8862e6cbd..8575f4537e57 100644
--- a/drivers/mmc/host/sdhci-sprd.c
+++ b/drivers/mmc/host/sdhci-sprd.c
@@ -296,7 +296,7 @@ static unsigned int sdhci_sprd_get_max_clock(struct sdhci_host *host)
 
 static unsigned int sdhci_sprd_get_min_clock(struct sdhci_host *host)
 {
-	return 400000;
+	return 100000;
 }
 
 static void sdhci_sprd_set_uhs_signaling(struct sdhci_host *host,
diff --git a/drivers/mmc/host/wmt-sdmmc.c b/drivers/mmc/host/wmt-sdmmc.c
index cf10949fb0ac..8df722ec57ed 100644
--- a/drivers/mmc/host/wmt-sdmmc.c
+++ b/drivers/mmc/host/wmt-sdmmc.c
@@ -849,7 +849,7 @@ static int wmt_mci_probe(struct platform_device *pdev)
 	if (IS_ERR(priv->clk_sdmmc)) {
 		dev_err(&pdev->dev, "Error getting clock\n");
 		ret = PTR_ERR(priv->clk_sdmmc);
-		goto fail5;
+		goto fail5_and_a_half;
 	}
 
 	ret = clk_prepare_enable(priv->clk_sdmmc);
@@ -866,6 +866,9 @@ static int wmt_mci_probe(struct platform_device *pdev)
 	return 0;
 fail6:
 	clk_put(priv->clk_sdmmc);
+fail5_and_a_half:
+	dma_free_coherent(&pdev->dev, mmc->max_blk_count * 16,
+			  priv->dma_desc_buffer, priv->dma_desc_device_addr);
 fail5:
 	free_irq(dma_irq, priv);
 fail4:
diff --git a/drivers/mtd/devices/docg3.c b/drivers/mtd/devices/docg3.c
index a030792115bc..fa42473d04c1 100644
--- a/drivers/mtd/devices/docg3.c
+++ b/drivers/mtd/devices/docg3.c
@@ -1975,9 +1975,14 @@ static int __init docg3_probe(struct platform_device *pdev)
 		dev_err(dev, "No I/O memory resource defined\n");
 		return ret;
 	}
-	base = devm_ioremap(dev, ress->start, DOC_IOSPACE_SIZE);
 
 	ret = -ENOMEM;
+	base = devm_ioremap(dev, ress->start, DOC_IOSPACE_SIZE);
+	if (!base) {
+		dev_err(dev, "devm_ioremap dev failed\n");
+		return ret;
+	}
+
 	cascade = devm_kcalloc(dev, DOC_MAX_NBFLOORS, sizeof(*cascade),
 			       GFP_KERNEL);
 	if (!cascade)
diff --git a/drivers/mtd/nand/raw/atmel/nand-controller.c b/drivers/mtd/nand/raw/atmel/nand-controller.c
index 2228c34f3dea..0d84f8156d8e 100644
--- a/drivers/mtd/nand/raw/atmel/nand-controller.c
+++ b/drivers/mtd/nand/raw/atmel/nand-controller.c
@@ -405,6 +405,7 @@ static int atmel_nand_dma_transfer(struct atmel_nand_controller *nc,
 
 	dma_async_issue_pending(nc->dmac);
 	wait_for_completion(&finished);
+	dma_unmap_single(nc->dev, buf_dma, len, dir);
 
 	return 0;
 
diff --git a/drivers/mtd/nand/raw/fsl_elbc_nand.c b/drivers/mtd/nand/raw/fsl_elbc_nand.c
index b2af7f81fdf8..c174b6dc3c6b 100644
--- a/drivers/mtd/nand/raw/fsl_elbc_nand.c
+++ b/drivers/mtd/nand/raw/fsl_elbc_nand.c
@@ -727,36 +727,40 @@ static int fsl_elbc_attach_chip(struct nand_chip *chip)
 	struct fsl_lbc_regs __iomem *lbc = ctrl->regs;
 	unsigned int al;
 
-	switch (chip->ecc.engine_type) {
 	/*
 	 * if ECC was not chosen in DT, decide whether to use HW or SW ECC from
 	 * CS Base Register
 	 */
-	case NAND_ECC_ENGINE_TYPE_NONE:
+	if (chip->ecc.engine_type == NAND_ECC_ENGINE_TYPE_INVALID) {
 		/* If CS Base Register selects full hardware ECC then use it */
 		if ((in_be32(&lbc->bank[priv->bank].br) & BR_DECC) ==
 		    BR_DECC_CHK_GEN) {
-			chip->ecc.read_page = fsl_elbc_read_page;
-			chip->ecc.write_page = fsl_elbc_write_page;
-			chip->ecc.write_subpage = fsl_elbc_write_subpage;
-
 			chip->ecc.engine_type = NAND_ECC_ENGINE_TYPE_ON_HOST;
-			mtd_set_ooblayout(mtd, &fsl_elbc_ooblayout_ops);
-			chip->ecc.size = 512;
-			chip->ecc.bytes = 3;
-			chip->ecc.strength = 1;
 		} else {
 			/* otherwise fall back to default software ECC */
 			chip->ecc.engine_type = NAND_ECC_ENGINE_TYPE_SOFT;
 			chip->ecc.algo = NAND_ECC_ALGO_HAMMING;
 		}
+	}
+
+	switch (chip->ecc.engine_type) {
+	/* if HW ECC was chosen, setup ecc and oob layout */
+	case NAND_ECC_ENGINE_TYPE_ON_HOST:
+		chip->ecc.read_page = fsl_elbc_read_page;
+		chip->ecc.write_page = fsl_elbc_write_page;
+		chip->ecc.write_subpage = fsl_elbc_write_subpage;
+		mtd_set_ooblayout(mtd, &fsl_elbc_ooblayout_ops);
+		chip->ecc.size = 512;
+		chip->ecc.bytes = 3;
+		chip->ecc.strength = 1;
 		break;
 
-	/* if SW ECC was chosen in DT, we do not need to set anything here */
+	/* if none or SW ECC was chosen, we do not need to set anything here */
+	case NAND_ECC_ENGINE_TYPE_NONE:
 	case NAND_ECC_ENGINE_TYPE_SOFT:
+	case NAND_ECC_ENGINE_TYPE_ON_DIE:
 		break;
 
-	/* should we also implement *_ECC_ENGINE_CONTROLLER to do as above? */
 	default:
 		return -EINVAL;
 	}
diff --git a/drivers/mtd/nand/raw/meson_nand.c b/drivers/mtd/nand/raw/meson_nand.c
index 327a2257ec26..38f490088d76 100644
--- a/drivers/mtd/nand/raw/meson_nand.c
+++ b/drivers/mtd/nand/raw/meson_nand.c
@@ -454,7 +454,7 @@ static int meson_nfc_ecc_correct(struct nand_chip *nand, u32 *bitflips,
 		if (ECC_ERR_CNT(*info) != ECC_UNCORRECTABLE) {
 			mtd->ecc_stats.corrected += ECC_ERR_CNT(*info);
 			*bitflips = max_t(u32, *bitflips, ECC_ERR_CNT(*info));
-			*correct_bitmap |= 1 >> i;
+			*correct_bitmap |= BIT_ULL(i);
 			continue;
 		}
 		if ((nand->options & NAND_NEED_SCRAMBLING) &&
@@ -800,7 +800,7 @@ static int meson_nfc_read_page_hwecc(struct nand_chip *nand, u8 *buf,
 			u8 *data = buf + i * ecc->size;
 			u8 *oob = nand->oob_poi + i * (ecc->bytes + 2);
 
-			if (correct_bitmap & (1 << i))
+			if (correct_bitmap & BIT_ULL(i))
 				continue;
 			ret = nand_check_erased_ecc_chunk(data,	ecc->size,
 							  oob, ecc->bytes + 2,
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb.h b/drivers/net/can/usb/kvaser_usb/kvaser_usb.h
index 61e67986b625..62958f04a2f2 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb.h
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb.h
@@ -178,6 +178,8 @@ struct kvaser_usb_dev_cfg {
 extern const struct kvaser_usb_dev_ops kvaser_usb_hydra_dev_ops;
 extern const struct kvaser_usb_dev_ops kvaser_usb_leaf_dev_ops;
 
+void kvaser_usb_unlink_tx_urbs(struct kvaser_usb_net_priv *priv);
+
 int kvaser_usb_recv_cmd(const struct kvaser_usb *dev, void *cmd, int len,
 			int *actual_len);
 
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
index 416763fd1f11..7491f85e85b3 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
@@ -453,7 +453,7 @@ static void kvaser_usb_reset_tx_urb_contexts(struct kvaser_usb_net_priv *priv)
 /* This method might sleep. Do not call it in the atomic context
  * of URB completions.
  */
-static void kvaser_usb_unlink_tx_urbs(struct kvaser_usb_net_priv *priv)
+void kvaser_usb_unlink_tx_urbs(struct kvaser_usb_net_priv *priv)
 {
 	usb_kill_anchored_urbs(&priv->tx_submitted);
 	kvaser_usb_reset_tx_urb_contexts(priv);
@@ -690,6 +690,7 @@ static int kvaser_usb_init_one(struct kvaser_usb *dev, int channel)
 	init_usb_anchor(&priv->tx_submitted);
 	init_completion(&priv->start_comp);
 	init_completion(&priv->stop_comp);
+	init_completion(&priv->flush_comp);
 	priv->can.ctrlmode_supported = 0;
 
 	priv->dev = dev;
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
index 01d4a731b579..5d642458bac5 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
@@ -1886,7 +1886,7 @@ static int kvaser_usb_hydra_flush_queue(struct kvaser_usb_net_priv *priv)
 {
 	int err;
 
-	init_completion(&priv->flush_comp);
+	reinit_completion(&priv->flush_comp);
 
 	err = kvaser_usb_hydra_send_simple_cmd(priv->dev, CMD_FLUSH_QUEUE,
 					       priv->channel);
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
index 5e281249ad5f..78d52a5e8fd5 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
@@ -309,6 +309,38 @@ struct kvaser_cmd {
 	} u;
 } __packed;
 
+#define CMD_SIZE_ANY 0xff
+#define kvaser_fsize(field) sizeof_field(struct kvaser_cmd, field)
+
+static const u8 kvaser_usb_leaf_cmd_sizes_leaf[] = {
+	[CMD_START_CHIP_REPLY]		= kvaser_fsize(u.simple),
+	[CMD_STOP_CHIP_REPLY]		= kvaser_fsize(u.simple),
+	[CMD_GET_CARD_INFO_REPLY]	= kvaser_fsize(u.cardinfo),
+	[CMD_TX_ACKNOWLEDGE]		= kvaser_fsize(u.tx_acknowledge_header),
+	[CMD_GET_SOFTWARE_INFO_REPLY]	= kvaser_fsize(u.leaf.softinfo),
+	[CMD_RX_STD_MESSAGE]		= kvaser_fsize(u.leaf.rx_can),
+	[CMD_RX_EXT_MESSAGE]		= kvaser_fsize(u.leaf.rx_can),
+	[CMD_LEAF_LOG_MESSAGE]		= kvaser_fsize(u.leaf.log_message),
+	[CMD_CHIP_STATE_EVENT]		= kvaser_fsize(u.leaf.chip_state_event),
+	[CMD_CAN_ERROR_EVENT]		= kvaser_fsize(u.leaf.error_event),
+	/* ignored events: */
+	[CMD_FLUSH_QUEUE_REPLY]		= CMD_SIZE_ANY,
+};
+
+static const u8 kvaser_usb_leaf_cmd_sizes_usbcan[] = {
+	[CMD_START_CHIP_REPLY]		= kvaser_fsize(u.simple),
+	[CMD_STOP_CHIP_REPLY]		= kvaser_fsize(u.simple),
+	[CMD_GET_CARD_INFO_REPLY]	= kvaser_fsize(u.cardinfo),
+	[CMD_TX_ACKNOWLEDGE]		= kvaser_fsize(u.tx_acknowledge_header),
+	[CMD_GET_SOFTWARE_INFO_REPLY]	= kvaser_fsize(u.usbcan.softinfo),
+	[CMD_RX_STD_MESSAGE]		= kvaser_fsize(u.usbcan.rx_can),
+	[CMD_RX_EXT_MESSAGE]		= kvaser_fsize(u.usbcan.rx_can),
+	[CMD_CHIP_STATE_EVENT]		= kvaser_fsize(u.usbcan.chip_state_event),
+	[CMD_CAN_ERROR_EVENT]		= kvaser_fsize(u.usbcan.error_event),
+	/* ignored events: */
+	[CMD_USBCAN_CLOCK_OVERFLOW_EVENT] = CMD_SIZE_ANY,
+};
+
 /* Summary of a kvaser error event, for a unified Leaf/Usbcan error
  * handling. Some discrepancies between the two families exist:
  *
@@ -396,6 +428,43 @@ static const struct kvaser_usb_dev_cfg kvaser_usb_leaf_imx_dev_cfg_32mhz = {
 	.bittiming_const = &kvaser_usb_flexc_bittiming_const,
 };
 
+static int kvaser_usb_leaf_verify_size(const struct kvaser_usb *dev,
+				       const struct kvaser_cmd *cmd)
+{
+	/* buffer size >= cmd->len ensured by caller */
+	u8 min_size = 0;
+
+	switch (dev->driver_info->family) {
+	case KVASER_LEAF:
+		if (cmd->id < ARRAY_SIZE(kvaser_usb_leaf_cmd_sizes_leaf))
+			min_size = kvaser_usb_leaf_cmd_sizes_leaf[cmd->id];
+		break;
+	case KVASER_USBCAN:
+		if (cmd->id < ARRAY_SIZE(kvaser_usb_leaf_cmd_sizes_usbcan))
+			min_size = kvaser_usb_leaf_cmd_sizes_usbcan[cmd->id];
+		break;
+	}
+
+	if (min_size == CMD_SIZE_ANY)
+		return 0;
+
+	if (min_size) {
+		min_size += CMD_HEADER_LEN;
+		if (cmd->len >= min_size)
+			return 0;
+
+		dev_err_ratelimited(&dev->intf->dev,
+				    "Received command %u too short (size %u, needed %u)",
+				    cmd->id, cmd->len, min_size);
+		return -EIO;
+	}
+
+	dev_warn_ratelimited(&dev->intf->dev,
+			     "Unhandled command (%d, size %d)\n",
+			     cmd->id, cmd->len);
+	return -EINVAL;
+}
+
 static void *
 kvaser_usb_leaf_frame_to_cmd(const struct kvaser_usb_net_priv *priv,
 			     const struct sk_buff *skb, int *frame_len,
@@ -503,6 +572,9 @@ static int kvaser_usb_leaf_wait_cmd(const struct kvaser_usb *dev, u8 id,
 end:
 	kfree(buf);
 
+	if (err == 0)
+		err = kvaser_usb_leaf_verify_size(dev, cmd);
+
 	return err;
 }
 
@@ -1137,6 +1209,9 @@ static void kvaser_usb_leaf_stop_chip_reply(const struct kvaser_usb *dev,
 static void kvaser_usb_leaf_handle_command(const struct kvaser_usb *dev,
 					   const struct kvaser_cmd *cmd)
 {
+	if (kvaser_usb_leaf_verify_size(dev, cmd) < 0)
+		return;
+
 	switch (cmd->id) {
 	case CMD_START_CHIP_REPLY:
 		kvaser_usb_leaf_start_chip_reply(dev, cmd);
@@ -1355,9 +1430,13 @@ static int kvaser_usb_leaf_set_mode(struct net_device *netdev,
 
 	switch (mode) {
 	case CAN_MODE_START:
+		kvaser_usb_unlink_tx_urbs(priv);
+
 		err = kvaser_usb_leaf_simple_cmd_async(priv, CMD_START_CHIP);
 		if (err)
 			return err;
+
+		priv->can.state = CAN_STATE_ERROR_ACTIVE;
 		break;
 	default:
 		return -EOPNOTSUPP;
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index 198e041d8410..4f669e7c7558 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -788,6 +788,7 @@ static void bnx2x_tpa_stop(struct bnx2x *bp, struct bnx2x_fastpath *fp,
 			BNX2X_ERR("skb_put is about to fail...  pad %d  len %d  rx_buf_size %d\n",
 				  pad, len, fp->rx_buf_size);
 			bnx2x_panic();
+			bnx2x_frag_free(fp, new_data);
 			return;
 		}
 #endif
diff --git a/drivers/net/ethernet/freescale/fs_enet/mac-fec.c b/drivers/net/ethernet/freescale/fs_enet/mac-fec.c
index 99fe2c210d0f..61f4b6e50d29 100644
--- a/drivers/net/ethernet/freescale/fs_enet/mac-fec.c
+++ b/drivers/net/ethernet/freescale/fs_enet/mac-fec.c
@@ -98,7 +98,7 @@ static int do_pd_setup(struct fs_enet_private *fep)
 		return -EINVAL;
 
 	fep->fec.fecp = of_iomap(ofdev->dev.of_node, 0);
-	if (!fep->fcc.fccp)
+	if (!fep->fec.fecp)
 		return -EINVAL;
 
 	return 0;
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index d825eb021b22..e999ac2de34e 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -1434,6 +1434,7 @@ u32 mvpp2_read(struct mvpp2 *priv, u32 offset);
 void mvpp2_dbgfs_init(struct mvpp2 *priv, const char *name);
 
 void mvpp2_dbgfs_cleanup(struct mvpp2 *priv);
+void mvpp2_dbgfs_exit(void);
 
 #ifdef CONFIG_MVPP2_PTP
 int mvpp22_tai_probe(struct device *dev, struct mvpp2 *priv);
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c
index 4a3baa7e0142..75e83ea2a926 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c
@@ -691,6 +691,13 @@ static int mvpp2_dbgfs_port_init(struct dentry *parent,
 	return 0;
 }
 
+static struct dentry *mvpp2_root;
+
+void mvpp2_dbgfs_exit(void)
+{
+	debugfs_remove(mvpp2_root);
+}
+
 void mvpp2_dbgfs_cleanup(struct mvpp2 *priv)
 {
 	debugfs_remove_recursive(priv->dbgfs_dir);
@@ -700,10 +707,9 @@ void mvpp2_dbgfs_cleanup(struct mvpp2 *priv)
 
 void mvpp2_dbgfs_init(struct mvpp2 *priv, const char *name)
 {
-	struct dentry *mvpp2_dir, *mvpp2_root;
+	struct dentry *mvpp2_dir;
 	int ret, i;
 
-	mvpp2_root = debugfs_lookup(MVPP2_DRIVER_NAME, NULL);
 	if (!mvpp2_root)
 		mvpp2_root = debugfs_create_dir(MVPP2_DRIVER_NAME, NULL);
 
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 542cd6f2c9bd..68c5ed8716c8 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -7155,7 +7155,18 @@ static struct platform_driver mvpp2_driver = {
 	},
 };
 
-module_platform_driver(mvpp2_driver);
+static int __init mvpp2_driver_init(void)
+{
+	return platform_driver_register(&mvpp2_driver);
+}
+module_init(mvpp2_driver_init);
+
+static void __exit mvpp2_driver_exit(void)
+{
+	platform_driver_unregister(&mvpp2_driver);
+	mvpp2_dbgfs_exit();
+}
+module_exit(mvpp2_driver_exit);
 
 MODULE_DESCRIPTION("Marvell PPv2 Ethernet Driver - www.marvell.com");
 MODULE_AUTHOR("Marcin Wojtas <mw@semihalf.com>");
diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 0bb5b1c78654..a526242a3e36 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -1689,7 +1689,9 @@ static void intr_callback(struct urb *urb)
 			   "Stop submitting intr, status %d\n", status);
 		return;
 	case -EOVERFLOW:
-		netif_info(tp, intr, tp->netdev, "intr status -EOVERFLOW\n");
+		if (net_ratelimit())
+			netif_info(tp, intr, tp->netdev,
+				   "intr status -EOVERFLOW\n");
 		goto resubmit;
 	/* -EPIPE:  should clear the halt */
 	default:
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index b61cd275fbda..15f02bf23e9b 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -853,11 +853,36 @@ static int ath10k_peer_delete(struct ath10k *ar, u32 vdev_id, const u8 *addr)
 	return 0;
 }
 
+static void ath10k_peer_map_cleanup(struct ath10k *ar, struct ath10k_peer *peer)
+{
+	int peer_id, i;
+
+	lockdep_assert_held(&ar->conf_mutex);
+
+	for_each_set_bit(peer_id, peer->peer_ids,
+			 ATH10K_MAX_NUM_PEER_IDS) {
+		ar->peer_map[peer_id] = NULL;
+	}
+
+	/* Double check that peer is properly un-referenced from
+	 * the peer_map
+	 */
+	for (i = 0; i < ARRAY_SIZE(ar->peer_map); i++) {
+		if (ar->peer_map[i] == peer) {
+			ath10k_warn(ar, "removing stale peer_map entry for %pM (ptr %pK idx %d)\n",
+				    peer->addr, peer, i);
+			ar->peer_map[i] = NULL;
+		}
+	}
+
+	list_del(&peer->list);
+	kfree(peer);
+	ar->num_peers--;
+}
+
 static void ath10k_peer_cleanup(struct ath10k *ar, u32 vdev_id)
 {
 	struct ath10k_peer *peer, *tmp;
-	int peer_id;
-	int i;
 
 	lockdep_assert_held(&ar->conf_mutex);
 
@@ -869,25 +894,7 @@ static void ath10k_peer_cleanup(struct ath10k *ar, u32 vdev_id)
 		ath10k_warn(ar, "removing stale peer %pM from vdev_id %d\n",
 			    peer->addr, vdev_id);
 
-		for_each_set_bit(peer_id, peer->peer_ids,
-				 ATH10K_MAX_NUM_PEER_IDS) {
-			ar->peer_map[peer_id] = NULL;
-		}
-
-		/* Double check that peer is properly un-referenced from
-		 * the peer_map
-		 */
-		for (i = 0; i < ARRAY_SIZE(ar->peer_map); i++) {
-			if (ar->peer_map[i] == peer) {
-				ath10k_warn(ar, "removing stale peer_map entry for %pM (ptr %pK idx %d)\n",
-					    peer->addr, peer, i);
-				ar->peer_map[i] = NULL;
-			}
-		}
-
-		list_del(&peer->list);
-		kfree(peer);
-		ar->num_peers--;
+		ath10k_peer_map_cleanup(ar, peer);
 	}
 	spin_unlock_bh(&ar->data_lock);
 }
@@ -7470,10 +7477,7 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 				/* Clean up the peer object as well since we
 				 * must have failed to do this above.
 				 */
-				list_del(&peer->list);
-				ar->peer_map[i] = NULL;
-				kfree(peer);
-				ar->num_peers--;
+				ath10k_peer_map_cleanup(ar, peer);
 			}
 		}
 		spin_unlock_bh(&ar->data_lock);
diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 44282aec069d..67faf62999de 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -3419,6 +3419,8 @@ static int ath11k_mac_set_txbf_conf(struct ath11k_vif *arvif)
 	if (vht_cap & (IEEE80211_VHT_CAP_SU_BEAMFORMEE_CAPABLE)) {
 		nsts = vht_cap & IEEE80211_VHT_CAP_BEAMFORMEE_STS_MASK;
 		nsts >>= IEEE80211_VHT_CAP_BEAMFORMEE_STS_SHIFT;
+		if (nsts > (ar->num_rx_chains - 1))
+			nsts = ar->num_rx_chains - 1;
 		value |= SM(nsts, WMI_TXBF_STS_CAP_OFFSET);
 	}
 
@@ -3459,7 +3461,7 @@ static int ath11k_mac_set_txbf_conf(struct ath11k_vif *arvif)
 static void ath11k_set_vht_txbf_cap(struct ath11k *ar, u32 *vht_cap)
 {
 	bool subfer, subfee;
-	int sound_dim = 0;
+	int sound_dim = 0, nsts = 0;
 
 	subfer = !!(*vht_cap & (IEEE80211_VHT_CAP_SU_BEAMFORMER_CAPABLE));
 	subfee = !!(*vht_cap & (IEEE80211_VHT_CAP_SU_BEAMFORMEE_CAPABLE));
@@ -3469,6 +3471,11 @@ static void ath11k_set_vht_txbf_cap(struct ath11k *ar, u32 *vht_cap)
 		subfer = false;
 	}
 
+	if (ar->num_rx_chains < 2) {
+		*vht_cap &= ~(IEEE80211_VHT_CAP_SU_BEAMFORMEE_CAPABLE);
+		subfee = false;
+	}
+
 	/* If SU Beaformer is not set, then disable MU Beamformer Capability */
 	if (!subfer)
 		*vht_cap &= ~(IEEE80211_VHT_CAP_MU_BEAMFORMER_CAPABLE);
@@ -3481,7 +3488,9 @@ static void ath11k_set_vht_txbf_cap(struct ath11k *ar, u32 *vht_cap)
 	sound_dim >>= IEEE80211_VHT_CAP_SOUNDING_DIMENSIONS_SHIFT;
 	*vht_cap &= ~IEEE80211_VHT_CAP_SOUNDING_DIMENSIONS_MASK;
 
-	/* TODO: Need to check invalid STS and Sound_dim values set by FW? */
+	nsts = (*vht_cap & IEEE80211_VHT_CAP_BEAMFORMEE_STS_MASK);
+	nsts >>= IEEE80211_VHT_CAP_BEAMFORMEE_STS_SHIFT;
+	*vht_cap &= ~IEEE80211_VHT_CAP_BEAMFORMEE_STS_MASK;
 
 	/* Enable Sounding Dimension Field only if SU BF is enabled */
 	if (subfer) {
@@ -3493,9 +3502,15 @@ static void ath11k_set_vht_txbf_cap(struct ath11k *ar, u32 *vht_cap)
 		*vht_cap |= sound_dim;
 	}
 
-	/* Use the STS advertised by FW unless SU Beamformee is not supported*/
-	if (!subfee)
-		*vht_cap &= ~(IEEE80211_VHT_CAP_BEAMFORMEE_STS_MASK);
+	/* Enable Beamformee STS Field only if SU BF is enabled */
+	if (subfee) {
+		if (nsts > (ar->num_rx_chains - 1))
+			nsts = ar->num_rx_chains - 1;
+
+		nsts <<= IEEE80211_VHT_CAP_BEAMFORMEE_STS_SHIFT;
+		nsts &=  IEEE80211_VHT_CAP_BEAMFORMEE_STS_MASK;
+		*vht_cap |= nsts;
+	}
 }
 
 static struct ieee80211_sta_vht_cap
diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.c b/drivers/net/wireless/ath/ath9k/htc_hst.c
index 994ec48b2f66..ca05b07a45e6 100644
--- a/drivers/net/wireless/ath/ath9k/htc_hst.c
+++ b/drivers/net/wireless/ath/ath9k/htc_hst.c
@@ -364,33 +364,27 @@ void ath9k_htc_txcompletion_cb(struct htc_target *htc_handle,
 }
 
 static void ath9k_htc_fw_panic_report(struct htc_target *htc_handle,
-				      struct sk_buff *skb)
+				      struct sk_buff *skb, u32 len)
 {
 	uint32_t *pattern = (uint32_t *)skb->data;
 
-	switch (*pattern) {
-	case 0x33221199:
-		{
+	if (*pattern == 0x33221199 && len >= sizeof(struct htc_panic_bad_vaddr)) {
 		struct htc_panic_bad_vaddr *htc_panic;
 		htc_panic = (struct htc_panic_bad_vaddr *) skb->data;
 		dev_err(htc_handle->dev, "ath: firmware panic! "
 			"exccause: 0x%08x; pc: 0x%08x; badvaddr: 0x%08x.\n",
 			htc_panic->exccause, htc_panic->pc,
 			htc_panic->badvaddr);
-		break;
-		}
-	case 0x33221299:
-		{
+		return;
+	}
+	if (*pattern == 0x33221299) {
 		struct htc_panic_bad_epid *htc_panic;
 		htc_panic = (struct htc_panic_bad_epid *) skb->data;
 		dev_err(htc_handle->dev, "ath: firmware panic! "
 			"bad epid: 0x%08x\n", htc_panic->epid);
-		break;
-		}
-	default:
-		dev_err(htc_handle->dev, "ath: unknown panic pattern!\n");
-		break;
+		return;
 	}
+	dev_err(htc_handle->dev, "ath: unknown panic pattern!\n");
 }
 
 /*
@@ -411,16 +405,26 @@ void ath9k_htc_rx_msg(struct htc_target *htc_handle,
 	if (!htc_handle || !skb)
 		return;
 
+	/* A valid message requires len >= 8.
+	 *
+	 *   sizeof(struct htc_frame_hdr) == 8
+	 *   sizeof(struct htc_ready_msg) == 8
+	 *   sizeof(struct htc_panic_bad_vaddr) == 16
+	 *   sizeof(struct htc_panic_bad_epid) == 8
+	 */
+	if (unlikely(len < sizeof(struct htc_frame_hdr)))
+		goto invalid;
 	htc_hdr = (struct htc_frame_hdr *) skb->data;
 	epid = htc_hdr->endpoint_id;
 
 	if (epid == 0x99) {
-		ath9k_htc_fw_panic_report(htc_handle, skb);
+		ath9k_htc_fw_panic_report(htc_handle, skb, len);
 		kfree_skb(skb);
 		return;
 	}
 
 	if (epid < 0 || epid >= ENDPOINT_MAX) {
+invalid:
 		if (pipe_id != USB_REG_IN_PIPE)
 			dev_kfree_skb_any(skb);
 		else
@@ -432,21 +436,30 @@ void ath9k_htc_rx_msg(struct htc_target *htc_handle,
 
 		/* Handle trailer */
 		if (htc_hdr->flags & HTC_FLAGS_RECV_TRAILER) {
-			if (be32_to_cpu(*(__be32 *) skb->data) == 0x00C60000)
+			if (be32_to_cpu(*(__be32 *) skb->data) == 0x00C60000) {
 				/* Move past the Watchdog pattern */
 				htc_hdr = (struct htc_frame_hdr *)(skb->data + 4);
+				len -= 4;
+			}
 		}
 
 		/* Get the message ID */
+		if (unlikely(len < sizeof(struct htc_frame_hdr) + sizeof(__be16)))
+			goto invalid;
 		msg_id = (__be16 *) ((void *) htc_hdr +
 				     sizeof(struct htc_frame_hdr));
 
 		/* Now process HTC messages */
 		switch (be16_to_cpu(*msg_id)) {
 		case HTC_MSG_READY_ID:
+			if (unlikely(len < sizeof(struct htc_ready_msg)))
+				goto invalid;
 			htc_process_target_rdy(htc_handle, htc_hdr);
 			break;
 		case HTC_MSG_CONNECT_SERVICE_RESPONSE_ID:
+			if (unlikely(len < sizeof(struct htc_frame_hdr) +
+				     sizeof(struct htc_conn_svc_rspmsg)))
+				goto invalid;
 			htc_process_conn_rsp(htc_handle, htc_hdr);
 			break;
 		default:
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index 61039538a15b..c8e1d505f7b5 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -290,6 +290,7 @@ static netdev_tx_t brcmf_netdev_start_xmit(struct sk_buff *skb,
 	struct brcmf_pub *drvr = ifp->drvr;
 	struct ethhdr *eh;
 	int head_delta;
+	unsigned int tx_bytes = skb->len;
 
 	brcmf_dbg(DATA, "Enter, bsscfgidx=%d\n", ifp->bsscfgidx);
 
@@ -364,7 +365,7 @@ static netdev_tx_t brcmf_netdev_start_xmit(struct sk_buff *skb,
 		ndev->stats.tx_dropped++;
 	} else {
 		ndev->stats.tx_packets++;
-		ndev->stats.tx_bytes += skb->len;
+		ndev->stats.tx_bytes += tx_bytes;
 	}
 
 	/* Return ok: we always eat the packet */
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c
index fabfbb0b40b0..d0a7465be586 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c
@@ -158,12 +158,12 @@ static int brcmf_pno_set_random(struct brcmf_if *ifp, struct brcmf_pno_info *pi)
 	struct brcmf_pno_macaddr_le pfn_mac;
 	u8 *mac_addr = NULL;
 	u8 *mac_mask = NULL;
-	int err, i;
+	int err, i, ri;
 
-	for (i = 0; i < pi->n_reqs; i++)
-		if (pi->reqs[i]->flags & NL80211_SCAN_FLAG_RANDOM_ADDR) {
-			mac_addr = pi->reqs[i]->mac_addr;
-			mac_mask = pi->reqs[i]->mac_addr_mask;
+	for (ri = 0; ri < pi->n_reqs; ri++)
+		if (pi->reqs[ri]->flags & NL80211_SCAN_FLAG_RANDOM_ADDR) {
+			mac_addr = pi->reqs[ri]->mac_addr;
+			mac_mask = pi->reqs[ri]->mac_addr_mask;
 			break;
 		}
 
@@ -185,7 +185,7 @@ static int brcmf_pno_set_random(struct brcmf_if *ifp, struct brcmf_pno_info *pi)
 	pfn_mac.mac[0] |= 0x02;
 
 	brcmf_dbg(SCAN, "enabling random mac: reqid=%llu mac=%pM\n",
-		  pi->reqs[i]->reqid, pfn_mac.mac);
+		  pi->reqs[ri]->reqid, pfn_mac.mac);
 	err = brcmf_fil_iovar_data_set(ifp, "pfn_macaddr", &pfn_mac,
 				       sizeof(pfn_mac));
 	if (err)
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index fed6d21cd6ce..4bdd3a95f2d2 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -4151,7 +4151,10 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 		rt2800_bbp_write(rt2x00dev, 62, 0x37 - rt2x00dev->lna_gain);
 		rt2800_bbp_write(rt2x00dev, 63, 0x37 - rt2x00dev->lna_gain);
 		rt2800_bbp_write(rt2x00dev, 64, 0x37 - rt2x00dev->lna_gain);
-		rt2800_bbp_write(rt2x00dev, 86, 0);
+		if (rt2x00_rt(rt2x00dev, RT6352))
+			rt2800_bbp_write(rt2x00dev, 86, 0x38);
+		else
+			rt2800_bbp_write(rt2x00dev, 86, 0);
 	}
 
 	if (rf->channel <= 14) {
@@ -4352,7 +4355,8 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 		reg = (rf->channel <= 14 ? 0x1c : 0x24) + 2*rt2x00dev->lna_gain;
 		rt2800_bbp_write_with_rx_chain(rt2x00dev, 66, reg);
 
-		rt2800_iq_calibrate(rt2x00dev, rf->channel);
+		if (rt2x00_rt(rt2x00dev, RT5592))
+			rt2800_iq_calibrate(rt2x00dev, rf->channel);
 	}
 
 	bbp = rt2800_bbp_read(rt2x00dev, 4);
@@ -5625,7 +5629,8 @@ static inline void rt2800_set_vgc(struct rt2x00_dev *rt2x00dev,
 	if (qual->vgc_level != vgc_level) {
 		if (rt2x00_rt(rt2x00dev, RT3572) ||
 		    rt2x00_rt(rt2x00dev, RT3593) ||
-		    rt2x00_rt(rt2x00dev, RT3883)) {
+		    rt2x00_rt(rt2x00dev, RT3883) ||
+		    rt2x00_rt(rt2x00dev, RT6352)) {
 			rt2800_bbp_write_with_rx_chain(rt2x00dev, 66,
 						       vgc_level);
 		} else if (rt2x00_rt(rt2x00dev, RT5592)) {
@@ -5848,7 +5853,7 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000404);
 	} else if (rt2x00_rt(rt2x00dev, RT6352)) {
 		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000401);
-		rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x000C0000);
+		rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x000C0001);
 		rt2800_register_write(rt2x00dev, TX_SW_CFG2, 0x00000000);
 		rt2800_register_write(rt2x00dev, TX_ALC_VGA3, 0x00000000);
 		rt2800_register_write(rt2x00dev, TX0_BB_GAIN_ATTEN, 0x0);
@@ -6110,6 +6115,27 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 		reg = rt2800_register_read(rt2x00dev, US_CYC_CNT);
 		rt2x00_set_field32(&reg, US_CYC_CNT_CLOCK_CYCLE, 125);
 		rt2800_register_write(rt2x00dev, US_CYC_CNT, reg);
+	} else if (rt2x00_is_soc(rt2x00dev)) {
+		struct clk *clk = clk_get_sys("bus", NULL);
+		int rate;
+
+		if (IS_ERR(clk)) {
+			clk = clk_get_sys("cpu", NULL);
+
+			if (IS_ERR(clk)) {
+				rate = 125;
+			} else {
+				rate = clk_get_rate(clk) / 3000000;
+				clk_put(clk);
+			}
+		} else {
+			rate = clk_get_rate(clk) / 1000000;
+			clk_put(clk);
+		}
+
+		reg = rt2800_register_read(rt2x00dev, US_CYC_CNT);
+		rt2x00_set_field32(&reg, US_CYC_CNT_CLOCK_CYCLE, rate);
+		rt2800_register_write(rt2x00dev, US_CYC_CNT, reg);
 	}
 
 	reg = rt2800_register_read(rt2x00dev, HT_FBK_CFG0);
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 0d374a294840..e34cd6fed7e8 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -1874,13 +1874,6 @@ static int rtl8xxxu_read_efuse(struct rtl8xxxu_priv *priv)
 
 		/* We have 8 bits to indicate validity */
 		map_addr = offset * 8;
-		if (map_addr >= EFUSE_MAP_LEN) {
-			dev_warn(dev, "%s: Illegal map_addr (%04x), "
-				 "efuse corrupt!\n",
-				 __func__, map_addr);
-			ret = -EINVAL;
-			goto exit;
-		}
 		for (i = 0; i < EFUSE_MAX_WORD_UNIT; i++) {
 			/* Check word enable condition in the section */
 			if (word_mask & BIT(i)) {
@@ -1891,6 +1884,13 @@ static int rtl8xxxu_read_efuse(struct rtl8xxxu_priv *priv)
 			ret = rtl8xxxu_read_efuse8(priv, efuse_addr++, &val8);
 			if (ret)
 				goto exit;
+			if (map_addr >= EFUSE_MAP_LEN - 1) {
+				dev_warn(dev, "%s: Illegal map_addr (%04x), "
+					 "efuse corrupt!\n",
+					 __func__, map_addr);
+				ret = -EINVAL;
+				goto exit;
+			}
 			priv->efuse_wifi.raw[map_addr++] = val8;
 
 			ret = rtl8xxxu_read_efuse8(priv, efuse_addr++, &val8);
@@ -2925,12 +2925,12 @@ bool rtl8xxxu_gen2_simularity_compare(struct rtl8xxxu_priv *priv,
 		}
 
 		if (!(simubitmap & 0x30) && priv->tx_paths > 1) {
-			/* path B RX OK */
+			/* path B TX OK */
 			for (i = 4; i < 6; i++)
 				result[3][i] = result[c1][i];
 		}
 
-		if (!(simubitmap & 0x30) && priv->tx_paths > 1) {
+		if (!(simubitmap & 0xc0) && priv->tx_paths > 1) {
 			/* path B RX OK */
 			for (i = 6; i < 8; i++)
 				result[3][i] = result[c1][i];
@@ -4338,15 +4338,14 @@ void rtl8xxxu_gen2_update_rate_mask(struct rtl8xxxu_priv *priv,
 	h2c.b_macid_cfg.ramask2 = (ramask >> 16) & 0xff;
 	h2c.b_macid_cfg.ramask3 = (ramask >> 24) & 0xff;
 
-	h2c.ramask.arg = 0x80;
 	h2c.b_macid_cfg.data1 = rateid;
 	if (sgi)
 		h2c.b_macid_cfg.data1 |= BIT(7);
 
 	h2c.b_macid_cfg.data2 = bw;
 
-	dev_dbg(&priv->udev->dev, "%s: rate mask %08x, arg %02x, size %zi\n",
-		__func__, ramask, h2c.ramask.arg, sizeof(h2c.b_macid_cfg));
+	dev_dbg(&priv->udev->dev, "%s: rate mask %08x, rateid %02x, sgi %d, size %zi\n",
+		__func__, ramask, rateid, sgi, sizeof(h2c.b_macid_cfg));
 	rtl8xxxu_gen2_h2c_cmd(priv, &h2c, sizeof(h2c.b_macid_cfg));
 }
 
@@ -4508,6 +4507,53 @@ rtl8xxxu_wireless_mode(struct ieee80211_hw *hw, struct ieee80211_sta *sta)
 	return network_type;
 }
 
+static void rtl8xxxu_set_aifs(struct rtl8xxxu_priv *priv, u8 slot_time)
+{
+	u32 reg_edca_param[IEEE80211_NUM_ACS] = {
+		[IEEE80211_AC_VO] = REG_EDCA_VO_PARAM,
+		[IEEE80211_AC_VI] = REG_EDCA_VI_PARAM,
+		[IEEE80211_AC_BE] = REG_EDCA_BE_PARAM,
+		[IEEE80211_AC_BK] = REG_EDCA_BK_PARAM,
+	};
+	u32 val32;
+	u16 wireless_mode = 0;
+	u8 aifs, aifsn, sifs;
+	int i;
+
+	if (priv->vif) {
+		struct ieee80211_sta *sta;
+
+		rcu_read_lock();
+		sta = ieee80211_find_sta(priv->vif, priv->vif->bss_conf.bssid);
+		if (sta)
+			wireless_mode = rtl8xxxu_wireless_mode(priv->hw, sta);
+		rcu_read_unlock();
+	}
+
+	if (priv->hw->conf.chandef.chan->band == NL80211_BAND_5GHZ ||
+	    (wireless_mode & WIRELESS_MODE_N_24G))
+		sifs = 16;
+	else
+		sifs = 10;
+
+	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
+		val32 = rtl8xxxu_read32(priv, reg_edca_param[i]);
+
+		/* It was set in conf_tx. */
+		aifsn = val32 & 0xff;
+
+		/* aifsn not set yet or already fixed */
+		if (aifsn < 2 || aifsn > 15)
+			continue;
+
+		aifs = aifsn * slot_time + sifs;
+
+		val32 &= ~0xff;
+		val32 |= aifs;
+		rtl8xxxu_write32(priv, reg_edca_param[i], val32);
+	}
+}
+
 static void
 rtl8xxxu_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			  struct ieee80211_bss_conf *bss_conf, u32 changed)
@@ -4593,6 +4639,8 @@ rtl8xxxu_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		else
 			val8 = 20;
 		rtl8xxxu_write8(priv, REG_SLOT, val8);
+
+		rtl8xxxu_set_aifs(priv, val8);
 	}
 
 	if (changed & BSS_CHANGED_BSSID) {
@@ -4984,6 +5032,8 @@ static void rtl8xxxu_tx(struct ieee80211_hw *hw,
 	if (control && control->sta)
 		sta = control->sta;
 
+	queue = rtl8xxxu_queue_select(hw, skb);
+
 	tx_desc = skb_push(skb, tx_desc_size);
 
 	memset(tx_desc, 0, tx_desc_size);
@@ -4996,7 +5046,6 @@ static void rtl8xxxu_tx(struct ieee80211_hw *hw,
 	    is_broadcast_ether_addr(ieee80211_get_DA(hdr)))
 		tx_desc->txdw0 |= TXDESC_BROADMULTICAST;
 
-	queue = rtl8xxxu_queue_select(hw, skb);
 	tx_desc->txdw1 = cpu_to_le32(queue << TXDESC_QUEUE_SHIFT);
 
 	if (tx_info->control.hw_key) {
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 265d9199b657..e9c13804760e 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2949,7 +2949,6 @@ static int nvme_init_subsystem(struct nvme_ctrl *ctrl, struct nvme_id_ctrl *id)
 	nvme_init_subnqn(subsys, ctrl, id);
 	memcpy(subsys->serial, id->sn, sizeof(subsys->serial));
 	memcpy(subsys->model, id->mn, sizeof(subsys->model));
-	memcpy(subsys->firmware_rev, id->fr, sizeof(subsys->firmware_rev));
 	subsys->vendor_id = le16_to_cpu(id->vid);
 	subsys->cmic = id->cmic;
 	subsys->awupf = le16_to_cpu(id->awupf);
@@ -3110,6 +3109,8 @@ int nvme_init_identify(struct nvme_ctrl *ctrl)
 				ctrl->quirks |= core_quirks[i].quirks;
 		}
 	}
+	memcpy(ctrl->subsys->firmware_rev, id->fr,
+	       sizeof(ctrl->subsys->firmware_rev));
 
 	if (force_apst && (ctrl->quirks & NVME_QUIRK_NO_DEEPEST_PS)) {
 		dev_warn(ctrl->device, "forcibly allowing all power states due to nvme_core.force_apst -- use at your own risk\n");
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index ce129655ef0a..65f4bf880608 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -2624,6 +2624,8 @@ static void nvme_reset_work(struct work_struct *work)
 	if (result)
 		goto out_unlock;
 
+	dma_set_min_align_mask(dev->dev, NVME_CTRL_PAGE_SIZE - 1);
+
 	/*
 	 * Limit the max command size to prevent iod->sg allocations going
 	 * over a single page.
@@ -2636,7 +2638,6 @@ static void nvme_reset_work(struct work_struct *work)
 	 * Don't limit the IOMMU merged segment size.
 	 */
 	dma_set_max_seg_size(dev->dev, 0xffffffff);
-	dma_set_min_align_mask(dev->dev, NVME_CTRL_PAGE_SIZE - 1);
 
 	mutex_unlock(&dev->shutdown_lock);
 
diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index e3e35b9bd684..2ddbd4f4f628 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -922,10 +922,17 @@ static int nvmet_tcp_handle_h2c_data_pdu(struct nvmet_tcp_queue *queue)
 	struct nvme_tcp_data_pdu *data = &queue->pdu.data;
 	struct nvmet_tcp_cmd *cmd;
 
-	if (likely(queue->nr_cmds))
+	if (likely(queue->nr_cmds)) {
+		if (unlikely(data->ttag >= queue->nr_cmds)) {
+			pr_err("queue %d: received out of bound ttag %u, nr_cmds %u\n",
+				queue->idx, data->ttag, queue->nr_cmds);
+			nvmet_tcp_fatal_error(queue);
+			return -EPROTO;
+		}
 		cmd = &queue->cmds[data->ttag];
-	else
+	} else {
 		cmd = &queue->connect;
+	}
 
 	if (le32_to_cpu(data->data_offset) != cmd->rbytes_done) {
 		pr_err("ttag %u unexpected data offset %u (expected %u)\n",
diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
index 7f1acb3918d0..875d50c16f19 100644
--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -210,6 +210,17 @@ static int pci_revert_fw_address(struct resource *res, struct pci_dev *dev,
 
 	root = pci_find_parent_resource(dev, res);
 	if (!root) {
+		/*
+		 * If dev is behind a bridge, accesses will only reach it
+		 * if res is inside the relevant bridge window.
+		 */
+		if (pci_upstream_bridge(dev))
+			return -ENXIO;
+
+		/*
+		 * On the root bus, assume the host bridge will forward
+		 * everything.
+		 */
 		if (res->flags & IORESOURCE_IO)
 			root = &ioport_resource;
 		else
diff --git a/drivers/phy/qualcomm/phy-qcom-usb-hsic.c b/drivers/phy/qualcomm/phy-qcom-usb-hsic.c
index 04d18d52f700..d4741c2dbbb5 100644
--- a/drivers/phy/qualcomm/phy-qcom-usb-hsic.c
+++ b/drivers/phy/qualcomm/phy-qcom-usb-hsic.c
@@ -54,8 +54,10 @@ static int qcom_usb_hsic_phy_power_on(struct phy *phy)
 
 	/* Configure pins for HSIC functionality */
 	pins_default = pinctrl_lookup_state(uphy->pctl, PINCTRL_STATE_DEFAULT);
-	if (IS_ERR(pins_default))
-		return PTR_ERR(pins_default);
+	if (IS_ERR(pins_default)) {
+		ret = PTR_ERR(pins_default);
+		goto err_ulpi;
+	}
 
 	ret = pinctrl_select_state(uphy->pctl, pins_default);
 	if (ret)
diff --git a/drivers/platform/chrome/chromeos_laptop.c b/drivers/platform/chrome/chromeos_laptop.c
index 472a03daa869..109c191d35cf 100644
--- a/drivers/platform/chrome/chromeos_laptop.c
+++ b/drivers/platform/chrome/chromeos_laptop.c
@@ -718,6 +718,7 @@ static int __init
 chromeos_laptop_prepare_i2c_peripherals(struct chromeos_laptop *cros_laptop,
 					const struct chromeos_laptop *src)
 {
+	struct i2c_peripheral *i2c_peripherals;
 	struct i2c_peripheral *i2c_dev;
 	struct i2c_board_info *info;
 	int i;
@@ -726,17 +727,15 @@ chromeos_laptop_prepare_i2c_peripherals(struct chromeos_laptop *cros_laptop,
 	if (!src->num_i2c_peripherals)
 		return 0;
 
-	cros_laptop->i2c_peripherals = kmemdup(src->i2c_peripherals,
-					       src->num_i2c_peripherals *
-						sizeof(*src->i2c_peripherals),
-					       GFP_KERNEL);
-	if (!cros_laptop->i2c_peripherals)
+	i2c_peripherals = kmemdup(src->i2c_peripherals,
+					      src->num_i2c_peripherals *
+					  sizeof(*src->i2c_peripherals),
+					  GFP_KERNEL);
+	if (!i2c_peripherals)
 		return -ENOMEM;
 
-	cros_laptop->num_i2c_peripherals = src->num_i2c_peripherals;
-
-	for (i = 0; i < cros_laptop->num_i2c_peripherals; i++) {
-		i2c_dev = &cros_laptop->i2c_peripherals[i];
+	for (i = 0; i < src->num_i2c_peripherals; i++) {
+		i2c_dev = &i2c_peripherals[i];
 		info = &i2c_dev->board_info;
 
 		error = chromeos_laptop_setup_irq(i2c_dev);
@@ -754,16 +753,19 @@ chromeos_laptop_prepare_i2c_peripherals(struct chromeos_laptop *cros_laptop,
 		}
 	}
 
+	cros_laptop->i2c_peripherals = i2c_peripherals;
+	cros_laptop->num_i2c_peripherals = src->num_i2c_peripherals;
+
 	return 0;
 
 err_out:
 	while (--i >= 0) {
-		i2c_dev = &cros_laptop->i2c_peripherals[i];
+		i2c_dev = &i2c_peripherals[i];
 		info = &i2c_dev->board_info;
 		if (info->properties)
 			property_entries_free(info->properties);
 	}
-	kfree(cros_laptop->i2c_peripherals);
+	kfree(i2c_peripherals);
 	return error;
 }
 
diff --git a/drivers/platform/chrome/cros_ec.c b/drivers/platform/chrome/cros_ec.c
index c4de8c4db193..5a622666a075 100644
--- a/drivers/platform/chrome/cros_ec.c
+++ b/drivers/platform/chrome/cros_ec.c
@@ -332,10 +332,16 @@ EXPORT_SYMBOL(cros_ec_suspend);
 
 static void cros_ec_report_events_during_suspend(struct cros_ec_device *ec_dev)
 {
+	bool wake_event;
+
 	while (ec_dev->mkbp_event_supported &&
-	       cros_ec_get_next_event(ec_dev, NULL, NULL) > 0)
+	       cros_ec_get_next_event(ec_dev, &wake_event, NULL) > 0) {
 		blocking_notifier_call_chain(&ec_dev->event_notifier,
 					     1, ec_dev);
+
+		if (wake_event && device_may_wakeup(ec_dev->dev))
+			pm_wakeup_event(ec_dev->dev, 0);
+	}
 }
 
 /**
diff --git a/drivers/platform/chrome/cros_ec_chardev.c b/drivers/platform/chrome/cros_ec_chardev.c
index fd33de546aee..0de7c255254e 100644
--- a/drivers/platform/chrome/cros_ec_chardev.c
+++ b/drivers/platform/chrome/cros_ec_chardev.c
@@ -327,6 +327,9 @@ static long cros_ec_chardev_ioctl_readmem(struct cros_ec_dev *ec,
 	if (copy_from_user(&s_mem, arg, sizeof(s_mem)))
 		return -EFAULT;
 
+	if (s_mem.bytes > sizeof(s_mem.buffer))
+		return -EINVAL;
+
 	num = ec_dev->cmd_readmem(ec_dev, s_mem.offset, s_mem.bytes,
 				  s_mem.buffer);
 	if (num <= 0)
diff --git a/drivers/platform/chrome/cros_ec_proto.c b/drivers/platform/chrome/cros_ec_proto.c
index 3a2a78ff3330..8ffbf92ec1e0 100644
--- a/drivers/platform/chrome/cros_ec_proto.c
+++ b/drivers/platform/chrome/cros_ec_proto.c
@@ -748,6 +748,7 @@ int cros_ec_get_next_event(struct cros_ec_device *ec_dev,
 	u8 event_type;
 	u32 host_event;
 	int ret;
+	u32 ver_mask;
 
 	/*
 	 * Default value for wake_event.
@@ -769,6 +770,37 @@ int cros_ec_get_next_event(struct cros_ec_device *ec_dev,
 		return get_keyboard_state_event(ec_dev);
 
 	ret = get_next_event(ec_dev);
+	/*
+	 * -ENOPROTOOPT is returned when EC returns EC_RES_INVALID_VERSION.
+	 * This can occur when EC based device (e.g. Fingerprint MCU) jumps to
+	 * the RO image which doesn't support newer version of the command. In
+	 * this case we will attempt to update maximum supported version of the
+	 * EC_CMD_GET_NEXT_EVENT.
+	 */
+	if (ret == -ENOPROTOOPT) {
+		dev_dbg(ec_dev->dev,
+			"GET_NEXT_EVENT returned invalid version error.\n");
+		ret = cros_ec_get_host_command_version_mask(ec_dev,
+							EC_CMD_GET_NEXT_EVENT,
+							&ver_mask);
+		if (ret < 0 || ver_mask == 0)
+			/*
+			 * Do not change the MKBP supported version if we can't
+			 * obtain supported version correctly. Please note that
+			 * calling EC_CMD_GET_NEXT_EVENT returned
+			 * EC_RES_INVALID_VERSION which means that the command
+			 * is present.
+			 */
+			return -ENOPROTOOPT;
+
+		ec_dev->mkbp_event_supported = fls(ver_mask);
+		dev_dbg(ec_dev->dev, "MKBP support version changed to %u\n",
+			ec_dev->mkbp_event_supported - 1);
+
+		/* Try to get next event with new MKBP support version set. */
+		ret = get_next_event(ec_dev);
+	}
+
 	if (ret <= 0)
 		return ret;
 
diff --git a/drivers/platform/x86/msi-laptop.c b/drivers/platform/x86/msi-laptop.c
index 24ffc8e2d2d1..0e804b6c2d24 100644
--- a/drivers/platform/x86/msi-laptop.c
+++ b/drivers/platform/x86/msi-laptop.c
@@ -596,11 +596,10 @@ static const struct dmi_system_id msi_dmi_table[] __initconst = {
 	{
 		.ident = "MSI S270",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "MICRO-STAR INT'L CO.,LTD"),
+			DMI_MATCH(DMI_SYS_VENDOR, "MICRO-STAR INT"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "MS-1013"),
 			DMI_MATCH(DMI_PRODUCT_VERSION, "0131"),
-			DMI_MATCH(DMI_CHASSIS_VENDOR,
-				  "MICRO-STAR INT'L CO.,LTD")
+			DMI_MATCH(DMI_CHASSIS_VENDOR, "MICRO-STAR INT")
 		},
 		.driver_data = &quirk_old_ec_model,
 		.callback = dmi_check_cb
@@ -633,8 +632,7 @@ static const struct dmi_system_id msi_dmi_table[] __initconst = {
 			DMI_MATCH(DMI_SYS_VENDOR, "NOTEBOOK"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "SAM2000"),
 			DMI_MATCH(DMI_PRODUCT_VERSION, "0131"),
-			DMI_MATCH(DMI_CHASSIS_VENDOR,
-				  "MICRO-STAR INT'L CO.,LTD")
+			DMI_MATCH(DMI_CHASSIS_VENDOR, "MICRO-STAR INT")
 		},
 		.driver_data = &quirk_old_ec_model,
 		.callback = dmi_check_cb
@@ -1048,8 +1046,7 @@ static int __init msi_init(void)
 		return -EINVAL;
 
 	/* Register backlight stuff */
-
-	if (quirks->old_ec_model ||
+	if (quirks->old_ec_model &&
 	    acpi_video_get_backlight_type() == acpi_backlight_vendor) {
 		struct backlight_properties props;
 		memset(&props, 0, sizeof(struct backlight_properties));
@@ -1117,6 +1114,8 @@ static int __init msi_init(void)
 fail_create_group:
 	if (quirks->load_scm_model) {
 		i8042_remove_filter(msi_laptop_i8042_filter);
+		cancel_delayed_work_sync(&msi_touchpad_dwork);
+		input_unregister_device(msi_laptop_input_dev);
 		cancel_delayed_work_sync(&msi_rfkill_dwork);
 		cancel_work_sync(&msi_rfkill_work);
 		rfkill_cleanup();
@@ -1137,6 +1136,7 @@ static void __exit msi_cleanup(void)
 {
 	if (quirks->load_scm_model) {
 		i8042_remove_filter(msi_laptop_i8042_filter);
+		cancel_delayed_work_sync(&msi_touchpad_dwork);
 		input_unregister_device(msi_laptop_input_dev);
 		cancel_delayed_work_sync(&msi_rfkill_dwork);
 		cancel_work_sync(&msi_rfkill_work);
diff --git a/drivers/power/supply/adp5061.c b/drivers/power/supply/adp5061.c
index 003557043ab3..daee1161c305 100644
--- a/drivers/power/supply/adp5061.c
+++ b/drivers/power/supply/adp5061.c
@@ -427,11 +427,11 @@ static int adp5061_get_chg_type(struct adp5061_state *st,
 	if (ret < 0)
 		return ret;
 
-	chg_type = adp5061_chg_type[ADP5061_CHG_STATUS_1_CHG_STATUS(status1)];
-	if (chg_type > ADP5061_CHG_FAST_CV)
+	chg_type = ADP5061_CHG_STATUS_1_CHG_STATUS(status1);
+	if (chg_type >= ARRAY_SIZE(adp5061_chg_type))
 		val->intval = POWER_SUPPLY_STATUS_UNKNOWN;
 	else
-		val->intval = chg_type;
+		val->intval = adp5061_chg_type[chg_type];
 
 	return ret;
 }
diff --git a/drivers/powercap/intel_rapl_common.c b/drivers/powercap/intel_rapl_common.c
index 70d6d52bc1e2..285420c1eb7c 100644
--- a/drivers/powercap/intel_rapl_common.c
+++ b/drivers/powercap/intel_rapl_common.c
@@ -938,6 +938,9 @@ static u64 rapl_compute_time_window_core(struct rapl_package *rp, u64 value,
 		y = value & 0x1f;
 		value = (1 << y) * (4 + f) * rp->time_unit / 4;
 	} else {
+		if (value < rp->time_unit)
+			return 0;
+
 		do_div(value, rp->time_unit);
 		y = ilog2(value);
 		f = div64_u64(4 * (value - (1 << y)), 1 << y);
@@ -979,7 +982,6 @@ static const struct rapl_defaults rapl_defaults_spr_server = {
 	.check_unit = rapl_check_unit_core,
 	.set_floor_freq = set_floor_freq_default,
 	.compute_time_window = rapl_compute_time_window_core,
-	.dram_domain_energy_unit = 15300,
 	.psys_domain_energy_unit = 1000000000,
 };
 
diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 317d701487ec..bf8ba73d6c7c 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2544,7 +2544,7 @@ static int _regulator_do_enable(struct regulator_dev *rdev)
 	 * expired, return -ETIMEDOUT.
 	 */
 	if (rdev->desc->poll_enabled_time) {
-		unsigned int time_remaining = delay;
+		int time_remaining = delay;
 
 		while (time_remaining > 0) {
 			_regulator_enable_delay(rdev->desc->poll_enabled_time);
diff --git a/drivers/regulator/qcom_rpm-regulator.c b/drivers/regulator/qcom_rpm-regulator.c
index 7f9d66ac37ff..3c41b71a1f52 100644
--- a/drivers/regulator/qcom_rpm-regulator.c
+++ b/drivers/regulator/qcom_rpm-regulator.c
@@ -802,6 +802,12 @@ static const struct rpm_regulator_data rpm_pm8018_regulators[] = {
 };
 
 static const struct rpm_regulator_data rpm_pm8058_regulators[] = {
+	{ "s0",   QCOM_RPM_PM8058_SMPS0,  &pm8058_smps, "vdd_s0" },
+	{ "s1",   QCOM_RPM_PM8058_SMPS1,  &pm8058_smps, "vdd_s1" },
+	{ "s2",   QCOM_RPM_PM8058_SMPS2,  &pm8058_smps, "vdd_s2" },
+	{ "s3",   QCOM_RPM_PM8058_SMPS3,  &pm8058_smps, "vdd_s3" },
+	{ "s4",   QCOM_RPM_PM8058_SMPS4,  &pm8058_smps, "vdd_s4" },
+
 	{ "l0",   QCOM_RPM_PM8058_LDO0,   &pm8058_nldo, "vdd_l0_l1_lvs"	},
 	{ "l1",   QCOM_RPM_PM8058_LDO1,   &pm8058_nldo, "vdd_l0_l1_lvs" },
 	{ "l2",   QCOM_RPM_PM8058_LDO2,   &pm8058_pldo, "vdd_l2_l11_l12" },
@@ -829,12 +835,6 @@ static const struct rpm_regulator_data rpm_pm8058_regulators[] = {
 	{ "l24",  QCOM_RPM_PM8058_LDO24,  &pm8058_nldo, "vdd_l23_l24_l25" },
 	{ "l25",  QCOM_RPM_PM8058_LDO25,  &pm8058_nldo, "vdd_l23_l24_l25" },
 
-	{ "s0",   QCOM_RPM_PM8058_SMPS0,  &pm8058_smps, "vdd_s0" },
-	{ "s1",   QCOM_RPM_PM8058_SMPS1,  &pm8058_smps, "vdd_s1" },
-	{ "s2",   QCOM_RPM_PM8058_SMPS2,  &pm8058_smps, "vdd_s2" },
-	{ "s3",   QCOM_RPM_PM8058_SMPS3,  &pm8058_smps, "vdd_s3" },
-	{ "s4",   QCOM_RPM_PM8058_SMPS4,  &pm8058_smps, "vdd_s4" },
-
 	{ "lvs0", QCOM_RPM_PM8058_LVS0, &pm8058_switch, "vdd_l0_l1_lvs" },
 	{ "lvs1", QCOM_RPM_PM8058_LVS1, &pm8058_switch, "vdd_l0_l1_lvs" },
 
@@ -843,6 +843,12 @@ static const struct rpm_regulator_data rpm_pm8058_regulators[] = {
 };
 
 static const struct rpm_regulator_data rpm_pm8901_regulators[] = {
+	{ "s0",   QCOM_RPM_PM8901_SMPS0, &pm8901_ftsmps, "vdd_s0" },
+	{ "s1",   QCOM_RPM_PM8901_SMPS1, &pm8901_ftsmps, "vdd_s1" },
+	{ "s2",   QCOM_RPM_PM8901_SMPS2, &pm8901_ftsmps, "vdd_s2" },
+	{ "s3",   QCOM_RPM_PM8901_SMPS3, &pm8901_ftsmps, "vdd_s3" },
+	{ "s4",   QCOM_RPM_PM8901_SMPS4, &pm8901_ftsmps, "vdd_s4" },
+
 	{ "l0",   QCOM_RPM_PM8901_LDO0, &pm8901_nldo, "vdd_l0" },
 	{ "l1",   QCOM_RPM_PM8901_LDO1, &pm8901_pldo, "vdd_l1" },
 	{ "l2",   QCOM_RPM_PM8901_LDO2, &pm8901_pldo, "vdd_l2" },
@@ -851,12 +857,6 @@ static const struct rpm_regulator_data rpm_pm8901_regulators[] = {
 	{ "l5",   QCOM_RPM_PM8901_LDO5, &pm8901_pldo, "vdd_l5" },
 	{ "l6",   QCOM_RPM_PM8901_LDO6, &pm8901_pldo, "vdd_l6" },
 
-	{ "s0",   QCOM_RPM_PM8901_SMPS0, &pm8901_ftsmps, "vdd_s0" },
-	{ "s1",   QCOM_RPM_PM8901_SMPS1, &pm8901_ftsmps, "vdd_s1" },
-	{ "s2",   QCOM_RPM_PM8901_SMPS2, &pm8901_ftsmps, "vdd_s2" },
-	{ "s3",   QCOM_RPM_PM8901_SMPS3, &pm8901_ftsmps, "vdd_s3" },
-	{ "s4",   QCOM_RPM_PM8901_SMPS4, &pm8901_ftsmps, "vdd_s4" },
-
 	{ "lvs0", QCOM_RPM_PM8901_LVS0, &pm8901_switch, "lvs0_in" },
 	{ "lvs1", QCOM_RPM_PM8901_LVS1, &pm8901_switch, "lvs1_in" },
 	{ "lvs2", QCOM_RPM_PM8901_LVS2, &pm8901_switch, "lvs2_in" },
diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index 3337b1e80412..f6f92033132a 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -2014,7 +2014,7 @@ static int twa_probe(struct pci_dev *pdev, const struct pci_device_id *dev_id)
 	retval = pci_enable_device(pdev);
 	if (retval) {
 		TW_PRINTK(host, TW_DRIVER, 0x34, "Failed to enable pci device");
-		goto out_disable_device;
+		return -ENODEV;
 	}
 
 	pci_set_master(pdev);
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index df47557a02a3..6485c1aa9e74 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -558,6 +558,8 @@ iscsi_sw_tcp_conn_create(struct iscsi_cls_session *cls_session,
 	tcp_conn = conn->dd_data;
 	tcp_sw_conn = tcp_conn->dd_data;
 
+	mutex_init(&tcp_sw_conn->sock_lock);
+
 	tfm = crypto_alloc_ahash("crc32c", 0, CRYPTO_ALG_ASYNC);
 	if (IS_ERR(tfm))
 		goto free_conn;
@@ -592,11 +594,15 @@ iscsi_sw_tcp_conn_create(struct iscsi_cls_session *cls_session,
 
 static void iscsi_sw_tcp_release_conn(struct iscsi_conn *conn)
 {
-	struct iscsi_session *session = conn->session;
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
 	struct iscsi_sw_tcp_conn *tcp_sw_conn = tcp_conn->dd_data;
 	struct socket *sock = tcp_sw_conn->sock;
 
+	/*
+	 * The iscsi transport class will make sure we are not called in
+	 * parallel with start, stop, bind and destroys. However, this can be
+	 * called twice if userspace does a stop then a destroy.
+	 */
 	if (!sock)
 		return;
 
@@ -604,9 +610,9 @@ static void iscsi_sw_tcp_release_conn(struct iscsi_conn *conn)
 	iscsi_sw_tcp_conn_restore_callbacks(conn);
 	sock_put(sock->sk);
 
-	spin_lock_bh(&session->frwd_lock);
+	mutex_lock(&tcp_sw_conn->sock_lock);
 	tcp_sw_conn->sock = NULL;
-	spin_unlock_bh(&session->frwd_lock);
+	mutex_unlock(&tcp_sw_conn->sock_lock);
 	sockfd_put(sock);
 }
 
@@ -658,7 +664,6 @@ iscsi_sw_tcp_conn_bind(struct iscsi_cls_session *cls_session,
 		       struct iscsi_cls_conn *cls_conn, uint64_t transport_eph,
 		       int is_leading)
 {
-	struct iscsi_session *session = cls_session->dd_data;
 	struct iscsi_conn *conn = cls_conn->dd_data;
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
 	struct iscsi_sw_tcp_conn *tcp_sw_conn = tcp_conn->dd_data;
@@ -678,10 +683,10 @@ iscsi_sw_tcp_conn_bind(struct iscsi_cls_session *cls_session,
 	if (err)
 		goto free_socket;
 
-	spin_lock_bh(&session->frwd_lock);
+	mutex_lock(&tcp_sw_conn->sock_lock);
 	/* bind iSCSI connection and socket */
 	tcp_sw_conn->sock = sock;
-	spin_unlock_bh(&session->frwd_lock);
+	mutex_unlock(&tcp_sw_conn->sock_lock);
 
 	/* setup Socket parameters */
 	sk = sock->sk;
@@ -717,8 +722,15 @@ static int iscsi_sw_tcp_conn_set_param(struct iscsi_cls_conn *cls_conn,
 		break;
 	case ISCSI_PARAM_DATADGST_EN:
 		iscsi_set_param(cls_conn, param, buf, buflen);
+
+		mutex_lock(&tcp_sw_conn->sock_lock);
+		if (!tcp_sw_conn->sock) {
+			mutex_unlock(&tcp_sw_conn->sock_lock);
+			return -ENOTCONN;
+		}
 		tcp_sw_conn->sendpage = conn->datadgst_en ?
 			sock_no_sendpage : tcp_sw_conn->sock->ops->sendpage;
+		mutex_unlock(&tcp_sw_conn->sock_lock);
 		break;
 	case ISCSI_PARAM_MAX_R2T:
 		return iscsi_tcp_set_max_r2t(conn, buf);
@@ -733,8 +745,8 @@ static int iscsi_sw_tcp_conn_get_param(struct iscsi_cls_conn *cls_conn,
 				       enum iscsi_param param, char *buf)
 {
 	struct iscsi_conn *conn = cls_conn->dd_data;
-	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
-	struct iscsi_sw_tcp_conn *tcp_sw_conn = tcp_conn->dd_data;
+	struct iscsi_sw_tcp_conn *tcp_sw_conn;
+	struct iscsi_tcp_conn *tcp_conn;
 	struct sockaddr_in6 addr;
 	struct socket *sock;
 	int rc;
@@ -744,21 +756,36 @@ static int iscsi_sw_tcp_conn_get_param(struct iscsi_cls_conn *cls_conn,
 	case ISCSI_PARAM_CONN_ADDRESS:
 	case ISCSI_PARAM_LOCAL_PORT:
 		spin_lock_bh(&conn->session->frwd_lock);
-		if (!tcp_sw_conn || !tcp_sw_conn->sock) {
+		if (!conn->session->leadconn) {
 			spin_unlock_bh(&conn->session->frwd_lock);
 			return -ENOTCONN;
 		}
-		sock = tcp_sw_conn->sock;
-		sock_hold(sock->sk);
+		/*
+		 * The conn has been setup and bound, so just grab a ref
+		 * incase a destroy runs while we are in the net layer.
+		 */
+		iscsi_get_conn(conn->cls_conn);
 		spin_unlock_bh(&conn->session->frwd_lock);
 
+		tcp_conn = conn->dd_data;
+		tcp_sw_conn = tcp_conn->dd_data;
+
+		mutex_lock(&tcp_sw_conn->sock_lock);
+		sock = tcp_sw_conn->sock;
+		if (!sock) {
+			rc = -ENOTCONN;
+			goto sock_unlock;
+		}
+
 		if (param == ISCSI_PARAM_LOCAL_PORT)
 			rc = kernel_getsockname(sock,
 						(struct sockaddr *)&addr);
 		else
 			rc = kernel_getpeername(sock,
 						(struct sockaddr *)&addr);
-		sock_put(sock->sk);
+sock_unlock:
+		mutex_unlock(&tcp_sw_conn->sock_lock);
+		iscsi_put_conn(conn->cls_conn);
 		if (rc < 0)
 			return rc;
 
@@ -796,17 +823,21 @@ static int iscsi_sw_tcp_host_get_param(struct Scsi_Host *shost,
 		}
 		tcp_conn = conn->dd_data;
 		tcp_sw_conn = tcp_conn->dd_data;
-		sock = tcp_sw_conn->sock;
-		if (!sock) {
-			spin_unlock_bh(&session->frwd_lock);
-			return -ENOTCONN;
-		}
-		sock_hold(sock->sk);
+		/*
+		 * The conn has been setup and bound, so just grab a ref
+		 * incase a destroy runs while we are in the net layer.
+		 */
+		iscsi_get_conn(conn->cls_conn);
 		spin_unlock_bh(&session->frwd_lock);
 
-		rc = kernel_getsockname(sock,
-					(struct sockaddr *)&addr);
-		sock_put(sock->sk);
+		mutex_lock(&tcp_sw_conn->sock_lock);
+		sock = tcp_sw_conn->sock;
+		if (!sock)
+			rc = -ENOTCONN;
+		else
+			rc = kernel_getsockname(sock, (struct sockaddr *)&addr);
+		mutex_unlock(&tcp_sw_conn->sock_lock);
+		iscsi_put_conn(conn->cls_conn);
 		if (rc < 0)
 			return rc;
 
diff --git a/drivers/scsi/iscsi_tcp.h b/drivers/scsi/iscsi_tcp.h
index 791453195099..1731956326e2 100644
--- a/drivers/scsi/iscsi_tcp.h
+++ b/drivers/scsi/iscsi_tcp.h
@@ -28,6 +28,8 @@ struct iscsi_sw_tcp_send {
 
 struct iscsi_sw_tcp_conn {
 	struct socket		*sock;
+	/* Taken when accessing the sock from the netlink/sysfs interface */
+	struct mutex		sock_lock;
 
 	struct iscsi_sw_tcp_send out;
 	/* old values for socket callbacks */
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 8d6bcc19359f..51485d0251f2 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -85,7 +85,7 @@ static int smp_execute_task_sg(struct domain_device *dev,
 		res = i->dft->lldd_execute_task(task, GFP_KERNEL);
 
 		if (res) {
-			del_timer(&task->slow_task->timer);
+			del_timer_sync(&task->slow_task->timer);
 			pr_notice("executing SMP task failed:%d\n", res);
 			break;
 		}
diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index de5b6453827c..f48ef47546f4 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -1917,6 +1917,27 @@ static int qedf_vport_create(struct fc_vport *vport, bool disabled)
 		fc_vport_setlink(vn_port);
 	}
 
+	/* Set symbolic node name */
+	if (base_qedf->pdev->device == QL45xxx)
+		snprintf(fc_host_symbolic_name(vn_port->host), 256,
+			 "Marvell FastLinQ 45xxx FCoE v%s", QEDF_VERSION);
+
+	if (base_qedf->pdev->device == QL41xxx)
+		snprintf(fc_host_symbolic_name(vn_port->host), 256,
+			 "Marvell FastLinQ 41xxx FCoE v%s", QEDF_VERSION);
+
+	/* Set supported speed */
+	fc_host_supported_speeds(vn_port->host) = n_port->link_supported_speeds;
+
+	/* Set speed */
+	vn_port->link_speed = n_port->link_speed;
+
+	/* Set port type */
+	fc_host_port_type(vn_port->host) = FC_PORTTYPE_NPIV;
+
+	/* Set maxframe size */
+	fc_host_maxframe_size(vn_port->host) = n_port->mfs;
+
 	QEDF_INFO(&(base_qedf->dbg_ctx), QEDF_LOG_NPIV, "vn_port=%p.\n",
 		   vn_port);
 
diff --git a/drivers/soc/qcom/smem_state.c b/drivers/soc/qcom/smem_state.c
index d2b558438deb..41e929407196 100644
--- a/drivers/soc/qcom/smem_state.c
+++ b/drivers/soc/qcom/smem_state.c
@@ -136,6 +136,7 @@ static void qcom_smem_state_release(struct kref *ref)
 	struct qcom_smem_state *state = container_of(ref, struct qcom_smem_state, refcount);
 
 	list_del(&state->list);
+	of_node_put(state->of_node);
 	kfree(state);
 }
 
@@ -169,7 +170,7 @@ struct qcom_smem_state *qcom_smem_state_register(struct device_node *of_node,
 
 	kref_init(&state->refcount);
 
-	state->of_node = of_node;
+	state->of_node = of_node_get(of_node);
 	state->ops = *ops;
 	state->priv = priv;
 
diff --git a/drivers/soc/qcom/smsm.c b/drivers/soc/qcom/smsm.c
index 6564f15c5319..acba67dfbc85 100644
--- a/drivers/soc/qcom/smsm.c
+++ b/drivers/soc/qcom/smsm.c
@@ -511,7 +511,7 @@ static int qcom_smsm_probe(struct platform_device *pdev)
 	for (id = 0; id < smsm->num_hosts; id++) {
 		ret = smsm_parse_ipc(smsm, id);
 		if (ret < 0)
-			return ret;
+			goto out_put;
 	}
 
 	/* Acquire the main SMSM state vector */
@@ -519,13 +519,14 @@ static int qcom_smsm_probe(struct platform_device *pdev)
 			      smsm->num_entries * sizeof(u32));
 	if (ret < 0 && ret != -EEXIST) {
 		dev_err(&pdev->dev, "unable to allocate shared state entry\n");
-		return ret;
+		goto out_put;
 	}
 
 	states = qcom_smem_get(QCOM_SMEM_HOST_ANY, SMEM_SMSM_SHARED_STATE, NULL);
 	if (IS_ERR(states)) {
 		dev_err(&pdev->dev, "Unable to acquire shared state entry\n");
-		return PTR_ERR(states);
+		ret = PTR_ERR(states);
+		goto out_put;
 	}
 
 	/* Acquire the list of interrupt mask vectors */
@@ -533,13 +534,14 @@ static int qcom_smsm_probe(struct platform_device *pdev)
 	ret = qcom_smem_alloc(QCOM_SMEM_HOST_ANY, SMEM_SMSM_CPU_INTR_MASK, size);
 	if (ret < 0 && ret != -EEXIST) {
 		dev_err(&pdev->dev, "unable to allocate smsm interrupt mask\n");
-		return ret;
+		goto out_put;
 	}
 
 	intr_mask = qcom_smem_get(QCOM_SMEM_HOST_ANY, SMEM_SMSM_CPU_INTR_MASK, NULL);
 	if (IS_ERR(intr_mask)) {
 		dev_err(&pdev->dev, "unable to acquire shared memory interrupt mask\n");
-		return PTR_ERR(intr_mask);
+		ret = PTR_ERR(intr_mask);
+		goto out_put;
 	}
 
 	/* Setup the reference to the local state bits */
@@ -550,7 +552,8 @@ static int qcom_smsm_probe(struct platform_device *pdev)
 	smsm->state = qcom_smem_state_register(local_node, &smsm_state_ops, smsm);
 	if (IS_ERR(smsm->state)) {
 		dev_err(smsm->dev, "failed to register qcom_smem_state\n");
-		return PTR_ERR(smsm->state);
+		ret = PTR_ERR(smsm->state);
+		goto out_put;
 	}
 
 	/* Register handlers for remote processor entries of interest. */
@@ -580,16 +583,19 @@ static int qcom_smsm_probe(struct platform_device *pdev)
 	}
 
 	platform_set_drvdata(pdev, smsm);
+	of_node_put(local_node);
 
 	return 0;
 
 unwind_interfaces:
+	of_node_put(node);
 	for (id = 0; id < smsm->num_entries; id++)
 		if (smsm->entries[id].domain)
 			irq_domain_remove(smsm->entries[id].domain);
 
 	qcom_smem_state_unregister(smsm->state);
-
+out_put:
+	of_node_put(local_node);
 	return ret;
 }
 
diff --git a/drivers/soc/tegra/Kconfig b/drivers/soc/tegra/Kconfig
index 976dee036470..676807c5a215 100644
--- a/drivers/soc/tegra/Kconfig
+++ b/drivers/soc/tegra/Kconfig
@@ -136,7 +136,6 @@ config SOC_TEGRA_FUSE
 	def_bool y
 	depends on ARCH_TEGRA
 	select SOC_BUS
-	select TEGRA20_APB_DMA if ARCH_TEGRA_2x_SOC
 
 config SOC_TEGRA_FLOWCTRL
 	bool
diff --git a/drivers/soundwire/cadence_master.c b/drivers/soundwire/cadence_master.c
index c6d421a4b91b..a3247692ddc0 100644
--- a/drivers/soundwire/cadence_master.c
+++ b/drivers/soundwire/cadence_master.c
@@ -501,9 +501,12 @@ cdns_fill_msg_resp(struct sdw_cdns *cdns,
 		return SDW_CMD_IGNORED;
 	}
 
-	/* fill response */
-	for (i = 0; i < count; i++)
-		msg->buf[i + offset] = FIELD_GET(CDNS_MCP_RESP_RDATA, cdns->response_buf[i]);
+	if (msg->flags == SDW_MSG_FLAG_READ) {
+		/* fill response */
+		for (i = 0; i < count; i++)
+			msg->buf[i + offset] = FIELD_GET(CDNS_MCP_RESP_RDATA,
+							 cdns->response_buf[i]);
+	}
 
 	return SDW_CMD_OK;
 }
diff --git a/drivers/soundwire/intel.c b/drivers/soundwire/intel.c
index 824d9f900aca..942d2fe13218 100644
--- a/drivers/soundwire/intel.c
+++ b/drivers/soundwire/intel.c
@@ -1470,7 +1470,6 @@ int intel_master_startup(struct platform_device *pdev)
 	ret = intel_register_dai(sdw);
 	if (ret) {
 		dev_err(dev, "DAI registration failed: %d\n", ret);
-		snd_soc_unregister_component(dev);
 		goto err_interrupt;
 	}
 
diff --git a/drivers/spi/spi-dw-bt1.c b/drivers/spi/spi-dw-bt1.c
index bc9d5eab3c58..8f6a1af14456 100644
--- a/drivers/spi/spi-dw-bt1.c
+++ b/drivers/spi/spi-dw-bt1.c
@@ -293,8 +293,10 @@ static int dw_spi_bt1_probe(struct platform_device *pdev)
 	pm_runtime_enable(&pdev->dev);
 
 	ret = dw_spi_add_host(&pdev->dev, dws);
-	if (ret)
+	if (ret) {
+		pm_runtime_disable(&pdev->dev);
 		goto err_disable_clk;
+	}
 
 	platform_set_drvdata(pdev, dwsbt1);
 
diff --git a/drivers/spi/spi-meson-spicc.c b/drivers/spi/spi-meson-spicc.c
index e4cb52e1fe26..6974a1c947aa 100644
--- a/drivers/spi/spi-meson-spicc.c
+++ b/drivers/spi/spi-meson-spicc.c
@@ -537,7 +537,7 @@ static unsigned long meson_spicc_pow2_recalc_rate(struct clk_hw *hw,
 	struct clk_divider *divider = to_clk_divider(hw);
 	struct meson_spicc_device *spicc = pow2_clk_to_spicc(divider);
 
-	if (!spicc->master->cur_msg || !spicc->master->busy)
+	if (!spicc->master->cur_msg)
 		return 0;
 
 	return clk_divider_ops.recalc_rate(hw, parent_rate);
@@ -549,7 +549,7 @@ static int meson_spicc_pow2_determine_rate(struct clk_hw *hw,
 	struct clk_divider *divider = to_clk_divider(hw);
 	struct meson_spicc_device *spicc = pow2_clk_to_spicc(divider);
 
-	if (!spicc->master->cur_msg || !spicc->master->busy)
+	if (!spicc->master->cur_msg)
 		return -EINVAL;
 
 	return clk_divider_ops.determine_rate(hw, req);
@@ -561,7 +561,7 @@ static int meson_spicc_pow2_set_rate(struct clk_hw *hw, unsigned long rate,
 	struct clk_divider *divider = to_clk_divider(hw);
 	struct meson_spicc_device *spicc = pow2_clk_to_spicc(divider);
 
-	if (!spicc->master->cur_msg || !spicc->master->busy)
+	if (!spicc->master->cur_msg)
 		return -EINVAL;
 
 	return clk_divider_ops.set_rate(hw, rate, parent_rate);
diff --git a/drivers/spi/spi-mt7621.c b/drivers/spi/spi-mt7621.c
index b4b9b7309b5e..351b0ef52bbc 100644
--- a/drivers/spi/spi-mt7621.c
+++ b/drivers/spi/spi-mt7621.c
@@ -340,11 +340,9 @@ static int mt7621_spi_probe(struct platform_device *pdev)
 		return PTR_ERR(base);
 
 	clk = devm_clk_get(&pdev->dev, NULL);
-	if (IS_ERR(clk)) {
-		dev_err(&pdev->dev, "unable to get SYS clock, err=%d\n",
-			status);
-		return PTR_ERR(clk);
-	}
+	if (IS_ERR(clk))
+		return dev_err_probe(&pdev->dev, PTR_ERR(clk),
+				     "unable to get SYS clock\n");
 
 	status = clk_prepare_enable(clk);
 	if (status)
diff --git a/drivers/spi/spi-omap-100k.c b/drivers/spi/spi-omap-100k.c
index 0d0cd061d356..7c992d1f4abd 100644
--- a/drivers/spi/spi-omap-100k.c
+++ b/drivers/spi/spi-omap-100k.c
@@ -414,6 +414,7 @@ static int omap1_spi100k_probe(struct platform_device *pdev)
 	return status;
 
 err_fck:
+	pm_runtime_disable(&pdev->dev);
 	clk_disable_unprepare(spi100k->fck);
 err_ick:
 	clk_disable_unprepare(spi100k->ick);
diff --git a/drivers/spi/spi-qup.c b/drivers/spi/spi-qup.c
index d39dec6d1c91..f3877eeb3da6 100644
--- a/drivers/spi/spi-qup.c
+++ b/drivers/spi/spi-qup.c
@@ -1199,8 +1199,10 @@ static int spi_qup_pm_resume_runtime(struct device *device)
 		return ret;
 
 	ret = clk_prepare_enable(controller->cclk);
-	if (ret)
+	if (ret) {
+		clk_disable_unprepare(controller->iclk);
 		return ret;
+	}
 
 	/* Disable clocks auto gaiting */
 	config = readl_relaxed(controller->base + QUP_CONFIG);
@@ -1246,14 +1248,25 @@ static int spi_qup_resume(struct device *device)
 		return ret;
 
 	ret = clk_prepare_enable(controller->cclk);
-	if (ret)
+	if (ret) {
+		clk_disable_unprepare(controller->iclk);
 		return ret;
+	}
 
 	ret = spi_qup_set_state(controller, QUP_STATE_RESET);
 	if (ret)
-		return ret;
+		goto disable_clk;
 
-	return spi_master_resume(master);
+	ret = spi_master_resume(master);
+	if (ret)
+		goto disable_clk;
+
+	return 0;
+
+disable_clk:
+	clk_disable_unprepare(controller->cclk);
+	clk_disable_unprepare(controller->iclk);
+	return ret;
 }
 #endif /* CONFIG_PM_SLEEP */
 
diff --git a/drivers/spi/spi-s3c64xx.c b/drivers/spi/spi-s3c64xx.c
index dfa7c91e13aa..d435df1b715b 100644
--- a/drivers/spi/spi-s3c64xx.c
+++ b/drivers/spi/spi-s3c64xx.c
@@ -84,6 +84,7 @@
 #define S3C64XX_SPI_ST_TX_FIFORDY		(1<<0)
 
 #define S3C64XX_SPI_PACKET_CNT_EN		(1<<16)
+#define S3C64XX_SPI_PACKET_CNT_MASK		GENMASK(15, 0)
 
 #define S3C64XX_SPI_PND_TX_UNDERRUN_CLR		(1<<4)
 #define S3C64XX_SPI_PND_TX_OVERRUN_CLR		(1<<3)
@@ -660,6 +661,13 @@ static int s3c64xx_spi_prepare_message(struct spi_master *master,
 	return 0;
 }
 
+static size_t s3c64xx_spi_max_transfer_size(struct spi_device *spi)
+{
+	struct spi_controller *ctlr = spi->controller;
+
+	return ctlr->can_dma ? S3C64XX_SPI_PACKET_CNT_MASK : SIZE_MAX;
+}
+
 static int s3c64xx_spi_transfer_one(struct spi_master *master,
 				    struct spi_device *spi,
 				    struct spi_transfer *xfer)
@@ -1135,6 +1143,7 @@ static int s3c64xx_spi_probe(struct platform_device *pdev)
 	master->prepare_transfer_hardware = s3c64xx_spi_prepare_transfer;
 	master->prepare_message = s3c64xx_spi_prepare_message;
 	master->transfer_one = s3c64xx_spi_transfer_one;
+	master->max_transfer_size = s3c64xx_spi_max_transfer_size;
 	master->num_chipselect = sci->num_cs;
 	master->dma_alignment = 8;
 	master->bits_per_word_mask = SPI_BPW_MASK(32) | SPI_BPW_MASK(16) |
diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 6ea7b286c80c..857a1399850c 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -946,6 +946,8 @@ void spi_unmap_buf(struct spi_controller *ctlr, struct device *dev,
 	if (sgt->orig_nents) {
 		dma_unmap_sg(dev, sgt->sgl, sgt->orig_nents, dir);
 		sg_free_table(sgt);
+		sgt->orig_nents = 0;
+		sgt->nents = 0;
 	}
 }
 
diff --git a/drivers/spmi/spmi-pmic-arb.c b/drivers/spmi/spmi-pmic-arb.c
index bbbd311eda03..e6de2aeece8d 100644
--- a/drivers/spmi/spmi-pmic-arb.c
+++ b/drivers/spmi/spmi-pmic-arb.c
@@ -887,7 +887,8 @@ static int pmic_arb_read_apid_map_v5(struct spmi_pmic_arb *pmic_arb)
 	 * version 5, there is more than one APID mapped to each PPID.
 	 * The owner field for each of these mappings specifies the EE which is
 	 * allowed to write to the APID.  The owner of the last (highest) APID
-	 * for a given PPID will receive interrupts from the PPID.
+	 * which has the IRQ owner bit set for a given PPID will receive
+	 * interrupts from the PPID.
 	 */
 	for (i = 0; ; i++, apidd++) {
 		offset = pmic_arb->ver_ops->apid_map_offset(i);
@@ -910,16 +911,16 @@ static int pmic_arb_read_apid_map_v5(struct spmi_pmic_arb *pmic_arb)
 		apid = pmic_arb->ppid_to_apid[ppid] & ~PMIC_ARB_APID_VALID;
 		prev_apidd = &pmic_arb->apid_data[apid];
 
-		if (valid && is_irq_ee &&
-				prev_apidd->write_ee == pmic_arb->ee) {
+		if (!valid || apidd->write_ee == pmic_arb->ee) {
+			/* First PPID mapping or one for this EE */
+			pmic_arb->ppid_to_apid[ppid] = i | PMIC_ARB_APID_VALID;
+		} else if (valid && is_irq_ee &&
+			   prev_apidd->write_ee == pmic_arb->ee) {
 			/*
 			 * Duplicate PPID mapping after the one for this EE;
 			 * override the irq owner
 			 */
 			prev_apidd->irq_ee = apidd->irq_ee;
-		} else if (!valid || is_irq_ee) {
-			/* First PPID mapping or duplicate for another EE */
-			pmic_arb->ppid_to_apid[ppid] = i | PMIC_ARB_APID_VALID;
 		}
 
 		apidd->ppid = ppid;
diff --git a/drivers/staging/greybus/audio_helper.c b/drivers/staging/greybus/audio_helper.c
index a9576f92efaa..08443f4aa045 100644
--- a/drivers/staging/greybus/audio_helper.c
+++ b/drivers/staging/greybus/audio_helper.c
@@ -3,7 +3,6 @@
  * Greybus Audio Sound SoC helper APIs
  */
 
-#include <linux/debugfs.h>
 #include <sound/core.h>
 #include <sound/soc.h>
 #include <sound/soc-dapm.h>
@@ -116,10 +115,6 @@ int gbaudio_dapm_free_controls(struct snd_soc_dapm_context *dapm,
 {
 	int i;
 	struct snd_soc_dapm_widget *w, *next_w;
-#ifdef CONFIG_DEBUG_FS
-	struct dentry *parent = dapm->debugfs_dapm;
-	struct dentry *debugfs_w = NULL;
-#endif
 
 	mutex_lock(&dapm->card->dapm_mutex);
 	for (i = 0; i < num; i++) {
@@ -139,12 +134,6 @@ int gbaudio_dapm_free_controls(struct snd_soc_dapm_context *dapm,
 			continue;
 		}
 		widget++;
-#ifdef CONFIG_DEBUG_FS
-		if (!parent)
-			debugfs_w = debugfs_lookup(w->name, parent);
-		debugfs_remove(debugfs_w);
-		debugfs_w = NULL;
-#endif
 		gbaudio_dapm_free_widget(w);
 	}
 	mutex_unlock(&dapm->card->dapm_mutex);
diff --git a/drivers/staging/media/meson/vdec/vdec_hevc.c b/drivers/staging/media/meson/vdec/vdec_hevc.c
index 9530e580e57a..afced435c907 100644
--- a/drivers/staging/media/meson/vdec/vdec_hevc.c
+++ b/drivers/staging/media/meson/vdec/vdec_hevc.c
@@ -167,8 +167,12 @@ static int vdec_hevc_start(struct amvdec_session *sess)
 
 	clk_set_rate(core->vdec_hevc_clk, 666666666);
 	ret = clk_prepare_enable(core->vdec_hevc_clk);
-	if (ret)
+	if (ret) {
+		if (core->platform->revision == VDEC_REVISION_G12A ||
+		    core->platform->revision == VDEC_REVISION_SM1)
+			clk_disable_unprepare(core->vdec_hevcf_clk);
 		return ret;
+	}
 
 	if (core->platform->revision == VDEC_REVISION_SM1)
 		regmap_update_bits(core->regmap_ao, AO_RTI_GEN_PWR_SLEEP0,
diff --git a/drivers/staging/media/sunxi/cedrus/cedrus.c b/drivers/staging/media/sunxi/cedrus/cedrus.c
index 1dd833757c4e..28de90edf4cc 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus.c
@@ -399,6 +399,8 @@ static int cedrus_probe(struct platform_device *pdev)
 	if (!dev)
 		return -ENOMEM;
 
+	platform_set_drvdata(pdev, dev);
+
 	dev->vfd = cedrus_video_device;
 	dev->dev = &pdev->dev;
 	dev->pdev = pdev;
@@ -469,8 +471,6 @@ static int cedrus_probe(struct platform_device *pdev)
 		goto err_m2m_mc;
 	}
 
-	platform_set_drvdata(pdev, dev);
-
 	return 0;
 
 err_m2m_mc:
diff --git a/drivers/staging/rtl8723bs/core/rtw_cmd.c b/drivers/staging/rtl8723bs/core/rtw_cmd.c
index 2abe205e3453..cee05385f872 100644
--- a/drivers/staging/rtl8723bs/core/rtw_cmd.c
+++ b/drivers/staging/rtl8723bs/core/rtw_cmd.c
@@ -165,8 +165,6 @@ No irqsave is necessary.
 
 int rtw_init_cmd_priv(struct	cmd_priv *pcmdpriv)
 {
-	int res = 0;
-
 	init_completion(&pcmdpriv->cmd_queue_comp);
 	init_completion(&pcmdpriv->terminate_cmdthread_comp);
 
@@ -178,18 +176,16 @@ int rtw_init_cmd_priv(struct	cmd_priv *pcmdpriv)
 
 	pcmdpriv->cmd_allocated_buf = rtw_zmalloc(MAX_CMDSZ + CMDBUFF_ALIGN_SZ);
 
-	if (!pcmdpriv->cmd_allocated_buf) {
-		res = -ENOMEM;
-		goto exit;
-	}
+	if (!pcmdpriv->cmd_allocated_buf)
+		return -ENOMEM;
 
 	pcmdpriv->cmd_buf = pcmdpriv->cmd_allocated_buf  +  CMDBUFF_ALIGN_SZ - ((SIZE_PTR)(pcmdpriv->cmd_allocated_buf) & (CMDBUFF_ALIGN_SZ-1));
 
 	pcmdpriv->rsp_allocated_buf = rtw_zmalloc(MAX_RSPSZ + 4);
 
 	if (!pcmdpriv->rsp_allocated_buf) {
-		res = -ENOMEM;
-		goto exit;
+		kfree(pcmdpriv->cmd_allocated_buf);
+		return -ENOMEM;
 	}
 
 	pcmdpriv->rsp_buf = pcmdpriv->rsp_allocated_buf  +  4 - ((SIZE_PTR)(pcmdpriv->rsp_allocated_buf) & 3);
@@ -199,8 +195,8 @@ int rtw_init_cmd_priv(struct	cmd_priv *pcmdpriv)
 	pcmdpriv->rsp_cnt = 0;
 
 	mutex_init(&pcmdpriv->sctx_mutex);
-exit:
-	return res;
+
+	return 0;
 }
 
 static void c2h_wk_callback(_workitem * work);
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 09ab6d6f2429..343f0de03154 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -564,7 +564,7 @@ static int device_init_rd0_ring(struct vnt_private *priv)
 	kfree(desc->rd_info);
 
 err_free_desc:
-	while (--i) {
+	while (i--) {
 		desc = &priv->aRD0Ring[i];
 		device_free_rx_buf(priv, desc);
 		kfree(desc->rd_info);
@@ -610,7 +610,7 @@ static int device_init_rd1_ring(struct vnt_private *priv)
 	kfree(desc->rd_info);
 
 err_free_desc:
-	while (--i) {
+	while (i--) {
 		desc = &priv->aRD1Ring[i];
 		device_free_rx_buf(priv, desc);
 		kfree(desc->rd_info);
@@ -675,7 +675,7 @@ static int device_init_td0_ring(struct vnt_private *priv)
 	return 0;
 
 err_free_desc:
-	while (--i) {
+	while (i--) {
 		desc = &priv->apTD0Rings[i];
 		kfree(desc->td_info);
 	}
@@ -715,7 +715,7 @@ static int device_init_td1_ring(struct vnt_private *priv)
 	return 0;
 
 err_free_desc:
-	while (--i) {
+	while (i--) {
 		desc = &priv->apTD1Rings[i];
 		kfree(desc->td_info);
 	}
diff --git a/drivers/thermal/intel/intel_powerclamp.c b/drivers/thermal/intel/intel_powerclamp.c
index b0eb5ece9243..fb04470d7d4b 100644
--- a/drivers/thermal/intel/intel_powerclamp.c
+++ b/drivers/thermal/intel/intel_powerclamp.c
@@ -531,9 +531,7 @@ static int start_power_clamp(void)
 	get_online_cpus();
 
 	/* prefer BSP */
-	control_cpu = 0;
-	if (!cpu_online(control_cpu))
-		control_cpu = smp_processor_id();
+	control_cpu = cpumask_first(cpu_online_mask);
 
 	clamping = true;
 	schedule_delayed_work(&poll_pkg_cstate_work, 0);
diff --git a/drivers/thermal/qcom/tsens-v0_1.c b/drivers/thermal/qcom/tsens-v0_1.c
index 4ffa2e2c0145..9b8ba429a304 100644
--- a/drivers/thermal/qcom/tsens-v0_1.c
+++ b/drivers/thermal/qcom/tsens-v0_1.c
@@ -522,7 +522,7 @@ static const struct tsens_ops ops_8939 = {
 struct tsens_plat_data data_8939 = {
 	.num_sensors	= 10,
 	.ops		= &ops_8939,
-	.hw_ids		= (unsigned int []){ 0, 1, 2, 4, 5, 6, 7, 8, 9, 10 },
+	.hw_ids		= (unsigned int []){ 0, 1, 2, 3, 5, 6, 7, 8, 9, 10 },
 
 	.feat		= &tsens_v0_1_feat,
 	.fields	= tsens_v0_1_regfields,
diff --git a/drivers/thunderbolt/switch.c b/drivers/thunderbolt/switch.c
index 65f99d744654..e881b72833dc 100644
--- a/drivers/thunderbolt/switch.c
+++ b/drivers/thunderbolt/switch.c
@@ -2413,6 +2413,26 @@ void tb_switch_unconfigure_link(struct tb_switch *sw)
 		tb_lc_unconfigure_port(down);
 }
 
+static int tb_switch_port_hotplug_enable(struct tb_switch *sw)
+{
+	struct tb_port *port;
+
+	if (tb_switch_is_icm(sw))
+		return 0;
+
+	tb_switch_for_each_port(sw, port) {
+		int res;
+
+		if (!port->cap_usb4)
+			continue;
+
+		res = usb4_port_hotplug_enable(port);
+		if (res)
+			return res;
+	}
+	return 0;
+}
+
 /**
  * tb_switch_add() - Add a switch to the domain
  * @sw: Switch to add
@@ -2480,6 +2500,10 @@ int tb_switch_add(struct tb_switch *sw)
 			return ret;
 	}
 
+	ret = tb_switch_port_hotplug_enable(sw);
+	if (ret)
+		return ret;
+
 	ret = device_add(&sw->dev);
 	if (ret) {
 		dev_err(&sw->dev, "failed to add device: %d\n", ret);
diff --git a/drivers/thunderbolt/tb.h b/drivers/thunderbolt/tb.h
index 8ea360b0ff77..266f3bf8ff5c 100644
--- a/drivers/thunderbolt/tb.h
+++ b/drivers/thunderbolt/tb.h
@@ -979,6 +979,7 @@ struct tb_port *usb4_switch_map_usb3_down(struct tb_switch *sw,
 					  const struct tb_port *port);
 
 int usb4_port_unlock(struct tb_port *port);
+int usb4_port_hotplug_enable(struct tb_port *port);
 int usb4_port_configure(struct tb_port *port);
 void usb4_port_unconfigure(struct tb_port *port);
 int usb4_port_configure_xdomain(struct tb_port *port);
diff --git a/drivers/thunderbolt/tb_regs.h b/drivers/thunderbolt/tb_regs.h
index e7d9529822fa..26868e2f9d0b 100644
--- a/drivers/thunderbolt/tb_regs.h
+++ b/drivers/thunderbolt/tb_regs.h
@@ -285,6 +285,7 @@ struct tb_regs_port_header {
 #define ADP_CS_5				0x05
 #define ADP_CS_5_LCA_MASK			GENMASK(28, 22)
 #define ADP_CS_5_LCA_SHIFT			22
+#define ADP_CS_5_DHP				BIT(31)
 
 /* TMU adapter registers */
 #define TMU_ADP_CS_3				0x03
diff --git a/drivers/thunderbolt/usb4.c b/drivers/thunderbolt/usb4.c
index c05ec6fad77f..0b3a77ade04d 100644
--- a/drivers/thunderbolt/usb4.c
+++ b/drivers/thunderbolt/usb4.c
@@ -854,6 +854,26 @@ int usb4_port_unlock(struct tb_port *port)
 	return tb_port_write(port, &val, TB_CFG_PORT, ADP_CS_4, 1);
 }
 
+/**
+ * usb4_port_hotplug_enable() - Enables hotplug for a port
+ * @port: USB4 port to operate on
+ *
+ * Enables hot plug events on a given port. This is only intended
+ * to be used on lane, DP-IN, and DP-OUT adapters.
+ */
+int usb4_port_hotplug_enable(struct tb_port *port)
+{
+	int ret;
+	u32 val;
+
+	ret = tb_port_read(port, &val, TB_CFG_PORT, ADP_CS_5, 1);
+	if (ret)
+		return ret;
+
+	val &= ~ADP_CS_5_DHP;
+	return tb_port_write(port, &val, TB_CFG_PORT, ADP_CS_5, 1);
+}
+
 static int usb4_port_set_configured(struct tb_port *port, bool configured)
 {
 	int ret;
diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index 98ce484f1089..0a7e9491b4d1 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -310,10 +310,9 @@ static void serial8250_backup_timeout(struct timer_list *t)
 		jiffies + uart_poll_timeout(&up->port) + HZ / 5);
 }
 
-static int univ8250_setup_irq(struct uart_8250_port *up)
+static void univ8250_setup_timer(struct uart_8250_port *up)
 {
 	struct uart_port *port = &up->port;
-	int retval = 0;
 
 	/*
 	 * The above check will only give an accurate result the first time
@@ -332,12 +331,18 @@ static int univ8250_setup_irq(struct uart_8250_port *up)
 	 * hardware interrupt, we use a timer-based system.  The original
 	 * driver used to do this with IRQ0.
 	 */
-	if (!port->irq) {
+	if (!port->irq)
 		mod_timer(&up->timer, jiffies + uart_poll_timeout(port));
-	} else
-		retval = serial_link_irq_chain(up);
+}
 
-	return retval;
+static int univ8250_setup_irq(struct uart_8250_port *up)
+{
+	struct uart_port *port = &up->port;
+
+	if (port->irq)
+		return serial_link_irq_chain(up);
+
+	return 0;
 }
 
 static void univ8250_release_irq(struct uart_8250_port *up)
@@ -393,6 +398,7 @@ static struct uart_ops univ8250_port_ops;
 static const struct uart_8250_ops univ8250_driver_ops = {
 	.setup_irq	= univ8250_setup_irq,
 	.release_irq	= univ8250_release_irq,
+	.setup_timer	= univ8250_setup_timer,
 };
 
 static struct uart_8250_port serial8250_ports[UART_NR];
@@ -766,6 +772,7 @@ void serial8250_suspend_port(int line)
 	if (!console_suspend_enabled && uart_console(port) &&
 	    port->type != PORT_8250) {
 		unsigned char canary = 0xa5;
+
 		serial_out(up, UART_SCR, canary);
 		if (serial_in(up, UART_SCR) == canary)
 			up->canary = canary;
diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/8250/8250_port.c
index 9d60418e4adb..71d143c00248 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -2276,6 +2276,10 @@ int serial8250_do_startup(struct uart_port *port)
 	if (port->irq && (up->port.flags & UPF_SHARE_IRQ))
 		up->port.irqflags |= IRQF_SHARED;
 
+	retval = up->ops->setup_irq(up);
+	if (retval)
+		goto out;
+
 	if (port->irq && !(up->port.flags & UPF_NO_THRE_TEST)) {
 		unsigned char iir1;
 
@@ -2318,9 +2322,7 @@ int serial8250_do_startup(struct uart_port *port)
 		}
 	}
 
-	retval = up->ops->setup_irq(up);
-	if (retval)
-		goto out;
+	up->ops->setup_timer(up);
 
 	/*
 	 * Now, initialize the UART
@@ -3286,8 +3288,13 @@ static void serial8250_console_restore(struct uart_8250_port *up)
 	unsigned int baud, quot, frac = 0;
 
 	termios.c_cflag = port->cons->cflag;
-	if (port->state->port.tty && termios.c_cflag == 0)
+	termios.c_ispeed = port->cons->ispeed;
+	termios.c_ospeed = port->cons->ospeed;
+	if (port->state->port.tty && termios.c_cflag == 0) {
 		termios.c_cflag = port->state->port.tty->termios.c_cflag;
+		termios.c_ispeed = port->state->port.tty->termios.c_ispeed;
+		termios.c_ospeed = port->state->port.tty->termios.c_ospeed;
+	}
 
 	baud = serial8250_get_baud_rate(port, &termios, NULL);
 	quot = serial8250_get_divisor(port, baud, &frac);
diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index a2c4eab0b470..269d1e3a025d 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -1725,6 +1725,7 @@ static void lpuart_dma_shutdown(struct lpuart_port *sport)
 	if (sport->lpuart_dma_rx_use) {
 		del_timer_sync(&sport->lpuart_timer);
 		lpuart_dma_rx_free(&sport->port);
+		sport->lpuart_dma_rx_use = false;
 	}
 
 	if (sport->lpuart_dma_tx_use) {
@@ -1733,6 +1734,7 @@ static void lpuart_dma_shutdown(struct lpuart_port *sport)
 			sport->dma_tx_in_progress = false;
 			dmaengine_terminate_all(sport->dma_tx_chan);
 		}
+		sport->lpuart_dma_tx_use = false;
 	}
 
 	if (sport->dma_tx_chan)
diff --git a/drivers/tty/serial/jsm/jsm_driver.c b/drivers/tty/serial/jsm/jsm_driver.c
index cd30da0ef083..b5b61e598b53 100644
--- a/drivers/tty/serial/jsm/jsm_driver.c
+++ b/drivers/tty/serial/jsm/jsm_driver.c
@@ -212,7 +212,8 @@ static int jsm_probe_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 		break;
 	default:
-		return -ENXIO;
+		rc = -ENXIO;
+		goto out_kfree_brd;
 	}
 
 	rc = request_irq(brd->irq, brd->bd_ops->intr, IRQF_SHARED, "JSM", brd);
diff --git a/drivers/tty/serial/xilinx_uartps.c b/drivers/tty/serial/xilinx_uartps.c
index b5a8afbc452b..f7dfa123907a 100644
--- a/drivers/tty/serial/xilinx_uartps.c
+++ b/drivers/tty/serial/xilinx_uartps.c
@@ -375,6 +375,8 @@ static irqreturn_t cdns_uart_isr(int irq, void *dev_id)
 		isrstatus &= ~CDNS_UART_IXR_TXEMPTY;
 	}
 
+	isrstatus &= port->read_status_mask;
+	isrstatus &= ~port->ignore_status_mask;
 	/*
 	 * Skip RX processing if RX is disabled as RXEMPTY will never be set
 	 * as read bytes will not be removed from the FIFO.
diff --git a/drivers/usb/common/common.c b/drivers/usb/common/common.c
index 1433260d99b4..347fb3d3894a 100644
--- a/drivers/usb/common/common.c
+++ b/drivers/usb/common/common.c
@@ -25,6 +25,12 @@ static const char *const ep_type_names[] = {
 	[USB_ENDPOINT_XFER_INT] = "intr",
 };
 
+/**
+ * usb_ep_type_string() - Returns human readable-name of the endpoint type.
+ * @ep_type: The endpoint type to return human-readable name for.  If it's not
+ *   any of the types: USB_ENDPOINT_XFER_{CONTROL, ISOC, BULK, INT},
+ *   usually got by usb_endpoint_type(), the string 'unknown' will be returned.
+ */
 const char *usb_ep_type_string(int ep_type)
 {
 	if (ep_type < 0 || ep_type >= ARRAY_SIZE(ep_type_names))
@@ -69,6 +75,19 @@ static const char *const speed_names[] = {
 	[USB_SPEED_SUPER_PLUS] = "super-speed-plus",
 };
 
+static const char *const ssp_rate[] = {
+	[USB_SSP_GEN_UNKNOWN] = "UNKNOWN",
+	[USB_SSP_GEN_2x1] = "super-speed-plus-gen2x1",
+	[USB_SSP_GEN_1x2] = "super-speed-plus-gen1x2",
+	[USB_SSP_GEN_2x2] = "super-speed-plus-gen2x2",
+};
+
+/**
+ * usb_speed_string() - Returns human readable-name of the speed.
+ * @speed: The speed to return human-readable name for.  If it's not
+ *   any of the speeds defined in usb_device_speed enum, string for
+ *   USB_SPEED_UNKNOWN will be returned.
+ */
 const char *usb_speed_string(enum usb_device_speed speed)
 {
 	if (speed < 0 || speed >= ARRAY_SIZE(speed_names))
@@ -77,6 +96,14 @@ const char *usb_speed_string(enum usb_device_speed speed)
 }
 EXPORT_SYMBOL_GPL(usb_speed_string);
 
+/**
+ * usb_get_maximum_speed - Get maximum requested speed for a given USB
+ * controller.
+ * @dev: Pointer to the given USB controller device
+ *
+ * The function gets the maximum speed string from property "maximum-speed",
+ * and returns the corresponding enum usb_device_speed.
+ */
 enum usb_device_speed usb_get_maximum_speed(struct device *dev)
 {
 	const char *maximum_speed;
@@ -86,12 +113,44 @@ enum usb_device_speed usb_get_maximum_speed(struct device *dev)
 	if (ret < 0)
 		return USB_SPEED_UNKNOWN;
 
-	ret = match_string(speed_names, ARRAY_SIZE(speed_names), maximum_speed);
+	ret = match_string(ssp_rate, ARRAY_SIZE(ssp_rate), maximum_speed);
+	if (ret > 0)
+		return USB_SPEED_SUPER_PLUS;
 
+	ret = match_string(speed_names, ARRAY_SIZE(speed_names), maximum_speed);
 	return (ret < 0) ? USB_SPEED_UNKNOWN : ret;
 }
 EXPORT_SYMBOL_GPL(usb_get_maximum_speed);
 
+/**
+ * usb_get_maximum_ssp_rate - Get the signaling rate generation and lane count
+ *	of a SuperSpeed Plus capable device.
+ * @dev: Pointer to the given USB controller device
+ *
+ * If the string from "maximum-speed" property is super-speed-plus-genXxY where
+ * 'X' is the generation number and 'Y' is the number of lanes, then this
+ * function returns the corresponding enum usb_ssp_rate.
+ */
+enum usb_ssp_rate usb_get_maximum_ssp_rate(struct device *dev)
+{
+	const char *maximum_speed;
+	int ret;
+
+	ret = device_property_read_string(dev, "maximum-speed", &maximum_speed);
+	if (ret < 0)
+		return USB_SSP_GEN_UNKNOWN;
+
+	ret = match_string(ssp_rate, ARRAY_SIZE(ssp_rate), maximum_speed);
+	return (ret < 0) ? USB_SSP_GEN_UNKNOWN : ret;
+}
+EXPORT_SYMBOL_GPL(usb_get_maximum_ssp_rate);
+
+/**
+ * usb_state_string - Returns human readable name for the state.
+ * @state: The state to return a human-readable name for. If it's not
+ *	any of the states devices in usb_device_state_string enum,
+ *	the string UNKNOWN will be returned.
+ */
 const char *usb_state_string(enum usb_device_state state)
 {
 	static const char *const names[] = {
@@ -141,6 +200,47 @@ enum usb_dr_mode usb_get_dr_mode(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(usb_get_dr_mode);
 
+/**
+ * usb_decode_interval - Decode bInterval into the time expressed in 1us unit
+ * @epd: The descriptor of the endpoint
+ * @speed: The speed that the endpoint works as
+ *
+ * Function returns the interval expressed in 1us unit for servicing
+ * endpoint for data transfers.
+ */
+unsigned int usb_decode_interval(const struct usb_endpoint_descriptor *epd,
+				 enum usb_device_speed speed)
+{
+	unsigned int interval = 0;
+
+	switch (usb_endpoint_type(epd)) {
+	case USB_ENDPOINT_XFER_CONTROL:
+		/* uframes per NAK */
+		if (speed == USB_SPEED_HIGH)
+			interval = epd->bInterval;
+		break;
+	case USB_ENDPOINT_XFER_ISOC:
+		interval = 1 << (epd->bInterval - 1);
+		break;
+	case USB_ENDPOINT_XFER_BULK:
+		/* uframes per NAK */
+		if (speed == USB_SPEED_HIGH && usb_endpoint_dir_out(epd))
+			interval = epd->bInterval;
+		break;
+	case USB_ENDPOINT_XFER_INT:
+		if (speed >= USB_SPEED_HIGH)
+			interval = 1 << (epd->bInterval - 1);
+		else
+			interval = epd->bInterval;
+		break;
+	}
+
+	interval *= (speed >= USB_SPEED_HIGH) ? 125 : 1000;
+
+	return interval;
+}
+EXPORT_SYMBOL_GPL(usb_decode_interval);
+
 #ifdef CONFIG_OF
 /**
  * of_usb_get_dr_mode_by_phy - Get dual role mode for the controller device
diff --git a/drivers/usb/common/debug.c b/drivers/usb/common/debug.c
index ba849c7bc5c7..f0c0e8db7038 100644
--- a/drivers/usb/common/debug.c
+++ b/drivers/usb/common/debug.c
@@ -207,12 +207,28 @@ static void usb_decode_set_isoch_delay(__u8 wValue, char *str, size_t size)
 	snprintf(str, size, "Set Isochronous Delay(Delay = %d ns)", wValue);
 }
 
-/*
- * usb_decode_ctrl - returns a string representation of ctrl request
- */
-const char *usb_decode_ctrl(char *str, size_t size, __u8 bRequestType,
-			    __u8 bRequest, __u16 wValue, __u16 wIndex,
-			    __u16 wLength)
+static void usb_decode_ctrl_generic(char *str, size_t size, __u8 bRequestType,
+				    __u8 bRequest, __u16 wValue, __u16 wIndex,
+				    __u16 wLength)
+{
+	u8 recip = bRequestType & USB_RECIP_MASK;
+	u8 type = bRequestType & USB_TYPE_MASK;
+
+	snprintf(str, size,
+		 "Type=%s Recipient=%s Dir=%s bRequest=%u wValue=%u wIndex=%u wLength=%u",
+		 (type == USB_TYPE_STANDARD)    ? "Standard" :
+		 (type == USB_TYPE_VENDOR)      ? "Vendor" :
+		 (type == USB_TYPE_CLASS)       ? "Class" : "Unknown",
+		 (recip == USB_RECIP_DEVICE)    ? "Device" :
+		 (recip == USB_RECIP_INTERFACE) ? "Interface" :
+		 (recip == USB_RECIP_ENDPOINT)  ? "Endpoint" : "Unknown",
+		 (bRequestType & USB_DIR_IN)    ? "IN" : "OUT",
+		 bRequest, wValue, wIndex, wLength);
+}
+
+static void usb_decode_ctrl_standard(char *str, size_t size, __u8 bRequestType,
+				     __u8 bRequest, __u16 wValue, __u16 wIndex,
+				     __u16 wLength)
 {
 	switch (bRequest) {
 	case USB_REQ_GET_STATUS:
@@ -253,14 +269,48 @@ const char *usb_decode_ctrl(char *str, size_t size, __u8 bRequestType,
 		usb_decode_set_isoch_delay(wValue, str, size);
 		break;
 	default:
-		snprintf(str, size, "%02x %02x %02x %02x %02x %02x %02x %02x",
-			 bRequestType, bRequest,
-			 (u8)(cpu_to_le16(wValue) & 0xff),
-			 (u8)(cpu_to_le16(wValue) >> 8),
-			 (u8)(cpu_to_le16(wIndex) & 0xff),
-			 (u8)(cpu_to_le16(wIndex) >> 8),
-			 (u8)(cpu_to_le16(wLength) & 0xff),
-			 (u8)(cpu_to_le16(wLength) >> 8));
+		usb_decode_ctrl_generic(str, size, bRequestType, bRequest,
+					wValue, wIndex, wLength);
+		break;
+	}
+}
+
+/**
+ * usb_decode_ctrl - Returns human readable representation of control request.
+ * @str: buffer to return a human-readable representation of control request.
+ *       This buffer should have about 200 bytes.
+ * @size: size of str buffer.
+ * @bRequestType: matches the USB bmRequestType field
+ * @bRequest: matches the USB bRequest field
+ * @wValue: matches the USB wValue field (CPU byte order)
+ * @wIndex: matches the USB wIndex field (CPU byte order)
+ * @wLength: matches the USB wLength field (CPU byte order)
+ *
+ * Function returns decoded, formatted and human-readable description of
+ * control request packet.
+ *
+ * The usage scenario for this is for tracepoints, so function as a return
+ * use the same value as in parameters. This approach allows to use this
+ * function in TP_printk
+ *
+ * Important: wValue, wIndex, wLength parameters before invoking this function
+ * should be processed by le16_to_cpu macro.
+ */
+const char *usb_decode_ctrl(char *str, size_t size, __u8 bRequestType,
+			    __u8 bRequest, __u16 wValue, __u16 wIndex,
+			    __u16 wLength)
+{
+	switch (bRequestType & USB_TYPE_MASK) {
+	case USB_TYPE_STANDARD:
+		usb_decode_ctrl_standard(str, size, bRequestType, bRequest,
+					 wValue, wIndex, wLength);
+		break;
+	case USB_TYPE_VENDOR:
+	case USB_TYPE_CLASS:
+	default:
+		usb_decode_ctrl_generic(str, size, bRequestType, bRequest,
+					wValue, wIndex, wLength);
+		break;
 	}
 
 	return str;
diff --git a/drivers/usb/core/devices.c b/drivers/usb/core/devices.c
index 1ef2de6e375a..d8b0041de612 100644
--- a/drivers/usb/core/devices.c
+++ b/drivers/usb/core/devices.c
@@ -157,38 +157,25 @@ static char *usb_dump_endpoint_descriptor(int speed, char *start, char *end,
 	switch (usb_endpoint_type(desc)) {
 	case USB_ENDPOINT_XFER_CONTROL:
 		type = "Ctrl";
-		if (speed == USB_SPEED_HIGH)	/* uframes per NAK */
-			interval = desc->bInterval;
-		else
-			interval = 0;
 		dir = 'B';			/* ctrl is bidirectional */
 		break;
 	case USB_ENDPOINT_XFER_ISOC:
 		type = "Isoc";
-		interval = 1 << (desc->bInterval - 1);
 		break;
 	case USB_ENDPOINT_XFER_BULK:
 		type = "Bulk";
-		if (speed == USB_SPEED_HIGH && dir == 'O') /* uframes per NAK */
-			interval = desc->bInterval;
-		else
-			interval = 0;
 		break;
 	case USB_ENDPOINT_XFER_INT:
 		type = "Int.";
-		if (speed == USB_SPEED_HIGH || speed >= USB_SPEED_SUPER)
-			interval = 1 << (desc->bInterval - 1);
-		else
-			interval = desc->bInterval;
 		break;
 	default:	/* "can't happen" */
 		return start;
 	}
-	interval *= (speed == USB_SPEED_HIGH ||
-		     speed >= USB_SPEED_SUPER) ? 125 : 1000;
-	if (interval % 1000)
+
+	interval = usb_decode_interval(desc, speed);
+	if (interval % 1000) {
 		unit = 'u';
-	else {
+	} else {
 		unit = 'm';
 		interval /= 1000;
 	}
diff --git a/drivers/usb/core/endpoint.c b/drivers/usb/core/endpoint.c
index 1c2c04079676..fc3341f2bb61 100644
--- a/drivers/usb/core/endpoint.c
+++ b/drivers/usb/core/endpoint.c
@@ -84,40 +84,13 @@ static ssize_t interval_show(struct device *dev, struct device_attribute *attr,
 			     char *buf)
 {
 	struct ep_device *ep = to_ep_device(dev);
+	unsigned int interval;
 	char unit;
-	unsigned interval = 0;
-	unsigned in;
 
-	in = (ep->desc->bEndpointAddress & USB_DIR_IN);
-
-	switch (usb_endpoint_type(ep->desc)) {
-	case USB_ENDPOINT_XFER_CONTROL:
-		if (ep->udev->speed == USB_SPEED_HIGH)
-			/* uframes per NAK */
-			interval = ep->desc->bInterval;
-		break;
-
-	case USB_ENDPOINT_XFER_ISOC:
-		interval = 1 << (ep->desc->bInterval - 1);
-		break;
-
-	case USB_ENDPOINT_XFER_BULK:
-		if (ep->udev->speed == USB_SPEED_HIGH && !in)
-			/* uframes per NAK */
-			interval = ep->desc->bInterval;
-		break;
-
-	case USB_ENDPOINT_XFER_INT:
-		if (ep->udev->speed == USB_SPEED_HIGH)
-			interval = 1 << (ep->desc->bInterval - 1);
-		else
-			interval = ep->desc->bInterval;
-		break;
-	}
-	interval *= (ep->udev->speed == USB_SPEED_HIGH) ? 125 : 1000;
-	if (interval % 1000)
+	interval = usb_decode_interval(ep->desc, ep->udev->speed);
+	if (interval % 1000) {
 		unit = 'u';
-	else {
+	} else {
 		unit = 'm';
 		interval /= 1000;
 	}
diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index f03ee889ecc7..03473e20e218 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -438,6 +438,10 @@ static const struct usb_device_id usb_quirk_list[] = {
 	{ USB_DEVICE(0x1532, 0x0116), .driver_info =
 			USB_QUIRK_LINEAR_UFRAME_INTR_BINTERVAL },
 
+	/* Lenovo ThinkPad OneLink+ Dock twin hub controllers (VIA Labs VL812) */
+	{ USB_DEVICE(0x17ef, 0x1018), .driver_info = USB_QUIRK_RESET_RESUME },
+	{ USB_DEVICE(0x17ef, 0x1019), .driver_info = USB_QUIRK_RESET_RESUME },
+
 	/* Lenovo USB-C to Ethernet Adapter RTL8153-04 */
 	{ USB_DEVICE(0x17ef, 0x720c), .driver_info = USB_QUIRK_NO_LPM },
 
diff --git a/drivers/usb/gadget/function/f_printer.c b/drivers/usb/gadget/function/f_printer.c
index 236ecc968998..c13bb29a160e 100644
--- a/drivers/usb/gadget/function/f_printer.c
+++ b/drivers/usb/gadget/function/f_printer.c
@@ -87,7 +87,7 @@ struct printer_dev {
 	u8			printer_cdev_open;
 	wait_queue_head_t	wait;
 	unsigned		q_len;
-	char			*pnp_string;	/* We don't own memory! */
+	char			**pnp_string;	/* We don't own memory! */
 	struct usb_function	function;
 };
 
@@ -999,16 +999,16 @@ static int printer_func_setup(struct usb_function *f,
 			if ((wIndex>>8) != dev->interface)
 				break;
 
-			if (!dev->pnp_string) {
+			if (!*dev->pnp_string) {
 				value = 0;
 				break;
 			}
-			value = strlen(dev->pnp_string);
+			value = strlen(*dev->pnp_string);
 			buf[0] = (value >> 8) & 0xFF;
 			buf[1] = value & 0xFF;
-			memcpy(buf + 2, dev->pnp_string, value);
+			memcpy(buf + 2, *dev->pnp_string, value);
 			DBG(dev, "1284 PNP String: %x %s\n", value,
-			    dev->pnp_string);
+			    *dev->pnp_string);
 			break;
 
 		case GET_PORT_STATUS: /* Get Port Status */
@@ -1471,7 +1471,7 @@ static struct usb_function *gprinter_alloc(struct usb_function_instance *fi)
 	kref_init(&dev->kref);
 	++opts->refcnt;
 	dev->minor = opts->minor;
-	dev->pnp_string = opts->pnp_string;
+	dev->pnp_string = &opts->pnp_string;
 	dev->q_len = opts->q_len;
 	mutex_unlock(&opts->lock);
 
diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index 024e8911df34..1fba5605a88e 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -659,7 +659,7 @@ struct xhci_stream_info *xhci_alloc_stream_info(struct xhci_hcd *xhci,
 			num_stream_ctxs, &stream_info->ctx_array_dma,
 			mem_flags);
 	if (!stream_info->stream_ctx_array)
-		goto cleanup_ctx;
+		goto cleanup_ring_array;
 	memset(stream_info->stream_ctx_array, 0,
 			sizeof(struct xhci_stream_ctx)*num_stream_ctxs);
 
@@ -720,6 +720,11 @@ struct xhci_stream_info *xhci_alloc_stream_info(struct xhci_hcd *xhci,
 	}
 	xhci_free_command(xhci, stream_info->free_streams_command);
 cleanup_ctx:
+	xhci_free_stream_ctx(xhci,
+		stream_info->num_stream_ctxs,
+		stream_info->stream_ctx_array,
+		stream_info->ctx_array_dma);
+cleanup_ring_array:
 	kfree(stream_info->stream_rings);
 cleanup_info:
 	kfree(stream_info);
diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
index dc570ce4e831..972a44b2a7f1 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -134,7 +134,7 @@ static const struct xhci_plat_priv xhci_plat_renesas_rcar_gen3 = {
 };
 
 static const struct xhci_plat_priv xhci_plat_brcm = {
-	.quirks = XHCI_RESET_ON_RESUME,
+	.quirks = XHCI_RESET_ON_RESUME | XHCI_SUSPEND_RESUME_CLKS,
 };
 
 static const struct of_device_id usb_xhci_of_match[] = {
@@ -447,7 +447,16 @@ static int __maybe_unused xhci_plat_suspend(struct device *dev)
 	 * xhci_suspend() needs `do_wakeup` to know whether host is allowed
 	 * to do wakeup during suspend.
 	 */
-	return xhci_suspend(xhci, device_may_wakeup(dev));
+	ret = xhci_suspend(xhci, device_may_wakeup(dev));
+	if (ret)
+		return ret;
+
+	if (!device_may_wakeup(dev) && (xhci->quirks & XHCI_SUSPEND_RESUME_CLKS)) {
+		clk_disable_unprepare(xhci->clk);
+		clk_disable_unprepare(xhci->reg_clk);
+	}
+
+	return 0;
 }
 
 static int __maybe_unused xhci_plat_resume(struct device *dev)
@@ -456,6 +465,11 @@ static int __maybe_unused xhci_plat_resume(struct device *dev)
 	struct xhci_hcd	*xhci = hcd_to_xhci(hcd);
 	int ret;
 
+	if (!device_may_wakeup(dev) && (xhci->quirks & XHCI_SUSPEND_RESUME_CLKS)) {
+		clk_prepare_enable(xhci->clk);
+		clk_prepare_enable(xhci->reg_clk);
+	}
+
 	ret = xhci_priv_resume_quirk(hcd);
 	if (ret)
 		return ret;
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 7b16b6b45af7..8918e6ae5c4b 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -1163,7 +1163,8 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernated)
 	/* re-initialize the HC on Restore Error, or Host Controller Error */
 	if (temp & (STS_SRE | STS_HCE)) {
 		reinit_xhc = true;
-		xhci_warn(xhci, "xHC error in resume, USBSTS 0x%x, Reinit\n", temp);
+		if (!xhci->broken_suspend)
+			xhci_warn(xhci, "xHC error in resume, USBSTS 0x%x, Reinit\n", temp);
 	}
 
 	if (reinit_xhc) {
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 6f16a05b1958..e668740000b2 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1888,6 +1888,7 @@ struct xhci_hcd {
 #define XHCI_SG_TRB_CACHE_SIZE_QUIRK	BIT_ULL(39)
 #define XHCI_NO_SOFT_RETRY	BIT_ULL(40)
 #define XHCI_EP_CTX_BROKEN_DCS	BIT_ULL(42)
+#define XHCI_SUSPEND_RESUME_CLKS	BIT_ULL(43)
 
 	unsigned int		num_active_eps;
 	unsigned int		limit_active_eps;
diff --git a/drivers/usb/misc/idmouse.c b/drivers/usb/misc/idmouse.c
index e9437a176518..ea39243efee3 100644
--- a/drivers/usb/misc/idmouse.c
+++ b/drivers/usb/misc/idmouse.c
@@ -177,10 +177,6 @@ static int idmouse_create_image(struct usb_idmouse *dev)
 		bytes_read += bulk_read;
 	}
 
-	/* reset the device */
-reset:
-	ftip_command(dev, FTIP_RELEASE, 0, 0);
-
 	/* check for valid image */
 	/* right border should be black (0x00) */
 	for (bytes_read = sizeof(HEADER)-1 + WIDTH-1; bytes_read < IMGSIZE; bytes_read += WIDTH)
@@ -192,6 +188,10 @@ static int idmouse_create_image(struct usb_idmouse *dev)
 		if (dev->bulk_in_buffer[bytes_read] != 0xFF)
 			return -EAGAIN;
 
+	/* reset the device */
+reset:
+	ftip_command(dev, FTIP_RELEASE, 0, 0);
+
 	/* should be IMGSIZE == 65040 */
 	dev_dbg(&dev->interface->dev, "read %d bytes fingerprint data\n",
 		bytes_read);
diff --git a/drivers/usb/musb/musb_gadget.c b/drivers/usb/musb/musb_gadget.c
index fb806b33178a..c273eee35aaa 100644
--- a/drivers/usb/musb/musb_gadget.c
+++ b/drivers/usb/musb/musb_gadget.c
@@ -760,6 +760,9 @@ static void rxstate(struct musb *musb, struct musb_request *req)
 			musb_writew(epio, MUSB_RXCSR, csr);
 
 buffer_aint_mapped:
+			fifo_count = min_t(unsigned int,
+					request->length - request->actual,
+					(unsigned int)fifo_count);
 			musb_read_fifo(musb_ep->hw_ep, fifo_count, (u8 *)
 					(request->buf + request->actual));
 			request->actual += fifo_count;
diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
index 4993227ab293..20dcbccb290b 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -1275,12 +1275,6 @@ UNUSUAL_DEV( 0x090a, 0x1200, 0x0000, 0x9999,
 		USB_SC_RBC, USB_PR_BULK, NULL,
 		0 ),
 
-UNUSUAL_DEV(0x090c, 0x1000, 0x1100, 0x1100,
-		"Samsung",
-		"Flash Drive FIT",
-		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
-		US_FL_MAX_SECTORS_64),
-
 /* aeb */
 UNUSUAL_DEV( 0x090c, 0x1132, 0x0000, 0xffff,
 		"Feiya",
diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 5d2d6ce7ff41..b0153617fe0e 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -359,7 +359,7 @@ vhost_vsock_alloc_pkt(struct vhost_virtqueue *vq,
 		return NULL;
 	}
 
-	pkt->buf = kmalloc(pkt->len, GFP_KERNEL);
+	pkt->buf = kvmalloc(pkt->len, GFP_KERNEL);
 	if (!pkt->buf) {
 		kfree(pkt);
 		return NULL;
diff --git a/drivers/video/fbdev/smscufx.c b/drivers/video/fbdev/smscufx.c
index 28768c272b73..7673db5da26b 100644
--- a/drivers/video/fbdev/smscufx.c
+++ b/drivers/video/fbdev/smscufx.c
@@ -137,6 +137,8 @@ static int ufx_submit_urb(struct ufx_data *dev, struct urb * urb, size_t len);
 static int ufx_alloc_urb_list(struct ufx_data *dev, int count, size_t size);
 static void ufx_free_urb_list(struct ufx_data *dev);
 
+static DEFINE_MUTEX(disconnect_mutex);
+
 /* reads a control register */
 static int ufx_reg_read(struct ufx_data *dev, u32 index, u32 *data)
 {
@@ -1070,9 +1072,13 @@ static int ufx_ops_open(struct fb_info *info, int user)
 	if (user == 0 && !console)
 		return -EBUSY;
 
+	mutex_lock(&disconnect_mutex);
+
 	/* If the USB device is gone, we don't accept new opens */
-	if (dev->virtualized)
+	if (dev->virtualized) {
+		mutex_unlock(&disconnect_mutex);
 		return -ENODEV;
+	}
 
 	dev->fb_count++;
 
@@ -1096,6 +1102,8 @@ static int ufx_ops_open(struct fb_info *info, int user)
 	pr_debug("open /dev/fb%d user=%d fb_info=%p count=%d",
 		info->node, user, info, dev->fb_count);
 
+	mutex_unlock(&disconnect_mutex);
+
 	return 0;
 }
 
@@ -1740,6 +1748,8 @@ static void ufx_usb_disconnect(struct usb_interface *interface)
 {
 	struct ufx_data *dev;
 
+	mutex_lock(&disconnect_mutex);
+
 	dev = usb_get_intfdata(interface);
 
 	pr_debug("USB disconnect starting\n");
@@ -1760,6 +1770,8 @@ static void ufx_usb_disconnect(struct usb_interface *interface)
 	kref_put(&dev->kref, ufx_free);
 
 	/* consider ufx_data freed */
+
+	mutex_unlock(&disconnect_mutex);
 }
 
 static struct usb_driver ufx_driver = {
diff --git a/drivers/video/fbdev/stifb.c b/drivers/video/fbdev/stifb.c
index 002f265d8db5..b0470f4f595e 100644
--- a/drivers/video/fbdev/stifb.c
+++ b/drivers/video/fbdev/stifb.c
@@ -1257,7 +1257,7 @@ static int __init stifb_init_fb(struct sti_struct *sti, int bpp_pref)
 	
 	/* limit fbsize to max visible screen size */
 	if (fix->smem_len > yres*fix->line_length)
-		fix->smem_len = yres*fix->line_length;
+		fix->smem_len = ALIGN(yres*fix->line_length, 4*1024*1024);
 	
 	fix->accel = FB_ACCEL_NONE;
 
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index a02e38fb696c..36da77534076 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1158,6 +1158,21 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_info)
 		fs_info->qgroup_rescan_running = true;
 	        btrfs_queue_work(fs_info->qgroup_rescan_workers,
 	                         &fs_info->qgroup_rescan_work);
+	} else {
+		/*
+		 * We have set both BTRFS_FS_QUOTA_ENABLED and
+		 * BTRFS_QGROUP_STATUS_FLAG_ON, so we can only fail with
+		 * -EINPROGRESS. That can happen because someone started the
+		 * rescan worker by calling quota rescan ioctl before we
+		 * attempted to initialize the rescan worker. Failure due to
+		 * quotas disabled in the meanwhile is not possible, because
+		 * we are holding a write lock on fs_info->subvol_sem, which
+		 * is also acquired when disabling quotas.
+		 * Ignore such error, and any other error would need to undo
+		 * everything we did in the transaction we just committed.
+		 */
+		ASSERT(ret == -EINPROGRESS);
+		ret = 0;
 	}
 
 out_free_path:
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 0392c556af60..88b9a5394561 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3811,6 +3811,7 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 	int ret;
 	struct btrfs_device *dev;
 	unsigned int nofs_flag;
+	bool need_commit = false;
 
 	if (btrfs_fs_closing(fs_info))
 		return -EAGAIN;
@@ -3924,6 +3925,12 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 	 */
 	nofs_flag = memalloc_nofs_save();
 	if (!is_dev_replace) {
+		u64 old_super_errors;
+
+		spin_lock(&sctx->stat_lock);
+		old_super_errors = sctx->stat.super_errors;
+		spin_unlock(&sctx->stat_lock);
+
 		btrfs_info(fs_info, "scrub: started on devid %llu", devid);
 		/*
 		 * by holding device list mutex, we can
@@ -3932,6 +3939,16 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 		mutex_lock(&fs_info->fs_devices->device_list_mutex);
 		ret = scrub_supers(sctx, dev);
 		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
+
+		spin_lock(&sctx->stat_lock);
+		/*
+		 * Super block errors found, but we can not commit transaction
+		 * at current context, since btrfs_commit_transaction() needs
+		 * to pause the current running scrub (hold by ourselves).
+		 */
+		if (sctx->stat.super_errors > old_super_errors && !sctx->readonly)
+			need_commit = true;
+		spin_unlock(&sctx->stat_lock);
 	}
 
 	if (!ret)
@@ -3958,6 +3975,25 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 	scrub_workers_put(fs_info);
 	scrub_put_ctx(sctx);
 
+	/*
+	 * We found some super block errors before, now try to force a
+	 * transaction commit, as scrub has finished.
+	 */
+	if (need_commit) {
+		struct btrfs_trans_handle *trans;
+
+		trans = btrfs_start_transaction(fs_info->tree_root, 0);
+		if (IS_ERR(trans)) {
+			ret = PTR_ERR(trans);
+			btrfs_err(fs_info,
+	"scrub: failed to start transaction to fix super block errors: %d", ret);
+			return ret;
+		}
+		ret = btrfs_commit_transaction(trans);
+		if (ret < 0)
+			btrfs_err(fs_info,
+	"scrub: failed to commit transaction to fix super block errors: %d", ret);
+	}
 	return ret;
 out:
 	scrub_workers_put(fs_info);
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index fafb69d338c2..a648146e49cf 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -3936,6 +3936,15 @@ static ssize_t __cifs_readv(
 		len = ctx->len;
 	}
 
+	if (direct) {
+		rc = filemap_write_and_wait_range(file->f_inode->i_mapping,
+						  offset, offset + len - 1);
+		if (rc) {
+			kref_put(&ctx->refcount, cifs_aio_ctx_release);
+			return -EAGAIN;
+		}
+	}
+
 	/* grab a lock here due to read response handlers can access ctx */
 	mutex_lock(&ctx->aio_mutex);
 
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 7ee8abd1f79b..0c4a2474e75b 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1075,9 +1075,9 @@ int smb3_validate_negotiate(const unsigned int xid, struct cifs_tcon *tcon)
 		pneg_inbuf->Dialects[0] =
 			cpu_to_le16(server->vals->protocol_id);
 		pneg_inbuf->DialectCount = cpu_to_le16(1);
-		/* structure is big enough for 3 dialects, sending only 1 */
+		/* structure is big enough for 4 dialects, sending only 1 */
 		inbuflen = sizeof(*pneg_inbuf) -
-				sizeof(pneg_inbuf->Dialects[0]) * 2;
+				sizeof(pneg_inbuf->Dialects[0]) * 3;
 	}
 
 	rc = SMB2_ioctl(xid, tcon, NO_FILE_ID, NO_FILE_ID,
@@ -2294,7 +2294,7 @@ create_sd_buf(umode_t mode, bool set_owner, unsigned int *len)
 	unsigned int acelen, acl_size, ace_count;
 	unsigned int owner_offset = 0;
 	unsigned int group_offset = 0;
-	struct smb3_acl acl;
+	struct smb3_acl acl = {};
 
 	*len = roundup(sizeof(struct crt_sd_ctxt) + (sizeof(struct cifs_ace) * 4), 8);
 
@@ -2367,6 +2367,7 @@ create_sd_buf(umode_t mode, bool set_owner, unsigned int *len)
 	acl.AclRevision = ACL_REVISION; /* See 2.4.4.1 of MS-DTYP */
 	acl.AclSize = cpu_to_le16(acl_size);
 	acl.AceCount = cpu_to_le16(ace_count);
+	/* acl.Sbz1 and Sbz2 MBZ so are not set here, but initialized above */
 	memcpy(aclptr, &acl, sizeof(struct smb3_acl));
 
 	buf->ccontext.DataLength = cpu_to_le32(ptr - (__u8 *)&buf->sd);
diff --git a/fs/dlm/ast.c b/fs/dlm/ast.c
index 283c7b94edda..ca06069e95c8 100644
--- a/fs/dlm/ast.c
+++ b/fs/dlm/ast.c
@@ -198,13 +198,13 @@ void dlm_add_cb(struct dlm_lkb *lkb, uint32_t flags, int mode, int status,
 	if (!prev_seq) {
 		kref_get(&lkb->lkb_ref);
 
+		mutex_lock(&ls->ls_cb_mutex);
 		if (test_bit(LSFL_CB_DELAY, &ls->ls_flags)) {
-			mutex_lock(&ls->ls_cb_mutex);
 			list_add(&lkb->lkb_cb_list, &ls->ls_cb_delay);
-			mutex_unlock(&ls->ls_cb_mutex);
 		} else {
 			queue_work(ls->ls_callback_wq, &lkb->lkb_cb_work);
 		}
+		mutex_unlock(&ls->ls_cb_mutex);
 	}
  out:
 	mutex_unlock(&lkb->lkb_cb_mutex);
@@ -284,7 +284,9 @@ void dlm_callback_stop(struct dlm_ls *ls)
 
 void dlm_callback_suspend(struct dlm_ls *ls)
 {
+	mutex_lock(&ls->ls_cb_mutex);
 	set_bit(LSFL_CB_DELAY, &ls->ls_flags);
+	mutex_unlock(&ls->ls_cb_mutex);
 
 	if (ls->ls_callback_wq)
 		flush_workqueue(ls->ls_callback_wq);
diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index eaa28d654e9f..dde9afb6747b 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -2888,24 +2888,24 @@ static int set_unlock_args(uint32_t flags, void *astarg, struct dlm_args *args)
 static int validate_lock_args(struct dlm_ls *ls, struct dlm_lkb *lkb,
 			      struct dlm_args *args)
 {
-	int rv = -EINVAL;
+	int rv = -EBUSY;
 
 	if (args->flags & DLM_LKF_CONVERT) {
-		if (lkb->lkb_flags & DLM_IFL_MSTCPY)
+		if (lkb->lkb_status != DLM_LKSTS_GRANTED)
 			goto out;
 
-		if (args->flags & DLM_LKF_QUECVT &&
-		    !__quecvt_compat_matrix[lkb->lkb_grmode+1][args->mode+1])
+		if (lkb->lkb_wait_type)
 			goto out;
 
-		rv = -EBUSY;
-		if (lkb->lkb_status != DLM_LKSTS_GRANTED)
+		if (is_overlap(lkb))
 			goto out;
 
-		if (lkb->lkb_wait_type)
+		rv = -EINVAL;
+		if (lkb->lkb_flags & DLM_IFL_MSTCPY)
 			goto out;
 
-		if (is_overlap(lkb))
+		if (args->flags & DLM_LKF_QUECVT &&
+		    !__quecvt_compat_matrix[lkb->lkb_grmode+1][args->mode+1])
 			goto out;
 	}
 
diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index 501e60713010..41dcf21558c4 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -766,22 +766,25 @@ static int ext4_fc_write_inode(struct inode *inode, u32 *crc)
 	tl.fc_tag = cpu_to_le16(EXT4_FC_TAG_INODE);
 	tl.fc_len = cpu_to_le16(inode_len + sizeof(fc_inode.fc_ino));
 
+	ret = -ECANCELED;
 	dst = ext4_fc_reserve_space(inode->i_sb,
 			sizeof(tl) + inode_len + sizeof(fc_inode.fc_ino), crc);
 	if (!dst)
-		return -ECANCELED;
+		goto err;
 
 	if (!ext4_fc_memcpy(inode->i_sb, dst, &tl, sizeof(tl), crc))
-		return -ECANCELED;
+		goto err;
 	dst += sizeof(tl);
 	if (!ext4_fc_memcpy(inode->i_sb, dst, &fc_inode, sizeof(fc_inode), crc))
-		return -ECANCELED;
+		goto err;
 	dst += sizeof(fc_inode);
 	if (!ext4_fc_memcpy(inode->i_sb, dst, (u8 *)ext4_raw_inode(&iloc),
 					inode_len, crc))
-		return -ECANCELED;
-
-	return 0;
+		goto err;
+	ret = 0;
+err:
+	brelse(iloc.bh);
+	return ret;
 }
 
 /*
@@ -1388,13 +1391,15 @@ static int ext4_fc_record_modified_inode(struct super_block *sb, int ino)
 		if (state->fc_modified_inodes[i] == ino)
 			return 0;
 	if (state->fc_modified_inodes_used == state->fc_modified_inodes_size) {
-		state->fc_modified_inodes = krealloc(
-				state->fc_modified_inodes,
+		int *fc_modified_inodes;
+
+		fc_modified_inodes = krealloc(state->fc_modified_inodes,
 				sizeof(int) * (state->fc_modified_inodes_size +
 				EXT4_FC_REPLAY_REALLOC_INCREMENT),
 				GFP_KERNEL);
-		if (!state->fc_modified_inodes)
+		if (!fc_modified_inodes)
 			return -ENOMEM;
+		state->fc_modified_inodes = fc_modified_inodes;
 		state->fc_modified_inodes_size +=
 			EXT4_FC_REPLAY_REALLOC_INCREMENT;
 	}
@@ -1579,15 +1584,18 @@ int ext4_fc_record_regions(struct super_block *sb, int ino,
 	if (replay && state->fc_regions_used != state->fc_regions_valid)
 		state->fc_regions_used = state->fc_regions_valid;
 	if (state->fc_regions_used == state->fc_regions_size) {
+		struct ext4_fc_alloc_region *fc_regions;
+
+		fc_regions = krealloc(state->fc_regions,
+				      sizeof(struct ext4_fc_alloc_region) *
+				      (state->fc_regions_size +
+				       EXT4_FC_REPLAY_REALLOC_INCREMENT),
+				      GFP_KERNEL);
+		if (!fc_regions)
+			return -ENOMEM;
 		state->fc_regions_size +=
 			EXT4_FC_REPLAY_REALLOC_INCREMENT;
-		state->fc_regions = krealloc(
-					state->fc_regions,
-					state->fc_regions_size *
-					sizeof(struct ext4_fc_alloc_region),
-					GFP_KERNEL);
-		if (!state->fc_regions)
-			return -ENOMEM;
+		state->fc_regions = fc_regions;
 	}
 	region = &state->fc_regions[state->fc_regions_used++];
 	region->ino = ino;
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 7b28d44b0ddd..0f61e0aa85d6 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -529,6 +529,12 @@ static ssize_t ext4_dio_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		ret = -EAGAIN;
 		goto out;
 	}
+	/*
+	 * Make sure inline data cannot be created anymore since we are going
+	 * to allocate blocks for DIO. We know the inode does not have any
+	 * inline data now because ext4_dio_supported() checked for that.
+	 */
+	ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
 
 	offset = iocb->ki_pos;
 	count = ret;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 44b6d061ed71..45f31dc1e66f 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1175,6 +1175,13 @@ static int ext4_write_begin(struct file *file, struct address_space *mapping,
 	page = grab_cache_page_write_begin(mapping, index, flags);
 	if (!page)
 		return -ENOMEM;
+	/*
+	 * The same as page allocation, we prealloc buffer heads before
+	 * starting the handle.
+	 */
+	if (!page_has_buffers(page))
+		create_empty_buffers(page, inode->i_sb->s_blocksize, 0);
+
 	unlock_page(page);
 
 retry_journal:
@@ -5769,7 +5776,12 @@ int ext4_mark_iloc_dirty(handle_t *handle,
 	}
 	ext4_fc_track_inode(handle, inode);
 
-	if (IS_I_VERSION(inode))
+	/*
+	 * ea_inodes are using i_version for storing reference count, don't
+	 * mess with it
+	 */
+	if (IS_I_VERSION(inode) &&
+	    !(EXT4_I(inode)->i_flags & EXT4_EA_INODE_FL))
 		inode_inc_iversion(inode);
 
 	/* the do_update_inode consumes one bh->b_count */
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 58b0f1b12095..646cc1935dff 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -125,7 +125,7 @@ static struct buffer_head *__ext4_read_dirblock(struct inode *inode,
 	struct ext4_dir_entry *dirent;
 	int is_dx_block = 0;
 
-	if (block >= inode->i_size) {
+	if (block >= inode->i_size >> inode->i_blkbits) {
 		ext4_error_inode(inode, func, line, block,
 		       "Attempting to read directory block (%u) that is past i_size (%llu)",
 		       block, inode->i_size);
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index f6409ddfd117..c55ba0390021 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -2068,7 +2068,7 @@ int ext4_resize_fs(struct super_block *sb, ext4_fsblk_t n_blocks_count)
 			goto out;
 	}
 
-	if (ext4_blocks_count(es) == n_blocks_count)
+	if (ext4_blocks_count(es) == n_blocks_count && n_blocks_count_retry == 0)
 		goto out;
 
 	err = ext4_alloc_flex_bg_array(sb, n_group + 1);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index a0af833f7da7..9573d493c374 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -188,19 +188,12 @@ int ext4_read_bh(struct buffer_head *bh, int op_flags, bh_end_io_t *end_io)
 
 int ext4_read_bh_lock(struct buffer_head *bh, int op_flags, bool wait)
 {
-	if (trylock_buffer(bh)) {
-		if (wait)
-			return ext4_read_bh(bh, op_flags, NULL);
+	lock_buffer(bh);
+	if (!wait) {
 		ext4_read_bh_nowait(bh, op_flags, NULL);
 		return 0;
 	}
-	if (wait) {
-		wait_on_buffer(bh);
-		if (buffer_uptodate(bh))
-			return 0;
-		return -EIO;
-	}
-	return 0;
+	return ext4_read_bh(bh, op_flags, NULL);
 }
 
 /*
@@ -247,7 +240,8 @@ void ext4_sb_breadahead_unmovable(struct super_block *sb, sector_t block)
 	struct buffer_head *bh = sb_getblk_gfp(sb, block, 0);
 
 	if (likely(bh)) {
-		ext4_read_bh_lock(bh, REQ_RAHEAD, false);
+		if (trylock_buffer(bh))
+			ext4_read_bh_nowait(bh, REQ_RAHEAD, NULL);
 		brelse(bh);
 	}
 }
@@ -3550,6 +3544,7 @@ static int ext4_lazyinit_thread(void *arg)
 	unsigned long next_wakeup, cur;
 
 	BUG_ON(NULL == eli);
+	set_freezable();
 
 cont_thread:
 	while (true) {
@@ -6273,7 +6268,7 @@ static int ext4_write_info(struct super_block *sb, int type)
 	handle_t *handle;
 
 	/* Data block + inode block */
-	handle = ext4_journal_start(d_inode(sb->s_root), EXT4_HT_QUOTA, 2);
+	handle = ext4_journal_start_sb(sb, EXT4_HT_QUOTA, 2);
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
 	ret = dquot_commit_info(sb, type);
diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 1c49b9959b32..cd46a64ace1b 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -136,7 +136,7 @@ static bool __is_bitmap_valid(struct f2fs_sb_info *sbi, block_t blkaddr,
 	unsigned int segno, offset;
 	bool exist;
 
-	if (type != DATA_GENERIC_ENHANCE && type != DATA_GENERIC_ENHANCE_READ)
+	if (type == DATA_GENERIC)
 		return true;
 
 	segno = GET_SEGNO(sbi, blkaddr);
@@ -144,6 +144,13 @@ static bool __is_bitmap_valid(struct f2fs_sb_info *sbi, block_t blkaddr,
 	se = get_seg_entry(sbi, segno);
 
 	exist = f2fs_test_bit(offset, se->cur_valid_map);
+	if (exist && type == DATA_GENERIC_ENHANCE_UPDATE) {
+		f2fs_err(sbi, "Inconsistent error blkaddr:%u, sit bitmap:%d",
+			 blkaddr, exist);
+		set_sbi_flag(sbi, SBI_NEED_FSCK);
+		return exist;
+	}
+
 	if (!exist && type == DATA_GENERIC_ENHANCE) {
 		f2fs_err(sbi, "Inconsistent error blkaddr:%u, sit bitmap:%d",
 			 blkaddr, exist);
@@ -181,6 +188,7 @@ bool f2fs_is_valid_blkaddr(struct f2fs_sb_info *sbi,
 	case DATA_GENERIC:
 	case DATA_GENERIC_ENHANCE:
 	case DATA_GENERIC_ENHANCE_READ:
+	case DATA_GENERIC_ENHANCE_UPDATE:
 		if (unlikely(blkaddr >= MAX_BLKADDR(sbi) ||
 				blkaddr < MAIN_BLKADDR(sbi))) {
 			f2fs_warn(sbi, "access invalid blkaddr:%u",
@@ -1039,7 +1047,8 @@ void f2fs_remove_dirty_inode(struct inode *inode)
 	spin_unlock(&sbi->inode_lock[type]);
 }
 
-int f2fs_sync_dirty_inodes(struct f2fs_sb_info *sbi, enum inode_type type)
+int f2fs_sync_dirty_inodes(struct f2fs_sb_info *sbi, enum inode_type type,
+						bool from_cp)
 {
 	struct list_head *head;
 	struct inode *inode;
@@ -1074,11 +1083,15 @@ int f2fs_sync_dirty_inodes(struct f2fs_sb_info *sbi, enum inode_type type)
 	if (inode) {
 		unsigned long cur_ino = inode->i_ino;
 
-		F2FS_I(inode)->cp_task = current;
+		if (from_cp)
+			F2FS_I(inode)->cp_task = current;
+		F2FS_I(inode)->wb_task = current;
 
 		filemap_fdatawrite(inode->i_mapping);
 
-		F2FS_I(inode)->cp_task = NULL;
+		F2FS_I(inode)->wb_task = NULL;
+		if (from_cp)
+			F2FS_I(inode)->cp_task = NULL;
 
 		iput(inode);
 		/* We need to give cpu to another writers. */
@@ -1207,7 +1220,7 @@ static int block_operations(struct f2fs_sb_info *sbi)
 	/* write all the dirty dentry pages */
 	if (get_pages(sbi, F2FS_DIRTY_DENTS)) {
 		f2fs_unlock_all(sbi);
-		err = f2fs_sync_dirty_inodes(sbi, DIR_INODE);
+		err = f2fs_sync_dirty_inodes(sbi, DIR_INODE, true);
 		if (err)
 			return err;
 		cond_resched();
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index b2016fd3a7ca..9270330ec5ce 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -2912,7 +2912,7 @@ int f2fs_write_single_data_page(struct page *page, int *submitted,
 	}
 	unlock_page(page);
 	if (!S_ISDIR(inode->i_mode) && !IS_NOQUOTA(inode) &&
-			!F2FS_I(inode)->cp_task && allow_balance)
+			!F2FS_I(inode)->wb_task && allow_balance)
 		f2fs_balance_fs(sbi, need_balance_fs);
 
 	if (unlikely(f2fs_cp_error(sbi))) {
@@ -3210,7 +3210,7 @@ static inline bool __should_serialize_io(struct inode *inode,
 					struct writeback_control *wbc)
 {
 	/* to avoid deadlock in path of data flush */
-	if (F2FS_I(inode)->cp_task)
+	if (F2FS_I(inode)->wb_task)
 		return false;
 
 	if (!S_ISREG(inode->i_mode))
diff --git a/fs/f2fs/extent_cache.c b/fs/f2fs/extent_cache.c
index 3ebf976a682d..bd16c78b5bf2 100644
--- a/fs/f2fs/extent_cache.c
+++ b/fs/f2fs/extent_cache.c
@@ -762,9 +762,8 @@ void f2fs_drop_extent_tree(struct inode *inode)
 	if (!f2fs_may_extent_tree(inode))
 		return;
 
-	set_inode_flag(inode, FI_NO_EXTENT);
-
 	write_lock(&et->lock);
+	set_inode_flag(inode, FI_NO_EXTENT);
 	__free_extent_tree(sbi, et);
 	if (et->largest.len) {
 		et->largest.len = 0;
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 1066725c3c5d..c03fdda1bddf 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -235,6 +235,10 @@ enum {
 					 * condition of read on truncated area
 					 * by extent_cache
 					 */
+	DATA_GENERIC_ENHANCE_UPDATE,	/*
+					 * strong check on range and segment
+					 * bitmap for update case
+					 */
 	META_GENERIC,
 };
 
@@ -697,6 +701,7 @@ struct f2fs_inode_info {
 	unsigned int clevel;		/* maximum level of given file name */
 	struct task_struct *task;	/* lookup and create consistency */
 	struct task_struct *cp_task;	/* separate cp/wb IO stats*/
+	struct task_struct *wb_task;	/* indicate inode is in context of writeback */
 	nid_t i_xattr_nid;		/* node id that contains xattrs */
 	loff_t	last_disk_size;		/* lastly written file size */
 	spinlock_t i_size_lock;		/* protect last_disk_size */
@@ -2422,24 +2427,31 @@ static inline void *f2fs_kmem_cache_alloc(struct kmem_cache *cachep,
 	return entry;
 }
 
-static inline bool is_idle(struct f2fs_sb_info *sbi, int type)
+static inline bool is_inflight_io(struct f2fs_sb_info *sbi, int type)
 {
-	if (sbi->gc_mode == GC_URGENT_HIGH)
-		return true;
-
 	if (get_pages(sbi, F2FS_RD_DATA) || get_pages(sbi, F2FS_RD_NODE) ||
 		get_pages(sbi, F2FS_RD_META) || get_pages(sbi, F2FS_WB_DATA) ||
 		get_pages(sbi, F2FS_WB_CP_DATA) ||
 		get_pages(sbi, F2FS_DIO_READ) ||
 		get_pages(sbi, F2FS_DIO_WRITE))
-		return false;
+		return true;
 
 	if (type != DISCARD_TIME && SM_I(sbi) && SM_I(sbi)->dcc_info &&
 			atomic_read(&SM_I(sbi)->dcc_info->queued_discard))
-		return false;
+		return true;
 
 	if (SM_I(sbi) && SM_I(sbi)->fcc_info &&
 			atomic_read(&SM_I(sbi)->fcc_info->queued_flush))
+		return true;
+	return false;
+}
+
+static inline bool is_idle(struct f2fs_sb_info *sbi, int type)
+{
+	if (sbi->gc_mode == GC_URGENT_HIGH)
+		return true;
+
+	if (is_inflight_io(sbi, type))
 		return false;
 
 	if (sbi->gc_mode == GC_URGENT_LOW &&
@@ -3389,7 +3401,8 @@ int f2fs_recover_orphan_inodes(struct f2fs_sb_info *sbi);
 int f2fs_get_valid_checkpoint(struct f2fs_sb_info *sbi);
 void f2fs_update_dirty_page(struct inode *inode, struct page *page);
 void f2fs_remove_dirty_inode(struct inode *inode);
-int f2fs_sync_dirty_inodes(struct f2fs_sb_info *sbi, enum inode_type type);
+int f2fs_sync_dirty_inodes(struct f2fs_sb_info *sbi, enum inode_type type,
+								bool from_cp);
 void f2fs_wait_on_all_pages(struct f2fs_sb_info *sbi, int type);
 int f2fs_write_checkpoint(struct f2fs_sb_info *sbi, struct cp_control *cpc);
 void f2fs_init_ino_entry_info(struct f2fs_sb_info *sbi);
diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 3b53fdebf03d..3baa62ef6e3a 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -977,7 +977,7 @@ static bool is_alive(struct f2fs_sb_info *sbi, struct f2fs_summary *sum,
 {
 	struct page *node_page;
 	nid_t nid;
-	unsigned int ofs_in_node;
+	unsigned int ofs_in_node, max_addrs;
 	block_t source_blkaddr;
 
 	nid = le32_to_cpu(sum->nid);
@@ -1003,6 +1003,14 @@ static bool is_alive(struct f2fs_sb_info *sbi, struct f2fs_summary *sum,
 		return false;
 	}
 
+	max_addrs = IS_INODE(node_page) ? DEF_ADDRS_PER_INODE :
+						DEF_ADDRS_PER_BLOCK;
+	if (ofs_in_node >= max_addrs) {
+		f2fs_err(sbi, "Inconsistent ofs_in_node:%u in summary, ino:%u, nid:%u, max:%u",
+			ofs_in_node, dni->ino, dni->nid, max_addrs);
+		return false;
+	}
+
 	*nofs = ofs_of_node(node_page);
 	source_blkaddr = data_blkaddr(NULL, node_page, ofs_in_node);
 	f2fs_put_page(node_page, 1);
diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index 72ce13111679..c3c527afdd07 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -437,7 +437,7 @@ static int check_index_in_prev_nodes(struct f2fs_sb_info *sbi,
 	struct dnode_of_data tdn = *dn;
 	nid_t ino, nid;
 	struct inode *inode;
-	unsigned int offset;
+	unsigned int offset, ofs_in_node, max_addrs;
 	block_t bidx;
 	int i;
 
@@ -463,15 +463,24 @@ static int check_index_in_prev_nodes(struct f2fs_sb_info *sbi,
 got_it:
 	/* Use the locked dnode page and inode */
 	nid = le32_to_cpu(sum.nid);
+	ofs_in_node = le16_to_cpu(sum.ofs_in_node);
+
+	max_addrs = ADDRS_PER_PAGE(dn->node_page, dn->inode);
+	if (ofs_in_node >= max_addrs) {
+		f2fs_err(sbi, "Inconsistent ofs_in_node:%u in summary, ino:%lu, nid:%u, max:%u",
+			ofs_in_node, dn->inode->i_ino, nid, max_addrs);
+		return -EFSCORRUPTED;
+	}
+
 	if (dn->inode->i_ino == nid) {
 		tdn.nid = nid;
 		if (!dn->inode_page_locked)
 			lock_page(dn->inode_page);
 		tdn.node_page = dn->inode_page;
-		tdn.ofs_in_node = le16_to_cpu(sum.ofs_in_node);
+		tdn.ofs_in_node = ofs_in_node;
 		goto truncate_out;
 	} else if (dn->nid == nid) {
-		tdn.ofs_in_node = le16_to_cpu(sum.ofs_in_node);
+		tdn.ofs_in_node = ofs_in_node;
 		goto truncate_out;
 	}
 
@@ -661,6 +670,14 @@ static int do_recover_data(struct f2fs_sb_info *sbi, struct inode *inode,
 				goto err;
 			}
 
+			if (f2fs_is_valid_blkaddr(sbi, dest,
+					DATA_GENERIC_ENHANCE_UPDATE)) {
+				f2fs_err(sbi, "Inconsistent dest blkaddr:%u, ino:%lu, ofs:%u",
+					dest, inode->i_ino, dn.ofs_in_node);
+				err = -EFSCORRUPTED;
+				goto err;
+			}
+
 			/* write dummy data page */
 			f2fs_replace_block(sbi, &dn, src, dest,
 						ni.version, false, false);
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 19224e7d2ad0..68774d6198a5 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -536,31 +536,38 @@ void f2fs_balance_fs_bg(struct f2fs_sb_info *sbi, bool from_bg)
 	else
 		f2fs_build_free_nids(sbi, false, false);
 
-	if (!is_idle(sbi, REQ_TIME) &&
-		(!excess_dirty_nats(sbi) && !excess_dirty_nodes(sbi)))
+	if (excess_dirty_nats(sbi) || excess_dirty_nodes(sbi) ||
+		excess_prefree_segs(sbi))
+		goto do_sync;
+
+	/* there is background inflight IO or foreground operation recently */
+	if (is_inflight_io(sbi, REQ_TIME) ||
+		(!f2fs_time_over(sbi, REQ_TIME) && rwsem_is_locked(&sbi->cp_rwsem)))
 		return;
 
+	/* exceed periodical checkpoint timeout threshold */
+	if (f2fs_time_over(sbi, CP_TIME))
+		goto do_sync;
+
 	/* checkpoint is the only way to shrink partial cached entries */
-	if (!f2fs_available_free_memory(sbi, NAT_ENTRIES) ||
-			!f2fs_available_free_memory(sbi, INO_ENTRIES) ||
-			excess_prefree_segs(sbi) ||
-			excess_dirty_nats(sbi) ||
-			excess_dirty_nodes(sbi) ||
-			f2fs_time_over(sbi, CP_TIME)) {
-		if (test_opt(sbi, DATA_FLUSH) && from_bg) {
-			struct blk_plug plug;
-
-			mutex_lock(&sbi->flush_lock);
-
-			blk_start_plug(&plug);
-			f2fs_sync_dirty_inodes(sbi, FILE_INODE);
-			blk_finish_plug(&plug);
+	if (f2fs_available_free_memory(sbi, NAT_ENTRIES) &&
+		f2fs_available_free_memory(sbi, INO_ENTRIES))
+		return;
 
-			mutex_unlock(&sbi->flush_lock);
-		}
-		f2fs_sync_fs(sbi->sb, true);
-		stat_inc_bg_cp_count(sbi->stat_info);
+do_sync:
+	if (test_opt(sbi, DATA_FLUSH) && from_bg) {
+		struct blk_plug plug;
+
+		mutex_lock(&sbi->flush_lock);
+
+		blk_start_plug(&plug);
+		f2fs_sync_dirty_inodes(sbi, FILE_INODE, false);
+		blk_finish_plug(&plug);
+
+		mutex_unlock(&sbi->flush_lock);
 	}
+	f2fs_sync_fs(sbi->sb, true);
+	stat_inc_bg_cp_count(sbi->stat_info);
 }
 
 static int __submit_flush_wait(struct f2fs_sb_info *sbi,
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index ccfb6c5a8fbc..fba413ced982 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -267,10 +267,10 @@ static int f2fs_sb_read_encoding(const struct f2fs_super_block *sb,
 
 static inline void limit_reserve_root(struct f2fs_sb_info *sbi)
 {
-	block_t limit = min((sbi->user_block_count << 1) / 1000,
+	block_t limit = min((sbi->user_block_count >> 3),
 			sbi->user_block_count - sbi->reserved_blocks);
 
-	/* limit is 0.2% */
+	/* limit is 12.5% */
 	if (test_opt(sbi, RESERVE_ROOT) &&
 			F2FS_OPTION(sbi).root_reserved_blocks > limit) {
 		F2FS_OPTION(sbi).root_reserved_blocks = limit;
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9654b60a06a5..05f360b66b07 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7301,6 +7301,7 @@ static int __io_sqe_files_scm(struct io_ring_ctx *ctx, int nr, int offset)
 	}
 
 	skb->sk = sk;
+	skb->scm_io_uring = 1;
 
 	nr_files = 0;
 	fpl->user = get_uid(ctx->user);
@@ -8436,8 +8437,6 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	if (ctx->sqo_task) {
 		put_task_struct(ctx->sqo_task);
 		ctx->sqo_task = NULL;
-		mmdrop(ctx->mm_account);
-		ctx->mm_account = NULL;
 	}
 
 #ifdef CONFIG_BLK_CGROUP
@@ -8456,6 +8455,11 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	}
 #endif
 
+	if (ctx->mm_account) {
+		mmdrop(ctx->mm_account);
+		ctx->mm_account = NULL;
+	}
+
 	io_mem_free(ctx->rings);
 	io_mem_free(ctx->sq_sqes);
 
diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 98cfa73cb165..fa24b407a9dc 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -581,7 +581,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 	journal->j_running_transaction = NULL;
 	start_time = ktime_get();
 	commit_transaction->t_log_start = journal->j_head;
-	wake_up(&journal->j_wait_transaction_locked);
+	wake_up_all(&journal->j_wait_transaction_locked);
 	write_unlock(&journal->j_state_lock);
 
 	jbd_debug(3, "JBD2: commit phase 2a\n");
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index b748329bb0ba..6689d235de8a 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -924,10 +924,16 @@ int jbd2_fc_wait_bufs(journal_t *journal, int num_blks)
 	for (i = j_fc_off - 1; i >= j_fc_off - num_blks; i--) {
 		bh = journal->j_fc_wbuf[i];
 		wait_on_buffer(bh);
+		/*
+		 * Update j_fc_off so jbd2_fc_release_bufs can release remain
+		 * buffer head.
+		 */
+		if (unlikely(!buffer_uptodate(bh))) {
+			journal->j_fc_off = i + 1;
+			return -EIO;
+		}
 		put_bh(bh);
 		journal->j_fc_wbuf[i] = NULL;
-		if (unlikely(!buffer_uptodate(bh)))
-			return -EIO;
 	}
 
 	return 0;
diff --git a/fs/jbd2/recovery.c b/fs/jbd2/recovery.c
index 1e07dfac4d81..1ae1697fe99b 100644
--- a/fs/jbd2/recovery.c
+++ b/fs/jbd2/recovery.c
@@ -256,6 +256,7 @@ static int fc_do_one_pass(journal_t *journal,
 		err = journal->j_fc_replay_callback(journal, bh, pass,
 					next_fc_block - journal->j_fc_first,
 					expected_commit_id);
+		brelse(bh);
 		next_fc_block++;
 		if (err < 0 || err == JBD2_FC_REPLAY_STOP)
 			break;
diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 0f1cef90fa7d..86472212cce1 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -173,7 +173,7 @@ static void wait_transaction_locked(journal_t *journal)
 	int need_to_start;
 	tid_t tid = journal->j_running_transaction->t_tid;
 
-	prepare_to_wait(&journal->j_wait_transaction_locked, &wait,
+	prepare_to_wait_exclusive(&journal->j_wait_transaction_locked, &wait,
 			TASK_UNINTERRUPTIBLE);
 	need_to_start = !tid_geq(journal->j_commit_request, tid);
 	read_unlock(&journal->j_state_lock);
@@ -199,7 +199,7 @@ static void wait_transaction_switching(journal_t *journal)
 		read_unlock(&journal->j_state_lock);
 		return;
 	}
-	prepare_to_wait(&journal->j_wait_transaction_locked, &wait,
+	prepare_to_wait_exclusive(&journal->j_wait_transaction_locked, &wait,
 			TASK_UNINTERRUPTIBLE);
 	read_unlock(&journal->j_state_lock);
 	/*
@@ -894,7 +894,7 @@ void jbd2_journal_unlock_updates (journal_t *journal)
 	write_lock(&journal->j_state_lock);
 	--journal->j_barrier_count;
 	write_unlock(&journal->j_state_lock);
-	wake_up(&journal->j_wait_transaction_locked);
+	wake_up_all(&journal->j_wait_transaction_locked);
 }
 
 static void warn_dirty_buffer(struct buffer_head *bh)
diff --git a/fs/nfsd/nfs4recover.c b/fs/nfsd/nfs4recover.c
index f9b730c43192..83c4e6883953 100644
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -815,8 +815,10 @@ __cld_pipe_inprogress_downcall(const struct cld_msg_v2 __user *cmsg,
 				princhash.data = memdup_user(
 						&ci->cc_princhash.cp_data,
 						princhashlen);
-				if (IS_ERR_OR_NULL(princhash.data))
+				if (IS_ERR_OR_NULL(princhash.data)) {
+					kfree(name.data);
 					return -EFAULT;
+				}
 				princhash.len = princhashlen;
 			} else
 				princhash.len = 0;
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index f1b503bec222..665d0eaeb8db 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -843,6 +843,7 @@ static struct nfs4_ol_stateid * nfs4_alloc_open_stateid(struct nfs4_client *clp)
 
 static void nfs4_free_deleg(struct nfs4_stid *stid)
 {
+	WARN_ON(!list_empty(&stid->sc_cp_list));
 	kmem_cache_free(deleg_slab, stid);
 	atomic_long_dec(&num_delegations);
 }
@@ -1358,6 +1359,7 @@ static void nfs4_free_ol_stateid(struct nfs4_stid *stid)
 	release_all_access(stp);
 	if (stp->st_stateowner)
 		nfs4_put_stateowner(stp->st_stateowner);
+	WARN_ON(!list_empty(&stid->sc_cp_list));
 	kmem_cache_free(stateid_slab, stid);
 }
 
@@ -6207,6 +6209,7 @@ static void nfsd4_close_open_stateid(struct nfs4_ol_stateid *s)
 	struct nfs4_client *clp = s->st_stid.sc_client;
 	bool unhashed;
 	LIST_HEAD(reaplist);
+	struct nfs4_ol_stateid *stp;
 
 	spin_lock(&clp->cl_lock);
 	unhashed = unhash_open_stateid(s, &reaplist);
@@ -6215,6 +6218,8 @@ static void nfsd4_close_open_stateid(struct nfs4_ol_stateid *s)
 		if (unhashed)
 			put_ol_stateid_locked(s, &reaplist);
 		spin_unlock(&clp->cl_lock);
+		list_for_each_entry(stp, &reaplist, st_locks)
+			nfs4_free_cpntf_statelist(clp->net, &stp->st_stid);
 		free_ol_stateid_reaplist(&reaplist);
 	} else {
 		spin_unlock(&clp->cl_lock);
diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 46f825cf53f4..cc605ee0b2fa 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -3871,7 +3871,7 @@ nfsd4_encode_read(struct nfsd4_compoundres *resp, __be32 nfserr,
 	if (resp->xdr.buf->page_len &&
 	    test_bit(RQ_SPLICE_OK, &resp->rqstp->rq_flags)) {
 		WARN_ON_ONCE(1);
-		return nfserr_resource;
+		return nfserr_serverfault;
 	}
 	xdr_commit_encode(xdr);
 
diff --git a/fs/quota/quota_tree.c b/fs/quota/quota_tree.c
index 1a188fbdf34e..07948f6ac84e 100644
--- a/fs/quota/quota_tree.c
+++ b/fs/quota/quota_tree.c
@@ -80,6 +80,35 @@ static ssize_t write_blk(struct qtree_mem_dqinfo *info, uint blk, char *buf)
 	return ret;
 }
 
+static inline int do_check_range(struct super_block *sb, const char *val_name,
+				 uint val, uint min_val, uint max_val)
+{
+	if (val < min_val || val > max_val) {
+		quota_error(sb, "Getting %s %u out of range %u-%u",
+			    val_name, val, min_val, max_val);
+		return -EUCLEAN;
+	}
+
+	return 0;
+}
+
+static int check_dquot_block_header(struct qtree_mem_dqinfo *info,
+				    struct qt_disk_dqdbheader *dh)
+{
+	int err = 0;
+
+	err = do_check_range(info->dqi_sb, "dqdh_next_free",
+			     le32_to_cpu(dh->dqdh_next_free), 0,
+			     info->dqi_blocks - 1);
+	if (err)
+		return err;
+	err = do_check_range(info->dqi_sb, "dqdh_prev_free",
+			     le32_to_cpu(dh->dqdh_prev_free), 0,
+			     info->dqi_blocks - 1);
+
+	return err;
+}
+
 /* Remove empty block from list and return it */
 static int get_free_dqblk(struct qtree_mem_dqinfo *info)
 {
@@ -94,6 +123,9 @@ static int get_free_dqblk(struct qtree_mem_dqinfo *info)
 		ret = read_blk(info, blk, buf);
 		if (ret < 0)
 			goto out_buf;
+		ret = check_dquot_block_header(info, dh);
+		if (ret)
+			goto out_buf;
 		info->dqi_free_blk = le32_to_cpu(dh->dqdh_next_free);
 	}
 	else {
@@ -241,6 +273,9 @@ static uint find_free_dqentry(struct qtree_mem_dqinfo *info,
 		*err = read_blk(info, blk, buf);
 		if (*err < 0)
 			goto out_buf;
+		*err = check_dquot_block_header(info, dh);
+		if (*err)
+			goto out_buf;
 	} else {
 		blk = get_free_dqblk(info);
 		if ((int)blk < 0) {
@@ -433,6 +468,9 @@ static int free_dqentry(struct qtree_mem_dqinfo *info, struct dquot *dquot,
 		goto out_buf;
 	}
 	dh = (struct qt_disk_dqdbheader *)buf;
+	ret = check_dquot_block_header(info, dh);
+	if (ret)
+		goto out_buf;
 	le16_add_cpu(&dh->dqdh_entries, -1);
 	if (!le16_to_cpu(dh->dqdh_entries)) {	/* Block got free? */
 		ret = remove_free_dqentry(info, buf, blk);
diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index aef0da5d6f63..a3074a9d71a6 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -974,7 +974,7 @@ static int resolve_userfault_fork(struct userfaultfd_ctx *ctx,
 	int fd;
 
 	fd = anon_inode_getfd("[userfaultfd]", &userfaultfd_fops, new,
-			      O_RDWR | (new->flags & UFFD_SHARED_FCNTL_FLAGS));
+			      O_RDONLY | (new->flags & UFFD_SHARED_FCNTL_FLAGS));
 	if (fd < 0)
 		return fd;
 
@@ -1987,7 +1987,7 @@ SYSCALL_DEFINE1(userfaultfd, int, flags)
 	mmgrab(ctx->mm);
 
 	fd = anon_inode_getfd("[userfaultfd]", &userfaultfd_fops, ctx,
-			      O_RDWR | (flags & UFFD_SHARED_FCNTL_FLAGS));
+			      O_RDONLY | (flags & UFFD_SHARED_FCNTL_FLAGS));
 	if (fd < 0) {
 		mmdrop(ctx->mm);
 		kmem_cache_free(userfaultfd_ctx_cachep, ctx);
diff --git a/include/linux/ata.h b/include/linux/ata.h
index 6e67aded28f8..6d2d31b03b4d 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -565,6 +565,18 @@ struct ata_bmdma_prd {
 	((((id)[ATA_ID_SATA_CAPABILITY] != 0x0000) && \
 	  ((id)[ATA_ID_SATA_CAPABILITY] != 0xffff)) && \
 	 ((id)[ATA_ID_FEATURE_SUPP] & (1 << 2)))
+#define ata_id_has_devslp(id)	\
+	((((id)[ATA_ID_SATA_CAPABILITY] != 0x0000) && \
+	  ((id)[ATA_ID_SATA_CAPABILITY] != 0xffff)) && \
+	 ((id)[ATA_ID_FEATURE_SUPP] & (1 << 8)))
+#define ata_id_has_ncq_autosense(id) \
+	((((id)[ATA_ID_SATA_CAPABILITY] != 0x0000) && \
+	  ((id)[ATA_ID_SATA_CAPABILITY] != 0xffff)) && \
+	 ((id)[ATA_ID_FEATURE_SUPP] & (1 << 7)))
+#define ata_id_has_dipm(id)	\
+	((((id)[ATA_ID_SATA_CAPABILITY] != 0x0000) && \
+	  ((id)[ATA_ID_SATA_CAPABILITY] != 0xffff)) && \
+	 ((id)[ATA_ID_FEATURE_SUPP] & (1 << 3)))
 #define ata_id_iordy_disable(id) ((id)[ATA_ID_CAPABILITY] & (1 << 10))
 #define ata_id_has_iordy(id) ((id)[ATA_ID_CAPABILITY] & (1 << 11))
 #define ata_id_u32(id,n)	\
@@ -577,9 +589,6 @@ struct ata_bmdma_prd {
 
 #define ata_id_cdb_intr(id)	(((id)[ATA_ID_CONFIG] & 0x60) == 0x20)
 #define ata_id_has_da(id)	((id)[ATA_ID_SATA_CAPABILITY_2] & (1 << 4))
-#define ata_id_has_devslp(id)	((id)[ATA_ID_FEATURE_SUPP] & (1 << 8))
-#define ata_id_has_ncq_autosense(id) \
-				((id)[ATA_ID_FEATURE_SUPP] & (1 << 7))
 
 static inline bool ata_id_has_hipm(const u16 *id)
 {
@@ -591,17 +600,6 @@ static inline bool ata_id_has_hipm(const u16 *id)
 	return val & (1 << 9);
 }
 
-static inline bool ata_id_has_dipm(const u16 *id)
-{
-	u16 val = id[ATA_ID_FEATURE_SUPP];
-
-	if (val == 0 || val == 0xffff)
-		return false;
-
-	return val & (1 << 3);
-}
-
-
 static inline bool ata_id_has_fua(const u16 *id)
 {
 	if ((id[ATA_ID_CFSSE] & 0xC000) != 0x4000)
@@ -770,16 +768,21 @@ static inline bool ata_id_has_read_log_dma_ext(const u16 *id)
 
 static inline bool ata_id_has_sense_reporting(const u16 *id)
 {
-	if (!(id[ATA_ID_CFS_ENABLE_2] & (1 << 15)))
+	if (!(id[ATA_ID_CFS_ENABLE_2] & BIT(15)))
+		return false;
+	if ((id[ATA_ID_COMMAND_SET_3] & (BIT(15) | BIT(14))) != BIT(14))
 		return false;
-	return id[ATA_ID_COMMAND_SET_3] & (1 << 6);
+	return id[ATA_ID_COMMAND_SET_3] & BIT(6);
 }
 
 static inline bool ata_id_sense_reporting_enabled(const u16 *id)
 {
-	if (!(id[ATA_ID_CFS_ENABLE_2] & (1 << 15)))
+	if (!ata_id_has_sense_reporting(id))
+		return false;
+	/* ata_id_has_sense_reporting() == true, word 86 must have bit 15 set */
+	if ((id[ATA_ID_COMMAND_SET_4] & (BIT(15) | BIT(14))) != BIT(14))
 		return false;
-	return id[ATA_ID_COMMAND_SET_4] & (1 << 6);
+	return id[ATA_ID_COMMAND_SET_4] & BIT(6);
 }
 
 /**
diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
index a57ee75342cf..c0c6ea9ea7e3 100644
--- a/include/linux/dynamic_debug.h
+++ b/include/linux/dynamic_debug.h
@@ -50,9 +50,6 @@ struct _ddebug {
 
 #if defined(CONFIG_DYNAMIC_DEBUG_CORE)
 
-/* exported for module authors to exercise >control */
-int dynamic_debug_exec_queries(const char *query, const char *modname);
-
 int ddebug_add_module(struct _ddebug *tab, unsigned int n,
 				const char *modname);
 extern int ddebug_remove_module(const char *mod_name);
@@ -196,7 +193,7 @@ static inline int ddebug_remove_module(const char *mod)
 static inline int ddebug_dyndbg_module_param_cb(char *param, char *val,
 						const char *modname)
 {
-	if (strstr(param, "dyndbg")) {
+	if (!strcmp(param, "dyndbg")) {
 		/* avoid pr_warn(), which wants pr_fmt() fully defined */
 		printk(KERN_WARNING "dyndbg param is supported only in "
 			"CONFIG_DYNAMIC_DEBUG builds\n");
@@ -216,12 +213,6 @@ static inline int ddebug_dyndbg_module_param_cb(char *param, char *val,
 				rowsize, groupsize, buf, len, ascii);	\
 	} while (0)
 
-static inline int dynamic_debug_exec_queries(const char *query, const char *modname)
-{
-	pr_warn("kernel not built with CONFIG_DYNAMIC_DEBUG_CORE\n");
-	return 0;
-}
-
 #endif /* !CONFIG_DYNAMIC_DEBUG_CORE */
 
 #endif
diff --git a/include/linux/iova.h b/include/linux/iova.h
index a0637abffee8..6c19b09e9663 100644
--- a/include/linux/iova.h
+++ b/include/linux/iova.h
@@ -132,7 +132,7 @@ static inline unsigned long iova_pfn(struct iova_domain *iovad, dma_addr_t iova)
 	return iova >> iova_shift(iovad);
 }
 
-#if IS_ENABLED(CONFIG_IOMMU_IOVA)
+#if IS_REACHABLE(CONFIG_IOMMU_IOVA)
 int iova_cache_get(void);
 void iova_cache_put(void);
 
diff --git a/include/linux/once.h b/include/linux/once.h
index ae6f4eb41cbe..bb58e1c3aa03 100644
--- a/include/linux/once.h
+++ b/include/linux/once.h
@@ -5,10 +5,18 @@
 #include <linux/types.h>
 #include <linux/jump_label.h>
 
+/* Helpers used from arbitrary contexts.
+ * Hard irqs are blocked, be cautious.
+ */
 bool __do_once_start(bool *done, unsigned long *flags);
 void __do_once_done(bool *done, struct static_key_true *once_key,
 		    unsigned long *flags, struct module *mod);
 
+/* Variant for process contexts only. */
+bool __do_once_slow_start(bool *done);
+void __do_once_slow_done(bool *done, struct static_key_true *once_key,
+			 struct module *mod);
+
 /* Call a function exactly once. The idea of DO_ONCE() is to perform
  * a function call such as initialization of random seeds, etc, only
  * once, where DO_ONCE() can live in the fast-path. After @func has
@@ -52,9 +60,29 @@ void __do_once_done(bool *done, struct static_key_true *once_key,
 		___ret;							     \
 	})
 
+/* Variant of DO_ONCE() for process/sleepable contexts. */
+#define DO_ONCE_SLOW(func, ...)						     \
+	({								     \
+		bool ___ret = false;					     \
+		static bool __section(".data.once") ___done = false;	     \
+		static DEFINE_STATIC_KEY_TRUE(___once_key);		     \
+		if (static_branch_unlikely(&___once_key)) {		     \
+			___ret = __do_once_slow_start(&___done);	     \
+			if (unlikely(___ret)) {				     \
+				func(__VA_ARGS__);			     \
+				__do_once_slow_done(&___done, &___once_key,  \
+						    THIS_MODULE);	     \
+			}						     \
+		}							     \
+		___ret;							     \
+	})
+
 #define get_random_once(buf, nbytes)					     \
 	DO_ONCE(get_random_bytes, (buf), (nbytes))
 #define get_random_once_wait(buf, nbytes)                                    \
 	DO_ONCE(get_random_bytes_wait, (buf), (nbytes))                      \
 
+#define get_random_slow_once(buf, nbytes)				     \
+	DO_ONCE_SLOW(get_random_bytes, (buf), (nbytes))
+
 #endif /* _LINUX_ONCE_H */
diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index 136ea0997e6d..c9237d30c29b 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -100,7 +100,7 @@ __ring_buffer_alloc(unsigned long size, unsigned flags, struct lock_class_key *k
 int ring_buffer_wait(struct trace_buffer *buffer, int cpu, int full);
 __poll_t ring_buffer_poll_wait(struct trace_buffer *buffer, int cpu,
 			  struct file *filp, poll_table *poll_table);
-
+void ring_buffer_wake_waiters(struct trace_buffer *buffer, int cpu);
 
 #define RING_BUFFER_ALL_CPUS -1
 
diff --git a/include/linux/serial_8250.h b/include/linux/serial_8250.h
index 2b70f736b091..92f3b778d8c2 100644
--- a/include/linux/serial_8250.h
+++ b/include/linux/serial_8250.h
@@ -74,6 +74,7 @@ struct uart_8250_port;
 struct uart_8250_ops {
 	int		(*setup_irq)(struct uart_8250_port *);
 	void		(*release_irq)(struct uart_8250_port *);
+	void		(*setup_timer)(struct uart_8250_port *);
 };
 
 struct uart_8250_em485 {
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 61fc053a4a4e..462b0e3ef2b2 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -681,6 +681,7 @@ typedef unsigned char *sk_buff_data_t;
  *	@csum_level: indicates the number of consecutive checksums found in
  *		the packet minus one that have been verified as
  *		CHECKSUM_UNNECESSARY (max 3)
+ *	@scm_io_uring: SKB holds io_uring registered files
  *	@dst_pending_confirm: need to confirm neighbour
  *	@decrypted: Decrypted SKB
  *	@napi_id: id of the NAPI struct this skb came from
@@ -858,6 +859,7 @@ struct sk_buff {
 #ifdef CONFIG_TLS_DEVICE
 	__u8			decrypted:1;
 #endif
+	__u8			scm_io_uring:1;
 
 #ifdef CONFIG_NET_SCHED
 	__u16			tc_index;	/* traffic control index */
diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index 2f87377e9af7..6e3340379d85 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -265,7 +265,7 @@ struct tcp_sock {
 	u32	packets_out;	/* Packets which are "in flight"	*/
 	u32	retrans_out;	/* Retransmitted packets out		*/
 	u32	max_packets_out;  /* max packets_out in last window */
-	u32	max_packets_seq;  /* right edge of max_packets_out flight */
+	u32	cwnd_usage_seq;  /* right edge of cwnd usage tracking flight */
 
 	u16	urg_data;	/* Saved octet of OOB data and control flags */
 	u8	ecn_flags;	/* ECN status bits.			*/
diff --git a/include/linux/usb/ch9.h b/include/linux/usb/ch9.h
index 604c6c514a50..1cffa34740b0 100644
--- a/include/linux/usb/ch9.h
+++ b/include/linux/usb/ch9.h
@@ -36,62 +36,24 @@
 #include <linux/device.h>
 #include <uapi/linux/usb/ch9.h>
 
-/**
- * usb_ep_type_string() - Returns human readable-name of the endpoint type.
- * @ep_type: The endpoint type to return human-readable name for.  If it's not
- *   any of the types: USB_ENDPOINT_XFER_{CONTROL, ISOC, BULK, INT},
- *   usually got by usb_endpoint_type(), the string 'unknown' will be returned.
- */
-extern const char *usb_ep_type_string(int ep_type);
+/* USB 3.2 SuperSpeed Plus phy signaling rate generation and lane count */
 
-/**
- * usb_speed_string() - Returns human readable-name of the speed.
- * @speed: The speed to return human-readable name for.  If it's not
- *   any of the speeds defined in usb_device_speed enum, string for
- *   USB_SPEED_UNKNOWN will be returned.
- */
-extern const char *usb_speed_string(enum usb_device_speed speed);
+enum usb_ssp_rate {
+	USB_SSP_GEN_UNKNOWN = 0,
+	USB_SSP_GEN_2x1,
+	USB_SSP_GEN_1x2,
+	USB_SSP_GEN_2x2,
+};
 
-/**
- * usb_get_maximum_speed - Get maximum requested speed for a given USB
- * controller.
- * @dev: Pointer to the given USB controller device
- *
- * The function gets the maximum speed string from property "maximum-speed",
- * and returns the corresponding enum usb_device_speed.
- */
+extern const char *usb_ep_type_string(int ep_type);
+extern const char *usb_speed_string(enum usb_device_speed speed);
 extern enum usb_device_speed usb_get_maximum_speed(struct device *dev);
-
-/**
- * usb_state_string - Returns human readable name for the state.
- * @state: The state to return a human-readable name for. If it's not
- *	any of the states devices in usb_device_state_string enum,
- *	the string UNKNOWN will be returned.
- */
+extern enum usb_ssp_rate usb_get_maximum_ssp_rate(struct device *dev);
 extern const char *usb_state_string(enum usb_device_state state);
+unsigned int usb_decode_interval(const struct usb_endpoint_descriptor *epd,
+				 enum usb_device_speed speed);
 
 #ifdef CONFIG_TRACING
-/**
- * usb_decode_ctrl - Returns human readable representation of control request.
- * @str: buffer to return a human-readable representation of control request.
- *       This buffer should have about 200 bytes.
- * @size: size of str buffer.
- * @bRequestType: matches the USB bmRequestType field
- * @bRequest: matches the USB bRequest field
- * @wValue: matches the USB wValue field (CPU byte order)
- * @wIndex: matches the USB wIndex field (CPU byte order)
- * @wLength: matches the USB wLength field (CPU byte order)
- *
- * Function returns decoded, formatted and human-readable description of
- * control request packet.
- *
- * The usage scenario for this is for tracepoints, so function as a return
- * use the same value as in parameters. This approach allows to use this
- * function in TP_printk
- *
- * Important: wValue, wIndex, wLength parameters before invoking this function
- * should be processed by le16_to_cpu macro.
- */
 extern const char *usb_decode_ctrl(char *str, size_t size, __u8 bRequestType,
 				   __u8 bRequest, __u16 wValue, __u16 wIndex,
 				   __u16 wLength);
diff --git a/include/net/ieee802154_netdev.h b/include/net/ieee802154_netdev.h
index a8994f307fc3..03b64bf876a4 100644
--- a/include/net/ieee802154_netdev.h
+++ b/include/net/ieee802154_netdev.h
@@ -185,21 +185,27 @@ static inline int
 ieee802154_sockaddr_check_size(struct sockaddr_ieee802154 *daddr, int len)
 {
 	struct ieee802154_addr_sa *sa;
+	int ret = 0;
 
 	sa = &daddr->addr;
 	if (len < IEEE802154_MIN_NAMELEN)
 		return -EINVAL;
 	switch (sa->addr_type) {
+	case IEEE802154_ADDR_NONE:
+		break;
 	case IEEE802154_ADDR_SHORT:
 		if (len < IEEE802154_NAMELEN_SHORT)
-			return -EINVAL;
+			ret = -EINVAL;
 		break;
 	case IEEE802154_ADDR_LONG:
 		if (len < IEEE802154_NAMELEN_LONG)
-			return -EINVAL;
+			ret = -EINVAL;
+		break;
+	default:
+		ret = -EINVAL;
 		break;
 	}
-	return 0;
+	return ret;
 }
 
 static inline void ieee802154_addr_from_sa(struct ieee802154_addr *a,
diff --git a/include/net/sock.h b/include/net/sock.h
index d53fb6437476..90a8b8b26a20 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -421,7 +421,7 @@ struct sock {
 #ifdef CONFIG_XFRM
 	struct xfrm_policy __rcu *sk_policy[2];
 #endif
-	struct dst_entry	*sk_rx_dst;
+	struct dst_entry __rcu	*sk_rx_dst;
 	struct dst_entry __rcu	*sk_dst_cache;
 	atomic_t		sk_omem_alloc;
 	int			sk_sndbuf;
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 8129ce9a0771..bf4af27f5620 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1271,11 +1271,14 @@ static inline bool tcp_is_cwnd_limited(const struct sock *sk)
 {
 	const struct tcp_sock *tp = tcp_sk(sk);
 
+	if (tp->is_cwnd_limited)
+		return true;
+
 	/* If in slow start, ensure cwnd grows to twice what was ACKed. */
 	if (tcp_in_slow_start(tp))
 		return tp->snd_cwnd < 2 * tp->max_packets_out;
 
-	return tp->is_cwnd_limited;
+	return false;
 }
 
 /* BBR congestion control needs pacing.
diff --git a/include/uapi/linux/usb/ch9.h b/include/uapi/linux/usb/ch9.h
index 0f865ae4ba89..17ce56198c9a 100644
--- a/include/uapi/linux/usb/ch9.h
+++ b/include/uapi/linux/usb/ch9.h
@@ -968,9 +968,22 @@ struct usb_ssp_cap_descriptor {
 	__le32 bmSublinkSpeedAttr[1]; /* list of sublink speed attrib entries */
 #define USB_SSP_SUBLINK_SPEED_SSID	(0xf)		/* sublink speed ID */
 #define USB_SSP_SUBLINK_SPEED_LSE	(0x3 << 4)	/* Lanespeed exponent */
+#define USB_SSP_SUBLINK_SPEED_LSE_BPS		0
+#define USB_SSP_SUBLINK_SPEED_LSE_KBPS		1
+#define USB_SSP_SUBLINK_SPEED_LSE_MBPS		2
+#define USB_SSP_SUBLINK_SPEED_LSE_GBPS		3
+
 #define USB_SSP_SUBLINK_SPEED_ST	(0x3 << 6)	/* Sublink type */
+#define USB_SSP_SUBLINK_SPEED_ST_SYM_RX		0
+#define USB_SSP_SUBLINK_SPEED_ST_ASYM_RX	1
+#define USB_SSP_SUBLINK_SPEED_ST_SYM_TX		2
+#define USB_SSP_SUBLINK_SPEED_ST_ASYM_TX	3
+
 #define USB_SSP_SUBLINK_SPEED_RSVD	(0x3f << 8)	/* Reserved */
 #define USB_SSP_SUBLINK_SPEED_LP	(0x3 << 14)	/* Link protocol */
+#define USB_SSP_SUBLINK_SPEED_LP_SS		0
+#define USB_SSP_SUBLINK_SPEED_LP_SSP		1
+
 #define USB_SSP_SUBLINK_SPEED_LSM	(0xff << 16)	/* Lanespeed mantissa */
 } __attribute__((packed));
 
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index dc497eaf2266..9232938e3f96 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -2913,7 +2913,7 @@ static int btf_struct_resolve(struct btf_verifier_env *env,
 	if (v->next_member) {
 		const struct btf_type *last_member_type;
 		const struct btf_member *last_member;
-		u16 last_member_type_id;
+		u32 last_member_type_id;
 
 		last_member = btf_type_member(v->t) + v->next_member - 1;
 		last_member_type_id = last_member->type;
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 419dbc3d060e..aaad2dce2be6 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -3915,7 +3915,9 @@ static int bpf_task_fd_query(const union bpf_attr *attr,
 	if (attr->task_fd_query.flags != 0)
 		return -EINVAL;
 
+	rcu_read_lock();
 	task = get_pid_task(find_vpid(pid), PIDTYPE_PID);
+	rcu_read_unlock();
 	if (!task)
 		return -ENOENT;
 
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index b7830f1f1f3a..43270b07b2e0 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -33,6 +33,7 @@
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
 #include <linux/kmod.h>
+#include <linux/kthread.h>
 #include <linux/list.h>
 #include <linux/mempolicy.h>
 #include <linux/mm.h>
@@ -1059,10 +1060,18 @@ static void update_tasks_cpumask(struct cpuset *cs)
 {
 	struct css_task_iter it;
 	struct task_struct *task;
+	bool top_cs = cs == &top_cpuset;
 
 	css_task_iter_start(&cs->css, 0, &it);
-	while ((task = css_task_iter_next(&it)))
+	while ((task = css_task_iter_next(&it))) {
+		/*
+		 * Percpu kthreads in top_cpuset are ignored
+		 */
+		if (top_cs && (task->flags & PF_KTHREAD) &&
+		    kthread_is_per_cpu(task))
+			continue;
 		set_cpus_allowed_ptr(task, cs->effective_cpus);
+	}
 	css_task_iter_end(&it);
 }
 
@@ -2016,12 +2025,7 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 		update_flag(CS_CPU_EXCLUSIVE, cs, 0);
 	}
 
-	/*
-	 * Update cpumask of parent's tasks except when it is the top
-	 * cpuset as some system daemons cannot be mapped to other CPUs.
-	 */
-	if (parent != &top_cpuset)
-		update_tasks_cpumask(parent);
+	update_tasks_cpumask(parent);
 
 	if (parent->child_ecpus_count)
 		update_sibling_cpumasks(parent, cs, &tmpmask);
diff --git a/kernel/gcov/gcc_4_7.c b/kernel/gcov/gcc_4_7.c
index 53c67c87f141..c699feda21ac 100644
--- a/kernel/gcov/gcc_4_7.c
+++ b/kernel/gcov/gcc_4_7.c
@@ -33,6 +33,13 @@
 
 #define GCOV_TAG_FUNCTION_LENGTH	3
 
+/* Since GCC 12.1 sizes are in BYTES and not in WORDS (4B). */
+#if (__GNUC__ >= 12)
+#define GCOV_UNIT_SIZE				4
+#else
+#define GCOV_UNIT_SIZE				1
+#endif
+
 static struct gcov_info *gcov_info_head;
 
 /**
@@ -451,12 +458,18 @@ static size_t convert_to_gcda(char *buffer, struct gcov_info *info)
 	pos += store_gcov_u32(buffer, pos, info->version);
 	pos += store_gcov_u32(buffer, pos, info->stamp);
 
+#if (__GNUC__ >= 12)
+	/* Use zero as checksum of the compilation unit. */
+	pos += store_gcov_u32(buffer, pos, 0);
+#endif
+
 	for (fi_idx = 0; fi_idx < info->n_functions; fi_idx++) {
 		fi_ptr = info->functions[fi_idx];
 
 		/* Function record. */
 		pos += store_gcov_u32(buffer, pos, GCOV_TAG_FUNCTION);
-		pos += store_gcov_u32(buffer, pos, GCOV_TAG_FUNCTION_LENGTH);
+		pos += store_gcov_u32(buffer, pos,
+			GCOV_TAG_FUNCTION_LENGTH * GCOV_UNIT_SIZE);
 		pos += store_gcov_u32(buffer, pos, fi_ptr->ident);
 		pos += store_gcov_u32(buffer, pos, fi_ptr->lineno_checksum);
 		pos += store_gcov_u32(buffer, pos, fi_ptr->cfg_checksum);
@@ -470,7 +483,8 @@ static size_t convert_to_gcda(char *buffer, struct gcov_info *info)
 			/* Counter record. */
 			pos += store_gcov_u32(buffer, pos,
 					      GCOV_TAG_FOR_COUNTER(ct_idx));
-			pos += store_gcov_u32(buffer, pos, ci_ptr->num * 2);
+			pos += store_gcov_u32(buffer, pos,
+				ci_ptr->num * 2 * GCOV_UNIT_SIZE);
 
 			for (cv_idx = 0; cv_idx < ci_ptr->num; cv_idx++) {
 				pos += store_gcov_u64(buffer, pos,
diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
index f6310f848f34..b04b87a4e0a7 100644
--- a/kernel/livepatch/transition.c
+++ b/kernel/livepatch/transition.c
@@ -611,9 +611,23 @@ void klp_reverse_transition(void)
 /* Called from copy_process() during fork */
 void klp_copy_process(struct task_struct *child)
 {
-	child->patch_state = current->patch_state;
 
-	/* TIF_PATCH_PENDING gets copied in setup_thread_stack() */
+	/*
+	 * The parent process may have gone through a KLP transition since
+	 * the thread flag was copied in setup_thread_stack earlier. Bring
+	 * the task flag up to date with the parent here.
+	 *
+	 * The operation is serialized against all klp_*_transition()
+	 * operations by the tasklist_lock. The only exception is
+	 * klp_update_patch_state(current), but we cannot race with
+	 * that because we are current.
+	 */
+	if (test_tsk_thread_flag(current, TIF_PATCH_PENDING))
+		set_tsk_thread_flag(child, TIF_PATCH_PENDING);
+	else
+		clear_tsk_thread_flag(child, TIF_PATCH_PENDING);
+
+	child->patch_state = current->patch_state;
 }
 
 /*
diff --git a/kernel/rcu/tasks.h b/kernel/rcu/tasks.h
index 14af29fe1377..8b51e6a5b386 100644
--- a/kernel/rcu/tasks.h
+++ b/kernel/rcu/tasks.h
@@ -171,7 +171,7 @@ static void call_rcu_tasks_generic(struct rcu_head *rhp, rcu_callback_t func,
 static void synchronize_rcu_tasks_generic(struct rcu_tasks *rtp)
 {
 	/* Complain if the scheduler has not started.  */
-	RCU_LOCKDEP_WARN(rcu_scheduler_active == RCU_SCHEDULER_INACTIVE,
+	WARN_ONCE(rcu_scheduler_active == RCU_SCHEDULER_INACTIVE,
 			 "synchronize_rcu_tasks called too soon");
 
 	/* Wait for the grace period. */
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index b41009a283ca..b10d6bcea77d 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -3393,15 +3393,16 @@ static void fill_page_cache_func(struct work_struct *work)
 		bnode = (struct kvfree_rcu_bulk_data *)
 			__get_free_page(GFP_KERNEL | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN);
 
-		if (bnode) {
-			raw_spin_lock_irqsave(&krcp->lock, flags);
-			pushed = put_cached_bnode(krcp, bnode);
-			raw_spin_unlock_irqrestore(&krcp->lock, flags);
+		if (!bnode)
+			break;
 
-			if (!pushed) {
-				free_page((unsigned long) bnode);
-				break;
-			}
+		raw_spin_lock_irqsave(&krcp->lock, flags);
+		pushed = put_cached_bnode(krcp, bnode);
+		raw_spin_unlock_irqrestore(&krcp->lock, flags);
+
+		if (!pushed) {
+			free_page((unsigned long) bnode);
+			break;
 		}
 	}
 
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index d868df6f13c8..2165c9ac14bf 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -5662,8 +5662,12 @@ int ftrace_regex_release(struct inode *inode, struct file *file)
 
 		if (filter_hash) {
 			orig_hash = &iter->ops->func_hash->filter_hash;
-			if (iter->tr && !list_empty(&iter->tr->mod_trace))
-				iter->hash->flags |= FTRACE_HASH_FL_MOD;
+			if (iter->tr) {
+				if (list_empty(&iter->tr->mod_trace))
+					iter->hash->flags &= ~FTRACE_HASH_FL_MOD;
+				else
+					iter->hash->flags |= FTRACE_HASH_FL_MOD;
+			}
 		} else
 			orig_hash = &iter->ops->func_hash->notrace_hash;
 
diff --git a/kernel/trace/kprobe_event_gen_test.c b/kernel/trace/kprobe_event_gen_test.c
index 18b0f1cbb947..80e04a1e1977 100644
--- a/kernel/trace/kprobe_event_gen_test.c
+++ b/kernel/trace/kprobe_event_gen_test.c
@@ -35,6 +35,45 @@
 static struct trace_event_file *gen_kprobe_test;
 static struct trace_event_file *gen_kretprobe_test;
 
+#define KPROBE_GEN_TEST_FUNC	"do_sys_open"
+
+/* X86 */
+#if defined(CONFIG_X86_64) || defined(CONFIG_X86_32)
+#define KPROBE_GEN_TEST_ARG0	"dfd=%ax"
+#define KPROBE_GEN_TEST_ARG1	"filename=%dx"
+#define KPROBE_GEN_TEST_ARG2	"flags=%cx"
+#define KPROBE_GEN_TEST_ARG3	"mode=+4($stack)"
+
+/* ARM64 */
+#elif defined(CONFIG_ARM64)
+#define KPROBE_GEN_TEST_ARG0	"dfd=%x0"
+#define KPROBE_GEN_TEST_ARG1	"filename=%x1"
+#define KPROBE_GEN_TEST_ARG2	"flags=%x2"
+#define KPROBE_GEN_TEST_ARG3	"mode=%x3"
+
+/* ARM */
+#elif defined(CONFIG_ARM)
+#define KPROBE_GEN_TEST_ARG0	"dfd=%r0"
+#define KPROBE_GEN_TEST_ARG1	"filename=%r1"
+#define KPROBE_GEN_TEST_ARG2	"flags=%r2"
+#define KPROBE_GEN_TEST_ARG3	"mode=%r3"
+
+/* RISCV */
+#elif defined(CONFIG_RISCV)
+#define KPROBE_GEN_TEST_ARG0	"dfd=%a0"
+#define KPROBE_GEN_TEST_ARG1	"filename=%a1"
+#define KPROBE_GEN_TEST_ARG2	"flags=%a2"
+#define KPROBE_GEN_TEST_ARG3	"mode=%a3"
+
+/* others */
+#else
+#define KPROBE_GEN_TEST_ARG0	NULL
+#define KPROBE_GEN_TEST_ARG1	NULL
+#define KPROBE_GEN_TEST_ARG2	NULL
+#define KPROBE_GEN_TEST_ARG3	NULL
+#endif
+
+
 /*
  * Test to make sure we can create a kprobe event, then add more
  * fields.
@@ -58,14 +97,14 @@ static int __init test_gen_kprobe_cmd(void)
 	 * fields.
 	 */
 	ret = kprobe_event_gen_cmd_start(&cmd, "gen_kprobe_test",
-					 "do_sys_open",
-					 "dfd=%ax", "filename=%dx");
+					 KPROBE_GEN_TEST_FUNC,
+					 KPROBE_GEN_TEST_ARG0, KPROBE_GEN_TEST_ARG1);
 	if (ret)
 		goto free;
 
 	/* Use kprobe_event_add_fields to add the rest of the fields */
 
-	ret = kprobe_event_add_fields(&cmd, "flags=%cx", "mode=+4($stack)");
+	ret = kprobe_event_add_fields(&cmd, KPROBE_GEN_TEST_ARG2, KPROBE_GEN_TEST_ARG3);
 	if (ret)
 		goto free;
 
@@ -128,7 +167,7 @@ static int __init test_gen_kretprobe_cmd(void)
 	 * Define the kretprobe event.
 	 */
 	ret = kretprobe_event_gen_cmd_start(&cmd, "gen_kretprobe_test",
-					    "do_sys_open",
+					    KPROBE_GEN_TEST_FUNC,
 					    "$retval");
 	if (ret)
 		goto free;
@@ -206,7 +245,7 @@ static void __exit kprobe_event_gen_test_exit(void)
 	WARN_ON(kprobe_event_delete("gen_kprobe_test"));
 
 	/* Disable the event or you can't remove it */
-	WARN_ON(trace_array_set_clr_event(gen_kprobe_test->tr,
+	WARN_ON(trace_array_set_clr_event(gen_kretprobe_test->tr,
 					  "kprobes",
 					  "gen_kretprobe_test", false));
 
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 6deac666ba3e..a12e27815555 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -414,6 +414,7 @@ struct rb_irq_work {
 	struct irq_work			work;
 	wait_queue_head_t		waiters;
 	wait_queue_head_t		full_waiters;
+	long				wait_index;
 	bool				waiters_pending;
 	bool				full_waiters_pending;
 	bool				wakeup_full;
@@ -794,12 +795,44 @@ static void rb_wake_up_waiters(struct irq_work *work)
 	struct rb_irq_work *rbwork = container_of(work, struct rb_irq_work, work);
 
 	wake_up_all(&rbwork->waiters);
-	if (rbwork->wakeup_full) {
+	if (rbwork->full_waiters_pending || rbwork->wakeup_full) {
 		rbwork->wakeup_full = false;
+		rbwork->full_waiters_pending = false;
 		wake_up_all(&rbwork->full_waiters);
 	}
 }
 
+/**
+ * ring_buffer_wake_waiters - wake up any waiters on this ring buffer
+ * @buffer: The ring buffer to wake waiters on
+ *
+ * In the case of a file that represents a ring buffer is closing,
+ * it is prudent to wake up any waiters that are on this.
+ */
+void ring_buffer_wake_waiters(struct trace_buffer *buffer, int cpu)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+	struct rb_irq_work *rbwork;
+
+	if (cpu == RING_BUFFER_ALL_CPUS) {
+
+		/* Wake up individual ones too. One level recursion */
+		for_each_buffer_cpu(buffer, cpu)
+			ring_buffer_wake_waiters(buffer, cpu);
+
+		rbwork = &buffer->irq_work;
+	} else {
+		cpu_buffer = buffer->buffers[cpu];
+		rbwork = &cpu_buffer->irq_work;
+	}
+
+	rbwork->wait_index++;
+	/* make sure the waiters see the new index */
+	smp_wmb();
+
+	rb_wake_up_waiters(&rbwork->work);
+}
+
 /**
  * ring_buffer_wait - wait for input to the ring buffer
  * @buffer: buffer to wait on
@@ -815,6 +848,7 @@ int ring_buffer_wait(struct trace_buffer *buffer, int cpu, int full)
 	struct ring_buffer_per_cpu *cpu_buffer;
 	DEFINE_WAIT(wait);
 	struct rb_irq_work *work;
+	long wait_index;
 	int ret = 0;
 
 	/*
@@ -833,6 +867,7 @@ int ring_buffer_wait(struct trace_buffer *buffer, int cpu, int full)
 		work = &cpu_buffer->irq_work;
 	}
 
+	wait_index = READ_ONCE(work->wait_index);
 
 	while (true) {
 		if (full)
@@ -888,7 +923,7 @@ int ring_buffer_wait(struct trace_buffer *buffer, int cpu, int full)
 			nr_pages = cpu_buffer->nr_pages;
 			dirty = ring_buffer_nr_dirty_pages(buffer, cpu);
 			if (!cpu_buffer->shortest_full ||
-			    cpu_buffer->shortest_full < full)
+			    cpu_buffer->shortest_full > full)
 				cpu_buffer->shortest_full = full;
 			raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 			if (!pagebusy &&
@@ -897,6 +932,11 @@ int ring_buffer_wait(struct trace_buffer *buffer, int cpu, int full)
 		}
 
 		schedule();
+
+		/* Make sure to see the new wait index */
+		smp_rmb();
+		if (wait_index != work->wait_index)
+			break;
 	}
 
 	if (full)
@@ -2491,6 +2531,9 @@ rb_reset_tail(struct ring_buffer_per_cpu *cpu_buffer,
 		/* Mark the rest of the page with padding */
 		rb_event_set_padding(event);
 
+		/* Make sure the padding is visible before the write update */
+		smp_wmb();
+
 		/* Set the write back to the previous setting */
 		local_sub(length, &tail_page->write);
 		return;
@@ -2502,6 +2545,9 @@ rb_reset_tail(struct ring_buffer_per_cpu *cpu_buffer,
 	/* time delta must be non zero */
 	event->time_delta = 1;
 
+	/* Make sure the padding is visible before the tail_page->write update */
+	smp_wmb();
+
 	/* Set write to end of buffer */
 	length = (tail + length) - BUF_PAGE_SIZE;
 	local_sub(length, &tail_page->write);
@@ -4316,6 +4362,33 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
 	arch_spin_unlock(&cpu_buffer->lock);
 	local_irq_restore(flags);
 
+	/*
+	 * The writer has preempt disable, wait for it. But not forever
+	 * Although, 1 second is pretty much "forever"
+	 */
+#define USECS_WAIT	1000000
+        for (nr_loops = 0; nr_loops < USECS_WAIT; nr_loops++) {
+		/* If the write is past the end of page, a writer is still updating it */
+		if (likely(!reader || rb_page_write(reader) <= BUF_PAGE_SIZE))
+			break;
+
+		udelay(1);
+
+		/* Get the latest version of the reader write value */
+		smp_rmb();
+	}
+
+	/* The writer is not moving forward? Something is wrong */
+	if (RB_WARN_ON(cpu_buffer, nr_loops == USECS_WAIT))
+		reader = NULL;
+
+	/*
+	 * Make sure we see any padding after the write update
+	 * (see rb_reset_tail())
+	 */
+	smp_rmb();
+
+
 	return reader;
 }
 
@@ -5341,7 +5414,15 @@ int ring_buffer_read_page(struct trace_buffer *buffer,
 		unsigned int pos = 0;
 		unsigned int size;
 
-		if (full)
+		/*
+		 * If a full page is expected, this can still be returned
+		 * if there's been a previous partial read and the
+		 * rest of the page can be read and the commit page is off
+		 * the reader page.
+		 */
+		if (full &&
+		    (!read || (len < (commit - read)) ||
+		     cpu_buffer->reader_page == cpu_buffer->commit_page))
 			goto out_unlock;
 
 		if (len > (commit - read))
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 50200898410d..a5245362ce7a 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1197,12 +1197,14 @@ void *tracing_cond_snapshot_data(struct trace_array *tr)
 {
 	void *cond_data = NULL;
 
+	local_irq_disable();
 	arch_spin_lock(&tr->max_lock);
 
 	if (tr->cond_snapshot)
 		cond_data = tr->cond_snapshot->cond_data;
 
 	arch_spin_unlock(&tr->max_lock);
+	local_irq_enable();
 
 	return cond_data;
 }
@@ -1338,9 +1340,11 @@ int tracing_snapshot_cond_enable(struct trace_array *tr, void *cond_data,
 		goto fail_unlock;
 	}
 
+	local_irq_disable();
 	arch_spin_lock(&tr->max_lock);
 	tr->cond_snapshot = cond_snapshot;
 	arch_spin_unlock(&tr->max_lock);
+	local_irq_enable();
 
 	mutex_unlock(&trace_types_lock);
 
@@ -1367,6 +1371,7 @@ int tracing_snapshot_cond_disable(struct trace_array *tr)
 {
 	int ret = 0;
 
+	local_irq_disable();
 	arch_spin_lock(&tr->max_lock);
 
 	if (!tr->cond_snapshot)
@@ -1377,6 +1382,7 @@ int tracing_snapshot_cond_disable(struct trace_array *tr)
 	}
 
 	arch_spin_unlock(&tr->max_lock);
+	local_irq_enable();
 
 	return ret;
 }
@@ -2198,6 +2204,11 @@ static size_t tgid_map_max;
 
 #define SAVED_CMDLINES_DEFAULT 128
 #define NO_CMDLINE_MAP UINT_MAX
+/*
+ * Preemption must be disabled before acquiring trace_cmdline_lock.
+ * The various trace_arrays' max_lock must be acquired in a context
+ * where interrupt is disabled.
+ */
 static arch_spinlock_t trace_cmdline_lock = __ARCH_SPIN_LOCK_UNLOCKED;
 struct saved_cmdlines_buffer {
 	unsigned map_pid_to_cmdline[PID_MAX_DEFAULT+1];
@@ -2410,7 +2421,11 @@ static int trace_save_cmdline(struct task_struct *tsk)
 	 * the lock, but we also don't want to spin
 	 * nor do we want to disable interrupts,
 	 * so if we miss here, then better luck next time.
+	 *
+	 * This is called within the scheduler and wake up, so interrupts
+	 * had better been disabled and run queue lock been held.
 	 */
+	lockdep_assert_preemption_disabled();
 	if (!arch_spin_trylock(&trace_cmdline_lock))
 		return 0;
 
@@ -5470,9 +5485,11 @@ tracing_saved_cmdlines_size_read(struct file *filp, char __user *ubuf,
 	char buf[64];
 	int r;
 
+	preempt_disable();
 	arch_spin_lock(&trace_cmdline_lock);
 	r = scnprintf(buf, sizeof(buf), "%u\n", savedcmd->cmdline_num);
 	arch_spin_unlock(&trace_cmdline_lock);
+	preempt_enable();
 
 	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
 }
@@ -5497,10 +5514,12 @@ static int tracing_resize_saved_cmdlines(unsigned int val)
 		return -ENOMEM;
 	}
 
+	preempt_disable();
 	arch_spin_lock(&trace_cmdline_lock);
 	savedcmd_temp = savedcmd;
 	savedcmd = s;
 	arch_spin_unlock(&trace_cmdline_lock);
+	preempt_enable();
 	free_saved_cmdlines_buffer(savedcmd_temp);
 
 	return 0;
@@ -5953,10 +5972,12 @@ int tracing_set_tracer(struct trace_array *tr, const char *buf)
 
 #ifdef CONFIG_TRACER_SNAPSHOT
 	if (t->use_max_tr) {
+		local_irq_disable();
 		arch_spin_lock(&tr->max_lock);
 		if (tr->cond_snapshot)
 			ret = -EBUSY;
 		arch_spin_unlock(&tr->max_lock);
+		local_irq_enable();
 		if (ret)
 			goto out;
 	}
@@ -7030,10 +7051,12 @@ tracing_snapshot_write(struct file *filp, const char __user *ubuf, size_t cnt,
 		goto out;
 	}
 
+	local_irq_disable();
 	arch_spin_lock(&tr->max_lock);
 	if (tr->cond_snapshot)
 		ret = -EBUSY;
 	arch_spin_unlock(&tr->max_lock);
+	local_irq_enable();
 	if (ret)
 		goto out;
 
diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 921d0a654243..10a50c03074e 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -207,10 +207,11 @@ static int ddebug_change(const struct ddebug_query *query,
 				continue;
 #ifdef CONFIG_JUMP_LABEL
 			if (dp->flags & _DPRINTK_FLAGS_PRINT) {
-				if (!(modifiers->flags & _DPRINTK_FLAGS_PRINT))
+				if (!(newflags & _DPRINTK_FLAGS_PRINT))
 					static_branch_disable(&dp->key.dd_key_true);
-			} else if (modifiers->flags & _DPRINTK_FLAGS_PRINT)
+			} else if (newflags & _DPRINTK_FLAGS_PRINT) {
 				static_branch_enable(&dp->key.dd_key_true);
+			}
 #endif
 			dp->flags = newflags;
 			v2pr_info("changed %s:%d [%s]%s =%s\n",
@@ -379,10 +380,6 @@ static int ddebug_parse_query(char *words[], int nwords,
 		return -EINVAL;
 	}
 
-	if (modname)
-		/* support $modname.dyndbg=<multiple queries> */
-		query->module = modname;
-
 	for (i = 0; i < nwords; i += 2) {
 		char *keyword = words[i];
 		char *arg = words[i+1];
@@ -423,6 +420,13 @@ static int ddebug_parse_query(char *words[], int nwords,
 		if (rc)
 			return rc;
 	}
+	if (!query->module && modname)
+		/*
+		 * support $modname.dyndbg=<multiple queries>, when
+		 * not given in the query itself
+		 */
+		query->module = modname;
+
 	vpr_info_dq(query, "parsed");
 	return 0;
 }
@@ -548,35 +552,6 @@ static int ddebug_exec_queries(char *query, const char *modname)
 	return nfound;
 }
 
-/**
- * dynamic_debug_exec_queries - select and change dynamic-debug prints
- * @query: query-string described in admin-guide/dynamic-debug-howto
- * @modname: string containing module name, usually &module.mod_name
- *
- * This uses the >/proc/dynamic_debug/control reader, allowing module
- * authors to modify their dynamic-debug callsites. The modname is
- * canonically struct module.mod_name, but can also be null or a
- * module-wildcard, for example: "drm*".
- */
-int dynamic_debug_exec_queries(const char *query, const char *modname)
-{
-	int rc;
-	char *qry; /* writable copy of query */
-
-	if (!query) {
-		pr_err("non-null query/command string expected\n");
-		return -EINVAL;
-	}
-	qry = kstrndup(query, PAGE_SIZE, GFP_KERNEL);
-	if (!qry)
-		return -ENOMEM;
-
-	rc = ddebug_exec_queries(qry, modname);
-	kfree(qry);
-	return rc;
-}
-EXPORT_SYMBOL_GPL(dynamic_debug_exec_queries);
-
 #define PREFIX_SIZE 64
 
 static int remaining(int wrote)
diff --git a/lib/once.c b/lib/once.c
index 59149bf3bfb4..351f66aad310 100644
--- a/lib/once.c
+++ b/lib/once.c
@@ -66,3 +66,33 @@ void __do_once_done(bool *done, struct static_key_true *once_key,
 	once_disable_jump(once_key, mod);
 }
 EXPORT_SYMBOL(__do_once_done);
+
+static DEFINE_MUTEX(once_mutex);
+
+bool __do_once_slow_start(bool *done)
+	__acquires(once_mutex)
+{
+	mutex_lock(&once_mutex);
+	if (*done) {
+		mutex_unlock(&once_mutex);
+		/* Keep sparse happy by restoring an even lock count on
+		 * this mutex. In case we return here, we don't call into
+		 * __do_once_done but return early in the DO_ONCE_SLOW() macro.
+		 */
+		__acquire(once_mutex);
+		return false;
+	}
+
+	return true;
+}
+EXPORT_SYMBOL(__do_once_slow_start);
+
+void __do_once_slow_done(bool *done, struct static_key_true *once_key,
+			 struct module *mod)
+	__releases(once_mutex)
+{
+	*done = true;
+	mutex_unlock(&once_mutex);
+	once_disable_jump(once_key, mod);
+}
+EXPORT_SYMBOL(__do_once_slow_done);
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index c42c76447e10..c57c165bfbbc 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4337,6 +4337,7 @@ static vm_fault_t hugetlb_no_page(struct mm_struct *mm,
 	spinlock_t *ptl;
 	unsigned long haddr = address & huge_page_mask(h);
 	bool new_page = false;
+	u32 hash = hugetlb_fault_mutex_hash(mapping, idx);
 
 	/*
 	 * Currently, we are forced to kill the process in the event the
@@ -4346,7 +4347,7 @@ static vm_fault_t hugetlb_no_page(struct mm_struct *mm,
 	if (is_vma_resv_set(vma, HPAGE_RESV_UNMAPPED)) {
 		pr_warn_ratelimited("PID %d killed due to inadequate hugepage pool\n",
 			   current->pid);
-		return ret;
+		goto out;
 	}
 
 	/*
@@ -4365,7 +4366,6 @@ static vm_fault_t hugetlb_no_page(struct mm_struct *mm,
 		 * Check for page in userfault range
 		 */
 		if (userfaultfd_missing(vma)) {
-			u32 hash;
 			struct vm_fault vmf = {
 				.vma = vma,
 				.address = haddr,
@@ -4380,17 +4380,14 @@ static vm_fault_t hugetlb_no_page(struct mm_struct *mm,
 			};
 
 			/*
-			 * hugetlb_fault_mutex and i_mmap_rwsem must be
-			 * dropped before handling userfault.  Reacquire
-			 * after handling fault to make calling code simpler.
+			 * vma_lock and hugetlb_fault_mutex must be dropped
+			 * before handling userfault. Also mmap_lock will
+			 * be dropped during handling userfault, any vma
+			 * operation should be careful from here.
 			 */
-			hash = hugetlb_fault_mutex_hash(mapping, idx);
 			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 			i_mmap_unlock_read(mapping);
-			ret = handle_userfault(&vmf, VM_UFFD_MISSING);
-			i_mmap_lock_read(mapping);
-			mutex_lock(&hugetlb_fault_mutex_table[hash]);
-			goto out;
+			return handle_userfault(&vmf, VM_UFFD_MISSING);
 		}
 
 		page = alloc_huge_page(vma, haddr, 0);
@@ -4497,6 +4494,8 @@ static vm_fault_t hugetlb_no_page(struct mm_struct *mm,
 
 	unlock_page(page);
 out:
+	mutex_unlock(&hugetlb_fault_mutex_table[hash]);
+	i_mmap_unlock_read(mapping);
 	return ret;
 
 backout:
@@ -4592,10 +4591,12 @@ vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	mutex_lock(&hugetlb_fault_mutex_table[hash]);
 
 	entry = huge_ptep_get(ptep);
-	if (huge_pte_none(entry)) {
-		ret = hugetlb_no_page(mm, vma, mapping, idx, address, ptep, flags);
-		goto out_mutex;
-	}
+	if (huge_pte_none(entry))
+		/*
+		 * hugetlb_no_page will drop vma lock and hugetlb fault
+		 * mutex internally, which make us return immediately.
+		 */
+		return hugetlb_no_page(mm, vma, mapping, idx, address, ptep, flags);
 
 	ret = 0;
 
diff --git a/mm/mmap.c b/mm/mmap.c
index 31fc116a8ec9..33ebda8385b9 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1856,7 +1856,7 @@ unsigned long mmap_region(struct file *file, unsigned long addr,
 	if (!arch_validate_flags(vma->vm_flags)) {
 		error = -EINVAL;
 		if (file)
-			goto unmap_and_free_vma;
+			goto close_and_free_vma;
 		else
 			goto free_vma;
 	}
@@ -1900,6 +1900,9 @@ unsigned long mmap_region(struct file *file, unsigned long addr,
 
 	return addr;
 
+close_and_free_vma:
+	if (vma->vm_ops && vma->vm_ops->close)
+		vma->vm_ops->close(vma);
 unmap_and_free_vma:
 	vma->vm_file = NULL;
 	fput(file);
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 2cb0cf035476..866eb22432de 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -4482,15 +4482,27 @@ static inline int __get_blocks(struct hci_dev *hdev, struct sk_buff *skb)
 	return DIV_ROUND_UP(skb->len - HCI_ACL_HDR_SIZE, hdev->block_len);
 }
 
-static void __check_timeout(struct hci_dev *hdev, unsigned int cnt)
+static void __check_timeout(struct hci_dev *hdev, unsigned int cnt, u8 type)
 {
-	if (!hci_dev_test_flag(hdev, HCI_UNCONFIGURED)) {
-		/* ACL tx timeout must be longer than maximum
-		 * link supervision timeout (40.9 seconds) */
-		if (!cnt && time_after(jiffies, hdev->acl_last_tx +
-				       HCI_ACL_TX_TIMEOUT))
-			hci_link_tx_to(hdev, ACL_LINK);
+	unsigned long last_tx;
+
+	if (hci_dev_test_flag(hdev, HCI_UNCONFIGURED))
+		return;
+
+	switch (type) {
+	case LE_LINK:
+		last_tx = hdev->le_last_tx;
+		break;
+	default:
+		last_tx = hdev->acl_last_tx;
+		break;
 	}
+
+	/* tx timeout must be longer than maximum link supervision timeout
+	 * (40.9 seconds)
+	 */
+	if (!cnt && time_after(jiffies, last_tx + HCI_ACL_TX_TIMEOUT))
+		hci_link_tx_to(hdev, type);
 }
 
 /* Schedule SCO */
@@ -4548,7 +4560,7 @@ static void hci_sched_acl_pkt(struct hci_dev *hdev)
 	struct sk_buff *skb;
 	int quote;
 
-	__check_timeout(hdev, cnt);
+	__check_timeout(hdev, cnt, ACL_LINK);
 
 	while (hdev->acl_cnt &&
 	       (chan = hci_chan_sent(hdev, ACL_LINK, &quote))) {
@@ -4591,8 +4603,6 @@ static void hci_sched_acl_blk(struct hci_dev *hdev)
 	int quote;
 	u8 type;
 
-	__check_timeout(hdev, cnt);
-
 	BT_DBG("%s", hdev->name);
 
 	if (hdev->dev_type == HCI_AMP)
@@ -4600,6 +4610,8 @@ static void hci_sched_acl_blk(struct hci_dev *hdev)
 	else
 		type = ACL_LINK;
 
+	__check_timeout(hdev, cnt, type);
+
 	while (hdev->block_cnt > 0 &&
 	       (chan = hci_chan_sent(hdev, type, &quote))) {
 		u32 priority = (skb_peek(&chan->data_q))->priority;
@@ -4673,7 +4685,7 @@ static void hci_sched_le(struct hci_dev *hdev)
 
 	cnt = hdev->le_pkts ? hdev->le_cnt : hdev->acl_cnt;
 
-	__check_timeout(hdev, cnt);
+	__check_timeout(hdev, cnt, LE_LINK);
 
 	tmp = cnt;
 	while (cnt && (chan = hci_chan_sent(hdev, LE_LINK, &quote))) {
diff --git a/net/bluetooth/hci_sysfs.c b/net/bluetooth/hci_sysfs.c
index b69d88b88d2e..ccd2c377bf83 100644
--- a/net/bluetooth/hci_sysfs.c
+++ b/net/bluetooth/hci_sysfs.c
@@ -48,6 +48,9 @@ void hci_conn_add_sysfs(struct hci_conn *conn)
 
 	BT_DBG("conn %p", conn);
 
+	if (device_is_registered(&conn->dev))
+		return;
+
 	dev_set_name(&conn->dev, "%s:%d", hdev->name, conn->handle);
 
 	if (device_add(&conn->dev) < 0) {
diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 0c38af2ff209..83dd76e9196f 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -61,6 +61,9 @@ static void l2cap_send_disconn_req(struct l2cap_chan *chan, int err);
 
 static void l2cap_tx(struct l2cap_chan *chan, struct l2cap_ctrl *control,
 		     struct sk_buff_head *skbs, u8 event);
+static void l2cap_retrans_timeout(struct work_struct *work);
+static void l2cap_monitor_timeout(struct work_struct *work);
+static void l2cap_ack_timeout(struct work_struct *work);
 
 static inline u8 bdaddr_type(u8 link_type, u8 bdaddr_type)
 {
@@ -476,6 +479,9 @@ struct l2cap_chan *l2cap_chan_create(void)
 	write_unlock(&chan_list_lock);
 
 	INIT_DELAYED_WORK(&chan->chan_timer, l2cap_chan_timeout);
+	INIT_DELAYED_WORK(&chan->retrans_timer, l2cap_retrans_timeout);
+	INIT_DELAYED_WORK(&chan->monitor_timer, l2cap_monitor_timeout);
+	INIT_DELAYED_WORK(&chan->ack_timer, l2cap_ack_timeout);
 
 	chan->state = BT_OPEN;
 
@@ -3316,10 +3322,6 @@ int l2cap_ertm_init(struct l2cap_chan *chan)
 	chan->rx_state = L2CAP_RX_STATE_RECV;
 	chan->tx_state = L2CAP_TX_STATE_XMIT;
 
-	INIT_DELAYED_WORK(&chan->retrans_timer, l2cap_retrans_timeout);
-	INIT_DELAYED_WORK(&chan->monitor_timer, l2cap_monitor_timeout);
-	INIT_DELAYED_WORK(&chan->ack_timer, l2cap_ack_timeout);
-
 	skb_queue_head_init(&chan->srej_q);
 
 	err = l2cap_seq_list_init(&chan->srej_list, chan->tx_win);
@@ -4303,6 +4305,12 @@ static int l2cap_connect_create_rsp(struct l2cap_conn *conn,
 		}
 	}
 
+	chan = l2cap_chan_hold_unless_zero(chan);
+	if (!chan) {
+		err = -EBADSLT;
+		goto unlock;
+	}
+
 	err = 0;
 
 	l2cap_chan_lock(chan);
@@ -4332,6 +4340,7 @@ static int l2cap_connect_create_rsp(struct l2cap_conn *conn,
 	}
 
 	l2cap_chan_unlock(chan);
+	l2cap_chan_put(chan);
 
 unlock:
 	mutex_unlock(&conn->chan_lock);
diff --git a/net/can/bcm.c b/net/can/bcm.c
index e918a0f3cda2..afa82adaf6cd 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -274,6 +274,7 @@ static void bcm_can_tx(struct bcm_op *op)
 	struct sk_buff *skb;
 	struct net_device *dev;
 	struct canfd_frame *cf = op->frames + op->cfsiz * op->currframe;
+	int err;
 
 	/* no target device? => exit */
 	if (!op->ifindex)
@@ -298,11 +299,11 @@ static void bcm_can_tx(struct bcm_op *op)
 	/* send with loopback */
 	skb->dev = dev;
 	can_skb_set_owner(skb, op->sk);
-	can_send(skb, 1);
+	err = can_send(skb, 1);
+	if (!err)
+		op->frames_abs++;
 
-	/* update statistics */
 	op->currframe++;
-	op->frames_abs++;
 
 	/* reached last frame? */
 	if (op->currframe >= op->nframes)
diff --git a/net/core/stream.c b/net/core/stream.c
index a166a32b411f..a61130504827 100644
--- a/net/core/stream.c
+++ b/net/core/stream.c
@@ -159,7 +159,8 @@ int sk_stream_wait_memory(struct sock *sk, long *timeo_p)
 		*timeo_p = current_timeo;
 	}
 out:
-	remove_wait_queue(sk_sleep(sk), &wait);
+	if (!sock_flag(sk, SOCK_DEAD))
+		remove_wait_queue(sk_sleep(sk), &wait);
 	return err;
 
 do_error:
diff --git a/net/ieee802154/socket.c b/net/ieee802154/socket.c
index 7edec210780a..ecc0d5fbde04 100644
--- a/net/ieee802154/socket.c
+++ b/net/ieee802154/socket.c
@@ -273,6 +273,10 @@ static int raw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 		err = -EMSGSIZE;
 		goto out_dev;
 	}
+	if (!size) {
+		err = 0;
+		goto out_dev;
+	}
 
 	hlen = LL_RESERVED_SPACE(dev);
 	tlen = dev->needed_tailroom;
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index a733ce1a3f8f..87d73a3e92ba 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -158,7 +158,7 @@ void inet_sock_destruct(struct sock *sk)
 
 	kfree(rcu_dereference_protected(inet->inet_opt, 1));
 	dst_release(rcu_dereference_protected(sk->sk_dst_cache, 1));
-	dst_release(sk->sk_rx_dst);
+	dst_release(rcu_dereference_protected(sk->sk_rx_dst, 1));
 	sk_refcnt_debug_dec(sk);
 }
 EXPORT_SYMBOL(inet_sock_destruct);
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index feb7f072f2b2..c0de655fffd7 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -771,8 +771,8 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 	if (likely(remaining > 1))
 		remaining &= ~1U;
 
-	net_get_random_once(table_perturb,
-			    INET_TABLE_PERTURB_SIZE * sizeof(*table_perturb));
+	get_random_slow_once(table_perturb,
+			     INET_TABLE_PERTURB_SIZE * sizeof(*table_perturb));
 	index = port_offset & (INET_TABLE_PERTURB_SIZE - 1);
 
 	offset = READ_ONCE(table_perturb[index]) + (port_offset >> 32);
diff --git a/net/ipv4/netfilter/nft_fib_ipv4.c b/net/ipv4/netfilter/nft_fib_ipv4.c
index 03df986217b7..9e6f0f1275e2 100644
--- a/net/ipv4/netfilter/nft_fib_ipv4.c
+++ b/net/ipv4/netfilter/nft_fib_ipv4.c
@@ -83,6 +83,9 @@ void nft_fib4_eval(const struct nft_expr *expr, struct nft_regs *regs,
 	else
 		oif = NULL;
 
+	if (priv->flags & NFTA_FIB_F_IIF)
+		fl4.flowi4_oif = l3mdev_master_ifindex_rcu(oif);
+
 	if (nft_hook(pkt) == NF_INET_PRE_ROUTING &&
 	    nft_fib_is_loopback(pkt->skb, nft_in(pkt))) {
 		nft_fib_store_result(dest, priv, nft_in(pkt));
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index bfeb05f62b94..a7127364253c 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2796,6 +2796,8 @@ int tcp_disconnect(struct sock *sk, int flags)
 	tp->snd_ssthresh = TCP_INFINITE_SSTHRESH;
 	tp->snd_cwnd = TCP_INIT_CWND;
 	tp->snd_cwnd_cnt = 0;
+	tp->is_cwnd_limited = 0;
+	tp->max_packets_out = 0;
 	tp->window_clamp = 0;
 	tp->delivered = 0;
 	tp->delivered_ce = 0;
@@ -2814,8 +2816,7 @@ int tcp_disconnect(struct sock *sk, int flags)
 	icsk->icsk_ack.rcv_mss = TCP_MIN_MSS;
 	memset(&tp->rx_opt, 0, sizeof(tp->rx_opt));
 	__sk_dst_reset(sk);
-	dst_release(sk->sk_rx_dst);
-	sk->sk_rx_dst = NULL;
+	dst_release(xchg((__force struct dst_entry **)&sk->sk_rx_dst, NULL));
 	tcp_saved_syn_free(tp);
 	tp->compressed_ack = 0;
 	tp->segs_in = 0;
@@ -4041,12 +4042,16 @@ static void __tcp_alloc_md5sig_pool(void)
 	 * to memory. See smp_rmb() in tcp_get_md5sig_pool()
 	 */
 	smp_wmb();
-	tcp_md5sig_pool_populated = true;
+	/* Paired with READ_ONCE() from tcp_alloc_md5sig_pool()
+	 * and tcp_get_md5sig_pool().
+	*/
+	WRITE_ONCE(tcp_md5sig_pool_populated, true);
 }
 
 bool tcp_alloc_md5sig_pool(void)
 {
-	if (unlikely(!tcp_md5sig_pool_populated)) {
+	/* Paired with WRITE_ONCE() from __tcp_alloc_md5sig_pool() */
+	if (unlikely(!READ_ONCE(tcp_md5sig_pool_populated))) {
 		mutex_lock(&tcp_md5sig_mutex);
 
 		if (!tcp_md5sig_pool_populated) {
@@ -4057,7 +4062,8 @@ bool tcp_alloc_md5sig_pool(void)
 
 		mutex_unlock(&tcp_md5sig_mutex);
 	}
-	return tcp_md5sig_pool_populated;
+	/* Paired with WRITE_ONCE() from __tcp_alloc_md5sig_pool() */
+	return READ_ONCE(tcp_md5sig_pool_populated);
 }
 EXPORT_SYMBOL(tcp_alloc_md5sig_pool);
 
@@ -4073,7 +4079,8 @@ struct tcp_md5sig_pool *tcp_get_md5sig_pool(void)
 {
 	local_bh_disable();
 
-	if (tcp_md5sig_pool_populated) {
+	/* Paired with WRITE_ONCE() from __tcp_alloc_md5sig_pool() */
+	if (READ_ONCE(tcp_md5sig_pool_populated)) {
 		/* coupled with smp_wmb() in __tcp_alloc_md5sig_pool() */
 		smp_rmb();
 		return this_cpu_ptr(&tcp_md5sig_pool);
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 4ecd85b1e806..377cba9b124d 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5777,7 +5777,7 @@ void tcp_rcv_established(struct sock *sk, struct sk_buff *skb)
 	trace_tcp_probe(sk, skb);
 
 	tcp_mstamp_refresh(tp);
-	if (unlikely(!sk->sk_rx_dst))
+	if (unlikely(!rcu_access_pointer(sk->sk_rx_dst)))
 		inet_csk(sk)->icsk_af_ops->sk_rx_dst_set(sk, skb);
 	/*
 	 *	Header prediction.
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 0d165ce2d80a..5c1e6b0687e2 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1670,15 +1670,18 @@ int tcp_v4_do_rcv(struct sock *sk, struct sk_buff *skb)
 	struct sock *rsk;
 
 	if (sk->sk_state == TCP_ESTABLISHED) { /* Fast path */
-		struct dst_entry *dst = sk->sk_rx_dst;
+		struct dst_entry *dst;
+
+		dst = rcu_dereference_protected(sk->sk_rx_dst,
+						lockdep_sock_is_held(sk));
 
 		sock_rps_save_rxhash(sk, skb);
 		sk_mark_napi_id(sk, skb);
 		if (dst) {
 			if (inet_sk(sk)->rx_dst_ifindex != skb->skb_iif ||
 			    !dst->ops->check(dst, 0)) {
+				RCU_INIT_POINTER(sk->sk_rx_dst, NULL);
 				dst_release(dst);
-				sk->sk_rx_dst = NULL;
 			}
 		}
 		tcp_rcv_established(sk, skb);
@@ -1753,7 +1756,7 @@ int tcp_v4_early_demux(struct sk_buff *skb)
 		skb->sk = sk;
 		skb->destructor = sock_edemux;
 		if (sk_fullsock(sk)) {
-			struct dst_entry *dst = READ_ONCE(sk->sk_rx_dst);
+			struct dst_entry *dst = rcu_dereference(sk->sk_rx_dst);
 
 			if (dst)
 				dst = dst_check(dst, 0);
@@ -2162,7 +2165,7 @@ void inet_sk_rx_dst_set(struct sock *sk, const struct sk_buff *skb)
 	struct dst_entry *dst = skb_dst(skb);
 
 	if (dst && dst_hold_safe(dst)) {
-		sk->sk_rx_dst = dst;
+		rcu_assign_pointer(sk->sk_rx_dst, dst);
 		inet_sk(sk)->rx_dst_ifindex = skb->skb_iif;
 	}
 }
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 48fce999dc61..eefd032bc6db 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1876,15 +1876,20 @@ static void tcp_cwnd_validate(struct sock *sk, bool is_cwnd_limited)
 	const struct tcp_congestion_ops *ca_ops = inet_csk(sk)->icsk_ca_ops;
 	struct tcp_sock *tp = tcp_sk(sk);
 
-	/* Track the maximum number of outstanding packets in each
-	 * window, and remember whether we were cwnd-limited then.
+	/* Track the strongest available signal of the degree to which the cwnd
+	 * is fully utilized. If cwnd-limited then remember that fact for the
+	 * current window. If not cwnd-limited then track the maximum number of
+	 * outstanding packets in the current window. (If cwnd-limited then we
+	 * chose to not update tp->max_packets_out to avoid an extra else
+	 * clause with no functional impact.)
 	 */
-	if (!before(tp->snd_una, tp->max_packets_seq) ||
-	    tp->packets_out > tp->max_packets_out ||
-	    is_cwnd_limited) {
-		tp->max_packets_out = tp->packets_out;
-		tp->max_packets_seq = tp->snd_nxt;
+	if (!before(tp->snd_una, tp->cwnd_usage_seq) ||
+	    is_cwnd_limited ||
+	    (!tp->is_cwnd_limited &&
+	     tp->packets_out > tp->max_packets_out)) {
 		tp->is_cwnd_limited = is_cwnd_limited;
+		tp->max_packets_out = tp->packets_out;
+		tp->cwnd_usage_seq = tp->snd_nxt;
 	}
 
 	if (tcp_is_cwnd_limited(sk)) {
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index e498c7666ec6..4446aa8237ff 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2193,7 +2193,7 @@ bool udp_sk_rx_dst_set(struct sock *sk, struct dst_entry *dst)
 	struct dst_entry *old;
 
 	if (dst_hold_safe(dst)) {
-		old = xchg(&sk->sk_rx_dst, dst);
+		old = xchg((__force struct dst_entry **)&sk->sk_rx_dst, dst);
 		dst_release(old);
 		return old != dst;
 	}
@@ -2383,7 +2383,7 @@ int __udp4_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 		struct dst_entry *dst = skb_dst(skb);
 		int ret;
 
-		if (unlikely(sk->sk_rx_dst != dst))
+		if (unlikely(rcu_dereference(sk->sk_rx_dst) != dst))
 			udp_sk_rx_dst_set(sk, dst);
 
 		ret = udp_unicast_rcv_skb(sk, skb, uh);
@@ -2541,7 +2541,7 @@ int udp_v4_early_demux(struct sk_buff *skb)
 
 	skb->sk = sk;
 	skb->destructor = sock_efree;
-	dst = READ_ONCE(sk->sk_rx_dst);
+	dst = rcu_dereference(sk->sk_rx_dst);
 
 	if (dst)
 		dst = dst_check(dst, 0);
diff --git a/net/ipv6/netfilter/nft_fib_ipv6.c b/net/ipv6/netfilter/nft_fib_ipv6.c
index 92f3235fa287..602743f6dcee 100644
--- a/net/ipv6/netfilter/nft_fib_ipv6.c
+++ b/net/ipv6/netfilter/nft_fib_ipv6.c
@@ -37,6 +37,9 @@ static int nft_fib6_flowi_init(struct flowi6 *fl6, const struct nft_fib *priv,
 	if (ipv6_addr_type(&fl6->daddr) & IPV6_ADDR_LINKLOCAL) {
 		lookup_flags |= RT6_LOOKUP_F_IFACE;
 		fl6->flowi6_oif = get_ifindex(dev ? dev : pkt->skb->dev);
+	} else if ((priv->flags & NFTA_FIB_F_IIF) &&
+		   (netif_is_l3_master(dev) || netif_is_l3_slave(dev))) {
+		fl6->flowi6_oif = dev->ifindex;
 	}
 
 	if (ipv6_addr_type(&fl6->saddr) & IPV6_ADDR_UNICAST)
@@ -193,7 +196,8 @@ void nft_fib6_eval(const struct nft_expr *expr, struct nft_regs *regs,
 	if (rt->rt6i_flags & (RTF_REJECT | RTF_ANYCAST | RTF_LOCAL))
 		goto put_rt_err;
 
-	if (oif && oif != rt->rt6i_idev->dev)
+	if (oif && oif != rt->rt6i_idev->dev &&
+	    l3mdev_master_ifindex_rcu(rt->rt6i_idev->dev) != oif->ifindex)
 		goto put_rt_err;
 
 	nft_fib_store_result(dest, priv, rt->rt6i_idev->dev);
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 8d91f36cb11b..c14eaec64a0b 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -107,7 +107,7 @@ static void inet6_sk_rx_dst_set(struct sock *sk, const struct sk_buff *skb)
 	if (dst && dst_hold_safe(dst)) {
 		const struct rt6_info *rt = (const struct rt6_info *)dst;
 
-		sk->sk_rx_dst = dst;
+		rcu_assign_pointer(sk->sk_rx_dst, dst);
 		inet_sk(sk)->rx_dst_ifindex = skb->skb_iif;
 		tcp_inet6_sk(sk)->rx_dst_cookie = rt6_get_cookie(rt);
 	}
@@ -1482,15 +1482,18 @@ static int tcp_v6_do_rcv(struct sock *sk, struct sk_buff *skb)
 		opt_skb = skb_clone(skb, sk_gfp_mask(sk, GFP_ATOMIC));
 
 	if (sk->sk_state == TCP_ESTABLISHED) { /* Fast path */
-		struct dst_entry *dst = sk->sk_rx_dst;
+		struct dst_entry *dst;
+
+		dst = rcu_dereference_protected(sk->sk_rx_dst,
+						lockdep_sock_is_held(sk));
 
 		sock_rps_save_rxhash(sk, skb);
 		sk_mark_napi_id(sk, skb);
 		if (dst) {
 			if (inet_sk(sk)->rx_dst_ifindex != skb->skb_iif ||
 			    dst->ops->check(dst, np->rx_dst_cookie) == NULL) {
+				RCU_INIT_POINTER(sk->sk_rx_dst, NULL);
 				dst_release(dst);
-				sk->sk_rx_dst = NULL;
 			}
 		}
 
@@ -1842,7 +1845,7 @@ INDIRECT_CALLABLE_SCOPE void tcp_v6_early_demux(struct sk_buff *skb)
 		skb->sk = sk;
 		skb->destructor = sock_edemux;
 		if (sk_fullsock(sk)) {
-			struct dst_entry *dst = READ_ONCE(sk->sk_rx_dst);
+			struct dst_entry *dst = rcu_dereference(sk->sk_rx_dst);
 
 			if (dst)
 				dst = dst_check(dst, tcp_inet6_sk(sk)->rx_dst_cookie);
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 4e90e5a52945..9b504bf49214 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -941,7 +941,7 @@ int __udp6_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 		struct dst_entry *dst = skb_dst(skb);
 		int ret;
 
-		if (unlikely(sk->sk_rx_dst != dst))
+		if (unlikely(rcu_dereference(sk->sk_rx_dst) != dst))
 			udp6_sk_rx_dst_set(sk, dst);
 
 		if (!uh->check && !udp_sk(sk)->no_check6_rx) {
@@ -1055,7 +1055,7 @@ INDIRECT_CALLABLE_SCOPE void udp_v6_early_demux(struct sk_buff *skb)
 
 	skb->sk = sk;
 	skb->destructor = sock_efree;
-	dst = READ_ONCE(sk->sk_rx_dst);
+	dst = rcu_dereference(sk->sk_rx_dst);
 
 	if (dst)
 		dst = dst_check(dst, inet6_sk(sk)->rx_dst_cookie);
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 8010967a6874..c6a7f1c99abc 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3357,9 +3357,6 @@ static int ieee80211_set_csa_beacon(struct ieee80211_sub_if_data *sdata,
 	case NL80211_IFTYPE_MESH_POINT: {
 		struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 
-		if (params->chandef.width != sdata->vif.bss_conf.chandef.width)
-			return -EINVAL;
-
 		/* changes into another band are not supported */
 		if (sdata->vif.bss_conf.chandef.chan->band !=
 		    params->chandef.chan->band)
diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 9d6ef6cb9b26..6b5c0abf7f1b 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -241,10 +241,17 @@ void ovs_dp_process_packet(struct sk_buff *skb, struct sw_flow_key *key)
 		upcall.portid = ovs_vport_find_upcall_portid(p, skb);
 		upcall.mru = OVS_CB(skb)->mru;
 		error = ovs_dp_upcall(dp, skb, key, &upcall, 0);
-		if (unlikely(error))
-			kfree_skb(skb);
-		else
+		switch (error) {
+		case 0:
+		case -EAGAIN:
+		case -ERESTARTSYS:
+		case -EINTR:
 			consume_skb(skb);
+			break;
+		default:
+			kfree_skb(skb);
+			break;
+		}
 		stats_counter = &stats->n_missed;
 		goto out;
 	}
@@ -537,8 +544,9 @@ static int queue_userspace_packet(struct datapath *dp, struct sk_buff *skb,
 out:
 	if (err)
 		skb_tx_error(skb);
-	kfree_skb(user_skb);
-	kfree_skb(nskb);
+	consume_skb(user_skb);
+	consume_skb(nskb);
+
 	return err;
 }
 
diff --git a/net/rds/tcp.c b/net/rds/tcp.c
index 5327d130c4b5..b560d06e6d96 100644
--- a/net/rds/tcp.c
+++ b/net/rds/tcp.c
@@ -166,10 +166,10 @@ void rds_tcp_reset_callbacks(struct socket *sock,
 	 */
 	atomic_set(&cp->cp_state, RDS_CONN_RESETTING);
 	wait_event(cp->cp_waitq, !test_bit(RDS_IN_XMIT, &cp->cp_flags));
-	lock_sock(osock->sk);
 	/* reset receive side state for rds_tcp_data_recv() for osock  */
 	cancel_delayed_work_sync(&cp->cp_send_w);
 	cancel_delayed_work_sync(&cp->cp_recv_w);
+	lock_sock(osock->sk);
 	if (tc->t_tinc) {
 		rds_inc_put(&tc->t_tinc->ti_inc);
 		tc->t_tinc = NULL;
diff --git a/net/sctp/auth.c b/net/sctp/auth.c
index db6b7373d16c..34964145514e 100644
--- a/net/sctp/auth.c
+++ b/net/sctp/auth.c
@@ -863,12 +863,17 @@ int sctp_auth_set_key(struct sctp_endpoint *ep,
 	}
 
 	list_del_init(&shkey->key_list);
-	sctp_auth_shkey_release(shkey);
 	list_add(&cur_key->key_list, sh_keys);
 
-	if (asoc && asoc->active_key_id == auth_key->sca_keynumber)
-		sctp_auth_asoc_init_active_key(asoc, GFP_KERNEL);
+	if (asoc && asoc->active_key_id == auth_key->sca_keynumber &&
+	    sctp_auth_asoc_init_active_key(asoc, GFP_KERNEL)) {
+		list_del_init(&cur_key->key_list);
+		sctp_auth_shkey_release(cur_key);
+		list_add(&shkey->key_list, sh_keys);
+		return -ENOMEM;
+	}
 
+	sctp_auth_shkey_release(shkey);
 	return 0;
 }
 
@@ -902,8 +907,13 @@ int sctp_auth_set_active_key(struct sctp_endpoint *ep,
 		return -EINVAL;
 
 	if (asoc) {
+		__u16  active_key_id = asoc->active_key_id;
+
 		asoc->active_key_id = key_id;
-		sctp_auth_asoc_init_active_key(asoc, GFP_KERNEL);
+		if (sctp_auth_asoc_init_active_key(asoc, GFP_KERNEL)) {
+			asoc->active_key_id = active_key_id;
+			return -ENOMEM;
+		}
 	} else
 		ep->active_key_id = key_id;
 
diff --git a/net/unix/garbage.c b/net/unix/garbage.c
index d45d5366115a..dc2763540393 100644
--- a/net/unix/garbage.c
+++ b/net/unix/garbage.c
@@ -204,6 +204,7 @@ void wait_for_unix_gc(void)
 /* The external entry point: unix_gc() */
 void unix_gc(void)
 {
+	struct sk_buff *next_skb, *skb;
 	struct unix_sock *u;
 	struct unix_sock *next;
 	struct sk_buff_head hitlist;
@@ -297,11 +298,30 @@ void unix_gc(void)
 
 	spin_unlock(&unix_gc_lock);
 
+	/* We need io_uring to clean its registered files, ignore all io_uring
+	 * originated skbs. It's fine as io_uring doesn't keep references to
+	 * other io_uring instances and so killing all other files in the cycle
+	 * will put all io_uring references forcing it to go through normal
+	 * release.path eventually putting registered files.
+	 */
+	skb_queue_walk_safe(&hitlist, skb, next_skb) {
+		if (skb->scm_io_uring) {
+			__skb_unlink(skb, &hitlist);
+			skb_queue_tail(&skb->sk->sk_receive_queue, skb);
+		}
+	}
+
 	/* Here we are. Hitlist is filled. Die. */
 	__skb_queue_purge(&hitlist);
 
 	spin_lock(&unix_gc_lock);
 
+	/* There could be io_uring registered files, just push them back to
+	 * the inflight list
+	 */
+	list_for_each_entry_safe(u, next, &gc_candidates, link)
+		list_move_tail(&u->link, &gc_inflight_list);
+
 	/* All candidates should have been detached by now. */
 	BUG_ON(!list_empty(&gc_candidates));
 
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index d6d3a05c008a..c9ee9259af48 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -1196,7 +1196,7 @@ EXPORT_SYMBOL_GPL(virtio_transport_recv_pkt);
 
 void virtio_transport_free_pkt(struct virtio_vsock_pkt *pkt)
 {
-	kfree(pkt->buf);
+	kvfree(pkt->buf);
 	kfree(pkt);
 }
 EXPORT_SYMBOL_GPL(virtio_transport_free_pkt);
diff --git a/net/xfrm/xfrm_ipcomp.c b/net/xfrm/xfrm_ipcomp.c
index 0814320472f1..24ac6805275e 100644
--- a/net/xfrm/xfrm_ipcomp.c
+++ b/net/xfrm/xfrm_ipcomp.c
@@ -212,6 +212,7 @@ static void ipcomp_free_scratches(void)
 		vfree(*per_cpu_ptr(scratches, i));
 
 	free_percpu(scratches);
+	ipcomp_scratches = NULL;
 }
 
 static void * __percpu *ipcomp_alloc_scratches(void)
diff --git a/scripts/Kbuild.include b/scripts/Kbuild.include
index 0d6e11820791..25696de8114a 100644
--- a/scripts/Kbuild.include
+++ b/scripts/Kbuild.include
@@ -179,8 +179,29 @@ echo-cmd = $(if $($(quiet)cmd_$(1)),\
  quiet_redirect :=
 silent_redirect := exec >/dev/null;
 
+# Delete the target on interruption
+#
+# GNU Make automatically deletes the target if it has already been changed by
+# the interrupted recipe. So, you can safely stop the build by Ctrl-C (Make
+# will delete incomplete targets), and resume it later.
+#
+# However, this does not work when the stderr is piped to another program, like
+#  $ make >&2 | tee log
+# Make dies with SIGPIPE before cleaning the targets.
+#
+# To address it, we clean the target in signal traps.
+#
+# Make deletes the target when it catches SIGHUP, SIGINT, SIGQUIT, SIGTERM.
+# So, we cover them, and also SIGPIPE just in case.
+#
+# Of course, this is unneeded for phony targets.
+delete-on-interrupt = \
+	$(if $(filter-out $(PHONY), $@), \
+		$(foreach sig, HUP INT QUIT TERM PIPE, \
+			trap 'rm -f $@; trap - $(sig); kill -s $(sig) $$$$' $(sig);))
+
 # printing commands
-cmd = @set -e; $(echo-cmd) $($(quiet)redirect) $(cmd_$(1))
+cmd = @set -e; $(echo-cmd) $($(quiet)redirect) $(delete-on-interrupt) $(cmd_$(1))
 
 ###
 # if_changed      - execute command if any prerequisite is newer than
diff --git a/scripts/package/mkspec b/scripts/package/mkspec
index 7c477ca7dc98..951cc60e5a90 100755
--- a/scripts/package/mkspec
+++ b/scripts/package/mkspec
@@ -85,10 +85,10 @@ $S
 	mkdir -p %{buildroot}/boot
 	%ifarch ia64
 	mkdir -p %{buildroot}/boot/efi
-	cp \$($MAKE image_name) %{buildroot}/boot/efi/vmlinuz-$KERNELRELEASE
+	cp \$($MAKE -s image_name) %{buildroot}/boot/efi/vmlinuz-$KERNELRELEASE
 	ln -s efi/vmlinuz-$KERNELRELEASE %{buildroot}/boot/
 	%else
-	cp \$($MAKE image_name) %{buildroot}/boot/vmlinuz-$KERNELRELEASE
+	cp \$($MAKE -s image_name) %{buildroot}/boot/vmlinuz-$KERNELRELEASE
 	%endif
 $M	$MAKE %{?_smp_mflags} INSTALL_MOD_PATH=%{buildroot} modules_install
 	$MAKE %{?_smp_mflags} INSTALL_HDR_PATH=%{buildroot}/usr headers_install
diff --git a/scripts/selinux/install_policy.sh b/scripts/selinux/install_policy.sh
index 2dccf141241d..20af56ce245c 100755
--- a/scripts/selinux/install_policy.sh
+++ b/scripts/selinux/install_policy.sh
@@ -78,7 +78,7 @@ cd /etc/selinux/dummy/contexts/files
 $SF -F file_contexts /
 
 mounts=`cat /proc/$$/mounts | \
-	egrep "ext[234]|jfs|xfs|reiserfs|jffs2|gfs2|btrfs|f2fs|ocfs2" | \
+	grep -E "ext[234]|jfs|xfs|reiserfs|jffs2|gfs2|btrfs|f2fs|ocfs2" | \
 	awk '{ print $2 '}`
 $SF -F file_contexts $mounts
 
diff --git a/security/Kconfig.hardening b/security/Kconfig.hardening
index 269967c4fc1b..b54eb7177a31 100644
--- a/security/Kconfig.hardening
+++ b/security/Kconfig.hardening
@@ -22,13 +22,23 @@ menu "Memory initialization"
 config CC_HAS_AUTO_VAR_INIT_PATTERN
 	def_bool $(cc-option,-ftrivial-auto-var-init=pattern)
 
-config CC_HAS_AUTO_VAR_INIT_ZERO
+config CC_HAS_AUTO_VAR_INIT_ZERO_BARE
+	def_bool $(cc-option,-ftrivial-auto-var-init=zero)
+
+config CC_HAS_AUTO_VAR_INIT_ZERO_ENABLER
+	# Clang 16 and later warn about using the -enable flag, but it
+	# is required before then.
 	def_bool $(cc-option,-ftrivial-auto-var-init=zero -enable-trivial-auto-var-init-zero-knowing-it-will-be-removed-from-clang)
+	depends on !CC_HAS_AUTO_VAR_INIT_ZERO_BARE
+
+config CC_HAS_AUTO_VAR_INIT_ZERO
+	def_bool CC_HAS_AUTO_VAR_INIT_ZERO_BARE || CC_HAS_AUTO_VAR_INIT_ZERO_ENABLER
 
 choice
 	prompt "Initialize kernel stack variables at function entry"
 	default GCC_PLUGIN_STRUCTLEAK_BYREF_ALL if COMPILE_TEST && GCC_PLUGINS
 	default INIT_STACK_ALL_PATTERN if COMPILE_TEST && CC_HAS_AUTO_VAR_INIT_PATTERN
+	default INIT_STACK_ALL_ZERO if CC_HAS_AUTO_VAR_INIT_ZERO
 	default INIT_STACK_NONE
 	help
 	  This option enables initialization of stack variables at
@@ -39,11 +49,11 @@ choice
 	  syscalls.
 
 	  This chooses the level of coverage over classes of potentially
-	  uninitialized variables. The selected class will be
+	  uninitialized variables. The selected class of variable will be
 	  initialized before use in a function.
 
 	config INIT_STACK_NONE
-		bool "no automatic initialization (weakest)"
+		bool "no automatic stack variable initialization (weakest)"
 		help
 		  Disable automatic stack variable initialization.
 		  This leaves the kernel vulnerable to the standard
@@ -80,7 +90,7 @@ choice
 		  and is disallowed.
 
 	config GCC_PLUGIN_STRUCTLEAK_BYREF_ALL
-		bool "zero-init anything passed by reference (very strong)"
+		bool "zero-init everything passed by reference (very strong)"
 		depends on GCC_PLUGINS
 		depends on !(KASAN && KASAN_STACK=1)
 		select GCC_PLUGIN_STRUCTLEAK
@@ -91,33 +101,44 @@ choice
 		  of uninitialized stack variable exploits and information
 		  exposures.
 
+		  As a side-effect, this keeps a lot of variables on the
+		  stack that can otherwise be optimized out, so combining
+		  this with CONFIG_KASAN_STACK can lead to a stack overflow
+		  and is disallowed.
+
 	config INIT_STACK_ALL_PATTERN
-		bool "0xAA-init everything on the stack (strongest)"
+		bool "pattern-init everything (strongest)"
 		depends on CC_HAS_AUTO_VAR_INIT_PATTERN
 		help
-		  Initializes everything on the stack with a 0xAA
-		  pattern. This is intended to eliminate all classes
-		  of uninitialized stack variable exploits and information
-		  exposures, even variables that were warned to have been
-		  left uninitialized.
+		  Initializes everything on the stack (including padding)
+		  with a specific debug value. This is intended to eliminate
+		  all classes of uninitialized stack variable exploits and
+		  information exposures, even variables that were warned about
+		  having been left uninitialized.
 
 		  Pattern initialization is known to provoke many existing bugs
 		  related to uninitialized locals, e.g. pointers receive
-		  non-NULL values, buffer sizes and indices are very big.
+		  non-NULL values, buffer sizes and indices are very big. The
+		  pattern is situation-specific; Clang on 64-bit uses 0xAA
+		  repeating for all types and padding except float and double
+		  which use 0xFF repeating (-NaN). Clang on 32-bit uses 0xFF
+		  repeating for all types and padding.
 
 	config INIT_STACK_ALL_ZERO
-		bool "zero-init everything on the stack (strongest and safest)"
+		bool "zero-init everything (strongest and safest)"
 		depends on CC_HAS_AUTO_VAR_INIT_ZERO
 		help
-		  Initializes everything on the stack with a zero
-		  value. This is intended to eliminate all classes
-		  of uninitialized stack variable exploits and information
-		  exposures, even variables that were warned to have been
-		  left uninitialized.
-
-		  Zero initialization provides safe defaults for strings,
-		  pointers, indices and sizes, and is therefore
-		  more suitable as a security mitigation measure.
+		  Initializes everything on the stack (including padding)
+		  with a zero value. This is intended to eliminate all
+		  classes of uninitialized stack variable exploits and
+		  information exposures, even variables that were warned
+		  about having been left uninitialized.
+
+		  Zero initialization provides safe defaults for strings
+		  (immediately NUL-terminated), pointers (NULL), indices
+		  (index 0), and sizes (0 length), so it is therefore more
+		  suitable as a production security mitigation than pattern
+		  initialization.
 
 endchoice
 
diff --git a/sound/core/pcm_dmaengine.c b/sound/core/pcm_dmaengine.c
index 4d0e8fe535a1..be58505889a3 100644
--- a/sound/core/pcm_dmaengine.c
+++ b/sound/core/pcm_dmaengine.c
@@ -130,12 +130,14 @@ EXPORT_SYMBOL_GPL(snd_dmaengine_pcm_set_config_from_dai_data);
 
 static void dmaengine_pcm_dma_complete(void *arg)
 {
+	unsigned int new_pos;
 	struct snd_pcm_substream *substream = arg;
 	struct dmaengine_pcm_runtime_data *prtd = substream_to_prtd(substream);
 
-	prtd->pos += snd_pcm_lib_period_bytes(substream);
-	if (prtd->pos >= snd_pcm_lib_buffer_bytes(substream))
-		prtd->pos = 0;
+	new_pos = prtd->pos + snd_pcm_lib_period_bytes(substream);
+	if (new_pos >= snd_pcm_lib_buffer_bytes(substream))
+		new_pos = 0;
+	prtd->pos = new_pos;
 
 	snd_pcm_period_elapsed(substream);
 }
diff --git a/sound/core/rawmidi.c b/sound/core/rawmidi.c
index 257ad5206240..0d91143eb464 100644
--- a/sound/core/rawmidi.c
+++ b/sound/core/rawmidi.c
@@ -1736,10 +1736,8 @@ static int snd_rawmidi_free(struct snd_rawmidi *rmidi)
 
 	snd_info_free_entry(rmidi->proc_entry);
 	rmidi->proc_entry = NULL;
-	mutex_lock(&register_mutex);
 	if (rmidi->ops && rmidi->ops->dev_unregister)
 		rmidi->ops->dev_unregister(rmidi);
-	mutex_unlock(&register_mutex);
 
 	snd_rawmidi_free_substreams(&rmidi->streams[SNDRV_RAWMIDI_STREAM_INPUT]);
 	snd_rawmidi_free_substreams(&rmidi->streams[SNDRV_RAWMIDI_STREAM_OUTPUT]);
diff --git a/sound/core/sound_oss.c b/sound/core/sound_oss.c
index 610f317bea9d..99874e80b682 100644
--- a/sound/core/sound_oss.c
+++ b/sound/core/sound_oss.c
@@ -162,7 +162,6 @@ int snd_unregister_oss_device(int type, struct snd_card *card, int dev)
 		mutex_unlock(&sound_oss_mutex);
 		return -ENOENT;
 	}
-	unregister_sound_special(minor);
 	switch (SNDRV_MINOR_OSS_DEVICE(minor)) {
 	case SNDRV_MINOR_OSS_PCM:
 		track2 = SNDRV_MINOR_OSS(cidx, SNDRV_MINOR_OSS_AUDIO);
@@ -174,12 +173,18 @@ int snd_unregister_oss_device(int type, struct snd_card *card, int dev)
 		track2 = SNDRV_MINOR_OSS(cidx, SNDRV_MINOR_OSS_DMMIDI1);
 		break;
 	}
-	if (track2 >= 0) {
-		unregister_sound_special(track2);
+	if (track2 >= 0)
 		snd_oss_minors[track2] = NULL;
-	}
 	snd_oss_minors[minor] = NULL;
 	mutex_unlock(&sound_oss_mutex);
+
+	/* call unregister_sound_special() outside sound_oss_mutex;
+	 * otherwise may deadlock, as it can trigger the release of a card
+	 */
+	unregister_sound_special(minor);
+	if (track2 >= 0)
+		unregister_sound_special(track2);
+
 	kfree(mptr);
 	return 0;
 }
diff --git a/sound/pci/hda/hda_beep.c b/sound/pci/hda/hda_beep.c
index 53a2b89f8983..e63621bcb214 100644
--- a/sound/pci/hda/hda_beep.c
+++ b/sound/pci/hda/hda_beep.c
@@ -118,6 +118,12 @@ static int snd_hda_beep_event(struct input_dev *dev, unsigned int type,
 	return 0;
 }
 
+static void turn_on_beep(struct hda_beep *beep)
+{
+	if (beep->keep_power_at_enable)
+		snd_hda_power_up_pm(beep->codec);
+}
+
 static void turn_off_beep(struct hda_beep *beep)
 {
 	cancel_work_sync(&beep->beep_work);
@@ -125,6 +131,8 @@ static void turn_off_beep(struct hda_beep *beep)
 		/* turn off beep */
 		generate_tone(beep, 0);
 	}
+	if (beep->keep_power_at_enable)
+		snd_hda_power_down_pm(beep->codec);
 }
 
 /**
@@ -140,7 +148,9 @@ int snd_hda_enable_beep_device(struct hda_codec *codec, int enable)
 	enable = !!enable;
 	if (beep->enabled != enable) {
 		beep->enabled = enable;
-		if (!enable)
+		if (enable)
+			turn_on_beep(beep);
+		else
 			turn_off_beep(beep);
 		return 1;
 	}
@@ -167,7 +177,8 @@ static int beep_dev_disconnect(struct snd_device *device)
 		input_unregister_device(beep->dev);
 	else
 		input_free_device(beep->dev);
-	turn_off_beep(beep);
+	if (beep->enabled)
+		turn_off_beep(beep);
 	return 0;
 }
 
diff --git a/sound/pci/hda/hda_beep.h b/sound/pci/hda/hda_beep.h
index a25358a4807a..db76e3ddba65 100644
--- a/sound/pci/hda/hda_beep.h
+++ b/sound/pci/hda/hda_beep.h
@@ -25,6 +25,7 @@ struct hda_beep {
 	unsigned int enabled:1;
 	unsigned int linear_tone:1;	/* linear tone for IDT/STAC codec */
 	unsigned int playing:1;
+	unsigned int keep_power_at_enable:1;	/* set by driver */
 	struct work_struct beep_work; /* scheduled task for beep event */
 	struct mutex mutex;
 	void (*power_hook)(struct hda_beep *beep, bool on);
diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index c3fcf478037f..b1c57c65f6cd 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -2684,9 +2684,6 @@ static void generic_acomp_pin_eld_notify(void *audio_ptr, int port, int dev_id)
 	 */
 	if (codec->core.dev.power.power_state.event == PM_EVENT_SUSPEND)
 		return;
-	/* ditto during suspend/resume process itself */
-	if (snd_hdac_is_in_pm(&codec->core))
-		return;
 
 	check_presence_and_report(codec, pin_nid, dev_id);
 }
@@ -2870,9 +2867,6 @@ static void intel_pin_eld_notify(void *audio_ptr, int port, int pipe)
 	 */
 	if (codec->core.dev.power.power_state.event == PM_EVENT_SUSPEND)
 		return;
-	/* ditto during suspend/resume process itself */
-	if (snd_hdac_is_in_pm(&codec->core))
-		return;
 
 	snd_hdac_i915_set_bclk(&codec->bus->core);
 	check_presence_and_report(codec, pin_nid, dev_id);
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 574fe798d512..60e3bc124836 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8164,11 +8164,13 @@ static const struct hda_fixup alc269_fixups[] = {
 	[ALC285_FIXUP_ASUS_G533Z_PINS] = {
 		.type = HDA_FIXUP_PINS,
 		.v.pins = (const struct hda_pintbl[]) {
-			{ 0x14, 0x90170120 },
+			{ 0x14, 0x90170152 }, /* Speaker Surround Playback Switch */
+			{ 0x19, 0x03a19020 }, /* Mic Boost Volume */
+			{ 0x1a, 0x03a11c30 }, /* Mic Boost Volume */
+			{ 0x1e, 0x90170151 }, /* Rear jack, IN OUT EAPD Detect */
+			{ 0x21, 0x03211420 },
 			{ }
 		},
-		.chained = true,
-		.chain_id = ALC294_FIXUP_ASUS_G513_PINS,
 	},
 	[ALC294_FIXUP_ASUS_COEF_1B] = {
 		.type = HDA_FIXUP_VERBS,
@@ -8774,7 +8776,6 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1028, 0x0871, "Dell Precision 3630", ALC255_FIXUP_DELL_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1028, 0x0872, "Dell Precision 3630", ALC255_FIXUP_DELL_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1028, 0x0873, "Dell Precision 3930", ALC255_FIXUP_DUMMY_LINEOUT_VERB),
-	SND_PCI_QUIRK(0x1028, 0x087d, "Dell Precision 5530", ALC289_FIXUP_DUAL_SPK),
 	SND_PCI_QUIRK(0x1028, 0x08ad, "Dell WYSE AIO", ALC225_FIXUP_DELL_WYSE_AIO_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x08ae, "Dell WYSE NB", ALC225_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x0935, "Dell", ALC274_FIXUP_DELL_AIO_LINEOUT_VERB),
@@ -8963,6 +8964,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x1e8e, "ASUS Zephyrus G15", ALC289_FIXUP_ASUS_GA401),
 	SND_PCI_QUIRK(0x1043, 0x1c52, "ASUS Zephyrus G15 2022", ALC289_FIXUP_ASUS_GA401),
 	SND_PCI_QUIRK(0x1043, 0x1f11, "ASUS Zephyrus G14", ALC289_FIXUP_ASUS_GA401),
+	SND_PCI_QUIRK(0x1043, 0x1f92, "ASUS ROG Flow X16", ALC289_FIXUP_ASUS_GA401),
 	SND_PCI_QUIRK(0x1043, 0x3030, "ASUS ZN270IE", ALC256_FIXUP_ASUS_AIO_GPIO2),
 	SND_PCI_QUIRK(0x1043, 0x831a, "ASUS P901", ALC269_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK(0x1043, 0x834a, "ASUS S101", ALC269_FIXUP_STEREO_DMIC),
@@ -8984,6 +8986,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x10ec, 0x10f2, "Intel Reference board", ALC700_FIXUP_INTEL_REFERENCE),
 	SND_PCI_QUIRK(0x10ec, 0x118c, "Medion EE4254 MD62100", ALC256_FIXUP_MEDION_HEADSET_NO_PRESENCE),
 	SND_PCI_QUIRK(0x10ec, 0x1230, "Intel Reference board", ALC295_FIXUP_CHROME_BOOK),
+	SND_PCI_QUIRK(0x10ec, 0x124c, "Intel Reference board", ALC295_FIXUP_CHROME_BOOK),
 	SND_PCI_QUIRK(0x10ec, 0x1252, "Intel Reference board", ALC295_FIXUP_CHROME_BOOK),
 	SND_PCI_QUIRK(0x10ec, 0x1254, "Intel Reference board", ALC295_FIXUP_CHROME_BOOK),
 	SND_PCI_QUIRK(0x10f7, 0x8338, "Panasonic CF-SZ6", ALC269_FIXUP_HEADSET_MODE),
diff --git a/sound/pci/hda/patch_sigmatel.c b/sound/pci/hda/patch_sigmatel.c
index b848e435b93f..6fc0c4e77cd1 100644
--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -4308,6 +4308,8 @@ static int stac_parse_auto_config(struct hda_codec *codec)
 		if (codec->beep) {
 			/* IDT/STAC codecs have linear beep tone parameter */
 			codec->beep->linear_tone = spec->linear_tone_beep;
+			/* keep power up while beep is enabled */
+			codec->beep->keep_power_at_enable = 1;
 			/* if no beep switch is available, make its own one */
 			caps = query_amp_caps(codec, nid, HDA_OUTPUT);
 			if (!(caps & AC_AMPCAP_MUTE)) {
@@ -4448,28 +4450,6 @@ static int stac_suspend(struct hda_codec *codec)
 	stac_shutup(codec);
 	return 0;
 }
-
-static int stac_check_power_status(struct hda_codec *codec, hda_nid_t nid)
-{
-#ifdef CONFIG_SND_HDA_INPUT_BEEP
-	struct sigmatel_spec *spec = codec->spec;
-#endif
-	int ret = snd_hda_gen_check_power_status(codec, nid);
-
-#ifdef CONFIG_SND_HDA_INPUT_BEEP
-	if (nid == spec->gen.beep_nid && codec->beep) {
-		if (codec->beep->enabled != spec->beep_power_on) {
-			spec->beep_power_on = codec->beep->enabled;
-			if (spec->beep_power_on)
-				snd_hda_power_up_pm(codec);
-			else
-				snd_hda_power_down_pm(codec);
-		}
-		ret |= spec->beep_power_on;
-	}
-#endif
-	return ret;
-}
 #else
 #define stac_suspend		NULL
 #endif /* CONFIG_PM */
@@ -4482,7 +4462,6 @@ static const struct hda_codec_ops stac_patch_ops = {
 	.unsol_event = snd_hda_jack_unsol_event,
 #ifdef CONFIG_PM
 	.suspend = stac_suspend,
-	.check_power_status = stac_check_power_status,
 #endif
 	.reboot_notify = stac_shutup,
 };
diff --git a/sound/soc/codecs/da7219.c b/sound/soc/codecs/da7219.c
index 5f8c96dea094..f9e58d6509a8 100644
--- a/sound/soc/codecs/da7219.c
+++ b/sound/soc/codecs/da7219.c
@@ -2194,6 +2194,7 @@ static int da7219_register_dai_clks(struct snd_soc_component *component)
 			dai_clk_lookup = clkdev_hw_create(dai_clk_hw, init.name,
 							  "%s", dev_name(dev));
 			if (!dai_clk_lookup) {
+				clk_hw_unregister(dai_clk_hw);
 				ret = -ENOMEM;
 				goto err;
 			} else {
@@ -2215,12 +2216,12 @@ static int da7219_register_dai_clks(struct snd_soc_component *component)
 	return 0;
 
 err:
-	do {
+	while (--i >= 0) {
 		if (da7219->dai_clks_lookup[i])
 			clkdev_drop(da7219->dai_clks_lookup[i]);
 
 		clk_hw_unregister(&da7219->dai_clks_hw[i]);
-	} while (i-- > 0);
+	}
 
 	if (np)
 		kfree(da7219->clk_hw_data);
diff --git a/sound/soc/codecs/mt6660.c b/sound/soc/codecs/mt6660.c
index d1797003c83d..e18a58868273 100644
--- a/sound/soc/codecs/mt6660.c
+++ b/sound/soc/codecs/mt6660.c
@@ -504,13 +504,17 @@ static int mt6660_i2c_probe(struct i2c_client *client,
 		dev_err(chip->dev, "read chip revision fail\n");
 		goto probe_fail;
 	}
-	pm_runtime_set_active(chip->dev);
-	pm_runtime_enable(chip->dev);
 
 	ret = devm_snd_soc_register_component(chip->dev,
 					       &mt6660_component_driver,
 					       &mt6660_codec_dai, 1);
+	if (!ret) {
+		pm_runtime_set_active(chip->dev);
+		pm_runtime_enable(chip->dev);
+	}
+
 	return ret;
+
 probe_fail:
 	_mt6660_chip_power_on(chip, 0);
 	mutex_destroy(&chip->io_lock);
diff --git a/sound/soc/codecs/tas2764.c b/sound/soc/codecs/tas2764.c
index 37588804a6b5..8b262e7f5275 100644
--- a/sound/soc/codecs/tas2764.c
+++ b/sound/soc/codecs/tas2764.c
@@ -34,6 +34,9 @@ struct tas2764_priv {
 	
 	int v_sense_slot;
 	int i_sense_slot;
+
+	bool dac_powered;
+	bool unmuted;
 };
 
 static void tas2764_reset(struct tas2764_priv *tas2764)
@@ -50,34 +53,22 @@ static void tas2764_reset(struct tas2764_priv *tas2764)
 	usleep_range(1000, 2000);
 }
 
-static int tas2764_set_bias_level(struct snd_soc_component *component,
-				 enum snd_soc_bias_level level)
+static int tas2764_update_pwr_ctrl(struct tas2764_priv *tas2764)
 {
-	struct tas2764_priv *tas2764 = snd_soc_component_get_drvdata(component);
+	struct snd_soc_component *component = tas2764->component;
+	unsigned int val;
+	int ret;
 
-	switch (level) {
-	case SND_SOC_BIAS_ON:
-		snd_soc_component_update_bits(component, TAS2764_PWR_CTRL,
-					      TAS2764_PWR_CTRL_MASK,
-					      TAS2764_PWR_CTRL_ACTIVE);
-		break;
-	case SND_SOC_BIAS_STANDBY:
-	case SND_SOC_BIAS_PREPARE:
-		snd_soc_component_update_bits(component, TAS2764_PWR_CTRL,
-					      TAS2764_PWR_CTRL_MASK,
-					      TAS2764_PWR_CTRL_MUTE);
-		break;
-	case SND_SOC_BIAS_OFF:
-		snd_soc_component_update_bits(component, TAS2764_PWR_CTRL,
-					      TAS2764_PWR_CTRL_MASK,
-					      TAS2764_PWR_CTRL_SHUTDOWN);
-		break;
+	if (tas2764->dac_powered)
+		val = tas2764->unmuted ?
+			TAS2764_PWR_CTRL_ACTIVE : TAS2764_PWR_CTRL_MUTE;
+	else
+		val = TAS2764_PWR_CTRL_SHUTDOWN;
 
-	default:
-		dev_err(tas2764->dev,
-				"wrong power level setting %d\n", level);
-		return -EINVAL;
-	}
+	ret = snd_soc_component_update_bits(component, TAS2764_PWR_CTRL,
+					    TAS2764_PWR_CTRL_MASK, val);
+	if (ret < 0)
+		return ret;
 
 	return 0;
 }
@@ -114,9 +105,7 @@ static int tas2764_codec_resume(struct snd_soc_component *component)
 		usleep_range(1000, 2000);
 	}
 
-	ret = snd_soc_component_update_bits(component, TAS2764_PWR_CTRL,
-					    TAS2764_PWR_CTRL_MASK,
-					    TAS2764_PWR_CTRL_ACTIVE);
+	ret = tas2764_update_pwr_ctrl(tas2764);
 
 	if (ret < 0)
 		return ret;
@@ -150,14 +139,12 @@ static int tas2764_dac_event(struct snd_soc_dapm_widget *w,
 
 	switch (event) {
 	case SND_SOC_DAPM_POST_PMU:
-		ret = snd_soc_component_update_bits(component, TAS2764_PWR_CTRL,
-						    TAS2764_PWR_CTRL_MASK,
-						    TAS2764_PWR_CTRL_MUTE);
+		tas2764->dac_powered = true;
+		ret = tas2764_update_pwr_ctrl(tas2764);
 		break;
 	case SND_SOC_DAPM_PRE_PMD:
-		ret = snd_soc_component_update_bits(component, TAS2764_PWR_CTRL,
-						    TAS2764_PWR_CTRL_MASK,
-						    TAS2764_PWR_CTRL_SHUTDOWN);
+		tas2764->dac_powered = false;
+		ret = tas2764_update_pwr_ctrl(tas2764);
 		break;
 	default:
 		dev_err(tas2764->dev, "Unsupported event\n");
@@ -202,17 +189,11 @@ static const struct snd_soc_dapm_route tas2764_audio_map[] = {
 
 static int tas2764_mute(struct snd_soc_dai *dai, int mute, int direction)
 {
-	struct snd_soc_component *component = dai->component;
-	int ret;
-
-	ret = snd_soc_component_update_bits(component, TAS2764_PWR_CTRL,
-					    TAS2764_PWR_CTRL_MASK,
-					    mute ? TAS2764_PWR_CTRL_MUTE : 0);
+	struct tas2764_priv *tas2764 =
+			snd_soc_component_get_drvdata(dai->component);
 
-	if (ret < 0)
-		return ret;
-
-	return 0;
+	tas2764->unmuted = !mute;
+	return tas2764_update_pwr_ctrl(tas2764);
 }
 
 static int tas2764_set_bitwidth(struct tas2764_priv *tas2764, int bitwidth)
@@ -485,7 +466,7 @@ static struct snd_soc_dai_driver tas2764_dai_driver[] = {
 		.id = 0,
 		.playback = {
 			.stream_name    = "ASI1 Playback",
-			.channels_min   = 2,
+			.channels_min   = 1,
 			.channels_max   = 2,
 			.rates      = TAS2764_RATES,
 			.formats    = TAS2764_FORMATS,
@@ -526,12 +507,6 @@ static int tas2764_codec_probe(struct snd_soc_component *component)
 	if (ret < 0)
 		return ret;
 
-	ret = snd_soc_component_update_bits(component, TAS2764_PWR_CTRL,
-					    TAS2764_PWR_CTRL_MASK,
-					    TAS2764_PWR_CTRL_MUTE);
-	if (ret < 0)
-		return ret;
-
 	return 0;
 }
 
@@ -549,7 +524,6 @@ static const struct snd_soc_component_driver soc_component_driver_tas2764 = {
 	.probe			= tas2764_codec_probe,
 	.suspend		= tas2764_codec_suspend,
 	.resume			= tas2764_codec_resume,
-	.set_bias_level		= tas2764_set_bias_level,
 	.controls		= tas2764_snd_controls,
 	.num_controls		= ARRAY_SIZE(tas2764_snd_controls),
 	.dapm_widgets		= tas2764_dapm_widgets,
diff --git a/sound/soc/codecs/wcd9335.c b/sound/soc/codecs/wcd9335.c
index 8f4ed39c49de..33c29a1f52d0 100644
--- a/sound/soc/codecs/wcd9335.c
+++ b/sound/soc/codecs/wcd9335.c
@@ -1971,8 +1971,8 @@ static int wcd9335_trigger(struct snd_pcm_substream *substream, int cmd,
 	case SNDRV_PCM_TRIGGER_STOP:
 	case SNDRV_PCM_TRIGGER_SUSPEND:
 	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
-		slim_stream_unprepare(dai_data->sruntime);
 		slim_stream_disable(dai_data->sruntime);
+		slim_stream_unprepare(dai_data->sruntime);
 		break;
 	default:
 		break;
diff --git a/sound/soc/codecs/wcd934x.c b/sound/soc/codecs/wcd934x.c
index fd704df9b175..104751ac6cd1 100644
--- a/sound/soc/codecs/wcd934x.c
+++ b/sound/soc/codecs/wcd934x.c
@@ -1829,8 +1829,8 @@ static int wcd934x_trigger(struct snd_pcm_substream *substream, int cmd,
 	case SNDRV_PCM_TRIGGER_STOP:
 	case SNDRV_PCM_TRIGGER_SUSPEND:
 	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
-		slim_stream_unprepare(dai_data->sruntime);
 		slim_stream_disable(dai_data->sruntime);
+		slim_stream_unprepare(dai_data->sruntime);
 		break;
 	default:
 		break;
diff --git a/sound/soc/codecs/wm5102.c b/sound/soc/codecs/wm5102.c
index 2ed3fa67027d..b7f5e5391fdb 100644
--- a/sound/soc/codecs/wm5102.c
+++ b/sound/soc/codecs/wm5102.c
@@ -2083,9 +2083,6 @@ static int wm5102_probe(struct platform_device *pdev)
 		regmap_update_bits(arizona->regmap, wm5102_digital_vu[i],
 				   WM5102_DIG_VU, WM5102_DIG_VU);
 
-	pm_runtime_enable(&pdev->dev);
-	pm_runtime_idle(&pdev->dev);
-
 	ret = arizona_request_irq(arizona, ARIZONA_IRQ_DSP_IRQ1,
 				  "ADSP2 Compressed IRQ", wm5102_adsp2_irq,
 				  wm5102);
@@ -2118,6 +2115,9 @@ static int wm5102_probe(struct platform_device *pdev)
 		goto err_spk_irqs;
 	}
 
+	pm_runtime_enable(&pdev->dev);
+	pm_runtime_idle(&pdev->dev);
+
 	return ret;
 
 err_spk_irqs:
diff --git a/sound/soc/codecs/wm5110.c b/sound/soc/codecs/wm5110.c
index d0cef982215d..c158f8b1e8e4 100644
--- a/sound/soc/codecs/wm5110.c
+++ b/sound/soc/codecs/wm5110.c
@@ -2452,9 +2452,6 @@ static int wm5110_probe(struct platform_device *pdev)
 		regmap_update_bits(arizona->regmap, wm5110_digital_vu[i],
 				   WM5110_DIG_VU, WM5110_DIG_VU);
 
-	pm_runtime_enable(&pdev->dev);
-	pm_runtime_idle(&pdev->dev);
-
 	ret = arizona_request_irq(arizona, ARIZONA_IRQ_DSP_IRQ1,
 				  "ADSP2 Compressed IRQ", wm5110_adsp2_irq,
 				  wm5110);
@@ -2487,6 +2484,9 @@ static int wm5110_probe(struct platform_device *pdev)
 		goto err_spk_irqs;
 	}
 
+	pm_runtime_enable(&pdev->dev);
+	pm_runtime_idle(&pdev->dev);
+
 	return ret;
 
 err_spk_irqs:
diff --git a/sound/soc/codecs/wm8997.c b/sound/soc/codecs/wm8997.c
index 229f2986cd96..07378714b013 100644
--- a/sound/soc/codecs/wm8997.c
+++ b/sound/soc/codecs/wm8997.c
@@ -1156,9 +1156,6 @@ static int wm8997_probe(struct platform_device *pdev)
 		regmap_update_bits(arizona->regmap, wm8997_digital_vu[i],
 				   WM8997_DIG_VU, WM8997_DIG_VU);
 
-	pm_runtime_enable(&pdev->dev);
-	pm_runtime_idle(&pdev->dev);
-
 	arizona_init_common(arizona);
 
 	ret = arizona_init_vol_limit(arizona);
@@ -1177,6 +1174,9 @@ static int wm8997_probe(struct platform_device *pdev)
 		goto err_spk_irqs;
 	}
 
+	pm_runtime_enable(&pdev->dev);
+	pm_runtime_idle(&pdev->dev);
+
 	return ret;
 
 err_spk_irqs:
diff --git a/sound/soc/fsl/eukrea-tlv320.c b/sound/soc/fsl/eukrea-tlv320.c
index e13271ea84de..29cf9234984d 100644
--- a/sound/soc/fsl/eukrea-tlv320.c
+++ b/sound/soc/fsl/eukrea-tlv320.c
@@ -86,7 +86,7 @@ static int eukrea_tlv320_probe(struct platform_device *pdev)
 	int ret;
 	int int_port = 0, ext_port;
 	struct device_node *np = pdev->dev.of_node;
-	struct device_node *ssi_np = NULL, *codec_np = NULL;
+	struct device_node *ssi_np = NULL, *codec_np = NULL, *tmp_np = NULL;
 
 	eukrea_tlv320.dev = &pdev->dev;
 	if (np) {
@@ -143,7 +143,7 @@ static int eukrea_tlv320_probe(struct platform_device *pdev)
 	}
 
 	if (machine_is_eukrea_cpuimx27() ||
-	    of_find_compatible_node(NULL, NULL, "fsl,imx21-audmux")) {
+	    (tmp_np = of_find_compatible_node(NULL, NULL, "fsl,imx21-audmux"))) {
 		imx_audmux_v1_configure_port(MX27_AUDMUX_HPCR1_SSI0,
 			IMX_AUDMUX_V1_PCR_SYN |
 			IMX_AUDMUX_V1_PCR_TFSDIR |
@@ -158,10 +158,11 @@ static int eukrea_tlv320_probe(struct platform_device *pdev)
 			IMX_AUDMUX_V1_PCR_SYN |
 			IMX_AUDMUX_V1_PCR_RXDSEL(MX27_AUDMUX_HPCR1_SSI0)
 		);
+		of_node_put(tmp_np);
 	} else if (machine_is_eukrea_cpuimx25sd() ||
 		   machine_is_eukrea_cpuimx35sd() ||
 		   machine_is_eukrea_cpuimx51sd() ||
-		   of_find_compatible_node(NULL, NULL, "fsl,imx31-audmux")) {
+		   (tmp_np = of_find_compatible_node(NULL, NULL, "fsl,imx31-audmux"))) {
 		if (!np)
 			ext_port = machine_is_eukrea_cpuimx25sd() ?
 				4 : 3;
@@ -178,6 +179,7 @@ static int eukrea_tlv320_probe(struct platform_device *pdev)
 			IMX_AUDMUX_V2_PTCR_SYN,
 			IMX_AUDMUX_V2_PDCR_RXDSEL(int_port)
 		);
+		of_node_put(tmp_np);
 	} else {
 		if (np) {
 			/* The eukrea,asoc-tlv320 driver was explicitly
diff --git a/sound/soc/sh/rcar/ctu.c b/sound/soc/sh/rcar/ctu.c
index 7647b3d4c0ba..25a8cfc27433 100644
--- a/sound/soc/sh/rcar/ctu.c
+++ b/sound/soc/sh/rcar/ctu.c
@@ -171,7 +171,11 @@ static int rsnd_ctu_init(struct rsnd_mod *mod,
 			 struct rsnd_dai_stream *io,
 			 struct rsnd_priv *priv)
 {
-	rsnd_mod_power_on(mod);
+	int ret;
+
+	ret = rsnd_mod_power_on(mod);
+	if (ret < 0)
+		return ret;
 
 	rsnd_ctu_activation(mod);
 
diff --git a/sound/soc/sh/rcar/dvc.c b/sound/soc/sh/rcar/dvc.c
index 8d91c0eb0880..53b2ad01222b 100644
--- a/sound/soc/sh/rcar/dvc.c
+++ b/sound/soc/sh/rcar/dvc.c
@@ -186,7 +186,11 @@ static int rsnd_dvc_init(struct rsnd_mod *mod,
 			 struct rsnd_dai_stream *io,
 			 struct rsnd_priv *priv)
 {
-	rsnd_mod_power_on(mod);
+	int ret;
+
+	ret = rsnd_mod_power_on(mod);
+	if (ret < 0)
+		return ret;
 
 	rsnd_dvc_activation(mod);
 
diff --git a/sound/soc/sh/rcar/mix.c b/sound/soc/sh/rcar/mix.c
index a3e0370f5704..c6fe2595c373 100644
--- a/sound/soc/sh/rcar/mix.c
+++ b/sound/soc/sh/rcar/mix.c
@@ -146,7 +146,11 @@ static int rsnd_mix_init(struct rsnd_mod *mod,
 			 struct rsnd_dai_stream *io,
 			 struct rsnd_priv *priv)
 {
-	rsnd_mod_power_on(mod);
+	int ret;
+
+	ret = rsnd_mod_power_on(mod);
+	if (ret < 0)
+		return ret;
 
 	rsnd_mix_activation(mod);
 
diff --git a/sound/soc/sh/rcar/src.c b/sound/soc/sh/rcar/src.c
index 585ffba0244b..fd52e26a3808 100644
--- a/sound/soc/sh/rcar/src.c
+++ b/sound/soc/sh/rcar/src.c
@@ -454,11 +454,14 @@ static int rsnd_src_init(struct rsnd_mod *mod,
 			 struct rsnd_priv *priv)
 {
 	struct rsnd_src *src = rsnd_mod_to_src(mod);
+	int ret;
 
 	/* reset sync convert_rate */
 	src->sync.val = 0;
 
-	rsnd_mod_power_on(mod);
+	ret = rsnd_mod_power_on(mod);
+	if (ret < 0)
+		return ret;
 
 	rsnd_src_activation(mod);
 
diff --git a/sound/soc/sh/rcar/ssi.c b/sound/soc/sh/rcar/ssi.c
index 042207c11651..2ead44779d46 100644
--- a/sound/soc/sh/rcar/ssi.c
+++ b/sound/soc/sh/rcar/ssi.c
@@ -518,7 +518,9 @@ static int rsnd_ssi_init(struct rsnd_mod *mod,
 
 	ssi->usrcnt++;
 
-	rsnd_mod_power_on(mod);
+	ret = rsnd_mod_power_on(mod);
+	if (ret < 0)
+		return ret;
 
 	rsnd_ssi_config_init(mod, io);
 
diff --git a/sound/soc/sof/sof-pci-dev.c b/sound/soc/sof/sof-pci-dev.c
index 75657a25dbc0..fe9feaab6a0a 100644
--- a/sound/soc/sof/sof-pci-dev.c
+++ b/sound/soc/sof/sof-pci-dev.c
@@ -75,7 +75,7 @@ static const struct dmi_system_id community_key_platforms[] = {
 	{
 		.ident = "Google Chromebooks",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Google"),
+			DMI_MATCH(DMI_PRODUCT_FAMILY, "Google"),
 		}
 	},
 	{},
diff --git a/sound/usb/endpoint.c b/sound/usb/endpoint.c
index 8527267725bb..80dcac5abe0c 100644
--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -73,12 +73,13 @@ static inline unsigned get_usb_high_speed_rate(unsigned int rate)
  */
 static void release_urb_ctx(struct snd_urb_ctx *u)
 {
-	if (u->buffer_size)
+	if (u->urb && u->buffer_size)
 		usb_free_coherent(u->ep->chip->dev, u->buffer_size,
 				  u->urb->transfer_buffer,
 				  u->urb->transfer_dma);
 	usb_free_urb(u->urb);
 	u->urb = NULL;
+	u->buffer_size = 0;
 }
 
 static const char *usb_error_string(int err)
@@ -998,6 +999,7 @@ static int sync_ep_set_params(struct snd_usb_endpoint *ep)
 	if (!ep->syncbuf)
 		return -ENOMEM;
 
+	ep->nurbs = SYNC_URBS;
 	for (i = 0; i < SYNC_URBS; i++) {
 		struct snd_urb_ctx *u = &ep->urb[i];
 		u->index = i;
@@ -1017,8 +1019,6 @@ static int sync_ep_set_params(struct snd_usb_endpoint *ep)
 		u->urb->complete = snd_complete_urb;
 	}
 
-	ep->nurbs = SYNC_URBS;
-
 	return 0;
 
 out_of_memory:
diff --git a/tools/bpf/bpftool/btf_dumper.c b/tools/bpf/bpftool/btf_dumper.c
index 0e9310727281..13be48763199 100644
--- a/tools/bpf/bpftool/btf_dumper.c
+++ b/tools/bpf/bpftool/btf_dumper.c
@@ -416,7 +416,7 @@ static int btf_dumper_int(const struct btf_type *t, __u8 bit_offset,
 					     *(char *)data);
 		break;
 	case BTF_INT_BOOL:
-		jsonw_bool(jw, *(int *)data);
+		jsonw_bool(jw, *(bool *)data);
 		break;
 	default:
 		/* shouldn't happen */
diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
index 1854d6b97860..4fd4e3462ebc 100644
--- a/tools/bpf/bpftool/main.c
+++ b/tools/bpf/bpftool/main.c
@@ -398,6 +398,16 @@ int main(int argc, char **argv)
 
 	setlinebuf(stdout);
 
+#ifdef USE_LIBCAP
+	/* Libcap < 2.63 hooks before main() to compute the number of
+	 * capabilities of the running kernel, and doing so it calls prctl()
+	 * which may fail and set errno to non-zero.
+	 * Let's reset errno to make sure this does not interfere with the
+	 * batch mode.
+	 */
+	errno = 0;
+#endif
+
 	last_do_help = do_help;
 	pretty_output = false;
 	json_output = false;
diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index e8745f646371..fa1f8faf7dfe 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -930,13 +930,13 @@ void xsk_socket__delete(struct xsk_socket *xsk)
 	ctx = xsk->ctx;
 	umem = ctx->umem;
 
-	xsk_put_ctx(ctx, true);
-
-	if (!ctx->refcount) {
+	if (ctx->refcount == 1) {
 		xsk_delete_bpf_maps(xsk);
 		close(ctx->prog_fd);
 	}
 
+	xsk_put_ctx(ctx, true);
+
 	err = xsk_get_mmap_offsets(xsk->fd, &off);
 	if (!err) {
 		if (xsk->rx) {
diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index 5aa3b4e76479..a2ea3931e01d 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -578,6 +578,11 @@ static int elf_update_symbol(struct elf *elf, struct section *symtab,
 	Elf64_Xword entsize = symtab->sh.sh_entsize;
 	int max_idx, idx = sym->idx;
 	Elf_Scn *s, *t = NULL;
+	bool is_special_shndx = sym->sym.st_shndx >= SHN_LORESERVE &&
+				sym->sym.st_shndx != SHN_XINDEX;
+
+	if (is_special_shndx)
+		shndx = sym->sym.st_shndx;
 
 	s = elf_getscn(elf->elf, symtab->idx);
 	if (!s) {
@@ -663,7 +668,7 @@ static int elf_update_symbol(struct elf *elf, struct section *symtab,
 	}
 
 	/* setup extended section index magic and write the symbol */
-	if (shndx >= SHN_UNDEF && shndx < SHN_LORESERVE) {
+	if ((shndx >= SHN_UNDEF && shndx < SHN_LORESERVE) || is_special_shndx) {
 		sym->sym.st_shndx = shndx;
 		if (!shndx_data)
 			shndx = 0;
diff --git a/tools/perf/util/intel-pt.c b/tools/perf/util/intel-pt.c
index 5163d2ffea70..453773ce6f45 100644
--- a/tools/perf/util/intel-pt.c
+++ b/tools/perf/util/intel-pt.c
@@ -3279,6 +3279,7 @@ static const char * const intel_pt_info_fmts[] = {
 	[INTEL_PT_SNAPSHOT_MODE]	= "  Snapshot mode       %"PRId64"\n",
 	[INTEL_PT_PER_CPU_MMAPS]	= "  Per-cpu maps        %"PRId64"\n",
 	[INTEL_PT_MTC_BIT]		= "  MTC bit             %#"PRIx64"\n",
+	[INTEL_PT_MTC_FREQ_BITS]	= "  MTC freq bits       %#"PRIx64"\n",
 	[INTEL_PT_TSC_CTC_N]		= "  TSC:CTC numerator   %"PRIu64"\n",
 	[INTEL_PT_TSC_CTC_D]		= "  TSC:CTC denominator %"PRIu64"\n",
 	[INTEL_PT_CYC_BIT]		= "  CYC bit             %#"PRIx64"\n",
@@ -3293,8 +3294,12 @@ static void intel_pt_print_info(__u64 *arr, int start, int finish)
 	if (!dump_trace)
 		return;
 
-	for (i = start; i <= finish; i++)
-		fprintf(stdout, intel_pt_info_fmts[i], arr[i]);
+	for (i = start; i <= finish; i++) {
+		const char *fmt = intel_pt_info_fmts[i];
+
+		if (fmt)
+			fprintf(stdout, fmt, arr[i]);
+	}
 }
 
 static void intel_pt_print_info_str(const char *name, const char *str)
diff --git a/tools/testing/selftests/arm64/signal/testcases/testcases.c b/tools/testing/selftests/arm64/signal/testcases/testcases.c
index 61ebcdf63831..a3ac5c2d8aac 100644
--- a/tools/testing/selftests/arm64/signal/testcases/testcases.c
+++ b/tools/testing/selftests/arm64/signal/testcases/testcases.c
@@ -33,7 +33,7 @@ bool validate_extra_context(struct extra_context *extra, char **err)
 		return false;
 
 	fprintf(stderr, "Validating EXTRA...\n");
-	term = GET_RESV_NEXT_HEAD(extra);
+	term = GET_RESV_NEXT_HEAD(&extra->head);
 	if (!term || term->magic || term->size) {
 		*err = "Missing terminator after EXTRA context";
 		return false;
diff --git a/tools/testing/selftests/tpm2/tpm2.py b/tools/testing/selftests/tpm2/tpm2.py
index f34486cd7342..3e67fdb518ec 100644
--- a/tools/testing/selftests/tpm2/tpm2.py
+++ b/tools/testing/selftests/tpm2/tpm2.py
@@ -370,6 +370,10 @@ class Client:
             fcntl.fcntl(self.tpm, fcntl.F_SETFL, flags)
             self.tpm_poll = select.poll()
 
+    def __del__(self):
+        if self.tpm:
+            self.tpm.close()
+
     def close(self):
         self.tpm.close()
 
