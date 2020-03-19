Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDBA418B6CC
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:29:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730506AbgCSNYn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:24:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:51668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730294AbgCSNYm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:24:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4EB16207FC;
        Thu, 19 Mar 2020 13:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584624281;
        bh=rscVf6dwNB9dzq/D3Nht1OZDO62VoVsl8EagXBA8kRo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DCuUjwHj07UOFfsehYFNbfIcQzn5jTu/JG7J95s8QHoqE5A6/gJqN1wvCUIblvZ7m
         5bEFpQ30lXKKQ6NRkYU/rhB8QuZLxJ0vi0juPjKht95z0Fc2i36NcNBulFp+lJF3m6
         vmdHSJikIerlAgxJqk9NWV7Sq6E7B4BHc5BRXnm4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 48/60] net: rmnet: fix bridge mode bugs
Date:   Thu, 19 Mar 2020 14:04:26 +0100
Message-Id: <20200319123934.723714606@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123919.441695203@linuxfoundation.org>
References: <20200319123919.441695203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit d939b6d30bea1a2322bc536b12be0a7c4c2bccd7 ]

In order to attach a bridge interface to the rmnet interface,
"master" operation is used.
(e.g. ip link set dummy1 master rmnet0)
But, in the rmnet_add_bridge(), which is a callback of ->ndo_add_slave()
doesn't register lower interface.
So, ->ndo_del_slave() doesn't work.
There are other problems too.
1. It couldn't detect circular upper/lower interface relationship.
2. It couldn't prevent stack overflow because of too deep depth
of upper/lower interface
3. It doesn't check the number of lower interfaces.
4. Panics because of several reasons.

The root problem of these issues is actually the same.
So, in this patch, these all problems will be fixed.

Test commands:
    modprobe rmnet
    ip link add dummy0 type dummy
    ip link add rmnet0 link dummy0 type rmnet mux_id 1
    ip link add dummy1 master rmnet0 type dummy
    ip link add dummy2 master rmnet0 type dummy
    ip link del rmnet0
    ip link del dummy2
    ip link del dummy1

Splat looks like:
[   41.867595][ T1164] general protection fault, probably for non-canonical address 0xdffffc0000000101I
[   41.869993][ T1164] KASAN: null-ptr-deref in range [0x0000000000000808-0x000000000000080f]
[   41.872950][ T1164] CPU: 0 PID: 1164 Comm: ip Not tainted 5.6.0-rc1+ #447
[   41.873915][ T1164] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[   41.875161][ T1164] RIP: 0010:rmnet_unregister_bridge.isra.6+0x71/0xf0 [rmnet]
[   41.876178][ T1164] Code: 48 89 ef 48 89 c6 5b 5d e9 fc fe ff ff e8 f7 f3 ff ff 48 8d b8 08 08 00 00 48 ba 00 7
[   41.878925][ T1164] RSP: 0018:ffff8880c4d0f188 EFLAGS: 00010202
[   41.879774][ T1164] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000101
[   41.887689][ T1164] RDX: dffffc0000000000 RSI: ffffffffb8cf64f0 RDI: 0000000000000808
[   41.888727][ T1164] RBP: ffff8880c40e4000 R08: ffffed101b3c0e3c R09: 0000000000000001
[   41.889749][ T1164] R10: 0000000000000001 R11: ffffed101b3c0e3b R12: 1ffff110189a1e3c
[   41.890783][ T1164] R13: ffff8880c4d0f200 R14: ffffffffb8d56160 R15: ffff8880ccc2c000
[   41.891794][ T1164] FS:  00007f4300edc0c0(0000) GS:ffff8880d9c00000(0000) knlGS:0000000000000000
[   41.892953][ T1164] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   41.893800][ T1164] CR2: 00007f43003bc8c0 CR3: 00000000ca53e001 CR4: 00000000000606f0
[   41.894824][ T1164] Call Trace:
[   41.895274][ T1164]  ? rcu_is_watching+0x2c/0x80
[   41.895895][ T1164]  rmnet_config_notify_cb+0x1f7/0x590 [rmnet]
[   41.896687][ T1164]  ? rmnet_unregister_bridge.isra.6+0xf0/0xf0 [rmnet]
[   41.897611][ T1164]  ? rmnet_unregister_bridge.isra.6+0xf0/0xf0 [rmnet]
[   41.898508][ T1164]  ? __module_text_address+0x13/0x140
[   41.899162][ T1164]  notifier_call_chain+0x90/0x160
[   41.899814][ T1164]  rollback_registered_many+0x660/0xcf0
[   41.900544][ T1164]  ? netif_set_real_num_tx_queues+0x780/0x780
[   41.901316][ T1164]  ? __lock_acquire+0xdfe/0x3de0
[   41.901958][ T1164]  ? memset+0x1f/0x40
[   41.902468][ T1164]  ? __nla_validate_parse+0x98/0x1ab0
[   41.903166][ T1164]  unregister_netdevice_many.part.133+0x13/0x1b0
[   41.903988][ T1164]  rtnl_delete_link+0xbc/0x100
[ ... ]

