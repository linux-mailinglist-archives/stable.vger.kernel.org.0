Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28A53278796
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728688AbgIYMsv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:48:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:52122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728670AbgIYMst (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:48:49 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE7C121D91;
        Fri, 25 Sep 2020 12:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038128;
        bh=F+Lytd52hcuvHTwXGuGmhfVFNf81Y3o+tc1VrUxcOSM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dZY1OkB2t0/mmKH3xZkCYhCVPYQApRPo6SuNeZaJ93Mu1qyaTDzm9MWSm7gSXHuLR
         Kp6tFoHOfEGBU8JsW6yJlTHysG4trywRiJgUpds+ie1iPLPLuYl9Fkj3JWFzQWN/hb
         EQ0zy7OuMOVt6EGtctsI5epJe9ri7JuErzbeDEtM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.8 14/56] ipv6: avoid lockdep issue in fib6_del()
Date:   Fri, 25 Sep 2020 14:48:04 +0200
Message-Id: <20200925124729.955249342@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925124727.878494124@linuxfoundation.org>
References: <20200925124727.878494124@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 843d926b003ea692468c8cc5bea1f9f58dfa8c75 ]

syzbot reported twice a lockdep issue in fib6_del() [1]
which I think is caused by net->ipv6.fib6_null_entry
having a NULL fib6_table pointer.

fib6_del() already checks for fib6_null_entry special
case, we only need to return earlier.

Bug seems to occur very rarely, I have thus chosen
a 'bug origin' that makes backports not too complex.

[1]
WARNING: suspicious RCU usage
5.9.0-rc4-syzkaller #0 Not tainted
-----------------------------
net/ipv6/ip6_fib.c:1996 suspicious rcu_dereference_protected() usage!

other info that might help us debug this:

rcu_scheduler_active = 2, debug_locks = 1
4 locks held by syz-executor.5/8095:
 #0: ffffffff8a7ea708 (rtnl_mutex){+.+.}-{3:3}, at: ppp_release+0x178/0x240 drivers/net/ppp/ppp_generic.c:401
 #1: ffff88804c422dd8 (&net->ipv6.fib6_gc_lock){+.-.}-{2:2}, at: spin_trylock_bh include/linux/spinlock.h:414 [inline]
 #1: ffff88804c422dd8 (&net->ipv6.fib6_gc_lock){+.-.}-{2:2}, at: fib6_run_gc+0x21b/0x2d0 net/ipv6/ip6_fib.c:2312
 #2: ffffffff89bd6a40 (rcu_read_lock){....}-{1:2}, at: __fib6_clean_all+0x0/0x290 net/ipv6/ip6_fib.c:2613
 #3: ffff8880a82e6430 (&tb->tb6_lock){+.-.}-{2:2}, at: spin_lock_bh include/linux/spinlock.h:359 [inline]
 #3: ffff8880a82e6430 (&tb->tb6_lock){+.-.}-{2:2}, at: __fib6_clean_all+0x107/0x290 net/ipv6/ip6_fib.c:2245

stack backtrace:
CPU: 1 PID: 8095 Comm: syz-executor.5 Not tainted 5.9.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x198/0x1fd lib/dump_stack.c:118
 fib6_del+0x12b4/0x1630 net/ipv6/ip6_fib.c:1996
 fib6_clean_node+0x39b/0x570 net/ipv6/ip6_fib.c:2180
 fib6_walk_continue+0x4aa/0x8e0 net/ipv6/ip6_fib.c:2102
 fib6_walk+0x182/0x370 net/ipv6/ip6_fib.c:2150
 fib6_clean_tree+0xdb/0x120 net/ipv6/ip6_fib.c:2230
 __fib6_clean_all+0x120/0x290 net/ipv6/ip6_fib.c:2246
 fib6_clean_all net/ipv6/ip6_fib.c:2257 [inline]
 fib6_run_gc+0x113/0x2d0 net/ipv6/ip6_fib.c:2320
 ndisc_netdev_event+0x217/0x350 net/ipv6/ndisc.c:1805
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2033
 call_netdevice_notifiers_extack net/core/dev.c:2045 [inline]
 call_netdevice_notifiers net/core/dev.c:2059 [inline]
 dev_close_many+0x30b/0x650 net/core/dev.c:1634
 rollback_registered_many+0x3a8/0x1210 net/core/dev.c:9261
 rollback_registered net/core/dev.c:9329 [inline]
 unregister_netdevice_queue+0x2dd/0x570 net/core/dev.c:10410
 unregister_netdevice include/linux/netdevice.h:2774 [inline]
 ppp_release+0x216/0x240 drivers/net/ppp/ppp_generic.c:403
 __fput+0x285/0x920 fs/file_table.c:281
 task_work_run+0xdd/0x190 kernel/task_work.c:141
 tracehook_notify_resume include/linux/tracehook.h:188 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:163 [inline]
 exit_to_user_mode_prepare+0x1e1/0x200 kernel/entry/common.c:190
 syscall_exit_to_user_mode+0x7e/0x2e0 kernel/entry/common.c:265
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: 421842edeaf6 ("net/ipv6: Add fib6_null_entry")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: David Ahern <dsahern@gmail.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_fib.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -1992,14 +1992,19 @@ static void fib6_del_route(struct fib6_t
 /* Need to own table->tb6_lock */
 int fib6_del(struct fib6_info *rt, struct nl_info *info)
 {
-	struct fib6_node *fn = rcu_dereference_protected(rt->fib6_node,
-				    lockdep_is_held(&rt->fib6_table->tb6_lock));
-	struct fib6_table *table = rt->fib6_table;
 	struct net *net = info->nl_net;
 	struct fib6_info __rcu **rtp;
 	struct fib6_info __rcu **rtp_next;
+	struct fib6_table *table;
+	struct fib6_node *fn;
 
-	if (!fn || rt == net->ipv6.fib6_null_entry)
+	if (rt == net->ipv6.fib6_null_entry)
+		return -ENOENT;
+
+	table = rt->fib6_table;
+	fn = rcu_dereference_protected(rt->fib6_node,
+				       lockdep_is_held(&table->tb6_lock));
+	if (!fn)
 		return -ENOENT;
 
 	WARN_ON(!(fn->fn_flags & RTN_RTINFO));


