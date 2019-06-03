Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC5503359E
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 18:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728465AbfFCQ44 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 12:56:56 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:35386 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727047AbfFCQ4z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jun 2019 12:56:55 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: koike)
        with ESMTPSA id 7B3C0284AD8
From:   Helen Koike <helen.koike@collabora.com>
To:     dri-devel@lists.freedesktop.org, nicholas.kazlauskas@amd.com
Cc:     andrey.grodzovsky@amd.com, daniel.vetter@ffwll.ch,
        linux-kernel@vger.kernel.org, Tomasz Figa <tfiga@chromium.org>,
        boris.brezillon@collabora.com, David Airlie <airlied@linux.ie>,
        Sean Paul <seanpaul@google.com>, kernel@collabora.com,
        harry.wentland@amd.com,
        =?UTF-8?q?St=C3=A9phane=20Marchesin?= <marcheu@google.com>,
        Helen Koike <helen.koike@collabora.com>,
        stable@vger.kernel.org, eric@anholt.net,
        Daniel Vetter <daniel@ffwll.ch>
Subject: [PATCH v4 4/5] drm/vc4: fix fb references in async update
Date:   Mon,  3 Jun 2019 13:56:09 -0300
Message-Id: <20190603165610.24614-5-helen.koike@collabora.com>
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

Calling drm_atomic_set_fb_for_plane() (which gets a reference of the new
fb and put the old fb) is not required, as it's taken care by
drm_mode_cursor_universal() when calling drm_atomic_helper_update_plane().

Cc: <stable@vger.kernel.org> # v4.19+
Fixes: 539c320bfa97 ("drm/vc4: update cursors asynchronously through atomic")
Suggested-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Helen Koike <helen.koike@collabora.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>

---
Hello,

I tested on a Raspberry Pi model B rev2 with igt plane_cursor_legacy and
kms_cursor_legacy and I didn't see any regressions.

Changes in v4: None
Changes in v3: None
Changes in v2:
- Added reviewed-by tag
- updated CC stable and Fixes tag

 drivers/gpu/drm/vc4/vc4_plane.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vc4/vc4_plane.c b/drivers/gpu/drm/vc4/vc4_plane.c
index be2274924b34..441e06d45c89 100644
--- a/drivers/gpu/drm/vc4/vc4_plane.c
+++ b/drivers/gpu/drm/vc4/vc4_plane.c
@@ -1020,7 +1020,7 @@ static void vc4_plane_atomic_async_update(struct drm_plane *plane,
 {
 	struct vc4_plane_state *vc4_state, *new_vc4_state;
 
-	drm_atomic_set_fb_for_plane(plane->state, state->fb);
+	swap(plane->state->fb, state->fb);
 	plane->state->crtc_x = state->crtc_x;
 	plane->state->crtc_y = state->crtc_y;
 	plane->state->crtc_w = state->crtc_w;
-- 
2.20.1

