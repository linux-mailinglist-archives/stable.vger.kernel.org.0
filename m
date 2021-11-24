Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07B7945C62A
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:02:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349437AbhKXOFk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:05:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:51876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356027AbhKXOD1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 09:03:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4AE3261241;
        Wed, 24 Nov 2021 13:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759448;
        bh=OIKv9eyq5YnOjXWGc1lL+IrJ0Xkw/I4g+hcPAt/lWxc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IitQzBeCgSzj3uvF8RR3Mu9YGmq8ihNc7jLLVuae+vJG14RceeYB6GBBwhedML5Pv
         P9NOq/nPTV40ifn0a1F2n9CLbncwPlVVUbDK3V3QJi5I7bxUx4LXuKL/2KsJFIyA+r
         P2vcN8OzW9pfczUQTCea+VRxAW5RliLwAHpyHdj0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthew Brost <matthew.brost@intel.com>,
        Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
        John Harrison <John.C.Harrison@Intel.com>
Subject: [PATCH 5.15 245/279] drm/i915/guc: Unwind context requests in reverse order
Date:   Wed, 24 Nov 2021 12:58:52 +0100
Message-Id: <20211124115727.188877432@linuxfoundation.org>
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

commit c39f51cc980dd918c5b3da61d54c4725785e766e upstream.

When unwinding requests on a reset context, if other requests in the
context are in the priority list the requests could be resubmitted out
of seqno order. Traverse the list of active requests in reverse and
append to the head of the priority list to fix this.

Fixes: eb5e7da736f3 ("drm/i915/guc: Reset implementation for new GuC interface")
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210909164744.31249-4-matthew.brost@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
@@ -807,9 +807,9 @@ __unwind_incomplete_requests(struct inte
 
 	spin_lock_irqsave(&sched_engine->lock, flags);
 	spin_lock(&ce->guc_active.lock);
-	list_for_each_entry_safe(rq, rn,
-				 &ce->guc_active.requests,
-				 sched.link) {
+	list_for_each_entry_safe_reverse(rq, rn,
+					 &ce->guc_active.requests,
+					 sched.link) {
 		if (i915_request_completed(rq))
 			continue;
 
@@ -824,7 +824,7 @@ __unwind_incomplete_requests(struct inte
 		}
 		GEM_BUG_ON(i915_sched_engine_is_empty(sched_engine));
 
-		list_add_tail(&rq->sched.link, pl);
+		list_add(&rq->sched.link, pl);
 		set_bit(I915_FENCE_FLAG_PQUEUE, &rq->fence.flags);
 	}
 	spin_unlock(&ce->guc_active.lock);


