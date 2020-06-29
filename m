Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8AF520DC8D
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:17:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732809AbgF2UQQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:16:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:40556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732639AbgF2TaQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:30:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93852252DE;
        Mon, 29 Jun 2020 15:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445109;
        bh=YJO+rR1zT8+Vb0G8wKjcHbxnjLc7cUyVjatn5U7cxi0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WEm/Sir/2Hjg/zmC+GQFP5unsUBtgBuHY5v4b3xtBijRHhUUT8r+1kpAvzpGlIlVi
         z8WnIfbff8SB/3TM2hfw7OEn6PEGOUSI7KyVp1bYzEqaUrp52Juf0LeH1ZRZT+jsM+
         3DguzNKkO2MMzy7ZQKExvqyzlpkp7OFaZLHPMtZE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Taehee Yoo <ap420073@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.14 17/78] ip_tunnel: fix use-after-free in ip_tunnel_lookup()
Date:   Mon, 29 Jun 2020 11:37:05 -0400
Message-Id: <20200629153806.2494953-18-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629153806.2494953-1-sashal@kernel.org>
References: <20200629153806.2494953-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.186-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.186-rc1
X-KernelTest-Deadline: 2020-07-01T15:38+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit ba61539c6ae57f4146284a5cb4f7b7ed8d42bf45 ]

In the datapath, the ip_tunnel_lookup() is used and it internally uses
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
    ip netns exec A ip link add gre1 type gre local 10.0.0.1 \
	    remote 10.0.0.2
    ip netns exec A ip link set gre1 up
    ip netns exec A ip a a 10.0.100.1/24 dev gre1
    ip netns exec A ip a a 10.0.0.1/24 dev eth0

    ip netns exec B ip link set lo up
    ip netns exec B ip link set eth1 up
    ip netns exec B ip link add gre1 type gre local 10.0.0.2 \
	    remote 10.0.0.1
    ip netns exec B ip link set gre1 up
    ip netns exec B ip a a 10.0.100.2/24 dev gre1
    ip netns exec B ip a a 10.0.0.2/24 dev eth1
    ip netns exec A hping3 10.0.100.2 -2 --flood -d 60000 &
    ip netns del B

Splat looks like:
[   77.793450][    C3] ==================================================================
[   77.794702][    C3] BUG: KASAN: use-after-free in ip_tunnel_lookup+0xcc4/0xf30
[   77.795573][    C3] Read of size 4 at addr ffff888060bd9c84 by task hping3/2905
[   77.796398][    C3]
[   77.796664][    C3] CPU: 3 PID: 2905 Comm: hping3 Not tainted 5.8.0-rc1+ #616
[   77.797474][    C3] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[   77.798453][    C3] Call Trace:
[   77.798815][    C3]  <IRQ>
[   77.799142][    C3]  dump_stack+0x9d/0xdb
[   77.799605][    C3]  print_address_description.constprop.7+0x2cc/0x450
[   77.800365][    C3]  ? ip_tunnel_lookup+0xcc4/0xf30
[   77.800908][    C3]  ? ip_tunnel_lookup+0xcc4/0xf30
[   77.801517][    C3]  ? ip_tunnel_lookup+0xcc4/0xf30
[   77.802145][    C3]  kasan_report+0x154/0x190
[   77.802821][    C3]  ? ip_tunnel_lookup+0xcc4/0xf30
[   77.803503][    C3]  ip_tunnel_lookup+0xcc4/0xf30
[   77.804165][    C3]  __ipgre_rcv+0x1ab/0xaa0 [ip_gre]
[   77.804862][    C3]  ? rcu_read_lock_sched_held+0xc0/0xc0
[   77.805621][    C3]  gre_rcv+0x304/0x1910 [ip_gre]
[   77.806293][    C3]  ? lock_acquire+0x1a9/0x870
[   77.806925][    C3]  ? gre_rcv+0xfe/0x354 [gre]
[   77.807559][    C3]  ? erspan_xmit+0x2e60/0x2e60 [ip_gre]
[   77.808305][    C3]  ? rcu_read_lock_sched_held+0xc0/0xc0
[   77.809032][    C3]  ? rcu_read_lock_held+0x90/0xa0
[   77.809713][    C3]  gre_rcv+0x1b8/0x354 [gre]
[ ... ]

Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
Fixes: c54419321455 ("GRE: Refactor GRE tunneling code.")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ip_tunnel.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
index f6793017a20d9..44cc17c43a6b5 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -98,9 +98,10 @@ struct ip_tunnel *ip_tunnel_lookup(struct ip_tunnel_net *itn,
 				   __be32 remote, __be32 local,
 				   __be32 key)
 {
-	unsigned int hash;
 	struct ip_tunnel *t, *cand = NULL;
 	struct hlist_head *head;
+	struct net_device *ndev;
+	unsigned int hash;
 
 	hash = ip_tunnel_hash(key, remote);
 	head = &itn->tunnels[hash];
@@ -175,8 +176,9 @@ struct ip_tunnel *ip_tunnel_lookup(struct ip_tunnel_net *itn,
 	if (t && t->dev->flags & IFF_UP)
 		return t;
 
-	if (itn->fb_tunnel_dev && itn->fb_tunnel_dev->flags & IFF_UP)
-		return netdev_priv(itn->fb_tunnel_dev);
+	ndev = READ_ONCE(itn->fb_tunnel_dev);
+	if (ndev && ndev->flags & IFF_UP)
+		return netdev_priv(ndev);
 
 	return NULL;
 }
@@ -1211,9 +1213,9 @@ void ip_tunnel_uninit(struct net_device *dev)
 	struct ip_tunnel_net *itn;
 
 	itn = net_generic(net, tunnel->ip_tnl_net_id);
-	/* fb_tunnel_dev will be unregisted in net-exit call. */
-	if (itn->fb_tunnel_dev != dev)
-		ip_tunnel_del(itn, netdev_priv(dev));
+	ip_tunnel_del(itn, netdev_priv(dev));
+	if (itn->fb_tunnel_dev == dev)
+		WRITE_ONCE(itn->fb_tunnel_dev, NULL);
 
 	dst_cache_reset(&tunnel->dst_cache);
 }
-- 
2.25.1

