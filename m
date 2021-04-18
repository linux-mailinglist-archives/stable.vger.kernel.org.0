Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F40536356C
	for <lists+stable@lfdr.de>; Sun, 18 Apr 2021 15:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbhDRNO3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Apr 2021 09:14:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:36320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229671AbhDRNO2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Apr 2021 09:14:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 819556108C;
        Sun, 18 Apr 2021 13:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618751640;
        bh=4K/rhV9NVvOKQgUExmMOnvuVu9WaUtAjrCxUlVovb7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=neEw+w+PqdBy8l1bvkSWCjkKZ53vLp3aEbTRRymIrNhI88HO4v505WhdegD2Zqpk3
         U5O4/f+Xt1IlepUGmfLmhRlpN2nnx3D3DamgtRBgIrKeWK83LVhDb5BLJ/Q0vWtQI+
         jgvJFaSVf+DFkGfzJ1GRPKj1kzPhsJnZrzm026DDy+gIqnMvsbsY3lqR2IcXfQ1FII
         +wtNqDizgNbO+ezwzpySsKMFwwacuIVT7e0ZAC4vjkkMeqptCSIX5VwbwhFXvyt3s7
         pteUSsvEOAWXTBROHvIe/MDUBiKiluvDHEamKyOInWYCg7ZdgSZX0uSGwSRAbCsXBz
         I8JX+elYm/lTw==
Received: by pali.im (Postfix)
        id 3608ABD5; Sun, 18 Apr 2021 15:13:58 +0200 (CEST)
From:   =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To:     stable@vger.kernel.org
Cc:     andrew@lunn.ch, davem@davemloft.net, kabel@kernel.org,
        gregkh@linuxfoundation.org
Subject: [PATCH] net: phy: marvell: fix detection of PHY on Topaz switches
Date:   Sun, 18 Apr 2021 15:13:44 +0200
Message-Id: <20210418131344.21024-1-pali@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <16187482432842@kroah.com> <161874858144103@kroah.com>
References: <16187482432842@kroah.com> <161874858144103@kroah.com>
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
[pali: Backported to 5.4 version]
---
This patch is backported to 5.4 version. Tested on Turris Mox with Topaz switch.
---
 drivers/net/dsa/mv88e6xxx/chip.c | 30 +++++++++++++-----------------
 drivers/net/phy/marvell.c        | 29 ++++++++++++++++++++++++++---
 include/linux/marvell_phy.h      |  5 +++--
 3 files changed, 42 insertions(+), 22 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 1af09fd3fed1..446eb06e50b4 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2766,10 +2766,17 @@ static int mv88e6xxx_setup(struct dsa_switch *ds)
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
 
@@ -2780,23 +2787,12 @@ static int mv88e6xxx_mdio_read(struct mii_bus *bus, int phy, int reg)
 	err = chip->info->ops->phy_read(chip, bus, phy, reg, &val);
 	mv88e6xxx_reg_unlock(chip);
 
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
index 91cf1d167263..9dbe625ad447 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -2401,9 +2401,31 @@ static struct phy_driver marvell_drivers[] = {
 		.get_stats = marvell_get_stats,
 	},
 	{
-		.phy_id = MARVELL_PHY_ID_88E6390,
+		.phy_id = MARVELL_PHY_ID_88E6341_FAMILY,
 		.phy_id_mask = MARVELL_PHY_ID_MASK,
-		.name = "Marvell 88E6390",
+		.name = "Marvell 88E6341 Family",
+		/* PHY_GBIT_FEATURES */
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
+		.get_tunable = m88e1540_get_tunable,
+		.set_tunable = m88e1540_set_tunable,
+	},
+	{
+		.phy_id = MARVELL_PHY_ID_88E6390_FAMILY,
+		.phy_id_mask = MARVELL_PHY_ID_MASK,
+		.name = "Marvell 88E6390 Family",
 		/* PHY_GBIT_FEATURES */
 		.probe = m88e6390_probe,
 		.config_init = &marvell_config_init,
@@ -2441,7 +2463,8 @@ static struct mdio_device_id __maybe_unused marvell_tbl[] = {
 	{ MARVELL_PHY_ID_88E1540, MARVELL_PHY_ID_MASK },
 	{ MARVELL_PHY_ID_88E1545, MARVELL_PHY_ID_MASK },
 	{ MARVELL_PHY_ID_88E3016, MARVELL_PHY_ID_MASK },
-	{ MARVELL_PHY_ID_88E6390, MARVELL_PHY_ID_MASK },
+	{ MARVELL_PHY_ID_88E6341_FAMILY, MARVELL_PHY_ID_MASK },
+	{ MARVELL_PHY_ID_88E6390_FAMILY, MARVELL_PHY_ID_MASK },
 	{ }
 };
 
diff --git a/include/linux/marvell_phy.h b/include/linux/marvell_phy.h
index af6b11d4d673..1847a0784243 100644
--- a/include/linux/marvell_phy.h
+++ b/include/linux/marvell_phy.h
@@ -23,11 +23,12 @@
 #define MARVELL_PHY_ID_88X3310		0x002b09a0
 #define MARVELL_PHY_ID_88E2110		0x002b09b0
 
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

