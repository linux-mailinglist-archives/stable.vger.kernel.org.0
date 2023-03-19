Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 888576BFFA1
	for <lists+stable@lfdr.de>; Sun, 19 Mar 2023 07:53:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbjCSGxu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Mar 2023 02:53:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjCSGxt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Mar 2023 02:53:49 -0400
X-Greylist: delayed 62 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 18 Mar 2023 23:53:48 PDT
Received: from mailout2.hostsharing.net (mailout2.hostsharing.net [83.223.78.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3775BB80
        for <stable@vger.kernel.org>; Sat, 18 Mar 2023 23:53:48 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL Global TLS RSA4096 SHA256 2022 CA1" (verified OK))
        by mailout2.hostsharing.net (Postfix) with ESMTPS id 11A8D10189E0D;
        Sun, 19 Mar 2023 07:53:44 +0100 (CET)
Received: from localhost (unknown [89.246.108.87])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by h08.hostsharing.net (Postfix) with ESMTPSA id E24B76031F35;
        Sun, 19 Mar 2023 07:53:43 +0100 (CET)
X-Mailbox-Line: From a97ccac88631d60800946d18374c0846a074be39 Mon Sep 17 00:00:00 2001
Message-Id: <a97ccac88631d60800946d18374c0846a074be39.1679208519.git.lukas@wunner.de>
In-Reply-To: <16782049101756@kroah.com>
References: <16782049101756@kroah.com>
From:   Lukas Wunner <lukas@wunner.de>
Date:   Sun, 19 Mar 2023 07:53:33 +0100
Subject: [PATCH 5.10.y 2/2] PCI/DPC: Await readiness of secondary bus after
 reset
To:     <stable@vger.kernel.org>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Ravi Kishore Koppuravuri" <ravi.kishore.koppuravuri@intel.com>,
        Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Sheng Bi <windy.bi.enflame@gmail.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/pci/pci.c      | 3 ---
 drivers/pci/pci.h      | 6 ++++++
 drivers/pci/pcie/dpc.c | 4 ++--
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index f1a3f165f88a..d37013d007b6 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -157,9 +157,6 @@ static int __init pcie_port_pm_setup(char *str)
 }
 __setup("pcie_port_pm=", pcie_port_pm_setup);
 
-/* Time to wait after a reset for device to become responsive */
-#define PCIE_RESET_READY_POLL_MS 60000
-
 /**
  * pci_bus_max_busnr - returns maximum PCI bus number of given bus' children
  * @bus: pointer to PCI bus structure to search
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 77dd7bbe861d..72436000ff25 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -53,6 +53,12 @@ int pci_bus_error_reset(struct pci_dev *dev);
  * Reset (PCIe r6.0 sec 5.8).
  */
 #define PCI_RESET_WAIT		1000	/* msec */
+/*
+ * Devices may extend the 1 sec period through Request Retry Status completions
+ * (PCIe r6.0 sec 2.3.1).  The spec does not provide an upper limit, but 60 sec
+ * ought to be enough for any device to become responsive.
+ */
+#define PCIE_RESET_READY_POLL_MS 60000	/* msec */
 
 /**
  * struct pci_platform_pm_ops - Firmware PM callbacks
diff --git a/drivers/pci/pcie/dpc.c b/drivers/pci/pcie/dpc.c
index c556e7beafe3..f21d64ae4ffc 100644
--- a/drivers/pci/pcie/dpc.c
+++ b/drivers/pci/pcie/dpc.c
@@ -170,8 +170,8 @@ pci_ers_result_t dpc_reset_link(struct pci_dev *pdev)
 	pci_write_config_word(pdev, cap + PCI_EXP_DPC_STATUS,
 			      PCI_EXP_DPC_STATUS_TRIGGER);
 
-	if (!pcie_wait_for_link(pdev, true)) {
-		pci_info(pdev, "Data Link Layer Link Active not set in 1000 msec\n");
+	if (pci_bridge_wait_for_secondary_bus(pdev, "DPC",
+					      PCIE_RESET_READY_POLL_MS)) {
 		clear_bit(PCI_DPC_RECOVERED, &pdev->priv_flags);
 		ret = PCI_ERS_RESULT_DISCONNECT;
 	} else {
-- 
2.39.2

