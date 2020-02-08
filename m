Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A384156609
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 19:31:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727751AbgBHS3t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 13:29:49 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34330 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727912AbgBHS3q (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 13:29:46 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrK-0003g8-4o; Sat, 08 Feb 2020 18:29:38 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrI-000CQ2-MN; Sat, 08 Feb 2020 18:29:36 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Eric Dumazet" <edumazet@google.com>,
        "syzbot" <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>
Date:   Sat, 08 Feb 2020 18:20:21 +0000
Message-ID: <lsq.1581185940.697104957@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 082/148] inetpeer: fix data-race in inet_putpeer /
 inet_putpeer
In-Reply-To: <lsq.1581185939.857586636@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.82-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 71685eb4ce80ae9c49eff82ca4dd15acab215de9 upstream.

We need to explicitely forbid read/store tearing in inet_peer_gc()
and inet_putpeer().

The following syzbot report reminds us about inet_putpeer()
running without a lock held.

BUG: KCSAN: data-race in inet_putpeer / inet_putpeer

write to 0xffff888121fb2ed0 of 4 bytes by interrupt on cpu 0:
 inet_putpeer+0x37/0xa0 net/ipv4/inetpeer.c:240
 ip4_frag_free+0x3d/0x50 net/ipv4/ip_fragment.c:102
 inet_frag_destroy_rcu+0x58/0x80 net/ipv4/inet_fragment.c:228
 __rcu_reclaim kernel/rcu/rcu.h:222 [inline]
 rcu_do_batch+0x256/0x5b0 kernel/rcu/tree.c:2157
 rcu_core+0x369/0x4d0 kernel/rcu/tree.c:2377
 rcu_core_si+0x12/0x20 kernel/rcu/tree.c:2386
 __do_softirq+0x115/0x33f kernel/softirq.c:292
 invoke_softirq kernel/softirq.c:373 [inline]
 irq_exit+0xbb/0xe0 kernel/softirq.c:413
 exiting_irq arch/x86/include/asm/apic.h:536 [inline]
 smp_apic_timer_interrupt+0xe6/0x280 arch/x86/kernel/apic/apic.c:1137
 apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:830
 native_safe_halt+0xe/0x10 arch/x86/kernel/paravirt.c:71
 arch_cpu_idle+0x1f/0x30 arch/x86/kernel/process.c:571
 default_idle_call+0x1e/0x40 kernel/sched/idle.c:94
 cpuidle_idle_call kernel/sched/idle.c:154 [inline]
 do_idle+0x1af/0x280 kernel/sched/idle.c:263

write to 0xffff888121fb2ed0 of 4 bytes by interrupt on cpu 1:
 inet_putpeer+0x37/0xa0 net/ipv4/inetpeer.c:240
 ip4_frag_free+0x3d/0x50 net/ipv4/ip_fragment.c:102
 inet_frag_destroy_rcu+0x58/0x80 net/ipv4/inet_fragment.c:228
 __rcu_reclaim kernel/rcu/rcu.h:222 [inline]
 rcu_do_batch+0x256/0x5b0 kernel/rcu/tree.c:2157
 rcu_core+0x369/0x4d0 kernel/rcu/tree.c:2377
 rcu_core_si+0x12/0x20 kernel/rcu/tree.c:2386
 __do_softirq+0x115/0x33f kernel/softirq.c:292
 run_ksoftirqd+0x46/0x60 kernel/softirq.c:603
 smpboot_thread_fn+0x37d/0x4a0 kernel/smpboot.c:165
 kthread+0x1d4/0x200 drivers/block/aoe/aoecmd.c:1253
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:352

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 16 Comm: ksoftirqd/1 Not tainted 5.4.0-rc3+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Fixes: 4b9d9be839fd ("inetpeer: remove unused list")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[bwh: Backported to 3.16:
 - Use ACCESS_ONCE() instead of {READ,WRITE}_ONCE()
 - Adjust context, indentation]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv4/inetpeer.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/net/ipv4/inetpeer.c
+++ b/net/ipv4/inetpeer.c
@@ -419,7 +419,12 @@ static int inet_peer_gc(struct inet_peer
 		p = rcu_deref_locked(**stackptr, base);
 		if (atomic_read(&p->refcnt) == 0) {
 			smp_rmb();
-			delta = (__u32)jiffies - p->dtime;
+
+			/* The ACCESS_ONCE() pairs with the ACCESS_ONCE()
+			 * in inet_putpeer()
+			 */
+			delta = (__u32)jiffies - ACCESS_ONCE(p->dtime);
+
 			if (delta >= ttl &&
 			    atomic_cmpxchg(&p->refcnt, 0, -1) == 0) {
 				p->gc_next = gchead;
@@ -504,7 +509,10 @@ EXPORT_SYMBOL_GPL(inet_getpeer);
 
 void inet_putpeer(struct inet_peer *p)
 {
-	p->dtime = (__u32)jiffies;
+	/* The ACCESS_ONCE() pairs with itself (we run lockless)
+	 * and the ACCESS_ONCE() in inet_peer_gc()
+	 */
+	ACCESS_ONCE(p->dtime) = (__u32)jiffies;
 	smp_mb__before_atomic();
 	atomic_dec(&p->refcnt);
 }

