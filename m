Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52C991D868F
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730739AbgERSY6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:24:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:47614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728802AbgERRrV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:47:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 395E320897;
        Mon, 18 May 2020 17:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824040;
        bh=o2rLPypImoZuBzXNaJCVkrUbeXVB7IAIYi8FmvN374E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=giHSfbzRszVIUja7d/JGMdUkWYkvOMfvKCcPnifL2UxwB0qCf9d4hH4FcVYTlzsmM
         nsa1H8WLQaDGKmTkRl/XUXm7BVS+jh8RIOFPJpb5bYxY0wFytvXRFlGvFi4vyPTxtA
         xm3p9ZgefMl34O7qYoC0ShwjKZEU+xCGrKe9xPCE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Hunter <jonathanh@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Bhadram Varka <vbhadram@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Subject: [PATCH 4.14 048/114] net: stmmac: Use mutex instead of spinlock
Date:   Mon, 18 May 2020 19:36:20 +0200
Message-Id: <20200518173511.977609991@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173503.033975649@linuxfoundation.org>
References: <20200518173503.033975649@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

commit 29555fa3de865630570b5f53c847b953413daf1a upstream.

Some drivers, such as DWC EQOS on Tegra, need to perform operations that
can sleep under this lock (clk_set_rate() in tegra_eqos_fix_speed()) for
proper operation. Since there is no need for this lock to be a spinlock,
convert it to a mutex instead.

Fixes: e6ea2d16fc61 ("net: stmmac: dwc-qos: Add Tegra186 support")
Reported-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Tested-by: Bhadram Varka <vbhadram@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac.h         |    2 -
 drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c |   12 +++----
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c    |   31 ++++++++-----------
 3 files changed, 21 insertions(+), 24 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -96,7 +96,7 @@ struct stmmac_priv {
 	struct net_device *dev;
 	struct device *device;
 	struct mac_device_info *hw;
-	spinlock_t lock;
+	struct mutex lock;
 
 	/* RX Queue */
 	struct stmmac_rx_queue rx_queue[MTL_MAX_RX_QUEUES];
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -392,13 +392,13 @@ stmmac_ethtool_set_link_ksettings(struct
 			ADVERTISED_10baseT_Half |
 			ADVERTISED_10baseT_Full);
 
-		spin_lock(&priv->lock);
+		mutex_lock(&priv->lock);
 
 		if (priv->hw->mac->pcs_ctrl_ane)
 			priv->hw->mac->pcs_ctrl_ane(priv->ioaddr, 1,
 						    priv->hw->ps, 0);
 
-		spin_unlock(&priv->lock);
+		mutex_unlock(&priv->lock);
 
 		return 0;
 	}
@@ -615,12 +615,12 @@ static void stmmac_get_wol(struct net_de
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
 
-	spin_lock_irq(&priv->lock);
+	mutex_lock(&priv->lock);
 	if (device_can_wakeup(priv->device)) {
 		wol->supported = WAKE_MAGIC | WAKE_UCAST;
 		wol->wolopts = priv->wolopts;
 	}
-	spin_unlock_irq(&priv->lock);
+	mutex_unlock(&priv->lock);
 }
 
 static int stmmac_set_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
@@ -649,9 +649,9 @@ static int stmmac_set_wol(struct net_dev
 		disable_irq_wake(priv->wol_irq);
 	}
 
-	spin_lock_irq(&priv->lock);
+	mutex_lock(&priv->lock);
 	priv->wolopts = wol->wolopts;
