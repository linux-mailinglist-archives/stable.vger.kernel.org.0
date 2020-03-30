Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A8C7198356
	for <lists+stable@lfdr.de>; Mon, 30 Mar 2020 20:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726781AbgC3S0O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Mar 2020 14:26:14 -0400
Received: from mail-db8eur05olkn2010.outbound.protection.outlook.com ([40.92.89.10]:30830
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726017AbgC3S0O (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Mar 2020 14:26:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nOmbhjkX9ceq/9MoYXBv1Po6wTI5OVOxnvsCvbLdll2RLGw5ISOuV9h2oMqzApcNCsD6o6bHoIh1uV0qYkClzEKNPd33gjBRS8ZN2T70JqNejDURD/e92FwiPtRhq7QcZgfcJC+g5Et0XDeJ0lrRl172fvP+kR3YIgflxol3iEgUjkdmYq/K7naME2DL9GhsPgoSaxd0WnAyy54UfeZ1kDIbw7Cdrx4lsxGSUt63m3lkgSpU70BuM6LqtGB3p2WCq6E1oTIB5nhlzrEDFFgjm2JtTQbwHwWKJ8zIQAOVYWZ1G2x7fvCkBxAY0F45I9YyZKIA7pCZkGUirREPQuxdSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d8U2Be8pswTMF/0bb5onJ6IK6fDOILJZWQi8vqyAJos=;
 b=bdFbi5fqhH/lSCn+e+krjSJWDO9xctQRxMlBNDypNsV1h/VKlVrDNvCcxOkj91Ywz5YgyRX7bc59i6ndmDzYXw9RxhJVdh9FuwAqwzjVGQabF8Vxs7yfuM3O0ykSTkKng3y0u4KcbAcn7rO5eWNlxFH+FpW8/IBj79fvSJC2074xg/a4RRcA1HUB+sn4EZQ3zKYL1PIWbaQNEQzDNbk/Md/qPEpBGAlwyzwVvvrJ6BhwyTcCuD3EyC+D1xV6NgPlG4y+ehaltQfZCyjkZoDrWeIkqZj9hmFwOpJrq37Dj7Vbv5kg4VdtJHOTqS9oFVaKBK7nB2gD5Jgxu3peIbgJzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hotmail.de; dmarc=pass action=none header.from=hotmail.de;
 dkim=pass header.d=hotmail.de; arc=none
Received: from DB8EUR05FT067.eop-eur05.prod.protection.outlook.com
 (2a01:111:e400:fc0f::48) by
 DB8EUR05HT007.eop-eur05.prod.protection.outlook.com (2a01:111:e400:fc0f::410)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.17; Mon, 30 Mar
 2020 18:26:09 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.233.238.55) by
 DB8EUR05FT067.mail.protection.outlook.com (10.233.238.176) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.17 via Frontend Transport; Mon, 30 Mar 2020 18:26:09 +0000
X-IncomingTopHeaderMarker: OriginalChecksum:4C88A4F429534C6CE96C2E909720EB49127FE5E73DC90950B0F5159915673A2E;UpperCasedChecksum:C8DD347AA88A5044EFEC87257EEC0F378B78247AEE23CC279700BA028CBF8FCC;SizeAsReceived:9761;Count:50
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::d57:5853:a396:969d]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::d57:5853:a396:969d%7]) with mapi id 15.20.2856.019; Mon, 30 Mar 2020
 18:26:09 +0000
Subject: [PATCH v7 15/16] exec: Fix dead-lock in de_thread with ptrace_attach
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Kees Cook <keescook@chromium.org>,
        "jannh@google.com" <jannh@google.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        "adobriyan@gmail.com" <adobriyan@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Oleg Nesterov <oleg@redhat.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        "avagin@gmail.com" <avagin@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "duyuyang@gmail.com" <duyuyang@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        David Howells <dhowells@redhat.com>,
        James Morris <jamorris@linux.microsoft.com>,
        Shakeel Butt <shakeelb@google.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "christian@kellner.me" <christian@kellner.me>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Aleksa Sarai <cyphar@cyphar.com>,
        "Dmitry V. Levin" <ldv@altlinux.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
