Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15CFF1AC307
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2897384AbgDPNgy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:36:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:48870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2896445AbgDPNgr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:36:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 142B7208E4;
        Thu, 16 Apr 2020 13:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044207;
        bh=WEjbj32u1Jb4ntTAzOpTsIfb0FsieTcI5zbiUUeeuy4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KMRjSWHEbi/Io/qN2QPDO3Mkc5WB5Ro2Hjb5cdzn5ws39XR9PU3CrfCfCe0Oy4Bgp
         q01EwlbcXyOhC2RV5peFyD/Vpa9e3VauWi688MYtXRD/7v2e6UL7i/zXoBULyKXLPJ
         RE37Fn4M9J5Q3Etjizu/DGA/O6yfAl/CDcpEnrGw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Paul E. McKenney" <paulmck@kernel.org>
Subject: [PATCH 5.5 125/257] rcu: Make rcu_barrier() account for offline no-CBs CPUs
Date:   Thu, 16 Apr 2020 15:22:56 +0200
Message-Id: <20200416131341.998176100@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.891903893@linuxfoundation.org>
References: <20200416131325.891903893@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul E. McKenney <paulmck@kernel.org>

commit 127e29815b4b2206c0a97ac1d83f92ffc0e25c34 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/trace/events/rcu.h |    1 +
 kernel/rcu/tree.c          |   36 ++++++++++++++++++++++++------------
 2 files changed, 25 insertions(+), 12 deletions(-)

--- a/include/trace/events/rcu.h
+++ b/include/trace/events/rcu.h
@@ -720,6 +720,7 @@ TRACE_EVENT_RCU(rcu_torture_read,
  *	"Begin": rcu_barrier() started.
  *	"EarlyExit": rcu_barrier() piggybacked, thus early exit.
  *	"Inc1": rcu_barrier() piggyback check counter incremented.
+ *	"OfflineNoCBQ": rcu_barrier() found offline no-CBs CPU with callbacks.
  *	"OnlineQ": rcu_barrier() found online CPU with callbacks.
  *	"OnlineNQ": rcu_barrier() found online CPU, no callbacks.
  *	"IRQ": An rcu_barrier_callback() callback posted on remote CPU.
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -2888,9 +2888,10 @@ static void rcu_barrier_callback(struct
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
@@ -2917,7 +2918,7 @@ static void rcu_barrier_func(void *unuse
  */
 void rcu_barrier(void)
 {
-	int cpu;
+	uintptr_t cpu;
 	struct rcu_data *rdp;
 	unsigned long s = rcu_seq_snap(&rcu_state.barrier_sequence);
 
@@ -2940,13 +2941,14 @@ void rcu_barrier(void)
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
@@ -2956,13 +2958,23 @@ void rcu_barrier(void)
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
@@ -2974,7 +2986,7 @@ void rcu_barrier(void)
 	 * Now that we have an rcu_barrier_callback() callback on each
 	 * CPU, and thus each counted, remove the initial count.
 	 */
-	if (atomic_dec_and_test(&rcu_state.barrier_cpu_count))
+	if (atomic_sub_and_test(2, &rcu_state.barrier_cpu_count))
 		complete(&rcu_state.barrier_completion);
 
 	/* Wait for all rcu_barrier_callback() callbacks to be invoked. */


