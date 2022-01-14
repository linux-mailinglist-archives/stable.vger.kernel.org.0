Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4E248E620
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 09:23:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240129AbiANIXq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 03:23:46 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33730 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239875AbiANIWO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 03:22:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32C6DB8242B;
        Fri, 14 Jan 2022 08:22:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A928C36AE9;
        Fri, 14 Jan 2022 08:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642148531;
        bh=R8LDtVgPNv61s3p1d6o/xuHFihm2tCTiq1Wa8DMMXPc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G66OKCbUIr4Ao8BzlXq9g6rJRfbVBMsemkPhF9v1vbZKiMILjt9oyfFM9G57YPMqY
         5XymBWqND7nWSTJvfW7VP5pgACKCT0vs/+cerCH41D+0exCUbKiGT3rSlxfnWuonjU
         q2OoIOeXjgsjUNEAvI9AcnsIgvjbVTVFCiKA7cM0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lai Jiangshan <jiangshanlai@gmail.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 5.16 02/37] workqueue: Fix unbind_workers() VS wq_worker_sleeping() race
Date:   Fri, 14 Jan 2022 09:16:16 +0100
Message-Id: <20220114081544.937905971@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220114081544.849748488@linuxfoundation.org>
References: <20220114081544.849748488@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frederic Weisbecker <frederic@kernel.org>

commit 45c753f5f24d2d4717acb38ce35e604ff9abcb50 upstream.

At CPU-hotplug time, unbind_workers() may preempt a worker while it is
going to sleep. In that case the following scenario can happen:

    unbind_workers()                     wq_worker_sleeping()
    --------------                      -------------------
                                      if (worker->flags & WORKER_NOT_RUNNING)
                                          return;
                                      //PREEMPTED by unbind_workers
    worker->flags |= WORKER_UNBOUND;
    [...]
    atomic_set(&pool->nr_running, 0);
    //resume to worker
                                       atomic_dec_and_test(&pool->nr_running);

After unbind_worker() resets pool->nr_running, the value is expected to
remain 0 until the pool ever gets rebound in case cpu_up() is called on
the target CPU in the future. But here the race leaves pool->nr_running
with a value of -1, triggering the following warning when the worker goes
idle:

        WARNING: CPU: 3 PID: 34 at kernel/workqueue.c:1823 worker_enter_idle+0x95/0xc0
        Modules linked in:
        CPU: 3 PID: 34 Comm: kworker/3:0 Not tainted 5.16.0-rc1+ #34
        Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.12.0-59-gc9ba527-rebuilt.opensuse.org 04/01/2014
        Workqueue:  0x0 (rcu_par_gp)
        RIP: 0010:worker_enter_idle+0x95/0xc0
        Code: 04 85 f8 ff ff ff 39 c1 7f 09 48 8b 43 50 48 85 c0 74 1b 83 e2 04 75 99 8b 43 34 39 43 30 75 91 8b 83 00 03 00 00 85 c0 74 87 <0f> 0b 5b c3 48 8b 35 70 f1 37 01 48 8d 7b 48 48 81 c6 e0 93  0
        RSP: 0000:ffff9b7680277ed0 EFLAGS: 00010086
        RAX: 00000000ffffffff RBX: ffff93465eae9c00 RCX: 0000000000000000
        RDX: 0000000000000000 RSI: ffff9346418a0000 RDI: ffff934641057140
        RBP: ffff934641057170 R08: 0000000000000001 R09: ffff9346418a0080
        R10: ffff9b768027fdf0 R11: 0000000000002400 R12: ffff93465eae9c20
        R13: ffff93465eae9c20 R14: ffff93465eae9c70 R15: ffff934641057140
        FS:  0000000000000000(0000) GS:ffff93465eac0000(0000) knlGS:0000000000000000
        CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
        CR2: 0000000000000000 CR3: 000000001cc0c000 CR4: 00000000000006e0
        DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
        DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
        Call Trace:
          <TASK>
          worker_thread+0x89/0x3d0
          ? process_one_work+0x400/0x400
          kthread+0x162/0x190
          ? set_kthread_struct+0x40/0x40
          ret_from_fork+0x22/0x30
          </TASK>

Also due to this incorrect "nr_running == -1", all sorts of hazards can
happen, starting with queued works being ignored because no workers are
awaken at insert_work() time.

Fix this with checking again the worker flags while pool->lock is locked.

Fixes: b945efcdd07d ("sched: Remove pointless preemption disable in sched_submit_work()")
Reviewed-by: Lai Jiangshan <jiangshanlai@gmail.com>
Tested-by: Paul E. McKenney <paulmck@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Daniel Bristot de Oliveira <bristot@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/workqueue.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -913,6 +913,16 @@ void wq_worker_sleeping(struct task_stru
 	raw_spin_lock_irq(&pool->lock);
 
 	/*
+	 * Recheck in case unbind_workers() preempted us. We don't
+	 * want to decrement nr_running after the worker is unbound
+	 * and nr_running has been reset.
+	 */
+	if (worker->flags & WORKER_NOT_RUNNING) {
+		raw_spin_unlock_irq(&pool->lock);
+		return;
+	}
+
+	/*
 	 * The counterpart of the following dec_and_test, implied mb,
 	 * worklist not empty test sequence is in insert_work().
 	 * Please read comment there.


