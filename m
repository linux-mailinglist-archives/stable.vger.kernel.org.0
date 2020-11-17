Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B8952B6020
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:07:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728915AbgKQNGl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:06:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:60982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728524AbgKQNGf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:06:35 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 519A5241A6;
        Tue, 17 Nov 2020 13:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605618395;
        bh=9c5bkrfss4g7vceJfjMpSNTR3gIzb6S8ksUQ+HROHiM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sv0rF0W8zIlEv3fnziIv6bvaJ4NAtz14TtpN2oGds1nS+QWSXMQK3guuXSnSkhO0e
         tUtzjCgEoXyRNTUNT9H5x3C377MrKehRSaRc+PKptF/p6Qet73cYpx4Tj1dfxDX8C/
         sA6dKMUjhzMs0bQT+cyIafB86ilwCSlLp3hmv3eQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qiuyu Xiao <qiuyu.xiao.qyx@gmail.com>,
        Mark Gray <mark.d.gray@redhat.com>,
        Greg Rose <gvrose8192@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 18/64] geneve: add transport ports in route lookup for geneve
Date:   Tue, 17 Nov 2020 14:04:41 +0100
Message-Id: <20201117122107.025773109@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122106.144800239@linuxfoundation.org>
References: <20201117122106.144800239@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Gray <mark.d.gray@redhat.com>

commit 34beb21594519ce64a55a498c2fe7d567bc1ca20 upstream.

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
[bwh: Backported to 4.4:
 - Use geneve->dst_port instead of geneve->cfg.info.key.tp_dst
 - Adjust context]
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/geneve.c | 36 ++++++++++++++++++++++++++----------
 1 file changed, 26 insertions(+), 10 deletions(-)

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index ec13e2ae6d16e..ee38299f9c578 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -711,7 +711,8 @@ static int geneve6_build_skb(struct dst_entry *dst, struct sk_buff *skb,
 static struct rtable *geneve_get_v4_rt(struct sk_buff *skb,
 				       struct net_device *dev,
 				       struct flowi4 *fl4,
-				       struct ip_tunnel_info *info)
+				       struct ip_tunnel_info *info,
+				       __be16 dport, __be16 sport)
 {
 	struct geneve_dev *geneve = netdev_priv(dev);
 	struct rtable *rt = NULL;
@@ -720,6 +721,8 @@ static struct rtable *geneve_get_v4_rt(struct sk_buff *skb,
 	memset(fl4, 0, sizeof(*fl4));
 	fl4->flowi4_mark = skb->mark;
 	fl4->flowi4_proto = IPPROTO_UDP;
+	fl4->fl4_dport = dport;
+	fl4->fl4_sport = sport;
 
 	if (info) {
 		fl4->daddr = info->key.u.ipv4.dst;
@@ -754,7 +757,8 @@ static struct rtable *geneve_get_v4_rt(struct sk_buff *skb,
 static struct dst_entry *geneve_get_v6_dst(struct sk_buff *skb,
 					   struct net_device *dev,
 					   struct flowi6 *fl6,
-					   struct ip_tunnel_info *info)
+					   struct ip_tunnel_info *info,
+					   __be16 dport, __be16 sport)
 {
 	struct geneve_dev *geneve = netdev_priv(dev);
 	struct geneve_sock *gs6 = geneve->sock6;
@@ -764,6 +768,8 @@ static struct dst_entry *geneve_get_v6_dst(struct sk_buff *skb,
 	memset(fl6, 0, sizeof(*fl6));
 	fl6->flowi6_mark = skb->mark;
 	fl6->flowi6_proto = IPPROTO_UDP;
+	fl6->fl6_dport = dport;
+	fl6->fl6_sport = sport;
 
 	if (info) {
 		fl6->daddr = info->key.u.ipv6.dst;
@@ -834,13 +840,14 @@ static netdev_tx_t geneve_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 			goto tx_error;
 	}
 
-	rt = geneve_get_v4_rt(skb, dev, &fl4, info);
+	sport = udp_flow_src_port(geneve->net, skb, 1, USHRT_MAX, true);
+	rt = geneve_get_v4_rt(skb, dev, &fl4, info,
+			      geneve->dst_port, sport);
 	if (IS_ERR(rt)) {
 		err = PTR_ERR(rt);
 		goto tx_error;
 	}
 
-	sport = udp_flow_src_port(geneve->net, skb, 1, USHRT_MAX, true);
 	skb_reset_mac_header(skb);
 
 	if (info) {
@@ -916,13 +923,14 @@ static netdev_tx_t geneve6_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 		}
 	}
 
-	dst = geneve_get_v6_dst(skb, dev, &fl6, info);
+	sport = udp_flow_src_port(geneve->net, skb, 1, USHRT_MAX, true);
+	dst = geneve_get_v6_dst(skb, dev, &fl6, info,
+				geneve->dst_port, sport);
 	if (IS_ERR(dst)) {
 		err = PTR_ERR(dst);
 		goto tx_error;
 	}
 
-	sport = udp_flow_src_port(geneve->net, skb, 1, USHRT_MAX, true);
 	skb_reset_mac_header(skb);
 
 	if (info) {
@@ -1011,9 +1019,14 @@ static int geneve_fill_metadata_dst(struct net_device *dev, struct sk_buff *skb)
 	struct dst_entry *dst;
 	struct flowi6 fl6;
 #endif
+	__be16 sport;
 
 	if (ip_tunnel_info_af(info) == AF_INET) {
-		rt = geneve_get_v4_rt(skb, dev, &fl4, info);
+		sport = udp_flow_src_port(geneve->net, skb,
+					  1, USHRT_MAX, true);
+
+		rt = geneve_get_v4_rt(skb, dev, &fl4, info,
+				      geneve->dst_port, sport);
 		if (IS_ERR(rt))
 			return PTR_ERR(rt);
 
@@ -1021,7 +1034,11 @@ static int geneve_fill_metadata_dst(struct net_device *dev, struct sk_buff *skb)
 		info->key.u.ipv4.src = fl4.saddr;
 #if IS_ENABLED(CONFIG_IPV6)
 	} else if (ip_tunnel_info_af(info) == AF_INET6) {
-		dst = geneve_get_v6_dst(skb, dev, &fl6, info);
+		sport = udp_flow_src_port(geneve->net, skb,
+					  1, USHRT_MAX, true);
+
+		dst = geneve_get_v6_dst(skb, dev, &fl6, info,
+					geneve->dst_port, sport);
 		if (IS_ERR(dst))
 			return PTR_ERR(dst);
 
@@ -1032,8 +1049,7 @@ static int geneve_fill_metadata_dst(struct net_device *dev, struct sk_buff *skb)
 		return -EINVAL;
 	}
 
-	info->key.tp_src = udp_flow_src_port(geneve->net, skb,
-					     1, USHRT_MAX, true);
+	info->key.tp_src = sport;
 	info->key.tp_dst = geneve->dst_port;
 	return 0;
 }
-- 
2.27.0



