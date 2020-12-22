Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65D162DEFAE
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 14:07:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727554AbgLSM62 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 07:58:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:44848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727533AbgLSM61 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 19 Dec 2020 07:58:27 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joseph Huang <Joseph.Huang@garmin.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 12/49] bridge: Fix a deadlock when enabling multicast snooping
Date:   Sat, 19 Dec 2020 13:58:16 +0100
Message-Id: <20201219125345.277579762@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201219125344.671832095@linuxfoundation.org>
References: <20201219125344.671832095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joseph Huang <Joseph.Huang@garmin.com>

[ Upstream commit 851d0a73c90e6c8c63fef106c6c1e73df7e05d9d ]

When enabling multicast snooping, bridge module deadlocks on multicast_lock
if 1) IPv6 is enabled, and 2) there is an existing querier on the same L2
network.

The deadlock was caused by the following sequence: While holding the lock,
br_multicast_open calls br_multicast_join_snoopers, which eventually causes
IP stack to (attempt to) send out a Listener Report (in igmp6_join_group).
Since the destination Ethernet address is a multicast address, br_dev_xmit
feeds the packet back to the bridge via br_multicast_rcv, which in turn
calls br_multicast_add_group, which then deadlocks on multicast_lock.

The fix is to move the call br_multicast_join_snoopers outside of the
critical section. This works since br_multicast_join_snoopers only deals
with IP and does not modify any multicast data structures of the bridge,
so there's no need to hold the lock.

Steps to reproduce:
1. sysctl net.ipv6.conf.all.force_mld_version=1
2. have another querier
3. ip link set dev bridge type bridge mcast_snooping 0 && \
   ip link set dev bridge type bridge mcast_snooping 1 < deadlock >

A typical call trace looks like the following:

[  936.251495]  _raw_spin_lock+0x5c/0x68
[  936.255221]  br_multicast_add_group+0x40/0x170 [bridge]
[  936.260491]  br_multicast_rcv+0x7ac/0xe30 [bridge]
[  936.265322]  br_dev_xmit+0x140/0x368 [bridge]
[  936.269689]  dev_hard_start_xmit+0x94/0x158
[  936.273876]  __dev_queue_xmit+0x5ac/0x7f8
[  936.277890]  dev_queue_xmit+0x10/0x18
[  936.281563]  neigh_resolve_output+0xec/0x198
[  936.285845]  ip6_finish_output2+0x240/0x710
[  936.290039]  __ip6_finish_output+0x130/0x170
[  936.294318]  ip6_output+0x6c/0x1c8
[  936.297731]  NF_HOOK.constprop.0+0xd8/0xe8
[  936.301834]  igmp6_send+0x358/0x558
[  936.305326]  igmp6_join_group.part.0+0x30/0xf0
[  936.309774]  igmp6_group_added+0xfc/0x110
[  936.313787]  __ipv6_dev_mc_inc+0x1a4/0x290
[  936.317885]  ipv6_dev_mc_inc+0x10/0x18
[  936.321677]  br_multicast_open+0xbc/0x110 [bridge]
[  936.326506]  br_multicast_toggle+0xec/0x140 [bridge]

Fixes: 4effd28c1245 ("bridge: join all-snoopers multicast address")
Signed-off-by: Joseph Huang <Joseph.Huang@garmin.com>
Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>
Link: https://lore.kernel.org/r/20201204235628.50653-1-Joseph.Huang@garmin.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/br_device.c    |    6 ++++++
 net/bridge/br_multicast.c |   34 +++++++++++++++++++++++++---------
 net/bridge/br_private.h   |   10 ++++++++++
 3 files changed, 41 insertions(+), 9 deletions(-)

--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -177,6 +177,9 @@ static int br_dev_open(struct net_device
 	br_stp_enable_bridge(br);
 	br_multicast_open(br);
 
+	if (br_opt_get(br, BROPT_MULTICAST_ENABLED))
+		br_multicast_join_snoopers(br);
+
 	return 0;
 }
 
@@ -197,6 +200,9 @@ static int br_dev_stop(struct net_device
 	br_stp_disable_bridge(br);
 	br_multicast_stop(br);
 
+	if (br_opt_get(br, BROPT_MULTICAST_ENABLED))
+		br_multicast_leave_snoopers(br);
+
 	netif_stop_queue(dev);
 
 	return 0;
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1848,7 +1848,7 @@ static inline void br_ip6_multicast_join
 }
 #endif
 
