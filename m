Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF4DF3B5DD
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 15:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390107AbfFJNTJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jun 2019 09:19:09 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:57266 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388848AbfFJNTI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jun 2019 09:19:08 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: koike)
        with ESMTPSA id 8868A261136
From:   Helen Koike <helen.koike@collabora.com>
To:     stable@vger.kernel.org
Cc:     dri-devel@lists.freedesktop.org, kernel@collabora.com,
        gregkh@linuxfoundation.org
Subject: [PATCH v5] drm/vc4: fix fb references in async update
Date:   Mon, 10 Jun 2019 10:18:59 -0300
Message-Id: <20190610131859.7616-1-helen.koike@collabora.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <156007492924468@kroah.com>
References: <156007492924468@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit c16b85559dcfb5a348cc085a7b4c75ed49b05e2c upstream.

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
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190603165610.24614-5-helen.koike@collabora.com
---

Hi,

This patch failed to apply on kernel stable v4.19, I'm re-sending it
fixing the conflict.

Thanks
Helen

 drivers/gpu/drm/vc4/vc4_plane.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/vc4/vc4_plane.c b/drivers/gpu/drm/vc4/vc4_plane.c
index ab39315c9078..39e608271263 100644
--- a/drivers/gpu/drm/vc4/vc4_plane.c
+++ b/drivers/gpu/drm/vc4/vc4_plane.c
@@ -818,6 +818,7 @@ static void vc4_plane_atomic_async_update(struct drm_plane *plane,
 		drm_atomic_set_fb_for_plane(plane->state, state->fb);
 	}
 
+	swap(plane->state->fb, state->fb);
 	/* Set the cursor's position on the screen.  This is the
 	 * expected change from the drm_mode_cursor_universal()
 	 * helper.
-- 
2.20.1

