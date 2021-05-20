Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7338138A10C
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:26:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232080AbhETJ2A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:28:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:53244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231680AbhETJ1M (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:27:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97C75613AD;
        Thu, 20 May 2021 09:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621502751;
        bh=T/inIGMNNUhjyeV6rD7o+aCemA0Lhcn3vQlXzVHhUmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gKB6nr50yRkZAZ4R4E0tkag/tuV0nIKnIztjw0HHIVK2WPV9NWw6rj+mtA/8fuAg5
         73sOacrWsRDXfbBA+iDcA5sQnkNYq7l4nTxeog2KSSd90fJW79GnUYUe5+P1cKtoWR
         k0KW23YutthuQi05BP21+LJn9jVZh5Uwg/xuEUGE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Louis Li <Ching-shih.Li@amd.com>,
        Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
        Harry Wentland <Harry.Wentland@amd.com>,
        Hersen Wu <hersenxs.wu@amd.com>,
        Sean Paul <seanpaul@chromium.org>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 35/45] drm/amd/display: Fix two cursor duplication when using overlay
Date:   Thu, 20 May 2021 11:22:23 +0200
Message-Id: <20210520092054.658264304@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092053.516042993@linuxfoundation.org>
References: <20210520092053.516042993@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>

[ Upstream commit 16e9b3e58bc3fce7391539e0eb3fd167cbf9951f ]

Our driver supports overlay planes, and as expected, some userspace
compositor takes advantage of these features. If the userspace is not
enabling the cursor, they can use multiple planes as they please.
Nevertheless, we start to have constraints when userspace tries to
enable hardware cursor with various planes. Basically, we cannot draw
the cursor at the same size and position on two separated pipes since it
uses extra bandwidth and DML only run with one cursor.

For those reasons, when we enable hardware cursor and multiple planes,
our driver should accept variations like the ones described below:

  +-------------+   +--------------+
  | +---------+ |   |              |
  | |Primary  | |   | Primary      |
  | |         | |   | Overlay      |
  | +---------+ |   |              |
  |Overlay      |   |              |
  +-------------+   +--------------+

In this scenario, we can have the desktop UI in the overlay and some
other framebuffer attached to the primary plane (e.g., video). However,
userspace needs to obey some rules and avoid scenarios like the ones
described below (when enabling hw cursor):

                                      +--------+
                                      |Overlay |
 +-------------+    +-----+-------+ +-|        |--+
 | +--------+  | +--------+       | | +--------+  |
 | |Overlay |  | |Overlay |       | |             |
 | |        |  | |        |       | |             |
 | +--------+  | +--------+       | |             |
 | Primary     |    | Primary     | | Primary     |
 +-------------+    +-------------+ +-------------+

 +-------------+   +-------------+
 |     +--------+  |  Primary    |
 |     |Overlay |  |             |
 |     |        |  |             |
 |     +--------+  | +--------+  |
 | Primary     |   | |Overlay |  |
 +-------------+   +-|        |--+
                     +--------+

If the userspace violates some of the above scenarios, our driver needs
to reject the commit; otherwise, we can have unexpected behavior. Since
we don't have a proper driver validation for the above case, we can see
some problems like a duplicate cursor in applications that use multiple
planes. This commit fixes the cursor issue and others by adding adequate
verification for multiple planes.

Change since V1 (Harry and Sean):
- Remove cursor verification from the equation.

Cc: Louis Li <Ching-shih.Li@amd.com>
Cc: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
Cc: Harry Wentland <Harry.Wentland@amd.com>
Cc: Hersen Wu <hersenxs.wu@amd.com>
Cc: Sean Paul <seanpaul@chromium.org>
Signed-off-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 51 +++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 71e07ebc8f88..b63f55ea8758 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -9344,6 +9344,53 @@ static int add_affected_mst_dsc_crtcs(struct drm_atomic_state *state, struct drm
 }
 #endif
 
+static int validate_overlay(struct drm_atomic_state *state)
+{
+	int i;
+	struct drm_plane *plane;
+	struct drm_plane_state *old_plane_state, *new_plane_state;
+	struct drm_plane_state *primary_state, *overlay_state = NULL;
+
+	/* Check if primary plane is contained inside overlay */
+	for_each_oldnew_plane_in_state_reverse(state, plane, old_plane_state, new_plane_state, i) {
+		if (plane->type == DRM_PLANE_TYPE_OVERLAY) {
+			if (drm_atomic_plane_disabling(plane->state, new_plane_state))
+				return 0;
+
+			overlay_state = new_plane_state;
+			continue;
+		}
+	}
+
+	/* check if we're making changes to the overlay plane */
+	if (!overlay_state)
+		return 0;
+
+	/* check if overlay plane is enabled */
+	if (!overlay_state->crtc)
+		return 0;
+
+	/* find the primary plane for the CRTC that the overlay is enabled on */
+	primary_state = drm_atomic_get_plane_state(state, overlay_state->crtc->primary);
+	if (IS_ERR(primary_state))
+		return PTR_ERR(primary_state);
+
+	/* check if primary plane is enabled */
+	if (!primary_state->crtc)
+		return 0;
+
+	/* Perform the bounds check to ensure the overlay plane covers the primary */
+	if (primary_state->crtc_x < overlay_state->crtc_x ||
+	    primary_state->crtc_y < overlay_state->crtc_y ||
+	    primary_state->crtc_x + primary_state->crtc_w > overlay_state->crtc_x + overlay_state->crtc_w ||
+	    primary_state->crtc_y + primary_state->crtc_h > overlay_state->crtc_y + overlay_state->crtc_h) {
+		DRM_DEBUG_ATOMIC("Overlay plane is enabled with hardware cursor but does not fully cover primary plane\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 /**
  * amdgpu_dm_atomic_check() - Atomic check implementation for AMDgpu DM.
  * @dev: The DRM device
@@ -9518,6 +9565,10 @@ static int amdgpu_dm_atomic_check(struct drm_device *dev,
 			goto fail;
 	}
 
+	ret = validate_overlay(state);
+	if (ret)
+		goto fail;
+
 	/* Add new/modified planes */
 	for_each_oldnew_plane_in_state_reverse(state, plane, old_plane_state, new_plane_state, i) {
 		ret = dm_update_plane_state(dc, state, plane,
-- 
2.30.2



