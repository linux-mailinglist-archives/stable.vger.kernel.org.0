Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF67E34936C
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 14:57:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231208AbhCYN4m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 09:56:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbhCYN4m (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Mar 2021 09:56:42 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F343EC06174A;
        Thu, 25 Mar 2021 06:56:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:From:Cc:To;
        bh=BzjlpMJ8U9y+9nVljOOXA5PT0ZC0uN8Sxr5R9mGjEKk=; b=ZOiEDmm9nEKdS58oOJVHND1vkm
        zMtFxNAY9Lj9LUDnVEb6MGC7uvDlqu/vjHZ1ibIAOVGJE/wwaybF6IjeU0FCA0OXnr8j3OY5Wj53P
        bKBW6VHeGIfat7xYFg0lLyqacLCveWWXuS1gHHbbCoOM3IZiC6kxKd2vFh4vZxyk0UFA3MXqYrFle
        3vVnsuLeh2XhiDblZUt+XxV3v8okvZp/WCqdlSSeQdMj+LwDVcbKYdRQ1c3uwxuvhXHFR02QUgHeT
        Etrs7Wo5AJfmmtfMuXkiNbxNULPwJx+7wcwrXIr6lx6ZLeeufg9Z8Dvc/NCacH+q3ZpAoOEiHJv2T
        IYkRaibfa0lquWD2QiaX3sNX/1do5tAW6mSm4WaWxSZoKQQdEPuvWAEvTOCpEurfh2AuZBlqVFZi9
        Aqw2HsexglSHHI08VMFdSgBkCw5Lzy0w17o+sj9XTiNrnVvZGnsM83N7QbVW/Sd/sr8LosMRfzXX3
        fj9JSwRtx2OGwpja8xevUZ07;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lPQTU-0000Cs-8D; Thu, 25 Mar 2021 13:56:36 +0000
Subject: Re: [PATCH AUTOSEL 5.11 43/44] signal: don't allow STOP on
 PF_IO_WORKER threads
To:     Jens Axboe <axboe@kernel.dk>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, io-uring <io-uring@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <20210325112459.1926846-1-sashal@kernel.org>
 <20210325112459.1926846-43-sashal@kernel.org>
 <f4c932b4-b787-651e-dd9f-584b386acddb@samba.org>
 <m1r1k34ey1.fsf@fess.ebiederm.org>
 <41589c56-9219-3ec2-55b3-3f010752ac7b@samba.org>
 <2b2a9701-cbe0-4538-ed3b-6917b85bebf8@kernel.dk>
From:   Stefan Metzmacher <metze@samba.org>
Message-ID: <acf9263d-7572-525d-9116-acb119399c13@samba.org>
Date:   Thu, 25 Mar 2021 14:56:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <2b2a9701-cbe0-4538-ed3b-6917b85bebf8@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 25.03.21 um 14:38 schrieb Jens Axboe:
> On 3/25/21 6:11 AM, Stefan Metzmacher wrote:
>>
>> Am 25.03.21 um 13:04 schrieb Eric W. Biederman:
>>> Stefan Metzmacher <metze@samba.org> writes:
>>>
>>>> Am 25.03.21 um 12:24 schrieb Sasha Levin:
>>>>> From: "Eric W. Biederman" <ebiederm@xmission.com>
>>>>>
>>>>> [ Upstream commit 4db4b1a0d1779dc159f7b87feb97030ec0b12597 ]
>>>>>
>>>>> Just like we don't allow normal signals to IO threads, don't deliver a
>>>>> STOP to a task that has PF_IO_WORKER set. The IO threads don't take
>>>>> signals in general, and have no means of flushing out a stop either.
>>>>>
>>>>> Longer term, we may want to look into allowing stop of these threads,
>>>>> as it relates to eg process freezing. For now, this prevents a spin
>>>>> issue if a SIGSTOP is delivered to the parent task.
>>>>>
>>>>> Reported-by: Stefan Metzmacher <metze@samba.org>
>>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>>> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
>>>>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>>>>> ---
>>>>>  kernel/signal.c | 3 ++-
>>>>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/kernel/signal.c b/kernel/signal.c
>>>>> index 55526b941011..00a3840f6037 100644
>>>>> --- a/kernel/signal.c
>>>>> +++ b/kernel/signal.c
>>>>> @@ -288,7 +288,8 @@ bool task_set_jobctl_pending(struct task_struct *task, unsigned long mask)
>>>>>  			JOBCTL_STOP_SIGMASK | JOBCTL_TRAPPING));
>>>>>  	BUG_ON((mask & JOBCTL_TRAPPING) && !(mask & JOBCTL_PENDING_MASK));
>>>>>  
>>>>> -	if (unlikely(fatal_signal_pending(task) || (task->flags & PF_EXITING)))
>>>>> +	if (unlikely(fatal_signal_pending(task) ||
>>>>> +		     (task->flags & (PF_EXITING | PF_IO_WORKER))))
>>>>>  		return false;
>>>>>  
>>>>>  	if (mask & JOBCTL_STOP_SIGMASK)
>>>>>
>>>>
>>>> Again, why is this proposed for 5.11 and 5.10 already?
>>>
>>> Has the bit about the io worker kthreads been backported?
>>> If so this isn't horrible.  If not this is nonsense.
> 
> No not yet - my plan is to do that, but not until we're 100% satisfied
> with it.

Do you understand why the patches where autoselected for 5.11 and 5.10?

>> I don't know, I hope not...
>>
>> But I just tested v5.12-rc4 and attaching to
>> an application with iothreads with gdb is still not possible,
>> it still loops forever trying to attach to the iothreads.
> 
> I do see the looping, gdb apparently doesn't give up when it gets
> -EPERM trying to attach to the threads. Which isn't really a kernel
> thing, but:

Maybe we need to remove the iothreads from /proc/pid/tasks/

>> And I tested 'kill -9 $pidofiothread', and it feezed the whole
>> machine...
> 
> that sounds very strange, I haven't seen anything like that running
> the exact same scenario.
> 
>> So there's still work to do in order to get 5.12 stable.
>>
>> I'm short on time currently, but I hope to send more details soon.
> 
> Thanks! I'll play with it this morning and see if I can provoke
> something odd related to STOP/attach.

Thanks!

Somehow I have the impression that your same_thread_group_account patch
may fix a lot of things...

metze

