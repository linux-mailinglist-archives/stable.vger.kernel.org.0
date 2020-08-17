Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22B0A246C70
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 18:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731110AbgHQQQM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 12:16:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:54756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731071AbgHQQPh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:15:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B269B22CB3;
        Mon, 17 Aug 2020 16:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680937;
        bh=b8dcykdGfMKAbIUCpCxX7tLSFSWEjDh6yo3ccQiiFkc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FH11BozWF7GzfLw7YHCnPRubhjh5cwZ+d7FCSQwZr2EiGRCO4GtD8yfvsGCSL7V4S
         124vpyNeOvhvssJAzOTYQ/NA5ozTTe57/4UTF1d6iD2onN46thwRwsZ5E4wHL03k8A
         3Whv8ekprg4D8wZVq5M4ACeGQEh6VFqoM2x5Bd+s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kishon Vijay Abraham I <kishon@ti.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 100/168] PCI: cadence: Fix updating Vendor ID and Subsystem Vendor ID register
Date:   Mon, 17 Aug 2020 17:17:11 +0200
Message-Id: <20200817143738.710505810@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143733.692105228@linuxfoundation.org>
References: <20200817143733.692105228@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kishon Vijay Abraham I <kishon@ti.com>

[ Upstream commit e3bca37d15dca118f2ef1f0a068bb6e07846ea20 ]

Commit 1b79c5284439 ("PCI: cadence: Add host driver for Cadence PCIe
controller") in order to update Vendor ID, directly wrote to
PCI_VENDOR_ID register. However PCI_VENDOR_ID in root port configuration
space is read-only register and writing to it will have no effect.
Use local management register to configure Vendor ID and Subsystem Vendor
ID.

Link: https://lore.kernel.org/r/20200722110317.4744-10-kishon@ti.com
Fixes: 1b79c5284439 ("PCI: cadence: Add host driver for Cadence PCIe controller")
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-cadence-host.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/controller/pcie-cadence-host.c b/drivers/pci/controller/pcie-cadence-host.c
index ec394f6a19c8e..ae7affcb1a811 100644
--- a/drivers/pci/controller/pcie-cadence-host.c
+++ b/drivers/pci/controller/pcie-cadence-host.c
@@ -102,6 +102,7 @@ static int cdns_pcie_host_init_root_port(struct cdns_pcie_rc *rc)
 {
 	struct cdns_pcie *pcie = &rc->pcie;
 	u32 value, ctrl;
+	u32 id;
 
 	/*
 	 * Set the root complex BAR configuration register:
@@ -121,8 +122,12 @@ static int cdns_pcie_host_init_root_port(struct cdns_pcie_rc *rc)
 	cdns_pcie_writel(pcie, CDNS_PCIE_LM_RC_BAR_CFG, value);
 
 	/* Set root port configuration space */
-	if (rc->vendor_id != 0xffff)
-		cdns_pcie_rp_writew(pcie, PCI_VENDOR_ID, rc->vendor_id);
+	if (rc->vendor_id != 0xffff) {
+		id = CDNS_PCIE_LM_ID_VENDOR(rc->vendor_id) |
+			CDNS_PCIE_LM_ID_SUBSYS(rc->vendor_id);
+		cdns_pcie_writel(pcie, CDNS_PCIE_LM_ID, id);
+	}
+
 	if (rc->device_id != 0xffff)
 		cdns_pcie_rp_writew(pcie, PCI_DEVICE_ID, rc->device_id);
 
-- 
2.25.1



