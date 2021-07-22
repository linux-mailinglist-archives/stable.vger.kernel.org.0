Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C1593D2915
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233891AbhGVQA6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:00:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:34178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233481AbhGVP7L (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:59:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1DFC161375;
        Thu, 22 Jul 2021 16:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626971983;
        bh=KVJQDHg+koXl4QxZHfvKYjYa/TXmNjwLGPHmjBZWMHk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kyY5bjIKrRL/JH657WhtgjtEDCUkAMZodo2z6VeNKJ/3HngtDFl52TJx7+iJs5KOh
         UyLzXEi+k2tgqxivrLEDwjt5bJF8RYuFUKo9UmYshO3GdFhIwcJaa+inc6JXJzWpKh
         vZVnP8AaHeWYXQiAuWhFV/AdpOMxjjFd+GLI9U3Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jianlin Shi <jishi@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 102/125] net: ip_tunnel: fix mtu calculation for ETHER tunnel devices
Date:   Thu, 22 Jul 2021 18:31:33 +0200
Message-Id: <20210722155628.079907771@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155624.672583740@linuxfoundation.org>
References: <20210722155624.672583740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

commit 9992a078b1771da354ac1f9737e1e639b687caa2 upstream.

Commit 28e104d00281 ("net: ip_tunnel: fix mtu calculation") removed
dev->hard_header_len subtraction when calculate MTU for tunnel devices
as there is an overhead for device that has header_ops.

But there are ETHER tunnel devices, like gre_tap or erspan, which don't
have header_ops but set dev->hard_header_len during setup. This makes
pkts greater than (MTU - ETH_HLEN) could not be xmited. Fix it by
subtracting the ETHER tunnel devices' dev->hard_header_len for MTU
calculation.

Fixes: 28e104d00281 ("net: ip_tunnel: fix mtu calculation")
Reported-by: Jianlin Shi <jishi@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ip_tunnel.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -317,7 +317,7 @@ static int ip_tunnel_bind_dev(struct net
 	}
 
 	dev->needed_headroom = t_hlen + hlen;
-	mtu -= t_hlen;
+	mtu -= t_hlen + (dev->type == ARPHRD_ETHER ? dev->hard_header_len : 0);
 
 	if (mtu < IPV4_MIN_MTU)
 		mtu = IPV4_MIN_MTU;
@@ -348,6 +348,9 @@ static struct ip_tunnel *ip_tunnel_creat
 	t_hlen = nt->hlen + sizeof(struct iphdr);
 	dev->min_mtu = ETH_MIN_MTU;
 	dev->max_mtu = IP_MAX_MTU - t_hlen;
+	if (dev->type == ARPHRD_ETHER)
+		dev->max_mtu -= dev->hard_header_len;
+
 	ip_tunnel_add(itn, nt);
 	return nt;
 
@@ -489,11 +492,14 @@ static int tnl_update_pmtu(struct net_de
 
 	tunnel_hlen = md ? tunnel_hlen : tunnel->hlen;
 	pkt_size = skb->len - tunnel_hlen;
+	pkt_size -= dev->type == ARPHRD_ETHER ? dev->hard_header_len : 0;
 
-	if (df)
+	if (df) {
 		mtu = dst_mtu(&rt->dst) - (sizeof(struct iphdr) + tunnel_hlen);
-	else
+		mtu -= dev->type == ARPHRD_ETHER ? dev->hard_header_len : 0;
+	} else {
 		mtu = skb_valid_dst(skb) ? dst_mtu(skb_dst(skb)) : dev->mtu;
+	}
 
 	if (skb_valid_dst(skb))
 		skb_dst_update_pmtu_no_confirm(skb, mtu);
@@ -972,6 +978,9 @@ int __ip_tunnel_change_mtu(struct net_de
 	int t_hlen = tunnel->hlen + sizeof(struct iphdr);
 	int max_mtu = IP_MAX_MTU - t_hlen;
 
+	if (dev->type == ARPHRD_ETHER)
+		max_mtu -= dev->hard_header_len;
+
 	if (new_mtu < ETH_MIN_MTU)
 		return -EINVAL;
 
@@ -1149,6 +1158,9 @@ int ip_tunnel_newlink(struct net_device
 	if (tb[IFLA_MTU]) {
 		unsigned int max = IP_MAX_MTU - (nt->hlen + sizeof(struct iphdr));
 
+		if (dev->type == ARPHRD_ETHER)
+			max -= dev->hard_header_len;
+
 		mtu = clamp(dev->mtu, (unsigned int)ETH_MIN_MTU, max);
 	}
 


