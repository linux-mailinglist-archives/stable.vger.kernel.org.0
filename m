Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5AFA14080B
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 11:35:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbgAQKfq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jan 2020 05:35:46 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:38732 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbgAQKfq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jan 2020 05:35:46 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: dafna)
        with ESMTPSA id 7EA6D294794
Subject: Re: [PATCH v3] media: v4l2-core: fix a use-after-free bug of
 sd->devnode
To:     Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc:     dafna3@gmail.com, helen.koike@collabora.com,
        ezequiel@collabora.com, stable@vger.kernel.org
References: <20191120122217.845-1-dafna.hirschfeld@collabora.com>
 <fe36e4a9-2369-3150-b823-97fb4bf1afe4@xs4all.nl>
From:   Dafna Hirschfeld <dafna.hirschfeld@collabora.com>
Message-ID: <d0505bd7-920e-d0f2-3aa2-440f27e7c08f@collabora.com>
Date:   Fri, 17 Jan 2020 12:35:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <fe36e4a9-2369-3150-b823-97fb4bf1afe4@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

On 16.01.20 13:57, Hans Verkuil wrote:
> On 11/20/19 1:22 PM, Dafna Hirschfeld wrote:
>> sd->devnode is released after calling
>> v4l2_subdev_release. Therefore it should be set
>> to NULL so that the subdev won't hold a pointer
>> to a released object. This fixes a reference
>> after free bug in function
>> v4l2_device_unregister_subdev
>>
>> Cc: stable@vger.kernel.org
>> Fixes: 0e43734d4c46e ("media: v4l2-subdev: add release() internal op")
>> Signed-off-by: Dafna Hirschfeld <dafna.hirschfeld@collabora.com>
>> Reviewed-by: Ezequiel Garcia <ezequiel@collabora.com>
>> ---
>> changes since v2:
>> - since this is a regresion fix, I added Fixes and Cc to stable tags,
>> - change the commit title and log to be more clear.
>>
>>   drivers/media/v4l2-core/v4l2-device.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/media/v4l2-core/v4l2-device.c b/drivers/media/v4l2-core/v4l2-device.c
>> index 63d6b147b21e..2b3595671d62 100644
>> --- a/drivers/media/v4l2-core/v4l2-device.c
>> +++ b/drivers/media/v4l2-core/v4l2-device.c
>> @@ -177,6 +177,7 @@ static void v4l2_subdev_release(struct v4l2_subdev *sd)
>>   {
>>   	struct module *owner = !sd->owner_v4l2_dev ? sd->owner : NULL;
>>   
>> +	sd->devnode = NULL;
>>   	if (sd->internal_ops && sd->internal_ops->release)
>>   		sd->internal_ops->release(sd);
> 
> I'd move the sd->devnode = NULL; line here. That way the
> sd->internal_ops->release(sd) callback can still use it.
> 
> Unless I am missing something?
It makes sense although none of the drivers uses this callback since
the subdevice should be released in the v4l2_device's release so it 
seems that this callback can (should?) be removed.

Dafna

> 
>>   	module_put(owner);
>>
> 
> Regards,
> 
> 	Hans
> 
