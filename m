Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47A5065D633
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 15:42:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239521AbjADOmD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 09:42:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239788AbjADOlo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 09:41:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 129C23D9F8
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 06:41:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B44A8B81694
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 14:41:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E23DDC433D2;
        Wed,  4 Jan 2023 14:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672843299;
        bh=kVC8+X2WmKOOnK8CGexVMeeEKto9FPGftuo/D7F9oNk=;
        h=Subject:To:Cc:From:Date:From;
        b=KX2/kElN6BaZlz4p/QzvLYRdvYV88VDE4jZnjkI5tpm5xQf+NXJeCrH6UEXMP1bmP
         aBoOmnNY4kGaiq/KoPPLGytZhmHHSqsTF9la5AD0UnA7zAWZxXtULcSHrg0cznLoDr
         vog+/zYJAPs2gOU0JZDllWnkwz5gqEHqT1bVe8Rc=
Subject: FAILED: patch "[PATCH] drm/i915/gt: Restrict forced preemption to the active context" failed to apply to 6.0-stable tree
To:     chris@chris-wilson.co.uk, andi.shyti@linux.intel.com,
        andrzej.hajda@intel.com, stable@vger.kernel.org,
        tvrtko.ursulin@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 15:41:33 +0100
Message-ID: <1672843293251148@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.0-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

107ba1a2c705 ("drm/i915/gt: Restrict forced preemption to the active context")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 107ba1a2c705f4358f2602ec2f2fd821bb651f42 Mon Sep 17 00:00:00 2001
From: Chris Wilson <chris@chris-wilson.co.uk>
Date: Wed, 21 Sep 2022 15:52:58 +0200
Subject: [PATCH] drm/i915/gt: Restrict forced preemption to the active context

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
Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220921135258.1714873-1-andrzej.hajda@intel.com

diff --git a/drivers/gpu/drm/i915/gt/intel_engine_types.h b/drivers/gpu/drm/i915/gt/intel_engine_types.h
index 633a7e5dba3b..6b5d4ea22b67 100644
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
index aab240ea1d25..428da98c5356 100644
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

