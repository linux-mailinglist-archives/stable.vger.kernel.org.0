Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86B1C54A43A
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 04:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350765AbiFNCFW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 22:05:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351007AbiFNCFO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 22:05:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 978B0340DE;
        Mon, 13 Jun 2022 19:05:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D583660A56;
        Tue, 14 Jun 2022 02:05:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C008C385A2;
        Tue, 14 Jun 2022 02:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655172309;
        bh=jvY6zLIFYZFwPqwJyHm4FYdTHBXHgYFw9HzPnyPYv5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OUkp6L2r8oOyhPI7sfOi+3jOeWAInBxyni2x0/Ebwj1nNrKCYnvAEAYcYuVzCJNRl
         8elJjs9sKQxjD6OKW70GeEmA/Js9X1QyHqDMfUGOGvenkEVdU1Km909kVMvj6k492b
         3dsOWaHUgWUsWlr0NucT71olaWP4zClss4j4OGfYfXLf4AQm4ANYGqCRIryoOu4DGb
         mFAvJcdEA8X920iDqQnq3vOy9RGszianebgK7SsM4cke+CGxsCI6iKIZ5ZyIYN3rhV
         XXKEbsP39ERLgL454Xy+fTyUNenZ424zBVBamu4sfCR9UBlY1HbeJASOSaWxj3lqgs
         uDKHu3wT/kHXw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lang Yu <Lang.Yu@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, airlied@linux.ie,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.18 15/47] drm/amdkfd: add pinned BOs to kfd_bo_list
Date:   Mon, 13 Jun 2022 22:04:08 -0400
Message-Id: <20220614020441.1098348-15-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220614020441.1098348-1-sashal@kernel.org>
References: <20220614020441.1098348-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lang Yu <Lang.Yu@amd.com>

[ Upstream commit 4fac4fcf4500bce515b0f32195e7bb86aa0246c6 ]

The kfd_bo_list is used to restore process BOs after
evictions. As page tables could be destroyed during
evictions, we should also update pinned BOs' page tables
during restoring to make sure they are valid.

So for pinned BOs,
1, Validate them and update their page tables.
2, Don't add eviction fence for them.

v2:
 - Don't handle pinned ones specially in BO validation.(Felix)

Signed-off-by: Lang Yu <Lang.Yu@amd.com>
Acked-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
index cd89d2e46852..f4509656ea8c 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -1955,9 +1955,6 @@ int amdgpu_amdkfd_gpuvm_map_gtt_bo_to_kernel(struct amdgpu_device *adev,
 		return -EINVAL;
 	}
 
-	/* delete kgd_mem from kfd_bo_list to avoid re-validating
-	 * this BO in BO's restoring after eviction.
-	 */
 	mutex_lock(&mem->process_info->lock);
 
 	ret = amdgpu_bo_reserve(bo, true);
@@ -1980,7 +1977,6 @@ int amdgpu_amdkfd_gpuvm_map_gtt_bo_to_kernel(struct amdgpu_device *adev,
 
 	amdgpu_amdkfd_remove_eviction_fence(
 		bo, mem->process_info->eviction_fence);
-	list_del_init(&mem->validate_list.head);
 
 	if (size)
 		*size = amdgpu_bo_size(bo);
@@ -2544,12 +2540,15 @@ int amdgpu_amdkfd_gpuvm_restore_process_bos(void *info, struct dma_fence **ef)
 	process_info->eviction_fence = new_fence;
 	*ef = dma_fence_get(&new_fence->base);
 
-	/* Attach new eviction fence to all BOs */
+	/* Attach new eviction fence to all BOs except pinned ones */
 	list_for_each_entry(mem, &process_info->kfd_bo_list,
-		validate_list.head)
+		validate_list.head) {
+		if (mem->bo->tbo.pin_count)
+			continue;
+
 		amdgpu_bo_fence(mem->bo,
 			&process_info->eviction_fence->base, true);
-
+	}
 	/* Attach eviction fence to PD / PT BOs */
 	list_for_each_entry(peer_vm, &process_info->vm_list_head,
 			    vm_list_node) {
-- 
2.35.1

