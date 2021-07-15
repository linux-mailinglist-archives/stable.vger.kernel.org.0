Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE6883CA4DC
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236840AbhGOSDH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:03:07 -0400
Received: from mout01.posteo.de ([185.67.36.65]:38393 "EHLO mout01.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236602AbhGOSDH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:03:07 -0400
Received: from submission (posteo.de [89.146.220.130]) 
        by mout01.posteo.de (Postfix) with ESMTPS id D250F240026
        for <stable@vger.kernel.org>; Thu, 15 Jul 2021 20:00:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.de; s=2017;
        t=1626372011; bh=GjN/abBN6XPuhZKZVaPGIFc9B9QSBfkhexupHXCrm0I=;
        h=Subject:From:To:Cc:Date:From;
        b=VS7idcmGAIrg4Z1CVEfei9+pcrU7BKeW5OyKYccQU3qvUeLWVPsnAMKrjqTczlxNf
         nSjccrulOAaisPo1fUk9gfzNy8ckiAIqDY1yiYRld4IITBWeKv5SGcvKmS8Jk2NkUL
         ip3BPRDtvuZt/H0cXUDB7TpS6qQvYWWUgUHmnK75fU+fkxnxqj//7ndDUreZ4WZzIE
         N87wCyCeEecQeJgXd8RDloD9Oek6L2ui2+ghWkcjDqFEyoVvKCayvAgFhXNRBPZm8f
         NNHDBUL0VdqjAokWPacqugajU4zwHLbuE1fLaXSkPR5p+herux8V60Ndim63ql/vZa
         2Au+hNSzvaNZw==
Received: from customer (localhost [127.0.0.1])
        by submission (posteo.de) with ESMTPSA id 4GQhwp6nySz9rxH;
        Thu, 15 Jul 2021 20:00:10 +0200 (CEST)
Message-ID: <ac6d3619747828306abaa2bede5dabb760a91ec0.camel@posteo.de>
Subject: Re: Patch "media: uvcvideo: Fix pixel format change for Elgato Cam
 Link 4K" has been added to the 5.10-stable tree
From:   Benjamin Drung <bdrung@posteo.de>
To:     gregkh@linuxfoundation.org, laurent.pinchart@ideasonboard.com,
        mchehab+huawei@kernel.org
Cc:     stable@vger.kernel.org
Date:   Thu, 15 Jul 2021 18:00:10 +0000
In-Reply-To: <162636023254123@kroah.com>
References: <162636023254123@kroah.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

thanks for applying/staging the commit for the stable release. For
kernel <= 5.11 the patch needs a small modification for the debug log.
See below. Should I send an adapted patch to stable@vger.kernel.org to
replace this one?

On Thu, 2021-07-15 at 16:43 +0200, gregkh@linuxfoundation.org wrote:
> This is a note to let you know that I've just added the patch titled
> 
>     media: uvcvideo: Fix pixel format change for Elgato Cam Link 4K
> 
> to the 5.10-stable tree which can be found at:
>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> 
> The filename of the patch is:
>      media-uvcvideo-fix-pixel-format-change-for-elgato-cam-link-4k.patch
> and it can be found in the queue-5.10 subdirectory.
> 
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.
> 
> 
> From 4c6e0976295add7f0ed94d276c04a3d6f1ea8f83 Mon Sep 17 00:00:00 2001
> From: Benjamin Drung <bdrung@posteo.de>
> Date: Sat, 5 Jun 2021 22:15:36 +0200
> Subject: media: uvcvideo: Fix pixel format change for Elgato Cam Link 4K
> 
> From: Benjamin Drung <bdrung@posteo.de>
> 
> commit 4c6e0976295add7f0ed94d276c04a3d6f1ea8f83 upstream.
> 
> The Elgato Cam Link 4K HDMI video capture card reports to support three
> different pixel formats, where the first format depends on the connected
> HDMI device.
> 
> ```
> $ v4l2-ctl -d /dev/video0 --list-formats-ext
> ioctl: VIDIOC_ENUM_FMT
> 	Type: Video Capture
> 
> 	[0]: 'NV12' (Y/CbCr 4:2:0)
> 		Size: Discrete 3840x2160
> 			Interval: Discrete 0.033s (29.970 fps)
> 	[1]: 'NV12' (Y/CbCr 4:2:0)
> 		Size: Discrete 3840x2160
> 			Interval: Discrete 0.033s (29.970 fps)
> 	[2]: 'YU12' (Planar YUV 4:2:0)
> 		Size: Discrete 3840x2160
> 			Interval: Discrete 0.033s (29.970 fps)
> ```
> 
> Changing the pixel format to anything besides the first pixel format
> does not work:
> 
> ```
> $ v4l2-ctl -d /dev/video0 --try-fmt-video pixelformat=YU12
> Format Video Capture:
> 	Width/Height      : 3840/2160
> 	Pixel Format      : 'NV12' (Y/CbCr 4:2:0)
> 	Field             : None
> 	Bytes per Line    : 3840
> 	Size Image        : 12441600
> 	Colorspace        : sRGB
> 	Transfer Function : Rec. 709
> 	YCbCr/HSV Encoding: Rec. 709
> 	Quantization      : Default (maps to Limited Range)
> 	Flags             :
> ```
> 
> User space applications like VLC might show an error message on the
> terminal in that case:
> 
> ```
> libv4l2: error set_fmt gave us a different result than try_fmt!
> ```
> 
> Depending on the error handling of the user space applications, they
> might display a distorted video, because they use the wrong pixel format
> for decoding the stream.
> 
> The Elgato Cam Link 4K responds to the USB video probe
> VS_PROBE_CONTROL/VS_COMMIT_CONTROL with a malformed data structure: The
> second byte contains bFormatIndex (instead of being the second byte of
> bmHint). The first byte is always zero. The third byte is always 1.
> 
> The firmware bug was reported to Elgato on 2020-12-01 and it was
> forwarded by the support team to the developers as feature request.
> There is no firmware update available since then. The latest firmware
> for Elgato Cam Link 4K as of 2021-03-23 has MCU 20.02.19 and FPGA 67.
> 
> Therefore correct the malformed data structure for this device. The
> change was successfully tested with VLC, OBS, and Chromium using
> different pixel formats (YUYV, NV12, YU12), resolutions (3840x2160,
> 1920x1080), and frame rates (29.970 and 59.940 fps).
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Benjamin Drung <bdrung@posteo.de>
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/media/usb/uvc/uvc_video.c |   27 +++++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
> 
> --- a/drivers/media/usb/uvc/uvc_video.c
> +++ b/drivers/media/usb/uvc/uvc_video.c
> @@ -124,10 +124,37 @@ int uvc_query_ctrl(struct uvc_device *de
>  static void uvc_fixup_video_ctrl(struct uvc_streaming *stream,
>  	struct uvc_streaming_control *ctrl)
>  {
> +	static const struct usb_device_id elgato_cam_link_4k = {
> +		USB_DEVICE(0x0fd9, 0x0066)
> +	};
>  	struct uvc_format *format = NULL;
>  	struct uvc_frame *frame = NULL;
>  	unsigned int i;
>  
> +	/*
> +	 * The response of the Elgato Cam Link 4K is incorrect: The second byte
> +	 * contains bFormatIndex (instead of being the second byte of bmHint).
> +	 * The first byte is always zero. The third byte is always 1.
> +	 *
> +	 * The UVC 1.5 class specification defines the first five bits in the
> +	 * bmHint bitfield. The remaining bits are reserved and should be zero.
> +	 * Therefore a valid bmHint will be less than 32.
> +	 *
> +	 * Latest Elgato Cam Link 4K firmware as of 2021-03-23 needs this fix.
> +	 * MCU: 20.02.19, FPGA: 67
> +	 */
> +	if (usb_match_one_id(stream->dev->intf, &elgato_cam_link_4k) &&
> +	    ctrl->bmHint > 255) {
> +		u8 corrected_format_index = ctrl->bmHint >> 8;
> +
> +		/* uvc_dbg(stream->dev, VIDEO,

Instead of commenting out the debug log, this line needs to be replaced by:

    uvc_trace(UVC_TRACE_VIDEO,

> +			"Correct USB video probe response from {bmHint: 0x%04x, bFormatIndex: %u} to {bmHint: 0x%04x, bFormatIndex: %u}\n",
> +			ctrl->bmHint, ctrl->bFormatIndex,
> +			1, corrected_format_index); */
> +		ctrl->bmHint = 1;
> +		ctrl->bFormatIndex = corrected_format_index;
> +	}
> +
>  	for (i = 0; i < stream->nformats; ++i) {
>  		if (stream->format[i].index == ctrl->bFormatIndex) {
>  			format = &stream->format[i];
> 
> 
> Patches currently in stable-queue which might be from bdrung@posteo.de are
> 
> queue-5.10/media-uvcvideo-fix-pixel-format-change-for-elgato-cam-link-4k.patch


