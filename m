Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 586D9541776
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357740AbiFGVDU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:03:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379279AbiFGVCT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:02:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 825F866AC7;
        Tue,  7 Jun 2022 11:47:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1DACE612F2;
        Tue,  7 Jun 2022 18:47:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2802DC385A5;
        Tue,  7 Jun 2022 18:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627644;
        bh=zZiGrdNdmGO+3CfM32sERyqnjtDOD2AoS3nDEP+ZFb4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FnL9nV9ql5oZX81eCpv7ODEYK5z1uiYucH89xOMArC5+BkMuknutiB8HeKHx/eRQB
         A3gPk83AtpBMsG6ScAmgtdTZhvwwHOQsqauURFCNqAuoQYWZZot6b2/1DZ5OyEK6oT
         q1WZTaOePpPWRSKSUbf3TkWLKk/pXyxIbVZVrUyo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?=D0=9C=D0=B0=D0=BA=D1=81=D0=B8=D0=BC=20=D0=9A=D1=83=D1=82=D1=8F=D0=B2=D0=B8=D0=BD?= 
        <maximkabox13@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 5.18 041/879] kthread: Dont allocate kthread_struct for init and umh
Date:   Tue,  7 Jun 2022 18:52:39 +0200
Message-Id: <20220607165003.871993847@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

commit 343f4c49f2438d8920f1f76fa823ee59b91f02e4 upstream.

If kthread_is_per_cpu runs concurrently with free_kthread_struct the
kthread_struct that was just freed may be read from.

