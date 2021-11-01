Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 254844417BD
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:37:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233451AbhKAJjr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:39:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:43562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233633AbhKAJhp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:37:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9446E6134F;
        Mon,  1 Nov 2021 09:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758798;
        bh=Yra+beBhWD7jxPbK6Qw8ggXqe3M9mzT9u8IUB9ffgVA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AKoc42QYEphlPEhv0eYjxSAS1eWL650Hu0Zz9q/Us8/5YKP2rGq7oG6Rd8o9SULLc
         zP4S7nItPTaBaYFoooJDGH0on5GduTnGB0cLgVWwhDpcglU9OwvCg+wNg7wEUMAQKX
         jh+JhshNJlS47OzDdxFaCL7zTLHUprYh9lbDlgbw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 62/77] phy: phy_ethtool_ksettings_set: Move after phy_start_aneg
Date:   Mon,  1 Nov 2021 10:17:50 +0100
Message-Id: <20211101082524.670392917@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082511.254155853@linuxfoundation.org>
References: <20211101082511.254155853@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>

commit 64cd92d5e8180c2ded3fdea76862de6f596ae2c9 upstream.

This allows it to make use of a helper which assume the PHY is already
locked.

Fixes: 2d55173e71b0 ("phy: add generic function to support ksetting support")
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/phy.c |  106 +++++++++++++++++++++++++-------------------------
 1 file changed, 53 insertions(+), 53 deletions(-)

--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -260,59 +260,6 @@ static void phy_sanitize_settings(struct
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
@@ -818,6 +765,59 @@ static int phy_poll_aneg_done(struct phy
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


