Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A36C8CA976
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404681AbfJCQmm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:42:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:53800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392687AbfJCQml (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:42:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5594A2054F;
        Thu,  3 Oct 2019 16:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120960;
        bh=TO36sxAHD4Bn+D3eeOaeB/DIge7EXOLy0Ew7V3AN8EU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TjOU/xFLFRx+D1mIvI1+hsBGdPEBsS8yzeJbgTTb8VYhzBlxqKSyKYXILFVdmrfPm
         dNUVz2TCOkdLLcOYiSt5Bl9PiMdcpUr2wwuO3S7P0MIuyVTqrvfB9qm8VH6B0mXp8E
         m9OZRehBIp6ePDktyxwkDjfrBJyPT/B1OTIcolvc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 101/344] idle: Prevent late-arriving interrupts from disrupting offline
Date:   Thu,  3 Oct 2019 17:51:06 +0200
Message-Id: <20191003154550.161023591@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit e78a7614f3876ac649b3df608789cb6ef74d0480 ]

Scheduling-clock interrupts can arrive late in the CPU-offline process,
after idle entry and the subsequent call to cpuhp_report_idle_dead().
Once execution passes the call to rcu_report_dead(), RCU is ignoring
the CPU, which results in lockdep complaints when the interrupt handler
uses RCU:

------------------------------------------------------------------------

=============================
WARNING: suspicious RCU usage
5.2.0-rc1+ #681 Not tainted
-----------------------------
kernel/sched/fair.c:9542 suspicious rcu_dereference_check() usage!

other info that might help us debug this:

RCU used illegally from offline CPU!
rcu_scheduler_active = 2, debug_locks = 1
no locks held by swapper/5/0.

stack backtrace:
CPU: 5 PID: 0 Comm: swapper/5 Not tainted 5.2.0-rc1+ #681
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS Bochs 01/01/2011
Call Trace:
 <IRQ>
 dump_stack+0x5e/0x8b
 trigger_load_balance+0xa8/0x390
 ? tick_sched_do_timer+0x60/0x60
 update_process_times+0x3b/0x50
 tick_sched_handle+0x2f/0x40
 tick_sched_timer+0x32/0x70
 __hrtimer_run_queues+0xd3/0x3b0
 hrtimer_interrupt+0x11d/0x270
 ? sched_clock_local+0xc/0x74
 smp_apic_timer_interrupt+0x79/0x200
 apic_timer_interrupt+0xf/0x20
 </IRQ>
RIP: 0010:delay_tsc+0x22/0x50
Code: ff 0f 1f 80 00 00 00 00 65 44 8b 05 18 a7 11 48 0f ae e8 0f 31 48 89 d6 48 c1 e6 20 48 09 c6 eb 0e f3 90 65 8b 05 fe a6 11 48 <41> 39 c0 75 18 0f ae e8 0f 31 48 c1 e2 20 48 09 c2 48 89 d0 48 29
RSP: 0000:ffff8f92c0157ed0 EFLAGS: 00000212 ORIG_RAX: ffffffffffffff13
RAX: 0000000000000005 RBX: ffff8c861f356400 RCX: ffff8f92c0157e64
RDX: 000000321214c8cc RSI: 00000032120daa7f RDI: 0000000000260f15
RBP: 0000000000000005 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000000
R13: 0000000000000000 R14: ffff8c861ee18000 R15: ffff8c861ee18000
 cpuhp_report_idle_dead+0x31/0x60
 do_idle+0x1d5/0x200
 ? _raw_spin_unlock_irqrestore+0x2d/0x40
 cpu_startup_entry+0x14/0x20
 start_secondary+0x151/0x170
 secondary_startup_64+0xa4/0xb0

------------------------------------------------------------------------

This happens rarely, but can be forced by happen more often by
placing delays in cpuhp_report_idle_dead() following the call to
rcu_report_dead().  With this in place, the following rcutorture
scenario reproduces the problem within a few minutes:

tools/testing/selftests/rcutorture/bin/kvm.sh --cpus 8 --duration 5 --kconfig "CONFIG_DEBUG_LOCK_ALLOC=y CONFIG_PROVE_LOCKING=y" --configs "TREE04"

This commit uses the crude but effective expedient of moving the disabling
of interrupts within the idle loop to precede the cpu_is_offline()
check.  It also invokes tick_nohz_idle_stop_tick() instead of
tick_nohz_idle_stop_tick_protected() to shut off the scheduling-clock
interrupt.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
[ paulmck: Revert tick_nohz_idle_stop_tick_protected() removal, new callers. ]
Signed-off-by: Paul E. McKenney <paulmck@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/idle.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
index 80940939b7336..e4bc4aa739b83 100644
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -241,13 +241,14 @@ static void do_idle(void)
 		check_pgt_cache();
 		rmb();
 
+		local_irq_disable();
+
 		if (cpu_is_offline(cpu)) {
-			tick_nohz_idle_stop_tick_protected();
+			tick_nohz_idle_stop_tick();
 			cpuhp_report_idle_dead();
 			arch_cpu_idle_dead();
 		}
 
-		local_irq_disable();
 		arch_cpu_idle_enter();
 
 		/*
-- 
2.20.1



