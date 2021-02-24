Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D16A8323567
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 02:42:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231584AbhBXBl6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 20:41:58 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:12949 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231981AbhBXBl5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Feb 2021 20:41:57 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4Dldrp5sW5zjPZd;
        Wed, 24 Feb 2021 09:39:54 +0800 (CST)
Received: from [10.67.102.197] (10.67.102.197) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.498.0; Wed, 24 Feb 2021 09:41:01 +0800
Subject: Re: [PATCH stable-rc queue/4.9 1/1] futex: Provide distinct return
 value when owner is exiting
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        <sashal@kernel.org>, <tglx@linutronix.de>, <wangle6@huawei.com>,
        <zhengyejian1@huawei.com>
References: <20210222070328.102384-1-nixiaoming@huawei.com>
 <20210222070328.102384-2-nixiaoming@huawei.com> <YDOEZhmKqjTVxtMn@kroah.com>
 <3bc570f6-f8af-b0a2-4d62-13ed4adc1f33@huawei.com>
 <YDOe9GNivoHQphQc@kroah.com>
 <76f6a446-41db-3b7a-dcab-a85d0841654f@huawei.com>
 <YDT8ZsMqVqihECoE@kroah.com>
From:   Xiaoming Ni <nixiaoming@huawei.com>
Message-ID: <2e8cf845-30ee-22c2-428a-b56e03cb49e4@huawei.com>
Date:   Wed, 24 Feb 2021 09:41:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.0.1
MIME-Version: 1.0
In-Reply-To: <YDT8ZsMqVqihECoE@kroah.com>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.197]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021/2/23 21:00, Greg KH wrote:
> On Mon, Feb 22, 2021 at 10:11:37PM +0800, Xiaoming Ni wrote:
>> On 2021/2/22 20:09, Greg KH wrote:
>>> On Mon, Feb 22, 2021 at 06:54:06PM +0800, Xiaoming Ni wrote:
>>>> On 2021/2/22 18:16, Greg KH wrote:
>>>>> On Mon, Feb 22, 2021 at 03:03:28PM +0800, Xiaoming Ni wrote:
>>>>>> From: Thomas Gleixner<tglx@linutronix.de>
>>>>>>
>>>>>> commit ac31c7ff8624409ba3c4901df9237a616c187a5d upstream.
>>>>> This commit is already in the 4.9 tree.  If the backport was incorrect,
>>>>> say that here, and describe what went wrong and why this commit fixes
>>>>> it.
>>>>>
>>>>> Also state what commit this fixes as well, otherwise this changelog just
>>>>> looks like it is being applied again to the tree, which doesn't make
>>>>> much sense.
>>>>>
>>>>> thanks,
>>>>>
>>>>> greg k-h
>>>>> .
>>>>
>>>> I wrote a cover for it. but forgot to adjust the title of the cover:
>>>>
>>>> https://lore.kernel.org/lkml/20210222070328.102384-1-nixiaoming@huawei.com/
>>>>
>>>>
>>>> I found a dead code in the queue/4.9 branch of the stable-rc repository.
>>>>
>>>> 2021-02-03:
>>>> commit c27f392040e2f6 ("futex: Provide distinct return value when
>>>>    owner is exiting")
>>>> 	The function handle_exit_race does not exist. Therefore, the
>>>> 	change in handle_exit_race() is ignored in the patch round.
>>>>
>>>> 2021-02-22:
>>>> commit e55cb811e612 ("futex: Cure exit race")
>>>> 	Define the handle_exit_race() function,
>>>> 	but no branch in the function returns EBUSY.
>>>> 	As a result, dead code occurs in the attach_to_pi_owner():
>>>>
>>>> 		int ret = handle_exit_race(uaddr, uval, p);
>>>> 		...
>>>> 		if (ret == -EBUSY)
>>>> 			*exiting = p; /* dead code */
>>>>
>>>> To fix the dead code, modify the commit e55cb811e612 ("futex: Cure exit
>>>> race"),
>>>> or install a patch to incorporate the changes in handle_exit_race().
>>>>
>>>> I am unfamiliar with the processing of the stable-rc queue branch,
>>>> and I cannot find the patch mail of the current branch in
>>>> 	https://lore.kernel.org/lkml/?q=%22futex%3A+Cure+exit+race%22
>>>> Therefore, I re-integrated commit ac31c7ff8624 ("futex: Provide distinct
>>>>    return value when owner is exiting").
>>>>    And wrote a cover (but forgot to adjust the title of the cover):
>>>>
>>>> https://lore.kernel.org/lkml/20210222070328.102384-1-nixiaoming@huawei.com/
>>>
>>> So this is a "fixup" patch, right?
>>>
>>> Please clearly label it as such in your patch description and resend
>>> this as what is here I can not apply at all.
>>>
>>> thanks,
>>>
>>> greg k-h
>>> .
>>>
>> Thank you for your guidance.
>> I have updated the patch description and resent the patch based on
>> v4.9.258-rc1
>> https://lore.kernel.org/lkml/20210222125352.110124-1-nixiaoming@huawei.com/
> 
> Can you please try 4.9.258 and let me know if this is still needed or
> not?
> 
> thanks,
> 
> greg k-h
> .
> 
The dead code problem still exists in V4.9.258. No conflict occurs 
during my patch integration. Do I need to correct the version number 
marked in the cc table in the patch and resend the patch?

Thanks
Xiaoming Ni
