Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22E614125D3
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354383AbhITSsf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:48:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:33542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1384095AbhITSqc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:46:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D350061B04;
        Mon, 20 Sep 2021 17:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159209;
        bh=12eTKTrgXoNsliTpBIj9AqdcGCF3gdeRnknu9J4fK+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uyxL9mY4mYLrNFN2/xfkjxSThPYWEgMXLtxCpHhNTEpjNjbDMgD791NXt3FxflRBi
         VIwkMeE+TTEOwBp88qDDOXA/4RIFOngMr7l0ZInZXm090MVeH7PVZiOi+sk7y4Uly1
         o4x5wEdZUxpOXrqFpfPxxCIR1YFFOCeb9uPslgOk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Rob Herring <robh@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Srinath Mannam <srinath.mannam@broadcom.com>,
        Roman Bacik <roman.bacik@broadcom.com>,
        Bharat Gooty <bharat.gooty@broadcom.com>,
        Abhishek Shah <abhishek.shah@broadcom.com>,
        Jitendra Bhivare <jitendra.bhivare@broadcom.com>,
        Ray Jui <ray.jui@broadcom.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        BCM Kernel Feedback <bcm-kernel-feedback-list@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 125/168] PCI: iproc: Fix BCMA probe resource handling
Date:   Mon, 20 Sep 2021 18:44:23 +0200
Message-Id: <20210920163925.767828626@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Herring <robh@kernel.org>

[ Upstream commit aeaea8969b402e0081210cc9144404d13996efed ]

In commit 7ef1c871da16 ("PCI: iproc: Use
pci_parse_request_of_pci_ranges()"), calling
devm_request_pci_bus_resources() was dropped from the common iProc
probe code, but is still needed for BCMA bus probing. Without it, there
will be lots of warnings like this:

pci 0000:00:00.0: BAR 8: no space for [mem size 0x00c00000]
pci 0000:00:00.0: BAR 8: failed to assign [mem size 0x00c00000]

Add back calling devm_request_pci_bus_resources() and adding the
resources to pci_host_bridge.windows for BCMA bus probe.

Link: https://lore.kernel.org/r/20210803215656.3803204-2-robh@kernel.org
Fixes: 7ef1c871da16 ("PCI: iproc: Use pci_parse_request_of_pci_ranges()")
Reported-by: Rafał Miłecki <zajec5@gmail.com>
Tested-by: Rafał Miłecki <rafal@milecki.pl>
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: Srinath Mannam <srinath.mannam@broadcom.com>
Cc: Roman Bacik <roman.bacik@broadcom.com>
Cc: Bharat Gooty <bharat.gooty@broadcom.com>
Cc: Abhishek Shah <abhishek.shah@broadcom.com>
Cc: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Cc: Ray Jui <ray.jui@broadcom.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: BCM Kernel Feedback <bcm-kernel-feedback-list@broadcom.com>
Cc: Scott Branden <sbranden@broadcom.com>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: "Krzysztof Wilczyński" <kw@linux.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-iproc-bcma.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/pci/controller/pcie-iproc-bcma.c b/drivers/pci/controller/pcie-iproc-bcma.c
index 56b8ee7bf330..f918c713afb0 100644
--- a/drivers/pci/controller/pcie-iproc-bcma.c
+++ b/drivers/pci/controller/pcie-iproc-bcma.c
@@ -35,7 +35,6 @@ static int iproc_pcie_bcma_probe(struct bcma_device *bdev)
 {
 	struct device *dev = &bdev->dev;
 	struct iproc_pcie *pcie;
-	LIST_HEAD(resources);
 	struct pci_host_bridge *bridge;
 	int ret;
 
@@ -60,19 +59,16 @@ static int iproc_pcie_bcma_probe(struct bcma_device *bdev)
 	pcie->mem.end = bdev->addr_s[0] + SZ_128M - 1;
 	pcie->mem.name = "PCIe MEM space";
 	pcie->mem.flags = IORESOURCE_MEM;
-	pci_add_resource(&resources, &pcie->mem);
+	pci_add_resource(&bridge->windows, &pcie->mem);
+	ret = devm_request_pci_bus_resources(dev, &bridge->windows);
+	if (ret)
+		return ret;
 
 	pcie->map_irq = iproc_pcie_bcma_map_irq;
 
-	ret = iproc_pcie_setup(pcie, &resources);
-	if (ret) {
-		dev_err(dev, "PCIe controller setup failed\n");
-		pci_free_resource_list(&resources);
-		return ret;
-	}
-
 	bcma_set_drvdata(bdev, pcie);
-	return 0;
+
+	return iproc_pcie_setup(pcie, &bridge->windows);
 }
 
 static void iproc_pcie_bcma_remove(struct bcma_device *bdev)
-- 
2.30.2



