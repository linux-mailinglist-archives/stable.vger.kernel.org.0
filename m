Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE3A1574E8
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:38:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728532AbgBJMgt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:36:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:57022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727927AbgBJMgs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:36:48 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFA8320838;
        Mon, 10 Feb 2020 12:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338207;
        bh=rCb0NwyL1p9Uocevjv00ZUTfYRghQggB8rhVLSmFtjk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iDVsoUO9iw0/ewpzZv+UJSdz4yMpqegT8ack5X81PjP0cfH5xKKVr+bMAkMXiyDKs
         C+jMi04TOzyu+ZO9BS4mZqiKdgwzvlaRZStborNB5A3Ux9eNEhCydfD305BD9vB83x
         m9OSdPiINkYiR/B9zOwTgjR9ltdzHqM14CPW5JmY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        "Paul E. McKenney" <paulmck@kernel.org>
Subject: [PATCH 5.4 029/309] rcu: Avoid data-race in rcu_gp_fqs_check_wake()
Date:   Mon, 10 Feb 2020 04:29:45 -0800
Message-Id: <20200210122408.832816354@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit 6935c3983b246d5fbfebd3b891c825e65c118f2d upstream.

The rcu_gp_fqs_check_wake() function uses rcu_preempt_blocked_readers_cgp()
to read ->gp_tasks while other cpus might overwrite this field.

We need READ_ONCE()/WRITE_ONCE() pairs to avoid compiler
tricks and KCSAN splats like the following :

BUG: KCSAN: data-race in rcu_gp_fqs_check_wake / rcu_preempt_deferred_qs_irqrestore

write to 0xffffffff85a7f190 of 8 bytes by task 7317 on cpu 0:
 rcu_preempt_deferred_qs_irqrestore+0x43d/0x580 kernel/rcu/tree_plugin.h:507
 rcu_read_unlock_special+0xec/0x370 kernel/rcu/tree_plugin.h:659
 __rcu_read_unlock+0xcf/0xe0 kernel/rcu/tree_plugin.h:394
 rcu_read_unlock include/linux/rcupdate.h:645 [inline]
 __ip_queue_xmit+0x3b0/0xa40 net/ipv4/ip_output.c:533
 ip_queue_xmit+0x45/0x60 include/net/ip.h:236
 __tcp_transmit_skb+0xdeb/0x1cd0 net/ipv4/tcp_output.c:1158
 __tcp_send_ack+0x246/0x300 net/ipv4/tcp_output.c:3685
 tcp_send_ack+0x34/0x40 net/ipv4/tcp_output.c:3691
 tcp_cleanup_rbuf+0x130/0x360 net/ipv4/tcp.c:1575
 tcp_recvmsg+0x633/0x1a30 net/ipv4/tcp.c:2179
 inet_recvmsg+0xbb/0x250 net/ipv4/af_inet.c:838
 sock_recvmsg_nosec net/socket.c:871 [inline]
 sock_recvmsg net/socket.c:889 [inline]
 sock_recvmsg+0x92/0xb0 net/socket.c:885
 sock_read_iter+0x15f/0x1e0 net/socket.c:967
 call_read_iter include/linux/fs.h:1864 [inline]
 new_sync_read+0x389/0x4f0 fs/read_write.c:414

read to 0xffffffff85a7f190 of 8 bytes by task 10 on cpu 1:
 rcu_gp_fqs_check_wake kernel/rcu/tree.c:1556 [inline]
 rcu_gp_fqs_check_wake+0x93/0xd0 kernel/rcu/tree.c:1546
 rcu_gp_fqs_loop+0x36c/0x580 kernel/rcu/tree.c:1611
 rcu_gp_kthread+0x143/0x220 kernel/rcu/tree.c:1768
 kthread+0x1d4/0x200 drivers/block/aoe/aoecmd.c:1253
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:352

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 10 Comm: rcu_preempt Not tainted 5.3.0+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
[ paulmck:  Added another READ_ONCE() for RCU CPU stall warnings. ]
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/rcu/tree_plugin.h |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -220,7 +220,7 @@ static void rcu_preempt_ctxt_queue(struc
 	 * blocked tasks.
 	 */
 	if (!rnp->gp_tasks && (blkd_state & RCU_GP_BLKD)) {
-		rnp->gp_tasks = &t->rcu_node_entry;
+		WRITE_ONCE(rnp->gp_tasks, &t->rcu_node_entry);
 		WARN_ON_ONCE(rnp->completedqs == rnp->gp_seq);
 	}
 	if (!rnp->exp_tasks && (blkd_state & RCU_EXP_BLKD))
@@ -340,7 +340,7 @@ EXPORT_SYMBOL_GPL(rcu_note_context_switc
  */
 static int rcu_preempt_blocked_readers_cgp(struct rcu_node *rnp)
 {
-	return rnp->gp_tasks != NULL;
+	return READ_ONCE(rnp->gp_tasks) != NULL;
 }
 
 /* Bias and limit values for ->rcu_read_lock_nesting. */
@@ -493,7 +493,7 @@ rcu_preempt_deferred_qs_irqrestore(struc
 		trace_rcu_unlock_preempted_task(TPS("rcu_preempt"),
 						rnp->gp_seq, t->pid);
 		if (&t->rcu_node_entry == rnp->gp_tasks)
-			rnp->gp_tasks = np;
+			WRITE_ONCE(rnp->gp_tasks, np);
 		if (&t->rcu_node_entry == rnp->exp_tasks)
 			rnp->exp_tasks = np;
 		if (IS_ENABLED(CONFIG_RCU_BOOST)) {
@@ -663,7 +663,7 @@ static void rcu_preempt_check_blocked_ta
 		dump_blkd_tasks(rnp, 10);
 	if (rcu_preempt_has_tasks(rnp) &&
 	    (rnp->qsmaskinit || rnp->wait_blkd_tasks)) {
-		rnp->gp_tasks = rnp->blkd_tasks.next;
+		WRITE_ONCE(rnp->gp_tasks, rnp->blkd_tasks.next);
 		t = container_of(rnp->gp_tasks, struct task_struct,
 				 rcu_node_entry);
 		trace_rcu_unlock_preempted_task(TPS("rcu_preempt-GPS"),
@@ -757,7 +757,8 @@ dump_blkd_tasks(struct rcu_node *rnp, in
 		pr_info("%s: %d:%d ->qsmask %#lx ->qsmaskinit %#lx ->qsmaskinitnext %#lx\n",
 			__func__, rnp1->grplo, rnp1->grphi, rnp1->qsmask, rnp1->qsmaskinit, rnp1->qsmaskinitnext);
 	pr_info("%s: ->gp_tasks %p ->boost_tasks %p ->exp_tasks %p\n",
-		__func__, rnp->gp_tasks, rnp->boost_tasks, rnp->exp_tasks);
+		__func__, READ_ONCE(rnp->gp_tasks), rnp->boost_tasks,
+		rnp->exp_tasks);
 	pr_info("%s: ->blkd_tasks", __func__);
 	i = 0;
 	list_for_each(lhp, &rnp->blkd_tasks) {


