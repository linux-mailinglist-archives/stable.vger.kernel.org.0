Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D345C3D8C03
	for <lists+stable@lfdr.de>; Wed, 28 Jul 2021 12:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232514AbhG1KjF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 06:39:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:47400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233125AbhG1KjF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Jul 2021 06:39:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E3D6060FC0;
        Wed, 28 Jul 2021 10:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627468743;
        bh=qdeQV+8L4TSZEk767nnJp1bg8E0gKpO+4jFbCF/bwRw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vjkhBmQYhPNVZ04b8KXc+w3yxWjCemMDGS07HvZMYiVZvgG5AxJQwklrs/pKNzTKz
         MIcNleTGltBpgk82rwuut6wSuQtHneuOuhmN942Q10JwG25/CVzNJKy3woJ3l2OaWx
         EN+GiN1uooDX46yMcl6LGCBGSTVMjfAYvOZuq1NQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.14.241
Date:   Wed, 28 Jul 2021 12:38:56 +0200
Message-Id: <1627468734279@kroah.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <16274687349916@kroah.com>
References: <16274687349916@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index c76ad4490eaf..439f416c36ff 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 14
-SUBLEVEL = 240
+SUBLEVEL = 241
 EXTRAVERSION =
 NAME = Petit Gorille
 
diff --git a/arch/arm/boot/dts/bcm-cygnus.dtsi b/arch/arm/boot/dts/bcm-cygnus.dtsi
index b822952c29f8..79acf9278aca 100644
--- a/arch/arm/boot/dts/bcm-cygnus.dtsi
+++ b/arch/arm/boot/dts/bcm-cygnus.dtsi
@@ -446,7 +446,7 @@
 			status = "disabled";
 		};
 
