Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25E481FE6CC
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729187AbgFRBNn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:13:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:42962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729174AbgFRBNk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:13:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6502F221EB;
        Thu, 18 Jun 2020 01:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442820;
        bh=PGIajTLNvn1TlSKGVmd+/Ro+viHxJzQ4+cuGN8MOxDA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fgmk6Tp5AmLgFnz+Vty6rmPTMvmLI+g0bKagi+CeTJc21J75LlUSdR6pzYG4GH/f1
         k3LMYjVgajENzu2r97jv2qFDOpz2pxmlKd5M2ceTKHdhcbiwLFMRKGxniW3DaZCeKM
         Cb2VYR+qVFZAuXp+Ye7CnwrTg+R05PE8YbguMVWM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wei Yongjun <weiyongjun1@huawei.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 257/388] PCI: dwc: pci-dra7xx: Use devm_platform_ioremap_resource_byname()
Date:   Wed, 17 Jun 2020 21:05:54 -0400
Message-Id: <20200618010805.600873-257-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit c8a119779f5609de8dcd98630f71cc7f1b2e4e8c ]

platform_get_resource() may fail and return NULL, so we had better
check its return value to avoid a NULL pointer dereference a bit later
in the code. Fix it to use devm_platform_ioremap_resource_byname()
instead of calling platform_get_resource_byname() and devm_ioremap().

Link: https://lore.kernel.org/r/20200429015027.134485-1-weiyongjun1@huawei.com
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
[lorenzo.pieralisi@arm.com: commit log]
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pci-dra7xx.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/controller/dwc/pci-dra7xx.c b/drivers/pci/controller/dwc/pci-dra7xx.c
index 3b0e58f2de58..6184ebc9392d 100644
--- a/drivers/pci/controller/dwc/pci-dra7xx.c
+++ b/drivers/pci/controller/dwc/pci-dra7xx.c
@@ -840,7 +840,6 @@ static int __init dra7xx_pcie_probe(struct platform_device *pdev)
 	struct phy **phy;
 	struct device_link **link;
 	void __iomem *base;
-	struct resource *res;
 	struct dw_pcie *pci;
 	struct dra7xx_pcie *dra7xx;
 	struct device *dev = &pdev->dev;
@@ -877,10 +876,9 @@ static int __init dra7xx_pcie_probe(struct platform_device *pdev)
 		return irq;
 	}
 
-	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "ti_conf");
-	base = devm_ioremap(dev, res->start, resource_size(res));
-	if (!base)
-		return -ENOMEM;
+	base = devm_platform_ioremap_resource_byname(pdev, "ti_conf");
+	if (IS_ERR(base))
+		return PTR_ERR(base);
 
 	phy_count = of_property_count_strings(np, "phy-names");
 	if (phy_count < 0) {
-- 
2.25.1

