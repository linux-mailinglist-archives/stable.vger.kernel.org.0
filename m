Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4A481856B1
	for <lists+stable@lfdr.de>; Sun, 15 Mar 2020 02:29:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbgCOB3J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Mar 2020 21:29:09 -0400
Received: from mail-oln040092066020.outbound.protection.outlook.com ([40.92.66.20]:7398
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726678AbgCOB3I (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 14 Mar 2020 21:29:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SGvjr4BNyCFBPVE64HTX1EbB5G+YvwrifM9N03ZMnhb4tQ2aXRp81VS0z2z3lE8+Aq2k6XpfAHfDEO1cmRxr26rLskXLZV5q8J02HMqXN8htCwe54mMvB7xXfYESz9f+ZPX6E80EQfCOZ1Ca7lvivMfn6z5WYFw4wUXQSnXOBVY+uMm6CYL2m5sMVz0wdufifOxCgxHuUvtgfETBrk3E9mZuvCXaXkls5Sh4P0vBPfnFOOxeqMiyQ5KzqJ90bQUuC8WGcv6b8ccjme1WVovGnVDtT9UpSaslvegKjY2sHBhXrAOL7w1dDHbrqu1E8mYQ4unwQwWBTDLddhPnPtmiOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sHZELvps2/vcLuiNrSD5Q9vjpQ8D5COG/a6p7AEDoxg=;
 b=BZL8pPyJeKUllxq45/Y3HAlve9A1KJKFaHfRkSHQa7c6N1nob70+n3qU3E4D57qmHaFLlQOwJtXh+ajExMJtc/R+xnjZVLwbJkK3uwzb4gqmK4s17fcqtovPtKJgddmjpA2/ttBLlISV9+VPuaC9Sv5RtJur2ETqn1fuYys+ZKdOHr6h220fgI4lgbIYRmlrDLTlChLrKIznaEUV2kv159G4c26AO4cXLZJgBsJJOYn79tk4Va3XsSej61gEN7QYtJUVK14NJlaYFsFTeH1r8lHpx12B1oyc6KfqK2P00oFUcZX649yPz7SD97LrkhpJkOZRztPdkzKof/dQk6XxaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hotmail.de; dmarc=pass action=none header.from=hotmail.de;
 dkim=pass header.d=hotmail.de; arc=none
Received: from HE1EUR01FT018.eop-EUR01.prod.protection.outlook.com
 (2a01:111:e400:7e18::37) by
 HE1EUR01HT016.eop-EUR01.prod.protection.outlook.com (2a01:111:e400:7e18::351)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.14; Sat, 14 Mar
 2020 09:11:58 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.152.0.51) by
 HE1EUR01FT018.mail.protection.outlook.com (10.152.0.175) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.14 via Frontend Transport; Sat, 14 Mar 2020 09:11:57 +0000
X-IncomingTopHeaderMarker: OriginalChecksum:2C1EFD390DBFCF4505C45E52245AB7FCF501D290F81D61D378A5C3D4EE8A1E09;UpperCasedChecksum:F15A72C4B6B9ADADBCB08FF6BFCE65C84149850D6C3A96AD056870422D593274;SizeAsReceived:10373;Count:50
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2814.018; Sat, 14 Mar 2020
 09:11:57 +0000
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
Subject: [PATCH v3 5/5] exec: Add a exec_update_mutex to replace
 cred_guard_mutex
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
Message-ID: <AM6PR03MB5170353DF3575FF7742BB155E4FB0@AM6PR03MB5170.eurprd03.prod.outlook.com>
Date:   Sat, 14 Mar 2020 10:11:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
In-Reply-To: <6002ac56-025a-d50f-e89d-1bf42a072323@virtuozzo.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZRAP278CA0014.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::24) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
X-Microsoft-Original-Message-ID: <507107db-662f-651f-c422-8bd4fda0ca3d@hotmail.de>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.101] (92.77.140.102) by ZRAP278CA0014.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:10::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.18 via Frontend Transport; Sat, 14 Mar 2020 09:11:55 +0000
X-Microsoft-Original-Message-ID: <507107db-662f-651f-c422-8bd4fda0ca3d@hotmail.de>
X-TMN:  [pf84JP2cKZ+s7aOt0kffqN6QI9cf8RY9]
X-MS-PublicTrafficType: Email
X-IncomingHeaderCount: 50
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-Correlation-Id: 4ab62632-86b0-4039-4adf-08d7c7f7bef9
X-MS-TrafficTypeDiagnostic: HE1EUR01HT016:
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Cvfj0E9E7///Ovr+gJg9gUOfaIyGkbb9/hOKmQwk8Vdwz5yCSiZ1W5iNdrcYyS2bqORe3k3EGhw6Bx9oWSAXDU0GxsMQtnRtvnvhRFe4Tzk/QBw3SlF50+hC8P2xAKdBxufMF2ypGluo6XG13XIrOgabZtWyZzzh0YBjDVDe2dIUrz6zqQO24Z0K7TKLW5bqO64Kx0EZqpPY93pdrUBpVcXW6t+VwG2sV+9v7++u9S4=
X-MS-Exchange-AntiSpam-MessageData: HmV+EWhsKXSPoloSlieGKZN+2qHkQP4YBkHRG8H8ro9+bJBW6UEnOKDbZ68mjGDhgIkeLcswDXSTtRaYKz4sDCiNlY2eBfMwQBlWNuxKNO6iUhwg1ps40oQVSTmNi4K+K5rKGMOk6VDRVeWMggNltQ==
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ab62632-86b0-4039-4adf-08d7c7f7bef9
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2020 09:11:57.8278
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-FromEntityHeader: Internet
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1EUR01HT016
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The cred_guard_mutex is problematic.  The cred_guard_mutex is held
over the userspace accesses as the arguments from userspace are read.
The cred_guard_mutex is held of PTRACE_EVENT_EXIT as the the other
threads are killed.  The cred_guard_mutex is held over
"put_user(0, tsk->clear_child_tid)" in exit_mm().

