Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 729D06BB25F
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:35:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232592AbjCOMfr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:35:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232649AbjCOMf3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:35:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EC519F050
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:34:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E420461D69
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:34:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0625BC4339C;
        Wed, 15 Mar 2023 12:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883648;
        bh=/4wXdushswwyYsHmuPXAyOOGaKB8u8himgerJvXeBgo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rXbOv6/bwS1Cy7DRl3QYo/TsyyXW08Xxg3fLAZmYt5RGLHLuqtyZT+yWzSbLt+yN8
         kk9w5i9umRTTpVUEHOGxnjQeXbQQGDjqkpkS1jjj0qjM/30rJ20bGNpbvcoJ7PKVOR
         7uX+Da2DtM3Lb+6wfAseP3/CPRK+r3kK4SDkBlAQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yuiko Oshino <yuiko.oshino@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 077/143] net: lan78xx: fix accessing the LAN7800s internal phy specific registers from the MAC driver
Date:   Wed, 15 Mar 2023 13:12:43 +0100
Message-Id: <20230315115742.883055860@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yuiko Oshino <yuiko.oshino@microchip.com>

[ Upstream commit e57cf3639c323eeed05d3725fd82f91b349adca8 ]

Move the LAN7800 internal phy (phy ID  0x0007c132) specific register
accesses to the phy driver (microchip.c).

Fix the error reported by Enguerrand de Ribaucourt in December 2022,
"Some operations during the cable switch workaround modify the register
LAN88XX_INT_MASK of the PHY. However, this register is specific to the
LAN8835 PHY. For instance, if a DP8322I PHY is connected to the LAN7801,
that register (0x19), corresponds to the LED and MAC address
configuration, resulting in unapropriate behavior."

I did not test with the DP8322I PHY, but I tested with an EVB-LAN7800
with the internal PHY.

Fixes: 14437e3fa284 ("lan78xx: workaround of forced 100 Full/Half duplex mode error")
Signed-off-by: Yuiko Oshino <yuiko.oshino@microchip.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20230301154307.30438-1-yuiko.oshino@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/microchip.c | 32 ++++++++++++++++++++++++++++++++
 drivers/net/usb/lan78xx.c   | 27 +--------------------------
 2 files changed, 33 insertions(+), 26 deletions(-)

diff --git a/drivers/net/phy/microchip.c b/drivers/net/phy/microchip.c
index ccecee2524ce6..0b88635f4fbca 100644
--- a/drivers/net/phy/microchip.c
+++ b/drivers/net/phy/microchip.c
@@ -342,6 +342,37 @@ static int lan88xx_config_aneg(struct phy_device *phydev)
 	return genphy_config_aneg(phydev);
 }
 
+static void lan88xx_link_change_notify(struct phy_device *phydev)
+{
+	int temp;
+
+	/* At forced 100 F/H mode, chip may fail to set mode correctly
+	 * when cable is switched between long(~50+m) and short one.
+	 * As workaround, set to 10 before setting to 100
+	 * at forced 100 F/H mode.
+	 */
+	if (!phydev->autoneg && phydev->speed == 100) {
+		/* disable phy interrupt */
+		temp = phy_read(phydev, LAN88XX_INT_MASK);
+		temp &= ~LAN88XX_INT_MASK_MDINTPIN_EN_;
+		phy_write(phydev, LAN88XX_INT_MASK, temp);
+
+		temp = phy_read(phydev, MII_BMCR);
+		temp &= ~(BMCR_SPEED100 | BMCR_SPEED1000);
+		phy_write(phydev, MII_BMCR, temp); /* set to 10 first */
+		temp |= BMCR_SPEED100;
+		phy_write(phydev, MII_BMCR, temp); /* set to 100 later */
+
+		/* clear pending interrupt generated while workaround */
+		temp = phy_read(phydev, LAN88XX_INT_STS);
+
+		/* enable phy interrupt back */
+		temp = phy_read(phydev, LAN88XX_INT_MASK);
+		temp |= LAN88XX_INT_MASK_MDINTPIN_EN_;
+		phy_write(phydev, LAN88XX_INT_MASK, temp);
+	}
+}
+
 static struct phy_driver microchip_phy_driver[] = {
 {
 	.phy_id		= 0x0007c132,
@@ -359,6 +390,7 @@ static struct phy_driver microchip_phy_driver[] = {
 
 	.config_init	= lan88xx_config_init,
 	.config_aneg	= lan88xx_config_aneg,
+	.link_change_notify = lan88xx_link_change_notify,
 
 	.config_intr	= lan88xx_phy_config_intr,
 	.handle_interrupt = lan88xx_handle_interrupt,
diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index f18ab8e220db7..068488890d57b 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -2115,33 +2115,8 @@ static void lan78xx_remove_mdio(struct lan78xx_net *dev)
 static void lan78xx_link_status_change(struct net_device *net)
 {
 	struct phy_device *phydev = net->phydev;
-	int temp;
-
-	/* At forced 100 F/H mode, chip may fail to set mode correctly
-	 * when cable is switched between long(~50+m) and short one.
-	 * As workaround, set to 10 before setting to 100
-	 * at forced 100 F/H mode.
-	 */
-	if (!phydev->autoneg && (phydev->speed == 100)) {
-		/* disable phy interrupt */
-		temp = phy_read(phydev, LAN88XX_INT_MASK);
-		temp &= ~LAN88XX_INT_MASK_MDINTPIN_EN_;
-		phy_write(phydev, LAN88XX_INT_MASK, temp);
 
-		temp = phy_read(phydev, MII_BMCR);
-		temp &= ~(BMCR_SPEED100 | BMCR_SPEED1000);
-		phy_write(phydev, MII_BMCR, temp); /* set to 10 first */
-		temp |= BMCR_SPEED100;
-		phy_write(phydev, MII_BMCR, temp); /* set to 100 later */
-
-		/* clear pending interrupt generated while workaround */
-		temp = phy_read(phydev, LAN88XX_INT_STS);
-
-		/* enable phy interrupt back */
-		temp = phy_read(phydev, LAN88XX_INT_MASK);
-		temp |= LAN88XX_INT_MASK_MDINTPIN_EN_;
-		phy_write(phydev, LAN88XX_INT_MASK, temp);
-	}
+	phy_print_status(phydev);
 }
 
 static int irq_map(struct irq_domain *d, unsigned int irq,
-- 
2.39.2



