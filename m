Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDA6268ED9
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 16:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387631AbfGOOKG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 10:10:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:36220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388020AbfGOOKF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 10:10:05 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AADB4217D9;
        Mon, 15 Jul 2019 14:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563199804;
        bh=yuyWJT7EPxMrUOmJZg7Ls76M070nWs9+tJEYyfQUuX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0UVwvzkAYtWNLr9gr3wix9/gJ55B6TWZT01N+ilAVdCjM+OgC868MoDgz5dTlEcp0
         IJDjn7oTV4an+ZhPTOxcFbF0v5vrdvV/F3QD1y0VYuyLEq/8PebYnD7SGqlO9MffPf
         KPOrv0/ouZUBfMUCR7qqw5EEYO5DsH7OZdIwH0CI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 110/219] PCI: Add missing link delays required by the PCIe spec
Date:   Mon, 15 Jul 2019 10:01:51 -0400
Message-Id: <20190715140341.6443-110-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715140341.6443-1-sashal@kernel.org>
References: <20190715140341.6443-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit c2bf1fc212f7e6f25ace1af8f0b3ac061ea48ba5 ]

Currently Linux does not follow PCIe spec regarding the required delays
after reset. A concrete example is a Thunderbolt add-in-card that
consists of a PCIe switch and two PCIe endpoints:

  +-1b.0-[01-6b]----00.0-[02-6b]--+-00.0-[03]----00.0 TBT controller
                                  +-01.0-[04-36]-- DS hotplug port
                                  +-02.0-[37]----00.0 xHCI controller
                                  \-04.0-[38-6b]-- DS hotplug port

The root port (1b.0) and the PCIe switch downstream ports are all PCIe
gen3 so they support 8GT/s link speeds.

We wait for the PCIe hierarchy to enter D3cold (runtime):

  pcieport 0000:00:1b.0: power state changed by ACPI to D3cold

When it wakes up from D3cold, according to the PCIe 4.0 section 5.8 the
PCIe switch is put to reset and its power is re-applied. This means that
we must follow the rules in PCIe 4.0 section 6.6.1.

For the PCIe gen3 ports we are dealing with here, the following applies:

  With a Downstream Port that supports Link speeds greater than 5.0
  GT/s, software must wait a minimum of 100 ms after Link training
  completes before sending a Configuration Request to the device
  immediately below that Port. Software can determine when Link training
  completes by polling the Data Link Layer Link Active bit or by setting
  up an associated interrupt (see Section 6.7.3.3).

Translating this into the above topology we would need to do this (DLLLA
stands for Data Link Layer Link Active):

  pcieport 0000:00:1b.0: wait for 100ms after DLLLA is set before access to 0000:01:00.0
  pcieport 0000:02:00.0: wait for 100ms after DLLLA is set before access to 0000:03:00.0
  pcieport 0000:02:02.0: wait for 100ms after DLLLA is set before access to 0000:37:00.0

I've instrumented the kernel with additional logging so we can see the
actual delays the kernel performs:

  pcieport 0000:00:1b.0: power state changed by ACPI to D0
  pcieport 0000:00:1b.0: waiting for D3cold delay of 100 ms
  pcieport 0000:00:1b.0: waking up bus
  pcieport 0000:00:1b.0: waiting for D3hot delay of 10 ms
  pcieport 0000:00:1b.0: restoring config space at offset 0x2c (was 0x60, writing 0x60)
  ...
  pcieport 0000:00:1b.0: PME# disabled
  pcieport 0000:01:00.0: restoring config space at offset 0x3c (was 0x1ff, writing 0x201ff)
  ...
  pcieport 0000:01:00.0: PME# disabled
  pcieport 0000:02:00.0: restoring config space at offset 0x3c (was 0x1ff, writing 0x201ff)
  ...
  pcieport 0000:02:00.0: PME# disabled
  pcieport 0000:02:01.0: restoring config space at offset 0x3c (was 0x1ff, writing 0x201ff)
  ...
  pcieport 0000:02:01.0: restoring config space at offset 0x4 (was 0x100000, writing 0x100407)
  pcieport 0000:02:01.0: PME# disabled
  pcieport 0000:02:02.0: restoring config space at offset 0x3c (was 0x1ff, writing 0x201ff)
  ...
  pcieport 0000:02:02.0: PME# disabled
  pcieport 0000:02:04.0: restoring config space at offset 0x3c (was 0x1ff, writing 0x201ff)
  ...
  pcieport 0000:02:04.0: PME# disabled
  pcieport 0000:02:01.0: PME# enabled
  pcieport 0000:02:01.0: waiting for D3hot delay of 10 ms
  pcieport 0000:02:04.0: PME# enabled
  pcieport 0000:02:04.0: waiting for D3hot delay of 10 ms
  thunderbolt 0000:03:00.0: restoring config space at offset 0x14 (was 0x0, writing 0x8a040000)
  ...
  thunderbolt 0000:03:00.0: PME# disabled
  xhci_hcd 0000:37:00.0: restoring config space at offset 0x10 (was 0x0, writing 0x73f00000)
  ...
  xhci_hcd 0000:37:00.0: PME# disabled

