Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5AF414BAC3
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:41:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729436AbgA1OOg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:14:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:36842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729113AbgA1OOg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:14:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 02C9724691;
        Tue, 28 Jan 2020 14:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220875;
        bh=jHMKAVzMW6nzIywW3PHvUmKYlMXkVYX0txP8GYsfOo0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sIANJceqIF0mPm0f5ZF2mw8gV9ilJ7fY3CXD9ayKdRjwB4/pXQKq7cxdetrZcGFdx
         N8q0Rf8Oczpw7XC9ECPoaIF8wSxPWCZBS1EVyJSL6BylFDwXZ3Sewtr3yuhJr0oXSU
         5fck8zmXhSTdCAiog30sgnwVdlup4RMe52v5txYw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+fabca5cbf5e54f3fe2de@syzkaller.appspotmail.com,
        syzbot+827ced406c9a1d9570ed@syzkaller.appspotmail.com,
        syzbot+190d63957b22ef673ea5@syzkaller.appspotmail.com,
        syzbot+dfccdb2bdb4a12ad425e@syzkaller.appspotmail.com,
        syzbot+df0d0f5895ef1f41a65b@syzkaller.appspotmail.com,
        syzbot+b08bd19bb37513357fd4@syzkaller.appspotmail.com,
        syzbot+53cdd0ec0bbabd53370a@syzkaller.appspotmail.com,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.4 181/183] netfilter: ipset: use bitmap infrastructure completely
Date:   Tue, 28 Jan 2020 15:06:40 +0100
Message-Id: <20200128135847.803026157@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135829.486060649@linuxfoundation.org>
References: <20200128135829.486060649@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kadlecsik József <kadlec@blackhole.kfki.hu>

commit 32c72165dbd0e246e69d16a3ad348a4851afd415 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/netfilter/ipset/ip_set.h    |    7 -------
 net/netfilter/ipset/ip_set_bitmap_gen.h   |    2 +-
 net/netfilter/ipset/ip_set_bitmap_ip.c    |    6 +++---
 net/netfilter/ipset/ip_set_bitmap_ipmac.c |    6 +++---
 net/netfilter/ipset/ip_set_bitmap_port.c  |    6 +++---
 5 files changed, 10 insertions(+), 17 deletions(-)

--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -530,13 +530,6 @@ ip6addrptr(const struct sk_buff *skb, bo
 	       sizeof(*addr));
 }
 
-/* Calculate the bytes required to store the inclusive range of a-b */
-static inline int
-bitmap_bytes(u32 a, u32 b)
-{
-	return 4 * ((((b - a + 8) / 8) + 3) / 4);
-}
-
 #include <linux/netfilter/ipset/ip_set_timeout.h>
 #include <linux/netfilter/ipset/ip_set_comment.h>
 
--- a/net/netfilter/ipset/ip_set_bitmap_gen.h
+++ b/net/netfilter/ipset/ip_set_bitmap_gen.h
@@ -81,7 +81,7 @@ mtype_flush(struct ip_set *set)
 
 	if (set->extensions & IPSET_EXT_DESTROY)
 		mtype_ext_cleanup(set);
-	memset(map->members, 0, map->memsize);
+	bitmap_zero(map->members, map->elements);
 }
 
 static int
--- a/net/netfilter/ipset/ip_set_bitmap_ip.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ip.c
@@ -40,7 +40,7 @@ MODULE_ALIAS("ip_set_bitmap:ip");
 
 /* Type structure */
 struct bitmap_ip {
-	void *members;		/* the set members */
+	unsigned long *members;	/* the set members */
 	u32 first_ip;		/* host byte order, included in range */
 	u32 last_ip;		/* host byte order, included in range */
 	u32 elements;		/* number of max elements in the set */
@@ -222,7 +222,7 @@ init_map_ip(struct ip_set *set, struct b
 	    u32 first_ip, u32 last_ip,
 	    u32 elements, u32 hosts, u8 netmask)
 {
-	map->members = ip_set_alloc(map->memsize);
+	map->members = bitmap_zalloc(elements, GFP_KERNEL | __GFP_NOWARN);
 	if (!map->members)
 		return false;
 	map->first_ip = first_ip;
@@ -315,7 +315,7 @@ bitmap_ip_create(struct net *net, struct
 	if (!map)
 		return -ENOMEM;
 
-	map->memsize = bitmap_bytes(0, elements - 1);
+	map->memsize = BITS_TO_LONGS(elements) * sizeof(unsigned long);
 	set->variant = &bitmap_ip;
 	if (!init_map_ip(set, map, first_ip, last_ip,
 			 elements, hosts, netmask)) {
--- a/net/netfilter/ipset/ip_set_bitmap_ipmac.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
@@ -46,7 +46,7 @@ enum {
 
 /* Type structure */
 struct bitmap_ipmac {
-	void *members;		/* the set members */
+	unsigned long *members;	/* the set members */
 	u32 first_ip;		/* host byte order, included in range */
 	u32 last_ip;		/* host byte order, included in range */
 	u32 elements;		/* number of max elements in the set */
@@ -297,7 +297,7 @@ static bool
 init_map_ipmac(struct ip_set *set, struct bitmap_ipmac *map,
 	       u32 first_ip, u32 last_ip, u32 elements)
 {
-	map->members = ip_set_alloc(map->memsize);
+	map->members = bitmap_zalloc(elements, GFP_KERNEL | __GFP_NOWARN);
 	if (!map->members)
 		return false;
 	map->first_ip = first_ip;
@@ -361,7 +361,7 @@ bitmap_ipmac_create(struct net *net, str
 	if (!map)
 		return -ENOMEM;
 
-	map->memsize = bitmap_bytes(0, elements - 1);
+	map->memsize = BITS_TO_LONGS(elements) * sizeof(unsigned long);
 	set->variant = &bitmap_ipmac;
 	if (!init_map_ipmac(set, map, first_ip, last_ip, elements)) {
 		kfree(map);
--- a/net/netfilter/ipset/ip_set_bitmap_port.c
+++ b/net/netfilter/ipset/ip_set_bitmap_port.c
@@ -34,7 +34,7 @@ MODULE_ALIAS("ip_set_bitmap:port");
 
 /* Type structure */
 struct bitmap_port {
-	void *members;		/* the set members */
+	unsigned long *members;	/* the set members */
 	u16 first_port;		/* host byte order, included in range */
 	u16 last_port;		/* host byte order, included in range */
 	u32 elements;		/* number of max elements in the set */
@@ -207,7 +207,7 @@ static bool
 init_map_port(struct ip_set *set, struct bitmap_port *map,
 	      u16 first_port, u16 last_port)
 {
-	map->members = ip_set_alloc(map->memsize);
+	map->members = bitmap_zalloc(map->elements, GFP_KERNEL | __GFP_NOWARN);
 	if (!map->members)
 		return false;
 	map->first_port = first_port;
@@ -250,7 +250,7 @@ bitmap_port_create(struct net *net, stru
 		return -ENOMEM;
 
 	map->elements = elements;
-	map->memsize = bitmap_bytes(0, map->elements);
+	map->memsize = BITS_TO_LONGS(elements) * sizeof(unsigned long);
 	set->variant = &bitmap_port;
 	if (!init_map_port(set, map, first_port, last_port)) {
 		kfree(map);


