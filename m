Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2041E18A377
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 21:06:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727135AbgCRUGZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 16:06:25 -0400
Received: from mail-db8eur05olkn2048.outbound.protection.outlook.com ([40.92.89.48]:16482
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726647AbgCRUGZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Mar 2020 16:06:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eiFV7O/nVkhWNmhGTpzUM1huv96+wm8dFSvCf+XOdEt0N960FaZ2tKU9Vw0hHiqI8ZNpiRVxRHyVanCoyP3OIN+9mA9oe38K7vcscs6MxcZ3WLFfJlGGfYJErAU1xrD2kvycW0pB4i1OjCpMb720nbeYI4Or1HeAJMlKkiDtjR/e6ghxbifXtPegJLOi+2uqevlLNTvkxx2qtvMw1PrnTs0YL7DE2VyxKUNPqsBscLZ5yjKE/d6t4yAoluLP10UEETn541i0Sr0H1LzYarAf4Gc2i/xAh50fQdhslA1DjTEBO57RvPjp7PJgiNmUEhIYf6r5egAEm0jkulY5GqSYRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zI5O/+zHKMbfx3iXEEaQahEwmPuPrNkBk3+/CFHOCNQ=;
 b=Q91/JRyu8M+HI6XSaKtANgAqKohSuSD/ZuHOA5hwx8zI70FfgGRSe9L/ZIaWKsjcbGXl03fdCg38LbaasZUE+a01nO7CjkG3QexNZ67TJhmb1WJn5Y34MSlHP6Dv5rBa4tE4+FI2gG8FXCYzSV+GFZgQDqnnPDeF0rIGGkrjqh+ilkzQqkQxqxk0SK84zLTAaUY4fgy3HQVbyO1gRQm3Q3QWyZRCHPdA2ykQipRdIbPYRqLxmmXWB6o9qpn5nk/DK9V/dQ/weuTBfZt3ZDAbmpSc8k6p6dBbIY+ZZvqlVOD3C+mmH+I0ut4C79/3n5cSMZVpyq8HIriKGjRE017UTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hotmail.de; dmarc=pass action=none header.from=hotmail.de;
 dkim=pass header.d=hotmail.de; arc=none
Received: from DB8EUR05FT032.eop-eur05.prod.protection.outlook.com
 (2a01:111:e400:fc0f::39) by
 DB8EUR05HT115.eop-eur05.prod.protection.outlook.com (2a01:111:e400:fc0f::282)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.13; Wed, 18 Mar
 2020 20:06:19 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.233.238.52) by
 DB8EUR05FT032.mail.protection.outlook.com (10.233.238.240) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.13 via Frontend Transport; Wed, 18 Mar 2020 20:06:19 +0000
X-IncomingTopHeaderMarker: OriginalChecksum:A5F450A44368847AE12DC651CF28CCBC705207EE2A79F7A5EA66F5FF6EDC7590;UpperCasedChecksum:FDDD9A4A2F4EAF49B8F6A5E706428C163BE54E690EEA2FAC0252BB2E9079C31D;SizeAsReceived:10363;Count:50
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2835.017; Wed, 18 Mar 2020
 20:06:19 +0000
