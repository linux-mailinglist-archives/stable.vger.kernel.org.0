Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2B471CAB7F
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:44:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729153AbgEHMoK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:44:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:42280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729145AbgEHMoG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:44:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73E8821473;
        Fri,  8 May 2020 12:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941844;
        bh=fJBfXKkqHa4pDVN/5kqG9euhjFO+AtPzVtwvh88wXeY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZeIee6Pnqup3Ul+OS54TjHWlL7bqWEwtIdiKKfKRufU61THmbH2h7zS7olyPoBH6X
         kj/EGEJuRx2WMtkLPh++dIq3ZhAwLWPSpWQNS9fXwKpJzaewYmuAQI4J2h879BL3b+
         jHUO/SZj/g0Mq7aIQA6U91KIOIc2+X/7Uxa3HtfA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Ahern <dsa@cumulusnetworks.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 196/312] net: ipv6: Fix processing of RAs in presence of VRF
Date:   Fri,  8 May 2020 14:33:07 +0200
Message-Id: <20200508123138.226850460@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Ahern <dsa@cumulusnetworks.com>

commit 830218c1add1da16519b71909e5cf21522b7d062 upstream.

rt6_add_route_info and rt6_add_dflt_router were updated to pull the FIB
table from the device index, but the corresponding rt6_get_route_info
and rt6_get_dflt_router functions were not leading to the failure to
process RA's:

    ICMPv6: RA: ndisc_router_discovery failed to add default route

Fix the 'get' functions by using the table id associated with the
device when applicable.

Also, now that default routes can be added to tables other than the
default table, rt6_purge_dflt_routers needs to be updated as well to
look at all tables. To handle that efficiently, add a flag to the table
denoting if it is has a default route via RA.

Fixes: ca254490c8dfd ("net: Add VRF support to IPv6 stack")
Signed-off-by: David Ahern <dsa@cumulusnetworks.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/net/ip6_fib.h |    2 +
 net/ipv6/route.c      |   68 +++++++++++++++++++++++++++++++++++---------------
 2 files changed, 50 insertions(+), 20 deletions(-)

