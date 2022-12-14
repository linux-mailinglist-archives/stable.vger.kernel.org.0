Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE4A64CD3B
	for <lists+stable@lfdr.de>; Wed, 14 Dec 2022 16:47:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238618AbiLNPrC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Dec 2022 10:47:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238812AbiLNPrA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Dec 2022 10:47:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F28102229C;
        Wed, 14 Dec 2022 07:46:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E9BC61B05;
        Wed, 14 Dec 2022 15:46:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1253DC433EF;
        Wed, 14 Dec 2022 15:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671032816;
        bh=j/0WOiU0o/n4vCgw3S+/+mNulGgJ6FNV8zrO7DVFxCA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AbVeK1Ws66xHIF31db4nJZxOYTfm/3DkxKmKfNEpCCMdzN+jlWwN0Q26OhOZs2AEQ
         G+9280xYBqw4oOvakfqC9vmFwoXR8m3/6jIZWG3M3HKqEEMzgFAjOPI2Zkzk9ng1xn
         oVjEUHUiMbPXM5DIwZ5HGuuRH4ty6L/UpnaHrv2M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.9.336
Date:   Wed, 14 Dec 2022 16:46:48 +0100
Message-Id: <167103280813183@kroah.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <167103280818230@kroah.com>
References: <167103280818230@kroah.com>
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

diff --git a/Makefile b/Makefile
index 36aed335c6b9..a2c74e89f20e 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,6 @@
 VERSION = 4
 PATCHLEVEL = 9
-SUBLEVEL = 335
+SUBLEVEL = 336
 EXTRAVERSION =
 NAME = Roaring Lionus
 