References: <077b63b7-6f5e-aa8e-bf96-a586b481cc46@hotmail.de>
 <b6537ae6-31b1-5c50-f32b-8b8332ace882@hotmail.de>
 <87a7448q7t.fsf@x220.int.ebiederm.org>
 <AM6PR03MB51700B30078BDCB6C6A4E0CAE4CA0@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <AM6PR03MB5170480FE4462D0DFF04B14BE4CA0@AM6PR03MB5170.eurprd03.prod.outlook.com>
Message-ID: <AM6PR03MB51700577CF9EF4972FDE568AE4CB0@AM6PR03MB5170.eurprd03.prod.outlook.com>
Date:   Mon, 30 Mar 2020 20:26:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
In-Reply-To: <AM6PR03MB5170480FE4462D0DFF04B14BE4CA0@AM6PR03MB5170.eurprd03.prod.outlook.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR10CA0045.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::25) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
X-Microsoft-Original-Message-ID: <cf7a0879-0e1f-42bb-8646-8280825cef22@hotmail.de>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.101] (92.77.140.102) by AM0PR10CA0045.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20 via Frontend Transport; Mon, 30 Mar 2020 18:26:06 +0000
X-Microsoft-Original-Message-ID: <cf7a0879-0e1f-42bb-8646-8280825cef22@hotmail.de>
X-TMN:  [y9ufXCBt4sr7XGb+WUkBtwVDEusu7VC3]
X-MS-PublicTrafficType: Email
X-IncomingHeaderCount: 50
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-Correlation-Id: 20199f2c-b72f-4876-2c8a-08d7d4d7d122
X-MS-TrafficTypeDiagnostic: DB8EUR05HT007:
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uS7rbgjfuVIVdgnKcd2uan596kkpevqhgupHOUEPthl4XWcOvoWBIc6SdcmbpYdAJbQPCsoQ5+l3lIr7OB/7BfCWnKYhfOzw3imFzQb+dPie8sahw5jmloYRcbWreWW0L5FK9btRZPbfrQXJje9NO2asSFw1vjjziJAkqbqBXAAkinKRKPfYe5NRa7dALK1O
X-MS-Exchange-AntiSpam-MessageData: 8GX4ZTJd49+7/svEgexSIVDmYXbhqnZQSGHJp6bHrA7oF+H9yJ0alQujonVxE77OutkC/Hd8PtV5fvObHNrewNy+KIsi/BazBn1kf6pyE0gpZ2H8M4XzyHIlj4Ykh4elrfX/rG4MjrZf3hiGAdq2Og==
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20199f2c-b72f-4876-2c8a-08d7d4d7d122
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2020 18:26:09.3636
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-FromEntityHeader: Internet
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8EUR05HT007
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This removes the last users of cred_guard_mutex
and replaces it with a new mutex exec_guard_mutex,
and a boolean unsafe_execve_in_progress.

This addresses the case when at least one of the
sibling threads is traced, and therefore the trace
process may dead-lock in ptrace_attach, but de_thread
will need to wait for the tracer to continue execution.

The solution is to detect this situation and make
ptrace_attach and similar functions return -EAGAIN,
but only in a situation where a dead-lock is imminent.

This means this is an API change, but only when the
process is traced while execve happens in a
multi-threaded application.

See tools/testing/selftests/ptrace/vmaccess.c
for a test case that gets fixed by this change.

Signed-off-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
---
 fs/exec.c                    | 44 +++++++++++++++++++++++++++++++++++---------
 fs/proc/base.c               | 20 ++++++++++++++++++--
 include/linux/sched/signal.h | 14 +++++++++-----
 init/init_task.c             |  2 +-
 kernel/cred.c                |  2 +-
 kernel/fork.c                |  2 +-
 kernel/ptrace.c              | 42 +++++++++++++++++++++++++++++++++++++++---
 kernel/seccomp.c             | 25 +++++++++++++++++++------
 8 files changed, 123 insertions(+), 28 deletions(-)

