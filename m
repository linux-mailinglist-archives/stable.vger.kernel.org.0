Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32D013D6162
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbhGZPa5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:30:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:41424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237802AbhGZP3Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:29:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D181861040;
        Mon, 26 Jul 2021 16:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315717;
        bh=fNxw5SKCDkE9+m8dpC5RvRb/DfRXI/Nm5DAV31/ZDoI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lY/euYW/cUsFPJMp9K4HnlovGgY7WECy93mS9VcvYs5Zt5EvkJCl4uOqLapAn+YUO
         O9TRbW/unQAzsxat0o9Bdi0GKZPaP2NZiEXjCi7g5qtJxhCkaiGmHJOwJUnBOxfTuw
         7CSlKWH1y0DZKhywCvjZk4HeqvrMLwwjQAdcaXnI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Matteo Croce <mcroce@linux.microsoft.com>,
        Matteo Croce <mcroce@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 039/223] net: phy: marvell10g: fix differentiation of 88X3310 from 88X3340
Date:   Mon, 26 Jul 2021 17:37:11 +0200
Message-Id: <20210726153847.526118470@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Behún <kabel@kernel.org>

[ Upstream commit a5de4be0aaaa66a2fa98e8a33bdbed3bd0682804 ]

It seems that we cannot differentiate 88X3310 from 88X3340 by simply
looking at bit 3 of revision ID. This only works on revisions A0 and A1.
On revision B0, this bit is always 1.

Instead use the 3.d00d register for differentiation, since this register
contains information about number of ports on the device.

Fixes: 9885d016ffa9 ("net: phy: marvell10g: add separate structure for 88X3340")
Signed-off-by: Marek Behún <kabel@kernel.org>
Reported-by: Matteo Croce <mcroce@linux.microsoft.com>
Tested-by: Matteo Croce <mcroce@microsoft.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/marvell10g.c | 40 +++++++++++++++++++++++++++++++-----
 include/linux/marvell_phy.h  |  6 +-----
 2 files changed, 36 insertions(+), 10 deletions(-)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index bbbc6ac8fa82..53a433442803 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -78,6 +78,11 @@ enum {
 	/* Temperature read register (88E2110 only) */
 	MV_PCS_TEMP		= 0x8042,
 
+	/* Number of ports on the device */
+	MV_PCS_PORT_INFO	= 0xd00d,
+	MV_PCS_PORT_INFO_NPORTS_MASK	= 0x0380,
+	MV_PCS_PORT_INFO_NPORTS_SHIFT	= 7,
+
 	/* These registers appear at 0x800X and 0xa00X - the 0xa00X control
 	 * registers appear to set themselves to the 0x800X when AN is
 	 * restarted, but status registers appear readable from either.
@@ -966,6 +971,30 @@ static const struct mv3310_chip mv2111_type = {
 #endif
 };
 
+static int mv3310_get_number_of_ports(struct phy_device *phydev)
+{
+	int ret;
+
+	ret = phy_read_mmd(phydev, MDIO_MMD_PCS, MV_PCS_PORT_INFO);
+	if (ret < 0)
+		return ret;
+
+	ret &= MV_PCS_PORT_INFO_NPORTS_MASK;
+	ret >>= MV_PCS_PORT_INFO_NPORTS_SHIFT;
+
+	return ret + 1;
+}
+
+static int mv3310_match_phy_device(struct phy_device *phydev)
+{
+	return mv3310_get_number_of_ports(phydev) == 1;
+}
+
+static int mv3340_match_phy_device(struct phy_device *phydev)
+{
+	return mv3310_get_number_of_ports(phydev) == 4;
+}
+
 static int mv211x_match_phy_device(struct phy_device *phydev, bool has_5g)
 {
 	int val;
@@ -994,7 +1023,8 @@ static int mv2111_match_phy_device(struct phy_device *phydev)
 static struct phy_driver mv3310_drivers[] = {
 	{
 		.phy_id		= MARVELL_PHY_ID_88X3310,
-		.phy_id_mask	= MARVELL_PHY_ID_88X33X0_MASK,
+		.phy_id_mask	= MARVELL_PHY_ID_MASK,
+		.match_phy_device = mv3310_match_phy_device,
 		.name		= "mv88x3310",
 		.driver_data	= &mv3310_type,
 		.get_features	= mv3310_get_features,
@@ -1011,8 +1041,9 @@ static struct phy_driver mv3310_drivers[] = {
 		.set_loopback	= genphy_c45_loopback,
 	},
 	{
-		.phy_id		= MARVELL_PHY_ID_88X3340,
-		.phy_id_mask	= MARVELL_PHY_ID_88X33X0_MASK,
+		.phy_id		= MARVELL_PHY_ID_88X3310,
+		.phy_id_mask	= MARVELL_PHY_ID_MASK,
+		.match_phy_device = mv3340_match_phy_device,
 		.name		= "mv88x3340",
 		.driver_data	= &mv3340_type,
 		.get_features	= mv3310_get_features,
@@ -1069,8 +1100,7 @@ static struct phy_driver mv3310_drivers[] = {
 module_phy_driver(mv3310_drivers);
 
 static struct mdio_device_id __maybe_unused mv3310_tbl[] = {
-	{ MARVELL_PHY_ID_88X3310, MARVELL_PHY_ID_88X33X0_MASK },
-	{ MARVELL_PHY_ID_88X3340, MARVELL_PHY_ID_88X33X0_MASK },
+	{ MARVELL_PHY_ID_88X3310, MARVELL_PHY_ID_MASK },
 	{ MARVELL_PHY_ID_88E2110, MARVELL_PHY_ID_MASK },
 	{ },
 };
diff --git a/include/linux/marvell_phy.h b/include/linux/marvell_phy.h
index acee44b9db26..0f06c2287b52 100644
--- a/include/linux/marvell_phy.h
+++ b/include/linux/marvell_phy.h
@@ -22,14 +22,10 @@
 #define MARVELL_PHY_ID_88E1545		0x01410ea0
 #define MARVELL_PHY_ID_88E1548P		0x01410ec0
 #define MARVELL_PHY_ID_88E3016		0x01410e60
+#define MARVELL_PHY_ID_88X3310		0x002b09a0
 #define MARVELL_PHY_ID_88E2110		0x002b09b0
 #define MARVELL_PHY_ID_88X2222		0x01410f10
 
-/* PHY IDs and mask for Alaska 10G PHYs */
-#define MARVELL_PHY_ID_88X33X0_MASK	0xfffffff8
-#define MARVELL_PHY_ID_88X3310		0x002b09a0
-#define MARVELL_PHY_ID_88X3340		0x002b09a8
-
 /* Marvel 88E1111 in Finisar SFP module with modified PHY ID */
 #define MARVELL_PHY_ID_88E1111_FINISAR	0x01ff0cc0
 
-- 
2.30.2



