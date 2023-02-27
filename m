Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD89B6A371A
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 03:06:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbjB0CG5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 21:06:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbjB0CGm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 21:06:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2A141ADDC;
        Sun, 26 Feb 2023 18:06:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E994EB80CB8;
        Mon, 27 Feb 2023 02:05:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AB71C433D2;
        Mon, 27 Feb 2023 02:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677463549;
        bh=cHd/x9+Mf9sE2UqjfhYjvJwRESfJJlkSntrFB1rrzmE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qHYum6DqiujV4EIXiU/pBovxf6a4IfC5TDxegvAngCsLxKsS3Rl+pyl2UPS+gTNNX
         nBYacpZ9yIbhafLbpIHuI5qd8gprwVqYqDK2C276kSKIKQD+eWQawGDc1K0Ap8D1xx
         gUK8vLjQltZU3efoCjiRI5vxdNVCufQ+1ifonisiU7rDOeLv3r5Y9gcdN5jVCKBFX1
         wY6dpNwekU24Ya9I+Yro1rwuKjHzqF1TRQx1CAjs1yqPcpV9Yy0Y94odCV9QmcWTbE
         7OrM3bdLZjA2XVg49Ep2j6BV2PaqyPF7otD+P3z/Hvy49CNt/KfHoUdvDyE5h8ORVa
         XdeZYi6WAQFzQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Philip Yang <Philip.Yang@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@gmail.com, daniel@ffwll.ch,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.1 12/58] drm/amdkfd: Page aligned memory reserve size
Date:   Sun, 26 Feb 2023 21:04:10 -0500
Message-Id: <20230227020457.1048737-12-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230227020457.1048737-1-sashal@kernel.org>
References: <20230227020457.1048737-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Philip Yang <Philip.Yang@amd.com>

[ Upstream commit 0c2dece8fb541ab07b68c3312a1065fa9c927a81 ]

Use page aligned size to reserve memory usage because page aligned TTM
BO size is used to unreserve memory usage, otherwise no page aligned
size causes memory usage accounting unbalanced.

Change vram_used definition type to int64_t to be able to trigger
WARN_ONCE(adev && adev->kfd.vram_used < 0, "..."), to help debug the
accounting issue with warning and backtrace.

Signed-off-by: Philip Yang <Philip.Yang@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h       |  2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c | 12 +++++++-----
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c         |  9 +++++++--
 3 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
index 30f145dc8724e..dbc842590b253 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
@@ -95,7 +95,7 @@ struct amdgpu_amdkfd_fence {
 
 struct amdgpu_kfd_dev {
 	struct kfd_dev *dev;
-	uint64_t vram_used;
+	int64_t vram_used;
 	uint64_t vram_used_aligned;
 	bool init_complete;
 	struct work_struct reset_work;
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
index 404c839683b1c..da01c1424b4ad 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -1653,6 +1653,7 @@ int amdgpu_amdkfd_gpuvm_alloc_memory_of_gpu(
 	struct amdgpu_bo *bo;
 	struct drm_gem_object *gobj = NULL;
 	u32 domain, alloc_domain;
+	uint64_t aligned_size;
 	u64 alloc_flags;
 	int ret;
 
@@ -1703,22 +1704,23 @@ int amdgpu_amdkfd_gpuvm_alloc_memory_of_gpu(
 	 * the memory.
 	 */
 	if ((*mem)->aql_queue)
-		size = size >> 1;
+		size >>= 1;
+	aligned_size = PAGE_ALIGN(size);
 
 	(*mem)->alloc_flags = flags;
 
 	amdgpu_sync_create(&(*mem)->sync);
 
-	ret = amdgpu_amdkfd_reserve_mem_limit(adev, size, flags);
+	ret = amdgpu_amdkfd_reserve_mem_limit(adev, aligned_size, flags);
 	if (ret) {
 		pr_debug("Insufficient memory\n");
 		goto err_reserve_limit;
 	}
 
 	pr_debug("\tcreate BO VA 0x%llx size 0x%llx domain %s\n",
-			va, size, domain_string(alloc_domain));
+			va, (*mem)->aql_queue ? size << 1 : size, domain_string(alloc_domain));
 
-	ret = amdgpu_gem_object_create(adev, size, 1, alloc_domain, alloc_flags,
+	ret = amdgpu_gem_object_create(adev, aligned_size, 1, alloc_domain, alloc_flags,
 				       bo_type, NULL, &gobj);
 	if (ret) {
 		pr_debug("Failed to create BO on domain %s. ret %d\n",
@@ -1775,7 +1777,7 @@ int amdgpu_amdkfd_gpuvm_alloc_memory_of_gpu(
 	/* Don't unreserve system mem limit twice */
 	goto err_reserve_limit;
 err_bo_create:
-	amdgpu_amdkfd_unreserve_mem_limit(adev, size, flags);
+	amdgpu_amdkfd_unreserve_mem_limit(adev, aligned_size, flags);
 err_reserve_limit:
 	mutex_destroy(&(*mem)->lock);
 	if (gobj)
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
index 6d291aa6386bd..f79b8e964140e 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -1127,8 +1127,13 @@ static int kfd_ioctl_alloc_memory_of_gpu(struct file *filep,
 	}
 
 	/* Update the VRAM usage count */
-	if (flags & KFD_IOC_ALLOC_MEM_FLAGS_VRAM)
-		WRITE_ONCE(pdd->vram_usage, pdd->vram_usage + args->size);
+	if (flags & KFD_IOC_ALLOC_MEM_FLAGS_VRAM) {
+		uint64_t size = args->size;
+
+		if (flags & KFD_IOC_ALLOC_MEM_FLAGS_AQL_QUEUE_MEM)
+			size >>= 1;
+		WRITE_ONCE(pdd->vram_usage, pdd->vram_usage + PAGE_ALIGN(size));
+	}
 
 	mutex_unlock(&p->mutex);
 
-- 
2.39.0

