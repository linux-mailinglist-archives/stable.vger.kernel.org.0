Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 030BB170153
	for <lists+stable@lfdr.de>; Wed, 26 Feb 2020 15:37:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727471AbgBZOh3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Feb 2020 09:37:29 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:53602 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727322AbgBZOh3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Feb 2020 09:37:29 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: dafna)
        with ESMTPSA id AB61F29258C
Subject: Re: [PATCH v4] media: v4l2-core: fix a use-after-free bug of
 sd->devnode
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, dafna3@gmail.com, helen.koike@collabora.com,
        ezequiel@collabora.com, stable@vger.kernel.org,
        kernel@collabora.com
References: <20200219152554.25222-1-dafna.hirschfeld@collabora.com>
From:   Dafna Hirschfeld <dafna.hirschfeld@collabora.com>
Message-ID: <47ac13b7-6709-3f2a-4fb9-b0fc178959f3@collabora.com>
Date:   Wed, 26 Feb 2020 15:37:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200219152554.25222-1-dafna.hirschfeld@collabora.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,
When a subdevice is registered with
v4l2_async_register_subdev_sensor_common and the main driver is
unloaded and reloaded, it does not register a node for the subdevice
since the devonde is not set to null.
in v4l2_device_register_subdev_nodes the sd is skipped if sd->devnode.

This patch solves this issue as well.

Dafna

On 19.02.20 16:25, Dafna Hirschfeld wrote:
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
> changes since v3:
> move the sd->devnode = NULL; line below the call to the release cb
> so that it can still use it.
> 
>   drivers/media/v4l2-core/v4l2-device.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-device.c b/drivers/media/v4l2-core/v4l2-device.c
> index 63d6b147b21e..41da73ce2e98 100644
> --- a/drivers/media/v4l2-core/v4l2-device.c
> +++ b/drivers/media/v4l2-core/v4l2-device.c
> @@ -179,6 +179,7 @@ static void v4l2_subdev_release(struct v4l2_subdev *sd)
>   
>   	if (sd->internal_ops && sd->internal_ops->release)
>   		sd->internal_ops->release(sd);
> +	sd->devnode = NULL;
>   	module_put(owner);
>   }
>   
> 
