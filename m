Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E18D1179B5B
	for <lists+stable@lfdr.de>; Wed,  4 Mar 2020 22:56:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388451AbgCDV4n convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 4 Mar 2020 16:56:43 -0500
Received: from mail-vi1eur05olkn2077.outbound.protection.outlook.com ([40.92.90.77]:53984
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727528AbgCDV4n (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Mar 2020 16:56:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S+lFazqYCAUyCP8Yq9en9VCxZwcllQqWHTUZ+3oaGVuhPDgnGvQhs11e+iYw4tAh2RZaHz2fK9eAAL2XlzV+Dvxd4WEEoMB+7j5qIZJGejaqCYFvol7vqFfpi/8Bg4bQrYKWFIkXEVfPEKxvoKUpJfdRyXRj9IOu1UBxmvnOZNrvGNTIPedt77vJLnYqUUb2e/W7LE00fYv8Rooo8sJHf4+K1fHJW1ammSLrC0n0g47ZJWIIWtD154UQF2Do8W+7KjD8CM+t9cM1/Pu2i/0f40oqoyZWbUATuaNf/PGJyr+aR9pJja/aOQDdYkJ0FGG82cscdiZxI041Bx8a8KQFSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AMyIwWGq/mhgq1UxwXX7PA6T6vHssilL65djFRHCkdA=;
 b=aLF14AIzSBBfChDGze0UNfP9WSzkhNTOW9A8CIA956kpKjN/pqENmWw7+i1XIgt/95Ib6HxMBuJWzexodi3NV+xYpgGdjldnqKRqzX/chA1jms2BXYsNDLGCC/bV0L8AVEHuutV4vNSfXCWKlnMDBNYrf0n70XC5vBR13VfFkYj3eN3wR2D2ZGTBU3EpzQdr51R4M0jjGB771hXjMdxlcwKRlVxdsZXIZbLkXrlzvzMxNJP05kJ9p0CL59IyddJhYMdc2IZR9wmGx53aWiqzJ7E+sfMM6XAZiXLIQ2giF1ORxA31TtCYIksFpp164p7X6jLCm0rjanwW5Yk6a235Nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from DB8EUR05FT056.eop-eur05.prod.protection.outlook.com
 (2a01:111:e400:fc0f::3b) by
 DB8EUR05HT151.eop-eur05.prod.protection.outlook.com (2a01:111:e400:fc0f::138)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.11; Wed, 4 Mar
 2020 21:56:18 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.233.238.54) by
 DB8EUR05FT056.mail.protection.outlook.com (10.233.238.156) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.11 via Frontend Transport; Wed, 4 Mar 2020 21:56:18 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2772.019; Wed, 4 Mar 2020
 21:56:18 +0000
Received: from [192.168.1.101] (92.77.140.102) by ZR0P278CA0011.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:16::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.14 via Frontend Transport; Wed, 4 Mar 2020 21:56:15 +0000
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
CC:     Christian Brauner <christian.brauner@ubuntu.com>,
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
Subject: [PATCHv6] exec: Fix a deadlock in ptrace
Thread-Topic: [PATCHv6] exec: Fix a deadlock in ptrace
Thread-Index: AQHV8m+7BrfnobQhVEKxcy9pzNZ2yw==
Date:   Wed, 4 Mar 2020 21:56:17 +0000
Message-ID: <AM6PR03MB517053AED7DC89F7C0704B7DE4E50@AM6PR03MB5170.eurprd03.prod.outlook.com>
References: <AM6PR03MB5170EB4427BF5C67EE98FF09E4E60@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <AM6PR03MB517071DEF894C3D72D2B4AE2E4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87k142lpfz.fsf@x220.int.ebiederm.org>
 <AM6PR03MB51704206634C009500A8080DE4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <875zfmloir.fsf@x220.int.ebiederm.org>
 <AM6PR03MB51707ABF20B6CBBECC34865FE4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87v9nmjulm.fsf@x220.int.ebiederm.org>
 <AM6PR03MB5170B976E6387FDDAD59A118E4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <202003021531.C77EF10@keescook>
 <20200303085802.eqn6jbhwxtmz4j2x@wittgenstein>
 <AM6PR03MB5170285B336790D3450E2644E4E40@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87v9nlii0b.fsf@x220.int.ebiederm.org>
 <AM6PR03MB5170609D44967E044FD1BE40E4E40@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87a74xi4kz.fsf@x220.int.ebiederm.org>
 <AM6PR03MB51705AA3009B4986BB6EF92FE4E50@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87r1y8dqqz.fsf@x220.int.ebiederm.org>
In-Reply-To: <87r1y8dqqz.fsf@x220.int.ebiederm.org>
Accept-Language: en-US, en-GB, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: ZR0P278CA0011.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:16::21) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
x-incomingtopheadermarker: OriginalChecksum:430D2CAAB68E269CCF8B3936A824EEE4B63FC09FB15FFA618454DB2C2C3462C8;UpperCasedChecksum:879C9D3A4C6C52CA292F978F0D2BFD166CCDBCF7B3BFAE045F934CEFBB193631;SizeAsReceived:9853;Count:50
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [UP/2zUohcAtl8QD3nhKRA1w1/NVuK0E5]
x-microsoft-original-message-id: <63db2821-127c-3930-67d5-d5033285b802@hotmail.de>
x-ms-publictraffictype: Email
x-incomingheadercount: 50
x-eopattributedmessage: 0
x-ms-office365-filtering-correlation-id: 1f656d95-9ec3-42e8-c40c-08d7c086ddb6
x-ms-traffictypediagnostic: DB8EUR05HT151:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: z3ZrZsqmczKrmWJskdWMwPWCRx6OWLxqvf+lEbdSroMp3F6J6NzjiyA2mCfgy/EK8GP1RtqrjIM+hQHw/Qj5sVW0OpQPhTxBfyor6oEk8I4F3VGSln1PgEa3w6797640w0U4DLcc2M1ENiICPzdqaWsu1DylKRToWF/Dwyg5VgvnKCvuLRQ7ezqfvvSTh3Po
x-ms-exchange-antispam-messagedata: AhJq/eNHJLG9magFLsHVbIUSGpztMeRGUBi2wGPa2vHGKjKL6t2DH5rrTcPF9k28a521H8t73A1p1iEq7zufSn3bZwd9hu5oeAwnW8lHmwK6nwRxuPa+JgIzfFSY+qBFcqnf05f6YB51zRQDNqFpAA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <58F172218D0E964C96DB75C877C744A3@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f656d95-9ec3-42e8-c40c-08d7c086ddb6
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Mar 2020 21:56:17.8944
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8EUR05HT151
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This fixes a deadlock in the tracer when tracing a multi-threaded
application that calls execve while more than one thread are running.

