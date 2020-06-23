Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 824C3205E36
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389984AbgFWUU6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:20:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:38360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389876AbgFWUUx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:20:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EFC132064B;
        Tue, 23 Jun 2020 20:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943652;
        bh=oYl5wT15U5jPC3XS3EeFMjCr+tLCo+LVYg3TGPmb+SA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cl3XWPnkdW0Oa2feBJYBcxQdKC2zpnqxcksYTT4oNiZ6OR0t+dde4T18rtnVocfJW
         BU2TLbIJh5dw3GiTjc6WuJHqAEf2wnYmbyvMO3lxXLmF4ZT5tY7r+tefs6x74F53/m
         cYpTf3ik1J3o721ZXm+tMIC0ZpUiUfNmp5B8dynM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Divya Indi <divya.indi@oracle.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.7 468/477] sample-trace-array: Fix sleeping function called from invalid context
Date:   Tue, 23 Jun 2020 21:57:45 +0200
Message-Id: <20200623195429.670042579@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kefeng Wang <wangkefeng.wang@huawei.com>

commit e9b7b1c0c103a623be1a65c39f98719803440871 upstream.

BUG: sleeping function called from invalid context at kernel/locking/mutex.c:935
 in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 0, name: swapper/5
 1 lock held by swapper/5/0:
  #0: ffff80001002bd90 (samples/ftrace/sample-trace-array.c:38){+.-.}-{0:0}, at: call_timer_fn+0x8/0x3e0
 CPU: 5 PID: 0 Comm: swapper/5 Not tainted 5.7.0+ #8
 Hardware name: QEMU QEMU Virtual Machine, BIOS 0.0.0 02/06/2015
 Call trace:
  dump_backtrace+0x0/0x1a0
  show_stack+0x20/0x30
  dump_stack+0xe4/0x150
  ___might_sleep+0x160/0x200
  __might_sleep+0x58/0x90
  __mutex_lock+0x64/0x948
  mutex_lock_nested+0x3c/0x58
  __ftrace_set_clr_event+0x44/0x88
  trace_array_set_clr_event+0x24/0x38
  mytimer_handler+0x34/0x40 [sample_trace_array]

mutex_lock() will be called in interrupt context, using workqueue to fix it.

Link: https://lkml.kernel.org/r/20200610011244.2209486-1-wangkefeng.wang@huawei.com

Cc: stable@vger.kernel.org
Fixes: 89ed42495ef4 ("tracing: Sample module to demonstrate kernel access to Ftrace instances.")
Reviewed-by: Divya Indi <divya.indi@oracle.com>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 samples/ftrace/sample-trace-array.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

--- a/samples/ftrace/sample-trace-array.c
+++ b/samples/ftrace/sample-trace-array.c
@@ -6,6 +6,7 @@
 #include <linux/timer.h>
 #include <linux/err.h>
 #include <linux/jiffies.h>
+#include <linux/workqueue.h>
 
 /*
  * Any file that uses trace points, must include the header.
@@ -20,6 +21,16 @@ struct trace_array *tr;
 static void mytimer_handler(struct timer_list *unused);
 static struct task_struct *simple_tsk;
 
+static void trace_work_fn(struct work_struct *work)
+{
+	/*
+	 * Disable tracing for event "sample_event".
+	 */
+	trace_array_set_clr_event(tr, "sample-subsystem", "sample_event",
+			false);
+}
+static DECLARE_WORK(trace_work, trace_work_fn);
+
 /*
  * mytimer: Timer setup to disable tracing for event "sample_event". This
  * timer is only for the purposes of the sample module to demonstrate access of
@@ -29,11 +40,7 @@ static DEFINE_TIMER(mytimer, mytimer_han
 
 static void mytimer_handler(struct timer_list *unused)
 {
-	/*
-	 * Disable tracing for event "sample_event".
-	 */
-	trace_array_set_clr_event(tr, "sample-subsystem", "sample_event",
-			false);
+	schedule_work(&trace_work);
 }
 
 static void simple_thread_func(int count)
@@ -76,6 +83,7 @@ static int simple_thread(void *arg)
 		simple_thread_func(count++);
 
 	del_timer(&mytimer);
+	cancel_work_sync(&trace_work);
 
 	/*
 	 * trace_array_put() decrements the reference counter associated with


