Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C5BB2B6306
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:34:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732160AbgKQNeQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:34:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:44740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731644AbgKQNeP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:34:15 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87A8321534;
        Tue, 17 Nov 2020 13:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620055;
        bh=pA8mLgTej4GQSGeBviRneyMprTgwzHUFWXb1tmMzlWM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fqo5oLogpCUWAcL2h0NhHsjyiNZO4CJ0phJpPR/4R0OGmCn1Yd4THF9WVktcrPVt8
         BapsneIlZdzGSr9BmFuf4ZBJB772xOej8rH6W07hrjCpVWNxkImInuGeUxuDkmsNHJ
         BcNj0ne8Es/XhRFx0FT6DdNW+U14Jx/Sz6rxG+Ws=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, vtolkm@googlemail.com,
        =?UTF-8?q?Jan=20Kundr=C3=A1t?= <jan.kundrat@cesnet.cz>,
        Rob Herring <robh@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Russell King <linux@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 063/255] PCI: mvebu: Fix duplicate resource requests
Date:   Tue, 17 Nov 2020 14:03:23 +0100
Message-Id: <20201117122142.017735222@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Herring <robh@kernel.org>

[ Upstream commit 832ea234277a2465ec6602fa6a4db5cd9ee87ae3 ]

With commit 669cbc708122 ("PCI: Move DT resource setup into
devm_pci_alloc_host_bridge()"), the DT 'ranges' is parsed and populated
into resources when the host bridge is allocated. The resources are
requested as well, but that happens a second time for the mvebu driver in
mvebu_pcie_parse_request_resources(). We should only be requesting the
additional resources added in mvebu_pcie_parse_request_resources().  These
are not added by default because they use custom properties rather than
standard DT address translation.

Also, the bus ranges was also populated by default, so we can remove it
from mvebu_pci_host_probe().

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=209729
Fixes: 669cbc708122 ("PCI: Move DT resource setup into devm_pci_alloc_host_bridge()")
Link: https://lore.kernel.org/r/20201023145252.2691779-1-robh@kernel.org
Reported-by: vtolkm@googlemail.com
Tested-by: Jan Kundrát <jan.kundrat@cesnet.cz>
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Russell King <linux@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pci-mvebu.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/pci/controller/pci-mvebu.c b/drivers/pci/controller/pci-mvebu.c
index c39978b750ec6..653c0b3d29125 100644
--- a/drivers/pci/controller/pci-mvebu.c
+++ b/drivers/pci/controller/pci-mvebu.c
@@ -960,25 +960,16 @@ static void mvebu_pcie_powerdown(struct mvebu_pcie_port *port)
 }
 
 /*
- * We can't use devm_of_pci_get_host_bridge_resources() because we
- * need to parse our special DT properties encoding the MEM and IO
- * apertures.
+ * devm_of_pci_get_host_bridge_resources() only sets up translateable resources,
+ * so we need extra resource setup parsing our special DT properties encoding
+ * the MEM and IO apertures.
  */
 static int mvebu_pcie_parse_request_resources(struct mvebu_pcie *pcie)
 {
 	struct device *dev = &pcie->pdev->dev;
-	struct device_node *np = dev->of_node;
 	struct pci_host_bridge *bridge = pci_host_bridge_from_priv(pcie);
 	int ret;
 
-	/* Get the bus range */
-	ret = of_pci_parse_bus_range(np, &pcie->busn);
-	if (ret) {
-		dev_err(dev, "failed to parse bus-range property: %d\n", ret);
-		return ret;
-	}
-	pci_add_resource(&bridge->windows, &pcie->busn);
-
 	/* Get the PCIe memory aperture */
 	mvebu_mbus_get_pcie_mem_aperture(&pcie->mem);
 	if (resource_size(&pcie->mem) == 0) {
@@ -988,6 +979,9 @@ static int mvebu_pcie_parse_request_resources(struct mvebu_pcie *pcie)
 
 	pcie->mem.name = "PCI MEM";
 	pci_add_resource(&bridge->windows, &pcie->mem);
+	ret = devm_request_resource(dev, &iomem_resource, &pcie->mem);
+	if (ret)
+		return ret;
 
 	/* Get the PCIe IO aperture */
 	mvebu_mbus_get_pcie_io_aperture(&pcie->io);
@@ -1001,9 +995,12 @@ static int mvebu_pcie_parse_request_resources(struct mvebu_pcie *pcie)
 		pcie->realio.name = "PCI I/O";
 
 		pci_add_resource(&bridge->windows, &pcie->realio);
+		ret = devm_request_resource(dev, &ioport_resource, &pcie->realio);
+		if (ret)
+			return ret;
 	}
 
-	return devm_request_pci_bus_resources(dev, &bridge->windows);
+	return 0;
 }
 
 /*
-- 
2.27.0



