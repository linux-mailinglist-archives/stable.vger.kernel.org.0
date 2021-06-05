Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A70F39C6B8
	for <lists+stable@lfdr.de>; Sat,  5 Jun 2021 10:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbhFEIVs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Jun 2021 04:21:48 -0400
Received: from mout02.posteo.de ([185.67.36.66]:56359 "EHLO mout02.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229889AbhFEIVr (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 5 Jun 2021 04:21:47 -0400
Received: from submission (posteo.de [89.146.220.130]) 
        by mout02.posteo.de (Postfix) with ESMTPS id 66AD82400FF
        for <stable@vger.kernel.org>; Sat,  5 Jun 2021 10:19:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.de; s=2017;
        t=1622881198; bh=nu1BLvmZrqYaytmdrBBw9GMUEofsomb+aCdcUAocJiM=;
        h=Subject:From:To:Cc:Date:From;
        b=BUR/4qovOyi1sZXEVZWUF+1XIOBUoPHtHHs4d4/CiZ5+jGlwDc+iOv2q0MTVFyi2k
         p21cr1AWDgTURjymVL7RnWsiP44aPBxi/s+g1szahGQcl1jANsvzSzHFjgaoe8UZwj
         de7C4+hW7dRl2iNSV3jEWLFiZcP2CLQ+5hXAmu+5Cexj/XjspxCAtZ1brS9QgXS/+w
         bGLoY/Wqq0vLRTAvks2JCQ2GT4QNL6dcbC5/+DqxtBQYGtyPED7cF1kCLoOZpOFvIk
         sRv7U+a+9ApotKbFfSomMIHrIedSFLTubDtlbbZSOad3RbQEBJVVrB22SAJbHy8EgP
         Wu3M7tPmG67WA==
Received: from customer (localhost [127.0.0.1])
        by submission (posteo.de) with ESMTPSA id 4Fxsxn147nz6tmL;
        Sat,  5 Jun 2021 10:19:57 +0200 (CEST)
Message-ID: <9219fc970e41188db748643bb0efe6bcbef53168.camel@posteo.de>
Subject: Re: [PATCH v2] media: uvcvideo: Fix pixel format change for Elgato
 Cam Link 4K
From:   Benjamin Drung <bdrung@posteo.de>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Adam Goode <agoode@google.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Date:   Sat, 05 Jun 2021 08:19:56 +0000
In-Reply-To: <YLqnU+FYSAcWwaAZ@pendragon.ideasonboard.com>
References: <CAOf41NnKMks8UgM+4Z5ymNtBnioPzsTE-1fh1ERMEcFfX=UoMg@mail.gmail.com>
         <20210604171941.66136-1-bdrung@posteo.de>
         <YLqnU+FYSAcWwaAZ@pendragon.ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Laurent,

Am Samstag, den 05.06.2021, 01:21 +0300 schrieb Laurent Pinchart:
> Hi Benjamin,
> 
> Thank you for the patch.
> 
> On Fri, Jun 04, 2021 at 05:19:42PM +0000, Benjamin Drung wrote:
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
> 
> *sigh* :-( Same vendors are depressingly unable to perform even the most
> basic conformance testing.
> 
> Thanks for all this analysis and bug reports.
> 
> > Therefore add a quirk to correct the malformed data structure.
> > 
> > The quirk was successfully tested with VLC, OBS, and Chromium using
> > different pixel formats (YUYV, NV12, YU12), resolutions (3840x2160,
> > 1920x1080), and frame rates (29.970 and 59.940 fps).
> > 
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Benjamin Drung <bdrung@posteo.de>
> > ---
> > 
> > I am sending this patch a fourth time since I got no response and the
> > last resend is over a month ago. This time I am including Linus Torvalds
> > in the hope to get it reviewed.
> 
> The resend got to the top of my mailbox and I had time to review it
> before it got burried again. Thanks for not giving up.

Thanks for reviewing the patch.

> >  drivers/media/usb/uvc/uvc_driver.c | 13 +++++++++++++
> >  drivers/media/usb/uvc/uvc_video.c  | 21 +++++++++++++++++++++
> >  drivers/media/usb/uvc/uvcvideo.h   |  1 +
> >  3 files changed, 35 insertions(+)
> > 
> > diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
> > index 9a791d8ef200..6ce58950d78b 100644
> > --- a/drivers/media/usb/uvc/uvc_driver.c
> > +++ b/drivers/media/usb/uvc/uvc_driver.c
> > @@ -3164,6 +3164,19 @@ static const struct usb_device_id uvc_ids[] = {
> >  	  .bInterfaceSubClass	= 1,
> >  	  .bInterfaceProtocol	= 0,
> >  	  .driver_info		= UVC_INFO_META(V4L2_META_FMT_D4XX) },
> > +	/*
> > +	 * Elgato Cam Link 4K
> > +	 * Latest firmware as of 2021-03-23 needs this quirk.
> > +	 * MCU: 20.02.19, FPGA: 67
> > +	 */
> > +	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
> > +				| USB_DEVICE_ID_MATCH_INT_INFO,
> > +	  .idVendor		= 0x0fd9,
> > +	  .idProduct		= 0x0066,
> > +	  .bInterfaceClass	= USB_CLASS_VIDEO,
> > +	  .bInterfaceSubClass	= 1,
> > +	  .bInterfaceProtocol	= 0,
> > +	  .driver_info		= UVC_INFO_QUIRK(UVC_QUIRK_FIX_FORMAT_INDEX) },
> >  	/* Generic USB Video Class */
> >  	{ USB_INTERFACE_INFO(USB_CLASS_VIDEO, 1, UVC_PC_PROTOCOL_UNDEFINED) },
> >  	{ USB_INTERFACE_INFO(USB_CLASS_VIDEO, 1, UVC_PC_PROTOCOL_15) },
> > diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
> > index a777b389a66e..910d22233d74 100644
> > --- a/drivers/media/usb/uvc/uvc_video.c
> > +++ b/drivers/media/usb/uvc/uvc_video.c
> > @@ -131,6 +131,27 @@ static void uvc_fixup_video_ctrl(struct uvc_streaming *stream,
> >  	struct uvc_frame *frame = NULL;
> >  	unsigned int i;
> >  
> > 
> > +	/*
> > +	 * The response of the Elgato Cam Link 4K is incorrect: The second byte
> > +	 * contains bFormatIndex (instead of being the second byte of bmHint).
> > +	 * The first byte is always zero. The third byte is always 1.
> > +	 *
> > +	 * The UVC 1.5 class specification defines the first five bits in the
> > +	 * bmHint bitfield. The remaining bits are reserved and should be zero.
> > +	 * Therefore a valid bmHint will be less than 32.
> > +	 */
> > +	if (stream->dev->quirks & UVC_QUIRK_FIX_FORMAT_INDEX && ctrl->bmHint > 255) {
> 
> Given that this is likely not going to affect other devices (at least in
> the same way), I'd rather test the USB VID:PID that add a quirk.
> Something along the lines of
> 
> 	if (usb_match_one_id(stream->dev->intf, USB_DEVICE(0x0fd9, 0x0066)) {

Adam Goode suggested that the Game Capture HD 60 S+ (0fd9:006a) from the
same vendor is probably affected by the same bug. I cannot test this
assumption since I don't have this device (I am open for a loaner
device). An Internet search did not reveal bug reports in this regard.
Most search results referred to older versions (e.g. without + or
without S+) Do you still prefer to test the USB VID:PID?

> > +		__u8 corrected_format_index;
> > +
> > +		corrected_format_index = ctrl->bmHint >> 8;
> > +		uvc_dbg(stream->dev, CONTROL,
> > +			"Correct USB video probe response from {bmHint: 0x%04x, bFormatIndex: 0x%02x} to {bmHint: 0x%04x, bFormatIndex: 0x%02x}.\n",
> > +			ctrl->bmHint, ctrl->bFormatIndex,
> > +			ctrl->bFormatIndex, corrected_format_index);
> > +		ctrl->bmHint = ctrl->bFormatIndex;
> 
> According to your description above, this will always be 1. Is the third
> byte always 1 because the driver always sets bmHint to 1, or would it
> have a different value if we set bmHint to something else ? In the first
> case I'd hardcode ctrl->bmHint to 1 here.

I will test setting bmHint to something else than 1 to check. I will
report back then. Either follow your sugstion or update the comment.

> > +		ctrl->bFormatIndex = corrected_format_index;
> > +	}
> > +
> >  	for (i = 0; i < stream->nformats; ++i) {
> >  		if (stream->format[i].index == ctrl->bFormatIndex) {
> >  			format = &stream->format[i];
> > diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
> > index cce5e38133cd..cbb4ef61a64d 100644
> > --- a/drivers/media/usb/uvc/uvcvideo.h
> > +++ b/drivers/media/usb/uvc/uvcvideo.h
> > @@ -209,6 +209,7 @@
> >  #define UVC_QUIRK_RESTORE_CTRLS_ON_INIT	0x00000400
> >  #define UVC_QUIRK_FORCE_Y8		0x00000800
> >  #define UVC_QUIRK_FORCE_BPP		0x00001000
> > +#define UVC_QUIRK_FIX_FORMAT_INDEX	0x00002000
> >  
> > 
> >  /* Format flags */
> >  #define UVC_FMT_FLAG_COMPRESSED		0x00000001
> 


