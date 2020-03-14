Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D60B1856D4
	for <lists+stable@lfdr.de>; Sun, 15 Mar 2020 02:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727077AbgCOBaE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Mar 2020 21:30:04 -0400
Received: from mail-oln040092065028.outbound.protection.outlook.com ([40.92.65.28]:1938
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727050AbgCOBaD (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 14 Mar 2020 21:30:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S8wzEONNYj+i5nqJILtLMFdIgk2xsR5diUdyl0j/llF+I8oV2ahSZI0Ueuw8cnjjJ9oUqXlmS8OvVgmRlbZ6wMpgbS+ZwMDIYPMQzCs7EIQQ58h6usm+QAN3X8erFZu81gduBNuPgeW9PRbgWI49On8egQGEHzoQU3l0cys5mcK23PlyJu7MCIPROsIqt/6hJa5MS0Lk3scfexokk9A60cbKlogNOJdBoUgdcXDmLuFLKV8UpCdQ0NP7XKwS9hUf0aDPKxKySiX7q40UjK8M6yLmB8t6oOAch6/l/hTqOoMD21pCAUk0IgUaPVO1SnvMlqEIJU5OInnBqtEQDa0LQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aQWV7K6+3M3gN5MtM5XTBxzVRYuEhMrr29I0KpA+cQc=;
 b=GX1zI0RnAivSA2w3pwN3+tIkKo2SwuA7tOeOPZ5ZarY9ekuJTXAq6xv/mskC7viH2i1UOPYzqHPb7+sJR3mzRWeVy+znETIfNLhPwNtXYUUCI1jvw81iN8EqXYuAjHxYvocpFeSll+fYhIo7gX8fFryvCwKdBYjmBfYSFYKC86L/PSO4/G+LXLGYejVgnF/HSpGebT9dlkWZCro6ulCqtyU0CHo/xuRV/ipVfcKDLv1npqG2K+ZfQ0Y71czXohElk2rmsQojqK/UafDxk+qLvD8gD0Ieto32//xs4xPHp+aoX3AUxibloTXbB9Coyr3g53uSLtICAk5DE7RoDN4hNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hotmail.de; dmarc=pass action=none header.from=hotmail.de;
 dkim=pass header.d=hotmail.de; arc=none
Received: from HE1EUR01FT018.eop-EUR01.prod.protection.outlook.com
 (2a01:111:e400:7e18::36) by
 HE1EUR01HT229.eop-EUR01.prod.protection.outlook.com (2a01:111:e400:7e18::471)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.14; Sat, 14 Mar
 2020 09:13:02 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.152.0.51) by
 HE1EUR01FT018.mail.protection.outlook.com (10.152.0.175) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.14 via Frontend Transport; Sat, 14 Mar 2020 09:13:02 +0000
X-IncomingTopHeaderMarker: OriginalChecksum:9874A653B683B2AE6740553C9DB31FD712F44B3CFF756D21E387F885308AEACA;UpperCasedChecksum:B3C560AACEDBF426AB4419F5DD0A0DE9D70C901630FD74FF017195B54C0223B2;SizeAsReceived:10353;Count:50
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2814.018; Sat, 14 Mar 2020
 09:13:02 +0000
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
Subject: [PATCH 1/2] exec: Fix dead-lock in de_thread with ptrace_attach
To:     Kirill Tkhai <ktkhai@virtuozzo.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Christian Brauner <christian.brauner@ubuntu.com>,
        Kees Cook <keescook@chromium.org>,
        Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Oleg Nesterov <oleg@redhat.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Andrei Vagin <avagin@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Yuyang Du <duyuyang@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        David Howells <dhowells@redhat.com>,
        James Morris <jamorris@linux.microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Shakeel Butt <shakeelb@google.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Christian Kellner <christian@kellner.me>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Aleksa Sarai <cyphar@cyphar.com>,
        "Dmitry V. Levin" <ldv@altlinux.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
References: <AM6PR03MB5170EB4427BF5C67EE98FF09E4E60@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87v9nlii0b.fsf@x220.int.ebiederm.org>
 <AM6PR03MB5170609D44967E044FD1BE40E4E40@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87a74xi4kz.fsf@x220.int.ebiederm.org>
 <AM6PR03MB51705AA3009B4986BB6EF92FE4E50@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87r1y8dqqz.fsf@x220.int.ebiederm.org>
 <AM6PR03MB517053AED7DC89F7C0704B7DE4E50@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <AM6PR03MB51703B44170EAB4626C9B2CAE4E20@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87tv32cxmf.fsf_-_@x220.int.ebiederm.org>
 <87v9ne5y4y.fsf_-_@x220.int.ebiederm.org>
 <87zhcq4jdj.fsf_-_@x220.int.ebiederm.org>
 <f37a5d68-9674-533f-ee9c-a49174605710@virtuozzo.com>
 <87d09hn4kt.fsf@x220.int.ebiederm.org>
 <dbce35c7-c060-cfd8-bde1-98fd9a0747a9@virtuozzo.com>
 <87lfo5lju6.fsf@x220.int.ebiederm.org>
 <AM6PR03MB5170E9E71B9F84330B098BADE4FA0@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <6002ac56-025a-d50f-e89d-1bf42a072323@virtuozzo.com>
Message-ID: <AM6PR03MB517026B0029290DD1CBDB7C9E4FB0@AM6PR03MB5170.eurprd03.prod.outlook.com>
Date:   Sat, 14 Mar 2020 10:12:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
In-Reply-To: <6002ac56-025a-d50f-e89d-1bf42a072323@virtuozzo.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0015.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:16::25) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
X-Microsoft-Original-Message-ID: <d34886d6-0436-839e-ac81-fa2db3a3e051@hotmail.de>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.101] (92.77.140.102) by ZR0P278CA0015.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:16::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.13 via Frontend Transport; Sat, 14 Mar 2020 09:13:00 +0000
X-Microsoft-Original-Message-ID: <d34886d6-0436-839e-ac81-fa2db3a3e051@hotmail.de>
X-TMN:  [JV5Rp9V8izNxMMC4Xu4j7QTWfk9lx0hD]
X-MS-PublicTrafficType: Email
X-IncomingHeaderCount: 50
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-Correlation-Id: b89af16d-a0a9-4ef3-e317-08d7c7f7e598
X-MS-TrafficTypeDiagnostic: HE1EUR01HT229:
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YZ5EDCtWGGspf2dUHOBsy8Uxo0I+LTFzMQ+CCFsNGh4TkWybo2phWOrg1Vs4yi7VbPPIOf89HVekrMI6r5DFnqAbmjViQnXyi8maz2FPB0KAw1w8aJjQ7SJn1mZ0FgZM6/bVCEmc4meGDZ67PvxIW4/i72bT6ew2VwFF8bAXEAZ9rr+WVFMsQNj2kQsGo8+W
X-MS-Exchange-AntiSpam-MessageData: 3Mlawo9jDqkiQ24bBGf88oK04cHc1ZXx4wadlzrdt+7yY+F+5dDUde7RLmsuG1QXQVNjPwIInujEi9HjtOhVld+bHznSlKaDPY3wqR/z3Owm4q/tLQRy/BEMfLIm1BiZYnLqDWmSY9HNEwQlUW2lrA==
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b89af16d-a0a9-4ef3-e317-08d7c7f7e598
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2020 09:13:02.2953
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-FromEntityHeader: Internet
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1EUR01HT229
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
 fs/proc/base.c               | 13 ++++++++-----
 include/linux/sched/signal.h | 14 +++++++++-----
 init/init_task.c             |  2 +-
 kernel/cred.c                |  2 +-
 kernel/fork.c                |  2 +-
 kernel/ptrace.c              | 20 +++++++++++++++++---
 kernel/seccomp.c             | 15 +++++++++------
 8 files changed, 81 insertions(+), 31 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 11974a1..6b78518 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1073,14 +1073,26 @@ static int de_thread(struct task_struct *tsk)
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
@@ -1424,22 +1436,30 @@ void finalize_exec(struct linux_binprm *bprm)
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
@@ -1448,7 +1468,10 @@ static void free_bprm(struct linux_binprm *bprm)
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
@@ -1492,19 +1515,22 @@ void install_exec_creds(struct linux_binprm *bprm)
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
index 6b13fc4..a428536 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2680,14 +2680,17 @@ static ssize_t proc_pid_attr_write(struct file * file, const char __user * buf,
 	}
 
 	/* Guard against adverse ptrace interaction */
