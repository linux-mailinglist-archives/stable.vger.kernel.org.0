Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5098A1AF0C1
	for <lists+stable@lfdr.de>; Sat, 18 Apr 2020 16:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728345AbgDROwC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Apr 2020 10:52:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:52452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728328AbgDROmZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 18 Apr 2020 10:42:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3E0E22250;
        Sat, 18 Apr 2020 14:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587220944;
        bh=xnodsSzlqg3ymuvDfcYdShdmvJ5EVROWyPn26FtHWXs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=waFpSdVU8IbIfFOY/uNcjmHLyeaPoRDwANIey2g/ZMFm5cZ+3SkmnyqP5xk/vPRch
         MyVqOelnls7G4Xyt2rgU4Rkr8C/aWerFrfP9nIGgDD1kzXlHdjaOXmcJn81k+G7SLV
         iToDLjlm7VOKQyDKrJ/3BC7UuLcwsfyxtO4eiVkI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mika Westerberg <mika.westerberg@linux.intel.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 78/78] PCI/PM: Add missing link delays required by the PCIe spec
Date:   Sat, 18 Apr 2020 10:40:47 -0400
Message-Id: <20200418144047.9013-78-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200418144047.9013-1-sashal@kernel.org>
References: <20200418144047.9013-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit ad9001f2f41198784b0423646450ba2cb24793a3 ]

Currently Linux does not follow PCIe spec regarding the required delays
after reset. A concrete example is a Thunderbolt add-in-card that consists
of a PCIe switch and two PCIe endpoints:

  +-1b.0-[01-6b]----00.0-[02-6b]--+-00.0-[03]----00.0 TBT controller
                                  +-01.0-[04-36]-- DS hotplug port
                                  +-02.0-[37]----00.0 xHCI controller
                                  \-04.0-[38-6b]-- DS hotplug port

The root port (1b.0) and the PCIe switch downstream ports are all PCIe Gen3
so they support 8GT/s link speeds.

We wait for the PCIe hierarchy to enter D3cold (runtime):

  pcieport 0000:00:1b.0: power state changed by ACPI to D3cold

When it wakes up from D3cold, according to the PCIe 5.0 section 5.8 the
PCIe switch is put to reset and its power is re-applied. This means that we
must follow the rules in PCIe 5.0 section 6.6.1.

For the PCIe Gen3 ports we are dealing with here, the following applies:

  With a Downstream Port that supports Link speeds greater than 5.0 GT/s,
  software must wait a minimum of 100 ms after Link training completes
  before sending a Configuration Request to the device immediately below
  that Port. Software can determine when Link training completes by polling
  the Data Link Layer Link Active bit or by setting up an associated
  interrupt (see Section 6.7.3.3).

Translating this into the above topology we would need to do this (DLLLA
stands for Data Link Layer Link Active):

  0000:00:1b.0: wait for 100 ms after DLLLA is set before access to 0000:01:00.0
  0000:02:00.0: wait for 100 ms after DLLLA is set before access to 0000:03:00.0
  0000:02:02.0: wait for 100 ms after DLLLA is set before access to 0000:37:00.0

I've instrumented the kernel with some additional logging so we can see the
actual delays performed:

  pcieport 0000:00:1b.0: power state changed by ACPI to D0
  pcieport 0000:00:1b.0: waiting for D3cold delay of 100 ms
  pcieport 0000:00:1b.0: waiting for D3hot delay of 10 ms
  pcieport 0000:02:01.0: waiting for D3hot delay of 10 ms
  pcieport 0000:02:04.0: waiting for D3hot delay of 10 ms

For the switch upstream port (01:00.0 reachable through 00:1b.0 root port)
we wait for 100 ms but not taking into account the DLLLA requirement. We
then wait 10 ms for D3hot -> D0 transition of the root port and the two
downstream hotplug ports. This means that we deviate from what the spec
requires.

