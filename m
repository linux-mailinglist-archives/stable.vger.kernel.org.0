Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5245188DE3
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727403AbfHJUuB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:50:01 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54522 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726727AbfHJUn5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:43:57 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDS-00058O-7q; Sat, 10 Aug 2019 21:43:54 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDP-0003m0-86; Sat, 10 Aug 2019 21:43:51 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Flavio Leitner" <fbl@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "Hannes Frederic Sowa" <hannes@stressinduktion.org>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.563481538@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 153/157] ipv6: hash net ptr into fragmentation bucket
 selection
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

From: Hannes Frederic Sowa <hannes@stressinduktion.org>

commit 5a352dd0a3aac03b443c94828dfd7144261c8636 upstream.

As namespaces are sometimes used with overlapping ip address ranges,
we should also use the namespace as input to the hash to select the ip
fragmentation counter bucket.

Cc: Eric Dumazet <edumazet@google.com>
Cc: Flavio Leitner <fbl@redhat.com>
Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/net/ipv6.h     |  5 +++--
 net/ipv6/ip6_output.c  |  6 +++---
 net/ipv6/output_core.c | 14 ++++++++------
 net/ipv6/udp_offload.c |  4 ++--
 4 files changed, 16 insertions(+), 13 deletions(-)

--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -688,8 +688,9 @@ static inline int ipv6_addr_diff(const s
 	return __ipv6_addr_diff(a1, a2, sizeof(struct in6_addr));
 }
 
-void ipv6_select_ident(struct frag_hdr *fhdr, struct rt6_info *rt);
-void ipv6_proxy_select_ident(struct sk_buff *skb);
+void ipv6_select_ident(struct net *net, struct frag_hdr *fhdr,
+		       struct rt6_info *rt);
+void ipv6_proxy_select_ident(struct net *net, struct sk_buff *skb);
 
 int ip6_dst_hoplimit(struct dst_entry *dst);
 
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -632,7 +632,7 @@ int ip6_fragment(struct sk_buff *skb, in
 		skb_reset_network_header(skb);
 		memcpy(skb_network_header(skb), tmp_hdr, hlen);
 
-		ipv6_select_ident(fh, rt);
+		ipv6_select_ident(net, fh, rt);
 		fh->nexthdr = nexthdr;
 		fh->reserved = 0;
 		fh->frag_off = htons(IP6_MF);
@@ -785,7 +785,7 @@ slow_path:
 		fh->nexthdr = nexthdr;
 		fh->reserved = 0;
 		if (!frag_id) {
-			ipv6_select_ident(fh, rt);
+			ipv6_select_ident(net, fh, rt);
 			frag_id = fh->identification;
 		} else
 			fh->identification = frag_id;
@@ -1079,7 +1079,7 @@ static inline int ip6_ufo_append_data(st
 	skb_shinfo(skb)->gso_size = (mtu - fragheaderlen -
 				     sizeof(struct frag_hdr)) & ~7;
 	skb_shinfo(skb)->gso_type = SKB_GSO_UDP;
-	ipv6_select_ident(&fhdr, rt);
+	ipv6_select_ident(sock_net(sk), &fhdr, rt);
 	skb_shinfo(skb)->ip6_frag_id = fhdr.identification;
 
 append:
--- a/net/ipv6/output_core.c
+++ b/net/ipv6/output_core.c
@@ -9,13 +9,14 @@
 #include <net/addrconf.h>
 #include <net/secure_seq.h>
 
-static u32 __ipv6_select_ident(u32 hashrnd, struct in6_addr *dst,
-			       struct in6_addr *src)
+static u32 __ipv6_select_ident(struct net *net, u32 hashrnd,
+			       struct in6_addr *dst, struct in6_addr *src)
 {
 	u32 hash, id;
 
 	hash = __ipv6_addr_jhash(dst, hashrnd);
 	hash = __ipv6_addr_jhash(src, hash);
+	hash ^= net_hash_mix(net);
 
 	/* Treat id of 0 as unset and if we get 0 back from ip_idents_reserve,
 	 * set the hight order instead thus minimizing possible future
@@ -36,7 +37,7 @@ static u32 __ipv6_select_ident(u32 hashr
  *
  * The network header must be set before calling this.
  */
-void ipv6_proxy_select_ident(struct sk_buff *skb)
+void ipv6_proxy_select_ident(struct net *net, struct sk_buff *skb)
 {
 	static u32 ip6_proxy_idents_hashrnd __read_mostly;
 	struct in6_addr buf[2];
@@ -53,20 +54,21 @@ void ipv6_proxy_select_ident(struct sk_b
 	net_get_random_once(&ip6_proxy_idents_hashrnd,
 			    sizeof(ip6_proxy_idents_hashrnd));
 
-	id = __ipv6_select_ident(ip6_proxy_idents_hashrnd,
+	id = __ipv6_select_ident(net, ip6_proxy_idents_hashrnd,
 				 &addrs[1], &addrs[0]);
 	skb_shinfo(skb)->ip6_frag_id = htonl(id);
 }
 EXPORT_SYMBOL_GPL(ipv6_proxy_select_ident);
 
-void ipv6_select_ident(struct frag_hdr *fhdr, struct rt6_info *rt)
+void ipv6_select_ident(struct net *net, struct frag_hdr *fhdr,
+		       struct rt6_info *rt)
 {
 	static u32 ip6_idents_hashrnd __read_mostly;
 	u32 id;
 
 	net_get_random_once(&ip6_idents_hashrnd, sizeof(ip6_idents_hashrnd));
 
-	id = __ipv6_select_ident(ip6_idents_hashrnd, &rt->rt6i_dst.addr,
+	id = __ipv6_select_ident(net, ip6_idents_hashrnd, &rt->rt6i_dst.addr,
 				 &rt->rt6i_src.addr);
 	fhdr->identification = htonl(id);
 }
--- a/net/ipv6/udp_offload.c
+++ b/net/ipv6/udp_offload.c
@@ -77,7 +77,7 @@ static struct sk_buff *udp6_ufo_fragment
 
 		/* Set the IPv6 fragment id if not set yet */
 		if (!skb_shinfo(skb)->ip6_frag_id)
-			ipv6_proxy_select_ident(skb);
+			ipv6_proxy_select_ident(dev_net(skb->dev), skb);
 
 		segs = NULL;
 		goto out;
@@ -125,7 +125,7 @@ static struct sk_buff *udp6_ufo_fragment
 		fptr->nexthdr = nexthdr;
 		fptr->reserved = 0;
 		if (!skb_shinfo(skb)->ip6_frag_id)
-			ipv6_proxy_select_ident(skb);
+			ipv6_proxy_select_ident(dev_net(skb->dev), skb);
 		fptr->identification = skb_shinfo(skb)->ip6_frag_id;
 
 		/* Fragment the skb. ipv6 header and the remaining fields of the

