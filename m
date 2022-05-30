Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C993E537E97
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238845AbiE3N6P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 09:58:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239491AbiE3N4m (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 09:56:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 750B19728F;
        Mon, 30 May 2022 06:38:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E1FBDB80D84;
        Mon, 30 May 2022 13:38:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AF97C3411F;
        Mon, 30 May 2022 13:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917910;
        bh=Oi8ynjuCy12/rKuZoMa+tK0Cg4GnEu3gJj9p6v5n/ic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F1xAUvFey6KlRgEex7IP7Tgh0EI+MtT/pQBTFGtMQcPGYYyrbuY+/5kNZJV53N7O1
         aJIvc2v+cDR5uxhnKcfy9nTHVmzjfS23zB/chBpNL+AFBRSAPCeUIUvbPRp53BQWeF
         IMX3NVGx1yRYZzj0XJHq2f1alo9Dum2zbf0Xc/Av6J1aJhmPhpD+N/kmM2vfDn/WO0
         wGJFBhMg459GFIiiZarLbTb2VeqWo5Lr0TusAqeFDtwSlZZo+JpkgtxdNcVAP7OGYt
         CYBMEO/AKrRUfY79qN4z5MuLE3OhQF9ptLs9pw3LPN9GfmVnRTIxM4lo7HGu1Ikjbp
         ixtBOWcbLhAVw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zack Rusin <zackr@vmware.com>,
        Martin Krastev <krastevm@vmware.com>,
        Sasha Levin <sashal@kernel.org>, airlied@linux.ie,
        daniel@ffwll.ch, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 002/109] drm/vmwgfx: validate the screen formats
Date:   Mon, 30 May 2022 09:36:38 -0400
Message-Id: <20220530133825.1933431-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530133825.1933431-1-sashal@kernel.org>
References: <20220530133825.1933431-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 50c64e7813be..171e90c4b9f3 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
@@ -916,6 +916,15 @@ static int vmw_kms_new_framebuffer_surface(struct vmw_private *dev_priv,
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
@@ -1229,20 +1238,13 @@ static int vmw_kms_new_framebuffer_bo(struct vmw_private *dev_priv,
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
index bbc809f7bd8a..8c8ee87fd3ac 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.h
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.h
@@ -248,7 +248,6 @@ struct vmw_framebuffer_bo {
 static const uint32_t __maybe_unused vmw_primary_plane_formats[] = {
 	DRM_FORMAT_XRGB1555,
 	DRM_FORMAT_RGB565,
-	DRM_FORMAT_RGB888,
 	DRM_FORMAT_XRGB8888,
 	DRM_FORMAT_ARGB8888,
 };
-- 
2.35.1

