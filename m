Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5EE145FB50
	for <lists+stable@lfdr.de>; Sat, 27 Nov 2021 02:37:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347802AbhK0Bk5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Nov 2021 20:40:57 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:16308 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346045AbhK0Bi4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Nov 2021 20:38:56 -0500
Received: from dggpeml500020.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4J1Dh00y3yz90SV;
        Sat, 27 Nov 2021 09:35:12 +0800 (CST)
Received: from [10.174.177.174] (10.174.177.174) by
 dggpeml500020.china.huawei.com (7.185.36.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Sat, 27 Nov 2021 09:35:40 +0800
Subject: Re: [PATCH -next V5 1/2] sata_fsl: fix UAF in sata_fsl_port_stop when
 rmmod sata_fsl
To:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        <damien.lemoal@opensource.wdc.com>, <axboe@kernel.dk>,
        <tj@kernel.org>, <linux-ide@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <yebin10@huawei.com>, <yukuai3@huawei.com>,
        <stable@vger.kernel.org>, Hulk Robot <hulkci@huawei.com>
References: <20211126020307.2168767-1-libaokun1@huawei.com>
 <20211126020307.2168767-2-libaokun1@huawei.com>
 <f8acc1f0-62d1-3c80-840f-1e38e21ad3c9@gmail.com>
From:   "libaokun (A)" <libaokun1@huawei.com>
Message-ID: <87fba93f-3813-87e2-9746-55c2393bde95@huawei.com>
Date:   Sat, 27 Nov 2021 09:35:40 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <f8acc1f0-62d1-3c80-840f-1e38e21ad3c9@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.174]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500020.china.huawei.com (7.185.36.88)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

在 2021/11/27 3:43, Sergei Shtylyov 写道:
> On 11/26/21 5:03 AM, Baokun Li wrote:
>
>> When the `rmmod sata_fsl.ko` command is executed in the PPC64 GNU/Linux,
>> a bug is reported:
>>   ==================================================================
>>   BUG: Unable to handle kernel data access on read at 0x80000800805b502c
>>   Oops: Kernel access of bad area, sig: 11 [#1]
>>   NIP [c0000000000388a4] .ioread32+0x4/0x20
>>   LR [80000000000c6034] .sata_fsl_port_stop+0x44/0xe0 [sata_fsl]
>>   Call Trace:
>>    .free_irq+0x1c/0x4e0 (unreliable)
>>    .ata_host_stop+0x74/0xd0 [libata]
>>    .release_nodes+0x330/0x3f0
>>    .device_release_driver_internal+0x178/0x2c0
>>    .driver_detach+0x64/0xd0
>>    .bus_remove_driver+0x70/0xf0
>>    .driver_unregister+0x38/0x80
>>    .platform_driver_unregister+0x14/0x30
>>    .fsl_sata_driver_exit+0x18/0xa20 [sata_fsl]
>>    .__se_sys_delete_module+0x1ec/0x2d0
>>    .system_call_exception+0xfc/0x1f0
>>    system_call_common+0xf8/0x200
>>   ==================================================================
>>
>> The triggering of the BUG is shown in the following stack:
>>
>> driver_detach
>>    device_release_driver_internal
>>      __device_release_driver
>>        drv->remove(dev) --> platform_drv_remove/platform_remove
>>          drv->remove(dev) --> sata_fsl_remove
>>            iounmap(host_priv->hcr_base);			<---- unmap
>>            kfree(host_priv);                             <---- free
>>        devres_release_all
>>          release_nodes
>>            dr->node.release(dev, dr->data) --> ata_host_stop
>>              ap->ops->port_stop(ap) --> sata_fsl_port_stop
>>                  ioread32(hcr_base + HCONTROL)           <---- UAF
>>              host->ops->host_stop(host)
>>
>> The iounmap(host_priv->hcr_base) and kfree(host_priv) functions should
>> not be executed in drv->remove. These functions should be executed in
>> host_stop after port_stop. Therefore, we move these functions to the
>> new function sata_fsl_host_stop and bind the new function to host_stop.
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

