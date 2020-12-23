Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D8A92E1762
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 04:11:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728163AbgLWCSf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:18:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:46336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728134AbgLWCSe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:18:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 65F302313F;
        Wed, 23 Dec 2020 02:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689817;
        bh=JfDRzZ27W9u7Q0FkxIoxcf9USYVWuUAAzG+ewwQMtq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o6wFYovRRUxAgxMEcokiMZGIr+6UB4gE5wBfb0kz9DRYAjAh1SQD+I37Cvkv1RsHp
         WNc4N7GMqhb+hjcMS2jDeuNjb/pY80zoZLyswsofIFVQsP9RQInNogkZVRWpGQaT2D
         AVZh5HgKHokBIOYaJh3NtSqmlavqiS7ZMP+8ww3cRSU9btWnZS1HcFtLfOytTvQkE1
         Dip9UrCFTtbctzbTuJJjLHtLInV/ynIQ+QixtmkyKBBHCp014+GX6NNE3lpp2QlY7e
         F7PC2+r9Flpzrs/v/wzz6BBIdD7msPdMMNUeY/Xo+S59aB2xU2LvmdS3AmeP2ZJHHT
         t1AqFkartPa8Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eryk Brol <eryk.brol@amd.com>,
        Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
        Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 023/217] drm/amd/display: Update connector on DSC property change
Date:   Tue, 22 Dec 2020 21:13:12 -0500
Message-Id: <20201223021626.2790791-23-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021626.2790791-1-sashal@kernel.org>
References: <20201223021626.2790791-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eryk Brol <eryk.brol@amd.com>

[ Upstream commit 886876ecf7f46917af8065bb574a669f19302f96 ]

[Why]
We want to trigger atomic check on connector when
DSC debugfs properties are changed. The previous
method was reverted because it accessed connector
properties unsafely and would also heavily
impact performance.

[How]
Add a flag for forcing DSC update in CRTC state
and add connector to the state if the flag is set.

