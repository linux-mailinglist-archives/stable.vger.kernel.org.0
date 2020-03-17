Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 903AD1890CA
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 22:54:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbgCQVyC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 17:54:02 -0400
Received: from mail-oln040092067070.outbound.protection.outlook.com ([40.92.67.70]:1997
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726476AbgCQVyC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 17:54:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iw8Ndk/3sWB8zc1KPd/+HbEoqJWMw0XjLBQAREKEKXwpsyVKmtya6ycwjNUUx1nTFYs6aIFyRdA+e1lXh8dqxBZJaSL2HcZCYOmorhv4Ppu+EtM1ODh3M8h0axACBr1xok6Yuw0sIhLv/YqJukIjKeKlh6dNWaREMI8hGKN1dzT100WWwBX4P8FdvO/up2padfDWzMczo6wHbyiYzxm3r+scoJ09qiKh2ptiD3YSzQ0pWlel9XieJoQHGGEfvz0nYiuKRiMM1uPAwaVopnyPVJzaVnVgAA19wtYrXgOSBBSKtHW7dLHpusKEdFti3tRA97UEknWRrJCFVzrYBBhz8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MfMUk+TYbhQyo069Y4tQCMdCoA1e5S3Vfl146EIzwEQ=;
 b=IrqQ5wiQRpRlgDpTApu/Ko+UnsQOIOuyrZf1kbA2wp+Oi2OLf8dezEsZH2Fatl8zpTUDrOG7jDEdCeJn3ao3zq6tVssmE00w+nQKfLbhlqm6waxNKAaftY5SNzX9YEsw2P4eNutQF9T/84o91bMyrEL9H4pkZX/mJBDo7MHdWnIcOTu/kECFGBlDpxhVmXTpBVJyRRY5uGLxaCRW58Mk1iHJ3n6EXQGjie68DDvDNbufytCuGgyvVpBZCJKz1MYfmizVvwBHxpS6yHDVFD10N3yNmQWyGD7epOXl0VqL8REL/YLFcsr8xyK/xxKSFgYioYi1Qo6JLCPu58nVU0/2bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hotmail.de; dmarc=pass action=none header.from=hotmail.de;
 dkim=pass header.d=hotmail.de; arc=none
Received: from VE1EUR02FT042.eop-EUR02.prod.protection.outlook.com
 (2a01:111:e400:7e1e::3c) by
 VE1EUR02HT124.eop-EUR02.prod.protection.outlook.com (2a01:111:e400:7e1e::486)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.13; Tue, 17 Mar
 2020 21:53:55 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.152.12.52) by
 VE1EUR02FT042.mail.protection.outlook.com (10.152.13.70) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.13 via Frontend Transport; Tue, 17 Mar 2020 21:53:55 +0000
