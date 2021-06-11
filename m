Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0628A3A45C5
	for <lists+stable@lfdr.de>; Fri, 11 Jun 2021 17:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbhFKP5R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Jun 2021 11:57:17 -0400
Received: from mail-oln040092073090.outbound.protection.outlook.com ([40.92.73.90]:16937
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229942AbhFKP5Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Jun 2021 11:57:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VOqlXsMU3Dn2RIEnjlakP+VB2Ez7sOBZ1DVHZvS9jl0QJNMoSkwvm/c+6mYQ/lln60ZquoayQM96rW15u83pbIuQ1WyFgtLfOGMRp5X5XHjVt6CgCVp6SusSPGyS8Q+k7esxlf+i0h3RS3ppnzeOk5fx3KtMhaU5bGRb8QWUkFdGTtWOTm91UGClj+zyhw2u9llOEXfknok8bJ6FcoSlGAHyWl95Pyy6MdMhh4MbCmPkQB6QmjBkcZoEv9BVjJUAB8fBs5GuA92/AKgy88f/WUPIDj4Qc5Qg1v2IzRDC0MwtSwcBEqdTImkpYwP7eU/HRYSAjnz9QA+XXtlIyvWjlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zls75ml2rTQwO5UREevvUsSWR1f1geC8e8GbcoHHQPE=;
 b=Ym8rrufvnUfviku+Gc4nfO9RUVCyzZ/0Y8JAphZkmp12An3wd2ON3xTw0zah0KIAauA5ykBItUeedavj4Ka74MXhpVVjVHtkpg1i57Hm7q0IliBVB73sB07Nhk/TN+K0FS/fI8/bxB//OYKVHhhSInseJQ+F6i4NheYBti+5/RoAQdvCIhUgEi0QwR8Yfugc4NH3XGir7xsSz4xhvU8/lpKPT0h5o9FvGaBzDJtjC6fkw5R7vBPPXxEK3NAE/RLI0s+n/rTkcepFCxukNzRCsGhfzJcVCGh6zRkOZ5Dzg+NmsdeXnHavobGDCBhK/WtGnHcWHBco72M+ZdG6ck6p8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from HE1EUR04FT040.eop-eur04.prod.protection.outlook.com
 (2a01:111:e400:7e0d::43) by
 HE1EUR04HT152.eop-eur04.prod.protection.outlook.com (2a01:111:e400:7e0d::378)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21; Fri, 11 Jun
 2021 15:55:15 +0000
Received: from AM8PR10MB4708.EURPRD10.PROD.OUTLOOK.COM
 (2a01:111:e400:7e0d::46) by HE1EUR04FT040.mail.protection.outlook.com
 (2a01:111:e400:7e0d::160) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend
 Transport; Fri, 11 Jun 2021 15:55:15 +0000
X-IncomingTopHeaderMarker: OriginalChecksum:E523485F68991B11A8E3C81C1C36A3C15D5AAB8283247CF74EA489FE3A694852;UpperCasedChecksum:604B6452DFC7E4EA2B64A05F62168AFED144E8DAA263525C9E6133D2D0DDD296;SizeAsReceived:8878;Count:47
Received: from AM8PR10MB4708.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::e5e5:7b7a:5ea5:c75a]) by AM8PR10MB4708.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::e5e5:7b7a:5ea5:c75a%7]) with mapi id 15.20.4219.021; Fri, 11 Jun 2021
 15:55:15 +0000
