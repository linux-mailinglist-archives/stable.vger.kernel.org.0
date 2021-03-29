Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0163334CAA7
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234795AbhC2Ij0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:39:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:60600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235115AbhC2IiE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:38:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B544D61581;
        Mon, 29 Mar 2021 08:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617007084;
        bh=A/203q7merzu8l+NtZeOtFUksOdBpc33Y4X119Ahxvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vr9HW5Lwop0m9E6bTEqJYo48L9DVohBI4tPi+4W3v8CorIAi2h+HlO56tpOk0iONY
         PzfTdmw0VrAcLyvSwaSkUidwE37f7E6CakG0+IZd7q6kxtUJdXuHlCEHySo1MEPJJD
         LbCfFaYUw9ZukVo/34I5TmoIgQ/AQDkgFCCZzCJs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Hancock <robert.hancock@calian.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 215/254] net: axienet: Fix probe error cleanup
Date:   Mon, 29 Mar 2021 09:58:51 +0200
Message-Id: <20210329075640.167245132@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Hancock <robert.hancock@calian.com>

[ Upstream commit 59cd4f19267a0aab87a8c07e4426eb7187ee548d ]

The driver did not always clean up all allocated resources when probe
failed. Fix the probe cleanup path to clean up everything that was
allocated.

Fixes: 57baf8cc70ea ("net: axienet: Handle deferred probe on clock properly")
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 35 +++++++++++++------
 1 file changed, 24 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index b4a0bfce5b76..4cd701a9277d 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1835,7 +1835,7 @@ static int axienet_probe(struct platform_device *pdev)
 	if (IS_ERR(lp->regs)) {
 		dev_err(&pdev->dev, "could not map Axi Ethernet regs.\n");
 		ret = PTR_ERR(lp->regs);
-		goto free_netdev;
+		goto cleanup_clk;
 	}
 	lp->regs_start = ethres->start;
 
@@ -1910,12 +1910,12 @@ static int axienet_probe(struct platform_device *pdev)
 			break;
 		default:
 			ret = -EINVAL;
-			goto free_netdev;
+			goto cleanup_clk;
 		}
 	} else {
 		ret = of_get_phy_mode(pdev->dev.of_node, &lp->phy_mode);
 		if (ret)
-			goto free_netdev;
+			goto cleanup_clk;
 	}
 
 	/* Find the DMA node, map the DMA registers, and decode the DMA IRQs */
@@ -1928,7 +1928,7 @@ static int axienet_probe(struct platform_device *pdev)
 			dev_err(&pdev->dev,
 				"unable to get DMA resource\n");
 			of_node_put(np);
-			goto free_netdev;
+			goto cleanup_clk;
 		}
 		lp->dma_regs = devm_ioremap_resource(&pdev->dev,
 						     &dmares);
@@ -1948,12 +1948,12 @@ static int axienet_probe(struct platform_device *pdev)
 	if (IS_ERR(lp->dma_regs)) {
 		dev_err(&pdev->dev, "could not map DMA regs\n");
 		ret = PTR_ERR(lp->dma_regs);
-		goto free_netdev;
+		goto cleanup_clk;
 	}
 	if ((lp->rx_irq <= 0) || (lp->tx_irq <= 0)) {
 		dev_err(&pdev->dev, "could not determine irqs\n");
 		ret = -ENOMEM;
-		goto free_netdev;
+		goto cleanup_clk;
 	}
 
 	/* Autodetect the need for 64-bit DMA pointers.
@@ -1983,7 +1983,7 @@ static int axienet_probe(struct platform_device *pdev)
 	ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(addr_width));
 	if (ret) {
 		dev_err(&pdev->dev, "No suitable DMA available\n");
-		goto free_netdev;
+		goto cleanup_clk;
 	}
 
 	/* Check for Ethernet core IRQ (optional) */
@@ -2014,12 +2014,12 @@ static int axienet_probe(struct platform_device *pdev)
 		if (!lp->phy_node) {
 			dev_err(&pdev->dev, "phy-handle required for 1000BaseX/SGMII\n");
 			ret = -EINVAL;
-			goto free_netdev;
+			goto cleanup_mdio;
 		}
 		lp->pcs_phy = of_mdio_find_device(lp->phy_node);
 		if (!lp->pcs_phy) {
 			ret = -EPROBE_DEFER;
-			goto free_netdev;
+			goto cleanup_mdio;
 		}
 		lp->phylink_config.pcs_poll = true;
 	}
@@ -2033,17 +2033,30 @@ static int axienet_probe(struct platform_device *pdev)
 	if (IS_ERR(lp->phylink)) {
 		ret = PTR_ERR(lp->phylink);
 		dev_err(&pdev->dev, "phylink_create error (%i)\n", ret);
-		goto free_netdev;
+		goto cleanup_mdio;
 	}
 
 	ret = register_netdev(lp->ndev);
 	if (ret) {
 		dev_err(lp->dev, "register_netdev() error (%i)\n", ret);
-		goto free_netdev;
+		goto cleanup_phylink;
 	}
 
 	return 0;
 
+cleanup_phylink:
+	phylink_destroy(lp->phylink);
+
+cleanup_mdio:
+	if (lp->pcs_phy)
+		put_device(&lp->pcs_phy->dev);
+	if (lp->mii_bus)
+		axienet_mdio_teardown(lp);
+	of_node_put(lp->phy_node);
+
+cleanup_clk:
+	clk_disable_unprepare(lp->clk);
+
 free_netdev:
 	free_netdev(ndev);
 
-- 
2.30.1



