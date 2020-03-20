Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1566C18D916
	for <lists+stable@lfdr.de>; Fri, 20 Mar 2020 21:25:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727060AbgCTUZt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Mar 2020 16:25:49 -0400
Received: from mail-oln040092075017.outbound.protection.outlook.com ([40.92.75.17]:12148
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726738AbgCTUZs (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Mar 2020 16:25:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KmTGzuvO0uXW38YTmE6WtkpHdM8f2OHfgpuW2s7arDHmTPXYYL7bIWmHVOuQNrLX+SP+WX7U5Z5qutvk7SuAM1EnzYrb03pqTMnqH483Q0VH3Ya6dK5ny1sS/RqLNSuCZ0MIwHoer1ZhJmZu6gx9dg5t6iFidVrJmcRnkoVnBYPZd0uNR8q9JpiZ4j/r3JDJpZwJXD80GbnuARPBzggnkt4tOly9sOlE8scfHU4MvXR80XRUsvtXoaGcRknRe19Y2m+FWZxLOU+5epFh87k0J59QTe893O1qAWV/ZZ+0TetNUJpwHeGfwcKYK8k09w0htMX4ovA9to6twWxJkWmuKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6J/ubmx2d4kWZ0sG5Imo3mfA5zCFWhbG7a0P/km2dnc=;
 b=U8Fp5aojcOKmgGsf076fH+JRbN9ZAvPbNyVf+ycIklcc0U8mHNqrRWhkIyNoyODXWSD8PQCHMGD+uGOpCYvyMn9nQfgBX0p/6VIHWTWr++uwhS62kmPTJWXOVKhEgu/LYAigV3dxXOeJZgsoCdOhj8Hf8MJMNIhbierxTxqKnA41YkL0rx1+qHeLyMOwkhXXsMS1sM6Y845hc1OqG74+YIIXIiU48Dw51G3B1jcaJpl9Rl50IhgVyW7RLcHBRLAsQPXBCoYLDQu9gORPatAzAkttizi4W/16ZS/9WDhNdGFlaSy7lrET2RbUuBWhacFl2Xmmz5aDYbYCv8Md69w8DQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hotmail.de; dmarc=pass action=none header.from=hotmail.de;
 dkim=pass header.d=hotmail.de; arc=none
Received: from DB3EUR04FT027.eop-eur04.prod.protection.outlook.com
 (2a01:111:e400:7e0c::3b) by
 DB3EUR04HT152.eop-eur04.prod.protection.outlook.com (2a01:111:e400:7e0c::93)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.13; Fri, 20 Mar
 2020 20:25:43 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.152.24.52) by
 DB3EUR04FT027.mail.protection.outlook.com (10.152.24.122) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.13 via Frontend Transport; Fri, 20 Mar 2020 20:25:43 +0000
X-IncomingTopHeaderMarker: OriginalChecksum:938A878B33C54E94B33F16CFDF8DE31BE0B77B50221A6B90CE3ACA03D2FFD16E;UpperCasedChecksum:28CBA51E653FE992FE6BA905D88A11914811A9C2B6A2890CF919629F3A3975DC;SizeAsReceived:9406;Count:49
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2835.017; Fri, 20 Mar 2020
 20:25:43 +0000
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
Subject: [PATCH v6 05/16] exec: Add exec_update_mutex to replace
 cred_guard_mutex
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
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
References: <077b63b7-6f5e-aa8e-bf96-a586b481cc46@hotmail.de>
Message-ID: <AM6PR03MB5170739C1B582B37E637279EE4F50@AM6PR03MB5170.eurprd03.prod.outlook.com>
Date:   Fri, 20 Mar 2020 21:25:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
In-Reply-To: <077b63b7-6f5e-aa8e-bf96-a586b481cc46@hotmail.de>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0019.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:14::6) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
X-Microsoft-Original-Message-ID: <449f3beb-33c5-43d6-508e-374c7d7a7548@hotmail.de>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.101] (92.77.140.102) by FR2P281CA0019.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:14::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.15 via Frontend Transport; Fri, 20 Mar 2020 20:25:41 +0000
X-Microsoft-Original-Message-ID: <449f3beb-33c5-43d6-508e-374c7d7a7548@hotmail.de>
X-TMN:  [d0YMkjymvrLRk0hY7gEzH4bQUCiQwa8U]
X-MS-PublicTrafficType: Email
X-IncomingHeaderCount: 49
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-Correlation-Id: ef738a95-1c99-4f45-8cf6-08d7cd0cdd07
X-MS-TrafficTypeDiagnostic: DB3EUR04HT152:
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lyYqO+4oi8hE8Ta00lmULzTkfgkcj89ypkJXeu/mygeYnLYlpsoh8eUpkeCLh3d4vbZAYu4b/HuAZt1E2d4TsZhfvM/dl6j7T7noeVb7kMfT4RHBNjaBmAqufffG5i+UCJNO534YUEUMJ6QStJFI1nXHE96u/F2a6mSjoayMm6purrfYo/9hP/EJmANWYMgNFXbP3exjA6FmY5C3nD8k1VGMlT6MhIqUz7wJn66+2XA=
X-MS-Exchange-AntiSpam-MessageData: s1IWQSwVR2DFQPt1fe+Zr84twgMg44WqDzHLpPa+J1bzRaP0aTND6QwmKx0BZj3UKYC5z0rdMDhdgbVGNb5eJ6Tfln4JhcV5xyzf64e6SIyNJ1Xfu+s030ehfpcJUP844K/bE1sf2ujw5j10X2DFbw==
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef738a95-1c99-4f45-8cf6-08d7cd0cdd07
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2020 20:25:43.0684
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-FromEntityHeader: Internet
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3EUR04HT152
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The cred_guard_mutex is problematic as it is held over possibly
indefinite waits for userspace.  The possible indefinite waits for
userspace that I have identified are: The cred_guard_mutex is held in
PTRACE_EVENT_EXIT waiting for the tracer.  The cred_guard_mutex is
held over "put_user(0, tsk->clear_child_tid)" in exit_mm().  The
cred_guard_mutex is held over "get_user(futex_offset, ...")  in
exit_robust_list.  The cred_guard_mutex held over copy_strings.

