Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2265433F0F3
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 14:16:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230394AbhCQNPn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Mar 2021 09:15:43 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:39210 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230044AbhCQNPm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Mar 2021 09:15:42 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 12HDFVBU053849;
        Wed, 17 Mar 2021 08:15:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1615986931;
        bh=z/0RVjPVB6nhY++viO0cqAxcncQ8evyw2P8L1LGfuMM=;
        h=From:To:CC:Subject:Date;
        b=GnN6XnFA5VAlNAURY/XnkRI/eTJhT7DP6fS4DLdJVaIu2DbU0RvbjCrTtszSXOgZ6
         O4M4tI0JToTHy65MJ7Fo6GqKyIY0Zq+g5YctlUx/B3s2XkBnaHoSCTN9ebm+9IiCuN
         u6g2Ritvl639rJqJKzfPCo6OOIaKJeyw4KcBCXU0=
Received: from DFLE101.ent.ti.com (dfle101.ent.ti.com [10.64.6.22])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 12HDFVb4001100
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 17 Mar 2021 08:15:31 -0500
Received: from DFLE106.ent.ti.com (10.64.6.27) by DFLE101.ent.ti.com
 (10.64.6.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Wed, 17
 Mar 2021 08:15:31 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE106.ent.ti.com
 (10.64.6.27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2 via
 Frontend Transport; Wed, 17 Mar 2021 08:15:31 -0500
Received: from a0393678-ssd.dhcp.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 12HDFQLo024146;
        Wed, 17 Mar 2021 08:15:27 -0500
From:   Kishon Vijay Abraham I <kishon@ti.com>
To:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Rob Herring <robh+dt@kernel.org>
CC:     Kishon Vijay Abraham I <kishon@ti.com>,
        <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Lokesh Vutla <lokeshvutla@ti.com>, <stable@vger.kernel.org>
Subject: [PATCH] PCI: keystone: Let AM65 use the pci_ops defined in pcie-designware-host.c
Date:   Wed, 17 Mar 2021 18:45:18 +0530
Message-ID: <20210317131518.11040-1-kishon@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Both TI's AM65x (K3) and TI's K2 PCIe driver are implemented in
pci-keystone. However Only K2 PCIe driver should use it's own pci_ops
for configuration space accesses. But commit 10a797c6e54a
("PCI: dwc: keystone: Use pci_ops for config space accessors") used
custom pci_ops for both AM65x and K2. This breaks configuration space
access for AM65x platform. Fix it here.

Fixes: 10a797c6e54a ("PCI: dwc: keystone: Use pci_ops for config space accessors")
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Cc: <stable@vger.kernel.org> # v5.10
---
 drivers/pci/controller/dwc/pci-keystone.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/controller/dwc/pci-keystone.c b/drivers/pci/controller/dwc/pci-keystone.c
index 53aa35cb3a49..a59ecbec601f 100644
--- a/drivers/pci/controller/dwc/pci-keystone.c
+++ b/drivers/pci/controller/dwc/pci-keystone.c
@@ -798,7 +798,8 @@ static int __init ks_pcie_host_init(struct pcie_port *pp)
 	int ret;
 
 	pp->bridge->ops = &ks_pcie_ops;
-	pp->bridge->child_ops = &ks_child_pcie_ops;
+	if (!ks_pcie->is_am6)
+		pp->bridge->child_ops = &ks_child_pcie_ops;
 
 	ret = ks_pcie_config_legacy_irq(ks_pcie);
 	if (ret)
-- 
2.17.1

