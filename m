Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0E88378624
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233554AbhEJLEM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:04:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:53004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234960AbhEJK5T (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:57:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 340DA6162E;
        Mon, 10 May 2021 10:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643834;
        bh=7UHw/pNCJlVRwJ5CrNe4drOoPke6e+nk1r28fBaF5zY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2hcj8WF1+qb3v9DoFoa4KqP7JiiidaZHFX+x6BQd3p8HX/UQ8AMLR9lS3jFvaX2QA
         w90eTp9Rgw+7d/Wni0p1o3FOcjv+Nlw/wpHMytE345Gctl3YJ0vFeF8oQJFvo/abCU
         h3fRQ7h6sMvTj4WOc1ij8+Lsa7R7vnjQ2cpH2eBA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Wheeler <daniel.wheeler@amd.com>,
        Lyude Paul <lyude@redhat.com>,
        Anson Jacob <Anson.Jacob@amd.com>,
        Aurabindo Jayamohanan Pillai <Aurabindo.Pillai@amd.com>,
        Solomon Chiu <solomon.chiu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 171/342] drm/amd/display: Fix UBSAN warning for not a valid value for type _Bool
Date:   Mon, 10 May 2021 12:19:21 +0200
Message-Id: <20210510102015.760993537@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



