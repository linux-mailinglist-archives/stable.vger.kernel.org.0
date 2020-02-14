Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC64C15E922
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:05:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404059AbgBNQPC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:15:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:44968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392420AbgBNQPB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:15:01 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9B9A246E3;
        Fri, 14 Feb 2020 16:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696900;
        bh=cldcMUZ+n6GGb4CcpB3xjq3wxG6GbSXzVfAQyHf4vHg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O2lbcbTM4gluLctPFZM07wdR0HokHTm9nCs4uVs6V+OPAR/LV2K6LPu46HOh9Lazj
         LIBFKmgxU/pM7sHs2OCGHETi/mq9lsN+lgybm7diRIdPEzbbsxuXrh447IsXAG/pSV
         CM453mdM6x4enwD3i1Qn+DrF+GKeD1naE+KHJgqM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Paul E. McKenney" <paulmck@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Sasha Levin <sashal@kernel.org>, rcu@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 151/252] rcu: Use WRITE_ONCE() for assignments to ->pprev for hlist_nulls
Date:   Fri, 14 Feb 2020 11:10:06 -0500
Message-Id: <20200214161147.15842-151-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161147.15842-1-sashal@kernel.org>
References: <20200214161147.15842-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Paul E. McKenney" <paulmck@kernel.org>

[ Upstream commit 860c8802ace14c646864795e057349c9fb2d60ad ]

Eric Dumazet supplied a KCSAN report of a bug that forces use
of hlist_unhashed_lockless() from sk_unhashed():

------------------------------------------------------------------------

BUG: KCSAN: data-race in inet_unhash / inet_unhash

write to 0xffff8880a69a0170 of 8 bytes by interrupt on cpu 1:
 __hlist_nulls_del include/linux/list_nulls.h:88 [inline]
 hlist_nulls_del_init_rcu include/linux/rculist_nulls.h:36 [inline]
 __sk_nulls_del_node_init_rcu include/net/sock.h:676 [inline]
 inet_unhash+0x38f/0x4a0 net/ipv4/inet_hashtables.c:612
 tcp_set_state+0xfa/0x3e0 net/ipv4/tcp.c:2249
 tcp_done+0x93/0x1e0 net/ipv4/tcp.c:3854
 tcp_write_err+0x7e/0xc0 net/ipv4/tcp_timer.c:56
 tcp_retransmit_timer+0x9b8/0x16d0 net/ipv4/tcp_timer.c:479
 tcp_write_timer_handler+0x42d/0x510 net/ipv4/tcp_timer.c:599
 tcp_write_timer+0xd1/0xf0 net/ipv4/tcp_timer.c:619
 call_timer_fn+0x5f/0x2f0 kernel/time/timer.c:1404
 expire_timers kernel/time/timer.c:1449 [inline]
 __run_timers kernel/time/timer.c:1773 [inline]
 __run_timers kernel/time/timer.c:1740 [inline]
 run_timer_softirq+0xc0c/0xcd0 kernel/time/timer.c:1786
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
 cpu_startup_entry+0x1b/0x20 kernel/sched/idle.c:355
 start_secondary+0x208/0x260 arch/x86/kernel/smpboot.c:264
 secondary_startup_64+0xa4/0xb0 arch/x86/kernel/head_64.S:241

