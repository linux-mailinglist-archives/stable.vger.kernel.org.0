Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5496E579E12
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239877AbiGSM5e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:57:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242238AbiGSM46 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:56:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E69C09B180;
        Tue, 19 Jul 2022 05:22:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4DA2E618CF;
        Tue, 19 Jul 2022 12:22:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07A36C341C6;
        Tue, 19 Jul 2022 12:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233373;
        bh=pNJE5Gf+Habch10E0X/gWeYItMc9ZtlV9143Podc3B0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cEsl9I8ZpCJCm8DLuUKFdYrYMfmNmxrQxN9F5Zoc/Dq2wPhGUQhHMjMVTGo5W4qX+
         8ykOLRT4ICrie4nsbfCmRnfYKC4KjKp0RcOw5g8JuOHs74a5lksGTVNwrNoBxsZQ0K
         KDKbhqrMnAMGrzwIrwTNtLeFzrU66GCE3q8iCNpc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthew Auld <matthew.auld@intel.com>,
        =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= 
        <thomas.hellstrom@linux.intel.com>,
        Nirmoy Das <nirmoy.das@linux.intel.com>,
        Nirmoy Das <nirmoy.das@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 101/231] drm/i915/ttm: fix sg_table construction
Date:   Tue, 19 Jul 2022 13:53:06 +0200
Message-Id: <20220719114723.172321041@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Auld <matthew.auld@intel.com>

[ Upstream commit aff1e0b09b54b64944b7fe32997229552737b9e9 ]

If we encounter some monster sized local-memory page that exceeds the
maximum sg length (UINT32_MAX), ensure that don't end up with some
misaligned address in the entry that follows, leading to fireworks
later. Also ensure we have some coverage of this in the selftests.

v2(Chris):
  - Use round_down consistently to avoid udiv errors
v3(Nirmoy):
  - Also update the max_segment in the selftest

Fixes: f701b16d4cc5 ("drm/i915/ttm: add i915_sg_from_buddy_resource")
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/6379
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Nirmoy Das <nirmoy.das@linux.intel.com>
Reviewed-by: Nirmoy Das <nirmoy.das@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220711085859.24198-1-matthew.auld@intel.com
(cherry picked from commit bc99f1209f19fefa3ee11e77464ccfae541f4291)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gem/i915_gem_ttm.c       | 11 ++++++++--
 drivers/gpu/drm/i915/i915_scatterlist.c       | 19 +++++++++++++----
 drivers/gpu/drm/i915/i915_scatterlist.h       |  6 ++++--
 drivers/gpu/drm/i915/intel_region_ttm.c       | 10 ++++++---
 drivers/gpu/drm/i915/intel_region_ttm.h       |  3 ++-
 .../drm/i915/selftests/intel_memory_region.c  | 21 +++++++++++++++++--
 drivers/gpu/drm/i915/selftests/mock_region.c  |  3 ++-
 7 files changed, 58 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_ttm.c b/drivers/gpu/drm/i915/gem/i915_gem_ttm.c
