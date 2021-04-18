Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 628E436357B
	for <lists+stable@lfdr.de>; Sun, 18 Apr 2021 15:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbhDRNUM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Apr 2021 09:20:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:36966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229671AbhDRNUL (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Apr 2021 09:20:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8B876109F;
        Sun, 18 Apr 2021 13:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618751984;
        bh=4DUEAi/IR1fyTdCQruenqxybZgMbZpKUQ7iEef+JMc8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZN+5iR2+hYYBMeDG7oP6BHFFhtNvMhrwGcCznq2hyeW0CWOrGF7qCBixncw8ev+uG
         HYUHJHPLVtFNnf0rcxQyjuJR1NKlkdkg4hk2SwRUqE9PTm9ZAqRrDIN//gESpDe5gT
         avelpeGFJwm1Mdhfp8B5mkMpHbvn+wzdj/caZjoc9ap6lKJ9o68A5F+LurTdol2uke
         IpE4KCmDfK/suyV2Imsdbjfu61pcRcUnxzfsmGw99QpL+NaM+Ex3y3Vmg+LhtFKXxP
         zUZYVgkisLOQrsEBQsNoChKmyzPqRr8+CwjHGOQcRK+w23ajS1Vg28p2y1liaiEQ7m
         JEn7geoL/IjFA==
Received: by pali.im (Postfix)
        id 45685BD5; Sun, 18 Apr 2021 15:19:41 +0200 (CEST)
From:   =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To:     stable@vger.kernel.org
Cc:     andrew@lunn.ch, davem@davemloft.net, kabel@kernel.org,
        gregkh@linuxfoundation.org
Subject: [PATCH] net: phy: marvell: fix detection of PHY on Topaz switches
Date:   Sun, 18 Apr 2021 15:19:37 +0200
Message-Id: <20210418131937.21368-1-pali@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <161874824218780@kroah.com>
References: <161874824218780@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 1fe976d308acb6374c899a4ee8025a0a016e453e upstream.

Since commit fee2d546414d ("net: phy: marvell: mv88e6390 temperature
sensor reading"), Linux reports the temperature of Topaz hwmon as
constant -75°C.

This is because switches from the Topaz family (88E6141 / 88E6341) have
the address of the temperature sensor register different from Peridot.

This address is instead compatible with 88E1510 PHYs, as was used for
Topaz before the above mentioned commit.

Create a new mapping table between switch family and PHY ID for families
which don't have a model number. And define PHY IDs for Topaz and Peridot
families.

Create a new PHY ID and a new PHY driver for Topaz's internal PHY.
The only difference from Peridot's PHY driver is the HWMON probing
method.

Prior this change Topaz's internal PHY is detected by kernel as:

  PHY [...] driver [Marvell 88E6390] (irq=63)

And afterwards as:

  PHY [...] driver [Marvell 88E6341 Family] (irq=63)

Signed-off-by: Pali Rohár <pali@kernel.org>
BugLink: https://github.com/globalscaletechnologies/linux/issues/1
Fixes: fee2d546414d ("net: phy: marvell: mv88e6390 temperature sensor reading")
Reviewed-by: Marek Behún <kabel@kernel.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
[pali: Backported to 4.19 version]
---
This patch is backported to 4.19 version. Compile-tested only.
---
 drivers/net/dsa/mv88e6xxx/chip.c | 30 +++++++++++++-----------------
 drivers/net/phy/marvell.c        | 28 +++++++++++++++++++++++++---
 include/linux/marvell_phy.h      |  5 +++--
 3 files changed, 41 insertions(+), 22 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index e04b7fa068af..67c0ad3b8079 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2634,10 +2634,17 @@ static int mv88e6xxx_setup(struct dsa_switch *ds)
 	return err;
 }
 
+/* prod_id for switch families which do not have a PHY model number */
+static const u16 family_prod_id_table[] = {
+	[MV88E6XXX_FAMILY_6341] = MV88E6XXX_PORT_SWITCH_ID_PROD_6341,
+	[MV88E6XXX_FAMILY_6390] = MV88E6XXX_PORT_SWITCH_ID_PROD_6390,
+};
+
 static int mv88e6xxx_mdio_read(struct mii_bus *bus, int phy, int reg)
 {
 	struct mv88e6xxx_mdio_bus *mdio_bus = bus->priv;
 	struct mv88e6xxx_chip *chip = mdio_bus->chip;
+	u16 prod_id;
 	u16 val;
 	int err;
 
@@ -2648,23 +2655,12 @@ static int mv88e6xxx_mdio_read(struct mii_bus *bus, int phy, int reg)
 	err = chip->info->ops->phy_read(chip, bus, phy, reg, &val);
 	mutex_unlock(&chip->reg_lock);
 
-	if (reg == MII_PHYSID2) {
-		/* Some internal PHYs don't have a model number. */
-		if (chip->info->family != MV88E6XXX_FAMILY_6165)
-			/* Then there is the 6165 family. It gets is
-			 * PHYs correct. But it can also have two
-			 * SERDES interfaces in the PHY address
-			 * space. And these don't have a model
-			 * number. But they are not PHYs, so we don't
-			 * want to give them something a PHY driver
-			 * will recognise.
-			 *
-			 * Use the mv88e6390 family model number
-			 * instead, for anything which really could be
-			 * a PHY,
-			 */
-			if (!(val & 0x3f0))
-				val |= MV88E6XXX_PORT_SWITCH_ID_PROD_6390 >> 4;
+	/* Some internal PHYs don't have a model number. */
+	if (reg == MII_PHYSID2 && !(val & 0x3f0) &&
+	    chip->info->family < ARRAY_SIZE(family_prod_id_table)) {
+		prod_id = family_prod_id_table[chip->info->family];
+		if (prod_id)
+			val |= prod_id >> 4;
 	}
 
 	return err ? err : val;
diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index bb6107f3b947..832a401c5fa5 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -2329,9 +2329,30 @@ static struct phy_driver marvell_drivers[] = {
 		.get_stats = marvell_get_stats,
 	},
 	{
-		.phy_id = MARVELL_PHY_ID_88E6390,
+		.phy_id = MARVELL_PHY_ID_88E6341_FAMILY,
 		.phy_id_mask = MARVELL_PHY_ID_MASK,
-		.name = "Marvell 88E6390",
+		.name = "Marvell 88E6341 Family",
+		.features = PHY_GBIT_FEATURES,
+		.flags = PHY_HAS_INTERRUPT,
+		.probe = m88e1510_probe,
+		.config_init = &marvell_config_init,
+		.config_aneg = &m88e6390_config_aneg,
+		.read_status = &marvell_read_status,
+		.ack_interrupt = &marvell_ack_interrupt,
+		.config_intr = &marvell_config_intr,
+		.did_interrupt = &m88e1121_did_interrupt,
+		.resume = &genphy_resume,
+		.suspend = &genphy_suspend,
+		.read_page = marvell_read_page,
+		.write_page = marvell_write_page,
+		.get_sset_count = marvell_get_sset_count,
+		.get_strings = marvell_get_strings,
+		.get_stats = marvell_get_stats,
+	},
+	{
+		.phy_id = MARVELL_PHY_ID_88E6390_FAMILY,
+		.phy_id_mask = MARVELL_PHY_ID_MASK,
+		.name = "Marvell 88E6390 Family",
 		.features = PHY_GBIT_FEATURES,
 		.flags = PHY_HAS_INTERRUPT,
 		.probe = m88e6390_probe,
@@ -2368,7 +2389,8 @@ static struct mdio_device_id __maybe_unused marvell_tbl[] = {
 	{ MARVELL_PHY_ID_88E1540, MARVELL_PHY_ID_MASK },
 	{ MARVELL_PHY_ID_88E1545, MARVELL_PHY_ID_MASK },
 	{ MARVELL_PHY_ID_88E3016, MARVELL_PHY_ID_MASK },
-	{ MARVELL_PHY_ID_88E6390, MARVELL_PHY_ID_MASK },
+	{ MARVELL_PHY_ID_88E6341_FAMILY, MARVELL_PHY_ID_MASK },
+	{ MARVELL_PHY_ID_88E6390_FAMILY, MARVELL_PHY_ID_MASK },
 	{ }
 };
 
diff --git a/include/linux/marvell_phy.h b/include/linux/marvell_phy.h
index 1eb6f244588d..9a488497ebc2 100644
--- a/include/linux/marvell_phy.h
+++ b/include/linux/marvell_phy.h
@@ -21,11 +21,12 @@
 #define MARVELL_PHY_ID_88E1545		0x01410ea0
 #define MARVELL_PHY_ID_88E3016		0x01410e60
 
-/* The MV88e6390 Ethernet switch contains embedded PHYs. These PHYs do
+/* These Ethernet switch families contain embedded PHYs, but they do
  * not have a model ID. So the switch driver traps reads to the ID2
  * register and returns the switch family ID
  */
-#define MARVELL_PHY_ID_88E6390		0x01410f90
+#define MARVELL_PHY_ID_88E6341_FAMILY	0x01410f41
+#define MARVELL_PHY_ID_88E6390_FAMILY	0x01410f90
 
 #define MARVELL_PHY_FAMILY_ID(id)	((id) >> 4)
 
-- 
2.20.1

