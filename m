Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFBF94A4504
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:36:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359154AbiAaLfu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:35:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379787AbiAaLal (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:30:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EDFCC06134A;
        Mon, 31 Jan 2022 03:21:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 00135B82A5D;
        Mon, 31 Jan 2022 11:21:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 365B7C340E8;
        Mon, 31 Jan 2022 11:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643628085;
        bh=UfKq2GQHSIkuB4vaUkVCYOWOTluH1D8DYB+0KuYdy7Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pwff8NbHSh+On/2NPWd3WeTgukBrw8cERLGiyI7h75XGhh98tHBZUhDZJrk9DqbkG
         l5oibF6BS1ca6WrqDWizdzTJwrnLbFXIYp+oTOCXlLLpdutnbRdVfu35Ewk2syEPi5
         1ZR4zJ05NVuNl4dqst+jG0bJrOg8qXt4Rjtc9cCE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.16 120/200] ipv6: annotate accesses to fn->fn_sernum
Date:   Mon, 31 Jan 2022 11:56:23 +0100
Message-Id: <20220131105237.605653484@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit aafc2e3285c2d7a79b7ee15221c19fbeca7b1509 upstream.

struct fib6_node's fn_sernum field can be
read while other threads change it.

Add READ_ONCE()/WRITE_ONCE() annotations.

Do not change existing smp barriers in fib6_get_cookie_safe()
and __fib6_update_sernum_upto_root()

syzbot reported:

BUG: KCSAN: data-race in fib6_clean_node / inet6_csk_route_socket

write to 0xffff88813df62e2c of 4 bytes by task 1920 on cpu 1:
 fib6_clean_node+0xc2/0x260 net/ipv6/ip6_fib.c:2178
 fib6_walk_continue+0x38e/0x430 net/ipv6/ip6_fib.c:2112
 fib6_walk net/ipv6/ip6_fib.c:2160 [inline]
 fib6_clean_tree net/ipv6/ip6_fib.c:2240 [inline]
 __fib6_clean_all+0x1a9/0x2e0 net/ipv6/ip6_fib.c:2256
 fib6_flush_trees+0x6c/0x80 net/ipv6/ip6_fib.c:2281
 rt_genid_bump_ipv6 include/net/net_namespace.h:488 [inline]
 addrconf_dad_completed+0x57f/0x870 net/ipv6/addrconf.c:4230
 addrconf_dad_work+0x908/0x1170
 process_one_work+0x3f6/0x960 kernel/workqueue.c:2307
 worker_thread+0x616/0xa70 kernel/workqueue.c:2454
 kthread+0x1bf/0x1e0 kernel/kthread.c:359
 ret_from_fork+0x1f/0x30

read to 0xffff88813df62e2c of 4 bytes by task 15701 on cpu 0:
 fib6_get_cookie_safe include/net/ip6_fib.h:285 [inline]
 rt6_get_cookie include/net/ip6_fib.h:306 [inline]
 ip6_dst_store include/net/ip6_route.h:234 [inline]
 inet6_csk_route_socket+0x352/0x3c0 net/ipv6/inet6_connection_sock.c:109
 inet6_csk_xmit+0x91/0x1e0 net/ipv6/inet6_connection_sock.c:121
 __tcp_transmit_skb+0x1323/0x1840 net/ipv4/tcp_output.c:1402
 tcp_transmit_skb net/ipv4/tcp_output.c:1420 [inline]
 tcp_write_xmit+0x1450/0x4460 net/ipv4/tcp_output.c:2680
 __tcp_push_pending_frames+0x68/0x1c0 net/ipv4/tcp_output.c:2864
 tcp_push+0x2d9/0x2f0 net/ipv4/tcp.c:725
 mptcp_push_release net/mptcp/protocol.c:1491 [inline]
 __mptcp_push_pending+0x46c/0x490 net/mptcp/protocol.c:1578
 mptcp_sendmsg+0x9ec/0xa50 net/mptcp/protocol.c:1764
 inet6_sendmsg+0x5f/0x80 net/ipv6/af_inet6.c:643
 sock_sendmsg_nosec net/socket.c:705 [inline]
 sock_sendmsg net/socket.c:725 [inline]
 kernel_sendmsg+0x97/0xd0 net/socket.c:745
 sock_no_sendpage+0x84/0xb0 net/core/sock.c:3086
 inet_sendpage+0x9d/0xc0 net/ipv4/af_inet.c:834
 kernel_sendpage+0x187/0x200 net/socket.c:3492
 sock_sendpage+0x5a/0x70 net/socket.c:1007
 pipe_to_sendpage+0x128/0x160 fs/splice.c:364
 splice_from_pipe_feed fs/splice.c:418 [inline]
 __splice_from_pipe+0x207/0x500 fs/splice.c:562
 splice_from_pipe fs/splice.c:597 [inline]
 generic_splice_sendpage+0x94/0xd0 fs/splice.c:746
 do_splice_from fs/splice.c:767 [inline]
 direct_splice_actor+0x80/0xa0 fs/splice.c:936
 splice_direct_to_actor+0x345/0x650 fs/splice.c:891
 do_splice_direct+0x106/0x190 fs/splice.c:979
 do_sendfile+0x675/0xc40 fs/read_write.c:1245
 __do_sys_sendfile64 fs/read_write.c:1310 [inline]
 __se_sys_sendfile64 fs/read_write.c:1296 [inline]
 __x64_sys_sendfile64+0x102/0x140 fs/read_write.c:1296
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