For the switch upstream port (01:00.0) we wait for 100ms but not taking
into account the DLLLA requirement. We then wait 10ms for D3hot -> D0
transition of the root port and the two downstream hotplug ports. This
means that we deviate from what the spec requires.

Performing the same check for system sleep (s2idle) transitions we can
see following when resuming from s2idle:

  pcieport 0000:00:1b.0: power state changed by ACPI to D0
  pcieport 0000:00:1b.0: restoring config space at offset 0x2c (was 0x60, writing 0x60)
  ...
  pcieport 0000:01:00.0: restoring config space at offset 0x3c (was 0x1ff, writing 0x201ff)
  ...
  pcieport 0000:02:02.0: restoring config space at offset 0x3c (was 0x1ff, writing 0x201ff)
  pcieport 0000:02:02.0: restoring config space at offset 0x2c (was 0x0, writing 0x0)
  pcieport 0000:02:01.0: restoring config space at offset 0x3c (was 0x1ff, writing 0x201ff)
  pcieport 0000:02:04.0: restoring config space at offset 0x3c (was 0x1ff, writing 0x201ff)
  pcieport 0000:02:02.0: restoring config space at offset 0x28 (was 0x0, writing 0x0)
  pcieport 0000:02:00.0: restoring config space at offset 0x3c (was 0x1ff, writing 0x201ff)
  pcieport 0000:02:02.0: restoring config space at offset 0x24 (was 0x10001, writing 0x1fff1)
  pcieport 0000:02:01.0: restoring config space at offset 0x2c (was 0x0, writing 0x60)
  pcieport 0000:02:02.0: restoring config space at offset 0x20 (was 0x0, writing 0x73f073f0)
  pcieport 0000:02:04.0: restoring config space at offset 0x2c (was 0x0, writing 0x60)
  pcieport 0000:02:01.0: restoring config space at offset 0x28 (was 0x0, writing 0x60)
  pcieport 0000:02:00.0: restoring config space at offset 0x2c (was 0x0, writing 0x0)
  pcieport 0000:02:02.0: restoring config space at offset 0x1c (was 0x101, writing 0x1f1)
  pcieport 0000:02:04.0: restoring config space at offset 0x28 (was 0x0, writing 0x60)
  pcieport 0000:02:01.0: restoring config space at offset 0x24 (was 0x10001, writing 0x1ff10001)
  pcieport 0000:02:00.0: restoring config space at offset 0x28 (was 0x0, writing 0x0)
  pcieport 0000:02:02.0: restoring config space at offset 0x18 (was 0x0, writing 0x373702)
  pcieport 0000:02:04.0: restoring config space at offset 0x24 (was 0x10001, writing 0x49f12001)
  pcieport 0000:02:01.0: restoring config space at offset 0x20 (was 0x0, writing 0x73e05c00)
  pcieport 0000:02:00.0: restoring config space at offset 0x24 (was 0x10001, writing 0x1fff1)
  pcieport 0000:02:04.0: restoring config space at offset 0x20 (was 0x0, writing 0x89f07400)
  pcieport 0000:02:01.0: restoring config space at offset 0x1c (was 0x101, writing 0x5151)
  pcieport 0000:02:00.0: restoring config space at offset 0x20 (was 0x0, writing 0x8a008a00)
  pcieport 0000:02:02.0: restoring config space at offset 0xc (was 0x10000, writing 0x10020)
  pcieport 0000:02:04.0: restoring config space at offset 0x1c (was 0x101, writing 0x6161)
  pcieport 0000:02:01.0: restoring config space at offset 0x18 (was 0x0, writing 0x360402)
  pcieport 0000:02:00.0: restoring config space at offset 0x1c (was 0x101, writing 0x1f1)
  pcieport 0000:02:04.0: restoring config space at offset 0x18 (was 0x0, writing 0x6b3802)
  pcieport 0000:02:02.0: restoring config space at offset 0x4 (was 0x100000, writing 0x100407)
  pcieport 0000:02:00.0: restoring config space at offset 0x18 (was 0x0, writing 0x30302)
  pcieport 0000:02:01.0: restoring config space at offset 0xc (was 0x10000, writing 0x10020)
  pcieport 0000:02:04.0: restoring config space at offset 0xc (was 0x10000, writing 0x10020)
  pcieport 0000:02:00.0: restoring config space at offset 0xc (was 0x10000, writing 0x10020)
  pcieport 0000:02:01.0: restoring config space at offset 0x4 (was 0x100000, writing 0x100407)
  pcieport 0000:02:04.0: restoring config space at offset 0x4 (was 0x100000, writing 0x100407)
  pcieport 0000:02:00.0: restoring config space at offset 0x4 (was 0x100000, writing 0x100407)
  xhci_hcd 0000:37:00.0: restoring config space at offset 0x10 (was 0x0, writing 0x73f00000)
  ...
  thunderbolt 0000:03:00.0: restoring config space at offset 0x14 (was 0x0, writing 0x8a040000)

