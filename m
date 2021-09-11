Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 434654076B4
	for <lists+stable@lfdr.de>; Sat, 11 Sep 2021 15:12:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235974AbhIKNNQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Sep 2021 09:13:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:36908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235924AbhIKNNM (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Sep 2021 09:13:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9AF69611CC;
        Sat, 11 Sep 2021 13:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631365919;
        bh=lbAZdGQWMdcvQ07c2MocX2Vj5WvDkupCf8fah3snmpE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sk8ROQwV1tKFCOQEo7i82Q5hO1lwVP/H9x70lf9Zw4MMy56XqOQGtqRSCPjw14ijF
         kR6ohvQQ/ivx4M4zz6kYuAtCEBjpcJyhezaPpW6UTgVajEVhOjZ4UFHhlX3qWFU5SU
         B9uhlsZEyV+fZH/eycXqoPJ/pdNGgwywC9lXQNeqWY1vQakNNVJe5LqQovWgPrWo5t
         N3bfS5csP28+BM/0dmBB5S/8ZM5A2fBZFXzMtMxw0AsepUkHEJ3Iy/AlhGmFAqxZvf
         YppKHkuJwoVO3GI5HBuYJi20XQqO9s6oneqrdfBBL5d4Ch1ERhOSBnTKpJqfH1RddK
         dkdx7+Oy/MHHA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Om Prakash Singh <omp@nvidia.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Vidya Sagar <vidyas@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 07/32] PCI: tegra194: Fix MSI-X programming
Date:   Sat, 11 Sep 2021 09:11:24 -0400
Message-Id: <20210911131149.284397-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210911131149.284397-1-sashal@kernel.org>
References: <20210911131149.284397-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Om Prakash Singh <omp@nvidia.com>

[ Upstream commit 43537cf7e351264a1f05ed42ad402942bfc9140e ]

Lower order MSI-X address is programmed in MSIX_ADDR_MATCH_HIGH_OFF
DBI register instead of higher order address. This patch fixes this
programming mistake.

Link: https://lore.kernel.org/r/20210623100525.19944-3-omp@nvidia.com
Signed-off-by: Om Prakash Singh <omp@nvidia.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Vidya Sagar <vidyas@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-tegra194.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/controller/dwc/pcie-tegra194.c b/drivers/pci/controller/dwc/pcie-tegra194.c
index fd14e2f45bba..55c8afb9a899 100644
--- a/drivers/pci/controller/dwc/pcie-tegra194.c
+++ b/drivers/pci/controller/dwc/pcie-tegra194.c
@@ -1763,7 +1763,7 @@ static void pex_ep_event_pex_rst_deassert(struct tegra_pcie_dw *pcie)
 	val = (ep->msi_mem_phys & MSIX_ADDR_MATCH_LOW_OFF_MASK);
 	val |= MSIX_ADDR_MATCH_LOW_OFF_EN;
 	dw_pcie_writel_dbi(pci, MSIX_ADDR_MATCH_LOW_OFF, val);
-	val = (lower_32_bits(ep->msi_mem_phys) & MSIX_ADDR_MATCH_HIGH_OFF_MASK);
+	val = (upper_32_bits(ep->msi_mem_phys) & MSIX_ADDR_MATCH_HIGH_OFF_MASK);
 	dw_pcie_writel_dbi(pci, MSIX_ADDR_MATCH_HIGH_OFF, val);
 
 	ret = dw_pcie_ep_init_complete(ep);
-- 
2.30.2