value changed: 0x0000026f -> 0x00000271

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 PID: 15701 Comm: syz-executor.2 Not tainted 5.16.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

The Fixes tag I chose is probably arbitrary, I do not think
we need to backport this patch to older kernels.

Fixes: c5cff8561d2d ("ipv6: add rcu grace period before freeing fib6_node")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Link: https://lore.kernel.org/r/20220120174112.1126644-1-eric.dumazet@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/ip6_fib.h |    2 +-
 net/ipv6/ip6_fib.c    |   23 +++++++++++++----------
 net/ipv6/route.c      |    2 +-
 3 files changed, 15 insertions(+), 12 deletions(-)

--- a/include/net/ip6_fib.h
+++ b/include/net/ip6_fib.h
@@ -281,7 +281,7 @@ static inline bool fib6_get_cookie_safe(
 	fn = rcu_dereference(f6i->fib6_node);
 
 	if (fn) {
-		*cookie = fn->fn_sernum;
+		*cookie = READ_ONCE(fn->fn_sernum);
 		/* pairs with smp_wmb() in __fib6_update_sernum_upto_root() */
 		smp_rmb();
 		status = true;
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -111,7 +111,7 @@ void fib6_update_sernum(struct net *net,
 	fn = rcu_dereference_protected(f6i->fib6_node,
 			lockdep_is_held(&f6i->fib6_table->tb6_lock));
 	if (fn)
-		fn->fn_sernum = fib6_new_sernum(net);
+		WRITE_ONCE(fn->fn_sernum, fib6_new_sernum(net));
 }
 
 /*
@@ -589,12 +589,13 @@ static int fib6_dump_table(struct fib6_t
 		spin_unlock_bh(&table->tb6_lock);
 		if (res > 0) {
 			cb->args[4] = 1;
-			cb->args[5] = w->root->fn_sernum;
+			cb->args[5] = READ_ONCE(w->root->fn_sernum);
 		}
 	} else {
-		if (cb->args[5] != w->root->fn_sernum) {
+		int sernum = READ_ONCE(w->root->fn_sernum);
+		if (cb->args[5] != sernum) {
 			/* Begin at the root if the tree changed */
-			cb->args[5] = w->root->fn_sernum;
+			cb->args[5] = sernum;
 			w->state = FWS_INIT;
 			w->node = w->root;
 			w->skip = w->count;
@@ -1344,7 +1345,7 @@ static void __fib6_update_sernum_upto_ro
 	/* paired with smp_rmb() in fib6_get_cookie_safe() */
 	smp_wmb();
 	while (fn) {
-		fn->fn_sernum = sernum;
+		WRITE_ONCE(fn->fn_sernum, sernum);
 		fn = rcu_dereference_protected(fn->parent,
 				lockdep_is_held(&rt->fib6_table->tb6_lock));
 	}
@@ -2173,8 +2174,8 @@ static int fib6_clean_node(struct fib6_w
 	};
 
 	if (c->sernum != FIB6_NO_SERNUM_CHANGE &&
-	    w->node->fn_sernum != c->sernum)
-		w->node->fn_sernum = c->sernum;
+	    READ_ONCE(w->node->fn_sernum) != c->sernum)
+		WRITE_ONCE(w->node->fn_sernum, c->sernum);
 
 	if (!c->func) {
 		WARN_ON_ONCE(c->sernum == FIB6_NO_SERNUM_CHANGE);
@@ -2542,7 +2543,7 @@ static void ipv6_route_seq_setup_walk(st
 	iter->w.state = FWS_INIT;
 	iter->w.node = iter->w.root;
 	iter->w.args = iter;
-	iter->sernum = iter->w.root->fn_sernum;
+	iter->sernum = READ_ONCE(iter->w.root->fn_sernum);
 	INIT_LIST_HEAD(&iter->w.lh);
 	fib6_walker_link(net, &iter->w);
 }
@@ -2570,8 +2571,10 @@ static struct fib6_table *ipv6_route_seq
 
 static void ipv6_route_check_sernum(struct ipv6_route_iter *iter)
 {
-	if (iter->sernum != iter->w.root->fn_sernum) {
-		iter->sernum = iter->w.root->fn_sernum;
+	int sernum = READ_ONCE(iter->w.root->fn_sernum);
+
+	if (iter->sernum != sernum) {
+		iter->sernum = sernum;
 		iter->w.state = FWS_INIT;
 		iter->w.node = iter->w.root;
 		WARN_ON(iter->w.skip);
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -2802,7 +2802,7 @@ static void ip6_link_failure(struct sk_b
 			if (from) {
 				fn = rcu_dereference(from->fib6_node);
 				if (fn && (rt->rt6i_flags & RTF_DEFAULT))
-					fn->fn_sernum = -1;
+					WRITE_ONCE(fn->fn_sernum, -1);
 			}
 		}
 		rcu_read_unlock();


