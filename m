Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB9E93CA6F6
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238960AbhGOSvf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:51:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:52350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239793AbhGOSuz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:50:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5CF3A613DA;
        Thu, 15 Jul 2021 18:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626374872;
        bh=dT8hcCxhperB/T+8aYy1wP8AerwINrRNIYBFnfhjs7g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GaEfnnu3mwfaAbB5r4JvzutNfP43QfKD9xE8YpA4JYXXJPdMj7QTxwgRSFxCz5S2+
         rrXs+pe2ovtpMqedGvs0hwza80swLguBY91KA7iLC4PvVjo03qIt/xrr6C32DPUADQ
         2nu4q27Ds83ADk8R1EDFNGp6AqZLztPY8gTIWmwo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ansuel Smith <ansuelsmth@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 017/215] net: mdio: ipq8064: add regmap config to disable REGCACHE
Date:   Thu, 15 Jul 2021 20:36:29 +0200
Message-Id: <20210715182601.755083135@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182558.381078833@linuxfoundation.org>
References: <20210715182558.381078833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ansuel Smith <ansuelsmth@gmail.com>

[ Upstream commit b097bea10215315e8ee17f88b4c1bbb521b1878c ]

mdio drivers should not use REGCHACHE. Also disable locking since it's
handled by the mdio users and regmap is always accessed atomically.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/mdio/mdio-ipq8064.c | 33 ++++++++++++++++++++++++---------
 1 file changed, 24 insertions(+), 9 deletions(-)

diff --git a/drivers/net/mdio/mdio-ipq8064.c b/drivers/net/mdio/mdio-ipq8064.c
index 1bd18857e1c5..f0a6bfa61645 100644
--- a/drivers/net/mdio/mdio-ipq8064.c
+++ b/drivers/net/mdio/mdio-ipq8064.c
@@ -10,7 +10,7 @@
 #include <linux/module.h>
 #include <linux/regmap.h>
 #include <linux/of_mdio.h>
-#include <linux/phy.h>
+#include <linux/of_address.h>
 #include <linux/platform_device.h>
 #include <linux/mfd/syscon.h>
 
@@ -96,14 +96,34 @@ ipq8064_mdio_write(struct mii_bus *bus, int phy_addr, int reg_offset, u16 data)
 	return ipq8064_mdio_wait_busy(priv);
 }
 
+static const struct regmap_config ipq8064_mdio_regmap_config = {
+	.reg_bits = 32,
+	.reg_stride = 4,
+	.val_bits = 32,
+	.can_multi_write = false,
+	/* the mdio lock is used by any user of this mdio driver */
+	.disable_locking = true,
+
+	.cache_type = REGCACHE_NONE,
+};
+
 static int
 ipq8064_mdio_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
 	struct ipq8064_mdio *priv;
+	struct resource res;
 	struct mii_bus *bus;
+	void __iomem *base;
 	int ret;
 
+	if (of_address_to_resource(np, 0, &res))
+		return -ENOMEM;
+
+	base = ioremap(res.start, resource_size(&res));
+	if (!base)
+		return -ENOMEM;
+
 	bus = devm_mdiobus_alloc_size(&pdev->dev, sizeof(*priv));
 	if (!bus)
 		return -ENOMEM;
@@ -115,15 +135,10 @@ ipq8064_mdio_probe(struct platform_device *pdev)
 	bus->parent = &pdev->dev;
 
 	priv = bus->priv;
-	priv->base = device_node_to_regmap(np);
-	if (IS_ERR(priv->base)) {
-		if (priv->base == ERR_PTR(-EPROBE_DEFER))
-			return -EPROBE_DEFER;
-
-		dev_err(&pdev->dev, "error getting device regmap, error=%pe\n",
-			priv->base);
+	priv->base = devm_regmap_init_mmio(&pdev->dev, base,
+					   &ipq8064_mdio_regmap_config);
+	if (IS_ERR(priv->base))
 		return PTR_ERR(priv->base);
-	}
 
 	ret = of_mdiobus_register(bus, np);
 	if (ret)
-- 
2.30.2



