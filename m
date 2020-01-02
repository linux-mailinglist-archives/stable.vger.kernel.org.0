Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F21A812EFFE
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:50:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727937AbgABWuD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:50:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:52370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729334AbgABWZ5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:25:57 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C2D120863;
        Thu,  2 Jan 2020 22:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003956;
        bh=ZLDF4Ltf4G5UjoR9/zQzd+JPen874KVc/sz60PX8f8Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fMr6Xsq6HDLWjVHGoyg7atsJD23iAA7FE8cF9eOCNi8V2rtlZo07KAEKVeMR0q/Qt
         W/qJRdtIMjPpqoQ239uEFCpsa2Lx0znh6uT/pQolWfat08f8GITAT6cy9jt8iDWTLc
         08vQPkMpNntSClYscH9+goTqbi7k3BB2t9vI101E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, syzbot <syzkaller@googlegroups.com>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 4.14 70/91] hrtimer: Annotate lockless access to timer->state
Date:   Thu,  2 Jan 2020 23:07:52 +0100
Message-Id: <20200102220445.979779818@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220356.856162165@linuxfoundation.org>
References: <20200102220356.856162165@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit 56144737e67329c9aaed15f942d46a6302e2e3d8 upstream.

syzbot reported various data-race caused by hrtimer_is_queued() reading
timer->state. A READ_ONCE() is required there to silence the warning.

Also add the corresponding WRITE_ONCE() when timer->state is set.

In remove_hrtimer() the hrtimer_is_queued() helper is open coded to avoid
loading timer->state twice.

KCSAN reported these cases:

BUG: KCSAN: data-race in __remove_hrtimer / tcp_pacing_check

write to 0xffff8880b2a7d388 of 1 bytes by interrupt on cpu 0:
 __remove_hrtimer+0x52/0x130 kernel/time/hrtimer.c:991
 __run_hrtimer kernel/time/hrtimer.c:1496 [inline]
 __hrtimer_run_queues+0x250/0x600 kernel/time/hrtimer.c:1576
 hrtimer_run_softirq+0x10e/0x150 kernel/time/hrtimer.c:1593
 __do_softirq+0x115/0x33f kernel/softirq.c:292
 run_ksoftirqd+0x46/0x60 kernel/softirq.c:603
 smpboot_thread_fn+0x37d/0x4a0 kernel/smpboot.c:165
 kthread+0x1d4/0x200 drivers/block/aoe/aoecmd.c:1253
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:352

read to 0xffff8880b2a7d388 of 1 bytes by task 24652 on cpu 1:
 tcp_pacing_check net/ipv4/tcp_output.c:2235 [inline]
 tcp_pacing_check+0xba/0x130 net/ipv4/tcp_output.c:2225
 tcp_xmit_retransmit_queue+0x32c/0x5a0 net/ipv4/tcp_output.c:3044
 tcp_xmit_recovery+0x7c/0x120 net/ipv4/tcp_input.c:3558
 tcp_ack+0x17b6/0x3170 net/ipv4/tcp_input.c:3717
 tcp_rcv_established+0x37e/0xf50 net/ipv4/tcp_input.c:5696
 tcp_v4_do_rcv+0x381/0x4e0 net/ipv4/tcp_ipv4.c:1561
 sk_backlog_rcv include/net/sock.h:945 [inline]
 __release_sock+0x135/0x1e0 net/core/sock.c:2435
 release_sock+0x61/0x160 net/core/sock.c:2951
 sk_stream_wait_memory+0x3d7/0x7c0 net/core/stream.c:145
 tcp_sendmsg_locked+0xb47/0x1f30 net/ipv4/tcp.c:1393
 tcp_sendmsg+0x39/0x60 net/ipv4/tcp.c:1434
 inet_sendmsg+0x6d/0x90 net/ipv4/af_inet.c:807
 sock_sendmsg_nosec net/socket.c:637 [inline]
 sock_sendmsg+0x9f/0xc0 net/socket.c:657

BUG: KCSAN: data-race in __remove_hrtimer / __tcp_ack_snd_check

write to 0xffff8880a3a65588 of 1 bytes by interrupt on cpu 0:
 __remove_hrtimer+0x52/0x130 kernel/time/hrtimer.c:991
 __run_hrtimer kernel/time/hrtimer.c:1496 [inline]
 __hrtimer_run_queues+0x250/0x600 kernel/time/hrtimer.c:1576
 hrtimer_run_softirq+0x10e/0x150 kernel/time/hrtimer.c:1593
 __do_softirq+0x115/0x33f kernel/softirq.c:292
 invoke_softirq kernel/softirq.c:373 [inline]
 irq_exit+0xbb/0xe0 kernel/softirq.c:413
 exiting_irq arch/x86/include/asm/apic.h:536 [inline]
 smp_apic_timer_interrupt+0xe6/0x280 arch/x86/kernel/apic/apic.c:1137
 apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:830

