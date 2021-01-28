Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABF0F307F06
	for <lists+stable@lfdr.de>; Thu, 28 Jan 2021 21:02:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbhA1T7V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jan 2021 14:59:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:54138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229595AbhA1T67 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 Jan 2021 14:58:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2772964E3D;
        Thu, 28 Jan 2021 19:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611863542;
        bh=8zEAI1CZ86s1UlqBcPyZhOMT3EnyRxIPkSG0TJEOVf0=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=s8ygVHbUKNn0fTuAJGqG6PNEMLynCCBP9o8mMAuqEhdmBp9AY4+Oy/Kc5tUov8YMS
         /6+JVFD7TEskuVwYzE32eoFF5tPj5vXYWJnR9L1CoZHFObKMUUIh/GCwxSMG81vyYO
         PO9RRiBFYSA/u3nZU6bZcSG3I/xyvOPC5b029rrHFnK+6rF2stvwoxXTAlksLyOfhp
         x+Wopvk7STf4X1zuNi5PwKSuhG1xORF13ic3y+zQJjkWHr7rU6u5b3ls91Qo/idnka
         JTtpGvxIoqfqAQr5clvx0bKLtm48gu7DT0UNFynf2NAqCVm+nrJy8sQVCltCiepNKG
         ksci4VXhmP+pA==
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id A6DEE35237A0; Thu, 28 Jan 2021 11:52:21 -0800 (PST)
Date:   Thu, 28 Jan 2021 11:52:21 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Frederic Weisbecker <frederic@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Neeraj Upadhyay <neeraju@codeaurora.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Stable <stable@vger.kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>
Subject: Re: [PATCH 03/16] rcu/nocb: Forbid NOCB toggling on offline CPUs
Message-ID: <20210128195221.GS2743@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20210128171222.131380-1-frederic@kernel.org>
 <20210128171222.131380-4-frederic@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210128171222.131380-4-frederic@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 28, 2021 at 06:12:09PM +0100, Frederic Weisbecker wrote:
> Toggling the NOCB state of a CPU when it is offline imply some specific
> issues to handle, especially making sure that the kthreads have handled
> all the remaining callbacks and bypass before the corresponding CPU can
> be set as non-offloaded while it is offline.
> 
> To prevent from such complications, simply forbid offline CPUs to
> perform NOCB-mode toggling. It's a simple rule to observe and after all
> it doesn't make much sense to switch a non working CPU to/from offloaded
> state.
> 
> Reported-by: Paul E. McKenney <paulmck@kernel.org>
> Cc: Josh Triplett <josh@joshtriplett.org>
> Cc: Lai Jiangshan <jiangshanlai@gmail.com>
> Cc: Joel Fernandes <joel@joelfernandes.org>
> Cc: Neeraj Upadhyay <neeraju@codeaurora.org>
> Cc: Boqun Feng <boqun.feng@gmail.com>
> Signed-off-by: Frederic Weisbecker <frederic@kernel.org>

Very nice, cuts out a world of hurt, thank you!  Queued for testing and
further review, the usual wordsmithing applied and the usual request
for you to check to see if I messed anything up.

							Thanx, Paul

------------------------------------------------------------------------

commit 4fbfeec81533e6ea9811e57cc848ee30522c0517
Author: Frederic Weisbecker <frederic@kernel.org>
Date:   Thu Jan 28 18:12:09 2021 +0100

    rcu/nocb: Forbid NOCB toggling on offline CPUs
    
    It makes no sense to de-offload an offline CPU because that CPU will never
    invoke any remaining callbacks.  It also makes little sense to offload an
    offline CPU because any pending RCU callbacks were migrated when that CPU
    went offline.  Yes, it is in theory possible to use a number of tricks
    to permit offloading and deoffloading offline CPUs in certain cases, but
    in practice it is far better to have the simple and deterministic rule
    "Toggling the offload state of an offline CPU is forbidden".
    
    For but one example, consider that an offloaded offline CPU might have
    millions of callbacks queued.  Best to just say "no".
    
    This commit therefore forbids toggling of the offloaded state of
    offline CPUs.
    
    Reported-by: Paul E. McKenney <paulmck@kernel.org>
    Cc: Josh Triplett <josh@joshtriplett.org>
    Cc: Lai Jiangshan <jiangshanlai@gmail.com>
    Cc: Joel Fernandes <joel@joelfernandes.org>
    Cc: Neeraj Upadhyay <neeraju@codeaurora.org>
    Cc: Boqun Feng <boqun.feng@gmail.com>
    Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
    Signed-off-by: Paul E. McKenney <paulmck@kernel.org>

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 8bb8da2..00059df 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -4066,8 +4066,7 @@ int rcutree_prepare_cpu(unsigned int cpu)
 	raw_spin_unlock_rcu_node(rnp);		/* irqs remain disabled. */
 	/*
 	 * Lock in case the CB/GP kthreads are still around handling
-	 * old callbacks (longer term we should flush all callbacks
-	 * before completing CPU offline)
+	 * old callbacks.
 	 */
 	rcu_nocb_lock(rdp);
 	if (rcu_segcblist_empty(&rdp->cblist)) /* No early-boot CBs? */
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index f1ebe67..c61613a 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2398,23 +2398,18 @@ static int rdp_offload_toggle(struct rcu_data *rdp,
 	return 0;
 }
 
