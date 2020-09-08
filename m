Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 139F1261F18
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730494AbgIHT65 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:58:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:59784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730157AbgIHPfj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 11:35:39 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C03C2245F;
        Tue,  8 Sep 2020 15:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579277;
        bh=DVKJ29QHAzz4qU2F/xNhd+abhHFEJS1721McD0/25Pw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2wHrl05yZnjZgvM12nSq0tAMHjjqVwh/gbLcwog0s+2HJEiV6Gi31CvK070PlOTPX
         XMiLDssqSY2K+LXXSVHzX4p8QL1inBM4jyXntq93ZM/J4FF48TQaJv76t9Wm+Ih3YF
         4RoKFddqSUQLklX8pydiAV2q2MWgeYQC0TYmzG2E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kalyan Thota <kalyan_t@codeaurora.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 003/186] drm/msm/dpu: Fix reservation failures in modeset
Date:   Tue,  8 Sep 2020 17:22:25 +0200
Message-Id: <20200908152241.819133349@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