Subject: Re: [PATCH v3 5/5] exec: Add a exec_update_mutex to replace
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
 <AM6PR03MB5170353DF3575FF7742BB155E4FB0@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <532ce6a3-f0df-e3e4-6966-473c608246e1@virtuozzo.com>
 <AM6PR03MB51705D8A5631B53844CE447CE4F60@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <13c4d333-9c33-8036-3142-dac22c392c60@virtuozzo.com>
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
Message-ID: <AM6PR03MB5170110A5D332DD0C1AC929FE4F70@AM6PR03MB5170.eurprd03.prod.outlook.com>
Date:   Wed, 18 Mar 2020 21:06:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
In-Reply-To: <13c4d333-9c33-8036-3142-dac22c392c60@virtuozzo.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0001.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:16::11) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
X-Microsoft-Original-Message-ID: <964a3c95-a155-e576-0df4-8f7f4ee312ec@hotmail.de>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.101] (92.77.140.102) by ZR0P278CA0001.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:16::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.15 via Frontend Transport; Wed, 18 Mar 2020 20:06:17 +0000
X-Microsoft-Original-Message-ID: <964a3c95-a155-e576-0df4-8f7f4ee312ec@hotmail.de>
X-TMN:  [0dPL4fh7b39Ul+6z6DMnFoUM2Fd0BtYc]
X-MS-PublicTrafficType: Email
X-IncomingHeaderCount: 50
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-Correlation-Id: 04254cf8-b319-4d1a-cd0e-08d7cb77d26f
X-MS-TrafficTypeDiagnostic: DB8EUR05HT115:
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WUZYQxJFGXjtilDpOJRTNon03s3wAdvBmI0GI0Yd1A0nlR1Z+0CtQUdo+QI1YmIo1AffoFcE+a2zacfjde7hnSVNea4HHVoZ/zAPoSi7XTHtqMGojoc/RwpNhCoijCKcXDEw9ne27iibr8VNPQH4aA/lX4fdSO7jxZUG7qIMwBs3cveps89FhcVqLLxhQohZ/sgrlI44aL5HlWN68DWZtBZ6xqhWhJeX2t+khYqWLA4=
X-MS-Exchange-AntiSpam-MessageData: qbcceBAennu07vTpLoBErxnpDaU9t6axwsuhBrjStPcJe0bCMBgS21Av1652jQDmygiOSshjohEWKAsQqsn0CyopiQRLUP3Wo1U3fOXVUoufNFPtxE7FYfyPpNJuhMRmpxMHDu70TlS7ghewto7eig==
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04254cf8-b319-4d1a-cd0e-08d7cb77d26f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2020 20:06:19.4039
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-FromEntityHeader: Internet
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8EUR05HT115
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/18/20 1:22 PM, Kirill Tkhai wrote:
> On 18.03.2020 00:53, Bernd Edlinger wrote:
>> On 3/17/20 9:56 AM, Kirill Tkhai wrote:
>>> On 14.03.2020 12:11, Bernd Edlinger wrote:
>>>> The cred_guard_mutex is problematic.  The cred_guard_mutex is held
>>>> over the userspace accesses as the arguments from userspace are read.
>>>> The cred_guard_mutex is held of PTRACE_EVENT_EXIT as the the other
>>>> threads are killed.  The cred_guard_mutex is held over
>>>> "put_user(0, tsk->clear_child_tid)" in exit_mm().
>>>>
>>>> Any of those can result in deadlock, as the cred_guard_mutex is held
>>>> over a possible indefinite userspace waits for userspace.
>>>>
>>>> Add exec_update_mutex that is only held over exec updating process
>>>> with the new contents of exec, so that code that needs not to be
>>>> confused by exec changing the mm and the cred in ways that can not
>>>> happen during ordinary execution of a process.
>>>>
>>>> The plan is to switch the users of cred_guard_mutex to
>>>> exec_udpate_mutex one by one.  This lets us move forward while still
>>>> being careful and not introducing any regressions.
>>>>
>>>> Link: https://lore.kernel.org/lkml/20160921152946.GA24210@dhcp22.suse.cz/
>>>> Link: https://lore.kernel.org/lkml/AM6PR03MB5170B06F3A2B75EFB98D071AE4E60@AM6PR03MB5170.eurprd03.prod.outlook.com/
>>>> Link: https://lore.kernel.org/linux-fsdevel/20161102181806.GB1112@redhat.com/
>>>> Link: https://lore.kernel.org/lkml/20160923095031.GA14923@redhat.com/
>>>> Link: https://lore.kernel.org/lkml/20170213141452.GA30203@redhat.com/
>>>> Ref: 45c1a159b85b ("Add PTRACE_O_TRACEVFORKDONE and PTRACE_O_TRACEEXIT facilities.")
>>>> Ref: 456f17cd1a28 ("[PATCH] user-vm-unlock-2.5.31-A2")
>>>> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
>>>> Signed-off-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
>>>> ---
>>>>  fs/exec.c                    | 17 ++++++++++++++---
>>>>  include/linux/binfmts.h      |  8 +++++++-
>>>>  include/linux/sched/signal.h |  9 ++++++++-
>>>>  init/init_task.c             |  1 +
>>>>  kernel/fork.c                |  1 +
>>>>  5 files changed, 31 insertions(+), 5 deletions(-)
>>>>
>>>> v3: this update fixes lock-order and adds an explicit data member in linux_binprm
>>>>
>>>> diff --git a/fs/exec.c b/fs/exec.c
>>>> index d820a72..11974a1 100644
>>>> --- a/fs/exec.c
>>>> +++ b/fs/exec.c
>>>> @@ -1014,12 +1014,17 @@ static int exec_mmap(struct mm_struct *mm)
>>>>  {
>>>>  	struct task_struct *tsk;
>>>>  	struct mm_struct *old_mm, *active_mm;
>>>> +	int ret;
>>>>  
>>>>  	/* Notify parent that we're no longer interested in the old VM */
>>>>  	tsk = current;
>>>>  	old_mm = current->mm;
>>>>  	exec_mm_release(tsk, old_mm);
>>>>  
>>>> +	ret = mutex_lock_killable(&tsk->signal->exec_update_mutex);
>>>> +	if (ret)
>>>> +		return ret;
>>>> +
>>>>  	if (old_mm) {
>>>>  		sync_mm_rss(old_mm);
>>>>  		/*
>>>> @@ -1031,9 +1036,11 @@ static int exec_mmap(struct mm_struct *mm)
>>>>  		down_read(&old_mm->mmap_sem);
>>>>  		if (unlikely(old_mm->core_state)) {
>>>>  			up_read(&old_mm->mmap_sem);
>>>> +			mutex_unlock(&tsk->signal->exec_update_mutex);
>>>>  			return -EINTR;
>>>>  		}
>>>>  	}
>>>> +
>>>>  	task_lock(tsk);
>>>>  	active_mm = tsk->active_mm;
>>>>  	membarrier_exec_mmap(mm);
>>>> @@ -1288,11 +1295,12 @@ int flush_old_exec(struct linux_binprm * bprm)
>>>>  		goto out;
>>>>  
>>>>  	/*
>>>> -	 * After clearing bprm->mm (to mark that current is using the
>>>> -	 * prepared mm now), we have nothing left of the original
>>>> +	 * After setting bprm->called_exec_mmap (to mark that current is
>>>> +	 * using the prepared mm now), we have nothing left of the original
>>>>  	 * process. If anything from here on returns an error, the check
>>>>  	 * in search_binary_handler() will SEGV current.
>>>>  	 */
>>>> +	bprm->called_exec_mmap = 1;
>>>
>>> The two below is non-breaking pair:
>>>
>>> exec_mmap(bprm->mm);
>>> bprm->called_exec_mmap = 1;
>>>
>>> Why not move this into exec_mmap(), so nobody definitely inserts something
>>> between them?
>>>
>>
>> Hmm, could be done, but then I would probably need a different name than
>> "called_exec_mmap".
>>
>> How about adding a nice function comment to exec_mmap that calls out the
>> changed behaviour that the exec_update_mutex is taken unless the function
>> fails?
> 
> Not sure, I understand correct.
> 
> Could you post this like a small patch hunk (on top of anything you want)?
> 

I was thinking of something like that:

--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1010,6 +1010,11 @@ ssize_t read_code(struct file *file, unsigned long addr, 
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


>> Bernd.
>>
>>
>>>>  	bprm->mm = NULL;
>>>>  
>>>>  #ifdef CONFIG_POSIX_TIMERS
>>>> @@ -1438,6 +1446,8 @@ static void free_bprm(struct linux_binprm *bprm)
>>>>  {
>>>>  	free_arg_pages(bprm);
>>>>  	if (bprm->cred) {
>>>> +		if (bprm->called_exec_mmap)
>>>> +			mutex_unlock(&current->signal->exec_update_mutex);
>>>>  		mutex_unlock(&current->signal->cred_guard_mutex);
>>>>  		abort_creds(bprm->cred);
>>>>  	}
>>>> @@ -1487,6 +1497,7 @@ void install_exec_creds(struct linux_binprm *bprm)
>>>>  	 * credentials; any time after this it may be unlocked.
>>>>  	 */
>>>>  	security_bprm_committed_creds(bprm);
>>>> +	mutex_unlock(&current->signal->exec_update_mutex);
>>>>  	mutex_unlock(&current->signal->cred_guard_mutex);
>>>>  }
>>>>  EXPORT_SYMBOL(install_exec_creds);
>>>> @@ -1678,7 +1689,7 @@ int search_binary_handler(struct linux_binprm *bprm)
>>>>  
>>>>  		read_lock(&binfmt_lock);
>>>>  		put_binfmt(fmt);
>>>> -		if (retval < 0 && !bprm->mm) {
>>>> +		if (retval < 0 && bprm->called_exec_mmap) {
>>>>  			/* we got to flush_old_exec() and failed after it */
>>>>  			read_unlock(&binfmt_lock);
>>>>  			force_sigsegv(SIGSEGV);
>>>> diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
>>>> index b40fc63..a345d9f 100644
>>>> --- a/include/linux/binfmts.h
>>>> +++ b/include/linux/binfmts.h
>>>> @@ -44,7 +44,13 @@ struct linux_binprm {
>>>>  		 * exec has happened. Used to sanitize execution environment
>>>>  		 * and to set AT_SECURE auxv for glibc.
>>>>  		 */
>>>> -		secureexec:1;
>>>> +		secureexec:1,
>>>> +		/*
>>>> +		 * Set by flush_old_exec, when exec_mmap has been called.
>>>> +		 * This is past the point of no return, when the
>>>> +		 * exec_update_mutex has been taken.
>>>> +		 */
>>>> +		called_exec_mmap:1;
>>>>  #ifdef __alpha__
>>>>  	unsigned int taso:1;
>>>>  #endif
>>>> diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
>>>> index 8805025..a29df79 100644
>>>> --- a/include/linux/sched/signal.h
>>>> +++ b/include/linux/sched/signal.h
>>>> @@ -224,7 +224,14 @@ struct signal_struct {
>>>>  
>>>>  	struct mutex cred_guard_mutex;	/* guard against foreign influences on
>>>>  					 * credential calculations
>>>> -					 * (notably. ptrace) */
>>>> +					 * (notably. ptrace)
>>>> +					 * Deprecated do not use in new code.
>>>> +					 * Use exec_update_mutex instead.
>>>> +					 */
>>>> +	struct mutex exec_update_mutex;	/* Held while task_struct is being
>>>> +					 * updated during exec, and may have
>>>> +					 * inconsistent permissions.
>>>> +					 */
>>>>  } __randomize_layout;
>>>>  
>>>>  /*
>>>> diff --git a/init/init_task.c b/init/init_task.c
>>>> index 9e5cbe5..bd403ed 100644
>>>> --- a/init/init_task.c
>>>> +++ b/init/init_task.c
>>>> @@ -26,6 +26,7 @@
>>>>  	.multiprocess	= HLIST_HEAD_INIT,
>>>>  	.rlim		= INIT_RLIMITS,
>>>>  	.cred_guard_mutex = __MUTEX_INITIALIZER(init_signals.cred_guard_mutex),
>>>> +	.exec_update_mutex = __MUTEX_INITIALIZER(init_signals.exec_update_mutex),
>>>>  #ifdef CONFIG_POSIX_TIMERS
>>>>  	.posix_timers = LIST_HEAD_INIT(init_signals.posix_timers),
>>>>  	.cputimer	= {
>>>> diff --git a/kernel/fork.c b/kernel/fork.c
>>>> index 8642530..036b692 100644
>>>> --- a/kernel/fork.c
>>>> +++ b/kernel/fork.c
>>>> @@ -1594,6 +1594,7 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
>>>>  	sig->oom_score_adj_min = current->signal->oom_score_adj_min;
>>>>  
>>>>  	mutex_init(&sig->cred_guard_mutex);
>>>> +	mutex_init(&sig->exec_update_mutex);
>>>>  
>>>>  	return 0;
>>>>  }
>>>>
>>>
> 
