Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B77026AF2D5
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:56:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233505AbjCGS4w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:56:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233511AbjCGS4c (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:56:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1928CB652
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:43:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 49D5BB8199A
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:43:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E439C433EF;
        Tue,  7 Mar 2023 18:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678214637;
        bh=GZwodpomZ3tAmN4fquzZldiee6mY0ngUUl2J0LZxdyw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mEhbnXtU/SxltmrwOTmiYi41lrmE2xaNbFZYdXHQN21AYVWFT0XdeKwUCHku1AZtF
         QCQvUwgtd6VrU290vh2FlHD90p65F3QP6Nq3936vh+YZ+Agrz4LH2mDuZ4cmuG3qkM
         RSx5NQn+Y9BjiBZeaxsaoSNDPP2H458oEbBFawFc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sheng Bi <windy.bi.enflame@gmail.com>,
        Ravi Kishore Koppuravuri <ravi.kishore.koppuravuri@intel.com>,
        Lukas Wunner <lukas@wunner.de>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Kuppuswamy Sathyanarayanan 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: [PATCH 6.1 865/885] PCI: Unify delay handling for reset and resume
Date:   Tue,  7 Mar 2023 18:03:19 +0100
Message-Id: <20230307170039.337578688@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/pci-driver.c |    2 -
 drivers/pci/pci.c        |   54 ++++++++++++++++++++---------------------------
 drivers/pci/pci.h        |   10 +++++++-
 3 files changed, 34 insertions(+), 32 deletions(-)

--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -572,7 +572,7 @@ static void pci_pm_default_resume_early(
 
 static void pci_pm_bridge_power_up_actions(struct pci_dev *pci_dev)
 {
-	pci_bridge_wait_for_secondary_bus(pci_dev);
+	pci_bridge_wait_for_secondary_bus(pci_dev, "resume", PCI_RESET_WAIT);
 	/*
 	 * When powering on a bridge from D3cold, the whole hierarchy may be
 	 * powered on into D0uninitialized state, resume them to give them a
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1174,7 +1174,7 @@ static int pci_dev_wait(struct pci_dev *
 			return -ENOTTY;
 		}
 
-		if (delay > 1000)
+		if (delay > PCI_RESET_WAIT)
 			pci_info(dev, "not ready %dms after %s; waiting\n",
 				 delay - 1, reset_type);
 
@@ -1183,7 +1183,7 @@ static int pci_dev_wait(struct pci_dev *
 		pci_read_config_dword(dev, PCI_COMMAND, &id);
 	}
 
-	if (delay > 1000)
+	if (delay > PCI_RESET_WAIT)
 		pci_info(dev, "ready %dms after %s\n", delay - 1,
 			 reset_type);
 
@@ -4941,24 +4941,31 @@ static int pci_bus_max_d3cold_delay(cons
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
 
@@ -4970,14 +4977,14 @@ void pci_bridge_wait_for_secondary_bus(s
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
@@ -4986,14 +4993,12 @@ void pci_bridge_wait_for_secondary_bus(s
 
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
@@ -5010,11 +5015,11 @@ void pci_bridge_wait_for_secondary_bus(s
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
@@ -5025,14 +5030,11 @@ void pci_bridge_wait_for_secondary_bus(s
 		if (!pcie_wait_for_link_delay(dev, true, delay)) {
 			/* Did not train, no need to wait any further */
 			pci_info(dev, "Data Link Layer Link Active not set in 1000 msec\n");
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
@@ -5051,15 +5053,6 @@ void pci_reset_secondary_bus(struct pci_
 
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
@@ -5078,7 +5071,8 @@ int pci_bridge_secondary_bus_reset(struc
 {
 	pcibios_reset_secondary_bus(dev);
 
-	return pci_dev_wait(dev, "bus reset", PCIE_RESET_READY_POLL_MS);
+	return pci_bridge_wait_for_secondary_bus(dev, "bus reset",
+						 PCIE_RESET_READY_POLL_MS);
 }
 EXPORT_SYMBOL_GPL(pci_bridge_secondary_bus_reset);
 
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -63,6 +63,13 @@ struct pci_cap_saved_state *pci_find_sav
 #define PCI_PM_D3HOT_WAIT       10	/* msec */
 #define PCI_PM_D3COLD_WAIT      100	/* msec */
 
+/*
+ * Following exit from Conventional Reset, devices must be ready within 1 sec
+ * (PCIe r6.0 sec 6.6.1).  A D3cold to D0 transition implies a Conventional
+ * Reset (PCIe r6.0 sec 5.8).
+ */
+#define PCI_RESET_WAIT		1000	/* msec */
+
 void pci_update_current_state(struct pci_dev *dev, pci_power_t state);
 void pci_refresh_power_state(struct pci_dev *dev);
 int pci_power_up(struct pci_dev *dev);
@@ -85,8 +92,9 @@ void pci_msi_init(struct pci_dev *dev);
 void pci_msix_init(struct pci_dev *dev);
 bool pci_bridge_d3_possible(struct pci_dev *dev);
 void pci_bridge_d3_update(struct pci_dev *dev);
-void pci_bridge_wait_for_secondary_bus(struct pci_dev *dev);
 void pci_bridge_reconfigure_ltr(struct pci_dev *dev);
+int pci_bridge_wait_for_secondary_bus(struct pci_dev *dev, char *reset_type,
+				      int timeout);
 
 static inline void pci_wakeup_event(struct pci_dev *dev)
 {


