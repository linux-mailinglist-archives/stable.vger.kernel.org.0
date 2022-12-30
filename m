Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA1876599B9
	for <lists+stable@lfdr.de>; Fri, 30 Dec 2022 16:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235018AbiL3Pcj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Dec 2022 10:32:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbiL3Pci (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Dec 2022 10:32:38 -0500
Received: from mail-vs1-xe2a.google.com (mail-vs1-xe2a.google.com [IPv6:2607:f8b0:4864:20::e2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A65355B3
        for <stable@vger.kernel.org>; Fri, 30 Dec 2022 07:32:37 -0800 (PST)
Received: by mail-vs1-xe2a.google.com with SMTP id p30so15960018vsr.1
        for <stable@vger.kernel.org>; Fri, 30 Dec 2022 07:32:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f9CTSN/sMpQvJw4AMVj0+6rBFZ/obq4voGPkfdqn1X8=;
        b=MibP40V7gf40s5S3WXQyqQXw6ZdilFQ4CB6GPH9nqjE0t5NYa4H0NJA03MNQD2+wc2
         jxoRLn9PeCGSOToSDaQjZemvh/wBx1iSdaplGIslNS+43UzkXb9iCBThTpr/bkTWRGw5
         4C5tq5KofRfYEbw+dWJArwzSMUI0RKV4/YNCY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f9CTSN/sMpQvJw4AMVj0+6rBFZ/obq4voGPkfdqn1X8=;
        b=ie11YD1o4zHnQ7bHm5c94N/cwxiXgzKEktk8VT9zeNiGtAvdX+zbM2JZSVlOo7FKHS
         zL3IqI/mK+bS62N3gPvDs/gBnMn+8C2CyVLXKORuiviPBJMnshWMqQQ8MWE2VYfg6m9X
         myvnaU0Mh7ZOu/aK5yiSdOEkh5p/Mq80prlAEV6tENhIs6TjGU6Ks1c/3AL+Pk5bM7VL
         XXUi9zpfpr4lolaHLlfPsoZ6emMVBjvkiWCVuEysTwdRnwd9KABx9Shor4JR0yjoP0mB
         0W588vBMDxEJkREX7NBdYzF9eEVwhfjLZyphlRL5LlsrH/VoGxVCQDgtm97wizKM+Pcx
         bsvg==
X-Gm-Message-State: AFqh2koIH1etwmDRm6TO5aCD7MmdhhOT5BQd+x+JIHRnOSRWQF0aobw0
        UfV0HiciHZC0qDROqy150pLpUC55OzmLqBgnBfc=
X-Google-Smtp-Source: AMrXdXtwuIZ9/yXlJQNDrzMVB6ENDODzPcmS1xI8EEdV5d1dTWctS1Eg5strGrK1x6iHWnSUTmtvVQ==
X-Received: by 2002:a05:6102:a2a:b0:3cb:12be:14f2 with SMTP id 10-20020a0561020a2a00b003cb12be14f2mr3952701vsb.31.1672414354724;
        Fri, 30 Dec 2022 07:32:34 -0800 (PST)
Received: from joelboxx.c.googlers.com.com (228.221.150.34.bc.googleusercontent.com. [34.150.221.228])
        by smtp.gmail.com with ESMTPSA id w29-20020a05620a0e9d00b006ec62032d3dsm15177813qkm.30.2022.12.30.07.32.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Dec 2022 07:32:33 -0800 (PST)
From:   "Joel Fernandes (Google)" <joel@joelfernandes.org>
To:     stable@vger.kernel.org
Cc:     "Paul E. McKenney" <paulmck@kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>, rcu@vger.kernel.org
Subject: [PATCH v5.10 2/2] rcu: Prevent lockdep-RCU splats on lock acquisition/release
Date:   Fri, 30 Dec 2022 15:32:14 +0000
Message-Id: <20221230153215.1333921-2-joel@joelfernandes.org>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
In-Reply-To: <20221230153215.1333921-1-joel@joelfernandes.org>
References: <20221230153215.1333921-1-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Paul E. McKenney" <paulmck@kernel.org>

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
Cc: <stable@vger.kernel.org> # 5.10.x
Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
---
 kernel/rcu/tree.c | 21 ++++++++++++++++++++-
 kernel/rcu/tree.h |  1 +
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 3fe7c75c371b..9cce4e13af41 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -1157,7 +1157,7 @@ bool rcu_lockdep_current_cpu_online(void)
 	preempt_disable_notrace();
 	rdp = this_cpu_ptr(&rcu_data);
 	rnp = rdp->mynode;
-	if (rdp->grpmask & rcu_rnp_online_cpus(rnp))
+	if (rdp->grpmask & rcu_rnp_online_cpus(rnp) || READ_ONCE(rnp->ofl_seq) & 0x1)
 		ret = true;
 	preempt_enable_notrace();
 	return ret;
@@ -1724,6 +1724,7 @@ static void rcu_strict_gp_boundary(void *unused)
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
diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
index e4f66b8f7c47..6e8c77729a47 100644
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
-- 
2.39.0.314.g84b9a713c41-goog

