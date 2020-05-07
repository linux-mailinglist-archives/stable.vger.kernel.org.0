Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7D4F1C980B
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 19:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728119AbgEGRj6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 13:39:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:35750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727825AbgEGRja (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 May 2020 13:39:30 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 307E8215A4;
        Thu,  7 May 2020 17:39:30 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.93)
        (envelope-from <rostedt@goodmis.org>)
        id 1jWkUb-000Dni-3C; Thu, 07 May 2020 13:39:29 -0400
Message-ID: <20200507173928.961003729@goodmis.org>
User-Agent: quilt/0.66
Date:   Thu, 07 May 2020 13:39:09 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, Xiao Yang <yangx.jy@cn.fujitsu.com>,
        Joel Fernandes <joel@joelfernandes.org>
Subject: [for-linus][PATCH 5/9] tracing: Wait for preempt irq delay thread to finish
References: <20200507173904.729935165@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Running on a slower machine, it is possible that the preempt delay kernel
thread may still be executing if the module was immediately removed after
added, and this can cause the kernel to crash as the kernel thread might be
executing after its code has been removed.

There's no reason that the caller of the code shouldn't just wait for the
delay thread to finish, as the thread can also be created by a trigger in
the sysfs code, which also has the same issues.

Link: http://lore.kernel.org/r/5EA2B0C8.2080706@cn.fujitsu.com

Cc: stable@vger.kernel.org
Fixes: 793937236d1ee ("lib: Add module for testing preemptoff/irqsoff latency tracers")
Reported-by: Xiao Yang <yangx.jy@cn.fujitsu.com>
Reviewed-by: Xiao Yang <yangx.jy@cn.fujitsu.com>
Reviewed-by: Joel Fernandes <joel@joelfernandes.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/trace/preemptirq_delay_test.c | 30 ++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/preemptirq_delay_test.c b/kernel/trace/preemptirq_delay_test.c
index 31c0fad4cb9e..c4c86de63cf9 100644
--- a/kernel/trace/preemptirq_delay_test.c
+++ b/kernel/trace/preemptirq_delay_test.c
@@ -113,22 +113,42 @@ static int preemptirq_delay_run(void *data)
 
 	for (i = 0; i < s; i++)
 		(testfuncs[i])(i);
+
+	set_current_state(TASK_INTERRUPTIBLE);
+	while (!kthread_should_stop()) {
+		schedule();
+		set_current_state(TASK_INTERRUPTIBLE);
+	}
+
+	__set_current_state(TASK_RUNNING);
+
 	return 0;
 }
 
-static struct task_struct *preemptirq_start_test(void)
+static int preemptirq_run_test(void)
 {
+	struct task_struct *task;
+
 	char task_name[50];
 
 	snprintf(task_name, sizeof(task_name), "%s_test", test_mode);
-	return kthread_run(preemptirq_delay_run, NULL, task_name);
+	task =  kthread_run(preemptirq_delay_run, NULL, task_name);
+	if (IS_ERR(task))
+		return PTR_ERR(task);
+	if (task)
+		kthread_stop(task);
+	return 0;
 }
 
 
 static ssize_t trigger_store(struct kobject *kobj, struct kobj_attribute *attr,
 			 const char *buf, size_t count)
 {
-	preemptirq_start_test();
+	ssize_t ret;
+
+	ret = preemptirq_run_test();
+	if (ret)
+		return ret;
 	return count;
 }
 
@@ -148,11 +168,9 @@ static struct kobject *preemptirq_delay_kobj;
 
 static int __init preemptirq_delay_init(void)
 {
-	struct task_struct *test_task;
 	int retval;
 
-	test_task = preemptirq_start_test();
-	retval = PTR_ERR_OR_ZERO(test_task);
+	retval = preemptirq_run_test();
 	if (retval != 0)
 		return retval;
 
-- 
2.26.2


