Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 045483C4690
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235013AbhGLG1C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:27:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:46224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234965AbhGLG0G (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:26:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 43E9461178;
        Mon, 12 Jul 2021 06:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626070980;
        bh=y0xC0LgeNQcMN6qT+Su5XzN9BfAy6LsTv8SsWTEvHKM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t0NX5FalWRL8/emqaz5SVVsGKXpLUB0v1IDXksq4+lZJSvzew17Viel1gYv8ywbey
         ts4eyEnPDHwamnniLDXiQ3GIbwWmSiuoYiREbOSX4YV9JB4fy8P0TZB3hj3jeKtvxk
         aD324Tana3aLz+BC9S996mWFtvw8J+SKY9BsP/Ow=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 224/348] vxlan: add missing rcu_read_lock() in neigh_reduce()
Date:   Mon, 12 Jul 2021 08:10:08 +0200
Message-Id: <20210712060731.566650211@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 85e8b032d6ebb0f698a34dd22c2f13443d905888 ]

syzbot complained in neigh_reduce(), because rcu_read_lock_bh()
is treated differently than rcu_read_lock()

WARNING: suspicious RCU usage
5.13.0-rc6-syzkaller #0 Not tainted
-----------------------------
include/net/addrconf.h:313 suspicious rcu_dereference_check() usage!

other info that might help us debug this:

rcu_scheduler_active = 2, debug_locks = 1
3 locks held by kworker/0:0/5:
 #0: ffff888011064d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888011064d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff888011064d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888011064d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:617 [inline]
 #0: ffff888011064d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:644 [inline]
 #0: ffff888011064d38 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2247
 #1: ffffc90000ca7da8 ((work_completion)(&port->wq)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2251
 #2: ffffffff8bf795c0 (rcu_read_lock_bh){....}-{1:2}, at: __dev_queue_xmit+0x1da/0x3130 net/core/dev.c:4180

stack backtrace:
CPU: 0 PID: 5 Comm: kworker/0:0 Not tainted 5.13.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events ipvlan_process_multicast
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x141/0x1d7 lib/dump_stack.c:120
 __in6_dev_get include/net/addrconf.h:313 [inline]
 __in6_dev_get include/net/addrconf.h:311 [inline]
 neigh_reduce drivers/net/vxlan.c:2167 [inline]
 vxlan_xmit+0x34d5/0x4c30 drivers/net/vxlan.c:2919
 __netdev_start_xmit include/linux/netdevice.h:4944 [inline]
 netdev_start_xmit include/linux/netdevice.h:4958 [inline]
 xmit_one net/core/dev.c:3654 [inline]
 dev_hard_start_xmit+0x1eb/0x920 net/core/dev.c:3670
 __dev_queue_xmit+0x2133/0x3130 net/core/dev.c:4246
 ipvlan_process_multicast+0xa99/0xd70 drivers/net/ipvlan/ipvlan_core.c:287
 process_one_work+0x98d/0x1600 kernel/workqueue.c:2276
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2422
 kthread+0x3b1/0x4a0 kernel/kthread.c:313
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

Fixes: f564f45c4518 ("vxlan: add ipv6 proxy support")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vxlan.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 8443df79fabc..c5991e31c557 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -1995,6 +1995,7 @@ static int neigh_reduce(struct net_device *dev, struct sk_buff *skb, __be32 vni)
 	struct neighbour *n;
 	struct nd_msg *msg;
 
+	rcu_read_lock();
 	in6_dev = __in6_dev_get(dev);
 	if (!in6_dev)
 		goto out;
@@ -2046,6 +2047,7 @@ static int neigh_reduce(struct net_device *dev, struct sk_buff *skb, __be32 vni)
 	}
 
 out:
+	rcu_read_unlock();
 	consume_skb(skb);
 	return NETDEV_TX_OK;
 }
-- 
2.30.2



