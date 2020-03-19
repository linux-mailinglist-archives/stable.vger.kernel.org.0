Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72F5818AEF5
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 10:13:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbgCSJNd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 05:13:33 -0400
Received: from mail-oln040092073052.outbound.protection.outlook.com ([40.92.73.52]:61387
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725768AbgCSJNd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 05:13:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YWifkEORSqwjIHz6zJ0O2Wr2X6DBbY8JXTFXMdD/1fVPhemiezDKCFY8QMS5MhLEjPMSRN5O6sjYIO1JtOXJrOanV1tgFScvtC5NF7eTDYSuNFGVYhsaHYUEj7JBhnWtUN3phPbmpQIGZeN6cvVC/ZJONMSgIZWpA9WWgufwQaISQWQZRvwyuiUyENnvlqawfml6JiAkWXrs+cLDipCtKjQhQjI0fcQUkaM/4lasuaRmKfcKfPVBh4D0+VOlQxSum9Gl/W/Dre7F5m+og3vGudh57YBxnQEu4enFIuS4cgtoNF8ItSyZt4beoQriK6/SNx7VrL8ep/2kHbDOtKRhFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2xdPb2xOwTL6+Ei7+MTI+7WSe6j5x1xFgLGonT/9hhw=;
 b=Pov7UCxuNk30BlNjO7wTgpKsCMwQjn+hm+DuHZz+0psqdOKHm9D9RVr1aSxL6GzbI2M1VoMQetQJfaQk5nerErKgEOc765OJ7HL6oC1gUnFHYe43WJDhmPx9vdxNet3CDYELZxLG1Hm0GVIOkODjltZxsXSGhvGuyMitckne6jzVoEgjnBaz38yCv9ZUd3BO9ZpunxgNXjiFeZgFK4dLVi5FHl6cYsDfcFbDbZnyl4dyLi3s41jKaLd4HRfqFSTd7AUP9eCTAXtme8QcnNbYCyHbgMvvby/3hQmia3yv7x6SW6zo2AEVjO9A4InU9giMb82gPGspsBjtMGhHM+zEtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hotmail.de; dmarc=pass action=none header.from=hotmail.de;
 dkim=pass header.d=hotmail.de; arc=none
Received: from DB3EUR04FT050.eop-eur04.prod.protection.outlook.com
 (2a01:111:e400:7e0c::3a) by
 DB3EUR04HT149.eop-eur04.prod.protection.outlook.com (2a01:111:e400:7e0c::155)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.13; Thu, 19 Mar
 2020 09:13:23 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.152.24.54) by
 DB3EUR04FT050.mail.protection.outlook.com (10.152.25.40) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.13 via Frontend Transport; Thu, 19 Mar 2020 09:13:23 +0000
X-IncomingTopHeaderMarker: OriginalChecksum:3668331D173F106644B3191FD9237B9E55197368D01837E1FC110AEB8C38898A;UpperCasedChecksum:A6DF1432EF0E4D6BC0F498D9D6AB87BA68CF72EFBFDFA6D7626279BE743B6399;SizeAsReceived:10399;Count:50
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2835.017; Thu, 19 Mar 2020
 09:13:23 +0000
Subject: Re: [PATCH v4 3/5] exec: Add a exec_update_mutex to replace
 cred_guard_mutex
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
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
 <87v9ne5y4y.fsf_-_@x220.int.ebiederm.org>
 <87zhcq4jdj.fsf_-_@x220.int.ebiederm.org>
 <f37a5d68-9674-533f-ee9c-a49174605710@virtuozzo.com>
 <87d09hn4kt.fsf@x220.int.ebiederm.org>
 <dbce35c7-c060-cfd8-bde1-98fd9a0747a9@virtuozzo.com>
 <87lfo5lju6.fsf@x220.int.ebiederm.org>
 <AM6PR03MB5170E9E71B9F84330B098BADE4FA0@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <6002ac56-025a-d50f-e89d-1bf42a072323@virtuozzo.com>
 <AM6PR03MB5170353DF3575FF7742BB155E4FB0@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <532ce6a3-f0df-e3e4-6966-473c608246e1@virtuozzo.com>
 <AM6PR03MB51705D8A5631B53844CE447CE4F60@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <13c4d333-9c33-8036-3142-dac22c392c60@virtuozzo.com>
 <AM6PR03MB5170110A5D332DD0C1AC929FE4F70@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <f7c1508a-a456-6ae4-a81e-8e8aa41d8d39@virtuozzo.com>
 <AM6PR03MB5170946BCC61F5D6CA233390E4F40@AM6PR03MB5170.eurprd03.prod.outlook.com>
