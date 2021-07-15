Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31F5E3CA7E4
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242153AbhGOS4y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:56:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:33068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237890AbhGOS4X (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:56:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0BBAE613CF;
        Thu, 15 Jul 2021 18:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375209;
        bh=GmKKiOyw77r0CD+Z7TsMw8WnLS9v1jPTTdYpMxr1rCE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AwXwU9LvNrEzWWV7loInhwgrRQiR2SpPFl7hiUvwHr1LCeL5m+nMc3iBGDTVMbWkd
         ghnlebuzjLFynwKHdk0iihLwb3mwoEnE8hAVzKk3B9CQRHAuUaI5zSog/pzo+4hZ4a
         pPyyC+TG+zaudvPsaC3hsQg6a1OFFHTvuhyaaef4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Benjamin Drung <bdrung@posteo.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.10 207/215] media: uvcvideo: Fix pixel format change for Elgato Cam Link 4K
Date:   Thu, 15 Jul 2021 20:39:39 +0200
Message-Id: <20210715182635.739003762@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182558.381078833@linuxfoundation.org>
References: <20210715182558.381078833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Drung <bdrung@posteo.de>

commit 4c6e0976295add7f0ed94d276c04a3d6f1ea8f83 upstream.

The Elgato Cam Link 4K HDMI video capture card reports to support three
different pixel formats, where the first format depends on the connected
HDMI device.

```
$ v4l2-ctl -d /dev/video0 --list-formats-ext
ioctl: VIDIOC_ENUM_FMT
	Type: Video Capture

	[0]: 'NV12' (Y/CbCr 4:2:0)
		Size: Discrete 3840x2160
			Interval: Discrete 0.033s (29.970 fps)
	[1]: 'NV12' (Y/CbCr 4:2:0)
		Size: Discrete 3840x2160
			Interval: Discrete 0.033s (29.970 fps)
	[2]: 'YU12' (Planar YUV 4:2:0)
		Size: Discrete 3840x2160
			Interval: Discrete 0.033s (29.970 fps)
```

Changing the pixel format to anything besides the first pixel format
does not work:

```
$ v4l2-ctl -d /dev/video0 --try-fmt-video pixelformat=YU12
Format Video Capture:
	Width/Height      : 3840/2160
	Pixel Format      : 'NV12' (Y/CbCr 4:2:0)
	Field             : None
	Bytes per Line    : 3840
	Size Image        : 12441600
	Colorspace        : sRGB
	Transfer Function : Rec. 709
	YCbCr/HSV Encoding: Rec. 709
	Quantization      : Default (maps to Limited Range)
	Flags             :
```

User space applications like VLC might show an error message on the
terminal in that case:

```
libv4l2: error set_fmt gave us a different result than try_fmt!
```

Depending on the error handling of the user space applications, they
might display a distorted video, because they use the wrong pixel format
for decoding the stream.

The Elgato Cam Link 4K responds to the USB video probe
VS_PROBE_CONTROL/VS_COMMIT_CONTROL with a malformed data structure: The
second byte contains bFormatIndex (instead of being the second byte of
bmHint). The first byte is always zero. The third byte is always 1.

The firmware bug was reported to Elgato on 2020-12-01 and it was
forwarded by the support team to the developers as feature request.
There is no firmware update available since then. The latest firmware
for Elgato Cam Link 4K as of 2021-03-23 has MCU 20.02.19 and FPGA 67.

Therefore correct the malformed data structure for this device. The
change was successfully tested with VLC, OBS, and Chromium using
different pixel formats (YUYV, NV12, YU12), resolutions (3840x2160,
1920x1080), and frame rates (29.970 and 59.940 fps).

Cc: stable@vger.kernel.org
Signed-off-by: Benjamin Drung <bdrung@posteo.de>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/uvc/uvc_video.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -124,10 +124,37 @@ int uvc_query_ctrl(struct uvc_device *de
 static void uvc_fixup_video_ctrl(struct uvc_streaming *stream,
 	struct uvc_streaming_control *ctrl)
 {
+	static const struct usb_device_id elgato_cam_link_4k = {
+		USB_DEVICE(0x0fd9, 0x0066)
+	};
 	struct uvc_format *format = NULL;
 	struct uvc_frame *frame = NULL;
 	unsigned int i;
 
+	/*
+	 * The response of the Elgato Cam Link 4K is incorrect: The second byte
+	 * contains bFormatIndex (instead of being the second byte of bmHint).
+	 * The first byte is always zero. The third byte is always 1.
+	 *
+	 * The UVC 1.5 class specification defines the first five bits in the
+	 * bmHint bitfield. The remaining bits are reserved and should be zero.
+	 * Therefore a valid bmHint will be less than 32.
+	 *
+	 * Latest Elgato Cam Link 4K firmware as of 2021-03-23 needs this fix.
+	 * MCU: 20.02.19, FPGA: 67
+	 */
+	if (usb_match_one_id(stream->dev->intf, &elgato_cam_link_4k) &&
+	    ctrl->bmHint > 255) {
+		u8 corrected_format_index = ctrl->bmHint >> 8;
+
+		/* uvc_dbg(stream->dev, VIDEO,
+			"Correct USB video probe response from {bmHint: 0x%04x, bFormatIndex: %u} to {bmHint: 0x%04x, bFormatIndex: %u}\n",
+			ctrl->bmHint, ctrl->bFormatIndex,
+			1, corrected_format_index); */
+		ctrl->bmHint = 1;
+		ctrl->bFormatIndex = corrected_format_index;
+	}
+
 	for (i = 0; i < stream->nformats; ++i) {
 		if (stream->format[i].index == ctrl->bFormatIndex) {
 			format = &stream->format[i];


