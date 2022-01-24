Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB8E249905B
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:03:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359477AbiAXT7o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:59:44 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:42220 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358632AbiAXTze (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:55:34 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 68117B8124F;
        Mon, 24 Jan 2022 19:55:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C741C340E5;
        Mon, 24 Jan 2022 19:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054131;
        bh=ojMR8X9nX7zDdS/xnbxlbb75aZ9SZ4nkfezZ4o8jmNk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C/87rKVmO5UvRSamdqPzDwHCtJlyewNxPYqwZ/bAYqvX5LbXJmu0BOFP9NKOGlT8B
         rXw/KAeCu8cbcLJ7q9BxKk1s9OHdTzauewTF1KZhRcT/Epr8rV4KnVLgb5VtedUnLj
         AReSa1XUAaL34OjQ+taZ7eObVFs0gP3GHrzZlZD4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Feng Tang <feng.tang@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 255/563] clocksource: Reduce clocksource-skew threshold
Date:   Mon, 24 Jan 2022 19:40:20 +0100
Message-Id: <20220124184033.241893805@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul E. McKenney <paulmck@kernel.org>

[ Upstream commit 2e27e793e280ff12cb5c202a1214c08b0d3a0f26 ]

Currently, WATCHDOG_THRESHOLD is set to detect a 62.5-millisecond skew in
a 500-millisecond WATCHDOG_INTERVAL.  This requires that clocks be skewed
by more than 12.5% in order to be marked unstable.  Except that a clock
that is skewed by that much is probably destroying unsuspecting software
right and left.  And given that there are now checks for false-positive
skews due to delays between reading the two clocks, it should be possible
to greatly decrease WATCHDOG_THRESHOLD, at least for fine-grained clocks
such as TSC.

Therefore, add a new uncertainty_margin field to the clocksource structure
that contains the maximum uncertainty in nanoseconds for the corresponding
clock.  This field may be initialized manually, as it is for
clocksource_tsc_early and clocksource_jiffies, which is copied to
refined_jiffies.  If the field is not initialized manually, it will be
computed at clock-registry time as the period of the clock in question
based on the scale and freq parameters to __clocksource_update_freq_scale()
function.  If either of those two parameters are zero, the
tens-of-milliseconds WATCHDOG_THRESHOLD is used as a cowardly alternative
to dividing by zero.  No matter how the uncertainty_margin field is
calculated, it is bounded below by twice WATCHDOG_MAX_SKEW, that is, by 100
microseconds.

Note that manually initialized uncertainty_margin fields are not adjusted,
but there is a WARN_ON_ONCE() that triggers if any such field is less than
twice WATCHDOG_MAX_SKEW.  This WARN_ON_ONCE() is intended to discourage
production use of the one-nanosecond uncertainty_margin values that are
used to test the clock-skew code itself.

The actual clock-skew check uses the sum of the uncertainty_margin fields
of the two clocksource structures being compared.  Integer overflow is
avoided because the largest computed value of the uncertainty_margin
fields is one billion (10^9), and double that value fits into an
unsigned int.  However, if someone manually specifies (say) UINT_MAX,
they will get what they deserve.

