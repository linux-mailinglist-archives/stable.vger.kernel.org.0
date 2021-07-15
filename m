Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B4C03CA010
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 15:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232934AbhGONxV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 09:53:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:55096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232091AbhGONxU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 09:53:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C3B061374;
        Thu, 15 Jul 2021 13:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626357026;
        bh=aSkN+Ij+wQXqWvcxBZTcABrUG41nO3y5HLuhKuNuERM=;
        h=Subject:To:Cc:From:Date:From;
        b=wtUgFgeLcEp9UP5l6JGwE084lZX5Z65PptMjtfvBnJRw3TlTgftqPNFwg3PJIARQe
         KB1e+XY970Seq5W5unsse5d1LSgmlbk4xpAm4k2PHaPKzGRn/C4GOdw5zAxNM5aW3j
         Sj6cMSrn2XLqLZx4THLNpsgg/THXTmN0hZvenGvA=
Subject: FAILED: patch "[PATCH] PCI: Suspend/resume quirks for Apple thunderbolt" failed to apply to 4.9-stable tree
To:     andreas.noever@gmail.com, gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 15 Jul 2021 15:50:16 +0200
Message-ID: <162635701612934@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1df5172c5c251ec24a1bd0f44fe38c841f384330 Mon Sep 17 00:00:00 2001
From: Andreas Noever <andreas.noever@gmail.com>
Date: Tue, 3 Jun 2014 22:04:10 +0200
Subject: [PATCH] PCI: Suspend/resume quirks for Apple thunderbolt

Add two quirks to support thunderbolt suspend/resume on Apple systems.
We need to perform two different actions during suspend and resume:

The whole controller has to be powered down before suspend. If this is
not done then the native host interface device will be gone after resume
if a thunderbolt device was plugged in before suspending. The controller
represents itself as multiple PCI devices/bridges. To power it down we
hook into the upstream bridge of the controller and call the magic ACPI
methods.  Power will be restored automatically during resume (by the
firmware presumably).

During resume we have to wait for the native host interface to
reestablish all pci tunnels. Since there is no parent-child relationship
between the NHI and the bridges we have to explicitly wait for them
using device_pm_wait_for_dev. We do this in the resume_noirq phase of
the downstream bridges of the controller (which lead into the
thunderbolt tunnels).

Signed-off-by: Andreas Noever <andreas.noever@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 03266af20d5f..ca8a171f9689 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2986,6 +2986,103 @@ DECLARE_PCI_FIXUP_HEADER(0x1814, 0x0601, /* Ralink RT2800 802.11n PCI */
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_REALTEK, 0x8169,
 			 quirk_broken_intx_masking);
 
+#ifdef CONFIG_ACPI
+/*
+ * Apple: Shutdown Cactus Ridge Thunderbolt controller.
+ *
+ * On Apple hardware the Cactus Ridge Thunderbolt controller needs to be
+ * shutdown before suspend. Otherwise the native host interface (NHI) will not
+ * be present after resume if a device was plugged in before suspend.
+ *
+ * The thunderbolt controller consists of a pcie switch with downstream
+ * bridges leading to the NHI and to the tunnel pci bridges.
+ *
+ * This quirk cuts power to the whole chip. Therefore we have to apply it
+ * during suspend_noirq of the upstream bridge.
+ *
+ * Power is automagically restored before resume. No action is needed.
+ */
+static void quirk_apple_poweroff_thunderbolt(struct pci_dev *dev)
+{
+	acpi_handle bridge, SXIO, SXFP, SXLV;
+
+	if (!dmi_match(DMI_BOARD_VENDOR, "Apple Inc."))
+		return;
+	if (pci_pcie_type(dev) != PCI_EXP_TYPE_UPSTREAM)
+		return;
+	bridge = ACPI_HANDLE(&dev->dev);
+	if (!bridge)
+		return;
+	/*
+	 * SXIO and SXLV are present only on machines requiring this quirk.
+	 * TB bridges in external devices might have the same device id as those
+	 * on the host, but they will not have the associated ACPI methods. This
+	 * implicitly checks that we are at the right bridge.
+	 */
+	if (ACPI_FAILURE(acpi_get_handle(bridge, "DSB0.NHI0.SXIO", &SXIO))
+	    || ACPI_FAILURE(acpi_get_handle(bridge, "DSB0.NHI0.SXFP", &SXFP))
+	    || ACPI_FAILURE(acpi_get_handle(bridge, "DSB0.NHI0.SXLV", &SXLV)))
+		return;
+	dev_info(&dev->dev, "quirk: cutting power to thunderbolt controller...\n");
+
+	/* magic sequence */
+	acpi_execute_simple_method(SXIO, NULL, 1);
+	acpi_execute_simple_method(SXFP, NULL, 0);
+	msleep(300);
+	acpi_execute_simple_method(SXLV, NULL, 0);
+	acpi_execute_simple_method(SXIO, NULL, 0);
+	acpi_execute_simple_method(SXLV, NULL, 0);
+}
+DECLARE_PCI_FIXUP_SUSPEND_LATE(PCI_VENDOR_ID_INTEL, 0x1547,
+			       quirk_apple_poweroff_thunderbolt);
+
+/*
+ * Apple: Wait for the thunderbolt controller to reestablish pci tunnels.
+ *
+ * During suspend the thunderbolt controller is reset and all pci
+ * tunnels are lost. The NHI driver will try to reestablish all tunnels
+ * during resume. We have to manually wait for the NHI since there is
+ * no parent child relationship between the NHI and the tunneled
+ * bridges.
+ */
+static void quirk_apple_wait_for_thunderbolt(struct pci_dev *dev)
+{
+	struct pci_dev *sibling = NULL;
+	struct pci_dev *nhi = NULL;
+
+	if (!dmi_match(DMI_BOARD_VENDOR, "Apple Inc."))
+		return;
+	if (pci_pcie_type(dev) != PCI_EXP_TYPE_DOWNSTREAM)
+		return;
+	/*
+	 * Find the NHI and confirm that we are a bridge on the tb host
+	 * controller and not on a tb endpoint.
+	 */
+	sibling = pci_get_slot(dev->bus, 0x0);
+	if (sibling == dev)
+		goto out; /* we are the downstream bridge to the NHI */
+	if (!sibling || !sibling->subordinate)
+		goto out;
+	nhi = pci_get_slot(sibling->subordinate, 0x0);
+	if (!nhi)
+		goto out;
+	if (nhi->vendor != PCI_VENDOR_ID_INTEL
+			|| (nhi->device != 0x1547 && nhi->device != 0x156c)
+			|| nhi->subsystem_vendor != 0x2222
+			|| nhi->subsystem_device != 0x1111)
+		goto out;
+	dev_info(&dev->dev, "quirk: wating for thunderbolt to reestablish pci tunnels...\n");
+	device_pm_wait_for_dev(&dev->dev, &nhi->dev);
+out:
+	pci_dev_put(nhi);
+	pci_dev_put(sibling);
+}
+DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_INTEL, 0x1547,
+			       quirk_apple_wait_for_thunderbolt);
+DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_INTEL, 0x156d,
+			       quirk_apple_wait_for_thunderbolt);
+#endif
+
 static void pci_do_fixups(struct pci_dev *dev, struct pci_fixup *f,
 			  struct pci_fixup *end)
 {

