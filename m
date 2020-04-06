Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CDCF19F515
	for <lists+stable@lfdr.de>; Mon,  6 Apr 2020 13:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727356AbgDFLs2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Apr 2020 07:48:28 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:63692 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727376AbgDFLs2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Apr 2020 07:48:28 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from build.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 20815140-1500050 
        for multiple; Mon, 06 Apr 2020 12:48:20 +0100
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Matthew Auld <matthew.william.auld@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH] drm/i915/gem: Flush all the reloc_gpu batch
Date:   Mon,  6 Apr 2020 12:48:21 +0100
Message-Id: <20200406114821.10949-1-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

__i915_gem_object_flush_map() takes a byte range, so feed it the written
bytes and do not mistake the u32 index as bytes!

Fixes: a679f58d0510 ("drm/i915: Flush pages on acquisition")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Matthew Auld <matthew.william.auld@gmail.com>
Cc: <stable@vger.kernel.org> # v5.2+
---
 drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
index 9d11bad74e9a..496cb1880e23 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
@@ -977,11 +977,13 @@ static inline struct i915_ggtt *cache_to_ggtt(struct reloc_cache *cache)
 
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
 
-- 
2.20.1

