Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00AF042DCCB
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 17:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232917AbhJNPBz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 11:01:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:45148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231977AbhJNPAg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Oct 2021 11:00:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C198611CB;
        Thu, 14 Oct 2021 14:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634223494;
        bh=mr6EYhAyGub4WdJKqDvzvA/q+Sc+Lp7O7crvO6T8n+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aYuEsZalBC8lbWX8PQPlnwhzWu9OtXjg3DoJ9EdMQKbqgVjmk5N7UbAKlUtuhPxL7
         kOOz04Kb+tfRr20mgLj5x2miC0CMWUQ6tPK+0+jM6aWGJuNmAFk/UqtRDbJ+qlI+Lq
         Wf1i6LQ3Bv6+W8ut8p0P/mSK1xRD4XoTMApYg2qc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 01/12] net: phy: bcm7xxx: Fixed indirect MMD operations
Date:   Thu, 14 Oct 2021 16:54:01 +0200
Message-Id: <20211014145206.612929174@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211014145206.566123760@linuxfoundation.org>
References: <20211014145206.566123760@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

commit d88fd1b546ff19c8040cfaea76bf16aed1c5a0bb upstream.

When EEE support was added to the 28nm EPHY it was assumed that it would
be able to support the standard clause 45 over clause 22 register access
method. It turns out that the PHY does not support that, which is the
very reason for using the indirect shadow mode 2 bank 3 access method.

Implement {read,write}_mmd to allow the standard PHY library routines
pertaining to EEE querying and configuration to work correctly on these
PHYs. This forces us to implement a __phy_set_clr_bits() function that
does not grab the MDIO bus lock since the PHY driver's {read,write}_mmd
functions are always called with that lock held.

Fixes: 83ee102a6998 ("net: phy: bcm7xxx: add support for 28nm EPHY")
[florian: adjust locking since phy_{read,write}_mmd are called with no
PHYLIB locks held]
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/phy/bcm7xxx.c |   94 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 94 insertions(+)

--- a/drivers/net/phy/bcm7xxx.c
+++ b/drivers/net/phy/bcm7xxx.c
@@ -30,7 +30,12 @@
 #define MII_BCM7XXX_SHD_2_ADDR_CTRL	0xe
 #define MII_BCM7XXX_SHD_2_CTRL_STAT	0xf
 #define MII_BCM7XXX_SHD_2_BIAS_TRIM	0x1a
+#define MII_BCM7XXX_SHD_3_PCS_CTRL	0x0
+#define MII_BCM7XXX_SHD_3_PCS_STATUS	0x1
+#define MII_BCM7XXX_SHD_3_EEE_CAP	0x2
 #define MII_BCM7XXX_SHD_3_AN_EEE_ADV	0x3
+#define MII_BCM7XXX_SHD_3_EEE_LP	0x4
+#define MII_BCM7XXX_SHD_3_EEE_WK_ERR	0x5
 #define MII_BCM7XXX_SHD_3_PCS_CTRL_2	0x6
 #define  MII_BCM7XXX_PCS_CTRL_2_DEF	0x4400
 #define MII_BCM7XXX_SHD_3_AN_STAT	0xb
@@ -463,6 +468,93 @@ static int bcm7xxx_28nm_ephy_config_init
 	return bcm7xxx_28nm_ephy_apd_enable(phydev);
 }
 
