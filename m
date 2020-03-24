Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0043D1908D6
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 10:16:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727095AbgCXJQa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 05:16:30 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:43851 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726697AbgCXJQ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Mar 2020 05:16:29 -0400
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1jGffe-0007ty-UA; Tue, 24 Mar 2020 10:16:27 +0100
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id 39AB61C0451;
        Tue, 24 Mar 2020 10:16:26 +0100 (CET)
Date:   Tue, 24 Mar 2020 09:16:25 -0000
From:   "tip-bot2 for Paul E. McKenney" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: core/rcu] rcu: Make rcu_barrier() account for offline no-CBs CPUs
Cc:     "Paul E. McKenney" <paulmck@kernel.org>, <stable@vger.kernel.org>,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <158504138587.28353.3587174919590819871.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the core/rcu branch of tip:

Commit-ID:     127e29815b4b2206c0a97ac1d83f92ffc0e25c34
Gitweb:        https://git.kernel.org/tip/127e29815b4b2206c0a97ac1d83f92ffc0e25c34
Author:        Paul E. McKenney <paulmck@kernel.org>
AuthorDate:    Tue, 11 Feb 2020 06:17:33 -08:00
Committer:     Paul E. McKenney <paulmck@kernel.org>
CommitterDate: Sat, 21 Mar 2020 16:14:25 -07:00

rcu: Make rcu_barrier() account for offline no-CBs CPUs

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
[ paulmck: Apply optimization feedback from Boqun Feng. ]
Cc: <stable@vger.kernel.org> # 5.5.x
---
 include/trace/events/rcu.h |  1 +
 kernel/rcu/tree.c          | 36 ++++++++++++++++++++++++------------
 2 files changed, 25 insertions(+), 12 deletions(-)

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
index 739788f..35292c8 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -3097,9 +3097,10 @@ static void rcu_barrier_callback(struct rcu_head *rhp)
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
@@ -3126,7 +3127,7 @@ static void rcu_barrier_func(void *unused)
  */
 void rcu_barrier(void)
 {
-	int cpu;
+	uintptr_t cpu;
 	struct rcu_data *rdp;
 	unsigned long s = rcu_seq_snap(&rcu_state.barrier_sequence);
 
@@ -3149,13 +3150,14 @@ void rcu_barrier(void)
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
@@ -3165,13 +3167,23 @@ void rcu_barrier(void)
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
+		} else if (rcu_segcblist_n_cbs(&rdp->cblist) &&
+			   cpu_is_offline(cpu)) {
+			rcu_barrier_trace(TPS("OfflineNoCBQ"), cpu,
+					  rcu_state.barrier_sequence);
+			local_irq_disable();
+			rcu_barrier_func((void *)cpu);
+			local_irq_enable();
+		} else if (cpu_is_offline(cpu)) {
+			rcu_barrier_trace(TPS("OfflineNoCBNoQ"), cpu,
+					  rcu_state.barrier_sequence);
 		} else {
 			rcu_barrier_trace(TPS("OnlineNQ"), cpu,
 					  rcu_state.barrier_sequence);
@@ -3183,7 +3195,7 @@ void rcu_barrier(void)
 	 * Now that we have an rcu_barrier_callback() callback on each
 	 * CPU, and thus each counted, remove the initial count.
 	 */
-	if (atomic_dec_and_test(&rcu_state.barrier_cpu_count))
+	if (atomic_sub_and_test(2, &rcu_state.barrier_cpu_count))
 		complete(&rcu_state.barrier_completion);
 
 	/* Wait for all rcu_barrier_callback() callbacks to be invoked. */
