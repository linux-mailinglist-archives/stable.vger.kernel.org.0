Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C89BCD6D4
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729744AbfJFRjN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:39:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:38676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730137AbfJFRjN (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:39:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F69E2133F;
        Sun,  6 Oct 2019 17:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383551;
        bh=TxigC21+DLiMafdGXO5lPtQ6kQiOwS68oR4xLUldI8Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vexhl11JLxqydm828yc/QQPSoa8yI1ezKxaOcISGnY1LwI0LUaZw4a2i3N9jUVs6B
         Tx9cPcIh1wL2lAIV/FadZ+AlRm5co6ITTHMVUDfY+7g8y75tn2wLx4qtIViQbWhR/T
         8+yUYJn/O7RaDzehI7YIWWpewNuVJMTDa28IGY2g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shayenne Moura <shayenneluzmoura@gmail.com>,
        Rodrigo Siqueira <rodrigosiqueiramelo@gmail.com>,
        Haneen Mohammed <hamohammed.sa@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 001/166] drm/vkms: Fix crc worker races
Date:   Sun,  6 Oct 2019 19:19:27 +0200
Message-Id: <20191006171212.939267264@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171212.850660298@linuxfoundation.org>
References: <20191006171212.850660298@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Vetter <daniel.vetter@ffwll.ch>

[ Upstream commit 18d0952a838ba559655b0cd9cf85097ad63d9bca ]

The issue we have is that the crc worker might fall behind. We've
tried to handle this by tracking both the earliest frame for which it
still needs to compute a crc, and the last one. Plus when the
crtc_state changes, we have a new work item, which are all run in
order due to the ordered workqueue we allocate for each vkms crtc.

Trouble is there's been a few small issues in the current code:
- we need to capture frame_end in the vblank hrtimer, not in the
  worker. The worker might run much later, and then we generate a lot
  of crc for which there's already a different worker queued up.
- frame number might be 0, so create a new crc_pending boolean to
  track this without confusion.
- we need to atomically grab frame_start/end and clear it, so do that
  all in one go. This is not going to create a new race, because if we
  race with the hrtimer then our work will be re-run.
- only race that can happen is the following:
  1. worker starts
  2. hrtimer runs and updates frame_end
  3. worker grabs frame_start/end, already reading the new frame_end,
  and clears crc_pending
  4. hrtimer calls queue_work()
  5. worker completes
  6. worker gets  re-run, crc_pending is false
  Explain this case a bit better by rewording the comment.

v2: Demote warning level output to debug when we fail to requeue, this
is expected under high load when the crc worker can't quite keep up.

Cc: Shayenne Moura <shayenneluzmoura@gmail.com>
Cc: Rodrigo Siqueira <rodrigosiqueiramelo@gmail.com>
Cc: Haneen Mohammed <hamohammed.sa@gmail.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Reviewed-by: Rodrigo Siqueira <rodrigosiqueiramelo@gmail.com>
Tested-by: Rodrigo Siqueira <rodrigosiqueiramelo@gmail.com>
Signed-off-by: Rodrigo Siqueira <rodrigosiqueiramelo@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190606222751.32567-2-daniel.vetter@ffwll.ch
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vkms/vkms_crc.c  | 27 +++++++++++++--------------
 drivers/gpu/drm/vkms/vkms_crtc.c |  9 +++++++--
 drivers/gpu/drm/vkms/vkms_drv.h  |  2 ++
 3 files changed, 22 insertions(+), 16 deletions(-)

diff --git a/drivers/gpu/drm/vkms/vkms_crc.c b/drivers/gpu/drm/vkms/vkms_crc.c
index e66ff25c008e6..e9fb4ebb789fd 100644
--- a/drivers/gpu/drm/vkms/vkms_crc.c
+++ b/drivers/gpu/drm/vkms/vkms_crc.c
@@ -166,16 +166,24 @@ void vkms_crc_work_handle(struct work_struct *work)
 	struct drm_plane *plane;
 	u32 crc32 = 0;
 	u64 frame_start, frame_end;
