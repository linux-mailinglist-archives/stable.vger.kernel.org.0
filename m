Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B874A371A51
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231859AbhECQj2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:39:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:38706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231868AbhECQiG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:38:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BB656054E;
        Mon,  3 May 2021 16:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620059802;
        bh=rbzHGteRRXA+HYT6QScnhUlW7tlUz+0AaOJknEJ07EQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dnz3DXCCuGTp3L/c/BwFg2+4JwTAU23Aw60SIT3dSWtGV2vA/gPwY13VJDnr5ZCRq
         98xtIDJP3tvXr2tuPLsRVJ2JssHePe+akOmtVbVdKPOPnbjRhNomt4E+e+K7RtTKCu
         KeNoIOdNce+5y8ygDQuStiqRjriISdhvfNGMBJR+wXEPxcNuZBb0mzMMcuyNDfXjv1
         wc9PzU0nYYdgyfQv9O5h8tbJoSy4kky8dGq4w8TvANKHmHuwQzyPn2YDHPXjeWEP/T
         6ff0ObSU+M5Pf8dPrB9tOuHbg2BAkaojnVCL+rmdMUg383qu42LkwggbzGwOnTylg+
         luuiq1nSrIhkw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
        Solomon Chiu <solomon.chiu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.12 057/134] drm/amd/display: Fix potential memory leak
Date:   Mon,  3 May 2021 12:33:56 -0400
Message-Id: <20210503163513.2851510-57-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163513.2851510-1-sashal@kernel.org>
References: <20210503163513.2851510-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qingqing Zhuo <qingqing.zhuo@amd.com>

[ Upstream commit 51ba691206e35464fd7ec33dd519d141c80b5dff ]

[Why]
vblank_workqueue is never released.

[How]
Free it upon dm finish.

Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Reviewed-by: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
Acked-by: Solomon Chiu <solomon.chiu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 167e04ab9d5b..9c243f66867a 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1191,6 +1191,15 @@ static void amdgpu_dm_fini(struct amdgpu_device *adev)
 	if (adev->dm.dc)
 		dc_deinit_callbacks(adev->dm.dc);
 #endif
+
+#if defined(CONFIG_DRM_AMD_DC_DCN)
+	if (adev->dm.vblank_workqueue) {
+		adev->dm.vblank_workqueue->dm = NULL;
+		kfree(adev->dm.vblank_workqueue);
+		adev->dm.vblank_workqueue = NULL;
+	}
+#endif
+
 	if (adev->dm.dc->ctx->dmub_srv) {
 		dc_dmub_srv_destroy(&adev->dm.dc->ctx->dmub_srv);
 		adev->dm.dc->ctx->dmub_srv = NULL;
-- 
2.30.2

