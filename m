Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEE3F6D562A
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 03:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232545AbjDDBfU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 21:35:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233009AbjDDBfM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 21:35:12 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99E642693
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 18:35:11 -0700 (PDT)
Received: from kwepemi500012.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Pr9GT3TgjznbBB;
        Tue,  4 Apr 2023 09:31:45 +0800 (CST)
Received: from [10.67.110.176] (10.67.110.176) by
 kwepemi500012.china.huawei.com (7.221.188.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 4 Apr 2023 09:35:08 +0800
Subject: Re: [PATCH 5.10] media: ti: cal: revert "media: ti: cal: fix possible
 memory leak in cal_ctx_create()"
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>, <bparrot@ti.com>, <mchehab@kernel.org>,
        <sashal@kernel.org>, <laurent.pinchart@ideasonboard.com>,
        <patches@lists.linux.dev>
References: <20230403121704.3017781-1-cuigaosheng1@huawei.com>
 <2023040303-corporate-unearth-8b5b@gregkh>
 <beac5f8a-d96e-1e1f-1e3c-18f3f9d7519c@huawei.com>
 <2023040333-untimely-salami-5e44@gregkh>
From:   cuigaosheng <cuigaosheng1@huawei.com>
Message-ID: <ab7ba725-3d04-f0a5-2260-dbcdd7de7ebe@huawei.com>
Date:   Tue, 4 Apr 2023 09:35:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <2023040333-untimely-salami-5e44@gregkh>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.110.176]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemi500012.china.huawei.com (7.221.188.12)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-3.6 required=5.0 tests=NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 2023/4/3 21:35, Greg KH wrote:
> On Mon, Apr 03, 2023 at 09:11:43PM +0800, cuigaosheng wrote:
>> On 2023/4/3 20:53, Greg KH wrote:
>>> On Mon, Apr 03, 2023 at 08:17:04PM +0800, Gaosheng Cui wrote:
>>>> This reverts commit c7a218cbf67fffcd99b76ae3b5e9c2e8bef17c8c.
>>>>
>>>> The memory of ctx is allocated by devm_kzalloc in cal_ctx_create,
>>>> it should not be freed by kfree when cal_ctx_v4l2_init() fails,
>>>> otherwise kfree() will cause double free, so revert this patch.
>>>>
>>>> Fixes: c7a218cbf67f ("media: ti: cal: fix possible memory leak in cal_ctx_create()")
>>>> Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
>>>> ---
>>>>    drivers/media/platform/ti-vpe/cal.c | 4 +---
>>>>    1 file changed, 1 insertion(+), 3 deletions(-)
>>>>
>>>> diff --git a/drivers/media/platform/ti-vpe/cal.c b/drivers/media/platform/ti-vpe/cal.c
>>>> index 93121c90d76a..2eef245c31a1 100644
>>>> --- a/drivers/media/platform/ti-vpe/cal.c
>>>> +++ b/drivers/media/platform/ti-vpe/cal.c
>>>> @@ -624,10 +624,8 @@ static struct cal_ctx *cal_ctx_create(struct cal_dev *cal, int inst)
>>>>    	ctx->cport = inst;
>>>>    	ret = cal_ctx_v4l2_init(ctx);
>>>> -	if (ret) {
>>>> -		kfree(ctx);
>>>> +	if (ret)
>>>>    		return NULL;
>>>> -	}
>>>>    	return ctx;
>>>>    }
>>>> -- 
>>>> 2.25.1
>>>>
>>> Why is this not needed to be reverted in Linus's tree first?
>>>
>>> thanks,
>>>
>>> greg k-h
>>> .
>> Thanks for taking time to review this patch.
>>
>> The memory of ctx is allocated by kzalloc since commit 9e67f24e4d90
>> ("media: ti-vpe: cal: fix ctx uninitialization"), so the fixes tag
>> of patch c7a218cbf67fis not entirely accurate, mainline should merge this
>> patch, but it should not be merged into 5.10, my apologies  for
>> notdiscovering this bug earlier. Gaosheng.
>>
> Great, can you please put all of this information in the changelog
> explaining why this is only needed for this one branch and resend it?
>
> thanks,
>
> greg k-h
> .

I have updated the commit message and resend it, thanks!

Gaosheng.

