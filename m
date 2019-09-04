Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E85CA8E41
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732585AbfIDR5A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 13:57:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:34614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387747AbfIDR47 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 13:56:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69E8222CF7;
        Wed,  4 Sep 2019 17:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567619817;
        bh=bw85jlk93cBNg/WX8uqzAAvAKPH9z2NgiII0wVYmW04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0wDa02jM+Sof+aDSHJREAoD/CLijB894yEnjPT7RxRxcmlmz/SemwdRF566jj+3w/
         knW2pJvNLx3dIQ+Tna7efPLXhMy20KhWbhXOxQ9hEbPgm4vR4sxAmpS12GCBsME2Y6
         23Hn8gdZjqcec1lH5wmmIZ4Y+XrfDi2P8CXDiX0Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Amit Klein <aksecurity@gmail.com>,
        Benny Pinkas <benny@pinkas.net>,
        "David S. Miller" <davem@davemloft.net>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 44/77] inet: switch IP ID generator to siphash
Date:   Wed,  4 Sep 2019 19:53:31 +0200
Message-Id: <20190904175307.730993197@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175303.317468926@linuxfoundation.org>
References: <20190904175303.317468926@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/siphash.h  |  5 +++++
 include/net/netns/ipv4.h |  2 ++
 net/ipv4/route.c         | 12 +++++++-----
 net/ipv6/output_core.c   | 30 ++++++++++++++++--------------
 4 files changed, 30 insertions(+), 19 deletions(-)

diff --git a/include/linux/siphash.h b/include/linux/siphash.h
index fa7a6b9cedbff..bf21591a9e5e6 100644
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
index 61c38f87ea079..e6f49f22e0066 100644
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
index a58effba760ae..3c605a788ba1e 100644
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
index f99a04674419b..6b896cc9604e5 100644
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
2.20.1



