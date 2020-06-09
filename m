Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 275651F4053
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 18:11:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731021AbgFIQLg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 12:11:36 -0400
Received: from mga14.intel.com ([192.55.52.115]:35944 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730652AbgFIQLg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 12:11:36 -0400
IronPort-SDR: nMeqbyv8bDM5RegbtTtFg9JKJSBA2omyJ9eKua0scXyddljGzIhR0IDwaHsSyT6aWdVklUx/jl
 PVOz8sC/J8Vw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2020 09:11:35 -0700
IronPort-SDR: yNuIwuuWWuBMK+Bc3JG5EV5sYYFeG7CXWQX+3plwW4iGG03M4XJNAZ3OM9LfFZLSC2rpXDIV5P
 LXmrvehaP46A==
X-IronPort-AV: E=Sophos;i="5.73,492,1583222400"; 
   d="scan'208";a="306306746"
Received: from gem-build.fi.intel.com (HELO localhost) ([10.237.72.180])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2020 09:11:34 -0700
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     gfx-internal-devel@eclists.intel.com
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH 060/185] drm/i915/execlists: Track inflight CCID
Date:   Tue,  9 Jun 2020 16:05:25 +0000
Message-Id: <20200609160731.287073-61-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200609160731.287073-1-chris@chris-wilson.co.uk>
References: <20200609160731.287073-1-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The presumption is that by using a circular counter that is twice as
large as the maximum ELSP submission, we would never reuse the same CCID
for two inflight contexts.

However, if we continually preempt an active context such that it always
remains inflight, it can be resubmitted with an arbitrary number of
paired contexts. As each of its paired contexts will use a new CCID,
eventually it will wrap and submit two ELSP with the same CCID.

Rather than use a simple circular counter, switch over to a small bitmap
of inflight ids so we can avoid reusing one that is still potentially
active.

Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/1796
Fixes: 2935ed5339c4 ("drm/i915: Remove logical HW ID")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc: <stable@vger.kernel.org> # v5.5+
Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200428184751.11257-2-chris@chris-wilson.co.uk
(cherry picked from commit 5c4a53e3b1cbc38d0906e382f1037290658759bb)
---
 drivers/gpu/drm/i915/gt/intel_engine_types.h |  3 +-
 drivers/gpu/drm/i915/gt/intel_lrc.c          | 29 +++++++++++++++-----
 drivers/gpu/drm/i915/i915_perf.c             |  3 +-
 drivers/gpu/drm/i915/selftests/i915_vma.c    |  2 +-
 4 files changed, 25 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_engine_types.h b/drivers/gpu/drm/i915/gt/intel_engine_types.h
