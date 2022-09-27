Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11A395EC4D4
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 15:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231934AbiI0Np3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Sep 2022 09:45:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231684AbiI0Np1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Sep 2022 09:45:27 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AE116E2D4;
        Tue, 27 Sep 2022 06:45:25 -0700 (PDT)
Received: from fraeml701-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4McLRr5wSxz67KvJ;
        Tue, 27 Sep 2022 21:43:20 +0800 (CST)
Received: from lhrpeml500003.china.huawei.com (7.191.162.67) by
 fraeml701-chm.china.huawei.com (10.206.15.50) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.31; Tue, 27 Sep 2022 15:45:23 +0200
Received: from [10.48.156.245] (10.48.156.245) by
 lhrpeml500003.china.huawei.com (7.191.162.67) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 27 Sep 2022 14:45:23 +0100
Message-ID: <f50cc744-f522-259a-e670-809d65361548@huawei.com>
Date:   Tue, 27 Sep 2022 14:45:25 +0100
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
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <2bcb72eb-b9a7-8fed-f17d-3f1df4da9ee5@huaweicloud.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.48.156.245]
X-ClientProxiedBy: lhrpeml100002.china.huawei.com (7.191.160.241) To
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

On 27/09/2022 14:14, Yu Kuai wrote:
> Hi, John
> 
> 在 2022/09/27 21:06, John Garry 写道:
>> On 27/09/2022 14:01, Yu Kuai wrote:
>>> This reverts commit 24cd0b9bfdff126c066032b0d40ab0962d35e777.
>>>
>>> 1) commit 4e89dce72521 ("iommu/iova: Retry from last rb tree node if
>>> iova search fails") tries to fix that iova allocation can fail while
>>> there are still free space available. This is not backported to 5.10
>>> stable.
>>
>> This arrived in 5.11, I think
>>
>>> 2) commit fce54ed02757 ("scsi: hisi_sas: Limit max hw sectors for v3
>>> HW") fix the performance regression introduced by 1), however, this
>>> is just a temporary solution and will cause io performance regression
>>> because it limit max io size to PAGE_SIZE * 32(128k for 4k page_size).
>>
>> Did you really notice a performance regression? In what scenario? 
>> which kernel versions?
> 
> We are using 5.10, and test tool is fs_mark and it's doing writeback,
> and benefits from io merge, before this patch, avgqusz is 300+, and this
> patch will limit avgqusz to 128.

OK, so I think it's ok to revert for 5.10

> 
> I think that in any other case that io size is greater than 128k, this
> patch will probably have defects.

However both 5.15 stable and 5.19 mainline include fce54ed02757 - it was 
automatically backported for 5.15 stable. Please double check that.

And can you also check performance there for those kernels?

The reason which we had fce54ed02757 was because 4e89dce72521 hammered 
performance when IOMMU enabled, and at least I saw no performance 
regression for fce54ed02757 in other scenarios.

Thanks,
John





