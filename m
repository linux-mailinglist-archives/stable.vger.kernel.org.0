Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 404C26B4241
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:01:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231418AbjCJOB1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:01:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231485AbjCJOBW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:01:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E4521165E6
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:01:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 20E3A617D5
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:01:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D80EC4339B;
        Fri, 10 Mar 2023 14:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678456868;
        bh=ImW7cVwZPxMa4BVZEt6a602oAhxVIhWuz7mCWSt7fjE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dqr1IwKYnzWnqm/ARAE/fS9q114R8GPuQcpwU/7TzLCJYv/Zlh1u9uAJjy/bOL5+v
         GVVrVAsXeQ6hgfDXvVJSNdERdJLTkWYEExiMyFLmMSjJVZV3V9yHpjbgSRCYRdT4Wh
         OhgvOquTht5H7ccClGaNsBJd961EWakLJ7CAmrdQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Huacai Chen <chenhuacai@loongson.cn>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 153/211] PCI/portdrv: Prevent LS7A Bus Master clearing on shutdown
Date:   Fri, 10 Mar 2023 14:38:53 +0100
Message-Id: <20230310133723.397725338@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
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