index e0de4af9a3481..781f94ce65f65 100644
--- a/drivers/gpu/drm/i915/gt/intel_engine_types.h
+++ b/drivers/gpu/drm/i915/gt/intel_engine_types.h
@@ -308,8 +308,7 @@ struct intel_engine_cs {
 	u32 context_size;
 	u32 mmio_base;
 
-	unsigned int context_tag;
-#define NUM_CONTEXT_TAG roundup_pow_of_two(2 * EXECLIST_MAX_PORTS)
+	unsigned long context_tag;
 
 	struct rb_node uabi_node;
 
diff --git a/drivers/gpu/drm/i915/gt/intel_lrc.c b/drivers/gpu/drm/i915/gt/intel_lrc.c
index dfcc44171df1c..adfaf52ca8d08 100644
--- a/drivers/gpu/drm/i915/gt/intel_lrc.c
+++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
@@ -1321,13 +1321,17 @@ __execlists_schedule_in(struct i915_request *rq)
 
 	if (ce->tag) {
 		/* Use a fixed tag for OA and friends */
+		GEM_BUG_ON(ce->tag <= BITS_PER_LONG);
 		ce->lrc.ccid = ce->tag;
 	} else {
 		/* We don't need a strict matching tag, just different values */
-		ce->lrc.ccid =
-			(++engine->context_tag % NUM_CONTEXT_TAG) <<
-			(GEN11_SW_CTX_ID_SHIFT - 32);
-		BUILD_BUG_ON(NUM_CONTEXT_TAG > GEN12_MAX_CONTEXT_HW_ID);
+		unsigned int tag = ffs(engine->context_tag);
+
+		GEM_BUG_ON(tag == 0 || tag >= BITS_PER_LONG);
+		clear_bit(tag - 1, &engine->context_tag);
+		ce->lrc.ccid = tag << (GEN11_SW_CTX_ID_SHIFT - 32);
+
+		BUILD_BUG_ON(BITS_PER_LONG > GEN12_MAX_CONTEXT_HW_ID);
 	}
 
 	ce->lrc.ccid |= engine->execlists.ccid;
@@ -1371,7 +1375,8 @@ static void kick_siblings(struct i915_request *rq, struct intel_context *ce)
 
 static inline void
 __execlists_schedule_out(struct i915_request *rq,
-			 struct intel_engine_cs * const engine)
+			 struct intel_engine_cs * const engine,
+			 unsigned int ccid)
 {
 	struct intel_context * const ce = rq->context;
 
@@ -1389,6 +1394,14 @@ __execlists_schedule_out(struct i915_request *rq,
 	    i915_request_completed(rq))
 		intel_engine_add_retire(engine, ce->timeline);
 
+	ccid >>= GEN11_SW_CTX_ID_SHIFT - 32;
+	ccid &= GEN12_MAX_CONTEXT_HW_ID;
+	if (ccid < BITS_PER_LONG) {
+		GEM_BUG_ON(ccid == 0);
+		GEM_BUG_ON(test_bit(ccid - 1, &engine->context_tag));
+		set_bit(ccid - 1, &engine->context_tag);
+	}
+
 	intel_context_update_runtime(ce);
 	intel_engine_context_out(engine);
 	execlists_context_status_change(rq, INTEL_CONTEXT_SCHEDULE_OUT);
@@ -1414,15 +1427,17 @@ execlists_schedule_out(struct i915_request *rq)
 {
 	struct intel_context * const ce = rq->context;
 	struct intel_engine_cs *cur, *old;
+	u32 ccid;
 
 	trace_i915_request_out(rq);
 
+	ccid = rq->context->lrc.ccid;
 	old = READ_ONCE(ce->inflight);
 	do
 		cur = ptr_unmask_bits(old, 2) ? ptr_dec(old) : NULL;
 	while (!try_cmpxchg(&ce->inflight, &old, cur));
 	if (!cur)
-		__execlists_schedule_out(rq, old);
+		__execlists_schedule_out(rq, old, ccid);
 
 	i915_request_put(rq);
 }
@@ -3883,7 +3898,7 @@ static void enable_execlists(struct intel_engine_cs *engine)
 
 	enable_error_interrupt(engine);
 
-	engine->context_tag = 0;
+	engine->context_tag = GENMASK(BITS_PER_LONG - 2, 0);
 }
 
 static bool unexpected_starting_state(struct intel_engine_cs *engine)
diff --git a/drivers/gpu/drm/i915/i915_perf.c b/drivers/gpu/drm/i915/i915_perf.c
index 6e3d378ebbbd6..820c6ba755cce 100644
--- a/drivers/gpu/drm/i915/i915_perf.c
+++ b/drivers/gpu/drm/i915/i915_perf.c
@@ -1326,11 +1326,10 @@ static int oa_get_render_ctx_id(struct i915_perf_stream *stream)
 			((1U << GEN11_SW_CTX_ID_WIDTH) - 1) << (GEN11_SW_CTX_ID_SHIFT - 32);
 		/*
 		 * Pick an unused context id
-		 * 0 - (NUM_CONTEXT_TAG - 1) are used by other contexts
+		 * 0 - BITS_PER_LONG are used by other contexts
 		 * GEN12_MAX_CONTEXT_HW_ID (0x7ff) is used by idle context
 		 */
 		stream->specific_ctx_id = (GEN12_MAX_CONTEXT_HW_ID - 1) << (GEN11_SW_CTX_ID_SHIFT - 32);
-		BUILD_BUG_ON((GEN12_MAX_CONTEXT_HW_ID - 1) < NUM_CONTEXT_TAG);
 		break;
 	}
 
diff --git a/drivers/gpu/drm/i915/selftests/i915_vma.c b/drivers/gpu/drm/i915/selftests/i915_vma.c
index 58b5f40a07dd6..af89c7fc8f593 100644
--- a/drivers/gpu/drm/i915/selftests/i915_vma.c
+++ b/drivers/gpu/drm/i915/selftests/i915_vma.c
@@ -173,7 +173,7 @@ static int igt_vma_create(void *arg)
 		}
 
 		nc = 0;
-		for_each_prime_number(num_ctx, 2 * NUM_CONTEXT_TAG) {
+		for_each_prime_number(num_ctx, 2 * BITS_PER_LONG) {
 			for (; nc < num_ctx; nc++) {
 				ctx = mock_context(i915, "mock");
 				if (!ctx)
---------------------------------------------------------------------
Intel Corporation (UK) Limited
Registered No. 1134945 (England)
Registered Office: Pipers Way, Swindon SN3 1RJ
VAT No: 860 2173 47

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

