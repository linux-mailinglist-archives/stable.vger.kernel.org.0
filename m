Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22F081B0BB5
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 14:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728322AbgDTMnH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 08:43:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:36376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727776AbgDTMnE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 08:43:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA01E20724;
        Mon, 20 Apr 2020 12:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587386583;
        bh=wVsjuW5qeAGCM3ngUkESGHskmplY5sshpRswX7BlpvU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IPbLQitZ6C5HXcoW6TeRrPaTca/jyBs7NQPvI/pSudNpiM3DEbu0iL4NMJJYiyu5+
         jH8R5TC5TXpJHMY4GmtuCGP/hk04jdoRhaGeMLhbwmBg5t9ASa9JGu5X1Wl8wNoAwN
         tNvpks24d/7pZ0QDhbwnXwbTWQsSxHSSRzFCDAhQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tim Stallard <code@timstallard.me.uk>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 06/71] net: ipv6: do not consider routes via gateways for anycast address check
Date:   Mon, 20 Apr 2020 14:38:20 +0200
Message-Id: <20200420121509.828659034@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420121508.491252919@linuxfoundation.org>
References: <20200420121508.491252919@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tim Stallard <code@timstallard.me.uk>

[ Upstream commit 03e2a984b6165621f287fadf5f4b5cd8b58dcaba ]

The behaviour for what is considered an anycast address changed in
commit 45e4fd26683c ("ipv6: Only create RTF_CACHE routes after
encountering pmtu exception"). This now considers the first
address in a subnet where there is a route via a gateway
to be an anycast address.

This breaks path MTU discovery and traceroutes when a host in a
remote network uses the address at the start of a prefix
(eg 2600:: advertised as 2600::/48 in the DFZ) as ICMP errors
will not be sent to anycast addresses.

This patch excludes any routes with a gateway, or via point to
point links, like the behaviour previously from
rt6_is_gw_or_nonexthop in net/ipv6/route.c.

This can be tested with:
ip link add v1 type veth peer name v2
ip netns add test
ip netns exec test ip link set lo up
ip link set v2 netns test
ip link set v1 up
ip netns exec test ip link set v2 up
ip addr add 2001:db8::1/64 dev v1 nodad
ip addr add 2001:db8:100:: dev lo nodad
ip netns exec test ip addr add 2001:db8::2/64 dev v2 nodad
ip netns exec test ip route add unreachable 2001:db8:1::1
ip netns exec test ip route add 2001:db8:100::/64 via 2001:db8::1
ip netns exec test sysctl net.ipv6.conf.all.forwarding=1
ip route add 2001:db8:1::1 via 2001:db8::2
ping -I 2001:db8::1 2001:db8:1::1 -c1
ping -I 2001:db8:100:: 2001:db8:1::1 -c1
ip addr delete 2001:db8:100:: dev lo
ip netns delete test

Currently the first ping will get back a destination unreachable ICMP
error, but the second will never get a response, with "icmp6_send:
acast source" logged. After this patch, both get destination
unreachable ICMP replies.

Fixes: 45e4fd26683c ("ipv6: Only create RTF_CACHE routes after encountering pmtu exception")
Signed-off-by: Tim Stallard <code@timstallard.me.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/ip6_route.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/net/ip6_route.h
+++ b/include/net/ip6_route.h
@@ -254,6 +254,7 @@ static inline bool ipv6_anycast_destinat
 
 	return rt->rt6i_flags & RTF_ANYCAST ||
 		(rt->rt6i_dst.plen < 127 &&
+		 !(rt->rt6i_flags & (RTF_GATEWAY | RTF_NONEXTHOP)) &&
 		 ipv6_addr_equal(&rt->rt6i_dst.addr, daddr));
 }
 


