Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A401C127DDA
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 15:38:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728028AbfLTOhH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Dec 2019 09:37:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:38748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728133AbfLTOek (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Dec 2019 09:34:40 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73F4D24680;
        Fri, 20 Dec 2019 14:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576852479;
        bh=Riktco6hxiLArecodnV7IydKi1HWpBO+RyQem6wfHm8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dRqiO4sEYVBFTVQ9vl2bS4tDEEJ4EUrJphL2SPok6dZHPEaN/c8dMqnwgu1Ou6mj9
         z4+1AxZ3jcMcZ/a+6ItpgZ+pcuKif89UFP54KPbzZhy90Ff9+Pc5gl4Ke8+TEZMmvZ
         3v+hAK9JMBqBD+LrlHQkhwSieJiJexSX0H3QnoG8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 04/34] drm/amdgpu: add cache flush workaround to gfx8 emit_fence
Date:   Fri, 20 Dec 2019 09:34:03 -0500
Message-Id: <20191220143433.9922-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191220143433.9922-1-sashal@kernel.org>
References: <20191220143433.9922-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>

[ Upstream commit bf26da927a1cd57c9deb2db29ae8cf276ba8b17b ]

The same workaround is used for gfx7.
Both PAL and Mesa use it for gfx8 too, so port this commit to
gfx_v8_0_ring_emit_fence_gfx.

Signed-off-by: Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c
index 5a9534a82d409..e1cb7fa89e4d6 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c
@@ -6405,7 +6405,23 @@ static void gfx_v8_0_ring_emit_fence_gfx(struct amdgpu_ring *ring, u64 addr,
 	bool write64bit = flags & AMDGPU_FENCE_FLAG_64BIT;
 	bool int_sel = flags & AMDGPU_FENCE_FLAG_INT;
 
-	/* EVENT_WRITE_EOP - flush caches, send int */
+	/* Workaround for cache flush problems. First send a dummy EOP
+	 * event down the pipe with seq one below.
+	 */
+	amdgpu_ring_write(ring, PACKET3(PACKET3_EVENT_WRITE_EOP, 4));
+	amdgpu_ring_write(ring, (EOP_TCL1_ACTION_EN |
+				 EOP_TC_ACTION_EN |
+				 EOP_TC_WB_ACTION_EN |
+				 EVENT_TYPE(CACHE_FLUSH_AND_INV_TS_EVENT) |
+				 EVENT_INDEX(5)));
+	amdgpu_ring_write(ring, addr & 0xfffffffc);
+	amdgpu_ring_write(ring, (upper_32_bits(addr) & 0xffff) |
+				DATA_SEL(1) | INT_SEL(0));
+	amdgpu_ring_write(ring, lower_32_bits(seq - 1));
+	amdgpu_ring_write(ring, upper_32_bits(seq - 1));
+
+	/* Then send the real EOP event down the pipe:
+	 * EVENT_WRITE_EOP - flush caches, send int */
 	amdgpu_ring_write(ring, PACKET3(PACKET3_EVENT_WRITE_EOP, 4));
 	amdgpu_ring_write(ring, (EOP_TCL1_ACTION_EN |
 				 EOP_TC_ACTION_EN |
@@ -7154,7 +7170,7 @@ static const struct amdgpu_ring_funcs gfx_v8_0_ring_funcs_gfx = {
 		5 +  /* COND_EXEC */
 		7 +  /* PIPELINE_SYNC */
 		VI_FLUSH_GPU_TLB_NUM_WREG * 5 + 9 + /* VM_FLUSH */
-		8 +  /* FENCE for VM_FLUSH */
+		12 +  /* FENCE for VM_FLUSH */
 		20 + /* GDS switch */
 		4 + /* double SWITCH_BUFFER,
 		       the first COND_EXEC jump to the place just
@@ -7166,7 +7182,7 @@ static const struct amdgpu_ring_funcs gfx_v8_0_ring_funcs_gfx = {
 		31 + /*	DE_META */
 		3 + /* CNTX_CTRL */
 		5 + /* HDP_INVL */
-		8 + 8 + /* FENCE x2 */
+		12 + 12 + /* FENCE x2 */
 		2, /* SWITCH_BUFFER */
 	.emit_ib_size =	4, /* gfx_v8_0_ring_emit_ib_gfx */
 	.emit_ib = gfx_v8_0_ring_emit_ib_gfx,
-- 
2.20.1

