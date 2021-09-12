Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2714D407D9C
	for <lists+stable@lfdr.de>; Sun, 12 Sep 2021 15:26:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235667AbhILN1r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Sep 2021 09:27:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:58254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235739AbhILN1p (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 12 Sep 2021 09:27:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5BB97610CE;
        Sun, 12 Sep 2021 13:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631453191;
        bh=vwQAXhI8sVIqNgoyieusHIz/qpYq0o2H0a00unFINk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=psdg47Jmtbo1NUmEveVTc9ZsGwfD2GanMD45aSj3JfdvbH4XCU7OX17IMnKv1yKqB
         7mae+JszBMmpHHqfsW2/VU/CXBAbgqjjwllInnQ4AOc0UKt4+uPZxs2pHXQ+YhRnih
         6f9xhnxPi49XBXI1MppeCTiMGwD6XdQMXQlhTujY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.13.16
Date:   Sun, 12 Sep 2021 15:26:25 +0200
Message-Id: <1631453185206250@kroah.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <16314531842471@kroah.com>
References: <16314531842471@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index d0ea05957da6..cbb2f35baedb 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 13
-SUBLEVEL = 15
+SUBLEVEL = 16
 EXTRAVERSION =
 NAME = Opossums on Parade
 
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index b29657b76e3f..798a6f73f894 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -388,10 +388,11 @@ static const struct dmi_system_id reboot_dmi_table[] __initconst = {
 	},
 	{	/* Handle problems with rebooting on the OptiPlex 990. */
 		.callback = set_pci_reboot,
-		.ident = "Dell OptiPlex 990",
+		.ident = "Dell OptiPlex 990 BIOS A0x",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
 			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex 990"),
+			DMI_MATCH(DMI_BIOS_VERSION, "A0"),
 		},
 	},
 	{	/* Handle problems with rebooting on Dell 300's */
diff --git a/block/blk-core.c b/block/blk-core.c
index ce0125efbaa7..9dce692e25a2 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -122,7 +122,6 @@ void blk_rq_init(struct request_queue *q, struct request *rq)
 	rq->internal_tag = BLK_MQ_NO_TAG;
 	rq->start_time_ns = ktime_get_ns();
 	rq->part = NULL;
-	refcount_set(&rq->ref, 1);
 	blk_crypto_rq_set_defaults(rq);
 }
 EXPORT_SYMBOL(blk_rq_init);
diff --git a/block/blk-flush.c b/block/blk-flush.c
index 1002f6c58181..4201728bf3a5 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -262,6 +262,11 @@ static void flush_end_io(struct request *flush_rq, blk_status_t error)
 	spin_unlock_irqrestore(&fq->mq_flush_lock, flags);
 }
 
+bool is_flush_rq(struct request *rq)
+{
+	return rq->end_io == flush_end_io;
+}
+
 /**
  * blk_kick_flush - consider issuing flush request
  * @q: request_queue being kicked
@@ -329,6 +334,14 @@ static void blk_kick_flush(struct request_queue *q, struct blk_flush_queue *fq,
 	flush_rq->rq_flags |= RQF_FLUSH_SEQ;
 	flush_rq->rq_disk = first_rq->rq_disk;
 	flush_rq->end_io = flush_end_io;
+	/*
+	 * Order WRITE ->end_io and WRITE rq->ref, and its pair is the one
+	 * implied in refcount_inc_not_zero() called from
+	 * blk_mq_find_and_get_req(), which orders WRITE/READ flush_rq->ref
+	 * and READ flush_rq->end_io
+	 */
+	smp_wmb();
+	refcount_set(&flush_rq->ref, 1);
 
 	blk_flush_queue_rq(flush_rq, false);
 }
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 6dfa572ac1fc..74fde07721e8 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -911,7 +911,7 @@ static bool blk_mq_req_expired(struct request *rq, unsigned long *next)
 
 void blk_mq_put_rq_ref(struct request *rq)
 {
-	if (is_flush_rq(rq, rq->mq_hctx))
+	if (is_flush_rq(rq))
 		rq->end_io(rq, 0);
 	else if (refcount_dec_and_test(&rq->ref))
 		__blk_mq_free_request(rq);
@@ -2620,16 +2620,49 @@ static void blk_mq_remove_cpuhp(struct blk_mq_hw_ctx *hctx)
 					    &hctx->cpuhp_dead);
 }
 
+/*
+ * Before freeing hw queue, clearing the flush request reference in
+ * tags->rqs[] for avoiding potential UAF.
+ */
+static void blk_mq_clear_flush_rq_mapping(struct blk_mq_tags *tags,
+		unsigned int queue_depth, struct request *flush_rq)
+{
+	int i;
+	unsigned long flags;
+
+	/* The hw queue may not be mapped yet */
+	if (!tags)
+		return;
+
+	WARN_ON_ONCE(refcount_read(&flush_rq->ref) != 0);
+
+	for (i = 0; i < queue_depth; i++)
+		cmpxchg(&tags->rqs[i], flush_rq, NULL);
+
+	/*
+	 * Wait until all pending iteration is done.
+	 *
+	 * Request reference is cleared and it is guaranteed to be observed
+	 * after the ->lock is released.
+	 */
+	spin_lock_irqsave(&tags->lock, flags);
+	spin_unlock_irqrestore(&tags->lock, flags);
+}
+
 /* hctx->ctxs will be freed in queue's release handler */
 static void blk_mq_exit_hctx(struct request_queue *q,
 		struct blk_mq_tag_set *set,
 		struct blk_mq_hw_ctx *hctx, unsigned int hctx_idx)
 {
+	struct request *flush_rq = hctx->fq->flush_rq;
+
 	if (blk_mq_hw_queue_mapped(hctx))
 		blk_mq_tag_idle(hctx);
 
+	blk_mq_clear_flush_rq_mapping(set->tags[hctx_idx],
+			set->queue_depth, flush_rq);
 	if (set->ops->exit_request)
-		set->ops->exit_request(set, hctx->fq->flush_rq, hctx_idx);
+		set->ops->exit_request(set, flush_rq, hctx_idx);
 
 	if (set->ops->exit_hctx)
 		set->ops->exit_hctx(hctx, hctx_idx);
diff --git a/block/blk.h b/block/blk.h
index 8b3591aee0a5..54d48987c21b 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -44,11 +44,7 @@ static inline void __blk_get_queue(struct request_queue *q)
 	kobject_get(&q->kobj);
 }
 
