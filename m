Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C551603E1B
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:11:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232605AbiJSJKv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:10:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232839AbiJSJJZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:09:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 216BF72B74;
        Wed, 19 Oct 2022 02:00:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A6BB961830;
        Wed, 19 Oct 2022 09:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDB2CC433D7;
        Wed, 19 Oct 2022 09:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170017;
        bh=jdZLnZbQFZrYc+ncUIK2z06tTja/ckr8DEOyMoDYb7M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QE6MH5gZIsgIO8ch6npUvyutJq5PU6khAzKDlOaW3HmSYIPY3Wj63JtWfmEoUgKOX
         iLG2/eY/xhLfz+4GRPp0tJrO8yx03qacy/T1tmtk+8atliiXF46rUwDT834dL2hMEF
         IRFQySVgwyGOIFZNeuEUqqRLxWebnEmdL5AcpY5Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yunke Cao <yunkec@google.com>,
        Ricardo Ribalda <ribalda@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 496/862] media: uvcvideo: Use entity get_cur in uvc_ctrl_set
Date:   Wed, 19 Oct 2022 10:29:43 +0200
Message-Id: <20221019083311.887213783@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yunke Cao <yunkec@google.com>

[ Upstream commit 5f36851c36b30f713f588ed2b60aa7b4512e2c76 ]

Entity controls should get_cur using an entity-defined function
instead of via a query. Fix this in uvc_ctrl_set.

Fixes: 65900c581d01 ("media: uvcvideo: Allow entity-defined get_info and get_cur")
Signed-off-by: Yunke Cao <yunkec@google.com>
Reviewed-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_ctrl.c | 83 ++++++++++++++++++--------------
 1 file changed, 46 insertions(+), 37 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
index 8c208db9600b..53250ea75dfb 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -985,36 +985,56 @@ static s32 __uvc_ctrl_get_value(struct uvc_control_mapping *mapping,
 	return value;
 }
 
-static int __uvc_ctrl_get(struct uvc_video_chain *chain,
-	struct uvc_control *ctrl, struct uvc_control_mapping *mapping,
-	s32 *value)
+static int __uvc_ctrl_load_cur(struct uvc_video_chain *chain,
+			       struct uvc_control *ctrl)
 {
+	u8 *data;
 	int ret;
 
-	if ((ctrl->info.flags & UVC_CTRL_FLAG_GET_CUR) == 0)
-		return -EACCES;
+	if (ctrl->loaded)
+		return 0;
 
-	if (!ctrl->loaded) {
-		if (ctrl->entity->get_cur) {
-			ret = ctrl->entity->get_cur(chain->dev,
-				ctrl->entity,
-				ctrl->info.selector,
-				uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT),
-				ctrl->info.size);
-		} else {
-			ret = uvc_query_ctrl(chain->dev, UVC_GET_CUR,
-				ctrl->entity->id,
-				chain->dev->intfnum,
-				ctrl->info.selector,
-				uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT),
-				ctrl->info.size);
-		}
-		if (ret < 0)
-			return ret;
+	data = uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT);
 
+	if ((ctrl->info.flags & UVC_CTRL_FLAG_GET_CUR) == 0) {
+		memset(data, 0, ctrl->info.size);
 		ctrl->loaded = 1;
+
+		return 0;
 	}
 
+	if (ctrl->entity->get_cur)
+		ret = ctrl->entity->get_cur(chain->dev, ctrl->entity,
+					    ctrl->info.selector, data,
+					    ctrl->info.size);
+	else
+		ret = uvc_query_ctrl(chain->dev, UVC_GET_CUR,
+				     ctrl->entity->id, chain->dev->intfnum,
+				     ctrl->info.selector, data,
+				     ctrl->info.size);
+
+	if (ret < 0)
+		return ret;
+
+	ctrl->loaded = 1;
+
+	return ret;
+}
+
+static int __uvc_ctrl_get(struct uvc_video_chain *chain,
+			  struct uvc_control *ctrl,
+			  struct uvc_control_mapping *mapping,
+			  s32 *value)
+{
+	int ret;
+
+	if ((ctrl->info.flags & UVC_CTRL_FLAG_GET_CUR) == 0)
+		return -EACCES;
+
+	ret = __uvc_ctrl_load_cur(chain, ctrl);
+	if (ret < 0)
+		return ret;
+
 	*value = __uvc_ctrl_get_value(mapping,
 				uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT));
 
@@ -1810,21 +1830,10 @@ int uvc_ctrl_set(struct uvc_fh *handle,
 	 * needs to be loaded from the device to perform the read-modify-write
 	 * operation.
 	 */
-	if (!ctrl->loaded && (ctrl->info.size * 8) != mapping->size) {
-		if ((ctrl->info.flags & UVC_CTRL_FLAG_GET_CUR) == 0) {
-			memset(uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT),
-				0, ctrl->info.size);
-		} else {
-			ret = uvc_query_ctrl(chain->dev, UVC_GET_CUR,
-				ctrl->entity->id, chain->dev->intfnum,
-				ctrl->info.selector,
-				uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT),
-				ctrl->info.size);
-			if (ret < 0)
-				return ret;
-		}
-
-		ctrl->loaded = 1;
+	if ((ctrl->info.size * 8) != mapping->size) {
+		ret = __uvc_ctrl_load_cur(chain, ctrl);
+		if (ret < 0)
+			return ret;
 	}
 
 	/* Backup the current value in case we need to rollback later. */
-- 
2.35.1



