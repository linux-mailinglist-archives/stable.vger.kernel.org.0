Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F97D18A447
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 21:53:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726866AbgCRUx0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 16:53:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:52244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726619AbgCRUxZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Mar 2020 16:53:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19E8420775;
        Wed, 18 Mar 2020 20:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584564804;
        bh=/ijMBUVOAd1AwPp1HZkRJKEm3Cv2b9QjgAdRy3XoOeY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M+T+B1dUvfgGjXJwpc4YkCku8kmRRt0hz+yHOBcdB82c/5VtHcum4yXZPOD2HVXlE
         avgHbYgbMv4NApm7hH/7ETShxZIctLWwCQbIrK36ORko5OZE5kHZIGejsmBM6BBljx
         nIZYmIUjFGHCtSVboV91CzIrbnQZYshkzF97gjPg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Tejun Heo <tj@kernel.org>, Sasha Levin <sashal@kernel.org>,
        cgroups@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 02/84] cgroup: Iterate tasks that did not finish do_exit()
Date:   Wed, 18 Mar 2020 16:51:59 -0400
Message-Id: <20200318205321.16066-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200318205321.16066-1-sashal@kernel.org>
References: <20200318205321.16066-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Koutný <mkoutny@suse.com>

[ Upstream commit 9c974c77246460fa6a92c18554c3311c8c83c160 ]

PF_EXITING is set earlier than actual removal from css_set when a task
is exitting. This can confuse cgroup.procs readers who see no PF_EXITING
tasks, however, rmdir is checking against css_set membership so it can
transitionally fail with EBUSY.

Fix this by listing tasks that weren't unlinked from css_set active
lists.
It may happen that other users of the task iterator (without
CSS_TASK_ITER_PROCS) spot a PF_EXITING task before cgroup_exit(). This
is equal to the state before commit c03cd7738a83 ("cgroup: Include dying
leaders with live threads in PROCS iterations") but it may be reviewed
later.

Reported-by: Suren Baghdasaryan <surenb@google.com>
Fixes: c03cd7738a83 ("cgroup: Include dying leaders with live threads in PROCS iterations")
Signed-off-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/cgroup.h |  1 +
 kernel/cgroup/cgroup.c | 23 ++++++++++++++++-------
 2 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index d7ddebd0cdec2..e75d2191226b9 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -62,6 +62,7 @@ struct css_task_iter {
 	struct list_head		*mg_tasks_head;
 	struct list_head		*dying_tasks_head;
 
+	struct list_head		*cur_tasks_head;
 	struct css_set			*cur_cset;
 	struct css_set			*cur_dcset;
 	struct task_struct		*cur_task;
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 30892c4759b49..fb25d56586583 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -4405,12 +4405,16 @@ static void css_task_iter_advance_css_set(struct css_task_iter *it)
 		}
 	} while (!css_set_populated(cset) && list_empty(&cset->dying_tasks));
 
-	if (!list_empty(&cset->tasks))
+	if (!list_empty(&cset->tasks)) {
 		it->task_pos = cset->tasks.next;
-	else if (!list_empty(&cset->mg_tasks))
+		it->cur_tasks_head = &cset->tasks;
+	} else if (!list_empty(&cset->mg_tasks)) {
 		it->task_pos = cset->mg_tasks.next;
-	else
+		it->cur_tasks_head = &cset->mg_tasks;
+	} else {
 		it->task_pos = cset->dying_tasks.next;
+		it->cur_tasks_head = &cset->dying_tasks;
+	}
 
 	it->tasks_head = &cset->tasks;
 	it->mg_tasks_head = &cset->mg_tasks;
@@ -4468,10 +4472,14 @@ static void css_task_iter_advance(struct css_task_iter *it)
 		else
 			it->task_pos = it->task_pos->next;
 
-		if (it->task_pos == it->tasks_head)
+		if (it->task_pos == it->tasks_head) {
 			it->task_pos = it->mg_tasks_head->next;
-		if (it->task_pos == it->mg_tasks_head)
+			it->cur_tasks_head = it->mg_tasks_head;
+		}
+		if (it->task_pos == it->mg_tasks_head) {
 			it->task_pos = it->dying_tasks_head->next;
+			it->cur_tasks_head = it->dying_tasks_head;
+		}
 		if (it->task_pos == it->dying_tasks_head)
 			css_task_iter_advance_css_set(it);
 	} else {
@@ -4490,11 +4498,12 @@ static void css_task_iter_advance(struct css_task_iter *it)
 			goto repeat;
 
 		/* and dying leaders w/o live member threads */
-		if (!atomic_read(&task->signal->live))
+		if (it->cur_tasks_head == it->dying_tasks_head &&
+		    !atomic_read(&task->signal->live))
 			goto repeat;
 	} else {
 		/* skip all dying ones */
-		if (task->flags & PF_EXITING)
+		if (it->cur_tasks_head == it->dying_tasks_head)
 			goto repeat;
 	}
 }
-- 
2.20.1