--- a/include/net/ip6_fib.h
+++ b/include/net/ip6_fib.h
@@ -258,6 +258,8 @@ struct fib6_table {
 	rwlock_t		tb6_lock;
 	struct fib6_node	tb6_root;
 	struct inet_peer_base	tb6_peers;
+	unsigned int		flags;
+#define RT6_TABLE_HAS_DFLT_ROUTER	BIT(0)
 };
 
 #define RT6_TABLE_UNSPEC	RT_TABLE_UNSPEC
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -101,11 +101,13 @@ static int rt6_score_route(struct rt6_in
 #ifdef CONFIG_IPV6_ROUTE_INFO
 static struct rt6_info *rt6_add_route_info(struct net *net,
 					   const struct in6_addr *prefix, int prefixlen,
-					   const struct in6_addr *gwaddr, int ifindex,
+					   const struct in6_addr *gwaddr,
+					   struct net_device *dev,
 					   unsigned int pref);
 static struct rt6_info *rt6_get_route_info(struct net *net,
 					   const struct in6_addr *prefix, int prefixlen,
-					   const struct in6_addr *gwaddr, int ifindex);
+					   const struct in6_addr *gwaddr,
+					   struct net_device *dev);
 #endif
 
 struct uncached_list {
@@ -801,7 +803,7 @@ int rt6_route_rcv(struct net_device *dev
 		rt = rt6_get_dflt_router(gwaddr, dev);
 	else
 		rt = rt6_get_route_info(net, prefix, rinfo->prefix_len,
-					gwaddr, dev->ifindex);
+					gwaddr, dev);
 
 	if (rt && !lifetime) {
 		ip6_del_rt(rt);
@@ -809,8 +811,8 @@ int rt6_route_rcv(struct net_device *dev
 	}
 
 	if (!rt && lifetime)
-		rt = rt6_add_route_info(net, prefix, rinfo->prefix_len, gwaddr, dev->ifindex,
-					pref);
+		rt = rt6_add_route_info(net, prefix, rinfo->prefix_len, gwaddr,
+					dev, pref);
 	else if (rt)
 		rt->rt6i_flags = RTF_ROUTEINFO |
 				 (rt->rt6i_flags & ~RTF_PREF_MASK) | RTF_PREF(pref);
@@ -2273,13 +2275,16 @@ static void ip6_rt_copy_init(struct rt6_
 #ifdef CONFIG_IPV6_ROUTE_INFO
 static struct rt6_info *rt6_get_route_info(struct net *net,
 					   const struct in6_addr *prefix, int prefixlen,
-					   const struct in6_addr *gwaddr, int ifindex)
+					   const struct in6_addr *gwaddr,
+					   struct net_device *dev)
 {
+	u32 tb_id = l3mdev_fib_table(dev) ? : RT6_TABLE_INFO;
+	int ifindex = dev->ifindex;
 	struct fib6_node *fn;
 	struct rt6_info *rt = NULL;
 	struct fib6_table *table;
 
-	table = fib6_get_table(net, RT6_TABLE_INFO);
+	table = fib6_get_table(net, tb_id);
 	if (!table)
 		return NULL;
 
@@ -2305,12 +2310,13 @@ out:
 
 static struct rt6_info *rt6_add_route_info(struct net *net,
 					   const struct in6_addr *prefix, int prefixlen,
-					   const struct in6_addr *gwaddr, int ifindex,
+					   const struct in6_addr *gwaddr,
+					   struct net_device *dev,
 					   unsigned int pref)
 {
 	struct fib6_config cfg = {
 		.fc_metric	= IP6_RT_PRIO_USER,
-		.fc_ifindex	= ifindex,
+		.fc_ifindex	= dev->ifindex,
 		.fc_dst_len	= prefixlen,
 		.fc_flags	= RTF_GATEWAY | RTF_ADDRCONF | RTF_ROUTEINFO |
 				  RTF_UP | RTF_PREF(pref),
@@ -2319,7 +2325,7 @@ static struct rt6_info *rt6_add_route_in
 		.fc_nlinfo.nl_net = net,
 	};
 
-	cfg.fc_table = l3mdev_fib_table_by_index(net, ifindex) ? : RT6_TABLE_INFO;
+	cfg.fc_table = l3mdev_fib_table(dev) ? : RT6_TABLE_INFO,
 	cfg.fc_dst = *prefix;
 	cfg.fc_gateway = *gwaddr;
 
@@ -2329,16 +2335,17 @@ static struct rt6_info *rt6_add_route_in
 
 	ip6_route_add(&cfg);
 
-	return rt6_get_route_info(net, prefix, prefixlen, gwaddr, ifindex);
+	return rt6_get_route_info(net, prefix, prefixlen, gwaddr, dev);
 }
 #endif
 
 struct rt6_info *rt6_get_dflt_router(const struct in6_addr *addr, struct net_device *dev)
 {
+	u32 tb_id = l3mdev_fib_table(dev) ? : RT6_TABLE_DFLT;
 	struct rt6_info *rt;
 	struct fib6_table *table;
 
-	table = fib6_get_table(dev_net(dev), RT6_TABLE_DFLT);
+	table = fib6_get_table(dev_net(dev), tb_id);
 	if (!table)
 		return NULL;
 
@@ -2372,20 +2379,20 @@ struct rt6_info *rt6_add_dflt_router(con
 
 	cfg.fc_gateway = *gwaddr;
 
-	ip6_route_add(&cfg);
+	if (!ip6_route_add(&cfg)) {
+		struct fib6_table *table;
+
+		table = fib6_get_table(dev_net(dev), cfg.fc_table);
+		if (table)
+			table->flags |= RT6_TABLE_HAS_DFLT_ROUTER;
+	}
 
 	return rt6_get_dflt_router(gwaddr, dev);
 }
 
-void rt6_purge_dflt_routers(struct net *net)
+static void __rt6_purge_dflt_routers(struct fib6_table *table)
 {
 	struct rt6_info *rt;
-	struct fib6_table *table;
-
-	/* NOTE: Keep consistent with rt6_get_dflt_router */
-	table = fib6_get_table(net, RT6_TABLE_DFLT);
-	if (!table)
-		return;
 
 restart:
 	read_lock_bh(&table->tb6_lock);
@@ -2399,6 +2406,27 @@ restart:
 		}
 	}
 	read_unlock_bh(&table->tb6_lock);
+
+	table->flags &= ~RT6_TABLE_HAS_DFLT_ROUTER;
+}
+
+void rt6_purge_dflt_routers(struct net *net)
+{
+	struct fib6_table *table;
+	struct hlist_head *head;
+	unsigned int h;
+
+	rcu_read_lock();
+
+	for (h = 0; h < FIB6_TABLE_HASHSZ; h++) {
+		head = &net->ipv6.fib_table_hash[h];
+		hlist_for_each_entry_rcu(table, head, tb6_hlist) {
+			if (table->flags & RT6_TABLE_HAS_DFLT_ROUTER)
+				__rt6_purge_dflt_routers(table);
+		}
+	}
+
+	rcu_read_unlock();
 }
 
 static void rtmsg_to_fib6_config(struct net *net,


