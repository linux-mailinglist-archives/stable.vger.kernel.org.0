Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19E6818A6A2
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 22:09:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727249AbgCRUxm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 16:53:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:52706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727228AbgCRUxl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Mar 2020 16:53:41 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B025208CA;
        Wed, 18 Mar 2020 20:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584564820;
        bh=CP9TqCmkgrHCPPusIn95TMjjPdjHEBSKfNkWw9xBLok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AXVsWULsKPZZYQO6x4M94xtQcmtkWWZWc3KRAarY9MwtyJFHbA7un2oWNSr9Aj0Aq
         8hjVEfpX+kH4z3lzrm16FQYH+mxtnNz62ddPqawrUW03jswmhntGgILRycLjerWujc
         s1F0+vUFyeaUEe283dcwLHFlEBN6ni76b9OcC7eE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Tejun Heo <tj@kernel.org>, Sasha Levin <sashal@kernel.org>,
        cgroups@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 02/73] cgroup: Iterate tasks that did not finish do_exit()
Date:   Wed, 18 Mar 2020 16:52:26 -0400
Message-Id: <20200318205337.16279-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200318205337.16279-1-sashal@kernel.org>
References: <20200318205337.16279-1-sashal@kernel.org>
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
index 3ba3e6da13a6f..57577075d2049 100644
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
index 595c52d59f310..a1236b1b80383 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -4461,12 +4461,16 @@ static void css_task_iter_advance_css_set(struct css_task_iter *it)
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
@@ -4524,10 +4528,14 @@ static void css_task_iter_advance(struct css_task_iter *it)
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
@@ -4546,11 +4554,12 @@ static void css_task_iter_advance(struct css_task_iter *it)
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

