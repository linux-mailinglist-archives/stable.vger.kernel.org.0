Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8C3184372
	for <lists+stable@lfdr.de>; Fri, 13 Mar 2020 10:13:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbgCMJNo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Mar 2020 05:13:44 -0400
Received: from relay.sw.ru ([185.231.240.75]:56008 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726230AbgCMJNn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Mar 2020 05:13:43 -0400
Received: from dhcp-172-16-24-104.sw.ru ([172.16.24.104])
        by relay.sw.ru with esmtp (Exim 4.92.3)
        (envelope-from <ktkhai@virtuozzo.com>)
        id 1jCgNL-0005Fb-2f; Fri, 13 Mar 2020 12:13:03 +0300
Subject: Re: [PATCH v2 5/5] exec: Add a exec_update_mutex to replace
 cred_guard_mutex
To:     Bernd Edlinger <bernd.edlinger@hotmail.de>,
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
From:   Kirill Tkhai <ktkhai@virtuozzo.com>
Message-ID: <6002ac56-025a-d50f-e89d-1bf42a072323@virtuozzo.com>
Date:   Fri, 13 Mar 2020 12:13:02 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <AM6PR03MB5170E9E71B9F84330B098BADE4FA0@AM6PR03MB5170.eurprd03.prod.outlook.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 13.03.2020 04:05, Bernd Edlinger wrote:
> On 3/12/20 3:38 PM, Eric W. Biederman wrote:
>> Kirill Tkhai <ktkhai@virtuozzo.com> writes:
>>
>>> On 12.03.2020 15:24, Eric W. Biederman wrote:
>>>>
>>>> I actually need to switch the lock ordering here, and I haven't yet
>>>> because my son was sick yesterday.
> 
> All the best wishes to you and your son.  I hope he will get well soon.
> 
> And sorry for not missing the issue in the review.  The reason turns
> out that bprm_mm_init is called after prepare_bprm_creds, but there
> are error pathes between those where free_bprm is called up with
> cred != NULL and mm == NULL, but the mutex not locked.
> 
> I figured out a possible fix for the problem that was pointed out:
> 
> 
> From ceb6f65b52b3a7f0280f4f20509a1564a439edf6 Mon Sep 17 00:00:00 2001
> From: Bernd Edlinger <bernd.edlinger@hotmail.de>
> Date: Wed, 11 Mar 2020 15:31:07 +0100
> Subject: [PATCH] Fix issues with exec_update_mutex
> 
> Signed-off-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
> ---
>  fs/exec.c | 17 ++++++++++-------
>  1 file changed, 10 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/exec.c b/fs/exec.c
> index ffeebb1..cde4937 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1021,8 +1021,14 @@ static int exec_mmap(struct mm_struct *mm)
>  	old_mm = current->mm;
>  	exec_mm_release(tsk, old_mm);
>  
> -	if (old_mm) {
> +	if (old_mm)
>  		sync_mm_rss(old_mm);
> +
> +	ret = mutex_lock_killable(&tsk->signal->exec_update_mutex);
> +	if (ret)
> +		return ret;
> +
> +	if (old_mm) {
>  		/*
>  		 * Make sure that if there is a core dump in progress
>  		 * for the old mm, we get out and die instead of going
> @@ -1032,14 +1038,11 @@ static int exec_mmap(struct mm_struct *mm)
>  		down_read(&old_mm->mmap_sem);
>  		if (unlikely(old_mm->core_state)) {
>  			up_read(&old_mm->mmap_sem);
> +			mutex_unlock(&tsk->signal->exec_update_mutex);
>  			return -EINTR;
>  		}
>  	}
>  
> -	ret = mutex_lock_killable(&tsk->signal->exec_update_mutex);
> -	if (ret)
> -		return ret;
> -
>  	task_lock(tsk);
>  	active_mm = tsk->active_mm;
>  	membarrier_exec_mmap(mm);
> @@ -1444,8 +1447,6 @@ static void free_bprm(struct linux_binprm *bprm)
>  {
>  	free_arg_pages(bprm);
>  	if (bprm->cred) {
> -		if (!bprm->mm)
> -			mutex_unlock(&current->signal->exec_update_mutex);
>  		mutex_unlock(&current->signal->cred_guard_mutex);
>  		abort_creds(bprm->cred);
>  	}
> @@ -1846,6 +1847,8 @@ static int __do_execve_file(int fd, struct filename *filename,
>  	would_dump(bprm, bprm->file);
>  
>  	retval = exec_binprm(bprm);
> +	if (bprm->cred && !bprm->mm)
> +		mutex_unlock(&current->signal->exec_update_mutex);

Despite this should fix the problem, this looks like a broken puzzle.

We can't use bprm->cred as an identifier whether the mutex was locked or not.
We can check for bprm->cred in regard to cred_guard_mutex, because of there is
strong rule: "cred_guard_mutex is becomes locked together with bprm->cred assignment
(see prepare_bprm_creds()), and it becomes unlocked together with bprm->cred zeroing".
Take attention on modularity of all this: there is no dependencies between anything else.

In regard to newly introduced exec_update_mutex, your fix and source patch way look like
an obfuscation. The mutex becomes deadly glued to unrelated bprm->cred and bprm->mm,
and this introduces the problems in the future modifications and support of all involved
entities. If someone wants to move some functions in relation to each other, there will
be a pain, and this person will have to go again the same dependencies and bug way,
Eric stepped on in the original patch.
