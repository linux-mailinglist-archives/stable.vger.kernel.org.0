Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A003D869EA
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 21:12:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405194AbfHHTMA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 15:12:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:46272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405523AbfHHTLk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 15:11:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6689214C6;
        Thu,  8 Aug 2019 19:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565291499;
        bh=hKTPgVco64fFZS4H1RKTSfv9q8WWlhmr9XebO6ZIbGc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SrWPd3V5ui4xfdt9iDjRaAeuE+RQhHSBYNZV1vAggz95vyAB4D/D2Pfvv9+ogLlDv
         neTPsrZlSRhbMIWBjLMK1ywNk0UudeUBvQQD0aeLJpQsCTwXgDmhAhp44g//ntGcET
         zgUhYKVqF3R4CsZD5J9cpNNbh2EuabFYKT7P1Fw0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Topi Miettinen <toiwoton@gmail.com>
Subject: [PATCH 4.14 30/33] cgroup: Include dying leaders with live threads in PROCS iterations
Date:   Thu,  8 Aug 2019 21:05:37 +0200
Message-Id: <20190808190455.151177736@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190808190453.582417307@linuxfoundation.org>
References: <20190808190453.582417307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

commit c03cd7738a83b13739f00546166969342c8ff014 upstream.

CSS_TASK_ITER_PROCS currently iterates live group leaders; however,
this means that a process with dying leader and live threads will be
skipped.  IOW, cgroup.procs might be empty while cgroup.threads isn't,
which is confusing to say the least.

Fix it by making cset track dying tasks and include dying leaders with
live threads in PROCS iteration.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-and-tested-by: Topi Miettinen <toiwoton@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/cgroup-defs.h |    1 +
 include/linux/cgroup.h      |    1 +
 kernel/cgroup/cgroup.c      |   44 +++++++++++++++++++++++++++++++++++++-------
 3 files changed, 39 insertions(+), 7 deletions(-)

--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -201,6 +201,7 @@ struct css_set {
 	 */
 	struct list_head tasks;
 	struct list_head mg_tasks;
+	struct list_head dying_tasks;
 
 	/* all css_task_iters currently walking this cset */
 	struct list_head task_iters;
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -59,6 +59,7 @@ struct css_task_iter {
 	struct list_head		*task_pos;
 	struct list_head		*tasks_head;
 	struct list_head		*mg_tasks_head;
+	struct list_head		*dying_tasks_head;
 
 	struct css_set			*cur_cset;
 	struct css_set			*cur_dcset;
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -643,6 +643,7 @@ struct css_set init_css_set = {
 	.dom_cset		= &init_css_set,
 	.tasks			= LIST_HEAD_INIT(init_css_set.tasks),
 	.mg_tasks		= LIST_HEAD_INIT(init_css_set.mg_tasks),
+	.dying_tasks		= LIST_HEAD_INIT(init_css_set.dying_tasks),
 	.task_iters		= LIST_HEAD_INIT(init_css_set.task_iters),
 	.threaded_csets		= LIST_HEAD_INIT(init_css_set.threaded_csets),
 	.cgrp_links		= LIST_HEAD_INIT(init_css_set.cgrp_links),
@@ -1107,6 +1108,7 @@ static struct css_set *find_css_set(stru
 	cset->dom_cset = cset;
 	INIT_LIST_HEAD(&cset->tasks);
 	INIT_LIST_HEAD(&cset->mg_tasks);
+	INIT_LIST_HEAD(&cset->dying_tasks);
 	INIT_LIST_HEAD(&cset->task_iters);
 	INIT_LIST_HEAD(&cset->threaded_csets);
 	INIT_HLIST_NODE(&cset->hlist);
@@ -4046,15 +4048,18 @@ static void css_task_iter_advance_css_se
 			it->task_pos = NULL;
 			return;
 		}
-	} while (!css_set_populated(cset));
+	} while (!css_set_populated(cset) && !list_empty(&cset->dying_tasks));
 
 	if (!list_empty(&cset->tasks))
 		it->task_pos = cset->tasks.next;
-	else
+	else if (!list_empty(&cset->mg_tasks))
 		it->task_pos = cset->mg_tasks.next;
+	else
+		it->task_pos = cset->dying_tasks.next;
 
 	it->tasks_head = &cset->tasks;
 	it->mg_tasks_head = &cset->mg_tasks;
+	it->dying_tasks_head = &cset->dying_tasks;
 
 	/*
 	 * We don't keep css_sets locked across iteration steps and thus
@@ -4093,6 +4098,8 @@ static void css_task_iter_skip(struct cs
 
 static void css_task_iter_advance(struct css_task_iter *it)
 {
+	struct task_struct *task;
+
 	lockdep_assert_held(&css_set_lock);
 repeat:
 	if (it->task_pos) {
@@ -4109,17 +4116,32 @@ repeat:
 		if (it->task_pos == it->tasks_head)
 			it->task_pos = it->mg_tasks_head->next;
 		if (it->task_pos == it->mg_tasks_head)
+			it->task_pos = it->dying_tasks_head->next;
+		if (it->task_pos == it->dying_tasks_head)
 			css_task_iter_advance_css_set(it);
 	} else {
 		/* called from start, proceed to the first cset */
 		css_task_iter_advance_css_set(it);
 	}
 
-	/* if PROCS, skip over tasks which aren't group leaders */
-	if ((it->flags & CSS_TASK_ITER_PROCS) && it->task_pos &&
-	    !thread_group_leader(list_entry(it->task_pos, struct task_struct,
-					    cg_list)))
-		goto repeat;
+	if (!it->task_pos)
+		return;
+
+	task = list_entry(it->task_pos, struct task_struct, cg_list);
+
+	if (it->flags & CSS_TASK_ITER_PROCS) {
+		/* if PROCS, skip over tasks which aren't group leaders */
+		if (!thread_group_leader(task))
+			goto repeat;
+
+		/* and dying leaders w/o live member threads */
+		if (!atomic_read(&task->signal->live))
+			goto repeat;
+	} else {
+		/* skip all dying ones */
+		if (task->flags & PF_EXITING)
+			goto repeat;
+	}
 }
 
 /**
@@ -5552,6 +5574,7 @@ void cgroup_exit(struct task_struct *tsk
 	if (!list_empty(&tsk->cg_list)) {
 		spin_lock_irq(&css_set_lock);
 		css_set_move_task(tsk, cset, NULL, false);
+		list_add_tail(&tsk->cg_list, &cset->dying_tasks);
 		cset->nr_tasks--;
 		spin_unlock_irq(&css_set_lock);
 	} else {
@@ -5572,6 +5595,13 @@ void cgroup_release(struct task_struct *
 	do_each_subsys_mask(ss, ssid, have_release_callback) {
 		ss->release(task);
 	} while_each_subsys_mask();
+
+	if (use_task_css_set_links) {
+		spin_lock_irq(&css_set_lock);
+		css_set_skip_task_iters(task_css_set(task), task);
+		list_del_init(&task->cg_list);
+		spin_unlock_irq(&css_set_lock);
+	}
 }
 
 void cgroup_free(struct task_struct *task)