-static inline bool
-is_flush_rq(struct request *req, struct blk_mq_hw_ctx *hctx)
-{
-	return hctx->fq->flush_rq == req;
-}
+bool is_flush_rq(struct request *req);
 
 struct blk_flush_queue *blk_alloc_flush_queue(int node, int cmd_size,
 					      gfp_t flags);
diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index c6b48160343a..9122f9cc97cb 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -443,6 +443,10 @@ static const struct usb_device_id blacklist_table[] = {
 	/* Additional Realtek 8822CE Bluetooth devices */
 	{ USB_DEVICE(0x04ca, 0x4005), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
+	/* Bluetooth component of Realtek 8852AE device */
+	{ USB_DEVICE(0x04ca, 0x4006), .driver_info = BTUSB_REALTEK |
+						     BTUSB_WIDEBAND_SPEECH },
+
 	{ USB_DEVICE(0x04c5, 0x161f), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x0b05, 0x18ef), .driver_info = BTUSB_REALTEK |
@@ -1886,7 +1890,7 @@ static int btusb_setup_csr(struct hci_dev *hdev)
 		is_fake = true;
 
 	if (is_fake) {
-		bt_dev_warn(hdev, "CSR: Unbranded CSR clone detected; adding workarounds...");
+		bt_dev_warn(hdev, "CSR: Unbranded CSR clone detected; adding workarounds and force-suspending once...");
 
 		/* Generally these clones have big discrepancies between
 		 * advertised features and what's actually supported.
@@ -1903,41 +1907,46 @@ static int btusb_setup_csr(struct hci_dev *hdev)
 		clear_bit(HCI_QUIRK_SIMULTANEOUS_DISCOVERY, &hdev->quirks);
 
 		/*
-		 * Special workaround for clones with a Barrot 8041a02 chip,
-		 * these clones are really messed-up:
-		 * 1. Their bulk rx endpoint will never report any data unless
-		 * the device was suspended at least once (yes really).
+		 * Special workaround for these BT 4.0 chip clones, and potentially more:
+		 *
+		 * - 0x0134: a Barrot 8041a02                 (HCI rev: 0x1012 sub: 0x0810)
+		 * - 0x7558: IC markings FR3191AHAL 749H15143 (HCI rev/sub-version: 0x0709)
+		 *
+		 * These controllers are really messed-up.
+		 *
+		 * 1. Their bulk RX endpoint will never report any data unless
+		 * the device was suspended at least once (yes, really).
 		 * 2. They will not wakeup when autosuspended and receiving data
-		 * on their bulk rx endpoint from e.g. a keyboard or mouse
+		 * on their bulk RX endpoint from e.g. a keyboard or mouse
 		 * (IOW remote-wakeup support is broken for the bulk endpoint).
 		 *
 		 * To fix 1. enable runtime-suspend, force-suspend the
-		 * hci and then wake-it up by disabling runtime-suspend.
+		 * HCI and then wake-it up by disabling runtime-suspend.
 		 *
-		 * To fix 2. clear the hci's can_wake flag, this way the hci
+		 * To fix 2. clear the HCI's can_wake flag, this way the HCI
 		 * will still be autosuspended when it is not open.
+		 *
+		 * --
+		 *
+		 * Because these are widespread problems we prefer generic solutions; so
+		 * apply this initialization quirk to every controller that gets here,
+		 * it should be harmless. The alternative is to not work at all.
 		 */
-		if (bcdDevice == 0x8891 &&
-		    le16_to_cpu(rp->lmp_subver) == 0x1012 &&
-		    le16_to_cpu(rp->hci_rev) == 0x0810 &&
-		    le16_to_cpu(rp->hci_ver) == BLUETOOTH_VER_4_0) {
-			bt_dev_warn(hdev, "CSR: detected a fake CSR dongle using a Barrot 8041a02 chip, this chip is very buggy and may have issues");
+		pm_runtime_allow(&data->udev->dev);
 
-			pm_runtime_allow(&data->udev->dev);
+		ret = pm_runtime_suspend(&data->udev->dev);
+		if (ret >= 0)
+			msleep(200);
+		else
+			bt_dev_err(hdev, "CSR: Failed to suspend the device for our Barrot 8041a02 receive-issue workaround");
 
-			ret = pm_runtime_suspend(&data->udev->dev);
-			if (ret >= 0)
-				msleep(200);
-			else
-				bt_dev_err(hdev, "Failed to suspend the device for Barrot 8041a02 receive-issue workaround");
+		pm_runtime_forbid(&data->udev->dev);
 
-			pm_runtime_forbid(&data->udev->dev);
+		device_set_wakeup_capable(&data->udev->dev, false);
 
-			device_set_wakeup_capable(&data->udev->dev, false);
-			/* Re-enable autosuspend if this was requested */
-			if (enable_autosuspend)
-				usb_enable_autosuspend(data->udev);
-		}
+		/* Re-enable autosuspend if this was requested */
+		if (enable_autosuspend)
+			usb_enable_autosuspend(data->udev);
 	}
 
 	kfree_skb(skb);
diff --git a/drivers/firmware/dmi-id.c b/drivers/firmware/dmi-id.c
index 4d5421d14a41..940ddf916202 100644
--- a/drivers/firmware/dmi-id.c
+++ b/drivers/firmware/dmi-id.c
@@ -73,6 +73,10 @@ static void ascii_filter(char *d, const char *s)
 
 static ssize_t get_modalias(char *buffer, size_t buffer_size)
 {
+	/*
+	 * Note new fields need to be added at the end to keep compatibility
+	 * with udev's hwdb which does matches on "`cat dmi/id/modalias`*".
+	 */
 	static const struct mafield {
 		const char *prefix;
 		int field;
@@ -85,13 +89,13 @@ static ssize_t get_modalias(char *buffer, size_t buffer_size)
 		{ "svn", DMI_SYS_VENDOR },
 		{ "pn",  DMI_PRODUCT_NAME },
 		{ "pvr", DMI_PRODUCT_VERSION },
-		{ "sku", DMI_PRODUCT_SKU },
 		{ "rvn", DMI_BOARD_VENDOR },
 		{ "rn",  DMI_BOARD_NAME },
 		{ "rvr", DMI_BOARD_VERSION },
 		{ "cvn", DMI_CHASSIS_VENDOR },
 		{ "ct",  DMI_CHASSIS_TYPE },
 		{ "cvr", DMI_CHASSIS_VERSION },
+		{ "sku", DMI_PRODUCT_SKU },
 		{ NULL,  DMI_NONE }
 	};
 
diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index b8eb1b2a8de3..ffbae9b64dc5 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -3510,6 +3510,7 @@ static void rtl_hw_start_8106(struct rtl8169_private *tp)
 	rtl_eri_write(tp, 0x1b0, ERIAR_MASK_0011, 0x0000);
 
 	rtl_pcie_state_l2l3_disable(tp);
+	rtl_hw_aspm_clkreq_enable(tp, true);
 }
 
 DECLARE_RTL_COND(rtl_mac_ocp_e00e_cond)
diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index 9a13953ea70f..60a4f79b8fa1 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -942,10 +942,8 @@ temac_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	wmb();
 	lp->dma_out(lp, TX_TAILDESC_PTR, tail_p); /* DMA start */
 
-	if (temac_check_tx_bd_space(lp, MAX_SKB_FRAGS + 1)) {
-		netdev_info(ndev, "%s -> netif_stop_queue\n", __func__);
+	if (temac_check_tx_bd_space(lp, MAX_SKB_FRAGS + 1))
 		netif_stop_queue(ndev);
-	}
 
 	return NETDEV_TX_OK;
 }
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index ab3de1551b50..7b1c81b899cd 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3235,12 +3235,12 @@ static void fixup_mpss_256(struct pci_dev *dev)
 {
 	dev->pcie_mpss = 1; /* 256 bytes */
 }
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_SOLARFLARE,
-			 PCI_DEVICE_ID_SOLARFLARE_SFC4000A_0, fixup_mpss_256);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_SOLARFLARE,
-			 PCI_DEVICE_ID_SOLARFLARE_SFC4000A_1, fixup_mpss_256);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_SOLARFLARE,
-			 PCI_DEVICE_ID_SOLARFLARE_SFC4000B, fixup_mpss_256);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SOLARFLARE,
+			PCI_DEVICE_ID_SOLARFLARE_SFC4000A_0, fixup_mpss_256);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SOLARFLARE,
+			PCI_DEVICE_ID_SOLARFLARE_SFC4000A_1, fixup_mpss_256);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SOLARFLARE,
+			PCI_DEVICE_ID_SOLARFLARE_SFC4000B, fixup_mpss_256);
 
 /*
  * Intel 5000 and 5100 Memory controllers have an erratum with read completion
diff --git a/drivers/usb/cdns3/cdnsp-mem.c b/drivers/usb/cdns3/cdnsp-mem.c
index 5d4c4bfe15b7..697a4e47c642 100644
--- a/drivers/usb/cdns3/cdnsp-mem.c
+++ b/drivers/usb/cdns3/cdnsp-mem.c
@@ -882,7 +882,7 @@ static u32 cdnsp_get_endpoint_max_burst(struct usb_gadget *g,
 	if (g->speed == USB_SPEED_HIGH &&
 	    (usb_endpoint_xfer_isoc(pep->endpoint.desc) ||
 	     usb_endpoint_xfer_int(pep->endpoint.desc)))
-		return (usb_endpoint_maxp(pep->endpoint.desc) & 0x1800) >> 11;
+		return usb_endpoint_maxp_mult(pep->endpoint.desc) - 1;
 
 	return 0;
 }
diff --git a/drivers/usb/gadget/udc/tegra-xudc.c b/drivers/usb/gadget/udc/tegra-xudc.c
index f3f112b08c9b..57ee72fead45 100644
--- a/drivers/usb/gadget/udc/tegra-xudc.c
+++ b/drivers/usb/gadget/udc/tegra-xudc.c
@@ -1610,7 +1610,7 @@ static void tegra_xudc_ep_context_setup(struct tegra_xudc_ep *ep)
 	u16 maxpacket, maxburst = 0, esit = 0;
 	u32 val;
 
-	maxpacket = usb_endpoint_maxp(desc) & 0x7ff;
+	maxpacket = usb_endpoint_maxp(desc);
 	if (xudc->gadget.speed == USB_SPEED_SUPER) {
 		if (!usb_endpoint_xfer_control(desc))
 			maxburst = comp_desc->bMaxBurst;
@@ -1621,7 +1621,7 @@ static void tegra_xudc_ep_context_setup(struct tegra_xudc_ep *ep)
 		   (usb_endpoint_xfer_int(desc) ||
 		    usb_endpoint_xfer_isoc(desc))) {
 		if (xudc->gadget.speed == USB_SPEED_HIGH) {
-			maxburst = (usb_endpoint_maxp(desc) >> 11) & 0x3;
+			maxburst = usb_endpoint_maxp_mult(desc) - 1;
 			if (maxburst == 0x3) {
 				dev_warn(xudc->dev,
 					 "invalid endpoint maxburst\n");
diff --git a/drivers/usb/host/xhci-debugfs.c b/drivers/usb/host/xhci-debugfs.c
index 2c0fda57869e..dc832ddf7033 100644
--- a/drivers/usb/host/xhci-debugfs.c
+++ b/drivers/usb/host/xhci-debugfs.c
@@ -198,12 +198,13 @@ static void xhci_ring_dump_segment(struct seq_file *s,
 	int			i;
 	dma_addr_t		dma;
 	union xhci_trb		*trb;
+	char			str[XHCI_MSG_MAX];
 
 	for (i = 0; i < TRBS_PER_SEGMENT; i++) {
 		trb = &seg->trbs[i];
 		dma = seg->dma + i * sizeof(*trb);
 		seq_printf(s, "%pad: %s\n", &dma,
-			   xhci_decode_trb(le32_to_cpu(trb->generic.field[0]),
+			   xhci_decode_trb(str, XHCI_MSG_MAX, le32_to_cpu(trb->generic.field[0]),
 					   le32_to_cpu(trb->generic.field[1]),
 					   le32_to_cpu(trb->generic.field[2]),
 					   le32_to_cpu(trb->generic.field[3])));
@@ -260,11 +261,13 @@ static int xhci_slot_context_show(struct seq_file *s, void *unused)
 	struct xhci_slot_ctx	*slot_ctx;
 	struct xhci_slot_priv	*priv = s->private;
 	struct xhci_virt_device	*dev = priv->dev;
+	char			str[XHCI_MSG_MAX];
 
 	xhci = hcd_to_xhci(bus_to_hcd(dev->udev->bus));
 	slot_ctx = xhci_get_slot_ctx(xhci, dev->out_ctx);
 	seq_printf(s, "%pad: %s\n", &dev->out_ctx->dma,
-		   xhci_decode_slot_context(le32_to_cpu(slot_ctx->dev_info),
+		   xhci_decode_slot_context(str,
+					    le32_to_cpu(slot_ctx->dev_info),
 					    le32_to_cpu(slot_ctx->dev_info2),
 					    le32_to_cpu(slot_ctx->tt_info),
 					    le32_to_cpu(slot_ctx->dev_state)));
@@ -280,6 +283,7 @@ static int xhci_endpoint_context_show(struct seq_file *s, void *unused)
 	struct xhci_ep_ctx	*ep_ctx;
 	struct xhci_slot_priv	*priv = s->private;
 	struct xhci_virt_device	*dev = priv->dev;
+	char			str[XHCI_MSG_MAX];
 
 	xhci = hcd_to_xhci(bus_to_hcd(dev->udev->bus));
 
@@ -287,7 +291,8 @@ static int xhci_endpoint_context_show(struct seq_file *s, void *unused)
 		ep_ctx = xhci_get_ep_ctx(xhci, dev->out_ctx, ep_index);
 		dma = dev->out_ctx->dma + (ep_index + 1) * CTX_SIZE(xhci->hcc_params);
 		seq_printf(s, "%pad: %s\n", &dma,
-			   xhci_decode_ep_context(le32_to_cpu(ep_ctx->ep_info),
+			   xhci_decode_ep_context(str,
+						  le32_to_cpu(ep_ctx->ep_info),
 						  le32_to_cpu(ep_ctx->ep_info2),
 						  le64_to_cpu(ep_ctx->deq),
 						  le32_to_cpu(ep_ctx->tx_info)));
@@ -341,9 +346,10 @@ static int xhci_portsc_show(struct seq_file *s, void *unused)
 {
 	struct xhci_port	*port = s->private;
 	u32			portsc;
+	char			str[XHCI_MSG_MAX];
 
 	portsc = readl(port->addr);
-	seq_printf(s, "%s\n", xhci_decode_portsc(portsc));
+	seq_printf(s, "%s\n", xhci_decode_portsc(str, portsc));
 
 	return 0;
 }
diff --git a/drivers/usb/host/xhci-mtk-sch.c b/drivers/usb/host/xhci-mtk-sch.c
index 8b90da5a6ed1..5e003baabac9 100644
--- a/drivers/usb/host/xhci-mtk-sch.c
+++ b/drivers/usb/host/xhci-mtk-sch.c
@@ -590,10 +590,12 @@ static u32 get_esit_boundary(struct mu3h_sch_ep_info *sch_ep)
 	u32 boundary = sch_ep->esit;
 
 	if (sch_ep->sch_tt) { /* LS/FS with TT */
