Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB8452D1FED
	for <lists+stable@lfdr.de>; Tue,  8 Dec 2020 02:24:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbgLHBXw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Dec 2020 20:23:52 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:9126 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725972AbgLHBXw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Dec 2020 20:23:52 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Cqj8s4LCmz15Xkq;
        Tue,  8 Dec 2020 09:22:37 +0800 (CST)
Received: from [10.67.102.197] (10.67.102.197) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.487.0; Tue, 8 Dec 2020 09:23:00 +0800
Subject: Re: ping // [PATCH] mtd:cfi_cmdset_0002: fix atomic sleep bug when
 CONFIG_MTD_XIP=y
To:     Vignesh Raghavendra <vigneshr@ti.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
CC:     <richard@nod.at>, <tudor.ambarus@microchip.com>,
        <tglx@linutronix.de>, <linux-mtd@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <wangle6@huawei.com>
References: <20201127130731.99270-1-nixiaoming@huawei.com>
 <a02e1364-3b82-039a-4b65-e2a216663dd4@huawei.com>
 <20201207115228.0a6de398@xps13> <73b539eb-616e-64d8-07d8-4606da2ea2ea@ti.com>
From:   Xiaoming Ni <nixiaoming@huawei.com>
Message-ID: <b5c52547-b3cc-4217-cc69-067cee7d536f@huawei.com>
Date:   Tue, 8 Dec 2020 09:23:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.0.1
MIME-Version: 1.0
In-Reply-To: <73b539eb-616e-64d8-07d8-4606da2ea2ea@ti.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.197]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020/12/8 2:59, Vignesh Raghavendra wrote:
> Hi Xiaoming,
> 
> On 12/7/20 4:23 PM, Miquel Raynal wrote:
>> Hi Xiaoming,
>>
>> Xiaoming Ni <nixiaoming@huawei.com> wrote on Mon, 7 Dec 2020 18:48:33
>> +0800:
>>
>>> ping
>>>
>>> On 2020/11/27 21:07, Xiaoming Ni wrote:
>>>> When CONFIG_MTD_XIP=y, local_irq_disable() is called in xip_disable().
>>>> To avoid sleep in interrupt context, we need to call local_irq_enable()
>>>> before schedule().
>>>>
>>>> The problem call stack is as follows:
>>>> bug1:
>>>> 	do_write_oneword_retry()
>>>> 		xip_disable()
>>>> 			local_irq_disable()
>>>> 		do_write_oneword_once()
>>>> 			schedule()
>>>> bug2:
>>>> 	do_write_buffer()
>>>> 		xip_disable()
>>>> 			local_irq_disable()
>>>> 		do_write_buffer_wait()
>>>> 			schedule()
>>>> bug3:
>>>> 	do_erase_chip()
>>>> 		xip_disable()
>>>> 			local_irq_disable()
>>>> 		schedule()
>>>> bug4:
>>>> 	do_erase_oneblock()
>>>> 		xip_disable()
>>>> 			local_irq_disable()
>>>> 		schedule()
>>>>
>>>> Fixes: 02b15e343aee ("[MTD] XIP for AMD CFI flash.")
>>>> Cc: stable@vger.kernel.org # v2.6.13
>>>> Signed-off-by: Xiaoming Ni <nixiaoming@huawei.com>
>>>> ---
>>>>    drivers/mtd/chips/cfi_cmdset_0002.c | 16 ++++++++++++++++
>>>>    1 file changed, 16 insertions(+)
>>>>
>>>> diff --git a/drivers/mtd/chips/cfi_cmdset_0002.c b/drivers/mtd/chips/cfi_cmdset_0002.c
>>>> index a1f3e1031c3d..12c3776f093a 100644
>>>> --- a/drivers/mtd/chips/cfi_cmdset_0002.c
>>>> +++ b/drivers/mtd/chips/cfi_cmdset_0002.c
>>>> @@ -1682,7 +1682,11 @@ static int __xipram do_write_oneword_once(struct map_info *map,
>>>>    			set_current_state(TASK_UNINTERRUPTIBLE);
>>>>    			add_wait_queue(&chip->wq, &wait);
>>>>    			mutex_unlock(&chip->mutex);
>>>> +			if (IS_ENABLED(CONFIG_MTD_XIP))
>>>> +				local_irq_enable();
>>>>    			schedule();
>>>> +			if (IS_ENABLED(CONFIG_MTD_XIP))
>>>> +				local_irq_disable();
>>
>> The fix really seems strange to me. I will let Vignesh decide but I
>> think we should consider updating/fixing xip_disable instead.
> 
> Agree with Miquel. Have you done any testing
> or is this purely based on code inspection?
> 
I don't have the corresponding device test environment.
I found the problem through code review.


> What about comment before xip_disable() function:
> 
> /*
>   * No interrupt what so ever can be serviced while the flash isn't in array
>   * mode.  This is ensured by the xip_disable() and xip_enable() functions
>   * enclosing any code path where the flash is known not to be in array mode.
>   * And within a XIP disabled code path, only functions marked with __xipram
>   * may be called and nothing else (it's a good thing to inspect generated
>   * assembly to make sure inline functions were actually inlined and that gcc
>   * didn't emit calls to its own support functions). Also configuring MTD CFI
>   * support to a single buswidth and a single interleave is also recommended.
>   */
> 
> So, I don't think the fix is as simple as this patch.
>
+xip_enable();
  schedule();
+xip_disable();

Do I need to change it to this?



> Regards
> Vignesh
> .
> 

Thanks
Xiaoming Ni