This bug was introduced by commit 40966e316f86 ("kthread: Ensure
struct kthread is present for all kthreads").  When kthread_struct
started to be allocated for all tasks that have PF_KTHREAD set.  This
in turn required the kthread_struct to be freed in kernel_execve and
violated the assumption that kthread_struct will have the same
lifetime as the task.

Looking a bit deeper this only applies to callers of kernel_execve
which is just the init process and the user mode helper processes.
These processes really don't want to be kernel threads but are for
historical reasons.  Mostly that copy_thread does not know how to take
a kernel mode function to the process with for processes without
PF_KTHREAD or PF_IO_WORKER set.

Solve this by not allocating kthread_struct for the init process and
the user mode helper processes.

This is done by adding a kthread member to struct kernel_clone_args.
Setting kthread in fork_idle and kernel_thread.  Adding
user_mode_thread that works like kernel_thread except it does not set
kthread.  In fork only allocating the kthread_struct if .kthread is set.

I have looked at kernel/kthread.c and since commit 40966e316f86
("kthread: Ensure struct kthread is present for all kthreads") there
have been no assumptions added that to_kthread or __to_kthread will
not return NULL.

There are a few callers of to_kthread or __to_kthread that assume a
non-NULL struct kthread pointer will be returned.  These functions are
kthread_data(), kthread_parmme(), kthread_exit(), kthread(),
kthread_park(), kthread_unpark(), kthread_stop().  All of those functions
can reasonably expected to be called when it is know that a task is a
kthread so that assumption seems reasonable.

Cc: stable@vger.kernel.org
Fixes: 40966e316f86 ("kthread: Ensure struct kthread is present for all kthreads")
Reported-by: Максим Кутявин <maximkabox13@gmail.com>
Link: https://lkml.kernel.org/r/20220506141512.516114-1-ebiederm@xmission.com
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exec.c                  |    6 ++++--
 include/linux/sched/task.h |    2 ++
 init/main.c                |    2 +-
 kernel/fork.c              |   22 ++++++++++++++++++++--
 kernel/umh.c               |    6 +++---
 5 files changed, 30 insertions(+), 8 deletions(-)

--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1308,8 +1308,6 @@ int begin_new_exec(struct linux_binprm *
 	if (retval)
 		goto out_unlock;
 
-	if (me->flags & PF_KTHREAD)
-		free_kthread_struct(me);
 	me->flags &= ~(PF_RANDOMIZE | PF_FORKNOEXEC | PF_KTHREAD |
 					PF_NOFREEZE | PF_NO_SETAFFINITY);
 	flush_thread();
@@ -1955,6 +1953,10 @@ int kernel_execve(const char *kernel_fil
 	int fd = AT_FDCWD;
 	int retval;
 
+	if (WARN_ON_ONCE((current->flags & PF_KTHREAD) &&
+			(current->worker_private)))
+		return -EINVAL;
+
 	filename = getname_kernel(kernel_filename);
 	if (IS_ERR(filename))
 		return PTR_ERR(filename);
--- a/include/linux/sched/task.h
+++ b/include/linux/sched/task.h
@@ -32,6 +32,7 @@ struct kernel_clone_args {
 	size_t set_tid_size;
 	int cgroup;
 	int io_thread;
+	int kthread;
 	struct cgroup *cgrp;
 	struct css_set *cset;
 };
@@ -89,6 +90,7 @@ struct task_struct *create_io_thread(int
 struct task_struct *fork_idle(int);
 struct mm_struct *copy_init_mm(void);
 extern pid_t kernel_thread(int (*fn)(void *), void *arg, unsigned long flags);
+extern pid_t user_mode_thread(int (*fn)(void *), void *arg, unsigned long flags);
 extern long kernel_wait4(pid_t, int __user *, int, struct rusage *);
 int kernel_wait(pid_t pid, int *stat);
 
--- a/init/main.c
+++ b/init/main.c
@@ -688,7 +688,7 @@ noinline void __ref rest_init(void)
 	 * the init task will end up wanting to create kthreads, which, if
 	 * we schedule it before we create kthreadd, will OOPS.
 	 */
-	pid = kernel_thread(kernel_init, NULL, CLONE_FS);
+	pid = user_mode_thread(kernel_init, NULL, CLONE_FS);
 	/*
 	 * Pin init on the boot CPU. Task migration is not properly working
 	 * until sched_init_smp() has been run. It will set the allowed
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2157,7 +2157,7 @@ static __latent_entropy struct task_stru
 	p->io_context = NULL;
 	audit_set_context(p, NULL);
 	cgroup_fork(p);
-	if (p->flags & PF_KTHREAD) {
+	if (args->kthread) {
 		if (!set_kthread_struct(p))
 			goto bad_fork_cleanup_delayacct;
 	}
@@ -2548,7 +2548,8 @@ struct task_struct * __init fork_idle(in
 {
 	struct task_struct *task;
 	struct kernel_clone_args args = {
-		.flags = CLONE_VM,
+		.flags		= CLONE_VM,
+		.kthread	= 1,
 	};
 
 	task = copy_process(&init_struct_pid, 0, cpu_to_node(cpu), &args);
@@ -2682,6 +2683,23 @@ pid_t kernel_thread(int (*fn)(void *), v
 {
 	struct kernel_clone_args args = {
 		.flags		= ((lower_32_bits(flags) | CLONE_VM |
+				    CLONE_UNTRACED) & ~CSIGNAL),
+		.exit_signal	= (lower_32_bits(flags) & CSIGNAL),
+		.stack		= (unsigned long)fn,
+		.stack_size	= (unsigned long)arg,
+		.kthread	= 1,
+	};
+
+	return kernel_clone(&args);
+}
+
+/*
+ * Create a user mode thread.
+ */
+pid_t user_mode_thread(int (*fn)(void *), void *arg, unsigned long flags)
+{
+	struct kernel_clone_args args = {
+		.flags		= ((lower_32_bits(flags) | CLONE_VM |
 				    CLONE_UNTRACED) & ~CSIGNAL),
 		.exit_signal	= (lower_32_bits(flags) & CSIGNAL),
 		.stack		= (unsigned long)fn,
--- a/kernel/umh.c
+++ b/kernel/umh.c
@@ -132,7 +132,7 @@ static void call_usermodehelper_exec_syn
 
 	/* If SIGCLD is ignored do_wait won't populate the status. */
 	kernel_sigaction(SIGCHLD, SIG_DFL);
-	pid = kernel_thread(call_usermodehelper_exec_async, sub_info, SIGCHLD);
+	pid = user_mode_thread(call_usermodehelper_exec_async, sub_info, SIGCHLD);
 	if (pid < 0)
 		sub_info->retval = pid;
 	else
@@ -171,8 +171,8 @@ static void call_usermodehelper_exec_wor
 		 * want to pollute current->children, and we need a parent
 		 * that always ignores SIGCHLD to ensure auto-reaping.
 		 */
-		pid = kernel_thread(call_usermodehelper_exec_async, sub_info,
-				    CLONE_PARENT | SIGCHLD);
+		pid = user_mode_thread(call_usermodehelper_exec_async, sub_info,
+				       CLONE_PARENT | SIGCHLD);
 		if (pid < 0) {
 			sub_info->retval = pid;
 			umh_complete(sub_info);


