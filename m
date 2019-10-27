Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2C36E6839
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:28:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729946AbfJ0V2C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:28:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:44594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732343AbfJ0VXY (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:23:24 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64226205C9;
        Sun, 27 Oct 2019 21:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211403;
        bh=UWRrMZJKv5UW1deDCzyVTEjunYLbL4c4zEt1YclGpx4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hOhm3e1FXQA/WRDsOFsedToMMi/v2aBZbDjrRHiSxsYprO+zSSFhUhA/TqP9X5XJ1
         lJsi6G2/UpNKJcj69sity72m7E6cu++3v+/sgpRqS9MPj6M0tumL6GeYE9i+sKeG/V
         qP6jhUelpWGlHnU+7UNerx08xASiItXF57cB+A3I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Sean Nyekjaer <sean.nyekjaer@prevas.dk>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: [PATCH 5.3 085/197] net: phy: micrel: Discern KSZ8051 and KSZ8795 PHYs
Date:   Sun, 27 Oct 2019 22:00:03 +0100
Message-Id: <20191027203356.311768827@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit 8b95599c55ed24b36cf44a4720067cfe67edbcb4 ]

The KSZ8051 PHY and the KSZ8794/KSZ8795/KSZ8765 switch share exactly the
same PHY ID. Since KSZ8051 is higher in the ksphy_driver[] list of PHYs
in the micrel PHY driver, it is used even with the KSZ87xx switch. This
is wrong, since the KSZ8051 configures registers of the PHY which are
not present on the simplified KSZ87xx switch PHYs and misconfigures
other registers of the KSZ87xx switch PHYs.

Fortunatelly, it is possible to tell apart the KSZ8051 PHY from the
KSZ87xx switch by checking the Basic Status register Bit 0, which is
read-only and indicates presence of the Extended Capability Registers.
The KSZ8051 PHY has those registers while the KSZ87xx switch does not.

This patch implements simple check for the presence of this bit for
both the KSZ8051 PHY and KSZ87xx switch, to let both use the correct
PHY driver instance.

Fixes: 9d162ed69f51 ("net: phy: micrel: add support for KSZ8795")
Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: David S. Miller <davem@davemloft.net>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: George McCollister <george.mccollister@gmail.com>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Sean Nyekjaer <sean.nyekjaer@prevas.dk>
Cc: Tristram Ha <Tristram.Ha@microchip.com>
Cc: Woojung Huh <woojung.huh@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/micrel.c |   40 ++++++++++++++++++++++++++++++++++++----
 1 file changed, 36 insertions(+), 4 deletions(-)

--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -341,6 +341,35 @@ static int ksz8041_config_aneg(struct ph
 	return genphy_config_aneg(phydev);
 }
 
+static int ksz8051_ksz8795_match_phy_device(struct phy_device *phydev,
+					    const u32 ksz_phy_id)
+{
+	int ret;
+
+	if ((phydev->phy_id & MICREL_PHY_ID_MASK) != ksz_phy_id)
+		return 0;
+
+	ret = phy_read(phydev, MII_BMSR);
+	if (ret < 0)
+		return ret;
+
+	/* KSZ8051 PHY and KSZ8794/KSZ8795/KSZ8765 switch share the same
+	 * exact PHY ID. However, they can be told apart by the extended
+	 * capability registers presence. The KSZ8051 PHY has them while
+	 * the switch does not.
+	 */
+	ret &= BMSR_ERCAP;
+	if (ksz_phy_id == PHY_ID_KSZ8051)
+		return ret;
+	else
+		return !ret;
+}
+
+static int ksz8051_match_phy_device(struct phy_device *phydev)
+{
+	return ksz8051_ksz8795_match_phy_device(phydev, PHY_ID_KSZ8051);
+}
+
 static int ksz8081_config_init(struct phy_device *phydev)
 {
 	/* KSZPHY_OMSO_FACTORY_TEST is set at de-assertion of the reset line
@@ -364,6 +393,11 @@ static int ksz8061_config_init(struct ph
 	return kszphy_config_init(phydev);
 }
 
+static int ksz8795_match_phy_device(struct phy_device *phydev)
+{
+	return ksz8051_ksz8795_match_phy_device(phydev, PHY_ID_KSZ8795);
+}
+
 static int ksz9021_load_values_from_of(struct phy_device *phydev,
 				       const struct device_node *of_node,
 				       u16 reg,
@@ -1017,8 +1051,6 @@ static struct phy_driver ksphy_driver[]
 	.suspend	= genphy_suspend,
 	.resume		= genphy_resume,
 }, {
-	.phy_id		= PHY_ID_KSZ8051,
-	.phy_id_mask	= MICREL_PHY_ID_MASK,
 	.name		= "Micrel KSZ8051",
 	/* PHY_BASIC_FEATURES */
 	.driver_data	= &ksz8051_type,
@@ -1029,6 +1061,7 @@ static struct phy_driver ksphy_driver[]
 	.get_sset_count = kszphy_get_sset_count,
 	.get_strings	= kszphy_get_strings,
 	.get_stats	= kszphy_get_stats,
+	.match_phy_device = ksz8051_match_phy_device,
 	.suspend	= genphy_suspend,
 	.resume		= genphy_resume,
 }, {
@@ -1141,13 +1174,12 @@ static struct phy_driver ksphy_driver[]
 	.suspend	= genphy_suspend,
 	.resume		= genphy_resume,
 }, {
-	.phy_id		= PHY_ID_KSZ8795,
-	.phy_id_mask	= MICREL_PHY_ID_MASK,
 	.name		= "Micrel KSZ8795",
 	/* PHY_BASIC_FEATURES */
 	.config_init	= kszphy_config_init,
 	.config_aneg	= ksz8873mll_config_aneg,
 	.read_status	= ksz8873mll_read_status,
+	.match_phy_device = ksz8795_match_phy_device,
 	.suspend	= genphy_suspend,
 	.resume		= genphy_resume,
 }, {


