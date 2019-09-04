Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0380FA8A4E
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732171AbfIDP66 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 11:58:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:33142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732131AbfIDP65 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 11:58:57 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B20D322CF7;
        Wed,  4 Sep 2019 15:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612736;
        bh=0dd297o4/giydwwbHGYujD6FY22aEiS50RVYkQurEz0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h+EhOXYjAiUuTgvYtBcaGc3ta3aDHkuIgJWOpa9MAxpwnRRLMEfnilxSJyTxrwO+H
         na5hxpefIEglS8ZkcDQSvlEpOo/B+pHjqGMjjtnnlRmy+DIZNiBxEkjkcByQqBKEEb
         K8IR2CSi/OEvJiemN1Om2tUIJfst22PNwrvFtBWA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Chunming Zhou <david1.zhou@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.2 50/94] drm/amdgpu: fix dma_fence_wait without reference
Date:   Wed,  4 Sep 2019 11:56:55 -0400
Message-Id: <20190904155739.2816-50-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904155739.2816-1-sashal@kernel.org>
References: <20190904155739.2816-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian König <christian.koenig@amd.com>

[ Upstream commit 42068e1ef961c719f967dbbb4ddcb394a0ba7917 ]

We need to grab a reference to the fence we wait for.

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Chunming Zhou <david1.zhou@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c | 27 ++++++++++++++-----------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c
index a28a3d722ba29..62298ae5c81c0 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c
@@ -535,21 +535,24 @@ int amdgpu_ctx_wait_prev_fence(struct amdgpu_ctx *ctx,
 			       struct drm_sched_entity *entity)
 {
 	struct amdgpu_ctx_entity *centity = to_amdgpu_ctx_entity(entity);
-	unsigned idx = centity->sequence & (amdgpu_sched_jobs - 1);
-	struct dma_fence *other = centity->fences[idx];
+	struct dma_fence *other;
+	unsigned idx;
+	long r;
 
-	if (other) {
-		signed long r;
-		r = dma_fence_wait(other, true);
-		if (r < 0) {
-			if (r != -ERESTARTSYS)
-				DRM_ERROR("Error (%ld) waiting for fence!\n", r);
+	spin_lock(&ctx->ring_lock);
+	idx = centity->sequence & (amdgpu_sched_jobs - 1);
+	other = dma_fence_get(centity->fences[idx]);
+	spin_unlock(&ctx->ring_lock);
 
-			return r;
-		}
-	}
+	if (!other)
+		return 0;
 
-	return 0;
+	r = dma_fence_wait(other, true);
+	if (r < 0 && r != -ERESTARTSYS)
+		DRM_ERROR("Error (%ld) waiting for fence!\n", r);
+
+	dma_fence_put(other);
+	return r;
 }
 
 void amdgpu_ctx_mgr_init(struct amdgpu_ctx_mgr *mgr)
-- 
2.20.1

