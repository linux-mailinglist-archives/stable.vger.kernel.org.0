Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8423F3741E6
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 18:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235492AbhEEQmA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 12:42:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:37174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235476AbhEEQjp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:39:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A5316141C;
        Wed,  5 May 2021 16:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232446;
        bh=85V6lX/ClG4UUgy1i0bQMijcBFzjfY54USznbcC8LGw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mq3MDKSnC/7jeK4+iviFo3CAaCOy4dCuo34pU8+2aCY+tVRnldlHR3GaLUXZkfd9/
         W73GYmuI5rWx3IOL6Y7Ftk/9TS8hN9fLKiy5xS+kK7GK6T1E/O6TdvxzDWNl8gDmt8
         i2I+Ah/4lKk4xWorDGAYVNkwJzkCetEKwKWa+TTpTeP9WyvsuxrAP0GV8wb+UgBS2Z
         qlaUXDCFLR7MesFqSVpoR/Z+/rIQq2dV1ETVoPGNxP2pft+SXaEp66xFmOl/YxA/v9
         RXGUYQ5KRhoXm0KS4H7+/sHrC963nasaa0aI6TEr8wN/sXSGCl/e0oMnh/D43qMwIA
         aE50/m184dZBg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Petr Mladek <pmladek@suse.com>, Ingo Molnar <mingo@kernel.org>,
        Laurence Oberman <loberman@redhat.com>,
        Michal Hocko <mhocko@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.12 113/116] watchdog/softlockup: report the overall time of softlockups
Date:   Wed,  5 May 2021 12:31:21 -0400
Message-Id: <20210505163125.3460440-113-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163125.3460440-1-sashal@kernel.org>
References: <20210505163125.3460440-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petr Mladek <pmladek@suse.com>

[ Upstream commit fef06efc2ebaa94c8aee299b863e870467dbab8d ]

The softlockup detector currently shows the time spent since the last
report.  As a result it is not clear whether a CPU is infinitely hogged by
a single task or if it is a repeated event.

The situation can be simulated with a simply busy loop:

	while (true)
	      cpu_relax();

The softlockup detector produces:

[  168.277520] watchdog: BUG: soft lockup - CPU#1 stuck for 22s! [cat:4865]
[  196.277604] watchdog: BUG: soft lockup - CPU#1 stuck for 22s! [cat:4865]
[  236.277522] watchdog: BUG: soft lockup - CPU#1 stuck for 23s! [cat:4865]

But it should be, something like:

[  480.372418] watchdog: BUG: soft lockup - CPU#2 stuck for 26s! [cat:4943]
[  508.372359] watchdog: BUG: soft lockup - CPU#2 stuck for 52s! [cat:4943]
[  548.372359] watchdog: BUG: soft lockup - CPU#2 stuck for 89s! [cat:4943]
[  576.372351] watchdog: BUG: soft lockup - CPU#2 stuck for 115s! [cat:4943]

For the better output, add an additional timestamp of the last report.
Only this timestamp is reset when the watchdog is intentionally touched
from slow code paths or when printing the report.

Link: https://lkml.kernel.org/r/20210311122130.6788-4-pmladek@suse.com
Signed-off-by: Petr Mladek <pmladek@suse.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Laurence Oberman <loberman@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vincent Whitchurch <vincent.whitchurch@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/watchdog.c | 40 ++++++++++++++++++++++++++++------------
 1 file changed, 28 insertions(+), 12 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 8efd2a8d9f10..6bc5113d3d74 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -154,7 +154,11 @@ static void lockup_detector_update_enable(void)
 
 #ifdef CONFIG_SOFTLOCKUP_DETECTOR
 
-#define SOFTLOCKUP_RESET	ULONG_MAX
+/*
+ * Delay the soflockup report when running a known slow code.
+ * It does _not_ affect the timestamp of the last successdul reschedule.
+ */
+#define SOFTLOCKUP_DELAY_REPORT	ULONG_MAX
 
 #ifdef CONFIG_SMP
 int __read_mostly sysctl_softlockup_all_cpu_backtrace;
@@ -169,7 +173,10 @@ unsigned int __read_mostly softlockup_panic =
 static bool softlockup_initialized __read_mostly;
 static u64 __read_mostly sample_period;
 
+/* Timestamp taken after the last successful reschedule. */
 static DEFINE_PER_CPU(unsigned long, watchdog_touch_ts);
+/* Timestamp of the last softlockup report. */
+static DEFINE_PER_CPU(unsigned long, watchdog_report_ts);
 static DEFINE_PER_CPU(struct hrtimer, watchdog_hrtimer);
 static DEFINE_PER_CPU(bool, softlockup_touch_sync);
 static DEFINE_PER_CPU(bool, soft_watchdog_warn);
