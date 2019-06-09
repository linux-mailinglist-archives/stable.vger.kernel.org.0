Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B3F93AAC1
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729464AbfFIRV2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 13:21:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:43842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730126AbfFIQpx (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:45:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A81B20833;
        Sun,  9 Jun 2019 16:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560098752;
        bh=2hmnF4XbiYzaLjNdH4KcV6WLN+C49zVKNABkve9f/FQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w5Gz4pWRM3DVCfHJuw56GPkRk99/kRBuSgdiRCFMd/IFX3835aWyRWD6oM1cJAYw9
         y9dkAXCJL2+c+LOkBMgBYacFOZUqNBCzxv6je0C5VpmAvs8hI9SJNpJ6zLsi+Gfsok
         +jVgFOMcMgN1cS6MuNpTfqcBO+a8/uwSeXdFGPpQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helen Koike <helen.koike@collabora.com>,
        Boris Brezillon <boris.brezillon@collabora.com>
Subject: [PATCH 5.1 49/70] drm/rockchip: fix fb references in async update
Date:   Sun,  9 Jun 2019 18:42:00 +0200
Message-Id: <20190609164131.535974639@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164127.541128197@linuxfoundation.org>
References: <20190609164127.541128197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helen Koike <helen.koike@collabora.com>

commit d985a3533274ef7dd1ccb25cb05a72259b25268f upstream.

In the case of async update, modifications are done in place, i.e. in the
current plane state, so the new_state is prepared and the new_state is
cleaned up (instead of the old_state, unlike what happens in a
normal sync update).
To cleanup the old_fb properly, it needs to be placed in the new_state
in the end of async_update, so cleanup call will unreference the old_fb
correctly.

Also, the previous code had a:

	plane_state = plane->funcs->atomic_duplicate_state(plane);
	...
	swap(plane_state, plane->state);

	if (plane->state->fb && plane->state->fb != new_state->fb) {
	...
	}

Which was wrong, as the fb were just assigned to be equal, so this if
statement nevers evaluates to true.

Another details is that the function drm_crtc_vblank_get() can only be
called when vop->is_enabled is true, otherwise it has no effect and
trows a WARN_ON().

Calling drm_atomic_set_fb_for_plane() (which get a referent of the new
fb and pus the old fb) is not required, as it is taken care by
drm_mode_cursor_universal() when calling
drm_atomic_helper_update_plane().

Fixes: 15609559a834 ("drm/rockchip: update cursors asynchronously through atomic.")
Cc: <stable@vger.kernel.org> # v4.20+
Signed-off-by: Helen Koike <helen.koike@collabora.com>
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190603165610.24614-2-helen.koike@collabora.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/rockchip/rockchip_drm_vop.c |   49 ++++++++++++++--------------
 1 file changed, 25 insertions(+), 24 deletions(-)

--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
@@ -924,29 +924,17 @@ static void vop_plane_atomic_async_updat
 					  struct drm_plane_state *new_state)
 {
 	struct vop *vop = to_vop(plane->state->crtc);
-	struct drm_plane_state *plane_state;
+	struct drm_framebuffer *old_fb = plane->state->fb;
 
-	plane_state = plane->funcs->atomic_duplicate_state(plane);
-	plane_state->crtc_x = new_state->crtc_x;
-	plane_state->crtc_y = new_state->crtc_y;
-	plane_state->crtc_h = new_state->crtc_h;
-	plane_state->crtc_w = new_state->crtc_w;
-	plane_state->src_x = new_state->src_x;
-	plane_state->src_y = new_state->src_y;
-	plane_state->src_h = new_state->src_h;
-	plane_state->src_w = new_state->src_w;
-
-	if (plane_state->fb != new_state->fb)
-		drm_atomic_set_fb_for_plane(plane_state, new_state->fb);
-
-	swap(plane_state, plane->state);
-
-	if (plane->state->fb && plane->state->fb != new_state->fb) {
-		drm_framebuffer_get(plane->state->fb);
-		WARN_ON(drm_crtc_vblank_get(plane->state->crtc) != 0);
-		drm_flip_work_queue(&vop->fb_unref_work, plane->state->fb);
-		set_bit(VOP_PENDING_FB_UNREF, &vop->pending);
-	}
+	plane->state->crtc_x = new_state->crtc_x;
+	plane->state->crtc_y = new_state->crtc_y;
+	plane->state->crtc_h = new_state->crtc_h;
+	plane->state->crtc_w = new_state->crtc_w;
+	plane->state->src_x = new_state->src_x;
+	plane->state->src_y = new_state->src_y;
+	plane->state->src_h = new_state->src_h;
+	plane->state->src_w = new_state->src_w;
+	swap(plane->state->fb, new_state->fb);
 
 	if (vop->is_enabled) {
 		rockchip_drm_psr_inhibit_get_state(new_state->state);
@@ -955,9 +943,22 @@ static void vop_plane_atomic_async_updat
 		vop_cfg_done(vop);
 		spin_unlock(&vop->reg_lock);
 		rockchip_drm_psr_inhibit_put_state(new_state->state);
-	}
 
-	plane->funcs->atomic_destroy_state(plane, plane_state);
+		/*
+		 * A scanout can still be occurring, so we can't drop the
+		 * reference to the old framebuffer. To solve this we get a
+		 * reference to old_fb and set a worker to release it later.
+		 * FIXME: if we perform 500 async_update calls before the
+		 * vblank, then we can have 500 different framebuffers waiting
+		 * to be released.
+		 */
+		if (old_fb && plane->state->fb != old_fb) {
+			drm_framebuffer_get(old_fb);
+			WARN_ON(drm_crtc_vblank_get(plane->state->crtc) != 0);
+			drm_flip_work_queue(&vop->fb_unref_work, old_fb);
+			set_bit(VOP_PENDING_FB_UNREF, &vop->pending);
+		}
+	}
 }
 
 static const struct drm_plane_helper_funcs plane_helper_funcs = {


