Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C543A1017AE
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:03:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729778AbfKSFkN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:40:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:34330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730367AbfKSFkM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:40:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE6BA21783;
        Tue, 19 Nov 2019 05:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142011;
        bh=X1BSDj7yVpDkdHnzecGboQR5aPjvRN2RmNz7kfu0+NE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0rCIp0mPhhmc6mnRPeqVpbsXO/teLn4drr3AYx/nfLdL1GiEwOHMkXbxfSio1lioz
         jKsBZ6EKk9nS5C2BMkMNmWL3AvA/r0I20AhXpeV30+XDS5eJxIK2WrDokkB+3NzxN6
         Nw+hHjr/EMpYiU+HvK8czSFiggtdfBRPvszwBOaY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 317/422] net: phy: mdio-bcm-unimac: Allow configuring MDIO clock divider
Date:   Tue, 19 Nov 2019 06:18:34 +0100
Message-Id: <20191119051419.535414678@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit b78ac6ecd1b6b46f8767cbafa95a7b0b51b87ad8 ]

Allow the configuration of the MDIO clock divider when the Device Tree
contains 'clock-frequency' property (similar to I2C and SPI buses).
Because the hardware may have lost its state during suspend/resume,
re-apply the MDIO clock divider upon resumption.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../bindings/net/brcm,unimac-mdio.txt         |  3 +
 drivers/net/phy/mdio-bcm-unimac.c             | 83 ++++++++++++++++++-
 2 files changed, 84 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/brcm,unimac-mdio.txt b/Documentation/devicetree/bindings/net/brcm,unimac-mdio.txt
index 4648948f7c3b8..e15589f477876 100644
--- a/Documentation/devicetree/bindings/net/brcm,unimac-mdio.txt
+++ b/Documentation/devicetree/bindings/net/brcm,unimac-mdio.txt
@@ -19,6 +19,9 @@ Optional properties:
 - interrupt-names: must be "mdio_done_error" when there is a share interrupt fed
   to this hardware block, or must be "mdio_done" for the first interrupt and
   "mdio_error" for the second when there are separate interrupts
+- clocks: A reference to the clock supplying the MDIO bus controller
+- clock-frequency: the MDIO bus clock that must be output by the MDIO bus
+  hardware, if absent, the default hardware values are used
 
 Child nodes of this MDIO bus controller node are standard Ethernet PHY device
 nodes as described in Documentation/devicetree/bindings/net/phy.txt
diff --git a/drivers/net/phy/mdio-bcm-unimac.c b/drivers/net/phy/mdio-bcm-unimac.c
index 8d370667fa1b3..80b9583eaa952 100644
--- a/drivers/net/phy/mdio-bcm-unimac.c
+++ b/drivers/net/phy/mdio-bcm-unimac.c
@@ -16,6 +16,7 @@
 #include <linux/module.h>
 #include <linux/io.h>
 #include <linux/delay.h>
+#include <linux/clk.h>
 
 #include <linux/of.h>
 #include <linux/of_platform.h>
@@ -45,6 +46,8 @@ struct unimac_mdio_priv {
 	void __iomem		*base;
 	int (*wait_func)	(void *wait_func_data);
 	void			*wait_func_data;
+	struct clk		*clk;
+	u32			clk_freq;
 };
 
 static inline u32 unimac_mdio_readl(struct unimac_mdio_priv *priv, u32 offset)
@@ -189,6 +192,35 @@ static int unimac_mdio_reset(struct mii_bus *bus)
 	return 0;
 }
 
+static void unimac_mdio_clk_set(struct unimac_mdio_priv *priv)
+{
+	unsigned long rate;
+	u32 reg, div;
+
+	/* Keep the hardware default values */
+	if (!priv->clk_freq)
+		return;
+
+	if (!priv->clk)
+		rate = 250000000;
+	else
+		rate = clk_get_rate(priv->clk);
+
+	div = (rate / (2 * priv->clk_freq)) - 1;
+	if (div & ~MDIO_CLK_DIV_MASK) {
+		pr_warn("Incorrect MDIO clock frequency, ignoring\n");
+		return;
+	}
+
+	/* The MDIO clock is the reference clock (typicaly 250Mhz) divided by
+	 * 2 x (MDIO_CLK_DIV + 1)
+	 */
+	reg = unimac_mdio_readl(priv, MDIO_CFG);
+	reg &= ~(MDIO_CLK_DIV_MASK << MDIO_CLK_DIV_SHIFT);
+	reg |= div << MDIO_CLK_DIV_SHIFT;
+	unimac_mdio_writel(priv, reg, MDIO_CFG);
+}
+
 static int unimac_mdio_probe(struct platform_device *pdev)
 {
 	struct unimac_mdio_pdata *pdata = pdev->dev.platform_data;
@@ -217,9 +249,26 @@ static int unimac_mdio_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
+	priv->clk = devm_clk_get(&pdev->dev, NULL);
+	if (PTR_ERR(priv->clk) == -EPROBE_DEFER)
+		return PTR_ERR(priv->clk);
+	else
+		priv->clk = NULL;
+
+	ret = clk_prepare_enable(priv->clk);
+	if (ret)
+		return ret;
+
+	if (of_property_read_u32(np, "clock-frequency", &priv->clk_freq))
+		priv->clk_freq = 0;
+
+	unimac_mdio_clk_set(priv);
+
 	priv->mii_bus = mdiobus_alloc();
-	if (!priv->mii_bus)
-		return -ENOMEM;
+	if (!priv->mii_bus) {
+		ret = -ENOMEM;
+		goto out_clk_disable;
+	}
 
 	bus = priv->mii_bus;
 	bus->priv = priv;
@@ -253,6 +302,8 @@ static int unimac_mdio_probe(struct platform_device *pdev)
 
 out_mdio_free:
 	mdiobus_free(bus);
+out_clk_disable:
+	clk_disable_unprepare(priv->clk);
 	return ret;
 }
 
@@ -262,10 +313,37 @@ static int unimac_mdio_remove(struct platform_device *pdev)
 
 	mdiobus_unregister(priv->mii_bus);
 	mdiobus_free(priv->mii_bus);
+	clk_disable_unprepare(priv->clk);
+
+	return 0;
+}
+
+static int unimac_mdio_suspend(struct device *d)
+{
+	struct unimac_mdio_priv *priv = dev_get_drvdata(d);
+
+	clk_disable_unprepare(priv->clk);
+
+	return 0;
+}
+
+static int unimac_mdio_resume(struct device *d)
+{
+	struct unimac_mdio_priv *priv = dev_get_drvdata(d);
+	int ret;
+
+	ret = clk_prepare_enable(priv->clk);
+	if (ret)
+		return ret;
+
+	unimac_mdio_clk_set(priv);
 
 	return 0;
 }
 
+static SIMPLE_DEV_PM_OPS(unimac_mdio_pm_ops,
+			 unimac_mdio_suspend, unimac_mdio_resume);
+
 static const struct of_device_id unimac_mdio_ids[] = {
 	{ .compatible = "brcm,genet-mdio-v5", },
 	{ .compatible = "brcm,genet-mdio-v4", },
@@ -281,6 +359,7 @@ static struct platform_driver unimac_mdio_driver = {
 	.driver = {
 		.name = UNIMAC_MDIO_DRV_NAME,
 		.of_match_table = unimac_mdio_ids,
+		.pm = &unimac_mdio_pm_ops,
 	},
 	.probe	= unimac_mdio_probe,
 	.remove	= unimac_mdio_remove,
-- 
2.20.1



