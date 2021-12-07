Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B034746AEEC
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 01:18:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351478AbhLGAWK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 19:22:10 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:44594 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235581AbhLGAWK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 19:22:10 -0500
Received: from pendragon.ideasonboard.com (62-78-145-57.bb.dnainternet.fi [62.78.145.57])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 86915556;
        Tue,  7 Dec 2021 01:18:39 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1638836319;
        bh=tflvrrDOoN1tBhmIJ33ljPH2DMjARriGjUn1Ah69U14=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qjXalC194NbV5ihWRQw+CvBr4lBEgS/LzjXscwHiVsw6FJa92aesPgnu/tjEGMhT7
         fcGKVP8K9X0bqQ6tZdDOzL/CPjJj5PvPjEmzmHzRzZWYqLZPlko8KidhUexLcHpGG9
         1ggK5w3uvCF5xFC75zfLYG7w6VAr6qbFbmD22JT8=
Date:   Tue, 7 Dec 2021 02:18:11 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Ricardo Ribalda <ricardo.ribalda@gmail.com>,
        Nicolas Dufresne <nicolas@ndufresne.ca>,
        Ricardo Ribalda <ribalda@chromium.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        tfiga@chromium.org, stable <stable@vger.kernel.org>
Subject: Re: [PATCH 1/3] Revert "media: uvcvideo: Set unique vdev name based
 in type"
Message-ID: <Ya6oQ9EOVKwkaLal@pendragon.ideasonboard.com>
References: <20211207000629.4985-1-ribalda@chromium.org>
 <20211207000629.4985-2-ribalda@chromium.org>
 <Ya6nSOVasXsMGrkc@pendragon.ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Ya6nSOVasXsMGrkc@pendragon.ideasonboard.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 07, 2021 at 02:14:01AM +0200, Laurent Pinchart wrote:
> Hi Ricardo,
> 
> Thank you for the patch.
> 
> On Tue, Dec 07, 2021 at 01:06:27AM +0100, Ricardo Ribalda wrote:
> > A lot of userspace depends on a descriptive name for vdev. Without this
> > patch, users have a hard time figuring out which camera shall they use
> > for their video conferencing.
> > 
> > This reverts commit e3f60e7e1a2b451f538f9926763432249bcf39c4.
> > 
> > Cc: <stable@vger.kernel.org>
> > Fixes: e3f60e7e1a2b ("media: uvcvideo: Set unique vdev name based in type")
> > Reported-by: Nicolas Dufresne <nicolas@ndufresne.ca>
> > Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
> 
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Mauro, is it possible to queue this as a fix for v5.16 ?

> > ---
> >  drivers/media/usb/uvc/uvc_driver.c | 7 +------
> >  1 file changed, 1 insertion(+), 6 deletions(-)
> > 
> > diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
> > index 7c007426e082..058d28a0344b 100644
> > --- a/drivers/media/usb/uvc/uvc_driver.c
> > +++ b/drivers/media/usb/uvc/uvc_driver.c
> > @@ -2193,7 +2193,6 @@ int uvc_register_video_device(struct uvc_device *dev,
> >  			      const struct v4l2_file_operations *fops,
> >  			      const struct v4l2_ioctl_ops *ioctl_ops)
> >  {
> > -	const char *name;
> >  	int ret;
> >  
> >  	/* Initialize the video buffers queue. */
> > @@ -2222,20 +2221,16 @@ int uvc_register_video_device(struct uvc_device *dev,
> >  	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
> >  	default:
> >  		vdev->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
> > -		name = "Video Capture";
> >  		break;
> >  	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
> >  		vdev->device_caps = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING;
> > -		name = "Video Output";
> >  		break;
> >  	case V4L2_BUF_TYPE_META_CAPTURE:
> >  		vdev->device_caps = V4L2_CAP_META_CAPTURE | V4L2_CAP_STREAMING;
> > -		name = "Metadata";
> >  		break;
> >  	}
> >  
> > -	snprintf(vdev->name, sizeof(vdev->name), "%s %u", name,
> > -		 stream->header.bTerminalLink);
> > +	strscpy(vdev->name, dev->name, sizeof(vdev->name));
> >  
> >  	/*
> >  	 * Set the driver data before calling video_register_device, otherwise

-- 
Regards,

Laurent Pinchart
