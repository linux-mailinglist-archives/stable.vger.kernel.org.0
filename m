Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CFAC156606
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 19:31:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727599AbgBHSbY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 13:31:24 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34838 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727979AbgBHS3u (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 13:29:50 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrN-0003hn-Aq; Sat, 08 Feb 2020 18:29:41 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrM-000CWn-PG; Sat, 08 Feb 2020 18:29:40 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Frederic Weisbecker" <fweisbec@gmail.com>,
        "Viresh Kumar" <viresh.kumar@linaro.org>,
        "Marcelo Tosatti" <mtosatti@redhat.com>,
        "Preeti U Murthy" <preeti@linux.vnet.ibm.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Peter Zijlstra" <peterz@infradead.org>
Date:   Sat, 08 Feb 2020 18:21:16 +0000
Message-ID: <lsq.1581185941.52885636@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 137/148] hrtimer: Get rid of the resolution field in
 hrtimer_clock_base
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

From: Thomas Gleixner <tglx@linutronix.de>

commit 398ca17fb54b212cdc9da7ff4a17a35c48dd2103 upstream.

The field has no value because all clock bases have the same
resolution. The resolution only changes when we switch to high
resolution timer mode. We can evaluate that from a single static
variable as well. In the !HIGHRES case its simply a constant.

