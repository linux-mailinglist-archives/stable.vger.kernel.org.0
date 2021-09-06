Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C389B4013F2
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 03:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240679AbhIFBcI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 21:32:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:48056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240599AbhIFB2B (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Sep 2021 21:28:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 87C4C61102;
        Mon,  6 Sep 2021 01:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891378;
        bh=5WCdiSfoYC4iCYUhDtOeTfNzUT9R7Tz2ghmwEOEsMQU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NgXmyl9fotMo7dz4h/OwKwZGQFLyEhcHZKW/PrqNiggxRO4AgMlw7wqw/dd/ylvan
         ipZnMJBZak5G0mpNgkPlyXWdExG6q6JsGa/zld9SIF8Qs3uRZlrZlgDJLqIfj9rcFu
         9vJl7K7Fi9dE6bFLBjkC/GX2OmK/qpQbe720r6KIDkwToYVeuDJrLdjFqQE7LC89xN
         7oyWYeJ6cIbEtR4VYugX0X63bL3uZYPfyvPTjxKV7VSordr7NmXZAenY5fIQQ/13Sa
         A6YQwJiY/r7FD2Urjz9gcoFUFwUJ7l1xtsjxVxYDqgKQ1fqqWBWdLafp5XUKJtc5Rd
         WYuRr4Qcy7JYg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 11/30] hrtimer: Ensure timerfd notification for HIGHRES=n
Date:   Sun,  5 Sep 2021 21:22:24 -0400
Message-Id: <20210906012244.930338-11-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210906012244.930338-1-sashal@kernel.org>
References: <20210906012244.930338-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 8c3b5e6ec0fee18bc2ce38d1dfe913413205f908 ]

If high resolution timers are disabled the timerfd notification about a
clock was set event is not happening for all cases which use
clock_was_set_delayed() because that's a NOP for HIGHRES=n, which is wrong.

Make clock_was_set_delayed() unconditially available to fix that.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20210713135158.196661266@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/hrtimer.h     |  5 -----
 kernel/time/hrtimer.c       | 32 ++++++++++++++++----------------
 kernel/time/tick-internal.h |  3 +++
 3 files changed, 19 insertions(+), 21 deletions(-)

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index 1f98b52118f0..48be92aded5e 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -317,16 +317,12 @@ struct clock_event_device;
 
 extern void hrtimer_interrupt(struct clock_event_device *dev);
 
-extern void clock_was_set_delayed(void);
-
 extern unsigned int hrtimer_resolution;
 
 #else
 
 #define hrtimer_resolution	(unsigned int)LOW_RES_NSEC
 
-static inline void clock_was_set_delayed(void) { }
-
 #endif
 
 static inline ktime_t
@@ -350,7 +346,6 @@ hrtimer_expires_remaining_adjusted(const struct hrtimer *timer)
 						    timer->base->get_time());
 }
 
-extern void clock_was_set(void);
 #ifdef CONFIG_TIMERFD
 extern void timerfd_clock_was_set(void);
 #else
diff --git a/kernel/time/hrtimer.c b/kernel/time/hrtimer.c
index 39beb9aaa24b..e1e8d5dab0c5 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -759,22 +759,6 @@ static void hrtimer_switch_to_hres(void)
 	retrigger_next_event(NULL);
 }
 
-static void clock_was_set_work(struct work_struct *work)
-{
-	clock_was_set();
-}
-
-static DECLARE_WORK(hrtimer_work, clock_was_set_work);
-
-/*
- * Called from timekeeping and resume code to reprogram the hrtimer
- * interrupt device on all cpus.
- */
-void clock_was_set_delayed(void)
-{
-	schedule_work(&hrtimer_work);
-}
-
 #else
 
 static inline int hrtimer_is_hres_enabled(void) { return 0; }
@@ -892,6 +876,22 @@ void clock_was_set(void)
 	timerfd_clock_was_set();
 }
 
+static void clock_was_set_work(struct work_struct *work)
+{
+	clock_was_set();
+}
+
+static DECLARE_WORK(hrtimer_work, clock_was_set_work);
+
+/*
+ * Called from timekeeping and resume code to reprogram the hrtimer
+ * interrupt device on all cpus and to notify timerfd.
+ */
+void clock_was_set_delayed(void)
+{
+	schedule_work(&hrtimer_work);
+}
+
 /*
  * During resume we might have to reprogram the high resolution timer
  * interrupt on all online CPUs.  However, all other CPUs will be
diff --git a/kernel/time/tick-internal.h b/kernel/time/tick-internal.h
index 7b2496136729..5294f5b1f955 100644
--- a/kernel/time/tick-internal.h
+++ b/kernel/time/tick-internal.h
@@ -165,3 +165,6 @@ DECLARE_PER_CPU(struct hrtimer_cpu_base, hrtimer_bases);
 
 extern u64 get_next_timer_interrupt(unsigned long basej, u64 basem);
 void timer_clear_idle(void);
+
+void clock_was_set(void);
+void clock_was_set_delayed(void);
-- 
2.30.2