Subject: [PATCH v9] exec: Fix dead-lock in de_thread with ptrace_attach
To:     Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Will Drewry <wad@chromium.org>, Shuah Khan <shuah@kernel.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Michal Hocko <mhocko@suse.com>,
        Serge Hallyn <serge@hallyn.com>,
        James Morris <jamorris@linux.microsoft.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Charles Haithcock <chaithco@redhat.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Yafang Shao <laoar.shao@gmail.com>,
        Helge Deller <deller@gmx.de>,
        YiFei Zhu <yifeifz2@illinois.edu>,
        Adrian Reber <areber@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <AM8PR10MB4708AFBD838138A84CE89EF8E4359@AM8PR10MB4708.EURPRD10.PROD.OUTLOOK.COM>
 <20210610143642.e4535dbdc0db0b1bd3ee5367@linux-foundation.org>
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
Message-ID: <AM8PR10MB470896FBC519ABCC20486958E4349@AM8PR10MB4708.EURPRD10.PROD.OUTLOOK.COM>
Date:   Fri, 11 Jun 2021 17:55:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
In-Reply-To: <20210610143642.e4535dbdc0db0b1bd3ee5367@linux-foundation.org>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TMN:  [ezZKtTFUGXfP0TiuDGfeGQWyItmg+P36]
X-ClientProxiedBy: PR0P264CA0212.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1f::32) To AM8PR10MB4708.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:364::23)
X-Microsoft-Original-Message-ID: <7cdc99ef-19c0-1786-59dd-3ed17ad9dcfb@hotmail.de>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.101] (84.57.61.94) by PR0P264CA0212.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1f::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Fri, 11 Jun 2021 15:55:11 +0000
X-MS-PublicTrafficType: Email
X-IncomingHeaderCount: 47
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-Correlation-Id: 05382c65-83d3-45ef-909d-08d92cf14d22
X-MS-TrafficTypeDiagnostic: HE1EUR04HT152:
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3hEzKepBdR/NRRmD2VP7LYWvyCGKw07R8GRBG6ozXnQ5ry02ZSGeWF7FO1mSdyiLm2qKo0ZhKODPWDTjW9hB8Xm9rYGK/iNaQHR9JTK0GneSnwjhvOUWJDFdQm51pcRE0bVnWQhMGnLyyvJgNDFYfYJseuJw/OdpU7wMUwVyxF0kKE+4BTtVARnJ5uJPU+bjgpJnUs/RrG8m03i4YLBQquq07LNYVKkSmh1urs8XLhsNJN5SalcHwEZdAaMJ7QY3r8UoJsD2il9rQJ2sOAXnIhEh8VjkeGrSuPX78ETp0V+FU3g/GfcRLnVsLc0LMvM3klTzeWgOfNBb6TDyC6WB75y6XBSfATSjKIUhHS1bX220AjlVhaDuRaQM8nZTI+ajnHur7N8QK4/Hank3KdDKjRGnOQynplYpddKP2YWtnP98PmPpTCh/udAmj+fFYbDdhEPAT+sa29+fG2luaYK/bcrCrFW1YulieGkjus5Ll9g=
X-MS-Exchange-AntiSpam-MessageData: VgyyV7DYYEmBGkQw7YZAj1gy9mrXCGlPkvY+jjbJrywfvanA7OWU9JL9xXtSg7sfo77uqopM+9oipfZ7RyOhGbRBAEsJvjyeJNo+nU09unNMl2bolphrwYWxFM7APmM9y5tptzTkZG5T+/I0zhKGsg==
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05382c65-83d3-45ef-909d-08d92cf14d22
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2021 15:55:15.1507
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-AuthSource: HE1EUR04FT040.eop-eur04.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: Internet
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1EUR04HT152
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This introduces signal->unsafe_execve_in_progress,
which is used to fix the case when at least one of the
sibling threads is traced, and therefore the trace
process may dead-lock in ptrace_attach, but de_thread
will need to wait for the tracer to continue execution.

The solution is to detect this situation and allow
ptrace_attach to continue, while de_thread() is still
waiting for traced zombies to be eventually released.
When the current thread changed the ptrace status from
non-traced to traced, we can simply abort the whole
execve and restart it by returning -ERESTARTSYS.
This needs to be done before changing the thread leader,
because the PTRACE_EVENT_EXEC needs to know the old
thread pid.

Although it is technically after the point of no return,
we just have to reset bprm->point_of_no_return here,
since at this time only the other threads have received
a fatal signal, not the current thread.

From the user's point of view the whole execve was
simply delayed until after the ptrace_attach.

Other threads die quickly since the cred_guard_mutex
is released, but a deadly signal is already pending.
In case the mutex_lock_killable misses the signal,
->unsafe_execve_in_progress makes sure they release
the mutex immediately and return with -ERESTARTNOINTR.

This means there is no API change, unlike the previous
version of this patch which was discussed here:

https://lore.kernel.org/lkml/b6537ae6-31b1-5c50-f32b-8b8332ace882@hotmail.de/

See tools/testing/selftests/ptrace/vmaccess.c
for a test case that gets fixed by this change.

Note that since the test case was originally designed to
test the ptrace_attach returning an error in this situation,
the test expectation needed to be adjusted, to allow the
API to succeed at the first attempt.

Signed-off-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
---
 fs/exec.c                                 | 37 +++++++++++++++++++++++++++++--
 fs/proc/base.c                            |  6 +++++
 include/linux/sched/signal.h              | 13 +++++++++++
 kernel/ptrace.c                           |  9 ++++++++
 kernel/seccomp.c                          | 12 +++++++---
 tools/testing/selftests/ptrace/vmaccess.c | 25 ++++++++++++++-------
 6 files changed, 89 insertions(+), 13 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 8344fba..c7b1926 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1040,6 +1040,8 @@ static int de_thread(struct task_struct *tsk)
 	struct signal_struct *sig = tsk->signal;
 	struct sighand_struct *oldsighand = tsk->sighand;
 	spinlock_t *lock = &oldsighand->siglock;
