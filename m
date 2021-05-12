Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC31D37D26B
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 20:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244311AbhELSJ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 14:09:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:51348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352500AbhELSD0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 14:03:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9572961430;
        Wed, 12 May 2021 18:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620842537;
        bh=GvCpCU7LOFMdC1La32QjDV/EKg3mqUZvXZcpx4mc1MQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lrVg/CG10Q+eF13AkIR+1LWNsllcQDE8NFm/bnYzs+V7VRM6k1UJSe5EXo4AlpQIm
         VwP9MhiQmnjb+urz9pj+pwjtbjVEohKVgta0c3RHauX09N/kCGNObZo0HqgtDChPOB
         6oJ/pYc9nRsuXkAtexEezPHQBkMHnLEENXgDRdRhVcJMfYkaplhKX0JTdGrQBYjTU2
         sIzADjY5XY6R4a8bY+TR7jiwuF4G3C361HyXwEgKgWyVaZOCW9W8RR+hoBEWNRFe4m
         TdA5G2xFDXgY895S+VB27Id8WOLHmYDtQd9uMHeCItr+7baRfVhPHcP6RsCuOPrLwd
         x1vl/MUbRwRYQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 07/35] PCI: tegra: Fix runtime PM imbalance in pex_ep_event_pex_rst_deassert()
Date:   Wed, 12 May 2021 14:01:37 -0400
Message-Id: <20210512180206.664536-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210512180206.664536-1-sashal@kernel.org>
References: <20210512180206.664536-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit 5859c926d1f052ee61b5815b14658875c14f6243 ]

pm_runtime_get_sync() will increase the runtime PM counter
even it returns an error. Thus a pairing decrement is needed
to prevent refcount leak. Fix this by replacing this API with
pm_runtime_resume_and_get(), which will not change the runtime
PM counter on error.

Link: https://lore.kernel.org/r/20210408072700.15791-1-dinghao.liu@zju.edu.cn
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Acked-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-tegra194.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/controller/dwc/pcie-tegra194.c b/drivers/pci/controller/dwc/pcie-tegra194.c
index 6fa216e52d14..0e94190ca4e8 100644
--- a/drivers/pci/controller/dwc/pcie-tegra194.c
+++ b/drivers/pci/controller/dwc/pcie-tegra194.c
@@ -1645,7 +1645,7 @@ static void pex_ep_event_pex_rst_deassert(struct tegra_pcie_dw *pcie)
 	if (pcie->ep_state == EP_STATE_ENABLED)
 		return;
 
-	ret = pm_runtime_get_sync(dev);
+	ret = pm_runtime_resume_and_get(dev);
 	if (ret < 0) {
 		dev_err(dev, "Failed to get runtime sync for PCIe dev: %d\n",
 			ret);
-- 
2.30.2

