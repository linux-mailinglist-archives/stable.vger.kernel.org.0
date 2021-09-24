Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7CD417506
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346140AbhIXNOJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:14:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:38146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346428AbhIXNLC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 09:11:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 01B64613AC;
        Fri, 24 Sep 2021 12:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632488306;
        bh=GQf2J0qqmeF/2WB/2+mspJAQ//rcwTHy1ozVhKJBdC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PPsxoGotVkn5C87l3345jyZ9wqoZrOyKk2r+U+LVT8sK/d+dYIrcpBqkzve+attRM
         v24x8R2FrmbbxCJr7U3DWJ923aFGTXaYp+k/Tl0fGCP+L3x0l1n5h5hBxEpKQmG+yq
         rE/jiZpMf4/XaMDY8pAP67fCCksH5FJ/EW8+pvtg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 62/63] sched/idle: Make the idle timer expire in hard interrupt context
Date:   Fri, 24 Sep 2021 14:45:02 +0200
Message-Id: <20210924124336.389554292@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124334.228235870@linuxfoundation.org>
References: <20210924124334.228235870@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
2.33.0



