Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4267B48E5B3
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 09:21:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240023AbiANIUZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 03:20:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237006AbiANIUB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 03:20:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5D0DC06175C;
        Fri, 14 Jan 2022 00:20:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7A636B823E6;
        Fri, 14 Jan 2022 08:20:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2912C36AEA;
        Fri, 14 Jan 2022 08:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642148399;
        bh=oSB93u3Ms+gNU2+klwKwwo1GhE4IqwsSDKKXBdxIty8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MVPJOXfohPiBuBQWFoK7rIecxq0GGa9LUEdg1Oa9p1uK35Ymxt3XwE6+glGya6WiY
         r2fSFMug6dtEv/+gogwYP2sLYnGKAy8HT2NOvykyabeWtFQ7QElxt/RJs+dYYIWNXr
         YoaCe/E3Mos9GhhlQetD58fsqFQ1rDnyARUdTsHU=
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
Subject: [PATCH 5.15 02/41] workqueue: Fix unbind_workers() VS wq_worker_running() race
Date:   Fri, 14 Jan 2022 09:16:02 +0100
Message-Id: <20220114081545.245897527@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220114081545.158363487@linuxfoundation.org>
References: <20220114081545.158363487@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frederic Weisbecker <frederic@kernel.org>

commit 07edfece8bcb0580a1828d939e6f8d91a8603eb2 upstream.

At CPU-hotplug time, unbind_worker() may preempt a worker while it is
waking up. In that case the following scenario can happen:

        unbind_workers()                     wq_worker_running()
        --------------                      -------------------
        	                      if (!(worker->flags & WORKER_NOT_RUNNING))
        	                          //PREEMPTED by unbind_workers
        worker->flags |= WORKER_UNBOUND;
        [...]
        atomic_set(&pool->nr_running, 0);
        //resume to worker
		                              atomic_inc(&worker->pool->nr_running);

After unbind_worker() resets pool->nr_running, the value is expected to
remain 0 until the pool ever gets rebound in case cpu_up() is called on
the target CPU in the future. But here the race leaves pool->nr_running
with a value of 1, triggering the following warning when the worker goes
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

Also due to this incorrect "nr_running == 1", further queued work may
end up not being served, because no worker is awaken at work insert time.
This raises rcutorture writer stalls for example.

Fix this with disabling preemption in the right place in
wq_worker_running().

It's worth noting that if the worker migrates and runs concurrently with
unbind_workers(), it is guaranteed to see the WORKER_UNBOUND flag update
due to set_cpus_allowed_ptr() acquiring/releasing rq->lock.

Fixes: 6d25be5782e4 ("sched/core, workqueues: Distangle worker accounting from rq lock")
Reviewed-by: Lai Jiangshan <jiangshanlai@gmail.com>
Tested-by: Paul E. McKenney <paulmck@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Daniel Bristot de Oliveira <bristot@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/workqueue.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -867,8 +867,17 @@ void wq_worker_running(struct task_struc
 
 	if (!worker->sleeping)
 		return;
+
+	/*
+	 * If preempted by unbind_workers() between the WORKER_NOT_RUNNING check
+	 * and the nr_running increment below, we may ruin the nr_running reset
+	 * and leave with an unexpected pool->nr_running == 1 on the newly unbound
+	 * pool. Protect against such race.
+	 */
+	preempt_disable();
 	if (!(worker->flags & WORKER_NOT_RUNNING))
 		atomic_inc(&worker->pool->nr_running);
+	preempt_enable();
 	worker->sleeping = 0;
 }
 


