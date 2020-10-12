Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE58E28B84D
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390179AbgJLNvE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:51:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:53874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731835AbgJLNsN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:48:13 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A44722222C;
        Mon, 12 Oct 2020 13:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510425;
        bh=8L0ghgXoQILZhOgl1giv4A56zH08g+RadgboeKzdNB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vNml/5TlMU4Sn/NMNlkdNwEZvFFf3j4cEIjTz7OOegwJ81VS8CZfAZu9+VbOOEvUf
         TCHzvEwyhN9OGbapbMjIGKJjYzRHoE16gfOtgp69/MPuS2q+mjOCznI9d2sgoRgg2F
         lQEDkzcZkRIt0qBSJ5edc8rKi1PNpmUYEjm1eFtk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Vineetha G. Jaya Kumaran" <vineetha.g.jaya.kumaran@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 094/124] net: stmmac: Modify configuration method of EEE timers
Date:   Mon, 12 Oct 2020 15:31:38 +0200
Message-Id: <20201012133151.402676180@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012133146.834528783@linuxfoundation.org>
References: <20201012133146.834528783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vineetha G. Jaya Kumaran <vineetha.g.jaya.kumaran@intel.com>

[ Upstream commit 388e201d41fa1ed8f2dce0f0567f56f8e919ffb0 ]

Ethtool manual stated that the tx-timer is the "the amount of time the
device should stay in idle mode prior to asserting its Tx LPI". The
previous implementation for "ethtool --set-eee tx-timer" sets the LPI TW
timer duration which is not correct. Hence, this patch fixes the
"ethtool --set-eee tx-timer" to configure the EEE LPI timer.

The LPI TW Timer will be using the defined default value instead of
"ethtool --set-eee tx-timer" which follows the EEE LS timer implementation.

Changelog V2
*Not removing/modifying the eee_timer.
*EEE LPI timer can be configured through ethtool and also the eee_timer
module param.
*EEE TW Timer will be configured with default value only, not able to be
configured through ethtool or module param. This follows the implementation
of the EEE LS Timer.

