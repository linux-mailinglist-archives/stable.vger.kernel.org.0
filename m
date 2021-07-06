Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56BCB3BD18A
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238508AbhGFLjm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:39:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:47552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237174AbhGFLf7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:35:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DFB1961EC9;
        Tue,  6 Jul 2021 11:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570755;
        bh=ufUr61OH30M4Hxk7SL0COsncKi5k41MsTd6RCQQpcUc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sxz7gOW7Gk4EmnLB8zV1Z2yD94UV2siopSq2Q5iUJU8iw7bz5QwRWX0LknOcTxlLc
         0QIUUkwW7A6KDlIpaMjfDjyHzNe7999TwQmPMuiwJz5HuIwehXwTYsQ+dYmECflo1g
         8QX8w7D8880VLmS7smgplda6pfcTiJrQLv033ROJKOM+DaYlQmeURg9ukteSMxMCbx
         uEjkpkBOauQ0MGTAJeAw5qfi9Xdeh0yO9d1CZBPozWKJwQF9gguM46u0uaDf4dXocv
         PyLtJt+6/buK+QJJE5JjFT+5/4JhgFafv9vWlJffwfISezqXpw0HwjnyC2ySl2dhJu
         JXEYXSbMncM5A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Yacoub <markyacoub@chromium.org>,
        Harry Wentland <harry.wentland@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 42/74] drm/amd/display: Verify Gamma & Degamma LUT sizes in amdgpu_dm_atomic_check
Date:   Tue,  6 Jul 2021 07:24:30 -0400
Message-Id: <20210706112502.2064236-42-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112502.2064236-1-sashal@kernel.org>
References: <20210706112502.2064236-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Yacoub <markyacoub@chromium.org>

[ Upstream commit 03fc4cf45d30533d54f0f4ebc02aacfa12f52ce2 ]

For each CRTC state, check the size of Gamma and Degamma LUTs  so
unexpected and larger sizes wouldn't slip through.

TEST: IGT:kms_color::pipe-invalid-gamma-lut-sizes

v2: fix assignments in if clauses, Mark's email.

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Mark Yacoub <markyacoub@chromium.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |  4 ++
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h |  1 +
 .../amd/display/amdgpu_dm/amdgpu_dm_color.c   | 41 ++++++++++++++++---
 3 files changed, 40 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index fca466d4806b..11da904fcb7e 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -7407,6 +7407,10 @@ static int amdgpu_dm_atomic_check(struct drm_device *dev,
 		    old_crtc_state->vrr_enabled == new_crtc_state->vrr_enabled)
 			continue;
 
+		ret = amdgpu_dm_verify_lut_sizes(new_crtc_state);
+		if (ret)
+			goto fail;
+
 		if (!new_crtc_state->enable)
 			continue;
 
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
index c8c525a2b505..54163c970e7a 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
@@ -387,6 +387,7 @@ void amdgpu_dm_update_freesync_caps(struct drm_connector *connector,
 #define MAX_COLOR_LEGACY_LUT_ENTRIES 256
 
 void amdgpu_dm_init_color_mod(void);
+int amdgpu_dm_verify_lut_sizes(const struct drm_crtc_state *crtc_state);
 int amdgpu_dm_update_crtc_color_mgmt(struct dm_crtc_state *crtc);
 int amdgpu_dm_update_plane_color_mgmt(struct dm_crtc_state *crtc,
 				      struct dc_plane_state *dc_plane_state);
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_color.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_color.c
index 2233d293a707..6acc460a3e98 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_color.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_color.c
@@ -277,6 +277,37 @@ static int __set_input_tf(struct dc_transfer_func *func,
 	return res ? 0 : -ENOMEM;
 }
 
+/**
+ * Verifies that the Degamma and Gamma LUTs attached to the |crtc_state| are of
+ * the expected size.
+ * Returns 0 on success.
+ */
+int amdgpu_dm_verify_lut_sizes(const struct drm_crtc_state *crtc_state)
+{
+	const struct drm_color_lut *lut = NULL;
+	uint32_t size = 0;
+
+	lut = __extract_blob_lut(crtc_state->degamma_lut, &size);
+	if (lut && size != MAX_COLOR_LUT_ENTRIES) {
+		DRM_DEBUG_DRIVER(
+			"Invalid Degamma LUT size. Should be %u but got %u.\n",
+			MAX_COLOR_LUT_ENTRIES, size);
+		return -EINVAL;
+	}
+
+	lut = __extract_blob_lut(crtc_state->gamma_lut, &size);
+	if (lut && size != MAX_COLOR_LUT_ENTRIES &&
+	    size != MAX_COLOR_LEGACY_LUT_ENTRIES) {
+		DRM_DEBUG_DRIVER(
+			"Invalid Gamma LUT size. Should be %u (or %u for legacy) but got %u.\n",
+			MAX_COLOR_LUT_ENTRIES, MAX_COLOR_LEGACY_LUT_ENTRIES,
+			size);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 /**
  * amdgpu_dm_update_crtc_color_mgmt: Maps DRM color management to DC stream.
  * @crtc: amdgpu_dm crtc state
@@ -311,14 +342,12 @@ int amdgpu_dm_update_crtc_color_mgmt(struct dm_crtc_state *crtc)
 	bool is_legacy;
 	int r;
 
-	degamma_lut = __extract_blob_lut(crtc->base.degamma_lut, &degamma_size);
-	if (degamma_lut && degamma_size != MAX_COLOR_LUT_ENTRIES)
-		return -EINVAL;
+	r = amdgpu_dm_verify_lut_sizes(&crtc->base);
+	if (r)
+		return r;
 
+	degamma_lut = __extract_blob_lut(crtc->base.degamma_lut, &degamma_size);
 	regamma_lut = __extract_blob_lut(crtc->base.gamma_lut, &regamma_size);
-	if (regamma_lut && regamma_size != MAX_COLOR_LUT_ENTRIES &&
-	    regamma_size != MAX_COLOR_LEGACY_LUT_ENTRIES)
-		return -EINVAL;
 
 	has_degamma =
 		degamma_lut && !__is_lut_linear(degamma_lut, degamma_size);
-- 
2.30.2

