Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1741C3CF877
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 12:57:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238062AbhGTKQu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 06:16:50 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:40024 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238099AbhGTKOu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Jul 2021 06:14:50 -0400
Date:   Tue, 20 Jul 2021 10:55:22 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1626778523;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=8lPvVTbfOrGyEFM7yYBrV80a7op6U6jWP3hzLmgYm+s=;
        b=zQUB1sj4GIj19ZOx/gxtR850gJ+PwFmi7U5/hXgeLDkTf45lyJPU1XsGZZyJ4oFBSTo1Q9
        g3sRTzcqrNL9De2nFRHoAdFC8YtiwJeODmlWWd559aKoqdQKbXr9Zjy6IVGi7e/BhLkTib
        laXjr0mGczzNFNzKJ0yIJAOPoNvRB3+mIXEnLSbnagZ0V5ceR3pvJbU7PEo4t/ZE4RfdCt
        cEpgQGq05ReZKkoUobMRsD9i8HwMGVv4wfC2dkp60B9CFjNfk4Nu0GvFiNDYbCbTNKkXN3
        XfaMNwC3sXc5v0xvaLWMM+i+Cupcj2SXwTxcptBMhCL2ErW0yDw4kSohQzWQPQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1626778523;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=8lPvVTbfOrGyEFM7yYBrV80a7op6U6jWP3hzLmgYm+s=;
        b=JiK0WDNi0VXxHudpdLy+iu6vAS7IiLoJVG5YYjg0ghVNWp/i8NNamR2Bs06v2felms8V1C
        TkYOgRGO909LoCBw==
From:   "tip-bot2 for Frederic Weisbecker" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: timers/urgent] posix-cpu-timers: Fix rearm racing against process tick
Cc:     "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        stable@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Message-ID: <162677852264.395.4295146742807519075.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the timers/urgent branch of tip:

Commit-ID:     1a3402d93c73bf6bb4df6d7c2aac35abfc3c50e2
Gitweb:        https://git.kernel.org/tip/1a3402d93c73bf6bb4df6d7c2aac35abfc3c50e2
Author:        Frederic Weisbecker <frederic@kernel.org>
AuthorDate:    Thu, 03 Jun 2021 01:15:59 +02:00
Committer:     Frederic Weisbecker <frederic@kernel.org>
CommitterDate: Thu, 15 Jul 2021 01:20:10 +02:00

posix-cpu-timers: Fix rearm racing against process tick

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
index 29a5e54..517be7f 100644
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
