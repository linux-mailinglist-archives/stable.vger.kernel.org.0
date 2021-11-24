Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB1DC45C60B
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:02:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347758AbhKXOE7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:04:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:48872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355536AbhKXOCy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 09:02:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB02B61A7A;
        Wed, 24 Nov 2021 13:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759437;
        bh=hQbeQq1y1SeK6kG+T2TDb8zAV2gmVoot5ZO4sSN0les=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jyyNEngcDbv86Av3lFhN0DPTIaAgp3kXkCZe8Tbo3deRSqTh41o/pV1T2pz8HOVga
         ml1rjUot5yKBB+8xZYpGz9xrHXKkzkn0V41HyfICDW/L9IK1mAL9sNVo6hxsOwHYlh
         7y438SftA5vB0F01yvtXcSlt6WbKXekSQNTIT7qc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthew Brost <matthew.brost@intel.com>,
        Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
        John Harrison <John.C.Harrison@Intel.com>
Subject: [PATCH 5.15 242/279] drm/i915/guc: Dont enable scheduling on a banned context, guc_id invalid, not registered
Date:   Wed, 24 Nov 2021 12:58:49 +0100
Message-Id: <20211124115727.087701528@linuxfoundation.org>
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

commit 9888beaaf118b6878347e1fe2b369fc66d756d18 upstream.

When unblocking a context, do not enable scheduling if the context is
banned, guc_id invalid, or not registered.

v2:
 (Daniele)
  - Add helper for unblock

Fixes: 62eaf0ae217d ("drm/i915/guc: Support request cancellation")
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210909164744.31249-10-matthew.brost@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c |   22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
@@ -148,6 +148,7 @@ static inline void clr_context_registere
 #define SCHED_STATE_BLOCKED_SHIFT			4
 #define SCHED_STATE_BLOCKED		BIT(SCHED_STATE_BLOCKED_SHIFT)
 #define SCHED_STATE_BLOCKED_MASK	(0xfff << SCHED_STATE_BLOCKED_SHIFT)
+
 static inline void init_sched_state(struct intel_context *ce)
 {
 	/* Only should be called from guc_lrc_desc_pin() */
@@ -1549,6 +1550,23 @@ static struct i915_sw_fence *guc_context
 	return &ce->guc_blocked;
 }
 
+#define SCHED_STATE_MULTI_BLOCKED_MASK \
+	(SCHED_STATE_BLOCKED_MASK & ~SCHED_STATE_BLOCKED)
+#define SCHED_STATE_NO_UNBLOCK \
+	(SCHED_STATE_MULTI_BLOCKED_MASK | \
+	 SCHED_STATE_PENDING_DISABLE | \
+	 SCHED_STATE_BANNED)
+
+static bool context_cant_unblock(struct intel_context *ce)
+{
+	lockdep_assert_held(&ce->guc_state.lock);
+
+	return (ce->guc_state.sched_state & SCHED_STATE_NO_UNBLOCK) ||
+		context_guc_id_invalid(ce) ||
+		!lrc_desc_registered(ce_to_guc(ce), ce->guc_id) ||
+		!intel_context_is_pinned(ce);
+}
+
 static void guc_context_unblock(struct intel_context *ce)
 {
 	struct intel_guc *guc = ce_to_guc(ce);
@@ -1563,9 +1581,7 @@ static void guc_context_unblock(struct i
 	spin_lock_irqsave(&ce->guc_state.lock, flags);
 
 	if (unlikely(submission_disabled(guc) ||
-		     !intel_context_is_pinned(ce) ||
-		     context_pending_disable(ce) ||
-		     context_blocked(ce) > 1)) {
+		     context_cant_unblock(ce))) {
 		enable = false;
 	} else {
 		enable = true;


