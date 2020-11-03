Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA7FC2A586A
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:52:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731684AbgKCVvI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:51:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:40104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730199AbgKCUsa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:48:30 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 863A7223FD;
        Tue,  3 Nov 2020 20:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436510;
        bh=gKeQlPlU2BL6oNOlRUoiQnJGawgTLyrqz/iDEHV+cTE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hfJDTMtGW23v7LQSDvL5qP7MSbgzaHtQKFkE/qRl0hOSrr5xA0VIJADy8bXw9Mpxm
         IIR6M9qhd0INxpEb9ZhOw4YF6bupgL9GFGocF6tpql+Z4wlDt9KdCRaVKpKIPtMSZm
         vXpcSnhPBUVOs8Vu4UBPvIkIQq85RNg3OGM/BPx8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Olsa <jolsa@redhat.com>, bpf@vger.kernel.org,
        "Paul E. McKenney" <paulmck@kernel.org>
Subject: [PATCH 5.9 281/391] rcu-tasks: Fix low-probability task_struct leak
Date:   Tue,  3 Nov 2020 21:35:32 +0100
Message-Id: <20201103203405.996797510@linuxfoundation.org>
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

commit 592031cc10858be4adb10f6c0f2608f6f21824aa upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/rcu/tasks.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/kernel/rcu/tasks.h
+++ b/kernel/rcu/tasks.h
@@ -1082,11 +1082,11 @@ static void rcu_tasks_trace_postgp(struc
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


