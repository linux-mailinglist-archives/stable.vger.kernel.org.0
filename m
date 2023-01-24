Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 362B6679CBE
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 15:59:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235175AbjAXO7H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 09:59:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235094AbjAXO7G (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 09:59:06 -0500
Received: from frasgout11.his.huawei.com (frasgout11.his.huawei.com [14.137.139.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9596211C;
        Tue, 24 Jan 2023 06:59:04 -0800 (PST)
Received: from mail02.huawei.com (unknown [172.18.147.228])
        by frasgout11.his.huawei.com (SkyGuard) with ESMTP id 4P1VK26lYJz9v7Hb;
        Tue, 24 Jan 2023 22:51:02 +0800 (CST)
Received: from [10.221.98.77] (unknown [10.221.98.77])
        by APP1 (Coremail) with SMTP id LxC2BwD3gAwT8s9jVBrDAA--.44223S2;
        Tue, 24 Jan 2023 15:58:40 +0100 (CET)
Message-ID: <f17dcce0-d510-a112-3127-984e8e73f480@huaweicloud.com>
Date:   Tue, 24 Jan 2023 15:57:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.0
Subject: Re: [PATCH] Fix data race in mark_rt_mutex_waiters
Content-Language: en-US
To:     paulmck@kernel.org
Cc:     Arjan van de Ven <arjan@linux.intel.com>, peterz@infradead.org,
        mingo@redhat.com, will@kernel.org, longman@redhat.com,
        boqun.feng@gmail.com, akpm@osdl.org, tglx@linutronix.de,
        joel@joelfernandes.org, stern@rowland.harvard.edu,
        diogo.behrens@huawei.com, jonas.oberhauser@huawei.com,
        linux-kernel@vger.kernel.org,
        Hernan Ponce de Leon <hernanl.leon@huawei.com>,
        stable@vger.kernel.org
References: <20230120135525.25561-1-hernan.poncedeleon@huaweicloud.com>
 <562c883b-b2c3-3a27-f045-97e7e3281e0b@linux.intel.com>
 <20230120155439.GI2948950@paulmck-ThinkPad-P17-Gen-1>
 <9a1c7959-4b8c-94df-a3e2-e69be72bfd7d@huaweicloud.com>
 <20230123164014.GN2948950@paulmck-ThinkPad-P17-Gen-1>
From:   Hernan Ponce de Leon <hernan.poncedeleon@huaweicloud.com>
In-Reply-To: <20230123164014.GN2948950@paulmck-ThinkPad-P17-Gen-1>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: LxC2BwD3gAwT8s9jVBrDAA--.44223S2
X-Coremail-Antispam: 1UD129KBjvJXoWxury5uF4UXw4UXw13GryrCrg_yoWrXrWDpF
        WrKayktFyDJrs2qr1IqF4xW34Fy39YkFy3Xw1UGryxAas0gF1fAr43C3y3Wryjqr1kt3yY
        vr45Z3429F1DZaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvIb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6r1F6r1fM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxV
        AFwI0_Gr1j6F4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
        6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
        Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7Mxk0xIA0c2IE
        e2xFo4CEbIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxV
        Aqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a
        6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6x
        kF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE
        14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf
        9x07UZ18PUUUUU=
X-CM-SenderInfo: xkhu0tnqos00pfhgvzhhrqqx5xdzvxpfor3voofrz/
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/23/2023 5:40 PM, Paul E. McKenney wrote:
> On Sun, Jan 22, 2023 at 04:24:21PM +0100, Hernan Ponce de Leon wrote:
>> On 1/20/2023 4:54 PM, Paul E. McKenney wrote:
>>> On Fri, Jan 20, 2023 at 06:58:20AM -0800, Arjan van de Ven wrote:
>>>> On 1/20/2023 5:55 AM, Hernan Ponce de Leon wrote:
>>>>> From: Hernan Ponce de Leon <hernanl.leon@huawei.com>
>>>>>
>>>>
>>>>>     kernel/locking/rtmutex.c | 2 +-
>>>>>     1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/kernel/locking/rtmutex.c b/kernel/locking/rtmutex.c
>>>>> index 010cf4e6d0b8..7ed9472edd48 100644
>>>>> --- a/kernel/locking/rtmutex.c
>>>>> +++ b/kernel/locking/rtmutex.c
>>>>> @@ -235,7 +235,7 @@ static __always_inline void mark_rt_mutex_waiters(struct rt_mutex_base *lock)
>>>>>     	unsigned long owner, *p = (unsigned long *) &lock->owner;
>>>>>     	do {
>>>>> -		owner = *p;
>>>>> +		owner = READ_ONCE(*p);
>>>>>     	} while (cmpxchg_relaxed(p, owner,
>>>>
>>>>
>>>> I don't see how this makes any difference at all.
>>>> *p can be read a dozen times and it's fine; cmpxchg has barrier semantics for compilers afaics
>>>
>>> Doing so does suppress a KCSAN warning.  You could also use data_race()
>>> if it turns out that the volatile semantics would prevent a valuable
>>> compiler optimization.
>>
>> I think the import question is "is this a harmful data race (and needs to be
>> fixed as proposed by the patch) or a harmless one (and we should use
>> data_race() to silence tools)?".
>>
>> In https://lkml.org/lkml/2023/1/22/160 I describe how this data race can
>> affect important ordering guarantees for the rest of the code. For this
>> reason I consider it a harmful one. If this is not the case, I would
>> appreciate some feedback or pointer to resources about what races care to
>> avoid spamming the mailing list in the future.
> 
> In the case, the value read is passed into cmpxchg_relaxed(), which
> checks the value against memory.  In this case, as Arjan noted, the only
> compiler-and-silicon difference between data_race() and READ_ONCE()
> is that use of data_race() might allow the compiler to do things like
> tear the load, thus forcing the occasional spurious cmpxchg_relaxed()
> failure.  In contrast, LKMM (by design) throws up its hands when it sees
> a data race.  Something about not being eager to track the idiosyncrasies
> of many compiler versions.
> 
> My approach in my own code is to use *_ONCE() unless it causes a visible
> performance regression or if it confuses KCSAN.  An example of the latter
> can be debug code, in which case use of data_race() avoids suppressing
> KCSAN warnings (and also false positives, depending).

I understand that *_ONCE() might avoid some compiler optimization and 
reduce performance in the general case. However, if I understand your 
first paragraph correctly, in this particular case data_race() could 
allow the CAS to fail more often, resulting in more spinning iterations 
and degraded performance. Am I right?

> 
> Except that your other email seems to also be arguing that additional
> ordering is required.  So is https://lkml.org/lkml/2023/1/20/702 really
> sufficient just by itself, or is additional ordering required?

I do not claim that we need to mark the read to add the ordering that is 
needed for correctness (mutual exclusion). What I claim in this patch is 
that there is a data race, and since it can affect ordering constrains 
in subtle ways, I consider it harmful and thus I want to fix it.

What I explain in the other email is that if we fix the data race, 
either the fence or the acquire store might be relaxed (because marking 
the read gives us some extra ordering guarantees). If the race is not 
fixed, both the fence and the acquire are needed according to LKMM. The 
situation is different wrt hardware models. In that case the tool cannot 
find any violation even if we don't fix the race and we relax the store 
/ remove the fence.

Hernan