-static int __rcu_nocb_rdp_deoffload(struct rcu_data *rdp)
+static long rcu_nocb_rdp_deoffload(void *arg)
 {
+	struct rcu_data *rdp = arg;
 	struct rcu_segcblist *cblist = &rdp->cblist;
 	unsigned long flags;
 	int ret;
 
+	WARN_ON_ONCE(rdp->cpu != raw_smp_processor_id());
+
 	pr_info("De-offloading %d\n", rdp->cpu);
 
 	rcu_nocb_lock_irqsave(rdp, flags);
-	/*
-	 * If there are still pending work offloaded, the offline
-	 * CPU won't help much handling them.
-	 */
-	if (cpu_is_offline(rdp->cpu) && !rcu_segcblist_empty(&rdp->cblist)) {
-		rcu_nocb_unlock_irqrestore(rdp, flags);
-		return -EBUSY;
-	}
 
 	ret = rdp_offload_toggle(rdp, false, flags);
 	swait_event_exclusive(rdp->nocb_state_wq,
@@ -2445,14 +2440,6 @@ static int __rcu_nocb_rdp_deoffload(struct rcu_data *rdp)
 	return ret;
 }
 
-static long rcu_nocb_rdp_deoffload(void *arg)
-{
-	struct rcu_data *rdp = arg;
-
-	WARN_ON_ONCE(rdp->cpu != raw_smp_processor_id());
-	return __rcu_nocb_rdp_deoffload(rdp);
-}
-
 int rcu_nocb_cpu_deoffload(int cpu)
 {
 	struct rcu_data *rdp = per_cpu_ptr(&rcu_data, cpu);
@@ -2465,12 +2452,14 @@ int rcu_nocb_cpu_deoffload(int cpu)
 	mutex_lock(&rcu_state.barrier_mutex);
 	cpus_read_lock();
 	if (rcu_rdp_is_offloaded(rdp)) {
-		if (cpu_online(cpu))
+		if (cpu_online(cpu)) {
 			ret = work_on_cpu(cpu, rcu_nocb_rdp_deoffload, rdp);
-		else
-			ret = __rcu_nocb_rdp_deoffload(rdp);
-		if (!ret)
-			cpumask_clear_cpu(cpu, rcu_nocb_mask);
+			if (!ret)
+				cpumask_clear_cpu(cpu, rcu_nocb_mask);
+		} else {
+			pr_info("NOCB: Can't CB-deoffload an offline CPU\n");
+			ret = -EINVAL;
+		}
 	}
 	cpus_read_unlock();
 	mutex_unlock(&rcu_state.barrier_mutex);
@@ -2479,12 +2468,14 @@ int rcu_nocb_cpu_deoffload(int cpu)
 }
 EXPORT_SYMBOL_GPL(rcu_nocb_cpu_deoffload);
 
-static int __rcu_nocb_rdp_offload(struct rcu_data *rdp)
+static long rcu_nocb_rdp_offload(void *arg)
 {
+	struct rcu_data *rdp = arg;
 	struct rcu_segcblist *cblist = &rdp->cblist;
 	unsigned long flags;
 	int ret;
 
+	WARN_ON_ONCE(rdp->cpu != raw_smp_processor_id());
 	/*
 	 * For now we only support re-offload, ie: the rdp must have been
 	 * offloaded on boot first.
@@ -2524,14 +2515,6 @@ static int __rcu_nocb_rdp_offload(struct rcu_data *rdp)
 	return ret;
 }
 
-static long rcu_nocb_rdp_offload(void *arg)
-{
-	struct rcu_data *rdp = arg;
-
-	WARN_ON_ONCE(rdp->cpu != raw_smp_processor_id());
-	return __rcu_nocb_rdp_offload(rdp);
-}
-
 int rcu_nocb_cpu_offload(int cpu)
 {
 	struct rcu_data *rdp = per_cpu_ptr(&rcu_data, cpu);
@@ -2540,12 +2523,14 @@ int rcu_nocb_cpu_offload(int cpu)
 	mutex_lock(&rcu_state.barrier_mutex);
 	cpus_read_lock();
 	if (!rcu_rdp_is_offloaded(rdp)) {
-		if (cpu_online(cpu))
+		if (cpu_online(cpu)) {
 			ret = work_on_cpu(cpu, rcu_nocb_rdp_offload, rdp);
-		else
-			ret = __rcu_nocb_rdp_offload(rdp);
-		if (!ret)
-			cpumask_set_cpu(cpu, rcu_nocb_mask);
+			if (!ret)
+				cpumask_set_cpu(cpu, rcu_nocb_mask);
+		} else {
+			pr_info("NOCB: Can't CB-offload an offline CPU\n");
+			ret = -EINVAL;
+		}
 	}
 	cpus_read_unlock();
 	mutex_unlock(&rcu_state.barrier_mutex);
