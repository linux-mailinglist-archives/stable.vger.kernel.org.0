Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AACE3A9F9F
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 17:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235065AbhFPPja (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 11:39:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:50334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235072AbhFPPiV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 11:38:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 304BD61166;
        Wed, 16 Jun 2021 15:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623857767;
        bh=d2ZN03nQKfadh+LSeiMEoiYz2/mAdXM3bE/ciLZ2Ndw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RA+tU+6HSNGwoJ5DWLkb+hF8I4Cnvbhdkn9R6Oi1Kk9oD3XcsSDCsl3GolC9glACA
         wzMonRrrzufX+eJ5NYMcGAO57VY5e4XSuU82pXhc/6Hyvhf2xG0P3rXtwIvLabwucl
         OvxO1rkg7sPBE9E1g62nm3AnB3pUvvxUZBFe4Fk4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Tianci.Yin" <tianci.yin@amd.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Nicholas Choi <nicholas.choi@amd.com>,
        Bhawanpreet Lakha <bhawanpreet.lakha@amd.com>,
        Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
        Mark Yacoub <markyacoub@google.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 32/38] drm/amd/display: Fix overlay validation by considering cursors
Date:   Wed, 16 Jun 2021 17:33:41 +0200
Message-Id: <20210616152836.409676264@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210616152835.407925718@linuxfoundation.org>
References: <20210616152835.407925718@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index fbbb1bde6b06..4792228ed481 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -8616,7 +8616,7 @@ static int validate_overlay(struct drm_atomic_state *state)
 	int i;
 	struct drm_plane *plane;
 	struct drm_plane_state *old_plane_state, *new_plane_state;
-	struct drm_plane_state *primary_state, *overlay_state = NULL;
+	struct drm_plane_state *primary_state, *cursor_state, *overlay_state = NULL;
 
 	/* Check if primary plane is contained inside overlay */
 	for_each_oldnew_plane_in_state_reverse(state, plane, old_plane_state, new_plane_state, i) {
@@ -8646,6 +8646,14 @@ static int validate_overlay(struct drm_atomic_state *state)
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