-		/* tune for CS */
-		if (sch_ep->ep_type != ISOC_OUT_EP)
-			boundary++;
-		else if (boundary > 1) /* normally esit >= 8 for FS/LS */
+		/*
+		 * tune for CS, normally esit >= 8 for FS/LS,
+		 * not add one for other types to avoid access array
+		 * out of boundary
+		 */
+		if (sch_ep->ep_type == ISOC_OUT_EP && boundary > 1)
 			boundary--;
 	}
 
diff --git a/drivers/usb/host/xhci-rcar.c b/drivers/usb/host/xhci-rcar.c
index 1bc4fe7b8c75..9888ba7d85b6 100644
--- a/drivers/usb/host/xhci-rcar.c
+++ b/drivers/usb/host/xhci-rcar.c
@@ -134,6 +134,13 @@ static int xhci_rcar_download_firmware(struct usb_hcd *hcd)
 	const struct soc_device_attribute *attr;
 	const char *firmware_name;
 
+	/*
+	 * According to the datasheet, "Upon the completion of FW Download,
+	 * there is no need to write or reload FW".
+	 */
+	if (readl(regs + RCAR_USB3_DL_CTRL) & RCAR_USB3_DL_CTRL_FW_SUCCESS)
+		return 0;
+
 	attr = soc_device_match(rcar_quirks_match);
 	if (attr)
 		quirks = (uintptr_t)attr->data;
diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 6acd2329e08d..5b54a3622c39 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -942,17 +942,21 @@ static int xhci_invalidate_cancelled_tds(struct xhci_virt_ep *ep)
 					 td->urb->stream_id);
 		hw_deq &= ~0xf;
 
-		if (td->cancel_status == TD_HALTED) {
-			cached_td = td;
-		} else if (trb_in_td(xhci, td->start_seg, td->first_trb,
-			      td->last_trb, hw_deq, false)) {
+		if (td->cancel_status == TD_HALTED ||
+		    trb_in_td(xhci, td->start_seg, td->first_trb, td->last_trb, hw_deq, false)) {
 			switch (td->cancel_status) {
 			case TD_CLEARED: /* TD is already no-op */
 			case TD_CLEARING_CACHE: /* set TR deq command already queued */
 				break;
 			case TD_DIRTY: /* TD is cached, clear it */
 			case TD_HALTED:
-				/* FIXME  stream case, several stopped rings */
+				td->cancel_status = TD_CLEARING_CACHE;
+				if (cached_td)
+					/* FIXME  stream case, several stopped rings */
+					xhci_dbg(xhci,
+						 "Move dq past stream %u URB %p instead of stream %u URB %p\n",
+						 td->urb->stream_id, td->urb,
+						 cached_td->urb->stream_id, cached_td->urb);
 				cached_td = td;
 				break;
 			}
@@ -961,18 +965,24 @@ static int xhci_invalidate_cancelled_tds(struct xhci_virt_ep *ep)
 			td->cancel_status = TD_CLEARED;
 		}
 	}
