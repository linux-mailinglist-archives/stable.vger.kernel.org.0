Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 404DA27C747
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730920AbgI2LrP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:47:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:47378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731021AbgI2Lqh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:46:37 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2DED52075F;
        Tue, 29 Sep 2020 11:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379982;
        bh=Y6JoQtbzzygBA+PtwLLeftoDBuRRRju8FF5/VAidqUU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s9gC7HOUZFtDj1ZZiBgFBod1IRSzbUJmM1NaxMVW4M/AX0ugVzXyylCewVw6R/yLE
         G8BgzNDvbQa1n/j38Rgu+Ihrbr/mckSp+kXTyOV7+RUIEra4wfU1SKyYazkZWU3q6G
         4/UjRLXlXRpqhUxD2zcovWxf01kBLjwUChv/4Td4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        =?UTF-8?q?Michel=20D=C3=A4nzer?= <mdaenzer@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 15/99] drm/amdgpu/dc: Require primary plane to be enabled whenever the CRTC is
Date:   Tue, 29 Sep 2020 13:00:58 +0200
Message-Id: <20200929105930.460076766@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105929.719230296@linuxfoundation.org>
References: <20200929105929.719230296@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michel Dänzer <mdaenzer@redhat.com>

[ Upstream commit 2f228aab21bbc74e90e267a721215ec8be51daf7 ]

Don't check drm_crtc_state::active for this either, per its
documentation in include/drm/drm_crtc.h:

 * Hence drivers must not consult @active in their various
 * &drm_mode_config_funcs.atomic_check callback to reject an atomic
 * commit.

atomic_remove_fb disables the CRTC as needed for disabling the primary
plane.

This prevents at least the following problems if the primary plane gets
disabled (e.g. due to destroying the FB assigned to the primary plane,
as happens e.g. with mutter in Wayland mode):

* The legacy cursor ioctl returned EINVAL for a non-0 cursor FB ID
  (which enables the cursor plane).
* If the cursor plane was enabled, changing the legacy DPMS property
  value from off to on returned EINVAL.

v2:
* Minor changes to code comment and commit log, per review feedback.

GitLab: https://gitlab.gnome.org/GNOME/mutter/-/issues/1108
GitLab: https://gitlab.gnome.org/GNOME/mutter/-/issues/1165
GitLab: https://gitlab.gnome.org/GNOME/mutter/-/issues/1344
Suggested-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Michel Dänzer <mdaenzer@redhat.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 32 ++++++-------------
 1 file changed, 10 insertions(+), 22 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 3f7eced92c0c8..7c1cc0ba30a55 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -5257,19 +5257,6 @@ static void dm_crtc_helper_disable(struct drm_crtc *crtc)
 {
 }
 
-static bool does_crtc_have_active_cursor(struct drm_crtc_state *new_crtc_state)
-{
-	struct drm_device *dev = new_crtc_state->crtc->dev;
-	struct drm_plane *plane;
-
-	drm_for_each_plane_mask(plane, dev, new_crtc_state->plane_mask) {
-		if (plane->type == DRM_PLANE_TYPE_CURSOR)
-			return true;
-	}
-
-	return false;
-}
-
 static int count_crtc_active_planes(struct drm_crtc_state *new_crtc_state)
 {
 	struct drm_atomic_state *state = new_crtc_state->state;
@@ -5349,19 +5336,20 @@ static int dm_crtc_helper_atomic_check(struct drm_crtc *crtc,
 		return ret;
 	}
 
-	/* In some use cases, like reset, no stream is attached */
-	if (!dm_crtc_state->stream)
-		return 0;
-
 	/*
-	 * We want at least one hardware plane enabled to use
-	 * the stream with a cursor enabled.
+	 * We require the primary plane to be enabled whenever the CRTC is, otherwise
+	 * drm_mode_cursor_universal may end up trying to enable the cursor plane while all other
+	 * planes are disabled, which is not supported by the hardware. And there is legacy
+	 * userspace which stops using the HW cursor altogether in response to the resulting EINVAL.
 	 */
-	if (state->enable && state->active &&
-	    does_crtc_have_active_cursor(state) &&
-	    dm_crtc_state->active_planes == 0)
+	if (state->enable &&
+	    !(state->plane_mask & drm_plane_mask(crtc->primary)))
 		return -EINVAL;
 
+	/* In some use cases, like reset, no stream is attached */
+	if (!dm_crtc_state->stream)
+		return 0;
+
 	if (dc_validate_stream(dc, dm_crtc_state->stream) == DC_OK)
 		return 0;
 
-- 
2.25.1



