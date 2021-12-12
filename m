Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5921647194D
	for <lists+stable@lfdr.de>; Sun, 12 Dec 2021 09:28:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbhLLI2p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Dec 2021 03:28:45 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57348 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbhLLI2n (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Dec 2021 03:28:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D52B1B80B67;
        Sun, 12 Dec 2021 08:28:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE49EC341CB;
        Sun, 12 Dec 2021 08:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639297720;
        bh=VRqGvqvUIyfK7wMSlQVPJTyXq7gEI7S+/DplM/pVHTU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t3ifgksV6UkcAsmER6vXxC04jW+2nHoPZBtC0GJ/ESTGfAGNv8ieACbooVqvZc8qS
         t5tc+PXDOyhA+Cx2+QjiJTTVIoAYo6lDd5cwMfB70Df391yRYChaaUtZhZLFFixIBd
         TS202PrWoq4RIKAmiKv1I9ronL/XrtsUJxSE2cRSanz1i4R7FOVUkCbROV5y8QRxde
         1ZcSjnQ1fGVE3y737Xd2WM7EDChCNEDCqFbSQloWbONjNGmOFJNLhthD7TP5xZgMZj
         BV6I2LwgiufYt3JvVGuQZB6qRlnHr3jIQuZ/zJ2W6kPmoQbxecIPIrF0jwnmuE5nTx
         1iXl3eI+rHnlQ==
From:   SeongJae Park <sj@kernel.org>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org
Cc:     akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, SeongJae Park <sj@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH for-v5.15.x 1/2] timers: implement usleep_idle_range()
Date:   Sun, 12 Dec 2021 08:28:29 +0000
Message-Id: <20211212082831.26988-2-sj@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211212082831.26988-1-sj@kernel.org>
References: <20211212082831.26988-1-sj@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 include/linux/delay.h | 14 +++++++++++++-
 kernel/time/timer.c   | 16 +++++++++-------
 2 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/include/linux/delay.h b/include/linux/delay.h
index 1d0e2ce6b6d9..e8607992c68a 100644
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
diff --git a/kernel/time/timer.c b/kernel/time/timer.c
index e3d2c23c413d..85f1021ad459 100644
--- a/kernel/time/timer.c
+++ b/kernel/time/timer.c
@@ -2054,26 +2054,28 @@ unsigned long msleep_interruptible(unsigned int msecs)
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
-- 
2.17.1