The functions get_user and put_user can trigger a page fault which can
potentially wait indefinitely in the case of userfaultfd or if
userspace implements part of the page fault path.

In any of those cases the userspace process that the kernel is waiting
for might make a different system call that winds up taking the
cred_guard_mutex and result in deadlock.

Holding a mutex over any of those possibly indefinite waits for
userspace does not appear necessary.  Add exec_update_mutex that will
just cover updating the process during exec where the permissions and
the objects pointed to by the task struct may be out of sync.

The plan is to switch the users of cred_guard_mutex to
exec_update_mutex one by one.  This lets us move forward while still
being careful and not introducing any regressions.

Link: https://lore.kernel.org/lkml/20160921152946.GA24210@dhcp22.suse.cz/
Link: https://lore.kernel.org/lkml/AM6PR03MB5170B06F3A2B75EFB98D071AE4E60@AM6PR03MB5170.eurprd03.prod.outlook.com/
Link: https://lore.kernel.org/linux-fsdevel/20161102181806.GB1112@redhat.com/
Link: https://lore.kernel.org/lkml/20160923095031.GA14923@redhat.com/
Link: https://lore.kernel.org/lkml/20170213141452.GA30203@redhat.com/
Ref: 45c1a159b85b ("Add PTRACE_O_TRACEVFORKDONE and PTRACE_O_TRACEEXIT facilities.")
Ref: 456f17cd1a28 ("[PATCH] user-vm-unlock-2.5.31-A2")
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
---
 fs/exec.c                    | 22 +++++++++++++++++++---
 include/linux/binfmts.h      |  8 +++++++-
 include/linux/sched/signal.h |  9 ++++++++-
 init/init_task.c             |  1 +
 kernel/fork.c                |  1 +
 5 files changed, 36 insertions(+), 5 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index d820a72..0e46ec5 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1010,16 +1010,26 @@ ssize_t read_code(struct file *file, unsigned long addr, loff_t pos, size_t len)
 }
 EXPORT_SYMBOL(read_code);
 
