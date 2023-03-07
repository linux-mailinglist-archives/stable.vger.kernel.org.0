Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 140326AF443
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:15:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233888AbjCGTPb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:15:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233864AbjCGTPM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:15:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8181FB79DC
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:58:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34449B819DB
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:58:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66A3EC433EF;
        Tue,  7 Mar 2023 18:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215520;
        bh=jNTR4xBTJfQ71Gy35ApSMVS2soiHyPyfcBFKZgnUh9M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=khlkcsOe+M3ClFjWxhZTRXVkICWpPykj4QODBTMQQo2EHxp5PtGGdQLa8OI87m3NB
         uwDzLg6Qoejku7P4M5l3248Clc0d3OkzAUArjRCKUHaxYYg1yNrTIL98ElokId3+2k
         OkFuHhHvLMyrY92cq0P1XDaBgWU6mt+mTE3Mi7hc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Ricardo Ribalda <ribalda@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 287/567] media: uvcvideo: Use control names from framework
Date:   Tue,  7 Mar 2023 18:00:23 +0100
Message-Id: <20230307165918.354302617@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
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

[ Upstream commit 70fa906d6fceb07a49198d2f31cadecc76787419 ]

The framework already contains a map of IDs to names, lets use it when
possible.

Reviewed-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Suggested-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Stable-dep-of: 9f582f0418ed ("media: uvcvideo: Check for INACTIVE in uvc_ctrl_is_accessible()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_ctrl.c | 57 ++++++++++++--------------------
 drivers/media/usb/uvc/uvc_v4l2.c |  8 ++++-
 drivers/media/usb/uvc/uvcvideo.h |  2 +-
 3 files changed, 30 insertions(+), 37 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
index 769088a7f9375..748f87af5e43e 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -432,7 +432,6 @@ static void uvc_ctrl_set_rel_speed(struct uvc_control_mapping *mapping,
 static const struct uvc_control_mapping uvc_ctrl_mappings[] = {
 	{
 		.id		= V4L2_CID_BRIGHTNESS,
-		.name		= "Brightness",
 		.entity		= UVC_GUID_UVC_PROCESSING,
 		.selector	= UVC_PU_BRIGHTNESS_CONTROL,
 		.size		= 16,
@@ -442,7 +441,6 @@ static const struct uvc_control_mapping uvc_ctrl_mappings[] = {
 	},
 	{
 		.id		= V4L2_CID_CONTRAST,
-		.name		= "Contrast",
 		.entity		= UVC_GUID_UVC_PROCESSING,
 		.selector	= UVC_PU_CONTRAST_CONTROL,
 		.size		= 16,
@@ -452,7 +450,6 @@ static const struct uvc_control_mapping uvc_ctrl_mappings[] = {
 	},
 	{
 		.id		= V4L2_CID_HUE,
-		.name		= "Hue",
 		.entity		= UVC_GUID_UVC_PROCESSING,
 		.selector	= UVC_PU_HUE_CONTROL,
 		.size		= 16,
@@ -464,7 +461,6 @@ static const struct uvc_control_mapping uvc_ctrl_mappings[] = {
 	},
 	{
 		.id		= V4L2_CID_SATURATION,
-		.name		= "Saturation",
 		.entity		= UVC_GUID_UVC_PROCESSING,
 		.selector	= UVC_PU_SATURATION_CONTROL,
 		.size		= 16,
@@ -474,7 +470,6 @@ static const struct uvc_control_mapping uvc_ctrl_mappings[] = {
 	},
 	{
 		.id		= V4L2_CID_SHARPNESS,
-		.name		= "Sharpness",
 		.entity		= UVC_GUID_UVC_PROCESSING,
 		.selector	= UVC_PU_SHARPNESS_CONTROL,
 		.size		= 16,
@@ -484,7 +479,6 @@ static const struct uvc_control_mapping uvc_ctrl_mappings[] = {
 	},
 	{
 		.id		= V4L2_CID_GAMMA,
-		.name		= "Gamma",
 		.entity		= UVC_GUID_UVC_PROCESSING,
 		.selector	= UVC_PU_GAMMA_CONTROL,
 		.size		= 16,
@@ -494,7 +488,6 @@ static const struct uvc_control_mapping uvc_ctrl_mappings[] = {
 	},
 	{
 		.id		= V4L2_CID_BACKLIGHT_COMPENSATION,
-		.name		= "Backlight Compensation",
 		.entity		= UVC_GUID_UVC_PROCESSING,
 		.selector	= UVC_PU_BACKLIGHT_COMPENSATION_CONTROL,
 		.size		= 16,
@@ -504,7 +497,6 @@ static const struct uvc_control_mapping uvc_ctrl_mappings[] = {
 	},
 	{
 		.id		= V4L2_CID_GAIN,
-		.name		= "Gain",
 		.entity		= UVC_GUID_UVC_PROCESSING,
 		.selector	= UVC_PU_GAIN_CONTROL,
 		.size		= 16,
@@ -514,7 +506,6 @@ static const struct uvc_control_mapping uvc_ctrl_mappings[] = {
 	},
 	{
 		.id		= V4L2_CID_POWER_LINE_FREQUENCY,
-		.name		= "Power Line Frequency",
 		.entity		= UVC_GUID_UVC_PROCESSING,
 		.selector	= UVC_PU_POWER_LINE_FREQUENCY_CONTROL,
 		.size		= 2,
@@ -526,7 +517,6 @@ static const struct uvc_control_mapping uvc_ctrl_mappings[] = {
 	},
 	{
 		.id		= V4L2_CID_HUE_AUTO,
-		.name		= "Hue, Auto",
 		.entity		= UVC_GUID_UVC_PROCESSING,
 		.selector	= UVC_PU_HUE_AUTO_CONTROL,
 		.size		= 1,
@@ -537,7 +527,6 @@ static const struct uvc_control_mapping uvc_ctrl_mappings[] = {
 	},
 	{
 		.id		= V4L2_CID_EXPOSURE_AUTO,
-		.name		= "Exposure, Auto",
 		.entity		= UVC_GUID_UVC_CAMERA,
 		.selector	= UVC_CT_AE_MODE_CONTROL,
 		.size		= 4,
@@ -550,7 +539,6 @@ static const struct uvc_control_mapping uvc_ctrl_mappings[] = {
 	},
 	{
 		.id		= V4L2_CID_EXPOSURE_AUTO_PRIORITY,
-		.name		= "Exposure, Auto Priority",
 		.entity		= UVC_GUID_UVC_CAMERA,
 		.selector	= UVC_CT_AE_PRIORITY_CONTROL,
 		.size		= 1,
@@ -560,7 +548,6 @@ static const struct uvc_control_mapping uvc_ctrl_mappings[] = {
 	},
 	{
 		.id		= V4L2_CID_EXPOSURE_ABSOLUTE,
-		.name		= "Exposure (Absolute)",
 		.entity		= UVC_GUID_UVC_CAMERA,
 		.selector	= UVC_CT_EXPOSURE_TIME_ABSOLUTE_CONTROL,
 		.size		= 32,
@@ -572,7 +559,6 @@ static const struct uvc_control_mapping uvc_ctrl_mappings[] = {
 	},
 	{
 		.id		= V4L2_CID_AUTO_WHITE_BALANCE,
-		.name		= "White Balance Temperature, Auto",
 		.entity		= UVC_GUID_UVC_PROCESSING,
 		.selector	= UVC_PU_WHITE_BALANCE_TEMPERATURE_AUTO_CONTROL,
 		.size		= 1,
@@ -583,7 +569,6 @@ static const struct uvc_control_mapping uvc_ctrl_mappings[] = {
 	},
 	{
 		.id		= V4L2_CID_WHITE_BALANCE_TEMPERATURE,
-		.name		= "White Balance Temperature",
 		.entity		= UVC_GUID_UVC_PROCESSING,
 		.selector	= UVC_PU_WHITE_BALANCE_TEMPERATURE_CONTROL,
 		.size		= 16,
@@ -595,7 +580,6 @@ static const struct uvc_control_mapping uvc_ctrl_mappings[] = {
 	},
 	{
 		.id		= V4L2_CID_AUTO_WHITE_BALANCE,
-		.name		= "White Balance Component, Auto",
 		.entity		= UVC_GUID_UVC_PROCESSING,
 		.selector	= UVC_PU_WHITE_BALANCE_COMPONENT_AUTO_CONTROL,
 		.size		= 1,
@@ -607,7 +591,6 @@ static const struct uvc_control_mapping uvc_ctrl_mappings[] = {
 	},
 	{
 		.id		= V4L2_CID_BLUE_BALANCE,
-		.name		= "White Balance Blue Component",
 		.entity		= UVC_GUID_UVC_PROCESSING,
 		.selector	= UVC_PU_WHITE_BALANCE_COMPONENT_CONTROL,
 		.size		= 16,
@@ -619,7 +602,6 @@ static const struct uvc_control_mapping uvc_ctrl_mappings[] = {
 	},
 	{
 		.id		= V4L2_CID_RED_BALANCE,
-		.name		= "White Balance Red Component",
 		.entity		= UVC_GUID_UVC_PROCESSING,
 		.selector	= UVC_PU_WHITE_BALANCE_COMPONENT_CONTROL,
 		.size		= 16,
@@ -631,7 +613,6 @@ static const struct uvc_control_mapping uvc_ctrl_mappings[] = {
 	},
 	{
 		.id		= V4L2_CID_FOCUS_ABSOLUTE,
-		.name		= "Focus (absolute)",
 		.entity		= UVC_GUID_UVC_CAMERA,
 		.selector	= UVC_CT_FOCUS_ABSOLUTE_CONTROL,
 		.size		= 16,
@@ -643,7 +624,6 @@ static const struct uvc_control_mapping uvc_ctrl_mappings[] = {
 	},
 	{
 		.id		= V4L2_CID_FOCUS_AUTO,
-		.name		= "Focus, Auto",
 		.entity		= UVC_GUID_UVC_CAMERA,
 		.selector	= UVC_CT_FOCUS_AUTO_CONTROL,
 		.size		= 1,
@@ -654,7 +634,6 @@ static const struct uvc_control_mapping uvc_ctrl_mappings[] = {
 	},
 	{
 		.id		= V4L2_CID_IRIS_ABSOLUTE,
-		.name		= "Iris, Absolute",
 		.entity		= UVC_GUID_UVC_CAMERA,
 		.selector	= UVC_CT_IRIS_ABSOLUTE_CONTROL,
 		.size		= 16,
@@ -664,7 +643,6 @@ static const struct uvc_control_mapping uvc_ctrl_mappings[] = {
 	},
 	{
 		.id		= V4L2_CID_IRIS_RELATIVE,
-		.name		= "Iris, Relative",
 		.entity		= UVC_GUID_UVC_CAMERA,
 		.selector	= UVC_CT_IRIS_RELATIVE_CONTROL,
 		.size		= 8,
@@ -674,7 +652,6 @@ static const struct uvc_control_mapping uvc_ctrl_mappings[] = {
 	},
 	{
 		.id		= V4L2_CID_ZOOM_ABSOLUTE,
-		.name		= "Zoom, Absolute",
 		.entity		= UVC_GUID_UVC_CAMERA,
 		.selector	= UVC_CT_ZOOM_ABSOLUTE_CONTROL,
 		.size		= 16,
@@ -684,7 +661,6 @@ static const struct uvc_control_mapping uvc_ctrl_mappings[] = {
 	},
 	{
 		.id		= V4L2_CID_ZOOM_CONTINUOUS,
-		.name		= "Zoom, Continuous",
 		.entity		= UVC_GUID_UVC_CAMERA,
 		.selector	= UVC_CT_ZOOM_RELATIVE_CONTROL,
 		.size		= 0,
@@ -696,7 +672,6 @@ static const struct uvc_control_mapping uvc_ctrl_mappings[] = {
 	},
 	{
 		.id		= V4L2_CID_PAN_ABSOLUTE,
-		.name		= "Pan (Absolute)",
 		.entity		= UVC_GUID_UVC_CAMERA,
 		.selector	= UVC_CT_PANTILT_ABSOLUTE_CONTROL,
 		.size		= 32,
@@ -706,7 +681,6 @@ static const struct uvc_control_mapping uvc_ctrl_mappings[] = {
 	},
 	{
 		.id		= V4L2_CID_TILT_ABSOLUTE,
-		.name		= "Tilt (Absolute)",
 		.entity		= UVC_GUID_UVC_CAMERA,
 		.selector	= UVC_CT_PANTILT_ABSOLUTE_CONTROL,
 		.size		= 32,
@@ -716,7 +690,6 @@ static const struct uvc_control_mapping uvc_ctrl_mappings[] = {
 	},
 	{
 		.id		= V4L2_CID_PAN_SPEED,
-		.name		= "Pan (Speed)",
 		.entity		= UVC_GUID_UVC_CAMERA,
 		.selector	= UVC_CT_PANTILT_RELATIVE_CONTROL,
 		.size		= 16,
@@ -728,7 +701,6 @@ static const struct uvc_control_mapping uvc_ctrl_mappings[] = {
 	},
 	{
 		.id		= V4L2_CID_TILT_SPEED,
-		.name		= "Tilt (Speed)",
 		.entity		= UVC_GUID_UVC_CAMERA,
 		.selector	= UVC_CT_PANTILT_RELATIVE_CONTROL,
 		.size		= 16,
@@ -740,7 +712,6 @@ static const struct uvc_control_mapping uvc_ctrl_mappings[] = {
 	},
 	{
 		.id		= V4L2_CID_PRIVACY,
-		.name		= "Privacy",
 		.entity		= UVC_GUID_UVC_CAMERA,
 		.selector	= UVC_CT_PRIVACY_CONTROL,
 		.size		= 1,
@@ -750,7 +721,6 @@ static const struct uvc_control_mapping uvc_ctrl_mappings[] = {
 	},
 	{
 		.id		= V4L2_CID_PRIVACY,
-		.name		= "Privacy",
 		.entity		= UVC_GUID_EXT_GPIO_CONTROLLER,
 		.selector	= UVC_CT_PRIVACY_CONTROL,
 		.size		= 1,
@@ -1092,6 +1062,20 @@ static int uvc_query_v4l2_class(struct uvc_video_chain *chain, u32 req_id,
 	return 0;
 }
 
+static const char *uvc_map_get_name(const struct uvc_control_mapping *map)
+{
+	const char *name;
+
+	if (map->name)
+		return map->name;
+
+	name = v4l2_ctrl_get_name(map->id);
+	if (name)
+		return name;
+
+	return "Unknown Control";
+}
+
 static int __uvc_query_v4l2_ctrl(struct uvc_video_chain *chain,
 	struct uvc_control *ctrl,
 	struct uvc_control_mapping *mapping,
@@ -1105,7 +1089,8 @@ static int __uvc_query_v4l2_ctrl(struct uvc_video_chain *chain,
 	memset(v4l2_ctrl, 0, sizeof(*v4l2_ctrl));
 	v4l2_ctrl->id = mapping->id;
 	v4l2_ctrl->type = mapping->v4l2_type;
-	strscpy(v4l2_ctrl->name, mapping->name, sizeof(v4l2_ctrl->name));
+	strscpy(v4l2_ctrl->name, uvc_map_get_name(mapping),
+		sizeof(v4l2_ctrl->name));
 	v4l2_ctrl->flags = 0;
 
 	if (!(ctrl->info.flags & UVC_CTRL_FLAG_GET_CUR))
@@ -2186,7 +2171,8 @@ static int __uvc_ctrl_add_mapping(struct uvc_video_chain *chain,
 
 	list_add_tail(&map->list, &ctrl->info.mappings);
 	uvc_dbg(chain->dev, CONTROL, "Adding mapping '%s' to control %pUl/%u\n",
-		map->name, ctrl->info.entity, ctrl->info.selector);
+		uvc_map_get_name(map), ctrl->info.entity,
+		ctrl->info.selector);
 
 	return 0;
 }
@@ -2204,7 +2190,7 @@ int uvc_ctrl_add_mapping(struct uvc_video_chain *chain,
 	if (mapping->id & ~V4L2_CTRL_ID_MASK) {
 		uvc_dbg(dev, CONTROL,
 			"Can't add mapping '%s', control id 0x%08x is invalid\n",
-			mapping->name, mapping->id);
+			uvc_map_get_name(mapping), mapping->id);
 		return -EINVAL;
 	}
 
@@ -2251,7 +2237,7 @@ int uvc_ctrl_add_mapping(struct uvc_video_chain *chain,
 		if (mapping->id == map->id) {
 			uvc_dbg(dev, CONTROL,
 				"Can't add mapping '%s', control id 0x%08x already exists\n",
-				mapping->name, mapping->id);
+				uvc_map_get_name(mapping), mapping->id);
 			ret = -EEXIST;
 			goto done;
 		}
@@ -2262,7 +2248,7 @@ int uvc_ctrl_add_mapping(struct uvc_video_chain *chain,
 		atomic_dec(&dev->nmappings);
 		uvc_dbg(dev, CONTROL,
 			"Can't add mapping '%s', maximum mappings count (%u) exceeded\n",
-			mapping->name, UVC_MAX_CONTROL_MAPPINGS);
+			uvc_map_get_name(mapping), UVC_MAX_CONTROL_MAPPINGS);
 		ret = -ENOMEM;
 		goto done;
 	}
@@ -2471,6 +2457,7 @@ static void uvc_ctrl_cleanup_mappings(struct uvc_device *dev,
 	list_for_each_entry_safe(mapping, nm, &ctrl->info.mappings, list) {
 		list_del(&mapping->list);
 		kfree(mapping->menu_info);
+		kfree(mapping->name);
 		kfree(mapping);
 	}
 }
diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
index 6955ed080d7dc..533c4a0645ee4 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -40,7 +40,13 @@ static int uvc_ioctl_ctrl_map(struct uvc_video_chain *chain,
 		return -ENOMEM;
 
 	map->id = xmap->id;
-	memcpy(map->name, xmap->name, sizeof(map->name));
+	/* Non standard control id. */
+	if (v4l2_ctrl_get_name(map->id) == NULL) {
+		map->name = kmemdup(xmap->name, sizeof(xmap->name),
+				    GFP_KERNEL);
+		if (!map->name)
+			return -ENOMEM;
+	}
 	memcpy(map->entity, xmap->entity, sizeof(map->entity));
 	map->selector = xmap->selector;
 	map->size = xmap->size;
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index 2c57a50f6a79b..33befa48fb493 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -241,7 +241,7 @@ struct uvc_control_mapping {
 	struct list_head ev_subs;
 
 	u32 id;
-	u8 name[32];
+	char *name;
 	u8 entity[16];
 	u8 selector;
 
-- 
2.39.2



