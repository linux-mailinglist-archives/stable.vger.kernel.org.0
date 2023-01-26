Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA1667D74E
	for <lists+stable@lfdr.de>; Thu, 26 Jan 2023 22:07:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232561AbjAZVHz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Jan 2023 16:07:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232710AbjAZVHx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Jan 2023 16:07:53 -0500
Received: from frasgout12.his.huawei.com (frasgout12.his.huawei.com [14.137.139.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EBA740C5;
        Thu, 26 Jan 2023 13:07:50 -0800 (PST)
Received: from mail02.huawei.com (unknown [172.18.147.227])
        by frasgout12.his.huawei.com (SkyGuard) with ESMTP id 4P2tPT0Sg9z9v7bg;
        Fri, 27 Jan 2023 04:59:41 +0800 (CST)
Received: from [10.81.221.86] (unknown [10.81.221.86])
        by APP2 (Coremail) with SMTP id GxC2BwAX6F6E69Jjh_fKAA--.18178S2;
        Thu, 26 Jan 2023 22:07:27 +0100 (CET)
Message-ID: <9da70674-42e0-9aaa-edab-c606ca8dd2e8@huaweicloud.com>
Date:   Thu, 26 Jan 2023 22:07:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.0
From:   Hernan Ponce de Leon <hernan.poncedeleon@huaweicloud.com>
Subject: Re: [PATCH] Fix data race in mark_rt_mutex_waiters
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Waiman Long <longman@redhat.com>, paulmck@kernel.org,
        Arjan van de Ven <arjan@linux.intel.com>, mingo@redhat.com,
        will@kernel.org, boqun.feng@gmail.com, akpm@osdl.org,
        tglx@linutronix.de, joel@joelfernandes.org,
        stern@rowland.harvard.edu, diogo.behrens@huawei.com,
        jonas.oberhauser@huawei.com, linux-kernel@vger.kernel.org,
        Hernan Ponce de Leon <hernanl.leon@huawei.com>,
        stable@vger.kernel.org,
        Jonas Oberhauser <jonas.oberhauser@huaweicloud.com>
References: <20230120135525.25561-1-hernan.poncedeleon@huaweicloud.com>
 <562c883b-b2c3-3a27-f045-97e7e3281e0b@linux.intel.com>
 <20230120155439.GI2948950@paulmck-ThinkPad-P17-Gen-1>
 <9a1c7959-4b8c-94df-a3e2-e69be72bfd7d@huaweicloud.com>
 <20230123164014.GN2948950@paulmck-ThinkPad-P17-Gen-1>
 <f17dcce0-d510-a112-3127-984e8e73f480@huaweicloud.com>
 <d1e28124-b7a7-ae19-87ec-b1dcd3701b61@redhat.com>
 <Y8/+2YBRD4rFySjh@hirez.programming.kicks-ass.net>
 <ae90e931-df19-9d60-610c-57dc34494d8e@redhat.com>
 <c300747a-cf81-0e2d-77ec-f861421291f9@huaweicloud.com>
 <Y9Jv9yL8x7/TAq/X@hirez.programming.kicks-ass.net>
Content-Language: en-US
In-Reply-To: <Y9Jv9yL8x7/TAq/X@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: GxC2BwAX6F6E69Jjh_fKAA--.18178S2
X-Coremail-Antispam: 1UD129KBjvJXoWxZF1fuFWUJw15CF47Zr1UKFg_yoWrJr15pF
        W7Kay7JF4DtF10qryqkF4xZ3y0y3s3KF4UXw1xKryxC3Z8tr4FgrZrCFW2k34kXrZ5AF4a
        qr4DZa43uF98ZaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUU9214x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWUuVWrJwAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26r1j6r1xM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
        6F4UM28EF7xvwVC2z280aVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVCY1x0267AKxVW8Jr
        0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
        6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr
        0_Gr1lF7xvr2IY64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxa
        n2IY04v7Mxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x
        0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2
        zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF
        4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWrZr1j
        6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYx
        BIdaVFxhVjvjDU0xZFpf9x0JUQvtAUUUUU=
X-CM-SenderInfo: xkhu0tnqos00pfhgvzhhrqqx5xdzvxpfor3voofrz/
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/26/2023 1:20 PM, Peter Zijlstra wrote:
> On Thu, Jan 26, 2023 at 10:42:07AM +0100, Hernan Ponce de Leon wrote:
>> On 1/24/2023 5:04 PM, Waiman Long wrote:
>>>
>>> On 1/24/23 10:52, Peter Zijlstra wrote:
>>>> On Tue, Jan 24, 2023 at 10:42:24AM -0500, Waiman Long wrote:
>>>>
>>>>> I would suggest to do it as suggested by PeterZ. Instead of set_bit(),
>>>>> however, it is probably better to use atomic_long_or() like
>>>>>
>>>>> atomic_long_or_relaxed(RT_MUTEX_HAS_WAITERS, (atomic_long_t
>>>>> *)&lock->owner)
>>>> That function doesn't exist, atomic_long_or() is implicitly relaxed for
>>>> not returning a value.
>>>>
>>> You are right. atomic_long_or() doesn't have variants like some others.
>>>
>>> Cheers,
>>> Longman
>>>
>>
>> When you say "replace the whole of that function", do you mean "barrier
>> included"? I argue in the other email that I think this should not affect
>> correctness (at least not obviously), but removing the barrier is doing more
>> than just fixing the data race as this patch suggests.
> 
> Well, set_bit() implies smp_mb(), atomic_long_or() does not and would
> need to retain the barrier.
> 
> That said, the comments are all batshit. The top comment states relaxed
> ordering is suffient since holding lock, the comment with the barrier
> utterly fails to explain what it's ordering against.

I think the top comment became obsolete after 1c0908d8e441 and this just 
went unnoticed. I agree the comment with the barrier does not say much 
and getting some more detailed information was one of the goals of my 
other email.

> 
> So all that would need to be updated as well.
> 
> That said, looking at 1c0908d8e441 I'm not at all sure we need that
> barrier. Even in the try_to_take_rt_mutex(.waiter=NULL) case, where we
> skip over the task->pi_lock region, rt_mutex_set_owner(.acquire=true)
> will be ACQUIRE.

This sentence states in a clear way the idea I was trying to express in 
my other email about why the barrier is not necessary. I think the same 
argument holds if we keep the barrier and relax the store in 
rt_mutex_set_owner as suggested by Boqun (see patch below).

> 
> And in case of rt_mutex_owner(), we fail the trylock (return with 0) and
> a failed trylock does not imply any ordering.
> 
> So why are we having this barrier?

I run again the verification with the following patch (I am aware the 
comments still need to be updated, this was just to be able to run the 
tool) and the tool still finds no violation.

diff --git a/kernel/locking/rtmutex.c b/kernel/locking/rtmutex.c
index 010cf4e6d0b8..c62e409906a2 100644
--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -107,7 +107,7 @@ rt_mutex_set_owner(struct rt_mutex_base *lock, 
struct task_struct *owner)
  	 * lock->wait_lock is held but explicit acquire semantics are needed
  	 * for a new lock owner so WRITE_ONCE is insufficient.
  	 */
-	xchg_acquire(&lock->owner, rt_mutex_owner_encode(lock, owner));
+	WRITE_ONCE(lock->owner, rt_mutex_owner_encode(lock, owner));
  }

  static __always_inline void rt_mutex_clear_owner(struct rt_mutex_base 
*lock)
@@ -232,12 +232,7 @@ static __always_inline bool 
rt_mutex_cmpxchg_release(struct rt_mutex_base *lock,
   */
  static __always_inline void mark_rt_mutex_waiters(struct rt_mutex_base 
*lock)
  {
-	unsigned long owner, *p = (unsigned long *) &lock->owner;
-
-	do {
-		owner = *p;
-	} while (cmpxchg_relaxed(p, owner,
-				 owner | RT_MUTEX_HAS_WAITERS) != owner);
+	atomic_long_or(RT_MUTEX_HAS_WAITERS, (atomic_long_t *)&lock->owner);

  	/*
  	 * The cmpxchg loop above is relaxed to avoid back-to-back ACQUIRE
-- 

