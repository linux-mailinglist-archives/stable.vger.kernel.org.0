Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A43742B63CF
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:42:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733092AbgKQNlt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:41:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:54336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733040AbgKQNls (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:41:48 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B9482468E;
        Tue, 17 Nov 2020 13:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620507;
        bh=YeiDVc/9sznJoehMpVDXFhFrWKqEVswZjPY0M0eyEc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yGsbLJUf+g5fFCjIgE6VCQMIAfeDK7FjzwfNTofqYmS7r00Ig/oqOQiIpbTrS3v4E
         JaG0YydiA2FjNST1hZ0aLfyt/XrfOEryjXUWtXHZxs/eJ6b20d1k/qLG8Ov62X7XHz
         VVFHSOMTMLHzp9lfqyDgCMs98JcXFJOuWvtuVuX4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 242/255] net: udp: fix IP header access and skb lookup on Fast/frag0 UDP GRO
Date:   Tue, 17 Nov 2020 14:06:22 +0100
Message-Id: <20201117122150.714251277@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Lobakin <alobakin@pm.me>

[ Upstream commit 55e729889bb07d68ab071660ce3f5e7a7872ebe8 ]

udp{4,6}_lib_lookup_skb() use ip{,v6}_hdr() to get IP header of the
packet. While it's probably OK for non-frag0 paths, this helpers
will also point to junk on Fast/frag0 GRO when all headers are
located in frags. As a result, sk/skb lookup may fail or give wrong
results. To support both GRO modes, skb_gro_network_header() might
be used. To not modify original functions, add private versions of
udp{4,6}_lib_lookup_skb() only to perform correct sk lookups on GRO.

Present since the introduction of "application-level" UDP GRO
in 4.7-rc1.

Misc: replace totally unneeded ternaries with plain ifs.

Fixes: a6024562ffd7 ("udp: Add GRO functions to UDP socket")
Suggested-by: Willem de Bruijn <willemb@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
Acked-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/udp_offload.c |   17 +++++++++++++++--
 net/ipv6/udp_offload.c |   17 +++++++++++++++--
 2 files changed, 30 insertions(+), 4 deletions(-)

--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -500,12 +500,22 @@ out:
 }
 EXPORT_SYMBOL(udp_gro_receive);
 
+static struct sock *udp4_gro_lookup_skb(struct sk_buff *skb, __be16 sport,
+					__be16 dport)
+{
+	const struct iphdr *iph = skb_gro_network_header(skb);
+
+	return __udp4_lib_lookup(dev_net(skb->dev), iph->saddr, sport,
+				 iph->daddr, dport, inet_iif(skb),
+				 inet_sdif(skb), &udp_table, NULL);
+}
+
 INDIRECT_CALLABLE_SCOPE
 struct sk_buff *udp4_gro_receive(struct list_head *head, struct sk_buff *skb)
 {
 	struct udphdr *uh = udp_gro_udphdr(skb);
+	struct sock *sk = NULL;
 	struct sk_buff *pp;
-	struct sock *sk;
 
 	if (unlikely(!uh))
 		goto flush;
@@ -523,7 +533,10 @@ struct sk_buff *udp4_gro_receive(struct
 skip:
 	NAPI_GRO_CB(skb)->is_ipv6 = 0;
 	rcu_read_lock();
-	sk = static_branch_unlikely(&udp_encap_needed_key) ? udp4_lib_lookup_skb(skb, uh->source, uh->dest) : NULL;
+
+	if (static_branch_unlikely(&udp_encap_needed_key))
+		sk = udp4_gro_lookup_skb(skb, uh->source, uh->dest);
+
 	pp = udp_gro_receive(head, skb, uh, sk);
 	rcu_read_unlock();
 	return pp;
--- a/net/ipv6/udp_offload.c
+++ b/net/ipv6/udp_offload.c
@@ -111,12 +111,22 @@ out:
 	return segs;
 }
 
+static struct sock *udp6_gro_lookup_skb(struct sk_buff *skb, __be16 sport,
+					__be16 dport)
+{
+	const struct ipv6hdr *iph = skb_gro_network_header(skb);
+
+	return __udp6_lib_lookup(dev_net(skb->dev), &iph->saddr, sport,
+				 &iph->daddr, dport, inet6_iif(skb),
+				 inet6_sdif(skb), &udp_table, NULL);
+}
+
 INDIRECT_CALLABLE_SCOPE
 struct sk_buff *udp6_gro_receive(struct list_head *head, struct sk_buff *skb)
 {
 	struct udphdr *uh = udp_gro_udphdr(skb);
+	struct sock *sk = NULL;
 	struct sk_buff *pp;
-	struct sock *sk;
 
 	if (unlikely(!uh))
 		goto flush;
@@ -135,7 +145,10 @@ struct sk_buff *udp6_gro_receive(struct
 skip:
 	NAPI_GRO_CB(skb)->is_ipv6 = 1;
 	rcu_read_lock();
-	sk = static_branch_unlikely(&udpv6_encap_needed_key) ? udp6_lib_lookup_skb(skb, uh->source, uh->dest) : NULL;
+
+	if (static_branch_unlikely(&udpv6_encap_needed_key))
+		sk = udp6_gro_lookup_skb(skb, uh->source, uh->dest);
+
 	pp = udp_gro_receive(head, skb, uh, sk);
 	rcu_read_unlock();
 	return pp;


