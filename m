Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1117571D81
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 16:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbiGLO7S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 10:59:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233574AbiGLO7G (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 10:59:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B37E15A22;
        Tue, 12 Jul 2022 07:59:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 898FA60C70;
        Tue, 12 Jul 2022 14:59:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E58AC385A5;
        Tue, 12 Jul 2022 14:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657637941;
        bh=39LC98Qm9jx2pQuqxNycIuDm6SHIEIFkm/V1uGnHjK8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G0y2Scc7NJWaTuQ6ca3KTC7HSbNZSsUr0b5duzhMFcEaGUqG1RXdvMKrfpVq74zHZ
         DRsFObmxoNOuHq/9hbxmowB5Gaf+PGkXpUmMSJ+3OAscCgumN75xNiJ6LUn6MZYarI
         atie1ZIu7AamakjXObOh3U5dVrXK0GjyJWL9f3go=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.19.252
Date:   Tue, 12 Jul 2022 16:58:51 +0200
Message-Id: <1657637931154252@kroah.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <16576379311388@kroah.com>
References: <16576379311388@kroah.com>
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

diff --git a/Makefile b/Makefile
index 35717e4c2b87..73a75363bba0 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 19
-SUBLEVEL = 251
+SUBLEVEL = 252
 EXTRAVERSION =
 NAME = "People's Front"
 
diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
index 21bfe9b6e16a..3ba0c6c560d8 100644
--- a/arch/arm/mach-at91/pm.c
+++ b/arch/arm/mach-at91/pm.c
@@ -95,7 +95,7 @@ static const struct wakeup_source_info ws_info[] = {
 
 static const struct of_device_id sama5d2_ws_ids[] = {
 	{ .compatible = "atmel,sama5d2-gem",		.data = &ws_info[0] },
-	{ .compatible = "atmel,at91rm9200-rtc",		.data = &ws_info[1] },
+	{ .compatible = "atmel,sama5d2-rtc",		.data = &ws_info[1] },
 	{ .compatible = "atmel,sama5d3-udc",		.data = &ws_info[2] },
 	{ .compatible = "atmel,at91rm9200-ohci",	.data = &ws_info[2] },
 	{ .compatible = "usb-ohci",			.data = &ws_info[2] },
diff --git a/arch/arm/mach-meson/platsmp.c b/arch/arm/mach-meson/platsmp.c
index cad7ee8f0d6b..75e16a2c3c81 100644
--- a/arch/arm/mach-meson/platsmp.c
+++ b/arch/arm/mach-meson/platsmp.c
@@ -81,6 +81,7 @@ static void __init meson_smp_prepare_cpus(const char *scu_compatible,
 	}
 
 	sram_base = of_iomap(node, 0);
+	of_node_put(node);
 	if (!sram_base) {
 		pr_err("Couldn't map SRAM registers\n");
 		return;
@@ -101,6 +102,7 @@ static void __init meson_smp_prepare_cpus(const char *scu_compatible,
 	}
 
 	scu_base = of_iomap(node, 0);
+	of_node_put(node);
 	if (!scu_base) {
 		pr_err("Couldn't map SCU registers\n");
 		return;
diff --git a/arch/powerpc/platforms/powernv/rng.c b/arch/powerpc/platforms/powernv/rng.c
index c5c1d5cd7b10..6fb1ceb5756d 100644
--- a/arch/powerpc/platforms/powernv/rng.c
+++ b/arch/powerpc/platforms/powernv/rng.c
@@ -180,12 +180,8 @@ static int __init pnv_get_random_long_early(unsigned long *v)
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
@@ -209,10 +205,18 @@ void __init pnv_rng_init(void)
 
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
diff --git a/drivers/dma/at_xdmac.c b/drivers/dma/at_xdmac.c
index d4ba0d9dd17c..a451ecae1669 100644
--- a/drivers/dma/at_xdmac.c
+++ b/drivers/dma/at_xdmac.c
@@ -1804,6 +1804,11 @@ static int at_xdmac_alloc_chan_resources(struct dma_chan *chan)
 	for (i = 0; i < init_nr_desc_per_channel; i++) {
 		desc = at_xdmac_alloc_desc(chan, GFP_ATOMIC);
 		if (!desc) {
+			if (i == 0) {
+				dev_warn(chan2dev(chan),
+					 "can't allocate any descriptors\n");
+				return -EIO;
+			}
 			dev_warn(chan2dev(chan),
 				"only %d descriptors have been allocated\n", i);
 			break;
diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index 816630505294..9cb1c4228205 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -2568,7 +2568,7 @@ static struct dma_pl330_desc *pl330_get_desc(struct dma_pl330_chan *pch)
 
 	/* If the DMAC pool is empty, alloc new */
 	if (!desc) {
-		DEFINE_SPINLOCK(lock);
+		static DEFINE_SPINLOCK(lock);
 		LIST_HEAD(pool);
 
 		if (!add_desc(&pool, &lock, GFP_ATOMIC, 1))
diff --git a/drivers/dma/ti/dma-crossbar.c b/drivers/dma/ti/dma-crossbar.c
index 6574cb5a12fe..932c638ef4a0 100644
--- a/drivers/dma/ti/dma-crossbar.c
+++ b/drivers/dma/ti/dma-crossbar.c
@@ -251,6 +251,7 @@ static void *ti_dra7_xbar_route_allocate(struct of_phandle_args *dma_spec,
 	if (dma_spec->args[0] >= xbar->xbar_requests) {
 		dev_err(&pdev->dev, "Invalid XBAR request number: %d\n",
 			dma_spec->args[0]);
+		put_device(&pdev->dev);
 		return ERR_PTR(-EINVAL);
 	}
 
@@ -258,12 +259,14 @@ static void *ti_dra7_xbar_route_allocate(struct of_phandle_args *dma_spec,
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
 
@@ -274,6 +277,8 @@ static void *ti_dra7_xbar_route_allocate(struct of_phandle_args *dma_spec,
 		mutex_unlock(&xbar->mutex);
 		dev_err(&pdev->dev, "Run out of free DMA requests\n");
 		kfree(map);
+		of_node_put(dma_spec->np);
+		put_device(&pdev->dev);
 		return ERR_PTR(-ENOMEM);
 	}
 	set_bit(map->xbar_out, xbar->dma_inuse);
diff --git a/drivers/i2c/busses/i2c-cadence.c b/drivers/i2c/busses/i2c-cadence.c
index 2150afdcc083..273f57e277b3 100644
--- a/drivers/i2c/busses/i2c-cadence.c
+++ b/drivers/i2c/busses/i2c-cadence.c
@@ -990,6 +990,7 @@ static int cdns_i2c_probe(struct platform_device *pdev)
 	return 0;
 
 err_clk_dis:
+	clk_notifier_unregister(id->clk, &id->clk_rate_change_nb);
 	clk_disable_unprepare(id->clk);
 	pm_runtime_set_suspended(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index bc565f8e8ac2..017786d62f47 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -374,7 +374,7 @@ static int dmar_pci_bus_notifier(struct notifier_block *nb,
 
 static struct notifier_block dmar_pci_bus_nb = {
 	.notifier_call = dmar_pci_bus_notifier,
-	.priority = INT_MIN,
+	.priority = 1,
 };
 
 static struct dmar_drhd_unit *
diff --git a/drivers/misc/cardreader/rtsx_usb.c b/drivers/misc/cardreader/rtsx_usb.c
index 869c176d48cc..578d39112229 100644
--- a/drivers/misc/cardreader/rtsx_usb.c
+++ b/drivers/misc/cardreader/rtsx_usb.c
@@ -642,16 +642,20 @@ static int rtsx_usb_probe(struct usb_interface *intf,
 
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
 
@@ -679,8 +683,11 @@ static int rtsx_usb_probe(struct usb_interface *intf,
 
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
 
@@ -693,8 +700,12 @@ static void rtsx_usb_disconnect(struct usb_interface *intf)
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
diff --git a/drivers/net/can/grcan.c b/drivers/net/can/grcan.c
index f07a6ff66d1c..5d1b7b9d316b 100644
--- a/drivers/net/can/grcan.c
+++ b/drivers/net/can/grcan.c
@@ -1664,7 +1664,6 @@ static int grcan_probe(struct platform_device *ofdev)
 	 */
 	sysid_parent = of_find_node_by_path("/ambapp0");
 	if (sysid_parent) {
-		of_node_get(sysid_parent);
 		err = of_property_read_u32(sysid_parent, "systemid", &sysid);
 		if (!err && ((sysid & GRLIB_VERSION_MASK) >=
 			     GRCAN_TXBUG_SAFE_GRLIB_VERSION))
diff --git a/drivers/net/can/usb/gs_usb.c b/drivers/net/can/usb/gs_usb.c
index b2a187bf6c5e..2101b2fab7df 100644
--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -192,6 +192,8 @@ struct gs_can {
 
 	struct usb_anchor tx_submitted;
 	atomic_t active_tx_urbs;
+	void *rxbuf[GS_MAX_RX_URBS];
+	dma_addr_t rxbuf_dma[GS_MAX_RX_URBS];
 };
 
 /* usb interface struct */
@@ -600,6 +602,7 @@ static int gs_can_open(struct net_device *netdev)
 		for (i = 0; i < GS_MAX_RX_URBS; i++) {
 			struct urb *urb;
 			u8 *buf;
+			dma_addr_t buf_dma;
 
 			/* alloc rx urb */
 			urb = usb_alloc_urb(0, GFP_KERNEL);
@@ -610,7 +613,7 @@ static int gs_can_open(struct net_device *netdev)
 			buf = usb_alloc_coherent(dev->udev,
 						 sizeof(struct gs_host_frame),
 						 GFP_KERNEL,
-						 &urb->transfer_dma);
+						 &buf_dma);
 			if (!buf) {
 				netdev_err(netdev,
 					   "No memory left for USB buffer\n");
@@ -618,6 +621,8 @@ static int gs_can_open(struct net_device *netdev)
 				return -ENOMEM;
 			}
 
+			urb->transfer_dma = buf_dma;
+
 			/* fill, anchor, and submit rx urb */
 			usb_fill_bulk_urb(urb,
 					  dev->udev,
@@ -641,10 +646,17 @@ static int gs_can_open(struct net_device *netdev)
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
@@ -709,13 +721,20 @@ static int gs_can_close(struct net_device *netdev)
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
index c89c7d4900d7..6e2c15626624 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
@@ -79,104 +79,134 @@
 #define USB_ATI_MEMO_PRO_2HS_V2_PRODUCT_ID	269
 #define USB_HYBRID_PRO_CANLIN_PRODUCT_ID	270
 
-static inline bool kvaser_is_leaf(const struct usb_device_id *id)
-{
-	return (id->idProduct >= USB_LEAF_DEVEL_PRODUCT_ID &&
-		id->idProduct <= USB_CAN_R_PRODUCT_ID) ||
-		(id->idProduct >= USB_LEAF_LITE_V2_PRODUCT_ID &&
-		 id->idProduct <= USB_MINI_PCIE_2HS_PRODUCT_ID);
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
-	       id->idProduct <= USB_HYBRID_PRO_CANLIN_PRODUCT_ID;
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
-	{ USB_DEVICE(KVASER_VENDOR_ID, USB_HYBRID_CANLIN_PRODUCT_ID) },
-	{ USB_DEVICE(KVASER_VENDOR_ID, USB_ATI_USBCAN_PRO_2HS_V2_PRODUCT_ID) },
-	{ USB_DEVICE(KVASER_VENDOR_ID, USB_ATI_MEMO_PRO_2HS_V2_PRODUCT_ID) },
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
+	{ USB_DEVICE(KVASER_VENDOR_ID, USB_HYBRID_CANLIN_PRODUCT_ID),
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_hydra },
+	{ USB_DEVICE(KVASER_VENDOR_ID, USB_ATI_USBCAN_PRO_2HS_V2_PRODUCT_ID),
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_hydra },
+	{ USB_DEVICE(KVASER_VENDOR_ID, USB_ATI_MEMO_PRO_2HS_V2_PRODUCT_ID),
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_hydra },
+	{ USB_DEVICE(KVASER_VENDOR_ID, USB_HYBRID_PRO_CANLIN_PRODUCT_ID),
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_hydra },
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, kvaser_usb_table);
@@ -267,6 +297,7 @@ int kvaser_usb_can_rx_over_error(struct net_device *netdev)
 static void kvaser_usb_read_bulk_callback(struct urb *urb)
 {
 	struct kvaser_usb *dev = urb->context;
+	const struct kvaser_usb_dev_ops *ops = dev->driver_info->ops;
 	int err;
 	unsigned int i;
 
@@ -283,8 +314,8 @@ static void kvaser_usb_read_bulk_callback(struct urb *urb)
 		goto resubmit_urb;
 	}
 
-	dev->ops->dev_read_bulk_callback(dev, urb->transfer_buffer,
-					 urb->actual_length);
+	ops->dev_read_bulk_callback(dev, urb->transfer_buffer,
+				    urb->actual_length);
 
 resubmit_urb:
 	usb_fill_bulk_urb(urb, dev->udev,
@@ -378,6 +409,7 @@ static int kvaser_usb_open(struct net_device *netdev)
 {
 	struct kvaser_usb_net_priv *priv = netdev_priv(netdev);
 	struct kvaser_usb *dev = priv->dev;
+	const struct kvaser_usb_dev_ops *ops = dev->driver_info->ops;
 	int err;
 
 	err = open_candev(netdev);
@@ -388,11 +420,11 @@ static int kvaser_usb_open(struct net_device *netdev)
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
@@ -449,22 +481,23 @@ static int kvaser_usb_close(struct net_device *netdev)
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
 
@@ -503,6 +536,7 @@ static netdev_tx_t kvaser_usb_start_xmit(struct sk_buff *skb,
 {
 	struct kvaser_usb_net_priv *priv = netdev_priv(netdev);
 	struct kvaser_usb *dev = priv->dev;
+	const struct kvaser_usb_dev_ops *ops = dev->driver_info->ops;
 	struct net_device_stats *stats = &netdev->stats;
 	struct kvaser_usb_tx_urb_context *context = NULL;
 	struct urb *urb;
@@ -545,8 +579,8 @@ static netdev_tx_t kvaser_usb_start_xmit(struct sk_buff *skb,
 		goto freeurb;
 	}
 
-	buf = dev->ops->dev_frame_to_cmd(priv, skb, &context->dlc, &cmd_len,
-					 context->echo_index);
+	buf = ops->dev_frame_to_cmd(priv, skb, &context->dlc, &cmd_len,
+				    context->echo_index);
 	if (!buf) {
 		stats->tx_dropped++;
 		dev_kfree_skb(skb);
@@ -630,15 +664,16 @@ static void kvaser_usb_remove_interfaces(struct kvaser_usb *dev)
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
@@ -668,20 +703,19 @@ static int kvaser_usb_init_one(struct kvaser_usb *dev,
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
@@ -712,29 +746,22 @@ static int kvaser_usb_probe(struct usb_interface *intf,
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
@@ -748,22 +775,22 @@ static int kvaser_usb_probe(struct usb_interface *intf,
 
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
@@ -781,14 +808,14 @@ static int kvaser_usb_probe(struct usb_interface *intf,
 
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
@@ -798,7 +825,7 @@ static int kvaser_usb_probe(struct usb_interface *intf,
 	}
 
 	for (i = 0; i < dev->nchannels; i++) {
-		err = kvaser_usb_init_one(dev, id, i);
+		err = kvaser_usb_init_one(dev, i);
 		if (err) {
 			kvaser_usb_remove_interfaces(dev);
 			return err;
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
index 218fadc91155..a7c408acb0c0 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
@@ -371,7 +371,7 @@ static const struct can_bittiming_const kvaser_usb_hydra_kcan_bittiming_c = {
 	.brp_inc = 1,
 };
 
-static const struct can_bittiming_const kvaser_usb_hydra_flexc_bittiming_c = {
+const struct can_bittiming_const kvaser_usb_flexc_bittiming_const = {
 	.name = "kvaser_usb_flex",
 	.tseg1_min = 4,
 	.tseg1_max = 16,
@@ -2024,5 +2024,5 @@ static const struct kvaser_usb_dev_cfg kvaser_usb_hydra_dev_cfg_flexc = {
 		.freq = 24000000,
 	},
 	.timestamp_freq = 1,
-	.bittiming_const = &kvaser_usb_hydra_flexc_bittiming_c,
+	.bittiming_const = &kvaser_usb_flexc_bittiming_const,
 };
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
index 8b5d1add899a..0e0403dd0550 100644
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
 
diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index ae3eea4a4213..1463cf4321a8 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -4691,6 +4691,15 @@ static int ibmvnic_reset_init(struct ibmvnic_adapter *adapter)
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
diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 2aa28c961d26..e5c7a5c05109 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -2131,7 +2131,7 @@ static void usbnet_async_cmd_cb(struct urb *urb)
 int usbnet_write_cmd_async(struct usbnet *dev, u8 cmd, u8 reqtype,
 			   u16 value, u16 index, const void *data, u16 size)
 {
-	struct usb_ctrlrequest *req = NULL;
+	struct usb_ctrlrequest *req;
 	struct urb *urb;
 	int err = -ENOMEM;
 	void *buf = NULL;
@@ -2149,7 +2149,7 @@ int usbnet_write_cmd_async(struct usbnet *dev, u8 cmd, u8 reqtype,
 		if (!buf) {
 			netdev_err(dev->net, "Error allocating buffer"
 				   " in %s!\n", __func__);
-			goto fail_free;
+			goto fail_free_urb;
 		}
 	}
 
@@ -2173,14 +2173,21 @@ int usbnet_write_cmd_async(struct usbnet *dev, u8 cmd, u8 reqtype,
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
diff --git a/drivers/video/fbdev/core/fbcon.c b/drivers/video/fbdev/core/fbcon.c
index 7c2582892eab..17ed20a73c2d 100644
--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -2468,6 +2468,11 @@ static int fbcon_set_font(struct vc_data *vc, struct console_font *font,
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
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index cd81d6d9848d..0370ee34b71c 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2899,7 +2899,6 @@ xfs_rename(
 	 * appropriately.
 	 */
 	if (flags & RENAME_WHITEOUT) {
-		ASSERT(!(flags & (RENAME_NOREPLACE | RENAME_EXCHANGE)));
 		error = xfs_rename_alloc_whiteout(target_dp, &wip);
 		if (error)
 			return error;
diff --git a/include/linux/rtsx_usb.h b/include/linux/rtsx_usb.h
index c446e4fd6b5c..09b08ff08830 100644
--- a/include/linux/rtsx_usb.h
+++ b/include/linux/rtsx_usb.h
@@ -65,8 +65,6 @@ struct rtsx_ucr {
 	struct usb_device	*pusb_dev;
 	struct usb_interface	*pusb_intf;
 	struct usb_sg_request	current_sg;
-	unsigned char		*iobuf;
-	dma_addr_t		iobuf_dma;
 
 	struct timer_list	sg_timer;
 	struct mutex		dev_mutex;
diff --git a/include/net/esp.h b/include/net/esp.h
index 465e38890ee9..117652eb6ea3 100644
--- a/include/net/esp.h
+++ b/include/net/esp.h
@@ -4,8 +4,6 @@
 
 #include <linux/skbuff.h>
 
-#define ESP_SKB_FRAG_MAXSIZE (PAGE_SIZE << SKB_FRAG_PAGE_ORDER)
-
 struct ip_esp_hdr;
 
 static inline struct ip_esp_hdr *ip_esp_hdr(const struct sk_buff *skb)
diff --git a/include/video/of_display_timing.h b/include/video/of_display_timing.h
index bb29e5954000..338f3839a299 100644
--- a/include/video/of_display_timing.h
+++ b/include/video/of_display_timing.h
@@ -9,6 +9,8 @@
 #ifndef __LINUX_OF_DISPLAY_TIMING_H
 #define __LINUX_OF_DISPLAY_TIMING_H
 
+#include <linux/errno.h>
+
 struct device_node;
 struct display_timing;
 struct display_timings;
diff --git a/lib/idr.c b/lib/idr.c
index 6ff3b1c36e0a..82c24a417dc6 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -573,7 +573,9 @@ void ida_free(struct ida *ida, unsigned int id)
 {
 	unsigned long flags;
 
-	BUG_ON((int)id < 0);
+	if ((int)id < 0)
+		return;
+
 	xa_lock_irqsave(&ida->ida_rt, flags);
 	ida_remove(ida, id);
 	xa_unlock_irqrestore(&ida->ida_rt, flags);
diff --git a/mm/slub.c b/mm/slub.c
index 499fb073d1ff..0fefe0ad8f57 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2162,6 +2162,7 @@ static void deactivate_slab(struct kmem_cache *s, struct page *page,
 
 	c->page = NULL;
 	c->freelist = NULL;
+	c->tid = next_tid(c->tid);
 }
 
 /*
@@ -2295,8 +2296,6 @@ static inline void flush_slab(struct kmem_cache *s, struct kmem_cache_cpu *c)
 {
 	stat(s, CPUSLAB_FLUSH);
 	deactivate_slab(s, c->page, c->freelist, c);
-
-	c->tid = next_tid(c->tid);
 }
 
 /*
@@ -2583,6 +2582,7 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 
 	if (!freelist) {
 		c->page = NULL;
+		c->tid = next_tid(c->tid);
 		stat(s, DEACTIVATE_BYPASS);
 		goto new_slab;
 	}
diff --git a/net/can/bcm.c b/net/can/bcm.c
index 353098166031..3c825b158fb5 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -99,6 +99,7 @@ static inline u64 get_u64(const struct canfd_frame *cp, int offset)
 
 struct bcm_op {
 	struct list_head list;
+	struct rcu_head rcu;
 	int ifindex;
 	canid_t can_id;
 	u32 flags;
@@ -717,10 +718,9 @@ static struct bcm_op *bcm_find_op(struct list_head *ops,
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
@@ -731,6 +731,14 @@ static void bcm_remove_op(struct bcm_op *op)
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
@@ -756,6 +764,9 @@ static int bcm_delete_rx_op(struct list_head *ops, struct bcm_msg_head *mh,
 		if ((op->can_id == mh->can_id) && (op->ifindex == ifindex) &&
 		    (op->flags & CAN_FD_FRAME) == (mh->flags & CAN_FD_FRAME)) {
 
+			/* disable automatic timer on frame reception */
+			op->flags |= RX_NO_AUTOTIMER;
+
 			/*
 			 * Don't care if we're bound or not (due to netdev
 			 * problems) can_rx_unregister() is always a save
@@ -784,7 +795,6 @@ static int bcm_delete_rx_op(struct list_head *ops, struct bcm_msg_head *mh,
 						  bcm_rx_handler, op);
 
 			list_del(&op->list);
-			synchronize_rcu();
 			bcm_remove_op(op);
 			return 1; /* done */
 		}
diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index 45bb5b60b994..203569500b91 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -275,7 +275,6 @@ int esp_output_head(struct xfrm_state *x, struct sk_buff *skb, struct esp_info *
 	struct page *page;
 	struct sk_buff *trailer;
 	int tailen = esp->tailen;
-	unsigned int allocsz;
 
 	/* this is non-NULL only with UDP Encapsulation */
 	if (x->encap) {
@@ -285,8 +284,8 @@ int esp_output_head(struct xfrm_state *x, struct sk_buff *skb, struct esp_info *
 			return err;
 	}
 
-	allocsz = ALIGN(skb->data_len + tailen, L1_CACHE_BYTES);
-	if (allocsz > ESP_SKB_FRAG_MAXSIZE)
+	if (ALIGN(tailen, L1_CACHE_BYTES) > PAGE_SIZE ||
+	    ALIGN(skb->data_len, L1_CACHE_BYTES) > PAGE_SIZE)
 		goto cow;
 
 	if (!skb_cloned(skb)) {
diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index e3abfc97fde7..d847ffbe9745 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -241,10 +241,9 @@ int esp6_output_head(struct xfrm_state *x, struct sk_buff *skb, struct esp_info
 	struct page *page;
 	struct sk_buff *trailer;
 	int tailen = esp->tailen;
-	unsigned int allocsz;
 
-	allocsz = ALIGN(skb->data_len + tailen, L1_CACHE_BYTES);
-	if (allocsz > ESP_SKB_FRAG_MAXSIZE)
+	if (ALIGN(tailen, L1_CACHE_BYTES) > PAGE_SIZE ||
+	    ALIGN(skb->data_len, L1_CACHE_BYTES) > PAGE_SIZE)
 		goto cow;
 
 	if (!skb_cloned(skb)) {
diff --git a/net/rose/rose_route.c b/net/rose/rose_route.c
index f2ff21d7df08..46ae92d70324 100644
--- a/net/rose/rose_route.c
+++ b/net/rose/rose_route.c
@@ -230,8 +230,8 @@ static void rose_remove_neigh(struct rose_neigh *rose_neigh)
 {
 	struct rose_neigh *s;
 
-	rose_stop_ftimer(rose_neigh);
-	rose_stop_t0timer(rose_neigh);
+	del_timer_sync(&rose_neigh->ftimer);
+	del_timer_sync(&rose_neigh->t0timer);
 
 	skb_queue_purge(&rose_neigh->queue);
 
diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index 08bac6cf1bb3..ee03552b4116 100644
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -819,6 +819,7 @@ learning_test()
 	# FDB entry was installed.
 	bridge link set dev $br_port1 flood off
 
+	ip link set $host1_if promisc on
 	tc qdisc add dev $host1_if ingress
 	tc filter add dev $host1_if ingress protocol ip pref 1 handle 101 \
 		flower dst_mac $mac action drop
@@ -829,7 +830,7 @@ learning_test()
 	tc -j -s filter show dev $host1_if ingress \
 		| jq -e ".[] | select(.options.handle == 101) \
 		| select(.options.actions[0].stats.packets == 1)" &> /dev/null
-	check_fail $? "Packet reached second host when should not"
+	check_fail $? "Packet reached first host when should not"
 
 	$MZ $host1_if -c 1 -p 64 -a $mac -t ip -q
 	sleep 1
@@ -868,6 +869,7 @@ learning_test()
 
 	tc filter del dev $host1_if ingress protocol ip pref 1 handle 101 flower
 	tc qdisc del dev $host1_if ingress
+	ip link set $host1_if promisc off
 
 	bridge link set dev $br_port1 flood on
 
@@ -885,6 +887,7 @@ flood_test_do()
 
 	# Add an ACL on `host2_if` which will tell us whether the packet
 	# was flooded to it or not.
+	ip link set $host2_if promisc on
 	tc qdisc add dev $host2_if ingress
 	tc filter add dev $host2_if ingress protocol ip pref 1 handle 101 \
 		flower dst_mac $mac action drop
@@ -902,6 +905,7 @@ flood_test_do()
 
 	tc filter del dev $host2_if ingress protocol ip pref 1 handle 101 flower
 	tc qdisc del dev $host2_if ingress
+	ip link set $host2_if promisc off
 
 	return $err
 }
