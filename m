Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 491EF420E74
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236096AbhJDNZM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:25:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:38168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236524AbhJDNWJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:22:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3DEC261BE3;
        Mon,  4 Oct 2021 13:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352980;
        bh=G5N68ogxPOyVPsCq0EXsuXcQ22sRzRd8LAAZOtMEC1M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=amJ+BC4GbjX1BLGYe1vQZCVuo4HvHF/Q2aWnrKfaxEXss7iYIjD0RpPT0FXP/NQeB
         zYiJC9XmvICIRTEmEzsEENNJv1X0/qWmimQanO06WubwReTcZOzf3rWIKskttPGLuf
         RFEBezjdSvl68HWNzwaNCyt7Yn18Rg2k/ZT1xn7Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthew Auld <matthew.auld@intel.com>,
        Michael Mason <michael.w.mason@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 42/93] drm/i915/request: fix early tracepoints
Date:   Mon,  4 Oct 2021 14:52:40 +0200
Message-Id: <20211004125035.948980497@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125034.579439135@linuxfoundation.org>
References: <20211004125034.579439135@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Auld <matthew.auld@intel.com>

[ Upstream commit c83ff0186401169eb27ce5057d820b7a863455c3 ]

Currently we blow up in trace_dma_fence_init, when calling into
get_driver_name or get_timeline_name, since both the engine and context
might be NULL(or contain some garbage address) in the case of newly
allocated slab objects via the request ctor. Note that we also use
SLAB_TYPESAFE_BY_RCU here, which allows requests to be immediately
freed, but delay freeing the underlying page by an RCU grace period.
With this scheme requests can be re-allocated, at the same time as they
are also being read by some lockless RCU lookup mechanism.

In the ctor case, which is only called for new slab objects(i.e allocate
new page and call the ctor for each object) it's safe to reset the
context/engine prior to calling into dma_fence_init, since we can be
certain that no one is doing an RCU lookup which might depend on peeking
at the engine/context, like in active_engine(), since the object can't
yet be externally visible.

In the recycled case(which might also be externally visible) the request
refcount always transitions from 0->1 after we set the context/engine
etc, which should ensure it's valid to dereference the engine for
example, when doing an RCU list-walk, so long as we can also increment
the refcount first. If the refcount is already zero, then the request is
considered complete/released.  If it's non-zero, then the request might
be in the process of being re-allocated, or potentially still in flight,
however after successfully incrementing the refcount, it's possible to
carefully inspect the request state, to determine if the request is
still what we were looking for. Note that all externally visible
requests returned to the cache must have zero refcount.

One possible fix then is to move dma_fence_init out from the request
ctor. Originally this was how it was done, but it was moved in:

commit 855e39e65cfc33a73724f1cc644ffc5754864a20
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Mon Feb 3 09:41:48 2020 +0000

    drm/i915: Initialise basic fence before acquiring seqno

where it looks like intel_timeline_get_seqno() relied on some of the
rq->fence state, but that is no longer the case since:

commit 12ca695d2c1ed26b2dcbb528b42813bd0f216cfc
Author: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Date:   Tue Mar 23 16:49:50 2021 +0100

    drm/i915: Do not share hwsp across contexts any more, v8.

intel_timeline_get_seqno() could also be cleaned up slightly by dropping
the request argument.

Moving dma_fence_init back out of the ctor, should ensure we have enough
of the request initialised in case of trace_dma_fence_init.
Functionally this should be the same, and is effectively what we were
already open coding before, except now we also assign the fence->lock
and fence->ops, but since these are invariant for recycled
requests(which might be externally visible), and will therefore already
hold the same value, it shouldn't matter.

An alternative fix, since we don't yet have a fully initialised request
when in the ctor, is just setting the context/engine as NULL, but this
does require adding some extra handling in get_driver_name etc.

v2(Daniel):
  - Try to make the commit message less confusing

Fixes: 855e39e65cfc ("drm/i915: Initialise basic fence before acquiring seqno")
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Michael Mason <michael.w.mason@intel.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20210921134202.3803151-1-matthew.auld@intel.com
(cherry picked from commit be988eaee1cb208c4445db46bc3ceaf75f586f0b)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/i915_request.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_request.c b/drivers/gpu/drm/i915/i915_request.c
index d8fef42ca38e..896389f93029 100644
--- a/drivers/gpu/drm/i915/i915_request.c
+++ b/drivers/gpu/drm/i915/i915_request.c
@@ -776,8 +776,6 @@ static void __i915_request_ctor(void *arg)
 	i915_sw_fence_init(&rq->submit, submit_notify);
 	i915_sw_fence_init(&rq->semaphore, semaphore_notify);
 
-	dma_fence_init(&rq->fence, &i915_fence_ops, &rq->lock, 0, 0);
-
 	rq->capture_list = NULL;
 
 	init_llist_head(&rq->execute_cb);
@@ -840,17 +838,12 @@ __i915_request_create(struct intel_context *ce, gfp_t gfp)
 	rq->ring = ce->ring;
 	rq->execution_mask = ce->engine->mask;
 
-	kref_init(&rq->fence.refcount);
-	rq->fence.flags = 0;
-	rq->fence.error = 0;
-	INIT_LIST_HEAD(&rq->fence.cb_list);
-
 	ret = intel_timeline_get_seqno(tl, rq, &seqno);
 	if (ret)
 		goto err_free;
 
-	rq->fence.context = tl->fence_context;
-	rq->fence.seqno = seqno;
+	dma_fence_init(&rq->fence, &i915_fence_ops, &rq->lock,
+		       tl->fence_context, seqno);
 
 	RCU_INIT_POINTER(rq->timeline, tl);
 	RCU_INIT_POINTER(rq->hwsp_cacheline, tl->hwsp_cacheline);
-- 
2.33.0



