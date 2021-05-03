Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE36C371B55
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232518AbhECQph (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:45:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:50582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232047AbhECQmj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:42:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A4DD6157E;
        Mon,  3 May 2021 16:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620059890;
        bh=7UHw/pNCJlVRwJ5CrNe4drOoPke6e+nk1r28fBaF5zY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Naxe0xD6f4WLpfn2li8aH+s8DL9eRBVugkJyNWcD7kRsccUf+biQYhLOY1f41ORzw
         f8nOkvndm8PtaN6nBT9426SvWTN43deHhTac3FdXO0qdBDJsVkXb/EIrg+JCH0fSf3
         mze7ZX7m1R5oXrxqlGOxt4b28uIhmo37gf99pzdWuKvqUmDVL7whuDTbzETTBWH85I
         xKRMcOKlGOQ8BqEB+VEG0L1tvwJ7AzWSF6MaQHgCVEKKzUVuQI/zwuoAJ/WHhVntez
         OXouACko4o0Rb2G2jX4B84xHUHTQtpaj4h5jHVosIDEQocUHk9jNaVwS+4MQDPc3/F
         D/TGJjm1VVhwg==
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
Subject: [PATCH AUTOSEL 5.11 046/115] drm/amd/display: Fix UBSAN warning for not a valid value for type '_Bool'
Date:   Mon,  3 May 2021 12:35:50 -0400
Message-Id: <20210503163700.2852194-46-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163700.2852194-1-sashal@kernel.org>
References: <20210503163700.2852194-1-sashal@kernel.org>
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
index fc2763745ae1..2b957d60c7b5 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -7250,10 +7250,6 @@ static int get_cursor_position(struct drm_plane *plane, struct drm_crtc *crtc,
 	int x, y;
 	int xorigin = 0, yorigin = 0;
 
-	position->enable = false;
-	position->x = 0;
-	position->y = 0;
-
 	if (!crtc || !plane->state->fb)
 		return 0;
 
@@ -7300,7 +7296,7 @@ static void handle_cursor_update(struct drm_plane *plane,
 	struct dm_crtc_state *crtc_state = crtc ? to_dm_crtc_state(crtc->state) : NULL;
 	struct amdgpu_crtc *amdgpu_crtc = to_amdgpu_crtc(crtc);
 	uint64_t address = afb ? afb->address : 0;
-	struct dc_cursor_position position;
+	struct dc_cursor_position position = {0};
 	struct dc_cursor_attributes attributes;
 	int ret;
 
-- 
2.30.2