+	unsigned int prev_ptrace = tsk->ptrace;
+	struct task_struct *t = tsk;
 
 	if (thread_group_empty(tsk))
 		goto no_thread_group;
@@ -1062,6 +1064,17 @@ static int de_thread(struct task_struct *tsk)
 	if (!thread_group_leader(tsk))
 		sig->notify_count--;
 
+	while_each_thread(tsk, t) {
+		if (unlikely(t->ptrace) && t != tsk->group_leader)
+			sig->unsafe_execve_in_progress = true;
+	}
+
+	if (unlikely(sig->unsafe_execve_in_progress)) {
+		spin_unlock_irq(lock);
+		mutex_unlock(&sig->cred_guard_mutex);
+		spin_lock_irq(lock);
+	}
+
 	while (sig->notify_count) {
 		__set_current_state(TASK_KILLABLE);
 		spin_unlock_irq(lock);
@@ -1072,6 +1085,17 @@ static int de_thread(struct task_struct *tsk)
 	}
 	spin_unlock_irq(lock);
 
+	if (unlikely(sig->unsafe_execve_in_progress)) {
+		if (mutex_lock_killable(&sig->cred_guard_mutex))
+			goto killed;
+		sig->unsafe_execve_in_progress = false;
+		if (!prev_ptrace && tsk->ptrace) {
+			sig->group_exit_task = NULL;
+			sig->notify_count = 0;
+			return -ERESTARTSYS;
+		}
+	}
+
 	/*
 	 * At this point all other threads have exited, all we have to
 	 * do is to wait for the thread group leader to become inactive,
@@ -1255,8 +1279,11 @@ int begin_new_exec(struct linux_binprm * bprm)
 	 * Make this the only thread in the thread group.
 	 */
 	retval = de_thread(me);
-	if (retval)
+	if (retval) {
+		if (retval == -ERESTARTSYS)
+			bprm->point_of_no_return = false;
 		goto out;
+	}
 
 	/*
 	 * Cancel any io_uring activity across execve
@@ -1466,6 +1493,11 @@ static int prepare_bprm_creds(struct linux_binprm *bprm)
 	if (mutex_lock_interruptible(&current->signal->cred_guard_mutex))
 		return -ERESTARTNOINTR;
 
+	if (unlikely(current->signal->unsafe_execve_in_progress)) {
+		mutex_unlock(&current->signal->cred_guard_mutex);
+		return -ERESTARTNOINTR;
+	}
+
 	bprm->cred = prepare_exec_creds();
 	if (likely(bprm->cred))
 		return 0;
@@ -1482,7 +1514,8 @@ static void free_bprm(struct linux_binprm *bprm)
 	}
 	free_arg_pages(bprm);
 	if (bprm->cred) {
-		mutex_unlock(&current->signal->cred_guard_mutex);
+		if (!current->signal->unsafe_execve_in_progress)
+			mutex_unlock(&current->signal->cred_guard_mutex);
 		abort_creds(bprm->cred);
 	}
 	if (bprm->file) {
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 3851bfc..3b2a55c 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2739,6 +2739,12 @@ static ssize_t proc_pid_attr_write(struct file * file, const char __user * buf,
 	if (rv < 0)
 		goto out_free;
 
+	if (unlikely(current->signal->unsafe_execve_in_progress)) {
+		mutex_unlock(&current->signal->cred_guard_mutex);
+		rv = -ERESTARTNOINTR;
+		goto out_free;
+	}
+
 	rv = security_setprocattr(PROC_I(inode)->op.lsm,
 				  file->f_path.dentry->d_name.name, page,
 				  count);
diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
index 3f6a0fc..220a083 100644
--- a/include/linux/sched/signal.h
+++ b/include/linux/sched/signal.h
@@ -214,6 +214,17 @@ struct signal_struct {
 #endif
 
 	/*
+	 * Set while execve is executing but is *not* holding
+	 * cred_guard_mutex to avoid possible dead-locks.
+	 * The cred_guard_mutex is released *after* de_thread() has
+	 * called zap_other_threads(), therefore a fatal signal is
+	 * guaranteed to be already pending in the unlikely event, that
+	 * current->signal->unsafe_execve_in_progress happens to be
+	 * true after the cred_guard_mutex was acquired.
+	 */
+	bool unsafe_execve_in_progress;
+
+	/*
 	 * Thread is the potential origin of an oom condition; kill first on
 	 * oom
 	 */
