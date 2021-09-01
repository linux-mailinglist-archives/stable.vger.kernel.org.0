Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93B283FDB7C
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343793AbhIAMlw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:41:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:41872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345026AbhIAMkZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:40:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96E9261185;
        Wed,  1 Sep 2021 12:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499802;
        bh=ZtTSdSlgZki8Oz0hH3QR5Ll8nn8rdGDB8uhJtHholBs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NHzdiYg/B26ZmH1HMam76qQElL5jL8mU8uSCVPPwqH5fYYpfTE/ZwBoQXhC9YyHYW
         veqm31Vfe9JKvKxaqW4cdDWtrSIknLM04P+V/6ZOWhRxZa+2yxzAsk77AoXQTtuzUO
         w1skjvvpwuXsrbmh6pV0zm9j6BQEDctac6L6xJWs=
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
Subject: [PATCH 5.10 091/103] tracepoint: Use rcu get state and cond sync for static call updates
Date:   Wed,  1 Sep 2021 14:28:41 +0200
Message-Id: <20210901122303.604440005@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122300.503008474@linuxfoundation.org>
References: <20210901122300.503008474@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

commit 7b40066c97ec66a44e388f82fcf694987451768f upstream.

State transitions from 1->0->1 and N->2->1 callbacks require RCU
synchronization. Rather than performing the RCU synchronization every
time the state change occurs, which is quite slow when many tracepoints
are registered in batch, instead keep a snapshot of the RCU state on the
most recent transitions which belong to a chain, and conditionally wait
for a grace period on the last transition of the chain if one g.p. has
not elapsed since the last snapshot.

This applies to both RCU and SRCU.

This brings the performance regression caused by commit 231264d6927f
("Fix: tracepoint: static call function vs data state mismatch") back to
what it was originally.

Before this commit:

  # trace-cmd start -e all
  # time trace-cmd start -p nop

  real	0m10.593s
  user	0m0.017s
  sys	0m0.259s

After this commit:

  # trace-cmd start -e all
  # time trace-cmd start -p nop

  real	0m0.878s
  user	0m0.000s
  sys	0m0.103s

Link: https://lkml.kernel.org/r/20210805192954.30688-1-mathieu.desnoyers@efficios.com
Link: https://lore.kernel.org/io-uring/4ebea8f0-58c9-e571-fd30-0ce4f6f09c70@samba.org/

Cc: stable@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Stefan Metzmacher <metze@samba.org>
Fixes: 231264d6927f ("Fix: tracepoint: static call function vs data state mismatch")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/tracepoint.c |   81 +++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 67 insertions(+), 14 deletions(-)

--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -28,6 +28,44 @@ extern tracepoint_ptr_t __stop___tracepo
 DEFINE_SRCU(tracepoint_srcu);
 EXPORT_SYMBOL_GPL(tracepoint_srcu);
 
+enum tp_transition_sync {
+	TP_TRANSITION_SYNC_1_0_1,
+	TP_TRANSITION_SYNC_N_2_1,
+
+	_NR_TP_TRANSITION_SYNC,
+};
+
+struct tp_transition_snapshot {
+	unsigned long rcu;
+	unsigned long srcu;
+	bool ongoing;
+};
+
+/* Protected by tracepoints_mutex */
+static struct tp_transition_snapshot tp_transition_snapshot[_NR_TP_TRANSITION_SYNC];
+
+static void tp_rcu_get_state(enum tp_transition_sync sync)
+{
+	struct tp_transition_snapshot *snapshot = &tp_transition_snapshot[sync];
+
+	/* Keep the latest get_state snapshot. */
+	snapshot->rcu = get_state_synchronize_rcu();
+	snapshot->srcu = start_poll_synchronize_srcu(&tracepoint_srcu);
+	snapshot->ongoing = true;
+}
+
+static void tp_rcu_cond_sync(enum tp_transition_sync sync)
+{
+	struct tp_transition_snapshot *snapshot = &tp_transition_snapshot[sync];
+
+	if (!snapshot->ongoing)
+		return;
+	cond_synchronize_rcu(snapshot->rcu);
+	if (!poll_state_synchronize_srcu(&tracepoint_srcu, snapshot->srcu))
+		synchronize_srcu(&tracepoint_srcu);
+	snapshot->ongoing = false;
+}
+
 /* Set to 1 to enable tracepoint debug output */
 static const int tracepoint_debug;
 
