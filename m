Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3065218DDBE
	for <lists+stable@lfdr.de>; Sat, 21 Mar 2020 03:51:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727926AbgCUCvV convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 20 Mar 2020 22:51:21 -0400
Received: from mail-am6eur05olkn2013.outbound.protection.outlook.com ([40.92.91.13]:52993
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727832AbgCUCvV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Mar 2020 22:51:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GkcjTtZyC725zHA5Er8F7OgVXCGjm+84rgygVAzoMErbM9DGm8Z8zexf2yf5hbrkvZFlelZoMKykiQDsKUVPgU47sJsl3XUmUB6YKNNFvAOddxhD/7RZm8RUMeiJFNyXMNTeuXO8fpT2iQLvdoIz1jPKI7Hdw6cyJ7ks8IEjA63u07fu07Ayq9oDC7CSwXUyvmrG3+46uNkcblbm11MdiGUG0UMhgcsF5HlRQLSQ5kqjknA0qZ9NeTV8QmuQVTynzm++2I50+iUXeaAfKjuP7lqSO9OoBsVrQeQil4nNK4g/dWIcyuRSlv8as2OS+/4Bwib2kcZPzbI8qMoyHI8NeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HrAGETUOOR00oWkTH1jVZj3wNsKFfXHc2eWH+SBowEY=;
 b=YDrHQ5NZfzHrzhGDDDMv6jqqviaz4ccgpXwvncunyqLNVgXc4pqt2jaEOXOG0JEX8/9iq619hr0UItKqd1TTrSCJ1XBlfclW3yZlotDgx9acBQDNngERVfyqFvVRNRebCALqrc7w3gdy+ZvXKJJSq+fHNAqlHDoY6uzUajHD+X0962W0GJq67EgwoV42A9tCCVL5s/YA2RBxprfrImPQ+QHLkvOLVAwCfr3PNKXshNfGawhrEVjfBFbPMerjsynWZqm7Parw3NM7pXh+B4tARIhFMUC6mPVPrI/G+eNCTaspAdbVIabhvbSorVh11BNQ2wzw4TJOLtNXBFgv3f9Nhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from VI1EUR05FT062.eop-eur05.prod.protection.outlook.com
 (2a01:111:e400:fc12::3a) by
 VI1EUR05HT017.eop-eur05.prod.protection.outlook.com (2a01:111:e400:fc12::128)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.13; Sat, 21 Mar
 2020 02:46:39 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.233.242.53) by
 VI1EUR05FT062.mail.protection.outlook.com (10.233.243.189) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.13 via Frontend Transport; Sat, 21 Mar 2020 02:46:39 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2835.017; Sat, 21 Mar 2020
 02:46:39 +0000
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
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
Subject: [PATCH v6 15/16] exec: Fix dead-lock in de_thread with ptrace_attach
Thread-Topic: [PATCH v6 15/16] exec: Fix dead-lock in de_thread with
 ptrace_attach
Thread-Index: AQHV/vVBkMzNaks2Z02xBb/IaJAhLA==
Date:   Sat, 21 Mar 2020 02:46:39 +0000
Message-ID: <b6537ae6-31b1-5c50-f32b-8b8332ace882@hotmail.de>
References: <077b63b7-6f5e-aa8e-bf96-a586b481cc46@hotmail.de>
In-Reply-To: <077b63b7-6f5e-aa8e-bf96-a586b481cc46@hotmail.de>
Accept-Language: en-US, en-GB, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-imapappendstamp: AM6PR03MB5170.eurprd03.prod.outlook.com
 (15.20.2835.016)
x-incomingtopheadermarker: OriginalChecksum:489F560D31A1C03A99AF43DDB9F7AC0F40B81002AF4B969270706C8F2B0A34EA;UpperCasedChecksum:71D2817F1CE3405C3F7E3BE2D36765A7F89AA81C1164C162EB5CA1AE362A08F4;SizeAsReceived:8494;Count:46
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [8lfxNVI790QoilAR3tkzuvxYtUCcE/vl]
x-ms-publictraffictype: Email
x-incomingheadercount: 46
x-eopattributedmessage: 0
x-ms-office365-filtering-correlation-id: 860235a6-2396-4787-2d80-08d7cd4214bf
x-ms-traffictypediagnostic: VI1EUR05HT017:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XvY6Ur0KiRHbEoS08p5oa/K5trBg8Lv8svneO6lKgIKSl0weqxGhiyutGsMtn7FsGT2mt+3q85wDmWKHr+XGavNyGrgdIopDSz1oP0BXOJiGDeGI20naiFAr5iFjFssRb9zt38XQlSTWSjtd+WEyZys9xQ5lHW7V12xDC2zUkbSLOT4OWHrD4dCnM4NyfNsB
x-ms-exchange-antispam-messagedata: rGLddUF8Lm8FlsKEBeWCHAcUcyCGsLRU/puBpeKF5om/44q7+N9KfRx89qquxPNvgSZIedeRs8sgMJGGzDjWI5PM5py8uKOvGz33jhhJKoyjmYFWS3MuNlLCDVOICuoGCLYHhyBJuO774fYny62YHw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <5BDE9C7CED3FA9408FFFAFF6E15DC696@sct-15-20-2387-20-msonline-outlook-45755.templateTenant>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 860235a6-2396-4787-2d80-08d7cd4214bf
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Mar 2020 02:46:39.4444
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1EUR05HT017
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
