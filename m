Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF0914D7F5
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729199AbfFTSNN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:13:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:41128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729188AbfFTSNM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:13:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56C80205F4;
        Thu, 20 Jun 2019 18:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561054391;
        bh=p9hmAQUJusUI99n1JUXlwchn+tXW9z4v2lUCvzTYy3I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tMaGGQpIC4+PNY15W/WJ26Grr85n8yCAJjIchHIpIV8m1gY1/KE9vE2dCCdlRiDi3
         FloDx485qnK1BVkSgVTqBVqYvMczfdijIGUBHEBi+nDtynH/WRr67bgzmLDGRdcEt1
         qdgDemwIpmAhDPal0AJZm10kkBYNLPTROvbPDKQg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.1 02/98] ax25: fix inconsistent lock state in ax25_destroy_timer
Date:   Thu, 20 Jun 2019 19:56:29 +0200
Message-Id: <20190620174349.532510588@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174349.443386789@linuxfoundation.org>
References: <20190620174349.443386789@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit d4d5d8e83c9616aeef28a2869cea49cc3fb35526 ]

Before thread in process context uses bh_lock_sock()
we must disable bh.

sysbot reported :

WARNING: inconsistent lock state
5.2.0-rc3+ #32 Not tainted

inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
blkid/26581 [HC0[0]:SC1[1]:HE1:SE0] takes:
00000000e0da85ee (slock-AF_AX25){+.?.}, at: spin_lock include/linux/spinlock.h:338 [inline]
00000000e0da85ee (slock-AF_AX25){+.?.}, at: ax25_destroy_timer+0x53/0xc0 net/ax25/af_ax25.c:275
{SOFTIRQ-ON-W} state was registered at:
  lock_acquire+0x16f/0x3f0 kernel/locking/lockdep.c:4303
  __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
  _raw_spin_lock+0x2f/0x40 kernel/locking/spinlock.c:151
  spin_lock include/linux/spinlock.h:338 [inline]
  ax25_rt_autobind+0x3ca/0x720 net/ax25/ax25_route.c:429
  ax25_connect.cold+0x30/0xa4 net/ax25/af_ax25.c:1221
  __sys_connect+0x264/0x330 net/socket.c:1834
  __do_sys_connect net/socket.c:1845 [inline]
  __se_sys_connect net/socket.c:1842 [inline]
  __x64_sys_connect+0x73/0xb0 net/socket.c:1842
  do_syscall_64+0xfd/0x680 arch/x86/entry/common.c:301
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
irq event stamp: 2272
hardirqs last  enabled at (2272): [<ffffffff810065f3>] trace_hardirqs_on_thunk+0x1a/0x1c
hardirqs last disabled at (2271): [<ffffffff8100660f>] trace_hardirqs_off_thunk+0x1a/0x1c
softirqs last  enabled at (1522): [<ffffffff87400654>] __do_softirq+0x654/0x94c kernel/softirq.c:320
softirqs last disabled at (2267): [<ffffffff81449010>] invoke_softirq kernel/softirq.c:374 [inline]
softirqs last disabled at (2267): [<ffffffff81449010>] irq_exit+0x180/0x1d0 kernel/softirq.c:414

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(slock-AF_AX25);
  <Interrupt>
    lock(slock-AF_AX25);

 *** DEADLOCK ***

1 lock held by blkid/26581:
 #0: 0000000010fd154d ((&ax25->dtimer)){+.-.}, at: lockdep_copy_map include/linux/lockdep.h:175 [inline]
 #0: 0000000010fd154d ((&ax25->dtimer)){+.-.}, at: call_timer_fn+0xe0/0x720 kernel/time/timer.c:1312

stack backtrace:
CPU: 1 PID: 26581 Comm: blkid Not tainted 5.2.0-rc3+ #32
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x172/0x1f0 lib/dump_stack.c:113
 print_usage_bug.cold+0x393/0x4a2 kernel/locking/lockdep.c:2935
 valid_state kernel/locking/lockdep.c:2948 [inline]
 mark_lock_irq kernel/locking/lockdep.c:3138 [inline]
 mark_lock+0xd46/0x1370 kernel/locking/lockdep.c:3513
 mark_irqflags kernel/locking/lockdep.c:3391 [inline]
 __lock_acquire+0x159f/0x5490 kernel/locking/lockdep.c:3745
 lock_acquire+0x16f/0x3f0 kernel/locking/lockdep.c:4303
 __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
 _raw_spin_lock+0x2f/0x40 kernel/locking/spinlock.c:151
 spin_lock include/linux/spinlock.h:338 [inline]
 ax25_destroy_timer+0x53/0xc0 net/ax25/af_ax25.c:275
 call_timer_fn+0x193/0x720 kernel/time/timer.c:1322
 expire_timers kernel/time/timer.c:1366 [inline]
 __run_timers kernel/time/timer.c:1685 [inline]
 __run_timers kernel/time/timer.c:1653 [inline]
 run_timer_softirq+0x66f/0x1740 kernel/time/timer.c:1698
 __do_softirq+0x25c/0x94c kernel/softirq.c:293
 invoke_softirq kernel/softirq.c:374 [inline]
 irq_exit+0x180/0x1d0 kernel/softirq.c:414
 exiting_irq arch/x86/include/asm/apic.h:536 [inline]
 smp_apic_timer_interrupt+0x13b/0x550 arch/x86/kernel/apic/apic.c:1068
 apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:806
 </IRQ>
RIP: 0033:0x7f858d5c3232
Code: 8b 61 08 48 8b 84 24 d8 00 00 00 4c 89 44 24 28 48 8b ac 24 d0 00 00 00 4c 8b b4 24 e8 00 00 00 48 89 7c 24 68 48 89 4c 24 78 <48> 89 44 24 58 8b 84 24 e0 00 00 00 89 84 24 84 00 00 00 8b 84 24
RSP: 002b:00007ffcaf0cf5c0 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
RAX: 00007f858d7d27a8 RBX: 00007f858d7d8820 RCX: 00007f858d3940d8
RDX: 00007ffcaf0cf798 RSI: 00000000f5e616f3 RDI: 00007f858d394fee
RBP: 0000000000000000 R08: 00007ffcaf0cf780 R09: 00007f858d7db480
R10: 0000000000000000 R11: 0000000009691a75 R12: 0000000000000005
R13: 00000000f5e616f3 R14: 0000000000000000 R15: 00007ffcaf0cf798

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ax25/ax25_route.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/ax25/ax25_route.c
+++ b/net/ax25/ax25_route.c
@@ -429,9 +429,11 @@ int ax25_rt_autobind(ax25_cb *ax25, ax25
 	}
 
 	if (ax25->sk != NULL) {
+		local_bh_disable();
 		bh_lock_sock(ax25->sk);
 		sock_reset_flag(ax25->sk, SOCK_ZAPPED);
 		bh_unlock_sock(ax25->sk);
+		local_bh_enable();
 	}
 
 put:


