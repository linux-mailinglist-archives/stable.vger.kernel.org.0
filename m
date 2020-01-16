Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46B3513DC47
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 14:45:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726160AbgAPNpN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 08:45:13 -0500
Received: from mga14.intel.com ([192.55.52.115]:37809 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726151AbgAPNpN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 08:45:13 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Jan 2020 05:45:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,326,1574150400"; 
   d="scan'208";a="425538251"
Received: from mdanino-mobl1.ger.corp.intel.com (HELO localhost.localdomain) ([10.252.23.174])
  by fmsmga006.fm.intel.com with ESMTP; 16 Jan 2020 05:45:11 -0800
From:   Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
To:     Intel-gfx@lists.freedesktop.org
Cc:     Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>, stable@vger.kernel.org
Subject: [PATCH v2] drm/i915: Align engine->uabi_class/instance with i915_drm.h
Date:   Thu, 16 Jan 2020 13:45:08 +0000
Message-Id: <20200116134508.25211-1-tvrtko.ursulin@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200115152437.13207-1-tvrtko.ursulin@linux.intel.com>
References: <20200115152437.13207-1-tvrtko.ursulin@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

In our ABI we have defined I915_ENGINE_CLASS_INVALID_NONE and
I915_ENGINE_CLASS_INVALID_VIRTUAL as negative values which creates
implicit coupling with type widths used in, also ABI, struct
i915_engine_class_instance.

One place where we export engine->uabi_class
I915_ENGINE_CLASS_INVALID_VIRTUAL is from our our tracepoints. Because the
type of the former is u8 in contrast to u16 defined in the ABI, 254 will
be returned instead of 65534 which userspace would legitimately expect.

Another place is I915_CONTEXT_PARAM_ENGINES.

Therefore we need to align the type used to store engine ABI class and
instance.

v2:
 * Update the commit message mentioning get_engines and cc stable.
   (Chris)

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Fixes: 6d06779e8672 ("drm/i915: Load balancing across a virtual engine")
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: <stable@vger.kernel.org> # v5.3+
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
---
 drivers/gpu/drm/i915/gem/i915_gem_busy.c     | 12 ++++++------
 drivers/gpu/drm/i915/gt/intel_engine_types.h |  4 ++--
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_busy.c b/drivers/gpu/drm/i915/gem/i915_gem_busy.c
index 3d4f5775a4ba..25235ef630c1 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_busy.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_busy.c
@@ -9,16 +9,16 @@
 #include "i915_gem_ioctls.h"
 #include "i915_gem_object.h"
 
-static __always_inline u32 __busy_read_flag(u8 id)
+static __always_inline u32 __busy_read_flag(u16 id)
 {
-	if (id == (u8)I915_ENGINE_CLASS_INVALID)
+	if (id == (u16)I915_ENGINE_CLASS_INVALID)
 		return 0xffff0000u;
 
 	GEM_BUG_ON(id >= 16);
 	return 0x10000u << id;
 }
 
-static __always_inline u32 __busy_write_id(u8 id)
+static __always_inline u32 __busy_write_id(u16 id)
 {
 	/*
 	 * The uABI guarantees an active writer is also amongst the read
@@ -29,14 +29,14 @@ static __always_inline u32 __busy_write_id(u8 id)
 	 * last_read - hence we always set both read and write busy for
 	 * last_write.
 	 */
-	if (id == (u8)I915_ENGINE_CLASS_INVALID)
+	if (id == (u16)I915_ENGINE_CLASS_INVALID)
 		return 0xffffffffu;
 
 	return (id + 1) | __busy_read_flag(id);
 }
 
 static __always_inline unsigned int
-__busy_set_if_active(const struct dma_fence *fence, u32 (*flag)(u8 id))
+__busy_set_if_active(const struct dma_fence *fence, u32 (*flag)(u16 id))
 {
 	const struct i915_request *rq;
 
@@ -57,7 +57,7 @@ __busy_set_if_active(const struct dma_fence *fence, u32 (*flag)(u8 id))
 		return 0;
 
 	/* Beware type-expansion follies! */
-	BUILD_BUG_ON(!typecheck(u8, rq->engine->uabi_class));
+	BUILD_BUG_ON(!typecheck(u16, rq->engine->uabi_class));
 	return flag(rq->engine->uabi_class);
 }
 
diff --git a/drivers/gpu/drm/i915/gt/intel_engine_types.h b/drivers/gpu/drm/i915/gt/intel_engine_types.h
index 00287515e7af..350da59e605b 100644
--- a/drivers/gpu/drm/i915/gt/intel_engine_types.h
+++ b/drivers/gpu/drm/i915/gt/intel_engine_types.h
@@ -278,8 +278,8 @@ struct intel_engine_cs {
 	u8 class;
 	u8 instance;
 
-	u8 uabi_class;
-	u8 uabi_instance;
+	u16 uabi_class;
+	u16 uabi_instance;
 
 	u32 uabi_capabilities;
 	u32 context_size;
-- 
2.20.1

