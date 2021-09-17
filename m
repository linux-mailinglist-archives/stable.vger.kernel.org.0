Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 610C340EF73
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 04:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243216AbhIQCgH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 22:36:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:33170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243031AbhIQCfw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 22:35:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7E6E61216;
        Fri, 17 Sep 2021 02:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631846070;
        bh=yT8oQICVcWPCUSyC5igRj3s6SxCIfYhyq/jip30yH8k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LD1OdjoKcvFRqZ8Nz920g/Fy4CFn+0Dl5JJzg6728JbWFeE3BrtfbvruQP9ClDdNa
         E3wFXkGBbYeTFqcVe42YJdI4Vy99njrXaY0WKmsrx8IJimsPZYdQHBKWPuxES4GZQS
         Heype+kkxF17eOZ6s9ZbIf7jwcn/WOVT/goRpQIe2iivnXejVb7vhWIEMFRmXvt7G5
         g2oxfRGcWGM0Ykq71rF+HBkhCGZq/pN3j6vnWKg5hka4ZFgInkPT/aDcUw77SMW8PU
         Wx3I3KBYf1A2mpq9ScqSi/8qo4NzyECnaSBJ9lywPeekRB1UiO1GD/WEjXdnM9oJHK
         jdS1ZtufrMz8g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>, mingo@redhat.com,
        peterz@infradead.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org
Subject: [PATCH AUTOSEL 5.14 19/21] sched/idle: Make the idle timer expire in hard interrupt context
Date:   Thu, 16 Sep 2021 22:33:13 -0400
Message-Id: <20210917023315.816225-19-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210917023315.816225-1-sashal@kernel.org>
References: <20210917023315.816225-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit 9848417926353daa59d2b05eb26e185063dbac6e ]

The intel powerclamp driver will setup a per-CPU worker with RT
priority. The worker will then invoke play_idle() in which it remains in
the idle poll loop until it is stopped by the timer it started earlier.

That timer needs to expire in hard interrupt context on PREEMPT_RT.
Otherwise the timer will expire in ksoftirqd as a SOFT timer but that task
won't be scheduled on the CPU because its priority is lower than the
priority of the worker which is in the idle loop.

Always expire the idle timer in hard interrupt context.

Reported-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20210906113034.jgfxrjdvxnjqgtmc@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/idle.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
index 912b47aa99d8..d17b0a5ce6ac 100644
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -379,10 +379,10 @@ void play_idle_precise(u64 duration_ns, u64 latency_ns)
 	cpuidle_use_deepest_state(latency_ns);
 
 	it.done = 0;
-	hrtimer_init_on_stack(&it.timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	hrtimer_init_on_stack(&it.timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL_HARD);
 	it.timer.function = idle_inject_timer_fn;
 	hrtimer_start(&it.timer, ns_to_ktime(duration_ns),
-		      HRTIMER_MODE_REL_PINNED);
+		      HRTIMER_MODE_REL_PINNED_HARD);
 
 	while (!READ_ONCE(it.done))
 		do_idle();
-- 
2.30.2

