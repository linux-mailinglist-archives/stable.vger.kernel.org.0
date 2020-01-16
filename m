Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3988A13D96B
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 12:57:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbgAPL5f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 06:57:35 -0500
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:33719 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726045AbgAPL5f (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jan 2020 06:57:35 -0500
Received: from [IPv6:2001:420:44c1:2577:1825:cb8:c622:6168]
 ([IPv6:2001:420:44c1:2577:1825:cb8:c622:6168])
        by smtp-cloud8.xs4all.net with ESMTPA
        id s3mEiVv1mpLtbs3mHippvi; Thu, 16 Jan 2020 12:57:33 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=xs4all.nl; s=s1;
        t=1579175853; bh=CO/vUaixcPthghITm2hsK1W4fZfENwAkzYapTVaIFkk=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type:From:
         Subject;
        b=oZ8LtWeazwlNeMSVA4OACnMQloHi2ZAzYUaQ/jdr/inW0JgtX50oCMVMZUwr6s1+W
         S2iGk3oTRZ08LKqaT1i4AV3MgFzKU01VmD/XTF40GRZWJzlIW7cAcOKMIgsyQ56dtu
         zNC716BfxPdE0E0OQhqNkasnm/7RDa6M39PNr51T+NSjpAQKjKjQeU8L3NnrYaO045
         c/3YpcNvIR6qwX9XImExqV1O5BqpIWNiAO4gk/hL9ZI9mFJjRGK5wPGP2nUaQ2vnjb
         w9RfPyMIjmFOOooMs0YGHdUTGSvQmBqUjNkbsId3APFMZUgprqxUpzNkCyoUFMXlz2
         B8HW2o1eObBZA==
Subject: Re: [PATCH v3] media: v4l2-core: fix a use-after-free bug of
 sd->devnode
To:     Dafna Hirschfeld <dafna.hirschfeld@collabora.com>,
        linux-media@vger.kernel.org
Cc:     dafna3@gmail.com, helen.koike@collabora.com,
        ezequiel@collabora.com, stable@vger.kernel.org
References: <20191120122217.845-1-dafna.hirschfeld@collabora.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <fe36e4a9-2369-3150-b823-97fb4bf1afe4@xs4all.nl>
Date:   Thu, 16 Jan 2020 12:57:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191120122217.845-1-dafna.hirschfeld@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfCKdpuTRcA4kmDyGfoE+W77lomGJ0lNiB/ZRxbC+hXyospYPJ8hI90siBENddxnfJ3XLFb1/aos6rnIbkpG60We7jdc1TgEt0zegrSBTNzeoCkNIYwFF
 6zrE0zL+MQHFIRqI2ZVIdHV2l9KlCf+uXWWYwxh6LnhXmCyi8wnCqOMzF5TJre3obgsDquDM/ijEDChP6dMn6zvssItANOSxozGCvGtAov4c0rD+8Air9D79
 Y+8fRepNp4cvt2Q596AeXGUh1SmA9SH9fZ7DCdlRfaW6knLo1Ja7cAWGxeZ632Z/ph/c6keuJsldw8+oVLispppSxR0z7AoX04RAJLriF134Pl1+sYh367yL
 4uovmjDdPHzPWHMmdeNACStaTFIUNL/WJH/sIYn3OjrvGgIh4cC3RAOBip43DXBpaG6chEeNA/efSlaaluUzuoVgwx8waa5y/gxH5mSCs/s6/k/jpGM=
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/20/19 1:22 PM, Dafna Hirschfeld wrote:
> sd->devnode is released after calling
> v4l2_subdev_release. Therefore it should be set
> to NULL so that the subdev won't hold a pointer
> to a released object. This fixes a reference
> after free bug in function
> v4l2_device_unregister_subdev
> 
> Cc: stable@vger.kernel.org
> Fixes: 0e43734d4c46e ("media: v4l2-subdev: add release() internal op")
> Signed-off-by: Dafna Hirschfeld <dafna.hirschfeld@collabora.com>
> Reviewed-by: Ezequiel Garcia <ezequiel@collabora.com>
> ---
> changes since v2:
> - since this is a regresion fix, I added Fixes and Cc to stable tags,
> - change the commit title and log to be more clear.
> 
>  drivers/media/v4l2-core/v4l2-device.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-device.c b/drivers/media/v4l2-core/v4l2-device.c
> index 63d6b147b21e..2b3595671d62 100644
> --- a/drivers/media/v4l2-core/v4l2-device.c
> +++ b/drivers/media/v4l2-core/v4l2-device.c
> @@ -177,6 +177,7 @@ static void v4l2_subdev_release(struct v4l2_subdev *sd)
>  {
>  	struct module *owner = !sd->owner_v4l2_dev ? sd->owner : NULL;
>  
> +	sd->devnode = NULL;
>  	if (sd->internal_ops && sd->internal_ops->release)
>  		sd->internal_ops->release(sd);

I'd move the sd->devnode = NULL; line here. That way the
sd->internal_ops->release(sd) callback can still use it.

Unless I am missing something?

>  	module_put(owner);
> 

Regards,

	Hans
