Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E25A6C18A4
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:26:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232685AbjCTP0P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:26:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232786AbjCTPZy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:25:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 532BD1A940
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:19:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA18FB80EAB
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:18:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDDA9C433EF;
        Mon, 20 Mar 2023 15:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325515;
        bh=TXwtochNyR79Wdn4VjQwCU9S12vrah87Hd0hMF1KabE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v5OoA1BzdzgIWZFjsXXp2d9S+/kZwzWvkLSVM0X1G2pKLDypO+UbvaH41Hmc9uOdX
         d0cOM7uQxxbEZpiEY/pK5EjWBHgcHj5JsAB4nRgZMEBamM+blym4xH0xDEPdvYShOB
         9caHrg9EXgNM3mLoeWa7pBM4+QxN4zJVN3j7zebs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Ravi Kishore Koppuravuri <ravi.kishore.koppuravuri@intel.com>,
        Lukas Wunner <lukas@wunner.de>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 5.15 113/115] PCI/DPC: Await readiness of secondary bus after reset
Date:   Mon, 20 Mar 2023 15:55:25 +0100
Message-Id: <20230320145454.200964675@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145449.336983711@linuxfoundation.org>
References: <20230320145449.336983711@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
@@ -163,9 +163,6 @@ static int __init pcie_port_pm_setup(cha
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
@@ -69,6 +69,12 @@ struct pci_cap_saved_state *pci_find_sav
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


