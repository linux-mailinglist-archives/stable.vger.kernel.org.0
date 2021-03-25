Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 203233494D2
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 16:01:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230416AbhCYPBT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 11:01:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:32892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229869AbhCYPAr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 11:00:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9154C61A07;
        Thu, 25 Mar 2021 15:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616684446;
        bh=13C25K8GpAKJvovS5Zi7tPUjVBZx0IifXkUDl2Fuozg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BEMgf6QbLULmr/G2Li61zttTA9RP/kiQu53Ypg/vwWSSg0Fah5HIboCQQ7xxgugl2
         Sp97QocjvZHLerpimRbrwUb0/1P4DEhiROkZ/pG2FjqEYo5KBv5dUBk8lW+N+nQ1Qb
         GQqXTRRb7w2c+yFiXElINyoLKDOckcxlpI8favSwt8EwfezI6Zlh9N6mk9/O1jyuSl
         Jpi+3t+KT+IWYh8sbOSZJCKk40hM4WvGmaftbBBi20PgjjG0E2cImq9b/D7kyygh43
         3Hym/fbhIHTqLfQ7HzjSM0nFG8DQoWi5NxFGWjZTiMapdJMWYdXtAdPvlb1RVE3qI5
         nVkzKl2AjlNzA==
Date:   Thu, 25 Mar 2021 11:00:45 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Stefan Metzmacher <metze@samba.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        io-uring <io-uring@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH AUTOSEL 5.11 43/44] signal: don't allow STOP on
 PF_IO_WORKER threads
Message-ID: <YFylnZ6eEEObO4FT@sashalap>
References: <20210325112459.1926846-1-sashal@kernel.org>
 <20210325112459.1926846-43-sashal@kernel.org>
 <f4c932b4-b787-651e-dd9f-584b386acddb@samba.org>
 <m1r1k34ey1.fsf@fess.ebiederm.org>
 <41589c56-9219-3ec2-55b3-3f010752ac7b@samba.org>
 <2b2a9701-cbe0-4538-ed3b-6917b85bebf8@kernel.dk>
 <acf9263d-7572-525d-9116-acb119399c13@samba.org>
 <15712d38-8ea4-e8c7-85ba-9d800b99c976@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <15712d38-8ea4-e8c7-85ba-9d800b99c976@kernel.dk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 25, 2021 at 08:02:11AM -0600, Jens Axboe wrote:
>On 3/25/21 7:56 AM, Stefan Metzmacher wrote:
>> Am 25.03.21 um 14:38 schrieb Jens Axboe:
>>> On 3/25/21 6:11 AM, Stefan Metzmacher wrote:
>>>>
>>>> Am 25.03.21 um 13:04 schrieb Eric W. Biederman:
>>>>> Stefan Metzmacher <metze@samba.org> writes:
>>>>>
>>>>>> Am 25.03.21 um 12:24 schrieb Sasha Levin:
>>>>>>> From: "Eric W. Biederman" <ebiederm@xmission.com>
>>>>>>>
>>>>>>> [ Upstream commit 4db4b1a0d1779dc159f7b87feb97030ec0b12597 ]
>>>>>>>
>>>>>>> Just like we don't allow normal signals to IO threads, don't deliver a
>>>>>>> STOP to a task that has PF_IO_WORKER set. The IO threads don't take
>>>>>>> signals in general, and have no means of flushing out a stop either.
>>>>>>>
>>>>>>> Longer term, we may want to look into allowing stop of these threads,
>>>>>>> as it relates to eg process freezing. For now, this prevents a spin
>>>>>>> issue if a SIGSTOP is delivered to the parent task.
>>>>>>>
>>>>>>> Reported-by: Stefan Metzmacher <metze@samba.org>
>>>>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>>>>> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
>>>>>>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>>>>>>> ---
>>>>>>>  kernel/signal.c | 3 ++-
>>>>>>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>>>>>>
>>>>>>> diff --git a/kernel/signal.c b/kernel/signal.c
>>>>>>> index 55526b941011..00a3840f6037 100644
>>>>>>> --- a/kernel/signal.c
>>>>>>> +++ b/kernel/signal.c
>>>>>>> @@ -288,7 +288,8 @@ bool task_set_jobctl_pending(struct task_struct *task, unsigned long mask)
>>>>>>>  			JOBCTL_STOP_SIGMASK | JOBCTL_TRAPPING));
>>>>>>>  	BUG_ON((mask & JOBCTL_TRAPPING) && !(mask & JOBCTL_PENDING_MASK));
>>>>>>>
>>>>>>> -	if (unlikely(fatal_signal_pending(task) || (task->flags & PF_EXITING)))
>>>>>>> +	if (unlikely(fatal_signal_pending(task) ||
>>>>>>> +		     (task->flags & (PF_EXITING | PF_IO_WORKER))))
>>>>>>>  		return false;
>>>>>>>
>>>>>>>  	if (mask & JOBCTL_STOP_SIGMASK)
>>>>>>>
>>>>>>
>>>>>> Again, why is this proposed for 5.11 and 5.10 already?
>>>>>
>>>>> Has the bit about the io worker kthreads been backported?
>>>>> If so this isn't horrible.  If not this is nonsense.
>>>
>>> No not yet - my plan is to do that, but not until we're 100% satisfied
>>> with it.
>>
>> Do you understand why the patches where autoselected for 5.11 and 5.10?
>
>As far as I know, selections like these (AUTOSEL) are done by some bot
>that uses whatever criteria to see if they should be applied for earlier
>revisions. I'm sure Sasha can expand on that :-)

Right, it's just heuristics that help catch commits that don't have a
stable tag but should have one.

>Hence it's reasonable to expect that sometimes it'll pick patches that
>should not go into stable, at least not just yet. It's important to
>understand that this message is just a notice that it's queued up for
>stable -rc, not that it's _in_ stable just yet. There's time to object.

Right, it's even more than that: this mail (tagged with "AUTOSEL") is a
notification that happens at least a week before the patch will go in
the stable queue.

If you think any AUTOSEL patches don't need to be backported, it's
usually enough to just quickly nack them.

-- 
Thanks,
Sasha
