Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D129C11F255
	for <lists+stable@lfdr.de>; Sat, 14 Dec 2019 15:59:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725975AbfLNO7p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Dec 2019 09:59:45 -0500
Received: from mail.fireflyinternet.com ([109.228.58.192]:65461 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725943AbfLNO7p (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Dec 2019 09:59:45 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from haswell.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 19578845-1500050 
        for multiple; Sat, 14 Dec 2019 14:59:37 +0000
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Matthew Auld <matthew.auld@intel.com>, stable@vger.kernel.org
Subject: [PATCH] drm/i915: Hold reference to intel_frontbuffer as we track activity
Date:   Sat, 14 Dec 2019 14:59:32 +0000
Message-Id: <20191214145932.2013492-1-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since obj->frontbuffer is no longer protected by the struct_mutex, as we
are processing the execbuf, it may be removed. Acquire a reference to
the struct as we track activity upon it.

Closes: https://gitlab.freedesktop.org/drm/intel/issues/827
Fixes: 8e7cb1799b4f ("drm/i915: Extract intel_frontbuffer active tracking")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: <stable@vger.kernel.org> # v5.4+
---
 drivers/gpu/drm/i915/display/intel_frontbuffer.c | 13 ++++++++++++-
 drivers/gpu/drm/i915/display/intel_frontbuffer.h | 14 +++++++++++++-
 drivers/gpu/drm/i915/i915_vma.c                  | 10 ++++++++--
 3 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_frontbuffer.c b/drivers/gpu/drm/i915/display/intel_frontbuffer.c
index 84b164f31895..6a8ef6a05133 100644
--- a/drivers/gpu/drm/i915/display/intel_frontbuffer.c
+++ b/drivers/gpu/drm/i915/display/intel_frontbuffer.c
@@ -237,7 +237,7 @@ static void frontbuffer_release(struct kref *ref)
 }
 
 struct intel_frontbuffer *
-intel_frontbuffer_get(struct drm_i915_gem_object *obj)
+____intel_frontbuffer_get(struct drm_i915_gem_object *obj)
 {
 	struct drm_i915_private *i915 = to_i915(obj->base.dev);
 	struct intel_frontbuffer *front;
@@ -247,6 +247,17 @@ intel_frontbuffer_get(struct drm_i915_gem_object *obj)
 	if (front)
 		kref_get(&front->ref);
 	spin_unlock(&i915->fb_tracking.lock);
+
+	return front;
+}
+
+struct intel_frontbuffer *
+intel_frontbuffer_get(struct drm_i915_gem_object *obj)
+{
+	struct drm_i915_private *i915 = to_i915(obj->base.dev);
+	struct intel_frontbuffer *front;
+
+	front = __intel_frontbuffer_get(obj);
 	if (front)
 		return front;
 
diff --git a/drivers/gpu/drm/i915/display/intel_frontbuffer.h b/drivers/gpu/drm/i915/display/intel_frontbuffer.h
index adc64d61a4a5..2b3068b61b80 100644
--- a/drivers/gpu/drm/i915/display/intel_frontbuffer.h
+++ b/drivers/gpu/drm/i915/display/intel_frontbuffer.h
@@ -27,10 +27,10 @@
 #include <linux/atomic.h>
 #include <linux/kref.h>
 
+#include "gem/i915_gem_object_types.h"
 #include "i915_active.h"
 
 struct drm_i915_private;
-struct drm_i915_gem_object;
 
 enum fb_op_origin {
 	ORIGIN_GTT,
@@ -54,6 +54,18 @@ void intel_frontbuffer_flip_complete(struct drm_i915_private *i915,
 void intel_frontbuffer_flip(struct drm_i915_private *i915,
 			    unsigned frontbuffer_bits);
 
+struct intel_frontbuffer *
+____intel_frontbuffer_get(struct drm_i915_gem_object *obj);
+
+static inline struct intel_frontbuffer *
+__intel_frontbuffer_get(struct drm_i915_gem_object *obj)
+{
+	if (!READ_ONCE(obj->frontbuffer))
+		return NULL;
+
+	return ____intel_frontbuffer_get(obj);
+}
+
 struct intel_frontbuffer *
 intel_frontbuffer_get(struct drm_i915_gem_object *obj);
 
diff --git a/drivers/gpu/drm/i915/i915_vma.c b/drivers/gpu/drm/i915/i915_vma.c
index 6794c742fbbf..f8790d08f449 100644
--- a/drivers/gpu/drm/i915/i915_vma.c
+++ b/drivers/gpu/drm/i915/i915_vma.c
@@ -1139,8 +1139,14 @@ int i915_vma_move_to_active(struct i915_vma *vma,
 		return err;
 
 	if (flags & EXEC_OBJECT_WRITE) {
-		if (intel_frontbuffer_invalidate(obj->frontbuffer, ORIGIN_CS))
-			i915_active_add_request(&obj->frontbuffer->write, rq);
+		struct intel_frontbuffer *front;
+
+		front = __intel_frontbuffer_get(obj);
+		if (unlikely(front)) {
+			if (intel_frontbuffer_invalidate(front, ORIGIN_CS))
+				i915_active_add_request(&front->write, rq);
+			intel_frontbuffer_put(front);
+		}
 
 		dma_resv_add_excl_fence(vma->resv, &rq->fence);
 		obj->write_domain = I915_GEM_DOMAIN_RENDER;
-- 
2.24.0

