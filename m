Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9467465BBEF
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 09:18:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237029AbjACIQa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 03:16:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237026AbjACIQN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 03:16:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D57C4BEA
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 00:16:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7486E611DD
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 08:16:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BCBEC433EF;
        Tue,  3 Jan 2023 08:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672733770;
        bh=lOZerBTQ5gYyhk15qEeqsvdwkOTwwEtAwupgB4roqJo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NGJSms8Y8g+zI5Fv+0vI9II0Kbsh49mZlQmigMH8xWBxKqYxOCxDv5v/R/py/72S7
         sR4or9nVG315+5FyqoejUiGM2LyMp7c3B7zbzI/1H0Oy8CLk5rNfW9xTfpEAeFH5Cc
         SOne5cx/N71z0eBDxj/pZ0ESNuPcbUqWNP92hd7A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Roman Gershman <romger@amazon.com>,
        Jens Axboe <axboe@kernel.dk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 5.10 16/63] task_work: Use TIF_NOTIFY_SIGNAL if available
Date:   Tue,  3 Jan 2023 09:13:46 +0100
Message-Id: <20230103081309.539024685@linuxfoundation.org>
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

[ Upstream commit 114518eb6430b832d2f9f5a008043b913ccf0e24 ]

If the arch supports TIF_NOTIFY_SIGNAL, then use that for TWA_SIGNAL as
it's more efficient than using the signal delivery method. This is
especially true on threaded applications, where ->sighand is shared across
threads, but it's also lighter weight on non-shared cases.

io_uring is a heavy consumer of TWA_SIGNAL based task_work. A test with
threads shows a nice improvement running an io_uring based echo server.

stock kernel:
0.01% <= 0.1 milliseconds
95.86% <= 0.2 milliseconds
98.27% <= 0.3 milliseconds
99.71% <= 0.4 milliseconds
100.00% <= 0.5 milliseconds
100.00% <= 0.6 milliseconds
100.00% <= 0.7 milliseconds
100.00% <= 0.8 milliseconds
100.00% <= 0.9 milliseconds
100.00% <= 1.0 milliseconds
100.00% <= 1.1 milliseconds
100.00% <= 2 milliseconds
100.00% <= 3 milliseconds
100.00% <= 3 milliseconds
1378930.00 requests per second
~1600% CPU

1.38M requests/second, and all 16 CPUs are maxed out.

patched kernel:
0.01% <= 0.1 milliseconds
98.24% <= 0.2 milliseconds
99.47% <= 0.3 milliseconds
99.99% <= 0.4 milliseconds
100.00% <= 0.5 milliseconds
100.00% <= 0.6 milliseconds
100.00% <= 0.7 milliseconds
100.00% <= 0.8 milliseconds
100.00% <= 0.9 milliseconds
100.00% <= 1.2 milliseconds
1666111.38 requests per second
~1450% CPU

1.67M requests/second, and we're no longer just hammering on the sighand
lock. The original reporter states:

"For 5.7.15 my benchmark achieves 1.6M qps and system cpu is at ~80%.
 for 5.7.16 or later it achieves only 1M qps and the system cpu is is
 at ~100%"

with the only difference there being that TWA_SIGNAL is used
unconditionally in 5.7.16, since it's required to be able to handle the
inability to run task_work if the application is waiting in the kernel
already on an event that needs task_work run to be satisfied. Also see
commit 0ba9c9edcd15.

Reported-by: Roman Gershman <romger@amazon.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Link: https://lore.kernel.org/r/20201026203230.386348-5-axboe@kernel.dk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/task_work.c |   41 +++++++++++++++++++++++++++++------------
 1 file changed, 29 insertions(+), 12 deletions(-)

--- a/kernel/task_work.c
+++ b/kernel/task_work.c
@@ -5,6 +5,34 @@
 
 static struct callback_head work_exited; /* all we need is ->next == NULL */
 
+/*
+ * TWA_SIGNAL signaling - use TIF_NOTIFY_SIGNAL, if available, as it's faster
+ * than TIF_SIGPENDING as there's no dependency on ->sighand. The latter is
+ * shared for threads, and can cause contention on sighand->lock. Even for
+ * the non-threaded case TIF_NOTIFY_SIGNAL is more efficient, as no locking
+ * or IRQ disabling is involved for notification (or running) purposes.
+ */
+static void task_work_notify_signal(struct task_struct *task)
+{
+#if defined(TIF_NOTIFY_SIGNAL)
+	set_notify_signal(task);
+#else
+	unsigned long flags;
+
+	/*
+	 * Only grab the sighand lock if we don't already have some
+	 * task_work pending. This pairs with the smp_store_mb()
+	 * in get_signal(), see comment there.
+	 */
+	if (!(READ_ONCE(task->jobctl) & JOBCTL_TASK_WORK) &&
+	    lock_task_sighand(task, &flags)) {
+		task->jobctl |= JOBCTL_TASK_WORK;
+		signal_wake_up(task, 0);
+		unlock_task_sighand(task, &flags);
+	}
+#endif
+}
+
 /**
  * task_work_add - ask the @task to execute @work->func()
  * @task: the task which should run the callback
@@ -33,7 +61,6 @@ int task_work_add(struct task_struct *ta
 		  enum task_work_notify_mode notify)
 {
 	struct callback_head *head;
-	unsigned long flags;
 
 	do {
 		head = READ_ONCE(task->task_works);
@@ -49,17 +76,7 @@ int task_work_add(struct task_struct *ta
 		set_notify_resume(task);
 		break;
 	case TWA_SIGNAL:
-		/*
-		 * Only grab the sighand lock if we don't already have some
-		 * task_work pending. This pairs with the smp_store_mb()
-		 * in get_signal(), see comment there.
-		 */
-		if (!(READ_ONCE(task->jobctl) & JOBCTL_TASK_WORK) &&
-		    lock_task_sighand(task, &flags)) {
-			task->jobctl |= JOBCTL_TASK_WORK;
-			signal_wake_up(task, 0);
-			unlock_task_sighand(task, &flags);
-		}
+		task_work_notify_signal(task);
 		break;
 	default:
 		WARN_ON_ONCE(1);


