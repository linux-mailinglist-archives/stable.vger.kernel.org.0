Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C76B8324C4A
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 09:57:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232137AbhBYI5C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 03:57:02 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:13002 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231721AbhBYI5B (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Feb 2021 03:57:01 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DmRS11HS5zjSGf;
        Thu, 25 Feb 2021 16:54:41 +0800 (CST)
Received: from [10.67.102.197] (10.67.102.197) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.498.0; Thu, 25 Feb 2021 16:56:11 +0800
Subject: Re: [PATCH] futex: fix dead code in attach_to_pi_owner()
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        <sashal@kernel.org>, <tglx@linutronix.de>, <lee.jones@linaro.org>,
        <wangle6@huawei.com>, <zhengyejian1@huawei.com>
References: <20210222125352.110124-1-nixiaoming@huawei.com>
 <YDdfASEcv7i/DxHF@kroah.com>
From:   Xiaoming Ni <nixiaoming@huawei.com>
Message-ID: <71a24b9b-2a65-57a1-55bb-95f7ec3287dd@huawei.com>
Date:   Thu, 25 Feb 2021 16:56:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.0.1
MIME-Version: 1.0
In-Reply-To: <YDdfASEcv7i/DxHF@kroah.com>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.197]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021/2/25 16:25, Greg KH wrote:
> On Mon, Feb 22, 2021 at 08:53:52PM +0800, Xiaoming Ni wrote:
>> From: Thomas Gleixner <tglx@linutronix.de>
>>
>> The handle_exit_race() function is defined in commit c158b461306df82
>>   ("futex: Cure exit race"), which never returns -EBUSY. This results
>> in a small piece of dead code in the attach_to_pi_owner() function:
>>
>> 	int ret = handle_exit_race(uaddr, uval, p); /* Never return -EBUSY */
>> 	...
>> 	if (ret == -EBUSY)
>> 		*exiting = p; /* dead code */
>>
>> The return value -EBUSY is added to handle_exit_race() in upsteam
>> commit ac31c7ff8624409 ("futex: Provide distinct return value when
>> owner is exiting"). This commit was incorporated into v4.9.255, before
>> the function handle_exit_race() was introduced, whitout Modify
>> handle_exit_race().
>>
>> To fix dead code, extract the change of handle_exit_race() from
>> commit ac31c7ff8624409 ("futex: Provide distinct return value when owner
>>   is exiting"), re-incorporated.
mainline:
ac31c7ff8624 futex: Provide distinct return value when owner is exiting

>>
>> Fixes: c158b461306df82 ("futex: Cure exit race")

stable linux-4.9.y
9c3f39860367 futex: Cure exit race
c27f392040e2 futex: Provide distinct return value when owner is exiting

>> Cc: stable@vger.kernel.org # 4.9.258-rc1
>> Signed-off-by: Xiaoming Ni <nixiaoming@huawei.com>
>> ---
>>   kernel/futex.c | 6 +++---
>>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> What is the git commit id of this patch in Linus's tree?
> 
> Also, what kernel tree(s) is this supposed to go to?
> 
> thanks,
> 
> greg k-h
> .
> 
Sorry, the commit id c158b461306df82 in the patch does not exist in the 
linux-stable repository.
The commit ID is from linux-stable-rc.

I corrected the commit id in a subsequent email, and added a branch 
label. 
https://lore.kernel.org/lkml/20210224100923.51315-1-nixiaoming@huawei.com/

Sorry, I forgot to use "--in-reply-to=" when I sent the update patch.

This issue occurs only in the linux-4.9.y branch v4.9.258

Thanks
xiaoming Ni




