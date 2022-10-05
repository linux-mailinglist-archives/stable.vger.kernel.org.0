Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 376865F517F
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 11:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbiJEJIy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 05:08:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230223AbiJEJIk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 05:08:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17CE777545;
        Wed,  5 Oct 2022 02:08:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ABB9DB81D4A;
        Wed,  5 Oct 2022 09:08:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 110FBC433D7;
        Wed,  5 Oct 2022 09:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664960891;
        bh=KbODNnKMw9A7Fnng7nyBvLUN/XJWH46TWLog22NRc/Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X+ua9iXLPfAXy/mhem/BPPyAPMBYcRVa2AagJ1u8DiX8LZSZfF8NCrOfnZqPmwzTQ
         9TS9lsGU0gxnDSM+5ZInzbL34DtGKCf/J5VbFRXfnFiXyFmoBzJcGAuFTF1aKyBkLy
         HSsqCiNfdDJiMThAFLqxeqxltU6htDMIuB6eaddU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.19.261
Date:   Wed,  5 Oct 2022 11:08:02 +0200
Message-Id: <166496088245117@kroah.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <1664960882137215@kroah.com>
References: <1664960882137215@kroah.com>
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
index 61971754a74e..165812d2f786 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 19
-SUBLEVEL = 260
+SUBLEVEL = 261
 EXTRAVERSION =
 NAME = "People's Front"
 