+	bool crc_pending;
 	unsigned long flags;
 
 	spin_lock_irqsave(&out->state_lock, flags);
 	frame_start = crtc_state->frame_start;
 	frame_end = crtc_state->frame_end;
+	crc_pending = crtc_state->crc_pending;
+	crtc_state->frame_start = 0;
+	crtc_state->frame_end = 0;
+	crtc_state->crc_pending = false;
 	spin_unlock_irqrestore(&out->state_lock, flags);
 
-	/* _vblank_handle() hasn't updated frame_start yet */
-	if (!frame_start || frame_start == frame_end)
-		goto out;
+	/*
+	 * We raced with the vblank hrtimer and previous work already computed
+	 * the crc, nothing to do.
+	 */
+	if (!crc_pending)
+		return;
 
 	drm_for_each_plane(plane, &vdev->drm) {
 		struct vkms_plane_state *vplane_state;
@@ -196,20 +204,11 @@ void vkms_crc_work_handle(struct work_struct *work)
 	if (primary_crc)
 		crc32 = _vkms_get_crc(primary_crc, cursor_crc);
 
-	frame_end = drm_crtc_accurate_vblank_count(crtc);
-
-	/* queue_work can fail to schedule crc_work; add crc for
-	 * missing frames
+	/*
+	 * The worker can fall behind the vblank hrtimer, make sure we catch up.
 	 */
 	while (frame_start <= frame_end)
 		drm_crtc_add_crc_entry(crtc, true, frame_start++, &crc32);
-
-out:
-	/* to avoid using the same value for frame number again */
-	spin_lock_irqsave(&out->state_lock, flags);
-	crtc_state->frame_end = frame_end;
-	crtc_state->frame_start = 0;
-	spin_unlock_irqrestore(&out->state_lock, flags);
 }
 
 static const char * const pipe_crc_sources[] = {"auto"};
diff --git a/drivers/gpu/drm/vkms/vkms_crtc.c b/drivers/gpu/drm/vkms/vkms_crtc.c
index 4d11292bc6f38..f392fa13015b8 100644
--- a/drivers/gpu/drm/vkms/vkms_crtc.c
+++ b/drivers/gpu/drm/vkms/vkms_crtc.c
@@ -30,13 +30,18 @@ static enum hrtimer_restart vkms_vblank_simulate(struct hrtimer *timer)
 		 * has read the data
 		 */
 		spin_lock(&output->state_lock);
-		if (!state->frame_start)
+		if (!state->crc_pending)
 			state->frame_start = frame;
+		else
+			DRM_DEBUG_DRIVER("crc worker falling behind, frame_start: %llu, frame_end: %llu\n",
+					 state->frame_start, frame);
+		state->frame_end = frame;
+		state->crc_pending = true;
 		spin_unlock(&output->state_lock);
 
 		ret = queue_work(output->crc_workq, &state->crc_work);
 		if (!ret)
-			DRM_WARN("failed to queue vkms_crc_work_handle");
+			DRM_DEBUG_DRIVER("vkms_crc_work_handle already queued\n");
 	}
 
 	spin_unlock(&output->lock);
diff --git a/drivers/gpu/drm/vkms/vkms_drv.h b/drivers/gpu/drm/vkms/vkms_drv.h
index b92c30c66a6f2..2b37eb1062d34 100644
--- a/drivers/gpu/drm/vkms/vkms_drv.h
+++ b/drivers/gpu/drm/vkms/vkms_drv.h
@@ -48,6 +48,8 @@ struct vkms_plane_state {
 struct vkms_crtc_state {
 	struct drm_crtc_state base;
 	struct work_struct crc_work;
+
+	bool crc_pending;
 	u64 frame_start;
 	u64 frame_end;
 };
-- 
2.20.1



