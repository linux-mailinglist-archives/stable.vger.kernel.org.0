Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E811469DE6
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:35:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376874AbhLFPeA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:34:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387170AbhLFPat (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:30:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BDD3C0698E4;
        Mon,  6 Dec 2021 07:18:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D4414B8101C;
        Mon,  6 Dec 2021 15:18:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0928AC341C2;
        Mon,  6 Dec 2021 15:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803908;
        bh=QJtNh0iyNmpBLslJLX+bRWOGqlx0f3f2G10cklSoUGY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l5ejvw6r05GMnVLKhWhC0P6rZ905V8Rui1szCrgKjQGne6WJdE9flvC+obWYkqEeM
         xmOhlZ6hvPT2L1P0IZsP/Ig5Wa3xXiJXCdUkqzGO9USXNIML4f921KFJZlZPAMNrPq
         qqKrQHneivqCvwcw+7D7gA7Hw1MKAJpiCgmvAGUk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 089/130] net: annotate data-races on txq->xmit_lock_owner
Date:   Mon,  6 Dec 2021 15:56:46 +0100
Message-Id: <20211206145602.732943511@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145559.607158688@linuxfoundation.org>
References: <20211206145559.607158688@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit 7a10d8c810cfad3e79372d7d1c77899d86cd6662 upstream.

syzbot found that __dev_queue_xmit() is reading txq->xmit_lock_owner
without annotations.

No serious issue there, let's document what is happening there.

BUG: KCSAN: data-race in __dev_queue_xmit / __dev_queue_xmit

write to 0xffff888139d09484 of 4 bytes by interrupt on cpu 0:
 __netif_tx_unlock include/linux/netdevice.h:4437 [inline]
 __dev_queue_xmit+0x948/0xf70 net/core/dev.c:4229
 dev_queue_xmit_accel+0x19/0x20 net/core/dev.c:4265
 macvlan_queue_xmit drivers/net/macvlan.c:543 [inline]
 macvlan_start_xmit+0x2b3/0x3d0 drivers/net/macvlan.c:567
 __netdev_start_xmit include/linux/netdevice.h:4987 [inline]
 netdev_start_xmit include/linux/netdevice.h:5001 [inline]
 xmit_one+0x105/0x2f0 net/core/dev.c:3590
 dev_hard_start_xmit+0x72/0x120 net/core/dev.c:3606
 sch_direct_xmit+0x1b2/0x7c0 net/sched/sch_generic.c:342
 __dev_xmit_skb+0x83d/0x1370 net/core/dev.c:3817
 __dev_queue_xmit+0x590/0xf70 net/core/dev.c:4194
 dev_queue_xmit+0x13/0x20 net/core/dev.c:4259
 neigh_hh_output include/net/neighbour.h:511 [inline]
 neigh_output include/net/neighbour.h:525 [inline]
 ip6_finish_output2+0x995/0xbb0 net/ipv6/ip6_output.c:126
 __ip6_finish_output net/ipv6/ip6_output.c:191 [inline]
 ip6_finish_output+0x444/0x4c0 net/ipv6/ip6_output.c:201
 NF_HOOK_COND include/linux/netfilter.h:296 [inline]
 ip6_output+0x10e/0x210 net/ipv6/ip6_output.c:224
 dst_output include/net/dst.h:450 [inline]
 NF_HOOK include/linux/netfilter.h:307 [inline]
 ndisc_send_skb+0x486/0x610 net/ipv6/ndisc.c:508
 ndisc_send_rs+0x3b0/0x3e0 net/ipv6/ndisc.c:702
 addrconf_rs_timer+0x370/0x540 net/ipv6/addrconf.c:3898
 call_timer_fn+0x2e/0x240 kernel/time/timer.c:1421
 expire_timers+0x116/0x240 kernel/time/timer.c:1466
 __run_timers+0x368/0x410 kernel/time/timer.c:1734
 run_timer_softirq+0x2e/0x60 kernel/time/timer.c:1747
 __do_softirq+0x158/0x2de kernel/softirq.c:558
 __irq_exit_rcu kernel/softirq.c:636 [inline]
 irq_exit_rcu+0x37/0x70 kernel/softirq.c:648
 sysvec_apic_timer_interrupt+0x3e/0xb0 arch/x86/kernel/apic/apic.c:1097
 asm_sysvec_apic_timer_interrupt+0x12/0x20

