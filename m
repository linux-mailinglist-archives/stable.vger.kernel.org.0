Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 070ACEEE0F
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:13:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390636AbfKDWLK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:11:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:44376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390633AbfKDWLH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:11:07 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C6CD214D9;
        Mon,  4 Nov 2019 22:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572905465;
        bh=b3mj3NJuqpAEPJuUoGDDueMjqzi4Kg8IgvA79VefASI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FzfU+OydqJmSBk1HnluApHT5y0qtXveKe5hrHiuA/wK4CAQgmagDCJa1jm7gXE0lt
         1oehqzGwGKUE+z8FH9yf3/qhUUxMc47XqDE/1EhtvBdMr+Yz/f5RTkpUjxM/Dr38XO
         G1MYh53NfRvFpnUW4kmpBtk0HCW0LR5NkyLWk3g8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+ac54455281db908c581e@syzkaller.appspotmail.com,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 156/163] net: sched: sch_sfb: dont call qdisc_put() while holding tree lock
Date:   Mon,  4 Nov 2019 22:45:46 +0100
Message-Id: <20191104212151.567291131@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212140.046021995@linuxfoundation.org>
References: <20191104212140.046021995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>

commit e3ae1f96accd21405715fe9c56b4d83bc7d96d44 upstream.

Recent changes that removed rtnl dependency from rules update path of tc
also made tcf_block_put() function sleeping. This function is called from
ops->destroy() of several Qdisc implementations, which in turn is called by
qdisc_put(). Some Qdiscs call qdisc_put() while holding sch tree spinlock,
which results sleeping-while-atomic BUG.

Steps to reproduce for sfb:

tc qdisc add dev ens1f0 handle 1: root sfb
tc qdisc add dev ens1f0 parent 1:10 handle 50: sfq perturb 10
tc qdisc change dev ens1f0 root handle 1: sfb

Resulting dmesg:

[ 7265.938717] BUG: sleeping function called from invalid context at kernel/locking/mutex.c:909
[ 7265.940152] in_atomic(): 1, irqs_disabled(): 0, pid: 28579, name: tc
[ 7265.941455] INFO: lockdep is turned off.
[ 7265.942744] CPU: 11 PID: 28579 Comm: tc Tainted: G        W         5.3.0-rc8+ #721
[ 7265.944065] Hardware name: Supermicro SYS-2028TP-DECR/X10DRT-P, BIOS 2.0b 03/30/2017
[ 7265.945396] Call Trace:
[ 7265.946709]  dump_stack+0x85/0xc0
[ 7265.947994]  ___might_sleep.cold+0xac/0xbc
[ 7265.949282]  __mutex_lock+0x5b/0x960
[ 7265.950543]  ? tcf_chain0_head_change_cb_del.isra.0+0x1b/0xf0
[ 7265.951803]  ? tcf_chain0_head_change_cb_del.isra.0+0x1b/0xf0
[ 7265.953022]  tcf_chain0_head_change_cb_del.isra.0+0x1b/0xf0
[ 7265.954248]  tcf_block_put_ext.part.0+0x21/0x50
[ 7265.955478]  tcf_block_put+0x50/0x70
[ 7265.956694]  sfq_destroy+0x15/0x50 [sch_sfq]
[ 7265.957898]  qdisc_destroy+0x5f/0x160
[ 7265.959099]  sfb_change+0x175/0x330 [sch_sfb]
[ 7265.960304]  tc_modify_qdisc+0x324/0x840
[ 7265.961503]  rtnetlink_rcv_msg+0x170/0x4b0
[ 7265.962692]  ? netlink_deliver_tap+0x95/0x400
[ 7265.963876]  ? rtnl_dellink+0x2d0/0x2d0
[ 7265.965064]  netlink_rcv_skb+0x49/0x110
[ 7265.966251]  netlink_unicast+0x171/0x200
[ 7265.967427]  netlink_sendmsg+0x224/0x3f0
[ 7265.968595]  sock_sendmsg+0x5e/0x60
[ 7265.969753]  ___sys_sendmsg+0x2ae/0x330
[ 7265.970916]  ? ___sys_recvmsg+0x159/0x1f0
[ 7265.972074]  ? do_wp_page+0x9c/0x790
[ 7265.973233]  ? __handle_mm_fault+0xcd3/0x19e0
[ 7265.974407]  __sys_sendmsg+0x59/0xa0
[ 7265.975591]  do_syscall_64+0x5c/0xb0
[ 7265.976753]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[ 7265.977938] RIP: 0033:0x7f229069f7b8
[ 7265.979117] Code: 89 02 48 c7 c0 ff ff ff ff eb bb 0f 1f 80 00 00 00 00 f3 0f 1e fa 48 8d 05 65 8f 0c 00 8b 00 85 c0 75 17 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 58 c3 0f 1f 80 00 00 00 00 48 83 ec 28 89 5
4
[ 7265.981681] RSP: 002b:00007ffd7ed2d158 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
[ 7265.983001] RAX: ffffffffffffffda RBX: 000000005d813ca1 RCX: 00007f229069f7b8
[ 7265.984336] RDX: 0000000000000000 RSI: 00007ffd7ed2d1c0 RDI: 0000000000000003
[ 7265.985682] RBP: 0000000000000000 R08: 0000000000000001 R09: 000000000165c9a0
[ 7265.987021] R10: 0000000000404eda R11: 0000000000000246 R12: 0000000000000001
[ 7265.988309] R13: 000000000047f640 R14: 0000000000000000 R15: 0000000000000000

In sfb_change() function use qdisc_purge_queue() instead of
qdisc_tree_flush_backlog() to properly reset old child Qdisc and save
pointer to it into local temporary variable. Put reference to Qdisc after
sch tree lock is released in order not to call potentially sleeping cls API
in atomic section. This is safe to do because Qdisc has already been reset
by qdisc_purge_queue() inside sch tree lock critical section.

Reported-by: syzbot+ac54455281db908c581e@syzkaller.appspotmail.com
Fixes: c266f64dbfa2 ("net: sched: protect block state with mutex")
Suggested-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sched/sch_sfb.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/net/sched/sch_sfb.c
+++ b/net/sched/sch_sfb.c
@@ -488,7 +488,7 @@ static int sfb_change(struct Qdisc *sch,
 		      struct netlink_ext_ack *extack)
 {
 	struct sfb_sched_data *q = qdisc_priv(sch);
-	struct Qdisc *child;
+	struct Qdisc *child, *old;
 	struct nlattr *tb[TCA_SFB_MAX + 1];
 	const struct tc_sfb_qopt *ctl = &sfb_default_ops;
 	u32 limit;
@@ -518,8 +518,8 @@ static int sfb_change(struct Qdisc *sch,
 		qdisc_hash_add(child, true);
 	sch_tree_lock(sch);
 
-	qdisc_tree_flush_backlog(q->qdisc);
-	qdisc_put(q->qdisc);
+	qdisc_purge_queue(q->qdisc);
+	old = q->qdisc;
 	q->qdisc = child;
 
 	q->rehash_interval = msecs_to_jiffies(ctl->rehash_interval);
@@ -542,6 +542,7 @@ static int sfb_change(struct Qdisc *sch,
 	sfb_init_perturbation(1, q);
 
 	sch_tree_unlock(sch);
+	qdisc_put(old);
 
 	return 0;
 }


