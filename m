Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD25036E1FA
	for <lists+stable@lfdr.de>; Thu, 29 Apr 2021 01:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbhD1XIH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Apr 2021 19:08:07 -0400
Received: from mout02.posteo.de ([185.67.36.66]:50175 "EHLO mout02.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229931AbhD1XIH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Apr 2021 19:08:07 -0400
Received: from submission (posteo.de [89.146.220.130]) 
        by mout02.posteo.de (Postfix) with ESMTPS id 0D6932400E5
        for <stable@vger.kernel.org>; Thu, 29 Apr 2021 01:07:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.de; s=2017;
        t=1619651240; bh=XI1aESVa2Wu/renRfpEbPhHM1YJ/jHSPO7TGIj1lnu0=;
        h=From:To:Cc:Subject:Date:From;
        b=p4AJoDCVxCuP4Ksa3YVh2s+lyhif6dq/Nyt3Cd8BVk+/QnEguTQvVqv+bhnN/SsKN
         JlepoB0o7iBVBoBuJJQD2xVms37EKt7CoH42w6/jHLIZFfMUdl0fkUxXeoZm8Wa720
         GFx7twE+xc+iKK2UL/Ew2d6EeS/gZgcGzdYGq96gsK5cDKSR3TUFw57BpNrfDGl23S
         vuXOWlC+TVXhAo1nKochO+DDMwFO4O5AKjCInlvXUnN86MxZFT2yZnERNn/k6JzzZj
         txeXKsRDFCRHXxNzJ6cn37mNvrXrlHTANW8rwOzqIVZXAl9EToxCQ0seQBEvhc5rX9
         INap4o7TYrdmQ==
Received: from customer (localhost [127.0.0.1])
        by submission (posteo.de) with ESMTPSA id 4FVvRB46z2z9rxH;
        Thu, 29 Apr 2021 01:07:18 +0200 (CEST)
From:   Benjamin Drung <bdrung@posteo.de>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Adam Goode <agoode@google.com>, Benjamin Drung <bdrung@posteo.de>,
        stable@vger.kernel.org
Subject: [PATCH v2] media: uvcvideo: Fix pixel format change for Elgato Cam Link 4K
Date:   Wed, 28 Apr 2021 23:03:59 +0000
Message-Id: <20210428230358.22756-1-bdrung@posteo.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
v4l2-ctl -d /dev/video0 --try-fmt-video pixelformat=YU12
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

Therefore add a quirk to correct the malformed data structure.

The quirk was successfully tested with VLC, OBS, and Chromium using
different pixel formats (YUYV, NV12, YU12), resolutions (3840x2160,
1920x1080), and frame rates (29.970 and 59.940 fps).

Cc: stable@vger.kernel.org
Signed-off-by: Benjamin Drung <bdrung@posteo.de>
---
 drivers/media/usb/uvc/uvc_driver.c | 13 +++++++++++++
 drivers/media/usb/uvc/uvc_video.c  | 21 +++++++++++++++++++++
 drivers/media/usb/uvc/uvcvideo.h   |  1 +
 3 files changed, 35 insertions(+)

I am resending this patch since I got no response in the last three
weeks.

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 9a791d8ef200..6ce58950d78b 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -3164,6 +3164,19 @@ static const struct usb_device_id uvc_ids[] = {
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
 	  .driver_info		= UVC_INFO_META(V4L2_META_FMT_D4XX) },
+	/*
+	 * Elgato Cam Link 4K
+	 * Latest firmware as of 2021-03-23 needs this quirk.
+	 * MCU: 20.02.19, FPGA: 67
+	 */
+	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
+				| USB_DEVICE_ID_MATCH_INT_INFO,
+	  .idVendor		= 0x0fd9,
+	  .idProduct		= 0x0066,
+	  .bInterfaceClass	= USB_CLASS_VIDEO,
+	  .bInterfaceSubClass	= 1,
+	  .bInterfaceProtocol	= 0,
+	  .driver_info		= UVC_INFO_QUIRK(UVC_QUIRK_FIX_FORMAT_INDEX) },
 	/* Generic USB Video Class */
 	{ USB_INTERFACE_INFO(USB_CLASS_VIDEO, 1, UVC_PC_PROTOCOL_UNDEFINED) },
 	{ USB_INTERFACE_INFO(USB_CLASS_VIDEO, 1, UVC_PC_PROTOCOL_15) },
diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index f2f565281e63..06a538d1008b 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -128,6 +128,27 @@ static void uvc_fixup_video_ctrl(struct uvc_streaming *stream,
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
+	 */
+	if (stream->dev->quirks & UVC_QUIRK_FIX_FORMAT_INDEX && ctrl->bmHint > 255) {
+		__u8 corrected_format_index;
+
+		corrected_format_index = ctrl->bmHint >> 8;
+		uvc_dbg(stream->dev, CONTROL,
+			"Correct USB video probe response from {bmHint: 0x%04x, bFormatIndex: 0x%02x} to {bmHint: 0x%04x, bFormatIndex: 0x%02x}.\n",
+			ctrl->bmHint, ctrl->bFormatIndex,
+			ctrl->bFormatIndex, corrected_format_index);
+		ctrl->bmHint = ctrl->bFormatIndex;
+		ctrl->bFormatIndex = corrected_format_index;
+	}
+
 	for (i = 0; i < stream->nformats; ++i) {
 		if (stream->format[i].index == ctrl->bFormatIndex) {
 			format = &stream->format[i];
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index 97df5ecd66c9..bf401d5ba27d 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -209,6 +209,7 @@
 #define UVC_QUIRK_RESTORE_CTRLS_ON_INIT	0x00000400
 #define UVC_QUIRK_FORCE_Y8		0x00000800
 #define UVC_QUIRK_FORCE_BPP		0x00001000
+#define UVC_QUIRK_FIX_FORMAT_INDEX	0x00002000
 
 /* Format flags */
 #define UVC_FMT_FLAG_COMPRESSED		0x00000001
-- 
2.27.0

