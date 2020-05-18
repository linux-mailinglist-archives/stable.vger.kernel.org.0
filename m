Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 491731D8562
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731455AbgERRzc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:55:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:60982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730833AbgERRzb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:55:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE02120674;
        Mon, 18 May 2020 17:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824530;
        bh=FoizjeQWVQ+PPrHic9gyMac+0ySrT3orkEdMtBwM2/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kYHYM8EdrrUUpyNe12dO4LW4uQABsB4GGXGsi7QPpadTdXj9Ghdt/5am0CbG2IXnE
         Iw1p4uvFzCjv0+ANtqM0ALdpUugHYpXXw3LlvaJ7xvpEli1zSOLb1N9kWt3YRnOY5c
         Nw8GvX3J+A8fOnFLHoAyVRRbZs+c55c2sL4C4JDU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Ol=C5=A1=C3=A1k?= <marek.olsak@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 049/147] drm/amdgpu: invalidate L2 before SDMA IBs (v2)
Date:   Mon, 18 May 2020 19:36:12 +0200
Message-Id: <20200518173520.085222643@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173513.009514388@linuxfoundation.org>
References: <20200518173513.009514388@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Olšák <marek.olsak@amd.com>

[ Upstream commit fdf83646c0542ecfb9adc4db8f741a1f43dca058 ]

This fixes GPU hangs due to cache coherency issues.

v2: Split the version bump to a separate patch

Signed-off-by: Marek Olšák <marek.olsak@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Tested-by: Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/amdgpu/navi10_sdma_pkt_open.h    | 16 ++++++++++++++++
 drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c           | 14 +++++++++++++-
 2 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/navi10_sdma_pkt_open.h b/drivers/gpu/drm/amd/amdgpu/navi10_sdma_pkt_open.h
index 074a9a09c0a79..a5b60c9a24189 100644
--- a/drivers/gpu/drm/amd/amdgpu/navi10_sdma_pkt_open.h
+++ b/drivers/gpu/drm/amd/amdgpu/navi10_sdma_pkt_open.h
@@ -73,6 +73,22 @@
 #define SDMA_OP_AQL_COPY  0
 #define SDMA_OP_AQL_BARRIER_OR  0
 
+#define SDMA_GCR_RANGE_IS_PA		(1 << 18)
+#define SDMA_GCR_SEQ(x)			(((x) & 0x3) << 16)
+#define SDMA_GCR_GL2_WB			(1 << 15)
+#define SDMA_GCR_GL2_INV		(1 << 14)
+#define SDMA_GCR_GL2_DISCARD		(1 << 13)
+#define SDMA_GCR_GL2_RANGE(x)		(((x) & 0x3) << 11)
+#define SDMA_GCR_GL2_US			(1 << 10)
+#define SDMA_GCR_GL1_INV		(1 << 9)
+#define SDMA_GCR_GLV_INV		(1 << 8)
+#define SDMA_GCR_GLK_INV		(1 << 7)
+#define SDMA_GCR_GLK_WB			(1 << 6)
+#define SDMA_GCR_GLM_INV		(1 << 5)
+#define SDMA_GCR_GLM_WB			(1 << 4)
+#define SDMA_GCR_GL1_RANGE(x)		(((x) & 0x3) << 2)
+#define SDMA_GCR_GLI_INV(x)		(((x) & 0x3) << 0)
+
 /*define for op field*/
 #define SDMA_PKT_HEADER_op_offset 0
 #define SDMA_PKT_HEADER_op_mask   0x000000FF
diff --git a/drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c b/drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c
index 2a792d7abe007..bd715012185c6 100644
--- a/drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c
@@ -382,6 +382,18 @@ static void sdma_v5_0_ring_emit_ib(struct amdgpu_ring *ring,
 	unsigned vmid = AMDGPU_JOB_GET_VMID(job);
 	uint64_t csa_mc_addr = amdgpu_sdma_get_csa_mc_addr(ring, vmid);
 
+	/* Invalidate L2, because if we don't do it, we might get stale cache
+	 * lines from previous IBs.
+	 */
+	amdgpu_ring_write(ring, SDMA_PKT_HEADER_OP(SDMA_OP_GCR_REQ));
+	amdgpu_ring_write(ring, 0);
+	amdgpu_ring_write(ring, (SDMA_GCR_GL2_INV |
+				 SDMA_GCR_GL2_WB |
+				 SDMA_GCR_GLM_INV |
+				 SDMA_GCR_GLM_WB) << 16);
+	amdgpu_ring_write(ring, 0xffffff80);
+	amdgpu_ring_write(ring, 0xffff);
+
 	/* An IB packet must end on a 8 DW boundary--the next dword
 	 * must be on a 8-dword boundary. Our IB packet below is 6
 	 * dwords long, thus add x number of NOPs, such that, in
@@ -1607,7 +1619,7 @@ static const struct amdgpu_ring_funcs sdma_v5_0_ring_funcs = {
 		SOC15_FLUSH_GPU_TLB_NUM_WREG * 3 +
 		SOC15_FLUSH_GPU_TLB_NUM_REG_WAIT * 6 * 2 +
 		10 + 10 + 10, /* sdma_v5_0_ring_emit_fence x3 for user fence, vm fence */
-	.emit_ib_size = 7 + 6, /* sdma_v5_0_ring_emit_ib */
+	.emit_ib_size = 5 + 7 + 6, /* sdma_v5_0_ring_emit_ib */
 	.emit_ib = sdma_v5_0_ring_emit_ib,
 	.emit_fence = sdma_v5_0_ring_emit_fence,
 	.emit_pipeline_sync = sdma_v5_0_ring_emit_pipeline_sync,
-- 
2.20.1



