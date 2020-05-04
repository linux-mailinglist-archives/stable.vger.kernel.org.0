Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAF0B1C4501
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 20:12:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731511AbgEDSDa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 14:03:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:60694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731522AbgEDSD3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 14:03:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01733206B8;
        Mon,  4 May 2020 18:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588615408;
        bh=WNkK7zEmrEiC3i+WKeSmlKup4yKe2HW73FUu/vksXB0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HggCV9VUH9oNo6ZcjKqAdmQogjY7fNwO+b/x+5GKhl1aZYrKUB7ryD6c5HyrS3O8h
         gf6NuQqgYr1XPH1XKZ81+XFOIFVHxJdTspwm97fd6MRrk3rmOmFde2CZGF595zuc0z
         g7PkhQe0QVteBPFETP/DkutZrPXTf4XiXXpBRlME=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.4 03/57] drm/amd/display: Fix green screen issue after suspend
Date:   Mon,  4 May 2020 19:57:07 +0200
Message-Id: <20200504165456.965597414@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504165456.783676004@linuxfoundation.org>
References: <20200504165456.783676004@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>

commit 87b7ebc2e16c14d32a912f18206a4d6cc9abc3e8 upstream.

[why]
We have seen a green screen after resume from suspend in a Raven system
connected with two displays (HDMI and DP) on X based system. We noticed
that this issue is related to bad DCC metadata from user space which may
generate hangs and consequently an underflow on HUBP. After taking a
deep look at the code path we realized that after resume we try to
restore the commit with the DCC enabled framebuffer but the framebuffer
is no longer valid.

[how]
This problem was only reported on Raven based system and after suspend,
for this reason, this commit adds a new parameter on
fill_plane_dcc_attributes() to give the option of disabling DCC
programmatically. In summary, for disabling DCC we first verify if is a
Raven system and if it is in suspend; if both conditions are true we
disable DCC temporarily, otherwise, it is enabled.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1099
Co-developed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Reviewed-by: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   38 ++++++++++++++++------
 1 file changed, 29 insertions(+), 9 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -2698,7 +2698,8 @@ fill_plane_dcc_attributes(struct amdgpu_
 			  const union dc_tiling_info *tiling_info,
 			  const uint64_t info,
 			  struct dc_plane_dcc_param *dcc,
-			  struct dc_plane_address *address)
+			  struct dc_plane_address *address,
+			  bool force_disable_dcc)
 {
 	struct dc *dc = adev->dm.dc;
 	struct dc_dcc_surface_param input;
@@ -2710,6 +2711,9 @@ fill_plane_dcc_attributes(struct amdgpu_
 	memset(&input, 0, sizeof(input));
 	memset(&output, 0, sizeof(output));
 
+	if (force_disable_dcc)
+		return 0;
+
 	if (!offset)
 		return 0;
 
@@ -2759,7 +2763,8 @@ fill_plane_buffer_attributes(struct amdg
 			     union dc_tiling_info *tiling_info,
 			     struct plane_size *plane_size,
 			     struct dc_plane_dcc_param *dcc,
-			     struct dc_plane_address *address)
+			     struct dc_plane_address *address,
+			     bool force_disable_dcc)
 {
 	const struct drm_framebuffer *fb = &afb->base;
 	int ret;
@@ -2869,7 +2874,8 @@ fill_plane_buffer_attributes(struct amdg
 
 		ret = fill_plane_dcc_attributes(adev, afb, format, rotation,
 						plane_size, tiling_info,
-						tiling_flags, dcc, address);
+						tiling_flags, dcc, address,
+						force_disable_dcc);
 		if (ret)
 			return ret;
 	}
@@ -2961,7 +2967,8 @@ fill_dc_plane_info_and_addr(struct amdgp
 			    const struct drm_plane_state *plane_state,
 			    const uint64_t tiling_flags,
 			    struct dc_plane_info *plane_info,
-			    struct dc_plane_address *address)
+			    struct dc_plane_address *address,
+			    bool force_disable_dcc)
 {
 	const struct drm_framebuffer *fb = plane_state->fb;
 	const struct amdgpu_framebuffer *afb =
@@ -3040,7 +3047,8 @@ fill_dc_plane_info_and_addr(struct amdgp
 					   plane_info->rotation, tiling_flags,
 					   &plane_info->tiling_info,
 					   &plane_info->plane_size,
-					   &plane_info->dcc, address);
+					   &plane_info->dcc, address,
+					   force_disable_dcc);
 	if (ret)
 		return ret;
 
@@ -3063,6 +3071,7 @@ static int fill_dc_plane_attributes(stru
 	struct dc_plane_info plane_info;
 	uint64_t tiling_flags;
 	int ret;
+	bool force_disable_dcc = false;
 
 	ret = fill_dc_scaling_info(plane_state, &scaling_info);
 	if (ret)
@@ -3077,9 +3086,11 @@ static int fill_dc_plane_attributes(stru
 	if (ret)
 		return ret;
 
+	force_disable_dcc = adev->asic_type == CHIP_RAVEN && adev->in_suspend;
 	ret = fill_dc_plane_info_and_addr(adev, plane_state, tiling_flags,
 					  &plane_info,
-					  &dc_plane_state->address);
+					  &dc_plane_state->address,
+					  force_disable_dcc);
 	if (ret)
 		return ret;
 
@@ -4481,6 +4492,7 @@ static int dm_plane_helper_prepare_fb(st
 	uint64_t tiling_flags;
 	uint32_t domain;
 	int r;
+	bool force_disable_dcc = false;
 
 	dm_plane_state_old = to_dm_plane_state(plane->state);
 	dm_plane_state_new = to_dm_plane_state(new_state);
@@ -4539,11 +4551,13 @@ static int dm_plane_helper_prepare_fb(st
 			dm_plane_state_old->dc_state != dm_plane_state_new->dc_state) {
 		struct dc_plane_state *plane_state = dm_plane_state_new->dc_state;
 
+		force_disable_dcc = adev->asic_type == CHIP_RAVEN && adev->in_suspend;
 		fill_plane_buffer_attributes(
 			adev, afb, plane_state->format, plane_state->rotation,
 			tiling_flags, &plane_state->tiling_info,
 			&plane_state->plane_size, &plane_state->dcc,
-			&plane_state->address);
+			&plane_state->address,
+			force_disable_dcc);
 	}
 
 	return 0;
@@ -5767,7 +5781,12 @@ static void amdgpu_dm_commit_planes(stru
 		fill_dc_plane_info_and_addr(
 			dm->adev, new_plane_state, tiling_flags,
 			&bundle->plane_infos[planes_count],
-			&bundle->flip_addrs[planes_count].address);
+			&bundle->flip_addrs[planes_count].address,
+			false);
+
+		DRM_DEBUG_DRIVER("plane: id=%d dcc_en=%d\n",
+				 new_plane_state->plane->index,
+				 bundle->plane_infos[planes_count].dcc.enable);
 
 		bundle->surface_updates[planes_count].plane_info =
 			&bundle->plane_infos[planes_count];
@@ -7138,7 +7157,8 @@ dm_determine_update_type_for_commit(stru
 				ret = fill_dc_plane_info_and_addr(
 					dm->adev, new_plane_state, tiling_flags,
 					&plane_info,
-					&flip_addr.address);
+					&flip_addr.address,
+					false);
 				if (ret)
 					goto cleanup;
 


