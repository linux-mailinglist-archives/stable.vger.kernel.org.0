Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 573203E15A5
	for <lists+stable@lfdr.de>; Thu,  5 Aug 2021 15:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240788AbhHEN1j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Aug 2021 09:27:39 -0400
Received: from mail.efficios.com ([167.114.26.124]:35318 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240828AbhHEN1i (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Aug 2021 09:27:38 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 0C96E3704E5;
        Thu,  5 Aug 2021 09:27:24 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id cTE0Rx0y_HjL; Thu,  5 Aug 2021 09:27:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 7E4D23704E4;
        Thu,  5 Aug 2021 09:27:23 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 7E4D23704E4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1628170043;
        bh=QFj8CTVMaz2svDfhD0vZPskJeGdxtXCMZlexhxU6xzA=;
        h=From:To:Date:Message-Id;
        b=VhuV4GEm3AE9mxOHH7HF4Eg3RADwjW6X7onsUA4oq5X4kBCt8YSyq+J3J67K4NjSC
         7WRKwMS+ghy47B8flzQxppGM7Tj+SRn7qVdjtfUrP3Y+GYLZ9TUcNB7L5I/EkMkvEj
         QrsM8HXJ6q2WNOM+6pNfJ6cvKm6kOg81x7YqBHUuqZ4b4m4/v91vInsSVVCYlTDkI3
         h/s/ZFzlzGi15lMf5MH9XGEMDFftXGwEd/7t5Ni5YC+jyJdETz6+bI4pO+7dmC0OQ6
         ziy2Da+YaVcWbNCf/5lIjlkR51A2Irl0c/NTktXScDZoKhGqzAF3ubUasUZ/qPRzCK
         roe1G9bfZOWsw==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 5pWjy_lLkj0m; Thu,  5 Aug 2021 09:27:23 -0400 (EDT)
Received: from localhost.localdomain (173-246-27-5.qc.cable.ebox.net [173.246.27.5])
        by mail.efficios.com (Postfix) with ESMTPSA id 0782037054B;
        Thu,  5 Aug 2021 09:27:23 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Stefan Metzmacher <metze@samba.org>, stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH 2/3] Fix: tracepoint: static call function vs data state mismatch (v2)
Date:   Thu,  5 Aug 2021 09:27:16 -0400
Message-Id: <20210805132717.23813-3-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210805132717.23813-1-mathieu.desnoyers@efficios.com>
References: <20210805132717.23813-1-mathieu.desnoyers@efficios.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

A follow up fix will introduce a more lightweight scheme based on RCU
get_state and cond_sync.

Link: https://lore.kernel.org/io-uring/4ebea8f0-58c9-e571-fd30-0ce4f6f09c70@samba.org/
Fixes: d25e37d89dd2 ("tracepoint: Optimize using static_call()")
Fixes: 547305a64632 ("tracepoint: Fix out of sync data passing by static caller")
Fixes: 352384d5c84e ("tracepoints: Update static_call before tp_funcs when adding a tracepoint")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Stefan Metzmacher <metze@samba.org>
Cc: <stable@vger.kernel.org> # 5.10+
---
Changes since v1:
- Add missing TP_FUNC_2 fallthrough to TP_FUNC_N in
  tracepoint_remove_func. This handles the missing transition from 3->2
  probes.
---
 kernel/tracepoint.c | 102 +++++++++++++++++++++++++++++++++++---------
 1 file changed, 82 insertions(+), 20 deletions(-)

diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index 133b6454b287..8d772bd6894d 100644
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
 
@@ -246,26 +253,29 @@ static void *func_remove(struct tracepoint_func **funcs,
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
 
@@ -299,9 +309,31 @@ static int tracepoint_add_func(struct tracepoint *tp,
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
@@ -328,17 +360,47 @@ static int tracepoint_remove_func(struct tracepoint *tp,
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
-- 
2.17.1