read to 0xffff888139d09484 of 4 bytes by interrupt on cpu 1:
 __dev_queue_xmit+0x5e3/0xf70 net/core/dev.c:4213
 dev_queue_xmit_accel+0x19/0x20 net/core/dev.c:4265
 macvlan_queue_xmit drivers/net/macvlan.c:543 [inline]
 macvlan_start_xmit+0x2b3/0x3d0 drivers/net/macvlan.c:567
 __netdev_start_xmit include/linux/netdevice.h:4987 [inline]
 netdev_start_xmit include/linux/netdevice.h:5001 [inline]
 xmit_one+0x105/0x2f0 net/core/dev.c:3590
 dev_hard_start_xmit+0x72/0x120 net/core/dev.c:3606
 sch_direct_xmit+0x1b2/0x7c0 net/sched/sch_generic.c:342
 __dev_xmit_skb+0x83d/0x1370 net/core/dev.c:3817
 __dev_queue_xmit+0x590/0xf70 net/core/dev.c:4194
 dev_queue_xmit+0x13/0x20 net/core/dev.c:4259
 neigh_resolve_output+0x3db/0x410 net/core/neighbour.c:1523
 neigh_output include/net/neighbour.h:527 [inline]
 ip6_finish_output2+0x9be/0xbb0 net/ipv6/ip6_output.c:126
 __ip6_finish_output net/ipv6/ip6_output.c:191 [inline]
 ip6_finish_output+0x444/0x4c0 net/ipv6/ip6_output.c:201
 NF_HOOK_COND include/linux/netfilter.h:296 [inline]
 ip6_output+0x10e/0x210 net/ipv6/ip6_output.c:224
 dst_output include/net/dst.h:450 [inline]
 NF_HOOK include/linux/netfilter.h:307 [inline]
 ndisc_send_skb+0x486/0x610 net/ipv6/ndisc.c:508
 ndisc_send_rs+0x3b0/0x3e0 net/ipv6/ndisc.c:702
 addrconf_rs_timer+0x370/0x540 net/ipv6/addrconf.c:3898
 call_timer_fn+0x2e/0x240 kernel/time/timer.c:1421
 expire_timers+0x116/0x240 kernel/time/timer.c:1466
 __run_timers+0x368/0x410 kernel/time/timer.c:1734
 run_timer_softirq+0x2e/0x60 kernel/time/timer.c:1747
 __do_softirq+0x158/0x2de kernel/softirq.c:558
 __irq_exit_rcu kernel/softirq.c:636 [inline]
 irq_exit_rcu+0x37/0x70 kernel/softirq.c:648
 sysvec_apic_timer_interrupt+0x8d/0xb0 arch/x86/kernel/apic/apic.c:1097
 asm_sysvec_apic_timer_interrupt+0x12/0x20
 kcsan_setup_watchpoint+0x94/0x420 kernel/kcsan/core.c:443
 folio_test_anon include/linux/page-flags.h:581 [inline]
 PageAnon include/linux/page-flags.h:586 [inline]
 zap_pte_range+0x5ac/0x10e0 mm/memory.c:1347
 zap_pmd_range mm/memory.c:1467 [inline]
 zap_pud_range mm/memory.c:1496 [inline]
 zap_p4d_range mm/memory.c:1517 [inline]
 unmap_page_range+0x2dc/0x3d0 mm/memory.c:1538
 unmap_single_vma+0x157/0x210 mm/memory.c:1583
 unmap_vmas+0xd0/0x180 mm/memory.c:1615
 exit_mmap+0x23d/0x470 mm/mmap.c:3170
 __mmput+0x27/0x1b0 kernel/fork.c:1113
 mmput+0x3d/0x50 kernel/fork.c:1134
 exit_mm+0xdb/0x170 kernel/exit.c:507
 do_exit+0x608/0x17a0 kernel/exit.c:819
 do_group_exit+0xce/0x180 kernel/exit.c:929
 get_signal+0xfc3/0x1550 kernel/signal.c:2852
 arch_do_signal_or_restart+0x8c/0x2e0 arch/x86/kernel/signal.c:868
 handle_signal_work kernel/entry/common.c:148 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
 exit_to_user_mode_prepare+0x113/0x190 kernel/entry/common.c:207
 __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
 syscall_exit_to_user_mode+0x20/0x40 kernel/entry/common.c:300
 do_syscall_64+0x50/0xd0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae

