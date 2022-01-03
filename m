Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 577D848336C
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:36:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235138AbiACOgj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:36:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235333AbiACOeN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:34:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 726EDC06179C;
        Mon,  3 Jan 2022 06:32:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 141C26112C;
        Mon,  3 Jan 2022 14:32:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF143C36AEF;
        Mon,  3 Jan 2022 14:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641220356;
        bh=Cm/hIgRC/2xkCq4XLFYvdL+ocYtjwvSGeKGicvWAXME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r5kuwKmaAHVpFIdZcXRCOju6z3NxX+I212hG2a9b/kEfUcXThE7r39jIpIkPR9LKd
         9ybuqWIdA728XpxlBuLhXKZa6xn5RP5hs1dst5WBBgmHsHIsRI3LBeLllQnPV0dSQ2
         F4DdnI0EgblsAELUqJbkoDErizSnd0RASN4s1GN0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 44/73] net: bridge: mcast: add and enforce startup query interval minimum
Date:   Mon,  3 Jan 2022 15:24:05 +0100
Message-Id: <20220103142058.342545441@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142056.911344037@linuxfoundation.org>
References: <20220103142056.911344037@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

[ Upstream commit f83a112bd91a494cdee671aec74e777470fb4a07 ]

As reported[1] if startup query interval is set too low in combination with
large number of startup queries and we have multiple bridges or even a
single bridge with multiple querier vlans configured we can crash the
machine. Add a 1 second minimum which must be enforced by overwriting the
value if set lower (i.e. without returning an error) to avoid breaking
user-space. If that happens a log message is emitted to let the admin know
that the startup interval has been set to the minimum. It doesn't make
sense to make the startup interval lower than the normal query interval
so use the same value of 1 second. The issue has been present since these
intervals could be user-controlled.

[1] https://lore.kernel.org/netdev/e8b9ce41-57b9-b6e2-a46a-ff9c791cf0ba@gmail.com/

Fixes: d902eee43f19 ("bridge: Add multicast count/interval sysfs entries")
Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_multicast.c    | 16 ++++++++++++++++
 net/bridge/br_netlink.c      |  2 +-
 net/bridge/br_private.h      |  3 +++
 net/bridge/br_sysfs_br.c     |  2 +-
 net/bridge/br_vlan_options.c |  2 +-
 5 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 998da4a2d2092..de24098894897 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -4538,6 +4538,22 @@ void br_multicast_set_query_intvl(struct net_bridge_mcast *brmctx,
 	brmctx->multicast_query_interval = intvl_jiffies;
 }
 
+void br_multicast_set_startup_query_intvl(struct net_bridge_mcast *brmctx,
+					  unsigned long val)
+{
+	unsigned long intvl_jiffies = clock_t_to_jiffies(val);
+
+	if (intvl_jiffies < BR_MULTICAST_STARTUP_QUERY_INTVL_MIN) {
+		br_info(brmctx->br,
+			"trying to set multicast startup query interval below minimum, setting to %lu (%ums)\n",
+			jiffies_to_clock_t(BR_MULTICAST_STARTUP_QUERY_INTVL_MIN),
+			jiffies_to_msecs(BR_MULTICAST_STARTUP_QUERY_INTVL_MIN));
+		intvl_jiffies = BR_MULTICAST_STARTUP_QUERY_INTVL_MIN;
+	}
+
+	brmctx->multicast_startup_query_interval = intvl_jiffies;
+}
+
 /**
  * br_multicast_list_adjacent - Returns snooped multicast addresses
  * @dev:	The bridge port adjacent to which to retrieve addresses
diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 09812df3bc91d..e365cf82f0615 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -1369,7 +1369,7 @@ static int br_changelink(struct net_device *brdev, struct nlattr *tb[],
 	if (data[IFLA_BR_MCAST_STARTUP_QUERY_INTVL]) {
 		u64 val = nla_get_u64(data[IFLA_BR_MCAST_STARTUP_QUERY_INTVL]);
 
-		br->multicast_ctx.multicast_startup_query_interval = clock_t_to_jiffies(val);
+		br_multicast_set_startup_query_intvl(&br->multicast_ctx, val);
 	}
 
 	if (data[IFLA_BR_MCAST_STATS_ENABLED]) {
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 30c9411bfb646..5951e3142fe94 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -29,6 +29,7 @@
 
 #define BR_MULTICAST_DEFAULT_HASH_MAX 4096
 #define BR_MULTICAST_QUERY_INTVL_MIN msecs_to_jiffies(1000)
+#define BR_MULTICAST_STARTUP_QUERY_INTVL_MIN BR_MULTICAST_QUERY_INTVL_MIN
 
 #define BR_HWDOM_MAX BITS_PER_LONG
 
@@ -971,6 +972,8 @@ size_t br_multicast_querier_state_size(void);
 size_t br_rports_size(const struct net_bridge_mcast *brmctx);
 void br_multicast_set_query_intvl(struct net_bridge_mcast *brmctx,
 				  unsigned long val);
+void br_multicast_set_startup_query_intvl(struct net_bridge_mcast *brmctx,
+					  unsigned long val);
 
 static inline bool br_group_is_l2(const struct br_ip *group)
 {
diff --git a/net/bridge/br_sysfs_br.c b/net/bridge/br_sysfs_br.c
index f5bd1114a434d..7b0c19772111c 100644
--- a/net/bridge/br_sysfs_br.c
+++ b/net/bridge/br_sysfs_br.c
@@ -706,7 +706,7 @@ static ssize_t multicast_startup_query_interval_show(
 static int set_startup_query_interval(struct net_bridge *br, unsigned long val,
 				      struct netlink_ext_ack *extack)
 {
-	br->multicast_ctx.multicast_startup_query_interval = clock_t_to_jiffies(val);
+	br_multicast_set_startup_query_intvl(&br->multicast_ctx, val);
 	return 0;
 }
 
diff --git a/net/bridge/br_vlan_options.c b/net/bridge/br_vlan_options.c
index bf1ac08742794..a6382973b3e70 100644
--- a/net/bridge/br_vlan_options.c
+++ b/net/bridge/br_vlan_options.c
@@ -535,7 +535,7 @@ static int br_vlan_process_global_one_opts(const struct net_bridge *br,
 		u64 val;
 
 		val = nla_get_u64(tb[BRIDGE_VLANDB_GOPTS_MCAST_STARTUP_QUERY_INTVL]);
-		v->br_mcast_ctx.multicast_startup_query_interval = clock_t_to_jiffies(val);
+		br_multicast_set_startup_query_intvl(&v->br_mcast_ctx, val);
 		*changed = true;
 	}
 	if (tb[BRIDGE_VLANDB_GOPTS_MCAST_QUERIER]) {
-- 
2.34.1



