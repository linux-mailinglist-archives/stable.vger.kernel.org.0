Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84930335A2
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 18:57:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729829AbfFCQ5E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 12:57:04 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:35428 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727227AbfFCQ5D (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jun 2019 12:57:03 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: koike)
        with ESMTPSA id 1DD31284FB7
From:   Helen Koike <helen.koike@collabora.com>
To:     dri-devel@lists.freedesktop.org, nicholas.kazlauskas@amd.com
Cc:     andrey.grodzovsky@amd.com, daniel.vetter@ffwll.ch,
        linux-kernel@vger.kernel.org, Tomasz Figa <tfiga@chromium.org>,
        boris.brezillon@collabora.com, David Airlie <airlied@linux.ie>,
        Sean Paul <seanpaul@google.com>, kernel@collabora.com,
        harry.wentland@amd.com,
        =?UTF-8?q?St=C3=A9phane=20Marchesin?= <marcheu@google.com>,
        Helen Koike <helen.koike@collabora.com>,
        stable@vger.kernel.org, Sean Paul <sean@poorly.run>,
        Sandy Huang <hjc@rock-chips.com>,
        linux-rockchip@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        eric@anholt.net, robdclark@gmail.com,
        amd-gfx@lists.freedesktop.org,
        =?UTF-8?q?Heiko=20St=C3=BCbner?= <heiko@sntech.de>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        freedreno@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: [PATCH v4 5/5] drm: don't block fb changes for async plane updates
Date:   Mon,  3 Jun 2019 13:56:10 -0300
Message-Id: <20190603165610.24614-6-helen.koike@collabora.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190603165610.24614-1-helen.koike@collabora.com>
References: <20190603165610.24614-1-helen.koike@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In the case of a normal sync update, the preparation of framebuffers (be
it calling drm_atomic_helper_prepare_planes() or doing setups with
drm_framebuffer_get()) are performed in the new_state and the respective
cleanups are performed in the old_state.

In the case of async updates, the preparation is also done in the
new_state but the cleanups are done in the new_state (because updates
are performed in place, i.e. in the current state).

The current code blocks async udpates when the fb is changed, turning
async updates into sync updates, slowing down cursor updates and
introducing regressions in igt tests with errors of type:

"CRITICAL: completed 97 cursor updated in a period of 30 flips, we
expect to complete approximately 15360 updates, with the threshold set
at 7680"

Fb changes in async updates were prevented to avoid the following scenario:

- Async update, oldfb = NULL, newfb = fb1, prepare fb1, cleanup fb1
- Async update, oldfb = fb1, newfb = fb2, prepare fb2, cleanup fb2
- Non-async commit, oldfb = fb2, newfb = fb1, prepare fb1, cleanup fb2 (wrong)
Where we have a single call to prepare fb2 but double cleanup call to fb2.

To solve the above problems, instead of blocking async fb changes, we
place the old framebuffer in the new_state object, so when the code
performs cleanups in the new_state it will cleanup the old_fb and we
will have the following scenario instead:

- Async update, oldfb = NULL, newfb = fb1, prepare fb1, no cleanup
- Async update, oldfb = fb1, newfb = fb2, prepare fb2, cleanup fb1
- Non-async commit, oldfb = fb2, newfb = fb1, prepare fb1, cleanup fb2

Where calls to prepare/cleanup are balanced.

Cc: <stable@vger.kernel.org> # v4.14+
Fixes: 25dc194b34dd ("drm: Block fb changes for async plane updates")
Suggested-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Helen Koike <helen.koike@collabora.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

---

Changes in v4:
- update docs in atomic_async_update callback

Changes in v3:
- Add Reviewed-by tags
- Add TODO in drm_atomic_helper_async_commit()

Changes in v2:
- Change the order of the patch in the series, add this as the last one.
- Add documentation
- s/ballanced/balanced

 drivers/gpu/drm/drm_atomic_helper.c      | 22 ++++++++++++----------
 include/drm/drm_modeset_helper_vtables.h |  8 ++++++++
 2 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/drm_atomic_helper.c b/drivers/gpu/drm/drm_atomic_helper.c
