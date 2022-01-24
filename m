Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 587CB497E80
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 13:09:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238171AbiAXMJW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 07:09:22 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34480 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238134AbiAXMJV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 07:09:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DC610B80EFA
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 12:09:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBF26C340E1;
        Mon, 24 Jan 2022 12:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643026159;
        bh=v3kttT/BRwIbQp+8AV2QG1ExUjjtohhvXr67VoflewA=;
        h=Subject:To:Cc:From:Date:From;
        b=wbf+L3N4G43NUI+jwEYkRLRlUx4FekVdUFj3ycJI7eBa2PaQnxBo/pTRfqhLRWmBi
         MBLhuaeFKhQts7pik4WTvQJdkIwza/FACjMXtDNpMVrjrBDPfa2fo9/EbOnsGHr06H
         IRx1ozLUh+fL11iXF/ZLXWPT4IFwB6TLTxI7pHCE=
Subject: FAILED: patch "[PATCH] ipv4: avoid quadratic behavior in netns dismantle" failed to apply to 4.4-stable tree
To:     edumazet@google.com, dsahern@kernel.org, kuba@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 24 Jan 2022 13:09:16 +0100
Message-ID: <16430261561186@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d07418afea8f1d9896aaf9dc5ae47ac4f45b220c Mon Sep 17 00:00:00 2001
From: Eric Dumazet <edumazet@google.com>
Date: Wed, 19 Jan 2022 02:04:12 -0800
Subject: [PATCH] ipv4: avoid quadratic behavior in netns dismantle

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

diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 45619c005b8d..9813949da104 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -29,6 +29,7 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/netlink.h>
+#include <linux/hash.h>
 
 #include <net/arp.h>
 #include <net/ip.h>
@@ -319,11 +320,15 @@ static inline int nh_comp(struct fib_info *fi, struct fib_info *ofi)
 
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
@@ -433,12 +438,11 @@ int ip_fib_check_default(__be32 gw, struct net_device *dev)
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
@@ -1609,12 +1613,10 @@ struct fib_info *fib_create_info(struct fib_config *cfg,
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
@@ -1966,8 +1968,7 @@ void fib_nhc_update_mtu(struct fib_nh_common *nhc, u32 new, u32 orig)
 
 void fib_sync_mtu(struct net_device *dev, u32 orig_mtu)
 {
-	unsigned int hash = fib_devindex_hashfn(dev->ifindex);
-	struct hlist_head *head = &fib_info_devhash[hash];
+	struct hlist_head *head = fib_info_devhash_bucket(dev);
 	struct fib_nh *nh;
 
 	hlist_for_each_entry(nh, head, nh_hash) {
@@ -1986,12 +1987,11 @@ void fib_sync_mtu(struct net_device *dev, u32 orig_mtu)
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
@@ -2136,7 +2136,6 @@ static void fib_select_default(const struct flowi4 *flp, struct fib_result *res)
 int fib_sync_up(struct net_device *dev, unsigned char nh_flags)
 {
 	struct fib_info *prev_fi;
-	unsigned int hash;
 	struct hlist_head *head;
 	struct fib_nh *nh;
 	int ret;
@@ -2152,8 +2151,7 @@ int fib_sync_up(struct net_device *dev, unsigned char nh_flags)
 	}
 
 	prev_fi = NULL;
-	hash = fib_devindex_hashfn(dev->ifindex);
-	head = &fib_info_devhash[hash];
+	head = fib_info_devhash_bucket(dev);
 	ret = 0;
 
 	hlist_for_each_entry(nh, head, nh_hash) {

