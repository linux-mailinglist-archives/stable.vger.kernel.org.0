Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FDCD2A5242
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:48:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730562AbgKCUsa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:48:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:40006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731483AbgKCUs2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:48:28 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E4AB20719;
        Tue,  3 Nov 2020 20:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436507;
        bh=u9Seep/Tu1jtztVWq+HFXRLLM97VEj/CmNJCs0RsdZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=03KCb9UjnesCjvoeZGT9q9wU9dmTMCCOZ9ukiKBZR8O1tywbncwcjQ5PdFL1Dr0Es
         mE5RPkzLiw52tRICw/VstqwHGaSksVSPu6UkxAZXnCuJTW1uJNF57s5G/NN/Va4oIU
         4XL9jfAyR6r+Xa7AEChVUKFTzOBNZ9D6PDj8SNWI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Olsa <jolsa@redhat.com>, bpf@vger.kernel.org,
        "Paul E. McKenney" <paulmck@kernel.org>
Subject: [PATCH 5.9 280/391] rcu-tasks: Fix grace-period/unlock race in RCU Tasks Trace
Date:   Tue,  3 Nov 2020 21:35:31 +0100
Message-Id: <20201103203405.928522527@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul E. McKenney <paulmck@kernel.org>

commit ba3a86e47232ad9f76160929f33ac9c64e4d0567 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/rcupdate_trace.h |    4 ++++
 kernel/rcu/tasks.h             |    6 ++++++
 2 files changed, 10 insertions(+)

--- a/include/linux/rcupdate_trace.h
+++ b/include/linux/rcupdate_trace.h
@@ -50,6 +50,7 @@ static inline void rcu_read_lock_trace(v
 	struct task_struct *t = current;
 
 	WRITE_ONCE(t->trc_reader_nesting, READ_ONCE(t->trc_reader_nesting) + 1);
+	barrier();
 	if (IS_ENABLED(CONFIG_TASKS_TRACE_RCU_READ_MB) &&
 	    t->trc_reader_special.b.need_mb)
 		smp_mb(); // Pairs with update-side barriers
@@ -72,6 +73,9 @@ static inline void rcu_read_unlock_trace
 
 	rcu_lock_release(&rcu_trace_lock_map);
 	nesting = READ_ONCE(t->trc_reader_nesting) - 1;
+	barrier(); // Critical section before disabling.
+	// Disable IPI-based setting of .need_qs.
+	WRITE_ONCE(t->trc_reader_nesting, INT_MIN);
 	if (likely(!READ_ONCE(t->trc_reader_special.s)) || nesting) {
 		WRITE_ONCE(t->trc_reader_nesting, nesting);
 		return;  // We assume shallow reader nesting.
--- a/kernel/rcu/tasks.h
+++ b/kernel/rcu/tasks.h
@@ -821,6 +821,12 @@ static void trc_read_check_handler(void
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


