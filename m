Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F413D65D5E9
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 15:37:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbjADOhq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 09:37:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239354AbjADOhh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 09:37:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79AC5B842
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 06:37:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 086F36141B
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 14:37:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1104AC433F0;
        Wed,  4 Jan 2023 14:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672843055;
        bh=IeZzoyBsQuFRDD+pDBIwiO/frWLfWAPAUbRBJxjxy6o=;
        h=Subject:To:Cc:From:Date:From;
        b=AWFonSob10Ni3SFzD/n2s9EN8hpD2SdOgHD2+PrCaiur9a8TiR8Hrb4lM2ehSmFu/
         z7OGLhDuH40Nz9LbbGTVBAGKOdFDcDhtmzI5NKyZQ+U0XLhgWnoknBtaceHtV4Nzjx
         tIma7ffr/BpZ6dGUijeozQ4hc8YDykIUqIZmg9yc=
Subject: FAILED: patch "[PATCH] drm/amdgpu: fix userptr HMM range handling v2" failed to apply to 6.0-stable tree
To:     christian.koenig@amd.com, Felix.Kuehling@amd.com,
        alexander.deucher@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 15:37:27 +0100
Message-ID: <167284304794190@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.0-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

fec8fdb54e8f ("drm/amdgpu: fix userptr HMM range handling v2")
4953b6b22ab9 ("drm/amdgpu: cleanup error handling in amdgpu_cs_parser_bos")
736ec9fadd7a ("drm/amdgpu: move setting the job resources")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From fec8fdb54e8f74d88951c9f998f47bf4f2031fe0 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Date: Thu, 10 Nov 2022 12:31:41 +0100
Subject: [PATCH] drm/amdgpu: fix userptr HMM range handling v2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The basic problem here is that it's not allowed to page fault while
holding the reservation lock.

So it can happen that multiple processes try to validate an userptr
at the same time.

Work around that by putting the HMM range object into the mutex
protected bo list for now.