+#define MII_BCM7XXX_REG_INVALID	0xff
+
+static u8 bcm7xxx_28nm_ephy_regnum_to_shd(u16 regnum)
+{
+	switch (regnum) {
+	case MDIO_CTRL1:
+		return MII_BCM7XXX_SHD_3_PCS_CTRL;
+	case MDIO_STAT1:
+		return MII_BCM7XXX_SHD_3_PCS_STATUS;
+	case MDIO_PCS_EEE_ABLE:
+		return MII_BCM7XXX_SHD_3_EEE_CAP;
+	case MDIO_AN_EEE_ADV:
+		return MII_BCM7XXX_SHD_3_AN_EEE_ADV;
+	case MDIO_AN_EEE_LPABLE:
+		return MII_BCM7XXX_SHD_3_EEE_LP;
+	case MDIO_PCS_EEE_WK_ERR:
+		return MII_BCM7XXX_SHD_3_EEE_WK_ERR;
+	default:
+		return MII_BCM7XXX_REG_INVALID;
+	}
+}
+
+static bool bcm7xxx_28nm_ephy_dev_valid(int devnum)
+{
+	return devnum == MDIO_MMD_AN || devnum == MDIO_MMD_PCS;
+}
+
+static int bcm7xxx_28nm_ephy_read_mmd(struct phy_device *phydev,
+				      int devnum, u16 regnum)
+{
+	u8 shd = bcm7xxx_28nm_ephy_regnum_to_shd(regnum);
+	int ret;
+
+	if (!bcm7xxx_28nm_ephy_dev_valid(devnum) ||
+	    shd == MII_BCM7XXX_REG_INVALID)
+		return -EOPNOTSUPP;
+
+	/* set shadow mode 2 */
+	ret = phy_set_clr_bits(phydev, MII_BCM7XXX_TEST,
+			       MII_BCM7XXX_SHD_MODE_2, 0);
+	if (ret < 0)
+		return ret;
+
+	/* Access the desired shadow register address */
+	ret = phy_write(phydev, MII_BCM7XXX_SHD_2_ADDR_CTRL, shd);
+	if (ret < 0)
+		goto reset_shadow_mode;
+
+	ret = phy_read(phydev, MII_BCM7XXX_SHD_2_CTRL_STAT);
+
+reset_shadow_mode:
+	/* reset shadow mode 2 */
+	phy_set_clr_bits(phydev, MII_BCM7XXX_TEST, 0,
+			 MII_BCM7XXX_SHD_MODE_2);
+	return ret;
+}
+
+static int bcm7xxx_28nm_ephy_write_mmd(struct phy_device *phydev,
+				       int devnum, u16 regnum, u16 val)
+{
+	u8 shd = bcm7xxx_28nm_ephy_regnum_to_shd(regnum);
+	int ret;
+
+	if (!bcm7xxx_28nm_ephy_dev_valid(devnum) ||
+	    shd == MII_BCM7XXX_REG_INVALID)
+		return -EOPNOTSUPP;
+
+	/* set shadow mode 2 */
+	ret = phy_set_clr_bits(phydev, MII_BCM7XXX_TEST,
+			       MII_BCM7XXX_SHD_MODE_2, 0);
+	if (ret < 0)
+		return ret;
+
+	/* Access the desired shadow register address */
+	ret = phy_write(phydev, MII_BCM7XXX_SHD_2_ADDR_CTRL, shd);
+	if (ret < 0)
+		goto reset_shadow_mode;
+
+	/* Write the desired value in the shadow register */
+	phy_write(phydev, MII_BCM7XXX_SHD_2_CTRL_STAT, val);
+
+reset_shadow_mode:
+	/* reset shadow mode 2 */
+	return phy_set_clr_bits(phydev, MII_BCM7XXX_TEST, 0,
+				MII_BCM7XXX_SHD_MODE_2);
+}
+
 static int bcm7xxx_28nm_ephy_resume(struct phy_device *phydev)
 {
 	int ret;
@@ -634,6 +726,8 @@ static int bcm7xxx_28nm_probe(struct phy
 	.get_strings	= bcm_phy_get_strings,				\
 	.get_stats	= bcm7xxx_28nm_get_phy_stats,			\
 	.probe		= bcm7xxx_28nm_probe,				\
+	.read_mmd	= bcm7xxx_28nm_ephy_read_mmd,			\
+	.write_mmd	= bcm7xxx_28nm_ephy_write_mmd,			\
 }
 
 #define BCM7XXX_40NM_EPHY(_oui, _name)					\


