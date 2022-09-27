Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC435EC8B3
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 17:55:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232683AbiI0PzI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Sep 2022 11:55:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232790AbiI0Pym (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Sep 2022 11:54:42 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35FF01B95C8;
        Tue, 27 Sep 2022 08:54:27 -0700 (PDT)
Received: from fraeml707-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4McPJj3F7cz67yqL;
        Tue, 27 Sep 2022 23:52:21 +0800 (CST)
Received: from lhrpeml500003.china.huawei.com (7.191.162.67) by
 fraeml707-chm.china.huawei.com (10.206.15.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 27 Sep 2022 17:54:24 +0200
Received: from [10.48.156.245] (10.48.156.245) by
 lhrpeml500003.china.huawei.com (7.191.162.67) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 27 Sep 2022 16:54:24 +0100
Message-ID: <f24d0eb1-a578-2221-c8da-17ddbd35e96d@huawei.com>
Date:   Tue, 27 Sep 2022 16:54:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH 5.10] scsi: hisi_sas: Revert "scsi: hisi_sas: Limit max hw
 sectors for v3 HW"
To:     Yu Kuai <yukuai1@huaweicloud.com>, <gregkh@linuxfoundation.org>,
        <stable@vger.kernel.org>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <yi.zhang@huawei.com>,
        "yukuai (C)" <yukuai3@huawei.com>
References: <20220927130116.1013775-1-yukuai3@huawei.com>
 <a1fe584c-5001-9983-3a3d-65d3bd396642@huawei.com>
 <2bcb72eb-b9a7-8fed-f17d-3f1df4da9ee5@huaweicloud.com>
 <f50cc744-f522-259a-e670-809d65361548@huawei.com>
 <5b8cc025-0755-74c1-3df5-a95718d23861@huaweicloud.com>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <5b8cc025-0755-74c1-3df5-a95718d23861@huaweicloud.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.48.156.245]
X-ClientProxiedBy: lhrpeml500003.china.huawei.com (7.191.162.67) To
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

On 27/09/2022 15:05, Yu Kuai wrote:
>>
>> However both 5.15 stable and 5.19 mainline include fce54ed02757 - it 
>> was automatically backported for 5.15 stable. Please double check that.
>>
>> And can you also check performance there for those kernels?
> 
> I'm pretty sure io split can decline performance, especially for HDD,
> because blk-mq can't guarantee that split io can be dispatched to disk
> sequentially. However, this is usually not common with proper
> max_sectors_kb.
> 
> Here is an example that if max_sector_kb is 128k, performance will
> drop a lot under high concurrency:
> 
> https://lore.kernel.org/all/20220408073916.1428590-1-yukuai3@huawei.com/
> 
> Here I set max_sectors_kb to 128k manually, and 1m random io performance
> will drop while io concurrency increase:
> 
> | numjobs | v5.18-rc1 |
> | ------- | --------- |
> | 1       | 67.7      |
> | 2       | 67.7      |
> | 4       | 67.7      |
> | 8       | 67.7      |
> | 16      | 64.8      |
> | 32      | 59.8      |
> | 64      | 54.9      |
> | 128     | 49        |
> | 256     | 37.7      |
> | 512     | 31.8      |

Commit fce54ed02757 was to circumvent a terrible performance hit for 
IOMMU enabled from 4e89dce72521 - have you ever tested with IOMMU enabled?

If fce54ed02757 really does cause a performance regression in some 
scenarios, then we can consider reverting it from any stable kernel and 
also backporting [0] when it is included in Linus' kernel

[0] 
https://lore.kernel.org/linux-iommu/495de02c-59ce-917f-1cb4-5425a37063ed@huawei.com/T/#m6a655d596fdf30e4e8b90100e16f75ae5d67341a

thanks,
John
