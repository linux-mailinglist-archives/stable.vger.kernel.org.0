Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42257257DB6
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 17:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729422AbgHaPjy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 11:39:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:38944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728483AbgHaP34 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 Aug 2020 11:29:56 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08C5320936;
        Mon, 31 Aug 2020 15:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598887796;
        bh=8CtIqjoJ1SacnqIRXbMc/xIzgI0xr7BYm3qPaqxHkiQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1Vn84u4g4uuKK7vxNtGXaS1V/V/l1k4hJYevQKeTpOz3onfdRxk/8znuOi9ct0vLh
         wVSgHVPy5H5zNxUbO8uVdMRNzfFiVXeBUazq2J0nL4XClaKDxlvNp4pXOhr4hMcTCb
         8dxTpuo9rYWkgdZ8Ut74A6kLauuRznSZVv2VTnCg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rob Clark <robdclark@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.8 13/42] drm/msm: enable vblank during atomic commits
Date:   Mon, 31 Aug 2020 11:29:05 -0400
Message-Id: <20200831152934.1023912-13-sashal@kernel.org>
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

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit 43906812eaab06423f56af5cca9a9fcdbb4ac454 ]

This has roughly the same effect as drm_atomic_helper_wait_for_vblanks(),
basically just ensuring that vblank accounting is enabled so that we get
valid timestamp/seqn on pageflip events.

Signed-off-by: Rob Clark <robdclark@chromium.org>
Tested-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_atomic.c | 36 ++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/drivers/gpu/drm/msm/msm_atomic.c b/drivers/gpu/drm/msm/msm_atomic.c
index 5ccfad794c6a5..561bfa48841c3 100644
--- a/drivers/gpu/drm/msm/msm_atomic.c
+++ b/drivers/gpu/drm/msm/msm_atomic.c
@@ -27,6 +27,34 @@ int msm_atomic_prepare_fb(struct drm_plane *plane,
 	return msm_framebuffer_prepare(new_state->fb, kms->aspace);
 }
 
+/*
+ * Helpers to control vblanks while we flush.. basically just to ensure
+ * that vblank accounting is switched on, so we get valid seqn/timestamp
+ * on pageflip events (if requested)
+ */
+
+static void vblank_get(struct msm_kms *kms, unsigned crtc_mask)
+{
+	struct drm_crtc *crtc;
+
+	for_each_crtc_mask(kms->dev, crtc, crtc_mask) {
+		if (!crtc->state->active)
+			continue;
+		drm_crtc_vblank_get(crtc);
+	}
+}
+
+static void vblank_put(struct msm_kms *kms, unsigned crtc_mask)
+{
+	struct drm_crtc *crtc;
+
+	for_each_crtc_mask(kms->dev, crtc, crtc_mask) {
+		if (!crtc->state->active)
+			continue;
+		drm_crtc_vblank_put(crtc);
+	}
+}
+
 static void msm_atomic_async_commit(struct msm_kms *kms, int crtc_idx)
 {
 	unsigned crtc_mask = BIT(crtc_idx);
@@ -44,6 +72,8 @@ static void msm_atomic_async_commit(struct msm_kms *kms, int crtc_idx)
 
 	kms->funcs->enable_commit(kms);
 
+	vblank_get(kms, crtc_mask);
+
 	/*
 	 * Flush hardware updates:
 	 */
@@ -58,6 +88,8 @@ static void msm_atomic_async_commit(struct msm_kms *kms, int crtc_idx)
 	kms->funcs->wait_flush(kms, crtc_mask);
 	trace_msm_atomic_wait_flush_finish(crtc_mask);
 
+	vblank_put(kms, crtc_mask);
+
 	mutex_lock(&kms->commit_lock);
 	kms->funcs->complete_commit(kms, crtc_mask);
 	mutex_unlock(&kms->commit_lock);
@@ -221,6 +253,8 @@ void msm_atomic_commit_tail(struct drm_atomic_state *state)
 	 */
 	kms->pending_crtc_mask &= ~crtc_mask;
 
+	vblank_get(kms, crtc_mask);
+
 	/*
 	 * Flush hardware updates:
 	 */
@@ -235,6 +269,8 @@ void msm_atomic_commit_tail(struct drm_atomic_state *state)
 	kms->funcs->wait_flush(kms, crtc_mask);
 	trace_msm_atomic_wait_flush_finish(crtc_mask);
 
+	vblank_put(kms, crtc_mask);
+
 	mutex_lock(&kms->commit_lock);
 	kms->funcs->complete_commit(kms, crtc_mask);
 	mutex_unlock(&kms->commit_lock);
-- 
2.25.1

