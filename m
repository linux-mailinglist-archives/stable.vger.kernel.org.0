Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2127290414
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 13:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394734AbgJPLd7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 07:33:59 -0400
Received: from mail.fireflyinternet.com ([77.68.26.236]:50864 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S2394731AbgJPLd7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Oct 2020 07:33:59 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from build.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 22734485-1500050 
        for multiple; Fri, 16 Oct 2020 12:33:54 +0100
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>, stable@vger.kernel.org
Subject: [PATCH 2/2] drm/i915: Exclude low pages (128KiB) of stolen from use
Date:   Fri, 16 Oct 2020 12:33:50 +0100
Message-Id: <20201016113350.6806-2-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201016113350.6806-1-chris@chris-wilson.co.uk>
References: <20201016113350.6806-1-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The GPU is trashing the low pages of its reserved memory upon reset. If
we are using this memory for ringbuffers, then we will dutiful resubmit
the trashed rings after the reset causing further resets, and worse. We
must exclude this range from our own use. The value of 128KiB was found
by empirical measurement (and verified now with a selftest) on gen9.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/i915/Kconfig.debug         |   1 +
 drivers/gpu/drm/i915/gem/i915_gem_stolen.c |   6 +-
 drivers/gpu/drm/i915/gem/i915_gem_stolen.h |   2 +
 drivers/gpu/drm/i915/gt/selftest_reset.c   | 196 +++++++++++++++++++++
 4 files changed, 203 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/Kconfig.debug b/drivers/gpu/drm/i915/Kconfig.debug
index 206882e154bc..0fb7fd0ef717 100644
--- a/drivers/gpu/drm/i915/Kconfig.debug
+++ b/drivers/gpu/drm/i915/Kconfig.debug
@@ -162,6 +162,7 @@ config DRM_I915_SELFTEST
 	select DRM_EXPORT_FOR_TESTS if m
 	select FAULT_INJECTION
 	select PRIME_NUMBERS
+	select CRC32
 	help
 	  Choose this option to allow the driver to perform selftests upon
 	  loading; also requires the i915.selftest=1 module parameter. To
diff --git a/drivers/gpu/drm/i915/gem/i915_gem_stolen.c b/drivers/gpu/drm/i915/gem/i915_gem_stolen.c
index 3954ec9981f0..4f923b8c43fb 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_stolen.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_stolen.c
@@ -53,8 +53,10 @@ int i915_gem_stolen_insert_node(struct drm_i915_private *i915,
 				struct drm_mm_node *node, u64 size,
 				unsigned alignment)
 {
-	return i915_gem_stolen_insert_node_in_range(i915, node, size,
-						    alignment, 0, U64_MAX);
+	return i915_gem_stolen_insert_node_in_range(i915, node,
+						    size, alignment,
+						    I915_GEM_STOLEN_BIAS,
+						    U64_MAX);
 }
 
 void i915_gem_stolen_remove_node(struct drm_i915_private *i915,
diff --git a/drivers/gpu/drm/i915/gem/i915_gem_stolen.h b/drivers/gpu/drm/i915/gem/i915_gem_stolen.h
index e15c0adad8af..61e028063f9f 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_stolen.h
+++ b/drivers/gpu/drm/i915/gem/i915_gem_stolen.h
@@ -30,4 +30,6 @@ i915_gem_object_create_stolen_for_preallocated(struct drm_i915_private *dev_priv
 					       resource_size_t stolen_offset,
 					       resource_size_t size);
 
+#define I915_GEM_STOLEN_BIAS SZ_128K
+
 #endif /* __I915_GEM_STOLEN_H__ */
diff --git a/drivers/gpu/drm/i915/gt/selftest_reset.c b/drivers/gpu/drm/i915/gt/selftest_reset.c
index 35406ecdf0b2..72dc65401b64 100644
--- a/drivers/gpu/drm/i915/gt/selftest_reset.c
+++ b/drivers/gpu/drm/i915/gt/selftest_reset.c
@@ -3,9 +3,203 @@
  * Copyright © 2018 Intel Corporation
  */
 
+#include <linux/crc32.h>
+
+#include "gem/i915_gem_stolen.h"
+
+#include "i915_memcpy.h"
 #include "i915_selftest.h"
 #include "selftests/igt_reset.h"
 #include "selftests/igt_atomic.h"
+#include "selftests/igt_spinner.h"
+
+static int
+__igt_reset_stolen(struct intel_gt *gt,
+		   intel_engine_mask_t mask,
+		   const char *msg)
+{
+	struct i915_ggtt *ggtt = &gt->i915->ggtt;
+	const struct resource *dsm = &gt->i915->dsm;
+	resource_size_t num_pages, page;
+	struct intel_engine_cs *engine;
+	intel_wakeref_t wakeref;
+	enum intel_engine_id id;
+	struct igt_spinner spin;
+	long max, count;
+	void *tmp;
+	u32 *crc;
+	int err;
+
+	if (!drm_mm_node_allocated(&ggtt->error_capture))
+		return 0;
+
+	num_pages = resource_size(dsm) >> PAGE_SHIFT;
+	if (!num_pages)
+		return 0;
+
+	crc = kmalloc_array(num_pages, sizeof(u32), GFP_KERNEL);
+	if (!crc)
+		return -ENOMEM;
+
+	tmp = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!tmp) {
+		err = -ENOMEM;
+		goto err_crc;
+	}
+
+	igt_global_reset_lock(gt);
+	wakeref = intel_runtime_pm_get(gt->uncore->rpm);
+
+	err = igt_spinner_init(&spin, gt);
+	if (err)
+		goto err_lock;
+
+	for_each_engine(engine, gt, id) {
+		struct intel_context *ce;
+		struct i915_request *rq;
+
+		if (!(mask & engine->mask))
+			continue;
+
+		if (!intel_engine_can_store_dword(engine))
+			continue;
+
+		ce = intel_context_create(engine);
+		if (IS_ERR(ce)) {
+			err = PTR_ERR(ce);
+			goto err_spin;
+		}
+		rq = igt_spinner_create_request(&spin, ce, 0xc3c3c3c3);
+		intel_context_put(ce);
+		if (IS_ERR(rq)) {
+			err = PTR_ERR(rq);
+			goto err_spin;
+		}
+		i915_request_add(rq);
+	}
+
+	for (page = 0; page < num_pages; page++) {
+		dma_addr_t dma = (dma_addr_t)dsm->start + (page << PAGE_SHIFT);
+		void __iomem *s;
+		void *in;
+
+		ggtt->vm.insert_page(&ggtt->vm, dma,
+				     ggtt->error_capture.start,
+				     I915_CACHE_NONE, 0);
+		mb();
+
+		s = io_mapping_map_wc(&ggtt->iomap,
+				      ggtt->error_capture.start,
+				      PAGE_SIZE);
+
+		if (!__drm_mm_interval_first(&gt->i915->mm.stolen,
+					     page << PAGE_SHIFT,
+					     ((page + 1) << PAGE_SHIFT) - 1))
+			memset32(s, STACK_MAGIC, PAGE_SIZE / sizeof(u32));
+
+		in = s;
+		if (i915_memcpy_from_wc(tmp, s, PAGE_SIZE))
+			in = tmp;
+		crc[page] = crc32_le(0, in, PAGE_SIZE);
+
+		io_mapping_unmap(s);
+	}
+	mb();
+	ggtt->vm.clear_range(&ggtt->vm, ggtt->error_capture.start, PAGE_SIZE);
+
+	if (mask == ALL_ENGINES) {
+		intel_gt_reset(gt, mask, NULL);
+	} else {
+		for_each_engine(engine, gt, id) {
+			if (mask & engine->mask)
+				intel_engine_reset(engine, NULL);
+		}
+	}
+
+	max = -1;
+	count = 0;
+	for (page = 0; page < num_pages; page++) {
+		dma_addr_t dma = (dma_addr_t)dsm->start + (page << PAGE_SHIFT);
+		void __iomem *s;
+		void *in;
+		u32 x;
+
+		ggtt->vm.insert_page(&ggtt->vm, dma,
+				     ggtt->error_capture.start,
+				     I915_CACHE_NONE, 0);
+		mb();
+
+		s = io_mapping_map_wc(&ggtt->iomap,
+				      ggtt->error_capture.start,
+				      PAGE_SIZE);
+
+		in = s;
+		if (i915_memcpy_from_wc(tmp, s, PAGE_SIZE))
+			in = tmp;
+		x = crc32_le(0, in, PAGE_SIZE);
+
+		if (x != crc[page] &&
+		    !__drm_mm_interval_first(&gt->i915->mm.stolen,
+					     page << PAGE_SHIFT,
+					     ((page + 1) << PAGE_SHIFT) - 1)) {
+			pr_debug("unused stolen page %pa modified by GPU reset\n",
+				 &page);
+			if (count++ == 0)
+				igt_hexdump(in, PAGE_SIZE);
+			max = page;
+		}
+
+		io_mapping_unmap(s);
+	}
+	mb();
+	ggtt->vm.clear_range(&ggtt->vm, ggtt->error_capture.start, PAGE_SIZE);
+
+	if (count > 0) {
+		pr_info("%s reset clobbered %ld pages of stolen, last clobber at page %ld\n",
+			msg, count, max);
+	}
+	if (max >= I915_GEM_STOLEN_BIAS >> PAGE_SHIFT) {
+		pr_err("%s reset clobbered unreserved area [above %x] of stolen; may cause severe faults\n",
+		       msg, I915_GEM_STOLEN_BIAS);
+		err = -EINVAL;
+	}
+
+err_spin:
+	igt_spinner_fini(&spin);
+
+err_lock:
+	intel_runtime_pm_put(gt->uncore->rpm, wakeref);
+	igt_global_reset_unlock(gt);
+
+	kfree(tmp);
+err_crc:
+	kfree(crc);
+	return err;
+}
+
+static int igt_reset_device_stolen(void *arg)
+{
+	return __igt_reset_stolen(arg, ALL_ENGINES, "device");
+}
+
+static int igt_reset_engines_stolen(void *arg)
+{
+	struct intel_gt *gt = arg;
+	struct intel_engine_cs *engine;
+	enum intel_engine_id id;
+	int err;
+
+	if (!intel_has_reset_engine(gt))
+		return 0;
+
+	for_each_engine(engine, gt, id) {
+		err = __igt_reset_stolen(gt, engine->mask, engine->name);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
 
 static int igt_global_reset(void *arg)
 {
@@ -164,6 +358,8 @@ int intel_reset_live_selftests(struct drm_i915_private *i915)
 {
 	static const struct i915_subtest tests[] = {
 		SUBTEST(igt_global_reset), /* attempt to recover GPU first */
+		SUBTEST(igt_reset_device_stolen),
+		SUBTEST(igt_reset_engines_stolen),
 		SUBTEST(igt_wedged_reset),
 		SUBTEST(igt_atomic_reset),
 		SUBTEST(igt_atomic_engine_reset),
-- 
2.20.1

