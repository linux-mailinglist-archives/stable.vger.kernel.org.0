Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54E65200FD1
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:23:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392998AbgFSPWY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:22:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:53788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392990AbgFSPWW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:22:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DB1E21548;
        Fri, 19 Jun 2020 15:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580141;
        bh=KO1X9m7NPmmKUMWAX5wnckaZR418zjtg/BYnrfIAY3Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U+0JCtQx/F+RJ7f3LtnEsgxzuYyxNL/ZqPBj1S2wC8KOzAY+LdICjlC2cKnXFIsVk
         lFLacC9n4X02isS3f230eSa01K/VAhJiTGdTtU9BOoWwQaUSyuc9vgi1mT57icEmCu
         mvRwom43uE2oSGIO7okUfPHpOeP/4B7QoO6CVEBo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Voon Weifeng <weifeng.voon@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 137/376] stmmac: intel: Fix clock handling on error and remove paths
Date:   Fri, 19 Jun 2020 16:30:55 +0200
Message-Id: <20200619141716.821321733@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 09f012e64e4b8126ed6f02d0a85a57c3a0465cf9 ]

clk_prepare_enable() might fail, we have to check its returned value.
Besides that we have to call clk_disable_unprepare() on the error and
remove paths. Do above in the dwmac-intel driver.

While at it, remove leftover in stmmac_pci and remove unneeded condition
for NULL-aware clk_unregister_fixed_rate() call.

Fixes: 58da0cfa6cf1 ("net: stmmac: create dwmac-intel.c to contain all Intel platform")
Cc: Voon Weifeng <weifeng.voon@intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/stmicro/stmmac/dwmac-intel.c | 20 +++++++++++++++----
 .../net/ethernet/stmicro/stmmac/stmmac_pci.c  |  5 -----
 2 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
index 2e4aaedb93f5..d163c4b43da0 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -252,6 +252,7 @@ static void common_default_data(struct plat_stmmacenet_data *plat)
 static int intel_mgbe_common_data(struct pci_dev *pdev,
 				  struct plat_stmmacenet_data *plat)
 {
+	int ret;
 	int i;
 
 	plat->clk_csr = 5;
@@ -324,7 +325,12 @@ static int intel_mgbe_common_data(struct pci_dev *pdev,
 		dev_warn(&pdev->dev, "Fail to register stmmac-clk\n");
 		plat->stmmac_clk = NULL;
 	}
-	clk_prepare_enable(plat->stmmac_clk);
+
+	ret = clk_prepare_enable(plat->stmmac_clk);
+	if (ret) {
+		clk_unregister_fixed_rate(plat->stmmac_clk);
+		return ret;
+	}
 
 	/* Set default value for multicast hash bins */
 	plat->multicast_filter_bins = HASH_TABLE_SIZE;
@@ -657,7 +663,13 @@ static int intel_eth_pci_probe(struct pci_dev *pdev,
 	res.wol_irq = pdev->irq;
 	res.irq = pdev->irq;
 
-	return stmmac_dvr_probe(&pdev->dev, plat, &res);
+	ret = stmmac_dvr_probe(&pdev->dev, plat, &res);
+	if (ret) {
+		clk_disable_unprepare(plat->stmmac_clk);
+		clk_unregister_fixed_rate(plat->stmmac_clk);
+	}
+
+	return ret;
 }
 
 /**
@@ -675,8 +687,8 @@ static void intel_eth_pci_remove(struct pci_dev *pdev)
 
 	stmmac_dvr_remove(&pdev->dev);
 
-	if (priv->plat->stmmac_clk)
-		clk_unregister_fixed_rate(priv->plat->stmmac_clk);
+	clk_disable_unprepare(priv->plat->stmmac_clk);
+	clk_unregister_fixed_rate(priv->plat->stmmac_clk);
 
 	for (i = 0; i < PCI_STD_NUM_BARS; i++) {
 		if (pci_resource_len(pdev, i) == 0)
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
index 3fb21f7ac9fb..272cb47af9f2 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
@@ -217,15 +217,10 @@ static int stmmac_pci_probe(struct pci_dev *pdev,
  */
 static void stmmac_pci_remove(struct pci_dev *pdev)
 {
-	struct net_device *ndev = dev_get_drvdata(&pdev->dev);
-	struct stmmac_priv *priv = netdev_priv(ndev);
 	int i;
 
 	stmmac_dvr_remove(&pdev->dev);
 
-	if (priv->plat->stmmac_clk)
-		clk_unregister_fixed_rate(priv->plat->stmmac_clk);
-
 	for (i = 0; i < PCI_STD_NUM_BARS; i++) {
 		if (pci_resource_len(pdev, i) == 0)
 			continue;
-- 
2.25.1



