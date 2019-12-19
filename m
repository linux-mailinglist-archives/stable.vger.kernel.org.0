Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E213126B77
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:57:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730853AbfLSS4m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:56:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:53374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730851AbfLSS4l (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:56:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5489A24680;
        Thu, 19 Dec 2019 18:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781800;
        bh=n3LB/i2T6bdeabCrViHehSXGPiFqsgg13s0tmfgofSE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NoXc2cGJlVV/D/3mrVx1DIMp6R+pUWvWl6TFX2UZOF5vaFMOIylshjr1YoRj0ezkW
         F94PX6KGETb0fKGojeY8YReXCAQSu6L1RCbWsd8ef5UJx2ClIUOQUlB/UV4FEhTC1q
         3u+BJW9YHkoQ4XGd601BH/zkxSSwhIqQWo4I7A+o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, changzhu <Changfeng.Zhu@amd.com>,
        Huang Rui <ray.huang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.4 79/80] drm/amdgpu: avoid using invalidate semaphore for picasso
Date:   Thu, 19 Dec 2019 19:35:11 +0100
Message-Id: <20191219183149.722641313@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183031.278083125@linuxfoundation.org>
References: <20191219183031.278083125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: changzhu <Changfeng.Zhu@amd.com>

commit 413fc385a594ea6eb08843be33939057ddfdae76 upstream.

It may cause timeout waiting for sem acquire in VM flush when using
invalidate semaphore for picasso. So it needs to avoid using invalidate
semaphore for piasso.

Signed-off-by: changzhu <Changfeng.Zhu@amd.com>
Reviewed-by: Huang Rui <ray.huang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c |   28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
@@ -500,8 +500,11 @@ static void gmc_v9_0_flush_gpu_tlb(struc
 	 */
 
 	/* TODO: It needs to continue working on debugging with semaphore for GFXHUB as well. */
-	if (vmhub == AMDGPU_MMHUB_0 ||
-	    vmhub == AMDGPU_MMHUB_1) {
+	if ((vmhub == AMDGPU_MMHUB_0 ||
+	     vmhub == AMDGPU_MMHUB_1) &&
+	    (!(adev->asic_type == CHIP_RAVEN &&
+	       adev->rev_id < 0x8 &&
+	       adev->pdev->device == 0x15d8))) {
 		for (j = 0; j < adev->usec_timeout; j++) {
 			/* a read return value of 1 means semaphore acuqire */
 			tmp = RREG32_NO_KIQ(hub->vm_inv_eng0_sem + eng);
@@ -531,8 +534,11 @@ static void gmc_v9_0_flush_gpu_tlb(struc
 	}
 
 	/* TODO: It needs to continue working on debugging with semaphore for GFXHUB as well. */
-	if (vmhub == AMDGPU_MMHUB_0 ||
-	    vmhub == AMDGPU_MMHUB_1)
+	if ((vmhub == AMDGPU_MMHUB_0 ||
+	     vmhub == AMDGPU_MMHUB_1) &&
+	    (!(adev->asic_type == CHIP_RAVEN &&
+	       adev->rev_id < 0x8 &&
+	       adev->pdev->device == 0x15d8)))
 		/*
 		 * add semaphore release after invalidation,
 		 * write with 0 means semaphore release
@@ -563,8 +569,11 @@ static uint64_t gmc_v9_0_emit_flush_gpu_
 	 */
 
 	/* TODO: It needs to continue working on debugging with semaphore for GFXHUB as well. */
-	if (ring->funcs->vmhub == AMDGPU_MMHUB_0 ||
-	    ring->funcs->vmhub == AMDGPU_MMHUB_1)
+	if ((ring->funcs->vmhub == AMDGPU_MMHUB_0 ||
+	     ring->funcs->vmhub == AMDGPU_MMHUB_1) &&
+	    (!(adev->asic_type == CHIP_RAVEN &&
+	       adev->rev_id < 0x8 &&
+	       adev->pdev->device == 0x15d8)))
 		/* a read return value of 1 means semaphore acuqire */
 		amdgpu_ring_emit_reg_wait(ring,
 					  hub->vm_inv_eng0_sem + eng, 0x1, 0x1);
@@ -580,8 +589,11 @@ static uint64_t gmc_v9_0_emit_flush_gpu_
 					    req, 1 << vmid);
 
 	/* TODO: It needs to continue working on debugging with semaphore for GFXHUB as well. */
-	if (ring->funcs->vmhub == AMDGPU_MMHUB_0 ||
-	    ring->funcs->vmhub == AMDGPU_MMHUB_1)
+	if ((ring->funcs->vmhub == AMDGPU_MMHUB_0 ||
+	     ring->funcs->vmhub == AMDGPU_MMHUB_1) &&
+	    (!(adev->asic_type == CHIP_RAVEN &&
+	       adev->rev_id < 0x8 &&
+	       adev->pdev->device == 0x15d8)))
 		/*
 		 * add semaphore release after invalidation,
 		 * write with 0 means semaphore release


