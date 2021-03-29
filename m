Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BA4434C962
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233594AbhC2I3j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:29:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:42698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233976AbhC2I1i (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:27:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB7666197F;
        Mon, 29 Mar 2021 08:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006381;
        bh=lF4aGwFHBMwI+uLg2etwxt9XCDznOsxLVKCUIWI1Igk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sw4qGKxKFtUMazUcpip0bAZ/M8Hlj8iifD6yjH/1ldcrhXMWeSos9EtqYJ6nhtfvy
         OzEQBgRtKgYph92PNQz/+HvT4trTFJHl8kYgc6Wn8dmkL/fufTuSfksXdcIwoCfDSY
         3ehzbtB8n88x6iBZKOejQlwL2cZvQ7D/F/fgpltA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Michael Walle <michael@walle.cc>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 185/221] net: phy: introduce phydev->port
Date:   Mon, 29 Mar 2021 09:58:36 +0200
Message-Id: <20210329075635.306730841@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Walle <michael@walle.cc>

[ Upstream commit 4217a64e18a1647a0dbc68cb3169a5a06f054ec8 ]

At the moment, PORT_MII is reported in the ethtool ops. This is odd
because it is an interface between the MAC and the PHY and no external
port. Some network card drivers will overwrite the port to twisted pair
or fiber, though. Even worse, the MDI/MDIX setting is only used by
ethtool if the port is twisted pair.

Set the port to PORT_TP by default because most PHY drivers are copper
ones. If there is fibre support and it is enabled, the PHY driver will
set it to PORT_FIBRE.

This will change reporting PORT_MII to either PORT_TP or PORT_FIBRE;
except for the genphy fallback driver.

Suggested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Michael Walle <michael@walle.cc>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/broadcom.c   |  2 ++
 drivers/net/phy/dp83822.c    |  3 +++
 drivers/net/phy/dp83869.c    |  4 ++++
 drivers/net/phy/lxt.c        |  1 +
 drivers/net/phy/marvell.c    |  1 +
 drivers/net/phy/marvell10g.c |  2 ++
 drivers/net/phy/micrel.c     | 14 +++++++++++---
 drivers/net/phy/phy.c        |  2 +-
 drivers/net/phy/phy_device.c |  9 +++++++++
 include/linux/phy.h          |  2 ++
 10 files changed, 36 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
index 69713ea36d4e..739efcce6dd5 100644
--- a/drivers/net/phy/broadcom.c
+++ b/drivers/net/phy/broadcom.c
@@ -505,6 +505,8 @@ static int bcm54616s_probe(struct phy_device *phydev)
 		 */
 		if (!(val & BCM54616S_100FX_MODE))
 			phydev->dev_flags |= PHY_BCM_FLAGS_MODE_1000BX;
+
+		phydev->port = PORT_FIBRE;
 	}
 
 	return 0;
diff --git a/drivers/net/phy/dp83822.c b/drivers/net/phy/dp83822.c
index c162c9551bd1..a9b058bb1be8 100644
--- a/drivers/net/phy/dp83822.c
+++ b/drivers/net/phy/dp83822.c
@@ -534,6 +534,9 @@ static int dp83822_probe(struct phy_device *phydev)
 
 	dp83822_of_init(phydev);
 
+	if (dp83822->fx_enabled)
+		phydev->port = PORT_FIBRE;
+
 	return 0;
 }
 
diff --git a/drivers/net/phy/dp83869.c b/drivers/net/phy/dp83869.c
index cf6dec7b7d8e..a9daff88006b 100644
--- a/drivers/net/phy/dp83869.c
+++ b/drivers/net/phy/dp83869.c
@@ -821,6 +821,10 @@ static int dp83869_probe(struct phy_device *phydev)
 	if (ret)
 		return ret;
 
+	if (dp83869->mode == DP83869_RGMII_100_BASE ||
+	    dp83869->mode == DP83869_RGMII_1000_BASE)
+		phydev->port = PORT_FIBRE;
+
 	return dp83869_config_init(phydev);
 }
 
diff --git a/drivers/net/phy/lxt.c b/drivers/net/phy/lxt.c
index fec58ad69e02..cb8e4f0215fe 100644
--- a/drivers/net/phy/lxt.c
+++ b/drivers/net/phy/lxt.c
@@ -218,6 +218,7 @@ static int lxt973_probe(struct phy_device *phydev)
 		phy_write(phydev, MII_BMCR, val);
 		/* Remember that the port is in fiber mode. */
 		phydev->priv = lxt973_probe;
+		phydev->port = PORT_FIBRE;
 	} else {
 		phydev->priv = NULL;
 	}
diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 5aec673a0120..5dbdaf0f5f09 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -1449,6 +1449,7 @@ static int marvell_read_status_page(struct phy_device *phydev, int page)
 	phydev->asym_pause = 0;
 	phydev->speed = SPEED_UNKNOWN;
 	phydev->duplex = DUPLEX_UNKNOWN;
