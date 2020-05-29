Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6238B1E781A
	for <lists+stable@lfdr.de>; Fri, 29 May 2020 10:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725601AbgE2IUX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 May 2020 04:20:23 -0400
Received: from mga18.intel.com ([134.134.136.126]:10357 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725306AbgE2IUW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 29 May 2020 04:20:22 -0400
IronPort-SDR: Bmspj7ontlywMHjoug7pYNsi52SRbB6L99GZkZ3y+VcsFgGsWyufa2uyqUAsdNZGno86xFVbxW
 MJvXpovIm7/Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2020 01:20:20 -0700
IronPort-SDR: am5vOOWJLw5WeuCbppVKERvGAF+pCda4HIH6lgC3gPF7QV8flxAytMWibvvcvDawKmHej0M6J3
 WbH3Mq3TGWdg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,447,1583222400"; 
   d="scan'208";a="376641764"
Received: from vtt.iind.intel.com ([10.145.162.194])
  by fmsmga001.fm.intel.com with ESMTP; 29 May 2020 01:20:17 -0700
From:   Prasad Nallani <prasad.nallani@intel.com>
To:     gfx-internal-devel@eclists.intel.com
Cc:     andi.shyti@intel.com, Chris Wilson <chris@chris-wilson.co.uk>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        stable@vger.kernel.org, Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 04/23] drm/i915/execlists: Always force a context reload when rewinding RING_TAIL
Date:   Fri, 29 May 2020 13:47:51 +0530
Message-Id: <20200529081810.10747-5-prasad.nallani@intel.com>
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

If we rewind the RING_TAIL on a context, due to a preemption event, we
must force the context restore for the RING_TAIL update to be properly
handled. Rather than note which preemption events may cause us to rewind
the tail, compare the new request's tail with the previously submitted
RING_TAIL, as it turns out that timeslicing was causing unexpected
rewinds.

   <idle>-0       0d.s2 1280851190us : __execlists_submission_tasklet: 0000:00:02.0 rcs0: expired last=130:4698, prio=3, hint=3
   <idle>-0       0d.s2 1280851192us : __i915_request_unsubmit: 0000:00:02.0 rcs0: fence 66:119966, current 119964
   <idle>-0       0d.s2 1280851195us : __i915_request_unsubmit: 0000:00:02.0 rcs0: fence 130:4698, current 4695
   <idle>-0       0d.s2 1280851198us : __i915_request_unsubmit: 0000:00:02.0 rcs0: fence 130:4696, current 4695
^----  Note we unwind 2 requests from the same context

   <idle>-0       0d.s2 1280851208us : __i915_request_submit: 0000:00:02.0 rcs0: fence 130:4696, current 4695
   <idle>-0       0d.s2 1280851213us : __i915_request_submit: 0000:00:02.0 rcs0: fence 134:1508, current 1506
^---- But to apply the new timeslice, we have to replay the first request
      before the new client can start -- the unexpected RING_TAIL rewind

   <idle>-0       0d.s2 1280851219us : trace_ports: 0000:00:02.0 rcs0: submit { 130:4696*, 134:1508 }
 synmark2-5425    2..s. 1280851239us : process_csb: 0000:00:02.0 rcs0: cs-irq head=5, tail=0
 synmark2-5425    2..s. 1280851240us : process_csb: 0000:00:02.0 rcs0: csb[0]: status=0x00008002:0x00000000
^---- Preemption event for the ELSP update; note the lite-restore

 synmark2-5425    2..s. 1280851243us : trace_ports: 0000:00:02.0 rcs0: preempted { 130:4698, 66:119966 }
 synmark2-5425    2..s. 1280851246us : trace_ports: 0000:00:02.0 rcs0: promote { 130:4696*, 134:1508 }
 synmark2-5425    2.... 1280851462us : __i915_request_commit: 0000:00:02.0 rcs0: fence 130:4700, current 4695
 synmark2-5425    2.... 1280852111us : __i915_request_commit: 0000:00:02.0 rcs0: fence 130:4702, current 4695
 synmark2-5425    2.Ns1 1280852296us : process_csb: 0000:00:02.0 rcs0: cs-irq head=0, tail=2
 synmark2-5425    2.Ns1 1280852297us : process_csb: 0000:00:02.0 rcs0: csb[1]: status=0x00000814:0x00000000
 synmark2-5425    2.Ns1 1280852299us : trace_ports: 0000:00:02.0 rcs0: completed { 130:4696!, 134:1508 }
 synmark2-5425    2.Ns1 1280852301us : process_csb: 0000:00:02.0 rcs0: csb[2]: status=0x00000818:0x00000040
 synmark2-5425    2.Ns1 1280852302us : trace_ports: 0000:00:02.0 rcs0: completed { 134:1508, 0:0 }
 synmark2-5425    2.Ns1 1280852313us : process_csb: process_csb:2336 GEM_BUG_ON(!i915_request_completed(*execlists->active) && !reset_in_progress(execlists))