read to 0xffff8880a3a65588 of 1 bytes by task 22891 on cpu 1:
 __tcp_ack_snd_check+0x415/0x4f0 net/ipv4/tcp_input.c:5265
 tcp_ack_snd_check net/ipv4/tcp_input.c:5287 [inline]
 tcp_rcv_established+0x750/0xf50 net/ipv4/tcp_input.c:5708
 tcp_v4_do_rcv+0x381/0x4e0 net/ipv4/tcp_ipv4.c:1561
 sk_backlog_rcv include/net/sock.h:945 [inline]
 __release_sock+0x135/0x1e0 net/core/sock.c:2435
 release_sock+0x61/0x160 net/core/sock.c:2951
 sk_stream_wait_memory+0x3d7/0x7c0 net/core/stream.c:145
 tcp_sendmsg_locked+0xb47/0x1f30 net/ipv4/tcp.c:1393
 tcp_sendmsg+0x39/0x60 net/ipv4/tcp.c:1434
 inet_sendmsg+0x6d/0x90 net/ipv4/af_inet.c:807
 sock_sendmsg_nosec net/socket.c:637 [inline]
 sock_sendmsg+0x9f/0xc0 net/socket.c:657
 __sys_sendto+0x21f/0x320 net/socket.c:1952
 __do_sys_sendto net/socket.c:1964 [inline]
 __se_sys_sendto net/socket.c:1960 [inline]
 __x64_sys_sendto+0x89/0xb0 net/socket.c:1960
 do_syscall_64+0xcc/0x370 arch/x86/entry/common.c:290

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 24652 Comm: syz-executor.3 Not tainted 5.4.0-rc3+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

[ tglx: Added comments ]

Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/20191106174804.74723-1-edumazet@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/hrtimer.h |   14 ++++++++++----
 kernel/time/hrtimer.c   |   11 +++++++----
 2 files changed, 17 insertions(+), 8 deletions(-)

--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -408,12 +408,18 @@ extern u64 hrtimer_get_next_event(void);
 
 extern bool hrtimer_active(const struct hrtimer *timer);
 
-/*
- * Helper function to check, whether the timer is on one of the queues
+/**
+ * hrtimer_is_queued = check, whether the timer is on one of the queues
+ * @timer:	Timer to check
+ *
+ * Returns: True if the timer is queued, false otherwise
+ *
+ * The function can be used lockless, but it gives only a current snapshot.
  */
-static inline int hrtimer_is_queued(struct hrtimer *timer)
+static inline bool hrtimer_is_queued(struct hrtimer *timer)
 {
-	return timer->state & HRTIMER_STATE_ENQUEUED;
+	/* The READ_ONCE pairs with the update functions of timer->state */
+	return !!(READ_ONCE(timer->state) & HRTIMER_STATE_ENQUEUED);
 }
 
 /*
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -845,7 +845,8 @@ static int enqueue_hrtimer(struct hrtime
 
 	base->cpu_base->active_bases |= 1 << base->index;
 
-	timer->state = HRTIMER_STATE_ENQUEUED;
+	/* Pairs with the lockless read in hrtimer_is_queued() */
+	WRITE_ONCE(timer->state, HRTIMER_STATE_ENQUEUED);
 
 	return timerqueue_add(&base->active, &timer->node);
 }
@@ -867,7 +868,8 @@ static void __remove_hrtimer(struct hrti
 	struct hrtimer_cpu_base *cpu_base = base->cpu_base;
 	u8 state = timer->state;
 
-	timer->state = newstate;
+	/* Pairs with the lockless read in hrtimer_is_queued() */
+	WRITE_ONCE(timer->state, newstate);
 	if (!(state & HRTIMER_STATE_ENQUEUED))
 		return;
 
@@ -894,8 +896,9 @@ static void __remove_hrtimer(struct hrti
 static inline int
 remove_hrtimer(struct hrtimer *timer, struct hrtimer_clock_base *base, bool restart)
 {
-	if (hrtimer_is_queued(timer)) {
-		u8 state = timer->state;
+	u8 state = timer->state;
+
+	if (state & HRTIMER_STATE_ENQUEUED) {
 		int reprogram;
 
 		/*


