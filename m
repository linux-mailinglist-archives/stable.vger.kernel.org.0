Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F973171DE9
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:24:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388672AbgB0OMq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:12:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:51498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730496AbgB0OMp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:12:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8FB920578;
        Thu, 27 Feb 2020 14:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812765;
        bh=keYDipm+Iq7TfngzURSJZVCi3gp8M1K0OlqXF89m9hs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jZfXRp9xME/Mh7H3aEWtEwBpb4PK9rCFBBGsADGfz8O3MeqGoaixUEJel6N3/njwL
         oOhmkzfvZKYAXDoK1GISzw+IHxBew9NP0KFIHuoDffPLKg1oXrwHirCpy5lXF3VO3h
         zIa5XonlAWPFouCy3YQFuMUAkBMKX8Dzw7PXoqKU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.4 102/135] drm/i915/execlists: Always force a context reload when rewinding RING_TAIL
Date:   Thu, 27 Feb 2020 14:37:22 +0100
Message-Id: <20200227132244.567429552@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132228.710492098@linuxfoundation.org>
References: <20200227132228.710492098@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit b1339ecac661e1cf3e1dc78ac56bff3aeeaeb92c upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/gt/intel_engine.h       |    8 ++++++++
 drivers/gpu/drm/i915/gt/intel_engine_types.h |    1 +
 drivers/gpu/drm/i915/gt/intel_lrc.c          |   18 ++++++++----------
 drivers/gpu/drm/i915/gt/intel_ringbuffer.c   |    2 ++
 4 files changed, 19 insertions(+), 10 deletions(-)

--- a/drivers/gpu/drm/i915/gt/intel_engine.h
+++ b/drivers/gpu/drm/i915/gt/intel_engine.h
@@ -250,6 +250,14 @@ static inline u32 intel_ring_wrap(const
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
--- a/drivers/gpu/drm/i915/gt/intel_engine_types.h
+++ b/drivers/gpu/drm/i915/gt/intel_engine_types.h
@@ -107,6 +107,7 @@ struct intel_ring {
 
 	u32 space;
 	u32 size;
+	u32 wrap;
 	u32 effective_size;
 };
 
--- a/drivers/gpu/drm/i915/gt/intel_lrc.c
+++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
@@ -647,7 +647,7 @@ static u64 execlists_update_context(stru
 {
 	struct intel_context *ce = rq->hw_context;
 	u64 desc = ce->lrc_desc;
-	u32 tail;
+	u32 tail, prev;
 
 	/*
 	 * WaIdleLiteRestore:bdw,skl
@@ -660,9 +660,15 @@ static u64 execlists_update_context(stru
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
-	if (unlikely(ce->lrc_reg_state[CTX_RING_TAIL + 1] == tail))
+	prev = ce->lrc_reg_state[CTX_RING_TAIL + 1];
+	if (unlikely(intel_ring_direction(rq->ring, tail, prev) <= 0))
 		desc |= CTX_DESC_FORCE_RESTORE;
 	ce->lrc_reg_state[CTX_RING_TAIL + 1] = tail;
 	rq->tail = rq->wa_tail;
@@ -1110,14 +1116,6 @@ static void execlists_dequeue(struct int
 			 */
 			__unwind_incomplete_requests(engine);
 
-			/*
-			 * If we need to return to the preempted context, we
-			 * need to skip the lite-restore and force it to
-			 * reload the RING_TAIL. Otherwise, the HW has a
-			 * tendency to ignore us rewinding the TAIL to the
-			 * end of an earlier request.
-			 */
-			last->hw_context->lrc_desc |= CTX_DESC_FORCE_RESTORE;
 			last = NULL;
 		} else if (need_timeslice(engine, last) &&
 			   !timer_pending(&engine->execlists.timer)) {
--- a/drivers/gpu/drm/i915/gt/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/gt/intel_ringbuffer.c
@@ -1312,6 +1312,8 @@ intel_engine_create_ring(struct intel_en
 	kref_init(&ring->ref);
 
 	ring->size = size;
+	ring->wrap = BITS_PER_TYPE(ring->size) - ilog2(size);
+
 	/* Workaround an erratum on the i830 which causes a hang if
 	 * the TAIL pointer points to within the last 2 cachelines
 	 * of the buffer.


