Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FEF318B54D
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:17:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729620AbgCSNRS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:17:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:38384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729355AbgCSNRR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:17:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF4D92098B;
        Thu, 19 Mar 2020 13:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623836;
        bh=0gFlzQXyqjqvTe384NB+HND7LEicV5ORE+ok2fAc4Qo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z3um633u5YrChHfCDkPTUCHq9NpXpCZAsUCOaYNfXwi7nIsDAb4TKlS/3T+EhD2AM
         nLVhgX42zzyB+UICfkbejmqNAAmWkIFo6cLke6fxSrkNHZtr5OVrbuA1K2YSkKOlsq
         hyMT2Acz+rbMuj2QpKcncl6N3p243l9xJgSEos+Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
        =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 4.14 38/99] cgroup: Iterate tasks that did not finish do_exit()
Date:   Thu, 19 Mar 2020 14:03:16 +0100
Message-Id: <20200319123953.345883567@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123941.630731708@linuxfoundation.org>
References: <20200319123941.630731708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Koutný <mkoutny@suse.com>

commit 9c974c77246460fa6a92c18554c3311c8c83c160 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/cgroup.h |    1 +
 kernel/cgroup/cgroup.c |   23 ++++++++++++++++-------
 2 files changed, 17 insertions(+), 7 deletions(-)

--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -61,6 +61,7 @@ struct css_task_iter {
 	struct list_head		*mg_tasks_head;
 	struct list_head		*dying_tasks_head;
 
+	struct list_head		*cur_tasks_head;
 	struct css_set			*cur_cset;
 	struct css_set			*cur_dcset;
 	struct task_struct		*cur_task;
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -4051,12 +4051,16 @@ static void css_task_iter_advance_css_se
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
@@ -4114,10 +4118,14 @@ repeat:
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
@@ -4136,11 +4144,12 @@ repeat:
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


