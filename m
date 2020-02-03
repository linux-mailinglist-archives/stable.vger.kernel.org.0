Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A02B150492
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 11:51:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727529AbgBCKvP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 05:51:15 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:46129 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727435AbgBCKvP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Feb 2020 05:51:15 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id D0C1F21533;
        Mon,  3 Feb 2020 05:51:13 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 03 Feb 2020 05:51:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=ruSfHg
        AryQndxIyvc484t7PqFiwk4fD8b/HKbMNMFNo=; b=hpC8mF319dWcYFQ2KUK0JL
        8V4BrqCZ3Eck+jPBVsL2aHfv3ERMHnk6+dYDZzVlx0xycKvJ1p5+3sYiuz56O+D7
        X2NSAC64A6vyHC0cFPfkH6Wy23fo9fdz4A9UobeuJQRx3WQhxbLiFMppvH9pfEwB
        R844uGHK5ACwcYvO6BPw4czl7NhG1wmyRd4msW01cTi8p38sKTVO+07pzQEv1elN
        TbOjpAGsZPkSqPp5mvp582OYfoTdnMlGZ2tO+ZTiSIWmS60tg/Gmbx82kfbWGJUT
        jCqNqd8gaC1wi6VSsHoG1kJC6J+EG5fDsCLDeaQuSYMjPe06RURh1eVh3WXAQ/RA
        ==
X-ME-Sender: <xms:Ifs3Xo6gbVC6jtj45b7BPvsK-pe4VCzziBWH17THhBPvmvWQopjZZA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrgeejgddvtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepuddtgedrudefvddrgeehrdelleenucevlhhushhtvghrufhiiigvpeefne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:Ifs3XhD3cREBCfre7a8beYgIMNo3UpYSpDdszmKVNXFJmuMCT-DHzA>
    <xmx:Ifs3Xpxo1jfWPIyfOsGeZuCYlheU8xbEB6vipwZs84Xkz-tBRswcbg>
    <xmx:Ifs3Xl5VWLlspfM5X7kII5GlP9l97u2X-81W8__hF1ru_Ix2vH5XYw>
    <xmx:Ifs3Xt_1g3L9k0Ztw7Y8SQK01EBgfxu9vEohrQH-osdtj6xslqN7rQ>
Received: from localhost (unknown [104.132.45.99])
        by mail.messagingengine.com (Postfix) with ESMTPA id 834033060134;
        Mon,  3 Feb 2020 05:51:13 -0500 (EST)
Subject: FAILED: patch "[PATCH] netfilter: ipset: use bitmap infrastructure completely" failed to apply to 4.4-stable tree
To:     kadlec@blackhole.kfki.hu, kadlec@netfilter.org, pablo@netfilter.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 03 Feb 2020 10:51:06 +0000
Message-ID: <15807270668581@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 32c72165dbd0e246e69d16a3ad348a4851afd415 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Kadlecsik=20J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>
Date: Sun, 19 Jan 2020 22:06:49 +0100
Subject: [PATCH] netfilter: ipset: use bitmap infrastructure completely

The bitmap allocation did not use full unsigned long sizes
when calculating the required size and that was triggered by KASAN
as slab-out-of-bounds read in several places. The patch fixes all
of them.

Reported-by: syzbot+fabca5cbf5e54f3fe2de@syzkaller.appspotmail.com
Reported-by: syzbot+827ced406c9a1d9570ed@syzkaller.appspotmail.com
Reported-by: syzbot+190d63957b22ef673ea5@syzkaller.appspotmail.com
Reported-by: syzbot+dfccdb2bdb4a12ad425e@syzkaller.appspotmail.com
Reported-by: syzbot+df0d0f5895ef1f41a65b@syzkaller.appspotmail.com
Reported-by: syzbot+b08bd19bb37513357fd4@syzkaller.appspotmail.com
Reported-by: syzbot+53cdd0ec0bbabd53370a@syzkaller.appspotmail.com
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
index 4d8b1eaf7708..908d38dbcb91 100644
--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -426,13 +426,6 @@ ip6addrptr(const struct sk_buff *skb, bool src, struct in6_addr *addr)
 	       sizeof(*addr));
 }
 
-/* Calculate the bytes required to store the inclusive range of a-b */
-static inline int
-bitmap_bytes(u32 a, u32 b)
-{
-	return 4 * ((((b - a + 8) / 8) + 3) / 4);
-}
-
 /* How often should the gc be run by default */
 #define IPSET_GC_TIME			(3 * 60)
 
diff --git a/net/netfilter/ipset/ip_set_bitmap_gen.h b/net/netfilter/ipset/ip_set_bitmap_gen.h
index 077a2cb65fcb..26ab0e9612d8 100644
--- a/net/netfilter/ipset/ip_set_bitmap_gen.h
+++ b/net/netfilter/ipset/ip_set_bitmap_gen.h
@@ -75,7 +75,7 @@ mtype_flush(struct ip_set *set)
 
 	if (set->extensions & IPSET_EXT_DESTROY)
 		mtype_ext_cleanup(set);