I observed that when running strace on the gcc test suite, it always
blocks after a while, when expect calls execve, because other threads
have to be terminated.  They send ptrace events, but the strace is no
longer able to respond, since it is blocked in vm_access.

The deadlock is always happening when strace needs to access the
tracees process mmap, while another thread in the tracee starts to
execve a child process, but that cannot continue until the
PTRACE_EVENT_EXIT is handled and the WIFEXITED event is received:

strace          D    0 30614  30584 0x00000000
Call Trace:
__schedule+0x3ce/0x6e0
schedule+0x5c/0xd0
schedule_preempt_disabled+0x15/0x20
__mutex_lock.isra.13+0x1ec/0x520
__mutex_lock_killable_slowpath+0x13/0x20
mutex_lock_killable+0x28/0x30
mm_access+0x27/0xa0
process_vm_rw_core.isra.3+0xff/0x550
process_vm_rw+0xdd/0xf0
__x64_sys_process_vm_readv+0x31/0x40
do_syscall_64+0x64/0x220
entry_SYSCALL_64_after_hwframe+0x44/0xa9

expect          D    0 31933  30876 0x80004003
Call Trace:
__schedule+0x3ce/0x6e0
schedule+0x5c/0xd0
flush_old_exec+0xc4/0x770
load_elf_binary+0x35a/0x16c0
search_binary_handler+0x97/0x1d0
__do_execve_file.isra.40+0x5d4/0x8a0
__x64_sys_execve+0x49/0x60
do_syscall_64+0x64/0x220
entry_SYSCALL_64_after_hwframe+0x44/0xa9

