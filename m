Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E979B1B6ECC
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 09:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726347AbgDXHTE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 03:19:04 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2092 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726051AbgDXHTD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Apr 2020 03:19:03 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.106])
        by Forcepoint Email with ESMTP id DC1392CAC0741D5FB70B;
        Fri, 24 Apr 2020 08:19:01 +0100 (IST)
Received: from [127.0.0.1] (10.47.6.64) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Fri, 24 Apr
 2020 08:19:00 +0100
Subject: Re: [PATCH] blk-mq: Put driver tag in blk_mq_dispatch_rq_list() when
 no budget
To:     Ming Lei <ming.lei@redhat.com>,
        Doug Anderson <dianders@chromium.org>
CC:     Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>,
        linux-block <linux-block@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Guenter Roeck <groeck@chromium.org>
References: <1587035931-125028-1-git-send-email-john.garry@huawei.com>
 <e5416179-2ba0-c9a8-1b86-d52eae29e146@acm.org>
 <663d472a-5bde-4b89-3137-c7bfdf4d7b97@huawei.com>
 <CAD=FV=XBrKgng+vYzJx+qsOEZ-cZ10A0t+pRh=FcbQMop2ht4Q@mail.gmail.com>
 <20200424013519.GA355437@T590>
From:   John Garry <john.garry@huawei.com>
Message-ID: <3b91a730-0923-c049-bbe4-68fc5a7ae793@huawei.com>
Date:   Fri, 24 Apr 2020 08:18:25 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20200424013519.GA355437@T590>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.6.64]
X-ClientProxiedBy: lhreml722-chm.china.huawei.com (10.201.108.73) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 24/04/2020 02:35, Ming Lei wrote:
> On Thu, Apr 23, 2020 at 03:42:37PM -0700, Doug Anderson wrote:
>> Hi,
>>
>> On Mon, Apr 20, 2020 at 1:23 AM John Garry <john.garry@huawei.com> wrote:
>>>
>>> On 18/04/2020 03:43, Bart Van Assche wrote:
>>>> On 2020-04-16 04:18, John Garry wrote:
>>>>> If in blk_mq_dispatch_rq_list() we find no budget, then we break of the
>>>>> dispatch loop, but the request may keep the driver tag, evaulated
>>>>> in 'nxt' in the previous loop iteration.
>>>>>
>>>>> Fix by putting the driver tag for that request.
>>>>>
>>>>> Signed-off-by: John Garry <john.garry@huawei.com>
>>>>>
>>>>> diff --git a/block/blk-mq.c b/block/blk-mq.c
>>>>> index 8e56884fd2e9..a7785df2c944 100644
>>>>> --- a/block/blk-mq.c
>>>>> +++ b/block/blk-mq.c
>>>>> @@ -1222,8 +1222,10 @@ bool blk_mq_dispatch_rq_list(struct request_queue *q, struct list_head *list,
>>>>>               rq = list_first_entry(list, struct request, queuelist);
>>>>>
>>>>>               hctx = rq->mq_hctx;
>>>>> -            if (!got_budget && !blk_mq_get_dispatch_budget(hctx))
>>>>> +            if (!got_budget && !blk_mq_get_dispatch_budget(hctx)) {
>>>>> +                    blk_mq_put_driver_tag(rq);
>>>>>                       break;
>>>>> +            }
>>>>>
>>>>>               if (!blk_mq_get_driver_tag(rq)) {
>>>>>                       /*
>>>>
>>>> Is this something that can only happen if q->mq_ops->queue_rq(hctx, &bd)
>>>> returns another value than BLK_STS_OK, BLK_STS_RESOURCE and
>>>> BLK_STS_DEV_RESOURCE?
>>>
>>> Right, as that case is handled in blk_mq_handle_dev_resource()
>>>
>>> If so, please add a comment in the source code
>>>> that explains this.
>>>
>>> So important that we should now do this in an extra patch?
>>>
>>>>
>>>> Is this perhaps a bug fix for 0bca799b9280 ("blk-mq: order getting
>>>> budget and driver tag")? If so, please mention this and add Cc tags for
>>>> the people who were Cc-ed on that patch.
>>>
>>> So it looks like 0bca799b9280 had a flaw, but I am not sure if anything
>>> got broken there and worthy of stable backport.
>>>
>>> I found this issue while debugging Ming's blk-mq cpu hotplug patchset,
>>> which I feel is ready to merge.
>>>
>>> Having said that, this nasty issue did take > 1 day for me to debug...
>>> so let me know.
>>
>> As per the above conversation, presumably this should go to stable
>> then for any kernel that has commit 0bca799b9280 ("blk-mq: order
>> getting budget and driver tag")?  For instance, I think 4.19 would be
>> affected?  When I picked it there I got a conflict due to not having
>> commit ea4f995ee8b8 ("blk-mq: cache request hardware queue mapping")
>> but I think it's just a context collision and easy to resolve.
>>
>> I'm no expert in the block code, but I posted my backport to 4.19 at
>> <https://crrev.com/c/2163313>.  I'm happy to send an email as a patch
>> to the list too or double-check that someone else's conflict
>> resolution matches mine.
> 
> The thing is that there may not user visible effect by this issue,
> when one tag isn't freed, this request will be re-dispatched soon.
> That said it just makes the tag lifetime longer.
> 
> It could only be an issue in case of request dependency, meantime
> the tag space is quite limited. However, not sure if there is such
> case in reality.
> 

FWIW, this was pretty nasty to debug, and if it's not going to cause 
harm, then I'd be more inclined to add to stable. In addition, some 
distro may backport patches on a stable baseline where it is visible 
separately, and miss this one.

Thanks,
John
