Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E707E15FB33
	for <lists+stable@lfdr.de>; Sat, 15 Feb 2020 00:58:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728517AbgBNX6C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 18:58:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:37906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728436AbgBNX6B (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 18:58:01 -0500
Received: from paulmck-ThinkPad-P72.c.hoisthospitality.com (unknown [62.84.152.189])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1102C24654;
        Fri, 14 Feb 2020 23:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581724680;
        bh=n8jIhHNs71ogHuL4lu8VxGWfjDBY6s7fdmQ+qRK6opY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Grw04+HBpcBkoeQWPGjA1lwrrQ8582oJq0s+6G6PDcqKe2RGhQ1qdgonBGk1lifjU
         PxdzzqXIM95tIMxYj6p2B5Y1kI+tP9JlVqfrjNlgTqkQbD5qGhXAtKyLYlewAruirc
         KjdwiLYWszT2hFlmilVGEk15K58eTmPm56zmL9Tk=
From:   paulmck@kernel.org
To:     rcu@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, kernel-team@fb.com, mingo@kernel.org,
        jiangshanlai@gmail.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        fweisbec@gmail.com, oleg@redhat.com, joel@joelfernandes.org,
        "Paul E. McKenney" <paulmck@kernel.org>,
        "# 5 . 5 . x" <stable@vger.kernel.org>
Subject: [PATCH tip/core/rcu 30/30] rcu: Make rcu_barrier() account for offline no-CBs CPUs
Date:   Fri, 14 Feb 2020 15:56:07 -0800
Message-Id: <20200214235607.13749-30-paulmck@kernel.org>
X-Mailer: git-send-email 2.9.5
In-Reply-To: <20200214235536.GA13364@paulmck-ThinkPad-P72>
References: <20200214235536.GA13364@paulmck-ThinkPad-P72>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Paul E. McKenney" <paulmck@kernel.org>

Currently, rcu_barrier() ignores offline CPUs,  However, it is possible
for an offline no-CBs CPU to have callbacks queued, and rcu_barrier()
must wait for those callbacks.  This commit therefore makes rcu_barrier()
directly invoke the rcu_barrier_func() with interrupts disabled for such
CPUs.  This requires passing the CPU number into this function so that
it can entrain the rcu_barrier() callback onto the correct CPU's callback
list, given that the code must instead execute on the current CPU.

While in the area, this commit fixes a bug where the first CPU's callback
might have been invoked before rcu_segcblist_entrain() returned, which
would also result in an early wakeup.

Fixes: 5d6742b37727 ("rcu/nocb: Use rcu_segcblist for no-CBs CPUs")
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Cc: <stable@vger.kernel.org> # 5.5.x
---
 include/trace/events/rcu.h |  1 +
 kernel/rcu/tree.c          | 32 ++++++++++++++++++++------------
 2 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/include/trace/events/rcu.h b/include/trace/events/rcu.h
index 5e49b06..d56d54c 100644
--- a/include/trace/events/rcu.h
+++ b/include/trace/events/rcu.h
@@ -712,6 +712,7 @@ TRACE_EVENT_RCU(rcu_torture_read,
  *	"Begin": rcu_barrier() started.
  *	"EarlyExit": rcu_barrier() piggybacked, thus early exit.
  *	"Inc1": rcu_barrier() piggyback check counter incremented.
+ *	"OfflineNoCBQ": rcu_barrier() found offline no-CBs CPU with callbacks.
  *	"OnlineQ": rcu_barrier() found online CPU with callbacks.
  *	"OnlineNQ": rcu_barrier() found online CPU, no callbacks.
  *	"IRQ": An rcu_barrier_callback() callback posted on remote CPU.
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index d15041f..160643e 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -3098,9 +3098,10 @@ static void rcu_barrier_callback(struct rcu_head *rhp)
 /*
  * Called with preemption disabled, and from cross-cpu IRQ context.
  */
-static void rcu_barrier_func(void *unused)
+static void rcu_barrier_func(void *cpu_in)
 {
-	struct rcu_data *rdp = raw_cpu_ptr(&rcu_data);
+	uintptr_t cpu = (uintptr_t)cpu_in;
+	struct rcu_data *rdp = per_cpu_ptr(&rcu_data, cpu);
 
 	rcu_barrier_trace(TPS("IRQ"), -1, rcu_state.barrier_sequence);
 	rdp->barrier_head.func = rcu_barrier_callback;
@@ -3127,7 +3128,7 @@ static void rcu_barrier_func(void *unused)
  */
 void rcu_barrier(void)
 {
-	int cpu;
+	uintptr_t cpu;
 	struct rcu_data *rdp;
 	unsigned long s = rcu_seq_snap(&rcu_state.barrier_sequence);
 
@@ -3150,13 +3151,14 @@ void rcu_barrier(void)
 	rcu_barrier_trace(TPS("Inc1"), -1, rcu_state.barrier_sequence);
 
 	/*
-	 * Initialize the count to one rather than to zero in order to
-	 * avoid a too-soon return to zero in case of a short grace period
-	 * (or preemption of this task).  Exclude CPU-hotplug operations
-	 * to ensure that no offline CPU has callbacks queued.
+	 * Initialize the count to two rather than to zero in order
+	 * to avoid a too-soon return to zero in case of an immediate
+	 * invocation of the just-enqueued callback (or preemption of
+	 * this task).  Exclude CPU-hotplug operations to ensure that no
+	 * offline non-offloaded CPU has callbacks queued.
 	 */
 	init_completion(&rcu_state.barrier_completion);
-	atomic_set(&rcu_state.barrier_cpu_count, 1);
+	atomic_set(&rcu_state.barrier_cpu_count, 2);
 	get_online_cpus();
 
 	/*
@@ -3166,13 +3168,19 @@ void rcu_barrier(void)
 	 */
 	for_each_possible_cpu(cpu) {
 		rdp = per_cpu_ptr(&rcu_data, cpu);
-		if (!cpu_online(cpu) &&
+		if (cpu_is_offline(cpu) &&
 		    !rcu_segcblist_is_offloaded(&rdp->cblist))
 			continue;
-		if (rcu_segcblist_n_cbs(&rdp->cblist)) {
+		if (rcu_segcblist_n_cbs(&rdp->cblist) && cpu_online(cpu)) {
 			rcu_barrier_trace(TPS("OnlineQ"), cpu,
 					  rcu_state.barrier_sequence);
-			smp_call_function_single(cpu, rcu_barrier_func, NULL, 1);
+			smp_call_function_single(cpu, rcu_barrier_func, (void *)cpu, 1);
+		} else if (cpu_is_offline(cpu)) {
+			rcu_barrier_trace(TPS("OfflineNoCBQ"), cpu,
+					  rcu_state.barrier_sequence);
+			local_irq_disable();
+			rcu_barrier_func((void *)cpu);
+			local_irq_enable();
 		} else {
 			rcu_barrier_trace(TPS("OnlineNQ"), cpu,
 					  rcu_state.barrier_sequence);
@@ -3184,7 +3192,7 @@ void rcu_barrier(void)
 	 * Now that we have an rcu_barrier_callback() callback on each
 	 * CPU, and thus each counted, remove the initial count.
 	 */
-	if (atomic_dec_and_test(&rcu_state.barrier_cpu_count))
+	if (atomic_sub_and_test(2, &rcu_state.barrier_cpu_count))
 		complete(&rcu_state.barrier_completion);
 
 	/* Wait for all rcu_barrier_callback() callbacks to be invoked. */
-- 
2.9.5

