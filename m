Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9DF45480DB
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 09:51:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234334AbiFMHtc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 03:49:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231434AbiFMHta (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 03:49:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5A89B1DA
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 00:49:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 731B460FA3
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 07:49:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76119C34114;
        Mon, 13 Jun 2022 07:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655106568;
        bh=E5TTjhy+W4gus0wE1+vhcPxps0QQWLH9DhYjWGyb/7E=;
        h=Subject:To:Cc:From:Date:From;
        b=v20Cy+3b6NjExYoD5FYiDBTlBCHrX9XzPDGnlb7rwl2XDrEa12B3Pgi/ds89VQ6FD
         prnlcJqsJEApNO5V5yu+fbbTOT5tETKNjCvm7ok0aELqOu1AVkUjKz4+g9PfnB7yqS
         D5xoqtGXN1el86MlGUOVhRESkjSucdqDaQuu2v9Q=
Subject: FAILED: patch "[PATCH] drm/amdkfd: Fix partial migration bugs" failed to apply to 5.17-stable tree
To:     Philip.Yang@amd.com, Felix.Kuehling@amd.com,
        alexander.deucher@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 13 Jun 2022 09:49:26 +0200
Message-ID: <165510656660244@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.17-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 88467db6e2f46a2e79b1b67ce6873c284e4cf417 Mon Sep 17 00:00:00 2001
From: Philip Yang <Philip.Yang@amd.com>
Date: Fri, 3 Jun 2022 09:19:34 -0400
Subject: [PATCH] drm/amdkfd: Fix partial migration bugs

Migration range from system memory to VRAM, if system page can not be
locked or unmapped, we do partial migration and leave some pages in
system memory. Several bugs found to copy pages and update GPU mapping
for this situation:

1. copy to vram should use migrate->npage which is total pages of range
as npages, not migrate->cpages which is number of pages can be migrated.

2. After partial copy, set VRAM res cursor as j + 1, j is number of
system pages copied plus 1 page to skip copy.

3. copy to ram, should collect all continuous VRAM pages and copy
together.

4. Call amdgpu_vm_update_range, should pass in offset as bytes, not
as number of pages.

Signed-off-by: Philip Yang <Philip.Yang@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
index 997650d597ec..e44376c2ecdc 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
@@ -296,7 +296,7 @@ svm_migrate_copy_to_vram(struct amdgpu_device *adev, struct svm_range *prange,
 			 struct migrate_vma *migrate, struct dma_fence **mfence,
 			 dma_addr_t *scratch)
 {
-	uint64_t npages = migrate->cpages;
+	uint64_t npages = migrate->npages;
 	struct device *dev = adev->dev;
 	struct amdgpu_res_cursor cursor;
 	dma_addr_t *src;
@@ -344,7 +344,7 @@ svm_migrate_copy_to_vram(struct amdgpu_device *adev, struct svm_range *prange,
 						mfence);
 				if (r)
 					goto out_free_vram_pages;
-				amdgpu_res_next(&cursor, j << PAGE_SHIFT);
+				amdgpu_res_next(&cursor, (j + 1) << PAGE_SHIFT);
 				j = 0;
 			} else {
 				amdgpu_res_next(&cursor, PAGE_SIZE);
@@ -590,7 +590,7 @@ svm_migrate_copy_to_ram(struct amdgpu_device *adev, struct svm_range *prange,
 			continue;
 		}
 		src[i] = svm_migrate_addr(adev, spage);
-		if (i > 0 && src[i] != src[i - 1] + PAGE_SIZE) {
+		if (j > 0 && src[i] != src[i - 1] + PAGE_SIZE) {
 			r = svm_migrate_copy_memory_gart(adev, dst + i - j,
 							 src + i - j, j,
 							 FROM_VRAM_TO_RAM,
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
index 3bd0f1a670bb..7b332246eda3 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
@@ -1295,7 +1295,7 @@ svm_range_map_to_gpu(struct kfd_process_device *pdd, struct svm_range *prange,
 		r = amdgpu_vm_update_range(adev, vm, false, false, flush_tlb, NULL,
 					   last_start, prange->start + i,
 					   pte_flags,
-					   last_start - prange->start,
+					   (last_start - prange->start) << PAGE_SHIFT,
 					   bo_adev ? bo_adev->vm_manager.vram_base_offset : 0,
 					   NULL, dma_addr, &vm->last_update);
 

