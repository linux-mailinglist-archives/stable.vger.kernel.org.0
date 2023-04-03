Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53E336D4AC6
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234159AbjDCOuU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234055AbjDCOuE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:50:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CB6129BC5
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:49:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE23561F84
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:49:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E19B1C433D2;
        Mon,  3 Apr 2023 14:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680533352;
        bh=dUBqWNwaiPeImQrG7Jns7ez82GT05Fkz+laPb8zZckU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cX9btMW46EEBPklsk+f+idfeh+4Ah0wzPIn2rrIptDpS36Mic0PZoH4tkufTP4zg0
         kKnmLgZh7XHxEZIeAFavba5TUvhIvtlwyZdWp/7/BqJPHd12xf90LR5q8e77mgtsJ2
         KvYNJr1qak8O+n5gVP2ZQNemK+SPY97BvhLLgjTQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Simon Horman <simon.horman@corigine.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 120/187] net: dsa: sync unicast and multicast addresses for VLAN filters too
Date:   Mon,  3 Apr 2023 16:09:25 +0200
Message-Id: <20230403140419.912180566@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 64fdc5f341db01200e33105265d4b8450122a82e ]

If certain conditions are met, DSA can install all necessary MAC
addresses on the CPU ports as FDB entries and disable flooding towards
the CPU (we call this RX filtering).

There is one corner case where this does not work.

ip link add br0 type bridge vlan_filtering 1 && ip link set br0 up
ip link set swp0 master br0 && ip link set swp0 up
ip link add link swp0 name swp0.100 type vlan id 100
ip link set swp0.100 up && ip addr add 192.168.100.1/24 dev swp0.100

Traffic through swp0.100 is broken, because the bridge turns on VLAN
filtering in the swp0 port (causing RX packets to be classified to the
FDB database corresponding to the VID from their 802.1Q header), and
although the 8021q module does call dev_uc_add() towards the real
device, that API is VLAN-unaware, so it only contains the MAC address,
not the VID; and DSA's current implementation of ndo_set_rx_mode() is
only for VID 0 (corresponding to FDB entries which are installed in an
FDB database which is only hit when the port is VLAN-unaware).

It's interesting to understand why the bridge does not turn on
IFF_PROMISC for its swp0 bridge port, and it may appear at first glance
that this is a regression caused by the logic in commit 2796d0c648c9
("bridge: Automatically manage port promiscuous mode."). After all,
a bridge port needs to have IFF_PROMISC by its very nature - it needs to
receive and forward frames with a MAC DA different from the bridge
ports' MAC addresses.

While that may be true, when the bridge is VLAN-aware *and* it has a
single port, there is no real reason to enable promiscuity even if that
is an automatic port, with flooding and learning (there is nowhere for
packets to go except to the BR_FDB_LOCAL entries), and this is how the
corner case appears. Adding a second automatic interface to the bridge
would make swp0 promisc as well, and would mask the corner case.

Given the dev_uc_add() / ndo_set_rx_mode() API is what it is (it doesn't
pass a VLAN ID), the only way to address that problem is to install host
FDB entries for the cartesian product of RX filtering MAC addresses and
VLAN RX filters.

Fixes: 7569459a52c9 ("net: dsa: manage flooding on the CPU ports")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20230329151821.745752-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/slave.c | 121 ++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 116 insertions(+), 5 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 6711ddc0a3c7d..df8b16c741a40 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -57,6 +57,12 @@ struct dsa_standalone_event_work {
 	u16 vid;
 };
 