-static void br_multicast_join_snoopers(struct net_bridge *br)
+void br_multicast_join_snoopers(struct net_bridge *br)
 {
 	br_ip4_multicast_join_snoopers(br);
 	br_ip6_multicast_join_snoopers(br);
@@ -1879,7 +1879,7 @@ static inline void br_ip6_multicast_leav
 }
 #endif
 
-static void br_multicast_leave_snoopers(struct net_bridge *br)
+void br_multicast_leave_snoopers(struct net_bridge *br)
 {
 	br_ip4_multicast_leave_snoopers(br);
 	br_ip6_multicast_leave_snoopers(br);
@@ -1898,9 +1898,6 @@ static void __br_multicast_open(struct n
 
 void br_multicast_open(struct net_bridge *br)
 {
-	if (br_opt_get(br, BROPT_MULTICAST_ENABLED))
-		br_multicast_join_snoopers(br);
-
 	__br_multicast_open(br, &br->ip4_own_query);
 #if IS_ENABLED(CONFIG_IPV6)
 	__br_multicast_open(br, &br->ip6_own_query);
@@ -1916,9 +1913,6 @@ void br_multicast_stop(struct net_bridge
 	del_timer_sync(&br->ip6_other_query.timer);
 	del_timer_sync(&br->ip6_own_query.timer);
 #endif
-
-	if (br_opt_get(br, BROPT_MULTICAST_ENABLED))
-		br_multicast_leave_snoopers(br);
 }
 
 void br_multicast_dev_del(struct net_bridge *br)
@@ -2049,6 +2043,7 @@ static void br_multicast_start_querier(s
 int br_multicast_toggle(struct net_bridge *br, unsigned long val)
 {
 	struct net_bridge_port *port;
+	bool change_snoopers = false;
 
 	spin_lock_bh(&br->multicast_lock);
 	if (!!br_opt_get(br, BROPT_MULTICAST_ENABLED) == !!val)
@@ -2057,7 +2052,7 @@ int br_multicast_toggle(struct net_bridg
 	br_mc_disabled_update(br->dev, val);
 	br_opt_toggle(br, BROPT_MULTICAST_ENABLED, !!val);
 	if (!br_opt_get(br, BROPT_MULTICAST_ENABLED)) {
-		br_multicast_leave_snoopers(br);
+		change_snoopers = true;
 		goto unlock;
 	}
 
@@ -2068,9 +2063,30 @@ int br_multicast_toggle(struct net_bridg
 	list_for_each_entry(port, &br->port_list, list)
 		__br_multicast_enable_port(port);
 
+	change_snoopers = true;
+
 unlock:
 	spin_unlock_bh(&br->multicast_lock);
 
+	/* br_multicast_join_snoopers has the potential to cause
+	 * an MLD Report/Leave to be delivered to br_multicast_rcv,
+	 * which would in turn call br_multicast_add_group, which would
+	 * attempt to acquire multicast_lock. This function should be
+	 * called after the lock has been released to avoid deadlocks on
+	 * multicast_lock.
+	 *
+	 * br_multicast_leave_snoopers does not have the problem since
+	 * br_multicast_rcv first checks BROPT_MULTICAST_ENABLED, and
+	 * returns without calling br_multicast_ipv4/6_rcv if it's not
+	 * enabled. Moved both functions out just for symmetry.
+	 */
+	if (change_snoopers) {
+		if (br_opt_get(br, BROPT_MULTICAST_ENABLED))
+			br_multicast_join_snoopers(br);
+		else
+			br_multicast_leave_snoopers(br);
+	}
+
 	return 0;
 }
 
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -745,6 +745,8 @@ void br_multicast_del_port(struct net_br
 void br_multicast_enable_port(struct net_bridge_port *port);
 void br_multicast_disable_port(struct net_bridge_port *port);
 void br_multicast_init(struct net_bridge *br);
+void br_multicast_join_snoopers(struct net_bridge *br);
+void br_multicast_leave_snoopers(struct net_bridge *br);
 void br_multicast_open(struct net_bridge *br);
 void br_multicast_stop(struct net_bridge *br);
 void br_multicast_dev_del(struct net_bridge *br);
@@ -872,6 +874,14 @@ static inline void br_multicast_init(str
 {
 }
 
+static inline void br_multicast_join_snoopers(struct net_bridge *br)
+{
+}
+
+static inline void br_multicast_leave_snoopers(struct net_bridge *br)
+{
+}
+
 static inline void br_multicast_open(struct net_bridge *br)
 {
 }


