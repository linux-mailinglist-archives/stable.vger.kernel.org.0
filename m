Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00C8F6AA198
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 22:41:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231998AbjCCVlh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 16:41:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231970AbjCCVlf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 16:41:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13336637C7;
        Fri,  3 Mar 2023 13:41:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5AC7B818A4;
        Fri,  3 Mar 2023 21:41:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21A5FC4339E;
        Fri,  3 Mar 2023 21:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677879674;
        bh=BR1ZsF7ohZ7DgIixMEok6HY/tjwrYcM1V7+I6aku2rM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WP0gv+Wb6TlEDR/mzPZF8FBsrRez8VdrjhXAEUUy9l3dLcl9bc2lGM3IyvC9Co4zj
         Fxy3ZkjnmacVeTnsuLGItXbGac30CwfuyOiMLkSbBQE+plYuVyRP9+gOUQkiTsoJmJ
         JDgWkYjiV399+eybg0obtzajep62q22S8b8EbivlwDl3CS/DwaBhUg/+yB1M5ZtmBE
         0hrhwx5EgeJWRV5D1YvT6xX5kkc9Lw5ofbPLaHLhScoxFLwcLvwkiCPq4Y/plx++al
         GvB2R07mf51WYwQR5NbkV4QF0uXZnRk12Kp4+myB5G2c5LsC223BBOl6ahOB3VFVWI
         fYDyIZOCY6pVQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        robert.moore@intel.com, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, acpica-devel@lists.linuxfoundation.org
Subject: [PATCH AUTOSEL 6.2 04/64] PCI/ACPI: Account for _S0W of the target bridge in acpi_pci_bridge_d3()
Date:   Fri,  3 Mar 2023 16:40:06 -0500
Message-Id: <20230303214106.1446460-4-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230303214106.1446460-1-sashal@kernel.org>
References: <20230303214106.1446460-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

[ Upstream commit 8133844a8f2434be9576850c6978179d7cca5c81 ]

It is questionable to allow a PCI bridge to go into D3 if it has _S0W
returning D2 or a shallower power state, so modify acpi_pci_bridge_d3(() to
always take the return value of _S0W for the target bridge into account.
That is, make it return 'false' if _S0W returns D2 or a shallower power
state for the target bridge regardless of its ancestor Root Port
properties.  Of course, this also causes 'false' to be returned if the Root
Port itself is the target and its _S0W returns D2 or a shallower power
state.

However, still allow bridges without _S0W that are power-manageable via
ACPI to enter D3 to retain the current code behavior in that case.

This fixes problems where a hotplug notification is missed because a bridge
is in D3.  That means hot-added devices such as USB4 docks (and the devices
they contain) and Thunderbolt 3 devices may not work.

Link: https://lore.kernel.org/linux-pci/20221031223356.32570-1-mario.limonciello@amd.com/
Link: https://lore.kernel.org/r/12155458.O9o76ZdvQC@kreacher
Reported-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/device_pm.c | 19 +++++++++++++++++
 drivers/pci/pci-acpi.c   | 45 +++++++++++++++++++++++++++-------------
 include/acpi/acpi_bus.h  |  1 +
 3 files changed, 51 insertions(+), 14 deletions(-)

diff --git a/drivers/acpi/device_pm.c b/drivers/acpi/device_pm.c
index 97450f4003cc9..f007116a84276 100644
--- a/drivers/acpi/device_pm.c
+++ b/drivers/acpi/device_pm.c
@@ -484,6 +484,25 @@ void acpi_dev_power_up_children_with_adr(struct acpi_device *adev)
 	acpi_dev_for_each_child(adev, acpi_power_up_if_adr_present, NULL);
 }
 
+/**
+ * acpi_dev_power_state_for_wake - Deepest power state for wakeup signaling
+ * @adev: ACPI companion of the target device.
+ *
+ * Evaluate _S0W for @adev and return the value produced by it or return
+ * ACPI_STATE_UNKNOWN on errors (including _S0W not present).
+ */
+u8 acpi_dev_power_state_for_wake(struct acpi_device *adev)
+{
+	unsigned long long state;
+	acpi_status status;
+
+	status = acpi_evaluate_integer(adev->handle, "_S0W", NULL, &state);
+	if (ACPI_FAILURE(status))
+		return ACPI_STATE_UNKNOWN;
+
+	return state;
+}
+
 #ifdef CONFIG_PM
 static DEFINE_MUTEX(acpi_pm_notifier_lock);
 static DEFINE_MUTEX(acpi_pm_notifier_install_lock);