Fixes: 60d58f971c10 ("net: qualcomm: rmnet: Implement bridge mode")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/qualcomm/rmnet/rmnet_config.c    | 131 +++++++++---------
 .../ethernet/qualcomm/rmnet/rmnet_config.h    |   1 +
 .../net/ethernet/qualcomm/rmnet/rmnet_vnd.c   |   8 --
 .../net/ethernet/qualcomm/rmnet/rmnet_vnd.h   |   1 -
 4 files changed, 64 insertions(+), 77 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
index e3fbf2331b965..fbf4cbcf1a654 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
@@ -13,25 +13,6 @@
 #include "rmnet_vnd.h"
 #include "rmnet_private.h"
 
-/* Locking scheme -
- * The shared resource which needs to be protected is realdev->rx_handler_data.
- * For the writer path, this is using rtnl_lock(). The writer paths are
- * rmnet_newlink(), rmnet_dellink() and rmnet_force_unassociate_device(). These
- * paths are already called with rtnl_lock() acquired in. There is also an
- * ASSERT_RTNL() to ensure that we are calling with rtnl acquired. For
- * dereference here, we will need to use rtnl_dereference(). Dev list writing
- * needs to happen with rtnl_lock() acquired for netdev_master_upper_dev_link().
- * For the reader path, the real_dev->rx_handler_data is called in the TX / RX
- * path. We only need rcu_read_lock() for these scenarios. In these cases,
- * the rcu_read_lock() is held in __dev_queue_xmit() and
- * netif_receive_skb_internal(), so readers need to use rcu_dereference_rtnl()
- * to get the relevant information. For dev list reading, we again acquire
- * rcu_read_lock() in rmnet_dellink() for netdev_master_upper_dev_get_rcu().
- * We also use unregister_netdevice_many() to free all rmnet devices in
- * rmnet_force_unassociate_device() so we dont lose the rtnl_lock() and free in
- * same context.
- */
-
 /* Local Definitions and Declarations */
 
 static const struct nla_policy rmnet_policy[IFLA_RMNET_MAX + 1] = {
@@ -51,9 +32,10 @@ rmnet_get_port_rtnl(const struct net_device *real_dev)
 	return rtnl_dereference(real_dev->rx_handler_data);
 }
 
-static int rmnet_unregister_real_device(struct net_device *real_dev,
-					struct rmnet_port *port)
+static int rmnet_unregister_real_device(struct net_device *real_dev)
 {
+	struct rmnet_port *port = rmnet_get_port_rtnl(real_dev);
+
 	if (port->nr_rmnet_devs)
 		return -EINVAL;
 
@@ -93,28 +75,33 @@ static int rmnet_register_real_device(struct net_device *real_dev)
 	return 0;
 }
 