-	spin_unlock_irq(&priv->lock);
+	mutex_unlock(&priv->lock);
 
 	return 0;
 }
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -365,7 +365,6 @@ bool stmmac_eee_init(struct stmmac_priv
 {
 	struct net_device *ndev = priv->dev;
 	int interface = priv->plat->interface;
-	unsigned long flags;
 	bool ret = false;
 
 	if ((interface != PHY_INTERFACE_MODE_MII) &&
@@ -392,7 +391,7 @@ bool stmmac_eee_init(struct stmmac_priv
 			 * changed).
 			 * In that case the driver disable own timers.
 			 */
-			spin_lock_irqsave(&priv->lock, flags);
+			mutex_lock(&priv->lock);
 			if (priv->eee_active) {
 				netdev_dbg(priv->dev, "disable EEE\n");
 				del_timer_sync(&priv->eee_ctrl_timer);
@@ -400,11 +399,11 @@ bool stmmac_eee_init(struct stmmac_priv
 							     tx_lpi_timer);
 			}
 			priv->eee_active = 0;
-			spin_unlock_irqrestore(&priv->lock, flags);
+			mutex_unlock(&priv->lock);
 			goto out;
 		}
 		/* Activate the EEE and start timers */
-		spin_lock_irqsave(&priv->lock, flags);
+		mutex_lock(&priv->lock);
 		if (!priv->eee_active) {
 			priv->eee_active = 1;
 			setup_timer(&priv->eee_ctrl_timer,
@@ -421,7 +420,7 @@ bool stmmac_eee_init(struct stmmac_priv
 		priv->hw->mac->set_eee_pls(priv->hw, ndev->phydev->link);
 
 		ret = true;
-		spin_unlock_irqrestore(&priv->lock, flags);
+		mutex_unlock(&priv->lock);
 
 		netdev_dbg(priv->dev, "Energy-Efficient Ethernet initialized\n");
 	}
@@ -799,13 +798,12 @@ static void stmmac_adjust_link(struct ne
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
 	struct phy_device *phydev = dev->phydev;
-	unsigned long flags;
 	bool new_state = false;
 
 	if (!phydev)
 		return;
 
-	spin_lock_irqsave(&priv->lock, flags);
+	mutex_lock(&priv->lock);
 
 	if (phydev->link) {
 		u32 ctrl = readl(priv->ioaddr + MAC_CTRL_REG);
@@ -864,7 +862,7 @@ static void stmmac_adjust_link(struct ne
 	if (new_state && netif_msg_link(priv))
 		phy_print_status(phydev);
 
-	spin_unlock_irqrestore(&priv->lock, flags);
+	mutex_unlock(&priv->lock);
 
 	if (phydev->is_pseudo_fixed_link)
 		/* Stop PHY layer to call the hook to adjust the link in case
@@ -4284,7 +4282,7 @@ int stmmac_dvr_probe(struct device *devi
 			       (8 * priv->plat->rx_queues_to_use));
 	}
 
-	spin_lock_init(&priv->lock);
+	mutex_init(&priv->lock);
 
 	/* If a specific clk_csr value is passed from the platform
 	 * this means that the CSR Clock Range selection cannot be
@@ -4375,6 +4373,7 @@ int stmmac_dvr_remove(struct device *dev
 	    priv->hw->pcs != STMMAC_PCS_TBI &&
 	    priv->hw->pcs != STMMAC_PCS_RTBI)
 		stmmac_mdio_unregister(ndev);
+	mutex_destroy(&priv->lock);
 	free_netdev(ndev);
 
 	return 0;
@@ -4392,7 +4391,6 @@ int stmmac_suspend(struct device *dev)
 {
 	struct net_device *ndev = dev_get_drvdata(dev);
 	struct stmmac_priv *priv = netdev_priv(ndev);
-	unsigned long flags;
 
 	if (!ndev || !netif_running(ndev))
 		return 0;
@@ -4400,7 +4398,7 @@ int stmmac_suspend(struct device *dev)
 	if (ndev->phydev)
 		phy_stop(ndev->phydev);
 
-	spin_lock_irqsave(&priv->lock, flags);
+	mutex_lock(&priv->lock);
 
 	netif_device_detach(ndev);
 	stmmac_stop_all_queues(priv);
@@ -4423,7 +4421,7 @@ int stmmac_suspend(struct device *dev)
 		clk_disable_unprepare(priv->plat->pclk);
 		clk_disable_unprepare(priv->plat->stmmac_clk);
 	}
-	spin_unlock_irqrestore(&priv->lock, flags);
+	mutex_unlock(&priv->lock);
 
 	priv->oldlink = false;
 	priv->speed = SPEED_UNKNOWN;
@@ -4467,7 +4465,6 @@ int stmmac_resume(struct device *dev)
 {
 	struct net_device *ndev = dev_get_drvdata(dev);
 	struct stmmac_priv *priv = netdev_priv(ndev);
-	unsigned long flags;
 
 	if (!netif_running(ndev))
 		return 0;
@@ -4479,9 +4476,9 @@ int stmmac_resume(struct device *dev)
 	 * from another devices (e.g. serial console).
 	 */
 	if (device_may_wakeup(priv->device)) {
-		spin_lock_irqsave(&priv->lock, flags);
+		mutex_lock(&priv->lock);
 		priv->hw->mac->pmt(priv->hw, 0);
-		spin_unlock_irqrestore(&priv->lock, flags);
+		mutex_unlock(&priv->lock);
 		priv->irq_wake = 0;
 	} else {
 		pinctrl_pm_select_default_state(priv->device);
@@ -4497,7 +4494,7 @@ int stmmac_resume(struct device *dev)
 
 	netif_device_attach(ndev);
 
-	spin_lock_irqsave(&priv->lock, flags);
+	mutex_lock(&priv->lock);
 
 	stmmac_reset_queues_param(priv);
 
@@ -4516,7 +4513,7 @@ int stmmac_resume(struct device *dev)
 
 	stmmac_start_all_queues(priv);
 
-	spin_unlock_irqrestore(&priv->lock, flags);
+	mutex_unlock(&priv->lock);
 
 	if (ndev->phydev)
 		phy_start(ndev->phydev);


