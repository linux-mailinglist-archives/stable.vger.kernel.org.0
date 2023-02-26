Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3566A300D
	for <lists+stable@lfdr.de>; Sun, 26 Feb 2023 15:45:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbjBZOp2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 09:45:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbjBZOpZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 09:45:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFB0A12064;
        Sun, 26 Feb 2023 06:45:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6263F60C39;
        Sun, 26 Feb 2023 14:45:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D23B2C433D2;
        Sun, 26 Feb 2023 14:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677422703;
        bh=OSIZOtpJa/QeqoEwsNsyhrUDyWFpAxhYqmgQsfrTDU0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PdyiI6OarWRTni1hwgcVn09HzxxQlEU54Dt4cLnu9QeYjtVHsxuk6MA0qw3J6t/Yv
         HA+DnBtD8KbkjNTKwSql7M+9YaOEUFlvdP+Hm1KjshX/5jlPttUizRLm23/69EX9e9
         Og7v2sXIQHrPT0unzb4AtEZA1/G6nJIDkINhf7YCzJQ0u4Hh6TFaHItRkrfwMbarKw
         wpKLjKIbnIiE1chAWCjosBdPcKuRt8NyMcOg0kmfFQPKnVLX7B0M7Vm5Kg6KJVaIvs
         5T8v/jjzZW8WGNucglCGrKi+Os5r+8cR3nlGz7RNRcwx5lpf7jKt5Yu3mA0PVb1SVR
         DrovlWrXLOjNQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zqiang <qiang1.zhang@intel.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>, frederic@kernel.org,
        quic_neeraju@quicinc.com, josh@joshtriplett.org,
        rcu@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 08/53] rcu-tasks: Handle queue-shrink/callback-enqueue race condition
Date:   Sun, 26 Feb 2023 09:44:00 -0500
Message-Id: <20230226144446.824580-8-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230226144446.824580-1-sashal@kernel.org>
References: <20230226144446.824580-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zqiang <qiang1.zhang@intel.com>

[ Upstream commit a4fcfbee8f6274f9b3f9a71dd5b03e6772ce33f3 ]

The rcu_tasks_need_gpcb() determines whether or not: (1) There are
callbacks needing another grace period, (2) There are callbacks ready
to be invoked, and (3) It would be a good time to shrink back down to a
single-CPU callback list.  This third case is interesting because some
other CPU might be adding new callbacks, which might suddenly make this
a very bad time to be shrinking.

This is currently handled by requiring call_rcu_tasks_generic() to
enqueue callbacks under the protection of rcu_read_lock() and requiring
rcu_tasks_need_gpcb() to wait for an RCU grace period to elapse before
finalizing the transition.  This works well in practice.

Unfortunately, the current code assumes that a grace period whose end is
detected by the poll_state_synchronize_rcu() in the second "if" condition
actually ended before the earlier code counted the callbacks queued on
CPUs other than CPU 0 (local variable "ncbsnz").  Given the current code,
it is possible that a long-delayed call_rcu_tasks_generic() invocation
will queue a callback on a non-zero CPU after these CPUs have had their
callbacks counted and zero has been stored to ncbsnz.  Such a callback
would trigger the WARN_ON_ONCE() in the second "if" statement.

To see this, consider the following sequence of events:

o	CPU 0 invokes rcu_tasks_one_gp(), and counts fewer than
	rcu_task_collapse_lim callbacks.  It sees at least one
	callback queued on some other CPU, thus setting ncbsnz
	to a non-zero value.

o	CPU 1 invokes call_rcu_tasks_generic() and loads 42 from
	->percpu_enqueue_lim.  It therefore decides to enqueue its
	callback onto CPU 1's callback list, but is delayed.

o	CPU 0 sees the rcu_task_cb_adjust is non-zero and that the number
	of callbacks does not exceed rcu_task_collapse_lim.  It therefore
	checks percpu_enqueue_lim, and sees that its value is greater
	than the value one.  CPU 0 therefore  starts the shift back
	to a single callback list.  It sets ->percpu_enqueue_lim to 1,
	but CPU 1 has already read the old value of 42.  It also gets
	a grace-period state value from get_state_synchronize_rcu().

o	CPU 0 sees that ncbsnz is non-zero in its second "if" statement,
	so it declines to finalize the shrink operation.

o	CPU 0 again invokes rcu_tasks_one_gp(), and counts fewer than
	rcu_task_collapse_lim callbacks.  It also sees that there are
	no callback queued on any other CPU, and thus sets ncbsnz to zero.

