Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF66E67BE
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:24:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730133AbfJ0VYB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:24:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:45384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732411AbfJ0VX6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:23:58 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6DAC21726;
        Sun, 27 Oct 2019 21:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211437;
        bh=7hY4aOUAT25qZzu5Zp8O4Xw+/lhFo9NIKHCkfDHF/X4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UY8tI9vtur6aqXfarJt/QpbYSSKBDLUIgI8QUN84g1+QwQQFBjwBRTponuW2eSUiT
         ZIUoZZ/m5jA38NP39uTTNQWzUxxErTF7oRGhic4FKUDYqhMR3nhPG5uqRiUeyeeryc
         t9w4NQKe59rb2+eD4Xo8zUdI7Ek8qDjc9vK6hUBY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        James Zhu <James.Zhu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.3 134/197] drm/amdgpu/uvd7: fix allocation size in enc ring test (v2)
Date:   Sun, 27 Oct 2019 22:00:52 +0100
Message-Id: <20191027203358.951696366@linuxfoundation.org>
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

commit 5d230bc91f6c15e5d281f2851502918d98b9e770 upstream.

We need to allocate a large enough buffer for the
session info, otherwise the IB test can overwrite
other memory.

v2: - session info is 128K according to mesa
    - use the same session info for create and destroy

Bug: https://bugzilla.kernel.org/show_bug.cgi?id=204241
Acked-by: Christian König <christian.koenig@amd.com>
Reviewed-by: James Zhu <James.Zhu@amd.com>
Tested-by: James Zhu <James.Zhu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/amdgpu/uvd_v7_0.c |   33 ++++++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 11 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/uvd_v7_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/uvd_v7_0.c
@@ -214,13 +214,14 @@ static int uvd_v7_0_enc_ring_test_ring(s
  * Open up a stream for HW test
  */
 static int uvd_v7_0_enc_get_create_msg(struct amdgpu_ring *ring, uint32_t handle,
+				       struct amdgpu_bo *bo,
 				       struct dma_fence **fence)
 {
 	const unsigned ib_size_dw = 16;
 	struct amdgpu_job *job;
 	struct amdgpu_ib *ib;
 	struct dma_fence *f = NULL;
-	uint64_t dummy;
+	uint64_t addr;
 	int i, r;
 
 	r = amdgpu_job_alloc_with_ib(ring->adev, ib_size_dw * 4, &job);
@@ -228,15 +229,15 @@ static int uvd_v7_0_enc_get_create_msg(s
 		return r;
 
 	ib = &job->ibs[0];
-	dummy = ib->gpu_addr + 1024;
+	addr = amdgpu_bo_gpu_offset(bo);
 
 	ib->length_dw = 0;
 	ib->ptr[ib->length_dw++] = 0x00000018;
 	ib->ptr[ib->length_dw++] = 0x00000001; /* session info */
 	ib->ptr[ib->length_dw++] = handle;
 	ib->ptr[ib->length_dw++] = 0x00000000;
-	ib->ptr[ib->length_dw++] = upper_32_bits(dummy);
-	ib->ptr[ib->length_dw++] = dummy;
+	ib->ptr[ib->length_dw++] = upper_32_bits(addr);
+	ib->ptr[ib->length_dw++] = addr;
 
 	ib->ptr[ib->length_dw++] = 0x00000014;
 	ib->ptr[ib->length_dw++] = 0x00000002; /* task info */
@@ -275,13 +276,14 @@ err:
  * Close up a stream for HW test or if userspace failed to do so
  */
 static int uvd_v7_0_enc_get_destroy_msg(struct amdgpu_ring *ring, uint32_t handle,
-				struct dma_fence **fence)
+					struct amdgpu_bo *bo,
+					struct dma_fence **fence)
 {
 	const unsigned ib_size_dw = 16;
 	struct amdgpu_job *job;
 	struct amdgpu_ib *ib;
 	struct dma_fence *f = NULL;
-	uint64_t dummy;
+	uint64_t addr;
 	int i, r;
 
 	r = amdgpu_job_alloc_with_ib(ring->adev, ib_size_dw * 4, &job);
@@ -289,15 +291,15 @@ static int uvd_v7_0_enc_get_destroy_msg(
 		return r;
 
 	ib = &job->ibs[0];
-	dummy = ib->gpu_addr + 1024;
+	addr = amdgpu_bo_gpu_offset(bo);
 
 	ib->length_dw = 0;
 	ib->ptr[ib->length_dw++] = 0x00000018;
 	ib->ptr[ib->length_dw++] = 0x00000001;
 	ib->ptr[ib->length_dw++] = handle;
 	ib->ptr[ib->length_dw++] = 0x00000000;
-	ib->ptr[ib->length_dw++] = upper_32_bits(dummy);
-	ib->ptr[ib->length_dw++] = dummy;
+	ib->ptr[ib->length_dw++] = upper_32_bits(addr);
+	ib->ptr[ib->length_dw++] = addr;
 
 	ib->ptr[ib->length_dw++] = 0x00000014;
 	ib->ptr[ib->length_dw++] = 0x00000002;
@@ -334,13 +336,20 @@ err:
 static int uvd_v7_0_enc_ring_test_ib(struct amdgpu_ring *ring, long timeout)
 {
 	struct dma_fence *fence = NULL;
+	struct amdgpu_bo *bo = NULL;
 	long r;
 
-	r = uvd_v7_0_enc_get_create_msg(ring, 1, NULL);
+	r = amdgpu_bo_create_reserved(ring->adev, 128 * 1024, PAGE_SIZE,
+				      AMDGPU_GEM_DOMAIN_VRAM,
+				      &bo, NULL, NULL);
+	if (r)
+		return r;
+
+	r = uvd_v7_0_enc_get_create_msg(ring, 1, bo, NULL);
 	if (r)
 		goto error;
 
-	r = uvd_v7_0_enc_get_destroy_msg(ring, 1, &fence);
+	r = uvd_v7_0_enc_get_destroy_msg(ring, 1, bo, &fence);
 	if (r)
 		goto error;
 
@@ -352,6 +361,8 @@ static int uvd_v7_0_enc_ring_test_ib(str
 
 error:
 	dma_fence_put(fence);
+	amdgpu_bo_unreserve(bo);
+	amdgpu_bo_unref(&bo);
 	return r;
 }
 


