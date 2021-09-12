Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F850407DA1
	for <lists+stable@lfdr.de>; Sun, 12 Sep 2021 15:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235824AbhILN2G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Sep 2021 09:28:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:58486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235844AbhILN1x (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 12 Sep 2021 09:27:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 720BE60F24;
        Sun, 12 Sep 2021 13:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631453199;
        bh=1vH6GddN3ovCCm4k9uW0OmgczCoWPXn/ISYIYOzSp4g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P6NvcrFuaghsOUx2vQBf1k35G2WWnTxQimbahhxA3g9pEGXhAYc6rDCRuSqIDxQx1
         EpozcCyNBNpGXLNr+LnF37mnsXpUyE1mvZswzRDfEr1n+jFocxVgGb5btqpB+WIMMF
         LdevqJGKJv+ZRl+PxnktQSiGa8n/k+6XBTVpn+JM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.14.3
Date:   Sun, 12 Sep 2021 15:26:33 +0200
Message-Id: <1631453192122202@kroah.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <16314531927389@kroah.com>
References: <16314531927389@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 9a2b00ecc6af..8715942fccb4 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 14
-SUBLEVEL = 2
+SUBLEVEL = 3
 EXTRAVERSION =
 NAME = Opossums on Parade
 
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index ebfb91108232..0a40df66a40d 100644
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
diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index a552e7b48360..0255bf243ce5 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -452,6 +452,10 @@ static const struct usb_device_id blacklist_table[] = {
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
@@ -1895,7 +1899,7 @@ static int btusb_setup_csr(struct hci_dev *hdev)
 		is_fake = true;
 
 	if (is_fake) {
-		bt_dev_warn(hdev, "CSR: Unbranded CSR clone detected; adding workarounds...");
+		bt_dev_warn(hdev, "CSR: Unbranded CSR clone detected; adding workarounds and force-suspending once...");
 
 		/* Generally these clones have big discrepancies between
 		 * advertised features and what's actually supported.
@@ -1912,41 +1916,46 @@ static int btusb_setup_csr(struct hci_dev *hdev)
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
diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
index 8ae89273f58e..54e9d4d2cf5f 100644
--- a/drivers/cxl/acpi.c
+++ b/drivers/cxl/acpi.c
@@ -243,6 +243,9 @@ static struct acpi_device *to_cxl_host_bridge(struct device *dev)
 {
 	struct acpi_device *adev = to_acpi_device(dev);
 
+	if (!acpi_pci_find_root(adev->handle))
+		return NULL;
+
 	if (strcmp(acpi_device_hid(adev), "ACPI0016") == 0)
 		return adev;
 	return NULL;
@@ -266,10 +269,6 @@ static int add_host_bridge_uport(struct device *match, void *arg)
 	if (!bridge)
 		return 0;
 
-	pci_root = acpi_pci_find_root(bridge->handle);
-	if (!pci_root)
-		return -ENXIO;
-
 	dport = find_dport_by_dev(root_port, match);
 	if (!dport) {
 		dev_dbg(host, "host bridge expected and not found\n");
@@ -282,6 +281,11 @@ static int add_host_bridge_uport(struct device *match, void *arg)
 		return PTR_ERR(port);
 	dev_dbg(host, "%s: add: %s\n", dev_name(match), dev_name(&port->dev));
 
+	/*
+	 * Note that this lookup already succeeded in
+	 * to_cxl_host_bridge(), so no need to check for failure here
+	 */
+	pci_root = acpi_pci_find_root(bridge->handle);
 	ctx = (struct cxl_walk_context){
 		.dev = host,
 		.root = pci_root->bus,
diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
index 4cf351a3cf99..145ad4bc305f 100644
--- a/drivers/cxl/pci.c
+++ b/drivers/cxl/pci.c
@@ -568,7 +568,7 @@ static bool cxl_mem_raw_command_allowed(u16 opcode)
 	if (!IS_ENABLED(CONFIG_CXL_MEM_RAW_COMMANDS))
 		return false;
 
-	if (security_locked_down(LOCKDOWN_NONE))
+	if (security_locked_down(LOCKDOWN_PCI_ACCESS))
 		return false;
 
 	if (cxl_raw_allow_all)
@@ -1022,8 +1022,8 @@ static int cxl_probe_regs(struct cxl_mem *cxlm, void __iomem *base,
 		    !dev_map->memdev.valid) {
 			dev_err(dev, "registers not found: %s%s%s\n",
 				!dev_map->status.valid ? "status " : "",
-				!dev_map->mbox.valid ? "status " : "",
-				!dev_map->memdev.valid ? "status " : "");
+				!dev_map->mbox.valid ? "mbox " : "",
+				!dev_map->memdev.valid ? "memdev " : "");
 			return -ENXIO;
 		}
 
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
 
diff --git a/drivers/net/can/c_can/c_can_ethtool.c b/drivers/net/can/c_can/c_can_ethtool.c
index cd5f07fca2a5..377c7d2e7612 100644
--- a/drivers/net/can/c_can/c_can_ethtool.c
+++ b/drivers/net/can/c_can/c_can_ethtool.c
@@ -15,10 +15,8 @@ static void c_can_get_drvinfo(struct net_device *netdev,
 			      struct ethtool_drvinfo *info)
 {
 	struct c_can_priv *priv = netdev_priv(netdev);
-	struct platform_device *pdev = to_platform_device(priv->device);
-
 	strscpy(info->driver, "c_can", sizeof(info->driver));
-	strscpy(info->bus_info, pdev->name, sizeof(info->bus_info));
+	strscpy(info->bus_info, dev_name(priv->device), sizeof(info->bus_info));
 }
 
 static void c_can_get_ringparam(struct net_device *netdev,
diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 4d8e337f5085..55411c100a0e 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -3489,6 +3489,7 @@ static void rtl_hw_start_8402(struct rtl8169_private *tp)
 	rtl_eri_write(tp, 0x1b0, ERIAR_MASK_0011, 0x0000);
 
 	rtl_pcie_state_l2l3_disable(tp);
+	rtl_hw_aspm_clkreq_enable(tp, true);
 }
 
 static void rtl_hw_start_8106(struct rtl8169_private *tp)
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
diff --git a/drivers/staging/mt7621-pci/pci-mt7621.c b/drivers/staging/mt7621-pci/pci-mt7621.c
index f9bdf4e33134..6acfc94a16e7 100644
--- a/drivers/staging/mt7621-pci/pci-mt7621.c
+++ b/drivers/staging/mt7621-pci/pci-mt7621.c
@@ -56,6 +56,7 @@
 #define PCIE_BAR_ENABLE			BIT(0)
 #define PCIE_PORT_INT_EN(x)		BIT(20 + (x))
 #define PCIE_PORT_LINKUP		BIT(0)
+#define PCIE_PORT_CNT			3
 
 #define PERST_DELAY_MS			100
 
@@ -388,10 +389,11 @@ static void mt7621_pcie_reset_ep_deassert(struct mt7621_pcie *pcie)
 	msleep(PERST_DELAY_MS);
 }
 
-static void mt7621_pcie_init_ports(struct mt7621_pcie *pcie)
+static int mt7621_pcie_init_ports(struct mt7621_pcie *pcie)
 {
 	struct device *dev = pcie->dev;
 	struct mt7621_pcie_port *port, *tmp;
+	u8 num_disabled = 0;
 	int err;
 
 	mt7621_pcie_reset_assert(pcie);
@@ -423,6 +425,7 @@ static void mt7621_pcie_init_ports(struct mt7621_pcie *pcie)
 				slot);
 			mt7621_control_assert(port);
 			port->enabled = false;
+			num_disabled++;
 
 			if (slot == 0) {
 				tmp = port;
@@ -433,6 +436,8 @@ static void mt7621_pcie_init_ports(struct mt7621_pcie *pcie)
 				phy_power_off(tmp->phy);
 		}
 	}
+
+	return (num_disabled != PCIE_PORT_CNT) ? 0 : -ENODEV;
 }
 
 static void mt7621_pcie_enable_port(struct mt7621_pcie_port *port)
