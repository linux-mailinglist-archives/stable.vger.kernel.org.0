Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8570145FB59
	for <lists+stable@lfdr.de>; Sat, 27 Nov 2021 02:38:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349971AbhK0BmK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Nov 2021 20:42:10 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:28179 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242280AbhK0BkJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Nov 2021 20:40:09 -0500
Received: from dggpeml500020.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4J1Dgm0P9zz8vfN;
        Sat, 27 Nov 2021 09:35:00 +0800 (CST)
Received: from [10.174.177.174] (10.174.177.174) by
 dggpeml500020.china.huawei.com (7.185.36.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Sat, 27 Nov 2021 09:36:38 +0800
Subject: Re: [PATCH -next V5 2/2] sata_fsl: fix warning in remove_proc_entry
 when rmmod sata_fsl
To:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        <damien.lemoal@opensource.wdc.com>, <axboe@kernel.dk>,
        <tj@kernel.org>, <linux-ide@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <yebin10@huawei.com>, <yukuai3@huawei.com>,
        <stable@vger.kernel.org>, Hulk Robot <hulkci@huawei.com>
References: <20211126020307.2168767-1-libaokun1@huawei.com>
 <20211126020307.2168767-3-libaokun1@huawei.com>
 <d54fd029-77e3-524a-65ab-90761338e1db@gmail.com>
From:   "libaokun (A)" <libaokun1@huawei.com>
Message-ID: <2a8d0992-9f14-86ea-f473-167453b6f43b@huawei.com>
Date:   Sat, 27 Nov 2021 09:36:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <d54fd029-77e3-524a-65ab-90761338e1db@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.174]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500020.china.huawei.com (7.185.36.88)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

在 2021/11/27 3:44, Sergei Shtylyov 写道:
> On 11/26/21 5:03 AM, Baokun Li wrote:
>
>> Trying to remove the fsl-sata module in the PPC64 GNU/Linux
>> leads to the following warning:
>>   ------------[ cut here ]------------
>>   remove_proc_entry: removing non-empty directory 'irq/69',
>>     leaking at least 'fsl-sata[ff0221000.sata]'
>>   WARNING: CPU: 3 PID: 1048 at fs/proc/generic.c:722
>>     .remove_proc_entry+0x20c/0x220
>>   IRQMASK: 0
>>   NIP [c00000000033826c] .remove_proc_entry+0x20c/0x220
>>   LR [c000000000338268] .remove_proc_entry+0x208/0x220
>>   Call Trace:
>>    .remove_proc_entry+0x208/0x220 (unreliable)
>>    .unregister_irq_proc+0x104/0x140
>>    .free_desc+0x44/0xb0
>>    .irq_free_descs+0x9c/0xf0
>>    .irq_dispose_mapping+0x64/0xa0
>>    .sata_fsl_remove+0x58/0xa0 [sata_fsl]
>>    .platform_drv_remove+0x40/0x90
>>    .device_release_driver_internal+0x160/0x2c0
>>    .driver_detach+0x64/0xd0
>>    .bus_remove_driver+0x70/0xf0
>>    .driver_unregister+0x38/0x80
>>    .platform_driver_unregister+0x14/0x30
>>    .fsl_sata_driver_exit+0x18/0xa20 [sata_fsl]
>>   ---[ end trace 0ea876d4076908f5 ]---
>>
>> The driver creates the mapping by calling irq_of_parse_and_map(),
>> so it also has to dispose the mapping. But the easy way out is to
>> simply use platform_get_irq() instead of irq_of_parse_map(). Also
>> we should adapt return value checking and propagate error values.
>>
>> In this case the mapping is not managed by the device but by
>> the of core, so the device has not to dispose the mapping.
>>
>> Fixes: faf0b2e5afe7 ("drivers/ata: add support to Freescale 3.0Gbps SATA Controller")
>> Cc: stable@vger.kernel.org
>> Reported-by: Hulk Robot <hulkci@huawei.com>
>> Signed-off-by: Baokun Li <libaokun1@huawei.com>
> Reviewed-by: Sergei Shtylyov <sergei.shtylyov@gmail.com>
>
> MBR, Sergei
> .

Thank you for your review.

-- 
With Best Regards,
Baokun Li
.

