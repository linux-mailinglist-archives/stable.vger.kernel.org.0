Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C24082ABACA
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:23:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388145AbgKINWU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:22:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:50260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388195AbgKINWQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:22:16 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EA6820897;
        Mon,  9 Nov 2020 13:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604928135;
        bh=v+8NgzgUpfLuwJX70v1JuQvopw9407bMbT6nDY/uK1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HeqwEDugklGrQ8ZWl+5zI0JWK+UMWr2rGDSXMivNzubmXEYKVkklhgbJo1k4gC7V7
         4s/fZJS8FfjAbaSAE/zXctHR4wuegvFioNpJljPLNXb71g1I7AbaVmjEOwQ3cun/k2
         dnTZdBv4Jq5WgyGhLzSpHufvwMNBy0yjiO3+uNbs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.9 132/133] drm/i915/gt: Use the local HWSP offset during submission
Date:   Mon,  9 Nov 2020 13:56:34 +0100
Message-Id: <20201109125037.040020609@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
References: <20201109125030.706496283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 8ce70996f759a37bac92e69ae0addd715227bfd1 upstream.

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
Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20201022064127.10159-1-chris@chris-wilson.co.uk
(cherry picked from commit c10f6019d0b2dc8a6a62b55459f3ada5bc4e5e1a)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/gt/intel_lrc.c            |   27 +++++++++++++++++--------
 drivers/gpu/drm/i915/gt/intel_timeline.c       |   18 +++++++++-------
 drivers/gpu/drm/i915/gt/intel_timeline_types.h |    2 +
 3 files changed, 31 insertions(+), 16 deletions(-)

--- a/drivers/gpu/drm/i915/gt/intel_lrc.c
+++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
@@ -3539,6 +3539,19 @@ static const struct intel_context_ops ex
 	.destroy = execlists_context_destroy,
 };
 
+static u32 hwsp_offset(const struct i915_request *rq)
+{
+	const struct intel_timeline_cacheline *cl;
+
+	/* Before the request is executed, the timeline/cachline is fixed */
+
+	cl = rcu_dereference_protected(rq->hwsp_cacheline, 1);
+	if (cl)
+		return cl->ggtt_offset;
+
+	return rcu_dereference_protected(rq->timeline, 1)->hwsp_offset;
+}
+
 static int gen8_emit_init_breadcrumb(struct i915_request *rq)
 {
 	u32 *cs;
@@ -3561,7 +3574,7 @@ static int gen8_emit_init_breadcrumb(str
 	*cs++ = MI_NOOP;
 
 	*cs++ = MI_STORE_DWORD_IMM_GEN4 | MI_USE_GGTT;
-	*cs++ = i915_request_timeline(rq)->hwsp_offset;
+	*cs++ = hwsp_offset(rq);
 	*cs++ = 0;
 	*cs++ = rq->fence.seqno - 1;
 
@@ -4865,11 +4878,9 @@ gen8_emit_fini_breadcrumb_tail(struct i9
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
@@ -4888,7 +4899,7 @@ static u32 *gen8_emit_fini_breadcrumb_rc
 	/* XXX flush+write+CS_STALL all in one upsets gem_concurrent_blt:kbl */
 	cs = gen8_emit_ggtt_write_rcs(cs,
 				      request->fence.seqno,
-				      i915_request_active_timeline(request)->hwsp_offset,
+				      hwsp_offset(request),
 				      PIPE_CONTROL_FLUSH_ENABLE |
 				      PIPE_CONTROL_CS_STALL);
 
@@ -4900,7 +4911,7 @@ gen11_emit_fini_breadcrumb_rcs(struct i9
 {
 	cs = gen8_emit_ggtt_write_rcs(cs,
 				      request->fence.seqno,
-				      i915_request_active_timeline(request)->hwsp_offset,
+				      hwsp_offset(request),
 				      PIPE_CONTROL_CS_STALL |
 				      PIPE_CONTROL_TILE_CACHE_FLUSH |
 				      PIPE_CONTROL_RENDER_TARGET_CACHE_FLUSH |
@@ -4970,7 +4981,7 @@ gen12_emit_fini_breadcrumb_rcs(struct i9
 {
 	cs = gen12_emit_ggtt_write_rcs(cs,
 				       request->fence.seqno,
-				       i915_request_active_timeline(request)->hwsp_offset,
+				       hwsp_offset(request),
 				       PIPE_CONTROL0_HDC_PIPELINE_FLUSH,
 				       PIPE_CONTROL_CS_STALL |
 				       PIPE_CONTROL_TILE_CACHE_FLUSH |
--- a/drivers/gpu/drm/i915/gt/intel_timeline.c
+++ b/drivers/gpu/drm/i915/gt/intel_timeline.c
@@ -188,10 +188,14 @@ cacheline_alloc(struct intel_timeline_hw
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
@@ -332,7 +336,7 @@ int intel_timeline_pin(struct intel_time
 	GT_TRACE(tl->gt, "timeline:%llx using HWSP offset:%x\n",
 		 tl->fence_context, tl->hwsp_offset);
 
-	cacheline_acquire(tl->hwsp_cacheline);
+	cacheline_acquire(tl->hwsp_cacheline, tl->hwsp_offset);
 	if (atomic_fetch_inc(&tl->pin_count)) {
 		cacheline_release(tl->hwsp_cacheline);
 		__i915_vma_unpin(tl->hwsp_ggtt);
@@ -505,7 +509,7 @@ __intel_timeline_get_seqno(struct intel_
 	GT_TRACE(tl->gt, "timeline:%llx using HWSP offset:%x\n",
 		 tl->fence_context, tl->hwsp_offset);
 
-	cacheline_acquire(cl);
+	cacheline_acquire(cl, tl->hwsp_offset);
 	tl->hwsp_cacheline = cl;
 
 	*seqno = timeline_advance(tl);
@@ -563,9 +567,7 @@ int intel_timeline_read_hwsp(struct i915
 	if (err)
 		goto out;
 
-	*hwsp = i915_ggtt_offset(cl->hwsp->vma) +
-		ptr_unmask_bits(cl->vaddr, CACHELINE_BITS) * CACHELINE_BYTES;
-
+	*hwsp = cl->ggtt_offset;
 out:
 	i915_active_release(&cl->active);
 	return err;
--- a/drivers/gpu/drm/i915/gt/intel_timeline_types.h
+++ b/drivers/gpu/drm/i915/gt/intel_timeline_types.h
@@ -94,6 +94,8 @@ struct intel_timeline_cacheline {
 	struct intel_timeline_hwsp *hwsp;
 	void *vaddr;
 
+	u32 ggtt_offset;
+
 	struct rcu_head rcu;
 };
 


