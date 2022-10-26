Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C300060DFAB
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 13:37:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233295AbiJZLhz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 07:37:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233476AbiJZLhx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 07:37:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9061FC58A5;
        Wed, 26 Oct 2022 04:37:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E6CE361E3C;
        Wed, 26 Oct 2022 11:37:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 728D4C433C1;
        Wed, 26 Oct 2022 11:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666784268;
        bh=pE2x1OQD/bhRVszSSL5yuGGQLPPkkpogeP+lvbpelGk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yzs5tB8BvOqgG+ZtwdK4kNbtileUmvsV67uAB86K6zrv4AY/Sz7VoYFBZoMcuscBU
         27nbpaKjnBpevdbIOr2M4gslwo+KTnZZnquaUsFXpvpOt7VcB8Rrn+pGBG7oJ5cqSq
         Nxw4QWAKsA80ZI+c+XKaF6sAZSYUB3L3uj/pY0rU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.14.296
Date:   Wed, 26 Oct 2022 13:37:37 +0200
Message-Id: <166678425613055@kroah.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <166678425611235@kroah.com>
References: <166678425611235@kroah.com>
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
index e21e2ca3e4f9..c6573a733a68 100644
--- a/Documentation/ABI/testing/sysfs-bus-iio
+++ b/Documentation/ABI/testing/sysfs-bus-iio
@@ -135,7 +135,7 @@ Description:
 		Raw capacitance measurement from channel Y. Units after
 		application of scale and offset are nanofarads.
 
-What:		/sys/.../iio:deviceX/in_capacitanceY-in_capacitanceZ_raw
+What:		/sys/.../iio:deviceX/in_capacitanceY-capacitanceZ_raw
 KernelVersion:	3.2
 Contact:	linux-iio@vger.kernel.org
 Description:
diff --git a/Documentation/devicetree/bindings/dma/moxa,moxart-dma.txt b/Documentation/devicetree/bindings/dma/moxa,moxart-dma.txt
index 8a9f3559335b..7e14e26676ec 100644
--- a/Documentation/devicetree/bindings/dma/moxa,moxart-dma.txt
+++ b/Documentation/devicetree/bindings/dma/moxa,moxart-dma.txt
@@ -34,8 +34,8 @@ Example:
 Use specific request line passing from dma
 For example, MMC request line is 5
 
-	sdhci: sdhci@98e00000 {
-		compatible = "moxa,moxart-sdhci";
+	mmc: mmc@98e00000 {
+		compatible = "moxa,moxart-mmc";
 		reg = <0x98e00000 0x5C>;
 		interrupts = <5 0>;
 		clocks = <&clk_apb>;
diff --git a/Makefile b/Makefile
index 74c0d3f17293..b7978fb873d6 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 14
-SUBLEVEL = 295
+SUBLEVEL = 296
 EXTRAVERSION =
 NAME = Petit Gorille
 
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 86ed77d75e4b..6fe7085cf7bd 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -63,7 +63,7 @@ config ARM
 	select HAVE_EFFICIENT_UNALIGNED_ACCESS if (CPU_V6 || CPU_V6K || CPU_V7) && MMU
 	select HAVE_EXIT_THREAD
 	select HAVE_FTRACE_MCOUNT_RECORD if (!XIP_KERNEL)
-	select HAVE_FUNCTION_GRAPH_TRACER if (!THUMB2_KERNEL)
+	select HAVE_FUNCTION_GRAPH_TRACER if (!THUMB2_KERNEL && !CC_IS_CLANG)
 	select HAVE_FUNCTION_TRACER if (!XIP_KERNEL)
 	select HAVE_FUTEX_CMPXCHG if FUTEX
 	select HAVE_GCC_PLUGINS
@@ -1951,7 +1951,6 @@ config CMDLINE
 choice
 	prompt "Kernel command line type" if CMDLINE != ""
 	default CMDLINE_FROM_BOOTLOADER
-	depends on ATAGS
 
 config CMDLINE_FROM_BOOTLOADER
 	bool "Use bootloader kernel arguments if available"
diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index d6cf18a0cb0a..fdffe3d4e1d4 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -18,8 +18,8 @@ config ARM_PTDUMP
 
 choice
 	prompt "Choose kernel unwinder"
-	default UNWINDER_ARM if AEABI && !FUNCTION_GRAPH_TRACER
-	default UNWINDER_FRAME_POINTER if !AEABI || FUNCTION_GRAPH_TRACER
+	default UNWINDER_ARM if AEABI
+	default UNWINDER_FRAME_POINTER if !AEABI
 	help
 	  This determines which method will be used for unwinding kernel stack
 	  traces for panics, oopses, bugs, warnings, perf, /proc/<pid>/stack,
@@ -36,7 +36,7 @@ config UNWINDER_FRAME_POINTER
 
 config UNWINDER_ARM
 	bool "ARM EABI stack unwinder"
-	depends on AEABI
+	depends on AEABI && !FUNCTION_GRAPH_TRACER
 	select ARM_UNWIND
 	help
 	  This option enables stack unwinding support in the kernel
diff --git a/arch/arm/boot/dts/armada-385-turris-omnia.dts b/arch/arm/boot/dts/armada-385-turris-omnia.dts
index 6c2d96cbd7cd..00f70c2fab24 100644
--- a/arch/arm/boot/dts/armada-385-turris-omnia.dts
+++ b/arch/arm/boot/dts/armada-385-turris-omnia.dts
@@ -340,7 +340,7 @@
 		marvell,function = "spi0";
 	};
 
-	spi0cs1_pins: spi0cs1-pins {
+	spi0cs2_pins: spi0cs2-pins {
 		marvell,pins = "mpp26";
 		marvell,function = "spi0";
 	};
@@ -375,7 +375,7 @@
 		};
 	};
 
