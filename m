Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D354B40EF91
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 04:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243518AbhIQCgr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 22:36:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:33176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242938AbhIQCgK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 22:36:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8620611EE;
        Fri, 17 Sep 2021 02:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631846088;
        bh=8iLE6/GPQ5IHZoSOJA/aadPED7/q+tpmOJ6PNwzrvwE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AqR96hq0smiWZUKfYsP8iSyLcu5ntyGWnfV37uQ7EpjwgncgQRHSlNbcB2X4wo4p/
         K9IaTbF1DuJ9pY425bF9ZRUtzAXHWVgvdJTDpCtbXg/tRFDSmQp+JGsp33/cWvsx0u
         Kydqw//pBJzyEOBYF/+/B3/dCqOA7KlPyVRALQxaRi3y8OpBO+Ob6oF842NhKFWEUb
         lIVGMHgdYzePTA+huBgR6W62py6+kkIAN0IbFhIj7AZO9DVUwFdcS7/iAESkxMRZkZ
         RWSCmiaWAUWZOeIZFPli3TooAN1uP9i0ajjveS7gfxUu04njE37e3unNietgIm7tuE
         dgKBym+PkGZGw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>, mingo@redhat.com,
        peterz@infradead.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org
Subject: [PATCH AUTOSEL 5.10 8/8] sched/idle: Make the idle timer expire in hard interrupt context
Date:   Thu, 16 Sep 2021 22:34:33 -0400
Message-Id: <20210917023437.816574-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210917023437.816574-1-sashal@kernel.org>
References: <20210917023437.816574-1-sashal@kernel.org>
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
index 36b545f17206..2593a733c084 100644
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -372,10 +372,10 @@ void play_idle_precise(u64 duration_ns, u64 latency_ns)
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

