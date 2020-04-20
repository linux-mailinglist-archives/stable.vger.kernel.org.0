Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70E1E1B0A73
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 14:49:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729245AbgDTMs0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 08:48:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:44952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729184AbgDTMsW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 08:48:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4AA34206E9;
        Mon, 20 Apr 2020 12:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587386901;
        bh=Zxmgv2pBfl9kBTfjjx2DGGbJnMniCyABQcS1iX5czk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZM2VJEQ2pst/A9Mf1gAGeFI022Rohgx62g+FEw6FKWNoiYwjoYPKwDDsCP3cz4y1q
         6lpj5yj78vSD5qHLLVfhrcRivW05tJj15kEmPcdK2TsofLjFAnLV4aBDrK3PnjRwbz
         4q7Sin3chYRp/c8lZUYtpxZcn0l0TEY7JL0dTWKM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tim Stallard <code@timstallard.me.uk>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 04/40] net: ipv6: do not consider routes via gateways for anycast address check
Date:   Mon, 20 Apr 2020 14:39:14 +0200
Message-Id: <20200420121451.519491651@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420121444.178150063@linuxfoundation.org>
References: <20200420121444.178150063@linuxfoundation.org>
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
@@ -234,6 +234,7 @@ static inline bool ipv6_anycast_destinat
 
 	return rt->rt6i_flags & RTF_ANYCAST ||
 		(rt->rt6i_dst.plen < 127 &&
+		 !(rt->rt6i_flags & (RTF_GATEWAY | RTF_NONEXTHOP)) &&
 		 ipv6_addr_equal(&rt->rt6i_dst.addr, daddr));
 }
 


