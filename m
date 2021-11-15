Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAFB9450D5E
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:53:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238964AbhKOR4j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:56:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:39822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238414AbhKORxl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:53:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E883632B5;
        Mon, 15 Nov 2021 17:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997562;
        bh=ck8XyBZYnj+ck7af5VYCTGfN3BGiqOHzr1XyLdEhGOw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YhPfbFY1t38nZB5UFdny8fg/iEAsGeiB2/AzEApQJf3c0S5EVl/jtThyT5Pa8diKc
         h8/ggV7TYT4qptp1F2sJP3xY0RERY5U5xlxHT9+WI+qIgMO9xP/zDxh5oS07URpPqz
         2ZBM1Q3F30KloixvaRl7v9CrQ4eDrEbdrlVEBQQQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ricardo Ribalda <ribalda@chromium.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 194/575] media: uvcvideo: Set unique vdev name based in type
Date:   Mon, 15 Nov 2021 17:58:39 +0100
Message-Id: <20211115165350.419514724@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit e3f60e7e1a2b451f538f9926763432249bcf39c4 ]

All the entities must have a unique name. We can have a descriptive and
unique name by appending the function and the entity->id.

This is even resilent to multi chain devices.

Fixes v4l2-compliance:
Media Controller ioctls:
                fail: v4l2-test-media.cpp(205): v2_entity_names_set.find(key) != v2_entity_names_set.end()
        test MEDIA_IOC_G_TOPOLOGY: FAIL
                fail: v4l2-test-media.cpp(394): num_data_links != num_links
	test MEDIA_IOC_ENUM_ENTITIES/LINKS: FAIL

Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Reviewed-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_driver.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 282f3d2388cc2..447b6a198926e 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -2065,6 +2065,7 @@ int uvc_register_video_device(struct uvc_device *dev,
 			      const struct v4l2_file_operations *fops,
 			      const struct v4l2_ioctl_ops *ioctl_ops)
 {
+	const char *name;
 	int ret;
 
 	/* Initialize the video buffers queue. */
@@ -2093,16 +2094,20 @@ int uvc_register_video_device(struct uvc_device *dev,
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
 	default:
 		vdev->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
+		name = "Video Capture";
 		break;
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
 		vdev->device_caps = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING;
+		name = "Video Output";
 		break;
 	case V4L2_BUF_TYPE_META_CAPTURE:
 		vdev->device_caps = V4L2_CAP_META_CAPTURE | V4L2_CAP_STREAMING;
+		name = "Metadata";
 		break;
 	}
 
-	strscpy(vdev->name, dev->name, sizeof(vdev->name));
+	snprintf(vdev->name, sizeof(vdev->name), "%s %u", name,
+		 stream->header.bTerminalLink);
 
 	/*
 	 * Set the driver data before calling video_register_device, otherwise
-- 
2.33.0



