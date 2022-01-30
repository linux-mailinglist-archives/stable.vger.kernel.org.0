Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C41454A3848
	for <lists+stable@lfdr.de>; Sun, 30 Jan 2022 19:54:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232037AbiA3SyG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 Jan 2022 13:54:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbiA3SyG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 Jan 2022 13:54:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6C3BC061714
        for <stable@vger.kernel.org>; Sun, 30 Jan 2022 10:54:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 55BB5B8290B
        for <stable@vger.kernel.org>; Sun, 30 Jan 2022 18:54:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78075C340E4;
        Sun, 30 Jan 2022 18:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643568843;
        bh=MZilE7hBX2oOETFDNUL9qx1quR7zzsEFjspGaAUpr/8=;
        h=Subject:To:Cc:From:Date:From;
        b=MQOZG5A5ODQXAiDMJiA7Xsg1QYi3tC4SwebH4dzrCbRZMmfA02apiAIhTp62SrpRQ
         JPLfnm2RSA8V9Mp+NvxzRUtSBinwl4YwmYwxFEHQcwUYnMUpElMhv4QAC+FuLP39w0
         Y2iwqhtsOksHDAE23nLIY1uE2SclC2NXlLClwE2w=
Subject: FAILED: patch "[PATCH] ipv6: annotate accesses to fn->fn_sernum" failed to apply to 4.4-stable tree
To:     edumazet@google.com, kuba@kernel.org, syzkaller@googlegroups.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 30 Jan 2022 19:54:00 +0100
Message-ID: <1643568840130116@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From aafc2e3285c2d7a79b7ee15221c19fbeca7b1509 Mon Sep 17 00:00:00 2001
From: Eric Dumazet <edumazet@google.com>
Date: Thu, 20 Jan 2022 09:41:12 -0800
Subject: [PATCH] ipv6: annotate accesses to fn->fn_sernum

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

diff --git a/include/net/ip6_fib.h b/include/net/ip6_fib.h
index a9a4ccc0cdb5..40ae8f1b18e5 100644
--- a/include/net/ip6_fib.h
+++ b/include/net/ip6_fib.h
@@ -282,7 +282,7 @@ static inline bool fib6_get_cookie_safe(const struct fib6_info *f6i,
 	fn = rcu_dereference(f6i->fib6_node);
 
 	if (fn) {
-		*cookie = fn->fn_sernum;
+		*cookie = READ_ONCE(fn->fn_sernum);
 		/* pairs with smp_wmb() in __fib6_update_sernum_upto_root() */
 		smp_rmb();
 		status = true;
diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 463c37dea449..413f66781e50 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -112,7 +112,7 @@ void fib6_update_sernum(struct net *net, struct fib6_info *f6i)
 	fn = rcu_dereference_protected(f6i->fib6_node,
 			lockdep_is_held(&f6i->fib6_table->tb6_lock));
 	if (fn)
-		fn->fn_sernum = fib6_new_sernum(net);
+		WRITE_ONCE(fn->fn_sernum, fib6_new_sernum(net));
 }
 
 /*
@@ -590,12 +590,13 @@ static int fib6_dump_table(struct fib6_table *table, struct sk_buff *skb,
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
@@ -1345,7 +1346,7 @@ static void __fib6_update_sernum_upto_root(struct fib6_info *rt,
 	/* paired with smp_rmb() in fib6_get_cookie_safe() */
 	smp_wmb();
 	while (fn) {
-		fn->fn_sernum = sernum;
+		WRITE_ONCE(fn->fn_sernum, sernum);
 		fn = rcu_dereference_protected(fn->parent,
 				lockdep_is_held(&rt->fib6_table->tb6_lock));
 	}
@@ -2174,8 +2175,8 @@ static int fib6_clean_node(struct fib6_walker *w)
 	};
 
 	if (c->sernum != FIB6_NO_SERNUM_CHANGE &&
-	    w->node->fn_sernum != c->sernum)
-		w->node->fn_sernum = c->sernum;
+	    READ_ONCE(w->node->fn_sernum) != c->sernum)
+		WRITE_ONCE(w->node->fn_sernum, c->sernum);
 
 	if (!c->func) {
 		WARN_ON_ONCE(c->sernum == FIB6_NO_SERNUM_CHANGE);
@@ -2543,7 +2544,7 @@ static void ipv6_route_seq_setup_walk(struct ipv6_route_iter *iter,
 	iter->w.state = FWS_INIT;
 	iter->w.node = iter->w.root;
 	iter->w.args = iter;
-	iter->sernum = iter->w.root->fn_sernum;
+	iter->sernum = READ_ONCE(iter->w.root->fn_sernum);
 	INIT_LIST_HEAD(&iter->w.lh);
 	fib6_walker_link(net, &iter->w);
 }
@@ -2571,8 +2572,10 @@ static struct fib6_table *ipv6_route_seq_next_table(struct fib6_table *tbl,
 
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
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index e6de94203c13..f4884cda13b9 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -2802,7 +2802,7 @@ static void ip6_link_failure(struct sk_buff *skb)
 			if (from) {
 				fn = rcu_dereference(from->fib6_node);
 				if (fn && (rt->rt6i_flags & RTF_DEFAULT))
-					fn->fn_sernum = -1;
+					WRITE_ONCE(fn->fn_sernum, -1);
 			}
 		}
 		rcu_read_unlock();

