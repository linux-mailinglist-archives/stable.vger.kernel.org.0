Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D10F205D47
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:14:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388890AbgFWULX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:11:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:52652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388884AbgFWULW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:11:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 314ED206C3;
        Tue, 23 Jun 2020 20:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943081;
        bh=R8FjzKUt+iLtGRH7GJ/8P6ElA1KiTTqRoMswO6ejsC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cy0fMJkf6j//lrihFH/Hkhd+HiqRHzrJb/3lAs98ZO6Ptr4HRp5931pElbJr0b1Zm
         wv05jceZY13f0EJitqEcCktNNYvO15MX6q3YALLuW58gvJJc1yyA3G5fgw9phglBHo
         ZgQs9tWJv85K44s2Lufm3tZ2sz95yUiAMDi3fKAE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Yongjun <weiyongjun1@huawei.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 253/477] PCI: dwc: pci-dra7xx: Use devm_platform_ioremap_resource_byname()
Date:   Tue, 23 Jun 2020 21:54:10 +0200
Message-Id: <20200623195419.531633835@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 3b0e58f2de588..6184ebc9392db 100644
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



