Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E86EE3B61B
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 15:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389373AbfFJNgf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jun 2019 09:36:35 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:57420 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390071AbfFJNgf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jun 2019 09:36:35 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: koike)
        with ESMTPSA id 303C82610C6
From:   Helen Koike <helen.koike@collabora.com>
To:     stable@vger.kernel.org
Cc:     dri-devel@lists.freedesktop.org, kernel@collabora.com,
        gregkh@linuxfoundation.org
Subject: [PATCH] drm: don't block fb changes for async plane updates
Date:   Mon, 10 Jun 2019 10:36:27 -0300
Message-Id: <20190610133627.31923-1-helen.koike@collabora.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <156007626458164@kroah.com>
References: <156007626458164@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 89a4aac0ab0e6f5eea10d7bf4869dd15c3de2cd4 upstream.

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
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190603165610.24614-6-helen.koike@collabora.com
---

Hi,

This patch failed to apply on kernel stable v4.14, I'm re-sending it
fixing the conflict.

Thanks
Helen

 drivers/gpu/drm/drm_atomic_helper.c      | 10 ++++++++++
 include/drm/drm_modeset_helper_vtables.h |  8 ++++++++
 2 files changed, 18 insertions(+)

diff --git a/drivers/gpu/drm/drm_atomic_helper.c b/drivers/gpu/drm/drm_atomic_helper.c
index d05ed0521e20..331478bd2ff8 100644
--- a/drivers/gpu/drm/drm_atomic_helper.c
+++ b/drivers/gpu/drm/drm_atomic_helper.c
@@ -1462,6 +1462,8 @@ EXPORT_SYMBOL(drm_atomic_helper_async_check);
  * drm_atomic_async_check() succeeds. Async commits are not supposed to swap
  * the states like normal sync commits, but just do in-place changes on the
  * current state.
+ *
+ * TODO: Implement full swap instead of doing in-place changes.
  */
 void drm_atomic_helper_async_commit(struct drm_device *dev,
 				    struct drm_atomic_state *state)
@@ -1472,8 +1474,16 @@ void drm_atomic_helper_async_commit(struct drm_device *dev,
 	int i;
 
 	for_each_new_plane_in_state(state, plane, plane_state, i) {
+		struct drm_framebuffer *old_fb = plane->state->fb;
+
 		funcs = plane->helper_private;
 		funcs->atomic_async_update(plane, plane_state);
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
index c55cf3ff6847..2f6d0f3ae985 100644
--- a/include/drm/drm_modeset_helper_vtables.h
+++ b/include/drm/drm_modeset_helper_vtables.h
@@ -1159,6 +1159,14 @@ struct drm_plane_helper_funcs {
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