-	/* MISO, MOSI, SCLK and CS1 are routed to pin header CN11 */
+	/* MISO, MOSI, SCLK and CS2 are routed to pin header CN11 */
 };
 
 &uart0 {
diff --git a/arch/arm/boot/dts/exynos4412-origen.dts b/arch/arm/boot/dts/exynos4412-origen.dts
index 8a89eb893d64..0224e1da66c5 100644
--- a/arch/arm/boot/dts/exynos4412-origen.dts
+++ b/arch/arm/boot/dts/exynos4412-origen.dts
@@ -90,7 +90,7 @@
 };
 
 &ehci {
-	samsung,vbus-gpio = <&gpx3 5 1>;
+	samsung,vbus-gpio = <&gpx3 5 GPIO_ACTIVE_HIGH>;
 	status = "okay";
 
 	port@1{
diff --git a/arch/arm/boot/dts/imx6dl.dtsi b/arch/arm/boot/dts/imx6dl.dtsi
index 8475e6cc59ac..71e7c87c7497 100644
--- a/arch/arm/boot/dts/imx6dl.dtsi
+++ b/arch/arm/boot/dts/imx6dl.dtsi
@@ -63,6 +63,9 @@
 		ocram: sram@00900000 {
 			compatible = "mmio-sram";
 			reg = <0x00900000 0x20000>;
+			ranges = <0 0x00900000 0x20000>;
+			#address-cells = <1>;
+			#size-cells = <1>;
 			clocks = <&clks IMX6QDL_CLK_OCRAM>;
 		};
 
diff --git a/arch/arm/boot/dts/imx6q.dtsi b/arch/arm/boot/dts/imx6q.dtsi
index 4747ede61acd..7b335e8050d3 100644
--- a/arch/arm/boot/dts/imx6q.dtsi
+++ b/arch/arm/boot/dts/imx6q.dtsi
@@ -82,6 +82,9 @@
 		ocram: sram@00900000 {
 			compatible = "mmio-sram";
 			reg = <0x00900000 0x40000>;
+			ranges = <0 0x00900000 0x40000>;
+			#address-cells = <1>;
+			#size-cells = <1>;
 			clocks = <&clks IMX6QDL_CLK_OCRAM>;
 		};
 
diff --git a/arch/arm/boot/dts/imx6qp.dtsi b/arch/arm/boot/dts/imx6qp.dtsi
index 299d863690c5..6cf0f9e18b70 100644
--- a/arch/arm/boot/dts/imx6qp.dtsi
+++ b/arch/arm/boot/dts/imx6qp.dtsi
@@ -47,12 +47,18 @@
 		ocram2: sram@00940000 {
 			compatible = "mmio-sram";
 			reg = <0x00940000 0x20000>;
+			ranges = <0 0x00940000 0x20000>;
+			#address-cells = <1>;
+			#size-cells = <1>;
 			clocks = <&clks IMX6QDL_CLK_OCRAM>;
 		};
 
 		ocram3: sram@00960000 {
 			compatible = "mmio-sram";
 			reg = <0x00960000 0x20000>;
+			ranges = <0 0x00960000 0x20000>;
+			#address-cells = <1>;
+			#size-cells = <1>;
 			clocks = <&clks IMX6QDL_CLK_OCRAM>;
 		};
 
diff --git a/arch/arm/boot/dts/imx6sl.dtsi b/arch/arm/boot/dts/imx6sl.dtsi
index bd9308b222ba..c8613ccd0944 100644
--- a/arch/arm/boot/dts/imx6sl.dtsi
+++ b/arch/arm/boot/dts/imx6sl.dtsi
@@ -112,6 +112,9 @@
 		ocram: sram@00900000 {
 			compatible = "mmio-sram";
 			reg = <0x00900000 0x20000>;
+			ranges = <0 0x00900000 0x20000>;
+			#address-cells = <1>;
+			#size-cells = <1>;
 			clocks = <&clks IMX6SL_CLK_OCRAM>;
 		};
 
diff --git a/arch/arm/boot/dts/imx7d-sdb.dts b/arch/arm/boot/dts/imx7d-sdb.dts
index 255e64ba32e2..7cf6557f4afc 100644
--- a/arch/arm/boot/dts/imx7d-sdb.dts
+++ b/arch/arm/boot/dts/imx7d-sdb.dts
@@ -179,12 +179,7 @@
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
@@ -10,6 +10,11 @@
 
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
@@ -213,22 +218,11 @@
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
diff --git a/arch/arm/boot/dts/moxart-uc7112lx.dts b/arch/arm/boot/dts/moxart-uc7112lx.dts
index 4a962a26482d..59d8775a3a93 100644
--- a/arch/arm/boot/dts/moxart-uc7112lx.dts
+++ b/arch/arm/boot/dts/moxart-uc7112lx.dts
@@ -80,7 +80,7 @@
 	clocks = <&ref12>;
 };
 
-&sdhci {
+&mmc {
 	status = "okay";
 };
 
diff --git a/arch/arm/boot/dts/moxart.dtsi b/arch/arm/boot/dts/moxart.dtsi
index da7b3237bfe9..804a2bc6ec82 100644
--- a/arch/arm/boot/dts/moxart.dtsi
+++ b/arch/arm/boot/dts/moxart.dtsi
@@ -93,8 +93,8 @@
 			clock-names = "PCLK";
 		};
 
-		sdhci: sdhci@98e00000 {
-			compatible = "moxa,moxart-sdhci";
+		mmc: mmc@98e00000 {
+			compatible = "moxa,moxart-mmc";
 			reg = <0x98e00000 0x5C>;
 			interrupts = <5 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&clk_apb>;
diff --git a/arch/mips/bcm47xx/prom.c b/arch/mips/bcm47xx/prom.c
index 135a5407f015..d26d9a6f6ee7 100644
--- a/arch/mips/bcm47xx/prom.c
+++ b/arch/mips/bcm47xx/prom.c
@@ -85,7 +85,7 @@ static __init void prom_init_mem(void)
 			pr_debug("Assume 128MB RAM\n");
 			break;
 		}
-		if (!memcmp(prom_init, prom_init + mem, 32))
+		if (!memcmp((void *)prom_init, (void *)prom_init + mem, 32))
 			break;
 	}
 	lowmem = mem;
@@ -162,7 +162,7 @@ void __init bcm47xx_prom_highmem_init(void)
 
 	off = EXTVBASE + __pa(off);
 	for (extmem = 128 << 20; extmem < 512 << 20; extmem <<= 1) {
-		if (!memcmp(prom_init, (void *)(off + extmem), 16))
+		if (!memcmp((void *)prom_init, (void *)(off + extmem), 16))
 			break;
 	}
 	extmem -= lowmem;
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
index e6d0b166d68d..b4314aa6769c 100644
--- a/arch/powerpc/boot/dts/fsl/mpc8540ads.dts
+++ b/arch/powerpc/boot/dts/fsl/mpc8540ads.dts
@@ -11,7 +11,7 @@
 
 /dts-v1/;
 
-/include/ "e500v2_power_isa.dtsi"
+/include/ "e500v1_power_isa.dtsi"
 
 / {
 	model = "MPC8540ADS";
diff --git a/arch/powerpc/boot/dts/fsl/mpc8541cds.dts b/arch/powerpc/boot/dts/fsl/mpc8541cds.dts
index 9fa2c734a988..48492c621edf 100644
--- a/arch/powerpc/boot/dts/fsl/mpc8541cds.dts
+++ b/arch/powerpc/boot/dts/fsl/mpc8541cds.dts
@@ -11,7 +11,7 @@
 
 /dts-v1/;
 
-/include/ "e500v2_power_isa.dtsi"
+/include/ "e500v1_power_isa.dtsi"
 
 / {
 	model = "MPC8541CDS";
diff --git a/arch/powerpc/boot/dts/fsl/mpc8555cds.dts b/arch/powerpc/boot/dts/fsl/mpc8555cds.dts
index 272f08caea92..325c817dedeb 100644
--- a/arch/powerpc/boot/dts/fsl/mpc8555cds.dts
+++ b/arch/powerpc/boot/dts/fsl/mpc8555cds.dts
@@ -11,7 +11,7 @@
 
 /dts-v1/;
 
-/include/ "e500v2_power_isa.dtsi"
+/include/ "e500v1_power_isa.dtsi"
 
 / {
 	model = "MPC8555CDS";
diff --git a/arch/powerpc/boot/dts/fsl/mpc8560ads.dts b/arch/powerpc/boot/dts/fsl/mpc8560ads.dts
index 7a822b08aa35..b5fb5ae3ed68 100644
--- a/arch/powerpc/boot/dts/fsl/mpc8560ads.dts
+++ b/arch/powerpc/boot/dts/fsl/mpc8560ads.dts
@@ -11,7 +11,7 @@
 
 /dts-v1/;
 
-/include/ "e500v2_power_isa.dtsi"
+/include/ "e500v1_power_isa.dtsi"
 
 / {
 	model = "MPC8560ADS";
diff --git a/arch/powerpc/kernel/pci_dn.c b/arch/powerpc/kernel/pci_dn.c
index 0e45a446a8c7..45aa39d55f91 100644
--- a/arch/powerpc/kernel/pci_dn.c
+++ b/arch/powerpc/kernel/pci_dn.c
@@ -344,6 +344,7 @@ struct pci_dn *pci_add_device_node_info(struct pci_controller *hose,
 	INIT_LIST_HEAD(&pdn->list);
 	parent = of_get_parent(dn);
 	pdn->parent = parent ? PCI_DN(parent) : NULL;
+	of_node_put(parent);
 	if (pdn->parent)
 		list_add_tail(&pdn->list, &pdn->parent->child_list);
 
diff --git a/arch/powerpc/math-emu/math_efp.c b/arch/powerpc/math-emu/math_efp.c
index 581f404caa1d..b9848179dbaa 100644
--- a/arch/powerpc/math-emu/math_efp.c
+++ b/arch/powerpc/math-emu/math_efp.c
@@ -21,6 +21,7 @@
 
 #include <linux/types.h>
 #include <linux/prctl.h>
+#include <linux/module.h>
 
 #include <linux/uaccess.h>
 #include <asm/reg.h>
diff --git a/arch/powerpc/platforms/powernv/opal.c b/arch/powerpc/platforms/powernv/opal.c
index 597fcbf7a39e..c8bc9accd858 100644
--- a/arch/powerpc/platforms/powernv/opal.c
+++ b/arch/powerpc/platforms/powernv/opal.c
@@ -677,6 +677,7 @@ static void opal_export_attrs(void)
 	kobj = kobject_create_and_add("exports", opal_kobj);
 	if (!kobj) {
 		pr_warn("kobject_create_and_add() of exports failed\n");
+		of_node_put(np);
 		return;
 	}
 
diff --git a/arch/powerpc/sysdev/fsl_msi.c b/arch/powerpc/sysdev/fsl_msi.c
index 44cbf4c12ea1..d43d3d1b27ed 100644
--- a/arch/powerpc/sysdev/fsl_msi.c
+++ b/arch/powerpc/sysdev/fsl_msi.c
@@ -216,8 +216,10 @@ static int fsl_setup_msi_irqs(struct pci_dev *pdev, int nvec, int type)
 			dev_err(&pdev->dev,
 				"node %pOF has an invalid fsl,msi phandle %u\n",
 				hose->dn, np->phandle);
+			of_node_put(np);
 			return -EINVAL;
 		}
+		of_node_put(np);
 	}
 
 	for_each_pci_msi_entry(entry, pdev) {
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
index ec05f491c347..a9f797a76e7c 100644
--- a/arch/sh/kernel/machvec.c
+++ b/arch/sh/kernel/machvec.c
@@ -22,8 +22,8 @@
 #define MV_NAME_SIZE 32
 
 #define for_each_mv(mv) \
-	for ((mv) = (struct sh_machine_vector *)&__machvec_start; \
-	     (mv) && (unsigned long)(mv) < (unsigned long)&__machvec_end; \
+	for ((mv) = (struct sh_machine_vector *)__machvec_start; \
+	     (mv) && (unsigned long)(mv) < (unsigned long)__machvec_end; \
 	     (mv)++)
 
 static struct sh_machine_vector * __init get_mv_byname(const char *name)
@@ -89,8 +89,8 @@ void __init sh_mv_setup(void)
 	if (!machvec_selected) {
 		unsigned long machvec_size;
 
-		machvec_size = ((unsigned long)&__machvec_end -
-				(unsigned long)&__machvec_start);
+		machvec_size = ((unsigned long)__machvec_end -
+				(unsigned long)__machvec_start);
 
 		/*
 		 * Sanity check for machvec section alignment. Ensure
@@ -104,7 +104,7 @@ void __init sh_mv_setup(void)
 		 * vector (usually the only one) from .machvec.init.
 		 */
 		if (machvec_size >= sizeof(struct sh_machine_vector))
-			sh_mv = *(struct sh_machine_vector *)&__machvec_start;
+			sh_mv = *(struct sh_machine_vector *)__machvec_start;
 	}
 
 	printk(KERN_NOTICE "Booting machvec: %s\n", get_system_type());
diff --git a/arch/um/kernel/um_arch.c b/arch/um/kernel/um_arch.c
index f433690b9b37..7bdc4cb82299 100644
--- a/arch/um/kernel/um_arch.c
+++ b/arch/um/kernel/um_arch.c
@@ -77,7 +77,7 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 
 static void *c_start(struct seq_file *m, loff_t *pos)
 {
-	return *pos < NR_CPUS ? cpu_data + *pos : NULL;
+	return *pos < nr_cpu_ids ? cpu_data + *pos : NULL;
 }
 
 static void *c_next(struct seq_file *m, void *v, loff_t *pos)
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 5b9ec38b7202..21480a6b1adc 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1988,7 +1988,7 @@ static int em_pop_sreg(struct x86_emulate_ctxt *ctxt)
 	if (rc != X86EMUL_CONTINUE)
 		return rc;
 
-	if (ctxt->modrm_reg == VCPU_SREG_SS)
+	if (seg == VCPU_SREG_SS)
 		ctxt->interruptibility = KVM_X86_SHADOW_INT_MOV_SS;
 	if (ctxt->op_bytes > 2)
 		rsp_increment(ctxt, ctxt->op_bytes - 2);
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 6a6d3cccae9a..27d99928a10e 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -11917,14 +11917,6 @@ static void prepare_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 		 */
 		vmcs12_save_pending_event(vcpu, vmcs12);
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
@@ -12236,6 +12228,17 @@ static void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason,
 			nested_vmx_abort(vcpu, VMX_ABORT_SAVE_GUEST_MSR_FAIL);
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
 	vm_entry_controls_reset_shadow(vmx);
 	vm_exit_controls_reset_shadow(vmx);
diff --git a/arch/x86/um/shared/sysdep/syscalls_32.h b/arch/x86/um/shared/sysdep/syscalls_32.h
index 68fd2cf526fd..f6e9f84397e7 100644
--- a/arch/x86/um/shared/sysdep/syscalls_32.h
+++ b/arch/x86/um/shared/sysdep/syscalls_32.h
@@ -6,10 +6,9 @@
 #include <asm/unistd.h>
 #include <sysdep/ptrace.h>
 
-typedef long syscall_handler_t(struct pt_regs);
+typedef long syscall_handler_t(struct syscall_args);
 
 extern syscall_handler_t *sys_call_table[];
 
 #define EXECUTE_SYSCALL(syscall, regs) \
-	((long (*)(struct syscall_args)) \
-	 (*sys_call_table[syscall]))(SYSCALL_ARGS(&regs->regs))
+	((*sys_call_table[syscall]))(SYSCALL_ARGS(&regs->regs))
diff --git a/arch/x86/um/tls_32.c b/arch/x86/um/tls_32.c
index 5bd949da7a4a..b69ab2409430 100644
--- a/arch/x86/um/tls_32.c
+++ b/arch/x86/um/tls_32.c
@@ -65,9 +65,6 @@ static int get_free_idx(struct task_struct* task)
 	struct thread_struct *t = &task->thread;
 	int idx;
 
-	if (!t->arch.tls_array)
-		return GDT_ENTRY_TLS_MIN;
-
 	for (idx = 0; idx < GDT_ENTRY_TLS_ENTRIES; idx++)
 		if (!t->arch.tls_array[idx].present)
 			return idx + GDT_ENTRY_TLS_MIN;
@@ -242,9 +239,6 @@ static int get_tls_entry(struct task_struct *task, struct user_desc *info,
 {
 	struct thread_struct *t = &task->thread;
 
-	if (!t->arch.tls_array)
-		goto clear;
-
 	if (idx < GDT_ENTRY_TLS_MIN || idx > GDT_ENTRY_TLS_MAX)
 		return -EINVAL;
 
diff --git a/drivers/acpi/acpi_video.c b/drivers/acpi/acpi_video.c
index 5a69260edf80..cc228e5ad2b3 100644
--- a/drivers/acpi/acpi_video.c
+++ b/drivers/acpi/acpi_video.c
@@ -511,6 +511,22 @@ static const struct dmi_system_id video_dmi_table[] = {
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
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 338d02a67afb..f01b8860ba14 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -1258,10 +1258,12 @@ static int nbd_start_device_ioctl(struct nbd_device *nbd, struct block_device *b
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
 	bd_set_size(bdev, 0);
 	/* user requested, ignore socket errors */
diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 125404773646..97c6a0405e1b 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -887,8 +887,8 @@ static const struct memdev {
 #endif
 	 [5] = { "zero", 0666, &zero_fops, 0 },
 	 [7] = { "full", 0666, &full_fops, 0 },
-	 [8] = { "random", 0666, &random_fops, 0 },
-	 [9] = { "urandom", 0666, &urandom_fops, 0 },
+	 [8] = { "random", 0666, &random_fops, FMODE_NOWAIT },
+	 [9] = { "urandom", 0666, &urandom_fops, FMODE_NOWAIT },
 #ifdef CONFIG_PRINTK
 	[11] = { "kmsg", 0644, &kmsg_fops, 0 },
 #endif
diff --git a/drivers/char/random.c b/drivers/char/random.c
index 261ec2a1dcf4..964f4828f507 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -890,10 +890,10 @@ void __init add_bootloader_randomness(const void *buf, size_t len)
 }
 
 struct fast_pool {
-	struct work_struct mix;
 	unsigned long pool[4];
 	unsigned long last;
 	unsigned int count;
+	struct timer_list mix;
 };
 
 static DEFINE_PER_CPU(struct fast_pool, irq_randomness) = {
@@ -945,9 +945,9 @@ int __cold random_online_cpu(unsigned int cpu)
 }
 #endif
 
-static void mix_interrupt_randomness(struct work_struct *work)
+static void mix_interrupt_randomness(unsigned long data)
 {
-	struct fast_pool *fast_pool = container_of(work, struct fast_pool, mix);
+	struct fast_pool *fast_pool = (struct fast_pool *)data;
 	/*
 	 * The size of the copied stack pool is explicitly 2 longs so that we
 	 * only ever ingest half of the siphash output each time, retaining
@@ -976,7 +976,7 @@ static void mix_interrupt_randomness(struct work_struct *work)
 	local_irq_enable();
 
 	mix_pool_bytes(pool, sizeof(pool));
-	credit_init_bits(max(1u, (count & U16_MAX) / 64));
+	credit_init_bits(clamp_t(unsigned int, (count & U16_MAX) / 64, 1, sizeof(pool) * 8));
 
 	memzero_explicit(pool, sizeof(pool));
 }
@@ -999,10 +999,14 @@ void add_interrupt_randomness(int irq)
 	if (new_count < 1024 && !time_is_before_jiffies(fast_pool->last + HZ))
 		return;
 
-	if (unlikely(!fast_pool->mix.func))
-		INIT_WORK(&fast_pool->mix, mix_interrupt_randomness);
+	if (unlikely(!fast_pool->mix.data))
+		setup_timer(&fast_pool->mix, mix_interrupt_randomness, (unsigned long)fast_pool);
+
 	fast_pool->count |= MIX_INFLIGHT;
-	queue_work_on(raw_smp_processor_id(), system_highpri_wq, &fast_pool->mix);
+	if (!timer_pending(&fast_pool->mix)) {
+		fast_pool->mix.expires = jiffies;
+		add_timer_on(&fast_pool->mix, raw_smp_processor_id());
+	}
 }
 EXPORT_SYMBOL_GPL(add_interrupt_randomness);
 
@@ -1294,6 +1298,11 @@ static ssize_t random_read_iter(struct kiocb *kiocb, struct iov_iter *iter)
 {
 	int ret;
 
+	if (!crng_ready() &&
+	    ((kiocb->ki_flags & IOCB_NOWAIT) ||
+	     (kiocb->ki_filp->f_flags & O_NONBLOCK)))
+		return -EAGAIN;
+
 	ret = wait_for_random_bytes();
 	if (ret != 0)
 		return ret;
diff --git a/drivers/clk/bcm/clk-bcm2835.c b/drivers/clk/bcm/clk-bcm2835.c
index 8ccd72cc66ba..be217c876e25 100644
--- a/drivers/clk/bcm/clk-bcm2835.c
+++ b/drivers/clk/bcm/clk-bcm2835.c
@@ -984,9 +984,9 @@ static u32 bcm2835_clock_choose_div(struct clk_hw *hw,
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
diff --git a/drivers/clk/bcm/clk-iproc-pll.c b/drivers/clk/bcm/clk-iproc-pll.c
index 375d8dd80d45..2e59314522dd 100644
--- a/drivers/clk/bcm/clk-iproc-pll.c
+++ b/drivers/clk/bcm/clk-iproc-pll.c
@@ -69,16 +69,6 @@ enum vco_freq_range {
 	VCO_MAX       = 4000000000U,
 };
 
-struct iproc_pll;
-
-struct iproc_clk {
-	struct clk_hw hw;
-	const char *name;
-	struct iproc_pll *pll;
-	unsigned long rate;
-	const struct iproc_clk_ctrl *ctrl;
-};
-
 struct iproc_pll {
 	void __iomem *status_base;
 	void __iomem *control_base;
@@ -88,9 +78,12 @@ struct iproc_pll {
 	const struct iproc_pll_ctrl *ctrl;
 	const struct iproc_pll_vco_param *vco_param;
 	unsigned int num_vco_entries;
+};
 
-	struct clk_hw_onecell_data *clk_data;
-	struct iproc_clk *clks;
+struct iproc_clk {
+	struct clk_hw hw;
+	struct iproc_pll *pll;
+	const struct iproc_clk_ctrl *ctrl;
 };
 
 #define to_iproc_clk(hw) container_of(hw, struct iproc_clk, hw)
@@ -263,6 +256,7 @@ static int pll_set_rate(struct iproc_clk *clk, unsigned int rate_index,
 	u32 val;
 	enum kp_band kp_index;
 	unsigned long ref_freq;
+	const char *clk_name = clk_hw_get_name(&clk->hw);
 
 	/*
 	 * reference frequency = parent frequency / PDIV
@@ -285,19 +279,19 @@ static int pll_set_rate(struct iproc_clk *clk, unsigned int rate_index,
 		kp_index = KP_BAND_HIGH_HIGH;
 	} else {
 		pr_err("%s: pll: %s has invalid rate: %lu\n", __func__,
-				clk->name, rate);
+				clk_name, rate);
 		return -EINVAL;
 	}
 
 	kp = get_kp(ref_freq, kp_index);
 	if (kp < 0) {
-		pr_err("%s: pll: %s has invalid kp\n", __func__, clk->name);
+		pr_err("%s: pll: %s has invalid kp\n", __func__, clk_name);
 		return kp;
 	}
 
 	ret = __pll_enable(pll);
 	if (ret) {
-		pr_err("%s: pll: %s fails to enable\n", __func__, clk->name);
+		pr_err("%s: pll: %s fails to enable\n", __func__, clk_name);
 		return ret;
 	}
 
@@ -354,7 +348,7 @@ static int pll_set_rate(struct iproc_clk *clk, unsigned int rate_index,
 
 	ret = pll_wait_for_lock(pll);
 	if (ret < 0) {
-		pr_err("%s: pll: %s failed to lock\n", __func__, clk->name);
+		pr_err("%s: pll: %s failed to lock\n", __func__, clk_name);
 		return ret;
 	}
 
@@ -390,16 +384,15 @@ static unsigned long iproc_pll_recalc_rate(struct clk_hw *hw,
 	u32 val;
 	u64 ndiv, ndiv_int, ndiv_frac;
 	unsigned int pdiv;
+	unsigned long rate;
 
 	if (parent_rate == 0)
 		return 0;
 
 	/* PLL needs to be locked */
 	val = readl(pll->status_base + ctrl->status.offset);
-	if ((val & (1 << ctrl->status.shift)) == 0) {
-		clk->rate = 0;
+	if ((val & (1 << ctrl->status.shift)) == 0)
 		return 0;
-	}
 
 	/*
 	 * PLL output frequency =
@@ -421,14 +414,14 @@ static unsigned long iproc_pll_recalc_rate(struct clk_hw *hw,
 	val = readl(pll->control_base + ctrl->pdiv.offset);
 	pdiv = (val >> ctrl->pdiv.shift) & bit_mask(ctrl->pdiv.width);
 
-	clk->rate = (ndiv * parent_rate) >> 20;
+	rate = (ndiv * parent_rate) >> 20;
 
 	if (pdiv == 0)
-		clk->rate *= 2;
+		rate *= 2;
 	else
-		clk->rate /= pdiv;
+		rate /= pdiv;
 
-	return clk->rate;
+	return rate;
 }
 
 static long iproc_pll_round_rate(struct clk_hw *hw, unsigned long rate,
@@ -518,6 +511,7 @@ static unsigned long iproc_clk_recalc_rate(struct clk_hw *hw,
 	struct iproc_pll *pll = clk->pll;
 	u32 val;
 	unsigned int mdiv;
+	unsigned long rate;
 
 	if (parent_rate == 0)
 		return 0;
@@ -528,11 +522,11 @@ static unsigned long iproc_clk_recalc_rate(struct clk_hw *hw,
 		mdiv = 256;
 
 	if (ctrl->flags & IPROC_CLK_MCLK_DIV_BY_2)
-		clk->rate = parent_rate / (mdiv * 2);
+		rate = parent_rate / (mdiv * 2);
 	else
-		clk->rate = parent_rate / mdiv;
+		rate = parent_rate / mdiv;
 
-	return clk->rate;
+	return rate;
 }
 
 static long iproc_clk_round_rate(struct clk_hw *hw, unsigned long rate,
@@ -583,10 +577,6 @@ static int iproc_clk_set_rate(struct clk_hw *hw, unsigned long rate,
 		val |= div << ctrl->mdiv.shift;
 	}
 	iproc_pll_write(pll, pll->control_base, ctrl->mdiv.offset, val);
-	if (ctrl->flags & IPROC_CLK_MCLK_DIV_BY_2)
-		clk->rate = parent_rate / (div * 2);
-	else
-		clk->rate = parent_rate / div;
 
 	return 0;
 }
@@ -629,6 +619,9 @@ void iproc_pll_clk_setup(struct device_node *node,
 	struct iproc_clk *iclk;
 	struct clk_init_data init;
 	const char *parent_name;
+	struct iproc_clk *iclk_array;
+	struct clk_hw_onecell_data *clk_data;
+	const char *clk_name;
 
 	if (WARN_ON(!pll_ctrl) || WARN_ON(!clk_ctrl))
 		return;
@@ -637,14 +630,14 @@ void iproc_pll_clk_setup(struct device_node *node,
 	if (WARN_ON(!pll))
 		return;
 
-	pll->clk_data = kzalloc(sizeof(*pll->clk_data->hws) * num_clks +
-				sizeof(*pll->clk_data), GFP_KERNEL);
-	if (WARN_ON(!pll->clk_data))
+	clk_data = kzalloc(sizeof(*clk_data->hws) * num_clks +
+				sizeof(*clk_data), GFP_KERNEL);
+	if (WARN_ON(!clk_data))
 		goto err_clk_data;
-	pll->clk_data->num = num_clks;
+	clk_data->num = num_clks;
 
-	pll->clks = kcalloc(num_clks, sizeof(*pll->clks), GFP_KERNEL);
-	if (WARN_ON(!pll->clks))
+	iclk_array = kcalloc(num_clks, sizeof(struct iproc_clk), GFP_KERNEL);
+	if (WARN_ON(!iclk_array))
 		goto err_clks;
 
 	pll->control_base = of_iomap(node, 0);
@@ -674,11 +667,15 @@ void iproc_pll_clk_setup(struct device_node *node,
 	/* initialize and register the PLL itself */
 	pll->ctrl = pll_ctrl;
 
-	iclk = &pll->clks[0];
+	iclk = &iclk_array[0];
 	iclk->pll = pll;
-	iclk->name = node->name;
 
-	init.name = node->name;
+	ret = of_property_read_string_index(node, "clock-output-names",
+					    0, &clk_name);
+	if (WARN_ON(ret))
+		goto err_pll_register;
+
+	init.name = clk_name;
 	init.ops = &iproc_pll_ops;
 	init.flags = 0;
 	parent_name = of_clk_get_parent_name(node, 0);
@@ -697,22 +694,19 @@ void iproc_pll_clk_setup(struct device_node *node,
 	if (WARN_ON(ret))
 		goto err_pll_register;
 
-	pll->clk_data->hws[0] = &iclk->hw;
+	clk_data->hws[0] = &iclk->hw;
+	parent_name = clk_name;
 
 	/* now initialize and register all leaf clocks */
 	for (i = 1; i < num_clks; i++) {
-		const char *clk_name;
-
 		memset(&init, 0, sizeof(init));
-		parent_name = node->name;
 
 		ret = of_property_read_string_index(node, "clock-output-names",
 						    i, &clk_name);
 		if (WARN_ON(ret))
 			goto err_clk_register;
 
-		iclk = &pll->clks[i];
-		iclk->name = clk_name;
+		iclk = &iclk_array[i];
 		iclk->pll = pll;
 		iclk->ctrl = &clk_ctrl[i];
 
@@ -727,11 +721,10 @@ void iproc_pll_clk_setup(struct device_node *node,
 		if (WARN_ON(ret))
 			goto err_clk_register;
 
-		pll->clk_data->hws[i] = &iclk->hw;
+		clk_data->hws[i] = &iclk->hw;
 	}
 
-	ret = of_clk_add_hw_provider(node, of_clk_hw_onecell_get,
-				     pll->clk_data);
+	ret = of_clk_add_hw_provider(node, of_clk_hw_onecell_get, clk_data);
 	if (WARN_ON(ret))
 		goto err_clk_register;
 
@@ -739,7 +732,7 @@ void iproc_pll_clk_setup(struct device_node *node,
 
 err_clk_register:
 	while (--i >= 0)
-		clk_hw_unregister(pll->clk_data->hws[i]);
+		clk_hw_unregister(clk_data->hws[i]);
 
 err_pll_register:
 	if (pll->status_base != pll->control_base)
@@ -756,10 +749,10 @@ void iproc_pll_clk_setup(struct device_node *node,
 	iounmap(pll->control_base);
 
 err_pll_iomap:
-	kfree(pll->clks);
+	kfree(iclk_array);
 
 err_clks:
-	kfree(pll->clk_data);
+	kfree(clk_data);
 
 err_clk_data:
 	kfree(pll);
diff --git a/drivers/clk/clk-oxnas.c b/drivers/clk/clk-oxnas.c
index e51e0023fc6e..a92bf71f03ac 100644
--- a/drivers/clk/clk-oxnas.c
+++ b/drivers/clk/clk-oxnas.c
@@ -218,7 +218,7 @@ static const struct of_device_id oxnas_stdclk_dt_ids[] = {
 
 static int oxnas_stdclk_probe(struct platform_device *pdev)
 {
-	struct device_node *np = pdev->dev.of_node;
+	struct device_node *np = pdev->dev.of_node, *parent_np;
 	const struct oxnas_stdclk_data *data;
 	const struct of_device_id *id;
 	struct regmap *regmap;
@@ -230,7 +230,9 @@ static int oxnas_stdclk_probe(struct platform_device *pdev)
 		return -ENODEV;
 	data = id->data;
 
-	regmap = syscon_node_to_regmap(of_get_parent(np));
+	parent_np = of_get_parent(np);
+	regmap = syscon_node_to_regmap(parent_np);
+	of_node_put(parent_np);
 	if (IS_ERR(regmap)) {
 		dev_err(&pdev->dev, "failed to have parent regmap\n");
 		return PTR_ERR(regmap);
diff --git a/drivers/clk/tegra/clk-tegra114.c b/drivers/clk/tegra/clk-tegra114.c
index fd1a99c05c2d..8c071a8fc710 100644
--- a/drivers/clk/tegra/clk-tegra114.c
+++ b/drivers/clk/tegra/clk-tegra114.c
@@ -1343,6 +1343,7 @@ static void __init tegra114_clock_init(struct device_node *np)
 	}
 
 	pmc_base = of_iomap(node, 0);
+	of_node_put(node);
 	if (!pmc_base) {
 		pr_err("Can't map pmc registers\n");
 		WARN_ON(1);
diff --git a/drivers/clk/tegra/clk-tegra20.c b/drivers/clk/tegra/clk-tegra20.c
index 837e5cbd60e9..4c9038e73888 100644
--- a/drivers/clk/tegra/clk-tegra20.c
+++ b/drivers/clk/tegra/clk-tegra20.c
@@ -1101,6 +1101,7 @@ static void __init tegra20_clock_init(struct device_node *np)
 	}
 
 	pmc_base = of_iomap(node, 0);
+	of_node_put(node);
 	if (!pmc_base) {
 		pr_err("Can't map pmc registers\n");
 		BUG();
diff --git a/drivers/clk/tegra/clk-tegra210.c b/drivers/clk/tegra/clk-tegra210.c
index cb2be154db3b..8aa400d04c6b 100644
--- a/drivers/clk/tegra/clk-tegra210.c
+++ b/drivers/clk/tegra/clk-tegra210.c
@@ -3130,6 +3130,7 @@ static void __init tegra210_clock_init(struct device_node *np)
 	}
 
 	pmc_base = of_iomap(node, 0);
+	of_node_put(node);
 	if (!pmc_base) {
 		pr_err("Can't map pmc registers\n");
 		WARN_ON(1);
diff --git a/drivers/clk/ti/clk-dra7-atl.c b/drivers/clk/ti/clk-dra7-atl.c
index beb672a215b6..a4b6f3ac2d34 100644
--- a/drivers/clk/ti/clk-dra7-atl.c
+++ b/drivers/clk/ti/clk-dra7-atl.c
@@ -252,14 +252,16 @@ static int of_dra7_atl_clk_probe(struct platform_device *pdev)
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
@@ -292,8 +294,9 @@ static int of_dra7_atl_clk_probe(struct platform_device *pdev)
 		if (cdesc->enabled)
 			atl_clk_enable(__clk_get_hw(clk));
 	}
-	pm_runtime_put_sync(cinfo->dev);
 
+pm_put:
+	pm_runtime_put_sync(cinfo->dev);
 	return ret;
 }
 
diff --git a/drivers/crypto/cavium/cpt/cptpf_main.c b/drivers/crypto/cavium/cpt/cptpf_main.c
index 34a6d8bf229e..dc34326e80df 100644
--- a/drivers/crypto/cavium/cpt/cptpf_main.c
+++ b/drivers/crypto/cavium/cpt/cptpf_main.c
@@ -257,6 +257,7 @@ static int cpt_ucode_load_fw(struct cpt_device *cpt, const u8 *fw, bool is_ae)
 	const struct firmware *fw_entry;
 	struct device *dev = &cpt->pdev->dev;
 	struct ucode_header *ucode;
+	unsigned int code_length;
 	struct microcode *mcode;
 	int j, ret = 0;
 
@@ -267,11 +268,12 @@ static int cpt_ucode_load_fw(struct cpt_device *cpt, const u8 *fw, bool is_ae)
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
diff --git a/drivers/dma/ioat/dma.c b/drivers/dma/ioat/dma.c
index 4c2b41beaf63..6f167a082832 100644
--- a/drivers/dma/ioat/dma.c
+++ b/drivers/dma/ioat/dma.c
@@ -654,7 +654,7 @@ static void __cleanup(struct ioatdma_chan *ioat_chan, dma_addr_t phys_complete)
 	if (active - i == 0) {
 		dev_dbg(to_dev(ioat_chan), "%s: cancel completion timeout\n",
 			__func__);
-		mod_timer(&ioat_chan->timer, jiffies + IDLE_TIMEOUT);
+		mod_timer_pending(&ioat_chan->timer, jiffies + IDLE_TIMEOUT);
 	}
 
 	/* microsecond delay by sysfs variable  per pending descriptor */
@@ -680,7 +680,7 @@ static void ioat_cleanup(struct ioatdma_chan *ioat_chan)
 
 		if (chanerr &
 		    (IOAT_CHANERR_HANDLE_MASK | IOAT_CHANERR_RECOVER_MASK)) {
-			mod_timer(&ioat_chan->timer, jiffies + IDLE_TIMEOUT);
+			mod_timer_pending(&ioat_chan->timer, jiffies + IDLE_TIMEOUT);
 			ioat_eh(ioat_chan);
 		}
 	}
@@ -872,7 +872,7 @@ static void check_active(struct ioatdma_chan *ioat_chan)
 	}
 
 	if (test_and_clear_bit(IOAT_CHAN_ACTIVE, &ioat_chan->state))
-		mod_timer(&ioat_chan->timer, jiffies + IDLE_TIMEOUT);
+		mod_timer_pending(&ioat_chan->timer, jiffies + IDLE_TIMEOUT);
 }
 
 void ioat_timer_event(unsigned long data)
diff --git a/drivers/dma/xilinx/xilinx_dma.c b/drivers/dma/xilinx/xilinx_dma.c
index 3c2084766a31..b4d00bc461db 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -2565,7 +2565,7 @@ static int xilinx_dma_probe(struct platform_device *pdev)
 		if (err < 0) {
 			dev_err(xdev->dev,
 				"missing xlnx,num-fstores property\n");
-			return err;
+			goto disable_clks;
 		}
 
 		err = of_property_read_u32(node, "xlnx,flush-fsync",
@@ -2585,7 +2585,11 @@ static int xilinx_dma_probe(struct platform_device *pdev)
 		xdev->ext_addr = false;
 
 	/* Set the dma mask bits */
-	dma_set_mask_and_coherent(xdev->dev, DMA_BIT_MASK(addr_width));
+	err = dma_set_mask_and_coherent(xdev->dev, DMA_BIT_MASK(addr_width));
+	if (err < 0) {
+		dev_err(xdev->dev, "DMA mask error %d\n", err);
+		goto disable_clks;
+	}
 
 	/* Initialize the DMA engine */
 	xdev->common.dev = &pdev->dev;
diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/efi/libstub/fdt.c
index dba296a44f4e..2a1a587edef9 100644
--- a/drivers/firmware/efi/libstub/fdt.c
+++ b/drivers/firmware/efi/libstub/fdt.c
@@ -301,14 +301,6 @@ efi_status_t allocate_new_fdt_and_exit_boot(efi_system_table_t *sys_table,
 		goto fail;
 	}
 
-	/*
-	 * Now that we have done our final memory allocation (and free)
-	 * we can get the memory map key needed for exit_boot_services().
-	 */
-	status = efi_get_memory_map(sys_table, &map);
-	if (status != EFI_SUCCESS)
-		goto fail_free_new_fdt;
-
 	status = update_fdt(sys_table, (void *)fdt_addr, fdt_size,
 			    (void *)*new_fdt_addr, MAX_FDT_SIZE, cmdline_ptr,
 			    initrd_addr, initrd_size);
diff --git a/drivers/firmware/google/gsmi.c b/drivers/firmware/google/gsmi.c
index 62337be07afc..2e3ef0eb6e82 100644
--- a/drivers/firmware/google/gsmi.c
+++ b/drivers/firmware/google/gsmi.c
@@ -661,6 +661,15 @@ static struct notifier_block gsmi_die_notifier = {
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
diff --git a/drivers/fsi/fsi-core.c b/drivers/fsi/fsi-core.c
index 8feca59c1f6b..392efc2a4b8c 100644
--- a/drivers/fsi/fsi-core.c
+++ b/drivers/fsi/fsi-core.c
@@ -821,6 +821,9 @@ int fsi_master_register(struct fsi_master *master)
 		return -EINVAL;
 
 	master->idx = ida_simple_get(&master_ida, 0, INT_MAX, GFP_KERNEL);
+	if (master->idx < 0)
+		return master->idx;
+
 	dev_set_name(&master->dev, "fsi%d", master->idx);
 
 	rc = device_register(&master->dev);
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c
index 0894bb98dc51..be3a384cc1cf 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c
@@ -1678,10 +1678,12 @@ amdgpu_connector_add(struct amdgpu_device *adev,
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
@@ -1786,6 +1788,7 @@ amdgpu_connector_add(struct amdgpu_device *adev,
 				drm_object_attach_property(&amdgpu_connector->base.base,
 							   adev->mode_info.audio_property,
 							   AMDGPU_AUDIO_AUTO);
+				amdgpu_connector->audio = AMDGPU_AUDIO_AUTO;
 			}
 			drm_object_attach_property(&amdgpu_connector->base.base,
 						   adev->mode_info.dither_property,
@@ -1834,6 +1837,7 @@ amdgpu_connector_add(struct amdgpu_device *adev,
 				drm_object_attach_property(&amdgpu_connector->base.base,
 							   adev->mode_info.audio_property,
 							   AMDGPU_AUDIO_AUTO);
+				amdgpu_connector->audio = AMDGPU_AUDIO_AUTO;
 			}
 			drm_object_attach_property(&amdgpu_connector->base.base,
 						   adev->mode_info.dither_property,
@@ -1879,6 +1883,7 @@ amdgpu_connector_add(struct amdgpu_device *adev,
 				drm_object_attach_property(&amdgpu_connector->base.base,
 							   adev->mode_info.audio_property,
 							   AMDGPU_AUDIO_AUTO);
+				amdgpu_connector->audio = AMDGPU_AUDIO_AUTO;
 			}
 			drm_object_attach_property(&amdgpu_connector->base.base,
 						   adev->mode_info.dither_property,
diff --git a/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c b/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
index 5855f17caf16..3a462240198a 100644
--- a/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
+++ b/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
@@ -1473,12 +1473,6 @@ int analogix_dp_suspend(struct device *dev)
 	struct analogix_dp_device *dp = dev_get_drvdata(dev);
 
 	clk_disable_unprepare(dp->clock);
-
-	if (dp->plat_data->panel) {
-		if (drm_panel_unprepare(dp->plat_data->panel))
-			DRM_ERROR("failed to turnoff the panel\n");
-	}
-
 	return 0;
 }
 EXPORT_SYMBOL_GPL(analogix_dp_suspend);
@@ -1494,13 +1488,6 @@ int analogix_dp_resume(struct device *dev)
 		return ret;
 	}
 
-	if (dp->plat_data->panel) {
-		if (drm_panel_prepare(dp->plat_data->panel)) {
-			DRM_ERROR("failed to setup the panel\n");
-			return -EBUSY;
-		}
-	}
-
 	return 0;
 }
 EXPORT_SYMBOL_GPL(analogix_dp_resume);
diff --git a/drivers/gpu/drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c b/drivers/gpu/drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c
index 4ab7b034bfec..313c80f29972 100644
--- a/drivers/gpu/drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c
+++ b/drivers/gpu/drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c
@@ -290,7 +290,9 @@ static void ge_b850v3_lvds_remove(void)
 	 * This check is to avoid both the drivers
 	 * removing the bridge in their remove() function
 	 */
-	if (!ge_b850v3_lvds_ptr)
+	if (!ge_b850v3_lvds_ptr ||
+	    !ge_b850v3_lvds_ptr->stdp2690_i2c ||
+		!ge_b850v3_lvds_ptr->stdp4028_i2c)
 		goto out;
 
 	drm_bridge_remove(&ge_b850v3_lvds_ptr->bridge);
diff --git a/drivers/gpu/drm/drm_ioctl.c b/drivers/gpu/drm/drm_ioctl.c
index ce26e8fea9c2..73dcf03e7e8c 100644
--- a/drivers/gpu/drm/drm_ioctl.c
+++ b/drivers/gpu/drm/drm_ioctl.c
@@ -437,7 +437,13 @@ EXPORT_SYMBOL(drm_invalid_op);
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
index 6f0de951b75d..bd5e8661f826 100644
--- a/drivers/gpu/drm/drm_mipi_dsi.c
+++ b/drivers/gpu/drm/drm_mipi_dsi.c
@@ -305,6 +305,7 @@ static int mipi_dsi_remove_device_fn(struct device *dev, void *priv)
 {
 	struct mipi_dsi_device *dsi = to_mipi_dsi_device(dev);
 
+	mipi_dsi_detach(dsi);
 	mipi_dsi_device_unregister(dsi);
 
 	return 0;
diff --git a/drivers/gpu/drm/vc4/vc4_vec.c b/drivers/gpu/drm/vc4/vc4_vec.c
index 3a9a302247a2..bcf7880f84a8 100644
--- a/drivers/gpu/drm/vc4/vc4_vec.c
+++ b/drivers/gpu/drm/vc4/vc4_vec.c
@@ -291,7 +291,7 @@ static void vc4_vec_ntsc_j_mode_set(struct vc4_vec *vec)
 static const struct drm_display_mode ntsc_mode = {
 	DRM_MODE("720x480", DRM_MODE_TYPE_DRIVER, 13500,
 		 720, 720 + 14, 720 + 14 + 64, 720 + 14 + 64 + 60, 0,
-		 480, 480 + 3, 480 + 3 + 3, 480 + 3 + 3 + 16, 0,
+		 480, 480 + 7, 480 + 7 + 6, 525, 0,
 		 DRM_MODE_FLAG_INTERLACE)
 };
 
@@ -313,7 +313,7 @@ static void vc4_vec_pal_m_mode_set(struct vc4_vec *vec)
 static const struct drm_display_mode pal_mode = {
 	DRM_MODE("720x576", DRM_MODE_TYPE_DRIVER, 13500,
 		 720, 720 + 20, 720 + 20 + 64, 720 + 20 + 64 + 60, 0,
-		 576, 576 + 2, 576 + 2 + 3, 576 + 2 + 3 + 20, 0,
+		 576, 576 + 4, 576 + 4 + 6, 625, 0,
 		 DRM_MODE_FLAG_INTERLACE)
 };
 
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index ac31998f93a8..0fa3bd2b035e 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -832,7 +832,7 @@ static void mt_touch_report(struct hid_device *hid, struct hid_report *report)
 	int r, n;
 
 	/* sticky fingers release in progress, abort */
-	if (test_and_set_bit(MT_IO_FLAGS_RUNNING, &td->mt_io_flags))
+	if (test_and_set_bit_lock(MT_IO_FLAGS_RUNNING, &td->mt_io_flags))
 		return;
 
 	/*
@@ -888,7 +888,7 @@ static void mt_touch_report(struct hid_device *hid, struct hid_report *report)
 			del_timer(&td->release_timer);
 	}
 
-	clear_bit(MT_IO_FLAGS_RUNNING, &td->mt_io_flags);
+	clear_bit_unlock(MT_IO_FLAGS_RUNNING, &td->mt_io_flags);
 }
 
 static int mt_touch_input_configured(struct hid_device *hdev,
@@ -1271,11 +1271,11 @@ static void mt_expired_timeout(unsigned long arg)
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
index fb77dec720a4..edfaf2cd0f26 100644
--- a/drivers/hid/hid-roccat.c
+++ b/drivers/hid/hid-roccat.c
@@ -260,6 +260,8 @@ int roccat_report_event(int minor, u8 const *data)
 	if (!new_value)
 		return -ENOMEM;
 
+	mutex_lock(&device->cbuf_lock);
+
 	report = &device->cbuf[device->cbuf_end];
 
 	/* passing NULL is safe */
@@ -279,6 +281,8 @@ int roccat_report_event(int minor, u8 const *data)
 			reader->cbuf_start = (reader->cbuf_start + 1) % ROCCAT_CBUF_SIZE;
 	}
 
+	mutex_unlock(&device->cbuf_lock);
+
 	wake_up_interruptible(&device->wait);
 	return 0;
 }
diff --git a/drivers/hsi/controllers/omap_ssi_core.c b/drivers/hsi/controllers/omap_ssi_core.c
index 3554443a609c..6e9d88d9d471 100644
--- a/drivers/hsi/controllers/omap_ssi_core.c
+++ b/drivers/hsi/controllers/omap_ssi_core.c
@@ -560,6 +560,7 @@ static int ssi_probe(struct platform_device *pd)
 		if (!childpdev) {
 			err = -ENODEV;
 			dev_err(&pd->dev, "failed to create ssi controller port\n");
+			of_node_put(child);
 			goto out3;
 		}
 	}
diff --git a/drivers/hsi/controllers/omap_ssi_port.c b/drivers/hsi/controllers/omap_ssi_port.c
index 7765de2f1ef1..68619dd6dfc1 100644
--- a/drivers/hsi/controllers/omap_ssi_port.c
+++ b/drivers/hsi/controllers/omap_ssi_port.c
@@ -252,10 +252,10 @@ static int ssi_start_dma(struct hsi_msg *msg, int lch)
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
@@ -269,10 +269,10 @@ static int ssi_start_dma(struct hsi_msg *msg, int lch)
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
diff --git a/drivers/i2c/i2c-dev.c b/drivers/i2c/i2c-dev.c
index b7f9fb00f695..08aff5ebc99a 100644
--- a/drivers/i2c/i2c-dev.c
+++ b/drivers/i2c/i2c-dev.c
@@ -297,7 +297,7 @@ static noinline int i2cdev_ioctl_rdwr(struct i2c_client *client,
 		 */
 		if (rdwr_pa[i].flags & I2C_M_RECV_LEN) {
 			if (!(rdwr_pa[i].flags & I2C_M_RD) ||
-			    rdwr_pa[i].buf[0] < 1 ||
+			    rdwr_pa[i].len < 1 || rdwr_pa[i].buf[0] < 1 ||
 			    rdwr_pa[i].len < rdwr_pa[i].buf[0] +
 					     I2C_SMBUS_BLOCK_MAX) {
 				i++;
diff --git a/drivers/iio/adc/at91-sama5d2_adc.c b/drivers/iio/adc/at91-sama5d2_adc.c
index 34639ee2d2ce..e015b86be6b0 100644
--- a/drivers/iio/adc/at91-sama5d2_adc.c
+++ b/drivers/iio/adc/at91-sama5d2_adc.c
@@ -79,7 +79,7 @@
 #define	AT91_SAMA5D2_MR_ANACH		BIT(23)
 /* Tracking Time */
 #define	AT91_SAMA5D2_MR_TRACKTIM(v)	((v) << 24)
-#define	AT91_SAMA5D2_MR_TRACKTIM_MAX	0xff
+#define	AT91_SAMA5D2_MR_TRACKTIM_MAX	0xf
 /* Transfer Time */
 #define	AT91_SAMA5D2_MR_TRANSFER(v)	((v) << 28)
 #define	AT91_SAMA5D2_MR_TRANSFER_MAX	0x3
diff --git a/drivers/iio/dac/ad5593r.c b/drivers/iio/dac/ad5593r.c
index fc11ea098f98..3d807522a35f 100644
--- a/drivers/iio/dac/ad5593r.c
+++ b/drivers/iio/dac/ad5593r.c
@@ -15,6 +15,8 @@
 #include <linux/of.h>
 #include <linux/acpi.h>
 
+#include <asm/unaligned.h>
+
 #define AD5593R_MODE_CONF		(0 << 4)
 #define AD5593R_MODE_DAC_WRITE		(1 << 4)
 #define AD5593R_MODE_ADC_READBACK	(4 << 4)
@@ -22,6 +24,24 @@
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
@@ -40,13 +60,7 @@ static int ad5593r_read_adc(struct ad5592r_state *st, unsigned chan, u16 *value)
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
@@ -60,25 +74,19 @@ static int ad5593r_reg_write(struct ad5592r_state *st, u8 reg, u16 value)
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
index f12bad60a581..599069b4fe5d 100644
--- a/drivers/iio/inkern.c
+++ b/drivers/iio/inkern.c
@@ -139,9 +139,10 @@ static int __of_iio_channel_get(struct iio_channel *channel,
 
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
@@ -149,6 +150,7 @@ static int __of_iio_channel_get(struct iio_channel *channel,
 		index = indio_dev->info->of_xlate(indio_dev, &iiospec);
 	else
 		index = __of_iio_simple_xlate(indio_dev, &iiospec);
+	of_node_put(iiospec.np);
 	if (index < 0)
 		goto err_put;
 	channel->channel = &indio_dev->channels[index];
diff --git a/drivers/infiniband/sw/rxe/rxe_qp.c b/drivers/infiniband/sw/rxe/rxe_qp.c
index 6964e843bbae..2391b0e698a9 100644
--- a/drivers/infiniband/sw/rxe/rxe_qp.c
+++ b/drivers/infiniband/sw/rxe/rxe_qp.c
@@ -829,7 +829,9 @@ void rxe_qp_destroy(struct rxe_qp *qp)
 	rxe_cleanup_task(&qp->comp.task);
 
 	/* flush out any receive wr's or pending requests */
-	__rxe_do_task(&qp->req.task);
+	if (qp->req.task.func)
+		__rxe_do_task(&qp->req.task);
+
 	if (qp->sq.queue) {
 		__rxe_do_task(&qp->comp.task);
 		__rxe_do_task(&qp->req.task);
@@ -869,8 +871,10 @@ static void rxe_qp_do_cleanup(struct work_struct *work)
 
 	free_rd_atomic_resources(qp);
 
-	kernel_sock_shutdown(qp->sk, SHUT_RDWR);
-	sock_release(qp->sk);
+	if (qp->sk) {
+		kernel_sock_shutdown(qp->sk, SHUT_RDWR);
+		sock_release(qp->sk);
+	}
 }
 
 /* called when the last reference to the qp is dropped */
diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
index f8f6bd92e314..1a12f9522730 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -129,6 +129,8 @@ static const struct xpad_device {
 	u8 xtype;
 } xpad_device[] = {
 	{ 0x0079, 0x18d4, "GPD Win 2 X-Box Controller", 0, XTYPE_XBOX360 },
+	{ 0x03eb, 0xff01, "Wooting One (Legacy)", 0, XTYPE_XBOX360 },
+	{ 0x03eb, 0xff02, "Wooting Two (Legacy)", 0, XTYPE_XBOX360 },
 	{ 0x044f, 0x0f00, "Thrustmaster Wheel", 0, XTYPE_XBOX },
 	{ 0x044f, 0x0f03, "Thrustmaster Wheel", 0, XTYPE_XBOX },
 	{ 0x044f, 0x0f07, "Thrustmaster, Inc. Controller", 0, XTYPE_XBOX },
@@ -259,6 +261,7 @@ static const struct xpad_device {
 	{ 0x0f0d, 0x0063, "Hori Real Arcade Pro Hayabusa (USA) Xbox One", MAP_TRIGGERS_TO_BUTTONS, XTYPE_XBOXONE },
 	{ 0x0f0d, 0x0067, "HORIPAD ONE", 0, XTYPE_XBOXONE },
 	{ 0x0f0d, 0x0078, "Hori Real Arcade Pro V Kai Xbox One", MAP_TRIGGERS_TO_BUTTONS, XTYPE_XBOXONE },
+	{ 0x0f0d, 0x00c5, "Hori Fighting Commander ONE", MAP_TRIGGERS_TO_BUTTONS, XTYPE_XBOXONE },
 	{ 0x0f30, 0x010b, "Philips Recoil", 0, XTYPE_XBOX },
 	{ 0x0f30, 0x0202, "Joytech Advanced Controller", 0, XTYPE_XBOX },
 	{ 0x0f30, 0x8888, "BigBen XBMiniPad Controller", 0, XTYPE_XBOX },
@@ -275,6 +278,7 @@ static const struct xpad_device {
 	{ 0x1430, 0x8888, "TX6500+ Dance Pad (first generation)", MAP_DPAD_TO_BUTTONS, XTYPE_XBOX },
 	{ 0x1430, 0xf801, "RedOctane Controller", 0, XTYPE_XBOX360 },
 	{ 0x146b, 0x0601, "BigBen Interactive XBOX 360 Controller", 0, XTYPE_XBOX360 },
+	{ 0x146b, 0x0604, "Bigben Interactive DAIJA Arcade Stick", MAP_TRIGGERS_TO_BUTTONS, XTYPE_XBOX360 },
 	{ 0x1532, 0x0037, "Razer Sabertooth", 0, XTYPE_XBOX360 },
 	{ 0x1532, 0x0a00, "Razer Atrox Arcade Stick", MAP_TRIGGERS_TO_BUTTONS, XTYPE_XBOXONE },
 	{ 0x1532, 0x0a03, "Razer Wildcat", 0, XTYPE_XBOXONE },
@@ -339,6 +343,7 @@ static const struct xpad_device {
 	{ 0x24c6, 0x5502, "Hori Fighting Stick VX Alt", MAP_TRIGGERS_TO_BUTTONS, XTYPE_XBOX360 },
 	{ 0x24c6, 0x5503, "Hori Fighting Edge", MAP_TRIGGERS_TO_BUTTONS, XTYPE_XBOX360 },
 	{ 0x24c6, 0x5506, "Hori SOULCALIBUR V Stick", 0, XTYPE_XBOX360 },
+	{ 0x24c6, 0x5510, "Hori Fighting Commander ONE (Xbox 360/PC Mode)", MAP_TRIGGERS_TO_BUTTONS, XTYPE_XBOX360 },
 	{ 0x24c6, 0x550d, "Hori GEM Xbox controller", 0, XTYPE_XBOX360 },
 	{ 0x24c6, 0x550e, "Hori Real Arcade Pro V Kai 360", MAP_TRIGGERS_TO_BUTTONS, XTYPE_XBOX360 },
 	{ 0x24c6, 0x551a, "PowerA FUSION Pro Controller", 0, XTYPE_XBOXONE },
@@ -348,6 +353,14 @@ static const struct xpad_device {
 	{ 0x24c6, 0x5b03, "Thrustmaster Ferrari 458 Racing Wheel", 0, XTYPE_XBOX360 },
 	{ 0x24c6, 0x5d04, "Razer Sabertooth", 0, XTYPE_XBOX360 },
 	{ 0x24c6, 0xfafe, "Rock Candy Gamepad for Xbox 360", 0, XTYPE_XBOX360 },
+	{ 0x2563, 0x058d, "OneXPlayer Gamepad", 0, XTYPE_XBOX360 },
+	{ 0x2dc8, 0x2000, "8BitDo Pro 2 Wired Controller fox Xbox", 0, XTYPE_XBOXONE },
+	{ 0x31e3, 0x1100, "Wooting One", 0, XTYPE_XBOX360 },
+	{ 0x31e3, 0x1200, "Wooting Two", 0, XTYPE_XBOX360 },
+	{ 0x31e3, 0x1210, "Wooting Lekker", 0, XTYPE_XBOX360 },
+	{ 0x31e3, 0x1220, "Wooting Two HE", 0, XTYPE_XBOX360 },
+	{ 0x31e3, 0x1300, "Wooting 60HE (AVR)", 0, XTYPE_XBOX360 },
+	{ 0x31e3, 0x1310, "Wooting 60HE (ARM)", 0, XTYPE_XBOX360 },
 	{ 0x3285, 0x0607, "Nacon GC-100", 0, XTYPE_XBOX360 },
 	{ 0x3767, 0x0101, "Fanatec Speedster 3 Forceshock Wheel", 0, XTYPE_XBOX },
 	{ 0xffff, 0xffff, "Chinese-made Xbox Controller", 0, XTYPE_XBOX },
@@ -433,6 +446,7 @@ static const signed short xpad_abs_triggers[] = {
 static const struct usb_device_id xpad_table[] = {
 	{ USB_INTERFACE_INFO('X', 'B', 0) },	/* X-Box USB-IF not approved class */
 	XPAD_XBOX360_VENDOR(0x0079),		/* GPD Win 2 Controller */
+	XPAD_XBOX360_VENDOR(0x03eb),		/* Wooting Keyboards (Legacy) */
 	XPAD_XBOX360_VENDOR(0x044f),		/* Thrustmaster X-Box 360 controllers */
 	XPAD_XBOX360_VENDOR(0x045e),		/* Microsoft X-Box 360 controllers */
 	XPAD_XBOXONE_VENDOR(0x045e),		/* Microsoft X-Box One controllers */
@@ -443,6 +457,7 @@ static const struct usb_device_id xpad_table[] = {
 	{ USB_DEVICE(0x0738, 0x4540) },		/* Mad Catz Beat Pad */
 	XPAD_XBOXONE_VENDOR(0x0738),		/* Mad Catz FightStick TE 2 */
 	XPAD_XBOX360_VENDOR(0x07ff),		/* Mad Catz GamePad */
+	XPAD_XBOX360_VENDOR(0x0c12),		/* Zeroplus X-Box 360 controllers */
 	XPAD_XBOX360_VENDOR(0x0e6f),		/* 0x0e6f X-Box 360 controllers */
 	XPAD_XBOXONE_VENDOR(0x0e6f),		/* 0x0e6f X-Box One controllers */
 	XPAD_XBOX360_VENDOR(0x0f0d),		/* Hori Controllers */
@@ -463,8 +478,12 @@ static const struct usb_device_id xpad_table[] = {
 	XPAD_XBOXONE_VENDOR(0x20d6),		/* PowerA Controllers */
 	XPAD_XBOX360_VENDOR(0x24c6),		/* PowerA Controllers */
 	XPAD_XBOXONE_VENDOR(0x24c6),		/* PowerA Controllers */
+	XPAD_XBOX360_VENDOR(0x2563),		/* OneXPlayer Gamepad */
+	XPAD_XBOX360_VENDOR(0x260d),		/* Dareu H101 */
+	XPAD_XBOXONE_VENDOR(0x2dc8),		/* 8BitDo Pro 2 Wired Controller for Xbox */
 	XPAD_XBOXONE_VENDOR(0x2e24),		/* Hyperkin Duke X-Box One pad */
 	XPAD_XBOX360_VENDOR(0x2f24),		/* GameSir Controllers */
+	XPAD_XBOX360_VENDOR(0x31e3),		/* Wooting Keyboards */
 	XPAD_XBOX360_VENDOR(0x3285),		/* Nacon GC-100 */
 	{ }
 };
@@ -1981,7 +2000,6 @@ static struct usb_driver xpad_driver = {
 	.disconnect	= xpad_disconnect,
 	.suspend	= xpad_suspend,
 	.resume		= xpad_resume,
-	.reset_resume	= xpad_resume,
 	.id_table	= xpad_table,
 };
 
diff --git a/drivers/input/touchscreen/melfas_mip4.c b/drivers/input/touchscreen/melfas_mip4.c
index 05108c2fea93..633d7e1dc7d6 100644
--- a/drivers/input/touchscreen/melfas_mip4.c
+++ b/drivers/input/touchscreen/melfas_mip4.c
@@ -1469,7 +1469,7 @@ static int mip4_probe(struct i2c_client *client, const struct i2c_device_id *id)
 					      "ce", GPIOD_OUT_LOW);
 	if (IS_ERR(ts->gpio_ce)) {
 		error = PTR_ERR(ts->gpio_ce);
-		if (error != EPROBE_DEFER)
+		if (error != -EPROBE_DEFER)
 			dev_err(&client->dev,
 				"Failed to get gpio: %d\n", error);
 		return error;
diff --git a/drivers/iommu/omap-iommu-debug.c b/drivers/iommu/omap-iommu-debug.c
index cec33e90e399..a15c4d99b888 100644
--- a/drivers/iommu/omap-iommu-debug.c
+++ b/drivers/iommu/omap-iommu-debug.c
@@ -35,12 +35,12 @@ static inline bool is_omap_iommu_detached(struct omap_iommu *obj)
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
index 6be2041248d3..c86f33ed9ef9 100644
--- a/drivers/isdn/mISDN/l1oip_core.c
+++ b/drivers/isdn/mISDN/l1oip_core.c
@@ -289,7 +289,7 @@ l1oip_socket_send(struct l1oip *hc, u8 localcodec, u8 channel, u32 chanmask,
 	p = frame;
 
 	/* restart timer */
-	if (time_before(hc->keep_tl.expires, jiffies + 5 * HZ))
+	if (time_before(hc->keep_tl.expires, jiffies + 5 * HZ) && !hc->shutdown)
 		mod_timer(&hc->keep_tl, jiffies + L1OIP_KEEPALIVE * HZ);
 	else
 		hc->keep_tl.expires = jiffies + L1OIP_KEEPALIVE * HZ;
@@ -621,7 +621,9 @@ l1oip_socket_parse(struct l1oip *hc, struct sockaddr_in *sin, u8 *buf, int len)
 		goto multiframe;
 
 	/* restart timer */
-	if (time_before(hc->timeout_tl.expires, jiffies + 5 * HZ) || !hc->timeout_on) {
+	if ((time_before(hc->timeout_tl.expires, jiffies + 5 * HZ) ||
+	     !hc->timeout_on) &&
+	    !hc->shutdown) {
 		hc->timeout_on = 1;
 		mod_timer(&hc->timeout_tl, jiffies + L1OIP_TIMEOUT * HZ);
 	} else /* only adjust timer */
@@ -1248,11 +1250,10 @@ release_card(struct l1oip *hc)
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
 
diff --git a/drivers/mailbox/bcm-flexrm-mailbox.c b/drivers/mailbox/bcm-flexrm-mailbox.c
index 7e3ed2714630..6e5d59f40a18 100644
--- a/drivers/mailbox/bcm-flexrm-mailbox.c
+++ b/drivers/mailbox/bcm-flexrm-mailbox.c
@@ -626,15 +626,15 @@ static int flexrm_spu_dma_map(struct device *dev, struct brcm_message *msg)
 
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
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 671d57c30690..2c79685a6d45 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -70,8 +70,8 @@ static void dump_zones(struct mddev *mddev)
 		int len = 0;
 
 		for (k = 0; k < conf->strip_zone[j].nb_dev; k++)
-			len += snprintf(line+len, 200-len, "%s%s", k?"/":"",
-					bdevname(conf->devlist[j*raid_disks
+			len += scnprintf(line+len, 200-len, "%s%s", k?"/":"",
+					 bdevname(conf->devlist[j*raid_disks
 							       + k]->bdev, b));
 		pr_debug("md: zone%d=[%s]\n", j, line);
 
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 866ba1743f9f..dc053a43a3dc 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -44,6 +44,7 @@
  */
 
 #include <linux/blkdev.h>
+#include <linux/delay.h>
 #include <linux/kthread.h>
 #include <linux/raid/pq.h>
 #include <linux/async_tx.h>
@@ -3720,7 +3721,7 @@ static void handle_stripe_fill(struct stripe_head *sh,
 		 * back cache (prexor with orig_page, and then xor with
 		 * page) in the read path
 		 */
-		if (s->injournal && s->failed) {
+		if (s->to_read && s->injournal && s->failed) {
 			if (test_bit(STRIPE_R5C_CACHING, &sh->state))
 				r5c_make_stripe_write_out(sh);
 			goto out;
@@ -6308,7 +6309,18 @@ static void raid5d(struct md_thread *thread)
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
index c637679b01b2..2649f87c070f 100644
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
index 1748812bd7e5..79c293c86f14 100644
--- a/drivers/media/pci/cx88/cx88-video.c
+++ b/drivers/media/pci/cx88/cx88-video.c
@@ -452,6 +452,7 @@ static int queue_setup(struct vb2_queue *q,
 
 static int buffer_prepare(struct vb2_buffer *vb)
 {
+	int ret;
 	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct cx8800_dev *dev = vb->vb2_queue->drv_priv;
 	struct cx88_core *core = dev->core;
@@ -466,35 +467,35 @@ static int buffer_prepare(struct vb2_buffer *vb)
 
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
@@ -502,7 +503,7 @@ static int buffer_prepare(struct vb2_buffer *vb)
 		buf, buf->vb.vb2_buf.index,
 		core->width, core->height, dev->fmt->depth, dev->fmt->name,
 		(unsigned long)buf->risc.dma);
-	return 0;
+	return ret;
 }
 
 static void buffer_finish(struct vb2_buffer *vb)
diff --git a/drivers/media/platform/exynos4-is/fimc-is.c b/drivers/media/platform/exynos4-is/fimc-is.c
index 0f3f82bd4d20..6f59fe02c727 100644
--- a/drivers/media/platform/exynos4-is/fimc-is.c
+++ b/drivers/media/platform/exynos4-is/fimc-is.c
@@ -217,6 +217,7 @@ static int fimc_is_register_subdevs(struct fimc_is *is)
 
 			if (ret < 0 || index >= FIMC_IS_SENSORS_NUM) {
 				of_node_put(child);
+				of_node_put(i2c_bus);
 				return ret;
 			}
 			index++;
diff --git a/drivers/media/platform/xilinx/xilinx-vipp.c b/drivers/media/platform/xilinx/xilinx-vipp.c
index ebfdf334d99c..7e0d7a47adf4 100644
--- a/drivers/media/platform/xilinx/xilinx-vipp.c
+++ b/drivers/media/platform/xilinx/xilinx-vipp.c
@@ -467,7 +467,7 @@ static int xvip_graph_dma_init(struct xvip_composite_device *xdev)
 {
 	struct device_node *ports;
 	struct device_node *port;
-	int ret;
+	int ret = 0;
 
 	ports = of_get_child_by_name(xdev->dev->of_node, "ports");
 	if (ports == NULL) {
@@ -477,13 +477,14 @@ static int xvip_graph_dma_init(struct xvip_composite_device *xdev)
 
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
index 568f05ed961a..36517b7d093e 100644
--- a/drivers/memory/of_memory.c
+++ b/drivers/memory/of_memory.c
@@ -135,6 +135,7 @@ const struct lpddr2_timings *of_get_ddr_timings(struct device_node *np_ddr,
 	for_each_child_of_node(np_ddr, np_tim) {
 		if (of_device_is_compatible(np_tim, tim_compat)) {
 			if (of_do_get_timings(np_tim, &timings[i])) {
+				of_node_put(np_tim);
 				devm_kfree(dev, timings);
 				goto default_timings;
 			}
diff --git a/drivers/mfd/fsl-imx25-tsadc.c b/drivers/mfd/fsl-imx25-tsadc.c
index 461b0990b56f..5ad721035e49 100644
--- a/drivers/mfd/fsl-imx25-tsadc.c
+++ b/drivers/mfd/fsl-imx25-tsadc.c
@@ -90,6 +90,19 @@ static int mx25_tsadc_setup_irq(struct platform_device *pdev,
 	return 0;
 }
 
+static int mx25_tsadc_unset_irq(struct platform_device *pdev)
+{
+	struct mx25_tsadc *tsadc = platform_get_drvdata(pdev);
+	int irq = platform_get_irq(pdev, 0);
+
+	if (irq) {
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
@@ -177,18 +190,21 @@ static int mx25_tsadc_probe(struct platform_device *pdev)
 
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
index 36adf9e8153e..eb9ff34294e6 100644
--- a/drivers/mfd/intel_soc_pmic_core.c
+++ b/drivers/mfd/intel_soc_pmic_core.c
@@ -119,6 +119,7 @@ static int intel_soc_pmic_i2c_probe(struct i2c_client *i2c,
 	return 0;
 
 err_del_irq_chip:
+	pwm_remove_table(crc_pwm_lookup, ARRAY_SIZE(crc_pwm_lookup));
 	regmap_del_irq_chip(pmic->irq, pmic->irq_chip_data);
 	return ret;
 }
diff --git a/drivers/mfd/lp8788-irq.c b/drivers/mfd/lp8788-irq.c
index 792d51bae20f..ae65928f35f0 100644
--- a/drivers/mfd/lp8788-irq.c
+++ b/drivers/mfd/lp8788-irq.c
@@ -179,6 +179,7 @@ int lp8788_irq_init(struct lp8788 *lp, int irq)
 				IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
 				"lp8788-irq", irqd);
 	if (ret) {
+		irq_domain_remove(lp->irqdm);
 		dev_err(lp->dev, "failed to create a thread for IRQ_N\n");
 		return ret;
 	}
@@ -192,4 +193,6 @@ void lp8788_irq_exit(struct lp8788 *lp)
 {
 	if (lp->irq)
 		free_irq(lp->irq, lp->irqdm);
+	if (lp->irqdm)
+		irq_domain_remove(lp->irqdm);
 }
diff --git a/drivers/mfd/lp8788.c b/drivers/mfd/lp8788.c
index acf616559512..e47150cdf747 100644
--- a/drivers/mfd/lp8788.c
+++ b/drivers/mfd/lp8788.c
@@ -199,8 +199,16 @@ static int lp8788_probe(struct i2c_client *cl, const struct i2c_device_id *id)
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
index 4ca245518a19..d64bd28cc6b8 100644
--- a/drivers/mfd/sm501.c
+++ b/drivers/mfd/sm501.c
@@ -1736,7 +1736,12 @@ static struct platform_driver sm501_plat_driver = {
 
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
 
diff --git a/drivers/mmc/core/sd.c b/drivers/mmc/core/sd.c
index 942dc358b9fd..78a9f509218a 100644
--- a/drivers/mmc/core/sd.c
+++ b/drivers/mmc/core/sd.c
@@ -793,7 +793,8 @@ int mmc_sd_get_cid(struct mmc_host *host, u32 ocr, u32 *cid, u32 *rocr)
 	 * the CCS bit is set as well. We deliberately deviate from the spec in
 	 * regards to this, which allows UHS-I to be supported for SDSC cards.
 	 */
-	if (!mmc_host_is_spi(host) && rocr && (*rocr & 0x01000000)) {
+	if (!mmc_host_is_spi(host) && (ocr & SD_OCR_S18R) &&
+	    rocr && (*rocr & SD_ROCR_S18A)) {
 		err = mmc_set_uhs_voltage(host, pocr);
 		if (err == -EAGAIN) {
 			retries--;
diff --git a/drivers/mmc/host/au1xmmc.c b/drivers/mmc/host/au1xmmc.c
index ed77fbfa4774..a1667339e21d 100644
--- a/drivers/mmc/host/au1xmmc.c
+++ b/drivers/mmc/host/au1xmmc.c
@@ -1114,8 +1114,9 @@ static int au1xmmc_probe(struct platform_device *pdev)
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
diff --git a/drivers/mmc/host/moxart-mmc.c b/drivers/mmc/host/moxart-mmc.c
index 5c81dc7371db..1552d1f09c5c 100644
--- a/drivers/mmc/host/moxart-mmc.c
+++ b/drivers/mmc/host/moxart-mmc.c
@@ -111,8 +111,8 @@
 #define CLK_DIV_MASK		0x7f
 
 /* REG_BUS_WIDTH */
-#define BUS_WIDTH_8		BIT(2)
-#define BUS_WIDTH_4		BIT(1)
+#define BUS_WIDTH_4_SUPPORT	BIT(3)
+#define BUS_WIDTH_4		BIT(2)
 #define BUS_WIDTH_1		BIT(0)
 
 #define MMC_VDD_360		23
@@ -527,9 +527,6 @@ static void moxart_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 	case MMC_BUS_WIDTH_4:
 		writel(BUS_WIDTH_4, host->base + REG_BUS_WIDTH);
 		break;
-	case MMC_BUS_WIDTH_8:
-		writel(BUS_WIDTH_8, host->base + REG_BUS_WIDTH);
-		break;
 	default:
 		writel(BUS_WIDTH_1, host->base + REG_BUS_WIDTH);
 		break;
@@ -646,16 +643,8 @@ static int moxart_probe(struct platform_device *pdev)
 		dmaengine_slave_config(host->dma_chan_rx, &cfg);
 	}
 
-	switch ((readl(host->base + REG_BUS_WIDTH) >> 3) & 3) {
-	case 1:
+	if (readl(host->base + REG_BUS_WIDTH) & BUS_WIDTH_4_SUPPORT)
 		mmc->caps |= MMC_CAP_4_BIT_DATA;
-		break;
-	case 2:
-		mmc->caps |= MMC_CAP_4_BIT_DATA | MMC_CAP_8_BIT_DATA;
-		break;
-	default:
-		break;
-	}
 
 	writel(0, host->base + REG_INTERRUPT_MASK);
 
diff --git a/drivers/mmc/host/wmt-sdmmc.c b/drivers/mmc/host/wmt-sdmmc.c
index fd30ac7da5e5..85cad20b2ae8 100644
--- a/drivers/mmc/host/wmt-sdmmc.c
+++ b/drivers/mmc/host/wmt-sdmmc.c
@@ -853,7 +853,7 @@ static int wmt_mci_probe(struct platform_device *pdev)
 	if (IS_ERR(priv->clk_sdmmc)) {
 		dev_err(&pdev->dev, "Error getting clock\n");
 		ret = PTR_ERR(priv->clk_sdmmc);
-		goto fail5;
+		goto fail5_and_a_half;
 	}
 
 	ret = clk_prepare_enable(priv->clk_sdmmc);
@@ -870,6 +870,9 @@ static int wmt_mci_probe(struct platform_device *pdev)
 	return 0;
 fail6:
 	clk_put(priv->clk_sdmmc);
+fail5_and_a_half:
+	dma_free_coherent(&pdev->dev, mmc->max_blk_count * 16,
+			  priv->dma_desc_buffer, priv->dma_desc_device_addr);
 fail5:
 	free_irq(dma_irq, priv);
 fail4:
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index 8c111def8185..96478d79243d 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -787,6 +787,7 @@ static void bnx2x_tpa_stop(struct bnx2x *bp, struct bnx2x_fastpath *fp,
 			BNX2X_ERR("skb_put is about to fail...  pad %d  len %d  rx_buf_size %d\n",
 				  pad, len, fp->rx_buf_size);
 			bnx2x_panic();
+			bnx2x_frag_free(fp, new_data);
 			return;
 		}
 #endif
diff --git a/drivers/net/ethernet/freescale/fs_enet/mac-fec.c b/drivers/net/ethernet/freescale/fs_enet/mac-fec.c
index 1fc27c97e3b2..e52231cfcf77 100644
--- a/drivers/net/ethernet/freescale/fs_enet/mac-fec.c
+++ b/drivers/net/ethernet/freescale/fs_enet/mac-fec.c
@@ -97,7 +97,7 @@ static int do_pd_setup(struct fs_enet_private *fep)
 		return -EINVAL;
 
 	fep->fec.fecp = of_iomap(ofdev->dev.of_node, 0);
-	if (!fep->fcc.fccp)
+	if (!fep->fec.fecp)
 		return -EINVAL;
 
 	return 0;
diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 75c09ba6a45f..66c6b7111a3a 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1346,6 +1346,7 @@ static const struct usb_device_id products[] = {
 	{QMI_FIXED_INTF(0x413c, 0x81b3, 8)},	/* Dell Wireless 5809e Gobi(TM) 4G LTE Mobile Broadband Card (rev3) */
 	{QMI_FIXED_INTF(0x413c, 0x81b6, 8)},	/* Dell Wireless 5811e */
 	{QMI_FIXED_INTF(0x413c, 0x81b6, 10)},	/* Dell Wireless 5811e */
+	{QMI_FIXED_INTF(0x413c, 0x81c2, 8)},	/* Dell Wireless 5811e */
 	{QMI_FIXED_INTF(0x413c, 0x81cc, 8)},	/* Dell Wireless 5816e */
 	{QMI_FIXED_INTF(0x413c, 0x81d7, 0)},	/* Dell Wireless 5821e */
 	{QMI_FIXED_INTF(0x413c, 0x81d7, 1)},	/* Dell Wireless 5821e preproduction config */
diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index a5a4fef09b93..1ed358d0da84 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -1382,7 +1382,9 @@ static void intr_callback(struct urb *urb)
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
diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 69be3593bc0e..71b026277b30 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1598,6 +1598,7 @@ void usbnet_disconnect (struct usb_interface *intf)
 	struct usbnet		*dev;
 	struct usb_device	*xdev;
 	struct net_device	*net;
+	struct urb		*urb;
 
 	dev = usb_get_intfdata(intf);
 	usb_set_intfdata(intf, NULL);
@@ -1614,7 +1615,11 @@ void usbnet_disconnect (struct usb_interface *intf)
 	net = dev->net;
 	unregister_netdev (net);
 
-	usb_scuttle_anchored_urbs(&dev->deferred);
+	while ((urb = usb_get_from_anchor(&dev->deferred))) {
+		dev_kfree_skb(urb->context);
+		kfree(urb->sg);
+		usb_free_urb(urb);
+	}
 
 	if (dev->driver_info->unbind)
 		dev->driver_info->unbind (dev, intf);
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 41ae999c685b..49e2bfc85f1a 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -806,11 +806,36 @@ static int ath10k_peer_delete(struct ath10k *ar, u32 vdev_id, const u8 *addr)
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
 
@@ -822,25 +847,7 @@ static void ath10k_peer_cleanup(struct ath10k *ar, u32 vdev_id)
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
@@ -6232,10 +6239,7 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
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
diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.c b/drivers/net/wireless/ath/ath9k/htc_hst.c
index e37de14bc502..6d69cf69fd86 100644
--- a/drivers/net/wireless/ath/ath9k/htc_hst.c
+++ b/drivers/net/wireless/ath/ath9k/htc_hst.c
@@ -367,33 +367,27 @@ void ath9k_htc_txcompletion_cb(struct htc_target *htc_handle,
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
@@ -414,16 +408,26 @@ void ath9k_htc_rx_msg(struct htc_target *htc_handle,
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
@@ -435,21 +439,30 @@ void ath9k_htc_rx_msg(struct htc_target *htc_handle,
 
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
index 590bef2defb9..9c8102be1d0b 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -200,6 +200,7 @@ static netdev_tx_t brcmf_netdev_start_xmit(struct sk_buff *skb,
 	struct brcmf_pub *drvr = ifp->drvr;
 	struct ethhdr *eh;
 	int head_delta;
+	unsigned int tx_bytes = skb->len;
 
 	brcmf_dbg(DATA, "Enter, bsscfgidx=%d\n", ifp->bsscfgidx);
 
@@ -254,7 +255,7 @@ static netdev_tx_t brcmf_netdev_start_xmit(struct sk_buff *skb,
 		ndev->stats.tx_dropped++;
 	} else {
 		ndev->stats.tx_packets++;
-		ndev->stats.tx_bytes += skb->len;
+		ndev->stats.tx_bytes += tx_bytes;
 	}
 
 	/* Return ok: we always eat the packet */
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c
index ffa243e2e2d0..581a23549ee5 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c
@@ -163,12 +163,12 @@ static int brcmf_pno_set_random(struct brcmf_if *ifp, struct brcmf_pno_info *pi)
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
 
@@ -190,7 +190,7 @@ static int brcmf_pno_set_random(struct brcmf_if *ifp, struct brcmf_pno_info *pi)
 	pfn_mac.mac[0] |= 0x02;
 
 	brcmf_dbg(SCAN, "enabling random mac: reqid=%llu mac=%pM\n",
-		  pi->reqs[i]->reqid, pfn_mac.mac);
+		  pi->reqs[ri]->reqid, pfn_mac.mac);
 	err = brcmf_fil_iovar_data_set(ifp, "pfn_macaddr", &pfn_mac,
 				       sizeof(pfn_mac));
 	if (err)
diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 885c4352bdef..55cca2ffa392 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -3075,6 +3075,8 @@ static int hwsim_cloned_frame_received_nl(struct sk_buff *skb_2,
 
 	rx_status.band = data2->channel->band;
 	rx_status.rate_idx = nla_get_u32(info->attrs[HWSIM_ATTR_RX_RATE]);
+	if (rx_status.rate_idx >= data2->hw->wiphy->bands[rx_status.band]->n_bitrates)
+		goto out;
 	rx_status.signal = nla_get_u32(info->attrs[HWSIM_ATTR_SIGNAL]);
 
 	memcpy(IEEE80211_SKB_RXCB(skb), &rx_status, sizeof(rx_status));
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index d2c289446c00..155c08dc2e0e 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -3655,7 +3655,10 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
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
@@ -3835,7 +3838,8 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 		reg += 2 * rt2x00dev->lna_gain;
 		rt2800_bbp_write_with_rx_chain(rt2x00dev, 66, reg);
 
-		rt2800_iq_calibrate(rt2x00dev, rf->channel);
+		if (rt2x00_rt(rt2x00dev, RT5592))
+			rt2800_iq_calibrate(rt2x00dev, rf->channel);
 	}
 
 	bbp = rt2800_bbp_read(rt2x00dev, 4);
@@ -5314,7 +5318,7 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000404);
 	} else if (rt2x00_rt(rt2x00dev, RT6352)) {
 		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000401);
-		rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x000C0000);
+		rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x000C0001);
 		rt2800_register_write(rt2x00dev, TX_SW_CFG2, 0x00000000);
 		rt2800_register_write(rt2x00dev, MIMO_PS_CFG, 0x00000002);
 		rt2800_register_write(rt2x00dev, TX_PIN_CFG, 0x00150F0F);
@@ -5566,6 +5570,27 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
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
index 5cf61710ae2f..a287c28b38b5 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -1879,13 +1879,6 @@ static int rtl8xxxu_read_efuse(struct rtl8xxxu_priv *priv)
 
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
@@ -1896,6 +1889,13 @@ static int rtl8xxxu_read_efuse(struct rtl8xxxu_priv *priv)
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
@@ -2930,12 +2930,12 @@ bool rtl8xxxu_gen2_simularity_compare(struct rtl8xxxu_priv *priv,
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
@@ -4955,6 +4955,8 @@ static void rtl8xxxu_tx(struct ieee80211_hw *hw,
 	if (control && control->sta)
 		sta = control->sta;
 
+	queue = rtl8xxxu_queue_select(hw, skb);
+
 	tx_desc = skb_push(skb, tx_desc_size);
 
 	memset(tx_desc, 0, tx_desc_size);
@@ -4967,7 +4969,6 @@ static void rtl8xxxu_tx(struct ieee80211_hw *hw,
 	    is_broadcast_ether_addr(ieee80211_get_DA(hdr)))
 		tx_desc->txdw0 |= TXDESC_BROADMULTICAST;
 
-	queue = rtl8xxxu_queue_select(hw, skb);
 	tx_desc->txdw1 = cpu_to_le32(queue << TXDESC_QUEUE_SHIFT);
 
 	if (tx_info->control.hw_key) {
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 2d95755092e3..8e136867180a 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1345,18 +1345,21 @@ static int nvme_pr_preempt(struct block_device *bdev, u64 old, u64 new,
 		enum pr_type type, bool abort)
 {
 	u32 cdw10 = nvme_pr_type(type) << 8 | (abort ? 2 : 1);
+
 	return nvme_pr_command(bdev, cdw10, old, new, nvme_cmd_resv_acquire);
 }
 
 static int nvme_pr_clear(struct block_device *bdev, u64 key)
 {
-	u32 cdw10 = 1 | (key ? 1 << 3 : 0);
-	return nvme_pr_command(bdev, cdw10, key, 0, nvme_cmd_resv_register);
+	u32 cdw10 = 1 | (key ? 0 : 1 << 3);
+
+	return nvme_pr_command(bdev, cdw10, key, 0, nvme_cmd_resv_release);
 }
 
 static int nvme_pr_release(struct block_device *bdev, u64 key, enum pr_type type)
 {
-	u32 cdw10 = nvme_pr_type(type) << 8 | (key ? 1 << 3 : 0);
+	u32 cdw10 = nvme_pr_type(type) << 8 | (key ? 0 : 1 << 3);
+
 	return nvme_pr_command(bdev, cdw10, key, 0, nvme_cmd_resv_release);
 }
 
diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
index c039149cacb0..dd0cd90a5252 100644
--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -215,6 +215,17 @@ static int pci_revert_fw_address(struct resource *res, struct pci_dev *dev,
 
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
index c110563a73cb..00926df4bc5b 100644
--- a/drivers/phy/qualcomm/phy-qcom-usb-hsic.c
+++ b/drivers/phy/qualcomm/phy-qcom-usb-hsic.c
@@ -57,8 +57,10 @@ static int qcom_usb_hsic_phy_power_on(struct phy *phy)
 
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
diff --git a/drivers/platform/x86/msi-laptop.c b/drivers/platform/x86/msi-laptop.c
index d5bfcc602090..42b31c549db0 100644
--- a/drivers/platform/x86/msi-laptop.c
+++ b/drivers/platform/x86/msi-laptop.c
@@ -609,11 +609,10 @@ static const struct dmi_system_id msi_dmi_table[] __initconst = {
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
@@ -646,8 +645,7 @@ static const struct dmi_system_id msi_dmi_table[] __initconst = {
 			DMI_MATCH(DMI_SYS_VENDOR, "NOTEBOOK"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "SAM2000"),
 			DMI_MATCH(DMI_PRODUCT_VERSION, "0131"),
-			DMI_MATCH(DMI_CHASSIS_VENDOR,
-				  "MICRO-STAR INT'L CO.,LTD")
+			DMI_MATCH(DMI_CHASSIS_VENDOR, "MICRO-STAR INT")
 		},
 		.driver_data = &quirk_old_ec_model,
 		.callback = dmi_check_cb
@@ -1061,8 +1059,7 @@ static int __init msi_init(void)
 		return -EINVAL;
 
 	/* Register backlight stuff */
-
-	if (quirks->old_ec_model ||
+	if (quirks->old_ec_model &&
 	    acpi_video_get_backlight_type() == acpi_backlight_vendor) {
 		struct backlight_properties props;
 		memset(&props, 0, sizeof(struct backlight_properties));
@@ -1130,6 +1127,8 @@ static int __init msi_init(void)
 fail_create_group:
 	if (quirks->load_scm_model) {
 		i8042_remove_filter(msi_laptop_i8042_filter);
+		cancel_delayed_work_sync(&msi_touchpad_dwork);
+		input_unregister_device(msi_laptop_input_dev);
 		cancel_delayed_work_sync(&msi_rfkill_dwork);
 		cancel_work_sync(&msi_rfkill_work);
 		rfkill_cleanup();
@@ -1150,6 +1149,7 @@ static void __exit msi_cleanup(void)
 {
 	if (quirks->load_scm_model) {
 		i8042_remove_filter(msi_laptop_i8042_filter);
+		cancel_delayed_work_sync(&msi_touchpad_dwork);
 		input_unregister_device(msi_laptop_input_dev);
 		cancel_delayed_work_sync(&msi_rfkill_dwork);
 		cancel_work_sync(&msi_rfkill_work);
diff --git a/drivers/powercap/intel_rapl.c b/drivers/powercap/intel_rapl.c
index 54ddd78924dd..5c07e04db421 100644
--- a/drivers/powercap/intel_rapl.c
+++ b/drivers/powercap/intel_rapl.c
@@ -1066,6 +1066,9 @@ static u64 rapl_compute_time_window_core(struct rapl_package *rp, u64 value,
 		y = value & 0x1f;
 		value = (1 << y) * (4 + f) * rp->time_unit / 4;
 	} else {
+		if (value < rp->time_unit)
+			return 0;
+
 		do_div(value, rp->time_unit);
 		y = ilog2(value);
 		f = div64_u64(4 * (value - (1 << y)), 1 << y);
diff --git a/drivers/regulator/qcom_rpm-regulator.c b/drivers/regulator/qcom_rpm-regulator.c
index 88dc0b0f003c..b64baea6d533 100644
--- a/drivers/regulator/qcom_rpm-regulator.c
+++ b/drivers/regulator/qcom_rpm-regulator.c
@@ -820,6 +820,12 @@ static const struct rpm_regulator_data rpm_pm8018_regulators[] = {
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
@@ -847,12 +853,6 @@ static const struct rpm_regulator_data rpm_pm8058_regulators[] = {
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
 
@@ -861,6 +861,12 @@ static const struct rpm_regulator_data rpm_pm8058_regulators[] = {
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
@@ -869,12 +875,6 @@ static const struct rpm_regulator_data rpm_pm8901_regulators[] = {
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
diff --git a/drivers/rpmsg/qcom_glink_native.c b/drivers/rpmsg/qcom_glink_native.c
index 67711537d3ff..4c90364638f9 100644
--- a/drivers/rpmsg/qcom_glink_native.c
+++ b/drivers/rpmsg/qcom_glink_native.c
@@ -1447,7 +1447,7 @@ static void qcom_glink_rx_close(struct qcom_glink *glink, unsigned int rcid)
 	cancel_work_sync(&channel->intent_work);
 
 	if (channel->rpdev) {
-		strncpy(chinfo.name, channel->name, sizeof(chinfo.name));
+		strscpy_pad(chinfo.name, channel->name, sizeof(chinfo.name));
 		chinfo.src = RPMSG_ADDR_ANY;
 		chinfo.dst = RPMSG_ADDR_ANY;
 
diff --git a/drivers/rpmsg/qcom_smd.c b/drivers/rpmsg/qcom_smd.c
index 781df7a17b56..c30dfd3f506f 100644
--- a/drivers/rpmsg/qcom_smd.c
+++ b/drivers/rpmsg/qcom_smd.c
@@ -1000,7 +1000,7 @@ static int qcom_smd_create_device(struct qcom_smd_channel *channel)
 
 	/* Assign public information to the rpmsg_device */
 	rpdev = &qsdev->rpdev;
-	strncpy(rpdev->id.name, channel->name, RPMSG_NAME_SIZE);
+	strscpy_pad(rpdev->id.name, channel->name, RPMSG_NAME_SIZE);
 	rpdev->src = RPMSG_ADDR_ANY;
 	rpdev->dst = RPMSG_ADDR_ANY;
 
@@ -1230,7 +1230,7 @@ static void qcom_channel_state_worker(struct work_struct *work)
 
 		spin_unlock_irqrestore(&edge->channels_lock, flags);
 
-		strncpy(chinfo.name, channel->name, sizeof(chinfo.name));
+		strscpy_pad(chinfo.name, channel->name, sizeof(chinfo.name));
 		chinfo.src = RPMSG_ADDR_ANY;
 		chinfo.dst = RPMSG_ADDR_ANY;
 		rpmsg_unregister_device(&edge->dev, &chinfo);
diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index dd342207095a..0baeed1793aa 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -2013,7 +2013,7 @@ static int twa_probe(struct pci_dev *pdev, const struct pci_device_id *dev_id)
 	retval = pci_enable_device(pdev);
 	if (retval) {
 		TW_PRINTK(host, TW_DRIVER, 0x34, "Failed to enable pci device");
-		goto out_disable_device;
+		return -ENODEV;
 	}
 
 	pci_set_master(pdev);
diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 9b20643ab49d..124a5d0ec05c 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -673,16 +673,17 @@ stex_queuecommand_lck(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 		return 0;
 	case PASSTHRU_CMD:
 		if (cmd->cmnd[1] == PASSTHRU_GET_DRVVER) {
-			struct st_drvver ver;
+			const struct st_drvver ver = {
+				.major = ST_VER_MAJOR,
+				.minor = ST_VER_MINOR,
+				.oem = ST_OEM,
+				.build = ST_BUILD_VER,
+				.signature[0] = PASSTHRU_SIGNATURE,
+				.console_id = host->max_id - 1,
+				.host_no = hba->host->host_no,
+			};
 			size_t cp_len = sizeof(ver);
 
-			ver.major = ST_VER_MAJOR;
-			ver.minor = ST_VER_MINOR;
-			ver.oem = ST_OEM;
-			ver.build = ST_BUILD_VER;
-			ver.signature[0] = PASSTHRU_SIGNATURE;
-			ver.console_id = host->max_id - 1;
-			ver.host_no = hba->host->host_no;
 			cp_len = scsi_sg_copy_from_buffer(cmd, &ver, cp_len);
 			cmd->result = sizeof(ver) == cp_len ?
 				DID_OK << 16 | COMMAND_COMPLETE << 8 :
diff --git a/drivers/soc/qcom/smem_state.c b/drivers/soc/qcom/smem_state.c
index d5437ca76ed9..1502cf037a6b 100644
--- a/drivers/soc/qcom/smem_state.c
+++ b/drivers/soc/qcom/smem_state.c
@@ -144,6 +144,7 @@ static void qcom_smem_state_release(struct kref *ref)
 	struct qcom_smem_state *state = container_of(ref, struct qcom_smem_state, refcount);
 
 	list_del(&state->list);
+	of_node_put(state->of_node);
 	kfree(state);
 }
 
@@ -177,7 +178,7 @@ struct qcom_smem_state *qcom_smem_state_register(struct device_node *of_node,
 
 	kref_init(&state->refcount);
 
-	state->of_node = of_node;
+	state->of_node = of_node_get(of_node);
 	state->ops = *ops;
 	state->priv = priv;
 
diff --git a/drivers/soc/qcom/smsm.c b/drivers/soc/qcom/smsm.c
index 5304529b41c9..a8a1dc49519e 100644
--- a/drivers/soc/qcom/smsm.c
+++ b/drivers/soc/qcom/smsm.c
@@ -519,7 +519,7 @@ static int qcom_smsm_probe(struct platform_device *pdev)
 	for (id = 0; id < smsm->num_hosts; id++) {
 		ret = smsm_parse_ipc(smsm, id);
 		if (ret < 0)
-			return ret;
+			goto out_put;
 	}
 
 	/* Acquire the main SMSM state vector */
@@ -527,13 +527,14 @@ static int qcom_smsm_probe(struct platform_device *pdev)
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
@@ -541,13 +542,14 @@ static int qcom_smsm_probe(struct platform_device *pdev)
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
@@ -558,7 +560,8 @@ static int qcom_smsm_probe(struct platform_device *pdev)
 	smsm->state = qcom_smem_state_register(local_node, &smsm_state_ops, smsm);
 	if (IS_ERR(smsm->state)) {
 		dev_err(smsm->dev, "failed to register qcom_smem_state\n");
-		return PTR_ERR(smsm->state);
+		ret = PTR_ERR(smsm->state);
+		goto out_put;
 	}
 
 	/* Register handlers for remote processor entries of interest. */
@@ -588,16 +591,19 @@ static int qcom_smsm_probe(struct platform_device *pdev)
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
 
diff --git a/drivers/soc/sunxi/sunxi_sram.c b/drivers/soc/sunxi/sunxi_sram.c
index 882be5ed7e84..3a0396395e70 100644
--- a/drivers/soc/sunxi/sunxi_sram.c
+++ b/drivers/soc/sunxi/sunxi_sram.c
@@ -71,8 +71,8 @@ static struct sunxi_sram_desc sun4i_a10_sram_d = {
 
 static struct sunxi_sram_desc sun50i_a64_sram_c = {
 	.data	= SUNXI_SRAM_DATA("C", 0x4, 24, 1,
-				  SUNXI_SRAM_MAP(0, 1, "cpu"),
-				  SUNXI_SRAM_MAP(1, 0, "de2")),
+				  SUNXI_SRAM_MAP(1, 0, "cpu"),
+				  SUNXI_SRAM_MAP(0, 1, "de2")),
 };
 
 static const struct of_device_id sunxi_sram_dt_ids[] = {
@@ -253,6 +253,7 @@ int sunxi_sram_claim(struct device *dev)
 	writel(val | ((device << sram_data->offset) & mask),
 	       base + sram_data->reg);
 
+	sram_desc->claimed = true;
 	spin_unlock(&sram_lock);
 
 	return 0;
diff --git a/drivers/spi/spi-omap-100k.c b/drivers/spi/spi-omap-100k.c
index 2eeb0fe2eed2..022f5bccef81 100644
--- a/drivers/spi/spi-omap-100k.c
+++ b/drivers/spi/spi-omap-100k.c
@@ -425,6 +425,7 @@ static int omap1_spi100k_probe(struct platform_device *pdev)
 	return status;
 
 err_fck:
+	pm_runtime_disable(&pdev->dev);
 	clk_disable_unprepare(spi100k->fck);
 err_ick:
 	clk_disable_unprepare(spi100k->ick);
diff --git a/drivers/spi/spi-qup.c b/drivers/spi/spi-qup.c
index cb74fd1af205..1ca678bcb527 100644
--- a/drivers/spi/spi-qup.c
+++ b/drivers/spi/spi-qup.c
@@ -1172,8 +1172,10 @@ static int spi_qup_pm_resume_runtime(struct device *device)
 		return ret;
 
 	ret = clk_prepare_enable(controller->cclk);
-	if (ret)
+	if (ret) {
+		clk_disable_unprepare(controller->iclk);
 		return ret;
+	}
 
 	/* Disable clocks auto gaiting */
 	config = readl_relaxed(controller->base + QUP_CONFIG);
@@ -1219,14 +1221,25 @@ static int spi_qup_resume(struct device *device)
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
index 1a6ec226d6e4..0594e214a636 100644
--- a/drivers/spi/spi-s3c64xx.c
+++ b/drivers/spi/spi-s3c64xx.c
@@ -94,6 +94,7 @@
 #define S3C64XX_SPI_ST_TX_FIFORDY		(1<<0)
 
 #define S3C64XX_SPI_PACKET_CNT_EN		(1<<16)
+#define S3C64XX_SPI_PACKET_CNT_MASK		GENMASK(15, 0)
 
 #define S3C64XX_SPI_PND_TX_UNDERRUN_CLR		(1<<4)
 #define S3C64XX_SPI_PND_TX_OVERRUN_CLR		(1<<3)
@@ -640,6 +641,13 @@ static int s3c64xx_spi_prepare_message(struct spi_master *master,
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
@@ -1067,6 +1075,7 @@ static int s3c64xx_spi_probe(struct platform_device *pdev)
 	master->prepare_transfer_hardware = s3c64xx_spi_prepare_transfer;
 	master->prepare_message = s3c64xx_spi_prepare_message;
 	master->transfer_one = s3c64xx_spi_transfer_one;
+	master->max_transfer_size = s3c64xx_spi_max_transfer_size;
 	master->num_chipselect = sci->num_cs;
 	master->dma_alignment = 8;
 	master->bits_per_word_mask = SPI_BPW_MASK(32) | SPI_BPW_MASK(16) |
diff --git a/drivers/spmi/spmi-pmic-arb.c b/drivers/spmi/spmi-pmic-arb.c
index 360b8218f322..0eb156aa4975 100644
--- a/drivers/spmi/spmi-pmic-arb.c
+++ b/drivers/spmi/spmi-pmic-arb.c
@@ -867,7 +867,8 @@ static int pmic_arb_read_apid_map_v5(struct spmi_pmic_arb *pmic_arb)
 	 * version 5, there is more than one APID mapped to each PPID.
 	 * The owner field for each of these mappings specifies the EE which is
 	 * allowed to write to the APID.  The owner of the last (highest) APID
-	 * for a given PPID will receive interrupts from the PPID.
+	 * which has the IRQ owner bit set for a given PPID will receive
+	 * interrupts from the PPID.
 	 */
 	for (i = 0; ; i++, apidd++) {
 		offset = pmic_arb->ver_ops->apid_map_offset(i);
@@ -890,16 +891,16 @@ static int pmic_arb_read_apid_map_v5(struct spmi_pmic_arb *pmic_arb)
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
diff --git a/drivers/thermal/intel_powerclamp.c b/drivers/thermal/intel_powerclamp.c
index c3293fa2bb1b..68cc88637e06 100644
--- a/drivers/thermal/intel_powerclamp.c
+++ b/drivers/thermal/intel_powerclamp.c
@@ -549,9 +549,7 @@ static int start_power_clamp(void)
 	get_online_cpus();
 
 	/* prefer BSP */
-	control_cpu = 0;
-	if (!cpu_online(control_cpu))
-		control_cpu = smp_processor_id();
+	control_cpu = cpumask_first(cpu_online_mask);
 
 	clamping = true;
 	schedule_delayed_work(&poll_pkg_cstate_work, 0);
diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/8250/8250_port.c
index 5d614d645e81..def880039b30 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -3236,8 +3236,13 @@ static void serial8250_console_restore(struct uart_8250_port *up)
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
 	quot = serial8250_get_divisor(up, baud, &frac);
diff --git a/drivers/tty/serial/jsm/jsm_driver.c b/drivers/tty/serial/jsm/jsm_driver.c
index 102d499814ac..bd4efbbb7073 100644
--- a/drivers/tty/serial/jsm/jsm_driver.c
+++ b/drivers/tty/serial/jsm/jsm_driver.c
@@ -221,7 +221,8 @@ static int jsm_probe_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 		break;
 	default:
-		return -ENXIO;
+		rc = -ENXIO;
+		goto out_kfree_brd;
 	}
 
 	rc = request_irq(brd->irq, brd->bd_ops->intr, IRQF_SHARED, "JSM", brd);
diff --git a/drivers/tty/serial/xilinx_uartps.c b/drivers/tty/serial/xilinx_uartps.c
index cdd81c28893a..a04fbf83d123 100644
--- a/drivers/tty/serial/xilinx_uartps.c
+++ b/drivers/tty/serial/xilinx_uartps.c
@@ -369,6 +369,8 @@ static irqreturn_t cdns_uart_isr(int irq, void *dev_id)
 		isrstatus &= ~CDNS_UART_IXR_TXEMPTY;
 	}
 
+	isrstatus &= port->read_status_mask;
+	isrstatus &= ~port->ignore_status_mask;
 	/*
 	 * Skip RX processing if RX is disabled as RXEMPTY will never be set
 	 * as read bytes will not be removed from the FIFO.
diff --git a/drivers/usb/gadget/function/f_printer.c b/drivers/usb/gadget/function/f_printer.c
index 4e0afeabe8b8..830cc2bb0fdf 100644
--- a/drivers/usb/gadget/function/f_printer.c
+++ b/drivers/usb/gadget/function/f_printer.c
@@ -91,7 +91,7 @@ struct printer_dev {
 	u8			printer_cdev_open;
 	wait_queue_head_t	wait;
 	unsigned		q_len;
-	char			*pnp_string;	/* We don't own memory! */
+	char			**pnp_string;	/* We don't own memory! */
 	struct usb_function	function;
 };
 
@@ -967,16 +967,16 @@ static int printer_func_setup(struct usb_function *f,
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
@@ -1439,7 +1439,7 @@ static struct usb_function *gprinter_alloc(struct usb_function_instance *fi)
 	kref_init(&dev->kref);
 	++opts->refcnt;
 	dev->minor = opts->minor;
-	dev->pnp_string = opts->pnp_string;
+	dev->pnp_string = &opts->pnp_string;
 	dev->q_len = opts->q_len;
 	mutex_unlock(&opts->lock);
 
diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index e930e2777c87..ae724460c8f2 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -657,7 +657,7 @@ struct xhci_stream_info *xhci_alloc_stream_info(struct xhci_hcd *xhci,
 			num_stream_ctxs, &stream_info->ctx_array_dma,
 			mem_flags);
 	if (!stream_info->stream_ctx_array)
-		goto cleanup_ctx;
+		goto cleanup_ring_array;
 	memset(stream_info->stream_ctx_array, 0,
 			sizeof(struct xhci_stream_ctx)*num_stream_ctxs);
 
@@ -718,6 +718,11 @@ struct xhci_stream_info *xhci_alloc_stream_info(struct xhci_hcd *xhci,
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
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index c41548f08c54..0f2b67f38d2e 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -1094,7 +1094,8 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernated)
 	/* re-initialize the HC on Restore Error, or Host Controller Error */
 	if (temp & (STS_SRE | STS_HCE)) {
 		reinit_xhc = true;
-		xhci_warn(xhci, "xHC error in resume, USBSTS 0x%x, Reinit\n", temp);
+		if (!xhci->broken_suspend)
+			xhci_warn(xhci, "xHC error in resume, USBSTS 0x%x, Reinit\n", temp);
 	}
 
 	if (reinit_xhc) {
diff --git a/drivers/usb/misc/idmouse.c b/drivers/usb/misc/idmouse.c
index 01ef2551be46..974b8d0621bd 100644
--- a/drivers/usb/misc/idmouse.c
+++ b/drivers/usb/misc/idmouse.c
@@ -182,10 +182,6 @@ static int idmouse_create_image(struct usb_idmouse *dev)
 		bytes_read += bulk_read;
 	}
 
-	/* reset the device */
-reset:
-	ftip_command(dev, FTIP_RELEASE, 0, 0);
-
 	/* check for valid image */
 	/* right border should be black (0x00) */
 	for (bytes_read = sizeof(HEADER)-1 + WIDTH-1; bytes_read < IMGSIZE; bytes_read += WIDTH)
@@ -197,6 +193,10 @@ static int idmouse_create_image(struct usb_idmouse *dev)
 		if (dev->bulk_in_buffer[bytes_read] != 0xFF)
 			return -EAGAIN;
 
+	/* reset the device */
+reset:
+	ftip_command(dev, FTIP_RELEASE, 0, 0);
+
 	/* should be IMGSIZE == 65040 */
 	dev_dbg(&dev->interface->dev, "read %d bytes fingerprint data\n",
 		bytes_read);
diff --git a/drivers/usb/mon/mon_bin.c b/drivers/usb/mon/mon_bin.c
index 156aebf62e61..a6da9b72f46b 100644
--- a/drivers/usb/mon/mon_bin.c
+++ b/drivers/usb/mon/mon_bin.c
@@ -1267,6 +1267,11 @@ static int mon_bin_mmap(struct file *filp, struct vm_area_struct *vma)
 {
 	/* don't do anything here: "fault" will set up page table entries */
 	vma->vm_ops = &mon_bin_vm_ops;
+
+	if (vma->vm_flags & VM_WRITE)
+		return -EPERM;
+
+	vma->vm_flags &= ~VM_MAYWRITE;
 	vma->vm_flags |= VM_DONTEXPAND | VM_DONTDUMP;
 	vma->vm_private_data = filp->private_data;
 	mon_bin_vma_open(vma);
diff --git a/drivers/usb/musb/musb_gadget.c b/drivers/usb/musb/musb_gadget.c
index 319c5a1b4a6a..8fd68f45a8df 100644
--- a/drivers/usb/musb/musb_gadget.c
+++ b/drivers/usb/musb/musb_gadget.c
@@ -785,6 +785,9 @@ static void rxstate(struct musb *musb, struct musb_request *req)
 			musb_writew(epio, MUSB_RXCSR, csr);
 
 buffer_aint_mapped:
+			fifo_count = min_t(unsigned int,
+					request->length - request->actual,
+					(unsigned int)fifo_count);
 			musb_read_fifo(musb_ep->hw_ep, fifo_count, (u8 *)
 					(request->buf + request->actual));
 			request->actual += fifo_count;
diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 48a6840a3f55..93b046c7409c 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1309,8 +1309,7 @@ static __u32 get_ftdi_divisor(struct tty_struct *tty,
 		case 38400: div_value = ftdi_sio_b38400; break;
 		case 57600: div_value = ftdi_sio_b57600;  break;
 		case 115200: div_value = ftdi_sio_b115200; break;
-		} /* baud */
-		if (div_value == 0) {
+		default:
 			dev_dbg(dev, "%s - Baudrate (%d) requested is not supported\n",
 				__func__,  baud);
 			div_value = ftdi_sio_b9600;
diff --git a/drivers/usb/serial/qcserial.c b/drivers/usb/serial/qcserial.c
index f926a0b0b133..6ea6cbbebfba 100644
--- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -181,6 +181,7 @@ static const struct usb_device_id id_table[] = {
 	{DEVICE_SWI(0x413c, 0x81b3)},	/* Dell Wireless 5809e Gobi(TM) 4G LTE Mobile Broadband Card (rev3) */
 	{DEVICE_SWI(0x413c, 0x81b5)},	/* Dell Wireless 5811e QDL */
 	{DEVICE_SWI(0x413c, 0x81b6)},	/* Dell Wireless 5811e QDL */
+	{DEVICE_SWI(0x413c, 0x81c2)},	/* Dell Wireless 5811e */
 	{DEVICE_SWI(0x413c, 0x81cb)},	/* Dell Wireless 5816e QDL */
 	{DEVICE_SWI(0x413c, 0x81cc)},	/* Dell Wireless 5816e */
 	{DEVICE_SWI(0x413c, 0x81cf)},   /* Dell Wireless 5819 */
diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
index 8c186ab5b5f7..8b38dd7d89b7 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -1294,12 +1294,6 @@ UNUSUAL_DEV( 0x090a, 0x1200, 0x0000, 0x9999,
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
diff --git a/drivers/usb/storage/unusual_uas.h b/drivers/usb/storage/unusual_uas.h
index 1effff26a2a6..414ef2533e27 100644
--- a/drivers/usb/storage/unusual_uas.h
+++ b/drivers/usb/storage/unusual_uas.h
@@ -65,6 +65,13 @@ UNUSUAL_DEV(0x059f, 0x1061, 0x0000, 0x9999,
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_NO_REPORT_OPCODES | US_FL_NO_SAME),
 
+/* Reported-by: Hongling Zeng <zenghongling@kylinos.cn> */
+UNUSUAL_DEV(0x090c, 0x2000, 0x0000, 0x9999,
+		"Hiksemi",
+		"External HDD",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_IGNORE_UAS),
+
 /*
  * Apricorn USB3 dongle sometimes returns "USBSUSBSUSBS" in response to SCSI
  * commands in UAS mode.  Observed with the 1.28 firmware; are there others?
@@ -145,6 +152,13 @@ UNUSUAL_DEV(0x0bc2, 0xab2a, 0x0000, 0x9999,
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_NO_ATA_1X),
 
+/* Reported-by: Hongling Zeng <zenghongling@kylinos.cn> */
+UNUSUAL_DEV(0x0bda, 0x9210, 0x0000, 0x9999,
+		"Hiksemi",
+		"External HDD",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_IGNORE_UAS),
+
 /* Reported-by: Benjamin Tissoires <benjamin.tissoires@redhat.com> */
 UNUSUAL_DEV(0x13fd, 0x3940, 0x0000, 0x9999,
 		"Initio Corporation",
@@ -187,6 +201,13 @@ UNUSUAL_DEV(0x154b, 0xf00d, 0x0000, 0x9999,
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_NO_ATA_1X),
 
+/* Reported-by: Hongling Zeng <zenghongling@kylinos.cn> */
+UNUSUAL_DEV(0x17ef, 0x3899, 0x0000, 0x9999,
+		"Thinkplus",
+		"External HDD",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_IGNORE_UAS),
+
 /* Reported-by: Hans de Goede <hdegoede@redhat.com> */
 UNUSUAL_DEV(0x2109, 0x0711, 0x0000, 0x9999,
 		"VIA",
diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index c87072217dc0..35f2fbc160a5 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -354,7 +354,7 @@ vhost_vsock_alloc_pkt(struct vhost_virtqueue *vq,
 		return NULL;
 	}
 
-	pkt->buf = kmalloc(pkt->len, GFP_KERNEL);
+	pkt->buf = kvmalloc(pkt->len, GFP_KERNEL);
 	if (!pkt->buf) {
 		kfree(pkt);
 		return NULL;
diff --git a/drivers/video/fbdev/smscufx.c b/drivers/video/fbdev/smscufx.c
index 1b244bea24b8..6f7820b236f4 100644
--- a/drivers/video/fbdev/smscufx.c
+++ b/drivers/video/fbdev/smscufx.c
@@ -140,6 +140,8 @@ static int ufx_submit_urb(struct ufx_data *dev, struct urb * urb, size_t len);
 static int ufx_alloc_urb_list(struct ufx_data *dev, int count, size_t size);
 static void ufx_free_urb_list(struct ufx_data *dev);
 
+static DEFINE_MUTEX(disconnect_mutex);
+
 /* reads a control register */
 static int ufx_reg_read(struct ufx_data *dev, u32 index, u32 *data)
 {
@@ -1073,9 +1075,13 @@ static int ufx_ops_open(struct fb_info *info, int user)
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
 
@@ -1100,6 +1106,8 @@ static int ufx_ops_open(struct fb_info *info, int user)
 	pr_debug("open /dev/fb%d user=%d fb_info=%p count=%d",
 		info->node, user, info, dev->fb_count);
 
+	mutex_unlock(&disconnect_mutex);
+
 	return 0;
 }
 
@@ -1762,6 +1770,8 @@ static void ufx_usb_disconnect(struct usb_interface *interface)
 {
 	struct ufx_data *dev;
 
+	mutex_lock(&disconnect_mutex);
+
 	dev = usb_get_intfdata(interface);
 
 	pr_debug("USB disconnect starting\n");
@@ -1782,6 +1792,8 @@ static void ufx_usb_disconnect(struct usb_interface *interface)
 	kref_put(&dev->kref, ufx_free);
 
 	/* consider ufx_data freed */
+
+	mutex_unlock(&disconnect_mutex);
 }
 
 static struct usb_driver ufx_driver = {
diff --git a/drivers/video/fbdev/stifb.c b/drivers/video/fbdev/stifb.c
index 6ded5c198998..2ff39a8d2923 100644
--- a/drivers/video/fbdev/stifb.c
+++ b/drivers/video/fbdev/stifb.c
@@ -1259,7 +1259,7 @@ static int __init stifb_init_fb(struct sti_struct *sti, int bpp_pref)
 	
 	/* limit fbsize to max visible screen size */
 	if (fix->smem_len > yres*fix->line_length)
-		fix->smem_len = yres*fix->line_length;
+		fix->smem_len = ALIGN(yres*fix->line_length, 4*1024*1024);
 	
 	fix->accel = FB_ACCEL_NONE;
 
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 1f873034f469..ddfa6ce3a0fb 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -381,6 +381,12 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 	if (dentry->d_name.len > NAME_MAX)
 		return -ENAMETOOLONG;
 
+	/*
+	 * Do not truncate the file, since atomic_open is called before the
+	 * permission check. The caller will do the truncation afterward.
+	 */
+	flags &= ~O_TRUNC;
+
 	if (flags & O_CREAT) {
 		err = ceph_pre_init_acls(dir, &mode, &acls);
 		if (err < 0)
@@ -411,9 +417,7 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 
 	req->r_parent = dir;
 	set_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
-	err = ceph_mdsc_do_request(mdsc,
-				   (flags & (O_CREAT|O_TRUNC)) ? dir : NULL,
-				   req);
+	err = ceph_mdsc_do_request(mdsc, (flags & O_CREAT) ? dir : NULL, req);
 	err = ceph_handle_snapdir(req, dentry, err);
 	if (err)
 		goto out_req;
diff --git a/fs/dlm/ast.c b/fs/dlm/ast.c
index 15fa4239ae9f..e82d9ad33b41 100644
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
index 73e1eeee4743..58b3ea271895 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -2887,24 +2887,24 @@ static int set_unlock_args(uint32_t flags, void *astarg, struct dlm_args *args)
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
 
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index acec134da57d..de33fa38f6ba 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -588,6 +588,12 @@ static loff_t ext4_seek_data(struct file *file, loff_t offset, loff_t maxsize)
 		inode_unlock(inode);
 		return -ENXIO;
 	}
+	/*
+	 * Make sure inline data cannot be created anymore since we are going
+	 * to allocate blocks for DIO. We know the inode does not have any
+	 * inline data now because ext4_dio_supported() checked for that.
+	 */
+	ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
 
 	blkbits = inode->i_sb->s_blocksize_bits;
 	start = offset >> blkbits;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index ccbeba71932e..175af0591d3d 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1309,6 +1309,13 @@ static int ext4_write_begin(struct file *file, struct address_space *mapping,
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
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 30b2798244fa..b7a64709791a 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -2062,7 +2062,7 @@ int ext4_resize_fs(struct super_block *sb, ext4_fsblk_t n_blocks_count)
 			goto out;
 	}
 
-	if (ext4_blocks_count(es) == n_blocks_count)
+	if (ext4_blocks_count(es) == n_blocks_count && n_blocks_count_retry == 0)
 		goto out;
 
 	err = ext4_alloc_flex_bg_array(sb, n_group + 1);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 88cf7093927e..aab39d10b29c 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3037,6 +3037,7 @@ static int ext4_lazyinit_thread(void *arg)
 	unsigned long next_wakeup, cur;
 
 	BUG_ON(NULL == eli);
+	set_freezable();
 
 cont_thread:
 	while (true) {
@@ -5601,7 +5602,7 @@ static int ext4_write_info(struct super_block *sb, int type)
 	handle_t *handle;
 
 	/* Data block + inode block */
-	handle = ext4_journal_start(d_inode(sb->s_root), EXT4_HT_QUOTA, 2);
+	handle = ext4_journal_start_sb(sb, EXT4_HT_QUOTA, 2);
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
 	ret = dquot_commit_info(sb, type);
diff --git a/fs/f2fs/extent_cache.c b/fs/f2fs/extent_cache.c
index aff6c2ed1c02..042c9d4f73cf 100644
--- a/fs/f2fs/extent_cache.c
+++ b/fs/f2fs/extent_cache.c
@@ -709,9 +709,8 @@ void f2fs_drop_extent_tree(struct inode *inode)
 	if (!f2fs_may_extent_tree(inode))
 		return;
 
-	set_inode_flag(inode, FI_NO_EXTENT);
-
 	write_lock(&et->lock);
+	set_inode_flag(inode, FI_NO_EXTENT);
 	__free_extent_tree(sbi, et);
 	__drop_largest_extent(inode, 0, UINT_MAX);
 	write_unlock(&et->lock);
diff --git a/fs/inode.c b/fs/inode.c
index 17172b616d22..05932ab6f95b 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -165,8 +165,6 @@ int inode_init_always(struct super_block *sb, struct inode *inode)
 	inode->i_wb_frn_history = 0;
 #endif
 
-	if (security_inode_alloc(inode))
-		goto out;
 	spin_lock_init(&inode->i_lock);
 	lockdep_set_class(&inode->i_lock, &sb->s_type->i_lock_key);
 
@@ -194,11 +192,12 @@ int inode_init_always(struct super_block *sb, struct inode *inode)
 	inode->i_fsnotify_mask = 0;
 #endif
 	inode->i_flctx = NULL;
+
+	if (unlikely(security_inode_alloc(inode)))
+		return -ENOMEM;
 	this_cpu_inc(nr_inodes);
 
 	return 0;
-out:
-	return -ENOMEM;
 }
 EXPORT_SYMBOL(inode_init_always);
 
diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 2e7349b2dd4d..c5c10b7dc63e 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -3550,7 +3550,7 @@ nfsd4_encode_read(struct nfsd4_compoundres *resp, __be32 nfserr,
 	if (resp->xdr.buf->page_len &&
 	    test_bit(RQ_SPLICE_OK, &resp->rqstp->rq_flags)) {
 		WARN_ON_ONCE(1);
-		return nfserr_resource;
+		return nfserr_serverfault;
 	}
 	xdr_commit_encode(xdr);
 
diff --git a/fs/nilfs2/btnode.c b/fs/nilfs2/btnode.c
index c21e0b4454a6..abee814d2506 100644
--- a/fs/nilfs2/btnode.c
+++ b/fs/nilfs2/btnode.c
@@ -29,6 +29,23 @@
 #include "page.h"
 #include "btnode.h"
 
+
+/**
+ * nilfs_init_btnc_inode - initialize B-tree node cache inode
+ * @btnc_inode: inode to be initialized
+ *
+ * nilfs_init_btnc_inode() sets up an inode for B-tree node cache.
+ */
+void nilfs_init_btnc_inode(struct inode *btnc_inode)
+{
+	struct nilfs_inode_info *ii = NILFS_I(btnc_inode);
+
+	btnc_inode->i_mode = S_IFREG;
+	ii->i_flags = 0;
+	memset(&ii->i_bmap_data, 0, sizeof(struct nilfs_bmap));
+	mapping_set_gfp_mask(btnc_inode->i_mapping, GFP_NOFS);
+}
+
 void nilfs_btnode_cache_clear(struct address_space *btnc)
 {
 	invalidate_mapping_pages(btnc, 0, -1);
@@ -38,7 +55,7 @@ void nilfs_btnode_cache_clear(struct address_space *btnc)
 struct buffer_head *
 nilfs_btnode_create_block(struct address_space *btnc, __u64 blocknr)
 {
-	struct inode *inode = NILFS_BTNC_I(btnc);
+	struct inode *inode = btnc->host;
 	struct buffer_head *bh;
 
 	bh = nilfs_grab_buffer(inode, btnc, blocknr, BIT(BH_NILFS_Node));
@@ -66,7 +83,7 @@ int nilfs_btnode_submit_block(struct address_space *btnc, __u64 blocknr,
 			      struct buffer_head **pbh, sector_t *submit_ptr)
 {
 	struct buffer_head *bh;
-	struct inode *inode = NILFS_BTNC_I(btnc);
+	struct inode *inode = btnc->host;
 	struct page *page;
 	int err;
 
@@ -166,7 +183,7 @@ int nilfs_btnode_prepare_change_key(struct address_space *btnc,
 				    struct nilfs_btnode_chkey_ctxt *ctxt)
 {
 	struct buffer_head *obh, *nbh;
-	struct inode *inode = NILFS_BTNC_I(btnc);
+	struct inode *inode = btnc->host;
 	__u64 oldkey = ctxt->oldkey, newkey = ctxt->newkey;
 	int err;
 
diff --git a/fs/nilfs2/btnode.h b/fs/nilfs2/btnode.h
index 4e8aaa1aeb65..1f78b637715d 100644
--- a/fs/nilfs2/btnode.h
+++ b/fs/nilfs2/btnode.h
@@ -39,6 +39,7 @@ struct nilfs_btnode_chkey_ctxt {
 	struct buffer_head *newbh;
 };
 
+void nilfs_init_btnc_inode(struct inode *btnc_inode);
 void nilfs_btnode_cache_clear(struct address_space *);
 struct buffer_head *nilfs_btnode_create_block(struct address_space *btnc,
 					      __u64 blocknr);
diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index 06ffa135dfa6..6a58e6d6a24b 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -67,7 +67,8 @@ static void nilfs_btree_free_path(struct nilfs_btree_path *path)
 static int nilfs_btree_get_new_block(const struct nilfs_bmap *btree,
 				     __u64 ptr, struct buffer_head **bhp)
 {
-	struct address_space *btnc = &NILFS_BMAP_I(btree)->i_btnode_cache;
+	struct inode *btnc_inode = NILFS_BMAP_I(btree)->i_assoc_inode;
+	struct address_space *btnc = btnc_inode->i_mapping;
 	struct buffer_head *bh;
 
 	bh = nilfs_btnode_create_block(btnc, ptr);
@@ -479,7 +480,8 @@ static int __nilfs_btree_get_block(const struct nilfs_bmap *btree, __u64 ptr,
 				   struct buffer_head **bhp,
 				   const struct nilfs_btree_readahead_info *ra)
 {
-	struct address_space *btnc = &NILFS_BMAP_I(btree)->i_btnode_cache;
+	struct inode *btnc_inode = NILFS_BMAP_I(btree)->i_assoc_inode;
+	struct address_space *btnc = btnc_inode->i_mapping;
 	struct buffer_head *bh, *ra_bh;
 	sector_t submit_ptr = 0;
 	int ret;
@@ -1751,6 +1753,10 @@ nilfs_btree_prepare_convert_and_insert(struct nilfs_bmap *btree, __u64 key,
 		dat = nilfs_bmap_get_dat(btree);
 	}
 
+	ret = nilfs_attach_btree_node_cache(&NILFS_BMAP_I(btree)->vfs_inode);
+	if (ret < 0)
+		return ret;
+
 	ret = nilfs_bmap_prepare_alloc_ptr(btree, dreq, dat);
 	if (ret < 0)
 		return ret;
@@ -1923,7 +1929,7 @@ static int nilfs_btree_prepare_update_v(struct nilfs_bmap *btree,
 		path[level].bp_ctxt.newkey = path[level].bp_newreq.bpr_ptr;
 		path[level].bp_ctxt.bh = path[level].bp_bh;
 		ret = nilfs_btnode_prepare_change_key(
-			&NILFS_BMAP_I(btree)->i_btnode_cache,
+			NILFS_BMAP_I(btree)->i_assoc_inode->i_mapping,
 			&path[level].bp_ctxt);
 		if (ret < 0) {
 			nilfs_dat_abort_update(dat,
@@ -1949,7 +1955,7 @@ static void nilfs_btree_commit_update_v(struct nilfs_bmap *btree,
 
 	if (buffer_nilfs_node(path[level].bp_bh)) {
 		nilfs_btnode_commit_change_key(
-			&NILFS_BMAP_I(btree)->i_btnode_cache,
+			NILFS_BMAP_I(btree)->i_assoc_inode->i_mapping,
 			&path[level].bp_ctxt);
 		path[level].bp_bh = path[level].bp_ctxt.bh;
 	}
@@ -1968,7 +1974,7 @@ static void nilfs_btree_abort_update_v(struct nilfs_bmap *btree,
 			       &path[level].bp_newreq.bpr_req);
 	if (buffer_nilfs_node(path[level].bp_bh))
 		nilfs_btnode_abort_change_key(
-			&NILFS_BMAP_I(btree)->i_btnode_cache,
+			NILFS_BMAP_I(btree)->i_assoc_inode->i_mapping,
 			&path[level].bp_ctxt);
 }
 
@@ -2144,7 +2150,8 @@ static void nilfs_btree_add_dirty_buffer(struct nilfs_bmap *btree,
 static void nilfs_btree_lookup_dirty_buffers(struct nilfs_bmap *btree,
 					     struct list_head *listp)
 {
-	struct address_space *btcache = &NILFS_BMAP_I(btree)->i_btnode_cache;
+	struct inode *btnc_inode = NILFS_BMAP_I(btree)->i_assoc_inode;
+	struct address_space *btcache = btnc_inode->i_mapping;
 	struct list_head lists[NILFS_BTREE_LEVEL_MAX];
 	struct pagevec pvec;
 	struct buffer_head *bh, *head;
@@ -2198,12 +2205,12 @@ static int nilfs_btree_assign_p(struct nilfs_bmap *btree,
 		path[level].bp_ctxt.newkey = blocknr;
 		path[level].bp_ctxt.bh = *bh;
 		ret = nilfs_btnode_prepare_change_key(
-			&NILFS_BMAP_I(btree)->i_btnode_cache,
+			NILFS_BMAP_I(btree)->i_assoc_inode->i_mapping,
 			&path[level].bp_ctxt);
 		if (ret < 0)
 			return ret;
 		nilfs_btnode_commit_change_key(
-			&NILFS_BMAP_I(btree)->i_btnode_cache,
+			NILFS_BMAP_I(btree)->i_assoc_inode->i_mapping,
 			&path[level].bp_ctxt);
 		*bh = path[level].bp_ctxt.bh;
 	}
@@ -2408,6 +2415,10 @@ int nilfs_btree_init(struct nilfs_bmap *bmap)
 
 	if (nilfs_btree_root_broken(nilfs_btree_get_root(bmap), bmap->b_inode))
 		ret = -EIO;
+	else
+		ret = nilfs_attach_btree_node_cache(
+			&NILFS_BMAP_I(bmap)->vfs_inode);
+
 	return ret;
 }
 
diff --git a/fs/nilfs2/dat.c b/fs/nilfs2/dat.c
index dffedb2f8817..524f13bc47b2 100644
--- a/fs/nilfs2/dat.c
+++ b/fs/nilfs2/dat.c
@@ -506,7 +506,9 @@ int nilfs_dat_read(struct super_block *sb, size_t entry_size,
 	di = NILFS_DAT_I(dat);
 	lockdep_set_class(&di->mi.mi_sem, &dat_lock_key);
 	nilfs_palloc_setup_cache(dat, &di->palloc_cache);
-	nilfs_mdt_setup_shadow_map(dat, &di->shadow);
+	err = nilfs_mdt_setup_shadow_map(dat, &di->shadow);
+	if (err)
+		goto failed;
 
 	err = nilfs_read_inode_common(dat, raw_inode);
 	if (err)
diff --git a/fs/nilfs2/gcinode.c b/fs/nilfs2/gcinode.c
index 853a831dcde0..1bbd0f50ce9d 100644
--- a/fs/nilfs2/gcinode.c
+++ b/fs/nilfs2/gcinode.c
@@ -135,9 +135,10 @@ int nilfs_gccache_submit_read_data(struct inode *inode, sector_t blkoff,
 int nilfs_gccache_submit_read_node(struct inode *inode, sector_t pbn,
 				   __u64 vbn, struct buffer_head **out_bh)
 {
+	struct inode *btnc_inode = NILFS_I(inode)->i_assoc_inode;
 	int ret;
 
-	ret = nilfs_btnode_submit_block(&NILFS_I(inode)->i_btnode_cache,
+	ret = nilfs_btnode_submit_block(btnc_inode->i_mapping,
 					vbn ? : pbn, pbn, REQ_OP_READ, 0,
 					out_bh, &pbn);
 	if (ret == -EEXIST) /* internal code (cache hit) */
@@ -179,7 +180,7 @@ int nilfs_init_gcinode(struct inode *inode)
 	ii->i_flags = 0;
 	nilfs_bmap_init_gc(ii->i_bmap);
 
-	return 0;
+	return nilfs_attach_btree_node_cache(inode);
 }
 
 /**
@@ -194,7 +195,7 @@ void nilfs_remove_all_gcinodes(struct the_nilfs *nilfs)
 		ii = list_first_entry(head, struct nilfs_inode_info, i_dirty);
 		list_del_init(&ii->i_dirty);
 		truncate_inode_pages(&ii->vfs_inode.i_data, 0);
-		nilfs_btnode_cache_clear(&ii->i_btnode_cache);
+		nilfs_btnode_cache_clear(ii->i_assoc_inode->i_mapping);
 		iput(&ii->vfs_inode);
 	}
 }
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 6a612d832e7d..39ef2d336265 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -37,12 +37,16 @@
  * @cno: checkpoint number
  * @root: pointer on NILFS root object (mounted checkpoint)
  * @for_gc: inode for GC flag
+ * @for_btnc: inode for B-tree node cache flag
+ * @for_shadow: inode for shadowed page cache flag
  */
 struct nilfs_iget_args {
 	u64 ino;
 	__u64 cno;
 	struct nilfs_root *root;
-	int for_gc;
+	bool for_gc;
+	bool for_btnc;
+	bool for_shadow;
 };
 
 static int nilfs_iget_test(struct inode *inode, void *opaque);
@@ -331,7 +335,8 @@ static int nilfs_insert_inode_locked(struct inode *inode,
 				     unsigned long ino)
 {
 	struct nilfs_iget_args args = {
-		.ino = ino, .root = root, .cno = 0, .for_gc = 0
+		.ino = ino, .root = root, .cno = 0, .for_gc = false,
+		.for_btnc = false, .for_shadow = false
 	};
 
 	return insert_inode_locked4(inode, ino, nilfs_iget_test, &args);
@@ -344,6 +349,7 @@ struct inode *nilfs_new_inode(struct inode *dir, umode_t mode)
 	struct inode *inode;
 	struct nilfs_inode_info *ii;
 	struct nilfs_root *root;
+	struct buffer_head *bh;
 	int err = -ENOMEM;
 	ino_t ino;
 
@@ -359,11 +365,26 @@ struct inode *nilfs_new_inode(struct inode *dir, umode_t mode)
 	ii->i_state = BIT(NILFS_I_NEW);
 	ii->i_root = root;
 
-	err = nilfs_ifile_create_inode(root->ifile, &ino, &ii->i_bh);
+	err = nilfs_ifile_create_inode(root->ifile, &ino, &bh);
 	if (unlikely(err))
 		goto failed_ifile_create_inode;
 	/* reference count of i_bh inherits from nilfs_mdt_read_block() */
 
+	if (unlikely(ino < NILFS_USER_INO)) {
+		nilfs_msg(sb, KERN_WARNING,
+			  "inode bitmap is inconsistent for reserved inodes");
+		do {
+			brelse(bh);
+			err = nilfs_ifile_create_inode(root->ifile, &ino, &bh);
+			if (unlikely(err))
+				goto failed_ifile_create_inode;
+		} while (ino < NILFS_USER_INO);
+
+		nilfs_msg(sb, KERN_INFO,
+			  "repaired inode bitmap for reserved inodes");
+	}
+	ii->i_bh = bh;
+
 	atomic64_inc(&root->inodes_count);
 	inode_init_owner(inode, dir, mode);
 	inode->i_ino = ino;
@@ -455,6 +476,8 @@ int nilfs_read_inode_common(struct inode *inode,
 	inode->i_atime.tv_nsec = le32_to_cpu(raw_inode->i_mtime_nsec);
 	inode->i_ctime.tv_nsec = le32_to_cpu(raw_inode->i_ctime_nsec);
 	inode->i_mtime.tv_nsec = le32_to_cpu(raw_inode->i_mtime_nsec);
+	if (nilfs_is_metadata_file_inode(inode) && !S_ISREG(inode->i_mode))
+		return -EIO; /* this inode is for metadata and corrupted */
 	if (inode->i_nlink == 0)
 		return -ESTALE; /* this inode is deleted */
 
@@ -543,6 +566,19 @@ static int nilfs_iget_test(struct inode *inode, void *opaque)
 		return 0;
 
 	ii = NILFS_I(inode);
+	if (test_bit(NILFS_I_BTNC, &ii->i_state)) {
+		if (!args->for_btnc)
+			return 0;
+	} else if (args->for_btnc) {
+		return 0;
+	}
+	if (test_bit(NILFS_I_SHADOW, &ii->i_state)) {
+		if (!args->for_shadow)
+			return 0;
+	} else if (args->for_shadow) {
+		return 0;
+	}
+
 	if (!test_bit(NILFS_I_GCINODE, &ii->i_state))
 		return !args->for_gc;
 
@@ -554,15 +590,17 @@ static int nilfs_iget_set(struct inode *inode, void *opaque)
 	struct nilfs_iget_args *args = opaque;
 
 	inode->i_ino = args->ino;
-	if (args->for_gc) {
+	NILFS_I(inode)->i_cno = args->cno;
+	NILFS_I(inode)->i_root = args->root;
+	if (args->root && args->ino == NILFS_ROOT_INO)
+		nilfs_get_root(args->root);
+
+	if (args->for_gc)
 		NILFS_I(inode)->i_state = BIT(NILFS_I_GCINODE);
-		NILFS_I(inode)->i_cno = args->cno;
-		NILFS_I(inode)->i_root = NULL;
-	} else {
-		if (args->root && args->ino == NILFS_ROOT_INO)
-			nilfs_get_root(args->root);
-		NILFS_I(inode)->i_root = args->root;
-	}
+	if (args->for_btnc)
+		NILFS_I(inode)->i_state |= BIT(NILFS_I_BTNC);
+	if (args->for_shadow)
+		NILFS_I(inode)->i_state |= BIT(NILFS_I_SHADOW);
 	return 0;
 }
 
@@ -570,7 +608,8 @@ struct inode *nilfs_ilookup(struct super_block *sb, struct nilfs_root *root,
 			    unsigned long ino)
 {
 	struct nilfs_iget_args args = {
-		.ino = ino, .root = root, .cno = 0, .for_gc = 0
+		.ino = ino, .root = root, .cno = 0, .for_gc = false,
+		.for_btnc = false, .for_shadow = false
 	};
 
 	return ilookup5(sb, ino, nilfs_iget_test, &args);
@@ -580,7 +619,8 @@ struct inode *nilfs_iget_locked(struct super_block *sb, struct nilfs_root *root,
 				unsigned long ino)
 {
 	struct nilfs_iget_args args = {
-		.ino = ino, .root = root, .cno = 0, .for_gc = 0
+		.ino = ino, .root = root, .cno = 0, .for_gc = false,
+		.for_btnc = false, .for_shadow = false
 	};
 
 	return iget5_locked(sb, ino, nilfs_iget_test, nilfs_iget_set, &args);
@@ -611,7 +651,8 @@ struct inode *nilfs_iget_for_gc(struct super_block *sb, unsigned long ino,
 				__u64 cno)
 {
 	struct nilfs_iget_args args = {
-		.ino = ino, .root = NULL, .cno = cno, .for_gc = 1
+		.ino = ino, .root = NULL, .cno = cno, .for_gc = true,
+		.for_btnc = false, .for_shadow = false
 	};
 	struct inode *inode;
 	int err;
@@ -631,6 +672,113 @@ struct inode *nilfs_iget_for_gc(struct super_block *sb, unsigned long ino,
 	return inode;
 }
 
+/**
+ * nilfs_attach_btree_node_cache - attach a B-tree node cache to the inode
+ * @inode: inode object
+ *
+ * nilfs_attach_btree_node_cache() attaches a B-tree node cache to @inode,
+ * or does nothing if the inode already has it.  This function allocates
+ * an additional inode to maintain page cache of B-tree nodes one-on-one.
+ *
+ * Return Value: On success, 0 is returned. On errors, one of the following
+ * negative error code is returned.
+ *
+ * %-ENOMEM - Insufficient memory available.
+ */
+int nilfs_attach_btree_node_cache(struct inode *inode)
+{
+	struct nilfs_inode_info *ii = NILFS_I(inode);
+	struct inode *btnc_inode;
+	struct nilfs_iget_args args;
+
+	if (ii->i_assoc_inode)
+		return 0;
+
+	args.ino = inode->i_ino;
+	args.root = ii->i_root;
+	args.cno = ii->i_cno;
+	args.for_gc = test_bit(NILFS_I_GCINODE, &ii->i_state) != 0;
+	args.for_btnc = true;
+	args.for_shadow = test_bit(NILFS_I_SHADOW, &ii->i_state) != 0;
+
+	btnc_inode = iget5_locked(inode->i_sb, inode->i_ino, nilfs_iget_test,
+				  nilfs_iget_set, &args);
+	if (unlikely(!btnc_inode))
+		return -ENOMEM;
+	if (btnc_inode->i_state & I_NEW) {
+		nilfs_init_btnc_inode(btnc_inode);
+		unlock_new_inode(btnc_inode);
+	}
+	NILFS_I(btnc_inode)->i_assoc_inode = inode;
+	NILFS_I(btnc_inode)->i_bmap = ii->i_bmap;
+	ii->i_assoc_inode = btnc_inode;
+
+	return 0;
+}
+
+/**
+ * nilfs_detach_btree_node_cache - detach the B-tree node cache from the inode
+ * @inode: inode object
+ *
+ * nilfs_detach_btree_node_cache() detaches the B-tree node cache and its
+ * holder inode bound to @inode, or does nothing if @inode doesn't have it.
+ */
+void nilfs_detach_btree_node_cache(struct inode *inode)
+{
+	struct nilfs_inode_info *ii = NILFS_I(inode);
+	struct inode *btnc_inode = ii->i_assoc_inode;
+
+	if (btnc_inode) {
+		NILFS_I(btnc_inode)->i_assoc_inode = NULL;
+		ii->i_assoc_inode = NULL;
+		iput(btnc_inode);
+	}
+}
+
+/**
+ * nilfs_iget_for_shadow - obtain inode for shadow mapping
+ * @inode: inode object that uses shadow mapping
+ *
+ * nilfs_iget_for_shadow() allocates a pair of inodes that holds page
+ * caches for shadow mapping.  The page cache for data pages is set up
+ * in one inode and the one for b-tree node pages is set up in the
+ * other inode, which is attached to the former inode.
+ *
+ * Return Value: On success, a pointer to the inode for data pages is
+ * returned. On errors, one of the following negative error code is returned
+ * in a pointer type.
+ *
+ * %-ENOMEM - Insufficient memory available.
+ */
+struct inode *nilfs_iget_for_shadow(struct inode *inode)
+{
+	struct nilfs_iget_args args = {
+		.ino = inode->i_ino, .root = NULL, .cno = 0, .for_gc = false,
+		.for_btnc = false, .for_shadow = true
+	};
+	struct inode *s_inode;
+	int err;
+
+	s_inode = iget5_locked(inode->i_sb, inode->i_ino, nilfs_iget_test,
+			       nilfs_iget_set, &args);
+	if (unlikely(!s_inode))
+		return ERR_PTR(-ENOMEM);
+	if (!(s_inode->i_state & I_NEW))
+		return inode;
+
+	NILFS_I(s_inode)->i_flags = 0;
+	memset(NILFS_I(s_inode)->i_bmap, 0, sizeof(struct nilfs_bmap));
+	mapping_set_gfp_mask(s_inode->i_mapping, GFP_NOFS);
+
+	err = nilfs_attach_btree_node_cache(s_inode);
+	if (unlikely(err)) {
+		iget_failed(s_inode);
+		return ERR_PTR(err);
+	}
+	unlock_new_inode(s_inode);
+	return s_inode;
+}
+
 void nilfs_write_inode_common(struct inode *inode,
 			      struct nilfs_inode *raw_inode, int has_bmap)
 {
@@ -779,7 +927,8 @@ static void nilfs_clear_inode(struct inode *inode)
 	if (test_bit(NILFS_I_BMAP, &ii->i_state))
 		nilfs_bmap_clear(ii->i_bmap);
 
-	nilfs_btnode_cache_clear(&ii->i_btnode_cache);
+	if (!test_bit(NILFS_I_BTNC, &ii->i_state))
+		nilfs_detach_btree_node_cache(inode);
 
 	if (ii->i_root && inode->i_ino == NILFS_ROOT_INO)
 		nilfs_put_root(ii->i_root);
diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
index c6bc1033e7d2..52763f8a8836 100644
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -478,9 +478,18 @@ int nilfs_mdt_init(struct inode *inode, gfp_t gfp_mask, size_t objsz)
 void nilfs_mdt_clear(struct inode *inode)
 {
 	struct nilfs_mdt_info *mdi = NILFS_MDT(inode);
+	struct nilfs_shadow_map *shadow = mdi->mi_shadow;
 
 	if (mdi->mi_palloc_cache)
 		nilfs_palloc_destroy_cache(inode);
+
+	if (shadow) {
+		struct inode *s_inode = shadow->inode;
+
+		shadow->inode = NULL;
+		iput(s_inode);
+		mdi->mi_shadow = NULL;
+	}
 }
 
 /**
@@ -514,12 +523,15 @@ int nilfs_mdt_setup_shadow_map(struct inode *inode,
 			       struct nilfs_shadow_map *shadow)
 {
 	struct nilfs_mdt_info *mi = NILFS_MDT(inode);
+	struct inode *s_inode;
 
 	INIT_LIST_HEAD(&shadow->frozen_buffers);
-	address_space_init_once(&shadow->frozen_data);
-	nilfs_mapping_init(&shadow->frozen_data, inode);
-	address_space_init_once(&shadow->frozen_btnodes);
-	nilfs_mapping_init(&shadow->frozen_btnodes, inode);
+
+	s_inode = nilfs_iget_for_shadow(inode);
+	if (IS_ERR(s_inode))
+		return PTR_ERR(s_inode);
+
+	shadow->inode = s_inode;
 	mi->mi_shadow = shadow;
 	return 0;
 }
@@ -533,14 +545,15 @@ int nilfs_mdt_save_to_shadow_map(struct inode *inode)
 	struct nilfs_mdt_info *mi = NILFS_MDT(inode);
 	struct nilfs_inode_info *ii = NILFS_I(inode);
 	struct nilfs_shadow_map *shadow = mi->mi_shadow;
+	struct inode *s_inode = shadow->inode;
 	int ret;
 
-	ret = nilfs_copy_dirty_pages(&shadow->frozen_data, inode->i_mapping);
+	ret = nilfs_copy_dirty_pages(s_inode->i_mapping, inode->i_mapping);
 	if (ret)
 		goto out;
 
-	ret = nilfs_copy_dirty_pages(&shadow->frozen_btnodes,
-				     &ii->i_btnode_cache);
+	ret = nilfs_copy_dirty_pages(NILFS_I(s_inode)->i_assoc_inode->i_mapping,
+				     ii->i_assoc_inode->i_mapping);
 	if (ret)
 		goto out;
 
@@ -556,7 +569,7 @@ int nilfs_mdt_freeze_buffer(struct inode *inode, struct buffer_head *bh)
 	struct page *page;
 	int blkbits = inode->i_blkbits;
 
-	page = grab_cache_page(&shadow->frozen_data, bh->b_page->index);
+	page = grab_cache_page(shadow->inode->i_mapping, bh->b_page->index);
 	if (!page)
 		return -ENOMEM;
 
@@ -588,7 +601,7 @@ nilfs_mdt_get_frozen_buffer(struct inode *inode, struct buffer_head *bh)
 	struct page *page;
 	int n;
 
-	page = find_lock_page(&shadow->frozen_data, bh->b_page->index);
+	page = find_lock_page(shadow->inode->i_mapping, bh->b_page->index);
 	if (page) {
 		if (page_has_buffers(page)) {
 			n = bh_offset(bh) >> inode->i_blkbits;
@@ -629,10 +642,11 @@ void nilfs_mdt_restore_from_shadow_map(struct inode *inode)
 		nilfs_palloc_clear_cache(inode);
 
 	nilfs_clear_dirty_pages(inode->i_mapping, true);
-	nilfs_copy_back_pages(inode->i_mapping, &shadow->frozen_data);
+	nilfs_copy_back_pages(inode->i_mapping, shadow->inode->i_mapping);
 
-	nilfs_clear_dirty_pages(&ii->i_btnode_cache, true);
-	nilfs_copy_back_pages(&ii->i_btnode_cache, &shadow->frozen_btnodes);
+	nilfs_clear_dirty_pages(ii->i_assoc_inode->i_mapping, true);
+	nilfs_copy_back_pages(ii->i_assoc_inode->i_mapping,
+			      NILFS_I(shadow->inode)->i_assoc_inode->i_mapping);
 
 	nilfs_bmap_restore(ii->i_bmap, &shadow->bmap_store);
 
@@ -647,10 +661,11 @@ void nilfs_mdt_clear_shadow_map(struct inode *inode)
 {
 	struct nilfs_mdt_info *mi = NILFS_MDT(inode);
 	struct nilfs_shadow_map *shadow = mi->mi_shadow;
+	struct inode *shadow_btnc_inode = NILFS_I(shadow->inode)->i_assoc_inode;
 
 	down_write(&mi->mi_sem);
 	nilfs_release_frozen_buffers(shadow);
-	truncate_inode_pages(&shadow->frozen_data, 0);
-	truncate_inode_pages(&shadow->frozen_btnodes, 0);
+	truncate_inode_pages(shadow->inode->i_mapping, 0);
+	truncate_inode_pages(shadow_btnc_inode->i_mapping, 0);
 	up_write(&mi->mi_sem);
 }
diff --git a/fs/nilfs2/mdt.h b/fs/nilfs2/mdt.h
index 3f67f3932097..35ee0aeb9e27 100644
--- a/fs/nilfs2/mdt.h
+++ b/fs/nilfs2/mdt.h
@@ -27,14 +27,12 @@
 /**
  * struct nilfs_shadow_map - shadow mapping of meta data file
  * @bmap_store: shadow copy of bmap state
- * @frozen_data: shadowed dirty data pages
- * @frozen_btnodes: shadowed dirty b-tree nodes' pages
+ * @inode: holder of page caches used in shadow mapping
  * @frozen_buffers: list of frozen buffers
  */
 struct nilfs_shadow_map {
 	struct nilfs_bmap_store bmap_store;
-	struct address_space frozen_data;
-	struct address_space frozen_btnodes;
+	struct inode *inode;
 	struct list_head frozen_buffers;
 };
 
diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index a89704271428..f9798f14c199 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -37,7 +37,7 @@
  * @i_xattr: <TODO>
  * @i_dir_start_lookup: page index of last successful search
  * @i_cno: checkpoint number for GC inode
- * @i_btnode_cache: cached pages of b-tree nodes
+ * @i_assoc_inode: associated inode (B-tree node cache holder or back pointer)
  * @i_dirty: list for connecting dirty files
  * @xattr_sem: semaphore for extended attributes processing
  * @i_bh: buffer contains disk inode
@@ -52,7 +52,7 @@ struct nilfs_inode_info {
 	__u64 i_xattr;	/* sector_t ??? */
 	__u32 i_dir_start_lookup;
 	__u64 i_cno;		/* check point number for GC inode */
-	struct address_space i_btnode_cache;
+	struct inode *i_assoc_inode;
 	struct list_head i_dirty;	/* List for connecting dirty files */
 
 #ifdef CONFIG_NILFS_XATTR
@@ -84,13 +84,6 @@ NILFS_BMAP_I(const struct nilfs_bmap *bmap)
 	return container_of(bmap, struct nilfs_inode_info, i_bmap_data);
 }
 
-static inline struct inode *NILFS_BTNC_I(struct address_space *btnc)
-{
-	struct nilfs_inode_info *ii =
-		container_of(btnc, struct nilfs_inode_info, i_btnode_cache);
-	return &ii->vfs_inode;
-}
-
 /*
  * Dynamic state flags of NILFS on-memory inode (i_state)
  */
@@ -107,6 +100,8 @@ enum {
 	NILFS_I_INODE_SYNC,		/* dsync is not allowed for inode */
 	NILFS_I_BMAP,			/* has bmap and btnode_cache */
 	NILFS_I_GCINODE,		/* inode for GC, on memory only */
+	NILFS_I_BTNC,			/* inode for btree node cache */
+	NILFS_I_SHADOW,			/* inode for shadowed page cache */
 };
 
 /*
@@ -277,6 +272,9 @@ struct inode *nilfs_iget(struct super_block *sb, struct nilfs_root *root,
 			 unsigned long ino);
 extern struct inode *nilfs_iget_for_gc(struct super_block *sb,
 				       unsigned long ino, __u64 cno);
+int nilfs_attach_btree_node_cache(struct inode *inode);
+void nilfs_detach_btree_node_cache(struct inode *inode);
+struct inode *nilfs_iget_for_shadow(struct inode *inode);
 extern void nilfs_update_inode(struct inode *, struct buffer_head *, int);
 extern void nilfs_truncate(struct inode *);
 extern void nilfs_evict_inode(struct inode *);
diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
index 8616c46d33da..884c2452e60d 100644
--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -462,10 +462,9 @@ void nilfs_mapping_init(struct address_space *mapping, struct inode *inode)
 /*
  * NILFS2 needs clear_page_dirty() in the following two cases:
  *
- * 1) For B-tree node pages and data pages of the dat/gcdat, NILFS2 clears
- *    page dirty flags when it copies back pages from the shadow cache
- *    (gcdat->{i_mapping,i_btnode_cache}) to its original cache
- *    (dat->{i_mapping,i_btnode_cache}).
+ * 1) For B-tree node pages and data pages of DAT file, NILFS2 clears dirty
+ *    flag of pages when it copies back pages from shadow cache to the
+ *    original cache.
  *
  * 2) Some B-tree operations like insertion or deletion may dispose buffers
  *    in dirty state, and this needs to cancel the dirty state of their pages.
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 5d1e5832690e..e5a2b04c77ad 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -751,16 +751,19 @@ static void nilfs_lookup_dirty_node_buffers(struct inode *inode,
 					    struct list_head *listp)
 {
 	struct nilfs_inode_info *ii = NILFS_I(inode);
-	struct address_space *mapping = &ii->i_btnode_cache;
+	struct inode *btnc_inode = ii->i_assoc_inode;
 	struct pagevec pvec;
 	struct buffer_head *bh, *head;
 	unsigned int i;
 	pgoff_t index = 0;
 
+	if (!btnc_inode)
+		return;
+
 	pagevec_init(&pvec, 0);
 
-	while (pagevec_lookup_tag(&pvec, mapping, &index, PAGECACHE_TAG_DIRTY,
-				  PAGEVEC_SIZE)) {
+	while (pagevec_lookup_tag(&pvec, btnc_inode->i_mapping, &index,
+				  PAGECACHE_TAG_DIRTY, PAGEVEC_SIZE)) {
 		for (i = 0; i < pagevec_count(&pvec); i++) {
 			bh = head = page_buffers(pvec.pages[i]);
 			do {
@@ -890,9 +893,11 @@ static int nilfs_segctor_create_checkpoint(struct nilfs_sc_info *sci)
 		nilfs_mdt_mark_dirty(nilfs->ns_cpfile);
 		nilfs_cpfile_put_checkpoint(
 			nilfs->ns_cpfile, nilfs->ns_cno, bh_cp);
-	} else
-		WARN_ON(err == -EINVAL || err == -ENOENT);
-
+	} else if (err == -EINVAL || err == -ENOENT) {
+		nilfs_error(sci->sc_super,
+			    "checkpoint creation failed due to metadata corruption.");
+		err = -EIO;
+	}
 	return err;
 }
 
@@ -906,7 +911,11 @@ static int nilfs_segctor_fill_in_checkpoint(struct nilfs_sc_info *sci)
 	err = nilfs_cpfile_get_checkpoint(nilfs->ns_cpfile, nilfs->ns_cno, 0,
 					  &raw_cp, &bh_cp);
 	if (unlikely(err)) {
-		WARN_ON(err == -EINVAL || err == -ENOENT);
+		if (err == -EINVAL || err == -ENOENT) {
+			nilfs_error(sci->sc_super,
+				    "checkpoint finalization failed due to metadata corruption.");
+			err = -EIO;
+		}
 		goto failed_ibh;
 	}
 	raw_cp->cp_snapshot_list.ssl_next = 0;
@@ -2423,7 +2432,7 @@ nilfs_remove_written_gcinodes(struct the_nilfs *nilfs, struct list_head *head)
 			continue;
 		list_del_init(&ii->i_dirty);
 		truncate_inode_pages(&ii->vfs_inode.i_data, 0);
-		nilfs_btnode_cache_clear(&ii->i_btnode_cache);
+		nilfs_btnode_cache_clear(ii->i_assoc_inode->i_mapping);
 		iput(&ii->vfs_inode);
 	}
 }
@@ -2797,10 +2806,9 @@ int nilfs_attach_log_writer(struct super_block *sb, struct nilfs_root *root)
 	inode_attach_wb(nilfs->ns_bdev->bd_inode, NULL);
 
 	err = nilfs_segctor_start_thread(nilfs->ns_writer);
-	if (err) {
-		kfree(nilfs->ns_writer);
-		nilfs->ns_writer = NULL;
-	}
+	if (unlikely(err))
+		nilfs_detach_log_writer(sb);
+
 	return err;
 }
 
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 4fc018dfcfae..af7d0d5cce50 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -161,7 +161,8 @@ struct inode *nilfs_alloc_inode(struct super_block *sb)
 	ii->i_state = 0;
 	ii->i_cno = 0;
 	ii->vfs_inode.i_version = 1;
-	nilfs_mapping_init(&ii->i_btnode_cache, &ii->vfs_inode);
+	ii->i_assoc_inode = NULL;
+	ii->i_bmap = &ii->i_bmap_data;
 	return &ii->vfs_inode;
 }
 
@@ -1392,8 +1393,6 @@ static void nilfs_inode_init_once(void *obj)
 #ifdef CONFIG_NILFS_XATTR
 	init_rwsem(&ii->xattr_sem);
 #endif
-	address_space_init_once(&ii->i_btnode_cache);
-	ii->i_bmap = &ii->i_bmap_data;
 	inode_init_once(&ii->vfs_inode);
 }
 
diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
index 3f70f041dbe9..9da19fcd4a16 100644
--- a/fs/ntfs/super.c
+++ b/fs/ntfs/super.c
@@ -2106,7 +2106,8 @@ static bool load_system_files(ntfs_volume *vol)
 	// TODO: Initialize security.
 	/* Get the extended system files' directory inode. */
 	vol->extend_ino = ntfs_iget(sb, FILE_Extend);
-	if (IS_ERR(vol->extend_ino) || is_bad_inode(vol->extend_ino)) {
+	if (IS_ERR(vol->extend_ino) || is_bad_inode(vol->extend_ino) ||
+	    !S_ISDIR(vol->extend_ino->i_mode)) {
 		if (!IS_ERR(vol->extend_ino))
 			iput(vol->extend_ino);
 		ntfs_error(sb, "Failed to load $Extend.");
diff --git a/fs/quota/quota_tree.c b/fs/quota/quota_tree.c
index 833cd3e3758b..ae2ed96d4847 100644
--- a/fs/quota/quota_tree.c
+++ b/fs/quota/quota_tree.c
@@ -79,6 +79,35 @@ static ssize_t write_blk(struct qtree_mem_dqinfo *info, uint blk, char *buf)
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
@@ -93,6 +122,9 @@ static int get_free_dqblk(struct qtree_mem_dqinfo *info)
 		ret = read_blk(info, blk, buf);
 		if (ret < 0)
 			goto out_buf;
+		ret = check_dquot_block_header(info, dh);
+		if (ret)
+			goto out_buf;
 		info->dqi_free_blk = le32_to_cpu(dh->dqdh_next_free);
 	}
 	else {
@@ -240,6 +272,9 @@ static uint find_free_dqentry(struct qtree_mem_dqinfo *info,
 		*err = read_blk(info, blk, buf);
 		if (*err < 0)
 			goto out_buf;
+		*err = check_dquot_block_header(info, dh);
+		if (*err)
+			goto out_buf;
 	} else {
 		blk = get_free_dqblk(info);
 		if ((int)blk < 0) {
@@ -432,6 +467,9 @@ static int free_dqentry(struct qtree_mem_dqinfo *info, struct dquot *dquot,
 		goto out_buf;
 	}
 	dh = (struct qt_disk_dqdbheader *)buf;
+	ret = check_dquot_block_header(info, dh);
+	if (ret)
+		goto out_buf;
 	le16_add_cpu(&dh->dqdh_entries, -1);
 	if (!le16_to_cpu(dh->dqdh_entries)) {	/* Block got free? */
 		ret = remove_free_dqentry(info, buf, blk);
diff --git a/fs/splice.c b/fs/splice.c
index 04d25af25a42..c84ac7e97e21 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -898,15 +898,17 @@ ssize_t splice_direct_to_actor(struct file *in, struct splice_desc *sd,
 {
 	struct pipe_inode_info *pipe;
 	long ret, bytes;
+	umode_t i_mode;
 	size_t len;
 	int i, flags, more;
 
 	/*
-	 * We require the input to be seekable, as we don't want to randomly
-	 * drop data for eg socket -> socket splicing. Use the piped splicing
-	 * for that!
+	 * We require the input being a regular file, as we don't want to
+	 * randomly drop data for eg socket -> socket splicing. Use the
+	 * piped splicing for that!
 	 */
-	if (unlikely(!(in->f_mode & FMODE_LSEEK)))
+	i_mode = file_inode(in)->i_mode;
+	if (unlikely(!S_ISREG(i_mode) && !S_ISBLK(i_mode)))
 		return -EINVAL;
 
 	/*
diff --git a/include/linux/ata.h b/include/linux/ata.h
index c7a353825450..af884beac08d 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -579,6 +579,18 @@ struct ata_bmdma_prd {
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
@@ -591,9 +603,6 @@ struct ata_bmdma_prd {
 
 #define ata_id_cdb_intr(id)	(((id)[ATA_ID_CONFIG] & 0x60) == 0x20)
 #define ata_id_has_da(id)	((id)[ATA_ID_SATA_CAPABILITY_2] & (1 << 4))
-#define ata_id_has_devslp(id)	((id)[ATA_ID_FEATURE_SUPP] & (1 << 8))
-#define ata_id_has_ncq_autosense(id) \
-				((id)[ATA_ID_FEATURE_SUPP] & (1 << 7))
 
 static inline bool ata_id_has_hipm(const u16 *id)
 {
@@ -605,17 +614,6 @@ static inline bool ata_id_has_hipm(const u16 *id)
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
@@ -784,16 +782,21 @@ static inline bool ata_id_has_read_log_dma_ext(const u16 *id)
 
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
index 2fd8006153c3..921649db00f9 100644
--- a/include/linux/dynamic_debug.h
+++ b/include/linux/dynamic_debug.h
@@ -168,7 +168,7 @@ static inline int ddebug_remove_module(const char *mod)
 static inline int ddebug_dyndbg_module_param_cb(char *param, char *val,
 						const char *modname)
 {
-	if (strstr(param, "dyndbg")) {
+	if (!strcmp(param, "dyndbg")) {
 		/* avoid pr_warn(), which wants pr_fmt() fully defined */
 		printk(KERN_WARNING "dyndbg param is supported only in "
 			"CONFIG_DYNAMIC_DEBUG builds\n");
diff --git a/include/linux/iova.h b/include/linux/iova.h
index 7d23bbb887f2..641e62700ef3 100644
--- a/include/linux/iova.h
+++ b/include/linux/iova.h
@@ -131,7 +131,7 @@ static inline unsigned long iova_pfn(struct iova_domain *iovad, dma_addr_t iova)
 	return iova >> iova_shift(iovad);
 }
 
-#if IS_ENABLED(CONFIG_IOMMU_IOVA)
+#if IS_REACHABLE(CONFIG_IOMMU_IOVA)
 int iova_cache_get(void);
 void iova_cache_put(void);
 
diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index 61eb40fef759..b9bc6e3e4ef9 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -245,7 +245,7 @@ struct tcp_sock {
 	u32	packets_out;	/* Packets which are "in flight"	*/
 	u32	retrans_out;	/* Retransmitted packets out		*/
 	u32	max_packets_out;  /* max packets_out in last window */
-	u32	max_packets_seq;  /* right edge of max_packets_out flight */
+	u32	cwnd_usage_seq;  /* right edge of cwnd usage tracking flight */
 
 	u16	urg_data;	/* Saved octet of OOB data and control flags */
 	u8	ecn_flags;	/* ECN status bits.			*/
diff --git a/include/net/ieee802154_netdev.h b/include/net/ieee802154_netdev.h
index c4b31601cd53..588c86f67796 100644
--- a/include/net/ieee802154_netdev.h
+++ b/include/net/ieee802154_netdev.h
@@ -23,6 +23,22 @@
 #ifndef IEEE802154_NETDEVICE_H
 #define IEEE802154_NETDEVICE_H
 
+#define IEEE802154_REQUIRED_SIZE(struct_type, member) \
+	(offsetof(typeof(struct_type), member) + \
+	sizeof(((typeof(struct_type) *)(NULL))->member))
+
+#define IEEE802154_ADDR_OFFSET \
+	offsetof(typeof(struct sockaddr_ieee802154), addr)
+
+#define IEEE802154_MIN_NAMELEN (IEEE802154_ADDR_OFFSET + \
+	IEEE802154_REQUIRED_SIZE(struct ieee802154_addr_sa, addr_type))
+
+#define IEEE802154_NAMELEN_SHORT (IEEE802154_ADDR_OFFSET + \
+	IEEE802154_REQUIRED_SIZE(struct ieee802154_addr_sa, short_addr))
+
+#define IEEE802154_NAMELEN_LONG (IEEE802154_ADDR_OFFSET + \
+	IEEE802154_REQUIRED_SIZE(struct ieee802154_addr_sa, hwaddr))
+
 #include <net/af_ieee802154.h>
 #include <linux/netdevice.h>
 #include <linux/skbuff.h>
@@ -173,6 +189,33 @@ static inline void ieee802154_devaddr_to_raw(void *raw, __le64 addr)
 	memcpy(raw, &temp, IEEE802154_ADDR_LEN);
 }
 
+static inline int
+ieee802154_sockaddr_check_size(struct sockaddr_ieee802154 *daddr, int len)
+{
+	struct ieee802154_addr_sa *sa;
+	int ret = 0;
+
+	sa = &daddr->addr;
+	if (len < IEEE802154_MIN_NAMELEN)
+		return -EINVAL;
+	switch (sa->addr_type) {
+	case IEEE802154_ADDR_NONE:
+		break;
+	case IEEE802154_ADDR_SHORT:
+		if (len < IEEE802154_NAMELEN_SHORT)
+			ret = -EINVAL;
+		break;
+	case IEEE802154_ADDR_LONG:
+		if (len < IEEE802154_NAMELEN_LONG)
+			ret = -EINVAL;
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+	return ret;
+}
+
 static inline void ieee802154_addr_from_sa(struct ieee802154_addr *a,
 					   const struct ieee802154_addr_sa *sa)
 {
diff --git a/include/net/sock.h b/include/net/sock.h
index dfeaa8deba96..4053eea6182a 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -389,7 +389,7 @@ struct sock {
 #ifdef CONFIG_XFRM
 	struct xfrm_policy __rcu *sk_policy[2];
 #endif
-	struct dst_entry	*sk_rx_dst;
+	struct dst_entry __rcu	*sk_rx_dst;
 	struct dst_entry __rcu	*sk_dst_cache;
 	atomic_t		sk_omem_alloc;
 	int			sk_sndbuf;
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 5e719f9d60fd..003638f73ffa 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1228,11 +1228,14 @@ static inline bool tcp_is_cwnd_limited(const struct sock *sk)
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
 
 /* Something is really bad, we could not queue an additional packet,
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 7bc752fc98de..618a4bff500f 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -225,7 +225,7 @@ static inline struct scsi_data_buffer *scsi_out(struct scsi_cmnd *cmd)
 }
 
 static inline int scsi_sg_copy_from_buffer(struct scsi_cmnd *cmd,
-					   void *buf, int buflen)
+					   const void *buf, int buflen)
 {
 	return sg_copy_from_buffer(scsi_sglist(cmd), scsi_sg_count(cmd),
 				   buf, buflen);
diff --git a/kernel/gcov/gcc_4_7.c b/kernel/gcov/gcc_4_7.c
index 5b9e76117ded..bb6ccf456e2d 100644
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
@@ -439,12 +446,18 @@ static size_t convert_to_gcda(char *buffer, struct gcov_info *info)
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
@@ -458,7 +471,8 @@ static size_t convert_to_gcda(char *buffer, struct gcov_info *info)
 			/* Counter record. */
 			pos += store_gcov_u32(buffer, pos,
 					      GCOV_TAG_FOR_COUNTER(ct_idx));
-			pos += store_gcov_u32(buffer, pos, ci_ptr->num * 2);
+			pos += store_gcov_u32(buffer, pos,
+				ci_ptr->num * 2 * GCOV_UNIT_SIZE);
 
 			for (cv_idx = 0; cv_idx < ci_ptr->num; cv_idx++) {
 				pos += store_gcov_u64(buffer, pos,
diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
index b004a1fb6032..1950b5b8ad5b 100644
--- a/kernel/livepatch/transition.c
+++ b/kernel/livepatch/transition.c
@@ -573,7 +573,21 @@ void klp_reverse_transition(void)
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
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 4da64244f83d..7153f8817303 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -5128,8 +5128,12 @@ int ftrace_regex_release(struct inode *inode, struct file *file)
 
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
 
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 359f44cee08a..1e96ad2cab8c 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -512,8 +512,9 @@ static void rb_wake_up_waiters(struct irq_work *work)
 	struct rb_irq_work *rbwork = container_of(work, struct rb_irq_work, work);
 
 	wake_up_all(&rbwork->waiters);
-	if (rbwork->wakeup_full) {
+	if (rbwork->full_waiters_pending || rbwork->wakeup_full) {
 		rbwork->wakeup_full = false;
+		rbwork->full_waiters_pending = false;
 		wake_up_all(&rbwork->full_waiters);
 	}
 }
@@ -2095,6 +2096,9 @@ rb_reset_tail(struct ring_buffer_per_cpu *cpu_buffer,
 		/* Mark the rest of the page with padding */
 		rb_event_set_padding(event);
 
+		/* Make sure the padding is visible before the write update */
+		smp_wmb();
+
 		/* Set the write back to the previous setting */
 		local_sub(length, &tail_page->write);
 		return;
@@ -2106,6 +2110,9 @@ rb_reset_tail(struct ring_buffer_per_cpu *cpu_buffer,
 	/* time delta must be non zero */
 	event->time_delta = 1;
 
+	/* Make sure the padding is visible before the tail_page->write update */
+	smp_wmb();
+
 	/* Set write to end of buffer */
 	length = (tail + length) - BUF_PAGE_SIZE;
 	local_sub(length, &tail_page->write);
@@ -3696,6 +3703,33 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
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
 
@@ -4639,7 +4673,15 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
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
diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 91c451e0f474..01591a7b151f 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -327,10 +327,6 @@ static int ddebug_parse_query(char *words[], int nwords,
 	}
 	memset(query, 0, sizeof(*query));
 
-	if (modname)
-		/* support $modname.dyndbg=<multiple queries> */
-		query->module = modname;
-
 	for (i = 0; i < nwords; i += 2) {
 		if (!strcmp(words[i], "func")) {
 			rc = check_set(&query->function, words[i+1], "func");
@@ -379,6 +375,13 @@ static int ddebug_parse_query(char *words[], int nwords,
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
diff --git a/mm/migrate.c b/mm/migrate.c
index 9a3ce8847308..7a057e80f038 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2349,13 +2349,14 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
 		migrate->dst[migrate->npages] = 0;
 		migrate->src[migrate->npages++] = mpfn;
 	}
-	arch_leave_lazy_mmu_mode();
-	pte_unmap_unlock(ptep - 1, ptl);
 
 	/* Only flush the TLB if we actually modified any entries */
 	if (unmapped)
 		flush_tlb_range(walk->vma, start, end);
 
+	arch_leave_lazy_mmu_mode();
+	pte_unmap_unlock(ptep - 1, ptl);
+
 	return 0;
 }
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index bfbccc739332..f88307fee38d 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3567,6 +3567,30 @@ void fs_reclaim_release(gfp_t gfp_mask)
 EXPORT_SYMBOL_GPL(fs_reclaim_release);
 #endif
 
+/*
+ * Zonelists may change due to hotplug during allocation. Detect when zonelists
+ * have been rebuilt so allocation retries. Reader side does not lock and
+ * retries the allocation if zonelist changes. Writer side is protected by the
+ * embedded spin_lock.
+ */
+static DEFINE_SEQLOCK(zonelist_update_seq);
+
+static unsigned int zonelist_iter_begin(void)
+{
+	if (IS_ENABLED(CONFIG_MEMORY_HOTREMOVE))
+		return read_seqbegin(&zonelist_update_seq);
+
+	return 0;
+}
+
+static unsigned int check_retry_zonelist(unsigned int seq)
+{
+	if (IS_ENABLED(CONFIG_MEMORY_HOTREMOVE))
+		return read_seqretry(&zonelist_update_seq, seq);
+
+	return seq;
+}
+
 /* Perform direct synchronous page reclaim */
 static int
 __perform_reclaim(gfp_t gfp_mask, unsigned int order,
@@ -3870,6 +3894,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	int compaction_retries;
 	int no_progress_loops;
 	unsigned int cpuset_mems_cookie;
+	unsigned int zonelist_iter_cookie;
 	int reserve_flags;
 
 	/*
@@ -3880,11 +3905,12 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 				(__GFP_ATOMIC|__GFP_DIRECT_RECLAIM)))
 		gfp_mask &= ~__GFP_ATOMIC;
 
-retry_cpuset:
+restart:
 	compaction_retries = 0;
 	no_progress_loops = 0;
 	compact_priority = DEF_COMPACT_PRIORITY;
 	cpuset_mems_cookie = read_mems_allowed_begin();
+	zonelist_iter_cookie = zonelist_iter_begin();
 
 	/*
 	 * The fast path uses conservative alloc_flags to succeed only until
@@ -4032,9 +4058,13 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 		goto retry;
 
 
-	/* Deal with possible cpuset update races before we start OOM killing */
-	if (check_retry_cpuset(cpuset_mems_cookie, ac))
-		goto retry_cpuset;
+	/*
+	 * Deal with possible cpuset update races or zonelist updates to avoid
+	 * a unnecessary OOM kill.
+	 */
+	if (check_retry_cpuset(cpuset_mems_cookie, ac) ||
+	    check_retry_zonelist(zonelist_iter_cookie))
+		goto restart;
 
 	/* Reclaim has failed us, start killing things */
 	page = __alloc_pages_may_oom(gfp_mask, order, ac, &did_some_progress);
@@ -4054,9 +4084,13 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	}
 
 nopage:
-	/* Deal with possible cpuset update races before we fail */
-	if (check_retry_cpuset(cpuset_mems_cookie, ac))
-		goto retry_cpuset;
+	/*
+	 * Deal with possible cpuset update races or zonelist updates to avoid
+	 * a unnecessary OOM kill.
+	 */
+	if (check_retry_cpuset(cpuset_mems_cookie, ac) ||
+	    check_retry_zonelist(zonelist_iter_cookie))
+		goto restart;
 
 	/*
 	 * Make sure that __GFP_NOFAIL request doesn't leak out and make sure
@@ -4357,6 +4391,18 @@ void *page_frag_alloc(struct page_frag_cache *nc,
 		/* reset page count bias and offset to start of new frag */
 		nc->pagecnt_bias = PAGE_FRAG_CACHE_MAX_SIZE + 1;
 		offset = size - fragsz;
+		if (unlikely(offset < 0)) {
+			/*
+			 * The caller is trying to allocate a fragment
+			 * with fragsz > PAGE_SIZE but the cache isn't big
+			 * enough to satisfy the request, this may
+			 * happen in low memory conditions.
+			 * We don't release the cache page because
+			 * it could make memory pressure worse
+			 * so we simply return NULL here.
+			 */
+			return NULL;
+		}
 	}
 
 	nc->pagecnt_bias--;
@@ -5167,9 +5213,8 @@ static void __build_all_zonelists(void *data)
 	int nid;
 	int __maybe_unused cpu;
 	pg_data_t *self = data;
-	static DEFINE_SPINLOCK(lock);
 
-	spin_lock(&lock);
+	write_seqlock(&zonelist_update_seq);
 
 #ifdef CONFIG_NUMA
 	memset(node_load, 0, sizeof(node_load));
@@ -5202,7 +5247,7 @@ static void __build_all_zonelists(void *data)
 #endif
 	}
 
-	spin_unlock(&lock);
+	write_sequnlock(&zonelist_update_seq);
 }
 
 static noinline void __init
diff --git a/net/bluetooth/hci_sysfs.c b/net/bluetooth/hci_sysfs.c
index b568f7c21b30..0c9249339790 100644
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
index e45a12378bd1..652c0723051b 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -63,6 +63,9 @@ static void l2cap_send_disconn_req(struct l2cap_chan *chan, int err);
 
 static void l2cap_tx(struct l2cap_chan *chan, struct l2cap_ctrl *control,
 		     struct sk_buff_head *skbs, u8 event);
+static void l2cap_retrans_timeout(struct work_struct *work);
+static void l2cap_monitor_timeout(struct work_struct *work);
+static void l2cap_ack_timeout(struct work_struct *work);
 
 static inline u8 bdaddr_type(u8 link_type, u8 bdaddr_type)
 {
@@ -470,6 +473,9 @@ struct l2cap_chan *l2cap_chan_create(void)
 	write_unlock(&chan_list_lock);
 
 	INIT_DELAYED_WORK(&chan->chan_timer, l2cap_chan_timeout);
+	INIT_DELAYED_WORK(&chan->retrans_timer, l2cap_retrans_timeout);
+	INIT_DELAYED_WORK(&chan->monitor_timer, l2cap_monitor_timeout);
+	INIT_DELAYED_WORK(&chan->ack_timer, l2cap_ack_timeout);
 
 	chan->state = BT_OPEN;
 
@@ -3154,10 +3160,6 @@ int l2cap_ertm_init(struct l2cap_chan *chan)
 	chan->rx_state = L2CAP_RX_STATE_RECV;
 	chan->tx_state = L2CAP_TX_STATE_XMIT;
 
-	INIT_DELAYED_WORK(&chan->retrans_timer, l2cap_retrans_timeout);
-	INIT_DELAYED_WORK(&chan->monitor_timer, l2cap_monitor_timeout);
-	INIT_DELAYED_WORK(&chan->ack_timer, l2cap_ack_timeout);
-
 	skb_queue_head_init(&chan->srej_q);
 
 	err = l2cap_seq_list_init(&chan->srej_list, chan->tx_win);
@@ -4047,6 +4049,12 @@ static int l2cap_connect_create_rsp(struct l2cap_conn *conn,
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
@@ -4076,6 +4084,7 @@ static int l2cap_connect_create_rsp(struct l2cap_conn *conn,
 	}
 
 	l2cap_chan_unlock(chan);
+	l2cap_chan_put(chan);
 
 unlock:
 	mutex_unlock(&conn->chan_lock);
diff --git a/net/can/bcm.c b/net/can/bcm.c
index b3f3b02ffd42..89b955ef75d1 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -286,6 +286,7 @@ static void bcm_can_tx(struct bcm_op *op)
 	struct sk_buff *skb;
 	struct net_device *dev;
 	struct canfd_frame *cf = op->frames + op->cfsiz * op->currframe;
+	int err;
 
 	/* no target device? => exit */
 	if (!op->ifindex)
@@ -310,11 +311,11 @@ static void bcm_can_tx(struct bcm_op *op)
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
index cbe52b169070..e5c6c9e5e0aa 100644
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
index 9d46d9462129..a8929675b5ab 100644
--- a/net/ieee802154/socket.c
+++ b/net/ieee802154/socket.c
@@ -212,8 +212,9 @@ static int raw_bind(struct sock *sk, struct sockaddr *_uaddr, int len)
 	int err = 0;
 	struct net_device *dev = NULL;
 
-	if (len < sizeof(*uaddr))
-		return -EINVAL;
+	err = ieee802154_sockaddr_check_size(uaddr, len);
+	if (err < 0)
+		return err;
 
 	uaddr = (struct sockaddr_ieee802154 *)_uaddr;
 	if (uaddr->family != AF_IEEE802154)
@@ -283,6 +284,10 @@ static int raw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 		err = -EMSGSIZE;
 		goto out_dev;
 	}
+	if (!size) {
+		err = 0;
+		goto out_dev;
+	}
 
 	hlen = LL_RESERVED_SPACE(dev);
 	tlen = dev->needed_tailroom;
@@ -506,7 +511,8 @@ static int dgram_bind(struct sock *sk, struct sockaddr *uaddr, int len)
 
 	ro->bound = 0;
 
-	if (len < sizeof(*addr))
+	err = ieee802154_sockaddr_check_size(addr, len);
+	if (err < 0)
 		goto out;
 
 	if (addr->family != AF_IEEE802154)
@@ -577,8 +583,9 @@ static int dgram_connect(struct sock *sk, struct sockaddr *uaddr,
 	struct dgram_sock *ro = dgram_sk(sk);
 	int err = 0;
 
-	if (len < sizeof(*addr))
-		return -EINVAL;
+	err = ieee802154_sockaddr_check_size(addr, len);
+	if (err < 0)
+		return err;
 
 	if (addr->family != AF_IEEE802154)
 		return -EINVAL;
@@ -617,6 +624,7 @@ static int dgram_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 	struct ieee802154_mac_cb *cb;
 	struct dgram_sock *ro = dgram_sk(sk);
 	struct ieee802154_addr dst_addr;
+	DECLARE_SOCKADDR(struct sockaddr_ieee802154*, daddr, msg->msg_name);
 	int hlen, tlen;
 	int err;
 
@@ -625,10 +633,20 @@ static int dgram_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 		return -EOPNOTSUPP;
 	}
 
-	if (!ro->connected && !msg->msg_name)
-		return -EDESTADDRREQ;
-	else if (ro->connected && msg->msg_name)
-		return -EISCONN;
+	if (msg->msg_name) {
+		if (ro->connected)
+			return -EISCONN;
+		if (msg->msg_namelen < IEEE802154_MIN_NAMELEN)
+			return -EINVAL;
+		err = ieee802154_sockaddr_check_size(daddr, msg->msg_namelen);
+		if (err < 0)
+			return err;
+		ieee802154_addr_from_sa(&dst_addr, &daddr->addr);
+	} else {
+		if (!ro->connected)
+			return -EDESTADDRREQ;
+		dst_addr = ro->dst_addr;
+	}
 
 	if (!ro->bound)
 		dev = dev_getfirstbyhwtype(sock_net(sk), ARPHRD_IEEE802154);
@@ -664,16 +682,6 @@ static int dgram_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 	cb = mac_cb_init(skb);
 	cb->type = IEEE802154_FC_TYPE_DATA;
 	cb->ackreq = ro->want_ack;
-
-	if (msg->msg_name) {
-		DECLARE_SOCKADDR(struct sockaddr_ieee802154*,
-				 daddr, msg->msg_name);
-
-		ieee802154_addr_from_sa(&dst_addr, &daddr->addr);
-	} else {
-		dst_addr = ro->dst_addr;
-	}
-
 	cb->secen = ro->secen;
 	cb->secen_override = ro->secen_override;
 	cb->seclevel = ro->seclevel;
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 93dea10ef9a6..06ad21597d68 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -156,7 +156,7 @@ void inet_sock_destruct(struct sock *sk)
 
 	kfree(rcu_dereference_protected(inet->inet_opt, 1));
 	dst_release(rcu_dereference_check(sk->sk_dst_cache, 1));
-	dst_release(sk->sk_rx_dst);
+	dst_release(rcu_dereference_protected(sk->sk_rx_dst, 1));
 	sk_refcnt_debug_dec(sk);
 }
 EXPORT_SYMBOL(inet_sock_destruct);
diff --git a/net/ipv4/netfilter/nft_fib_ipv4.c b/net/ipv4/netfilter/nft_fib_ipv4.c
index e50976e3c213..3b2e8ac45d4e 100644
--- a/net/ipv4/netfilter/nft_fib_ipv4.c
+++ b/net/ipv4/netfilter/nft_fib_ipv4.c
@@ -95,6 +95,9 @@ void nft_fib4_eval(const struct nft_expr *expr, struct nft_regs *regs,
 	else
 		oif = NULL;
 
+	if (priv->flags & NFTA_FIB_F_IIF)
+		fl4.flowi4_oif = l3mdev_master_ifindex_rcu(oif);
+
 	if (nft_hook(pkt) == NF_INET_PRE_ROUTING &&
 	    nft_fib_is_loopback(pkt->skb, nft_in(pkt))) {
 		nft_fib_store_result(dest, priv, pkt,
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index a0fd9ef2d2c6..160ed3e7c24d 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2366,6 +2366,8 @@ int tcp_disconnect(struct sock *sk, int flags)
 	icsk->icsk_probes_out = 0;
 	tp->snd_ssthresh = TCP_INFINITE_SSTHRESH;
 	tp->snd_cwnd_cnt = 0;
+	tp->is_cwnd_limited = 0;
+	tp->max_packets_out = 0;
 	tp->window_clamp = 0;
 	tp->delivered = 0;
 	if (icsk->icsk_ca_ops->release)
@@ -2383,8 +2385,7 @@ int tcp_disconnect(struct sock *sk, int flags)
 	tcp_init_send_head(sk);
 	memset(&tp->rx_opt, 0, sizeof(tp->rx_opt));
 	__sk_dst_reset(sk);
-	dst_release(sk->sk_rx_dst);
-	sk->sk_rx_dst = NULL;
+	dst_release(xchg((__force struct dst_entry **)&sk->sk_rx_dst, NULL));
 	tcp_saved_syn_free(tp);
 	tp->segs_in = 0;
 	tp->segs_out = 0;
@@ -3316,12 +3317,16 @@ static void __tcp_alloc_md5sig_pool(void)
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
 
 		if (!tcp_md5sig_pool_populated)
@@ -3329,7 +3334,8 @@ bool tcp_alloc_md5sig_pool(void)
 
 		mutex_unlock(&tcp_md5sig_mutex);
 	}
-	return tcp_md5sig_pool_populated;
+	/* Paired with WRITE_ONCE() from __tcp_alloc_md5sig_pool() */
+	return READ_ONCE(tcp_md5sig_pool_populated);
 }
 EXPORT_SYMBOL(tcp_alloc_md5sig_pool);
 
@@ -3345,7 +3351,8 @@ struct tcp_md5sig_pool *tcp_get_md5sig_pool(void)
 {
 	local_bh_disable();
 
-	if (tcp_md5sig_pool_populated) {
+	/* Paired with WRITE_ONCE() from __tcp_alloc_md5sig_pool() */
+	if (READ_ONCE(tcp_md5sig_pool_populated)) {
 		/* coupled with smp_wmb() in __tcp_alloc_md5sig_pool() */
 		smp_rmb();
 		return this_cpu_ptr(&tcp_md5sig_pool);
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index c6d49ec38a56..eeed79ce8f9f 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5452,7 +5452,7 @@ void tcp_rcv_established(struct sock *sk, struct sk_buff *skb,
 	struct tcp_sock *tp = tcp_sk(sk);
 
 	tcp_mstamp_refresh(tp);
-	if (unlikely(!sk->sk_rx_dst))
+	if (unlikely(!rcu_access_pointer(sk->sk_rx_dst)))
 		inet_csk(sk)->icsk_af_ops->sk_rx_dst_set(sk, skb);
 	/*
 	 *	Header prediction.
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 3d56f2729418..9d8c64b92011 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1473,15 +1473,18 @@ int tcp_v4_do_rcv(struct sock *sk, struct sk_buff *skb)
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
 		tcp_rcv_established(sk, skb, tcp_hdr(skb));
@@ -1556,7 +1559,7 @@ int tcp_v4_early_demux(struct sk_buff *skb)
 		skb->sk = sk;
 		skb->destructor = sock_edemux;
 		if (sk_fullsock(sk)) {
-			struct dst_entry *dst = READ_ONCE(sk->sk_rx_dst);
+			struct dst_entry *dst = rcu_dereference(sk->sk_rx_dst);
 
 			if (dst)
 				dst = dst_check(dst, 0);
@@ -1849,7 +1852,7 @@ void inet_sk_rx_dst_set(struct sock *sk, const struct sk_buff *skb)
 	struct dst_entry *dst = skb_dst(skb);
 
 	if (dst && dst_hold_safe(dst)) {
-		sk->sk_rx_dst = dst;
+		rcu_assign_pointer(sk->sk_rx_dst, dst);
 		inet_sk(sk)->rx_dst_ifindex = skb->skb_iif;
 	}
 }
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 6b6dfb08dde4..2a9e55411ac4 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1618,15 +1618,20 @@ static void tcp_cwnd_validate(struct sock *sk, bool is_cwnd_limited)
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
index fee1cdcc224e..16573afc3069 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1955,7 +1955,7 @@ bool udp_sk_rx_dst_set(struct sock *sk, struct dst_entry *dst)
 	struct dst_entry *old;
 
 	if (dst_hold_safe(dst)) {
-		old = xchg(&sk->sk_rx_dst, dst);
+		old = xchg((__force struct dst_entry **)&sk->sk_rx_dst, dst);
 		dst_release(old);
 		return old != dst;
 	}
@@ -2145,7 +2145,7 @@ int __udp4_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 		struct dst_entry *dst = skb_dst(skb);
 		int ret;
 
-		if (unlikely(sk->sk_rx_dst != dst))
+		if (unlikely(rcu_dereference(sk->sk_rx_dst) != dst))
 			udp_sk_rx_dst_set(sk, dst);
 
 		ret = udp_unicast_rcv_skb(sk, skb, uh);
@@ -2303,7 +2303,7 @@ int udp_v4_early_demux(struct sk_buff *skb)
 
 	skb->sk = sk;
 	skb->destructor = sock_efree;
-	dst = READ_ONCE(sk->sk_rx_dst);
+	dst = rcu_dereference(sk->sk_rx_dst);
 
 	if (dst)
 		dst = dst_check(dst, 0);
diff --git a/net/ipv6/netfilter/nft_fib_ipv6.c b/net/ipv6/netfilter/nft_fib_ipv6.c
index fd9a45cbd709..bcc673e433e6 100644
--- a/net/ipv6/netfilter/nft_fib_ipv6.c
+++ b/net/ipv6/netfilter/nft_fib_ipv6.c
@@ -41,6 +41,9 @@ static int nft_fib6_flowi_init(struct flowi6 *fl6, const struct nft_fib *priv,
 	if (ipv6_addr_type(&fl6->daddr) & IPV6_ADDR_LINKLOCAL) {
 		lookup_flags |= RT6_LOOKUP_F_IFACE;
 		fl6->flowi6_oif = get_ifindex(dev ? dev : pkt->skb->dev);
+	} else if ((priv->flags & NFTA_FIB_F_IIF) &&
+		   (netif_is_l3_master(dev) || netif_is_l3_slave(dev))) {
+		fl6->flowi6_oif = dev->ifindex;
 	}
 
 	if (ipv6_addr_type(&fl6->saddr) & IPV6_ADDR_UNICAST)
@@ -190,7 +193,8 @@ void nft_fib6_eval(const struct nft_expr *expr, struct nft_regs *regs,
 	if (rt->rt6i_flags & (RTF_REJECT | RTF_ANYCAST | RTF_LOCAL))
 		goto put_rt_err;
 
-	if (oif && oif != rt->rt6i_idev->dev)
+	if (oif && oif != rt->rt6i_idev->dev &&
+	    l3mdev_master_ifindex_rcu(rt->rt6i_idev->dev) != oif->ifindex)
 		goto put_rt_err;
 
 	switch (priv->result) {
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 21637031fbab..711e5565e3a5 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -95,7 +95,7 @@ static void inet6_sk_rx_dst_set(struct sock *sk, const struct sk_buff *skb)
 	if (dst && dst_hold_safe(dst)) {
 		const struct rt6_info *rt = (const struct rt6_info *)dst;
 
-		sk->sk_rx_dst = dst;
+		rcu_assign_pointer(sk->sk_rx_dst, dst);
 		inet_sk(sk)->rx_dst_ifindex = skb->skb_iif;
 		inet6_sk(sk)->rx_dst_cookie = rt6_get_cookie(rt);
 	}
@@ -1318,15 +1318,18 @@ static int tcp_v6_do_rcv(struct sock *sk, struct sk_buff *skb)
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
 
@@ -1659,7 +1662,7 @@ static void tcp_v6_early_demux(struct sk_buff *skb)
 		skb->sk = sk;
 		skb->destructor = sock_edemux;
 		if (sk_fullsock(sk)) {
-			struct dst_entry *dst = READ_ONCE(sk->sk_rx_dst);
+			struct dst_entry *dst = rcu_dereference(sk->sk_rx_dst);
 
 			if (dst)
 				dst = dst_check(dst, inet6_sk(sk)->rx_dst_cookie);
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 3411b36b8a50..685efa6a8c32 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -848,7 +848,7 @@ int __udp6_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 		struct dst_entry *dst = skb_dst(skb);
 		int ret;
 
-		if (unlikely(sk->sk_rx_dst != dst))
+		if (unlikely(rcu_dereference(sk->sk_rx_dst) != dst))
 			udp6_sk_rx_dst_set(sk, dst);
 
 		if (!uh->check && !udp_sk(sk)->no_check6_rx) {
@@ -960,7 +960,7 @@ static void udp_v6_early_demux(struct sk_buff *skb)
 
 	skb->sk = sk;
 	skb->destructor = sock_efree;
-	dst = READ_ONCE(sk->sk_rx_dst);
+	dst = rcu_dereference(sk->sk_rx_dst);
 
 	if (dst)
 		dst = dst_check(dst, inet6_sk(sk)->rx_dst_cookie);
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index f769b08e6f2a..94293b57f1b2 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3111,9 +3111,6 @@ static int ieee80211_set_csa_beacon(struct ieee80211_sub_if_data *sdata,
 	case NL80211_IFTYPE_MESH_POINT: {
 		struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 
-		if (params->chandef.width != sdata->vif.bss_conf.chandef.width)
-			return -EINVAL;
-
 		/* changes into another band are not supported */
 		if (sdata->vif.bss_conf.chandef.chan->band !=
 		    params->chandef.chan->band)
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index dbc45165c533..46984cdee658 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -91,8 +91,6 @@ bool nf_queue_entry_get_refs(struct nf_queue_entry *entry)
 		dev_hold(state->in);
 	if (state->out)
 		dev_hold(state->out);
-	if (state->sk)
-		sock_hold(state->sk);
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
 	if (entry->skb->nf_bridge) {
 		struct net_device *physdev;
diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 3248cf04d0b3..8319628ab428 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -276,10 +276,17 @@ void ovs_dp_process_packet(struct sk_buff *skb, struct sw_flow_key *key)
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
@@ -546,8 +553,9 @@ static int queue_userspace_packet(struct datapath *dp, struct sk_buff *skb,
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
index 55bae71bf339..ae4901933e6d 100644
--- a/net/rds/tcp.c
+++ b/net/rds/tcp.c
@@ -162,10 +162,10 @@ void rds_tcp_reset_callbacks(struct socket *sock,
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
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 349311f6d195..9b8f592897ec 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -1075,7 +1075,7 @@ EXPORT_SYMBOL_GPL(virtio_transport_recv_pkt);
 
 void virtio_transport_free_pkt(struct virtio_vsock_pkt *pkt)
 {
-	kfree(pkt->buf);
+	kvfree(pkt->buf);
 	kfree(pkt);
 }
 EXPORT_SYMBOL_GPL(virtio_transport_free_pkt);
diff --git a/net/xfrm/xfrm_ipcomp.c b/net/xfrm/xfrm_ipcomp.c
index a00ec715aa46..32aed1d0f6ee 100644
--- a/net/xfrm/xfrm_ipcomp.c
+++ b/net/xfrm/xfrm_ipcomp.c
@@ -216,6 +216,7 @@ static void ipcomp_free_scratches(void)
 		vfree(*per_cpu_ptr(scratches, i));
 
 	free_percpu(scratches);
+	ipcomp_scratches = NULL;
 }
 
 static void * __percpu *ipcomp_alloc_scratches(void)
diff --git a/scripts/Makefile.extrawarn b/scripts/Makefile.extrawarn
index 65df6141397f..e15cd63428ba 100644
--- a/scripts/Makefile.extrawarn
+++ b/scripts/Makefile.extrawarn
@@ -74,5 +74,6 @@ KBUILD_CFLAGS += $(call cc-disable-warning, format-zero-length)
 KBUILD_CFLAGS += $(call cc-disable-warning, uninitialized)
 KBUILD_CFLAGS += $(call cc-disable-warning, pointer-to-enum-cast)
 KBUILD_CFLAGS += $(call cc-disable-warning, unaligned-access)
+KBUILD_CFLAGS += $(call cc-disable-warning, cast-function-type-strict)
 endif
 endif
diff --git a/scripts/selinux/install_policy.sh b/scripts/selinux/install_policy.sh
index 0b86c47baf7d..481d88b2c582 100755
--- a/scripts/selinux/install_policy.sh
+++ b/scripts/selinux/install_policy.sh
@@ -57,7 +57,7 @@ fi
 cd /etc/selinux/dummy/contexts/files
 $SF file_contexts /
 
-mounts=`cat /proc/$$/mounts | egrep "ext2|ext3|xfs|jfs|ext4|ext4dev|gfs2" | awk '{ print $2 '}`
+mounts=`cat /proc/$$/mounts | grep -E "ext2|ext3|xfs|jfs|ext4|ext4dev|gfs2" | awk '{ print $2 '}`
 $SF file_contexts $mounts
 
 
diff --git a/sound/core/pcm_dmaengine.c b/sound/core/pcm_dmaengine.c
index 8eb58c709b14..6f6da1128edc 100644
--- a/sound/core/pcm_dmaengine.c
+++ b/sound/core/pcm_dmaengine.c
@@ -139,12 +139,14 @@ EXPORT_SYMBOL_GPL(snd_dmaengine_pcm_set_config_from_dai_data);
 
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
index 0120624c4120..b96b95fb3e7e 100644
--- a/sound/core/rawmidi.c
+++ b/sound/core/rawmidi.c
@@ -1633,10 +1633,8 @@ static int snd_rawmidi_free(struct snd_rawmidi *rmidi)
 
 	snd_info_free_entry(rmidi->proc_entry);
 	rmidi->proc_entry = NULL;
-	mutex_lock(&register_mutex);
 	if (rmidi->ops && rmidi->ops->dev_unregister)
 		rmidi->ops->dev_unregister(rmidi);
-	mutex_unlock(&register_mutex);
 
 	snd_rawmidi_free_substreams(&rmidi->streams[SNDRV_RAWMIDI_STREAM_INPUT]);
 	snd_rawmidi_free_substreams(&rmidi->streams[SNDRV_RAWMIDI_STREAM_OUTPUT]);
diff --git a/sound/core/sound_oss.c b/sound/core/sound_oss.c
index 0a5c66229a22..cb065746d5c4 100644
--- a/sound/core/sound_oss.c
+++ b/sound/core/sound_oss.c
@@ -177,7 +177,6 @@ int snd_unregister_oss_device(int type, struct snd_card *card, int dev)
 		mutex_unlock(&sound_oss_mutex);
 		return -ENOENT;
 	}
-	unregister_sound_special(minor);
 	switch (SNDRV_MINOR_OSS_DEVICE(minor)) {
 	case SNDRV_MINOR_OSS_PCM:
 		track2 = SNDRV_MINOR_OSS(cidx, SNDRV_MINOR_OSS_AUDIO);
@@ -189,12 +188,18 @@ int snd_unregister_oss_device(int type, struct snd_card *card, int dev)
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
diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 8bab422bc141..978719fc4cd3 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2571,7 +2571,8 @@ static const struct pci_device_id azx_ids[] = {
 	  .driver_data = AZX_DRIVER_SCH | AZX_DCAPS_INTEL_PCH_NOPM },
 	/* Poulsbo */
 	{ PCI_DEVICE(0x8086, 0x811b),
-	  .driver_data = AZX_DRIVER_SCH | AZX_DCAPS_INTEL_PCH_BASE },
+	  .driver_data = AZX_DRIVER_SCH | AZX_DCAPS_INTEL_PCH_BASE |
+	  AZX_DCAPS_POSFIX_LPIB },
 	/* Oaktrail */
 	{ PCI_DEVICE(0x8086, 0x080a),
 	  .driver_data = AZX_DRIVER_SCH | AZX_DCAPS_INTEL_PCH_BASE },
diff --git a/sound/soc/fsl/eukrea-tlv320.c b/sound/soc/fsl/eukrea-tlv320.c
index 4c6f19ef98b2..04ef886f71b2 100644
--- a/sound/soc/fsl/eukrea-tlv320.c
+++ b/sound/soc/fsl/eukrea-tlv320.c
@@ -88,7 +88,7 @@ static int eukrea_tlv320_probe(struct platform_device *pdev)
 	int ret;
 	int int_port = 0, ext_port;
 	struct device_node *np = pdev->dev.of_node;
-	struct device_node *ssi_np = NULL, *codec_np = NULL;
+	struct device_node *ssi_np = NULL, *codec_np = NULL, *tmp_np = NULL;
 
 	eukrea_tlv320.dev = &pdev->dev;
 	if (np) {
@@ -145,7 +145,7 @@ static int eukrea_tlv320_probe(struct platform_device *pdev)
 	}
 
 	if (machine_is_eukrea_cpuimx27() ||
-	    of_find_compatible_node(NULL, NULL, "fsl,imx21-audmux")) {
+	    (tmp_np = of_find_compatible_node(NULL, NULL, "fsl,imx21-audmux"))) {
 		imx_audmux_v1_configure_port(MX27_AUDMUX_HPCR1_SSI0,
 			IMX_AUDMUX_V1_PCR_SYN |
 			IMX_AUDMUX_V1_PCR_TFSDIR |
@@ -160,10 +160,11 @@ static int eukrea_tlv320_probe(struct platform_device *pdev)
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
@@ -180,6 +181,7 @@ static int eukrea_tlv320_probe(struct platform_device *pdev)
 			IMX_AUDMUX_V2_PTCR_SYN,
 			IMX_AUDMUX_V2_PDCR_RXDSEL(int_port)
 		);
+		of_node_put(tmp_np);
 	} else {
 		if (np) {
 			/* The eukrea,asoc-tlv320 driver was explicitly
diff --git a/sound/usb/endpoint.c b/sound/usb/endpoint.c
index 8caf0b57f9c6..eefe3d1c0b93 100644
--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -86,12 +86,13 @@ static inline unsigned get_usb_high_speed_rate(unsigned int rate)
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
@@ -818,6 +819,7 @@ static int sync_ep_set_params(struct snd_usb_endpoint *ep)
 	if (!ep->syncbuf)
 		return -ENOMEM;
 
+	ep->nurbs = SYNC_URBS;
 	for (i = 0; i < SYNC_URBS; i++) {
 		struct snd_urb_ctx *u = &ep->urb[i];
 		u->index = i;
@@ -837,8 +839,6 @@ static int sync_ep_set_params(struct snd_usb_endpoint *ep)
 		u->urb->complete = snd_complete_urb;
 	}
 
-	ep->nurbs = SYNC_URBS;
-
 	return 0;
 
 out_of_memory:
diff --git a/tools/perf/util/intel-pt.c b/tools/perf/util/intel-pt.c
index b51393ee9599..5dce810bd9bd 100644
--- a/tools/perf/util/intel-pt.c
+++ b/tools/perf/util/intel-pt.c
@@ -2411,6 +2411,7 @@ static const char * const intel_pt_info_fmts[] = {
 	[INTEL_PT_SNAPSHOT_MODE]	= "  Snapshot mode       %"PRId64"\n",
 	[INTEL_PT_PER_CPU_MMAPS]	= "  Per-cpu maps        %"PRId64"\n",
 	[INTEL_PT_MTC_BIT]		= "  MTC bit             %#"PRIx64"\n",
+	[INTEL_PT_MTC_FREQ_BITS]	= "  MTC freq bits       %#"PRIx64"\n",
 	[INTEL_PT_TSC_CTC_N]		= "  TSC:CTC numerator   %"PRIu64"\n",
 	[INTEL_PT_TSC_CTC_D]		= "  TSC:CTC denominator %"PRIu64"\n",
 	[INTEL_PT_CYC_BIT]		= "  CYC bit             %#"PRIx64"\n",
@@ -2425,8 +2426,12 @@ static void intel_pt_print_info(u64 *arr, int start, int finish)
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
diff --git a/tools/testing/selftests/net/reuseport_bpf.c b/tools/testing/selftests/net/reuseport_bpf.c
index b5277106df1f..b0cc082fbb84 100644
--- a/tools/testing/selftests/net/reuseport_bpf.c
+++ b/tools/testing/selftests/net/reuseport_bpf.c
@@ -330,7 +330,7 @@ static void test_extra_filter(const struct test_params p)
 	if (bind(fd1, addr, sockaddr_size()))
 		error(1, errno, "failed to bind recv socket 1");
 
-	if (!bind(fd2, addr, sockaddr_size()) && errno != EADDRINUSE)
+	if (!bind(fd2, addr, sockaddr_size()) || errno != EADDRINUSE)
 		error(1, errno, "bind socket 2 should fail with EADDRINUSE");
 
 	free(addr);