diff --git a/arch/arm/boot/dts/rk3036-evb.dts b/arch/arm/boot/dts/rk3036-evb.dts
index 8db9e9b197a2..9f9e055a47dc 100644
--- a/arch/arm/boot/dts/rk3036-evb.dts
+++ b/arch/arm/boot/dts/rk3036-evb.dts
@@ -69,7 +69,7 @@
 &i2c1 {
 	status = "okay";
 
-	hym8563: hym8563@51 {
+	hym8563: rtc@51 {
 		compatible = "haoyu,hym8563";
 		reg = <0x51>;
 		#clock-cells = <0>;
diff --git a/arch/arm/boot/dts/rk3188-radxarock.dts b/arch/arm/boot/dts/rk3188-radxarock.dts
index 1da46d138029..54e8e5dca93b 100644
--- a/arch/arm/boot/dts/rk3188-radxarock.dts
+++ b/arch/arm/boot/dts/rk3188-radxarock.dts
@@ -104,7 +104,7 @@
 		#sound-dai-cells = <0>;
 	};
 
-	ir_recv: gpio-ir-receiver {
+	ir_recv: ir-receiver {
 		compatible = "gpio-ir-receiver";
 		gpios = <&gpio0 10 1>;
 		pinctrl-names = "default";
diff --git a/arch/arm/boot/dts/rk3288-evb-act8846.dts b/arch/arm/boot/dts/rk3288-evb-act8846.dts
index 041dd5d2d18c..0fb6843cb26c 100644
--- a/arch/arm/boot/dts/rk3288-evb-act8846.dts
+++ b/arch/arm/boot/dts/rk3288-evb-act8846.dts
@@ -91,7 +91,7 @@
 		vin-supply = <&vcc_sys>;
 	};
 
-	hym8563@51 {
+	rtc@51 {
 		compatible = "haoyu,hym8563";
 		reg = <0x51>;
 
diff --git a/arch/arm/boot/dts/rk3288-firefly.dtsi b/arch/arm/boot/dts/rk3288-firefly.dtsi
index 114c90fb65e2..f1bceeea8124 100644
--- a/arch/arm/boot/dts/rk3288-firefly.dtsi
+++ b/arch/arm/boot/dts/rk3288-firefly.dtsi
@@ -253,7 +253,7 @@
 		vin-supply = <&vcc_sys>;
 	};
 
-	hym8563: hym8563@51 {
+	hym8563: rtc@51 {
 		compatible = "haoyu,hym8563";
 		reg = <0x51>;
 		#clock-cells = <0>;
diff --git a/arch/arm/boot/dts/rk3288-miqi.dts b/arch/arm/boot/dts/rk3288-miqi.dts
index 24488421f0f0..05ad29271aa5 100644
--- a/arch/arm/boot/dts/rk3288-miqi.dts
+++ b/arch/arm/boot/dts/rk3288-miqi.dts
@@ -186,7 +186,7 @@
 		vin-supply = <&vcc_sys>;
 	};
 
-	hym8563: hym8563@51 {
+	hym8563: rtc@51 {
 		compatible = "haoyu,hym8563";
 		reg = <0x51>;
 		#clock-cells = <0>;
diff --git a/arch/arm/boot/dts/rk3288-rock2-square.dts b/arch/arm/boot/dts/rk3288-rock2-square.dts
index dd3ad2e93a6d..61490f03918c 100644
--- a/arch/arm/boot/dts/rk3288-rock2-square.dts
+++ b/arch/arm/boot/dts/rk3288-rock2-square.dts
@@ -159,7 +159,7 @@
 };
 
 &i2c0 {
-	hym8563: hym8563@51 {
+	hym8563: rtc@51 {
 		compatible = "haoyu,hym8563";
 		reg = <0x51>;
 		#clock-cells = <0>;
diff --git a/arch/arm/include/asm/perf_event.h b/arch/arm/include/asm/perf_event.h
index 4f9dec489931..c5d27140834e 100644
--- a/arch/arm/include/asm/perf_event.h
+++ b/arch/arm/include/asm/perf_event.h
@@ -21,7 +21,7 @@ extern unsigned long perf_misc_flags(struct pt_regs *regs);
 
 #define perf_arch_fetch_caller_regs(regs, __ip) { \
 	(regs)->ARM_pc = (__ip); \
-	(regs)->ARM_fp = (unsigned long) __builtin_frame_address(0); \
+	frame_pointer((regs)) = (unsigned long) __builtin_frame_address(0); \
 	(regs)->ARM_sp = current_stack_pointer; \
 	(regs)->ARM_cpsr = SVC_MODE; \
 }
diff --git a/drivers/gpio/gpio-amd8111.c b/drivers/gpio/gpio-amd8111.c
index 30ad7d7c1678..f8486bac12d0 100644
--- a/drivers/gpio/gpio-amd8111.c
+++ b/drivers/gpio/gpio-amd8111.c
@@ -231,7 +231,10 @@ static int __init amd_gpio_init(void)
 		ioport_unmap(gp.pm);
 		goto out;
 	}
+	return 0;
+
 out:
+	pci_dev_put(pdev);
 	return err;
 }
 
@@ -239,6 +242,7 @@ static void __exit amd_gpio_exit(void)
 {
 	gpiochip_remove(&gp.chip);
 	ioport_unmap(gp.pm);
+	pci_dev_put(gp.pdev);
 }
 
 module_init(amd_gpio_init);
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index a056850328ef..c5207ed5d65b 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1112,6 +1112,9 @@ static s32 snto32(__u32 value, unsigned n)
 	if (!value || !n)
 		return 0;
 
+	if (n > 32)
+		n = 32;
+
 	switch (n) {
 	case 8:  return ((__s8)value);
 	case 16: return ((__s16)value);
diff --git a/drivers/hid/hid-lg4ff.c b/drivers/hid/hid-lg4ff.c
index 1b109a5cf922..83ae2a639a03 100644
--- a/drivers/hid/hid-lg4ff.c
+++ b/drivers/hid/hid-lg4ff.c
@@ -880,6 +880,12 @@ static ssize_t lg4ff_alternate_modes_store(struct device *dev, struct device_att
 		return -ENOMEM;
 
 	i = strlen(lbuf);
+
+	if (i == 0) {
+		kfree(lbuf);
+		return -EINVAL;
+	}
+
 	if (lbuf[i-1] == '\n') {
 		if (i == 1) {
 			kfree(lbuf);
diff --git a/drivers/media/v4l2-core/v4l2-dv-timings.c b/drivers/media/v4l2-core/v4l2-dv-timings.c
index 12e04ac6a9ee..32931421e2e5 100644
--- a/drivers/media/v4l2-core/v4l2-dv-timings.c
+++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
@@ -155,6 +155,8 @@ bool v4l2_valid_dv_timings(const struct v4l2_dv_timings *t,
 	const struct v4l2_bt_timings *bt = &t->bt;
 	const struct v4l2_bt_timings_cap *cap = &dvcap->bt;
 	u32 caps = cap->capabilities;
+	const u32 max_vert = 10240;
+	u32 max_hor = 3 * bt->width;
 
 	if (t->type != V4L2_DV_BT_656_1120)
 		return false;
@@ -176,14 +178,20 @@ bool v4l2_valid_dv_timings(const struct v4l2_dv_timings *t,
 	if (!bt->interlaced &&
 	    (bt->il_vbackporch || bt->il_vsync || bt->il_vfrontporch))
 		return false;
-	if (bt->hfrontporch > 2 * bt->width ||
-	    bt->hsync > 1024 || bt->hbackporch > 1024)
+	/*
+	 * Some video receivers cannot properly separate the frontporch,
+	 * backporch and sync values, and instead they only have the total
+	 * blanking. That can be assigned to any of these three fields.
+	 * So just check that none of these are way out of range.
+	 */
+	if (bt->hfrontporch > max_hor ||
+	    bt->hsync > max_hor || bt->hbackporch > max_hor)
 		return false;
-	if (bt->vfrontporch > 4096 ||
-	    bt->vsync > 128 || bt->vbackporch > 4096)
+	if (bt->vfrontporch > max_vert ||
+	    bt->vsync > max_vert || bt->vbackporch > max_vert)
 		return false;
-	if (bt->interlaced && (bt->il_vfrontporch > 4096 ||
-	    bt->il_vsync > 128 || bt->il_vbackporch > 4096))
+	if (bt->interlaced && (bt->il_vfrontporch > max_vert ||
+	    bt->il_vsync > max_vert || bt->il_vbackporch > max_vert))
 		return false;
 	return fnc == NULL || fnc(t, fnc_handle);
 }
diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 560b2996911a..f3e2aba53ffa 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -13,6 +13,7 @@
  *     - JMicron (hardware and technical support)
  */
 
+#include <linux/bitfield.h>
 #include <linux/delay.h>
 #include <linux/highmem.h>
 #include <linux/io.h>
@@ -239,6 +240,7 @@ static void sdhci_init(struct sdhci_host *host, int soft)
 	if (soft) {
 		/* force clock reconfiguration */
 		host->clock = 0;
+		host->reinit_uhs = true;
 		mmc->ops->set_ios(mmc, &mmc->ios);
 	}
 }
@@ -1266,10 +1268,9 @@ u16 sdhci_calc_clk(struct sdhci_host *host, unsigned int clock,
 
 			clk = sdhci_readw(host, SDHCI_CLOCK_CONTROL);
 			pre_val = sdhci_get_preset_value(host);
-			div = (pre_val & SDHCI_PRESET_SDCLK_FREQ_MASK)
-				>> SDHCI_PRESET_SDCLK_FREQ_SHIFT;
+			div = FIELD_GET(SDHCI_PRESET_SDCLK_FREQ_MASK, pre_val);
 			if (host->clk_mul &&
-				(pre_val & SDHCI_PRESET_CLKGEN_SEL_MASK)) {
+				(pre_val & SDHCI_PRESET_CLKGEN_SEL)) {
 				clk = SDHCI_PROG_CLOCK_MODE;
 				real_div = div + 1;
 				clk_mul = host->clk_mul;
@@ -1580,12 +1581,47 @@ void sdhci_set_uhs_signaling(struct sdhci_host *host, unsigned timing)
 }
 EXPORT_SYMBOL_GPL(sdhci_set_uhs_signaling);
 
+static bool sdhci_timing_has_preset(unsigned char timing)
+{
+	switch (timing) {
+	case MMC_TIMING_UHS_SDR12:
+	case MMC_TIMING_UHS_SDR25:
+	case MMC_TIMING_UHS_SDR50:
+	case MMC_TIMING_UHS_SDR104:
+	case MMC_TIMING_UHS_DDR50:
+	case MMC_TIMING_MMC_DDR52:
+		return true;
+	};
+	return false;
+}
+
+static bool sdhci_preset_needed(struct sdhci_host *host, unsigned char timing)
+{
+	return !(host->quirks2 & SDHCI_QUIRK2_PRESET_VALUE_BROKEN) &&
+	       sdhci_timing_has_preset(timing);
+}
+
+static bool sdhci_presetable_values_change(struct sdhci_host *host, struct mmc_ios *ios)
+{
+	/*
+	 * Preset Values are: Driver Strength, Clock Generator and SDCLK/RCLK
+	 * Frequency. Check if preset values need to be enabled, or the Driver
+	 * Strength needs updating. Note, clock changes are handled separately.
+	 */
+	return !host->preset_enabled &&
+	       (sdhci_preset_needed(host, ios->timing) || host->drv_type != ios->drv_type);
+}
+
 static void sdhci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 {
 	struct sdhci_host *host = mmc_priv(mmc);
+	bool reinit_uhs = host->reinit_uhs;
+	bool turning_on_clk = false;
 	unsigned long flags;
 	u8 ctrl;
 
+	host->reinit_uhs = false;
+
 	spin_lock_irqsave(&host->lock, flags);
 
 	if (host->flags & SDHCI_DEVICE_DEAD) {
@@ -1611,6 +1647,8 @@ static void sdhci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 		sdhci_enable_preset_value(host, false);
 
 	if (!ios->clock || ios->clock != host->clock) {
+		turning_on_clk = ios->clock && !host->clock;
+
 		host->ops->set_clock(host, ios->clock);
 		host->clock = ios->clock;
 
@@ -1637,6 +1675,17 @@ static void sdhci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 
 	host->ops->set_bus_width(host, ios->bus_width);
 
+	/*
+	 * Special case to avoid multiple clock changes during voltage
+	 * switching.
+	 */
+	if (!reinit_uhs &&
+	    turning_on_clk &&
+	    host->timing == ios->timing &&
+	    host->version >= SDHCI_SPEC_300 &&
+	    !sdhci_presetable_values_change(host, ios))
+		goto out;
+
 	ctrl = sdhci_readb(host, SDHCI_HOST_CONTROL);
 
 	if ((ios->timing == MMC_TIMING_SD_HS ||
@@ -1682,6 +1731,7 @@ static void sdhci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 			}
 
 			sdhci_writew(host, ctrl_2, SDHCI_HOST_CONTROL2);
+			host->drv_type = ios->drv_type;
 		} else {
 			/*
 			 * According to SDHC Spec v3.00, if the Preset Value
@@ -1709,26 +1759,21 @@ static void sdhci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 		host->ops->set_uhs_signaling(host, ios->timing);
 		host->timing = ios->timing;
 
-		if (!(host->quirks2 & SDHCI_QUIRK2_PRESET_VALUE_BROKEN) &&
-				((ios->timing == MMC_TIMING_UHS_SDR12) ||
-				 (ios->timing == MMC_TIMING_UHS_SDR25) ||
-				 (ios->timing == MMC_TIMING_UHS_SDR50) ||
-				 (ios->timing == MMC_TIMING_UHS_SDR104) ||
-				 (ios->timing == MMC_TIMING_UHS_DDR50) ||
-				 (ios->timing == MMC_TIMING_MMC_DDR52))) {
+		if (sdhci_preset_needed(host, ios->timing)) {
 			u16 preset;
 
 			sdhci_enable_preset_value(host, true);
 			preset = sdhci_get_preset_value(host);
-			ios->drv_type = (preset & SDHCI_PRESET_DRV_MASK)
-				>> SDHCI_PRESET_DRV_SHIFT;
+			ios->drv_type = FIELD_GET(SDHCI_PRESET_DRV_MASK,
+						  preset);
+			host->drv_type = ios->drv_type;
 		}
 
 		/* Re-enable SD Clock */
 		host->ops->set_clock(host, host->clock);
 	} else
 		sdhci_writeb(host, ctrl, SDHCI_HOST_CONTROL);
-
+out:
 	/*
 	 * Some (ENE) controllers go apeshit on some ios operation,
 	 * signalling timeout and CRC errors even on CMD0. Resetting
@@ -2882,6 +2927,7 @@ int sdhci_resume_host(struct sdhci_host *host)
 		sdhci_init(host, 0);
 		host->pwr = 0;
 		host->clock = 0;
+		host->reinit_uhs = true;
 		mmc->ops->set_ios(mmc, &mmc->ios);
 	} else {
 		sdhci_init(host, (host->mmc->pm_flags & MMC_PM_KEEP_POWER));
@@ -2946,6 +2992,7 @@ int sdhci_runtime_resume_host(struct sdhci_host *host)
 	/* Force clock and power re-program */
 	host->pwr = 0;
 	host->clock = 0;
+	host->reinit_uhs = true;
 	mmc->ops->start_signal_voltage_switch(mmc, &mmc->ios);
 	mmc->ops->set_ios(mmc, &mmc->ios);
 
diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
index 062db5f6ccac..4542f164a43f 100644
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -13,6 +13,7 @@
 #ifndef __SDHCI_HW_H
 #define __SDHCI_HW_H
 
+#include <linux/bits.h>
 #include <linux/scatterlist.h>
 #include <linux/compiler.h>
 #include <linux/types.h>
@@ -244,12 +245,9 @@
 #define SDHCI_PRESET_FOR_SDR104        0x6C
 #define SDHCI_PRESET_FOR_DDR50 0x6E
 #define SDHCI_PRESET_FOR_HS400 0x74 /* Non-standard */
-#define SDHCI_PRESET_DRV_MASK  0xC000
-#define SDHCI_PRESET_DRV_SHIFT  14
-#define SDHCI_PRESET_CLKGEN_SEL_MASK   0x400
-#define SDHCI_PRESET_CLKGEN_SEL_SHIFT	10
-#define SDHCI_PRESET_SDCLK_FREQ_MASK   0x3FF
-#define SDHCI_PRESET_SDCLK_FREQ_SHIFT	0
+#define SDHCI_PRESET_DRV_MASK		GENMASK(15, 14)
+#define SDHCI_PRESET_CLKGEN_SEL		BIT(10)
+#define SDHCI_PRESET_SDCLK_FREQ_MASK	GENMASK(9, 0)
 
 #define SDHCI_SLOT_INT_STATUS	0xFC
 
@@ -468,6 +466,8 @@ struct sdhci_host {
 
 	unsigned int clock;	/* Current clock (MHz) */
 	u8 pwr;			/* Current voltage */
+	u8 drv_type;		/* Current UHS-I driver type */
+	bool reinit_uhs;	/* Force UHS-related re-initialization */
 
 	bool runtime_suspended;	/* Host is runtime suspended */
 	bool bus_on;		/* Bus power prevents runtime suspend */
diff --git a/drivers/net/ethernet/aeroflex/greth.c b/drivers/net/ethernet/aeroflex/greth.c
index 31e02ca56572..aa2d1b088df6 100644
--- a/drivers/net/ethernet/aeroflex/greth.c
+++ b/drivers/net/ethernet/aeroflex/greth.c
@@ -261,6 +261,7 @@ static int greth_init_rings(struct greth_private *greth)
 			if (dma_mapping_error(greth->dev, dma_addr)) {
 				if (netif_msg_ifup(greth))
 					dev_err(greth->dev, "Could not create initial DMA mapping\n");
+				dev_kfree_skb(skb);
 				goto cleanup;
 			}
 			greth->rx_skbuff[i] = skb;
diff --git a/drivers/net/ethernet/hisilicon/hisi_femac.c b/drivers/net/ethernet/hisilicon/hisi_femac.c
index ced185962ef8..77f61167e238 100644
--- a/drivers/net/ethernet/hisilicon/hisi_femac.c
+++ b/drivers/net/ethernet/hisilicon/hisi_femac.c
@@ -295,7 +295,7 @@ static int hisi_femac_rx(struct net_device *dev, int limit)
 		skb->protocol = eth_type_trans(skb, dev);
 		napi_gro_receive(&priv->napi, skb);
 		dev->stats.rx_packets++;
-		dev->stats.rx_bytes += skb->len;
+		dev->stats.rx_bytes += len;
 next:
 		pos = (pos + 1) % rxq->num;
 		if (rx_pkts_num >= limit)
diff --git a/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c b/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
index dd24c352b200..4dc6c3e99d15 100644
--- a/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
+++ b/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
@@ -498,7 +498,7 @@ static int hix5hd2_rx(struct net_device *dev, int limit)
 		skb->protocol = eth_type_trans(skb, dev);
 		napi_gro_receive(&priv->napi, skb);
 		dev->stats.rx_packets++;
-		dev->stats.rx_bytes += skb->len;
+		dev->stats.rx_bytes += len;
 next:
 		pos = dma_ring_incr(pos, RX_DESC_NUM);
 	}
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 5d7967c03554..8f459f910f73 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -5875,9 +5875,9 @@ static netdev_tx_t e1000_xmit_frame(struct sk_buff *skb,
 		e1000_tx_queue(tx_ring, tx_flags, count);
 		/* Make sure there is space in the ring for the next send. */
 		e1000_maybe_stop_tx(tx_ring,
-				    (MAX_SKB_FRAGS *
+				    ((MAX_SKB_FRAGS + 1) *
 				     DIV_ROUND_UP(PAGE_SIZE,
-						  adapter->tx_fifo_limit) + 2));
+						  adapter->tx_fifo_limit) + 4));
 
 		if (!skb->xmit_more ||
 		    netif_xmit_stopped(netdev_get_tx_queue(netdev, 0))) {
diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c b/drivers/net/ethernet/intel/igb/igb_ethtool.c
index b02e262ed76a..fa23c93ef740 100644
--- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
+++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
@@ -1401,6 +1401,8 @@ static int igb_intr_test(struct igb_adapter *adapter, u64 *data)
 			*data = 1;
 			return -1;
 		}
+		wr32(E1000_IVAR_MISC, E1000_IVAR_VALID << 8);
+		wr32(E1000_EIMS, BIT(0));
 	} else if (adapter->flags & IGB_FLAG_HAS_MSI) {
 		shared_int = false;
 		if (request_irq(irq,
diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index ccacdcfb5932..b2d42d276efd 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -3278,7 +3278,7 @@ static void mvneta_percpu_elect(struct mvneta_port *pp)
 	/* Use the cpu associated to the rxq when it is online, in all
 	 * the other cases, use the cpu 0 which can't be offline.
 	 */
-	if (cpu_online(pp->rxq_def))
+	if (pp->rxq_def < nr_cpu_ids && cpu_online(pp->rxq_def))
 		elected_cpu = pp->rxq_def;
 
 	max_cpu = num_present_cpus();
diff --git a/drivers/net/ethernet/microchip/encx24j600-regmap.c b/drivers/net/ethernet/microchip/encx24j600-regmap.c
index b5de665ce718..668a63abe0cb 100644
--- a/drivers/net/ethernet/microchip/encx24j600-regmap.c
+++ b/drivers/net/ethernet/microchip/encx24j600-regmap.c
@@ -363,7 +363,7 @@ static int regmap_encx24j600_phy_reg_read(void *context, unsigned int reg,
 		goto err_out;
 
 	usleep_range(26, 100);
-	while ((ret = regmap_read(ctx->regmap, MISTAT, &mistat) != 0) &&
+	while (((ret = regmap_read(ctx->regmap, MISTAT, &mistat)) == 0) &&
 	       (mistat & BUSY))
 		cpu_relax();
 
@@ -401,7 +401,7 @@ static int regmap_encx24j600_phy_reg_write(void *context, unsigned int reg,
 		goto err_out;
 
 	usleep_range(26, 100);
-	while ((ret = regmap_read(ctx->regmap, MISTAT, &mistat) != 0) &&
+	while (((ret = regmap_read(ctx->regmap, MISTAT, &mistat)) == 0) &&
 	       (mistat & BUSY))
 		cpu_relax();
 
diff --git a/drivers/net/ieee802154/cc2520.c b/drivers/net/ieee802154/cc2520.c
index 436cf2007138..92aefaf8ea19 100644
--- a/drivers/net/ieee802154/cc2520.c
+++ b/drivers/net/ieee802154/cc2520.c
@@ -979,7 +979,7 @@ static int cc2520_hw_init(struct cc2520_private *priv)
 
 		if (timeout-- <= 0) {
 			dev_err(&priv->spi->dev, "oscillator start failed!\n");
-			return ret;
+			return -ETIMEDOUT;
 		}
 		udelay(1);
 	} while (!(status & CC2520_STATUS_XOSC32M_STABLE));
diff --git a/drivers/net/plip/plip.c b/drivers/net/plip/plip.c
index 9c4b41a4df7d..061894ba271c 100644
--- a/drivers/net/plip/plip.c
+++ b/drivers/net/plip/plip.c
@@ -449,12 +449,12 @@ plip_bh_timeout_error(struct net_device *dev, struct net_local *nl,
 	}
 	rcv->state = PLIP_PK_DONE;
 	if (rcv->skb) {
-		kfree_skb(rcv->skb);
+		dev_kfree_skb_irq(rcv->skb);
 		rcv->skb = NULL;
 	}
 	snd->state = PLIP_PK_DONE;
 	if (snd->skb) {
-		dev_kfree_skb(snd->skb);
+		dev_consume_skb_irq(snd->skb);
 		snd->skb = NULL;
 	}
 	spin_unlock_irq(&nl->lock);
diff --git a/drivers/net/xen-netback/common.h b/drivers/net/xen-netback/common.h
index bfa3c6aaebe6..e5f254500c1c 100644
--- a/drivers/net/xen-netback/common.h
+++ b/drivers/net/xen-netback/common.h
@@ -48,7 +48,6 @@
 #include <linux/debugfs.h>
 
 typedef unsigned int pending_ring_idx_t;
-#define INVALID_PENDING_RING_IDX (~0U)
 
 struct pending_tx_info {
 	struct xen_netif_tx_request req; /* tx request */
@@ -82,8 +81,6 @@ struct xenvif_rx_meta {
 /* Discriminate from any valid pending_idx value. */
 #define INVALID_PENDING_IDX 0xFFFF
 
-#define MAX_BUFFER_OFFSET XEN_PAGE_SIZE
-
 #define MAX_PENDING_REQS XEN_NETIF_TX_RING_SIZE
 
 /* The maximum number of frags is derived from the size of a grant (same
@@ -345,11 +342,6 @@ void xenvif_free(struct xenvif *vif);
 int xenvif_xenbus_init(void);
 void xenvif_xenbus_fini(void);
 
-int xenvif_schedulable(struct xenvif *vif);
-
-int xenvif_queue_stopped(struct xenvif_queue *queue);
-void xenvif_wake_queue(struct xenvif_queue *queue);
-
 /* (Un)Map communication rings. */
 void xenvif_unmap_frontend_data_rings(struct xenvif_queue *queue);
 int xenvif_map_frontend_data_rings(struct xenvif_queue *queue,
@@ -372,17 +364,13 @@ int xenvif_dealloc_kthread(void *data);
 irqreturn_t xenvif_ctrl_irq_fn(int irq, void *data);
 
 bool xenvif_have_rx_work(struct xenvif_queue *queue, bool test_kthread);
-void xenvif_rx_action(struct xenvif_queue *queue);
-void xenvif_rx_queue_tail(struct xenvif_queue *queue, struct sk_buff *skb);
+bool xenvif_rx_queue_tail(struct xenvif_queue *queue, struct sk_buff *skb);
 
 void xenvif_carrier_on(struct xenvif *vif);
 
 /* Callback from stack when TX packet can be released */
 void xenvif_zerocopy_callback(struct ubuf_info *ubuf, bool zerocopy_success);
 
-/* Unmap a pending page and release it back to the guest */
-void xenvif_idx_unmap(struct xenvif_queue *queue, u16 pending_idx);
-
 static inline pending_ring_idx_t nr_pending_reqs(struct xenvif_queue *queue)
 {
 	return MAX_PENDING_REQS -
diff --git a/drivers/net/xen-netback/interface.c b/drivers/net/xen-netback/interface.c
index d9d06dc689ed..b83777d4d35e 100644
--- a/drivers/net/xen-netback/interface.c
+++ b/drivers/net/xen-netback/interface.c
@@ -69,7 +69,7 @@ void xenvif_skb_zerocopy_complete(struct xenvif_queue *queue)
 	wake_up(&queue->dealloc_wq);
 }
 
-int xenvif_schedulable(struct xenvif *vif)
+static int xenvif_schedulable(struct xenvif *vif)
 {
 	return netif_running(vif->dev) &&
 		test_bit(VIF_STATUS_CONNECTED, &vif->status) &&
@@ -177,20 +177,6 @@ irqreturn_t xenvif_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-int xenvif_queue_stopped(struct xenvif_queue *queue)
-{
-	struct net_device *dev = queue->vif->dev;
-	unsigned int id = queue->id;
-	return netif_tx_queue_stopped(netdev_get_tx_queue(dev, id));
-}
-
-void xenvif_wake_queue(struct xenvif_queue *queue)
-{
-	struct net_device *dev = queue->vif->dev;
-	unsigned int id = queue->id;
-	netif_tx_wake_queue(netdev_get_tx_queue(dev, id));
-}
-
 static u16 xenvif_select_queue(struct net_device *dev, struct sk_buff *skb,
 			       void *accel_priv,
 			       select_queue_fallback_t fallback)
@@ -263,14 +249,16 @@ xenvif_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	if (vif->hash.alg == XEN_NETIF_CTRL_HASH_ALGORITHM_NONE)
 		skb_clear_hash(skb);
 
-	xenvif_rx_queue_tail(queue, skb);
+	if (!xenvif_rx_queue_tail(queue, skb))
+		goto drop;
+
 	xenvif_kick_thread(queue);
 
 	return NETDEV_TX_OK;
 
  drop:
 	vif->dev->stats.tx_dropped++;
-	dev_kfree_skb(skb);
+	dev_kfree_skb_any(skb);
 	return NETDEV_TX_OK;
 }
 
diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index 3016869b4afd..f82120f81c79 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -105,6 +105,8 @@ static void make_tx_response(struct xenvif_queue *queue,
 			     s8       st);
 static void push_tx_responses(struct xenvif_queue *queue);
 
+static void xenvif_idx_unmap(struct xenvif_queue *queue, u16 pending_idx);
+
 static inline int tx_work_todo(struct xenvif_queue *queue);
 
 static inline unsigned long idx_to_pfn(struct xenvif_queue *queue,
@@ -323,10 +325,13 @@ static int xenvif_count_requests(struct xenvif_queue *queue,
 
 
 struct xenvif_tx_cb {
-	u16 pending_idx;
+	u16 copy_pending_idx[XEN_NETBK_LEGACY_SLOTS_MAX + 1];
+	u8 copy_count;
 };
 
 #define XENVIF_TX_CB(skb) ((struct xenvif_tx_cb *)(skb)->cb)
+#define copy_pending_idx(skb, i) (XENVIF_TX_CB(skb)->copy_pending_idx[i])
+#define copy_count(skb) (XENVIF_TX_CB(skb)->copy_count)
 
 static inline void xenvif_tx_create_map_op(struct xenvif_queue *queue,
 					   u16 pending_idx,
@@ -361,31 +366,93 @@ static inline struct sk_buff *xenvif_alloc_skb(unsigned int size)
 	return skb;
 }
 
-static struct gnttab_map_grant_ref *xenvif_get_requests(struct xenvif_queue *queue,
-							struct sk_buff *skb,
-							struct xen_netif_tx_request *txp,
-							struct gnttab_map_grant_ref *gop,
-							unsigned int frag_overflow,
-							struct sk_buff *nskb)
+static void xenvif_get_requests(struct xenvif_queue *queue,
+				struct sk_buff *skb,
+				struct xen_netif_tx_request *first,
+				struct xen_netif_tx_request *txfrags,
+			        unsigned *copy_ops,
+			        unsigned *map_ops,
+				unsigned int frag_overflow,
+				struct sk_buff *nskb,
+				unsigned int extra_count,
+				unsigned int data_len)
 {
 	struct skb_shared_info *shinfo = skb_shinfo(skb);
 	skb_frag_t *frags = shinfo->frags;
-	u16 pending_idx = XENVIF_TX_CB(skb)->pending_idx;
-	int start;
+	u16 pending_idx;
 	pending_ring_idx_t index;
 	unsigned int nr_slots;
+	struct gnttab_copy *cop = queue->tx_copy_ops + *copy_ops;
+	struct gnttab_map_grant_ref *gop = queue->tx_map_ops + *map_ops;
+	struct xen_netif_tx_request *txp = first;
+
+	nr_slots = shinfo->nr_frags + 1;
+
+	copy_count(skb) = 0;
 
-	nr_slots = shinfo->nr_frags;
+	/* Create copy ops for exactly data_len bytes into the skb head. */
+	__skb_put(skb, data_len);
+	while (data_len > 0) {
+		int amount = data_len > txp->size ? txp->size : data_len;
 
-	/* Skip first skb fragment if it is on same page as header fragment. */
-	start = (frag_get_pending_idx(&shinfo->frags[0]) == pending_idx);
+		cop->source.u.ref = txp->gref;
+		cop->source.domid = queue->vif->domid;
+		cop->source.offset = txp->offset;
 
-	for (shinfo->nr_frags = start; shinfo->nr_frags < nr_slots;
-	     shinfo->nr_frags++, txp++, gop++) {
+		cop->dest.domid = DOMID_SELF;
+		cop->dest.offset = (offset_in_page(skb->data +
+						   skb_headlen(skb) -
+						   data_len)) & ~XEN_PAGE_MASK;
+		cop->dest.u.gmfn = virt_to_gfn(skb->data + skb_headlen(skb)
+				               - data_len);
+
+		cop->len = amount;
+		cop->flags = GNTCOPY_source_gref;
+
+		index = pending_index(queue->pending_cons);
+		pending_idx = queue->pending_ring[index];
+		callback_param(queue, pending_idx).ctx = NULL;
+		copy_pending_idx(skb, copy_count(skb)) = pending_idx;
+		copy_count(skb)++;
+
+		cop++;
+		data_len -= amount;
+
+		if (amount == txp->size) {
+			/* The copy op covered the full tx_request */
+
+			memcpy(&queue->pending_tx_info[pending_idx].req,
+			       txp, sizeof(*txp));
+			queue->pending_tx_info[pending_idx].extra_count =
+				(txp == first) ? extra_count : 0;
+
+			if (txp == first)
+				txp = txfrags;
+			else
+				txp++;
+			queue->pending_cons++;
+			nr_slots--;
+		} else {
+			/* The copy op partially covered the tx_request.
+			 * The remainder will be mapped.
+			 */
+			txp->offset += amount;
+			txp->size -= amount;
+		}
+	}
+
+	for (shinfo->nr_frags = 0; shinfo->nr_frags < nr_slots;
+	     shinfo->nr_frags++, gop++) {
 		index = pending_index(queue->pending_cons++);
 		pending_idx = queue->pending_ring[index];
-		xenvif_tx_create_map_op(queue, pending_idx, txp, 0, gop);
+		xenvif_tx_create_map_op(queue, pending_idx, txp,
+				        txp == first ? extra_count : 0, gop);
 		frag_set_pending_idx(&frags[shinfo->nr_frags], pending_idx);
+
+		if (txp == first)
+			txp = txfrags;
+		else
+			txp++;
 	}
 
 	if (frag_overflow) {
@@ -406,7 +473,8 @@ static struct gnttab_map_grant_ref *xenvif_get_requests(struct xenvif_queue *que
 		skb_shinfo(skb)->frag_list = nskb;
 	}
 
-	return gop;
+	(*copy_ops) = cop - queue->tx_copy_ops;
+	(*map_ops) = gop - queue->tx_map_ops;
 }
 
 static inline void xenvif_grant_handle_set(struct xenvif_queue *queue,
@@ -442,7 +510,7 @@ static int xenvif_tx_check_gop(struct xenvif_queue *queue,
 			       struct gnttab_copy **gopp_copy)
 {
 	struct gnttab_map_grant_ref *gop_map = *gopp_map;
-	u16 pending_idx = XENVIF_TX_CB(skb)->pending_idx;
+	u16 pending_idx;
 	/* This always points to the shinfo of the skb being checked, which
 	 * could be either the first or the one on the frag_list
 	 */
@@ -453,24 +521,37 @@ static int xenvif_tx_check_gop(struct xenvif_queue *queue,
 	struct skb_shared_info *first_shinfo = NULL;
 	int nr_frags = shinfo->nr_frags;
 	const bool sharedslot = nr_frags &&
-				frag_get_pending_idx(&shinfo->frags[0]) == pending_idx;
-	int i, err;
+				frag_get_pending_idx(&shinfo->frags[0]) ==
+				    copy_pending_idx(skb, copy_count(skb) - 1);
+	int i, err = 0;
 
-	/* Check status of header. */
-	err = (*gopp_copy)->status;
-	if (unlikely(err)) {
-		if (net_ratelimit())
-			netdev_dbg(queue->vif->dev,
-				   "Grant copy of header failed! status: %d pending_idx: %u ref: %u\n",
-				   (*gopp_copy)->status,
-				   pending_idx,
-				   (*gopp_copy)->source.u.ref);
-		/* The first frag might still have this slot mapped */
-		if (!sharedslot)
-			xenvif_idx_release(queue, pending_idx,
-					   XEN_NETIF_RSP_ERROR);
+	for (i = 0; i < copy_count(skb); i++) {
+		int newerr;
+
+		/* Check status of header. */
+		pending_idx = copy_pending_idx(skb, i);
+
+		newerr = (*gopp_copy)->status;
+		if (likely(!newerr)) {
+			/* The first frag might still have this slot mapped */
+			if (i < copy_count(skb) - 1 || !sharedslot)
+				xenvif_idx_release(queue, pending_idx,
+						   XEN_NETIF_RSP_OKAY);
+		} else {
+			err = newerr;
+			if (net_ratelimit())
+				netdev_dbg(queue->vif->dev,
+					   "Grant copy of header failed! status: %d pending_idx: %u ref: %u\n",
+					   (*gopp_copy)->status,
+					   pending_idx,
+					   (*gopp_copy)->source.u.ref);
+			/* The first frag might still have this slot mapped */
+			if (i < copy_count(skb) - 1 || !sharedslot)
+				xenvif_idx_release(queue, pending_idx,
+						   XEN_NETIF_RSP_ERROR);
+		}
+		(*gopp_copy)++;
 	}
-	(*gopp_copy)++;
 
 check_frags:
 	for (i = 0; i < nr_frags; i++, gop_map++) {
@@ -517,14 +598,6 @@ static int xenvif_tx_check_gop(struct xenvif_queue *queue,
 		if (err)
 			continue;
 
-		/* First error: if the header haven't shared a slot with the
-		 * first frag, release it as well.
-		 */
-		if (!sharedslot)
-			xenvif_idx_release(queue,
-					   XENVIF_TX_CB(skb)->pending_idx,
-					   XEN_NETIF_RSP_OKAY);
-
 		/* Invalidate preceding fragments of this skb. */
 		for (j = 0; j < i; j++) {
 			pending_idx = frag_get_pending_idx(&shinfo->frags[j]);
@@ -796,7 +869,6 @@ static void xenvif_tx_build_gops(struct xenvif_queue *queue,
 				     unsigned *copy_ops,
 				     unsigned *map_ops)
 {
-	struct gnttab_map_grant_ref *gop = queue->tx_map_ops;
 	struct sk_buff *skb, *nskb;
 	int ret;
 	unsigned int frag_overflow;
@@ -878,8 +950,12 @@ static void xenvif_tx_build_gops(struct xenvif_queue *queue,
 			continue;
 		}
 
+		data_len = (txreq.size > XEN_NETBACK_TX_COPY_LEN) ?
+			XEN_NETBACK_TX_COPY_LEN : txreq.size;
+
 		ret = xenvif_count_requests(queue, &txreq, extra_count,
 					    txfrags, work_to_do);
+
 		if (unlikely(ret < 0))
 			break;
 
@@ -905,9 +981,8 @@ static void xenvif_tx_build_gops(struct xenvif_queue *queue,
 		index = pending_index(queue->pending_cons);
 		pending_idx = queue->pending_ring[index];
 
-		data_len = (txreq.size > XEN_NETBACK_TX_COPY_LEN &&
-			    ret < XEN_NETBK_LEGACY_SLOTS_MAX) ?
-			XEN_NETBACK_TX_COPY_LEN : txreq.size;
+		if (ret >= XEN_NETBK_LEGACY_SLOTS_MAX - 1 && data_len < txreq.size)
+			data_len = txreq.size;
 
 		skb = xenvif_alloc_skb(data_len);
 		if (unlikely(skb == NULL)) {
@@ -918,8 +993,6 @@ static void xenvif_tx_build_gops(struct xenvif_queue *queue,
 		}
 
 		skb_shinfo(skb)->nr_frags = ret;
-		if (data_len < txreq.size)
-			skb_shinfo(skb)->nr_frags++;
 		/* At this point shinfo->nr_frags is in fact the number of
 		 * slots, which can be as large as XEN_NETBK_LEGACY_SLOTS_MAX.
 		 */
@@ -981,54 +1054,19 @@ static void xenvif_tx_build_gops(struct xenvif_queue *queue,
 					     type);
 		}
 
-		XENVIF_TX_CB(skb)->pending_idx = pending_idx;
-
-		__skb_put(skb, data_len);
-		queue->tx_copy_ops[*copy_ops].source.u.ref = txreq.gref;
-		queue->tx_copy_ops[*copy_ops].source.domid = queue->vif->domid;
-		queue->tx_copy_ops[*copy_ops].source.offset = txreq.offset;
-
-		queue->tx_copy_ops[*copy_ops].dest.u.gmfn =
-			virt_to_gfn(skb->data);
-		queue->tx_copy_ops[*copy_ops].dest.domid = DOMID_SELF;
-		queue->tx_copy_ops[*copy_ops].dest.offset =
-			offset_in_page(skb->data) & ~XEN_PAGE_MASK;
-
-		queue->tx_copy_ops[*copy_ops].len = data_len;
-		queue->tx_copy_ops[*copy_ops].flags = GNTCOPY_source_gref;
-
-		(*copy_ops)++;
-
-		if (data_len < txreq.size) {
-			frag_set_pending_idx(&skb_shinfo(skb)->frags[0],
-					     pending_idx);
-			xenvif_tx_create_map_op(queue, pending_idx, &txreq,
-						extra_count, gop);
-			gop++;
-		} else {
-			frag_set_pending_idx(&skb_shinfo(skb)->frags[0],
-					     INVALID_PENDING_IDX);
-			memcpy(&queue->pending_tx_info[pending_idx].req,
-			       &txreq, sizeof(txreq));
-			queue->pending_tx_info[pending_idx].extra_count =
-				extra_count;
-		}
-
-		queue->pending_cons++;
-
-		gop = xenvif_get_requests(queue, skb, txfrags, gop,
-				          frag_overflow, nskb);
+		xenvif_get_requests(queue, skb, &txreq, txfrags, copy_ops,
+				    map_ops, frag_overflow, nskb, extra_count,
+				    data_len);
 
 		__skb_queue_tail(&queue->tx_queue, skb);
 
 		queue->tx.req_cons = idx;
 
-		if (((gop-queue->tx_map_ops) >= ARRAY_SIZE(queue->tx_map_ops)) ||
+		if ((*map_ops >= ARRAY_SIZE(queue->tx_map_ops)) ||
 		    (*copy_ops >= ARRAY_SIZE(queue->tx_copy_ops)))
 			break;
 	}
 
-	(*map_ops) = gop - queue->tx_map_ops;
 	return;
 }
 
@@ -1107,9 +1145,8 @@ static int xenvif_tx_submit(struct xenvif_queue *queue)
 	while ((skb = __skb_dequeue(&queue->tx_queue)) != NULL) {
 		struct xen_netif_tx_request *txp;
 		u16 pending_idx;
-		unsigned data_len;
 
-		pending_idx = XENVIF_TX_CB(skb)->pending_idx;
+		pending_idx = copy_pending_idx(skb, 0);
 		txp = &queue->pending_tx_info[pending_idx].req;
 
 		/* Check the remap error code. */
@@ -1128,18 +1165,6 @@ static int xenvif_tx_submit(struct xenvif_queue *queue)
 			continue;
 		}
 
-		data_len = skb->len;
-		callback_param(queue, pending_idx).ctx = NULL;
-		if (data_len < txp->size) {
-			/* Append the packet payload as a fragment. */
-			txp->offset += data_len;
-			txp->size -= data_len;
-		} else {
-			/* Schedule a response immediately. */
-			xenvif_idx_release(queue, pending_idx,
-					   XEN_NETIF_RSP_OKAY);
-		}
-
 		if (txp->flags & XEN_NETTXF_csum_blank)
 			skb->ip_summed = CHECKSUM_PARTIAL;
 		else if (txp->flags & XEN_NETTXF_data_validated)
@@ -1316,7 +1341,7 @@ static inline void xenvif_tx_dealloc_action(struct xenvif_queue *queue)
 /* Called after netfront has transmitted */
 int xenvif_tx_action(struct xenvif_queue *queue, int budget)
 {
-	unsigned nr_mops, nr_cops = 0;
+	unsigned nr_mops = 0, nr_cops = 0;
 	int work_done, ret;
 
 	if (unlikely(!tx_work_todo(queue)))
@@ -1403,7 +1428,7 @@ static void push_tx_responses(struct xenvif_queue *queue)
 		notify_remote_via_irq(queue->tx_irq);
 }
 
-void xenvif_idx_unmap(struct xenvif_queue *queue, u16 pending_idx)
+static void xenvif_idx_unmap(struct xenvif_queue *queue, u16 pending_idx)
 {
 	int ret;
 	struct gnttab_unmap_grant_ref tx_unmap_op;
diff --git a/drivers/net/xen-netback/rx.c b/drivers/net/xen-netback/rx.c
index 2612810eadaf..5067fa0c751f 100644
--- a/drivers/net/xen-netback/rx.c
+++ b/drivers/net/xen-netback/rx.c
@@ -82,9 +82,10 @@ static bool xenvif_rx_ring_slots_available(struct xenvif_queue *queue)
 	return false;
 }
 
-void xenvif_rx_queue_tail(struct xenvif_queue *queue, struct sk_buff *skb)
+bool xenvif_rx_queue_tail(struct xenvif_queue *queue, struct sk_buff *skb)
 {
 	unsigned long flags;
+	bool ret = true;
 
 	spin_lock_irqsave(&queue->rx_queue.lock, flags);
 
@@ -92,8 +93,7 @@ void xenvif_rx_queue_tail(struct xenvif_queue *queue, struct sk_buff *skb)
 		struct net_device *dev = queue->vif->dev;
 
 		netif_tx_stop_queue(netdev_get_tx_queue(dev, queue->id));
-		kfree_skb(skb);
-		queue->vif->dev->stats.rx_dropped++;
+		ret = false;
 	} else {
 		if (skb_queue_empty(&queue->rx_queue))
 			xenvif_update_needed_slots(queue, skb);
@@ -104,6 +104,8 @@ void xenvif_rx_queue_tail(struct xenvif_queue *queue, struct sk_buff *skb)
 	}
 
 	spin_unlock_irqrestore(&queue->rx_queue.lock, flags);
+
+	return ret;
 }
 
 static struct sk_buff *xenvif_rx_dequeue(struct xenvif_queue *queue)
@@ -473,7 +475,7 @@ void xenvif_rx_skb(struct xenvif_queue *queue)
 
 #define RX_BATCH_SIZE 64
 
-void xenvif_rx_action(struct xenvif_queue *queue)
+static void xenvif_rx_action(struct xenvif_queue *queue)
 {
 	struct sk_buff_head completed_skbs;
 	unsigned int work_done = 0;
diff --git a/net/bluetooth/6lowpan.c b/net/bluetooth/6lowpan.c
index 3bfd747aa515..4a29410f5abc 100644
--- a/net/bluetooth/6lowpan.c
+++ b/net/bluetooth/6lowpan.c
@@ -1119,6 +1119,7 @@ static int get_l2cap_conn(char *buf, bdaddr_t *addr, u8 *addr_type,
 	hci_dev_lock(hdev);
 	hcon = hci_conn_hash_lookup_le(hdev, addr, *addr_type);
 	hci_dev_unlock(hdev);
+	hci_dev_put(hdev);
 
 	if (!hcon)
 		return -ENOENT;
diff --git a/net/mac802154/iface.c b/net/mac802154/iface.c
index 06019dba4b10..9f2355cb6701 100644
--- a/net/mac802154/iface.c
+++ b/net/mac802154/iface.c
@@ -670,6 +670,7 @@ ieee802154_if_add(struct ieee802154_local *local, const char *name,
 	sdata->dev = ndev;
 	sdata->wpan_dev.wpan_phy = local->hw.phy;
 	sdata->local = local;
+	INIT_LIST_HEAD(&sdata->wpan_dev.list);
 
 	/* setup type-dependent data */
 	ret = ieee802154_setup_sdata(sdata, type);
diff --git a/net/nfc/nci/ntf.c b/net/nfc/nci/ntf.c
index 1e8c1a12aaec..4f75453c07aa 100644
--- a/net/nfc/nci/ntf.c
+++ b/net/nfc/nci/ntf.c
@@ -230,6 +230,8 @@ static int nci_add_new_protocol(struct nci_dev *ndev,
 		target->sens_res = nfca_poll->sens_res;
 		target->sel_res = nfca_poll->sel_res;
 		target->nfcid1_len = nfca_poll->nfcid1_len;
+		if (target->nfcid1_len > ARRAY_SIZE(target->nfcid1))
+			return -EPROTO;
 		if (target->nfcid1_len > 0) {
 			memcpy(target->nfcid1, nfca_poll->nfcid1,
 			       target->nfcid1_len);
@@ -238,6 +240,8 @@ static int nci_add_new_protocol(struct nci_dev *ndev,
 		nfcb_poll = (struct rf_tech_specific_params_nfcb_poll *)params;
 
 		target->sensb_res_len = nfcb_poll->sensb_res_len;
+		if (target->sensb_res_len > ARRAY_SIZE(target->sensb_res))
+			return -EPROTO;
 		if (target->sensb_res_len > 0) {
 			memcpy(target->sensb_res, nfcb_poll->sensb_res,
 			       target->sensb_res_len);
@@ -246,6 +250,8 @@ static int nci_add_new_protocol(struct nci_dev *ndev,
 		nfcf_poll = (struct rf_tech_specific_params_nfcf_poll *)params;
 
 		target->sensf_res_len = nfcf_poll->sensf_res_len;
+		if (target->sensf_res_len > ARRAY_SIZE(target->sensf_res))
+			return -EPROTO;
 		if (target->sensf_res_len > 0) {
 			memcpy(target->sensf_res, nfcf_poll->sensf_res,
 			       target->sensf_res_len);
diff --git a/net/tipc/link.c b/net/tipc/link.c
index 2c1350e811e2..5c063a548093 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -1456,7 +1456,9 @@ static int tipc_link_proto_rcv(struct tipc_link *l, struct sk_buff *skb,
 	if (tipc_own_addr(l->net) > msg_prevnode(hdr))
 		l->net_plane = msg_net_plane(hdr);
 
-	skb_linearize(skb);
+	if (skb_linearize(skb))
+		goto exit;
+
 	hdr = buf_msg(skb);
 	data = msg_data(hdr);
 
diff --git a/sound/core/seq/seq_memory.c b/sound/core/seq/seq_memory.c
index 4c8cbcd89887..42f4aa841051 100644
--- a/sound/core/seq/seq_memory.c
+++ b/sound/core/seq/seq_memory.c
@@ -126,15 +126,19 @@ EXPORT_SYMBOL(snd_seq_dump_var_event);
  * expand the variable length event to linear buffer space.
  */
 
-static int seq_copy_in_kernel(char **bufptr, const void *src, int size)
+static int seq_copy_in_kernel(void *ptr, void *src, int size)
 {
+	char **bufptr = ptr;
+
 	memcpy(*bufptr, src, size);
 	*bufptr += size;
 	return 0;
 }
 
-static int seq_copy_in_user(char __user **bufptr, const void *src, int size)
+static int seq_copy_in_user(void *ptr, void *src, int size)
 {
+	char __user **bufptr = ptr;
+
 	if (copy_to_user(*bufptr, src, size))
 		return -EFAULT;
 	*bufptr += size;
@@ -163,8 +167,7 @@ int snd_seq_expand_var_event(const struct snd_seq_event *event, int count, char
 		return newlen;
 	}
 	err = snd_seq_dump_var_event(event,
-				     in_kernel ? (snd_seq_dump_func_t)seq_copy_in_kernel :
-				     (snd_seq_dump_func_t)seq_copy_in_user,
+				     in_kernel ? seq_copy_in_kernel : seq_copy_in_user,
 				     &buf);
 	return err < 0 ? err : newlen;
 }
diff --git a/sound/soc/soc-pcm.c b/sound/soc/soc-pcm.c
index 6c31a909845c..f6cebe2b3cbb 100644
--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -1182,6 +1182,8 @@ static void dpcm_be_reparent(struct snd_soc_pcm_runtime *fe,
 		return;
 
 	be_substream = snd_soc_dpcm_get_substream(be, stream);
+	if (!be_substream)
+		return;
 
 	list_for_each_entry(dpcm, &be->dpcm[stream].fe_clients, list_fe) {
 		if (dpcm->fe == fe)
diff --git a/tools/testing/selftests/rcutorture/bin/kvm.sh b/tools/testing/selftests/rcutorture/bin/kvm.sh
index 0aed965f0062..5e65071bc325 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm.sh
@@ -175,6 +175,14 @@ do
 	shift
 done
 
+if test -z "$TORTURE_INITRD" || tools/testing/selftests/rcutorture/bin/mkinitrd.sh
+then
+	:
+else
+	echo No initrd and unable to create one, aborting test >&2
+	exit 1
+fi
+
 CONFIGFRAG=${KVM}/configs/${TORTURE_SUITE}; export CONFIGFRAG
 
 if test -z "$configs"
diff --git a/tools/testing/selftests/rcutorture/bin/mkinitrd.sh b/tools/testing/selftests/rcutorture/bin/mkinitrd.sh
new file mode 100644
index 000000000000..ae773760f396
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/bin/mkinitrd.sh
@@ -0,0 +1,60 @@
+#!/bin/bash
+#
+# Create an initrd directory if one does not already exist.
+#
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License as published by
+# the Free Software Foundation; either version 2 of the License, or
+# (at your option) any later version.
+#
+# This program is distributed in the hope that it will be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, you can access it online at
+# http://www.gnu.org/licenses/gpl-2.0.html.
+#
+# Copyright (C) IBM Corporation, 2013
+#
+# Author: Connor Shu <Connor.Shu@ibm.com>
+
+D=tools/testing/selftests/rcutorture
+
+# Prerequisite checks
+[ -z "$D" ] && echo >&2 "No argument supplied" && exit 1
+if [ ! -d "$D" ]; then
+    echo >&2 "$D does not exist: Malformed kernel source tree?"
+    exit 1
+fi
+if [ -d "$D/initrd" ]; then
+    echo "$D/initrd already exists, no need to create it"
+    exit 0
+fi
+
+T=${TMPDIR-/tmp}/mkinitrd.sh.$$
+trap 'rm -rf $T' 0 2
+mkdir $T
+
+cat > $T/init << '__EOF___'
+#!/bin/sh
+while :
+do
+	sleep 1000000
+done
+__EOF___
+
+# Try using dracut to create initrd
+command -v dracut >/dev/null 2>&1 || { echo >&2 "Dracut not installed"; exit 1; }
+echo Creating $D/initrd using dracut.
+
+# Filesystem creation
+dracut --force --no-hostonly --no-hostonly-cmdline --module "base" $T/initramfs.img
+cd $D
+mkdir initrd
+cd initrd
+zcat $T/initramfs.img | cpio -id
+cp $T/init init
+echo Done creating $D/initrd using dracut
+exit 0
