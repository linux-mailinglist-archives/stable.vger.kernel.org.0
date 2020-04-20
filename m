Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47FC21B0C03
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 15:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbgDTMkY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 08:40:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:60758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727067AbgDTMkX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 08:40:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 13E922070B;
        Mon, 20 Apr 2020 12:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587386422;
        bh=D9Zh8lCgpiqB7HX8/NwmWCHrVq/g2Z7HfkRe/5ncGN8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f+FUgRIeQm6DdObh854xrZqX/IRa6qhVo6h4IsRwK5hLJ06GFpaYtYkBnAzROd8Ea
         o3Z2rY08wpuMessfTlt4pTrDKkFcXqxCtQ11nHaG+xVLbbAsyRbHvN50w9yjaqK95J
         I+KX3p4XsHf/GKBGBSTx4VG3iFgLe0iN5qXZVSzQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tim Stallard <code@timstallard.me.uk>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 17/65] net: icmp6: do not select saddr from iif when route has prefsrc set
Date:   Mon, 20 Apr 2020 14:38:21 +0200
Message-Id: <20200420121510.180413831@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420121505.909671922@linuxfoundation.org>
References: <20200420121505.909671922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tim Stallard <code@timstallard.me.uk>

[ Upstream commit b93cfb9cd3af3adc9ba4854f178d5300f7544d3e ]

Since commit fac6fce9bdb5 ("net: icmp6: provide input address for
traceroute6") ICMPv6 errors have source addresses from the ingress
interface. However, this overrides when source address selection is
influenced by setting preferred source addresses on routes.

This can result in ICMP errors being lost to upstream BCP38 filters
when the wrong source addresses are used, breaking path MTU discovery
and traceroute.

This patch sets the modified source address selection to only take place
when the route used has no prefsrc set.

It can be tested with:

ip link add v1 type veth peer name v2
ip netns add test
ip netns exec test ip link set lo up
ip link set v2 netns test
ip link set v1 up
ip netns exec test ip link set v2 up
ip addr add 2001:db8::1/64 dev v1 nodad
ip addr add 2001:db8::3 dev v1 nodad
ip netns exec test ip addr add 2001:db8::2/64 dev v2 nodad
ip netns exec test ip route add unreachable 2001:db8:1::1
ip netns exec test ip addr add 2001:db8:100::1 dev lo
ip netns exec test ip route add 2001:db8::1 dev v2 src 2001:db8:100::1
ip route add 2001:db8:1000::1 via 2001:db8::2
traceroute6 -s 2001:db8::1 2001:db8:1000::1
traceroute6 -s 2001:db8::3 2001:db8:1000::1
ip netns delete test

Output before:
$ traceroute6 -s 2001:db8::1 2001:db8:1000::1
traceroute to 2001:db8:1000::1 (2001:db8:1000::1), 30 hops max, 80 byte packets
 1  2001:db8::2 (2001:db8::2)  0.843 ms !N  0.396 ms !N  0.257 ms !N
$ traceroute6 -s 2001:db8::3 2001:db8:1000::1
traceroute to 2001:db8:1000::1 (2001:db8:1000::1), 30 hops max, 80 byte packets
 1  2001:db8::2 (2001:db8::2)  0.772 ms !N  0.257 ms !N  0.357 ms !N

After:
$ traceroute6 -s 2001:db8::1 2001:db8:1000::1
traceroute to 2001:db8:1000::1 (2001:db8:1000::1), 30 hops max, 80 byte packets
 1  2001:db8:100::1 (2001:db8:100::1)  8.885 ms !N  0.310 ms !N  0.174 ms !N
$ traceroute6 -s 2001:db8::3 2001:db8:1000::1
traceroute to 2001:db8:1000::1 (2001:db8:1000::1), 30 hops max, 80 byte packets
 1  2001:db8::2 (2001:db8::2)  1.403 ms !N  0.205 ms !N  0.313 ms !N

Fixes: fac6fce9bdb5 ("net: icmp6: provide input address for traceroute6")
Signed-off-by: Tim Stallard <code@timstallard.me.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/icmp.c |   21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -229,6 +229,25 @@ static bool icmpv6_xrlim_allow(struct so
 	return res;
 }
 
+static bool icmpv6_rt_has_prefsrc(struct sock *sk, u8 type,
+				  struct flowi6 *fl6)
+{
+	struct net *net = sock_net(sk);
+	struct dst_entry *dst;
+	bool res = false;
+
+	dst = ip6_route_output(net, sk, fl6);
+	if (!dst->error) {
+		struct rt6_info *rt = (struct rt6_info *)dst;
+		struct in6_addr prefsrc;
+
+		rt6_get_prefsrc(rt, &prefsrc);
+		res = !ipv6_addr_any(&prefsrc);
+	}
+	dst_release(dst);
+	return res;
+}
+
 /*
  *	an inline helper for the "simple" if statement below
  *	checks if parameter problem report is caused by an
@@ -527,7 +546,7 @@ static void icmp6_send(struct sk_buff *s
 		saddr = force_saddr;
 	if (saddr) {
 		fl6.saddr = *saddr;
-	} else {
+	} else if (!icmpv6_rt_has_prefsrc(sk, type, &fl6)) {
 		/* select a more meaningful saddr from input if */
 		struct net_device *in_netdev;
 


