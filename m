Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC2F3031AF
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 03:21:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729963AbhAYStv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 13:49:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:35852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730840AbhAYSsq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:48:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F796224B8;
        Mon, 25 Jan 2021 18:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600484;
        bh=j/XEtw7DHPkTLU5YsQY4ychMOJTcc7bq6sVzuMNeunw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rh0XpEMghqvtapGhlpmllOBLa2z893l2+Y4RkszJPfdckG7ZXp6WZa7k1Tb5BSur+
         QZMdr11LJc9px3e/2X2nj04/Oyv0xy1Y3ruZMsPgUGY50TgduQbzFCGaex6HJ4/4Eu
         o7IJcn66SKkNiLJS9Ij5rycavVLvAjZIlp7JjSnk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.10 033/199] drm/i915: Check for rq->hwsp validity after acquiring RCU lock
Date:   Mon, 25 Jan 2021 19:37:35 +0100
Message-Id: <20210125183217.643577411@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 45db630e5f7ec83817c57c8ae387fe219bd42adf upstream.

Since we allow removing the timeline map at runtime, there is a risk
that rq->hwsp points into a stale page. To control that risk, we hold
the RCU read lock while reading *rq->hwsp, but we missed a couple of
important barriers. First, the unpinning / removal of the timeline map
must be after all RCU readers into that map are complete, i.e. after an
rcu barrier (in this case courtesy of call_rcu()). Secondly, we must
make sure that the rq->hwsp we are about to dereference under the RCU
lock is valid. In this case, we make the rq->hwsp pointer safe during
i915_request_retire() and so we know that rq->hwsp may become invalid
only after the request has been signaled. Therefore is the request is
not yet signaled when we acquire rq->hwsp under the RCU, we know that
rq->hwsp will remain valid for the duration of the RCU read lock.

This is a very small window that may lead to either considering the
request not completed (causing a delay until the request is checked
again, any wait for the request is not affected) or dereferencing an
invalid pointer.

Fixes: 3adac4689f58 ("drm/i915: Introduce concept of per-timeline (context) HWSP")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: <stable@vger.kernel.org> # v5.1+
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20201218122421.18344-1-chris@chris-wilson.co.uk
(cherry picked from commit 9bb36cf66091ddf2d8840e5aa705ad3c93a6279b)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210118101755.476744-1-chris@chris-wilson.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/gt/intel_breadcrumbs.c |    9 +-----
 drivers/gpu/drm/i915/gt/intel_timeline.c    |   10 +++----
 drivers/gpu/drm/i915/i915_request.h         |   37 ++++++++++++++++++++++++----
 3 files changed, 38 insertions(+), 18 deletions(-)

--- a/drivers/gpu/drm/i915/gt/intel_breadcrumbs.c
+++ b/drivers/gpu/drm/i915/gt/intel_breadcrumbs.c
@@ -134,11 +134,6 @@ static bool remove_signaling_context(str
 	return true;
 }
 
