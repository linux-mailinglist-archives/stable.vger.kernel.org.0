Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DC67328D62
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:12:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235646AbhCATJY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:09:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:34916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240890AbhCATFg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:05:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B11EF64F2F;
        Mon,  1 Mar 2021 17:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620358;
        bh=J5YOrgjPXyAs7hXWSJQPrrUZ/gh3p0DJj1cjo15DZeM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ya3g9zlepSViV35iZ0uH3gsv+DOhO22qLO5uln3hdi9bwvafwhJP35Gzz+VFouY44
         mX9+oPsKXd19fff31X5rK9anzw2mSCYb6zfY6VdmO0xvKDduDeEz4uZHKzcXeHxkHC
         /9DGTJCKz6WgvTyvfgEiaRR/2I3+6PC3XAemP2u4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Hancock <robert.hancock@calian.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 124/775] net: axienet: Handle deferred probe on clock properly
Date:   Mon,  1 Mar 2021 17:04:52 +0100
Message-Id: <20210301161207.800242344@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Hancock <robert.hancock@calian.com>

[ Upstream commit 57baf8cc70ea4cf5503c9d42f31f6a86d7f5ff1a ]

This driver is set up to use a clock mapping in the device tree if it is
present, but still work without one for backward compatibility. However,
if getting the clock returns -EPROBE_DEFER, then we need to abort and
return that error from our driver initialization so that the probe can
be retried later after the clock is set up.

Move clock initialization to earlier in the process so we do not waste as
much effort if the clock is not yet available. Switch to use
devm_clk_get_optional and abort initialization on any error reported.
Also enable the clock regardless of whether the controller is using an MDIO
bus, as the clock is required in any case.

Fixes: 09a0354cadec267be7f ("net: axienet: Use clock framework to get device clock rate")
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 26 +++++++++----------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 6fea980acf646..b4a0bfce5b762 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1817,6 +1817,18 @@ static int axienet_probe(struct platform_device *pdev)
 	lp->options = XAE_OPTION_DEFAULTS;
 	lp->rx_bd_num = RX_BD_NUM_DEFAULT;
 	lp->tx_bd_num = TX_BD_NUM_DEFAULT;
+
+	lp->clk = devm_clk_get_optional(&pdev->dev, NULL);
+	if (IS_ERR(lp->clk)) {
+		ret = PTR_ERR(lp->clk);
+		goto free_netdev;
+	}
+	ret = clk_prepare_enable(lp->clk);
+	if (ret) {
+		dev_err(&pdev->dev, "Unable to enable clock: %d\n", ret);
+		goto free_netdev;
+	}
+
 	/* Map device registers */
 	ethres = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	lp->regs = devm_ioremap_resource(&pdev->dev, ethres);
@@ -1992,20 +2004,6 @@ static int axienet_probe(struct platform_device *pdev)
 
 	lp->phy_node = of_parse_phandle(pdev->dev.of_node, "phy-handle", 0);
 	if (lp->phy_node) {
-		lp->clk = devm_clk_get(&pdev->dev, NULL);
-		if (IS_ERR(lp->clk)) {
-			dev_warn(&pdev->dev, "Failed to get clock: %ld\n",
-				 PTR_ERR(lp->clk));
-			lp->clk = NULL;
-		} else {
-			ret = clk_prepare_enable(lp->clk);
-			if (ret) {
-				dev_err(&pdev->dev, "Unable to enable clock: %d\n",
-					ret);
-				goto free_netdev;
-			}
-		}
-
 		ret = axienet_mdio_setup(lp);
 		if (ret)
 			dev_warn(&pdev->dev,
-- 
2.27.0



