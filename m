Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE989F6A4
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 01:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726111AbfH0XLL convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 27 Aug 2019 19:11:11 -0400
Received: from imap1.codethink.co.uk ([176.9.8.82]:59021 "EHLO
        imap1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726034AbfH0XLL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Aug 2019 19:11:11 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126] helo=xylophone.i.decadent.org.uk)
        by imap1.codethink.co.uk with esmtpsa (Exim 4.84_2 #1 (Debian))
        id 1i2kcG-0000kA-DV; Wed, 28 Aug 2019 00:11:08 +0100
Date:   Wed, 28 Aug 2019 00:11:06 +0100
From:   Ben Hutchings <ben.hutchings@codethink.co.uk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable <stable@vger.kernel.org>
Subject: [PATCH 4.4 11/13] inet: switch IP ID generator to siphash
Message-ID: <20190827231106.GK11046@xylophone.i.decadent.org.uk>
References: <20190827230906.GA11046@xylophone.i.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20190827230906.GA11046@xylophone.i.decadent.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
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
[bwh: Backported to 4.4: adjust context]
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
---
 include/linux/siphash.h  |  5 +++++
 include/net/netns/ipv4.h |  2 ++
 net/ipv4/route.c         | 12 +++++++-----
 net/ipv6/output_core.c   | 30 ++++++++++++++++--------------
 4 files changed, 30 insertions(+), 19 deletions(-)

diff --git a/include/linux/siphash.h b/include/linux/siphash.h
index fa7a6b9cedbf..bf21591a9e5e 100644
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
diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index 61c38f87ea07..e6f49f22e006 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -8,6 +8,7 @@
 #include <linux/uidgid.h>
 #include <net/inet_frag.h>
 #include <linux/rcupdate.h>
+#include <linux/siphash.h>
 
 struct tcpm_hash_bucket;
 struct ctl_table_header;
@@ -109,5 +110,6 @@ struct netns_ipv4 {
 #endif
 #endif
 	atomic_t	rt_genid;
+	siphash_key_t	ip_id_key;
 };
 #endif
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index a58effba760a..3c605a788ba1 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -490,15 +490,17 @@ EXPORT_SYMBOL(ip_idents_reserve);
 
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
diff --git a/net/ipv6/output_core.c b/net/ipv6/output_core.c
index f99a04674419..6b896cc9604e 100644
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
@@ -41,7 +51,6 @@ static u32 __ipv6_select_ident(struct net *net, u32 hashrnd,
  */
 void ipv6_proxy_select_ident(struct net *net, struct sk_buff *skb)
 {
-	static u32 ip6_proxy_idents_hashrnd __read_mostly;
 	struct in6_addr buf[2];
 	struct in6_addr *addrs;
 	u32 id;
@@ -53,11 +62,7 @@ void ipv6_proxy_select_ident(struct net *net, struct sk_buff *skb)
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
@@ -66,12 +71,9 @@ __be32 ipv6_select_ident(struct net *net,
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
-- 
Ben Hutchings, Software Developer                         Codethink Ltd
https://www.codethink.co.uk/                 Dale House, 35 Dale Street
                                     Manchester, M1 2HF, United Kingdom


