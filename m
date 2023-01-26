Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2B5D67C7A5
	for <lists+stable@lfdr.de>; Thu, 26 Jan 2023 10:42:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236353AbjAZJmr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Jan 2023 04:42:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234781AbjAZJmq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Jan 2023 04:42:46 -0500
Received: from frasgout13.his.huawei.com (frasgout13.his.huawei.com [14.137.139.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1D02552A8;
        Thu, 26 Jan 2023 01:42:44 -0800 (PST)
Received: from mail02.huawei.com (unknown [172.18.147.227])
        by frasgout13.his.huawei.com (SkyGuard) with ESMTP id 4P2bC609Drz9v7Qm;
        Thu, 26 Jan 2023 17:34:42 +0800 (CST)
Received: from [10.221.98.77] (unknown [10.221.98.77])
        by APP2 (Coremail) with SMTP id GxC2BwCXamHxStJjAvDIAA--.168S2;
        Thu, 26 Jan 2023 10:42:20 +0100 (CET)
Message-ID: <c300747a-cf81-0e2d-77ec-f861421291f9@huaweicloud.com>
Date:   Thu, 26 Jan 2023 10:42:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.0
Subject: Re: [PATCH] Fix data race in mark_rt_mutex_waiters
Content-Language: en-US
To:     Waiman Long <longman@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     paulmck@kernel.org, Arjan van de Ven <arjan@linux.intel.com>,
        mingo@redhat.com, will@kernel.org, boqun.feng@gmail.com,
        akpm@osdl.org, tglx@linutronix.de, joel@joelfernandes.org,
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
From:   Hernan Ponce de Leon <hernan.poncedeleon@huaweicloud.com>
In-Reply-To: <ae90e931-df19-9d60-610c-57dc34494d8e@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: GxC2BwCXamHxStJjAvDIAA--.168S2
X-Coremail-Antispam: 1UD129KBjvdXoW7Gry3KrWfJF13AF4UAFyxXwb_yoWfXFc_uF
        nFkwn7GrsIkr15ZwnrXr4UKFWDWa97tryUW34UXa4Ika4DKrZ8XFWxGFyIvanxG3yIyFsx
        W3W2qFyIvw1a9jkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUb3kFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6r1S6rWUM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_
        Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gr0_Gr
        1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
        jxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr
        1lF7xvr2IY64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY
        04v7Mxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7
        v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF
        1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIx
        AIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWrZr1j6s0D
        MIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIda
        VFxhVjvjDU0xZFpf9x0JUQvtAUUUUU=
X-CM-SenderInfo: xkhu0tnqos00pfhgvzhhrqqx5xdzvxpfor3voofrz/
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/24/2023 5:04 PM, Waiman Long wrote:
> 
> On 1/24/23 10:52, Peter Zijlstra wrote:
>> On Tue, Jan 24, 2023 at 10:42:24AM -0500, Waiman Long wrote:
>>
>>> I would suggest to do it as suggested by PeterZ. Instead of set_bit(),
>>> however, it is probably better to use atomic_long_or() like
>>>
>>> atomic_long_or_relaxed(RT_MUTEX_HAS_WAITERS, (atomic_long_t 
>>> *)&lock->owner)
>> That function doesn't exist, atomic_long_or() is implicitly relaxed for
>> not returning a value.
>>
> You are right. atomic_long_or() doesn't have variants like some others.
> 
> Cheers,
> Longman
> 

When you say "replace the whole of that function", do you mean "barrier 
included"? I argue in the other email that I think this should not 
affect correctness (at least not obviously), but removing the barrier is 
doing more than just fixing the data race as this patch suggests.

Hernan

