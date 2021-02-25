Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C24F4324C3D
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 09:52:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236011AbhBYIvh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 03:51:37 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:12207 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232177AbhBYIvg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Feb 2021 03:51:36 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DmRKF55mFzlPYB;
        Thu, 25 Feb 2021 16:48:49 +0800 (CST)
Received: from [10.67.110.218] (10.67.110.218) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Thu, 25 Feb 2021 16:50:45 +0800
Subject: Re: [PATCH 4.9.y 1/1] futex: Fix OWNER_DEAD fixup
To:     Lee Jones <lee.jones@linaro.org>
CC:     <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <cj.chengjian@huawei.com>, <judy.chenhui@huawei.com>,
        <zhangjinhao2@huawei.com>
References: <20210223144151.916675-1-zhengyejian1@huawei.com>
 <20210223144151.916675-2-zhengyejian1@huawei.com>
 <20210224111915.GA641347@dell>
 <09cd79ce-291a-1750-6954-ecde0a6bdfcf@huawei.com>
 <20210225080930.GB641347@dell>
From:   "Zhengyejian (Zetta)" <zhengyejian1@huawei.com>
Message-ID: <69c1801e-f126-f83e-6bda-9eb5e029f6a5@huawei.com>
Date:   Thu, 25 Feb 2021 16:50:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210225080930.GB641347@dell>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.110.218]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2021/2/25 16:09, Lee Jones wrote:
> On Thu, 25 Feb 2021, Zhengyejian (Zetta) wrote:
> 
>>
>>
>> On 2021/2/24 19:19, Lee Jones wrote:
>>> On Tue, 23 Feb 2021, Zheng Yejian wrote:
>>>
>>>> From: Peter Zijlstra <peterz@infradead.org>
>>>>
>>>> commit a97cb0e7b3f4c6297fd857055ae8e895f402f501 upstream.
>>>>
>>>> Both Geert and DaveJ reported that the recent futex commit:
>>>>
>>>>     c1e2f0eaf015 ("futex: Avoid violating the 10th rule of futex")
>>>>
>>>> introduced a problem with setting OWNER_DEAD. We set the bit on an
>>>> uninitialized variable and then entirely optimize it away as a
>>>> dead-store.
>>>>
>>>> Move the setting of the bit to where it is more useful.
>>>>
>>>> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
>>>> Reported-by: Dave Jones <davej@codemonkey.org.uk>
>>>> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
>>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>>> Cc: Linus Torvalds <torvalds@linux-foundation.org>
>>>> Cc: Paul E. McKenney <paulmck@us.ibm.com>
>>>> Cc: Peter Zijlstra <peterz@infradead.org>
>>>> Cc: Thomas Gleixner <tglx@linutronix.de>
>>>> Fixes: c1e2f0eaf015 ("futex: Avoid violating the 10th rule of futex")
>>>> Link: http://lkml.kernel.org/r/20180122103947.GD2228@hirez.programming.kicks-ass.net
>>>> Signed-off-by: Ingo Molnar <mingo@kernel.org>
>>>> Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>
>>>
>>> Why have you dropped my Reviewed-by?
>>>
>> Really sorry. I thought that a changed patchset needs another review.
>> Then I do need to append your Reviewed-by and send a "V2" patchset, Do I?
> 
> No need.  I won't hold up merging just for that.
> 
> Just bear in mind that you should apply and carry forward *-by tags
> unless there have been significant/functional changes.
> 
> Reviewed-by: Lee Jones <lee.jones@linaro.org>
> 

I get it, thanks.

>>>> ---
>>>>    kernel/futex.c | 6 +++---
>>>>    1 file changed, 3 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/kernel/futex.c b/kernel/futex.c
>>>> index b65dbb5d60bb..604d1cb9839d 100644
>>>> --- a/kernel/futex.c
>>>> +++ b/kernel/futex.c
>>>> @@ -2424,9 +2424,6 @@ static int __fixup_pi_state_owner(u32 __user *uaddr, struct futex_q *q,
>>>>    	int err = 0;
>>>>    	oldowner = pi_state->owner;
>>>> -	/* Owner died? */
>>>> -	if (!pi_state->owner)
>>>> -		newtid |= FUTEX_OWNER_DIED;
>>>>    	/*
>>>>    	 * We are here because either:
>>>> @@ -2484,6 +2481,9 @@ static int __fixup_pi_state_owner(u32 __user *uaddr, struct futex_q *q,
>>>>    	}
>>>>    	newtid = task_pid_vnr(newowner) | FUTEX_WAITERS;
>>>> +	/* Owner died? */
>>>> +	if (!pi_state->owner)
>>>> +		newtid |= FUTEX_OWNER_DIED;
>>>>    	if (get_futex_value_locked(&uval, uaddr))
>>>>    		goto handle_fault;
>>>
> 
