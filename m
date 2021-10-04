Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 079C4420DC1
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236381AbhJDNSL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:18:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:53980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234436AbhJDNQV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:16:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9626F61BB2;
        Mon,  4 Oct 2021 13:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352793;
        bh=n1CoMQiKBXVMk5YwYTLUvIGd8zllXLDTXO9xNoJVG5I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ou8v8/il8XjsMM/BmSIwdjEt4vpGTjTVlC1ecNdZhkrzZisbBpsboADcC2UxvVozN
         bgiRtetGVEcpgTStV6rHmpL35TZkZWRIH8khvNW1wEVWrcKvK2TBj1AlF6RiUuRqp8
         Gf2pEeCrnmcRx2Xz/CX6M6uoek7Xp6vDIUghK3uM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 29/56] net: phy: bcm7xxx: request and manage GPHY clock
Date:   Mon,  4 Oct 2021 14:52:49 +0200
Message-Id: <20211004125030.918133685@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125030.002116402@linuxfoundation.org>
References: <20211004125030.002116402@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit ba4ee3c053659119472135231dbef8f6880ce1fb ]

The internal Gigabit PHY on Broadcom STB chips has a digital clock which
drives its MDIO interface among other things, the driver now requests
and manage that clock during .probe() and .remove() accordingly.

Because the PHY driver can be probed with the clocks turned off we need
to apply the dummy BMSR workaround during the driver probe function to
ensure subsequent MDIO read or write towards the PHY will succeed.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/bcm7xxx.c | 30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/bcm7xxx.c b/drivers/net/phy/bcm7xxx.c
index af8eabe7a6d4..e68dd2e9443c 100644
--- a/drivers/net/phy/bcm7xxx.c
+++ b/drivers/net/phy/bcm7xxx.c
@@ -11,6 +11,7 @@
 #include "bcm-phy-lib.h"
 #include <linux/bitops.h>
 #include <linux/brcmphy.h>
+#include <linux/clk.h>
 #include <linux/mdio.h>
 
 /* Broadcom BCM7xxx internal PHY registers */
@@ -39,6 +40,7 @@
 
 struct bcm7xxx_phy_priv {
 	u64	*stats;
+	struct clk *clk;
 };
 
 static int bcm7xxx_28nm_d0_afe_config_init(struct phy_device *phydev)
@@ -517,6 +519,7 @@ static void bcm7xxx_28nm_get_phy_stats(struct phy_device *phydev,
 static int bcm7xxx_28nm_probe(struct phy_device *phydev)
 {
 	struct bcm7xxx_phy_priv *priv;
+	int ret = 0;
 
 	priv = devm_kzalloc(&phydev->mdio.dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
@@ -530,7 +533,30 @@ static int bcm7xxx_28nm_probe(struct phy_device *phydev)
 	if (!priv->stats)
 		return -ENOMEM;
 
-	return 0;
+	priv->clk = devm_clk_get_optional(&phydev->mdio.dev, NULL);
+	if (IS_ERR(priv->clk))
+		return PTR_ERR(priv->clk);
+
+	ret = clk_prepare_enable(priv->clk);
+	if (ret)
+		return ret;
+
+	/* Dummy read to a register to workaround an issue upon reset where the
+	 * internal inverter may not allow the first MDIO transaction to pass
+	 * the MDIO management controller and make us return 0xffff for such
+	 * reads. This is needed to ensure that any subsequent reads to the
+	 * PHY will succeed.
+	 */
+	phy_read(phydev, MII_BMSR);
+
+	return ret;
+}
+
+static void bcm7xxx_28nm_remove(struct phy_device *phydev)
+{
+	struct bcm7xxx_phy_priv *priv = phydev->priv;
+
+	clk_disable_unprepare(priv->clk);
 }
 
 #define BCM7XXX_28NM_GPHY(_oui, _name)					\
@@ -548,6 +574,7 @@ static int bcm7xxx_28nm_probe(struct phy_device *phydev)
 	.get_strings	= bcm_phy_get_strings,				\
 	.get_stats	= bcm7xxx_28nm_get_phy_stats,			\
 	.probe		= bcm7xxx_28nm_probe,				\
+	.remove		= bcm7xxx_28nm_remove,				\
 }
 
 #define BCM7XXX_28NM_EPHY(_oui, _name)					\
@@ -563,6 +590,7 @@ static int bcm7xxx_28nm_probe(struct phy_device *phydev)
 	.get_strings	= bcm_phy_get_strings,				\
 	.get_stats	= bcm7xxx_28nm_get_phy_stats,			\
 	.probe		= bcm7xxx_28nm_probe,				\
+	.remove		= bcm7xxx_28nm_remove,				\
 }
 
 #define BCM7XXX_40NM_EPHY(_oui, _name)					\
-- 
2.33.0



