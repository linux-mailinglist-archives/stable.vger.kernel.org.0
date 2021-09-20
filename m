Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFE7F412476
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381084AbhITSfZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:35:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:49300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1379766AbhITSa1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:30:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68480632F7;
        Mon, 20 Sep 2021 17:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158834;
        bh=tSld2HOwibPSCdTrA5wJUDFuSG0AdJmTLSluveSg8WU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FtfkiYCYOXJDapl2Qdu1G0iEeTJ16ScM+E9P/sWWidSXBEeNLvFpY//Nlc6D2Cvts
         nWv9VucARbpFw9hH5cwFiI7UyEYrChUE+WPbnQG6k86JSEWWJ6LEZ+T9ZBq1fSpnGi
         aJF6RhE5LeY+P1/YK9ACwL4opVJHASF3+IsnEhAU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Om Prakash Singh <omp@nvidia.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Vidya Sagar <vidyas@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 060/122] PCI: tegra194: Fix MSI-X programming
Date:   Mon, 20 Sep 2021 18:43:52 +0200
Message-Id: <20210920163917.747617427@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163915.757887582@linuxfoundation.org>
References: <20210920163915.757887582@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