@@ -227,6 +238,8 @@ struct signal_struct {
 	struct mutex cred_guard_mutex;	/* guard against foreign influences on
 					 * credential calculations
 					 * (notably. ptrace)
+					 * Held while execve runs, except when
+					 * a sibling thread is being traced.
 					 * Deprecated do not use in new code.
 					 * Use exec_update_lock instead.
 					 */
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 61db50f..0cbc1eb 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -468,6 +468,14 @@ static int ptrace_traceme(void)
 {
 	int ret = -EPERM;
 
+	if (mutex_lock_interruptible(&current->signal->cred_guard_mutex))
+		return -ERESTARTNOINTR;
+
+	if (unlikely(current->signal->unsafe_execve_in_progress)) {
+		mutex_unlock(&current->signal->cred_guard_mutex);
+		return -ERESTARTNOINTR;
+	}
+
 	write_lock_irq(&tasklist_lock);
 	/* Are we already being traced? */
 	if (!current->ptrace) {
@@ -483,6 +491,7 @@ static int ptrace_traceme(void)
 		}
 	}
 	write_unlock_irq(&tasklist_lock);
+	mutex_unlock(&current->signal->cred_guard_mutex);
 
 	return ret;
 }
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 1d60fc2..b1389ee 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -1824,9 +1824,15 @@ static long seccomp_set_mode_filter(unsigned int flags,
 	 * Make sure we cannot change seccomp or nnp state via TSYNC
 	 * while another thread is in the middle of calling exec.
 	 */
-	if (flags & SECCOMP_FILTER_FLAG_TSYNC &&
-	    mutex_lock_killable(&current->signal->cred_guard_mutex))
-		goto out_put_fd;
+	if (flags & SECCOMP_FILTER_FLAG_TSYNC) {
+		if (mutex_lock_killable(&current->signal->cred_guard_mutex))
+			goto out_put_fd;
+
+		if (unlikely(current->signal->unsafe_execve_in_progress)) {
+			mutex_unlock(&current->signal->cred_guard_mutex);
+			goto out_put_fd;
+		}
+	}
 
 	spin_lock_irq(&current->sighand->siglock);
 
diff --git a/tools/testing/selftests/ptrace/vmaccess.c b/tools/testing/selftests/ptrace/vmaccess.c
index 4db327b..c7c2242 100644
--- a/tools/testing/selftests/ptrace/vmaccess.c
+++ b/tools/testing/selftests/ptrace/vmaccess.c
@@ -39,8 +39,15 @@ static void *thread(void *arg)
 	f = open(mm, O_RDONLY);
 	ASSERT_GE(f, 0);
 	close(f);
-	f = kill(pid, SIGCONT);
-	ASSERT_EQ(f, 0);
+	f = waitpid(-1, NULL, 0);
+	ASSERT_NE(f, -1);
+	ASSERT_NE(f, 0);
+	ASSERT_NE(f, pid);
+	f = waitpid(-1, NULL, 0);
+	ASSERT_EQ(f, pid);
+	f = waitpid(-1, NULL, 0);
+	ASSERT_EQ(f, -1);
+	ASSERT_EQ(errno, ECHILD);
 }
 
 TEST(attach)
@@ -57,22 +64,24 @@ static void *thread(void *arg)
 
 	sleep(1);
 	k = ptrace(PTRACE_ATTACH, pid, 0L, 0L);
-	ASSERT_EQ(errno, EAGAIN);
-	ASSERT_EQ(k, -1);
+	ASSERT_EQ(k, 0);
 	k = waitpid(-1, &s, WNOHANG);
 	ASSERT_NE(k, -1);
 	ASSERT_NE(k, 0);
 	ASSERT_NE(k, pid);
 	ASSERT_EQ(WIFEXITED(s), 1);
 	ASSERT_EQ(WEXITSTATUS(s), 0);
-	sleep(1);
-	k = ptrace(PTRACE_ATTACH, pid, 0L, 0L);
-	ASSERT_EQ(k, 0);
 	k = waitpid(-1, &s, 0);
 	ASSERT_EQ(k, pid);
 	ASSERT_EQ(WIFSTOPPED(s), 1);
 	ASSERT_EQ(WSTOPSIG(s), SIGSTOP);
-	k = ptrace(PTRACE_DETACH, pid, 0L, 0L);
+	k = ptrace(PTRACE_CONT, pid, 0L, 0L);
+	ASSERT_EQ(k, 0);
+	k = waitpid(-1, &s, 0);
+	ASSERT_EQ(k, pid);
+	ASSERT_EQ(WIFSTOPPED(s), 1);
+	ASSERT_EQ(WSTOPSIG(s), SIGTRAP);
+	k = ptrace(PTRACE_CONT, pid, 0L, 0L);
 	ASSERT_EQ(k, 0);
 	k = waitpid(-1, &s, 0);
 	ASSERT_EQ(k, pid);
-- 
1.9.1
