Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1863D6B4669
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:43:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232905AbjCJOnA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:43:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232799AbjCJOmt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:42:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BCA4121153
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:42:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F6CFB822E3
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:42:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BD6EC433D2;
        Fri, 10 Mar 2023 14:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459354;
        bh=CFXGFtfgO0JbaRfNEjKAHLR7fg6maWo7hW4goNR7XqA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jLLXvmCZ64sEvb6/wNpoiZK8eU/h1dHM0jRzRzENlEbDniURZXxqyEIAKV5wa3Eb2
         axWXCKnEyLMvM/vgF+tjWNBbTiHL5vjHADyxYeoARXRi06EiH28i8utUJs2fO89HwP
         +LkzREhhALFaA2mxt16jYXj2tFsoTy53s6jbrLOQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ricardo Ribalda <ribalda@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 334/357] media: uvcvideo: Quirk for autosuspend in Logitech B910 and C910
Date:   Fri, 10 Mar 2023 14:40:23 +0100
Message-Id: <20230310133749.400688302@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit 136effa754b57632f99574fc4a3433e0cfc031d9 ]

Logitech B910 and C910 firmware are unable to recover from a USB
autosuspend. When it resumes, the device is in a state where it only
produces invalid frames. Eg:

$ echo 0xFFFF > /sys/module/uvcvideo/parameters/trace # enable verbose log
$ yavta -c1 -n1 --file='frame#.jpg' --format MJPEG --size=1920x1080 /dev/video1
[350438.435219] uvcvideo: uvc_v4l2_open
[350438.529794] uvcvideo: Resuming interface 2
[350438.529801] uvcvideo: Resuming interface 3
[350438.529991] uvcvideo: Trying format 0x47504a4d (MJPG): 1920x1080.
[350438.529996] uvcvideo: Using default frame interval 33333.3 us (30.0 fps).
[350438.551496] uvcvideo: uvc_v4l2_mmap
[350438.555890] uvcvideo: Device requested 3060 B/frame bandwidth.
[350438.555896] uvcvideo: Selecting alternate setting 11 (3060 B/frame bandwidth).
[350438.556362] uvcvideo: Allocated 5 URB buffers of 32x3060 bytes each.
[350439.316468] uvcvideo: Marking buffer as bad (error bit set).
[350439.316475] uvcvideo: Frame complete (EOF found).
[350439.316477] uvcvideo: EOF in empty payload.
[350439.316484] uvcvideo: frame 1 stats: 149/261/417 packets, 1/149/417 pts (early initial), 416/417 scr, last pts/stc/sof 2976325734/2978107243/249
[350439.384510] uvcvideo: Marking buffer as bad (error bit set).
[350439.384516] uvcvideo: Frame complete (EOF found).
[350439.384518] uvcvideo: EOF in empty payload.
[350439.384525] uvcvideo: frame 2 stats: 265/379/533 packets, 1/265/533 pts (early initial), 532/533 scr, last pts/stc/sof 2979524454/2981305193/316
[350439.448472] uvcvideo: Marking buffer as bad (error bit set).
[350439.448478] uvcvideo: Frame complete (EOF found).
[350439.448480] uvcvideo: EOF in empty payload.
[350439.448487] uvcvideo: frame 3 stats: 265/377/533 packets, 1/265/533 pts (early initial), 532/533 scr, last pts/stc/sof 2982723174/2984503144/382
...(loop)...

The devices can leave this invalid state if the alternate setting of
the streaming interface is toggled.

This patch adds a quirk for this device so it can be autosuspended
properly.

lsusb -v:
Bus 001 Device 049: ID 046d:0821 Logitech, Inc. HD Webcam C910
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass          239 Miscellaneous Device
  bDeviceSubClass         2
  bDeviceProtocol         1 Interface Association
  bMaxPacketSize0        64
  idVendor           0x046d Logitech, Inc.
  idProduct          0x0821 HD Webcam C910
  bcdDevice            0.10
  iManufacturer           0
  iProduct                0
  iSerial                 1 390022B0
  bNumConfigurations      1

Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_driver.c | 18 ++++++++++++++++++
 drivers/media/usb/uvc/uvc_video.c  | 11 +++++++++++
 drivers/media/usb/uvc/uvcvideo.h   |  1 +
 3 files changed, 30 insertions(+)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index f6c48f22c6724..0caa57a6782aa 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -2462,6 +2462,24 @@ static const struct usb_device_id uvc_ids[] = {
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
 	  .driver_info		= (kernel_ulong_t)&uvc_quirk_probe_minmax },
+	/* Logitech, Webcam C910 */
+	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
+				| USB_DEVICE_ID_MATCH_INT_INFO,
+	  .idVendor		= 0x046d,
+	  .idProduct		= 0x0821,
+	  .bInterfaceClass	= USB_CLASS_VIDEO,
+	  .bInterfaceSubClass	= 1,
+	  .bInterfaceProtocol	= 0,
+	  .driver_info		= UVC_INFO_QUIRK(UVC_QUIRK_WAKE_AUTOSUSPEND)},
+	/* Logitech, Webcam B910 */
+	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
+				| USB_DEVICE_ID_MATCH_INT_INFO,
+	  .idVendor		= 0x046d,
+	  .idProduct		= 0x0823,
+	  .bInterfaceClass	= USB_CLASS_VIDEO,
+	  .bInterfaceSubClass	= 1,
+	  .bInterfaceProtocol	= 0,
+	  .driver_info		= UVC_INFO_QUIRK(UVC_QUIRK_WAKE_AUTOSUSPEND)},
 	/* Logitech Quickcam Fusion */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index fe58723fc5ac7..698aecf1aad48 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -1903,6 +1903,17 @@ static int uvc_video_start_transfer(struct uvc_streaming *stream,
 		uvc_trace(UVC_TRACE_VIDEO, "Selecting alternate setting %u "
 			"(%u B/frame bandwidth).\n", altsetting, best_psize);
 
+		/*
+		 * Some devices, namely the Logitech C910 and B910, are unable
+		 * to recover from a USB autosuspend, unless the alternate
+		 * setting of the streaming interface is toggled.
+		 */
+		if (stream->dev->quirks & UVC_QUIRK_WAKE_AUTOSUSPEND) {
+			usb_set_interface(stream->dev->udev, intfnum,
+					  altsetting);
+			usb_set_interface(stream->dev->udev, intfnum, 0);
+		}
+
 		ret = usb_set_interface(stream->dev->udev, intfnum, altsetting);
 		if (ret < 0)
 			return ret;
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index 5f137400bebd6..6afbfc71bad4b 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -199,6 +199,7 @@
 #define UVC_QUIRK_RESTORE_CTRLS_ON_INIT	0x00000400
 #define UVC_QUIRK_FORCE_Y8		0x00000800
 #define UVC_QUIRK_FORCE_BPP		0x00001000
+#define UVC_QUIRK_WAKE_AUTOSUSPEND	0x00002000
 
 /* Format flags */
 #define UVC_FMT_FLAG_COMPRESSED		0x00000001
-- 
2.39.2



