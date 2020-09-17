Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A407C26E724
	for <lists+stable@lfdr.de>; Thu, 17 Sep 2020 23:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726790AbgIQVIG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 17:08:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:45486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726736AbgIQVHt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 17:07:49 -0400
Received: from paulmck-ThinkPad-P72.home (unknown [50.45.173.55])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8A4921D7F;
        Thu, 17 Sep 2020 21:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600376868;
        bh=nvT8pKFywazxQhPu3YmSdR1Yxo9oiXNROZJ+19/2Hw4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1vTC2OeSe7Cb1bR7lQ1DcubdqqUOLqwyPWDGikyd87ud0iyRNJEkmxrwfRQIQeRO4
         NEiY/Z7Ku0GyWwJKkYiNRronZRgRRbm2EQjAm0ohZQeSocI58Y2rDmNqR5exen+pW3
         l8xIumEIQbyfWkeAOTMGerKxNC0Q2AAcXjSTEeG4=
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
Subject: [PATCH tip/core/rcu 7/8] rcu-tasks: Fix low-probability task_struct leak
Date:   Thu, 17 Sep 2020 14:07:43 -0700
Message-Id: <20200917210744.2995-7-paulmck@kernel.org>
X-Mailer: git-send-email 2.9.5
In-Reply-To: <20200917210652.GA31242@paulmck-ThinkPad-P72>
References: <20200917210652.GA31242@paulmck-ThinkPad-P72>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Paul E. McKenney" <paulmck@kernel.org>

When rcu_tasks_trace_postgp() function detects an RCU Tasks Trace
CPU stall, it adds all tasks blocking the current grace period to
a list, invoking get_task_struct() on each to prevent them from
being freed while on the list.  It then traverses that list,
printing stall-warning messages for each one that is still blocking
the current grace period and removing it from the list.  The list
removal invokes the matching put_task_struct().

This of course means that in the admittedly unlikely event that some
task executes its outermost rcu_read_unlock_trace() in the meantime, it
won't be removed from the list and put_task_struct() won't be executing,
resulting in a task_struct leak.  This commit therefore makes the list
removal and put_task_struct() unconditional, stopping the leak.

Note further that this bug can occur only after an RCU Tasks Trace CPU
stall warning, which by default only happens after a grace period has
extended for ten minutes (yes, not a typo, minutes).

Fixes: 4593e772b502 ("rcu-tasks: Add stall warnings for RCU Tasks Trace")
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: <bpf@vger.kernel.org>
Cc: <stable@vger.kernel.org> # 5.7.x
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
---
 kernel/rcu/tasks.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/rcu/tasks.h b/kernel/rcu/tasks.h
index e583a2d..fcd9c25 100644
--- a/kernel/rcu/tasks.h
+++ b/kernel/rcu/tasks.h
@@ -1092,11 +1092,11 @@ static void rcu_tasks_trace_postgp(struct rcu_tasks *rtp)
 			if (READ_ONCE(t->trc_reader_special.b.need_qs))
 				trc_add_holdout(t, &holdouts);
 		firstreport = true;
-		list_for_each_entry_safe(t, g, &holdouts, trc_holdout_list)
-			if (READ_ONCE(t->trc_reader_special.b.need_qs)) {
+		list_for_each_entry_safe(t, g, &holdouts, trc_holdout_list) {
+			if (READ_ONCE(t->trc_reader_special.b.need_qs))
 				show_stalled_task_trace(t, &firstreport);
-				trc_del_holdout(t);
-			}
+			trc_del_holdout(t); // Release task_struct reference.
+		}
 		if (firstreport)
 			pr_err("INFO: rcu_tasks_trace detected stalls? (Counter/taskslist mismatch?)\n");
 		show_stalled_ipi_trace();
-- 
2.9.5

