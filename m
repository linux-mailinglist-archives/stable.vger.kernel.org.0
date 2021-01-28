Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAB26307C02
	for <lists+stable@lfdr.de>; Thu, 28 Jan 2021 18:18:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232854AbhA1RPb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jan 2021 12:15:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:50764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232793AbhA1RNR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 Jan 2021 12:13:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC20E64E1A;
        Thu, 28 Jan 2021 17:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611853955;
        bh=tkZdZ3735vkiRlryWG6nvVpMmiIjqnVftwoNlSqZ3B8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XC3mhRhh0huUhFSFNd4zs46msGrP1Lm5+ISAJQTs2kGinv3AK1tnU9QElwk9MqbE+
         S5ZYbva8Y9xuYhvNiOW1xAEmP3RASQlgFMqdwjoAmtG0QJzhTfRS+c75WIj2Y3F9Kw
         nXPDL+AqBElpmIGi5BHUM8gjAFsMtOsCDFCkp9dEcIVtyhZCqbuPB4v3XHiHDs8xLo
         HjI4p+hsDWYa23UM9BtOz6EH4y13r1710fBMnhap5Mew/sOY2IhkZMJ37alZsaiiqG
         7gt+lt+jyN6uH/VUomucrhh3M3aaRzjwuwsWXpf+QAc6XmONypqeamaZbhdZVuWcVI
         PnRGSLS5V0Auw==
From:   Frederic Weisbecker <frederic@kernel.org>
To:     "Paul E . McKenney" <paulmck@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Neeraj Upadhyay <neeraju@codeaurora.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Stable <stable@vger.kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>
Subject: [PATCH 03/16] rcu/nocb: Forbid NOCB toggling on offline CPUs
Date:   Thu, 28 Jan 2021 18:12:09 +0100
Message-Id: <20210128171222.131380-4-frederic@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210128171222.131380-1-frederic@kernel.org>
References: <20210128171222.131380-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Toggling the NOCB state of a CPU when it is offline imply some specific
issues to handle, especially making sure that the kthreads have handled
all the remaining callbacks and bypass before the corresponding CPU can
be set as non-offloaded while it is offline.

To prevent from such complications, simply forbid offline CPUs to
perform NOCB-mode toggling. It's a simple rule to observe and after all
it doesn't make much sense to switch a non working CPU to/from offloaded
state.

Reported-by: Paul E. McKenney <paulmck@kernel.org>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Neeraj Upadhyay <neeraju@codeaurora.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 kernel/rcu/tree.c        |  3 +--
 kernel/rcu/tree_plugin.h | 57 +++++++++++++++-------------------------
 2 files changed, 22 insertions(+), 38 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index e7a226abff0d..4c5a1ac54fa6 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -4068,8 +4068,7 @@ int rcutree_prepare_cpu(unsigned int cpu)
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
index dcfae03eb9e9..732942a15f2b 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2399,23 +2399,18 @@ static int rdp_offload_toggle(struct rcu_data *rdp,
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
@@ -2446,14 +2441,6 @@ static int __rcu_nocb_rdp_deoffload(struct rcu_data *rdp)
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
@@ -2466,12 +2453,14 @@ int rcu_nocb_cpu_deoffload(int cpu)
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
@@ -2480,12 +2469,14 @@ int rcu_nocb_cpu_deoffload(int cpu)
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
@@ -2525,14 +2516,6 @@ static int __rcu_nocb_rdp_offload(struct rcu_data *rdp)
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
@@ -2541,12 +2524,14 @@ int rcu_nocb_cpu_offload(int cpu)
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
-- 
2.25.1