-	memset(map->members, 0, map->memsize);
+	bitmap_zero(map->members, map->elements);
 	set->elements = 0;
 	set->ext_size = 0;
 }
diff --git a/net/netfilter/ipset/ip_set_bitmap_ip.c b/net/netfilter/ipset/ip_set_bitmap_ip.c
index abe8f77d7d23..0a2196f59106 100644
--- a/net/netfilter/ipset/ip_set_bitmap_ip.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ip.c
@@ -37,7 +37,7 @@ MODULE_ALIAS("ip_set_bitmap:ip");
 
 /* Type structure */
 struct bitmap_ip {
-	void *members;		/* the set members */
+	unsigned long *members;	/* the set members */
 	u32 first_ip;		/* host byte order, included in range */
 	u32 last_ip;		/* host byte order, included in range */
 	u32 elements;		/* number of max elements in the set */
@@ -220,7 +220,7 @@ init_map_ip(struct ip_set *set, struct bitmap_ip *map,
 	    u32 first_ip, u32 last_ip,
 	    u32 elements, u32 hosts, u8 netmask)
 {
-	map->members = ip_set_alloc(map->memsize);
+	map->members = bitmap_zalloc(elements, GFP_KERNEL | __GFP_NOWARN);
 	if (!map->members)
 		return false;
 	map->first_ip = first_ip;
@@ -322,7 +322,7 @@ bitmap_ip_create(struct net *net, struct ip_set *set, struct nlattr *tb[],
 	if (!map)
 		return -ENOMEM;
 
-	map->memsize = bitmap_bytes(0, elements - 1);
+	map->memsize = BITS_TO_LONGS(elements) * sizeof(unsigned long);
 	set->variant = &bitmap_ip;
 	if (!init_map_ip(set, map, first_ip, last_ip,
 			 elements, hosts, netmask)) {
diff --git a/net/netfilter/ipset/ip_set_bitmap_ipmac.c b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
index b618713297da..739e343efaf6 100644
--- a/net/netfilter/ipset/ip_set_bitmap_ipmac.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
@@ -42,7 +42,7 @@ enum {
 
 /* Type structure */
 struct bitmap_ipmac {
-	void *members;		/* the set members */
+	unsigned long *members;	/* the set members */
 	u32 first_ip;		/* host byte order, included in range */
 	u32 last_ip;		/* host byte order, included in range */
 	u32 elements;		/* number of max elements in the set */
@@ -299,7 +299,7 @@ static bool
 init_map_ipmac(struct ip_set *set, struct bitmap_ipmac *map,
 	       u32 first_ip, u32 last_ip, u32 elements)
 {
-	map->members = ip_set_alloc(map->memsize);
+	map->members = bitmap_zalloc(elements, GFP_KERNEL | __GFP_NOWARN);
 	if (!map->members)
 		return false;
 	map->first_ip = first_ip;
@@ -360,7 +360,7 @@ bitmap_ipmac_create(struct net *net, struct ip_set *set, struct nlattr *tb[],
 	if (!map)
 		return -ENOMEM;
 
-	map->memsize = bitmap_bytes(0, elements - 1);
+	map->memsize = BITS_TO_LONGS(elements) * sizeof(unsigned long);
 	set->variant = &bitmap_ipmac;
 	if (!init_map_ipmac(set, map, first_ip, last_ip, elements)) {
 		kfree(map);
diff --git a/net/netfilter/ipset/ip_set_bitmap_port.c b/net/netfilter/ipset/ip_set_bitmap_port.c
index 23d6095cb196..b49978dd810d 100644
--- a/net/netfilter/ipset/ip_set_bitmap_port.c
+++ b/net/netfilter/ipset/ip_set_bitmap_port.c
@@ -30,7 +30,7 @@ MODULE_ALIAS("ip_set_bitmap:port");
 
 /* Type structure */
 struct bitmap_port {
-	void *members;		/* the set members */
+	unsigned long *members;	/* the set members */
 	u16 first_port;		/* host byte order, included in range */
 	u16 last_port;		/* host byte order, included in range */
 	u32 elements;		/* number of max elements in the set */
@@ -231,7 +231,7 @@ static bool
 init_map_port(struct ip_set *set, struct bitmap_port *map,
 	      u16 first_port, u16 last_port)
 {
-	map->members = ip_set_alloc(map->memsize);
+	map->members = bitmap_zalloc(map->elements, GFP_KERNEL | __GFP_NOWARN);
 	if (!map->members)
 		return false;
 	map->first_port = first_port;
@@ -271,7 +271,7 @@ bitmap_port_create(struct net *net, struct ip_set *set, struct nlattr *tb[],
 		return -ENOMEM;
 
 	map->elements = elements;
-	map->memsize = bitmap_bytes(0, map->elements);
+	map->memsize = BITS_TO_LONGS(elements) * sizeof(unsigned long);
 	set->variant = &bitmap_port;
 	if (!init_map_port(set, map, first_port, last_port)) {
 		kfree(map);

