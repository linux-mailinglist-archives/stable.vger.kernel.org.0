Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B46F1794CC
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729757AbfG2Tff (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:35:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:49914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729752AbfG2Tfe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:35:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2BEC2171F;
        Mon, 29 Jul 2019 19:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564428933;
        bh=o+gUEAdqo4k1GnCYrjiQ2VeC9eCNVj157bg/jRvCF7M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DguS15cK8os6vITSHrPZZrxabW5PYmtE9UcqrKWNAlupvKzPrme9M3G+T902UOtaN
         WMxNlnTA1B63P7lOXeOol2L8nlMmOzhvbUSitRO3WbxzwENWGUOrhtpMtPwBKvhp6n
         mPTgFA3engyyp5b/BMi+2+U+PYlAfmgp2nv4jQ/A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Kosyh <p.kosyh@gmail.com>,
        David Ahern <dsa@cumulusnetworks.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 193/293] vrf: make sure skb->data contains ip header to make routing
Date:   Mon, 29 Jul 2019 21:21:24 +0200
Message-Id: <20190729190839.257346175@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190820.321094988@linuxfoundation.org>
References: <20190729190820.321094988@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Kosyh <p.kosyh@gmail.com>

[ Upstream commit 107e47cc80ec37cb332bd41b22b1c7779e22e018 ]

vrf_process_v4_outbound() and vrf_process_v6_outbound() do routing
using ip/ipv6 addresses, but don't make sure the header is available
in skb->data[] (skb_headlen() is less then header size).

Case:

1) igb driver from intel.
2) Packet size is greater then 255.
3) MPLS forwards to VRF device.

So, patch adds pskb_may_pull() calls in vrf_process_v4/v6_outbound()
functions.

Signed-off-by: Peter Kosyh <p.kosyh@gmail.com>
Reviewed-by: David Ahern <dsa@cumulusnetworks.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/vrf.c |   58 ++++++++++++++++++++++++++++++++----------------------
 1 file changed, 35 insertions(+), 23 deletions(-)

--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -167,23 +167,29 @@ static int vrf_ip6_local_out(struct net
 static netdev_tx_t vrf_process_v6_outbound(struct sk_buff *skb,
 					   struct net_device *dev)
 {
-	const struct ipv6hdr *iph = ipv6_hdr(skb);
+	const struct ipv6hdr *iph;
 	struct net *net = dev_net(skb->dev);
-	struct flowi6 fl6 = {
-		/* needed to match OIF rule */
-		.flowi6_oif = dev->ifindex,
-		.flowi6_iif = LOOPBACK_IFINDEX,
-		.daddr = iph->daddr,
-		.saddr = iph->saddr,
-		.flowlabel = ip6_flowinfo(iph),
-		.flowi6_mark = skb->mark,
-		.flowi6_proto = iph->nexthdr,
-		.flowi6_flags = FLOWI_FLAG_SKIP_NH_OIF,
-	};
+	struct flowi6 fl6;
 	int ret = NET_XMIT_DROP;
 	struct dst_entry *dst;
 	struct dst_entry *dst_null = &net->ipv6.ip6_null_entry->dst;
 
+	if (!pskb_may_pull(skb, ETH_HLEN + sizeof(struct ipv6hdr)))
+		goto err;
+
+	iph = ipv6_hdr(skb);
+
+	memset(&fl6, 0, sizeof(fl6));
+	/* needed to match OIF rule */
+	fl6.flowi6_oif = dev->ifindex;
+	fl6.flowi6_iif = LOOPBACK_IFINDEX;
+	fl6.daddr = iph->daddr;
+	fl6.saddr = iph->saddr;
+	fl6.flowlabel = ip6_flowinfo(iph);
+	fl6.flowi6_mark = skb->mark;
+	fl6.flowi6_proto = iph->nexthdr;
+	fl6.flowi6_flags = FLOWI_FLAG_SKIP_NH_OIF;
+
 	dst = ip6_route_output(net, NULL, &fl6);
 	if (dst == dst_null)
 		goto err;
@@ -239,21 +245,27 @@ static int vrf_ip_local_out(struct net *
 static netdev_tx_t vrf_process_v4_outbound(struct sk_buff *skb,
 					   struct net_device *vrf_dev)
 {
-	struct iphdr *ip4h = ip_hdr(skb);
+	struct iphdr *ip4h;
 	int ret = NET_XMIT_DROP;
-	struct flowi4 fl4 = {
-		/* needed to match OIF rule */
-		.flowi4_oif = vrf_dev->ifindex,
-		.flowi4_iif = LOOPBACK_IFINDEX,
-		.flowi4_tos = RT_TOS(ip4h->tos),
-		.flowi4_flags = FLOWI_FLAG_ANYSRC | FLOWI_FLAG_SKIP_NH_OIF,
-		.flowi4_proto = ip4h->protocol,
-		.daddr = ip4h->daddr,
-		.saddr = ip4h->saddr,
-	};
+	struct flowi4 fl4;
 	struct net *net = dev_net(vrf_dev);
 	struct rtable *rt;
 
+	if (!pskb_may_pull(skb, ETH_HLEN + sizeof(struct iphdr)))
+		goto err;
+
+	ip4h = ip_hdr(skb);
+
+	memset(&fl4, 0, sizeof(fl4));
+	/* needed to match OIF rule */
+	fl4.flowi4_oif = vrf_dev->ifindex;
+	fl4.flowi4_iif = LOOPBACK_IFINDEX;
+	fl4.flowi4_tos = RT_TOS(ip4h->tos);
+	fl4.flowi4_flags = FLOWI_FLAG_ANYSRC | FLOWI_FLAG_SKIP_NH_OIF;
+	fl4.flowi4_proto = ip4h->protocol;
+	fl4.daddr = ip4h->daddr;
+	fl4.saddr = ip4h->saddr;
+
 	rt = ip_route_output_flow(net, &fl4, NULL);
 	if (IS_ERR(rt))
 		goto err;


