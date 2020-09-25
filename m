Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B29E2787BB
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728960AbgIYMty (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:49:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:53674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728970AbgIYMty (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:49:54 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E8A521D7A;
        Fri, 25 Sep 2020 12:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038193;
        bh=meVWnDSR8euJmXPeC1spN/R7Z3FvDGFuvQRTDwB1ae4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yGU0KDFdYWJhWAhd4w1m4UL0bWJPP9LbOFoz0einZg8wLoPoW0T2EP1EJjRYX+/7t
         epiVXQb/GjlCKTtKYEuWnOCuP6MsQPyLddNZhIm3XB+3X4KIUOoL2PHTYChFId4lVF
         qf6X2xlF8+kveFdkXTVQsFkElYpR1YruL8A/BxRM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qiuyu Xiao <qiuyu.xiao.qyx@gmail.com>,
        Mark Gray <mark.d.gray@redhat.com>,
        Greg Rose <gvrose8192@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.8 08/56] geneve: add transport ports in route lookup for geneve
Date:   Fri, 25 Sep 2020 14:47:58 +0200
Message-Id: <20200925124729.088935642@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925124727.878494124@linuxfoundation.org>
References: <20200925124727.878494124@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Gray <mark.d.gray@redhat.com>

[ Upstream commit 34beb21594519ce64a55a498c2fe7d567bc1ca20 ]

This patch adds transport ports information for route lookup so that
IPsec can select Geneve tunnel traffic to do encryption. This is
needed for OVS/OVN IPsec with encrypted Geneve tunnels.

This can be tested by configuring a host-host VPN using an IKE
daemon and specifying port numbers. For example, for an
Openswan-type configuration, the following parameters should be
configured on both hosts and IPsec set up as-per normal:

$ cat /etc/ipsec.conf

conn in
...
left=$IP1
right=$IP2
...
leftprotoport=udp/6081
rightprotoport=udp
...
conn out
...
left=$IP1
right=$IP2
...
leftprotoport=udp
rightprotoport=udp/6081
...

The tunnel can then be setup using "ip" on both hosts (but
changing the relevant IP addresses):

$ ip link add tun type geneve id 1000 remote $IP2
$ ip addr add 192.168.0.1/24 dev tun
$ ip link set tun up

This can then be tested by pinging from $IP1:

$ ping 192.168.0.2

Without this patch the traffic is unencrypted on the wire.

Fixes: 2d07dc79fe04 ("geneve: add initial netdev driver for GENEVE tunnels")
Signed-off-by: Qiuyu Xiao <qiuyu.xiao.qyx@gmail.com>
Signed-off-by: Mark Gray <mark.d.gray@redhat.com>
Reviewed-by: Greg Rose <gvrose8192@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/geneve.c |   37 +++++++++++++++++++++++++++----------
 1 file changed, 27 insertions(+), 10 deletions(-)

--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -773,7 +773,8 @@ static struct rtable *geneve_get_v4_rt(s
 				       struct net_device *dev,
 				       struct geneve_sock *gs4,
 				       struct flowi4 *fl4,
-				       const struct ip_tunnel_info *info)
+				       const struct ip_tunnel_info *info,
+				       __be16 dport, __be16 sport)
 {
 	bool use_cache = ip_tunnel_dst_cache_usable(skb, info);
 	struct geneve_dev *geneve = netdev_priv(dev);
@@ -789,6 +790,8 @@ static struct rtable *geneve_get_v4_rt(s
 	fl4->flowi4_proto = IPPROTO_UDP;
 	fl4->daddr = info->key.u.ipv4.dst;
 	fl4->saddr = info->key.u.ipv4.src;
+	fl4->fl4_dport = dport;
+	fl4->fl4_sport = sport;
 
 	tos = info->key.tos;
 	if ((tos == 1) && !geneve->collect_md) {
@@ -823,7 +826,8 @@ static struct dst_entry *geneve_get_v6_d
 					   struct net_device *dev,
 					   struct geneve_sock *gs6,
 					   struct flowi6 *fl6,
-					   const struct ip_tunnel_info *info)
+					   const struct ip_tunnel_info *info,
+					   __be16 dport, __be16 sport)
 {
 	bool use_cache = ip_tunnel_dst_cache_usable(skb, info);
 	struct geneve_dev *geneve = netdev_priv(dev);
@@ -839,6 +843,9 @@ static struct dst_entry *geneve_get_v6_d
 	fl6->flowi6_proto = IPPROTO_UDP;
 	fl6->daddr = info->key.u.ipv6.dst;
 	fl6->saddr = info->key.u.ipv6.src;
+	fl6->fl6_dport = dport;
+	fl6->fl6_sport = sport;
+
 	prio = info->key.tos;
 	if ((prio == 1) && !geneve->collect_md) {
 		prio = ip_tunnel_get_dsfield(ip_hdr(skb), skb);
@@ -885,14 +892,15 @@ static int geneve_xmit_skb(struct sk_buf
 	__be16 sport;
 	int err;
 
-	rt = geneve_get_v4_rt(skb, dev, gs4, &fl4, info);
+	sport = udp_flow_src_port(geneve->net, skb, 1, USHRT_MAX, true);
+	rt = geneve_get_v4_rt(skb, dev, gs4, &fl4, info,
+			      geneve->info.key.tp_dst, sport);
 	if (IS_ERR(rt))
 		return PTR_ERR(rt);
 
 	skb_tunnel_check_pmtu(skb, &rt->dst,
 			      GENEVE_IPV4_HLEN + info->options_len);
 
-	sport = udp_flow_src_port(geneve->net, skb, 1, USHRT_MAX, true);
 	if (geneve->collect_md) {
 		tos = ip_tunnel_ecn_encap(key->tos, ip_hdr(skb), skb);
 		ttl = key->ttl;
@@ -947,13 +955,14 @@ static int geneve6_xmit_skb(struct sk_bu
 	__be16 sport;
 	int err;
 
-	dst = geneve_get_v6_dst(skb, dev, gs6, &fl6, info);
+	sport = udp_flow_src_port(geneve->net, skb, 1, USHRT_MAX, true);
+	dst = geneve_get_v6_dst(skb, dev, gs6, &fl6, info,
+				geneve->info.key.tp_dst, sport);
 	if (IS_ERR(dst))
 		return PTR_ERR(dst);
 
 	skb_tunnel_check_pmtu(skb, dst, GENEVE_IPV6_HLEN + info->options_len);
 
-	sport = udp_flow_src_port(geneve->net, skb, 1, USHRT_MAX, true);
 	if (geneve->collect_md) {
 		prio = ip_tunnel_ecn_encap(key->tos, ip_hdr(skb), skb);
 		ttl = key->ttl;
@@ -1034,13 +1043,18 @@ static int geneve_fill_metadata_dst(stru
 {
 	struct ip_tunnel_info *info = skb_tunnel_info(skb);
 	struct geneve_dev *geneve = netdev_priv(dev);
+	__be16 sport;
 
 	if (ip_tunnel_info_af(info) == AF_INET) {
 		struct rtable *rt;
 		struct flowi4 fl4;
+
 		struct geneve_sock *gs4 = rcu_dereference(geneve->sock4);
+		sport = udp_flow_src_port(geneve->net, skb,
+					  1, USHRT_MAX, true);
 
-		rt = geneve_get_v4_rt(skb, dev, gs4, &fl4, info);
+		rt = geneve_get_v4_rt(skb, dev, gs4, &fl4, info,
+				      geneve->info.key.tp_dst, sport);
 		if (IS_ERR(rt))
 			return PTR_ERR(rt);
 
@@ -1050,9 +1064,13 @@ static int geneve_fill_metadata_dst(stru
 	} else if (ip_tunnel_info_af(info) == AF_INET6) {
 		struct dst_entry *dst;
 		struct flowi6 fl6;
+
 		struct geneve_sock *gs6 = rcu_dereference(geneve->sock6);
+		sport = udp_flow_src_port(geneve->net, skb,
+					  1, USHRT_MAX, true);
 
-		dst = geneve_get_v6_dst(skb, dev, gs6, &fl6, info);
+		dst = geneve_get_v6_dst(skb, dev, gs6, &fl6, info,
+					geneve->info.key.tp_dst, sport);
 		if (IS_ERR(dst))
 			return PTR_ERR(dst);
 
@@ -1063,8 +1081,7 @@ static int geneve_fill_metadata_dst(stru
 		return -EINVAL;
 	}
 
-	info->key.tp_src = udp_flow_src_port(geneve->net, skb,
-					     1, USHRT_MAX, true);
+	info->key.tp_src = sport;
 	info->key.tp_dst = geneve->info.key.tp_dst;
 	return 0;
 }