Message-ID: <AM6PR03MB51703082215BDFE074E9D735E4F40@AM6PR03MB5170.eurprd03.prod.outlook.com>
Date:   Thu, 19 Mar 2020 10:13:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
In-Reply-To: <AM6PR03MB5170946BCC61F5D6CA233390E4F40@AM6PR03MB5170.eurprd03.prod.outlook.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0039.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1d::8) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
X-Microsoft-Original-Message-ID: <d22d08fd-3229-c7ed-8413-c01c494defcf@hotmail.de>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.101] (92.77.140.102) by ZR0P278CA0039.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1d::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.15 via Frontend Transport; Thu, 19 Mar 2020 09:13:21 +0000
X-Microsoft-Original-Message-ID: <d22d08fd-3229-c7ed-8413-c01c494defcf@hotmail.de>
X-TMN:  [UUsM3TMx7bEfLGOIJ+iDQ97ISGUN8ca3]
X-MS-PublicTrafficType: Email
X-IncomingHeaderCount: 50
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-Correlation-Id: c89c222a-0453-4829-10db-08d7cbe5c624
X-MS-TrafficTypeDiagnostic: DB3EUR04HT149:
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mlQqNO4x95xQcEG/8mCJLLyIIwjsNNPixhKsM1B7A1Uvy0sz7F6ahdIP770jb08pREWxbI9mo58PmQDI5lke6cpMIdXuxJPQYu+Pa0c0anA4CVPiWiQ66vKe0enkqwa6z0yp8jSBoPeomu0/ooFnQyepymAnpqBh+YCuQqCnNO5Ty1LNZFSbE/RbCBbK1zMSdV7wmE4A6Uxss1z/0c2X+LtHF7xHkdxv1mF72JWvf9c=
X-MS-Exchange-AntiSpam-MessageData: RuA+4SaI16GcwOokoS4uhtgmwWeQBmPbAJsHQTwcBawIZlmuHAce61yygIxfY0wbdngF/0wL881ZRteycfsbjMtu6I0Bl7k4err928PpuJvaAkfjzsxOz2eQbZg8m5aPGxwe+xuHq4CNUkizoH4XGQ==
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c89c222a-0453-4829-10db-08d7cbe5c624
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2020 09:13:23.1714
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-FromEntityHeader: Internet
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3EUR04HT149
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Ah, sorry this is actuall v4 5/5.
Should I send a new version or can you handle it?


