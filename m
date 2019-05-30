Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7552D2F221
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729745AbfE3ESs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:18:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:38864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730314AbfE3DP3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:15:29 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07B5324559;
        Thu, 30 May 2019 03:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186129;
        bh=BYFtQfBUzUSraymaH/ctnpl6FrmDvPDOsJF1vVqIk6E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PWisfc/Enoy48vqV03KEtPdP/aLIwcLFx/YHXpMKvrrIiY3Q0NGZ2T3UovtqhPt97
         uv2NZBDY2MxePKxSN4jRsWp13ZWKF2yO4YB2GY/CRsb7lWxDWOoLHxkcbmSV/2kD9/
         3ZHBPiilBAWp/6/0CnIBBAEeIlGODmB+VJ/9RGWc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Harry Wentland <Harry.Wentland@amd.com>,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 290/346] drm/amd/display: Reset alpha state for planes to the correct values
Date:   Wed, 29 May 2019 20:06:03 -0700
Message-Id: <20190530030555.570465890@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit eec3d5efd16d13984a88396b685ae17462fb6d87 ]

[Why]
The plane_reset callback is subclassed but hasn't been updated since
the drm helper got updated to include resetting alpha related state
(state->alpha and state->pixel_blend_mode). The overlay planes
exposed by amdgpu_dm were therefore being rendered as invisible by
default ever since supported was exposed for alpha blending properties
on overlays.

This caused regressions in igt@kms_plane_multiple@atomic-tiling-none
and igt@kms_plane@plane-position-covered-pipe tests.

[How]
Reset the plane state values to their correct values as defined in
the drm helper.

This fixes the IGT test regression.

Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Reviewed-by: Harry Wentland <Harry.Wentland@amd.com>
Acked-by: Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 84ee777869441..e766dede5b472 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -3519,6 +3519,8 @@ static void dm_drm_plane_reset(struct drm_plane *plane)
 		plane->state = &amdgpu_state->base;
 		plane->state->plane = plane;
 		plane->state->rotation = DRM_MODE_ROTATE_0;
+		plane->state->alpha = DRM_BLEND_ALPHA_OPAQUE;
+		plane->state->pixel_blend_mode = DRM_MODE_BLEND_PREMULTI;
 	}
 }
 
-- 
2.20.1



