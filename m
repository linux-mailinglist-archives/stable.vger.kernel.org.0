Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA0C6790D7
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 07:28:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233277AbjAXG2y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 01:28:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233309AbjAXG2t (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 01:28:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1688D3B3CF;
        Mon, 23 Jan 2023 22:28:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F7DB611F8;
        Tue, 24 Jan 2023 06:28:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AC17C433D2;
        Tue, 24 Jan 2023 06:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674541721;
        bh=fGxCEhv0JZB6zrUDokx8biDa+M8ajI1J8ySrN+kPrBA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x4Qdf4eOlVJUinKheXn4N0eJuSZze6mJj0o3KABwa+cm26EVUykRiIFmvH6c4vgQi
         zaSZt9A1mXIK3HwhOvPxwKonfdW5lNlRJBwF6Yghev+ku/bPSiiCwSAGX9QW5RoM0V
         4PaI3oxTBIRIt8khFkCzRMsoFgl+P2kG7NIjyr2M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.19.271
Date:   Tue, 24 Jan 2023 07:28:33 +0100
Message-Id: <16745417126036@kroah.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <1674541712176110@kroah.com>
References: <1674541712176110@kroah.com>
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
index 11c68e88776a..560507d1f7a1 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 19
-SUBLEVEL = 270
+SUBLEVEL = 271
 EXTRAVERSION =
 NAME = "People's Front"
 
diff --git a/arch/x86/kernel/fpu/init.c b/arch/x86/kernel/fpu/init.c
index 9692ccc583bb..a3a570df6be1 100644
--- a/arch/x86/kernel/fpu/init.c
+++ b/arch/x86/kernel/fpu/init.c
@@ -138,9 +138,6 @@ static void __init fpu__init_system_generic(void)
 unsigned int fpu_kernel_xstate_size;
 EXPORT_SYMBOL_GPL(fpu_kernel_xstate_size);
 
-/* Get alignment of the TYPE. */
-#define TYPE_ALIGN(TYPE) offsetof(struct { char x; TYPE test; }, test)
-
 /*
  * Enforce that 'MEMBER' is the last field of 'TYPE'.
  *
@@ -148,8 +145,8 @@ EXPORT_SYMBOL_GPL(fpu_kernel_xstate_size);
  * because that's how C aligns structs.
  */
 #define CHECK_MEMBER_AT_END_OF(TYPE, MEMBER) \
-	BUILD_BUG_ON(sizeof(TYPE) != ALIGN(offsetofend(TYPE, MEMBER), \
-					   TYPE_ALIGN(TYPE)))
+	BUILD_BUG_ON(sizeof(TYPE) !=         \
+		     ALIGN(offsetofend(TYPE, MEMBER), _Alignof(TYPE)))
 
 /*
  * We append the 'struct fpu' to the task_struct:
diff --git a/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c b/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
index c05ef7f1d7b6..99a40385267c 100644
--- a/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
+++ b/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
@@ -551,6 +551,11 @@ static noinline void axi_chan_handle_err(struct axi_dma_chan *chan, u32 status)
 
 	/* The bad descriptor currently is in the head of vc list */
 	vd = vchan_next_desc(&chan->vc);
+	if (!vd) {
+		dev_err(chan2dev(chan), "BUG: %s, IRQ with no descriptors\n",
+			axi_chan_name(chan));
+		goto out;
+	}
 	/* Remove the completed descriptor from issued list */
 	list_del(&vd->node);
 
@@ -565,6 +570,7 @@ static noinline void axi_chan_handle_err(struct axi_dma_chan *chan, u32 status)
 	/* Try to restart the controller */
 	axi_chan_start_first_queued(chan);
 
+out:
 	spin_unlock_irqrestore(&chan->vc.lock, flags);
 }
 
diff --git a/drivers/firmware/google/gsmi.c b/drivers/firmware/google/gsmi.c
index 2e3ef0eb6e82..e50dd4030d90 100644
--- a/drivers/firmware/google/gsmi.c
+++ b/drivers/firmware/google/gsmi.c
@@ -343,9 +343,10 @@ static efi_status_t gsmi_get_variable(efi_char16_t *name,
 		memcpy(data, gsmi_dev.data_buf->start, *data_size);
 
 		/* All variables are have the following attributes */
-		*attr = EFI_VARIABLE_NON_VOLATILE |
-			EFI_VARIABLE_BOOTSERVICE_ACCESS |
-			EFI_VARIABLE_RUNTIME_ACCESS;
+		if (attr)
+			*attr = EFI_VARIABLE_NON_VOLATILE |
+				EFI_VARIABLE_BOOTSERVICE_ACCESS |
+				EFI_VARIABLE_RUNTIME_ACCESS;
 	}
 
 	spin_unlock_irqrestore(&gsmi_dev.lock, flags);
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index a2706086b9c7..10cb50b90d7f 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -63,12 +63,14 @@ enum {
 	SRP_DEFAULT_CMD_SQ_SIZE = SRP_DEFAULT_QUEUE_SIZE - SRP_RSP_SQ_SIZE -
 				  SRP_TSK_MGMT_SQ_SIZE,
 
-	SRP_TAG_NO_REQ		= ~0U,
-	SRP_TAG_TSK_MGMT	= 1U << 31,
-
 	SRP_MAX_PAGES_PER_MR	= 512,
 };
 
+enum {
+	SRP_TAG_NO_REQ		= ~0U,
+	SRP_TAG_TSK_MGMT	= BIT(31),
+};
+
 enum srp_target_state {
 	SRP_TARGET_SCANNING,
 	SRP_TARGET_LIVE,
diff --git a/drivers/mmc/host/sunxi-mmc.c b/drivers/mmc/host/sunxi-mmc.c
index c4584184525f..757eb175611f 100644
--- a/drivers/mmc/host/sunxi-mmc.c
+++ b/drivers/mmc/host/sunxi-mmc.c
@@ -1441,9 +1441,11 @@ static int sunxi_mmc_remove(struct platform_device *pdev)
 	struct sunxi_mmc_host *host = mmc_priv(mmc);
 
 	mmc_remove_host(mmc);
-	pm_runtime_force_suspend(&pdev->dev);
-	disable_irq(host->irq);
-	sunxi_mmc_disable(host);
+	pm_runtime_disable(&pdev->dev);
+	if (!pm_runtime_status_suspended(&pdev->dev)) {
+		disable_irq(host->irq);
+		sunxi_mmc_disable(host);
+	}
 	dma_free_coherent(&pdev->dev, PAGE_SIZE, host->sg_cpu, host->sg_dma);
 	mmc_free_host(mmc);
 
diff --git a/drivers/staging/comedi/drivers/adv_pci1760.c b/drivers/staging/comedi/drivers/adv_pci1760.c
index f460f21efb90..0f6faf263c82 100644
--- a/drivers/staging/comedi/drivers/adv_pci1760.c
+++ b/drivers/staging/comedi/drivers/adv_pci1760.c
@@ -59,7 +59,7 @@
 #define PCI1760_CMD_CLR_IMB2		0x00	/* Clears IMB2 */
 #define PCI1760_CMD_SET_DO		0x01	/* Set output state */
 #define PCI1760_CMD_GET_DO		0x02	/* Read output status */
-#define PCI1760_CMD_GET_STATUS		0x03	/* Read current status */
+#define PCI1760_CMD_GET_STATUS		0x07	/* Read current status */
 #define PCI1760_CMD_GET_FW_VER		0x0e	/* Read firmware version */
 #define PCI1760_CMD_GET_HW_VER		0x0f	/* Read hardware version */
 #define PCI1760_CMD_SET_PWM_HI(x)	(0x10 + (x) * 2) /* Set "hi" period */
diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
index 3ba9ed36d636..50c4058a00e6 100644
--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -2511,13 +2511,7 @@ static void __init atmel_console_get_options(struct uart_port *port, int *baud,
 	else if (mr == ATMEL_US_PAR_ODD)
 		*parity = 'o';
 
-	/*
-	 * The serial core only rounds down when matching this to a
-	 * supported baud rate. Make sure we don't end up slightly
-	 * lower than one of those, as it would make us fall through
-	 * to a much lower baud rate than we really want.
-	 */
-	*baud = port->uartclk / (16 * (quot - 1));
+	*baud = port->uartclk / (16 * quot);
 }
 
 static int __init atmel_console_setup(struct console *co, char *options)
diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index 447990006d68..4b035d61b280 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -792,7 +792,7 @@ static void pch_dma_tx_complete(void *arg)
 	}
 	xmit->tail &= UART_XMIT_SIZE - 1;
 	async_tx_ack(priv->desc_tx);
-	dma_unmap_sg(port->dev, sg, priv->orig_nent, DMA_TO_DEVICE);
+	dma_unmap_sg(port->dev, priv->sg_tx_p, priv->orig_nent, DMA_TO_DEVICE);
 	priv->tx_dma_use = 0;
 	priv->nent = 0;
 	priv->orig_nent = 0;
diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index d1a7f22cb3a9..af9fe76745c3 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -40,6 +40,9 @@
 #define USB_PRODUCT_USB5534B			0x5534
 #define USB_VENDOR_CYPRESS			0x04b4
 #define USB_PRODUCT_CY7C65632			0x6570
+#define USB_VENDOR_TEXAS_INSTRUMENTS		0x0451
+#define USB_PRODUCT_TUSB8041_USB3		0x8140
+#define USB_PRODUCT_TUSB8041_USB2		0x8142
 #define HUB_QUIRK_CHECK_PORT_AUTOSUSPEND	0x01
 #define HUB_QUIRK_DISABLE_AUTOSUSPEND		0x02
 
@@ -5515,6 +5518,16 @@ static const struct usb_device_id hub_id_table[] = {
       .idVendor = USB_VENDOR_GENESYS_LOGIC,
       .bInterfaceClass = USB_CLASS_HUB,
       .driver_info = HUB_QUIRK_CHECK_PORT_AUTOSUSPEND},
+    { .match_flags = USB_DEVICE_ID_MATCH_VENDOR
+			| USB_DEVICE_ID_MATCH_PRODUCT,
+      .idVendor = USB_VENDOR_TEXAS_INSTRUMENTS,
+      .idProduct = USB_PRODUCT_TUSB8041_USB2,
+      .driver_info = HUB_QUIRK_DISABLE_AUTOSUSPEND},
+    { .match_flags = USB_DEVICE_ID_MATCH_VENDOR
+			| USB_DEVICE_ID_MATCH_PRODUCT,
+      .idVendor = USB_VENDOR_TEXAS_INSTRUMENTS,
+      .idProduct = USB_PRODUCT_TUSB8041_USB3,
+      .driver_info = HUB_QUIRK_DISABLE_AUTOSUSPEND},
     { .match_flags = USB_DEVICE_ID_MATCH_DEV_CLASS,
       .bDeviceClass = USB_CLASS_HUB},
     { .match_flags = USB_DEVICE_ID_MATCH_INT_CLASS,
diff --git a/drivers/usb/gadget/function/f_ncm.c b/drivers/usb/gadget/function/f_ncm.c
index 10b4612df8a7..d01fd211566e 100644
--- a/drivers/usb/gadget/function/f_ncm.c
+++ b/drivers/usb/gadget/function/f_ncm.c
@@ -86,7 +86,9 @@ static inline struct f_ncm *func_to_ncm(struct usb_function *f)
 /* peak (theoretical) bulk transfer rate in bits-per-second */
 static inline unsigned ncm_bitrate(struct usb_gadget *g)
 {
-	if (gadget_is_superspeed(g) && g->speed >= USB_SPEED_SUPER_PLUS)
+	if (!g)
+		return 0;
+	else if (gadget_is_superspeed(g) && g->speed >= USB_SPEED_SUPER_PLUS)
 		return 4250000000U;
 	else if (gadget_is_superspeed(g) && g->speed == USB_SPEED_SUPER)
 		return 3750000000U;
diff --git a/drivers/usb/gadget/legacy/webcam.c b/drivers/usb/gadget/legacy/webcam.c
index a9f8eb8e1c76..0d44d3103d14 100644
--- a/drivers/usb/gadget/legacy/webcam.c
+++ b/drivers/usb/gadget/legacy/webcam.c
@@ -292,6 +292,7 @@ static const struct uvc_descriptor_header * const uvc_fs_streaming_cls[] = {
 	(const struct uvc_descriptor_header *) &uvc_format_yuv,
 	(const struct uvc_descriptor_header *) &uvc_frame_yuv_360p,
 	(const struct uvc_descriptor_header *) &uvc_frame_yuv_720p,
+	(const struct uvc_descriptor_header *) &uvc_color_matching,
 	(const struct uvc_descriptor_header *) &uvc_format_mjpg,
 	(const struct uvc_descriptor_header *) &uvc_frame_mjpg_360p,
 	(const struct uvc_descriptor_header *) &uvc_frame_mjpg_720p,
@@ -304,6 +305,7 @@ static const struct uvc_descriptor_header * const uvc_hs_streaming_cls[] = {
 	(const struct uvc_descriptor_header *) &uvc_format_yuv,
 	(const struct uvc_descriptor_header *) &uvc_frame_yuv_360p,
 	(const struct uvc_descriptor_header *) &uvc_frame_yuv_720p,
+	(const struct uvc_descriptor_header *) &uvc_color_matching,
 	(const struct uvc_descriptor_header *) &uvc_format_mjpg,
 	(const struct uvc_descriptor_header *) &uvc_frame_mjpg_360p,
 	(const struct uvc_descriptor_header *) &uvc_frame_mjpg_720p,
@@ -316,6 +318,7 @@ static const struct uvc_descriptor_header * const uvc_ss_streaming_cls[] = {
 	(const struct uvc_descriptor_header *) &uvc_format_yuv,
 	(const struct uvc_descriptor_header *) &uvc_frame_yuv_360p,
 	(const struct uvc_descriptor_header *) &uvc_frame_yuv_720p,
+	(const struct uvc_descriptor_header *) &uvc_color_matching,
 	(const struct uvc_descriptor_header *) &uvc_format_mjpg,
 	(const struct uvc_descriptor_header *) &uvc_frame_mjpg_360p,
 	(const struct uvc_descriptor_header *) &uvc_frame_mjpg_720p,
diff --git a/drivers/usb/host/ehci-fsl.c b/drivers/usb/host/ehci-fsl.c
index 0a9fd2022acf..768f8a93f19e 100644
--- a/drivers/usb/host/ehci-fsl.c
+++ b/drivers/usb/host/ehci-fsl.c
@@ -28,7 +28,7 @@
 #include "ehci-fsl.h"
 
 #define DRIVER_DESC "Freescale EHCI Host controller driver"
-#define DRV_NAME "ehci-fsl"
+#define DRV_NAME "fsl-ehci"
 
 static struct hc_driver __read_mostly fsl_ehci_hc_driver;
 
diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 7f640603b103..55bd97029017 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -378,6 +378,8 @@ static int xhci_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	/* USB-2 and USB-3 roothubs initialized, allow runtime pm suspend */
 	pm_runtime_put_noidle(&dev->dev);
 
+	dma_set_max_seg_size(&dev->dev, UINT_MAX);
+
 	return 0;
 
 put_usb3_hcd:
diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index e18b675fb7af..aa4c5b43fb78 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -896,7 +896,10 @@ static void xhci_kill_endpoint_urbs(struct xhci_hcd *xhci,
 	struct xhci_virt_ep *ep;
 	struct xhci_ring *ring;
 
-	ep = &xhci->devs[slot_id]->eps[ep_index];
+	ep = xhci_get_virt_ep(xhci, slot_id, ep_index);
+	if (!ep)
+		return;
+
 	if ((ep->ep_state & EP_HAS_STREAMS) ||
 			(ep->ep_state & EP_GETTING_NO_STREAMS)) {
 		int stream_id;
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 3a1ed63d7334..13c10ebde296 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -3830,6 +3830,7 @@ static void xhci_free_dev(struct usb_hcd *hcd, struct usb_device *udev)
 	struct xhci_hcd *xhci = hcd_to_xhci(hcd);
 	struct xhci_virt_device *virt_dev;
 	struct xhci_slot_ctx *slot_ctx;
+	unsigned long flags;
 	int i, ret;
 
 	/*
@@ -3859,7 +3860,11 @@ static void xhci_free_dev(struct usb_hcd *hcd, struct usb_device *udev)
 	xhci_debugfs_remove_slot(xhci, udev->slot_id);
 	virt_dev->udev = NULL;
 	xhci_disable_slot(xhci, udev->slot_id);
+
+	spin_lock_irqsave(&xhci->lock, flags);
 	xhci_free_virt_device(xhci, udev->slot_id);
+	spin_unlock_irqrestore(&xhci->lock, flags);
+
 }
 
 int xhci_disable_slot(struct xhci_hcd *xhci, u32 slot_id)
@@ -4912,6 +4917,7 @@ static int xhci_enable_usb3_lpm_timeout(struct usb_hcd *hcd,
 			struct usb_device *udev, enum usb3_link_state state)
 {
 	struct xhci_hcd	*xhci;
+	struct xhci_port *port;
 	u16 hub_encoded_timeout;
 	int mel;
 	int ret;
@@ -4925,6 +4931,13 @@ static int xhci_enable_usb3_lpm_timeout(struct usb_hcd *hcd,
 			!xhci->devs[udev->slot_id])
 		return USB3_LPM_DISABLED;
 
+	/* If connected to root port then check port can handle lpm */
+	if (udev->parent && !udev->parent->parent) {
+		port = xhci->usb3_rhub.ports[udev->portnum - 1];
+		if (port->lpm_incapable)
+			return USB3_LPM_DISABLED;
+	}
+
 	hub_encoded_timeout = xhci_calculate_lpm_timeout(hcd, udev, state);
 	mel = calculate_max_exit_latency(udev, state, hub_encoded_timeout);
 	if (mel < 0) {
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 029ffcb13d62..f2bf3431cd6f 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1723,6 +1723,7 @@ struct xhci_port {
 	int			hcd_portnum;
 	struct xhci_hub		*rhub;
 	struct xhci_port_cap	*port_cap;
+	unsigned int		lpm_incapable:1;
 };
 
 struct xhci_hub {
diff --git a/drivers/usb/misc/iowarrior.c b/drivers/usb/misc/iowarrior.c
index 07d6bc63be96..8b04d2705920 100644
--- a/drivers/usb/misc/iowarrior.c
+++ b/drivers/usb/misc/iowarrior.c
@@ -832,7 +832,7 @@ static int iowarrior_probe(struct usb_interface *interface,
 			break;
 
 		case USB_DEVICE_ID_CODEMERCS_IOW100:
-			dev->report_size = 13;
+			dev->report_size = 12;
 			break;
 		}
 	}
diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index f1acc6f686a9..7932a65324d2 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -61,6 +61,7 @@ static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x0846, 0x1100) }, /* NetGear Managed Switch M4100 series, M5300 series, M7100 series */
 	{ USB_DEVICE(0x08e6, 0x5501) }, /* Gemalto Prox-PU/CU contactless smartcard reader */
 	{ USB_DEVICE(0x08FD, 0x000A) }, /* Digianswer A/S , ZigBee/802.15.4 MAC Device */
+	{ USB_DEVICE(0x0908, 0x0070) }, /* Siemens SCALANCE LPE-9000 USB Serial Console */
 	{ USB_DEVICE(0x0908, 0x01FF) }, /* Siemens RUGGEDCOM USB Serial Console */
 	{ USB_DEVICE(0x0988, 0x0578) }, /* Teraoka AD2000 */
 	{ USB_DEVICE(0x0B00, 0x3070) }, /* Ingenico 3070 */
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 57bef990382b..48b66656dca8 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -255,10 +255,16 @@ static void option_instat_callback(struct urb *urb);
 #define QUECTEL_PRODUCT_EP06			0x0306
 #define QUECTEL_PRODUCT_EM05G			0x030a
 #define QUECTEL_PRODUCT_EM060K			0x030b
+#define QUECTEL_PRODUCT_EM05G_CS		0x030c
+#define QUECTEL_PRODUCT_EM05CN_SG		0x0310
 #define QUECTEL_PRODUCT_EM05G_SG		0x0311
+#define QUECTEL_PRODUCT_EM05CN			0x0312
+#define QUECTEL_PRODUCT_EM05G_GR		0x0313
+#define QUECTEL_PRODUCT_EM05G_RS		0x0314
 #define QUECTEL_PRODUCT_EM12			0x0512
 #define QUECTEL_PRODUCT_RM500Q			0x0800
 #define QUECTEL_PRODUCT_RM520N			0x0801
+#define QUECTEL_PRODUCT_EC200U			0x0901
 #define QUECTEL_PRODUCT_EC200S_CN		0x6002
 #define QUECTEL_PRODUCT_EC200T			0x6026
 #define QUECTEL_PRODUCT_RM500K			0x7001
@@ -1159,8 +1165,18 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EP06, 0xff, 0xff, 0xff),
 	  .driver_info = RSVD(1) | RSVD(2) | RSVD(3) | RSVD(4) | NUMEP2 },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EP06, 0xff, 0, 0) },
+	{ USB_DEVICE_INTERFACE_CLASS(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EM05CN, 0xff),
+	  .driver_info = RSVD(6) | ZLP },
+	{ USB_DEVICE_INTERFACE_CLASS(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EM05CN_SG, 0xff),
+	  .driver_info = RSVD(6) | ZLP },
 	{ USB_DEVICE_INTERFACE_CLASS(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EM05G, 0xff),
 	  .driver_info = RSVD(6) | ZLP },
+	{ USB_DEVICE_INTERFACE_CLASS(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EM05G_GR, 0xff),
+	  .driver_info = RSVD(6) | ZLP },
+	{ USB_DEVICE_INTERFACE_CLASS(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EM05G_CS, 0xff),
+	  .driver_info = RSVD(6) | ZLP },
+	{ USB_DEVICE_INTERFACE_CLASS(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EM05G_RS, 0xff),
+	  .driver_info = RSVD(6) | ZLP },
 	{ USB_DEVICE_INTERFACE_CLASS(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EM05G_SG, 0xff),
 	  .driver_info = RSVD(6) | ZLP },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EM060K, 0xff, 0x00, 0x40) },
