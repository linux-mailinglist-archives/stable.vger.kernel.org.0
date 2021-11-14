Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3021044F82D
	for <lists+stable@lfdr.de>; Sun, 14 Nov 2021 14:47:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233961AbhKNNuP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Nov 2021 08:50:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:40928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235272AbhKNNuL (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 14 Nov 2021 08:50:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D00E160C51;
        Sun, 14 Nov 2021 13:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636897631;
        bh=vTbGpshM9tBH4lvrwBvpBOFixqwtDWVz2jb2DjQISU8=;
        h=Subject:To:Cc:From:Date:From;
        b=T2J2BMYxHePr0wXdDECT455ZbVZyP1gSqIE2OiXR6FDLz/5/N7dMwtf3vF2kU+dMP
         hmy34fNvMKb2ZPuRPb2We5MNb5TLa9BQ04pxpMf7uqRZml+7MHKVPbKkAnWnbkwhA0
         DmLh2KdYORPSogwX5ZcEvLzRWVzvIGpg909YdfAo=
Subject: FAILED: patch "[PATCH] PCI: pciehp: Ignore Link Down/Up caused by error-induced Hot" failed to apply to 4.4-stable tree
To:     lukas@wunner.de, bhelgaas@google.com, kbusch@kernel.org,
        stuart.w.hayes@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 14 Nov 2021 14:47:08 +0100
Message-ID: <1636897628233216@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ea401499e943c307e6d44af6c2b4e068643e7884 Mon Sep 17 00:00:00 2001
From: Lukas Wunner <lukas@wunner.de>
Date: Sat, 31 Jul 2021 14:39:01 +0200
Subject: [PATCH] PCI: pciehp: Ignore Link Down/Up caused by error-induced Hot
 Reset

Stuart Hayes reports that an error handled by DPC at a Root Port results
in pciehp gratuitously bringing down a subordinate hotplug port:

  RP -- UP -- DP -- UP -- DP (hotplug) -- EP

pciehp brings the slot down because the Link to the Endpoint goes down.
That is caused by a Hot Reset being propagated as a result of DPC.
Per PCIe Base Spec 5.0, section 6.6.1 "Conventional Reset":

  For a Switch, the following must cause a hot reset to be sent on all
  Downstream Ports: [...]

  * The Data Link Layer of the Upstream Port reporting DL_Down status.
    In Switches that support Link speeds greater than 5.0 GT/s, the
    Upstream Port must direct the LTSSM of each Downstream Port to the
    Hot Reset state, but not hold the LTSSMs in that state. This permits
    each Downstream Port to begin Link training immediately after its
    hot reset completes. This behavior is recommended for all Switches.

  * Receiving a hot reset on the Upstream Port.

Once DPC recovers, pcie_do_recovery() walks down the hierarchy and
invokes pcie_portdrv_slot_reset() to restore each port's config space.
At that point, a hotplug interrupt is signaled per PCIe Base Spec r5.0,
section 6.7.3.4 "Software Notification of Hot-Plug Events":

  If the Port is enabled for edge-triggered interrupt signaling using
  MSI or MSI-X, an interrupt message must be sent every time the logical
  AND of the following conditions transitions from FALSE to TRUE: [...]

  * The Hot-Plug Interrupt Enable bit in the Slot Control register is
    set to 1b.

  * At least one hot-plug event status bit in the Slot Status register
    and its associated enable bit in the Slot Control register are both
    set to 1b.

Prevent pciehp from gratuitously bringing down the slot by clearing the
error-induced Data Link Layer State Changed event before restoring
config space.  Afterwards, check whether the link has unexpectedly
failed to retrain and synthesize a DLLSC event if so.

Allow each pcie_port_service_driver (one of them being pciehp) to define
a slot_reset callback and re-use the existing pm_iter() function to
iterate over the callbacks.

Thereby, the Endpoint driver remains bound throughout error recovery and
may restore the device to working state.

Surprise removal during error recovery is detected through a Presence
Detect Changed event.  The hotplug port is expected to not signal that
event as a result of a Hot Reset.

The issue isn't DPC-specific, it also occurs when an error is handled by
AER through aer_root_reset().  So while the issue was noticed only now,
it's been around since 2006 when AER support was first introduced.

[bhelgaas: drop PCI_ERROR_RECOVERY Kconfig, split pm_iter() rename to
preparatory patch]
Link: https://lore.kernel.org/linux-pci/08c046b0-c9f2-3489-eeef-7e7aca435bb9@gmail.com/
Fixes: 6c2b374d7485 ("PCI-Express AER implemetation: AER core and aerdriver")
Link: https://lore.kernel.org/r/251f4edcc04c14f873ff1c967bc686169cd07d2d.1627638184.git.lukas@wunner.de
Reported-by: Stuart Hayes <stuart.w.hayes@gmail.com>
Tested-by: Stuart Hayes <stuart.w.hayes@gmail.com>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org # v2.6.19+: ba952824e6c1: PCI/portdrv: Report reset for frozen channel
Cc: Keith Busch <kbusch@kernel.org>

diff --git a/drivers/pci/hotplug/pciehp.h b/drivers/pci/hotplug/pciehp.h
index 69fd401691be..918dccbc74b6 100644
--- a/drivers/pci/hotplug/pciehp.h
+++ b/drivers/pci/hotplug/pciehp.h
@@ -189,6 +189,8 @@ int pciehp_get_attention_status(struct hotplug_slot *hotplug_slot, u8 *status);
 int pciehp_set_raw_indicator_status(struct hotplug_slot *h_slot, u8 status);
 int pciehp_get_raw_indicator_status(struct hotplug_slot *h_slot, u8 *status);
 
+int pciehp_slot_reset(struct pcie_device *dev);
+
 static inline const char *slot_name(struct controller *ctrl)
 {
 	return hotplug_slot_name(&ctrl->hotplug_slot);
diff --git a/drivers/pci/hotplug/pciehp_core.c b/drivers/pci/hotplug/pciehp_core.c
index ad3393930ecb..f34114d45259 100644
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
index 3024d7e85e6a..83a0fa119cae 100644
--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -862,6 +862,32 @@ void pcie_disable_interrupt(struct controller *ctrl)
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
index 6126ee4676a7..41fe1ffd5907 100644
--- a/drivers/pci/pcie/portdrv.h
+++ b/drivers/pci/pcie/portdrv.h
@@ -85,6 +85,8 @@ struct pcie_port_service_driver {
 	int (*runtime_suspend)(struct pcie_device *dev);
 	int (*runtime_resume)(struct pcie_device *dev);
 
+	int (*slot_reset)(struct pcie_device *dev);
+
 	/* Device driver may resume normal operations */
 	void (*error_resume)(struct pci_dev *dev);
 
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

