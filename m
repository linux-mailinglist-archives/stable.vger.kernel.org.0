Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 630FA3D6107
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbhGZP1Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:27:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:40446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238345AbhGZPZ0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:25:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0531560F6B;
        Mon, 26 Jul 2021 16:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315555;
        bh=VGjDmFS/VCFvf6MWF09yXAnp+giMB7GjGJ677XJ/ZV4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xQv5kJfpLZpINkSeAfxR8AZ66WQSJDJgCByWBjS7+x/1RMjLTIolRR+n1AvhoQVlg
         fqfHkubTRQLr7+YpgnIUBjUiCDT/EbzKU09VTDavQzRkI6P5pLmxqBoI6J/88pb91t
         fJruGNfJZKpv73zbLIpuCsiUK1cKXGLZCHvL7jVs=
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
Subject: [PATCH 5.10 142/167] posix-cpu-timers: Fix rearm racing against process tick
Date:   Mon, 26 Jul 2021 17:39:35 +0200
Message-Id: <20210726153844.172089019@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153839.371771838@linuxfoundation.org>
References: <20210726153839.371771838@linuxfoundation.org>
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


