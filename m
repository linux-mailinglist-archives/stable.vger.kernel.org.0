Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCD4239CB8F
	for <lists+stable@lfdr.de>; Sun,  6 Jun 2021 00:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbhFEXAu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Jun 2021 19:00:50 -0400
Received: from mout01.posteo.de ([185.67.36.65]:35137 "EHLO mout01.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230029AbhFEXAu (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 5 Jun 2021 19:00:50 -0400
Received: from submission (posteo.de [89.146.220.130]) 
        by mout01.posteo.de (Postfix) with ESMTPS id DBB01240026
        for <stable@vger.kernel.org>; Sun,  6 Jun 2021 00:58:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.de; s=2017;
        t=1622933937; bh=nPGY2VcDEnZ+t+bGcuIh6wvTeAHTfrpR6gz4oJQz/XA=;
        h=Subject:From:To:Cc:Date:From;
        b=n2PHIMbdtzA+oAMoQnFJmNh/dJIJI16VHPWCe/CbbfDnBY3pBiv227YjQ6aDpRMOk
         drg6B6TgZ64Ia/mUxlO3sJffZDHNCVbY2M1LDfUETnzOrEEYNx0bw4EM/5E6JyrGfZ
         6sFanXq9lZCaW+T8KO046Ll7p2t1rk0XElGFGravB09D+6JQ6XKhwX8LK31/4eaAZJ
         FkSXWU9AGUaqRaHC2Wvd89wzY+aKoQvYzmJug9yG+Yk26oWHBg+INu/Wf0C3lCwBCM
         ZYt7W0mkAskIpza3TzMpzWBhKOfDiRvaYZSSFYyOI+e+n/QeDZbjNH2YLLzwtS2eUm
         S28F7aTWgqJLA==
Received: from customer (localhost [127.0.0.1])
        by submission (posteo.de) with ESMTPSA id 4FyFS118dqz9rxB;
        Sun,  6 Jun 2021 00:58:57 +0200 (CEST)
Message-ID: <c891893c80a0f0d30b464427fe1ee904d95df99e.camel@posteo.de>
Subject: Re: [PATCH v4] media: uvcvideo: Fix pixel format change for Elgato
 Cam Link 4K
From:   Benjamin Drung <bdrung@posteo.de>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Adam Goode <agoode@google.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Date:   Sat, 05 Jun 2021 22:58:56 +0000
In-Reply-To: <YLvy9iE2Z+DpMvmg@pendragon.ideasonboard.com>
References: <YLqnU+FYSAcWwaAZ@pendragon.ideasonboard.com>
         <20210605201534.53114-1-bdrung@posteo.de>
         <YLvy9iE2Z+DpMvmg@pendragon.ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am Sonntag, den 06.06.2021, 00:56 +0300 schrieb Laurent Pinchart:
> Hi Benjamin,
> 
> Thank you for the patch.
> 
> On Sat, Jun 05, 2021 at 08:15:36PM +0000, Benjamin Drung wrote:
> > The Elgato Cam Link 4K HDMI video capture card reports to support three
> > different pixel formats, where the first format depends on the connected
> > HDMI device.
> > 
> > ```
> > $ v4l2-ctl -d /dev/video0 --list-formats-ext
> > ioctl: VIDIOC_ENUM_FMT
> > 	Type: Video Capture
> > 
> > 	[0]: 'NV12' (Y/CbCr 4:2:0)
> > 		Size: Discrete 3840x2160
> > 			Interval: Discrete 0.033s (29.970 fps)
> > 	[1]: 'NV12' (Y/CbCr 4:2:0)
> > 		Size: Discrete 3840x2160
> > 			Interval: Discrete 0.033s (29.970 fps)
> > 	[2]: 'YU12' (Planar YUV 4:2:0)
> > 		Size: Discrete 3840x2160
> > 			Interval: Discrete 0.033s (29.970 fps)
> > ```
> > 
> > Changing the pixel format to anything besides the first pixel format
> > does not work:
> > 
> > ```
> > $ v4l2-ctl -d /dev/video0 --try-fmt-video pixelformat=YU12
> > Format Video Capture:
> > 	Width/Height      : 3840/2160
> > 	Pixel Format      : 'NV12' (Y/CbCr 4:2:0)
> > 	Field             : None
> > 	Bytes per Line    : 3840
> > 	Size Image        : 12441600
> > 	Colorspace        : sRGB
> > 	Transfer Function : Rec. 709
> > 	YCbCr/HSV Encoding: Rec. 709
> > 	Quantization      : Default (maps to Limited Range)
> > 	Flags             :
> > ```
> > 
> > User space applications like VLC might show an error message on the
> > terminal in that case:
> > 
> > ```
> > libv4l2: error set_fmt gave us a different result than try_fmt!
> > ```
> > 
> > Depending on the error handling of the user space applications, they
> > might display a distorted video, because they use the wrong pixel format
> > for decoding the stream.
> > 
> > The Elgato Cam Link 4K responds to the USB video probe
> > VS_PROBE_CONTROL/VS_COMMIT_CONTROL with a malformed data structure: The
> > second byte contains bFormatIndex (instead of being the second byte of
> > bmHint). The first byte is always zero. The third byte is always 1.
> > 
> > The firmware bug was reported to Elgato on 2020-12-01 and it was
> > forwarded by the support team to the developers as feature request.
> > There is no firmware update available since then. The latest firmware
> > for Elgato Cam Link 4K as of 2021-03-23 has MCU 20.02.19 and FPGA 67.
> > 
> > Therefore add a quirk to correct the malformed data structure.
> > 
> > The quirk was successfully tested with VLC, OBS, and Chromium using
> > different pixel formats (YUYV, NV12, YU12), resolutions (3840x2160,
> > 1920x1080), and frame rates (29.970 and 59.940 fps).
> > 
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Benjamin Drung <bdrung@posteo.de>
> > ---
> >  drivers/media/usb/uvc/uvc_video.c | 25 +++++++++++++++++++++++++
> >  1 file changed, 25 insertions(+)
> > 
> > (now sending this patch with v4 in the subject instead of falsely v3)
> > 
> > v2: enhanced the comment describing the quirk
> > 
> > v3:
> > * hardcode ctrl->bmHint to 1
> > * Use UVC_DBG_VIDEO instead of UVC_DBG_CONTROL (to match the rest of the
> >   file)
> > 
> > v4:
> > * Replace quirk bit by specific check for USB VID:PID test
> > 
> > I tried setting different values for bmHint, but the response from the
> > Cam Link was always 1. So this patch hardcodes ctrl->bmHint to 1 as
> > suggested.
> > 
> > Patch version 4 implements the recommendation of Laurent Pinchart. It
> > requires defining the device ID as variable since usb_match_one_id takes
> > an pointer to it. In case more Elgato products like Game Capture
> > HD 60 S+ (0fd9:006a) are affected, this version is harder to extent.
> > 
> > Take patch version 3 or 4 depending on which version you prefer. Both
> > work and are tested.
> > 
> > diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
> > index a777b389a66e..35c3ce0e0716 100644
> > --- a/drivers/media/usb/uvc/uvc_video.c
> > +++ b/drivers/media/usb/uvc/uvc_video.c
> > @@ -130,6 +130,31 @@ static void uvc_fixup_video_ctrl(struct uvc_streaming *stream,
> >  	struct uvc_format *format = NULL;
> >  	struct uvc_frame *frame = NULL;
> >  	unsigned int i;
> > +	static const struct usb_device_id elgato_cam_link_4k = { USB_DEVICE(0x0fd9, 0x0066) };
> 
> Let's avoid long line
> 
> 	static const struct usb_device_id elgato_cam_link_4k = {
> 		USB_DEVICE(0x0fd9, 0x0066)
> 	};

Yes. That's better readable.

> > +
> > +	/*
> > +	 * The response of the Elgato Cam Link 4K is incorrect: The second byte
> > +	 * contains bFormatIndex (instead of being the second byte of bmHint).
> > +	 * The first byte is always zero. The third byte is always 1.
> > +	 *
> > +	 * The UVC 1.5 class specification defines the first five bits in the
> > +	 * bmHint bitfield. The remaining bits are reserved and should be zero.
> > +	 * Therefore a valid bmHint will be less than 32.
> > +	 *
> > +	 * Latest Elgato Cam Link 4K firmware as of 2021-03-23 needs this quirk.
> > +	 * MCU: 20.02.19, FPGA: 67
> > +	 */
> > +	if (usb_match_one_id(stream->dev->intf, &elgato_cam_link_4k) && ctrl->bmHint > 255) {
> 
> Similarly, I'd break this as
> 
> 	if (usb_match_one_id(stream->dev->intf, &elgato_cam_link_4k) &&
> 	    ctrl->bmHint > 255) {

Agreed.

> > +		__u8 corrected_format_index;
> 
> You can use u8 within the kernel.

Good to know. I can't remember why I used __u8 instead.

> > +
> > +		corrected_format_index = ctrl->bmHint >> 8;
> > +		uvc_dbg(stream->dev, VIDEO,
> > +			"Correct USB video probe response from {bmHint: 0x%04x, bFormatIndex: 0x%02x} to {bmHint: 0x%04x, bFormatIndex: 0x%02x}.\n",
> 
> I'd print bFormatIndex with %u as it's an index and thus more readable
> as a decimal integer.

So print bmHint as hex and bFormatIndex as integer? That would change
the log from e.g.

uvcvideo: Correct USB video probe response from {bmHint: 0x0300, bFormatIndex: 0x01} to {bmHint: 0x0001, bFormatIndex: 0x03}.

to

uvcvideo: Correct USB video probe response from {bmHint: 0x0300, bFormatIndex: 1} to {bmHint: 0x0001, bFormatIndex: 3}.

That would be fine for me as well (since bFormatIndex is only one byte).

> If you agree with those small changes, there's no need to resubmit, I
> can fold them in when applying the patch.

I agree. Thanks for reviewing it.

> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> > +			ctrl->bmHint, ctrl->bFormatIndex,
> > +			1, corrected_format_index);
> > +		ctrl->bmHint = 1;
> > +		ctrl->bFormatIndex = corrected_format_index;
> > +	}
> >  
> > 
> >  	for (i = 0; i < stream->nformats; ++i) {
> >  		if (stream->format[i].index == ctrl->bFormatIndex) {
> 


