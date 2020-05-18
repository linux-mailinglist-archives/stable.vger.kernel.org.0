Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51A6E1D8256
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729053AbgERRzc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:55:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:60894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731453AbgERRz2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:55:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 521F8207C4;
        Mon, 18 May 2020 17:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824527;
        bh=ojTCDQRwP9wu3Su04Ln7NJUNO3cMlEDTawPCWWCKniU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lzJHkVty7INZWdfBDMTkR6QrqWjA9pvm/BkMR0qa2SZ6waS/BXg1H3hGNiicASkTC
         /3GDmboHAM/xyC+V+N39vRyDmFxgr9l3Z+unlxjKORgnfTDPzvRF7vrkaqvWG/jG7/
         GhMO6X5x0h1nX40GaiuruWO9XNd60Odqnh76YO+U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luben Tuikov <luben.tuikov@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 048/147] drm/amdgpu: simplify padding calculations (v2)
Date:   Mon, 18 May 2020 19:36:11 +0200
Message-Id: <20200518173519.982019557@linuxfoundation.org>
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

From: Luben Tuikov <luben.tuikov@amd.com>

[ Upstream commit ce73516d42c9ab011fad498168b892d28e181db4 ]

Simplify padding calculations.

v2: Comment update and spacing.

Signed-off-by: Luben Tuikov <luben.tuikov@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/cik_sdma.c  |  4 ++--
 drivers/gpu/drm/amd/amdgpu/sdma_v2_4.c |  4 ++--
 drivers/gpu/drm/amd/amdgpu/sdma_v3_0.c |  4 ++--
 drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c |  4 ++--
 drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c | 17 ++++++++++++-----
 5 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/cik_sdma.c b/drivers/gpu/drm/amd/amdgpu/cik_sdma.c
