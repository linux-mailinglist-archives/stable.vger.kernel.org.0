Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB6113D5ECC
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 17:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236168AbhGZPLf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:11:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:51214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237336AbhGZPKt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:10:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C32F60F02;
        Mon, 26 Jul 2021 15:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314676;
        bh=t2pUdxOAlA6Vx2D0LgeUf3paFGelNw3p6hR9eZP7nCg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z9JuzniQvDPCrfO1a7OTyLUWwEdEco/FdWRSYho+7H1VhImdCvVY54OLV+VBSAxmG
         6cE7FVaudWxYdA1nSrdtCPGfrHMtdX4AVdK4NHtB9qsCdedoseHeC5hR9gkDSrZOO1
         KN/sLWrq6dy3P56Ntd8lO+TVHrBzxZL4yEqhFJh0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jianlin Shi <jishi@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 052/120] net: ip_tunnel: fix mtu calculation for ETHER tunnel devices
Date:   Mon, 26 Jul 2021 17:38:24 +0200
Message-Id: <20210726153834.050445874@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153832.339431936@linuxfoundation.org>
References: <20210726153832.339431936@linuxfoundation.org>
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
 net/ipv4/ip_tunnel.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -330,7 +330,7 @@ static int ip_tunnel_bind_dev(struct net
 	}
 
 	dev->needed_headroom = t_hlen + hlen;
-	mtu -= t_hlen;
+	mtu -= t_hlen + (dev->type == ARPHRD_ETHER ? dev->hard_header_len : 0);
 
 	if (mtu < IPV4_MIN_MTU)
 		mtu = IPV4_MIN_MTU;
@@ -361,6 +361,9 @@ static struct ip_tunnel *ip_tunnel_creat
 	t_hlen = nt->hlen + sizeof(struct iphdr);
 	dev->min_mtu = ETH_MIN_MTU;
 	dev->max_mtu = IP_MAX_MTU - t_hlen;
+	if (dev->type == ARPHRD_ETHER)
+		dev->max_mtu -= dev->hard_header_len;
+
 	ip_tunnel_add(itn, nt);
 	return nt;
 
@@ -502,13 +505,18 @@ static int tnl_update_pmtu(struct net_de
 			    const struct iphdr *inner_iph)
 {
 	struct ip_tunnel *tunnel = netdev_priv(dev);
-	int pkt_size = skb->len - tunnel->hlen;
+	int pkt_size;
 	int mtu;
 
-	if (df)
+	pkt_size = skb->len - tunnel->hlen;
+	pkt_size -= dev->type == ARPHRD_ETHER ? dev->hard_header_len : 0;
+
+	if (df) {
 		mtu = dst_mtu(&rt->dst) - (sizeof(struct iphdr) + tunnel->hlen);
-	else
+		mtu -= dev->type == ARPHRD_ETHER ? dev->hard_header_len : 0;
+	} else {
 		mtu = skb_dst(skb) ? dst_mtu(skb_dst(skb)) : dev->mtu;
+	}
 
 	skb_dst_update_pmtu_no_confirm(skb, mtu);
 
@@ -936,6 +944,9 @@ int __ip_tunnel_change_mtu(struct net_de
 	int t_hlen = tunnel->hlen + sizeof(struct iphdr);
 	int max_mtu = IP_MAX_MTU - t_hlen;
 
+	if (dev->type == ARPHRD_ETHER)
+		max_mtu -= dev->hard_header_len;
+
 	if (new_mtu < ETH_MIN_MTU)
 		return -EINVAL;
 
@@ -1113,6 +1124,9 @@ int ip_tunnel_newlink(struct net_device
 	if (tb[IFLA_MTU]) {
 		unsigned int max = IP_MAX_MTU - (nt->hlen + sizeof(struct iphdr));
 
+		if (dev->type == ARPHRD_ETHER)
+			max -= dev->hard_header_len;
+
 		mtu = clamp(dev->mtu, (unsigned int)ETH_MIN_MTU, max);
 	}
 


