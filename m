Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC371CF59D
	for <lists+stable@lfdr.de>; Tue, 12 May 2020 15:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730033AbgELNXz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 May 2020 09:23:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:57502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727859AbgELNXt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 May 2020 09:23:49 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17DC52075E;
        Tue, 12 May 2020 13:23:49 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.93)
        (envelope-from <rostedt@goodmis.org>)
        id 1jYUsu-0006Oe-07; Tue, 12 May 2020 09:23:48 -0400
Message-ID: <20200512132347.887995207@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 12 May 2020 09:23:19 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>
Subject: [for-linus][PATCH 2/3] tracing: Wait for preempt irq delay thread to execute
References: <20200512132317.343672858@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

A bug report was posted that running the preempt irq delay module on a slow
machine, and removing it quickly could lead to the thread created by the
modlue to execute after the module is removed, and this could cause the
kernel to crash. The fix for this was to call kthread_stop() after creating
the thread to make sure it finishes before allowing the module to be
removed.

Now this caused the opposite problem on fast machines. What now happens is
the kthread_stop() can cause the kthread never to execute and the test never
to run. To fix this, add a completion and wait for the kthread to execute,
then wait for it to end.

This issue caused the ftracetest selftests to fail on the preemptirq tests.

Link: https://lore.kernel.org/r/20200510114210.15d9e4af@oasis.local.home

Cc: stable@vger.kernel.org
Fixes: d16a8c31077e ("tracing: Wait for preempt irq delay thread to finish")
Reviewed-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/trace/preemptirq_delay_test.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/preemptirq_delay_test.c b/kernel/trace/preemptirq_delay_test.c
index c4c86de63cf9..312d1a0ca3b6 100644
--- a/kernel/trace/preemptirq_delay_test.c
+++ b/kernel/trace/preemptirq_delay_test.c
@@ -16,6 +16,7 @@
 #include <linux/printk.h>
 #include <linux/string.h>
 #include <linux/sysfs.h>
+#include <linux/completion.h>
 
 static ulong delay = 100;
 static char test_mode[12] = "irq";
@@ -28,6 +29,8 @@ MODULE_PARM_DESC(delay, "Period in microseconds (100 us default)");
 MODULE_PARM_DESC(test_mode, "Mode of the test such as preempt, irq, or alternate (default irq)");
 MODULE_PARM_DESC(burst_size, "The size of a burst (default 1)");
 
+static struct completion done;
+
 #define MIN(x, y) ((x) < (y) ? (x) : (y))
 
 static void busy_wait(ulong time)
@@ -114,6 +117,8 @@ static int preemptirq_delay_run(void *data)
 	for (i = 0; i < s; i++)
 		(testfuncs[i])(i);
 
+	complete(&done);
+
 	set_current_state(TASK_INTERRUPTIBLE);
 	while (!kthread_should_stop()) {
 		schedule();
@@ -128,15 +133,18 @@ static int preemptirq_delay_run(void *data)
 static int preemptirq_run_test(void)
 {
 	struct task_struct *task;
-
 	char task_name[50];
 
+	init_completion(&done);
+
 	snprintf(task_name, sizeof(task_name), "%s_test", test_mode);
 	task =  kthread_run(preemptirq_delay_run, NULL, task_name);
 	if (IS_ERR(task))
 		return PTR_ERR(task);
-	if (task)
+	if (task) {
+		wait_for_completion(&done);
 		kthread_stop(task);
+	}
 	return 0;
 }
 
-- 
2.26.2


