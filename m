Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 757C84E9336
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 13:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240651AbiC1LU4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 07:20:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240583AbiC1LU2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 07:20:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA12D55759;
        Mon, 28 Mar 2022 04:18:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D667E6114A;
        Mon, 28 Mar 2022 11:18:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4393BC340EC;
        Mon, 28 Mar 2022 11:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648466322;
        bh=2ncRTTPX3hIETBFICl5p5zP4ZHOlcCFDMCrPZS07OeY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QOlYCyhAyP9rpIdayW4xuVUWGP1ams/4RzUIFnK9BVtnPdRI0PCWsr9F+G1wCPEum
         Y6DGwTpYPH9A0NdsT0QOAE8+1nj/umjX4bEc1HKrs6X8Xdmyo7nOudQOaHzkPQTlnQ
         GDFgP/3/7wZT2BHrugkQmw4lTUYWmoTSU4o7pQarL8lbGIFEBo8uNa+AheDhNnnfto
         Ze/urRgjktwyOVhssGDnYfSlRMbStJslhvZeizREKikszQj8dm8KVhOieVsDCEnrLR
         gmLWGdjq2tAw4MzmqV+wG68vYpjbvohFXf8sL6jmaZz9LHNamMLeWtUz7k5/Ku7ijG
         b57zZNXF/s0Og==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Woodhouse <dwmw@amazon.co.uk>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>, frederic@kernel.org,
        quic_neeraju@quicinc.com, josh@joshtriplett.org,
        rcu@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 06/43] rcu: Kill rnp->ofl_seq and use only rcu_state.ofl_lock for exclusion
Date:   Mon, 28 Mar 2022 07:17:50 -0400
Message-Id: <20220328111828.1554086-6-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220328111828.1554086-1-sashal@kernel.org>
References: <20220328111828.1554086-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

[ Upstream commit 82980b1622d97017053c6792382469d7dc26a486 ]

If we allow architectures to bring APs online in parallel, then we end
up requiring rcu_cpu_starting() to be reentrant. But currently, the
manipulation of rnp->ofl_seq is not thread-safe.

However, rnp->ofl_seq is also fairly much pointless anyway since both
rcu_cpu_starting() and rcu_report_dead() hold rcu_state.ofl_lock for
fairly much the whole time that rnp->ofl_seq is set to an odd number
to indicate that an operation is in progress.

So drop rnp->ofl_seq completely, and use only rcu_state.ofl_lock.

This has a couple of minor complexities: lockdep will complain when we
take rcu_state.ofl_lock, and currently accepts the 'excuse' of having
an odd value in rnp->ofl_seq. So switch it to an arch_spinlock_t to
avoid that false positive complaint. Since we're killing rnp->ofl_seq
of course that 'excuse' has to be changed too, so make it check for
arch_spin_is_locked(rcu_state.ofl_lock).

There's no arch_spin_lock_irqsave() so we have to manually save and
restore local interrupts around the locking.

At Paul's request based on Neeraj's analysis, make rcu_gp_init not just
wait but *exclude* any CPU online/offline activity, which was fairly
much true already by virtue of it holding rcu_state.ofl_lock.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tree.c | 71 ++++++++++++++++++++++++-----------------------
 kernel/rcu/tree.h |  4 +--
 2 files changed, 37 insertions(+), 38 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index a4c25a6283b0..73a4c9d07b86 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -91,7 +91,7 @@ static struct rcu_state rcu_state = {
 	.abbr = RCU_ABBR,
 	.exp_mutex = __MUTEX_INITIALIZER(rcu_state.exp_mutex),
 	.exp_wake_mutex = __MUTEX_INITIALIZER(rcu_state.exp_wake_mutex),
-	.ofl_lock = __RAW_SPIN_LOCK_UNLOCKED(rcu_state.ofl_lock),
+	.ofl_lock = __ARCH_SPIN_LOCK_UNLOCKED,
 };
 
 /* Dump rcu_node combining tree at boot to verify correct setup. */
@@ -1175,7 +1175,15 @@ bool rcu_lockdep_current_cpu_online(void)
 	preempt_disable_notrace();
 	rdp = this_cpu_ptr(&rcu_data);
 	rnp = rdp->mynode;