value changed: 0x00000000 -> 0xffffffff

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 28712 Comm: syz-executor.0 Tainted: G        W         5.16.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Link: https://lore.kernel.org/r/20211130170155.2331929-1-eric.dumazet@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/netdevice.h |   19 +++++++++++++------
 net/core/dev.c            |    5 ++++-
 2 files changed, 17 insertions(+), 7 deletions(-)

--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4212,7 +4212,8 @@ static inline u32 netif_msg_init(int deb
 static inline void __netif_tx_lock(struct netdev_queue *txq, int cpu)
 {
 	spin_lock(&txq->_xmit_lock);
-	txq->xmit_lock_owner = cpu;
+	/* Pairs with READ_ONCE() in __dev_queue_xmit() */
+	WRITE_ONCE(txq->xmit_lock_owner, cpu);
 }
 
 static inline bool __netif_tx_acquire(struct netdev_queue *txq)
@@ -4229,26 +4230,32 @@ static inline void __netif_tx_release(st
 static inline void __netif_tx_lock_bh(struct netdev_queue *txq)
 {
 	spin_lock_bh(&txq->_xmit_lock);
-	txq->xmit_lock_owner = smp_processor_id();
+	/* Pairs with READ_ONCE() in __dev_queue_xmit() */
+	WRITE_ONCE(txq->xmit_lock_owner, smp_processor_id());
 }
 
 static inline bool __netif_tx_trylock(struct netdev_queue *txq)
 {
 	bool ok = spin_trylock(&txq->_xmit_lock);
-	if (likely(ok))
-		txq->xmit_lock_owner = smp_processor_id();
+
+	if (likely(ok)) {
+		/* Pairs with READ_ONCE() in __dev_queue_xmit() */
+		WRITE_ONCE(txq->xmit_lock_owner, smp_processor_id());
+	}
 	return ok;
 }
 
 static inline void __netif_tx_unlock(struct netdev_queue *txq)
 {
-	txq->xmit_lock_owner = -1;
+	/* Pairs with READ_ONCE() in __dev_queue_xmit() */
+	WRITE_ONCE(txq->xmit_lock_owner, -1);
 	spin_unlock(&txq->_xmit_lock);
 }
 
 static inline void __netif_tx_unlock_bh(struct netdev_queue *txq)
 {
-	txq->xmit_lock_owner = -1;
+	/* Pairs with READ_ONCE() in __dev_queue_xmit() */
+	WRITE_ONCE(txq->xmit_lock_owner, -1);
 	spin_unlock_bh(&txq->_xmit_lock);
 }
 
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4147,7 +4147,10 @@ static int __dev_queue_xmit(struct sk_bu
 	if (dev->flags & IFF_UP) {
 		int cpu = smp_processor_id(); /* ok because BHs are off */
 
-		if (txq->xmit_lock_owner != cpu) {
+		/* Other cpus might concurrently change txq->xmit_lock_owner
+		 * to -1 or to their cpu id, but not to our id.
+		 */
+		if (READ_ONCE(txq->xmit_lock_owner) != cpu) {
 			if (dev_xmit_recursion())
 				goto recursion_alert;
 


