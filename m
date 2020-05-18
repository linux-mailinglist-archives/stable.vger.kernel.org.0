Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05F9D1D8412
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733101AbgERSGE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:06:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:53814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733087AbgERSF6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:05:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F3662087D;
        Mon, 18 May 2020 18:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589825157;
        bh=fB+roZHtIxggYejk2OF7luJkFNMNH6aS08BxOIv9KII=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=StB1YKkzsDU9acBW1T4GWmOP5Zh3sM7/JXaEcGVIGEYgz9H2x5EgTw6JtSoBV1NsC
         tPNxnjiHJzaoDzvWDZMU0B9Zlvp5yRStGEoris/3u6A4Z/bFnuJ74aJSlB+OA/AIo0
         uUjqlAv5PGvJj6e9hZOuIwPSdf74M4GlKC5qbews=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Simon Ser <contact@emersion.fr>,
        Roman Gilg <subdiff@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Harry Wentland <hwentlan@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Subject: [PATCH 5.6 151/194] drm/amd/display: add basic atomic check for cursor plane
Date:   Mon, 18 May 2020 19:37:21 +0200
Message-Id: <20200518173543.827591423@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Simon Ser <contact@emersion.fr>

commit 626bf90fe03fa080d8df06bb0397c95c53ae8e27 upstream.

This patch adds a basic cursor check when an atomic test-only commit is
performed. The position and size of the cursor plane is checked.

This should fix user-space relying on atomic checks to assign buffers to
planes.

Signed-off-by: Simon Ser <contact@emersion.fr>
Reported-by: Roman Gilg <subdiff@gmail.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Harry Wentland <hwentlan@amd.com>
Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   26 ++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -7716,6 +7716,7 @@ static int dm_update_plane_state(struct
 	struct drm_crtc_state *old_crtc_state, *new_crtc_state;
 	struct dm_crtc_state *dm_new_crtc_state, *dm_old_crtc_state;
 	struct dm_plane_state *dm_new_plane_state, *dm_old_plane_state;
+	struct amdgpu_crtc *new_acrtc;
 	bool needs_reset;
 	int ret = 0;
 
@@ -7725,9 +7726,30 @@ static int dm_update_plane_state(struct
 	dm_new_plane_state = to_dm_plane_state(new_plane_state);
 	dm_old_plane_state = to_dm_plane_state(old_plane_state);
 
-	/*TODO Implement atomic check for cursor plane */
-	if (plane->type == DRM_PLANE_TYPE_CURSOR)
+	/*TODO Implement better atomic check for cursor plane */
+	if (plane->type == DRM_PLANE_TYPE_CURSOR) {
+		if (!enable || !new_plane_crtc ||
+			drm_atomic_plane_disabling(plane->state, new_plane_state))
+			return 0;
+
+		new_acrtc = to_amdgpu_crtc(new_plane_crtc);
+
+		if ((new_plane_state->crtc_w > new_acrtc->max_cursor_width) ||
+			(new_plane_state->crtc_h > new_acrtc->max_cursor_height)) {
+			DRM_DEBUG_ATOMIC("Bad cursor size %d x %d\n",
+							 new_plane_state->crtc_w, new_plane_state->crtc_h);
+			return -EINVAL;
+		}
+
+		if (new_plane_state->crtc_x <= -new_acrtc->max_cursor_width ||
+			new_plane_state->crtc_y <= -new_acrtc->max_cursor_height) {
+			DRM_DEBUG_ATOMIC("Bad cursor position %d, %d\n",
+							 new_plane_state->crtc_x, new_plane_state->crtc_y);
+			return -EINVAL;
+		}
+
 		return 0;
+	}
 
 	needs_reset = should_reset_plane(state, plane, old_plane_state,
 					 new_plane_state);