-	if (rdp->grpmask & rcu_rnp_online_cpus(rnp) || READ_ONCE(rnp->ofl_seq) & 0x1)
+	/*
+	 * Strictly, we care here about the case where the current CPU is
+	 * in rcu_cpu_starting() and thus has an excuse for rdp->grpmask
+	 * not being up to date. So arch_spin_is_locked() might have a
+	 * false positive if it's held by some *other* CPU, but that's
+	 * OK because that just means a false *negative* on the warning.
+	 */
+	if (rdp->grpmask & rcu_rnp_online_cpus(rnp) ||
+	    arch_spin_is_locked(&rcu_state.ofl_lock))
 		ret = true;
 	preempt_enable_notrace();
 	return ret;
@@ -1739,7 +1747,6 @@ static void rcu_strict_gp_boundary(void *unused)
  */
 static noinline_for_stack bool rcu_gp_init(void)
 {
-	unsigned long firstseq;
 	unsigned long flags;
 	unsigned long oldmask;
 	unsigned long mask;
@@ -1782,22 +1789,17 @@ static noinline_for_stack bool rcu_gp_init(void)
 	 * of RCU's Requirements documentation.
 	 */
 	WRITE_ONCE(rcu_state.gp_state, RCU_GP_ONOFF);
+	/* Exclude CPU hotplug operations. */
 	rcu_for_each_leaf_node(rnp) {
-		// Wait for CPU-hotplug operations that might have
-		// started before this grace period did.
-		smp_mb(); // Pair with barriers used when updating ->ofl_seq to odd values.
-		firstseq = READ_ONCE(rnp->ofl_seq);
-		if (firstseq & 0x1)
-			while (firstseq == READ_ONCE(rnp->ofl_seq))
-				schedule_timeout_idle(1);  // Can't wake unless RCU is watching.
-		smp_mb(); // Pair with barriers used when updating ->ofl_seq to even values.
-		raw_spin_lock(&rcu_state.ofl_lock);
-		raw_spin_lock_irq_rcu_node(rnp);
+		local_irq_save(flags);
+		arch_spin_lock(&rcu_state.ofl_lock);
+		raw_spin_lock_rcu_node(rnp);
 		if (rnp->qsmaskinit == rnp->qsmaskinitnext &&
 		    !rnp->wait_blkd_tasks) {
 			/* Nothing to do on this leaf rcu_node structure. */
-			raw_spin_unlock_irq_rcu_node(rnp);
-			raw_spin_unlock(&rcu_state.ofl_lock);
+			raw_spin_unlock_rcu_node(rnp);
+			arch_spin_unlock(&rcu_state.ofl_lock);
+			local_irq_restore(flags);
 			continue;
 		}
 
@@ -1832,8 +1834,9 @@ static noinline_for_stack bool rcu_gp_init(void)
 				rcu_cleanup_dead_rnp(rnp);
 		}
 
-		raw_spin_unlock_irq_rcu_node(rnp);
-		raw_spin_unlock(&rcu_state.ofl_lock);
+		raw_spin_unlock_rcu_node(rnp);
+		arch_spin_unlock(&rcu_state.ofl_lock);
+		local_irq_restore(flags);
 	}
 	rcu_gp_slow(gp_preinit_delay); /* Races with CPU hotplug. */
 
@@ -4287,11 +4290,10 @@ void rcu_cpu_starting(unsigned int cpu)
 
 	rnp = rdp->mynode;
 	mask = rdp->grpmask;
-	WRITE_ONCE(rnp->ofl_seq, rnp->ofl_seq + 1);
-	WARN_ON_ONCE(!(rnp->ofl_seq & 0x1));
+	local_irq_save(flags);
+	arch_spin_lock(&rcu_state.ofl_lock);
 	rcu_dynticks_eqs_online();
-	smp_mb(); // Pair with rcu_gp_cleanup()'s ->ofl_seq barrier().
-	raw_spin_lock_irqsave_rcu_node(rnp, flags);
+	raw_spin_lock_rcu_node(rnp);
 	WRITE_ONCE(rnp->qsmaskinitnext, rnp->qsmaskinitnext | mask);
 	newcpu = !(rnp->expmaskinitnext & mask);
 	rnp->expmaskinitnext |= mask;
