Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50D6F470E28
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 23:46:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344745AbhLJWuB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 17:50:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344718AbhLJWuB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 17:50:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FC70C061746;
        Fri, 10 Dec 2021 14:46:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EF7ECB827BD;
        Fri, 10 Dec 2021 22:46:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77424C341CC;
        Fri, 10 Dec 2021 22:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639176382;
        bh=q6RfDfuJeEvi3q8xEd4Z830faXUH5/x9+E+1EHvZKnw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=hZ/ho0/mgu9TXq5bYNROEZ1C7CzlgHK2ZjVorUjxZrVhPg4kPGbHm9CS5WCb8OKSV
         19VdtnGrI1+JwZJuHTnXM0Ee6nR/ArlXmUFb3qe/73iwCEdbY7sUBiMNDLe/Vrfhv2
         msLIFg4uJrNGREhT6TOEw0vV5BGtzW5rUYBHBQE4=
Date:   Fri, 10 Dec 2021 14:46:22 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, john.stultz@linaro.org,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        oleksandr@natalenko.name, sj@kernel.org, stable@vger.kernel.org,
        tglx@linutronix.de, torvalds@linux-foundation.org
Subject:  [patch 05/21] timers: implement usleep_idle_range()
Message-ID: <20211210224622.Dk89hIymE%akpm@linux-foundation.org>
In-Reply-To: <20211210144539.663efee2c80d8450e6180230@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: SeongJae Park <sj@kernel.org>
Subject: timers: implement usleep_idle_range()

Patch series "mm/damon: Fix fake /proc/loadavg reports", v3.

This patchset fixes DAMON's fake load report issue.  The first patch makes
yet another variant of usleep_range() for this fix, and the second patch
fixes the issue of DAMON by making it using the newly introduced function.


This patch (of 2):

Some kernel threads such as DAMON could need to repeatedly sleep in micro
seconds level.  Because usleep_range() sleeps in uninterruptible state,
however, such threads would make /proc/loadavg reports fake load.

To help such cases, this commit implements a variant of usleep_range()
called usleep_idle_range().  It is same to usleep_range() but sets the
state of the current task as TASK_IDLE while sleeping.

Link: https://lkml.kernel.org/r/20211126145015.15862-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20211126145015.15862-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Cc: John Stultz <john.stultz@linaro.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/delay.h |   14 +++++++++++++-
 kernel/time/timer.c   |   16 +++++++++-------
 2 files changed, 22 insertions(+), 8 deletions(-)

--- a/include/linux/delay.h~timers-implement-usleep_idle_range
+++ a/include/linux/delay.h
@@ -20,6 +20,7 @@
  */
 
 #include <linux/math.h>
+#include <linux/sched.h>
 
 extern unsigned long loops_per_jiffy;
 
@@ -58,7 +59,18 @@ void calibrate_delay(void);
 void __attribute__((weak)) calibration_delay_done(void);
 void msleep(unsigned int msecs);
 unsigned long msleep_interruptible(unsigned int msecs);
-void usleep_range(unsigned long min, unsigned long max);
+void usleep_range_state(unsigned long min, unsigned long max,
+			unsigned int state);
+
+static inline void usleep_range(unsigned long min, unsigned long max)
+{
+	usleep_range_state(min, max, TASK_UNINTERRUPTIBLE);
+}
+
+static inline void usleep_idle_range(unsigned long min, unsigned long max)
+{
+	usleep_range_state(min, max, TASK_IDLE);
+}
 
 static inline void ssleep(unsigned int seconds)
 {
--- a/kernel/time/timer.c~timers-implement-usleep_idle_range
+++ a/kernel/time/timer.c
@@ -2054,26 +2054,28 @@ unsigned long msleep_interruptible(unsig
 EXPORT_SYMBOL(msleep_interruptible);
 
 /**
- * usleep_range - Sleep for an approximate time
- * @min: Minimum time in usecs to sleep
- * @max: Maximum time in usecs to sleep
+ * usleep_range_state - Sleep for an approximate time in a given state
+ * @min:	Minimum time in usecs to sleep
+ * @max:	Maximum time in usecs to sleep
+ * @state:	State of the current task that will be while sleeping
  *
  * In non-atomic context where the exact wakeup time is flexible, use
- * usleep_range() instead of udelay().  The sleep improves responsiveness
+ * usleep_range_state() instead of udelay().  The sleep improves responsiveness
  * by avoiding the CPU-hogging busy-wait of udelay(), and the range reduces
  * power usage by allowing hrtimers to take advantage of an already-
  * scheduled interrupt instead of scheduling a new one just for this sleep.
  */
-void __sched usleep_range(unsigned long min, unsigned long max)
+void __sched usleep_range_state(unsigned long min, unsigned long max,
+				unsigned int state)
 {
 	ktime_t exp = ktime_add_us(ktime_get(), min);
 	u64 delta = (u64)(max - min) * NSEC_PER_USEC;
 
 	for (;;) {
-		__set_current_state(TASK_UNINTERRUPTIBLE);
+		__set_current_state(state);
 		/* Do not return before the requested sleep time has elapsed */
 		if (!schedule_hrtimeout_range(&exp, delta, HRTIMER_MODE_ABS))
 			break;
 	}
 }
-EXPORT_SYMBOL(usleep_range);
+EXPORT_SYMBOL(usleep_range_state);
_
