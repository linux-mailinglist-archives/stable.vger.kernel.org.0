Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9C6839CB54
	for <lists+stable@lfdr.de>; Sat,  5 Jun 2021 23:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbhFEVxi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Jun 2021 17:53:38 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:49358 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbhFEVxi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Jun 2021 17:53:38 -0400
Received: from pendragon.ideasonboard.com (62-78-145-57.bb.dnainternet.fi [62.78.145.57])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id CCE3AB2C;
        Sat,  5 Jun 2021 23:51:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1622929908;
        bh=7AtEhbgjMTIMOimdkjZ2AGo1wum4rpBo0faBCoWgOMc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZrhB/7EjrPafzxl9YIlJE4DrE4zm0MH7qxjNSKF0+k0I38fuoUZKbkpXujOxGjbPp
         IdObz59ZqmF398woMVium2ZbYdbC20aDYp5tJSpHTpp8LQkV+Qkxq4Mon5/676afJZ
         1r+M/BBktPYiHU+c1k5ecjdguDEdzqmG8+wOMu1M=
Date:   Sun, 6 Jun 2021 00:51:34 +0300
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Benjamin Drung <bdrung@posteo.de>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Adam Goode <agoode@google.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] media: uvcvideo: Fix pixel format change for Elgato
 Cam Link 4K
Message-ID: <YLvx5qjoUhVIZ5UK@pendragon.ideasonboard.com>
References: <CAOf41NnKMks8UgM+4Z5ymNtBnioPzsTE-1fh1ERMEcFfX=UoMg@mail.gmail.com>
 <20210604171941.66136-1-bdrung@posteo.de>
 <YLqnU+FYSAcWwaAZ@pendragon.ideasonboard.com>
 <9219fc970e41188db748643bb0efe6bcbef53168.camel@posteo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9219fc970e41188db748643bb0efe6bcbef53168.camel@posteo.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Benjamin,

