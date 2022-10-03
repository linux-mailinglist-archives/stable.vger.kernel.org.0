Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FAF35F29D1
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbiJCHZg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:25:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230492AbiJCHXq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:23:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14E5346224;
        Mon,  3 Oct 2022 00:17:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C9B4C60FAF;
        Mon,  3 Oct 2022 07:17:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7AFFC433C1;
        Mon,  3 Oct 2022 07:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781448;
        bh=L6PUVAwizPyx4YMe0PQv6L4vBKBX2k7yjtIKYhvrJlw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JF8Uo0YxguSWNJa30GO+pCZTLls/iswh8Mr6h6BfGAEQlnEa2wHOT32vf7rnSRQIN
         abQ6lHiqa0i08K/s9ETz4l+0e8kNGyRVO9ofmPDHra9LiUSAs7zgGpcFcfVWVcH6m8
         RrXZrk9QsxF520AQn3Rfzd9cblf5768xG78nvRso=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Andi Shyti <andi.shyti@linux.intel.com>,
        Andrzej Hajda <andrzej.hajda@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.15 23/83] drm/i915/gt: Restrict forced preemption to the active context
Date:   Mon,  3 Oct 2022 09:10:48 +0200
Message-Id: <20221003070722.573308617@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070721.971297651@linuxfoundation.org>
References: <20221003070721.971297651@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 6ef7d362123ecb5bf6d163bb9c7fd6ba2d8c968c upstream.

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
(cherry picked from commit 107ba1a2c705f4358f2602ec2f2fd821bb651f42)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gt/intel_engine_types.h         |   15 +++++++++++++
 drivers/gpu/drm/i915/gt/intel_execlists_submission.c |   21 ++++++++++++++++++-
 2 files changed, 35 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/gt/intel_engine_types.h
+++ b/drivers/gpu/drm/i915/gt/intel_engine_types.h
@@ -144,6 +144,21 @@ struct intel_engine_execlists {
 	struct timer_list preempt;
 
 	/**
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
+	/**
 	 * @ccid: identifier for contexts submitted to this engine
 	 */
 	u32 ccid;
--- a/drivers/gpu/drm/i915/gt/intel_execlists_submission.c
+++ b/drivers/gpu/drm/i915/gt/intel_execlists_submission.c
@@ -1225,6 +1225,9 @@ static unsigned long active_preempt_time
 	if (!rq)
 		return 0;
 
+	/* Only allow ourselves to force reset the currently active context */
+	engine->execlists.preempt_target = rq;
+
 	/* Force a fast reset for terminated contexts (ignoring sysfs!) */
 	if (unlikely(intel_context_is_banned(rq->context) || bad_request(rq)))
 		return 1;
@@ -2401,8 +2404,24 @@ static void execlists_submission_tasklet
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


