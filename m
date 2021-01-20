Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB472FC7FB
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 03:34:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbhATCaf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 21:30:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:48236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730605AbhATB26 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Jan 2021 20:28:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F1A02242A;
        Wed, 20 Jan 2021 01:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611106009;
        bh=nI/ZJyNTZ4RU/UM2F6qtQ3iwMQ3AMhYHWtXt9MvH7Zw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KZjFNv3bnPHCAimeHdgRSS6EP+8u37gQo0Rxu6dfyyjveH/VuSfKjYiAKQS4cCVMK
         vBsJaT+S3ekCFaSMvl9+pJ+5iVpXAUdNtnNesp45bCFZKhk9muZkxeyRE36wWQbcEE
         zX5jhz5d/v24hgyWcLjlPCopBed1TkZwRrt4z3ZRwXPjxVYACpxQM2X4ypIA/eGWk6
         kFlNUPbmWkTEGHjOImUAr3fBVR9eGf2UY1a/lqZxdHDoNynCzABa+c4RPU/BlkVR3D
         EfB4gWtvArOB/k1nNURRRuJhsew9Ny0VPQ24q+tLh/o3JXgcQyW06HrieCTLvNZoT+
         KtkGPqeqnt4Bw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wayne Lin <Wayne.Lin@amd.com>,
        Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
        Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 35/45] drm/amd/display: Fix to be able to stop crc calculation
Date:   Tue, 19 Jan 2021 20:25:52 -0500
Message-Id: <20210120012602.769683-35-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210120012602.769683-1-sashal@kernel.org>
References: <20210120012602.769683-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wayne Lin <Wayne.Lin@amd.com>

[ Upstream commit 02ce73b01e09e388614b22b7ebc71debf4a588f0 ]

[Why]
Find out when we try to disable CRC calculation,
crc generation is still enabled. Main reason is
that dc_stream_configure_crc() will never get
called when the source is AMDGPU_DM_PIPE_CRC_SOURCE_NONE.

[How]
Add checking condition that when source is
AMDGPU_DM_PIPE_CRC_SOURCE_NONE, we should also call
dc_stream_configure_crc() to disable crc calculation.
Also, clean up crc window when disable crc calculation.

Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
Reviewed-by: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crc.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crc.c
index d0699e98db929..e00a30e7d2529 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crc.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crc.c
@@ -113,7 +113,7 @@ int amdgpu_dm_crtc_configure_crc_source(struct drm_crtc *crtc,
 	mutex_lock(&adev->dm.dc_lock);
 
 	/* Enable CRTC CRC generation if necessary. */
-	if (dm_is_crc_source_crtc(source)) {
+	if (dm_is_crc_source_crtc(source) || source == AMDGPU_DM_PIPE_CRC_SOURCE_NONE) {
 		if (!dc_stream_configure_crc(stream_state->ctx->dc,
 					     stream_state, enable, enable)) {
 			ret = -EINVAL;
-- 
2.27.0

