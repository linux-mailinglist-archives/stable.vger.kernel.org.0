Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB1176AEAAD
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:36:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231816AbjCGRgS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:36:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231837AbjCGRf5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:35:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 906FE9E52E
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:31:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4866EB819B5
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:31:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85E1BC433EF;
        Tue,  7 Mar 2023 17:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210306;
        bh=mH5DrzJOFJmb5we/oLkptg/WQfuYGHhGlfz1otJI/5k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UcrNCZLCIxdUIRdfePpXg5oh40QxhZY1W1axWgjw6+k/v4COQdjXHUAmR19LzLmjC
         Bi9ghnQnHoR6m+8f+95ZxOtAY6yPVnQ9G4TswMAVM2peSNA8fvrjOc5ZKU2V8a2qhT
         pMIvJpZQDbvKrLukVTSbCHQPEmvUDPwI/z9fg0eM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ricardo Ribalda <ribalda@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0500/1001] media: uvcvideo: Refactor uvc_ctrl_mappings_uvcXX
Date:   Tue,  7 Mar 2023 17:54:32 +0100
Message-Id: <20230307170043.087421711@linuxfoundation.org>
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

[ Upstream commit 96a160b068e09b4ed5a32e2179e5219fc3545eca ]

Convert the array of structs into an array of pointers, that way the
mappings can be reused.

Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Stable-dep-of: 3aa8628eb78a ("media: uvcvideo: Refactor power_line_frequency_controls_limited")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_ctrl.c | 74 ++++++++++++++++----------------
 1 file changed, 37 insertions(+), 37 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
index 32c182987d52c..3c46c33b9e571 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -723,34 +723,40 @@ static const struct uvc_control_mapping uvc_ctrl_mappings[] = {
 	},
 };
 
-static const struct uvc_control_mapping uvc_ctrl_mappings_uvc11[] = {
-	{
-		.id		= V4L2_CID_POWER_LINE_FREQUENCY,
-		.entity		= UVC_GUID_UVC_PROCESSING,
-		.selector	= UVC_PU_POWER_LINE_FREQUENCY_CONTROL,
-		.size		= 2,
-		.offset		= 0,
-		.v4l2_type	= V4L2_CTRL_TYPE_MENU,
-		.data_type	= UVC_CTRL_DATA_TYPE_ENUM,
-		.menu_info	= power_line_frequency_controls,
-		.menu_mask	= GENMASK(V4L2_CID_POWER_LINE_FREQUENCY_60HZ,
-					  V4L2_CID_POWER_LINE_FREQUENCY_DISABLED),
-	},
+static const struct uvc_control_mapping uvc_ctrl_power_line_mapping_uvc11 = {
+	.id		= V4L2_CID_POWER_LINE_FREQUENCY,
+	.entity		= UVC_GUID_UVC_PROCESSING,
+	.selector	= UVC_PU_POWER_LINE_FREQUENCY_CONTROL,
+	.size		= 2,
+	.offset		= 0,
+	.v4l2_type	= V4L2_CTRL_TYPE_MENU,
+	.data_type	= UVC_CTRL_DATA_TYPE_ENUM,
+	.menu_info	= power_line_frequency_controls,
+	.menu_mask	= GENMASK(V4L2_CID_POWER_LINE_FREQUENCY_60HZ,
+				  V4L2_CID_POWER_LINE_FREQUENCY_DISABLED),
 };
 
-static const struct uvc_control_mapping uvc_ctrl_mappings_uvc15[] = {
-	{
-		.id		= V4L2_CID_POWER_LINE_FREQUENCY,
-		.entity		= UVC_GUID_UVC_PROCESSING,
-		.selector	= UVC_PU_POWER_LINE_FREQUENCY_CONTROL,
-		.size		= 2,
-		.offset		= 0,
-		.v4l2_type	= V4L2_CTRL_TYPE_MENU,
-		.data_type	= UVC_CTRL_DATA_TYPE_ENUM,
-		.menu_info	= power_line_frequency_controls,
-		.menu_mask	= GENMASK(V4L2_CID_POWER_LINE_FREQUENCY_AUTO,
-					  V4L2_CID_POWER_LINE_FREQUENCY_DISABLED),
-	},
+static const struct uvc_control_mapping *uvc_ctrl_mappings_uvc11[] = {
+	&uvc_ctrl_power_line_mapping_uvc11,
+	NULL, /* Sentinel */
+};
+
+static const struct uvc_control_mapping uvc_ctrl_power_line_mapping_uvc15 = {
+	.id		= V4L2_CID_POWER_LINE_FREQUENCY,
+	.entity		= UVC_GUID_UVC_PROCESSING,
+	.selector	= UVC_PU_POWER_LINE_FREQUENCY_CONTROL,
+	.size		= 2,
+	.offset		= 0,
+	.v4l2_type	= V4L2_CTRL_TYPE_MENU,
+	.data_type	= UVC_CTRL_DATA_TYPE_ENUM,
+	.menu_info	= power_line_frequency_controls,
+	.menu_mask	= GENMASK(V4L2_CID_POWER_LINE_FREQUENCY_AUTO,
+				  V4L2_CID_POWER_LINE_FREQUENCY_DISABLED),
+};
+
+static const struct uvc_control_mapping *uvc_ctrl_mappings_uvc15[] = {
+	&uvc_ctrl_power_line_mapping_uvc15,
+	NULL, /* Sentinel */
 };
 
 /* ------------------------------------------------------------------------
@@ -2474,8 +2480,7 @@ static void uvc_ctrl_prune_entity(struct uvc_device *dev,
 static void uvc_ctrl_init_ctrl(struct uvc_video_chain *chain,
 			       struct uvc_control *ctrl)
 {
-	const struct uvc_control_mapping *mappings;
-	unsigned int num_mappings;
+	const struct uvc_control_mapping **mappings;
 	unsigned int i;
 
 	/*
@@ -2542,16 +2547,11 @@ static void uvc_ctrl_init_ctrl(struct uvc_video_chain *chain,
 	}
 
 	/* Finally process version-specific mappings. */
-	if (chain->dev->uvc_version < 0x0150) {
-		mappings = uvc_ctrl_mappings_uvc11;
-		num_mappings = ARRAY_SIZE(uvc_ctrl_mappings_uvc11);
-	} else {
-		mappings = uvc_ctrl_mappings_uvc15;
-		num_mappings = ARRAY_SIZE(uvc_ctrl_mappings_uvc15);
-	}
+	mappings = chain->dev->uvc_version < 0x0150
+		 ? uvc_ctrl_mappings_uvc11 : uvc_ctrl_mappings_uvc15;
 
-	for (i = 0; i < num_mappings; ++i) {
-		const struct uvc_control_mapping *mapping = &mappings[i];
+	for (i = 0; mappings[i]; ++i) {
+		const struct uvc_control_mapping *mapping = mappings[i];
 
 		if (uvc_entity_match_guid(ctrl->entity, mapping->entity) &&
 		    ctrl->info.selector == mapping->selector)
-- 
2.39.2



