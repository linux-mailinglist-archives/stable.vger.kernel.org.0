Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7024DE810
	for <lists+stable@lfdr.de>; Sat, 19 Mar 2022 14:05:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243023AbiCSNG3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Mar 2022 09:06:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243008AbiCSNGT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Mar 2022 09:06:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B48725EC99;
        Sat, 19 Mar 2022 06:04:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E5AC060C58;
        Sat, 19 Mar 2022 13:04:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5E54C340EC;
        Sat, 19 Mar 2022 13:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647695092;
        bh=6LukUBX+wyatdutELNhjJv7xWYfqLjncqkz9z5Ksadg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2Wvi2SrnQANDvoQL0h4ghU6YcwJoxhkfq7jqVwuLBLtBzlZLm4ZEdP5P2OYs0JfUR
         MsxUwWrXoqGjrcNbZhHWFaNjucdU58ssUDSaCD8uxh3Unmtt6RNbXqznA36Gab4sFF
         UzbGUquseK/xlZ6tO2+B/CR3PDBrqz3gzldhLk7M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.16.16
Date:   Sat, 19 Mar 2022 14:04:40 +0100
Message-Id: <1647695079132244@kroah.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <16476950798220@kroah.com>
References: <16476950798220@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 8675dd2a9cc8..d625d3aeab2e 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 16
-SUBLEVEL = 15
+SUBLEVEL = 16
 EXTRAVERSION =
 NAME = Gobble Gobble
 
