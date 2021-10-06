Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C65142427F
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 18:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239148AbhJFQXW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 12:23:22 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3940 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbhJFQXW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Oct 2021 12:23:22 -0400
Received: from fraeml711-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4HPfkv3Nt5z67LTc;
        Thu,  7 Oct 2021 00:18:15 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml711-chm.china.huawei.com (10.206.15.60) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 6 Oct 2021 18:21:26 +0200
Received: from [10.47.95.252] (10.47.95.252) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2308.8; Wed, 6 Oct 2021
 17:21:24 +0100
Subject: Re: [PATCH] scsi: storvsc: Cap scsi_driver.can_queue to fix a hang
 issue during boot
To:     Michael Kelley <mikelley@microsoft.com>,
        Dexuan Cui <decui@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "ming.lei@redhat.com" <ming.lei@redhat.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <20211006070345.51713-1-decui@microsoft.com>
 <e36619df-652d-3550-cb4d-9b65b2f5faee@huawei.com>
 <MWHPR21MB159368D7BAAD90E19F31D1C6D7B09@MWHPR21MB1593.namprd21.prod.outlook.com>
 <d9416464-cf0f-2275-2d16-94e81d5b4362@huawei.com>
 <MWHPR21MB15932B5C5B5C5EE5CBAFE00ED7B09@MWHPR21MB1593.namprd21.prod.outlook.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <fc4b3284-0218-8a03-a55c-94c10ac0b029@huawei.com>
Date:   Wed, 6 Oct 2021 17:24:00 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <MWHPR21MB15932B5C5B5C5EE5CBAFE00ED7B09@MWHPR21MB1593.namprd21.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.95.252]
X-ClientProxiedBy: lhreml709-chm.china.huawei.com (10.201.108.58) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 06/10/2021 17:08, Michael Kelley wrote:
>>> The calculated value of can_queue is not realistic.  The blk-mq layer
>>> caps the number of tags at 10240,
>> nit: 1024, I think
> I was thinking about BLK_MQ_MAX_DEPTH (#define'd as 10240), which
> is used to limit the tag set size in blk_mq_alloc_tag_set().   When running
> on large VMs on Hyper-V, we can see the "blk-mq: reduced tag depth
> to 10240" message.:-(

Ah, right. The other related capping is the sdev queue depth, which is 
now capped at max(1024, can_queue), see scsi_device_max_queue_depth().

Thanks,
John
