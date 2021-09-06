Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6F2401285
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 03:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238706AbhIFBV3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 21:21:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:37676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238709AbhIFBVM (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Sep 2021 21:21:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 55E2A61050;
        Mon,  6 Sep 2021 01:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891207;
        bh=wvWm3+IgOpv5wDhxP3A7rLifpTrYQmAj+aCKBsckjm4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UmEX492nQanpTY/1MAwyYHdgiAzMpb961ZnhyZJgl8b1pVo2Qb3K9MN/RW7eJV9SF
         Y5sN0V8oiL/2ddtWgXi4qEUEBsfsUz67X1IWX6zi/y+U7yEMAH7SX+NTcYpliOoklK
         xaV2T1tCPsih1BTRTRjCS18C0LKhEE3rVsGO6qEqCklHzVlrSz15cqw9JXgEXo3u4J
         C6NOHxfTj4vGC3eAwrIc8FHEgOuBH2hTcCzY3+G1tV4qj0tx9YzU+uvRpRx773bnmf
         psBq2IKvfc+QEBzDZ27yMlF49+j26eHV6d3Pb24dabdyiRU+ETspJsz8tYgdXgT/tr
         b0wT6Cjwzf9IA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.14 13/47] hrtimer: Ensure timerfd notification for HIGHRES=n
Date:   Sun,  5 Sep 2021 21:19:17 -0400
Message-Id: <20210906011951.928679-13-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210906011951.928679-1-sashal@kernel.org>
References: <20210906011951.928679-1-sashal@kernel.org>
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
index bb5e7b0a4274..77295af72426 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -318,16 +318,12 @@ struct clock_event_device;
 
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
@@ -351,7 +347,6 @@ hrtimer_expires_remaining_adjusted(const struct hrtimer *timer)
 						    timer->base->get_time());
 }
 
-extern void clock_was_set(void);
 #ifdef CONFIG_TIMERFD
 extern void timerfd_clock_was_set(void);
 #else
diff --git a/kernel/time/hrtimer.c b/kernel/time/hrtimer.c
index ba2e0d0a0e5a..5af758473488 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -758,22 +758,6 @@ static void hrtimer_switch_to_hres(void)
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
@@ -891,6 +875,22 @@ void clock_was_set(void)
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
index 6a742a29e545..cd610faa2523 100644
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

