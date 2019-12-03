Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D6D6111C47
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728466AbfLCWmZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:42:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:57326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727887AbfLCWmY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:42:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 745CE206EC;
        Tue,  3 Dec 2019 22:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575412943;
        bh=cet8sYWhO/iD+8etpg2NUEaddX7y3venOG+F3NFCEH4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qLuW73lE4+9cvV5GRDhlZDGE3+h9xs+UOfr+9nIwGY7D4KqhxKcS1HVZY3JXmvA73
         7gvuFVRdpHwhsaZL23+W8tWhbo1/DNEefad0BL3VWGvr+CxKHBw3nlE0/B6ip498PZ
         bk8SK3sUTXXtkf2if3cr2vf7ppcYBHJGOc2zb4xc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 075/135] net: bcmgenet: use RGMII loopback for MAC reset
Date:   Tue,  3 Dec 2019 23:35:15 +0100
Message-Id: <20191203213027.860936034@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203213005.828543156@linuxfoundation.org>
References: <20191203213005.828543156@linuxfoundation.org>
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
index 06e2581b28eaf..4c90923d7a1c8 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -1996,8 +1996,6 @@ static void reset_umac(struct bcmgenet_priv *priv)
 
 	/* issue soft reset with (rg)mii loopback to ensure a stable rxclk */
 	bcmgenet_umac_writel(priv, CMD_SW_RESET | CMD_LCL_LOOP_EN, UMAC_CMD);
-	udelay(2);
-	bcmgenet_umac_writel(priv, 0, UMAC_CMD);
 }
 
 static void bcmgenet_intr_disable(struct bcmgenet_priv *priv)
diff --git a/drivers/net/ethernet/broadcom/genet/bcmmii.c b/drivers/net/ethernet/broadcom/genet/bcmmii.c
index e7c291bf4ed17..dbe18cdf6c1b8 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
@@ -181,8 +181,38 @@ int bcmgenet_mii_config(struct net_device *dev, bool init)
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
 
@@ -214,6 +244,9 @@ int bcmgenet_mii_config(struct net_device *dev, bool init)
 		phy_set_max_speed(phydev, SPEED_100);
 		bcmgenet_sys_writel(priv,
 				    PORT_MODE_EXT_EPHY, SYS_PORT_CTRL);
+		/* Restore the MII PHY after isolation */
+		if (bmcr >= 0)
+			phy_write(phydev, MII_BMCR, bmcr);
 		break;
 
 	case PHY_INTERFACE_MODE_REVMII:
-- 
2.20.1