This is even worse. None of the mandatory delays are performed. If this
would be S3 instead of s2idle then according to PCI FW spec 3.2 section
4.6.8.  there is a specific _DSM that allows the OS to skip the delays
but this platform does not provide the _DSM and does not go to S3 anyway
so no firmware is involved that could already handle these delays.

In this particular Intel Coffee Lake platform these delays are not
actually needed because there is an additional delay as part of the ACPI
power resource that is used to turn on power to the hierarchy but since
that additional delay is not required by any of standards (PCIe, ACPI)
it is not present in the Intel Ice Lake, for example where missing the
mandatory delays causes pciehp to start tearing down the stack too early
(links are not yet trained).

For this reason, change the PCIe portdrv PM resume hooks so that they
perform the mandatory delays before the downstream component gets
resumed. We perform the delays before port services are resumed because
otherwise pciehp might find that the link is not up (even if it is just
training) and tears-down the hierarchy.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci.c               | 29 ++++++++++-----
 drivers/pci/pci.h               |  1 +
 drivers/pci/pcie/portdrv_core.c | 66 +++++++++++++++++++++++++++++++++
 3 files changed, 86 insertions(+), 10 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 766f5779db92..12013ebc3ebb 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -999,15 +999,10 @@ static void __pci_start_power_transition(struct pci_dev *dev, pci_power_t state)
 	if (state == PCI_D0) {
 		pci_platform_power_transition(dev, PCI_D0);
 		/*
-		 * Mandatory power management transition delays, see
-		 * PCI Express Base Specification Revision 2.0 Section
-		 * 6.6.1: Conventional Reset.  Do not delay for
-		 * devices powered on/off by corresponding bridge,
-		 * because have already delayed for the bridge.
+		 * Mandatory power management transition delays are
+		 * handled in the PCIe portdrv resume hooks.
 		 */
 		if (dev->runtime_d3cold) {
-			if (dev->d3cold_delay && !dev->imm_ready)
-				msleep(dev->d3cold_delay);
 			/*
 			 * When powering on a bridge from D3cold, the
 			 * whole hierarchy may be powered on into
@@ -4581,14 +4576,16 @@ static int pci_pm_reset(struct pci_dev *dev, int probe)
 
 	return pci_dev_wait(dev, "PM D3->D0", PCIE_RESET_READY_POLL_MS);
 }
+
 /**
- * pcie_wait_for_link - Wait until link is active or inactive
+ * pcie_wait_for_link_delay - Wait until link is active or inactive
  * @pdev: Bridge device
  * @active: waiting for active or inactive?
+ * @delay: Delay to wait after link has become active (in ms)
  *
  * Use this to wait till link becomes active or inactive.
  */
-bool pcie_wait_for_link(struct pci_dev *pdev, bool active)
+bool pcie_wait_for_link_delay(struct pci_dev *pdev, bool active, int delay)
 {
 	int timeout = 1000;
 	bool ret;
@@ -4625,13 +4622,25 @@ bool pcie_wait_for_link(struct pci_dev *pdev, bool active)
 		timeout -= 10;
 	}
 	if (active && ret)
-		msleep(100);
+		msleep(delay);
 	else if (ret != active)
 		pci_info(pdev, "Data Link Layer Link Active not %s in 1000 msec\n",
 			active ? "set" : "cleared");
 	return ret == active;
 }
 
+/**
+ * pcie_wait_for_link - Wait until link is active or inactive
+ * @pdev: Bridge device
+ * @active: waiting for active or inactive?
+ *
+ * Use this to wait till link becomes active or inactive.
+ */
+bool pcie_wait_for_link(struct pci_dev *pdev, bool active)
+{
+	return pcie_wait_for_link_delay(pdev, active, 100);
+}
+
 void pci_reset_secondary_bus(struct pci_dev *dev)
 {
 	u16 ctrl;
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 9cb99380c61e..59802b3def4b 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -493,6 +493,7 @@ static inline int pci_dev_specific_disable_acs_redir(struct pci_dev *dev)
 void pcie_do_recovery(struct pci_dev *dev, enum pci_channel_state state,
 		      u32 service);
 
+bool pcie_wait_for_link_delay(struct pci_dev *pdev, bool active, int delay);
 bool pcie_wait_for_link(struct pci_dev *pdev, bool active);
 #ifdef CONFIG_PCIEASPM
 void pcie_aspm_init_link_state(struct pci_dev *pdev);
diff --git a/drivers/pci/pcie/portdrv_core.c b/drivers/pci/pcie/portdrv_core.c
index 1b330129089f..308c3e0c4a34 100644
--- a/drivers/pci/pcie/portdrv_core.c
+++ b/drivers/pci/pcie/portdrv_core.c
@@ -9,6 +9,7 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/kernel.h>
+#include <linux/delay.h>
 #include <linux/errno.h>
 #include <linux/pm.h>
 #include <linux/pm_runtime.h>
@@ -378,6 +379,67 @@ static int pm_iter(struct device *dev, void *data)
 	return 0;
 }
 
+static int get_downstream_delay(struct pci_bus *bus)
+{
+	struct pci_dev *pdev;
+	int min_delay = 100;
+	int max_delay = 0;
+
+	list_for_each_entry(pdev, &bus->devices, bus_list) {
+		if (!pdev->imm_ready)
+			min_delay = 0;
+		else if (pdev->d3cold_delay < min_delay)
+			min_delay = pdev->d3cold_delay;
+		if (pdev->d3cold_delay > max_delay)
+			max_delay = pdev->d3cold_delay;
+	}
+
+	return max(min_delay, max_delay);
+}
+
+/*
+ * wait_for_downstream_link - Wait for downstream link to establish
+ * @pdev: PCIe port whose downstream link is waited
+ *
+ * Handle delays according to PCIe 4.0 section 6.6.1 before configuration
+ * access to the downstream component is permitted.
+ *
+ * This blocks PCI core resume of the hierarchy below this port until the
+ * link is trained. Should be called before resuming port services to
+ * prevent pciehp from starting to tear-down the hierarchy too soon.
+ */
+static void wait_for_downstream_link(struct pci_dev *pdev)
+{
+	int delay;
+
+	if (pci_pcie_type(pdev) != PCI_EXP_TYPE_ROOT_PORT &&
+	    pci_pcie_type(pdev) != PCI_EXP_TYPE_DOWNSTREAM)
+		return;
+
+	if (pci_dev_is_disconnected(pdev))
+		return;
+
+	if (!pdev->subordinate || list_empty(&pdev->subordinate->devices) ||
+	    !pdev->bridge_d3)
+		return;
+
+	delay = get_downstream_delay(pdev->subordinate);
+	if (!delay)
+		return;
+
+	dev_dbg(&pdev->dev, "waiting downstream link for %d ms\n", delay);
+
+	/*
+	 * If downstream port does not support speeds greater than 5 GT/s
+	 * need to wait 100ms. For higher speeds (gen3) we need to wait
+	 * first for the data link layer to become active.
+	 */
+	if (pcie_get_speed_cap(pdev) <= PCIE_SPEED_5_0GT)
+		msleep(delay);
+	else
+		pcie_wait_for_link_delay(pdev, true, delay);
+}
+
 /**
  * pcie_port_device_suspend - suspend port services associated with a PCIe port
  * @dev: PCI Express port to handle
@@ -391,6 +453,8 @@ int pcie_port_device_suspend(struct device *dev)
 int pcie_port_device_resume_noirq(struct device *dev)
 {
 	size_t off = offsetof(struct pcie_port_service_driver, resume_noirq);
+
+	wait_for_downstream_link(to_pci_dev(dev));
 	return device_for_each_child(dev, &off, pm_iter);
 }
 
@@ -421,6 +485,8 @@ int pcie_port_device_runtime_suspend(struct device *dev)
 int pcie_port_device_runtime_resume(struct device *dev)
 {
 	size_t off = offsetof(struct pcie_port_service_driver, runtime_resume);
+
+	wait_for_downstream_link(to_pci_dev(dev));
 	return device_for_each_child(dev, &off, pm_iter);
 }
 #endif /* PM */
-- 
2.20.1

