Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EBDFF7E8
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 14:03:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728635AbfD3LnP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:43:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:53166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728753AbfD3LnO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:43:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC66021734;
        Tue, 30 Apr 2019 11:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624593;
        bh=bMIyDFSNMZbDV9mwlps5UzDDiVznRcO1GZN9HpcM6iQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LK7TTeOFj7E/FC1Wrcpj9r1/TQ9z1RlRSSCEVGIG6sf1Ttm+kbU79wEuiN66jGigF
         mA9wEVuH1Gq503mguKexJhzSfTL4nx7WK/rsYo3xLI56RBXJO0ahThzOTrElwQPufj
         FoM+B67dA+88DAzcp/AxgOovfGWeJaeDpVxavAiY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 52/53] net/rose: fix unbound loop in rose_loopback_timer()
Date:   Tue, 30 Apr 2019 13:38:59 +0200
Message-Id: <20190430113559.727986231@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113549.400132183@linuxfoundation.org>
References: <20190430113549.400132183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 0453c682459583910d611a96de928f4442205493 ]

This patch adds a limit on the number of skbs that fuzzers can queue
into loopback_queue. 1000 packets for rose loopback seems more than enough.

Then, since we now have multiple cpus in most linux hosts,
we also need to limit the number of skbs rose_loopback_timer()
can dequeue at each round.

rose_loopback_queue() can be drop-monitor friendly, calling
consume_skb() or kfree_skb() appropriately.

Finally, use mod_timer() instead of del_timer() + add_timer()

syzbot report was :

rcu: INFO: rcu_preempt self-detected stall on CPU
rcu:    0-...!: (10499 ticks this GP) idle=536/1/0x4000000000000002 softirq=103291/103291 fqs=34
rcu:     (t=10500 jiffies g=140321 q=323)
rcu: rcu_preempt kthread starved for 10426 jiffies! g140321 f0x0 RCU_GP_WAIT_FQS(5) ->state=0x402 ->cpu=1
rcu: RCU grace-period kthread stack dump:
rcu_preempt     I29168    10      2 0x80000000
Call Trace:
 context_switch kernel/sched/core.c:2877 [inline]
 __schedule+0x813/0x1cc0 kernel/sched/core.c:3518
 schedule+0x92/0x180 kernel/sched/core.c:3562
 schedule_timeout+0x4db/0xfd0 kernel/time/timer.c:1803
 rcu_gp_fqs_loop kernel/rcu/tree.c:1971 [inline]
 rcu_gp_kthread+0x962/0x17b0 kernel/rcu/tree.c:2128
 kthread+0x357/0x430 kernel/kthread.c:253
 ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:352
NMI backtrace for cpu 0
CPU: 0 PID: 7632 Comm: kworker/0:4 Not tainted 5.1.0-rc5+ #172
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events iterate_cleanup_work
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x172/0x1f0 lib/dump_stack.c:113
 nmi_cpu_backtrace.cold+0x63/0xa4 lib/nmi_backtrace.c:101
 nmi_trigger_cpumask_backtrace+0x1be/0x236 lib/nmi_backtrace.c:62
 arch_trigger_cpumask_backtrace+0x14/0x20 arch/x86/kernel/apic/hw_nmi.c:38
 trigger_single_cpu_backtrace include/linux/nmi.h:164 [inline]
 rcu_dump_cpu_stacks+0x183/0x1cf kernel/rcu/tree.c:1223
 print_cpu_stall kernel/rcu/tree.c:1360 [inline]
 check_cpu_stall kernel/rcu/tree.c:1434 [inline]
 rcu_pending kernel/rcu/tree.c:3103 [inline]
 rcu_sched_clock_irq.cold+0x500/0xa4a kernel/rcu/tree.c:2544
 update_process_times+0x32/0x80 kernel/time/timer.c:1635
 tick_sched_handle+0xa2/0x190 kernel/time/tick-sched.c:161
 tick_sched_timer+0x47/0x130 kernel/time/tick-sched.c:1271
 __run_hrtimer kernel/time/hrtimer.c:1389 [inline]
 __hrtimer_run_queues+0x33e/0xde0 kernel/time/hrtimer.c:1451
 hrtimer_interrupt+0x314/0x770 kernel/time/hrtimer.c:1509
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1035 [inline]
 smp_apic_timer_interrupt+0x120/0x570 arch/x86/kernel/apic/apic.c:1060
 apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:807
