Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45191472EB5
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 15:20:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238829AbhLMOUC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 09:20:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232268AbhLMOUB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 09:20:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F762C061574;
        Mon, 13 Dec 2021 06:20:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B3A3F6109A;
        Mon, 13 Dec 2021 14:20:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFAB2C34601;
        Mon, 13 Dec 2021 14:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639405200;
        bh=RNQw6h/bAHeOfYIB0aUzxhYWwdxlLIxCqxi4yZQ0emg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hkN5BkND/qH5M/I89W7IRtpnGqLk+K4oWHgSR8i9jxcdVqTXLavDsdzI82iFmu/Xg
         zghXAlThZpV5pyFUyedwdxQArIUf4KLkrBYsvMTPyvlgrRfspLj9guwpL9/+97bSRo
         pvDaghTTyzUPomVS7vD++j/doc/kNotXr6pSVm9EsubvgMtm3ECLbEhQER5+KQPu5f
         u3stUxJvQtFkyi2Ptca7Aub7fDDcQRW5r/0pE6hESOD/PtkwcaJIIdKJc6UqtSOyV8
         OiLF3YFxvh38k0ZWgs87kVQTig/15fuyd2zi7e9L+SCzhgAOoPITleLoZUZhNJNLGF
         COghDu6g0VGtA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Frederic Weisbecker <frederic@kernel.org>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>, fweisbec@gmail.com,
        mingo@kernel.org, peterz@infradead.org, dave@stgolabs.net,
        will@kernel.org, dirk.behme@de.bosch.com, tannerlove@google.com
Subject: [PATCH MANUALSEL 5.15 2/9] timers/nohz: Last resort update jiffies on nohz_full IRQ entry
Date:   Mon, 13 Dec 2021 09:19:35 -0500
Message-Id: <20211213141944.352249-2-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211213141944.352249-1-sashal@kernel.org>
References: <20211213141944.352249-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frederic Weisbecker <frederic@kernel.org>

[ Upstream commit 53e87e3cdc155f20c3417b689df8d2ac88d79576 ]

When at least one CPU runs in nohz_full mode, a dedicated timekeeper CPU
is guaranteed to stay online and to never stop its tick.

Meanwhile on some rare case, the dedicated timekeeper may be running
with interrupts disabled for a while, such as in stop_machine.

If jiffies stop being updated, a nohz_full CPU may end up endlessly
programming the next tick in the past, taking the last jiffies update
monotonic timestamp as a stale base, resulting in an tick storm.

Here is a scenario where it matters:

0) CPU 0 is the timekeeper and CPU 1 a nohz_full CPU.

1) A stop machine callback is queued to execute somewhere.

2) CPU 0 reaches MULTI_STOP_DISABLE_IRQ while CPU 1 is still in
   MULTI_STOP_PREPARE. Hence CPU 0 can't do its timekeeping duty. CPU 1
   can still take IRQs.

3) CPU 1 receives an IRQ which queues a timer callback one jiffy forward.

4) On IRQ exit, CPU 1 schedules the tick one jiffy forward, taking
   last_jiffies_update as a base. But last_jiffies_update hasn't been
   updated for 2 jiffies since the timekeeper has interrupts disabled.

5) clockevents_program_event(), which relies on ktime_get(), observes
   that the expiration is in the past and therefore programs the min
   delta event on the clock.

6) The tick fires immediately, goto 3)

7) Tick storm, the nohz_full CPU is drown and takes ages to reach
   MULTI_STOP_DISABLE_IRQ, which is the only way out of this situation.

Solve this with unconditionally updating jiffies if the value is stale
on nohz_full IRQ entry. IRQs and other disturbances are expected to be
rare enough on nohz_full for the unconditional call to ktime_get() to
actually matter.

Reported-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Paul E. McKenney <paulmck@kernel.org>
Link: https://lore.kernel.org/r/20211026141055.57358-2-frederic@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/softirq.c         | 3 ++-
 kernel/time/tick-sched.c | 7 +++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index 322b65d456767..41f470929e991 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -595,7 +595,8 @@ void irq_enter_rcu(void)
 {
 	__irq_enter_raw();
 
-	if (is_idle_task(current) && (irq_count() == HARDIRQ_OFFSET))
+	if (tick_nohz_full_cpu(smp_processor_id()) ||
+	    (is_idle_task(current) && (irq_count() == HARDIRQ_OFFSET)))
 		tick_irq_enter();
 
 	account_hardirq_enter(current);
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 6bffe5af8cb11..17a283ce2b20f 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -1375,6 +1375,13 @@ static inline void tick_nohz_irq_enter(void)
 	now = ktime_get();
 	if (ts->idle_active)
 		tick_nohz_stop_idle(ts, now);
+	/*
+	 * If all CPUs are idle. We may need to update a stale jiffies value.
+	 * Note nohz_full is a special case: a timekeeper is guaranteed to stay
+	 * alive but it might be busy looping with interrupts disabled in some
+	 * rare case (typically stop machine). So we must make sure we have a
+	 * last resort.
+	 */
 	if (ts->tick_stopped)
 		tick_nohz_update_jiffies(now);
 }
-- 
2.33.0

