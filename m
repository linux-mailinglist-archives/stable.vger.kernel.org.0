Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADC006AED6B
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:04:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbjCGSEK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:04:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232157AbjCGSDu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:03:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CDF3A4005
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:56:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D23916150B
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:56:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D59A4C433D2;
        Tue,  7 Mar 2023 17:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211804;
        bh=yXf+aPFI/AJXU7tbHHFYrZ37GFUxPR/coCUegubzZiw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SbiIcs8Dn7N6EjhyWEvNpTB174EHz8THVBKdrQepPeuUtZcHrbWTbbq6mOlhx2tAM
         6DSk6aY8yLj+AXxATK+TAJlT/HOWuoZjtRoQR5AFg/asQIG7SUGa6E1Ec6Q5r9J4z8
         1yZS6KsDIES46iIfoR7eb/dJzhIryCOb9q46yfFo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Ravi Kishore Koppuravuri <ravi.kishore.koppuravuri@intel.com>,
        Lukas Wunner <lukas@wunner.de>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.2 0982/1001] PCI/DPC: Await readiness of secondary bus after reset
Date:   Tue,  7 Mar 2023 18:02:34 +0100
Message-Id: <20230307170104.844482290@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

commit 53b54ad074de1896f8b021615f65b27f557ce874 upstream.

pci_bridge_wait_for_secondary_bus() is called after a Secondary Bus
Reset, but not after a DPC-induced Hot Reset.

As a result, the delays prescribed by PCIe r6.0 sec 6.6.1 are not
observed and devices on the secondary bus may be accessed before
they're ready.

One affected device is Intel's Ponte Vecchio HPC GPU.  It comprises a
PCIe switch whose upstream port is not immediately ready after reset.
Because its config space is restored too early, it remains in
D0uninitialized, its subordinate devices remain inaccessible and DPC
recovery fails with messages such as:

  i915 0000:8c:00.0: can't change power state from D3cold to D0 (config space inaccessible)
  intel_vsec 0000:8e:00.1: can't change power state from D3cold to D0 (config space inaccessible)
  pcieport 0000:89:02.0: AER: device recovery failed

Fix it.

Link: https://lore.kernel.org/r/9f5ff00e1593d8d9a4b452398b98aa14d23fca11.1673769517.git.lukas@wunner.de
Tested-by: Ravi Kishore Koppuravuri <ravi.kishore.koppuravuri@intel.com>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/pci.c      |    3 ---
 drivers/pci/pci.h      |    6 ++++++
 drivers/pci/pcie/dpc.c |    4 ++--
 3 files changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -167,9 +167,6 @@ static int __init pcie_port_pm_setup(cha
 }
 __setup("pcie_port_pm=", pcie_port_pm_setup);
 
-/* Time to wait after a reset for device to become responsive */
-#define PCIE_RESET_READY_POLL_MS 60000
-
 /**
  * pci_bus_max_busnr - returns maximum PCI bus number of given bus' children
  * @bus: pointer to PCI bus structure to search
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -70,6 +70,12 @@ struct pci_cap_saved_state *pci_find_sav
  * Reset (PCIe r6.0 sec 5.8).
  */
 #define PCI_RESET_WAIT		1000	/* msec */
+/*
+ * Devices may extend the 1 sec period through Request Retry Status completions
+ * (PCIe r6.0 sec 2.3.1).  The spec does not provide an upper limit, but 60 sec
+ * ought to be enough for any device to become responsive.
+ */
+#define PCIE_RESET_READY_POLL_MS 60000	/* msec */
 
 void pci_update_current_state(struct pci_dev *dev, pci_power_t state);
 void pci_refresh_power_state(struct pci_dev *dev);
--- a/drivers/pci/pcie/dpc.c
+++ b/drivers/pci/pcie/dpc.c
@@ -170,8 +170,8 @@ pci_ers_result_t dpc_reset_link(struct p
 	pci_write_config_word(pdev, cap + PCI_EXP_DPC_STATUS,
 			      PCI_EXP_DPC_STATUS_TRIGGER);
 
-	if (!pcie_wait_for_link(pdev, true)) {
-		pci_info(pdev, "Data Link Layer Link Active not set in 1000 msec\n");
+	if (pci_bridge_wait_for_secondary_bus(pdev, "DPC",
+					      PCIE_RESET_READY_POLL_MS)) {
 		clear_bit(PCI_DPC_RECOVERED, &pdev->priv_flags);
 		ret = PCI_ERS_RESULT_DISCONNECT;
 	} else {


