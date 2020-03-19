Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E69F18B59B
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:20:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729090AbgCSNUB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:20:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:43730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729928AbgCSNT7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:19:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A98EE2098B;
        Thu, 19 Mar 2020 13:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623999;
        bh=s/aWU81kmKonMJeapYLf3B9Cp6+KRpzFqJtyzhSiF/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VipqDZru0iafifTIFjlypwW8JCv6gibBheVkIvt7V9a1x+1XdIQT5M+JOba5awqSI
         YU57aS1oYMTptqmi84//sTqPWavF1K6Pc7S959Lp6clBVwPShBV2/ga3KvERLcjcCW
         8t7ojIowBYLnqCdqdGMygqFHKvH353n8eMWOcnro=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 24/48] net: rmnet: fix suspicious RCU usage
Date:   Thu, 19 Mar 2020 14:04:06 +0100
Message-Id: <20200319123910.684951942@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123902.941451241@linuxfoundation.org>
References: <20200319123902.941451241@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit 102210f7664442d8c0ce332c006ea90626df745b ]

rmnet_get_port() internally calls rcu_dereference_rtnl(),
which checks RTNL.
But rmnet_get_port() could be called by packet path.
The packet path is not protected by RTNL.
So, the suspicious RCU usage problem occurs.

Test commands:
    modprobe rmnet
    ip netns add nst
    ip link add veth0 type veth peer name veth1
    ip link set veth1 netns nst
    ip link add rmnet0 link veth0 type rmnet mux_id 1
    ip netns exec nst ip link add rmnet1 link veth1 type rmnet mux_id 1
    ip netns exec nst ip link set veth1 up
    ip netns exec nst ip link set rmnet1 up
    ip netns exec nst ip a a 192.168.100.2/24 dev rmnet1
    ip link set veth0 up
    ip link set rmnet0 up
    ip a a 192.168.100.1/24 dev rmnet0
    ping 192.168.100.2

Splat looks like:
[  146.630958][ T1174] WARNING: suspicious RCU usage
[  146.631735][ T1174] 5.6.0-rc1+ #447 Not tainted
[  146.632387][ T1174] -----------------------------
[  146.633151][ T1174] drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c:386 suspicious rcu_dereference_check() !
[  146.634742][ T1174]
[  146.634742][ T1174] other info that might help us debug this:
[  146.634742][ T1174]
[  146.645992][ T1174]
[  146.645992][ T1174] rcu_scheduler_active = 2, debug_locks = 1
[  146.646937][ T1174] 5 locks held by ping/1174:
[  146.647609][ T1174]  #0: ffff8880c31dea70 (sk_lock-AF_INET){+.+.}, at: raw_sendmsg+0xab8/0x2980
[  146.662463][ T1174]  #1: ffffffff93925660 (rcu_read_lock_bh){....}, at: ip_finish_output2+0x243/0x2150
[  146.671696][ T1174]  #2: ffffffff93925660 (rcu_read_lock_bh){....}, at: __dev_queue_xmit+0x213/0x2940
[  146.673064][ T1174]  #3: ffff8880c19ecd58 (&dev->qdisc_running_key#7){+...}, at: ip_finish_output2+0x714/0x2150
[  146.690358][ T1174]  #4: ffff8880c5796898 (&dev->qdisc_xmit_lock_key#3){+.-.}, at: sch_direct_xmit+0x1e2/0x1020
[  146.699875][ T1174]
[  146.699875][ T1174] stack backtrace:
[  146.701091][ T1174] CPU: 0 PID: 1174 Comm: ping Not tainted 5.6.0-rc1+ #447
[  146.705215][ T1174] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[  146.706565][ T1174] Call Trace:
[  146.707102][ T1174]  dump_stack+0x96/0xdb
[  146.708007][ T1174]  rmnet_get_port.part.9+0x76/0x80 [rmnet]
[  146.709233][ T1174]  rmnet_egress_handler+0x107/0x420 [rmnet]
[  146.710492][ T1174]  ? sch_direct_xmit+0x1e2/0x1020
[  146.716193][ T1174]  rmnet_vnd_start_xmit+0x3d/0xa0 [rmnet]
[  146.717012][ T1174]  dev_hard_start_xmit+0x160/0x740
[  146.717854][ T1174]  sch_direct_xmit+0x265/0x1020
[  146.718577][ T1174]  ? register_lock_class+0x14d0/0x14d0
[  146.719429][ T1174]  ? dev_watchdog+0xac0/0xac0
[  146.723738][ T1174]  ? __dev_queue_xmit+0x15fd/0x2940
[  146.724469][ T1174]  ? lock_acquire+0x164/0x3b0
[  146.725172][ T1174]  __dev_queue_xmit+0x20c7/0x2940
[ ... ]

