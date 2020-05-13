Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4C321D0E51
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 11:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732603AbgEMJ7T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:59:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:55554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387962AbgEMJxc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:53:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68EB220769;
        Wed, 13 May 2020 09:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363611;
        bh=vtTYfenDTiknJybDemWFnKrjtKPZpagDPm/tbPp0Ouk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mJFQYNF7Upan6jqpRCgSyxNrSwBGJ7GXbCaKgkNhFsQztZKMYdTDhjZ7JdoNNUj2v
         nPkgJsrHBQCY06kxQeaRiQbFGKRv3B4Ly+Q1Iv1rApFEMJq2BOi41tG3Su8WQZfNm/
         0wDN753ukFXZDz/xQ7xMNmExJbcxDXNhHyywILIg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>, Baruch Siach <baruch@tkos.co.il>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 027/118] net: phy: marvell10g: fix temperature sensor on 2110
Date:   Wed, 13 May 2020 11:44:06 +0200
Message-Id: <20200513094420.000084079@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094417.618129545@linuxfoundation.org>
References: <20200513094417.618129545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baruch Siach <baruch@tkos.co.il>

[ Upstream commit c3e302edca2457bbd0c958c445a7538fbf6a6ac8 ]

Read the temperature sensor register from the correct location for the
88E2110 PHY. There is no enable/disable bit on 2110, so make
mv3310_hwmon_config() run on 88X3310 only.

Fixes: 62d01535474b61 ("net: phy: marvell10g: add support for the 88x2110 PHY")
Cc: Maxime Chevallier <maxime.chevallier@bootlin.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Baruch Siach <baruch@tkos.co.il>
Reviewed-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/marvell10g.c |   27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -44,6 +44,9 @@ enum {
 	MV_PCS_PAIRSWAP_AB	= 0x0002,
 	MV_PCS_PAIRSWAP_NONE	= 0x0003,
 
+	/* Temperature read register (88E2110 only) */
+	MV_PCS_TEMP		= 0x8042,
+
 	/* These registers appear at 0x800X and 0xa00X - the 0xa00X control
 	 * registers appear to set themselves to the 0x800X when AN is
 	 * restarted, but status registers appear readable from either.
@@ -54,6 +57,7 @@ enum {
 	/* Vendor2 MMD registers */
 	MV_V2_PORT_CTRL		= 0xf001,
 	MV_V2_PORT_CTRL_PWRDOWN = 0x0800,
+	/* Temperature control/read registers (88X3310 only) */
 	MV_V2_TEMP_CTRL		= 0xf08a,
 	MV_V2_TEMP_CTRL_MASK	= 0xc000,
 	MV_V2_TEMP_CTRL_SAMPLE	= 0x0000,
@@ -79,6 +83,24 @@ static umode_t mv3310_hwmon_is_visible(c
 	return 0;
 }
 
+static int mv3310_hwmon_read_temp_reg(struct phy_device *phydev)
+{
+	return phy_read_mmd(phydev, MDIO_MMD_VEND2, MV_V2_TEMP);
+}
+
+static int mv2110_hwmon_read_temp_reg(struct phy_device *phydev)
+{
+	return phy_read_mmd(phydev, MDIO_MMD_PCS, MV_PCS_TEMP);
+}
+
+static int mv10g_hwmon_read_temp_reg(struct phy_device *phydev)
+{
+	if (phydev->drv->phy_id == MARVELL_PHY_ID_88X3310)
+		return mv3310_hwmon_read_temp_reg(phydev);
+	else /* MARVELL_PHY_ID_88E2110 */
+		return mv2110_hwmon_read_temp_reg(phydev);
+}
+
 static int mv3310_hwmon_read(struct device *dev, enum hwmon_sensor_types type,
 			     u32 attr, int channel, long *value)
 {
@@ -91,7 +113,7 @@ static int mv3310_hwmon_read(struct devi
 	}
 
 	if (type == hwmon_temp && attr == hwmon_temp_input) {
-		temp = phy_read_mmd(phydev, MDIO_MMD_VEND2, MV_V2_TEMP);
+		temp = mv10g_hwmon_read_temp_reg(phydev);
 		if (temp < 0)
 			return temp;
 
@@ -144,6 +166,9 @@ static int mv3310_hwmon_config(struct ph
 	u16 val;
 	int ret;
 
+	if (phydev->drv->phy_id != MARVELL_PHY_ID_88X3310)
+		return 0;
+
 	ret = phy_write_mmd(phydev, MDIO_MMD_VEND2, MV_V2_TEMP,
 			    MV_V2_TEMP_UNKNOWN);
 	if (ret < 0)