@@ -235,10 +242,16 @@ static void set_sample_period(void)
 	watchdog_update_hrtimer_threshold(sample_period);
 }
 
+static void update_report_ts(void)
+{
+	__this_cpu_write(watchdog_report_ts, get_timestamp());
+}
+
 /* Commands for resetting the watchdog */
 static void update_touch_ts(void)
 {
 	__this_cpu_write(watchdog_touch_ts, get_timestamp());
+	update_report_ts();
 }
 
 /**
@@ -252,10 +265,10 @@ static void update_touch_ts(void)
 notrace void touch_softlockup_watchdog_sched(void)
 {
 	/*
-	 * Preemption can be enabled.  It doesn't matter which CPU's timestamp
-	 * gets zeroed here, so use the raw_ operation.
+	 * Preemption can be enabled.  It doesn't matter which CPU's watchdog
+	 * report period gets restarted here, so use the raw_ operation.
 	 */
-	raw_cpu_write(watchdog_touch_ts, SOFTLOCKUP_RESET);
+	raw_cpu_write(watchdog_report_ts, SOFTLOCKUP_DELAY_REPORT);
 }
 
 notrace void touch_softlockup_watchdog(void)
@@ -279,7 +292,7 @@ void touch_all_softlockup_watchdogs(void)
 	 * the softlockup check.
 	 */
 	for_each_cpu(cpu, &watchdog_allowed_mask) {
-		per_cpu(watchdog_touch_ts, cpu) = SOFTLOCKUP_RESET;
+		per_cpu(watchdog_report_ts, cpu) = SOFTLOCKUP_DELAY_REPORT;
 		wq_watchdog_touch(cpu);
 	}
 }
@@ -287,16 +300,16 @@ void touch_all_softlockup_watchdogs(void)
 void touch_softlockup_watchdog_sync(void)
 {
 	__this_cpu_write(softlockup_touch_sync, true);
-	__this_cpu_write(watchdog_touch_ts, SOFTLOCKUP_RESET);
+	__this_cpu_write(watchdog_report_ts, SOFTLOCKUP_DELAY_REPORT);
 }
 
-static int is_softlockup(unsigned long touch_ts)
+static int is_softlockup(unsigned long touch_ts, unsigned long period_ts)
 {
 	unsigned long now = get_timestamp();
 
 	if ((watchdog_enabled & SOFT_WATCHDOG_ENABLED) && watchdog_thresh){
 		/* Warn about unreasonable delays. */
-		if (time_after(now, touch_ts + get_softlockup_thresh()))
+		if (time_after(now, period_ts + get_softlockup_thresh()))
 			return now - touch_ts;
 	}
 	return 0;
@@ -342,6 +355,7 @@ static int softlockup_fn(void *data)
 static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
 {
 	unsigned long touch_ts = __this_cpu_read(watchdog_touch_ts);
+	unsigned long period_ts = __this_cpu_read(watchdog_report_ts);
 	struct pt_regs *regs = get_irq_regs();
 	int duration;
 	int softlockup_all_cpu_backtrace = sysctl_softlockup_all_cpu_backtrace;
@@ -363,7 +377,8 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
 	/* .. and repeat */
 	hrtimer_forward_now(hrtimer, ns_to_ktime(sample_period));
 
-	if (touch_ts == SOFTLOCKUP_RESET) {
+	/* Reset the interval when touched externally by a known slow code. */
+	if (period_ts == SOFTLOCKUP_DELAY_REPORT) {
 		if (unlikely(__this_cpu_read(softlockup_touch_sync))) {
 			/*
 			 * If the time stamp was touched atomically
@@ -375,7 +390,8 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
 
 		/* Clear the guest paused flag on watchdog reset */
 		kvm_check_and_clear_guest_paused();
-		update_touch_ts();
+		update_report_ts();
+
 		return HRTIMER_RESTART;
 	}
 
@@ -385,7 +401,7 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
 	 * indicate it is getting cpu time.  If it hasn't then
 	 * this is a good indication some task is hogging the cpu
 	 */
-	duration = is_softlockup(touch_ts);
+	duration = is_softlockup(touch_ts, period_ts);
 	if (unlikely(duration)) {
 		/*
 		 * If a virtual machine is stopped by the host it can look to
@@ -411,7 +427,7 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
 		}
 
 		/* Start period for the next softlockup warning. */
-		update_touch_ts();
+		update_report_ts();
 
 		pr_emerg("BUG: soft lockup - CPU#%d stuck for %us! [%s:%d]\n",
 			smp_processor_id(), duration,
-- 
2.30.2

