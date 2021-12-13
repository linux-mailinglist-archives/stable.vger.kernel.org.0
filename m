Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A037472889
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:14:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234737AbhLMKOA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:14:00 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40690 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237641AbhLMJ4p (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:56:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40165B80E2E;
        Mon, 13 Dec 2021 09:56:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A35BC34600;
        Mon, 13 Dec 2021 09:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389402;
        bh=j6VD68CqU75rwnl7IbhYuao4VP1njQ7X90VZY0++yqQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Xdcm0BPj0rh/10+ZZEQKKmYwy6OB0oaF3xIhXBzSfVOttYqMM9behVOa2qmWDCE5
         lB3za/WTb6OwR0zvMHy+zH1/+M6ESmmd6kYuAY3rWIqN/ZUat2ED7IQcsu/ISB/NbP
         3NTFt3Ihh082njEYj5qfqFHF0xIwRGSu4sR5MiuU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, SeongJae Park <sj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        John Stultz <john.stultz@linaro.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.15 060/171] timers: implement usleep_idle_range()
Date:   Mon, 13 Dec 2021 10:29:35 +0100
Message-Id: <20211213092947.097963225@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: SeongJae Park <sj@kernel.org>

commit e4779015fd5d2fb8390c258268addff24d6077c7 upstream.

Patch series "mm/damon: Fix fake /proc/loadavg reports", v3.

This patchset fixes DAMON's fake load report issue.  The first patch
makes yet another variant of usleep_range() for this fix, and the second
patch fixes the issue of DAMON by making it using the newly introduced
function.

This patch (of 2):

Some kernel threads such as DAMON could need to repeatedly sleep in
micro seconds level.  Because usleep_range() sleeps in uninterruptible
state, however, such threads would make /proc/loadavg reports fake load.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/delay.h |   14 +++++++++++++-
 kernel/time/timer.c   |   16 +++++++++-------
 2 files changed, 22 insertions(+), 8 deletions(-)

--- a/include/linux/delay.h
+++ b/include/linux/delay.h
@@ -20,6 +20,7 @@
  */
 
 #include <linux/kernel.h>
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
--- a/kernel/time/timer.c
+++ b/kernel/time/timer.c
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