diff --git a/arch/arm/boot/dts/integratorap.dts b/arch/arm/boot/dts/integratorap.dts
index 94d2ff9836d0..e6c5a99e0741 100644
--- a/arch/arm/boot/dts/integratorap.dts
+++ b/arch/arm/boot/dts/integratorap.dts
@@ -155,6 +155,7 @@
 
 	pci: pciv3@62000000 {
 		compatible = "arm,integrator-ap-pci", "v3,v360epc-pci";
+		device_type = "pci";
 		#interrupt-cells = <1>;
 		#size-cells = <2>;
 		#address-cells = <3>;
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index b0dea0702c74..6d110a1c090d 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4560,6 +4560,10 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	{ "PIONEER DVD-RW  DVR-212D",	NULL,	ATA_HORKAGE_NOSETXFER },
 	{ "PIONEER DVD-RW  DVR-216D",	NULL,	ATA_HORKAGE_NOSETXFER },
 
+	/* These specific Pioneer models have LPM issues */
+	{ "PIONEER BD-RW   BDR-207M",	NULL,	ATA_HORKAGE_NOLPM },
+	{ "PIONEER BD-RW   BDR-205",	NULL,	ATA_HORKAGE_NOLPM },
+
 	/* Crucial BX100 SSD 500GB has broken LPM support */
 	{ "CT500BX100SSD1",		NULL,	ATA_HORKAGE_NOLPM },
 
diff --git a/drivers/clk/bcm/clk-iproc-pll.c b/drivers/clk/bcm/clk-iproc-pll.c
index 274441e2ddb2..8f0619f362e3 100644
--- a/drivers/clk/bcm/clk-iproc-pll.c
+++ b/drivers/clk/bcm/clk-iproc-pll.c
@@ -736,6 +736,7 @@ void iproc_pll_clk_setup(struct device_node *node,
 	const char *parent_name;
 	struct iproc_clk *iclk_array;
 	struct clk_hw_onecell_data *clk_data;
+	const char *clk_name;
 
 	if (WARN_ON(!pll_ctrl) || WARN_ON(!clk_ctrl))
 		return;
@@ -783,7 +784,12 @@ void iproc_pll_clk_setup(struct device_node *node,
 	iclk = &iclk_array[0];
 	iclk->pll = pll;
 
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
@@ -803,13 +809,11 @@ void iproc_pll_clk_setup(struct device_node *node,
 		goto err_pll_register;
 
 	clk_data->hws[0] = &iclk->hw;
+	parent_name = clk_name;
 
 	/* now initialize and register all leaf clocks */
 	for (i = 1; i < num_clks; i++) {
-		const char *clk_name;
-
 		memset(&init, 0, sizeof(init));
-		parent_name = node->name;
 
 		ret = of_property_read_string_index(node, "clock-output-names",
 						    i, &clk_name);
diff --git a/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c b/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
index e21c7673cd5b..57781833cae1 100644
--- a/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
+++ b/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
@@ -1690,12 +1690,6 @@ EXPORT_SYMBOL_GPL(analogix_dp_unbind);
 int analogix_dp_suspend(struct analogix_dp_device *dp)
 {
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
@@ -1710,13 +1704,6 @@ int analogix_dp_resume(struct analogix_dp_device *dp)
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
diff --git a/drivers/input/touchscreen/melfas_mip4.c b/drivers/input/touchscreen/melfas_mip4.c
index 430a2bc5f7ca..5d947e721fa5 100644
--- a/drivers/input/touchscreen/melfas_mip4.c
+++ b/drivers/input/touchscreen/melfas_mip4.c
@@ -1462,7 +1462,7 @@ static int mip4_probe(struct i2c_client *client, const struct i2c_device_id *id)
 					      "ce", GPIOD_OUT_LOW);
 	if (IS_ERR(ts->gpio_ce)) {
 		error = PTR_ERR(ts->gpio_ce);
-		if (error != EPROBE_DEFER)
+		if (error != -EPROBE_DEFER)
 			dev_err(&client->dev,
 				"Failed to get gpio: %d\n", error);
 		return error;
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
 
diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 8d10c29ba176..56115792bea1 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1357,6 +1357,7 @@ static const struct usb_device_id products[] = {
 	{QMI_FIXED_INTF(0x413c, 0x81b3, 8)},	/* Dell Wireless 5809e Gobi(TM) 4G LTE Mobile Broadband Card (rev3) */
 	{QMI_FIXED_INTF(0x413c, 0x81b6, 8)},	/* Dell Wireless 5811e */
 	{QMI_FIXED_INTF(0x413c, 0x81b6, 10)},	/* Dell Wireless 5811e */
+	{QMI_FIXED_INTF(0x413c, 0x81c2, 8)},	/* Dell Wireless 5811e */
 	{QMI_FIXED_INTF(0x413c, 0x81cc, 8)},	/* Dell Wireless 5816e */
 	{QMI_FIXED_INTF(0x413c, 0x81d7, 0)},	/* Dell Wireless 5821e */
 	{QMI_FIXED_INTF(0x413c, 0x81d7, 1)},	/* Dell Wireless 5821e preproduction config */
diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 1316f5b0c0d7..2263a66f6314 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1596,6 +1596,7 @@ void usbnet_disconnect (struct usb_interface *intf)
 	struct usbnet		*dev;
 	struct usb_device	*xdev;
 	struct net_device	*net;
+	struct urb		*urb;
 
 	dev = usb_get_intfdata(intf);
 	usb_set_intfdata(intf, NULL);
@@ -1612,7 +1613,11 @@ void usbnet_disconnect (struct usb_interface *intf)
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
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index a0a805a5ab6b..582c3b190418 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1716,18 +1716,21 @@ static int nvme_pr_preempt(struct block_device *bdev, u64 old, u64 new,
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
 
diff --git a/drivers/soc/sunxi/sunxi_sram.c b/drivers/soc/sunxi/sunxi_sram.c
index b4b0f3480bd3..2c1672f9aac9 100644
--- a/drivers/soc/sunxi/sunxi_sram.c
+++ b/drivers/soc/sunxi/sunxi_sram.c
@@ -78,8 +78,8 @@ static struct sunxi_sram_desc sun4i_a10_sram_d = {
 
 static struct sunxi_sram_desc sun50i_a64_sram_c = {
 	.data	= SUNXI_SRAM_DATA("C", 0x4, 24, 1,
-				  SUNXI_SRAM_MAP(0, 1, "cpu"),
-				  SUNXI_SRAM_MAP(1, 0, "de2")),
+				  SUNXI_SRAM_MAP(1, 0, "cpu"),
+				  SUNXI_SRAM_MAP(0, 1, "de2")),
 };
 
 static const struct of_device_id sunxi_sram_dt_ids[] = {
@@ -264,6 +264,7 @@ int sunxi_sram_claim(struct device *dev)
 	writel(val | ((device << sram_data->offset) & mask),
 	       base + sram_data->reg);
 
+	sram_desc->claimed = true;
 	spin_unlock(&sram_lock);
 
 	return 0;
@@ -324,12 +325,12 @@ static struct regmap_config sunxi_sram_emac_clock_regmap = {
 	.writeable_reg	= sunxi_sram_regmap_accessible_reg,
 };
 
-static int sunxi_sram_probe(struct platform_device *pdev)
+static int __init sunxi_sram_probe(struct platform_device *pdev)
 {
 	struct resource *res;
-	struct dentry *d;
 	struct regmap *emac_clock;
 	const struct sunxi_sramc_variant *variant;
+	struct device *dev = &pdev->dev;
 
 	sram_dev = &pdev->dev;
 
@@ -342,13 +343,6 @@ static int sunxi_sram_probe(struct platform_device *pdev)
 	if (IS_ERR(base))
 		return PTR_ERR(base);
 
-	of_platform_populate(pdev->dev.of_node, NULL, NULL, &pdev->dev);
-
-	d = debugfs_create_file("sram", S_IRUGO, NULL, NULL,
-				&sunxi_sram_fops);
-	if (!d)
-		return -ENOMEM;
-
 	if (variant->has_emac_clock) {
 		emac_clock = devm_regmap_init_mmio(&pdev->dev, base,
 						   &sunxi_sram_emac_clock_regmap);
@@ -357,6 +351,10 @@ static int sunxi_sram_probe(struct platform_device *pdev)
 			return PTR_ERR(emac_clock);
 	}
 
+	of_platform_populate(dev->of_node, NULL, NULL, dev);
+
+	debugfs_create_file("sram", 0444, NULL, NULL, &sunxi_sram_fops);
+
 	return 0;
 }
 
@@ -398,9 +396,8 @@ static struct platform_driver sunxi_sram_driver = {
 		.name		= "sunxi-sram",
 		.of_match_table	= sunxi_sram_dt_match,
 	},
-	.probe	= sunxi_sram_probe,
 };
-module_platform_driver(sunxi_sram_driver);
+builtin_platform_driver_probe(sunxi_sram_driver, sunxi_sram_probe);
 
 MODULE_AUTHOR("Maxime Ripard <maxime.ripard@free-electrons.com>");
 MODULE_DESCRIPTION("Allwinner sunXi SRAM Controller Driver");
diff --git a/drivers/usb/storage/unusual_uas.h b/drivers/usb/storage/unusual_uas.h
index 0b37c8e550e7..92e9bd006622 100644
--- a/drivers/usb/storage/unusual_uas.h
+++ b/drivers/usb/storage/unusual_uas.h
@@ -52,6 +52,13 @@ UNUSUAL_DEV(0x059f, 0x1061, 0x0000, 0x9999,
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
@@ -76,6 +83,13 @@ UNUSUAL_DEV(0x0bc2, 0x331a, 0x0000, 0x9999,
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_NO_REPORT_LUNS),
 
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
@@ -118,6 +132,13 @@ UNUSUAL_DEV(0x154b, 0xf00d, 0x0000, 0x9999,
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
diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
index bb7159f697f2..f47a3390118f 100644
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
diff --git a/mm/migrate.c b/mm/migrate.c
index 76f8dedc0e02..171573613c39 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2359,13 +2359,14 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
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
index 9c35403d9646..1cffd4e1fd8f 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3779,6 +3779,30 @@ void fs_reclaim_release(gfp_t gfp_mask)
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
@@ -4084,6 +4108,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	int compaction_retries;
 	int no_progress_loops;
 	unsigned int cpuset_mems_cookie;
+	unsigned int zonelist_iter_cookie;
 	int reserve_flags;
 
 	/*
@@ -4094,11 +4119,12 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
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
@@ -4247,9 +4273,13 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
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
@@ -4269,9 +4299,13 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
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
@@ -4569,6 +4603,18 @@ void *page_frag_alloc(struct page_frag_cache *nc,
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
@@ -5379,9 +5425,8 @@ static void __build_all_zonelists(void *data)
 	int nid;
 	int __maybe_unused cpu;
 	pg_data_t *self = data;
-	static DEFINE_SPINLOCK(lock);
 
-	spin_lock(&lock);
+	write_seqlock(&zonelist_update_seq);
 
 #ifdef CONFIG_NUMA
 	memset(node_load, 0, sizeof(node_load));
@@ -5414,7 +5459,7 @@ static void __build_all_zonelists(void *data)
 #endif
 	}
 
-	spin_unlock(&lock);
+	write_sequnlock(&zonelist_update_seq);
 }
 
 static noinline void __init
diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index d12b07eb3a58..e2916b115b93 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -298,6 +298,7 @@ static inline int ima_read_xattr(struct dentry *dentry,
 #ifdef CONFIG_IMA_LSM_RULES
 
 #define security_filter_rule_init security_audit_rule_init
+#define security_filter_rule_free security_audit_rule_free
 #define security_filter_rule_match security_audit_rule_match
 
 #else
@@ -308,6 +309,10 @@ static inline int security_filter_rule_init(u32 field, u32 op, char *rulestr,
 	return -EINVAL;
 }
 
+static inline void security_filter_rule_free(void *lsmrule)
+{
+}
+
 static inline int security_filter_rule_match(u32 secid, u32 field, u32 op,
 					     void *lsmrule,
 					     struct audit_context *actx)
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index 2d5a3daa02f9..b2dadff3626b 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -241,6 +241,21 @@ static int __init default_appraise_policy_setup(char *str)
 }
 __setup("ima_appraise_tcb", default_appraise_policy_setup);
 
+static void ima_free_rule(struct ima_rule_entry *entry)
+{
+	int i;
+
+	if (!entry)
+		return;
+
+	kfree(entry->fsname);
+	for (i = 0; i < MAX_LSM_RULES; i++) {
+		security_filter_rule_free(entry->lsm[i].rule);
+		kfree(entry->lsm[i].args_p);
+	}
+	kfree(entry);
+}
+
 /*
  * The LSM policy can be reloaded, leaving the IMA LSM based rules referring
  * to the old, stale LSM policy.  Update the IMA LSM based rules to reflect
@@ -647,6 +662,7 @@ static int ima_lsm_rule_init(struct ima_rule_entry *entry,
 					   &entry->lsm[lsm_rule].rule);
 	if (!entry->lsm[lsm_rule].rule) {
 		kfree(entry->lsm[lsm_rule].args_p);
+		entry->lsm[lsm_rule].args_p = NULL;
 		return -EINVAL;
 	}
 
@@ -1019,7 +1035,7 @@ ssize_t ima_parse_add_rule(char *rule)
 
 	result = ima_parse_rule(p, entry);
 	if (result) {
-		kfree(entry);
+		ima_free_rule(entry);
 		integrity_audit_msg(AUDIT_INTEGRITY_STATUS, NULL,
 				    NULL, op, "invalid-policy", result,
 				    audit_info);
@@ -1040,15 +1056,11 @@ ssize_t ima_parse_add_rule(char *rule)
 void ima_delete_rules(void)
 {
 	struct ima_rule_entry *entry, *tmp;
-	int i;
 
 	temp_ima_appraise = 0;
 	list_for_each_entry_safe(entry, tmp, &ima_temp_rules, list) {
-		for (i = 0; i < MAX_LSM_RULES; i++)
-			kfree(entry->lsm[i].args_p);
-
 		list_del(&entry->list);
-		kfree(entry);
+		ima_free_rule(entry);
 	}
 }
 
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
