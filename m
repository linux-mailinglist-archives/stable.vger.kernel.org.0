Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 959FD336AE9
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 04:49:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbhCKDtD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 22:49:03 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:13500 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230052AbhCKDtA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Mar 2021 22:49:00 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Dwvyk52MpzrTlR;
        Thu, 11 Mar 2021 11:47:10 +0800 (CST)
Received: from [10.67.110.218] (10.67.110.218) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.498.0; Thu, 11 Mar 2021 11:48:52 +0800
Subject: Re: [PATCH 4.4 0/3] Backport patch series to update Futex from 4.9
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     <lee.jones@linaro.org>, <stable@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <cj.chengjian@huawei.com>, <judy.chenhui@huawei.com>,
        <zhangjinhao2@huawei.com>, <nixiaoming@huawei.com>
References: <20210309030605.3295183-1-zhengyejian1@huawei.com>
 <YEdQz4AxVRoabTW4@kroah.com>
From:   "Zhengyejian (Zetta)" <zhengyejian1@huawei.com>
Message-ID: <d44ebf43-1fe8-6588-b84f-dcfea9eca0a4@huawei.com>
Date:   Thu, 11 Mar 2021 11:48:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YEdQz4AxVRoabTW4@kroah.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.110.218]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2021/3/9 18:41, Greg KH wrote:
> On Tue, Mar 09, 2021 at 11:06:02AM +0800, Zheng Yejian wrote:
>> Lee sent a patchset to update Futex for 4.9, see https://www.spinics.net/lists/stable/msg443081.html,
>> Then Xiaoming sent a follow-up patch for it, see https://lore.kernel.org/lkml/20210225093120.GD641347@dell/.
>>
>> These patchsets may also resolve following issues in 4.4.260 which have been reported in 4.9,
>> see https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/?h=linux-4.4.y&id=319f66f08de1083c1fe271261665c209009dd65a
>>        > /*
>>        >  * The task is on the way out. When the futex state is
>>        >  * FUTEX_STATE_DEAD, we know that the task has finished
>>        >  * the cleanup:
>>        >  */
>>        > int ret = (p->futex_state = FUTEX_STATE_DEAD) ? -ESRCH : -EAGAIN;
>>
>>      Here may be:
>>        int ret = (p->futex_state == FUTEX_STATE_DEAD) ? -ESRCH : -EAGAIN;
>>
>>        > raw_spin_unlock_irq(&p->pi_lock);
>>        > /*
>>        >  * If the owner task is between FUTEX_STATE_EXITING and
>>        >  * FUTEX_STATE_DEAD then store the task pointer and keep
>>        >  * the reference on the task struct. The calling code will
>>        >  * drop all locks, wait for the task to reach
>>        >  * FUTEX_STATE_DEAD and then drop the refcount. This is
>>        >  * required to prevent a live lock when the current task
>>        >  * preempted the exiting task between the two states.
>>        >  */
>>        > if (ret == -EBUSY)
>>
>>      And here, the variable "ret" may only be "-ESRCH" or "-EAGAIN", but not "-EBUSY".
>>
>>        > 	*exiting = p;
>>        > else
>>        > 	put_task_struct(p);
>>
>> Since 074e7d515783 ("futex: Ensure the correct return value from futex_lock_pi()") has
>> been merged in 4.4.260, I send the remain 3 patches.
> 
> There already are 2 futex patches in the 4.4.y stable queue, do those
> not resolve these issues for you?

I think that 2 futex patches in 4.4 stable queue are fixing other issues:
     futex-fix-irq-self-deadlock-and-satisfy-assertion.patch
     futex-fix-spin_lock-spin_unlock_irq-imbalance.patch
But I am not very sure if there are any lock conflicts between that 2 
patches and this 3 patches.

> 
> If not, please resend this series with the needed git commit ids added to
> them.

I have add that information and sent a "v2" patchset.
