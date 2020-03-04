Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6BBB178CB1
	for <lists+stable@lfdr.de>; Wed,  4 Mar 2020 09:41:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728845AbgCDIlT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Mar 2020 03:41:19 -0500
Received: from lelv0143.ext.ti.com ([198.47.23.248]:45548 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725271AbgCDIlT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Mar 2020 03:41:19 -0500
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0248fJrg076181;
        Wed, 4 Mar 2020 02:41:19 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1583311279;
        bh=rh+u6hRecxH1UwjsGXN0erDuw+ULRQgmjFGSRajyK60=;
        h=Subject:From:To:CC:References:Date:In-Reply-To;
        b=MMAktQ/ejoPhBWD9wssZfw0fGIRODO1BIfxEJ8tYQBJra4cpFunSZK8VepBGBKuAp
         4tvCoi7i2/YY/g9dmBi0YVL+T/uvWqTROk8s1aJFmN+xTYd6M9oC4vbQup67hN5CoW
         d/bQqROvl6yDwEp75+nUPDgim5XJjkU+VXr8pXNA=
Received: from DLEE115.ent.ti.com (dlee115.ent.ti.com [157.170.170.26])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 0248fI3C008404
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 4 Mar 2020 02:41:18 -0600
Received: from DLEE112.ent.ti.com (157.170.170.23) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Wed, 4 Mar
 2020 02:41:18 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Wed, 4 Mar 2020 02:41:18 -0600
Received: from [192.168.2.6] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0248fGQt038530;
        Wed, 4 Mar 2020 02:41:17 -0600
Subject: Re: [Patch] media: ti-vpe: cal: fix a kernel oops when unloading
 module
From:   Tomi Valkeinen <tomi.valkeinen@ti.com>
To:     Benoit Parrot <bparrot@ti.com>, Hans Verkuil <hverkuil@xs4all.nl>
CC:     <linux-media@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
References: <20200303172629.21339-1-bparrot@ti.com>
 <4010c13f-6a32-f3c3-5b6d-62a4e3782c64@ti.com>
Message-ID: <f7f6dd87-147f-b9e9-aaa7-c063a8f3c11e@ti.com>
Date:   Wed, 4 Mar 2020 10:41:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <4010c13f-6a32-f3c3-5b6d-62a4e3782c64@ti.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 04/03/2020 10:40, Tomi Valkeinen wrote:
> On 03/03/2020 19:26, Benoit Parrot wrote:
>> After the switch to use v4l2_async_notifier_add_subdev() and
>> v4l2_async_notifier_cleanup(), unloading the ti_cal module would casue a
>> kernel oops.
>>
>> This was root cause to the fact that v4l2_async_notifier_cleanup() tries
>> to kfree the asd pointer passed into v4l2_async_notifier_add_subdev().
>>
>> In our case the asd reference was from a statically allocated struct.
>> So in effect v4l2_async_notifier_cleanup() was trying to free a pointer
>> that was not kalloc.
>>
>> So here we switch to using a kzalloc struct instead of a static one.
>>
>> Fixes: d079f94c9046 ("media: platform: Switch to v4l2_async_notifier_add_subdev")
>>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Benoit Parrot <bparrot@ti.com>
>> ---
>>   drivers/media/platform/ti-vpe/cal.c | 7 ++++---
>>   1 file changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/media/platform/ti-vpe/cal.c b/drivers/media/platform/ti-vpe/cal.c
>> index 6d4cbb8782ed..18fe2cb9dd17 100644
>> --- a/drivers/media/platform/ti-vpe/cal.c
>> +++ b/drivers/media/platform/ti-vpe/cal.c
>> @@ -372,8 +372,6 @@ struct cal_ctx {
>>       struct v4l2_subdev    *sensor;
>>       struct v4l2_fwnode_endpoint    endpoint;
>> -    struct v4l2_async_subdev asd;
>> -
>>       struct v4l2_fh        fh;
>>       struct cal_dev        *dev;
>>       struct cc_data        *cc;
>> @@ -2032,7 +2030,6 @@ static int of_cal_create_instance(struct cal_ctx *ctx, int inst)
>>       parent = pdev->dev.of_node;
>> -    asd = &ctx->asd;
>>       endpoint = &ctx->endpoint;
>>       ep_node = NULL;
>> @@ -2040,6 +2037,10 @@ static int of_cal_create_instance(struct cal_ctx *ctx, int inst)
>>       sensor_node = NULL;
>>       ret = -EINVAL;
>> +    asd = kzalloc(sizeof(*asd), GFP_KERNEL);
>> +    if (!asd)
>> +        goto cleanup_exit;
>> +
>>       ctx_dbg(3, ctx, "Scanning Port node for csi2 port: %d\n", inst);
>>       for (index = 0; index < CAL_NUM_CSI2_PORTS; index++) {
>>           port = of_get_next_port(parent, port);
>>
> 
> Thanks, this fixes the crash for me.
> 
> It does look a bit odd that something is allocated with kzalloc, and then it's freed somewhere 
> inside v4l2_async_notifier_cleanup, though. But if that's how it supposed to be used, looks fine to me.

Well, sent that a few seconds too early... With this patch, I see kmemleaks.

  Tomi

-- 
Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki.
Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
