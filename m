Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4178331BD06
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:39:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbhBOPii (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:38:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:49648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231248AbhBOPhO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:37:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5FEFE64EE1;
        Mon, 15 Feb 2021 15:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403164;
        bh=kAABYYgnm3eDTzaiVQSmhvnBVlVRUqcHETZxpS0fzWc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ci/q9QQc3mJTvW+zRj/6nfDJcmA+tN9nY4DY75pySLNPnbDC2AVLb/7/UQku6orRP
         tQaxhMmnj2CnDIITf9LvRBuUn+TByXD/HRJxTlkT5UmTlgH4DE9JmoDDJ0cXmiO4eS
         274hfpuf8srru1qAKWp8411Os2qVhfw5Biy5Voc4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Eric Anholt <eric@anholt.net>,
        Maxime Ripard <maxime@cerno.tech>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 053/104] drm/vc4: hvs: Fix buffer overflow with the dlist handling
Date:   Mon, 15 Feb 2021 16:27:06 +0100
Message-Id: <20210215152721.190120902@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152719.459796636@linuxfoundation.org>
References: <20210215152719.459796636@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Ripard <maxime@cerno.tech>

[ Upstream commit facd93f4285c405f9a91b05166147cb39e860666 ]

Commit 0a038c1c29a7 ("drm/vc4: Move LBM creation out of
vc4_plane_mode_set()") changed the LBM allocation logic from first
allocating the LBM memory for the plane to running mode_set,
adding a gap in the LBM, and then running the dlist allocation filling
that gap.

The gap was introduced by incrementing the dlist array index, but was
never checking whether or not we were over the array length, leading
eventually to memory corruptions if we ever crossed this limit.

vc4_dlist_write had that logic though, and was reallocating a larger
dlist array when reaching the end of the buffer. Let's share the logic
between both functions.

Cc: Boris Brezillon <boris.brezillon@collabora.com>
Cc: Eric Anholt <eric@anholt.net>
Fixes: 0a038c1c29a7 ("drm/vc4: Move LBM creation out of vc4_plane_mode_set()")
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210129160647.128373-1-maxime@cerno.tech
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_plane.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_plane.c b/drivers/gpu/drm/vc4/vc4_plane.c
index 5612cab552270..af4b8944a6032 100644
--- a/drivers/gpu/drm/vc4/vc4_plane.c
+++ b/drivers/gpu/drm/vc4/vc4_plane.c
@@ -220,7 +220,7 @@ static void vc4_plane_reset(struct drm_plane *plane)
 	__drm_atomic_helper_plane_reset(plane, &vc4_state->base);
 }
 
-static void vc4_dlist_write(struct vc4_plane_state *vc4_state, u32 val)
+static void vc4_dlist_counter_increment(struct vc4_plane_state *vc4_state)
 {
 	if (vc4_state->dlist_count == vc4_state->dlist_size) {
 		u32 new_size = max(4u, vc4_state->dlist_count * 2);
@@ -235,7 +235,15 @@ static void vc4_dlist_write(struct vc4_plane_state *vc4_state, u32 val)
 		vc4_state->dlist_size = new_size;
 	}
 
-	vc4_state->dlist[vc4_state->dlist_count++] = val;
+	vc4_state->dlist_count++;
+}
+
+static void vc4_dlist_write(struct vc4_plane_state *vc4_state, u32 val)
+{
+	unsigned int idx = vc4_state->dlist_count;
+
+	vc4_dlist_counter_increment(vc4_state);
+	vc4_state->dlist[idx] = val;
 }
 
 /* Returns the scl0/scl1 field based on whether the dimensions need to
@@ -978,8 +986,10 @@ static int vc4_plane_mode_set(struct drm_plane *plane,
 		 * be set when calling vc4_plane_allocate_lbm().
 		 */
 		if (vc4_state->y_scaling[0] != VC4_SCALING_NONE ||
-		    vc4_state->y_scaling[1] != VC4_SCALING_NONE)
-			vc4_state->lbm_offset = vc4_state->dlist_count++;
+		    vc4_state->y_scaling[1] != VC4_SCALING_NONE) {
+			vc4_state->lbm_offset = vc4_state->dlist_count;
+			vc4_dlist_counter_increment(vc4_state);
+		}
 
 		if (num_planes > 1) {
 			/* Emit Cb/Cr as channel 0 and Y as channel
-- 
2.27.0



