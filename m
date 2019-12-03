Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 074AF111CB7
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:47:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728504AbfLCWqu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:46:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:36684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729240AbfLCWqu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:46:50 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1321120684;
        Tue,  3 Dec 2019 22:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413208;
        bh=+nX3oMJ4JKwb7MG6fDKSTwPgleKO+jilJAZvGnH7OGc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XUSnZ7JDM4jTmfeWJjJVjqu6EGdZQIvYLq6+KoNNBxajHEUH3O84tg4q4hnnds5OT
         oHfN+bwFkdeheJJoCqWdn5+POLwOQO0/7a8vSNBnpSXg6w2BgGUJEOP/4Y+uc9r/vR
         FlehNDN+czFmiuHpLDDeBUskuzCwi5dT5PwhX31o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 039/321] net: bcmgenet: use RGMII loopback for MAC reset
Date:   Tue,  3 Dec 2019 23:31:45 +0100
Message-Id: <20191203223429.145573653@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Doug Berger <opendmb@gmail.com>

[ Upstream commit 3a55402c93877d291b0a612d25edb03d1b4b93ac ]

As noted in commit 28c2d1a7a0bf ("net: bcmgenet: enable loopback
during UniMAC sw_reset") the UniMAC must be clocked while sw_reset
is asserted for its state machines to reset cleanly.

The transmit and receive clocks used by the UniMAC are derived from
the signals used on its PHY interface. The bcmgenet MAC can be
configured to work with different PHY interfaces including MII,
GMII, RGMII, and Reverse MII on internal and external interfaces.
Unfortunately for the UniMAC, when configured for MII the Tx clock
is always driven from the PHY which places it outside of the direct
control of the MAC.

The earlier commit enabled a local loopback mode within the UniMAC
so that the receive clock would be derived from the transmit clock
which addressed the observed issue with an external GPHY disabling
it's Rx clock. However, when a Tx clock is not available this
loopback is insufficient.

This commit implements a workaround that leverages the fact that
the MAC can reliably generate all of its necessary clocking by
enterring the external GPHY RGMII interface mode with the UniMAC in
local loopback during the sw_reset interval. Unfortunately, this
has the undesirable side efect of the RGMII GTXCLK signal being
driven during the same window.

In most configurations this is a benign side effect as the signal
is either not routed to a pin or is already expected to drive the
pin. The one exception is when an external MII PHY is expected to
drive the same pin with its TX_CLK output creating output driver
contention.

This commit exploits the IEEE 802.3 clause 22 standard defined
isolate mode to force an external MII PHY to present a high
impedance on its TX_CLK output during the window to prevent any
contention at the pin.

The MII interface is used internally with the 40nm internal EPHY
which agressively disables its clocks for power savings leading to
incomplete resets of the UniMAC and many instabilities observed
over the years. The workaround of this commit is expected to put
an end to those problems.

Fixes: 1c1008c793fa ("net: bcmgenet: add main driver file")
Signed-off-by: Doug Berger <opendmb@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/broadcom/genet/bcmgenet.c    |  2 --
 drivers/net/ethernet/broadcom/genet/bcmmii.c  | 33 +++++++++++++++++++
 2 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 338d223804343..6f7278d2ce4f2 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -1998,8 +1998,6 @@ static void reset_umac(struct bcmgenet_priv *priv)
 
 	/* issue soft reset with (rg)mii loopback to ensure a stable rxclk */
 	bcmgenet_umac_writel(priv, CMD_SW_RESET | CMD_LCL_LOOP_EN, UMAC_CMD);
-	udelay(2);
-	bcmgenet_umac_writel(priv, 0, UMAC_CMD);
 }
 
 static void bcmgenet_intr_disable(struct bcmgenet_priv *priv)
diff --git a/drivers/net/ethernet/broadcom/genet/bcmmii.c b/drivers/net/ethernet/broadcom/genet/bcmmii.c
index b0592fd4135b3..a5049d637791d 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
@@ -184,8 +184,38 @@ int bcmgenet_mii_config(struct net_device *dev, bool init)
 	const char *phy_name = NULL;
 	u32 id_mode_dis = 0;
 	u32 port_ctrl;
+	int bmcr = -1;
+	int ret;
 	u32 reg;
 
+	/* MAC clocking workaround during reset of umac state machines */
+	reg = bcmgenet_umac_readl(priv, UMAC_CMD);
+	if (reg & CMD_SW_RESET) {
+		/* An MII PHY must be isolated to prevent TXC contention */
+		if (priv->phy_interface == PHY_INTERFACE_MODE_MII) {
+			ret = phy_read(phydev, MII_BMCR);
+			if (ret >= 0) {
+				bmcr = ret;
+				ret = phy_write(phydev, MII_BMCR,
+						bmcr | BMCR_ISOLATE);
+			}
+			if (ret) {
+				netdev_err(dev, "failed to isolate PHY\n");
+				return ret;
+			}
+		}
+		/* Switch MAC clocking to RGMII generated clock */
+		bcmgenet_sys_writel(priv, PORT_MODE_EXT_GPHY, SYS_PORT_CTRL);
+		/* Ensure 5 clks with Rx disabled
+		 * followed by 5 clks with Reset asserted
+		 */
+		udelay(4);
+		reg &= ~(CMD_SW_RESET | CMD_LCL_LOOP_EN);
+		bcmgenet_umac_writel(priv, reg, UMAC_CMD);
+		/* Ensure 5 more clocks before Rx is enabled */
+		udelay(2);
+	}
+
 	priv->ext_phy = !priv->internal_phy &&
 			(priv->phy_interface != PHY_INTERFACE_MODE_MOCA);
 
@@ -217,6 +247,9 @@ int bcmgenet_mii_config(struct net_device *dev, bool init)
 		phydev->supported &= PHY_BASIC_FEATURES;
 		bcmgenet_sys_writel(priv,
 				    PORT_MODE_EXT_EPHY, SYS_PORT_CTRL);
+		/* Restore the MII PHY after isolation */
+		if (bmcr >= 0)
+			phy_write(phydev, MII_BMCR, bmcr);
 		break;
 
 	case PHY_INTERFACE_MODE_REVMII:
-- 
2.20.1



