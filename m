Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADFF91834E4
	for <lists+stable@lfdr.de>; Thu, 12 Mar 2020 16:24:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727747AbgCLPXy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Mar 2020 11:23:54 -0400
Received: from relay.sw.ru ([185.231.240.75]:52640 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727446AbgCLPXy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Mar 2020 11:23:54 -0400
Received: from dhcp-172-16-24-104.sw.ru ([172.16.24.104])
        by relay.sw.ru with esmtp (Exim 4.92.3)
        (envelope-from <ktkhai@virtuozzo.com>)
        id 1jCPgC-0008Rx-Fq; Thu, 12 Mar 2020 18:23:24 +0300
Subject: Re: [PATCH v2 5/5] exec: Add a exec_update_mutex to replace
 cred_guard_mutex
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Bernd Edlinger <bernd.edlinger@hotmail.de>,
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
 <20200303085802.eqn6jbhwxtmz4j2x@wittgenstein>
 <AM6PR03MB5170285B336790D3450E2644E4E40@AM6PR03MB5170.eurprd03.prod.outlook.com>
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
From:   Kirill Tkhai <ktkhai@virtuozzo.com>
Message-ID: <f4e941aa-3a63-d74a-4f72-0e81e794f622@virtuozzo.com>
Date:   Thu, 12 Mar 2020 18:23:23 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <87lfo5lju6.fsf@x220.int.ebiederm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12.03.2020 17:38, Eric W. Biederman wrote:
> Kirill Tkhai <ktkhai@virtuozzo.com> writes:
> 
>> On 12.03.2020 15:24, Eric W. Biederman wrote:
>>> Kirill Tkhai <ktkhai@virtuozzo.com> writes:
>>>
>>>> On 09.03.2020 00:38, Eric W. Biederman wrote:
>>>>>
>>>>> The cred_guard_mutex is problematic.  The cred_guard_mutex is held
>>>>> over the userspace accesses as the arguments from userspace are read.
>>>>> The cred_guard_mutex is held of PTRACE_EVENT_EXIT as the the other
>>>>> threads are killed.  The cred_guard_mutex is held over
>>>>> "put_user(0, tsk->clear_child_tid)" in exit_mm().
>>>>>
>>>>> Any of those can result in deadlock, as the cred_guard_mutex is held
>>>>> over a possible indefinite userspace waits for userspace.
>>>>>
>>>>> Add exec_update_mutex that is only held over exec updating process
>>>>> with the new contents of exec, so that code that needs not to be
>>>>> confused by exec changing the mm and the cred in ways that can not
>>>>> happen during ordinary execution of a process.
>>>>>
>>>>> The plan is to switch the users of cred_guard_mutex to
>>>>> exec_udpate_mutex one by one.  This lets us move forward while still
>>>>> being careful and not introducing any regressions.
>>>>>
>>>>> Link: https://lore.kernel.org/lkml/20160921152946.GA24210@dhcp22.suse.cz/
>>>>> Link: https://lore.kernel.org/lkml/AM6PR03MB5170B06F3A2B75EFB98D071AE4E60@AM6PR03MB5170.eurprd03.prod.outlook.com/
>>>>> Link: https://lore.kernel.org/linux-fsdevel/20161102181806.GB1112@redhat.com/
>>>>> Link: https://lore.kernel.org/lkml/20160923095031.GA14923@redhat.com/
>>>>> Link: https://lore.kernel.org/lkml/20170213141452.GA30203@redhat.com/
>>>>> Ref: 45c1a159b85b ("Add PTRACE_O_TRACEVFORKDONE and PTRACE_O_TRACEEXIT facilities.")
>>>>> Ref: 456f17cd1a28 ("[PATCH] user-vm-unlock-2.5.31-A2")
>>>>> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
>>>>> ---
>>>>>  fs/exec.c                    | 9 +++++++++
>>>>>  include/linux/sched/signal.h | 9 ++++++++-
>>>>>  init/init_task.c             | 1 +
>>>>>  kernel/fork.c                | 1 +
>>>>>  4 files changed, 19 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/fs/exec.c b/fs/exec.c
>>>>> index d820a7272a76..ffeebb1f167b 100644
>>>>> --- a/fs/exec.c
>>>>> +++ b/fs/exec.c
>>>>> @@ -1014,6 +1014,7 @@ static int exec_mmap(struct mm_struct *mm)
>>>>>  {
>>>>>  	struct task_struct *tsk;
>>>>>  	struct mm_struct *old_mm, *active_mm;
>>>>> +	int ret;
>>>>>  
>>>>>  	/* Notify parent that we're no longer interested in the old VM */
>>>>>  	tsk = current;
>>>>> @@ -1034,6 +1035,11 @@ static int exec_mmap(struct mm_struct *mm)
>>>>>  			return -EINTR;
>>>>>  		}
>>>>>  	}
>>>>> +
>>>>> +	ret = mutex_lock_killable(&tsk->signal->exec_update_mutex);
>>>>> +	if (ret)
>>>>> +		return ret;
>>>>
>>>> You missed old_mm->mmap_sem unlock. See here:
>>>
>>> Duh.  Thank you.
>>>
>>> I actually need to switch the lock ordering here, and I haven't yet
>>> because my son was sick yesterday.
>>
>> There is some fundamental problem with your patch, since the below fires in 100% cases
>> on current linux-next:
> 
> Thank you.
> 
> I have just backed this out of linux-next for now because it is clearly
> flawed.
> 
> You make some good points about the recursion.  I will go back to the
> drawing board and see what I can work out.
> 
> 
>> [   22.838717] kernel BUG at fs/exec.c:1474!
>>
>> diff --git a/fs/exec.c b/fs/exec.c
>> index 47582cd97f86..0f77f8c94905 100644
>> --- a/fs/exec.c
>> +++ b/fs/exec.c
>> @@ -1470,8 +1470,10 @@ static void free_bprm(struct linux_binprm *bprm)
>>  {
>>  	free_arg_pages(bprm);
>>  	if (bprm->cred) {
>> -		if (!bprm->mm)
>> +		if (!bprm->mm) {
>> +			BUG_ON(!mutex_is_locked(&current->signal->exec_update_mutex));
>>  			mutex_unlock(&current->signal->exec_update_mutex);
>> +		}
>>  		mutex_unlock(&current->signal->cred_guard_mutex);
>>  		abort_creds(bprm->cred);
>>  	}
>> @@ -1521,6 +1523,7 @@ void install_exec_creds(struct linux_binprm *bprm)
>>  	 * credentials; any time after this it may be unlocked.
>>  	 */
>>  	security_bprm_committed_creds(bprm);
>> +	BUG_ON(!mutex_is_locked(&current->signal->exec_update_mutex));
>>  	mutex_unlock(&current->signal->exec_update_mutex);
>>  	mutex_unlock(&current->signal->cred_guard_mutex);
>>  }
>>
>> ---------------------------------------------------------------------------------------------
>>
>> First time the mutex is unlocked in:
>>
>> exec_binprm()->search_binary_handler()->.load_binary->install_exec_creds()
>>
>> Then exec_binprm()->search_binary_handler()->.load_binary->flush_old_exec() clears mm:
>>
>>         bprm->mm = NULL;        
>>
>> Second time the mutex is unlocked in free_bprm():
>>
>> 	if (bprm->cred) {
>>                 if (!bprm->mm)
>>                         mutex_unlock(&current->signal->exec_update_mutex);
>>
>> My opinion is we should not relay on side indicators like bprm->mm. Better you may
>> introduce struct linux_binprm::exec_update_mutex_is_locked. So the next person dealing
>> with this after you won't waste much time on diving into this. Also, if someone decides
>> to change the place, where bprm->mm is set into NULL, this person will bump into hell
>> of dependences between unrelated components like your newly introduced mutex.
>>
>> So, I'm strongly for *struct linux_binprm::exec_update_mutex_is_locked*, since this improves
>> modularity.
> 
> Am I wrong or is that also a problem with cred_guard_mutex?

No, there is no a problem.

cred_guard_mutex is locked in a pair with bprm->cred = prepare_exec_creds() assignment.

cred_guard_mutex is unlocked in a pair with bprm->cred = NULL clearing (see install_exec_creds()).
Further free_bprm() skip unlock in case of bprm->cred is NULL.
