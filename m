Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 279C73C9D05
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 12:42:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241569AbhGOKpU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 06:45:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:52008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240920AbhGOKpU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 06:45:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 49D23613C0;
        Thu, 15 Jul 2021 10:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626345747;
        bh=YclN/odYoP04lN50BJ4ZxjBFT2n0ds/xP7p7UpTSEh8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UMoWj/RvhBTk6BUxeqajsC6nr1Jp0AzGp4wRZMbdYPofrDPhnr6miJjgxcWVEHAMp
         C1Zcm5FYR+Mo4qF5Tc6d2+m/tgAhfnkpPEZFUmfvRG9aUNfq2bikOQqvPcZ7IzPVIS
         2JCfdcXnby68hFwBTcws+QClYffivtgdsSEwcfzXnQa70uleI+LSKmnkKOUePzZZbS
         UeivXfAzlj7YCzjJkba1EPdlMp3U73x0t45msRsYO7I5S91SmwFVQ8xX8izegYbHD6
         9jQElbpiiRUQY5Ci0M/Iuh+NMCgBcpOhQxVPKOzEnaJEjtM9m47eo/Y40Fj6/NTjzi
         Wqr10plvY0ITQ==
From:   Frederic Weisbecker <frederic@kernel.org>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Oleg Nesterov <oleg@redhat.com>, stable@vger.kernel.org,
        Nicolas Saenz Julienne <nsaenzju@redhat.com>
Subject: [PATCH 1/2] posix-cpu-timers: Fix rearm racing against process tick
Date:   Thu, 15 Jul 2021 12:42:17 +0200
Message-Id: <20210715104218.81276-2-frederic@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210715104218.81276-1-frederic@kernel.org>
References: <20210715104218.81276-1-frederic@kernel.org>
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
index 29a5e54e6e10..517be7fd175e 100644
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