v2: make sure range is set to NULL in case of an error

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
CC: stable@vger.kernel.org
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
index 68741b157153..e44d740022bc 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -938,6 +938,7 @@ static int init_user_pages(struct kgd_mem *mem, uint64_t user_addr,
 	struct amdkfd_process_info *process_info = mem->process_info;
 	struct amdgpu_bo *bo = mem->bo;
 	struct ttm_operation_ctx ctx = { true, false };
+	struct hmm_range *range;
 	int ret = 0;
 
 	mutex_lock(&process_info->lock);
@@ -967,7 +968,7 @@ static int init_user_pages(struct kgd_mem *mem, uint64_t user_addr,
 		return 0;
 	}
 
-	ret = amdgpu_ttm_tt_get_user_pages(bo, bo->tbo.ttm->pages);
+	ret = amdgpu_ttm_tt_get_user_pages(bo, bo->tbo.ttm->pages, &range);
 	if (ret) {
 		pr_err("%s: Failed to get user pages: %d\n", __func__, ret);
 		goto unregister_out;
@@ -985,7 +986,7 @@ static int init_user_pages(struct kgd_mem *mem, uint64_t user_addr,
 	amdgpu_bo_unreserve(bo);
 
 release_out:
-	amdgpu_ttm_tt_get_user_pages_done(bo->tbo.ttm);
+	amdgpu_ttm_tt_get_user_pages_done(bo->tbo.ttm, range);
 unregister_out:
 	if (ret)
 		amdgpu_mn_unregister(bo);
@@ -2317,6 +2318,8 @@ static int update_invalid_user_pages(struct amdkfd_process_info *process_info,
 	/* Go through userptr_inval_list and update any invalid user_pages */
 	list_for_each_entry(mem, &process_info->userptr_inval_list,
 			    validate_list.head) {
+		struct hmm_range *range;
+
 		invalid = atomic_read(&mem->invalid);
 		if (!invalid)
 			/* BO hasn't been invalidated since the last
@@ -2327,7 +2330,8 @@ static int update_invalid_user_pages(struct amdkfd_process_info *process_info,
 		bo = mem->bo;
 
 		/* Get updated user pages */
-		ret = amdgpu_ttm_tt_get_user_pages(bo, bo->tbo.ttm->pages);
+		ret = amdgpu_ttm_tt_get_user_pages(bo, bo->tbo.ttm->pages,
+						   &range);
 		if (ret) {
 			pr_debug("Failed %d to get user pages\n", ret);
 
@@ -2346,7 +2350,7 @@ static int update_invalid_user_pages(struct amdkfd_process_info *process_info,
 			 * FIXME: Cannot ignore the return code, must hold
 			 * notifier_lock
 			 */
-			amdgpu_ttm_tt_get_user_pages_done(bo->tbo.ttm);
+			amdgpu_ttm_tt_get_user_pages_done(bo->tbo.ttm, range);
 		}
 
 		/* Mark the BO as valid unless it was invalidated
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c
index 2168163aad2d..252a876b0725 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c
@@ -209,6 +209,7 @@ void amdgpu_bo_list_get_list(struct amdgpu_bo_list *list,
 			list_add_tail(&e->tv.head, &bucket[priority]);
 
 		e->user_pages = NULL;
+		e->range = NULL;
 	}
 
 	/* Connect the sorted buckets in the output list. */
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.h
index 9caea1688fc3..e4d78491bcc7 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.h
@@ -26,6 +26,8 @@
 #include <drm/ttm/ttm_execbuf_util.h>
 #include <drm/amdgpu_drm.h>
 
+struct hmm_range;
+
 struct amdgpu_device;
 struct amdgpu_bo;
 struct amdgpu_bo_va;
@@ -36,6 +38,7 @@ struct amdgpu_bo_list_entry {
 	struct amdgpu_bo_va		*bo_va;
 	uint32_t			priority;
 	struct page			**user_pages;
+	struct hmm_range		*range;
 	bool				user_invalidated;
 };
 
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
index 255d545e5524..275da612cd87 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -912,7 +912,7 @@ static int amdgpu_cs_parser_bos(struct amdgpu_cs_parser *p,
 			goto out_free_user_pages;
 		}
 
-		r = amdgpu_ttm_tt_get_user_pages(bo, e->user_pages);
+		r = amdgpu_ttm_tt_get_user_pages(bo, e->user_pages, &e->range);
 		if (r) {
 			kvfree(e->user_pages);
 			e->user_pages = NULL;
@@ -990,9 +990,10 @@ static int amdgpu_cs_parser_bos(struct amdgpu_cs_parser *p,
 
 		if (!e->user_pages)
 			continue;
-		amdgpu_ttm_tt_get_user_pages_done(bo->tbo.ttm);
+		amdgpu_ttm_tt_get_user_pages_done(bo->tbo.ttm, e->range);
 		kvfree(e->user_pages);
 		e->user_pages = NULL;
+		e->range = NULL;
 	}
 	mutex_unlock(&p->bo_list->bo_list_mutex);
 	return r;
@@ -1267,7 +1268,8 @@ static int amdgpu_cs_submit(struct amdgpu_cs_parser *p,
 	amdgpu_bo_list_for_each_userptr_entry(e, p->bo_list) {
 		struct amdgpu_bo *bo = ttm_to_amdgpu_bo(e->tv.bo);
 
-		r |= !amdgpu_ttm_tt_get_user_pages_done(bo->tbo.ttm);
+		r |= !amdgpu_ttm_tt_get_user_pages_done(bo->tbo.ttm, e->range);
+		e->range = NULL;
 	}
 	if (r) {
 		r = -EAGAIN;
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
index 111484ceb47d..91571b1324f2 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
@@ -378,6 +378,7 @@ int amdgpu_gem_userptr_ioctl(struct drm_device *dev, void *data,
 	struct amdgpu_device *adev = drm_to_adev(dev);
 	struct drm_amdgpu_gem_userptr *args = data;
 	struct drm_gem_object *gobj;
+	struct hmm_range *range;
 	struct amdgpu_bo *bo;
 	uint32_t handle;
 	int r;
@@ -418,7 +419,8 @@ int amdgpu_gem_userptr_ioctl(struct drm_device *dev, void *data,
 		goto release_object;
 
 	if (args->flags & AMDGPU_GEM_USERPTR_VALIDATE) {
-		r = amdgpu_ttm_tt_get_user_pages(bo, bo->tbo.ttm->pages);
+		r = amdgpu_ttm_tt_get_user_pages(bo, bo->tbo.ttm->pages,
+						 &range);
 		if (r)
 			goto release_object;
 
@@ -441,7 +443,7 @@ int amdgpu_gem_userptr_ioctl(struct drm_device *dev, void *data,
 
 user_pages_done:
 	if (args->flags & AMDGPU_GEM_USERPTR_VALIDATE)
-		amdgpu_ttm_tt_get_user_pages_done(bo->tbo.ttm);
+		amdgpu_ttm_tt_get_user_pages_done(bo->tbo.ttm, range);
 
 release_object:
 	drm_gem_object_put(gobj);
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
index 02a8f25ae134..965808f4f682 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -643,9 +643,6 @@ struct amdgpu_ttm_tt {
 	struct task_struct	*usertask;
 	uint32_t		userflags;
 	bool			bound;
-#if IS_ENABLED(CONFIG_DRM_AMDGPU_USERPTR)
-	struct hmm_range	*range;
-#endif
 };
 
 #define ttm_to_amdgpu_ttm_tt(ptr)	container_of(ptr, struct amdgpu_ttm_tt, ttm)
@@ -658,7 +655,8 @@ struct amdgpu_ttm_tt {
  * Calling function must call amdgpu_ttm_tt_userptr_range_done() once and only
  * once afterwards to stop HMM tracking
  */
-int amdgpu_ttm_tt_get_user_pages(struct amdgpu_bo *bo, struct page **pages)
+int amdgpu_ttm_tt_get_user_pages(struct amdgpu_bo *bo, struct page **pages,
+				 struct hmm_range **range)
 {
 	struct ttm_tt *ttm = bo->tbo.ttm;
 	struct amdgpu_ttm_tt *gtt = ttm_to_amdgpu_ttm_tt(ttm);
@@ -668,16 +666,15 @@ int amdgpu_ttm_tt_get_user_pages(struct amdgpu_bo *bo, struct page **pages)
 	bool readonly;
 	int r = 0;
 
+	/* Make sure get_user_pages_done() can cleanup gracefully */
+	*range = NULL;
+
 	mm = bo->notifier.mm;
 	if (unlikely(!mm)) {
 		DRM_DEBUG_DRIVER("BO is not registered?\n");
 		return -EFAULT;
 	}
 
-	/* Another get_user_pages is running at the same time?? */
-	if (WARN_ON(gtt->range))
-		return -EFAULT;
-
 	if (!mmget_not_zero(mm)) /* Happens during process shutdown */
 		return -ESRCH;
 
@@ -695,7 +692,7 @@ int amdgpu_ttm_tt_get_user_pages(struct amdgpu_bo *bo, struct page **pages)
 
 	readonly = amdgpu_ttm_tt_is_readonly(ttm);
 	r = amdgpu_hmm_range_get_pages(&bo->notifier, mm, pages, start,
-				       ttm->num_pages, &gtt->range, readonly,
+				       ttm->num_pages, range, readonly,
 				       true, NULL);
 out_unlock:
 	mmap_read_unlock(mm);
@@ -713,30 +710,24 @@ int amdgpu_ttm_tt_get_user_pages(struct amdgpu_bo *bo, struct page **pages)
  *
  * Returns: true if pages are still valid
  */
-bool amdgpu_ttm_tt_get_user_pages_done(struct ttm_tt *ttm)
+bool amdgpu_ttm_tt_get_user_pages_done(struct ttm_tt *ttm,
+				       struct hmm_range *range)
 {
 	struct amdgpu_ttm_tt *gtt = ttm_to_amdgpu_ttm_tt(ttm);
-	bool r = false;
 
-	if (!gtt || !gtt->userptr)
+	if (!gtt || !gtt->userptr || !range)
 		return false;
 
 	DRM_DEBUG_DRIVER("user_pages_done 0x%llx pages 0x%x\n",
 		gtt->userptr, ttm->num_pages);
 
-	WARN_ONCE(!gtt->range || !gtt->range->hmm_pfns,
-		"No user pages to check\n");
+	WARN_ONCE(!range->hmm_pfns, "No user pages to check\n");
 
-	if (gtt->range) {
-		/*
-		 * FIXME: Must always hold notifier_lock for this, and must
-		 * not ignore the return code.
-		 */
-		r = amdgpu_hmm_range_get_pages_done(gtt->range);
-		gtt->range = NULL;
-	}
-
-	return !r;
+	/*
+	 * FIXME: Must always hold notifier_lock for this, and must
+	 * not ignore the return code.
+	 */
+	return !amdgpu_hmm_range_get_pages_done(range);
 }
 #endif
 
@@ -813,20 +804,6 @@ static void amdgpu_ttm_tt_unpin_userptr(struct ttm_device *bdev,
 	/* unmap the pages mapped to the device */
 	dma_unmap_sgtable(adev->dev, ttm->sg, direction, 0);
 	sg_free_table(ttm->sg);
-
-#if IS_ENABLED(CONFIG_DRM_AMDGPU_USERPTR)
-	if (gtt->range) {
-		unsigned long i;
-
-		for (i = 0; i < ttm->num_pages; i++) {
-			if (ttm->pages[i] !=
-			    hmm_pfn_to_page(gtt->range->hmm_pfns[i]))
-				break;
-		}
-
-		WARN((i == ttm->num_pages), "Missing get_user_page_done\n");
-	}
-#endif
 }
 
 static void amdgpu_ttm_gart_bind(struct amdgpu_device *adev,
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.h
index 7c38843f411e..b391c8d076ff 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.h
@@ -39,6 +39,8 @@
 
 #define AMDGPU_POISON	0xd0bed0be
 
+struct hmm_range;
+
 struct amdgpu_gtt_mgr {
 	struct ttm_resource_manager manager;
 	struct drm_mm mm;
@@ -154,15 +156,19 @@ void amdgpu_ttm_recover_gart(struct ttm_buffer_object *tbo);
 uint64_t amdgpu_ttm_domain_start(struct amdgpu_device *adev, uint32_t type);
 
 #if IS_ENABLED(CONFIG_DRM_AMDGPU_USERPTR)
-int amdgpu_ttm_tt_get_user_pages(struct amdgpu_bo *bo, struct page **pages);
-bool amdgpu_ttm_tt_get_user_pages_done(struct ttm_tt *ttm);
+int amdgpu_ttm_tt_get_user_pages(struct amdgpu_bo *bo, struct page **pages,
+				 struct hmm_range **range);
+bool amdgpu_ttm_tt_get_user_pages_done(struct ttm_tt *ttm,
+				       struct hmm_range *range);
 #else
 static inline int amdgpu_ttm_tt_get_user_pages(struct amdgpu_bo *bo,
-					       struct page **pages)
+					       struct page **pages,
+					       struct hmm_range **range)
 {
 	return -EPERM;
 }
-static inline bool amdgpu_ttm_tt_get_user_pages_done(struct ttm_tt *ttm)
+static inline bool amdgpu_ttm_tt_get_user_pages_done(struct ttm_tt *ttm,
+						     struct hmm_range *range)
 {
 	return false;
 }

