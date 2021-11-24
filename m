Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BC4D45C60C
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:02:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347765AbhKXOE7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:04:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:51224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355637AbhKXODC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 09:03:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9CC5863307;
        Wed, 24 Nov 2021 13:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759440;
        bh=K2qaNJ5FeRn//q+1kSIzHb+F+d0uGdwhzvYCs5PiHYU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GFgQJv/o7kPWzhR73sqrckXskZXKbrygxhrqUhL1kJu/X5X+F9DIscuvUzS2LR1RO
         G+rc3mpQsx+iyOMI6kBNpR4lPyXCuNhcDjdbZcharPzVGGbqFJaheUBBDeGgDViSEn
         PlQ4XoU/JKBG0HT3gwS8Z9XSbFV58Aes0LNm4mK0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthew Brost <matthew.brost@intel.com>,
        Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
        John Harrison <John.C.Harrison@Intel.com>
Subject: [PATCH 5.15 243/279] drm/i915/guc: Workaround reset G2H is received after schedule done G2H
Date:   Wed, 24 Nov 2021 12:58:50 +0100
Message-Id: <20211124115727.126490625@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Brost <matthew.brost@intel.com>

commit 1ca36cff0166b0483fe3b99e711e9c800ebbfaa4 upstream.

If the context is reset as a result of the request cancellation the
context reset G2H is received after schedule disable done G2H which is
the wrong order. The schedule disable done G2H release the waiting
request cancellation code which resubmits the context. This races
with the context reset G2H which also wants to resubmit the context but
in this case it really should be a NOP as request cancellation code owns
the resubmit. Use some clever tricks of checking the context state to
seal this race until the GuC firmware is fixed.

v2:
 (Checkpatch)
  - Fix typos
v3:
 (Daniele)
  - State that is a bug in the GuC firmware

Fixes: 62eaf0ae217d ("drm/i915/guc: Support request cancellation")
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Cc: <stable@vger.kernel.org>
Reviewed-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210909164744.31249-7-matthew.brost@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c |   41 ++++++++++++++++++----
 1 file changed, 35 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
@@ -838,17 +838,33 @@ __unwind_incomplete_requests(struct inte
 static void __guc_reset_context(struct intel_context *ce, bool stalled)
 {
 	struct i915_request *rq;
+	unsigned long flags;
 	u32 head;
+	bool skip = false;
 
 	intel_context_get(ce);
 
 	/*
-	 * GuC will implicitly mark the context as non-schedulable
-	 * when it sends the reset notification. Make sure our state
-	 * reflects this change. The context will be marked enabled
-	 * on resubmission.
+	 * GuC will implicitly mark the context as non-schedulable when it sends
+	 * the reset notification. Make sure our state reflects this change. The
+	 * context will be marked enabled on resubmission.
+	 *
+	 * XXX: If the context is reset as a result of the request cancellation
+	 * this G2H is received after the schedule disable complete G2H which is
+	 * wrong as this creates a race between the request cancellation code
+	 * re-submitting the context and this G2H handler. This is a bug in the
+	 * GuC but can be worked around in the meantime but converting this to a
+	 * NOP if a pending enable is in flight as this indicates that a request
+	 * cancellation has occurred.
 	 */
-	clr_context_enabled(ce);
+	spin_lock_irqsave(&ce->guc_state.lock, flags);
+	if (likely(!context_pending_enable(ce)))
+		clr_context_enabled(ce);
+	else
+		skip = true;
+	spin_unlock_irqrestore(&ce->guc_state.lock, flags);
+	if (unlikely(skip))
+		goto out_put;
 
 	rq = intel_context_find_active_request(ce);
 	if (!rq) {
@@ -867,6 +883,7 @@ static void __guc_reset_context(struct i
 out_replay:
 	guc_reset_state(ce, head, stalled);
 	__unwind_incomplete_requests(ce);
+out_put:
 	intel_context_put(ce);
 }
 
@@ -1618,6 +1635,13 @@ static void guc_context_cancel_request(s
 			guc_reset_state(ce, intel_ring_wrap(ce->ring, rq->head),
 					true);
 		}
+
+		/*
+		 * XXX: Racey if context is reset, see comment in
+		 * __guc_reset_context().
+		 */
+		flush_work(&ce_to_guc(ce)->ct.requests.worker);
+
 		guc_context_unblock(ce);
 	}
 }
@@ -2732,7 +2756,12 @@ static void guc_handle_context_reset(str
 {
 	trace_intel_context_reset(ce);
 
-	if (likely(!intel_context_is_banned(ce))) {
+	/*
+	 * XXX: Racey if request cancellation has occurred, see comment in
+	 * __guc_reset_context().
+	 */
+	if (likely(!intel_context_is_banned(ce) &&
+		   !context_blocked(ce))) {
 		capture_error_state(guc, ce);
 		guc_context_replay(ce);
 	}


