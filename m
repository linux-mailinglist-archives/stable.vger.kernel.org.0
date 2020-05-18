Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4506C1D835B
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732752AbgERSEM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:04:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:50536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732699AbgERSEL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:04:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1535B20826;
        Mon, 18 May 2020 18:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589825050;
        bh=E/Op+RaVrETQ1UOWJ3NjNwU0eayP3HX8NADC4kqwK90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wKeLE/LGGA3bZIUdjowffVhYoby9jvb3vpqU4n2tz/+LuhctWouicQsQrEgcokpcM
         cTYi2ySd3SWhKrtqvcAXfpnloOyEtwbCaCqEaW389wla4xX3to9dbA0KsfDuCpaV9N
         G45W4aE+f6soYqOVNxUewFvygeANiSGbzuBbsAUk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 108/194] tracing: Wait for preempt irq delay thread to execute
Date:   Mon, 18 May 2020 19:36:38 +0200
Message-Id: <20200518173540.820723562@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

[ Upstream commit 8b1fac2e73e84ef0d6391051880a8e1d7044c847 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/preemptirq_delay_test.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/preemptirq_delay_test.c b/kernel/trace/preemptirq_delay_test.c
index c4c86de63cf91..312d1a0ca3b60 100644
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
2.20.1



