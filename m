Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE86B172124
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:47:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729795AbgB0No2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 08:44:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:39944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730212AbgB0No1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:44:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6F7020726;
        Thu, 27 Feb 2020 13:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582811066;
        bh=M2GwOBsJPTU/gH5nnLIvxg5gkcietonzkfSQO9QeHZs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MOvuH9bOcvkww9BQ9onOx62rCPPw9uEC34MoawRn1SLrI1sKwD/duj+KicOCfbX1J
         AJkopgcfgoHDTtmNmsNsSILcF7VwKdHTNNEnJ/HLXL+QAXv9bwVAjcrfMmzFjKjJJj
         oWfSqVurnJ6oiWhu2qtns9HeJ/0W5vWYq8MawKqc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH 4.4 054/113] rcu: Use WRITE_ONCE() for assignments to ->pprev for hlist_nulls
Date:   Thu, 27 Feb 2020 14:36:10 +0100
Message-Id: <20200227132220.401442785@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132211.791484803@linuxfoundation.org>
References: <20200227132211.791484803@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul E. McKenney <paulmck@kernel.org>

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
index 444d2b1313bda..703928e4fd42d 100644
--- a/include/linux/list_nulls.h
+++ b/include/linux/list_nulls.h
@@ -66,10 +66,10 @@ static inline void hlist_nulls_add_head(struct hlist_nulls_node *n,
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
@@ -79,13 +79,13 @@ static inline void __hlist_nulls_del(struct hlist_nulls_node *n)
 
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
index 1c33dd7da4a7d..f35dc0a1d6ebc 100644
--- a/include/linux/rculist_nulls.h
+++ b/include/linux/rculist_nulls.h
@@ -33,7 +33,7 @@ static inline void hlist_nulls_del_init_rcu(struct hlist_nulls_node *n)
 {
 	if (!hlist_nulls_unhashed(n)) {
 		__hlist_nulls_del(n);
-		n->pprev = NULL;
+		WRITE_ONCE(n->pprev, NULL);
 	}
 }
 
@@ -65,7 +65,7 @@ static inline void hlist_nulls_del_init_rcu(struct hlist_nulls_node *n)
 static inline void hlist_nulls_del_rcu(struct hlist_nulls_node *n)
 {
 	__hlist_nulls_del(n);
-	n->pprev = LIST_POISON2;
+	WRITE_ONCE(n->pprev, LIST_POISON2);
 }
 
 /**
@@ -93,10 +93,10 @@ static inline void hlist_nulls_add_head_rcu(struct hlist_nulls_node *n,
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
  * hlist_nulls_for_each_entry_rcu - iterate over rcu list of given type
-- 
2.20.1