Performing the same check for system sleep (s2idle) transitions it turns
out to be even worse. None of the mandatory delays are performed. If this
would be S3 instead of s2idle then according to PCI FW spec 3.2 section
4.6.8. there is a specific _DSM that allows the OS to skip the delays but
this platform does not provide the _DSM and does not go to S3 anyway so no
firmware is involved that could already handle these delays.

On this particular platform these delays are not actually needed because
there is an additional delay as part of the ACPI power resource that is
used to turn on power to the hierarchy but since that additional delay is
not required by any of standards (PCIe, ACPI) it is not present in the
Intel Ice Lake, for example where missing the mandatory delays causes
pciehp to start tearing down the stack too early (links are not yet
trained). Below is an example how it looks like when this happens:

  pcieport 0000:83:04.0: pciehp: Slot(4): Card not present
  pcieport 0000:87:04.0: PME# disabled
  pcieport 0000:83:04.0: pciehp: pciehp_unconfigure_device: domain:bus:dev = 0000:86:00
  pcieport 0000:86:00.0: Refused to change power state, currently in D3
  pcieport 0000:86:00.0: restoring config space at offset 0x3c (was 0xffffffff, writing 0x201ff)
  pcieport 0000:86:00.0: restoring config space at offset 0x38 (was 0xffffffff, writing 0x0)
  ...

There is also one reported case (see the bugzilla link below) where the
missing delay causes xHCI on a Titan Ridge controller fail to runtime
resume when USB-C dock is plugged. This does not involve pciehp but instead
the PCI core fails to runtime resume the xHCI device:

  pcieport 0000:04:02.0: restoring config space at offset 0xc (was 0x10000, writing 0x10020)
  pcieport 0000:04:02.0: restoring config space at offset 0x4 (was 0x100000, writing 0x100406)
  xhci_hcd 0000:39:00.0: Refused to change power state, currently in D3
  xhci_hcd 0000:39:00.0: restoring config space at offset 0x3c (was 0xffffffff, writing 0x1ff)
  xhci_hcd 0000:39:00.0: restoring config space at offset 0x38 (was 0xffffffff, writing 0x0)
  ...

Add a new function pci_bridge_wait_for_secondary_bus() that is called on
PCI core resume and runtime resume paths accordingly if the bridge entered
D3cold (and thus went through reset).

This is second attempt to add the missing delays. The previous solution in
c2bf1fc212f7 ("PCI: Add missing link delays required by the PCIe spec") was
reverted because of two issues it caused:

  1. One system become unresponsive after S3 resume due to PME service
     spinning in pcie_pme_work_fn(). The root port in question reports that
     the xHCI sent PME but the xHCI device itself does not have PME status
     set. The PME status bit is never cleared in the root port resulting
     the indefinite loop in pcie_pme_work_fn().

  2. Slows down resume if the root/downstream port does not support Data
     Link Layer Active Reporting because pcie_wait_for_link_delay() waits
     1100 ms in that case.

This version should avoid the above issues because we restrict the delay to
happen only if the port went into D3cold.

Link: https://lore.kernel.org/linux-pci/SL2P216MB01878BBCD75F21D882AEEA2880C60@SL2P216MB0187.KORP216.PROD.OUTLOOK.COM/
Link: https://bugzilla.kernel.org/show_bug.cgi?id=203885
Link: https://lore.kernel.org/r/20191112091617.70282-3-mika.westerberg@linux.intel.com
Reported-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Tested-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci-driver.c |  11 +++-
 drivers/pci/pci.c        | 121 ++++++++++++++++++++++++++++++++++++++-
 drivers/pci/pci.h        |   1 +
 3 files changed, 130 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 0c3086793e4ec..5ea612a15550e 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -919,6 +919,8 @@ static int pci_pm_resume_noirq(struct device *dev)
 	struct pci_dev *pci_dev = to_pci_dev(dev);
 	struct device_driver *drv = dev->driver;
 	int error = 0;
