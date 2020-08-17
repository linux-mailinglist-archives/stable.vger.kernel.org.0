Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1732C247618
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404224AbgHQTdO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:33:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:54128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730256AbgHQPbD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:31:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3072E22BEF;
        Mon, 17 Aug 2020 15:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678262;
        bh=GcF9Oe8I5nbSA24PxJyVGNRfg6ycr/7DGFIS9wrAiJc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bfjKkb5K8EIvJCB0S78pWRy/L4CMB41Q4+L5lloiZkYJ1jOwBNTyJisIc7M+nQWy+
         p9Tk8E/3+1vhltJSkxe9dt1JPqjOwsJMPW72k7uno8mHJ4u9w0P8jtXuAzKEV1457D
         IjELZ1kcWu6wto3MhoLVUEEEjt0VfTzZDB3BmVJk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, Vinod Koul <vkoul@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 273/464] phy: armada-38x: fix NETA lockup when repeatedly switching speeds
Date:   Mon, 17 Aug 2020 17:13:46 +0200
Message-Id: <20200817143846.857053651@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

[ Upstream commit 1dea06cd643da38931382ebdc151efced201ffad ]

The mvneta hardware appears to lock up in various random ways when
repeatedly switching speeds between 1G and 2.5G, which involves
reprogramming the COMPHY.  It is not entirely clear why this happens,
but best guess is that reprogramming the COMPHY glitches mvneta clocks
causing the hardware to fail.  It seems that rebooting resolves the
failure, but not down/up cycling the interface alone.

Various other approaches have been tried, such as trying to cleanly
power down the COMPHY and then take it back through the power up
initialisation, but this does not seem to help.

It was finally noticed that u-boot's last step when configuring a
COMPHY for "SGMII" mode was to poke at a register described as
"GBE_CONFIGURATION_REG", which is undocumented in any external
documentation.  All that we have is the fact that u-boot sets a bit
corresponding to the "SGMII" lane at the end of COMPHY initialisation.

Experimentation shows that if we clear this bit prior to changing the
speed, and then set it afterwards, mvneta does not suffer this problem
on the SolidRun Clearfog when switching speeds between 1G and 2.5G.

This problem was found while script-testing phylink.

This fix also requires the corresponding change to DT to be effective.
See "ARM: dts: armada-38x: fix NETA lockup when repeatedly switching
speeds".

Fixes: 14dc100b4411 ("phy: armada38x: add common phy support")
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/E1jxtRj-0003Tz-CG@rmk-PC.armlinux.org.uk
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/marvell/phy-armada38x-comphy.c | 45 ++++++++++++++++++----
 1 file changed, 38 insertions(+), 7 deletions(-)

diff --git a/drivers/phy/marvell/phy-armada38x-comphy.c b/drivers/phy/marvell/phy-armada38x-comphy.c
index 6960dfd8ad8c9..0fe4089643342 100644
--- a/drivers/phy/marvell/phy-armada38x-comphy.c
+++ b/drivers/phy/marvell/phy-armada38x-comphy.c
@@ -41,6 +41,7 @@ struct a38x_comphy_lane {
 
 struct a38x_comphy {
 	void __iomem *base;
+	void __iomem *conf;
 	struct device *dev;
 	struct a38x_comphy_lane lane[MAX_A38X_COMPHY];
 };
@@ -54,6 +55,21 @@ static const u8 gbe_mux[MAX_A38X_COMPHY][MAX_A38X_PORTS] = {
 	{ 0, 0, 3 },
 };
 
+static void a38x_set_conf(struct a38x_comphy_lane *lane, bool enable)
+{
+	struct a38x_comphy *priv = lane->priv;
+	u32 conf;
+
+	if (priv->conf) {
+		conf = readl_relaxed(priv->conf);
+		if (enable)
+			conf |= BIT(lane->port);
+		else
+			conf &= ~BIT(lane->port);
+		writel(conf, priv->conf);
+	}
+}
+
 static void a38x_comphy_set_reg(struct a38x_comphy_lane *lane,
 				unsigned int offset, u32 mask, u32 value)
 {
@@ -97,6 +113,7 @@ static int a38x_comphy_set_mode(struct phy *phy, enum phy_mode mode, int sub)
 {
 	struct a38x_comphy_lane *lane = phy_get_drvdata(phy);
 	unsigned int gen;
+	int ret;
 
 	if (mode != PHY_MODE_ETHERNET)
 		return -EINVAL;
@@ -115,13 +132,20 @@ static int a38x_comphy_set_mode(struct phy *phy, enum phy_mode mode, int sub)
 		return -EINVAL;
 	}
 
+	a38x_set_conf(lane, false);
+
 	a38x_comphy_set_speed(lane, gen, gen);
 
-	return a38x_comphy_poll(lane, COMPHY_STAT1,
-				COMPHY_STAT1_PLL_RDY_TX |
-				COMPHY_STAT1_PLL_RDY_RX,
-				COMPHY_STAT1_PLL_RDY_TX |
-				COMPHY_STAT1_PLL_RDY_RX);
+	ret = a38x_comphy_poll(lane, COMPHY_STAT1,
+			       COMPHY_STAT1_PLL_RDY_TX |
+			       COMPHY_STAT1_PLL_RDY_RX,
+			       COMPHY_STAT1_PLL_RDY_TX |
+			       COMPHY_STAT1_PLL_RDY_RX);
+
+	if (ret == 0)
+		a38x_set_conf(lane, true);
+
+	return ret;
 }
 
 static const struct phy_ops a38x_comphy_ops = {
@@ -174,14 +198,21 @@ static int a38x_comphy_probe(struct platform_device *pdev)
 	if (!priv)
 		return -ENOMEM;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	base = devm_ioremap_resource(&pdev->dev, res);
+	base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(base))
 		return PTR_ERR(base);
 
 	priv->dev = &pdev->dev;
 	priv->base = base;
 
+	/* Optional */
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "conf");
+	if (res) {
+		priv->conf = devm_ioremap_resource(&pdev->dev, res);
+		if (IS_ERR(priv->conf))
+			return PTR_ERR(priv->conf);
+	}
+
 	for_each_available_child_of_node(pdev->dev.of_node, child) {
 		struct phy *phy;
 		int ret;
-- 
2.25.1



