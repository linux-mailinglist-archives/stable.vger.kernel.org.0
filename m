Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E094D591F82
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 12:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbiHNKUs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 06:20:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbiHNKUr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 06:20:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B7731A040
        for <stable@vger.kernel.org>; Sun, 14 Aug 2022 03:20:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3873861008
        for <stable@vger.kernel.org>; Sun, 14 Aug 2022 10:20:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48503C433D6;
        Sun, 14 Aug 2022 10:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660472445;
        bh=4MxXGzfVj7vC7wN769Zw1QJVIRWiEGvN4qzJXnyI+C8=;
        h=Subject:To:Cc:From:Date:From;
        b=PgTcz+z3c2+BkAeEzNN/bpcTAaouV9r+L2mKU6nwjZoPCWIWmoP/jNhVcVmYkYjan
         uZt9OmUlmasknkdQZleFSeyP2aR/0Hn+E6jkYeawtKi5yl8eZazSYwBNgfCThOuing
         tl09PDu/bV8j2bV2cl0BulEe42GbNxTCJ+eRBZjc=
Subject: FAILED: patch "[PATCH] audit, io_uring, io-wq: Fix memory leak in io_sq_thread() and" failed to apply to 5.18-stable tree
To:     peilin.ye@bytedance.com, axboe@kernel.dk, paul@paul-moore.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 14 Aug 2022 12:20:35 +0200
Message-ID: <16604724358610@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.18-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f482aa98652795846cc55da98ebe331eb74f3d0b Mon Sep 17 00:00:00 2001
From: Peilin Ye <peilin.ye@bytedance.com>
Date: Wed, 3 Aug 2022 15:23:43 -0700
Subject: [PATCH] audit, io_uring, io-wq: Fix memory leak in io_sq_thread() and
 io_wqe_worker()

Currently @audit_context is allocated twice for io_uring workers:

  1. copy_process() calls audit_alloc();
  2. io_sq_thread() or io_wqe_worker() calls audit_alloc_kernel() (which
     is effectively audit_alloc()) and overwrites @audit_context,
     causing:

  BUG: memory leak
  unreferenced object 0xffff888144547400 (size 1024):
<...>
    hex dump (first 32 bytes):
      00 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00  ................
      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    backtrace:
      [<ffffffff8135cfc3>] audit_alloc+0x133/0x210
      [<ffffffff81239e63>] copy_process+0xcd3/0x2340
      [<ffffffff8123b5f3>] create_io_thread+0x63/0x90
      [<ffffffff81686604>] create_io_worker+0xb4/0x230
      [<ffffffff81686f68>] io_wqe_enqueue+0x248/0x3b0
      [<ffffffff8167663a>] io_queue_iowq+0xba/0x200
      [<ffffffff816768b3>] io_queue_async+0x113/0x180
      [<ffffffff816840df>] io_req_task_submit+0x18f/0x1a0
      [<ffffffff816841cd>] io_apoll_task_func+0xdd/0x120
      [<ffffffff8167d49f>] tctx_task_work+0x11f/0x570
      [<ffffffff81272c4e>] task_work_run+0x7e/0xc0
      [<ffffffff8125a688>] get_signal+0xc18/0xf10
      [<ffffffff8111645b>] arch_do_signal_or_restart+0x2b/0x730
      [<ffffffff812ea44e>] exit_to_user_mode_prepare+0x5e/0x180
      [<ffffffff844ae1b2>] syscall_exit_to_user_mode+0x12/0x20
      [<ffffffff844a7e80>] do_syscall_64+0x40/0x80

Then,

  3. io_sq_thread() or io_wqe_worker() frees @audit_context using
     audit_free();
  4. do_exit() eventually calls audit_free() again, which is okay
     because audit_free() does a NULL check.

As suggested by Paul Moore, fix it by deleting audit_alloc_kernel() and
redundant audit_free() calls.

Fixes: 5bd2182d58e9 ("audit,io_uring,io-wq: add some basic audit support to io_uring")
Suggested-by: Paul Moore <paul@paul-moore.com>
Cc: stable@vger.kernel.org
Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
Acked-by: Paul Moore <paul@paul-moore.com>
Link: https://lore.kernel.org/r/20220803222343.31673-1-yepeilin.cs@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 00f7a80f1a3e..3608992848d3 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -285,7 +285,6 @@ static inline int audit_signal_info(int sig, struct task_struct *t)
 /* These are defined in auditsc.c */
 				/* Public API */
 extern int  audit_alloc(struct task_struct *task);
-extern int  audit_alloc_kernel(struct task_struct *task);
 extern void __audit_free(struct task_struct *task);
 extern void __audit_uring_entry(u8 op);
 extern void __audit_uring_exit(int success, long code);
@@ -578,10 +577,6 @@ static inline int audit_alloc(struct task_struct *task)
 {
 	return 0;
 }
-static inline int audit_alloc_kernel(struct task_struct *task)
-{
-	return 0;
-}
 static inline void audit_free(struct task_struct *task)
 { }
 static inline void audit_uring_entry(u8 op)
diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 77df5b43bf52..c6536d4b2da0 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -624,8 +624,6 @@ static int io_wqe_worker(void *data)
 	snprintf(buf, sizeof(buf), "iou-wrk-%d", wq->task->pid);
 	set_task_comm(current, buf);
 
-	audit_alloc_kernel(current);
-
 	while (!test_bit(IO_WQ_BIT_EXIT, &wq->state)) {
 		long ret;
 
@@ -660,7 +658,6 @@ static int io_wqe_worker(void *data)
 	if (test_bit(IO_WQ_BIT_EXIT, &wq->state))
 		io_worker_handle_work(worker);
 
-	audit_free(current);
 	io_worker_exit(worker);
 	return 0;
 }
diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index 76d4d70c733a..559652380672 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -235,8 +235,6 @@ static int io_sq_thread(void *data)
 		set_cpus_allowed_ptr(current, cpu_online_mask);
 	current->flags |= PF_NO_SETAFFINITY;
 
-	audit_alloc_kernel(current);
-
 	mutex_lock(&sqd->lock);
 	while (1) {
 		bool cap_entries, sqt_spin = false;
@@ -310,8 +308,6 @@ static int io_sq_thread(void *data)
 	io_run_task_work();
 	mutex_unlock(&sqd->lock);
 
-	audit_free(current);
-
 	complete(&sqd->exited);
 	do_exit(0);
 }
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 3a8c9d744800..dd8d9ab747c3 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1073,31 +1073,6 @@ int audit_alloc(struct task_struct *tsk)
 	return 0;
 }
 
-/**
- * audit_alloc_kernel - allocate an audit_context for a kernel task
- * @tsk: the kernel task
- *
- * Similar to the audit_alloc() function, but intended for kernel private
- * threads.  Returns zero on success, negative values on failure.
- */
-int audit_alloc_kernel(struct task_struct *tsk)
-{
-	/*
-	 * At the moment we are just going to call into audit_alloc() to
-	 * simplify the code, but there two things to keep in mind with this
-	 * approach:
-	 *
-	 * 1. Filtering internal kernel tasks is a bit laughable in almost all
-	 * cases, but there is at least one case where there is a benefit:
-	 * the '-a task,never' case allows the admin to effectively disable
-	 * task auditing at runtime.
-	 *
-	 * 2. The {set,clear}_task_syscall_work() ops likely have zero effect
-	 * on these internal kernel tasks, but they probably don't hurt either.
-	 */
-	return audit_alloc(tsk);
-}
-
 static inline void audit_free_context(struct audit_context *context)
 {
 	/* resetting is extra work, but it is likely just noise */

