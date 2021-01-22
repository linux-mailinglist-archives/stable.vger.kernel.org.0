Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA554300549
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 15:25:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728662AbhAVOYo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 09:24:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:40754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728646AbhAVOYP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:24:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4470C23B98;
        Fri, 22 Jan 2021 14:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611325099;
        bh=Rpm5wm1IyjsK0e0/7TgXJjNjRuXwKrAGdDwAGzvZVxU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZetzQxahpDaR9YhO4AV2OZIwy2pROPW0CZ5Zxi8uqcK2p9bTUs5uK2sTrLKIiUAkG
         hWlwuJrpPk6/9bTSYzAzdYmujEKC/UDtAO7dL522woD0kZGlbRwUIl2d0K7u3HwGf8
         Klur/PRcli3VdCZG48XEwqRdjsz2BWNrzvsKMqxA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 15/43] net: ipv6: Validate GSO SKB before finish IPv6 processing
Date:   Fri, 22 Jan 2021 15:12:31 +0100
Message-Id: <20210122135736.261336762@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135735.652681690@linuxfoundation.org>
References: <20210122135735.652681690@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

[ Upstream commit b210de4f8c97d57de051e805686248ec4c6cfc52 ]

There are cases where GSO segment's length exceeds the egress MTU:
 - Forwarding of a TCP GRO skb, when DF flag is not set.
 - Forwarding of an skb that arrived on a virtualisation interface
   (virtio-net/vhost/tap) with TSO/GSO size set by other network
   stack.
 - Local GSO skb transmitted on an NETIF_F_TSO tunnel stacked over an
   interface with a smaller MTU.
 - Arriving GRO skb (or GSO skb in a virtualised environment) that is
   bridged to a NETIF_F_TSO tunnel stacked over an interface with an
   insufficient MTU.

If so:
 - Consume the SKB and its segments.
 - Issue an ICMP packet with 'Packet Too Big' message containing the
   MTU, allowing the source host to reduce its Path MTU appropriately.

Note: These cases are handled in the same manner in IPv4 output finish.
This patch aligns the behavior of IPv6 and the one of IPv4.

Fixes: 9e50849054a4 ("netfilter: ipv6: move POSTROUTING invocation before fragmentation")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://lore.kernel.org/r/1610027418-30438-1-git-send-email-ayal@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_output.c |   41 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 40 insertions(+), 1 deletion(-)

--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -125,8 +125,43 @@ static int ip6_finish_output2(struct net
 	return -EINVAL;
 }
 
+static int
+ip6_finish_output_gso_slowpath_drop(struct net *net, struct sock *sk,
+				    struct sk_buff *skb, unsigned int mtu)
+{
+	struct sk_buff *segs, *nskb;
+	netdev_features_t features;
+	int ret = 0;
+
+	/* Please see corresponding comment in ip_finish_output_gso
+	 * describing the cases where GSO segment length exceeds the
+	 * egress MTU.
+	 */
+	features = netif_skb_features(skb);
+	segs = skb_gso_segment(skb, features & ~NETIF_F_GSO_MASK);
+	if (IS_ERR_OR_NULL(segs)) {
+		kfree_skb(skb);
+		return -ENOMEM;
+	}
+
+	consume_skb(skb);
+
+	skb_list_walk_safe(segs, segs, nskb) {
+		int err;
+
+		skb_mark_not_on_list(segs);
+		err = ip6_fragment(net, sk, segs, ip6_finish_output2);
+		if (err && ret == 0)
+			ret = err;
+	}
+
+	return ret;
+}
+
 static int __ip6_finish_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 {
+	unsigned int mtu;
+
 #if defined(CONFIG_NETFILTER) && defined(CONFIG_XFRM)
 	/* Policy lookup after SNAT yielded a new policy */
 	if (skb_dst(skb)->xfrm) {
@@ -135,7 +170,11 @@ static int __ip6_finish_output(struct ne
 	}
 #endif
 
-	if ((skb->len > ip6_skb_dst_mtu(skb) && !skb_is_gso(skb)) ||
+	mtu = ip6_skb_dst_mtu(skb);
+	if (skb_is_gso(skb) && !skb_gso_validate_network_len(skb, mtu))
+		return ip6_finish_output_gso_slowpath_drop(net, sk, skb, mtu);
+
+	if ((skb->len > mtu && !skb_is_gso(skb)) ||
 	    dst_allfrag(skb_dst(skb)) ||
 	    (IP6CB(skb)->frag_max_size && skb->len > IP6CB(skb)->frag_max_size))
 		return ip6_fragment(net, sk, skb, ip6_finish_output2);


