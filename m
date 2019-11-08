Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1507DF56A3
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:04:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388171AbfKHTKC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:10:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:42080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391825AbfKHTKB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:10:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 302D921D7B;
        Fri,  8 Nov 2019 19:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573240200;
        bh=/IrYZ2gAkygTZSpQUuLTJGdhRVZlUQDCSL45dT1z7v4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M3NQgZzZtwe+E4vFi5Ek5d8EVpCPD+euTSS8nioFxnrHcb/SEOyZ+jI5qNXvDw7vN
         Mh6OPvzlgjpU5wqx6mOpn/uiaJ+68KyU6e5XmdW4a4KqjCBVbcjVj70OoR8Z44r0MD
         GaVvV3Iv5UktdiN0NK/s08vggGtgZCDWAdMV33TQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Thomas Bartschies <Thomas.Bartschies@cvk.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 124/140] net: ensure correct skb->tstamp in various fragmenters
Date:   Fri,  8 Nov 2019 19:50:52 +0100
Message-Id: <20191108174912.529483559@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174900.189064908@linuxfoundation.org>
References: <20191108174900.189064908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 9669fffc1415bb0c30e5d2ec98a8e1c3a418cb9c ]

Thomas found that some forwarded packets would be stuck
in FQ packet scheduler because their skb->tstamp contained
timestamps far in the future.

We thought we addressed this point in commit 8203e2d844d3
("net: clear skb->tstamp in forwarding paths") but there
is still an issue when/if a packet needs to be fragmented.

In order to meet EDT requirements, we have to make sure all
fragments get the original skb->tstamp.

Note that this original skb->tstamp should be zero in
forwarding path, but might have a non zero value in
output path if user decided so.

Fixes: fb420d5d91c1 ("tcp/fq: move back to CLOCK_MONOTONIC")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Thomas Bartschies <Thomas.Bartschies@cvk.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/netfilter/nf_conntrack_bridge.c |    3 +++
 net/ipv4/ip_output.c                       |    3 +++
 net/ipv6/ip6_output.c                      |    3 +++
 net/ipv6/netfilter.c                       |    3 +++
 4 files changed, 12 insertions(+)

--- a/net/bridge/netfilter/nf_conntrack_bridge.c
+++ b/net/bridge/netfilter/nf_conntrack_bridge.c
@@ -34,6 +34,7 @@ static int nf_br_ip_fragment(struct net
 {
 	int frag_max_size = BR_INPUT_SKB_CB(skb)->frag_max_size;
 	unsigned int hlen, ll_rs, mtu;
+	ktime_t tstamp = skb->tstamp;
 	struct ip_frag_state state;
 	struct iphdr *iph;
 	int err;
@@ -81,6 +82,7 @@ static int nf_br_ip_fragment(struct net
 			if (iter.frag)
 				ip_fraglist_prepare(skb, &iter);
 
+			skb->tstamp = tstamp;
 			err = output(net, sk, data, skb);
 			if (err || !iter.frag)
 				break;
@@ -105,6 +107,7 @@ slow_path:
 			goto blackhole;
 		}
 
+		skb2->tstamp = tstamp;
 		err = output(net, sk, data, skb2);
 		if (err)
 			goto blackhole;
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -771,6 +771,7 @@ int ip_do_fragment(struct net *net, stru
 	struct rtable *rt = skb_rtable(skb);
 	unsigned int mtu, hlen, ll_rs;
 	struct ip_fraglist_iter iter;
+	ktime_t tstamp = skb->tstamp;
 	struct ip_frag_state state;
 	int err = 0;
 
@@ -846,6 +847,7 @@ int ip_do_fragment(struct net *net, stru
 				ip_fraglist_prepare(skb, &iter);
 			}
 
+			skb->tstamp = tstamp;
 			err = output(net, sk, skb);
 
 			if (!err)
@@ -901,6 +903,7 @@ slow_path:
 		/*
 		 *	Put this fragment into the sending queue.
 		 */
+		skb2->tstamp = tstamp;
 		err = output(net, sk, skb2);
 		if (err)
 			goto fail;
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -768,6 +768,7 @@ int ip6_fragment(struct net *net, struct
 				inet6_sk(skb->sk) : NULL;
 	struct ip6_frag_state state;
 	unsigned int mtu, hlen, nexthdr_offset;
+	ktime_t tstamp = skb->tstamp;
 	int hroom, err = 0;
 	__be32 frag_id;
 	u8 *prevhdr, nexthdr = 0;
@@ -855,6 +856,7 @@ int ip6_fragment(struct net *net, struct
 			if (iter.frag)
 				ip6_fraglist_prepare(skb, &iter);
 
+			skb->tstamp = tstamp;
 			err = output(net, sk, skb);
 			if (!err)
 				IP6_INC_STATS(net, ip6_dst_idev(&rt->dst),
@@ -913,6 +915,7 @@ slow_path:
 		/*
 		 *	Put this fragment into the sending queue.
 		 */
+		frag->tstamp = tstamp;
 		err = output(net, sk, frag);
 		if (err)
 			goto fail;
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -119,6 +119,7 @@ int br_ip6_fragment(struct net *net, str
 				  struct sk_buff *))
 {
 	int frag_max_size = BR_INPUT_SKB_CB(skb)->frag_max_size;
+	ktime_t tstamp = skb->tstamp;
 	struct ip6_frag_state state;
 	u8 *prevhdr, nexthdr = 0;
 	unsigned int mtu, hlen;
@@ -183,6 +184,7 @@ int br_ip6_fragment(struct net *net, str
 			if (iter.frag)
 				ip6_fraglist_prepare(skb, &iter);
 
+			skb->tstamp = tstamp;
 			err = output(net, sk, data, skb);
 			if (err || !iter.frag)
 				break;
@@ -215,6 +217,7 @@ slow_path:
 			goto blackhole;
 		}
 
+		skb2->tstamp = tstamp;
 		err = output(net, sk, data, skb2);
 		if (err)
 			goto blackhole;