index acf993cb8e52..ac81d8440b40 100644
--- a/drivers/gpu/drm/drm_atomic_helper.c
+++ b/drivers/gpu/drm/drm_atomic_helper.c
@@ -1610,15 +1610,6 @@ int drm_atomic_helper_async_check(struct drm_device *dev,
 	    old_plane_state->crtc != new_plane_state->crtc)
 		return -EINVAL;
 
-	/*
-	 * FIXME: Since prepare_fb and cleanup_fb are always called on
-	 * the new_plane_state for async updates we need to block framebuffer
-	 * changes. This prevents use of a fb that's been cleaned up and
-	 * double cleanups from occuring.
-	 */
-	if (old_plane_state->fb != new_plane_state->fb)
-		return -EINVAL;
-
 	funcs = plane->helper_private;
 	if (!funcs->atomic_async_update)
 		return -EINVAL;
@@ -1649,6 +1640,8 @@ EXPORT_SYMBOL(drm_atomic_helper_async_check);
  * drm_atomic_async_check() succeeds. Async commits are not supposed to swap
  * the states like normal sync commits, but just do in-place changes on the
  * current state.
+ *
+ * TODO: Implement full swap instead of doing in-place changes.
  */
 void drm_atomic_helper_async_commit(struct drm_device *dev,
 				    struct drm_atomic_state *state)
@@ -1659,6 +1652,9 @@ void drm_atomic_helper_async_commit(struct drm_device *dev,
 	int i;
 
 	for_each_new_plane_in_state(state, plane, plane_state, i) {
+		struct drm_framebuffer *new_fb = plane_state->fb;
+		struct drm_framebuffer *old_fb = plane->state->fb;
+
 		funcs = plane->helper_private;
 		funcs->atomic_async_update(plane, plane_state);
 
@@ -1667,11 +1663,17 @@ void drm_atomic_helper_async_commit(struct drm_device *dev,
 		 * plane->state in-place, make sure at least common
 		 * properties have been properly updated.
 		 */
-		WARN_ON_ONCE(plane->state->fb != plane_state->fb);
+		WARN_ON_ONCE(plane->state->fb != new_fb);
 		WARN_ON_ONCE(plane->state->crtc_x != plane_state->crtc_x);
 		WARN_ON_ONCE(plane->state->crtc_y != plane_state->crtc_y);
 		WARN_ON_ONCE(plane->state->src_x != plane_state->src_x);
 		WARN_ON_ONCE(plane->state->src_y != plane_state->src_y);
+
+		/*
+		 * Make sure the FBs have been swapped so that cleanups in the
+		 * new_state performs a cleanup in the old FB.
+		 */
+		WARN_ON_ONCE(plane_state->fb != old_fb);
 	}
 }
 EXPORT_SYMBOL(drm_atomic_helper_async_commit);
diff --git a/include/drm/drm_modeset_helper_vtables.h b/include/drm/drm_modeset_helper_vtables.h
index f9c94c2a1364..f7bbd0b0ecd1 100644
--- a/include/drm/drm_modeset_helper_vtables.h
+++ b/include/drm/drm_modeset_helper_vtables.h
@@ -1185,6 +1185,14 @@ struct drm_plane_helper_funcs {
 	 * current one with the new plane configurations in the new
 	 * plane_state.
 	 *
+	 * Drivers should also swap the framebuffers between current plane
+	 * state (&drm_plane.state) and new_state.
+	 * This is required since cleanup for async commits is performed on
+	 * the new state, rather than old state like for traditional commits.
+	 * Since we want to give up the reference on the current (old) fb
+	 * instead of our brand new one, swap them in the driver during the
+	 * async commit.
+	 *
 	 * FIXME:
 	 *  - It only works for single plane updates
 	 *  - Async Pageflips are not supported yet
-- 
2.20.1

