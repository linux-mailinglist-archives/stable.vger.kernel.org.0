Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45567313817
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:37:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232711AbhBHPgi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:36:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:33710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233373AbhBHPRa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:17:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7252364ED4;
        Mon,  8 Feb 2021 15:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797109;
        bh=UzyqG8TJcBdAVLiUiSmFGcQSiCH9dZJSk6xSdRB5rGY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gs/FjQ7L3MEYdZWzvnhOsbg+g92g107FBrGr7THG+dLgTC9qoi4jGQMwrhYfKxGVv
         BibPrWEOr1LyhOxDTkUmLTdqdpmgP0LsXcgqWFjqH5VnXXuJPkGqaV0PWx8Ku5SaNG
         qO+sYCl1Xn+z5l8cISp2ryeiPbP8YCdNYTUrslbc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Slava Bacherikov <mail@slava.cc>,
        Vadim Fedorenko <vfedorenko@novek.ru>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 62/65] net: ip_tunnel: fix mtu calculation
Date:   Mon,  8 Feb 2021 16:01:34 +0100
Message-Id: <20210208145812.615442715@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145810.230485165@linuxfoundation.org>
References: <20210208145810.230485165@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vadim Fedorenko <vfedorenko@novek.ru>

commit 28e104d00281ade30250b24e098bf50887671ea4 upstream.

dev->hard_header_len for tunnel interface is set only when header_ops
are set too and already contains full overhead of any tunnel encapsulation.
That's why there is not need to use this overhead twice in mtu calc.

Fixes: fdafed459998 ("ip_gre: set dev->hard_header_len and dev->needed_headroom properly")
Reported-by: Slava Bacherikov <mail@slava.cc>
Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
Link: https://lore.kernel.org/r/1611959267-20536-1-git-send-email-vfedorenko@novek.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ip_tunnel.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -317,7 +317,7 @@ static int ip_tunnel_bind_dev(struct net
 	}
 
 	dev->needed_headroom = t_hlen + hlen;
-	mtu -= (dev->hard_header_len + t_hlen);
+	mtu -= t_hlen;
 
 	if (mtu < IPV4_MIN_MTU)
 		mtu = IPV4_MIN_MTU;
@@ -347,7 +347,7 @@ static struct ip_tunnel *ip_tunnel_creat
 	nt = netdev_priv(dev);
 	t_hlen = nt->hlen + sizeof(struct iphdr);
 	dev->min_mtu = ETH_MIN_MTU;
-	dev->max_mtu = IP_MAX_MTU - dev->hard_header_len - t_hlen;
+	dev->max_mtu = IP_MAX_MTU - t_hlen;
 	ip_tunnel_add(itn, nt);
 	return nt;
 
@@ -494,11 +494,10 @@ static int tnl_update_pmtu(struct net_de
 	int mtu;
 
 	tunnel_hlen = md ? tunnel_hlen : tunnel->hlen;
-	pkt_size = skb->len - tunnel_hlen - dev->hard_header_len;
+	pkt_size = skb->len - tunnel_hlen;
 
 	if (df)
-		mtu = dst_mtu(&rt->dst) - dev->hard_header_len
-					- sizeof(struct iphdr) - tunnel_hlen;
+		mtu = dst_mtu(&rt->dst) - (sizeof(struct iphdr) + tunnel_hlen);
 	else
 		mtu = skb_valid_dst(skb) ? dst_mtu(skb_dst(skb)) : dev->mtu;
 
@@ -964,7 +963,7 @@ int __ip_tunnel_change_mtu(struct net_de
 {
 	struct ip_tunnel *tunnel = netdev_priv(dev);
 	int t_hlen = tunnel->hlen + sizeof(struct iphdr);
-	int max_mtu = IP_MAX_MTU - dev->hard_header_len - t_hlen;
+	int max_mtu = IP_MAX_MTU - t_hlen;
 
 	if (new_mtu < ETH_MIN_MTU)
 		return -EINVAL;
@@ -1141,10 +1140,9 @@ int ip_tunnel_newlink(struct net_device
 
 	mtu = ip_tunnel_bind_dev(dev);
 	if (tb[IFLA_MTU]) {
-		unsigned int max = IP_MAX_MTU - dev->hard_header_len - nt->hlen;
+		unsigned int max = IP_MAX_MTU - (nt->hlen + sizeof(struct iphdr));
 
-		mtu = clamp(dev->mtu, (unsigned int)ETH_MIN_MTU,
-			    (unsigned int)(max - sizeof(struct iphdr)));
+		mtu = clamp(dev->mtu, (unsigned int)ETH_MIN_MTU, max);
 	}
 
 	err = dev_set_mtu(dev, mtu);


