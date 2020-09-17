Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E31326E720
	for <lists+stable@lfdr.de>; Thu, 17 Sep 2020 23:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbgIQVHw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 17:07:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:45518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726739AbgIQVHt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 17:07:49 -0400
Received: from paulmck-ThinkPad-P72.home (unknown [50.45.173.55])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E429E235F7;
        Thu, 17 Sep 2020 21:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600376869;
        bh=fbo5hHOzAyJO2AHNabv76vHNoNm0Fsocg9ueEelOuuM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ke+AYRFUnFQtFJj49ROFc57x36pfAHvz6oj17TVvhABREtisen69OCqHvYXH4ej1Q
         dXDesA7UW4MJFtEbUnA+F1xkSVgtIrAVUQSO8j0eo5b6UCTSTn4ehtkEGox3s8D0W8
         8qqTuIGJrfNA+0aeIY/v/cCEEyjqSUo4rSR62R/s=
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
Subject: [PATCH tip/core/rcu 8/8] rcu-tasks: Enclose task-list scan in rcu_read_lock()
Date:   Thu, 17 Sep 2020 14:07:44 -0700
Message-Id: <20200917210744.2995-8-paulmck@kernel.org>
X-Mailer: git-send-email 2.9.5
In-Reply-To: <20200917210652.GA31242@paulmck-ThinkPad-P72>
References: <20200917210652.GA31242@paulmck-ThinkPad-P72>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Paul E. McKenney" <paulmck@kernel.org>

The rcu_tasks_trace_postgp() function uses for_each_process_thread()
to scan the task list without the benefit of RCU read-side protection,
which can result in use-after-free errors on task_struct structures.
This error was missed because the TRACE01 rcutorture scenario enables
lockdep, but also builds with CONFIG_PREEMPT_NONE=y.  In this situation,
preemption is disabled everywhere, so lockdep thinks everywhere can
be a legitimate RCU reader.  This commit therefore adds the needed
rcu_read_lock() and rcu_read_unlock().

Note that this bug can occur only after an RCU Tasks Trace CPU stall
warning, which by default only happens after a grace period has extended
for ten minutes (yes, not a typo, minutes).

Fixes: 4593e772b502 ("rcu-tasks: Add stall warnings for RCU Tasks Trace")
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: <bpf@vger.kernel.org>
Cc: <stable@vger.kernel.org> # 5.7.x
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
---
 kernel/rcu/tasks.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/rcu/tasks.h b/kernel/rcu/tasks.h
index fcd9c25..d5d9f2d 100644
--- a/kernel/rcu/tasks.h
+++ b/kernel/rcu/tasks.h
@@ -1088,9 +1088,11 @@ static void rcu_tasks_trace_postgp(struct rcu_tasks *rtp)
 		if (ret)
 			break;  // Count reached zero.
 		// Stall warning time, so make a list of the offenders.
+		rcu_read_lock();
 		for_each_process_thread(g, t)
 			if (READ_ONCE(t->trc_reader_special.b.need_qs))
 				trc_add_holdout(t, &holdouts);
+		rcu_read_unlock();
 		firstreport = true;
 		list_for_each_entry_safe(t, g, &holdouts, trc_holdout_list) {
 			if (READ_ONCE(t->trc_reader_special.b.need_qs))
-- 
2.9.5

