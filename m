Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 774EB6AA1F1
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 22:45:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232286AbjCCVod (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 16:44:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231778AbjCCVoP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 16:44:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1EEF4B801;
        Fri,  3 Mar 2023 13:43:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21EF4B819FD;
        Fri,  3 Mar 2023 21:42:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C541FC433D2;
        Fri,  3 Mar 2023 21:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677879728;
        bh=ImW7cVwZPxMa4BVZEt6a602oAhxVIhWuz7mCWSt7fjE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r6E6cvBQWGpu/0qreDAsXQBa8IMCKYZjJAnAgLJjNrcP5rVwwNzAtZVQGm8/c3BHl
         h4ENkAtIaXMjdEVGyuz2XK0tp+8DJwzxK3iDE2b3pWitMxBXYHIGhG7ArRC0y1qmIz
         0svv1D/8oaYJghlkfV33/8EKXvZHry+8uLpcw+aWiiaax2WWsq3ENZ3Nb/hkMNGplP
         5EFxkeL/k4H/j5OWBknb89xuaCyUZVHmbHoUW+mKv+TiBB5fx5at5067PeKbh9B6TH
         96X4DBLrdrG04zO/Q1KhvrCTjZIYsc5RHo7qQvBFuldPIPPcq13s2VrYSIOaKqTNB1
         PFAwEqvvnbkeQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Huacai Chen <chenhuacai@loongson.cn>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>, kbusch@kernel.org,
        sathyanarayanan.kuppuswamy@linux.intel.com, sr@denx.de,
        pali@kernel.org, chenhuacai@kernel.org, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 27/64] PCI/portdrv: Prevent LS7A Bus Master clearing on shutdown
Date:   Fri,  3 Mar 2023 16:40:29 -0500
Message-Id: <20230303214106.1446460-27-sashal@kernel.org>
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

From: Huacai Chen <chenhuacai@loongson.cn>

[ Upstream commit 62b6dee1b44aa23b3935543aff7df80399ec726b ]

After cc27b735ad3a ("PCI/portdrv: Turn off PCIe services during shutdown")
we observe hangs during poweroff/reboot on systems with LS7A chipset.

This happens because the portdrv .shutdown() method (pcie_portdrv_remove())
clears PCI_COMMAND_MASTER via pci_disable_device(), which prevents bridges
from forwarding memory or I/O Requests in the upstream direction (PCIe
r6.0, sec 7.5.1.1.3).

LS7A Root Ports have a hardware defect: clearing PCI_COMMAND_MASTER *also*
prevents the bridge from forwarding CPU MMIO requests in the downstream
direction, and these MMIO accesses to devices below the bridge happen even
after .shutdown(), e.g., to print console messages.  LS7A neither forwards
the requests nor sends an unsuccessful completion to the CPU, so the CPU
waits forever, resulting in the hang.

The purpose of .shutdown() is to disable interrupts and DMA from the
device.  PCIe ports may generate interrupts (either MSI/MSI-X or INTx) for
AER, DPC, PME, hotplug, etc., but they never perform DMA except MSI/MSI-X.
Clearing PCI_COMMAND_MASTER effectively disables MSI/MSI-X, but not INTx.

The port service driver .remove() methods clear the interrupt enables in
PCI_ERR_ROOT_COMMAND, PCI_EXP_DPC_CTL, PCI_EXP_SLTCTL, and PCI_EXP_RTCTL,
etc., which disables interrupts regardless of whether they are MSI/MSI-X or
INTx.

Add a pcie_portdrv_shutdown() method that calls all the port service driver
.remove() methods to clear the interrupt enables for each service but does
not clear Bus Mastering on the port itself.

[bhelgaas: commit log]
Link: https://lore.kernel.org/r/20230201043018.778499-2-chenhuacai@loongson.cn
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pcie/portdrv.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/pcie/portdrv.c b/drivers/pci/pcie/portdrv.c
index 2cc2e60bcb396..46fad0d813b2b 100644
--- a/drivers/pci/pcie/portdrv.c
+++ b/drivers/pci/pcie/portdrv.c
@@ -501,7 +501,6 @@ static void pcie_port_device_remove(struct pci_dev *dev)
 {
 	device_for_each_child(&dev->dev, NULL, remove_iter);
 	pci_free_irq_vectors(dev);
-	pci_disable_device(dev);
 }
 
 /**
@@ -727,6 +726,19 @@ static void pcie_portdrv_remove(struct pci_dev *dev)
 	}
 
 	pcie_port_device_remove(dev);
+
+	pci_disable_device(dev);
+}
+
+static void pcie_portdrv_shutdown(struct pci_dev *dev)
+{
+	if (pci_bridge_d3_possible(dev)) {
+		pm_runtime_forbid(&dev->dev);
+		pm_runtime_get_noresume(&dev->dev);
+		pm_runtime_dont_use_autosuspend(&dev->dev);
+	}
+
+	pcie_port_device_remove(dev);
 }
 
 static pci_ers_result_t pcie_portdrv_error_detected(struct pci_dev *dev,
@@ -777,7 +789,7 @@ static struct pci_driver pcie_portdriver = {
 
 	.probe		= pcie_portdrv_probe,
 	.remove		= pcie_portdrv_remove,
-	.shutdown	= pcie_portdrv_remove,
+	.shutdown	= pcie_portdrv_shutdown,
 
 	.err_handler	= &pcie_portdrv_err_handler,
 
-- 
2.39.2

