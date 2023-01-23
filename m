Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73E726787A2
	for <lists+stable@lfdr.de>; Mon, 23 Jan 2023 21:22:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231739AbjAWUW0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 15:22:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232178AbjAWUWW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 15:22:22 -0500
X-Greylist: delayed 1114 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 23 Jan 2023 12:22:14 PST
Received: from frasgout11.his.huawei.com (frasgout11.his.huawei.com [14.137.139.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D2C934C22;
        Mon, 23 Jan 2023 12:22:14 -0800 (PST)
Received: from mail02.huawei.com (unknown [172.18.147.227])
        by frasgout11.his.huawei.com (SkyGuard) with ESMTP id 4P116N6Knjz9v7Nc;
        Tue, 24 Jan 2023 03:55:08 +0800 (CST)
Received: from [10.81.216.232] (unknown [10.81.216.232])
        by APP1 (Coremail) with SMTP id LxC2BwC3PAja585jhpa_AA--.11827S2;
        Mon, 23 Jan 2023 21:02:46 +0100 (CET)
Message-ID: <c1a03870-43dd-5837-0a09-1ba3a996ec59@huaweicloud.com>
Date:   Mon, 23 Jan 2023 21:02:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH] Fix data race in mark_rt_mutex_waiters
To:     Alan Stern <stern@rowland.harvard.edu>,
        "Paul E. McKenney" <paulmck@kernel.org>
Cc:     Hernan Ponce de Leon <hernan.poncedeleon@huaweicloud.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        peterz@infradead.org, mingo@redhat.com, will@kernel.org,
        longman@redhat.com, boqun.feng@gmail.com, akpm@osdl.org,
        tglx@linutronix.de, joel@joelfernandes.org,
        diogo.behrens@huawei.com, jonas.oberhauser@huawei.com,
        linux-kernel@vger.kernel.org,
        Hernan Ponce de Leon <hernanl.leon@huawei.com>,
        stable@vger.kernel.org
References: <20230120135525.25561-1-hernan.poncedeleon@huaweicloud.com>
 <562c883b-b2c3-3a27-f045-97e7e3281e0b@linux.intel.com>
 <20230120155439.GI2948950@paulmck-ThinkPad-P17-Gen-1>
 <9a1c7959-4b8c-94df-a3e2-e69be72bfd7d@huaweicloud.com>
 <20230123164014.GN2948950@paulmck-ThinkPad-P17-Gen-1>
 <Y87FLV0dWSyQz3NZ@rowland.harvard.edu>
From:   Jonas Oberhauser <jonas.oberhauser@huaweicloud.com>
In-Reply-To: <Y87FLV0dWSyQz3NZ@rowland.harvard.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: LxC2BwC3PAja585jhpa_AA--.11827S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Ww43Zw18ZrW8JrWxKrW5GFg_yoW8Gw45pr
        Z8KayDAr97Xrn2yrySyr4xX3s0vrW0qasxtr1vkryIkwsxZrySkrWakr1rXFyrAwsay3Wj
        v3W0g347CFn8XaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUU9I14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26r1j6r1xM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
        6F4UM28EF7xvwVC2z280aVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv6xkF7I0E14v26r4UJV
        WxJr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
        0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7x
        kEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E
        67AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCw
        CI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6rWUJVWr
        Zr1UMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJb
        IYCTnIWIevJa73UjIFyTuYvjfUeApeUUUUU
X-CM-SenderInfo: 5mrqt2oorev25kdx2v3u6k3tpzhluzxrxghudrp/
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 1/23/2023 6:34 PM, Alan Stern wrote:
> On Mon, Jan 23, 2023 at 08:40:14AM -0800, Paul E. McKenney wrote:
>> In the case, the value read is passed into cmpxchg_relaxed(), which
>> checks the value against memory.  In this case, as Arjan noted, the only
>> compiler-and-silicon difference between data_race() and READ_ONCE()
>> is that use of data_race() might allow the compiler to do things like
>> tear the load, thus forcing the occasional spurious cmpxchg_relaxed()
>> failure.
> Is it possible in theory for a torn load to cause a spurious
> cmpxchg_relaxed() success?  Or would that not matter here?

Note that in this example there are no memory accesses between the read 
and the CAS.
So if the cmpxchg succeeds, what you non-atomically read must be exactly 
the value that is read by the cmpxchg, and you could pretend that the 
torn read happened at the same time as the cmpxchg.

This "pretend" part requires that there are no other events in the 
middle, otherwise you could be violating some ordering constraint 
between those events and the torn reads. Otherwise you might get some 
issues. E.g., you might read a sequence count of 259 from reading the 
lower half when the count is 3 and the upper half when the count is 256, 
and then do the CAS when the sequence count is 259, so if you had two 
peeks at sequence-count-protected data between that read and the CAS you 
might see different states despite the CAS succeeding.

have fun, jonas