Fixes: ceed73a2cf4a ("drivers: net: ethernet: qualcomm: rmnet: Initial implementation")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c  | 13 ++++++-------
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h  |  2 +-
 .../net/ethernet/qualcomm/rmnet/rmnet_handlers.c    |  4 ++--
 3 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
index ad46f5aadc0ab..915165cda996f 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
@@ -391,11 +391,10 @@ struct rtnl_link_ops rmnet_link_ops __read_mostly = {
 	.fill_info	= rmnet_fill_info,
 };
 
-/* Needs either rcu_read_lock() or rtnl lock */
-struct rmnet_port *rmnet_get_port(struct net_device *real_dev)
+struct rmnet_port *rmnet_get_port_rcu(struct net_device *real_dev)
 {
 	if (rmnet_is_real_dev_registered(real_dev))
-		return rcu_dereference_rtnl(real_dev->rx_handler_data);
+		return rcu_dereference_bh(real_dev->rx_handler_data);
 	else
 		return NULL;
 }
@@ -421,7 +420,7 @@ int rmnet_add_bridge(struct net_device *rmnet_dev,
 	struct rmnet_port *port, *slave_port;
 	int err;
 
-	port = rmnet_get_port(real_dev);
+	port = rmnet_get_port_rtnl(real_dev);
 
 	/* If there is more than one rmnet dev attached, its probably being
 	 * used for muxing. Skip the briding in that case
@@ -436,7 +435,7 @@ int rmnet_add_bridge(struct net_device *rmnet_dev,
 	if (err)
 		return -EBUSY;
 
-	slave_port = rmnet_get_port(slave_dev);
+	slave_port = rmnet_get_port_rtnl(slave_dev);
 	slave_port->rmnet_mode = RMNET_EPMODE_BRIDGE;
 	slave_port->bridge_ep = real_dev;
 
@@ -454,11 +453,11 @@ int rmnet_del_bridge(struct net_device *rmnet_dev,
 	struct net_device *real_dev = priv->real_dev;
 	struct rmnet_port *port, *slave_port;
 
-	port = rmnet_get_port(real_dev);
+	port = rmnet_get_port_rtnl(real_dev);
 	port->rmnet_mode = RMNET_EPMODE_VND;
 	port->bridge_ep = NULL;
 
-	slave_port = rmnet_get_port(slave_dev);
+	slave_port = rmnet_get_port_rtnl(slave_dev);
 	rmnet_unregister_real_device(slave_dev, slave_port);
 
 	netdev_dbg(slave_dev, "removed from rmnet as slave\n");
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h
index 34ac45a774e72..6a978f486ce10 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h
@@ -74,7 +74,7 @@ struct rmnet_priv {
 	struct rmnet_priv_stats stats;
 };
 
-struct rmnet_port *rmnet_get_port(struct net_device *real_dev);
+struct rmnet_port *rmnet_get_port_rcu(struct net_device *real_dev);
 struct rmnet_endpoint *rmnet_get_endpoint(struct rmnet_port *port, u8 mux_id);
 int rmnet_add_bridge(struct net_device *rmnet_dev,
 		     struct net_device *slave_dev,
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
index 11167abe5934d..5177d0f24947f 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
@@ -193,7 +193,7 @@ rx_handler_result_t rmnet_rx_handler(struct sk_buff **pskb)
 		return RX_HANDLER_PASS;
 
 	dev = skb->dev;
-	port = rmnet_get_port(dev);
+	port = rmnet_get_port_rcu(dev);
 
 	switch (port->rmnet_mode) {
 	case RMNET_EPMODE_VND:
@@ -226,7 +226,7 @@ void rmnet_egress_handler(struct sk_buff *skb)
 	skb->dev = priv->real_dev;
 	mux_id = priv->mux_id;
 
-	port = rmnet_get_port(skb->dev);
+	port = rmnet_get_port_rcu(skb->dev);
 	if (!port)
 		goto drop;
 
-- 
2.20.1



