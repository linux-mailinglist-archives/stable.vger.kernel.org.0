Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D555188DDA
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbfHJUtq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:49:46 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54598 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726750AbfHJUn6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:43:58 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDS-00053W-BF; Sat, 10 Aug 2019 21:43:54 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDP-0003mC-C9; Sat, 10 Aug 2019 21:43:51 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Eric Dumazet" <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Amit Klein" <aksecurity@gmail.com>,
        "Benny Pinkas" <benny@pinkas.net>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.862882638@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 155/157] inet: switch IP ID generator to siphash
In-Reply-To: <lsq.1565469607.188083258@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.72-rc1 review patch.  If anyone has any objections, please let me know.

------------------

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
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/include/linux/siphash.h
+++ b/include/linux/siphash.h
@@ -19,6 +19,11 @@ typedef struct {
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
@@ -7,6 +7,7 @@
 
 #include <linux/uidgid.h>
 #include <net/inet_frag.h>
+#include <linux/siphash.h>
 
 struct tcpm_hash_bucket;
 struct ctl_table_header;
@@ -98,5 +99,6 @@ struct netns_ipv4 {
 #endif
 #endif
 	atomic_t	rt_genid;
+	siphash_key_t	ip_id_key;
 };
 #endif
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -486,15 +486,17 @@ EXPORT_SYMBOL(ip_idents_reserve);
 
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
@@ -9,14 +9,24 @@
 #include <net/addrconf.h>
 #include <net/secure_seq.h>
 
-static u32 __ipv6_select_ident(struct net *net, u32 hashrnd,
+static u32 __ipv6_select_ident(struct net *net,
 			       struct in6_addr *dst, struct in6_addr *src)
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
@@ -39,7 +49,6 @@ static u32 __ipv6_select_ident(struct ne
  */
 void ipv6_proxy_select_ident(struct net *net, struct sk_buff *skb)
 {
-	static u32 ip6_proxy_idents_hashrnd __read_mostly;
 	struct in6_addr buf[2];
 	struct in6_addr *addrs;
 	u32 id;
@@ -51,11 +60,7 @@ void ipv6_proxy_select_ident(struct net
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
@@ -63,13 +68,9 @@ EXPORT_SYMBOL_GPL(ipv6_proxy_select_iden
 void ipv6_select_ident(struct net *net, struct frag_hdr *fhdr,
 		       struct rt6_info *rt)
 {
-	static u32 ip6_idents_hashrnd __read_mostly;
 	u32 id;
 
-	net_get_random_once(&ip6_idents_hashrnd, sizeof(ip6_idents_hashrnd));
-
-	id = __ipv6_select_ident(net, ip6_idents_hashrnd, &rt->rt6i_dst.addr,
-				 &rt->rt6i_src.addr);
+	id = __ipv6_select_ident(net, &rt->rt6i_dst.addr, &rt->rt6i_src.addr);
 	fhdr->identification = htonl(id);
 }
 EXPORT_SYMBOL(ipv6_select_ident);

