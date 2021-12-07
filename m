Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3B6F46AEDD
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 01:14:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353942AbhLGASA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 19:18:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240481AbhLGAR7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 19:17:59 -0500
Received: from perceval.ideasonboard.com (perceval.ideasonboard.com [IPv6:2001:4b98:dc2:55:216:3eff:fef7:d647])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CF1DC061746;
        Mon,  6 Dec 2021 16:14:30 -0800 (PST)
Received: from pendragon.ideasonboard.com (62-78-145-57.bb.dnainternet.fi [62.78.145.57])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 19364556;
        Tue,  7 Dec 2021 01:14:28 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1638836068;
        bh=UTKU4Q9SUW59qL6kwwzJOZJh1Zs1HmmZV7DL1kTWXuY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i5CwiztIFgk69yaT1Zl8iSWO95qKnJC41mRu/+YLcr/cMPvwSjFWOuxExWNnoxNxp
         PDnY/wbqZ72hVx20N4GA54S2B1sSpzZLz9gRyiHOTgfoesxa6EJkFzPnxDsb4m9gt2
         3h8eBp9HJCp/4jsRsEEcTId0AIOUPZkz7H1i3h8g=
Date:   Tue, 7 Dec 2021 02:14:00 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Ricardo Ribalda <ricardo.ribalda@gmail.com>
Cc:     Nicolas Dufresne <nicolas@ndufresne.ca>,
        ": Ricardo Ribalda" <ribalda@chromium.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        tfiga@chromium.org, stable <stable@vger.kernel.org>
Subject: Re: [PATCH 1/3] Revert "media: uvcvideo: Set unique vdev name based
 in type"
Message-ID: <Ya6nSOVasXsMGrkc@pendragon.ideasonboard.com>
References: <20211207000629.4985-1-ribalda@chromium.org>
 <20211207000629.4985-2-ribalda@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211207000629.4985-2-ribalda@chromium.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Ricardo,

Thank you for the patch.

On Tue, Dec 07, 2021 at 01:06:27AM +0100, Ricardo Ribalda wrote:
> A lot of userspace depends on a descriptive name for vdev. Without this
> patch, users have a hard time figuring out which camera shall they use
> for their video conferencing.
> 
> This reverts commit e3f60e7e1a2b451f538f9926763432249bcf39c4.
> 
> Cc: <stable@vger.kernel.org>
> Fixes: e3f60e7e1a2b ("media: uvcvideo: Set unique vdev name based in type")
> Reported-by: Nicolas Dufresne <nicolas@ndufresne.ca>
> Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/usb/uvc/uvc_driver.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
> index 7c007426e082..058d28a0344b 100644
> --- a/drivers/media/usb/uvc/uvc_driver.c
> +++ b/drivers/media/usb/uvc/uvc_driver.c
> @@ -2193,7 +2193,6 @@ int uvc_register_video_device(struct uvc_device *dev,
>  			      const struct v4l2_file_operations *fops,
>  			      const struct v4l2_ioctl_ops *ioctl_ops)
>  {
> -	const char *name;
>  	int ret;
>  
>  	/* Initialize the video buffers queue. */
> @@ -2222,20 +2221,16 @@ int uvc_register_video_device(struct uvc_device *dev,
>  	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
>  	default:
>  		vdev->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
> -		name = "Video Capture";
>  		break;
>  	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
>  		vdev->device_caps = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING;
> -		name = "Video Output";
>  		break;
>  	case V4L2_BUF_TYPE_META_CAPTURE:
>  		vdev->device_caps = V4L2_CAP_META_CAPTURE | V4L2_CAP_STREAMING;
> -		name = "Metadata";
>  		break;
>  	}
>  
> -	snprintf(vdev->name, sizeof(vdev->name), "%s %u", name,
> -		 stream->header.bTerminalLink);
> +	strscpy(vdev->name, dev->name, sizeof(vdev->name));
>  
>  	/*
>  	 * Set the driver data before calling video_register_device, otherwise

-- 
Regards,

Laurent Pinchart
