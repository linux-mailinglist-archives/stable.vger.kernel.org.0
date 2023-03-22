Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 186BF6C55DF
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 21:01:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231420AbjCVUBe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 16:01:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231209AbjCVUAj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 16:00:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2DCE6B5D5;
        Wed, 22 Mar 2023 12:58:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 87111B81DE8;
        Wed, 22 Mar 2023 19:58:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00F23C433EF;
        Wed, 22 Mar 2023 19:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679515110;
        bh=EnesByuTN3+cFtldbykaUe5M7GvSSZRNv1wpFYKaUXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VjzBYFa/ZzPrCbuoX43W/B16A1lZ5C4rkYEC7Wlxy3fRJvifybs1sfTS2wvh6Vc4U
         I5qnHlEF5+gXMTBF49IIOXKb9gUMREg9m44O2pvXlrNTu1ewF220giYMBDmH7zGS6+
         m4EIL/3X+tMlasRzOqlEVQthNDFplo35HCJS/KuLeFmkDyo6MlUJe9bAA/oHRTPo2t
         OYC6hq23YnXvVCCYw1B4rHW/9zh04WjKiFcjHviho/IG9lETPdzgay2AJNEjUO9yr0
         lEOVzPB4IQ8lta14ZsKQnxPYeMyjxAkI4P8rE39tRYWB+l+wSAZRseo44Pj7sMnd6r
         Y3rQOdr5Ndi3Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiaogang Chen <Xiaogang.Chen@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@gmail.com, daniel@ffwll.ch,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.2 24/45] drm/amdkfd: Fix BO offset for multi-VMA page migration
Date:   Wed, 22 Mar 2023 15:56:18 -0400
Message-Id: <20230322195639.1995821-24-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230322195639.1995821-1-sashal@kernel.org>
References: <20230322195639.1995821-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaogang Chen <Xiaogang.Chen@amd.com>

[ Upstream commit b4ee9606378bb9520c94d8b96f0305c3696f5c29 ]

svm_migrate_ram_to_vram migrates a prange from sys ram to vram. The prange may
cross multiple vma. Need remember current dst vram offset in the TTM resource for
each migration.

v2: squash in warning fix (Alex)

Signed-off-by: Xiaogang Chen <Xiaogang.Chen@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
index 10048ce16aea4..5c319007b4701 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
@@ -289,7 +289,7 @@ static unsigned long svm_migrate_unsuccessful_pages(struct migrate_vma *migrate)
 static int
 svm_migrate_copy_to_vram(struct amdgpu_device *adev, struct svm_range *prange,
 			 struct migrate_vma *migrate, struct dma_fence **mfence,
-			 dma_addr_t *scratch)
+			 dma_addr_t *scratch, uint64_t ttm_res_offset)
 {
 	uint64_t npages = migrate->npages;
 	struct device *dev = adev->dev;
@@ -299,8 +299,8 @@ svm_migrate_copy_to_vram(struct amdgpu_device *adev, struct svm_range *prange,
 	uint64_t i, j;
 	int r;
 
-	pr_debug("svms 0x%p [0x%lx 0x%lx]\n", prange->svms, prange->start,
-		 prange->last);
+	pr_debug("svms 0x%p [0x%lx 0x%lx 0x%llx]\n", prange->svms, prange->start,
+		 prange->last, ttm_res_offset);
 
 	src = scratch;
 	dst = (uint64_t *)(scratch + npages);
@@ -311,7 +311,7 @@ svm_migrate_copy_to_vram(struct amdgpu_device *adev, struct svm_range *prange,
 		goto out;
 	}
 
-	amdgpu_res_first(prange->ttm_res, prange->offset << PAGE_SHIFT,
+	amdgpu_res_first(prange->ttm_res, ttm_res_offset,
 			 npages << PAGE_SHIFT, &cursor);
 	for (i = j = 0; i < npages; i++) {
 		struct page *spage;
@@ -398,7 +398,7 @@ svm_migrate_copy_to_vram(struct amdgpu_device *adev, struct svm_range *prange,
 static long
 svm_migrate_vma_to_vram(struct amdgpu_device *adev, struct svm_range *prange,
 			struct vm_area_struct *vma, uint64_t start,
-			uint64_t end, uint32_t trigger)
+			uint64_t end, uint32_t trigger, uint64_t ttm_res_offset)
 {
 	struct kfd_process *p = container_of(prange->svms, struct kfd_process, svms);
 	uint64_t npages = (end - start) >> PAGE_SHIFT;
@@ -451,7 +451,7 @@ svm_migrate_vma_to_vram(struct amdgpu_device *adev, struct svm_range *prange,
 	else
 		pr_debug("0x%lx pages migrated\n", cpages);
 
-	r = svm_migrate_copy_to_vram(adev, prange, &migrate, &mfence, scratch);
+	r = svm_migrate_copy_to_vram(adev, prange, &migrate, &mfence, scratch, ttm_res_offset);
 	migrate_vma_pages(&migrate);
 
 	pr_debug("successful/cpages/npages 0x%lx/0x%lx/0x%lx\n",
@@ -499,6 +499,7 @@ svm_migrate_ram_to_vram(struct svm_range *prange, uint32_t best_loc,
 	unsigned long addr, start, end;
 	struct vm_area_struct *vma;
 	struct amdgpu_device *adev;
+	uint64_t ttm_res_offset;
 	unsigned long cpages = 0;
 	long r = 0;
 
@@ -519,6 +520,7 @@ svm_migrate_ram_to_vram(struct svm_range *prange, uint32_t best_loc,
 
 	start = prange->start << PAGE_SHIFT;
 	end = (prange->last + 1) << PAGE_SHIFT;
+	ttm_res_offset = prange->offset << PAGE_SHIFT;
 
 	for (addr = start; addr < end;) {
 		unsigned long next;
@@ -528,13 +530,14 @@ svm_migrate_ram_to_vram(struct svm_range *prange, uint32_t best_loc,
 			break;
 
 		next = min(vma->vm_end, end);
-		r = svm_migrate_vma_to_vram(adev, prange, vma, addr, next, trigger);
+		r = svm_migrate_vma_to_vram(adev, prange, vma, addr, next, trigger, ttm_res_offset);
 		if (r < 0) {
 			pr_debug("failed %ld to migrate\n", r);
 			break;
 		} else {
 			cpages += r;
 		}
+		ttm_res_offset += next - addr;
 		addr = next;
 	}
 
-- 
2.39.2