@@ -4304,15 +4306,18 @@ void rcu_cpu_starting(unsigned int cpu)
 
 	/* An incoming CPU should never be blocking a grace period. */
 	if (WARN_ON_ONCE(rnp->qsmask & mask)) { /* RCU waiting on incoming CPU? */
+		/* rcu_report_qs_rnp() *really* wants some flags to restore */
+		unsigned long flags2;
+
+		local_irq_save(flags2);
 		rcu_disable_urgency_upon_qs(rdp);
 		/* Report QS -after- changing ->qsmaskinitnext! */
-		rcu_report_qs_rnp(mask, rnp, rnp->gp_seq, flags);
+		rcu_report_qs_rnp(mask, rnp, rnp->gp_seq, flags2);
 	} else {
-		raw_spin_unlock_irqrestore_rcu_node(rnp, flags);
+		raw_spin_unlock_rcu_node(rnp);
 	}
-	smp_mb(); // Pair with rcu_gp_cleanup()'s ->ofl_seq barrier().
-	WRITE_ONCE(rnp->ofl_seq, rnp->ofl_seq + 1);
-	WARN_ON_ONCE(rnp->ofl_seq & 0x1);
+	arch_spin_unlock(&rcu_state.ofl_lock);
+	local_irq_restore(flags);
 	smp_mb(); /* Ensure RCU read-side usage follows above initialization. */
 }
 
@@ -4326,7 +4331,7 @@ void rcu_cpu_starting(unsigned int cpu)
  */
 void rcu_report_dead(unsigned int cpu)
 {
-	unsigned long flags;
+	unsigned long flags, seq_flags;
 	unsigned long mask;
 	struct rcu_data *rdp = per_cpu_ptr(&rcu_data, cpu);
 	struct rcu_node *rnp = rdp->mynode;  /* Outgoing CPU's rdp & rnp. */
@@ -4340,10 +4345,8 @@ void rcu_report_dead(unsigned int cpu)
 
 	/* Remove outgoing CPU from mask in the leaf rcu_node structure. */
 	mask = rdp->grpmask;
-	WRITE_ONCE(rnp->ofl_seq, rnp->ofl_seq + 1);
-	WARN_ON_ONCE(!(rnp->ofl_seq & 0x1));
-	smp_mb(); // Pair with rcu_gp_cleanup()'s ->ofl_seq barrier().
-	raw_spin_lock(&rcu_state.ofl_lock);
+	local_irq_save(seq_flags);
+	arch_spin_lock(&rcu_state.ofl_lock);
 	raw_spin_lock_irqsave_rcu_node(rnp, flags); /* Enforce GP memory-order guarantee. */
 	rdp->rcu_ofl_gp_seq = READ_ONCE(rcu_state.gp_seq);
 	rdp->rcu_ofl_gp_flags = READ_ONCE(rcu_state.gp_flags);
@@ -4354,10 +4357,8 @@ void rcu_report_dead(unsigned int cpu)
 	}
 	WRITE_ONCE(rnp->qsmaskinitnext, rnp->qsmaskinitnext & ~mask);
 	raw_spin_unlock_irqrestore_rcu_node(rnp, flags);
-	raw_spin_unlock(&rcu_state.ofl_lock);
-	smp_mb(); // Pair with rcu_gp_cleanup()'s ->ofl_seq barrier().
-	WRITE_ONCE(rnp->ofl_seq, rnp->ofl_seq + 1);
-	WARN_ON_ONCE(rnp->ofl_seq & 0x1);
+	arch_spin_unlock(&rcu_state.ofl_lock);
+	local_irq_restore(seq_flags);
 
 	rdp->cpu_started = false;
 }
diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
index 486fc901bd08..4b4bcef8a974 100644
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -56,8 +56,6 @@ struct rcu_node {
 				/*  Initialized from ->qsmaskinitnext at the */
 				/*  beginning of each grace period. */
 	unsigned long qsmaskinitnext;
-	unsigned long ofl_seq;	/* CPU-hotplug operation sequence count. */
-				/* Online CPUs for next grace period. */
 	unsigned long expmask;	/* CPUs or groups that need to check in */
 				/*  to allow the current expedited GP */
 				/*  to complete. */
@@ -355,7 +353,7 @@ struct rcu_state {
 	const char *name;			/* Name of structure. */
 	char abbr;				/* Abbreviated name. */
 
-	raw_spinlock_t ofl_lock ____cacheline_internodealigned_in_smp;
+	arch_spinlock_t ofl_lock ____cacheline_internodealigned_in_smp;
 						/* Synchronize offline with */
 						/*  GP pre-initialization. */
 };
-- 
2.34.1