diff --git a/drivers/pci/pci-acpi.c b/drivers/pci/pci-acpi.c
index 068d6745bf98c..052a611081ecd 100644
--- a/drivers/pci/pci-acpi.c
+++ b/drivers/pci/pci-acpi.c
@@ -976,24 +976,41 @@ bool acpi_pci_power_manageable(struct pci_dev *dev)
 bool acpi_pci_bridge_d3(struct pci_dev *dev)
 {
 	struct pci_dev *rpdev;
-	struct acpi_device *adev;
-	acpi_status status;
-	unsigned long long state;
+	struct acpi_device *adev, *rpadev;
 	const union acpi_object *obj;
 
 	if (acpi_pci_disabled || !dev->is_hotplug_bridge)
 		return false;
 
-	/* Assume D3 support if the bridge is power-manageable by ACPI. */
-	if (acpi_pci_power_manageable(dev))
-		return true;
+	adev = ACPI_COMPANION(&dev->dev);
+	if (adev) {
+		/*
+		 * If the bridge has _S0W, whether or not it can go into D3
+		 * depends on what is returned by that object.  In particular,
+		 * if the power state returned by _S0W is D2 or shallower,
+		 * entering D3 should not be allowed.
+		 */
+		if (acpi_dev_power_state_for_wake(adev) <= ACPI_STATE_D2)
+			return false;
+
+		/*
+		 * Otherwise, assume that the bridge can enter D3 so long as it
+		 * is power-manageable via ACPI.
+		 */
+		if (acpi_device_power_manageable(adev))
+			return true;
+	}
 
 	rpdev = pcie_find_root_port(dev);
 	if (!rpdev)
 		return false;
 
-	adev = ACPI_COMPANION(&rpdev->dev);
-	if (!adev)
+	if (rpdev == dev)
+		rpadev = adev;
+	else
+		rpadev = ACPI_COMPANION(&rpdev->dev);
+
+	if (!rpadev)
 		return false;
 
 	/*
@@ -1001,15 +1018,15 @@ bool acpi_pci_bridge_d3(struct pci_dev *dev)
 	 * doesn't supply a wakeup GPE via _PRW, it cannot signal hotplug
 	 * events from low-power states including D3hot and D3cold.
 	 */
-	if (!adev->wakeup.flags.valid)
+	if (!rpadev->wakeup.flags.valid)
 		return false;
 
 	/*
-	 * If the Root Port cannot wake itself from D3hot or D3cold, we
-	 * can't use D3.
+	 * In the bridge-below-a-Root-Port case, evaluate _S0W for the Root Port
+	 * to verify whether or not it can signal wakeup from D3.
 	 */
-	status = acpi_evaluate_integer(adev->handle, "_S0W", NULL, &state);
-	if (ACPI_SUCCESS(status) && state < ACPI_STATE_D3_HOT)
+	if (rpadev != adev &&
+	    acpi_dev_power_state_for_wake(rpadev) <= ACPI_STATE_D2)
 		return false;
 
 	/*
@@ -1018,7 +1035,7 @@ bool acpi_pci_bridge_d3(struct pci_dev *dev)
 	 * bridges *below* that Root Port can also signal hotplug events
 	 * while in D3.
 	 */
-	if (!acpi_dev_get_property(adev, "HotPlugSupportInD3",
+	if (!acpi_dev_get_property(rpadev, "HotPlugSupportInD3",
 				   ACPI_TYPE_INTEGER, &obj) &&
 	    obj->integer.value == 1)
 		return true;
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index e44be31115a67..0584e9f6e3397 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -534,6 +534,7 @@ int acpi_bus_update_power(acpi_handle handle, int *state_p);
 int acpi_device_update_power(struct acpi_device *device, int *state_p);
 bool acpi_bus_power_manageable(acpi_handle handle);
 void acpi_dev_power_up_children_with_adr(struct acpi_device *adev);
+u8 acpi_dev_power_state_for_wake(struct acpi_device *adev);
 int acpi_device_power_add_dependent(struct acpi_device *adev,
 				    struct device *dev);
 void acpi_device_power_remove_dependent(struct acpi_device *adev,
-- 
2.39.2

