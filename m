Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA95649A9EF
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:29:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1323839AbiAYD3p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:29:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376993AbiAXVGc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:06:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 286A7C0613EF;
        Mon, 24 Jan 2022 12:06:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BCB5461324;
        Mon, 24 Jan 2022 20:06:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACF53C340E5;
        Mon, 24 Jan 2022 20:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054807;
        bh=Jw7EEzHPcXAFK0dwyj8V0E54n37YUsAQ5hLgWn8Vm4U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ubHqgzY/uDR7vbxbhgZ/XVNSwfZcddaHOtzgtHBtzi5c1tRcQm3cebnJHxbIa/csq
         LX6ZTp+WjiNgoNWc49qkD8fAJu9+sgcVeIBG4kV3JdDWHJVgJuiVjxTuYP80//buhF
         hIJUheACiANpj0pH9aHnlWTKOaKpvKT/yHC+DiJM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 510/563] ipv4: avoid quadratic behavior in netns dismantle
Date:   Mon, 24 Jan 2022 19:44:35 +0100
Message-Id: <20220124184042.099678760@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit d07418afea8f1d9896aaf9dc5ae47ac4f45b220c upstream.

net/ipv4/fib_semantics.c uses an hash table of 256 slots,
keyed by device ifindexes: fib_info_devhash[DEVINDEX_HASHSIZE]

Problem is that with network namespaces, devices tend
to use the same ifindex.

lo device for instance has a fixed ifindex of one,
for all network namespaces.

This means that hosts with thousands of netns spend
a lot of time looking at some hash buckets with thousands
of elements, notably at netns dismantle.

Simply add a per netns perturbation (net_hash_mix())
to spread elements more uniformely.

Also change fib_devindex_hashfn() to use more entropy.

Fixes: aa79e66eee5d ("net: Make ifindex generation per-net namespace")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/fib_semantics.c |   36 +++++++++++++++++-------------------
 1 file changed, 17 insertions(+), 19 deletions(-)

--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -29,6 +29,7 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/netlink.h>
+#include <linux/hash.h>
 
 #include <net/arp.h>
 #include <net/ip.h>
@@ -321,11 +322,15 @@ static inline int nh_comp(struct fib_inf
 
 static inline unsigned int fib_devindex_hashfn(unsigned int val)
 {
-	unsigned int mask = DEVINDEX_HASHSIZE - 1;
+	return hash_32(val, DEVINDEX_HASHBITS);
+}
+
+static struct hlist_head *
+fib_info_devhash_bucket(const struct net_device *dev)
+{
+	u32 val = net_hash_mix(dev_net(dev)) ^ dev->ifindex;
 
-	return (val ^
-		(val >> DEVINDEX_HASHBITS) ^
-		(val >> (DEVINDEX_HASHBITS * 2))) & mask;
+	return &fib_info_devhash[fib_devindex_hashfn(val)];
 }
 
 static unsigned int fib_info_hashfn_1(int init_val, u8 protocol, u8 scope,
@@ -435,12 +440,11 @@ int ip_fib_check_default(__be32 gw, stru
 {
 	struct hlist_head *head;
 	struct fib_nh *nh;
-	unsigned int hash;
 
 	spin_lock(&fib_info_lock);
 
-	hash = fib_devindex_hashfn(dev->ifindex);
-	head = &fib_info_devhash[hash];
+	head = fib_info_devhash_bucket(dev);
+
 	hlist_for_each_entry(nh, head, nh_hash) {
 		if (nh->fib_nh_dev == dev &&
 		    nh->fib_nh_gw4 == gw &&
@@ -1608,12 +1612,10 @@ link_it:
 	} else {
 		change_nexthops(fi) {
 			struct hlist_head *head;
-			unsigned int hash;
 
 			if (!nexthop_nh->fib_nh_dev)
 				continue;
-			hash = fib_devindex_hashfn(nexthop_nh->fib_nh_dev->ifindex);
-			head = &fib_info_devhash[hash];
+			head = fib_info_devhash_bucket(nexthop_nh->fib_nh_dev);
 			hlist_add_head(&nexthop_nh->nh_hash, head);
 		} endfor_nexthops(fi)
 	}
@@ -1963,8 +1965,7 @@ void fib_nhc_update_mtu(struct fib_nh_co
 
 void fib_sync_mtu(struct net_device *dev, u32 orig_mtu)
 {
-	unsigned int hash = fib_devindex_hashfn(dev->ifindex);
-	struct hlist_head *head = &fib_info_devhash[hash];
+	struct hlist_head *head = fib_info_devhash_bucket(dev);
 	struct fib_nh *nh;
 
 	hlist_for_each_entry(nh, head, nh_hash) {
@@ -1983,12 +1984,11 @@ void fib_sync_mtu(struct net_device *dev
  */
 int fib_sync_down_dev(struct net_device *dev, unsigned long event, bool force)
 {
-	int ret = 0;
-	int scope = RT_SCOPE_NOWHERE;
+	struct hlist_head *head = fib_info_devhash_bucket(dev);
 	struct fib_info *prev_fi = NULL;
-	unsigned int hash = fib_devindex_hashfn(dev->ifindex);
-	struct hlist_head *head = &fib_info_devhash[hash];
+	int scope = RT_SCOPE_NOWHERE;
 	struct fib_nh *nh;
+	int ret = 0;
 
 	if (force)
 		scope = -1;
@@ -2133,7 +2133,6 @@ out:
 int fib_sync_up(struct net_device *dev, unsigned char nh_flags)
 {
 	struct fib_info *prev_fi;
-	unsigned int hash;
 	struct hlist_head *head;
 	struct fib_nh *nh;
 	int ret;
@@ -2149,8 +2148,7 @@ int fib_sync_up(struct net_device *dev,
 	}
 
 	prev_fi = NULL;
-	hash = fib_devindex_hashfn(dev->ifindex);
-	head = &fib_info_devhash[hash];
+	head = fib_info_devhash_bucket(dev);
 	ret = 0;
 
 	hlist_for_each_entry(nh, head, nh_hash) {


