Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAC0D15DBCA
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 16:51:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730419AbgBNPuS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 10:50:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:54220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730411AbgBNPuR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:50:17 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83BFA24686;
        Fri, 14 Feb 2020 15:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695416;
        bh=jgO7SE6s7cXMkkAGgKa4jsbN+HPX3s6CS37fMH/wceY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CPhhrXYt+Ba+mpLc/jTNqtM82v9qKEKbc2uOS11oE8Y/4XfsXPY2IHY9Xh6dai4wI
         ai4vJV+gh+14TDCnK0xh0LAvO40ULnmUBwhFYP9DPnybf+sToDBbtxAsixhXJkQRbw
         UXN3JxRJHiIufGcGqKgU5fgxAVHTol2vHFrpvlhg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marcel Ziswiler <marcel@ziswiler.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, linux-tegra@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 062/542] PCI: tegra: Fix afi_pex2_ctrl reg offset for Tegra30
Date:   Fri, 14 Feb 2020 10:40:54 -0500
Message-Id: <20200214154854.6746-62-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marcel Ziswiler <marcel@ziswiler.com>

[ Upstream commit 21a92676e1fe292acb077b13106b08c22ed36b14 ]

Fix AFI_PEX2_CTRL reg offset for Tegra30 by moving it from the Tegra20
SoC struct where it erroneously got added. This fixes the AFI_PEX2_CTRL
reg offset being uninitialised subsequently failing to bring up the
third PCIe port.

Fixes: adb2653b3d2e ("PCI: tegra: Add AFI_PEX2_CTRL reg offset as part of SoC struct")
Signed-off-by: Marcel Ziswiler <marcel@ziswiler.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Andrew Murray <andrew.murray@arm.com>
Acked-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pci-tegra.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/controller/pci-tegra.c b/drivers/pci/controller/pci-tegra.c
index 090b632965e21..ac93f5a0398e4 100644
--- a/drivers/pci/controller/pci-tegra.c
+++ b/drivers/pci/controller/pci-tegra.c
@@ -2499,7 +2499,6 @@ static const struct tegra_pcie_soc tegra20_pcie = {
 	.num_ports = 2,
 	.ports = tegra20_pcie_ports,
 	.msi_base_shift = 0,
-	.afi_pex2_ctrl = 0x128,
 	.pads_pll_ctl = PADS_PLL_CTL_TEGRA20,
 	.tx_ref_sel = PADS_PLL_CTL_TXCLKREF_DIV10,
 	.pads_refclk_cfg0 = 0xfa5cfa5c,
@@ -2528,6 +2527,7 @@ static const struct tegra_pcie_soc tegra30_pcie = {
 	.num_ports = 3,
 	.ports = tegra30_pcie_ports,
 	.msi_base_shift = 8,
+	.afi_pex2_ctrl = 0x128,
 	.pads_pll_ctl = PADS_PLL_CTL_TEGRA30,
 	.tx_ref_sel = PADS_PLL_CTL_TXCLKREF_BUF_EN,
 	.pads_refclk_cfg0 = 0xfa5cfa5c,
-- 
2.20.1