@@ -540,7 +545,11 @@ static int mt7621_pci_probe(struct platform_device *pdev)
 		return err;
 	}
 
-	mt7621_pcie_init_ports(pcie);
+	err = mt7621_pcie_init_ports(pcie);
+	if (err) {
+		dev_err(dev, "Nothing connected in virtual bridges\n");
+		return 0;
+	}
 
 	err = mt7621_pcie_enable_ports(bridge);
 	if (err) {
diff --git a/drivers/usb/cdns3/cdnsp-mem.c b/drivers/usb/cdns3/cdnsp-mem.c
index a47948a1623f..ad9aee3f1e39 100644
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
index c0ca7144e512..43f1b0d461c1 100644
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
index cffcaf4dfa9f..0bb1a6295d64 100644
--- a/drivers/usb/host/xhci-mtk-sch.c
+++ b/drivers/usb/host/xhci-mtk-sch.c
@@ -575,10 +575,12 @@ static u32 get_esit_boundary(struct mu3h_sch_ep_info *sch_ep)
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
index 8fea44bbc266..9017986241f5 100644
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
index 3c7d281672ae..dca6181c33fd 100644
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
 
@@ -2235,15 +2238,14 @@ static inline char *xhci_slot_state_string(u32 state)
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
@@ -2260,7 +2262,7 @@ static inline const char *xhci_decode_trb(u32 field0, u32 field1, u32 field2,
 	case TRB_HC_EVENT:
 	case TRB_DEV_NOTE:
 	case TRB_MFINDEX_WRAP:
-		sprintf(str,
+		snprintf(str, size,
 			"TRB %08x%08x status '%s' len %d slot %d ep %d type '%s' flags %c:%c",
 			field1, field0,
 			xhci_trb_comp_code_string(GET_COMP_CODE(field2)),
@@ -2273,7 +2275,8 @@ static inline const char *xhci_decode_trb(u32 field0, u32 field1, u32 field2,
 
 		break;
 	case TRB_SETUP:
-		sprintf(str, "bRequestType %02x bRequest %02x wValue %02x%02x wIndex %02x%02x wLength %d length %d TD size %d intr %d type '%s' flags %c:%c:%c",
+		snprintf(str, size,
+			"bRequestType %02x bRequest %02x wValue %02x%02x wIndex %02x%02x wLength %d length %d TD size %d intr %d type '%s' flags %c:%c:%c",
 				field0 & 0xff,
 				(field0 & 0xff00) >> 8,
 				(field0 & 0xff000000) >> 24,
@@ -2290,7 +2293,8 @@ static inline const char *xhci_decode_trb(u32 field0, u32 field1, u32 field2,
 				field3 & TRB_CYCLE ? 'C' : 'c');
 		break;
 	case TRB_DATA:
-		sprintf(str, "Buffer %08x%08x length %d TD size %d intr %d type '%s' flags %c:%c:%c:%c:%c:%c:%c",
+		snprintf(str, size,
+			 "Buffer %08x%08x length %d TD size %d intr %d type '%s' flags %c:%c:%c:%c:%c:%c:%c",
 				field1, field0, TRB_LEN(field2), GET_TD_SIZE(field2),
 				GET_INTR_TARGET(field2),
 				xhci_trb_type_string(type),
@@ -2303,7 +2307,8 @@ static inline const char *xhci_decode_trb(u32 field0, u32 field1, u32 field2,
 				field3 & TRB_CYCLE ? 'C' : 'c');
 		break;
 	case TRB_STATUS:
-		sprintf(str, "Buffer %08x%08x length %d TD size %d intr %d type '%s' flags %c:%c:%c:%c",
+		snprintf(str, size,
+			 "Buffer %08x%08x length %d TD size %d intr %d type '%s' flags %c:%c:%c:%c",
 				field1, field0, TRB_LEN(field2), GET_TD_SIZE(field2),
 				GET_INTR_TARGET(field2),
 				xhci_trb_type_string(type),
@@ -2316,7 +2321,7 @@ static inline const char *xhci_decode_trb(u32 field0, u32 field1, u32 field2,
 	case TRB_ISOC:
 	case TRB_EVENT_DATA:
 	case TRB_TR_NOOP:
-		sprintf(str,
+		snprintf(str, size,
 			"Buffer %08x%08x length %d TD size %d intr %d type '%s' flags %c:%c:%c:%c:%c:%c:%c:%c",
 			field1, field0, TRB_LEN(field2), GET_TD_SIZE(field2),
 			GET_INTR_TARGET(field2),
@@ -2333,21 +2338,21 @@ static inline const char *xhci_decode_trb(u32 field0, u32 field1, u32 field2,
 
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
@@ -2356,7 +2361,7 @@ static inline const char *xhci_decode_trb(u32 field0, u32 field1, u32 field2,
 			field3 & TRB_CYCLE ? 'C' : 'c');
 		break;
 	case TRB_CONFIG_EP:
-		sprintf(str,
+		snprintf(str, size,
 			"%s: ctx %08x%08x slot %d flags %c:%c",
 			xhci_trb_type_string(type),
 			field1, field0,
@@ -2365,7 +2370,7 @@ static inline const char *xhci_decode_trb(u32 field0, u32 field1, u32 field2,
 			field3 & TRB_CYCLE ? 'C' : 'c');
 		break;
 	case TRB_EVAL_CONTEXT:
-		sprintf(str,
+		snprintf(str, size,
 			"%s: ctx %08x%08x slot %d flags %c",
 			xhci_trb_type_string(type),
 			field1, field0,
@@ -2373,7 +2378,7 @@ static inline const char *xhci_decode_trb(u32 field0, u32 field1, u32 field2,
 			field3 & TRB_CYCLE ? 'C' : 'c');
 		break;
 	case TRB_RESET_EP:
-		sprintf(str,
+		snprintf(str, size,
 			"%s: ctx %08x%08x slot %d ep %d flags %c:%c",
 			xhci_trb_type_string(type),
 			field1, field0,
@@ -2394,7 +2399,7 @@ static inline const char *xhci_decode_trb(u32 field0, u32 field1, u32 field2,
 			field3 & TRB_CYCLE ? 'C' : 'c');
 		break;
 	case TRB_SET_DEQ:
-		sprintf(str,
+		snprintf(str, size,
 			"%s: deq %08x%08x stream %d slot %d ep %d flags %c",
 			xhci_trb_type_string(type),
 			field1, field0,
@@ -2405,14 +2410,14 @@ static inline const char *xhci_decode_trb(u32 field0, u32 field1, u32 field2,
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
@@ -2421,14 +2426,14 @@ static inline const char *xhci_decode_trb(u32 field0, u32 field1, u32 field2,
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
@@ -2437,7 +2442,7 @@ static inline const char *xhci_decode_trb(u32 field0, u32 field1, u32 field2,
 			field3 & TRB_CYCLE ? 'C' : 'c');
 		break;
 	case TRB_FORCE_HEADER:
-		sprintf(str,
+		snprintf(str, size,
 			"%s: info %08x%08x%08x pkt type %d roothub port %d flags %c",
 			xhci_trb_type_string(type),
 			field2, field1, field0 & 0xffffffe0,
@@ -2446,7 +2451,7 @@ static inline const char *xhci_decode_trb(u32 field0, u32 field1, u32 field2,
 			field3 & TRB_CYCLE ? 'C' : 'c');
 		break;
 	default:
-		sprintf(str,
+		snprintf(str, size,
 			"type '%s' -> raw %08x %08x %08x %08x",
 			xhci_trb_type_string(type),
 			field0, field1, field2, field3);
@@ -2455,10 +2460,9 @@ static inline const char *xhci_decode_trb(u32 field0, u32 field1, u32 field2,
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
 
@@ -2484,10 +2488,9 @@ static inline const char *xhci_decode_ctrl_ctx(unsigned long drop,
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
@@ -2571,9 +2574,8 @@ static inline const char *xhci_portsc_link_state_string(u32 portsc)
 	return "Unknown";
 }
 
-static inline const char *xhci_decode_portsc(u32 portsc)
+static inline const char *xhci_decode_portsc(char *str, u32 portsc)
 {
-	static char str[256];
 	int ret;
 
 	ret = sprintf(str, "%s %s %s Link:%s PortSpeed:%d ",
@@ -2617,9 +2619,8 @@ static inline const char *xhci_decode_portsc(u32 portsc)
 	return str;
 }
 
-static inline const char *xhci_decode_usbsts(u32 usbsts)
+static inline const char *xhci_decode_usbsts(char *str, u32 usbsts)
 {
-	static char str[256];
 	int ret = 0;
 
 	if (usbsts == ~(u32)0)
@@ -2646,9 +2647,8 @@ static inline const char *xhci_decode_usbsts(u32 usbsts)
 	return str;
 }
 
-static inline const char *xhci_decode_doorbell(u32 slot, u32 doorbell)
+static inline const char *xhci_decode_doorbell(char *str, u32 slot, u32 doorbell)
 {
-	static char str[256];
 	u8 ep;
 	u16 stream;
 	int ret;
@@ -2715,10 +2715,9 @@ static inline const char *xhci_ep_type_string(u8 type)
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
index 562f4357831e..6403f01947b2 100644
--- a/drivers/usb/mtu3/mtu3_core.c
+++ b/drivers/usb/mtu3/mtu3_core.c
@@ -227,11 +227,13 @@ static void mtu3_set_speed(struct mtu3 *mtu, enum usb_device_speed speed)
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
index 5e21ba05ebf0..a399fd84c71f 100644
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
