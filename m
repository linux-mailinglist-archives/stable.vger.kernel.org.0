Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BC936B3E0B
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 12:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbjCJLhe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 06:37:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbjCJLhd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 06:37:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C895875A41
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 03:37:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 631396130C
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 11:37:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60C5DC433EF;
        Fri, 10 Mar 2023 11:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678448250;
        bh=oDunM1xV5NIvtSeZrTA/C9TENlXKa7AEE7f44g2YFUI=;
        h=Subject:To:Cc:From:Date:From;
        b=Vqo19NfXxNtN2i5tvNXy1EKEQZClfRVN6jCUiu2xT6YOkKTvkIJXnBAsZoEHV5EjO
         qB7bxo5Gi87xOhTQ/tJ6vpl7duPXtxQsIcCYYEg6cMm4h9298oM2AXK0HjTWGBc9Am
         lapq3RpBi5ZY8EXxqNbYx02xBN2PtVeu6anWI5Fo=
Subject: FAILED: patch "[PATCH] drm/i915/ttm: consider CCS for backup objects" failed to apply to 6.2-stable tree
To:     matthew.auld@intel.com, andrzej.hajda@intel.com,
        nirmoy.das@intel.com, shuicheng.lin@intel.com,
        stable@vger.kernel.org, ville.syrjala@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 10 Mar 2023 12:37:19 +0100
Message-ID: <16784482396376@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.2-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-6.2.y
git checkout FETCH_HEAD
git cherry-pick -x 95df9cc24bee8a09d39c62bcef4319b984814e18
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '16784482396376@kroah.com' --subject-prefix 'PATCH 6.2.y' HEAD^..

Possible dependencies:

95df9cc24bee ("drm/i915/ttm: consider CCS for backup objects")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 95df9cc24bee8a09d39c62bcef4319b984814e18 Mon Sep 17 00:00:00 2001
From: Matthew Auld <matthew.auld@intel.com>
Date: Mon, 12 Dec 2022 17:19:58 +0000
Subject: [PATCH] drm/i915/ttm: consider CCS for backup objects
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

It seems we can have one or more framebuffers that are still pinned when
suspending lmem, in such a case we end up creating a shmem backup
object, instead of evicting the object directly, but this will skip
copying the CCS aux state, since we don't allocate the extra storage for
the CCS pages as part of the ttm_tt construction. Since we can already
deal with pinned objects just fine, it doesn't seem too nasty to just
extend to support dealing with the CCS aux state, if the object is a
pinned framebuffer. This fixes display corruption (like in gnome-shell)
seen on DG2 when returning from suspend.

Fixes: da0595ae91da ("drm/i915/migrate: Evict and restore the flatccs capable lmem obj")
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Nirmoy Das <nirmoy.das@intel.com>
Cc: Andrzej Hajda <andrzej.hajda@intel.com>
Cc: Shuicheng Lin <shuicheng.lin@intel.com>
Cc: <stable@vger.kernel.org> # v5.19+
Tested-by: Nirmoy Das <nirmoy.das@intel.com>
Reviewed-by: Nirmoy Das <nirmoy.das@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221212171958.82593-2-matthew.auld@intel.com

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_object.c b/drivers/gpu/drm/i915/gem/i915_gem_object.c
index 733696057761..1a0886b8aaa1 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_object.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_object.c
@@ -785,6 +785,9 @@ bool i915_gem_object_needs_ccs_pages(struct drm_i915_gem_object *obj)
 	if (!HAS_FLAT_CCS(to_i915(obj->base.dev)))
 		return false;
 
+	if (obj->flags & I915_BO_ALLOC_CCS_AUX)
+		return true;
+
 	for (i = 0; i < obj->mm.n_placements; i++) {
 		/* Compression is not allowed for the objects with smem placement */
 		if (obj->mm.placements[i]->type == INTEL_MEMORY_SYSTEM)
diff --git a/drivers/gpu/drm/i915/gem/i915_gem_object_types.h b/drivers/gpu/drm/i915/gem/i915_gem_object_types.h
index d0d6772e6f36..ab4c2f90a564 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_object_types.h
+++ b/drivers/gpu/drm/i915/gem/i915_gem_object_types.h
@@ -327,16 +327,18 @@ struct drm_i915_gem_object {
  * dealing with userspace objects the CPU fault handler is free to ignore this.
  */
 #define I915_BO_ALLOC_GPU_ONLY	  BIT(6)
+#define I915_BO_ALLOC_CCS_AUX	  BIT(7)
 #define I915_BO_ALLOC_FLAGS (I915_BO_ALLOC_CONTIGUOUS | \
 			     I915_BO_ALLOC_VOLATILE | \
 			     I915_BO_ALLOC_CPU_CLEAR | \
 			     I915_BO_ALLOC_USER | \
 			     I915_BO_ALLOC_PM_VOLATILE | \
 			     I915_BO_ALLOC_PM_EARLY | \
-			     I915_BO_ALLOC_GPU_ONLY)
-#define I915_BO_READONLY          BIT(7)
-#define I915_TILING_QUIRK_BIT     8 /* unknown swizzling; do not release! */
-#define I915_BO_PROTECTED         BIT(9)
+			     I915_BO_ALLOC_GPU_ONLY | \
+			     I915_BO_ALLOC_CCS_AUX)
+#define I915_BO_READONLY          BIT(8)
+#define I915_TILING_QUIRK_BIT     9 /* unknown swizzling; do not release! */
+#define I915_BO_PROTECTED         BIT(10)
 	/**
 	 * @mem_flags - Mutable placement-related flags
 	 *
diff --git a/drivers/gpu/drm/i915/gem/i915_gem_ttm_pm.c b/drivers/gpu/drm/i915/gem/i915_gem_ttm_pm.c
index 07e49f22f2de..7e67742bc65e 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_ttm_pm.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_ttm_pm.c
@@ -50,6 +50,7 @@ static int i915_ttm_backup(struct i915_gem_apply_to_region *apply,
 		container_of(bo->bdev, typeof(*i915), bdev);
 	struct drm_i915_gem_object *backup;
 	struct ttm_operation_ctx ctx = {};
+	unsigned int flags;
 	int err = 0;
 
 	if (bo->resource->mem_type == I915_PL_SYSTEM || obj->ttm.backup)
@@ -65,7 +66,22 @@ static int i915_ttm_backup(struct i915_gem_apply_to_region *apply,
 	if (obj->flags & I915_BO_ALLOC_PM_VOLATILE)
 		return 0;
 
-	backup = i915_gem_object_create_shmem(i915, obj->base.size);
+	/*
+	 * It seems that we might have some framebuffers still pinned at this
+	 * stage, but for such objects we might also need to deal with the CCS
+	 * aux state. Make sure we force the save/restore of the CCS state,
+	 * otherwise we might observe display corruption, when returning from
+	 * suspend.
+	 */
+	flags = 0;
+	if (i915_gem_object_needs_ccs_pages(obj)) {
+		WARN_ON_ONCE(!i915_gem_object_is_framebuffer(obj));
+		WARN_ON_ONCE(!pm_apply->allow_gpu);
+
+		flags = I915_BO_ALLOC_CCS_AUX;
+	}
+	backup = i915_gem_object_create_region(i915->mm.regions[INTEL_REGION_SMEM],
+					       obj->base.size, 0, flags);
 	if (IS_ERR(backup))
 		return PTR_ERR(backup);
 

