Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A92C13CE522
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347272AbhGSPru (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:47:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:47138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235530AbhGSPpt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:45:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 32517613DF;
        Mon, 19 Jul 2021 16:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711988;
        bh=SKc2HtVL0Gq9rNDH0/NvQDUnW0rUiCq4uHxniytZ+kE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LGF0OVXZPKnfD4CJbZV9X4UpQVCRBYLRfaQP53wI0W11v+iv3ypua/aiVtUYcsYcG
         yy/jt0cx04LQmHMaM64mCyLhtLr2utJ+8JNAJRfBoMexfXIfRja8Cjl6Z2AUvEoboZ
         XgtZQsE+8HGFYXLOis5iaTdFXDeGeeIKd+jCbWs4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Hunter <jonathanh@nvidia.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 207/292] PCI: tegra194: Fix tegra_pcie_ep_raise_msi_irq() ill-defined shift
Date:   Mon, 19 Jul 2021 16:54:29 +0200
Message-Id: <20210719144949.809772093@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jon Hunter <jonathanh@nvidia.com>

[ Upstream commit f67092eff2bd40650aad54a1a1910160f41d864a ]

tegra_pcie_ep_raise_msi_irq() shifted a signed 32-bit value left by 31
bits.  The behavior of this is implementation-defined.

Replace the shift by BIT(), which is well-defined.

Found by cppcheck:

  $ cppcheck --enable=all drivers/pci/controller/dwc/pcie-tegra194.c
  Checking drivers/pci/controller/dwc/pcie-tegra194.c ...

  drivers/pci/controller/dwc/pcie-tegra194.c:1829:23: portability: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour. See condition at line 1826.  [shiftTooManyBitsSigned]

  appl_writel(pcie, (1 << irq), APPL_MSI_CTRL_1);
                     ^

[bhelgaas: commit log]
Link: https://lore.kernel.org/r/20210618160219.303092-1-jonathanh@nvidia.com
Fixes: c57247f940e8 ("PCI: tegra: Add support for PCIe endpoint mode in Tegra194")
Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-tegra194.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/controller/dwc/pcie-tegra194.c b/drivers/pci/controller/dwc/pcie-tegra194.c
index 8dee6d3f33a7..fb1df066a236 100644
--- a/drivers/pci/controller/dwc/pcie-tegra194.c
+++ b/drivers/pci/controller/dwc/pcie-tegra194.c
@@ -1826,7 +1826,7 @@ static int tegra_pcie_ep_raise_msi_irq(struct tegra_pcie_dw *pcie, u16 irq)
 	if (unlikely(irq > 31))
 		return -EINVAL;
 
-	appl_writel(pcie, (1 << irq), APPL_MSI_CTRL_1);
+	appl_writel(pcie, BIT(irq), APPL_MSI_CTRL_1);
 
 	return 0;
 }
-- 
2.30.2



