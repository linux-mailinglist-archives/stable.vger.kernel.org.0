Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8EA151DA4F
	for <lists+stable@lfdr.de>; Fri,  6 May 2022 16:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442107AbiEFOTT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 May 2022 10:19:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390697AbiEFOTR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 May 2022 10:19:17 -0400
Received: from out03.mta.xmission.com (out03.mta.xmission.com [166.70.13.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D469A1DA6B;
        Fri,  6 May 2022 07:15:33 -0700 (PDT)
Received: from in01.mta.xmission.com ([166.70.13.51]:33830)
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nmyjz-001V0o-S3; Fri, 06 May 2022 08:15:32 -0600
Received: from ip68-227-174-4.om.om.cox.net ([68.227.174.4]:37210 helo=localhost.localdomain)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nmyjy-007Cxx-8O; Fri, 06 May 2022 08:15:31 -0600
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     linux-arch@vger.kernel.org
Cc:     Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        stable@vger.kernel.org,
        =?UTF-8?q?=D0=9C=D0=B0=D0=BA=D1=81=D0=B8=D0=BC=20=D0=9A=D1=83=D1=82=D1=8F=D0=B2=D0=B8=D0=BD?= 
        <maximkabox13@gmail.com>
Date:   Fri,  6 May 2022 09:15:06 -0500
Message-Id: <20220506141512.516114-1-ebiederm@xmission.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <87mtfu4up3.fsf@email.froward.int.ebiederm.org>
References: <87mtfu4up3.fsf@email.froward.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-XM-SPF: eid=1nmyjy-007Cxx-8O;;;mid=<20220506141512.516114-1-ebiederm@xmission.com>;;;hst=in01.mta.xmission.com;;;ip=68.227.174.4;;;frm=ebiederm@xmission.com;;;spf=softfail
X-XM-AID: U2FsdGVkX1/6Fq28LXF6kTwesTM8nfhPUaGtjnsT1W4=
X-SA-Exim-Connect-IP: 68.227.174.4
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ****;linux-arch@vger.kernel.org
X-Spam-Relay-Country: 
X-Spam-Timing: total 760 ms - load_scoreonly_sql: 0.04 (0.0%),
        signal_user_changed: 11 (1.4%), b_tie_ro: 9 (1.2%), parse: 1.25 (0.2%),
         extract_message_metadata: 13 (1.7%), get_uri_detail_list: 3.5 (0.5%),
        tests_pri_-1000: 14 (1.8%), tests_pri_-950: 1.16 (0.2%),
        tests_pri_-900: 0.98 (0.1%), tests_pri_-90: 227 (29.8%), check_bayes:
        225 (29.7%), b_tokenize: 13 (1.8%), b_tok_get_all: 12 (1.5%),
        b_comp_prob: 3.1 (0.4%), b_tok_touch_all: 193 (25.4%), b_finish: 0.89
        (0.1%), tests_pri_0: 480 (63.2%), check_dkim_signature: 0.78 (0.1%),
        check_dkim_adsp: 2.4 (0.3%), poll_dns_idle: 0.77 (0.1%), tests_pri_10:
        1.96 (0.3%), tests_pri_500: 7 (0.9%), rewrite_mail: 0.00 (0.0%)
Subject: [PATCH 1/7] kthread: Don't allocate kthread_struct for init and umh
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/exec.c                  |  6 ++++--
 include/linux/sched/task.h |  2 ++
 init/main.c                |  2 +-
 kernel/fork.c              | 22 ++++++++++++++++++++--
 kernel/umh.c               |  6 +++---
 5 files changed, 30 insertions(+), 8 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index e3e55d5e0be1..75eb6e0ee7b2 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1308,8 +1308,6 @@ int begin_new_exec(struct linux_binprm * bprm)
 	if (retval)
 		goto out_unlock;
 
-	if (me->flags & PF_KTHREAD)
-		free_kthread_struct(me);
 	me->flags &= ~(PF_RANDOMIZE | PF_FORKNOEXEC | PF_KTHREAD |
 					PF_NOFREEZE | PF_NO_SETAFFINITY);
 	flush_thread();
@@ -1955,6 +1953,10 @@ int kernel_execve(const char *kernel_filename,
 	int fd = AT_FDCWD;
 	int retval;
 
+	if (WARN_ON_ONCE((current->flags & PF_KTHREAD) &&
+			(current->worker_private)))
+		return -EINVAL;
+
 	filename = getname_kernel(kernel_filename);
 	if (IS_ERR(filename))
 		return PTR_ERR(filename);
diff --git a/include/linux/sched/task.h b/include/linux/sched/task.h
index 719c9a6cac8d..4492266935dd 100644
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
@@ -89,6 +90,7 @@ struct task_struct *create_io_thread(int (*fn)(void *), void *arg, int node);
 struct task_struct *fork_idle(int);
 struct mm_struct *copy_init_mm(void);
 extern pid_t kernel_thread(int (*fn)(void *), void *arg, unsigned long flags);
+extern pid_t user_mode_thread(int (*fn)(void *), void *arg, unsigned long flags);
 extern long kernel_wait4(pid_t, int __user *, int, struct rusage *);
 int kernel_wait(pid_t pid, int *stat);
 
diff --git a/init/main.c b/init/main.c
index 98182c3c2c4b..39baac0211c6 100644
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
diff --git a/kernel/fork.c b/kernel/fork.c
index 9796897560ab..27c5203750b4 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2157,7 +2157,7 @@ static __latent_entropy struct task_struct *copy_process(
 	p->io_context = NULL;
 	audit_set_context(p, NULL);
 	cgroup_fork(p);
-	if (p->flags & PF_KTHREAD) {
+	if (args->kthread) {
 		if (!set_kthread_struct(p))
 			goto bad_fork_cleanup_delayacct;
 	}
@@ -2548,7 +2548,8 @@ struct task_struct * __init fork_idle(int cpu)
 {
 	struct task_struct *task;
 	struct kernel_clone_args args = {
-		.flags = CLONE_VM,
+		.flags		= CLONE_VM,
+		.kthread	= 1,
 	};
 
 	task = copy_process(&init_struct_pid, 0, cpu_to_node(cpu), &args);
@@ -2679,6 +2680,23 @@ pid_t kernel_clone(struct kernel_clone_args *args)
  * Create a kernel thread.
  */
 pid_t kernel_thread(int (*fn)(void *), void *arg, unsigned long flags)
+{
+	struct kernel_clone_args args = {
+		.flags		= ((lower_32_bits(flags) | CLONE_VM |
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
 {
 	struct kernel_clone_args args = {
 		.flags		= ((lower_32_bits(flags) | CLONE_VM |
diff --git a/kernel/umh.c b/kernel/umh.c
index 36c123360ab8..b989736e8707 100644
--- a/kernel/umh.c
+++ b/kernel/umh.c
@@ -132,7 +132,7 @@ static void call_usermodehelper_exec_sync(struct subprocess_info *sub_info)
 
 	/* If SIGCLD is ignored do_wait won't populate the status. */
 	kernel_sigaction(SIGCHLD, SIG_DFL);
-	pid = kernel_thread(call_usermodehelper_exec_async, sub_info, SIGCHLD);
+	pid = user_mode_thread(call_usermodehelper_exec_async, sub_info, SIGCHLD);
 	if (pid < 0)
 		sub_info->retval = pid;
 	else
@@ -171,8 +171,8 @@ static void call_usermodehelper_exec_work(struct work_struct *work)
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
-- 
2.35.3

