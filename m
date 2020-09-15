Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07DFC26B505
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727160AbgIOXfW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:35:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:47652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726890AbgIOOgI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:36:08 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34D48222D9;
        Tue, 15 Sep 2020 14:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179974;
        bh=OdV+oL+uQ+QuGfYJpLfnkahfqYvexPdvQFWqPtet8IA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UVb6l54BQ/ePH/yZo1D+PUXz+RP/VzKRlCCzMStKtitEuwhUMV2KgrZ5PxEdWSn4Z
         ZP7e6G+f5G3CwCW5fF6idG6LGd5NkTZryRCag3+BEsX9HMZSwJc6qMMwd0QkQx1WvT
         Y91AQJiAERR1/eja1nY6llSkocQA2TeyTFwNMBJY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, 1882851@bugs.launchpad.net,
        Gerd Hoffmann <kraxel@redhat.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Diego Viola <diego.viola@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 029/177] drm/virtio: fix unblank
Date:   Tue, 15 Sep 2020 16:11:40 +0200
Message-Id: <20200915140655.034933308@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gerd Hoffmann <kraxel@redhat.com>

[ Upstream commit c6016c6e39c3ee8fd671532520be3cc13e439db2 ]

When going through a disable/enable cycle without changing the
framebuffer the optimization added by commit 3954ff10e06e ("drm/virtio:
skip set_scanout if framebuffer didn't change") causes the screen stay
blank.  Add a bool to force an update to fix that.

v2: use drm_atomic_crtc_needs_modeset() (Daniel).

Cc: 1882851@bugs.launchpad.net
Fixes: 3954ff10e06e ("drm/virtio: skip set_scanout if framebuffer didn't change")
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Tested-by: Jiri Slaby <jirislaby@kernel.org>
Tested-by: Diego Viola <diego.viola@gmail.com>
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: http://patchwork.freedesktop.org/patch/msgid/20200818072511.6745-2-kraxel@redhat.com
(cherry picked from commit 1bc371cd0ec907bab870cacb6e898105f9c41dc8)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/virtio/virtgpu_display.c | 11 +++++++++++
 drivers/gpu/drm/virtio/virtgpu_drv.h     |  1 +
 drivers/gpu/drm/virtio/virtgpu_plane.c   |  4 +++-
 3 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/virtio/virtgpu_display.c b/drivers/gpu/drm/virtio/virtgpu_display.c
index cc7fd957a3072..2b8421a35ab94 100644
--- a/drivers/gpu/drm/virtio/virtgpu_display.c
+++ b/drivers/gpu/drm/virtio/virtgpu_display.c
@@ -123,6 +123,17 @@ static int virtio_gpu_crtc_atomic_check(struct drm_crtc *crtc,
 static void virtio_gpu_crtc_atomic_flush(struct drm_crtc *crtc,
 					 struct drm_crtc_state *old_state)
 {
+	struct virtio_gpu_output *output = drm_crtc_to_virtio_gpu_output(crtc);
+
+	/*
+	 * virtio-gpu can't do modeset and plane update operations
+	 * independent from each other.  So the actual modeset happens
+	 * in the plane update callback, and here we just check
+	 * whenever we must force the modeset.
+	 */
+	if (drm_atomic_crtc_needs_modeset(crtc->state)) {
+		output->needs_modeset = true;
+	}
 }
 
 static const struct drm_crtc_helper_funcs virtio_gpu_crtc_helper_funcs = {
diff --git a/drivers/gpu/drm/virtio/virtgpu_drv.h b/drivers/gpu/drm/virtio/virtgpu_drv.h
index 9ff9f4ac0522a..4ab1b0ba29253 100644
--- a/drivers/gpu/drm/virtio/virtgpu_drv.h
+++ b/drivers/gpu/drm/virtio/virtgpu_drv.h
@@ -138,6 +138,7 @@ struct virtio_gpu_output {
 	int cur_x;
 	int cur_y;
 	bool enabled;
+	bool needs_modeset;
 };
 #define drm_crtc_to_virtio_gpu_output(x) \
 	container_of(x, struct virtio_gpu_output, crtc)
diff --git a/drivers/gpu/drm/virtio/virtgpu_plane.c b/drivers/gpu/drm/virtio/virtgpu_plane.c
index 52d24179bcecc..65757409d9ed1 100644
--- a/drivers/gpu/drm/virtio/virtgpu_plane.c
+++ b/drivers/gpu/drm/virtio/virtgpu_plane.c
@@ -163,7 +163,9 @@ static void virtio_gpu_primary_plane_update(struct drm_plane *plane,
 	    plane->state->src_w != old_state->src_w ||
 	    plane->state->src_h != old_state->src_h ||
 	    plane->state->src_x != old_state->src_x ||
-	    plane->state->src_y != old_state->src_y) {
+	    plane->state->src_y != old_state->src_y ||
+	    output->needs_modeset) {
+		output->needs_modeset = false;
 		DRM_DEBUG("handle 0x%x, crtc %dx%d+%d+%d, src %dx%d+%d+%d\n",
 			  bo->hw_res_handle,
 			  plane->state->crtc_w, plane->state->crtc_h,
-- 
2.25.1