+struct dsa_host_vlan_rx_filtering_ctx {
+	struct net_device *dev;
+	const unsigned char *addr;
+	enum dsa_standalone_event event;
+};
+
 static bool dsa_switch_supports_uc_filtering(struct dsa_switch *ds)
 {
 	return ds->ops->port_fdb_add && ds->ops->port_fdb_del &&
@@ -155,18 +161,37 @@ static int dsa_slave_schedule_standalone_work(struct net_device *dev,
 	return 0;
 }
 
+static int dsa_slave_host_vlan_rx_filtering(struct net_device *vdev, int vid,
+					    void *arg)
+{
+	struct dsa_host_vlan_rx_filtering_ctx *ctx = arg;
+
+	return dsa_slave_schedule_standalone_work(ctx->dev, ctx->event,
+						  ctx->addr, vid);
+}
+
 static int dsa_slave_sync_uc(struct net_device *dev,
 			     const unsigned char *addr)
 {
 	struct net_device *master = dsa_slave_to_master(dev);
 	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_host_vlan_rx_filtering_ctx ctx = {
+		.dev = dev,
+		.addr = addr,
+		.event = DSA_UC_ADD,
+	};
+	int err;
 
 	dev_uc_add(master, addr);
 
 	if (!dsa_switch_supports_uc_filtering(dp->ds))
 		return 0;
 
-	return dsa_slave_schedule_standalone_work(dev, DSA_UC_ADD, addr, 0);
+	err = dsa_slave_schedule_standalone_work(dev, DSA_UC_ADD, addr, 0);
+	if (err)
+		return err;
+
+	return vlan_for_each(dev, dsa_slave_host_vlan_rx_filtering, &ctx);
 }
 
 static int dsa_slave_unsync_uc(struct net_device *dev,
@@ -174,13 +199,23 @@ static int dsa_slave_unsync_uc(struct net_device *dev,
 {
 	struct net_device *master = dsa_slave_to_master(dev);
 	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_host_vlan_rx_filtering_ctx ctx = {
+		.dev = dev,
+		.addr = addr,
+		.event = DSA_UC_DEL,
+	};
+	int err;
 
 	dev_uc_del(master, addr);
 
 	if (!dsa_switch_supports_uc_filtering(dp->ds))
 		return 0;
 
-	return dsa_slave_schedule_standalone_work(dev, DSA_UC_DEL, addr, 0);
+	err = dsa_slave_schedule_standalone_work(dev, DSA_UC_DEL, addr, 0);
+	if (err)
+		return err;
+
+	return vlan_for_each(dev, dsa_slave_host_vlan_rx_filtering, &ctx);
 }
 
 static int dsa_slave_sync_mc(struct net_device *dev,
@@ -188,13 +223,23 @@ static int dsa_slave_sync_mc(struct net_device *dev,
 {
 	struct net_device *master = dsa_slave_to_master(dev);
 	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_host_vlan_rx_filtering_ctx ctx = {
+		.dev = dev,
+		.addr = addr,
+		.event = DSA_MC_ADD,
+	};
+	int err;
 
 	dev_mc_add(master, addr);
 
 	if (!dsa_switch_supports_mc_filtering(dp->ds))
 		return 0;
 
-	return dsa_slave_schedule_standalone_work(dev, DSA_MC_ADD, addr, 0);
+	err = dsa_slave_schedule_standalone_work(dev, DSA_MC_ADD, addr, 0);
+	if (err)
+		return err;
+
+	return vlan_for_each(dev, dsa_slave_host_vlan_rx_filtering, &ctx);
 }
 
 static int dsa_slave_unsync_mc(struct net_device *dev,
@@ -202,13 +247,23 @@ static int dsa_slave_unsync_mc(struct net_device *dev,
 {
 	struct net_device *master = dsa_slave_to_master(dev);
 	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_host_vlan_rx_filtering_ctx ctx = {
+		.dev = dev,
+		.addr = addr,
+		.event = DSA_MC_DEL,
+	};
+	int err;
 
 	dev_mc_del(master, addr);
 
 	if (!dsa_switch_supports_mc_filtering(dp->ds))
 		return 0;
 
-	return dsa_slave_schedule_standalone_work(dev, DSA_MC_DEL, addr, 0);
+	err = dsa_slave_schedule_standalone_work(dev, DSA_MC_DEL, addr, 0);
+	if (err)
+		return err;
+
+	return vlan_for_each(dev, dsa_slave_host_vlan_rx_filtering, &ctx);
 }
 
 void dsa_slave_sync_ha(struct net_device *dev)
@@ -1668,6 +1723,8 @@ static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
 		.flags = 0,
 	};
 	struct netlink_ext_ack extack = {0};
+	struct dsa_switch *ds = dp->ds;
+	struct netdev_hw_addr *ha;
 	int ret;
 
 	/* User port... */
@@ -1687,6 +1744,30 @@ static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
 		return ret;
 	}
 
+	if (!dsa_switch_supports_uc_filtering(ds) &&
+	    !dsa_switch_supports_mc_filtering(ds))
+		return 0;
+
+	netif_addr_lock_bh(dev);
+
+	if (dsa_switch_supports_mc_filtering(ds)) {
+		netdev_for_each_synced_mc_addr(ha, dev) {
+			dsa_slave_schedule_standalone_work(dev, DSA_MC_ADD,
+							   ha->addr, vid);
+		}
+	}
+
+	if (dsa_switch_supports_uc_filtering(ds)) {
+		netdev_for_each_synced_uc_addr(ha, dev) {
+			dsa_slave_schedule_standalone_work(dev, DSA_UC_ADD,
+							   ha->addr, vid);
+		}
+	}
+
+	netif_addr_unlock_bh(dev);
+
+	dsa_flush_workqueue();
+
 	return 0;
 }
 
@@ -1699,13 +1780,43 @@ static int dsa_slave_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
 		/* This API only allows programming tagged, non-PVID VIDs */
 		.flags = 0,
 	};
+	struct dsa_switch *ds = dp->ds;
+	struct netdev_hw_addr *ha;
 	int err;
 
 	err = dsa_port_vlan_del(dp, &vlan);
 	if (err)
 		return err;
 
-	return dsa_port_host_vlan_del(dp, &vlan);
+	err = dsa_port_host_vlan_del(dp, &vlan);
+	if (err)
+		return err;
+
+	if (!dsa_switch_supports_uc_filtering(ds) &&
+	    !dsa_switch_supports_mc_filtering(ds))
+		return 0;
+
+	netif_addr_lock_bh(dev);
+
+	if (dsa_switch_supports_mc_filtering(ds)) {
+		netdev_for_each_synced_mc_addr(ha, dev) {
+			dsa_slave_schedule_standalone_work(dev, DSA_MC_DEL,
+							   ha->addr, vid);
+		}
+	}
+
+	if (dsa_switch_supports_uc_filtering(ds)) {
+		netdev_for_each_synced_uc_addr(ha, dev) {
+			dsa_slave_schedule_standalone_work(dev, DSA_UC_DEL,
+							   ha->addr, vid);
+		}
+	}
+
+	netif_addr_unlock_bh(dev);
+
+	dsa_flush_workqueue();
+
+	return 0;
 }
 
 static int dsa_slave_restore_vlan(struct net_device *vdev, int vid, void *arg)
-- 
2.39.2



