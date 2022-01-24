Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A748499585
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:13:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442061AbiAXUwm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:52:42 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:46934 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391735AbiAXUs3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:48:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61909B81063;
        Mon, 24 Jan 2022 20:48:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C188C340E7;
        Mon, 24 Jan 2022 20:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057307;
        bh=JR+CIPlwPm4CxYIFpJ+ZR7WBCsiaKJG3Bzl/6RlkOPU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GyNXFN6JzRS8Hf6Xw2XtfwYP47030+v8kRAEEJC2OzzyTJVF3ETG3mlJskods00wU
         F9nM8bZaz4tsl0bRWf+tP8g3athsOIV4gTEJopJaxRZ7TKsrtvsLpqKdSWmPf0L5Fn
         UDl9DiPDucy4k9a/wfw/VgulZP7HpsTW1CBFvQJo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 770/846] ipv4: avoid quadratic behavior in netns dismantle
Date:   Mon, 24 Jan 2022 19:44:47 +0100
Message-Id: <20220124184127.525290585@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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
@@ -319,11 +320,15 @@ static inline int nh_comp(struct fib_inf
 
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
@@ -433,12 +438,11 @@ int ip_fib_check_default(__be32 gw, stru
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
@@ -1607,12 +1611,10 @@ link_it:
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
@@ -1964,8 +1966,7 @@ void fib_nhc_update_mtu(struct fib_nh_co
 
 void fib_sync_mtu(struct net_device *dev, u32 orig_mtu)
 {
-	unsigned int hash = fib_devindex_hashfn(dev->ifindex);
-	struct hlist_head *head = &fib_info_devhash[hash];
+	struct hlist_head *head = fib_info_devhash_bucket(dev);
 	struct fib_nh *nh;
 
 	hlist_for_each_entry(nh, head, nh_hash) {
@@ -1984,12 +1985,11 @@ void fib_sync_mtu(struct net_device *dev
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
@@ -2134,7 +2134,6 @@ out:
 int fib_sync_up(struct net_device *dev, unsigned char nh_flags)
 {
 	struct fib_info *prev_fi;
-	unsigned int hash;
 	struct hlist_head *head;
 	struct fib_nh *nh;
 	int ret;
@@ -2150,8 +2149,7 @@ int fib_sync_up(struct net_device *dev,
 	}
 
 	prev_fi = NULL;
-	hash = fib_devindex_hashfn(dev->ifindex);
-	head = &fib_info_devhash[hash];
+	head = fib_info_devhash_bucket(dev);
 	ret = 0;
 
 	hlist_for_each_entry(nh, head, nh_hash) {


