Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E67C5BFF44
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 15:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbiIUNx6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 09:53:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230055AbiIUNx5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 09:53:57 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A72D9792F8
        for <stable@vger.kernel.org>; Wed, 21 Sep 2022 06:53:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663768436; x=1695304436;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=hoz1ubzM9n0gSCVaSO8Rh2hLwF+q/MmNZpaoVx+WlpI=;
  b=OUMt+PJOAQGdzvgeW/tq0itTsS01/Hd4IbRsnS6BFh4T6gd4oM7f8bfk
   HrgIP9Y/0EffKoadewaWzV2PmkJ1gWVLMjch7XuX9svEcU3/zJVw3WTA5
   I/39/0z0up7qM1lnFueGEBCoEUAzWKyHBxCY0nTXRH7GUgTffb8gD10+w
   Or4dsEncrSfG545HTHWYTNTyxeFdKc95Yfg0YhQO/LjAn4yLSek4SLDKF
   w9dH5GWAbnCTSfSwnvkv0s3WKetlfMOzIU4wnGkx0wxoMtyPo0qDV9pem
   06EHtYahwtX+w4V3S5RKOf2BNNDplQP5C1LNnuYc2VPrA0gOfawbzGHAZ
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10477"; a="280377220"
X-IronPort-AV: E=Sophos;i="5.93,333,1654585200"; 
   d="scan'208";a="280377220"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2022 06:53:56 -0700
X-IronPort-AV: E=Sophos;i="5.93,333,1654585200"; 
   d="scan'208";a="864426613"
Received: from lab-ah.igk.intel.com ([10.91.215.196])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2022 06:53:54 -0700
From:   Andrzej Hajda <andrzej.hajda@intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Chris Wilson <chris.p.wilson@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Andi Shyti <andi.shyti@linux.intel.com>,
        Andrzej Hajda <andrzej.hajda@intel.com>, stable@vger.kernel.org
Subject: [PATCH] drm/i915/gt: Restrict forced preemption to the active context
Date:   Wed, 21 Sep 2022 15:52:58 +0200
Message-Id: <20220921135258.1714873-1-andrzej.hajda@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298 Gdansk - KRS 101882 - NIP 957-07-52-316
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris.p.wilson@intel.com>

When we submit a new pair of contexts to ELSP for execution, we start a
timer by which point we expect the HW to have switched execution to the
pending contexts. If the promotion to the new pair of contexts has not
occurred, we declare the executing context to have hung and force the
preemption to take place by resetting the engine and resubmitting the
new contexts.

This can lead to an unfair situation where almost all of the preemption
timeout is consumed by the first context which just switches into the
second context immediately prior to the timer firing and triggering the
preemption reset (assuming that the timer interrupts before we process
the CS events for the context switch). The second context hasn't yet had
a chance to yield to the incoming ELSP (and send the ACk for the
promotion) and so ends up being blamed for the reset.

If we see that a context switch has occurred since setting the
preemption timeout, but have not yet received the ACK for the ELSP
promotion, rearm the preemption timer and check again. This is
especially significant if the first context was not schedulable and so
we used the shortest timer possible, greatly increasing the chance of
accidentally blaming the second innocent context.

Fixes: 3a7a92aba8fb ("drm/i915/execlists: Force preemption")
Fixes: d12acee84ffb ("drm/i915/execlists: Cancel banned contexts on schedule-out")
Reported-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: Andi Shyti <andi.shyti@linux.intel.com>
Reviewed-by: Andrzej Hajda <andrzej.hajda@intel.com>
Tested-by: Andrzej Hajda <andrzej.hajda@intel.com>
Cc: <stable@vger.kernel.org> # v5.5+
---
Hi,

This patch is upstreamed from internal branch. So I have removed
R-B by Andi. Andi let me know if your R-B still apply.

Regards
Andrzej
---
 drivers/gpu/drm/i915/gt/intel_engine_types.h  | 15 +++++++++++++
 .../drm/i915/gt/intel_execlists_submission.c  | 21 ++++++++++++++++++-
 2 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_engine_types.h b/drivers/gpu/drm/i915/gt/intel_engine_types.h
index 633a7e5dba3b4b..6b5d4ea22b673b 100644
--- a/drivers/gpu/drm/i915/gt/intel_engine_types.h
+++ b/drivers/gpu/drm/i915/gt/intel_engine_types.h
@@ -165,6 +165,21 @@ struct intel_engine_execlists {
 	 */
 	struct timer_list preempt;
 
+	/**
+	 * @preempt_target: active request at the time of the preemption request
+	 *
+	 * We force a preemption to occur if the pending contexts have not
+	 * been promoted to active upon receipt of the CS ack event within
+	 * the timeout. This timeout maybe chosen based on the target,
+	 * using a very short timeout if the context is no longer schedulable.
+	 * That short timeout may not be applicable to other contexts, so
+	 * if a context switch should happen within before the preemption
+	 * timeout, we may shoot early at an innocent context. To prevent this,
+	 * we record which context was active at the time of the preemption
+	 * request and only reset that context upon the timeout.
+	 */
+	const struct i915_request *preempt_target;
+
 	/**
 	 * @ccid: identifier for contexts submitted to this engine
 	 */
diff --git a/drivers/gpu/drm/i915/gt/intel_execlists_submission.c b/drivers/gpu/drm/i915/gt/intel_execlists_submission.c
index 4b909cb88cdfb7..c718e6dc40b515 100644
--- a/drivers/gpu/drm/i915/gt/intel_execlists_submission.c
+++ b/drivers/gpu/drm/i915/gt/intel_execlists_submission.c
@@ -1241,6 +1241,9 @@ static unsigned long active_preempt_timeout(struct intel_engine_cs *engine,
 	if (!rq)
 		return 0;
 
+	/* Only allow ourselves to force reset the currently active context */
+	engine->execlists.preempt_target = rq;
+
 	/* Force a fast reset for terminated contexts (ignoring sysfs!) */
 	if (unlikely(intel_context_is_banned(rq->context) || bad_request(rq)))
 		return INTEL_CONTEXT_BANNED_PREEMPT_TIMEOUT_MS;
@@ -2427,8 +2430,24 @@ static void execlists_submission_tasklet(struct tasklet_struct *t)
 	GEM_BUG_ON(inactive - post > ARRAY_SIZE(post));
 
 	if (unlikely(preempt_timeout(engine))) {
+		const struct i915_request *rq = *engine->execlists.active;
+
+		/*
+		 * If after the preempt-timeout expired, we are still on the
+		 * same active request/context as before we initiated the
+		 * preemption, reset the engine.
+		 *
+		 * However, if we have processed a CS event to switch contexts,
+		 * but not yet processed the CS event for the pending
+		 * preemption, reset the timer allowing the new context to
+		 * gracefully exit.
+		 */
 		cancel_timer(&engine->execlists.preempt);
-		engine->execlists.error_interrupt |= ERROR_PREEMPT;
+		if (rq == engine->execlists.preempt_target)
+			engine->execlists.error_interrupt |= ERROR_PREEMPT;
+		else
+			set_timer_ms(&engine->execlists.preempt,
+				     active_preempt_timeout(engine, rq));
 	}
 
 	if (unlikely(READ_ONCE(engine->execlists.error_interrupt))) {
-- 
2.34.1

