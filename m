Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A88ED3B10B3
	for <lists+stable@lfdr.de>; Wed, 23 Jun 2021 01:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbhFVXoV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Jun 2021 19:44:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:52536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229747AbhFVXoV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Jun 2021 19:44:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 69FAE61003;
        Tue, 22 Jun 2021 23:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624405325;
        bh=g4E/vdYh2QVf8t933gHLgeNZUvOXHmnn6xmrpWfhGlg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=APtIlBGBprpAh3N1sTE4nJF6xqWCbAJPKeWDs+FZUdRYU8Cy9ATCMHKVfsN8eQVjB
         pK+739hYzMIKv1E01/8k76+UlbSDMQB/Nv3reKUih0ZOvVluVIduoyTbKER2SClBWy
         dTt03/z2a1AKeU222AUaz9zhA16va/Nhd2odZtK0g1GRXjhy/EPFqE9b2szSIH5uk5
         EK6JF4ezksMloHCeic8BZWvNpLJWqNy2wjphohvTdlzH+T5vRSjJ5vdWknzx5tErc+
         Yvdy63pRe4LY+qhpzLjz9RnYHtPlCNP9KsWywDKOlP3meX8mzatF7sb44AUtfIn/j4
         /fvAKfkW6MxmQ==
From:   Frederic Weisbecker <frederic@kernel.org>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Oleg Nesterov <oleg@redhat.com>, stable@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 1/7] posix-cpu-timers: Fix rearm racing against process tick
Date:   Wed, 23 Jun 2021 01:41:49 +0200
Message-Id: <20210622234155.119685-2-frederic@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210622234155.119685-1-frederic@kernel.org>
References: <20210622234155.119685-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since the process wide cputime counter is started locklessly from
posix_cpu_timer_rearm(), it can be concurrently stopped by operations
on other timers from the same thread group, such as in the following
unlucky scenario:

         CPU 0                                CPU 1
         -----                                -----
                                           timer_settime(TIMER B)
   posix_cpu_timer_rearm(TIMER A)
       cpu_clock_sample_group()
           (pct->timers_active already true)

                                           handle_posix_cpu_timers()
                                               check_process_timers()
                                                   stop_process_timers()
                                                       pct->timers_active = false
       arm_timer(TIMER A)

   tick -> run_posix_cpu_timers()
       // sees !pct->timers_active, ignore
       // our TIMER A

Fix this with simply locking process wide cputime counting start and
timer arm in the same block.

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Fixes: 60f2ceaa8111 ("posix-cpu-timers: Remove unnecessary locking around cpu_clock_sample_group")
Cc: stable@vger.kernel.org
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
---
 kernel/time/posix-cpu-timers.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/time/posix-cpu-timers.c b/kernel/time/posix-cpu-timers.c
index 3bb96a8b49c9..aa52fc85dbcb 100644
--- a/kernel/time/posix-cpu-timers.c
+++ b/kernel/time/posix-cpu-timers.c
@@ -991,6 +991,11 @@ static void posix_cpu_timer_rearm(struct k_itimer *timer)
 	if (!p)
 		goto out;
 
+	/* Protect timer list r/w in arm_timer() */
+	sighand = lock_task_sighand(p, &flags);
+	if (unlikely(sighand == NULL))
+		goto out;
+
 	/*
 	 * Fetch the current sample and update the timer's expiry time.
 	 */
@@ -1001,11 +1006,6 @@ static void posix_cpu_timer_rearm(struct k_itimer *timer)
 
 	bump_cpu_timer(timer, now);
 
-	/* Protect timer list r/w in arm_timer() */
-	sighand = lock_task_sighand(p, &flags);
-	if (unlikely(sighand == NULL))
-		goto out;
-
 	/*
 	 * Now re-arm for the new expiry time.
 	 */
-- 
2.25.1

