Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72C2A6C16F2
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:10:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231838AbjCTPK1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:10:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232196AbjCTPKD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:10:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 172EF2B9E4
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:05:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 865E2B80EBE
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:05:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 989CEC433EF;
        Mon, 20 Mar 2023 15:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679324717;
        bh=EqRirIe3wSEM13Qk+Ni5ipVtNOSlnkRWbG/B2wN215M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=igcdRJEIvsuOMfFy7PbuBShCWu2H89Kcgm4cLqAtodn5yqCdOUjcnb9oukgqNtuIu
         3xFMkgSutz3BUKrm7qDPejvIUMcDug975hmUmgifQZ+Mt37NCeNxbz/9icZ7gIhELi
         RhwgLR6LMPk4feWBWjOzieNs4cIaCcwsLJ66EI7o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Daniel Vetter <daniel@ffwll.ch>,
        Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>,
        =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 022/115] drm/i915/display/psr: Use drm damage helpers to calculate plane damaged area
Date:   Mon, 20 Mar 2023 15:53:54 +0100
Message-Id: <20230320145450.339742681@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145449.336983711@linuxfoundation.org>
References: <20230320145449.336983711@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: José Roberto de Souza <jose.souza@intel.com>

[ Upstream commit af7ea1e22afc7ce7773b2e4562df4370c8c711ea ]

drm_atomic_helper_damage_iter_init() + drm_atomic_for_each_plane_damage()
returns the full plane area in case no damaged area was set by
userspace or it was discarted by driver.

This is important to fix the rendering of userspace applications that
does frontbuffer rendering and notify driver about dirty areas but do
not set any dirty clips.

With this we don't need to worry about to check and mark the whole
area as damaged in page flips.

Another important change here is the move of
drm_atomic_add_affected_planes() call, it needs to called late
otherwise the area of all the planes would be added to pipe_clip and
not saving power.

Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>
Reviewed-by: Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>
Signed-off-by: José Roberto de Souza <jose.souza@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210914212507.177511-4-jose.souza@intel.com
Stable-dep-of: 71c602103c74 ("drm/i915/psr: Use calculated io and fast wake lines")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_psr.c | 37 +++++++++---------------
 1 file changed, 13 insertions(+), 24 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_psr.c b/drivers/gpu/drm/i915/display/intel_psr.c
index b4b193c2bc32e..5e7827b076028 100644
--- a/drivers/gpu/drm/i915/display/intel_psr.c
+++ b/drivers/gpu/drm/i915/display/intel_psr.c
@@ -22,6 +22,7 @@
  */
 
 #include <drm/drm_atomic_helper.h>
+#include <drm/drm_damage_helper.h>
 
 #include "display/intel_dp.h"
 
@@ -1636,10 +1637,6 @@ int intel_psr2_sel_fetch_update(struct intel_atomic_state *state,
 	if (!crtc_state->enable_psr2_sel_fetch)
 		return 0;
 
-	ret = drm_atomic_add_affected_planes(&state->base, &crtc->base);
-	if (ret)
-		return ret;
-
 	/*
 	 * Calculate minimal selective fetch area of each plane and calculate
 	 * the pipe damaged area.
@@ -1649,8 +1646,8 @@ int intel_psr2_sel_fetch_update(struct intel_atomic_state *state,
 	for_each_oldnew_intel_plane_in_state(state, plane, old_plane_state,
 					     new_plane_state, i) {
 		struct drm_rect src, damaged_area = { .y1 = -1 };
-		struct drm_mode_rect *damaged_clips;
-		u32 num_clips, j;
+		struct drm_atomic_helper_damage_iter iter;
+		struct drm_rect clip;
 
 		if (new_plane_state->uapi.crtc != crtc_state->uapi.crtc)
 			continue;
@@ -1670,8 +1667,6 @@ int intel_psr2_sel_fetch_update(struct intel_atomic_state *state,
 			break;
 		}
 
-		num_clips = drm_plane_get_damage_clips_count(&new_plane_state->uapi);
-
 		/*
 		 * If visibility or plane moved, mark the whole plane area as
 		 * damaged as it needs to be complete redraw in the new and old
@@ -1695,14 +1690,8 @@ int intel_psr2_sel_fetch_update(struct intel_atomic_state *state,
 			cursor_area_workaround(new_plane_state, &damaged_area,
 					       &pipe_clip);
 			continue;
-		} else if (new_plane_state->uapi.alpha != old_plane_state->uapi.alpha ||
-			   (!num_clips &&
-			    new_plane_state->uapi.fb != old_plane_state->uapi.fb)) {
-			/*
-			 * If the plane don't have damaged areas but the
-			 * framebuffer changed or alpha changed, mark the whole
-			 * plane area as damaged.
-			 */
+		} else if (new_plane_state->uapi.alpha != old_plane_state->uapi.alpha) {
+			/* If alpha changed mark the whole plane area as damaged */
 			damaged_area.y1 = new_plane_state->uapi.dst.y1;
 			damaged_area.y2 = new_plane_state->uapi.dst.y2;
 			clip_area_update(&pipe_clip, &damaged_area);
@@ -1710,15 +1699,11 @@ int intel_psr2_sel_fetch_update(struct intel_atomic_state *state,
 		}
 
 		drm_rect_fp_to_int(&src, &new_plane_state->uapi.src);
-		damaged_clips = drm_plane_get_damage_clips(&new_plane_state->uapi);
-
-		for (j = 0; j < num_clips; j++) {
-			struct drm_rect clip;
 
-			clip.x1 = damaged_clips[j].x1;
-			clip.y1 = damaged_clips[j].y1;
-			clip.x2 = damaged_clips[j].x2;
-			clip.y2 = damaged_clips[j].y2;
+		drm_atomic_helper_damage_iter_init(&iter,
+						   &old_plane_state->uapi,
+						   &new_plane_state->uapi);
+		drm_atomic_for_each_plane_damage(&iter, &clip) {
 			if (drm_rect_intersect(&clip, &src))
 				clip_area_update(&damaged_area, &clip);
 		}
@@ -1734,6 +1719,10 @@ int intel_psr2_sel_fetch_update(struct intel_atomic_state *state,
 	if (full_update)
 		goto skip_sel_fetch_set_loop;
 
+	ret = drm_atomic_add_affected_planes(&state->base, &crtc->base);
+	if (ret)
+		return ret;
+
 	intel_psr2_sel_fetch_pipe_alignment(crtc_state, &pipe_clip);
 
 	/*
-- 
2.39.2