On Sat, Jun 05, 2021 at 08:19:56AM +0000, Benjamin Drung wrote:
> Am Samstag, den 05.06.2021, 01:21 +0300 schrieb Laurent Pinchart:
> > On Fri, Jun 04, 2021 at 05:19:42PM +0000, Benjamin Drung wrote:
> > > The Elgato Cam Link 4K HDMI video capture card reports to support three
> > > different pixel formats, where the first format depends on the connected
> > > HDMI device.
> > > 
> > > ```
> > > $ v4l2-ctl -d /dev/video0 --list-formats-ext
> > > ioctl: VIDIOC_ENUM_FMT
> > > 	Type: Video Capture
> > > 
> > > 	[0]: 'NV12' (Y/CbCr 4:2:0)
> > > 		Size: Discrete 3840x2160
> > > 			Interval: Discrete 0.033s (29.970 fps)
> > > 	[1]: 'NV12' (Y/CbCr 4:2:0)
> > > 		Size: Discrete 3840x2160
> > > 			Interval: Discrete 0.033s (29.970 fps)
> > > 	[2]: 'YU12' (Planar YUV 4:2:0)
> > > 		Size: Discrete 3840x2160
> > > 			Interval: Discrete 0.033s (29.970 fps)
> > > ```
> > > 
> > > Changing the pixel format to anything besides the first pixel format
> > > does not work:
> > > 
> > > ```
> > > $ v4l2-ctl -d /dev/video0 --try-fmt-video pixelformat=YU12
> > > Format Video Capture:
> > > 	Width/Height      : 3840/2160
> > > 	Pixel Format      : 'NV12' (Y/CbCr 4:2:0)
> > > 	Field             : None
> > > 	Bytes per Line    : 3840
> > > 	Size Image        : 12441600
> > > 	Colorspace        : sRGB
> > > 	Transfer Function : Rec. 709
> > > 	YCbCr/HSV Encoding: Rec. 709
> > > 	Quantization      : Default (maps to Limited Range)
> > > 	Flags             :
> > > ```
> > > 
> > > User space applications like VLC might show an error message on the
> > > terminal in that case:
> > > 
> > > ```
> > > libv4l2: error set_fmt gave us a different result than try_fmt!
> > > ```
> > > 
> > > Depending on the error handling of the user space applications, they
> > > might display a distorted video, because they use the wrong pixel format
> > > for decoding the stream.
> > > 
> > > The Elgato Cam Link 4K responds to the USB video probe
> > > VS_PROBE_CONTROL/VS_COMMIT_CONTROL with a malformed data structure: The
> > > second byte contains bFormatIndex (instead of being the second byte of
> > > bmHint). The first byte is always zero. The third byte is always 1.
> > > 
> > > The firmware bug was reported to Elgato on 2020-12-01 and it was
> > > forwarded by the support team to the developers as feature request.
> > > There is no firmware update available since then. The latest firmware
> > > for Elgato Cam Link 4K as of 2021-03-23 has MCU 20.02.19 and FPGA 67.
> > 
> > *sigh* :-( Same vendors are depressingly unable to perform even the most
> > basic conformance testing.
> > 
> > Thanks for all this analysis and bug reports.
> > 
> > > Therefore add a quirk to correct the malformed data structure.
> > > 
> > > The quirk was successfully tested with VLC, OBS, and Chromium using
> > > different pixel formats (YUYV, NV12, YU12), resolutions (3840x2160,
> > > 1920x1080), and frame rates (29.970 and 59.940 fps).
> > > 
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Benjamin Drung <bdrung@posteo.de>
> > > ---
> > > 
> > > I am sending this patch a fourth time since I got no response and the
> > > last resend is over a month ago. This time I am including Linus Torvalds
> > > in the hope to get it reviewed.
> > 
> > The resend got to the top of my mailbox and I had time to review it
> > before it got burried again. Thanks for not giving up.
> 
> Thanks for reviewing the patch.

I'll try not to be that late for v3/v4 :-)

> > >  drivers/media/usb/uvc/uvc_driver.c | 13 +++++++++++++
> > >  drivers/media/usb/uvc/uvc_video.c  | 21 +++++++++++++++++++++
> > >  drivers/media/usb/uvc/uvcvideo.h   |  1 +
> > >  3 files changed, 35 insertions(+)
> > > 
> > > diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
> > > index 9a791d8ef200..6ce58950d78b 100644
> > > --- a/drivers/media/usb/uvc/uvc_driver.c
> > > +++ b/drivers/media/usb/uvc/uvc_driver.c
> > > @@ -3164,6 +3164,19 @@ static const struct usb_device_id uvc_ids[] = {
> > >  	  .bInterfaceSubClass	= 1,
> > >  	  .bInterfaceProtocol	= 0,
> > >  	  .driver_info		= UVC_INFO_META(V4L2_META_FMT_D4XX) },
> > > +	/*
> > > +	 * Elgato Cam Link 4K
> > > +	 * Latest firmware as of 2021-03-23 needs this quirk.
> > > +	 * MCU: 20.02.19, FPGA: 67
> > > +	 */
> > > +	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
> > > +				| USB_DEVICE_ID_MATCH_INT_INFO,
> > > +	  .idVendor		= 0x0fd9,
> > > +	  .idProduct		= 0x0066,
> > > +	  .bInterfaceClass	= USB_CLASS_VIDEO,
> > > +	  .bInterfaceSubClass	= 1,
> > > +	  .bInterfaceProtocol	= 0,
> > > +	  .driver_info		= UVC_INFO_QUIRK(UVC_QUIRK_FIX_FORMAT_INDEX) },
> > >  	/* Generic USB Video Class */
> > >  	{ USB_INTERFACE_INFO(USB_CLASS_VIDEO, 1, UVC_PC_PROTOCOL_UNDEFINED) },
> > >  	{ USB_INTERFACE_INFO(USB_CLASS_VIDEO, 1, UVC_PC_PROTOCOL_15) },
> > > diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
> > > index a777b389a66e..910d22233d74 100644
> > > --- a/drivers/media/usb/uvc/uvc_video.c
> > > +++ b/drivers/media/usb/uvc/uvc_video.c
> > > @@ -131,6 +131,27 @@ static void uvc_fixup_video_ctrl(struct uvc_streaming *stream,
> > >  	struct uvc_frame *frame = NULL;
> > >  	unsigned int i;
> > >  
> > > 
> > > +	/*
> > > +	 * The response of the Elgato Cam Link 4K is incorrect: The second byte
> > > +	 * contains bFormatIndex (instead of being the second byte of bmHint).
> > > +	 * The first byte is always zero. The third byte is always 1.
> > > +	 *
> > > +	 * The UVC 1.5 class specification defines the first five bits in the
> > > +	 * bmHint bitfield. The remaining bits are reserved and should be zero.
> > > +	 * Therefore a valid bmHint will be less than 32.
> > > +	 */
> > > +	if (stream->dev->quirks & UVC_QUIRK_FIX_FORMAT_INDEX && ctrl->bmHint > 255) {
> > 
> > Given that this is likely not going to affect other devices (at least in
> > the same way), I'd rather test the USB VID:PID that add a quirk.
> > Something along the lines of
> > 
> > 	if (usb_match_one_id(stream->dev->intf, USB_DEVICE(0x0fd9, 0x0066)) {
> 
> Adam Goode suggested that the Game Capture HD 60 S+ (0fd9:006a) from the
> same vendor is probably affected by the same bug. I cannot test this
> assumption since I don't have this device (I am open for a loaner
> device). An Internet search did not reveal bug reports in this regard.
> Most search results referred to older versions (e.g. without + or
> without S+) Do you still prefer to test the USB VID:PID?

What bothers me a bit with a quirk is that it's supposed to be a generic
mechanism for bugs that affect a wide variety of devices. We could have
a small array of device match entries as in uvc_ctrl_prune_entity() if
you don't expect more than a handful of devices to be affected.
Otherwise, if you think a quirk is better, let's go for that, but let's
then name it with the vendor name (UVC_QUIRK_ELGATE_VIDEO_CONTROL or
similar).

> > > +		__u8 corrected_format_index;
> > > +
> > > +		corrected_format_index = ctrl->bmHint >> 8;
> > > +		uvc_dbg(stream->dev, CONTROL,
> > > +			"Correct USB video probe response from {bmHint: 0x%04x, bFormatIndex: 0x%02x} to {bmHint: 0x%04x, bFormatIndex: 0x%02x}.\n",
> > > +			ctrl->bmHint, ctrl->bFormatIndex,
> > > +			ctrl->bFormatIndex, corrected_format_index);
> > > +		ctrl->bmHint = ctrl->bFormatIndex;
> > 
> > According to your description above, this will always be 1. Is the third
> > byte always 1 because the driver always sets bmHint to 1, or would it
> > have a different value if we set bmHint to something else ? In the first
> > case I'd hardcode ctrl->bmHint to 1 here.
> 
> I will test setting bmHint to something else than 1 to check. I will
> report back then. Either follow your sugstion or update the comment.

Thanks.

> > > +		ctrl->bFormatIndex = corrected_format_index;
> > > +	}
> > > +
> > >  	for (i = 0; i < stream->nformats; ++i) {
> > >  		if (stream->format[i].index == ctrl->bFormatIndex) {
> > >  			format = &stream->format[i];
> > > diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
> > > index cce5e38133cd..cbb4ef61a64d 100644
> > > --- a/drivers/media/usb/uvc/uvcvideo.h
> > > +++ b/drivers/media/usb/uvc/uvcvideo.h
> > > @@ -209,6 +209,7 @@
> > >  #define UVC_QUIRK_RESTORE_CTRLS_ON_INIT	0x00000400
> > >  #define UVC_QUIRK_FORCE_Y8		0x00000800
> > >  #define UVC_QUIRK_FORCE_BPP		0x00001000
> > > +#define UVC_QUIRK_FIX_FORMAT_INDEX	0x00002000
> > >  
> > >  /* Format flags */
> > >  #define UVC_FMT_FLAG_COMPRESSED		0x00000001

-- 
Regards,

Laurent Pinchart
