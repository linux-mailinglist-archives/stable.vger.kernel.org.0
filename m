Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB6D841747A
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346429AbhIXNG1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:06:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:34548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345905AbhIXNE1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 09:04:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5EDD561268;
        Fri, 24 Sep 2021 12:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632488130;
        bh=KoRok/c289mOUfiuFf5DqIQBpPD/AVRD0esmWN417rY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Oriu9PrT8f2EAgXjgNfa71/dUj6pPEL1i3mbx1cy0i09aUWPzUZNlduvfbp53DBrP
         WyNzkZ01DBVRzTds8wSer9fyWEa41/I2DB8EV48mfHoIj/wglJsmkG9xqFjkIdtq/t
         8NiO8+u5lRGcLAVaesuj3aphe8+ZxBqGUGw6cOrc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 096/100] sched/idle: Make the idle timer expire in hard interrupt context
Date:   Fri, 24 Sep 2021 14:44:45 +0200
Message-Id: <20210924124344.695410214@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124341.214446495@linuxfoundation.org>
References: <20210924124341.214446495@linuxfoundation.org>
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
2.33.0



