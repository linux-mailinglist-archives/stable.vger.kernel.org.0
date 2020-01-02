Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9A412EC38
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:16:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728244AbgABWQ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:16:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:58386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727171AbgABWQ2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:16:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF02C227BF;
        Thu,  2 Jan 2020 22:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003387;
        bh=xp112zKb8v80psbV/puqDOGOBn1/rLffnVodRk8j5xw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U9iEUlveVhZWCgqHluZkPMsnl8vcHWwJcBEEZ3B1t+hGjtKmpOtkMkns9xFKdGyPw
         L/1wGY0uD0q7IeF7HFH2hYYQy4S7WoB1roKetIgjMCUijX2jzC+RKXVY7soDlmox+6
         6PaOFADtAi5yTKUIoEh6LsoENJads6CXy4H+sNZI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 139/191] inetpeer: fix data-race in inet_putpeer / inet_putpeer
Date:   Thu,  2 Jan 2020 23:07:01 +0100
Message-Id: <20200102215844.479691102@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ipv4/inetpeer.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/net/ipv4/inetpeer.c
+++ b/net/ipv4/inetpeer.c
@@ -160,7 +160,12 @@ static void inet_peer_gc(struct inet_pee
 					base->total / inet_peer_threshold * HZ;
 	for (i = 0; i < gc_cnt; i++) {
 		p = gc_stack[i];
-		delta = (__u32)jiffies - p->dtime;
+
+		/* The READ_ONCE() pairs with the WRITE_ONCE()
+		 * in inet_putpeer()
+		 */
+		delta = (__u32)jiffies - READ_ONCE(p->dtime);
+
 		if (delta < ttl || !refcount_dec_if_one(&p->refcnt))
 			gc_stack[i] = NULL;
 	}
@@ -237,7 +242,10 @@ EXPORT_SYMBOL_GPL(inet_getpeer);
 
 void inet_putpeer(struct inet_peer *p)
 {
-	p->dtime = (__u32)jiffies;
+	/* The WRITE_ONCE() pairs with itself (we run lockless)
+	 * and the READ_ONCE() in inet_peer_gc()
+	 */
+	WRITE_ONCE(p->dtime, (__u32)jiffies);
 
 	if (refcount_dec_and_test(&p->refcnt))
 		call_rcu(&p->rcu, inetpeer_free_rcu);


