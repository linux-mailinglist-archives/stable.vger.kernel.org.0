Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91D5F99D72
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405199AbfHVRm3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:42:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:44256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391644AbfHVRXr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:23:47 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F028423431;
        Thu, 22 Aug 2019 17:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494626;
        bh=zYG/HiEN+IeYXW4MakE7ji8fVnCXG85vzm5DWGmJx4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OlfWQddFJ69DntCjro201piN2iZQ44jAXr24gCVSci61L2zmxPO4PZlppCr0WZU9K
         qNHcMNCM8meNMEfezqRDAiHC1N2WjOiOSNflRrJB7bRoIomFvYl2TN5hzep/j1VrGK
         V+txl3rFo0DZgFbaEpvFxCSNlaReq/tvuV8N0X6E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Amit Klein <aksecurity@gmail.com>,
        Benny Pinkas <benny@pinkas.net>,
        "David S. Miller" <davem@davemloft.net>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 4.9 056/103] inet: switch IP ID generator to siphash
Date:   Thu, 22 Aug 2019 10:18:44 -0700
Message-Id: <20190822171731.053476357@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171728.445189830@linuxfoundation.org>
References: <20190822171728.445189830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit df453700e8d81b1bdafdf684365ee2b9431fb702 upstream.

According to Amit Klein and Benny Pinkas, IP ID generation is too weak
and might be used by attackers.

Even with recent net_hash_mix() fix (netns: provide pure entropy for net_hash_mix())
having 64bit key and Jenkins hash is risky.

It is time to switch to siphash and its 128bit keys.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Amit Klein <aksecurity@gmail.com>
Reported-by: Benny Pinkas <benny@pinkas.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
[bwh: Backported to 4.9: adjust context]
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/siphash.h  |    5 +++++
 include/net/netns/ipv4.h |    2 ++
 net/ipv4/route.c         |   12 +++++++-----
 net/ipv6/output_core.c   |   30 ++++++++++++++++--------------
 4 files changed, 30 insertions(+), 19 deletions(-)

--- a/include/linux/siphash.h
+++ b/include/linux/siphash.h
@@ -21,6 +21,11 @@ typedef struct {
 	u64 key[2];
 } siphash_key_t;
 
+static inline bool siphash_key_is_zero(const siphash_key_t *key)
+{
+	return !(key->key[0] | key->key[1]);
+}
+
 u64 __siphash_aligned(const void *data, size_t len, const siphash_key_t *key);
 #ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
 u64 __siphash_unaligned(const void *data, size_t len, const siphash_key_t *key);
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -8,6 +8,7 @@
 #include <linux/uidgid.h>
 #include <net/inet_frag.h>
 #include <linux/rcupdate.h>
+#include <linux/siphash.h>
 
 struct tcpm_hash_bucket;
 struct ctl_table_header;
@@ -137,5 +138,6 @@ struct netns_ipv4 {
 	int sysctl_fib_multipath_use_neigh;
 #endif
 	atomic_t	rt_genid;
+	siphash_key_t	ip_id_key;
 };
 #endif
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -496,15 +496,17 @@ EXPORT_SYMBOL(ip_idents_reserve);
 
 void __ip_select_ident(struct net *net, struct iphdr *iph, int segs)
 {
-	static u32 ip_idents_hashrnd __read_mostly;
 	u32 hash, id;
 
-	net_get_random_once(&ip_idents_hashrnd, sizeof(ip_idents_hashrnd));
+	/* Note the following code is not safe, but this is okay. */
+	if (unlikely(siphash_key_is_zero(&net->ipv4.ip_id_key)))
+		get_random_bytes(&net->ipv4.ip_id_key,
+				 sizeof(net->ipv4.ip_id_key));
 
-	hash = jhash_3words((__force u32)iph->daddr,
+	hash = siphash_3u32((__force u32)iph->daddr,
 			    (__force u32)iph->saddr,
-			    iph->protocol ^ net_hash_mix(net),
-			    ip_idents_hashrnd);
+			    iph->protocol,
+			    &net->ipv4.ip_id_key);
 	id = ip_idents_reserve(hash, segs);
 	iph->id = htons(id);
 }
--- a/net/ipv6/output_core.c
+++ b/net/ipv6/output_core.c
@@ -10,15 +10,25 @@
 #include <net/secure_seq.h>
 #include <linux/netfilter.h>
 
-static u32 __ipv6_select_ident(struct net *net, u32 hashrnd,
+static u32 __ipv6_select_ident(struct net *net,
 			       const struct in6_addr *dst,
 			       const struct in6_addr *src)
 {
+	const struct {
+		struct in6_addr dst;
+		struct in6_addr src;
+	} __aligned(SIPHASH_ALIGNMENT) combined = {
+		.dst = *dst,
+		.src = *src,
+	};
 	u32 hash, id;
 
-	hash = __ipv6_addr_jhash(dst, hashrnd);
-	hash = __ipv6_addr_jhash(src, hash);
-	hash ^= net_hash_mix(net);
+	/* Note the following code is not safe, but this is okay. */
+	if (unlikely(siphash_key_is_zero(&net->ipv4.ip_id_key)))
+		get_random_bytes(&net->ipv4.ip_id_key,
+				 sizeof(net->ipv4.ip_id_key));
+
+	hash = siphash(&combined, sizeof(combined), &net->ipv4.ip_id_key);
 
 	/* Treat id of 0 as unset and if we get 0 back from ip_idents_reserve,
 	 * set the hight order instead thus minimizing possible future
@@ -41,7 +51,6 @@ static u32 __ipv6_select_ident(struct ne
  */
 void ipv6_proxy_select_ident(struct net *net, struct sk_buff *skb)
 {
-	static u32 ip6_proxy_idents_hashrnd __read_mostly;
 	struct in6_addr buf[2];
 	struct in6_addr *addrs;
 	u32 id;
@@ -53,11 +62,7 @@ void ipv6_proxy_select_ident(struct net
 	if (!addrs)
 		return;
 
-	net_get_random_once(&ip6_proxy_idents_hashrnd,
-			    sizeof(ip6_proxy_idents_hashrnd));
-
-	id = __ipv6_select_ident(net, ip6_proxy_idents_hashrnd,
-				 &addrs[1], &addrs[0]);
+	id = __ipv6_select_ident(net, &addrs[1], &addrs[0]);
 	skb_shinfo(skb)->ip6_frag_id = htonl(id);
 }
 EXPORT_SYMBOL_GPL(ipv6_proxy_select_ident);
@@ -66,12 +71,9 @@ __be32 ipv6_select_ident(struct net *net
 			 const struct in6_addr *daddr,
 			 const struct in6_addr *saddr)
 {
-	static u32 ip6_idents_hashrnd __read_mostly;
 	u32 id;
 
-	net_get_random_once(&ip6_idents_hashrnd, sizeof(ip6_idents_hashrnd));
-
-	id = __ipv6_select_ident(net, ip6_idents_hashrnd, daddr, saddr);
+	id = __ipv6_select_ident(net, daddr, saddr);
 	return htonl(id);
 }
 EXPORT_SYMBOL(ipv6_select_ident);