The proposed solution is to detect if a sibling thread
exists that is traced and in this case to make PTRACE_ACCESS
fail with -EAGAIN instead of dead-lock.
But other functions like vm_access are allowed to complete normally.

This changes the lifetime of the cred_guard_mutex lock to be
from flush_old_exec() through install_exec_creds().
Before, cred_guard_mutex was held from prepare_bprm_creds() through
install_exec_creds().

Additionally a new mutex exec_guard_mutex is introduced that is used
for PTRACE_ACCESS and SECCOMP_FILTER_FLAG_TSYNC.

Signed-off-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
---
 Documentation/security/credentials.rst    | 29 ++++++++---
 fs/exec.c                                 | 58 ++++++++++++++++++---
 include/linux/binfmts.h                   | 15 +++++-
 include/linux/sched/signal.h              | 10 ++--
 init/init_task.c                          |  1 +
 kernel/cred.c                             |  4 +-
 kernel/fork.c                             |  1 +
 kernel/ptrace.c                           | 20 ++++++--
 kernel/seccomp.c                          | 15 +++---
 mm/process_vm_access.c                    |  2 +-
 tools/testing/selftests/ptrace/Makefile   |  4 +-
 tools/testing/selftests/ptrace/vmaccess.c | 85 +++++++++++++++++++++++++++++++
 12 files changed, 210 insertions(+), 34 deletions(-)
 create mode 100644 tools/testing/selftests/ptrace/vmaccess.c

v2: adds a test case which passes when this patch is applied.
v3: fixes the issue without introducing a new mutex.
v4: fixes one comment and a formatting issue found by checkpatch.pl in the test case. 
v5: addresses review comments.
v6: minimal API changes, using a second mutex, improved test case.

diff --git a/Documentation/security/credentials.rst b/Documentation/security/credentials.rst
index 282e79f..b08899f 100644
--- a/Documentation/security/credentials.rst
+++ b/Documentation/security/credentials.rst
@@ -437,15 +437,30 @@ new set of credentials by calling::
 
 	struct cred *prepare_creds(void);
 
-this locks current->cred_replace_mutex and then allocates and constructs a
-duplicate of the current process's credentials, returning with the mutex still
-held if successful.  It returns NULL if not successful (out of memory).
+this allocates and constructs a duplicate of the current process's credentials.
+It returns NULL if not successful (out of memory).
+
+If called from __do_execve_file, the mutex current->signal->exec_guard_mutex
+is acquired before this function gets called, and usually released after
+the new process mmap and credentials are installed.  However if one of the
+sibling threads are being traced when the execve is invoked, there is no
+guarantee how long it takes to terminate all sibling threads, and therefore
+the variable current->signal->cred_locked_in_execve is set, and the
+exec_guard_mutex is released immediately.  Functions that may have effect
+on the credentials of a different thread need to lock the exec_guard_mutex
+and additionally check the cred_locked_in_execve status, and fail with
+-EAGAIN if that variable is set.
 
 The mutex prevents ``ptrace()`` from altering the ptrace state of a process
 while security checks on credentials construction and changing is taking place
 as the ptrace state may alter the outcome, particularly in the case of
 ``execve()``.
 
+The mutex current->signal->cred_guard_mutex is acquired when only a single thread
+is remaining, and the credentials and the process mmap are actually changed.
+Functions that only need to access to a consistent state of the credentials
+and the process mmap do only need to aquire this mutex.
+
 The new credentials set should be altered appropriately, and any security
 checks and hooks done.  Both the current and the proposed sets of credentials
 are available for this purpose as current_cred() will return the current set
@@ -466,9 +481,8 @@ by calling::
 
 This will alter various aspects of the credentials and the process, giving the
 LSM a chance to do likewise, then it will use ``rcu_assign_pointer()`` to
-actually commit the new credentials to ``current->cred``, it will release
-``current->cred_replace_mutex`` to allow ``ptrace()`` to take place, and it
-will notify the scheduler and others of the changes.
+actually commit the new credentials to ``current->cred``, and it will notify
+the scheduler and others of the changes.
 
 This function is guaranteed to return 0, so that it can be tail-called at the
 end of such functions as ``sys_setresuid()``.
@@ -486,8 +500,7 @@ invoked::
 
 	void abort_creds(struct cred *new);
 
