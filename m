Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BDDC869DC
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 21:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405521AbfHHTLi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 15:11:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:46220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405519AbfHHTLh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 15:11:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23184208C3;
        Thu,  8 Aug 2019 19:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565291496;
        bh=nK/QWR1Q5YrqwgIC/8cdUrjiGRT2MF5KQwFZ137YDgo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lPdevfBbfN9LeZgrJmZJoI7AKkJCNZla8o80A3iR3ZblXmub8TJz7RjwH4QcPzR0j
         RrEGG4s0O2SFAdCnd9eJR5sjhPiQR4LpGn7tB/nmYpjo3/6wFWpVaKWnJiBY+20pW4
         uvtQjflWHn1jYdPSTwSsmYL1voREJh5fqkxtX9Sg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 4.14 29/33] cgroup: Implement css_task_iter_skip()
Date:   Thu,  8 Aug 2019 21:05:36 +0200
Message-Id: <20190808190455.102830007@linuxfoundation.org>
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

commit b636fd38dc40113f853337a7d2a6885ad23b8811 upstream.

When a task is moved out of a cset, task iterators pointing to the
task are advanced using the normal css_task_iter_advance() call.  This
is fine but we'll be tracking dying tasks on csets and thus moving
tasks from cset->tasks to (to be added) cset->dying_tasks.  When we
remove a task from cset->tasks, if we advance the iterators, they may
move over to the next cset before we had the chance to add the task
back on the dying list, which can allow the task to escape iteration.

This patch separates out skipping from advancing.  Skipping only moves
the affected iterators to the next pointer rather than fully advancing
it and the following advancing will recognize that the cursor has
already been moved forward and do the rest of advancing.  This ensures
that when a task moves from one list to another in its cset, as long
as it moves in the right direction, it's always visible to iteration.

This doesn't cause any visible behavior changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/cgroup.h |    3 ++
 kernel/cgroup/cgroup.c |   60 +++++++++++++++++++++++++++++--------------------
 2 files changed, 39 insertions(+), 24 deletions(-)

--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -42,6 +42,9 @@
 /* walk all threaded css_sets in the domain */
 #define CSS_TASK_ITER_THREADED		(1U << 1)
 
+/* internal flags */
+#define CSS_TASK_ITER_SKIPPED		(1U << 16)
+
 /* a css_task_iter should be treated as an opaque object */
 struct css_task_iter {
 	struct cgroup_subsys		*ss;
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -204,7 +204,8 @@ static struct cftype cgroup_base_files[]
 
 static int cgroup_apply_control(struct cgroup *cgrp);
 static void cgroup_finalize_control(struct cgroup *cgrp, int ret);
-static void css_task_iter_advance(struct css_task_iter *it);
+static void css_task_iter_skip(struct css_task_iter *it,
+			       struct task_struct *task);
 static int cgroup_destroy_locked(struct cgroup *cgrp);
 static struct cgroup_subsys_state *css_create(struct cgroup *cgrp,
 					      struct cgroup_subsys *ss);
@@ -737,6 +738,21 @@ static void css_set_update_populated(str
 		cgroup_update_populated(link->cgrp, populated);
 }
 
+/*
+ * @task is leaving, advance task iterators which are pointing to it so
+ * that they can resume at the next position.  Advancing an iterator might
+ * remove it from the list, use safe walk.  See css_task_iter_skip() for
+ * details.
+ */
+static void css_set_skip_task_iters(struct css_set *cset,
+				    struct task_struct *task)
+{
+	struct css_task_iter *it, *pos;
+
+	list_for_each_entry_safe(it, pos, &cset->task_iters, iters_node)
+		css_task_iter_skip(it, task);
+}
+
 /**
  * css_set_move_task - move a task from one css_set to another
  * @task: task being moved
@@ -762,22 +778,9 @@ static void css_set_move_task(struct tas
 		css_set_update_populated(to_cset, true);
 
 	if (from_cset) {
-		struct css_task_iter *it, *pos;
-
 		WARN_ON_ONCE(list_empty(&task->cg_list));
 
-		/*
-		 * @task is leaving, advance task iterators which are
-		 * pointing to it so that they can resume at the next
-		 * position.  Advancing an iterator might remove it from
-		 * the list, use safe walk.  See css_task_iter_advance*()
-		 * for details.
-		 */
-		list_for_each_entry_safe(it, pos, &from_cset->task_iters,
-					 iters_node)
-			if (it->task_pos == &task->cg_list)
-				css_task_iter_advance(it);
-
+		css_set_skip_task_iters(from_cset, task);
 		list_del_init(&task->cg_list);
 		if (!css_set_populated(from_cset))
 			css_set_update_populated(from_cset, false);
@@ -4077,10 +4080,19 @@ static void css_task_iter_advance_css_se
 	list_add(&it->iters_node, &cset->task_iters);
 }
 
-static void css_task_iter_advance(struct css_task_iter *it)
+static void css_task_iter_skip(struct css_task_iter *it,
+			       struct task_struct *task)
 {
-	struct list_head *next;
+	lockdep_assert_held(&css_set_lock);
+
+	if (it->task_pos == &task->cg_list) {
+		it->task_pos = it->task_pos->next;
+		it->flags |= CSS_TASK_ITER_SKIPPED;
+	}
+}
 
+static void css_task_iter_advance(struct css_task_iter *it)
+{
 	lockdep_assert_held(&css_set_lock);
 repeat:
 	if (it->task_pos) {
@@ -4089,15 +4101,15 @@ repeat:
 		 * consumed first and then ->mg_tasks.  After ->mg_tasks,
 		 * we move onto the next cset.
 		 */
-		next = it->task_pos->next;
-
-		if (next == it->tasks_head)
-			next = it->mg_tasks_head->next;
+		if (it->flags & CSS_TASK_ITER_SKIPPED)
+			it->flags &= ~CSS_TASK_ITER_SKIPPED;
+		else
+			it->task_pos = it->task_pos->next;
 
-		if (next == it->mg_tasks_head)
+		if (it->task_pos == it->tasks_head)
+			it->task_pos = it->mg_tasks_head->next;
+		if (it->task_pos == it->mg_tasks_head)
 			css_task_iter_advance_css_set(it);
-		else
-			it->task_pos = next;
 	} else {
 		/* called from start, proceed to the first cset */
 		css_task_iter_advance_css_set(it);


