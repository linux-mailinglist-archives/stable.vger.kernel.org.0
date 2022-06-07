Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A62B541106
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355322AbiFGTcX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:32:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356116AbiFGTbV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:31:21 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D833B24BED;
        Tue,  7 Jun 2022 11:12:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 89C70CE2439;
        Tue,  7 Jun 2022 18:12:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 981D9C385A2;
        Tue,  7 Jun 2022 18:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625527;
        bh=s3qNkoIYVWMpejiHT67UNIh/odgE/06E//y1wED6l1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R2FCyte0qBGtNM0nP/BhNk6hAgDf9jzgh26D8WZTDPma9w+pzJROLVx0nvAt5wXXN
         XSe0kcFbhF1Dt2rLRNSmn6rclX0j3ExIuhvT7fWGEnhDBCw8je+FASrYeB8kK5t0pQ
         nGQZYDQw01IzLfIWkk7THaWJk9/1FYaDtgGCpBPo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zack Rusin <zackr@vmware.com>,
        Martin Krastev <krastevm@vmware.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 051/772] drm/vmwgfx: validate the screen formats
Date:   Tue,  7 Jun 2022 18:54:03 +0200
Message-Id: <20220607164950.542970412@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zack Rusin <zackr@vmware.com>

[ Upstream commit 8bb75aeb58bd688d70827ae179bd3da57b6d975b ]

The kms code wasn't validating the modifiers and was letting through
unsupported formats. rgb8 was never properly supported and has no
matching svga screen target format so remove it.
This fixes format/modifier failures in kms_addfb_basic from IGT.

Signed-off-by: Zack Rusin <zackr@vmware.com>
Reviewed-by: Martin Krastev <krastevm@vmware.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220318174332.440068-4-zack@kde.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c | 30 +++++++++++++++--------------
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.h |  1 -
 2 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
index 93431e8f6606..9410152f9d6f 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
@@ -914,6 +914,15 @@ static int vmw_kms_new_framebuffer_surface(struct vmw_private *dev_priv,
 	 * Sanity checks.
 	 */
 
+	if (!drm_any_plane_has_format(&dev_priv->drm,
+				      mode_cmd->pixel_format,
+				      mode_cmd->modifier[0])) {
+		drm_dbg(&dev_priv->drm,
+			"unsupported pixel format %p4cc / modifier 0x%llx\n",
+			&mode_cmd->pixel_format, mode_cmd->modifier[0]);
+		return -EINVAL;
+	}
+
 	/* Surface must be marked as a scanout. */
 	if (unlikely(!surface->metadata.scanout))
 		return -EINVAL;
@@ -1236,20 +1245,13 @@ static int vmw_kms_new_framebuffer_bo(struct vmw_private *dev_priv,
 		return -EINVAL;
 	}
 
-	/* Limited framebuffer color depth support for screen objects */
-	if (dev_priv->active_display_unit == vmw_du_screen_object) {
-		switch (mode_cmd->pixel_format) {
-		case DRM_FORMAT_XRGB8888:
-		case DRM_FORMAT_ARGB8888:
-			break;
-		case DRM_FORMAT_XRGB1555:
-		case DRM_FORMAT_RGB565:
-			break;
-		default:
-			DRM_ERROR("Invalid pixel format: %p4cc\n",
-				  &mode_cmd->pixel_format);
-			return -EINVAL;
-		}
+	if (!drm_any_plane_has_format(&dev_priv->drm,
+				      mode_cmd->pixel_format,
+				      mode_cmd->modifier[0])) {
+		drm_dbg(&dev_priv->drm,
+			"unsupported pixel format %p4cc / modifier 0x%llx\n",
+			&mode_cmd->pixel_format, mode_cmd->modifier[0]);
+		return -EINVAL;
 	}
 
 	vfbd = kzalloc(sizeof(*vfbd), GFP_KERNEL);
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.h b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.h
index 4d36e8507380..d9ebd02099a6 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.h
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.h
@@ -247,7 +247,6 @@ struct vmw_framebuffer_bo {
 static const uint32_t __maybe_unused vmw_primary_plane_formats[] = {
 	DRM_FORMAT_XRGB1555,
 	DRM_FORMAT_RGB565,
-	DRM_FORMAT_RGB888,
 	DRM_FORMAT_XRGB8888,
 	DRM_FORMAT_ARGB8888,
 };
-- 
2.35.1



