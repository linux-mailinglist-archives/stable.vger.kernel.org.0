Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25C33406C46
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 14:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234296AbhIJMii (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 08:38:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:54670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233807AbhIJMg4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Sep 2021 08:36:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D09F611C0;
        Fri, 10 Sep 2021 12:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631277335;
        bh=dSns49qWg5ARj6dzAc5DaoLLkaiUpv+3xSk79i1/fUc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A5mlqVuVjV2zUKWCsc6bT0ovRxyhqTQ0LZ4yGuxEkqMreeNYFhWzaFr7Zu8uYbCB/
         +ffey+xY6ITAPN7Eq2+MQwq916jcE32ugLqvxpsK86NBrEl4EfwcnEDxz2srqclKhA
         4rDXlnoMqDXFKH6So3kCZvuQudNUjGyQmGF3XsKo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 24/37] ipv4/icmp: l3mdev: Perform icmp error route lookup on source device routing table (v2)
Date:   Fri, 10 Sep 2021 14:30:27 +0200
Message-Id: <20210910122917.956670274@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210910122917.149278545@linuxfoundation.org>
References: <20210910122917.149278545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

commit e1e84eb58eb494b77c8389fc6308b5042dcce791 upstream.

As per RFC792, ICMP errors should be sent to the source host.

However, in configurations with Virtual Routing and Forwarding tables,
looking up which routing table to use is currently done by using the
destination net_device.

commit 9d1a6c4ea43e ("net: icmp_route_lookup should use rt dev to
determine L3 domain") changes the interface passed to
l3mdev_master_ifindex() and inet_addr_type_dev_table() from skb_in->dev
to skb_dst(skb_in)->dev. This effectively uses the destination device
rather than the source device for choosing which routing table should be
used to lookup where to send the ICMP error.

Therefore, if the source and destination interfaces are within separate
VRFs, or one in the global routing table and the other in a VRF, looking
up the source host in the destination interface's routing table will
fail if the destination interface's routing table contains no route to
the source host.

One observable effect of this issue is that traceroute does not work in
the following cases:

- Route leaking between global routing table and VRF
- Route leaking between VRFs

Preferably use the source device routing table when sending ICMP error
messages. If no source device is set, fall-back on the destination
device routing table. Else, use the main routing table (index 0).

[ It has been pointed out that a similar issue may exist with ICMP
  errors triggered when forwarding between network namespaces. It would
  be worthwhile to investigate, but is outside of the scope of this
  investigation. ]

[ It has also been pointed out that a similar issue exists with
  unreachable / fragmentation needed messages, which can be triggered by
  changing the MTU of eth1 in r1 to 1400 and running:

  ip netns exec h1 ping -s 1450 -Mdo -c1 172.16.2.2

  Some investigation points to raw_icmp_error() and raw_err() as being
  involved in this last scenario. The focus of this patch is TTL expired
  ICMP messages, which go through icmp_route_lookup.
  Investigation of failure modes related to raw_icmp_error() is beyond
  this investigation's scope. ]

Fixes: 9d1a6c4ea43e ("net: icmp_route_lookup should use rt dev to determine L3 domain")
Link: https://tools.ietf.org/html/rfc792
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/icmp.c |   23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -460,6 +460,23 @@ out_bh_enable:
 	local_bh_enable();
 }
 
+/*
+ * The device used for looking up which routing table to use for sending an ICMP
+ * error is preferably the source whenever it is set, which should ensure the
+ * icmp error can be sent to the source host, else lookup using the routing
+ * table of the destination device, else use the main routing table (index 0).
+ */
+static struct net_device *icmp_get_route_lookup_dev(struct sk_buff *skb)
+{
+	struct net_device *route_lookup_dev = NULL;
+
+	if (skb->dev)
+		route_lookup_dev = skb->dev;
+	else if (skb_dst(skb))
+		route_lookup_dev = skb_dst(skb)->dev;
+	return route_lookup_dev;
+}
+
 static struct rtable *icmp_route_lookup(struct net *net,
 					struct flowi4 *fl4,
 					struct sk_buff *skb_in,
@@ -468,6 +485,7 @@ static struct rtable *icmp_route_lookup(
 					int type, int code,
 					struct icmp_bxm *param)
 {
+	struct net_device *route_lookup_dev;
 	struct rtable *rt, *rt2;
 	struct flowi4 fl4_dec;
 	int err;
@@ -482,7 +500,8 @@ static struct rtable *icmp_route_lookup(
 	fl4->flowi4_proto = IPPROTO_ICMP;
 	fl4->fl4_icmp_type = type;
 	fl4->fl4_icmp_code = code;
-	fl4->flowi4_oif = l3mdev_master_ifindex(skb_dst(skb_in)->dev);
+	route_lookup_dev = icmp_get_route_lookup_dev(skb_in);
+	fl4->flowi4_oif = l3mdev_master_ifindex(route_lookup_dev);
 
 	security_skb_classify_flow(skb_in, flowi4_to_flowi(fl4));
 	rt = ip_route_output_key_hash(net, fl4, skb_in);
@@ -506,7 +525,7 @@ static struct rtable *icmp_route_lookup(
 	if (err)
 		goto relookup_failed;
 
-	if (inet_addr_type_dev_table(net, skb_dst(skb_in)->dev,
+	if (inet_addr_type_dev_table(net, route_lookup_dev,
 				     fl4_dec.saddr) == RTN_LOCAL) {
 		rt2 = __ip_route_output_key(net, &fl4_dec);
 		if (IS_ERR(rt2))