o	CPU 1 resumes execution and enqueues its callback onto its own
	list.  This invalidates the value of ncbsnz.

o	CPU 0 sees the rcu_task_cb_adjust is non-zero and that the number
	of callbacks does not exceed rcu_task_collapse_lim.  It therefore
	checks percpu_enqueue_lim, but sees that its value is already
	unity.	It therefore does not get a new grace-period state value.

o	CPU 0 sees that rcu_task_cb_adjust is non-zero, ncbsnz is zero,
	and that poll_state_synchronize_rcu() says that the grace period
	has completed.  it therefore finalizes the shrink operation,
	setting ->percpu_dequeue_lim to the value one.

o	CPU 0 does a debug check, scanning the other CPUs' callback lists.
	It sees that CPU 1's list has a callback, so it (rightly)
	triggers the WARN_ON_ONCE().  After all, the new value of
	->percpu_dequeue_lim says to not bother looking at CPU 1's
	callback list, which means that this callback will never be
	invoked.  This can result in hangs and maybe even OOMs.

Based on long experience with rcutorture, this is an extremely
low-probability race condition, but it really can happen, especially in
preemptible kernels or within guest OSes.

This commit therefore checks for completion of the grace period
before counting callbacks.  With this change, in the above failure
scenario CPU 0 would know not to prematurely end the shrink operation
because the grace period would not have completed before the count
operation started.

[ paulmck: Adjust grace-period end rather than adding RCU reader. ]
[ paulmck: Avoid spurious WARN_ON_ONCE() with ->percpu_dequeue_lim check. ]

Signed-off-by: Zqiang <qiang1.zhang@intel.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tasks.h | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/kernel/rcu/tasks.h b/kernel/rcu/tasks.h
index 1aec68dd18aae..83f239926b35e 100644
--- a/kernel/rcu/tasks.h
+++ b/kernel/rcu/tasks.h
@@ -384,6 +384,7 @@ static int rcu_tasks_need_gpcb(struct rcu_tasks *rtp)
 {
 	int cpu;
 	unsigned long flags;
+	bool gpdone = poll_state_synchronize_rcu(rtp->percpu_dequeue_gpseq);
 	long n;
 	long ncbs = 0;
 	long ncbsnz = 0;
@@ -425,21 +426,23 @@ static int rcu_tasks_need_gpcb(struct rcu_tasks *rtp)
 			WRITE_ONCE(rtp->percpu_enqueue_shift, order_base_2(nr_cpu_ids));
 			smp_store_release(&rtp->percpu_enqueue_lim, 1);
 			rtp->percpu_dequeue_gpseq = get_state_synchronize_rcu();
+			gpdone = false;
 			pr_info("Starting switch %s to CPU-0 callback queuing.\n", rtp->name);
 		}
 		raw_spin_unlock_irqrestore(&rtp->cbs_gbl_lock, flags);
 	}
-	if (rcu_task_cb_adjust && !ncbsnz &&
-	    poll_state_synchronize_rcu(rtp->percpu_dequeue_gpseq)) {
+	if (rcu_task_cb_adjust && !ncbsnz && gpdone) {
 		raw_spin_lock_irqsave(&rtp->cbs_gbl_lock, flags);
 		if (rtp->percpu_enqueue_lim < rtp->percpu_dequeue_lim) {
 			WRITE_ONCE(rtp->percpu_dequeue_lim, 1);
 			pr_info("Completing switch %s to CPU-0 callback queuing.\n", rtp->name);
 		}
-		for (cpu = rtp->percpu_dequeue_lim; cpu < nr_cpu_ids; cpu++) {
-			struct rcu_tasks_percpu *rtpcp = per_cpu_ptr(rtp->rtpcpu, cpu);
+		if (rtp->percpu_dequeue_lim == 1) {
+			for (cpu = rtp->percpu_dequeue_lim; cpu < nr_cpu_ids; cpu++) {
+				struct rcu_tasks_percpu *rtpcp = per_cpu_ptr(rtp->rtpcpu, cpu);
 
-			WARN_ON_ONCE(rcu_segcblist_n_cbs(&rtpcp->cblist));
+				WARN_ON_ONCE(rcu_segcblist_n_cbs(&rtpcp->cblist));
+			}
 		}
 		raw_spin_unlock_irqrestore(&rtp->cbs_gbl_lock, flags);
 	}
-- 
2.39.0