@@ -1180,6 +1196,7 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_RM520N, 0xff, 0xff, 0x30) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_RM520N, 0xff, 0, 0x40) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_RM520N, 0xff, 0, 0) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EC200U, 0xff, 0, 0) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EC200S_CN, 0xff, 0, 0) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EC200T, 0xff, 0, 0) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_RM500K, 0xff, 0x00, 0x00) },
diff --git a/drivers/usb/storage/uas-detect.h b/drivers/usb/storage/uas-detect.h
index 3734a25e09e5..44f0b78be8a9 100644
--- a/drivers/usb/storage/uas-detect.h
+++ b/drivers/usb/storage/uas-detect.h
@@ -116,6 +116,19 @@ static int uas_use_uas_driver(struct usb_interface *intf,
 	if (le16_to_cpu(udev->descriptor.idVendor) == 0x0bc2)
 		flags |= US_FL_NO_ATA_1X;
 
+	/*
+	 * RTL9210-based enclosure from HIKSEMI, MD202 reportedly have issues
+	 * with UAS.  This isn't distinguishable with just idVendor and
+	 * idProduct, use manufacturer and product too.
+	 *
+	 * Reported-by: Hongling Zeng <zenghongling@kylinos.cn>
+	 */
+	if (le16_to_cpu(udev->descriptor.idVendor) == 0x0bda &&
+			le16_to_cpu(udev->descriptor.idProduct) == 0x9210 &&
+			(udev->manufacturer && !strcmp(udev->manufacturer, "HIKSEMI")) &&
+			(udev->product && !strcmp(udev->product, "MD202")))
+		flags |= US_FL_IGNORE_UAS;
+
 	usb_stor_adjust_quirks(udev, &flags);
 
 	if (flags & US_FL_IGNORE_UAS) {
diff --git a/drivers/usb/storage/unusual_uas.h b/drivers/usb/storage/unusual_uas.h
index 92e9bd006622..d4fa29b623ff 100644
--- a/drivers/usb/storage/unusual_uas.h
+++ b/drivers/usb/storage/unusual_uas.h
@@ -83,13 +83,6 @@ UNUSUAL_DEV(0x0bc2, 0x331a, 0x0000, 0x9999,
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_NO_REPORT_LUNS),
 
-/* Reported-by: Hongling Zeng <zenghongling@kylinos.cn> */
-UNUSUAL_DEV(0x0bda, 0x9210, 0x0000, 0x9999,
-		"Hiksemi",
-		"External HDD",
-		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
-		US_FL_IGNORE_UAS),
-
 /* Reported-by: Benjamin Tissoires <benjamin.tissoires@redhat.com> */
 UNUSUAL_DEV(0x13fd, 0x3940, 0x0000, 0x9999,
 		"Initio Corporation",
diff --git a/drivers/usb/typec/altmodes/displayport.c b/drivers/usb/typec/altmodes/displayport.c
index 52cdc06e1dea..2ae3fab36a80 100644
--- a/drivers/usb/typec/altmodes/displayport.c
+++ b/drivers/usb/typec/altmodes/displayport.c
@@ -411,6 +411,18 @@ static const char * const pin_assignments[] = {
 	[DP_PIN_ASSIGN_F] = "F",
 };
 
+/*
+ * Helper function to extract a peripheral's currently supported
+ * Pin Assignments from its DisplayPort alternate mode state.
+ */
+static u8 get_current_pin_assignments(struct dp_altmode *dp)
+{
+	if (DP_CONF_CURRENTLY(dp->data.conf) == DP_CONF_DFP_D)
+		return DP_CAP_PIN_ASSIGN_DFP_D(dp->alt->vdo);
+	else
+		return DP_CAP_PIN_ASSIGN_UFP_D(dp->alt->vdo);
+}
+
 static ssize_t
 pin_assignment_store(struct device *dev, struct device_attribute *attr,
 		     const char *buf, size_t size)
@@ -437,10 +449,7 @@ pin_assignment_store(struct device *dev, struct device_attribute *attr,
 		goto out_unlock;
 	}
 
-	if (DP_CONF_CURRENTLY(dp->data.conf) == DP_CONF_DFP_D)
-		assignments = DP_CAP_UFP_D_PIN_ASSIGN(dp->alt->vdo);
-	else
-		assignments = DP_CAP_DFP_D_PIN_ASSIGN(dp->alt->vdo);
+	assignments = get_current_pin_assignments(dp);
 
 	if (!(DP_CONF_GET_PIN_ASSIGN(conf) & assignments)) {
 		ret = -EINVAL;
@@ -477,10 +486,7 @@ static ssize_t pin_assignment_show(struct device *dev,
 
 	cur = get_count_order(DP_CONF_GET_PIN_ASSIGN(dp->data.conf));
 
-	if (DP_CONF_CURRENTLY(dp->data.conf) == DP_CONF_DFP_D)
-		assignments = DP_CAP_UFP_D_PIN_ASSIGN(dp->alt->vdo);
-	else
-		assignments = DP_CAP_DFP_D_PIN_ASSIGN(dp->alt->vdo);
+	assignments = get_current_pin_assignments(dp);
 
 	for (i = 0; assignments; assignments >>= 1, i++) {
 		if (assignments & 1) {
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 3485b9bf970f..50c6405befc4 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -3152,12 +3152,15 @@ smb2_readv_callback(struct mid_q_entry *mid)
 				(struct smb2_sync_hdr *)rdata->iov[0].iov_base;
 	unsigned int credits_received = 0;
 	struct smb_rqst rqst = { .rq_iov = &rdata->iov[1],
-				 .rq_nvec = 1,
-				 .rq_pages = rdata->pages,
-				 .rq_offset = rdata->page_offset,
-				 .rq_npages = rdata->nr_pages,
-				 .rq_pagesz = rdata->pagesz,
-				 .rq_tailsz = rdata->tailsz };
+				 .rq_nvec = 1, };
+
+	if (rdata->got_bytes) {
+		rqst.rq_pages = rdata->pages;
+		rqst.rq_offset = rdata->page_offset;
+		rqst.rq_npages = rdata->nr_pages;
+		rqst.rq_pagesz = rdata->pagesz;
+		rqst.rq_tailsz = rdata->tailsz;
+	}
 
 	cifs_dbg(FYI, "%s: mid=%llu state=%d result=%d bytes=%u\n",
 		 __func__, mid->mid, mid->mid_state, rdata->result,
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index d8068c0e547d..e58b162ad5d6 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1041,9 +1041,6 @@ struct ext4_inode_info {
 	ext4_lblk_t i_da_metadata_calc_last_lblock;
 	int i_da_metadata_calc_len;
 
-	/* pending cluster reservations for bigalloc file systems */
-	struct ext4_pending_tree i_pending_tree;
-
 	/* on-disk additional length */
 	__u16 i_extra_isize;
 
@@ -3231,6 +3228,10 @@ extern struct ext4_ext_path *ext4_find_extent(struct inode *, ext4_lblk_t,
 					      int flags);
 extern void ext4_ext_drop_refs(struct ext4_ext_path *);
 extern int ext4_ext_check_inode(struct inode *inode);
+extern int ext4_find_delalloc_range(struct inode *inode,
+				    ext4_lblk_t lblk_start,
+				    ext4_lblk_t lblk_end);
+extern int ext4_find_delalloc_cluster(struct inode *inode, ext4_lblk_t lblk);
 extern ext4_lblk_t ext4_ext_next_allocated_block(struct ext4_ext_path *path);
 extern int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 			__u64 start, __u64 len);
@@ -3241,7 +3242,6 @@ extern int ext4_swap_extents(handle_t *handle, struct inode *inode1,
 				struct inode *inode2, ext4_lblk_t lblk1,
 			     ext4_lblk_t lblk2,  ext4_lblk_t count,
 			     int mark_unwritten,int *err);
-extern int ext4_clu_mapped(struct inode *inode, ext4_lblk_t lclu);
 
 /* move_extent.c */
 extern void ext4_double_down_write_data_sem(struct inode *first,
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 1ad4c8eb82c1..6c492fca60c4 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2381,8 +2381,8 @@ ext4_ext_put_gap_in_cache(struct inode *inode, ext4_lblk_t hole_start,
 {
 	struct extent_status es;
 
-	ext4_es_find_extent_range(inode, &ext4_es_is_delayed, hole_start,
-				  hole_start + hole_len - 1, &es);
+	ext4_es_find_delayed_extent_range(inode, hole_start,
+					  hole_start + hole_len - 1, &es);
 	if (es.es_len) {
 		/* There's delayed extent containing lblock? */
 		if (es.es_lblk <= hole_start)
@@ -3852,6 +3852,39 @@ static int check_eofblocks_fl(handle_t *handle, struct inode *inode,
 	return ext4_mark_inode_dirty(handle, inode);
 }
 
+/**
+ * ext4_find_delalloc_range: find delayed allocated block in the given range.
+ *
+ * Return 1 if there is a delalloc block in the range, otherwise 0.
+ */
+int ext4_find_delalloc_range(struct inode *inode,
+			     ext4_lblk_t lblk_start,
+			     ext4_lblk_t lblk_end)
+{
+	struct extent_status es;
+
+	ext4_es_find_delayed_extent_range(inode, lblk_start, lblk_end, &es);
+	if (es.es_len == 0)
+		return 0; /* there is no delay extent in this tree */
+	else if (es.es_lblk <= lblk_start &&
+		 lblk_start < es.es_lblk + es.es_len)
+		return 1;
+	else if (lblk_start <= es.es_lblk && es.es_lblk <= lblk_end)
+		return 1;
+	else
+		return 0;
+}
+
+int ext4_find_delalloc_cluster(struct inode *inode, ext4_lblk_t lblk)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+	ext4_lblk_t lblk_start, lblk_end;
+	lblk_start = EXT4_LBLK_CMASK(sbi, lblk);
+	lblk_end = lblk_start + sbi->s_cluster_ratio - 1;
+
+	return ext4_find_delalloc_range(inode, lblk_start, lblk_end);
+}
+
 /**
  * Determines how many complete clusters (out of those specified by the 'map')
  * are under delalloc and were reserved quota for.
@@ -3910,8 +3943,7 @@ get_reserved_cluster_alloc(struct inode *inode, ext4_lblk_t lblk_start,
 		lblk_from = EXT4_LBLK_CMASK(sbi, lblk_start);
 		lblk_to = lblk_from + c_offset - 1;
 
-		if (ext4_es_scan_range(inode, &ext4_es_is_delayed, lblk_from,
-				       lblk_to))
+		if (ext4_find_delalloc_range(inode, lblk_from, lblk_to))
 			allocated_clusters--;
 	}
 
@@ -3921,8 +3953,7 @@ get_reserved_cluster_alloc(struct inode *inode, ext4_lblk_t lblk_start,
 		lblk_from = lblk_start + num_blks;
 		lblk_to = lblk_from + (sbi->s_cluster_ratio - c_offset) - 1;
 
-		if (ext4_es_scan_range(inode, &ext4_es_is_delayed, lblk_from,
-				       lblk_to))
+		if (ext4_find_delalloc_range(inode, lblk_from, lblk_to))
 			allocated_clusters--;
 	}
 
@@ -5077,10 +5108,8 @@ static int ext4_find_delayed_extent(struct inode *inode,
 	ext4_lblk_t block, next_del;
 
 	if (newes->es_pblk == 0) {
-		ext4_es_find_extent_range(inode, &ext4_es_is_delayed,
-					  newes->es_lblk,
-					  newes->es_lblk + newes->es_len - 1,
-					  &es);
+		ext4_es_find_delayed_extent_range(inode, newes->es_lblk,
+				newes->es_lblk + newes->es_len - 1, &es);
 
 		/*
 		 * No extent in extent-tree contains block @newes->es_pblk,
@@ -5101,8 +5130,7 @@ static int ext4_find_delayed_extent(struct inode *inode,
 	}
 
 	block = newes->es_lblk + newes->es_len;
-	ext4_es_find_extent_range(inode, &ext4_es_is_delayed, block,
-				  EXT_MAX_BLOCKS, &es);
+	ext4_es_find_delayed_extent_range(inode, block, EXT_MAX_BLOCKS, &es);
 	if (es.es_len == 0)
 		next_del = EXT_MAX_BLOCKS;
 	else
@@ -5963,90 +5991,3 @@ ext4_swap_extents(handle_t *handle, struct inode *inode1,
 	}
 	return replaced_count;
 }
-
-/*
- * ext4_clu_mapped - determine whether any block in a logical cluster has
- *                   been mapped to a physical cluster
- *
- * @inode - file containing the logical cluster
- * @lclu - logical cluster of interest
- *
- * Returns 1 if any block in the logical cluster is mapped, signifying
- * that a physical cluster has been allocated for it.  Otherwise,
- * returns 0.  Can also return negative error codes.  Derived from
- * ext4_ext_map_blocks().
- */
-int ext4_clu_mapped(struct inode *inode, ext4_lblk_t lclu)
-{
-	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
-	struct ext4_ext_path *path;
-	int depth, mapped = 0, err = 0;
-	struct ext4_extent *extent;
-	ext4_lblk_t first_lblk, first_lclu, last_lclu;
-
-	/*
-	 * if data can be stored inline, the logical cluster isn't
-	 * mapped - no physical clusters have been allocated, and the
-	 * file has no extents
-	 */
-	if (ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA))
-		return 0;
-
-	/* search for the extent closest to the first block in the cluster */
-	path = ext4_find_extent(inode, EXT4_C2B(sbi, lclu), NULL, 0);
-	if (IS_ERR(path)) {
-		err = PTR_ERR(path);
-		path = NULL;
-		goto out;
-	}
-
-	depth = ext_depth(inode);
-
-	/*
-	 * A consistent leaf must not be empty.  This situation is possible,
-	 * though, _during_ tree modification, and it's why an assert can't
-	 * be put in ext4_find_extent().
-	 */
-	if (unlikely(path[depth].p_ext == NULL && depth != 0)) {
-		EXT4_ERROR_INODE(inode,
-		    "bad extent address - lblock: %lu, depth: %d, pblock: %lld",
-				 (unsigned long) EXT4_C2B(sbi, lclu),
-				 depth, path[depth].p_block);
-		err = -EFSCORRUPTED;
-		goto out;
-	}
-
-	extent = path[depth].p_ext;
-
-	/* can't be mapped if the extent tree is empty */
-	if (extent == NULL)
-		goto out;
-
-	first_lblk = le32_to_cpu(extent->ee_block);
-	first_lclu = EXT4_B2C(sbi, first_lblk);
-
-	/*
-	 * Three possible outcomes at this point - found extent spanning
-	 * the target cluster, to the left of the target cluster, or to the
-	 * right of the target cluster.  The first two cases are handled here.
-	 * The last case indicates the target cluster is not mapped.
-	 */
-	if (lclu >= first_lclu) {
-		last_lclu = EXT4_B2C(sbi, first_lblk +
-				     ext4_ext_get_actual_len(extent) - 1);
-		if (lclu <= last_lclu) {
-			mapped = 1;
-		} else {
-			first_lblk = ext4_ext_next_allocated_block(path);
-			first_lclu = EXT4_B2C(sbi, first_lblk);
-			if (lclu == first_lclu)
-				mapped = 1;
-		}
-	}
-
-out:
-	ext4_ext_drop_refs(path);
-	kfree(path);
-
-	return err ? err : mapped;
-}
diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index 441ee2e747d3..027c3e1b9f61 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -142,7 +142,6 @@
  */
 
 static struct kmem_cache *ext4_es_cachep;
-static struct kmem_cache *ext4_pending_cachep;
 
 static int __es_insert_extent(struct inode *inode, struct extent_status *newes);
 static int __es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
@@ -234,38 +233,30 @@ static struct extent_status *__es_tree_search(struct rb_root *root,
 }
 
 /*
- * ext4_es_find_extent_range - find extent with specified status within block
- *                             range or next extent following block range in
- *                             extents status tree
+ * ext4_es_find_delayed_extent_range: find the 1st delayed extent covering
+ * @es->lblk if it exists, otherwise, the next extent after @es->lblk.
  *
- * @inode - file containing the range
- * @matching_fn - pointer to function that matches extents with desired status
- * @lblk - logical block defining start of range
- * @end - logical block defining end of range
- * @es - extent found, if any
- *
- * Find the first extent within the block range specified by @lblk and @end
- * in the extents status tree that satisfies @matching_fn.  If a match
- * is found, it's returned in @es.  If not, and a matching extent is found
- * beyond the block range, it's returned in @es.  If no match is found, an
- * extent is returned in @es whose es_lblk, es_len, and es_pblk components
- * are 0.
+ * @inode: the inode which owns delayed extents
+ * @lblk: the offset where we start to search
+ * @end: the offset where we stop to search
+ * @es: delayed extent that we found
  */
-static void __es_find_extent_range(struct inode *inode,
-				   int (*matching_fn)(struct extent_status *es),
-				   ext4_lblk_t lblk, ext4_lblk_t end,
-				   struct extent_status *es)
+void ext4_es_find_delayed_extent_range(struct inode *inode,
+				 ext4_lblk_t lblk, ext4_lblk_t end,
+				 struct extent_status *es)
 {
 	struct ext4_es_tree *tree = NULL;
 	struct extent_status *es1 = NULL;
 	struct rb_node *node;
 
-	WARN_ON(es == NULL);
-	WARN_ON(end < lblk);
+	BUG_ON(es == NULL);
+	BUG_ON(end < lblk);
+	trace_ext4_es_find_delayed_extent_range_enter(inode, lblk);
 
+	read_lock(&EXT4_I(inode)->i_es_lock);
 	tree = &EXT4_I(inode)->i_es_tree;
 
-	/* see if the extent has been cached */
+	/* find extent in cache firstly */
 	es->es_lblk = es->es_len = es->es_pblk = 0;
 	if (tree->cache_es) {
 		es1 = tree->cache_es;
@@ -280,133 +271,28 @@ static void __es_find_extent_range(struct inode *inode,
 	es1 = __es_tree_search(&tree->root, lblk);
 
 out:
-	if (es1 && !matching_fn(es1)) {
+	if (es1 && !ext4_es_is_delayed(es1)) {
 		while ((node = rb_next(&es1->rb_node)) != NULL) {
 			es1 = rb_entry(node, struct extent_status, rb_node);
 			if (es1->es_lblk > end) {
 				es1 = NULL;
 				break;
 			}
-			if (matching_fn(es1))
+			if (ext4_es_is_delayed(es1))
 				break;
 		}
 	}
 
-	if (es1 && matching_fn(es1)) {
+	if (es1 && ext4_es_is_delayed(es1)) {
 		tree->cache_es = es1;
 		es->es_lblk = es1->es_lblk;
 		es->es_len = es1->es_len;
 		es->es_pblk = es1->es_pblk;
 	}
 
-}
-
-/*
- * Locking for __es_find_extent_range() for external use
- */
-void ext4_es_find_extent_range(struct inode *inode,
-			       int (*matching_fn)(struct extent_status *es),
-			       ext4_lblk_t lblk, ext4_lblk_t end,
-			       struct extent_status *es)
-{
-	trace_ext4_es_find_extent_range_enter(inode, lblk);
-
-	read_lock(&EXT4_I(inode)->i_es_lock);
-	__es_find_extent_range(inode, matching_fn, lblk, end, es);
-	read_unlock(&EXT4_I(inode)->i_es_lock);
-
-	trace_ext4_es_find_extent_range_exit(inode, es);
-}
-
-/*
- * __es_scan_range - search block range for block with specified status
- *                   in extents status tree
- *
- * @inode - file containing the range
- * @matching_fn - pointer to function that matches extents with desired status
- * @lblk - logical block defining start of range
- * @end - logical block defining end of range
- *
- * Returns true if at least one block in the specified block range satisfies
- * the criterion specified by @matching_fn, and false if not.  If at least
- * one extent has the specified status, then there is at least one block
- * in the cluster with that status.  Should only be called by code that has
- * taken i_es_lock.
- */
-static bool __es_scan_range(struct inode *inode,
-			    int (*matching_fn)(struct extent_status *es),
-			    ext4_lblk_t start, ext4_lblk_t end)
-{
-	struct extent_status es;
-
-	__es_find_extent_range(inode, matching_fn, start, end, &es);
-	if (es.es_len == 0)
-		return false;   /* no matching extent in the tree */
-	else if (es.es_lblk <= start &&
-		 start < es.es_lblk + es.es_len)
-		return true;
-	else if (start <= es.es_lblk && es.es_lblk <= end)
-		return true;
-	else
-		return false;
-}
-/*
- * Locking for __es_scan_range() for external use
- */
-bool ext4_es_scan_range(struct inode *inode,
-			int (*matching_fn)(struct extent_status *es),
-			ext4_lblk_t lblk, ext4_lblk_t end)
-{
-	bool ret;
-
-	read_lock(&EXT4_I(inode)->i_es_lock);
-	ret = __es_scan_range(inode, matching_fn, lblk, end);
-	read_unlock(&EXT4_I(inode)->i_es_lock);
-
-	return ret;
-}
-
-/*
- * __es_scan_clu - search cluster for block with specified status in
- *                 extents status tree
- *
- * @inode - file containing the cluster
- * @matching_fn - pointer to function that matches extents with desired status
- * @lblk - logical block in cluster to be searched
- *
- * Returns true if at least one extent in the cluster containing @lblk
- * satisfies the criterion specified by @matching_fn, and false if not.  If at
- * least one extent has the specified status, then there is at least one block
- * in the cluster with that status.  Should only be called by code that has
- * taken i_es_lock.
- */
-static bool __es_scan_clu(struct inode *inode,
-			  int (*matching_fn)(struct extent_status *es),
-			  ext4_lblk_t lblk)
-{
-	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
-	ext4_lblk_t lblk_start, lblk_end;
-
-	lblk_start = EXT4_LBLK_CMASK(sbi, lblk);
-	lblk_end = lblk_start + sbi->s_cluster_ratio - 1;
-
-	return __es_scan_range(inode, matching_fn, lblk_start, lblk_end);
-}
-
-/*
- * Locking for __es_scan_clu() for external use
- */
-bool ext4_es_scan_clu(struct inode *inode,
-		      int (*matching_fn)(struct extent_status *es),
-		      ext4_lblk_t lblk)
-{
-	bool ret;
-
-	read_lock(&EXT4_I(inode)->i_es_lock);
-	ret = __es_scan_clu(inode, matching_fn, lblk);
 	read_unlock(&EXT4_I(inode)->i_es_lock);
 
-	return ret;
+	trace_ext4_es_find_delayed_extent_range_exit(inode, es);
 }
 
 static void ext4_es_list_add(struct inode *inode)
@@ -1364,242 +1250,3 @@ static int es_reclaim_extents(struct ext4_inode_info *ei, int *nr_to_scan)
 	ei->i_es_tree.cache_es = NULL;
 	return nr_shrunk;
 }
-
-#ifdef ES_DEBUG__
-static void ext4_print_pending_tree(struct inode *inode)
-{
-	struct ext4_pending_tree *tree;
-	struct rb_node *node;
-	struct pending_reservation *pr;
-
-	printk(KERN_DEBUG "pending reservations for inode %lu:", inode->i_ino);
-	tree = &EXT4_I(inode)->i_pending_tree;
-	node = rb_first(&tree->root);
-	while (node) {
-		pr = rb_entry(node, struct pending_reservation, rb_node);
-		printk(KERN_DEBUG " %u", pr->lclu);
-		node = rb_next(node);
-	}
-	printk(KERN_DEBUG "\n");
-}
-#else
-#define ext4_print_pending_tree(inode)
-#endif
-
-int __init ext4_init_pending(void)
-{
-	ext4_pending_cachep = kmem_cache_create("ext4_pending_reservation",
-					   sizeof(struct pending_reservation),
-					   0, (SLAB_RECLAIM_ACCOUNT), NULL);
-	if (ext4_pending_cachep == NULL)
-		return -ENOMEM;
-	return 0;
-}
-
-void ext4_exit_pending(void)
-{
-	kmem_cache_destroy(ext4_pending_cachep);
-}
-
-void ext4_init_pending_tree(struct ext4_pending_tree *tree)
-{
-	tree->root = RB_ROOT;
-}
-
-/*
- * __get_pending - retrieve a pointer to a pending reservation
- *
- * @inode - file containing the pending cluster reservation
- * @lclu - logical cluster of interest
- *
- * Returns a pointer to a pending reservation if it's a member of
- * the set, and NULL if not.  Must be called holding i_es_lock.
- */
-static struct pending_reservation *__get_pending(struct inode *inode,
-						 ext4_lblk_t lclu)
-{
-	struct ext4_pending_tree *tree;
-	struct rb_node *node;
-	struct pending_reservation *pr = NULL;
-
-	tree = &EXT4_I(inode)->i_pending_tree;
-	node = (&tree->root)->rb_node;
-
-	while (node) {
-		pr = rb_entry(node, struct pending_reservation, rb_node);
-		if (lclu < pr->lclu)
-			node = node->rb_left;
-		else if (lclu > pr->lclu)
-			node = node->rb_right;
-		else if (lclu == pr->lclu)
-			return pr;
-	}
-	return NULL;
-}
-
-/*
- * __insert_pending - adds a pending cluster reservation to the set of
- *                    pending reservations
- *
- * @inode - file containing the cluster
- * @lblk - logical block in the cluster to be added
- *
- * Returns 0 on successful insertion and -ENOMEM on failure.  If the
- * pending reservation is already in the set, returns successfully.
- */
-static int __insert_pending(struct inode *inode, ext4_lblk_t lblk)
-{
-	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
-	struct ext4_pending_tree *tree = &EXT4_I(inode)->i_pending_tree;
-	struct rb_node **p = &tree->root.rb_node;
-	struct rb_node *parent = NULL;
-	struct pending_reservation *pr;
-	ext4_lblk_t lclu;
-	int ret = 0;
-
-	lclu = EXT4_B2C(sbi, lblk);
-	/* search to find parent for insertion */
-	while (*p) {
-		parent = *p;
-		pr = rb_entry(parent, struct pending_reservation, rb_node);
-
-		if (lclu < pr->lclu) {
-			p = &(*p)->rb_left;
-		} else if (lclu > pr->lclu) {
-			p = &(*p)->rb_right;
-		} else {
-			/* pending reservation already inserted */
-			goto out;
-		}
-	}
-
-	pr = kmem_cache_alloc(ext4_pending_cachep, GFP_ATOMIC);
-	if (pr == NULL) {
-		ret = -ENOMEM;
-		goto out;
-	}
-	pr->lclu = lclu;
-
-	rb_link_node(&pr->rb_node, parent, p);
-	rb_insert_color(&pr->rb_node, &tree->root);
-
-out:
-	return ret;
-}
-
-/*
- * __remove_pending - removes a pending cluster reservation from the set
- *                    of pending reservations
- *
- * @inode - file containing the cluster
- * @lblk - logical block in the pending cluster reservation to be removed
- *
- * Returns successfully if pending reservation is not a member of the set.
- */
-static void __remove_pending(struct inode *inode, ext4_lblk_t lblk)
-{
-	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
-	struct pending_reservation *pr;
-	struct ext4_pending_tree *tree;
-
-	pr = __get_pending(inode, EXT4_B2C(sbi, lblk));
-	if (pr != NULL) {
-		tree = &EXT4_I(inode)->i_pending_tree;
-		rb_erase(&pr->rb_node, &tree->root);
-		kmem_cache_free(ext4_pending_cachep, pr);
-	}
-}
-
-/*
- * ext4_remove_pending - removes a pending cluster reservation from the set
- *                       of pending reservations
- *
- * @inode - file containing the cluster
- * @lblk - logical block in the pending cluster reservation to be removed
- *
- * Locking for external use of __remove_pending.
- */
-void ext4_remove_pending(struct inode *inode, ext4_lblk_t lblk)
-{
-	struct ext4_inode_info *ei = EXT4_I(inode);
-
-	write_lock(&ei->i_es_lock);
-	__remove_pending(inode, lblk);
-	write_unlock(&ei->i_es_lock);
-}
-
-/*
- * ext4_is_pending - determine whether a cluster has a pending reservation
- *                   on it
- *
- * @inode - file containing the cluster
- * @lblk - logical block in the cluster
- *
- * Returns true if there's a pending reservation for the cluster in the
- * set of pending reservations, and false if not.
- */
-bool ext4_is_pending(struct inode *inode, ext4_lblk_t lblk)
-{
-	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
-	struct ext4_inode_info *ei = EXT4_I(inode);
-	bool ret;
-
-	read_lock(&ei->i_es_lock);
-	ret = (bool)(__get_pending(inode, EXT4_B2C(sbi, lblk)) != NULL);
-	read_unlock(&ei->i_es_lock);
-
-	return ret;
-}
-
-/*
- * ext4_es_insert_delayed_block - adds a delayed block to the extents status
- *                                tree, adding a pending reservation where
- *                                needed
- *
- * @inode - file containing the newly added block
- * @lblk - logical block to be added
- * @allocated - indicates whether a physical cluster has been allocated for
- *              the logical cluster that contains the block
- *
- * Returns 0 on success, negative error code on failure.
- */
-int ext4_es_insert_delayed_block(struct inode *inode, ext4_lblk_t lblk,
-				 bool allocated)
-{
-	struct extent_status newes;
-	int err = 0;
-
-	es_debug("add [%u/1) delayed to extent status tree of inode %lu\n",
-		 lblk, inode->i_ino);
-
-	newes.es_lblk = lblk;
-	newes.es_len = 1;
-	ext4_es_store_pblock_status(&newes, ~0, EXTENT_STATUS_DELAYED);
-	trace_ext4_es_insert_delayed_block(inode, &newes, allocated);
-
-	ext4_es_insert_extent_check(inode, &newes);
-
-	write_lock(&EXT4_I(inode)->i_es_lock);
-
-	err = __es_remove_extent(inode, lblk, lblk);
-	if (err != 0)
-		goto error;
-retry:
-	err = __es_insert_extent(inode, &newes);
-	if (err == -ENOMEM && __es_shrink(EXT4_SB(inode->i_sb),
-					  128, EXT4_I(inode)))
-		goto retry;
-	if (err != 0)
-		goto error;
-
-	if (allocated)
-		__insert_pending(inode, lblk);
-
-error:
-	write_unlock(&EXT4_I(inode)->i_es_lock);
-
-	ext4_es_print_tree(inode);
-	ext4_print_pending_tree(inode);
-
-	return err;
-}
diff --git a/fs/ext4/extents_status.h b/fs/ext4/extents_status.h
index 9d3c676ec623..8efdeb903d6b 100644
--- a/fs/ext4/extents_status.h
+++ b/fs/ext4/extents_status.h
@@ -78,51 +78,6 @@ struct ext4_es_stats {
 	struct percpu_counter es_stats_shk_cnt;
 };
 
-/*
- * Pending cluster reservations for bigalloc file systems
- *
- * A cluster with a pending reservation is a logical cluster shared by at
- * least one extent in the extents status tree with delayed and unwritten
- * status and at least one other written or unwritten extent.  The
- * reservation is said to be pending because a cluster reservation would
- * have to be taken in the event all blocks in the cluster shared with
- * written or unwritten extents were deleted while the delayed and
- * unwritten blocks remained.
- *
- * The set of pending cluster reservations is an auxiliary data structure
- * used with the extents status tree to implement reserved cluster/block
- * accounting for bigalloc file systems.  The set is kept in memory and
- * records all pending cluster reservations.
- *
- * Its primary function is to avoid the need to read extents from the
- * disk when invalidating pages as a result of a truncate, punch hole, or
- * collapse range operation.  Page invalidation requires a decrease in the
- * reserved cluster count if it results in the removal of all delayed
- * and unwritten extents (blocks) from a cluster that is not shared with a
- * written or unwritten extent, and no decrease otherwise.  Determining
- * whether the cluster is shared can be done by searching for a pending
- * reservation on it.
- *
- * Secondarily, it provides a potentially faster method for determining
- * whether the reserved cluster count should be increased when a physical
- * cluster is deallocated as a result of a truncate, punch hole, or
- * collapse range operation.  The necessary information is also present
- * in the extents status tree, but might be more rapidly accessed in
- * the pending reservation set in many cases due to smaller size.
- *
- * The pending cluster reservation set is implemented as a red-black tree
- * with the goal of minimizing per page search time overhead.
- */
-
-struct pending_reservation {
-	struct rb_node rb_node;
-	ext4_lblk_t lclu;
-};
-
-struct ext4_pending_tree {
-	struct rb_root root;
-};
-
 extern int __init ext4_init_es(void);
 extern void ext4_exit_es(void);
 extern void ext4_es_init_tree(struct ext4_es_tree *tree);
@@ -135,18 +90,11 @@ extern void ext4_es_cache_extent(struct inode *inode, ext4_lblk_t lblk,
 				 unsigned int status);
 extern int ext4_es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
 				 ext4_lblk_t len);
-extern void ext4_es_find_extent_range(struct inode *inode,
-				      int (*match_fn)(struct extent_status *es),
-				      ext4_lblk_t lblk, ext4_lblk_t end,
-				      struct extent_status *es);
+extern void ext4_es_find_delayed_extent_range(struct inode *inode,
+					ext4_lblk_t lblk, ext4_lblk_t end,
+					struct extent_status *es);
 extern int ext4_es_lookup_extent(struct inode *inode, ext4_lblk_t lblk,
 				 struct extent_status *es);
-extern bool ext4_es_scan_range(struct inode *inode,
-			       int (*matching_fn)(struct extent_status *es),
-			       ext4_lblk_t lblk, ext4_lblk_t end);
-extern bool ext4_es_scan_clu(struct inode *inode,
-			     int (*matching_fn)(struct extent_status *es),
-			     ext4_lblk_t lblk);
 
 static inline unsigned int ext4_es_status(struct extent_status *es)
 {
@@ -178,16 +126,6 @@ static inline int ext4_es_is_hole(struct extent_status *es)
 	return (ext4_es_type(es) & EXTENT_STATUS_HOLE) != 0;
 }
 
-static inline int ext4_es_is_mapped(struct extent_status *es)
-{
-	return (ext4_es_is_written(es) || ext4_es_is_unwritten(es));
-}
-
-static inline int ext4_es_is_delonly(struct extent_status *es)
-{
-	return (ext4_es_is_delayed(es) && !ext4_es_is_unwritten(es));
-}
-
 static inline void ext4_es_set_referenced(struct extent_status *es)
 {
 	es->es_pblk |= ((ext4_fsblk_t)EXTENT_STATUS_REFERENCED) << ES_SHIFT;
@@ -237,12 +175,4 @@ extern void ext4_es_unregister_shrinker(struct ext4_sb_info *sbi);
 
 extern int ext4_seq_es_shrinker_info_show(struct seq_file *seq, void *v);
 
-extern int __init ext4_init_pending(void);
-extern void ext4_exit_pending(void);
-extern void ext4_init_pending_tree(struct ext4_pending_tree *tree);
-extern void ext4_remove_pending(struct inode *inode, ext4_lblk_t lblk);
-extern bool ext4_is_pending(struct inode *inode, ext4_lblk_t lblk);
-extern int ext4_es_insert_delayed_block(struct inode *inode, ext4_lblk_t lblk,
-					bool allocated);
-
 #endif /* _EXT4_EXTENTS_STATUS_H */
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 17d120ac2010..3c7bbdaa425a 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -600,8 +600,8 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 				EXTENT_STATUS_UNWRITTEN : EXTENT_STATUS_WRITTEN;
 		if (!(flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE) &&
 		    !(status & EXTENT_STATUS_WRITTEN) &&
-		    ext4_es_scan_range(inode, &ext4_es_is_delayed, map->m_lblk,
-				       map->m_lblk + map->m_len - 1))
+		    ext4_find_delalloc_range(inode, map->m_lblk,
+					     map->m_lblk + map->m_len - 1))
 			status |= EXTENT_STATUS_DELAYED;
 		ret = ext4_es_insert_extent(inode, map->m_lblk,
 					    map->m_len, map->m_pblk, status);
@@ -724,8 +724,8 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 				EXTENT_STATUS_UNWRITTEN : EXTENT_STATUS_WRITTEN;
 		if (!(flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE) &&
 		    !(status & EXTENT_STATUS_WRITTEN) &&
-		    ext4_es_scan_range(inode, &ext4_es_is_delayed, map->m_lblk,
-				       map->m_lblk + map->m_len - 1))
+		    ext4_find_delalloc_range(inode, map->m_lblk,
+					     map->m_lblk + map->m_len - 1))
 			status |= EXTENT_STATUS_DELAYED;
 		ret = ext4_es_insert_extent(inode, map->m_lblk, map->m_len,
 					    map->m_pblk, status);
@@ -1717,7 +1717,7 @@ static void ext4_da_page_release_reservation(struct page *page,
 		lblk = (page->index << (PAGE_SHIFT - inode->i_blkbits)) +
 			((num_clusters - 1) << sbi->s_cluster_bits);
 		if (sbi->s_cluster_ratio == 1 ||
-		    !ext4_es_scan_clu(inode, &ext4_es_is_delayed, lblk))
+		    !ext4_find_delalloc_cluster(inode, lblk))
 			ext4_da_release_space(inode, 1);
 
 		num_clusters--;
@@ -1823,65 +1823,6 @@ static int ext4_bh_delay_or_unwritten(handle_t *handle, struct buffer_head *bh)
 	return (buffer_delay(bh) || buffer_unwritten(bh)) && buffer_dirty(bh);
 }
 
-/*
- * ext4_insert_delayed_block - adds a delayed block to the extents status
- *                             tree, incrementing the reserved cluster/block
- *                             count or making a pending reservation
- *                             where needed
- *
- * @inode - file containing the newly added block
- * @lblk - logical block to be added
- *
- * Returns 0 on success, negative error code on failure.
- */
-static int ext4_insert_delayed_block(struct inode *inode, ext4_lblk_t lblk)
-{
-	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
-	int ret;
-	bool allocated = false;
-
-	/*
-	 * If the cluster containing lblk is shared with a delayed,
-	 * written, or unwritten extent in a bigalloc file system, it's
-	 * already been accounted for and does not need to be reserved.
-	 * A pending reservation must be made for the cluster if it's
-	 * shared with a written or unwritten extent and doesn't already
-	 * have one.  Written and unwritten extents can be purged from the
-	 * extents status tree if the system is under memory pressure, so
-	 * it's necessary to examine the extent tree if a search of the
-	 * extents status tree doesn't get a match.
-	 */
-	if (sbi->s_cluster_ratio == 1) {
-		ret = ext4_da_reserve_space(inode);
-		if (ret != 0)   /* ENOSPC */
-			goto errout;
-	} else {   /* bigalloc */
-		if (!ext4_es_scan_clu(inode, &ext4_es_is_delonly, lblk)) {
-			if (!ext4_es_scan_clu(inode,
-					      &ext4_es_is_mapped, lblk)) {
-				ret = ext4_clu_mapped(inode,
-						      EXT4_B2C(sbi, lblk));
-				if (ret < 0)
-					goto errout;
-				if (ret == 0) {
-					ret = ext4_da_reserve_space(inode);
-					if (ret != 0)   /* ENOSPC */
-						goto errout;
-				} else {
-					allocated = true;
-				}
-			} else {
-				allocated = true;
-			}
-		}
-	}
-
-	ret = ext4_es_insert_delayed_block(inode, lblk, allocated);
-
-errout:
-	return ret;
-}
-
 /*
  * This function is grabs code from the very beginning of
  * ext4_map_blocks, but assumes that the caller is from delayed write
@@ -1961,14 +1902,28 @@ static int ext4_da_map_blocks(struct inode *inode, sector_t iblock,
 add_delayed:
 	if (retval == 0) {
 		int ret;
-
 		/*
 		 * XXX: __block_prepare_write() unmaps passed block,
 		 * is it OK?
 		 */
+		/*
+		 * If the block was allocated from previously allocated cluster,
+		 * then we don't need to reserve it again. However we still need
+		 * to reserve metadata for every block we're going to write.
+		 */
+		if (EXT4_SB(inode->i_sb)->s_cluster_ratio == 1 ||
+		    !ext4_find_delalloc_cluster(inode, map->m_lblk)) {
+			ret = ext4_da_reserve_space(inode);
+			if (ret) {
+				/* not enough space to reserve */
+				retval = ret;
+				goto out_unlock;
+			}
+		}
 
-		ret = ext4_insert_delayed_block(inode, map->m_lblk);
-		if (ret != 0) {
+		ret = ext4_es_insert_extent(inode, map->m_lblk, map->m_len,
+					    ~0, EXTENT_STATUS_DELAYED);
+		if (ret) {
 			retval = ret;
 			goto out_unlock;
 		}
@@ -3564,8 +3519,7 @@ static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 			ext4_lblk_t end = map.m_lblk + map.m_len - 1;
 			struct extent_status es;
 
-			ext4_es_find_extent_range(inode, &ext4_es_is_delayed,
-						  map.m_lblk, end, &es);
+			ext4_es_find_delayed_extent_range(inode, map.m_lblk, end, &es);
 
 			if (!es.es_len || es.es_lblk > end) {
 				/* entire range is a hole */
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 73a431b6e720..e54a5be15636 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1095,7 +1095,6 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
 	ei->i_da_metadata_calc_len = 0;
 	ei->i_da_metadata_calc_last_lblock = 0;
 	spin_lock_init(&(ei->i_block_reservation_lock));
-	ext4_init_pending_tree(&ei->i_pending_tree);
 #ifdef CONFIG_QUOTA
 	ei->i_reserved_quota = 0;
 	memset(&ei->i_dquot, 0, sizeof(ei->i_dquot));
@@ -6190,10 +6189,6 @@ static int __init ext4_init_fs(void)
 	if (err)
 		return err;
 
-	err = ext4_init_pending();
-	if (err)
-		goto out6;
-
 	err = ext4_init_pageio();
 	if (err)
 		goto out5;
@@ -6232,8 +6227,6 @@ static int __init ext4_init_fs(void)
 out4:
 	ext4_exit_pageio();
 out5:
-	ext4_exit_pending();
-out6:
 	ext4_exit_es();
 
 	return err;
@@ -6251,7 +6244,6 @@ static void __exit ext4_exit_fs(void)
 	ext4_exit_system_zone();
 	ext4_exit_pageio();
 	ext4_exit_es();
-	ext4_exit_pending();
 }
 
 MODULE_AUTHOR("Remy Card, Stephen Tweedie, Andrew Morton, Andreas Dilger, Theodore Ts'o and others");
diff --git a/fs/f2fs/extent_cache.c b/fs/f2fs/extent_cache.c
index 36d6b561b524..e85ed4aa9d46 100644
--- a/fs/f2fs/extent_cache.c
+++ b/fs/f2fs/extent_cache.c
@@ -375,7 +375,8 @@ static bool f2fs_lookup_extent_tree(struct inode *inode, pgoff_t pgofs,
 	struct extent_node *en;
 	bool ret = false;
 
-	f2fs_bug_on(sbi, !et);
+	if (!et)
+		return false;
 
 	trace_f2fs_lookup_extent_tree_start(inode, pgofs);
 
diff --git a/fs/nfs/filelayout/filelayout.c b/fs/nfs/filelayout/filelayout.c
index e8e825497cbd..015d39ac2c8f 100644
--- a/fs/nfs/filelayout/filelayout.c
+++ b/fs/nfs/filelayout/filelayout.c
@@ -837,6 +837,12 @@ filelayout_alloc_lseg(struct pnfs_layout_hdr *layoutid,
 	return &fl->generic_hdr;
 }
 
+static bool
+filelayout_lseg_is_striped(const struct nfs4_filelayout_segment *flseg)
+{
+	return flseg->num_fh > 1;
+}
+
 /*
  * filelayout_pg_test(). Called by nfs_can_coalesce_requests()
  *
@@ -857,6 +863,8 @@ filelayout_pg_test(struct nfs_pageio_descriptor *pgio, struct nfs_page *prev,
 	size = pnfs_generic_pg_test(pgio, prev, req);
 	if (!size)
 		return 0;
+	else if (!filelayout_lseg_is_striped(FILELAYOUT_LSEG(pgio->pg_lseg)))
+		return size;
 
 	/* see if req and prev are in the same stripe */
 	if (prev) {
diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index 919d1238ce45..a0e37530dcf3 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -480,9 +480,18 @@ static int __nilfs_btree_get_block(const struct nilfs_bmap *btree, __u64 ptr,
 	ret = nilfs_btnode_submit_block(btnc, ptr, 0, REQ_OP_READ, 0, &bh,
 					&submit_ptr);
 	if (ret) {
-		if (ret != -EEXIST)
-			return ret;
-		goto out_check;
+		if (likely(ret == -EEXIST))
+			goto out_check;
+		if (ret == -ENOENT) {
+			/*
+			 * Block address translation failed due to invalid
+			 * value of 'ptr'.  In this case, return internal code
+			 * -EINVAL (broken bmap) to notify bmap layer of fatal
+			 * metadata corruption.
+			 */
+			ret = -EINVAL;
+		}
+		return ret;
 	}
 
 	if (ra) {
diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
index 20c9b8e77a57..0dfb174f707e 100644
--- a/include/trace/events/ext4.h
+++ b/include/trace/events/ext4.h
@@ -2290,7 +2290,7 @@ TRACE_EVENT(ext4_es_remove_extent,
 		  __entry->lblk, __entry->len)
 );
 
-TRACE_EVENT(ext4_es_find_extent_range_enter,
+TRACE_EVENT(ext4_es_find_delayed_extent_range_enter,
 	TP_PROTO(struct inode *inode, ext4_lblk_t lblk),
 
 	TP_ARGS(inode, lblk),
@@ -2312,7 +2312,7 @@ TRACE_EVENT(ext4_es_find_extent_range_enter,
 		  (unsigned long) __entry->ino, __entry->lblk)
 );
 
-TRACE_EVENT(ext4_es_find_extent_range_exit,
+TRACE_EVENT(ext4_es_find_delayed_extent_range_exit,
 	TP_PROTO(struct inode *inode, struct extent_status *es),
 
 	TP_ARGS(inode, es),
@@ -2532,41 +2532,6 @@ TRACE_EVENT(ext4_es_shrink,
 		  __entry->scan_time, __entry->nr_skipped, __entry->retried)
 );
 
-TRACE_EVENT(ext4_es_insert_delayed_block,
-	TP_PROTO(struct inode *inode, struct extent_status *es,
-		 bool allocated),
-
-	TP_ARGS(inode, es, allocated),
-
-	TP_STRUCT__entry(
-		__field(	dev_t,		dev		)
-		__field(	ino_t,		ino		)
-		__field(	ext4_lblk_t,	lblk		)
-		__field(	ext4_lblk_t,	len		)
-		__field(	ext4_fsblk_t,	pblk		)
-		__field(	char,		status		)
-		__field(	bool,		allocated	)
-	),
-
-	TP_fast_assign(
-		__entry->dev		= inode->i_sb->s_dev;
-		__entry->ino		= inode->i_ino;
-		__entry->lblk		= es->es_lblk;
-		__entry->len		= es->es_len;
-		__entry->pblk		= ext4_es_pblock(es);
-		__entry->status		= ext4_es_status(es);
-		__entry->allocated	= allocated;
-	),
-
-	TP_printk("dev %d,%d ino %lu es [%u/%u) mapped %llu status %s "
-		  "allocated %d",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  (unsigned long) __entry->ino,
-		  __entry->lblk, __entry->len,
-		  __entry->pblk, show_extent_status(__entry->status),
-		  __entry->allocated)
-);
-
 /* fsmap traces */
 DECLARE_EVENT_CLASS(ext4_fsmap_class,
 	TP_PROTO(struct super_block *sb, u32 keydev, u32 agno, u64 bno, u64 len,
diff --git a/kernel/sys.c b/kernel/sys.c
index d0663f8e6fb8..3548467f6459 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1530,6 +1530,8 @@ int do_prlimit(struct task_struct *tsk, unsigned int resource,
 
 	if (resource >= RLIM_NLIMITS)
 		return -EINVAL;
+	resource = array_index_nospec(resource, RLIM_NLIMITS);
+
 	if (new_rlim) {
 		if (new_rlim->rlim_cur > new_rlim->rlim_max)
 			return -EINVAL;
diff --git a/net/core/ethtool.c b/net/core/ethtool.c
index 4db9512feba8..d007f1cca64c 100644
--- a/net/core/ethtool.c
+++ b/net/core/ethtool.c
@@ -2023,7 +2023,8 @@ static int ethtool_get_phy_stats(struct net_device *dev, void __user *useraddr)
 		return n_stats;
 	if (n_stats > S32_MAX / sizeof(u64))
 		return -ENOMEM;
-	WARN_ON_ONCE(!n_stats);
+	if (WARN_ON_ONCE(!n_stats))
+		return -EOPNOTSUPP;
 
 	if (copy_from_user(&stats, useraddr, sizeof(stats)))
 		return -EFAULT;
