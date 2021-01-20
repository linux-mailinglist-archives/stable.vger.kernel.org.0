Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD472FC8B7
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 04:27:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732212AbhATCbT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 21:31:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:46618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727571AbhATB3K (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Jan 2021 20:29:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2009623119;
        Wed, 20 Jan 2021 01:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611106053;
        bh=x8SzVggovaHzS2vLj57odYH8uRPPp+IM+ZSmWzDora4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ajjuuym+kh/7DYhiATHs17+f+B0TcR1ycxgPSSH/AzpuUCYXKlbMNzZrSpkcpLkqy
         SBTFUobzTEkQ3k2wrl4gr5NU+870J71HoImpLmB/Zu4/v1CrAI0pirkGzP7t+4ZdFs
         AzwH0a8q/d3MQnNdkW/n4tZtR2jN5b3YStr2M4e+EWfAD8IVS4m3UwIDXj6/GEy+vS
         G0X/7sD/0h2YizYM3l3Tx7xheyswyl53bvkrCKYSLIz73JeDvuaGSPEhMeSzn2pGnO
         vE+BXZ5xk8UnB4yBhFRb1tRiAkrqI7N8BWsxJTvIlCKphARuA7FBwcRtXgD9JMV62e
         72U3EZyKg0+Sg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wayne Lin <Wayne.Lin@amd.com>,
        Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
        Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 21/26] drm/amd/display: Fix to be able to stop crc calculation
Date:   Tue, 19 Jan 2021 20:26:58 -0500
Message-Id: <20210120012704.770095-21-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210120012704.770095-1-sashal@kernel.org>
References: <20210120012704.770095-1-sashal@kernel.org>
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
index a549c7c717ddc..f0b001b3af578 100644
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

