Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE0183491A4
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 13:12:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbhCYMLv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 08:11:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbhCYMLq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Mar 2021 08:11:46 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A224C06174A;
        Thu, 25 Mar 2021 05:11:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:From:Cc:To;
        bh=miwPIcGRmxLognFQqT73uzsqflhmzM1L7+w2rU8vpmM=; b=0zO0h1f70agryRb7uyRn/iCH5S
        W7b5b1W1pqfnbUHSIeHQAG468ootZEDLihJFyseJAxE4CPkwGFtedVi26Pcedayo0SVaTAxfkI+oK
        ENROBq/YJ31yjgKoeOMnarCMxdNOrYWRIRVQMHfwjxGTLjl3sorunH+BQl2SFoncF+JTvvTP8o1tJ
        j1oiMkKHkMyUV4RVjv+eCTGWox2eJxrhEF7D7amj/3fBKIA6do+CSJpmtsXjdKTklZ7z1vqzYdZH4
        QaumKP9rvOqH9/UwPP5XjQXoq+AaJXPwjJSzoqgs+TM1rMyKlVZ2mOBo9s4ipES+uvfNy+1Jl3wNx
        ElY3iN4OsnlfCefug4wMrkrf65uTSSpPStDlGkAkSybeDmOa/jH6Too3gH4lDpcouf97kXAXH2KE2
        me02RrMSTsYolwGRfGIbVOUvxaZvxnrn42NOYvo/dUn/kSSKaVPtyjBuFI7TIMtnzv65ErmCVvMeg
        hUj2X5e5uu9N3rbwY1xpAIvr;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lPOpz-0007nn-AF; Thu, 25 Mar 2021 12:11:43 +0000
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        io-uring <io-uring@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <20210325112459.1926846-1-sashal@kernel.org>
 <20210325112459.1926846-43-sashal@kernel.org>
 <f4c932b4-b787-651e-dd9f-584b386acddb@samba.org>
 <m1r1k34ey1.fsf@fess.ebiederm.org>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: [PATCH AUTOSEL 5.11 43/44] signal: don't allow STOP on
 PF_IO_WORKER threads
Message-ID: <41589c56-9219-3ec2-55b3-3f010752ac7b@samba.org>
Date:   Thu, 25 Mar 2021 13:11:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <m1r1k34ey1.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Am 25.03.21 um 13:04 schrieb Eric W. Biederman:
> Stefan Metzmacher <metze@samba.org> writes:
> 
>> Am 25.03.21 um 12:24 schrieb Sasha Levin:
>>> From: "Eric W. Biederman" <ebiederm@xmission.com>
>>>
>>> [ Upstream commit 4db4b1a0d1779dc159f7b87feb97030ec0b12597 ]
>>>
>>> Just like we don't allow normal signals to IO threads, don't deliver a
>>> STOP to a task that has PF_IO_WORKER set. The IO threads don't take
>>> signals in general, and have no means of flushing out a stop either.
>>>
>>> Longer term, we may want to look into allowing stop of these threads,
>>> as it relates to eg process freezing. For now, this prevents a spin
>>> issue if a SIGSTOP is delivered to the parent task.
>>>
>>> Reported-by: Stefan Metzmacher <metze@samba.org>
>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
>>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>>> ---
>>>  kernel/signal.c | 3 ++-
>>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/kernel/signal.c b/kernel/signal.c
>>> index 55526b941011..00a3840f6037 100644
>>> --- a/kernel/signal.c
>>> +++ b/kernel/signal.c
>>> @@ -288,7 +288,8 @@ bool task_set_jobctl_pending(struct task_struct *task, unsigned long mask)
>>>  			JOBCTL_STOP_SIGMASK | JOBCTL_TRAPPING));
>>>  	BUG_ON((mask & JOBCTL_TRAPPING) && !(mask & JOBCTL_PENDING_MASK));
>>>  
>>> -	if (unlikely(fatal_signal_pending(task) || (task->flags & PF_EXITING)))
>>> +	if (unlikely(fatal_signal_pending(task) ||
>>> +		     (task->flags & (PF_EXITING | PF_IO_WORKER))))
>>>  		return false;
>>>  
>>>  	if (mask & JOBCTL_STOP_SIGMASK)
>>>
>>
>> Again, why is this proposed for 5.11 and 5.10 already?
> 
> Has the bit about the io worker kthreads been backported?
> If so this isn't horrible.  If not this is nonsense.

I don't know, I hope not...

But I just tested v5.12-rc4 and attaching to
an application with iothreads with gdb is still not possible,
it still loops forever trying to attach to the iothreads.

And I tested 'kill -9 $pidofiothread', and it feezed the whole
machine...

So there's still work to do in order to get 5.12 stable.

I'm short on time currently, but I hope to send more details soon.

metze