-This releases the lock on ``current->cred_replace_mutex`` that
-``prepare_creds()`` got and then releases the new credentials.
+This releases the new credentials.
 
 
 A typical credentials alteration function would look something like this::
diff --git a/fs/exec.c b/fs/exec.c
index 74d88da..8a23804 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1258,6 +1258,11 @@ int flush_old_exec(struct linux_binprm * bprm)
 {
 	int retval;
 
+	if (bprm->detected_unsafe_exec) {
+		mutex_unlock(&current->signal->exec_guard_mutex);
+		bprm->holding_exec_guard_mutex = 0;
+	}
+
 	/*
 	 * Make sure we have a private signal table and that
 	 * we are unassociated from the previous thread group.
@@ -1266,6 +1271,12 @@ int flush_old_exec(struct linux_binprm * bprm)
 	if (retval)
 		goto out;
 
+	retval = mutex_lock_killable(&current->signal->cred_guard_mutex);
+	if (retval)
+		goto out;
+
+	bprm->holding_cred_guard_mutex = 1;
+
 	/*
 	 * Must be called _before_ exec_mmap() as bprm->mm is
 	 * not visibile until then. This also enables the update
@@ -1398,29 +1409,56 @@ void finalize_exec(struct linux_binprm *bprm)
 EXPORT_SYMBOL(finalize_exec);
 
 /*
- * Prepare credentials and lock ->cred_guard_mutex.
+ * Prepare credentials and set ->cred_locked_in_execve.
  * install_exec_creds() commits the new creds and drops the lock.
  * Or, if exec fails before, free_bprm() should release ->cred and
  * and unlock.
  */
 static int prepare_bprm_creds(struct linux_binprm *bprm)
 {
-	if (mutex_lock_interruptible(&current->signal->cred_guard_mutex))
+	int ret;
+	struct task_struct *t;
+
+	if (mutex_lock_interruptible(&current->signal->exec_guard_mutex))
 		return -ERESTARTNOINTR;
 
+	bprm->holding_exec_guard_mutex = 1;
+
+	ret = -EAGAIN;
+	if (unlikely(current->signal->cred_locked_in_execve))
+		goto out;
+
 	bprm->cred = prepare_exec_creds();
-	if (likely(bprm->cred))
-		return 0;
+	ret = -ENOMEM;
+	if (unlikely(bprm->cred == NULL))
+		goto out;
 
-	mutex_unlock(&current->signal->cred_guard_mutex);
-	return -ENOMEM;
+	current->signal->cred_locked_in_execve = true;
+
+	spin_lock_irq(&current->sighand->siglock);
+	t = current;
+	while_each_thread(current, t) {
+		if (t->ptrace)
+			bprm->detected_unsafe_exec = 1;
+	}
+	spin_unlock_irq(&current->sighand->siglock);
+	return 0;
+
+out:
+	mutex_unlock(&current->signal->exec_guard_mutex);
+	return ret;
 }
 
 static void free_bprm(struct linux_binprm *bprm)
 {
 	free_arg_pages(bprm);
 	if (bprm->cred) {
-		mutex_unlock(&current->signal->cred_guard_mutex);
+		if (bprm->holding_cred_guard_mutex)
+			mutex_unlock(&current->signal->cred_guard_mutex);
+		if (!bprm->holding_exec_guard_mutex)
+			mutex_lock(&current->signal->exec_guard_mutex);
+		current->signal->cred_locked_in_execve = false;
+		mutex_unlock(&current->signal->exec_guard_mutex);
 		abort_creds(bprm->cred);
 	}
 	if (bprm->file) {
@@ -1470,12 +1508,16 @@ void install_exec_creds(struct linux_binprm *bprm)
 	 */
 	security_bprm_committed_creds(bprm);
 	mutex_unlock(&current->signal->cred_guard_mutex);
+	if (bprm->detected_unsafe_exec)
+		mutex_lock(&current->signal->exec_guard_mutex);
+	current->signal->cred_locked_in_execve = false;
+	mutex_unlock(&current->signal->exec_guard_mutex);
 }
 EXPORT_SYMBOL(install_exec_creds);
 
 /*
  * determine how safe it is to execute the proposed program
- * - the caller must hold ->cred_guard_mutex to protect against
+ * - the caller must have set ->cred_locked_in_execve to protect against
  *   PTRACE_ATTACH or seccomp thread-sync
  */
 static void check_unsafe_exec(struct linux_binprm *bprm)
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index b40fc63..238e280 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -44,7 +44,20 @@ struct linux_binprm {
 		 * exec has happened. Used to sanitize execution environment
 		 * and to set AT_SECURE auxv for glibc.
 		 */
-		secureexec:1;
+		secureexec:1,
+		/*
+		 * Set by prepare_bprm_creds, if a sibling thread is being
+		 * traced and the exec_guard_mutex is therefore not taken.
+		 */
+		detected_unsafe_exec:1,
+		/*
+		 * Set when the cred_guard_mutex is taken.
+		 */
+		holding_cred_guard_mutex:1,
+		/*
+		 * Set when the exec_guard_mutex is taken.
+		 */
+		holding_exec_guard_mutex:1;
 #ifdef __alpha__
 	unsigned int taso:1;
 #endif
diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
index 8805025..4484aa3 100644
--- a/include/linux/sched/signal.h
+++ b/include/linux/sched/signal.h
@@ -222,9 +222,13 @@ struct signal_struct {
 	struct mm_struct *oom_mm;	/* recorded mm when the thread group got
 					 * killed by the oom killer */
 
-	struct mutex cred_guard_mutex;	/* guard against foreign influences on
-					 * credential calculations
-					 * (notably. ptrace) */
+	struct mutex cred_guard_mutex;	/* guard against changing credentials */
+	struct mutex exec_guard_mutex;	/* guard against foreign influences on
+					 * execve (notably. ptrace)
+					 */
+	bool cred_locked_in_execve;	/* set while in execve, only valid when
+					 * exec_guard_mutex is held
+					 */
 } __randomize_layout;
 
 /*
diff --git a/init/init_task.c b/init/init_task.c
index 9e5cbe5..6cf602a 100644
--- a/init/init_task.c
+++ b/init/init_task.c
@@ -26,6 +26,7 @@
 	.multiprocess	= HLIST_HEAD_INIT,
 	.rlim		= INIT_RLIMITS,
 	.cred_guard_mutex = __MUTEX_INITIALIZER(init_signals.cred_guard_mutex),
+	.exec_guard_mutex = __MUTEX_INITIALIZER(init_signals.exec_guard_mutex),
 #ifdef CONFIG_POSIX_TIMERS
 	.posix_timers = LIST_HEAD_INIT(init_signals.posix_timers),
 	.cputimer	= {
diff --git a/kernel/cred.c b/kernel/cred.c
index 809a985..620cd50 100644
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
@@ -676,7 +676,7 @@ void __init cred_init(void)
  *
  * Returns the new credentials or NULL if out of memory.
  *
- * Does not take, and does not return holding current->cred_replace_mutex.
+ * Does not take, and does not return holding ->cred_guard_mutex.
  */
 struct cred *prepare_kernel_cred(struct task_struct *daemon)
 {
diff --git a/kernel/fork.c b/kernel/fork.c
index 0808095..0c21baa 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1594,6 +1594,7 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 	sig->oom_score_adj_min = current->signal->oom_score_adj_min;
 
 	mutex_init(&sig->cred_guard_mutex);
+	mutex_init(&sig->exec_guard_mutex);
 
 	return 0;
 }
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 43d6179..1af8ff4 100644
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
+	if (task->signal->cred_locked_in_execve)
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
+	if (current->signal->cred_locked_in_execve)
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
index b6ea3dc..7ec66b1 100644
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
 
+	if (current->signal->cred_locked_in_execve)
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
diff --git a/mm/process_vm_access.c b/mm/process_vm_access.c
index 357aa7b..b3e6eb5 100644
--- a/mm/process_vm_access.c
+++ b/mm/process_vm_access.c
@@ -204,7 +204,7 @@ static ssize_t process_vm_rw_core(pid_t pid, struct iov_iter *iter,
 	if (!mm || IS_ERR(mm)) {
 		rc = IS_ERR(mm) ? PTR_ERR(mm) : -ESRCH;
 		/*
-		 * Explicitly map EACCES to EPERM as EPERM is a more a
+		 * Explicitly map EACCES to EPERM as EPERM is a more
 		 * appropriate error code for process_vw_readv/writev
 		 */
 		if (rc == -EACCES)
diff --git a/tools/testing/selftests/ptrace/Makefile b/tools/testing/selftests/ptrace/Makefile
index c0b7f89..2f1f532 100644
--- a/tools/testing/selftests/ptrace/Makefile
+++ b/tools/testing/selftests/ptrace/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
-CFLAGS += -iquote../../../../include/uapi -Wall
+CFLAGS += -std=c99 -pthread -iquote../../../../include/uapi -Wall
 
-TEST_GEN_PROGS := get_syscall_info peeksiginfo
+TEST_GEN_PROGS := get_syscall_info peeksiginfo vmaccess
 
 include ../lib.mk
diff --git a/tools/testing/selftests/ptrace/vmaccess.c b/tools/testing/selftests/ptrace/vmaccess.c
new file mode 100644
index 0000000..fdca30b
--- /dev/null
+++ b/tools/testing/selftests/ptrace/vmaccess.c
@@ -0,0 +1,85 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright (c) 2020 Bernd Edlinger <bernd.edlinger@hotmail.de>
+ * All rights reserved.
+ *
+ * Check whether /proc/$pid/mem can be accessed without causing deadlocks
+ * when de_thread is blocked with ->cred_guard_mutex held.
+ */
+
+#include "../kselftest_harness.h"
+#include <stdio.h>
+#include <fcntl.h>
+#include <pthread.h>
+#include <signal.h>
+#include <unistd.h>
+#include <sys/ptrace.h>
+
+static void *thread(void *arg)
+{
+	ptrace(PTRACE_TRACEME, 0, 0L, 0L);
+	return NULL;
+}
+
+TEST(vmaccess)
+{
+	int f, pid = fork();
+	char mm[64];
+
+	if (!pid) {
+		pthread_t pt;
+
+		pthread_create(&pt, NULL, thread, NULL);
+		pthread_join(pt, NULL);
+		execlp("true", "true", NULL);
+	}
+
+	sleep(1);
+	sprintf(mm, "/proc/%d/mem", pid);
+	f = open(mm, O_RDONLY);
+	ASSERT_GE(f, 0);
+	close(f);
+	f = kill(pid, SIGCONT);
+	ASSERT_EQ(f, 0);
+}
+
+TEST(attach)
+{
+	int s, k, pid = fork();
+
+	if (!pid) {
+		pthread_t pt;
+
+		pthread_create(&pt, NULL, thread, NULL);
+		pthread_join(pt, NULL);
+		execlp("sleep", "sleep", "2", NULL);
+	}
+
+	sleep(1);
+	k = ptrace(PTRACE_ATTACH, pid, 0L, 0L);
+	ASSERT_EQ(errno, EAGAIN);
+	ASSERT_EQ(k, -1);
+	k = waitpid(-1, &s, WNOHANG);
+	ASSERT_NE(k, 0);
+	ASSERT_NE(k, pid);
+	ASSERT_EQ(WIFEXITED(s), 1);
+	ASSERT_EQ(WEXITSTATUS(s), 0);
+	sleep(1);
+	k = ptrace(PTRACE_ATTACH, pid, 0L, 0L);
+	ASSERT_EQ(k, 0);
+	k = waitpid(-1, &s, 0);
+	ASSERT_EQ(k, pid);
+	ASSERT_EQ(WIFSTOPPED(s), 1);
+	ASSERT_EQ(WSTOPSIG(s), SIGSTOP);
+	k = ptrace(PTRACE_DETACH, pid, 0L, 0L);
+	ASSERT_EQ(k, 0);
+	k = waitpid(-1, &s, 0);
+	ASSERT_EQ(k, pid);
+	ASSERT_EQ(WIFEXITED(s), 1);
+	ASSERT_EQ(WEXITSTATUS(s), 0);
+	k = waitpid(-1, NULL, 0);
+	ASSERT_EQ(k, -1);
+	ASSERT_EQ(errno, ECHILD);
+}
+
+TEST_HARNESS_MAIN
-- 
1.9.1