Note that the refined_jiffies uncertainty_margin field is initialized to
TICK_NSEC, which means that skew checks involving this clocksource will
be sufficently forgiving.  In a similar vein, the clocksource_tsc_early
uncertainty_margin field is initialized to 32*NSEC_PER_MSEC, which
replicates the current behavior and allows custom setting if needed
in order to address the rare skews detected for this clocksource in
current mainline.

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Feng Tang <feng.tang@intel.com>
Link: https://lore.kernel.org/r/20210527190124.440372-4-paulmck@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/tsc.c       |  1 +
 include/linux/clocksource.h |  3 +++
 kernel/time/clocksource.c   | 48 +++++++++++++++++++++++++++++--------
 kernel/time/jiffies.c       | 15 ++++++------
 4 files changed, 50 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index f9f1b45e5ddc4..13d1a0ac8916a 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -1127,6 +1127,7 @@ static int tsc_cs_enable(struct clocksource *cs)
 static struct clocksource clocksource_tsc_early = {
 	.name			= "tsc-early",
 	.rating			= 299,
+	.uncertainty_margin	= 32 * NSEC_PER_MSEC,
 	.read			= read_tsc,
 	.mask			= CLOCKSOURCE_MASK(64),
 	.flags			= CLOCK_SOURCE_IS_CONTINUOUS |
diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index 83a3ebff74560..8f87c1a6f3231 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -42,6 +42,8 @@ struct module;
  * @shift:		Cycle to nanosecond divisor (power of two)
  * @max_idle_ns:	Maximum idle time permitted by the clocksource (nsecs)
  * @maxadj:		Maximum adjustment value to mult (~11%)
+ * @uncertainty_margin:	Maximum uncertainty in nanoseconds per half second.
+ *			Zero says to use default WATCHDOG_THRESHOLD.
  * @archdata:		Optional arch-specific data
  * @max_cycles:		Maximum safe cycle value which won't overflow on
  *			multiplication
@@ -93,6 +95,7 @@ struct clocksource {
 	u32			shift;
 	u64			max_idle_ns;
 	u32			maxadj;
+	u32			uncertainty_margin;
 #ifdef CONFIG_ARCH_CLOCKSOURCE_DATA
 	struct arch_clocksource_data archdata;
 #endif
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 74492f08660c4..d0803a69a2009 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -93,6 +93,20 @@ static char override_name[CS_NAME_LEN];
 static int finished_booting;
 static u64 suspend_start;
 
+/*
+ * Threshold: 0.0312s, when doubled: 0.0625s.
+ * Also a default for cs->uncertainty_margin when registering clocks.
+ */
+#define WATCHDOG_THRESHOLD (NSEC_PER_SEC >> 5)
+
+/*
+ * Maximum permissible delay between two readouts of the watchdog
+ * clocksource surrounding a read of the clocksource being validated.
+ * This delay could be due to SMIs, NMIs, or to VCPU preemptions.  Used as
+ * a lower bound for cs->uncertainty_margin values when registering clocks.
+ */
+#define WATCHDOG_MAX_SKEW (50 * NSEC_PER_USEC)
+
 #ifdef CONFIG_CLOCKSOURCE_WATCHDOG
 static void clocksource_watchdog_work(struct work_struct *work);
 static void clocksource_select(void);
@@ -119,17 +133,9 @@ static int clocksource_watchdog_kthread(void *data);
 static void __clocksource_change_rating(struct clocksource *cs, int rating);
 
 /*
- * Interval: 0.5sec Threshold: 0.0625s
+ * Interval: 0.5sec.
  */
 #define WATCHDOG_INTERVAL (HZ >> 1)
-#define WATCHDOG_THRESHOLD (NSEC_PER_SEC >> 4)
-
-/*
- * Maximum permissible delay between two readouts of the watchdog
- * clocksource surrounding a read of the clocksource being validated.
- * This delay could be due to SMIs, NMIs, or to VCPU preemptions.
- */
-#define WATCHDOG_MAX_SKEW (100 * NSEC_PER_USEC)
 
 static void clocksource_watchdog_work(struct work_struct *work)
 {
@@ -284,6 +290,7 @@ static void clocksource_watchdog(struct timer_list *unused)
 	int next_cpu, reset_pending;
 	int64_t wd_nsec, cs_nsec;
 	struct clocksource *cs;
+	u32 md;
 
 	spin_lock(&watchdog_lock);
 	if (!watchdog_running)
@@ -330,7 +337,8 @@ static void clocksource_watchdog(struct timer_list *unused)
 			continue;
 
 		/* Check the deviation from the watchdog clocksource. */
-		if (abs(cs_nsec - wd_nsec) > WATCHDOG_THRESHOLD) {
+		md = cs->uncertainty_margin + watchdog->uncertainty_margin;
+		if (abs(cs_nsec - wd_nsec) > md) {
 			pr_warn("timekeeping watchdog on CPU%d: Marking clocksource '%s' as unstable because the skew is too large:\n",
 				smp_processor_id(), cs->name);
 			pr_warn("                      '%s' wd_now: %llx wd_last: %llx mask: %llx\n",
@@ -985,6 +993,26 @@ void __clocksource_update_freq_scale(struct clocksource *cs, u32 scale, u32 freq
 		clocks_calc_mult_shift(&cs->mult, &cs->shift, freq,
 				       NSEC_PER_SEC / scale, sec * scale);
 	}
+
+	/*
+	 * If the uncertainty margin is not specified, calculate it.
+	 * If both scale and freq are non-zero, calculate the clock
+	 * period, but bound below at 2*WATCHDOG_MAX_SKEW.  However,
+	 * if either of scale or freq is zero, be very conservative and
+	 * take the tens-of-milliseconds WATCHDOG_THRESHOLD value for the
+	 * uncertainty margin.  Allow stupidly small uncertainty margins
+	 * to be specified by the caller for testing purposes, but warn
+	 * to discourage production use of this capability.
+	 */
+	if (scale && freq && !cs->uncertainty_margin) {
+		cs->uncertainty_margin = NSEC_PER_SEC / (scale * freq);
+		if (cs->uncertainty_margin < 2 * WATCHDOG_MAX_SKEW)
+			cs->uncertainty_margin = 2 * WATCHDOG_MAX_SKEW;
+	} else if (!cs->uncertainty_margin) {
+		cs->uncertainty_margin = WATCHDOG_THRESHOLD;
+	}
+	WARN_ON_ONCE(cs->uncertainty_margin < 2 * WATCHDOG_MAX_SKEW);
+
 	/*
 	 * Ensure clocksources that have large 'mult' values don't overflow
 	 * when adjusted.
diff --git a/kernel/time/jiffies.c b/kernel/time/jiffies.c
index eddcf49704445..65409abcca8e1 100644
--- a/kernel/time/jiffies.c
+++ b/kernel/time/jiffies.c
@@ -49,13 +49,14 @@ static u64 jiffies_read(struct clocksource *cs)
  * for "tick-less" systems.
  */
 static struct clocksource clocksource_jiffies = {
-	.name		= "jiffies",
-	.rating		= 1, /* lowest valid rating*/
-	.read		= jiffies_read,
-	.mask		= CLOCKSOURCE_MASK(32),
-	.mult		= TICK_NSEC << JIFFIES_SHIFT, /* details above */
-	.shift		= JIFFIES_SHIFT,
-	.max_cycles	= 10,
+	.name			= "jiffies",
+	.rating			= 1, /* lowest valid rating*/
+	.uncertainty_margin	= 32 * NSEC_PER_MSEC,
+	.read			= jiffies_read,
+	.mask			= CLOCKSOURCE_MASK(32),
+	.mult			= TICK_NSEC << JIFFIES_SHIFT, /* details above */
+	.shift			= JIFFIES_SHIFT,
+	.max_cycles		= 10,
 };
 
 __cacheline_aligned_in_smp DEFINE_RAW_SPINLOCK(jiffies_lock);
-- 
2.34.1



