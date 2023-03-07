Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9410B6AEAAE
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:36:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231823AbjCGRgW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:36:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231689AbjCGRgC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:36:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD02B9FBC3
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:31:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0F8C9B819B4
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:31:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CBE1C433EF;
        Tue,  7 Mar 2023 17:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210309;
        bh=QIwdirwmNRmD6hXJhnseuTOQsBB5tcRCQpWWfBBvnnE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=okJymqFXc/LVNrQQtxR/GJVOtMxLGp2d5jL1j8OUOau80obHRv9G6/FFAePRYJbsV
         +Ml5mG5Xl98xuiwsDimLa9sEQcM01wuiTMxkvy/fJIrE2jfo+9OynO1Fd4w+BXRJQ2
         MuJK6N8RjTzKAc8+rAJXTQHypbpmGCaJWJKybZEw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ricardo Ribalda <ribalda@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0501/1001] media: uvcvideo: Refactor power_line_frequency_controls_limited
Date:   Tue,  7 Mar 2023 17:54:33 +0100
Message-Id: <20230307170043.126050108@linuxfoundation.org>
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

[ Upstream commit 3aa8628eb78a63d0bf93e159846e9c92bccc8f69 ]

Move the control mapping to uvc_ctrl.c. This way we do not have
references to UVC controls or V4L2 controls in uvc_driver.c.

This also fixes a bug introduced in commit 382075604a68 ("media:
uvcvideo: Limit power line control for Quanta UVC Webcam"). The
offending commit caused the power line control menu entries to have
incorrect indices compared to the V4L2_CID_POWER_LINE_FREQUENCY_*
enumeration. Now that the limited mapping reuses the correct menu_info
array, the indices correctly map to the V4L2 control specification.

Fixes: 382075604a68 ("media: uvcvideo: Limit power line control for Quanta UVC Webcam")
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_ctrl.c   | 13 +++++++++++++
 drivers/media/usb/uvc/uvc_driver.c | 18 ------------------
 drivers/media/usb/uvc/uvcvideo.h   |  1 +
 3 files changed, 14 insertions(+), 18 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
index 3c46c33b9e571..44b0cfb8ee1c7 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -723,6 +723,19 @@ static const struct uvc_control_mapping uvc_ctrl_mappings[] = {
 	},
 };
 
+const struct uvc_control_mapping uvc_ctrl_power_line_mapping_limited = {
+	.id		= V4L2_CID_POWER_LINE_FREQUENCY,
+	.entity		= UVC_GUID_UVC_PROCESSING,
+	.selector	= UVC_PU_POWER_LINE_FREQUENCY_CONTROL,
+	.size		= 2,
+	.offset		= 0,
+	.v4l2_type	= V4L2_CTRL_TYPE_MENU,
+	.data_type	= UVC_CTRL_DATA_TYPE_ENUM,
+	.menu_info	= power_line_frequency_controls,
+	.menu_mask	= GENMASK(V4L2_CID_POWER_LINE_FREQUENCY_60HZ,
+				  V4L2_CID_POWER_LINE_FREQUENCY_50HZ),
+};
+
 static const struct uvc_control_mapping uvc_ctrl_power_line_mapping_uvc11 = {
 	.id		= V4L2_CID_POWER_LINE_FREQUENCY,
 	.entity		= UVC_GUID_UVC_PROCESSING,
diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 1c8d936ef4799..d5ff8df20f18a 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -2371,24 +2371,6 @@ MODULE_PARM_DESC(timeout, "Streaming control requests timeout");
  * Driver initialization and cleanup
  */
 
-static const struct uvc_menu_info power_line_frequency_controls_limited[] = {
-	{ 1, "50 Hz" },
-	{ 2, "60 Hz" },
-};
-
-static const struct uvc_control_mapping uvc_ctrl_power_line_mapping_limited = {
-	.id		= V4L2_CID_POWER_LINE_FREQUENCY,
-	.entity		= UVC_GUID_UVC_PROCESSING,
-	.selector	= UVC_PU_POWER_LINE_FREQUENCY_CONTROL,
-	.size		= 2,
-	.offset		= 0,
-	.v4l2_type	= V4L2_CTRL_TYPE_MENU,
-	.data_type	= UVC_CTRL_DATA_TYPE_ENUM,
-	.menu_info	= power_line_frequency_controls_limited,
-	.menu_mask	=
-		GENMASK(ARRAY_SIZE(power_line_frequency_controls_limited) - 1, 0),
-};
-
 static const struct uvc_device_info uvc_ctrl_power_line_limited = {
 	.mappings = (const struct uvc_control_mapping *[]) {
 		&uvc_ctrl_power_line_mapping_limited,
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index f75e5864bbf72..1227ae63f85b7 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -728,6 +728,7 @@ int uvc_status_start(struct uvc_device *dev, gfp_t flags);
 void uvc_status_stop(struct uvc_device *dev);
 
 /* Controls */
+extern const struct uvc_control_mapping uvc_ctrl_power_line_mapping_limited;
 extern const struct v4l2_subscribed_event_ops uvc_ctrl_sub_ev_ops;
 
 int uvc_query_v4l2_ctrl(struct uvc_video_chain *chain,
-- 
2.39.2



