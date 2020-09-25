Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E94872787F6
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729212AbgIYMvf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:51:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:55890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728759AbgIYMvc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:51:32 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C87272075E;
        Fri, 25 Sep 2020 12:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038291;
        bh=ud6Ce1H5+gJM28laOw/9a2IniJR3pJEU8ohEEPgkZF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vfFMX6g8fxoSFO+0YKdabzILna0Kr6TJu247ol0esJhyG/mvCawqKtvVYLmi949yp
         bshEuxCIr9Fom8nAaeQDcDgwZ3Lv6DVOrUY6WYkznncCIZOmKlaiJlA7hmZI9091Ju
         mMz270PgM+6IpCga5yLEfNWi+Kt5kAvkmIZsPP+8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 16/43] ipv6: avoid lockdep issue in fib6_del()
Date:   Fri, 25 Sep 2020 14:48:28 +0200
Message-Id: <20200925124726.028001941@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925124723.575329814@linuxfoundation.org>
References: <20200925124723.575329814@linuxfoundation.org>
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
@@ -1896,14 +1896,19 @@ static void fib6_del_route(struct fib6_t
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


