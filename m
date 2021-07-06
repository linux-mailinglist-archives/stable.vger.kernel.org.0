Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CBA63BCC29
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232577AbhGFLSf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:18:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:54502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232484AbhGFLSX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:18:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6559961C3B;
        Tue,  6 Jul 2021 11:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570145;
        bh=fYlHyb7OaFyWCJM71JTFifuDn2s5sr2GkIvOqqhxUe0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lKkjjw7kz8h1w0bS+VuuKGMmB2N/o+exyvY6SzevJnDywLnRE/YOEhxyT8SWekFep
         ktX2nMEJTNCTZeI3SER/ceW/OSD7aiKo70iI7ZDzIOMaskInSGuT6s1O8C3bC/L6zE
         EwLxMmXiRPf9Cr1wMubGMZ1Bz1EFV5FCF3TikwveKCjqc5uHy9vkR+z0uuyIt1ZQs+
         24iNpgcjfhc80POkZpfLVmpzZGSEYFR+kMuEX5PMOu9NwI7SkiFlnHkYJ4PB3fVln4
         SlhqlTv2sXX/NafaMPWKsK9e07WXTRFjDVDnldUbILwTFWUDeN/Cvkd1hKBTSXKXfU
         4W9o4GUVkO7Dg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiansong Chen <Jiansong.Chen@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.13 069/189] drm/amdgpu: remove unsafe optimization to drop preamble ib
Date:   Tue,  6 Jul 2021 07:12:09 -0400
Message-Id: <20210706111409.2058071-69-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiansong Chen <Jiansong.Chen@amd.com>

[ Upstream commit 7d9c70d23550eb86a1bec1954ccaa8d6ec3a3328 ]

Take the situation with gfxoff, the optimization may cause
corrupt CE ram contents. In addition emit_cntxcntl callback
has similar optimization which firmware can handle properly
even for power feature.

Signed-off-by: Jiansong Chen <Jiansong.Chen@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c
index a2fe2dac32c1..98906a43fda3 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c
@@ -130,7 +130,7 @@ int amdgpu_ib_schedule(struct amdgpu_ring *ring, unsigned num_ibs,
 	struct amdgpu_device *adev = ring->adev;
 	struct amdgpu_ib *ib = &ibs[0];
 	struct dma_fence *tmp = NULL;
-	bool skip_preamble, need_ctx_switch;
+	bool need_ctx_switch;
 	unsigned patch_offset = ~0;
 	struct amdgpu_vm *vm;
 	uint64_t fence_ctx;
@@ -227,7 +227,6 @@ int amdgpu_ib_schedule(struct amdgpu_ring *ring, unsigned num_ibs,
 	if (need_ctx_switch)
 		status |= AMDGPU_HAVE_CTX_SWITCH;
 
-	skip_preamble = ring->current_ctx == fence_ctx;
 	if (job && ring->funcs->emit_cntxcntl) {
 		status |= job->preamble_status;
 		status |= job->preemption_status;
@@ -245,14 +244,6 @@ int amdgpu_ib_schedule(struct amdgpu_ring *ring, unsigned num_ibs,
 	for (i = 0; i < num_ibs; ++i) {
 		ib = &ibs[i];
 
-		/* drop preamble IBs if we don't have a context switch */
-		if ((ib->flags & AMDGPU_IB_FLAG_PREAMBLE) &&
-		    skip_preamble &&
-		    !(status & AMDGPU_PREAMBLE_IB_PRESENT_FIRST) &&
-		    !amdgpu_mcbp &&
-		    !amdgpu_sriov_vf(adev)) /* for SRIOV preemption, Preamble CE ib must be inserted anyway */
-			continue;
-
 		if (job && ring->funcs->emit_frame_cntl) {
 			if (secure != !!(ib->flags & AMDGPU_IB_FLAGS_SECURE)) {
 				amdgpu_ring_emit_frame_cntl(ring, false, secure);
-- 
2.30.2

