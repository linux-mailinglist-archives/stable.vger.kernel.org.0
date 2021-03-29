Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E66A634C913
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233718AbhC2I0i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:26:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:43434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233330AbhC2IYy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:24:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30D56619B7;
        Mon, 29 Mar 2021 08:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006287;
        bh=xy1S9CwRaPguvtzmqgW2ErK1Gu2UlLNa9OShbfVaym4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=szODNotP5lzsI+dHnS+RUc8+IuoxJ9fM85wZFxWjDYowk5TdFIVH1G0pa81BtWrMj
         WeUyeC8q3enMZABvI1xObkmUNguRslewGrIJgqaTkFG4gpKU21T1UVH0LBcROP7no6
         9zwBQoMXig2N5Cqoau5XfSYAcHTunboctmOzJG+0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Hancock <robert.hancock@calian.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 187/221] net: phy: broadcom: Set proper 1000BaseX/SGMII interface mode for BCM54616S
Date:   Mon, 29 Mar 2021 09:58:38 +0200
Message-Id: <20210329075635.365861689@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Hancock <robert.hancock@calian.com>

[ Upstream commit 3afd0218992a8d1398e9791d6c2edd4c948ae7ee ]

The default configuration for the BCM54616S PHY may not match the desired
mode when using 1000BaseX or SGMII interface modes, such as when it is on
an SFP module. Add code to explicitly set the correct mode using
programming sequences provided by Bel-Fuse:

https://www.belfuse.com/resources/datasheets/powersolutions/ds-bps-sfp-1gbt-05-series.pdf
https://www.belfuse.com/resources/datasheets/powersolutions/ds-bps-sfp-1gbt-06-series.pdf

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/broadcom.c | 84 ++++++++++++++++++++++++++++++++------
 include/linux/brcmphy.h    |  4 ++
 2 files changed, 76 insertions(+), 12 deletions(-)

diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
index 88e9708e0562..6f6e64f81924 100644
--- a/drivers/net/phy/broadcom.c
+++ b/drivers/net/phy/broadcom.c
@@ -103,6 +103,64 @@ static int bcm54612e_config_init(struct phy_device *phydev)
 	return 0;
 }
 
