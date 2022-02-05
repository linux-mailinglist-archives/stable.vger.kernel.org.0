Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A2724AAC2E
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 20:08:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243026AbiBETIU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 14:08:20 -0500
Received: from mail.baikalelectronics.com ([87.245.175.226]:41478 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238602AbiBETIT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Feb 2022 14:08:19 -0500
Received: from mail.baikalelectronics.ru (unknown [192.168.51.25])
        by mail.baikalelectronics.ru (Postfix) with ESMTP id 4495B8001D4C;
        Sat,  5 Feb 2022 22:08:17 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.baikalelectronics.ru 4495B8001D4C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baikalelectronics.ru; s=mail; t=1644088098;
        bh=vJ0hJ+iqdOTB+PkIasIoM6oadTqjr4Wx8U3DncmG/t0=;
        h=From:To:CC:Subject:Date:In-Reply-To:References:From;
        b=nKPxqcJi+Xk3W8U1FD6/8UqBrbh1CBZrbABq70ktMNyPhMTjXQaI7Ck4eouOo4ukG
         aab/qgpLHAqjintPIj6RMS2nmMmRT3okxsbgtwbwVoDZyRXlRYYabTm1CUVMNED9qI
         irnICv2dB0bjPN+v8NT8A/3tVN7r0B7N3n/Ng0Ps=
Received: from localhost (192.168.168.10) by mail (192.168.51.25) with
 Microsoft SMTP Server (TLS) id 15.0.1395.4; Sat, 5 Feb 2022 22:08:03 +0300
From:   Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>
To:     <Pavel.Parkhomenko@baikalelectronics.ru>
CC:     <Sergey.Semin@baikalelectronics.ru>, <fancer.lancer@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        <stable@vger.kernel.org>
Subject: [PATCH net v2] net: phy: marvell: Fix RGMII Tx/Rx delays setting in 88e1121-compatible PHYs
Date:   Sat, 5 Feb 2022 22:08:14 +0300
Message-ID: <20220205190814.20282-1-Pavel.Parkhomenko@baikalelectronics.ru>
In-Reply-To: <96759fee7240fd095cb9cc1f6eaf2d9113b57cf0.camel@baikalelectronics.ru>
References: <96759fee7240fd095cb9cc1f6eaf2d9113b57cf0.camel@baikalelectronics.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It is mandatory for a software to issue a reset upon modifying RGMII
Receive Timing Control and RGMII Transmit Timing Control bit fields of MAC
Specific Control register 2 (page 2, register 21) otherwise the changes
won't be perceived by the PHY (the same is applicable for a lot of other
registers). Not setting the RGMII delays on the platforms that imply it'
being done on the PHY side will consequently cause the traffic loss. We
discovered that the denoted soft-reset is missing in the
m88e1121_config_aneg() method for the case if the RGMII delays are
modified but the MDIx polarity isn't changed or the auto-negotiation is
left enabled, thus causing the traffic loss on our platform with Marvell
Alaska 88E1510 installed. Let's fix that by issuing the soft-reset if the
delays have been actually set in the m88e1121_config_aneg_rgmii_delays()
method.

Fixes: d6ab93364734 ("net: phy: marvell: Avoid unnecessary soft reset")
Signed-off-by: Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Cc: stable@vger.kernel.org

---

Link: https://lore.kernel.org/netdev/96759fee7240fd095cb9cc1f6eaf2d9113b57cf0.camel@baikalelectronics.ru/
Changelog v2:
- Add "net" suffix into the PATCH-clause of the subject.
- Cc the patch to the stable tree list.
- Rebase onto the latset netdev/net branch with the top commit
---
 drivers/net/phy/marvell.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index fa71fb7a66b5..4b8f822f8c51 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -553,9 +553,9 @@ static int m88e1121_config_aneg_rgmii_delays(struct phy_device *phydev)
 	else
 		mscr = 0;
 
-	return phy_modify_paged(phydev, MII_MARVELL_MSCR_PAGE,
-				MII_88E1121_PHY_MSCR_REG,
-				MII_88E1121_PHY_MSCR_DELAY_MASK, mscr);
+	return phy_modify_paged_changed(phydev, MII_MARVELL_MSCR_PAGE,
+					MII_88E1121_PHY_MSCR_REG,
+					MII_88E1121_PHY_MSCR_DELAY_MASK, mscr);
 }
 
 static int m88e1121_config_aneg(struct phy_device *phydev)
@@ -569,11 +569,13 @@ static int m88e1121_config_aneg(struct phy_device *phydev)
 			return err;
 	}
 
+	changed = err;
+
 	err = marvell_set_polarity(phydev, phydev->mdix_ctrl);
 	if (err < 0)
 		return err;
 
-	changed = err;
+	changed |= err;
 
 	err = genphy_config_aneg(phydev);
 	if (err < 0)
@@ -1211,17 +1213,22 @@ static int m88e1510_config_init(struct phy_device *phydev)
 
 static int m88e1118_config_aneg(struct phy_device *phydev)
 {
+	int changed = 0;
 	int err;
 
-	err = genphy_soft_reset(phydev);
+	err = marvell_set_polarity(phydev, phydev->mdix_ctrl);
 	if (err < 0)
 		return err;
 
-	err = marvell_set_polarity(phydev, phydev->mdix_ctrl);
+	changed = err;
+
+	err = genphy_config_aneg(phydev);
 	if (err < 0)
 		return err;
 
-	err = genphy_config_aneg(phydev);
+	if (phydev->autoneg != AUTONEG_ENABLE || changed)
+		return genphy_soft_reset(phydev);
+
 	return 0;
 }
 
-- 
2.34.1

