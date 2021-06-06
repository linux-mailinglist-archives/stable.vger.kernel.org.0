Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4F6C39D177
	for <lists+stable@lfdr.de>; Sun,  6 Jun 2021 22:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbhFFUgW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Jun 2021 16:36:22 -0400
Received: from mout01.posteo.de ([185.67.36.65]:41851 "EHLO mout01.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229813AbhFFUgW (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Jun 2021 16:36:22 -0400
Received: from submission (posteo.de [89.146.220.130]) 
        by mout01.posteo.de (Postfix) with ESMTPS id 97332240028
        for <stable@vger.kernel.org>; Sun,  6 Jun 2021 22:34:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.de; s=2017;
        t=1623011670; bh=C/RaIsJDIHq50Q0MALj/LW+4LIGZ7A5/NXiFqaw97V4=;
        h=Subject:From:To:Cc:Date:From;
        b=rx8FblmPxICJyHYFQkXlP0rtNrYxIfvopv+7OdqHcozR8lZkxypWee0/2FjRqiNzw
         2alkta6XbDHTQ2Laq5faQyrAzq8sbo2H61P65T2vPKnYiE7/1EveO3r/tw9AniXr8r
         WSj8Yt2GnSba82QQx8yleZ1uo/rogd1hSgq2OvFB8JAB5xyf7IimlkGTpi+J6kdNIs
         x8YiaVFUzskJf85j704iURnRpo2PktmZhD5hW2Bpx68dswRLm9sWYaiAfLCQ39A/jw
         72AWkMGBV6fMJKzqXpYGaKgHLwVvZknsQ1HbYZd6syZE6Za4boSeSdKSo/+lXwfPwI
         FQbod/EAqIdmw==
Received: from customer (localhost [127.0.0.1])
        by submission (posteo.de) with ESMTPSA id 4FypBs6Hxrz6tmJ;
        Sun,  6 Jun 2021 22:34:29 +0200 (CEST)
Message-ID: <bf6f506e908699a07e74d22bdbc37e1d381e66e7.camel@posteo.de>
Subject: Re: [PATCH v5] media: uvcvideo: Fix pixel format change for Elgato
 Cam Link 4K
From:   Benjamin Drung <bdrung@posteo.de>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc:     Adam Goode <agoode@google.com>, stable@vger.kernel.org
Date:   Sun, 06 Jun 2021 20:34:29 +0000
In-Reply-To: <20210606030928.9739-1-laurent.pinchart@ideasonboard.com>
References: <20210606030928.9739-1-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 2021-06-06 at 06:09 +0300, Laurent Pinchart wrote:
> From: Benjamin Drung <bdrung@posteo.de>
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
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
> Benjamin, could you double-check the adjustments ? I've also updated the
> commit messages to not mention a quirk anymore.

They are perfect! You also updated the source code comment to not
mention a quirk any more. :)

> ---
>  drivers/media/usb/uvc/uvc_video.c | 27 +++++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
> 
> diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
> index a777b389a66e..e16464606b14 100644
> --- a/drivers/media/usb/uvc/uvc_video.c
> +++ b/drivers/media/usb/uvc/uvc_video.c
> @@ -127,10 +127,37 @@ int uvc_query_ctrl(struct uvc_device *dev, u8 query, u8 unit,
>  static void uvc_fixup_video_ctrl(struct uvc_streaming *stream,
>  	struct uvc_streaming_control *ctrl)
>  {
> +	static const struct usb_device_id elgato_cam_link_4k = {
> +		USB_DEVICE(0x0fd9, 0x0066)
> +	};
>  	struct uvc_format *format = NULL;
>  	struct uvc_frame *frame = NULL;
>  	unsigned int i;
>  
> 
> 
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
> +		uvc_dbg(stream->dev, VIDEO,
> +			"Correct USB video probe response from {bmHint: 0x%04x, bFormatIndex: %u} to {bmHint: 0x%04x, bFormatIndex: %u}\n",
> +			ctrl->bmHint, ctrl->bFormatIndex,
> +			1, corrected_format_index);
> +		ctrl->bmHint = 1;
> +		ctrl->bFormatIndex = corrected_format_index;
> +	}
> +
>  	for (i = 0; i < stream->nformats; ++i) {
>  		if (stream->format[i].index == ctrl->bFormatIndex) {
>  			format = &stream->format[i];


