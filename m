Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAFED6D081
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 16:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727708AbfGROyQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 10:54:16 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:50276 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726513AbfGROyP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jul 2019 10:54:15 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from haswell.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 17402283-1500050 
        for multiple; Thu, 18 Jul 2019 15:54:10 +0100
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH 4/4] drm/i915: Flush stale cachelines on set-cache-level
Date:   Thu, 18 Jul 2019 15:54:07 +0100
Message-Id: <20190718145407.21352-4-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190718145407.21352-1-chris@chris-wilson.co.uk>
References: <20190718145407.21352-1-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Ensure that we flush any cache dirt out to main memory before the user
changes the cache-level as they may elect to bypass the cache (even after
declaring their access cache-coherent) via use of unprivileged MOCS.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/i915/gem/i915_gem_domain.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_domain.c b/drivers/gpu/drm/i915/gem/i915_gem_domain.c
index 2e3ce2a69653..5d41e769a428 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_domain.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_domain.c
@@ -277,6 +277,11 @@ int i915_gem_object_set_cache_level(struct drm_i915_gem_object *obj,
 
 	list_for_each_entry(vma, &obj->vma.list, obj_link)
 		vma->node.color = cache_level;
+
+	/* Flush any previous cache dirt in case of cache bypass */
+	if (obj->cache_dirty & ~obj->cache_coherent)
+		i915_gem_clflush_object(obj, I915_CLFLUSH_SYNC);
+
 	i915_gem_object_set_cache_coherency(obj, cache_level);
 	obj->cache_dirty = true; /* Always invalidate stale cachelines */
 
-- 
2.22.0

