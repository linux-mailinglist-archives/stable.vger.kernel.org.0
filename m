Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 982D53358F
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 18:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727853AbfFCQ4w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 12:56:52 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:35366 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727047AbfFCQ4v (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jun 2019 12:56:51 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: koike)
        with ESMTPSA id A58E1284CE3
From:   Helen Koike <helen.koike@collabora.com>
To:     dri-devel@lists.freedesktop.org, nicholas.kazlauskas@amd.com
Cc:     andrey.grodzovsky@amd.com, daniel.vetter@ffwll.ch,
        linux-kernel@vger.kernel.org, Tomasz Figa <tfiga@chromium.org>,
        boris.brezillon@collabora.com, David Airlie <airlied@linux.ie>,
        Sean Paul <seanpaul@google.com>, kernel@collabora.com,
        harry.wentland@amd.com,
        =?UTF-8?q?St=C3=A9phane=20Marchesin?= <marcheu@google.com>,
        Helen Koike <helen.koike@collabora.com>,
        stable@vger.kernel.org, Rob Clark <robdclark@gmail.com>,
        Sean Paul <sean@poorly.run>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        linux-arm-msm@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Jeykumar Sankaran <jsanka@codeaurora.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        freedreno@lists.freedesktop.org,
        Mamta Shukla <mamtashukla555@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>
Subject: [PATCH v4 3/5] drm/msm: fix fb references in async update
Date:   Mon,  3 Jun 2019 13:56:08 -0300
Message-Id: <20190603165610.24614-4-helen.koike@collabora.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190603165610.24614-1-helen.koike@collabora.com>
References: <20190603165610.24614-1-helen.koike@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Async update callbacks are expected to set the old_fb in the new_state
so prepare/cleanup framebuffers are balanced.

Cc: <stable@vger.kernel.org> # v4.14+
Fixes: 224a4c970987 ("drm/msm: update cursors asynchronously through atomic")
Suggested-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Helen Koike <helen.koike@collabora.com>
Acked-by: Rob Clark <robdclark@gmail.com>

---
Hello,

This was tested on the dragonboard 410c using igt plane_cursor_legacy and
kms_cursor_legacy and I didn't see any regressions.

Changes in v4:
- add acked by tag

Changes in v3: None
Changes in v2:
- update CC stable and Fixes tag

 drivers/gpu/drm/msm/disp/mdp5/mdp5_plane.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/msm/disp/mdp5/mdp5_plane.c b/drivers/gpu/drm/msm/disp/mdp5/mdp5_plane.c
index 9d9fb6c5fd68..1105c2433f14 100644
--- a/drivers/gpu/drm/msm/disp/mdp5/mdp5_plane.c
+++ b/drivers/gpu/drm/msm/disp/mdp5/mdp5_plane.c
@@ -502,6 +502,8 @@ static int mdp5_plane_atomic_async_check(struct drm_plane *plane,
 static void mdp5_plane_atomic_async_update(struct drm_plane *plane,
 					   struct drm_plane_state *new_state)
 {
+	struct drm_framebuffer *old_fb = plane->state->fb;
+
 	plane->state->src_x = new_state->src_x;
 	plane->state->src_y = new_state->src_y;
 	plane->state->crtc_x = new_state->crtc_x;
@@ -524,6 +526,8 @@ static void mdp5_plane_atomic_async_update(struct drm_plane *plane,
 
 	*to_mdp5_plane_state(plane->state) =
 		*to_mdp5_plane_state(new_state);
+
+	new_state->fb = old_fb;
 }
 
 static const struct drm_plane_helper_funcs mdp5_plane_helper_funcs = {
-- 
2.20.1

