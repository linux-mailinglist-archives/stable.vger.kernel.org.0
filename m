Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56310499931
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:43:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1454204AbiAXVcA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:32:00 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:45388 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1451880AbiAXVXn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:23:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B99C60C44;
        Mon, 24 Jan 2022 21:23:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E9B2C340E4;
        Mon, 24 Jan 2022 21:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059423;
        bh=+bH8S50HUOJv3r/LvFSv6imiapSYgEoH4Jcf7BfElYg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zz71QydKz5+9oqVV3gNQrZ4Y3YEzcZsmU5Nj9h1VmB6Urbx8wcbuuxKv+cUsEvA6T
         aVDaTnurEGZMf+JAaOkDDP+7D5H/Yrm3ONwPD7g/LmUTNnmEzQiQiy5AEXFIRBZOyn
         H34SgBjDPMZMHIrvH0NWLL1g1lOoVg1F/dAuYL0s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Vlad Zahorodnii <vlad.zahorodnii@kde.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0610/1039] drm/amd/display: Use oriented source size when checking cursor scaling
Date:   Mon, 24 Jan 2022 19:39:59 +0100
Message-Id: <20220124184145.846608151@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index e12f841d1d110..46d38d528468c 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -10662,6 +10662,24 @@ static int dm_update_plane_state(struct dc *dc,
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
@@ -10670,6 +10688,8 @@ static int dm_check_crtc_cursor(struct drm_atomic_state *state,
 	struct drm_plane_state *new_cursor_state, *new_underlying_state;
 	int i;
 	int cursor_scale_w, cursor_scale_h, underlying_scale_w, underlying_scale_h;
+	int cursor_src_w, cursor_src_h;
+	int underlying_src_w, underlying_src_h;
 
 	/* On DCE and DCN there is no dedicated hardware cursor plane. We get a
 	 * cursor per pipe but it's going to inherit the scaling and
@@ -10681,10 +10701,9 @@ static int dm_check_crtc_cursor(struct drm_atomic_state *state,
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
@@ -10695,10 +10714,10 @@ static int dm_check_crtc_cursor(struct drm_atomic_state *state,
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