@@ -332,6 +370,11 @@ static int tracepoint_add_func(struct tr
 	 */
 	switch (nr_func_state(tp_funcs)) {
 	case TP_FUNC_1:		/* 0->1 */
+		/*
+		 * Make sure new static func never uses old data after a
+		 * 1->0->1 transition sequence.
+		 */
+		tp_rcu_cond_sync(TP_TRANSITION_SYNC_1_0_1);
 		/* Set static call to first function */
 		tracepoint_update_call(tp, tp_funcs);
 		/* Both iterator and static call handle NULL tp->funcs */
@@ -346,10 +389,15 @@ static int tracepoint_add_func(struct tr
 		 * Requires ordering between RCU assign/dereference and
 		 * static call update/call.
 		 */
-		rcu_assign_pointer(tp->funcs, tp_funcs);
-		break;
+		fallthrough;
 	case TP_FUNC_N:		/* N->N+1 (N>1) */
 		rcu_assign_pointer(tp->funcs, tp_funcs);
+		/*
+		 * Make sure static func never uses incorrect data after a
+		 * N->...->2->1 (N>1) transition sequence.
+		 */
+		if (tp_funcs[0].data != old[0].data)
+			tp_rcu_get_state(TP_TRANSITION_SYNC_N_2_1);
 		break;
 	default:
 		WARN_ON_ONCE(1);
@@ -393,24 +441,23 @@ static int tracepoint_remove_func(struct
 		/* Both iterator and static call handle NULL tp->funcs */
 		rcu_assign_pointer(tp->funcs, NULL);
 		/*
-		 * Make sure new func never uses old data after a 1->0->1
-		 * transition sequence.
-		 * Considering that transition 0->1 is the common case
-		 * and don't have rcu-sync, issue rcu-sync after
-		 * transition 1->0 to break that sequence by waiting for
-		 * readers to be quiescent.
+		 * Make sure new static func never uses old data after a
+		 * 1->0->1 transition sequence.
 		 */
-		tracepoint_synchronize_unregister();
+		tp_rcu_get_state(TP_TRANSITION_SYNC_1_0_1);
 		break;
 	case TP_FUNC_1:		/* 2->1 */
 		rcu_assign_pointer(tp->funcs, tp_funcs);
 		/*
-		 * On 2->1 transition, RCU sync is needed before setting
-		 * static call to first callback, because the observer
-		 * may have loaded any prior tp->funcs after the last one
-		 * associated with an rcu-sync.
+		 * Make sure static func never uses incorrect data after a
+		 * N->...->2->1 (N>2) transition sequence. If the first
+		 * element's data has changed, then force the synchronization
+		 * to prevent current readers that have loaded the old data
+		 * from calling the new function.
 		 */
-		tracepoint_synchronize_unregister();
+		if (tp_funcs[0].data != old[0].data)
+			tp_rcu_get_state(TP_TRANSITION_SYNC_N_2_1);
+		tp_rcu_cond_sync(TP_TRANSITION_SYNC_N_2_1);
 		/* Set static call to first function */
 		tracepoint_update_call(tp, tp_funcs);
 		break;
@@ -418,6 +465,12 @@ static int tracepoint_remove_func(struct
 		fallthrough;
 	case TP_FUNC_N:
 		rcu_assign_pointer(tp->funcs, tp_funcs);
+		/*
+		 * Make sure static func never uses incorrect data after a
+		 * N->...->2->1 (N>2) transition sequence.
+		 */
+		if (tp_funcs[0].data != old[0].data)
+			tp_rcu_get_state(TP_TRANSITION_SYNC_N_2_1);
 		break;
 	default:
 		WARN_ON_ONCE(1);