+static int bcm54616s_config_init(struct phy_device *phydev)
+{
+	int rc, val;
+
+	if (phydev->interface != PHY_INTERFACE_MODE_SGMII &&
+	    phydev->interface != PHY_INTERFACE_MODE_1000BASEX)
+		return 0;
+
+	/* Ensure proper interface mode is selected. */
+	/* Disable RGMII mode */
+	val = bcm54xx_auxctl_read(phydev, MII_BCM54XX_AUXCTL_SHDWSEL_MISC);
+	if (val < 0)
+		return val;
+	val &= ~MII_BCM54XX_AUXCTL_SHDWSEL_MISC_RGMII_EN;
+	val |= MII_BCM54XX_AUXCTL_MISC_WREN;
+	rc = bcm54xx_auxctl_write(phydev, MII_BCM54XX_AUXCTL_SHDWSEL_MISC,
+				  val);
+	if (rc < 0)
+		return rc;
+
+	/* Select 1000BASE-X register set (primary SerDes) */
+	val = bcm_phy_read_shadow(phydev, BCM54XX_SHD_MODE);
+	if (val < 0)
+		return val;
+	val |= BCM54XX_SHD_MODE_1000BX;
+	rc = bcm_phy_write_shadow(phydev, BCM54XX_SHD_MODE, val);
+	if (rc < 0)
+		return rc;
+
+	/* Power down SerDes interface */
+	rc = phy_set_bits(phydev, MII_BMCR, BMCR_PDOWN);
+	if (rc < 0)
+		return rc;
+
+	/* Select proper interface mode */
+	val &= ~BCM54XX_SHD_INTF_SEL_MASK;
+	val |= phydev->interface == PHY_INTERFACE_MODE_SGMII ?
+		BCM54XX_SHD_INTF_SEL_SGMII :
+		BCM54XX_SHD_INTF_SEL_GBIC;
+	rc = bcm_phy_write_shadow(phydev, BCM54XX_SHD_MODE, val);
+	if (rc < 0)
+		return rc;
+
+	/* Power up SerDes interface */
+	rc = phy_clear_bits(phydev, MII_BMCR, BMCR_PDOWN);
+	if (rc < 0)
+		return rc;
+
+	/* Select copper register set */
+	val &= ~BCM54XX_SHD_MODE_1000BX;
+	rc = bcm_phy_write_shadow(phydev, BCM54XX_SHD_MODE, val);
+	if (rc < 0)
+		return rc;
+
+	/* Power up copper interface */
+	return phy_clear_bits(phydev, MII_BMCR, BMCR_PDOWN);
+}
+
 /* Needs SMDSP clock enabled via bcm54xx_phydsp_config() */
 static int bcm50610_a0_workaround(struct phy_device *phydev)
 {
@@ -281,15 +339,17 @@ static int bcm54xx_config_init(struct phy_device *phydev)
 
 	bcm54xx_adjust_rxrefclk(phydev);
 
-	if (BRCM_PHY_MODEL(phydev) == PHY_ID_BCM54210E) {
+	switch (BRCM_PHY_MODEL(phydev)) {
+	case PHY_ID_BCM54210E:
 		err = bcm54210e_config_init(phydev);
-		if (err)
-			return err;
-	} else if (BRCM_PHY_MODEL(phydev) == PHY_ID_BCM54612E) {
+		break;
+	case PHY_ID_BCM54612E:
 		err = bcm54612e_config_init(phydev);
-		if (err)
-			return err;
-	} else if (BRCM_PHY_MODEL(phydev) == PHY_ID_BCM54810) {
+		break;
+	case PHY_ID_BCM54616S:
+		err = bcm54616s_config_init(phydev);
+		break;
+	case PHY_ID_BCM54810:
 		/* For BCM54810, we need to disable BroadR-Reach function */
 		val = bcm_phy_read_exp(phydev,
 				       BCM54810_EXP_BROADREACH_LRE_MISC_CTL);
@@ -297,9 +357,10 @@ static int bcm54xx_config_init(struct phy_device *phydev)
 		err = bcm_phy_write_exp(phydev,
 					BCM54810_EXP_BROADREACH_LRE_MISC_CTL,
 					val);
-		if (err < 0)
-			return err;
+		break;
 	}
+	if (err)
+		return err;
 
 	bcm54xx_phydsp_config(phydev);
 
@@ -478,7 +539,7 @@ static int bcm5481_config_aneg(struct phy_device *phydev)
 
 static int bcm54616s_probe(struct phy_device *phydev)
 {
-	int val, intf_sel;
+	int val;
 
 	val = bcm_phy_read_shadow(phydev, BCM54XX_SHD_MODE);
 	if (val < 0)
@@ -490,8 +551,7 @@ static int bcm54616s_probe(struct phy_device *phydev)
 	 * RGMII-1000Base-X is properly supported, but RGMII-100Base-FX
 	 * support is still missing as of now.
 	 */
-	intf_sel = (val & BCM54XX_SHD_INTF_SEL_MASK) >> 1;
-	if (intf_sel == 1) {
+	if ((val & BCM54XX_SHD_INTF_SEL_MASK) == BCM54XX_SHD_INTF_SEL_RGMII) {
 		val = bcm_phy_read_shadow(phydev, BCM54616S_SHD_100FX_CTRL);
 		if (val < 0)
 			return val;
diff --git a/include/linux/brcmphy.h b/include/linux/brcmphy.h
index d0bd226d6bd9..54665952d6ad 100644
--- a/include/linux/brcmphy.h
+++ b/include/linux/brcmphy.h
@@ -136,6 +136,7 @@
 
 #define MII_BCM54XX_AUXCTL_SHDWSEL_MISC			0x07
 #define MII_BCM54XX_AUXCTL_SHDWSEL_MISC_WIRESPEED_EN	0x0010
+#define MII_BCM54XX_AUXCTL_SHDWSEL_MISC_RGMII_EN	0x0080
 #define MII_BCM54XX_AUXCTL_SHDWSEL_MISC_RGMII_SKEW_EN	0x0100
 #define MII_BCM54XX_AUXCTL_MISC_FORCE_AMDIX		0x0200
 #define MII_BCM54XX_AUXCTL_MISC_WREN			0x8000
@@ -222,6 +223,9 @@
 /* 11111: Mode Control Register */
 #define BCM54XX_SHD_MODE		0x1f
 #define BCM54XX_SHD_INTF_SEL_MASK	GENMASK(2, 1)	/* INTERF_SEL[1:0] */
+#define BCM54XX_SHD_INTF_SEL_RGMII	0x02
+#define BCM54XX_SHD_INTF_SEL_SGMII	0x04
+#define BCM54XX_SHD_INTF_SEL_GBIC	0x06
 #define BCM54XX_SHD_MODE_1000BX		BIT(0)	/* Enable 1000-X registers */
 
 /*
-- 
2.30.1



