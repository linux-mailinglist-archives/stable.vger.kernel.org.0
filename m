Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 241AC64A5B3
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 18:20:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbiLLRUY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 12:20:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbiLLRUX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 12:20:23 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EFDB60F1
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 09:20:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670865622; x=1702401622;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FRCFXAK0CgbAO508wGIZu3cJUyCR6Tpr4/izHzEaTxU=;
  b=JglQElwWsGNFjG8fW7G4UzE0kPrZusZ6nUrS5Mh6MhbwKAY9idBtW+F7
   vZSZO5xmDAv9iTY1M0m+NAOEUjyQvNUKZop1ONzke3wPHo9C7r9Ag+UAs
   ex/2Cx8YPK/qaq2WF+XLe59hXgGsVdCTpDlN8EAYqasqOlX4iyBQztXN3
   M3Uv2cfYm9RK+MUITYdpzuAWq9m51WxCQDtgQ4Dod6j4wzGslnuljJ8TJ
   BWaZ0sAH1pxJqiXRTr6PHpVtRfAFCohK1U8AF1ZYMrwsRnnSCWqq4Q6OM
   onxhvVxw/7trCeNB2D89mP5cqshbfmqBMARKD1K+r8Ei93cnMSqVtvyRF
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10559"; a="319769734"
X-IronPort-AV: E=Sophos;i="5.96,239,1665471600"; 
   d="scan'208";a="319769734"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2022 09:20:22 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10559"; a="650411408"
X-IronPort-AV: E=Sophos;i="5.96,239,1665471600"; 
   d="scan'208";a="650411408"
Received: from jzywicka-mobl.ger.corp.intel.com (HELO mwauld-desk1.intel.com) ([10.252.5.179])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2022 09:20:20 -0800
From:   Matthew Auld <matthew.auld@intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, Nirmoy Das <nirmoy.das@intel.com>,
        Andrzej Hajda <andrzej.hajda@intel.com>,
        Shuicheng Lin <shuicheng.lin@intel.com>, stable@vger.kernel.org
Subject: [PATCH 2/2] drm/i915/ttm: consider CCS for backup objects
Date:   Mon, 12 Dec 2022 17:19:58 +0000
Message-Id: <20221212171958.82593-2-matthew.auld@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212171958.82593-1-matthew.auld@intel.com>
References: <20221212171958.82593-1-matthew.auld@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/gpu/drm/i915/gem/i915_gem_object.c     |  3 +++
 .../gpu/drm/i915/gem/i915_gem_object_types.h   | 10 ++++++----
 drivers/gpu/drm/i915/gem/i915_gem_ttm_pm.c     | 18 +++++++++++++++++-
 3 files changed, 26 insertions(+), 5 deletions(-)

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
index a7b70701617a..19c9bdd8f905 100644
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
 
-- 
2.38.1

