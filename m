Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1A1846A575
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 20:16:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347593AbhLFTTu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 14:19:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243589AbhLFTTt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 14:19:49 -0500
Received: from perceval.ideasonboard.com (perceval.ideasonboard.com [IPv6:2001:4b98:dc2:55:216:3eff:fef7:d647])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4F43C061746;
        Mon,  6 Dec 2021 11:16:19 -0800 (PST)
Received: from pendragon.ideasonboard.com (62-78-145-57.bb.dnainternet.fi [62.78.145.57])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id AC23EEE;
        Mon,  6 Dec 2021 20:16:17 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1638818177;
        bh=zFdavL06ulBt0zjQ7jeYKdKdKljFjx0ZhG2E2ii+PXA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wBh8jXa753hMgT9b6/K+PVJpkzBq8qkAtu1hjEuzg1JN6hQ9DNIWPX7/WMianAta7
         p+bub5JrrQTtcINp2vfzGJO8q5sDjXHNCWLg8xf2HqcPw12e0M6gOyUako1DB5JB/X
         xjk1m+fgJVqB8YkfWmNvpaBiPMn9hfauO4DgoqKk=
Date:   Mon, 6 Dec 2021 21:15:50 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Nicolas Dufresne <nicolas@ndufresne.ca>
Cc:     Ricardo Ribalda <ribalda@chromium.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        tfiga@chromium.org, stable <stable@vger.kernel.org>
Subject: Re: [REGRESSION] Re: [PATCH v10 11/21] media: uvcvideo: Set unique
 vdev name based in type
Message-ID: <Ya5hZtwcfBU/19CU@pendragon.ideasonboard.com>
References: <20210618122923.385938-1-ribalda@chromium.org>
 <20210618122923.385938-12-ribalda@chromium.org>
 <b4bfa8b8f3d8f25c48a3b0b81a0e87dc90f111af.camel@ndufresne.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b4bfa8b8f3d8f25c48a3b0b81a0e87dc90f111af.camel@ndufresne.ca>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Nicolas,

On Mon, Dec 06, 2021 at 02:05:06PM -0500, Nicolas Dufresne wrote:
> Le vendredi 18 juin 2021 à 14:29 +0200, Ricardo Ribalda a écrit :
> > All the entities must have a unique name. We can have a descriptive and
> > unique name by appending the function and the entity->id.
> 
> Thanks for your work. The only issue is that unfortunately this change cause an
> important regression for users. All UVC cameras in all UIs seems to no longer
> include any information about the camera. As an example, I have two cameras on
> my system and Firefox, Chrome, Cheese, Zoom and MS Team all agree that my camera
> are now:
> 
>   Video Capture 4
>   Video Capture 5
> 
> Previously they would be shown as something like:
> 
>   StreamCam
>   Integrated
> 
> We should probably revert this change quickly before it get deployed more
> widely, I have notice the backport being sent for 5.4, 5.10 and 5.14. I'm using
> 5.15 shipped by Fedora team.

Ack.

> As a proper solution, maybe I could suggest to keep using dev->name, but trim it
> enough to fit the " N" string to guaranty that you have enough space in this
> limited 32 char string and use that instead ? This should fit the uniqueness
> requirement without the sacrifice of the only possibly useful information we had
> in that limited string.

That would polute the device name a bit, which isn't very nice for
users. I wonder if we could instead decouple the entity name from the
video device name.

> > This is even resilent to multi chain devices.
> > 
> > Fixes v4l2-compliance:
> > Media Controller ioctls:
> >                 fail: v4l2-test-media.cpp(205): v2_entity_names_set.find(key) != v2_entity_names_set.end()
> >         test MEDIA_IOC_G_TOPOLOGY: FAIL
> >                 fail: v4l2-test-media.cpp(394): num_data_links != num_links
> > 	test MEDIA_IOC_ENUM_ENTITIES/LINKS: FAIL
> > 
> > Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
> > Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > Reviewed-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> > ---
> >  drivers/media/usb/uvc/uvc_driver.c | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
> > index 14b60792ffab..037bf80d1100 100644
> > --- a/drivers/media/usb/uvc/uvc_driver.c
> > +++ b/drivers/media/usb/uvc/uvc_driver.c
> > @@ -2194,6 +2194,7 @@ int uvc_register_video_device(struct uvc_device *dev,
> >  			      const struct v4l2_file_operations *fops,
> >  			      const struct v4l2_ioctl_ops *ioctl_ops)
> >  {
> > +	const char *name;
> >  	int ret;
> >  
> >  	/* Initialize the video buffers queue. */
> > @@ -2222,16 +2223,20 @@ int uvc_register_video_device(struct uvc_device *dev,
> >  	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
> >  	default:
> >  		vdev->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
> > +		name = "Video Capture";
> >  		break;
> >  	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
> >  		vdev->device_caps = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING;
> > +		name = "Video Output";
> >  		break;
> >  	case V4L2_BUF_TYPE_META_CAPTURE:
> >  		vdev->device_caps = V4L2_CAP_META_CAPTURE | V4L2_CAP_STREAMING;
> > +		name = "Metadata";
> >  		break;
> >  	}
> >  
> > -	strscpy(vdev->name, dev->name, sizeof(vdev->name));
> > +	snprintf(vdev->name, sizeof(vdev->name), "%s %u", name,
> > +		 stream->header.bTerminalLink);
> >  
> >  	/*
> >  	 * Set the driver data before calling video_register_device, otherwise

-- 
Regards,

Laurent Pinchart
