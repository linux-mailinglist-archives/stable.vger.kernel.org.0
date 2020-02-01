Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE13B14F79E
	for <lists+stable@lfdr.de>; Sat,  1 Feb 2020 12:21:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726450AbgBALVX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Feb 2020 06:21:23 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:57170 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbgBALVX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 1 Feb 2020 06:21:23 -0500
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1ixqpz-0005Kk-Po; Sat, 01 Feb 2020 12:21:19 +0100
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id 13DC11C1DFA;
        Sat,  1 Feb 2020 12:21:19 +0100 (CET)
Date:   Sat, 01 Feb 2020 11:21:18 -0000
From:   "tip-bot2 for Konstantin Khlebnikov" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: timers/urgent] clocksource: Prevent double add_timer_on() for
 watchdog_timer
Cc:     Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <158048693917.4378.13823603769948933793.stgit@buzz>
References: <158048693917.4378.13823603769948933793.stgit@buzz>
MIME-Version: 1.0
Message-ID: <158055607880.396.15231854905152208691.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the timers/urgent branch of tip:

Commit-ID:     febac332a819f0e764aa4da62757ba21d18c182b
Gitweb:        https://git.kernel.org/tip/febac332a819f0e764aa4da62757ba21d18c182b
Author:        Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
AuthorDate:    Fri, 31 Jan 2020 19:08:59 +03:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Sat, 01 Feb 2020 11:07:56 +01:00

clocksource: Prevent double add_timer_on() for watchdog_timer

Kernel crashes inside QEMU/KVM are observed:

  kernel BUG at kernel/time/timer.c:1154!
  BUG_ON(timer_pending(timer) || !timer->function) in add_timer_on().

At the same time another cpu got:

  general protection fault: 0000 [#1] SMP PTI of poinson pointer 0xdead000000000200 in:

  __hlist_del at include/linux/list.h:681
  (inlined by) detach_timer at kernel/time/timer.c:818
  (inlined by) expire_timers at kernel/time/timer.c:1355
  (inlined by) __run_timers at kernel/time/timer.c:1686
  (inlined by) run_timer_softirq at kernel/time/timer.c:1699

Unfortunately kernel logs are badly scrambled, stacktraces are lost.

Printing the timer->function before the BUG_ON() pointed to
clocksource_watchdog().

The execution of clocksource_watchdog() can race with a sequence of
clocksource_stop_watchdog() .. clocksource_start_watchdog():

expire_timers()
 detach_timer(timer, true);
  timer->entry.pprev = NULL;
 raw_spin_unlock_irq(&base->lock);
 call_timer_fn
  clocksource_watchdog()

					clocksource_watchdog_kthread() or
					clocksource_unbind()

					spin_lock_irqsave(&watchdog_lock, flags);
					clocksource_stop_watchdog();
					 del_timer(&watchdog_timer);
					 watchdog_running = 0;
					spin_unlock_irqrestore(&watchdog_lock, flags);

					spin_lock_irqsave(&watchdog_lock, flags);
					clocksource_start_watchdog();
					 add_timer_on(&watchdog_timer, ...);
					 watchdog_running = 1;
					spin_unlock_irqrestore(&watchdog_lock, flags);

  spin_lock(&watchdog_lock);
  add_timer_on(&watchdog_timer, ...);
   BUG_ON(timer_pending(timer) || !timer->function);
    timer_pending() -> true
    BUG()

I.e. inside clocksource_watchdog() watchdog_timer could be already armed.

Check timer_pending() before calling add_timer_on(). This is sufficient as
all operations are synchronized by watchdog_lock.

Fixes: 75c5158f70c0 ("timekeeping: Update clocksource with stop_machine")
Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/158048693917.4378.13823603769948933793.stgit@buzz
---
 kernel/time/clocksource.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index fff5f64..428beb6 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -293,8 +293,15 @@ static void clocksource_watchdog(struct timer_list *unused)
 	next_cpu = cpumask_next(raw_smp_processor_id(), cpu_online_mask);
 	if (next_cpu >= nr_cpu_ids)
 		next_cpu = cpumask_first(cpu_online_mask);
-	watchdog_timer.expires += WATCHDOG_INTERVAL;
-	add_timer_on(&watchdog_timer, next_cpu);
+
+	/*
+	 * Arm timer if not already pending: could race with concurrent
+	 * pair clocksource_stop_watchdog() clocksource_start_watchdog().
+	 */
+	if (!timer_pending(&watchdog_timer)) {
+		watchdog_timer.expires += WATCHDOG_INTERVAL;
+		add_timer_on(&watchdog_timer, next_cpu);
+	}
 out:
 	spin_unlock(&watchdog_lock);
 }