Export the variable, so we can simplify the usage sites.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/r/20150414203500.645454122@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
[bwh: Backported to 3.16 as dependency of commit 552263456215
 "powerpc: Fix vDSO clock_getres()":
 - Adjust filename, context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/hrtimer.h  |  6 ++++--
 kernel/hrtimer.c         | 26 +++++++++-----------------
 kernel/time/timer_list.c |  8 ++++----
 3 files changed, 17 insertions(+), 23 deletions(-)

--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -137,7 +137,6 @@ struct hrtimer_sleeper {
  *			timer to a base on another cpu.
  * @clockid:		clock id for per_cpu support
  * @active:		red black tree root node for the active timers
- * @resolution:		the resolution of the clock, in nanoseconds
  * @get_time:		function to retrieve the current time of the clock
  * @softirq_time:	the time when running the hrtimer queue in the softirq
  * @offset:		offset of this clock to the monotonic base
@@ -147,7 +146,6 @@ struct hrtimer_clock_base {
 	int			index;
 	clockid_t		clockid;
 	struct timerqueue_head	active;
-	ktime_t			resolution;
 	ktime_t			(*get_time)(void);
 	ktime_t			softirq_time;
 	ktime_t			offset;
@@ -293,11 +291,15 @@ extern void hrtimer_peek_ahead_timers(vo
 
 extern void clock_was_set_delayed(void);
 
+extern unsigned int hrtimer_resolution;
+
 #else
 
 # define MONOTONIC_RES_NSEC	LOW_RES_NSEC
 # define KTIME_MONOTONIC_RES	KTIME_LOW_RES
 
+#define hrtimer_resolution	LOW_RES_NSEC
+
 static inline void hrtimer_peek_ahead_timers(void) { }
 
 /*
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -64,7 +64,6 @@
  */
 DEFINE_PER_CPU(struct hrtimer_cpu_base, hrtimer_bases) =
 {
-
 	.lock = __RAW_SPIN_LOCK_UNLOCKED(hrtimer_bases.lock),
 	.clock_base =
 	{
@@ -72,25 +71,21 @@ DEFINE_PER_CPU(struct hrtimer_cpu_base,
 			.index = HRTIMER_BASE_MONOTONIC,
 			.clockid = CLOCK_MONOTONIC,
 			.get_time = &ktime_get,
-			.resolution = KTIME_LOW_RES,
 		},
 		{
 			.index = HRTIMER_BASE_REALTIME,
 			.clockid = CLOCK_REALTIME,
 			.get_time = &ktime_get_real,
-			.resolution = KTIME_LOW_RES,
 		},
 		{
 			.index = HRTIMER_BASE_BOOTTIME,
 			.clockid = CLOCK_BOOTTIME,
 			.get_time = &ktime_get_boottime,
-			.resolution = KTIME_LOW_RES,
 		},
 		{
 			.index = HRTIMER_BASE_TAI,
 			.clockid = CLOCK_TAI,
 			.get_time = &ktime_get_clocktai,
-			.resolution = KTIME_LOW_RES,
 		},
 	}
 };
@@ -501,6 +496,8 @@ static inline void debug_deactivate(stru
  * High resolution timer enabled ?
  */
 static int hrtimer_hres_enabled __read_mostly  = 1;
+unsigned int hrtimer_resolution __read_mostly = LOW_RES_NSEC;
+EXPORT_SYMBOL_GPL(hrtimer_resolution);
 
 /*
  * Enable / Disable high resolution mode
@@ -707,7 +704,7 @@ static void retrigger_next_event(void *a
  */
 static int hrtimer_switch_to_hres(void)
 {
-	int i, cpu = smp_processor_id();
+	int cpu = smp_processor_id();
 	struct hrtimer_cpu_base *base = &per_cpu(hrtimer_bases, cpu);
 	unsigned long flags;
 
@@ -723,8 +720,7 @@ static int hrtimer_switch_to_hres(void)
 		return 0;
 	}
 	base->hres_active = 1;
-	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++)
-		base->clock_base[i].resolution = KTIME_HIGH_RES;
+	hrtimer_resolution = HIGH_RES_NSEC;
 
 	tick_setup_sched_timer();
 	/* "Retrigger" the interrupt to get things going */
@@ -859,8 +855,8 @@ u64 hrtimer_forward(struct hrtimer *time
 	if (delta.tv64 < 0)
 		return 0;
 
-	if (interval.tv64 < timer->base->resolution.tv64)
-		interval.tv64 = timer->base->resolution.tv64;
+	if (interval.tv64 < hrtimer_resolution)
+		interval.tv64 = hrtimer_resolution;
 
 	if (unlikely(delta.tv64 >= interval.tv64)) {
 		s64 incr = ktime_to_ns(interval);
@@ -1001,7 +997,7 @@ int __hrtimer_start_range_ns(struct hrti
 		 * timeouts. This will go away with the GTOD framework.
 		 */
 #ifdef CONFIG_TIME_LOW_RES
-		tim = ktime_add_safe(tim, base->resolution);
+		tim = ktime_add_safe(tim, ktime_set(0, hrtimer_resolution));
 #endif
 	}
 
@@ -1240,12 +1236,8 @@ EXPORT_SYMBOL_GPL(hrtimer_init);
  */
 int hrtimer_get_res(const clockid_t which_clock, struct timespec *tp)
 {
-	struct hrtimer_cpu_base *cpu_base;
-	int base = hrtimer_clockid_to_base(which_clock);
-
-	cpu_base = &__raw_get_cpu_var(hrtimer_bases);
-	*tp = ktime_to_timespec(cpu_base->clock_base[base].resolution);
-
+	tp->tv_sec = 0;
+	tp->tv_nsec = hrtimer_resolution;
 	return 0;
 }
 EXPORT_SYMBOL_GPL(hrtimer_get_res);
--- a/kernel/time/timer_list.c
+++ b/kernel/time/timer_list.c
@@ -120,10 +120,10 @@ static void
 print_base(struct seq_file *m, struct hrtimer_clock_base *base, u64 now)
 {
 	SEQ_printf(m, "  .base:       %pK\n", base);
-	SEQ_printf(m, "  .index:      %d\n",
-			base->index);
-	SEQ_printf(m, "  .resolution: %Lu nsecs\n",
-			(unsigned long long)ktime_to_ns(base->resolution));
+	SEQ_printf(m, "  .index:      %d\n", base->index);
+
+	SEQ_printf(m, "  .resolution: %u nsecs\n", (unsigned) hrtimer_resolution);
+
 	SEQ_printf(m,   "  .get_time:   ");
 	print_name_offset(m, base->get_time);
 	SEQ_printf(m,   "\n");

