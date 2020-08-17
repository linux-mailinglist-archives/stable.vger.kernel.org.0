Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24114247293
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:45:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391319AbgHQSol (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:44:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:43042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730138AbgHQP4L (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:56:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0B59208C7;
        Mon, 17 Aug 2020 15:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679771;
        bh=EbKJFmJMFC5qcVZXrPC9mGVW7qZWGEtTZ4ULWTa08eo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KWMX+8yx1v1mC9+60qsHTaRGohKtSQ4f791touuMKE9VNhCy+HrwFESniYQmHP+uC
         uDMnjM5N/dLnvG3bH/8a35ogyAbZPSmR2xrwO0+YTCyZpmt9j3engwNMkmPCbdq+v2
         pS4wQy6JeDUZ6aELvAJa+DwOY+hylC3lcZDCq2BY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>, Baruch Siach <baruch@tkos.co.il>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.7 329/393] net: phy: marvell10g: fix null pointer dereference
Date:   Mon, 17 Aug 2020 17:16:19 +0200
Message-Id: <20200817143835.554848778@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Marek Behún" <marek.behun@nic.cz>

[ Upstream commit 1b8ef1423dbfd34de2439a2db457b84480b7c8a8 ]

Commit c3e302edca24 ("net: phy: marvell10g: fix temperature sensor on 2110")
added a check for PHY ID via phydev->drv->phy_id in a function which is
called by devres at a time when phydev->drv is already set to null by
phy_remove function.

This null pointer dereference can be triggered via SFP subsystem with a
SFP module containing this Marvell PHY. When the SFP interface is put
down, the SFP subsystem removes the PHY.

Fixes: c3e302edca24 ("net: phy: marvell10g: fix temperature sensor on 2110")
Signed-off-by: Marek Behún <marek.behun@nic.cz>
Cc: Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Baruch Siach <baruch@tkos.co.il>
Cc: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/marvell10g.c |   18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -205,13 +205,6 @@ static int mv3310_hwmon_config(struct ph
 			      MV_V2_TEMP_CTRL_MASK, val);
 }
 
-static void mv3310_hwmon_disable(void *data)
-{
-	struct phy_device *phydev = data;
-
-	mv3310_hwmon_config(phydev, false);
-}
-
 static int mv3310_hwmon_probe(struct phy_device *phydev)
 {
 	struct device *dev = &phydev->mdio.dev;
@@ -235,10 +228,6 @@ static int mv3310_hwmon_probe(struct phy
 	if (ret)
 		return ret;
 
-	ret = devm_add_action_or_reset(dev, mv3310_hwmon_disable, phydev);
-	if (ret)
-		return ret;
-
 	priv->hwmon_dev = devm_hwmon_device_register_with_info(dev,
 				priv->hwmon_name, phydev,
 				&mv3310_hwmon_chip_info, NULL);
@@ -423,6 +412,11 @@ static int mv3310_probe(struct phy_devic
 	return phy_sfp_probe(phydev, &mv3310_sfp_ops);
 }
 
+static void mv3310_remove(struct phy_device *phydev)
+{
+	mv3310_hwmon_config(phydev, false);
+}
+
 static int mv3310_suspend(struct phy_device *phydev)
 {
 	return mv3310_power_down(phydev);
@@ -763,6 +757,7 @@ static struct phy_driver mv3310_drivers[
 		.read_status	= mv3310_read_status,
 		.get_tunable	= mv3310_get_tunable,
 		.set_tunable	= mv3310_set_tunable,
+		.remove		= mv3310_remove,
 	},
 	{
 		.phy_id		= MARVELL_PHY_ID_88E2110,
@@ -778,6 +773,7 @@ static struct phy_driver mv3310_drivers[
 		.read_status	= mv3310_read_status,
 		.get_tunable	= mv3310_get_tunable,
 		.set_tunable	= mv3310_set_tunable,
+		.remove		= mv3310_remove,
 	},
 };
 