diff --git a/arch/arm/boot/dts/rk322x.dtsi b/arch/arm/boot/dts/rk322x.dtsi
index 8eed9e3a92e9..5868eb512f69 100644
--- a/arch/arm/boot/dts/rk322x.dtsi
+++ b/arch/arm/boot/dts/rk322x.dtsi
@@ -718,8 +718,8 @@ hdmi: hdmi@200a0000 {
 		interrupts = <GIC_SPI 35 IRQ_TYPE_LEVEL_HIGH>;
 		assigned-clocks = <&cru SCLK_HDMI_PHY>;
 		assigned-clock-parents = <&hdmi_phy>;
-		clocks = <&cru SCLK_HDMI_HDCP>, <&cru PCLK_HDMI_CTRL>, <&cru SCLK_HDMI_CEC>;
-		clock-names = "isfr", "iahb", "cec";
+		clocks = <&cru PCLK_HDMI_CTRL>, <&cru SCLK_HDMI_HDCP>, <&cru SCLK_HDMI_CEC>;
+		clock-names = "iahb", "isfr", "cec";
 		pinctrl-names = "default";
 		pinctrl-0 = <&hdmii2c_xfer &hdmi_hpd &hdmi_cec>;
 		resets = <&cru SRST_HDMI_P>;
diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
index aaaa61875701..45a9d9b908d2 100644
--- a/arch/arm/boot/dts/rk3288.dtsi
+++ b/arch/arm/boot/dts/rk3288.dtsi
@@ -971,7 +971,7 @@ i2s: i2s@ff890000 {
 		status = "disabled";
 	};
 
-	crypto: cypto-controller@ff8a0000 {
+	crypto: crypto@ff8a0000 {
 		compatible = "rockchip,rk3288-crypto";
 		reg = <0x0 0xff8a0000 0x0 0x4000>;
 		interrupts = <GIC_SPI 48 IRQ_TYPE_LEVEL_HIGH>;
diff --git a/arch/arm64/boot/dts/intel/socfpga_agilex.dtsi b/arch/arm64/boot/dts/intel/socfpga_agilex.dtsi
index 0dd2d2ee765a..f4270cf18996 100644
--- a/arch/arm64/boot/dts/intel/socfpga_agilex.dtsi
+++ b/arch/arm64/boot/dts/intel/socfpga_agilex.dtsi
@@ -502,7 +502,7 @@ uart1: serial@ffc02100 {
 		};
 
 		usb0: usb@ffb00000 {
-			compatible = "snps,dwc2";
+			compatible = "intel,socfpga-agilex-hsotg", "snps,dwc2";
 			reg = <0xffb00000 0x40000>;
 			interrupts = <GIC_SPI 93 IRQ_TYPE_LEVEL_HIGH>;
 			phys = <&usbphy0>;
@@ -515,7 +515,7 @@ usb0: usb@ffb00000 {
 		};
 
 		usb1: usb@ffb40000 {
-			compatible = "snps,dwc2";
+			compatible = "intel,socfpga-agilex-hsotg", "snps,dwc2";
 			reg = <0xffb40000 0x40000>;
 			interrupts = <GIC_SPI 94 IRQ_TYPE_LEVEL_HIGH>;
 			phys = <&usbphy0>;
diff --git a/arch/arm64/boot/dts/rockchip/px30.dtsi b/arch/arm64/boot/dts/rockchip/px30.dtsi
index 00f50b05d55a..b72874c16a71 100644
--- a/arch/arm64/boot/dts/rockchip/px30.dtsi
+++ b/arch/arm64/boot/dts/rockchip/px30.dtsi
@@ -711,7 +711,7 @@ rktimer: timer@ff210000 {
 		clock-names = "pclk", "timer";
 	};
 
-	dmac: dmac@ff240000 {
+	dmac: dma-controller@ff240000 {
 		compatible = "arm,pl330", "arm,primecell";
 		reg = <0x0 0xff240000 0x0 0x4000>;
 		interrupts = <GIC_SPI 1 IRQ_TYPE_LEVEL_HIGH>,
diff --git a/arch/arm64/boot/dts/rockchip/rk3328.dtsi b/arch/arm64/boot/dts/rockchip/rk3328.dtsi
index 39db0b85b4da..b822533dc7f1 100644
--- a/arch/arm64/boot/dts/rockchip/rk3328.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3328.dtsi
@@ -489,7 +489,7 @@ pwm3: pwm@ff1b0030 {
 		status = "disabled";
 	};
 
-	dmac: dmac@ff1f0000 {
+	dmac: dma-controller@ff1f0000 {
 		compatible = "arm,pl330", "arm,primecell";
 		reg = <0x0 0xff1f0000 0x0 0x4000>;
 		interrupts = <GIC_SPI 0 IRQ_TYPE_LEVEL_HIGH>,
diff --git a/arch/arm64/boot/dts/rockchip/rk3399-puma-haikou.dts b/arch/arm64/boot/dts/rockchip/rk3399-puma-haikou.dts
index 292bb7e80cf3..3ae5d727e367 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-puma-haikou.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-puma-haikou.dts
@@ -232,6 +232,7 @@ &usbdrd3_0 {
 
 &usbdrd_dwc3_0 {
 	dr_mode = "otg";
+	extcon = <&extcon_usb3>;
 	status = "okay";
 };
 
diff --git a/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
index fb67db4619ea..08fa00364b42 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
@@ -25,6 +25,13 @@ module_led: led-0 {
 		};
 	};
 
+	extcon_usb3: extcon-usb3 {
+		compatible = "linux,extcon-usb-gpio";
+		id-gpio = <&gpio1 RK_PC2 GPIO_ACTIVE_HIGH>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&usb3_id>;
+	};
+
 	clkin_gmac: external-gmac-clock {
 		compatible = "fixed-clock";
 		clock-frequency = <125000000>;
@@ -422,9 +429,22 @@ vcc5v0_host_en: vcc5v0-host-en {
 			  <4 RK_PA3 RK_FUNC_GPIO &pcfg_pull_none>;
 		};
 	};
+
+	usb3 {
+		usb3_id: usb3-id {
+			rockchip,pins =
+			  <1 RK_PC2 RK_FUNC_GPIO &pcfg_pull_none>;
+		};
+	};
 };
 
 &sdhci {
+	/*
+	 * Signal integrity isn't great at 200MHz but 100MHz has proven stable
+	 * enough.
+	 */
+	max-frequency = <100000000>;
+
 	bus-width = <8>;
 	mmc-hs400-1_8v;
 	mmc-hs400-enhanced-strobe;
diff --git a/arch/arm64/boot/dts/rockchip/rk3399.dtsi b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
index d3cdf6f42a30..080457a68e3c 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
@@ -1881,10 +1881,10 @@ hdmi: hdmi@ff940000 {
 		interrupts = <GIC_SPI 23 IRQ_TYPE_LEVEL_HIGH 0>;
 		clocks = <&cru PCLK_HDMI_CTRL>,
 			 <&cru SCLK_HDMI_SFR>,
-			 <&cru PLL_VPLL>,
+			 <&cru SCLK_HDMI_CEC>,
 			 <&cru PCLK_VIO_GRF>,
-			 <&cru SCLK_HDMI_CEC>;
-		clock-names = "iahb", "isfr", "vpll", "grf", "cec";
+			 <&cru PLL_VPLL>;
+		clock-names = "iahb", "isfr", "cec", "grf", "vpll";
 		power-domains = <&power RK3399_PD_HDCP>;
 		reg-io-width = <4>;
 		rockchip,grf = <&grf>;
diff --git a/arch/arm64/boot/dts/rockchip/rk356x.dtsi b/arch/arm64/boot/dts/rockchip/rk356x.dtsi
index 46d9552f6028..688e3585525a 100644
--- a/arch/arm64/boot/dts/rockchip/rk356x.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk356x.dtsi
@@ -647,7 +647,7 @@ &i2s1m0_sdo0   &i2s1m0_sdo1
 		status = "disabled";
 	};
 
-	dmac0: dmac@fe530000 {
+	dmac0: dma-controller@fe530000 {
 		compatible = "arm,pl330", "arm,primecell";
 		reg = <0x0 0xfe530000 0x0 0x4000>;
 		interrupts = <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>,
@@ -658,7 +658,7 @@ dmac0: dmac@fe530000 {
 		#dma-cells = <1>;
 	};
 
-	dmac1: dmac@fe550000 {
+	dmac1: dma-controller@fe550000 {
 		compatible = "arm,pl330", "arm,primecell";
 		reg = <0x0 0xfe550000 0x0 0x4000>;
 		interrupts = <GIC_SPI 16 IRQ_TYPE_LEVEL_HIGH>,
diff --git a/arch/mips/kernel/smp.c b/arch/mips/kernel/smp.c
index d542fb7af3ba..1986d1309410 100644
--- a/arch/mips/kernel/smp.c
+++ b/arch/mips/kernel/smp.c
@@ -351,6 +351,9 @@ asmlinkage void start_secondary(void)
 	cpu = smp_processor_id();
 	cpu_data[cpu].udelay_val = loops_per_jiffy;
 
+	set_cpu_sibling_map(cpu);
+	set_cpu_core_map(cpu);
+
 	cpumask_set_cpu(cpu, &cpu_coherent_mask);
 	notify_cpu_starting(cpu);
 
@@ -362,9 +365,6 @@ asmlinkage void start_secondary(void)
 	/* The CPU is running and counters synchronised, now mark it online */
 	set_cpu_online(cpu, true);
 
-	set_cpu_sibling_map(cpu);
-	set_cpu_core_map(cpu);
-
 	calculate_cpu_foreign_map();
 
 	/*
diff --git a/drivers/atm/firestream.c b/drivers/atm/firestream.c
index 3bc3c314a467..4f67404fe64c 100644
--- a/drivers/atm/firestream.c
+++ b/drivers/atm/firestream.c
@@ -1676,6 +1676,8 @@ static int fs_init(struct fs_dev *dev)
 	dev->hw_base = pci_resource_start(pci_dev, 0);
 
 	dev->base = ioremap(dev->hw_base, 0x1000);
+	if (!dev->base)
+		return 1;
 
 	reset_chip (dev);
   
diff --git a/drivers/gpu/drm/drm_connector.c b/drivers/gpu/drm/drm_connector.c
index 52e20c68813b..6ae26e7d3dec 100644
--- a/drivers/gpu/drm/drm_connector.c
+++ b/drivers/gpu/drm/drm_connector.c
@@ -2275,6 +2275,9 @@ EXPORT_SYMBOL(drm_connector_atomic_hdr_metadata_equal);
 void drm_connector_set_vrr_capable_property(
 		struct drm_connector *connector, bool capable)
 {
+	if (!connector->vrr_capable_property)
+		return;
+
 	drm_object_property_set_value(&connector->base,
 				      connector->vrr_capable_property,
 				      capable);
diff --git a/drivers/input/touchscreen/goodix.c b/drivers/input/touchscreen/goodix.c
index aaa3c455e01e..d3136842b717 100644
--- a/drivers/input/touchscreen/goodix.c
+++ b/drivers/input/touchscreen/goodix.c
@@ -18,6 +18,7 @@
 #include <linux/delay.h>
 #include <linux/irq.h>
 #include <linux/interrupt.h>
+#include <linux/platform_data/x86/soc.h>
 #include <linux/slab.h>
 #include <linux/acpi.h>
 #include <linux/of.h>
@@ -686,21 +687,6 @@ static int goodix_reset(struct goodix_ts_data *ts)
 }
 
 #ifdef ACPI_GPIO_SUPPORT
-#include <asm/cpu_device_id.h>
-#include <asm/intel-family.h>
-
-static const struct x86_cpu_id baytrail_cpu_ids[] = {
-	{ X86_VENDOR_INTEL, 6, INTEL_FAM6_ATOM_SILVERMONT, X86_FEATURE_ANY, },
-	{}
-};
-
-static inline bool is_byt(void)
-{
-	const struct x86_cpu_id *id = x86_match_cpu(baytrail_cpu_ids);
-
-	return !!id;
-}
-
 static const struct acpi_gpio_params first_gpio = { 0, 0, false };
 static const struct acpi_gpio_params second_gpio = { 1, 0, false };
 
@@ -759,7 +745,7 @@ static int goodix_add_acpi_gpio_mappings(struct goodix_ts_data *ts)
 	const struct acpi_gpio_mapping *gpio_mapping = NULL;
 	struct device *dev = &ts->client->dev;
 	LIST_HEAD(resources);
-	int ret;
+	int irq, ret;
 
 	ts->gpio_count = 0;
 	ts->gpio_int_idx = -1;
@@ -772,6 +758,20 @@ static int goodix_add_acpi_gpio_mappings(struct goodix_ts_data *ts)
 
 	acpi_dev_free_resource_list(&resources);
 
+	/*
+	 * CHT devices should have a GpioInt + a regular GPIO ACPI resource.
+	 * Some CHT devices have a bug (where the also is bogus Interrupt
+	 * resource copied from a previous BYT based generation). i2c-core-acpi
+	 * will use the non-working Interrupt resource, fix this up.
+	 */
+	if (soc_intel_is_cht() && ts->gpio_count == 2 && ts->gpio_int_idx != -1) {
+		irq = acpi_dev_gpio_irq_get(ACPI_COMPANION(dev), 0);
+		if (irq > 0 && irq != ts->client->irq) {
+			dev_warn(dev, "Overriding IRQ %d -> %d\n", ts->client->irq, irq);
+			ts->client->irq = irq;
+		}
+	}
+
 	if (ts->gpio_count == 2 && ts->gpio_int_idx == 0) {
 		ts->irq_pin_access_method = IRQ_PIN_ACCESS_ACPI_GPIO;
 		gpio_mapping = acpi_goodix_int_first_gpios;
@@ -784,7 +784,7 @@ static int goodix_add_acpi_gpio_mappings(struct goodix_ts_data *ts)
 		dev_info(dev, "Using ACPI INTI and INTO methods for IRQ pin access\n");
 		ts->irq_pin_access_method = IRQ_PIN_ACCESS_ACPI_METHOD;
 		gpio_mapping = acpi_goodix_reset_only_gpios;
-	} else if (is_byt() && ts->gpio_count == 2 && ts->gpio_int_idx == -1) {
+	} else if (soc_intel_is_byt() && ts->gpio_count == 2 && ts->gpio_int_idx == -1) {
 		dev_info(dev, "No ACPI GpioInt resource, assuming that the GPIO order is reset, int\n");
 		ts->irq_pin_access_method = IRQ_PIN_ACCESS_ACPI_GPIO;
 		gpio_mapping = acpi_goodix_int_last_gpios;
diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index 137eea4c7bad..4871428859fd 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -1716,15 +1716,15 @@ static int rcar_canfd_channel_probe(struct rcar_canfd_global *gpriv, u32 ch,
 
 	netif_napi_add(ndev, &priv->napi, rcar_canfd_rx_poll,
 		       RCANFD_NAPI_WEIGHT);
+	spin_lock_init(&priv->tx_lock);
+	devm_can_led_init(ndev);
+	gpriv->ch[priv->channel] = priv;
 	err = register_candev(ndev);
 	if (err) {
 		dev_err(&pdev->dev,
 			"register_candev() failed, error %d\n", err);
 		goto fail_candev;
 	}
-	spin_lock_init(&priv->tx_lock);
-	devm_can_led_init(ndev);
-	gpriv->ch[priv->channel] = priv;
 	dev_info(&pdev->dev, "device registered (channel %u)\n", priv->channel);
 	return 0;
 
diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/broadcom/bnx2.c
index babc955ba64e..b47a8237c6dd 100644
--- a/drivers/net/ethernet/broadcom/bnx2.c
+++ b/drivers/net/ethernet/broadcom/bnx2.c
@@ -8212,7 +8212,7 @@ bnx2_init_board(struct pci_dev *pdev, struct net_device *dev)
 		rc = dma_set_coherent_mask(&pdev->dev, persist_dma_mask);
 		if (rc) {
 			dev_err(&pdev->dev,
-				"pci_set_consistent_dma_mask failed, aborting\n");
+				"dma_set_coherent_mask failed, aborting\n");
 			goto err_out_unmap;
 		}
 	} else if ((rc = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32))) != 0) {
diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index fa91896ae699..8093346f163b 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -891,7 +891,16 @@ static inline void ice_set_rdma_cap(struct ice_pf *pf)
  */
 static inline void ice_clear_rdma_cap(struct ice_pf *pf)
 {
-	ice_unplug_aux_dev(pf);
+	/* We can directly unplug aux device here only if the flag bit
+	 * ICE_FLAG_PLUG_AUX_DEV is not set because ice_unplug_aux_dev()
+	 * could race with ice_plug_aux_dev() called from
+	 * ice_service_task(). In this case we only clear that bit now and
+	 * aux device will be unplugged later once ice_plug_aux_device()
+	 * called from ice_service_task() finishes (see ice_service_task()).
+	 */
+	if (!test_and_clear_bit(ICE_FLAG_PLUG_AUX_DEV, pf->flags))
+		ice_unplug_aux_dev(pf);
+
 	clear_bit(ICE_FLAG_RDMA_ENA, pf->flags);
 	clear_bit(ICE_FLAG_AUX_ENA, pf->flags);
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 676e837d48cf..8a6c3716cdab 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2237,9 +2237,19 @@ static void ice_service_task(struct work_struct *work)
 		return;
 	}
 
-	if (test_and_clear_bit(ICE_FLAG_PLUG_AUX_DEV, pf->flags))
+	if (test_bit(ICE_FLAG_PLUG_AUX_DEV, pf->flags)) {
+		/* Plug aux device per request */
 		ice_plug_aux_dev(pf);
 
+		/* Mark plugging as done but check whether unplug was
+		 * requested during ice_plug_aux_dev() call
+		 * (e.g. from ice_clear_rdma_cap()) and if so then
+		 * plug aux device.
+		 */
+		if (!test_and_clear_bit(ICE_FLAG_PLUG_AUX_DEV, pf->flags))
+			ice_unplug_aux_dev(pf);
+	}
+
 	if (test_and_clear_bit(ICE_FLAG_MTU_CHANGED, pf->flags)) {
 		struct iidc_event *event;
 
diff --git a/drivers/net/ethernet/sfc/mcdi.c b/drivers/net/ethernet/sfc/mcdi.c
index be6bfd6b7ec7..50baf62b2cbc 100644
--- a/drivers/net/ethernet/sfc/mcdi.c
+++ b/drivers/net/ethernet/sfc/mcdi.c
@@ -163,9 +163,9 @@ static void efx_mcdi_send_request(struct efx_nic *efx, unsigned cmd,
 	/* Serialise with efx_mcdi_ev_cpl() and efx_mcdi_ev_death() */
 	spin_lock_bh(&mcdi->iface_lock);
 	++mcdi->seqno;
+	seqno = mcdi->seqno & SEQ_MASK;
 	spin_unlock_bh(&mcdi->iface_lock);
 
-	seqno = mcdi->seqno & SEQ_MASK;
 	xflags = 0;
 	if (mcdi->mode == MCDI_MODE_EVENTS)
 		xflags |= MCDI_HEADER_XFLAGS_EVREQ;
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
index f470f9aea50f..c97798f6290a 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@ -552,8 +552,7 @@ static const struct ieee80211_sband_iftype_data iwl_he_capa[] = {
 			.has_he = true,
 			.he_cap_elem = {
 				.mac_cap_info[0] =
-					IEEE80211_HE_MAC_CAP0_HTC_HE |
-					IEEE80211_HE_MAC_CAP0_TWT_REQ,
+					IEEE80211_HE_MAC_CAP0_HTC_HE,
 				.mac_cap_info[1] =
 					IEEE80211_HE_MAC_CAP1_TF_MAC_PAD_DUR_16US |
 					IEEE80211_HE_MAC_CAP1_MULTI_TID_AGG_RX_QOS_8,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index cde3d2ce0b85..a65024fc96dd 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -223,7 +223,6 @@ static const u8 he_if_types_ext_capa_sta[] = {
 	 [0] = WLAN_EXT_CAPA1_EXT_CHANNEL_SWITCHING,
 	 [2] = WLAN_EXT_CAPA3_MULTI_BSSID_SUPPORT,
 	 [7] = WLAN_EXT_CAPA8_OPMODE_NOTIF,
-	 [9] = WLAN_EXT_CAPA10_TWT_REQUESTER_SUPPORT,
 };
 
 static const struct wiphy_iftype_ext_capab he_iftypes_ext_capa[] = {
diff --git a/include/linux/netfilter_netdev.h b/include/linux/netfilter_netdev.h
index b4dd96e4dc8d..e6487a691136 100644
--- a/include/linux/netfilter_netdev.h
+++ b/include/linux/netfilter_netdev.h
@@ -101,7 +101,11 @@ static inline struct sk_buff *nf_hook_egress(struct sk_buff *skb, int *rc,
 	nf_hook_state_init(&state, NF_NETDEV_EGRESS,
 			   NFPROTO_NETDEV, dev, NULL, NULL,
 			   dev_net(dev), NULL);
+
+	/* nf assumes rcu_read_lock, not just read_lock_bh */
+	rcu_read_lock();
 	ret = nf_hook_slow(skb, &state, e, 0);
+	rcu_read_unlock();
 
 	if (ret == 1) {
 		return skb;
diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 301a164f17e9..358dfe6fefef 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1679,14 +1679,15 @@ int km_migrate(const struct xfrm_selector *sel, u8 dir, u8 type,
 	       const struct xfrm_migrate *m, int num_bundles,
 	       const struct xfrm_kmaddress *k,
 	       const struct xfrm_encap_tmpl *encap);
-struct xfrm_state *xfrm_migrate_state_find(struct xfrm_migrate *m, struct net *net);
+struct xfrm_state *xfrm_migrate_state_find(struct xfrm_migrate *m, struct net *net,
+						u32 if_id);
 struct xfrm_state *xfrm_state_migrate(struct xfrm_state *x,
 				      struct xfrm_migrate *m,
 				      struct xfrm_encap_tmpl *encap);
 int xfrm_migrate(const struct xfrm_selector *sel, u8 dir, u8 type,
 		 struct xfrm_migrate *m, int num_bundles,
 		 struct xfrm_kmaddress *k, struct net *net,
-		 struct xfrm_encap_tmpl *encap);
+		 struct xfrm_encap_tmpl *encap, u32 if_id);
 #endif
 
 int km_new_mapping(struct xfrm_state *x, xfrm_address_t *ipaddr, __be16 sport);
diff --git a/lib/Kconfig b/lib/Kconfig
index 5e7165e6a346..fa4b10322efc 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -45,7 +45,6 @@ config BITREVERSE
 config HAVE_ARCH_BITREVERSE
 	bool
 	default n
-	depends on BITREVERSE
 	help
 	  This option enables the use of hardware bit-reversal instructions on
 	  architectures which support such operations.
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 6c00ce302f09..1c8fb27b155a 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3969,6 +3969,7 @@ void hci_release_dev(struct hci_dev *hdev)
 	hci_dev_unlock(hdev);
 
 	ida_simple_remove(&hci_index_ida, hdev->id);
+	kfree_skb(hdev->sent_cmd);
 	kfree(hdev);
 }
 EXPORT_SYMBOL(hci_release_dev);
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 28abb0bb1c51..38f936785179 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1653,11 +1653,13 @@ int tcp_read_sock(struct sock *sk, read_descriptor_t *desc,
 				if (!copied)
 					copied = used;
 				break;
-			} else if (used <= len) {
-				seq += used;
-				copied += used;
-				offset += used;
 			}
+			if (WARN_ON_ONCE(used > len))
+				used = len;
+			seq += used;
+			copied += used;
+			offset += used;
+
 			/* If recv_actor drops the lock (e.g. TCP splice
 			 * receive) the skb pointer might be invalid when
 			 * getting here: tcp_collapse might have deleted it
diff --git a/net/key/af_key.c b/net/key/af_key.c
index de24a7d474df..9bf52a09b5ff 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -2623,7 +2623,7 @@ static int pfkey_migrate(struct sock *sk, struct sk_buff *skb,
 	}
 
 	return xfrm_migrate(&sel, dir, XFRM_POLICY_TYPE_MAIN, m, i,
-			    kma ? &k : NULL, net, NULL);
+			    kma ? &k : NULL, net, NULL, 0);
 
  out:
 	return err;
diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 74a878f213d3..1deb3d874a4b 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -9,7 +9,7 @@
  * Copyright 2007, Michael Wu <flamingice@sourmilk.net>
  * Copyright 2007-2010, Intel Corporation
  * Copyright(c) 2015-2017 Intel Deutschland GmbH
- * Copyright (C) 2018 - 2021 Intel Corporation
+ * Copyright (C) 2018 - 2022 Intel Corporation
  */
 
 #include <linux/ieee80211.h>
@@ -626,6 +626,14 @@ int ieee80211_start_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid,
 		return -EINVAL;
 	}
 
+	if (test_sta_flag(sta, WLAN_STA_MFP) &&
+	    !test_sta_flag(sta, WLAN_STA_AUTHORIZED)) {
+		ht_dbg(sdata,
+		       "MFP STA not authorized - deny BA session request %pM tid %d\n",
+		       sta->sta.addr, tid);
+		return -EINVAL;
+	}
+
 	/*
 	 * 802.11n-2009 11.5.1.1: If the initiating STA is an HT STA, is a
 	 * member of an IBSS, and has no other existing Block Ack agreement
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index f73251828782..9b4bb1460cef 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -17757,7 +17757,8 @@ void cfg80211_ch_switch_notify(struct net_device *dev,
 	wdev->chandef = *chandef;
 	wdev->preset_chandef = *chandef;
 
-	if (wdev->iftype == NL80211_IFTYPE_STATION &&
+	if ((wdev->iftype == NL80211_IFTYPE_STATION ||
+	     wdev->iftype == NL80211_IFTYPE_P2P_CLIENT) &&
 	    !WARN_ON(!wdev->current_bss))
 		cfg80211_update_assoc_bss_entry(wdev, chandef->chan);
 
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 4924b9135c6e..fbc0b2798184 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -4257,7 +4257,7 @@ static bool xfrm_migrate_selector_match(const struct xfrm_selector *sel_cmp,
 }
 
 static struct xfrm_policy *xfrm_migrate_policy_find(const struct xfrm_selector *sel,
-						    u8 dir, u8 type, struct net *net)
+						    u8 dir, u8 type, struct net *net, u32 if_id)
 {
 	struct xfrm_policy *pol, *ret = NULL;
 	struct hlist_head *chain;
@@ -4266,7 +4266,8 @@ static struct xfrm_policy *xfrm_migrate_policy_find(const struct xfrm_selector *
 	spin_lock_bh(&net->xfrm.xfrm_policy_lock);
 	chain = policy_hash_direct(net, &sel->daddr, &sel->saddr, sel->family, dir);
 	hlist_for_each_entry(pol, chain, bydst) {
-		if (xfrm_migrate_selector_match(sel, &pol->selector) &&
+		if ((if_id == 0 || pol->if_id == if_id) &&
+		    xfrm_migrate_selector_match(sel, &pol->selector) &&
 		    pol->type == type) {
 			ret = pol;
 			priority = ret->priority;
@@ -4278,7 +4279,8 @@ static struct xfrm_policy *xfrm_migrate_policy_find(const struct xfrm_selector *
 		if ((pol->priority >= priority) && ret)
 			break;
 
-		if (xfrm_migrate_selector_match(sel, &pol->selector) &&
+		if ((if_id == 0 || pol->if_id == if_id) &&
+		    xfrm_migrate_selector_match(sel, &pol->selector) &&
 		    pol->type == type) {
 			ret = pol;
 			break;
@@ -4394,7 +4396,7 @@ static int xfrm_migrate_check(const struct xfrm_migrate *m, int num_migrate)
 int xfrm_migrate(const struct xfrm_selector *sel, u8 dir, u8 type,
 		 struct xfrm_migrate *m, int num_migrate,
 		 struct xfrm_kmaddress *k, struct net *net,
-		 struct xfrm_encap_tmpl *encap)
+		 struct xfrm_encap_tmpl *encap, u32 if_id)
 {
 	int i, err, nx_cur = 0, nx_new = 0;
 	struct xfrm_policy *pol = NULL;
@@ -4413,14 +4415,14 @@ int xfrm_migrate(const struct xfrm_selector *sel, u8 dir, u8 type,
 	}
 
 	/* Stage 1 - find policy */
-	if ((pol = xfrm_migrate_policy_find(sel, dir, type, net)) == NULL) {
+	if ((pol = xfrm_migrate_policy_find(sel, dir, type, net, if_id)) == NULL) {
 		err = -ENOENT;
 		goto out;
 	}
 
 	/* Stage 2 - find and update state(s) */
 	for (i = 0, mp = m; i < num_migrate; i++, mp++) {
-		if ((x = xfrm_migrate_state_find(mp, net))) {
+		if ((x = xfrm_migrate_state_find(mp, net, if_id))) {
 			x_cur[nx_cur] = x;
 			nx_cur++;
 			xc = xfrm_state_migrate(x, mp, encap);
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 100b4b3723e7..f7bfa1916968 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -1578,9 +1578,6 @@ static struct xfrm_state *xfrm_state_clone(struct xfrm_state *orig,
 	memcpy(&x->mark, &orig->mark, sizeof(x->mark));
 	memcpy(&x->props.smark, &orig->props.smark, sizeof(x->props.smark));
 
-	if (xfrm_init_state(x) < 0)
-		goto error;
-
 	x->props.flags = orig->props.flags;
 	x->props.extra_flags = orig->props.extra_flags;
 
@@ -1605,7 +1602,8 @@ static struct xfrm_state *xfrm_state_clone(struct xfrm_state *orig,
 	return NULL;
 }
 
-struct xfrm_state *xfrm_migrate_state_find(struct xfrm_migrate *m, struct net *net)
+struct xfrm_state *xfrm_migrate_state_find(struct xfrm_migrate *m, struct net *net,
+						u32 if_id)
 {
 	unsigned int h;
 	struct xfrm_state *x = NULL;
@@ -1621,6 +1619,8 @@ struct xfrm_state *xfrm_migrate_state_find(struct xfrm_migrate *m, struct net *n
 				continue;
 			if (m->reqid && x->props.reqid != m->reqid)
 				continue;
+			if (if_id != 0 && x->if_id != if_id)
+				continue;
 			if (!xfrm_addr_equal(&x->id.daddr, &m->old_daddr,
 					     m->old_family) ||
 			    !xfrm_addr_equal(&x->props.saddr, &m->old_saddr,
@@ -1636,6 +1636,8 @@ struct xfrm_state *xfrm_migrate_state_find(struct xfrm_migrate *m, struct net *n
 			if (x->props.mode != m->mode ||
 			    x->id.proto != m->proto)
 				continue;
+			if (if_id != 0 && x->if_id != if_id)
+				continue;
 			if (!xfrm_addr_equal(&x->id.daddr, &m->old_daddr,
 					     m->old_family) ||
 			    !xfrm_addr_equal(&x->props.saddr, &m->old_saddr,
@@ -1662,6 +1664,11 @@ struct xfrm_state *xfrm_state_migrate(struct xfrm_state *x,
 	if (!xc)
 		return NULL;
 
+	xc->props.family = m->new_family;
+
+	if (xfrm_init_state(xc) < 0)
+		goto error;
+
 	memcpy(&xc->id.daddr, &m->new_daddr, sizeof(xc->id.daddr));
 	memcpy(&xc->props.saddr, &m->new_saddr, sizeof(xc->props.saddr));
 
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index c60441be883a..a8c142bd1263 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -629,13 +629,8 @@ static struct xfrm_state *xfrm_state_construct(struct net *net,
 
 	xfrm_smark_init(attrs, &x->props.smark);
 
-	if (attrs[XFRMA_IF_ID]) {
+	if (attrs[XFRMA_IF_ID])
 		x->if_id = nla_get_u32(attrs[XFRMA_IF_ID]);
-		if (!x->if_id) {
-			err = -EINVAL;
-			goto error;
-		}
-	}
 
 	err = __xfrm_init_state(x, false, attrs[XFRMA_OFFLOAD_DEV]);
 	if (err)
@@ -1431,13 +1426,8 @@ static int xfrm_alloc_userspi(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 	mark = xfrm_mark_get(attrs, &m);
 
-	if (attrs[XFRMA_IF_ID]) {
+	if (attrs[XFRMA_IF_ID])
 		if_id = nla_get_u32(attrs[XFRMA_IF_ID]);
-		if (!if_id) {
-			err = -EINVAL;
-			goto out_noput;
-		}
-	}
 
 	if (p->info.seq) {
 		x = xfrm_find_acq_byseq(net, mark, p->info.seq);
@@ -1750,13 +1740,8 @@ static struct xfrm_policy *xfrm_policy_construct(struct net *net, struct xfrm_us
 
 	xfrm_mark_get(attrs, &xp->mark);
 
-	if (attrs[XFRMA_IF_ID]) {
+	if (attrs[XFRMA_IF_ID])
 		xp->if_id = nla_get_u32(attrs[XFRMA_IF_ID]);
-		if (!xp->if_id) {
-			err = -EINVAL;
-			goto error;
-		}
-	}
 
 	return xp;
  error:
@@ -2607,6 +2592,7 @@ static int xfrm_do_migrate(struct sk_buff *skb, struct nlmsghdr *nlh,
 	int n = 0;
 	struct net *net = sock_net(skb->sk);
 	struct xfrm_encap_tmpl  *encap = NULL;
+	u32 if_id = 0;
 
 	if (attrs[XFRMA_MIGRATE] == NULL)
 		return -EINVAL;
@@ -2631,7 +2617,10 @@ static int xfrm_do_migrate(struct sk_buff *skb, struct nlmsghdr *nlh,
 			return -ENOMEM;
 	}
 
-	err = xfrm_migrate(&pi->sel, pi->dir, type, m, n, kmp, net, encap);
+	if (attrs[XFRMA_IF_ID])
+		if_id = nla_get_u32(attrs[XFRMA_IF_ID]);
+
+	err = xfrm_migrate(&pi->sel, pi->dir, type, m, n, kmp, net, encap, if_id);
 
 	kfree(encap);
 
diff --git a/tools/testing/selftests/vm/userfaultfd.c b/tools/testing/selftests/vm/userfaultfd.c
index 9354a5e0321c..3f7f5bd4e4c0 100644
--- a/tools/testing/selftests/vm/userfaultfd.c
+++ b/tools/testing/selftests/vm/userfaultfd.c
@@ -46,6 +46,7 @@
 #include <signal.h>
 #include <poll.h>
 #include <string.h>
+#include <linux/mman.h>
 #include <sys/mman.h>
 #include <sys/syscall.h>
 #include <sys/ioctl.h>
