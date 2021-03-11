Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2C023369D2
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 02:40:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229441AbhCKBj6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 20:39:58 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:12706 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbhCKBja (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Mar 2021 20:39:30 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Dws4l3vzQzmVqv;
        Thu, 11 Mar 2021 09:37:11 +0800 (CST)
Received: from [10.67.110.218] (10.67.110.218) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.498.0; Thu, 11 Mar 2021 09:39:19 +0800
Subject: Re: [PATCH 4.4 3/3] futex: fix dead code in attach_to_pi_owner()
To:     Greg KH <gregkh@linuxfoundation.org>,
        Lee Jones <lee.jones@linaro.org>, <stable@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <cj.chengjian@huawei.com>, <judy.chenhui@huawei.com>,
        <zhangjinhao2@huawei.com>, <nixiaoming@huawei.com>
References: <20210309030605.3295183-1-zhengyejian1@huawei.com>
 <20210309030605.3295183-4-zhengyejian1@huawei.com>
 <YEdQoy6j7eOne+8h@kroah.com> <20210309181437.GV4931@dell>
 <YEi08Dr3cgNp0KlP@kroah.com> <20210310132802.GP701493@dell>
 <YEjTUwOnAfoKyCpV@kroah.com>
From:   "Zhengyejian (Zetta)" <zhengyejian1@huawei.com>
Message-ID: <16dd7cbc-8f4e-7a85-02df-9a9fb2593b58@huawei.com>
Date:   Thu, 11 Mar 2021 09:39:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YEjTUwOnAfoKyCpV@kroah.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.110.218]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2021/3/10 22:10, Greg KH wrote:
> On Wed, Mar 10, 2021 at 01:28:02PM +0000, Lee Jones wrote:
>> On Wed, 10 Mar 2021, Greg KH wrote:
>>
>>> On Tue, Mar 09, 2021 at 06:14:37PM +0000, Lee Jones wrote:
>>>> On Tue, 09 Mar 2021, Greg KH wrote:
>>>>
>>>>> On Tue, Mar 09, 2021 at 11:06:05AM +0800, Zheng Yejian wrote:
>>>>>> From: Thomas Gleixner <tglx@linutronix.de>
>>>>>>
>>>>>> The handle_exit_race() function is defined in commit 9c3f39860367
>>>>>>   ("futex: Cure exit race"), which never returns -EBUSY. This results
>>>>>> in a small piece of dead code in the attach_to_pi_owner() function:
>>>>>>
>>>>>> 	int ret = handle_exit_race(uaddr, uval, p); /* Never return -EBUSY */
>>>>>> 	...
>>>>>> 	if (ret == -EBUSY)
>>>>>> 		*exiting = p; /* dead code */
>>>>>>
>>>>>> The return value -EBUSY is added to handle_exit_race() in upsteam
>>>>>> commit ac31c7ff8624409 ("futex: Provide distinct return value when
>>>>>> owner is exiting"). This commit was incorporated into v4.9.255, before
>>>>>> the function handle_exit_race() was introduced, whitout Modify
>>>>>> handle_exit_race().
>>>>>>
>>>>>> To fix dead code, extract the change of handle_exit_race() from
>>>>>> commit ac31c7ff8624409 ("futex: Provide distinct return value when owner
>>>>>>   is exiting"), re-incorporated.
>>>>>>
>>>>>> Lee writes:
>>>>>>
>>>>>> This commit takes the remaining functional snippet of:
>>>>>>
>>>>>>   ac31c7ff8624409 ("futex: Provide distinct return value when owner is exiting")
>>>>>>
>>>>>> ... and is the correct fix for this issue.
>>>>>>
>>>>>> Fixes: 9c3f39860367 ("futex: Cure exit race")
>>>>>> Cc: stable@vger.kernel.org # v4.9.258
>>>>>> Signed-off-by: Xiaoming Ni <nixiaoming@huawei.com>
>>>>>> Reviewed-by: Lee Jones <lee.jones@linaro.org>
>>>>>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>>>>> Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>
>>>>>> ---
>>>>>>   kernel/futex.c | 6 +++---
>>>>>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>>>>
>>>>> Same here, what is the upstream git id?
>>>>
>>>> It doesn't have one as such - it's a part-patch:
>>>>
>>>>>> This commit takes the remaining functional snippet of:
>>>>>>
>>>>>>   ac31c7ff8624409 ("futex: Provide distinct return value when owner is exiting")
>>>
>>> That wasn't obvious :(
>>
>> This was also my thinking, which is why I replied to the original
>> patch in an attempt to clarify what I thought was happening.
>>
>>> Is this a backport of another patch in the stable tree somewhere?
>>
>> Yes, it looks like it.
>>
>> The full patch was back-ported to v4.14 as:
>>
>>    e6e00df182908f34360c3c9f2d13cc719362e9c0
> 
> Ok, Zheng, can you put this information in the patch and resend the
> whole series?
> 

Sure, I'll send a "v2" patchset soon.
Thanks for your suggestions,

Zheng Yejian
