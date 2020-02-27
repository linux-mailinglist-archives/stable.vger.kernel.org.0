Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E35F171E27
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:25:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387461AbgB0OZn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:25:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:49338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388211AbgB0OLB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:11:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE3A520714;
        Thu, 27 Feb 2020 14:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812661;
        bh=A9uAKK7YkzX0ba2QET25Yc8HWZTPTDPR+mNkf7f6ehc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TCjs7OqwdpAeBQ/DFQugQwFn72oGGmljeDmEvBTIMkOjwevmXEhZrj5sCNobLbF4t
         Xnu79nqP5b3JmvcQzwSevidXGovmN2G5n8hSfYLjUHSMmdgiYAxuEbyV5HoFb2ngsP
         rpQmz5UVVjSbhIa8pkJbwF9/wcSc1GR7iAt9KhR0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        stable@kernel.vger.org
Subject: [PATCH 5.4 101/135] drm/i915/gt: Detect if we miss WaIdleLiteRestore
Date:   Thu, 27 Feb 2020 14:37:21 +0100
Message-Id: <20200227132244.400898378@linuxfoundation.org>
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

commit 82c69bf58650e644c61aa2bf5100b63a1070fd2f upstream.

In order to avoid confusing the HW, we must never submit an empty ring
during lite-restore, that is we should always advance the RING_TAIL
before submitting to stay ahead of the RING_HEAD.

Normally this is prevented by keeping a couple of spare NOPs in the
request->wa_tail so that on resubmission we can advance the tail. This
relies on the request only being resubmitted once, which is the normal
condition as it is seen once for ELSP[1] and then later in ELSP[0]. On
preemption, the requests are unwound and the tail reset back to the
normal end point (as we know the request is incomplete and therefore its
RING_HEAD is even earlier).

However, if this w/a should fail we would try and resubmit the request
with the RING_TAIL already set to the location of this request's wa_tail
potentially causing a GPU hang. We can spot when we do try and
incorrectly resubmit without advancing the RING_TAIL and spare any
embarrassment by forcing the context restore.

In the case of preempt-to-busy, we leave the requests running on the HW
while we unwind. As the ring is still live, we cannot rewind our
rq->tail without forcing a reload so leave it set to rq->wa_tail and
only force a reload if we resubmit after a lite-restore. (Normally, the
forced reload will be a part of the preemption event.)

Fixes: 22b7a426bbe1 ("drm/i915/execlists: Preempt-to-busy")
Closes: https://gitlab.freedesktop.org/drm/intel/issues/673
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: stable@kernel.vger.org
Link: https://patchwork.freedesktop.org/patch/msgid/20191209023215.3519970-1-chris@chris-wilson.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/gpu/drm/i915/gt/intel_lrc.c |   42 +++++++++++++++++-------------------
 1 file changed, 20 insertions(+), 22 deletions(-)

--- a/drivers/gpu/drm/i915/gt/intel_lrc.c
+++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
@@ -471,12 +471,6 @@ lrc_descriptor(struct intel_context *ce,
 	return desc;
 }
 
-static void unwind_wa_tail(struct i915_request *rq)
-{
-	rq->tail = intel_ring_wrap(rq->ring, rq->wa_tail - WA_TAIL_BYTES);
-	assert_ring_tail_valid(rq->ring, rq->tail);
-}
-
 static struct i915_request *
 __unwind_incomplete_requests(struct intel_engine_cs *engine)
 {
@@ -495,7 +489,6 @@ __unwind_incomplete_requests(struct inte
 			continue; /* XXX */
 
 		__i915_request_unsubmit(rq);
-		unwind_wa_tail(rq);
 
 		/*
 		 * Push the request back into the queue for later resubmission.
@@ -650,13 +643,29 @@ execlists_schedule_out(struct i915_reque
 	i915_request_put(rq);
 }
 
-static u64 execlists_update_context(const struct i915_request *rq)
+static u64 execlists_update_context(struct i915_request *rq)
 {
 	struct intel_context *ce = rq->hw_context;
-	u64 desc;
+	u64 desc = ce->lrc_desc;
+	u32 tail;
 
-	ce->lrc_reg_state[CTX_RING_TAIL + 1] =
-		intel_ring_set_tail(rq->ring, rq->tail);
+	/*
+	 * WaIdleLiteRestore:bdw,skl
+	 *
+	 * We should never submit the context with the same RING_TAIL twice
+	 * just in case we submit an empty ring, which confuses the HW.
+	 *
+	 * We append a couple of NOOPs (gen8_emit_wa_tail) after the end of
+	 * the normal request to be able to always advance the RING_TAIL on
+	 * subsequent resubmissions (for lite restore). Should that fail us,
+	 * and we try and submit the same tail again, force the context
+	 * reload.
+	 */
+	tail = intel_ring_set_tail(rq->ring, rq->tail);
+	if (unlikely(ce->lrc_reg_state[CTX_RING_TAIL + 1] == tail))
+		desc |= CTX_DESC_FORCE_RESTORE;
+	ce->lrc_reg_state[CTX_RING_TAIL + 1] = tail;
+	rq->tail = rq->wa_tail;
 
 	/*
 	 * Make sure the context image is complete before we submit it to HW.
@@ -675,7 +684,6 @@ static u64 execlists_update_context(cons
 	 */
 	mb();
 
-	desc = ce->lrc_desc;
 	ce->lrc_desc &= ~CTX_DESC_FORCE_RESTORE;
 
 	return desc;
@@ -1150,16 +1158,6 @@ static void execlists_dequeue(struct int
 			if (!list_is_last(&last->sched.link,
 					  &engine->active.requests))
 				return;
-
-			/*
-			 * WaIdleLiteRestore:bdw,skl
-			 * Apply the wa NOOPs to prevent
-			 * ring:HEAD == rq:TAIL as we resubmit the
-			 * request. See gen8_emit_fini_breadcrumb() for
-			 * where we prepare the padding after the
-			 * end of the request.
-			 */
-			last->tail = last->wa_tail;
 		}
 	}
 