Fixes: d765955d2ae0 ("stmmac: add the Energy Efficient Ethernet support")
Signed-off-by: Vineetha G. Jaya Kumaran <vineetha.g.jaya.kumaran@intel.com>
Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac.h  |  2 ++
 .../ethernet/stmicro/stmmac/stmmac_ethtool.c  | 12 +++++++++-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 23 ++++++++++++-------
 3 files changed, 28 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index 9c02fc754bf1b..545696971f65e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -203,6 +203,8 @@ struct stmmac_priv {
 	int eee_enabled;
 	int eee_active;
 	int tx_lpi_timer;
+	int tx_lpi_enabled;
+	int eee_tw_timer;
 	unsigned int mode;
 	unsigned int chain_mode;
 	int extend_desc;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
index c16d0cc3e9c44..b82c6715f95f3 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -652,6 +652,7 @@ static int stmmac_ethtool_op_get_eee(struct net_device *dev,
 	edata->eee_enabled = priv->eee_enabled;
 	edata->eee_active = priv->eee_active;
 	edata->tx_lpi_timer = priv->tx_lpi_timer;
+	edata->tx_lpi_enabled = priv->tx_lpi_enabled;
 
 	return phylink_ethtool_get_eee(priv->phylink, edata);
 }
@@ -665,6 +666,10 @@ static int stmmac_ethtool_op_set_eee(struct net_device *dev,
 	if (!priv->dma_cap.eee)
 		return -EOPNOTSUPP;
 
+	if (priv->tx_lpi_enabled != edata->tx_lpi_enabled)
+		netdev_warn(priv->dev,
+			    "Setting EEE tx-lpi is not supported\n");
+
 	if (!edata->eee_enabled)
 		stmmac_disable_eee_mode(priv);
 
@@ -672,7 +677,12 @@ static int stmmac_ethtool_op_set_eee(struct net_device *dev,
 	if (ret)
 		return ret;
 
-	priv->tx_lpi_timer = edata->tx_lpi_timer;
+	if (edata->eee_enabled &&
+	    priv->tx_lpi_timer != edata->tx_lpi_timer) {
+		priv->tx_lpi_timer = edata->tx_lpi_timer;
+		stmmac_eee_init(priv);
+	}
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 73677c3b33b65..73465e5f5a417 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -94,7 +94,7 @@ static const u32 default_msg_level = (NETIF_MSG_DRV | NETIF_MSG_PROBE |
 static int eee_timer = STMMAC_DEFAULT_LPI_TIMER;
 module_param(eee_timer, int, 0644);
 MODULE_PARM_DESC(eee_timer, "LPI tx expiration time in msec");
-#define STMMAC_LPI_T(x) (jiffies + msecs_to_jiffies(x))
+#define STMMAC_LPI_T(x) (jiffies + usecs_to_jiffies(x))
 
 /* By default the driver will use the ring mode to manage tx and rx descriptors,
  * but allow user to force to use the chain instead of the ring
@@ -370,7 +370,7 @@ static void stmmac_eee_ctrl_timer(struct timer_list *t)
 	struct stmmac_priv *priv = from_timer(priv, t, eee_ctrl_timer);
 
 	stmmac_enable_eee_mode(priv);
-	mod_timer(&priv->eee_ctrl_timer, STMMAC_LPI_T(eee_timer));
+	mod_timer(&priv->eee_ctrl_timer, STMMAC_LPI_T(priv->tx_lpi_timer));
 }
 
 /**
@@ -383,7 +383,7 @@ static void stmmac_eee_ctrl_timer(struct timer_list *t)
  */
 bool stmmac_eee_init(struct stmmac_priv *priv)
 {
-	int tx_lpi_timer = priv->tx_lpi_timer;
+	int eee_tw_timer = priv->eee_tw_timer;
 
 	/* Using PCS we cannot dial with the phy registers at this stage
 	 * so we do not support extra feature like EEE.
@@ -403,7 +403,7 @@ bool stmmac_eee_init(struct stmmac_priv *priv)
 		if (priv->eee_enabled) {
 			netdev_dbg(priv->dev, "disable EEE\n");
 			del_timer_sync(&priv->eee_ctrl_timer);
-			stmmac_set_eee_timer(priv, priv->hw, 0, tx_lpi_timer);
+			stmmac_set_eee_timer(priv, priv->hw, 0, eee_tw_timer);
 		}
 		mutex_unlock(&priv->lock);
 		return false;
@@ -411,11 +411,12 @@ bool stmmac_eee_init(struct stmmac_priv *priv)
 
 	if (priv->eee_active && !priv->eee_enabled) {
 		timer_setup(&priv->eee_ctrl_timer, stmmac_eee_ctrl_timer, 0);
-		mod_timer(&priv->eee_ctrl_timer, STMMAC_LPI_T(eee_timer));
 		stmmac_set_eee_timer(priv, priv->hw, STMMAC_DEFAULT_LIT_LS,
-				     tx_lpi_timer);
+				     eee_tw_timer);
 	}
 
+	mod_timer(&priv->eee_ctrl_timer, STMMAC_LPI_T(priv->tx_lpi_timer));
+
 	mutex_unlock(&priv->lock);
 	netdev_dbg(priv->dev, "Energy-Efficient Ethernet initialized\n");
 	return true;
@@ -930,6 +931,7 @@ static void stmmac_mac_link_down(struct phylink_config *config,
 
 	stmmac_mac_set(priv, priv->ioaddr, false);
 	priv->eee_active = false;
+	priv->tx_lpi_enabled = false;
 	stmmac_eee_init(priv);
 	stmmac_set_eee_pls(priv, priv->hw, false);
 }
@@ -1027,6 +1029,7 @@ static void stmmac_mac_link_up(struct phylink_config *config,
 	if (phy && priv->dma_cap.eee) {
 		priv->eee_active = phy_init_eee(phy, 1) >= 0;
 		priv->eee_enabled = stmmac_eee_init(priv);
+		priv->tx_lpi_enabled = priv->eee_enabled;
 		stmmac_set_eee_pls(priv, priv->hw, true);
 	}
 }
@@ -2057,7 +2060,7 @@ static int stmmac_tx_clean(struct stmmac_priv *priv, int budget, u32 queue)
 
 	if ((priv->eee_enabled) && (!priv->tx_path_in_lpi_mode)) {
 		stmmac_enable_eee_mode(priv);
-		mod_timer(&priv->eee_ctrl_timer, STMMAC_LPI_T(eee_timer));
+		mod_timer(&priv->eee_ctrl_timer, STMMAC_LPI_T(priv->tx_lpi_timer));
 	}
 
 	/* We still have pending packets, let's call for a new scheduling */
@@ -2690,7 +2693,11 @@ static int stmmac_hw_setup(struct net_device *dev, bool init_ptp)
 			netdev_warn(priv->dev, "PTP init failed\n");
 	}
 
-	priv->tx_lpi_timer = STMMAC_DEFAULT_TWT_LS;
+	priv->eee_tw_timer = STMMAC_DEFAULT_TWT_LS;
+
+	/* Convert the timer from msec to usec */
+	if (!priv->tx_lpi_timer)
+		priv->tx_lpi_timer = eee_timer * 1000;
 
 	if (priv->use_riwt) {
 		if (!priv->rx_riwt)
-- 
2.25.1



