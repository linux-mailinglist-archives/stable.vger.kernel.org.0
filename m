Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 155A8440901
	for <lists+stable@lfdr.de>; Sat, 30 Oct 2021 15:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbhJ3NN1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Oct 2021 09:13:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:45478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230153AbhJ3NN1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 30 Oct 2021 09:13:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 938F460E9C;
        Sat, 30 Oct 2021 13:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635599457;
        bh=Xujr45mrLZ1YuMJICL+UFrCNiDVo99VpEF97npWWTfE=;
        h=Subject:To:Cc:From:Date:From;
        b=zMypcX4Qz2Fxrs1U9J7MpmyCY3mPxo4RIWKSJ9wIU+AKziF8MFQVurns92osqaJGt
         +Hqx/2MepOZi13162s8nvNKFY3C9vwqhaQZD8lHbkloELtcxyZnsOG+A83J3c1shCg
         9KIoxip7H8b+G0UaM20VVKxhUk/jOHwACDyzsv3k=
Subject: FAILED: patch "[PATCH] phy: phy_ethtool_ksettings_set: Move after phy_start_aneg" failed to apply to 4.14-stable tree
To:     andrew@lunn.ch, davem@davemloft.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 30 Oct 2021 15:10:42 +0200
Message-ID: <1635599442181254@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 64cd92d5e8180c2ded3fdea76862de6f596ae2c9 Mon Sep 17 00:00:00 2001
From: Andrew Lunn <andrew@lunn.ch>
Date: Sun, 24 Oct 2021 21:48:03 +0200
Subject: [PATCH] phy: phy_ethtool_ksettings_set: Move after phy_start_aneg

This allows it to make use of a helper which assume the PHY is already
locked.

Fixes: 2d55173e71b0 ("phy: add generic function to support ksetting support")
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 8457b829667e..ee584fa8b76d 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -243,59 +243,6 @@ static void phy_sanitize_settings(struct phy_device *phydev)
 	}
 }
 
-int phy_ethtool_ksettings_set(struct phy_device *phydev,
-			      const struct ethtool_link_ksettings *cmd)
-{
-	__ETHTOOL_DECLARE_LINK_MODE_MASK(advertising);
-	u8 autoneg = cmd->base.autoneg;
-	u8 duplex = cmd->base.duplex;
-	u32 speed = cmd->base.speed;
-
-	if (cmd->base.phy_address != phydev->mdio.addr)
-		return -EINVAL;
-
-	linkmode_copy(advertising, cmd->link_modes.advertising);
-
-	/* We make sure that we don't pass unsupported values in to the PHY */
-	linkmode_and(advertising, advertising, phydev->supported);
-
-	/* Verify the settings we care about. */
-	if (autoneg != AUTONEG_ENABLE && autoneg != AUTONEG_DISABLE)
-		return -EINVAL;
-
-	if (autoneg == AUTONEG_ENABLE && linkmode_empty(advertising))
-		return -EINVAL;
-
-	if (autoneg == AUTONEG_DISABLE &&
-	    ((speed != SPEED_1000 &&
-	      speed != SPEED_100 &&
-	      speed != SPEED_10) ||
-	     (duplex != DUPLEX_HALF &&
-	      duplex != DUPLEX_FULL)))
-		return -EINVAL;
-
-	phydev->autoneg = autoneg;
-
-	if (autoneg == AUTONEG_DISABLE) {
-		phydev->speed = speed;
-		phydev->duplex = duplex;
-	}
-
-	linkmode_copy(phydev->advertising, advertising);
-
-	linkmode_mod_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
-			 phydev->advertising, autoneg == AUTONEG_ENABLE);
-
-	phydev->master_slave_set = cmd->base.master_slave_cfg;
-	phydev->mdix_ctrl = cmd->base.eth_tp_mdix_ctrl;
-
-	/* Restart the PHY */
-	phy_start_aneg(phydev);
-
-	return 0;
-}
-EXPORT_SYMBOL(phy_ethtool_ksettings_set);
-
 void phy_ethtool_ksettings_get(struct phy_device *phydev,
 			       struct ethtool_link_ksettings *cmd)
 {
@@ -802,6 +749,59 @@ static int phy_poll_aneg_done(struct phy_device *phydev)
 	return ret < 0 ? ret : 0;
 }
 
+int phy_ethtool_ksettings_set(struct phy_device *phydev,
+			      const struct ethtool_link_ksettings *cmd)
+{
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(advertising);
+	u8 autoneg = cmd->base.autoneg;
+	u8 duplex = cmd->base.duplex;
+	u32 speed = cmd->base.speed;
+
+	if (cmd->base.phy_address != phydev->mdio.addr)
+		return -EINVAL;
+
+	linkmode_copy(advertising, cmd->link_modes.advertising);
+
+	/* We make sure that we don't pass unsupported values in to the PHY */
+	linkmode_and(advertising, advertising, phydev->supported);
+
+	/* Verify the settings we care about. */
+	if (autoneg != AUTONEG_ENABLE && autoneg != AUTONEG_DISABLE)
+		return -EINVAL;
+
+	if (autoneg == AUTONEG_ENABLE && linkmode_empty(advertising))
+		return -EINVAL;
+
+	if (autoneg == AUTONEG_DISABLE &&
+	    ((speed != SPEED_1000 &&
+	      speed != SPEED_100 &&
+	      speed != SPEED_10) ||
+	     (duplex != DUPLEX_HALF &&
+	      duplex != DUPLEX_FULL)))
+		return -EINVAL;
+
+	phydev->autoneg = autoneg;
+
+	if (autoneg == AUTONEG_DISABLE) {
+		phydev->speed = speed;
+		phydev->duplex = duplex;
+	}
+
+	linkmode_copy(phydev->advertising, advertising);
+
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
+			 phydev->advertising, autoneg == AUTONEG_ENABLE);
+
+	phydev->master_slave_set = cmd->base.master_slave_cfg;
+	phydev->mdix_ctrl = cmd->base.eth_tp_mdix_ctrl;
+
+	/* Restart the PHY */
+	phy_start_aneg(phydev);
+
+	return 0;
+}
+EXPORT_SYMBOL(phy_ethtool_ksettings_set);
+
 /**
  * phy_speed_down - set speed to lowest speed supported by both link partners
  * @phydev: the phy_device struct

