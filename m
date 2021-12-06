Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE57446A558
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 20:05:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237675AbhLFTIi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 14:08:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348222AbhLFTIi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 14:08:38 -0500
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AB4BC061354
        for <stable@vger.kernel.org>; Mon,  6 Dec 2021 11:05:09 -0800 (PST)
Received: by mail-qv1-xf2d.google.com with SMTP id p3so10798563qvj.9
        for <stable@vger.kernel.org>; Mon, 06 Dec 2021 11:05:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ndufresne-ca.20210112.gappssmtp.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=Bc6SGKQNlMFh9taK81eaVOm8+Noh1ocBxGN8bqECuqk=;
        b=tSTX6CVKOlJcxtnIXzTwvjih4g9VupPHqBfCCpeawQ1csVcTqeSor0FqXaDLcOVoto
         SkDMTCTaROpRgpmx6SLtt7xtyKRW+AAF16z6QuNpHpJH1NwOQJBhp5rjlYa5jTPp3xkR
         Lv737niiytUuvSFQILx0sDCVkNSvEOpHo+KmX8y3N1AaLFQ5YEmJdBBw7vbpZHFYDvks
         H4VrREJ78AsSpJoOQiX9JCzgz+Zv4lBHzR6bGFa5Z2iCW3wWgOzPs4bAodPyEZ3x68+m
         LyoRRaxFTXJqV9uZcUdnYXYgn83ZNvB4r8zV6K3quKdCfV6zuFw57GMo9RGwpudOb+Ob
         Vncw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Bc6SGKQNlMFh9taK81eaVOm8+Noh1ocBxGN8bqECuqk=;
        b=kvTvU/wx7KjvJKwWTSUBiz2Ssu59Y7eV/XlaF0PVOSR2qXDnmzD2F0ATNum73i7kzF
         esyS3LK9PKVKrNMBgq9KyDlHV5csiwjo1rHOosobYejZp6UzIlD98MVxSo/sGLEED6X+
         hZIjz2rNdWaQNyEMpP0h5BaNwotVMl/45l4h+7Mu+o7DHFlVGElR3/o4yT5MhJS+LGz0
         6zb4vEVinyFmrNdOR5AErNUsAQUaBZfNVR5WOAmGMgM3ZlqR974ioU/sT44namW26MsB
         uowWe8PL+YDI5go1GFWnlKw8VHDG/hdNroPF76JRpoy0uXwn7fLjq7BEm2tc7wPvEWvt
         zv0Q==
X-Gm-Message-State: AOAM531M9p5cG2B/3gfqa6Zmp19+fn4h53yrfSKS2p34TQFQew42YSiR
        YF4wW2Fa5ZW8w2+v/flUO0naZg==
X-Google-Smtp-Source: ABdhPJyzfE7VvZ03mSWFEoCHvAWa5ou1h9E4HstNlAcV0HyPMH1PrFVEgBSZun35WQhcbrUSoBqAoA==
X-Received: by 2002:a05:6214:c47:: with SMTP id r7mr39609317qvj.51.1638817508236;
        Mon, 06 Dec 2021 11:05:08 -0800 (PST)
Received: from nicolas-tpx395.localdomain (mtl.collabora.ca. [66.171.169.34])
        by smtp.gmail.com with ESMTPSA id d19sm8064502qtb.47.2021.12.06.11.05.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 11:05:07 -0800 (PST)
Message-ID: <b4bfa8b8f3d8f25c48a3b0b81a0e87dc90f111af.camel@ndufresne.ca>
Subject: [REGRESSION] Re: [PATCH v10 11/21] media: uvcvideo: Set unique vdev
 name based in type
From:   Nicolas Dufresne <nicolas@ndufresne.ca>
To:     Ricardo Ribalda <ribalda@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        tfiga@chromium.org
Cc:     linux-kernel@vger.kernel.org, stable <stable@vger.kernel.org>
Date:   Mon, 06 Dec 2021 14:05:06 -0500
In-Reply-To: <20210618122923.385938-12-ribalda@chromium.org>
References: <20210618122923.385938-1-ribalda@chromium.org>
         <20210618122923.385938-12-ribalda@chromium.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.1 (3.42.1-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Ricard, 

Le vendredi 18 juin 2021 à 14:29 +0200, Ricardo Ribalda a écrit :
> All the entities must have a unique name. We can have a descriptive and
> unique name by appending the function and the entity->id.

Thanks for your work. The only issue is that unfortunately this change cause an
important regression for users. All UVC cameras in all UIs seems to no longer
include any information about the camera. As an example, I have two cameras on
my system and Firefox, Chrome, Cheese, Zoom and MS Team all agree that my camera
are now:

  Video Capture 4
  Video Capture 5

Previously they would be shown as something like:

  StreamCam
  Integrated

We should probably revert this change quickly before it get deployed more
widely, I have notice the backport being sent for 5.4, 5.10 and 5.14. I'm using
5.15 shipped by Fedora team.

As a proper solution, maybe I could suggest to keep using dev->name, but trim it
enough to fit the " N" string to guaranty that you have enough space in this
limited 32 char string and use that instead ? This should fit the uniqueness
requirement without the sacrifice of the only possibly useful information we had
in that limited string.

regards,
Nicolas

> 
> This is even resilent to multi chain devices.
> 
> Fixes v4l2-compliance:
> Media Controller ioctls:
>                 fail: v4l2-test-media.cpp(205): v2_entity_names_set.find(key) != v2_entity_names_set.end()
>         test MEDIA_IOC_G_TOPOLOGY: FAIL
>                 fail: v4l2-test-media.cpp(394): num_data_links != num_links
> 	test MEDIA_IOC_ENUM_ENTITIES/LINKS: FAIL
> 
> Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Reviewed-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> ---
>  drivers/media/usb/uvc/uvc_driver.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
> index 14b60792ffab..037bf80d1100 100644
> --- a/drivers/media/usb/uvc/uvc_driver.c
> +++ b/drivers/media/usb/uvc/uvc_driver.c
> @@ -2194,6 +2194,7 @@ int uvc_register_video_device(struct uvc_device *dev,
>  			      const struct v4l2_file_operations *fops,
>  			      const struct v4l2_ioctl_ops *ioctl_ops)
>  {
> +	const char *name;
>  	int ret;
>  
>  	/* Initialize the video buffers queue. */
> @@ -2222,16 +2223,20 @@ int uvc_register_video_device(struct uvc_device *dev,
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
> -	strscpy(vdev->name, dev->name, sizeof(vdev->name));
> +	snprintf(vdev->name, sizeof(vdev->name), "%s %u", name,
> +		 stream->header.bTerminalLink);
>  
>  	/*
>  	 * Set the driver data before calling video_register_device, otherwise

