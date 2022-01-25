Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5FD49AE3F
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 09:41:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444429AbiAYIk6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 03:40:58 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:4490 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1451456AbiAYIis (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 03:38:48 -0500
Received: from fraeml744-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JjgGr2qtRz6H7cN;
        Tue, 25 Jan 2022 16:38:12 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml744-chm.china.huawei.com (10.206.15.225) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 25 Jan 2022 09:38:34 +0100
Received: from [10.47.84.133] (10.47.84.133) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Tue, 25 Jan
 2022 08:38:33 +0000
Subject: Re: [PATCH 5.16 1026/1039] blk-mq: fix tag_get wait task cant be
 awakened
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <stable@vger.kernel.org>, Ming Lei <ming.lei@redhat.com>,
        Laibin Qiu <qiulaibin@huawei.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Jens Axboe <axboe@kernel.dk>, <alex_y_xu@yahoo.ca>
References: <20220124184125.121143506@linuxfoundation.org>
 <20220124184159.785093232@linuxfoundation.org>
From:   John Garry <john.garry@huawei.com>
Message-ID: <e8558aeb-7343-da56-88bb-14c1a27d099c@huawei.com>
Date:   Tue, 25 Jan 2022 08:38:01 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20220124184159.785093232@linuxfoundation.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.84.133]
X-ClientProxiedBy: lhreml727-chm.china.huawei.com (10.201.108.78) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 24/01/2022 18:46, Greg Kroah-Hartman wrote:
> From: Laibin Qiu<qiulaibin@huawei.com>
> 
> commit 180dccb0dba4f5e84a4a70c1be1d34cbb6528b32 upstream.
> 
> In case of shared tags, there might be more than one hctx which
> allocates from the same tags, and each hctx is limited to allocate at
> most:
>          hctx_max_depth = max((bt->sb.depth + users - 1) / users, 4U);
> 
> tag idle detection is lazy, and may be delayed for 30sec, so there
> could be just one real active hctx(queue) but all others are actually
> idle and still accounted as active because of the lazy idle detection.
> Then if wake_batch is > hctx_max_depth, driver tag allocation may wait
> forever on this real active hctx.
> 
> Fix this by recalculating wake_batch when inc or dec active_queues.
> 
> Fixes: 0d2602ca30e41 ("blk-mq: improve support for shared tags maps")
> Suggested-by: Ming Lei<ming.lei@redhat.com>
> Suggested-by: John Garry<john.garry@huawei.com>
> Signed-off-by: Laibin Qiu<qiulaibin@huawei.com>
> Reviewed-by: Andy Shevchenko<andriy.shevchenko@linux.intel.com>
> Link:https://lore.kernel.org/r/20220113025536.1479653-1-qiulaibin@huawei.com
> Signed-off-by: Jens Axboe<axboe@kernel.dk>
> Signed-off-by: Greg Kroah-Hartman<gregkh@linuxfoundation.org>

JFYI, Somebody reported a hang with this commit:
https://lore.kernel.org/linux-block/78cafe94-a787-e006-8851-69906f0c2128@huawei.com/T/#t

Thanks,
John
