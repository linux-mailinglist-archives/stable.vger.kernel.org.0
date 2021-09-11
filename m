Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB8BE407790
	for <lists+stable@lfdr.de>; Sat, 11 Sep 2021 15:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236513AbhIKNSR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Sep 2021 09:18:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:39276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236135AbhIKNPp (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Sep 2021 09:15:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D47D961261;
        Sat, 11 Sep 2021 13:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631366000;
        bh=tSld2HOwibPSCdTrA5wJUDFuSG0AdJmTLSluveSg8WU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bW8yLhPiglpg40E61Y9FAdvYTH2s3LSuYmQLIfKuKO3A1v0wzjeQaoV7ZFiO+KQuV
         nSE9tUNNyTvn1clIUC4DtlfQx65V7VCVEkVaTAru/TaT95G1A0+x6w5WRMdU2XW61S
         6iAwRS6Ano/N+BPYT0qROBFS3Nj2CNb9yH/eVkLtQU2aZgO9xoswOhh0MAnKWLtQj9
         IiO0aNmT0JJgb3jmYx2jpgDbugRvKYGFnbE1JVfXboq47DnnaVrhXwyZD7c+b3bewX
         RNqmwhbAgUkYjhLHfVeMNp182RSysFXSeQJNj4xpKAiVMxoVyca31eNMH2FZleBydO
         k/sA8g4UhLkpA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Om Prakash Singh <omp@nvidia.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Vidya Sagar <vidyas@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 06/25] PCI: tegra194: Fix MSI-X programming
Date:   Sat, 11 Sep 2021 09:12:53 -0400
Message-Id: <20210911131312.285225-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210911131312.285225-1-sashal@kernel.org>
References: <20210911131312.285225-1-sashal@kernel.org>
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
index c2827a8d208f..a5b677ec0769 100644
--- a/drivers/pci/controller/dwc/pcie-tegra194.c
+++ b/drivers/pci/controller/dwc/pcie-tegra194.c
@@ -1778,7 +1778,7 @@ static void pex_ep_event_pex_rst_deassert(struct tegra_pcie_dw *pcie)
 	val = (ep->msi_mem_phys & MSIX_ADDR_MATCH_LOW_OFF_MASK);
 	val |= MSIX_ADDR_MATCH_LOW_OFF_EN;
 	dw_pcie_writel_dbi(pci, MSIX_ADDR_MATCH_LOW_OFF, val);
-	val = (lower_32_bits(ep->msi_mem_phys) & MSIX_ADDR_MATCH_HIGH_OFF_MASK);
+	val = (upper_32_bits(ep->msi_mem_phys) & MSIX_ADDR_MATCH_HIGH_OFF_MASK);
 	dw_pcie_writel_dbi(pci, MSIX_ADDR_MATCH_HIGH_OFF, val);
 
 	ret = dw_pcie_ep_init_complete(ep);
-- 
2.30.2

