Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39F8165BBEE
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 09:18:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237045AbjACIRV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 03:17:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237073AbjACIRA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 03:17:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B9E3DFBC
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 00:16:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DBF45611F0
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 08:16:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEFE8C433D2;
        Tue,  3 Jan 2023 08:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672733818;
        bh=be2TTvhY8EBxKrzyJOJ+UfrGaKMECh2VPW9ojLS79P0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CDcH5R9uuD7OIu2QjU7A7x3KxPoLa/MbuTo68efWvXfkfjLhPPyqHP4WfHQCBmJuJ
         1GfdoEFq0Z6//IA1jopXYQgvc2qH+Z5u+hwwqCJUa2PMqHQlKpMPFHODckD+vthMum
         ZZ+8Db/m+cCaxnpzP354WZ3B3jyeCVuAeEc2+H38=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Oleg Nesterov <oleg@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 54/63] task_work: add helper for more targeted task_work canceling
Date:   Tue,  3 Jan 2023 09:14:24 +0100
Message-Id: <20230103081311.827558617@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230103081308.548338576@linuxfoundation.org>
References: <20230103081308.548338576@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit c7aab1a7c52b82d9afd7e03c398eb03dc2aa0507 ]

The only exported helper we have right now is task_work_cancel(), which
cancels any task_work from a given task where func matches the queued
work item. This is a bit too coarse for some use cases. Add a
task_work_cancel_match() that allows to more specifically target
individual work items outside of purely the callback function used.

task_work_cancel() can be trivially implemented on top of that, hence do
so.

Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/task_work.h |    2 ++
 kernel/task_work.c        |   35 ++++++++++++++++++++++++++++-------
 2 files changed, 30 insertions(+), 7 deletions(-)

--- a/include/linux/task_work.h
+++ b/include/linux/task_work.h
@@ -22,6 +22,8 @@ enum task_work_notify_mode {
 int task_work_add(struct task_struct *task, struct callback_head *twork,
 			enum task_work_notify_mode mode);
 
+struct callback_head *task_work_cancel_match(struct task_struct *task,
+	bool (*match)(struct callback_head *, void *data), void *data);
 struct callback_head *task_work_cancel(struct task_struct *, task_work_func_t);
 void task_work_run(void);
 
--- a/kernel/task_work.c
+++ b/kernel/task_work.c
@@ -59,18 +59,17 @@ int task_work_add(struct task_struct *ta
 }
 
 /**
- * task_work_cancel - cancel a pending work added by task_work_add()
+ * task_work_cancel_match - cancel a pending work added by task_work_add()
  * @task: the task which should execute the work
- * @func: identifies the work to remove
- *
- * Find the last queued pending work with ->func == @func and remove
- * it from queue.
+ * @match: match function to call
  *
  * RETURNS:
  * The found work or NULL if not found.
  */
 struct callback_head *
-task_work_cancel(struct task_struct *task, task_work_func_t func)
+task_work_cancel_match(struct task_struct *task,
+		       bool (*match)(struct callback_head *, void *data),
+		       void *data)
 {
 	struct callback_head **pprev = &task->task_works;
 	struct callback_head *work;
@@ -86,7 +85,7 @@ task_work_cancel(struct task_struct *tas
 	 */
 	raw_spin_lock_irqsave(&task->pi_lock, flags);
 	while ((work = READ_ONCE(*pprev))) {
-		if (work->func != func)
+		if (!match(work, data))
 			pprev = &work->next;
 		else if (cmpxchg(pprev, work, work->next) == work)
 			break;
@@ -96,6 +95,28 @@ task_work_cancel(struct task_struct *tas
 	return work;
 }
 
+static bool task_work_func_match(struct callback_head *cb, void *data)
+{
+	return cb->func == data;
+}
+
+/**
+ * task_work_cancel - cancel a pending work added by task_work_add()
+ * @task: the task which should execute the work
+ * @func: identifies the work to remove
+ *
+ * Find the last queued pending work with ->func == @func and remove
+ * it from queue.
+ *
+ * RETURNS:
+ * The found work or NULL if not found.
+ */
+struct callback_head *
+task_work_cancel(struct task_struct *task, task_work_func_t func)
+{
+	return task_work_cancel_match(task, task_work_func_match, func);
+}
+
 /**
  * task_work_run - execute the works added by task_work_add()
  *


