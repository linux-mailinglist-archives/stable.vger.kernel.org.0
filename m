Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2DDE33B68D
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:59:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231284AbhCON6M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:58:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:34900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231651AbhCON5h (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:57:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E3A9664F0D;
        Mon, 15 Mar 2021 13:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816657;
        bh=4Nz/EDZt7WkEy/6dG03NJB4RGB498BRcpTFxYkRHkQI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uRkLtXMaerM7bwqFAmk+mUqd7tyAerLRFYk6ft9IPX7nF50j++JPittT0JhW/fNQg
         u45p6f7A2zVQoeq2ftd+6wPAOeF+bFAAVjlCZultPf8vzlLWhkn7LE+4uy20Yb8Ii4
         /Fo9x2CmZ0pawjr4yd2S89PuRx4acMwNN5n1KfK0=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ido Schimmel <idosch@nvidia.com>,
        Donald Sharp <sharpd@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 029/168] nexthop: Do not flush blackhole nexthops when loopback goes down
Date:   Mon, 15 Mar 2021 14:54:21 +0100
Message-Id: <20210315135551.304297262@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135550.333963635@linuxfoundation.org>
References: <20210315135550.333963635@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Ido Schimmel <idosch@nvidia.com>

commit 76c03bf8e2624076b88d93542d78e22d5345c88e upstream.

As far as user space is concerned, blackhole nexthops do not have a
nexthop device and therefore should not be affected by the
administrative or carrier state of any netdev.

However, when the loopback netdev goes down all the blackhole nexthops
are flushed. This happens because internally the kernel associates
blackhole nexthops with the loopback netdev.

This behavior is both confusing to those not familiar with kernel
internals and also diverges from the legacy API where blackhole IPv4
routes are not flushed when the loopback netdev goes down:

 # ip route add blackhole 198.51.100.0/24
 # ip link set dev lo down
 # ip route show 198.51.100.0/24
 blackhole 198.51.100.0/24

Blackhole IPv6 routes are flushed, but at least user space knows that
they are associated with the loopback netdev:

 # ip -6 route show 2001:db8:1::/64
 blackhole 2001:db8:1::/64 dev lo metric 1024 pref medium

Fix this by only flushing blackhole nexthops when the loopback netdev is
unregistered.

Fixes: ab84be7e54fc ("net: Initial nexthop code")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reported-by: Donald Sharp <sharpd@nvidia.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/nexthop.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -1065,7 +1065,7 @@ out:
 
 /* rtnl */
 /* remove all nexthops tied to a device being deleted */
-static void nexthop_flush_dev(struct net_device *dev)
+static void nexthop_flush_dev(struct net_device *dev, unsigned long event)
 {
 	unsigned int hash = nh_dev_hashfn(dev->ifindex);
 	struct net *net = dev_net(dev);
@@ -1077,6 +1077,10 @@ static void nexthop_flush_dev(struct net
 		if (nhi->fib_nhc.nhc_dev != dev)
 			continue;
 
+		if (nhi->reject_nh &&
+		    (event == NETDEV_DOWN || event == NETDEV_CHANGE))
+			continue;
+
 		remove_nexthop(net, nhi->nh_parent, NULL);
 	}
 }
@@ -1794,11 +1798,11 @@ static int nh_netdev_event(struct notifi
 	switch (event) {
 	case NETDEV_DOWN:
 	case NETDEV_UNREGISTER:
-		nexthop_flush_dev(dev);
+		nexthop_flush_dev(dev, event);
 		break;
 	case NETDEV_CHANGE:
 		if (!(dev_get_flags(dev) & (IFF_RUNNING | IFF_LOWER_UP)))
-			nexthop_flush_dev(dev);
+			nexthop_flush_dev(dev, event);
 		break;
 	case NETDEV_CHANGEMTU:
 		info_ext = ptr;


