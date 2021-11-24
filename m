Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A16945C60D
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:02:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347846AbhKXOFA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:05:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:48876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355803AbhKXODC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 09:03:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 946A561A85;
        Wed, 24 Nov 2021 13:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759443;
        bh=Nhv6m9EJLgrKwV0PtY41aAOJl4lGmX3GumIHb60Xyms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X+pa4yxf/0DRCQ6l6Y0bFW8jwk8ayqsJOvDieCz4WVzdNCg+o2ruORYXflnTVAJJF
         gw8clpJVsIVavorKhxIy0OPwFLiWRwtL3v1dWvWTtAvrzIEpFPlXGZGIqP5A/3oEcS
         hXmbfWdmdInlJtZO/50mDZCL73nwj84RLqBsKm38=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
        Matthew Brost <matthew.brost@intel.com>,
        John Harrison <John.C.Harrison@Intel.com>
Subject: [PATCH 5.15 244/279] drm/i915/guc: Dont drop ce->guc_active.lock when unwinding context
Date:   Wed, 24 Nov 2021 12:58:51 +0100
Message-Id: <20211124115727.156660561@linuxfoundation.org>
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

commit 88209a8ecb8b8752322908a3c3362a001bdc3a39 upstream.

Don't drop ce->guc_active.lock when unwinding a context after reset.
At one point we had to drop this because of a lock inversion but that is
no longer the case. It is much safer to hold the lock so let's do that.

Fixes: eb5e7da736f3 ("drm/i915/guc: Reset implementation for new GuC interface")
Reviewed-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210909164744.31249-5-matthew.brost@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
@@ -814,8 +814,6 @@ __unwind_incomplete_requests(struct inte
 			continue;
 
 		list_del_init(&rq->sched.link);
-		spin_unlock(&ce->guc_active.lock);
-
 		__i915_request_unsubmit(rq);
 
 		/* Push the request back into the queue for later resubmission. */
@@ -828,8 +826,6 @@ __unwind_incomplete_requests(struct inte
 
 		list_add_tail(&rq->sched.link, pl);
 		set_bit(I915_FENCE_FLAG_PQUEUE, &rq->fence.flags);
-
-		spin_lock(&ce->guc_active.lock);
 	}
 	spin_unlock(&ce->guc_active.lock);
 	spin_unlock_irqrestore(&sched_engine->lock, flags);


