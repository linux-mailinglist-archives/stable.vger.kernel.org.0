Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0127E56FC44
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbiGKJlj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:41:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233094AbiGKJkx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:40:53 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36C3A237CF;
        Mon, 11 Jul 2022 02:20:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9B11ECE1261;
        Mon, 11 Jul 2022 09:20:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91599C34115;
        Mon, 11 Jul 2022 09:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531247;
        bh=SnrEFLDJqgO83gv4EWKET/Q/vmfdBl5tVgv09mI+I4k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O9wBToZgIOB0qPU319k6Eu6dVI31JmEfCcaNxSQ5BxsLEe2YjJqWMzR5U9jp5oiaZ
         rzK5bKs5lHWMd4SuBtMS8Hkp8bup7BwOInYccWm74icnlkPPWCNY1JtEZva62SkcNB
         C7UyKwzndzZAH6Ue57gxrS7rX8kp3KiuPAPYuYBo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stuart Hayes <stuart.w.hayes@gmail.com>,
        Lukas Wunner <lukas@wunner.de>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Keith Busch <kbusch@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 035/230] PCI: pciehp: Ignore Link Down/Up caused by error-induced Hot Reset
Date:   Mon, 11 Jul 2022 11:04:51 +0200
Message-Id: <20220711090605.076186446@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Lukas Wunner <lukas@wunner.de>

[ Upstream commit ea401499e943c307e6d44af6c2b4e068643e7884 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/hotplug/pciehp.h      |  2 ++
 drivers/pci/hotplug/pciehp_core.c |  2 ++
 drivers/pci/hotplug/pciehp_hpc.c  | 26 ++++++++++++++++++++++++++
 drivers/pci/pcie/portdrv.h        |  2 ++
 drivers/pci/pcie/portdrv_pci.c    |  3 +++
 5 files changed, 35 insertions(+)

diff --git a/drivers/pci/hotplug/pciehp.h b/drivers/pci/hotplug/pciehp.h
index 10d7e7e1b553..e0a614acee05 100644
--- a/drivers/pci/hotplug/pciehp.h
+++ b/drivers/pci/hotplug/pciehp.h
@@ -192,6 +192,8 @@ int pciehp_get_attention_status(struct hotplug_slot *hotplug_slot, u8 *status);
 int pciehp_set_raw_indicator_status(struct hotplug_slot *h_slot, u8 status);
 int pciehp_get_raw_indicator_status(struct hotplug_slot *h_slot, u8 *status);
 
+int pciehp_slot_reset(struct pcie_device *dev);
+
 static inline const char *slot_name(struct controller *ctrl)
 {
 	return hotplug_slot_name(&ctrl->hotplug_slot);
diff --git a/drivers/pci/hotplug/pciehp_core.c b/drivers/pci/hotplug/pciehp_core.c
index e7fe4b42f039..4042d87d539d 100644
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
index 8bedbc77fe95..60098a701e83 100644
--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -865,6 +865,32 @@ void pcie_disable_interrupt(struct controller *ctrl)
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
-- 
2.35.1



