Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D8082E1796
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 04:12:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727645AbgLWCR6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:17:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:45510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727612AbgLWCRy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:17:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F4C4225AC;
        Wed, 23 Dec 2020 02:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689806;
        bh=v0oZvUtokxvo39/NdM+fLn468wX5yHrFHPEcQw3Zl2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oxNQ7v1YSxh1C1Jh/fDOPHOJUvil3tGgR7nc8laYELaI+3yY+cRYd291AqkmHfadB
         DgkviNIBpq8AqNTdH9ottx56C7AkXSJv135oE7YyDDCrr7I2lB1KXLBcyzSPBgFlF1
         mSoVntPEqx9w4NgXaml/kxhB/QQtmLHtjFZHw6a2qy3OvtGi7CJzNNUR9fpwwLf+rR
         eikQdptedpKYHiCTmg6qq9r+jhP2AWHAhh8wot51AC2j+X47g5kmghPLTKq28Z7t6z
         1O+NFsEI4FOmGLpA2WIoiUrXEMqN20gJsnpMPQSPskBLzqINrDAiV6bd/B3UjOv3Dl
         PT9ZlJSE3C5QA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Krishna Manikandan <mkrishn@codeaurora.org>,
        Rob Clark <robdclark@gmail.com>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 015/217] drm/msm: Fix race condition in msm driver with async layer updates
Date:   Tue, 22 Dec 2020 21:13:04 -0500
Message-Id: <20201223021626.2790791-15-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021626.2790791-1-sashal@kernel.org>
References: <20201223021626.2790791-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krishna Manikandan <mkrishn@codeaurora.org>

[ Upstream commit b3d91800d9ac35014e0349292273a6fa7938d402 ]

When there are back to back commits with async cursor update,
there is a case where second commit can program the DPU hw
blocks while first didn't complete flushing config to HW.

Synchronize the compositions such that second commit waits
until first commit flushes the composition.

This change also introduces per crtc commit lock, such that
commits on different crtcs are not blocked by each other.

Changes in v2:
	- Use an array of mutexes in kms to handle commit
	  lock per crtc. (Rob Clark)

Changes in v3:
	- Add wrapper functions to handle lock and unlock of
	  commit_lock for each crtc. (Rob Clark)

Signed-off-by: Krishna Manikandan <mkrishn@codeaurora.org>
Reviewed-by: Rob Clark <robdclark@gmail.com>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_atomic.c | 37 +++++++++++++++++++++-----------
 drivers/gpu/drm/msm/msm_kms.h    |  6 ++++--
 2 files changed, 28 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/msm/msm_atomic.c b/drivers/gpu/drm/msm/msm_atomic.c
index 561bfa48841c3..575e9af9b6fc9 100644
--- a/drivers/gpu/drm/msm/msm_atomic.c
+++ b/drivers/gpu/drm/msm/msm_atomic.c
@@ -55,16 +55,32 @@ static void vblank_put(struct msm_kms *kms, unsigned crtc_mask)
 	}
 }
 