On 3/19/20 10:11 AM, Bernd Edlinger wrote:
> The cred_guard_mutex is problematic.  The cred_guard_mutex is held
> over the userspace accesses as the arguments from userspace are read.
> The cred_guard_mutex is held of PTRACE_EVENT_EXIT as the the other
> threads are killed.  The cred_guard_mutex is held over
> "put_user(0, tsk->clear_child_tid)" in exit_mm().
> 
> Any of those can result in deadlock, as the cred_guard_mutex is held
> over a possible indefinite userspace waits for userspace.
> 
> Add exec_update_mutex that is only held over exec updating process
> with the new contents of exec, so that code that needs not to be
> confused by exec changing the mm and the cred in ways that can not
> happen during ordinary execution of a process.
> 
> The plan is to switch the users of cred_guard_mutex to
> exec_udpate_mutex one by one.  This lets us move forward while still
> being careful and not introducing any regressions.
> 
> Link: https://lore.kernel.org/lkml/20160921152946.GA24210@dhcp22.suse.cz/
> Link: https://lore.kernel.org/lkml/AM6PR03MB5170B06F3A2B75EFB98D071AE4E60@AM6PR03MB5170.eurprd03.prod.outlook.com/
> Link: https://lore.kernel.org/linux-fsdevel/20161102181806.GB1112@redhat.com/
> Link: https://lore.kernel.org/lkml/20160923095031.GA14923@redhat.com/
> Link: https://lore.kernel.org/lkml/20170213141452.GA30203@redhat.com/
> Ref: 45c1a159b85b ("Add PTRACE_O_TRACEVFORKDONE and PTRACE_O_TRACEEXIT facilities.")
> Ref: 456f17cd1a28 ("[PATCH] user-vm-unlock-2.5.31-A2")
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> Signed-off-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
> ---
>  fs/exec.c                    | 22 +++++++++++++++++++---
>  include/linux/binfmts.h      |  8 +++++++-
>  include/linux/sched/signal.h |  9 ++++++++-
>  init/init_task.c             |  1 +
>  kernel/fork.c                |  1 +
>  5 files changed, 36 insertions(+), 5 deletions(-)
> 
> v3: this update fixes lock-order and adds an explicit data member in linux_binprm
> v4: add a function comment to exec_mmap
> 
> diff --git a/fs/exec.c b/fs/exec.c
> index d820a72..0e46ec5 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1010,16 +1010,26 @@ ssize_t read_code(struct file *file, unsigned long addr, loff_t pos, size_t len)
>  }
>  EXPORT_SYMBOL(read_code);
>  
> +/*
> + * Maps the mm_struct mm into the current task struct.
> + * On success, this function returns with the mutex
> + * exec_update_mutex locked.
> + */
>  static int exec_mmap(struct mm_struct *mm)
>  {
>  	struct task_struct *tsk;
>  	struct mm_struct *old_mm, *active_mm;
> +	int ret;
>  
>  	/* Notify parent that we're no longer interested in the old VM */
>  	tsk = current;
>  	old_mm = current->mm;
>  	exec_mm_release(tsk, old_mm);
>  
> +	ret = mutex_lock_killable(&tsk->signal->exec_update_mutex);
> +	if (ret)
> +		return ret;
> +
>  	if (old_mm) {
>  		sync_mm_rss(old_mm);
>  		/*
> @@ -1031,9 +1041,11 @@ static int exec_mmap(struct mm_struct *mm)
>  		down_read(&old_mm->mmap_sem);
>  		if (unlikely(old_mm->core_state)) {
>  			up_read(&old_mm->mmap_sem);
> +			mutex_unlock(&tsk->signal->exec_update_mutex);
>  			return -EINTR;
>  		}
>  	}
> +
>  	task_lock(tsk);
>  	active_mm = tsk->active_mm;
>  	membarrier_exec_mmap(mm);
> @@ -1288,11 +1300,12 @@ int flush_old_exec(struct linux_binprm * bprm)
>  		goto out;
>  
>  	/*
> -	 * After clearing bprm->mm (to mark that current is using the
> -	 * prepared mm now), we have nothing left of the original
> +	 * After setting bprm->called_exec_mmap (to mark that current is
> +	 * using the prepared mm now), we have nothing left of the original
>  	 * process. If anything from here on returns an error, the check
>  	 * in search_binary_handler() will SEGV current.
>  	 */
> +	bprm->called_exec_mmap = 1;
>  	bprm->mm = NULL;
>  
>  #ifdef CONFIG_POSIX_TIMERS
> @@ -1438,6 +1451,8 @@ static void free_bprm(struct linux_binprm *bprm)
>  {
>  	free_arg_pages(bprm);
>  	if (bprm->cred) {
> +		if (bprm->called_exec_mmap)
> +			mutex_unlock(&current->signal->exec_update_mutex);
>  		mutex_unlock(&current->signal->cred_guard_mutex);
>  		abort_creds(bprm->cred);
>  	}
> @@ -1487,6 +1502,7 @@ void install_exec_creds(struct linux_binprm *bprm)
>  	 * credentials; any time after this it may be unlocked.
>  	 */
>  	security_bprm_committed_creds(bprm);
> +	mutex_unlock(&current->signal->exec_update_mutex);
>  	mutex_unlock(&current->signal->cred_guard_mutex);
>  }
>  EXPORT_SYMBOL(install_exec_creds);
> @@ -1678,7 +1694,7 @@ int search_binary_handler(struct linux_binprm *bprm)
>  
>  		read_lock(&binfmt_lock);
>  		put_binfmt(fmt);
> -		if (retval < 0 && !bprm->mm) {
> +		if (retval < 0 && bprm->called_exec_mmap) {
>  			/* we got to flush_old_exec() and failed after it */
>  			read_unlock(&binfmt_lock);
>  			force_sigsegv(SIGSEGV);
> diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
> index b40fc63..a345d9f 100644
> --- a/include/linux/binfmts.h
> +++ b/include/linux/binfmts.h
> @@ -44,7 +44,13 @@ struct linux_binprm {
>  		 * exec has happened. Used to sanitize execution environment
>  		 * and to set AT_SECURE auxv for glibc.
>  		 */
> -		secureexec:1;
> +		secureexec:1,
> +		/*
> +		 * Set by flush_old_exec, when exec_mmap has been called.
> +		 * This is past the point of no return, when the
> +		 * exec_update_mutex has been taken.
> +		 */
> +		called_exec_mmap:1;
>  #ifdef __alpha__
>  	unsigned int taso:1;
>  #endif
> diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
> index 8805025..a29df79 100644
> --- a/include/linux/sched/signal.h
> +++ b/include/linux/sched/signal.h
> @@ -224,7 +224,14 @@ struct signal_struct {
>  
>  	struct mutex cred_guard_mutex;	/* guard against foreign influences on
>  					 * credential calculations
> -					 * (notably. ptrace) */
> +					 * (notably. ptrace)
> +					 * Deprecated do not use in new code.
> +					 * Use exec_update_mutex instead.
> +					 */
> +	struct mutex exec_update_mutex;	/* Held while task_struct is being
> +					 * updated during exec, and may have
> +					 * inconsistent permissions.
> +					 */
>  } __randomize_layout;
>  
>  /*
> diff --git a/init/init_task.c b/init/init_task.c
> index 9e5cbe5..bd403ed 100644
> --- a/init/init_task.c
> +++ b/init/init_task.c
> @@ -26,6 +26,7 @@
>  	.multiprocess	= HLIST_HEAD_INIT,
>  	.rlim		= INIT_RLIMITS,
>  	.cred_guard_mutex = __MUTEX_INITIALIZER(init_signals.cred_guard_mutex),
> +	.exec_update_mutex = __MUTEX_INITIALIZER(init_signals.exec_update_mutex),
>  #ifdef CONFIG_POSIX_TIMERS
>  	.posix_timers = LIST_HEAD_INIT(init_signals.posix_timers),
>  	.cputimer	= {
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 8642530..036b692 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1594,6 +1594,7 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
>  	sig->oom_score_adj_min = current->signal->oom_score_adj_min;
>  
>  	mutex_init(&sig->cred_guard_mutex);
> +	mutex_init(&sig->exec_update_mutex);
>  
>  	return 0;
>  }
> 
