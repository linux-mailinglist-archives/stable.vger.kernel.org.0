Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 906ADE6841
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:28:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732290AbfJ0VXI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:23:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:44252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731618AbfJ0VXH (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:23:07 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 995C1205C9;
        Sun, 27 Oct 2019 21:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211386;
        bh=2K+kbrC0pT7NeYLIPxFN+7ukgau/pSNVnR6/Ps6OhsQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eXGd61xJjXv9goeFIqUj9LMfPQA1fb+cSkkndbKlMyih5myB+plF26TjCXwHYQoM4
         pLa1+v1CsUp7+iHdT3Jj8JG6w2Yvn47cLDS2XJYCr9tro3MCvtgcY6MexNEYOaS6qX
         LF37qwNSpQgcYqRc0F5lHWg9G7QmFtwdjjm3ieFo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Zhu <James.Zhu@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.3 131/197] drm/amdgpu/vce: fix allocation size in enc ring test
Date:   Sun, 27 Oct 2019 22:00:49 +0100
Message-Id: <20191027203358.794097652@linuxfoundation.org>
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

commit ee027828c40faa92a7ef4c2b0641bbb3f4be95d3 upstream.

We need to allocate a large enough buffer for the
feedback buffer, otherwise the IB test can overwrite
other memory.

Reviewed-by: James Zhu <James.Zhu@amd.com>
Acked-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vce.c |   20 +++++++++++++++-----
 drivers/gpu/drm/amd/amdgpu/amdgpu_vce.h |    1 +
 2 files changed, 16 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vce.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vce.c
@@ -429,13 +429,14 @@ void amdgpu_vce_free_handles(struct amdg
  * Open up a stream for HW test
  */
 int amdgpu_vce_get_create_msg(struct amdgpu_ring *ring, uint32_t handle,
+			      struct amdgpu_bo *bo,
 			      struct dma_fence **fence)
 {
 	const unsigned ib_size_dw = 1024;
 	struct amdgpu_job *job;
 	struct amdgpu_ib *ib;
 	struct dma_fence *f = NULL;
-	uint64_t dummy;
+	uint64_t addr;
 	int i, r;
 
 	r = amdgpu_job_alloc_with_ib(ring->adev, ib_size_dw * 4, &job);
@@ -444,7 +445,7 @@ int amdgpu_vce_get_create_msg(struct amd
 
 	ib = &job->ibs[0];
 
-	dummy = ib->gpu_addr + 1024;
+	addr = amdgpu_bo_gpu_offset(bo);
 
 	/* stitch together an VCE create msg */
 	ib->length_dw = 0;
@@ -476,8 +477,8 @@ int amdgpu_vce_get_create_msg(struct amd
 
 	ib->ptr[ib->length_dw++] = 0x00000014; /* len */
 	ib->ptr[ib->length_dw++] = 0x05000005; /* feedback buffer */
-	ib->ptr[ib->length_dw++] = upper_32_bits(dummy);
-	ib->ptr[ib->length_dw++] = dummy;
+	ib->ptr[ib->length_dw++] = upper_32_bits(addr);
+	ib->ptr[ib->length_dw++] = addr;
 	ib->ptr[ib->length_dw++] = 0x00000001;
 
 	for (i = ib->length_dw; i < ib_size_dw; ++i)
@@ -1110,13 +1111,20 @@ int amdgpu_vce_ring_test_ring(struct amd
 int amdgpu_vce_ring_test_ib(struct amdgpu_ring *ring, long timeout)
 {
 	struct dma_fence *fence = NULL;
+	struct amdgpu_bo *bo = NULL;
 	long r;
 
 	/* skip vce ring1/2 ib test for now, since it's not reliable */
 	if (ring != &ring->adev->vce.ring[0])
 		return 0;
 
-	r = amdgpu_vce_get_create_msg(ring, 1, NULL);
+	r = amdgpu_bo_create_reserved(ring->adev, 512, PAGE_SIZE,
+				      AMDGPU_GEM_DOMAIN_VRAM,
+				      &bo, NULL, NULL);
+	if (r)
+		return r;
+
+	r = amdgpu_vce_get_create_msg(ring, 1, bo, NULL);
 	if (r)
 		goto error;
 
@@ -1132,5 +1140,7 @@ int amdgpu_vce_ring_test_ib(struct amdgp
 
 error:
 	dma_fence_put(fence);
+	amdgpu_bo_unreserve(bo);
+	amdgpu_bo_unref(&bo);
 	return r;
 }
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vce.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vce.h
@@ -59,6 +59,7 @@ int amdgpu_vce_entity_init(struct amdgpu
 int amdgpu_vce_suspend(struct amdgpu_device *adev);
 int amdgpu_vce_resume(struct amdgpu_device *adev);
 int amdgpu_vce_get_create_msg(struct amdgpu_ring *ring, uint32_t handle,
+			      struct amdgpu_bo *bo,
 			      struct dma_fence **fence);
 int amdgpu_vce_get_destroy_msg(struct amdgpu_ring *ring, uint32_t handle,
 			       bool direct, struct dma_fence **fence);


