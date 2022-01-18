Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA3D491559
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:27:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245332AbiARC11 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:27:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245313AbiARCZQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:25:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89A8EC0613EE;
        Mon, 17 Jan 2022 18:24:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB34060C9B;
        Tue, 18 Jan 2022 02:24:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DDE1C36AE3;
        Tue, 18 Jan 2022 02:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472661;
        bh=capFOdoYMT5zuDsGokY1Gk/LSUmBH/rwoQ/95rHsKq0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J3ljuf9L9ekzY0xUtaO7baI+JIOjLLi38LsrCFWFP5je2DrLIH+skXlP+qhlfQIQZ
         7mRJeBFobOiNWOMRct4/PVi6iHCChEEf/U5VBe1RjbXDFKmWfBttw+0RUyVCBCfMdl
         S2pXdNZhzT7UVKZQoxQehgIOtQefX7b3py7RdbKNhakCN/VivPXreGCAA1PKSJyWgf
         LOadXLQSz20uTcnnUte8EI5z+PCTOPbtuxz/TkFOAoI7G7lcVEZS+Xj6hry7UHjneK
         eg58Zodg9NY3oKOp2DotHlGUW9arLWxZXezkUOsaop2SHH4rJ4oCf3eQzRtxA+QlXw
         4B5X6tFrEmrpg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vlad Zahorodnii <vlad.zahorodnii@kde.org>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@linux.ie,
        daniel@ffwll.ch, qingqing.zhuo@amd.com, Anson.Jacob@amd.com,
        shenshih@amd.com, aurabindo.pillai@amd.com, nikola.cornij@amd.com,
        Wayne.Lin@amd.com, Roman.Li@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.16 089/217] drm/amd/display: Use oriented source size when checking cursor scaling
Date:   Mon, 17 Jan 2022 21:17:32 -0500
Message-Id: <20220118021940.1942199-89-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vlad Zahorodnii <vlad.zahorodnii@kde.org>

[ Upstream commit 69cb56290d9d10cdcc461aa2685e67e540507a96 ]

dm_check_crtc_cursor() doesn't take into account plane transforms when
calculating plane scaling, this can result in false positives.

For example, if there's an output with resolution 3840x2160 and the
output is rotated 90 degrees, CRTC_W and CRTC_H will be 3840 and 2160,
respectively, but SRC_W and SRC_H will be 2160 and 3840, respectively.

Since the cursor plane usually has a square buffer attached to it, the
dm_check_crtc_cursor() will think that there's a scale factor mismatch
even though there isn't really.

This fixes an issue where kwin fails to use hardware plane transforms.

Changes since version 1:
- s/orientated/oriented/g

Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Vlad Zahorodnii <vlad.zahorodnii@kde.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 35 ++++++++++++++-----
 1 file changed, 27 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index e08ac474e9d59..21ff6b232fb62 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -10661,6 +10661,24 @@ static int dm_update_plane_state(struct dc *dc,
 	return ret;
 }
 
+static void dm_get_oriented_plane_size(struct drm_plane_state *plane_state,
+				       int *src_w, int *src_h)
+{
+	switch (plane_state->rotation & DRM_MODE_ROTATE_MASK) {
+	case DRM_MODE_ROTATE_90:
+	case DRM_MODE_ROTATE_270:
+		*src_w = plane_state->src_h >> 16;
+		*src_h = plane_state->src_w >> 16;
+		break;
+	case DRM_MODE_ROTATE_0:
+	case DRM_MODE_ROTATE_180:
+	default:
+		*src_w = plane_state->src_w >> 16;
+		*src_h = plane_state->src_h >> 16;
+		break;
+	}
+}
+
 static int dm_check_crtc_cursor(struct drm_atomic_state *state,
 				struct drm_crtc *crtc,
 				struct drm_crtc_state *new_crtc_state)
@@ -10669,6 +10687,8 @@ static int dm_check_crtc_cursor(struct drm_atomic_state *state,
 	struct drm_plane_state *new_cursor_state, *new_underlying_state;
 	int i;
 	int cursor_scale_w, cursor_scale_h, underlying_scale_w, underlying_scale_h;
+	int cursor_src_w, cursor_src_h;
+	int underlying_src_w, underlying_src_h;
 
 	/* On DCE and DCN there is no dedicated hardware cursor plane. We get a
 	 * cursor per pipe but it's going to inherit the scaling and
@@ -10680,10 +10700,9 @@ static int dm_check_crtc_cursor(struct drm_atomic_state *state,
 		return 0;
 	}
 
-	cursor_scale_w = new_cursor_state->crtc_w * 1000 /
-			 (new_cursor_state->src_w >> 16);
-	cursor_scale_h = new_cursor_state->crtc_h * 1000 /
-			 (new_cursor_state->src_h >> 16);
+	dm_get_oriented_plane_size(new_cursor_state, &cursor_src_w, &cursor_src_h);
+	cursor_scale_w = new_cursor_state->crtc_w * 1000 / cursor_src_w;
+	cursor_scale_h = new_cursor_state->crtc_h * 1000 / cursor_src_h;
 
 	for_each_new_plane_in_state_reverse(state, underlying, new_underlying_state, i) {
 		/* Narrow down to non-cursor planes on the same CRTC as the cursor */
@@ -10694,10 +10713,10 @@ static int dm_check_crtc_cursor(struct drm_atomic_state *state,
 		if (!new_underlying_state->fb)
 			continue;
 
-		underlying_scale_w = new_underlying_state->crtc_w * 1000 /
-				     (new_underlying_state->src_w >> 16);
-		underlying_scale_h = new_underlying_state->crtc_h * 1000 /
-				     (new_underlying_state->src_h >> 16);
+		dm_get_oriented_plane_size(new_underlying_state,
+					   &underlying_src_w, &underlying_src_h);
+		underlying_scale_w = new_underlying_state->crtc_w * 1000 / underlying_src_w;
+		underlying_scale_h = new_underlying_state->crtc_h * 1000 / underlying_src_h;
 
 		if (cursor_scale_w != underlying_scale_w ||
 		    cursor_scale_h != underlying_scale_h) {
-- 
2.34.1