Signed-off-by: Eryk Brol <eryk.brol@amd.com>
Reviewed-by: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   6 +-
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h |   1 +
 .../amd/display/amdgpu_dm/amdgpu_dm_debugfs.c | 124 ++++++++++++++++++
 3 files changed, 130 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 553a241dedf5d..c532b6f2702f8 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -8656,6 +8656,7 @@ static int amdgpu_dm_atomic_check(struct drm_device *dev,
 	enum dc_status status;
 	int ret, i;
 	bool lock_and_validation_needed = false;
+	struct dm_crtc_state *dm_old_crtc_state;
 
 	amdgpu_check_debugfs_connector_property_change(adev, state);
 
@@ -8698,9 +8699,12 @@ static int amdgpu_dm_atomic_check(struct drm_device *dev,
 	}
 #endif
 	for_each_oldnew_crtc_in_state(state, crtc, old_crtc_state, new_crtc_state, i) {
+		dm_old_crtc_state = to_dm_crtc_state(old_crtc_state);
+
 		if (!drm_atomic_crtc_needs_modeset(new_crtc_state) &&
 		    !new_crtc_state->color_mgmt_changed &&
-		    old_crtc_state->vrr_enabled == new_crtc_state->vrr_enabled)
+		    old_crtc_state->vrr_enabled == new_crtc_state->vrr_enabled &&
+			dm_old_crtc_state->dsc_force_changed == false)
 			continue;
 
 		if (!new_crtc_state->enable)
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
index a8a0e8cb1a118..56ec5d7677488 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
@@ -440,6 +440,7 @@ struct dm_crtc_state {
 	bool freesync_timing_changed;
 	bool freesync_vrr_info_changed;
 
+	bool dsc_force_changed;
 	bool vrr_supported;
 	struct mod_freesync_config freesync_config;
 	struct dc_info_packet vrr_infopacket;
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
index 8cd646eef096c..5c72ebd5998f8 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
@@ -1253,6 +1253,10 @@ static ssize_t dp_dsc_clock_en_write(struct file *f, const char __user *buf,
 				     size_t size, loff_t *pos)
 {
 	struct amdgpu_dm_connector *aconnector = file_inode(f)->i_private;
+	struct drm_connector *connector = &aconnector->base;
+	struct drm_device *dev = connector->dev;
+	struct drm_crtc *crtc = NULL;
+	struct dm_crtc_state *dm_crtc_state = NULL;
 	struct pipe_ctx *pipe_ctx;
 	int i;
 	char *wr_buf = NULL;
@@ -1295,6 +1299,25 @@ static ssize_t dp_dsc_clock_en_write(struct file *f, const char __user *buf,
 	if (!pipe_ctx || !pipe_ctx->stream)
 		goto done;
 
+	// Get CRTC state
+	mutex_lock(&dev->mode_config.mutex);
+	drm_modeset_lock(&dev->mode_config.connection_mutex, NULL);
+
+	if (connector->state == NULL)
+		goto unlock;
+
+	crtc = connector->state->crtc;
+	if (crtc == NULL)
+		goto unlock;
+
+	drm_modeset_lock(&crtc->mutex, NULL);
+	if (crtc->state == NULL)
+		goto unlock;
+
+	dm_crtc_state = to_dm_crtc_state(crtc->state);
+	if (dm_crtc_state->stream == NULL)
+		goto unlock;
+
 	if (param[0] == 1)
 		aconnector->dsc_settings.dsc_force_enable = DSC_CLK_FORCE_ENABLE;
 	else if (param[0] == 2)
@@ -1302,6 +1325,14 @@ static ssize_t dp_dsc_clock_en_write(struct file *f, const char __user *buf,
 	else
 		aconnector->dsc_settings.dsc_force_enable = DSC_CLK_FORCE_DEFAULT;
 
+	dm_crtc_state->dsc_force_changed = true;
+
+unlock:
+	if (crtc)
+		drm_modeset_unlock(&crtc->mutex);
+	drm_modeset_unlock(&dev->mode_config.connection_mutex);
+	mutex_unlock(&dev->mode_config.mutex);
+
 done:
 	kfree(wr_buf);
 	return size;
@@ -1408,6 +1439,10 @@ static ssize_t dp_dsc_slice_width_write(struct file *f, const char __user *buf,
 {
 	struct amdgpu_dm_connector *aconnector = file_inode(f)->i_private;
 	struct pipe_ctx *pipe_ctx;
+	struct drm_connector *connector = &aconnector->base;
+	struct drm_device *dev = connector->dev;
+	struct drm_crtc *crtc = NULL;
+	struct dm_crtc_state *dm_crtc_state = NULL;
 	int i;
 	char *wr_buf = NULL;
 	uint32_t wr_buf_size = 42;
@@ -1449,6 +1484,25 @@ static ssize_t dp_dsc_slice_width_write(struct file *f, const char __user *buf,
 	if (!pipe_ctx || !pipe_ctx->stream)
 		goto done;
 
+	// Safely get CRTC state
+	mutex_lock(&dev->mode_config.mutex);
+	drm_modeset_lock(&dev->mode_config.connection_mutex, NULL);
+
+	if (connector->state == NULL)
+		goto unlock;
+
+	crtc = connector->state->crtc;
+	if (crtc == NULL)
+		goto unlock;
+
+	drm_modeset_lock(&crtc->mutex, NULL);
+	if (crtc->state == NULL)
+		goto unlock;
+
+	dm_crtc_state = to_dm_crtc_state(crtc->state);
+	if (dm_crtc_state->stream == NULL)
+		goto unlock;
+
 	if (param[0] > 0)
 		aconnector->dsc_settings.dsc_num_slices_h = DIV_ROUND_UP(
 					pipe_ctx->stream->timing.h_addressable,
@@ -1456,6 +1510,14 @@ static ssize_t dp_dsc_slice_width_write(struct file *f, const char __user *buf,
 	else
 		aconnector->dsc_settings.dsc_num_slices_h = 0;
 
+	dm_crtc_state->dsc_force_changed = true;
+
+unlock:
+	if (crtc)
+		drm_modeset_unlock(&crtc->mutex);
+	drm_modeset_unlock(&dev->mode_config.connection_mutex);
+	mutex_unlock(&dev->mode_config.mutex);
+
 done:
 	kfree(wr_buf);
 	return size;
@@ -1561,6 +1623,10 @@ static ssize_t dp_dsc_slice_height_write(struct file *f, const char __user *buf,
 				     size_t size, loff_t *pos)
 {
 	struct amdgpu_dm_connector *aconnector = file_inode(f)->i_private;
+	struct drm_connector *connector = &aconnector->base;
+	struct drm_device *dev = connector->dev;
+	struct drm_crtc *crtc = NULL;
+	struct dm_crtc_state *dm_crtc_state = NULL;
 	struct pipe_ctx *pipe_ctx;
 	int i;
 	char *wr_buf = NULL;
@@ -1603,6 +1669,25 @@ static ssize_t dp_dsc_slice_height_write(struct file *f, const char __user *buf,
 	if (!pipe_ctx || !pipe_ctx->stream)
 		goto done;
 
+	// Get CRTC state
+	mutex_lock(&dev->mode_config.mutex);
+	drm_modeset_lock(&dev->mode_config.connection_mutex, NULL);
+
+	if (connector->state == NULL)
+		goto unlock;
+
+	crtc = connector->state->crtc;
+	if (crtc == NULL)
+		goto unlock;
+
+	drm_modeset_lock(&crtc->mutex, NULL);
+	if (crtc->state == NULL)
+		goto unlock;
+
+	dm_crtc_state = to_dm_crtc_state(crtc->state);
+	if (dm_crtc_state->stream == NULL)
+		goto unlock;
+
 	if (param[0] > 0)
 		aconnector->dsc_settings.dsc_num_slices_v = DIV_ROUND_UP(
 					pipe_ctx->stream->timing.v_addressable,
@@ -1610,6 +1695,14 @@ static ssize_t dp_dsc_slice_height_write(struct file *f, const char __user *buf,
 	else
 		aconnector->dsc_settings.dsc_num_slices_v = 0;
 
+	dm_crtc_state->dsc_force_changed = true;
+
+unlock:
+	if (crtc)
+		drm_modeset_unlock(&crtc->mutex);
+	drm_modeset_unlock(&dev->mode_config.connection_mutex);
+	mutex_unlock(&dev->mode_config.mutex);
+
 done:
 	kfree(wr_buf);
 	return size;
@@ -1708,6 +1801,10 @@ static ssize_t dp_dsc_bits_per_pixel_write(struct file *f, const char __user *bu
 				     size_t size, loff_t *pos)
 {
 	struct amdgpu_dm_connector *aconnector = file_inode(f)->i_private;
+	struct drm_connector *connector = &aconnector->base;
+	struct drm_device *dev = connector->dev;
+	struct drm_crtc *crtc = NULL;
+	struct dm_crtc_state *dm_crtc_state = NULL;
 	struct pipe_ctx *pipe_ctx;
 	int i;
 	char *wr_buf = NULL;
@@ -1750,8 +1847,35 @@ static ssize_t dp_dsc_bits_per_pixel_write(struct file *f, const char __user *bu
 	if (!pipe_ctx || !pipe_ctx->stream)
 		goto done;
 
+	// Get CRTC state
+	mutex_lock(&dev->mode_config.mutex);
+	drm_modeset_lock(&dev->mode_config.connection_mutex, NULL);
+
+	if (connector->state == NULL)
+		goto unlock;
+
+	crtc = connector->state->crtc;
+	if (crtc == NULL)
+		goto unlock;
+
+	drm_modeset_lock(&crtc->mutex, NULL);
+	if (crtc->state == NULL)
+		goto unlock;
+
+	dm_crtc_state = to_dm_crtc_state(crtc->state);
+	if (dm_crtc_state->stream == NULL)
+		goto unlock;
+
 	aconnector->dsc_settings.dsc_bits_per_pixel = param[0];
 
+	dm_crtc_state->dsc_force_changed = true;
+
+unlock:
+	if (crtc)
+		drm_modeset_unlock(&crtc->mutex);
+	drm_modeset_unlock(&dev->mode_config.connection_mutex);
+	mutex_unlock(&dev->mode_config.mutex);
+
 done:
 	kfree(wr_buf);
 	return size;
-- 
2.27.0

