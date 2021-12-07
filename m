Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA6D246AEE9
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 01:17:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351259AbhLGAU5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 19:20:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235581AbhLGAU5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 19:20:57 -0500
Received: from perceval.ideasonboard.com (perceval.ideasonboard.com [IPv6:2001:4b98:dc2:55:216:3eff:fef7:d647])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00C05C061746;
        Mon,  6 Dec 2021 16:17:28 -0800 (PST)
Received: from pendragon.ideasonboard.com (62-78-145-57.bb.dnainternet.fi [62.78.145.57])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 8D487556;
        Tue,  7 Dec 2021 01:17:26 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1638836246;
        bh=eI4Z7k9xrHhkGPdVR0Kgp/80a7c9xwnzxKmLdSuIv8E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vq+tIzuiV7MPt4Jugq873VhMOTGg/hs6AxasahMWGDm+NPbkh5qk4KqcNjMsKMnCZ
         CHhmAr1PYAWacdH8vsE6AcaZBPOG7ADxMEVXMk/hP0/QXKMWiAdX96OtMN2BNXj/5u
         BQB7vt7BGVYN+X+rvz24D4tNbjSuhyIldCa+nagA=
Date:   Tue, 7 Dec 2021 02:16:58 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Ricardo Ribalda <ricardo.ribalda@gmail.com>
Cc:     Nicolas Dufresne <nicolas@ndufresne.ca>,
        ": Ricardo Ribalda" <ribalda@chromium.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        tfiga@chromium.org, stable <stable@vger.kernel.org>
Subject: Re: [PATCH 3/3] media: uvcvideo: Set unique entity name based in type
Message-ID: <Ya6n+ke9eqnUuPq2@pendragon.ideasonboard.com>
References: <20211207000629.4985-1-ribalda@chromium.org>
 <20211207000629.4985-4-ribalda@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211207000629.4985-4-ribalda@chromium.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Ricardo,

Thank you for the patch.

On Tue, Dec 07, 2021 at 01:06:29AM +0100, Ricardo Ribalda wrote:
> All the entities must have a unique name. We can have a descriptive and
> unique name by appending the function to their terminal link.
> 
> This is even resilient to multi chain devices.
> 
> Fixes v4l2-compliance:
> Media Controller ioctls:
>    fail: v4l2-test-media.cpp(205): v2_entity_names_set.find(key) != v2_entity_names_set.end()
>      test MEDIA_IOC_G_TOPOLOGY: FAIL
>      fail: v4l2-test-media.cpp(394): num_data_links != num_links
>    test MEDIA_IOC_ENUM_ENTITIES/LINKS: FAIL
> 
> Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
> ---
>  drivers/media/usb/uvc/uvc_driver.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
> index 058d28a0344b..3700e61a8701 100644
> --- a/drivers/media/usb/uvc/uvc_driver.c
> +++ b/drivers/media/usb/uvc/uvc_driver.c
> @@ -2194,6 +2194,7 @@ int uvc_register_video_device(struct uvc_device *dev,
>  			      const struct v4l2_ioctl_ops *ioctl_ops)
>  {
>  	int ret;
> +	const char *name;

Please swap those two lines.

>  
>  	/* Initialize the video buffers queue. */
>  	ret = uvc_queue_init(queue, type, !uvc_no_drop_param);
> @@ -2221,17 +2222,29 @@ int uvc_register_video_device(struct uvc_device *dev,
>  	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
>  	default:
>  		vdev->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
> +		name = "Video Capture";
>  		break;
>  	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
>  		vdev->device_caps = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING;
> +		name = "Video Output";
>  		break;
>  	case V4L2_BUF_TYPE_META_CAPTURE:
>  		vdev->device_caps = V4L2_CAP_META_CAPTURE | V4L2_CAP_STREAMING;
> +		name = "Metadata";
>  		break;
>  	}
>  
> +	/*
> +	 * Many userspace apps identify the device with vdev->name, so we

s/apps/applications/

> +	 * cannot change its name for its function.
> +	 */
>  	strscpy(vdev->name, dev->name, sizeof(vdev->name));
>  
> +#if defined(CONFIG_MEDIA_CONTROLLER)
> +	vdev->entity.name = devm_kasprintf(&stream->intf->dev, GFP_KERNEL,
> +				"%s %u", name, stream->header.bTerminalLink);

Won't the compiler warn about a set but unused variable when
!CONFIG_MEDIA_CONTROLLER ?

> +#endif
> +
>  	/*
>  	 * Set the driver data before calling video_register_device, otherwise
>  	 * the file open() handler might race us.

-- 
Regards,

Laurent Pinchart
