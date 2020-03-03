Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5F46177F85
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 19:58:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731960AbgCCRvS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:51:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:59170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731954AbgCCRvL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:51:11 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3206A206E6;
        Tue,  3 Mar 2020 17:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583257870;
        bh=q9ncxq94EGXOCTEZx6k1DLyeoq/IGMKBwAr6s2YL1N4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BEVK7XmhJ6SQzHWNakpBqOC25AIBo+XdQygMK9eXVPg9d4EvunRR7TRPTN197Lfit
         vn+6u9LG8bmX8/JvcsZ/USXkviohNnXkEi+IzPoPEfptF+ygSiydiMKL9NA12gsTJg
         YpWOb/ksT8jh5WYDA3qp+5aUBj+s9oKEPqmVHMDc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Neeraj Upadhyay <neeraju@codeaurora.org>,
        "Paul E. McKenney" <paulmck@kernel.org>
Subject: [PATCH 5.5 160/176] rcu: Allow only one expedited GP to run concurrently with wakeups
Date:   Tue,  3 Mar 2020 18:43:44 +0100
Message-Id: <20200303174322.832178830@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174304.593872177@linuxfoundation.org>
References: <20200303174304.593872177@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Neeraj Upadhyay <neeraju@codeaurora.org>

commit 4bc6b745e5cbefed92c48071e28a5f41246d0470 upstream.

The current expedited RCU grace-period code expects that a task
requesting an expedited grace period cannot awaken until that grace
period has reached the wakeup phase.  However, it is possible for a long
preemption to result in the waiting task never sleeping.  For example,
consider the following sequence of events:

1.	Task A starts an expedited grace period by invoking
	synchronize_rcu_expedited().  It proceeds normally up to the
	wait_event() near the end of that function, and is then preempted
	(or interrupted or whatever).

2.	The expedited grace period completes, and a kworker task starts
	the awaken phase, having incremented the counter and acquired
	the rcu_state structure's .exp_wake_mutex.  This kworker task
	is then preempted or interrupted or whatever.

3.	Task A resumes and enters wait_event(), which notes that the
	expedited grace period has completed, and thus doesn't sleep.

4.	Task B starts an expedited grace period exactly as did Task A,
	complete with the preemption (or whatever delay) just before
	the call to wait_event().

5.	The expedited grace period completes, and another kworker
	task starts the awaken phase, having incremented the counter.
	However, it blocks when attempting to acquire the rcu_state
	structure's .exp_wake_mutex because step 2's kworker task has
	not yet released it.

6.	Steps 4 and 5 repeat, resulting in overflow of the rcu_node
	structure's ->exp_wq[] array.

In theory, this is harmless.  Tasks waiting on the various ->exp_wq[]
array will just be spuriously awakened, but they will just sleep again
on noting that the rcu_state structure's ->expedited_sequence value has
not advanced far enough.

In practice, this wastes CPU time and is an accident waiting to happen.
This commit therefore moves the rcu_exp_gp_seq_end() call that officially
ends the expedited grace period (along with associate tracing) until
after the ->exp_wake_mutex has been acquired.  This prevents Task A from
awakening prematurely, thus preventing more than one expedited grace
period from being in flight during a previous expedited grace period's
wakeup phase.

Fixes: 3b5f668e715b ("rcu: Overlap wakeups with next expedited grace period")
Signed-off-by: Neeraj Upadhyay <neeraju@codeaurora.org>
[ paulmck: Added updated comment. ]
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/rcu/tree_exp.h |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/kernel/rcu/tree_exp.h
+++ b/kernel/rcu/tree_exp.h
@@ -540,14 +540,13 @@ static void rcu_exp_wait_wake(unsigned l
 	struct rcu_node *rnp;
 
 	synchronize_sched_expedited_wait();
-	rcu_exp_gp_seq_end();
-	trace_rcu_exp_grace_period(rcu_state.name, s, TPS("end"));
 
-	/*
-	 * Switch over to wakeup mode, allowing the next GP, but -only- the
-	 * next GP, to proceed.
-	 */
+	// Switch over to wakeup mode, allowing the next GP to proceed.
+	// End the previous grace period only after acquiring the mutex
+	// to ensure that only one GP runs concurrently with wakeups.
 	mutex_lock(&rcu_state.exp_wake_mutex);
+	rcu_exp_gp_seq_end();
+	trace_rcu_exp_grace_period(rcu_state.name, s, TPS("end"));
 
 	rcu_for_each_node_breadth_first(rnp) {
 		if (ULONG_CMP_LT(READ_ONCE(rnp->exp_seq_rq), s)) {