Any of those can result in deadlock, as the cred_guard_mutex is held
over a possible indefinite userspace waits for userspace.

Add exec_update_mutex that is only held over exec updating process
with the new contents of exec, so that code that needs not to be
confused by exec changing the mm and the cred in ways that can not
happen during ordinary execution of a process.

The plan is to switch the users of cred_guard_mutex to
exec_udpate_mutex one by one.  This lets us move forward while still
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
 fs/exec.c                    | 17 ++++++++++++++---
 include/linux/binfmts.h      |  8 +++++++-
 include/linux/sched/signal.h |  9 ++++++++-
 init/init_task.c             |  1 +
 kernel/fork.c                |  1 +
 5 files changed, 31 insertions(+), 5 deletions(-)

v3: this update fixes lock-order and adds an explicit data member in linux_binprm

diff --git a/fs/exec.c b/fs/exec.c
index d820a72..11974a1 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1014,12 +1014,17 @@ static int exec_mmap(struct mm_struct *mm)
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
@@ -1031,9 +1036,11 @@ static int exec_mmap(struct mm_struct *mm)
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
@@ -1288,11 +1295,12 @@ int flush_old_exec(struct linux_binprm * bprm)
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
@@ -1438,6 +1446,8 @@ static void free_bprm(struct linux_binprm *bprm)
 {
 	free_arg_pages(bprm);
 	if (bprm->cred) {
+		if (bprm->called_exec_mmap)
+			mutex_unlock(&current->signal->exec_update_mutex);
 		mutex_unlock(&current->signal->cred_guard_mutex);
 		abort_creds(bprm->cred);
 	}
@@ -1487,6 +1497,7 @@ void install_exec_creds(struct linux_binprm *bprm)
 	 * credentials; any time after this it may be unlocked.
 	 */
 	security_bprm_committed_creds(bprm);
+	mutex_unlock(&current->signal->exec_update_mutex);
 	mutex_unlock(&current->signal->cred_guard_mutex);
 }
 EXPORT_SYMBOL(install_exec_creds);
@@ -1678,7 +1689,7 @@ int search_binary_handler(struct linux_binprm *bprm)
 
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
