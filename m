Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C632F313829
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:37:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233888AbhBHPhZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:37:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:38802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233956AbhBHPcc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:32:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 655E864F40;
        Mon,  8 Feb 2021 15:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797462;
        bh=foKHj7tFnv9yAZNLbXe2JlZcOSmKTUf7CwPHA/4SqAA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U69hQjdpoZWnocByTah6D236XH/tq81Xbap+bVNgJdpZSOqn7h4wFyJBI0K9aqnKB
         0/6CplV+WOOvPpo7YpU51mOC+z5ZIJsjktsDpNTkbT47hIqmqeLACDxr3PJ9+6d9Lf
         JIwEqNUk9Re5TIlV2VFKGEK5M0rRYdEVlAupOIc4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dongseok Yi <dseok.yi@samsung.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 118/120] udp: ipv4: manipulate network header of NATed UDP GRO fraglist
Date:   Mon,  8 Feb 2021 16:01:45 +0100
Message-Id: <20210208145823.087150403@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
References: <20210208145818.395353822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dongseok Yi <dseok.yi@samsung.com>

commit c3df39ac9b0e3747bf8233ea9ce4ed5ceb3199d3 upstream.

UDP/IP header of UDP GROed frag_skbs are not updated even after NAT
forwarding. Only the header of head_skb from ip_finish_output_gso ->
skb_gso_segment is updated but following frag_skbs are not updated.

A call path skb_mac_gso_segment -> inet_gso_segment ->
udp4_ufo_fragment -> __udp_gso_segment -> __udp_gso_segment_list
does not try to update UDP/IP header of the segment list but copy
only the MAC header.

Update port, addr and check of each skb of the segment list in
__udp_gso_segment_list. It covers both SNAT and DNAT.

Fixes: 9fd1ff5d2ac7 (udp: Support UDP fraglist GRO/GSO.)
Signed-off-by: Dongseok Yi <dseok.yi@samsung.com>
Acked-by: Steffen Klassert <steffen.klassert@secunet.com>
Link: https://lore.kernel.org/r/1611962007-80092-1-git-send-email-dseok.yi@samsung.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/udp.h      |    2 -
 net/ipv4/udp_offload.c |   69 +++++++++++++++++++++++++++++++++++++++++++++----
 net/ipv6/udp_offload.c |    2 -
 3 files changed, 66 insertions(+), 7 deletions(-)

--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -178,7 +178,7 @@ struct sk_buff *udp_gro_receive(struct l
 int udp_gro_complete(struct sk_buff *skb, int nhoff, udp_lookup_t lookup);
 
 struct sk_buff *__udp_gso_segment(struct sk_buff *gso_skb,
-				  netdev_features_t features);
+				  netdev_features_t features, bool is_ipv6);
 
 static inline struct udphdr *udp_gro_udphdr(struct sk_buff *skb)
 {
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -184,8 +184,67 @@ out_unlock:
 }
 EXPORT_SYMBOL(skb_udp_tunnel_segment);
 
+static void __udpv4_gso_segment_csum(struct sk_buff *seg,
+				     __be32 *oldip, __be32 *newip,
+				     __be16 *oldport, __be16 *newport)
+{
+	struct udphdr *uh;
+	struct iphdr *iph;
+
+	if (*oldip == *newip && *oldport == *newport)
+		return;
+
+	uh = udp_hdr(seg);
+	iph = ip_hdr(seg);
+
+	if (uh->check) {
+		inet_proto_csum_replace4(&uh->check, seg, *oldip, *newip,
+					 true);
+		inet_proto_csum_replace2(&uh->check, seg, *oldport, *newport,
+					 false);
+		if (!uh->check)
+			uh->check = CSUM_MANGLED_0;
+	}
+	*oldport = *newport;
+
+	csum_replace4(&iph->check, *oldip, *newip);
+	*oldip = *newip;
+}
+
+static struct sk_buff *__udpv4_gso_segment_list_csum(struct sk_buff *segs)
+{
+	struct sk_buff *seg;
+	struct udphdr *uh, *uh2;
+	struct iphdr *iph, *iph2;
+
+	seg = segs;
+	uh = udp_hdr(seg);
+	iph = ip_hdr(seg);
+
+	if ((udp_hdr(seg)->dest == udp_hdr(seg->next)->dest) &&
+	    (udp_hdr(seg)->source == udp_hdr(seg->next)->source) &&
+	    (ip_hdr(seg)->daddr == ip_hdr(seg->next)->daddr) &&
+	    (ip_hdr(seg)->saddr == ip_hdr(seg->next)->saddr))
+		return segs;
+
+	while ((seg = seg->next)) {
+		uh2 = udp_hdr(seg);
+		iph2 = ip_hdr(seg);
+
+		__udpv4_gso_segment_csum(seg,
+					 &iph2->saddr, &iph->saddr,
+					 &uh2->source, &uh->source);
+		__udpv4_gso_segment_csum(seg,
+					 &iph2->daddr, &iph->daddr,
+					 &uh2->dest, &uh->dest);
+	}
+
+	return segs;
+}
+
 static struct sk_buff *__udp_gso_segment_list(struct sk_buff *skb,
-					      netdev_features_t features)
+					      netdev_features_t features,
+					      bool is_ipv6)
 {
 	unsigned int mss = skb_shinfo(skb)->gso_size;
 
@@ -195,11 +254,11 @@ static struct sk_buff *__udp_gso_segment
 
 	udp_hdr(skb)->len = htons(sizeof(struct udphdr) + mss);
 
-	return skb;
+	return is_ipv6 ? skb : __udpv4_gso_segment_list_csum(skb);
 }
 
 struct sk_buff *__udp_gso_segment(struct sk_buff *gso_skb,
-				  netdev_features_t features)
+				  netdev_features_t features, bool is_ipv6)
 {
 	struct sock *sk = gso_skb->sk;
 	unsigned int sum_truesize = 0;
@@ -211,7 +270,7 @@ struct sk_buff *__udp_gso_segment(struct
 	__be16 newlen;
 
 	if (skb_shinfo(gso_skb)->gso_type & SKB_GSO_FRAGLIST)
-		return __udp_gso_segment_list(gso_skb, features);
+		return __udp_gso_segment_list(gso_skb, features, is_ipv6);
 
 	mss = skb_shinfo(gso_skb)->gso_size;
 	if (gso_skb->len <= sizeof(*uh) + mss)
@@ -325,7 +384,7 @@ static struct sk_buff *udp4_ufo_fragment
 		goto out;
 
 	if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4)
-		return __udp_gso_segment(skb, features);
+		return __udp_gso_segment(skb, features, false);
 
 	mss = skb_shinfo(skb)->gso_size;
 	if (unlikely(skb->len <= mss))
--- a/net/ipv6/udp_offload.c
+++ b/net/ipv6/udp_offload.c
@@ -46,7 +46,7 @@ static struct sk_buff *udp6_ufo_fragment
 			goto out;
 
 		if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4)
-			return __udp_gso_segment(skb, features);
+			return __udp_gso_segment(skb, features, true);
 
 		/* Do software UFO. Complete and fill in the UDP checksum as HW cannot
 		 * do checksum of UDP packets sent as multiple IP fragments.


