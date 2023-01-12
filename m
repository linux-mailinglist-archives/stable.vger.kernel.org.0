Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B833667748
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:41:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239685AbjALOl2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:41:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239795AbjALOku (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:40:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D6CB58F9D
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:30:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3CB2B8113E
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:30:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E36C7C433D2;
        Thu, 12 Jan 2023 14:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673533833;
        bh=WgbIkmvQwjCbUIPgdHBdEXR1rrcSIVLu2v9BTSpJT7s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hm8CR8cl65yr5a1ZWXcysTVIzqfREO8ez7LgbQUGUafj453TBxw6FefwFwhVR8agZ
         bzfsBuavzRnIVd3KKRrCWkizAZDHV4pqU8r3EKQbAQcUk01O5Mjhb1whTDb1hwyjD7
         6ev8AyYJXZC6ADRFhf6kAn6o9PUezDyb/d3CDzGI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Paul E. McKenney" <paulmck@kernel.org>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>
Subject: [PATCH 5.10 607/783] rcu: Prevent lockdep-RCU splats on lock acquisition/release
Date:   Thu, 12 Jan 2023 14:55:23 +0100
Message-Id: <20230112135552.406214090@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul E. McKenney <paulmck@kernel.org>

commit 4d60b475f858ebdb06c1339f01a890f287b5e587 upstream.

The rcu_cpu_starting() and rcu_report_dead() functions transition the
current CPU between online and offline state from an RCU perspective.
Unfortunately, this means that the rcu_cpu_starting() function's lock
acquisition and the rcu_report_dead() function's lock releases happen
while the CPU is offline from an RCU perspective, which can result
in lockdep-RCU splats about using RCU from an offline CPU.  And this
situation can also result in too-short grace periods, especially in
guest OSes that are subject to vCPU preemption.

This commit therefore uses sequence-count-like synchronization to forgive
use of RCU while RCU thinks a CPU is offline across the full extent of
the rcu_cpu_starting() and rcu_report_dead() function's lock acquisitions
and releases.

One approach would have been to use the actual sequence-count primitives
provided by the Linux kernel.  Unfortunately, the resulting code looks
completely broken and wrong, and is likely to result in patches that
break RCU in an attempt to address this appearance of broken wrongness.
Plus there is no net savings in lines of code, given the additional
explicit memory barriers required.

Therefore, this sequence count is instead implemented by a new ->ofl_seq
field in the rcu_node structure.  If this counter's value is an odd
number, RCU forgives RCU read-side critical sections on other CPUs covered
by the same rcu_node structure, even if those CPUs are offline from
an RCU perspective.  In addition, if a given leaf rcu_node structure's
->ofl_seq counter value is an odd number, rcu_gp_init() delays starting
the grace period until that counter value changes.

[ paulmck: Apply Peter Zijlstra feedback. ]
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/rcu/tree.c |   21 ++++++++++++++++++++-
 kernel/rcu/tree.h |    1 +
 2 files changed, 21 insertions(+), 1 deletion(-)

--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -1157,7 +1157,7 @@ bool rcu_lockdep_current_cpu_online(void
 	preempt_disable_notrace();
 	rdp = this_cpu_ptr(&rcu_data);
 	rnp = rdp->mynode;
-	if (rdp->grpmask & rcu_rnp_online_cpus(rnp))
+	if (rdp->grpmask & rcu_rnp_online_cpus(rnp) || READ_ONCE(rnp->ofl_seq) & 0x1)
 		ret = true;
 	preempt_enable_notrace();
 	return ret;
@@ -1724,6 +1724,7 @@ static void rcu_strict_gp_boundary(void
  */
 static bool rcu_gp_init(void)
 {
+	unsigned long firstseq;
 	unsigned long flags;
 	unsigned long oldmask;
 	unsigned long mask;
@@ -1767,6 +1768,12 @@ static bool rcu_gp_init(void)
 	 */
 	rcu_state.gp_state = RCU_GP_ONOFF;
 	rcu_for_each_leaf_node(rnp) {
+		smp_mb(); // Pair with barriers used when updating ->ofl_seq to odd values.
+		firstseq = READ_ONCE(rnp->ofl_seq);
+		if (firstseq & 0x1)
+			while (firstseq == READ_ONCE(rnp->ofl_seq))
+				schedule_timeout_idle(1);  // Can't wake unless RCU is watching.
+		smp_mb(); // Pair with barriers used when updating ->ofl_seq to even values.
 		raw_spin_lock(&rcu_state.ofl_lock);
 		raw_spin_lock_irq_rcu_node(rnp);
 		if (rnp->qsmaskinit == rnp->qsmaskinitnext &&
@@ -4107,6 +4114,9 @@ void rcu_cpu_starting(unsigned int cpu)
 
 	rnp = rdp->mynode;
 	mask = rdp->grpmask;
+	WRITE_ONCE(rnp->ofl_seq, rnp->ofl_seq + 1);
+	WARN_ON_ONCE(!(rnp->ofl_seq & 0x1));
+	smp_mb(); // Pair with rcu_gp_cleanup()'s ->ofl_seq barrier().
 	raw_spin_lock_irqsave_rcu_node(rnp, flags);
 	WRITE_ONCE(rnp->qsmaskinitnext, rnp->qsmaskinitnext | mask);
 	newcpu = !(rnp->expmaskinitnext & mask);
@@ -4124,6 +4134,9 @@ void rcu_cpu_starting(unsigned int cpu)
 	} else {
 		raw_spin_unlock_irqrestore_rcu_node(rnp, flags);
 	}
+	smp_mb(); // Pair with rcu_gp_cleanup()'s ->ofl_seq barrier().
+	WRITE_ONCE(rnp->ofl_seq, rnp->ofl_seq + 1);
+	WARN_ON_ONCE(rnp->ofl_seq & 0x1);
 	smp_mb(); /* Ensure RCU read-side usage follows above initialization. */
 }
 
@@ -4150,6 +4163,9 @@ void rcu_report_dead(unsigned int cpu)
 
 	/* Remove outgoing CPU from mask in the leaf rcu_node structure. */
 	mask = rdp->grpmask;
+	WRITE_ONCE(rnp->ofl_seq, rnp->ofl_seq + 1);
+	WARN_ON_ONCE(!(rnp->ofl_seq & 0x1));
+	smp_mb(); // Pair with rcu_gp_cleanup()'s ->ofl_seq barrier().
 	raw_spin_lock(&rcu_state.ofl_lock);
 	raw_spin_lock_irqsave_rcu_node(rnp, flags); /* Enforce GP memory-order guarantee. */
 	rdp->rcu_ofl_gp_seq = READ_ONCE(rcu_state.gp_seq);
@@ -4162,6 +4178,9 @@ void rcu_report_dead(unsigned int cpu)
 	WRITE_ONCE(rnp->qsmaskinitnext, rnp->qsmaskinitnext & ~mask);
 	raw_spin_unlock_irqrestore_rcu_node(rnp, flags);
 	raw_spin_unlock(&rcu_state.ofl_lock);
+	smp_mb(); // Pair with rcu_gp_cleanup()'s ->ofl_seq barrier().
+	WRITE_ONCE(rnp->ofl_seq, rnp->ofl_seq + 1);
+	WARN_ON_ONCE(rnp->ofl_seq & 0x1);
 
 	rdp->cpu_started = false;
 }
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -56,6 +56,7 @@ struct rcu_node {
 				/*  Initialized from ->qsmaskinitnext at the */
 				/*  beginning of each grace period. */
 	unsigned long qsmaskinitnext;
+	unsigned long ofl_seq;	/* CPU-hotplug operation sequence count. */
 				/* Online CPUs for next grace period. */
 	unsigned long expmask;	/* CPUs or groups that need to check in */
 				/*  to allow the current expedited GP */


