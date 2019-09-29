Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A128C158F
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 16:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729272AbfI2OAy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 10:00:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:42916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729244AbfI2OAy (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 10:00:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5CCED2082F;
        Sun, 29 Sep 2019 14:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569765653;
        bh=GvRHzuZ9n5ZclAM+ZZmd5DVPZsbXsaErbdvLbC5k65U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s3GlVV/fp0LBCAZeRU3z6Cbn6yrKYbWmRlLO6hKHZ4EvpCgbXl8A1KJ16TTK+YQGx
         4yK0yoqVX2QBp7z/EyRWA4uSIBjSpKGFQE1uxa0E3b1emh8Iznd/N1HLbbvEMpyKKS
         vGrpjrSk5eF0OG9xgbH91jV2O12c9tGzRJ5xYdWk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        David Francis <david.francis@amd.com>
Subject: [PATCH 5.2 06/45] drm/amd/display: Allow cursor async updates for framebuffer swaps
Date:   Sun, 29 Sep 2019 15:55:34 +0200
Message-Id: <20190929135026.613359381@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190929135024.387033930@linuxfoundation.org>
References: <20190929135024.387033930@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

commit e16e37efb4c9eb7bcb9dab756c975040c5257e98 upstream.

[Why]
We previously allowed framebuffer swaps as async updates for cursor
planes but had to disable them due to a bug in DRM with async update
handling and incorrect ref counting. The check to block framebuffer
swaps has been added to DRM for a while now, so this check is redundant.

The real fix that allows this to properly in DRM has also finally been
merged and is getting backported into stable branches, so dropping
this now seems to be the right time to do so.

[How]
Drop the redundant check for old_fb != new_fb.

With the proper fix in DRM, this should also fix some cursor stuttering
issues with xf86-video-amdgpu since it double buffers the cursor.

IGT tests that swap framebuffers (-varying-size for example) should
also pass again.

Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: David Francis <david.francis@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   10 ----------
 1 file changed, 10 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -4209,20 +4209,10 @@ static int dm_plane_atomic_check(struct
 static int dm_plane_atomic_async_check(struct drm_plane *plane,
 				       struct drm_plane_state *new_plane_state)
 {
-	struct drm_plane_state *old_plane_state =
-		drm_atomic_get_old_plane_state(new_plane_state->state, plane);
-
 	/* Only support async updates on cursor planes. */
 	if (plane->type != DRM_PLANE_TYPE_CURSOR)
 		return -EINVAL;
 
-	/*
-	 * DRM calls prepare_fb and cleanup_fb on new_plane_state for
-	 * async commits so don't allow fb changes.
-	 */
-	if (old_plane_state->fb != new_plane_state->fb)
-		return -EINVAL;
-
 	return 0;
 }
 


