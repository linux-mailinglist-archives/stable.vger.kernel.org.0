Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1140E67EE
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:25:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731756AbfJ0VZj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:25:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:47504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732779AbfJ0VZi (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:25:38 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B347421850;
        Sun, 27 Oct 2019 21:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211537;
        bh=eRXpJNeQCyyCD23nmN3XQx5ovGSGyho2lmGLOeVxShs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0T7+Cz2DlLAg90wg2cdVIprHqVdSRtTOjubwZlP5ObUqcjMmJftgEzCSlVeZJBCFI
         6y5c1PIdLOkKu/QxGOnq+oo/Z3/TWJ+2TR4vy2//47C0ovnQzSkg3PGMg+3u9QW2Sc
         ju9sUNpwFIarZZkU+t3o5X5QQgoEHM+dgqg8s3H0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        James Zhu <James.Zhu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.3 132/197] drm/amdgpu/vcn: fix allocation size in enc ring test
Date:   Sun, 27 Oct 2019 22:00:50 +0100
Message-Id: <20191027203358.845695967@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

commit c81fffc2c9450750dd7a54a36a788a860ab0425d upstream.

We need to allocate a large enough buffer for the
session info, otherwise the IB test can overwrite
other memory.

- Session info is 128K according to mesa
- Use the same session info for create and destroy

Bug: https://bugzilla.kernel.org/show_bug.cgi?id=204241
Acked-by: Christian König <christian.koenig@amd.com>
Reviewed-by: James Zhu <James.Zhu@amd.com>
Tested-by: James Zhu <James.Zhu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c |   35 +++++++++++++++++++++-----------
 1 file changed, 23 insertions(+), 12 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c
@@ -517,13 +517,14 @@ int amdgpu_vcn_enc_ring_test_ring(struct
 }
 
 static int amdgpu_vcn_enc_get_create_msg(struct amdgpu_ring *ring, uint32_t handle,
-			      struct dma_fence **fence)
+					 struct amdgpu_bo *bo,
+					 struct dma_fence **fence)
 {
 	const unsigned ib_size_dw = 16;
 	struct amdgpu_job *job;
 	struct amdgpu_ib *ib;
 	struct dma_fence *f = NULL;
-	uint64_t dummy;
+	uint64_t addr;
 	int i, r;
 
 	r = amdgpu_job_alloc_with_ib(ring->adev, ib_size_dw * 4, &job);
@@ -531,14 +532,14 @@ static int amdgpu_vcn_enc_get_create_msg
 		return r;
 
 	ib = &job->ibs[0];
-	dummy = ib->gpu_addr + 1024;
+	addr = amdgpu_bo_gpu_offset(bo);
 
 	ib->length_dw = 0;
 	ib->ptr[ib->length_dw++] = 0x00000018;
 	ib->ptr[ib->length_dw++] = 0x00000001; /* session info */
 	ib->ptr[ib->length_dw++] = handle;
-	ib->ptr[ib->length_dw++] = upper_32_bits(dummy);
-	ib->ptr[ib->length_dw++] = dummy;
+	ib->ptr[ib->length_dw++] = upper_32_bits(addr);
+	ib->ptr[ib->length_dw++] = addr;
 	ib->ptr[ib->length_dw++] = 0x0000000b;
 
 	ib->ptr[ib->length_dw++] = 0x00000014;
@@ -569,13 +570,14 @@ err:
 }
 
 static int amdgpu_vcn_enc_get_destroy_msg(struct amdgpu_ring *ring, uint32_t handle,
-				struct dma_fence **fence)
+					  struct amdgpu_bo *bo,
+					  struct dma_fence **fence)
 {
 	const unsigned ib_size_dw = 16;
 	struct amdgpu_job *job;
 	struct amdgpu_ib *ib;
 	struct dma_fence *f = NULL;
-	uint64_t dummy;
+	uint64_t addr;
 	int i, r;
 
 	r = amdgpu_job_alloc_with_ib(ring->adev, ib_size_dw * 4, &job);
@@ -583,14 +585,14 @@ static int amdgpu_vcn_enc_get_destroy_ms
 		return r;
 
 	ib = &job->ibs[0];
-	dummy = ib->gpu_addr + 1024;
+	addr = amdgpu_bo_gpu_offset(bo);
 
 	ib->length_dw = 0;
 	ib->ptr[ib->length_dw++] = 0x00000018;
 	ib->ptr[ib->length_dw++] = 0x00000001;
 	ib->ptr[ib->length_dw++] = handle;
-	ib->ptr[ib->length_dw++] = upper_32_bits(dummy);
-	ib->ptr[ib->length_dw++] = dummy;
+	ib->ptr[ib->length_dw++] = upper_32_bits(addr);
+	ib->ptr[ib->length_dw++] = addr;
 	ib->ptr[ib->length_dw++] = 0x0000000b;
 
 	ib->ptr[ib->length_dw++] = 0x00000014;
@@ -623,13 +625,20 @@ err:
 int amdgpu_vcn_enc_ring_test_ib(struct amdgpu_ring *ring, long timeout)
 {
 	struct dma_fence *fence = NULL;
+	struct amdgpu_bo *bo = NULL;
 	long r;
 
-	r = amdgpu_vcn_enc_get_create_msg(ring, 1, NULL);
+	r = amdgpu_bo_create_reserved(ring->adev, 128 * 1024, PAGE_SIZE,
+				      AMDGPU_GEM_DOMAIN_VRAM,
+				      &bo, NULL, NULL);
+	if (r)
+		return r;
+
+	r = amdgpu_vcn_enc_get_create_msg(ring, 1, bo, NULL);
 	if (r)
 		goto error;
 
-	r = amdgpu_vcn_enc_get_destroy_msg(ring, 1, &fence);
+	r = amdgpu_vcn_enc_get_destroy_msg(ring, 1, bo, &fence);
 	if (r)
 		goto error;
 
@@ -641,6 +650,8 @@ int amdgpu_vcn_enc_ring_test_ib(struct a
 
 error:
 	dma_fence_put(fence);
+	amdgpu_bo_unreserve(bo);
+	amdgpu_bo_unref(&bo);
 	return r;
 }
 


