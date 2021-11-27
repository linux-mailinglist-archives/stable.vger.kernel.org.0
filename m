Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5D7B46026F
	for <lists+stable@lfdr.de>; Sun, 28 Nov 2021 00:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356611AbhK1ACK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 27 Nov 2021 19:02:10 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:58094 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbhK1AAK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 27 Nov 2021 19:00:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E277260F55;
        Sat, 27 Nov 2021 23:56:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1235FC53FBF;
        Sat, 27 Nov 2021 23:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638057414;
        bh=tvYQzBGT+nZ5Ups9RPG+LTdRuduwyQqXodc5IYpKsAg=;
        h=Date:From:To:Subject:From;
        b=GSKQUc/CkWRBlEjSKBYKSsQwi0i9On3WjY9VOL0j0WkoejAIglG2YMS1omslDyXN/
         VueyTeeuZlfJB5iJk2GTDWei+11csN3xjNK9SdRLeeKZqLLeieNMl6Of4mZmlshZBw
         9B7JPix6cbMHNGyqWEUb4iibvq2eakyRwX+/izMk=
Date:   Sat, 27 Nov 2021 15:56:53 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, john.stultz@linaro.org,
        mm-commits@vger.kernel.org, oleksandr@natalenko.name,
        sj@kernel.org, stable@vger.kernel.org, tglx@linutronix.de
Subject:  + timers-implement-usleep_idle_range.patch added to -mm
 tree
Message-ID: <20211127235653.NOYYrId5C%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: timers: implement usleep_idle_range()
has been added to the -mm tree.  Its filename is
     timers-implement-usleep_idle_range.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/timers-implement-usleep_idle_range.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/timers-implement-usleep_idle_range.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
Cc: John Stultz <john.stultz@linaro.org>
Cc: Oleksandr Natalenko <oleksandr@natalenko.name>
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

Patches currently in -mm which might be from sj@kernel.org are

timers-implement-usleep_idle_range.patch
mm-damon-core-fix-fake-load-reports-due-to-uninterruptible-sleeps.patch
mm-damon-remove-some-no-need-func-definitions-in-damonh-file-fix.patch

