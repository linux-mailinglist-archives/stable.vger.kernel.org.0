Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7304E425F46
	for <lists+stable@lfdr.de>; Thu,  7 Oct 2021 23:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242294AbhJGVlM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Oct 2021 17:41:12 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3943 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235665AbhJGVlM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Oct 2021 17:41:12 -0400
Received: from fraeml734-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4HQPlc71p7z67bcg;
        Fri,  8 Oct 2021 05:36:28 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml734-chm.china.huawei.com (10.206.15.215) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Thu, 7 Oct 2021 23:39:15 +0200
Received: from [10.47.80.141] (10.47.80.141) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Thu, 7 Oct 2021
 22:39:14 +0100
Subject: Re: [PATCH v2] scsi: core: Fix shost->cmd_per_lun calculation in
 scsi_add_host_with_dma()
To:     Dexuan Cui <decui@microsoft.com>, <kys@microsoft.com>,
        <sthemmin@microsoft.com>, <wei.liu@kernel.org>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <haiyangz@microsoft.com>, <ming.lei@redhat.com>,
        <bvanassche@acm.org>, <linux-scsi@vger.kernel.org>,
        <linux-hyperv@vger.kernel.org>, <longli@microsoft.com>,
        <mikelley@microsoft.com>
CC:     <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
References: <20211007174957.2080-1-decui@microsoft.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <8fe3959d-9462-64f6-53d8-ef7036ec0545@huawei.com>
Date:   Thu, 7 Oct 2021 22:41:46 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20211007174957.2080-1-decui@microsoft.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.80.141]
X-ClientProxiedBy: lhreml744-chm.china.huawei.com (10.201.108.194) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 07/10/2021 18:49, Dexuan Cui wrote:
> After commit ea2f0f77538c, a 416-CPU VM running on Hyper-V hangs during
> boot because scsi_add_host_with_dma() sets shost->cmd_per_lun to a
> negative number (the below numbers may differ in different kernel versions):
> in drivers/scsi/storvsc_drv.c, 	storvsc_drv_init() sets
> 'max_outstanding_req_per_channel' to 352, and storvsc_probe() sets
> 'max_sub_channels' to (416 - 1) / 4 = 103 and sets scsi_driver.can_queue to
> 352 * (103 + 1) * (100 - 10) / 100 = 32947, which exceeds SHRT_MAX.

I think that you just need to mention that if can_queue exceeds 
SHRT_MAX, then there is a data truncation issue.

> 
> Use min_t(int, ...) to fix the issue.
> 
> Fixes: ea2f0f77538c ("scsi: core: Cap scsi_host cmd_per_lun at can_queue")
> Cc: stable@vger.kernel.org
> Signed-off-by: Dexuan Cui <decui@microsoft.com>

It looks ok, I'd just like to test it a bit more.

Thanks,
John

> ---
> 
> v1 tried to fix the issue by changing the storvsc driver:
> https://lwn.net/ml/linux-kernel/BYAPR21MB1270BBC14D5F1AE69FC31A16BFB09@BYAPR21MB1270.namprd21.prod.outlook.com/
> 
> v2 directly fixes the scsi core change instead as Michael Kelley and
> John Garry suggested (refer to the above link).

To be fair, it was Michael's suggestion

> 
>   drivers/scsi/hosts.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index 3f6f14f0cafb..24b72ee4246f 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -220,7 +220,8 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
>   		goto fail;
>   	}
>   
> -	shost->cmd_per_lun = min_t(short, shost->cmd_per_lun,
> +	/* Use min_t(int, ...) in case shost->can_queue exceeds SHRT_MAX */
> +	shost->cmd_per_lun = min_t(int, shost->cmd_per_lun,
>   				   shost->can_queue);
>   
>   	error = scsi_init_sense_cache(shost);
> 

