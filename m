Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE6DE26E72A
	for <lists+stable@lfdr.de>; Thu, 17 Sep 2020 23:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbgIQVIR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 17:08:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:45610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726729AbgIQVHt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 17:07:49 -0400
Received: from paulmck-ThinkPad-P72.home (unknown [50.45.173.55])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6FF2423447;
        Thu, 17 Sep 2020 21:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600376868;
        bh=ZY2LyvjU7wixM4PMHpWWQ8GltjXVaTMrDxcrG1Mcbc8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j2vqme/DMz88y46udAi42iiKj7i5/M4ZpHEiidzTM6ausTh6Ql1nuR9iaEcv+1Q1W
         WB9OzK+XzxON/5YXUcRqJUBElV1bQPkXsLB/LlGE2RrKcettHfJwU6CZUA45XxBqSR
         dtuFAvAqJW+22Iuz8a8EjSr1djcB+SPO4zwzDVok=
From:   paulmck@kernel.org
To:     rcu@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, kernel-team@fb.com, mingo@kernel.org,
        jiangshanlai@gmail.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        fweisbec@gmail.com, oleg@redhat.com, joel@joelfernandes.org,
        sfr@canb.auug.org.au, "Paul E. McKenney" <paulmck@kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Olsa <jolsa@redhat.com>, bpf@vger.kernel.org,
        "# 5 . 7 . x" <stable@vger.kernel.org>
Subject: [PATCH tip/core/rcu 6/8] rcu-tasks: Fix grace-period/unlock race in RCU Tasks Trace
Date:   Thu, 17 Sep 2020 14:07:42 -0700
Message-Id: <20200917210744.2995-6-paulmck@kernel.org>
X-Mailer: git-send-email 2.9.5
In-Reply-To: <20200917210652.GA31242@paulmck-ThinkPad-P72>
References: <20200917210652.GA31242@paulmck-ThinkPad-P72>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Paul E. McKenney" <paulmck@kernel.org>

The more intense grace-period processing resulting from the 50x RCU
Tasks Trace grace-period speedups exposed the following race condition:

o	Task A running on CPU 0 executes rcu_read_lock_trace(),
	entering a read-side critical section.

o	When Task A eventually invokes rcu_read_unlock_trace()
	to exit its read-side critical section, this function
	notes that the ->trc_reader_special.s flag is zero and
	and therefore invoke wil set ->trc_reader_nesting to zero
	using WRITE_ONCE().  But before that happens...

o	The RCU Tasks Trace grace-period kthread running on some other
	CPU interrogates Task A, but this fails because this task is
	currently running.  This kthread therefore sends an IPI to CPU 0.

o	CPU 0 receives the IPI, and thus invokes trc_read_check_handler().
	Because Task A has not yet cleared its ->trc_reader_nesting
	counter, this function sees that Task A is still within its
	read-side critical section.  This function therefore sets the
	->trc_reader_nesting.b.need_qs flag, AKA the .need_qs flag.

	Except that Task A has already checked the .need_qs flag, which
	is part of the ->trc_reader_special.s flag.  The .need_qs flag
	therefore remains set until Task A's next rcu_read_unlock_trace().

o	Task A now invokes synchronize_rcu_tasks_trace(), which cannot
	start a new grace period until the current grace period completes.
	And thus cannot return until after that time.

	But Task A's .need_qs flag is still set, which prevents the current
	grace period from completing.  And because Task A is blocked, it
	will never execute rcu_read_unlock_trace() until its call to
	synchronize_rcu_tasks_trace() returns.

	We are therefore deadlocked.

This race is improbable, but 80 hours of rcutorture made it happen twice.
The race was possible before the grace-period speedup, but roughly 50x
less probable.  Several thousand hours of rcutorture would have been
necessary to have a reasonable chance of making this happen before this
50x speedup.

This commit therefore eliminates this deadlock by setting
->trc_reader_nesting to a large negative number before checking the
.need_qs and zeroing (or decrementing with respect to its initial
value) ->trc_reader_nesting.  For its part, the IPI handler's
trc_read_check_handler() function adds a check for negative values,
deferring evaluation of the task in this case.  Taken together, these
changes avoid this deadlock scenario.

Fixes: 276c410448db ("rcu-tasks: Split ->trc_reader_need_end")
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: <bpf@vger.kernel.org>
Cc: <stable@vger.kernel.org> # 5.7.x
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
---
 include/linux/rcupdate_trace.h | 4 ++++
 kernel/rcu/tasks.h             | 6 ++++++
 2 files changed, 10 insertions(+)

diff --git a/include/linux/rcupdate_trace.h b/include/linux/rcupdate_trace.h
index d9015aa..a6a6a3a 100644
--- a/include/linux/rcupdate_trace.h
+++ b/include/linux/rcupdate_trace.h
@@ -50,6 +50,7 @@ static inline void rcu_read_lock_trace(void)
 	struct task_struct *t = current;
 
 	WRITE_ONCE(t->trc_reader_nesting, READ_ONCE(t->trc_reader_nesting) + 1);
+	barrier();
 	if (IS_ENABLED(CONFIG_TASKS_TRACE_RCU_READ_MB) &&
 	    t->trc_reader_special.b.need_mb)
 		smp_mb(); // Pairs with update-side barriers
@@ -72,6 +73,9 @@ static inline void rcu_read_unlock_trace(void)
 
 	rcu_lock_release(&rcu_trace_lock_map);
 	nesting = READ_ONCE(t->trc_reader_nesting) - 1;
+	barrier(); // Critical section before disabling.
+	// Disable IPI-based setting of .need_qs.
+	WRITE_ONCE(t->trc_reader_nesting, INT_MIN);
 	if (likely(!READ_ONCE(t->trc_reader_special.s)) || nesting) {
 		WRITE_ONCE(t->trc_reader_nesting, nesting);
 		return;  // We assume shallow reader nesting.
diff --git a/kernel/rcu/tasks.h b/kernel/rcu/tasks.h
index a0eaed5..e583a2d 100644
--- a/kernel/rcu/tasks.h
+++ b/kernel/rcu/tasks.h
@@ -830,6 +830,12 @@ static void trc_read_check_handler(void *t_in)
 		WRITE_ONCE(t->trc_reader_checked, true);
 		goto reset_ipi;
 	}
+	// If we are racing with an rcu_read_unlock_trace(), try again later.
+	if (unlikely(t->trc_reader_nesting < 0)) {
+		if (WARN_ON_ONCE(atomic_dec_and_test(&trc_n_readers_need_end)))
+			wake_up(&trc_wait);
+		goto reset_ipi;
+	}
 	WRITE_ONCE(t->trc_reader_checked, true);
 
 	// Get here if the task is in a read-side critical section.  Set
-- 
2.9.5

