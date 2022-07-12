Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 373D2571DB6
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 17:02:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232809AbiGLPCB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 11:02:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233792AbiGLPA7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 11:00:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C701CBF54C;
        Tue, 12 Jul 2022 07:59:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2382B819AE;
        Tue, 12 Jul 2022 14:59:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98360C3411C;
        Tue, 12 Jul 2022 14:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657637970;
        bh=P5w9on7Xs+9WHrgELa9Oci16YnYvaf4e5H0SeQBGoHI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y7s2vILH7SYJj8OQEdUPXvEJkl2gkZ2mEKx0upzIRacMv5Hpi+g9NLYqHOSOxUqQi
         QnAH9TGSCTS+Rn/LWeHD5iHia01jJyC+UZbDNuL6WsLHVtpeurr9xyqrJdwWMA7iCa
         BaneE/erQ4xRuRrAsTCwFDe4na+jPrkw0CblGGpY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.15.54
Date:   Tue, 12 Jul 2022 16:59:13 +0200
Message-Id: <165763795213532@kroah.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <1657637952161138@kroah.com>
References: <1657637952161138@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

diff --git a/Documentation/devicetree/bindings/dma/allwinner,sun50i-a64-dma.yaml b/Documentation/devicetree/bindings/dma/allwinner,sun50i-a64-dma.yaml
index b6e1ebfaf366..bb3cbc30d912 100644
--- a/Documentation/devicetree/bindings/dma/allwinner,sun50i-a64-dma.yaml
+++ b/Documentation/devicetree/bindings/dma/allwinner,sun50i-a64-dma.yaml
@@ -64,7 +64,7 @@ if:
 then:
   properties:
     clocks:
-      maxItems: 2
+      minItems: 2
 
   required:
     - clock-names
diff --git a/Documentation/devicetree/bindings/soc/qcom/qcom,smd-rpm.yaml b/Documentation/devicetree/bindings/soc/qcom/qcom,smd-rpm.yaml
index cc3fe5ed7421..1b0062e3c1a4 100644
--- a/Documentation/devicetree/bindings/soc/qcom/qcom,smd-rpm.yaml
+++ b/Documentation/devicetree/bindings/soc/qcom/qcom,smd-rpm.yaml
@@ -34,6 +34,8 @@ properties:
       - qcom,rpm-ipq6018
       - qcom,rpm-msm8226
       - qcom,rpm-msm8916
+      - qcom,rpm-msm8936
+      - qcom,rpm-msm8953
       - qcom,rpm-msm8974
       - qcom,rpm-msm8976
       - qcom,rpm-msm8996
@@ -57,6 +59,7 @@ if:
           - qcom,rpm-apq8084
           - qcom,rpm-msm8916
           - qcom,rpm-msm8974
+          - qcom,rpm-msm8953
 then:
   required:
     - qcom,smd-channels
diff --git a/MAINTAINERS b/MAINTAINERS
index a60d7e0466af..edc32575828b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7952,9 +7952,10 @@ F:	drivers/media/usb/go7007/
 
 GOODIX TOUCHSCREEN
 M:	Bastien Nocera <hadess@hadess.net>
+M:	Hans de Goede <hdegoede@redhat.com>
 L:	linux-input@vger.kernel.org
 S:	Maintained
-F:	drivers/input/touchscreen/goodix.c
+F:	drivers/input/touchscreen/goodix*
 
 GOOGLE ETHERNET DRIVERS
 M:	Jeroen de Borst <jeroendb@google.com>
diff --git a/Makefile b/Makefile
index c7750d260a55..f8dc156aa302 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 15
-SUBLEVEL = 53
+SUBLEVEL = 54
 EXTRAVERSION =
 NAME = Trick or Treat
 
@@ -1011,6 +1011,21 @@ ifdef CONFIG_CC_IS_GCC
 KBUILD_CFLAGS += -Wno-maybe-uninitialized
 endif
 
+ifdef CONFIG_CC_IS_GCC
+# The allocators already balk at large sizes, so silence the compiler
+# warnings for bounds checks involving those possible values. While
+# -Wno-alloc-size-larger-than would normally be used here, earlier versions
+# of gcc (<9.1) weirdly don't handle the option correctly when _other_
+# warnings are produced (?!). Using -Walloc-size-larger-than=SIZE_MAX
+# doesn't work (as it is documented to), silently resolving to "0" prior to
+# version 9.1 (and producing an error more recently). Numeric values larger
+# than PTRDIFF_MAX also don't work prior to version 9.1, which are silently
+# ignored, continuing to default to PTRDIFF_MAX. So, left with no other
+# choice, we must perform a versioned check to disable this warning.
+# https://lore.kernel.org/lkml/20210824115859.187f272f@canb.auug.org.au
+KBUILD_CFLAGS += $(call cc-ifversion, -ge, 0901, -Wno-alloc-size-larger-than)
+endif
+
 # disable invalid "can't wrap" optimizations for signed / pointers
 KBUILD_CFLAGS	+= -fno-strict-overflow
 
diff --git a/arch/arm/boot/dts/at91-sam9x60ek.dts b/arch/arm/boot/dts/at91-sam9x60ek.dts
index b1068cca4228..fd8dc1183b3e 100644
--- a/arch/arm/boot/dts/at91-sam9x60ek.dts
+++ b/arch/arm/boot/dts/at91-sam9x60ek.dts
@@ -233,10 +233,9 @@ i2c0: i2c@600 {
 		status = "okay";
 
 		eeprom@53 {
-			compatible = "atmel,24c32";
+			compatible = "atmel,24c02";
 			reg = <0x53>;
 			pagesize = <16>;
-			size = <128>;
 			status = "okay";
 		};
 	};
diff --git a/arch/arm/boot/dts/at91-sama5d2_icp.dts b/arch/arm/boot/dts/at91-sama5d2_icp.dts
index e06b58724ca8..fd1a288f686b 100644
--- a/arch/arm/boot/dts/at91-sama5d2_icp.dts
+++ b/arch/arm/boot/dts/at91-sama5d2_icp.dts
@@ -323,21 +323,21 @@ &i2c1 {
 	status = "okay";
 
 	eeprom@50 {
-		compatible = "atmel,24c32";
+		compatible = "atmel,24c02";
 		reg = <0x50>;
 		pagesize = <16>;
 		status = "okay";
 	};
 
 	eeprom@52 {
-		compatible = "atmel,24c32";
+		compatible = "atmel,24c02";
 		reg = <0x52>;
 		pagesize = <16>;
 		status = "disabled";
 	};
 
 	eeprom@53 {
-		compatible = "atmel,24c32";
+		compatible = "atmel,24c02";
 		reg = <0x53>;
 		pagesize = <16>;
 		status = "disabled";
diff --git a/arch/arm/boot/dts/stm32mp151.dtsi b/arch/arm/boot/dts/stm32mp151.dtsi
index 6992a4b0ba79..a9b65b3bfda5 100644
--- a/arch/arm/boot/dts/stm32mp151.dtsi
+++ b/arch/arm/boot/dts/stm32mp151.dtsi
@@ -1452,7 +1452,7 @@ stmmac_axi_config_0: stmmac-axi-config {
 		usbh_ohci: usb@5800c000 {
 			compatible = "generic-ohci";
 			reg = <0x5800c000 0x1000>;
-			clocks = <&rcc USBH>;
+			clocks = <&usbphyc>, <&rcc USBH>;
 			resets = <&rcc USBH_R>;
 			interrupts = <GIC_SPI 74 IRQ_TYPE_LEVEL_HIGH>;
 			status = "disabled";
@@ -1461,7 +1461,7 @@ usbh_ohci: usb@5800c000 {
 		usbh_ehci: usb@5800d000 {
 			compatible = "generic-ehci";
 			reg = <0x5800d000 0x1000>;
-			clocks = <&rcc USBH>;
+			clocks = <&usbphyc>, <&rcc USBH>;
 			resets = <&rcc USBH_R>;
 			interrupts = <GIC_SPI 75 IRQ_TYPE_LEVEL_HIGH>;
 			companion = <&usbh_ohci>;
diff --git a/arch/arm/configs/mxs_defconfig b/arch/arm/configs/mxs_defconfig
index ca32446b187f..f53086ddc48b 100644
--- a/arch/arm/configs/mxs_defconfig
+++ b/arch/arm/configs/mxs_defconfig
@@ -93,6 +93,7 @@ CONFIG_REGULATOR_FIXED_VOLTAGE=y
 CONFIG_DRM=y
 CONFIG_DRM_PANEL_SEIKO_43WVF1G=y
 CONFIG_DRM_MXSFB=y
+CONFIG_FB=y
 CONFIG_FB_MODE_HELPERS=y
 CONFIG_LCD_CLASS_DEVICE=y
 CONFIG_BACKLIGHT_CLASS_DEVICE=y
diff --git a/arch/arm/include/asm/arch_gicv3.h b/arch/arm/include/asm/arch_gicv3.h
index 413abfb42989..f82a819eb0db 100644
--- a/arch/arm/include/asm/arch_gicv3.h
+++ b/arch/arm/include/asm/arch_gicv3.h
@@ -48,6 +48,7 @@ static inline u32 read_ ## a64(void)		\
 	return read_sysreg(a32); 		\
 }						\
 
+CPUIF_MAP(ICC_EOIR1, ICC_EOIR1_EL1)
 CPUIF_MAP(ICC_PMR, ICC_PMR_EL1)
 CPUIF_MAP(ICC_AP0R0, ICC_AP0R0_EL1)
 CPUIF_MAP(ICC_AP0R1, ICC_AP0R1_EL1)
@@ -63,12 +64,6 @@ CPUIF_MAP(ICC_AP1R3, ICC_AP1R3_EL1)
 
 /* Low-level accessors */
 
-static inline void gic_write_eoir(u32 irq)
-{
-	write_sysreg(irq, ICC_EOIR1);
-	isb();
-}
-
 static inline void gic_write_dir(u32 val)
 {
 	write_sysreg(val, ICC_DIR);
diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
index 8711d6824c1f..ed1050404ef0 100644
--- a/arch/arm/mach-at91/pm.c
+++ b/arch/arm/mach-at91/pm.c
@@ -146,7 +146,7 @@ static const struct wakeup_source_info ws_info[] = {
 
 static const struct of_device_id sama5d2_ws_ids[] = {
 	{ .compatible = "atmel,sama5d2-gem",		.data = &ws_info[0] },
-	{ .compatible = "atmel,at91rm9200-rtc",		.data = &ws_info[1] },
+	{ .compatible = "atmel,sama5d2-rtc",		.data = &ws_info[1] },
 	{ .compatible = "atmel,sama5d3-udc",		.data = &ws_info[2] },
 	{ .compatible = "atmel,at91rm9200-ohci",	.data = &ws_info[2] },
 	{ .compatible = "usb-ohci",			.data = &ws_info[2] },
@@ -157,24 +157,24 @@ static const struct of_device_id sama5d2_ws_ids[] = {
 };
 
 static const struct of_device_id sam9x60_ws_ids[] = {
-	{ .compatible = "atmel,at91sam9x5-rtc",		.data = &ws_info[1] },
+	{ .compatible = "microchip,sam9x60-rtc",	.data = &ws_info[1] },
 	{ .compatible = "atmel,at91rm9200-ohci",	.data = &ws_info[2] },
 	{ .compatible = "usb-ohci",			.data = &ws_info[2] },
 	{ .compatible = "atmel,at91sam9g45-ehci",	.data = &ws_info[2] },
 	{ .compatible = "usb-ehci",			.data = &ws_info[2] },
-	{ .compatible = "atmel,at91sam9260-rtt",	.data = &ws_info[4] },
+	{ .compatible = "microchip,sam9x60-rtt",	.data = &ws_info[4] },
 	{ .compatible = "cdns,sam9x60-macb",		.data = &ws_info[5] },
 	{ /* sentinel */ }
 };
 
 static const struct of_device_id sama7g5_ws_ids[] = {
-	{ .compatible = "atmel,at91sam9x5-rtc",		.data = &ws_info[1] },
+	{ .compatible = "microchip,sama7g5-rtc",	.data = &ws_info[1] },
 	{ .compatible = "microchip,sama7g5-ohci",	.data = &ws_info[2] },
 	{ .compatible = "usb-ohci",			.data = &ws_info[2] },
 	{ .compatible = "atmel,at91sam9g45-ehci",	.data = &ws_info[2] },
 	{ .compatible = "usb-ehci",			.data = &ws_info[2] },
 	{ .compatible = "microchip,sama7g5-sdhci",	.data = &ws_info[3] },
-	{ .compatible = "atmel,at91sam9260-rtt",	.data = &ws_info[4] },
+	{ .compatible = "microchip,sama7g5-rtt",	.data = &ws_info[4] },
 	{ /* sentinel */ }
 };
 
diff --git a/arch/arm/mach-meson/platsmp.c b/arch/arm/mach-meson/platsmp.c
index 4b8ad728bb42..32ac60b89fdc 100644
--- a/arch/arm/mach-meson/platsmp.c
+++ b/arch/arm/mach-meson/platsmp.c
@@ -71,6 +71,7 @@ static void __init meson_smp_prepare_cpus(const char *scu_compatible,
 	}
 
 	sram_base = of_iomap(node, 0);
+	of_node_put(node);
 	if (!sram_base) {
 		pr_err("Couldn't map SRAM registers\n");
 		return;
@@ -91,6 +92,7 @@ static void __init meson_smp_prepare_cpus(const char *scu_compatible,
 	}
 
 	scu_base = of_iomap(node, 0);
+	of_node_put(node);
 	if (!scu_base) {
 		pr_err("Couldn't map SCU registers\n");
 		return;
diff --git a/arch/arm64/boot/dts/freescale/imx8mp-evk.dts b/arch/arm64/boot/dts/freescale/imx8mp-evk.dts
index 7b99fad6e4d6..5c9fb39dd99e 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-evk.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mp-evk.dts
@@ -285,21 +285,21 @@ &wdog1 {
 &iomuxc {
 	pinctrl_eqos: eqosgrp {
 		fsl,pins = <
-			MX8MP_IOMUXC_ENET_MDC__ENET_QOS_MDC				0x3
-			MX8MP_IOMUXC_ENET_MDIO__ENET_QOS_MDIO				0x3
-			MX8MP_IOMUXC_ENET_RD0__ENET_QOS_RGMII_RD0			0x91
-			MX8MP_IOMUXC_ENET_RD1__ENET_QOS_RGMII_RD1			0x91
-			MX8MP_IOMUXC_ENET_RD2__ENET_QOS_RGMII_RD2			0x91
-			MX8MP_IOMUXC_ENET_RD3__ENET_QOS_RGMII_RD3			0x91
-			MX8MP_IOMUXC_ENET_RXC__CCM_ENET_QOS_CLOCK_GENERATE_RX_CLK	0x91
-			MX8MP_IOMUXC_ENET_RX_CTL__ENET_QOS_RGMII_RX_CTL			0x91
-			MX8MP_IOMUXC_ENET_TD0__ENET_QOS_RGMII_TD0			0x1f
-			MX8MP_IOMUXC_ENET_TD1__ENET_QOS_RGMII_TD1			0x1f
-			MX8MP_IOMUXC_ENET_TD2__ENET_QOS_RGMII_TD2			0x1f
-			MX8MP_IOMUXC_ENET_TD3__ENET_QOS_RGMII_TD3			0x1f
-			MX8MP_IOMUXC_ENET_TX_CTL__ENET_QOS_RGMII_TX_CTL			0x1f
-			MX8MP_IOMUXC_ENET_TXC__CCM_ENET_QOS_CLOCK_GENERATE_TX_CLK	0x1f
-			MX8MP_IOMUXC_SAI2_RXC__GPIO4_IO22				0x19
+			MX8MP_IOMUXC_ENET_MDC__ENET_QOS_MDC				0x2
+			MX8MP_IOMUXC_ENET_MDIO__ENET_QOS_MDIO				0x2
+			MX8MP_IOMUXC_ENET_RD0__ENET_QOS_RGMII_RD0			0x90
+			MX8MP_IOMUXC_ENET_RD1__ENET_QOS_RGMII_RD1			0x90
+			MX8MP_IOMUXC_ENET_RD2__ENET_QOS_RGMII_RD2			0x90
+			MX8MP_IOMUXC_ENET_RD3__ENET_QOS_RGMII_RD3			0x90
+			MX8MP_IOMUXC_ENET_RXC__CCM_ENET_QOS_CLOCK_GENERATE_RX_CLK	0x90
+			MX8MP_IOMUXC_ENET_RX_CTL__ENET_QOS_RGMII_RX_CTL			0x90
+			MX8MP_IOMUXC_ENET_TD0__ENET_QOS_RGMII_TD0			0x16
+			MX8MP_IOMUXC_ENET_TD1__ENET_QOS_RGMII_TD1			0x16
+			MX8MP_IOMUXC_ENET_TD2__ENET_QOS_RGMII_TD2			0x16
+			MX8MP_IOMUXC_ENET_TD3__ENET_QOS_RGMII_TD3			0x16
+			MX8MP_IOMUXC_ENET_TX_CTL__ENET_QOS_RGMII_TX_CTL			0x16
+			MX8MP_IOMUXC_ENET_TXC__CCM_ENET_QOS_CLOCK_GENERATE_TX_CLK	0x16
+			MX8MP_IOMUXC_SAI2_RXC__GPIO4_IO22				0x10
 		>;
 	};
 
@@ -351,21 +351,21 @@ MX8MP_IOMUXC_SAI2_MCLK__GPIO4_IO27      0x154   /* CAN2_STBY */
 
 	pinctrl_gpio_led: gpioledgrp {
 		fsl,pins = <
-			MX8MP_IOMUXC_NAND_READY_B__GPIO3_IO16	0x19
+			MX8MP_IOMUXC_NAND_READY_B__GPIO3_IO16	0x140
 		>;
 	};
 
 	pinctrl_i2c1: i2c1grp {
 		fsl,pins = <
-			MX8MP_IOMUXC_I2C1_SCL__I2C1_SCL		0x400001c3
-			MX8MP_IOMUXC_I2C1_SDA__I2C1_SDA		0x400001c3
+			MX8MP_IOMUXC_I2C1_SCL__I2C1_SCL		0x400001c2
+			MX8MP_IOMUXC_I2C1_SDA__I2C1_SDA		0x400001c2
 		>;
 	};
 
 	pinctrl_i2c3: i2c3grp {
 		fsl,pins = <
-			MX8MP_IOMUXC_I2C3_SCL__I2C3_SCL		0x400001c3
-			MX8MP_IOMUXC_I2C3_SDA__I2C3_SDA		0x400001c3
+			MX8MP_IOMUXC_I2C3_SCL__I2C3_SCL		0x400001c2
+			MX8MP_IOMUXC_I2C3_SDA__I2C3_SDA		0x400001c2
 		>;
 	};
 
@@ -377,20 +377,20 @@ MX8MP_IOMUXC_GPIO1_IO03__GPIO1_IO03	0x000001c0
 
 	pinctrl_reg_usdhc2_vmmc: regusdhc2vmmcgrp {
 		fsl,pins = <
-			MX8MP_IOMUXC_SD2_RESET_B__GPIO2_IO19	0x41
+			MX8MP_IOMUXC_SD2_RESET_B__GPIO2_IO19	0x40
 		>;
 	};
 
 	pinctrl_uart2: uart2grp {
 		fsl,pins = <
-			MX8MP_IOMUXC_UART2_RXD__UART2_DCE_RX	0x49
-			MX8MP_IOMUXC_UART2_TXD__UART2_DCE_TX	0x49
+			MX8MP_IOMUXC_UART2_RXD__UART2_DCE_RX	0x140
+			MX8MP_IOMUXC_UART2_TXD__UART2_DCE_TX	0x140
 		>;
 	};
 
 	pinctrl_usb1_vbus: usb1grp {
 		fsl,pins = <
-			MX8MP_IOMUXC_GPIO1_IO14__USB2_OTG_PWR	0x19
+			MX8MP_IOMUXC_GPIO1_IO14__USB2_OTG_PWR	0x10
 		>;
 	};
 
@@ -402,7 +402,7 @@ MX8MP_IOMUXC_SD2_DATA0__USDHC2_DATA0	0x1d0
 			MX8MP_IOMUXC_SD2_DATA1__USDHC2_DATA1	0x1d0
 			MX8MP_IOMUXC_SD2_DATA2__USDHC2_DATA2	0x1d0
 			MX8MP_IOMUXC_SD2_DATA3__USDHC2_DATA3	0x1d0
-			MX8MP_IOMUXC_GPIO1_IO04__USDHC2_VSELECT	0xc1
+			MX8MP_IOMUXC_GPIO1_IO04__USDHC2_VSELECT	0xc0
 		>;
 	};
 
@@ -414,7 +414,7 @@ MX8MP_IOMUXC_SD2_DATA0__USDHC2_DATA0	0x1d4
 			MX8MP_IOMUXC_SD2_DATA1__USDHC2_DATA1	0x1d4
 			MX8MP_IOMUXC_SD2_DATA2__USDHC2_DATA2	0x1d4
 			MX8MP_IOMUXC_SD2_DATA3__USDHC2_DATA3	0x1d4
-			MX8MP_IOMUXC_GPIO1_IO04__USDHC2_VSELECT 0xc1
+			MX8MP_IOMUXC_GPIO1_IO04__USDHC2_VSELECT 0xc0
 		>;
 	};
 
@@ -426,7 +426,7 @@ MX8MP_IOMUXC_SD2_DATA0__USDHC2_DATA0	0x1d6
 			MX8MP_IOMUXC_SD2_DATA1__USDHC2_DATA1	0x1d6
 			MX8MP_IOMUXC_SD2_DATA2__USDHC2_DATA2	0x1d6
 			MX8MP_IOMUXC_SD2_DATA3__USDHC2_DATA3	0x1d6
-			MX8MP_IOMUXC_GPIO1_IO04__USDHC2_VSELECT 0xc1
+			MX8MP_IOMUXC_GPIO1_IO04__USDHC2_VSELECT 0xc0
 		>;
 	};
 
diff --git a/arch/arm64/boot/dts/freescale/imx8mp-phyboard-pollux-rdk.dts b/arch/arm64/boot/dts/freescale/imx8mp-phyboard-pollux-rdk.dts
index 984a6b9ded8d..6aa720bafe28 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-phyboard-pollux-rdk.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mp-phyboard-pollux-rdk.dts
@@ -116,48 +116,48 @@ &usdhc2 {
 &iomuxc {
 	pinctrl_eqos: eqosgrp {
 		fsl,pins = <
-			MX8MP_IOMUXC_ENET_MDC__ENET_QOS_MDC			0x3
-			MX8MP_IOMUXC_ENET_MDIO__ENET_QOS_MDIO			0x3
-			MX8MP_IOMUXC_ENET_RD0__ENET_QOS_RGMII_RD0		0x91
-			MX8MP_IOMUXC_ENET_RD1__ENET_QOS_RGMII_RD1		0x91
-			MX8MP_IOMUXC_ENET_RD2__ENET_QOS_RGMII_RD2		0x91
-			MX8MP_IOMUXC_ENET_RD3__ENET_QOS_RGMII_RD3		0x91
-			MX8MP_IOMUXC_ENET_RXC__CCM_ENET_QOS_CLOCK_GENERATE_RX_CLK	0x91
-			MX8MP_IOMUXC_ENET_RX_CTL__ENET_QOS_RGMII_RX_CTL		0x91
-			MX8MP_IOMUXC_ENET_TD0__ENET_QOS_RGMII_TD0		0x1f
-			MX8MP_IOMUXC_ENET_TD1__ENET_QOS_RGMII_TD1		0x1f
-			MX8MP_IOMUXC_ENET_TD2__ENET_QOS_RGMII_TD2		0x1f
-			MX8MP_IOMUXC_ENET_TD3__ENET_QOS_RGMII_TD3		0x1f
-			MX8MP_IOMUXC_ENET_TX_CTL__ENET_QOS_RGMII_TX_CTL		0x1f
-			MX8MP_IOMUXC_ENET_TXC__CCM_ENET_QOS_CLOCK_GENERATE_TX_CLK	0x1f
+			MX8MP_IOMUXC_ENET_MDC__ENET_QOS_MDC			0x2
+			MX8MP_IOMUXC_ENET_MDIO__ENET_QOS_MDIO			0x2
+			MX8MP_IOMUXC_ENET_RD0__ENET_QOS_RGMII_RD0		0x90
+			MX8MP_IOMUXC_ENET_RD1__ENET_QOS_RGMII_RD1		0x90
+			MX8MP_IOMUXC_ENET_RD2__ENET_QOS_RGMII_RD2		0x90
+			MX8MP_IOMUXC_ENET_RD3__ENET_QOS_RGMII_RD3		0x90
+			MX8MP_IOMUXC_ENET_RXC__CCM_ENET_QOS_CLOCK_GENERATE_RX_CLK	0x90
+			MX8MP_IOMUXC_ENET_RX_CTL__ENET_QOS_RGMII_RX_CTL		0x90
+			MX8MP_IOMUXC_ENET_TD0__ENET_QOS_RGMII_TD0		0x16
+			MX8MP_IOMUXC_ENET_TD1__ENET_QOS_RGMII_TD1		0x16
+			MX8MP_IOMUXC_ENET_TD2__ENET_QOS_RGMII_TD2		0x16
+			MX8MP_IOMUXC_ENET_TD3__ENET_QOS_RGMII_TD3		0x16
+			MX8MP_IOMUXC_ENET_TX_CTL__ENET_QOS_RGMII_TX_CTL		0x16
+			MX8MP_IOMUXC_ENET_TXC__CCM_ENET_QOS_CLOCK_GENERATE_TX_CLK	0x16
 			MX8MP_IOMUXC_SAI1_MCLK__GPIO4_IO20			0x10
 		>;
 	};
 
 	pinctrl_i2c2: i2c2grp {
 		fsl,pins = <
-			MX8MP_IOMUXC_I2C2_SCL__I2C2_SCL		0x400001c3
-			MX8MP_IOMUXC_I2C2_SDA__I2C2_SDA		0x400001c3
+			MX8MP_IOMUXC_I2C2_SCL__I2C2_SCL		0x400001c2
+			MX8MP_IOMUXC_I2C2_SDA__I2C2_SDA		0x400001c2
 		>;
 	};
 
 	pinctrl_i2c2_gpio: i2c2gpiogrp {
 		fsl,pins = <
-			MX8MP_IOMUXC_I2C2_SCL__GPIO5_IO16	0x1e3
-			MX8MP_IOMUXC_I2C2_SDA__GPIO5_IO17	0x1e3
+			MX8MP_IOMUXC_I2C2_SCL__GPIO5_IO16	0x1e2
+			MX8MP_IOMUXC_I2C2_SDA__GPIO5_IO17	0x1e2
 		>;
 	};
 
 	pinctrl_reg_usdhc2_vmmc: regusdhc2vmmcgrp {
 		fsl,pins = <
-			MX8MP_IOMUXC_SD2_RESET_B__GPIO2_IO19	0x41
+			MX8MP_IOMUXC_SD2_RESET_B__GPIO2_IO19	0x40
 		>;
 	};
 
 	pinctrl_uart1: uart1grp {
 		fsl,pins = <
-			MX8MP_IOMUXC_UART1_RXD__UART1_DCE_RX	0x49
-			MX8MP_IOMUXC_UART1_TXD__UART1_DCE_TX	0x49
+			MX8MP_IOMUXC_UART1_RXD__UART1_DCE_RX	0x40
+			MX8MP_IOMUXC_UART1_TXD__UART1_DCE_TX	0x40
 		>;
 	};
 
@@ -175,7 +175,7 @@ MX8MP_IOMUXC_SD2_DATA0__USDHC2_DATA0	0x1d0
 			MX8MP_IOMUXC_SD2_DATA1__USDHC2_DATA1	0x1d0
 			MX8MP_IOMUXC_SD2_DATA2__USDHC2_DATA2	0x1d0
 			MX8MP_IOMUXC_SD2_DATA3__USDHC2_DATA3	0x1d0
-			MX8MP_IOMUXC_GPIO1_IO04__USDHC2_VSELECT	0xc1
+			MX8MP_IOMUXC_GPIO1_IO04__USDHC2_VSELECT	0xc0
 		>;
 	};
 
@@ -187,7 +187,7 @@ MX8MP_IOMUXC_SD2_DATA0__USDHC2_DATA0	0x1d4
 			MX8MP_IOMUXC_SD2_DATA1__USDHC2_DATA1	0x1d4
 			MX8MP_IOMUXC_SD2_DATA2__USDHC2_DATA2	0x1d4
 			MX8MP_IOMUXC_SD2_DATA3__USDHC2_DATA3	0x1d4
-			MX8MP_IOMUXC_GPIO1_IO04__USDHC2_VSELECT	0xc1
+			MX8MP_IOMUXC_GPIO1_IO04__USDHC2_VSELECT	0xc0
 		>;
 	};
 
@@ -199,7 +199,7 @@ MX8MP_IOMUXC_SD2_DATA0__USDHC2_DATA0	0x1d6
 			MX8MP_IOMUXC_SD2_DATA1__USDHC2_DATA1	0x1d6
 			MX8MP_IOMUXC_SD2_DATA2__USDHC2_DATA2	0x1d6
 			MX8MP_IOMUXC_SD2_DATA3__USDHC2_DATA3	0x1d6
-			MX8MP_IOMUXC_GPIO1_IO04__USDHC2_VSELECT	0xc1
+			MX8MP_IOMUXC_GPIO1_IO04__USDHC2_VSELECT	0xc0
 		>;
 	};
 };
diff --git a/arch/arm64/boot/dts/qcom/msm8992-bullhead-rev-101.dts b/arch/arm64/boot/dts/qcom/msm8992-bullhead-rev-101.dts
index 1ccca83292ac..c7d191dc6d4b 100644
--- a/arch/arm64/boot/dts/qcom/msm8992-bullhead-rev-101.dts
+++ b/arch/arm64/boot/dts/qcom/msm8992-bullhead-rev-101.dts
@@ -74,7 +74,7 @@ pm8994_regulators: pm8994-regulators {
 		vdd_l17_29-supply = <&vph_pwr>;
 		vdd_l20_21-supply = <&vph_pwr>;
 		vdd_l25-supply = <&pm8994_s5>;
-		vdd_lvs1_2 = <&pm8994_s4>;
+		vdd_lvs1_2-supply = <&pm8994_s4>;
 
 		/* S1, S2, S6 and S12 are managed by RPMPD */
 
diff --git a/arch/arm64/boot/dts/qcom/msm8992-xiaomi-libra.dts b/arch/arm64/boot/dts/qcom/msm8992-xiaomi-libra.dts
index 357d55496e75..a3d6340a0c55 100644
--- a/arch/arm64/boot/dts/qcom/msm8992-xiaomi-libra.dts
+++ b/arch/arm64/boot/dts/qcom/msm8992-xiaomi-libra.dts
@@ -142,7 +142,7 @@ pm8994-regulators {
 		vdd_l17_29-supply = <&vph_pwr>;
 		vdd_l20_21-supply = <&vph_pwr>;
 		vdd_l25-supply = <&pm8994_s5>;
-		vdd_lvs1_2 = <&pm8994_s4>;
+		vdd_lvs1_2-supply = <&pm8994_s4>;
 
 		/* S1, S2, S6 and S12 are managed by RPMPD */
 
diff --git a/arch/arm64/boot/dts/qcom/msm8994.dtsi b/arch/arm64/boot/dts/qcom/msm8994.dtsi
index 3c27671c8b5c..a8dc8163ee82 100644
--- a/arch/arm64/boot/dts/qcom/msm8994.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8994.dtsi
@@ -93,7 +93,7 @@ CPU5: cpu@101 {
 		CPU6: cpu@102 {
 			device_type = "cpu";
 			compatible = "arm,cortex-a57";
-			reg = <0x0 0x101>;
+			reg = <0x0 0x102>;
 			enable-method = "psci";
 			next-level-cache = <&L2_1>;
 		};
@@ -101,7 +101,7 @@ CPU6: cpu@102 {
 		CPU7: cpu@103 {
 			device_type = "cpu";
 			compatible = "arm,cortex-a57";
-			reg = <0x0 0x101>;
+			reg = <0x0 0x103>;
 			enable-method = "psci";
 			next-level-cache = <&L2_1>;
 		};
diff --git a/arch/arm64/boot/dts/qcom/sdm845.dtsi b/arch/arm64/boot/dts/qcom/sdm845.dtsi
index d20eacfc1017..ea7a272d267a 100644
--- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
@@ -4147,7 +4147,7 @@ mdss: mdss@ae00000 {
 
 			power-domains = <&dispcc MDSS_GDSC>;
 
-			clocks = <&gcc GCC_DISP_AHB_CLK>,
+			clocks = <&dispcc DISP_CC_MDSS_AHB_CLK>,
 				 <&dispcc DISP_CC_MDSS_MDP_CLK>;
 			clock-names = "iface", "core";
 
diff --git a/arch/arm64/include/asm/arch_gicv3.h b/arch/arm64/include/asm/arch_gicv3.h
index 4ad22c3135db..5a0f792492af 100644
--- a/arch/arm64/include/asm/arch_gicv3.h
+++ b/arch/arm64/include/asm/arch_gicv3.h
@@ -26,12 +26,6 @@
  * sets the GP register's most significant bits to 0 with an explicit cast.
  */
 
-static inline void gic_write_eoir(u32 irq)
-{
-	write_sysreg_s(irq, SYS_ICC_EOIR1_EL1);
-	isb();
-}
-
 static __always_inline void gic_write_dir(u32 irq)
 {
 	write_sysreg_s(irq, SYS_ICC_DIR_EL1);
diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index 95439bbe5df8..4895b4d7e150 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -788,7 +788,10 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 		u64 imm64;
 
 		imm64 = (u64)insn1.imm << 32 | (u32)imm;
-		emit_a64_mov_i64(dst, imm64, ctx);
+		if (bpf_pseudo_func(insn))
+			emit_addr_mov_i64(dst, imm64, ctx);
+		else
+			emit_a64_mov_i64(dst, imm64, ctx);
 
 		return 1;
 	}
diff --git a/arch/powerpc/boot/crt0.S b/arch/powerpc/boot/crt0.S
index 1d83966f5ef6..e8f10a599659 100644
--- a/arch/powerpc/boot/crt0.S
+++ b/arch/powerpc/boot/crt0.S
@@ -226,16 +226,19 @@ p_base:	mflr	r10		/* r10 now points to runtime addr of p_base */
 #ifdef __powerpc64__
 
 #define PROM_FRAME_SIZE 512
-#define SAVE_GPR(n, base)       std     n,8*(n)(base)
-#define REST_GPR(n, base)       ld      n,8*(n)(base)
-#define SAVE_2GPRS(n, base)     SAVE_GPR(n, base); SAVE_GPR(n+1, base)
-#define SAVE_4GPRS(n, base)     SAVE_2GPRS(n, base); SAVE_2GPRS(n+2, base)
-#define SAVE_8GPRS(n, base)     SAVE_4GPRS(n, base); SAVE_4GPRS(n+4, base)
-#define SAVE_10GPRS(n, base)    SAVE_8GPRS(n, base); SAVE_2GPRS(n+8, base)
-#define REST_2GPRS(n, base)     REST_GPR(n, base); REST_GPR(n+1, base)
-#define REST_4GPRS(n, base)     REST_2GPRS(n, base); REST_2GPRS(n+2, base)
-#define REST_8GPRS(n, base)     REST_4GPRS(n, base); REST_4GPRS(n+4, base)
-#define REST_10GPRS(n, base)    REST_8GPRS(n, base); REST_2GPRS(n+8, base)
+
+.macro OP_REGS op, width, start, end, base, offset
+	.Lreg=\start
+	.rept (\end - \start + 1)
+	\op	.Lreg,\offset+\width*.Lreg(\base)
+	.Lreg=.Lreg+1
+	.endr
+.endm
+
+#define SAVE_GPRS(start, end, base)	OP_REGS std, 8, start, end, base, 0
+#define REST_GPRS(start, end, base)	OP_REGS ld, 8, start, end, base, 0
+#define SAVE_GPR(n, base)		SAVE_GPRS(n, n, base)
+#define REST_GPR(n, base)		REST_GPRS(n, n, base)
 
 /* prom handles the jump into and return from firmware.  The prom args pointer
    is loaded in r3. */
@@ -246,9 +249,7 @@ prom:
 	stdu	r1,-PROM_FRAME_SIZE(r1) /* Save SP and create stack space */
 
 	SAVE_GPR(2, r1)
-	SAVE_GPR(13, r1)
-	SAVE_8GPRS(14, r1)
-	SAVE_10GPRS(22, r1)
+	SAVE_GPRS(13, 31, r1)
 	mfcr    r10
 	std     r10,8*32(r1)
 	mfmsr   r10
@@ -283,9 +284,7 @@ prom:
 
 	/* Restore other registers */
 	REST_GPR(2, r1)
-	REST_GPR(13, r1)
-	REST_8GPRS(14, r1)
-	REST_10GPRS(22, r1)
+	REST_GPRS(13, 31, r1)
 	ld      r10,8*32(r1)
 	mtcr	r10
 
diff --git a/arch/powerpc/crypto/md5-asm.S b/arch/powerpc/crypto/md5-asm.S
index 948d100a2934..fa6bc440cf4a 100644
--- a/arch/powerpc/crypto/md5-asm.S
+++ b/arch/powerpc/crypto/md5-asm.S
@@ -38,15 +38,11 @@
 
 #define INITIALIZE \
 	PPC_STLU r1,-INT_FRAME_SIZE(r1); \
-	SAVE_8GPRS(14, r1);		/* push registers onto stack	*/ \
-	SAVE_4GPRS(22, r1);						   \
-	SAVE_GPR(26, r1)
+	SAVE_GPRS(14, 26, r1)		/* push registers onto stack	*/
 
 #define FINALIZE \
-	REST_8GPRS(14, r1);		/* pop registers from stack	*/ \
-	REST_4GPRS(22, r1);						   \
-	REST_GPR(26, r1);						   \
-	addi	r1,r1,INT_FRAME_SIZE;
+	REST_GPRS(14, 26, r1);		/* pop registers from stack	*/ \
+	addi	r1,r1,INT_FRAME_SIZE
 
 #ifdef __BIG_ENDIAN__
 #define LOAD_DATA(reg, off) \
diff --git a/arch/powerpc/crypto/sha1-powerpc-asm.S b/arch/powerpc/crypto/sha1-powerpc-asm.S
index 23e248beff71..f0d5ed557ab1 100644
--- a/arch/powerpc/crypto/sha1-powerpc-asm.S
+++ b/arch/powerpc/crypto/sha1-powerpc-asm.S
@@ -125,8 +125,7 @@
 
 _GLOBAL(powerpc_sha_transform)
 	PPC_STLU r1,-INT_FRAME_SIZE(r1)
-	SAVE_8GPRS(14, r1)
-	SAVE_10GPRS(22, r1)
+	SAVE_GPRS(14, 31, r1)
 
 	/* Load up A - E */
 	lwz	RA(0),0(r3)	/* A */
@@ -184,7 +183,6 @@ _GLOBAL(powerpc_sha_transform)
 	stw	RD(0),12(r3)
 	stw	RE(0),16(r3)
 
-	REST_8GPRS(14, r1)
-	REST_10GPRS(22, r1)
+	REST_GPRS(14, 31, r1)
 	addi	r1,r1,INT_FRAME_SIZE
 	blr
diff --git a/arch/powerpc/include/asm/ppc_asm.h b/arch/powerpc/include/asm/ppc_asm.h
index 1c538a9a11e0..f21e6bde17a1 100644
--- a/arch/powerpc/include/asm/ppc_asm.h
+++ b/arch/powerpc/include/asm/ppc_asm.h
@@ -16,30 +16,41 @@
 
 #define SZL			(BITS_PER_LONG/8)
 
+/*
+ * This expands to a sequence of operations with reg incrementing from
+ * start to end inclusive, of this form:
+ *
+ *   op  reg, (offset + (width * reg))(base)
+ *
+ * Note that offset is not the offset of the first operation unless start
+ * is zero (or width is zero).
+ */
+.macro OP_REGS op, width, start, end, base, offset
+	.Lreg=\start
+	.rept (\end - \start + 1)
+	\op	.Lreg, \offset + \width * .Lreg(\base)
+	.Lreg=.Lreg+1
+	.endr
+.endm
+
 /*
  * Macros for storing registers into and loading registers from
  * exception frames.
  */
 #ifdef __powerpc64__
-#define SAVE_GPR(n, base)	std	n,GPR0+8*(n)(base)
-#define REST_GPR(n, base)	ld	n,GPR0+8*(n)(base)
-#define SAVE_NVGPRS(base)	SAVE_8GPRS(14, base); SAVE_10GPRS(22, base)
-#define REST_NVGPRS(base)	REST_8GPRS(14, base); REST_10GPRS(22, base)
+#define SAVE_GPRS(start, end, base)	OP_REGS std, 8, start, end, base, GPR0
+#define REST_GPRS(start, end, base)	OP_REGS ld, 8, start, end, base, GPR0
+#define SAVE_NVGPRS(base)		SAVE_GPRS(14, 31, base)
+#define REST_NVGPRS(base)		REST_GPRS(14, 31, base)
 #else
-#define SAVE_GPR(n, base)	stw	n,GPR0+4*(n)(base)
-#define REST_GPR(n, base)	lwz	n,GPR0+4*(n)(base)
-#define SAVE_NVGPRS(base)	stmw	13, GPR0+4*13(base)
-#define REST_NVGPRS(base)	lmw	13, GPR0+4*13(base)
+#define SAVE_GPRS(start, end, base)	OP_REGS stw, 4, start, end, base, GPR0
+#define REST_GPRS(start, end, base)	OP_REGS lwz, 4, start, end, base, GPR0
+#define SAVE_NVGPRS(base)		SAVE_GPRS(13, 31, base)
+#define REST_NVGPRS(base)		REST_GPRS(13, 31, base)
 #endif
 
-#define SAVE_2GPRS(n, base)	SAVE_GPR(n, base); SAVE_GPR(n+1, base)
-#define SAVE_4GPRS(n, base)	SAVE_2GPRS(n, base); SAVE_2GPRS(n+2, base)
-#define SAVE_8GPRS(n, base)	SAVE_4GPRS(n, base); SAVE_4GPRS(n+4, base)
-#define SAVE_10GPRS(n, base)	SAVE_8GPRS(n, base); SAVE_2GPRS(n+8, base)
-#define REST_2GPRS(n, base)	REST_GPR(n, base); REST_GPR(n+1, base)
-#define REST_4GPRS(n, base)	REST_2GPRS(n, base); REST_2GPRS(n+2, base)
-#define REST_8GPRS(n, base)	REST_4GPRS(n, base); REST_4GPRS(n+4, base)
-#define REST_10GPRS(n, base)	REST_8GPRS(n, base); REST_2GPRS(n+8, base)
+#define SAVE_GPR(n, base)		SAVE_GPRS(n, n, base)
+#define REST_GPR(n, base)		REST_GPRS(n, n, base)
 
 #define SAVE_FPR(n, base)	stfd	n,8*TS_FPRWIDTH*(n)(base)
 #define SAVE_2FPRS(n, base)	SAVE_FPR(n, base); SAVE_FPR(n+1, base)
diff --git a/arch/powerpc/kernel/entry_32.S b/arch/powerpc/kernel/entry_32.S
index 61fdd53cdd9a..c62dd9815965 100644
--- a/arch/powerpc/kernel/entry_32.S
+++ b/arch/powerpc/kernel/entry_32.S
@@ -90,8 +90,7 @@ transfer_to_syscall:
 	stw	r12,8(r1)
 	stw	r2,_TRAP(r1)
 	SAVE_GPR(0, r1)
-	SAVE_4GPRS(3, r1)
-	SAVE_2GPRS(7, r1)
+	SAVE_GPRS(3, 8, r1)
 	addi	r2,r10,-THREAD
 	SAVE_NVGPRS(r1)
 
@@ -139,7 +138,7 @@ syscall_exit_finish:
 	mtxer	r5
 	lwz	r0,GPR0(r1)
 	lwz	r3,GPR3(r1)
-	REST_8GPRS(4,r1)
+	REST_GPRS(4, 11, r1)
 	lwz	r12,GPR12(r1)
 	b	1b
 
@@ -232,9 +231,9 @@ fast_exception_return:
 	beq	3f			/* if not, we've got problems */
 #endif
 
-2:	REST_4GPRS(3, r11)
+2:	REST_GPRS(3, 6, r11)
 	lwz	r10,_CCR(r11)
-	REST_2GPRS(1, r11)
+	REST_GPRS(1, 2, r11)
 	mtcr	r10
 	lwz	r10,_LINK(r11)
 	mtlr	r10
@@ -298,16 +297,14 @@ ALT_FTR_SECTION_END_IFCLR(CPU_FTR_STCX_CHECKS_ADDRESS)
 	 * the reliable stack unwinder later on. Clear it.
 	 */
 	stw	r0,8(r1)
-	REST_4GPRS(7, r1)
-	REST_2GPRS(11, r1)
+	REST_GPRS(7, 12, r1)
 
 	mtcr	r3
 	mtlr	r4
 	mtctr	r5
 	mtspr	SPRN_XER,r6
 
-	REST_4GPRS(2, r1)
-	REST_GPR(6, r1)
+	REST_GPRS(2, 6, r1)
 	REST_GPR(0, r1)
 	REST_GPR(1, r1)
 	rfi
@@ -341,8 +338,7 @@ ALT_FTR_SECTION_END_IFCLR(CPU_FTR_STCX_CHECKS_ADDRESS)
 	lwz	r6,_CCR(r1)
 	li	r0,0
 
-	REST_4GPRS(7, r1)
-	REST_2GPRS(11, r1)
+	REST_GPRS(7, 12, r1)
 
 	mtlr	r3
 	mtctr	r4
@@ -354,7 +350,7 @@ ALT_FTR_SECTION_END_IFCLR(CPU_FTR_STCX_CHECKS_ADDRESS)
 	 */
 	stw	r0,8(r1)
 
-	REST_4GPRS(2, r1)
+	REST_GPRS(2, 5, r1)
 
 	bne-	cr1,1f /* emulate stack store */
 	mtcr	r6
@@ -430,8 +426,7 @@ _ASM_NOKPROBE_SYMBOL(interrupt_return)
 	bne	interrupt_return;					\
 	lwz	r0,GPR0(r1);						\
 	lwz	r2,GPR2(r1);						\
-	REST_4GPRS(3, r1);						\
-	REST_2GPRS(7, r1);						\
+	REST_GPRS(3, 8, r1);						\
 	lwz	r10,_XER(r1);						\
 	lwz	r11,_CTR(r1);						\
 	mtspr	SPRN_XER,r10;						\
diff --git a/arch/powerpc/kernel/exceptions-64e.S b/arch/powerpc/kernel/exceptions-64e.S
index 711c66b76df1..67dc4e3179a0 100644
--- a/arch/powerpc/kernel/exceptions-64e.S
+++ b/arch/powerpc/kernel/exceptions-64e.S
@@ -198,8 +198,7 @@ END_FTR_SECTION_IFSET(CPU_FTR_EMB_HV)
 
 	stdcx.	r0,0,r1		/* to clear the reservation */
 
-	REST_4GPRS(2, r1)
-	REST_4GPRS(6, r1)
+	REST_GPRS(2, 9, r1)
 
 	ld	r10,_CTR(r1)
 	ld	r11,_XER(r1)
@@ -375,9 +374,7 @@ ret_from_mc_except:
 exc_##n##_common:							    \
 	std	r0,GPR0(r1);		/* save r0 in stackframe */	    \
 	std	r2,GPR2(r1);		/* save r2 in stackframe */	    \
-	SAVE_4GPRS(3, r1);		/* save r3 - r6 in stackframe */    \
-	SAVE_2GPRS(7, r1);		/* save r7, r8 in stackframe */	    \
-	std	r9,GPR9(r1);		/* save r9 in stackframe */	    \
+	SAVE_GPRS(3, 9, r1);		/* save r3 - r9 in stackframe */    \
 	std	r10,_NIP(r1);		/* save SRR0 to stackframe */	    \
 	std	r11,_MSR(r1);		/* save SRR1 to stackframe */	    \
 	beq	2f;			/* if from kernel mode */	    \
@@ -1061,9 +1058,7 @@ bad_stack_book3e:
 	std	r11,_ESR(r1)
 	std	r0,GPR0(r1);		/* save r0 in stackframe */	    \
 	std	r2,GPR2(r1);		/* save r2 in stackframe */	    \
-	SAVE_4GPRS(3, r1);		/* save r3 - r6 in stackframe */    \
-	SAVE_2GPRS(7, r1);		/* save r7, r8 in stackframe */	    \
-	std	r9,GPR9(r1);		/* save r9 in stackframe */	    \
+	SAVE_GPRS(3, 9, r1);		/* save r3 - r9 in stackframe */    \
 	ld	r3,PACA_EXGEN+EX_R10(r13);/* get back r10 */		    \
 	ld	r4,PACA_EXGEN+EX_R11(r13);/* get back r11 */		    \
 	mfspr	r5,SPRN_SPRG_GEN_SCRATCH;/* get back r13 XXX can be wrong */ \
@@ -1077,8 +1072,7 @@ bad_stack_book3e:
 	std	r10,_LINK(r1)
 	std	r11,_CTR(r1)
 	std	r12,_XER(r1)
-	SAVE_10GPRS(14,r1)
-	SAVE_8GPRS(24,r1)
+	SAVE_GPRS(14, 31, r1)
 	lhz	r12,PACA_TRAP_SAVE(r13)
 	std	r12,_TRAP(r1)
 	addi	r11,r1,INT_FRAME_SIZE
diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exceptions-64s.S
index eaf1f72131a1..277eccf0f086 100644
--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -574,8 +574,7 @@ END_FTR_SECTION_IFSET(CPU_FTR_CFAR)
 	ld	r10,IAREA+EX_CTR(r13)
 	std	r10,_CTR(r1)
 	std	r2,GPR2(r1)		/* save r2 in stackframe	*/
-	SAVE_4GPRS(3, r1)		/* save r3 - r6 in stackframe   */
-	SAVE_2GPRS(7, r1)		/* save r7, r8 in stackframe	*/
+	SAVE_GPRS(3, 8, r1)		/* save r3 - r8 in stackframe   */
 	mflr	r9			/* Get LR, later save to stack	*/
 	ld	r2,PACATOC(r13)		/* get kernel TOC into r2	*/
 	std	r9,_LINK(r1)
@@ -693,8 +692,7 @@ END_FTR_SECTION_IFSET(CPU_FTR_CFAR)
 	mtlr	r9
 	ld	r9,_CCR(r1)
 	mtcr	r9
-	REST_8GPRS(2, r1)
-	REST_4GPRS(10, r1)
+	REST_GPRS(2, 13, r1)
 	REST_GPR(0, r1)
 	/* restore original r1. */
 	ld	r1,GPR1(r1)
diff --git a/arch/powerpc/kernel/head_32.h b/arch/powerpc/kernel/head_32.h
index 349c4a820231..261c79bdbe53 100644
--- a/arch/powerpc/kernel/head_32.h
+++ b/arch/powerpc/kernel/head_32.h
@@ -115,8 +115,7 @@ _ASM_NOKPROBE_SYMBOL(\name\()_virt)
 	stw	r10,8(r1)
 	li	r10, \trapno
 	stw	r10,_TRAP(r1)
-	SAVE_4GPRS(3, r1)
-	SAVE_2GPRS(7, r1)
+	SAVE_GPRS(3, 8, r1)
 	SAVE_NVGPRS(r1)
 	stw	r2,GPR2(r1)
 	stw	r12,_NIP(r1)
diff --git a/arch/powerpc/kernel/head_booke.h b/arch/powerpc/kernel/head_booke.h
index ef8d1b1c234e..bb6d5d0fc4ac 100644
--- a/arch/powerpc/kernel/head_booke.h
+++ b/arch/powerpc/kernel/head_booke.h
@@ -87,8 +87,7 @@ END_BTB_FLUSH_SECTION
 	stw	r10, 8(r1)
 	li	r10, \trapno
 	stw	r10,_TRAP(r1)
-	SAVE_4GPRS(3, r1)
-	SAVE_2GPRS(7, r1)
+	SAVE_GPRS(3, 8, r1)
 	SAVE_NVGPRS(r1)
 	stw	r2,GPR2(r1)
 	stw	r12,_NIP(r1)
diff --git a/arch/powerpc/kernel/interrupt_64.S b/arch/powerpc/kernel/interrupt_64.S
index 4c6d1a8dcefe..ff8c8c03f41a 100644
--- a/arch/powerpc/kernel/interrupt_64.S
+++ b/arch/powerpc/kernel/interrupt_64.S
@@ -166,10 +166,9 @@ END_FTR_SECTION_IFSET(CPU_FTR_HAS_PPR)
 	 * The value of AMR only matters while we're in the kernel.
 	 */
 	mtcr	r2
-	ld	r2,GPR2(r1)
-	ld	r3,GPR3(r1)
-	ld	r13,GPR13(r1)
-	ld	r1,GPR1(r1)
+	REST_GPRS(2, 3, r1)
+	REST_GPR(13, r1)
+	REST_GPR(1, r1)
 	RFSCV_TO_USER
 	b	.	/* prevent speculative execution */
 
@@ -187,9 +186,8 @@ END_FTR_SECTION_IFSET(CPU_FTR_HAS_PPR)
 	mtctr	r3
 	mtlr	r4
 	mtspr	SPRN_XER,r5
-	REST_10GPRS(2, r1)
-	REST_2GPRS(12, r1)
-	ld	r1,GPR1(r1)
+	REST_GPRS(2, 13, r1)
+	REST_GPR(1, r1)
 	RFI_TO_USER
 .Lsyscall_vectored_\name\()_rst_end:
 
@@ -378,10 +376,9 @@ END_FTR_SECTION_IFSET(CPU_FTR_HAS_PPR)
 	 * The value of AMR only matters while we're in the kernel.
 	 */
 	mtcr	r2
-	ld	r2,GPR2(r1)
-	ld	r3,GPR3(r1)
-	ld	r13,GPR13(r1)
-	ld	r1,GPR1(r1)
+	REST_GPRS(2, 3, r1)
+	REST_GPR(13, r1)
+	REST_GPR(1, r1)
 	RFI_TO_USER
 	b	.	/* prevent speculative execution */
 
@@ -392,8 +389,7 @@ END_FTR_SECTION_IFSET(CPU_FTR_HAS_PPR)
 	mtctr	r3
 	mtspr	SPRN_XER,r4
 	ld	r0,GPR0(r1)
-	REST_8GPRS(4, r1)
-	ld	r12,GPR12(r1)
+	REST_GPRS(4, 12, r1)
 	b	.Lsyscall_restore_regs_cont
 .Lsyscall_rst_end:
 
@@ -522,17 +518,14 @@ ALT_FTR_SECTION_END_IFCLR(CPU_FTR_STCX_CHECKS_ADDRESS)
 	ld	r6,_XER(r1)
 	li	r0,0
 
-	REST_4GPRS(7, r1)
-	REST_2GPRS(11, r1)
-	REST_GPR(13, r1)
+	REST_GPRS(7, 13, r1)
 
 	mtcr	r3
 	mtlr	r4
 	mtctr	r5
 	mtspr	SPRN_XER,r6
 
-	REST_4GPRS(2, r1)
-	REST_GPR(6, r1)
+	REST_GPRS(2, 6, r1)
 	REST_GPR(0, r1)
 	REST_GPR(1, r1)
 	.ifc \srr,srr
@@ -629,8 +622,7 @@ ALT_FTR_SECTION_END_IFCLR(CPU_FTR_STCX_CHECKS_ADDRESS)
 	ld	r6,_CCR(r1)
 	li	r0,0
 
-	REST_4GPRS(7, r1)
-	REST_2GPRS(11, r1)
+	REST_GPRS(7, 12, r1)
 
 	mtlr	r3
 	mtctr	r4
@@ -642,7 +634,7 @@ ALT_FTR_SECTION_END_IFCLR(CPU_FTR_STCX_CHECKS_ADDRESS)
 	 */
 	std	r0,STACK_FRAME_OVERHEAD-16(r1)
 
-	REST_4GPRS(2, r1)
+	REST_GPRS(2, 5, r1)
 
 	bne-	cr1,1f /* emulate stack store */
 	mtcr	r6
diff --git a/arch/powerpc/kernel/optprobes_head.S b/arch/powerpc/kernel/optprobes_head.S
index 19ea3312403c..5c7f0b4b784b 100644
--- a/arch/powerpc/kernel/optprobes_head.S
+++ b/arch/powerpc/kernel/optprobes_head.S
@@ -10,8 +10,8 @@
 #include <asm/asm-offsets.h>
 
 #ifdef CONFIG_PPC64
-#define SAVE_30GPRS(base) SAVE_10GPRS(2,base); SAVE_10GPRS(12,base); SAVE_10GPRS(22,base)
-#define REST_30GPRS(base) REST_10GPRS(2,base); REST_10GPRS(12,base); REST_10GPRS(22,base)
+#define SAVE_30GPRS(base) SAVE_GPRS(2, 31, base)
+#define REST_30GPRS(base) REST_GPRS(2, 31, base)
 #define TEMPLATE_FOR_IMM_LOAD_INSNS	nop; nop; nop; nop; nop
 #else
 #define SAVE_30GPRS(base) stmw	r2, GPR2(base)
diff --git a/arch/powerpc/kernel/tm.S b/arch/powerpc/kernel/tm.S
index 2b91f233b05d..5a0f023a26e9 100644
--- a/arch/powerpc/kernel/tm.S
+++ b/arch/powerpc/kernel/tm.S
@@ -226,11 +226,8 @@ _GLOBAL(tm_reclaim)
 
 	/* Sync the userland GPRs 2-12, 14-31 to thread->regs: */
 	SAVE_GPR(0, r7)				/* user r0 */
-	SAVE_GPR(2, r7)				/* user r2 */
-	SAVE_4GPRS(3, r7)			/* user r3-r6 */
-	SAVE_GPR(8, r7)				/* user r8 */
-	SAVE_GPR(9, r7)				/* user r9 */
-	SAVE_GPR(10, r7)			/* user r10 */
+	SAVE_GPRS(2, 6, r7)			/* user r2-r6 */
+	SAVE_GPRS(8, 10, r7)			/* user r8-r10 */
 	ld	r3, GPR1(r1)			/* user r1 */
 	ld	r4, GPR7(r1)			/* user r7 */
 	ld	r5, GPR11(r1)			/* user r11 */
@@ -445,12 +442,9 @@ restore_gprs:
 	ld	r6, THREAD_TM_PPR(r3)
 
 	REST_GPR(0, r7)				/* GPR0 */
-	REST_2GPRS(2, r7)			/* GPR2-3 */
-	REST_GPR(4, r7)				/* GPR4 */
-	REST_4GPRS(8, r7)			/* GPR8-11 */
-	REST_2GPRS(12, r7)			/* GPR12-13 */
-
-	REST_NVGPRS(r7)				/* GPR14-31 */
+	REST_GPRS(2, 4, r7)			/* GPR2-4 */
+	REST_GPRS(8, 12, r7)			/* GPR8-12 */
+	REST_GPRS(14, 31, r7)			/* GPR14-31 */
 
 	/* Load up PPR and DSCR here so we don't run with user values for long */
 	mtspr	SPRN_DSCR, r5
@@ -486,18 +480,24 @@ restore_gprs:
 	REST_GPR(6, r7)
 
 	/*
-	 * Store r1 and r5 on the stack so that we can access them after we
-	 * clear MSR RI.
+	 * Store user r1 and r5 and r13 on the stack (in the unused save
+	 * areas / compiler reserved areas), so that we can access them after
+	 * we clear MSR RI.
 	 */
 
 	REST_GPR(5, r7)
 	std	r5, -8(r1)
-	ld	r5, GPR1(r7)
+	ld	r5, GPR13(r7)
 	std	r5, -16(r1)
+	ld	r5, GPR1(r7)
+	std	r5, -24(r1)
 
 	REST_GPR(7, r7)
 
-	/* Clear MSR RI since we are about to use SCRATCH0. EE is already off */
+	/* Stash the stack pointer away for use after recheckpoint */
+	std	r1, PACAR1(r13)
+
+	/* Clear MSR RI since we are about to clobber r13. EE is already off */
 	li	r5, 0
 	mtmsrd	r5, 1
 
@@ -508,9 +508,9 @@ restore_gprs:
 	 * until we turn MSR RI back on.
 	 */
 
-	SET_SCRATCH0(r1)
 	ld	r5, -8(r1)
-	ld	r1, -16(r1)
+	ld	r13, -16(r1)
+	ld	r1, -24(r1)
 
 	/* Commit register state as checkpointed state: */
 	TRECHKPT
@@ -526,9 +526,9 @@ restore_gprs:
 	 */
 
 	GET_PACA(r13)
-	GET_SCRATCH0(r1)
+	ld	r1, PACAR1(r13)
 
-	/* R1 is restored, so we are recoverable again.  EE is still off */
+	/* R13, R1 is restored, so we are recoverable again.  EE is still off */
 	li	r4, MSR_RI
 	mtmsrd	r4, 1
 
diff --git a/arch/powerpc/kernel/trace/ftrace_64_mprofile.S b/arch/powerpc/kernel/trace/ftrace_64_mprofile.S
index f9fd5f743eba..d636fc755f60 100644
--- a/arch/powerpc/kernel/trace/ftrace_64_mprofile.S
+++ b/arch/powerpc/kernel/trace/ftrace_64_mprofile.S
@@ -41,15 +41,14 @@ _GLOBAL(ftrace_regs_caller)
 
 	/* Save all gprs to pt_regs */
 	SAVE_GPR(0, r1)
-	SAVE_10GPRS(2, r1)
+	SAVE_GPRS(2, 11, r1)
 
 	/* Ok to continue? */
 	lbz	r3, PACA_FTRACE_ENABLED(r13)
 	cmpdi	r3, 0
 	beq	ftrace_no_trace
 
-	SAVE_10GPRS(12, r1)
-	SAVE_10GPRS(22, r1)
+	SAVE_GPRS(12, 31, r1)
 
 	/* Save previous stack pointer (r1) */
 	addi	r8, r1, SWITCH_FRAME_SIZE
@@ -108,10 +107,8 @@ ftrace_regs_call:
 #endif
 
 	/* Restore gprs */
-	REST_GPR(0,r1)
-	REST_10GPRS(2,r1)
-	REST_10GPRS(12,r1)
-	REST_10GPRS(22,r1)
+	REST_GPR(0, r1)
+	REST_GPRS(2, 31, r1)
 
 	/* Restore possibly modified LR */
 	ld	r0, _LINK(r1)
@@ -157,7 +154,7 @@ _GLOBAL(ftrace_caller)
 	stdu	r1, -SWITCH_FRAME_SIZE(r1)
 
 	/* Save all gprs to pt_regs */
-	SAVE_8GPRS(3, r1)
+	SAVE_GPRS(3, 10, r1)
 
 	lbz	r3, PACA_FTRACE_ENABLED(r13)
 	cmpdi	r3, 0
@@ -194,7 +191,7 @@ ftrace_call:
 	mtctr	r3
 
 	/* Restore gprs */
-	REST_8GPRS(3,r1)
+	REST_GPRS(3, 10, r1)
 
 	/* Restore callee's TOC */
 	ld	r2, 24(r1)
diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
index 32a4b4d412b9..81fc1e0ebe9a 100644
--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -2711,8 +2711,7 @@ kvmppc_bad_host_intr:
 	std	r0, GPR0(r1)
 	std	r9, GPR1(r1)
 	std	r2, GPR2(r1)
-	SAVE_4GPRS(3, r1)
-	SAVE_2GPRS(7, r1)
+	SAVE_GPRS(3, 8, r1)
 	srdi	r0, r12, 32
 	clrldi	r12, r12, 32
 	std	r0, _CCR(r1)
@@ -2735,7 +2734,7 @@ kvmppc_bad_host_intr:
 	ld	r9, HSTATE_SCRATCH2(r13)
 	ld	r12, HSTATE_SCRATCH0(r13)
 	GET_SCRATCH0(r0)
-	SAVE_4GPRS(9, r1)
+	SAVE_GPRS(9, 12, r1)
 	std	r0, GPR13(r1)
 	SAVE_NVGPRS(r1)
 	ld	r5, HSTATE_CFAR(r13)
diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book3s_hv_uvmem.c
index 3fbe710ff839..3d4ee75b0fb7 100644
--- a/arch/powerpc/kvm/book3s_hv_uvmem.c
+++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -251,7 +251,7 @@ int kvmppc_uvmem_slot_init(struct kvm *kvm, const struct kvm_memory_slot *slot)
 	p = kzalloc(sizeof(*p), GFP_KERNEL);
 	if (!p)
 		return -ENOMEM;
-	p->pfns = vzalloc(array_size(slot->npages, sizeof(*p->pfns)));
+	p->pfns = vcalloc(slot->npages, sizeof(*p->pfns));
 	if (!p->pfns) {
 		kfree(p);
 		return -ENOMEM;
diff --git a/arch/powerpc/lib/test_emulate_step_exec_instr.S b/arch/powerpc/lib/test_emulate_step_exec_instr.S
index 9ef941d958d8..5473f9d03df3 100644
--- a/arch/powerpc/lib/test_emulate_step_exec_instr.S
+++ b/arch/powerpc/lib/test_emulate_step_exec_instr.S
@@ -37,7 +37,7 @@ _GLOBAL(exec_instr)
 	 * The stack pointer (GPR1) and the thread pointer (GPR13) are not
 	 * saved as these should not be modified anyway.
 	 */
-	SAVE_2GPRS(2, r1)
+	SAVE_GPRS(2, 3, r1)
 	SAVE_NVGPRS(r1)
 
 	/*
@@ -75,8 +75,7 @@ _GLOBAL(exec_instr)
 
 	/* Load GPRs from pt_regs */
 	REST_GPR(0, r31)
-	REST_10GPRS(2, r31)
-	REST_GPR(12, r31)
+	REST_GPRS(2, 12, r31)
 	REST_NVGPRS(r31)
 
 	/* Placeholder for the test instruction */
@@ -99,8 +98,7 @@ _GLOBAL(exec_instr)
 	subi	r3, r3, GPR0
 	SAVE_GPR(0, r3)
 	SAVE_GPR(2, r3)
-	SAVE_8GPRS(4, r3)
-	SAVE_GPR(12, r3)
+	SAVE_GPRS(4, 12, r3)
 	SAVE_NVGPRS(r3)
 
 	/* Save resulting LR to pt_regs */
diff --git a/arch/powerpc/platforms/powernv/rng.c b/arch/powerpc/platforms/powernv/rng.c
index 2b5a1a41234c..236bd2ba51b9 100644
--- a/arch/powerpc/platforms/powernv/rng.c
+++ b/arch/powerpc/platforms/powernv/rng.c
@@ -176,12 +176,8 @@ static int __init pnv_get_random_long_early(unsigned long *v)
 		    NULL) != pnv_get_random_long_early)
 		return 0;
 
-	for_each_compatible_node(dn, NULL, "ibm,power-rng") {
-		if (rng_create(dn))
-			continue;
-		/* Create devices for hwrng driver */
-		of_platform_device_create(dn, NULL, NULL);
-	}
+	for_each_compatible_node(dn, NULL, "ibm,power-rng")
+		rng_create(dn);
 
 	if (!ppc_md.get_random_seed)
 		return 0;
@@ -205,10 +201,18 @@ void __init pnv_rng_init(void)
 
 static int __init pnv_rng_late_init(void)
 {
+	struct device_node *dn;
 	unsigned long v;
+
 	/* In case it wasn't called during init for some other reason. */
 	if (ppc_md.get_random_seed == pnv_get_random_long_early)
 		pnv_get_random_long_early(&v);
+
+	if (ppc_md.get_random_seed == powernv_get_random_long) {
+		for_each_compatible_node(dn, NULL, "ibm,power-rng")
+			of_platform_device_create(dn, NULL, NULL);
+	}
+
 	return 0;
 }
 machine_subsys_initcall(powernv, pnv_rng_late_init);
diff --git a/arch/riscv/configs/defconfig b/arch/riscv/configs/defconfig
index 4ebc80315f01..f2a2f9c9ed49 100644
--- a/arch/riscv/configs/defconfig
+++ b/arch/riscv/configs/defconfig
@@ -72,9 +72,11 @@ CONFIG_GPIOLIB=y
 CONFIG_GPIO_SIFIVE=y
 # CONFIG_PTP_1588_CLOCK is not set
 CONFIG_POWER_RESET=y
-CONFIG_DRM=y
-CONFIG_DRM_RADEON=y
-CONFIG_DRM_VIRTIO_GPU=y
+CONFIG_DRM=m
+CONFIG_DRM_RADEON=m
+CONFIG_DRM_NOUVEAU=m
+CONFIG_DRM_VIRTIO_GPU=m
+CONFIG_FB=y
 CONFIG_FRAMEBUFFER_CONSOLE=y
 CONFIG_USB=y
 CONFIG_USB_XHCI_HCD=y
diff --git a/arch/riscv/configs/rv32_defconfig b/arch/riscv/configs/rv32_defconfig
index 434ef5b64599..cdd113e7a291 100644
--- a/arch/riscv/configs/rv32_defconfig
+++ b/arch/riscv/configs/rv32_defconfig
@@ -71,6 +71,7 @@ CONFIG_POWER_RESET=y
 CONFIG_DRM=y
 CONFIG_DRM_RADEON=y
 CONFIG_DRM_VIRTIO_GPU=y
+CONFIG_FB=y
 CONFIG_FRAMEBUFFER_CONSOLE=y
 CONFIG_USB=y
 CONFIG_USB_XHCI_HCD=y
diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index 7f130ac3b9f9..c58a7c77989b 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -265,6 +265,7 @@ pgd_t early_pg_dir[PTRS_PER_PGD] __initdata __aligned(PAGE_SIZE);
 static pmd_t __maybe_unused early_dtb_pmd[PTRS_PER_PMD] __initdata __aligned(PAGE_SIZE);
 
 #ifdef CONFIG_XIP_KERNEL
+#define riscv_pfn_base         (*(unsigned long  *)XIP_FIXUP(&riscv_pfn_base))
 #define trampoline_pg_dir      ((pgd_t *)XIP_FIXUP(trampoline_pg_dir))
 #define fixmap_pte             ((pte_t *)XIP_FIXUP(fixmap_pte))
 #define early_pg_dir           ((pgd_t *)XIP_FIXUP(early_pg_dir))
diff --git a/arch/s390/boot/compressed/decompressor.h b/arch/s390/boot/compressed/decompressor.h
index a59f75c5b049..f75cc31a77dd 100644
--- a/arch/s390/boot/compressed/decompressor.h
+++ b/arch/s390/boot/compressed/decompressor.h
@@ -24,6 +24,7 @@ struct vmlinux_info {
 	unsigned long dynsym_start;
 	unsigned long rela_dyn_start;
 	unsigned long rela_dyn_end;
+	unsigned long amode31_size;
 };
 
 /* Symbols defined by linker scripts */
diff --git a/arch/s390/boot/startup.c b/arch/s390/boot/startup.c
index b13352dd1e1c..1aa11a8f57dd 100644
--- a/arch/s390/boot/startup.c
+++ b/arch/s390/boot/startup.c
@@ -15,6 +15,7 @@
 #include "uv.h"
 
 unsigned long __bootdata_preserved(__kaslr_offset);
+unsigned long __bootdata(__amode31_base);
 unsigned long __bootdata_preserved(VMALLOC_START);
 unsigned long __bootdata_preserved(VMALLOC_END);
 struct page *__bootdata_preserved(vmemmap);
@@ -233,6 +234,12 @@ static void offset_vmlinux_info(unsigned long offset)
 	vmlinux.dynsym_start += offset;
 }
 
+static unsigned long reserve_amode31(unsigned long safe_addr)
+{
+	__amode31_base = PAGE_ALIGN(safe_addr);
+	return safe_addr + vmlinux.amode31_size;
+}
+
 void startup_kernel(void)
 {
 	unsigned long random_lma;
@@ -247,6 +254,7 @@ void startup_kernel(void)
 	setup_lpp();
 	store_ipl_parmblock();
 	safe_addr = mem_safe_offset();
+	safe_addr = reserve_amode31(safe_addr);
 	safe_addr = read_ipl_report(safe_addr);
 	uv_query_info();
 	rescue_initrd(safe_addr);
diff --git a/arch/s390/kernel/entry.h b/arch/s390/kernel/entry.h
index 7f2696e8d511..6083090be1f4 100644
--- a/arch/s390/kernel/entry.h
+++ b/arch/s390/kernel/entry.h
@@ -70,5 +70,6 @@ extern struct exception_table_entry _stop_amode31_ex_table[];
 #define __amode31_data __section(".amode31.data")
 #define __amode31_ref __section(".amode31.refs")
 extern long _start_amode31_refs[], _end_amode31_refs[];
+extern unsigned long __amode31_base;
 
 #endif /* _ENTRY_H */
diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index 8ede12c4ba6b..36c1f31dfd66 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -95,10 +95,10 @@ EXPORT_SYMBOL(console_irq);
  * relocated above 2 GB, because it has to use 31 bit addresses.
  * Such code and data is part of the .amode31 section.
  */
-unsigned long __amode31_ref __samode31 = __pa(&_samode31);
-unsigned long __amode31_ref __eamode31 = __pa(&_eamode31);
-unsigned long __amode31_ref __stext_amode31 = __pa(&_stext_amode31);
-unsigned long __amode31_ref __etext_amode31 = __pa(&_etext_amode31);
+unsigned long __amode31_ref __samode31 = (unsigned long)&_samode31;
+unsigned long __amode31_ref __eamode31 = (unsigned long)&_eamode31;
+unsigned long __amode31_ref __stext_amode31 = (unsigned long)&_stext_amode31;
+unsigned long __amode31_ref __etext_amode31 = (unsigned long)&_etext_amode31;
 struct exception_table_entry __amode31_ref *__start_amode31_ex_table = _start_amode31_ex_table;
 struct exception_table_entry __amode31_ref *__stop_amode31_ex_table = _stop_amode31_ex_table;
 
@@ -149,6 +149,7 @@ struct mem_detect_info __bootdata(mem_detect);
 struct initrd_data __bootdata(initrd_data);
 
 unsigned long __bootdata_preserved(__kaslr_offset);
+unsigned long __bootdata(__amode31_base);
 unsigned int __bootdata_preserved(zlib_dfltcc_support);
 EXPORT_SYMBOL(zlib_dfltcc_support);
 u64 __bootdata_preserved(stfle_fac_list[16]);
@@ -796,12 +797,12 @@ static void __init check_initrd(void)
  */
 static void __init reserve_kernel(void)
 {
-	unsigned long start_pfn = PFN_UP(__pa(_end));
-
 	memblock_reserve(0, STARTUP_NORMAL_OFFSET);
-	memblock_reserve((unsigned long)sclp_early_sccb, EXT_SCCB_READ_SCP);
-	memblock_reserve((unsigned long)_stext, PFN_PHYS(start_pfn)
-			 - (unsigned long)_stext);
+	memblock_reserve(OLDMEM_BASE, sizeof(unsigned long));
+	memblock_reserve(OLDMEM_SIZE, sizeof(unsigned long));
+	memblock_reserve(__amode31_base, __eamode31 - __samode31);
+	memblock_reserve(__pa(sclp_early_sccb), EXT_SCCB_READ_SCP);
+	memblock_reserve(__pa(_stext), _end - _stext);
 }
 
 static void __init setup_memory(void)
@@ -820,20 +821,14 @@ static void __init setup_memory(void)
 
 static void __init relocate_amode31_section(void)
 {
-	unsigned long amode31_addr, amode31_size;
-	long amode31_offset;
+	unsigned long amode31_size = __eamode31 - __samode31;
+	long amode31_offset = __amode31_base - __samode31;
 	long *ptr;
 
-	/* Allocate a new AMODE31 capable memory region */
-	amode31_size = __eamode31 - __samode31;
 	pr_info("Relocating AMODE31 section of size 0x%08lx\n", amode31_size);
-	amode31_addr = (unsigned long)memblock_alloc_low(amode31_size, PAGE_SIZE);
-	if (!amode31_addr)
-		panic("Failed to allocate memory for AMODE31 section\n");
-	amode31_offset = amode31_addr - __samode31;
 
 	/* Move original AMODE31 section to the new one */
-	memmove((void *)amode31_addr, (void *)__samode31, amode31_size);
+	memmove((void *)__amode31_base, (void *)__samode31, amode31_size);
 	/* Zero out the old AMODE31 section to catch invalid accesses within it */
 	memset((void *)__samode31, 0, amode31_size);
 
diff --git a/arch/s390/kernel/vmlinux.lds.S b/arch/s390/kernel/vmlinux.lds.S
index 63bdb9e1bfc1..42c43521878f 100644
--- a/arch/s390/kernel/vmlinux.lds.S
+++ b/arch/s390/kernel/vmlinux.lds.S
@@ -212,6 +212,7 @@ SECTIONS
 		QUAD(__dynsym_start)				/* dynsym_start */
 		QUAD(__rela_dyn_start)				/* rela_dyn_start */
 		QUAD(__rela_dyn_end)				/* rela_dyn_end */
+		QUAD(_eamode31 - _samode31)			/* amode31_size */
 	} :NONE
 
 	/* Debugging sections.	*/
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 402597f9d050..b456aa196c04 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -3913,14 +3913,12 @@ static int kvm_s390_handle_requests(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-void kvm_s390_set_tod_clock(struct kvm *kvm,
-			    const struct kvm_s390_vm_tod_clock *gtod)
+static void __kvm_s390_set_tod_clock(struct kvm *kvm, const struct kvm_s390_vm_tod_clock *gtod)
 {
 	struct kvm_vcpu *vcpu;
 	union tod_clock clk;
 	int i;
 
-	mutex_lock(&kvm->lock);
 	preempt_disable();
 
 	store_tod_clock_ext(&clk);
@@ -3941,7 +3939,22 @@ void kvm_s390_set_tod_clock(struct kvm *kvm,
 
 	kvm_s390_vcpu_unblock_all(kvm);
 	preempt_enable();
+}
+
+void kvm_s390_set_tod_clock(struct kvm *kvm, const struct kvm_s390_vm_tod_clock *gtod)
+{
+	mutex_lock(&kvm->lock);
+	__kvm_s390_set_tod_clock(kvm, gtod);
+	mutex_unlock(&kvm->lock);
+}
+
+int kvm_s390_try_set_tod_clock(struct kvm *kvm, const struct kvm_s390_vm_tod_clock *gtod)
+{
+	if (!mutex_trylock(&kvm->lock))
+		return 0;
+	__kvm_s390_set_tod_clock(kvm, gtod);
 	mutex_unlock(&kvm->lock);
+	return 1;
 }
 
 /**
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index 1539dd981104..f8803bf0ff17 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -326,8 +326,8 @@ int kvm_s390_handle_sigp(struct kvm_vcpu *vcpu);
 int kvm_s390_handle_sigp_pei(struct kvm_vcpu *vcpu);
 
 /* implemented in kvm-s390.c */
-void kvm_s390_set_tod_clock(struct kvm *kvm,
-			    const struct kvm_s390_vm_tod_clock *gtod);
+void kvm_s390_set_tod_clock(struct kvm *kvm, const struct kvm_s390_vm_tod_clock *gtod);
+int kvm_s390_try_set_tod_clock(struct kvm *kvm, const struct kvm_s390_vm_tod_clock *gtod);
 long kvm_arch_fault_in_page(struct kvm_vcpu *vcpu, gpa_t gpa, int writable);
 int kvm_s390_store_status_unloaded(struct kvm_vcpu *vcpu, unsigned long addr);
 int kvm_s390_vcpu_store_status(struct kvm_vcpu *vcpu, unsigned long addr);
diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
index 417154b314a6..6a765fe22eaf 100644
--- a/arch/s390/kvm/priv.c
+++ b/arch/s390/kvm/priv.c
@@ -102,7 +102,20 @@ static int handle_set_clock(struct kvm_vcpu *vcpu)
 		return kvm_s390_inject_prog_cond(vcpu, rc);
 
 	VCPU_EVENT(vcpu, 3, "SCK: setting guest TOD to 0x%llx", gtod.tod);
-	kvm_s390_set_tod_clock(vcpu->kvm, &gtod);
+	/*
+	 * To set the TOD clock the kvm lock must be taken, but the vcpu lock
+	 * is already held in handle_set_clock. The usual lock order is the
+	 * opposite.  As SCK is deprecated and should not be used in several
+	 * cases, for example when the multiple epoch facility or TOD clock
+	 * steering facility is installed (see Principles of Operation),  a
+	 * slow path can be used.  If the lock can not be taken via try_lock,
+	 * the instruction will be retried via -EAGAIN at a later point in
+	 * time.
+	 */
+	if (!kvm_s390_try_set_tod_clock(vcpu->kvm, &gtod)) {
+		kvm_s390_retry_instr(vcpu);
+		return -EAGAIN;
+	}
 
 	kvm_s390_set_psw_cc(vcpu, 0);
 	return 0;
diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index e23e74e2f928..848cfb013f58 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -1297,10 +1297,12 @@ static void kill_me_maybe(struct callback_head *cb)
 
 	/*
 	 * -EHWPOISON from memory_failure() means that it already sent SIGBUS
-	 * to the current process with the proper error info, so no need to
-	 * send SIGBUS here again.
+	 * to the current process with the proper error info,
+	 * -EOPNOTSUPP means hwpoison_filter() filtered the error event,
+	 *
+	 * In both cases, no further processing is required.
 	 */
-	if (ret == -EHWPOISON)
+	if (ret == -EHWPOISON || ret == -EOPNOTSUPP)
 		return;
 
 	if (p->mce_vaddr != (void __user *)-1l) {
diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index 21427e84a82e..630ae70bb6bd 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -36,8 +36,8 @@ int kvm_page_track_create_memslot(struct kvm_memory_slot *slot,
 
 	for (i = 0; i < KVM_PAGE_TRACK_MAX; i++) {
 		slot->arch.gfn_track[i] =
-			kvcalloc(npages, sizeof(*slot->arch.gfn_track[i]),
-				 GFP_KERNEL_ACCOUNT);
+			__vcalloc(npages, sizeof(*slot->arch.gfn_track[i]),
+				  GFP_KERNEL_ACCOUNT);
 		if (!slot->arch.gfn_track[i])
 			goto track_free;
 	}
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 853780eb033b..6c2bb60ccd88 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1098,13 +1098,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 bool kvm_tdp_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range,
 				 bool flush)
 {
-	struct kvm_mmu_page *root;
-
-	for_each_tdp_mmu_root(kvm, root, range->slot->as_id)
-		flush = zap_gfn_range(kvm, root, range->start, range->end,
-				      range->may_block, flush, false);
-
-	return flush;
+	return __kvm_tdp_mmu_zap_gfn_range(kvm, range->slot->as_id, range->start,
+					   range->end, range->may_block, flush);
 }
 
 typedef bool (*tdp_handler_t)(struct kvm *kvm, struct tdp_iter *iter,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 39aaa21e28f7..8974884ef2ad 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11552,7 +11552,7 @@ static int memslot_rmap_alloc(struct kvm_memory_slot *slot,
 		if (slot->arch.rmap[i])
 			continue;
 
-		slot->arch.rmap[i] = kvcalloc(lpages, sz, GFP_KERNEL_ACCOUNT);
+		slot->arch.rmap[i] = __vcalloc(lpages, sz, GFP_KERNEL_ACCOUNT);
 		if (!slot->arch.rmap[i]) {
 			memslot_rmap_free(slot);
 			return -ENOMEM;
@@ -11633,7 +11633,7 @@ static int kvm_alloc_memslot_metadata(struct kvm *kvm,
 
 		lpages = __kvm_mmu_slot_lpages(slot, npages, level);
 
-		linfo = kvcalloc(lpages, sizeof(*linfo), GFP_KERNEL_ACCOUNT);
+		linfo = __vcalloc(lpages, sizeof(*linfo), GFP_KERNEL_ACCOUNT);
 		if (!linfo)
 			goto out_free;
 
diff --git a/block/bio.c b/block/bio.c
index 8381c6690dd6..b8a8bfba714f 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -910,7 +910,7 @@ EXPORT_SYMBOL(bio_add_pc_page);
 int bio_add_zone_append_page(struct bio *bio, struct page *page,
 			     unsigned int len, unsigned int offset)
 {
-	struct request_queue *q = bio->bi_bdev->bd_disk->queue;
+	struct request_queue *q = bdev_get_queue(bio->bi_bdev);
 	bool same_page = false;
 
 	if (WARN_ON_ONCE(bio_op(bio) != REQ_OP_ZONE_APPEND))
@@ -1054,7 +1054,7 @@ static int bio_iov_bvec_set(struct bio *bio, struct iov_iter *iter)
 
 static int bio_iov_bvec_set_append(struct bio *bio, struct iov_iter *iter)
 {
-	struct request_queue *q = bio->bi_bdev->bd_disk->queue;
+	struct request_queue *q = bdev_get_queue(bio->bi_bdev);
 	struct iov_iter i = *iter;
 
 	iov_iter_truncate(&i, queue_max_zone_append_sectors(q) << 9);
@@ -1132,7 +1132,7 @@ static int __bio_iov_append_get_pages(struct bio *bio, struct iov_iter *iter)
 {
 	unsigned short nr_pages = bio->bi_max_vecs - bio->bi_vcnt;
 	unsigned short entries_left = bio->bi_max_vecs - bio->bi_vcnt;
-	struct request_queue *q = bio->bi_bdev->bd_disk->queue;
+	struct request_queue *q = bdev_get_queue(bio->bi_bdev);
 	unsigned int max_append_sectors = queue_max_zone_append_sectors(q);
 	struct bio_vec *bv = bio->bi_io_vec + bio->bi_vcnt;
 	struct page **pages = (struct page **)bv;
@@ -1470,11 +1470,10 @@ void bio_endio(struct bio *bio)
 	if (!bio_integrity_endio(bio))
 		return;
 
-	if (bio->bi_bdev && bio_flagged(bio, BIO_TRACKED))
-		rq_qos_done_bio(bio->bi_bdev->bd_disk->queue, bio);
+	rq_qos_done_bio(bio);
 
 	if (bio->bi_bdev && bio_flagged(bio, BIO_TRACE_COMPLETION)) {
-		trace_block_bio_complete(bio->bi_bdev->bd_disk->queue, bio);
+		trace_block_bio_complete(bdev_get_queue(bio->bi_bdev), bio);
 		bio_clear_flag(bio, BIO_TRACE_COMPLETION);
 	}
 
diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
index ce3847499d85..d85f30a85ee7 100644
--- a/block/blk-iolatency.c
+++ b/block/blk-iolatency.c
@@ -601,7 +601,7 @@ static void blkcg_iolatency_done_bio(struct rq_qos *rqos, struct bio *bio)
 	int inflight = 0;
 
 	blkg = bio->bi_blkg;
-	if (!blkg || !bio_flagged(bio, BIO_TRACKED))
+	if (!blkg || !bio_flagged(bio, BIO_QOS_THROTTLED))
 		return;
 
 	iolat = blkg_to_lat(bio->bi_blkg);
diff --git a/block/blk-rq-qos.h b/block/blk-rq-qos.h
index f000f83e0621..68267007da1c 100644
--- a/block/blk-rq-qos.h
+++ b/block/blk-rq-qos.h
@@ -177,21 +177,22 @@ static inline void rq_qos_requeue(struct request_queue *q, struct request *rq)
 		__rq_qos_requeue(q->rq_qos, rq);
 }
 
-static inline void rq_qos_done_bio(struct request_queue *q, struct bio *bio)
+static inline void rq_qos_done_bio(struct bio *bio)
 {
-	if (q->rq_qos)
-		__rq_qos_done_bio(q->rq_qos, bio);
+	if (bio->bi_bdev && (bio_flagged(bio, BIO_QOS_THROTTLED) ||
+			     bio_flagged(bio, BIO_QOS_MERGED))) {
+		struct request_queue *q = bdev_get_queue(bio->bi_bdev);
+		if (q->rq_qos)
+			__rq_qos_done_bio(q->rq_qos, bio);
+	}
 }
 
 static inline void rq_qos_throttle(struct request_queue *q, struct bio *bio)
 {
-	/*
-	 * BIO_TRACKED lets controllers know that a bio went through the
-	 * normal rq_qos path.
-	 */
-	bio_set_flag(bio, BIO_TRACKED);
-	if (q->rq_qos)
+	if (q->rq_qos) {
+		bio_set_flag(bio, BIO_QOS_THROTTLED);
 		__rq_qos_throttle(q->rq_qos, bio);
+	}
 }
 
 static inline void rq_qos_track(struct request_queue *q, struct request *rq,
@@ -204,8 +205,10 @@ static inline void rq_qos_track(struct request_queue *q, struct request *rq,
 static inline void rq_qos_merge(struct request_queue *q, struct request *rq,
 				struct bio *bio)
 {
-	if (q->rq_qos)
+	if (q->rq_qos) {
+		bio_set_flag(bio, BIO_QOS_MERGED);
 		__rq_qos_merge(q->rq_qos, rq, bio);
+	}
 }
 
 static inline void rq_qos_queue_depth_changed(struct request_queue *q)
diff --git a/drivers/base/core.c b/drivers/base/core.c
index 8e73a34e1005..10e027e92692 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -485,7 +485,8 @@ static void device_link_release_fn(struct work_struct *work)
 	/* Ensure that all references to the link object have been dropped. */
 	device_link_synchronize_removal();
 
-	pm_runtime_release_supplier(link, true);
+	pm_runtime_release_supplier(link);
+	pm_request_idle(link->supplier);
 
 	put_device(link->consumer);
 	put_device(link->supplier);
diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index c0d501a3a714..c778d1df7455 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -555,6 +555,8 @@ static ssize_t hard_offline_page_store(struct device *dev,
 		return -EINVAL;
 	pfn >>= PAGE_SHIFT;
 	ret = memory_failure(pfn, 0);
+	if (ret == -EOPNOTSUPP)
+		ret = 0;
 	return ret ? ret : count;
 }
 
diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
index 44ae3909e64b..3179c9265471 100644
--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -308,13 +308,10 @@ static int rpm_get_suppliers(struct device *dev)
 /**
  * pm_runtime_release_supplier - Drop references to device link's supplier.
  * @link: Target device link.
- * @check_idle: Whether or not to check if the supplier device is idle.
  *
- * Drop all runtime PM references associated with @link to its supplier device
- * and if @check_idle is set, check if that device is idle (and so it can be
- * suspended).
+ * Drop all runtime PM references associated with @link to its supplier device.
  */
-void pm_runtime_release_supplier(struct device_link *link, bool check_idle)
+void pm_runtime_release_supplier(struct device_link *link)
 {
 	struct device *supplier = link->supplier;
 
@@ -327,9 +324,6 @@ void pm_runtime_release_supplier(struct device_link *link, bool check_idle)
 	while (refcount_dec_not_one(&link->rpm_active) &&
 	       atomic_read(&supplier->power.usage_count) > 0)
 		pm_runtime_put_noidle(supplier);
-
-	if (check_idle)
-		pm_request_idle(supplier);
 }
 
 static void __rpm_put_suppliers(struct device *dev, bool try_to_suspend)
@@ -337,8 +331,11 @@ static void __rpm_put_suppliers(struct device *dev, bool try_to_suspend)
 	struct device_link *link;
 
 	list_for_each_entry_rcu(link, &dev->links.suppliers, c_node,
-				device_links_read_lock_held())
-		pm_runtime_release_supplier(link, try_to_suspend);
+				device_links_read_lock_held()) {
+		pm_runtime_release_supplier(link);
+		if (try_to_suspend)
+			pm_request_idle(link->supplier);
+	}
 }
 
 static void rpm_put_suppliers(struct device *dev)
@@ -1791,7 +1788,8 @@ void pm_runtime_drop_link(struct device_link *link)
 		return;
 
 	pm_runtime_drop_link_count(link->consumer);
-	pm_runtime_release_supplier(link, true);
+	pm_runtime_release_supplier(link);
+	pm_request_idle(link->supplier);
 }
 
 static bool pm_runtime_need_not_resume(struct device *dev)
diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index f93cb989241c..28ed157b1203 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -410,6 +410,7 @@ config XEN_BLKDEV_BACKEND
 config VIRTIO_BLK
 	tristate "Virtio block driver"
 	depends on VIRTIO
+	select SG_POOL
 	help
 	  This is the virtual block driver for virtio.  It can be used with
           QEMU based VMMs (like KVM or Xen).  Say Y or M.
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 8ba2fe356f01..d59af26d7703 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2795,10 +2795,12 @@ enum drbd_ret_code drbd_create_device(struct drbd_config_context *adm_ctx, unsig
 
 	if (init_submitter(device)) {
 		err = ERR_NOMEM;
-		goto out_idr_remove_vol;
+		goto out_idr_remove_from_resource;
 	}
 
-	add_disk(disk);
+	err = add_disk(disk);
+	if (err)
+		goto out_idr_remove_from_resource;
 
 	/* inherit the connection state */
 	device->state.conn = first_connection(resource)->cstate;
@@ -2812,8 +2814,6 @@ enum drbd_ret_code drbd_create_device(struct drbd_config_context *adm_ctx, unsig
 	drbd_debugfs_device_add(device);
 	return NO_ERROR;
 
-out_idr_remove_vol:
-	idr_remove(&connection->peer_devices, vnr);
 out_idr_remove_from_resource:
 	for_each_connection(connection, resource) {
 		peer_device = idr_remove(&connection->peer_devices, vnr);
diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index c05138a28475..d2ba849bb8d1 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -24,6 +24,12 @@
 /* The maximum number of sg elements that fit into a virtqueue */
 #define VIRTIO_BLK_MAX_SG_ELEMS 32768
 
+#ifdef CONFIG_ARCH_NO_SG_CHAIN
+#define VIRTIO_BLK_INLINE_SG_CNT	0
+#else
+#define VIRTIO_BLK_INLINE_SG_CNT	2
+#endif
+
 static int major;
 static DEFINE_IDA(vd_index_ida);
 
@@ -77,6 +83,7 @@ struct virtio_blk {
 struct virtblk_req {
 	struct virtio_blk_outhdr out_hdr;
 	u8 status;
+	struct sg_table sg_table;
 	struct scatterlist sg[];
 };
 
@@ -162,12 +169,92 @@ static int virtblk_setup_discard_write_zeroes(struct request *req, bool unmap)
 	return 0;
 }
 
-static inline void virtblk_request_done(struct request *req)
+static void virtblk_unmap_data(struct request *req, struct virtblk_req *vbr)
 {
-	struct virtblk_req *vbr = blk_mq_rq_to_pdu(req);
+	if (blk_rq_nr_phys_segments(req))
+		sg_free_table_chained(&vbr->sg_table,
+				      VIRTIO_BLK_INLINE_SG_CNT);
+}
+
+static int virtblk_map_data(struct blk_mq_hw_ctx *hctx, struct request *req,
+		struct virtblk_req *vbr)
+{
+	int err;
+
+	if (!blk_rq_nr_phys_segments(req))
+		return 0;
+
+	vbr->sg_table.sgl = vbr->sg;
+	err = sg_alloc_table_chained(&vbr->sg_table,
+				     blk_rq_nr_phys_segments(req),
+				     vbr->sg_table.sgl,
+				     VIRTIO_BLK_INLINE_SG_CNT);
+	if (unlikely(err))
+		return -ENOMEM;
 
+	return blk_rq_map_sg(hctx->queue, req, vbr->sg_table.sgl);
+}
+
+static void virtblk_cleanup_cmd(struct request *req)
+{
 	if (req->rq_flags & RQF_SPECIAL_PAYLOAD)
 		kfree(bvec_virt(&req->special_vec));
+}
+
+static int virtblk_setup_cmd(struct virtio_device *vdev, struct request *req,
+		struct virtblk_req *vbr)
+{
+	bool unmap = false;
+	u32 type;
+
+	vbr->out_hdr.sector = 0;
+
+	switch (req_op(req)) {
+	case REQ_OP_READ:
+		type = VIRTIO_BLK_T_IN;
+		vbr->out_hdr.sector = cpu_to_virtio64(vdev,
+						      blk_rq_pos(req));
+		break;
+	case REQ_OP_WRITE:
+		type = VIRTIO_BLK_T_OUT;
+		vbr->out_hdr.sector = cpu_to_virtio64(vdev,
+						      blk_rq_pos(req));
+		break;
+	case REQ_OP_FLUSH:
+		type = VIRTIO_BLK_T_FLUSH;
+		break;
+	case REQ_OP_DISCARD:
+		type = VIRTIO_BLK_T_DISCARD;
+		break;
+	case REQ_OP_WRITE_ZEROES:
+		type = VIRTIO_BLK_T_WRITE_ZEROES;
+		unmap = !(req->cmd_flags & REQ_NOUNMAP);
+		break;
+	case REQ_OP_DRV_IN:
+		type = VIRTIO_BLK_T_GET_ID;
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		return BLK_STS_IOERR;
+	}
+
+	vbr->out_hdr.type = cpu_to_virtio32(vdev, type);
+	vbr->out_hdr.ioprio = cpu_to_virtio32(vdev, req_get_ioprio(req));
+
+	if (type == VIRTIO_BLK_T_DISCARD || type == VIRTIO_BLK_T_WRITE_ZEROES) {
+		if (virtblk_setup_discard_write_zeroes(req, unmap))
+			return BLK_STS_RESOURCE;
+	}
+
+	return 0;
+}
+
+static inline void virtblk_request_done(struct request *req)
+{
+	struct virtblk_req *vbr = blk_mq_rq_to_pdu(req);
+
+	virtblk_unmap_data(req, vbr);
+	virtblk_cleanup_cmd(req);
 	blk_mq_end_request(req, virtblk_result(vbr));
 }
 
@@ -221,61 +308,27 @@ static blk_status_t virtio_queue_rq(struct blk_mq_hw_ctx *hctx,
 	struct request *req = bd->rq;
 	struct virtblk_req *vbr = blk_mq_rq_to_pdu(req);
 	unsigned long flags;
-	unsigned int num;
+	int num;
 	int qid = hctx->queue_num;
 	int err;
 	bool notify = false;
-	bool unmap = false;
-	u32 type;
 
 	BUG_ON(req->nr_phys_segments + 2 > vblk->sg_elems);
 
-	switch (req_op(req)) {
-	case REQ_OP_READ:
-	case REQ_OP_WRITE:
-		type = 0;
-		break;
-	case REQ_OP_FLUSH:
-		type = VIRTIO_BLK_T_FLUSH;
-		break;
-	case REQ_OP_DISCARD:
-		type = VIRTIO_BLK_T_DISCARD;
-		break;
-	case REQ_OP_WRITE_ZEROES:
-		type = VIRTIO_BLK_T_WRITE_ZEROES;
-		unmap = !(req->cmd_flags & REQ_NOUNMAP);
-		break;
-	case REQ_OP_DRV_IN:
-		type = VIRTIO_BLK_T_GET_ID;
-		break;
-	default:
-		WARN_ON_ONCE(1);
-		return BLK_STS_IOERR;
-	}
-
-	vbr->out_hdr.type = cpu_to_virtio32(vblk->vdev, type);
-	vbr->out_hdr.sector = type ?
-		0 : cpu_to_virtio64(vblk->vdev, blk_rq_pos(req));
-	vbr->out_hdr.ioprio = cpu_to_virtio32(vblk->vdev, req_get_ioprio(req));
+	err = virtblk_setup_cmd(vblk->vdev, req, vbr);
+	if (unlikely(err))
+		return err;
 
 	blk_mq_start_request(req);
 
-	if (type == VIRTIO_BLK_T_DISCARD || type == VIRTIO_BLK_T_WRITE_ZEROES) {
-		err = virtblk_setup_discard_write_zeroes(req, unmap);
-		if (err)
-			return BLK_STS_RESOURCE;
-	}
-
-	num = blk_rq_map_sg(hctx->queue, req, vbr->sg);
-	if (num) {
-		if (rq_data_dir(req) == WRITE)
-			vbr->out_hdr.type |= cpu_to_virtio32(vblk->vdev, VIRTIO_BLK_T_OUT);
-		else
-			vbr->out_hdr.type |= cpu_to_virtio32(vblk->vdev, VIRTIO_BLK_T_IN);
+	num = virtblk_map_data(hctx, req, vbr);
+	if (unlikely(num < 0)) {
+		virtblk_cleanup_cmd(req);
+		return BLK_STS_RESOURCE;
 	}
 
 	spin_lock_irqsave(&vblk->vqs[qid].lock, flags);
-	err = virtblk_add_req(vblk->vqs[qid].vq, vbr, vbr->sg, num);
+	err = virtblk_add_req(vblk->vqs[qid].vq, vbr, vbr->sg_table.sgl, num);
 	if (err) {
 		virtqueue_kick(vblk->vqs[qid].vq);
 		/* Don't stop the queue if -ENOMEM: we may have failed to
@@ -284,6 +337,8 @@ static blk_status_t virtio_queue_rq(struct blk_mq_hw_ctx *hctx,
 		if (err == -ENOSPC)
 			blk_mq_stop_hw_queue(hctx);
 		spin_unlock_irqrestore(&vblk->vqs[qid].lock, flags);
+		virtblk_unmap_data(req, vbr);
+		virtblk_cleanup_cmd(req);
 		switch (err) {
 		case -ENOSPC:
 			return BLK_STS_DEV_RESOURCE;
@@ -660,16 +715,6 @@ static const struct attribute_group *virtblk_attr_groups[] = {
 	NULL,
 };
 
-static int virtblk_init_request(struct blk_mq_tag_set *set, struct request *rq,
-		unsigned int hctx_idx, unsigned int numa_node)
-{
-	struct virtio_blk *vblk = set->driver_data;
-	struct virtblk_req *vbr = blk_mq_rq_to_pdu(rq);
-
-	sg_init_table(vbr->sg, vblk->sg_elems);
-	return 0;
-}
-
 static int virtblk_map_queues(struct blk_mq_tag_set *set)
 {
 	struct virtio_blk *vblk = set->driver_data;
@@ -682,7 +727,6 @@ static const struct blk_mq_ops virtio_mq_ops = {
 	.queue_rq	= virtio_queue_rq,
 	.commit_rqs	= virtio_commit_rqs,
 	.complete	= virtblk_request_done,
-	.init_request	= virtblk_init_request,
 	.map_queues	= virtblk_map_queues,
 };
 
@@ -762,7 +806,7 @@ static int virtblk_probe(struct virtio_device *vdev)
 	vblk->tag_set.flags = BLK_MQ_F_SHOULD_MERGE;
 	vblk->tag_set.cmd_size =
 		sizeof(struct virtblk_req) +
-		sizeof(struct scatterlist) * sg_elems;
+		sizeof(struct scatterlist) * VIRTIO_BLK_INLINE_SG_CNT;
 	vblk->tag_set.driver_data = vblk;
 	vblk->tag_set.nr_hw_queues = vblk->num_vqs;
 
diff --git a/drivers/bluetooth/btmtksdio.c b/drivers/bluetooth/btmtksdio.c
index ff1f5dfbb6db..d66e4df171d2 100644
--- a/drivers/bluetooth/btmtksdio.c
+++ b/drivers/bluetooth/btmtksdio.c
@@ -331,6 +331,7 @@ static int btmtksdio_recv_event(struct hci_dev *hdev, struct sk_buff *skb)
 {
 	struct btmtksdio_dev *bdev = hci_get_drvdata(hdev);
 	struct hci_event_hdr *hdr = (void *)skb->data;
+	u8 evt = hdr->evt;
 	int err;
 
 	/* Fix up the vendor event id with 0xff for vendor specific instead
@@ -355,7 +356,7 @@ static int btmtksdio_recv_event(struct hci_dev *hdev, struct sk_buff *skb)
 	if (err < 0)
 		goto err_free_skb;
 
-	if (hdr->evt == HCI_EV_VENDOR) {
+	if (evt == HCI_EV_VENDOR) {
 		if (test_and_clear_bit(BTMTKSDIO_TX_WAIT_VND_EVT,
 				       &bdev->tx_state)) {
 			/* Barrier to sync with other CPUs */
diff --git a/drivers/bus/mhi/core/init.c b/drivers/bus/mhi/core/init.c
index 4183945fc2c4..d8787aaa176b 100644
--- a/drivers/bus/mhi/core/init.c
+++ b/drivers/bus/mhi/core/init.c
@@ -77,11 +77,14 @@ static const char * const mhi_pm_state_str[] = {
 	[MHI_PM_STATE_LD_ERR_FATAL_DETECT] = "Linkdown or Error Fatal Detect",
 };
 
-const char *to_mhi_pm_state_str(enum mhi_pm_state state)
+const char *to_mhi_pm_state_str(u32 state)
 {
-	int index = find_last_bit((unsigned long *)&state, 32);
+	int index;
 
-	if (index >= ARRAY_SIZE(mhi_pm_state_str))
+	if (state)
+		index = __fls(state);
+
+	if (!state || index >= ARRAY_SIZE(mhi_pm_state_str))
 		return "Invalid State";
 
 	return mhi_pm_state_str[index];
diff --git a/drivers/bus/mhi/core/internal.h b/drivers/bus/mhi/core/internal.h
index c02c4d48b744..71f181402be9 100644
--- a/drivers/bus/mhi/core/internal.h
+++ b/drivers/bus/mhi/core/internal.h
@@ -622,7 +622,7 @@ void mhi_free_bhie_table(struct mhi_controller *mhi_cntrl,
 enum mhi_pm_state __must_check mhi_tryset_pm_state(
 					struct mhi_controller *mhi_cntrl,
 					enum mhi_pm_state state);
-const char *to_mhi_pm_state_str(enum mhi_pm_state state);
+const char *to_mhi_pm_state_str(u32 state);
 int mhi_queue_state_transition(struct mhi_controller *mhi_cntrl,
 			       enum dev_st_transition state);
 void mhi_pm_st_worker(struct work_struct *work);
diff --git a/drivers/clk/renesas/r9a07g044-cpg.c b/drivers/clk/renesas/r9a07g044-cpg.c
index 1490446985e2..61609eddf7d0 100644
--- a/drivers/clk/renesas/r9a07g044-cpg.c
+++ b/drivers/clk/renesas/r9a07g044-cpg.c
@@ -61,8 +61,8 @@ static const struct cpg_core_clk r9a07g044_core_clks[] __initconst = {
 	DEF_FIXED(".osc", R9A07G044_OSCCLK, CLK_EXTAL, 1, 1),
 	DEF_FIXED(".osc_div1000", CLK_OSC_DIV1000, CLK_EXTAL, 1, 1000),
 	DEF_SAMPLL(".pll1", CLK_PLL1, CLK_EXTAL, PLL146_CONF(0)),
-	DEF_FIXED(".pll2", CLK_PLL2, CLK_EXTAL, 133, 2),
-	DEF_FIXED(".pll3", CLK_PLL3, CLK_EXTAL, 133, 2),
+	DEF_FIXED(".pll2", CLK_PLL2, CLK_EXTAL, 200, 3),
+	DEF_FIXED(".pll3", CLK_PLL3, CLK_EXTAL, 200, 3),
 
 	DEF_FIXED(".pll2_div2", CLK_PLL2_DIV2, CLK_PLL2, 1, 2),
 	DEF_FIXED(".pll2_div16", CLK_PLL2_DIV16, CLK_PLL2, 1, 16),
diff --git a/drivers/cxl/core/bus.c b/drivers/cxl/core/bus.c
index 267d8042bec2..0987a6423ee0 100644
--- a/drivers/cxl/core/bus.c
+++ b/drivers/cxl/core/bus.c
@@ -182,6 +182,7 @@ static void cxl_decoder_release(struct device *dev)
 
 	ida_free(&port->decoder_ida, cxld->id);
 	kfree(cxld);
+	put_device(&port->dev);
 }
 
 static const struct device_type cxl_decoder_switch_type = {
@@ -481,6 +482,9 @@ cxl_decoder_alloc(struct cxl_port *port, int nr_targets, resource_size_t base,
 	if (rc < 0)
 		goto err;
 
+	/* need parent to stick around to release the id */
+	get_device(&port->dev);
+
 	*cxld = (struct cxl_decoder) {
 		.id = rc,
 		.range = {
diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index f9217e300eea..968c3df2810e 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -67,12 +67,9 @@ static void dma_buf_release(struct dentry *dentry)
 	BUG_ON(dmabuf->vmapping_counter);
 
 	/*
-	 * Any fences that a dma-buf poll can wait on should be signaled
-	 * before releasing dma-buf. This is the responsibility of each
-	 * driver that uses the reservation objects.
-	 *
-	 * If you hit this BUG() it means someone dropped their ref to the
-	 * dma-buf while still having pending operation to the buffer.
+	 * If you hit this BUG() it could mean:
+	 * * There's a file reference imbalance in dma_buf_poll / dma_buf_poll_cb or somewhere else
+	 * * dmabuf->cb_in/out.active are non-0 despite no pending fence callback
 	 */
 	BUG_ON(dmabuf->cb_in.active || dmabuf->cb_out.active);
 
@@ -200,6 +197,7 @@ static loff_t dma_buf_llseek(struct file *file, loff_t offset, int whence)
 static void dma_buf_poll_cb(struct dma_fence *fence, struct dma_fence_cb *cb)
 {
 	struct dma_buf_poll_cb_t *dcb = (struct dma_buf_poll_cb_t *)cb;
+	struct dma_buf *dmabuf = container_of(dcb->poll, struct dma_buf, poll);
 	unsigned long flags;
 
 	spin_lock_irqsave(&dcb->poll->lock, flags);
@@ -207,6 +205,8 @@ static void dma_buf_poll_cb(struct dma_fence *fence, struct dma_fence_cb *cb)
 	dcb->active = 0;
 	spin_unlock_irqrestore(&dcb->poll->lock, flags);
 	dma_fence_put(fence);
+	/* Paired with get_file in dma_buf_poll */
+	fput(dmabuf->file);
 }
 
 static bool dma_buf_poll_shared(struct dma_resv *resv,
@@ -282,8 +282,12 @@ static __poll_t dma_buf_poll(struct file *file, poll_table *poll)
 		spin_unlock_irq(&dmabuf->poll.lock);
 
 		if (events & EPOLLOUT) {
+			/* Paired with fput in dma_buf_poll_cb */
+			get_file(dmabuf->file);
+
 			if (!dma_buf_poll_shared(resv, dcb) &&
 			    !dma_buf_poll_excl(resv, dcb))
+
 				/* No callback queued, wake up any other waiters */
 				dma_buf_poll_cb(NULL, &dcb->cb);
 			else
@@ -303,6 +307,9 @@ static __poll_t dma_buf_poll(struct file *file, poll_table *poll)
 		spin_unlock_irq(&dmabuf->poll.lock);
 
 		if (events & EPOLLIN) {
+			/* Paired with fput in dma_buf_poll_cb */
+			get_file(dmabuf->file);
+
 			if (!dma_buf_poll_excl(resv, dcb))
 				/* No callback queued, wake up any other waiters */
 				dma_buf_poll_cb(NULL, &dcb->cb);
diff --git a/drivers/dma/at_xdmac.c b/drivers/dma/at_xdmac.c
index 177a537971a1..c5638afe9436 100644
--- a/drivers/dma/at_xdmac.c
+++ b/drivers/dma/at_xdmac.c
@@ -1898,6 +1898,11 @@ static int at_xdmac_alloc_chan_resources(struct dma_chan *chan)
 	for (i = 0; i < init_nr_desc_per_channel; i++) {
 		desc = at_xdmac_alloc_desc(chan, GFP_KERNEL);
 		if (!desc) {
+			if (i == 0) {
+				dev_warn(chan2dev(chan),
+					 "can't allocate any descriptors\n");
+				return -EIO;
+			}
 			dev_warn(chan2dev(chan),
 				"only %d descriptors have been allocated\n", i);
 			break;
diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index e622245c9380..11d3f2aede71 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -720,10 +720,7 @@ static void idxd_device_wqs_clear_state(struct idxd_device *idxd)
 	for (i = 0; i < idxd->max_wqs; i++) {
 		struct idxd_wq *wq = idxd->wqs[i];
 
-		if (wq->state == IDXD_WQ_ENABLED) {
-			idxd_wq_disable_cleanup(wq);
-			wq->state = IDXD_WQ_DISABLED;
-		}
+		idxd_wq_disable_cleanup(wq);
 		idxd_wq_device_reset_cleanup(wq);
 	}
 }
diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index 2300d965a3f4..5215a5e39f3c 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -2264,7 +2264,7 @@ MODULE_DESCRIPTION("i.MX SDMA driver");
 #if IS_ENABLED(CONFIG_SOC_IMX6Q)
 MODULE_FIRMWARE("imx/sdma/sdma-imx6q.bin");
 #endif
-#if IS_ENABLED(CONFIG_SOC_IMX7D)
+#if IS_ENABLED(CONFIG_SOC_IMX7D) || IS_ENABLED(CONFIG_SOC_IMX8M)
 MODULE_FIRMWARE("imx/sdma/sdma-imx7d.bin");
 #endif
 MODULE_LICENSE("GPL");
diff --git a/drivers/dma/lgm/lgm-dma.c b/drivers/dma/lgm/lgm-dma.c
index efe8bd3a0e2a..9b9184f964be 100644
--- a/drivers/dma/lgm/lgm-dma.c
+++ b/drivers/dma/lgm/lgm-dma.c
@@ -1593,11 +1593,12 @@ static int intel_ldma_probe(struct platform_device *pdev)
 	d->core_clk = devm_clk_get_optional(dev, NULL);
 	if (IS_ERR(d->core_clk))
 		return PTR_ERR(d->core_clk);
-	clk_prepare_enable(d->core_clk);
 
 	d->rst = devm_reset_control_get_optional(dev, NULL);
 	if (IS_ERR(d->rst))
 		return PTR_ERR(d->rst);
+
+	clk_prepare_enable(d->core_clk);
 	reset_control_deassert(d->rst);
 
 	ret = devm_add_action_or_reset(dev, ldma_clk_disable, d);
diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index 110de8a60058..4ef68ddff75b 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -2589,7 +2589,7 @@ static struct dma_pl330_desc *pl330_get_desc(struct dma_pl330_chan *pch)
 
 	/* If the DMAC pool is empty, alloc new */
 	if (!desc) {
-		DEFINE_SPINLOCK(lock);
+		static DEFINE_SPINLOCK(lock);
 		LIST_HEAD(pool);
 
 		if (!add_desc(&pool, &lock, GFP_ATOMIC, 1))
diff --git a/drivers/dma/qcom/bam_dma.c b/drivers/dma/qcom/bam_dma.c
index c8a77b428b52..ca8c862c9747 100644
--- a/drivers/dma/qcom/bam_dma.c
+++ b/drivers/dma/qcom/bam_dma.c
@@ -515,14 +515,6 @@ static int bam_alloc_chan(struct dma_chan *chan)
 	return 0;
 }
 
-static int bam_pm_runtime_get_sync(struct device *dev)
-{
-	if (pm_runtime_enabled(dev))
-		return pm_runtime_get_sync(dev);
-
-	return 0;
-}
-
 /**
  * bam_free_chan - Frees dma resources associated with specific channel
  * @chan: specified channel
@@ -538,7 +530,7 @@ static void bam_free_chan(struct dma_chan *chan)
 	unsigned long flags;
 	int ret;
 
-	ret = bam_pm_runtime_get_sync(bdev->dev);
+	ret = pm_runtime_get_sync(bdev->dev);
 	if (ret < 0)
 		return;
 
@@ -734,7 +726,7 @@ static int bam_pause(struct dma_chan *chan)
 	unsigned long flag;
 	int ret;
 
-	ret = bam_pm_runtime_get_sync(bdev->dev);
+	ret = pm_runtime_get_sync(bdev->dev);
 	if (ret < 0)
 		return ret;
 
@@ -760,7 +752,7 @@ static int bam_resume(struct dma_chan *chan)
 	unsigned long flag;
 	int ret;
 
-	ret = bam_pm_runtime_get_sync(bdev->dev);
+	ret = pm_runtime_get_sync(bdev->dev);
 	if (ret < 0)
 		return ret;
 
@@ -869,7 +861,7 @@ static irqreturn_t bam_dma_irq(int irq, void *data)
 	if (srcs & P_IRQ)
 		tasklet_schedule(&bdev->task);
 
-	ret = bam_pm_runtime_get_sync(bdev->dev);
+	ret = pm_runtime_get_sync(bdev->dev);
 	if (ret < 0)
 		return IRQ_NONE;
 
@@ -987,7 +979,7 @@ static void bam_start_dma(struct bam_chan *bchan)
 	if (!vd)
 		return;
 
-	ret = bam_pm_runtime_get_sync(bdev->dev);
+	ret = pm_runtime_get_sync(bdev->dev);
 	if (ret < 0)
 		return;
 
@@ -1350,11 +1342,6 @@ static int bam_dma_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_unregister_dma;
 
-	if (!bdev->bamclk) {
-		pm_runtime_disable(&pdev->dev);
-		return 0;
-	}
-
 	pm_runtime_irq_safe(&pdev->dev);
 	pm_runtime_set_autosuspend_delay(&pdev->dev, BAM_DMA_AUTOSUSPEND_DELAY);
 	pm_runtime_use_autosuspend(&pdev->dev);
@@ -1438,10 +1425,8 @@ static int __maybe_unused bam_dma_suspend(struct device *dev)
 {
 	struct bam_device *bdev = dev_get_drvdata(dev);
 
-	if (bdev->bamclk) {
-		pm_runtime_force_suspend(dev);
-		clk_unprepare(bdev->bamclk);
-	}
+	pm_runtime_force_suspend(dev);
+	clk_unprepare(bdev->bamclk);
 
 	return 0;
 }
@@ -1451,13 +1436,11 @@ static int __maybe_unused bam_dma_resume(struct device *dev)
 	struct bam_device *bdev = dev_get_drvdata(dev);
 	int ret;
 
-	if (bdev->bamclk) {
-		ret = clk_prepare(bdev->bamclk);
-		if (ret)
-			return ret;
+	ret = clk_prepare(bdev->bamclk);
+	if (ret)
+		return ret;
 
-		pm_runtime_force_resume(dev);
-	}
+	pm_runtime_force_resume(dev);
 
 	return 0;
 }
diff --git a/drivers/dma/ti/dma-crossbar.c b/drivers/dma/ti/dma-crossbar.c
index 71d24fc07c00..f744ddbbbad7 100644
--- a/drivers/dma/ti/dma-crossbar.c
+++ b/drivers/dma/ti/dma-crossbar.c
@@ -245,6 +245,7 @@ static void *ti_dra7_xbar_route_allocate(struct of_phandle_args *dma_spec,
 	if (dma_spec->args[0] >= xbar->xbar_requests) {
 		dev_err(&pdev->dev, "Invalid XBAR request number: %d\n",
 			dma_spec->args[0]);
+		put_device(&pdev->dev);
 		return ERR_PTR(-EINVAL);
 	}
 
@@ -252,12 +253,14 @@ static void *ti_dra7_xbar_route_allocate(struct of_phandle_args *dma_spec,
 	dma_spec->np = of_parse_phandle(ofdma->of_node, "dma-masters", 0);
 	if (!dma_spec->np) {
 		dev_err(&pdev->dev, "Can't get DMA master\n");
+		put_device(&pdev->dev);
 		return ERR_PTR(-EINVAL);
 	}
 
 	map = kzalloc(sizeof(*map), GFP_KERNEL);
 	if (!map) {
 		of_node_put(dma_spec->np);
+		put_device(&pdev->dev);
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -268,6 +271,8 @@ static void *ti_dra7_xbar_route_allocate(struct of_phandle_args *dma_spec,
 		mutex_unlock(&xbar->mutex);
 		dev_err(&pdev->dev, "Run out of free DMA requests\n");
 		kfree(map);
+		of_node_put(dma_spec->np);
+		put_device(&pdev->dev);
 		return ERR_PTR(-ENOMEM);
 	}
 	set_bit(map->xbar_out, xbar->dma_inuse);
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu.h b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
index 2eebefd26fa8..5f95d03fd46a 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
@@ -1285,6 +1285,7 @@ int amdgpu_device_gpu_recover(struct amdgpu_device *adev,
 void amdgpu_device_pci_config_reset(struct amdgpu_device *adev);
 int amdgpu_device_pci_reset(struct amdgpu_device *adev);
 bool amdgpu_device_need_post(struct amdgpu_device *adev);
+bool amdgpu_device_should_use_aspm(struct amdgpu_device *adev);
 
 void amdgpu_cs_report_moved_bytes(struct amdgpu_device *adev, u64 num_bytes,
 				  u64 num_vis_bytes);
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index a926b5ebbfdf..d1af709cc7dc 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -1309,6 +1309,31 @@ bool amdgpu_device_need_post(struct amdgpu_device *adev)
 	return true;
 }
 
+/**
+ * amdgpu_device_should_use_aspm - check if the device should program ASPM
+ *
+ * @adev: amdgpu_device pointer
+ *
+ * Confirm whether the module parameter and pcie bridge agree that ASPM should
+ * be set for this device.
+ *
+ * Returns true if it should be used or false if not.
+ */
+bool amdgpu_device_should_use_aspm(struct amdgpu_device *adev)
+{
+	switch (amdgpu_aspm) {
+	case -1:
+		break;
+	case 0:
+		return false;
+	case 1:
+		return true;
+	default:
+		return false;
+	}
+	return pcie_aspm_enabled(adev->pdev);
+}
+
 /* if we get transitioned to only one device, take VGA back */
 /**
  * amdgpu_device_vga_set_decode - enable/disable vga decode
diff --git a/drivers/gpu/drm/amd/amdgpu/cik.c b/drivers/gpu/drm/amd/amdgpu/cik.c
index f10ce740a29c..de6d10390ab2 100644
--- a/drivers/gpu/drm/amd/amdgpu/cik.c
+++ b/drivers/gpu/drm/amd/amdgpu/cik.c
@@ -1719,7 +1719,7 @@ static void cik_program_aspm(struct amdgpu_device *adev)
 	bool disable_l0s = false, disable_l1 = false, disable_plloff_in_l1 = false;
 	bool disable_clkreq = false;
 
-	if (amdgpu_aspm == 0)
+	if (!amdgpu_device_should_use_aspm(adev))
 		return;
 
 	if (pci_is_root_bus(adev->pdev->bus))
diff --git a/drivers/gpu/drm/amd/amdgpu/nv.c b/drivers/gpu/drm/amd/amdgpu/nv.c
index 9cbed9a8f1c0..6e277236b44f 100644
--- a/drivers/gpu/drm/amd/amdgpu/nv.c
+++ b/drivers/gpu/drm/amd/amdgpu/nv.c
@@ -584,7 +584,7 @@ static void nv_pcie_gen3_enable(struct amdgpu_device *adev)
 
 static void nv_program_aspm(struct amdgpu_device *adev)
 {
-	if (!amdgpu_aspm)
+	if (!amdgpu_device_should_use_aspm(adev))
 		return;
 
 	if (!(adev->flags & AMD_IS_APU) &&
diff --git a/drivers/gpu/drm/amd/amdgpu/si.c b/drivers/gpu/drm/amd/amdgpu/si.c
index e6d2f74a7976..7f99e130acd0 100644
--- a/drivers/gpu/drm/amd/amdgpu/si.c
+++ b/drivers/gpu/drm/amd/amdgpu/si.c
@@ -2453,7 +2453,7 @@ static void si_program_aspm(struct amdgpu_device *adev)
 	bool disable_l0s = false, disable_l1 = false, disable_plloff_in_l1 = false;
 	bool disable_clkreq = false;
 
-	if (amdgpu_aspm == 0)
+	if (!amdgpu_device_should_use_aspm(adev))
 		return;
 
 	if (adev->flags & AMD_IS_APU)
diff --git a/drivers/gpu/drm/amd/amdgpu/soc15.c b/drivers/gpu/drm/amd/amdgpu/soc15.c
index 6439d5c3d8d8..bdb47ae96ce6 100644
--- a/drivers/gpu/drm/amd/amdgpu/soc15.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc15.c
@@ -689,7 +689,7 @@ static void soc15_pcie_gen3_enable(struct amdgpu_device *adev)
 
 static void soc15_program_aspm(struct amdgpu_device *adev)
 {
-	if (!amdgpu_aspm)
+	if (!amdgpu_device_should_use_aspm(adev))
 		return;
 
 	if (!(adev->flags & AMD_IS_APU) &&
diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c b/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
index 6e56bef4fdf8..1310617f030f 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
@@ -1511,7 +1511,7 @@ static int vcn_v3_0_stop_dpg_mode(struct amdgpu_device *adev, int inst_idx)
 	struct dpg_pause_state state = {.fw_based = VCN_DPG_STATE__UNPAUSE};
 	uint32_t tmp;
 
-	vcn_v3_0_pause_dpg_mode(adev, 0, &state);
+	vcn_v3_0_pause_dpg_mode(adev, inst_idx, &state);
 
 	/* Wait for power status to be 1 */
 	SOC15_WAIT_ON_RREG(VCN, inst_idx, mmUVD_POWER_STATUS, 1,
diff --git a/drivers/gpu/drm/amd/amdgpu/vi.c b/drivers/gpu/drm/amd/amdgpu/vi.c
index 6645ebbd2696..45f0188c4273 100644
--- a/drivers/gpu/drm/amd/amdgpu/vi.c
+++ b/drivers/gpu/drm/amd/amdgpu/vi.c
@@ -81,6 +81,10 @@
 #include "mxgpu_vi.h"
 #include "amdgpu_dm.h"
 
+#if IS_ENABLED(CONFIG_X86)
+#include <asm/intel-family.h>
+#endif
+
 #define ixPCIE_LC_L1_PM_SUBSTATE	0x100100C6
 #define PCIE_LC_L1_PM_SUBSTATE__LC_L1_SUBSTATES_OVERRIDE_EN_MASK	0x00000001L
 #define PCIE_LC_L1_PM_SUBSTATE__LC_PCI_PM_L1_2_OVERRIDE_MASK	0x00000002L
@@ -1134,13 +1138,24 @@ static void vi_enable_aspm(struct amdgpu_device *adev)
 		WREG32_PCIE(ixPCIE_LC_CNTL, data);
 }
 
+static bool aspm_support_quirk_check(void)
+{
+#if IS_ENABLED(CONFIG_X86)
+	struct cpuinfo_x86 *c = &cpu_data(0);
+
+	return !(c->x86 == 6 && c->x86_model == INTEL_FAM6_ALDERLAKE);
+#else
+	return true;
+#endif
+}
+
 static void vi_program_aspm(struct amdgpu_device *adev)
 {
 	u32 data, data1, orig;
 	bool bL1SS = false;
 	bool bClkReqSupport = true;
 
-	if (!amdgpu_aspm)
+	if (!amdgpu_device_should_use_aspm(adev) || !aspm_support_quirk_check())
 		return;
 
 	if (adev->flags & AMD_IS_APU ||
diff --git a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c
index 0294d0cc4759..735c92a5aa36 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c
@@ -1856,7 +1856,7 @@ static struct pipe_ctx *dcn30_find_split_pipe(
 	return pipe;
 }
 
-static noinline bool dcn30_internal_validate_bw(
+noinline bool dcn30_internal_validate_bw(
 		struct dc *dc,
 		struct dc_state *context,
 		display_e2e_pipe_params_st *pipes,
diff --git a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.h b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.h
index b754b89beadf..b92e4cc0232f 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.h
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.h
@@ -55,6 +55,13 @@ unsigned int dcn30_calc_max_scaled_time(
 
 bool dcn30_validate_bandwidth(struct dc *dc, struct dc_state *context,
 		bool fast_validate);
+bool dcn30_internal_validate_bw(
+		struct dc *dc,
+		struct dc_state *context,
+		display_e2e_pipe_params_st *pipes,
+		int *pipe_cnt_out,
+		int *vlevel_out,
+		bool fast_validate);
 void dcn30_calculate_wm_and_dlg(
 		struct dc *dc, struct dc_state *context,
 		display_e2e_pipe_params_st *pipes,
diff --git a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c
index b60ab3cc0f11..e224c5213258 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c
@@ -1664,6 +1664,15 @@ static void dcn31_calculate_wm_and_dlg_fp(
 	if (context->bw_ctx.dml.soc.min_dcfclk > dcfclk)
 		dcfclk = context->bw_ctx.dml.soc.min_dcfclk;
 
+	/* We don't recalculate clocks for 0 pipe configs, which can block
+	 * S0i3 as high clocks will block low power states
+	 * Override any clocks that can block S0i3 to min here
+	 */
+	if (pipe_cnt == 0) {
+		context->bw_ctx.bw.dcn.clk.dcfclk_khz = dcfclk; // always should be vlevel 0
+		return;
+	}
+
 	pipes[0].clks_cfg.voltage = vlevel;
 	pipes[0].clks_cfg.dcfclk_mhz = dcfclk;
 	pipes[0].clks_cfg.socclk_mhz = context->bw_ctx.dml.soc.clock_limits[vlevel].socclk_mhz;
@@ -1789,6 +1798,60 @@ static void dcn31_calculate_wm_and_dlg(
 	DC_FP_END();
 }
 
+bool dcn31_validate_bandwidth(struct dc *dc,
+		struct dc_state *context,
+		bool fast_validate)
+{
+	bool out = false;
+
+	BW_VAL_TRACE_SETUP();
+
+	int vlevel = 0;
+	int pipe_cnt = 0;
+	display_e2e_pipe_params_st *pipes = kzalloc(dc->res_pool->pipe_count * sizeof(display_e2e_pipe_params_st), GFP_KERNEL);
+	DC_LOGGER_INIT(dc->ctx->logger);
+
+	BW_VAL_TRACE_COUNT();
+
+	DC_FP_START();
+	out = dcn30_internal_validate_bw(dc, context, pipes, &pipe_cnt, &vlevel, fast_validate);
+	DC_FP_END();
+
+	// Disable fast_validate to set min dcfclk in alculate_wm_and_dlg
+	if (pipe_cnt == 0)
+		fast_validate = false;
+
+	if (!out)
+		goto validate_fail;
+
+	BW_VAL_TRACE_END_VOLTAGE_LEVEL();
+
+	if (fast_validate) {
+		BW_VAL_TRACE_SKIP(fast);
+		goto validate_out;
+	}
+
+	dc->res_pool->funcs->calculate_wm_and_dlg(dc, context, pipes, pipe_cnt, vlevel);
+
+	BW_VAL_TRACE_END_WATERMARKS();
+
+	goto validate_out;
+
+validate_fail:
+	DC_LOG_WARNING("Mode Validation Warning: %s failed alidation.\n",
+		dml_get_status_message(context->bw_ctx.dml.vba.ValidationStatus[context->bw_ctx.dml.vba.soc.num_states]));
+
+	BW_VAL_TRACE_SKIP(fail);
+	out = false;
+
+validate_out:
+	kfree(pipes);
+
+	BW_VAL_TRACE_FINISH();
+
+	return out;
+}
+
 static struct dc_cap_funcs cap_funcs = {
 	.get_dcc_compression_cap = dcn20_get_dcc_compression_cap
 };
@@ -1871,7 +1934,7 @@ static struct resource_funcs dcn31_res_pool_funcs = {
 	.link_encs_assign = link_enc_cfg_link_encs_assign,
 	.link_enc_unassign = link_enc_cfg_link_enc_unassign,
 	.panel_cntl_create = dcn31_panel_cntl_create,
-	.validate_bandwidth = dcn30_validate_bandwidth,
+	.validate_bandwidth = dcn31_validate_bandwidth,
 	.calculate_wm_and_dlg = dcn31_calculate_wm_and_dlg,
 	.update_soc_for_wm_a = dcn31_update_soc_for_wm_a,
 	.populate_dml_pipes = dcn31_populate_dml_pipes_from_context,
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
index 574a9d7f7a5e..918d5c7c2328 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
@@ -338,7 +338,7 @@ sienna_cichlid_get_allowed_feature_mask(struct smu_context *smu,
 	if (smu->dc_controlled_by_gpio)
        *(uint64_t *)feature_mask |= FEATURE_MASK(FEATURE_ACDC_BIT);
 
-	if (amdgpu_aspm)
+	if (amdgpu_device_should_use_aspm(adev))
 		*(uint64_t *)feature_mask |= FEATURE_MASK(FEATURE_DS_LCLK_BIT);
 
 	return 0;
diff --git a/drivers/gpu/drm/i915/gem/i915_gem_context.c b/drivers/gpu/drm/i915/gem/i915_gem_context.c
index ee0c0b712522..ba2e037a82e4 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_context.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_context.c
@@ -442,6 +442,13 @@ set_proto_ctx_engines_bond(struct i915_user_extension __user *base, void *data)
 	u16 idx, num_bonds;
 	int err, n;
 
+	if (GRAPHICS_VER(i915) >= 12 && !IS_TIGERLAKE(i915) &&
+	    !IS_ROCKETLAKE(i915) && !IS_ALDERLAKE_S(i915)) {
+		drm_dbg(&i915->drm,
+			"Bonding on gen12+ aside from TGL, RKL, and ADL_S not supported\n");
+		return -ENODEV;
+	}
+
 	if (get_user(idx, &ext->virtual_index))
 		return -EFAULT;
 
diff --git a/drivers/gpu/drm/i915/gem/i915_gem_object.c b/drivers/gpu/drm/i915/gem/i915_gem_object.c
index 6fb9afb65034..5f48d5ea5c15 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_object.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_object.c
@@ -224,6 +224,12 @@ void __i915_gem_free_object(struct drm_i915_gem_object *obj)
 			GEM_BUG_ON(vma->obj != obj);
 			spin_unlock(&obj->vma.lock);
 
+			/* Verify that the vma is unbound under the vm mutex. */
+			mutex_lock(&vma->vm->mutex);
+			atomic_and(~I915_VMA_PIN_MASK, &vma->flags);
+			__i915_vma_unbind(vma);
+			mutex_unlock(&vma->vm->mutex);
+
 			__i915_vma_put(vma);
 
 			spin_lock(&obj->vma.lock);
diff --git a/drivers/gpu/drm/i915/gt/intel_context_types.h b/drivers/gpu/drm/i915/gt/intel_context_types.h
index e54351a170e2..a63631ea0ec4 100644
--- a/drivers/gpu/drm/i915/gt/intel_context_types.h
+++ b/drivers/gpu/drm/i915/gt/intel_context_types.h
@@ -152,6 +152,14 @@ struct intel_context {
 	/** sseu: Control eu/slice partitioning */
 	struct intel_sseu sseu;
 
+	/**
+	 * pinned_contexts_link: List link for the engine's pinned contexts.
+	 * This is only used if this is a perma-pinned kernel context and
+	 * the list is assumed to only be manipulated during driver load
+	 * or unload time so no mutex protection currently.
+	 */
+	struct list_head pinned_contexts_link;
+
 	u8 wa_bb_page; /* if set, page num reserved for context workarounds */
 
 	struct {
diff --git a/drivers/gpu/drm/i915/gt/intel_engine_cs.c b/drivers/gpu/drm/i915/gt/intel_engine_cs.c
index 0d9105a31d84..eb99441e0ada 100644
--- a/drivers/gpu/drm/i915/gt/intel_engine_cs.c
+++ b/drivers/gpu/drm/i915/gt/intel_engine_cs.c
@@ -320,6 +320,7 @@ static int intel_engine_setup(struct intel_gt *gt, enum intel_engine_id id)
 
 	BUILD_BUG_ON(BITS_PER_TYPE(engine->mask) < I915_NUM_ENGINES);
 
+	INIT_LIST_HEAD(&engine->pinned_contexts_list);
 	engine->id = id;
 	engine->legacy_idx = INVALID_ENGINE;
 	engine->mask = BIT(id);
@@ -875,6 +876,8 @@ intel_engine_create_pinned_context(struct intel_engine_cs *engine,
 		return ERR_PTR(err);
 	}
 
+	list_add_tail(&ce->pinned_contexts_link, &engine->pinned_contexts_list);
+
 	/*
 	 * Give our perma-pinned kernel timelines a separate lockdep class,
 	 * so that we can use them from within the normal user timelines
@@ -897,6 +900,7 @@ void intel_engine_destroy_pinned_context(struct intel_context *ce)
 	list_del(&ce->timeline->engine_link);
 	mutex_unlock(&hwsp->vm->mutex);
 
+	list_del(&ce->pinned_contexts_link);
 	intel_context_unpin(ce);
 	intel_context_put(ce);
 }
diff --git a/drivers/gpu/drm/i915/gt/intel_engine_pm.c b/drivers/gpu/drm/i915/gt/intel_engine_pm.c
index 1f07ac4e0672..dacd62773735 100644
--- a/drivers/gpu/drm/i915/gt/intel_engine_pm.c
+++ b/drivers/gpu/drm/i915/gt/intel_engine_pm.c
@@ -298,6 +298,29 @@ void intel_engine_init__pm(struct intel_engine_cs *engine)
 	intel_engine_init_heartbeat(engine);
 }
 
+/**
+ * intel_engine_reset_pinned_contexts - Reset the pinned contexts of
+ * an engine.
+ * @engine: The engine whose pinned contexts we want to reset.
+ *
+ * Typically the pinned context LMEM images lose or get their content
+ * corrupted on suspend. This function resets their images.
+ */
+void intel_engine_reset_pinned_contexts(struct intel_engine_cs *engine)
+{
+	struct intel_context *ce;
+
+	list_for_each_entry(ce, &engine->pinned_contexts_list,
+			    pinned_contexts_link) {
+		/* kernel context gets reset at __engine_unpark() */
+		if (ce == engine->kernel_context)
+			continue;
+
+		dbg_poison_ce(ce);
+		ce->ops->reset(ce);
+	}
+}
+
 #if IS_ENABLED(CONFIG_DRM_I915_SELFTEST)
 #include "selftest_engine_pm.c"
 #endif
diff --git a/drivers/gpu/drm/i915/gt/intel_engine_pm.h b/drivers/gpu/drm/i915/gt/intel_engine_pm.h
index 70ea46d6cfb0..8520c595f5e1 100644
--- a/drivers/gpu/drm/i915/gt/intel_engine_pm.h
+++ b/drivers/gpu/drm/i915/gt/intel_engine_pm.h
@@ -69,4 +69,6 @@ intel_engine_create_kernel_request(struct intel_engine_cs *engine)
 
 void intel_engine_init__pm(struct intel_engine_cs *engine);
 
+void intel_engine_reset_pinned_contexts(struct intel_engine_cs *engine);
+
 #endif /* INTEL_ENGINE_PM_H */
diff --git a/drivers/gpu/drm/i915/gt/intel_engine_types.h b/drivers/gpu/drm/i915/gt/intel_engine_types.h
index ed91bcff20eb..adc44c9fac6d 100644
--- a/drivers/gpu/drm/i915/gt/intel_engine_types.h
+++ b/drivers/gpu/drm/i915/gt/intel_engine_types.h
@@ -304,6 +304,13 @@ struct intel_engine_cs {
 
 	struct intel_context *kernel_context; /* pinned */
 
+	/**
+	 * pinned_contexts_list: List of pinned contexts. This list is only
+	 * assumed to be manipulated during driver load- or unload time and
+	 * does therefore not have any additional protection.
+	 */
+	struct list_head pinned_contexts_list;
+
 	intel_engine_mask_t saturated; /* submitting semaphores too late? */
 
 	struct {
diff --git a/drivers/gpu/drm/i915/gt/intel_execlists_submission.c b/drivers/gpu/drm/i915/gt/intel_execlists_submission.c
index cafb0608ffb4..416f5e0657f0 100644
--- a/drivers/gpu/drm/i915/gt/intel_execlists_submission.c
+++ b/drivers/gpu/drm/i915/gt/intel_execlists_submission.c
@@ -2787,6 +2787,8 @@ static void execlists_sanitize(struct intel_engine_cs *engine)
 
 	/* And scrub the dirty cachelines for the HWSP */
 	clflush_cache_range(engine->status_page.addr, PAGE_SIZE);
+
+	intel_engine_reset_pinned_contexts(engine);
 }
 
 static void enable_error_interrupt(struct intel_engine_cs *engine)
diff --git a/drivers/gpu/drm/i915/gt/intel_ring_submission.c b/drivers/gpu/drm/i915/gt/intel_ring_submission.c
index 2958e2fae380..02e18e70c78e 100644
--- a/drivers/gpu/drm/i915/gt/intel_ring_submission.c
+++ b/drivers/gpu/drm/i915/gt/intel_ring_submission.c
@@ -17,6 +17,7 @@
 #include "intel_ring.h"
 #include "shmem_utils.h"
 #include "intel_engine_heartbeat.h"
+#include "intel_engine_pm.h"
 
 /* Rough estimate of the typical request size, performing a flush,
  * set-context and then emitting the batch.
@@ -291,7 +292,9 @@ static void xcs_sanitize(struct intel_engine_cs *engine)
 	sanitize_hwsp(engine);
 
 	/* And scrub the dirty cachelines for the HWSP */
-	clflush_cache_range(engine->status_page.addr, PAGE_SIZE);
+	drm_clflush_virt_range(engine->status_page.addr, PAGE_SIZE);
+
+	intel_engine_reset_pinned_contexts(engine);
 }
 
 static void reset_prepare(struct intel_engine_cs *engine)
diff --git a/drivers/gpu/drm/i915/gt/mock_engine.c b/drivers/gpu/drm/i915/gt/mock_engine.c
index 2c1af030310c..8b89215afe46 100644
--- a/drivers/gpu/drm/i915/gt/mock_engine.c
+++ b/drivers/gpu/drm/i915/gt/mock_engine.c
@@ -376,6 +376,8 @@ int mock_engine_init(struct intel_engine_cs *engine)
 {
 	struct intel_context *ce;
 
+	INIT_LIST_HEAD(&engine->pinned_contexts_list);
+
 	engine->sched_engine = i915_sched_engine_create(ENGINE_MOCK);
 	if (!engine->sched_engine)
 		return -ENOMEM;
diff --git a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
index 93c9de8f43e8..6e09a1cca37b 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
@@ -2347,6 +2347,8 @@ static void guc_sanitize(struct intel_engine_cs *engine)
 
 	/* And scrub the dirty cachelines for the HWSP */
 	clflush_cache_range(engine->status_page.addr, PAGE_SIZE);
+
+	intel_engine_reset_pinned_contexts(engine);
 }
 
 static void setup_hwsp(struct intel_engine_cs *engine)
@@ -2422,9 +2424,13 @@ static inline void guc_init_lrc_mapping(struct intel_guc *guc)
 	 * and even it did this code would be run again.
 	 */
 
-	for_each_engine(engine, gt, id)
-		if (engine->kernel_context)
-			guc_kernel_context_pin(guc, engine->kernel_context);
+	for_each_engine(engine, gt, id) {
+		struct intel_context *ce;
+
+		list_for_each_entry(ce, &engine->pinned_contexts_list,
+				    pinned_contexts_link)
+			guc_kernel_context_pin(guc, ce);
+	}
 }
 
 static void guc_release(struct intel_engine_cs *engine)
diff --git a/drivers/gpu/drm/mediatek/mtk_disp_drv.h b/drivers/gpu/drm/mediatek/mtk_disp_drv.h
index 86c3068894b1..974462831133 100644
--- a/drivers/gpu/drm/mediatek/mtk_disp_drv.h
+++ b/drivers/gpu/drm/mediatek/mtk_disp_drv.h
@@ -76,9 +76,11 @@ void mtk_ovl_layer_off(struct device *dev, unsigned int idx,
 void mtk_ovl_start(struct device *dev);
 void mtk_ovl_stop(struct device *dev);
 unsigned int mtk_ovl_supported_rotations(struct device *dev);
-void mtk_ovl_enable_vblank(struct device *dev,
-			   void (*vblank_cb)(void *),
-			   void *vblank_cb_data);
+void mtk_ovl_register_vblank_cb(struct device *dev,
+				void (*vblank_cb)(void *),
+				void *vblank_cb_data);
+void mtk_ovl_unregister_vblank_cb(struct device *dev);
+void mtk_ovl_enable_vblank(struct device *dev);
 void mtk_ovl_disable_vblank(struct device *dev);
 
 void mtk_rdma_bypass_shadow(struct device *dev);
@@ -93,9 +95,11 @@ void mtk_rdma_layer_config(struct device *dev, unsigned int idx,
 			   struct cmdq_pkt *cmdq_pkt);
 void mtk_rdma_start(struct device *dev);
 void mtk_rdma_stop(struct device *dev);
-void mtk_rdma_enable_vblank(struct device *dev,
-			    void (*vblank_cb)(void *),
-			    void *vblank_cb_data);
+void mtk_rdma_register_vblank_cb(struct device *dev,
+				 void (*vblank_cb)(void *),
+				 void *vblank_cb_data);
+void mtk_rdma_unregister_vblank_cb(struct device *dev);
+void mtk_rdma_enable_vblank(struct device *dev);
 void mtk_rdma_disable_vblank(struct device *dev);
 
 #endif
diff --git a/drivers/gpu/drm/mediatek/mtk_disp_ovl.c b/drivers/gpu/drm/mediatek/mtk_disp_ovl.c
index 5326989d5206..411cf0f21661 100644
--- a/drivers/gpu/drm/mediatek/mtk_disp_ovl.c
+++ b/drivers/gpu/drm/mediatek/mtk_disp_ovl.c
@@ -96,14 +96,28 @@ static irqreturn_t mtk_disp_ovl_irq_handler(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-void mtk_ovl_enable_vblank(struct device *dev,
-			   void (*vblank_cb)(void *),
-			   void *vblank_cb_data)
+void mtk_ovl_register_vblank_cb(struct device *dev,
+				void (*vblank_cb)(void *),
+				void *vblank_cb_data)
 {
 	struct mtk_disp_ovl *ovl = dev_get_drvdata(dev);
 
 	ovl->vblank_cb = vblank_cb;
 	ovl->vblank_cb_data = vblank_cb_data;
+}
+
+void mtk_ovl_unregister_vblank_cb(struct device *dev)
+{
+	struct mtk_disp_ovl *ovl = dev_get_drvdata(dev);
+
+	ovl->vblank_cb = NULL;
+	ovl->vblank_cb_data = NULL;
+}
+
+void mtk_ovl_enable_vblank(struct device *dev)
+{
+	struct mtk_disp_ovl *ovl = dev_get_drvdata(dev);
+
 	writel(0x0, ovl->regs + DISP_REG_OVL_INTSTA);
 	writel_relaxed(OVL_FME_CPL_INT, ovl->regs + DISP_REG_OVL_INTEN);
 }
@@ -112,8 +126,6 @@ void mtk_ovl_disable_vblank(struct device *dev)
 {
 	struct mtk_disp_ovl *ovl = dev_get_drvdata(dev);
 
-	ovl->vblank_cb = NULL;
-	ovl->vblank_cb_data = NULL;
 	writel_relaxed(0x0, ovl->regs + DISP_REG_OVL_INTEN);
 }
 
diff --git a/drivers/gpu/drm/mediatek/mtk_disp_rdma.c b/drivers/gpu/drm/mediatek/mtk_disp_rdma.c
index 75d7f45579e2..a6a6cb5f75af 100644
--- a/drivers/gpu/drm/mediatek/mtk_disp_rdma.c
+++ b/drivers/gpu/drm/mediatek/mtk_disp_rdma.c
@@ -94,24 +94,32 @@ static void rdma_update_bits(struct device *dev, unsigned int reg,
 	writel(tmp, rdma->regs + reg);
 }
 
-void mtk_rdma_enable_vblank(struct device *dev,
-			    void (*vblank_cb)(void *),
-			    void *vblank_cb_data)
+void mtk_rdma_register_vblank_cb(struct device *dev,
+				 void (*vblank_cb)(void *),
+				 void *vblank_cb_data)
 {
 	struct mtk_disp_rdma *rdma = dev_get_drvdata(dev);
 
 	rdma->vblank_cb = vblank_cb;
 	rdma->vblank_cb_data = vblank_cb_data;
-	rdma_update_bits(dev, DISP_REG_RDMA_INT_ENABLE, RDMA_FRAME_END_INT,
-			 RDMA_FRAME_END_INT);
 }
 
-void mtk_rdma_disable_vblank(struct device *dev)
+void mtk_rdma_unregister_vblank_cb(struct device *dev)
 {
 	struct mtk_disp_rdma *rdma = dev_get_drvdata(dev);
 
 	rdma->vblank_cb = NULL;
 	rdma->vblank_cb_data = NULL;
+}
+
+void mtk_rdma_enable_vblank(struct device *dev)
+{
+	rdma_update_bits(dev, DISP_REG_RDMA_INT_ENABLE, RDMA_FRAME_END_INT,
+			 RDMA_FRAME_END_INT);
+}
+
+void mtk_rdma_disable_vblank(struct device *dev)
+{
 	rdma_update_bits(dev, DISP_REG_RDMA_INT_ENABLE, RDMA_FRAME_END_INT, 0);
 }
 
diff --git a/drivers/gpu/drm/mediatek/mtk_drm_crtc.c b/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
index a4e80e499674..34bb6c713a90 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
@@ -4,6 +4,8 @@
  */
 
 #include <linux/clk.h>
+#include <linux/dma-mapping.h>
+#include <linux/mailbox_controller.h>
 #include <linux/pm_runtime.h>
 #include <linux/soc/mediatek/mtk-cmdq.h>
 #include <linux/soc/mediatek/mtk-mmsys.h>
@@ -50,8 +52,10 @@ struct mtk_drm_crtc {
 	bool				pending_async_planes;
 
 #if IS_REACHABLE(CONFIG_MTK_CMDQ)
-	struct cmdq_client		*cmdq_client;
+	struct cmdq_client		cmdq_client;
+	struct cmdq_pkt			cmdq_handle;
 	u32				cmdq_event;
+	u32				cmdq_vblank_cnt;
 #endif
 
 	struct device			*mmsys_dev;
@@ -104,11 +108,63 @@ static void mtk_drm_finish_page_flip(struct mtk_drm_crtc *mtk_crtc)
 	}
 }
 
+#if IS_REACHABLE(CONFIG_MTK_CMDQ)
+static int mtk_drm_cmdq_pkt_create(struct cmdq_client *client, struct cmdq_pkt *pkt,
+				   size_t size)
+{
+	struct device *dev;
+	dma_addr_t dma_addr;
+
+	pkt->va_base = kzalloc(size, GFP_KERNEL);
+	if (!pkt->va_base) {
+		kfree(pkt);
+		return -ENOMEM;
+	}
+	pkt->buf_size = size;
+	pkt->cl = (void *)client;
+
+	dev = client->chan->mbox->dev;
+	dma_addr = dma_map_single(dev, pkt->va_base, pkt->buf_size,
+				  DMA_TO_DEVICE);
+	if (dma_mapping_error(dev, dma_addr)) {
+		dev_err(dev, "dma map failed, size=%u\n", (u32)(u64)size);
+		kfree(pkt->va_base);
+		kfree(pkt);
+		return -ENOMEM;
+	}
+
+	pkt->pa_base = dma_addr;
+
+	return 0;
+}
+
+static void mtk_drm_cmdq_pkt_destroy(struct cmdq_pkt *pkt)
+{
+	struct cmdq_client *client = (struct cmdq_client *)pkt->cl;
+
+	dma_unmap_single(client->chan->mbox->dev, pkt->pa_base, pkt->buf_size,
+			 DMA_TO_DEVICE);
+	kfree(pkt->va_base);
+	kfree(pkt);
+}
+#endif
+
 static void mtk_drm_crtc_destroy(struct drm_crtc *crtc)
 {
 	struct mtk_drm_crtc *mtk_crtc = to_mtk_crtc(crtc);
+	int i;
 
 	mtk_mutex_put(mtk_crtc->mutex);
+#if IS_REACHABLE(CONFIG_MTK_CMDQ)
+	mtk_drm_cmdq_pkt_destroy(&mtk_crtc->cmdq_handle);
+#endif
+
+	for (i = 0; i < mtk_crtc->ddp_comp_nr; i++) {
+		struct mtk_ddp_comp *comp;
+
+		comp = mtk_crtc->ddp_comp[i];
+		mtk_ddp_comp_unregister_vblank_cb(comp);
+	}
 
 	drm_crtc_cleanup(crtc);
 }
@@ -222,9 +278,12 @@ struct mtk_ddp_comp *mtk_drm_ddp_comp_for_plane(struct drm_crtc *crtc,
 }
 
 #if IS_REACHABLE(CONFIG_MTK_CMDQ)
-static void ddp_cmdq_cb(struct cmdq_cb_data data)
+static void ddp_cmdq_cb(struct mbox_client *cl, void *mssg)
 {
-	cmdq_pkt_destroy(data.data);
+	struct cmdq_client *cmdq_cl = container_of(cl, struct cmdq_client, client);
+	struct mtk_drm_crtc *mtk_crtc = container_of(cmdq_cl, struct mtk_drm_crtc, cmdq_client);
+
+	mtk_crtc->cmdq_vblank_cnt = 0;
 }
 #endif
 
@@ -430,7 +489,7 @@ static void mtk_drm_crtc_update_config(struct mtk_drm_crtc *mtk_crtc,
 				       bool needs_vblank)
 {
 #if IS_REACHABLE(CONFIG_MTK_CMDQ)
-	struct cmdq_pkt *cmdq_handle;
+	struct cmdq_pkt *cmdq_handle = &mtk_crtc->cmdq_handle;
 #endif
 	struct drm_crtc *crtc = &mtk_crtc->base;
 	struct mtk_drm_private *priv = crtc->dev->dev_private;
@@ -468,14 +527,28 @@ static void mtk_drm_crtc_update_config(struct mtk_drm_crtc *mtk_crtc,
 		mtk_mutex_release(mtk_crtc->mutex);
 	}
 #if IS_REACHABLE(CONFIG_MTK_CMDQ)
-	if (mtk_crtc->cmdq_client) {
-		mbox_flush(mtk_crtc->cmdq_client->chan, 2000);
-		cmdq_handle = cmdq_pkt_create(mtk_crtc->cmdq_client, PAGE_SIZE);
+	if (mtk_crtc->cmdq_client.chan) {
+		mbox_flush(mtk_crtc->cmdq_client.chan, 2000);
+		cmdq_handle->cmd_buf_size = 0;
 		cmdq_pkt_clear_event(cmdq_handle, mtk_crtc->cmdq_event);
 		cmdq_pkt_wfe(cmdq_handle, mtk_crtc->cmdq_event, false);
 		mtk_crtc_ddp_config(crtc, cmdq_handle);
 		cmdq_pkt_finalize(cmdq_handle);
-		cmdq_pkt_flush_async(cmdq_handle, ddp_cmdq_cb, cmdq_handle);
+		dma_sync_single_for_device(mtk_crtc->cmdq_client.chan->mbox->dev,
+					   cmdq_handle->pa_base,
+					   cmdq_handle->cmd_buf_size,
+					   DMA_TO_DEVICE);
+		/*
+		 * CMDQ command should execute in next 3 vblank.
+		 * One vblank interrupt before send message (occasionally)
+		 * and one vblank interrupt after cmdq done,
+		 * so it's timeout after 3 vblank interrupt.
+		 * If it fail to execute in next 3 vblank, timeout happen.
+		 */
+		mtk_crtc->cmdq_vblank_cnt = 3;
+
+		mbox_send_message(mtk_crtc->cmdq_client.chan, cmdq_handle);
+		mbox_client_txdone(mtk_crtc->cmdq_client.chan, 0);
 	}
 #endif
 	mtk_crtc->config_updating = false;
@@ -489,12 +562,15 @@ static void mtk_crtc_ddp_irq(void *data)
 	struct mtk_drm_private *priv = crtc->dev->dev_private;
 
 #if IS_REACHABLE(CONFIG_MTK_CMDQ)
-	if (!priv->data->shadow_register && !mtk_crtc->cmdq_client)
+	if (!priv->data->shadow_register && !mtk_crtc->cmdq_client.chan)
+		mtk_crtc_ddp_config(crtc, NULL);
+	else if (mtk_crtc->cmdq_vblank_cnt > 0 && --mtk_crtc->cmdq_vblank_cnt == 0)
+		DRM_ERROR("mtk_crtc %d CMDQ execute command timeout!\n",
+			  drm_crtc_index(&mtk_crtc->base));
 #else
 	if (!priv->data->shadow_register)
-#endif
 		mtk_crtc_ddp_config(crtc, NULL);
-
+#endif
 	mtk_drm_finish_page_flip(mtk_crtc);
 }
 
@@ -503,7 +579,7 @@ static int mtk_drm_crtc_enable_vblank(struct drm_crtc *crtc)
 	struct mtk_drm_crtc *mtk_crtc = to_mtk_crtc(crtc);
 	struct mtk_ddp_comp *comp = mtk_crtc->ddp_comp[0];
 
-	mtk_ddp_comp_enable_vblank(comp, mtk_crtc_ddp_irq, &mtk_crtc->base);
+	mtk_ddp_comp_enable_vblank(comp);
 
 	return 0;
 }
@@ -803,6 +879,9 @@ int mtk_drm_crtc_create(struct drm_device *drm_dev,
 			if (comp->funcs->ctm_set)
 				has_ctm = true;
 		}
+
+		mtk_ddp_comp_register_vblank_cb(comp, mtk_crtc_ddp_irq,
+						&mtk_crtc->base);
 	}
 
 	for (i = 0; i < mtk_crtc->ddp_comp_nr; i++)
@@ -829,16 +908,20 @@ int mtk_drm_crtc_create(struct drm_device *drm_dev,
 	mutex_init(&mtk_crtc->hw_lock);
 
 #if IS_REACHABLE(CONFIG_MTK_CMDQ)
-	mtk_crtc->cmdq_client =
-			cmdq_mbox_create(mtk_crtc->mmsys_dev,
-					 drm_crtc_index(&mtk_crtc->base));
-	if (IS_ERR(mtk_crtc->cmdq_client)) {
+	mtk_crtc->cmdq_client.client.dev = mtk_crtc->mmsys_dev;
+	mtk_crtc->cmdq_client.client.tx_block = false;
+	mtk_crtc->cmdq_client.client.knows_txdone = true;
+	mtk_crtc->cmdq_client.client.rx_callback = ddp_cmdq_cb;
+	mtk_crtc->cmdq_client.chan =
+			mbox_request_channel(&mtk_crtc->cmdq_client.client,
+					     drm_crtc_index(&mtk_crtc->base));
+	if (IS_ERR(mtk_crtc->cmdq_client.chan)) {
 		dev_dbg(dev, "mtk_crtc %d failed to create mailbox client, writing register by CPU now\n",
 			drm_crtc_index(&mtk_crtc->base));
-		mtk_crtc->cmdq_client = NULL;
+		mtk_crtc->cmdq_client.chan = NULL;
 	}
 
-	if (mtk_crtc->cmdq_client) {
+	if (mtk_crtc->cmdq_client.chan) {
 		ret = of_property_read_u32_index(priv->mutex_node,
 						 "mediatek,gce-events",
 						 drm_crtc_index(&mtk_crtc->base),
@@ -846,8 +929,18 @@ int mtk_drm_crtc_create(struct drm_device *drm_dev,
 		if (ret) {
 			dev_dbg(dev, "mtk_crtc %d failed to get mediatek,gce-events property\n",
 				drm_crtc_index(&mtk_crtc->base));
-			cmdq_mbox_destroy(mtk_crtc->cmdq_client);
-			mtk_crtc->cmdq_client = NULL;
+			mbox_free_channel(mtk_crtc->cmdq_client.chan);
+			mtk_crtc->cmdq_client.chan = NULL;
+		} else {
+			ret = mtk_drm_cmdq_pkt_create(&mtk_crtc->cmdq_client,
+						      &mtk_crtc->cmdq_handle,
+						      PAGE_SIZE);
+			if (ret) {
+				dev_dbg(dev, "mtk_crtc %d failed to create cmdq packet\n",
+					drm_crtc_index(&mtk_crtc->base));
+				mbox_free_channel(mtk_crtc->cmdq_client.chan);
+				mtk_crtc->cmdq_client.chan = NULL;
+			}
 		}
 	}
 #endif
diff --git a/drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c b/drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c
index 99cbf44463e4..22d23668b484 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c
@@ -276,6 +276,8 @@ static const struct mtk_ddp_comp_funcs ddp_ovl = {
 	.config = mtk_ovl_config,
 	.start = mtk_ovl_start,
 	.stop = mtk_ovl_stop,
+	.register_vblank_cb = mtk_ovl_register_vblank_cb,
+	.unregister_vblank_cb = mtk_ovl_unregister_vblank_cb,
 	.enable_vblank = mtk_ovl_enable_vblank,
 	.disable_vblank = mtk_ovl_disable_vblank,
 	.supported_rotations = mtk_ovl_supported_rotations,
@@ -292,6 +294,8 @@ static const struct mtk_ddp_comp_funcs ddp_rdma = {
 	.config = mtk_rdma_config,
 	.start = mtk_rdma_start,
 	.stop = mtk_rdma_stop,
+	.register_vblank_cb = mtk_rdma_register_vblank_cb,
+	.unregister_vblank_cb = mtk_rdma_unregister_vblank_cb,
 	.enable_vblank = mtk_rdma_enable_vblank,
 	.disable_vblank = mtk_rdma_disable_vblank,
 	.layer_nr = mtk_rdma_layer_nr,
diff --git a/drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.h b/drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.h
index bb914d976cf5..25cb50f2391f 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.h
+++ b/drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.h
@@ -47,9 +47,11 @@ struct mtk_ddp_comp_funcs {
 		       unsigned int bpc, struct cmdq_pkt *cmdq_pkt);
 	void (*start)(struct device *dev);
 	void (*stop)(struct device *dev);
-	void (*enable_vblank)(struct device *dev,
-			      void (*vblank_cb)(void *),
-			      void *vblank_cb_data);
+	void (*register_vblank_cb)(struct device *dev,
+				   void (*vblank_cb)(void *),
+				   void *vblank_cb_data);
+	void (*unregister_vblank_cb)(struct device *dev);
+	void (*enable_vblank)(struct device *dev);
 	void (*disable_vblank)(struct device *dev);
 	unsigned int (*supported_rotations)(struct device *dev);
 	unsigned int (*layer_nr)(struct device *dev);
@@ -110,12 +112,25 @@ static inline void mtk_ddp_comp_stop(struct mtk_ddp_comp *comp)
 		comp->funcs->stop(comp->dev);
 }
 
-static inline void mtk_ddp_comp_enable_vblank(struct mtk_ddp_comp *comp,
-					      void (*vblank_cb)(void *),
-					      void *vblank_cb_data)
+static inline void mtk_ddp_comp_register_vblank_cb(struct mtk_ddp_comp *comp,
+						   void (*vblank_cb)(void *),
+						   void *vblank_cb_data)
+{
+	if (comp->funcs && comp->funcs->register_vblank_cb)
+		comp->funcs->register_vblank_cb(comp->dev, vblank_cb,
+						vblank_cb_data);
+}
+
+static inline void mtk_ddp_comp_unregister_vblank_cb(struct mtk_ddp_comp *comp)
+{
+	if (comp->funcs && comp->funcs->unregister_vblank_cb)
+		comp->funcs->unregister_vblank_cb(comp->dev);
+}
+
+static inline void mtk_ddp_comp_enable_vblank(struct mtk_ddp_comp *comp)
 {
 	if (comp->funcs && comp->funcs->enable_vblank)
-		comp->funcs->enable_vblank(comp->dev, vblank_cb, vblank_cb_data);
+		comp->funcs->enable_vblank(comp->dev);
 }
 
 static inline void mtk_ddp_comp_disable_vblank(struct mtk_ddp_comp *comp)
diff --git a/drivers/i2c/busses/i2c-cadence.c b/drivers/i2c/busses/i2c-cadence.c
index b4c1ad19cdae..3d6f8ee355bf 100644
--- a/drivers/i2c/busses/i2c-cadence.c
+++ b/drivers/i2c/busses/i2c-cadence.c
@@ -1338,6 +1338,7 @@ static int cdns_i2c_probe(struct platform_device *pdev)
 	return 0;
 
 err_clk_dis:
+	clk_notifier_unregister(id->clk, &id->clk_rate_change_nb);
 	clk_disable_unprepare(id->clk);
 	pm_runtime_disable(&pdev->dev);
 	pm_runtime_set_suspended(&pdev->dev);
diff --git a/drivers/i2c/busses/i2c-piix4.c b/drivers/i2c/busses/i2c-piix4.c
index ac8e7d60672a..39cb1b7bb865 100644
--- a/drivers/i2c/busses/i2c-piix4.c
+++ b/drivers/i2c/busses/i2c-piix4.c
@@ -161,7 +161,6 @@ static const char *piix4_aux_port_name_sb800 = " port 1";
 
 struct sb800_mmio_cfg {
 	void __iomem *addr;
-	struct resource *res;
 	bool use_mmio;
 };
 
@@ -179,13 +178,11 @@ static int piix4_sb800_region_request(struct device *dev,
 				      struct sb800_mmio_cfg *mmio_cfg)
 {
 	if (mmio_cfg->use_mmio) {
-		struct resource *res;
 		void __iomem *addr;
 
-		res = request_mem_region_muxed(SB800_PIIX4_FCH_PM_ADDR,
-					       SB800_PIIX4_FCH_PM_SIZE,
-					       "sb800_piix4_smb");
-		if (!res) {
+		if (!request_mem_region_muxed(SB800_PIIX4_FCH_PM_ADDR,
+					      SB800_PIIX4_FCH_PM_SIZE,
+					      "sb800_piix4_smb")) {
 			dev_err(dev,
 				"SMBus base address memory region 0x%x already in use.\n",
 				SB800_PIIX4_FCH_PM_ADDR);
@@ -195,12 +192,12 @@ static int piix4_sb800_region_request(struct device *dev,
 		addr = ioremap(SB800_PIIX4_FCH_PM_ADDR,
 			       SB800_PIIX4_FCH_PM_SIZE);
 		if (!addr) {
-			release_resource(res);
+			release_mem_region(SB800_PIIX4_FCH_PM_ADDR,
+					   SB800_PIIX4_FCH_PM_SIZE);
 			dev_err(dev, "SMBus base address mapping failed.\n");
 			return -ENOMEM;
 		}
 
-		mmio_cfg->res = res;
 		mmio_cfg->addr = addr;
 
 		return 0;
@@ -222,7 +219,8 @@ static void piix4_sb800_region_release(struct device *dev,
 {
 	if (mmio_cfg->use_mmio) {
 		iounmap(mmio_cfg->addr);
-		release_resource(mmio_cfg->res);
+		release_mem_region(SB800_PIIX4_FCH_PM_ADDR,
+				   SB800_PIIX4_FCH_PM_SIZE);
 		return;
 	}
 
diff --git a/drivers/iio/accel/mma8452.c b/drivers/iio/accel/mma8452.c
index 373b59557afe..1f46a73aafea 100644
--- a/drivers/iio/accel/mma8452.c
+++ b/drivers/iio/accel/mma8452.c
@@ -380,8 +380,8 @@ static ssize_t mma8452_show_scale_avail(struct device *dev,
 					struct device_attribute *attr,
 					char *buf)
 {
-	struct mma8452_data *data = iio_priv(i2c_get_clientdata(
-					     to_i2c_client(dev)));
+	struct iio_dev *indio_dev = dev_to_iio_dev(dev);
+	struct mma8452_data *data = iio_priv(indio_dev);
 
 	return mma8452_show_int_plus_micros(buf, data->chip_info->mma_scales,
 		ARRAY_SIZE(data->chip_info->mma_scales));
diff --git a/drivers/input/misc/cpcap-pwrbutton.c b/drivers/input/misc/cpcap-pwrbutton.c
index 0abef63217e2..372cb44d0635 100644
--- a/drivers/input/misc/cpcap-pwrbutton.c
+++ b/drivers/input/misc/cpcap-pwrbutton.c
@@ -54,9 +54,13 @@ static irqreturn_t powerbutton_irq(int irq, void *_button)
 static int cpcap_power_button_probe(struct platform_device *pdev)
 {
 	struct cpcap_power_button *button;
-	int irq = platform_get_irq(pdev, 0);
+	int irq;
 	int err;
 
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0)
+		return irq;
+
 	button = devm_kmalloc(&pdev->dev, sizeof(*button), GFP_KERNEL);
 	if (!button)
 		return -ENOMEM;
diff --git a/drivers/input/touchscreen/goodix.c b/drivers/input/touchscreen/goodix.c
index 5051a1766aac..3667f7e51fde 100644
--- a/drivers/input/touchscreen/goodix.c
+++ b/drivers/input/touchscreen/goodix.c
@@ -14,20 +14,15 @@
 #include <linux/kernel.h>
 #include <linux/dmi.h>
 #include <linux/firmware.h>
-#include <linux/gpio/consumer.h>
-#include <linux/i2c.h>
-#include <linux/input.h>
-#include <linux/input/mt.h>
-#include <linux/input/touchscreen.h>
 #include <linux/module.h>
 #include <linux/delay.h>
 #include <linux/irq.h>
 #include <linux/interrupt.h>
-#include <linux/regulator/consumer.h>
 #include <linux/slab.h>
 #include <linux/acpi.h>
 #include <linux/of.h>
 #include <asm/unaligned.h>
+#include "goodix.h"
 
 #define GOODIX_GPIO_INT_NAME		"irq"
 #define GOODIX_GPIO_RST_NAME		"reset"
@@ -38,22 +33,11 @@
 #define GOODIX_CONTACT_SIZE		8
 #define GOODIX_MAX_CONTACT_SIZE		9
 #define GOODIX_MAX_CONTACTS		10
-#define GOODIX_MAX_KEYS			7
 
 #define GOODIX_CONFIG_MIN_LENGTH	186
 #define GOODIX_CONFIG_911_LENGTH	186
 #define GOODIX_CONFIG_967_LENGTH	228
 #define GOODIX_CONFIG_GT9X_LENGTH	240
-#define GOODIX_CONFIG_MAX_LENGTH	240
-
-/* Register defines */
-#define GOODIX_REG_COMMAND		0x8040
-#define GOODIX_CMD_SCREEN_OFF		0x05
-
-#define GOODIX_READ_COOR_ADDR		0x814E
-#define GOODIX_GT1X_REG_CONFIG_DATA	0x8050
-#define GOODIX_GT9X_REG_CONFIG_DATA	0x8047
-#define GOODIX_REG_ID			0x8140
 
 #define GOODIX_BUFFER_STATUS_READY	BIT(7)
 #define GOODIX_HAVE_KEY			BIT(4)
@@ -68,55 +52,11 @@
 #define ACPI_GPIO_SUPPORT
 #endif
 
-struct goodix_ts_data;
-
-enum goodix_irq_pin_access_method {
-	IRQ_PIN_ACCESS_NONE,
-	IRQ_PIN_ACCESS_GPIO,
-	IRQ_PIN_ACCESS_ACPI_GPIO,
-	IRQ_PIN_ACCESS_ACPI_METHOD,
-};
-
-struct goodix_chip_data {
-	u16 config_addr;
-	int config_len;
-	int (*check_config)(struct goodix_ts_data *ts, const u8 *cfg, int len);
-	void (*calc_config_checksum)(struct goodix_ts_data *ts);
-};
-
 struct goodix_chip_id {
 	const char *id;
 	const struct goodix_chip_data *data;
 };
 
-#define GOODIX_ID_MAX_LEN	4
-
-struct goodix_ts_data {
-	struct i2c_client *client;
-	struct input_dev *input_dev;
-	const struct goodix_chip_data *chip;
-	struct touchscreen_properties prop;
-	unsigned int max_touch_num;
-	unsigned int int_trigger_type;
-	struct regulator *avdd28;
-	struct regulator *vddio;
-	struct gpio_desc *gpiod_int;
-	struct gpio_desc *gpiod_rst;
-	int gpio_count;
-	int gpio_int_idx;
-	char id[GOODIX_ID_MAX_LEN + 1];
-	u16 version;
-	const char *cfg_name;
-	bool reset_controller_at_probe;
-	bool load_cfg_from_disk;
-	struct completion firmware_loading_complete;
-	unsigned long irq_flags;
-	enum goodix_irq_pin_access_method irq_pin_access_method;
-	unsigned int contact_size;
-	u8 config[GOODIX_CONFIG_MAX_LENGTH];
-	unsigned short keymap[GOODIX_MAX_KEYS];
-};
-
 static int goodix_check_cfg_8(struct goodix_ts_data *ts,
 			      const u8 *cfg, int len);
 static int goodix_check_cfg_16(struct goodix_ts_data *ts,
@@ -216,8 +156,7 @@ static const struct dmi_system_id inverted_x_screen[] = {
  * @buf: raw write data buffer.
  * @len: length of the buffer to write
  */
-static int goodix_i2c_read(struct i2c_client *client,
-			   u16 reg, u8 *buf, int len)
+int goodix_i2c_read(struct i2c_client *client, u16 reg, u8 *buf, int len)
 {
 	struct i2c_msg msgs[2];
 	__be16 wbuf = cpu_to_be16(reg);
@@ -245,8 +184,7 @@ static int goodix_i2c_read(struct i2c_client *client,
  * @buf: raw data buffer to write.
  * @len: length of the buffer to write
  */
-static int goodix_i2c_write(struct i2c_client *client, u16 reg, const u8 *buf,
-			    unsigned len)
+int goodix_i2c_write(struct i2c_client *client, u16 reg, const u8 *buf, int len)
 {
 	u8 *addr_buf;
 	struct i2c_msg msg;
@@ -270,7 +208,7 @@ static int goodix_i2c_write(struct i2c_client *client, u16 reg, const u8 *buf,
 	return ret < 0 ? ret : (ret != 1 ? -EIO : 0);
 }
 
-static int goodix_i2c_write_u8(struct i2c_client *client, u16 reg, u8 value)
+int goodix_i2c_write_u8(struct i2c_client *client, u16 reg, u8 value)
 {
 	return goodix_i2c_write(client, reg, &value, sizeof(value));
 }
@@ -554,7 +492,7 @@ static int goodix_check_cfg(struct goodix_ts_data *ts, const u8 *cfg, int len)
  * @cfg: config firmware to write to device
  * @len: config data length
  */
-static int goodix_send_cfg(struct goodix_ts_data *ts, const u8 *cfg, int len)
+int goodix_send_cfg(struct goodix_ts_data *ts, const u8 *cfg, int len)
 {
 	int error;
 
@@ -652,62 +590,88 @@ static int goodix_irq_direction_input(struct goodix_ts_data *ts)
 	return -EINVAL; /* Never reached */
 }
 
-static int goodix_int_sync(struct goodix_ts_data *ts)
+int goodix_int_sync(struct goodix_ts_data *ts)
 {
 	int error;
 
 	error = goodix_irq_direction_output(ts, 0);
 	if (error)
-		return error;
+		goto error;
 
 	msleep(50);				/* T5: 50ms */
 
 	error = goodix_irq_direction_input(ts);
 	if (error)
-		return error;
+		goto error;
 
 	return 0;
+
+error:
+	dev_err(&ts->client->dev, "Controller irq sync failed.\n");
+	return error;
 }
 
 /**
- * goodix_reset - Reset device during power on
+ * goodix_reset_no_int_sync - Reset device, leaving interrupt line in output mode
  *
  * @ts: goodix_ts_data pointer
  */
-static int goodix_reset(struct goodix_ts_data *ts)
+int goodix_reset_no_int_sync(struct goodix_ts_data *ts)
 {
 	int error;
 
 	/* begin select I2C slave addr */
 	error = gpiod_direction_output(ts->gpiod_rst, 0);
 	if (error)
-		return error;
+		goto error;
 
 	msleep(20);				/* T2: > 10ms */
 
 	/* HIGH: 0x28/0x29, LOW: 0xBA/0xBB */
 	error = goodix_irq_direction_output(ts, ts->client->addr == 0x14);
 	if (error)
-		return error;
+		goto error;
 
 	usleep_range(100, 2000);		/* T3: > 100us */
 
 	error = gpiod_direction_output(ts->gpiod_rst, 1);
 	if (error)
-		return error;
+		goto error;
 
 	usleep_range(6000, 10000);		/* T4: > 5ms */
 
-	/* end select I2C slave addr */
-	error = gpiod_direction_input(ts->gpiod_rst);
-	if (error)
-		return error;
+	/*
+	 * Put the reset pin back in to input / high-impedance mode to save
+	 * power. Only do this in the non ACPI case since some ACPI boards
+	 * don't have a pull-up, so there the reset pin must stay active-high.
+	 */
+	if (ts->irq_pin_access_method == IRQ_PIN_ACCESS_GPIO) {
+		error = gpiod_direction_input(ts->gpiod_rst);
+		if (error)
+			goto error;
+	}
 
-	error = goodix_int_sync(ts);
+	return 0;
+
+error:
+	dev_err(&ts->client->dev, "Controller reset failed.\n");
+	return error;
+}
+
+/**
+ * goodix_reset - Reset device during power on
+ *
+ * @ts: goodix_ts_data pointer
+ */
+static int goodix_reset(struct goodix_ts_data *ts)
+{
+	int error;
+
+	error = goodix_reset_no_int_sync(ts);
 	if (error)
 		return error;
 
-	return 0;
+	return goodix_int_sync(ts);
 }
 
 #ifdef ACPI_GPIO_SUPPORT
@@ -819,6 +783,14 @@ static int goodix_add_acpi_gpio_mappings(struct goodix_ts_data *ts)
 		return -EINVAL;
 	}
 
+	/*
+	 * Normally we put the reset pin in input / high-impedance mode to save
+	 * power. But some x86/ACPI boards don't have a pull-up, so for the ACPI
+	 * case, leave the pin as is. This results in the pin not being touched
+	 * at all on x86/ACPI boards, except when needed for error-recover.
+	 */
+	ts->gpiod_rst_flags = GPIOD_ASIS;
+
 	return devm_acpi_dev_add_driver_gpios(dev, gpio_mapping);
 }
 #else
@@ -844,6 +816,12 @@ static int goodix_get_gpio_config(struct goodix_ts_data *ts)
 		return -EINVAL;
 	dev = &ts->client->dev;
 
+	/*
+	 * By default we request the reset pin as input, leaving it in
+	 * high-impedance when not resetting the controller to save power.
+	 */
+	ts->gpiod_rst_flags = GPIOD_IN;
+
 	ts->avdd28 = devm_regulator_get(dev, "AVDD28");
 	if (IS_ERR(ts->avdd28)) {
 		error = PTR_ERR(ts->avdd28);
@@ -881,7 +859,7 @@ static int goodix_get_gpio_config(struct goodix_ts_data *ts)
 	ts->gpiod_int = gpiod;
 
 	/* Get the reset line GPIO pin number */
-	gpiod = devm_gpiod_get_optional(dev, GOODIX_GPIO_RST_NAME, GPIOD_IN);
+	gpiod = devm_gpiod_get_optional(dev, GOODIX_GPIO_RST_NAME, ts->gpiod_rst_flags);
 	if (IS_ERR(gpiod)) {
 		error = PTR_ERR(gpiod);
 		if (error != -EPROBE_DEFER)
@@ -1206,10 +1184,8 @@ static int goodix_ts_probe(struct i2c_client *client,
 	if (ts->reset_controller_at_probe) {
 		/* reset the controller */
 		error = goodix_reset(ts);
-		if (error) {
-			dev_err(&client->dev, "Controller reset failed.\n");
+		if (error)
 			return error;
-		}
 	}
 
 	error = goodix_i2c_test(client);
@@ -1351,10 +1327,8 @@ static int __maybe_unused goodix_resume(struct device *dev)
 
 	if (error != 0 || config_ver != ts->config[0]) {
 		error = goodix_reset(ts);
-		if (error) {
-			dev_err(dev, "Controller reset failed.\n");
+		if (error)
 			return error;
-		}
 
 		error = goodix_send_cfg(ts, ts->config, ts->chip->config_len);
 		if (error)
diff --git a/drivers/input/touchscreen/goodix.h b/drivers/input/touchscreen/goodix.h
new file mode 100644
index 000000000000..1a1571ad2cd2
--- /dev/null
+++ b/drivers/input/touchscreen/goodix.h
@@ -0,0 +1,75 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef __GOODIX_H__
+#define __GOODIX_H__
+
+#include <linux/gpio/consumer.h>
+#include <linux/i2c.h>
+#include <linux/input.h>
+#include <linux/input/mt.h>
+#include <linux/input/touchscreen.h>
+#include <linux/regulator/consumer.h>
+
+/* Register defines */
+#define GOODIX_REG_COMMAND			0x8040
+#define GOODIX_CMD_SCREEN_OFF			0x05
+
+#define GOODIX_GT1X_REG_CONFIG_DATA		0x8050
+#define GOODIX_GT9X_REG_CONFIG_DATA		0x8047
+#define GOODIX_REG_ID				0x8140
+#define GOODIX_READ_COOR_ADDR			0x814E
+
+#define GOODIX_ID_MAX_LEN			4
+#define GOODIX_CONFIG_MAX_LENGTH		240
+#define GOODIX_MAX_KEYS				7
+
+enum goodix_irq_pin_access_method {
+	IRQ_PIN_ACCESS_NONE,
+	IRQ_PIN_ACCESS_GPIO,
+	IRQ_PIN_ACCESS_ACPI_GPIO,
+	IRQ_PIN_ACCESS_ACPI_METHOD,
+};
+
+struct goodix_ts_data;
+
+struct goodix_chip_data {
+	u16 config_addr;
+	int config_len;
+	int (*check_config)(struct goodix_ts_data *ts, const u8 *cfg, int len);
+	void (*calc_config_checksum)(struct goodix_ts_data *ts);
+};
+
+struct goodix_ts_data {
+	struct i2c_client *client;
+	struct input_dev *input_dev;
+	const struct goodix_chip_data *chip;
+	struct touchscreen_properties prop;
+	unsigned int max_touch_num;
+	unsigned int int_trigger_type;
+	struct regulator *avdd28;
+	struct regulator *vddio;
+	struct gpio_desc *gpiod_int;
+	struct gpio_desc *gpiod_rst;
+	int gpio_count;
+	int gpio_int_idx;
+	enum gpiod_flags gpiod_rst_flags;
+	char id[GOODIX_ID_MAX_LEN + 1];
+	u16 version;
+	const char *cfg_name;
+	bool reset_controller_at_probe;
+	bool load_cfg_from_disk;
+	struct completion firmware_loading_complete;
+	unsigned long irq_flags;
+	enum goodix_irq_pin_access_method irq_pin_access_method;
+	unsigned int contact_size;
+	u8 config[GOODIX_CONFIG_MAX_LENGTH];
+	unsigned short keymap[GOODIX_MAX_KEYS];
+};
+
+int goodix_i2c_read(struct i2c_client *client, u16 reg, u8 *buf, int len);
+int goodix_i2c_write(struct i2c_client *client, u16 reg, const u8 *buf, int len);
+int goodix_i2c_write_u8(struct i2c_client *client, u16 reg, u8 value);
+int goodix_send_cfg(struct goodix_ts_data *ts, const u8 *cfg, int len);
+int goodix_int_sync(struct goodix_ts_data *ts);
+int goodix_reset_no_int_sync(struct goodix_ts_data *ts);
+
+#endif
diff --git a/drivers/iommu/intel/dmar.c b/drivers/iommu/intel/dmar.c
index b7708b93f3fa..3d9cb711e87b 100644
--- a/drivers/iommu/intel/dmar.c
+++ b/drivers/iommu/intel/dmar.c
@@ -385,7 +385,7 @@ static int dmar_pci_bus_notifier(struct notifier_block *nb,
 
 static struct notifier_block dmar_pci_bus_nb = {
 	.notifier_call = dmar_pci_bus_notifier,
-	.priority = INT_MIN,
+	.priority = 1,
 };
 
 static struct dmar_drhd_unit *
diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index fd4fb1b35787..9507989bf2e1 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -556,7 +556,8 @@ static void gic_irq_nmi_teardown(struct irq_data *d)
 
 static void gic_eoi_irq(struct irq_data *d)
 {
-	gic_write_eoir(gic_irq(d));
+	write_gicreg(gic_irq(d), ICC_EOIR1_EL1);
+	isb();
 }
 
 static void gic_eoimode1_eoi_irq(struct irq_data *d)
@@ -640,10 +641,38 @@ static void gic_deactivate_unhandled(u32 irqnr)
 		if (irqnr < 8192)
 			gic_write_dir(irqnr);
 	} else {
-		gic_write_eoir(irqnr);
+		write_gicreg(irqnr, ICC_EOIR1_EL1);
+		isb();
 	}
 }
 
+/*
+ * Follow a read of the IAR with any HW maintenance that needs to happen prior
+ * to invoking the relevant IRQ handler. We must do two things:
+ *
+ * (1) Ensure instruction ordering between a read of IAR and subsequent
+ *     instructions in the IRQ handler using an ISB.
+ *
+ *     It is possible for the IAR to report an IRQ which was signalled *after*
+ *     the CPU took an IRQ exception as multiple interrupts can race to be
+ *     recognized by the GIC, earlier interrupts could be withdrawn, and/or
+ *     later interrupts could be prioritized by the GIC.
+ *
+ *     For devices which are tightly coupled to the CPU, such as PMUs, a
+ *     context synchronization event is necessary to ensure that system
+ *     register state is not stale, as these may have been indirectly written
+ *     *after* exception entry.
+ *
+ * (2) Deactivate the interrupt when EOI mode 1 is in use.
+ */
+static inline void gic_complete_ack(u32 irqnr)
+{
+	if (static_branch_likely(&supports_deactivate_key))
+		write_gicreg(irqnr, ICC_EOIR1_EL1);
+
+	isb();
+}
+
 static inline void gic_handle_nmi(u32 irqnr, struct pt_regs *regs)
 {
 	bool irqs_enabled = interrupts_enabled(regs);
@@ -652,8 +681,8 @@ static inline void gic_handle_nmi(u32 irqnr, struct pt_regs *regs)
 	if (irqs_enabled)
 		nmi_enter();
 
-	if (static_branch_likely(&supports_deactivate_key))
-		gic_write_eoir(irqnr);
+	gic_complete_ack(irqnr);
+
 	/*
 	 * Leave the PSR.I bit set to prevent other NMIs to be
 	 * received while handling this one.
@@ -723,10 +752,7 @@ static asmlinkage void __exception_irq_entry gic_handle_irq(struct pt_regs *regs
 		gic_arch_enable_irqs();
 	}
 
-	if (static_branch_likely(&supports_deactivate_key))
-		gic_write_eoir(irqnr);
-	else
-		isb();
+	gic_complete_ack(irqnr);
 
 	if (handle_domain_irq(gic_data.domain, irqnr, regs)) {
 		WARN_ONCE(true, "Unexpected interrupt received!\n");
diff --git a/drivers/media/platform/davinci/vpif.c b/drivers/media/platform/davinci/vpif.c
index 5658c7f148d7..8ffc01c606d0 100644
--- a/drivers/media/platform/davinci/vpif.c
+++ b/drivers/media/platform/davinci/vpif.c
@@ -41,6 +41,11 @@ MODULE_ALIAS("platform:" VPIF_DRIVER_NAME);
 #define VPIF_CH2_MAX_MODES	15
 #define VPIF_CH3_MAX_MODES	2
 
+struct vpif_data {
+	struct platform_device *capture;
+	struct platform_device *display;
+};
+
 DEFINE_SPINLOCK(vpif_lock);
 EXPORT_SYMBOL_GPL(vpif_lock);
 
@@ -423,11 +428,19 @@ int vpif_channel_getfid(u8 channel_id)
 }
 EXPORT_SYMBOL(vpif_channel_getfid);
 
+static void vpif_pdev_release(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+
+	kfree(pdev);
+}
+
 static int vpif_probe(struct platform_device *pdev)
 {
 	static struct resource	*res, *res_irq;
 	struct platform_device *pdev_capture, *pdev_display;
 	struct device_node *endpoint = NULL;
+	struct vpif_data *data;
 	int ret;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
@@ -435,6 +448,12 @@ static int vpif_probe(struct platform_device *pdev)
 	if (IS_ERR(vpif_base))
 		return PTR_ERR(vpif_base);
 
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, data);
+
 	pm_runtime_enable(&pdev->dev);
 	pm_runtime_get(&pdev->dev);
 
@@ -462,49 +481,75 @@ static int vpif_probe(struct platform_device *pdev)
 		goto err_put_rpm;
 	}
 
-	pdev_capture = devm_kzalloc(&pdev->dev, sizeof(*pdev_capture),
-				    GFP_KERNEL);
-	if (pdev_capture) {
-		pdev_capture->name = "vpif_capture";
-		pdev_capture->id = -1;
-		pdev_capture->resource = res_irq;
-		pdev_capture->num_resources = 1;
-		pdev_capture->dev.dma_mask = pdev->dev.dma_mask;
-		pdev_capture->dev.coherent_dma_mask = pdev->dev.coherent_dma_mask;
-		pdev_capture->dev.parent = &pdev->dev;
-		platform_device_register(pdev_capture);
-	} else {
-		dev_warn(&pdev->dev, "Unable to allocate memory for pdev_capture.\n");
+	pdev_capture = kzalloc(sizeof(*pdev_capture), GFP_KERNEL);
+	if (!pdev_capture) {
+		ret = -ENOMEM;
+		goto err_put_rpm;
 	}
 
-	pdev_display = devm_kzalloc(&pdev->dev, sizeof(*pdev_display),
-				    GFP_KERNEL);
-	if (pdev_display) {
-		pdev_display->name = "vpif_display";
-		pdev_display->id = -1;
-		pdev_display->resource = res_irq;
-		pdev_display->num_resources = 1;
-		pdev_display->dev.dma_mask = pdev->dev.dma_mask;
-		pdev_display->dev.coherent_dma_mask = pdev->dev.coherent_dma_mask;
-		pdev_display->dev.parent = &pdev->dev;
-		platform_device_register(pdev_display);
-	} else {
-		dev_warn(&pdev->dev, "Unable to allocate memory for pdev_display.\n");
+	pdev_capture->name = "vpif_capture";
+	pdev_capture->id = -1;
+	pdev_capture->resource = res_irq;
+	pdev_capture->num_resources = 1;
+	pdev_capture->dev.dma_mask = pdev->dev.dma_mask;
+	pdev_capture->dev.coherent_dma_mask = pdev->dev.coherent_dma_mask;
+	pdev_capture->dev.parent = &pdev->dev;
+	pdev_capture->dev.release = vpif_pdev_release;
+
+	ret = platform_device_register(pdev_capture);
+	if (ret)
+		goto err_put_pdev_capture;
+
+	pdev_display = kzalloc(sizeof(*pdev_display), GFP_KERNEL);
+	if (!pdev_display) {
+		ret = -ENOMEM;
+		goto err_put_pdev_capture;
 	}
 
+	pdev_display->name = "vpif_display";
+	pdev_display->id = -1;
+	pdev_display->resource = res_irq;
+	pdev_display->num_resources = 1;
+	pdev_display->dev.dma_mask = pdev->dev.dma_mask;
+	pdev_display->dev.coherent_dma_mask = pdev->dev.coherent_dma_mask;
+	pdev_display->dev.parent = &pdev->dev;
+	pdev_display->dev.release = vpif_pdev_release;
+
+	ret = platform_device_register(pdev_display);
+	if (ret)
+		goto err_put_pdev_display;
+
+	data->capture = pdev_capture;
+	data->display = pdev_display;
+
 	return 0;
 
+err_put_pdev_display:
+	platform_device_put(pdev_display);
+err_put_pdev_capture:
+	platform_device_put(pdev_capture);
 err_put_rpm:
 	pm_runtime_put(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
+	kfree(data);
 
 	return ret;
 }
 
 static int vpif_remove(struct platform_device *pdev)
 {
+	struct vpif_data *data = platform_get_drvdata(pdev);
+
+	if (data->capture)
+		platform_device_unregister(data->capture);
+	if (data->display)
+		platform_device_unregister(data->display);
+
 	pm_runtime_put(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
+
+	kfree(data);
+
 	return 0;
 }
 
diff --git a/drivers/media/platform/omap3isp/ispstat.c b/drivers/media/platform/omap3isp/ispstat.c
index 5b9b57f4d9bf..68cf68dbcace 100644
--- a/drivers/media/platform/omap3isp/ispstat.c
+++ b/drivers/media/platform/omap3isp/ispstat.c
@@ -512,7 +512,7 @@ int omap3isp_stat_request_statistics(struct ispstat *stat,
 int omap3isp_stat_request_statistics_time32(struct ispstat *stat,
 					struct omap3isp_stat_data_time32 *data)
 {
-	struct omap3isp_stat_data data64;
+	struct omap3isp_stat_data data64 = { };
 	int ret;
 
 	ret = omap3isp_stat_request_statistics(stat, &data64);
@@ -521,7 +521,8 @@ int omap3isp_stat_request_statistics_time32(struct ispstat *stat,
 
 	data->ts.tv_sec = data64.ts.tv_sec;
 	data->ts.tv_usec = data64.ts.tv_usec;
-	memcpy(&data->buf, &data64.buf, sizeof(*data) - sizeof(data->ts));
+	data->buf = (uintptr_t)data64.buf;
+	memcpy(&data->frame, &data64.frame, sizeof(data->frame));
 
 	return 0;
 }
diff --git a/drivers/media/rc/ir_toy.c b/drivers/media/rc/ir_toy.c
index 7f394277478b..53ae19fa103a 100644
--- a/drivers/media/rc/ir_toy.c
+++ b/drivers/media/rc/ir_toy.c
@@ -310,7 +310,7 @@ static int irtoy_tx(struct rc_dev *rc, uint *txbuf, uint count)
 		buf[i] = cpu_to_be16(v);
 	}
 
-	buf[count] = cpu_to_be16(0xffff);
+	buf[count] = 0xffff;
 
 	irtoy->tx_buf = buf;
 	irtoy->tx_len = size;
diff --git a/drivers/memory/renesas-rpc-if.c b/drivers/memory/renesas-rpc-if.c
index 3a416705f61c..c77b23b68a93 100644
--- a/drivers/memory/renesas-rpc-if.c
+++ b/drivers/memory/renesas-rpc-if.c
@@ -199,7 +199,6 @@ static int rpcif_reg_read(void *context, unsigned int reg, unsigned int *val)
 
 	*val = readl(rpc->base + reg);
 	return 0;
-
 }
 
 static int rpcif_reg_write(void *context, unsigned int reg, unsigned int val)
@@ -577,6 +576,48 @@ int rpcif_manual_xfer(struct rpcif *rpc)
 }
 EXPORT_SYMBOL(rpcif_manual_xfer);
 
+static void memcpy_fromio_readw(void *to,
+				const void __iomem *from,
+				size_t count)
+{
+	const int maxw = (IS_ENABLED(CONFIG_64BIT)) ? 8 : 4;
+	u8 buf[2];
+
+	if (count && ((unsigned long)from & 1)) {
+		*(u16 *)buf = __raw_readw((void __iomem *)((unsigned long)from & ~1));
+		*(u8 *)to = buf[1];
+		from++;
+		to++;
+		count--;
+	}
+	while (count >= 2 && !IS_ALIGNED((unsigned long)from, maxw)) {
+		*(u16 *)to = __raw_readw(from);
+		from += 2;
+		to += 2;
+		count -= 2;
+	}
+	while (count >= maxw) {
+#ifdef CONFIG_64BIT
+		*(u64 *)to = __raw_readq(from);
+#else
+		*(u32 *)to = __raw_readl(from);
+#endif
+		from += maxw;
+		to += maxw;
+		count -= maxw;
+	}
+	while (count >= 2) {
+		*(u16 *)to = __raw_readw(from);
+		from += 2;
+		to += 2;
+		count -= 2;
+	}
+	if (count) {
+		*(u16 *)buf = __raw_readw(from);
+		*(u8 *)to = buf[0];
+	}
+}
+
 ssize_t rpcif_dirmap_read(struct rpcif *rpc, u64 offs, size_t len, void *buf)
 {
 	loff_t from = offs & (RPCIF_DIRMAP_SIZE - 1);
@@ -598,7 +639,10 @@ ssize_t rpcif_dirmap_read(struct rpcif *rpc, u64 offs, size_t len, void *buf)
 	regmap_write(rpc->regmap, RPCIF_DRDMCR, rpc->dummy);
 	regmap_write(rpc->regmap, RPCIF_DRDRENR, rpc->ddr);
 
-	memcpy_fromio(buf, rpc->dirmap + from, len);
+	if (rpc->bus_size == 2)
+		memcpy_fromio_readw(buf, rpc->dirmap + from, len);
+	else
+		memcpy_fromio(buf, rpc->dirmap + from, len);
 
 	pm_runtime_put(rpc->dev);
 
diff --git a/drivers/misc/cardreader/rtsx_usb.c b/drivers/misc/cardreader/rtsx_usb.c
index 1ef9b61077c4..f150d8769f19 100644
--- a/drivers/misc/cardreader/rtsx_usb.c
+++ b/drivers/misc/cardreader/rtsx_usb.c
@@ -631,16 +631,20 @@ static int rtsx_usb_probe(struct usb_interface *intf,
 
 	ucr->pusb_dev = usb_dev;
 
-	ucr->iobuf = usb_alloc_coherent(ucr->pusb_dev, IOBUF_SIZE,
-			GFP_KERNEL, &ucr->iobuf_dma);
-	if (!ucr->iobuf)
+	ucr->cmd_buf = kmalloc(IOBUF_SIZE, GFP_KERNEL);
+	if (!ucr->cmd_buf)
 		return -ENOMEM;
 
+	ucr->rsp_buf = kmalloc(IOBUF_SIZE, GFP_KERNEL);
+	if (!ucr->rsp_buf) {
+		ret = -ENOMEM;
+		goto out_free_cmd_buf;
+	}
+
 	usb_set_intfdata(intf, ucr);
 
 	ucr->vendor_id = id->idVendor;
 	ucr->product_id = id->idProduct;
-	ucr->cmd_buf = ucr->rsp_buf = ucr->iobuf;
 
 	mutex_init(&ucr->dev_mutex);
 
@@ -668,8 +672,11 @@ static int rtsx_usb_probe(struct usb_interface *intf,
 
 out_init_fail:
 	usb_set_intfdata(ucr->pusb_intf, NULL);
-	usb_free_coherent(ucr->pusb_dev, IOBUF_SIZE, ucr->iobuf,
-			ucr->iobuf_dma);
+	kfree(ucr->rsp_buf);
+	ucr->rsp_buf = NULL;
+out_free_cmd_buf:
+	kfree(ucr->cmd_buf);
+	ucr->cmd_buf = NULL;
 	return ret;
 }
 
@@ -682,8 +689,12 @@ static void rtsx_usb_disconnect(struct usb_interface *intf)
 	mfd_remove_devices(&intf->dev);
 
 	usb_set_intfdata(ucr->pusb_intf, NULL);
-	usb_free_coherent(ucr->pusb_dev, IOBUF_SIZE, ucr->iobuf,
-			ucr->iobuf_dma);
+
+	kfree(ucr->cmd_buf);
+	ucr->cmd_buf = NULL;
+
+	kfree(ucr->rsp_buf);
+	ucr->rsp_buf = NULL;
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/mtd/spi-nor/core.c b/drivers/mtd/spi-nor/core.c
index 90f39aabc1ff..d97cdbc2b9de 100644
--- a/drivers/mtd/spi-nor/core.c
+++ b/drivers/mtd/spi-nor/core.c
@@ -3148,7 +3148,6 @@ int spi_nor_scan(struct spi_nor *nor, const char *name,
 	mtd->writesize = nor->params->writesize;
 	mtd->flags = MTD_CAP_NORFLASH;
 	mtd->size = nor->params->size;
-	mtd->_erase = spi_nor_erase;
 	mtd->_read = spi_nor_read;
 	mtd->_suspend = spi_nor_suspend;
 	mtd->_resume = spi_nor_resume;
@@ -3178,6 +3177,8 @@ int spi_nor_scan(struct spi_nor *nor, const char *name,
 
 	if (info->flags & SPI_NOR_NO_ERASE)
 		mtd->flags |= MTD_NO_ERASE;
+	else
+		mtd->_erase = spi_nor_erase;
 
 	mtd->dev.parent = dev;
 	nor->page_size = nor->params->page_size;
diff --git a/drivers/net/can/grcan.c b/drivers/net/can/grcan.c
index daee3652ac8b..e098f594a749 100644
--- a/drivers/net/can/grcan.c
+++ b/drivers/net/can/grcan.c
@@ -1659,7 +1659,6 @@ static int grcan_probe(struct platform_device *ofdev)
 	 */
 	sysid_parent = of_find_node_by_path("/ambapp0");
 	if (sysid_parent) {
-		of_node_get(sysid_parent);
 		err = of_property_read_u32(sysid_parent, "systemid", &sysid);
 		if (!err && ((sysid & GRLIB_VERSION_MASK) >=
 			     GRCAN_TXBUG_SAFE_GRLIB_VERSION))
diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index bff33a619acd..c4596fbe6d2f 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -532,7 +532,7 @@ static int m_can_read_fifo(struct net_device *dev, u32 rxfs)
 	stats->rx_packets++;
 	stats->rx_bytes += cf->len;
 
-	timestamp = FIELD_GET(RX_BUF_RXTS_MASK, fifo_header.dlc);
+	timestamp = FIELD_GET(RX_BUF_RXTS_MASK, fifo_header.dlc) << 16;
 
 	m_can_receive_skb(cdev, skb, timestamp);
 
@@ -1043,7 +1043,7 @@ static int m_can_echo_tx_event(struct net_device *dev)
 		}
 
 		msg_mark = FIELD_GET(TX_EVENT_MM_MASK, txe);
-		timestamp = FIELD_GET(TX_EVENT_TXTS_MASK, txe);
+		timestamp = FIELD_GET(TX_EVENT_TXTS_MASK, txe) << 16;
 
 		/* ack txe element */
 		m_can_write(cdev, M_CAN_TXEFA, FIELD_PREP(TXEFA_EFAI_MASK,
@@ -1367,7 +1367,9 @@ static void m_can_chip_config(struct net_device *dev)
 	/* enable internal timestamp generation, with a prescalar of 16. The
 	 * prescalar is applied to the nominal bit timing
 	 */
-	m_can_write(cdev, M_CAN_TSCC, FIELD_PREP(TSCC_TCP_MASK, 0xf));
+	m_can_write(cdev, M_CAN_TSCC,
+		    FIELD_PREP(TSCC_TCP_MASK, 0xf) |
+		    FIELD_PREP(TSCC_TSS_MASK, TSCC_TSS_INTERNAL));
 
 	m_can_config_endisable(cdev, false);
 
diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-regmap.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-regmap.c
index 297491516a26..bb559663a3fa 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-regmap.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-regmap.c
@@ -325,19 +325,21 @@ mcp251xfd_regmap_crc_read(void *context,
 		 * register. It increments once per SYS clock tick,
 		 * which is 20 or 40 MHz.
 		 *
-		 * Observation shows that if the lowest byte (which is
-		 * transferred first on the SPI bus) of that register
-		 * is 0x00 or 0x80 the calculated CRC doesn't always
-		 * match the transferred one.
+		 * Observation on the mcp2518fd shows that if the
+		 * lowest byte (which is transferred first on the SPI
+		 * bus) of that register is 0x00 or 0x80 the
+		 * calculated CRC doesn't always match the transferred
+		 * one. On the mcp2517fd this problem is not limited
+		 * to the first byte being 0x00 or 0x80.
 		 *
 		 * If the highest bit in the lowest byte is flipped
 		 * the transferred CRC matches the calculated one. We
-		 * assume for now the CRC calculation in the chip
-		 * works on wrong data and the transferred data is
-		 * correct.
+		 * assume for now the CRC operates on the correct
+		 * data.
 		 */
 		if (reg == MCP251XFD_REG_TBC &&
-		    (buf_rx->data[0] == 0x0 || buf_rx->data[0] == 0x80)) {
+		    ((buf_rx->data[0] & 0xf8) == 0x0 ||
+		     (buf_rx->data[0] & 0xf8) == 0x80)) {
 			/* Flip highest bit in lowest byte of le32 */
 			buf_rx->data[0] ^= 0x80;
 
@@ -347,10 +349,8 @@ mcp251xfd_regmap_crc_read(void *context,
 								  val_len);
 			if (!err) {
 				/* If CRC is now correct, assume
-				 * transferred data was OK, flip bit
-				 * back to original value.
+				 * flipped data is OK.
 				 */
-				buf_rx->data[0] ^= 0x80;
 				goto out;
 			}
 		}
diff --git a/drivers/net/can/usb/gs_usb.c b/drivers/net/can/usb/gs_usb.c
index d68d698f2606..e26b3d6f5b48 100644
--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -185,6 +185,8 @@ struct gs_can {
 
 	struct usb_anchor tx_submitted;
 	atomic_t active_tx_urbs;
+	void *rxbuf[GS_MAX_RX_URBS];
+	dma_addr_t rxbuf_dma[GS_MAX_RX_URBS];
 };
 
 /* usb interface struct */
@@ -594,6 +596,7 @@ static int gs_can_open(struct net_device *netdev)
 		for (i = 0; i < GS_MAX_RX_URBS; i++) {
 			struct urb *urb;
 			u8 *buf;
+			dma_addr_t buf_dma;
 
 			/* alloc rx urb */
 			urb = usb_alloc_urb(0, GFP_KERNEL);
@@ -604,7 +607,7 @@ static int gs_can_open(struct net_device *netdev)
 			buf = usb_alloc_coherent(dev->udev,
 						 sizeof(struct gs_host_frame),
 						 GFP_KERNEL,
-						 &urb->transfer_dma);
+						 &buf_dma);
 			if (!buf) {
 				netdev_err(netdev,
 					   "No memory left for USB buffer\n");
@@ -612,6 +615,8 @@ static int gs_can_open(struct net_device *netdev)
 				return -ENOMEM;
 			}
 
+			urb->transfer_dma = buf_dma;
+
 			/* fill, anchor, and submit rx urb */
 			usb_fill_bulk_urb(urb,
 					  dev->udev,
@@ -635,10 +640,17 @@ static int gs_can_open(struct net_device *netdev)
 					   rc);
 
 				usb_unanchor_urb(urb);
+				usb_free_coherent(dev->udev,
+						  sizeof(struct gs_host_frame),
+						  buf,
+						  buf_dma);
 				usb_free_urb(urb);
 				break;
 			}
 
+			dev->rxbuf[i] = buf;
+			dev->rxbuf_dma[i] = buf_dma;
+
 			/* Drop reference,
 			 * USB core will take care of freeing it
 			 */
@@ -703,13 +715,20 @@ static int gs_can_close(struct net_device *netdev)
 	int rc;
 	struct gs_can *dev = netdev_priv(netdev);
 	struct gs_usb *parent = dev->parent;
+	unsigned int i;
 
 	netif_stop_queue(netdev);
 
 	/* Stop polling */
 	parent->active_channels--;
-	if (!parent->active_channels)
+	if (!parent->active_channels) {
 		usb_kill_anchored_urbs(&parent->rx_submitted);
+		for (i = 0; i < GS_MAX_RX_URBS; i++)
+			usb_free_coherent(dev->udev,
+					  sizeof(struct gs_host_frame),
+					  dev->rxbuf[i],
+					  dev->rxbuf_dma[i]);
+	}
 
 	/* Stop sending URBs */
 	usb_kill_anchored_urbs(&dev->tx_submitted);
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb.h b/drivers/net/can/usb/kvaser_usb/kvaser_usb.h
index 390b6bde883c..61e67986b625 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb.h
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb.h
@@ -35,9 +35,10 @@
 #define KVASER_USB_RX_BUFFER_SIZE		3072
 #define KVASER_USB_MAX_NET_DEVICES		5
 
-/* USB devices features */
-#define KVASER_USB_HAS_SILENT_MODE		BIT(0)
-#define KVASER_USB_HAS_TXRX_ERRORS		BIT(1)
+/* Kvaser USB device quirks */
+#define KVASER_USB_QUIRK_HAS_SILENT_MODE	BIT(0)
+#define KVASER_USB_QUIRK_HAS_TXRX_ERRORS	BIT(1)
+#define KVASER_USB_QUIRK_IGNORE_CLK_FREQ	BIT(2)
 
 /* Device capabilities */
 #define KVASER_USB_CAP_BERR_CAP			0x01
@@ -65,12 +66,7 @@ struct kvaser_usb_dev_card_data_hydra {
 struct kvaser_usb_dev_card_data {
 	u32 ctrlmode_supported;
 	u32 capabilities;
-	union {
-		struct {
-			enum kvaser_usb_leaf_family family;
-		} leaf;
-		struct kvaser_usb_dev_card_data_hydra hydra;
-	};
+	struct kvaser_usb_dev_card_data_hydra hydra;
 };
 
 /* Context for an outstanding, not yet ACKed, transmission */
@@ -84,7 +80,7 @@ struct kvaser_usb {
 	struct usb_device *udev;
 	struct usb_interface *intf;
 	struct kvaser_usb_net_priv *nets[KVASER_USB_MAX_NET_DEVICES];
-	const struct kvaser_usb_dev_ops *ops;
+	const struct kvaser_usb_driver_info *driver_info;
 	const struct kvaser_usb_dev_cfg *cfg;
 
 	struct usb_endpoint_descriptor *bulk_in, *bulk_out;
@@ -166,6 +162,12 @@ struct kvaser_usb_dev_ops {
 				  int *cmd_len, u16 transid);
 };
 
+struct kvaser_usb_driver_info {
+	u32 quirks;
+	enum kvaser_usb_leaf_family family;
+	const struct kvaser_usb_dev_ops *ops;
+};
+
 struct kvaser_usb_dev_cfg {
 	const struct can_clock clock;
 	const unsigned int timestamp_freq;
@@ -185,4 +187,7 @@ int kvaser_usb_send_cmd_async(struct kvaser_usb_net_priv *priv, void *cmd,
 			      int len);
 
 int kvaser_usb_can_rx_over_error(struct net_device *netdev);
+
+extern const struct can_bittiming_const kvaser_usb_flexc_bittiming_const;
+
 #endif /* KVASER_USB_H */
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
index 0cc0fc866a2a..e570f5a76bbf 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
@@ -61,8 +61,6 @@
 #define USB_USBCAN_R_V2_PRODUCT_ID		294
 #define USB_LEAF_LIGHT_R_V2_PRODUCT_ID		295
 #define USB_LEAF_LIGHT_HS_V2_OEM2_PRODUCT_ID	296
-#define USB_LEAF_PRODUCT_ID_END \
-	USB_LEAF_LIGHT_HS_V2_OEM2_PRODUCT_ID
 
 /* Kvaser USBCan-II devices product ids */
 #define USB_USBCAN_REVB_PRODUCT_ID		2
@@ -89,116 +87,153 @@
 #define USB_USBCAN_PRO_4HS_PRODUCT_ID		276
 #define USB_HYBRID_CANLIN_PRODUCT_ID		277
 #define USB_HYBRID_PRO_CANLIN_PRODUCT_ID	278
-#define USB_HYDRA_PRODUCT_ID_END \
-	USB_HYBRID_PRO_CANLIN_PRODUCT_ID
 
-static inline bool kvaser_is_leaf(const struct usb_device_id *id)
-{
-	return (id->idProduct >= USB_LEAF_DEVEL_PRODUCT_ID &&
-		id->idProduct <= USB_CAN_R_PRODUCT_ID) ||
-		(id->idProduct >= USB_LEAF_LITE_V2_PRODUCT_ID &&
-		 id->idProduct <= USB_LEAF_PRODUCT_ID_END);
-}
+static const struct kvaser_usb_driver_info kvaser_usb_driver_info_hydra = {
+	.quirks = 0,
+	.ops = &kvaser_usb_hydra_dev_ops,
+};
 
-static inline bool kvaser_is_usbcan(const struct usb_device_id *id)
-{
-	return id->idProduct >= USB_USBCAN_REVB_PRODUCT_ID &&
-	       id->idProduct <= USB_MEMORATOR_PRODUCT_ID;
-}
+static const struct kvaser_usb_driver_info kvaser_usb_driver_info_usbcan = {
+	.quirks = KVASER_USB_QUIRK_HAS_TXRX_ERRORS |
+		  KVASER_USB_QUIRK_HAS_SILENT_MODE,
+	.family = KVASER_USBCAN,
+	.ops = &kvaser_usb_leaf_dev_ops,
+};
 
-static inline bool kvaser_is_hydra(const struct usb_device_id *id)
-{
-	return id->idProduct >= USB_BLACKBIRD_V2_PRODUCT_ID &&
-	       id->idProduct <= USB_HYDRA_PRODUCT_ID_END;
-}
+static const struct kvaser_usb_driver_info kvaser_usb_driver_info_leaf = {
+	.quirks = KVASER_USB_QUIRK_IGNORE_CLK_FREQ,
+	.family = KVASER_LEAF,
+	.ops = &kvaser_usb_leaf_dev_ops,
+};
+
+static const struct kvaser_usb_driver_info kvaser_usb_driver_info_leaf_err = {
+	.quirks = KVASER_USB_QUIRK_HAS_TXRX_ERRORS |
+		  KVASER_USB_QUIRK_IGNORE_CLK_FREQ,
+	.family = KVASER_LEAF,
+	.ops = &kvaser_usb_leaf_dev_ops,
+};
+
+static const struct kvaser_usb_driver_info kvaser_usb_driver_info_leaf_err_listen = {
+	.quirks = KVASER_USB_QUIRK_HAS_TXRX_ERRORS |
+		  KVASER_USB_QUIRK_HAS_SILENT_MODE |
+		  KVASER_USB_QUIRK_IGNORE_CLK_FREQ,
+	.family = KVASER_LEAF,
+	.ops = &kvaser_usb_leaf_dev_ops,
+};
+
+static const struct kvaser_usb_driver_info kvaser_usb_driver_info_leafimx = {
+	.quirks = 0,
+	.ops = &kvaser_usb_leaf_dev_ops,
+};
 
 static const struct usb_device_id kvaser_usb_table[] = {
-	/* Leaf USB product IDs */
-	{ USB_DEVICE(KVASER_VENDOR_ID, USB_LEAF_DEVEL_PRODUCT_ID) },
-	{ USB_DEVICE(KVASER_VENDOR_ID, USB_LEAF_LITE_PRODUCT_ID) },
+	/* Leaf M32C USB product IDs */
+	{ USB_DEVICE(KVASER_VENDOR_ID, USB_LEAF_DEVEL_PRODUCT_ID),
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leaf },
+	{ USB_DEVICE(KVASER_VENDOR_ID, USB_LEAF_LITE_PRODUCT_ID),
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leaf },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_LEAF_PRO_PRODUCT_ID),
-		.driver_info = KVASER_USB_HAS_TXRX_ERRORS |
-			       KVASER_USB_HAS_SILENT_MODE },
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leaf_err_listen },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_LEAF_SPRO_PRODUCT_ID),
-		.driver_info = KVASER_USB_HAS_TXRX_ERRORS |
-			       KVASER_USB_HAS_SILENT_MODE },
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leaf_err_listen },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_LEAF_PRO_LS_PRODUCT_ID),
-		.driver_info = KVASER_USB_HAS_TXRX_ERRORS |
-			       KVASER_USB_HAS_SILENT_MODE },
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leaf_err_listen },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_LEAF_PRO_SWC_PRODUCT_ID),
-		.driver_info = KVASER_USB_HAS_TXRX_ERRORS |
-			       KVASER_USB_HAS_SILENT_MODE },
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leaf_err_listen },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_LEAF_PRO_LIN_PRODUCT_ID),
-		.driver_info = KVASER_USB_HAS_TXRX_ERRORS |
-			       KVASER_USB_HAS_SILENT_MODE },
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leaf_err_listen },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_LEAF_SPRO_LS_PRODUCT_ID),
-		.driver_info = KVASER_USB_HAS_TXRX_ERRORS |
-			       KVASER_USB_HAS_SILENT_MODE },
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leaf_err_listen },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_LEAF_SPRO_SWC_PRODUCT_ID),
-		.driver_info = KVASER_USB_HAS_TXRX_ERRORS |
-			       KVASER_USB_HAS_SILENT_MODE },
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leaf_err_listen },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_MEMO2_DEVEL_PRODUCT_ID),
-		.driver_info = KVASER_USB_HAS_TXRX_ERRORS |
-			       KVASER_USB_HAS_SILENT_MODE },
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leaf_err_listen },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_MEMO2_HSHS_PRODUCT_ID),
-		.driver_info = KVASER_USB_HAS_TXRX_ERRORS |
-			       KVASER_USB_HAS_SILENT_MODE },
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leaf_err_listen },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_UPRO_HSHS_PRODUCT_ID),
-		.driver_info = KVASER_USB_HAS_TXRX_ERRORS },
-	{ USB_DEVICE(KVASER_VENDOR_ID, USB_LEAF_LITE_GI_PRODUCT_ID) },
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leaf_err },
+	{ USB_DEVICE(KVASER_VENDOR_ID, USB_LEAF_LITE_GI_PRODUCT_ID),
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leaf },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_LEAF_PRO_OBDII_PRODUCT_ID),
-		.driver_info = KVASER_USB_HAS_TXRX_ERRORS |
-			       KVASER_USB_HAS_SILENT_MODE },
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leaf_err_listen },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_MEMO2_HSLS_PRODUCT_ID),
-		.driver_info = KVASER_USB_HAS_TXRX_ERRORS },
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leaf_err },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_LEAF_LITE_CH_PRODUCT_ID),
-		.driver_info = KVASER_USB_HAS_TXRX_ERRORS },
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leaf_err },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_BLACKBIRD_SPRO_PRODUCT_ID),
-		.driver_info = KVASER_USB_HAS_TXRX_ERRORS },
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leaf_err },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_OEM_MERCURY_PRODUCT_ID),
-		.driver_info = KVASER_USB_HAS_TXRX_ERRORS },
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leaf_err },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_OEM_LEAF_PRODUCT_ID),
-		.driver_info = KVASER_USB_HAS_TXRX_ERRORS },
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leaf_err },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_CAN_R_PRODUCT_ID),
-		.driver_info = KVASER_USB_HAS_TXRX_ERRORS },
-	{ USB_DEVICE(KVASER_VENDOR_ID, USB_LEAF_LITE_V2_PRODUCT_ID) },
-	{ USB_DEVICE(KVASER_VENDOR_ID, USB_MINI_PCIE_HS_PRODUCT_ID) },
-	{ USB_DEVICE(KVASER_VENDOR_ID, USB_LEAF_LIGHT_HS_V2_OEM_PRODUCT_ID) },
-	{ USB_DEVICE(KVASER_VENDOR_ID, USB_USBCAN_LIGHT_2HS_PRODUCT_ID) },
-	{ USB_DEVICE(KVASER_VENDOR_ID, USB_MINI_PCIE_2HS_PRODUCT_ID) },
-	{ USB_DEVICE(KVASER_VENDOR_ID, USB_USBCAN_R_V2_PRODUCT_ID) },
-	{ USB_DEVICE(KVASER_VENDOR_ID, USB_LEAF_LIGHT_R_V2_PRODUCT_ID) },
-	{ USB_DEVICE(KVASER_VENDOR_ID, USB_LEAF_LIGHT_HS_V2_OEM2_PRODUCT_ID) },
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leaf_err },
+
+	/* Leaf i.MX28 USB product IDs */
+	{ USB_DEVICE(KVASER_VENDOR_ID, USB_LEAF_LITE_V2_PRODUCT_ID),
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leafimx },
+	{ USB_DEVICE(KVASER_VENDOR_ID, USB_MINI_PCIE_HS_PRODUCT_ID),
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leafimx },
+	{ USB_DEVICE(KVASER_VENDOR_ID, USB_LEAF_LIGHT_HS_V2_OEM_PRODUCT_ID),
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leafimx },
+	{ USB_DEVICE(KVASER_VENDOR_ID, USB_USBCAN_LIGHT_2HS_PRODUCT_ID),
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leafimx },
+	{ USB_DEVICE(KVASER_VENDOR_ID, USB_MINI_PCIE_2HS_PRODUCT_ID),
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leafimx },
+	{ USB_DEVICE(KVASER_VENDOR_ID, USB_USBCAN_R_V2_PRODUCT_ID),
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leafimx },
+	{ USB_DEVICE(KVASER_VENDOR_ID, USB_LEAF_LIGHT_R_V2_PRODUCT_ID),
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leafimx },
+	{ USB_DEVICE(KVASER_VENDOR_ID, USB_LEAF_LIGHT_HS_V2_OEM2_PRODUCT_ID),
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leafimx },
 
 	/* USBCANII USB product IDs */
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_USBCAN2_PRODUCT_ID),
-		.driver_info = KVASER_USB_HAS_TXRX_ERRORS },
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_usbcan },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_USBCAN_REVB_PRODUCT_ID),
-		.driver_info = KVASER_USB_HAS_TXRX_ERRORS },
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_usbcan },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_MEMORATOR_PRODUCT_ID),
-		.driver_info = KVASER_USB_HAS_TXRX_ERRORS },
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_usbcan },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_VCI2_PRODUCT_ID),
-		.driver_info = KVASER_USB_HAS_TXRX_ERRORS },
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_usbcan },
 
 	/* Minihydra USB product IDs */
-	{ USB_DEVICE(KVASER_VENDOR_ID, USB_BLACKBIRD_V2_PRODUCT_ID) },
-	{ USB_DEVICE(KVASER_VENDOR_ID, USB_MEMO_PRO_5HS_PRODUCT_ID) },
-	{ USB_DEVICE(KVASER_VENDOR_ID, USB_USBCAN_PRO_5HS_PRODUCT_ID) },
-	{ USB_DEVICE(KVASER_VENDOR_ID, USB_USBCAN_LIGHT_4HS_PRODUCT_ID) },
-	{ USB_DEVICE(KVASER_VENDOR_ID, USB_LEAF_PRO_HS_V2_PRODUCT_ID) },
-	{ USB_DEVICE(KVASER_VENDOR_ID, USB_USBCAN_PRO_2HS_V2_PRODUCT_ID) },
-	{ USB_DEVICE(KVASER_VENDOR_ID, USB_MEMO_2HS_PRODUCT_ID) },
-	{ USB_DEVICE(KVASER_VENDOR_ID, USB_MEMO_PRO_2HS_V2_PRODUCT_ID) },
-	{ USB_DEVICE(KVASER_VENDOR_ID, USB_HYBRID_2CANLIN_PRODUCT_ID) },
-	{ USB_DEVICE(KVASER_VENDOR_ID, USB_ATI_USBCAN_PRO_2HS_V2_PRODUCT_ID) },
-	{ USB_DEVICE(KVASER_VENDOR_ID, USB_ATI_MEMO_PRO_2HS_V2_PRODUCT_ID) },
-	{ USB_DEVICE(KVASER_VENDOR_ID, USB_HYBRID_PRO_2CANLIN_PRODUCT_ID) },
-	{ USB_DEVICE(KVASER_VENDOR_ID, USB_U100_PRODUCT_ID) },
-	{ USB_DEVICE(KVASER_VENDOR_ID, USB_U100P_PRODUCT_ID) },
-	{ USB_DEVICE(KVASER_VENDOR_ID, USB_U100S_PRODUCT_ID) },
-	{ USB_DEVICE(KVASER_VENDOR_ID, USB_USBCAN_PRO_4HS_PRODUCT_ID) },
-	{ USB_DEVICE(KVASER_VENDOR_ID, USB_HYBRID_CANLIN_PRODUCT_ID) },
-	{ USB_DEVICE(KVASER_VENDOR_ID, USB_HYBRID_PRO_CANLIN_PRODUCT_ID) },
+	{ USB_DEVICE(KVASER_VENDOR_ID, USB_BLACKBIRD_V2_PRODUCT_ID),
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_hydra },
+	{ USB_DEVICE(KVASER_VENDOR_ID, USB_MEMO_PRO_5HS_PRODUCT_ID),
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_hydra },
+	{ USB_DEVICE(KVASER_VENDOR_ID, USB_USBCAN_PRO_5HS_PRODUCT_ID),
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_hydra },
+	{ USB_DEVICE(KVASER_VENDOR_ID, USB_USBCAN_LIGHT_4HS_PRODUCT_ID),
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_hydra },
+	{ USB_DEVICE(KVASER_VENDOR_ID, USB_LEAF_PRO_HS_V2_PRODUCT_ID),
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_hydra },
+	{ USB_DEVICE(KVASER_VENDOR_ID, USB_USBCAN_PRO_2HS_V2_PRODUCT_ID),
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_hydra },
+	{ USB_DEVICE(KVASER_VENDOR_ID, USB_MEMO_2HS_PRODUCT_ID),
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_hydra },
+	{ USB_DEVICE(KVASER_VENDOR_ID, USB_MEMO_PRO_2HS_V2_PRODUCT_ID),
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_hydra },
+	{ USB_DEVICE(KVASER_VENDOR_ID, USB_HYBRID_2CANLIN_PRODUCT_ID),
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_hydra },
+	{ USB_DEVICE(KVASER_VENDOR_ID, USB_ATI_USBCAN_PRO_2HS_V2_PRODUCT_ID),
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_hydra },
+	{ USB_DEVICE(KVASER_VENDOR_ID, USB_ATI_MEMO_PRO_2HS_V2_PRODUCT_ID),
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_hydra },
+	{ USB_DEVICE(KVASER_VENDOR_ID, USB_HYBRID_PRO_2CANLIN_PRODUCT_ID),
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_hydra },
+	{ USB_DEVICE(KVASER_VENDOR_ID, USB_U100_PRODUCT_ID),
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_hydra },
+	{ USB_DEVICE(KVASER_VENDOR_ID, USB_U100P_PRODUCT_ID),
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_hydra },
+	{ USB_DEVICE(KVASER_VENDOR_ID, USB_U100S_PRODUCT_ID),
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_hydra },
+	{ USB_DEVICE(KVASER_VENDOR_ID, USB_USBCAN_PRO_4HS_PRODUCT_ID),
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_hydra },
+	{ USB_DEVICE(KVASER_VENDOR_ID, USB_HYBRID_CANLIN_PRODUCT_ID),
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_hydra },
+	{ USB_DEVICE(KVASER_VENDOR_ID, USB_HYBRID_PRO_CANLIN_PRODUCT_ID),
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_hydra },
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, kvaser_usb_table);
@@ -289,6 +324,7 @@ int kvaser_usb_can_rx_over_error(struct net_device *netdev)
 static void kvaser_usb_read_bulk_callback(struct urb *urb)
 {
 	struct kvaser_usb *dev = urb->context;
+	const struct kvaser_usb_dev_ops *ops = dev->driver_info->ops;
 	int err;
 	unsigned int i;
 
@@ -305,8 +341,8 @@ static void kvaser_usb_read_bulk_callback(struct urb *urb)
 		goto resubmit_urb;
 	}
 
-	dev->ops->dev_read_bulk_callback(dev, urb->transfer_buffer,
-					 urb->actual_length);
+	ops->dev_read_bulk_callback(dev, urb->transfer_buffer,
+				    urb->actual_length);
 
 resubmit_urb:
 	usb_fill_bulk_urb(urb, dev->udev,
@@ -400,6 +436,7 @@ static int kvaser_usb_open(struct net_device *netdev)
 {
 	struct kvaser_usb_net_priv *priv = netdev_priv(netdev);
 	struct kvaser_usb *dev = priv->dev;
+	const struct kvaser_usb_dev_ops *ops = dev->driver_info->ops;
 	int err;
 
 	err = open_candev(netdev);
@@ -410,11 +447,11 @@ static int kvaser_usb_open(struct net_device *netdev)
 	if (err)
 		goto error;
 
-	err = dev->ops->dev_set_opt_mode(priv);
+	err = ops->dev_set_opt_mode(priv);
 	if (err)
 		goto error;
 
-	err = dev->ops->dev_start_chip(priv);
+	err = ops->dev_start_chip(priv);
 	if (err) {
 		netdev_warn(netdev, "Cannot start device, error %d\n", err);
 		goto error;
@@ -471,22 +508,23 @@ static int kvaser_usb_close(struct net_device *netdev)
 {
 	struct kvaser_usb_net_priv *priv = netdev_priv(netdev);
 	struct kvaser_usb *dev = priv->dev;
+	const struct kvaser_usb_dev_ops *ops = dev->driver_info->ops;
 	int err;
 
 	netif_stop_queue(netdev);
 
-	err = dev->ops->dev_flush_queue(priv);
+	err = ops->dev_flush_queue(priv);
 	if (err)
 		netdev_warn(netdev, "Cannot flush queue, error %d\n", err);
 
-	if (dev->ops->dev_reset_chip) {
-		err = dev->ops->dev_reset_chip(dev, priv->channel);
+	if (ops->dev_reset_chip) {
+		err = ops->dev_reset_chip(dev, priv->channel);
 		if (err)
 			netdev_warn(netdev, "Cannot reset card, error %d\n",
 				    err);
 	}
 
-	err = dev->ops->dev_stop_chip(priv);
+	err = ops->dev_stop_chip(priv);
 	if (err)
 		netdev_warn(netdev, "Cannot stop device, error %d\n", err);
 
@@ -525,6 +563,7 @@ static netdev_tx_t kvaser_usb_start_xmit(struct sk_buff *skb,
 {
 	struct kvaser_usb_net_priv *priv = netdev_priv(netdev);
 	struct kvaser_usb *dev = priv->dev;
+	const struct kvaser_usb_dev_ops *ops = dev->driver_info->ops;
 	struct net_device_stats *stats = &netdev->stats;
 	struct kvaser_usb_tx_urb_context *context = NULL;
 	struct urb *urb;
@@ -567,8 +606,8 @@ static netdev_tx_t kvaser_usb_start_xmit(struct sk_buff *skb,
 		goto freeurb;
 	}
 
-	buf = dev->ops->dev_frame_to_cmd(priv, skb, &context->dlc, &cmd_len,
-					 context->echo_index);
+	buf = ops->dev_frame_to_cmd(priv, skb, &context->dlc, &cmd_len,
+				    context->echo_index);
 	if (!buf) {
 		stats->tx_dropped++;
 		dev_kfree_skb(skb);
@@ -652,15 +691,16 @@ static void kvaser_usb_remove_interfaces(struct kvaser_usb *dev)
 	}
 }
 
-static int kvaser_usb_init_one(struct kvaser_usb *dev,
-			       const struct usb_device_id *id, int channel)
+static int kvaser_usb_init_one(struct kvaser_usb *dev, int channel)
 {
 	struct net_device *netdev;
 	struct kvaser_usb_net_priv *priv;
+	const struct kvaser_usb_driver_info *driver_info = dev->driver_info;
+	const struct kvaser_usb_dev_ops *ops = driver_info->ops;
 	int err;
 
-	if (dev->ops->dev_reset_chip) {
-		err = dev->ops->dev_reset_chip(dev, channel);
+	if (ops->dev_reset_chip) {
+		err = ops->dev_reset_chip(dev, channel);
 		if (err)
 			return err;
 	}
@@ -689,20 +729,19 @@ static int kvaser_usb_init_one(struct kvaser_usb *dev,
 	priv->can.state = CAN_STATE_STOPPED;
 	priv->can.clock.freq = dev->cfg->clock.freq;
 	priv->can.bittiming_const = dev->cfg->bittiming_const;
-	priv->can.do_set_bittiming = dev->ops->dev_set_bittiming;
-	priv->can.do_set_mode = dev->ops->dev_set_mode;
-	if ((id->driver_info & KVASER_USB_HAS_TXRX_ERRORS) ||
+	priv->can.do_set_bittiming = ops->dev_set_bittiming;
+	priv->can.do_set_mode = ops->dev_set_mode;
+	if ((driver_info->quirks & KVASER_USB_QUIRK_HAS_TXRX_ERRORS) ||
 	    (priv->dev->card_data.capabilities & KVASER_USB_CAP_BERR_CAP))
-		priv->can.do_get_berr_counter = dev->ops->dev_get_berr_counter;
-	if (id->driver_info & KVASER_USB_HAS_SILENT_MODE)
+		priv->can.do_get_berr_counter = ops->dev_get_berr_counter;
+	if (driver_info->quirks & KVASER_USB_QUIRK_HAS_SILENT_MODE)
 		priv->can.ctrlmode_supported |= CAN_CTRLMODE_LISTENONLY;
 
 	priv->can.ctrlmode_supported |= dev->card_data.ctrlmode_supported;
 
 	if (priv->can.ctrlmode_supported & CAN_CTRLMODE_FD) {
 		priv->can.data_bittiming_const = dev->cfg->data_bittiming_const;
-		priv->can.do_set_data_bittiming =
-					dev->ops->dev_set_data_bittiming;
+		priv->can.do_set_data_bittiming = ops->dev_set_data_bittiming;
 	}
 
 	netdev->flags |= IFF_ECHO;
@@ -733,29 +772,22 @@ static int kvaser_usb_probe(struct usb_interface *intf,
 	struct kvaser_usb *dev;
 	int err;
 	int i;
+	const struct kvaser_usb_driver_info *driver_info;
+	const struct kvaser_usb_dev_ops *ops;
+
+	driver_info = (const struct kvaser_usb_driver_info *)id->driver_info;
+	if (!driver_info)
+		return -ENODEV;
 
 	dev = devm_kzalloc(&intf->dev, sizeof(*dev), GFP_KERNEL);
 	if (!dev)
 		return -ENOMEM;
 
-	if (kvaser_is_leaf(id)) {
-		dev->card_data.leaf.family = KVASER_LEAF;
-		dev->ops = &kvaser_usb_leaf_dev_ops;
-	} else if (kvaser_is_usbcan(id)) {
-		dev->card_data.leaf.family = KVASER_USBCAN;
-		dev->ops = &kvaser_usb_leaf_dev_ops;
-	} else if (kvaser_is_hydra(id)) {
-		dev->ops = &kvaser_usb_hydra_dev_ops;
-	} else {
-		dev_err(&intf->dev,
-			"Product ID (%d) is not a supported Kvaser USB device\n",
-			id->idProduct);
-		return -ENODEV;
-	}
-
 	dev->intf = intf;
+	dev->driver_info = driver_info;
+	ops = driver_info->ops;
 
-	err = dev->ops->dev_setup_endpoints(dev);
+	err = ops->dev_setup_endpoints(dev);
 	if (err) {
 		dev_err(&intf->dev, "Cannot get usb endpoint(s)");
 		return err;
@@ -769,22 +801,22 @@ static int kvaser_usb_probe(struct usb_interface *intf,
 
 	dev->card_data.ctrlmode_supported = 0;
 	dev->card_data.capabilities = 0;
-	err = dev->ops->dev_init_card(dev);
+	err = ops->dev_init_card(dev);
 	if (err) {
 		dev_err(&intf->dev,
 			"Failed to initialize card, error %d\n", err);
 		return err;
 	}
 
-	err = dev->ops->dev_get_software_info(dev);
+	err = ops->dev_get_software_info(dev);
 	if (err) {
 		dev_err(&intf->dev,
 			"Cannot get software info, error %d\n", err);
 		return err;
 	}
 
-	if (dev->ops->dev_get_software_details) {
-		err = dev->ops->dev_get_software_details(dev);
+	if (ops->dev_get_software_details) {
+		err = ops->dev_get_software_details(dev);
 		if (err) {
 			dev_err(&intf->dev,
 				"Cannot get software details, error %d\n", err);
@@ -802,14 +834,14 @@ static int kvaser_usb_probe(struct usb_interface *intf,
 
 	dev_dbg(&intf->dev, "Max outstanding tx = %d URBs\n", dev->max_tx_urbs);
 
-	err = dev->ops->dev_get_card_info(dev);
+	err = ops->dev_get_card_info(dev);
 	if (err) {
 		dev_err(&intf->dev, "Cannot get card info, error %d\n", err);
 		return err;
 	}
 
-	if (dev->ops->dev_get_capabilities) {
-		err = dev->ops->dev_get_capabilities(dev);
+	if (ops->dev_get_capabilities) {
+		err = ops->dev_get_capabilities(dev);
 		if (err) {
 			dev_err(&intf->dev,
 				"Cannot get capabilities, error %d\n", err);
@@ -819,7 +851,7 @@ static int kvaser_usb_probe(struct usb_interface *intf,
 	}
 
 	for (i = 0; i < dev->nchannels; i++) {
-		err = kvaser_usb_init_one(dev, id, i);
+		err = kvaser_usb_init_one(dev, i);
 		if (err) {
 			kvaser_usb_remove_interfaces(dev);
 			return err;
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
index dcee8dc828ec..fce3f069cdbc 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
@@ -373,7 +373,7 @@ static const struct can_bittiming_const kvaser_usb_hydra_kcan_bittiming_c = {
 	.brp_inc = 1,
 };
 
-static const struct can_bittiming_const kvaser_usb_hydra_flexc_bittiming_c = {
+const struct can_bittiming_const kvaser_usb_flexc_bittiming_const = {
 	.name = "kvaser_usb_flex",
 	.tseg1_min = 4,
 	.tseg1_max = 16,
@@ -2052,7 +2052,7 @@ static const struct kvaser_usb_dev_cfg kvaser_usb_hydra_dev_cfg_flexc = {
 		.freq = 24000000,
 	},
 	.timestamp_freq = 1,
-	.bittiming_const = &kvaser_usb_hydra_flexc_bittiming_c,
+	.bittiming_const = &kvaser_usb_flexc_bittiming_const,
 };
 
 static const struct kvaser_usb_dev_cfg kvaser_usb_hydra_dev_cfg_rt = {
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
index f7af1bf5ab46..b9c2231e4b43 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
@@ -100,16 +100,6 @@
 #define USBCAN_ERROR_STATE_RX_ERROR	BIT(1)
 #define USBCAN_ERROR_STATE_BUSERROR	BIT(2)
 
-/* bittiming parameters */
-#define KVASER_USB_TSEG1_MIN		1
-#define KVASER_USB_TSEG1_MAX		16
-#define KVASER_USB_TSEG2_MIN		1
-#define KVASER_USB_TSEG2_MAX		8
-#define KVASER_USB_SJW_MAX		4
-#define KVASER_USB_BRP_MIN		1
-#define KVASER_USB_BRP_MAX		64
-#define KVASER_USB_BRP_INC		1
-
 /* ctrl modes */
 #define KVASER_CTRL_MODE_NORMAL		1
 #define KVASER_CTRL_MODE_SILENT		2
@@ -342,48 +332,68 @@ struct kvaser_usb_err_summary {
 	};
 };
 
-static const struct can_bittiming_const kvaser_usb_leaf_bittiming_const = {
-	.name = "kvaser_usb",
-	.tseg1_min = KVASER_USB_TSEG1_MIN,
-	.tseg1_max = KVASER_USB_TSEG1_MAX,
-	.tseg2_min = KVASER_USB_TSEG2_MIN,
-	.tseg2_max = KVASER_USB_TSEG2_MAX,
-	.sjw_max = KVASER_USB_SJW_MAX,
-	.brp_min = KVASER_USB_BRP_MIN,
-	.brp_max = KVASER_USB_BRP_MAX,
-	.brp_inc = KVASER_USB_BRP_INC,
+static const struct can_bittiming_const kvaser_usb_leaf_m16c_bittiming_const = {
+	.name = "kvaser_usb_ucii",
+	.tseg1_min = 4,
+	.tseg1_max = 16,
+	.tseg2_min = 2,
+	.tseg2_max = 8,
+	.sjw_max = 4,
+	.brp_min = 1,
+	.brp_max = 16,
+	.brp_inc = 1,
+};
+
+static const struct can_bittiming_const kvaser_usb_leaf_m32c_bittiming_const = {
+	.name = "kvaser_usb_leaf",
+	.tseg1_min = 3,
+	.tseg1_max = 16,
+	.tseg2_min = 2,
+	.tseg2_max = 8,
+	.sjw_max = 4,
+	.brp_min = 2,
+	.brp_max = 128,
+	.brp_inc = 2,
 };
 
-static const struct kvaser_usb_dev_cfg kvaser_usb_leaf_dev_cfg_8mhz = {
+static const struct kvaser_usb_dev_cfg kvaser_usb_leaf_usbcan_dev_cfg = {
 	.clock = {
 		.freq = 8000000,
 	},
 	.timestamp_freq = 1,
-	.bittiming_const = &kvaser_usb_leaf_bittiming_const,
+	.bittiming_const = &kvaser_usb_leaf_m16c_bittiming_const,
+};
+
+static const struct kvaser_usb_dev_cfg kvaser_usb_leaf_m32c_dev_cfg = {
+	.clock = {
+		.freq = 16000000,
+	},
+	.timestamp_freq = 1,
+	.bittiming_const = &kvaser_usb_leaf_m32c_bittiming_const,
 };
 
-static const struct kvaser_usb_dev_cfg kvaser_usb_leaf_dev_cfg_16mhz = {
+static const struct kvaser_usb_dev_cfg kvaser_usb_leaf_imx_dev_cfg_16mhz = {
 	.clock = {
 		.freq = 16000000,
 	},
 	.timestamp_freq = 1,
-	.bittiming_const = &kvaser_usb_leaf_bittiming_const,
+	.bittiming_const = &kvaser_usb_flexc_bittiming_const,
 };
 
-static const struct kvaser_usb_dev_cfg kvaser_usb_leaf_dev_cfg_24mhz = {
+static const struct kvaser_usb_dev_cfg kvaser_usb_leaf_imx_dev_cfg_24mhz = {
 	.clock = {
 		.freq = 24000000,
 	},
 	.timestamp_freq = 1,
-	.bittiming_const = &kvaser_usb_leaf_bittiming_const,
+	.bittiming_const = &kvaser_usb_flexc_bittiming_const,
 };
 
-static const struct kvaser_usb_dev_cfg kvaser_usb_leaf_dev_cfg_32mhz = {
+static const struct kvaser_usb_dev_cfg kvaser_usb_leaf_imx_dev_cfg_32mhz = {
 	.clock = {
 		.freq = 32000000,
 	},
 	.timestamp_freq = 1,
-	.bittiming_const = &kvaser_usb_leaf_bittiming_const,
+	.bittiming_const = &kvaser_usb_flexc_bittiming_const,
 };
 
 static void *
@@ -405,7 +415,7 @@ kvaser_usb_leaf_frame_to_cmd(const struct kvaser_usb_net_priv *priv,
 				      sizeof(struct kvaser_cmd_tx_can);
 		cmd->u.tx_can.channel = priv->channel;
 
-		switch (dev->card_data.leaf.family) {
+		switch (dev->driver_info->family) {
 		case KVASER_LEAF:
 			cmd_tx_can_flags = &cmd->u.tx_can.leaf.flags;
 			break;
@@ -525,16 +535,23 @@ static void kvaser_usb_leaf_get_software_info_leaf(struct kvaser_usb *dev,
 	dev->fw_version = le32_to_cpu(softinfo->fw_version);
 	dev->max_tx_urbs = le16_to_cpu(softinfo->max_outstanding_tx);
 
-	switch (sw_options & KVASER_USB_LEAF_SWOPTION_FREQ_MASK) {
-	case KVASER_USB_LEAF_SWOPTION_FREQ_16_MHZ_CLK:
-		dev->cfg = &kvaser_usb_leaf_dev_cfg_16mhz;
-		break;
-	case KVASER_USB_LEAF_SWOPTION_FREQ_24_MHZ_CLK:
-		dev->cfg = &kvaser_usb_leaf_dev_cfg_24mhz;
-		break;
-	case KVASER_USB_LEAF_SWOPTION_FREQ_32_MHZ_CLK:
-		dev->cfg = &kvaser_usb_leaf_dev_cfg_32mhz;
-		break;
+	if (dev->driver_info->quirks & KVASER_USB_QUIRK_IGNORE_CLK_FREQ) {
+		/* Firmware expects bittiming parameters calculated for 16MHz
+		 * clock, regardless of the actual clock
+		 */
+		dev->cfg = &kvaser_usb_leaf_m32c_dev_cfg;
+	} else {
+		switch (sw_options & KVASER_USB_LEAF_SWOPTION_FREQ_MASK) {
+		case KVASER_USB_LEAF_SWOPTION_FREQ_16_MHZ_CLK:
+			dev->cfg = &kvaser_usb_leaf_imx_dev_cfg_16mhz;
+			break;
+		case KVASER_USB_LEAF_SWOPTION_FREQ_24_MHZ_CLK:
+			dev->cfg = &kvaser_usb_leaf_imx_dev_cfg_24mhz;
+			break;
+		case KVASER_USB_LEAF_SWOPTION_FREQ_32_MHZ_CLK:
+			dev->cfg = &kvaser_usb_leaf_imx_dev_cfg_32mhz;
+			break;
+		}
 	}
 }
 
@@ -551,7 +568,7 @@ static int kvaser_usb_leaf_get_software_info_inner(struct kvaser_usb *dev)
 	if (err)
 		return err;
 
-	switch (dev->card_data.leaf.family) {
+	switch (dev->driver_info->family) {
 	case KVASER_LEAF:
 		kvaser_usb_leaf_get_software_info_leaf(dev, &cmd.u.leaf.softinfo);
 		break;
@@ -559,7 +576,7 @@ static int kvaser_usb_leaf_get_software_info_inner(struct kvaser_usb *dev)
 		dev->fw_version = le32_to_cpu(cmd.u.usbcan.softinfo.fw_version);
 		dev->max_tx_urbs =
 			le16_to_cpu(cmd.u.usbcan.softinfo.max_outstanding_tx);
-		dev->cfg = &kvaser_usb_leaf_dev_cfg_8mhz;
+		dev->cfg = &kvaser_usb_leaf_usbcan_dev_cfg;
 		break;
 	}
 
@@ -598,7 +615,7 @@ static int kvaser_usb_leaf_get_card_info(struct kvaser_usb *dev)
 
 	dev->nchannels = cmd.u.cardinfo.nchannels;
 	if (dev->nchannels > KVASER_USB_MAX_NET_DEVICES ||
-	    (dev->card_data.leaf.family == KVASER_USBCAN &&
+	    (dev->driver_info->family == KVASER_USBCAN &&
 	     dev->nchannels > MAX_USBCAN_NET_DEVICES))
 		return -EINVAL;
 
@@ -734,7 +751,7 @@ kvaser_usb_leaf_rx_error_update_can_state(struct kvaser_usb_net_priv *priv,
 	    new_state < CAN_STATE_BUS_OFF)
 		priv->can.can_stats.restarts++;
 
-	switch (dev->card_data.leaf.family) {
+	switch (dev->driver_info->family) {
 	case KVASER_LEAF:
 		if (es->leaf.error_factor) {
 			priv->can.can_stats.bus_error++;
@@ -813,7 +830,7 @@ static void kvaser_usb_leaf_rx_error(const struct kvaser_usb *dev,
 		}
 	}
 
-	switch (dev->card_data.leaf.family) {
+	switch (dev->driver_info->family) {
 	case KVASER_LEAF:
 		if (es->leaf.error_factor) {
 			cf->can_id |= CAN_ERR_BUSERROR | CAN_ERR_PROT;
@@ -1005,7 +1022,7 @@ static void kvaser_usb_leaf_rx_can_msg(const struct kvaser_usb *dev,
 	stats = &priv->netdev->stats;
 
 	if ((cmd->u.rx_can_header.flag & MSG_FLAG_ERROR_FRAME) &&
-	    (dev->card_data.leaf.family == KVASER_LEAF &&
+	    (dev->driver_info->family == KVASER_LEAF &&
 	     cmd->id == CMD_LEAF_LOG_MESSAGE)) {
 		kvaser_usb_leaf_leaf_rx_error(dev, cmd);
 		return;
@@ -1021,7 +1038,7 @@ static void kvaser_usb_leaf_rx_can_msg(const struct kvaser_usb *dev,
 		return;
 	}
 
-	switch (dev->card_data.leaf.family) {
+	switch (dev->driver_info->family) {
 	case KVASER_LEAF:
 		rx_data = cmd->u.leaf.rx_can.data;
 		break;
@@ -1036,7 +1053,7 @@ static void kvaser_usb_leaf_rx_can_msg(const struct kvaser_usb *dev,
 		return;
 	}
 
-	if (dev->card_data.leaf.family == KVASER_LEAF && cmd->id ==
+	if (dev->driver_info->family == KVASER_LEAF && cmd->id ==
 	    CMD_LEAF_LOG_MESSAGE) {
 		cf->can_id = le32_to_cpu(cmd->u.leaf.log_message.id);
 		if (cf->can_id & KVASER_EXTENDED_FRAME)
@@ -1133,14 +1150,14 @@ static void kvaser_usb_leaf_handle_command(const struct kvaser_usb *dev,
 		break;
 
 	case CMD_LEAF_LOG_MESSAGE:
-		if (dev->card_data.leaf.family != KVASER_LEAF)
+		if (dev->driver_info->family != KVASER_LEAF)
 			goto warn;
 		kvaser_usb_leaf_rx_can_msg(dev, cmd);
 		break;
 
 	case CMD_CHIP_STATE_EVENT:
 	case CMD_CAN_ERROR_EVENT:
-		if (dev->card_data.leaf.family == KVASER_LEAF)
+		if (dev->driver_info->family == KVASER_LEAF)
 			kvaser_usb_leaf_leaf_rx_error(dev, cmd);
 		else
 			kvaser_usb_leaf_usbcan_rx_error(dev, cmd);
@@ -1152,12 +1169,12 @@ static void kvaser_usb_leaf_handle_command(const struct kvaser_usb *dev,
 
 	/* Ignored commands */
 	case CMD_USBCAN_CLOCK_OVERFLOW_EVENT:
-		if (dev->card_data.leaf.family != KVASER_USBCAN)
+		if (dev->driver_info->family != KVASER_USBCAN)
 			goto warn;
 		break;
 
 	case CMD_FLUSH_QUEUE_REPLY:
-		if (dev->card_data.leaf.family != KVASER_LEAF)
+		if (dev->driver_info->family != KVASER_LEAF)
 			goto warn;
 		break;
 
diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index a984f06f6f04..67869c8cbeaa 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1599,7 +1599,7 @@ static int
 qca8k_port_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
 {
 	struct qca8k_priv *priv = ds->priv;
-	int i, mtu = 0;
+	int ret, i, mtu = 0;
 
 	priv->port_mtu[port] = new_mtu;
 
@@ -1607,8 +1607,27 @@ qca8k_port_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
 		if (priv->port_mtu[i] > mtu)
 			mtu = priv->port_mtu[i];
 
+	/* To change the MAX_FRAME_SIZE the cpu ports must be off or
+	 * the switch panics.
+	 * Turn off both cpu ports before applying the new value to prevent
+	 * this.
+	 */
+	if (priv->port_sts[0].enabled)
+		qca8k_port_set_status(priv, 0, 0);
+
+	if (priv->port_sts[6].enabled)
+		qca8k_port_set_status(priv, 6, 0);
+
 	/* Include L2 header / FCS length */
-	return qca8k_write(priv, QCA8K_MAX_FRAME_SIZE, mtu + ETH_HLEN + ETH_FCS_LEN);
+	ret = qca8k_write(priv, QCA8K_MAX_FRAME_SIZE, mtu + ETH_HLEN + ETH_FCS_LEN);
+
+	if (priv->port_sts[0].enabled)
+		qca8k_port_set_status(priv, 0, 1);
+
+	if (priv->port_sts[6].enabled)
+		qca8k_port_set_status(priv, 6, 1);
+
+	return ret;
 }
 
 static int
diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index b262aa84b6a2..4a070724a8fb 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2063,6 +2063,19 @@ static const char *reset_reason_to_string(enum ibmvnic_reset_reason reason)
 	return "UNKNOWN";
 }
 
+/*
+ * Initialize the init_done completion and return code values. We
+ * can get a transport event just after registering the CRQ and the
+ * tasklet will use this to communicate the transport event. To ensure
+ * we don't miss the notification/error, initialize these _before_
+ * regisering the CRQ.
+ */
+static inline void reinit_init_done(struct ibmvnic_adapter *adapter)
+{
+	reinit_completion(&adapter->init_done);
+	adapter->init_done_rc = 0;
+}
+
 /*
  * do_reset returns zero if we are able to keep processing reset events, or
  * non-zero if we hit a fatal error and must halt.
@@ -2169,6 +2182,8 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 		 */
 		adapter->state = VNIC_PROBED;
 
+		reinit_init_done(adapter);
+
 		if (adapter->reset_reason == VNIC_RESET_CHANGE_PARAM) {
 			rc = init_crq_queue(adapter);
 		} else if (adapter->reset_reason == VNIC_RESET_MOBILITY) {
@@ -2314,7 +2329,8 @@ static int do_hard_reset(struct ibmvnic_adapter *adapter,
 	 */
 	adapter->state = VNIC_PROBED;
 
-	reinit_completion(&adapter->init_done);
+	reinit_init_done(adapter);
+
 	rc = init_crq_queue(adapter);
 	if (rc) {
 		netdev_err(adapter->netdev,
@@ -2455,23 +2471,82 @@ static int do_passive_init(struct ibmvnic_adapter *adapter)
 static void __ibmvnic_reset(struct work_struct *work)
 {
 	struct ibmvnic_adapter *adapter;
-	bool saved_state = false;
+	unsigned int timeout = 5000;
 	struct ibmvnic_rwi *tmprwi;
+	bool saved_state = false;
 	struct ibmvnic_rwi *rwi;
 	unsigned long flags;
-	u32 reset_state;
+	struct device *dev;
+	bool need_reset;
 	int num_fails = 0;
+	u32 reset_state;
 	int rc = 0;
 
 	adapter = container_of(work, struct ibmvnic_adapter, ibmvnic_reset);
+		dev = &adapter->vdev->dev;
 
-	if (test_and_set_bit_lock(0, &adapter->resetting)) {
+	/* Wait for ibmvnic_probe() to complete. If probe is taking too long
+	 * or if another reset is in progress, defer work for now. If probe
+	 * eventually fails it will flush and terminate our work.
+	 *
+	 * Three possibilities here:
+	 * 1. Adpater being removed  - just return
+	 * 2. Timed out on probe or another reset in progress - delay the work
+	 * 3. Completed probe - perform any resets in queue
+	 */
+	if (adapter->state == VNIC_PROBING &&
+	    !wait_for_completion_timeout(&adapter->probe_done, timeout)) {
+		dev_err(dev, "Reset thread timed out on probe");
 		queue_delayed_work(system_long_wq,
 				   &adapter->ibmvnic_delayed_reset,
 				   IBMVNIC_RESET_DELAY);
 		return;
 	}
 
+	/* adapter is done with probe (i.e state is never VNIC_PROBING now) */
+	if (adapter->state == VNIC_REMOVING)
+		return;
+
+	/* ->rwi_list is stable now (no one else is removing entries) */
+
+	/* ibmvnic_probe() may have purged the reset queue after we were
+	 * scheduled to process a reset so there maybe no resets to process.
+	 * Before setting the ->resetting bit though, we have to make sure
+	 * that there is infact a reset to process. Otherwise we may race
+	 * with ibmvnic_open() and end up leaving the vnic down:
+	 *
+	 *	__ibmvnic_reset()	    ibmvnic_open()
+	 *	-----------------	    --------------
+	 *
+	 *  set ->resetting bit
+	 *  				find ->resetting bit is set
+	 *  				set ->state to IBMVNIC_OPEN (i.e
+	 *  				assume reset will open device)
+	 *  				return
+	 *  find reset queue empty
+	 *  return
+	 *
+	 *  	Neither performed vnic login/open and vnic stays down
+	 *
+	 * If we hold the lock and conditionally set the bit, either we
+	 * or ibmvnic_open() will complete the open.
+	 */
+	need_reset = false;
+	spin_lock(&adapter->rwi_lock);
+	if (!list_empty(&adapter->rwi_list)) {
+		if (test_and_set_bit_lock(0, &adapter->resetting)) {
+			queue_delayed_work(system_long_wq,
+					   &adapter->ibmvnic_delayed_reset,
+					   IBMVNIC_RESET_DELAY);
+		} else {
+			need_reset = true;
+		}
+	}
+	spin_unlock(&adapter->rwi_lock);
+
+	if (!need_reset)
+		return;
+
 	rwi = get_next_rwi(adapter);
 	while (rwi) {
 		spin_lock_irqsave(&adapter->state_lock, flags);
@@ -2623,13 +2698,6 @@ static int ibmvnic_reset(struct ibmvnic_adapter *adapter,
 		goto err;
 	}
 
-	if (adapter->state == VNIC_PROBING) {
-		netdev_warn(netdev, "Adapter reset during probe\n");
-		adapter->init_done_rc = -EAGAIN;
-		ret = EAGAIN;
-		goto err;
-	}
-
 	list_for_each_entry(tmp, &adapter->rwi_list, list) {
 		if (tmp->reset_reason == reason) {
 			netdev_dbg(netdev, "Skipping matching reset, reason=%s\n",
@@ -5485,10 +5553,6 @@ static int ibmvnic_reset_init(struct ibmvnic_adapter *adapter, bool reset)
 
 	adapter->from_passive_init = false;
 
-	if (reset)
-		reinit_completion(&adapter->init_done);
-
-	adapter->init_done_rc = 0;
 	rc = ibmvnic_send_crq_init(adapter);
 	if (rc) {
 		dev_err(dev, "Send crq init failed with error %d\n", rc);
@@ -5502,12 +5566,14 @@ static int ibmvnic_reset_init(struct ibmvnic_adapter *adapter, bool reset)
 
 	if (adapter->init_done_rc) {
 		release_crq_queue(adapter);
+		dev_err(dev, "CRQ-init failed, %d\n", adapter->init_done_rc);
 		return adapter->init_done_rc;
 	}
 
 	if (adapter->from_passive_init) {
 		adapter->state = VNIC_OPEN;
 		adapter->from_passive_init = false;
+		dev_err(dev, "CRQ-init failed, passive-init\n");
 		return -1;
 	}
 
@@ -5519,6 +5585,15 @@ static int ibmvnic_reset_init(struct ibmvnic_adapter *adapter, bool reset)
 			release_sub_crqs(adapter, 0);
 			rc = init_sub_crqs(adapter);
 		} else {
+			/* no need to reinitialize completely, but we do
+			 * need to clean up transmits that were in flight
+			 * when we processed the reset.  Failure to do so
+			 * will confound the upper layer, usually TCP, by
+			 * creating the illusion of transmits that are
+			 * awaiting completion.
+			 */
+			clean_tx_pools(adapter);
+
 			rc = reset_sub_crq_queues(adapter);
 		}
 	} else {
@@ -5547,6 +5622,7 @@ static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
 	struct ibmvnic_adapter *adapter;
 	struct net_device *netdev;
 	unsigned char *mac_addr_p;
+	unsigned long flags;
 	bool init_success;
 	int rc;
 
@@ -5588,6 +5664,7 @@ static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
 	spin_lock_init(&adapter->rwi_lock);
 	spin_lock_init(&adapter->state_lock);
 	mutex_init(&adapter->fw_lock);
+	init_completion(&adapter->probe_done);
 	init_completion(&adapter->init_done);
 	init_completion(&adapter->fw_done);
 	init_completion(&adapter->reset_done);
@@ -5596,6 +5673,33 @@ static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
 
 	init_success = false;
 	do {
+		reinit_init_done(adapter);
+
+		/* clear any failovers we got in the previous pass
+		 * since we are reinitializing the CRQ
+		 */
+		adapter->failover_pending = false;
+
+		/* If we had already initialized CRQ, we may have one or
+		 * more resets queued already. Discard those and release
+		 * the CRQ before initializing the CRQ again.
+		 */
+		release_crq_queue(adapter);
+
+		/* Since we are still in PROBING state, __ibmvnic_reset()
+		 * will not access the ->rwi_list and since we released CRQ,
+		 * we won't get _new_ transport events. But there maybe an
+		 * ongoing ibmvnic_reset() call. So serialize access to
+		 * rwi_list. If we win the race, ibvmnic_reset() could add
+		 * a reset after we purged but thats ok - we just may end
+		 * up with an extra reset (i.e similar to having two or more
+		 * resets in the queue at once).
+		 * CHECK.
+		 */
+		spin_lock_irqsave(&adapter->rwi_lock, flags);
+		flush_reset_queue(adapter);
+		spin_unlock_irqrestore(&adapter->rwi_lock, flags);
+
 		rc = init_crq_queue(adapter);
 		if (rc) {
 			dev_err(&dev->dev, "Couldn't initialize crq. rc=%d\n",
@@ -5647,6 +5751,8 @@ static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
 	}
 	dev_info(&dev->dev, "ibmvnic registered\n");
 
+	complete(&adapter->probe_done);
+
 	return 0;
 
 ibmvnic_register_fail:
@@ -5661,6 +5767,17 @@ static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
 ibmvnic_init_fail:
 	release_sub_crqs(adapter, 1);
 	release_crq_queue(adapter);
+
+	/* cleanup worker thread after releasing CRQ so we don't get
+	 * transport events (i.e new work items for the worker thread).
+	 */
+	adapter->state = VNIC_REMOVING;
+	complete(&adapter->probe_done);
+	flush_work(&adapter->ibmvnic_reset);
+	flush_delayed_work(&adapter->ibmvnic_delayed_reset);
+
+	flush_reset_queue(adapter);
+
 	mutex_destroy(&adapter->fw_lock);
 	free_netdev(netdev);
 
diff --git a/drivers/net/ethernet/ibm/ibmvnic.h b/drivers/net/ethernet/ibm/ibmvnic.h
index 1a9ed9202654..b01c439965ff 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.h
+++ b/drivers/net/ethernet/ibm/ibmvnic.h
@@ -927,6 +927,7 @@ struct ibmvnic_adapter {
 
 	struct ibmvnic_tx_pool *tx_pool;
 	struct ibmvnic_tx_pool *tso_pool;
+	struct completion probe_done;
 	struct completion init_done;
 	int init_done_rc;
 
diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index 56a3a6d1dbe4..210f09118ede 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -37,6 +37,7 @@
 #include <net/tc_act/tc_mirred.h>
 #include <net/udp_tunnel.h>
 #include <net/xdp_sock.h>
+#include <linux/bitfield.h>
 #include "i40e_type.h"
 #include "i40e_prototype.h"
 #include <linux/net/intel/i40e_client.h>
@@ -1087,6 +1088,21 @@ static inline void i40e_write_fd_input_set(struct i40e_pf *pf,
 			  (u32)(val & 0xFFFFFFFFULL));
 }
 
+/**
+ * i40e_get_pf_count - get PCI PF count.
+ * @hw: pointer to a hw.
+ *
+ * Reports the function number of the highest PCI physical
+ * function plus 1 as it is loaded from the NVM.
+ *
+ * Return: PCI PF count.
+ **/
+static inline u32 i40e_get_pf_count(struct i40e_hw *hw)
+{
+	return FIELD_GET(I40E_GLGEN_PCIFCNCNT_PCIPFCNT_MASK,
+			 rd32(hw, I40E_GLGEN_PCIFCNCNT));
+}
+
 /* needed by i40e_ethtool.c */
 int i40e_up(struct i40e_vsi *vsi);
 void i40e_down(struct i40e_vsi *vsi);
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 9bc05d671ad5..02594e4d6258 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -549,6 +549,47 @@ void i40e_pf_reset_stats(struct i40e_pf *pf)
 	pf->hw_csum_rx_error = 0;
 }
 
+/**
+ * i40e_compute_pci_to_hw_id - compute index form PCI function.
+ * @vsi: ptr to the VSI to read from.
+ * @hw: ptr to the hardware info.
+ **/
+static u32 i40e_compute_pci_to_hw_id(struct i40e_vsi *vsi, struct i40e_hw *hw)
+{
+	int pf_count = i40e_get_pf_count(hw);
+
+	if (vsi->type == I40E_VSI_SRIOV)
+		return (hw->port * BIT(7)) / pf_count + vsi->vf_id;
+
+	return hw->port + BIT(7);
+}
+
+/**
+ * i40e_stat_update64 - read and update a 64 bit stat from the chip.
+ * @hw: ptr to the hardware info.
+ * @hireg: the high 32 bit reg to read.
+ * @loreg: the low 32 bit reg to read.
+ * @offset_loaded: has the initial offset been loaded yet.
+ * @offset: ptr to current offset value.
+ * @stat: ptr to the stat.
+ *
+ * Since the device stats are not reset at PFReset, they will not
+ * be zeroed when the driver starts.  We'll save the first values read
+ * and use them as offsets to be subtracted from the raw values in order
+ * to report stats that count from zero.
+ **/
+static void i40e_stat_update64(struct i40e_hw *hw, u32 hireg, u32 loreg,
+			       bool offset_loaded, u64 *offset, u64 *stat)
+{
+	u64 new_data;
+
+	new_data = rd64(hw, loreg);
+
+	if (!offset_loaded || new_data < *offset)
+		*offset = new_data;
+	*stat = new_data - *offset;
+}
+
 /**
  * i40e_stat_update48 - read and update a 48 bit stat from the chip
  * @hw: ptr to the hardware info
@@ -620,6 +661,34 @@ static void i40e_stat_update_and_clear32(struct i40e_hw *hw, u32 reg, u64 *stat)
 	*stat += new_data;
 }
 
+/**
+ * i40e_stats_update_rx_discards - update rx_discards.
+ * @vsi: ptr to the VSI to be updated.
+ * @hw: ptr to the hardware info.
+ * @stat_idx: VSI's stat_counter_idx.
+ * @offset_loaded: ptr to the VSI's stat_offsets_loaded.
+ * @stat_offset: ptr to stat_offset to store first read of specific register.
+ * @stat: ptr to VSI's stat to be updated.
+ **/
+static void
+i40e_stats_update_rx_discards(struct i40e_vsi *vsi, struct i40e_hw *hw,
+			      int stat_idx, bool offset_loaded,
+			      struct i40e_eth_stats *stat_offset,
+			      struct i40e_eth_stats *stat)
+{
+	u64 rx_rdpc, rx_rxerr;
+
+	i40e_stat_update32(hw, I40E_GLV_RDPC(stat_idx), offset_loaded,
+			   &stat_offset->rx_discards, &rx_rdpc);
+	i40e_stat_update64(hw,
+			   I40E_GL_RXERR1H(i40e_compute_pci_to_hw_id(vsi, hw)),
+			   I40E_GL_RXERR1L(i40e_compute_pci_to_hw_id(vsi, hw)),
+			   offset_loaded, &stat_offset->rx_discards_other,
+			   &rx_rxerr);
+
+	stat->rx_discards = rx_rdpc + rx_rxerr;
+}
+
 /**
  * i40e_update_eth_stats - Update VSI-specific ethernet statistics counters.
  * @vsi: the VSI to be updated
@@ -679,6 +748,10 @@ void i40e_update_eth_stats(struct i40e_vsi *vsi)
 			   I40E_GLV_BPTCL(stat_idx),
 			   vsi->stat_offsets_loaded,
 			   &oes->tx_broadcast, &es->tx_broadcast);
+
+	i40e_stats_update_rx_discards(vsi, hw, stat_idx,
+				      vsi->stat_offsets_loaded, oes, es);
+
 	vsi->stat_offsets_loaded = true;
 }
 
diff --git a/drivers/net/ethernet/intel/i40e/i40e_register.h b/drivers/net/ethernet/intel/i40e/i40e_register.h
index 1908eed4fa5e..7339003aa17c 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_register.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_register.h
@@ -211,6 +211,11 @@
 #define I40E_GLGEN_MSRWD_MDIWRDATA_SHIFT 0
 #define I40E_GLGEN_MSRWD_MDIRDDATA_SHIFT 16
 #define I40E_GLGEN_MSRWD_MDIRDDATA_MASK I40E_MASK(0xFFFF, I40E_GLGEN_MSRWD_MDIRDDATA_SHIFT)
+#define I40E_GLGEN_PCIFCNCNT                0x001C0AB4 /* Reset: PCIR */
+#define I40E_GLGEN_PCIFCNCNT_PCIPFCNT_SHIFT 0
+#define I40E_GLGEN_PCIFCNCNT_PCIPFCNT_MASK  I40E_MASK(0x1F, I40E_GLGEN_PCIFCNCNT_PCIPFCNT_SHIFT)
+#define I40E_GLGEN_PCIFCNCNT_PCIVFCNT_SHIFT 16
+#define I40E_GLGEN_PCIFCNCNT_PCIVFCNT_MASK  I40E_MASK(0xFF, I40E_GLGEN_PCIFCNCNT_PCIVFCNT_SHIFT)
 #define I40E_GLGEN_RSTAT 0x000B8188 /* Reset: POR */
 #define I40E_GLGEN_RSTAT_DEVSTATE_SHIFT 0
 #define I40E_GLGEN_RSTAT_DEVSTATE_MASK I40E_MASK(0x3, I40E_GLGEN_RSTAT_DEVSTATE_SHIFT)
@@ -643,6 +648,14 @@
 #define I40E_VFQF_HKEY1_MAX_INDEX 12
 #define I40E_VFQF_HLUT1(_i, _VF) (0x00220000 + ((_i) * 1024 + (_VF) * 4)) /* _i=0...15, _VF=0...127 */ /* Reset: CORER */
 #define I40E_VFQF_HLUT1_MAX_INDEX 15
+#define I40E_GL_RXERR1H(_i)             (0x00318004 + ((_i) * 8)) /* _i=0...143 */ /* Reset: CORER */
+#define I40E_GL_RXERR1H_MAX_INDEX       143
+#define I40E_GL_RXERR1H_RXERR1H_SHIFT   0
+#define I40E_GL_RXERR1H_RXERR1H_MASK    I40E_MASK(0xFFFFFFFF, I40E_GL_RXERR1H_RXERR1H_SHIFT)
+#define I40E_GL_RXERR1L(_i)             (0x00318000 + ((_i) * 8)) /* _i=0...143 */ /* Reset: CORER */
+#define I40E_GL_RXERR1L_MAX_INDEX       143
+#define I40E_GL_RXERR1L_RXERR1L_SHIFT   0
+#define I40E_GL_RXERR1L_RXERR1L_MASK    I40E_MASK(0xFFFFFFFF, I40E_GL_RXERR1L_RXERR1L_SHIFT)
 #define I40E_GLPRT_BPRCH(_i) (0x003005E4 + ((_i) * 8)) /* _i=0...3 */ /* Reset: CORER */
 #define I40E_GLPRT_BPRCL(_i) (0x003005E0 + ((_i) * 8)) /* _i=0...3 */ /* Reset: CORER */
 #define I40E_GLPRT_BPTCH(_i) (0x00300A04 + ((_i) * 8)) /* _i=0...3 */ /* Reset: CORER */
diff --git a/drivers/net/ethernet/intel/i40e/i40e_type.h b/drivers/net/ethernet/intel/i40e/i40e_type.h
index 36a4ca1ffb1a..7b3f30beb757 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_type.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_type.h
@@ -1172,6 +1172,7 @@ struct i40e_eth_stats {
 	u64 tx_broadcast;		/* bptc */
 	u64 tx_discards;		/* tdpc */
 	u64 tx_errors;			/* tepc */
+	u64 rx_discards_other;          /* rxerr1 */
 };
 
 /* Statistics collected per VEB per TC */
diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 6c1e668f4ebf..d78ac5e7f658 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -2147,6 +2147,10 @@ static int i40e_vc_get_vf_resources_msg(struct i40e_vf *vf, u8 *msg)
 		/* VFs only use TC 0 */
 		vfres->vsi_res[0].qset_handle
 					  = le16_to_cpu(vsi->info.qs_handle[0]);
+		if (!(vf->driver_caps & VIRTCHNL_VF_OFFLOAD_USO) && !vf->pf_set_mac) {
+			i40e_del_mac_filter(vsi, vf->default_lan_addr.addr);
+			eth_zero_addr(vf->default_lan_addr.addr);
+		}
 		ether_addr_copy(vfres->vsi_res[0].default_mac_addr,
 				vf->default_lan_addr.addr);
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 3aa8d0b83d10..843c8435387f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3291,37 +3291,68 @@ static bool modify_header_match_supported(struct mlx5e_priv *priv,
 	return true;
 }
 
-static bool actions_match_supported(struct mlx5e_priv *priv,
-				    struct flow_action *flow_action,
-				    struct mlx5e_tc_flow_parse_attr *parse_attr,
-				    struct mlx5e_tc_flow *flow,
-				    struct netlink_ext_ack *extack)
+static bool
+actions_match_supported_fdb(struct mlx5e_priv *priv,
+			    struct mlx5e_tc_flow_parse_attr *parse_attr,
+			    struct mlx5e_tc_flow *flow,
+			    struct netlink_ext_ack *extack)
 {
-	bool ct_flow = false, ct_clear = false;
-	u32 actions;
+	bool ct_flow, ct_clear;
 
-	ct_clear = flow->attr->ct_attr.ct_action &
-		TCA_CT_ACT_CLEAR;
+	ct_clear = flow->attr->ct_attr.ct_action & TCA_CT_ACT_CLEAR;
 	ct_flow = flow_flag_test(flow, CT) && !ct_clear;
-	actions = flow->attr->action;
 
-	if (mlx5e_is_eswitch_flow(flow)) {
-		if (flow->attr->esw_attr->split_count && ct_flow &&
-		    !MLX5_CAP_GEN(flow->attr->esw_attr->in_mdev, reg_c_preserve)) {
-			/* All registers used by ct are cleared when using
-			 * split rules.
-			 */
-			NL_SET_ERR_MSG_MOD(extack,
-					   "Can't offload mirroring with action ct");
-			return false;
-		}
+	if (flow->attr->esw_attr->split_count && ct_flow &&
+	    !MLX5_CAP_GEN(flow->attr->esw_attr->in_mdev, reg_c_preserve)) {
+		/* All registers used by ct are cleared when using
+		 * split rules.
+		 */
+		NL_SET_ERR_MSG_MOD(extack, "Can't offload mirroring with action ct");
+		return false;
+	}
+
+	return true;
+}
+
+static bool
+actions_match_supported(struct mlx5e_priv *priv,
+			struct flow_action *flow_action,
+			struct mlx5e_tc_flow_parse_attr *parse_attr,
+			struct mlx5e_tc_flow *flow,
+			struct netlink_ext_ack *extack)
+{
+	u32 actions = flow->attr->action;
+	bool ct_flow, ct_clear;
+
+	ct_clear = flow->attr->ct_attr.ct_action & TCA_CT_ACT_CLEAR;
+	ct_flow = flow_flag_test(flow, CT) && !ct_clear;
+
+	if (!(actions &
+	      (MLX5_FLOW_CONTEXT_ACTION_FWD_DEST | MLX5_FLOW_CONTEXT_ACTION_DROP))) {
+		NL_SET_ERR_MSG_MOD(extack, "Rule must have at least one forward/drop action");
+		return false;
+	}
+
+	if (!(~actions &
+	      (MLX5_FLOW_CONTEXT_ACTION_FWD_DEST | MLX5_FLOW_CONTEXT_ACTION_DROP))) {
+		NL_SET_ERR_MSG_MOD(extack, "Rule cannot support forward+drop action");
+		return false;
 	}
 
-	if (actions & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR)
-		return modify_header_match_supported(priv, &parse_attr->spec,
-						     flow_action, actions,
-						     ct_flow, ct_clear,
-						     extack);
+	if (actions & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR &&
+	    actions & MLX5_FLOW_CONTEXT_ACTION_DROP) {
+		NL_SET_ERR_MSG_MOD(extack, "Drop with modify header action is not supported");
+		return false;
+	}
+
+	if (actions & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR &&
+	    !modify_header_match_supported(priv, &parse_attr->spec, flow_action,
+					   actions, ct_flow, ct_clear, extack))
+		return false;
+
+	if (mlx5e_is_eswitch_flow(flow) &&
+	    !actions_match_supported_fdb(priv, parse_attr, flow, extack))
+		return false;
 
 	return true;
 }
@@ -4207,13 +4238,6 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 		attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
 	}
 
-	if (!(attr->action &
-	      (MLX5_FLOW_CONTEXT_ACTION_FWD_DEST | MLX5_FLOW_CONTEXT_ACTION_DROP))) {
-		NL_SET_ERR_MSG_MOD(extack,
-				   "Rule must have at least one forward/drop action");
-		return -EOPNOTSUPP;
-	}
-
 	if (esw_attr->split_count > 0 && !mlx5_esw_has_fwd_fdb(priv->mdev)) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "current firmware doesn't support split rule for port mirroring");
diff --git a/drivers/net/ethernet/qlogic/qed/qed_l2.c b/drivers/net/ethernet/qlogic/qed/qed_l2.c
index dfaf10edfabf..ba8c7a31cce1 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_l2.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_l2.c
@@ -2763,25 +2763,6 @@ static int qed_configure_filter_mcast(struct qed_dev *cdev,
 	return qed_filter_mcast_cmd(cdev, &mcast, QED_SPQ_MODE_CB, NULL);
 }
 
-static int qed_configure_filter(struct qed_dev *cdev,
-				struct qed_filter_params *params)
-{
-	enum qed_filter_rx_mode_type accept_flags;
-
-	switch (params->type) {
-	case QED_FILTER_TYPE_UCAST:
-		return qed_configure_filter_ucast(cdev, &params->filter.ucast);
-	case QED_FILTER_TYPE_MCAST:
-		return qed_configure_filter_mcast(cdev, &params->filter.mcast);
-	case QED_FILTER_TYPE_RX_MODE:
-		accept_flags = params->filter.accept_flags;
-		return qed_configure_filter_rx_mode(cdev, accept_flags);
-	default:
-		DP_NOTICE(cdev, "Unknown filter type %d\n", (int)params->type);
-		return -EINVAL;
-	}
-}
-
 static int qed_configure_arfs_searcher(struct qed_dev *cdev,
 				       enum qed_filter_config_mode mode)
 {
@@ -2904,7 +2885,9 @@ static const struct qed_eth_ops qed_eth_ops_pass = {
 	.q_rx_stop = &qed_stop_rxq,
 	.q_tx_start = &qed_start_txq,
 	.q_tx_stop = &qed_stop_txq,
-	.filter_config = &qed_configure_filter,
+	.filter_config_rx_mode = &qed_configure_filter_rx_mode,
+	.filter_config_ucast = &qed_configure_filter_ucast,
+	.filter_config_mcast = &qed_configure_filter_mcast,
 	.fastpath_stop = &qed_fastpath_stop,
 	.eth_cqe_completion = &qed_fp_cqe_completion,
 	.get_vport_stats = &qed_get_vport_stats,
diff --git a/drivers/net/ethernet/qlogic/qede/qede_filter.c b/drivers/net/ethernet/qlogic/qede/qede_filter.c
index a2e4dfb5cb44..f99b085b56a5 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_filter.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_filter.c
@@ -619,30 +619,28 @@ static int qede_set_ucast_rx_mac(struct qede_dev *edev,
 				 enum qed_filter_xcast_params_type opcode,
 				 unsigned char mac[ETH_ALEN])
 {
-	struct qed_filter_params filter_cmd;
+	struct qed_filter_ucast_params ucast;
 
-	memset(&filter_cmd, 0, sizeof(filter_cmd));
-	filter_cmd.type = QED_FILTER_TYPE_UCAST;
-	filter_cmd.filter.ucast.type = opcode;
-	filter_cmd.filter.ucast.mac_valid = 1;
-	ether_addr_copy(filter_cmd.filter.ucast.mac, mac);
+	memset(&ucast, 0, sizeof(ucast));
+	ucast.type = opcode;
+	ucast.mac_valid = 1;
+	ether_addr_copy(ucast.mac, mac);
 
-	return edev->ops->filter_config(edev->cdev, &filter_cmd);
+	return edev->ops->filter_config_ucast(edev->cdev, &ucast);
 }
 
 static int qede_set_ucast_rx_vlan(struct qede_dev *edev,
 				  enum qed_filter_xcast_params_type opcode,
 				  u16 vid)
 {
-	struct qed_filter_params filter_cmd;
+	struct qed_filter_ucast_params ucast;
 
-	memset(&filter_cmd, 0, sizeof(filter_cmd));
-	filter_cmd.type = QED_FILTER_TYPE_UCAST;
-	filter_cmd.filter.ucast.type = opcode;
-	filter_cmd.filter.ucast.vlan_valid = 1;
-	filter_cmd.filter.ucast.vlan = vid;
+	memset(&ucast, 0, sizeof(ucast));
+	ucast.type = opcode;
+	ucast.vlan_valid = 1;
+	ucast.vlan = vid;
 
-	return edev->ops->filter_config(edev->cdev, &filter_cmd);
+	return edev->ops->filter_config_ucast(edev->cdev, &ucast);
 }
 
 static int qede_config_accept_any_vlan(struct qede_dev *edev, bool action)
@@ -1057,18 +1055,17 @@ static int qede_set_mcast_rx_mac(struct qede_dev *edev,
 				 enum qed_filter_xcast_params_type opcode,
 				 unsigned char *mac, int num_macs)
 {
-	struct qed_filter_params filter_cmd;
+	struct qed_filter_mcast_params mcast;
 	int i;
 
-	memset(&filter_cmd, 0, sizeof(filter_cmd));
-	filter_cmd.type = QED_FILTER_TYPE_MCAST;
-	filter_cmd.filter.mcast.type = opcode;
-	filter_cmd.filter.mcast.num = num_macs;
+	memset(&mcast, 0, sizeof(mcast));
+	mcast.type = opcode;
+	mcast.num = num_macs;
 
 	for (i = 0; i < num_macs; i++, mac += ETH_ALEN)
-		ether_addr_copy(filter_cmd.filter.mcast.mac[i], mac);
+		ether_addr_copy(mcast.mac[i], mac);
 
-	return edev->ops->filter_config(edev->cdev, &filter_cmd);
+	return edev->ops->filter_config_mcast(edev->cdev, &mcast);
 }
 
 int qede_set_mac_addr(struct net_device *ndev, void *p)
@@ -1194,7 +1191,6 @@ void qede_config_rx_mode(struct net_device *ndev)
 {
 	enum qed_filter_rx_mode_type accept_flags;
 	struct qede_dev *edev = netdev_priv(ndev);
-	struct qed_filter_params rx_mode;
 	unsigned char *uc_macs, *temp;
 	struct netdev_hw_addr *ha;
 	int rc, uc_count;
@@ -1220,10 +1216,6 @@ void qede_config_rx_mode(struct net_device *ndev)
 
 	netif_addr_unlock_bh(ndev);
 
-	/* Configure the struct for the Rx mode */
-	memset(&rx_mode, 0, sizeof(struct qed_filter_params));
-	rx_mode.type = QED_FILTER_TYPE_RX_MODE;
-
 	/* Remove all previous unicast secondary macs and multicast macs
 	 * (configure / leave the primary mac)
 	 */
@@ -1271,8 +1263,7 @@ void qede_config_rx_mode(struct net_device *ndev)
 		qede_config_accept_any_vlan(edev, false);
 	}
 
-	rx_mode.filter.accept_flags = accept_flags;
-	edev->ops->filter_config(edev->cdev, &rx_mode);
+	edev->ops->filter_config_rx_mode(edev->cdev, accept_flags);
 out:
 	kfree(uc_macs);
 }
diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 2918947dd57c..2af4c76bcf02 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4177,7 +4177,6 @@ static void rtl8169_tso_csum_v1(struct sk_buff *skb, u32 *opts)
 static bool rtl8169_tso_csum_v2(struct rtl8169_private *tp,
 				struct sk_buff *skb, u32 *opts)
 {
-	u32 transport_offset = (u32)skb_transport_offset(skb);
 	struct skb_shared_info *shinfo = skb_shinfo(skb);
 	u32 mss = shinfo->gso_size;
 
@@ -4194,7 +4193,7 @@ static bool rtl8169_tso_csum_v2(struct rtl8169_private *tp,
 			WARN_ON_ONCE(1);
 		}
 
-		opts[0] |= transport_offset << GTTCPHO_SHIFT;
+		opts[0] |= skb_transport_offset(skb) << GTTCPHO_SHIFT;
 		opts[1] |= mss << TD1_MSS_SHIFT;
 	} else if (skb->ip_summed == CHECKSUM_PARTIAL) {
 		u8 ip_protocol;
@@ -4222,7 +4221,7 @@ static bool rtl8169_tso_csum_v2(struct rtl8169_private *tp,
 		else
 			WARN_ON_ONCE(1);
 
-		opts[1] |= transport_offset << TCPHO_SHIFT;
+		opts[1] |= skb_transport_offset(skb) << TCPHO_SHIFT;
 	} else {
 		unsigned int padto = rtl_quirk_packet_padto(tp, skb);
 
@@ -4389,14 +4388,13 @@ static netdev_features_t rtl8169_features_check(struct sk_buff *skb,
 						struct net_device *dev,
 						netdev_features_t features)
 {
-	int transport_offset = skb_transport_offset(skb);
 	struct rtl8169_private *tp = netdev_priv(dev);
 
 	if (skb_is_gso(skb)) {
 		if (tp->mac_version == RTL_GIGA_MAC_VER_34)
 			features = rtl8168evl_fix_tso(skb, features);
 
-		if (transport_offset > GTTCPHO_MAX &&
+		if (skb_transport_offset(skb) > GTTCPHO_MAX &&
 		    rtl_chip_supports_csum_v2(tp))
 			features &= ~NETIF_F_ALL_TSO;
 	} else if (skb->ip_summed == CHECKSUM_PARTIAL) {
@@ -4407,7 +4405,7 @@ static netdev_features_t rtl8169_features_check(struct sk_buff *skb,
 		if (rtl_quirk_packet_padto(tp, skb))
 			features &= ~NETIF_F_CSUM_MASK;
 
-		if (transport_offset > TCPHO_MAX &&
+		if (skb_transport_offset(skb) > TCPHO_MAX &&
 		    rtl_chip_supports_csum_v2(tp))
 			features &= ~NETIF_F_CSUM_MASK;
 	}
diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index a0ea236ac60e..71bb0849ce48 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -2135,7 +2135,7 @@ static void usbnet_async_cmd_cb(struct urb *urb)
 int usbnet_write_cmd_async(struct usbnet *dev, u8 cmd, u8 reqtype,
 			   u16 value, u16 index, const void *data, u16 size)
 {
-	struct usb_ctrlrequest *req = NULL;
+	struct usb_ctrlrequest *req;
 	struct urb *urb;
 	int err = -ENOMEM;
 	void *buf = NULL;
@@ -2153,7 +2153,7 @@ int usbnet_write_cmd_async(struct usbnet *dev, u8 cmd, u8 reqtype,
 		if (!buf) {
 			netdev_err(dev->net, "Error allocating buffer"
 				   " in %s!\n", __func__);
-			goto fail_free;
+			goto fail_free_urb;
 		}
 	}
 
@@ -2177,14 +2177,21 @@ int usbnet_write_cmd_async(struct usbnet *dev, u8 cmd, u8 reqtype,
 	if (err < 0) {
 		netdev_err(dev->net, "Error submitting the control"
 			   " message: status=%d\n", err);
-		goto fail_free;
+		goto fail_free_all;
 	}
 	return 0;
 
+fail_free_all:
+	kfree(req);
 fail_free_buf:
 	kfree(buf);
-fail_free:
-	kfree(req);
+	/*
+	 * avoid a double free
+	 * needed because the flag can be set only
+	 * after filling the URB
+	 */
+	urb->transfer_flags = 0;
+fail_free_urb:
 	usb_free_urb(urb);
 fail:
 	return err;
diff --git a/drivers/net/wireless/ath/ath11k/core.c b/drivers/net/wireless/ath/ath11k/core.c
index 7dcf6b13f794..48b4151e13a3 100644
--- a/drivers/net/wireless/ath/ath11k/core.c
+++ b/drivers/net/wireless/ath/ath11k/core.c
@@ -71,6 +71,7 @@ static const struct ath11k_hw_params ath11k_hw_params[] = {
 		.supports_suspend = false,
 		.hal_desc_sz = sizeof(struct hal_rx_desc_ipq8074),
 		.fix_l1ss = true,
+		.wakeup_mhi = false,
 	},
 	{
 		.hw_rev = ATH11K_HW_IPQ6018_HW10,
@@ -112,6 +113,7 @@ static const struct ath11k_hw_params ath11k_hw_params[] = {
 		.supports_suspend = false,
 		.hal_desc_sz = sizeof(struct hal_rx_desc_ipq8074),
 		.fix_l1ss = true,
+		.wakeup_mhi = false,
 	},
 	{
 		.name = "qca6390 hw2.0",
@@ -152,6 +154,7 @@ static const struct ath11k_hw_params ath11k_hw_params[] = {
 		.supports_suspend = true,
 		.hal_desc_sz = sizeof(struct hal_rx_desc_ipq8074),
 		.fix_l1ss = true,
+		.wakeup_mhi = true,
 	},
 	{
 		.name = "qcn9074 hw1.0",
@@ -190,6 +193,7 @@ static const struct ath11k_hw_params ath11k_hw_params[] = {
 		.supports_suspend = false,
 		.hal_desc_sz = sizeof(struct hal_rx_desc_qcn9074),
 		.fix_l1ss = true,
+		.wakeup_mhi = false,
 	},
 	{
 		.name = "wcn6855 hw2.0",
@@ -230,6 +234,7 @@ static const struct ath11k_hw_params ath11k_hw_params[] = {
 		.supports_suspend = true,
 		.hal_desc_sz = sizeof(struct hal_rx_desc_wcn6855),
 		.fix_l1ss = false,
+		.wakeup_mhi = true,
 	},
 };
 
diff --git a/drivers/net/wireless/ath/ath11k/hw.h b/drivers/net/wireless/ath/ath11k/hw.h
index 62f5978b3005..4fe051625edf 100644
--- a/drivers/net/wireless/ath/ath11k/hw.h
+++ b/drivers/net/wireless/ath/ath11k/hw.h
@@ -163,6 +163,7 @@ struct ath11k_hw_params {
 	bool supports_suspend;
 	u32 hal_desc_sz;
 	bool fix_l1ss;
+	bool wakeup_mhi;
 };
 
 struct ath11k_hw_ops {
diff --git a/drivers/net/wireless/ath/ath11k/pci.c b/drivers/net/wireless/ath/ath11k/pci.c
index 353a2d669fcd..7d0be9388f89 100644
--- a/drivers/net/wireless/ath/ath11k/pci.c
+++ b/drivers/net/wireless/ath/ath11k/pci.c
@@ -182,7 +182,8 @@ void ath11k_pci_write32(struct ath11k_base *ab, u32 offset, u32 value)
 	/* for offset beyond BAR + 4K - 32, may
 	 * need to wakeup MHI to access.
 	 */
-	if (test_bit(ATH11K_PCI_FLAG_INIT_DONE, &ab_pci->flags) &&
+	if (ab->hw_params.wakeup_mhi &&
+	    test_bit(ATH11K_PCI_FLAG_INIT_DONE, &ab_pci->flags) &&
 	    offset >= ACCESS_ALWAYS_OFF)
 		mhi_device_get_sync(ab_pci->mhi_ctrl->mhi_dev);
 
@@ -206,7 +207,8 @@ void ath11k_pci_write32(struct ath11k_base *ab, u32 offset, u32 value)
 		}
 	}
 
-	if (test_bit(ATH11K_PCI_FLAG_INIT_DONE, &ab_pci->flags) &&
+	if (ab->hw_params.wakeup_mhi &&
+	    test_bit(ATH11K_PCI_FLAG_INIT_DONE, &ab_pci->flags) &&
 	    offset >= ACCESS_ALWAYS_OFF)
 		mhi_device_put(ab_pci->mhi_ctrl->mhi_dev);
 }
@@ -219,7 +221,8 @@ u32 ath11k_pci_read32(struct ath11k_base *ab, u32 offset)
 	/* for offset beyond BAR + 4K - 32, may
 	 * need to wakeup MHI to access.
 	 */
-	if (test_bit(ATH11K_PCI_FLAG_INIT_DONE, &ab_pci->flags) &&
+	if (ab->hw_params.wakeup_mhi &&
+	    test_bit(ATH11K_PCI_FLAG_INIT_DONE, &ab_pci->flags) &&
 	    offset >= ACCESS_ALWAYS_OFF)
 		mhi_device_get_sync(ab_pci->mhi_ctrl->mhi_dev);
 
@@ -243,7 +246,8 @@ u32 ath11k_pci_read32(struct ath11k_base *ab, u32 offset)
 		}
 	}
 
-	if (test_bit(ATH11K_PCI_FLAG_INIT_DONE, &ab_pci->flags) &&
+	if (ab->hw_params.wakeup_mhi &&
+	    test_bit(ATH11K_PCI_FLAG_INIT_DONE, &ab_pci->flags) &&
 	    offset >= ACCESS_ALWAYS_OFF)
 		mhi_device_put(ab_pci->mhi_ctrl->mhi_dev);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c
index af43bcb54578..306e9eaea917 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c
@@ -7,9 +7,6 @@ int mt76_connac_pm_wake(struct mt76_phy *phy, struct mt76_connac_pm *pm)
 {
 	struct mt76_dev *dev = phy->dev;
 
-	if (!pm->enable)
-		return 0;
-
 	if (mt76_is_usb(dev))
 		return 0;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
index 77d4435e4581..72a70a7046fb 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
@@ -556,7 +556,7 @@ enum {
 	MCU_CMD_SET_BSS_CONNECTED = MCU_CE_PREFIX | 0x16,
 	MCU_CMD_SET_BSS_ABORT = MCU_CE_PREFIX | 0x17,
 	MCU_CMD_CANCEL_HW_SCAN = MCU_CE_PREFIX | 0x1b,
-	MCU_CMD_SET_ROC = MCU_CE_PREFIX | 0x1d,
+	MCU_CMD_SET_ROC = MCU_CE_PREFIX | 0x1c,
 	MCU_CMD_SET_P2P_OPPPS = MCU_CE_PREFIX | 0x33,
 	MCU_CMD_SET_RATE_TX_POWER = MCU_CE_PREFIX | 0x5d,
 	MCU_CMD_SCHED_SCAN_ENABLE = MCU_CE_PREFIX | 0x61,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c
index 8d5e261cd10f..cfcf7964c688 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c
@@ -262,31 +262,44 @@ mt7921_txpwr(struct seq_file *s, void *data)
 	return 0;
 }
 
+static void
+mt7921_pm_interface_iter(void *priv, u8 *mac, struct ieee80211_vif *vif)
+{
+	struct mt7921_dev *dev = priv;
+
+	mt7921_mcu_set_beacon_filter(dev, vif, dev->pm.enable);
+}
+
 static int
 mt7921_pm_set(void *data, u64 val)
 {
 	struct mt7921_dev *dev = data;
 	struct mt76_connac_pm *pm = &dev->pm;
-	struct mt76_phy *mphy = dev->phy.mt76;
 
-	if (val == pm->enable)
-		return 0;
+	mutex_lock(&dev->mt76.mutex);
 
-	mt7921_mutex_acquire(dev);
+	if (val == pm->enable)
+		goto out;
 
 	if (!pm->enable) {
 		pm->stats.last_wake_event = jiffies;
 		pm->stats.last_doze_event = jiffies;
 	}
-	pm->enable = val;
+	/* make sure the chip is awake here and ps_work is scheduled
+	 * just at end of the this routine.
+	 */
+	pm->enable = false;
+	mt76_connac_pm_wake(&dev->mphy, pm);
 
-	ieee80211_iterate_active_interfaces(mphy->hw,
+	pm->enable = val;
+	ieee80211_iterate_active_interfaces(mt76_hw(dev),
 					    IEEE80211_IFACE_ITER_RESUME_ALL,
-					    mt7921_pm_interface_iter, mphy->priv);
+					    mt7921_pm_interface_iter, dev);
 
 	mt76_connac_mcu_set_deep_sleep(&dev->mt76, pm->ds_enable);
-
-	mt7921_mutex_release(dev);
+	mt76_connac_power_save_sched(&dev->mphy, pm);
+out:
+	mutex_unlock(&dev->mt76.mutex);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
index bef8d4a76ed9..426e7a32bdc8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
@@ -1573,34 +1573,6 @@ void mt7921_pm_power_save_work(struct work_struct *work)
 	queue_delayed_work(dev->mt76.wq, &dev->pm.ps_work, delta);
 }
 
-int mt7921_mac_set_beacon_filter(struct mt7921_phy *phy,
-				 struct ieee80211_vif *vif,
-				 bool enable)
-{
-	struct mt7921_dev *dev = phy->dev;
-	bool ext_phy = phy != &dev->phy;
-	int err;
-
-	if (!dev->pm.enable)
-		return -EOPNOTSUPP;
-
-	err = mt7921_mcu_set_bss_pm(dev, vif, enable);
-	if (err)
-		return err;
-
-	if (enable) {
-		vif->driver_flags |= IEEE80211_VIF_BEACON_FILTER;
-		mt76_set(dev, MT_WF_RFCR(ext_phy),
-			 MT_WF_RFCR_DROP_OTHER_BEACON);
-	} else {
-		vif->driver_flags &= ~IEEE80211_VIF_BEACON_FILTER;
-		mt76_clear(dev, MT_WF_RFCR(ext_phy),
-			   MT_WF_RFCR_DROP_OTHER_BEACON);
-	}
-
-	return 0;
-}
-
 void mt7921_coredump_work(struct work_struct *work)
 {
 	struct mt7921_dev *dev;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
index 30252f408ddc..13a7ae3d8351 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -528,36 +528,6 @@ static void mt7921_configure_filter(struct ieee80211_hw *hw,
 	mt7921_mutex_release(dev);
 }
 
-static int
-mt7921_bss_bcnft_apply(struct mt7921_dev *dev, struct ieee80211_vif *vif,
-		       bool assoc)
-{
-	int ret;
-
-	if (!dev->pm.enable)
-		return 0;
-
-	if (assoc) {
-		ret = mt7921_mcu_uni_bss_bcnft(dev, vif, true);
-		if (ret)
-			return ret;
-
-		vif->driver_flags |= IEEE80211_VIF_BEACON_FILTER;
-		mt76_set(dev, MT_WF_RFCR(0), MT_WF_RFCR_DROP_OTHER_BEACON);
-
-		return 0;
-	}
-
-	ret = mt7921_mcu_set_bss_pm(dev, vif, false);
-	if (ret)
-		return ret;
-
-	vif->driver_flags &= ~IEEE80211_VIF_BEACON_FILTER;
-	mt76_clear(dev, MT_WF_RFCR(0), MT_WF_RFCR_DROP_OTHER_BEACON);
-
-	return 0;
-}
-
 static void mt7921_bss_info_changed(struct ieee80211_hw *hw,
 				    struct ieee80211_vif *vif,
 				    struct ieee80211_bss_conf *info,
@@ -587,7 +557,8 @@ static void mt7921_bss_info_changed(struct ieee80211_hw *hw,
 	if (changed & BSS_CHANGED_ASSOC) {
 		mt7921_mcu_sta_update(dev, NULL, vif, true,
 				      MT76_STA_INFO_STATE_ASSOC);
-		mt7921_bss_bcnft_apply(dev, vif, info->assoc);
+		if (dev->pm.enable)
+			mt7921_mcu_set_beacon_filter(dev, vif, info->assoc);
 	}
 
 	if (changed & BSS_CHANGED_ARP_FILTER) {
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
index 4119f8efd896..dabc0de2ec65 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -1205,8 +1205,9 @@ int mt7921_mcu_uni_bss_ps(struct mt7921_dev *dev, struct ieee80211_vif *vif)
 				 &ps_req, sizeof(ps_req), true);
 }
 
-int mt7921_mcu_uni_bss_bcnft(struct mt7921_dev *dev, struct ieee80211_vif *vif,
-			     bool enable)
+static int
+mt7921_mcu_uni_bss_bcnft(struct mt7921_dev *dev, struct ieee80211_vif *vif,
+			 bool enable)
 {
 	struct mt7921_vif *mvif = (struct mt7921_vif *)vif->drv_priv;
 	struct {
@@ -1240,8 +1241,9 @@ int mt7921_mcu_uni_bss_bcnft(struct mt7921_dev *dev, struct ieee80211_vif *vif,
 				 &bcnft_req, sizeof(bcnft_req), true);
 }
 
-int mt7921_mcu_set_bss_pm(struct mt7921_dev *dev, struct ieee80211_vif *vif,
-			  bool enable)
+static int
+mt7921_mcu_set_bss_pm(struct mt7921_dev *dev, struct ieee80211_vif *vif,
+		      bool enable)
 {
 	struct mt7921_vif *mvif = (struct mt7921_vif *)vif->drv_priv;
 	struct {
@@ -1390,31 +1392,34 @@ int mt7921_mcu_fw_pmctrl(struct mt7921_dev *dev)
 	return err;
 }
 
-void
-mt7921_pm_interface_iter(void *priv, u8 *mac, struct ieee80211_vif *vif)
+int mt7921_mcu_set_beacon_filter(struct mt7921_dev *dev,
+				 struct ieee80211_vif *vif,
+				 bool enable)
 {
-	struct mt7921_phy *phy = priv;
-	struct mt7921_dev *dev = phy->dev;
 	struct ieee80211_hw *hw = mt76_hw(dev);
-	int ret;
-
-	if (dev->pm.enable)
-		ret = mt7921_mcu_uni_bss_bcnft(dev, vif, true);
-	else
-		ret = mt7921_mcu_set_bss_pm(dev, vif, false);
+	int err;
 
-	if (ret)
-		return;
+	if (enable) {
+		err = mt7921_mcu_uni_bss_bcnft(dev, vif, true);
+		if (err)
+			return err;
 
-	if (dev->pm.enable) {
 		vif->driver_flags |= IEEE80211_VIF_BEACON_FILTER;
 		ieee80211_hw_set(hw, CONNECTION_MONITOR);
 		mt76_set(dev, MT_WF_RFCR(0), MT_WF_RFCR_DROP_OTHER_BEACON);
-	} else {
-		vif->driver_flags &= ~IEEE80211_VIF_BEACON_FILTER;
-		__clear_bit(IEEE80211_HW_CONNECTION_MONITOR, hw->flags);
-		mt76_clear(dev, MT_WF_RFCR(0), MT_WF_RFCR_DROP_OTHER_BEACON);
+
+		return 0;
 	}
+
+	err = mt7921_mcu_set_bss_pm(dev, vif, false);
+	if (err)
+		return err;
+
+	vif->driver_flags &= ~IEEE80211_VIF_BEACON_FILTER;
+	__clear_bit(IEEE80211_HW_CONNECTION_MONITOR, hw->flags);
+	mt76_clear(dev, MT_WF_RFCR(0), MT_WF_RFCR_DROP_OTHER_BEACON);
+
+	return 0;
 }
 
 int mt7921_get_txpwr_info(struct mt7921_dev *dev, struct mt7921_txpwr *txpwr)
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h b/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
index 2d8bd6bfc820..32d4f2cab94e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
@@ -363,6 +363,9 @@ void mt7921_set_stream_he_caps(struct mt7921_phy *phy);
 void mt7921_update_channel(struct mt76_phy *mphy);
 int mt7921_init_debugfs(struct mt7921_dev *dev);
 
+int mt7921_mcu_set_beacon_filter(struct mt7921_dev *dev,
+				 struct ieee80211_vif *vif,
+				 bool enable);
 int mt7921_mcu_uni_tx_ba(struct mt7921_dev *dev,
 			 struct ieee80211_ampdu_params *params,
 			 bool enable);
@@ -371,20 +374,12 @@ int mt7921_mcu_uni_rx_ba(struct mt7921_dev *dev,
 			 bool enable);
 void mt7921_scan_work(struct work_struct *work);
 int mt7921_mcu_uni_bss_ps(struct mt7921_dev *dev, struct ieee80211_vif *vif);
-int mt7921_mcu_uni_bss_bcnft(struct mt7921_dev *dev, struct ieee80211_vif *vif,
-			     bool enable);
-int mt7921_mcu_set_bss_pm(struct mt7921_dev *dev, struct ieee80211_vif *vif,
-			  bool enable);
 int __mt7921_mcu_drv_pmctrl(struct mt7921_dev *dev);
 int mt7921_mcu_drv_pmctrl(struct mt7921_dev *dev);
 int mt7921_mcu_fw_pmctrl(struct mt7921_dev *dev);
 void mt7921_pm_wake_work(struct work_struct *work);
 void mt7921_pm_power_save_work(struct work_struct *work);
 bool mt7921_wait_for_mcu_init(struct mt7921_dev *dev);
-int mt7921_mac_set_beacon_filter(struct mt7921_phy *phy,
-				 struct ieee80211_vif *vif,
-				 bool enable);
-void mt7921_pm_interface_iter(void *priv, u8 *mac, struct ieee80211_vif *vif);
 void mt7921_coredump_work(struct work_struct *work);
 int mt7921_wfsys_reset(struct mt7921_dev *dev);
 int mt7921_get_txpwr_info(struct mt7921_dev *dev, struct mt7921_txpwr *txpwr);
diff --git a/drivers/pci/hotplug/pciehp.h b/drivers/pci/hotplug/pciehp.h
index 10d7e7e1b553..e0a614acee05 100644
--- a/drivers/pci/hotplug/pciehp.h
+++ b/drivers/pci/hotplug/pciehp.h
@@ -192,6 +192,8 @@ int pciehp_get_attention_status(struct hotplug_slot *hotplug_slot, u8 *status);
 int pciehp_set_raw_indicator_status(struct hotplug_slot *h_slot, u8 status);
 int pciehp_get_raw_indicator_status(struct hotplug_slot *h_slot, u8 *status);
 
+int pciehp_slot_reset(struct pcie_device *dev);
+
 static inline const char *slot_name(struct controller *ctrl)
 {
 	return hotplug_slot_name(&ctrl->hotplug_slot);
diff --git a/drivers/pci/hotplug/pciehp_core.c b/drivers/pci/hotplug/pciehp_core.c
index e7fe4b42f039..4042d87d539d 100644
--- a/drivers/pci/hotplug/pciehp_core.c
+++ b/drivers/pci/hotplug/pciehp_core.c
@@ -351,6 +351,8 @@ static struct pcie_port_service_driver hpdriver_portdrv = {
 	.runtime_suspend = pciehp_runtime_suspend,
 	.runtime_resume	= pciehp_runtime_resume,
 #endif	/* PM */
+
+	.slot_reset	= pciehp_slot_reset,
 };
 
 int __init pcie_hp_init(void)
diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
index 8bedbc77fe95..60098a701e83 100644
--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -865,6 +865,32 @@ void pcie_disable_interrupt(struct controller *ctrl)
 	pcie_write_cmd(ctrl, 0, mask);
 }
 
+/**
+ * pciehp_slot_reset() - ignore link event caused by error-induced hot reset
+ * @dev: PCI Express port service device
+ *
+ * Called from pcie_portdrv_slot_reset() after AER or DPC initiated a reset
+ * further up in the hierarchy to recover from an error.  The reset was
+ * propagated down to this hotplug port.  Ignore the resulting link flap.
+ * If the link failed to retrain successfully, synthesize the ignored event.
+ * Surprise removal during reset is detected through Presence Detect Changed.
+ */
+int pciehp_slot_reset(struct pcie_device *dev)
+{
+	struct controller *ctrl = get_service_data(dev);
+
+	if (ctrl->state != ON_STATE)
+		return 0;
+
+	pcie_capability_write_word(dev->port, PCI_EXP_SLTSTA,
+				   PCI_EXP_SLTSTA_DLLSC);
+
+	if (!pciehp_check_link_active(ctrl))
+		pciehp_request(ctrl, PCI_EXP_SLTSTA_DLLSC);
+
+	return 0;
+}
+
 /*
  * pciehp has a 1:1 bus:slot relationship so we ultimately want a secondary
  * bus reset of the bridge, but at the same time we want to ensure that it is
diff --git a/drivers/pci/pcie/portdrv.h b/drivers/pci/pcie/portdrv.h
index 2ff5724b8f13..41fe1ffd5907 100644
--- a/drivers/pci/pcie/portdrv.h
+++ b/drivers/pci/pcie/portdrv.h
@@ -85,6 +85,8 @@ struct pcie_port_service_driver {
 	int (*runtime_suspend)(struct pcie_device *dev);
 	int (*runtime_resume)(struct pcie_device *dev);
 
+	int (*slot_reset)(struct pcie_device *dev);
+
 	/* Device driver may resume normal operations */
 	void (*error_resume)(struct pci_dev *dev);
 
@@ -110,6 +112,7 @@ void pcie_port_service_unregister(struct pcie_port_service_driver *new);
 
 extern struct bus_type pcie_port_bus_type;
 int pcie_port_device_register(struct pci_dev *dev);
+int pcie_port_device_iter(struct device *dev, void *data);
 #ifdef CONFIG_PM
 int pcie_port_device_suspend(struct device *dev);
 int pcie_port_device_resume_noirq(struct device *dev);
diff --git a/drivers/pci/pcie/portdrv_core.c b/drivers/pci/pcie/portdrv_core.c
index 3ee63968deaa..604feeb84ee4 100644
--- a/drivers/pci/pcie/portdrv_core.c
+++ b/drivers/pci/pcie/portdrv_core.c
@@ -367,24 +367,24 @@ int pcie_port_device_register(struct pci_dev *dev)
 	return status;
 }
 
-#ifdef CONFIG_PM
-typedef int (*pcie_pm_callback_t)(struct pcie_device *);
+typedef int (*pcie_callback_t)(struct pcie_device *);
 
-static int pm_iter(struct device *dev, void *data)
+int pcie_port_device_iter(struct device *dev, void *data)
 {
 	struct pcie_port_service_driver *service_driver;
 	size_t offset = *(size_t *)data;
-	pcie_pm_callback_t cb;
+	pcie_callback_t cb;
 
 	if ((dev->bus == &pcie_port_bus_type) && dev->driver) {
 		service_driver = to_service_driver(dev->driver);
-		cb = *(pcie_pm_callback_t *)((void *)service_driver + offset);
+		cb = *(pcie_callback_t *)((void *)service_driver + offset);
 		if (cb)
 			return cb(to_pcie_device(dev));
 	}
 	return 0;
 }
 
+#ifdef CONFIG_PM
 /**
  * pcie_port_device_suspend - suspend port services associated with a PCIe port
  * @dev: PCI Express port to handle
@@ -392,13 +392,13 @@ static int pm_iter(struct device *dev, void *data)
 int pcie_port_device_suspend(struct device *dev)
 {
 	size_t off = offsetof(struct pcie_port_service_driver, suspend);
-	return device_for_each_child(dev, &off, pm_iter);
+	return device_for_each_child(dev, &off, pcie_port_device_iter);
 }
 
 int pcie_port_device_resume_noirq(struct device *dev)
 {
 	size_t off = offsetof(struct pcie_port_service_driver, resume_noirq);
-	return device_for_each_child(dev, &off, pm_iter);
+	return device_for_each_child(dev, &off, pcie_port_device_iter);
 }
 
 /**
@@ -408,7 +408,7 @@ int pcie_port_device_resume_noirq(struct device *dev)
 int pcie_port_device_resume(struct device *dev)
 {
 	size_t off = offsetof(struct pcie_port_service_driver, resume);
-	return device_for_each_child(dev, &off, pm_iter);
+	return device_for_each_child(dev, &off, pcie_port_device_iter);
 }
 
 /**
@@ -418,7 +418,7 @@ int pcie_port_device_resume(struct device *dev)
 int pcie_port_device_runtime_suspend(struct device *dev)
 {
 	size_t off = offsetof(struct pcie_port_service_driver, runtime_suspend);
-	return device_for_each_child(dev, &off, pm_iter);
+	return device_for_each_child(dev, &off, pcie_port_device_iter);
 }
 
 /**
@@ -428,7 +428,7 @@ int pcie_port_device_runtime_suspend(struct device *dev)
 int pcie_port_device_runtime_resume(struct device *dev)
 {
 	size_t off = offsetof(struct pcie_port_service_driver, runtime_resume);
-	return device_for_each_child(dev, &off, pm_iter);
+	return device_for_each_child(dev, &off, pcie_port_device_iter);
 }
 #endif /* PM */
 
diff --git a/drivers/pci/pcie/portdrv_pci.c b/drivers/pci/pcie/portdrv_pci.c
index c7ff1eea225a..1af74c3d9d5d 100644
--- a/drivers/pci/pcie/portdrv_pci.c
+++ b/drivers/pci/pcie/portdrv_pci.c
@@ -160,6 +160,9 @@ static pci_ers_result_t pcie_portdrv_error_detected(struct pci_dev *dev,
 
 static pci_ers_result_t pcie_portdrv_slot_reset(struct pci_dev *dev)
 {
+	size_t off = offsetof(struct pcie_port_service_driver, slot_reset);
+	device_for_each_child(&dev->dev, &off, pcie_port_device_iter);
+
 	pci_restore_state(dev);
 	pci_save_state(dev);
 	return PCI_ERS_RESULT_RECOVERED;
diff --git a/drivers/pinctrl/sunxi/pinctrl-sun8i-a83t.c b/drivers/pinctrl/sunxi/pinctrl-sun8i-a83t.c
index 4ada80317a3b..b5c1a8f363f3 100644
--- a/drivers/pinctrl/sunxi/pinctrl-sun8i-a83t.c
+++ b/drivers/pinctrl/sunxi/pinctrl-sun8i-a83t.c
@@ -158,26 +158,26 @@ static const struct sunxi_desc_pin sun8i_a83t_pins[] = {
 	SUNXI_PIN(SUNXI_PINCTRL_PIN(C, 14),
 		  SUNXI_FUNCTION(0x0, "gpio_in"),
 		  SUNXI_FUNCTION(0x1, "gpio_out"),
-		  SUNXI_FUNCTION(0x2, "nand"),		/* DQ6 */
+		  SUNXI_FUNCTION(0x2, "nand0"),		/* DQ6 */
 		  SUNXI_FUNCTION(0x3, "mmc2")),		/* D6 */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN(C, 15),
 		  SUNXI_FUNCTION(0x0, "gpio_in"),
 		  SUNXI_FUNCTION(0x1, "gpio_out"),
-		  SUNXI_FUNCTION(0x2, "nand"),		/* DQ7 */
+		  SUNXI_FUNCTION(0x2, "nand0"),		/* DQ7 */
 		  SUNXI_FUNCTION(0x3, "mmc2")),		/* D7 */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN(C, 16),
 		  SUNXI_FUNCTION(0x0, "gpio_in"),
 		  SUNXI_FUNCTION(0x1, "gpio_out"),
-		  SUNXI_FUNCTION(0x2, "nand"),		/* DQS */
+		  SUNXI_FUNCTION(0x2, "nand0"),		/* DQS */
 		  SUNXI_FUNCTION(0x3, "mmc2")),		/* RST */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN(C, 17),
 		  SUNXI_FUNCTION(0x0, "gpio_in"),
 		  SUNXI_FUNCTION(0x1, "gpio_out"),
-		  SUNXI_FUNCTION(0x2, "nand")),		/* CE2 */
+		  SUNXI_FUNCTION(0x2, "nand0")),	/* CE2 */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN(C, 18),
 		  SUNXI_FUNCTION(0x0, "gpio_in"),
 		  SUNXI_FUNCTION(0x1, "gpio_out"),
-		  SUNXI_FUNCTION(0x2, "nand")),		/* CE3 */
+		  SUNXI_FUNCTION(0x2, "nand0")),	/* CE3 */
 	/* Hole */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN(D, 2),
 		  SUNXI_FUNCTION(0x0, "gpio_in"),
diff --git a/drivers/pinctrl/sunxi/pinctrl-sunxi.c b/drivers/pinctrl/sunxi/pinctrl-sunxi.c
index ce3f9ea41511..1431ab21aca6 100644
--- a/drivers/pinctrl/sunxi/pinctrl-sunxi.c
+++ b/drivers/pinctrl/sunxi/pinctrl-sunxi.c
@@ -544,6 +544,8 @@ static int sunxi_pconf_set(struct pinctrl_dev *pctldev, unsigned pin,
 	struct sunxi_pinctrl *pctl = pinctrl_dev_get_drvdata(pctldev);
 	int i;
 
+	pin -= pctl->desc->pin_base;
+
 	for (i = 0; i < num_configs; i++) {
 		enum pin_config_param param;
 		unsigned long flags;
diff --git a/drivers/platform/x86/wmi.c b/drivers/platform/x86/wmi.c
index 1b65bb61ce88..c4f917d45b51 100644
--- a/drivers/platform/x86/wmi.c
+++ b/drivers/platform/x86/wmi.c
@@ -51,6 +51,11 @@ struct guid_block {
 	u8 flags;
 };
 
+enum {	/* wmi_block flags */
+	WMI_READ_TAKES_NO_ARGS,
+	WMI_PROBED,
+};
+
 struct wmi_block {
 	struct wmi_device dev;
 	struct list_head list;
@@ -61,8 +66,7 @@ struct wmi_block {
 	wmi_notify_handler handler;
 	void *handler_data;
 	u64 req_buf_size;
-
-	bool read_takes_no_args;
+	unsigned long flags;
 };
 
 
@@ -325,7 +329,7 @@ static acpi_status __query_block(struct wmi_block *wblock, u8 instance,
 	wq_params[0].type = ACPI_TYPE_INTEGER;
 	wq_params[0].integer.value = instance;
 
-	if (instance == 0 && wblock->read_takes_no_args)
+	if (instance == 0 && test_bit(WMI_READ_TAKES_NO_ARGS, &wblock->flags))
 		input.count = 0;
 
 	/*
@@ -676,6 +680,11 @@ static struct wmi_device *dev_to_wdev(struct device *dev)
 	return container_of(dev, struct wmi_device, dev);
 }
 
+static inline struct wmi_driver *drv_to_wdrv(struct device_driver *drv)
+{
+	return container_of(drv, struct wmi_driver, driver);
+}
+
 /*
  * sysfs interface
  */
@@ -794,8 +803,7 @@ static void wmi_dev_release(struct device *dev)
 
 static int wmi_dev_match(struct device *dev, struct device_driver *driver)
 {
-	struct wmi_driver *wmi_driver =
-		container_of(driver, struct wmi_driver, driver);
+	struct wmi_driver *wmi_driver = drv_to_wdrv(driver);
 	struct wmi_block *wblock = dev_to_wblock(dev);
 	const struct wmi_device_id *id = wmi_driver->id_table;
 
@@ -892,8 +900,7 @@ static long wmi_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	}
 
 	/* let the driver do any filtering and do the call */
-	wdriver = container_of(wblock->dev.dev.driver,
-			       struct wmi_driver, driver);
+	wdriver = drv_to_wdrv(wblock->dev.dev.driver);
 	if (!try_module_get(wdriver->driver.owner)) {
 		ret = -EBUSY;
 		goto out_ioctl;
@@ -926,8 +933,7 @@ static const struct file_operations wmi_fops = {
 static int wmi_dev_probe(struct device *dev)
 {
 	struct wmi_block *wblock = dev_to_wblock(dev);
-	struct wmi_driver *wdriver =
-		container_of(dev->driver, struct wmi_driver, driver);
+	struct wmi_driver *wdriver = drv_to_wdrv(dev->driver);
 	int ret = 0;
 	char *buf;
 
@@ -975,6 +981,7 @@ static int wmi_dev_probe(struct device *dev)
 		}
 	}
 
+	set_bit(WMI_PROBED, &wblock->flags);
 	return 0;
 
 probe_misc_failure:
@@ -990,8 +997,9 @@ static int wmi_dev_probe(struct device *dev)
 static void wmi_dev_remove(struct device *dev)
 {
 	struct wmi_block *wblock = dev_to_wblock(dev);
-	struct wmi_driver *wdriver =
-		container_of(dev->driver, struct wmi_driver, driver);
+	struct wmi_driver *wdriver = drv_to_wdrv(dev->driver);
+
+	clear_bit(WMI_PROBED, &wblock->flags);
 
 	if (wdriver->filter_callback) {
 		misc_deregister(&wblock->char_dev);
@@ -1086,7 +1094,7 @@ static int wmi_create_device(struct device *wmi_bus_dev,
 	 * laptops, WQxx may not be a method at all.)
 	 */
 	if (info->type != ACPI_TYPE_METHOD || info->param_count == 0)
-		wblock->read_takes_no_args = true;
+		set_bit(WMI_READ_TAKES_NO_ARGS, &wblock->flags);
 
 	kfree(info);
 
@@ -1295,16 +1303,13 @@ static void acpi_wmi_notify_handler(acpi_handle handle, u32 event,
 		return;
 
 	/* If a driver is bound, then notify the driver. */
-	if (wblock->dev.dev.driver) {
-		struct wmi_driver *driver;
+	if (test_bit(WMI_PROBED, &wblock->flags) && wblock->dev.dev.driver) {
+		struct wmi_driver *driver = drv_to_wdrv(wblock->dev.dev.driver);
 		struct acpi_object_list input;
 		union acpi_object params[1];
 		struct acpi_buffer evdata = { ACPI_ALLOCATE_BUFFER, NULL };
 		acpi_status status;
 
-		driver = container_of(wblock->dev.dev.driver,
-				      struct wmi_driver, driver);
-
 		input.count = 1;
 		input.pointer = params;
 		params[0].type = ACPI_TYPE_INTEGER;
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 2ea35e47ea44..303ad60d1d49 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3759,6 +3759,7 @@ struct qla_qpair {
 	struct qla_fw_resources fwres ____cacheline_aligned;
 	u32	cmd_cnt;
 	u32	cmd_completion_cnt;
+	u32	prev_completion_cnt;
 };
 
 /* Place holder for FW buffer parameters */
@@ -4618,7 +4619,9 @@ struct qla_hw_data {
 	struct qla_chip_state_84xx *cs84xx;
 	struct isp_operations *isp_ops;
 	struct workqueue_struct *wq;
+	struct work_struct heartbeat_work;
 	struct qlfc_fw fw_buf;
+	unsigned long last_heartbeat_run_jiffies;
 
 	/* FCP_CMND priority support */
 	struct qla_fcp_prio_cfg *fcp_prio_cfg;
@@ -4719,7 +4722,6 @@ struct qla_hw_data {
 
 	struct qla_hw_data_stat stat;
 	pci_error_state_t pci_error_state;
-	u64 prev_cmd_cnt;
 	struct dma_pool *purex_dma_pool;
 	struct btree_head32 host_map;
 
@@ -4865,7 +4867,6 @@ typedef struct scsi_qla_host {
 #define SET_ZIO_THRESHOLD_NEEDED 32
 #define ISP_ABORT_TO_ROM	33
 #define VPORT_DELETE		34
-#define HEARTBEAT_CHK		38
 
 #define PROCESS_PUREX_IOCB	63
 
diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index a00fe88c6021..e40b9cc38214 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -1684,41 +1684,25 @@ static struct enode *
 qla_enode_find(scsi_qla_host_t *vha, uint32_t ntype, uint32_t p1, uint32_t p2)
 {
 	struct enode		*node_rtn = NULL;
-	struct enode		*list_node = NULL;
+	struct enode		*list_node, *q;
 	unsigned long		flags;
-	struct list_head	*pos, *q;
 	uint32_t		sid;
-	uint32_t		rw_flag;
 	struct purexevent	*purex;
 
 	/* secure the list from moving under us */
 	spin_lock_irqsave(&vha->pur_cinfo.pur_lock, flags);
 
-	list_for_each_safe(pos, q, &vha->pur_cinfo.head) {
-		list_node = list_entry(pos, struct enode, list);
+	list_for_each_entry_safe(list_node, q, &vha->pur_cinfo.head, list) {
 
 		/* node type determines what p1 and p2 are */
 		purex = &list_node->u.purexinfo;
 		sid = p1;
-		rw_flag = p2;
 
 		if (purex->pur_info.pur_sid.b24 == sid) {
-			if (purex->pur_info.pur_pend == 1 &&
-			    rw_flag == PUR_GET) {
-				/*
-				 * if the receive is in progress
-				 * and its a read/get then can't
-				 * transfer yet
-				 */
-				ql_dbg(ql_dbg_edif, vha, 0x9106,
-				    "%s purex xfer in progress for sid=%x\n",
-				    __func__, sid);
-			} else {
-				/* found it and its complete */
-				node_rtn = list_node;
-				list_del(pos);
-				break;
-			}
+			/* found it and its complete */
+			node_rtn = list_node;
+			list_del(&list_node->list);
+			break;
 		}
 	}
 
@@ -2428,7 +2412,6 @@ void qla24xx_auth_els(scsi_qla_host_t *vha, void **pkt, struct rsp_que **rsp)
 
 	purex = &ptr->u.purexinfo;
 	purex->pur_info.pur_sid = a.did;
-	purex->pur_info.pur_pend = 0;
 	purex->pur_info.pur_bytes_rcvd = totlen;
 	purex->pur_info.pur_rx_xchg_address = le32_to_cpu(p->rx_xchg_addr);
 	purex->pur_info.pur_nphdl = le16_to_cpu(p->nport_handle);
@@ -3180,18 +3163,14 @@ static uint16_t qla_edif_sadb_get_sa_index(fc_port_t *fcport,
 /* release any sadb entries -- only done at teardown */
 void qla_edif_sadb_release(struct qla_hw_data *ha)
 {
-	struct list_head *pos;
-	struct list_head *tmp;
-	struct edif_sa_index_entry *entry;
+	struct edif_sa_index_entry *entry, *tmp;
 
-	list_for_each_safe(pos, tmp, &ha->sadb_rx_index_list) {
-		entry = list_entry(pos, struct edif_sa_index_entry, next);
+	list_for_each_entry_safe(entry, tmp, &ha->sadb_rx_index_list, next) {
 		list_del(&entry->next);
 		kfree(entry);
 	}
 
-	list_for_each_safe(pos, tmp, &ha->sadb_tx_index_list) {
-		entry = list_entry(pos, struct edif_sa_index_entry, next);
+	list_for_each_entry_safe(entry, tmp, &ha->sadb_tx_index_list, next) {
 		list_del(&entry->next);
 		kfree(entry);
 	}
diff --git a/drivers/scsi/qla2xxx/qla_edif.h b/drivers/scsi/qla2xxx/qla_edif.h
index 45cf87e33778..32800bfb32a3 100644
--- a/drivers/scsi/qla2xxx/qla_edif.h
+++ b/drivers/scsi/qla2xxx/qla_edif.h
@@ -101,7 +101,6 @@ struct dinfo {
 };
 
 struct pur_ninfo {
-	unsigned int	pur_pend:1;
 	port_id_t       pur_sid;
 	port_id_t	pur_did;
 	uint8_t		vp_idx;
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index af8df5a800c6..c3ba2995209b 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -7096,12 +7096,14 @@ qla2x00_abort_isp_cleanup(scsi_qla_host_t *vha)
 	ha->chip_reset++;
 	ha->base_qpair->chip_reset = ha->chip_reset;
 	ha->base_qpair->cmd_cnt = ha->base_qpair->cmd_completion_cnt = 0;
+	ha->base_qpair->prev_completion_cnt = 0;
 	for (i = 0; i < ha->max_qpairs; i++) {
 		if (ha->queue_pair_map[i]) {
 			ha->queue_pair_map[i]->chip_reset =
 				ha->base_qpair->chip_reset;
 			ha->queue_pair_map[i]->cmd_cnt =
 			    ha->queue_pair_map[i]->cmd_completion_cnt = 0;
+			ha->base_qpair->prev_completion_cnt = 0;
 		}
 	}
 
diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 42b29f4fd937..1bf3ab10846a 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -775,7 +775,6 @@ int qla_nvme_register_hba(struct scsi_qla_host *vha)
 	ha = vha->hw;
 	tmpl = &qla_nvme_fc_transport;
 
-	WARN_ON(vha->nvme_local_port);
 
 	qla_nvme_fc_transport.max_hw_queues =
 	    min((uint8_t)(qla_nvme_fc_transport.max_hw_queues),
@@ -786,13 +785,25 @@ int qla_nvme_register_hba(struct scsi_qla_host *vha)
 	pinfo.port_role = FC_PORT_ROLE_NVME_INITIATOR;
 	pinfo.port_id = vha->d_id.b24;
 
-	ql_log(ql_log_info, vha, 0xffff,
-	    "register_localport: host-traddr=nn-0x%llx:pn-0x%llx on portID:%x\n",
-	    pinfo.node_name, pinfo.port_name, pinfo.port_id);
-	qla_nvme_fc_transport.dma_boundary = vha->host->dma_boundary;
-
-	ret = nvme_fc_register_localport(&pinfo, tmpl,
-	    get_device(&ha->pdev->dev), &vha->nvme_local_port);
+	mutex_lock(&ha->vport_lock);
+	/*
+	 * Check again for nvme_local_port to see if any other thread raced
+	 * with this one and finished registration.
+	 */
+	if (!vha->nvme_local_port) {
+		ql_log(ql_log_info, vha, 0xffff,
+		    "register_localport: host-traddr=nn-0x%llx:pn-0x%llx on portID:%x\n",
+		    pinfo.node_name, pinfo.port_name, pinfo.port_id);
+		qla_nvme_fc_transport.dma_boundary = vha->host->dma_boundary;
+
+		ret = nvme_fc_register_localport(&pinfo, tmpl,
+						 get_device(&ha->pdev->dev),
+						 &vha->nvme_local_port);
+		mutex_unlock(&ha->vport_lock);
+	} else {
+		mutex_unlock(&ha->vport_lock);
+		return 0;
+	}
 	if (ret) {
 		ql_log(ql_log_warn, vha, 0xffff,
 		    "register_localport failed: ret=%x\n", ret);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 77c0bf06f162..e683b1c01c9f 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2779,6 +2779,16 @@ qla2xxx_scan_finished(struct Scsi_Host *shost, unsigned long time)
 	return atomic_read(&vha->loop_state) == LOOP_READY;
 }
 
+static void qla_heartbeat_work_fn(struct work_struct *work)
+{
+	struct qla_hw_data *ha = container_of(work,
+		struct qla_hw_data, heartbeat_work);
+	struct scsi_qla_host *base_vha = pci_get_drvdata(ha->pdev);
+
+	if (!ha->flags.mbox_busy && base_vha->flags.init_done)
+		qla_no_op_mb(base_vha);
+}
+
 static void qla2x00_iocb_work_fn(struct work_struct *work)
 {
 	struct scsi_qla_host *vha = container_of(work,
@@ -3217,6 +3227,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	    host->transportt, sht->vendor_id);
 
 	INIT_WORK(&base_vha->iocb_work, qla2x00_iocb_work_fn);
+	INIT_WORK(&ha->heartbeat_work, qla_heartbeat_work_fn);
 
 	/* Set up the irqs */
 	ret = qla2x00_request_irqs(ha, rsp);
@@ -3875,13 +3886,15 @@ qla2x00_remove_one(struct pci_dev *pdev)
 static inline void
 qla24xx_free_purex_list(struct purex_list *list)
 {
-	struct list_head *item, *next;
+	struct purex_item *item, *next;
 	ulong flags;
 
 	spin_lock_irqsave(&list->lock, flags);
-	list_for_each_safe(item, next, &list->head) {
-		list_del(item);
-		kfree(list_entry(item, struct purex_item, list));
+	list_for_each_entry_safe(item, next, &list->head, list) {
+		list_del(&item->list);
+		if (item == &item->vha->default_item)
+			continue;
+		kfree(item);
 	}
 	spin_unlock_irqrestore(&list->lock, flags);
 }
@@ -7103,17 +7116,6 @@ qla2x00_do_dpc(void *data)
 			qla2x00_lip_reset(base_vha);
 		}
 
-		if (test_bit(HEARTBEAT_CHK, &base_vha->dpc_flags)) {
-			/*
-			 * if there is a mb in progress then that's
-			 * enough of a check to see if fw is still ticking.
-			 */
-			if (!ha->flags.mbox_busy && base_vha->flags.init_done)
-				qla_no_op_mb(base_vha);
-
-			clear_bit(HEARTBEAT_CHK, &base_vha->dpc_flags);
-		}
-
 		ha->dpc_active = 0;
 end_loop:
 		set_current_state(TASK_INTERRUPTIBLE);
@@ -7172,56 +7174,61 @@ qla2x00_rst_aen(scsi_qla_host_t *vha)
 
 static bool qla_do_heartbeat(struct scsi_qla_host *vha)
 {
-	u64 cmd_cnt, prev_cmd_cnt;
-	bool do_hb = false;
 	struct qla_hw_data *ha = vha->hw;
-	int i;
+	u32 cmpl_cnt;
+	u16 i;
+	bool do_heartbeat = false;
 
-	/* if cmds are still pending down in fw, then do hb */
-	if (ha->base_qpair->cmd_cnt != ha->base_qpair->cmd_completion_cnt) {
-		do_hb = true;
+	/*
+	 * Allow do_heartbeat only if we don’t have any active interrupts,
+	 * but there are still IOs outstanding with firmware.
+	 */
+	cmpl_cnt = ha->base_qpair->cmd_completion_cnt;
+	if (cmpl_cnt == ha->base_qpair->prev_completion_cnt &&
+	    cmpl_cnt != ha->base_qpair->cmd_cnt) {
+		do_heartbeat = true;
 		goto skip;
 	}
+	ha->base_qpair->prev_completion_cnt = cmpl_cnt;
 
 	for (i = 0; i < ha->max_qpairs; i++) {
-		if (ha->queue_pair_map[i] &&
-		    ha->queue_pair_map[i]->cmd_cnt !=
-		    ha->queue_pair_map[i]->cmd_completion_cnt) {
-			do_hb = true;
-			break;
+		if (ha->queue_pair_map[i]) {
+			cmpl_cnt = ha->queue_pair_map[i]->cmd_completion_cnt;
+			if (cmpl_cnt == ha->queue_pair_map[i]->prev_completion_cnt &&
+			    cmpl_cnt != ha->queue_pair_map[i]->cmd_cnt) {
+				do_heartbeat = true;
+				break;
+			}
+			ha->queue_pair_map[i]->prev_completion_cnt = cmpl_cnt;
 		}
 	}
 
 skip:
-	prev_cmd_cnt = ha->prev_cmd_cnt;
-	cmd_cnt = ha->base_qpair->cmd_cnt;
-	for (i = 0; i < ha->max_qpairs; i++) {
-		if (ha->queue_pair_map[i])
-			cmd_cnt += ha->queue_pair_map[i]->cmd_cnt;
-	}
-	ha->prev_cmd_cnt = cmd_cnt;
-
-	if (!do_hb && ((cmd_cnt - prev_cmd_cnt) > 50))
-		/*
-		 * IOs are completing before periodic hb check.
-		 * IOs seems to be running, do hb for sanity check.
-		 */
-		do_hb = true;
-
-	return do_hb;
+	return do_heartbeat;
 }
 
-static void qla_heart_beat(struct scsi_qla_host *vha)
+static void qla_heart_beat(struct scsi_qla_host *vha, u16 dpc_started)
 {
+	struct qla_hw_data *ha = vha->hw;
+
 	if (vha->vp_idx)
 		return;
 
 	if (vha->hw->flags.eeh_busy || qla2x00_chip_is_down(vha))
 		return;
 
+	/*
+	 * dpc thread cannot run if heartbeat is running at the same time.
+	 * We also do not want to starve heartbeat task. Therefore, do
+	 * heartbeat task at least once every 5 seconds.
+	 */
+	if (dpc_started &&
+	    time_before(jiffies, ha->last_heartbeat_run_jiffies + 5 * HZ))
+		return;
+
 	if (qla_do_heartbeat(vha)) {
-		set_bit(HEARTBEAT_CHK, &vha->dpc_flags);
-		qla2xxx_wake_dpc(vha);
+		ha->last_heartbeat_run_jiffies = jiffies;
+		queue_work(ha->wq, &ha->heartbeat_work);
 	}
 }
 
@@ -7413,6 +7420,8 @@ qla2x00_timer(struct timer_list *t)
 		start_dpc++;
 	}
 
+	/* borrowing w to signify dpc will run */
+	w = 0;
 	/* Schedule the DPC routine if needed */
 	if ((test_bit(ISP_ABORT_NEEDED, &vha->dpc_flags) ||
 	    test_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags) ||
@@ -7445,9 +7454,10 @@ qla2x00_timer(struct timer_list *t)
 		    test_bit(RELOGIN_NEEDED, &vha->dpc_flags),
 		    test_bit(PROCESS_PUREX_IOCB, &vha->dpc_flags));
 		qla2xxx_wake_dpc(vha);
+		w = 1;
 	}
 
-	qla_heart_beat(vha);
+	qla_heart_beat(vha, w);
 
 	qla2x00_restart_timer(vha, WATCH_INTERVAL);
 }
diff --git a/drivers/soc/atmel/soc.c b/drivers/soc/atmel/soc.c
index a490ad7e090f..9e3d37011447 100644
--- a/drivers/soc/atmel/soc.c
+++ b/drivers/soc/atmel/soc.c
@@ -91,14 +91,14 @@ static const struct at91_soc socs[] __initconst = {
 	AT91_SOC(SAM9X60_CIDR_MATCH, AT91_CIDR_MATCH_MASK,
 		 AT91_CIDR_VERSION_MASK, SAM9X60_EXID_MATCH,
 		 "sam9x60", "sam9x60"),
-	AT91_SOC(SAM9X60_CIDR_MATCH, SAM9X60_D5M_EXID_MATCH,
-		 AT91_CIDR_VERSION_MASK, SAM9X60_EXID_MATCH,
+	AT91_SOC(SAM9X60_CIDR_MATCH, AT91_CIDR_MATCH_MASK,
+		 AT91_CIDR_VERSION_MASK, SAM9X60_D5M_EXID_MATCH,
 		 "sam9x60 64MiB DDR2 SiP", "sam9x60"),
-	AT91_SOC(SAM9X60_CIDR_MATCH, SAM9X60_D1G_EXID_MATCH,
-		 AT91_CIDR_VERSION_MASK, SAM9X60_EXID_MATCH,
+	AT91_SOC(SAM9X60_CIDR_MATCH, AT91_CIDR_MATCH_MASK,
+		 AT91_CIDR_VERSION_MASK, SAM9X60_D1G_EXID_MATCH,
 		 "sam9x60 128MiB DDR2 SiP", "sam9x60"),
-	AT91_SOC(SAM9X60_CIDR_MATCH, SAM9X60_D6K_EXID_MATCH,
-		 AT91_CIDR_VERSION_MASK, SAM9X60_EXID_MATCH,
+	AT91_SOC(SAM9X60_CIDR_MATCH, AT91_CIDR_MATCH_MASK,
+		 AT91_CIDR_VERSION_MASK, SAM9X60_D6K_EXID_MATCH,
 		 "sam9x60 8MiB SDRAM SiP", "sam9x60"),
 #endif
 #ifdef CONFIG_SOC_SAMA5
diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 6734ef22c304..4946a241e323 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -137,6 +137,7 @@ struct gsm_dlci {
 	int retries;
 	/* Uplink tty if active */
 	struct tty_port port;	/* The tty bound to this DLCI if there is one */
+#define TX_SIZE		4096    /* Must be power of 2. */
 	struct kfifo fifo;	/* Queue fifo for the DLCI */
 	int adaption;		/* Adaption layer in use */
 	int prev_adaption;
@@ -221,7 +222,6 @@ struct gsm_mux {
 	int encoding;
 	u8 control;
 	u8 fcs;
-	u8 received_fcs;
 	u8 *txframe;			/* TX framing buffer */
 
 	/* Method for the receiver side */
@@ -274,6 +274,10 @@ static DEFINE_SPINLOCK(gsm_mux_lock);
 
 static struct tty_driver *gsm_tty_driver;
 
+/* Save dlci open address */
+static int addr_open[256] = { 0 };
+/* Save dlci open count */
+static int addr_cnt;
 /*
  *	This section of the driver logic implements the GSM encodings
  *	both the basic and the 'advanced'. Reliable transport is not
@@ -368,6 +372,7 @@ static const u8 gsm_fcs8[256] = {
 #define GOOD_FCS	0xCF
 
 static int gsmld_output(struct gsm_mux *gsm, u8 *data, int len);
+static int gsm_modem_update(struct gsm_dlci *dlci, u8 brk);
 
 /**
  *	gsm_fcs_add	-	update FCS
@@ -466,7 +471,7 @@ static void gsm_hex_dump_bytes(const char *fname, const u8 *data,
  *	gsm_print_packet	-	display a frame for debug
  *	@hdr: header to print before decode
  *	@addr: address EA from the frame
- *	@cr: C/R bit from the frame
+ *	@cr: C/R bit seen as initiator
  *	@control: control including PF bit
  *	@data: following data bytes
  *	@dlen: length of data
@@ -566,7 +571,7 @@ static int gsm_stuff_frame(const u8 *input, u8 *output, int len)
  *	gsm_send	-	send a control frame
  *	@gsm: our GSM mux
  *	@addr: address for control frame
- *	@cr: command/response bit
+ *	@cr: command/response bit seen as initiator
  *	@control:  control byte including PF bit
  *
  *	Format up and transmit a control frame. These do not go via the
@@ -581,11 +586,15 @@ static void gsm_send(struct gsm_mux *gsm, int addr, int cr, int control)
 	int len;
 	u8 cbuf[10];
 	u8 ibuf[3];
+	int ocr;
+
+	/* toggle C/R coding if not initiator */
+	ocr = cr ^ (gsm->initiator ? 0 : 1);
 
 	switch (gsm->encoding) {
 	case 0:
 		cbuf[0] = GSM0_SOF;
-		cbuf[1] = (addr << 2) | (cr << 1) | EA;
+		cbuf[1] = (addr << 2) | (ocr << 1) | EA;
 		cbuf[2] = control;
 		cbuf[3] = EA;	/* Length of data = 0 */
 		cbuf[4] = 0xFF - gsm_fcs_add_block(INIT_FCS, cbuf + 1, 3);
@@ -595,7 +604,7 @@ static void gsm_send(struct gsm_mux *gsm, int addr, int cr, int control)
 	case 1:
 	case 2:
 		/* Control frame + packing (but not frame stuffing) in mode 1 */
-		ibuf[0] = (addr << 2) | (cr << 1) | EA;
+		ibuf[0] = (addr << 2) | (ocr << 1) | EA;
 		ibuf[1] = control;
 		ibuf[2] = 0xFF - gsm_fcs_add_block(INIT_FCS, ibuf, 2);
 		/* Stuffing may double the size worst case */
@@ -924,6 +933,66 @@ static int gsm_dlci_data_output_framed(struct gsm_mux *gsm,
 	return size;
 }
 
+/**
+ *	gsm_dlci_modem_output	-	try and push modem status out of a DLCI
+ *	@gsm: mux
+ *	@dlci: the DLCI to pull modem status from
+ *	@brk: break signal
+ *
+ *	Push an empty frame in to the transmit queue to update the modem status
+ *	bits and to transmit an optional break.
+ *
+ *	Caller must hold the tx_lock of the mux.
+ */
+
+static int gsm_dlci_modem_output(struct gsm_mux *gsm, struct gsm_dlci *dlci,
+				 u8 brk)
+{
+	u8 *dp = NULL;
+	struct gsm_msg *msg;
+	int size = 0;
+
+	/* for modem bits without break data */
+	switch (dlci->adaption) {
+	case 1: /* Unstructured */
+		break;
+	case 2: /* Unstructured with modem bits. */
+		size++;
+		if (brk > 0)
+			size++;
+		break;
+	default:
+		pr_err("%s: unsupported adaption %d\n", __func__,
+		       dlci->adaption);
+		return -EINVAL;
+	}
+
+	msg = gsm_data_alloc(gsm, dlci->addr, size, gsm->ftype);
+	if (!msg) {
+		pr_err("%s: gsm_data_alloc error", __func__);
+		return -ENOMEM;
+	}
+	dp = msg->data;
+	switch (dlci->adaption) {
+	case 1: /* Unstructured */
+		break;
+	case 2: /* Unstructured with modem bits. */
+		if (brk == 0) {
+			*dp++ = (gsm_encode_modem(dlci) << 1) | EA;
+		} else {
+			*dp++ = gsm_encode_modem(dlci) << 1;
+			*dp++ = (brk << 4) | 2 | EA; /* Length, Break, EA */
+		}
+		break;
+	default:
+		/* Handled above */
+		break;
+	}
+
+	__gsm_data_queue(dlci, msg);
+	return size;
+}
+
 /**
  *	gsm_dlci_data_sweep		-	look for data to send
  *	@gsm: the GSM mux
@@ -1191,6 +1260,7 @@ static void gsm_control_rls(struct gsm_mux *gsm, const u8 *data, int clen)
 }
 
 static void gsm_dlci_begin_close(struct gsm_dlci *dlci);
+static void gsm_dlci_close(struct gsm_dlci *dlci);
 
 /**
  *	gsm_control_message	-	DLCI 0 control processing
@@ -1209,15 +1279,28 @@ static void gsm_control_message(struct gsm_mux *gsm, unsigned int command,
 {
 	u8 buf[1];
 	unsigned long flags;
+	struct gsm_dlci *dlci;
+	int i;
+	int address;
 
 	switch (command) {
 	case CMD_CLD: {
-		struct gsm_dlci *dlci = gsm->dlci[0];
+		if (addr_cnt > 0) {
+			for (i = 0; i < addr_cnt; i++) {
+				address = addr_open[i];
+				dlci = gsm->dlci[address];
+				gsm_dlci_close(dlci);
+				addr_open[i] = 0;
+			}
+		}
 		/* Modem wishes to close down */
+		dlci = gsm->dlci[0];
 		if (dlci) {
 			dlci->dead = true;
 			gsm->dead = true;
-			gsm_dlci_begin_close(dlci);
+			gsm_dlci_close(dlci);
+			addr_cnt = 0;
+			gsm_response(gsm, 0, UA|PF);
 		}
 		}
 		break;
@@ -1472,6 +1555,9 @@ static void gsm_dlci_open(struct gsm_dlci *dlci)
 	dlci->state = DLCI_OPEN;
 	if (debug & 8)
 		pr_debug("DLCI %d goes open.\n", dlci->addr);
+	/* Send current modem state */
+	if (dlci->addr)
+		gsm_modem_update(dlci, 0);
 	wake_up(&dlci->gsm->event);
 }
 
@@ -1677,7 +1763,7 @@ static struct gsm_dlci *gsm_dlci_alloc(struct gsm_mux *gsm, int addr)
 		return NULL;
 	spin_lock_init(&dlci->lock);
 	mutex_init(&dlci->mutex);
-	if (kfifo_alloc(&dlci->fifo, 4096, GFP_KERNEL) < 0) {
+	if (kfifo_alloc(&dlci->fifo, TX_SIZE, GFP_KERNEL) < 0) {
 		kfree(dlci);
 		return NULL;
 	}
@@ -1780,18 +1866,8 @@ static void gsm_queue(struct gsm_mux *gsm)
 	struct gsm_dlci *dlci;
 	u8 cr;
 	int address;
-	/* We have to sneak a look at the packet body to do the FCS.
-	   A somewhat layering violation in the spec */
+	int i, j, k, address_tmp;
 
-	if ((gsm->control & ~PF) == UI)
-		gsm->fcs = gsm_fcs_add_block(gsm->fcs, gsm->buf, gsm->len);
-	if (gsm->encoding == 0) {
-		/* WARNING: gsm->received_fcs is used for
-		gsm->encoding = 0 only.
-		In this case it contain the last piece of data
-		required to generate final CRC */
-		gsm->fcs = gsm_fcs_add(gsm->fcs, gsm->received_fcs);
-	}
 	if (gsm->fcs != GOOD_FCS) {
 		gsm->bad_fcs++;
 		if (debug & 4)
@@ -1803,10 +1879,10 @@ static void gsm_queue(struct gsm_mux *gsm)
 		goto invalid;
 
 	cr = gsm->address & 1;		/* C/R bit */
+	cr ^= gsm->initiator ? 0 : 1;	/* Flip so 1 always means command */
 
 	gsm_print_packet("<--", address, cr, gsm->control, gsm->buf, gsm->len);
 
-	cr ^= 1 - gsm->initiator;	/* Flip so 1 always means command */
 	dlci = gsm->dlci[address];
 
 	switch (gsm->control) {
@@ -1818,22 +1894,52 @@ static void gsm_queue(struct gsm_mux *gsm)
 		if (dlci == NULL)
 			return;
 		if (dlci->dead)
-			gsm_response(gsm, address, DM);
+			gsm_response(gsm, address, DM|PF);
 		else {
-			gsm_response(gsm, address, UA);
+			gsm_response(gsm, address, UA|PF);
 			gsm_dlci_open(dlci);
+			/* Save dlci open address */
+			if (address) {
+				addr_open[addr_cnt] = address;
+				addr_cnt++;
+			}
 		}
 		break;
 	case DISC|PF:
 		if (cr == 0)
 			goto invalid;
 		if (dlci == NULL || dlci->state == DLCI_CLOSED) {
-			gsm_response(gsm, address, DM);
+			gsm_response(gsm, address, DM|PF);
 			return;
 		}
 		/* Real close complete */
-		gsm_response(gsm, address, UA);
-		gsm_dlci_close(dlci);
+		if (!address) {
+			if (addr_cnt > 0) {
+				for (i = 0; i < addr_cnt; i++) {
+					address = addr_open[i];
+					dlci = gsm->dlci[address];
+					gsm_dlci_close(dlci);
+					addr_open[i] = 0;
+				}
+			}
+			dlci = gsm->dlci[0];
+			gsm_dlci_close(dlci);
+			addr_cnt = 0;
+			gsm_response(gsm, 0, UA|PF);
+		} else {
+			gsm_response(gsm, address, UA|PF);
+			gsm_dlci_close(dlci);
+			/* clear dlci address */
+			for (j = 0; j < addr_cnt; j++) {
+				address_tmp = addr_open[j];
+				if (address_tmp == address) {
+					for (k = j; k < addr_cnt; k++)
+						addr_open[k] = addr_open[k+1];
+				addr_cnt--;
+				break;
+				}
+			}
+		}
 		break;
 	case UA|PF:
 		if (cr == 0 || dlci == NULL)
@@ -1948,19 +2054,25 @@ static void gsm0_receive(struct gsm_mux *gsm, unsigned char c)
 		break;
 	case GSM_DATA:		/* Data */
 		gsm->buf[gsm->count++] = c;
-		if (gsm->count == gsm->len)
+		if (gsm->count == gsm->len) {
+			/* Calculate final FCS for UI frames over all data */
+			if ((gsm->control & ~PF) != UIH) {
+				gsm->fcs = gsm_fcs_add_block(gsm->fcs, gsm->buf,
+							     gsm->count);
+			}
 			gsm->state = GSM_FCS;
+		}
 		break;
 	case GSM_FCS:		/* FCS follows the packet */
-		gsm->received_fcs = c;
-		gsm_queue(gsm);
+		gsm->fcs = gsm_fcs_add(gsm->fcs, c);
 		gsm->state = GSM_SSOF;
 		break;
 	case GSM_SSOF:
-		if (c == GSM0_SOF) {
-			gsm->state = GSM_SEARCH;
-			break;
-		}
+		gsm->state = GSM_SEARCH;
+		if (c == GSM0_SOF)
+			gsm_queue(gsm);
+		else
+			gsm->bad_size++;
 		break;
 	default:
 		pr_debug("%s: unhandled state: %d\n", __func__, gsm->state);
@@ -1989,11 +2101,24 @@ static void gsm1_receive(struct gsm_mux *gsm, unsigned char c)
 		return;
 	}
 	if (c == GSM1_SOF) {
-		/* EOF is only valid in frame if we have got to the data state
-		   and received at least one byte (the FCS) */
-		if (gsm->state == GSM_DATA && gsm->count) {
-			/* Extract the FCS */
+		/* EOF is only valid in frame if we have got to the data state */
+		if (gsm->state == GSM_DATA) {
+			if (gsm->count < 1) {
+				/* Missing FSC */
+				gsm->malformed++;
+				gsm->state = GSM_START;
+				return;
+			}
+			/* Remove the FCS from data */
 			gsm->count--;
+			if ((gsm->control & ~PF) != UIH) {
+				/* Calculate final FCS for UI frames over all
+				 * data but FCS
+				 */
+				gsm->fcs = gsm_fcs_add_block(gsm->fcs, gsm->buf,
+							     gsm->count);
+			}
+			/* Add the FCS itself to test against GOOD_FCS */
 			gsm->fcs = gsm_fcs_add(gsm->fcs, gsm->buf[gsm->count]);
 			gsm->len = gsm->count;
 			gsm_queue(gsm);
@@ -2915,14 +3040,43 @@ static struct tty_ldisc_ops tty_ldisc_packet = {
  *	Virtual tty side
  */
 
-#define TX_SIZE		512
+/**
+ *	gsm_modem_upd_via_data	-	send modem bits via convergence layer
+ *	@dlci: channel
+ *	@brk: break signal
+ *
+ *	Send an empty frame to signal mobile state changes and to transmit the
+ *	break signal for adaption 2.
+ */
+
+static void gsm_modem_upd_via_data(struct gsm_dlci *dlci, u8 brk)
+{
+	struct gsm_mux *gsm = dlci->gsm;
+	unsigned long flags;
+
+	if (dlci->state != DLCI_OPEN || dlci->adaption != 2)
+		return;
+
+	spin_lock_irqsave(&gsm->tx_lock, flags);
+	gsm_dlci_modem_output(gsm, dlci, brk);
+	spin_unlock_irqrestore(&gsm->tx_lock, flags);
+}
+
+/**
+ *	gsm_modem_upd_via_msc	-	send modem bits via control frame
+ *	@dlci: channel
+ *	@brk: break signal
+ */
 
-static int gsmtty_modem_update(struct gsm_dlci *dlci, u8 brk)
+static int gsm_modem_upd_via_msc(struct gsm_dlci *dlci, u8 brk)
 {
 	u8 modembits[3];
 	struct gsm_control *ctrl;
 	int len = 2;
 
+	if (dlci->gsm->encoding != 0)
+		return 0;
+
 	modembits[0] = (dlci->addr << 2) | 2 | EA;  /* DLCI, Valid, EA */
 	if (!brk) {
 		modembits[1] = (gsm_encode_modem(dlci) << 1) | EA;
@@ -2937,6 +3091,27 @@ static int gsmtty_modem_update(struct gsm_dlci *dlci, u8 brk)
 	return gsm_control_wait(dlci->gsm, ctrl);
 }
 
+/**
+ *	gsm_modem_update	-	send modem status line state
+ *	@dlci: channel
+ *	@brk: break signal
+ */
+
+static int gsm_modem_update(struct gsm_dlci *dlci, u8 brk)
+{
+	if (dlci->adaption == 2) {
+		/* Send convergence layer type 2 empty data frame. */
+		gsm_modem_upd_via_data(dlci, brk);
+		return 0;
+	} else if (dlci->gsm->encoding == 0) {
+		/* Send as MSC control message. */
+		return gsm_modem_upd_via_msc(dlci, brk);
+	}
+
+	/* Modem status lines are not supported. */
+	return -EPROTONOSUPPORT;
+}
+
 static int gsm_carrier_raised(struct tty_port *port)
 {
 	struct gsm_dlci *dlci = container_of(port, struct gsm_dlci, port);
@@ -2969,7 +3144,7 @@ static void gsm_dtr_rts(struct tty_port *port, int onoff)
 		modem_tx &= ~(TIOCM_DTR | TIOCM_RTS);
 	if (modem_tx != dlci->modem_tx) {
 		dlci->modem_tx = modem_tx;
-		gsmtty_modem_update(dlci, 0);
+		gsm_modem_update(dlci, 0);
 	}
 }
 
@@ -3102,7 +3277,7 @@ static unsigned int gsmtty_write_room(struct tty_struct *tty)
 	struct gsm_dlci *dlci = tty->driver_data;
 	if (dlci->state == DLCI_CLOSED)
 		return 0;
-	return TX_SIZE - kfifo_len(&dlci->fifo);
+	return kfifo_avail(&dlci->fifo);
 }
 
 static unsigned int gsmtty_chars_in_buffer(struct tty_struct *tty)
@@ -3158,7 +3333,7 @@ static int gsmtty_tiocmset(struct tty_struct *tty,
 
 	if (modem_tx != dlci->modem_tx) {
 		dlci->modem_tx = modem_tx;
-		return gsmtty_modem_update(dlci, 0);
+		return gsm_modem_update(dlci, 0);
 	}
 	return 0;
 }
@@ -3219,7 +3394,7 @@ static void gsmtty_throttle(struct tty_struct *tty)
 		dlci->modem_tx &= ~TIOCM_RTS;
 	dlci->throttled = true;
 	/* Send an MSC with RTS cleared */
-	gsmtty_modem_update(dlci, 0);
+	gsm_modem_update(dlci, 0);
 }
 
 static void gsmtty_unthrottle(struct tty_struct *tty)
@@ -3231,7 +3406,7 @@ static void gsmtty_unthrottle(struct tty_struct *tty)
 		dlci->modem_tx |= TIOCM_RTS;
 	dlci->throttled = false;
 	/* Send an MSC with RTS set */
-	gsmtty_modem_update(dlci, 0);
+	gsm_modem_update(dlci, 0);
 }
 
 static int gsmtty_break_ctl(struct tty_struct *tty, int state)
@@ -3249,7 +3424,7 @@ static int gsmtty_break_ctl(struct tty_struct *tty, int state)
 		if (encode > 0x0F)
 			encode = 0x0F;	/* Best effort */
 	}
-	return gsmtty_modem_update(dlci, encode);
+	return gsm_modem_update(dlci, encode);
 }
 
 static void gsmtty_cleanup(struct tty_struct *tty)
diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 174895372e7f..467a349dc26c 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -1641,7 +1641,7 @@ static void mlx5_vdpa_kick_vq(struct vdpa_device *vdev, u16 idx)
 		return;
 
 	if (unlikely(is_ctrl_vq_idx(mvdev, idx))) {
-		if (!mvdev->cvq.ready)
+		if (!mvdev->wq || !mvdev->cvq.ready)
 			return;
 
 		queue_work(mvdev->wq, &ndev->cvq_ent.work);
@@ -2626,9 +2626,12 @@ static void mlx5_vdpa_dev_del(struct vdpa_mgmt_dev *v_mdev, struct vdpa_device *
 	struct mlx5_vdpa_mgmtdev *mgtdev = container_of(v_mdev, struct mlx5_vdpa_mgmtdev, mgtdev);
 	struct mlx5_vdpa_dev *mvdev = to_mvdev(dev);
 	struct mlx5_vdpa_net *ndev = to_mlx5_vdpa_ndev(mvdev);
+	struct workqueue_struct *wq;
 
 	mlx5_notifier_unregister(mvdev->mdev, &ndev->nb);
-	destroy_workqueue(mvdev->wq);
+	wq = mvdev->wq;
+	mvdev->wq = NULL;
+	destroy_workqueue(wq);
 	_vdpa_unregister_device(dev);
 	mgtdev->ndev = NULL;
 }
diff --git a/drivers/video/fbdev/core/fbcon.c b/drivers/video/fbdev/core/fbcon.c
index a25b63b56223..bb83e7c53ae0 100644
--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -2480,6 +2480,11 @@ static int fbcon_set_font(struct vc_data *vc, struct console_font *font,
 	if (charcount != 256 && charcount != 512)
 		return -EINVAL;
 
+	/* font bigger than screen resolution ? */
+	if (w > FBCON_SWAP(info->var.rotate, info->var.xres, info->var.yres) ||
+	    h > FBCON_SWAP(info->var.rotate, info->var.yres, info->var.xres))
+		return -EINVAL;
+
 	/* Make sure drawing engine can handle the font */
 	if (!(info->pixmap.blit_x & (1 << (font->width - 1))) ||
 	    !(info->pixmap.blit_y & (1 << (font->height - 1))))
@@ -2742,6 +2747,34 @@ void fbcon_update_vcs(struct fb_info *info, bool all)
 }
 EXPORT_SYMBOL(fbcon_update_vcs);
 
+/* let fbcon check if it supports a new screen resolution */
+int fbcon_modechange_possible(struct fb_info *info, struct fb_var_screeninfo *var)
+{
+	struct fbcon_ops *ops = info->fbcon_par;
+	struct vc_data *vc;
+	unsigned int i;
+
+	WARN_CONSOLE_UNLOCKED();
+
+	if (!ops)
+		return 0;
+
+	/* prevent setting a screen size which is smaller than font size */
+	for (i = first_fb_vc; i <= last_fb_vc; i++) {
+		vc = vc_cons[i].d;
+		if (!vc || vc->vc_mode != KD_TEXT ||
+			   registered_fb[con2fb_map[i]] != info)
+			continue;
+
+		if (vc->vc_font.width  > FBCON_SWAP(var->rotate, var->xres, var->yres) ||
+		    vc->vc_font.height > FBCON_SWAP(var->rotate, var->yres, var->xres))
+			return -EINVAL;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(fbcon_modechange_possible);
+
 int fbcon_mode_deleted(struct fb_info *info,
 		       struct fb_videomode *mode)
 {
diff --git a/drivers/video/fbdev/core/fbmem.c b/drivers/video/fbdev/core/fbmem.c
index 0371ad233fdf..6d7868cc1fca 100644
--- a/drivers/video/fbdev/core/fbmem.c
+++ b/drivers/video/fbdev/core/fbmem.c
@@ -514,7 +514,7 @@ static int fb_show_logo_line(struct fb_info *info, int rotate,
 
 		while (n && (n * (logo->width + 8) - 8 > xres))
 			--n;
-		image.dx = (xres - n * (logo->width + 8) - 8) / 2;
+		image.dx = (xres - (n * (logo->width + 8) - 8)) / 2;
 		image.dy = y ?: (yres - logo->height) / 2;
 	} else {
 		image.dx = 0;
@@ -1020,6 +1020,16 @@ fb_set_var(struct fb_info *info, struct fb_var_screeninfo *var)
 	if (ret)
 		return ret;
 
+	/* verify that virtual resolution >= physical resolution */
+	if (var->xres_virtual < var->xres ||
+	    var->yres_virtual < var->yres) {
+		pr_warn("WARNING: fbcon: Driver '%s' missed to adjust virtual screen size (%ux%u vs. %ux%u)\n",
+			info->fix.id,
+			var->xres_virtual, var->yres_virtual,
+			var->xres, var->yres);
+		return -EINVAL;
+	}
+
 	if ((var->activate & FB_ACTIVATE_MASK) != FB_ACTIVATE_NOW)
 		return 0;
 
@@ -1110,7 +1120,9 @@ static long do_fb_ioctl(struct fb_info *info, unsigned int cmd,
 			return -EFAULT;
 		console_lock();
 		lock_fb_info(info);
-		ret = fb_set_var(info, &var);
+		ret = fbcon_modechange_possible(info, &var);
+		if (!ret)
+			ret = fb_set_var(info, &var);
 		if (!ret)
 			fbcon_update_vcs(info, var.activate & FB_ACTIVATE_ALL);
 		unlock_fb_info(info);
diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 37418b183b07..c6c5a22ff6e8 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -3400,31 +3400,12 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans, u64 flags)
 	 */
 	check_system_chunk(trans, flags);
 
-	bg = btrfs_alloc_chunk(trans, flags);
+	bg = btrfs_create_chunk(trans, flags);
 	if (IS_ERR(bg)) {
 		ret = PTR_ERR(bg);
 		goto out;
 	}
 
-	/*
-	 * If this is a system chunk allocation then stop right here and do not
-	 * add the chunk item to the chunk btree. This is to prevent a deadlock
-	 * because this system chunk allocation can be triggered while COWing
-	 * some extent buffer of the chunk btree and while holding a lock on a
-	 * parent extent buffer, in which case attempting to insert the chunk
-	 * item (or update the device item) would result in a deadlock on that
-	 * parent extent buffer. In this case defer the chunk btree updates to
-	 * the second phase of chunk allocation and keep our reservation until
-	 * the second phase completes.
-	 *
-	 * This is a rare case and can only be triggered by the very few cases
-	 * we have where we need to touch the chunk btree outside chunk allocation
-	 * and chunk removal. These cases are basically adding a device, removing
-	 * a device or resizing a device.
-	 */
-	if (flags & BTRFS_BLOCK_GROUP_SYSTEM)
-		return 0;
-
 	ret = btrfs_chunk_alloc_add_chunk_item(trans, bg);
 	/*
 	 * Normally we are not expected to fail with -ENOSPC here, since we have
@@ -3461,7 +3442,7 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans, u64 flags)
 		const u64 sys_flags = btrfs_system_alloc_profile(trans->fs_info);
 		struct btrfs_block_group *sys_bg;
 
-		sys_bg = btrfs_alloc_chunk(trans, sys_flags);
+		sys_bg = btrfs_create_chunk(trans, sys_flags);
 		if (IS_ERR(sys_bg)) {
 			ret = PTR_ERR(sys_bg);
 			btrfs_abort_transaction(trans, ret);
@@ -3557,14 +3538,14 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans, u64 flags)
  * This has happened before and commit eafa4fd0ad0607 ("btrfs: fix exhaustion of
  * the system chunk array due to concurrent allocations") provides more details.
  *
- * For allocation of system chunks, we defer the updates and insertions into the
- * chunk btree to phase 2. This is to prevent deadlocks on extent buffers because
- * if the chunk allocation is triggered while COWing an extent buffer of the
- * chunk btree, we are holding a lock on the parent of that extent buffer and
- * doing the chunk btree updates and insertions can require locking that parent.
- * This is for the very few and rare cases where we update the chunk btree that
- * are not chunk allocation or chunk removal: adding a device, removing a device
- * or resizing a device.
+ * Allocation of system chunks does not happen through this function. A task that
+ * needs to update the chunk btree (the only btree that uses system chunks), must
+ * preallocate chunk space by calling either check_system_chunk() or
+ * btrfs_reserve_chunk_metadata() - the former is used when allocating a data or
+ * metadata chunk or when removing a chunk, while the later is used before doing
+ * a modification to the chunk btree - use cases for the later are adding,
+ * removing and resizing a device as well as relocation of a system chunk.
+ * See the comment below for more details.
  *
  * The reservation of system space, done through check_system_chunk(), as well
  * as all the updates and insertions into the chunk btree must be done while
@@ -3601,11 +3582,27 @@ int btrfs_chunk_alloc(struct btrfs_trans_handle *trans, u64 flags,
 	if (trans->allocating_chunk)
 		return -ENOSPC;
 	/*
-	 * If we are removing a chunk, don't re-enter or we would deadlock.
-	 * System space reservation and system chunk allocation is done by the
-	 * chunk remove operation (btrfs_remove_chunk()).
+	 * Allocation of system chunks can not happen through this path, as we
+	 * could end up in a deadlock if we are allocating a data or metadata
+	 * chunk and there is another task modifying the chunk btree.
+	 *
+	 * This is because while we are holding the chunk mutex, we will attempt
+	 * to add the new chunk item to the chunk btree or update an existing
+	 * device item in the chunk btree, while the other task that is modifying
+	 * the chunk btree is attempting to COW an extent buffer while holding a
+	 * lock on it and on its parent - if the COW operation triggers a system
+	 * chunk allocation, then we can deadlock because we are holding the
+	 * chunk mutex and we may need to access that extent buffer or its parent
+	 * in order to add the chunk item or update a device item.
+	 *
+	 * Tasks that want to modify the chunk tree should reserve system space
+	 * before updating the chunk btree, by calling either
+	 * btrfs_reserve_chunk_metadata() or check_system_chunk().
+	 * It's possible that after a task reserves the space, it still ends up
+	 * here - this happens in the cases described above at do_chunk_alloc().
+	 * The task will have to either retry or fail.
 	 */
-	if (trans->removing_chunk)
+	if (flags & BTRFS_BLOCK_GROUP_SYSTEM)
 		return -ENOSPC;
 
 	space_info = btrfs_find_space_info(fs_info, flags);
@@ -3704,17 +3701,14 @@ static u64 get_profile_num_devs(struct btrfs_fs_info *fs_info, u64 type)
 	return num_dev;
 }
 
-/*
- * Reserve space in the system space for allocating or removing a chunk
- */
-void check_system_chunk(struct btrfs_trans_handle *trans, u64 type)
+static void reserve_chunk_space(struct btrfs_trans_handle *trans,
+				u64 bytes,
+				u64 type)
 {
 	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_space_info *info;
 	u64 left;
-	u64 thresh;
 	int ret = 0;
-	u64 num_devs;
 
 	/*
 	 * Needed because we can end up allocating a system chunk and for an
@@ -3727,19 +3721,13 @@ void check_system_chunk(struct btrfs_trans_handle *trans, u64 type)
 	left = info->total_bytes - btrfs_space_info_used(info, true);
 	spin_unlock(&info->lock);
 
-	num_devs = get_profile_num_devs(fs_info, type);
-
-	/* num_devs device items to update and 1 chunk item to add or remove */
-	thresh = btrfs_calc_metadata_size(fs_info, num_devs) +
-		btrfs_calc_insert_metadata_size(fs_info, 1);
-
-	if (left < thresh && btrfs_test_opt(fs_info, ENOSPC_DEBUG)) {
+	if (left < bytes && btrfs_test_opt(fs_info, ENOSPC_DEBUG)) {
 		btrfs_info(fs_info, "left=%llu, need=%llu, flags=%llu",
-			   left, thresh, type);
+			   left, bytes, type);
 		btrfs_dump_space_info(fs_info, info, 0, 0);
 	}
 
-	if (left < thresh) {
+	if (left < bytes) {
 		u64 flags = btrfs_system_alloc_profile(fs_info);
 		struct btrfs_block_group *bg;
 
@@ -3748,21 +3736,20 @@ void check_system_chunk(struct btrfs_trans_handle *trans, u64 type)
 		 * needing it, as we might not need to COW all nodes/leafs from
 		 * the paths we visit in the chunk tree (they were already COWed
 		 * or created in the current transaction for example).
-		 *
-		 * Also, if our caller is allocating a system chunk, do not
-		 * attempt to insert the chunk item in the chunk btree, as we
-		 * could deadlock on an extent buffer since our caller may be
-		 * COWing an extent buffer from the chunk btree.
 		 */
-		bg = btrfs_alloc_chunk(trans, flags);
+		bg = btrfs_create_chunk(trans, flags);
 		if (IS_ERR(bg)) {
 			ret = PTR_ERR(bg);
-		} else if (!(type & BTRFS_BLOCK_GROUP_SYSTEM)) {
+		} else {
 			/*
 			 * If we fail to add the chunk item here, we end up
 			 * trying again at phase 2 of chunk allocation, at
 			 * btrfs_create_pending_block_groups(). So ignore
-			 * any error here.
+			 * any error here. An ENOSPC here could happen, due to
+			 * the cases described at do_chunk_alloc() - the system
+			 * block group we just created was just turned into RO
+			 * mode by a scrub for example, or a running discard
+			 * temporarily removed its free space entries, etc.
 			 */
 			btrfs_chunk_alloc_add_chunk_item(trans, bg);
 		}
@@ -3771,12 +3758,61 @@ void check_system_chunk(struct btrfs_trans_handle *trans, u64 type)
 	if (!ret) {
 		ret = btrfs_block_rsv_add(fs_info->chunk_root,
 					  &fs_info->chunk_block_rsv,
-					  thresh, BTRFS_RESERVE_NO_FLUSH);
+					  bytes, BTRFS_RESERVE_NO_FLUSH);
 		if (!ret)
-			trans->chunk_bytes_reserved += thresh;
+			trans->chunk_bytes_reserved += bytes;
 	}
 }
 
+/*
+ * Reserve space in the system space for allocating or removing a chunk.
+ * The caller must be holding fs_info->chunk_mutex.
+ */
+void check_system_chunk(struct btrfs_trans_handle *trans, u64 type)
+{
+	struct btrfs_fs_info *fs_info = trans->fs_info;
+	const u64 num_devs = get_profile_num_devs(fs_info, type);
+	u64 bytes;
+
+	/* num_devs device items to update and 1 chunk item to add or remove. */
+	bytes = btrfs_calc_metadata_size(fs_info, num_devs) +
+		btrfs_calc_insert_metadata_size(fs_info, 1);
+
+	reserve_chunk_space(trans, bytes, type);
+}
+
+/*
+ * Reserve space in the system space, if needed, for doing a modification to the
+ * chunk btree.
+ *
+ * @trans:		A transaction handle.
+ * @is_item_insertion:	Indicate if the modification is for inserting a new item
+ *			in the chunk btree or if it's for the deletion or update
+ *			of an existing item.
+ *
+ * This is used in a context where we need to update the chunk btree outside
+ * block group allocation and removal, to avoid a deadlock with a concurrent
+ * task that is allocating a metadata or data block group and therefore needs to
+ * update the chunk btree while holding the chunk mutex. After the update to the
+ * chunk btree is done, btrfs_trans_release_chunk_metadata() should be called.
+ *
+ */
+void btrfs_reserve_chunk_metadata(struct btrfs_trans_handle *trans,
+				  bool is_item_insertion)
+{
+	struct btrfs_fs_info *fs_info = trans->fs_info;
+	u64 bytes;
+
+	if (is_item_insertion)
+		bytes = btrfs_calc_insert_metadata_size(fs_info, 1);
+	else
+		bytes = btrfs_calc_metadata_size(fs_info, 1);
+
+	mutex_lock(&fs_info->chunk_mutex);
+	reserve_chunk_space(trans, bytes, BTRFS_BLOCK_GROUP_SYSTEM);
+	mutex_unlock(&fs_info->chunk_mutex);
+}
+
 void btrfs_put_block_group_cache(struct btrfs_fs_info *info)
 {
 	struct btrfs_block_group *block_group;
diff --git a/fs/btrfs/block-group.h b/fs/btrfs/block-group.h
index c72a71efcb18..37e55ebde735 100644
--- a/fs/btrfs/block-group.h
+++ b/fs/btrfs/block-group.h
@@ -289,6 +289,8 @@ int btrfs_chunk_alloc(struct btrfs_trans_handle *trans, u64 flags,
 		      enum btrfs_chunk_alloc_enum force);
 int btrfs_force_chunk_alloc(struct btrfs_trans_handle *trans, u64 type);
 void check_system_chunk(struct btrfs_trans_handle *trans, const u64 type);
+void btrfs_reserve_chunk_metadata(struct btrfs_trans_handle *trans,
+				  bool is_item_insertion);
 u64 btrfs_get_alloc_profile(struct btrfs_fs_info *fs_info, u64 orig_flags);
 void btrfs_put_block_group_cache(struct btrfs_fs_info *info);
 int btrfs_free_block_groups(struct btrfs_fs_info *info);
diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 899f85445925..341ce90d24b1 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -462,8 +462,8 @@ static noinline int __btrfs_cow_block(struct btrfs_trans_handle *trans,
 		BUG_ON(ret < 0);
 		rcu_assign_pointer(root->node, cow);
 
-		btrfs_free_tree_block(trans, root, buf, parent_start,
-				      last_ref);
+		btrfs_free_tree_block(trans, btrfs_root_id(root), buf,
+				      parent_start, last_ref);
 		free_extent_buffer(buf);
 		add_root_to_dirty_list(root);
 	} else {
@@ -484,8 +484,8 @@ static noinline int __btrfs_cow_block(struct btrfs_trans_handle *trans,
 				return ret;
 			}
 		}
-		btrfs_free_tree_block(trans, root, buf, parent_start,
-				      last_ref);
+		btrfs_free_tree_block(trans, btrfs_root_id(root), buf,
+				      parent_start, last_ref);
 	}
 	if (unlock_orig)
 		btrfs_tree_unlock(buf);
@@ -926,7 +926,7 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 		free_extent_buffer(mid);
 
 		root_sub_used(root, mid->len);
-		btrfs_free_tree_block(trans, root, mid, 0, 1);
+		btrfs_free_tree_block(trans, btrfs_root_id(root), mid, 0, 1);
 		/* once for the root ptr */
 		free_extent_buffer_stale(mid);
 		return 0;
@@ -985,7 +985,8 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 			btrfs_tree_unlock(right);
 			del_ptr(root, path, level + 1, pslot + 1);
 			root_sub_used(root, right->len);
-			btrfs_free_tree_block(trans, root, right, 0, 1);
+			btrfs_free_tree_block(trans, btrfs_root_id(root), right,
+					      0, 1);
 			free_extent_buffer_stale(right);
 			right = NULL;
 		} else {
@@ -1030,7 +1031,7 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 		btrfs_tree_unlock(mid);
 		del_ptr(root, path, level + 1, pslot);
 		root_sub_used(root, mid->len);
-		btrfs_free_tree_block(trans, root, mid, 0, 1);
+		btrfs_free_tree_block(trans, btrfs_root_id(root), mid, 0, 1);
 		free_extent_buffer_stale(mid);
 		mid = NULL;
 	} else {
@@ -4059,7 +4060,7 @@ static noinline void btrfs_del_leaf(struct btrfs_trans_handle *trans,
 	root_sub_used(root, leaf->len);
 
 	atomic_inc(&leaf->refs);
-	btrfs_free_tree_block(trans, root, leaf, 0, 1);
+	btrfs_free_tree_block(trans, btrfs_root_id(root), leaf, 0, 1);
 	free_extent_buffer_stale(leaf);
 }
 /*
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 21c44846b002..d1838de0b39c 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1027,6 +1027,7 @@ struct btrfs_fs_info {
 	 */
 	spinlock_t relocation_bg_lock;
 	u64 data_reloc_bg;
+	struct mutex zoned_data_reloc_io_lock;
 
 #ifdef CONFIG_BTRFS_FS_REF_VERIFY
 	spinlock_t ref_verify_lock;
@@ -2256,6 +2257,11 @@ static inline bool btrfs_root_dead(const struct btrfs_root *root)
 	return (root->root_item.flags & cpu_to_le64(BTRFS_ROOT_SUBVOL_DEAD)) != 0;
 }
 
+static inline u64 btrfs_root_id(const struct btrfs_root *root)
+{
+	return root->root_key.objectid;
+}
+
 /* struct btrfs_root_backup */
 BTRFS_SETGET_STACK_FUNCS(backup_tree_root, struct btrfs_root_backup,
 		   tree_root, 64);
@@ -2718,7 +2724,7 @@ struct extent_buffer *btrfs_alloc_tree_block(struct btrfs_trans_handle *trans,
 					     u64 empty_size,
 					     enum btrfs_lock_nesting nest);
 void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
-			   struct btrfs_root *root,
+			   u64 root_id,
 			   struct extent_buffer *buf,
 			   u64 parent, int last_ref);
 int btrfs_alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
index e22fba272e4f..31266ba1d430 100644
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -271,7 +271,7 @@ static inline void btrfs_init_generic_ref(struct btrfs_ref *generic_ref,
 }
 
 static inline void btrfs_init_tree_ref(struct btrfs_ref *generic_ref,
-				int level, u64 root)
+				int level, u64 root, u64 mod_root, bool skip_qgroup)
 {
 	/* If @real_root not set, use @root as fallback */
 	if (!generic_ref->real_root)
@@ -282,7 +282,8 @@ static inline void btrfs_init_tree_ref(struct btrfs_ref *generic_ref,
 }
 
 static inline void btrfs_init_data_ref(struct btrfs_ref *generic_ref,
-				u64 ref_root, u64 ino, u64 offset)
+				u64 ref_root, u64 ino, u64 offset, u64 mod_root,
+				bool skip_qgroup)
 {
 	/* If @real_root not set, use @root as fallback */
 	if (!generic_ref->real_root)
diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index bdbc310a8f8c..781556e2a37f 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -70,6 +70,7 @@ static int btrfs_dev_replace_kthread(void *data);
 
 int btrfs_init_dev_replace(struct btrfs_fs_info *fs_info)
 {
+	struct btrfs_dev_lookup_args args = { .devid = BTRFS_DEV_REPLACE_DEVID };
 	struct btrfs_key key;
 	struct btrfs_root *dev_root = fs_info->dev_root;
 	struct btrfs_dev_replace *dev_replace = &fs_info->dev_replace;
@@ -100,8 +101,7 @@ int btrfs_init_dev_replace(struct btrfs_fs_info *fs_info)
 		 * We don't have a replace item or it's corrupted.  If there is
 		 * a replace target, fail the mount.
 		 */
-		if (btrfs_find_device(fs_info->fs_devices,
-				      BTRFS_DEV_REPLACE_DEVID, NULL, NULL)) {
+		if (btrfs_find_device(fs_info->fs_devices, &args)) {
 			btrfs_err(fs_info,
 			"found replace target device without a valid replace item");
 			ret = -EUCLEAN;
@@ -163,8 +163,7 @@ int btrfs_init_dev_replace(struct btrfs_fs_info *fs_info)
 		 * We don't have an active replace item but if there is a
 		 * replace target, fail the mount.
 		 */
-		if (btrfs_find_device(fs_info->fs_devices,
-				      BTRFS_DEV_REPLACE_DEVID, NULL, NULL)) {
+		if (btrfs_find_device(fs_info->fs_devices, &args)) {
 			btrfs_err(fs_info,
 			"replace devid present without an active replace item");
 			ret = -EUCLEAN;
@@ -175,11 +174,10 @@ int btrfs_init_dev_replace(struct btrfs_fs_info *fs_info)
 		break;
 	case BTRFS_IOCTL_DEV_REPLACE_STATE_STARTED:
 	case BTRFS_IOCTL_DEV_REPLACE_STATE_SUSPENDED:
-		dev_replace->srcdev = btrfs_find_device(fs_info->fs_devices,
-						src_devid, NULL, NULL);
-		dev_replace->tgtdev = btrfs_find_device(fs_info->fs_devices,
-							BTRFS_DEV_REPLACE_DEVID,
-							NULL, NULL);
+		dev_replace->tgtdev = btrfs_find_device(fs_info->fs_devices, &args);
+		args.devid = src_devid;
+		dev_replace->srcdev = btrfs_find_device(fs_info->fs_devices, &args);
+
 		/*
 		 * allow 'btrfs dev replace_cancel' if src/tgt device is
 		 * missing
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 233d894f6feb..909d19656316 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2914,6 +2914,7 @@ void btrfs_init_fs_info(struct btrfs_fs_info *fs_info)
 	mutex_init(&fs_info->reloc_mutex);
 	mutex_init(&fs_info->delalloc_root_mutex);
 	mutex_init(&fs_info->zoned_meta_io_lock);
+	mutex_init(&fs_info->zoned_data_reloc_io_lock);
 	seqlock_init(&fs_info->profiles_lock);
 
 	INIT_LIST_HEAD(&fs_info->dirty_cowonly_roots);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 514adc83577f..f11616f61dd6 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2440,7 +2440,8 @@ static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
 					       num_bytes, parent);
 			generic_ref.real_root = root->root_key.objectid;
 			btrfs_init_data_ref(&generic_ref, ref_root, key.objectid,
-					    key.offset);
+					    key.offset, root->root_key.objectid,
+					    for_reloc);
 			generic_ref.skip_qgroup = for_reloc;
 			if (inc)
 				ret = btrfs_inc_extent_ref(trans, &generic_ref);
@@ -2454,7 +2455,8 @@ static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
 			btrfs_init_generic_ref(&generic_ref, action, bytenr,
 					       num_bytes, parent);
 			generic_ref.real_root = root->root_key.objectid;
-			btrfs_init_tree_ref(&generic_ref, level - 1, ref_root);
+			btrfs_init_tree_ref(&generic_ref, level - 1, ref_root,
+					    root->root_key.objectid, for_reloc);
 			generic_ref.skip_qgroup = for_reloc;
 			if (inc)
 				ret = btrfs_inc_extent_ref(trans, &generic_ref);
@@ -3278,20 +3280,20 @@ static noinline int check_ref_cleanup(struct btrfs_trans_handle *trans,
 }
 
 void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
-			   struct btrfs_root *root,
+			   u64 root_id,
 			   struct extent_buffer *buf,
 			   u64 parent, int last_ref)
 {
-	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_ref generic_ref = { 0 };
 	int ret;
 
 	btrfs_init_generic_ref(&generic_ref, BTRFS_DROP_DELAYED_REF,
 			       buf->start, buf->len, parent);
 	btrfs_init_tree_ref(&generic_ref, btrfs_header_level(buf),
-			    root->root_key.objectid);
+			    root_id, 0, false);
 
-	if (root->root_key.objectid != BTRFS_TREE_LOG_OBJECTID) {
+	if (root_id != BTRFS_TREE_LOG_OBJECTID) {
 		btrfs_ref_tree_mod(fs_info, &generic_ref);
 		ret = btrfs_add_delayed_tree_ref(trans, &generic_ref, NULL);
 		BUG_ON(ret); /* -ENOMEM */
@@ -3301,7 +3303,7 @@ void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 		struct btrfs_block_group *cache;
 		bool must_pin = false;
 
-		if (root->root_key.objectid != BTRFS_TREE_LOG_OBJECTID) {
+		if (root_id != BTRFS_TREE_LOG_OBJECTID) {
 			ret = check_ref_cleanup(trans, buf->start);
 			if (!ret) {
 				btrfs_redirty_list_add(trans->transaction, buf);
@@ -4705,7 +4707,8 @@ int btrfs_alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
 
 	btrfs_init_generic_ref(&generic_ref, BTRFS_ADD_DELAYED_EXTENT,
 			       ins->objectid, ins->offset, 0);
-	btrfs_init_data_ref(&generic_ref, root->root_key.objectid, owner, offset);
+	btrfs_init_data_ref(&generic_ref, root->root_key.objectid, owner,
+			    offset, 0, false);
 	btrfs_ref_tree_mod(root->fs_info, &generic_ref);
 
 	return btrfs_add_delayed_data_ref(trans, &generic_ref, ram_bytes);
@@ -4898,7 +4901,8 @@ struct extent_buffer *btrfs_alloc_tree_block(struct btrfs_trans_handle *trans,
 		btrfs_init_generic_ref(&generic_ref, BTRFS_ADD_DELAYED_EXTENT,
 				       ins.objectid, ins.offset, parent);
 		generic_ref.real_root = root->root_key.objectid;
-		btrfs_init_tree_ref(&generic_ref, level, root_objectid);
+		btrfs_init_tree_ref(&generic_ref, level, root_objectid,
+				    root->root_key.objectid, false);
 		btrfs_ref_tree_mod(fs_info, &generic_ref);
 		ret = btrfs_add_delayed_tree_ref(trans, &generic_ref, extent_op);
 		if (ret)
@@ -5315,7 +5319,8 @@ static noinline int do_walk_down(struct btrfs_trans_handle *trans,
 
 		btrfs_init_generic_ref(&ref, BTRFS_DROP_DELAYED_REF, bytenr,
 				       fs_info->nodesize, parent);
-		btrfs_init_tree_ref(&ref, level - 1, root->root_key.objectid);
+		btrfs_init_tree_ref(&ref, level - 1, root->root_key.objectid,
+				    0, false);
 		ret = btrfs_free_extent(trans, &ref);
 		if (ret)
 			goto out_unlock;
@@ -5436,7 +5441,8 @@ static noinline int walk_up_proc(struct btrfs_trans_handle *trans,
 			goto owner_mismatch;
 	}
 
-	btrfs_free_tree_block(trans, root, eb, parent, wc->refs[level] == 1);
+	btrfs_free_tree_block(trans, btrfs_root_id(root), eb, parent,
+			      wc->refs[level] == 1);
 out:
 	wc->refs[level] = 0;
 	wc->flags[level] = 0;
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 6dd375ed6e3d..059bd0753e27 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -5139,8 +5139,6 @@ int extent_writepages(struct address_space *mapping,
 		      struct writeback_control *wbc)
 {
 	struct inode *inode = mapping->host;
-	const bool data_reloc = btrfs_is_data_reloc_root(BTRFS_I(inode)->root);
-	const bool zoned = btrfs_is_zoned(BTRFS_I(inode)->root->fs_info);
 	int ret = 0;
 	struct extent_page_data epd = {
 		.bio_ctrl = { 0 },
@@ -5152,11 +5150,9 @@ int extent_writepages(struct address_space *mapping,
 	 * Allow only a single thread to do the reloc work in zoned mode to
 	 * protect the write pointer updates.
 	 */
-	if (data_reloc && zoned)
-		btrfs_inode_lock(inode, 0);
+	btrfs_zoned_data_reloc_lock(BTRFS_I(inode));
 	ret = extent_write_cache_pages(mapping, wbc, &epd);
-	if (data_reloc && zoned)
-		btrfs_inode_unlock(inode, 0);
+	btrfs_zoned_data_reloc_unlock(BTRFS_I(inode));
 	ASSERT(ret <= 0);
 	if (ret < 0) {
 		end_write_bio(&epd, ret);
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index a06c8366a8f4..1c597cd6c024 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -869,7 +869,8 @@ int btrfs_drop_extents(struct btrfs_trans_handle *trans,
 				btrfs_init_data_ref(&ref,
 						root->root_key.objectid,
 						new_key.objectid,
-						args->start - extent_offset);
+						args->start - extent_offset,
+						0, false);
 				ret = btrfs_inc_extent_ref(trans, &ref);
 				BUG_ON(ret); /* -ENOMEM */
 			}
@@ -955,7 +956,8 @@ int btrfs_drop_extents(struct btrfs_trans_handle *trans,
 				btrfs_init_data_ref(&ref,
 						root->root_key.objectid,
 						key.objectid,
-						key.offset - extent_offset);
+						key.offset - extent_offset, 0,
+						false);
 				ret = btrfs_free_extent(trans, &ref);
 				BUG_ON(ret); /* -ENOMEM */
 				args->bytes_found += extent_end - key.offset;
@@ -1232,7 +1234,7 @@ int btrfs_mark_extent_written(struct btrfs_trans_handle *trans,
 		btrfs_init_generic_ref(&ref, BTRFS_ADD_DELAYED_REF, bytenr,
 				       num_bytes, 0);
 		btrfs_init_data_ref(&ref, root->root_key.objectid, ino,
-				    orig_offset);
+				    orig_offset, 0, false);
 		ret = btrfs_inc_extent_ref(trans, &ref);
 		if (ret) {
 			btrfs_abort_transaction(trans, ret);
@@ -1257,7 +1259,8 @@ int btrfs_mark_extent_written(struct btrfs_trans_handle *trans,
 	other_end = 0;
 	btrfs_init_generic_ref(&ref, BTRFS_DROP_DELAYED_REF, bytenr,
 			       num_bytes, 0);
-	btrfs_init_data_ref(&ref, root->root_key.objectid, ino, orig_offset);
+	btrfs_init_data_ref(&ref, root->root_key.objectid, ino, orig_offset,
+			    0, false);
 	if (extent_mergeable(leaf, path->slots[0] + 1,
 			     ino, bytenr, orig_offset,
 			     &other_start, &other_end)) {
@@ -2715,7 +2718,7 @@ static int btrfs_insert_replace_extent(struct btrfs_trans_handle *trans,
 				       extent_info->disk_len, 0);
 		ref_offset = extent_info->file_offset - extent_info->data_offset;
 		btrfs_init_data_ref(&ref, root->root_key.objectid,
-				    btrfs_ino(inode), ref_offset);
+				    btrfs_ino(inode), ref_offset, 0, false);
 		ret = btrfs_inc_extent_ref(trans, &ref);
 	}
 
diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
index a33bca94d133..3abec44c6255 100644
--- a/fs/btrfs/free-space-tree.c
+++ b/fs/btrfs/free-space-tree.c
@@ -1256,8 +1256,8 @@ int btrfs_clear_free_space_tree(struct btrfs_fs_info *fs_info)
 	btrfs_tree_lock(free_space_root->node);
 	btrfs_clean_tree_block(free_space_root->node);
 	btrfs_tree_unlock(free_space_root->node);
-	btrfs_free_tree_block(trans, free_space_root, free_space_root->node,
-			      0, 1);
+	btrfs_free_tree_block(trans, btrfs_root_id(free_space_root),
+			      free_space_root->node, 0, 1);
 
 	btrfs_put_root(free_space_root);
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 044d584c3467..d644dcaf3004 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4919,7 +4919,8 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 					extent_start, extent_num_bytes, 0);
 			ref.real_root = root->root_key.objectid;
 			btrfs_init_data_ref(&ref, btrfs_header_owner(leaf),
-					ino, extent_offset);
+					ino, extent_offset,
+					root->root_key.objectid, false);
 			ret = btrfs_free_extent(trans, &ref);
 			if (ret) {
 				btrfs_abort_transaction(trans, ret);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index bf53af8694f8..b9dcaae7c8d5 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -615,11 +615,13 @@ static noinline int create_subvol(struct user_namespace *mnt_userns,
 		 * Since we don't abort the transaction in this case, free the
 		 * tree block so that we don't leak space and leave the
 		 * filesystem in an inconsistent state (an extent item in the
-		 * extent tree without backreferences). Also no need to have
-		 * the tree block locked since it is not in any tree at this
-		 * point, so no other task can find it and use it.
+		 * extent tree with a backreference for a root that does not
+		 * exists).
 		 */
-		btrfs_free_tree_block(trans, root, leaf, 0, 1);
+		btrfs_tree_lock(leaf);
+		btrfs_clean_tree_block(leaf);
+		btrfs_tree_unlock(leaf);
+		btrfs_free_tree_block(trans, objectid, leaf, 0, 1);
 		free_extent_buffer(leaf);
 		goto fail;
 	}
@@ -1655,6 +1657,7 @@ static int exclop_start_or_cancel_reloc(struct btrfs_fs_info *fs_info,
 static noinline int btrfs_ioctl_resize(struct file *file,
 					void __user *arg)
 {
+	BTRFS_DEV_LOOKUP_ARGS(args);
 	struct inode *inode = file_inode(file);
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	u64 new_size;
@@ -1710,7 +1713,8 @@ static noinline int btrfs_ioctl_resize(struct file *file,
 		btrfs_info(fs_info, "resizing devid %llu", devid);
 	}
 
-	device = btrfs_find_device(fs_info->fs_devices, devid, NULL, NULL);
+	args.devid = devid;
+	device = btrfs_find_device(fs_info->fs_devices, &args);
 	if (!device) {
 		btrfs_info(fs_info, "resizer unable to find device %llu",
 			   devid);
@@ -3214,6 +3218,7 @@ static long btrfs_ioctl_add_dev(struct btrfs_fs_info *fs_info, void __user *arg)
 
 static long btrfs_ioctl_rm_dev_v2(struct file *file, void __user *arg)
 {
+	BTRFS_DEV_LOOKUP_ARGS(args);
 	struct inode *inode = file_inode(file);
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	struct btrfs_ioctl_vol_args_v2 *vol_args;
@@ -3225,35 +3230,37 @@ static long btrfs_ioctl_rm_dev_v2(struct file *file, void __user *arg)
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	ret = mnt_want_write_file(file);
-	if (ret)
-		return ret;
-
 	vol_args = memdup_user(arg, sizeof(*vol_args));
-	if (IS_ERR(vol_args)) {
-		ret = PTR_ERR(vol_args);
-		goto err_drop;
-	}
+	if (IS_ERR(vol_args))
+		return PTR_ERR(vol_args);
 
 	if (vol_args->flags & ~BTRFS_DEVICE_REMOVE_ARGS_MASK) {
 		ret = -EOPNOTSUPP;
 		goto out;
 	}
+
 	vol_args->name[BTRFS_SUBVOL_NAME_MAX] = '\0';
-	if (!(vol_args->flags & BTRFS_DEVICE_SPEC_BY_ID) &&
-	    strcmp("cancel", vol_args->name) == 0)
+	if (vol_args->flags & BTRFS_DEVICE_SPEC_BY_ID) {
+		args.devid = vol_args->devid;
+	} else if (!strcmp("cancel", vol_args->name)) {
 		cancel = true;
+	} else {
+		ret = btrfs_get_dev_args_from_path(fs_info, &args, vol_args->name);
+		if (ret)
+			goto out;
+	}
+
+	ret = mnt_want_write_file(file);
+	if (ret)
+		goto out;
 
 	ret = exclop_start_or_cancel_reloc(fs_info, BTRFS_EXCLOP_DEV_REMOVE,
 					   cancel);
 	if (ret)
-		goto out;
-	/* Exclusive operation is now claimed */
+		goto err_drop;
 
-	if (vol_args->flags & BTRFS_DEVICE_SPEC_BY_ID)
-		ret = btrfs_rm_device(fs_info, NULL, vol_args->devid, &bdev, &mode);
-	else
-		ret = btrfs_rm_device(fs_info, vol_args->name, 0, &bdev, &mode);
+	/* Exclusive operation is now claimed */
+	ret = btrfs_rm_device(fs_info, &args, &bdev, &mode);
 
 	btrfs_exclop_finish(fs_info);
 
@@ -3265,54 +3272,62 @@ static long btrfs_ioctl_rm_dev_v2(struct file *file, void __user *arg)
 			btrfs_info(fs_info, "device deleted: %s",
 					vol_args->name);
 	}
-out:
-	kfree(vol_args);
 err_drop:
 	mnt_drop_write_file(file);
 	if (bdev)
 		blkdev_put(bdev, mode);
+out:
+	btrfs_put_dev_args_from_path(&args);
+	kfree(vol_args);
 	return ret;
 }
 
 static long btrfs_ioctl_rm_dev(struct file *file, void __user *arg)
 {
+	BTRFS_DEV_LOOKUP_ARGS(args);
 	struct inode *inode = file_inode(file);
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	struct btrfs_ioctl_vol_args *vol_args;
 	struct block_device *bdev = NULL;
 	fmode_t mode;
 	int ret;
-	bool cancel;
+	bool cancel = false;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	ret = mnt_want_write_file(file);
-	if (ret)
-		return ret;
-
 	vol_args = memdup_user(arg, sizeof(*vol_args));
-	if (IS_ERR(vol_args)) {
-		ret = PTR_ERR(vol_args);
-		goto out_drop_write;
-	}
+	if (IS_ERR(vol_args))
+		return PTR_ERR(vol_args);
+
 	vol_args->name[BTRFS_PATH_NAME_MAX] = '\0';
-	cancel = (strcmp("cancel", vol_args->name) == 0);
+	if (!strcmp("cancel", vol_args->name)) {
+		cancel = true;
+	} else {
+		ret = btrfs_get_dev_args_from_path(fs_info, &args, vol_args->name);
+		if (ret)
+			goto out;
+	}
+
+	ret = mnt_want_write_file(file);
+	if (ret)
+		goto out;
 
 	ret = exclop_start_or_cancel_reloc(fs_info, BTRFS_EXCLOP_DEV_REMOVE,
 					   cancel);
 	if (ret == 0) {
-		ret = btrfs_rm_device(fs_info, vol_args->name, 0, &bdev, &mode);
+		ret = btrfs_rm_device(fs_info, &args, &bdev, &mode);
 		if (!ret)
 			btrfs_info(fs_info, "disk deleted %s", vol_args->name);
 		btrfs_exclop_finish(fs_info);
 	}
 
-	kfree(vol_args);
-out_drop_write:
 	mnt_drop_write_file(file);
 	if (bdev)
 		blkdev_put(bdev, mode);
+out:
+	btrfs_put_dev_args_from_path(&args);
+	kfree(vol_args);
 	return ret;
 }
 
@@ -3373,22 +3388,21 @@ static long btrfs_ioctl_fs_info(struct btrfs_fs_info *fs_info,
 static long btrfs_ioctl_dev_info(struct btrfs_fs_info *fs_info,
 				 void __user *arg)
 {
+	BTRFS_DEV_LOOKUP_ARGS(args);
 	struct btrfs_ioctl_dev_info_args *di_args;
 	struct btrfs_device *dev;
 	int ret = 0;
-	char *s_uuid = NULL;
 
 	di_args = memdup_user(arg, sizeof(*di_args));
 	if (IS_ERR(di_args))
 		return PTR_ERR(di_args);
 
+	args.devid = di_args->devid;
 	if (!btrfs_is_empty_uuid(di_args->uuid))
-		s_uuid = di_args->uuid;
+		args.uuid = di_args->uuid;
 
 	rcu_read_lock();
-	dev = btrfs_find_device(fs_info->fs_devices, di_args->devid, s_uuid,
-				NULL);
-
+	dev = btrfs_find_device(fs_info->fs_devices, &args);
 	if (!dev) {
 		ret = -ENODEV;
 		goto out;
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 2c803108ea94..4ca809fa80ea 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1259,7 +1259,8 @@ int btrfs_quota_disable(struct btrfs_fs_info *fs_info)
 	btrfs_tree_lock(quota_root->node);
 	btrfs_clean_tree_block(quota_root->node);
 	btrfs_tree_unlock(quota_root->node);
-	btrfs_free_tree_block(trans, quota_root, quota_root->node, 0, 1);
+	btrfs_free_tree_block(trans, btrfs_root_id(quota_root),
+			      quota_root->node, 0, 1);
 
 	btrfs_put_root(quota_root);
 
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index a6661f2ad2c0..429a198f8937 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1147,7 +1147,8 @@ int replace_file_extents(struct btrfs_trans_handle *trans,
 				       num_bytes, parent);
 		ref.real_root = root->root_key.objectid;
 		btrfs_init_data_ref(&ref, btrfs_header_owner(leaf),
-				    key.objectid, key.offset);
+				    key.objectid, key.offset,
+				    root->root_key.objectid, false);
 		ret = btrfs_inc_extent_ref(trans, &ref);
 		if (ret) {
 			btrfs_abort_transaction(trans, ret);
@@ -1158,7 +1159,8 @@ int replace_file_extents(struct btrfs_trans_handle *trans,
 				       num_bytes, parent);
 		ref.real_root = root->root_key.objectid;
 		btrfs_init_data_ref(&ref, btrfs_header_owner(leaf),
-				    key.objectid, key.offset);
+				    key.objectid, key.offset,
+				    root->root_key.objectid, false);
 		ret = btrfs_free_extent(trans, &ref);
 		if (ret) {
 			btrfs_abort_transaction(trans, ret);
@@ -1368,7 +1370,8 @@ int replace_path(struct btrfs_trans_handle *trans, struct reloc_control *rc,
 		btrfs_init_generic_ref(&ref, BTRFS_ADD_DELAYED_REF, old_bytenr,
 				       blocksize, path->nodes[level]->start);
 		ref.skip_qgroup = true;
-		btrfs_init_tree_ref(&ref, level - 1, src->root_key.objectid);
+		btrfs_init_tree_ref(&ref, level - 1, src->root_key.objectid,
+				    0, true);
 		ret = btrfs_inc_extent_ref(trans, &ref);
 		if (ret) {
 			btrfs_abort_transaction(trans, ret);
@@ -1377,7 +1380,8 @@ int replace_path(struct btrfs_trans_handle *trans, struct reloc_control *rc,
 		btrfs_init_generic_ref(&ref, BTRFS_ADD_DELAYED_REF, new_bytenr,
 				       blocksize, 0);
 		ref.skip_qgroup = true;
-		btrfs_init_tree_ref(&ref, level - 1, dest->root_key.objectid);
+		btrfs_init_tree_ref(&ref, level - 1, dest->root_key.objectid, 0,
+				    true);
 		ret = btrfs_inc_extent_ref(trans, &ref);
 		if (ret) {
 			btrfs_abort_transaction(trans, ret);
@@ -1386,7 +1390,8 @@ int replace_path(struct btrfs_trans_handle *trans, struct reloc_control *rc,
 
 		btrfs_init_generic_ref(&ref, BTRFS_DROP_DELAYED_REF, new_bytenr,
 				       blocksize, path->nodes[level]->start);
-		btrfs_init_tree_ref(&ref, level - 1, src->root_key.objectid);
+		btrfs_init_tree_ref(&ref, level - 1, src->root_key.objectid,
+				    0, true);
 		ref.skip_qgroup = true;
 		ret = btrfs_free_extent(trans, &ref);
 		if (ret) {
@@ -1396,7 +1401,8 @@ int replace_path(struct btrfs_trans_handle *trans, struct reloc_control *rc,
 
 		btrfs_init_generic_ref(&ref, BTRFS_DROP_DELAYED_REF, old_bytenr,
 				       blocksize, 0);
-		btrfs_init_tree_ref(&ref, level - 1, dest->root_key.objectid);
+		btrfs_init_tree_ref(&ref, level - 1, dest->root_key.objectid,
+				    0, true);
 		ref.skip_qgroup = true;
 		ret = btrfs_free_extent(trans, &ref);
 		if (ret) {
@@ -2475,7 +2481,8 @@ static int do_relocation(struct btrfs_trans_handle *trans,
 					       upper->eb->start);
 			ref.real_root = root->root_key.objectid;
 			btrfs_init_tree_ref(&ref, node->level,
-					    btrfs_header_owner(upper->eb));
+					    btrfs_header_owner(upper->eb),
+					    root->root_key.objectid, false);
 			ret = btrfs_inc_extent_ref(trans, &ref);
 			if (!ret)
 				ret = btrfs_drop_subtree(trans, root, eb,
@@ -2691,8 +2698,12 @@ static int relocate_tree_block(struct btrfs_trans_handle *trans,
 			list_add_tail(&node->list, &rc->backref_cache.changed);
 		} else {
 			path->lowest_level = node->level;
+			if (root == root->fs_info->chunk_root)
+				btrfs_reserve_chunk_metadata(trans, false);
 			ret = btrfs_search_slot(trans, root, key, path, 0, 1);
 			btrfs_release_path(path);
+			if (root == root->fs_info->chunk_root)
+				btrfs_trans_release_chunk_metadata(trans);
 			if (ret > 0)
 				ret = 0;
 		}
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 62f4bafbe54b..6f2787b21530 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -4068,6 +4068,7 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 		    u64 end, struct btrfs_scrub_progress *progress,
 		    int readonly, int is_dev_replace)
 {
+	struct btrfs_dev_lookup_args args = { .devid = devid };
 	struct scrub_ctx *sctx;
 	int ret;
 	struct btrfs_device *dev;
@@ -4115,7 +4116,7 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 		goto out_free_ctx;
 
 	mutex_lock(&fs_info->fs_devices->device_list_mutex);
-	dev = btrfs_find_device(fs_info->fs_devices, devid, NULL, NULL);
+	dev = btrfs_find_device(fs_info->fs_devices, &args);
 	if (!dev || (test_bit(BTRFS_DEV_STATE_MISSING, &dev->dev_state) &&
 		     !is_dev_replace)) {
 		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
@@ -4288,11 +4289,12 @@ int btrfs_scrub_cancel_dev(struct btrfs_device *dev)
 int btrfs_scrub_progress(struct btrfs_fs_info *fs_info, u64 devid,
 			 struct btrfs_scrub_progress *progress)
 {
+	struct btrfs_dev_lookup_args args = { .devid = devid };
 	struct btrfs_device *dev;
 	struct scrub_ctx *sctx = NULL;
 
 	mutex_lock(&fs_info->fs_devices->device_list_mutex);
-	dev = btrfs_find_device(fs_info->fs_devices, devid, NULL, NULL);
+	dev = btrfs_find_device(fs_info->fs_devices, &args);
 	if (dev)
 		sctx = dev->scrub_ctx;
 	if (sctx)
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 1221d8483d63..bed6811476b0 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -761,7 +761,7 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
 						ins.objectid, ins.offset, 0);
 				btrfs_init_data_ref(&ref,
 						root->root_key.objectid,
-						key->objectid, offset);
+						key->objectid, offset, 0, false);
 				ret = btrfs_inc_extent_ref(trans, &ref);
 				if (ret)
 					goto out;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 378e03a93e10..89ce0b449c22 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -844,9 +844,13 @@ static noinline struct btrfs_device *device_list_add(const char *path,
 
 		device = NULL;
 	} else {
+		struct btrfs_dev_lookup_args args = {
+			.devid = devid,
+			.uuid = disk_super->dev_item.uuid,
+		};
+
 		mutex_lock(&fs_devices->device_list_mutex);
-		device = btrfs_find_device(fs_devices, devid,
-				disk_super->dev_item.uuid, NULL);
+		device = btrfs_find_device(fs_devices, &args);
 
 		/*
 		 * If this disk has been pulled into an fs devices created by
@@ -951,6 +955,11 @@ static noinline struct btrfs_device *device_list_add(const char *path,
 		/*
 		 * We are going to replace the device path for a given devid,
 		 * make sure it's the same device if the device is mounted
+		 *
+		 * NOTE: the device->fs_info may not be reliable here so pass
+		 * in a NULL to message helpers instead. This avoids a possible
+		 * use-after-free when the fs_info and fs_info->sb are already
+		 * torn down.
 		 */
 		if (device->bdev) {
 			int error;
@@ -964,12 +973,6 @@ static noinline struct btrfs_device *device_list_add(const char *path,
 
 			if (device->bdev->bd_dev != path_dev) {
 				mutex_unlock(&fs_devices->device_list_mutex);
-				/*
-				 * device->fs_info may not be reliable here, so
-				 * pass in a NULL instead. This avoids a
-				 * possible use-after-free when the fs_info and
-				 * fs_info->sb are already torn down.
-				 */
 				btrfs_warn_in_rcu(NULL,
 	"duplicate device %s devid %llu generation %llu scanned by %s (%d)",
 						  path, devid, found_transid,
@@ -977,7 +980,7 @@ static noinline struct btrfs_device *device_list_add(const char *path,
 						  task_pid_nr(current));
 				return ERR_PTR(-EEXIST);
 			}
-			btrfs_info_in_rcu(device->fs_info,
+			btrfs_info_in_rcu(NULL,
 	"devid %llu device path %s changed to %s scanned by %s (%d)",
 					  devid, rcu_str_deref(device->name),
 					  path, current->comm,
@@ -1879,8 +1882,10 @@ static int btrfs_add_dev_item(struct btrfs_trans_handle *trans,
 	key.type = BTRFS_DEV_ITEM_KEY;
 	key.offset = device->devid;
 
+	btrfs_reserve_chunk_metadata(trans, true);
 	ret = btrfs_insert_empty_item(trans, trans->fs_info->chunk_root, path,
 				      &key, sizeof(*dev_item));
+	btrfs_trans_release_chunk_metadata(trans);
 	if (ret)
 		goto out;
 
@@ -1936,46 +1941,34 @@ static void update_dev_time(const char *device_path)
 	path_put(&path);
 }
 
-static int btrfs_rm_dev_item(struct btrfs_device *device)
+static int btrfs_rm_dev_item(struct btrfs_trans_handle *trans,
+			     struct btrfs_device *device)
 {
 	struct btrfs_root *root = device->fs_info->chunk_root;
 	int ret;
 	struct btrfs_path *path;
 	struct btrfs_key key;
-	struct btrfs_trans_handle *trans;
 
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
 
-	trans = btrfs_start_transaction(root, 0);
-	if (IS_ERR(trans)) {
-		btrfs_free_path(path);
-		return PTR_ERR(trans);
-	}
 	key.objectid = BTRFS_DEV_ITEMS_OBJECTID;
 	key.type = BTRFS_DEV_ITEM_KEY;
 	key.offset = device->devid;
 
+	btrfs_reserve_chunk_metadata(trans, false);
 	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
+	btrfs_trans_release_chunk_metadata(trans);
 	if (ret) {
 		if (ret > 0)
 			ret = -ENOENT;
-		btrfs_abort_transaction(trans, ret);
-		btrfs_end_transaction(trans);
 		goto out;
 	}
 
 	ret = btrfs_del_item(trans, root, path);
-	if (ret) {
-		btrfs_abort_transaction(trans, ret);
-		btrfs_end_transaction(trans);
-	}
-
 out:
 	btrfs_free_path(path);
-	if (!ret)
-		ret = btrfs_commit_transaction(trans);
 	return ret;
 }
 
@@ -2112,9 +2105,11 @@ void btrfs_scratch_superblocks(struct btrfs_fs_info *fs_info,
 	update_dev_time(device_path);
 }
 
-int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
-		    u64 devid, struct block_device **bdev, fmode_t *mode)
+int btrfs_rm_device(struct btrfs_fs_info *fs_info,
+		    struct btrfs_dev_lookup_args *args,
+		    struct block_device **bdev, fmode_t *mode)
 {
+	struct btrfs_trans_handle *trans;
 	struct btrfs_device *device;
 	struct btrfs_fs_devices *cur_devices;
 	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
@@ -2130,37 +2125,30 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
 
 	ret = btrfs_check_raid_min_devices(fs_info, num_devices - 1);
 	if (ret)
-		goto out;
-
-	device = btrfs_find_device_by_devspec(fs_info, devid, device_path);
+		return ret;
 
-	if (IS_ERR(device)) {
-		if (PTR_ERR(device) == -ENOENT &&
-		    device_path && strcmp(device_path, "missing") == 0)
+	device = btrfs_find_device(fs_info->fs_devices, args);
+	if (!device) {
+		if (args->missing)
 			ret = BTRFS_ERROR_DEV_MISSING_NOT_FOUND;
 		else
-			ret = PTR_ERR(device);
-		goto out;
+			ret = -ENOENT;
+		return ret;
 	}
 
 	if (btrfs_pinned_by_swapfile(fs_info, device)) {
 		btrfs_warn_in_rcu(fs_info,
 		  "cannot remove device %s (devid %llu) due to active swapfile",
 				  rcu_str_deref(device->name), device->devid);
-		ret = -ETXTBSY;
-		goto out;
+		return -ETXTBSY;
 	}
 
-	if (test_bit(BTRFS_DEV_STATE_REPLACE_TGT, &device->dev_state)) {
-		ret = BTRFS_ERROR_DEV_TGT_REPLACE;
-		goto out;
-	}
+	if (test_bit(BTRFS_DEV_STATE_REPLACE_TGT, &device->dev_state))
+		return BTRFS_ERROR_DEV_TGT_REPLACE;
 
 	if (test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state) &&
-	    fs_info->fs_devices->rw_devices == 1) {
-		ret = BTRFS_ERROR_DEV_ONLY_WRITABLE;
-		goto out;
-	}
+	    fs_info->fs_devices->rw_devices == 1)
+		return BTRFS_ERROR_DEV_ONLY_WRITABLE;
 
 	if (test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state)) {
 		mutex_lock(&fs_info->chunk_mutex);
@@ -2175,14 +2163,22 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
 	if (ret)
 		goto error_undo;
 
-	/*
-	 * TODO: the superblock still includes this device in its num_devices
-	 * counter although write_all_supers() is not locked out. This
-	 * could give a filesystem state which requires a degraded mount.
-	 */
-	ret = btrfs_rm_dev_item(device);
-	if (ret)
+	trans = btrfs_start_transaction(fs_info->chunk_root, 0);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
 		goto error_undo;
+	}
+
+	ret = btrfs_rm_dev_item(trans, device);
+	if (ret) {
+		/* Any error in dev item removal is critical */
+		btrfs_crit(fs_info,
+			   "failed to remove device item for devid %llu: %d",
+			   device->devid, ret);
+		btrfs_abort_transaction(trans, ret);
+		btrfs_end_transaction(trans);
+		return ret;
+	}
 
 	clear_bit(BTRFS_DEV_STATE_IN_FS_METADATA, &device->dev_state);
 	btrfs_scrub_cancel_dev(device);
@@ -2257,7 +2253,8 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
 		free_fs_devices(cur_devices);
 	}
 
-out:
+	ret = btrfs_commit_transaction(trans);
+
 	return ret;
 
 error_undo:
@@ -2269,7 +2266,7 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
 		device->fs_devices->rw_devices++;
 		mutex_unlock(&fs_info->chunk_mutex);
 	}
-	goto out;
+	return ret;
 }
 
 void btrfs_rm_dev_replace_remove_srcdev(struct btrfs_device *srcdev)
@@ -2353,69 +2350,98 @@ void btrfs_destroy_dev_replace_tgtdev(struct btrfs_device *tgtdev)
 	btrfs_free_device(tgtdev);
 }
 
-static struct btrfs_device *btrfs_find_device_by_path(
-		struct btrfs_fs_info *fs_info, const char *device_path)
+/**
+ * Populate args from device at path
+ *
+ * @fs_info:	the filesystem
+ * @args:	the args to populate
+ * @path:	the path to the device
+ *
+ * This will read the super block of the device at @path and populate @args with
+ * the devid, fsid, and uuid.  This is meant to be used for ioctls that need to
+ * lookup a device to operate on, but need to do it before we take any locks.
+ * This properly handles the special case of "missing" that a user may pass in,
+ * and does some basic sanity checks.  The caller must make sure that @path is
+ * properly NUL terminated before calling in, and must call
+ * btrfs_put_dev_args_from_path() in order to free up the temporary fsid and
+ * uuid buffers.
+ *
+ * Return: 0 for success, -errno for failure
+ */
+int btrfs_get_dev_args_from_path(struct btrfs_fs_info *fs_info,
+				 struct btrfs_dev_lookup_args *args,
+				 const char *path)
 {
-	int ret = 0;
 	struct btrfs_super_block *disk_super;
-	u64 devid;
-	u8 *dev_uuid;
 	struct block_device *bdev;
-	struct btrfs_device *device;
+	int ret;
 
-	ret = btrfs_get_bdev_and_sb(device_path, FMODE_READ,
-				    fs_info->bdev_holder, 0, &bdev, &disk_super);
-	if (ret)
-		return ERR_PTR(ret);
+	if (!path || !path[0])
+		return -EINVAL;
+	if (!strcmp(path, "missing")) {
+		args->missing = true;
+		return 0;
+	}
 
-	devid = btrfs_stack_device_id(&disk_super->dev_item);
-	dev_uuid = disk_super->dev_item.uuid;
+	args->uuid = kzalloc(BTRFS_UUID_SIZE, GFP_KERNEL);
+	args->fsid = kzalloc(BTRFS_FSID_SIZE, GFP_KERNEL);
+	if (!args->uuid || !args->fsid) {
+		btrfs_put_dev_args_from_path(args);
+		return -ENOMEM;
+	}
+
+	ret = btrfs_get_bdev_and_sb(path, FMODE_READ, fs_info->bdev_holder, 0,
+				    &bdev, &disk_super);
+	if (ret)
+		return ret;
+	args->devid = btrfs_stack_device_id(&disk_super->dev_item);
+	memcpy(args->uuid, disk_super->dev_item.uuid, BTRFS_UUID_SIZE);
 	if (btrfs_fs_incompat(fs_info, METADATA_UUID))
-		device = btrfs_find_device(fs_info->fs_devices, devid, dev_uuid,
-					   disk_super->metadata_uuid);
+		memcpy(args->fsid, disk_super->metadata_uuid, BTRFS_FSID_SIZE);
 	else
-		device = btrfs_find_device(fs_info->fs_devices, devid, dev_uuid,
-					   disk_super->fsid);
-
+		memcpy(args->fsid, disk_super->fsid, BTRFS_FSID_SIZE);
 	btrfs_release_disk_super(disk_super);
-	if (!device)
-		device = ERR_PTR(-ENOENT);
 	blkdev_put(bdev, FMODE_READ);
-	return device;
+	return 0;
 }
 
 /*
- * Lookup a device given by device id, or the path if the id is 0.
+ * Only use this jointly with btrfs_get_dev_args_from_path() because we will
+ * allocate our ->uuid and ->fsid pointers, everybody else uses local variables
+ * that don't need to be freed.
  */
+void btrfs_put_dev_args_from_path(struct btrfs_dev_lookup_args *args)
+{
+	kfree(args->uuid);
+	kfree(args->fsid);
+	args->uuid = NULL;
+	args->fsid = NULL;
+}
+
 struct btrfs_device *btrfs_find_device_by_devspec(
 		struct btrfs_fs_info *fs_info, u64 devid,
 		const char *device_path)
 {
+	BTRFS_DEV_LOOKUP_ARGS(args);
 	struct btrfs_device *device;
+	int ret;
 
 	if (devid) {
-		device = btrfs_find_device(fs_info->fs_devices, devid, NULL,
-					   NULL);
+		args.devid = devid;
+		device = btrfs_find_device(fs_info->fs_devices, &args);
 		if (!device)
 			return ERR_PTR(-ENOENT);
 		return device;
 	}
 
-	if (!device_path || !device_path[0])
-		return ERR_PTR(-EINVAL);
-
-	if (strcmp(device_path, "missing") == 0) {
-		/* Find first missing device */
-		list_for_each_entry(device, &fs_info->fs_devices->devices,
-				    dev_list) {
-			if (test_bit(BTRFS_DEV_STATE_IN_FS_METADATA,
-				     &device->dev_state) && !device->bdev)
-				return device;
-		}
+	ret = btrfs_get_dev_args_from_path(fs_info, &args, device_path);
+	if (ret)
+		return ERR_PTR(ret);
+	device = btrfs_find_device(fs_info->fs_devices, &args);
+	btrfs_put_dev_args_from_path(&args);
+	if (!device)
 		return ERR_PTR(-ENOENT);
-	}
-
-	return btrfs_find_device_by_path(fs_info, device_path);
+	return device;
 }
 
 /*
@@ -2492,6 +2518,7 @@ static int btrfs_prepare_sprout(struct btrfs_fs_info *fs_info)
  */
 static int btrfs_finish_sprout(struct btrfs_trans_handle *trans)
 {
+	BTRFS_DEV_LOOKUP_ARGS(args);
 	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_root *root = fs_info->chunk_root;
 	struct btrfs_path *path;
@@ -2501,7 +2528,6 @@ static int btrfs_finish_sprout(struct btrfs_trans_handle *trans)
 	struct btrfs_key key;
 	u8 fs_uuid[BTRFS_FSID_SIZE];
 	u8 dev_uuid[BTRFS_UUID_SIZE];
-	u64 devid;
 	int ret;
 
 	path = btrfs_alloc_path();
@@ -2513,7 +2539,9 @@ static int btrfs_finish_sprout(struct btrfs_trans_handle *trans)
 	key.type = BTRFS_DEV_ITEM_KEY;
 
 	while (1) {
+		btrfs_reserve_chunk_metadata(trans, false);
 		ret = btrfs_search_slot(trans, root, &key, path, 0, 1);
+		btrfs_trans_release_chunk_metadata(trans);
 		if (ret < 0)
 			goto error;
 
@@ -2538,13 +2566,14 @@ static int btrfs_finish_sprout(struct btrfs_trans_handle *trans)
 
 		dev_item = btrfs_item_ptr(leaf, path->slots[0],
 					  struct btrfs_dev_item);
-		devid = btrfs_device_id(leaf, dev_item);
+		args.devid = btrfs_device_id(leaf, dev_item);
 		read_extent_buffer(leaf, dev_uuid, btrfs_device_uuid(dev_item),
 				   BTRFS_UUID_SIZE);
 		read_extent_buffer(leaf, fs_uuid, btrfs_device_fsid(dev_item),
 				   BTRFS_FSID_SIZE);
-		device = btrfs_find_device(fs_info->fs_devices, devid, dev_uuid,
-					   fs_uuid);
+		args.uuid = dev_uuid;
+		args.fsid = fs_uuid;
+		device = btrfs_find_device(fs_info->fs_devices, &args);
 		BUG_ON(!device); /* Logic error */
 
 		if (device->fs_devices->seeding) {
@@ -2861,6 +2890,7 @@ int btrfs_grow_device(struct btrfs_trans_handle *trans,
 	struct btrfs_super_block *super_copy = fs_info->super_copy;
 	u64 old_total;
 	u64 diff;
+	int ret;
 
 	if (!test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state))
 		return -EACCES;
@@ -2889,7 +2919,11 @@ int btrfs_grow_device(struct btrfs_trans_handle *trans,
 			      &trans->transaction->dev_update_list);
 	mutex_unlock(&fs_info->chunk_mutex);
 
-	return btrfs_update_device(trans, device);
+	btrfs_reserve_chunk_metadata(trans, false);
+	ret = btrfs_update_device(trans, device);
+	btrfs_trans_release_chunk_metadata(trans);
+
+	return ret;
 }
 
 static int btrfs_free_chunk(struct btrfs_trans_handle *trans, u64 chunk_offset)
@@ -3131,7 +3165,7 @@ int btrfs_remove_chunk(struct btrfs_trans_handle *trans, u64 chunk_offset)
 		const u64 sys_flags = btrfs_system_alloc_profile(fs_info);
 		struct btrfs_block_group *sys_bg;
 
-		sys_bg = btrfs_alloc_chunk(trans, sys_flags);
+		sys_bg = btrfs_create_chunk(trans, sys_flags);
 		if (IS_ERR(sys_bg)) {
 			ret = PTR_ERR(sys_bg);
 			btrfs_abort_transaction(trans, ret);
@@ -4926,8 +4960,10 @@ int btrfs_shrink_device(struct btrfs_device *device, u64 new_size)
 			round_down(old_total - diff, fs_info->sectorsize));
 	mutex_unlock(&fs_info->chunk_mutex);
 
+	btrfs_reserve_chunk_metadata(trans, false);
 	/* Now btrfs_update_device() will change the on-disk size. */
 	ret = btrfs_update_device(trans, device);
+	btrfs_trans_release_chunk_metadata(trans);
 	if (ret < 0) {
 		btrfs_abort_transaction(trans, ret);
 		btrfs_end_transaction(trans);
@@ -5010,7 +5046,7 @@ static void check_raid1c34_incompat_flag(struct btrfs_fs_info *info, u64 type)
 }
 
 /*
- * Structure used internally for __btrfs_alloc_chunk() function.
+ * Structure used internally for btrfs_create_chunk() function.
  * Wraps needed parameters.
  */
 struct alloc_chunk_ctl {
@@ -5414,7 +5450,7 @@ static struct btrfs_block_group *create_chunk(struct btrfs_trans_handle *trans,
 	return block_group;
 }
 
-struct btrfs_block_group *btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
+struct btrfs_block_group *btrfs_create_chunk(struct btrfs_trans_handle *trans,
 					    u64 type)
 {
 	struct btrfs_fs_info *info = trans->fs_info;
@@ -5615,12 +5651,12 @@ static noinline int init_first_rw_device(struct btrfs_trans_handle *trans)
 	 */
 
 	alloc_profile = btrfs_metadata_alloc_profile(fs_info);
-	meta_bg = btrfs_alloc_chunk(trans, alloc_profile);
+	meta_bg = btrfs_create_chunk(trans, alloc_profile);
 	if (IS_ERR(meta_bg))
 		return PTR_ERR(meta_bg);
 
 	alloc_profile = btrfs_system_alloc_profile(fs_info);
-	sys_bg = btrfs_alloc_chunk(trans, alloc_profile);
+	sys_bg = btrfs_create_chunk(trans, alloc_profile);
 	if (IS_ERR(sys_bg))
 		return PTR_ERR(sys_bg);
 
@@ -6792,6 +6828,33 @@ blk_status_t btrfs_map_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
 	return BLK_STS_OK;
 }
 
+static bool dev_args_match_fs_devices(const struct btrfs_dev_lookup_args *args,
+				      const struct btrfs_fs_devices *fs_devices)
+{
+	if (args->fsid == NULL)
+		return true;
+	if (memcmp(fs_devices->metadata_uuid, args->fsid, BTRFS_FSID_SIZE) == 0)
+		return true;
+	return false;
+}
+
+static bool dev_args_match_device(const struct btrfs_dev_lookup_args *args,
+				  const struct btrfs_device *device)
+{
+	ASSERT((args->devid != (u64)-1) || args->missing);
+
+	if ((args->devid != (u64)-1) && device->devid != args->devid)
+		return false;
+	if (args->uuid && memcmp(device->uuid, args->uuid, BTRFS_UUID_SIZE) != 0)
+		return false;
+	if (!args->missing)
+		return true;
+	if (test_bit(BTRFS_DEV_STATE_IN_FS_METADATA, &device->dev_state) &&
+	    !device->bdev)
+		return true;
+	return false;
+}
+
 /*
  * Find a device specified by @devid or @uuid in the list of @fs_devices, or
  * return NULL.
@@ -6799,31 +6862,25 @@ blk_status_t btrfs_map_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
  * If devid and uuid are both specified, the match must be exact, otherwise
  * only devid is used.
  */
-struct btrfs_device *btrfs_find_device(struct btrfs_fs_devices *fs_devices,
-				       u64 devid, u8 *uuid, u8 *fsid)
+struct btrfs_device *btrfs_find_device(const struct btrfs_fs_devices *fs_devices,
+				       const struct btrfs_dev_lookup_args *args)
 {
 	struct btrfs_device *device;
 	struct btrfs_fs_devices *seed_devs;
 
-	if (!fsid || !memcmp(fs_devices->metadata_uuid, fsid, BTRFS_FSID_SIZE)) {
+	if (dev_args_match_fs_devices(args, fs_devices)) {
 		list_for_each_entry(device, &fs_devices->devices, dev_list) {
-			if (device->devid == devid &&
-			    (!uuid || memcmp(device->uuid, uuid,
-					     BTRFS_UUID_SIZE) == 0))
+			if (dev_args_match_device(args, device))
 				return device;
 		}
 	}
 
 	list_for_each_entry(seed_devs, &fs_devices->seed_list, seed_list) {
-		if (!fsid ||
-		    !memcmp(seed_devs->metadata_uuid, fsid, BTRFS_FSID_SIZE)) {
-			list_for_each_entry(device, &seed_devs->devices,
-					    dev_list) {
-				if (device->devid == devid &&
-				    (!uuid || memcmp(device->uuid, uuid,
-						     BTRFS_UUID_SIZE) == 0))
-					return device;
-			}
+		if (!dev_args_match_fs_devices(args, seed_devs))
+			continue;
+		list_for_each_entry(device, &seed_devs->devices, dev_list) {
+			if (dev_args_match_device(args, device))
+				return device;
 		}
 	}
 
@@ -6989,6 +7046,7 @@ static void warn_32bit_meta_chunk(struct btrfs_fs_info *fs_info,
 static int read_one_chunk(struct btrfs_key *key, struct extent_buffer *leaf,
 			  struct btrfs_chunk *chunk)
 {
+	BTRFS_DEV_LOOKUP_ARGS(args);
 	struct btrfs_fs_info *fs_info = leaf->fs_info;
 	struct extent_map_tree *map_tree = &fs_info->mapping_tree;
 	struct map_lookup *map;
@@ -7066,11 +7124,12 @@ static int read_one_chunk(struct btrfs_key *key, struct extent_buffer *leaf,
 		map->stripes[i].physical =
 			btrfs_stripe_offset_nr(leaf, chunk, i);
 		devid = btrfs_stripe_devid_nr(leaf, chunk, i);
+		args.devid = devid;
 		read_extent_buffer(leaf, uuid, (unsigned long)
 				   btrfs_stripe_dev_uuid_nr(chunk, i),
 				   BTRFS_UUID_SIZE);
-		map->stripes[i].dev = btrfs_find_device(fs_info->fs_devices,
-							devid, uuid, NULL);
+		args.uuid = uuid;
+		map->stripes[i].dev = btrfs_find_device(fs_info->fs_devices, &args);
 		if (!map->stripes[i].dev &&
 		    !btrfs_test_opt(fs_info, DEGRADED)) {
 			free_extent_map(em);
@@ -7188,6 +7247,7 @@ static struct btrfs_fs_devices *open_seed_devices(struct btrfs_fs_info *fs_info,
 static int read_one_dev(struct extent_buffer *leaf,
 			struct btrfs_dev_item *dev_item)
 {
+	BTRFS_DEV_LOOKUP_ARGS(args);
 	struct btrfs_fs_info *fs_info = leaf->fs_info;
 	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
 	struct btrfs_device *device;
@@ -7196,11 +7256,13 @@ static int read_one_dev(struct extent_buffer *leaf,
 	u8 fs_uuid[BTRFS_FSID_SIZE];
 	u8 dev_uuid[BTRFS_UUID_SIZE];
 
-	devid = btrfs_device_id(leaf, dev_item);
+	devid = args.devid = btrfs_device_id(leaf, dev_item);
 	read_extent_buffer(leaf, dev_uuid, btrfs_device_uuid(dev_item),
 			   BTRFS_UUID_SIZE);
 	read_extent_buffer(leaf, fs_uuid, btrfs_device_fsid(dev_item),
 			   BTRFS_FSID_SIZE);
+	args.uuid = dev_uuid;
+	args.fsid = fs_uuid;
 
 	if (memcmp(fs_uuid, fs_devices->metadata_uuid, BTRFS_FSID_SIZE)) {
 		fs_devices = open_seed_devices(fs_info, fs_uuid);
@@ -7208,8 +7270,7 @@ static int read_one_dev(struct extent_buffer *leaf,
 			return PTR_ERR(fs_devices);
 	}
 
-	device = btrfs_find_device(fs_info->fs_devices, devid, dev_uuid,
-				   fs_uuid);
+	device = btrfs_find_device(fs_info->fs_devices, &args);
 	if (!device) {
 		if (!btrfs_test_opt(fs_info, DEGRADED)) {
 			btrfs_report_missing_device(fs_info, devid,
@@ -7886,12 +7947,14 @@ static void btrfs_dev_stat_print_on_load(struct btrfs_device *dev)
 int btrfs_get_dev_stats(struct btrfs_fs_info *fs_info,
 			struct btrfs_ioctl_get_dev_stats *stats)
 {
+	BTRFS_DEV_LOOKUP_ARGS(args);
 	struct btrfs_device *dev;
 	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
 	int i;
 
 	mutex_lock(&fs_devices->device_list_mutex);
-	dev = btrfs_find_device(fs_info->fs_devices, stats->devid, NULL, NULL);
+	args.devid = stats->devid;
+	dev = btrfs_find_device(fs_info->fs_devices, &args);
 	mutex_unlock(&fs_devices->device_list_mutex);
 
 	if (!dev) {
@@ -7967,6 +8030,7 @@ static int verify_one_dev_extent(struct btrfs_fs_info *fs_info,
 				 u64 chunk_offset, u64 devid,
 				 u64 physical_offset, u64 physical_len)
 {
+	struct btrfs_dev_lookup_args args = { .devid = devid };
 	struct extent_map_tree *em_tree = &fs_info->mapping_tree;
 	struct extent_map *em;
 	struct map_lookup *map;
@@ -8022,7 +8086,7 @@ static int verify_one_dev_extent(struct btrfs_fs_info *fs_info,
 	}
 
 	/* Make sure no dev extent is beyond device boundary */
-	dev = btrfs_find_device(fs_info->fs_devices, devid, NULL, NULL);
+	dev = btrfs_find_device(fs_info->fs_devices, &args);
 	if (!dev) {
 		btrfs_err(fs_info, "failed to find devid %llu", devid);
 		ret = -EUCLEAN;
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 4db10d071d67..30288b728bbb 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -418,6 +418,22 @@ struct btrfs_balance_control {
 	struct btrfs_balance_progress stat;
 };
 
+/*
+ * Search for a given device by the set parameters
+ */
+struct btrfs_dev_lookup_args {
+	u64 devid;
+	u8 *uuid;
+	u8 *fsid;
+	bool missing;
+};
+
+/* We have to initialize to -1 because BTRFS_DEV_REPLACE_DEVID is 0 */
+#define BTRFS_DEV_LOOKUP_ARGS_INIT { .devid = (u64)-1 }
+
+#define BTRFS_DEV_LOOKUP_ARGS(name) \
+	struct btrfs_dev_lookup_args name = BTRFS_DEV_LOOKUP_ARGS_INIT
+
 enum btrfs_map_op {
 	BTRFS_MAP_READ,
 	BTRFS_MAP_WRITE,
@@ -454,7 +470,7 @@ int btrfs_get_io_geometry(struct btrfs_fs_info *fs_info, struct extent_map *map,
 			  struct btrfs_io_geometry *io_geom);
 int btrfs_read_sys_array(struct btrfs_fs_info *fs_info);
 int btrfs_read_chunk_tree(struct btrfs_fs_info *fs_info);
-struct btrfs_block_group *btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
+struct btrfs_block_group *btrfs_create_chunk(struct btrfs_trans_handle *trans,
 					    u64 type);
 void btrfs_mapping_tree_free(struct extent_map_tree *tree);
 blk_status_t btrfs_map_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
@@ -471,19 +487,23 @@ void btrfs_assign_next_active_device(struct btrfs_device *device,
 struct btrfs_device *btrfs_find_device_by_devspec(struct btrfs_fs_info *fs_info,
 						  u64 devid,
 						  const char *devpath);
+int btrfs_get_dev_args_from_path(struct btrfs_fs_info *fs_info,
+				 struct btrfs_dev_lookup_args *args,
+				 const char *path);
 struct btrfs_device *btrfs_alloc_device(struct btrfs_fs_info *fs_info,
 					const u64 *devid,
 					const u8 *uuid);
+void btrfs_put_dev_args_from_path(struct btrfs_dev_lookup_args *args);
 void btrfs_free_device(struct btrfs_device *device);
 int btrfs_rm_device(struct btrfs_fs_info *fs_info,
-		    const char *device_path, u64 devid,
+		    struct btrfs_dev_lookup_args *args,
 		    struct block_device **bdev, fmode_t *mode);
 void __exit btrfs_cleanup_fs_uuids(void);
 int btrfs_num_copies(struct btrfs_fs_info *fs_info, u64 logical, u64 len);
 int btrfs_grow_device(struct btrfs_trans_handle *trans,
 		      struct btrfs_device *device, u64 new_size);
-struct btrfs_device *btrfs_find_device(struct btrfs_fs_devices *fs_devices,
-				       u64 devid, u8 *uuid, u8 *fsid);
+struct btrfs_device *btrfs_find_device(const struct btrfs_fs_devices *fs_devices,
+				       const struct btrfs_dev_lookup_args *args);
 int btrfs_shrink_device(struct btrfs_device *device, u64 new_size);
 int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *path);
 int btrfs_balance(struct btrfs_fs_info *fs_info,
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 596b2148807d..3bc2f92cd197 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -636,7 +636,7 @@ int btrfs_check_zoned_mode(struct btrfs_fs_info *fs_info)
 
 	/*
 	 * stripe_size is always aligned to BTRFS_STRIPE_LEN in
-	 * __btrfs_alloc_chunk(). Since we want stripe_len == zone_size,
+	 * btrfs_create_chunk(). Since we want stripe_len == zone_size,
 	 * check the alignment here.
 	 */
 	if (!IS_ALIGNED(zone_size, BTRFS_STRIPE_LEN)) {
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index 813aa3cddc11..3a826f7c2040 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -8,6 +8,7 @@
 #include "volumes.h"
 #include "disk-io.h"
 #include "block-group.h"
+#include "btrfs_inode.h"
 
 /*
  * Block groups with more than this value (percents) of unusable space will be
@@ -324,4 +325,20 @@ static inline void btrfs_clear_treelog_bg(struct btrfs_block_group *bg)
 	spin_unlock(&fs_info->treelog_bg_lock);
 }
 
+static inline void btrfs_zoned_data_reloc_lock(struct btrfs_inode *inode)
+{
+	struct btrfs_root *root = inode->root;
+
+	if (btrfs_is_data_reloc_root(root) && btrfs_is_zoned(root->fs_info))
+		mutex_lock(&root->fs_info->zoned_data_reloc_io_lock);
+}
+
+static inline void btrfs_zoned_data_reloc_unlock(struct btrfs_inode *inode)
+{
+	struct btrfs_root *root = inode->root;
+
+	if (btrfs_is_data_reloc_root(root) && btrfs_is_zoned(root->fs_info))
+		mutex_unlock(&root->fs_info->zoned_data_reloc_io_lock);
+}
+
 #endif
diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 60390f9dc31f..e93185d804e0 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -1086,6 +1086,7 @@ static ssize_t gfs2_file_buffered_write(struct kiocb *iocb,
 	gfs2_holder_uninit(gh);
 	if (statfs_gh)
 		kfree(statfs_gh);
+	from->count = orig_count - read;
 	return read ? read : ret;
 }
 
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 189323740324..9bff14c5e2b2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2686,8 +2686,12 @@ static bool io_rw_should_reissue(struct io_kiocb *req)
 
 static bool __io_complete_rw_common(struct io_kiocb *req, long res)
 {
-	if (req->rw.kiocb.ki_flags & IOCB_WRITE)
+	if (req->rw.kiocb.ki_flags & IOCB_WRITE) {
 		kiocb_end_write(req);
+		fsnotify_modify(req->file);
+	} else {
+		fsnotify_access(req->file);
+	}
 	if (res != req->result) {
 		if ((res == -EAGAIN || res == -EOPNOTSUPP) &&
 		    io_rw_should_reissue(req)) {
@@ -4183,6 +4187,8 @@ static int io_fallocate(struct io_kiocb *req, unsigned int issue_flags)
 				req->sync.len);
 	if (ret < 0)
 		req_set_fail(req);
+	else
+		fsnotify_modify(req->file);
 	io_req_complete(req, ret);
 	return 0;
 }
@@ -6860,7 +6866,7 @@ static void io_wq_submit_work(struct io_wq_work *work)
 			 * forcing a sync submission from here, since we can't
 			 * wait for request slots on the block side.
 			 */
-			if (ret != -EAGAIN)
+			if (ret != -EAGAIN || !(req->ctx->flags & IORING_SETUP_IOPOLL))
 				break;
 			cond_resched();
 		} while (1);
diff --git a/fs/nfsd/nfs3proc.c b/fs/nfsd/nfs3proc.c
index b540489ea240..936eebd4c56d 100644
--- a/fs/nfsd/nfs3proc.c
+++ b/fs/nfsd/nfs3proc.c
@@ -660,15 +660,9 @@ nfsd3_proc_commit(struct svc_rqst *rqstp)
 				argp->count,
 				(unsigned long long) argp->offset);
 
-	if (argp->offset > NFS_OFFSET_MAX) {
-		resp->status = nfserr_inval;
-		goto out;
-	}
-
 	fh_copy(&resp->fh, &argp->fh);
 	resp->status = nfsd_commit(rqstp, &resp->fh, argp->offset,
 				   argp->count, resp->verf);
-out:
 	return rpc_success;
 }
 
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 5f62fa0963ce..abfbb6953e89 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1108,44 +1108,64 @@ nfsd_write(struct svc_rqst *rqstp, struct svc_fh *fhp, loff_t offset,
 }
 
 #ifdef CONFIG_NFSD_V3
-/*
- * Commit all pending writes to stable storage.
+/**
+ * nfsd_commit - Commit pending writes to stable storage
+ * @rqstp: RPC request being processed
+ * @fhp: NFS filehandle
+ * @offset: raw offset from beginning of file
+ * @count: raw count of bytes to sync
+ * @verf: filled in with the server's current write verifier
  *
- * Note: we only guarantee that data that lies within the range specified
- * by the 'offset' and 'count' parameters will be synced.
+ * Note: we guarantee that data that lies within the range specified
+ * by the 'offset' and 'count' parameters will be synced. The server
+ * is permitted to sync data that lies outside this range at the
+ * same time.
  *
  * Unfortunately we cannot lock the file to make sure we return full WCC
  * data to the client, as locking happens lower down in the filesystem.
+ *
+ * Return values:
+ *   An nfsstat value in network byte order.
  */
 __be32
-nfsd_commit(struct svc_rqst *rqstp, struct svc_fh *fhp,
-               loff_t offset, unsigned long count, __be32 *verf)
+nfsd_commit(struct svc_rqst *rqstp, struct svc_fh *fhp, u64 offset,
+	    u32 count, __be32 *verf)
 {
+	u64			maxbytes;
+	loff_t			start, end;
+	struct nfsd_net		*nn;
 	struct nfsd_file	*nf;
-	loff_t			end = LLONG_MAX;
-	__be32			err = nfserr_inval;
-
-	if (offset < 0)
-		goto out;
-	if (count != 0) {
-		end = offset + (loff_t)count - 1;
-		if (end < offset)
-			goto out;
-	}
+	__be32			err;
 
 	err = nfsd_file_acquire(rqstp, fhp,
 			NFSD_MAY_WRITE|NFSD_MAY_NOT_BREAK_LEASE, &nf);
 	if (err)
 		goto out;
+
+	/*
+	 * Convert the client-provided (offset, count) range to a
+	 * (start, end) range. If the client-provided range falls
+	 * outside the maximum file size of the underlying FS,
+	 * clamp the sync range appropriately.
+	 */
+	start = 0;
+	end = LLONG_MAX;
+	maxbytes = (u64)fhp->fh_dentry->d_sb->s_maxbytes;
+	if (offset < maxbytes) {
+		start = offset;
+		if (count && (offset + count - 1 < maxbytes))
+			end = offset + count - 1;
+	}
+
+	nn = net_generic(nf->nf_net, nfsd_net_id);
 	if (EX_ISSYNC(fhp->fh_export)) {
 		errseq_t since = READ_ONCE(nf->nf_file->f_wb_err);
 		int err2;
 
-		err2 = vfs_fsync_range(nf->nf_file, offset, end, 0);
+		err2 = vfs_fsync_range(nf->nf_file, start, end, 0);
 		switch (err2) {
 		case 0:
-			nfsd_copy_boot_verifier(verf, net_generic(nf->nf_net,
-						nfsd_net_id));
+			nfsd_copy_boot_verifier(verf, nn);
 			err2 = filemap_check_wb_err(nf->nf_file->f_mapping,
 						    since);
 			err = nfserrno(err2);
@@ -1154,13 +1174,11 @@ nfsd_commit(struct svc_rqst *rqstp, struct svc_fh *fhp,
 			err = nfserr_notsupp;
 			break;
 		default:
-			nfsd_reset_boot_verifier(net_generic(nf->nf_net,
-						 nfsd_net_id));
+			nfsd_reset_boot_verifier(nn);
 			err = nfserrno(err2);
 		}
 	} else
-		nfsd_copy_boot_verifier(verf, net_generic(nf->nf_net,
-					nfsd_net_id));
+		nfsd_copy_boot_verifier(verf, nn);
 
 	nfsd_file_put(nf);
 out:
diff --git a/fs/nfsd/vfs.h b/fs/nfsd/vfs.h
index b21b76e6b9a8..3cf5a8a13da5 100644
--- a/fs/nfsd/vfs.h
+++ b/fs/nfsd/vfs.h
@@ -73,8 +73,8 @@ __be32		do_nfsd_create(struct svc_rqst *, struct svc_fh *,
 				char *name, int len, struct iattr *attrs,
 				struct svc_fh *res, int createmode,
 				u32 *verifier, bool *truncp, bool *created);
-__be32		nfsd_commit(struct svc_rqst *, struct svc_fh *,
-				loff_t, unsigned long, __be32 *verf);
+__be32		nfsd_commit(struct svc_rqst *rqst, struct svc_fh *fhp,
+				u64 offset, u32 count, __be32 *verf);
 #endif /* CONFIG_NFSD_V3 */
 #ifdef CONFIG_NFSD_V4
 __be32		nfsd_getxattr(struct svc_rqst *rqstp, struct svc_fh *fhp,
diff --git a/fs/seq_file.c b/fs/seq_file.c
index 4a2cda04d3e2..b17ee4c4f618 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -947,6 +947,38 @@ struct list_head *seq_list_next(void *v, struct list_head *head, loff_t *ppos)
 }
 EXPORT_SYMBOL(seq_list_next);
 
+struct list_head *seq_list_start_rcu(struct list_head *head, loff_t pos)
+{
+	struct list_head *lh;
+
+	list_for_each_rcu(lh, head)
+		if (pos-- == 0)
+			return lh;
+
+	return NULL;
+}
+EXPORT_SYMBOL(seq_list_start_rcu);
+
+struct list_head *seq_list_start_head_rcu(struct list_head *head, loff_t pos)
+{
+	if (!pos)
+		return head;
+
+	return seq_list_start_rcu(head, pos - 1);
+}
+EXPORT_SYMBOL(seq_list_start_head_rcu);
+
+struct list_head *seq_list_next_rcu(void *v, struct list_head *head,
+				    loff_t *ppos)
+{
+	struct list_head *lh;
+
+	lh = list_next_rcu((struct list_head *)v);
+	++*ppos;
+	return lh == head ? NULL : lh;
+}
+EXPORT_SYMBOL(seq_list_next_rcu);
+
 /**
  * seq_hlist_start - start an iteration of a hlist
  * @head: the head of the hlist
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 2477e301fa82..c19f3ca605af 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3128,7 +3128,6 @@ xfs_rename(
 	 * appropriately.
 	 */
 	if (flags & RENAME_WHITEOUT) {
-		ASSERT(!(flags & (RENAME_NOREPLACE | RENAME_EXCHANGE)));
 		error = xfs_rename_alloc_whiteout(mnt_userns, target_dp, &wip);
 		if (error)
 			return error;
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 17c92c0f15b2..36ce3d0fb9f3 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -294,7 +294,8 @@ enum {
 	BIO_TRACE_COMPLETION,	/* bio_endio() should trace the final completion
 				 * of this bio. */
 	BIO_CGROUP_ACCT,	/* has been accounted to a cgroup */
-	BIO_TRACKED,		/* set if bio goes through the rq_qos path */
+	BIO_QOS_THROTTLED,	/* bio went through rq_qos throttle path */
+	BIO_QOS_MERGED,		/* but went through rq_qos merge path */
 	BIO_REMAPPED,
 	BIO_ZONE_WRITE_LOCKED,	/* Owns a zoned device zone write lock */
 	BIO_PERCPU_CACHE,	/* can participate in per-cpu alloc cache */
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index bb766a0b9b51..818cd594e922 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -533,6 +533,12 @@ bpf_ctx_record_field_size(struct bpf_insn_access_aux *aux, u32 size)
 	aux->ctx_field_size = size;
 }
 
+static inline bool bpf_pseudo_func(const struct bpf_insn *insn)
+{
+	return insn->code == (BPF_LD | BPF_IMM | BPF_DW) &&
+	       insn->src_reg == BPF_PSEUDO_FUNC;
+}
+
 struct bpf_prog_ops {
 	int (*test_run)(struct bpf_prog *prog, const union bpf_attr *kattr,
 			union bpf_attr __user *uattr);
diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index bd2b881c6b63..b9d5f9c373a0 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -144,3 +144,11 @@
 #else
 #define __diag_GCC_8(s)
 #endif
+
+/*
+ * Prior to 9.1, -Wno-alloc-size-larger-than (and therefore the "alloc_size"
+ * attribute) do not work, and must be disabled.
+ */
+#if GCC_VERSION < 90100
+#undef __alloc_size__
+#endif
diff --git a/include/linux/compiler_attributes.h b/include/linux/compiler_attributes.h
index e6ec63403965..3de06a8fae73 100644
--- a/include/linux/compiler_attributes.h
+++ b/include/linux/compiler_attributes.h
@@ -33,6 +33,15 @@
 #define __aligned(x)                    __attribute__((__aligned__(x)))
 #define __aligned_largest               __attribute__((__aligned__))
 
+/*
+ * Note: do not use this directly. Instead, use __alloc_size() since it is conditionally
+ * available and includes other attributes.
+ *
+ *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-alloc_005fsize-function-attribute
+ * clang: https://clang.llvm.org/docs/AttributeReference.html#alloc-size
+ */
+#define __alloc_size__(x, ...)		__attribute__((__alloc_size__(x, ## __VA_ARGS__)))
+
 /*
  * Note: users of __always_inline currently do not write "inline" themselves,
  * which seems to be required by gcc to apply the attribute according
@@ -153,6 +162,7 @@
 
 /*
  *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-malloc-function-attribute
+ * clang: https://clang.llvm.org/docs/AttributeReference.html#malloc
  */
 #define __malloc                        __attribute__((__malloc__))
 
diff --git a/include/linux/compiler_types.h b/include/linux/compiler_types.h
index b6ff83a714ca..4f2203c4a257 100644
--- a/include/linux/compiler_types.h
+++ b/include/linux/compiler_types.h
@@ -250,6 +250,18 @@ struct ftrace_likely_data {
 # define __cficanonical
 #endif
 
+/*
+ * Any place that could be marked with the "alloc_size" attribute is also
+ * a place to be marked with the "malloc" attribute. Do this as part of the
+ * __alloc_size macro to avoid redundant attributes and to avoid missing a
+ * __malloc marking.
+ */
+#ifdef __alloc_size__
+# define __alloc_size(x, ...)	__alloc_size__(x, ## __VA_ARGS__) __malloc
+#else
+# define __alloc_size(x, ...)	__malloc
+#endif
+
 #ifndef asm_volatile_goto
 #define asm_volatile_goto(x...) asm goto(x)
 #endif
diff --git a/include/linux/fbcon.h b/include/linux/fbcon.h
index ff5596dd30f8..2382dec6d6ab 100644
--- a/include/linux/fbcon.h
+++ b/include/linux/fbcon.h
@@ -15,6 +15,8 @@ void fbcon_new_modelist(struct fb_info *info);
 void fbcon_get_requirement(struct fb_info *info,
 			   struct fb_blit_caps *caps);
 void fbcon_fb_blanked(struct fb_info *info, int blank);
+int  fbcon_modechange_possible(struct fb_info *info,
+			       struct fb_var_screeninfo *var);
 void fbcon_update_vcs(struct fb_info *info, bool all);
 void fbcon_remap_all(struct fb_info *info);
 int fbcon_set_con2fb_map_ioctl(void __user *argp);
@@ -33,6 +35,8 @@ static inline void fbcon_new_modelist(struct fb_info *info) {}
 static inline void fbcon_get_requirement(struct fb_info *info,
 					 struct fb_blit_caps *caps) {}
 static inline void fbcon_fb_blanked(struct fb_info *info, int blank) {}
+static inline int  fbcon_modechange_possible(struct fb_info *info,
+				struct fb_var_screeninfo *var) { return 0; }
 static inline void fbcon_update_vcs(struct fb_info *info, bool all) {}
 static inline void fbcon_remap_all(struct fb_info *info) {}
 static inline int fbcon_set_con2fb_map_ioctl(void __user *argp) { return 0; }
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 1faebe1cd0ed..22c1d935e22d 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -167,6 +167,7 @@ long hugetlb_unreserve_pages(struct inode *inode, long start, long end,
 						long freed);
 bool isolate_huge_page(struct page *page, struct list_head *list);
 int get_hwpoison_huge_page(struct page *page, bool *hugetlb);
+int get_huge_page_for_hwpoison(unsigned long pfn, int flags);
 void putback_active_hugepage(struct page *page);
 void move_hugetlb_state(struct page *oldpage, struct page *newpage, int reason);
 void free_huge_page(struct page *page);
@@ -362,6 +363,11 @@ static inline int get_hwpoison_huge_page(struct page *page, bool *hugetlb)
 	return 0;
 }
 
+static inline int get_huge_page_for_hwpoison(unsigned long pfn, int flags)
+{
+	return 0;
+}
+
 static inline void putback_active_hugepage(struct page *page)
 {
 }
diff --git a/include/linux/list.h b/include/linux/list.h
index a119dd1990d4..d206ae93c06d 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -577,6 +577,16 @@ static inline void list_splice_tail_init(struct list_head *list,
 #define list_for_each(pos, head) \
 	for (pos = (head)->next; !list_is_head(pos, (head)); pos = pos->next)
 
+/**
+ * list_for_each_rcu - Iterate over a list in an RCU-safe fashion
+ * @pos:	the &struct list_head to use as a loop cursor.
+ * @head:	the head for your list.
+ */
+#define list_for_each_rcu(pos, head)		  \
+	for (pos = rcu_dereference((head)->next); \
+	     !list_is_head(pos, (head)); \
+	     pos = rcu_dereference(pos->next))
+
 /**
  * list_for_each_continue - continue iteration over a list
  * @pos:	the &struct list_head to use as a loop cursor.
diff --git a/include/linux/memregion.h b/include/linux/memregion.h
index e11595256cac..c04c4fd2e209 100644
--- a/include/linux/memregion.h
+++ b/include/linux/memregion.h
@@ -16,7 +16,7 @@ static inline int memregion_alloc(gfp_t gfp)
 {
 	return -ENOMEM;
 }
-void memregion_free(int id)
+static inline void memregion_free(int id)
 {
 }
 #endif
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 85205adcdd0d..e4e1817bb3b8 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3132,6 +3132,14 @@ extern int sysctl_memory_failure_recovery;
 extern void shake_page(struct page *p);
 extern atomic_long_t num_poisoned_pages __read_mostly;
 extern int soft_offline_page(unsigned long pfn, int flags);
+#ifdef CONFIG_MEMORY_FAILURE
+extern int __get_huge_page_for_hwpoison(unsigned long pfn, int flags);
+#else
+static inline int __get_huge_page_for_hwpoison(unsigned long pfn, int flags)
+{
+	return 0;
+}
+#endif
 
 
 /*
diff --git a/include/linux/pm_runtime.h b/include/linux/pm_runtime.h
index 016de5776b6d..90eaff8b78fc 100644
--- a/include/linux/pm_runtime.h
+++ b/include/linux/pm_runtime.h
@@ -58,7 +58,7 @@ extern void pm_runtime_get_suppliers(struct device *dev);
 extern void pm_runtime_put_suppliers(struct device *dev);
 extern void pm_runtime_new_link(struct device *dev);
 extern void pm_runtime_drop_link(struct device_link *link);
-extern void pm_runtime_release_supplier(struct device_link *link, bool check_idle);
+extern void pm_runtime_release_supplier(struct device_link *link);
 
 extern int devm_pm_runtime_enable(struct device *dev);
 
@@ -284,8 +284,7 @@ static inline void pm_runtime_get_suppliers(struct device *dev) {}
 static inline void pm_runtime_put_suppliers(struct device *dev) {}
 static inline void pm_runtime_new_link(struct device *dev) {}
 static inline void pm_runtime_drop_link(struct device_link *link) {}
-static inline void pm_runtime_release_supplier(struct device_link *link,
-					       bool check_idle) {}
+static inline void pm_runtime_release_supplier(struct device_link *link) {}
 
 #endif /* !CONFIG_PM */
 
diff --git a/include/linux/qed/qed_eth_if.h b/include/linux/qed/qed_eth_if.h
index 812a4d751163..4df0bf0a0864 100644
--- a/include/linux/qed/qed_eth_if.h
+++ b/include/linux/qed/qed_eth_if.h
@@ -145,12 +145,6 @@ struct qed_filter_mcast_params {
 	unsigned char mac[64][ETH_ALEN];
 };
 
-union qed_filter_type_params {
-	enum qed_filter_rx_mode_type accept_flags;
-	struct qed_filter_ucast_params ucast;
-	struct qed_filter_mcast_params mcast;
-};
-
 enum qed_filter_type {
 	QED_FILTER_TYPE_UCAST,
 	QED_FILTER_TYPE_MCAST,
@@ -158,11 +152,6 @@ enum qed_filter_type {
 	QED_MAX_FILTER_TYPES,
 };
 
-struct qed_filter_params {
-	enum qed_filter_type type;
-	union qed_filter_type_params filter;
-};
-
 struct qed_tunn_params {
 	u16 vxlan_port;
 	u8 update_vxlan_port;
@@ -314,8 +303,14 @@ struct qed_eth_ops {
 
 	int (*q_tx_stop)(struct qed_dev *cdev, u8 rss_id, void *handle);
 
-	int (*filter_config)(struct qed_dev *cdev,
-			     struct qed_filter_params *params);
+	int (*filter_config_rx_mode)(struct qed_dev *cdev,
+				     enum qed_filter_rx_mode_type type);
+
+	int (*filter_config_ucast)(struct qed_dev *cdev,
+				   struct qed_filter_ucast_params *params);
+
+	int (*filter_config_mcast)(struct qed_dev *cdev,
+				   struct qed_filter_mcast_params *params);
 
 	int (*fastpath_stop)(struct qed_dev *cdev);
 
diff --git a/include/linux/rtsx_usb.h b/include/linux/rtsx_usb.h
index 159729cffd8e..3247ed8e9ff0 100644
--- a/include/linux/rtsx_usb.h
+++ b/include/linux/rtsx_usb.h
@@ -54,8 +54,6 @@ struct rtsx_ucr {
 	struct usb_device	*pusb_dev;
 	struct usb_interface	*pusb_intf;
 	struct usb_sg_request	current_sg;
-	unsigned char		*iobuf;
-	dma_addr_t		iobuf_dma;
 
 	struct timer_list	sg_timer;
 	struct mutex		dev_mutex;
diff --git a/include/linux/seq_file.h b/include/linux/seq_file.h
index 5733890df64f..0b429111f85e 100644
--- a/include/linux/seq_file.h
+++ b/include/linux/seq_file.h
@@ -261,6 +261,10 @@ extern struct list_head *seq_list_start_head(struct list_head *head,
 extern struct list_head *seq_list_next(void *v, struct list_head *head,
 		loff_t *ppos);
 
+extern struct list_head *seq_list_start_rcu(struct list_head *head, loff_t pos);
+extern struct list_head *seq_list_start_head_rcu(struct list_head *head, loff_t pos);
+extern struct list_head *seq_list_next_rcu(void *v, struct list_head *head, loff_t *ppos);
+
 /*
  * Helpers for iteration over hlist_head-s in seq_files
  */
diff --git a/include/linux/stddef.h b/include/linux/stddef.h
index 998a4ba28eba..31fdbb784c24 100644
--- a/include/linux/stddef.h
+++ b/include/linux/stddef.h
@@ -36,4 +36,65 @@ enum {
 #define offsetofend(TYPE, MEMBER) \
 	(offsetof(TYPE, MEMBER)	+ sizeof_field(TYPE, MEMBER))
 
+/**
+ * struct_group() - Wrap a set of declarations in a mirrored struct
+ *
+ * @NAME: The identifier name of the mirrored sub-struct
+ * @MEMBERS: The member declarations for the mirrored structs
+ *
+ * Used to create an anonymous union of two structs with identical
+ * layout and size: one anonymous and one named. The former can be
+ * used normally without sub-struct naming, and the latter can be
+ * used to reason about the start, end, and size of the group of
+ * struct members.
+ */
+#define struct_group(NAME, MEMBERS...)	\
+	__struct_group(/* no tag */, NAME, /* no attrs */, MEMBERS)
+
+/**
+ * struct_group_attr() - Create a struct_group() with trailing attributes
+ *
+ * @NAME: The identifier name of the mirrored sub-struct
+ * @ATTRS: Any struct attributes to apply
+ * @MEMBERS: The member declarations for the mirrored structs
+ *
+ * Used to create an anonymous union of two structs with identical
+ * layout and size: one anonymous and one named. The former can be
+ * used normally without sub-struct naming, and the latter can be
+ * used to reason about the start, end, and size of the group of
+ * struct members. Includes structure attributes argument.
+ */
+#define struct_group_attr(NAME, ATTRS, MEMBERS...) \
+	__struct_group(/* no tag */, NAME, ATTRS, MEMBERS)
+
+/**
+ * struct_group_tagged() - Create a struct_group with a reusable tag
+ *
+ * @TAG: The tag name for the named sub-struct
+ * @NAME: The identifier name of the mirrored sub-struct
+ * @MEMBERS: The member declarations for the mirrored structs
+ *
+ * Used to create an anonymous union of two structs with identical
+ * layout and size: one anonymous and one named. The former can be
+ * used normally without sub-struct naming, and the latter can be
+ * used to reason about the start, end, and size of the group of
+ * struct members. Includes struct tag argument for the named copy,
+ * so the specified layout can be reused later.
+ */
+#define struct_group_tagged(TAG, NAME, MEMBERS...) \
+	__struct_group(TAG, NAME, /* no attrs */, MEMBERS)
+
+/**
+ * DECLARE_FLEX_ARRAY() - Declare a flexible array usable in a union
+ *
+ * @TYPE: The type of each flexible array element
+ * @NAME: The name of the flexible array member
+ *
+ * In order to have a flexible array member in a union or alone in a
+ * struct, it needs to be wrapped in an anonymous struct with at least 1
+ * named member, but that member can be empty.
+ */
+#define DECLARE_FLEX_ARRAY(TYPE, NAME) \
+	__DECLARE_FLEX_ARRAY(TYPE, NAME)
+
 #endif
diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index 4fe9e885bbfa..5535be1012a2 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -159,6 +159,11 @@ void *__vmalloc_node(unsigned long size, unsigned long align, gfp_t gfp_mask,
 		int node, const void *caller);
 void *vmalloc_no_huge(unsigned long size);
 
+extern void *__vmalloc_array(size_t n, size_t size, gfp_t flags) __alloc_size(1, 2);
+extern void *vmalloc_array(size_t n, size_t size) __alloc_size(1, 2);
+extern void *__vcalloc(size_t n, size_t size, gfp_t flags) __alloc_size(1, 2);
+extern void *vcalloc(size_t n, size_t size) __alloc_size(1, 2);
+
 extern void vfree(const void *addr);
 extern void vfree_atomic(const void *addr);
 
diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 2af1c2c64128..bcfee89012a1 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -21,13 +21,19 @@ struct module;
 
 #define NFT_JUMP_STACK_SIZE	16
 
+enum {
+	NFT_PKTINFO_L4PROTO	= (1 << 0),
+	NFT_PKTINFO_INNER	= (1 << 1),
+};
+
 struct nft_pktinfo {
 	struct sk_buff			*skb;
 	const struct nf_hook_state	*state;
-	bool				tprot_set;
+	u8				flags;
 	u8				tprot;
 	u16				fragoff;
 	unsigned int			thoff;
+	unsigned int			inneroff;
 };
 
 static inline struct sock *nft_sk(const struct nft_pktinfo *pkt)
@@ -75,7 +81,7 @@ static inline void nft_set_pktinfo(struct nft_pktinfo *pkt,
 
 static inline void nft_set_pktinfo_unspec(struct nft_pktinfo *pkt)
 {
-	pkt->tprot_set = false;
+	pkt->flags = 0;
 	pkt->tprot = 0;
 	pkt->thoff = 0;
 	pkt->fragoff = 0;
diff --git a/include/net/netfilter/nf_tables_ipv4.h b/include/net/netfilter/nf_tables_ipv4.h
index eb4c094cd54d..c4a6147b0ef8 100644
--- a/include/net/netfilter/nf_tables_ipv4.h
+++ b/include/net/netfilter/nf_tables_ipv4.h
@@ -10,7 +10,7 @@ static inline void nft_set_pktinfo_ipv4(struct nft_pktinfo *pkt)
 	struct iphdr *ip;
 
 	ip = ip_hdr(pkt->skb);
-	pkt->tprot_set = true;
+	pkt->flags = NFT_PKTINFO_L4PROTO;
 	pkt->tprot = ip->protocol;
 	pkt->thoff = ip_hdrlen(pkt->skb);
 	pkt->fragoff = ntohs(ip->frag_off) & IP_OFFSET;
@@ -36,7 +36,7 @@ static inline int __nft_set_pktinfo_ipv4_validate(struct nft_pktinfo *pkt)
 	else if (len < thoff)
 		return -1;
 
-	pkt->tprot_set = true;
+	pkt->flags = NFT_PKTINFO_L4PROTO;
 	pkt->tprot = iph->protocol;
 	pkt->thoff = thoff;
 	pkt->fragoff = ntohs(iph->frag_off) & IP_OFFSET;
@@ -71,7 +71,7 @@ static inline int nft_set_pktinfo_ipv4_ingress(struct nft_pktinfo *pkt)
 		goto inhdr_error;
 	}
 
-	pkt->tprot_set = true;
+	pkt->flags = NFT_PKTINFO_L4PROTO;
 	pkt->tprot = iph->protocol;
 	pkt->thoff = thoff;
 	pkt->fragoff = ntohs(iph->frag_off) & IP_OFFSET;
@@ -82,4 +82,5 @@ static inline int nft_set_pktinfo_ipv4_ingress(struct nft_pktinfo *pkt)
 	__IP_INC_STATS(nft_net(pkt), IPSTATS_MIB_INHDRERRORS);
 	return -1;
 }
+
 #endif
diff --git a/include/net/netfilter/nf_tables_ipv6.h b/include/net/netfilter/nf_tables_ipv6.h
index 7595e02b00ba..ec7eaeaf4f04 100644
--- a/include/net/netfilter/nf_tables_ipv6.h
+++ b/include/net/netfilter/nf_tables_ipv6.h
@@ -18,7 +18,7 @@ static inline void nft_set_pktinfo_ipv6(struct nft_pktinfo *pkt)
 		return;
 	}
 
-	pkt->tprot_set = true;
+	pkt->flags = NFT_PKTINFO_L4PROTO;
 	pkt->tprot = protohdr;
 	pkt->thoff = thoff;
 	pkt->fragoff = frag_off;
@@ -50,7 +50,7 @@ static inline int __nft_set_pktinfo_ipv6_validate(struct nft_pktinfo *pkt)
 	if (protohdr < 0)
 		return -1;
 
-	pkt->tprot_set = true;
+	pkt->flags = NFT_PKTINFO_L4PROTO;
 	pkt->tprot = protohdr;
 	pkt->thoff = thoff;
 	pkt->fragoff = frag_off;
@@ -96,7 +96,7 @@ static inline int nft_set_pktinfo_ipv6_ingress(struct nft_pktinfo *pkt)
 	if (protohdr < 0)
 		goto inhdr_error;
 
-	pkt->tprot_set = true;
+	pkt->flags = NFT_PKTINFO_L4PROTO;
 	pkt->tprot = protohdr;
 	pkt->thoff = thoff;
 	pkt->fragoff = frag_off;
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index e94d1fa554cb..07871c8a0601 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -753,11 +753,13 @@ enum nft_dynset_attributes {
  * @NFT_PAYLOAD_LL_HEADER: link layer header
  * @NFT_PAYLOAD_NETWORK_HEADER: network header
  * @NFT_PAYLOAD_TRANSPORT_HEADER: transport header
+ * @NFT_PAYLOAD_INNER_HEADER: inner header / payload
  */
 enum nft_payload_bases {
 	NFT_PAYLOAD_LL_HEADER,
 	NFT_PAYLOAD_NETWORK_HEADER,
 	NFT_PAYLOAD_TRANSPORT_HEADER,
+	NFT_PAYLOAD_INNER_HEADER,
 };
 
 /**
diff --git a/include/uapi/linux/omap3isp.h b/include/uapi/linux/omap3isp.h
index 87b55755f4ff..d9db7ad43890 100644
--- a/include/uapi/linux/omap3isp.h
+++ b/include/uapi/linux/omap3isp.h
@@ -162,6 +162,7 @@ struct omap3isp_h3a_aewb_config {
  * struct omap3isp_stat_data - Statistic data sent to or received from user
  * @ts: Timestamp of returned framestats.
  * @buf: Pointer to pass to user.
+ * @buf_size: Size of buffer.
  * @frame_number: Frame number of requested stats.
  * @cur_frame: Current frame number being processed.
  * @config_counter: Number of the configuration associated with the data.
@@ -176,10 +177,12 @@ struct omap3isp_stat_data {
 	struct timeval ts;
 #endif
 	void __user *buf;
-	__u32 buf_size;
-	__u16 frame_number;
-	__u16 cur_frame;
-	__u16 config_counter;
+	__struct_group(/* no tag */, frame, /* no attrs */,
+		__u32 buf_size;
+		__u16 frame_number;
+		__u16 cur_frame;
+		__u16 config_counter;
+	);
 };
 
 #ifdef __KERNEL__
@@ -189,10 +192,12 @@ struct omap3isp_stat_data_time32 {
 		__s32	tv_usec;
 	} ts;
 	__u32 buf;
-	__u32 buf_size;
-	__u16 frame_number;
-	__u16 cur_frame;
-	__u16 config_counter;
+	__struct_group(/* no tag */, frame, /* no attrs */,
+		__u32 buf_size;
+		__u16 frame_number;
+		__u16 cur_frame;
+		__u16 config_counter;
+	);
 };
 #endif
 
diff --git a/include/uapi/linux/stddef.h b/include/uapi/linux/stddef.h
index ee8220f8dcf5..7837ba4fe728 100644
--- a/include/uapi/linux/stddef.h
+++ b/include/uapi/linux/stddef.h
@@ -1,6 +1,47 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _UAPI_LINUX_STDDEF_H
+#define _UAPI_LINUX_STDDEF_H
+
 #include <linux/compiler_types.h>
 
 #ifndef __always_inline
 #define __always_inline inline
 #endif
+
+/**
+ * __struct_group() - Create a mirrored named and anonyomous struct
+ *
+ * @TAG: The tag name for the named sub-struct (usually empty)
+ * @NAME: The identifier name of the mirrored sub-struct
+ * @ATTRS: Any struct attributes (usually empty)
+ * @MEMBERS: The member declarations for the mirrored structs
+ *
+ * Used to create an anonymous union of two structs with identical layout
+ * and size: one anonymous and one named. The former's members can be used
+ * normally without sub-struct naming, and the latter can be used to
+ * reason about the start, end, and size of the group of struct members.
+ * The named struct can also be explicitly tagged for layer reuse, as well
+ * as both having struct attributes appended.
+ */
+#define __struct_group(TAG, NAME, ATTRS, MEMBERS...) \
+	union { \
+		struct { MEMBERS } ATTRS; \
+		struct TAG { MEMBERS } ATTRS NAME; \
+	}
+
+/**
+ * __DECLARE_FLEX_ARRAY() - Declare a flexible array usable in a union
+ *
+ * @TYPE: The type of each flexible array element
+ * @NAME: The name of the flexible array member
+ *
+ * In order to have a flexible array member in a union or alone in a
+ * struct, it needs to be wrapped in an anonymous struct with at least 1
+ * named member, but that member can be empty.
+ */
+#define __DECLARE_FLEX_ARRAY(TYPE, NAME)	\
+	struct { \
+		struct { } __empty_ ## NAME; \
+		TYPE NAME[]; \
+	}
+#endif
diff --git a/include/video/of_display_timing.h b/include/video/of_display_timing.h
index e1126a74882a..eff166fdd81b 100644
--- a/include/video/of_display_timing.h
+++ b/include/video/of_display_timing.h
@@ -8,6 +8,8 @@
 #ifndef __LINUX_OF_DISPLAY_TIMING_H
 #define __LINUX_OF_DISPLAY_TIMING_H
 
+#include <linux/errno.h>
+
 struct device_node;
 struct display_timing;
 struct display_timings;
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 48eb9c329da6..15946c11524e 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -389,6 +389,13 @@ static int bpf_adj_branches(struct bpf_prog *prog, u32 pos, s32 end_old,
 			i = end_new;
 			insn = prog->insnsi + end_old;
 		}
+		if (bpf_pseudo_func(insn)) {
+			ret = bpf_adj_delta_to_imm(insn, pos, end_old,
+						   end_new, i, probe_pass);
+			if (ret)
+				return ret;
+			continue;
+		}
 		code = insn->code;
 		if ((BPF_CLASS(code) != BPF_JMP &&
 		     BPF_CLASS(code) != BPF_JMP32) ||
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 25ee8d9572c6..346d36c905a9 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -240,12 +240,6 @@ static bool bpf_pseudo_kfunc_call(const struct bpf_insn *insn)
 	       insn->src_reg == BPF_PSEUDO_KFUNC_CALL;
 }
 
-static bool bpf_pseudo_func(const struct bpf_insn *insn)
-{
-	return insn->code == (BPF_LD | BPF_IMM | BPF_DW) &&
-	       insn->src_reg == BPF_PSEUDO_FUNC;
-}
-
 struct bpf_call_arg_meta {
 	struct bpf_map *map_ptr;
 	bool raw_mode;
@@ -1333,6 +1327,21 @@ static void __reg_bound_offset(struct bpf_reg_state *reg)
 	reg->var_off = tnum_or(tnum_clear_subreg(var64_off), var32_off);
 }
 
+static void reg_bounds_sync(struct bpf_reg_state *reg)
+{
+	/* We might have learned new bounds from the var_off. */
+	__update_reg_bounds(reg);
+	/* We might have learned something about the sign bit. */
+	__reg_deduce_bounds(reg);
+	/* We might have learned some bits from the bounds. */
+	__reg_bound_offset(reg);
+	/* Intersecting with the old var_off might have improved our bounds
+	 * slightly, e.g. if umax was 0x7f...f and var_off was (0; 0xf...fc),
+	 * then new var_off is (0; 0x7f...fc) which improves our umax.
+	 */
+	__update_reg_bounds(reg);
+}
+
 static bool __reg32_bound_s64(s32 a)
 {
 	return a >= 0 && a <= S32_MAX;
@@ -1374,16 +1383,8 @@ static void __reg_combine_32_into_64(struct bpf_reg_state *reg)
 		 * so they do not impact tnum bounds calculation.
 		 */
 		__mark_reg64_unbounded(reg);
-		__update_reg_bounds(reg);
 	}
-
-	/* Intersecting with the old var_off might have improved our bounds
-	 * slightly.  e.g. if umax was 0x7f...f and var_off was (0; 0xf...fc),
-	 * then new var_off is (0; 0x7f...fc) which improves our umax.
-	 */
-	__reg_deduce_bounds(reg);
-	__reg_bound_offset(reg);
-	__update_reg_bounds(reg);
+	reg_bounds_sync(reg);
 }
 
 static bool __reg64_bound_s32(s64 a)
@@ -1399,7 +1400,6 @@ static bool __reg64_bound_u32(u64 a)
 static void __reg_combine_64_into_32(struct bpf_reg_state *reg)
 {
 	__mark_reg32_unbounded(reg);
-
 	if (__reg64_bound_s32(reg->smin_value) && __reg64_bound_s32(reg->smax_value)) {
 		reg->s32_min_value = (s32)reg->smin_value;
 		reg->s32_max_value = (s32)reg->smax_value;
@@ -1408,14 +1408,7 @@ static void __reg_combine_64_into_32(struct bpf_reg_state *reg)
 		reg->u32_min_value = (u32)reg->umin_value;
 		reg->u32_max_value = (u32)reg->umax_value;
 	}
-
-	/* Intersecting with the old var_off might have improved our bounds
-	 * slightly.  e.g. if umax was 0x7f...f and var_off was (0; 0xf...fc),
-	 * then new var_off is (0; 0x7f...fc) which improves our umax.
-	 */
-	__reg_deduce_bounds(reg);
-	__reg_bound_offset(reg);
-	__update_reg_bounds(reg);
+	reg_bounds_sync(reg);
 }
 
 /* Mark a register as having a completely unknown (scalar) value. */
@@ -1789,16 +1782,10 @@ static int add_subprog_and_kfunc(struct bpf_verifier_env *env)
 			return -EPERM;
 		}
 
-		if (bpf_pseudo_func(insn)) {
-			ret = add_subprog(env, i + insn->imm + 1);
-			if (ret >= 0)
-				/* remember subprog */
-				insn[1].imm = ret;
-		} else if (bpf_pseudo_call(insn)) {
+		if (bpf_pseudo_func(insn) || bpf_pseudo_call(insn))
 			ret = add_subprog(env, i + insn->imm + 1);
-		} else {
+		else
 			ret = add_kfunc_call(env, insn->imm);
-		}
 
 		if (ret < 0)
 			return ret;
@@ -6054,9 +6041,7 @@ static void do_refine_retval_range(struct bpf_reg_state *regs, int ret_type,
 	ret_reg->s32_max_value = meta->msize_max_value;
 	ret_reg->smin_value = -MAX_ERRNO;
 	ret_reg->s32_min_value = -MAX_ERRNO;
-	__reg_deduce_bounds(ret_reg);
-	__reg_bound_offset(ret_reg);
-	__update_reg_bounds(ret_reg);
+	reg_bounds_sync(ret_reg);
 }
 
 static int
@@ -7216,11 +7201,7 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 
 	if (!check_reg_sane_offset(env, dst_reg, ptr_reg->type))
 		return -EINVAL;
-
-	__update_reg_bounds(dst_reg);
-	__reg_deduce_bounds(dst_reg);
-	__reg_bound_offset(dst_reg);
-
+	reg_bounds_sync(dst_reg);
 	if (sanitize_check_bounds(env, insn, dst_reg) < 0)
 		return -EACCES;
 	if (sanitize_needed(opcode)) {
@@ -7958,10 +7939,7 @@ static int adjust_scalar_min_max_vals(struct bpf_verifier_env *env,
 	/* ALU32 ops are zero extended into 64bit register */
 	if (alu32)
 		zext_32_to_64(dst_reg);
-
-	__update_reg_bounds(dst_reg);
-	__reg_deduce_bounds(dst_reg);
-	__reg_bound_offset(dst_reg);
+	reg_bounds_sync(dst_reg);
 	return 0;
 }
 
@@ -8150,10 +8128,7 @@ static int check_alu_op(struct bpf_verifier_env *env, struct bpf_insn *insn)
 							 insn->dst_reg);
 				}
 				zext_32_to_64(dst_reg);
-
-				__update_reg_bounds(dst_reg);
-				__reg_deduce_bounds(dst_reg);
-				__reg_bound_offset(dst_reg);
+				reg_bounds_sync(dst_reg);
 			}
 		} else {
 			/* case: R = imm
@@ -8591,26 +8566,33 @@ static void reg_set_min_max(struct bpf_reg_state *true_reg,
 		return;
 
 	switch (opcode) {
+	/* JEQ/JNE comparison doesn't change the register equivalence.
+	 *
+	 * r1 = r2;
+	 * if (r1 == 42) goto label;
+	 * ...
+	 * label: // here both r1 and r2 are known to be 42.
+	 *
+	 * Hence when marking register as known preserve it's ID.
+	 */
 	case BPF_JEQ:
+		if (is_jmp32) {
+			__mark_reg32_known(true_reg, val32);
+			true_32off = tnum_subreg(true_reg->var_off);
+		} else {
+			___mark_reg_known(true_reg, val);
+			true_64off = true_reg->var_off;
+		}
+		break;
 	case BPF_JNE:
-	{
-		struct bpf_reg_state *reg =
-			opcode == BPF_JEQ ? true_reg : false_reg;
-
-		/* JEQ/JNE comparison doesn't change the register equivalence.
-		 * r1 = r2;
-		 * if (r1 == 42) goto label;
-		 * ...
-		 * label: // here both r1 and r2 are known to be 42.
-		 *
-		 * Hence when marking register as known preserve it's ID.
-		 */
-		if (is_jmp32)
-			__mark_reg32_known(reg, val32);
-		else
-			___mark_reg_known(reg, val);
+		if (is_jmp32) {
+			__mark_reg32_known(false_reg, val32);
+			false_32off = tnum_subreg(false_reg->var_off);
+		} else {
+			___mark_reg_known(false_reg, val);
+			false_64off = false_reg->var_off;
+		}
 		break;
-	}
 	case BPF_JSET:
 		if (is_jmp32) {
 			false_32off = tnum_and(false_32off, tnum_const(~val32));
@@ -8749,21 +8731,8 @@ static void __reg_combine_min_max(struct bpf_reg_state *src_reg,
 							dst_reg->smax_value);
 	src_reg->var_off = dst_reg->var_off = tnum_intersect(src_reg->var_off,
 							     dst_reg->var_off);
-	/* We might have learned new bounds from the var_off. */
-	__update_reg_bounds(src_reg);
-	__update_reg_bounds(dst_reg);
-	/* We might have learned something about the sign bit. */
-	__reg_deduce_bounds(src_reg);
-	__reg_deduce_bounds(dst_reg);
-	/* We might have learned some bits from the bounds. */
-	__reg_bound_offset(src_reg);
-	__reg_bound_offset(dst_reg);
-	/* Intersecting with the old var_off might have improved our bounds
-	 * slightly.  e.g. if umax was 0x7f...f and var_off was (0; 0xf...fc),
-	 * then new var_off is (0; 0x7f...fc) which improves our umax.
-	 */
-	__update_reg_bounds(src_reg);
-	__update_reg_bounds(dst_reg);
+	reg_bounds_sync(src_reg);
+	reg_bounds_sync(dst_reg);
 }
 
 static void reg_combine_min_max(struct bpf_reg_state *true_src,
@@ -9241,7 +9210,8 @@ static int check_ld_imm(struct bpf_verifier_env *env, struct bpf_insn *insn)
 
 	if (insn->src_reg == BPF_PSEUDO_FUNC) {
 		struct bpf_prog_aux *aux = env->prog->aux;
-		u32 subprogno = insn[1].imm;
+		u32 subprogno = find_subprog(env,
+					     env->insn_idx + insn->imm + 1);
 
 		if (!aux->func_info) {
 			verbose(env, "missing btf func_info\n");
@@ -12411,14 +12381,9 @@ static int jit_subprogs(struct bpf_verifier_env *env)
 		return 0;
 
 	for (i = 0, insn = prog->insnsi; i < prog->len; i++, insn++) {
-		if (bpf_pseudo_func(insn)) {
-			env->insn_aux_data[i].call_imm = insn->imm;
-			/* subprog is encoded in insn[1].imm */
+		if (!bpf_pseudo_func(insn) && !bpf_pseudo_call(insn))
 			continue;
-		}
 
-		if (!bpf_pseudo_call(insn))
-			continue;
 		/* Upon error here we cannot fall back to interpreter but
 		 * need a hard reject of the program. Thus -EFAULT is
 		 * propagated in any case.
@@ -12439,6 +12404,12 @@ static int jit_subprogs(struct bpf_verifier_env *env)
 		env->insn_aux_data[i].call_imm = insn->imm;
 		/* point imm to __bpf_call_base+1 from JITs point of view */
 		insn->imm = 1;
+		if (bpf_pseudo_func(insn))
+			/* jit (e.g. x86_64) may emit fewer instructions
+			 * if it learns a u32 imm is the same as a u64 imm.
+			 * Force a non zero here.
+			 */
+			insn[1].imm = 1;
 	}
 
 	err = bpf_prog_alloc_jited_linfo(prog);
@@ -12522,7 +12493,7 @@ static int jit_subprogs(struct bpf_verifier_env *env)
 		insn = func[i]->insnsi;
 		for (j = 0; j < func[i]->len; j++, insn++) {
 			if (bpf_pseudo_func(insn)) {
-				subprog = insn[1].imm;
+				subprog = insn->off;
 				insn[0].imm = (u32)(long)func[subprog]->bpf_func;
 				insn[1].imm = ((u64)(long)func[subprog]->bpf_func) >> 32;
 				continue;
@@ -12574,7 +12545,8 @@ static int jit_subprogs(struct bpf_verifier_env *env)
 	for (i = 0, insn = prog->insnsi; i < prog->len; i++, insn++) {
 		if (bpf_pseudo_func(insn)) {
 			insn[0].imm = env->insn_aux_data[i].call_imm;
-			insn[1].imm = find_subprog(env, i + insn[0].imm + 1);
+			insn[1].imm = insn->off;
+			insn->off = 0;
 			continue;
 		}
 		if (!bpf_pseudo_call(insn))
diff --git a/kernel/module.c b/kernel/module.c
index 83991c2d5af9..ef79f4dbda87 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2967,14 +2967,29 @@ static int elf_validity_check(struct load_info *info)
 	Elf_Shdr *shdr, *strhdr;
 	int err;
 
-	if (info->len < sizeof(*(info->hdr)))
-		return -ENOEXEC;
+	if (info->len < sizeof(*(info->hdr))) {
+		pr_err("Invalid ELF header len %lu\n", info->len);
+		goto no_exec;
+	}
 
-	if (memcmp(info->hdr->e_ident, ELFMAG, SELFMAG) != 0
-	    || info->hdr->e_type != ET_REL
-	    || !elf_check_arch(info->hdr)
-	    || info->hdr->e_shentsize != sizeof(Elf_Shdr))
-		return -ENOEXEC;
+	if (memcmp(info->hdr->e_ident, ELFMAG, SELFMAG) != 0) {
+		pr_err("Invalid ELF header magic: != %s\n", ELFMAG);
+		goto no_exec;
+	}
+	if (info->hdr->e_type != ET_REL) {
+		pr_err("Invalid ELF header type: %u != %u\n",
+		       info->hdr->e_type, ET_REL);
+		goto no_exec;
+	}
+	if (!elf_check_arch(info->hdr)) {
+		pr_err("Invalid architecture in ELF header: %u\n",
+		       info->hdr->e_machine);
+		goto no_exec;
+	}
+	if (info->hdr->e_shentsize != sizeof(Elf_Shdr)) {
+		pr_err("Invalid ELF section header size\n");
+		goto no_exec;
+	}
 
 	/*
 	 * e_shnum is 16 bits, and sizeof(Elf_Shdr) is
@@ -2983,8 +2998,10 @@ static int elf_validity_check(struct load_info *info)
 	 */
 	if (info->hdr->e_shoff >= info->len
 	    || (info->hdr->e_shnum * sizeof(Elf_Shdr) >
-		info->len - info->hdr->e_shoff))
-		return -ENOEXEC;
+		info->len - info->hdr->e_shoff)) {
+		pr_err("Invalid ELF section header overflow\n");
+		goto no_exec;
+	}
 
 	info->sechdrs = (void *)info->hdr + info->hdr->e_shoff;
 
@@ -2992,13 +3009,19 @@ static int elf_validity_check(struct load_info *info)
 	 * Verify if the section name table index is valid.
 	 */
 	if (info->hdr->e_shstrndx == SHN_UNDEF
-	    || info->hdr->e_shstrndx >= info->hdr->e_shnum)
-		return -ENOEXEC;
+	    || info->hdr->e_shstrndx >= info->hdr->e_shnum) {
+		pr_err("Invalid ELF section name index: %d || e_shstrndx (%d) >= e_shnum (%d)\n",
+		       info->hdr->e_shstrndx, info->hdr->e_shstrndx,
+		       info->hdr->e_shnum);
+		goto no_exec;
+	}
 
 	strhdr = &info->sechdrs[info->hdr->e_shstrndx];
 	err = validate_section_offset(info, strhdr);
-	if (err < 0)
+	if (err < 0) {
+		pr_err("Invalid ELF section hdr(type %u)\n", strhdr->sh_type);
 		return err;
+	}
 
 	/*
 	 * The section name table must be NUL-terminated, as required
@@ -3006,8 +3029,14 @@ static int elf_validity_check(struct load_info *info)
 	 * strings in the section safe.
 	 */
 	info->secstrings = (void *)info->hdr + strhdr->sh_offset;
-	if (info->secstrings[strhdr->sh_size - 1] != '\0')
-		return -ENOEXEC;
+	if (strhdr->sh_size == 0) {
+		pr_err("empty section name table\n");
+		goto no_exec;
+	}
+	if (info->secstrings[strhdr->sh_size - 1] != '\0') {
+		pr_err("ELF Spec violation: section name table isn't null terminated\n");
+		goto no_exec;
+	}
 
 	/*
 	 * The code assumes that section 0 has a length of zero and
@@ -3015,8 +3044,11 @@ static int elf_validity_check(struct load_info *info)
 	 */
 	if (info->sechdrs[0].sh_type != SHT_NULL
 	    || info->sechdrs[0].sh_size != 0
-	    || info->sechdrs[0].sh_addr != 0)
-		return -ENOEXEC;
+	    || info->sechdrs[0].sh_addr != 0) {
+		pr_err("ELF Spec violation: section 0 type(%d)!=SH_NULL or non-zero len or addr\n",
+		       info->sechdrs[0].sh_type);
+		goto no_exec;
+	}
 
 	for (i = 1; i < info->hdr->e_shnum; i++) {
 		shdr = &info->sechdrs[i];
@@ -3026,8 +3058,12 @@ static int elf_validity_check(struct load_info *info)
 			continue;
 		case SHT_SYMTAB:
 			if (shdr->sh_link == SHN_UNDEF
-			    || shdr->sh_link >= info->hdr->e_shnum)
-				return -ENOEXEC;
+			    || shdr->sh_link >= info->hdr->e_shnum) {
+				pr_err("Invalid ELF sh_link!=SHN_UNDEF(%d) or (sh_link(%d) >= hdr->e_shnum(%d)\n",
+				       shdr->sh_link, shdr->sh_link,
+				       info->hdr->e_shnum);
+				goto no_exec;
+			}
 			fallthrough;
 		default:
 			err = validate_section_offset(info, shdr);
@@ -3049,6 +3085,9 @@ static int elf_validity_check(struct load_info *info)
 	}
 
 	return 0;
+
+no_exec:
+	return -ENOEXEC;
 }
 
 #define COPY_CHUNK_SIZE (16*PAGE_SIZE)
@@ -3925,10 +3964,8 @@ static int load_module(struct load_info *info, const char __user *uargs,
 	 * sections.
 	 */
 	err = elf_validity_check(info);
-	if (err) {
-		pr_err("Module has invalid ELF structures\n");
+	if (err)
 		goto free_copy;
-	}
 
 	/*
 	 * Everything checks out, so set up the section info
diff --git a/lib/idr.c b/lib/idr.c
index f4ab4f4aa3c7..7ecdfdb5309e 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -491,7 +491,8 @@ void ida_free(struct ida *ida, unsigned int id)
 	struct ida_bitmap *bitmap;
 	unsigned long flags;
 
-	BUG_ON((int)id < 0);
+	if ((int)id < 0)
+		return;
 
 	xas_lock_irqsave(&xas, flags);
 	bitmap = xas_load(&xas);
diff --git a/mm/filemap.c b/mm/filemap.c
index 00e391e75880..dbc461703ff4 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2090,7 +2090,11 @@ unsigned find_lock_entries(struct address_space *mapping, pgoff_t start,
 
 	rcu_read_lock();
 	while ((page = find_get_entry(&xas, end, XA_PRESENT))) {
+		unsigned long next_idx = xas.xa_index + 1;
+
 		if (!xa_is_value(page)) {
+			if (PageTransHuge(page))
+				next_idx = page->index + thp_nr_pages(page);
 			if (page->index < start)
 				goto put;
 			if (page->index + thp_nr_pages(page) - 1 > end)
@@ -2111,13 +2115,11 @@ unsigned find_lock_entries(struct address_space *mapping, pgoff_t start,
 put:
 		put_page(page);
 next:
-		if (!xa_is_value(page) && PageTransHuge(page)) {
-			unsigned int nr_pages = thp_nr_pages(page);
-
+		if (next_idx != xas.xa_index + 1) {
 			/* Final THP may cross MAX_LFS_FILESIZE on 32-bit */
-			xas_set(&xas, page->index + nr_pages);
-			if (xas.xa_index < nr_pages)
+			if (next_idx < xas.xa_index)
 				break;
+			xas_set(&xas, next_idx);
 		}
 	}
 	rcu_read_unlock();
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index e4c717b08cfe..eed96302897a 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6290,6 +6290,16 @@ int get_hwpoison_huge_page(struct page *page, bool *hugetlb)
 	return ret;
 }
 
+int get_huge_page_for_hwpoison(unsigned long pfn, int flags)
+{
+	int ret;
+
+	spin_lock_irq(&hugetlb_lock);
+	ret = __get_huge_page_for_hwpoison(pfn, flags);
+	spin_unlock_irq(&hugetlb_lock);
+	return ret;
+}
+
 void putback_active_hugepage(struct page *page)
 {
 	spin_lock_irq(&hugetlb_lock);
diff --git a/mm/hwpoison-inject.c b/mm/hwpoison-inject.c
index aff4d27ec235..a1d6fc3c78b9 100644
--- a/mm/hwpoison-inject.c
+++ b/mm/hwpoison-inject.c
@@ -48,7 +48,8 @@ static int hwpoison_inject(void *data, u64 val)
 
 inject:
 	pr_info("Injecting memory failure at pfn %#lx\n", pfn);
-	return memory_failure(pfn, 0);
+	err = memory_failure(pfn, 0);
+	return (err == -EOPNOTSUPP) ? 0 : err;
 }
 
 static int hwpoison_unpoison(void *data, u64 val)
diff --git a/mm/madvise.c b/mm/madvise.c
index 8e5ca01a6cc0..882767d58c27 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -968,6 +968,8 @@ static int madvise_inject_error(int behavior,
 			pr_info("Injecting memory failure for pfn %#lx at process virtual address %#lx\n",
 				 pfn, start);
 			ret = memory_failure(pfn, MF_COUNT_INCREASED);
+			if (ret == -EOPNOTSUPP)
+				ret = 0;
 		}
 
 		if (ret)
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index c3ceb7436933..c71135edd0a1 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1418,59 +1418,115 @@ static int try_to_split_thp_page(struct page *page, const char *msg)
 	return 0;
 }
 
-static int memory_failure_hugetlb(unsigned long pfn, int flags)
+/*
+ * Called from hugetlb code with hugetlb_lock held.
+ *
+ * Return values:
+ *   0             - free hugepage
+ *   1             - in-use hugepage
+ *   2             - not a hugepage
+ *   -EBUSY        - the hugepage is busy (try to retry)
+ *   -EHWPOISON    - the hugepage is already hwpoisoned
+ */
+int __get_huge_page_for_hwpoison(unsigned long pfn, int flags)
+{
+	struct page *page = pfn_to_page(pfn);
+	struct page *head = compound_head(page);
+	int ret = 2;	/* fallback to normal page handling */
+	bool count_increased = false;
+
+	if (!PageHeadHuge(head))
+		goto out;
+
+	if (flags & MF_COUNT_INCREASED) {
+		ret = 1;
+		count_increased = true;
+	} else if (HPageFreed(head) || HPageMigratable(head)) {
+		ret = get_page_unless_zero(head);
+		if (ret)
+			count_increased = true;
+	} else {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	if (TestSetPageHWPoison(head)) {
+		ret = -EHWPOISON;
+		goto out;
+	}
+
+	return ret;
+out:
+	if (count_increased)
+		put_page(head);
+	return ret;
+}
+
+#ifdef CONFIG_HUGETLB_PAGE
+/*
+ * Taking refcount of hugetlb pages needs extra care about race conditions
+ * with basic operations like hugepage allocation/free/demotion.
+ * So some of prechecks for hwpoison (pinning, and testing/setting
+ * PageHWPoison) should be done in single hugetlb_lock range.
+ */
+static int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb)
 {
-	struct page *p = pfn_to_page(pfn);
-	struct page *head = compound_head(p);
 	int res;
+	struct page *p = pfn_to_page(pfn);
+	struct page *head;
 	unsigned long page_flags;
+	bool retry = true;
 
-	if (TestSetPageHWPoison(head)) {
-		pr_err("Memory failure: %#lx: already hardware poisoned\n",
-		       pfn);
-		res = -EHWPOISON;
-		if (flags & MF_ACTION_REQUIRED)
+	*hugetlb = 1;
+retry:
+	res = get_huge_page_for_hwpoison(pfn, flags);
+	if (res == 2) { /* fallback to normal page handling */
+		*hugetlb = 0;
+		return 0;
+	} else if (res == -EHWPOISON) {
+		pr_err("Memory failure: %#lx: already hardware poisoned\n", pfn);
+		if (flags & MF_ACTION_REQUIRED) {
+			head = compound_head(p);
 			res = kill_accessing_process(current, page_to_pfn(head), flags);
+		}
+		return res;
+	} else if (res == -EBUSY) {
+		if (retry) {
+			retry = false;
+			goto retry;
+		}
+		action_result(pfn, MF_MSG_UNKNOWN, MF_IGNORED);
 		return res;
 	}
 
-	num_poisoned_pages_inc();
+	head = compound_head(p);
+	lock_page(head);
 
-	if (!(flags & MF_COUNT_INCREASED)) {
-		res = get_hwpoison_page(p, flags);
-		if (!res) {
-			lock_page(head);
-			if (hwpoison_filter(p)) {
-				if (TestClearPageHWPoison(head))
-					num_poisoned_pages_dec();
-				unlock_page(head);
-				return 0;
-			}
-			unlock_page(head);
-			res = MF_FAILED;
-			if (__page_handle_poison(p)) {
-				page_ref_inc(p);
-				res = MF_RECOVERED;
-			}
-			action_result(pfn, MF_MSG_FREE_HUGE, res);
-			return res == MF_RECOVERED ? 0 : -EBUSY;
-		} else if (res < 0) {
-			action_result(pfn, MF_MSG_UNKNOWN, MF_IGNORED);
-			return -EBUSY;
-		}
+	if (hwpoison_filter(p)) {
+		ClearPageHWPoison(head);
+		res = -EOPNOTSUPP;
+		goto out;
 	}
 
-	lock_page(head);
-	page_flags = head->flags;
+	num_poisoned_pages_inc();
 
-	if (!PageHWPoison(head)) {
-		pr_err("Memory failure: %#lx: just unpoisoned\n", pfn);
-		num_poisoned_pages_dec();
+	/*
+	 * Handling free hugepage.  The possible race with hugepage allocation
+	 * or demotion can be prevented by PageHWPoison flag.
+	 */
+	if (res == 0) {
 		unlock_page(head);
-		put_page(head);
-		return 0;
+		res = MF_FAILED;
+		if (__page_handle_poison(p)) {
+			page_ref_inc(p);
+			res = MF_RECOVERED;
+		}
+		action_result(pfn, MF_MSG_FREE_HUGE, res);
+		return res == MF_RECOVERED ? 0 : -EBUSY;
 	}
 
+	page_flags = head->flags;
+
 	/*
 	 * TODO: hwpoison for pud-sized hugetlb doesn't work right now, so
 	 * simply disable it. In order to make it work properly, we need
@@ -1497,6 +1553,12 @@ static int memory_failure_hugetlb(unsigned long pfn, int flags)
 	unlock_page(head);
 	return res;
 }
+#else
+static inline int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb)
+{
+	return 0;
+}
+#endif
 
 static int memory_failure_dev_pagemap(unsigned long pfn, int flags,
 		struct dev_pagemap *pgmap)
@@ -1533,7 +1595,7 @@ static int memory_failure_dev_pagemap(unsigned long pfn, int flags,
 		goto out;
 
 	if (hwpoison_filter(page)) {
-		rc = 0;
+		rc = -EOPNOTSUPP;
 		goto unlock;
 	}
 
@@ -1584,6 +1646,8 @@ static int memory_failure_dev_pagemap(unsigned long pfn, int flags,
 	return rc;
 }
 
+static DEFINE_MUTEX(mf_mutex);
+
 /**
  * memory_failure - Handle memory failure of a page.
  * @pfn: Page Number of the corrupted page
@@ -1600,6 +1664,10 @@ static int memory_failure_dev_pagemap(unsigned long pfn, int flags,
  *
  * Must run in process context (e.g. a work queue) with interrupts
  * enabled and no spinlocks hold.
+ *
+ * Return: 0 for successfully handled the memory error,
+ *         -EOPNOTSUPP for memory_filter() filtered the error event,
+ *         < 0(except -EOPNOTSUPP) on failure.
  */
 int memory_failure(unsigned long pfn, int flags)
 {
@@ -1610,7 +1678,7 @@ int memory_failure(unsigned long pfn, int flags)
 	int res = 0;
 	unsigned long page_flags;
 	bool retry = true;
-	static DEFINE_MUTEX(mf_mutex);
+	int hugetlb = 0;
 
 	if (!sysctl_memory_failure_recovery)
 		panic("Memory failure on page %lx", pfn);
@@ -1631,10 +1699,9 @@ int memory_failure(unsigned long pfn, int flags)
 	mutex_lock(&mf_mutex);
 
 try_again:
-	if (PageHuge(p)) {
-		res = memory_failure_hugetlb(pfn, flags);
+	res = try_memory_failure_hugetlb(pfn, flags, &hugetlb);
+	if (hugetlb)
 		goto unlock_mutex;
-	}
 
 	if (TestSetPageHWPoison(p)) {
 		pr_err("Memory failure: %#lx: already hardware poisoned\n",
@@ -1744,21 +1811,12 @@ int memory_failure(unsigned long pfn, int flags)
 	 */
 	page_flags = p->flags;
 
-	/*
-	 * unpoison always clear PG_hwpoison inside page lock
-	 */
-	if (!PageHWPoison(p)) {
-		pr_err("Memory failure: %#lx: just unpoisoned\n", pfn);
-		num_poisoned_pages_dec();
-		unlock_page(p);
-		put_page(p);
-		goto unlock_mutex;
-	}
 	if (hwpoison_filter(p)) {
 		if (TestClearPageHWPoison(p))
 			num_poisoned_pages_dec();
 		unlock_page(p);
 		put_page(p);
+		res = -EOPNOTSUPP;
 		goto unlock_mutex;
 	}
 
@@ -1934,6 +1992,7 @@ int unpoison_memory(unsigned long pfn)
 	struct page *page;
 	struct page *p;
 	int freeit = 0;
+	int ret = 0;
 	unsigned long flags = 0;
 	static DEFINE_RATELIMIT_STATE(unpoison_rs, DEFAULT_RATELIMIT_INTERVAL,
 					DEFAULT_RATELIMIT_BURST);
@@ -1944,39 +2003,30 @@ int unpoison_memory(unsigned long pfn)
 	p = pfn_to_page(pfn);
 	page = compound_head(p);
 
+	mutex_lock(&mf_mutex);
+
 	if (!PageHWPoison(p)) {
 		unpoison_pr_info("Unpoison: Page was already unpoisoned %#lx\n",
 				 pfn, &unpoison_rs);
-		return 0;
+		goto unlock_mutex;
 	}
 
 	if (page_count(page) > 1) {
 		unpoison_pr_info("Unpoison: Someone grabs the hwpoison page %#lx\n",
 				 pfn, &unpoison_rs);
-		return 0;
+		goto unlock_mutex;
 	}
 
 	if (page_mapped(page)) {
 		unpoison_pr_info("Unpoison: Someone maps the hwpoison page %#lx\n",
 				 pfn, &unpoison_rs);
-		return 0;
+		goto unlock_mutex;
 	}
 
 	if (page_mapping(page)) {
 		unpoison_pr_info("Unpoison: the hwpoison page has non-NULL mapping %#lx\n",
 				 pfn, &unpoison_rs);
-		return 0;
-	}
-
-	/*
-	 * unpoison_memory() can encounter thp only when the thp is being
-	 * worked by memory_failure() and the page lock is not held yet.
-	 * In such case, we yield to memory_failure() and make unpoison fail.
-	 */
-	if (!PageHuge(page) && PageTransHuge(page)) {
-		unpoison_pr_info("Unpoison: Memory failure is now running on %#lx\n",
-				 pfn, &unpoison_rs);
-		return 0;
+		goto unlock_mutex;
 	}
 
 	if (!get_hwpoison_page(p, flags)) {
@@ -1984,29 +2034,23 @@ int unpoison_memory(unsigned long pfn)
 			num_poisoned_pages_dec();
 		unpoison_pr_info("Unpoison: Software-unpoisoned free page %#lx\n",
 				 pfn, &unpoison_rs);
-		return 0;
+		goto unlock_mutex;
 	}
 
-	lock_page(page);
-	/*
-	 * This test is racy because PG_hwpoison is set outside of page lock.
-	 * That's acceptable because that won't trigger kernel panic. Instead,
-	 * the PG_hwpoison page will be caught and isolated on the entrance to
-	 * the free buddy page pool.
-	 */
 	if (TestClearPageHWPoison(page)) {
 		unpoison_pr_info("Unpoison: Software-unpoisoned page %#lx\n",
 				 pfn, &unpoison_rs);
 		num_poisoned_pages_dec();
 		freeit = 1;
 	}
-	unlock_page(page);
 
 	put_page(page);
 	if (freeit && !(pfn == my_zero_pfn(0) && page_count(p) == 1))
 		put_page(page);
 
-	return 0;
+unlock_mutex:
+	mutex_unlock(&mf_mutex);
+	return ret;
 }
 EXPORT_SYMBOL(unpoison_memory);
 
@@ -2187,9 +2231,12 @@ int soft_offline_page(unsigned long pfn, int flags)
 		return -EIO;
 	}
 
+	mutex_lock(&mf_mutex);
+
 	if (PageHWPoison(page)) {
 		pr_info("%s: %#lx page already poisoned\n", __func__, pfn);
 		put_ref_page(ref_page);
+		mutex_unlock(&mf_mutex);
 		return 0;
 	}
 
@@ -2208,5 +2255,7 @@ int soft_offline_page(unsigned long pfn, int flags)
 		}
 	}
 
+	mutex_unlock(&mf_mutex);
+
 	return ret;
 }
diff --git a/mm/slub.c b/mm/slub.c
index b75eebc0350e..519bbbad7b2f 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2935,6 +2935,7 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 
 	if (!freelist) {
 		c->page = NULL;
+		c->tid = next_tid(c->tid);
 		local_unlock_irqrestore(&s->cpu_slab->lock, flags);
 		stat(s, DEACTIVATE_BYPASS);
 		goto new_slab;
@@ -2967,6 +2968,7 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 	freelist = c->freelist;
 	c->page = NULL;
 	c->freelist = NULL;
+	c->tid = next_tid(c->tid);
 	local_unlock_irqrestore(&s->cpu_slab->lock, flags);
 	deactivate_slab(s, page, freelist);
 
diff --git a/mm/util.c b/mm/util.c
index 3073de05c2bd..ea04979f131e 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -698,6 +698,56 @@ static inline void *__page_rmapping(struct page *page)
 	return (void *)mapping;
 }
 
+/**
+ * __vmalloc_array - allocate memory for a virtually contiguous array.
+ * @n: number of elements.
+ * @size: element size.
+ * @flags: the type of memory to allocate (see kmalloc).
+ */
+void *__vmalloc_array(size_t n, size_t size, gfp_t flags)
+{
+	size_t bytes;
+
+	if (unlikely(check_mul_overflow(n, size, &bytes)))
+		return NULL;
+	return __vmalloc(bytes, flags);
+}
+EXPORT_SYMBOL(__vmalloc_array);
+
+/**
+ * vmalloc_array - allocate memory for a virtually contiguous array.
+ * @n: number of elements.
+ * @size: element size.
+ */
+void *vmalloc_array(size_t n, size_t size)
+{
+	return __vmalloc_array(n, size, GFP_KERNEL);
+}
+EXPORT_SYMBOL(vmalloc_array);
+
+/**
+ * __vcalloc - allocate and zero memory for a virtually contiguous array.
+ * @n: number of elements.
+ * @size: element size.
+ * @flags: the type of memory to allocate (see kmalloc).
+ */
+void *__vcalloc(size_t n, size_t size, gfp_t flags)
+{
+	return __vmalloc_array(n, size, flags | __GFP_ZERO);
+}
+EXPORT_SYMBOL(__vcalloc);
+
+/**
+ * vcalloc - allocate and zero memory for a virtually contiguous array.
+ * @n: number of elements.
+ * @size: element size.
+ */
+void *vcalloc(size_t n, size_t size)
+{
+	return __vmalloc_array(n, size, GFP_KERNEL | __GFP_ZERO);
+}
+EXPORT_SYMBOL(vcalloc);
+
 /* Neutral page->mapping pointer to address_space or anon_vma or other */
 void *page_rmapping(struct page *page)
 {
diff --git a/net/batman-adv/bridge_loop_avoidance.c b/net/batman-adv/bridge_loop_avoidance.c
index 17687848daec..11f6ef657d82 100644
--- a/net/batman-adv/bridge_loop_avoidance.c
+++ b/net/batman-adv/bridge_loop_avoidance.c
@@ -443,7 +443,7 @@ static void batadv_bla_send_claim(struct batadv_priv *bat_priv, u8 *mac,
 	batadv_add_counter(bat_priv, BATADV_CNT_RX_BYTES,
 			   skb->len + ETH_HLEN);
 
-	netif_rx_any_context(skb);
+	netif_rx(skb);
 out:
 	batadv_hardif_put(primary_if);
 }
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 5ac3aca6deeb..2337e9275863 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -1559,7 +1559,9 @@ static void hci_cc_le_clear_accept_list(struct hci_dev *hdev,
 	if (status)
 		return;
 
+	hci_dev_lock(hdev);
 	hci_bdaddr_list_clear(&hdev->le_accept_list);
+	hci_dev_unlock(hdev);
 }
 
 static void hci_cc_le_add_to_accept_list(struct hci_dev *hdev,
@@ -1577,8 +1579,10 @@ static void hci_cc_le_add_to_accept_list(struct hci_dev *hdev,
 	if (!sent)
 		return;
 
+	hci_dev_lock(hdev);
 	hci_bdaddr_list_add(&hdev->le_accept_list, &sent->bdaddr,
 			    sent->bdaddr_type);
+	hci_dev_unlock(hdev);
 }
 
 static void hci_cc_le_del_from_accept_list(struct hci_dev *hdev,
@@ -1596,8 +1600,10 @@ static void hci_cc_le_del_from_accept_list(struct hci_dev *hdev,
 	if (!sent)
 		return;
 
+	hci_dev_lock(hdev);
 	hci_bdaddr_list_del(&hdev->le_accept_list, &sent->bdaddr,
 			    sent->bdaddr_type);
+	hci_dev_unlock(hdev);
 }
 
 static void hci_cc_le_read_supported_states(struct hci_dev *hdev,
@@ -1661,9 +1667,11 @@ static void hci_cc_le_add_to_resolv_list(struct hci_dev *hdev,
 	if (!sent)
 		return;
 
+	hci_dev_lock(hdev);
 	hci_bdaddr_list_add_with_irk(&hdev->le_resolv_list, &sent->bdaddr,
 				sent->bdaddr_type, sent->peer_irk,
 				sent->local_irk);
+	hci_dev_unlock(hdev);
 }
 
 static void hci_cc_le_del_from_resolv_list(struct hci_dev *hdev,
@@ -1681,8 +1689,10 @@ static void hci_cc_le_del_from_resolv_list(struct hci_dev *hdev,
 	if (!sent)
 		return;
 
+	hci_dev_lock(hdev);
 	hci_bdaddr_list_del_with_irk(&hdev->le_resolv_list, &sent->bdaddr,
 			    sent->bdaddr_type);
+	hci_dev_unlock(hdev);
 }
 
 static void hci_cc_le_clear_resolv_list(struct hci_dev *hdev,
@@ -1695,7 +1705,9 @@ static void hci_cc_le_clear_resolv_list(struct hci_dev *hdev,
 	if (status)
 		return;
 
+	hci_dev_lock(hdev);
 	hci_bdaddr_list_clear(&hdev->le_resolv_list);
+	hci_dev_unlock(hdev);
 }
 
 static void hci_cc_le_read_resolv_list_size(struct hci_dev *hdev,
diff --git a/net/can/bcm.c b/net/can/bcm.c
index 508f67de0b80..e5ffd2bd62ab 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -100,6 +100,7 @@ static inline u64 get_u64(const struct canfd_frame *cp, int offset)
 
 struct bcm_op {
 	struct list_head list;
+	struct rcu_head rcu;
 	int ifindex;
 	canid_t can_id;
 	u32 flags;
@@ -718,10 +719,9 @@ static struct bcm_op *bcm_find_op(struct list_head *ops,
 	return NULL;
 }
 
-static void bcm_remove_op(struct bcm_op *op)
+static void bcm_free_op_rcu(struct rcu_head *rcu_head)
 {
-	hrtimer_cancel(&op->timer);
-	hrtimer_cancel(&op->thrtimer);
+	struct bcm_op *op = container_of(rcu_head, struct bcm_op, rcu);
 
 	if ((op->frames) && (op->frames != &op->sframe))
 		kfree(op->frames);
@@ -732,6 +732,14 @@ static void bcm_remove_op(struct bcm_op *op)
 	kfree(op);
 }
 
+static void bcm_remove_op(struct bcm_op *op)
+{
+	hrtimer_cancel(&op->timer);
+	hrtimer_cancel(&op->thrtimer);
+
+	call_rcu(&op->rcu, bcm_free_op_rcu);
+}
+
 static void bcm_rx_unreg(struct net_device *dev, struct bcm_op *op)
 {
 	if (op->rx_reg_dev == dev) {
@@ -757,6 +765,9 @@ static int bcm_delete_rx_op(struct list_head *ops, struct bcm_msg_head *mh,
 		if ((op->can_id == mh->can_id) && (op->ifindex == ifindex) &&
 		    (op->flags & CAN_FD_FRAME) == (mh->flags & CAN_FD_FRAME)) {
 
+			/* disable automatic timer on frame reception */
+			op->flags |= RX_NO_AUTOTIMER;
+
 			/*
 			 * Don't care if we're bound or not (due to netdev
 			 * problems) can_rx_unregister() is always a save
@@ -785,7 +796,6 @@ static int bcm_delete_rx_op(struct list_head *ops, struct bcm_msg_head *mh,
 						  bcm_rx_handler, op);
 
 			list_del(&op->list);
-			synchronize_rcu();
 			bcm_remove_op(op);
 			return 1; /* done */
 		}
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 1b4bc588f8d6..65d96439e2be 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5118,13 +5118,20 @@ static int nft_setelem_parse_data(struct nft_ctx *ctx, struct nft_set *set,
 				  struct nft_data *data,
 				  struct nlattr *attr)
 {
+	u32 dtype;
 	int err;
 
 	err = nft_data_init(ctx, data, NFT_DATA_VALUE_MAXLEN, desc, attr);
 	if (err < 0)
 		return err;
 
-	if (desc->type != NFT_DATA_VERDICT && desc->len != set->dlen) {
+	if (set->dtype == NFT_DATA_VERDICT)
+		dtype = NFT_DATA_VERDICT;
+	else
+		dtype = NFT_DATA_VALUE;
+
+	if (dtype != desc->type ||
+	    set->dlen != desc->len) {
 		nft_data_release(data, desc->type);
 		return -EINVAL;
 	}
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 907e848dbc17..d4d8f613af51 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -79,7 +79,7 @@ static bool nft_payload_fast_eval(const struct nft_expr *expr,
 	if (priv->base == NFT_PAYLOAD_NETWORK_HEADER)
 		ptr = skb_network_header(skb);
 	else {
-		if (!pkt->tprot_set)
+		if (!(pkt->flags & NFT_PKTINFO_L4PROTO))
 			return false;
 		ptr = skb_network_header(skb) + nft_thoff(pkt);
 	}
diff --git a/net/netfilter/nf_tables_trace.c b/net/netfilter/nf_tables_trace.c
index e4fe2f0780eb..84a7dea46efa 100644
--- a/net/netfilter/nf_tables_trace.c
+++ b/net/netfilter/nf_tables_trace.c
@@ -113,13 +113,13 @@ static int nf_trace_fill_pkt_info(struct sk_buff *nlskb,
 	int off = skb_network_offset(skb);
 	unsigned int len, nh_end;
 
-	nh_end = pkt->tprot_set ? nft_thoff(pkt) : skb->len;
+	nh_end = pkt->flags & NFT_PKTINFO_L4PROTO ? nft_thoff(pkt) : skb->len;
 	len = min_t(unsigned int, nh_end - skb_network_offset(skb),
 		    NFT_TRACETYPE_NETWORK_HSIZE);
 	if (trace_fill_header(nlskb, NFTA_TRACE_NETWORK_HEADER, skb, off, len))
 		return -1;
 
-	if (pkt->tprot_set) {
+	if (pkt->flags & NFT_PKTINFO_L4PROTO) {
 		len = min_t(unsigned int, skb->len - nft_thoff(pkt),
 			    NFT_TRACETYPE_TRANSPORT_HSIZE);
 		if (trace_fill_header(nlskb, NFTA_TRACE_TRANSPORT_HEADER, skb,
diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index dbe1f2e7dd9e..9e927ab4df15 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -167,7 +167,7 @@ nft_tcp_header_pointer(const struct nft_pktinfo *pkt,
 {
 	struct tcphdr *tcph;
 
-	if (pkt->tprot != IPPROTO_TCP)
+	if (pkt->tprot != IPPROTO_TCP || pkt->fragoff)
 		return NULL;
 
 	tcph = skb_header_pointer(pkt->skb, nft_thoff(pkt), sizeof(*tcph), buffer);
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 44d9b38e5f90..14412f69a34e 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -321,7 +321,7 @@ void nft_meta_get_eval(const struct nft_expr *expr,
 		nft_reg_store8(dest, nft_pf(pkt));
 		break;
 	case NFT_META_L4PROTO:
-		if (!pkt->tprot_set)
+		if (!(pkt->flags & NFT_PKTINFO_L4PROTO))
 			goto err;
 		nft_reg_store8(dest, pkt->tprot);
 		break;
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 132875cd7fff..b46e01365bd9 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -22,6 +22,7 @@
 #include <linux/icmpv6.h>
 #include <linux/ip.h>
 #include <linux/ipv6.h>
+#include <linux/ip.h>
 #include <net/sctp/checksum.h>
 
 static bool nft_payload_rebuild_vlan_hdr(const struct sk_buff *skb, int mac_off,
@@ -79,6 +80,45 @@ nft_payload_copy_vlan(u32 *d, const struct sk_buff *skb, u8 offset, u8 len)
 	return skb_copy_bits(skb, offset + mac_off, dst_u8, len) == 0;
 }
 
+static int __nft_payload_inner_offset(struct nft_pktinfo *pkt)
+{
+	unsigned int thoff = nft_thoff(pkt);
+
+	if (!(pkt->flags & NFT_PKTINFO_L4PROTO) || pkt->fragoff)
+		return -1;
+
+	switch (pkt->tprot) {
+	case IPPROTO_UDP:
+		pkt->inneroff = thoff + sizeof(struct udphdr);
+		break;
+	case IPPROTO_TCP: {
+		struct tcphdr *th, _tcph;
+
+		th = skb_header_pointer(pkt->skb, thoff, sizeof(_tcph), &_tcph);
+		if (!th)
+			return -1;
+
+		pkt->inneroff = thoff + __tcp_hdrlen(th);
+		}
+		break;
+	default:
+		return -1;
+	}
+
+	pkt->flags |= NFT_PKTINFO_INNER;
+
+	return 0;
+}
+
+static int nft_payload_inner_offset(const struct nft_pktinfo *pkt)
+{
+	if (!(pkt->flags & NFT_PKTINFO_INNER) &&
+	    __nft_payload_inner_offset((struct nft_pktinfo *)pkt) < 0)
+		return -1;
+
+	return pkt->inneroff;
+}
+
 void nft_payload_eval(const struct nft_expr *expr,
 		      struct nft_regs *regs,
 		      const struct nft_pktinfo *pkt)
@@ -108,10 +148,15 @@ void nft_payload_eval(const struct nft_expr *expr,
 		offset = skb_network_offset(skb);
 		break;
 	case NFT_PAYLOAD_TRANSPORT_HEADER:
-		if (!pkt->tprot_set)
+		if (!(pkt->flags & NFT_PKTINFO_L4PROTO) || pkt->fragoff)
 			goto err;
 		offset = nft_thoff(pkt);
 		break;
+	case NFT_PAYLOAD_INNER_HEADER:
+		offset = nft_payload_inner_offset(pkt);
+		if (offset < 0)
+			goto err;
+		break;
 	default:
 		BUG();
 	}
@@ -613,10 +658,15 @@ static void nft_payload_set_eval(const struct nft_expr *expr,
 		offset = skb_network_offset(skb);
 		break;
 	case NFT_PAYLOAD_TRANSPORT_HEADER:
-		if (!pkt->tprot_set)
+		if (!(pkt->flags & NFT_PKTINFO_L4PROTO) || pkt->fragoff)
 			goto err;
 		offset = nft_thoff(pkt);
 		break;
+	case NFT_PAYLOAD_INNER_HEADER:
+		offset = nft_payload_inner_offset(pkt);
+		if (offset < 0)
+			goto err;
+		break;
 	default:
 		BUG();
 	}
@@ -625,7 +675,8 @@ static void nft_payload_set_eval(const struct nft_expr *expr,
 	offset += priv->offset;
 
 	if ((priv->csum_type == NFT_PAYLOAD_CSUM_INET || priv->csum_flags) &&
-	    (priv->base != NFT_PAYLOAD_TRANSPORT_HEADER ||
+	    ((priv->base != NFT_PAYLOAD_TRANSPORT_HEADER &&
+	      priv->base != NFT_PAYLOAD_INNER_HEADER) ||
 	     skb->ip_summed != CHECKSUM_PARTIAL)) {
 		fsum = skb_checksum(skb, offset, priv->len, 0);
 		tsum = csum_partial(src, priv->len, 0);
@@ -646,7 +697,8 @@ static void nft_payload_set_eval(const struct nft_expr *expr,
 	if (priv->csum_type == NFT_PAYLOAD_CSUM_SCTP &&
 	    pkt->tprot == IPPROTO_SCTP &&
 	    skb->ip_summed != CHECKSUM_PARTIAL) {
-		if (nft_payload_csum_sctp(skb, nft_thoff(pkt)))
+		if (pkt->fragoff == 0 &&
+		    nft_payload_csum_sctp(skb, nft_thoff(pkt)))
 			goto err;
 	}
 
@@ -744,6 +796,7 @@ nft_payload_select_ops(const struct nft_ctx *ctx,
 	case NFT_PAYLOAD_LL_HEADER:
 	case NFT_PAYLOAD_NETWORK_HEADER:
 	case NFT_PAYLOAD_TRANSPORT_HEADER:
+	case NFT_PAYLOAD_INNER_HEADER:
 		break;
 	default:
 		return ERR_PTR(-EOPNOTSUPP);
@@ -762,7 +815,7 @@ nft_payload_select_ops(const struct nft_ctx *ctx,
 	len    = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_LEN]));
 
 	if (len <= 4 && is_power_of_2(len) && IS_ALIGNED(offset, len) &&
-	    base != NFT_PAYLOAD_LL_HEADER)
+	    base != NFT_PAYLOAD_LL_HEADER && base != NFT_PAYLOAD_INNER_HEADER)
 		return &nft_payload_fast_ops;
 	else
 		return &nft_payload_ops;
diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 2c8051d8cca6..4f9299b9dcdd 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -2124,6 +2124,32 @@ static int nft_pipapo_init(const struct nft_set *set,
 	return err;
 }
 
+/**
+ * nft_set_pipapo_match_destroy() - Destroy elements from key mapping array
+ * @set:	nftables API set representation
+ * @m:		matching data pointing to key mapping array
+ */
+static void nft_set_pipapo_match_destroy(const struct nft_set *set,
+					 struct nft_pipapo_match *m)
+{
+	struct nft_pipapo_field *f;
+	int i, r;
+
+	for (i = 0, f = m->f; i < m->field_count - 1; i++, f++)
+		;
+
+	for (r = 0; r < f->rules; r++) {
+		struct nft_pipapo_elem *e;
+
+		if (r < f->rules - 1 && f->mt[r + 1].e == f->mt[r].e)
+			continue;
+
+		e = f->mt[r].e;
+
+		nft_set_elem_destroy(set, e, true);
+	}
+}
+
 /**
  * nft_pipapo_destroy() - Free private data for set and all committed elements
  * @set:	nftables API set representation
@@ -2132,26 +2158,13 @@ static void nft_pipapo_destroy(const struct nft_set *set)
 {
 	struct nft_pipapo *priv = nft_set_priv(set);
 	struct nft_pipapo_match *m;
-	struct nft_pipapo_field *f;
-	int i, r, cpu;
+	int cpu;
 
 	m = rcu_dereference_protected(priv->match, true);
 	if (m) {
 		rcu_barrier();
 
-		for (i = 0, f = m->f; i < m->field_count - 1; i++, f++)
-			;
-
-		for (r = 0; r < f->rules; r++) {
-			struct nft_pipapo_elem *e;
-
-			if (r < f->rules - 1 && f->mt[r + 1].e == f->mt[r].e)
-				continue;
-
-			e = f->mt[r].e;
-
-			nft_set_elem_destroy(set, e, true);
-		}
+		nft_set_pipapo_match_destroy(set, m);
 
 #ifdef NFT_PIPAPO_ALIGN
 		free_percpu(m->scratch_aligned);
@@ -2165,6 +2178,11 @@ static void nft_pipapo_destroy(const struct nft_set *set)
 	}
 
 	if (priv->clone) {
+		m = priv->clone;
+
+		if (priv->dirty)
+			nft_set_pipapo_match_destroy(set, m);
+
 #ifdef NFT_PIPAPO_ALIGN
 		free_percpu(priv->clone->scratch_aligned);
 #endif
diff --git a/net/rose/rose_route.c b/net/rose/rose_route.c
index c0e04c261a15..764a726debb1 100644
--- a/net/rose/rose_route.c
+++ b/net/rose/rose_route.c
@@ -227,8 +227,8 @@ static void rose_remove_neigh(struct rose_neigh *rose_neigh)
 {
 	struct rose_neigh *s;
 
-	rose_stop_ftimer(rose_neigh);
-	rose_stop_t0timer(rose_neigh);
+	del_timer_sync(&rose_neigh->ftimer);
+	del_timer_sync(&rose_neigh->t0timer);
 
 	skb_queue_purge(&rose_neigh->queue);
 
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index dce056adb78c..f2d593e27b64 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -68,7 +68,7 @@ struct rxrpc_net {
 	struct proc_dir_entry	*proc_net;	/* Subdir in /proc/net */
 	u32			epoch;		/* Local epoch for detecting local-end reset */
 	struct list_head	calls;		/* List of calls active in this namespace */
-	rwlock_t		call_lock;	/* Lock for ->calls */
+	spinlock_t		call_lock;	/* Lock for ->calls */
 	atomic_t		nr_calls;	/* Count of allocated calls */
 
 	atomic_t		nr_conns;
diff --git a/net/rxrpc/call_accept.c b/net/rxrpc/call_accept.c
index 1ae90fb97936..8b24ffbc72ef 100644
--- a/net/rxrpc/call_accept.c
+++ b/net/rxrpc/call_accept.c
@@ -140,9 +140,9 @@ static int rxrpc_service_prealloc_one(struct rxrpc_sock *rx,
 	write_unlock(&rx->call_lock);
 
 	rxnet = call->rxnet;
-	write_lock(&rxnet->call_lock);
-	list_add_tail(&call->link, &rxnet->calls);
-	write_unlock(&rxnet->call_lock);
+	spin_lock_bh(&rxnet->call_lock);
+	list_add_tail_rcu(&call->link, &rxnet->calls);
+	spin_unlock_bh(&rxnet->call_lock);
 
 	b->call_backlog[call_head] = call;
 	smp_store_release(&b->call_backlog_head, (call_head + 1) & (size - 1));
diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index 043508fd8d8a..25c9a2cbf048 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -337,9 +337,9 @@ struct rxrpc_call *rxrpc_new_client_call(struct rxrpc_sock *rx,
 	write_unlock(&rx->call_lock);
 
 	rxnet = call->rxnet;
-	write_lock(&rxnet->call_lock);
-	list_add_tail(&call->link, &rxnet->calls);
-	write_unlock(&rxnet->call_lock);
+	spin_lock_bh(&rxnet->call_lock);
+	list_add_tail_rcu(&call->link, &rxnet->calls);
+	spin_unlock_bh(&rxnet->call_lock);
 
 	/* From this point on, the call is protected by its own lock. */
 	release_sock(&rx->sk);
@@ -631,9 +631,9 @@ void rxrpc_put_call(struct rxrpc_call *call, enum rxrpc_call_trace op)
 		ASSERTCMP(call->state, ==, RXRPC_CALL_COMPLETE);
 
 		if (!list_empty(&call->link)) {
-			write_lock(&rxnet->call_lock);
+			spin_lock_bh(&rxnet->call_lock);
 			list_del_init(&call->link);
-			write_unlock(&rxnet->call_lock);
+			spin_unlock_bh(&rxnet->call_lock);
 		}
 
 		rxrpc_cleanup_call(call);
@@ -705,7 +705,7 @@ void rxrpc_destroy_all_calls(struct rxrpc_net *rxnet)
 	_enter("");
 
 	if (!list_empty(&rxnet->calls)) {
-		write_lock(&rxnet->call_lock);
+		spin_lock_bh(&rxnet->call_lock);
 
 		while (!list_empty(&rxnet->calls)) {
 			call = list_entry(rxnet->calls.next,
@@ -720,12 +720,12 @@ void rxrpc_destroy_all_calls(struct rxrpc_net *rxnet)
 			       rxrpc_call_states[call->state],
 			       call->flags, call->events);
 
-			write_unlock(&rxnet->call_lock);
+			spin_unlock_bh(&rxnet->call_lock);
 			cond_resched();
-			write_lock(&rxnet->call_lock);
+			spin_lock_bh(&rxnet->call_lock);
 		}
 
-		write_unlock(&rxnet->call_lock);
+		spin_unlock_bh(&rxnet->call_lock);
 	}
 
 	atomic_dec(&rxnet->nr_calls);
diff --git a/net/rxrpc/net_ns.c b/net/rxrpc/net_ns.c
index cc7e30733feb..e4d6d432515b 100644
--- a/net/rxrpc/net_ns.c
+++ b/net/rxrpc/net_ns.c
@@ -50,7 +50,7 @@ static __net_init int rxrpc_init_net(struct net *net)
 	rxnet->epoch |= RXRPC_RANDOM_EPOCH;
 
 	INIT_LIST_HEAD(&rxnet->calls);
-	rwlock_init(&rxnet->call_lock);
+	spin_lock_init(&rxnet->call_lock);
 	atomic_set(&rxnet->nr_calls, 1);
 
 	atomic_set(&rxnet->nr_conns, 1);
diff --git a/net/rxrpc/proc.c b/net/rxrpc/proc.c
index e2f990754f88..5a67955cc00f 100644
--- a/net/rxrpc/proc.c
+++ b/net/rxrpc/proc.c
@@ -26,29 +26,23 @@ static const char *const rxrpc_conn_states[RXRPC_CONN__NR_STATES] = {
  */
 static void *rxrpc_call_seq_start(struct seq_file *seq, loff_t *_pos)
 	__acquires(rcu)
-	__acquires(rxnet->call_lock)
 {
 	struct rxrpc_net *rxnet = rxrpc_net(seq_file_net(seq));
 
 	rcu_read_lock();
-	read_lock(&rxnet->call_lock);
-	return seq_list_start_head(&rxnet->calls, *_pos);
+	return seq_list_start_head_rcu(&rxnet->calls, *_pos);
 }
 
 static void *rxrpc_call_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
 	struct rxrpc_net *rxnet = rxrpc_net(seq_file_net(seq));
 
-	return seq_list_next(v, &rxnet->calls, pos);
+	return seq_list_next_rcu(v, &rxnet->calls, pos);
 }
 
 static void rxrpc_call_seq_stop(struct seq_file *seq, void *v)
-	__releases(rxnet->call_lock)
 	__releases(rcu)
 {
-	struct rxrpc_net *rxnet = rxrpc_net(seq_file_net(seq));
-
-	read_unlock(&rxnet->call_lock);
 	rcu_read_unlock();
 }
 
diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index fc7fbfc1e586..ccedbbd27692 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -326,6 +326,7 @@ static void __xp_dma_unmap(struct xsk_dma_map *dma_map, unsigned long attrs)
 	for (i = 0; i < dma_map->dma_pages_cnt; i++) {
 		dma = &dma_map->dma_pages[i];
 		if (*dma) {
+			*dma &= ~XSK_NEXT_PG_CONTIG_MASK;
 			dma_unmap_page_attrs(dma_map->dev, *dma, PAGE_SIZE,
 					     DMA_BIDIRECTIONAL, attrs);
 			*dma = 0;
diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index c27d2312cfc3..88cb294dc447 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -489,7 +489,8 @@ our $Attribute	= qr{
 			____cacheline_aligned|
 			____cacheline_aligned_in_smp|
 			____cacheline_internodealigned_in_smp|
-			__weak
+			__weak|
+			__alloc_size\s*\(\s*\d+\s*(?:,\s*\d+\s*)?\)
 		  }x;
 our $Modifier;
 our $Inline	= qr{inline|__always_inline|noinline|__inline|__inline__};
diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index cfcb60737957..5d54b57ff90c 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -1245,6 +1245,13 @@ sub dump_struct($$) {
 	$members =~ s/\s*CRYPTO_MINALIGN_ATTR/ /gos;
 	$members =~ s/\s*____cacheline_aligned_in_smp/ /gos;
 	$members =~ s/\s*____cacheline_aligned/ /gos;
+	# unwrap struct_group():
+	# - first eat non-declaration parameters and rewrite for final match
+	# - then remove macro, outer parens, and trailing semicolon
+	$members =~ s/\bstruct_group\s*\(([^,]*,)/STRUCT_GROUP(/gos;
+	$members =~ s/\bstruct_group_(attr|tagged)\s*\(([^,]*,){2}/STRUCT_GROUP(/gos;
+	$members =~ s/\b__struct_group\s*\(([^,]*,){3}/STRUCT_GROUP(/gos;
+	$members =~ s/\bSTRUCT_GROUP(\(((?:(?>[^)(]+)|(?1))*)\))[^;]*;/$2/gos;
 
 	my $args = qr{([^,)]+)};
 	# replace DECLARE_BITMAP
@@ -1256,6 +1263,8 @@ sub dump_struct($$) {
 	$members =~ s/DECLARE_KFIFO\s*\($args,\s*$args,\s*$args\)/$2 \*$1/gos;
 	# replace DECLARE_KFIFO_PTR
 	$members =~ s/DECLARE_KFIFO_PTR\s*\($args,\s*$args\)/$2 \*$1/gos;
+	# replace DECLARE_FLEX_ARRAY
+	$members =~ s/(?:__)?DECLARE_FLEX_ARRAY\s*\($args,\s*$args\)/$1 $2\[\]/gos;
 	my $declaration = $members;
 
 	# Split nested struct/union elements as newer ones
diff --git a/sound/pci/cs46xx/cs46xx.c b/sound/pci/cs46xx/cs46xx.c
index bd60308769ff..8634004a606b 100644
--- a/sound/pci/cs46xx/cs46xx.c
+++ b/sound/pci/cs46xx/cs46xx.c
@@ -74,36 +74,36 @@ static int snd_card_cs46xx_probe(struct pci_dev *pci,
 	err = snd_cs46xx_create(card, pci,
 				external_amp[dev], thinkpad[dev]);
 	if (err < 0)
-		return err;
+		goto error;
 	card->private_data = chip;
 	chip->accept_valid = mmap_valid[dev];
 	err = snd_cs46xx_pcm(chip, 0);
 	if (err < 0)
-		return err;
+		goto error;
 #ifdef CONFIG_SND_CS46XX_NEW_DSP
 	err = snd_cs46xx_pcm_rear(chip, 1);
 	if (err < 0)
-		return err;
+		goto error;
 	err = snd_cs46xx_pcm_iec958(chip, 2);
 	if (err < 0)
-		return err;
+		goto error;
 #endif
 	err = snd_cs46xx_mixer(chip, 2);
 	if (err < 0)
-		return err;
+		goto error;
 #ifdef CONFIG_SND_CS46XX_NEW_DSP
 	if (chip->nr_ac97_codecs ==2) {
 		err = snd_cs46xx_pcm_center_lfe(chip, 3);
 		if (err < 0)
-			return err;
+			goto error;
 	}
 #endif
 	err = snd_cs46xx_midi(chip, 0);
 	if (err < 0)
-		return err;
+		goto error;
 	err = snd_cs46xx_start_dsp(chip);
 	if (err < 0)
-		return err;
+		goto error;
 
 	snd_cs46xx_gameport(chip);
 
@@ -117,11 +117,15 @@ static int snd_card_cs46xx_probe(struct pci_dev *pci,
 
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
 
 static struct pci_driver cs46xx_driver = {
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 70664c9832d6..3c3eac2399da 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9001,6 +9001,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1558, 0x70f4, "Clevo NH77EPY", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x70f6, "Clevo NH77DPQ-Y", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x7716, "Clevo NS50PU", ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1558, 0x7718, "Clevo L140PU", ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x8228, "Clevo NR40BU", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x8520, "Clevo NH50D[CD]", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x8521, "Clevo NH77D[CD]", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
diff --git a/sound/soc/codecs/rt5682-i2c.c b/sound/soc/codecs/rt5682-i2c.c
index b9d5d7a0975b..3d2d7c9ce66d 100644
--- a/sound/soc/codecs/rt5682-i2c.c
+++ b/sound/soc/codecs/rt5682-i2c.c
@@ -59,18 +59,12 @@ static void rt5682_jd_check_handler(struct work_struct *work)
 	struct rt5682_priv *rt5682 = container_of(work, struct rt5682_priv,
 		jd_check_work.work);
 
-	if (snd_soc_component_read(rt5682->component, RT5682_AJD1_CTRL)
-		& RT5682_JDH_RS_MASK) {
+	if (snd_soc_component_read(rt5682->component, RT5682_AJD1_CTRL) & RT5682_JDH_RS_MASK)
 		/* jack out */
-		rt5682->jack_type = rt5682_headset_detect(rt5682->component, 0);
-
-		snd_soc_jack_report(rt5682->hs_jack, rt5682->jack_type,
-			SND_JACK_HEADSET |
-			SND_JACK_BTN_0 | SND_JACK_BTN_1 |
-			SND_JACK_BTN_2 | SND_JACK_BTN_3);
-	} else {
+		mod_delayed_work(system_power_efficient_wq,
+				 &rt5682->jack_detect_work, 0);
+	else
 		schedule_delayed_work(&rt5682->jd_check_work, 500);
-	}
 }
 
 static irqreturn_t rt5682_irq(int irq, void *data)
@@ -139,6 +133,8 @@ static int rt5682_i2c_probe(struct i2c_client *i2c,
 
 	i2c_set_clientdata(i2c, rt5682);
 
+	rt5682->i2c_dev = &i2c->dev;
+
 	rt5682->pdata = i2s_default_platform_data;
 
 	if (pdata)
@@ -276,6 +272,26 @@ static int rt5682_i2c_probe(struct i2c_client *i2c,
 			dev_err(&i2c->dev, "Failed to reguest IRQ: %d\n", ret);
 	}
 
+#ifdef CONFIG_COMMON_CLK
+	/* Check if MCLK provided */
+	rt5682->mclk = devm_clk_get(&i2c->dev, "mclk");
+	if (IS_ERR(rt5682->mclk)) {
+		if (PTR_ERR(rt5682->mclk) != -ENOENT) {
+			ret = PTR_ERR(rt5682->mclk);
+			return ret;
+		}
+		rt5682->mclk = NULL;
+	}
+
+	/* Register CCF DAI clock control */
+	ret = rt5682_register_dai_clks(rt5682);
+	if (ret)
+		return ret;
+
+	/* Initial setup for CCF */
+	rt5682->lrck[RT5682_AIF1] = 48000;
+#endif
+
 	return devm_snd_soc_register_component(&i2c->dev,
 					       &rt5682_soc_component_dev,
 					       rt5682_dai, ARRAY_SIZE(rt5682_dai));
diff --git a/sound/soc/codecs/rt5682.c b/sound/soc/codecs/rt5682.c
index 6ad3159eceb9..8a9e1a4fa03e 100644
--- a/sound/soc/codecs/rt5682.c
+++ b/sound/soc/codecs/rt5682.c
@@ -48,6 +48,8 @@ static const struct reg_sequence patch_list[] = {
 	{RT5682_SAR_IL_CMD_6, 0x0110},
 	{RT5682_CHARGE_PUMP_1, 0x0210},
 	{RT5682_HP_LOGIC_CTRL_2, 0x0007},
+	{RT5682_SAR_IL_CMD_2, 0xac00},
+	{RT5682_CBJ_CTRL_7, 0x0104},
 };
 
 void rt5682_apply_patch_list(struct rt5682_priv *rt5682, struct device *dev)
@@ -920,15 +922,13 @@ static void rt5682_enable_push_button_irq(struct snd_soc_component *component,
  *
  * Returns detect status.
  */
-int rt5682_headset_detect(struct snd_soc_component *component, int jack_insert)
+static int rt5682_headset_detect(struct snd_soc_component *component, int jack_insert)
 {
 	struct rt5682_priv *rt5682 = snd_soc_component_get_drvdata(component);
 	struct snd_soc_dapm_context *dapm = &component->dapm;
 	unsigned int val, count;
 
 	if (jack_insert) {
-		snd_soc_dapm_mutex_lock(dapm);
-
 		snd_soc_component_update_bits(component, RT5682_PWR_ANLG_1,
 			RT5682_PWR_VREF2 | RT5682_PWR_MB,
 			RT5682_PWR_VREF2 | RT5682_PWR_MB);
@@ -942,6 +942,10 @@ int rt5682_headset_detect(struct snd_soc_component *component, int jack_insert)
 		snd_soc_component_update_bits(component,
 			RT5682_HP_CHARGE_PUMP_1,
 			RT5682_OSW_L_MASK | RT5682_OSW_R_MASK, 0);
+		rt5682_enable_push_button_irq(component, false);
+		snd_soc_component_update_bits(component, RT5682_CBJ_CTRL_1,
+			RT5682_TRIG_JD_MASK, RT5682_TRIG_JD_LOW);
+		usleep_range(55000, 60000);
 		snd_soc_component_update_bits(component, RT5682_CBJ_CTRL_1,
 			RT5682_TRIG_JD_MASK, RT5682_TRIG_JD_HIGH);
 
@@ -975,8 +979,6 @@ int rt5682_headset_detect(struct snd_soc_component *component, int jack_insert)
 		snd_soc_component_update_bits(component, RT5682_MICBIAS_2,
 			RT5682_PWR_CLK25M_MASK | RT5682_PWR_CLK1M_MASK,
 			RT5682_PWR_CLK25M_PU | RT5682_PWR_CLK1M_PU);
-
-		snd_soc_dapm_mutex_unlock(dapm);
 	} else {
 		rt5682_enable_push_button_irq(component, false);
 		snd_soc_component_update_bits(component, RT5682_CBJ_CTRL_1,
@@ -1005,7 +1007,6 @@ int rt5682_headset_detect(struct snd_soc_component *component, int jack_insert)
 	dev_dbg(component->dev, "jack_type = %d\n", rt5682->jack_type);
 	return rt5682->jack_type;
 }
-EXPORT_SYMBOL_GPL(rt5682_headset_detect);
 
 static int rt5682_set_jack_detect(struct snd_soc_component *component,
 		struct snd_soc_jack *hs_jack, void *data)
@@ -1088,6 +1089,7 @@ void rt5682_jack_detect_handler(struct work_struct *work)
 {
 	struct rt5682_priv *rt5682 =
 		container_of(work, struct rt5682_priv, jack_detect_work.work);
+	struct snd_soc_dapm_context *dapm;
 	int val, btn_type;
 
 	if (!rt5682->component || !rt5682->component->card ||
@@ -1098,6 +1100,9 @@ void rt5682_jack_detect_handler(struct work_struct *work)
 		return;
 	}
 
+	dapm = snd_soc_component_get_dapm(rt5682->component);
+
+	snd_soc_dapm_mutex_lock(dapm);
 	mutex_lock(&rt5682->calibrate_mutex);
 
 	val = snd_soc_component_read(rt5682->component, RT5682_AJD1_CTRL)
@@ -1157,6 +1162,9 @@ void rt5682_jack_detect_handler(struct work_struct *work)
 		rt5682->irq_work_delay_time = 50;
 	}
 
+	mutex_unlock(&rt5682->calibrate_mutex);
+	snd_soc_dapm_mutex_unlock(dapm);
+
 	snd_soc_jack_report(rt5682->hs_jack, rt5682->jack_type,
 		SND_JACK_HEADSET |
 		SND_JACK_BTN_0 | SND_JACK_BTN_1 |
@@ -1169,8 +1177,6 @@ void rt5682_jack_detect_handler(struct work_struct *work)
 		else
 			cancel_delayed_work_sync(&rt5682->jd_check_work);
 	}
-
-	mutex_unlock(&rt5682->calibrate_mutex);
 }
 EXPORT_SYMBOL_GPL(rt5682_jack_detect_handler);
 
@@ -2556,7 +2562,7 @@ static int rt5682_set_bias_level(struct snd_soc_component *component,
 static bool rt5682_clk_check(struct rt5682_priv *rt5682)
 {
 	if (!rt5682->master[RT5682_AIF1]) {
-		dev_dbg(rt5682->component->dev, "sysclk/dai not set correctly\n");
+		dev_dbg(rt5682->i2c_dev, "sysclk/dai not set correctly\n");
 		return false;
 	}
 	return true;
@@ -2567,13 +2573,15 @@ static int rt5682_wclk_prepare(struct clk_hw *hw)
 	struct rt5682_priv *rt5682 =
 		container_of(hw, struct rt5682_priv,
 			     dai_clks_hw[RT5682_DAI_WCLK_IDX]);
-	struct snd_soc_component *component = rt5682->component;
-	struct snd_soc_dapm_context *dapm =
-			snd_soc_component_get_dapm(component);
+	struct snd_soc_component *component;
+	struct snd_soc_dapm_context *dapm;
 
 	if (!rt5682_clk_check(rt5682))
 		return -EINVAL;
 
+	component = rt5682->component;
+	dapm = snd_soc_component_get_dapm(component);
+
 	snd_soc_dapm_mutex_lock(dapm);
 
 	snd_soc_dapm_force_enable_pin_unlocked(dapm, "MICBIAS");
@@ -2603,13 +2611,15 @@ static void rt5682_wclk_unprepare(struct clk_hw *hw)
 	struct rt5682_priv *rt5682 =
 		container_of(hw, struct rt5682_priv,
 			     dai_clks_hw[RT5682_DAI_WCLK_IDX]);
-	struct snd_soc_component *component = rt5682->component;
-	struct snd_soc_dapm_context *dapm =
-			snd_soc_component_get_dapm(component);
+	struct snd_soc_component *component;
+	struct snd_soc_dapm_context *dapm;
 
 	if (!rt5682_clk_check(rt5682))
 		return;
 
+	component = rt5682->component;
+	dapm = snd_soc_component_get_dapm(component);
+
 	snd_soc_dapm_mutex_lock(dapm);
 
 	snd_soc_dapm_disable_pin_unlocked(dapm, "MICBIAS");
@@ -2633,7 +2643,6 @@ static unsigned long rt5682_wclk_recalc_rate(struct clk_hw *hw,
 	struct rt5682_priv *rt5682 =
 		container_of(hw, struct rt5682_priv,
 			     dai_clks_hw[RT5682_DAI_WCLK_IDX]);
-	struct snd_soc_component *component = rt5682->component;
 	const char * const clk_name = clk_hw_get_name(hw);
 
 	if (!rt5682_clk_check(rt5682))
@@ -2643,7 +2652,7 @@ static unsigned long rt5682_wclk_recalc_rate(struct clk_hw *hw,
 	 */
 	if (rt5682->lrck[RT5682_AIF1] != CLK_48 &&
 	    rt5682->lrck[RT5682_AIF1] != CLK_44) {
-		dev_warn(component->dev, "%s: clk %s only support %d or %d Hz output\n",
+		dev_warn(rt5682->i2c_dev, "%s: clk %s only support %d or %d Hz output\n",
 			__func__, clk_name, CLK_44, CLK_48);
 		return 0;
 	}
@@ -2657,7 +2666,6 @@ static long rt5682_wclk_round_rate(struct clk_hw *hw, unsigned long rate,
 	struct rt5682_priv *rt5682 =
 		container_of(hw, struct rt5682_priv,
 			     dai_clks_hw[RT5682_DAI_WCLK_IDX]);
-	struct snd_soc_component *component = rt5682->component;
 	const char * const clk_name = clk_hw_get_name(hw);
 
 	if (!rt5682_clk_check(rt5682))
@@ -2667,7 +2675,7 @@ static long rt5682_wclk_round_rate(struct clk_hw *hw, unsigned long rate,
 	 * It will force to 48kHz if not both.
 	 */
 	if (rate != CLK_48 && rate != CLK_44) {
-		dev_warn(component->dev, "%s: clk %s only support %d or %d Hz output\n",
+		dev_warn(rt5682->i2c_dev, "%s: clk %s only support %d or %d Hz output\n",
 			__func__, clk_name, CLK_44, CLK_48);
 		rate = CLK_48;
 	}
@@ -2681,7 +2689,7 @@ static int rt5682_wclk_set_rate(struct clk_hw *hw, unsigned long rate,
 	struct rt5682_priv *rt5682 =
 		container_of(hw, struct rt5682_priv,
 			     dai_clks_hw[RT5682_DAI_WCLK_IDX]);
-	struct snd_soc_component *component = rt5682->component;
+	struct snd_soc_component *component;
 	struct clk_hw *parent_hw;
 	const char * const clk_name = clk_hw_get_name(hw);
 	int pre_div;
@@ -2690,6 +2698,8 @@ static int rt5682_wclk_set_rate(struct clk_hw *hw, unsigned long rate,
 	if (!rt5682_clk_check(rt5682))
 		return -EINVAL;
 
+	component = rt5682->component;
+
 	/*
 	 * Whether the wclk's parent clk (mclk) exists or not, please ensure
 	 * it is fixed or set to 48MHz before setting wclk rate. It's a
@@ -2699,12 +2709,12 @@ static int rt5682_wclk_set_rate(struct clk_hw *hw, unsigned long rate,
 	 */
 	parent_hw = clk_hw_get_parent(hw);
 	if (!parent_hw)
-		dev_warn(component->dev,
+		dev_warn(rt5682->i2c_dev,
 			"Parent mclk of wclk not acquired in driver. Please ensure mclk was provided as %d Hz.\n",
 			CLK_PLL2_FIN);
 
 	if (parent_rate != CLK_PLL2_FIN)
-		dev_warn(component->dev, "clk %s only support %d Hz input\n",
+		dev_warn(rt5682->i2c_dev, "clk %s only support %d Hz input\n",
 			clk_name, CLK_PLL2_FIN);
 
 	/*
@@ -2736,10 +2746,9 @@ static unsigned long rt5682_bclk_recalc_rate(struct clk_hw *hw,
 	struct rt5682_priv *rt5682 =
 		container_of(hw, struct rt5682_priv,
 			     dai_clks_hw[RT5682_DAI_BCLK_IDX]);
-	struct snd_soc_component *component = rt5682->component;
 	unsigned int bclks_per_wclk;
 
-	bclks_per_wclk = snd_soc_component_read(component, RT5682_TDM_TCON_CTRL);
+	regmap_read(rt5682->regmap, RT5682_TDM_TCON_CTRL, &bclks_per_wclk);
 
 	switch (bclks_per_wclk & RT5682_TDM_BCLK_MS1_MASK) {
 	case RT5682_TDM_BCLK_MS1_256:
@@ -2800,25 +2809,24 @@ static int rt5682_bclk_set_rate(struct clk_hw *hw, unsigned long rate,
 	struct rt5682_priv *rt5682 =
 		container_of(hw, struct rt5682_priv,
 			     dai_clks_hw[RT5682_DAI_BCLK_IDX]);
-	struct snd_soc_component *component = rt5682->component;
+	struct snd_soc_component *component;
 	struct snd_soc_dai *dai;
 	unsigned long factor;
 
 	if (!rt5682_clk_check(rt5682))
 		return -EINVAL;
 
+	component = rt5682->component;
+
 	factor = rt5682_bclk_get_factor(rate, parent_rate);
 
 	for_each_component_dais(component, dai)
 		if (dai->id == RT5682_AIF1)
-			break;
-	if (!dai) {
-		dev_err(component->dev, "dai %d not found in component\n",
-			RT5682_AIF1);
-		return -ENODEV;
-	}
+			return rt5682_set_bclk1_ratio(dai, factor);
 
-	return rt5682_set_bclk1_ratio(dai, factor);
+	dev_err(rt5682->i2c_dev, "dai %d not found in component\n",
+		RT5682_AIF1);
+	return -ENODEV;
 }
 
 static const struct clk_ops rt5682_dai_clk_ops[RT5682_DAI_NUM_CLKS] = {
@@ -2836,10 +2844,9 @@ static const struct clk_ops rt5682_dai_clk_ops[RT5682_DAI_NUM_CLKS] = {
 	},
 };
 
-static int rt5682_register_dai_clks(struct snd_soc_component *component)
+int rt5682_register_dai_clks(struct rt5682_priv *rt5682)
 {
-	struct device *dev = component->dev;
-	struct rt5682_priv *rt5682 = snd_soc_component_get_drvdata(component);
+	struct device *dev = rt5682->i2c_dev;
 	struct rt5682_platform_data *pdata = &rt5682->pdata;
 	struct clk_hw *dai_clk_hw;
 	int i, ret;
@@ -2899,6 +2906,7 @@ static int rt5682_register_dai_clks(struct snd_soc_component *component)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(rt5682_register_dai_clks);
 #endif /* CONFIG_COMMON_CLK */
 
 static int rt5682_probe(struct snd_soc_component *component)
@@ -2908,9 +2916,6 @@ static int rt5682_probe(struct snd_soc_component *component)
 	unsigned long time;
 	struct snd_soc_dapm_context *dapm = &component->dapm;
 
-#ifdef CONFIG_COMMON_CLK
-	int ret;
-#endif
 	rt5682->component = component;
 
 	if (rt5682->is_sdw) {
@@ -2922,26 +2927,6 @@ static int rt5682_probe(struct snd_soc_component *component)
 			dev_err(&slave->dev, "Initialization not complete, timed out\n");
 			return -ETIMEDOUT;
 		}
-	} else {
-#ifdef CONFIG_COMMON_CLK
-		/* Check if MCLK provided */
-		rt5682->mclk = devm_clk_get(component->dev, "mclk");
-		if (IS_ERR(rt5682->mclk)) {
-			if (PTR_ERR(rt5682->mclk) != -ENOENT) {
-				ret = PTR_ERR(rt5682->mclk);
-				return ret;
-			}
-			rt5682->mclk = NULL;
-		}
-
-		/* Register CCF DAI clock control */
-		ret = rt5682_register_dai_clks(component);
-		if (ret)
-			return ret;
-
-		/* Initial setup for CCF */
-		rt5682->lrck[RT5682_AIF1] = CLK_48;
-#endif
 	}
 
 	snd_soc_dapm_disable_pin(dapm, "MICBIAS");
@@ -2968,10 +2953,7 @@ static int rt5682_suspend(struct snd_soc_component *component)
 
 	cancel_delayed_work_sync(&rt5682->jack_detect_work);
 	cancel_delayed_work_sync(&rt5682->jd_check_work);
-	if (rt5682->hs_jack && rt5682->jack_type == SND_JACK_HEADSET) {
-		snd_soc_component_update_bits(component, RT5682_CBJ_CTRL_1,
-			RT5682_MB1_PATH_MASK | RT5682_MB2_PATH_MASK,
-			RT5682_CTRL_MB1_REG | RT5682_CTRL_MB2_REG);
+	if (rt5682->hs_jack && (rt5682->jack_type & SND_JACK_HEADSET) == SND_JACK_HEADSET) {
 		val = snd_soc_component_read(component,
 				RT5682_CBJ_CTRL_2) & RT5682_JACK_TYPE_MASK;
 
@@ -2993,10 +2975,17 @@ static int rt5682_suspend(struct snd_soc_component *component)
 		/* enter SAR ADC power saving mode */
 		snd_soc_component_update_bits(component, RT5682_SAR_IL_CMD_1,
 			RT5682_SAR_BUTT_DET_MASK | RT5682_SAR_BUTDET_MODE_MASK |
-			RT5682_SAR_BUTDET_RST_MASK | RT5682_SAR_SEL_MB1_MB2_MASK, 0);
+			RT5682_SAR_SEL_MB1_MB2_MASK, 0);
+		usleep_range(5000, 6000);
+		snd_soc_component_update_bits(component, RT5682_CBJ_CTRL_1,
+			RT5682_MB1_PATH_MASK | RT5682_MB2_PATH_MASK,
+			RT5682_CTRL_MB1_REG | RT5682_CTRL_MB2_REG);
+		usleep_range(10000, 12000);
 		snd_soc_component_update_bits(component, RT5682_SAR_IL_CMD_1,
-			RT5682_SAR_BUTT_DET_MASK | RT5682_SAR_BUTDET_MODE_MASK | RT5682_SAR_BUTDET_RST_MASK,
-			RT5682_SAR_BUTT_DET_EN | RT5682_SAR_BUTDET_POW_SAV | RT5682_SAR_BUTDET_RST_NORMAL);
+			RT5682_SAR_BUTT_DET_MASK | RT5682_SAR_BUTDET_MODE_MASK,
+			RT5682_SAR_BUTT_DET_EN | RT5682_SAR_BUTDET_POW_SAV);
+		snd_soc_component_update_bits(component, RT5682_HP_CHARGE_PUMP_1,
+			RT5682_OSW_L_MASK | RT5682_OSW_R_MASK, 0);
 	}
 
 	regcache_cache_only(rt5682->regmap, true);
@@ -3014,10 +3003,11 @@ static int rt5682_resume(struct snd_soc_component *component)
 	regcache_cache_only(rt5682->regmap, false);
 	regcache_sync(rt5682->regmap);
 
-	if (rt5682->hs_jack && rt5682->jack_type == SND_JACK_HEADSET) {
+	if (rt5682->hs_jack && (rt5682->jack_type & SND_JACK_HEADSET) == SND_JACK_HEADSET) {
 		snd_soc_component_update_bits(component, RT5682_SAR_IL_CMD_1,
 			RT5682_SAR_BUTDET_MODE_MASK | RT5682_SAR_SEL_MB1_MB2_MASK,
 			RT5682_SAR_BUTDET_POW_NORM | RT5682_SAR_SEL_MB1_MB2_AUTO);
+		usleep_range(5000, 6000);
 		snd_soc_component_update_bits(component, RT5682_CBJ_CTRL_1,
 			RT5682_MB1_PATH_MASK | RT5682_MB2_PATH_MASK,
 			RT5682_CTRL_MB1_FSM | RT5682_CTRL_MB2_FSM);
@@ -3025,8 +3015,9 @@ static int rt5682_resume(struct snd_soc_component *component)
 			RT5682_PWR_CBJ, RT5682_PWR_CBJ);
 	}
 
+	rt5682->jack_type = 0;
 	mod_delayed_work(system_power_efficient_wq,
-		&rt5682->jack_detect_work, msecs_to_jiffies(250));
+		&rt5682->jack_detect_work, msecs_to_jiffies(0));
 
 	return 0;
 }
diff --git a/sound/soc/codecs/rt5682.h b/sound/soc/codecs/rt5682.h
index 8e3244a62c16..52ff0d9c36c5 100644
--- a/sound/soc/codecs/rt5682.h
+++ b/sound/soc/codecs/rt5682.h
@@ -1428,6 +1428,7 @@ enum {
 
 struct rt5682_priv {
 	struct snd_soc_component *component;
+	struct device *i2c_dev;
 	struct rt5682_platform_data pdata;
 	struct regmap *regmap;
 	struct regmap *sdw_regmap;
@@ -1471,7 +1472,6 @@ int rt5682_sel_asrc_clk_src(struct snd_soc_component *component,
 
 void rt5682_apply_patch_list(struct rt5682_priv *rt5682, struct device *dev);
 
-int rt5682_headset_detect(struct snd_soc_component *component, int jack_insert);
 void rt5682_jack_detect_handler(struct work_struct *work);
 
 bool rt5682_volatile_register(struct device *dev, unsigned int reg);
@@ -1482,6 +1482,8 @@ void rt5682_calibrate(struct rt5682_priv *rt5682);
 void rt5682_reset(struct rt5682_priv *rt5682);
 int rt5682_parse_dt(struct rt5682_priv *rt5682, struct device *dev);
 
+int rt5682_register_dai_clks(struct rt5682_priv *rt5682);
+
 #define RT5682_REG_NUM 318
 extern const struct reg_default rt5682_reg[RT5682_REG_NUM];
 
diff --git a/sound/soc/codecs/rt700.c b/sound/soc/codecs/rt700.c
index 921382724f9c..614a40247679 100644
--- a/sound/soc/codecs/rt700.c
+++ b/sound/soc/codecs/rt700.c
@@ -315,17 +315,27 @@ static int rt700_set_jack_detect(struct snd_soc_component *component,
 	struct snd_soc_jack *hs_jack, void *data)
 {
 	struct rt700_priv *rt700 = snd_soc_component_get_drvdata(component);
+	int ret;
 
 	rt700->hs_jack = hs_jack;
 
-	if (!rt700->hw_init) {
-		dev_dbg(&rt700->slave->dev,
-			"%s hw_init not ready yet\n", __func__);
+	ret = pm_runtime_resume_and_get(component->dev);
+	if (ret < 0) {
+		if (ret != -EACCES) {
+			dev_err(component->dev, "%s: failed to resume %d\n", __func__, ret);
+			return ret;
+		}
+
+		/* pm_runtime not enabled yet */
+		dev_dbg(component->dev,	"%s: skipping jack init for now\n", __func__);
 		return 0;
 	}
 
 	rt700_jack_init(rt700);
 
+	pm_runtime_mark_last_busy(component->dev);
+	pm_runtime_put_autosuspend(component->dev);
+
 	return 0;
 }
 
diff --git a/sound/soc/codecs/rt711-sdca.c b/sound/soc/codecs/rt711-sdca.c
index 2e992589f1e4..c15fb98eac86 100644
--- a/sound/soc/codecs/rt711-sdca.c
+++ b/sound/soc/codecs/rt711-sdca.c
@@ -487,16 +487,27 @@ static int rt711_sdca_set_jack_detect(struct snd_soc_component *component,
 	struct snd_soc_jack *hs_jack, void *data)
 {
 	struct rt711_sdca_priv *rt711 = snd_soc_component_get_drvdata(component);
+	int ret;
 
 	rt711->hs_jack = hs_jack;
 
-	if (!rt711->hw_init) {
-		dev_dbg(&rt711->slave->dev,
-			"%s hw_init not ready yet\n", __func__);
+	ret = pm_runtime_resume_and_get(component->dev);
+	if (ret < 0) {
+		if (ret != -EACCES) {
+			dev_err(component->dev, "%s: failed to resume %d\n", __func__, ret);
+			return ret;
+		}
+
+		/* pm_runtime not enabled yet */
+		dev_dbg(component->dev,	"%s: skipping jack init for now\n", __func__);
 		return 0;
 	}
 
 	rt711_sdca_jack_init(rt711);
+
+	pm_runtime_mark_last_busy(component->dev);
+	pm_runtime_put_autosuspend(component->dev);
+
 	return 0;
 }
 
@@ -1190,14 +1201,6 @@ static int rt711_sdca_probe(struct snd_soc_component *component)
 	return 0;
 }
 
-static void rt711_sdca_remove(struct snd_soc_component *component)
-{
-	struct rt711_sdca_priv *rt711 = snd_soc_component_get_drvdata(component);
-
-	regcache_cache_only(rt711->regmap, true);
-	regcache_cache_only(rt711->mbq_regmap, true);
-}
-
 static const struct snd_soc_component_driver soc_sdca_dev_rt711 = {
 	.probe = rt711_sdca_probe,
 	.controls = rt711_sdca_snd_controls,
@@ -1207,7 +1210,7 @@ static const struct snd_soc_component_driver soc_sdca_dev_rt711 = {
 	.dapm_routes = rt711_sdca_audio_map,
 	.num_dapm_routes = ARRAY_SIZE(rt711_sdca_audio_map),
 	.set_jack = rt711_sdca_set_jack_detect,
-	.remove = rt711_sdca_remove,
+	.endianness = 1,
 };
 
 static int rt711_sdca_set_sdw_stream(struct snd_soc_dai *dai, void *sdw_stream,
diff --git a/sound/soc/codecs/rt711.c b/sound/soc/codecs/rt711.c
index a7c5608a0ef8..fafb0ba8349f 100644
--- a/sound/soc/codecs/rt711.c
+++ b/sound/soc/codecs/rt711.c
@@ -450,17 +450,27 @@ static int rt711_set_jack_detect(struct snd_soc_component *component,
 	struct snd_soc_jack *hs_jack, void *data)
 {
 	struct rt711_priv *rt711 = snd_soc_component_get_drvdata(component);
+	int ret;
 
 	rt711->hs_jack = hs_jack;
 
-	if (!rt711->hw_init) {
-		dev_dbg(&rt711->slave->dev,
-			"%s hw_init not ready yet\n", __func__);
+	ret = pm_runtime_resume_and_get(component->dev);
+	if (ret < 0) {
+		if (ret != -EACCES) {
+			dev_err(component->dev, "%s: failed to resume %d\n", __func__, ret);
+			return ret;
+		}
+
+		/* pm_runtime not enabled yet */
+		dev_dbg(component->dev,	"%s: skipping jack init for now\n", __func__);
 		return 0;
 	}
 
 	rt711_jack_init(rt711);
 
+	pm_runtime_mark_last_busy(component->dev);
+	pm_runtime_put_autosuspend(component->dev);
+
 	return 0;
 }
 
@@ -925,13 +935,6 @@ static int rt711_probe(struct snd_soc_component *component)
 	return 0;
 }
 
-static void rt711_remove(struct snd_soc_component *component)
-{
-	struct rt711_priv *rt711 = snd_soc_component_get_drvdata(component);
-
-	regcache_cache_only(rt711->regmap, true);
-}
-
 static const struct snd_soc_component_driver soc_codec_dev_rt711 = {
 	.probe = rt711_probe,
 	.set_bias_level = rt711_set_bias_level,
@@ -942,7 +945,7 @@ static const struct snd_soc_component_driver soc_codec_dev_rt711 = {
 	.dapm_routes = rt711_audio_map,
 	.num_dapm_routes = ARRAY_SIZE(rt711_audio_map),
 	.set_jack = rt711_set_jack_detect,
-	.remove = rt711_remove,
+	.endianness = 1,
 };
 
 static int rt711_set_sdw_stream(struct snd_soc_dai *dai, void *sdw_stream,
diff --git a/sound/usb/mixer_maps.c b/sound/usb/mixer_maps.c
index 6ffd23f2ee65..997425ef0a29 100644
--- a/sound/usb/mixer_maps.c
+++ b/sound/usb/mixer_maps.c
@@ -423,6 +423,14 @@ static const struct usbmix_name_map aorus_master_alc1220vb_map[] = {
 	{}
 };
 
+/* MSI MPG X570S Carbon Max Wifi with ALC4080  */
+static const struct usbmix_name_map msi_mpg_x570s_carbon_max_wifi_alc4080_map[] = {
+	{ 29, "Speaker Playback" },
+	{ 30, "Front Headphone Playback" },
+	{ 32, "IEC958 Playback" },
+	{}
+};
+
 /*
  * Control map entries
  */
@@ -574,6 +582,14 @@ static const struct usbmix_ctl_map usbmix_ctl_maps[] = {
 		.map = trx40_mobo_map,
 		.connector_map = trx40_mobo_connector_map,
 	},
+	{	/* MSI MPG X570S Carbon Max Wifi */
+		.id = USB_ID(0x0db0, 0x419c),
+		.map = msi_mpg_x570s_carbon_max_wifi_alc4080_map,
+	},
+	{	/* MSI MAG X570S Torpedo Max */
+		.id = USB_ID(0x0db0, 0xa073),
+		.map = msi_mpg_x570s_carbon_max_wifi_alc4080_map,
+	},
 	{	/* MSI TRX40 */
 		.id = USB_ID(0x0db0, 0x543d),
 		.map = trx40_mobo_map,
diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index e8468f9b007d..12ce69b04f63 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1842,6 +1842,10 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_SHARE_MEDIA_DEVICE | QUIRK_FLAG_ALIGN_TRANSFER),
 	DEVICE_FLG(0x1395, 0x740a, /* Sennheiser DECT */
 		   QUIRK_FLAG_GET_SAMPLE_RATE),
+	DEVICE_FLG(0x1397, 0x0508, /* Behringer UMC204HD */
+		   QUIRK_FLAG_PLAYBACK_FIRST | QUIRK_FLAG_GENERIC_IMPLICIT_FB),
+	DEVICE_FLG(0x1397, 0x0509, /* Behringer UMC404HD */
+		   QUIRK_FLAG_PLAYBACK_FIRST | QUIRK_FLAG_GENERIC_IMPLICIT_FB),
 	DEVICE_FLG(0x13e5, 0x0001, /* Serato Phono */
 		   QUIRK_FLAG_IGNORE_CTL_ERROR),
 	DEVICE_FLG(0x154e, 0x1002, /* Denon DCD-1500RE */
diff --git a/tools/testing/selftests/bpf/prog_tests/timer_crash.c b/tools/testing/selftests/bpf/prog_tests/timer_crash.c
deleted file mode 100644
index f74b82305da8..000000000000
--- a/tools/testing/selftests/bpf/prog_tests/timer_crash.c
+++ /dev/null
@@ -1,32 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-#include <test_progs.h>
-#include "timer_crash.skel.h"
-
-enum {
-	MODE_ARRAY,
-	MODE_HASH,
-};
-
-static void test_timer_crash_mode(int mode)
-{
-	struct timer_crash *skel;
-
-	skel = timer_crash__open_and_load();
-	if (!ASSERT_OK_PTR(skel, "timer_crash__open_and_load"))
-		return;
-	skel->bss->pid = getpid();
-	skel->bss->crash_map = mode;
-	if (!ASSERT_OK(timer_crash__attach(skel), "timer_crash__attach"))
-		goto end;
-	usleep(1);
-end:
-	timer_crash__destroy(skel);
-}
-
-void test_timer_crash(void)
-{
-	if (test__start_subtest("array"))
-		test_timer_crash_mode(MODE_ARRAY);
-	if (test__start_subtest("hash"))
-		test_timer_crash_mode(MODE_HASH);
-}
diff --git a/tools/testing/selftests/bpf/progs/timer_crash.c b/tools/testing/selftests/bpf/progs/timer_crash.c
deleted file mode 100644
index f8f7944e70da..000000000000
--- a/tools/testing/selftests/bpf/progs/timer_crash.c
+++ /dev/null
@@ -1,54 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-
-#include <vmlinux.h>
-#include <bpf/bpf_tracing.h>
-#include <bpf/bpf_helpers.h>
-
-struct map_elem {
-	struct bpf_timer timer;
-	struct bpf_spin_lock lock;
-};
-
-struct {
-	__uint(type, BPF_MAP_TYPE_ARRAY);
-	__uint(max_entries, 1);
-	__type(key, int);
-	__type(value, struct map_elem);
-} amap SEC(".maps");
-
-struct {
-	__uint(type, BPF_MAP_TYPE_HASH);
-	__uint(max_entries, 1);
-	__type(key, int);
-	__type(value, struct map_elem);
-} hmap SEC(".maps");
-
-int pid = 0;
-int crash_map = 0; /* 0 for amap, 1 for hmap */
-
-SEC("fentry/do_nanosleep")
-int sys_enter(void *ctx)
-{
-	struct map_elem *e, value = {};
-	void *map = crash_map ? (void *)&hmap : (void *)&amap;
-
-	if (bpf_get_current_task_btf()->tgid != pid)
-		return 0;
-
-	*(void **)&value = (void *)0xdeadcaf3;
-
-	bpf_map_update_elem(map, &(int){0}, &value, 0);
-	/* For array map, doing bpf_map_update_elem will do a
-	 * check_and_free_timer_in_array, which will trigger the crash if timer
-	 * pointer was overwritten, for hmap we need to use bpf_timer_cancel.
-	 */
-	if (crash_map == 1) {
-		e = bpf_map_lookup_elem(map, &(int){0});
-		if (!e)
-			return 0;
-		bpf_timer_cancel(&e->timer);
-	}
-	return 0;
-}
-
-char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index 92087d423bcf..c9507df9c05b 100644
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -1149,6 +1149,7 @@ learning_test()
 	# FDB entry was installed.
 	bridge link set dev $br_port1 flood off
 
+	ip link set $host1_if promisc on
 	tc qdisc add dev $host1_if ingress
 	tc filter add dev $host1_if ingress protocol ip pref 1 handle 101 \
 		flower dst_mac $mac action drop
@@ -1159,7 +1160,7 @@ learning_test()
 	tc -j -s filter show dev $host1_if ingress \
 		| jq -e ".[] | select(.options.handle == 101) \
 		| select(.options.actions[0].stats.packets == 1)" &> /dev/null
-	check_fail $? "Packet reached second host when should not"
+	check_fail $? "Packet reached first host when should not"
 
 	$MZ $host1_if -c 1 -p 64 -a $mac -t ip -q
 	sleep 1
@@ -1198,6 +1199,7 @@ learning_test()
 
 	tc filter del dev $host1_if ingress protocol ip pref 1 handle 101 flower
 	tc qdisc del dev $host1_if ingress
+	ip link set $host1_if promisc off
 
 	bridge link set dev $br_port1 flood on
 
@@ -1215,6 +1217,7 @@ flood_test_do()
 
 	# Add an ACL on `host2_if` which will tell us whether the packet
 	# was flooded to it or not.
+	ip link set $host2_if promisc on
 	tc qdisc add dev $host2_if ingress
 	tc filter add dev $host2_if ingress protocol ip pref 1 handle 101 \
 		flower dst_mac $mac action drop
@@ -1232,6 +1235,7 @@ flood_test_do()
 
 	tc filter del dev $host2_if ingress protocol ip pref 1 handle 101 flower
 	tc qdisc del dev $host2_if ingress
+	ip link set $host2_if promisc off
 
 	return $err
 }
diff --git a/tools/testing/selftests/net/udpgro.sh b/tools/testing/selftests/net/udpgro.sh
index f8a19f548ae9..ebbd0b282432 100755
--- a/tools/testing/selftests/net/udpgro.sh
+++ b/tools/testing/selftests/net/udpgro.sh
@@ -34,7 +34,7 @@ cfg_veth() {
 	ip -netns "${PEER_NS}" addr add dev veth1 192.168.1.1/24
 	ip -netns "${PEER_NS}" addr add dev veth1 2001:db8::1/64 nodad
 	ip -netns "${PEER_NS}" link set dev veth1 up
-	ip -n "${PEER_NS}" link set veth1 xdp object ../bpf/xdp_dummy.o section xdp_dummy
+	ip -n "${PEER_NS}" link set veth1 xdp object ../bpf/xdp_dummy.o section xdp
 }
 
 run_one() {
diff --git a/tools/testing/selftests/net/udpgro_bench.sh b/tools/testing/selftests/net/udpgro_bench.sh
index 820bc50f6b68..fad2d1a71cac 100755
--- a/tools/testing/selftests/net/udpgro_bench.sh
+++ b/tools/testing/selftests/net/udpgro_bench.sh
@@ -34,7 +34,7 @@ run_one() {
 	ip -netns "${PEER_NS}" addr add dev veth1 2001:db8::1/64 nodad
 	ip -netns "${PEER_NS}" link set dev veth1 up
 
-	ip -n "${PEER_NS}" link set veth1 xdp object ../bpf/xdp_dummy.o section xdp_dummy
+	ip -n "${PEER_NS}" link set veth1 xdp object ../bpf/xdp_dummy.o section xdp
 	ip netns exec "${PEER_NS}" ./udpgso_bench_rx ${rx_args} -r &
 	ip netns exec "${PEER_NS}" ./udpgso_bench_rx -t ${rx_args} -r &
 
diff --git a/tools/testing/selftests/net/udpgro_fwd.sh b/tools/testing/selftests/net/udpgro_fwd.sh
index 6f05e06f6761..1bcd82e1f662 100755
--- a/tools/testing/selftests/net/udpgro_fwd.sh
+++ b/tools/testing/selftests/net/udpgro_fwd.sh
@@ -46,7 +46,7 @@ create_ns() {
 		ip -n $BASE$ns addr add dev veth$ns $BM_NET_V4$ns/24
 		ip -n $BASE$ns addr add dev veth$ns $BM_NET_V6$ns/64 nodad
 	done
-	ip -n $NS_DST link set veth$DST xdp object ../bpf/xdp_dummy.o section xdp_dummy 2>/dev/null
+	ip -n $NS_DST link set veth$DST xdp object ../bpf/xdp_dummy.o section xdp 2>/dev/null
 }
 
 create_vxlan_endpoint() {
diff --git a/tools/testing/selftests/net/veth.sh b/tools/testing/selftests/net/veth.sh
index 19eac3e44c06..430895d1a2b6 100755
--- a/tools/testing/selftests/net/veth.sh
+++ b/tools/testing/selftests/net/veth.sh
@@ -289,14 +289,14 @@ if [ $CPUS -gt 1 ]; then
 	ip netns exec $NS_SRC ethtool -L veth$SRC rx 1 tx 2 2>/dev/null
 	printf "%-60s" "bad setting: XDP with RX nr less than TX"
 	ip -n $NS_DST link set dev veth$DST xdp object ../bpf/xdp_dummy.o \
-		section xdp_dummy 2>/dev/null &&\
+		section xdp 2>/dev/null &&\
 		echo "fail - set operation successful ?!?" || echo " ok "
 
 	# the following tests will run with multiple channels active
 	ip netns exec $NS_SRC ethtool -L veth$SRC rx 2
 	ip netns exec $NS_DST ethtool -L veth$DST rx 2
 	ip -n $NS_DST link set dev veth$DST xdp object ../bpf/xdp_dummy.o \
-		section xdp_dummy 2>/dev/null
+		section xdp 2>/dev/null
 	printf "%-60s" "bad setting: reducing RX nr below peer TX with XDP set"
 	ip netns exec $NS_DST ethtool -L veth$DST rx 1 2>/dev/null &&\
 		echo "fail - set operation successful ?!?" || echo " ok "
@@ -311,7 +311,7 @@ if [ $CPUS -gt 2 ]; then
 	chk_channels "setting invalid channels nr" $DST 2 2
 fi
 
-ip -n $NS_DST link set dev veth$DST xdp object ../bpf/xdp_dummy.o section xdp_dummy 2>/dev/null
+ip -n $NS_DST link set dev veth$DST xdp object ../bpf/xdp_dummy.o section xdp 2>/dev/null
 chk_gro_flag "with xdp attached - gro flag" $DST on
 chk_gro_flag "        - peer gro flag" $SRC off
 chk_tso_flag "        - tso flag" $SRC off
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index fefdf3a6dae3..9eac68ae291e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -911,7 +911,7 @@ static void kvm_destroy_vm_debugfs(struct kvm *kvm)
 	int kvm_debugfs_num_entries = kvm_vm_stats_header.num_desc +
 				      kvm_vcpu_stats_header.num_desc;
 
-	if (!kvm->debugfs_dentry)
+	if (IS_ERR(kvm->debugfs_dentry))
 		return;
 
 	debugfs_remove_recursive(kvm->debugfs_dentry);
@@ -1049,6 +1049,12 @@ static struct kvm *kvm_create_vm(unsigned long type)
 
 	BUILD_BUG_ON(KVM_MEM_SLOTS_NUM > SHRT_MAX);
 
+	/*
+	 * Force subsequent debugfs file creations to fail if the VM directory
+	 * is not created (by kvm_create_vm_debugfs()).
+	 */
+	kvm->debugfs_dentry = ERR_PTR(-ENOENT);
+
 	if (init_srcu_struct(&kvm->srcu))
 		goto out_err_no_srcu;
 	if (init_srcu_struct(&kvm->irq_srcu))
@@ -1255,9 +1261,9 @@ static int kvm_vm_release(struct inode *inode, struct file *filp)
  */
 static int kvm_alloc_dirty_bitmap(struct kvm_memory_slot *memslot)
 {
-	unsigned long dirty_bytes = 2 * kvm_dirty_bitmap_bytes(memslot);
+	unsigned long dirty_bytes = kvm_dirty_bitmap_bytes(memslot);
 
-	memslot->dirty_bitmap = kvzalloc(dirty_bytes, GFP_KERNEL_ACCOUNT);
+	memslot->dirty_bitmap = __vcalloc(2, dirty_bytes, GFP_KERNEL_ACCOUNT);
 	if (!memslot->dirty_bitmap)
 		return -ENOMEM;
 
@@ -5373,7 +5379,7 @@ static void kvm_uevent_notify_change(unsigned int type, struct kvm *kvm)
 	}
 	add_uevent_var(env, "PID=%d", kvm->userspace_pid);
 
-	if (kvm->debugfs_dentry) {
+	if (!IS_ERR(kvm->debugfs_dentry)) {
 		char *tmp, *p = kmalloc(PATH_MAX, GFP_KERNEL_ACCOUNT);
 
 		if (p) {
