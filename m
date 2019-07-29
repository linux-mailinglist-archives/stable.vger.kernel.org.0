Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2ACF6796F2
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403914AbfG2Tzo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:55:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:48512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391048AbfG2Tzl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:55:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A4942054F;
        Mon, 29 Jul 2019 19:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564430140;
        bh=71/CmMNhNip2fgg79PeggCuwhuzDhvx2mKbBfwvQMOY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iVZgSePMrxgqOrD5x2y4mxGdhPMBcc/Xg53NYrCWRJ9H8Hk217lOXLzebojiUkXfA
         bIGdU2nFSTUbd+Jh1mM/2xD02YGP+KSkRC4soWbQC785I54Vb4PmjCvcWD+GteCGYm
         qQ0Nx95YzPVn6amZDvAYV93Mixd4QDk2xJvV38fs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Dmitry Rogozhkin <dmitry.v.rogozhkin@intel.com>,
        Dmitry Ermilov <dmitry.ermilov@intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 5.2 210/215] drm/i915: Make the semaphore saturation mask global
Date:   Mon, 29 Jul 2019 21:23:26 +0200
Message-Id: <20190729190816.360739317@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 44d89409a12eb8333735958509d7d591b461d13d upstream.

The idea behind keeping the saturation mask local to a context backfired
spectacularly. The premise with the local mask was that we would be more
proactive in attempting to use semaphores after each time the context
idled, and that all new contexts would attempt to use semaphores
ignoring the current state of the system. This turns out to be horribly
optimistic. If the system state is still oversaturated and the existing
workloads have all stopped using semaphores, the new workloads would
attempt to use semaphores and be deprioritised behind real work. The
new contexts would not switch off using semaphores until their initial
batch of low priority work had completed. Given sufficient backload load
of equal user priority, this would completely starve the new work of any
GPU time.

To compensate, remove the local tracking in favour of keeping it as
global state on the engine -- once the system is saturated and
semaphores are disabled, everyone stops attempting to use semaphores
until the system is idle again. One of the reason for preferring local
context tracking was that it worked with virtual engines, so for
switching to global state we could either do a complete check of all the
virtual siblings or simply disable semaphores for those requests. This
takes the simpler approach of disabling semaphores on virtual engines.

The downside is that the decision that the engine is saturated is a
local measure -- we are only checking whether or not this context was
scheduled in a timely fashion, it may be legitimately delayed due to user
priorities. We still have the same dilemma though, that we do not want
to employ the semaphore poll unless it will be used.

v2: Explain why we need to assume the worst wrt virtual engines.

Fixes: ca6e56f654e7 ("drm/i915: Disable semaphore busywaits on saturated systems")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: Dmitry Rogozhkin <dmitry.v.rogozhkin@intel.com>
Cc: Dmitry Ermilov <dmitry.ermilov@intel.com>
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190618074153.16055-8-chris@chris-wilson.co.uk
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/i915_request.c        |    4 ++--
 drivers/gpu/drm/i915/intel_context.c       |    1 -
 drivers/gpu/drm/i915/intel_context_types.h |    2 --
 drivers/gpu/drm/i915/intel_engine_cs.c     |    1 +
 drivers/gpu/drm/i915/intel_engine_types.h  |    2 ++
 5 files changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/i915/i915_request.c
+++ b/drivers/gpu/drm/i915/i915_request.c
@@ -443,7 +443,7 @@ void __i915_request_submit(struct i915_r
 	 */
 	if (request->sched.semaphores &&
 	    i915_sw_fence_signaled(&request->semaphore))
-		request->hw_context->saturated |= request->sched.semaphores;
+		engine->saturated |= request->sched.semaphores;
 
 	/* We may be recursing from the signal callback of another i915 fence */
 	spin_lock_nested(&request->lock, SINGLE_DEPTH_NESTING);
@@ -829,7 +829,7 @@ already_busywaiting(struct i915_request
 	 *
 	 * See the are-we-too-late? check in __i915_request_submit().
 	 */
-	return rq->sched.semaphores | rq->hw_context->saturated;
+	return rq->sched.semaphores | rq->engine->saturated;
 }
 
 static int
--- a/drivers/gpu/drm/i915/intel_context.c
+++ b/drivers/gpu/drm/i915/intel_context.c
@@ -230,7 +230,6 @@ intel_context_init(struct intel_context
 	ce->gem_context = ctx;
 	ce->engine = engine;
 	ce->ops = engine->cops;
-	ce->saturated = 0;
 
 	INIT_LIST_HEAD(&ce->signal_link);
 	INIT_LIST_HEAD(&ce->signals);
--- a/drivers/gpu/drm/i915/intel_context_types.h
+++ b/drivers/gpu/drm/i915/intel_context_types.h
@@ -59,8 +59,6 @@ struct intel_context {
 	atomic_t pin_count;
 	struct mutex pin_mutex; /* guards pinning and associated on-gpuing */
 
-	intel_engine_mask_t saturated; /* submitting semaphores too late? */
-
 	/**
 	 * active_tracker: Active tracker for the external rq activity
 	 * on this intel_context object.
--- a/drivers/gpu/drm/i915/intel_engine_cs.c
+++ b/drivers/gpu/drm/i915/intel_engine_cs.c
@@ -1200,6 +1200,7 @@ void intel_engines_park(struct drm_i915_
 
 		i915_gem_batch_pool_fini(&engine->batch_pool);
 		engine->execlists.no_priolist = false;
+		engine->saturated = 0;
 	}
 
 	i915->gt.active_engines = 0;
--- a/drivers/gpu/drm/i915/intel_engine_types.h
+++ b/drivers/gpu/drm/i915/intel_engine_types.h
@@ -285,6 +285,8 @@ struct intel_engine_cs {
 	struct intel_context *kernel_context; /* pinned */
 	struct intel_context *preempt_context; /* pinned; optional */
 
+	intel_engine_mask_t saturated; /* submitting semaphores too late? */
+
 	struct drm_i915_gem_object *default_state;
 	void *pinned_default_state;
 


