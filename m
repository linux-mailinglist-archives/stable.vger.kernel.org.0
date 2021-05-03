Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9883371BBB
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233434AbhECQr4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:47:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:50736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232139AbhECQp4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:45:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E2FDD61627;
        Mon,  3 May 2021 16:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620059964;
        bh=Kc3/jYjdXUV2vo541oiEx5cP/sIAfbsWjpGIBRrWKQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WLcJubAoumyWFsholThoPNdyEXCGS79Fuxt6vfosZZi3WP3InnkjIJ5zfB9YTyCZy
         KNv6KvKHSH7bCDqINTIV2+onRMUcmc0MTQF12egyDC6OtxdatcnhFmO4bv5MbPfdA5
         le3BZPOl5fUSs6hhxo+ZGh4HD2OOPp84/T3qdi/dlaYfUBJUy6OMMrGt/vGuzpkOFn
         l3lhOCR8fm9TPXSknDHyewqZoib2v3WMVnMfMv0dol+WIKdU+vB2XP1hXVno5fN3rc
         7B8c6/oA/8O12WcrW06dy2k/r/F+E6ViU/tqz4kmYtKia63H7TRT67aZ6SRNzPIQRU
         Q/CXjioEXLnmw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anson Jacob <Anson.Jacob@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Lyude Paul <lyude@redhat.com>,
        Aurabindo Jayamohanan Pillai <Aurabindo.Pillai@amd.com>,
        Solomon Chiu <solomon.chiu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 036/100] drm/amd/display: Fix UBSAN warning for not a valid value for type '_Bool'
Date:   Mon,  3 May 2021 12:37:25 -0400
Message-Id: <20210503163829.2852775-36-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163829.2852775-1-sashal@kernel.org>
References: <20210503163829.2852775-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anson Jacob <Anson.Jacob@amd.com>

[ Upstream commit 6a30a92997eee49554f72b462dce90abe54a496f ]

[Why]
dc_cursor_position do not initialise position.translate_by_source when
crtc or plane->state->fb is NULL. UBSAN caught this error in
dce110_set_cursor_position, as the value was garbage.

[How]
Initialise dc_cursor_position structure elements to 0 in handle_cursor_update
before calling get_cursor_position.

Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1471
Reported-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Anson Jacob <Anson.Jacob@amd.com>
Reviewed-by: Aurabindo Jayamohanan Pillai <Aurabindo.Pillai@amd.com>
Acked-by: Solomon Chiu <solomon.chiu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 830d302be045..12a4f0675fb0 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -6800,10 +6800,6 @@ static int get_cursor_position(struct drm_plane *plane, struct drm_crtc *crtc,
 	int x, y;
 	int xorigin = 0, yorigin = 0;
 
-	position->enable = false;
-	position->x = 0;
-	position->y = 0;
-
 	if (!crtc || !plane->state->fb)
 		return 0;
 
@@ -6850,7 +6846,7 @@ static void handle_cursor_update(struct drm_plane *plane,
 	struct dm_crtc_state *crtc_state = crtc ? to_dm_crtc_state(crtc->state) : NULL;
 	struct amdgpu_crtc *amdgpu_crtc = to_amdgpu_crtc(crtc);
 	uint64_t address = afb ? afb->address : 0;
-	struct dc_cursor_position position;
+	struct dc_cursor_position position = {0};
 	struct dc_cursor_attributes attributes;
 	int ret;
 
-- 
2.30.2