index 45cc5837ce00..342ca303eae4 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_ttm.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_ttm.c
@@ -583,10 +583,15 @@ i915_ttm_resource_get_st(struct drm_i915_gem_object *obj,
 			 struct ttm_resource *res)
 {
 	struct ttm_buffer_object *bo = i915_gem_to_ttm(obj);
+	u64 page_alignment;
 
 	if (!i915_ttm_gtt_binds_lmem(res))
 		return i915_ttm_tt_get_st(bo->ttm);
 
+	page_alignment = bo->page_alignment << PAGE_SHIFT;
+	if (!page_alignment)
+		page_alignment = obj->mm.region->min_page_size;
+
 	/*
 	 * If CPU mapping differs, we need to add the ttm_tt pages to
 	 * the resulting st. Might make sense for GGTT.
@@ -597,7 +602,8 @@ i915_ttm_resource_get_st(struct drm_i915_gem_object *obj,
 			struct i915_refct_sgt *rsgt;
 
 			rsgt = intel_region_ttm_resource_to_rsgt(obj->mm.region,
-								 res);
+								 res,
+								 page_alignment);
 			if (IS_ERR(rsgt))
 				return rsgt;
 
@@ -606,7 +612,8 @@ i915_ttm_resource_get_st(struct drm_i915_gem_object *obj,
 		return i915_refct_sgt_get(obj->ttm.cached_io_rsgt);
 	}
 
-	return intel_region_ttm_resource_to_rsgt(obj->mm.region, res);
+	return intel_region_ttm_resource_to_rsgt(obj->mm.region, res,
+						 page_alignment);
 }
 
 static int i915_ttm_truncate(struct drm_i915_gem_object *obj)
diff --git a/drivers/gpu/drm/i915/i915_scatterlist.c b/drivers/gpu/drm/i915/i915_scatterlist.c
index 159571b9bd24..f63b50b71e10 100644
--- a/drivers/gpu/drm/i915/i915_scatterlist.c
+++ b/drivers/gpu/drm/i915/i915_scatterlist.c
@@ -68,6 +68,7 @@ void i915_refct_sgt_init(struct i915_refct_sgt *rsgt, size_t size)
  * drm_mm_node
  * @node: The drm_mm_node.
  * @region_start: An offset to add to the dma addresses of the sg list.
+ * @page_alignment: Required page alignment for each sg entry. Power of two.
  *
  * Create a struct sg_table, initializing it from a struct drm_mm_node,
  * taking a maximum segment length into account, splitting into segments
@@ -77,15 +78,18 @@ void i915_refct_sgt_init(struct i915_refct_sgt *rsgt, size_t size)
  * error code cast to an error pointer on failure.
  */
 struct i915_refct_sgt *i915_rsgt_from_mm_node(const struct drm_mm_node *node,
-					      u64 region_start)
+					      u64 region_start,
+					      u64 page_alignment)
 {
-	const u64 max_segment = SZ_1G; /* Do we have a limit on this? */
+	const u64 max_segment = round_down(UINT_MAX, page_alignment);
 	u64 segment_pages = max_segment >> PAGE_SHIFT;
 	u64 block_size, offset, prev_end;
 	struct i915_refct_sgt *rsgt;
 	struct sg_table *st;
 	struct scatterlist *sg;
 
+	GEM_BUG_ON(!max_segment);
+
 	rsgt = kmalloc(sizeof(*rsgt), GFP_KERNEL);
 	if (!rsgt)
 		return ERR_PTR(-ENOMEM);
@@ -112,6 +116,8 @@ struct i915_refct_sgt *i915_rsgt_from_mm_node(const struct drm_mm_node *node,
 				sg = __sg_next(sg);
 
 			sg_dma_address(sg) = region_start + offset;
+			GEM_BUG_ON(!IS_ALIGNED(sg_dma_address(sg),
+					       page_alignment));
 			sg_dma_len(sg) = 0;
 			sg->length = 0;
 			st->nents++;
@@ -138,6 +144,7 @@ struct i915_refct_sgt *i915_rsgt_from_mm_node(const struct drm_mm_node *node,
  * i915_buddy_block list
  * @res: The struct i915_ttm_buddy_resource.
  * @region_start: An offset to add to the dma addresses of the sg list.
+ * @page_alignment: Required page alignment for each sg entry. Power of two.
  *
  * Create a struct sg_table, initializing it from struct i915_buddy_block list,
  * taking a maximum segment length into account, splitting into segments
@@ -147,11 +154,12 @@ struct i915_refct_sgt *i915_rsgt_from_mm_node(const struct drm_mm_node *node,
  * error code cast to an error pointer on failure.
  */
 struct i915_refct_sgt *i915_rsgt_from_buddy_resource(struct ttm_resource *res,
-						     u64 region_start)
+						     u64 region_start,
+						     u64 page_alignment)
 {
 	struct i915_ttm_buddy_resource *bman_res = to_ttm_buddy_resource(res);
 	const u64 size = res->num_pages << PAGE_SHIFT;
-	const u64 max_segment = rounddown(UINT_MAX, PAGE_SIZE);
+	const u64 max_segment = round_down(UINT_MAX, page_alignment);
 	struct drm_buddy *mm = bman_res->mm;
 	struct list_head *blocks = &bman_res->blocks;
 	struct drm_buddy_block *block;
@@ -161,6 +169,7 @@ struct i915_refct_sgt *i915_rsgt_from_buddy_resource(struct ttm_resource *res,
 	resource_size_t prev_end;
 
 	GEM_BUG_ON(list_empty(blocks));
+	GEM_BUG_ON(!max_segment);
 
 	rsgt = kmalloc(sizeof(*rsgt), GFP_KERNEL);
 	if (!rsgt)
@@ -191,6 +200,8 @@ struct i915_refct_sgt *i915_rsgt_from_buddy_resource(struct ttm_resource *res,
 					sg = __sg_next(sg);
 
 				sg_dma_address(sg) = region_start + offset;
+				GEM_BUG_ON(!IS_ALIGNED(sg_dma_address(sg),
+						       page_alignment));
 				sg_dma_len(sg) = 0;
 				sg->length = 0;
 				st->nents++;
diff --git a/drivers/gpu/drm/i915/i915_scatterlist.h b/drivers/gpu/drm/i915/i915_scatterlist.h
index 12c6a1684081..b13e4cdea923 100644
--- a/drivers/gpu/drm/i915/i915_scatterlist.h
+++ b/drivers/gpu/drm/i915/i915_scatterlist.h
@@ -213,9 +213,11 @@ static inline void __i915_refct_sgt_init(struct i915_refct_sgt *rsgt,
 void i915_refct_sgt_init(struct i915_refct_sgt *rsgt, size_t size);
 
 struct i915_refct_sgt *i915_rsgt_from_mm_node(const struct drm_mm_node *node,
-					      u64 region_start);
+					      u64 region_start,
+					      u64 page_alignment);
 
 struct i915_refct_sgt *i915_rsgt_from_buddy_resource(struct ttm_resource *res,
-						     u64 region_start);
+						     u64 region_start,
+						     u64 page_alignment);
 
 #endif
diff --git a/drivers/gpu/drm/i915/intel_region_ttm.c b/drivers/gpu/drm/i915/intel_region_ttm.c
index 737ef3f4ab54..d896558cf458 100644
--- a/drivers/gpu/drm/i915/intel_region_ttm.c
+++ b/drivers/gpu/drm/i915/intel_region_ttm.c
@@ -151,6 +151,7 @@ int intel_region_ttm_fini(struct intel_memory_region *mem)
  * Convert an opaque TTM resource manager resource to a refcounted sg_table.
  * @mem: The memory region.
  * @res: The resource manager resource obtained from the TTM resource manager.
+ * @page_alignment: Required page alignment for each sg entry. Power of two.
  *
  * The gem backends typically use sg-tables for operations on the underlying
  * io_memory. So provide a way for the backends to translate the
@@ -160,16 +161,19 @@ int intel_region_ttm_fini(struct intel_memory_region *mem)
  */
 struct i915_refct_sgt *
 intel_region_ttm_resource_to_rsgt(struct intel_memory_region *mem,
-				  struct ttm_resource *res)
+				  struct ttm_resource *res,
+				  u64 page_alignment)
 {
 	if (mem->is_range_manager) {
 		struct ttm_range_mgr_node *range_node =
 			to_ttm_range_mgr_node(res);
 
 		return i915_rsgt_from_mm_node(&range_node->mm_nodes[0],
-					      mem->region.start);
+					      mem->region.start,
+					      page_alignment);
 	} else {
-		return i915_rsgt_from_buddy_resource(res, mem->region.start);
+		return i915_rsgt_from_buddy_resource(res, mem->region.start,
+						     page_alignment);
 	}
 }
 
diff --git a/drivers/gpu/drm/i915/intel_region_ttm.h b/drivers/gpu/drm/i915/intel_region_ttm.h
index fdee5e7bd46c..b17e494ef79c 100644
--- a/drivers/gpu/drm/i915/intel_region_ttm.h
+++ b/drivers/gpu/drm/i915/intel_region_ttm.h
@@ -24,7 +24,8 @@ int intel_region_ttm_fini(struct intel_memory_region *mem);
 
 struct i915_refct_sgt *
 intel_region_ttm_resource_to_rsgt(struct intel_memory_region *mem,
-				  struct ttm_resource *res);
+				  struct ttm_resource *res,
+				  u64 page_alignment);
 
 void intel_region_ttm_resource_free(struct intel_memory_region *mem,
 				    struct ttm_resource *res);
diff --git a/drivers/gpu/drm/i915/selftests/intel_memory_region.c b/drivers/gpu/drm/i915/selftests/intel_memory_region.c
index ba32893e0873..0250a114fe0a 100644
--- a/drivers/gpu/drm/i915/selftests/intel_memory_region.c
+++ b/drivers/gpu/drm/i915/selftests/intel_memory_region.c
@@ -451,7 +451,6 @@ static int igt_mock_splintered_region(void *arg)
 
 static int igt_mock_max_segment(void *arg)
 {
-	const unsigned int max_segment = rounddown(UINT_MAX, PAGE_SIZE);
 	struct intel_memory_region *mem = arg;
 	struct drm_i915_private *i915 = mem->i915;
 	struct i915_ttm_buddy_resource *res;
@@ -460,7 +459,10 @@ static int igt_mock_max_segment(void *arg)
 	struct drm_buddy *mm;
 	struct list_head *blocks;
 	struct scatterlist *sg;
+	I915_RND_STATE(prng);
 	LIST_HEAD(objects);
+	unsigned int max_segment;
+	unsigned int ps;
 	u64 size;
 	int err = 0;
 
@@ -472,7 +474,13 @@ static int igt_mock_max_segment(void *arg)
 	 */
 
 	size = SZ_8G;
-	mem = mock_region_create(i915, 0, size, PAGE_SIZE, 0, 0);
+	ps = PAGE_SIZE;
+	if (i915_prandom_u64_state(&prng) & 1)
+		ps = SZ_64K; /* For something like DG2 */
+
+	max_segment = round_down(UINT_MAX, ps);
+
+	mem = mock_region_create(i915, 0, size, ps, 0, 0);
 	if (IS_ERR(mem))
 		return PTR_ERR(mem);
 
@@ -498,12 +506,21 @@ static int igt_mock_max_segment(void *arg)
 	}
 
 	for (sg = obj->mm.pages->sgl; sg; sg = sg_next(sg)) {
+		dma_addr_t daddr = sg_dma_address(sg);
+
 		if (sg->length > max_segment) {
 			pr_err("%s: Created an oversized scatterlist entry, %u > %u\n",
 			       __func__, sg->length, max_segment);
 			err = -EINVAL;
 			goto out_close;
 		}
+
+		if (!IS_ALIGNED(daddr, ps)) {
+			pr_err("%s: Created an unaligned scatterlist entry, addr=%pa, ps=%u\n",
+			       __func__,  &daddr, ps);
+			err = -EINVAL;
+			goto out_close;
+		}
 	}
 
 out_close:
diff --git a/drivers/gpu/drm/i915/selftests/mock_region.c b/drivers/gpu/drm/i915/selftests/mock_region.c
index f64325491f35..6f7c9820d3e9 100644
--- a/drivers/gpu/drm/i915/selftests/mock_region.c
+++ b/drivers/gpu/drm/i915/selftests/mock_region.c
@@ -32,7 +32,8 @@ static int mock_region_get_pages(struct drm_i915_gem_object *obj)
 		return PTR_ERR(obj->mm.res);
 
 	obj->mm.rsgt = intel_region_ttm_resource_to_rsgt(obj->mm.region,
-							 obj->mm.res);
+							 obj->mm.res,
+							 obj->mm.region->min_page_size);
 	if (IS_ERR(obj->mm.rsgt)) {
 		err = PTR_ERR(obj->mm.rsgt);
 		goto err_free_resource;
-- 
2.35.1



