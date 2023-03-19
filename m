Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CBC06BFFA0
	for <lists+stable@lfdr.de>; Sun, 19 Mar 2023 07:50:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbjCSGu1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Mar 2023 02:50:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjCSGu0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Mar 2023 02:50:26 -0400
X-Greylist: delayed 468 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 18 Mar 2023 23:50:24 PDT
Received: from mailout1.hostsharing.net (mailout1.hostsharing.net [IPv6:2a01:37:1000::53df:5fcc:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14104CDFA
        for <stable@vger.kernel.org>; Sat, 18 Mar 2023 23:50:23 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL Global TLS RSA4096 SHA256 2022 CA1" (verified OK))
        by mailout1.hostsharing.net (Postfix) with ESMTPS id B3F4910190FBD;
        Sun, 19 Mar 2023 07:42:31 +0100 (CET)
Received: from localhost (unknown [89.246.108.87])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by h08.hostsharing.net (Postfix) with ESMTPSA id 7A7576031F35;
        Sun, 19 Mar 2023 07:42:31 +0100 (CET)
X-Mailbox-Line: From 50c1ab1e329d2fecafd69a8438ab91e5e3dcd572 Mon Sep 17 00:00:00 2001
Message-Id: <50c1ab1e329d2fecafd69a8438ab91e5e3dcd572.1679207873.git.lukas@wunner.de>
In-Reply-To: <167820491185214@kroah.com>
References: <167820491185214@kroah.com>
From:   Lukas Wunner <lukas@wunner.de>
Date:   Sun, 19 Mar 2023 07:42:00 +0100
Subject: [PATCH 5.4.y] PCI: Unify delay handling for reset and resume
To:     <stable@vger.kernel.org>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Ravi Kishore Koppuravuri" <ravi.kishore.koppuravuri@intel.com>,
        Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Sheng Bi <windy.bi.enflame@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit ac91e6980563ed53afadd925fa6585ffd2bc4a2c upstream.

Sheng Bi reports that pci_bridge_secondary_bus_reset() may fail to wait
for devices on the secondary bus to become accessible after reset:

Although it does call pci_dev_wait(), it erroneously passes the bridge's
pci_dev rather than that of a child.  The bridge of course is always
accessible while its secondary bus is reset, so pci_dev_wait() returns
immediately.

Sheng Bi proposes introducing a new pci_bridge_secondary_bus_wait()
function which is called from pci_bridge_secondary_bus_reset():

https://lore.kernel.org/linux-pci/20220523171517.32407-1-windy.bi.enflame@gmail.com/

However we already have pci_bridge_wait_for_secondary_bus() which does
almost exactly what we need.  So far it's only called on resume from
D3cold (which implies a Fundamental Reset per PCIe r6.0 sec 5.8).
Re-using it for Secondary Bus Resets is a leaner and more rational
approach than introducing a new function.

That only requires a few minor tweaks:

- Amend pci_bridge_wait_for_secondary_bus() to await accessibility of
  the first device on the secondary bus by calling pci_dev_wait() after
  performing the prescribed delays.  pci_dev_wait() needs two parameters,
  a reset reason and a timeout, which callers must now pass to
  pci_bridge_wait_for_secondary_bus().  The timeout is 1 sec for resume
  (PCIe r6.0 sec 6.6.1) and 60 sec for reset (commit 821cdad5c46c ("PCI:
  Wait up to 60 seconds for device to become ready after FLR")).
  Introduce a PCI_RESET_WAIT macro for the 1 sec timeout.

- Amend pci_bridge_wait_for_secondary_bus() to return 0 on success or
  -ENOTTY on error for consumption by pci_bridge_secondary_bus_reset().

- Drop an unnecessary 1 sec delay from pci_reset_secondary_bus() which
  is now performed by pci_bridge_wait_for_secondary_bus().  A static
  delay this long is only necessary for Conventional PCI, so modern
  PCIe systems benefit from shorter reset times as a side effect.

Fixes: 6b2f1351af56 ("PCI: Wait for device to become ready after secondary bus reset")
Link: https://lore.kernel.org/r/da77c92796b99ec568bd070cbe4725074a117038.1673769517.git.lukas@wunner.de
Reported-by: Sheng Bi <windy.bi.enflame@gmail.com>
Tested-by: Ravi Kishore Koppuravuri <ravi.kishore.koppuravuri@intel.com>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Cc: stable@vger.kernel.org # v4.17+
---
 drivers/pci/pci-driver.c |  4 +--
 drivers/pci/pci.c        | 54 ++++++++++++++++++----------------------
 drivers/pci/pci.h        | 10 +++++++-
 3 files changed, 35 insertions(+), 33 deletions(-)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 5ea612a15550..70c8584b3ffc 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -946,7 +946,7 @@ static int pci_pm_resume_noirq(struct device *dev)
 	pcie_pme_root_status_cleanup(pci_dev);
 
 	if (!skip_bus_pm && prev_state == PCI_D3cold)
-		pci_bridge_wait_for_secondary_bus(pci_dev);
+		pci_bridge_wait_for_secondary_bus(pci_dev, "resume", PCI_RESET_WAIT);
 
 	if (pci_has_legacy_pm_support(pci_dev))
 		return pci_legacy_resume_early(dev);
@@ -1355,7 +1355,7 @@ static int pci_pm_runtime_resume(struct device *dev)
 	pci_fixup_device(pci_fixup_resume, pci_dev);
 
 	if (prev_state == PCI_D3cold)
-		pci_bridge_wait_for_secondary_bus(pci_dev);
+		pci_bridge_wait_for_secondary_bus(pci_dev, "resume", PCI_RESET_WAIT);
 
 	if (pm && pm->runtime_resume)
 		rc = pm->runtime_resume(dev);
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 365b9ed6d815..f8c730b6701b 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -4483,7 +4483,7 @@ static int pci_dev_wait(struct pci_dev *dev, char *reset_type, int timeout)
 			return -ENOTTY;
 		}
 
-		if (delay > 1000)
+		if (delay > PCI_RESET_WAIT)
 			pci_info(dev, "not ready %dms after %s; waiting\n",
 				 delay - 1, reset_type);
 
@@ -4492,7 +4492,7 @@ static int pci_dev_wait(struct pci_dev *dev, char *reset_type, int timeout)
 		pci_read_config_dword(dev, PCI_COMMAND, &id);
 	}
 
-	if (delay > 1000)
+	if (delay > PCI_RESET_WAIT)
 		pci_info(dev, "ready %dms after %s\n", delay - 1,
 			 reset_type);
 
@@ -4727,24 +4727,31 @@ static int pci_bus_max_d3cold_delay(const struct pci_bus *bus)
 /**
  * pci_bridge_wait_for_secondary_bus - Wait for secondary bus to be accessible
  * @dev: PCI bridge
+ * @reset_type: reset type in human-readable form
+ * @timeout: maximum time to wait for devices on secondary bus (milliseconds)
  *
  * Handle necessary delays before access to the devices on the secondary
- * side of the bridge are permitted after D3cold to D0 transition.
+ * side of the bridge are permitted after D3cold to D0 transition
+ * or Conventional Reset.
  *
  * For PCIe this means the delays in PCIe 5.0 section 6.6.1. For
  * conventional PCI it means Tpvrh + Trhfa specified in PCI 3.0 section
  * 4.3.2.
+ *
+ * Return 0 on success or -ENOTTY if the first device on the secondary bus
+ * failed to become accessible.
  */
-void pci_bridge_wait_for_secondary_bus(struct pci_dev *dev)
+int pci_bridge_wait_for_secondary_bus(struct pci_dev *dev, char *reset_type,
+				      int timeout)
 {
 	struct pci_dev *child;
 	int delay;
 
 	if (pci_dev_is_disconnected(dev))
-		return;
+		return 0;
 
 	if (!pci_is_bridge(dev))
-		return;
+		return 0;
 
 	down_read(&pci_bus_sem);
 
@@ -4756,14 +4763,14 @@ void pci_bridge_wait_for_secondary_bus(struct pci_dev *dev)
 	 */
 	if (!dev->subordinate || list_empty(&dev->subordinate->devices)) {
 		up_read(&pci_bus_sem);
-		return;
+		return 0;
 	}
 
 	/* Take d3cold_delay requirements into account */
 	delay = pci_bus_max_d3cold_delay(dev->subordinate);
 	if (!delay) {
 		up_read(&pci_bus_sem);
-		return;
+		return 0;
 	}
 
 	child = list_first_entry(&dev->subordinate->devices, struct pci_dev,
@@ -4772,14 +4779,12 @@ void pci_bridge_wait_for_secondary_bus(struct pci_dev *dev)
 
 	/*
 	 * Conventional PCI and PCI-X we need to wait Tpvrh + Trhfa before
-	 * accessing the device after reset (that is 1000 ms + 100 ms). In
-	 * practice this should not be needed because we don't do power
-	 * management for them (see pci_bridge_d3_possible()).
+	 * accessing the device after reset (that is 1000 ms + 100 ms).
 	 */
 	if (!pci_is_pcie(dev)) {
 		pci_dbg(dev, "waiting %d ms for secondary bus\n", 1000 + delay);
 		msleep(1000 + delay);
-		return;
+		return 0;
 	}
 
 	/*
@@ -4796,11 +4801,11 @@ void pci_bridge_wait_for_secondary_bus(struct pci_dev *dev)
 	 * configuration requests if we only wait for 100 ms (see
 	 * https://bugzilla.kernel.org/show_bug.cgi?id=203885).
 	 *
-	 * Therefore we wait for 100 ms and check for the device presence.
-	 * If it is still not present give it an additional 100 ms.
+	 * Therefore we wait for 100 ms and check for the device presence
+	 * until the timeout expires.
 	 */
 	if (!pcie_downstream_port(dev))
-		return;
+		return 0;
 
 	if (pcie_get_speed_cap(dev) <= PCIE_SPEED_5_0GT) {
 		pci_dbg(dev, "waiting %d ms for downstream link\n", delay);
@@ -4810,14 +4815,11 @@ void pci_bridge_wait_for_secondary_bus(struct pci_dev *dev)
 			delay);
 		if (!pcie_wait_for_link_delay(dev, true, delay)) {
 			/* Did not train, no need to wait any further */
-			return;
+			return -ENOTTY;
 		}
 	}
 
-	if (!pci_device_is_present(child)) {
-		pci_dbg(child, "waiting additional %d ms to become accessible\n", delay);
-		msleep(delay);
-	}
+	return pci_dev_wait(child, reset_type, timeout - delay);
 }
 
 void pci_reset_secondary_bus(struct pci_dev *dev)
@@ -4836,15 +4838,6 @@ void pci_reset_secondary_bus(struct pci_dev *dev)
 
 	ctrl &= ~PCI_BRIDGE_CTL_BUS_RESET;
 	pci_write_config_word(dev, PCI_BRIDGE_CONTROL, ctrl);
-
-	/*
-	 * Trhfa for conventional PCI is 2^25 clock cycles.
-	 * Assuming a minimum 33MHz clock this results in a 1s
-	 * delay before we can consider subordinate devices to
-	 * be re-initialized.  PCIe has some ways to shorten this,
-	 * but we don't make use of them yet.
-	 */
-	ssleep(1);
 }
 
 void __weak pcibios_reset_secondary_bus(struct pci_dev *dev)
@@ -4863,7 +4856,8 @@ int pci_bridge_secondary_bus_reset(struct pci_dev *dev)
 {
 	pcibios_reset_secondary_bus(dev);
 
-	return pci_dev_wait(dev, "bus reset", PCIE_RESET_READY_POLL_MS);
+	return pci_bridge_wait_for_secondary_bus(dev, "bus reset",
+						 PCIE_RESET_READY_POLL_MS);
 }
 EXPORT_SYMBOL_GPL(pci_bridge_secondary_bus_reset);
 
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 2db1e2bee215..725d2b0d4569 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -47,6 +47,13 @@ int pci_bus_error_reset(struct pci_dev *dev);
 #define PCI_PM_D3COLD_WAIT      100
 #define PCI_PM_BUS_WAIT         50
 
+/*
+ * Following exit from Conventional Reset, devices must be ready within 1 sec
+ * (PCIe r6.0 sec 6.6.1).  A D3cold to D0 transition implies a Conventional
+ * Reset (PCIe r6.0 sec 5.8).
+ */
+#define PCI_RESET_WAIT		1000	/* msec */
+
 /**
  * struct pci_platform_pm_ops - Firmware PM callbacks
  *
@@ -107,7 +114,8 @@ void pci_allocate_cap_save_buffers(struct pci_dev *dev);
 void pci_free_cap_save_buffers(struct pci_dev *dev);
 bool pci_bridge_d3_possible(struct pci_dev *dev);
 void pci_bridge_d3_update(struct pci_dev *dev);
-void pci_bridge_wait_for_secondary_bus(struct pci_dev *dev);
+int pci_bridge_wait_for_secondary_bus(struct pci_dev *dev, char *reset_type,
+				      int timeout);
 
 static inline void pci_wakeup_event(struct pci_dev *dev)
 {
-- 
2.39.2