Fixes: 8ee36e048c98 ("drm/i915/execlists: Minimalistic timeslicing")
Referenecs: 82c69bf58650 ("drm/i915/gt: Detect if we miss WaIdleLiteRestore")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc: <stable@vger.kernel.org> # v5.4+
Link: https://patchwork.freedesktop.org/patch/msgid/20200207211452.2860634-1-chris@chris-wilson.co.uk
(cherry picked from commit 5ba32c7be81e53ea8a27190b0f6be98e6c6779af)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit b1339ecac661e1cf3e1dc78ac56bff3aeeaeb92c)
---
 drivers/gpu/drm/i915/gt/intel_lrc.c        | 18 ++++++++----------
 drivers/gpu/drm/i915/gt/intel_ring.c       |  1 +
 drivers/gpu/drm/i915/gt/intel_ring.h       |  8 ++++++++
 drivers/gpu/drm/i915/gt/intel_ring_types.h |  1 +
 4 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_lrc.c b/drivers/gpu/drm/i915/gt/intel_lrc.c
index 2a04c767121b..c50e5da842ca 100644
--- a/drivers/gpu/drm/i915/gt/intel_lrc.c
+++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
@@ -1446,7 +1446,7 @@ static u64 execlists_update_context(struct i915_request *rq)
 {
 	struct intel_context *ce = rq->context;
 	u64 desc = ce->lrc_desc;
-	u32 tail;
+	u32 tail, prev;
 
 	/*
 	 * WaIdleLiteRestore:bdw,skl
@@ -1459,9 +1459,15 @@ static u64 execlists_update_context(struct i915_request *rq)
 	 * subsequent resubmissions (for lite restore). Should that fail us,
 	 * and we try and submit the same tail again, force the context
 	 * reload.
+	 *
+	 * If we need to return to a preempted context, we need to skip the
+	 * lite-restore and force it to reload the RING_TAIL. Otherwise, the
+	 * HW has a tendency to ignore us rewinding the TAIL to the end of
+	 * an earlier request.
 	 */
 	tail = intel_ring_set_tail(rq->ring, rq->tail);
-	if (unlikely(ce->lrc_reg_state[CTX_RING_TAIL] == tail))
+	prev = ce->lrc_reg_state[CTX_RING_TAIL];
+	if (unlikely(intel_ring_direction(rq->ring, tail, prev) <= 0))
 		desc |= CTX_DESC_FORCE_RESTORE;
 	ce->lrc_reg_state[CTX_RING_TAIL] = tail;
 	rq->tail = rq->wa_tail;
@@ -1968,14 +1974,6 @@ static void execlists_dequeue(struct intel_engine_cs *engine)
 			 */
 			__unwind_incomplete_requests(engine);
 
-			/*
-			 * If we need to return to the preempted context, we
-			 * need to skip the lite-restore and force it to
-			 * reload the RING_TAIL. Otherwise, the HW has a
-			 * tendency to ignore us rewinding the TAIL to the
-			 * end of an earlier request.
-			 */
-			last->context->lrc_desc |= CTX_DESC_FORCE_RESTORE;
 			last = NULL;
 		} else if (need_timeslice(engine, last) &&
 			   timer_expired(&engine->execlists.timer)) {
diff --git a/drivers/gpu/drm/i915/gt/intel_ring.c b/drivers/gpu/drm/i915/gt/intel_ring.c
index 374b28f13ca0..6ff803f397c4 100644
--- a/drivers/gpu/drm/i915/gt/intel_ring.c
+++ b/drivers/gpu/drm/i915/gt/intel_ring.c
@@ -145,6 +145,7 @@ intel_engine_create_ring(struct intel_engine_cs *engine, int size)
 
 	kref_init(&ring->ref);
 	ring->size = size;
+	ring->wrap = BITS_PER_TYPE(ring->size) - ilog2(size);
 
 	/*
 	 * Workaround an erratum on the i830 which causes a hang if
diff --git a/drivers/gpu/drm/i915/gt/intel_ring.h b/drivers/gpu/drm/i915/gt/intel_ring.h
index ea2839d9e044..5bdce24994aa 100644
--- a/drivers/gpu/drm/i915/gt/intel_ring.h
+++ b/drivers/gpu/drm/i915/gt/intel_ring.h
@@ -56,6 +56,14 @@ static inline u32 intel_ring_wrap(const struct intel_ring *ring, u32 pos)
 	return pos & (ring->size - 1);
 }
 
+static inline int intel_ring_direction(const struct intel_ring *ring,
+				       u32 next, u32 prev)
+{
+	typecheck(typeof(ring->size), next);
+	typecheck(typeof(ring->size), prev);
+	return (next - prev) << ring->wrap;
+}
+
 static inline bool
 intel_ring_offset_valid(const struct intel_ring *ring,
 			unsigned int pos)
diff --git a/drivers/gpu/drm/i915/gt/intel_ring_types.h b/drivers/gpu/drm/i915/gt/intel_ring_types.h
index d9f17f38e0cc..3cd7fec7fd8d 100644
--- a/drivers/gpu/drm/i915/gt/intel_ring_types.h
+++ b/drivers/gpu/drm/i915/gt/intel_ring_types.h
@@ -45,6 +45,7 @@ struct intel_ring {
 
 	u32 space;
 	u32 size;
+	u32 wrap;
 	u32 effective_size;
 };
 