RIP: 0010:__sanitizer_cov_trace_pc+0x0/0x50 kernel/kcov.c:95
Code: 89 25 b4 6e ec 08 41 bc f4 ff ff ff e8 cd 5d ea ff 48 c7 05 9e 6e ec 08 00 00 00 00 e9 a4 e9 ff ff 90 90 90 90 90 90 90 90 90 <55> 48 89 e5 48 8b 75 08 65 48 8b 04 25 00 ee 01 00 65 8b 15 c8 60
RSP: 0018:ffff8880ae807ce0 EFLAGS: 00000286 ORIG_RAX: ffffffffffffff13
RAX: ffff88806fd40640 RBX: dffffc0000000000 RCX: ffffffff863fbc56
RDX: 0000000000000100 RSI: ffffffff863fbc1d RDI: ffff88808cf94228
RBP: ffff8880ae807d10 R08: ffff88806fd40640 R09: ffffed1015d00f8b
R10: ffffed1015d00f8a R11: 0000000000000003 R12: ffff88808cf941c0
R13: 00000000fffff034 R14: ffff8882166cd840 R15: 0000000000000000
 rose_loopback_timer+0x30d/0x3f0 net/rose/rose_loopback.c:91
 call_timer_fn+0x190/0x720 kernel/time/timer.c:1325
 expire_timers kernel/time/timer.c:1362 [inline]
 __run_timers kernel/time/timer.c:1681 [inline]
 __run_timers kernel/time/timer.c:1649 [inline]
 run_timer_softirq+0x652/0x1700 kernel/time/timer.c:1694
 __do_softirq+0x266/0x95a kernel/softirq.c:293
 do_softirq_own_stack+0x2a/0x40 arch/x86/entry/entry_64.S:1027

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rose/rose_loopback.c |   27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

--- a/net/rose/rose_loopback.c
+++ b/net/rose/rose_loopback.c
@@ -16,6 +16,7 @@
 #include <linux/init.h>
 
 static struct sk_buff_head loopback_queue;
+#define ROSE_LOOPBACK_LIMIT 1000
 static struct timer_list loopback_timer;
 
 static void rose_set_loopback_timer(void);
@@ -35,29 +36,27 @@ static int rose_loopback_running(void)
 
 int rose_loopback_queue(struct sk_buff *skb, struct rose_neigh *neigh)
 {
-	struct sk_buff *skbn;
+	struct sk_buff *skbn = NULL;
 
-	skbn = skb_clone(skb, GFP_ATOMIC);
+	if (skb_queue_len(&loopback_queue) < ROSE_LOOPBACK_LIMIT)
+		skbn = skb_clone(skb, GFP_ATOMIC);
 
-	kfree_skb(skb);
-
-	if (skbn != NULL) {
+	if (skbn) {
+		consume_skb(skb);
 		skb_queue_tail(&loopback_queue, skbn);
 
 		if (!rose_loopback_running())
 			rose_set_loopback_timer();
+	} else {
+		kfree_skb(skb);
 	}
 
 	return 1;
 }
 
-
 static void rose_set_loopback_timer(void)
 {
-	del_timer(&loopback_timer);
-
-	loopback_timer.expires  = jiffies + 10;
-	add_timer(&loopback_timer);
+	mod_timer(&loopback_timer, jiffies + 10);
 }
 
 static void rose_loopback_timer(struct timer_list *unused)
@@ -68,8 +67,12 @@ static void rose_loopback_timer(struct t
 	struct sock *sk;
 	unsigned short frametype;
 	unsigned int lci_i, lci_o;
+	int count;
 
-	while ((skb = skb_dequeue(&loopback_queue)) != NULL) {
+	for (count = 0; count < ROSE_LOOPBACK_LIMIT; count++) {
+		skb = skb_dequeue(&loopback_queue);
+		if (!skb)
+			return;
 		if (skb->len < ROSE_MIN_LEN) {
 			kfree_skb(skb);
 			continue;
@@ -106,6 +109,8 @@ static void rose_loopback_timer(struct t
 			kfree_skb(skb);
 		}
 	}
+	if (!skb_queue_empty(&loopback_queue))
+		mod_timer(&loopback_timer, jiffies + 1);
 }
 
 void __exit rose_loopback_clear(void)