+	phydev->port = fiber ? PORT_FIBRE : PORT_TP;
 
 	if (phydev->autoneg == AUTONEG_ENABLE)
 		err = marvell_read_status_page_an(phydev, fiber, status);
diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index 1901ba277413..b1bb9b8e1e4e 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -631,6 +631,7 @@ static int mv3310_read_status_10gbaser(struct phy_device *phydev)
 	phydev->link = 1;
 	phydev->speed = SPEED_10000;
 	phydev->duplex = DUPLEX_FULL;
+	phydev->port = PORT_FIBRE;
 
 	return 0;
 }
@@ -690,6 +691,7 @@ static int mv3310_read_status_copper(struct phy_device *phydev)
 
 	phydev->duplex = cssr1 & MV_PCS_CSSR1_DUPLEX_FULL ?
 			 DUPLEX_FULL : DUPLEX_HALF;
+	phydev->port = PORT_TP;
 	phydev->mdix = cssr1 & MV_PCS_CSSR1_MDIX ?
 		       ETH_TP_MDI_X : ETH_TP_MDI;
 
diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 47ae1d1723c5..9b0bc8b74bc0 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -308,14 +308,19 @@ static int kszphy_config_init(struct phy_device *phydev)
 	return kszphy_config_reset(phydev);
 }
 
+static int ksz8041_fiber_mode(struct phy_device *phydev)
+{
+	struct device_node *of_node = phydev->mdio.dev.of_node;
+
+	return of_property_read_bool(of_node, "micrel,fiber-mode");
+}
+
 static int ksz8041_config_init(struct phy_device *phydev)
 {
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
 
-	struct device_node *of_node = phydev->mdio.dev.of_node;
-
 	/* Limit supported and advertised modes in fiber mode */
-	if (of_property_read_bool(of_node, "micrel,fiber-mode")) {
+	if (ksz8041_fiber_mode(phydev)) {
 		phydev->dev_flags |= MICREL_PHY_FXEN;
 		linkmode_set_bit(ETHTOOL_LINK_MODE_100baseT_Full_BIT, mask);
 		linkmode_set_bit(ETHTOOL_LINK_MODE_100baseT_Half_BIT, mask);
@@ -1143,6 +1148,9 @@ static int kszphy_probe(struct phy_device *phydev)
 		}
 	}
 
+	if (ksz8041_fiber_mode(phydev))
+		phydev->port = PORT_FIBRE;
+
 	/* Support legacy board-file configuration */
 	if (phydev->dev_flags & MICREL_PHY_50MHZ_CLK) {
 		priv->rmii_ref_clk_sel = true;
diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 49e96ca585ff..28ddaad721ed 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -327,7 +327,7 @@ void phy_ethtool_ksettings_get(struct phy_device *phydev,
 	if (phydev->interface == PHY_INTERFACE_MODE_MOCA)
 		cmd->base.port = PORT_BNC;
 	else
-		cmd->base.port = PORT_MII;
+		cmd->base.port = phydev->port;
 	cmd->base.transceiver = phy_is_internal(phydev) ?
 				XCVR_INTERNAL : XCVR_EXTERNAL;
 	cmd->base.phy_address = phydev->mdio.addr;
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 2d4eed2d61ce..85f3cde5ffd0 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -576,6 +576,7 @@ struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32 phy_id,
 	dev->pause = 0;
 	dev->asym_pause = 0;
 	dev->link = 0;
+	dev->port = PORT_TP;
 	dev->interface = PHY_INTERFACE_MODE_GMII;
 
 	dev->autoneg = AUTONEG_ENABLE;
@@ -1384,6 +1385,14 @@ int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
 
 	phydev->state = PHY_READY;
 
+	/* Port is set to PORT_TP by default and the actual PHY driver will set
+	 * it to different value depending on the PHY configuration. If we have
+	 * the generic PHY driver we can't figure it out, thus set the old
+	 * legacy PORT_MII value.
+	 */
+	if (using_genphy)
+		phydev->port = PORT_MII;
+
 	/* Initial carrier state is off as the phy is about to be
 	 * (re)initialized.
 	 */
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 56563e5e0dc7..08725a262f32 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -499,6 +499,7 @@ struct macsec_ops;
  *
  * @speed: Current link speed
  * @duplex: Current duplex
+ * @port: Current port
  * @pause: Current pause
  * @asym_pause: Current asymmetric pause
  * @supported: Combined MAC/PHY supported linkmodes
@@ -577,6 +578,7 @@ struct phy_device {
 	 */
 	int speed;
 	int duplex;
+	int port;
 	int pause;
 	int asym_pause;
 	u8 master_slave_get;
-- 
2.30.1