-		nand: nand@18046000 {
+		nand_controller: nand-controller@18046000 {
 			compatible = "brcm,nand-iproc", "brcm,brcmnand-v6.1";
 			reg = <0x18046000 0x600>, <0xf8105408 0x600>,
 			      <0x18046f00 0x20>;
diff --git a/arch/arm/boot/dts/bcm-nsp.dtsi b/arch/arm/boot/dts/bcm-nsp.dtsi
index e975f9cabe84..3bd3412b29a8 100644
--- a/arch/arm/boot/dts/bcm-nsp.dtsi
+++ b/arch/arm/boot/dts/bcm-nsp.dtsi
@@ -259,7 +259,7 @@
 			dma-coherent;
 		};
 
-		nand: nand@26000 {
+		nand_controller: nand-controller@26000 {
 			compatible = "brcm,nand-iproc", "brcm,brcmnand-v6.1";
 			reg = <0x026000 0x600>,
 			      <0x11b408 0x600>,
diff --git a/arch/arm/boot/dts/bcm63138.dtsi b/arch/arm/boot/dts/bcm63138.dtsi
index 6df61518776f..557098f5c8d5 100644
--- a/arch/arm/boot/dts/bcm63138.dtsi
+++ b/arch/arm/boot/dts/bcm63138.dtsi
@@ -175,7 +175,7 @@
 			status = "disabled";
 		};
 
-		nand: nand@2000 {
+		nand_controller: nand-controller@2000 {
 			#address-cells = <1>;
 			#size-cells = <0>;
 			compatible = "brcm,nand-bcm63138", "brcm,brcmnand-v7.0", "brcm,brcmnand";
diff --git a/arch/arm/boot/dts/bcm7445-bcm97445svmb.dts b/arch/arm/boot/dts/bcm7445-bcm97445svmb.dts
index 8006c69a3fdf..5931c0288283 100644
--- a/arch/arm/boot/dts/bcm7445-bcm97445svmb.dts
+++ b/arch/arm/boot/dts/bcm7445-bcm97445svmb.dts
@@ -14,10 +14,10 @@
 	};
 };
 
-&nand {
+&nand_controller {
 	status = "okay";
 
-	nandcs@1 {
+	nand@1 {
 		compatible = "brcm,nandcs";
 		reg = <1>;
 		nand-ecc-step-size = <512>;
diff --git a/arch/arm/boot/dts/bcm7445.dtsi b/arch/arm/boot/dts/bcm7445.dtsi
index c859aa6f358c..b06845e92acd 100644
--- a/arch/arm/boot/dts/bcm7445.dtsi
+++ b/arch/arm/boot/dts/bcm7445.dtsi
@@ -150,7 +150,7 @@
 			reg-names = "aon-ctrl", "aon-sram";
 		};
 
-		nand: nand@3e2800 {
+		nand_controller: nand-controller@3e2800 {
 			status = "disabled";
 			#address-cells = <1>;
 			#size-cells = <0>;
diff --git a/arch/arm/boot/dts/bcm911360_entphn.dts b/arch/arm/boot/dts/bcm911360_entphn.dts
index 53f990defd6a..423a29a46b77 100644
--- a/arch/arm/boot/dts/bcm911360_entphn.dts
+++ b/arch/arm/boot/dts/bcm911360_entphn.dts
@@ -84,8 +84,8 @@
 	status = "okay";
 };
 
-&nand {
-	nandcs@1 {
+&nand_controller {
+	nand@1 {
 		compatible = "brcm,nandcs";
 		reg = <0>;
 		nand-on-flash-bbt;
diff --git a/arch/arm/boot/dts/bcm958300k.dts b/arch/arm/boot/dts/bcm958300k.dts
index b4a1392bd5a6..dda3e11b711f 100644
--- a/arch/arm/boot/dts/bcm958300k.dts
+++ b/arch/arm/boot/dts/bcm958300k.dts
@@ -60,8 +60,8 @@
 	status = "okay";
 };
 
-&nand {
-	nandcs@1 {
+&nand_controller {
+	nand@1 {
 		compatible = "brcm,nandcs";
 		reg = <0>;
 		nand-on-flash-bbt;
diff --git a/arch/arm/boot/dts/bcm958305k.dts b/arch/arm/boot/dts/bcm958305k.dts
index 3378683321d3..ea3c6b88b313 100644
--- a/arch/arm/boot/dts/bcm958305k.dts
+++ b/arch/arm/boot/dts/bcm958305k.dts
@@ -68,8 +68,8 @@
 	status = "okay";
 };
 
-&nand {
-	nandcs@1 {
+&nand_controller {
+	nand@1 {
 		compatible = "brcm,nandcs";
 		reg = <0>;
 		nand-on-flash-bbt;
diff --git a/arch/arm/boot/dts/bcm958522er.dts b/arch/arm/boot/dts/bcm958522er.dts
index f9dd342cc2ae..56f9181975b1 100644
--- a/arch/arm/boot/dts/bcm958522er.dts
+++ b/arch/arm/boot/dts/bcm958522er.dts
@@ -74,8 +74,8 @@
 	status = "okay";
 };
 
-&nand {
-	nandcs@0 {
+&nand_controller {
+	nand@0 {
 		compatible = "brcm,nandcs";
 		reg = <0>;
 		nand-on-flash-bbt;
diff --git a/arch/arm/boot/dts/bcm958525er.dts b/arch/arm/boot/dts/bcm958525er.dts
index 374508a9cfbf..93a3e23ec7ae 100644
--- a/arch/arm/boot/dts/bcm958525er.dts
+++ b/arch/arm/boot/dts/bcm958525er.dts
@@ -74,8 +74,8 @@
 	status = "okay";
 };
 
-&nand {
-	nandcs@0 {
+&nand_controller {
+	nand@0 {
 		compatible = "brcm,nandcs";
 		reg = <0>;
 		nand-on-flash-bbt;
diff --git a/arch/arm/boot/dts/bcm958525xmc.dts b/arch/arm/boot/dts/bcm958525xmc.dts
index 403250c5ad8e..fad974212d8a 100644
--- a/arch/arm/boot/dts/bcm958525xmc.dts
+++ b/arch/arm/boot/dts/bcm958525xmc.dts
@@ -90,8 +90,8 @@
 	};
 };
 
-&nand {
-	nandcs@0 {
+&nand_controller {
+	nand@0 {
 		compatible = "brcm,nandcs";
 		reg = <0>;
 		nand-on-flash-bbt;
diff --git a/arch/arm/boot/dts/bcm958622hr.dts b/arch/arm/boot/dts/bcm958622hr.dts
index fd8b8c689ffe..26b5ed56b604 100644
--- a/arch/arm/boot/dts/bcm958622hr.dts
+++ b/arch/arm/boot/dts/bcm958622hr.dts
@@ -78,8 +78,8 @@
 	status = "okay";
 };
 
-&nand {
-	nandcs@0 {
+&nand_controller {
+	nand@0 {
 		compatible = "brcm,nandcs";
 		reg = <0>;
 		nand-on-flash-bbt;
diff --git a/arch/arm/boot/dts/bcm958623hr.dts b/arch/arm/boot/dts/bcm958623hr.dts
index b8bde13de90a..789fb77e17ad 100644
--- a/arch/arm/boot/dts/bcm958623hr.dts
+++ b/arch/arm/boot/dts/bcm958623hr.dts
@@ -78,8 +78,8 @@
 	status = "okay";
 };
 
-&nand {
-	nandcs@0 {
+&nand_controller {
+	nand@0 {
 		compatible = "brcm,nandcs";
 		reg = <0>;
 		nand-on-flash-bbt;
diff --git a/arch/arm/boot/dts/bcm958625hr.dts b/arch/arm/boot/dts/bcm958625hr.dts
index f0e2008f7490..88d51eb3083d 100644
--- a/arch/arm/boot/dts/bcm958625hr.dts
+++ b/arch/arm/boot/dts/bcm958625hr.dts
@@ -76,8 +76,8 @@
 	status = "okay";
 };
 
-&nand {
-	nandcs@0 {
+&nand_controller {
+	nand@0 {
 		compatible = "brcm,nandcs";
 		reg = <0>;
 		nand-on-flash-bbt;
diff --git a/arch/arm/boot/dts/bcm958625k.dts b/arch/arm/boot/dts/bcm958625k.dts
index 2cf2392483b2..22d321e06a31 100644
--- a/arch/arm/boot/dts/bcm958625k.dts
+++ b/arch/arm/boot/dts/bcm958625k.dts
@@ -69,8 +69,8 @@
 	status = "okay";
 };
 
-&nand {
-	nandcs@0 {
+&nand_controller {
+	nand@0 {
 		compatible = "brcm,nandcs";
 		reg = <0>;
 		nand-on-flash-bbt;
diff --git a/arch/arm/boot/dts/bcm963138dvt.dts b/arch/arm/boot/dts/bcm963138dvt.dts
index c61673638fa8..5445fccec5a5 100644
--- a/arch/arm/boot/dts/bcm963138dvt.dts
+++ b/arch/arm/boot/dts/bcm963138dvt.dts
@@ -30,10 +30,10 @@
 	status = "okay";
 };
 
-&nand {
+&nand_controller {
 	status = "okay";
 
-	nandcs@0 {
+	nand@0 {
 		compatible = "brcm,nandcs";
 		reg = <0>;
 		nand-ecc-strength = <4>;
diff --git a/arch/arm/boot/dts/bcm988312hr.dts b/arch/arm/boot/dts/bcm988312hr.dts
index bce251a68591..b62b91fa942f 100644
--- a/arch/arm/boot/dts/bcm988312hr.dts
+++ b/arch/arm/boot/dts/bcm988312hr.dts
@@ -78,8 +78,8 @@
 	status = "okay";
 };
 
-&nand {
-	nandcs@0 {
+&nand_controller {
+	nand@0 {
 		compatible = "brcm,nandcs";
 		reg = <0>;
 		nand-on-flash-bbt;
diff --git a/arch/arm/boot/dts/gemini.dtsi b/arch/arm/boot/dts/gemini.dtsi
index b9b07d0895cf..52c35bf816f0 100644
--- a/arch/arm/boot/dts/gemini.dtsi
+++ b/arch/arm/boot/dts/gemini.dtsi
@@ -275,6 +275,7 @@
 			clock-names = "PCLK", "PCICLK";
 			pinctrl-names = "default";
 			pinctrl-0 = <&pci_default_pins>;
+			device_type = "pci";
 			#address-cells = <3>;
 			#size-cells = <2>;
 			#interrupt-cells = <1>;
diff --git a/arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi b/arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi
index d2c31eae9fef..cce680a563f7 100644
--- a/arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi
@@ -306,8 +306,8 @@
 			fsl,pins = <
 				MX6QDL_PAD_EIM_D24__UART3_TX_DATA	0x1b0b1
 				MX6QDL_PAD_EIM_D25__UART3_RX_DATA	0x1b0b1
-				MX6QDL_PAD_EIM_D30__UART3_RTS_B		0x1b0b1
-				MX6QDL_PAD_EIM_D31__UART3_CTS_B		0x1b0b1
+				MX6QDL_PAD_EIM_D31__UART3_RTS_B		0x1b0b1
+				MX6QDL_PAD_EIM_D30__UART3_CTS_B		0x1b0b1
 			>;
 		};
 
@@ -394,6 +394,7 @@
 &uart3 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_uart3>;
+	uart-has-rtscts;
 	status = "disabled";
 };
 
diff --git a/arch/arm/boot/dts/rk3036-kylin.dts b/arch/arm/boot/dts/rk3036-kylin.dts
index fdb1570bc7d3..3371bc921aef 100644
--- a/arch/arm/boot/dts/rk3036-kylin.dts
+++ b/arch/arm/boot/dts/rk3036-kylin.dts
@@ -424,7 +424,7 @@
 		};
 	};
 
-	sleep {
+	suspend {
 		global_pwroff: global-pwroff {
 			rockchip,pins = <2 7 RK_FUNC_1 &pcfg_pull_none>;
 		};
diff --git a/arch/arm/boot/dts/rk3188.dtsi b/arch/arm/boot/dts/rk3188.dtsi
index 1399bc04ea77..74eb1dfa2f6c 100644
--- a/arch/arm/boot/dts/rk3188.dtsi
+++ b/arch/arm/boot/dts/rk3188.dtsi
@@ -110,16 +110,16 @@
 		compatible = "rockchip,rk3188-timer", "rockchip,rk3288-timer";
 		reg = <0x2000e000 0x20>;
 		interrupts = <GIC_SPI 46 IRQ_TYPE_LEVEL_HIGH>;
-		clocks = <&cru SCLK_TIMER3>, <&cru PCLK_TIMER3>;
-		clock-names = "timer", "pclk";
+		clocks = <&cru PCLK_TIMER3>, <&cru SCLK_TIMER3>;
+		clock-names = "pclk", "timer";
 	};
 
 	timer6: timer@200380a0 {
 		compatible = "rockchip,rk3188-timer", "rockchip,rk3288-timer";
 		reg = <0x200380a0 0x20>;
 		interrupts = <GIC_SPI 64 IRQ_TYPE_LEVEL_HIGH>;
-		clocks = <&cru SCLK_TIMER6>, <&cru PCLK_TIMER0>;
-		clock-names = "timer", "pclk";
+		clocks = <&cru PCLK_TIMER0>, <&cru SCLK_TIMER6>;
+		clock-names = "pclk", "timer";
 	};
 
 	i2s0: i2s@1011a000 {
diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
index 23907d9ce89a..9adb58930c08 100644
--- a/arch/arm/boot/dts/rk3288.dtsi
+++ b/arch/arm/boot/dts/rk3288.dtsi
@@ -220,8 +220,8 @@
 		compatible = "rockchip,rk3288-timer";
 		reg = <0x0 0xff810000 0x0 0x20>;
 		interrupts = <GIC_SPI 72 IRQ_TYPE_LEVEL_HIGH>;
-		clocks = <&xin24m>, <&cru PCLK_TIMER>;
-		clock-names = "timer", "pclk";
+		clocks = <&cru PCLK_TIMER>, <&xin24m>;
+		clock-names = "pclk", "timer";
 	};
 
 	display-subsystem {
@@ -745,7 +745,7 @@
 			 *	*_HDMI		HDMI
 			 *	*_MIPI_*	MIPI
 			 */
-			pd_vio@RK3288_PD_VIO {
+			power-domain@RK3288_PD_VIO {
 				reg = <RK3288_PD_VIO>;
 				clocks = <&cru ACLK_IEP>,
 					 <&cru ACLK_ISP>,
@@ -787,7 +787,7 @@
 			 * Note: The following 3 are HEVC(H.265) clocks,
 			 * and on the ACLK_HEVC_NIU (NOC).
 			 */
-			pd_hevc@RK3288_PD_HEVC {
+			power-domain@RK3288_PD_HEVC {
 				reg = <RK3288_PD_HEVC>;
 				clocks = <&cru ACLK_HEVC>,
 					 <&cru SCLK_HEVC_CABAC>,
@@ -801,7 +801,7 @@
 			 * (video endecoder & decoder) clocks that on the
 			 * ACLK_VCODEC_NIU and HCLK_VCODEC_NIU (NOC).
 			 */
-			pd_video@RK3288_PD_VIDEO {
+			power-domain@RK3288_PD_VIDEO {
 				reg = <RK3288_PD_VIDEO>;
 				clocks = <&cru ACLK_VCODEC>,
 					 <&cru HCLK_VCODEC>;
@@ -812,7 +812,7 @@
 			 * Note: ACLK_GPU is the GPU clock,
 			 * and on the ACLK_GPU_NIU (NOC).
 			 */
-			pd_gpu@RK3288_PD_GPU {
+			power-domain@RK3288_PD_GPU {
 				reg = <RK3288_PD_GPU>;
 				clocks = <&cru ACLK_GPU>;
 				pm_qos = <&qos_gpu_r>,
@@ -1453,7 +1453,7 @@
 			drive-strength = <12>;
 		};
 
-		sleep {
+		suspend {
 			global_pwroff: global-pwroff {
 				rockchip,pins = <0 0 RK_FUNC_1 &pcfg_pull_none>;
 			};
diff --git a/arch/arm/boot/dts/stm32f429.dtsi b/arch/arm/boot/dts/stm32f429.dtsi
index 5b36eb114ddc..d65a03d0da65 100644
--- a/arch/arm/boot/dts/stm32f429.dtsi
+++ b/arch/arm/boot/dts/stm32f429.dtsi
@@ -597,7 +597,7 @@
 			status = "disabled";
 		};
 
-		rcc: rcc@40023810 {
+		rcc: rcc@40023800 {
 			#reset-cells = <1>;
 			#clock-cells = <2>;
 			compatible = "st,stm32f42xx-rcc", "st,stm32-rcc";
diff --git a/arch/arm/mach-imx/suspend-imx53.S b/arch/arm/mach-imx/suspend-imx53.S
index 5ed078ad110a..f12d24104075 100644
--- a/arch/arm/mach-imx/suspend-imx53.S
+++ b/arch/arm/mach-imx/suspend-imx53.S
@@ -33,11 +33,11 @@
  *                              ^
  *                              ^
  *                      imx53_suspend code
- *              PM_INFO structure(imx53_suspend_info)
+ *              PM_INFO structure(imx5_cpu_suspend_info)
  * ======================== low address =======================
  */
 
-/* Offsets of members of struct imx53_suspend_info */
+/* Offsets of members of struct imx5_cpu_suspend_info */
 #define SUSPEND_INFO_MX53_M4IF_V_OFFSET		0x0
 #define SUSPEND_INFO_MX53_IOMUXC_V_OFFSET	0x4
 #define SUSPEND_INFO_MX53_IO_COUNT_OFFSET	0x8
diff --git a/arch/arm64/boot/dts/arm/juno-base.dtsi b/arch/arm64/boot/dts/arm/juno-base.dtsi
index 13ee8ffa9bbf..76902ea7288f 100644
--- a/arch/arm64/boot/dts/arm/juno-base.dtsi
+++ b/arch/arm64/boot/dts/arm/juno-base.dtsi
@@ -513,13 +513,13 @@
 		clocks {
 			compatible = "arm,scpi-clocks";
 
-			scpi_dvfs: scpi-dvfs {
+			scpi_dvfs: clocks-0 {
 				compatible = "arm,scpi-dvfs-clocks";
 				#clock-cells = <1>;
 				clock-indices = <0>, <1>, <2>;
 				clock-output-names = "atlclk", "aplclk","gpuclk";
 			};
-			scpi_clk: scpi-clk {
+			scpi_clk: clocks-1 {
 				compatible = "arm,scpi-variable-clocks";
 				#clock-cells = <1>;
 				clock-indices = <3>;
@@ -527,7 +527,7 @@
 			};
 		};
 
-		scpi_devpd: scpi-power-domains {
+		scpi_devpd: power-controller {
 			compatible = "arm,scpi-power-domains";
 			num-domains = <2>;
 			#power-domain-cells = <1>;
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi
index 4fb9a0966a84..4b459167a746 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi
@@ -515,7 +515,6 @@
 			clocks = <&clockgen 4 3>;
 			clock-names = "dspi";
 			spi-num-chipselects = <5>;
-			bus-num = <0>;
 		};
 
 		esdhc: esdhc@2140000 {
diff --git a/arch/arm64/boot/dts/rockchip/rk3328.dtsi b/arch/arm64/boot/dts/rockchip/rk3328.dtsi
index 6c3684885fac..a3fb072f20ba 100644
--- a/arch/arm64/boot/dts/rockchip/rk3328.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3328.dtsi
@@ -289,13 +289,13 @@
 			#address-cells = <1>;
 			#size-cells = <0>;
 
-			pd_hevc@RK3328_PD_HEVC {
+			power-domain@RK3328_PD_HEVC {
 				reg = <RK3328_PD_HEVC>;
 			};
-			pd_video@RK3328_PD_VIDEO {
+			power-domain@RK3328_PD_VIDEO {
 				reg = <RK3328_PD_VIDEO>;
 			};
-			pd_vpu@RK3328_PD_VPU {
+			power-domain@RK3328_PD_VPU {
 				reg = <RK3328_PD_VPU>;
 			};
 		};
diff --git a/arch/arm64/boot/dts/rockchip/rk3399.dtsi b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
index 721f4b6b262f..029d4578bca3 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
@@ -2074,7 +2074,7 @@
 			};
 		};
 
-		sleep {
+		suspend {
 			ap_pwroff: ap-pwroff {
 				rockchip,pins = <1 5 RK_FUNC_1 &pcfg_pull_none>;
 			};
diff --git a/arch/mips/include/asm/pgalloc.h b/arch/mips/include/asm/pgalloc.h
index f800872f867b..39b9f311c4ef 100644
--- a/arch/mips/include/asm/pgalloc.h
+++ b/arch/mips/include/asm/pgalloc.h
@@ -93,15 +93,11 @@ do {							\
 
 static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long address)
 {
-	pmd_t *pmd = NULL;
-	struct page *pg;
+	pmd_t *pmd;
 
-	pg = alloc_pages(GFP_KERNEL | __GFP_ACCOUNT, PMD_ORDER);
-	if (pg) {
-		pgtable_pmd_page_ctor(pg);
-		pmd = (pmd_t *)page_address(pg);
+	pmd = (pmd_t *) __get_free_pages(GFP_KERNEL, PMD_ORDER);
+	if (pmd)
 		pmd_init((unsigned long)pmd, (unsigned long)invalid_pte_table);
-	}
 	return pmd;
 }
 
diff --git a/arch/powerpc/kvm/book3s_rtas.c b/arch/powerpc/kvm/book3s_rtas.c
index 8f2355138f80..a56c56aa829c 100644
--- a/arch/powerpc/kvm/book3s_rtas.c
+++ b/arch/powerpc/kvm/book3s_rtas.c
@@ -243,6 +243,17 @@ int kvmppc_rtas_hcall(struct kvm_vcpu *vcpu)
 	 * value so we can restore it on the way out.
 	 */
 	orig_rets = args.rets;
+	if (be32_to_cpu(args.nargs) >= ARRAY_SIZE(args.args)) {
+		/*
+		 * Don't overflow our args array: ensure there is room for
+		 * at least rets[0] (even if the call specifies 0 nret).
+		 *
+		 * Each handler must then check for the correct nargs and nret
+		 * values, but they may always return failure in rets[0].
+		 */
+		rc = -EINVAL;
+		goto fail;
+	}
 	args.rets = &args.args[be32_to_cpu(args.nargs)];
 
 	mutex_lock(&vcpu->kvm->arch.rtas_token_lock);
@@ -270,9 +281,17 @@ int kvmppc_rtas_hcall(struct kvm_vcpu *vcpu)
 fail:
 	/*
 	 * We only get here if the guest has called RTAS with a bogus
-	 * args pointer. That means we can't get to the args, and so we
-	 * can't fail the RTAS call. So fail right out to userspace,
-	 * which should kill the guest.
+	 * args pointer or nargs/nret values that would overflow the
+	 * array. That means we can't get to the args, and so we can't
+	 * fail the RTAS call. So fail right out to userspace, which
+	 * should kill the guest.
+	 *
+	 * SLOF should actually pass the hcall return value from the
+	 * rtas handler call in r3, so enter_rtas could be modified to
+	 * return a failure indication in r3 and we could return such
+	 * errors to the guest rather than failing to host userspace.
+	 * However old guests that don't test for failure could then
+	 * continue silently after errors, so for now we won't do this.
 	 */
 	return rc;
 }
diff --git a/arch/s390/include/asm/ftrace.h b/arch/s390/include/asm/ftrace.h
index cfccc0edd00d..0c06387f1263 100644
--- a/arch/s390/include/asm/ftrace.h
+++ b/arch/s390/include/asm/ftrace.h
@@ -20,6 +20,7 @@ void ftrace_caller(void);
 
 extern char ftrace_graph_caller_end;
 extern unsigned long ftrace_plt;
+extern void *ftrace_func;
 
 struct dyn_arch_ftrace { };
 
diff --git a/arch/s390/kernel/ftrace.c b/arch/s390/kernel/ftrace.c
index dc76d813e420..ef196d79d229 100644
--- a/arch/s390/kernel/ftrace.c
+++ b/arch/s390/kernel/ftrace.c
@@ -57,6 +57,7 @@
  * >	brasl	%r0,ftrace_caller	# offset 0
  */
 
+void *ftrace_func __read_mostly = ftrace_stub;
 unsigned long ftrace_plt;
 
 static inline void ftrace_generate_orig_insn(struct ftrace_insn *insn)
@@ -166,6 +167,7 @@ int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 
 int ftrace_update_ftrace_func(ftrace_func_t func)
 {
+	ftrace_func = func;
 	return 0;
 }
 
diff --git a/arch/s390/kernel/mcount.S b/arch/s390/kernel/mcount.S
index 151f001a90ff..216c365807a5 100644
--- a/arch/s390/kernel/mcount.S
+++ b/arch/s390/kernel/mcount.S
@@ -60,13 +60,13 @@ ENTRY(ftrace_caller)
 #ifdef CONFIG_HAVE_MARCH_Z196_FEATURES
 	aghik	%r2,%r0,-MCOUNT_INSN_SIZE
 	lgrl	%r4,function_trace_op
-	lgrl	%r1,ftrace_trace_function
+	lgrl	%r1,ftrace_func
 #else
 	lgr	%r2,%r0
 	aghi	%r2,-MCOUNT_INSN_SIZE
 	larl	%r4,function_trace_op
 	lg	%r4,0(%r4)
-	larl	%r1,ftrace_trace_function
+	larl	%r1,ftrace_func
 	lg	%r1,0(%r1)
 #endif
 	lgr	%r3,%r14
diff --git a/arch/s390/net/bpf_jit_comp.c b/arch/s390/net/bpf_jit_comp.c
index b8bd84104843..bb3710e7ad9c 100644
--- a/arch/s390/net/bpf_jit_comp.c
+++ b/arch/s390/net/bpf_jit_comp.c
@@ -117,7 +117,7 @@ static inline void reg_set_seen(struct bpf_jit *jit, u32 b1)
 {
 	u32 r1 = reg2hex[b1];
 
-	if (!jit->seen_reg[r1] && r1 >= 6 && r1 <= 15)
+	if (r1 >= 6 && r1 <= 15 && !jit->seen_reg[r1])
 		jit->seen_reg[r1] = 1;
 }
 
diff --git a/drivers/dma-buf/sync_file.c b/drivers/dma-buf/sync_file.c
index bf65e634590b..bcc886394bac 100644
--- a/drivers/dma-buf/sync_file.c
+++ b/drivers/dma-buf/sync_file.c
@@ -220,8 +220,8 @@ static struct sync_file *sync_file_merge(const char *name, struct sync_file *a,
 					 struct sync_file *b)
 {
 	struct sync_file *sync_file;
-	struct dma_fence **fences, **nfences, **a_fences, **b_fences;
-	int i, i_a, i_b, num_fences, a_num_fences, b_num_fences;
+	struct dma_fence **fences = NULL, **nfences, **a_fences, **b_fences;
+	int i = 0, i_a, i_b, num_fences, a_num_fences, b_num_fences;
 
 	sync_file = sync_file_alloc();
 	if (!sync_file)
@@ -245,7 +245,7 @@ static struct sync_file *sync_file_merge(const char *name, struct sync_file *a,
 	 * If a sync_file can only be created with sync_file_merge
 	 * and sync_file_create, this is a reasonable assumption.
 	 */
-	for (i = i_a = i_b = 0; i_a < a_num_fences && i_b < b_num_fences; ) {
+	for (i_a = i_b = 0; i_a < a_num_fences && i_b < b_num_fences; ) {
 		struct dma_fence *pt_a = a_fences[i_a];
 		struct dma_fence *pt_b = b_fences[i_b];
 
@@ -286,15 +286,16 @@ static struct sync_file *sync_file_merge(const char *name, struct sync_file *a,
 		fences = nfences;
 	}
 
-	if (sync_file_set_fence(sync_file, fences, i) < 0) {
-		kfree(fences);
+	if (sync_file_set_fence(sync_file, fences, i) < 0)
 		goto err;
-	}
 
 	strlcpy(sync_file->user_name, name, sizeof(sync_file->user_name));
 	return sync_file;
 
 err:
+	while (i)
+		dma_fence_put(fences[--i]);
+	kfree(fences);
 	fput(sync_file->file);
 	return NULL;
 
diff --git a/drivers/gpu/drm/drm_ioctl.c b/drivers/gpu/drm/drm_ioctl.c
index 60fc06234d73..ce26e8fea9c2 100644
--- a/drivers/gpu/drm/drm_ioctl.c
+++ b/drivers/gpu/drm/drm_ioctl.c
@@ -776,6 +776,9 @@ long drm_ioctl(struct file *filp,
 	if (drm_dev_is_unplugged(dev))
 		return -ENODEV;
 
+       if (DRM_IOCTL_TYPE(cmd) != DRM_IOCTL_BASE)
+               return -ENOTTY;
+
 	is_driver_ioctl = nr >= DRM_COMMAND_BASE && nr < DRM_COMMAND_END;
 
 	if (is_driver_ioctl) {
diff --git a/drivers/iio/accel/bma180.c b/drivers/iio/accel/bma180.c
index dabe4717961f..d266e5614473 100644
--- a/drivers/iio/accel/bma180.c
+++ b/drivers/iio/accel/bma180.c
@@ -50,7 +50,7 @@ struct bma180_part_info {
 
 	u8 int_reset_reg, int_reset_mask;
 	u8 sleep_reg, sleep_mask;
-	u8 bw_reg, bw_mask;
+	u8 bw_reg, bw_mask, bw_offset;
 	u8 scale_reg, scale_mask;
 	u8 power_reg, power_mask, lowpower_val;
 	u8 int_enable_reg, int_enable_mask;
@@ -106,6 +106,7 @@ struct bma180_part_info {
 
 #define BMA250_RANGE_MASK	GENMASK(3, 0) /* Range of accel values */
 #define BMA250_BW_MASK		GENMASK(4, 0) /* Accel bandwidth */
+#define BMA250_BW_OFFSET	8
 #define BMA250_SUSPEND_MASK	BIT(7) /* chip will sleep */
 #define BMA250_LOWPOWER_MASK	BIT(6)
 #define BMA250_DATA_INTEN_MASK	BIT(4)
@@ -243,7 +244,8 @@ static int bma180_set_bw(struct bma180_data *data, int val)
 	for (i = 0; i < data->part_info->num_bw; ++i) {
 		if (data->part_info->bw_table[i] == val) {
 			ret = bma180_set_bits(data, data->part_info->bw_reg,
-				data->part_info->bw_mask, i);
+				data->part_info->bw_mask,
+				i + data->part_info->bw_offset);
 			if (ret) {
 				dev_err(&data->client->dev,
 					"failed to set bandwidth\n");
@@ -626,32 +628,53 @@ static const struct iio_chan_spec bma250_channels[] = {
 
 static const struct bma180_part_info bma180_part_info[] = {
 	[BMA180] = {
-		bma180_channels, ARRAY_SIZE(bma180_channels),
-		bma180_scale_table, ARRAY_SIZE(bma180_scale_table),
-		bma180_bw_table, ARRAY_SIZE(bma180_bw_table),
-		BMA180_CTRL_REG0, BMA180_RESET_INT,
-		BMA180_CTRL_REG0, BMA180_SLEEP,
-		BMA180_BW_TCS, BMA180_BW,
-		BMA180_OFFSET_LSB1, BMA180_RANGE,
-		BMA180_TCO_Z, BMA180_MODE_CONFIG, BMA180_LOW_POWER,
-		BMA180_CTRL_REG3, BMA180_NEW_DATA_INT,
-		BMA180_RESET,
-		bma180_chip_config,
-		bma180_chip_disable,
+		.channels = bma180_channels,
+		.num_channels = ARRAY_SIZE(bma180_channels),
+		.scale_table = bma180_scale_table,
+		.num_scales = ARRAY_SIZE(bma180_scale_table),
+		.bw_table = bma180_bw_table,
+		.num_bw = ARRAY_SIZE(bma180_bw_table),
+		.int_reset_reg = BMA180_CTRL_REG0,
+		.int_reset_mask = BMA180_RESET_INT,
+		.sleep_reg = BMA180_CTRL_REG0,
+		.sleep_mask = BMA180_SLEEP,
+		.bw_reg = BMA180_BW_TCS,
+		.bw_mask = BMA180_BW,
+		.scale_reg = BMA180_OFFSET_LSB1,
+		.scale_mask = BMA180_RANGE,
+		.power_reg = BMA180_TCO_Z,
+		.power_mask = BMA180_MODE_CONFIG,
+		.lowpower_val = BMA180_LOW_POWER,
+		.int_enable_reg = BMA180_CTRL_REG3,
+		.int_enable_mask = BMA180_NEW_DATA_INT,
+		.softreset_reg = BMA180_RESET,
+		.chip_config = bma180_chip_config,
+		.chip_disable = bma180_chip_disable,
 	},
 	[BMA250] = {
-		bma250_channels, ARRAY_SIZE(bma250_channels),
-		bma250_scale_table, ARRAY_SIZE(bma250_scale_table),
-		bma250_bw_table, ARRAY_SIZE(bma250_bw_table),
-		BMA250_INT_RESET_REG, BMA250_INT_RESET_MASK,
-		BMA250_POWER_REG, BMA250_SUSPEND_MASK,
-		BMA250_BW_REG, BMA250_BW_MASK,
-		BMA250_RANGE_REG, BMA250_RANGE_MASK,
-		BMA250_POWER_REG, BMA250_LOWPOWER_MASK, 1,
-		BMA250_INT_ENABLE_REG, BMA250_DATA_INTEN_MASK,
-		BMA250_RESET_REG,
-		bma250_chip_config,
-		bma250_chip_disable,
+		.channels = bma250_channels,
+		.num_channels = ARRAY_SIZE(bma250_channels),
+		.scale_table = bma250_scale_table,
+		.num_scales = ARRAY_SIZE(bma250_scale_table),
+		.bw_table = bma250_bw_table,
+		.num_bw = ARRAY_SIZE(bma250_bw_table),
+		.int_reset_reg = BMA250_INT_RESET_REG,
+		.int_reset_mask = BMA250_INT_RESET_MASK,
+		.sleep_reg = BMA250_POWER_REG,
+		.sleep_mask = BMA250_SUSPEND_MASK,
+		.bw_reg = BMA250_BW_REG,
+		.bw_mask = BMA250_BW_MASK,
+		.bw_offset = BMA250_BW_OFFSET,
+		.scale_reg = BMA250_RANGE_REG,
+		.scale_mask = BMA250_RANGE_MASK,
+		.power_reg = BMA250_POWER_REG,
+		.power_mask = BMA250_LOWPOWER_MASK,
+		.lowpower_val = 1,
+		.int_enable_reg = BMA250_INT_ENABLE_REG,
+		.int_enable_mask = BMA250_DATA_INTEN_MASK,
+		.softreset_reg = BMA250_RESET_REG,
+		.chip_config = bma250_chip_config,
+		.chip_disable = bma250_chip_disable,
 	},
 };
 
diff --git a/drivers/media/pci/ngene/ngene-core.c b/drivers/media/pci/ngene/ngene-core.c
index 8c92cb7f7e72..96d0cbffa77c 100644
--- a/drivers/media/pci/ngene/ngene-core.c
+++ b/drivers/media/pci/ngene/ngene-core.c
@@ -398,7 +398,7 @@ static int ngene_command_config_free_buf(struct ngene *dev, u8 *config)
 
 	com.cmd.hdr.Opcode = CMD_CONFIGURE_FREE_BUFFER;
 	com.cmd.hdr.Length = 6;
-	memcpy(&com.cmd.ConfigureBuffers.config, config, 6);
+	memcpy(&com.cmd.ConfigureFreeBuffers.config, config, 6);
 	com.in_len = 6;
 	com.out_len = 0;
 
diff --git a/drivers/media/pci/ngene/ngene.h b/drivers/media/pci/ngene/ngene.h
index 7c7cd217333d..af063be3dc4e 100644
--- a/drivers/media/pci/ngene/ngene.h
+++ b/drivers/media/pci/ngene/ngene.h
@@ -403,12 +403,14 @@ enum _BUFFER_CONFIGS {
 
 struct FW_CONFIGURE_FREE_BUFFERS {
 	struct FW_HEADER hdr;
-	u8   UVI1_BufferLength;
-	u8   UVI2_BufferLength;
-	u8   TVO_BufferLength;
-	u8   AUD1_BufferLength;
-	u8   AUD2_BufferLength;
-	u8   TVA_BufferLength;
+	struct {
+		u8   UVI1_BufferLength;
+		u8   UVI2_BufferLength;
+		u8   TVO_BufferLength;
+		u8   AUD1_BufferLength;
+		u8   AUD2_BufferLength;
+		u8   TVA_BufferLength;
+	} __packed config;
 } __attribute__ ((__packed__));
 
 struct FW_CONFIGURE_UART {
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index ce89c43ced8a..23ff3ec666cd 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -1158,7 +1158,8 @@ static void bcmgenet_power_up(struct bcmgenet_priv *priv,
 
 	switch (mode) {
 	case GENET_POWER_PASSIVE:
-		reg &= ~(EXT_PWR_DOWN_DLL | EXT_PWR_DOWN_BIAS);
+		reg &= ~(EXT_PWR_DOWN_DLL | EXT_PWR_DOWN_BIAS |
+			 EXT_ENERGY_DET_MASK);
 		if (GENET_IS_V5(priv)) {
 			reg &= ~(EXT_PWR_DOWN_PHY_EN |
 				 EXT_PWR_DOWN_PHY_RD |
@@ -2789,15 +2790,21 @@ static void bcmgenet_set_hw_addr(struct bcmgenet_priv *priv,
 /* Returns a reusable dma control register value */
 static u32 bcmgenet_dma_disable(struct bcmgenet_priv *priv)
 {
+	unsigned int i;
 	u32 reg;
 	u32 dma_ctrl;
 
 	/* disable DMA */
 	dma_ctrl = 1 << (DESC_INDEX + DMA_RING_BUF_EN_SHIFT) | DMA_EN;
+	for (i = 0; i < priv->hw_params->tx_queues; i++)
+		dma_ctrl |= (1 << (i + DMA_RING_BUF_EN_SHIFT));
 	reg = bcmgenet_tdma_readl(priv, DMA_CTRL);
 	reg &= ~dma_ctrl;
 	bcmgenet_tdma_writel(priv, reg, DMA_CTRL);
 
+	dma_ctrl = 1 << (DESC_INDEX + DMA_RING_BUF_EN_SHIFT) | DMA_EN;
+	for (i = 0; i < priv->hw_params->rx_queues; i++)
+		dma_ctrl |= (1 << (i + DMA_RING_BUF_EN_SHIFT));
 	reg = bcmgenet_rdma_readl(priv, DMA_CTRL);
 	reg &= ~dma_ctrl;
 	bcmgenet_rdma_writel(priv, reg, DMA_CTRL);
@@ -2907,12 +2914,6 @@ static int bcmgenet_open(struct net_device *dev)
 
 	bcmgenet_set_hw_addr(priv, dev->dev_addr);
 
-	if (priv->internal_phy) {
-		reg = bcmgenet_ext_readl(priv, EXT_EXT_PWR_MGMT);
-		reg |= EXT_ENERGY_DET_MASK;
-		bcmgenet_ext_writel(priv, reg, EXT_EXT_PWR_MGMT);
-	}
-
 	/* Disable RX/TX DMA and flush TX queues */
 	dma_ctrl = bcmgenet_dma_disable(priv);
 
@@ -3670,7 +3671,6 @@ static int bcmgenet_resume(struct device *d)
 	struct bcmgenet_priv *priv = netdev_priv(dev);
 	unsigned long dma_ctrl;
 	int ret;
-	u32 reg;
 
 	if (!netif_running(dev))
 		return 0;
@@ -3706,12 +3706,6 @@ static int bcmgenet_resume(struct device *d)
 
 	bcmgenet_set_hw_addr(priv, dev->dev_addr);
 
-	if (priv->internal_phy) {
-		reg = bcmgenet_ext_readl(priv, EXT_EXT_PWR_MGMT);
-		reg |= EXT_ENERGY_DET_MASK;
-		bcmgenet_ext_writel(priv, reg, EXT_EXT_PWR_MGMT);
-	}
-
 	if (priv->wolopts)
 		bcmgenet_power_up(priv, GENET_POWER_WOL_MAGIC);
 
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
index 2fbd027f0148..26c57f3edb88 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
@@ -166,12 +166,6 @@ int bcmgenet_wol_power_down_cfg(struct bcmgenet_priv *priv,
 	reg |= CMD_RX_EN;
 	bcmgenet_umac_writel(priv, reg, UMAC_CMD);
 
-	if (priv->hw_params->flags & GENET_HAS_EXT) {
-		reg = bcmgenet_ext_readl(priv, EXT_EXT_PWR_MGMT);
-		reg &= ~EXT_ENERGY_DET_MASK;
-		bcmgenet_ext_writel(priv, reg, EXT_EXT_PWR_MGMT);
-	}
-
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_device.c b/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_device.c
index 30f0e54f658e..4248ba307b66 100644
--- a/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_device.c
+++ b/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_device.c
@@ -420,7 +420,7 @@ static int cn23xx_pf_setup_global_input_regs(struct octeon_device *oct)
 	 * bits 32:47 indicate the PVF num.
 	 */
 	for (q_no = 0; q_no < ern; q_no++) {
-		reg_val = oct->pcie_port << CN23XX_PKT_INPUT_CTL_MAC_NUM_POS;
+		reg_val = (u64)oct->pcie_port << CN23XX_PKT_INPUT_CTL_MAC_NUM_POS;
 
 		/* for VF assigned queues. */
 		if (q_no < oct->sriov_info.pf_srn) {
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index f50d0da8fefe..116914de603e 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -7392,6 +7392,7 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 err_ioremap:
 	free_netdev(netdev);
 err_alloc_etherdev:
+	pci_disable_pcie_error_reporting(pdev);
 	pci_release_mem_regions(pdev);
 err_pci_reg:
 err_dma:
diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_pci.c b/drivers/net/ethernet/intel/fm10k/fm10k_pci.c
index 63784576ae8b..6b71fc19ab38 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_pci.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_pci.c
@@ -2095,6 +2095,7 @@ static int fm10k_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 err_ioremap:
 	free_netdev(netdev);
 err_alloc_netdev:
+	pci_disable_pcie_error_reporting(pdev);
 	pci_release_mem_regions(pdev);
 err_pci_reg:
 err_dma:
diff --git a/drivers/net/ethernet/intel/i40evf/i40evf_main.c b/drivers/net/ethernet/intel/i40evf/i40evf_main.c
index 1b5d204c57c1..ad2dd5b747b2 100644
--- a/drivers/net/ethernet/intel/i40evf/i40evf_main.c
+++ b/drivers/net/ethernet/intel/i40evf/i40evf_main.c
@@ -2924,6 +2924,7 @@ static int i40evf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 err_ioremap:
 	free_netdev(netdev);
 err_alloc_etherdev:
+	pci_disable_pcie_error_reporting(pdev);
 	pci_release_regions(pdev);
 err_pci_reg:
 err_dma:
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 50fa0401c701..6bd30d51dafc 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -949,6 +949,7 @@ static void igb_configure_msix(struct igb_adapter *adapter)
  **/
 static int igb_request_msix(struct igb_adapter *adapter)
 {
+	unsigned int num_q_vectors = adapter->num_q_vectors;
 	struct net_device *netdev = adapter->netdev;
 	int i, err = 0, vector = 0, free_vector = 0;
 
@@ -957,7 +958,13 @@ static int igb_request_msix(struct igb_adapter *adapter)
 	if (err)
 		goto err_out;
 
-	for (i = 0; i < adapter->num_q_vectors; i++) {
+	if (num_q_vectors > MAX_Q_VECTORS) {
+		num_q_vectors = MAX_Q_VECTORS;
+		dev_warn(&adapter->pdev->dev,
+			 "The number of queue vectors (%d) is higher than max allowed (%d)\n",
+			 adapter->num_q_vectors, MAX_Q_VECTORS);
+	}
+	for (i = 0; i < num_q_vectors; i++) {
 		struct igb_q_vector *q_vector = adapter->q_vector[i];
 
 		vector++;
@@ -2784,6 +2791,7 @@ static int igb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 err_ioremap:
 	free_netdev(netdev);
 err_alloc_etherdev:
+	pci_disable_pcie_error_reporting(pdev);
 	pci_release_mem_regions(pdev);
 err_pci_reg:
 err_dma:
@@ -3962,6 +3970,8 @@ static void igb_clean_tx_ring(struct igb_ring *tx_ring)
 					       DMA_TO_DEVICE);
 		}
 
+		tx_buffer->next_to_watch = NULL;
+
 		/* move us one more past the eop_desc for start of next pkt */
 		tx_buffer++;
 		i++;
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index e9205c893531..ac9835e61602 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -1872,7 +1872,8 @@ static void ixgbe_dma_sync_frag(struct ixgbe_ring *rx_ring,
 				struct sk_buff *skb)
 {
 	if (ring_uses_build_skb(rx_ring)) {
-		unsigned long offset = (unsigned long)(skb->data) & ~PAGE_MASK;
+		unsigned long mask = (unsigned long)ixgbe_rx_pg_size(rx_ring) - 1;
+		unsigned long offset = (unsigned long)(skb->data) & mask;
 
 		dma_sync_single_range_for_cpu(rx_ring->dev,
 					      IXGBE_CB(skb)->dma,
@@ -10572,6 +10573,7 @@ static int ixgbe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	disable_dev = !test_and_set_bit(__IXGBE_DISABLED, &adapter->state);
 	free_netdev(netdev);
 err_alloc_etherdev:
+	pci_disable_pcie_error_reporting(pdev);
 	pci_release_mem_regions(pdev);
 err_pci_reg:
 err_dma:
diff --git a/drivers/net/ethernet/moxa/moxart_ether.c b/drivers/net/ethernet/moxa/moxart_ether.c
index beb730ff5d42..d126efd21e43 100644
--- a/drivers/net/ethernet/moxa/moxart_ether.c
+++ b/drivers/net/ethernet/moxa/moxart_ether.c
@@ -538,10 +538,8 @@ static int moxart_mac_probe(struct platform_device *pdev)
 	SET_NETDEV_DEV(ndev, &pdev->dev);
 
 	ret = register_netdev(ndev);
-	if (ret) {
-		free_netdev(ndev);
+	if (ret)
 		goto init_fail;
-	}
 
 	netdev_dbg(ndev, "%s: IRQ=%d address=%pM\n",
 		   __func__, ndev->irq, ndev->dev_addr);
diff --git a/drivers/net/ethernet/qualcomm/emac/emac.c b/drivers/net/ethernet/qualcomm/emac/emac.c
index 5ab83751a471..cae570f1d7e1 100644
--- a/drivers/net/ethernet/qualcomm/emac/emac.c
+++ b/drivers/net/ethernet/qualcomm/emac/emac.c
@@ -765,12 +765,13 @@ static int emac_remove(struct platform_device *pdev)
 
 	put_device(&adpt->phydev->mdio.dev);
 	mdiobus_unregister(adpt->mii_bus);
-	free_netdev(netdev);
 
 	if (adpt->phy.digital)
 		iounmap(adpt->phy.digital);
 	iounmap(adpt->phy.base);
 
+	free_netdev(netdev);
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/ti/tlan.c b/drivers/net/ethernet/ti/tlan.c
index 5ffc55f8fa75..1ce2947eaf2b 100644
--- a/drivers/net/ethernet/ti/tlan.c
+++ b/drivers/net/ethernet/ti/tlan.c
@@ -313,9 +313,8 @@ static void tlan_remove_one(struct pci_dev *pdev)
 	pci_release_regions(pdev);
 #endif
 
-	free_netdev(dev);
-
 	cancel_work_sync(&priv->tlan_tqueue);
+	free_netdev(dev);
 }
 
 static void tlan_start(struct net_device *dev)
diff --git a/drivers/reset/reset-ti-syscon.c b/drivers/reset/reset-ti-syscon.c
index 99520b0a1329..3d375747c4e6 100644
--- a/drivers/reset/reset-ti-syscon.c
+++ b/drivers/reset/reset-ti-syscon.c
@@ -58,8 +58,8 @@ struct ti_syscon_reset_data {
 	unsigned int nr_controls;
 };
 
-#define to_ti_syscon_reset_data(rcdev)	\
-	container_of(rcdev, struct ti_syscon_reset_data, rcdev)
+#define to_ti_syscon_reset_data(_rcdev)	\
+	container_of(_rcdev, struct ti_syscon_reset_data, rcdev)
 
 /**
  * ti_syscon_reset_assert() - assert device reset
diff --git a/drivers/rtc/rtc-max77686.c b/drivers/rtc/rtc-max77686.c
index 182fdd00e290..ecd61573dd31 100644
--- a/drivers/rtc/rtc-max77686.c
+++ b/drivers/rtc/rtc-max77686.c
@@ -718,8 +718,8 @@ static int max77686_init_rtc_regmap(struct max77686_rtc_info *info)
 
 add_rtc_irq:
 	ret = regmap_add_irq_chip(info->rtc_regmap, info->rtc_irq,
-				  IRQF_TRIGGER_FALLING | IRQF_ONESHOT |
-				  IRQF_SHARED, 0, info->drv_data->rtc_irq_chip,
+				  IRQF_ONESHOT | IRQF_SHARED,
+				  0, info->drv_data->rtc_irq_chip,
 				  &info->rtc_irq_data);
 	if (ret < 0) {
 		dev_err(info->dev, "Failed to add RTC irq chip: %d\n", ret);
diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/aic7xxx_core.c
index fdbb0a3dc9b4..6929aa13adc3 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_core.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_core.c
@@ -500,7 +500,7 @@ ahc_inq(struct ahc_softc *ahc, u_int port)
 	return ((ahc_inb(ahc, port))
 	      | (ahc_inb(ahc, port+1) << 8)
 	      | (ahc_inb(ahc, port+2) << 16)
-	      | (ahc_inb(ahc, port+3) << 24)
+	      | (((uint64_t)ahc_inb(ahc, port+3)) << 24)
 	      | (((uint64_t)ahc_inb(ahc, port+4)) << 32)
 	      | (((uint64_t)ahc_inb(ahc, port+5)) << 40)
 	      | (((uint64_t)ahc_inb(ahc, port+6)) << 48)
diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 669cf3553a77..ef2fa6b10a9c 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -1174,6 +1174,7 @@ static void fc_rport_prli_resp(struct fc_seq *sp, struct fc_frame *fp,
 		resp_code = (pp->spp.spp_flags & FC_SPP_RESP_MASK);
 		FC_RPORT_DBG(rdata, "PRLI spp_flags = 0x%x spp_type 0x%x\n",
 			     pp->spp.spp_flags, pp->spp.spp_type);
+
 		rdata->spp_type = pp->spp.spp_type;
 		if (resp_code != FC_SPP_RESP_ACK) {
 			if (resp_code == FC_SPP_RESP_CONF)
@@ -1194,11 +1195,13 @@ static void fc_rport_prli_resp(struct fc_seq *sp, struct fc_frame *fp,
 		/*
 		 * Call prli provider if we should act as a target
 		 */
-		prov = fc_passive_prov[rdata->spp_type];
-		if (prov) {
-			memset(&temp_spp, 0, sizeof(temp_spp));
-			prov->prli(rdata, pp->prli.prli_spp_len,
-				   &pp->spp, &temp_spp);
+		if (rdata->spp_type < FC_FC4_PROV_SIZE) {
+			prov = fc_passive_prov[rdata->spp_type];
+			if (prov) {
+				memset(&temp_spp, 0, sizeof(temp_spp));
+				prov->prli(rdata, pp->prli.prli_spp_len,
+					   &pp->spp, &temp_spp);
+			}
 		}
 		/*
 		 * Check if the image pair could be established
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 95c61fb4b81b..064c941e5483 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -427,39 +427,10 @@ static umode_t iscsi_iface_attr_is_visible(struct kobject *kobj,
 	struct device *dev = container_of(kobj, struct device, kobj);
 	struct iscsi_iface *iface = iscsi_dev_to_iface(dev);
 	struct iscsi_transport *t = iface->transport;
-	int param;
-	int param_type;
+	int param = -1;
 
 	if (attr == &dev_attr_iface_enabled.attr)
 		param = ISCSI_NET_PARAM_IFACE_ENABLE;
-	else if (attr == &dev_attr_iface_vlan_id.attr)
-		param = ISCSI_NET_PARAM_VLAN_ID;
-	else if (attr == &dev_attr_iface_vlan_priority.attr)
-		param = ISCSI_NET_PARAM_VLAN_PRIORITY;
-	else if (attr == &dev_attr_iface_vlan_enabled.attr)
-		param = ISCSI_NET_PARAM_VLAN_ENABLED;
-	else if (attr == &dev_attr_iface_mtu.attr)
-		param = ISCSI_NET_PARAM_MTU;
-	else if (attr == &dev_attr_iface_port.attr)
-		param = ISCSI_NET_PARAM_PORT;
-	else if (attr == &dev_attr_iface_ipaddress_state.attr)
-		param = ISCSI_NET_PARAM_IPADDR_STATE;
-	else if (attr == &dev_attr_iface_delayed_ack_en.attr)
-		param = ISCSI_NET_PARAM_DELAYED_ACK_EN;
-	else if (attr == &dev_attr_iface_tcp_nagle_disable.attr)
-		param = ISCSI_NET_PARAM_TCP_NAGLE_DISABLE;
-	else if (attr == &dev_attr_iface_tcp_wsf_disable.attr)
-		param = ISCSI_NET_PARAM_TCP_WSF_DISABLE;
-	else if (attr == &dev_attr_iface_tcp_wsf.attr)
-		param = ISCSI_NET_PARAM_TCP_WSF;
-	else if (attr == &dev_attr_iface_tcp_timer_scale.attr)
-		param = ISCSI_NET_PARAM_TCP_TIMER_SCALE;
-	else if (attr == &dev_attr_iface_tcp_timestamp_en.attr)
-		param = ISCSI_NET_PARAM_TCP_TIMESTAMP_EN;
-	else if (attr == &dev_attr_iface_cache_id.attr)
-		param = ISCSI_NET_PARAM_CACHE_ID;
-	else if (attr == &dev_attr_iface_redirect_en.attr)
-		param = ISCSI_NET_PARAM_REDIRECT_EN;
 	else if (attr == &dev_attr_iface_def_taskmgmt_tmo.attr)
 		param = ISCSI_IFACE_PARAM_DEF_TASKMGMT_TMO;
 	else if (attr == &dev_attr_iface_header_digest.attr)
@@ -496,6 +467,38 @@ static umode_t iscsi_iface_attr_is_visible(struct kobject *kobj,
 		param = ISCSI_IFACE_PARAM_STRICT_LOGIN_COMP_EN;
 	else if (attr == &dev_attr_iface_initiator_name.attr)
 		param = ISCSI_IFACE_PARAM_INITIATOR_NAME;
+
+	if (param != -1)
+		return t->attr_is_visible(ISCSI_IFACE_PARAM, param);
+
+	if (attr == &dev_attr_iface_vlan_id.attr)
+		param = ISCSI_NET_PARAM_VLAN_ID;
+	else if (attr == &dev_attr_iface_vlan_priority.attr)
+		param = ISCSI_NET_PARAM_VLAN_PRIORITY;
+	else if (attr == &dev_attr_iface_vlan_enabled.attr)
+		param = ISCSI_NET_PARAM_VLAN_ENABLED;
+	else if (attr == &dev_attr_iface_mtu.attr)
+		param = ISCSI_NET_PARAM_MTU;
+	else if (attr == &dev_attr_iface_port.attr)
+		param = ISCSI_NET_PARAM_PORT;
+	else if (attr == &dev_attr_iface_ipaddress_state.attr)
+		param = ISCSI_NET_PARAM_IPADDR_STATE;
+	else if (attr == &dev_attr_iface_delayed_ack_en.attr)
+		param = ISCSI_NET_PARAM_DELAYED_ACK_EN;
+	else if (attr == &dev_attr_iface_tcp_nagle_disable.attr)
+		param = ISCSI_NET_PARAM_TCP_NAGLE_DISABLE;
+	else if (attr == &dev_attr_iface_tcp_wsf_disable.attr)
+		param = ISCSI_NET_PARAM_TCP_WSF_DISABLE;
+	else if (attr == &dev_attr_iface_tcp_wsf.attr)
+		param = ISCSI_NET_PARAM_TCP_WSF;
+	else if (attr == &dev_attr_iface_tcp_timer_scale.attr)
+		param = ISCSI_NET_PARAM_TCP_TIMER_SCALE;
+	else if (attr == &dev_attr_iface_tcp_timestamp_en.attr)
+		param = ISCSI_NET_PARAM_TCP_TIMESTAMP_EN;
+	else if (attr == &dev_attr_iface_cache_id.attr)
+		param = ISCSI_NET_PARAM_CACHE_ID;
+	else if (attr == &dev_attr_iface_redirect_en.attr)
+		param = ISCSI_NET_PARAM_REDIRECT_EN;
 	else if (iface->iface_type == ISCSI_IFACE_TYPE_IPV4) {
 		if (attr == &dev_attr_ipv4_iface_ipaddress.attr)
 			param = ISCSI_NET_PARAM_IPV4_ADDR;
@@ -586,32 +589,7 @@ static umode_t iscsi_iface_attr_is_visible(struct kobject *kobj,
 		return 0;
 	}
 
-	switch (param) {
-	case ISCSI_IFACE_PARAM_DEF_TASKMGMT_TMO:
-	case ISCSI_IFACE_PARAM_HDRDGST_EN:
-	case ISCSI_IFACE_PARAM_DATADGST_EN:
-	case ISCSI_IFACE_PARAM_IMM_DATA_EN:
-	case ISCSI_IFACE_PARAM_INITIAL_R2T_EN:
-	case ISCSI_IFACE_PARAM_DATASEQ_INORDER_EN:
-	case ISCSI_IFACE_PARAM_PDU_INORDER_EN:
-	case ISCSI_IFACE_PARAM_ERL:
-	case ISCSI_IFACE_PARAM_MAX_RECV_DLENGTH:
-	case ISCSI_IFACE_PARAM_FIRST_BURST:
-	case ISCSI_IFACE_PARAM_MAX_R2T:
-	case ISCSI_IFACE_PARAM_MAX_BURST:
-	case ISCSI_IFACE_PARAM_CHAP_AUTH_EN:
-	case ISCSI_IFACE_PARAM_BIDI_CHAP_EN:
-	case ISCSI_IFACE_PARAM_DISCOVERY_AUTH_OPTIONAL:
-	case ISCSI_IFACE_PARAM_DISCOVERY_LOGOUT_EN:
-	case ISCSI_IFACE_PARAM_STRICT_LOGIN_COMP_EN:
-	case ISCSI_IFACE_PARAM_INITIATOR_NAME:
-		param_type = ISCSI_IFACE_PARAM;
-		break;
-	default:
-		param_type = ISCSI_NET_PARAM;
-	}
-
-	return t->attr_is_visible(param_type, param);
+	return t->attr_is_visible(ISCSI_NET_PARAM, param);
 }
 
 static struct attribute *iscsi_iface_attrs[] = {
diff --git a/drivers/spi/spi-cadence.c b/drivers/spi/spi-cadence.c
index 9ed5f0010e44..d9aeb9efa7aa 100644
--- a/drivers/spi/spi-cadence.c
+++ b/drivers/spi/spi-cadence.c
@@ -585,6 +585,12 @@ static int cdns_spi_probe(struct platform_device *pdev)
 		goto clk_dis_apb;
 	}
 
+	pm_runtime_use_autosuspend(&pdev->dev);
+	pm_runtime_set_autosuspend_delay(&pdev->dev, SPI_AUTOSUSPEND_TIMEOUT);
+	pm_runtime_get_noresume(&pdev->dev);
+	pm_runtime_set_active(&pdev->dev);
+	pm_runtime_enable(&pdev->dev);
+
 	ret = of_property_read_u32(pdev->dev.of_node, "num-cs", &num_cs);
 	if (ret < 0)
 		master->num_chipselect = CDNS_SPI_DEFAULT_NUM_CS;
@@ -599,11 +605,6 @@ static int cdns_spi_probe(struct platform_device *pdev)
 	/* SPI controller initializations */
 	cdns_spi_init_hw(xspi);
 
-	pm_runtime_set_active(&pdev->dev);
-	pm_runtime_enable(&pdev->dev);
-	pm_runtime_use_autosuspend(&pdev->dev);
-	pm_runtime_set_autosuspend_delay(&pdev->dev, SPI_AUTOSUSPEND_TIMEOUT);
-
 	irq = platform_get_irq(pdev, 0);
 	if (irq <= 0) {
 		ret = -ENXIO;
@@ -636,6 +637,9 @@ static int cdns_spi_probe(struct platform_device *pdev)
 
 	master->bits_per_word_mask = SPI_BPW_MASK(8);
 
+	pm_runtime_mark_last_busy(&pdev->dev);
+	pm_runtime_put_autosuspend(&pdev->dev);
+
 	ret = spi_register_master(master);
 	if (ret) {
 		dev_err(&pdev->dev, "spi_register_master failed\n");
diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
index befabddf897a..ed114f00a6d1 100644
--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -1057,11 +1057,13 @@ static int dspi_probe(struct platform_device *pdev)
 	ret = spi_register_master(master);
 	if (ret != 0) {
 		dev_err(&pdev->dev, "Problem registering DSPI master\n");
-		goto out_free_irq;
+		goto out_release_dma;
 	}
 
 	return ret;
 
+out_release_dma:
+	dspi_release_dma(dspi);
 out_free_irq:
 	if (dspi->irq)
 		free_irq(dspi->irq, dspi);
diff --git a/drivers/spi/spi-mt65xx.c b/drivers/spi/spi-mt65xx.c
index da28c52c9da1..e2b171057b3b 100644
--- a/drivers/spi/spi-mt65xx.c
+++ b/drivers/spi/spi-mt65xx.c
@@ -392,13 +392,23 @@ static int mtk_spi_fifo_transfer(struct spi_master *master,
 	mtk_spi_setup_packet(master);
 
 	cnt = xfer->len / 4;
-	iowrite32_rep(mdata->base + SPI_TX_DATA_REG, xfer->tx_buf, cnt);
+	if (xfer->tx_buf)
+		iowrite32_rep(mdata->base + SPI_TX_DATA_REG, xfer->tx_buf, cnt);
+
+	if (xfer->rx_buf)
+		ioread32_rep(mdata->base + SPI_RX_DATA_REG, xfer->rx_buf, cnt);
 
 	remainder = xfer->len % 4;
 	if (remainder > 0) {
 		reg_val = 0;
-		memcpy(&reg_val, xfer->tx_buf + (cnt * 4), remainder);
-		writel(reg_val, mdata->base + SPI_TX_DATA_REG);
+		if (xfer->tx_buf) {
+			memcpy(&reg_val, xfer->tx_buf + (cnt * 4), remainder);
+			writel(reg_val, mdata->base + SPI_TX_DATA_REG);
+		}
+		if (xfer->rx_buf) {
+			reg_val = readl(mdata->base + SPI_RX_DATA_REG);
+			memcpy(xfer->rx_buf + (cnt * 4), &reg_val, remainder);
+		}
 	}
 
 	mtk_spi_enable_transfer(master);
diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 750a04ed0e93..bf05701f78b3 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -38,7 +38,7 @@
 #include "target_core_alua.h"
 
 static sense_reason_t
-sbc_check_prot(struct se_device *, struct se_cmd *, unsigned char *, u32, bool);
+sbc_check_prot(struct se_device *, struct se_cmd *, unsigned char, u32, bool);
 static sense_reason_t sbc_execute_unmap(struct se_cmd *cmd);
 
 static sense_reason_t
@@ -292,14 +292,14 @@ static inline unsigned long long transport_lba_64_ext(unsigned char *cdb)
 }
 
 static sense_reason_t
-sbc_setup_write_same(struct se_cmd *cmd, unsigned char *flags, struct sbc_ops *ops)
+sbc_setup_write_same(struct se_cmd *cmd, unsigned char flags, struct sbc_ops *ops)
 {
 	struct se_device *dev = cmd->se_dev;
 	sector_t end_lba = dev->transport->get_blocks(dev) + 1;
 	unsigned int sectors = sbc_get_write_same_sectors(cmd);
 	sense_reason_t ret;
 
-	if ((flags[0] & 0x04) || (flags[0] & 0x02)) {
+	if ((flags & 0x04) || (flags & 0x02)) {
 		pr_err("WRITE_SAME PBDATA and LBDATA"
 			" bits not supported for Block Discard"
 			" Emulation\n");
@@ -321,7 +321,7 @@ sbc_setup_write_same(struct se_cmd *cmd, unsigned char *flags, struct sbc_ops *o
 	}
 
 	/* We always have ANC_SUP == 0 so setting ANCHOR is always an error */
-	if (flags[0] & 0x10) {
+	if (flags & 0x10) {
 		pr_warn("WRITE SAME with ANCHOR not supported\n");
 		return TCM_INVALID_CDB_FIELD;
 	}
@@ -329,7 +329,7 @@ sbc_setup_write_same(struct se_cmd *cmd, unsigned char *flags, struct sbc_ops *o
 	 * Special case for WRITE_SAME w/ UNMAP=1 that ends up getting
 	 * translated into block discard requests within backend code.
 	 */
-	if (flags[0] & 0x08) {
+	if (flags & 0x08) {
 		if (!ops->execute_unmap)
 			return TCM_UNSUPPORTED_SCSI_OPCODE;
 
@@ -344,7 +344,7 @@ sbc_setup_write_same(struct se_cmd *cmd, unsigned char *flags, struct sbc_ops *o
 	if (!ops->execute_write_same)
 		return TCM_UNSUPPORTED_SCSI_OPCODE;
 
-	ret = sbc_check_prot(dev, cmd, &cmd->t_task_cdb[0], sectors, true);
+	ret = sbc_check_prot(dev, cmd, flags >> 5, sectors, true);
 	if (ret)
 		return ret;
 
@@ -702,10 +702,9 @@ sbc_set_prot_op_checks(u8 protect, bool fabric_prot, enum target_prot_type prot_
 }
 
 static sense_reason_t
-sbc_check_prot(struct se_device *dev, struct se_cmd *cmd, unsigned char *cdb,
+sbc_check_prot(struct se_device *dev, struct se_cmd *cmd, unsigned char protect,
 	       u32 sectors, bool is_write)
 {
-	u8 protect = cdb[1] >> 5;
 	int sp_ops = cmd->se_sess->sup_prot_ops;
 	int pi_prot_type = dev->dev_attrib.pi_prot_type;
 	bool fabric_prot = false;
@@ -753,7 +752,7 @@ sbc_check_prot(struct se_device *dev, struct se_cmd *cmd, unsigned char *cdb,
 		/* Fallthrough */
 	default:
 		pr_err("Unable to determine pi_prot_type for CDB: 0x%02x "
-		       "PROTECT: 0x%02x\n", cdb[0], protect);
+		       "PROTECT: 0x%02x\n", cmd->t_task_cdb[0], protect);
 		return TCM_INVALID_CDB_FIELD;
 	}
 
@@ -828,7 +827,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		if (sbc_check_dpofua(dev, cmd, cdb))
 			return TCM_INVALID_CDB_FIELD;
 
-		ret = sbc_check_prot(dev, cmd, cdb, sectors, false);
+		ret = sbc_check_prot(dev, cmd, cdb[1] >> 5, sectors, false);
 		if (ret)
 			return ret;
 
@@ -842,7 +841,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		if (sbc_check_dpofua(dev, cmd, cdb))
 			return TCM_INVALID_CDB_FIELD;
 
-		ret = sbc_check_prot(dev, cmd, cdb, sectors, false);
+		ret = sbc_check_prot(dev, cmd, cdb[1] >> 5, sectors, false);
 		if (ret)
 			return ret;
 
@@ -856,7 +855,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		if (sbc_check_dpofua(dev, cmd, cdb))
 			return TCM_INVALID_CDB_FIELD;
 
-		ret = sbc_check_prot(dev, cmd, cdb, sectors, false);
+		ret = sbc_check_prot(dev, cmd, cdb[1] >> 5, sectors, false);
 		if (ret)
 			return ret;
 
@@ -877,7 +876,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		if (sbc_check_dpofua(dev, cmd, cdb))
 			return TCM_INVALID_CDB_FIELD;
 
-		ret = sbc_check_prot(dev, cmd, cdb, sectors, true);
+		ret = sbc_check_prot(dev, cmd, cdb[1] >> 5, sectors, true);
 		if (ret)
 			return ret;
 
@@ -891,7 +890,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		if (sbc_check_dpofua(dev, cmd, cdb))
 			return TCM_INVALID_CDB_FIELD;
 
-		ret = sbc_check_prot(dev, cmd, cdb, sectors, true);
+		ret = sbc_check_prot(dev, cmd, cdb[1] >> 5, sectors, true);
 		if (ret)
 			return ret;
 
@@ -906,7 +905,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		if (sbc_check_dpofua(dev, cmd, cdb))
 			return TCM_INVALID_CDB_FIELD;
 
-		ret = sbc_check_prot(dev, cmd, cdb, sectors, true);
+		ret = sbc_check_prot(dev, cmd, cdb[1] >> 5, sectors, true);
 		if (ret)
 			return ret;
 
@@ -965,7 +964,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 			size = sbc_get_size(cmd, 1);
 			cmd->t_task_lba = get_unaligned_be64(&cdb[12]);
 
-			ret = sbc_setup_write_same(cmd, &cdb[10], ops);
+			ret = sbc_setup_write_same(cmd, cdb[10], ops);
 			if (ret)
 				return ret;
 			break;
@@ -1063,7 +1062,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		size = sbc_get_size(cmd, 1);
 		cmd->t_task_lba = get_unaligned_be64(&cdb[2]);
 
-		ret = sbc_setup_write_same(cmd, &cdb[1], ops);
+		ret = sbc_setup_write_same(cmd, cdb[1], ops);
 		if (ret)
 			return ret;
 		break;
@@ -1081,7 +1080,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		 * Follow sbcr26 with WRITE_SAME (10) and check for the existence
 		 * of byte 1 bit 3 UNMAP instead of original reserved field
 		 */
-		ret = sbc_setup_write_same(cmd, &cdb[1], ops);
+		ret = sbc_setup_write_same(cmd, cdb[1], ops);
 		if (ret)
 			return ret;
 		break;
diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index fcefafe7df48..2db83b555e59 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -1304,7 +1304,7 @@ thermal_zone_device_register(const char *type, int trips, int mask,
 EXPORT_SYMBOL_GPL(thermal_zone_device_register);
 
 /**
- * thermal_device_unregister - removes the registered thermal zone device
+ * thermal_zone_device_unregister - removes the registered thermal zone device
  * @tz: the thermal zone device to remove
  */
 void thermal_zone_device_unregister(struct thermal_zone_device *tz)
diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 276a63ae510e..6c555a50646a 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -3903,6 +3903,47 @@ static int usb_set_lpm_timeout(struct usb_device *udev,
 	return 0;
 }
 
+/*
+ * Don't allow device intiated U1/U2 if the system exit latency + one bus
+ * interval is greater than the minimum service interval of any active
+ * periodic endpoint. See USB 3.2 section 9.4.9
+ */
+static bool usb_device_may_initiate_lpm(struct usb_device *udev,
+					enum usb3_link_state state)
+{
+	unsigned int sel;		/* us */
+	int i, j;
+
+	if (state == USB3_LPM_U1)
+		sel = DIV_ROUND_UP(udev->u1_params.sel, 1000);
+	else if (state == USB3_LPM_U2)
+		sel = DIV_ROUND_UP(udev->u2_params.sel, 1000);
+	else
+		return false;
+
+	for (i = 0; i < udev->actconfig->desc.bNumInterfaces; i++) {
+		struct usb_interface *intf;
+		struct usb_endpoint_descriptor *desc;
+		unsigned int interval;
+
+		intf = udev->actconfig->interface[i];
+		if (!intf)
+			continue;
+
+		for (j = 0; j < intf->cur_altsetting->desc.bNumEndpoints; j++) {
+			desc = &intf->cur_altsetting->endpoint[j].desc;
+
+			if (usb_endpoint_xfer_int(desc) ||
+			    usb_endpoint_xfer_isoc(desc)) {
+				interval = (1 << (desc->bInterval - 1)) * 125;
+				if (sel + 125 > interval)
+					return false;
+			}
+		}
+	}
+	return true;
+}
+
 /*
  * Enable the hub-initiated U1/U2 idle timeouts, and enable device-initiated
  * U1/U2 entry.
@@ -3975,20 +4016,23 @@ static void usb_enable_link_state(struct usb_hcd *hcd, struct usb_device *udev,
 	 * U1/U2_ENABLE
 	 */
 	if (udev->actconfig &&
-	    usb_set_device_initiated_lpm(udev, state, true) == 0) {
-		if (state == USB3_LPM_U1)
-			udev->usb3_lpm_u1_enabled = 1;
-		else if (state == USB3_LPM_U2)
-			udev->usb3_lpm_u2_enabled = 1;
-	} else {
-		/* Don't request U1/U2 entry if the device
-		 * cannot transition to U1/U2.
-		 */
-		usb_set_lpm_timeout(udev, state, 0);
-		hcd->driver->disable_usb3_lpm_timeout(hcd, udev, state);
+	    usb_device_may_initiate_lpm(udev, state)) {
+		if (usb_set_device_initiated_lpm(udev, state, true)) {
+			/*
+			 * Request to enable device initiated U1/U2 failed,
+			 * better to turn off lpm in this case.
+			 */
+			usb_set_lpm_timeout(udev, state, 0);
+			hcd->driver->disable_usb3_lpm_timeout(hcd, udev, state);
+			return;
+		}
 	}
-}
 
+	if (state == USB3_LPM_U1)
+		udev->usb3_lpm_u1_enabled = 1;
+	else if (state == USB3_LPM_U2)
+		udev->usb3_lpm_u2_enabled = 1;
+}
 /*
  * Disable the hub-initiated U1/U2 idle timeouts, and disable device-initiated
  * U1/U2 entry.
diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index 3dfd584a1ef3..2ca6ed207e26 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -325,10 +325,6 @@ static const struct usb_device_id usb_quirk_list[] = {
 	/* DJI CineSSD */
 	{ USB_DEVICE(0x2ca3, 0x0031), .driver_info = USB_QUIRK_NO_LPM },
 
-	/* Fibocom L850-GL LTE Modem */
-	{ USB_DEVICE(0x2cb7, 0x0007), .driver_info =
-			USB_QUIRK_IGNORE_REMOTE_WAKEUP },
-
 	/* INTEL VALUE SSD */
 	{ USB_DEVICE(0x8086, 0xf1a5), .driver_info = USB_QUIRK_RESET_RESUME },
 
diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
index 6790c0a18123..f1edc5727000 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -2702,12 +2702,14 @@ static void dwc2_hsotg_complete_in(struct dwc2_hsotg *hsotg,
 		return;
 	}
 
-	/* Zlp for all endpoints, for ep0 only in DATA IN stage */
+	/* Zlp for all endpoints in non DDMA, for ep0 only in DATA IN stage */
 	if (hs_ep->send_zlp) {
-		dwc2_hsotg_program_zlp(hsotg, hs_ep);
 		hs_ep->send_zlp = 0;
-		/* transfer will be completed on next complete interrupt */
-		return;
+		if (!using_desc_dma(hsotg)) {
+			dwc2_hsotg_program_zlp(hsotg, hs_ep);
+			/* transfer will be completed on next complete interrupt */
+			return;
+		}
 	}
 
 	if (hs_ep->index == 0 && hsotg->ep0_state == DWC2_EP0_DATA_IN) {
diff --git a/drivers/usb/host/max3421-hcd.c b/drivers/usb/host/max3421-hcd.c
index 0ece9a9341e5..1c047f28c88e 100644
--- a/drivers/usb/host/max3421-hcd.c
+++ b/drivers/usb/host/max3421-hcd.c
@@ -149,8 +149,6 @@ struct max3421_hcd {
 	 */
 	struct urb *curr_urb;
 	enum scheduling_pass sched_pass;
-	struct usb_device *loaded_dev;	/* dev that's loaded into the chip */
-	int loaded_epnum;		/* epnum whose toggles are loaded */
 	int urb_done;			/* > 0 -> no errors, < 0: errno */
 	size_t curr_len;
 	u8 hien;
@@ -488,39 +486,17 @@ max3421_set_speed(struct usb_hcd *hcd, struct usb_device *dev)
  * Caller must NOT hold HCD spinlock.
  */
 static void
-max3421_set_address(struct usb_hcd *hcd, struct usb_device *dev, int epnum,
-		    int force_toggles)
+max3421_set_address(struct usb_hcd *hcd, struct usb_device *dev, int epnum)
 {
-	struct max3421_hcd *max3421_hcd = hcd_to_max3421(hcd);
-	int old_epnum, same_ep, rcvtog, sndtog;
-	struct usb_device *old_dev;
+	int rcvtog, sndtog;
 	u8 hctl;
 
-	old_dev = max3421_hcd->loaded_dev;
-	old_epnum = max3421_hcd->loaded_epnum;
-
-	same_ep = (dev == old_dev && epnum == old_epnum);
-	if (same_ep && !force_toggles)
-		return;
-
-	if (old_dev && !same_ep) {
-		/* save the old end-points toggles: */
-		u8 hrsl = spi_rd8(hcd, MAX3421_REG_HRSL);
-
-		rcvtog = (hrsl >> MAX3421_HRSL_RCVTOGRD_BIT) & 1;
-		sndtog = (hrsl >> MAX3421_HRSL_SNDTOGRD_BIT) & 1;
-
-		/* no locking: HCD (i.e., we) own toggles, don't we? */
-		usb_settoggle(old_dev, old_epnum, 0, rcvtog);
-		usb_settoggle(old_dev, old_epnum, 1, sndtog);
-	}
 	/* setup new endpoint's toggle bits: */
 	rcvtog = usb_gettoggle(dev, epnum, 0);
 	sndtog = usb_gettoggle(dev, epnum, 1);
 	hctl = (BIT(rcvtog + MAX3421_HCTL_RCVTOG0_BIT) |
 		BIT(sndtog + MAX3421_HCTL_SNDTOG0_BIT));
 
-	max3421_hcd->loaded_epnum = epnum;
 	spi_wr8(hcd, MAX3421_REG_HCTL, hctl);
 
 	/*
@@ -528,7 +504,6 @@ max3421_set_address(struct usb_hcd *hcd, struct usb_device *dev, int epnum,
 	 * address-assignment so it's best to just always load the
 	 * address whenever the end-point changed/was forced.
 	 */
-	max3421_hcd->loaded_dev = dev;
 	spi_wr8(hcd, MAX3421_REG_PERADDR, dev->devnum);
 }
 
@@ -663,7 +638,7 @@ max3421_select_and_start_urb(struct usb_hcd *hcd)
 	struct max3421_hcd *max3421_hcd = hcd_to_max3421(hcd);
 	struct urb *urb, *curr_urb = NULL;
 	struct max3421_ep *max3421_ep;
-	int epnum, force_toggles = 0;
+	int epnum;
 	struct usb_host_endpoint *ep;
 	struct list_head *pos;
 	unsigned long flags;
@@ -773,7 +748,6 @@ max3421_select_and_start_urb(struct usb_hcd *hcd)
 			usb_settoggle(urb->dev, epnum, 0, 1);
 			usb_settoggle(urb->dev, epnum, 1, 1);
 			max3421_ep->pkt_state = PKT_STATE_SETUP;
-			force_toggles = 1;
 		} else
 			max3421_ep->pkt_state = PKT_STATE_TRANSFER;
 	}
@@ -781,7 +755,7 @@ max3421_select_and_start_urb(struct usb_hcd *hcd)
 	spin_unlock_irqrestore(&max3421_hcd->lock, flags);
 
 	max3421_ep->last_active = max3421_hcd->frame_number;
-	max3421_set_address(hcd, urb->dev, epnum, force_toggles);
+	max3421_set_address(hcd, urb->dev, epnum);
 	max3421_set_speed(hcd, urb->dev);
 	max3421_next_transfer(hcd, 0);
 	return 1;
@@ -1376,6 +1350,16 @@ max3421_urb_done(struct usb_hcd *hcd)
 		status = 0;
 	urb = max3421_hcd->curr_urb;
 	if (urb) {
+		/* save the old end-points toggles: */
+		u8 hrsl = spi_rd8(hcd, MAX3421_REG_HRSL);
+		int rcvtog = (hrsl >> MAX3421_HRSL_RCVTOGRD_BIT) & 1;
+		int sndtog = (hrsl >> MAX3421_HRSL_SNDTOGRD_BIT) & 1;
+		int epnum = usb_endpoint_num(&urb->ep->desc);
+
+		/* no locking: HCD (i.e., we) own toggles, don't we? */
+		usb_settoggle(urb->dev, epnum, 0, rcvtog);
+		usb_settoggle(urb->dev, epnum, 1, sndtog);
+
 		max3421_hcd->curr_urb = NULL;
 		spin_lock_irqsave(&max3421_hcd->lock, flags);
 		usb_hcd_unlink_urb_from_ep(hcd, urb);
diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
index 7f1685a54514..65a930b3722e 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -1450,11 +1450,12 @@ int xhci_hub_status_data(struct usb_hcd *hcd, char *buf)
 	 * Inform the usbcore about resume-in-progress by returning
 	 * a non-zero value even if there are no status changes.
 	 */
+	spin_lock_irqsave(&xhci->lock, flags);
+
 	status = bus_state->resuming_ports;
 
 	mask = PORT_CSC | PORT_PEC | PORT_OCC | PORT_PLC | PORT_WRC | PORT_CEC;
 
-	spin_lock_irqsave(&xhci->lock, flags);
 	/* For each port, did anything change?  If so, set that bit in buf. */
 	for (i = 0; i < max_ports; i++) {
 		temp = readl(port_array[i]);
diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 748d4c69cb28..420ad7dc4fe8 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -444,6 +444,26 @@ static void ring_doorbell_for_active_rings(struct xhci_hcd *xhci,
 	}
 }
 
+static struct xhci_virt_ep *xhci_get_virt_ep(struct xhci_hcd *xhci,
+					     unsigned int slot_id,
+					     unsigned int ep_index)
+{
+	if (slot_id == 0 || slot_id >= MAX_HC_SLOTS) {
+		xhci_warn(xhci, "Invalid slot_id %u\n", slot_id);
+		return NULL;
+	}
+	if (ep_index >= EP_CTX_PER_DEV) {
+		xhci_warn(xhci, "Invalid endpoint index %u\n", ep_index);
+		return NULL;
+	}
+	if (!xhci->devs[slot_id]) {
+		xhci_warn(xhci, "No xhci virt device for slot_id %u\n", slot_id);
+		return NULL;
+	}
+
+	return &xhci->devs[slot_id]->eps[ep_index];
+}
+
 /* Get the right ring for the given slot_id, ep_index and stream_id.
  * If the endpoint supports streams, boundary check the URB's stream ID.
  * If the endpoint doesn't support streams, return the singular endpoint ring.
@@ -454,7 +474,10 @@ struct xhci_ring *xhci_triad_to_transfer_ring(struct xhci_hcd *xhci,
 {
 	struct xhci_virt_ep *ep;
 
-	ep = &xhci->devs[slot_id]->eps[ep_index];
+	ep = xhci_get_virt_ep(xhci, slot_id, ep_index);
+	if (!ep)
+		return NULL;
+
 	/* Common case: no streams */
 	if (!(ep->ep_state & EP_HAS_STREAMS))
 		return ep->ring;
@@ -729,11 +752,14 @@ static void xhci_handle_cmd_stop_ep(struct xhci_hcd *xhci, int slot_id,
 	memset(&deq_state, 0, sizeof(deq_state));
 	ep_index = TRB_TO_EP_INDEX(le32_to_cpu(trb->generic.field[3]));
 
+	ep = xhci_get_virt_ep(xhci, slot_id, ep_index);
+	if (!ep)
+		return;
+
 	vdev = xhci->devs[slot_id];
 	ep_ctx = xhci_get_ep_ctx(xhci, vdev->out_ctx, ep_index);
 	trace_xhci_handle_cmd_stop_ep(ep_ctx);
 
-	ep = &xhci->devs[slot_id]->eps[ep_index];
 	last_unlinked_td = list_last_entry(&ep->cancelled_td_list,
 			struct xhci_td, cancelled_td_list);
 
@@ -1057,9 +1083,11 @@ static void xhci_handle_cmd_set_deq(struct xhci_hcd *xhci, int slot_id,
 
 	ep_index = TRB_TO_EP_INDEX(le32_to_cpu(trb->generic.field[3]));
 	stream_id = TRB_TO_STREAM_ID(le32_to_cpu(trb->generic.field[2]));
-	dev = xhci->devs[slot_id];
-	ep = &dev->eps[ep_index];
+	ep = xhci_get_virt_ep(xhci, slot_id, ep_index);
+	if (!ep)
+		return;
 
+	dev = xhci->devs[slot_id];
 	ep_ring = xhci_stream_id_to_ring(dev, ep_index, stream_id);
 	if (!ep_ring) {
 		xhci_warn(xhci, "WARN Set TR deq ptr command for freed stream ID %u\n",
@@ -1132,9 +1160,9 @@ static void xhci_handle_cmd_set_deq(struct xhci_hcd *xhci, int slot_id,
 	}
 
 cleanup:
-	dev->eps[ep_index].ep_state &= ~SET_DEQ_PENDING;
-	dev->eps[ep_index].queued_deq_seg = NULL;
-	dev->eps[ep_index].queued_deq_ptr = NULL;
+	ep->ep_state &= ~SET_DEQ_PENDING;
+	ep->queued_deq_seg = NULL;
+	ep->queued_deq_ptr = NULL;
 	/* Restart any rings with pending URBs */
 	ring_doorbell_for_active_rings(xhci, slot_id, ep_index);
 }
@@ -1143,10 +1171,15 @@ static void xhci_handle_cmd_reset_ep(struct xhci_hcd *xhci, int slot_id,
 		union xhci_trb *trb, u32 cmd_comp_code)
 {
 	struct xhci_virt_device *vdev;
+	struct xhci_virt_ep *ep;
 	struct xhci_ep_ctx *ep_ctx;
 	unsigned int ep_index;
 
 	ep_index = TRB_TO_EP_INDEX(le32_to_cpu(trb->generic.field[3]));
+	ep = xhci_get_virt_ep(xhci, slot_id, ep_index);
+	if (!ep)
+		return;
+
 	vdev = xhci->devs[slot_id];
 	ep_ctx = xhci_get_ep_ctx(xhci, vdev->out_ctx, ep_index);
 	trace_xhci_handle_cmd_reset_ep(ep_ctx);
@@ -1176,7 +1209,7 @@ static void xhci_handle_cmd_reset_ep(struct xhci_hcd *xhci, int slot_id,
 		xhci_ring_cmd_db(xhci);
 	} else {
 		/* Clear our internal halted state */
-		xhci->devs[slot_id]->eps[ep_index].ep_state &= ~EP_HALTED;
+		ep->ep_state &= ~EP_HALTED;
 	}
 }
 
@@ -2352,14 +2385,13 @@ static int handle_tx_event(struct xhci_hcd *xhci,
 	trb_comp_code = GET_COMP_CODE(le32_to_cpu(event->transfer_len));
 	ep_trb_dma = le64_to_cpu(event->buffer);
 
-	xdev = xhci->devs[slot_id];
-	if (!xdev) {
-		xhci_err(xhci, "ERROR Transfer event pointed to bad slot %u\n",
-			 slot_id);
+	ep = xhci_get_virt_ep(xhci, slot_id, ep_index);
+	if (!ep) {
+		xhci_err(xhci, "ERROR Invalid Transfer event\n");
 		goto err_out;
 	}
 
-	ep = &xdev->eps[ep_index];
+	xdev = xhci->devs[slot_id];
 	ep_ring = xhci_dma_to_transfer_ring(ep, ep_trb_dma);
 	ep_ctx = xhci_get_ep_ctx(xhci, xdev->out_ctx, ep_index);
 
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 8b52a7773bc8..300506de0c7a 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -991,6 +991,7 @@ struct xhci_interval_bw_table {
 	unsigned int		ss_bw_out;
 };
 
+#define EP_CTX_PER_DEV		31
 
 struct xhci_virt_device {
 	struct usb_device		*udev;
@@ -1005,7 +1006,7 @@ struct xhci_virt_device {
 	struct xhci_container_ctx       *out_ctx;
 	/* Used for addressing devices and configuration changes */
 	struct xhci_container_ctx       *in_ctx;
-	struct xhci_virt_ep		eps[31];
+	struct xhci_virt_ep		eps[EP_CTX_PER_DEV];
 	u8				fake_port;
 	u8				real_port;
 	struct xhci_interval_bw_table	*bw_table;
diff --git a/drivers/usb/renesas_usbhs/fifo.c b/drivers/usb/renesas_usbhs/fifo.c
index 3637d5edab74..e22aaed652ac 100644
--- a/drivers/usb/renesas_usbhs/fifo.c
+++ b/drivers/usb/renesas_usbhs/fifo.c
@@ -112,6 +112,8 @@ static struct dma_chan *usbhsf_dma_chan_get(struct usbhs_fifo *fifo,
 #define usbhsf_dma_map(p)	__usbhsf_dma_map_ctrl(p, 1)
 #define usbhsf_dma_unmap(p)	__usbhsf_dma_map_ctrl(p, 0)
 static int __usbhsf_dma_map_ctrl(struct usbhs_pkt *pkt, int map);
+static void usbhsf_tx_irq_ctrl(struct usbhs_pipe *pipe, int enable);
+static void usbhsf_rx_irq_ctrl(struct usbhs_pipe *pipe, int enable);
 struct usbhs_pkt *usbhs_pkt_pop(struct usbhs_pipe *pipe, struct usbhs_pkt *pkt)
 {
 	struct usbhs_priv *priv = usbhs_pipe_to_priv(pipe);
@@ -135,6 +137,11 @@ struct usbhs_pkt *usbhs_pkt_pop(struct usbhs_pipe *pipe, struct usbhs_pkt *pkt)
 			dmaengine_terminate_all(chan);
 			usbhsf_fifo_clear(pipe, fifo);
 			usbhsf_dma_unmap(pkt);
+		} else {
+			if (usbhs_pipe_is_dir_in(pipe))
+				usbhsf_rx_irq_ctrl(pipe, 0);
+			else
+				usbhsf_tx_irq_ctrl(pipe, 0);
 		}
 
 		usbhs_pipe_running(pipe, 0);
diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index e15947392f1b..dd34ea3ef14e 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -159,6 +159,7 @@ static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x10C4, 0x89A4) }, /* CESINEL FTBC Flexible Thyristor Bridge Controller */
 	{ USB_DEVICE(0x10C4, 0x89FB) }, /* Qivicon ZigBee USB Radio Stick */
 	{ USB_DEVICE(0x10C4, 0x8A2A) }, /* HubZ dual ZigBee and Z-Wave dongle */
+	{ USB_DEVICE(0x10C4, 0x8A5B) }, /* CEL EM3588 ZigBee USB Stick */
 	{ USB_DEVICE(0x10C4, 0x8A5E) }, /* CEL EM3588 ZigBee USB Stick Long Range */
 	{ USB_DEVICE(0x10C4, 0x8B34) }, /* Qivicon ZigBee USB Radio Stick */
 	{ USB_DEVICE(0x10C4, 0xEA60) }, /* Silicon Labs factory default */
@@ -206,8 +207,8 @@ static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x1901, 0x0194) },	/* GE Healthcare Remote Alarm Box */
 	{ USB_DEVICE(0x1901, 0x0195) },	/* GE B850/B650/B450 CP2104 DP UART interface */
 	{ USB_DEVICE(0x1901, 0x0196) },	/* GE B850 CP2105 DP UART interface */
-	{ USB_DEVICE(0x1901, 0x0197) }, /* GE CS1000 Display serial interface */
-	{ USB_DEVICE(0x1901, 0x0198) }, /* GE CS1000 M.2 Key E serial interface */
+	{ USB_DEVICE(0x1901, 0x0197) }, /* GE CS1000 M.2 Key E serial interface */
+	{ USB_DEVICE(0x1901, 0x0198) }, /* GE CS1000 Display serial interface */
 	{ USB_DEVICE(0x199B, 0xBA30) }, /* LORD WSDA-200-USB */
 	{ USB_DEVICE(0x19CF, 0x3000) }, /* Parrot NMEA GPS Flight Recorder */
 	{ USB_DEVICE(0x1ADB, 0x0001) }, /* Schweitzer Engineering C662 Cable */
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index ea8288e40fd9..fa9e3a2ddd01 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -241,6 +241,7 @@ static void option_instat_callback(struct urb *urb);
 #define QUECTEL_PRODUCT_UC15			0x9090
 /* These u-blox products use Qualcomm's vendor ID */
 #define UBLOX_PRODUCT_R410M			0x90b2
+#define UBLOX_PRODUCT_R6XX			0x90fa
 /* These Yuga products use Qualcomm's vendor ID */
 #define YUGA_PRODUCT_CLM920_NC5			0x9625
 
@@ -1104,6 +1105,8 @@ static const struct usb_device_id option_ids[] = {
 	/* u-blox products using Qualcomm vendor ID */
 	{ USB_DEVICE(QUALCOMM_VENDOR_ID, UBLOX_PRODUCT_R410M),
 	  .driver_info = RSVD(1) | RSVD(3) },
+	{ USB_DEVICE(QUALCOMM_VENDOR_ID, UBLOX_PRODUCT_R6XX),
+	  .driver_info = RSVD(3) },
 	/* Quectel products using Quectel vendor ID */
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EC21, 0xff, 0xff, 0xff),
 	  .driver_info = NUMEP2 },
diff --git a/drivers/usb/storage/unusual_uas.h b/drivers/usb/storage/unusual_uas.h
index 5705201e5707..6f57fb0614fe 100644
--- a/drivers/usb/storage/unusual_uas.h
+++ b/drivers/usb/storage/unusual_uas.h
@@ -58,6 +58,13 @@ UNUSUAL_DEV(0x059f, 0x105f, 0x0000, 0x9999,
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_NO_REPORT_OPCODES | US_FL_NO_SAME),
 
+/* Reported-by: Julian Sikorski <belegdol@gmail.com> */
+UNUSUAL_DEV(0x059f, 0x1061, 0x0000, 0x9999,
+		"LaCie",
+		"Rugged USB3-FW",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_IGNORE_UAS),
+
 /*
  * Apricorn USB3 dongle sometimes returns "USBSUSBSUSBS" in response to SCSI
  * commands in UAS mode.  Observed with the 1.28 firmware; are there others?
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 9769a5db7d5e..7ca0fafcd5a6 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -540,7 +540,7 @@ static noinline void compress_file_range(struct inode *inode,
 	 * inode has not been flagged as nocompress.  This flag can
 	 * change at any time if we discover bad compression ratios.
 	 */
-	if (inode_need_compress(inode, start, end)) {
+	if (nr_pages > 1 && inode_need_compress(inode, start, end)) {
 		WARN_ON(pages);
 		pages = kcalloc(nr_pages, sizeof(struct page *), GFP_NOFS);
 		if (!pages) {
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 005d4cb2347e..5f68454cf421 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -841,7 +841,7 @@ static ssize_t mem_rw(struct file *file, char __user *buf,
 	flags = FOLL_FORCE | (write ? FOLL_WRITE : 0);
 
 	while (count > 0) {
-		int this_len = min_t(int, count, PAGE_SIZE);
+		size_t this_len = min_t(size_t, count, PAGE_SIZE);
 
 		if (write && copy_from_user(page, buf, this_len)) {
 			copied = -EFAULT;
diff --git a/include/drm/drm_ioctl.h b/include/drm/drm_ioctl.h
index add42809642a..d9df199333fd 100644
--- a/include/drm/drm_ioctl.h
+++ b/include/drm/drm_ioctl.h
@@ -68,6 +68,7 @@ typedef int drm_ioctl_compat_t(struct file *filp, unsigned int cmd,
 			       unsigned long arg);
 
 #define DRM_IOCTL_NR(n)                _IOC_NR(n)
+#define DRM_IOCTL_TYPE(n)              _IOC_TYPE(n)
 #define DRM_MAJOR       226
 
 /**
diff --git a/include/net/dst_metadata.h b/include/net/dst_metadata.h
index 91bc7bdf6bf5..0b3c2aaed3c8 100644
--- a/include/net/dst_metadata.h
+++ b/include/net/dst_metadata.h
@@ -44,7 +44,9 @@ static inline struct ip_tunnel_info *skb_tunnel_info(struct sk_buff *skb)
 		return &md_dst->u.tun_info;
 
 	dst = skb_dst(skb);
-	if (dst && dst->lwtstate)
+	if (dst && dst->lwtstate &&
+	    (dst->lwtstate->type == LWTUNNEL_ENCAP_IP ||
+	     dst->lwtstate->type == LWTUNNEL_ENCAP_IP6))
 		return lwt_tun_info(dst->lwtstate);
 
 	return NULL;
diff --git a/include/net/ip6_route.h b/include/net/ip6_route.h
index 9f7f81117434..34139bc9a853 100644
--- a/include/net/ip6_route.h
+++ b/include/net/ip6_route.h
@@ -214,7 +214,7 @@ static inline bool ipv6_anycast_destination(const struct dst_entry *dst,
 int ip6_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 		 int (*output)(struct net *, struct sock *, struct sk_buff *));
 
-static inline int ip6_skb_dst_mtu(struct sk_buff *skb)
+static inline unsigned int ip6_skb_dst_mtu(struct sk_buff *skb)
 {
 	struct ipv6_pinfo *np = skb->sk && !dev_recursion_level() ?
 				inet6_sk(skb->sk) : NULL;
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 37ac76dce908..3ff60230710c 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4464,7 +4464,7 @@ static const u64 cfs_bandwidth_slack_period = 5 * NSEC_PER_MSEC;
 static int runtime_refresh_within(struct cfs_bandwidth *cfs_b, u64 min_expire)
 {
 	struct hrtimer *refresh_timer = &cfs_b->period_timer;
-	u64 remaining;
+	s64 remaining;
 
 	/* if the call-back is running a quota refresh is already occurring */
 	if (hrtimer_callback_running(refresh_timer))
@@ -4472,7 +4472,7 @@ static int runtime_refresh_within(struct cfs_bandwidth *cfs_b, u64 min_expire)
 
 	/* is a quota refresh about to occur? */
 	remaining = ktime_to_ns(hrtimer_expires_remaining(refresh_timer));
-	if (remaining < min_expire)
+	if (remaining < (s64)min_expire)
 		return 1;
 
 	return 0;
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index d929c0afbacc..359f44cee08a 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -3054,10 +3054,30 @@ static bool rb_per_cpu_empty(struct ring_buffer_per_cpu *cpu_buffer)
 	if (unlikely(!head))
 		return true;
 
-	return reader->read == rb_page_commit(reader) &&
-		(commit == reader ||
-		 (commit == head &&
-		  head->read == rb_page_commit(commit)));
+	/* Reader should exhaust content in reader page */
+	if (reader->read != rb_page_commit(reader))
+		return false;
+
+	/*
+	 * If writers are committing on the reader page, knowing all
+	 * committed content has been read, the ring buffer is empty.
+	 */
+	if (commit == reader)
+		return true;
+
+	/*
+	 * If writers are committing on a page other than reader page
+	 * and head page, there should always be content to read.
+	 */
+	if (commit != head)
+		return false;
+
+	/*
+	 * Writers are committing on the head page, we just need
+	 * to care about there're committed data, and the reader will
+	 * swap reader page with head page when it is to read data.
+	 */
+	return rb_page_commit(commit) == 0;
 }
 
 /**
diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index d9156eabddb8..9a36592cf20f 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -485,7 +485,7 @@ int br_add_if(struct net_bridge *br, struct net_device *dev)
 	struct net_bridge_port *p;
 	int err = 0;
 	unsigned br_hr, dev_hr;
-	bool changed_addr;
+	bool changed_addr, fdb_synced = false;
 
 	/* Don't allow bridging non-ethernet like devices, or DSA-enabled
 	 * master network devices since the bridge layer rx_handler prevents
@@ -555,6 +555,19 @@ int br_add_if(struct net_bridge *br, struct net_device *dev)
 	list_add_rcu(&p->list, &br->port_list);
 
 	nbp_update_port_count(br);
+	if (!br_promisc_port(p) && (p->dev->priv_flags & IFF_UNICAST_FLT)) {
+		/* When updating the port count we also update all ports'
+		 * promiscuous mode.
+		 * A port leaving promiscuous mode normally gets the bridge's
+		 * fdb synced to the unicast filter (if supported), however,
+		 * `br_port_clear_promisc` does not distinguish between
+		 * non-promiscuous ports and *new* ports, so we need to
+		 * sync explicitly here.
+		 */
+		fdb_synced = br_fdb_sync_static(br, p) == 0;
+		if (!fdb_synced)
+			netdev_err(dev, "failed to sync bridge static fdb addresses to this port\n");
+	}
 
 	netdev_update_features(br->dev);
 
@@ -595,6 +608,8 @@ int br_add_if(struct net_bridge *br, struct net_device *dev)
 	return 0;
 
 err7:
+	if (fdb_synced)
+		br_fdb_unsync_static(br, p);
 	list_del_rcu(&p->list);
 	br_fdb_delete_by_port(br, p, 0, 1);
 	nbp_update_port_count(br);
diff --git a/net/caif/caif_socket.c b/net/caif/caif_socket.c
index df936d2f58bd..c44ade1b1833 100644
--- a/net/caif/caif_socket.c
+++ b/net/caif/caif_socket.c
@@ -539,7 +539,8 @@ static int caif_seqpkt_sendmsg(struct socket *sock, struct msghdr *msg,
 		goto err;
 
 	ret = -EINVAL;
-	if (unlikely(msg->msg_iter.iov->iov_base == NULL))
+	if (unlikely(msg->msg_iter.nr_segs == 0) ||
+	    unlikely(msg->msg_iter.iov->iov_base == NULL))
 		goto err;
 	noblock = msg->msg_flags & MSG_DONTWAIT;
 
diff --git a/net/decnet/af_decnet.c b/net/decnet/af_decnet.c
index 8dbfcd388633..9c7b8ff4556a 100644
--- a/net/decnet/af_decnet.c
+++ b/net/decnet/af_decnet.c
@@ -824,7 +824,7 @@ static int dn_auto_bind(struct socket *sock)
 static int dn_confirm_accept(struct sock *sk, long *timeo, gfp_t allocation)
 {
 	struct dn_scp *scp = DN_SK(sk);
-	DEFINE_WAIT(wait);
+	DEFINE_WAIT_FUNC(wait, woken_wake_function);
 	int err;
 
 	if (scp->state != DN_CR)
@@ -834,11 +834,11 @@ static int dn_confirm_accept(struct sock *sk, long *timeo, gfp_t allocation)
 	scp->segsize_loc = dst_metric_advmss(__sk_dst_get(sk));
 	dn_send_conn_conf(sk, allocation);
 
-	prepare_to_wait(sk_sleep(sk), &wait, TASK_INTERRUPTIBLE);
+	add_wait_queue(sk_sleep(sk), &wait);
 	for(;;) {
 		release_sock(sk);
 		if (scp->state == DN_CC)
-			*timeo = schedule_timeout(*timeo);
+			*timeo = wait_woken(&wait, TASK_INTERRUPTIBLE, *timeo);
 		lock_sock(sk);
 		err = 0;
 		if (scp->state == DN_RUN)
@@ -852,9 +852,8 @@ static int dn_confirm_accept(struct sock *sk, long *timeo, gfp_t allocation)
 		err = -EAGAIN;
 		if (!*timeo)
 			break;
-		prepare_to_wait(sk_sleep(sk), &wait, TASK_INTERRUPTIBLE);
 	}
-	finish_wait(sk_sleep(sk), &wait);
+	remove_wait_queue(sk_sleep(sk), &wait);
 	if (err == 0) {
 		sk->sk_socket->state = SS_CONNECTED;
 	} else if (scp->state != DN_CC) {
@@ -866,7 +865,7 @@ static int dn_confirm_accept(struct sock *sk, long *timeo, gfp_t allocation)
 static int dn_wait_run(struct sock *sk, long *timeo)
 {
 	struct dn_scp *scp = DN_SK(sk);
-	DEFINE_WAIT(wait);
+	DEFINE_WAIT_FUNC(wait, woken_wake_function);
 	int err = 0;
 
 	if (scp->state == DN_RUN)
@@ -875,11 +874,11 @@ static int dn_wait_run(struct sock *sk, long *timeo)
 	if (!*timeo)
 		return -EALREADY;
 
-	prepare_to_wait(sk_sleep(sk), &wait, TASK_INTERRUPTIBLE);
+	add_wait_queue(sk_sleep(sk), &wait);
 	for(;;) {
 		release_sock(sk);
 		if (scp->state == DN_CI || scp->state == DN_CC)
-			*timeo = schedule_timeout(*timeo);
+			*timeo = wait_woken(&wait, TASK_INTERRUPTIBLE, *timeo);
 		lock_sock(sk);
 		err = 0;
 		if (scp->state == DN_RUN)
@@ -893,9 +892,8 @@ static int dn_wait_run(struct sock *sk, long *timeo)
 		err = -ETIMEDOUT;
 		if (!*timeo)
 			break;
-		prepare_to_wait(sk_sleep(sk), &wait, TASK_INTERRUPTIBLE);
 	}
-	finish_wait(sk_sleep(sk), &wait);
+	remove_wait_queue(sk_sleep(sk), &wait);
 out:
 	if (err == 0) {
 		sk->sk_socket->state = SS_CONNECTED;
@@ -1040,16 +1038,16 @@ static void dn_user_copy(struct sk_buff *skb, struct optdata_dn *opt)
 
 static struct sk_buff *dn_wait_for_connect(struct sock *sk, long *timeo)
 {
-	DEFINE_WAIT(wait);
+	DEFINE_WAIT_FUNC(wait, woken_wake_function);
 	struct sk_buff *skb = NULL;
 	int err = 0;
 
-	prepare_to_wait(sk_sleep(sk), &wait, TASK_INTERRUPTIBLE);
+	add_wait_queue(sk_sleep(sk), &wait);
 	for(;;) {
 		release_sock(sk);
 		skb = skb_dequeue(&sk->sk_receive_queue);
 		if (skb == NULL) {
-			*timeo = schedule_timeout(*timeo);
+			*timeo = wait_woken(&wait, TASK_INTERRUPTIBLE, *timeo);
 			skb = skb_dequeue(&sk->sk_receive_queue);
 		}
 		lock_sock(sk);
@@ -1064,9 +1062,8 @@ static struct sk_buff *dn_wait_for_connect(struct sock *sk, long *timeo)
 		err = -EAGAIN;
 		if (!*timeo)
 			break;
-		prepare_to_wait(sk_sleep(sk), &wait, TASK_INTERRUPTIBLE);
 	}
-	finish_wait(sk_sleep(sk), &wait);
+	remove_wait_queue(sk_sleep(sk), &wait);
 
 	return skb == NULL ? ERR_PTR(err) : skb;
 }
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index d01c34e95016..146a137ee7ef 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -285,7 +285,7 @@ void tcp_v4_mtu_reduced(struct sock *sk)
 
 	if ((1 << sk->sk_state) & (TCPF_LISTEN | TCPF_CLOSE))
 		return;
-	mtu = tcp_sk(sk)->mtu_info;
+	mtu = READ_ONCE(tcp_sk(sk)->mtu_info);
 	dst = inet_csk_update_pmtu(sk, mtu);
 	if (!dst)
 		return;
@@ -453,7 +453,7 @@ void tcp_v4_err(struct sk_buff *icmp_skb, u32 info)
 			if (sk->sk_state == TCP_LISTEN)
 				goto out;
 
-			tp->mtu_info = info;
+			WRITE_ONCE(tp->mtu_info, info);
 			if (!sock_owned_by_user(sk)) {
 				tcp_v4_mtu_reduced(sk);
 			} else {
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 90827c386b5b..99ab936a9cd3 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1470,6 +1470,7 @@ int tcp_mtu_to_mss(struct sock *sk, int pmtu)
 	return __tcp_mtu_to_mss(sk, pmtu) -
 	       (tcp_sk(sk)->tcp_header_len - sizeof(struct tcphdr));
 }
+EXPORT_SYMBOL(tcp_mtu_to_mss);
 
 /* Inverse of above */
 int tcp_mss_to_mtu(struct sock *sk, int mss)
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 037958ccc9f5..0f0772c48bf0 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -319,11 +319,20 @@ static int tcp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
 static void tcp_v6_mtu_reduced(struct sock *sk)
 {
 	struct dst_entry *dst;
+	u32 mtu;
 
 	if ((1 << sk->sk_state) & (TCPF_LISTEN | TCPF_CLOSE))
 		return;
 
-	dst = inet6_csk_update_pmtu(sk, tcp_sk(sk)->mtu_info);
+	mtu = READ_ONCE(tcp_sk(sk)->mtu_info);
+
+	/* Drop requests trying to increase our current mss.
+	 * Check done in __ip6_rt_update_pmtu() is too late.
+	 */
+	if (tcp_mtu_to_mss(sk, mtu) >= tcp_sk(sk)->mss_cache)
+		return;
+
+	dst = inet6_csk_update_pmtu(sk, mtu);
 	if (!dst)
 		return;
 
@@ -402,6 +411,8 @@ static void tcp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 	}
 
 	if (type == ICMPV6_PKT_TOOBIG) {
+		u32 mtu = ntohl(info);
+
 		/* We are not interested in TCP_LISTEN and open_requests
 		 * (SYN-ACKs send out by Linux are always <576bytes so
 		 * they should go through unfragmented).
@@ -412,7 +423,11 @@ static void tcp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 		if (!ip6_sk_accept_pmtu(sk))
 			goto out;
 
-		tp->mtu_info = ntohl(info);
+		if (mtu < IPV6_MIN_MTU)
+			goto out;
+
+		WRITE_ONCE(tp->mtu_info, mtu);
+
 		if (!sock_owned_by_user(sk))
 			tcp_v6_mtu_reduced(sk);
 		else if (!test_and_set_bit(TCP_MTU_REDUCED_DEFERRED,
@@ -486,7 +501,8 @@ static int tcp_v6_send_synack(const struct sock *sk, struct dst_entry *dst,
 		opt = ireq->ipv6_opt;
 		if (!opt)
 			opt = rcu_dereference(np->opt);
-		err = ip6_xmit(sk, skb, fl6, sk->sk_mark, opt, np->tclass);
+		err = ip6_xmit(sk, skb, fl6, skb->mark ? : sk->sk_mark, opt,
+			       np->tclass);
 		rcu_read_unlock();
 		err = net_xmit_eval(err);
 	}
diff --git a/net/ipv6/xfrm6_output.c b/net/ipv6/xfrm6_output.c
index aff901be5353..276280d1e3da 100644
--- a/net/ipv6/xfrm6_output.c
+++ b/net/ipv6/xfrm6_output.c
@@ -146,7 +146,7 @@ static int __xfrm6_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 {
 	struct dst_entry *dst = skb_dst(skb);
 	struct xfrm_state *x = dst->xfrm;
-	int mtu;
+	unsigned int mtu;
 	bool toobig;
 
 #ifdef CONFIG_NETFILTER
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index a83147f701da..b084659bd34b 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -196,6 +196,7 @@ static int ctnetlink_dump_helpinfo(struct sk_buff *skb,
 	if (!help)
 		return 0;
 
+	rcu_read_lock();
 	helper = rcu_dereference(help->helper);
 	if (!helper)
 		goto out;
@@ -211,9 +212,11 @@ static int ctnetlink_dump_helpinfo(struct sk_buff *skb,
 
 	nla_nest_end(skb, nest_helper);
 out:
+	rcu_read_unlock();
 	return 0;
 
 nla_put_failure:
+	rcu_read_unlock();
 	return -1;
 }
 
diff --git a/net/netrom/nr_timer.c b/net/netrom/nr_timer.c
index f0ecaec1ff3d..d1a0b7056743 100644
--- a/net/netrom/nr_timer.c
+++ b/net/netrom/nr_timer.c
@@ -125,11 +125,9 @@ static void nr_heartbeat_expiry(unsigned long param)
 		   is accepted() it isn't 'dead' so doesn't get removed. */
 		if (sock_flag(sk, SOCK_DESTROY) ||
 		    (sk->sk_state == TCP_LISTEN && sock_flag(sk, SOCK_DEAD))) {
-			sock_hold(sk);
 			bh_unlock_sock(sk);
 			nr_destroy_socket(sk);
-			sock_put(sk);
-			return;
+			goto out;
 		}
 		break;
 
@@ -150,6 +148,8 @@ static void nr_heartbeat_expiry(unsigned long param)
 
 	nr_start_heartbeat(sk);
 	bh_unlock_sock(sk);
+out:
+	sock_put(sk);
 }
 
 static void nr_t2timer_expiry(unsigned long param)
@@ -163,6 +163,7 @@ static void nr_t2timer_expiry(unsigned long param)
 		nr_enquiry_response(sk);
 	}
 	bh_unlock_sock(sk);
+	sock_put(sk);
 }
 
 static void nr_t4timer_expiry(unsigned long param)
@@ -172,6 +173,7 @@ static void nr_t4timer_expiry(unsigned long param)
 	bh_lock_sock(sk);
 	nr_sk(sk)->condition &= ~NR_COND_PEER_RX_BUSY;
 	bh_unlock_sock(sk);
+	sock_put(sk);
 }
 
 static void nr_idletimer_expiry(unsigned long param)
@@ -200,6 +202,7 @@ static void nr_idletimer_expiry(unsigned long param)
 		sock_set_flag(sk, SOCK_DEAD);
 	}
 	bh_unlock_sock(sk);
+	sock_put(sk);
 }
 
 static void nr_t1timer_expiry(unsigned long param)
@@ -212,8 +215,7 @@ static void nr_t1timer_expiry(unsigned long param)
 	case NR_STATE_1:
 		if (nr->n2count == nr->n2) {
 			nr_disconnect(sk, ETIMEDOUT);
-			bh_unlock_sock(sk);
-			return;
+			goto out;
 		} else {
 			nr->n2count++;
 			nr_write_internal(sk, NR_CONNREQ);
@@ -223,8 +225,7 @@ static void nr_t1timer_expiry(unsigned long param)
 	case NR_STATE_2:
 		if (nr->n2count == nr->n2) {
 			nr_disconnect(sk, ETIMEDOUT);
-			bh_unlock_sock(sk);
-			return;
+			goto out;
 		} else {
 			nr->n2count++;
 			nr_write_internal(sk, NR_DISCREQ);
@@ -234,8 +235,7 @@ static void nr_t1timer_expiry(unsigned long param)
 	case NR_STATE_3:
 		if (nr->n2count == nr->n2) {
 			nr_disconnect(sk, ETIMEDOUT);
-			bh_unlock_sock(sk);
-			return;
+			goto out;
 		} else {
 			nr->n2count++;
 			nr_requeue_frames(sk);
@@ -244,5 +244,7 @@ static void nr_t1timer_expiry(unsigned long param)
 	}
 
 	nr_start_t1timer(sk);
+out:
 	bh_unlock_sock(sk);
+	sock_put(sk);
 }
diff --git a/scripts/mkcompile_h b/scripts/mkcompile_h
index 959199c3147e..49f92fffa098 100755
--- a/scripts/mkcompile_h
+++ b/scripts/mkcompile_h
@@ -83,15 +83,23 @@ UTS_TRUNCATE="cut -b -$UTS_LEN"
 # Only replace the real compile.h if the new one is different,
 # in order to preserve the timestamp and avoid unnecessary
 # recompilations.
-# We don't consider the file changed if only the date/time changed.
+# We don't consider the file changed if only the date/time changed,
+# unless KBUILD_BUILD_TIMESTAMP was explicitly set (e.g. for
+# reproducible builds with that value referring to a commit timestamp).
 # A kernel config change will increase the generation number, thus
 # causing compile.h to be updated (including date/time) due to the
 # changed comment in the
 # first line.
 
+if [ -z "$KBUILD_BUILD_TIMESTAMP" ]; then
+   IGNORE_PATTERN="UTS_VERSION"
+else
+   IGNORE_PATTERN="NOT_A_PATTERN_TO_BE_MATCHED"
+fi
+
 if [ -r $TARGET ] && \
-      grep -v 'UTS_VERSION' $TARGET > .tmpver.1 && \
-      grep -v 'UTS_VERSION' .tmpcompile > .tmpver.2 && \
+      grep -v $IGNORE_PATTERN $TARGET > .tmpver.1 && \
+      grep -v $IGNORE_PATTERN .tmpcompile > .tmpver.2 && \
       cmp -s .tmpver.1 .tmpver.2; then
    rm -f .tmpcompile
 else
diff --git a/sound/isa/sb/sb16_csp.c b/sound/isa/sb/sb16_csp.c
index 69f392cf67b6..00d059412c8a 100644
--- a/sound/isa/sb/sb16_csp.c
+++ b/sound/isa/sb/sb16_csp.c
@@ -828,6 +828,7 @@ static int snd_sb_csp_start(struct snd_sb_csp * p, int sample_width, int channel
 	mixR = snd_sbmixer_read(p->chip, SB_DSP4_PCM_DEV + 1);
 	snd_sbmixer_write(p->chip, SB_DSP4_PCM_DEV, mixL & 0x7);
 	snd_sbmixer_write(p->chip, SB_DSP4_PCM_DEV + 1, mixR & 0x7);
+	spin_unlock_irqrestore(&p->chip->mixer_lock, flags);
 
 	spin_lock(&p->chip->reg_lock);
 	set_mode_register(p->chip, 0xc0);	/* c0 = STOP */
@@ -867,6 +868,7 @@ static int snd_sb_csp_start(struct snd_sb_csp * p, int sample_width, int channel
 	spin_unlock(&p->chip->reg_lock);
 
 	/* restore PCM volume */
+	spin_lock_irqsave(&p->chip->mixer_lock, flags);
 	snd_sbmixer_write(p->chip, SB_DSP4_PCM_DEV, mixL);
 	snd_sbmixer_write(p->chip, SB_DSP4_PCM_DEV + 1, mixR);
 	spin_unlock_irqrestore(&p->chip->mixer_lock, flags);
@@ -892,6 +894,7 @@ static int snd_sb_csp_stop(struct snd_sb_csp * p)
 	mixR = snd_sbmixer_read(p->chip, SB_DSP4_PCM_DEV + 1);
 	snd_sbmixer_write(p->chip, SB_DSP4_PCM_DEV, mixL & 0x7);
 	snd_sbmixer_write(p->chip, SB_DSP4_PCM_DEV + 1, mixR & 0x7);
+	spin_unlock_irqrestore(&p->chip->mixer_lock, flags);
 
 	spin_lock(&p->chip->reg_lock);
 	if (p->running & SNDRV_SB_CSP_ST_QSOUND) {
@@ -906,6 +909,7 @@ static int snd_sb_csp_stop(struct snd_sb_csp * p)
 	spin_unlock(&p->chip->reg_lock);
 
 	/* restore PCM volume */
+	spin_lock_irqsave(&p->chip->mixer_lock, flags);
 	snd_sbmixer_write(p->chip, SB_DSP4_PCM_DEV, mixL);
 	snd_sbmixer_write(p->chip, SB_DSP4_PCM_DEV + 1, mixR);
 	spin_unlock_irqrestore(&p->chip->mixer_lock, flags);
diff --git a/tools/perf/tests/bpf.c b/tools/perf/tests/bpf.c
index 34c22cdf4d5d..3fc7fd779c27 100644
--- a/tools/perf/tests/bpf.c
+++ b/tools/perf/tests/bpf.c
@@ -1,5 +1,6 @@
 #include <errno.h>
 #include <stdio.h>
+#include <stdlib.h>
 #include <sys/epoll.h>
 #include <sys/types.h>
 #include <sys/stat.h>
@@ -275,6 +276,7 @@ static int __test__bpf(int idx)
 	}
 
 out:
+	free(obj_buf);
 	bpf__clear();
 	return ret;
 }
diff --git a/tools/perf/util/lzma.c b/tools/perf/util/lzma.c
index 07498eaddc08..bbf4c6bc2c2e 100644
--- a/tools/perf/util/lzma.c
+++ b/tools/perf/util/lzma.c
@@ -64,7 +64,7 @@ int lzma_decompress_to_file(const char *input, int output_fd)
 
 			if (ferror(infile)) {
 				pr_err("lzma: read error: %s\n", strerror(errno));
-				goto err_fclose;
+				goto err_lzma_end;
 			}
 
 			if (feof(infile))
@@ -78,7 +78,7 @@ int lzma_decompress_to_file(const char *input, int output_fd)
 
 			if (writen(output_fd, buf_out, write_size) != write_size) {
 				pr_err("lzma: write error: %s\n", strerror(errno));
-				goto err_fclose;
+				goto err_lzma_end;
 			}
 
 			strm.next_out  = buf_out;
@@ -90,11 +90,13 @@ int lzma_decompress_to_file(const char *input, int output_fd)
 				break;
 
 			pr_err("lzma: failed %s\n", lzma_strerror(ret));
-			goto err_fclose;
+			goto err_lzma_end;
 		}
 	}
 
 	err = 0;
+err_lzma_end:
+	lzma_end(&strm);
 err_fclose:
 	fclose(infile);
 	return err;
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 9d42a2821ecb..d7c34feef58e 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -216,6 +216,8 @@ struct map *map__new(struct machine *machine, u64 start, u64 len,
 			if (type != MAP__FUNCTION)
 				dso__set_loaded(dso, map->type);
 		}
+
+		nsinfo__put(dso->nsinfo);
 		dso->nsinfo = nsi;
 		dso__put(dso);
 	}
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 7c286756c34b..a0597e417ca3 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -197,8 +197,10 @@ struct map *get_target_map(const char *target, struct nsinfo *nsi, bool user)
 		struct map *map;
 
 		map = dso__new_map(target);
-		if (map && map->dso)
+		if (map && map->dso) {
+			nsinfo__put(map->dso->nsinfo);
 			map->dso->nsinfo = nsinfo__get(nsi);
+		}
 		return map;
 	} else {
 		return kernel_get_module_map(target);
diff --git a/tools/perf/util/probe-file.c b/tools/perf/util/probe-file.c
index 6ab9230ce8ee..4de93df73c4c 100644
--- a/tools/perf/util/probe-file.c
+++ b/tools/perf/util/probe-file.c
@@ -342,11 +342,11 @@ int probe_file__del_events(int fd, struct strfilter *filter)
 
 	ret = probe_file__get_events(fd, filter, namelist);
 	if (ret < 0)
-		return ret;
+		goto out;
 
 	ret = probe_file__del_strlist(fd, namelist);
+out:
 	strlist__delete(namelist);
-
 	return ret;
 }
 
diff --git a/tools/testing/selftests/vm/userfaultfd.c b/tools/testing/selftests/vm/userfaultfd.c
index 7b8171e3128a..16d42b2de424 100644
--- a/tools/testing/selftests/vm/userfaultfd.c
+++ b/tools/testing/selftests/vm/userfaultfd.c
@@ -129,8 +129,10 @@ static int anon_release_pages(char *rel_area)
 
 static void anon_allocate_area(void **alloc_area)
 {
-	if (posix_memalign(alloc_area, page_size, nr_pages * page_size)) {
-		fprintf(stderr, "out of memory\n");
+	*alloc_area = mmap(NULL, nr_pages * page_size, PROT_READ | PROT_WRITE,
+			   MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+	if (*alloc_area == MAP_FAILED)
+		fprintf(stderr, "mmap of anonymous memory failed");
 		*alloc_area = NULL;
 	}
 }
