Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E95829549E
	for <lists+stable@lfdr.de>; Thu, 22 Oct 2020 00:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440934AbgJUWES (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Oct 2020 18:04:18 -0400
Received: from mail.fireflyinternet.com ([77.68.26.236]:57331 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S2395367AbgJUWES (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Oct 2020 18:04:18 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from build.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 22769467-1500050 
        for multiple; Wed, 21 Oct 2020 23:04:13 +0100
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/2] drm/i915/gt: Use the local HWSP offset during submission
Date:   Wed, 21 Oct 2020 23:04:10 +0100
Message-Id: <20201021220411.5777-1-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We wrap the timeline on construction of the next request, but there may
still be requests in flight that have not yet finalized the breadcrumb.
(The breadcrumb is delayed as we need engine-local offsets, and for the
virtual engine that is not known until execution.) As such, by the time
we write to the timeline's HWSP offset it may have changed, and we
should use the value we preserved in the request instead.

Though the window is small and infrequent (at full flow we can expect a
timeline's seqno to wrap once every 30 minutes), the impact of writing
the old seqno into the new HWSP is severe: the old requests are never
completed, and the new requests are completed before they are even
submitted.

Fixes: ebece7539242 ("drm/i915: Keep timeline HWSP allocated until idle across the system")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: <stable@vger.kernel.org> # v5.2+
---
 drivers/gpu/drm/i915/gt/intel_lrc.c           | 22 ++++++++++++-------
 drivers/gpu/drm/i915/gt/intel_timeline.c      | 18 ++++++++-------
 .../gpu/drm/i915/gt/intel_timeline_types.h    |  2 ++
 3 files changed, 26 insertions(+), 16 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_lrc.c b/drivers/gpu/drm/i915/gt/intel_lrc.c
index c22d47cc6701..84ba6cd70a2a 100644
--- a/drivers/gpu/drm/i915/gt/intel_lrc.c
+++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
@@ -3597,6 +3597,14 @@ static const struct intel_context_ops execlists_context_ops = {
 	.destroy = execlists_context_destroy,
 };
 
+static u32 hwsp_offset(struct i915_request *rq)
+{
+	if (rq->hwsp_cacheline)
+		return rq->hwsp_cacheline->ggtt_offset;
+	else
+		return i915_request_active_timeline(rq)->hwsp_offset;
+}
+
 static int gen8_emit_init_breadcrumb(struct i915_request *rq)
 {
 	u32 *cs;
@@ -3619,7 +3627,7 @@ static int gen8_emit_init_breadcrumb(struct i915_request *rq)
 	*cs++ = MI_NOOP;
 
 	*cs++ = MI_STORE_DWORD_IMM_GEN4 | MI_USE_GGTT;
-	*cs++ = i915_request_timeline(rq)->hwsp_offset;
+	*cs++ = hwsp_offset(rq);
 	*cs++ = 0;
 	*cs++ = rq->fence.seqno - 1;
 
@@ -4939,11 +4947,9 @@ gen8_emit_fini_breadcrumb_tail(struct i915_request *request, u32 *cs)
 	return gen8_emit_wa_tail(request, cs);
 }
 
-static u32 *emit_xcs_breadcrumb(struct i915_request *request, u32 *cs)
+static u32 *emit_xcs_breadcrumb(struct i915_request *rq, u32 *cs)
 {
-	u32 addr = i915_request_active_timeline(request)->hwsp_offset;
-
-	return gen8_emit_ggtt_write(cs, request->fence.seqno, addr, 0);
+	return gen8_emit_ggtt_write(cs, rq->fence.seqno, hwsp_offset(rq), 0);
 }
 
 static u32 *gen8_emit_fini_breadcrumb(struct i915_request *rq, u32 *cs)
@@ -4962,7 +4968,7 @@ static u32 *gen8_emit_fini_breadcrumb_rcs(struct i915_request *request, u32 *cs)
 	/* XXX flush+write+CS_STALL all in one upsets gem_concurrent_blt:kbl */
 	cs = gen8_emit_ggtt_write_rcs(cs,
 				      request->fence.seqno,
-				      i915_request_active_timeline(request)->hwsp_offset,
+				      hwsp_offset(request),
 				      PIPE_CONTROL_FLUSH_ENABLE |
 				      PIPE_CONTROL_CS_STALL);
 
@@ -4974,7 +4980,7 @@ gen11_emit_fini_breadcrumb_rcs(struct i915_request *request, u32 *cs)
 {
 	cs = gen8_emit_ggtt_write_rcs(cs,
 				      request->fence.seqno,
-				      i915_request_active_timeline(request)->hwsp_offset,
+				      hwsp_offset(request),
 				      PIPE_CONTROL_CS_STALL |
 				      PIPE_CONTROL_TILE_CACHE_FLUSH |
 				      PIPE_CONTROL_RENDER_TARGET_CACHE_FLUSH |
@@ -5044,7 +5050,7 @@ gen12_emit_fini_breadcrumb_rcs(struct i915_request *request, u32 *cs)
 {
 	cs = gen12_emit_ggtt_write_rcs(cs,
 				       request->fence.seqno,
-				       i915_request_active_timeline(request)->hwsp_offset,
+				       hwsp_offset(request),
 				       PIPE_CONTROL0_HDC_PIPELINE_FLUSH,
 				       PIPE_CONTROL_CS_STALL |
 				       PIPE_CONTROL_TILE_CACHE_FLUSH |
diff --git a/drivers/gpu/drm/i915/gt/intel_timeline.c b/drivers/gpu/drm/i915/gt/intel_timeline.c
index a2f74cefe4c3..7ea94d201fe6 100644
--- a/drivers/gpu/drm/i915/gt/intel_timeline.c
+++ b/drivers/gpu/drm/i915/gt/intel_timeline.c
@@ -188,10 +188,14 @@ cacheline_alloc(struct intel_timeline_hwsp *hwsp, unsigned int cacheline)
 	return cl;
 }
 
-static void cacheline_acquire(struct intel_timeline_cacheline *cl)
+static void cacheline_acquire(struct intel_timeline_cacheline *cl,
+			      u32 ggtt_offset)
 {
-	if (cl)
-		i915_active_acquire(&cl->active);
+	if (!cl)
+		return;
+
+	cl->ggtt_offset = ggtt_offset;
+	i915_active_acquire(&cl->active);
 }
 
 static void cacheline_release(struct intel_timeline_cacheline *cl)
@@ -340,7 +344,7 @@ int intel_timeline_pin(struct intel_timeline *tl, struct i915_gem_ww_ctx *ww)
 	GT_TRACE(tl->gt, "timeline:%llx using HWSP offset:%x\n",
 		 tl->fence_context, tl->hwsp_offset);
 
-	cacheline_acquire(tl->hwsp_cacheline);
+	cacheline_acquire(tl->hwsp_cacheline, tl->hwsp_offset);
 	if (atomic_fetch_inc(&tl->pin_count)) {
 		cacheline_release(tl->hwsp_cacheline);
 		__i915_vma_unpin(tl->hwsp_ggtt);
@@ -515,7 +519,7 @@ __intel_timeline_get_seqno(struct intel_timeline *tl,
 	GT_TRACE(tl->gt, "timeline:%llx using HWSP offset:%x\n",
 		 tl->fence_context, tl->hwsp_offset);
 
-	cacheline_acquire(cl);
+	cacheline_acquire(cl, tl->hwsp_offset);
 	tl->hwsp_cacheline = cl;
 
 	*seqno = timeline_advance(tl);
@@ -573,9 +577,7 @@ int intel_timeline_read_hwsp(struct i915_request *from,
 	if (err)
 		goto out;
 
-	*hwsp = i915_ggtt_offset(cl->hwsp->vma) +
-		ptr_unmask_bits(cl->vaddr, CACHELINE_BITS) * CACHELINE_BYTES;
-
+	*hwsp = cl->ggtt_offset;
 out:
 	i915_active_release(&cl->active);
 	return err;
diff --git a/drivers/gpu/drm/i915/gt/intel_timeline_types.h b/drivers/gpu/drm/i915/gt/intel_timeline_types.h
index 02181c5020db..4474f487f589 100644
--- a/drivers/gpu/drm/i915/gt/intel_timeline_types.h
+++ b/drivers/gpu/drm/i915/gt/intel_timeline_types.h
@@ -94,6 +94,8 @@ struct intel_timeline_cacheline {
 	struct intel_timeline_hwsp *hwsp;
 	void *vaddr;
 
+	u32 ggtt_offset;
+
 	struct rcu_head rcu;
 };
 
-- 
2.20.1

