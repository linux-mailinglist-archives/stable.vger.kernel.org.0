Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6E53D269F
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 17:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232541AbhGVOoW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 10:44:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:34284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232588AbhGVOoV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 10:44:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1EDFA6109D;
        Thu, 22 Jul 2021 15:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626967496;
        bh=9/+qWw/gJoaAgjwyuADFiTREzRd//BeU9ZK/1xgQTW0=;
        h=Subject:To:Cc:From:Date:From;
        b=ATN1JWCT7J0Hxri6jeJi6Wd0tMlZYcxHpaDqFeofbhsk4Ri6KUtKySDrpTkxliR4B
         1AuE+1JJScAvWSbdkWSw5oVU48PjlPl1bpzK28ky5D5VaGcR+msQkaMU8MwM59ZnON
         cBW698Ni6i4eTRPsKz2Ke+Hmax9Y1h0a9kWOi9RQ=
Subject: FAILED: patch "[PATCH] net: ip_tunnel: fix mtu calculation for ETHER tunnel devices" failed to apply to 4.19-stable tree
To:     liuhangbin@gmail.com, davem@davemloft.net, jishi@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 22 Jul 2021 17:24:54 +0200
Message-ID: <1626967494217153@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 9992a078b1771da354ac1f9737e1e639b687caa2 Mon Sep 17 00:00:00 2001
From: Hangbin Liu <liuhangbin@gmail.com>
Date: Fri, 9 Jul 2021 11:45:02 +0800
Subject: [PATCH] net: ip_tunnel: fix mtu calculation for ETHER tunnel devices

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

diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
index f6cc26de5ed3..0dca00745ac3 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -317,7 +317,7 @@ static int ip_tunnel_bind_dev(struct net_device *dev)
 	}
 
 	dev->needed_headroom = t_hlen + hlen;
-	mtu -= t_hlen;
+	mtu -= t_hlen + (dev->type == ARPHRD_ETHER ? dev->hard_header_len : 0);
 
 	if (mtu < IPV4_MIN_MTU)
 		mtu = IPV4_MIN_MTU;
@@ -348,6 +348,9 @@ static struct ip_tunnel *ip_tunnel_create(struct net *net,
 	t_hlen = nt->hlen + sizeof(struct iphdr);
 	dev->min_mtu = ETH_MIN_MTU;
 	dev->max_mtu = IP_MAX_MTU - t_hlen;
+	if (dev->type == ARPHRD_ETHER)
+		dev->max_mtu -= dev->hard_header_len;
+
 	ip_tunnel_add(itn, nt);
 	return nt;
 
@@ -489,11 +492,14 @@ static int tnl_update_pmtu(struct net_device *dev, struct sk_buff *skb,
 
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
@@ -972,6 +978,9 @@ int __ip_tunnel_change_mtu(struct net_device *dev, int new_mtu, bool strict)
 	int t_hlen = tunnel->hlen + sizeof(struct iphdr);
 	int max_mtu = IP_MAX_MTU - t_hlen;
 
+	if (dev->type == ARPHRD_ETHER)
+		max_mtu -= dev->hard_header_len;
+
 	if (new_mtu < ETH_MIN_MTU)
 		return -EINVAL;
 
@@ -1149,6 +1158,9 @@ int ip_tunnel_newlink(struct net_device *dev, struct nlattr *tb[],
 	if (tb[IFLA_MTU]) {
 		unsigned int max = IP_MAX_MTU - (nt->hlen + sizeof(struct iphdr));
 
+		if (dev->type == ARPHRD_ETHER)
+			max -= dev->hard_header_len;
+
 		mtu = clamp(dev->mtu, (unsigned int)ETH_MIN_MTU, max);
 	}
 