-	rv = mutex_lock_interruptible(&current->signal->cred_guard_mutex);
+	rv = mutex_lock_interruptible(&current->signal->exec_guard_mutex);
 	if (rv < 0)
 		goto out_free;
 
-	rv = security_setprocattr(PROC_I(inode)->op.lsm,
-				  file->f_path.dentry->d_name.name, page,
-				  count);
-	mutex_unlock(&current->signal->cred_guard_mutex);
+	if (unlikely(current->signal->unsafe_execve_in_progress))
+		rv = -EAGAIN;
+	else
+		rv = security_setprocattr(PROC_I(inode)->op.lsm,
+					  file->f_path.dentry->d_name.name,
+					  page, count);
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
index 43d6179..221759e 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -392,9 +392,13 @@ static int ptrace_attach(struct task_struct *task, long request,
 	 * under ptrace.
 	 */
 	retval = -ERESTARTNOINTR;
-	if (mutex_lock_interruptible(&task->signal->cred_guard_mutex))
+	if (mutex_lock_interruptible(&task->signal->exec_guard_mutex))
 		goto out;
 
+	retval = -EAGAIN;
+	if (unlikely(task->signal->unsafe_execve_in_progress))
+		goto unlock_creds;
+
 	task_lock(task);
 	retval = __ptrace_may_access(task, PTRACE_MODE_ATTACH_REALCREDS);
 	task_unlock(task);
@@ -447,7 +451,7 @@ static int ptrace_attach(struct task_struct *task, long request,
 unlock_tasklist:
 	write_unlock_irq(&tasklist_lock);
 unlock_creds:
-	mutex_unlock(&task->signal->cred_guard_mutex);
+	mutex_unlock(&task->signal->exec_guard_mutex);
 out:
 	if (!retval) {
 		/*
@@ -472,10 +476,18 @@ static int ptrace_attach(struct task_struct *task, long request,
  */
 static int ptrace_traceme(void)
 {
-	int ret = -EPERM;
+	int ret;
+
+	if (mutex_lock_interruptible(&current->signal->exec_guard_mutex))
+		return -ERESTARTNOINTR;
+
+	ret = -EAGAIN;
+	if (unlikely(current->signal->unsafe_execve_in_progress))
+		goto unlock_creds;
 
 	write_lock_irq(&tasklist_lock);
 	/* Are we already being traced? */
+	ret = -EPERM;
 	if (!current->ptrace) {
 		ret = security_ptrace_traceme(current->parent);
 		/*
@@ -490,6 +502,8 @@ static int ptrace_traceme(void)
 	}
 	write_unlock_irq(&tasklist_lock);
 
+unlock_creds:
+	mutex_unlock(&current->signal->exec_guard_mutex);
 	return ret;
 }
 
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index b6ea3dc..acd6960 100644
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
@@ -339,9 +339,12 @@ static inline pid_t seccomp_can_sync_threads(void)
 {
 	struct task_struct *thread, *caller;
 
-	BUG_ON(!mutex_is_locked(&current->signal->cred_guard_mutex));
+	BUG_ON(!mutex_is_locked(&current->signal->exec_guard_mutex));
 	assert_spin_locked(&current->sighand->siglock);
 
+	if (unlikely(current->signal->unsafe_execve_in_progress))
+		return -EAGAIN;
+
 	/* Validate all threads being eligible for synchronization. */
 	caller = current;
 	for_each_thread(caller, thread) {
@@ -371,7 +374,7 @@ static inline pid_t seccomp_can_sync_threads(void)
 /**
  * seccomp_sync_threads: sets all threads to use current's filter
  *
- * Expects sighand and cred_guard_mutex locks to be held, and for
+ * Expects sighand and exec_guard_mutex locks to be held, and for
  * seccomp_can_sync_threads() to have returned success already
  * without dropping the locks.
  *
@@ -380,7 +383,7 @@ static inline void seccomp_sync_threads(unsigned long flags)
 {
 	struct task_struct *thread, *caller;
 
-	BUG_ON(!mutex_is_locked(&current->signal->cred_guard_mutex));
+	BUG_ON(!mutex_is_locked(&current->signal->exec_guard_mutex));
 	assert_spin_locked(&current->sighand->siglock);
 
 	/* Synchronize all threads. */
@@ -1319,7 +1322,7 @@ static long seccomp_set_mode_filter(unsigned int flags,
 	 * while another thread is in the middle of calling exec.
 	 */
 	if (flags & SECCOMP_FILTER_FLAG_TSYNC &&
-	    mutex_lock_killable(&current->signal->cred_guard_mutex))
+	    mutex_lock_killable(&current->signal->exec_guard_mutex))
 		goto out_put_fd;
 
 	spin_lock_irq(&current->sighand->siglock);
@@ -1337,7 +1340,7 @@ static long seccomp_set_mode_filter(unsigned int flags,
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
