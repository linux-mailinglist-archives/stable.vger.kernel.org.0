Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98BFA29C293
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:37:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1820730AbgJ0Rho (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:37:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:34108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1760595AbgJ0OfV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:35:21 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26E48207BB;
        Tue, 27 Oct 2020 14:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809320;
        bh=ezwpuEtSE8t1DPchafqOLuJ901dwhdYsmF0CgiR6vEw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VlDha9cRJ5YZHNWCAga14QvAiej3OB8DjX/PD1l+PG/N516IEq7ThSqaEsHMKziFd
         HT0C/Sfv/FUJA3WNX2TPl60l57OtFFAU0s9IvtS0j28TciYVgccsBopf22o4xMlCKq
         aFTk0o0mogfnpVd92l4ZUcAHw0gphZi4qgHP2xYM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 147/408] net: stmmac: use netif_tx_start|stop_all_queues() function
Date:   Tue, 27 Oct 2020 14:51:25 +0100
Message-Id: <20201027135501.915419876@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ong Boon Leong <boon.leong.ong@intel.com>

[ Upstream commit 9f19306d166688a73356aa636c62e698bf2063cc ]

The current implementation of stmmac_stop_all_queues() and
stmmac_start_all_queues() will not work correctly when the value of
tx_queues_to_use is changed through ethtool -L DEVNAME rx N tx M command.

Also, netif_tx_start|stop_all_queues() are only needed in driver open()
and close() only.

Fixes: c22a3f48 net: stmmac: adding multiple napi mechanism

Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 33 +------------------
 1 file changed, 1 insertion(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 982be75fde833..189cdb7633671 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -175,32 +175,6 @@ static void stmmac_enable_all_queues(struct stmmac_priv *priv)
 	}
 }
 
-/**
- * stmmac_stop_all_queues - Stop all queues
- * @priv: driver private structure
- */
-static void stmmac_stop_all_queues(struct stmmac_priv *priv)
-{
-	u32 tx_queues_cnt = priv->plat->tx_queues_to_use;
-	u32 queue;
-
-	for (queue = 0; queue < tx_queues_cnt; queue++)
-		netif_tx_stop_queue(netdev_get_tx_queue(priv->dev, queue));
-}
-
-/**
- * stmmac_start_all_queues - Start all queues
- * @priv: driver private structure
- */
-static void stmmac_start_all_queues(struct stmmac_priv *priv)
-{
-	u32 tx_queues_cnt = priv->plat->tx_queues_to_use;
-	u32 queue;
-
-	for (queue = 0; queue < tx_queues_cnt; queue++)
-		netif_tx_start_queue(netdev_get_tx_queue(priv->dev, queue));
-}
-
 static void stmmac_service_event_schedule(struct stmmac_priv *priv)
 {
 	if (!test_bit(STMMAC_DOWN, &priv->state) &&
@@ -2737,7 +2711,7 @@ static int stmmac_open(struct net_device *dev)
 	}
 
 	stmmac_enable_all_queues(priv);
-	stmmac_start_all_queues(priv);
+	netif_tx_start_all_queues(priv->dev);
 
 	return 0;
 
@@ -2778,8 +2752,6 @@ static int stmmac_release(struct net_device *dev)
 	phylink_stop(priv->phylink);
 	phylink_disconnect_phy(priv->phylink);
 
-	stmmac_stop_all_queues(priv);
-
 	stmmac_disable_all_queues(priv);
 
 	for (chan = 0; chan < priv->plat->tx_queues_to_use; chan++)
@@ -4770,7 +4742,6 @@ int stmmac_suspend(struct device *dev)
 	mutex_lock(&priv->lock);
 
 	netif_device_detach(ndev);
-	stmmac_stop_all_queues(priv);
 
 	stmmac_disable_all_queues(priv);
 
@@ -4883,8 +4854,6 @@ int stmmac_resume(struct device *dev)
 
 	stmmac_enable_all_queues(priv);
 
-	stmmac_start_all_queues(priv);
-
 	mutex_unlock(&priv->lock);
 
 	if (!device_may_wakeup(priv->device)) {
-- 
2.25.1



