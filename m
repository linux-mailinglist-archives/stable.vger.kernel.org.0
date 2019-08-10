Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF6688DEC
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbfHJUuA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:50:00 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54562 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726739AbfHJUn5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:43:57 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDS-00053a-LQ; Sat, 10 Aug 2019 21:43:54 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDO-0003kx-Tb; Sat, 10 Aug 2019 21:43:50 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Vladislav Yasevich" <vyasevic@redhat.com>,
        "Vlad Yasevich" <vyasevich@gmail.com>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.234587141@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 146/157] ipv6: Select fragment id during UFO
 segmentation if not set.
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

From: Vlad Yasevich <vyasevich@gmail.com>

commit 0508c07f5e0c94f38afd5434e8b2a55b84553077 upstream.

If the IPv6 fragment id has not been set and we perform
fragmentation due to UFO, select a new fragment id.
We now consider a fragment id of 0 as unset and if id selection
process returns 0 (after all the pertrubations), we set it to
0x80000000, thus giving us ample space not to create collisions
with the next packet we may have to fragment.

When doing UFO integrity checking, we also select the
fragment id if it has not be set yet.   This is stored into
the skb_shinfo() thus allowing UFO to function correclty.

This patch also removes duplicate fragment id generation code
and moves ipv6_select_ident() into the header as it may be
used during GSO.

Signed-off-by: Vladislav Yasevich <vyasevic@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/net/ipv6.h     |  3 +++
 net/ipv6/ip6_output.c  | 14 --------------
 net/ipv6/output_core.c | 41 +++++++++++++++++++++++++++++++++++------
 net/ipv6/udp_offload.c | 10 +++++++++-
 4 files changed, 47 insertions(+), 21 deletions(-)

--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -688,6 +688,9 @@ static inline int ipv6_addr_diff(const s
 	return __ipv6_addr_diff(a1, a2, sizeof(struct in6_addr));
 }
 
+u32 __ipv6_select_ident(u32 hashrnd, struct in6_addr *dst,
+			struct in6_addr *src);
+void ipv6_select_ident(struct frag_hdr *fhdr, struct rt6_info *rt);
 void ipv6_proxy_select_ident(struct sk_buff *skb);
 
 int ip6_dst_hoplimit(struct dst_entry *dst);
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -538,20 +538,6 @@ static void ip6_copy_metadata(struct sk_
 	skb_copy_secmark(to, from);
 }
 
-static void ipv6_select_ident(struct frag_hdr *fhdr, struct rt6_info *rt)
-{
-	static u32 ip6_idents_hashrnd __read_mostly;
-	u32 hash, id;
-
-	net_get_random_once(&ip6_idents_hashrnd, sizeof(ip6_idents_hashrnd));
-
-	hash = __ipv6_addr_jhash(&rt->rt6i_dst.addr, ip6_idents_hashrnd);
-	hash = __ipv6_addr_jhash(&rt->rt6i_src.addr, hash);
-
-	id = ip_idents_reserve(hash, 1);
-	fhdr->identification = htonl(id);
-}
-
 int ip6_fragment(struct sk_buff *skb, int (*output)(struct sk_buff *))
 {
 	struct sk_buff *frag;
--- a/net/ipv6/output_core.c
+++ b/net/ipv6/output_core.c
@@ -9,6 +9,24 @@
 #include <net/addrconf.h>
 #include <net/secure_seq.h>
 
+u32 __ipv6_select_ident(u32 hashrnd, struct in6_addr *dst, struct in6_addr *src)
+{
+	u32 hash, id;
+
+	hash = __ipv6_addr_jhash(dst, hashrnd);
+	hash = __ipv6_addr_jhash(src, hash);
+
+	/* Treat id of 0 as unset and if we get 0 back from ip_idents_reserve,
+	 * set the hight order instead thus minimizing possible future
+	 * collisions.
+	 */
+	id = ip_idents_reserve(hash, 1);
+	if (unlikely(!id))
+		id = 1 << 31;
+
+	return id;
+}
+
 /* This function exists only for tap drivers that must support broken
  * clients requesting UFO without specifying an IPv6 fragment ID.
  *
@@ -22,7 +40,7 @@ void ipv6_proxy_select_ident(struct sk_b
 	static u32 ip6_proxy_idents_hashrnd __read_mostly;
 	struct in6_addr buf[2];
 	struct in6_addr *addrs;
-	u32 hash, id;
+	u32 id;
 
 	addrs = skb_header_pointer(skb,
 				   skb_network_offset(skb) +
@@ -34,14 +52,25 @@ void ipv6_proxy_select_ident(struct sk_b
 	net_get_random_once(&ip6_proxy_idents_hashrnd,
 			    sizeof(ip6_proxy_idents_hashrnd));
 
-	hash = __ipv6_addr_jhash(&addrs[1], ip6_proxy_idents_hashrnd);
-	hash = __ipv6_addr_jhash(&addrs[0], hash);
-
-	id = ip_idents_reserve(hash, 1);
-	skb_shinfo(skb)->ip6_frag_id = htonl(id);
+	id = __ipv6_select_ident(ip6_proxy_idents_hashrnd,
+				 &addrs[1], &addrs[0]);
+	skb_shinfo(skb)->ip6_frag_id = id;
 }
 EXPORT_SYMBOL_GPL(ipv6_proxy_select_ident);
 
+void ipv6_select_ident(struct frag_hdr *fhdr, struct rt6_info *rt)
+{
+	static u32 ip6_idents_hashrnd __read_mostly;
+	u32 id;
+
+	net_get_random_once(&ip6_idents_hashrnd, sizeof(ip6_idents_hashrnd));
+
+	id = __ipv6_select_ident(ip6_idents_hashrnd, &rt->rt6i_dst.addr,
+				 &rt->rt6i_src.addr);
+	fhdr->identification = htonl(id);
+}
+EXPORT_SYMBOL(ipv6_select_ident);
+
 int ip6_find_1stfragopt(struct sk_buff *skb, u8 **nexthdr)
 {
 	unsigned int offset = sizeof(struct ipv6hdr);
--- a/net/ipv6/udp_offload.c
+++ b/net/ipv6/udp_offload.c
@@ -75,6 +75,10 @@ static struct sk_buff *udp6_ufo_fragment
 
 		skb_shinfo(skb)->gso_segs = DIV_ROUND_UP(skb->len, mss);
 
+		/* Set the IPv6 fragment id if not set yet */
+		if (!skb_shinfo(skb)->ip6_frag_id)
+			ipv6_proxy_select_ident(skb);
+
 		segs = NULL;
 		goto out;
 	}
@@ -120,7 +124,11 @@ static struct sk_buff *udp6_ufo_fragment
 		fptr = (struct frag_hdr *)(skb_network_header(skb) + unfrag_ip6hlen);
 		fptr->nexthdr = nexthdr;
 		fptr->reserved = 0;
-		fptr->identification = skb_shinfo(skb)->ip6_frag_id;
+		if (skb_shinfo(skb)->ip6_frag_id)
+			fptr->identification = skb_shinfo(skb)->ip6_frag_id;
+		else
+			ipv6_select_ident(fptr,
+					  (struct rt6_info *)skb_dst(skb));
 
 		/* Fragment the skb. ipv6 header and the remaining fields of the
 		 * fragment header are updated in ipv6_gso_segment()