index c45304f1047c5..4af9acc2dc4f9 100644
--- a/drivers/gpu/drm/amd/amdgpu/cik_sdma.c
+++ b/drivers/gpu/drm/amd/amdgpu/cik_sdma.c
@@ -228,7 +228,7 @@ static void cik_sdma_ring_emit_ib(struct amdgpu_ring *ring,
 	u32 extra_bits = vmid & 0xf;
 
 	/* IB packet must end on a 8 DW boundary */
-	cik_sdma_ring_insert_nop(ring, (12 - (lower_32_bits(ring->wptr) & 7)) % 8);
+	cik_sdma_ring_insert_nop(ring, (4 - lower_32_bits(ring->wptr)) & 7);
 
 	amdgpu_ring_write(ring, SDMA_PACKET(SDMA_OPCODE_INDIRECT_BUFFER, 0, extra_bits));
 	amdgpu_ring_write(ring, ib->gpu_addr & 0xffffffe0); /* base must be 32 byte aligned */
@@ -811,7 +811,7 @@ static void cik_sdma_ring_pad_ib(struct amdgpu_ring *ring, struct amdgpu_ib *ib)
 	u32 pad_count;
 	int i;
 
-	pad_count = (8 - (ib->length_dw & 0x7)) % 8;
+	pad_count = (-ib->length_dw) & 7;
 	for (i = 0; i < pad_count; i++)
 		if (sdma && sdma->burst_nop && (i == 0))
 			ib->ptr[ib->length_dw++] =
diff --git a/drivers/gpu/drm/amd/amdgpu/sdma_v2_4.c b/drivers/gpu/drm/amd/amdgpu/sdma_v2_4.c
index a101758380130..b6af67f6f2149 100644
--- a/drivers/gpu/drm/amd/amdgpu/sdma_v2_4.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v2_4.c
@@ -255,7 +255,7 @@ static void sdma_v2_4_ring_emit_ib(struct amdgpu_ring *ring,
 	unsigned vmid = AMDGPU_JOB_GET_VMID(job);
 
 	/* IB packet must end on a 8 DW boundary */
-	sdma_v2_4_ring_insert_nop(ring, (10 - (lower_32_bits(ring->wptr) & 7)) % 8);
+	sdma_v2_4_ring_insert_nop(ring, (2 - lower_32_bits(ring->wptr)) & 7);
 
 	amdgpu_ring_write(ring, SDMA_PKT_HEADER_OP(SDMA_OP_INDIRECT) |
 			  SDMA_PKT_INDIRECT_HEADER_VMID(vmid & 0xf));
@@ -750,7 +750,7 @@ static void sdma_v2_4_ring_pad_ib(struct amdgpu_ring *ring, struct amdgpu_ib *ib
 	u32 pad_count;
 	int i;
 
-	pad_count = (8 - (ib->length_dw & 0x7)) % 8;
+	pad_count = (-ib->length_dw) & 7;
 	for (i = 0; i < pad_count; i++)
 		if (sdma && sdma->burst_nop && (i == 0))
 			ib->ptr[ib->length_dw++] =
diff --git a/drivers/gpu/drm/amd/amdgpu/sdma_v3_0.c b/drivers/gpu/drm/amd/amdgpu/sdma_v3_0.c
index 5f4e2c616241f..cd3ebed46d05f 100644
--- a/drivers/gpu/drm/amd/amdgpu/sdma_v3_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v3_0.c
@@ -429,7 +429,7 @@ static void sdma_v3_0_ring_emit_ib(struct amdgpu_ring *ring,
 	unsigned vmid = AMDGPU_JOB_GET_VMID(job);
 
 	/* IB packet must end on a 8 DW boundary */
-	sdma_v3_0_ring_insert_nop(ring, (10 - (lower_32_bits(ring->wptr) & 7)) % 8);
+	sdma_v3_0_ring_insert_nop(ring, (2 - lower_32_bits(ring->wptr)) & 7);
 
 	amdgpu_ring_write(ring, SDMA_PKT_HEADER_OP(SDMA_OP_INDIRECT) |
 			  SDMA_PKT_INDIRECT_HEADER_VMID(vmid & 0xf));
@@ -1021,7 +1021,7 @@ static void sdma_v3_0_ring_pad_ib(struct amdgpu_ring *ring, struct amdgpu_ib *ib
 	u32 pad_count;
 	int i;
 
-	pad_count = (8 - (ib->length_dw & 0x7)) % 8;
+	pad_count = (-ib->length_dw) & 7;
 	for (i = 0; i < pad_count; i++)
 		if (sdma && sdma->burst_nop && (i == 0))
 			ib->ptr[ib->length_dw++] =
diff --git a/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c b/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
index 4554e72c83786..23de332f3c6ed 100644
--- a/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
@@ -698,7 +698,7 @@ static void sdma_v4_0_ring_emit_ib(struct amdgpu_ring *ring,
 	unsigned vmid = AMDGPU_JOB_GET_VMID(job);
 
 	/* IB packet must end on a 8 DW boundary */
-	sdma_v4_0_ring_insert_nop(ring, (10 - (lower_32_bits(ring->wptr) & 7)) % 8);
+	sdma_v4_0_ring_insert_nop(ring, (2 - lower_32_bits(ring->wptr)) & 7);
 
 	amdgpu_ring_write(ring, SDMA_PKT_HEADER_OP(SDMA_OP_INDIRECT) |
 			  SDMA_PKT_INDIRECT_HEADER_VMID(vmid & 0xf));
@@ -1579,7 +1579,7 @@ static void sdma_v4_0_ring_pad_ib(struct amdgpu_ring *ring, struct amdgpu_ib *ib
 	u32 pad_count;
 	int i;
 
-	pad_count = (8 - (ib->length_dw & 0x7)) % 8;
+	pad_count = (-ib->length_dw) & 7;
 	for (i = 0; i < pad_count; i++)
 		if (sdma && sdma->burst_nop && (i == 0))
 			ib->ptr[ib->length_dw++] =
diff --git a/drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c b/drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c
index 8493bfbbc1484..2a792d7abe007 100644
--- a/drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c
@@ -382,8 +382,15 @@ static void sdma_v5_0_ring_emit_ib(struct amdgpu_ring *ring,
 	unsigned vmid = AMDGPU_JOB_GET_VMID(job);
 	uint64_t csa_mc_addr = amdgpu_sdma_get_csa_mc_addr(ring, vmid);
 
-	/* IB packet must end on a 8 DW boundary */
-	sdma_v5_0_ring_insert_nop(ring, (10 - (lower_32_bits(ring->wptr) & 7)) % 8);
+	/* An IB packet must end on a 8 DW boundary--the next dword
+	 * must be on a 8-dword boundary. Our IB packet below is 6
+	 * dwords long, thus add x number of NOPs, such that, in
+	 * modular arithmetic,
+	 * wptr + 6 + x = 8k, k >= 0, which in C is,
+	 * (wptr + 6 + x) % 8 = 0.
+	 * The expression below, is a solution of x.
+	 */
+	sdma_v5_0_ring_insert_nop(ring, (2 - lower_32_bits(ring->wptr)) & 7);
 
 	amdgpu_ring_write(ring, SDMA_PKT_HEADER_OP(SDMA_OP_INDIRECT) |
 			  SDMA_PKT_INDIRECT_HEADER_VMID(vmid & 0xf));
@@ -1086,10 +1093,10 @@ static void sdma_v5_0_vm_set_pte_pde(struct amdgpu_ib *ib,
 }
 
 /**
- * sdma_v5_0_ring_pad_ib - pad the IB to the required number of dw
- *
+ * sdma_v5_0_ring_pad_ib - pad the IB
  * @ib: indirect buffer to fill with padding
  *
+ * Pad the IB with NOPs to a boundary multiple of 8.
  */
 static void sdma_v5_0_ring_pad_ib(struct amdgpu_ring *ring, struct amdgpu_ib *ib)
 {
@@ -1097,7 +1104,7 @@ static void sdma_v5_0_ring_pad_ib(struct amdgpu_ring *ring, struct amdgpu_ib *ib
 	u32 pad_count;
 	int i;
 
-	pad_count = (8 - (ib->length_dw & 0x7)) % 8;
+	pad_count = (-ib->length_dw) & 0x7;
 	for (i = 0; i < pad_count; i++)
 		if (sdma && sdma->burst_nop && (i == 0))
 			ib->ptr[ib->length_dw++] =
-- 
2.20.1



