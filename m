Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0D961E7823
	for <lists+stable@lfdr.de>; Fri, 29 May 2020 10:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726629AbgE2IUr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 May 2020 04:20:47 -0400
Received: from mga18.intel.com ([134.134.136.126]:10357 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725821AbgE2IUq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 29 May 2020 04:20:46 -0400
IronPort-SDR: oFRBk+DZe0kK/UIP6GVs9UCbSBeNs1+piGw5Bb9/IoqaIa8dNcNJ4uawSNpN2IP9VX7XVD+LGk
 CYThV3ghS84Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2020 01:20:45 -0700
IronPort-SDR: LP9Z8yniGVLvGJeBCZeBItNRkXoOs1dSdIlmFtDSKa7jA5Ml5eEQixaUB21QJVW8DSa1hHVgvh
 W1xhgMErP3bQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,447,1583222400"; 
   d="scan'208";a="376641861"
Received: from vtt.iind.intel.com ([10.145.162.194])
  by fmsmga001.fm.intel.com with ESMTP; 29 May 2020 01:20:43 -0700
From:   Prasad Nallani <prasad.nallani@intel.com>
To:     gfx-internal-devel@eclists.intel.com
Cc:     andi.shyti@intel.com, Chris Wilson <chris@chris-wilson.co.uk>,
        Matthew Auld <matthew.william.auld@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH 13/23] drm/i915/gem: Flush all the reloc_gpu batch
Date:   Fri, 29 May 2020 13:48:00 +0530
Message-Id: <20200529081810.10747-14-prasad.nallani@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200529081810.10747-1-prasad.nallani@intel.com>
References: <20200529081810.10747-1-prasad.nallani@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

__i915_gem_object_flush_map() takes a byte range, so feed it the written
bytes and do not mistake the u32 index as bytes!

Fixes: a679f58d0510 ("drm/i915: Flush pages on acquisition")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Matthew Auld <matthew.william.auld@gmail.com>
Cc: <stable@vger.kernel.org> # v5.2+
Reviewed-by: Matthew Auld <matthew.william.auld@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200406114821.10949-1-chris@chris-wilson.co.uk
(cherry picked from commit 30c88a47f1abd5744908d3681f54dcf823fe2a12)
---
 drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
index 5c1fa7513a53..4de2a6b0b29d 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
@@ -915,11 +915,13 @@ static inline struct i915_ggtt *cache_to_ggtt(struct reloc_cache *cache)
 
 static void reloc_gpu_flush(struct reloc_cache *cache)
 {
-	GEM_BUG_ON(cache->rq_size >= cache->rq->batch->obj->base.size / sizeof(u32));
+	struct drm_i915_gem_object *obj = cache->rq->batch->obj;
+
+	GEM_BUG_ON(cache->rq_size >= obj->base.size / sizeof(u32));
 	cache->rq_cmd[cache->rq_size] = MI_BATCH_BUFFER_END;
 
-	__i915_gem_object_flush_map(cache->rq->batch->obj, 0, cache->rq_size);
-	i915_gem_object_unpin_map(cache->rq->batch->obj);
+	__i915_gem_object_flush_map(obj, 0, sizeof(u32) * (cache->rq_size + 1));
+	i915_gem_object_unpin_map(obj);
 
 	intel_gt_chipset_flush(cache->rq->engine->gt);
 
