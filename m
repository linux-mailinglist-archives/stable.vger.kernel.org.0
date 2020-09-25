Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27183278844
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728365AbgIYMyL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:54:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:60592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729523AbgIYMyL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:54:11 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2049206DB;
        Fri, 25 Sep 2020 12:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038450;
        bh=zW1Ae1Nk3MYqBi18oFm0RUKxtHSC++9LCRprbcmnK18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q4fXB6jBZuFTX5wodz/2d4Oc55ygTP3ylHuq+9puJ1w3dKTbqrkFMU5aF8bHzkPO0
         zeEQfhcpWy8QVTWJGGm9+j+FAngtpqzAv4TfFZmRgc6UX68y5WsVj7cdlJvo8C3048
         RgVmgLkWVVcUYmav8GxKu6eLTcHN3IZ65P9rz0sw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kfir Itzhak <mastertheknife@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 23/37] ipv4: Update exception handling for multipath routes via same device
Date:   Fri, 25 Sep 2020 14:48:51 +0200
Message-Id: <20200925124724.448531559@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925124720.972208530@linuxfoundation.org>
References: <20200925124720.972208530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Ahern <dsahern@kernel.org>

[ Upstream commit 2fbc6e89b2f1403189e624cabaf73e189c5e50c6 ]

Kfir reported that pmtu exceptions are not created properly for
deployments where multipath routes use the same device.

After some digging I see 2 compounding problems:
1. ip_route_output_key_hash_rcu is updating the flowi4_oif *after*
   the route lookup. This is the second use case where this has
   been a problem (the first is related to use of vti devices with
   VRF). I can not find any reason for the oif to be changed after the
   lookup; the code goes back to the start of git. It does not seem
   logical so remove it.

2. fib_lookups for exceptions do not call fib_select_path to handle
   multipath route selection based on the hash.

The end result is that the fib_lookup used to add the exception
always creates it based using the first leg of the route.

An example topology showing the problem:

                 |  host1
             +------+
             | eth0 |  .209
             +------+
                 |
             +------+
     switch  | br0  |
             +------+
                 |
       +---------+---------+
       | host2             |  host3
   +------+             +------+
   | eth0 | .250        | eth0 | 192.168.252.252
   +------+             +------+

   +-----+             +-----+
   | vti | .2          | vti | 192.168.247.3
   +-----+             +-----+
       \                  /
 =================================
 tunnels
         192.168.247.1/24

for h in host1 host2 host3; do
        ip netns add ${h}
        ip -netns ${h} link set lo up
        ip netns exec ${h} sysctl -wq net.ipv4.ip_forward=1
done

ip netns add switch
ip -netns switch li set lo up
ip -netns switch link add br0 type bridge stp 0
ip -netns switch link set br0 up

for n in 1 2 3; do
        ip -netns switch link add eth-sw type veth peer name eth-h${n}
        ip -netns switch li set eth-h${n} master br0 up
        ip -netns switch li set eth-sw netns host${n} name eth0
done

ip -netns host1 addr add 192.168.252.209/24 dev eth0
ip -netns host1 link set dev eth0 up
ip -netns host1 route add 192.168.247.0/24 \
        nexthop via 192.168.252.250 dev eth0 nexthop via 192.168.252.252 dev eth0

ip -netns host2 addr add 192.168.252.250/24 dev eth0
ip -netns host2 link set dev eth0 up

ip -netns host2 addr add 192.168.252.252/24 dev eth0
ip -netns host3 link set dev eth0 up

ip netns add tunnel
ip -netns tunnel li set lo up
ip -netns tunnel li add br0 type bridge
ip -netns tunnel li set br0 up
for n in $(seq 11 20); do
        ip -netns tunnel addr add dev br0 192.168.247.${n}/24
done

for n in 2 3
do
        ip -netns tunnel link add vti${n} type veth peer name eth${n}
        ip -netns tunnel link set eth${n} mtu 1360 master br0 up
        ip -netns tunnel link set vti${n} netns host${n} mtu 1360 up
        ip -netns host${n} addr add dev vti${n} 192.168.247.${n}/24
done
ip -netns tunnel ro add default nexthop via 192.168.247.2 nexthop via 192.168.247.3

ip netns exec host1 ping -M do -s 1400 -c3 -I 192.168.252.209 192.168.247.11
ip netns exec host1 ping -M do -s 1400 -c3 -I 192.168.252.209 192.168.247.15
ip -netns host1 ro ls cache

Before this patch the cache always shows exceptions against the first
leg in the multipath route; 192.168.252.250 per this example. Since the
hash has an initial random seed, you may need to vary the final octet
more than what is listed. In my tests, using addresses between 11 and 19
usually found 1 that used both legs.

With this patch, the cache will have exceptions for both legs.

Fixes: 4895c771c7f0 ("ipv4: Add FIB nexthop exceptions")
Reported-by: Kfir Itzhak <mastertheknife@gmail.com>
Signed-off-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/route.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -779,6 +779,8 @@ static void __ip_do_redirect(struct rtab
 			if (fib_lookup(net, fl4, &res, 0) == 0) {
 				struct fib_nh *nh = &FIB_RES_NH(res);
 
+				fib_select_path(net, &res, fl4, skb);
+				nh = &FIB_RES_NH(res);
 				update_or_create_fnhe(nh, fl4->daddr, new_gw,
 						0, false,
 						jiffies + ip_rt_gc_timeout);
@@ -1004,6 +1006,7 @@ out:	kfree_skb(skb);
 static void __ip_rt_update_pmtu(struct rtable *rt, struct flowi4 *fl4, u32 mtu)
 {
 	struct dst_entry *dst = &rt->dst;
+	struct net *net = dev_net(dst->dev);
 	u32 old_mtu = ipv4_mtu(dst);
 	struct fib_result res;
 	bool lock = false;
@@ -1024,9 +1027,11 @@ static void __ip_rt_update_pmtu(struct r
 		return;
 
 	rcu_read_lock();
-	if (fib_lookup(dev_net(dst->dev), fl4, &res, 0) == 0) {
-		struct fib_nh *nh = &FIB_RES_NH(res);
+	if (fib_lookup(net, fl4, &res, 0) == 0) {
+		struct fib_nh *nh;
 
+		fib_select_path(net, &res, fl4, NULL);
+		nh = &FIB_RES_NH(res);
 		update_or_create_fnhe(nh, fl4->daddr, 0, mtu, lock,
 				      jiffies + ip_rt_mtu_expires);
 	}
@@ -2536,8 +2541,6 @@ struct rtable *ip_route_output_key_hash_
 	fib_select_path(net, res, fl4, skb);
 
 	dev_out = FIB_RES_DEV(*res);
-	fl4->flowi4_oif = dev_out->ifindex;
-
 
 make_route:
 	rth = __mkroute_output(res, fl4, orig_oif, dev_out, flags);