+static void lock_crtcs(struct msm_kms *kms, unsigned int crtc_mask)
+{
+	struct drm_crtc *crtc;
+
+	for_each_crtc_mask(kms->dev, crtc, crtc_mask)
+		mutex_lock(&kms->commit_lock[drm_crtc_index(crtc)]);
+}
+
+static void unlock_crtcs(struct msm_kms *kms, unsigned int crtc_mask)
+{
+	struct drm_crtc *crtc;
+
+	for_each_crtc_mask(kms->dev, crtc, crtc_mask)
+		mutex_unlock(&kms->commit_lock[drm_crtc_index(crtc)]);
+}
+
 static void msm_atomic_async_commit(struct msm_kms *kms, int crtc_idx)
 {
 	unsigned crtc_mask = BIT(crtc_idx);
 
 	trace_msm_atomic_async_commit_start(crtc_mask);
 
-	mutex_lock(&kms->commit_lock);
+	lock_crtcs(kms, crtc_mask);
 
 	if (!(kms->pending_crtc_mask & crtc_mask)) {
-		mutex_unlock(&kms->commit_lock);
+		unlock_crtcs(kms, crtc_mask);
 		goto out;
 	}
 
@@ -79,7 +95,6 @@ static void msm_atomic_async_commit(struct msm_kms *kms, int crtc_idx)
 	 */
 	trace_msm_atomic_flush_commit(crtc_mask);
 	kms->funcs->flush_commit(kms, crtc_mask);
-	mutex_unlock(&kms->commit_lock);
 
 	/*
 	 * Wait for flush to complete:
@@ -90,9 +105,8 @@ static void msm_atomic_async_commit(struct msm_kms *kms, int crtc_idx)
 
 	vblank_put(kms, crtc_mask);
 
-	mutex_lock(&kms->commit_lock);
 	kms->funcs->complete_commit(kms, crtc_mask);
-	mutex_unlock(&kms->commit_lock);
+	unlock_crtcs(kms, crtc_mask);
 	kms->funcs->disable_commit(kms);
 
 out:
@@ -189,12 +203,11 @@ void msm_atomic_commit_tail(struct drm_atomic_state *state)
 	 * Ensure any previous (potentially async) commit has
 	 * completed:
 	 */
+	lock_crtcs(kms, crtc_mask);
 	trace_msm_atomic_wait_flush_start(crtc_mask);
 	kms->funcs->wait_flush(kms, crtc_mask);
 	trace_msm_atomic_wait_flush_finish(crtc_mask);
 
-	mutex_lock(&kms->commit_lock);
-
 	/*
 	 * Now that there is no in-progress flush, prepare the
 	 * current update:
@@ -232,8 +245,7 @@ void msm_atomic_commit_tail(struct drm_atomic_state *state)
 		}
 
 		kms->funcs->disable_commit(kms);
-		mutex_unlock(&kms->commit_lock);
-
+		unlock_crtcs(kms, crtc_mask);
 		/*
 		 * At this point, from drm core's perspective, we
 		 * are done with the atomic update, so we can just
@@ -260,8 +272,7 @@ void msm_atomic_commit_tail(struct drm_atomic_state *state)
 	 */
 	trace_msm_atomic_flush_commit(crtc_mask);
 	kms->funcs->flush_commit(kms, crtc_mask);
-	mutex_unlock(&kms->commit_lock);
-
+	unlock_crtcs(kms, crtc_mask);
 	/*
 	 * Wait for flush to complete:
 	 */
@@ -271,9 +282,9 @@ void msm_atomic_commit_tail(struct drm_atomic_state *state)
 
 	vblank_put(kms, crtc_mask);
 
-	mutex_lock(&kms->commit_lock);
+	lock_crtcs(kms, crtc_mask);
 	kms->funcs->complete_commit(kms, crtc_mask);
-	mutex_unlock(&kms->commit_lock);
+	unlock_crtcs(kms, crtc_mask);
 	kms->funcs->disable_commit(kms);
 
 	drm_atomic_helper_commit_hw_done(state);
diff --git a/drivers/gpu/drm/msm/msm_kms.h b/drivers/gpu/drm/msm/msm_kms.h
index 1cbef6b200b70..2049847b66428 100644
--- a/drivers/gpu/drm/msm/msm_kms.h
+++ b/drivers/gpu/drm/msm/msm_kms.h
@@ -155,7 +155,7 @@ struct msm_kms {
 	 * For async commit, where ->flush_commit() and later happens
 	 * from the crtc's pending_timer close to end of the frame:
 	 */
-	struct mutex commit_lock;
+	struct mutex commit_lock[MAX_CRTCS];
 	unsigned pending_crtc_mask;
 	struct msm_pending_timer pending_timers[MAX_CRTCS];
 };
@@ -165,7 +165,9 @@ static inline void msm_kms_init(struct msm_kms *kms,
 {
 	unsigned i;
 
-	mutex_init(&kms->commit_lock);
+	for (i = 0; i < ARRAY_SIZE(kms->commit_lock); i++)
+		mutex_init(&kms->commit_lock[i]);
+
 	kms->funcs = funcs;
 
 	for (i = 0; i < ARRAY_SIZE(kms->pending_timers); i++)
-- 
2.27.0

