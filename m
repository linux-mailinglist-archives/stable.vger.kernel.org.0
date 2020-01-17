Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6E21140837
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 11:46:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726409AbgAQKqt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jan 2020 05:46:49 -0500
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:51433 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726196AbgAQKqs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jan 2020 05:46:48 -0500
Received: from [IPv6:2001:420:44c1:2577:dfd:739b:f489:745b]
 ([IPv6:2001:420:44c1:2577:dfd:739b:f489:745b])
        by smtp-cloud9.xs4all.net with ESMTPA
        id sP9GiPN0sT6sRsP9JifuYB; Fri, 17 Jan 2020 11:46:46 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=xs4all.nl; s=s1;
        t=1579258006; bh=ezv2tbK5FmjFYrKlKjqCTGvgRep81EQ3iel13n64fpk=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type:From:
         Subject;
        b=u1YrR2/3OTj2GWJVQzwvBJ2quNOtpR0lzufg1MLd4GDU2ibNzklve/XdNX9kY4RTt
         mNk3KyCHgbY1CGAegLP1s3OU4gNc1lBXKRFR+pKup6Z8uEV/7UhTAADVm25v6vPi4e
         N1KkEKi4cNsTuvMcy52ri77DfyzdD3zBmDSoySNIpEz8FJ8nt7eOOO7+jZCqs128B0
         jlgpkMY0ceOaIHgkm/w1vsOICa/BUCk8ed5mFwpA5zU4bZdR0jtU2bl031uwDal0nt
         idVp3o5wog/5/jtAyVWmzxd0WdvnUObCfRb3/ZoH0uk4CO+OE0Td1PpVM66FLqeNom
         7TbLyHHgKvXGQ==
Subject: Re: [PATCH v3] media: v4l2-core: fix a use-after-free bug of
 sd->devnode
To:     Dafna Hirschfeld <dafna.hirschfeld@collabora.com>,
        linux-media@vger.kernel.org
Cc:     dafna3@gmail.com, helen.koike@collabora.com,
        ezequiel@collabora.com, stable@vger.kernel.org
References: <20191120122217.845-1-dafna.hirschfeld@collabora.com>
 <fe36e4a9-2369-3150-b823-97fb4bf1afe4@xs4all.nl>
 <d0505bd7-920e-d0f2-3aa2-440f27e7c08f@collabora.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <2cf9c519-14d8-1a1d-d1b8-aea428deee5a@xs4all.nl>
Date:   Fri, 17 Jan 2020 11:46:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <d0505bd7-920e-d0f2-3aa2-440f27e7c08f@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfN7yG5K/ifUMBERReEWF18sJggSToUmIMWjRUzcXmE9n0qqEJFbYRqePk4ox10qMlKrYrT8EmgoSSC/WZAEr0KvY2F+1FlMMynC516A561GiTk+ifOm+
 3tVIbfhWPisk8rLfxN7w6OgSBDfrEjzYSsUqpuyZCuzoG6r/NHSr2uiSu68RbP9wKz0thaKYZwiZ6WjQpLuefAiiTy35nuURt/OuakT3ILt4+nDq9s29WSGM
 2xaMSG0Ay/0loOc4HfKSOU/vTIz2ysr1gpaX2vI6Bu/ysRPgYwS+pT6B0oYpqY8KRJFYikqQ0amsDj2OLEP432YMbSgY7scjrreXrlh49EKfbnaJu6mgIyhi
 A94bV0z8AnnG7pr0PscnL5aXtgoQdyXxmpxhXhiez4wnyQJi1lbjcfrdhgFxM++4H4HEWMyrDsbyDzJA82vDodLa8Nh8BXH3Qz47Mmgj+ZM7KdrQBLg=
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/17/20 11:35 AM, Dafna Hirschfeld wrote:
> Hi
> 
> On 16.01.20 13:57, Hans Verkuil wrote:
>> On 11/20/19 1:22 PM, Dafna Hirschfeld wrote:
>>> sd->devnode is released after calling
>>> v4l2_subdev_release. Therefore it should be set
>>> to NULL so that the subdev won't hold a pointer
>>> to a released object. This fixes a reference
>>> after free bug in function
>>> v4l2_device_unregister_subdev
>>>
>>> Cc: stable@vger.kernel.org
>>> Fixes: 0e43734d4c46e ("media: v4l2-subdev: add release() internal op")
>>> Signed-off-by: Dafna Hirschfeld <dafna.hirschfeld@collabora.com>
>>> Reviewed-by: Ezequiel Garcia <ezequiel@collabora.com>
>>> ---
>>> changes since v2:
>>> - since this is a regresion fix, I added Fixes and Cc to stable tags,
>>> - change the commit title and log to be more clear.
>>>
>>>   drivers/media/v4l2-core/v4l2-device.c | 1 +
>>>   1 file changed, 1 insertion(+)
>>>
>>> diff --git a/drivers/media/v4l2-core/v4l2-device.c b/drivers/media/v4l2-core/v4l2-device.c
>>> index 63d6b147b21e..2b3595671d62 100644
>>> --- a/drivers/media/v4l2-core/v4l2-device.c
>>> +++ b/drivers/media/v4l2-core/v4l2-device.c
>>> @@ -177,6 +177,7 @@ static void v4l2_subdev_release(struct v4l2_subdev *sd)
>>>   {
>>>   	struct module *owner = !sd->owner_v4l2_dev ? sd->owner : NULL;
>>>   
>>> +	sd->devnode = NULL;
>>>   	if (sd->internal_ops && sd->internal_ops->release)
>>>   		sd->internal_ops->release(sd);
>>
>> I'd move the sd->devnode = NULL; line here. That way the
>> sd->internal_ops->release(sd) callback can still use it.
>>
>> Unless I am missing something?
> It makes sense although none of the drivers uses this callback since
> the subdevice should be released in the v4l2_device's release so it 
> seems that this callback can (should?) be removed.

If nobody uses it, then I agree that it is better to remove it.

Regards,

	Hans

> 
> Dafna
> 
>>
>>>   	module_put(owner);
>>>
>>
>> Regards,
>>
>> 	Hans
>>

