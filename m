Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59D21257DC3
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 17:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728405AbgHaP3p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 11:29:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:38266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728369AbgHaP3m (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 Aug 2020 11:29:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3EFC2083E;
        Mon, 31 Aug 2020 15:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598887781;
        bh=DVKJ29QHAzz4qU2F/xNhd+abhHFEJS1721McD0/25Pw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BVgPlztInhS/+jPXxBfeOqZMRiFgW049evUwGOWfafa55BpXg8iU8k/2S8/dSNc2e
         c4GOYc6ejgRCPbgTTof7Gaczq6UGBqwPHUx9lSfUGqYbDBzEgWOAiqzTJQDWQ37T9P
         leFmjee1/ThUcFlAGaoaMdXPxXFGxOx8fuYKSbU4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kalyan Thota <kalyan_t@codeaurora.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.8 04/42] drm/msm/dpu: Fix reservation failures in modeset
Date:   Mon, 31 Aug 2020 11:28:56 -0400
Message-Id: <20200831152934.1023912-4-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200831152934.1023912-1-sashal@kernel.org>
References: <20200831152934.1023912-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kalyan Thota <kalyan_t@codeaurora.org>

[ Upstream commit ccc862b957c6413b008fbe458034372847992d7f ]

In TEST_ONLY commit, rm global_state will duplicate the
object and request for new reservations, once they pass
then the new state will be swapped with the old and will
be available for the Atomic Commit.

This patch fixes some of missing links in the resource
reservation sequence mentioned above.

1) Creation of duplicate state in test_only commit (Rob)
2) Allocate and release the resources on every modeset.
3) Avoid allocation only when active is false.

In a modeset operation, swap state happens well before
disable. Hence clearing reservations in disable will
cause failures in modeset enable.

Allow reservations to be cleared/allocated before swap,
such that only newly committed resources are pushed to HW.

Changes in v1:
 - Move the rm release to atomic_check.
 - Ensure resource allocation and free happens when active
   is not changed i.e only when mode is changed.(Rob)

Changes in v2:
 - Handle dpu_kms_get_global_state API failure as it may
   return EDEADLK (swboyd).

Signed-off-by: Kalyan Thota <kalyan_t@codeaurora.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
index 0946a86b37b28..c0cd936314e66 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
@@ -586,7 +586,10 @@ static int dpu_encoder_virt_atomic_check(
 	dpu_kms = to_dpu_kms(priv->kms);
 	mode = &crtc_state->mode;
 	adj_mode = &crtc_state->adjusted_mode;
-	global_state = dpu_kms_get_existing_global_state(dpu_kms);
+	global_state = dpu_kms_get_global_state(crtc_state->state);
+	if (IS_ERR(global_state))
+		return PTR_ERR(global_state);
+
 	trace_dpu_enc_atomic_check(DRMID(drm_enc));
 
 	/*
@@ -621,12 +624,15 @@ static int dpu_encoder_virt_atomic_check(
 	/* Reserve dynamic resources now. */
 	if (!ret) {
 		/*
-		 * Avoid reserving resources when mode set is pending. Topology
-		 * info may not be available to complete reservation.
+		 * Release and Allocate resources on every modeset
+		 * Dont allocate when active is false.
 		 */
 		if (drm_atomic_crtc_needs_modeset(crtc_state)) {
-			ret = dpu_rm_reserve(&dpu_kms->rm, global_state,
-					drm_enc, crtc_state, topology);
+			dpu_rm_release(global_state, drm_enc);
+
+			if (!crtc_state->active_changed || crtc_state->active)
+				ret = dpu_rm_reserve(&dpu_kms->rm, global_state,
+						drm_enc, crtc_state, topology);
 		}
 	}
 
@@ -1175,7 +1181,6 @@ static void dpu_encoder_virt_disable(struct drm_encoder *drm_enc)
 	struct dpu_encoder_virt *dpu_enc = NULL;
 	struct msm_drm_private *priv;
 	struct dpu_kms *dpu_kms;
-	struct dpu_global_state *global_state;
 	int i = 0;
 
 	if (!drm_enc) {
@@ -1194,7 +1199,6 @@ static void dpu_encoder_virt_disable(struct drm_encoder *drm_enc)
 
 	priv = drm_enc->dev->dev_private;
 	dpu_kms = to_dpu_kms(priv->kms);
-	global_state = dpu_kms_get_existing_global_state(dpu_kms);
 
 	trace_dpu_enc_disable(DRMID(drm_enc));
 
@@ -1224,8 +1228,6 @@ static void dpu_encoder_virt_disable(struct drm_encoder *drm_enc)
 
 	DPU_DEBUG_ENC(dpu_enc, "encoder disabled\n");
 
-	dpu_rm_release(global_state, drm_enc);
-
 	mutex_unlock(&dpu_enc->enc_lock);
 }
 
-- 
2.25.1

