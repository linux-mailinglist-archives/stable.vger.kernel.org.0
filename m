Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C29CE6B4A2A
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:19:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234174AbjCJPTe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:19:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233291AbjCJPTD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:19:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 078BA13F545
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:09:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A0F3961A73
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 15:08:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 936F9C433D2;
        Fri, 10 Mar 2023 15:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678460899;
        bh=b+9FvI6c6W4Yj3ezEadKsc63k66pgMyriBxryXG9Rh8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jfej/DVauyCbfNGE6UWFkZhhABOkNEhyhClJLXiWafiIoo7nAJX0JRAsSjTwyX7Zr
         QzmhrtBU5IVtJYISHnYOHJgm3XnzOk7QsrQFYpWuB8uxWbOZCRZOM6ZqUpSBwjX/bJ
         F7hwrQlvPE+zy4a3MC6JEpCoClkPRZwAUJTAAYHo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Guenter Roeck <linux@roeck-us.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 489/529] media: uvcvideo: Handle errors from calls to usb_string
Date:   Fri, 10 Mar 2023 14:40:32 +0100
Message-Id: <20230310133827.512197153@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 4867bb590ae445bcfaa711a86b603c97e94574b3 ]

On a Webcam from Quanta, we see the following error.

usb 3-5: New USB device found, idVendor=0408, idProduct=30d2, bcdDevice= 0.03
usb 3-5: New USB device strings: Mfr=3, Product=1, SerialNumber=2
usb 3-5: Product: USB2.0 HD UVC WebCam
usb 3-5: Manufacturer: Quanta
usb 3-5: SerialNumber: 0x0001
...
uvcvideo: Found UVC 1.10 device USB2.0 HD UVC WebCam (0408:30d2)
uvcvideo: Failed to initialize entity for entity 5
uvcvideo: Failed to register entities (-22).

The Webcam reports an entity of type UVC_VC_EXTENSION_UNIT. It reports a
string index of '7' associated with that entity. The attempt to read that
string from the camera fails with error -32 (-EPIPE). usb_string() returns
that error, but it is ignored. As result, the entity name is empty. This
later causes v4l2_device_register_subdev() to return -EINVAL, and no
entities are registered as result.

While this appears to be a firmware problem with the camera, the kernel
should still handle the situation gracefully. To do that, check the return
value from usb_string(). If it reports an error, assign the entity's
default name.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_driver.c | 48 ++++++++++++------------------
 1 file changed, 19 insertions(+), 29 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 282f3d2388cc2..2be18fa7982d7 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -1121,10 +1121,8 @@ static int uvc_parse_vendor_control(struct uvc_device *dev,
 					       + n;
 		memcpy(unit->extension.bmControls, &buffer[23+p], 2*n);
 
-		if (buffer[24+p+2*n] != 0)
-			usb_string(udev, buffer[24+p+2*n], unit->name,
-				   sizeof(unit->name));
-		else
+		if (buffer[24+p+2*n] == 0 ||
+		    usb_string(udev, buffer[24+p+2*n], unit->name, sizeof(unit->name)) < 0)
 			sprintf(unit->name, "Extension %u", buffer[3]);
 
 		list_add_tail(&unit->list, &dev->entities);
@@ -1249,15 +1247,15 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
 			memcpy(term->media.bmTransportModes, &buffer[10+n], p);
 		}
 
-		if (buffer[7] != 0)
-			usb_string(udev, buffer[7], term->name,
-				   sizeof(term->name));
-		else if (UVC_ENTITY_TYPE(term) == UVC_ITT_CAMERA)
-			sprintf(term->name, "Camera %u", buffer[3]);
-		else if (UVC_ENTITY_TYPE(term) == UVC_ITT_MEDIA_TRANSPORT_INPUT)
-			sprintf(term->name, "Media %u", buffer[3]);
-		else
-			sprintf(term->name, "Input %u", buffer[3]);
+		if (buffer[7] == 0 ||
+		    usb_string(udev, buffer[7], term->name, sizeof(term->name)) < 0) {
+			if (UVC_ENTITY_TYPE(term) == UVC_ITT_CAMERA)
+				sprintf(term->name, "Camera %u", buffer[3]);
+			if (UVC_ENTITY_TYPE(term) == UVC_ITT_MEDIA_TRANSPORT_INPUT)
+				sprintf(term->name, "Media %u", buffer[3]);
+			else
+				sprintf(term->name, "Input %u", buffer[3]);
+		}
 
 		list_add_tail(&term->list, &dev->entities);
 		break;
@@ -1289,10 +1287,8 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
 
 		memcpy(term->baSourceID, &buffer[7], 1);
 
-		if (buffer[8] != 0)
-			usb_string(udev, buffer[8], term->name,
-				   sizeof(term->name));
-		else
+		if (buffer[8] == 0 ||
+		    usb_string(udev, buffer[8], term->name, sizeof(term->name)) < 0)
 			sprintf(term->name, "Output %u", buffer[3]);
 
 		list_add_tail(&term->list, &dev->entities);
@@ -1314,10 +1310,8 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
 
 		memcpy(unit->baSourceID, &buffer[5], p);
 
-		if (buffer[5+p] != 0)
-			usb_string(udev, buffer[5+p], unit->name,
-				   sizeof(unit->name));
-		else
+		if (buffer[5+p] == 0 ||
+		    usb_string(udev, buffer[5+p], unit->name, sizeof(unit->name)) < 0)
 			sprintf(unit->name, "Selector %u", buffer[3]);
 
 		list_add_tail(&unit->list, &dev->entities);
@@ -1347,10 +1341,8 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
 		if (dev->uvc_version >= 0x0110)
 			unit->processing.bmVideoStandards = buffer[9+n];
 
-		if (buffer[8+n] != 0)
-			usb_string(udev, buffer[8+n], unit->name,
-				   sizeof(unit->name));
-		else
+		if (buffer[8+n] == 0 ||
+		    usb_string(udev, buffer[8+n], unit->name, sizeof(unit->name)) < 0)
 			sprintf(unit->name, "Processing %u", buffer[3]);
 
 		list_add_tail(&unit->list, &dev->entities);
@@ -1378,10 +1370,8 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
 		unit->extension.bmControls = (u8 *)unit + sizeof(*unit);
 		memcpy(unit->extension.bmControls, &buffer[23+p], n);
 
-		if (buffer[23+p+n] != 0)
-			usb_string(udev, buffer[23+p+n], unit->name,
-				   sizeof(unit->name));
-		else
+		if (buffer[23+p+n] == 0 ||
+		    usb_string(udev, buffer[23+p+n], unit->name, sizeof(unit->name)) < 0)
 			sprintf(unit->name, "Extension %u", buffer[3]);
 
 		list_add_tail(&unit->list, &dev->entities);
-- 
2.39.2



