Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8A133E8071
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233731AbhHJRtI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:49:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:54474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234999AbhHJRrK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:47:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8CD2661262;
        Tue, 10 Aug 2021 17:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617252;
        bh=VqyELQDY9wdyXwQ/Nv4kX98wfXZIVmc8dfeOcHz8ZJU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y/i92+qCor1HVdXrvztW/fMjL/VphGiuGH/KhoCBD7klhFkXscl+vgDIFLhGS88Wi
         tG6VaS/aWsgwitJnfVFioHaXnjsuoe0uGh30x2WMOEhGNeSfxPSUca8n7aWq8BxpTB
         KC52fn/uR1IGcJsfkYFINYHBL9eP0DWOhKNFhfko=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Stefan Metzmacher <metze@samba.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.10 079/135] tracepoint: Fix static call function vs data state mismatch
Date:   Tue, 10 Aug 2021 19:30:13 +0200
Message-Id: <20210810172958.419985047@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172955.660225700@linuxfoundation.org>
References: <20210810172955.660225700@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

commit 231264d6927f6740af36855a622d0e240be9d94c upstream.

On a 1->0->1 callbacks transition, there is an issue with the new
callback using the old callback's data.

Considering __DO_TRACE_CALL:

        do {                                                            \
                struct tracepoint_func *it_func_ptr;                    \
                void *__data;                                           \
                it_func_ptr =                                           \
                        rcu_dereference_raw((&__tracepoint_##name)->funcs); \
                if (it_func_ptr) {                                      \
                        __data = (it_func_ptr)->data;                   \

----> [ delayed here on one CPU (e.g. vcpu preempted by the host) ]

                        static_call(tp_func_##name)(__data, args);      \
                }                                                       \
        } while (0)

It has loaded the tp->funcs of the old callback, so it will try to use the old
data. This can be fixed by adding a RCU sync anywhere in the 1->0->1
transition chain.

On a N->2->1 transition, we need an rcu-sync because you may have a
sequence of 3->2->1 (or 1->2->1) where the element 0 data is unchanged
between 2->1, but was changed from 3->2 (or from 1->2), which may be
observed by the static call. This can be fixed by adding an
unconditional RCU sync in transition 2->1.

Note, this fixes a correctness issue at the cost of adding a tremendous
performance regression to the disabling of tracepoints.

Before this commit:

  # trace-cmd start -e all
  # time trace-cmd start -p nop

  real	0m0.778s
  user	0m0.000s
  sys	0m0.061s

After this commit:

  # trace-cmd start -e all
  # time trace-cmd start -p nop

  real	0m10.593s
  user	0m0.017s
  sys	0m0.259s

A follow up fix will introduce a more lightweight scheme based on RCU
get_state and cond_sync, that will return the performance back to what it
was. As both this change and the lightweight versions are complex on their
own, for bisecting any issues that this may cause, they are kept as two
separate changes.

Link: https://lkml.kernel.org/r/20210805132717.23813-3-mathieu.desnoyers@efficios.com
Link: https://lore.kernel.org/io-uring/4ebea8f0-58c9-e571-fd30-0ce4f6f09c70@samba.org/

Cc: stable@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Stefan Metzmacher <metze@samba.org>
Fixes: d25e37d89dd2 ("tracepoint: Optimize using static_call()")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/tracepoint.c |  102 +++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 82 insertions(+), 20 deletions(-)

--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -15,6 +15,13 @@
 #include <linux/sched/task.h>
 #include <linux/static_key.h>
 
+enum tp_func_state {
+	TP_FUNC_0,
+	TP_FUNC_1,
+	TP_FUNC_2,
+	TP_FUNC_N,
+};
+
 extern tracepoint_ptr_t __start___tracepoints_ptrs[];
 extern tracepoint_ptr_t __stop___tracepoints_ptrs[];
 
@@ -267,26 +274,29 @@ static void *func_remove(struct tracepoi
 	return old;
 }
 
-static void tracepoint_update_call(struct tracepoint *tp, struct tracepoint_func *tp_funcs, bool sync)
+/*
+ * Count the number of functions (enum tp_func_state) in a tp_funcs array.
+ */
+static enum tp_func_state nr_func_state(const struct tracepoint_func *tp_funcs)
+{
+	if (!tp_funcs)
+		return TP_FUNC_0;
+	if (!tp_funcs[1].func)
+		return TP_FUNC_1;
+	if (!tp_funcs[2].func)
+		return TP_FUNC_2;
+	return TP_FUNC_N;	/* 3 or more */
+}
+
+static void tracepoint_update_call(struct tracepoint *tp, struct tracepoint_func *tp_funcs)
 {
 	void *func = tp->iterator;
 
 	/* Synthetic events do not have static call sites */
 	if (!tp->static_call_key)
 		return;
-
-	if (!tp_funcs[1].func) {
+	if (nr_func_state(tp_funcs) == TP_FUNC_1)
 		func = tp_funcs[0].func;
-		/*
-		 * If going from the iterator back to a single caller,
-		 * we need to synchronize with __DO_TRACE to make sure
-		 * that the data passed to the callback is the one that
-		 * belongs to that callback.
-		 */
-		if (sync)
-			tracepoint_synchronize_unregister();
-	}
-
 	__static_call_update(tp->static_call_key, tp->static_call_tramp, func);
 }
 
@@ -320,9 +330,31 @@ static int tracepoint_add_func(struct tr
 	 * a pointer to it.  This array is referenced by __DO_TRACE from
 	 * include/linux/tracepoint.h using rcu_dereference_sched().
 	 */
-	tracepoint_update_call(tp, tp_funcs, false);
-	rcu_assign_pointer(tp->funcs, tp_funcs);
-	static_key_enable(&tp->key);
+	switch (nr_func_state(tp_funcs)) {
+	case TP_FUNC_1:		/* 0->1 */
+		/* Set static call to first function */
+		tracepoint_update_call(tp, tp_funcs);
+		/* Both iterator and static call handle NULL tp->funcs */
+		rcu_assign_pointer(tp->funcs, tp_funcs);
+		static_key_enable(&tp->key);
+		break;
+	case TP_FUNC_2:		/* 1->2 */
+		/* Set iterator static call */
+		tracepoint_update_call(tp, tp_funcs);
+		/*
+		 * Iterator callback installed before updating tp->funcs.
+		 * Requires ordering between RCU assign/dereference and
+		 * static call update/call.
+		 */
+		rcu_assign_pointer(tp->funcs, tp_funcs);
+		break;
+	case TP_FUNC_N:		/* N->N+1 (N>1) */
+		rcu_assign_pointer(tp->funcs, tp_funcs);
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		break;
+	}
 
 	release_probes(old);
 	return 0;
@@ -349,17 +381,47 @@ static int tracepoint_remove_func(struct
 		/* Failed allocating new tp_funcs, replaced func with stub */
 		return 0;
 
-	if (!tp_funcs) {
+	switch (nr_func_state(tp_funcs)) {
+	case TP_FUNC_0:		/* 1->0 */
 		/* Removed last function */
 		if (tp->unregfunc && static_key_enabled(&tp->key))
 			tp->unregfunc();
 
 		static_key_disable(&tp->key);
+		/* Set iterator static call */
+		tracepoint_update_call(tp, tp_funcs);
+		/* Both iterator and static call handle NULL tp->funcs */
+		rcu_assign_pointer(tp->funcs, NULL);
+		/*
+		 * Make sure new func never uses old data after a 1->0->1
+		 * transition sequence.
+		 * Considering that transition 0->1 is the common case
+		 * and don't have rcu-sync, issue rcu-sync after
+		 * transition 1->0 to break that sequence by waiting for
+		 * readers to be quiescent.
+		 */
+		tracepoint_synchronize_unregister();
+		break;
+	case TP_FUNC_1:		/* 2->1 */
 		rcu_assign_pointer(tp->funcs, tp_funcs);
-	} else {
+		/*
+		 * On 2->1 transition, RCU sync is needed before setting
+		 * static call to first callback, because the observer
+		 * may have loaded any prior tp->funcs after the last one
+		 * associated with an rcu-sync.
+		 */
+		tracepoint_synchronize_unregister();
+		/* Set static call to first function */
+		tracepoint_update_call(tp, tp_funcs);
+		break;
+	case TP_FUNC_2:		/* N->N-1 (N>2) */
+		fallthrough;
+	case TP_FUNC_N:
 		rcu_assign_pointer(tp->funcs, tp_funcs);
-		tracepoint_update_call(tp, tp_funcs,
-				       tp_funcs[0].data != old[0].data);
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		break;
 	}
 	release_probes(old);
 	return 0;


