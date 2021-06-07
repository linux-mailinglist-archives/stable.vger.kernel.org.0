Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C709439E233
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 18:16:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232167AbhFGQPr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 12:15:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:48600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231423AbhFGQPE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 12:15:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3FDD261418;
        Mon,  7 Jun 2021 16:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082389;
        bh=p4wmOn+TNC5YGsNrtgkO02CFSowApYNpV1fmt6+KvXE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oxWbWiQr3Qy5NhZB6mf+5pmHW5wNMTVxMK+I2FfkjWglsTdEd/D6M+HBVAOCpLuWd
         4H3ZmicOZ+qXoairuFAy2CFrf0au51E07WQ8Ha383NkgjN273db35XS+bKN6ojYY/t
         oTXlH1f4JgicgRIjWlcizCVIqBeMj34YA3jV9lCj4R2RXy2yuP34lnvpQiT1nZQvFT
         o4xVfmmdj53qvq52NaVH9UwGc1JHOB51trmRlwADeZTqQObd/F2+nC/MrW28QRUmCi
         zrlQIMdI2ZECNHaOmYdRKnxc7iwRJbOLrFk9hnS9KYV1BeCbshCeaRJmdswzdUc0sf
         ldSz2QoEBsBLw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        "Tianci . Yin" <tianci.yin@amd.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Nicholas Choi <nicholas.choi@amd.com>,
        Bhawanpreet Lakha <bhawanpreet.lakha@amd.com>,
        Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
        Mark Yacoub <markyacoub@google.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.12 43/49] drm/amd/display: Fix overlay validation by considering cursors
Date:   Mon,  7 Jun 2021 12:12:09 -0400
Message-Id: <20210607161215.3583176-43-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161215.3583176-1-sashal@kernel.org>
References: <20210607161215.3583176-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>

[ Upstream commit 33f409e60eb0c59a4d0d06a62ab4642a988e17f7 ]

A few weeks ago, we saw a two cursor issue in a ChromeOS system. We
fixed it in the commit:

 drm/amd/display: Fix two cursor duplication when using overlay
 (read the commit message for more details)

After this change, we noticed that some IGT subtests related to
kms_plane and kms_plane_scaling started to fail. After investigating
this issue, we noticed that all subtests that fail have a primary plane
covering the overlay plane, which is currently rejected by amdgpu dm.
Fail those IGT tests highlight that our verification was too broad and
compromises the overlay usage in our drive. This patch fixes this issue
by ensuring that we only reject commits where the primary plane is not
fully covered by the overlay when the cursor hardware is enabled. With
this fix, all IGT tests start to pass again, which means our overlay
support works as expected.

Cc: Tianci.Yin <tianci.yin@amd.com>
Cc: Harry Wentland <harry.wentland@amd.com>
Cc: Nicholas Choi <nicholas.choi@amd.com>
Cc: Bhawanpreet Lakha <bhawanpreet.lakha@amd.com>
Cc: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
Cc: Mark Yacoub <markyacoub@google.com>
Cc: Daniel Wheeler <daniel.wheeler@amd.com>

Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index b63f55ea8758..69023b4b0a8b 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -9349,7 +9349,7 @@ static int validate_overlay(struct drm_atomic_state *state)
 	int i;
 	struct drm_plane *plane;
 	struct drm_plane_state *old_plane_state, *new_plane_state;
-	struct drm_plane_state *primary_state, *overlay_state = NULL;
+	struct drm_plane_state *primary_state, *cursor_state, *overlay_state = NULL;
 
 	/* Check if primary plane is contained inside overlay */
 	for_each_oldnew_plane_in_state_reverse(state, plane, old_plane_state, new_plane_state, i) {
@@ -9379,6 +9379,14 @@ static int validate_overlay(struct drm_atomic_state *state)
 	if (!primary_state->crtc)
 		return 0;
 
+	/* check if cursor plane is enabled */
+	cursor_state = drm_atomic_get_plane_state(state, overlay_state->crtc->cursor);
+	if (IS_ERR(cursor_state))
+		return PTR_ERR(cursor_state);
+
+	if (drm_atomic_plane_disabling(plane->state, cursor_state))
+		return 0;
+
 	/* Perform the bounds check to ensure the overlay plane covers the primary */
 	if (primary_state->crtc_x < overlay_state->crtc_x ||
 	    primary_state->crtc_y < overlay_state->crtc_y ||
-- 
2.30.2

