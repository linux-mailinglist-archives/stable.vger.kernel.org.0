Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FFC66AEAAC
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:36:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231778AbjCGRgI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:36:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231777AbjCGRft (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:35:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA7929E51F
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:31:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8EDAE61518
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:31:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85F06C433A0;
        Tue,  7 Mar 2023 17:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210304;
        bh=riObwAx9aliAFVFWT9bQTQwFo/5chOJRExsUFlA+3X4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x6KucbY37N4DEzR5cPtw4AUZVB5fOBBN13jSvZhC0Ck+u9Jsnx7XUzzlCSVGZZ6q3
         nrDHlgPrq5FYNVxtLi9eT+Nj5RS6t0RhtWg1p5xPOfUtGa38so48Ze7Q3bLC/IsZ0I
         Zu/15oI4YsOMuUAa08NP4fSP7vOi8DpJtyi57gAM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Ricardo Ribalda <ribalda@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0499/1001] media: uvcvideo: Implement mask for V4L2_CTRL_TYPE_MENU
Date:   Tue,  7 Mar 2023 17:54:31 +0100
Message-Id: <20230307170043.050146824@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit 40140eda661ea4be219ef194a4f43b7b5e3bbd27 ]

Replace the count with a mask field that lets us choose not only the max
value, but also the minimum value and what values are valid in between.

Suggested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Stable-dep-of: 3aa8628eb78a ("media: uvcvideo: Refactor power_line_frequency_controls_limited")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_ctrl.c   | 33 +++++++++++++++++++++---------
 drivers/media/usb/uvc/uvc_driver.c |  4 +++-
 drivers/media/usb/uvc/uvc_v4l2.c   |  3 ++-
 drivers/media/usb/uvc/uvcvideo.h   |  2 +-
 4 files changed, 29 insertions(+), 13 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
index 6f5aaaf09ee01..32c182987d52c 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -6,6 +6,7 @@
  *          Laurent Pinchart (laurent.pinchart@ideasonboard.com)
  */
 
+#include <linux/bitops.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/module.h>
@@ -525,7 +526,8 @@ static const struct uvc_control_mapping uvc_ctrl_mappings[] = {
 		.v4l2_type	= V4L2_CTRL_TYPE_MENU,
 		.data_type	= UVC_CTRL_DATA_TYPE_BITMASK,
 		.menu_info	= exposure_auto_controls,
-		.menu_count	= ARRAY_SIZE(exposure_auto_controls),
+		.menu_mask	= GENMASK(V4L2_EXPOSURE_APERTURE_PRIORITY,
+					  V4L2_EXPOSURE_AUTO),
 		.slave_ids	= { V4L2_CID_EXPOSURE_ABSOLUTE, },
 	},
 	{
@@ -731,7 +733,8 @@ static const struct uvc_control_mapping uvc_ctrl_mappings_uvc11[] = {
 		.v4l2_type	= V4L2_CTRL_TYPE_MENU,
 		.data_type	= UVC_CTRL_DATA_TYPE_ENUM,
 		.menu_info	= power_line_frequency_controls,
-		.menu_count	= ARRAY_SIZE(power_line_frequency_controls) - 1,
+		.menu_mask	= GENMASK(V4L2_CID_POWER_LINE_FREQUENCY_60HZ,
+					  V4L2_CID_POWER_LINE_FREQUENCY_DISABLED),
 	},
 };
 
@@ -745,7 +748,8 @@ static const struct uvc_control_mapping uvc_ctrl_mappings_uvc15[] = {
 		.v4l2_type	= V4L2_CTRL_TYPE_MENU,
 		.data_type	= UVC_CTRL_DATA_TYPE_ENUM,
 		.menu_info	= power_line_frequency_controls,
-		.menu_count	= ARRAY_SIZE(power_line_frequency_controls),
+		.menu_mask	= GENMASK(V4L2_CID_POWER_LINE_FREQUENCY_AUTO,
+					  V4L2_CID_POWER_LINE_FREQUENCY_DISABLED),
 	},
 };
 