v7: Added "big fat" warning comments, made the change in
proc_pid_attr_write a bit more readable.

diff --git a/fs/exec.c b/fs/exec.c
index 0e46ec5..2056562 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1078,14 +1078,26 @@ static int de_thread(struct task_struct *tsk)
 	struct signal_struct *sig = tsk->signal;
 	struct sighand_struct *oldsighand = tsk->sighand;
 	spinlock_t *lock = &oldsighand->siglock;
+	struct task_struct *t = tsk;
 
 	if (thread_group_empty(tsk))
 		goto no_thread_group;
 
+	spin_lock_irq(lock);
+	while_each_thread(tsk, t) {
+		if (unlikely(t->ptrace))
+			sig->unsafe_execve_in_progress = true;
+	}
+
+	if (unlikely(sig->unsafe_execve_in_progress)) {
+		spin_unlock_irq(lock);
+		mutex_unlock(&sig->exec_guard_mutex);
+		spin_lock_irq(lock);
+	}
+
 	/*
 	 * Kill all other threads in the thread group.
 	 */
-	spin_lock_irq(lock);
 	if (signal_group_exit(sig)) {
 		/*
 		 * Another group action in progress, just
@@ -1429,22 +1441,30 @@ void finalize_exec(struct linux_binprm *bprm)
 EXPORT_SYMBOL(finalize_exec);
 
 /*
- * Prepare credentials and lock ->cred_guard_mutex.
+ * Prepare credentials and lock ->exec_guard_mutex.
  * install_exec_creds() commits the new creds and drops the lock.
  * Or, if exec fails before, free_bprm() should release ->cred and
  * and unlock.
  */
 static int prepare_bprm_creds(struct linux_binprm *bprm)
 {
-	if (mutex_lock_interruptible(&current->signal->cred_guard_mutex))
+	int ret;
+
+	if (mutex_lock_interruptible(&current->signal->exec_guard_mutex))
 		return -ERESTARTNOINTR;
 
+	ret = -EAGAIN;
+	if (unlikely(current->signal->unsafe_execve_in_progress))
+		goto out;
+
 	bprm->cred = prepare_exec_creds();
 	if (likely(bprm->cred))
 		return 0;
 
-	mutex_unlock(&current->signal->cred_guard_mutex);
-	return -ENOMEM;
+	ret = -ENOMEM;
+out:
+	mutex_unlock(&current->signal->exec_guard_mutex);
+	return ret;
 }
 
 static void free_bprm(struct linux_binprm *bprm)
@@ -1453,7 +1473,10 @@ static void free_bprm(struct linux_binprm *bprm)
 	if (bprm->cred) {
 		if (bprm->called_exec_mmap)
 			mutex_unlock(&current->signal->exec_update_mutex);
-		mutex_unlock(&current->signal->cred_guard_mutex);
+		if (unlikely(current->signal->unsafe_execve_in_progress))
+			mutex_lock(&current->signal->exec_guard_mutex);
+		current->signal->unsafe_execve_in_progress = false;
+		mutex_unlock(&current->signal->exec_guard_mutex);
 		abort_creds(bprm->cred);
 	}
 	if (bprm->file) {
@@ -1497,19 +1520,22 @@ void install_exec_creds(struct linux_binprm *bprm)
 	if (get_dumpable(current->mm) != SUID_DUMP_USER)
 		perf_event_exit_task(current);
 	/*
-	 * cred_guard_mutex must be held at least to this point to prevent
+	 * exec_guard_mutex must be held at least to this point to prevent
 	 * ptrace_attach() from altering our determination of the task's
 	 * credentials; any time after this it may be unlocked.
 	 */
 	security_bprm_committed_creds(bprm);
 	mutex_unlock(&current->signal->exec_update_mutex);
-	mutex_unlock(&current->signal->cred_guard_mutex);
+	if (unlikely(current->signal->unsafe_execve_in_progress))
+		mutex_lock(&current->signal->exec_guard_mutex);
+	current->signal->unsafe_execve_in_progress = false;
+	mutex_unlock(&current->signal->exec_guard_mutex);
 }
 EXPORT_SYMBOL(install_exec_creds);
 
 /*
  * determine how safe it is to execute the proposed program
- * - the caller must hold ->cred_guard_mutex to protect against
+ * - the caller must hold ->exec_guard_mutex to protect against
  *   PTRACE_ATTACH or seccomp thread-sync
  */
 static void check_unsafe_exec(struct linux_binprm *bprm)
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 6b13fc4..eaca36e 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2680,14 +2680,30 @@ static ssize_t proc_pid_attr_write(struct file * file, const char __user * buf,
 	}
 
 	/* Guard against adverse ptrace interaction */
-	rv = mutex_lock_interruptible(&current->signal->cred_guard_mutex);
+	rv = mutex_lock_interruptible(&current->signal->exec_guard_mutex);
 	if (rv < 0)
 		goto out_free;
 
+	/*
+	 * BIG FAT WARNING - Fragile code ahead.
+	 * Please do not insert any code between these two
+	 * if statements.  It may happen that execve has to
+	 * release the exec_guard_mutex in order to prevent
+	 * deadlocks.  In that case unsafe_execve_in_progress
+	 * will be set.  If that happens you cannot assume that
+	 * the usual guarantees implied by exec_guard_mutex
+	 * are valid.  Just return -EAGAIN in that case and
+	 * unlock the mutex immediately.
+	 */
+	rv = -EAGAIN;
+	if (unlikely(current->signal->unsafe_execve_in_progress))
+		goto out_unlock;
+
 	rv = security_setprocattr(PROC_I(inode)->op.lsm,
 				  file->f_path.dentry->d_name.name, page,
 				  count);
-	mutex_unlock(&current->signal->cred_guard_mutex);
+out_unlock:
+	mutex_unlock(&current->signal->exec_guard_mutex);
 out_free:
 	kfree(page);
 out:
diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
index a29df79..e83cef2 100644
--- a/include/linux/sched/signal.h
+++ b/include/linux/sched/signal.h
@@ -212,6 +212,13 @@ struct signal_struct {
 #endif
 
 	/*
+	 * Set while execve is executing but is *not* holding
+	 * exec_guard_mutex to avoid possible dead-locks.
+	 * Only valid when exec_guard_mutex is held.
+	 */
+	bool unsafe_execve_in_progress;
+
+	/*
 	 * Thread is the potential origin of an oom condition; kill first on
 	 * oom
 	 */
@@ -222,11 +229,8 @@ struct signal_struct {
 	struct mm_struct *oom_mm;	/* recorded mm when the thread group got
 					 * killed by the oom killer */
 
-	struct mutex cred_guard_mutex;	/* guard against foreign influences on
-					 * credential calculations
-					 * (notably. ptrace)
-					 * Deprecated do not use in new code.
-					 * Use exec_update_mutex instead.
+	struct mutex exec_guard_mutex;	/* Held while execve runs, except when
+					 * a sibling thread is being traced.
 					 */
 	struct mutex exec_update_mutex;	/* Held while task_struct is being
 					 * updated during exec, and may have
diff --git a/init/init_task.c b/init/init_task.c
index bd403ed..6f96327 100644
--- a/init/init_task.c
+++ b/init/init_task.c
@@ -25,7 +25,7 @@
 	},
 	.multiprocess	= HLIST_HEAD_INIT,
 	.rlim		= INIT_RLIMITS,
-	.cred_guard_mutex = __MUTEX_INITIALIZER(init_signals.cred_guard_mutex),
+	.exec_guard_mutex = __MUTEX_INITIALIZER(init_signals.exec_guard_mutex),
 	.exec_update_mutex = __MUTEX_INITIALIZER(init_signals.exec_update_mutex),
 #ifdef CONFIG_POSIX_TIMERS
 	.posix_timers = LIST_HEAD_INIT(init_signals.posix_timers),
diff --git a/kernel/cred.c b/kernel/cred.c
index 71a7926..341ca59 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -295,7 +295,7 @@ struct cred *prepare_creds(void)
 
 /*
  * Prepare credentials for current to perform an execve()
- * - The caller must hold ->cred_guard_mutex
+ * - The caller must hold ->exec_guard_mutex
  */
 struct cred *prepare_exec_creds(void)
 {
diff --git a/kernel/fork.c b/kernel/fork.c
index e23ccac..98012f7 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1593,7 +1593,7 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 	sig->oom_score_adj = current->signal->oom_score_adj;
 	sig->oom_score_adj_min = current->signal->oom_score_adj_min;
 
-	mutex_init(&sig->cred_guard_mutex);
+	mutex_init(&sig->exec_guard_mutex);
 	mutex_init(&sig->exec_update_mutex);
 
 	return 0;
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 43d6179..19bf69f 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -392,9 +392,24 @@ static int ptrace_attach(struct task_struct *task, long request,
 	 * under ptrace.
 	 */
 	retval = -ERESTARTNOINTR;
-	if (mutex_lock_interruptible(&task->signal->cred_guard_mutex))
+	if (mutex_lock_interruptible(&task->signal->exec_guard_mutex))
 		goto out;
 
+	/*
+	 * BIG FAT WARNING - Fragile code ahead.
+	 * Please do not insert any code between these two
+	 * if statements.  It may happen that execve has to
+	 * release the exec_guard_mutex in order to prevent
+	 * deadlocks.  In that case unsafe_execve_in_progress
+	 * will be set.  If that happens you cannot assume that
+	 * the usual guarantees implied by exec_guard_mutex
+	 * are valid.  Just return -EAGAIN in that case and
+	 * unlock the mutex immediately.
+	 */
+	retval = -EAGAIN;
+	if (unlikely(task->signal->unsafe_execve_in_progress))
+		goto unlock_creds;
+
 	task_lock(task);
 	retval = __ptrace_may_access(task, PTRACE_MODE_ATTACH_REALCREDS);
 	task_unlock(task);
@@ -447,7 +462,7 @@ static int ptrace_attach(struct task_struct *task, long request,
 unlock_tasklist:
 	write_unlock_irq(&tasklist_lock);
 unlock_creds:
-	mutex_unlock(&task->signal->cred_guard_mutex);
+	mutex_unlock(&task->signal->exec_guard_mutex);
 out:
 	if (!retval) {
 		/*
@@ -472,10 +487,29 @@ static int ptrace_attach(struct task_struct *task, long request,
  */
 static int ptrace_traceme(void)
 {
-	int ret = -EPERM;
+	int ret;
+
+	if (mutex_lock_interruptible(&current->signal->exec_guard_mutex))
+		return -ERESTARTNOINTR;
+
+	/*
+	 * BIG FAT WARNING - Fragile code ahead.
+	 * Please do not insert any code between these two
+	 * if statements.  It may happen that execve has to
+	 * release the exec_guard_mutex in order to prevent
+	 * deadlocks.  In that case unsafe_execve_in_progress
+	 * will be set.  If that happens you cannot assume that
+	 * the usual guarantees implied by exec_guard_mutex
+	 * are valid.  Just return -EAGAIN in that case and
+	 * unlock the mutex immediately.
+	 */
+	ret = -EAGAIN;
+	if (unlikely(current->signal->unsafe_execve_in_progress))
+		goto unlock_creds;
 
 	write_lock_irq(&tasklist_lock);
 	/* Are we already being traced? */
+	ret = -EPERM;
 	if (!current->ptrace) {
 		ret = security_ptrace_traceme(current->parent);
 		/*
@@ -490,6 +524,8 @@ static int ptrace_traceme(void)
 	}
 	write_unlock_irq(&tasklist_lock);
 
+unlock_creds:
+	mutex_unlock(&current->signal->exec_guard_mutex);
 	return ret;
 }
 
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index b6ea3dc..7ebb194 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -329,7 +329,7 @@ static int is_ancestor(struct seccomp_filter *parent,
 /**
  * seccomp_can_sync_threads: checks if all threads can be synchronized
  *
- * Expects sighand and cred_guard_mutex locks to be held.
+ * Expects sighand and exec_guard_mutex locks to be held.
  *
  * Returns 0 on success, -ve on error, or the pid of a thread which was
  * either not in the correct seccomp mode or did not have an ancestral
@@ -339,9 +339,22 @@ static inline pid_t seccomp_can_sync_threads(void)
 {
 	struct task_struct *thread, *caller;
 
-	BUG_ON(!mutex_is_locked(&current->signal->cred_guard_mutex));
+	BUG_ON(!mutex_is_locked(&current->signal->exec_guard_mutex));
 	assert_spin_locked(&current->sighand->siglock);
 
+	/*
+	 * BIG FAT WARNING - Fragile code ahead.
+	 * It may happen that execve has to release the
+	 * exec_guard_mutex in order to prevent deadlocks.
+	 * In that case unsafe_execve_in_progress will be set.
+	 * If that happens you cannot assume that the usual
+	 * guarantees implied by exec_guard_mutex are valid.
+	 * Just return -EAGAIN in that case and unlock the mutex
+	 * immediately.
+	 */
+	if (unlikely(current->signal->unsafe_execve_in_progress))
+		return -EAGAIN;
+
 	/* Validate all threads being eligible for synchronization. */
 	caller = current;
 	for_each_thread(caller, thread) {
@@ -371,7 +384,7 @@ static inline pid_t seccomp_can_sync_threads(void)
 /**
  * seccomp_sync_threads: sets all threads to use current's filter
  *
- * Expects sighand and cred_guard_mutex locks to be held, and for
+ * Expects sighand and exec_guard_mutex locks to be held, and for
  * seccomp_can_sync_threads() to have returned success already
  * without dropping the locks.
  *
@@ -380,7 +393,7 @@ static inline void seccomp_sync_threads(unsigned long flags)
 {
 	struct task_struct *thread, *caller;
 
-	BUG_ON(!mutex_is_locked(&current->signal->cred_guard_mutex));
+	BUG_ON(!mutex_is_locked(&current->signal->exec_guard_mutex));
 	assert_spin_locked(&current->sighand->siglock);
 
 	/* Synchronize all threads. */
@@ -1319,7 +1332,7 @@ static long seccomp_set_mode_filter(unsigned int flags,
 	 * while another thread is in the middle of calling exec.
 	 */
 	if (flags & SECCOMP_FILTER_FLAG_TSYNC &&
-	    mutex_lock_killable(&current->signal->cred_guard_mutex))
+	    mutex_lock_killable(&current->signal->exec_guard_mutex))
 		goto out_put_fd;
 
 	spin_lock_irq(&current->sighand->siglock);
@@ -1337,7 +1350,7 @@ static long seccomp_set_mode_filter(unsigned int flags,
 out:
 	spin_unlock_irq(&current->sighand->siglock);
 	if (flags & SECCOMP_FILTER_FLAG_TSYNC)
-		mutex_unlock(&current->signal->cred_guard_mutex);
+		mutex_unlock(&current->signal->exec_guard_mutex);
 out_put_fd:
 	if (flags & SECCOMP_FILTER_FLAG_NEW_LISTENER) {
 		if (ret) {
-- 
1.9.1