+	pci_power_t prev_state = pci_dev->current_state;
+	bool skip_bus_pm = pci_dev->skip_bus_pm;
 
 	if (dev_pm_may_skip_resume(dev))
 		return 0;
@@ -937,12 +939,15 @@ static int pci_pm_resume_noirq(struct device *dev)
 	 * configuration here and attempting to put them into D0 again is
 	 * pointless, so avoid doing that.
 	 */
-	if (!(pci_dev->skip_bus_pm && pm_suspend_no_platform()))
+	if (!(skip_bus_pm && pm_suspend_no_platform()))
 		pci_pm_default_resume_early(pci_dev);
 
 	pci_fixup_device(pci_fixup_resume_early, pci_dev);
 	pcie_pme_root_status_cleanup(pci_dev);
 
+	if (!skip_bus_pm && prev_state == PCI_D3cold)
+		pci_bridge_wait_for_secondary_bus(pci_dev);
+
 	if (pci_has_legacy_pm_support(pci_dev))
 		return pci_legacy_resume_early(dev);
 
@@ -1333,6 +1338,7 @@ static int pci_pm_runtime_resume(struct device *dev)
 	int rc = 0;
 	struct pci_dev *pci_dev = to_pci_dev(dev);
 	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
+	pci_power_t prev_state = pci_dev->current_state;
 
 	/*
 	 * Restoring config space is necessary even if the device is not bound
@@ -1348,6 +1354,9 @@ static int pci_pm_runtime_resume(struct device *dev)
 	pci_enable_wake(pci_dev, PCI_D0, false);
 	pci_fixup_device(pci_fixup_resume, pci_dev);
 
+	if (prev_state == PCI_D3cold)
+		pci_bridge_wait_for_secondary_bus(pci_dev);
+
 	if (pm && pm->runtime_resume)
 		rc = pm->runtime_resume(dev);
 
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 94d6e120b4734..779132aef0fb9 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1019,8 +1019,6 @@ static void __pci_start_power_transition(struct pci_dev *dev, pci_power_t state)
 		 * because have already delayed for the bridge.
 		 */
 		if (dev->runtime_d3cold) {
-			if (dev->d3cold_delay && !dev->imm_ready)
-				msleep(dev->d3cold_delay);
 			/*
 			 * When powering on a bridge from D3cold, the
 			 * whole hierarchy may be powered on into
@@ -4671,6 +4669,125 @@ bool pcie_wait_for_link(struct pci_dev *pdev, bool active)
 	return pcie_wait_for_link_delay(pdev, active, 100);
 }
 
+/*
+ * Find maximum D3cold delay required by all the devices on the bus.  The
+ * spec says 100 ms, but firmware can lower it and we allow drivers to
+ * increase it as well.
+ *
+ * Called with @pci_bus_sem locked for reading.
+ */
+static int pci_bus_max_d3cold_delay(const struct pci_bus *bus)
+{
+	const struct pci_dev *pdev;
+	int min_delay = 100;
+	int max_delay = 0;
+
+	list_for_each_entry(pdev, &bus->devices, bus_list) {
+		if (pdev->d3cold_delay < min_delay)
+			min_delay = pdev->d3cold_delay;
+		if (pdev->d3cold_delay > max_delay)
+			max_delay = pdev->d3cold_delay;
+	}
+
+	return max(min_delay, max_delay);
+}
+
+/**
+ * pci_bridge_wait_for_secondary_bus - Wait for secondary bus to be accessible
+ * @dev: PCI bridge
+ *
+ * Handle necessary delays before access to the devices on the secondary
+ * side of the bridge are permitted after D3cold to D0 transition.
+ *
+ * For PCIe this means the delays in PCIe 5.0 section 6.6.1. For
+ * conventional PCI it means Tpvrh + Trhfa specified in PCI 3.0 section
+ * 4.3.2.
+ */
+void pci_bridge_wait_for_secondary_bus(struct pci_dev *dev)
+{
+	struct pci_dev *child;
+	int delay;
+
+	if (pci_dev_is_disconnected(dev))
+		return;
+
+	if (!pci_is_bridge(dev) || !dev->bridge_d3)
+		return;
+
+	down_read(&pci_bus_sem);
+
+	/*
+	 * We only deal with devices that are present currently on the bus.
+	 * For any hot-added devices the access delay is handled in pciehp
+	 * board_added(). In case of ACPI hotplug the firmware is expected
+	 * to configure the devices before OS is notified.
+	 */
+	if (!dev->subordinate || list_empty(&dev->subordinate->devices)) {
+		up_read(&pci_bus_sem);
+		return;
+	}
+
+	/* Take d3cold_delay requirements into account */
+	delay = pci_bus_max_d3cold_delay(dev->subordinate);
+	if (!delay) {
+		up_read(&pci_bus_sem);
+		return;
+	}
+
+	child = list_first_entry(&dev->subordinate->devices, struct pci_dev,
+				 bus_list);
+	up_read(&pci_bus_sem);
+
+	/*
+	 * Conventional PCI and PCI-X we need to wait Tpvrh + Trhfa before
+	 * accessing the device after reset (that is 1000 ms + 100 ms). In
+	 * practice this should not be needed because we don't do power
+	 * management for them (see pci_bridge_d3_possible()).
+	 */
+	if (!pci_is_pcie(dev)) {
+		pci_dbg(dev, "waiting %d ms for secondary bus\n", 1000 + delay);
+		msleep(1000 + delay);
+		return;
+	}
+
+	/*
+	 * For PCIe downstream and root ports that do not support speeds
+	 * greater than 5 GT/s need to wait minimum 100 ms. For higher
+	 * speeds (gen3) we need to wait first for the data link layer to
+	 * become active.
+	 *
+	 * However, 100 ms is the minimum and the PCIe spec says the
+	 * software must allow at least 1s before it can determine that the
+	 * device that did not respond is a broken device. There is
+	 * evidence that 100 ms is not always enough, for example certain
+	 * Titan Ridge xHCI controller does not always respond to
+	 * configuration requests if we only wait for 100 ms (see
+	 * https://bugzilla.kernel.org/show_bug.cgi?id=203885).
+	 *
+	 * Therefore we wait for 100 ms and check for the device presence.
+	 * If it is still not present give it an additional 100 ms.
+	 */
+	if (!pcie_downstream_port(dev))
+		return;
+
+	if (pcie_get_speed_cap(dev) <= PCIE_SPEED_5_0GT) {
+		pci_dbg(dev, "waiting %d ms for downstream link\n", delay);
+		msleep(delay);
+	} else {
+		pci_dbg(dev, "waiting %d ms for downstream link, after activation\n",
+			delay);
+		if (!pcie_wait_for_link_delay(dev, true, delay)) {
+			/* Did not train, no need to wait any further */
+			return;
+		}
+	}
+
+	if (!pci_device_is_present(child)) {
+		pci_dbg(child, "waiting additional %d ms to become accessible\n", delay);
+		msleep(delay);
+	}
+}
+
 void pci_reset_secondary_bus(struct pci_dev *dev)
 {
 	u16 ctrl;
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 273d60cb0762d..a5adc2e2c351d 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -107,6 +107,7 @@ void pci_allocate_cap_save_buffers(struct pci_dev *dev);
 void pci_free_cap_save_buffers(struct pci_dev *dev);
 bool pci_bridge_d3_possible(struct pci_dev *dev);
 void pci_bridge_d3_update(struct pci_dev *dev);
+void pci_bridge_wait_for_secondary_bus(struct pci_dev *dev);
 
 static inline void pci_wakeup_event(struct pci_dev *dev)
 {
-- 
2.20.1

