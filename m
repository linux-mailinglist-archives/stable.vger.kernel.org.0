Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6A8A40C4B2
	for <lists+stable@lfdr.de>; Wed, 15 Sep 2021 13:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237543AbhIOMAJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Sep 2021 08:00:09 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:9875 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232793AbhIOMAI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Sep 2021 08:00:08 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4H8dt60m1tz8yZY;
        Wed, 15 Sep 2021 19:54:22 +0800 (CST)
Received: from dggema762-chm.china.huawei.com (10.1.198.204) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2308.8; Wed, 15 Sep 2021 19:58:45 +0800
Received: from [10.174.176.73] (10.174.176.73) by
 dggema762-chm.china.huawei.com (10.1.198.204) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.8; Wed, 15 Sep 2021 19:58:45 +0800
Subject: Re: [PATCH linux-4.19.y] blk-mq: fix divide by zero crash in
 tg_may_dispatch()
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     <linux-block@vger.kernel.org>, <stable@vger.kernel.org>,
        <axboe@kernel.dk>, <hch@lst.de>, <yi.zhang@huawei.com>
References: <20210914125402.4068844-1-yukuai3@huawei.com>
 <YUHYqwVeeXtfD0qf@kroah.com>
From:   "yukuai (C)" <yukuai3@huawei.com>
Message-ID: <0380c476-9cf5-d621-e432-ba5f5c7138c5@huawei.com>
Date:   Wed, 15 Sep 2021 19:58:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <YUHYqwVeeXtfD0qf@kroah.com>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.176.73]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggema762-chm.china.huawei.com (10.1.198.204)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021/09/15 19:27, Greg KH wrote:
> On Tue, Sep 14, 2021 at 08:54:02PM +0800, Yu Kuai wrote:
>> If blk-throttle is enabled and io is issued before
>> blk_throtl_register_queue() is done. Divide by zero crash will be
>> triggered in tg_may_dispatch() because 'throtl_slice' is uninitialized.
>>
>> The problem is fixed in commit 75f4dca59694 ("block: call
>> blk_register_queue earlier in device_add_disk") from mainline, however
>> it's too hard to backport this patch due to lots of refactoring.
>>
>> Thus introduce a new flag QUEUE_FLAG_THROTL_INIT_DONE. It will be set
>> after blk_throtl_register_queue() is done, and will be checked before
>> applying any config.
>>
>> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
>> ---
>>   block/blk-sysfs.c      |  2 ++
>>   block/blk-throttle.c   | 41 +++++++++++++++++++++++++++++++++++++++--
>>   include/linux/blkdev.h |  1 +
>>   3 files changed, 42 insertions(+), 2 deletions(-)
> 
> 
> The commit you reference above is in 5.15-rc1.  What about all of the
> other stable kernel releases newer than 4.19.y?  You do not want to move
> to a newer release and have a regression.

All other kernel releases without this patch have the same issure,
including v5.14.
> 
> And I would _REALLY_ like to take the identical commits that are
> upstream if at all possible.  What is needed to backport instead of
> doing this one-off patch instead?

The function __device_add_disk() is quite different compared from
4.19.y to mainline, I haven't finish to collect that how many patches is
needed yet, which is not easy to do...
> 
> When we take changes that are not upstream, almost always they are
> broken so we almost never want to do that.

I understand that, more proper fix should be calling blk_register_queue
earlier in device_add_disk like the commit did. I'll try to do that and
hope conflicts are not too much...

Thanks,
Kuai
> 
> thanks,
> 
> greg k-h
> .
> 