-	if (cached_td) {
-		cached_td->cancel_status = TD_CLEARING_CACHE;
 
-		err = xhci_move_dequeue_past_td(xhci, slot_id, ep->ep_index,
-						cached_td->urb->stream_id,
-						cached_td);
-		/* Failed to move past cached td, try just setting it noop */
-		if (err) {
-			td_to_noop(xhci, ring, cached_td, false);
-			cached_td->cancel_status = TD_CLEARED;
+	/* If there's no need to move the dequeue pointer then we're done */
+	if (!cached_td)
+		return 0;
+
+	err = xhci_move_dequeue_past_td(xhci, slot_id, ep->ep_index,
+					cached_td->urb->stream_id,
+					cached_td);
+	if (err) {
+		/* Failed to move past cached td, just set cached TDs to no-op */
+		list_for_each_entry_safe(td, tmp_td, &ep->cancelled_td_list, cancelled_td_list) {
+			if (td->cancel_status != TD_CLEARING_CACHE)
+				continue;
+			xhci_dbg(xhci, "Failed to clear cancelled cached URB %p, mark clear anyway\n",
+				 td->urb);
+			td_to_noop(xhci, ring, td, false);
+			td->cancel_status = TD_CLEARED;
 		}
-		cached_td = NULL;
 	}
 	return 0;
 }
@@ -1212,6 +1222,7 @@ void xhci_stop_endpoint_command_watchdog(struct timer_list *t)
 	struct xhci_hcd *xhci = ep->xhci;
 	unsigned long flags;
 	u32 usbsts;
+	char str[XHCI_MSG_MAX];
 
 	spin_lock_irqsave(&xhci->lock, flags);
 
@@ -1225,7 +1236,7 @@ void xhci_stop_endpoint_command_watchdog(struct timer_list *t)
 	usbsts = readl(&xhci->op_regs->status);
 
 	xhci_warn(xhci, "xHCI host not responding to stop endpoint command.\n");
-	xhci_warn(xhci, "USBSTS:%s\n", xhci_decode_usbsts(usbsts));
+	xhci_warn(xhci, "USBSTS:%s\n", xhci_decode_usbsts(str, usbsts));
 
 	ep->ep_state &= ~EP_STOP_CMD_PENDING;
 
diff --git a/drivers/usb/host/xhci-trace.h b/drivers/usb/host/xhci-trace.h
index 627abd236dbe..a5da02077297 100644
--- a/drivers/usb/host/xhci-trace.h
+++ b/drivers/usb/host/xhci-trace.h
@@ -25,8 +25,6 @@
 #include "xhci.h"
 #include "xhci-dbgcap.h"
 
-#define XHCI_MSG_MAX	500
-
 DECLARE_EVENT_CLASS(xhci_log_msg,
 	TP_PROTO(struct va_format *vaf),
 	TP_ARGS(vaf),
@@ -122,6 +120,7 @@ DECLARE_EVENT_CLASS(xhci_log_trb,
 		__field(u32, field1)
 		__field(u32, field2)
 		__field(u32, field3)
+		__dynamic_array(char, str, XHCI_MSG_MAX)
 	),
 	TP_fast_assign(
 		__entry->type = ring->type;
@@ -131,7 +130,7 @@ DECLARE_EVENT_CLASS(xhci_log_trb,
 		__entry->field3 = le32_to_cpu(trb->field[3]);
 	),
 	TP_printk("%s: %s", xhci_ring_type_string(__entry->type),
-			xhci_decode_trb(__entry->field0, __entry->field1,
+		  xhci_decode_trb(__get_str(str), XHCI_MSG_MAX, __entry->field0, __entry->field1,
 					__entry->field2, __entry->field3)
 	)
 );
@@ -323,6 +322,7 @@ DECLARE_EVENT_CLASS(xhci_log_ep_ctx,
 		__field(u32, info2)
 		__field(u64, deq)
 		__field(u32, tx_info)
+		__dynamic_array(char, str, XHCI_MSG_MAX)
 	),
 	TP_fast_assign(
 		__entry->info = le32_to_cpu(ctx->ep_info);
@@ -330,8 +330,8 @@ DECLARE_EVENT_CLASS(xhci_log_ep_ctx,
 		__entry->deq = le64_to_cpu(ctx->deq);
 		__entry->tx_info = le32_to_cpu(ctx->tx_info);
 	),
-	TP_printk("%s", xhci_decode_ep_context(__entry->info,
-		__entry->info2, __entry->deq, __entry->tx_info)
+	TP_printk("%s", xhci_decode_ep_context(__get_str(str),
+		__entry->info, __entry->info2, __entry->deq, __entry->tx_info)
 	)
 );
 
@@ -368,6 +368,7 @@ DECLARE_EVENT_CLASS(xhci_log_slot_ctx,
 		__field(u32, info2)
 		__field(u32, tt_info)
 		__field(u32, state)
+		__dynamic_array(char, str, XHCI_MSG_MAX)
 	),
 	TP_fast_assign(
 		__entry->info = le32_to_cpu(ctx->dev_info);
@@ -375,9 +376,9 @@ DECLARE_EVENT_CLASS(xhci_log_slot_ctx,
 		__entry->tt_info = le64_to_cpu(ctx->tt_info);
 		__entry->state = le32_to_cpu(ctx->dev_state);
 	),
-	TP_printk("%s", xhci_decode_slot_context(__entry->info,
-			__entry->info2, __entry->tt_info,
-			__entry->state)
+	TP_printk("%s", xhci_decode_slot_context(__get_str(str),
+			__entry->info, __entry->info2,
+			__entry->tt_info, __entry->state)
 	)
 );
 
@@ -432,12 +433,13 @@ DECLARE_EVENT_CLASS(xhci_log_ctrl_ctx,
 	TP_STRUCT__entry(
 		__field(u32, drop)
 		__field(u32, add)
+		__dynamic_array(char, str, XHCI_MSG_MAX)
 	),
 	TP_fast_assign(
 		__entry->drop = le32_to_cpu(ctrl_ctx->drop_flags);
 		__entry->add = le32_to_cpu(ctrl_ctx->add_flags);
 	),
-	TP_printk("%s", xhci_decode_ctrl_ctx(__entry->drop, __entry->add)
+	TP_printk("%s", xhci_decode_ctrl_ctx(__get_str(str), __entry->drop, __entry->add)
 	)
 );
 
@@ -523,6 +525,7 @@ DECLARE_EVENT_CLASS(xhci_log_portsc,
 		    TP_STRUCT__entry(
 				     __field(u32, portnum)
 				     __field(u32, portsc)
+				     __dynamic_array(char, str, XHCI_MSG_MAX)
 				     ),
 		    TP_fast_assign(
 				   __entry->portnum = portnum;
@@ -530,7 +533,7 @@ DECLARE_EVENT_CLASS(xhci_log_portsc,
 				   ),
 		    TP_printk("port-%d: %s",
 			      __entry->portnum,
-			      xhci_decode_portsc(__entry->portsc)
+			      xhci_decode_portsc(__get_str(str), __entry->portsc)
 			      )
 );
 
@@ -555,13 +558,14 @@ DECLARE_EVENT_CLASS(xhci_log_doorbell,
 	TP_STRUCT__entry(
 		__field(u32, slot)
 		__field(u32, doorbell)
+		__dynamic_array(char, str, XHCI_MSG_MAX)
 	),
 	TP_fast_assign(
 		__entry->slot = slot;
 		__entry->doorbell = doorbell;
 	),
 	TP_printk("Ring doorbell for %s",
-		xhci_decode_doorbell(__entry->slot, __entry->doorbell)
+		  xhci_decode_doorbell(__get_str(str), __entry->slot, __entry->doorbell)
 	)
 );
 
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index e417f5ce13d1..528cdac53269 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -22,6 +22,9 @@
 #include	"xhci-ext-caps.h"
 #include "pci-quirks.h"
 
+/* max buffer size for trace and debug messages */
+#define XHCI_MSG_MAX		500
+
 /* xHCI PCI Configuration Registers */
 #define XHCI_SBRN_OFFSET	(0x60)
 
@@ -2232,15 +2235,14 @@ static inline char *xhci_slot_state_string(u32 state)
 	}
 }
 
-static inline const char *xhci_decode_trb(u32 field0, u32 field1, u32 field2,
-		u32 field3)
+static inline const char *xhci_decode_trb(char *str, size_t size,
+					  u32 field0, u32 field1, u32 field2, u32 field3)
 {
-	static char str[256];
 	int type = TRB_FIELD_TO_TYPE(field3);
 
 	switch (type) {
 	case TRB_LINK:
-		sprintf(str,
+		snprintf(str, size,
 			"LINK %08x%08x intr %d type '%s' flags %c:%c:%c:%c",
 			field1, field0, GET_INTR_TARGET(field2),
 			xhci_trb_type_string(type),
@@ -2257,7 +2259,7 @@ static inline const char *xhci_decode_trb(u32 field0, u32 field1, u32 field2,
 	case TRB_HC_EVENT:
 	case TRB_DEV_NOTE:
 	case TRB_MFINDEX_WRAP:
-		sprintf(str,
+		snprintf(str, size,
 			"TRB %08x%08x status '%s' len %d slot %d ep %d type '%s' flags %c:%c",
 			field1, field0,
 			xhci_trb_comp_code_string(GET_COMP_CODE(field2)),
@@ -2270,7 +2272,8 @@ static inline const char *xhci_decode_trb(u32 field0, u32 field1, u32 field2,
 
 		break;
 	case TRB_SETUP:
-		sprintf(str, "bRequestType %02x bRequest %02x wValue %02x%02x wIndex %02x%02x wLength %d length %d TD size %d intr %d type '%s' flags %c:%c:%c",
+		snprintf(str, size,
+			"bRequestType %02x bRequest %02x wValue %02x%02x wIndex %02x%02x wLength %d length %d TD size %d intr %d type '%s' flags %c:%c:%c",
 				field0 & 0xff,
 				(field0 & 0xff00) >> 8,
 				(field0 & 0xff000000) >> 24,
@@ -2287,7 +2290,8 @@ static inline const char *xhci_decode_trb(u32 field0, u32 field1, u32 field2,
 				field3 & TRB_CYCLE ? 'C' : 'c');
 		break;
 	case TRB_DATA:
-		sprintf(str, "Buffer %08x%08x length %d TD size %d intr %d type '%s' flags %c:%c:%c:%c:%c:%c:%c",
+		snprintf(str, size,
+			 "Buffer %08x%08x length %d TD size %d intr %d type '%s' flags %c:%c:%c:%c:%c:%c:%c",
 				field1, field0, TRB_LEN(field2), GET_TD_SIZE(field2),
 				GET_INTR_TARGET(field2),
 				xhci_trb_type_string(type),
@@ -2300,7 +2304,8 @@ static inline const char *xhci_decode_trb(u32 field0, u32 field1, u32 field2,
 				field3 & TRB_CYCLE ? 'C' : 'c');
 		break;
 	case TRB_STATUS:
-		sprintf(str, "Buffer %08x%08x length %d TD size %d intr %d type '%s' flags %c:%c:%c:%c",
+		snprintf(str, size,
+			 "Buffer %08x%08x length %d TD size %d intr %d type '%s' flags %c:%c:%c:%c",
 				field1, field0, TRB_LEN(field2), GET_TD_SIZE(field2),
 				GET_INTR_TARGET(field2),
 				xhci_trb_type_string(type),
@@ -2313,7 +2318,7 @@ static inline const char *xhci_decode_trb(u32 field0, u32 field1, u32 field2,
 	case TRB_ISOC:
 	case TRB_EVENT_DATA:
 	case TRB_TR_NOOP:
-		sprintf(str,
+		snprintf(str, size,
 			"Buffer %08x%08x length %d TD size %d intr %d type '%s' flags %c:%c:%c:%c:%c:%c:%c:%c",
 			field1, field0, TRB_LEN(field2), GET_TD_SIZE(field2),
 			GET_INTR_TARGET(field2),
@@ -2330,21 +2335,21 @@ static inline const char *xhci_decode_trb(u32 field0, u32 field1, u32 field2,
 
 	case TRB_CMD_NOOP:
 	case TRB_ENABLE_SLOT:
-		sprintf(str,
+		snprintf(str, size,
 			"%s: flags %c",
 			xhci_trb_type_string(type),
 			field3 & TRB_CYCLE ? 'C' : 'c');
 		break;
 	case TRB_DISABLE_SLOT:
 	case TRB_NEG_BANDWIDTH:
-		sprintf(str,
+		snprintf(str, size,
 			"%s: slot %d flags %c",
 			xhci_trb_type_string(type),
 			TRB_TO_SLOT_ID(field3),
 			field3 & TRB_CYCLE ? 'C' : 'c');
 		break;
 	case TRB_ADDR_DEV:
-		sprintf(str,
+		snprintf(str, size,
 			"%s: ctx %08x%08x slot %d flags %c:%c",
 			xhci_trb_type_string(type),
 			field1, field0,
@@ -2353,7 +2358,7 @@ static inline const char *xhci_decode_trb(u32 field0, u32 field1, u32 field2,
 			field3 & TRB_CYCLE ? 'C' : 'c');
 		break;
 	case TRB_CONFIG_EP:
-		sprintf(str,
+		snprintf(str, size,
 			"%s: ctx %08x%08x slot %d flags %c:%c",
 			xhci_trb_type_string(type),
 			field1, field0,
@@ -2362,7 +2367,7 @@ static inline const char *xhci_decode_trb(u32 field0, u32 field1, u32 field2,
 			field3 & TRB_CYCLE ? 'C' : 'c');
 		break;
 	case TRB_EVAL_CONTEXT:
-		sprintf(str,
+		snprintf(str, size,
 			"%s: ctx %08x%08x slot %d flags %c",
 			xhci_trb_type_string(type),
 			field1, field0,
@@ -2370,7 +2375,7 @@ static inline const char *xhci_decode_trb(u32 field0, u32 field1, u32 field2,
 			field3 & TRB_CYCLE ? 'C' : 'c');
 		break;
 	case TRB_RESET_EP:
-		sprintf(str,
+		snprintf(str, size,
 			"%s: ctx %08x%08x slot %d ep %d flags %c:%c",
 			xhci_trb_type_string(type),
 			field1, field0,
@@ -2391,7 +2396,7 @@ static inline const char *xhci_decode_trb(u32 field0, u32 field1, u32 field2,
 			field3 & TRB_CYCLE ? 'C' : 'c');
 		break;
 	case TRB_SET_DEQ:
-		sprintf(str,
+		snprintf(str, size,
 			"%s: deq %08x%08x stream %d slot %d ep %d flags %c",
 			xhci_trb_type_string(type),
 			field1, field0,
@@ -2402,14 +2407,14 @@ static inline const char *xhci_decode_trb(u32 field0, u32 field1, u32 field2,
 			field3 & TRB_CYCLE ? 'C' : 'c');
 		break;
 	case TRB_RESET_DEV:
-		sprintf(str,
+		snprintf(str, size,
 			"%s: slot %d flags %c",
 			xhci_trb_type_string(type),
 			TRB_TO_SLOT_ID(field3),
 			field3 & TRB_CYCLE ? 'C' : 'c');
 		break;
 	case TRB_FORCE_EVENT:
-		sprintf(str,
+		snprintf(str, size,
 			"%s: event %08x%08x vf intr %d vf id %d flags %c",
 			xhci_trb_type_string(type),
 			field1, field0,
@@ -2418,14 +2423,14 @@ static inline const char *xhci_decode_trb(u32 field0, u32 field1, u32 field2,
 			field3 & TRB_CYCLE ? 'C' : 'c');
 		break;
 	case TRB_SET_LT:
-		sprintf(str,
+		snprintf(str, size,
 			"%s: belt %d flags %c",
 			xhci_trb_type_string(type),
 			TRB_TO_BELT(field3),
 			field3 & TRB_CYCLE ? 'C' : 'c');
 		break;
 	case TRB_GET_BW:
-		sprintf(str,
+		snprintf(str, size,
 			"%s: ctx %08x%08x slot %d speed %d flags %c",
 			xhci_trb_type_string(type),
 			field1, field0,
@@ -2434,7 +2439,7 @@ static inline const char *xhci_decode_trb(u32 field0, u32 field1, u32 field2,
 			field3 & TRB_CYCLE ? 'C' : 'c');
 		break;
 	case TRB_FORCE_HEADER:
-		sprintf(str,
+		snprintf(str, size,
 			"%s: info %08x%08x%08x pkt type %d roothub port %d flags %c",
 			xhci_trb_type_string(type),
 			field2, field1, field0 & 0xffffffe0,
@@ -2443,7 +2448,7 @@ static inline const char *xhci_decode_trb(u32 field0, u32 field1, u32 field2,
 			field3 & TRB_CYCLE ? 'C' : 'c');
 		break;
 	default:
-		sprintf(str,
+		snprintf(str, size,
 			"type '%s' -> raw %08x %08x %08x %08x",
 			xhci_trb_type_string(type),
 			field0, field1, field2, field3);
@@ -2452,10 +2457,9 @@ static inline const char *xhci_decode_trb(u32 field0, u32 field1, u32 field2,
 	return str;
 }
 
-static inline const char *xhci_decode_ctrl_ctx(unsigned long drop,
-					       unsigned long add)
+static inline const char *xhci_decode_ctrl_ctx(char *str,
+		unsigned long drop, unsigned long add)
 {
-	static char	str[1024];
 	unsigned int	bit;
 	int		ret = 0;
 
@@ -2481,10 +2485,9 @@ static inline const char *xhci_decode_ctrl_ctx(unsigned long drop,
 	return str;
 }
 
-static inline const char *xhci_decode_slot_context(u32 info, u32 info2,
-		u32 tt_info, u32 state)
+static inline const char *xhci_decode_slot_context(char *str,
+		u32 info, u32 info2, u32 tt_info, u32 state)
 {
-	static char str[1024];
 	u32 speed;
 	u32 hub;
 	u32 mtt;
@@ -2568,9 +2571,8 @@ static inline const char *xhci_portsc_link_state_string(u32 portsc)
 	return "Unknown";
 }
 
-static inline const char *xhci_decode_portsc(u32 portsc)
+static inline const char *xhci_decode_portsc(char *str, u32 portsc)
 {
-	static char str[256];
 	int ret;
 
 	ret = sprintf(str, "%s %s %s Link:%s PortSpeed:%d ",
@@ -2614,9 +2616,8 @@ static inline const char *xhci_decode_portsc(u32 portsc)
 	return str;
 }
 
-static inline const char *xhci_decode_usbsts(u32 usbsts)
+static inline const char *xhci_decode_usbsts(char *str, u32 usbsts)
 {
-	static char str[256];
 	int ret = 0;
 
 	if (usbsts == ~(u32)0)
@@ -2643,9 +2644,8 @@ static inline const char *xhci_decode_usbsts(u32 usbsts)
 	return str;
 }
 
-static inline const char *xhci_decode_doorbell(u32 slot, u32 doorbell)
+static inline const char *xhci_decode_doorbell(char *str, u32 slot, u32 doorbell)
 {
-	static char str[256];
 	u8 ep;
 	u16 stream;
 	int ret;
@@ -2712,10 +2712,9 @@ static inline const char *xhci_ep_type_string(u8 type)
 	}
 }
 
-static inline const char *xhci_decode_ep_context(u32 info, u32 info2, u64 deq,
-		u32 tx_info)
+static inline const char *xhci_decode_ep_context(char *str, u32 info,
+		u32 info2, u64 deq, u32 tx_info)
 {
-	static char str[1024];
 	int ret;
 
 	u32 esit;
diff --git a/drivers/usb/mtu3/mtu3_core.c b/drivers/usb/mtu3/mtu3_core.c
index b3b459937566..3d328dfdbb5e 100644
--- a/drivers/usb/mtu3/mtu3_core.c
+++ b/drivers/usb/mtu3/mtu3_core.c
@@ -227,11 +227,13 @@ void mtu3_set_speed(struct mtu3 *mtu, enum usb_device_speed speed)
 		mtu3_setbits(mbase, U3D_POWER_MANAGEMENT, HS_ENABLE);
 		break;
 	case USB_SPEED_SUPER:
+		mtu3_setbits(mbase, U3D_POWER_MANAGEMENT, HS_ENABLE);
 		mtu3_clrbits(mtu->ippc_base, SSUSB_U3_CTRL(0),
 			     SSUSB_U3_PORT_SSP_SPEED);
 		break;
 	case USB_SPEED_SUPER_PLUS:
-			mtu3_setbits(mtu->ippc_base, SSUSB_U3_CTRL(0),
+		mtu3_setbits(mbase, U3D_POWER_MANAGEMENT, HS_ENABLE);
+		mtu3_setbits(mtu->ippc_base, SSUSB_U3_CTRL(0),
 			     SSUSB_U3_PORT_SSP_SPEED);
 		break;
 	default:
diff --git a/drivers/usb/mtu3/mtu3_gadget.c b/drivers/usb/mtu3/mtu3_gadget.c
index 38f17d66d5bc..0b3aa7c65857 100644
--- a/drivers/usb/mtu3/mtu3_gadget.c
+++ b/drivers/usb/mtu3/mtu3_gadget.c
@@ -64,14 +64,12 @@ static int mtu3_ep_enable(struct mtu3_ep *mep)
 	u32 interval = 0;
 	u32 mult = 0;
 	u32 burst = 0;
-	int max_packet;
 	int ret;
 
 	desc = mep->desc;
 	comp_desc = mep->comp_desc;
 	mep->type = usb_endpoint_type(desc);
-	max_packet = usb_endpoint_maxp(desc);
-	mep->maxp = max_packet & GENMASK(10, 0);
+	mep->maxp = usb_endpoint_maxp(desc);
 
 	switch (mtu->g.speed) {
 	case USB_SPEED_SUPER:
@@ -92,7 +90,7 @@ static int mtu3_ep_enable(struct mtu3_ep *mep)
 				usb_endpoint_xfer_int(desc)) {
 			interval = desc->bInterval;
 			interval = clamp_val(interval, 1, 16) - 1;
-			burst = (max_packet & GENMASK(12, 11)) >> 11;
+			mult = usb_endpoint_maxp_mult(desc) - 1;
 		}
 		break;
 	default:
diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index 00576bae183d..0c321996c6eb 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -2720,6 +2720,7 @@ int ip_check_mc_rcu(struct in_device *in_dev, __be32 mc_addr, __be32 src_addr, u
 		rv = 1;
 	} else if (im) {
 		if (src_addr) {
+			spin_lock_bh(&im->lock);
 			for (psf = im->sources; psf; psf = psf->sf_next) {
 				if (psf->sf_inaddr == src_addr)
 					break;
@@ -2730,6 +2731,7 @@ int ip_check_mc_rcu(struct in_device *in_dev, __be32 mc_addr, __be32 src_addr, u
 					im->sfcount[MCAST_EXCLUDE];
 			else
 				rv = im->sfcount[MCAST_EXCLUDE] != 0;
+			spin_unlock_bh(&im->lock);
 		} else
 			rv = 1; /* unspecified source; tentatively allow */
 	}
diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 326d1b0ea5e6..db65f77eb131 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1898,6 +1898,7 @@ static const struct registration_quirk registration_quirks[] = {
 	REG_QUIRK_ENTRY(0x0951, 0x16ed, 2),	/* Kingston HyperX Cloud Alpha S */
 	REG_QUIRK_ENTRY(0x0951, 0x16ea, 2),	/* Kingston HyperX Cloud Flight S */
 	REG_QUIRK_ENTRY(0x0ecb, 0x1f46, 2),	/* JBL Quantum 600 */
+	REG_QUIRK_ENTRY(0x0ecb, 0x1f47, 2),	/* JBL Quantum 800 */
 	REG_QUIRK_ENTRY(0x0ecb, 0x2039, 2),	/* JBL Quantum 400 */
 	REG_QUIRK_ENTRY(0x0ecb, 0x203c, 2),	/* JBL Quantum 600 */
 	REG_QUIRK_ENTRY(0x0ecb, 0x203e, 2),	/* JBL Quantum 800 */