@@ -975,7 +979,9 @@ static s32 __uvc_ctrl_get_value(struct uvc_control_mapping *mapping,
 		const struct uvc_menu_info *menu = mapping->menu_info;
 		unsigned int i;
 
-		for (i = 0; i < mapping->menu_count; ++i, ++menu) {
+		for (i = 0; BIT(i) <= mapping->menu_mask; ++i, ++menu) {
+			if (!test_bit(i, &mapping->menu_mask))
+				continue;
 			if (menu->value == value) {
 				value = i;
 				break;
@@ -1209,12 +1215,14 @@ static int __uvc_query_v4l2_ctrl(struct uvc_video_chain *chain,
 
 	switch (mapping->v4l2_type) {
 	case V4L2_CTRL_TYPE_MENU:
-		v4l2_ctrl->minimum = 0;
-		v4l2_ctrl->maximum = mapping->menu_count - 1;
+		v4l2_ctrl->minimum = ffs(mapping->menu_mask) - 1;
+		v4l2_ctrl->maximum = fls(mapping->menu_mask) - 1;
 		v4l2_ctrl->step = 1;
 
 		menu = mapping->menu_info;
-		for (i = 0; i < mapping->menu_count; ++i, ++menu) {
+		for (i = 0; BIT(i) <= mapping->menu_mask; ++i, ++menu) {
+			if (!test_bit(i, &mapping->menu_mask))
+				continue;
 			if (menu->value == v4l2_ctrl->default_value) {
 				v4l2_ctrl->default_value = i;
 				break;
@@ -1329,7 +1337,7 @@ int uvc_query_v4l2_menu(struct uvc_video_chain *chain,
 		goto done;
 	}
 
-	if (query_menu->index >= mapping->menu_count) {
+	if (!test_bit(query_menu->index, &mapping->menu_mask)) {
 		ret = -EINVAL;
 		goto done;
 	}
@@ -1837,8 +1845,13 @@ int uvc_ctrl_set(struct uvc_fh *handle,
 		break;
 
 	case V4L2_CTRL_TYPE_MENU:
-		if (xctrl->value < 0 || xctrl->value >= mapping->menu_count)
+		if (xctrl->value < (ffs(mapping->menu_mask) - 1) ||
+		    xctrl->value > (fls(mapping->menu_mask) - 1))
 			return -ERANGE;
+
+		if (!test_bit(xctrl->value, &mapping->menu_mask))
+			return -EINVAL;
+
 		value = mapping->menu_info[xctrl->value].value;
 
 		/*
@@ -2277,7 +2290,7 @@ static int __uvc_ctrl_add_mapping(struct uvc_video_chain *chain,
 
 	INIT_LIST_HEAD(&map->ev_subs);
 
-	size = sizeof(*mapping->menu_info) * mapping->menu_count;
+	size = sizeof(*mapping->menu_info) * fls(mapping->menu_mask);
 	map->menu_info = kmemdup(mapping->menu_info, size, GFP_KERNEL);
 	if (map->menu_info == NULL) {
 		kfree(map->name);
diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index e4bcb50113607..1c8d936ef4799 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/atomic.h>
+#include <linux/bits.h>
 #include <linux/gpio/consumer.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
@@ -2384,7 +2385,8 @@ static const struct uvc_control_mapping uvc_ctrl_power_line_mapping_limited = {
 	.v4l2_type	= V4L2_CTRL_TYPE_MENU,
 	.data_type	= UVC_CTRL_DATA_TYPE_ENUM,
 	.menu_info	= power_line_frequency_controls_limited,
-	.menu_count	= ARRAY_SIZE(power_line_frequency_controls_limited),
+	.menu_mask	=
+		GENMASK(ARRAY_SIZE(power_line_frequency_controls_limited) - 1, 0),
 };
 
 static const struct uvc_device_info uvc_ctrl_power_line_limited = {
diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
index 3edb54c086b24..0774a11360c03 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -6,6 +6,7 @@
  *          Laurent Pinchart (laurent.pinchart@ideasonboard.com)
  */
 
+#include <linux/bits.h>
 #include <linux/compat.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
@@ -80,7 +81,7 @@ static int uvc_ioctl_ctrl_map(struct uvc_video_chain *chain,
 			goto free_map;
 		}
 
-		map->menu_count = xmap->menu_count;
+		map->menu_mask = GENMASK(xmap->menu_count - 1, 0);
 		break;
 
 	default:
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index a151f583cd156..f75e5864bbf72 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -117,7 +117,7 @@ struct uvc_control_mapping {
 	u32 data_type;
 
 	const struct uvc_menu_info *menu_info;
-	u32 menu_count;
+	unsigned long menu_mask;
 
 	u32 master_id;
 	s32 master_manual;
-- 
2.39.2



