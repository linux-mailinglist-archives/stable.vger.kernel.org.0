Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29BC818812B
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:16:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbgCQLKM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:10:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:52926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729062AbgCQLKM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:10:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DFF7020736;
        Tue, 17 Mar 2020 11:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443411;
        bh=ycfJPDGiYsmonPxYJEq1Gn0iYpW73QmP85vc5IF881Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q4MCqA6buYbS948hnzI90Za1OkbHU3kfk/qM7W5k9AJqz5peqVBqor/WVk5XLROjH
         DW2Lvuf1whkfCOKzBuymvLe3FZCPmrrQnbxvC2sxZsVUzPM3uTIYkKEHLuDv1QoYH1
         Z7sROhjAMhjIFQPMK1Bp25j8bKY+QUGBrwhroNVY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
        =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 5.5 074/151] cgroup: Iterate tasks that did not finish do_exit()
Date:   Tue, 17 Mar 2020 11:54:44 +0100
Message-Id: <20200317103331.746779097@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103326.593639086@linuxfoundation.org>
References: <20200317103326.593639086@linuxfoundation.org>
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
@@ -62,6 +62,7 @@ struct css_task_iter {
 	struct list_head		*mg_tasks_head;
 	struct list_head		*dying_tasks_head;
 
+	struct list_head		*cur_tasks_head;
 	struct css_set			*cur_cset;
 	struct css_set			*cur_dcset;
 	struct task_struct		*cur_task;
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -4405,12 +4405,16 @@ static void css_task_iter_advance_css_se
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
@@ -4468,10 +4472,14 @@ repeat:
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
@@ -4490,11 +4498,12 @@ repeat:
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


