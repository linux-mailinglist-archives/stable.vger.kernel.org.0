Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6115EC398
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 15:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232314AbiI0NGL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Sep 2022 09:06:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231322AbiI0NGI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Sep 2022 09:06:08 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D3F517D413;
        Tue, 27 Sep 2022 06:06:01 -0700 (PDT)
Received: from fraeml701-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4McKbL3JKKz686RQ;
        Tue, 27 Sep 2022 21:04:46 +0800 (CST)
Received: from lhrpeml500003.china.huawei.com (7.191.162.67) by
 fraeml701-chm.china.huawei.com (10.206.15.50) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.31; Tue, 27 Sep 2022 15:05:58 +0200
Received: from [10.48.156.245] (10.48.156.245) by
 lhrpeml500003.china.huawei.com (7.191.162.67) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 27 Sep 2022 14:05:58 +0100
Message-ID: <a1fe584c-5001-9983-3a3d-65d3bd396642@huawei.com>
Date:   Tue, 27 Sep 2022 14:06:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH 5.10] scsi: hisi_sas: Revert "scsi: hisi_sas: Limit max hw
 sectors for v3 HW"
To:     Yu Kuai <yukuai3@huawei.com>, <gregkh@linuxfoundation.org>,
        <stable@vger.kernel.org>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <yukuai1@huaweicloud.com>,
        <yi.zhang@huawei.com>
References: <20220927130116.1013775-1-yukuai3@huawei.com>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <20220927130116.1013775-1-yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.48.156.245]
X-ClientProxiedBy: lhrpeml100005.china.huawei.com (7.191.160.25) To
 lhrpeml500003.china.huawei.com (7.191.162.67)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-6.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 27/09/2022 14:01, Yu Kuai wrote:
> This reverts commit 24cd0b9bfdff126c066032b0d40ab0962d35e777.
> 
> 1) commit 4e89dce72521 ("iommu/iova: Retry from last rb tree node if
> iova search fails") tries to fix that iova allocation can fail while
> there are still free space available. This is not backported to 5.10
> stable.

This arrived in 5.11, I think

> 2) commit fce54ed02757 ("scsi: hisi_sas: Limit max hw sectors for v3
> HW") fix the performance regression introduced by 1), however, this
> is just a temporary solution and will cause io performance regression
> because it limit max io size to PAGE_SIZE * 32(128k for 4k page_size).

Did you really notice a performance regression? In what scenario? which 
kernel versions?

> 3) John Garry posted a patchset to fix the problem.
> 4) The temporary solution is reverted.
> 


> It's weird that the patch in 2) is backported to 5.10 stable alone,
> while the right thing to do is to backport them all together.

I would tend to agree. I did not notice fce54ed02757 backported at all. 
But I did consider backporting it to address 4e89dce72521. Anyway, the 
proper solution is merged for 6.0 in 4cbfca5f7750 ("scsi: 
scsi_transport_sas: cap shost opt_sectors according to DMA optimal 
limit") and I have a revert of "scsi: hisi_sas: Limit max hw sectors for 
v3 HW" queued for 6.1, but I would not plan on reverting for stable.

Please let me know if any issue here.

Thanks,
John

> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>   drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 7 -------
>   1 file changed, 7 deletions(-)
> 
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> index dfe7e6370d84..cd41dc061d87 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> @@ -2738,7 +2738,6 @@ static int slave_configure_v3_hw(struct scsi_device *sdev)
>   	struct hisi_hba *hisi_hba = shost_priv(shost);
>   	struct device *dev = hisi_hba->dev;
>   	int ret = sas_slave_configure(sdev);
> -	unsigned int max_sectors;
>   
>   	if (ret)
>   		return ret;
> @@ -2756,12 +2755,6 @@ static int slave_configure_v3_hw(struct scsi_device *sdev)
>   		}
>   	}
>   
> -	/* Set according to IOMMU IOVA caching limit */
> -	max_sectors = min_t(size_t, queue_max_hw_sectors(sdev->request_queue),
> -			    (PAGE_SIZE * 32) >> SECTOR_SHIFT);
> -
> -	blk_queue_max_hw_sectors(sdev->request_queue, max_sectors);
> -
>   	return 0;
>   }
>   

