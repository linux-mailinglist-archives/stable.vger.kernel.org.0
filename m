Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A80D03D6295
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234600AbhGZPgX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:36:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:53728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232091AbhGZPgC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:36:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F7B760FD7;
        Mon, 26 Jul 2021 16:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627316191;
        bh=VGjDmFS/VCFvf6MWF09yXAnp+giMB7GjGJ677XJ/ZV4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dp3ciKcHlFb1Fg30ygY21Q9VchU9mLkUBODavn0Bcd8kEjAqrKo9YyuHamY02vVDh
         aNVge+dSvtNUgLUM3wYa/MzT3Sk0iuldrvJWF09QvAiolxE0hchpKNWXZnLAsrfnRg
         UGfs95Z8aL1lMa0UZvM7VFwfkIEk5hzFoEJ6SEIA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 5.13 190/223] posix-cpu-timers: Fix rearm racing against process tick
Date:   Mon, 26 Jul 2021 17:39:42 +0200
Message-Id: <20210726153852.414420578@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frederic Weisbecker <frederic@kernel.org>

commit 1a3402d93c73bf6bb4df6d7c2aac35abfc3c50e2 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/posix-cpu-timers.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/kernel/time/posix-cpu-timers.c
+++ b/kernel/time/posix-cpu-timers.c
@@ -991,6 +991,11 @@ static void posix_cpu_timer_rearm(struct
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
@@ -1001,11 +1006,6 @@ static void posix_cpu_timer_rearm(struct
 
 	bump_cpu_timer(timer, now);
 
-	/* Protect timer list r/w in arm_timer() */
-	sighand = lock_task_sighand(p, &flags);
-	if (unlikely(sighand == NULL))
-		goto out;
-
 	/*
 	 * Now re-arm for the new expiry time.
 	 */


