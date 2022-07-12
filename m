Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04A09571D7E
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 16:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233478AbiGLO7B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 10:59:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233294AbiGLO65 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 10:58:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0823112765;
        Tue, 12 Jul 2022 07:58:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B20F61248;
        Tue, 12 Jul 2022 14:58:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC0AEC341C8;
        Tue, 12 Jul 2022 14:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657637932;
        bh=pREIybagFU5vuoR/8VPcNZRX12LstCLDLZ/EgXAKTvI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tMaEFRetD6tnBwt6GXWa4IqsYuFgqZS1imiNnU+X1Ik0GoCdMV+skCJqT9qwCP/5w
         lLteY1iPFz79vUzcEYW4B1mVzOKc1OGv5nIwec6GNQiT29YozPSPrc1oD+ljF5M2kU
         ySy/XyJL0aNnAm3iZm5UYiZF2cQsYjYiP7uHKZeA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.14.288
Date:   Tue, 12 Jul 2022 16:58:46 +0200
Message-Id: <165763792642226@kroah.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <1657637926225123@kroah.com>
References: <1657637926225123@kroah.com>
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
index 1ae54266908b..de73407a1bc3 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 14
-SUBLEVEL = 287
+SUBLEVEL = 288
 EXTRAVERSION =
 NAME = Petit Gorille
 
diff --git a/arch/powerpc/platforms/powernv/rng.c b/arch/powerpc/platforms/powernv/rng.c
index 60ed30306da5..8a09e654e905 100644
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
diff --git a/drivers/dma/at_xdmac.c b/drivers/dma/at_xdmac.c
index 2af0e151b31b..c8dd0eef0b67 100644
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
diff --git a/drivers/dma/ti-dma-crossbar.c b/drivers/dma/ti-dma-crossbar.c
index 6574cb5a12fe..932c638ef4a0 100644
--- a/drivers/dma/ti-dma-crossbar.c
+++ b/drivers/dma/ti-dma-crossbar.c
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
index 804570b619f4..6ed96cb02239 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -374,7 +374,7 @@ static int dmar_pci_bus_notifier(struct notifier_block *nb,
 
 static struct notifier_block dmar_pci_bus_nb = {
 	.notifier_call = dmar_pci_bus_notifier,
-	.priority = INT_MIN,
+	.priority = 1,
 };
 
 static struct dmar_drhd_unit *
diff --git a/drivers/net/can/grcan.c b/drivers/net/can/grcan.c
index 4eb196d7f4a6..5ba3da9e1d39 100644
--- a/drivers/net/can/grcan.c
+++ b/drivers/net/can/grcan.c
@@ -1669,7 +1669,6 @@ static int grcan_probe(struct platform_device *ofdev)
 	 */
 	sysid_parent = of_find_node_by_path("/ambapp0");
 	if (sysid_parent) {
-		of_node_get(sysid_parent);
 		err = of_property_read_u32(sysid_parent, "systemid", &sysid);
 		if (!err && ((sysid & GRLIB_VERSION_MASK) >=
 			     GRCAN_TXBUG_SAFE_GRLIB_VERSION))
diff --git a/drivers/net/can/usb/gs_usb.c b/drivers/net/can/usb/gs_usb.c
index ab2e019c841f..31c1dc0aa5cf 100644
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
diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 43f14f64be00..24d40d6c78eb 100644
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
index e9b6f053f5bd..a97e94b1c84f 100644
--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -2445,6 +2445,11 @@ static int fbcon_set_font(struct vc_data *vc, struct console_font *font, unsigne
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
index 7cfbe2b0f886..cfc7d6e01158 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2964,7 +2964,6 @@ xfs_rename(
 	 * appropriately.
 	 */
 	if (flags & RENAME_WHITEOUT) {
-		ASSERT(!(flags & (RENAME_NOREPLACE | RENAME_EXCHANGE)));
 		error = xfs_rename_alloc_whiteout(target_dp, &wip);
 		if (error)
 			return error;
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
index 956455fc9f9a..c10574089e56 100644
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
index 8c1a98d03164..f1a5f32fe207 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -498,7 +498,9 @@ void ida_simple_remove(struct ida *ida, unsigned int id)
 {
 	unsigned long flags;
 
-	BUG_ON((int)id < 0);
+	if ((int)id < 0)
+		return;
+
 	spin_lock_irqsave(&simple_ida_lock, flags);
 	ida_remove(ida, id);
 	spin_unlock_irqrestore(&simple_ida_lock, flags);
diff --git a/mm/slub.c b/mm/slub.c
index 484a75296a12..0120ce3867b7 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2171,6 +2171,7 @@ static void deactivate_slab(struct kmem_cache *s, struct page *page,
 
 	c->page = NULL;
 	c->freelist = NULL;
+	c->tid = next_tid(c->tid);
 }
 
 /*
@@ -2306,8 +2307,6 @@ static inline void flush_slab(struct kmem_cache *s, struct kmem_cache_cpu *c)
 {
 	stat(s, CPUSLAB_FLUSH);
 	deactivate_slab(s, c->page, c->freelist, c);
-
-	c->tid = next_tid(c->tid);
 }
 
 /*
@@ -2592,6 +2591,7 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 
 	if (!freelist) {
 		c->page = NULL;
+		c->tid = next_tid(c->tid);
 		stat(s, DEACTIVATE_BYPASS);
 		goto new_slab;
 	}
diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index 38e2aa2b2a31..d5e860573ecd 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -257,7 +257,6 @@ int esp_output_head(struct xfrm_state *x, struct sk_buff *skb, struct esp_info *
 	struct page *page;
 	struct sk_buff *trailer;
 	int tailen = esp->tailen;
-	unsigned int allocsz;
 
 	/* this is non-NULL only with UDP Encapsulation */
 	if (x->encap) {
@@ -267,8 +266,8 @@ int esp_output_head(struct xfrm_state *x, struct sk_buff *skb, struct esp_info *
 			return err;
 	}
 
-	allocsz = ALIGN(skb->data_len + tailen, L1_CACHE_BYTES);
-	if (allocsz > ESP_SKB_FRAG_MAXSIZE)
+	if (ALIGN(tailen, L1_CACHE_BYTES) > PAGE_SIZE ||
+	    ALIGN(skb->data_len, L1_CACHE_BYTES) > PAGE_SIZE)
 		goto cow;
 
 	if (!skb_cloned(skb)) {
diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index a9baf562bb9b..e19624245e16 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -223,10 +223,9 @@ int esp6_output_head(struct xfrm_state *x, struct sk_buff *skb, struct esp_info
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
index d94d6110bb1c..1027f52a45ab 100644
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
 