read to 0xffff8880a69a0170 of 8 bytes by interrupt on cpu 0:
 sk_unhashed include/net/sock.h:607 [inline]
 inet_unhash+0x3d/0x4a0 net/ipv4/inet_hashtables.c:592
 tcp_set_state+0xfa/0x3e0 net/ipv4/tcp.c:2249
 tcp_done+0x93/0x1e0 net/ipv4/tcp.c:3854
 tcp_write_err+0x7e/0xc0 net/ipv4/tcp_timer.c:56
 tcp_retransmit_timer+0x9b8/0x16d0 net/ipv4/tcp_timer.c:479
 tcp_write_timer_handler+0x42d/0x510 net/ipv4/tcp_timer.c:599
 tcp_write_timer+0xd1/0xf0 net/ipv4/tcp_timer.c:619
 call_timer_fn+0x5f/0x2f0 kernel/time/timer.c:1404
 expire_timers kernel/time/timer.c:1449 [inline]
 __run_timers kernel/time/timer.c:1773 [inline]
 __run_timers kernel/time/timer.c:1740 [inline]
 run_timer_softirq+0xc0c/0xcd0 kernel/time/timer.c:1786
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
 cpu_startup_entry+0x1b/0x20 kernel/sched/idle.c:355
 rest_init+0xec/0xf6 init/main.c:452
 arch_call_rest_init+0x17/0x37
 start_kernel+0x838/0x85e init/main.c:786
 x86_64_start_reservations+0x29/0x2b arch/x86/kernel/head64.c:490
 x86_64_start_kernel+0x72/0x76 arch/x86/kernel/head64.c:471
 secondary_startup_64+0xa4/0xb0 arch/x86/kernel/head_64.S:241

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.4.0-rc6+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine,
BIOS Google 01/01/2011

------------------------------------------------------------------------

This commit therefore replaces C-language assignments with WRITE_ONCE()
in include/linux/list_nulls.h and include/linux/rculist_nulls.h.

Reported-by: Eric Dumazet <edumazet@google.com> # For KCSAN
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/list_nulls.h    | 8 ++++----
 include/linux/rculist_nulls.h | 8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/linux/list_nulls.h b/include/linux/list_nulls.h
index 3ef96743db8da..1ecd35664e0d3 100644
--- a/include/linux/list_nulls.h
+++ b/include/linux/list_nulls.h
@@ -72,10 +72,10 @@ static inline void hlist_nulls_add_head(struct hlist_nulls_node *n,
 	struct hlist_nulls_node *first = h->first;
 
 	n->next = first;
-	n->pprev = &h->first;
+	WRITE_ONCE(n->pprev, &h->first);
 	h->first = n;
 	if (!is_a_nulls(first))
-		first->pprev = &n->next;
+		WRITE_ONCE(first->pprev, &n->next);
 }
 
 static inline void __hlist_nulls_del(struct hlist_nulls_node *n)
@@ -85,13 +85,13 @@ static inline void __hlist_nulls_del(struct hlist_nulls_node *n)
 
 	WRITE_ONCE(*pprev, next);
 	if (!is_a_nulls(next))
-		next->pprev = pprev;
+		WRITE_ONCE(next->pprev, pprev);
 }
 
 static inline void hlist_nulls_del(struct hlist_nulls_node *n)
 {
 	__hlist_nulls_del(n);
-	n->pprev = LIST_POISON2;
+	WRITE_ONCE(n->pprev, LIST_POISON2);
 }
 
 /**
diff --git a/include/linux/rculist_nulls.h b/include/linux/rculist_nulls.h
index 61974c4c566be..90f2e2232c6d7 100644
--- a/include/linux/rculist_nulls.h
+++ b/include/linux/rculist_nulls.h
@@ -34,7 +34,7 @@ static inline void hlist_nulls_del_init_rcu(struct hlist_nulls_node *n)
 {
 	if (!hlist_nulls_unhashed(n)) {
 		__hlist_nulls_del(n);
-		n->pprev = NULL;
+		WRITE_ONCE(n->pprev, NULL);
 	}
 }
 
@@ -66,7 +66,7 @@ static inline void hlist_nulls_del_init_rcu(struct hlist_nulls_node *n)
 static inline void hlist_nulls_del_rcu(struct hlist_nulls_node *n)
 {
 	__hlist_nulls_del(n);
-	n->pprev = LIST_POISON2;
+	WRITE_ONCE(n->pprev, LIST_POISON2);
 }
 
 /**
@@ -94,10 +94,10 @@ static inline void hlist_nulls_add_head_rcu(struct hlist_nulls_node *n,
 	struct hlist_nulls_node *first = h->first;
 
 	n->next = first;
-	n->pprev = &h->first;
+	WRITE_ONCE(n->pprev, &h->first);
 	rcu_assign_pointer(hlist_nulls_first_rcu(h), n);
 	if (!is_a_nulls(first))
-		first->pprev = &n->next;
+		WRITE_ONCE(first->pprev, &n->next);
 }
 
 /**
-- 
2.20.1