-static inline bool __request_completed(const struct i915_request *rq)
-{
-	return i915_seqno_passed(__hwsp_seqno(rq), rq->fence.seqno);
-}
-
 __maybe_unused static bool
 check_signal_order(struct intel_context *ce, struct i915_request *rq)
 {
@@ -257,7 +252,7 @@ static void signal_irq_work(struct irq_w
 		list_for_each_entry_rcu(rq, &ce->signals, signal_link) {
 			bool release;
 
-			if (!__request_completed(rq))
+			if (!__i915_request_is_complete(rq))
 				break;
 
 			if (!test_and_clear_bit(I915_FENCE_FLAG_SIGNAL,
@@ -379,7 +374,7 @@ static void insert_breadcrumb(struct i91
 	 * straight onto a signaled list, and queue the irq worker for
 	 * its signal completion.
 	 */
-	if (__request_completed(rq)) {
+	if (__i915_request_is_complete(rq)) {
 		if (__signal_request(rq) &&
 		    llist_add(&rq->signal_node, &b->signaled_requests))
 			irq_work_queue(&b->irq_work);
--- a/drivers/gpu/drm/i915/gt/intel_timeline.c
+++ b/drivers/gpu/drm/i915/gt/intel_timeline.c
@@ -126,6 +126,10 @@ static void __rcu_cacheline_free(struct
 	struct intel_timeline_cacheline *cl =
 		container_of(rcu, typeof(*cl), rcu);
 
+	/* Must wait until after all *rq->hwsp are complete before removing */
+	i915_gem_object_unpin_map(cl->hwsp->vma->obj);
+	__idle_hwsp_free(cl->hwsp, ptr_unmask_bits(cl->vaddr, CACHELINE_BITS));
+
 	i915_active_fini(&cl->active);
 	kfree(cl);
 }
@@ -133,11 +137,6 @@ static void __rcu_cacheline_free(struct
 static void __idle_cacheline_free(struct intel_timeline_cacheline *cl)
 {
 	GEM_BUG_ON(!i915_active_is_idle(&cl->active));
-
-	i915_gem_object_unpin_map(cl->hwsp->vma->obj);
-	i915_vma_put(cl->hwsp->vma);
-	__idle_hwsp_free(cl->hwsp, ptr_unmask_bits(cl->vaddr, CACHELINE_BITS));
-
 	call_rcu(&cl->rcu, __rcu_cacheline_free);
 }
 
@@ -179,7 +178,6 @@ cacheline_alloc(struct intel_timeline_hw
 		return ERR_CAST(vaddr);
 	}
 
-	i915_vma_get(hwsp->vma);
 	cl->hwsp = hwsp;
 	cl->vaddr = page_pack_bits(vaddr, cacheline);
 
--- a/drivers/gpu/drm/i915/i915_request.h
+++ b/drivers/gpu/drm/i915/i915_request.h
@@ -434,7 +434,7 @@ static inline u32 hwsp_seqno(const struc
 
 static inline bool __i915_request_has_started(const struct i915_request *rq)
 {
-	return i915_seqno_passed(hwsp_seqno(rq), rq->fence.seqno - 1);
+	return i915_seqno_passed(__hwsp_seqno(rq), rq->fence.seqno - 1);
 }
 
 /**
@@ -465,11 +465,19 @@ static inline bool __i915_request_has_st
  */
 static inline bool i915_request_started(const struct i915_request *rq)
 {
+	bool result;
+
 	if (i915_request_signaled(rq))
 		return true;
 
-	/* Remember: started but may have since been preempted! */
-	return __i915_request_has_started(rq);
+	result = true;
+	rcu_read_lock(); /* the HWSP may be freed at runtime */
+	if (likely(!i915_request_signaled(rq)))
+		/* Remember: started but may have since been preempted! */
+		result = __i915_request_has_started(rq);
+	rcu_read_unlock();
+
+	return result;
 }
 
 /**
@@ -482,10 +490,16 @@ static inline bool i915_request_started(
  */
 static inline bool i915_request_is_running(const struct i915_request *rq)
 {
+	bool result;
+
 	if (!i915_request_is_active(rq))
 		return false;
 
-	return __i915_request_has_started(rq);
+	rcu_read_lock();
+	result = __i915_request_has_started(rq) && i915_request_is_active(rq);
+	rcu_read_unlock();
+
+	return result;
 }
 
 /**
@@ -509,12 +523,25 @@ static inline bool i915_request_is_ready
 	return !list_empty(&rq->sched.link);
 }
 
+static inline bool __i915_request_is_complete(const struct i915_request *rq)
+{
+	return i915_seqno_passed(__hwsp_seqno(rq), rq->fence.seqno);
+}
+
 static inline bool i915_request_completed(const struct i915_request *rq)
 {
+	bool result;
+
 	if (i915_request_signaled(rq))
 		return true;
 
-	return i915_seqno_passed(hwsp_seqno(rq), rq->fence.seqno);
+	result = true;
+	rcu_read_lock(); /* the HWSP may be freed at runtime */
+	if (likely(!i915_request_signaled(rq)))
+		result = __i915_request_is_complete(rq);
+	rcu_read_unlock();
+
+	return result;
 }
 
 static inline void i915_request_mark_complete(struct i915_request *rq)


