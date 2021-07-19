Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D85F33CE370
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244947AbhGSPiC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:38:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:57516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348342AbhGSPfY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:35:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8FDC061628;
        Mon, 19 Jul 2021 16:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711225;
        bh=1+MUafsHAMF0uJsNF0NtjlA4eT/n9KbA+BEKJoCETJQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qN8EkKsBIvZkND7WuSP8m7QBALJ9lKy1FFmhrb1sVvqh+l1uowXA1Om6/kxP6nlni
         R02UTqcAqXCqANdbEHXO9i8q4ncruGfgkvndLmbWUAEQunFql9iuLsBsPCb11eI8ze
         7w85il+4QHxbKkUmzrGFQc5jZ30OFqEKMmFsSORk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Hunter <jonathanh@nvidia.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 240/351] PCI: tegra194: Fix tegra_pcie_ep_raise_msi_irq() ill-defined shift
Date:   Mon, 19 Jul 2021 16:53:06 +0200
Message-Id: <20210719144952.882110949@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
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
index fa6b12cfc043..3ec7b29d5dc7 100644
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



