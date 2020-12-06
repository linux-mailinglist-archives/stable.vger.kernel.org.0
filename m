Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84BC02D03F5
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 12:51:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728885AbgLFLlx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 06:41:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:39698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728880AbgLFLlw (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Dec 2020 06:41:52 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <gnault@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 16/39] ipv4: Fix tos mask in inet_rtm_getroute()
Date:   Sun,  6 Dec 2020 12:17:20 +0100
Message-Id: <20201206111555.458123604@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201206111554.677764505@linuxfoundation.org>
References: <20201206111554.677764505@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guillaume Nault <gnault@redhat.com>

[ Upstream commit 1ebf179037cb46c19da3a9c1e2ca16e7a754b75e ]

When inet_rtm_getroute() was converted to use the RCU variants of
ip_route_input() and ip_route_output_key(), the TOS parameters
stopped being masked with IPTOS_RT_MASK before doing the route lookup.

As a result, "ip route get" can return a different route than what
would be used when sending real packets.

For example:

    $ ip route add 192.0.2.11/32 dev eth0
    $ ip route add unreachable 192.0.2.11/32 tos 2
    $ ip route get 192.0.2.11 tos 2
    RTNETLINK answers: No route to host

But, packets with TOS 2 (ECT(0) if interpreted as an ECN bit) would
actually be routed using the first route:

    $ ping -c 1 -Q 2 192.0.2.11
    PING 192.0.2.11 (192.0.2.11) 56(84) bytes of data.
    64 bytes from 192.0.2.11: icmp_seq=1 ttl=64 time=0.173 ms

    --- 192.0.2.11 ping statistics ---
    1 packets transmitted, 1 received, 0% packet loss, time 0ms
    rtt min/avg/max/mdev = 0.173/0.173/0.173/0.000 ms

This patch re-applies IPTOS_RT_MASK in inet_rtm_getroute(), to
return results consistent with real route lookups.

Fixes: 3765d35ed8b9 ("net: ipv4: Convert inet_rtm_getroute to rcu versions of route lookup")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/b2d237d08317ca55926add9654a48409ac1b8f5b.1606412894.git.gnault@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/route.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -3132,7 +3132,7 @@ static int inet_rtm_getroute(struct sk_b
 
 	fl4.daddr = dst;
 	fl4.saddr = src;
-	fl4.flowi4_tos = rtm->rtm_tos;
+	fl4.flowi4_tos = rtm->rtm_tos & IPTOS_RT_MASK;
 	fl4.flowi4_oif = tb[RTA_OIF] ? nla_get_u32(tb[RTA_OIF]) : 0;
 	fl4.flowi4_mark = mark;
 	fl4.flowi4_uid = uid;
@@ -3156,8 +3156,9 @@ static int inet_rtm_getroute(struct sk_b
 		fl4.flowi4_iif = iif; /* for rt_fill_info */
 		skb->dev	= dev;
 		skb->mark	= mark;
-		err = ip_route_input_rcu(skb, dst, src, rtm->rtm_tos,
-					 dev, &res);
+		err = ip_route_input_rcu(skb, dst, src,
+					 rtm->rtm_tos & IPTOS_RT_MASK, dev,
+					 &res);
 
 		rt = skb_rtable(skb);
 		if (err == 0 && rt->dst.error)


