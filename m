Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65FA1280F05
	for <lists+stable@lfdr.de>; Fri,  2 Oct 2020 10:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387595AbgJBIea (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Oct 2020 04:34:30 -0400
Received: from mail.fireflyinternet.com ([77.68.26.236]:56149 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725961AbgJBIea (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Oct 2020 04:34:30 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from build.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 22599388-1500050 
        for multiple; Fri, 02 Oct 2020 09:34:27 +0100
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Bruce Chang <yu.bruce.chang@intel.com>,
        Ramalingam C <ramalingam.c@intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] drm/i915/gt: Undo forced context restores after trivial preemptions
Date:   Fri,  2 Oct 2020 09:34:25 +0100
Message-Id: <20201002083425.4605-1-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We may try to preempt the currently executing request, only to find that
after unravelling all the dependencies that the original executing
context is still the earliest in the topological sort and re-submitted
back to HW (if we do detect some change in the ELSP that requires
re-submission). However, due to the way we check for wrap-around during
the unravelling, we mark any context that has been submitted just once
(i.e. with the rq->wa_tail set, but the ring->tail earlier) as
potentially wrapping and requiring a forced restore on resubmission.
This was expected to be not a problem, as it was anticipated that most
unwinding for preemption would result in a context switch and the few
that did not would be lost in the noise. It did not take long for
someone to find one particular workload where the cost of those extra
context restores was measurable.

However, since we know the wa_tail is of fixed size, and we know that a
request must be larger than the wa_tail itself, we can safely maintain
the check for request wrapping and check against a slightly future point
in the ring that includes an expected wa_tail. (That is if the
ring->tail is already set to rq->wa_tail, including another 8 bytes in
the check does not invalidate the incremental wrap detection.)

Fixes: 8ab3a3812aa9 ("drm/i915/gt: Incrementally check for rewinding")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc: Bruce Chang <yu.bruce.chang@intel.com>
Cc: Ramalingam C <ramalingam.c@intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: <stable@vger.kernel.org> # v5.4+
---
 drivers/gpu/drm/i915/gt/intel_lrc.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_lrc.c b/drivers/gpu/drm/i915/gt/intel_lrc.c
index 287537089c77..3aa05588834b 100644
--- a/drivers/gpu/drm/i915/gt/intel_lrc.c
+++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
@@ -1140,9 +1140,8 @@ __unwind_incomplete_requests(struct intel_engine_cs *engine)
 
 			/* Check in case we rollback so far we wrap [size/2] */
 			if (intel_ring_direction(rq->ring,
-						 intel_ring_wrap(rq->ring,
-								 rq->tail),
-						 rq->ring->tail) > 0)
+						 rq->tail,
+						 rq->ring->tail + 8) > 0)
 				rq->context->lrc.desc |= CTX_DESC_FORCE_RESTORE;
 
 			active = rq;
-- 
2.20.1

