Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79E9115EBA3
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:22:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391382AbgBNQKA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:10:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:35122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391302AbgBNQKA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:10:00 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 051C622314;
        Fri, 14 Feb 2020 16:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696598;
        bh=A5M/b60pryRVMCK7wWtj9FXnrBwc8azvr0jEhFC4aWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XSef138qM1m5BY2cR+WB1YnsuxvGtrL3Q1fSUP75BrKR9P7aF+EWY4oXFEgFraV3v
         anOhANTZALuAWWy6F7h9uyEnv8LaFJruSs6eey5uSM+3YzUcuzwAaLTczlaQWFFr6f
         Tvx7V2BmvK74IjlrZ+OCBVFLHc5MnBB03O+DXI64=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sergey Zakharchenko <szakharchenko@digital-loggers.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 384/459] media: uvcvideo: Add a quirk to force GEO GC6500 Camera bits-per-pixel value
Date:   Fri, 14 Feb 2020 11:00:34 -0500
Message-Id: <20200214160149.11681-384-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergey Zakharchenko <szakharchenko@digital-loggers.com>

[ Upstream commit 1dd2e8f942574e2be18374ebb81751082d8d467c ]

This device does not function correctly in raw mode in kernel
versions validating buffer sizes in bulk mode. It erroneously
announces 16 bits per pixel instead of 12 for NV12 format, so it
needs this quirk to fix computed frame size and avoid legitimate
frames getting discarded.

[Move info and div variables to local scope]

Signed-off-by: Sergey Zakharchenko <szakharchenko@digital-loggers.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_driver.c | 25 +++++++++++++++++++++++++
 drivers/media/usb/uvc/uvcvideo.h   |  1 +
 2 files changed, 26 insertions(+)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 2b688cc39bb81..99883550375e9 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -497,6 +497,22 @@ static int uvc_parse_format(struct uvc_device *dev,
 			}
 		}
 
+		/* Some devices report bpp that doesn't match the format. */
+		if (dev->quirks & UVC_QUIRK_FORCE_BPP) {
+			const struct v4l2_format_info *info =
+				v4l2_format_info(format->fcc);
+
+			if (info) {
+				unsigned int div = info->hdiv * info->vdiv;
+
+				n = info->bpp[0] * div;
+				for (i = 1; i < info->comp_planes; i++)
+					n += info->bpp[i];
+
+				format->bpp = DIV_ROUND_UP(8 * n, div);
+			}
+		}
+
 		if (buffer[2] == UVC_VS_FORMAT_UNCOMPRESSED) {
 			ftype = UVC_VS_FRAME_UNCOMPRESSED;
 		} else {
@@ -2874,6 +2890,15 @@ static const struct usb_device_id uvc_ids[] = {
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
 	  .driver_info		= (kernel_ulong_t)&uvc_quirk_force_y8 },
+	/* GEO Semiconductor GC6500 */
+	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
+				| USB_DEVICE_ID_MATCH_INT_INFO,
+	  .idVendor		= 0x29fe,
+	  .idProduct		= 0x4d53,
+	  .bInterfaceClass	= USB_CLASS_VIDEO,
+	  .bInterfaceSubClass	= 1,
+	  .bInterfaceProtocol	= 0,
+	  .driver_info		= UVC_INFO_QUIRK(UVC_QUIRK_FORCE_BPP) },
 	/* Intel RealSense D4M */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index c7c1baa90dea8..24e3d8c647e77 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -198,6 +198,7 @@
 #define UVC_QUIRK_RESTRICT_FRAME_RATE	0x00000200
 #define UVC_QUIRK_RESTORE_CTRLS_ON_INIT	0x00000400
 #define UVC_QUIRK_FORCE_Y8		0x00000800
+#define UVC_QUIRK_FORCE_BPP		0x00001000
 
 /* Format flags */
 #define UVC_FMT_FLAG_COMPRESSED		0x00000001
-- 
2.20.1

