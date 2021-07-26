Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 226273D61BC
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233927AbhGZPcv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:32:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:43296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237833AbhGZP3Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:29:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B13CD6104F;
        Mon, 26 Jul 2021 16:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315722;
        bh=Ci8NwXawURBlAAGaCdbPSoAzx3i3WVpS1UIsf6UIfq4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pu5tsbCbSQ10ZyT8MrIvXD0LLuphAKjsnr3TDoGv+3khjY2BDVdYXrZIHz3dGz5kS
         pP9i7cFXn5bQT8pKvRLwfozGK22ef0wFkp6Eo9CO9pmriJEBngAdQz/9wJlmc50m39
         EiXax4vHTEMdmD01oswVum7fZFKM2rPV1D5yAWTw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 041/223] net: ocelot: fix switchdev objects synced for wrong netdev with LAG offload
Date:   Mon, 26 Jul 2021 17:37:13 +0200
Message-Id: <20210726153847.597069669@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit e56c6bbd98dc1cefb6f9c5d795fd29016e4f2fe7 ]

The point with a *dev and a *brport_dev is that when we have a LAG net
device that is a bridge port, *dev is an ocelot net device and
*brport_dev is the bonding/team net device. The ocelot net device
beneath the LAG does not exist from the bridge's perspective, so we need
to sync the switchdev objects belonging to the brport_dev and not to the
dev.

Fixes: e4bd44e89dcf ("net: ocelot: replay switchdev events when joining bridge")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mscc/ocelot_net.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index aad33d22c33f..3dc577183a40 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -1287,6 +1287,7 @@ static int ocelot_netdevice_lag_leave(struct net_device *dev,
 }
 
 static int ocelot_netdevice_changeupper(struct net_device *dev,
+					struct net_device *brport_dev,
 					struct netdev_notifier_changeupper_info *info)
 {
 	struct netlink_ext_ack *extack;
@@ -1296,11 +1297,11 @@ static int ocelot_netdevice_changeupper(struct net_device *dev,
 
 	if (netif_is_bridge_master(info->upper_dev)) {
 		if (info->linking)
-			err = ocelot_netdevice_bridge_join(dev, dev,
+			err = ocelot_netdevice_bridge_join(dev, brport_dev,
 							   info->upper_dev,
 							   extack);
 		else
-			err = ocelot_netdevice_bridge_leave(dev, dev,
+			err = ocelot_netdevice_bridge_leave(dev, brport_dev,
 							    info->upper_dev);
 	}
 	if (netif_is_lag_master(info->upper_dev)) {
@@ -1335,7 +1336,7 @@ ocelot_netdevice_lag_changeupper(struct net_device *dev,
 		if (ocelot_port->bond != dev)
 			return NOTIFY_OK;
 
-		err = ocelot_netdevice_changeupper(lower, info);
+		err = ocelot_netdevice_changeupper(lower, dev, info);
 		if (err)
 			return notifier_from_errno(err);
 	}
@@ -1374,7 +1375,7 @@ static int ocelot_netdevice_event(struct notifier_block *unused,
 		struct netdev_notifier_changeupper_info *info = ptr;
 
 		if (ocelot_netdevice_dev_check(dev))
-			return ocelot_netdevice_changeupper(dev, info);
+			return ocelot_netdevice_changeupper(dev, dev, info);
 
 		if (netif_is_lag_master(dev))
 			return ocelot_netdevice_lag_changeupper(dev, info);
-- 
2.30.2