+/*
+ * Maps the mm_struct mm into the current task struct.
+ * On success, this function returns with the mutex
+ * exec_update_mutex locked.
+ */
 static int exec_mmap(struct mm_struct *mm)
 {
 	struct task_struct *tsk;
 	struct mm_struct *old_mm, *active_mm;
+	int ret;
 
 	/* Notify parent that we're no longer interested in the old VM */
 	tsk = current;
 	old_mm = current->mm;
 	exec_mm_release(tsk, old_mm);
 
+	ret = mutex_lock_killable(&tsk->signal->exec_update_mutex);
+	if (ret)
+		return ret;
+
 	if (old_mm) {
 		sync_mm_rss(old_mm);
 		/*
@@ -1031,9 +1041,11 @@ static int exec_mmap(struct mm_struct *mm)
 		down_read(&old_mm->mmap_sem);
 		if (unlikely(old_mm->core_state)) {
 			up_read(&old_mm->mmap_sem);
+			mutex_unlock(&tsk->signal->exec_update_mutex);
 			return -EINTR;
 		}
 	}
+
 	task_lock(tsk);
 	active_mm = tsk->active_mm;
 	membarrier_exec_mmap(mm);
@@ -1288,11 +1300,12 @@ int flush_old_exec(struct linux_binprm * bprm)
 		goto out;
 
 	/*
-	 * After clearing bprm->mm (to mark that current is using the
-	 * prepared mm now), we have nothing left of the original
+	 * After setting bprm->called_exec_mmap (to mark that current is
+	 * using the prepared mm now), we have nothing left of the original
 	 * process. If anything from here on returns an error, the check
 	 * in search_binary_handler() will SEGV current.
 	 */
+	bprm->called_exec_mmap = 1;
 	bprm->mm = NULL;
 
 #ifdef CONFIG_POSIX_TIMERS
@@ -1438,6 +1451,8 @@ static void free_bprm(struct linux_binprm *bprm)
 {
 	free_arg_pages(bprm);
 	if (bprm->cred) {
+		if (bprm->called_exec_mmap)
+			mutex_unlock(&current->signal->exec_update_mutex);
 		mutex_unlock(&current->signal->cred_guard_mutex);
 		abort_creds(bprm->cred);
 	}
@@ -1487,6 +1502,7 @@ void install_exec_creds(struct linux_binprm *bprm)
 	 * credentials; any time after this it may be unlocked.
 	 */
 	security_bprm_committed_creds(bprm);
+	mutex_unlock(&current->signal->exec_update_mutex);
 	mutex_unlock(&current->signal->cred_guard_mutex);
 }
 EXPORT_SYMBOL(install_exec_creds);
@@ -1678,7 +1694,7 @@ int search_binary_handler(struct linux_binprm *bprm)
 
 		read_lock(&binfmt_lock);
 		put_binfmt(fmt);
-		if (retval < 0 && !bprm->mm) {
+		if (retval < 0 && bprm->called_exec_mmap) {
 			/* we got to flush_old_exec() and failed after it */
 			read_unlock(&binfmt_lock);
 			force_sigsegv(SIGSEGV);
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index b40fc63..a345d9f 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -44,7 +44,13 @@ struct linux_binprm {
 		 * exec has happened. Used to sanitize execution environment
 		 * and to set AT_SECURE auxv for glibc.
 		 */
-		secureexec:1;
+		secureexec:1,
+		/*
+		 * Set by flush_old_exec, when exec_mmap has been called.
+		 * This is past the point of no return, when the
+		 * exec_update_mutex has been taken.
+		 */
+		called_exec_mmap:1;
 #ifdef __alpha__
 	unsigned int taso:1;
 #endif
diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
index 8805025..a29df79 100644
--- a/include/linux/sched/signal.h
+++ b/include/linux/sched/signal.h
@@ -224,7 +224,14 @@ struct signal_struct {
 
 	struct mutex cred_guard_mutex;	/* guard against foreign influences on
 					 * credential calculations
-					 * (notably. ptrace) */
+					 * (notably. ptrace)
+					 * Deprecated do not use in new code.
+					 * Use exec_update_mutex instead.
+					 */
+	struct mutex exec_update_mutex;	/* Held while task_struct is being
+					 * updated during exec, and may have
+					 * inconsistent permissions.
+					 */
 } __randomize_layout;
 
 /*
diff --git a/init/init_task.c b/init/init_task.c
index 9e5cbe5..bd403ed 100644
--- a/init/init_task.c
+++ b/init/init_task.c
@@ -26,6 +26,7 @@
 	.multiprocess	= HLIST_HEAD_INIT,
 	.rlim		= INIT_RLIMITS,
 	.cred_guard_mutex = __MUTEX_INITIALIZER(init_signals.cred_guard_mutex),
+	.exec_update_mutex = __MUTEX_INITIALIZER(init_signals.exec_update_mutex),
 #ifdef CONFIG_POSIX_TIMERS
 	.posix_timers = LIST_HEAD_INIT(init_signals.posix_timers),
 	.cputimer	= {
diff --git a/kernel/fork.c b/kernel/fork.c
index 8642530..036b692 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1594,6 +1594,7 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 	sig->oom_score_adj_min = current->signal->oom_score_adj_min;
 
 	mutex_init(&sig->cred_guard_mutex);
+	mutex_init(&sig->exec_update_mutex);
 
 	return 0;
 }
-- 
1.9.1
