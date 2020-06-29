Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9249F20D9FB
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387712AbgF2Twh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:52:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:47694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387689AbgF2Tk1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:40:27 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D14982482C;
        Mon, 29 Jun 2020 15:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444346;
        bh=ZSUC7tD4dJcbdChXIXW0Wc+cNObHrZMYvCPyNkWxuUo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mi7RzVjDXwkudGQk2sike2HMU168drzHYceIGXyvLs0IJNkvJD0JdouWO04xVeSum
         fOB066TkrQ+tAwCpqcCX0o33ToQhHY6L5TIndSDMZLwKjP84SK7+CfLO7XIFnnPtzK
         cQpvlLcRfRyo7qzKHIN4ty4Ka7tN4c0XH27FZoBU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Taehee Yoo <ap420073@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.4 021/178] ip6_gre: fix use-after-free in ip6gre_tunnel_lookup()
Date:   Mon, 29 Jun 2020 11:22:46 -0400
Message-Id: <20200629152523.2494198-22-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629152523.2494198-1-sashal@kernel.org>
References: <20200629152523.2494198-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.50-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.50-rc1
X-KernelTest-Deadline: 2020-07-01T15:25+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit dafabb6590cb15f300b77c095d50312e2c7c8e0f ]

In the datapath, the ip6gre_tunnel_lookup() is used and it internally uses
fallback tunnel device pointer, which is fb_tunnel_dev.
This pointer variable should be set to NULL when a fb interface is deleted.
But there is no routine to set fb_tunnel_dev pointer to NULL.
So, this pointer will be still used after interface is deleted and
it eventually results in the use-after-free problem.

Test commands:
    ip netns add A
    ip netns add B
    ip link add eth0 type veth peer name eth1
    ip link set eth0 netns A
    ip link set eth1 netns B

    ip netns exec A ip link set lo up
    ip netns exec A ip link set eth0 up
    ip netns exec A ip link add ip6gre1 type ip6gre local fc:0::1 \
	    remote fc:0::2
    ip netns exec A ip -6 a a fc:100::1/64 dev ip6gre1
    ip netns exec A ip link set ip6gre1 up
    ip netns exec A ip -6 a a fc:0::1/64 dev eth0
    ip netns exec A ip link set ip6gre0 up

    ip netns exec B ip link set lo up
    ip netns exec B ip link set eth1 up
    ip netns exec B ip link add ip6gre1 type ip6gre local fc:0::2 \
	    remote fc:0::1
    ip netns exec B ip -6 a a fc:100::2/64 dev ip6gre1
    ip netns exec B ip link set ip6gre1 up
    ip netns exec B ip -6 a a fc:0::2/64 dev eth1
    ip netns exec B ip link set ip6gre0 up
    ip netns exec A ping fc:100::2 -s 60000 &
    ip netns del B

Splat looks like:
[   73.087285][    C1] BUG: KASAN: use-after-free in ip6gre_tunnel_lookup+0x1064/0x13f0 [ip6_gre]
[   73.088361][    C1] Read of size 4 at addr ffff888040559218 by task ping/1429
[   73.089317][    C1]
[   73.089638][    C1] CPU: 1 PID: 1429 Comm: ping Not tainted 5.7.0+ #602
[   73.090531][    C1] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[   73.091725][    C1] Call Trace:
[   73.092160][    C1]  <IRQ>
[   73.092556][    C1]  dump_stack+0x96/0xdb
[   73.093122][    C1]  print_address_description.constprop.6+0x2cc/0x450
[   73.094016][    C1]  ? ip6gre_tunnel_lookup+0x1064/0x13f0 [ip6_gre]
[   73.094894][    C1]  ? ip6gre_tunnel_lookup+0x1064/0x13f0 [ip6_gre]
[   73.095767][    C1]  ? ip6gre_tunnel_lookup+0x1064/0x13f0 [ip6_gre]
[   73.096619][    C1]  kasan_report+0x154/0x190
[   73.097209][    C1]  ? ip6gre_tunnel_lookup+0x1064/0x13f0 [ip6_gre]
[   73.097989][    C1]  ip6gre_tunnel_lookup+0x1064/0x13f0 [ip6_gre]
[   73.098750][    C1]  ? gre_del_protocol+0x60/0x60 [gre]
[   73.099500][    C1]  gre_rcv+0x1c5/0x1450 [ip6_gre]
[   73.100199][    C1]  ? ip6gre_header+0xf00/0xf00 [ip6_gre]
[   73.100985][    C1]  ? rcu_read_lock_sched_held+0xc0/0xc0
[   73.101830][    C1]  ? ip6_input_finish+0x5/0xf0
[   73.102483][    C1]  ip6_protocol_deliver_rcu+0xcbb/0x1510
[   73.103296][    C1]  ip6_input_finish+0x5b/0xf0
[   73.103920][    C1]  ip6_input+0xcd/0x2c0
[   73.104473][    C1]  ? ip6_input_finish+0xf0/0xf0
[   73.105115][    C1]  ? rcu_read_lock_held+0x90/0xa0
[   73.105783][    C1]  ? rcu_read_lock_sched_held+0xc0/0xc0
[   73.106548][    C1]  ipv6_rcv+0x1f1/0x300
[ ... ]

Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
Fixes: c12b395a4664 ("gre: Support GRE over IPv6")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_gre.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index 9ec05a1df5e19..04d76f043e180 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -127,6 +127,7 @@ static struct ip6_tnl *ip6gre_tunnel_lookup(struct net_device *dev,
 			gre_proto == htons(ETH_P_ERSPAN2)) ?
 		       ARPHRD_ETHER : ARPHRD_IP6GRE;
 	int score, cand_score = 4;
+	struct net_device *ndev;
 
 	for_each_ip_tunnel_rcu(t, ign->tunnels_r_l[h0 ^ h1]) {
 		if (!ipv6_addr_equal(local, &t->parms.laddr) ||
@@ -238,9 +239,9 @@ static struct ip6_tnl *ip6gre_tunnel_lookup(struct net_device *dev,
 	if (t && t->dev->flags & IFF_UP)
 		return t;
 
-	dev = ign->fb_tunnel_dev;
-	if (dev && dev->flags & IFF_UP)
-		return netdev_priv(dev);
+	ndev = READ_ONCE(ign->fb_tunnel_dev);
+	if (ndev && ndev->flags & IFF_UP)
+		return netdev_priv(ndev);
 
 	return NULL;
 }
@@ -413,6 +414,8 @@ static void ip6gre_tunnel_uninit(struct net_device *dev)
 
 	ip6gre_tunnel_unlink_md(ign, t);
 	ip6gre_tunnel_unlink(ign, t);
+	if (ign->fb_tunnel_dev == dev)
+		WRITE_ONCE(ign->fb_tunnel_dev, NULL);
 	dst_cache_reset(&t->dst_cache);
 	dev_put(dev);
 }
-- 
2.25.1

