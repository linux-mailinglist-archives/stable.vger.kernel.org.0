Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 165D33CADFD
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 22:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230515AbhGOUgV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 16:36:21 -0400
Received: from mout02.posteo.de ([185.67.36.66]:49059 "EHLO mout02.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231285AbhGOUgV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 16:36:21 -0400
Received: from submission (posteo.de [89.146.220.130]) 
        by mout02.posteo.de (Postfix) with ESMTPS id 1DA9D240104
        for <stable@vger.kernel.org>; Thu, 15 Jul 2021 22:33:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.de; s=2017;
        t=1626381205; bh=L3Mrm0RIbAzYf998TOSRz98G5f6mvYrU79OoWVC2iGU=;
        h=From:To:Cc:Subject:Date:From;
        b=blD2AU7Z9MJNBmD5dZgG4JO0cDUvJLW4K+/S6/VKbh87h9JmnxqZbGLFqkLYfyK9i
         u7vkjN9EWfHEFampLB4xGprNShleCqYts5F6cIMKE5M08FY2/vMo11rLNU8Ku1xVvW
         nOaacNN7pYO4Pmn2FOrlBuo3nRDc5ZFMGWhvmqWtpFHNhEeXpSX4eb9HZ8x7ckSXgY
         Eb1wX2yBK4lozPTKtXDlnigwWBvm1aG2qYzqyNkoTfVI1y4/LevshfEsSXtIcRFRKt
         hwoVxANzo59T3IGFy/9QNvEaL7UNHtIVkvJ46wHUq/v5HIli8NIk4sZfcInGyFQChA
         rCHqf5DZH0NYQ==
Received: from customer (localhost [127.0.0.1])
        by submission (posteo.de) with ESMTPSA id 4GQmKc3g8wz9rxT;
        Thu, 15 Jul 2021 22:33:24 +0200 (CEST)
From:   Benjamin Drung <bdrung@posteo.de>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        stable@vger.kernel.org, Benjamin Drung <bdrung@posteo.de>
Subject: [PATCH] media: uvcvideo: Fix pixel format change for Elgato Cam Link 4K
Date:   Thu, 15 Jul 2021 20:32:55 +0000
Message-Id: <20210715203254.31085-1-bdrung@posteo.de>
In-Reply-To: <YPB78NYzwIl6ERWs@kroah.com>
References: <YPB78NYzwIl6ERWs@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
(backported from commit 4c6e0976295add7f0ed94d276c04a3d6f1ea8f83 upstream)
Signed-off-by: Benjamin Drung <bdrung@posteo.de>
---
 drivers/media/usb/uvc/uvc_video.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

The debug message does't matter much, but I am a perfectionist.

This patch is for kernel <= 5.11.

diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index a6a441d92b94..70b0d0f8026b 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -124,10 +124,37 @@ int uvc_query_ctrl(struct uvc_device *dev, u8 query, u8 unit,
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
+		uvc_trace(UVC_TRACE_VIDEO,
+			"Correct USB video probe response from {bmHint: 0x%04x, bFormatIndex: %u} to {bmHint: 0x%04x, bFormatIndex: %u}\n",
+			ctrl->bmHint, ctrl->bFormatIndex,
+			1, corrected_format_index);
+		ctrl->bmHint = 1;
+		ctrl->bFormatIndex = corrected_format_index;
+	}
+
 	for (i = 0; i < stream->nformats; ++i) {
 		if (stream->format[i].index == ctrl->bFormatIndex) {
 			format = &stream->format[i];
-- 
2.30.2

