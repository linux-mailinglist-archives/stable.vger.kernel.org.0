Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA95200DEC
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390541AbgFSPCy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:02:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:59558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390894AbgFSPCu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:02:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E56C921941;
        Fri, 19 Jun 2020 15:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578970;
        bh=B/hvqbQYqnEJ47ahpY2o/6cP5npf/2M9FY4jezJOFdU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UKiWDYb1HGPLrTXpav5odFZX30jv4H9o4kppypu+mwh2Qh2al6boCbF84mjreqVvz
         jaW1jzHj2Q3yTpuZdr3m0uWlca/M6GdkmZUvwykAWSRQo5k0SI8B5gPDvYL0cAn4xY
         6lLjlRfmngBTV9vbN8w007WTFwi9yQzPlrJ3ajTA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abhishek Sahu <abhsahu@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 227/267] PCI: Generalize multi-function power dependency device links
Date:   Fri, 19 Jun 2020 16:33:32 +0200
Message-Id: <20200619141659.587541394@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141648.840376470@linuxfoundation.org>
References: <20200619141648.840376470@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Abhishek Sahu <abhsahu@nvidia.com>

[ Upstream commit a17beb1a0882a544523dcb5d0da4801272dfd43a ]

Although not allowed by the PCI specs, some multi-function devices have
power dependencies between the functions.  For example, function 1 may not
work unless function 0 is in the D0 power state.

The existing quirk_gpu_hda() adds a device link to express this dependency
for GPU and HDA devices, but it really is not specific to those device
types.

Generalize it and rename it to pci_create_device_link() so we can create
dependencies between any "consumer" and "producer" functions of a
multi-function device, where the consumer is only functional if the
producer is in D0.  This reorganization should not affect any
functionality.

Link: https://lore.kernel.org/lkml/20190606092225.17960-2-abhsahu@nvidia.com
Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
[bhelgaas: commit log, reword diagnostic]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c | 54 ++++++++++++++++++++++++++++----------------
 1 file changed, 34 insertions(+), 20 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 0704025a2160..0862cb633849 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5077,35 +5077,49 @@ static void quirk_fsl_no_msi(struct pci_dev *pdev)
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_FREESCALE, PCI_ANY_ID, quirk_fsl_no_msi);
 
 /*
- * GPUs with integrated HDA controller for streaming audio to attached displays
- * need a device link from the HDA controller (consumer) to the GPU (supplier)
- * so that the GPU is powered up whenever the HDA controller is accessed.
- * The GPU and HDA controller are functions 0 and 1 of the same PCI device.
- * The device link stays in place until shutdown (or removal of the PCI device
- * if it's hotplugged).  Runtime PM is allowed by default on the HDA controller
- * to prevent it from permanently keeping the GPU awake.
+ * Although not allowed by the spec, some multi-function devices have
+ * dependencies of one function (consumer) on another (supplier).  For the
+ * consumer to work in D0, the supplier must also be in D0.  Create a
+ * device link from the consumer to the supplier to enforce this
+ * dependency.  Runtime PM is allowed by default on the consumer to prevent
+ * it from permanently keeping the supplier awake.
  */
-static void quirk_gpu_hda(struct pci_dev *hda)
+static void pci_create_device_link(struct pci_dev *pdev, unsigned int consumer,
+				   unsigned int supplier, unsigned int class,
+				   unsigned int class_shift)
 {
-	struct pci_dev *gpu;
+	struct pci_dev *supplier_pdev;
 
-	if (PCI_FUNC(hda->devfn) != 1)
+	if (PCI_FUNC(pdev->devfn) != consumer)
 		return;
 
-	gpu = pci_get_domain_bus_and_slot(pci_domain_nr(hda->bus),
-					  hda->bus->number,
-					  PCI_DEVFN(PCI_SLOT(hda->devfn), 0));
-	if (!gpu || (gpu->class >> 16) != PCI_BASE_CLASS_DISPLAY) {
-		pci_dev_put(gpu);
+	supplier_pdev = pci_get_domain_bus_and_slot(pci_domain_nr(pdev->bus),
+				pdev->bus->number,
+				PCI_DEVFN(PCI_SLOT(pdev->devfn), supplier));
+	if (!supplier_pdev || (supplier_pdev->class >> class_shift) != class) {
+		pci_dev_put(supplier_pdev);
 		return;
 	}
 
-	if (!device_link_add(&hda->dev, &gpu->dev,
-			     DL_FLAG_STATELESS | DL_FLAG_PM_RUNTIME))
-		pci_err(hda, "cannot link HDA to GPU %s\n", pci_name(gpu));
+	if (device_link_add(&pdev->dev, &supplier_pdev->dev,
+			    DL_FLAG_STATELESS | DL_FLAG_PM_RUNTIME))
+		pci_info(pdev, "D0 power state depends on %s\n",
+			 pci_name(supplier_pdev));
+	else
+		pci_err(pdev, "Cannot enforce power dependency on %s\n",
+			pci_name(supplier_pdev));
+
+	pm_runtime_allow(&pdev->dev);
+	pci_dev_put(supplier_pdev);
+}
 
-	pm_runtime_allow(&hda->dev);
-	pci_dev_put(gpu);
+/*
+ * Create device link for GPUs with integrated HDA controller for streaming
+ * audio to attached displays.
+ */
+static void quirk_gpu_hda(struct pci_dev *hda)
+{
+	pci_create_device_link(hda, 1, 0, PCI_BASE_CLASS_DISPLAY, 16);
 }
 DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_VENDOR_ID_ATI, PCI_ANY_ID,
 			      PCI_CLASS_MULTIMEDIA_HD_AUDIO, 8, quirk_gpu_hda);
-- 
2.25.1



