Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7FD146AED2
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 01:06:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378023AbhLGAKK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 19:10:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377974AbhLGAKF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 19:10:05 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71897C061746;
        Mon,  6 Dec 2021 16:06:36 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id e3so49965586edu.4;
        Mon, 06 Dec 2021 16:06:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=J/izVKc3tuBxJtnAJV+Cykg9SYVmJJjsg5mHWvc7FL8=;
        b=cBAw5wC55uc1Ko2CY/uFR3PpqvXUrPYByfqA/GKUr9zdfcbOMBzNkUb/hBoLfLIGLv
         5k8D8j9+sPbpnkEFDQo7Ie7aVrSZaXaXfCQ0vuRO7NWdn8+UxTox4cLXu6f0nw40x+Y6
         WW+aCxp/48t4SivOwsiFOjmFXUtauUJD13a7vZkQZMrLPUZ5rUrgpJ7F3vSOywKzP/eO
         H/lveWpy+laHm7T1FY4HFNVOeeskbuYVfkV1g0aYUyib29x519ofPHlxLID696NAvckd
         yJoUI6ISbmN/yRERPhvqhaYssEwIBTj07OwcmHZgpW5BHrXXPWJrPovSeaU/ePSW1H0d
         17aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=J/izVKc3tuBxJtnAJV+Cykg9SYVmJJjsg5mHWvc7FL8=;
        b=uA2Xbgfw/KvPVOqSLk4jQvt1y42/9rALGemSpwGuVdbRwmBTNFKyFPx9aBO8DWtF48
         QjV7HXihQVVmr+hgi8TseY29Ddto0BnHdtxlwd0Is1figDuVh4wGL8P4ENKAljyEjw3O
         kFUzdSk4IEPzOUfBX34iadb+CnvV/r5LuVdPDwRv9xYpPRVGaixZwaZ+Lse2RnsWpFPp
         F3j0+tcX+n4vTuolg+IwtHmhdo0r9eZBJpRAWalHDNgEjHsOXpK5n+B75d3Xq1o7O4aZ
         xyjBxYTXShDUwQ6R5FfyhhYc40aejwRMpVxWojFXLFOJF30S4QewMUgaqqt6xuj4waV9
         R7/w==
X-Gm-Message-State: AOAM531TibbMLZk9J5eAATA+eqDUsqkEA5ufBcEUjFJHZHAaflDy/vjf
        xWWdDBFa9SiX8+IosFMyE0g=
X-Google-Smtp-Source: ABdhPJyfIL/kxLjWWeRlAaiJbtv6RSRylX5+dzF5ZAhoy3DC9sFI792+w+OoB3s7sb3RSeh6T3229w==
X-Received: by 2002:a17:906:fa87:: with SMTP id lt7mr50151940ejb.426.1638835595028;
        Mon, 06 Dec 2021 16:06:35 -0800 (PST)
Received: from piling.lan (80.71.134.83.ipv4.parknet.dk. [80.71.134.83])
        by smtp.gmail.com with ESMTPSA id w18sm8713114edx.55.2021.12.06.16.06.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 16:06:34 -0800 (PST)
From:   Ricardo Ribalda <ricardo.ribalda@gmail.com>
X-Google-Original-From: Ricardo Ribalda <ribalda@chromium.org>
To:     Nicolas Dufresne <nicolas@ndufresne.ca>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        ": Ricardo Ribalda" <ribalda@chromium.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        tfiga@chromium.org, stable <stable@vger.kernel.org>
Subject: [PATCH 3/3] media: uvcvideo: Set unique entity name based in type
Date:   Tue,  7 Dec 2021 01:06:29 +0100
Message-Id: <20211207000629.4985-4-ribalda@chromium.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211207000629.4985-1-ribalda@chromium.org>
References: <20211207000629.4985-1-ribalda@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

All the entities must have a unique name. We can have a descriptive and
unique name by appending the function to their terminal link.

This is even resilient to multi chain devices.

Fixes v4l2-compliance:
Media Controller ioctls:
   fail: v4l2-test-media.cpp(205): v2_entity_names_set.find(key) != v2_entity_names_set.end()
     test MEDIA_IOC_G_TOPOLOGY: FAIL
     fail: v4l2-test-media.cpp(394): num_data_links != num_links
   test MEDIA_IOC_ENUM_ENTITIES/LINKS: FAIL

Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
---
 drivers/media/usb/uvc/uvc_driver.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 058d28a0344b..3700e61a8701 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -2194,6 +2194,7 @@ int uvc_register_video_device(struct uvc_device *dev,
 			      const struct v4l2_ioctl_ops *ioctl_ops)
 {
 	int ret;
+	const char *name;
 
 	/* Initialize the video buffers queue. */
 	ret = uvc_queue_init(queue, type, !uvc_no_drop_param);
@@ -2221,17 +2222,29 @@ int uvc_register_video_device(struct uvc_device *dev,
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
 
+	/*
+	 * Many userspace apps identify the device with vdev->name, so we
+	 * cannot change its name for its function.
+	 */
 	strscpy(vdev->name, dev->name, sizeof(vdev->name));
 
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	vdev->entity.name = devm_kasprintf(&stream->intf->dev, GFP_KERNEL,
+				"%s %u", name, stream->header.bTerminalLink);
+#endif
+
 	/*
 	 * Set the driver data before calling video_register_device, otherwise
 	 * the file open() handler might race us.
-- 
2.33.0

