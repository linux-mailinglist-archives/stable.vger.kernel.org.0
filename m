Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 394BF328B76
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:35:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239928AbhCASfH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:35:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:41706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239995AbhCAS2P (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:28:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA8D065005;
        Mon,  1 Mar 2021 17:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618563;
        bh=dR0bZ0yj2FeouI6kXJC36uvyehdFRUCww1UxU6wsQWA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MF6Jqrbw1nzNApwlLxq6wKm/UhLakbRf7aJiqJOOmOaNyGmy3SDOLGjMFtDdnY0Tu
         8ggweMSuTh51Z8s4qF4HP3SMld6YrKdYJLvCwYwXgkqtkjCODwySkBAZumgByIPyPO
         wSc0cjVXRpFZx/R60apO8vCIH9867cRZc2Mvqcpc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 102/663] net: phy: consider that suspend2ram may cut off PHY power
Date:   Mon,  1 Mar 2021 17:05:50 +0100
Message-Id: <20210301161146.780963539@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 4c0d2e96ba055bd8911bb8287def4f8ebbad15b6 ]

Claudiu reported that on his system S2R cuts off power to the PHY and
after resuming certain PHY settings are lost. The PM folks confirmed
that cutting off power to selected components in S2R is a valid case.
Therefore resuming from S2R, same as from hibernation, has to assume
that the PHY has power-on defaults. As a consequence use the restore
callback also as resume callback.
In addition make sure that the interrupt configuration is restored.
Let's do this in phy_init_hw() and ensure that after this call
actual interrupt configuration is in sync with phydev->interrupts.
Currently, if interrupt was enabled before hibernation, we would
resume with interrupt disabled because that's the power-on default.

This fix applies cleanly only after the commit marked as fixed.

I don't have an affected system, therefore change is compile-tested
only.

[0] https://lore.kernel.org/netdev/1610120754-14331-1-git-send-email-claudiu.beznea@microchip.com/

Fixes: 611d779af7ca ("net: phy: fix MDIO bus PM PHY resuming")
Reported-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phy_device.c | 53 ++++++++++++------------------------
 1 file changed, 17 insertions(+), 36 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 5dab6be6fc383..dd1f711140c3d 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -300,50 +300,22 @@ static int mdio_bus_phy_resume(struct device *dev)
 
 	phydev->suspended_by_mdio_bus = 0;
 
-	ret = phy_resume(phydev);
+	ret = phy_init_hw(phydev);
 	if (ret < 0)
 		return ret;
 
-no_resume:
-	if (phydev->attached_dev && phydev->adjust_link)
-		phy_start_machine(phydev);
-
-	return 0;
-}
-
-static int mdio_bus_phy_restore(struct device *dev)
-{
-	struct phy_device *phydev = to_phy_device(dev);
-	struct net_device *netdev = phydev->attached_dev;
-	int ret;
-
-	if (!netdev)
-		return 0;
-
-	ret = phy_init_hw(phydev);
+	ret = phy_resume(phydev);
 	if (ret < 0)
 		return ret;
-
+no_resume:
 	if (phydev->attached_dev && phydev->adjust_link)
 		phy_start_machine(phydev);
 
 	return 0;
 }
 
-static const struct dev_pm_ops mdio_bus_phy_pm_ops = {
-	.suspend = mdio_bus_phy_suspend,
-	.resume = mdio_bus_phy_resume,
-	.freeze = mdio_bus_phy_suspend,
-	.thaw = mdio_bus_phy_resume,
-	.restore = mdio_bus_phy_restore,
-};
-
-#define MDIO_BUS_PHY_PM_OPS (&mdio_bus_phy_pm_ops)
-
-#else
-
-#define MDIO_BUS_PHY_PM_OPS NULL
-
+static SIMPLE_DEV_PM_OPS(mdio_bus_phy_pm_ops, mdio_bus_phy_suspend,
+			 mdio_bus_phy_resume);
 #endif /* CONFIG_PM */
 
 /**
@@ -554,7 +526,7 @@ static const struct device_type mdio_bus_phy_type = {
 	.name = "PHY",
 	.groups = phy_dev_groups,
 	.release = phy_device_release,
-	.pm = MDIO_BUS_PHY_PM_OPS,
+	.pm = pm_ptr(&mdio_bus_phy_pm_ops),
 };
 
 static int phy_request_driver_module(struct phy_device *dev, u32 phy_id)
@@ -1143,10 +1115,19 @@ int phy_init_hw(struct phy_device *phydev)
 	if (ret < 0)
 		return ret;
 
-	if (phydev->drv->config_init)
+	if (phydev->drv->config_init) {
 		ret = phydev->drv->config_init(phydev);
+		if (ret < 0)
+			return ret;
+	}
 
-	return ret;
+	if (phydev->drv->config_intr) {
+		ret = phydev->drv->config_intr(phydev);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
 }
 EXPORT_SYMBOL(phy_init_hw);
 
-- 
2.27.0



