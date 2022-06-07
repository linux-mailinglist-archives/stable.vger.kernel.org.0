Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03F49540C1E
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351657AbiFGSdu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:33:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352965AbiFGSb1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:31:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCF2817CC9A;
        Tue,  7 Jun 2022 10:56:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E071960DBA;
        Tue,  7 Jun 2022 17:56:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEB52C34119;
        Tue,  7 Jun 2022 17:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624596;
        bh=IJvUhjUH5u1qO3dZ2GVA6CBiywfAM52fb19Dmh1LEHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fgPnzgbVz0QaxdS/AhZX+ifH+ggT0Ih32DMGOL++ptCVne8doIwTpC6ri0aGSHEzT
         GzT4cYdw+xi4rAvszDrLtCWNeXzY0vIsBqiDAaVnKBUg9kDNFk/jZA74ZH0zjNHj41
         a9dLQ2CryQMoAUJLDfPiO8r7J4lu3o4KtY4o0ezU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mario Limonciello <mario.limonciello@amd.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 383/667] PCI/ACPI: Allow D3 only if Root Port can signal and wake from D3
Date:   Tue,  7 Jun 2022 19:00:48 +0200
Message-Id: <20220607164946.236103738@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit dff6139015dc68e93be3822a7bd406a1d138628b ]

acpi_pci_bridge_d3(dev) returns "true" if "dev" is a hotplug bridge that
can handle hotplug events while in D3.  Previously this meant either:

  - "dev" has a _PS0 or _PR0 method (acpi_pci_power_manageable()), or

  - The Root Port above "dev" has a _DSD with a "HotPlugSupportInD3"
    property with value 1.

This did not consider _PRW, which tells us about wakeup GPEs (ACPI v6.4,
sec 7.3.13).  Without a wakeup GPE, from an ACPI perspective the Root Port
has no way of generating wakeup signals, so hotplug events will be lost if
we use D3.

Similarly, it did not consider _S0W, which tells us the deepest D-state
from which a device can wake itself (sec 7.3.20).  If _S0W tells us the
device cannot wake from D3, hotplug events will again be lost if we use D3.

Some platforms, e.g., AMD Yellow Carp, supply "HotPlugSupportInD3" without
_PRW or with an _S0W that says the Root Port cannot wake from D3.  On those
platforms, we previously put bridges in D3hot, hotplug events were lost,
and hotplugged devices would not be recognized without manually rescanning.

Allow bridges to be put in D3 only if the Root Port can generate wakeup
GPEs (wakeup.flags.valid), it can wake from D3 (_S0W), AND it has the
"HotPlugSupportInD3" property.

Neither Windows 10 nor Windows 11 puts the bridge in D3 when the firmware
is configured this way, and this change aligns the handling of the
situation to be the same.

[bhelgaas: commit log, tidy "HotPlugSupportInD3" check and comment]
Link: https://uefi.org/htmlspecs/ACPI_Spec_6_4_html/07_Power_and_Performance_Mgmt/device-power-management-objects.html?highlight=s0w#s0w-s0-device-wake-state
Link: https://docs.microsoft.com/en-us/windows-hardware/drivers/pci/dsd-for-pcie-root-ports#identifying-pcie-root-ports-supporting-hot-plug-in-d3
Link: https://lore.kernel.org/r/20220401034003.3166-1-mario.limonciello@amd.com
Fixes: 26ad34d510a87 ("PCI / ACPI: Whitelist D3 for more PCIe hotplug ports")
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci-acpi.c | 41 ++++++++++++++++++++++++++++++-----------
 1 file changed, 30 insertions(+), 11 deletions(-)

diff --git a/drivers/pci/pci-acpi.c b/drivers/pci/pci-acpi.c
index 260a06fb78a6..813e0d25e841 100644
--- a/drivers/pci/pci-acpi.c
+++ b/drivers/pci/pci-acpi.c
@@ -976,9 +976,11 @@ static bool acpi_pci_power_manageable(struct pci_dev *dev)
 
 static bool acpi_pci_bridge_d3(struct pci_dev *dev)
 {
-	const union acpi_object *obj;
-	struct acpi_device *adev;
 	struct pci_dev *rpdev;
+	struct acpi_device *adev;
+	acpi_status status;
+	unsigned long long state;
+	const union acpi_object *obj;
 
 	if (!dev->is_hotplug_bridge)
 		return false;
@@ -987,12 +989,6 @@ static bool acpi_pci_bridge_d3(struct pci_dev *dev)
 	if (acpi_pci_power_manageable(dev))
 		return true;
 
-	/*
-	 * The ACPI firmware will provide the device-specific properties through
-	 * _DSD configuration object. Look for the 'HotPlugSupportInD3' property
-	 * for the root port and if it is set we know the hierarchy behind it
-	 * supports D3 just fine.
-	 */
 	rpdev = pcie_find_root_port(dev);
 	if (!rpdev)
 		return false;
@@ -1001,11 +997,34 @@ static bool acpi_pci_bridge_d3(struct pci_dev *dev)
 	if (!adev)
 		return false;
 
-	if (acpi_dev_get_property(adev, "HotPlugSupportInD3",
-				   ACPI_TYPE_INTEGER, &obj) < 0)
+	/*
+	 * If the Root Port cannot signal wakeup signals at all, i.e., it
+	 * doesn't supply a wakeup GPE via _PRW, it cannot signal hotplug
+	 * events from low-power states including D3hot and D3cold.
+	 */
+	if (!adev->wakeup.flags.valid)
 		return false;
 
-	return obj->integer.value == 1;
+	/*
+	 * If the Root Port cannot wake itself from D3hot or D3cold, we
+	 * can't use D3.
+	 */
+	status = acpi_evaluate_integer(adev->handle, "_S0W", NULL, &state);
+	if (ACPI_SUCCESS(status) && state < ACPI_STATE_D3_HOT)
+		return false;
+
+	/*
+	 * The "HotPlugSupportInD3" property in a Root Port _DSD indicates
+	 * the Port can signal hotplug events while in D3.  We assume any
+	 * bridges *below* that Root Port can also signal hotplug events
+	 * while in D3.
+	 */
+	if (!acpi_dev_get_property(adev, "HotPlugSupportInD3",
+				   ACPI_TYPE_INTEGER, &obj) &&
+	    obj->integer.value == 1)
+		return true;
+
+	return false;
 }
 
 static int acpi_pci_set_power_state(struct pci_dev *dev, pci_power_t state)
-- 
2.35.1



