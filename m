Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D06E1E2B84
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391561AbgEZTGA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:06:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:34030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391092AbgEZTF7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:05:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B90F20776;
        Tue, 26 May 2020 19:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519958;
        bh=mRxvmJxdQSgll9Gs2py6a241v8LCbk3tjj+w8cKD8rg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wl7Zbc8GKW06z3RUXeRFZgx9HB+RSwlxM3FShJlwBmgbihYhjI/3uAhfUZTHtwxZu
         TuGoSBy5cLL7x9VIXLETzJG9SiR83Sg2o8sQtes91ysUczkn4iu/JQX9l/qck7VpFL
         gdE9GhBt2VAacDbnbMUZ/GwwRL215Vy1FcYHjDCM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 58/81] net: bcmgenet: code movement
Date:   Tue, 26 May 2020 20:53:33 +0200
Message-Id: <20200526183933.528845980@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183923.108515292@linuxfoundation.org>
References: <20200526183923.108515292@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Doug Berger <opendmb@gmail.com>

[ Upstream commit a94cbf03eb514d4d64d8c4f4caa0616b7ce5040a ]

This commit switches the order of bcmgenet_suspend and bcmgenet_resume
in the file to prevent the need for a forward declaration in the next
commit and to make the review of that commit easier.

Signed-off-by: Doug Berger <opendmb@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/broadcom/genet/bcmgenet.c    | 60 +++++++++----------
 1 file changed, 30 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 89cc146d2c5c..60abf9fab810 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -3616,36 +3616,6 @@ static int bcmgenet_remove(struct platform_device *pdev)
 }
 
 #ifdef CONFIG_PM_SLEEP
-static int bcmgenet_suspend(struct device *d)
-{
-	struct net_device *dev = dev_get_drvdata(d);
-	struct bcmgenet_priv *priv = netdev_priv(dev);
-	int ret = 0;
-
-	if (!netif_running(dev))
-		return 0;
-
-	netif_device_detach(dev);
-
-	bcmgenet_netif_stop(dev);
-
-	if (!device_may_wakeup(d))
-		phy_suspend(dev->phydev);
-
-	/* Prepare the device for Wake-on-LAN and switch to the slow clock */
-	if (device_may_wakeup(d) && priv->wolopts) {
-		ret = bcmgenet_power_down(priv, GENET_POWER_WOL_MAGIC);
-		clk_prepare_enable(priv->clk_wol);
-	} else if (priv->internal_phy) {
-		ret = bcmgenet_power_down(priv, GENET_POWER_PASSIVE);
-	}
-
-	/* Turn off the clocks */
-	clk_disable_unprepare(priv->clk);
-
-	return ret;
-}
-
 static int bcmgenet_resume(struct device *d)
 {
 	struct net_device *dev = dev_get_drvdata(d);
@@ -3724,6 +3694,36 @@ static int bcmgenet_resume(struct device *d)
 	clk_disable_unprepare(priv->clk);
 	return ret;
 }
+
+static int bcmgenet_suspend(struct device *d)
+{
+	struct net_device *dev = dev_get_drvdata(d);
+	struct bcmgenet_priv *priv = netdev_priv(dev);
+	int ret = 0;
+
+	if (!netif_running(dev))
+		return 0;
+
+	netif_device_detach(dev);
+
+	bcmgenet_netif_stop(dev);
+
+	if (!device_may_wakeup(d))
+		phy_suspend(dev->phydev);
+
+	/* Prepare the device for Wake-on-LAN and switch to the slow clock */
+	if (device_may_wakeup(d) && priv->wolopts) {
+		ret = bcmgenet_power_down(priv, GENET_POWER_WOL_MAGIC);
+		clk_prepare_enable(priv->clk_wol);
+	} else if (priv->internal_phy) {
+		ret = bcmgenet_power_down(priv, GENET_POWER_PASSIVE);
+	}
+
+	/* Turn off the clocks */
+	clk_disable_unprepare(priv->clk);
+
+	return ret;
+}
 #endif /* CONFIG_PM_SLEEP */
 
 static SIMPLE_DEV_PM_OPS(bcmgenet_pm_ops, bcmgenet_suspend, bcmgenet_resume);
-- 
2.25.1