X-IncomingTopHeaderMarker: OriginalChecksum:079933D0050953D00B1595D7E3EC684E4BEF8D14F99B4452C7BD7C512A7578A2;UpperCasedChecksum:5E4B4C9D9934F285B603CFBB35EAAC433D00F82E1FC5487E6098010C116CAE70;SizeAsReceived:10391;Count:50
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2814.021; Tue, 17 Mar 2020
 21:53:55 +0000
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
 <AM6PR03MB5170353DF3575FF7742BB155E4FB0@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <532ce6a3-f0df-e3e4-6966-473c608246e1@virtuozzo.com>
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
Message-ID: <AM6PR03MB51705D8A5631B53844CE447CE4F60@AM6PR03MB5170.eurprd03.prod.outlook.com>
Date:   Tue, 17 Mar 2020 22:53:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
In-Reply-To: <532ce6a3-f0df-e3e4-6966-473c608246e1@virtuozzo.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0033.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:14::20) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
X-Microsoft-Original-Message-ID: <cf066e98-79a3-9506-e0cc-4c0b7a6bca33@hotmail.de>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.101] (92.77.140.102) by FR2P281CA0033.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:14::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.19 via Frontend Transport; Tue, 17 Mar 2020 21:53:53 +0000
X-Microsoft-Original-Message-ID: <cf066e98-79a3-9506-e0cc-4c0b7a6bca33@hotmail.de>
X-TMN:  [8/u1as5RDCi+LfL4ERhF3MFusUC8BGOx]
X-MS-PublicTrafficType: Email
X-IncomingHeaderCount: 50
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-Correlation-Id: 1f106d70-f042-4d65-8777-08d7cabdb042
X-MS-TrafficTypeDiagnostic: VE1EUR02HT124:
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HdG5v9lvssNH7faA1LgXrFWy8Zrb2UEBeqQMlMx4gin9j2EeN/XfeXY8s2ZFdOKbKe+2EDn9T9j9CQ6g3MZKW9+OTA3Ezzx1RJa4IJH2pYB1m78D2ofvq2jNboKxH0t2LUl4m0KYi68n+S91WPYXy0Jg/Zu0Ant+FDrwMhqCQTjIbbMNu795hxS4IWTt/7sOLNBPZHgg4XUzWp6UDSkrZ2NKsAVux3gXOvoZNvlMxlQ=
X-MS-Exchange-AntiSpam-MessageData: 8k8bx8BQpTlW5h6QHUM9jc0hB/GeSPzqQ1bLCi2KmjJIYAnHEGlTcr0Pt8BHv6pZb5Lr134A8Lds0clpZS3F/ziWXtlvcjdB+RS7bPlMqP6n32wfDq517BssnWnC3uwsfsi0Vas3Zu/g5PB85Nuvmg==
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f106d70-f042-4d65-8777-08d7cabdb042
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2020 21:53:55.5961
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-FromEntityHeader: Internet
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1EUR02HT124
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/17/20 9:56 AM, Kirill Tkhai wrote:
> On 14.03.2020 12:11, Bernd Edlinger wrote:
>> The cred_guard_mutex is problematic.  The cred_guard_mutex is held
>> over the userspace accesses as the arguments from userspace are read.
>> The cred_guard_mutex is held of PTRACE_EVENT_EXIT as the the other
>> threads are killed.  The cred_guard_mutex is held over
>> "put_user(0, tsk->clear_child_tid)" in exit_mm().
>>
>> Any of those can result in deadlock, as the cred_guard_mutex is held
>> over a possible indefinite userspace waits for userspace.
>>
>> Add exec_update_mutex that is only held over exec updating process
>> with the new contents of exec, so that code that needs not to be
>> confused by exec changing the mm and the cred in ways that can not
>> happen during ordinary execution of a process.
>>
>> The plan is to switch the users of cred_guard_mutex to
>> exec_udpate_mutex one by one.  This lets us move forward while still
>> being careful and not introducing any regressions.
>>
>> Link: https://lore.kernel.org/lkml/20160921152946.GA24210@dhcp22.suse.cz/
>> Link: https://lore.kernel.org/lkml/AM6PR03MB5170B06F3A2B75EFB98D071AE4E60@AM6PR03MB5170.eurprd03.prod.outlook.com/
>> Link: https://lore.kernel.org/linux-fsdevel/20161102181806.GB1112@redhat.com/
>> Link: https://lore.kernel.org/lkml/20160923095031.GA14923@redhat.com/
>> Link: https://lore.kernel.org/lkml/20170213141452.GA30203@redhat.com/
>> Ref: 45c1a159b85b ("Add PTRACE_O_TRACEVFORKDONE and PTRACE_O_TRACEEXIT facilities.")
>> Ref: 456f17cd1a28 ("[PATCH] user-vm-unlock-2.5.31-A2")
>> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
>> Signed-off-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
>> ---
>>  fs/exec.c                    | 17 ++++++++++++++---
>>  include/linux/binfmts.h      |  8 +++++++-
>>  include/linux/sched/signal.h |  9 ++++++++-
>>  init/init_task.c             |  1 +
>>  kernel/fork.c                |  1 +
>>  5 files changed, 31 insertions(+), 5 deletions(-)
>>
>> v3: this update fixes lock-order and adds an explicit data member in linux_binprm
>>
>> diff --git a/fs/exec.c b/fs/exec.c
>> index d820a72..11974a1 100644
>> --- a/fs/exec.c
>> +++ b/fs/exec.c
>> @@ -1014,12 +1014,17 @@ static int exec_mmap(struct mm_struct *mm)
>>  {
>>  	struct task_struct *tsk;
>>  	struct mm_struct *old_mm, *active_mm;
>> +	int ret;
>>  
>>  	/* Notify parent that we're no longer interested in the old VM */
>>  	tsk = current;
>>  	old_mm = current->mm;
>>  	exec_mm_release(tsk, old_mm);
>>  
>> +	ret = mutex_lock_killable(&tsk->signal->exec_update_mutex);
>> +	if (ret)
>> +		return ret;
>> +
>>  	if (old_mm) {
>>  		sync_mm_rss(old_mm);
>>  		/*
>> @@ -1031,9 +1036,11 @@ static int exec_mmap(struct mm_struct *mm)
>>  		down_read(&old_mm->mmap_sem);
>>  		if (unlikely(old_mm->core_state)) {
>>  			up_read(&old_mm->mmap_sem);
>> +			mutex_unlock(&tsk->signal->exec_update_mutex);
>>  			return -EINTR;
>>  		}
>>  	}
>> +
>>  	task_lock(tsk);
>>  	active_mm = tsk->active_mm;
>>  	membarrier_exec_mmap(mm);
>> @@ -1288,11 +1295,12 @@ int flush_old_exec(struct linux_binprm * bprm)
>>  		goto out;
>>  
>>  	/*
>> -	 * After clearing bprm->mm (to mark that current is using the
>> -	 * prepared mm now), we have nothing left of the original
>> +	 * After setting bprm->called_exec_mmap (to mark that current is
>> +	 * using the prepared mm now), we have nothing left of the original
>>  	 * process. If anything from here on returns an error, the check
>>  	 * in search_binary_handler() will SEGV current.
>>  	 */
>> +	bprm->called_exec_mmap = 1;
> 
> The two below is non-breaking pair:
> 
> exec_mmap(bprm->mm);
> bprm->called_exec_mmap = 1;
> 
> Why not move this into exec_mmap(), so nobody definitely inserts something
> between them?
> 

Hmm, could be done, but then I would probably need a different name than
"called_exec_mmap".

How about adding a nice function comment to exec_mmap that calls out the
changed behaviour that the exec_update_mutex is taken unless the function
fails?


Bernd.


>>  	bprm->mm = NULL;
>>  
>>  #ifdef CONFIG_POSIX_TIMERS
>> @@ -1438,6 +1446,8 @@ static void free_bprm(struct linux_binprm *bprm)
>>  {
>>  	free_arg_pages(bprm);
>>  	if (bprm->cred) {
>> +		if (bprm->called_exec_mmap)
>> +			mutex_unlock(&current->signal->exec_update_mutex);
>>  		mutex_unlock(&current->signal->cred_guard_mutex);
>>  		abort_creds(bprm->cred);
>>  	}
>> @@ -1487,6 +1497,7 @@ void install_exec_creds(struct linux_binprm *bprm)
>>  	 * credentials; any time after this it may be unlocked.
>>  	 */
>>  	security_bprm_committed_creds(bprm);
>> +	mutex_unlock(&current->signal->exec_update_mutex);
>>  	mutex_unlock(&current->signal->cred_guard_mutex);
>>  }
>>  EXPORT_SYMBOL(install_exec_creds);
>> @@ -1678,7 +1689,7 @@ int search_binary_handler(struct linux_binprm *bprm)
>>  
>>  		read_lock(&binfmt_lock);
>>  		put_binfmt(fmt);
>> -		if (retval < 0 && !bprm->mm) {
>> +		if (retval < 0 && bprm->called_exec_mmap) {
>>  			/* we got to flush_old_exec() and failed after it */
>>  			read_unlock(&binfmt_lock);
>>  			force_sigsegv(SIGSEGV);
>> diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
>> index b40fc63..a345d9f 100644
>> --- a/include/linux/binfmts.h
>> +++ b/include/linux/binfmts.h
>> @@ -44,7 +44,13 @@ struct linux_binprm {
>>  		 * exec has happened. Used to sanitize execution environment
>>  		 * and to set AT_SECURE auxv for glibc.
>>  		 */
>> -		secureexec:1;
>> +		secureexec:1,
>> +		/*
>> +		 * Set by flush_old_exec, when exec_mmap has been called.
>> +		 * This is past the point of no return, when the
>> +		 * exec_update_mutex has been taken.
>> +		 */
>> +		called_exec_mmap:1;
>>  #ifdef __alpha__
>>  	unsigned int taso:1;
>>  #endif
>> diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
>> index 8805025..a29df79 100644
>> --- a/include/linux/sched/signal.h
>> +++ b/include/linux/sched/signal.h
>> @@ -224,7 +224,14 @@ struct signal_struct {
>>  
>>  	struct mutex cred_guard_mutex;	/* guard against foreign influences on
>>  					 * credential calculations
>> -					 * (notably. ptrace) */
>> +					 * (notably. ptrace)
>> +					 * Deprecated do not use in new code.
>> +					 * Use exec_update_mutex instead.
>> +					 */
>> +	struct mutex exec_update_mutex;	/* Held while task_struct is being
>> +					 * updated during exec, and may have
>> +					 * inconsistent permissions.
>> +					 */
>>  } __randomize_layout;
>>  
>>  /*
>> diff --git a/init/init_task.c b/init/init_task.c
>> index 9e5cbe5..bd403ed 100644
>> --- a/init/init_task.c
>> +++ b/init/init_task.c
>> @@ -26,6 +26,7 @@
>>  	.multiprocess	= HLIST_HEAD_INIT,
>>  	.rlim		= INIT_RLIMITS,
>>  	.cred_guard_mutex = __MUTEX_INITIALIZER(init_signals.cred_guard_mutex),
>> +	.exec_update_mutex = __MUTEX_INITIALIZER(init_signals.exec_update_mutex),
>>  #ifdef CONFIG_POSIX_TIMERS
>>  	.posix_timers = LIST_HEAD_INIT(init_signals.posix_timers),
>>  	.cputimer	= {
>> diff --git a/kernel/fork.c b/kernel/fork.c
>> index 8642530..036b692 100644
>> --- a/kernel/fork.c
>> +++ b/kernel/fork.c
>> @@ -1594,6 +1594,7 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
>>  	sig->oom_score_adj_min = current->signal->oom_score_adj_min;
>>  
>>  	mutex_init(&sig->cred_guard_mutex);
>> +	mutex_init(&sig->exec_update_mutex);
>>  
>>  	return 0;
>>  }
>>
> 
