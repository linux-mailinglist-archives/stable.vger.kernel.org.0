Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D197676FC4
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:25:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231381AbjAVPZD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:25:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231373AbjAVPZC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:25:02 -0500
Received: from frasgout11.his.huawei.com (frasgout11.his.huawei.com [14.137.139.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3B5B222C8;
        Sun, 22 Jan 2023 07:25:00 -0800 (PST)
Received: from mail02.huawei.com (unknown [172.18.147.227])
        by frasgout11.his.huawei.com (SkyGuard) with ESMTP id 4P0Gzw4G5Mz9y4Zd;
        Sun, 22 Jan 2023 23:17:00 +0800 (CST)
Received: from [10.48.133.163] (unknown [10.48.133.163])
        by APP2 (Coremail) with SMTP id GxC2BwAH3WMnVc1jR4O4AA--.31050S2;
        Sun, 22 Jan 2023 16:24:34 +0100 (CET)
Message-ID: <9a1c7959-4b8c-94df-a3e2-e69be72bfd7d@huaweicloud.com>
Date:   Sun, 22 Jan 2023 16:24:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.0
Subject: Re: [PATCH] Fix data race in mark_rt_mutex_waiters
Content-Language: en-US
To:     paulmck@kernel.org, Arjan van de Ven <arjan@linux.intel.com>
Cc:     peterz@infradead.org, mingo@redhat.com, will@kernel.org,
        longman@redhat.com, boqun.feng@gmail.com, akpm@osdl.org,
        tglx@linutronix.de, joel@joelfernandes.org,
        stern@rowland.harvard.edu, diogo.behrens@huawei.com,
        jonas.oberhauser@huawei.com, linux-kernel@vger.kernel.org,
        Hernan Ponce de Leon <hernanl.leon@huawei.com>,
        stable@vger.kernel.org
References: <20230120135525.25561-1-hernan.poncedeleon@huaweicloud.com>
 <562c883b-b2c3-3a27-f045-97e7e3281e0b@linux.intel.com>
 <20230120155439.GI2948950@paulmck-ThinkPad-P17-Gen-1>
From:   Hernan Ponce de Leon <hernan.poncedeleon@huaweicloud.com>
In-Reply-To: <20230120155439.GI2948950@paulmck-ThinkPad-P17-Gen-1>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: GxC2BwAH3WMnVc1jR4O4AA--.31050S2
X-Coremail-Antispam: 1UD129KBjvJXoW7CFy5Ww15Ww47ZrW8ZrW3Awb_yoW8WF48pF
        yrGay8tFWUtr40vry09Fn2gry5t3y5CFWfC3W7G348Aas8tFnIqrn7C3y7WryxXryvyrWa
        vr4avFy2vF98ZaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvIb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6r1F6r1fM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxV
        AFwI0_Gr0_Gr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
        x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
        0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7I2V7IY0VAS
        07AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c
        02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_GFv_
        WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7
        CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6rWUJVWrZr1UMIIF0xvEx4A2jsIE
        14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf
        9x07UZ18PUUUUU=
X-CM-SenderInfo: xkhu0tnqos00pfhgvzhhrqqx5xdzvxpfor3voofrz/
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/20/2023 4:54 PM, Paul E. McKenney wrote:
> On Fri, Jan 20, 2023 at 06:58:20AM -0800, Arjan van de Ven wrote:
>> On 1/20/2023 5:55 AM, Hernan Ponce de Leon wrote:
>>> From: Hernan Ponce de Leon <hernanl.leon@huawei.com>
>>>
>>
>>>    kernel/locking/rtmutex.c | 2 +-
>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/kernel/locking/rtmutex.c b/kernel/locking/rtmutex.c
>>> index 010cf4e6d0b8..7ed9472edd48 100644
>>> --- a/kernel/locking/rtmutex.c
>>> +++ b/kernel/locking/rtmutex.c
>>> @@ -235,7 +235,7 @@ static __always_inline void mark_rt_mutex_waiters(struct rt_mutex_base *lock)
>>>    	unsigned long owner, *p = (unsigned long *) &lock->owner;
>>>    	do {
>>> -		owner = *p;
>>> +		owner = READ_ONCE(*p);
>>>    	} while (cmpxchg_relaxed(p, owner,
>>
>>
>> I don't see how this makes any difference at all.
>> *p can be read a dozen times and it's fine; cmpxchg has barrier semantics for compilers afaics
> 
> Doing so does suppress a KCSAN warning.  You could also use data_race()
> if it turns out that the volatile semantics would prevent a valuable
> compiler optimization.

I think the import question is "is this a harmful data race (and needs 
to be fixed as proposed by the patch) or a harmless one (and we should 
use data_race() to silence tools)?".

In https://lkml.org/lkml/2023/1/22/160 I describe how this data race can 
affect important ordering guarantees for the rest of the code. For this 
reason I consider it a harmful one. If this is not the case, I would 
appreciate some feedback or pointer to resources about what races care 
to avoid spamming the mailing list in the future.

Hernan

