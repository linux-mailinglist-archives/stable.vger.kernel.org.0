Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C3014832CC
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:31:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234033AbiACOax (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:30:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233662AbiACO32 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:29:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57146C07E5E7;
        Mon,  3 Jan 2022 06:28:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 22E05B80F10;
        Mon,  3 Jan 2022 14:28:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B5C8C36AF0;
        Mon,  3 Jan 2022 14:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641220132;
        bh=c6EbhrQo73/A0p5treJs6Xm126tR0mUQkKA6NKsZ4+w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=148DyDOJOWmrzy1rzpA7JoxmITBxlFLNcCsCvbGbIkblK7eJq8wdMJEfjAiqKZtR4
         JkqsCClGyJZ19xASvo72ZRZUjt+sdmivqFlCilvT0ufbEXWJwBJvyQAv4lRqHr5D3O
         f5NOjlTNlTrqI3ynMZMrfZGO/90D1PRNrh1dhWLM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 20/48] net: ag71xx: Fix a potential double free in error handling paths
Date:   Mon,  3 Jan 2022 15:23:57 +0100
Message-Id: <20220103142054.158535868@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142053.466768714@linuxfoundation.org>
References: <20220103142053.466768714@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 1cd5384c88af5b59bf9f3b6c1a151bc14b88c2cd ]

'ndev' is a managed resource allocated with devm_alloc_etherdev(), so there
is no need to call free_netdev() explicitly or there will be a double
free().

Simplify all error handling paths accordingly.

Fixes: d51b6ce441d3 ("net: ethernet: add ag71xx driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/atheros/ag71xx.c | 23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/atheros/ag71xx.c b/drivers/net/ethernet/atheros/ag71xx.c
index a60ce90305819..c26c9b0c00d8f 100644
--- a/drivers/net/ethernet/atheros/ag71xx.c
+++ b/drivers/net/ethernet/atheros/ag71xx.c
@@ -1904,15 +1904,12 @@ static int ag71xx_probe(struct platform_device *pdev)
 	ag->mac_reset = devm_reset_control_get(&pdev->dev, "mac");
 	if (IS_ERR(ag->mac_reset)) {
 		netif_err(ag, probe, ndev, "missing mac reset\n");
-		err = PTR_ERR(ag->mac_reset);
-		goto err_free;
+		return PTR_ERR(ag->mac_reset);
 	}
 
 	ag->mac_base = devm_ioremap(&pdev->dev, res->start, resource_size(res));
-	if (!ag->mac_base) {
-		err = -ENOMEM;
-		goto err_free;
-	}
+	if (!ag->mac_base)
+		return -ENOMEM;
 
 	ndev->irq = platform_get_irq(pdev, 0);
 	err = devm_request_irq(&pdev->dev, ndev->irq, ag71xx_interrupt,
@@ -1920,7 +1917,7 @@ static int ag71xx_probe(struct platform_device *pdev)
 	if (err) {
 		netif_err(ag, probe, ndev, "unable to request IRQ %d\n",
 			  ndev->irq);
-		goto err_free;
+		return err;
 	}
 
 	ndev->netdev_ops = &ag71xx_netdev_ops;
@@ -1948,10 +1945,8 @@ static int ag71xx_probe(struct platform_device *pdev)
 	ag->stop_desc = dmam_alloc_coherent(&pdev->dev,
 					    sizeof(struct ag71xx_desc),
 					    &ag->stop_desc_dma, GFP_KERNEL);
-	if (!ag->stop_desc) {
-		err = -ENOMEM;
-		goto err_free;
-	}
+	if (!ag->stop_desc)
+		return -ENOMEM;
 
 	ag->stop_desc->data = 0;
 	ag->stop_desc->ctrl = 0;
@@ -1968,7 +1963,7 @@ static int ag71xx_probe(struct platform_device *pdev)
 	err = of_get_phy_mode(np, &ag->phy_if_mode);
 	if (err) {
 		netif_err(ag, probe, ndev, "missing phy-mode property in DT\n");
-		goto err_free;
+		return err;
 	}
 
 	netif_napi_add(ndev, &ag->napi, ag71xx_poll, AG71XX_NAPI_WEIGHT);
@@ -1976,7 +1971,7 @@ static int ag71xx_probe(struct platform_device *pdev)
 	err = clk_prepare_enable(ag->clk_eth);
 	if (err) {
 		netif_err(ag, probe, ndev, "Failed to enable eth clk.\n");
-		goto err_free;
+		return err;
 	}
 
 	ag71xx_wr(ag, AG71XX_REG_MAC_CFG1, 0);
@@ -2012,8 +2007,6 @@ err_mdio_remove:
 	ag71xx_mdio_remove(ag);
 err_put_clk:
 	clk_disable_unprepare(ag->clk_eth);
-err_free:
-	free_netdev(ndev);
 	return err;
 }
 
-- 
2.34.1