-static void rmnet_unregister_bridge(struct net_device *dev,
-				    struct rmnet_port *port)
+static void rmnet_unregister_bridge(struct rmnet_port *port)
 {
-	struct rmnet_port *bridge_port;
-	struct net_device *bridge_dev;
+	struct net_device *bridge_dev, *real_dev, *rmnet_dev;
+	struct rmnet_port *real_port;
 
 	if (port->rmnet_mode != RMNET_EPMODE_BRIDGE)
 		return;
 
-	/* bridge slave handling */
+	rmnet_dev = port->rmnet_dev;
 	if (!port->nr_rmnet_devs) {
-		bridge_dev = port->bridge_ep;
+		/* bridge device */
+		real_dev = port->bridge_ep;
+		bridge_dev = port->dev;
 
-		bridge_port = rmnet_get_port_rtnl(bridge_dev);
-		bridge_port->bridge_ep = NULL;
-		bridge_port->rmnet_mode = RMNET_EPMODE_VND;
+		real_port = rmnet_get_port_rtnl(real_dev);
+		real_port->bridge_ep = NULL;
+		real_port->rmnet_mode = RMNET_EPMODE_VND;
 	} else {
+		/* real device */
 		bridge_dev = port->bridge_ep;
 
-		bridge_port = rmnet_get_port_rtnl(bridge_dev);
-		rmnet_unregister_real_device(bridge_dev, bridge_port);
+		port->bridge_ep = NULL;
+		port->rmnet_mode = RMNET_EPMODE_VND;
 	}
+
+	netdev_upper_dev_unlink(bridge_dev, rmnet_dev);
+	rmnet_unregister_real_device(bridge_dev);
 }
 
 static int rmnet_newlink(struct net *src_net, struct net_device *dev,
@@ -161,6 +148,7 @@ static int rmnet_newlink(struct net *src_net, struct net_device *dev,
 		goto err2;
 
 	port->rmnet_mode = mode;
+	port->rmnet_dev = dev;
 
 	hlist_add_head_rcu(&ep->hlnode, &port->muxed_ep[mux_id]);
 
@@ -178,8 +166,9 @@ static int rmnet_newlink(struct net *src_net, struct net_device *dev,
 
 err2:
 	unregister_netdevice(dev);
+	rmnet_vnd_dellink(mux_id, port, ep);
 err1:
-	rmnet_unregister_real_device(real_dev, port);
+	rmnet_unregister_real_device(real_dev);
 err0:
 	kfree(ep);
 	return err;
@@ -188,30 +177,32 @@ static int rmnet_newlink(struct net *src_net, struct net_device *dev,
 static void rmnet_dellink(struct net_device *dev, struct list_head *head)
 {
 	struct rmnet_priv *priv = netdev_priv(dev);
-	struct net_device *real_dev;
+	struct net_device *real_dev, *bridge_dev;
+	struct rmnet_port *real_port, *bridge_port;
 	struct rmnet_endpoint *ep;
-	struct rmnet_port *port;
-	u8 mux_id;
+	u8 mux_id = priv->mux_id;
 
 	real_dev = priv->real_dev;
 
-	if (!real_dev || !rmnet_is_real_dev_registered(real_dev))
+	if (!rmnet_is_real_dev_registered(real_dev))
 		return;
 
-	port = rmnet_get_port_rtnl(real_dev);
-
-	mux_id = rmnet_vnd_get_mux(dev);
+	real_port = rmnet_get_port_rtnl(real_dev);
+	bridge_dev = real_port->bridge_ep;
+	if (bridge_dev) {
+		bridge_port = rmnet_get_port_rtnl(bridge_dev);
+		rmnet_unregister_bridge(bridge_port);
+	}
 
-	ep = rmnet_get_endpoint(port, mux_id);
+	ep = rmnet_get_endpoint(real_port, mux_id);
 	if (ep) {
 		hlist_del_init_rcu(&ep->hlnode);
-		rmnet_unregister_bridge(dev, port);
-		rmnet_vnd_dellink(mux_id, port, ep);
+		rmnet_vnd_dellink(mux_id, real_port, ep);
 		kfree(ep);
 	}
-	netdev_upper_dev_unlink(real_dev, dev);
-	rmnet_unregister_real_device(real_dev, port);
 
+	netdev_upper_dev_unlink(real_dev, dev);
+	rmnet_unregister_real_device(real_dev);
 	unregister_netdevice_queue(dev, head);
 }
 
@@ -223,23 +214,23 @@ static void rmnet_force_unassociate_device(struct net_device *real_dev)
 	unsigned long bkt_ep;
 	LIST_HEAD(list);
 
-	ASSERT_RTNL();
-
 	port = rmnet_get_port_rtnl(real_dev);
 
-	rmnet_unregister_bridge(real_dev, port);
-
-	hash_for_each_safe(port->muxed_ep, bkt_ep, tmp_ep, ep, hlnode) {
-		netdev_upper_dev_unlink(real_dev, ep->egress_dev);
-		unregister_netdevice_queue(ep->egress_dev, &list);
-		rmnet_vnd_dellink(ep->mux_id, port, ep);
-		hlist_del_init_rcu(&ep->hlnode);
-		kfree(ep);
+	if (port->nr_rmnet_devs) {
+		/* real device */
+		rmnet_unregister_bridge(port);
+		hash_for_each_safe(port->muxed_ep, bkt_ep, tmp_ep, ep, hlnode) {
+			unregister_netdevice_queue(ep->egress_dev, &list);
+			netdev_upper_dev_unlink(real_dev, ep->egress_dev);
+			rmnet_vnd_dellink(ep->mux_id, port, ep);
+			hlist_del_init_rcu(&ep->hlnode);
+			kfree(ep);
+		}
+		rmnet_unregister_real_device(real_dev);
+		unregister_netdevice_many(&list);
+	} else {
+		rmnet_unregister_bridge(port);
 	}
-
-	unregister_netdevice_many(&list);
-
-	rmnet_unregister_real_device(real_dev, port);
 }
 
 static int rmnet_config_notify_cb(struct notifier_block *nb,
@@ -418,6 +409,9 @@ int rmnet_add_bridge(struct net_device *rmnet_dev,
 	if (port->nr_rmnet_devs > 1)
 		return -EINVAL;
 
+	if (port->rmnet_mode != RMNET_EPMODE_VND)
+		return -EINVAL;
+
 	if (rmnet_is_real_dev_registered(slave_dev))
 		return -EBUSY;
 
@@ -425,9 +419,17 @@ int rmnet_add_bridge(struct net_device *rmnet_dev,
 	if (err)
 		return -EBUSY;
 
+	err = netdev_master_upper_dev_link(slave_dev, rmnet_dev, NULL, NULL,
+					   extack);
+	if (err) {
+		rmnet_unregister_real_device(slave_dev);
+		return err;
+	}
+
 	slave_port = rmnet_get_port_rtnl(slave_dev);
 	slave_port->rmnet_mode = RMNET_EPMODE_BRIDGE;
 	slave_port->bridge_ep = real_dev;
+	slave_port->rmnet_dev = rmnet_dev;
 
 	port->rmnet_mode = RMNET_EPMODE_BRIDGE;
 	port->bridge_ep = slave_dev;
@@ -439,16 +441,9 @@ int rmnet_add_bridge(struct net_device *rmnet_dev,
 int rmnet_del_bridge(struct net_device *rmnet_dev,
 		     struct net_device *slave_dev)
 {
-	struct rmnet_priv *priv = netdev_priv(rmnet_dev);
-	struct net_device *real_dev = priv->real_dev;
-	struct rmnet_port *port, *slave_port;
-
-	port = rmnet_get_port_rtnl(real_dev);
-	port->rmnet_mode = RMNET_EPMODE_VND;
-	port->bridge_ep = NULL;
+	struct rmnet_port *port = rmnet_get_port_rtnl(slave_dev);
 
-	slave_port = rmnet_get_port_rtnl(slave_dev);
-	rmnet_unregister_real_device(slave_dev, slave_port);
+	rmnet_unregister_bridge(port);
 
 	netdev_dbg(slave_dev, "removed from rmnet as slave\n");
 	return 0;
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h
index 0d568dcfd65a1..be515982d6286 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h
@@ -28,6 +28,7 @@ struct rmnet_port {
 	u8 rmnet_mode;
 	struct hlist_head muxed_ep[RMNET_MAX_LOGICAL_EP];
 	struct net_device *bridge_ep;
+	struct net_device *rmnet_dev;
 };
 
 extern struct rtnl_link_ops rmnet_link_ops;
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
index 509dfc895a33e..26ad40f19c64c 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
@@ -266,14 +266,6 @@ int rmnet_vnd_dellink(u8 id, struct rmnet_port *port,
 	return 0;
 }
 
-u8 rmnet_vnd_get_mux(struct net_device *rmnet_dev)
-{
-	struct rmnet_priv *priv;
-
-	priv = netdev_priv(rmnet_dev);
-	return priv->mux_id;
-}
-
 int rmnet_vnd_do_flow_control(struct net_device *rmnet_dev, int enable)
 {
 	netdev_dbg(rmnet_dev, "Setting VND TX queue state to %d\n", enable);
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.h b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.h
index 54cbaf3c3bc43..14d77c709d4ad 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.h
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.h
@@ -16,6 +16,5 @@ int rmnet_vnd_dellink(u8 id, struct rmnet_port *port,
 		      struct rmnet_endpoint *ep);
 void rmnet_vnd_rx_fixup(struct sk_buff *skb, struct net_device *dev);
 void rmnet_vnd_tx_fixup(struct sk_buff *skb, struct net_device *dev);
-u8 rmnet_vnd_get_mux(struct net_device *rmnet_dev);
 void rmnet_vnd_setup(struct net_device *dev);
 #endif /* _RMNET_VND_H_ */
-- 
2.20.1



