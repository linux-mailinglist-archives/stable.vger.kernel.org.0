Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7D1C29C4BF
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 19:07:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1823053AbgJ0R5I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:57:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:45044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2509483AbgJ0OUw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:20:52 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BCC05206D4;
        Tue, 27 Oct 2020 14:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808451;
        bh=OjUdGh4Z85bmDQt9ToW+nl7MZhmz7IOacyixy5UXS5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VZjGo2F8EheLBAyfODYyWuWjeM9azJnqQrWOycm+UoxpyhRfjfXXI3KpNAclm0d34
         kw66Hoqu+f93wdFVhe4fMagxpAVwv+iIfpqkF3AZF8oSctHW2c6V6kI2eciFOCZqtX
         cxdxwuAisz0PJpAFRezLhK5Iq+XOa5jBjCXSCJ08=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 096/264] net: stmmac: use netif_tx_start|stop_all_queues() function
Date:   Tue, 27 Oct 2020 14:52:34 +0100
Message-Id: <20201027135435.204241270@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135430.632029009@linuxfoundation.org>
References: <20201027135430.632029009@linuxfoundation.org>
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
index c41879a955b57..2872684906e14 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -177,32 +177,6 @@ static void stmmac_enable_all_queues(struct stmmac_priv *priv)
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
@@ -2678,7 +2652,7 @@ static int stmmac_open(struct net_device *dev)
 	}
 
 	stmmac_enable_all_queues(priv);
-	stmmac_start_all_queues(priv);
+	netif_tx_start_all_queues(priv->dev);
 
 	return 0;
 
@@ -2724,8 +2698,6 @@ static int stmmac_release(struct net_device *dev)
 		phy_disconnect(dev->phydev);
 	}
 
-	stmmac_stop_all_queues(priv);
-
 	stmmac_disable_all_queues(priv);
 
 	for (chan = 0; chan < priv->plat->tx_queues_to_use; chan++)
@@ -4519,7 +4491,6 @@ int stmmac_suspend(struct device *dev)
 	mutex_lock(&priv->lock);
 
 	netif_device_detach(ndev);
-	stmmac_stop_all_queues(priv);
 
 	stmmac_disable_all_queues(priv);
 
@@ -4628,8 +4599,6 @@ int stmmac_resume(struct device *dev)
 
 	stmmac_enable_all_queues(priv);
 
-	stmmac_start_all_queues(priv);
-
 	mutex_unlock(&priv->lock);
 
 	if (ndev->phydev)
-- 
2.25.1



