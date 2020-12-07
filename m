Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00D022D18E7
	for <lists+stable@lfdr.de>; Mon,  7 Dec 2020 20:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725774AbgLGTAy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Dec 2020 14:00:54 -0500
Received: from fllv0015.ext.ti.com ([198.47.19.141]:34212 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725915AbgLGTAx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Dec 2020 14:00:53 -0500
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0B7IxPUC093171;
        Mon, 7 Dec 2020 12:59:25 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1607367565;
        bh=l8AmyJmC8gTSyUoOze7WxgteJNUwxEVxb9g16VApPdw=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=uf3lKJX3Y7M0KMBKT9zU1izumbaHH2Db6t1lq3zwqAvdV1wzNSPmjQncDfG0tN/xr
         Q+DwVpd/lP6v/7hRySH3XNULenJWlKsfSEtOyNI0KFP3/jAjJuS6X4LEJ1yhH6X66n
         cqVT78yK+TdsyXpenbRQ6kEU3VJ4ziMXKN7Ddgks=
Received: from DLEE102.ent.ti.com (dlee102.ent.ti.com [157.170.170.32])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 0B7IxPMB031013
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 7 Dec 2020 12:59:25 -0600
Received: from DLEE103.ent.ti.com (157.170.170.33) by DLEE102.ent.ti.com
 (157.170.170.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Mon, 7 Dec
 2020 12:59:25 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE103.ent.ti.com
 (157.170.170.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Mon, 7 Dec 2020 12:59:24 -0600
Received: from [10.250.233.179] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0B7IxLb3066531;
        Mon, 7 Dec 2020 12:59:22 -0600
Subject: Re: ping // [PATCH] mtd:cfi_cmdset_0002: fix atomic sleep bug when
 CONFIG_MTD_XIP=y
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Xiaoming Ni <nixiaoming@huawei.com>
CC:     <richard@nod.at>, <tudor.ambarus@microchip.com>,
        <tglx@linutronix.de>, <linux-mtd@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <wangle6@huawei.com>
References: <20201127130731.99270-1-nixiaoming@huawei.com>
 <a02e1364-3b82-039a-4b65-e2a216663dd4@huawei.com>
 <20201207115228.0a6de398@xps13>
From:   Vignesh Raghavendra <vigneshr@ti.com>
Message-ID: <73b539eb-616e-64d8-07d8-4606da2ea2ea@ti.com>
Date:   Tue, 8 Dec 2020 00:29:21 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201207115228.0a6de398@xps13>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Xiaoming,

On 12/7/20 4:23 PM, Miquel Raynal wrote:
> Hi Xiaoming,
> 
> Xiaoming Ni <nixiaoming@huawei.com> wrote on Mon, 7 Dec 2020 18:48:33
> +0800:
> 
>> ping
>>
>> On 2020/11/27 21:07, Xiaoming Ni wrote:
>>> When CONFIG_MTD_XIP=y, local_irq_disable() is called in xip_disable().
>>> To avoid sleep in interrupt context, we need to call local_irq_enable()
>>> before schedule().
>>>
>>> The problem call stack is as follows:
>>> bug1:
>>> 	do_write_oneword_retry()
>>> 		xip_disable()
>>> 			local_irq_disable()
>>> 		do_write_oneword_once()
>>> 			schedule()
>>> bug2:
>>> 	do_write_buffer()
>>> 		xip_disable()
>>> 			local_irq_disable()
>>> 		do_write_buffer_wait()
>>> 			schedule()
>>> bug3:
>>> 	do_erase_chip()
>>> 		xip_disable()
>>> 			local_irq_disable()
>>> 		schedule()
>>> bug4:
>>> 	do_erase_oneblock()
>>> 		xip_disable()
>>> 			local_irq_disable()
>>> 		schedule()
>>>
>>> Fixes: 02b15e343aee ("[MTD] XIP for AMD CFI flash.")
>>> Cc: stable@vger.kernel.org # v2.6.13
>>> Signed-off-by: Xiaoming Ni <nixiaoming@huawei.com>
>>> ---
>>>   drivers/mtd/chips/cfi_cmdset_0002.c | 16 ++++++++++++++++
>>>   1 file changed, 16 insertions(+)
>>>
>>> diff --git a/drivers/mtd/chips/cfi_cmdset_0002.c b/drivers/mtd/chips/cfi_cmdset_0002.c
>>> index a1f3e1031c3d..12c3776f093a 100644
>>> --- a/drivers/mtd/chips/cfi_cmdset_0002.c
>>> +++ b/drivers/mtd/chips/cfi_cmdset_0002.c
>>> @@ -1682,7 +1682,11 @@ static int __xipram do_write_oneword_once(struct map_info *map,
>>>   			set_current_state(TASK_UNINTERRUPTIBLE);
>>>   			add_wait_queue(&chip->wq, &wait);
>>>   			mutex_unlock(&chip->mutex);
>>> +			if (IS_ENABLED(CONFIG_MTD_XIP))
>>> +				local_irq_enable();
>>>   			schedule();
>>> +			if (IS_ENABLED(CONFIG_MTD_XIP))
>>> +				local_irq_disable();
> 
> The fix really seems strange to me. I will let Vignesh decide but I
> think we should consider updating/fixing xip_disable instead.

Agree with Miquel. Have you done any testing 
or is this purely based on code inspection?

What about comment before xip_disable() function:

/*
 * No interrupt what so ever can be serviced while the flash isn't in array
 * mode.  This is ensured by the xip_disable() and xip_enable() functions
 * enclosing any code path where the flash is known not to be in array mode.
 * And within a XIP disabled code path, only functions marked with __xipram
 * may be called and nothing else (it's a good thing to inspect generated
 * assembly to make sure inline functions were actually inlined and that gcc
 * didn't emit calls to its own support functions). Also configuring MTD CFI
 * support to a single buswidth and a single interleave is also recommended.
 */

So, I don't think the fix is as simple as this patch.

Regards
Vignesh
