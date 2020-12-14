Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E82D82D9395
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 08:18:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438915AbgLNHSc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 02:18:32 -0500
Received: from fllv0015.ext.ti.com ([198.47.19.141]:45746 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726305AbgLNHSb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Dec 2020 02:18:31 -0500
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0BE7Gtgh074940;
        Mon, 14 Dec 2020 01:16:55 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1607930215;
        bh=8FHqPP8PBL/oO2YZ5LjA9fGaAwrrvB9dOJXSZMgKL24=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=i6wTFtj2r08OWxpTCqDKPlwFrEkRth5z4rhY833WWd0Ym490ManQwNO/x3t4p2HsH
         JAURnj8+vPWgb/NgnBXeGb1ImDnoxyMrxOSIwWewpc5mhZbqNhBhUaLkKwZIzOGjb4
         SI/ucIWQEk5QAhMGOwyCt/vMIAYfT2/d9h3eWcqc=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 0BE7GsmG105549
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 14 Dec 2020 01:16:55 -0600
Received: from DLEE107.ent.ti.com (157.170.170.37) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Mon, 14
 Dec 2020 01:16:54 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE107.ent.ti.com
 (157.170.170.37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Mon, 14 Dec 2020 01:16:54 -0600
Received: from [10.250.233.179] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0BE7GpkQ093250;
        Mon, 14 Dec 2020 01:16:51 -0600
Subject: Re: ping // [PATCH] mtd:cfi_cmdset_0002: fix atomic sleep bug when
 CONFIG_MTD_XIP=y
To:     Xiaoming Ni <nixiaoming@huawei.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
CC:     <richard@nod.at>, <tudor.ambarus@microchip.com>,
        <tglx@linutronix.de>, <linux-mtd@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <wangle6@huawei.com>
References: <20201127130731.99270-1-nixiaoming@huawei.com>
 <a02e1364-3b82-039a-4b65-e2a216663dd4@huawei.com>
 <20201207115228.0a6de398@xps13> <73b539eb-616e-64d8-07d8-4606da2ea2ea@ti.com>
 <b5c52547-b3cc-4217-cc69-067cee7d536f@huawei.com>
From:   Vignesh Raghavendra <vigneshr@ti.com>
Message-ID: <f14ccb94-cb53-f495-e95c-fe657122f16c@ti.com>
Date:   Mon, 14 Dec 2020 12:46:50 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <b5c52547-b3cc-4217-cc69-067cee7d536f@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 12/8/20 6:53 AM, Xiaoming Ni wrote:
> On 2020/12/8 2:59, Vignesh Raghavendra wrote:
>> Hi Xiaoming,
>>
[...]
>>>>> ---
>>>>>    drivers/mtd/chips/cfi_cmdset_0002.c | 16 ++++++++++++++++
>>>>>    1 file changed, 16 insertions(+)
>>>>>
>>>>> diff --git a/drivers/mtd/chips/cfi_cmdset_0002.c
>>>>> b/drivers/mtd/chips/cfi_cmdset_0002.c
>>>>> index a1f3e1031c3d..12c3776f093a 100644
>>>>> --- a/drivers/mtd/chips/cfi_cmdset_0002.c
>>>>> +++ b/drivers/mtd/chips/cfi_cmdset_0002.c
>>>>> @@ -1682,7 +1682,11 @@ static int __xipram
>>>>> do_write_oneword_once(struct map_info *map,
>>>>>                set_current_state(TASK_UNINTERRUPTIBLE);
>>>>>                add_wait_queue(&chip->wq, &wait);
>>>>>                mutex_unlock(&chip->mutex);
>>>>> +            if (IS_ENABLED(CONFIG_MTD_XIP))
>>>>> +                local_irq_enable();
>>>>>                schedule();
>>>>> +            if (IS_ENABLED(CONFIG_MTD_XIP))
>>>>> +                local_irq_disable();
>>>
>>> The fix really seems strange to me. I will let Vignesh decide but I
>>> think we should consider updating/fixing xip_disable instead.
>>
>> Agree with Miquel. Have you done any testing
>> or is this purely based on code inspection?
>>
> I don't have the corresponding device test environment.
> I found the problem through code review.
> 

Sorry, I am not comfortable applying this patch without proper testing
that given the unknowns and legacy nature of the code.

> 
>> What about comment before xip_disable() function:
>>
>> /*
>>   * No interrupt what so ever can be serviced while the flash isn't in
>> array
>>   * mode.  This is ensured by the xip_disable() and xip_enable()
>> functions
>>   * enclosing any code path where the flash is known not to be in
>> array mode.
>>   * And within a XIP disabled code path, only functions marked with
>> __xipram
>>   * may be called and nothing else (it's a good thing to inspect
>> generated
>>   * assembly to make sure inline functions were actually inlined and
>> that gcc
>>   * didn't emit calls to its own support functions). Also configuring
>> MTD CFI
>>   * support to a single buswidth and a single interleave is also
>> recommended.
>>   */
>>
>> So, I don't think the fix is as simple as this patch.
>>
> +xip_enable();
>  schedule();
> +xip_disable();
> 
> Do I need to change it to this?
> 

This just narrows the window, but an IRQ is still possible just after
xip_enable() but before schedule().

Regards
Vignesh

