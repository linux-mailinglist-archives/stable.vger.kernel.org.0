Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C85011A68DC
	for <lists+stable@lfdr.de>; Mon, 13 Apr 2020 17:29:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730342AbgDMP3e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Apr 2020 11:29:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730336AbgDMP3d (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Apr 2020 11:29:33 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BAEAC0A3BDC
        for <stable@vger.kernel.org>; Mon, 13 Apr 2020 08:29:33 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id r14so4615333pfl.12
        for <stable@vger.kernel.org>; Mon, 13 Apr 2020 08:29:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=L37ULc8e3vMUIfIvndWBkbjcG9etcM5/MjCUH44A8Kw=;
        b=fHzLUbt5hGWOdH2bnGwrU+GiDe3GRm5BTKasiQs5qpztDGiBPGKUUqF6PiuAoHEL2h
         R4IasFljtCq7UGGwQB6lgfpf/Iuce3hXOfiNaa48e7c461GsbFqj2D6XshpCCvZDvobs
         zHz0kHT8pIgcXvgrQ54hW8IeIHyNB+SMfmFUcJt2VxmkXTmp9h34PbC6QgYyxo+K7vFc
         3RuRENtBxvLxSB37sAhAqwO2rmvM5kyjXXpDbFEouFE795Rr2zd8s+W1LG4iTM9pNjrj
         9idq0PGaZ9S8EdAuH3o92Tu1Nk7kXBWhhMVsbOthTMZpxTyWaOCcfYWySGulL6tt3ZHG
         fN0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=L37ULc8e3vMUIfIvndWBkbjcG9etcM5/MjCUH44A8Kw=;
        b=TneIyTBIOx9E/BULXs9Gt+QKob/xxy+2qGgnmzerpmWLIMVTkb8bkW7Jf8C0yD565r
         Qly4kyyltiJ+cYl0BUkD0bisdBmwxGwvoU6mcMvEJOFe0pzBeaL1Z58iROYW/UCILMNT
         aAlht7Ae3Fxqq9BQvGhcHT0VJZb+u9D2cheHT5t89Ipaw/I4CT96yyNZY6jOHi+GASkX
         CvhIPLwDnzKtWoz3nOpBqAtSz9W0IKZYJDcqCQDXJwwlN47CX15oKOLNtfxGucyXOEk1
         yyp8TCA4HP06I8YfuvpoX6/SzJUMQNX0kGi+/UZYgQ1h8KufXSa7NhSA/7f3CW75CxV/
         et3A==
X-Gm-Message-State: AGi0Puat6lzQ50klokrWSvA1pgp4dQVLwg6wGwSi+qJt7GRq/GX1vqZK
        vi7IoH0LoVIOG8Ovw0tgDZ0H/RZU
X-Google-Smtp-Source: APiQypIR76sWNFQ3e/Akruzd0Y094AViMcJqjXNzLbxTaYN27kkPq+JLAdIDHVySBdVQx+W8Ho3AsQ==
X-Received: by 2002:a63:d013:: with SMTP id z19mr18422702pgf.349.1586791772797;
        Mon, 13 Apr 2020 08:29:32 -0700 (PDT)
Received: from sultan-box.localdomain (static-198-54-129-52.cust.tzulo.com. [198.54.129.52])
        by smtp.gmail.com with ESMTPSA id b11sm8078712pgj.92.2020.04.13.08.29.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2020 08:29:32 -0700 (PDT)
From:   Sultan Alsawaf <sultan@kerneltoast.com>
X-Google-Original-From: Sultan Alsawaf
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org
Subject: [PATCH v3] drm/i915/gt: Schedule request retirement when timeline idles
Date:   Mon, 13 Apr 2020 08:29:30 -0700
Message-Id: <20200413152930.2930-1-sultan@kerneltoast.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200413152344.GA2300@sultan-box.localdomain>
References: <20200413152344.GA2300@sultan-box.localdomain>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 4f88f8747fa43c97c3b3712d8d87295ea757cc51 upstream.

The major drawback of commit 7e34f4e4aad3 ("drm/i915/gen8+: Add RC6 CTX
corruption WA") is that it disables RC6 while Skylake (and friends) is
active, and we do not consider the GPU idle until all outstanding
requests have been retired and the engine switched over to the kernel
context. If userspace is idle, this task falls onto our background idle
worker, which only runs roughly once a second, meaning that userspace has
to have been idle for a couple of seconds before we enable RC6 again.
Naturally, this causes us to consume considerably more energy than
before as powersaving is effectively disabled while a display server
(here's looking at you Xorg) is running.

As execlists will get a completion event as each context is completed,
we can use this interrupt to queue a retire worker bound to this engine
to cleanup idle timelines. We will then immediately notice the idle
engine (without userspace intervention or the aid of the background
retire worker) and start parking the GPU. Thus during light workloads,
we will do much more work to idle the GPU faster...  Hopefully with
commensurate power saving!

v2: Watch context completions and only look at those local to the engine
when retiring to reduce the amount of excess work we perform.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=112315
References: 7e34f4e4aad3 ("drm/i915/gen8+: Add RC6 CTX corruption WA")
References: 2248a28384fe ("drm/i915/gen8+: Add RC6 CTX corruption WA")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20191125105858.1718307-3-chris@chris-wilson.co.uk
[Sultan: for the backport to 5.4, struct_mutex needs to be held while
 retiring so that retirement doesn't race with vma destruction.]
Signed-off-by: Sultan Alsawaf <sultan@kerneltoast.com>
---
 drivers/gpu/drm/i915/gt/intel_engine_cs.c     |  2 +
 drivers/gpu/drm/i915/gt/intel_engine_types.h  |  8 ++
 drivers/gpu/drm/i915/gt/intel_lrc.c           |  8 ++
 drivers/gpu/drm/i915/gt/intel_timeline.c      |  1 +
 .../gpu/drm/i915/gt/intel_timeline_types.h    |  3 +
 drivers/gpu/drm/i915/i915_request.c           | 75 +++++++++++++++++++
 drivers/gpu/drm/i915/i915_request.h           |  4 +
 7 files changed, 101 insertions(+)

diff --git a/drivers/gpu/drm/i915/gt/intel_engine_cs.c b/drivers/gpu/drm/i915/gt/intel_engine_cs.c
index 4ce8626b140e..f732a2177cd0 100644
--- a/drivers/gpu/drm/i915/gt/intel_engine_cs.c
+++ b/drivers/gpu/drm/i915/gt/intel_engine_cs.c
@@ -600,6 +600,7 @@ static int intel_engine_setup_common(struct intel_engine_cs *engine)
 	intel_engine_init_hangcheck(engine);
 	intel_engine_init_cmd_parser(engine);
 	intel_engine_init__pm(engine);
+	intel_engine_init_retire(engine);
 
 	intel_engine_pool_init(&engine->pool);
 
@@ -807,6 +808,7 @@ void intel_engine_cleanup_common(struct intel_engine_cs *engine)
 
 	cleanup_status_page(engine);
 
+	intel_engine_fini_retire(engine);
 	intel_engine_pool_fini(&engine->pool);
 	intel_engine_fini_breadcrumbs(engine);
 	intel_engine_cleanup_cmd_parser(engine);
diff --git a/drivers/gpu/drm/i915/gt/intel_engine_types.h b/drivers/gpu/drm/i915/gt/intel_engine_types.h
index c77c9518c58b..1eb7189f88e1 100644
--- a/drivers/gpu/drm/i915/gt/intel_engine_types.h
+++ b/drivers/gpu/drm/i915/gt/intel_engine_types.h
@@ -471,6 +471,14 @@ struct intel_engine_cs {
 
 	struct intel_engine_execlists execlists;
 
+	/*
+	 * Keep track of completed timelines on this engine for early
+	 * retirement with the goal of quickly enabling powersaving as
+	 * soon as the engine is idle.
+	 */
+	struct intel_timeline *retire;
+	struct work_struct retire_work;
+
 	/* status_notifier: list of callbacks for context-switch changes */
 	struct atomic_notifier_head context_status_notifier;
 
diff --git a/drivers/gpu/drm/i915/gt/intel_lrc.c b/drivers/gpu/drm/i915/gt/intel_lrc.c
index 66f6d1a897f2..a1538c8f7922 100644
--- a/drivers/gpu/drm/i915/gt/intel_lrc.c
+++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
@@ -606,6 +606,14 @@ __execlists_schedule_out(struct i915_request *rq,
 {
 	struct intel_context * const ce = rq->hw_context;
 
+	/*
+	 * If we have just completed this context, the engine may now be
+	 * idle and we want to re-enter powersaving.
+	 */
+	if (list_is_last(&rq->link, &ce->timeline->requests) &&
+	    i915_request_completed(rq))
+		intel_engine_add_retire(engine, ce->timeline);
+
 	intel_engine_context_out(engine);
 	execlists_context_status_change(rq, INTEL_CONTEXT_SCHEDULE_OUT);
 	intel_gt_pm_put(engine->gt);
diff --git a/drivers/gpu/drm/i915/gt/intel_timeline.c b/drivers/gpu/drm/i915/gt/intel_timeline.c
index 9cb01d9828f1..63515e3caaf2 100644
--- a/drivers/gpu/drm/i915/gt/intel_timeline.c
+++ b/drivers/gpu/drm/i915/gt/intel_timeline.c
@@ -282,6 +282,7 @@ void intel_timeline_fini(struct intel_timeline *timeline)
 {
 	GEM_BUG_ON(atomic_read(&timeline->pin_count));
 	GEM_BUG_ON(!list_empty(&timeline->requests));
+	GEM_BUG_ON(timeline->retire);
 
 	if (timeline->hwsp_cacheline)
 		cacheline_free(timeline->hwsp_cacheline);
diff --git a/drivers/gpu/drm/i915/gt/intel_timeline_types.h b/drivers/gpu/drm/i915/gt/intel_timeline_types.h
index 2b1baf2fcc8e..adf2d14ef647 100644
--- a/drivers/gpu/drm/i915/gt/intel_timeline_types.h
+++ b/drivers/gpu/drm/i915/gt/intel_timeline_types.h
@@ -65,6 +65,9 @@ struct intel_timeline {
 	 */
 	struct i915_active_request last_request;
 
+	/** A chain of completed timelines ready for early retirement. */
+	struct intel_timeline *retire;
+
 	/**
 	 * We track the most recent seqno that we wait on in every context so
 	 * that we only have to emit a new await and dependency on a more
diff --git a/drivers/gpu/drm/i915/i915_request.c b/drivers/gpu/drm/i915/i915_request.c
index 0d39038898d4..35457fda350c 100644
--- a/drivers/gpu/drm/i915/i915_request.c
+++ b/drivers/gpu/drm/i915/i915_request.c
@@ -600,6 +600,81 @@ static void retire_requests(struct intel_timeline *tl)
 			break;
 }
 
+static void engine_retire(struct work_struct *work)
+{
+	struct intel_engine_cs *engine =
+		container_of(work, typeof(*engine), retire_work);
+	struct intel_timeline *tl = xchg(&engine->retire, NULL);
+
+	do {
+		struct intel_timeline *next = xchg(&tl->retire, NULL);
+
+		/*
+		 * Our goal here is to retire _idle_ timelines as soon as
+		 * possible (as they are idle, we do not expect userspace
+		 * to be cleaning up anytime soon).
+		 *
+		 * If the timeline is currently locked, either it is being
+		 * retired elsewhere or about to be!
+		 */
+		mutex_lock(&engine->i915->drm.struct_mutex);
+		if (mutex_trylock(&tl->mutex)) {
+			retire_requests(tl);
+			mutex_unlock(&tl->mutex);
+		}
+		mutex_unlock(&engine->i915->drm.struct_mutex);
+		intel_timeline_put(tl);
+
+		GEM_BUG_ON(!next);
+		tl = ptr_mask_bits(next, 1);
+	} while (tl);
+}
+
+static bool add_retire(struct intel_engine_cs *engine,
+		       struct intel_timeline *tl)
+{
+	struct intel_timeline *first;
+
+	/*
+	 * We open-code a llist here to include the additional tag [BIT(0)]
+	 * so that we know when the timeline is already on a
+	 * retirement queue: either this engine or another.
+	 *
+	 * However, we rely on that a timeline can only be active on a single
+	 * engine at any one time and that add_retire() is called before the
+	 * engine releases the timeline and transferred to another to retire.
+	 */
+
+	if (READ_ONCE(tl->retire)) /* already queued */
+		return false;
+
+	intel_timeline_get(tl);
+	first = READ_ONCE(engine->retire);
+	do
+		tl->retire = ptr_pack_bits(first, 1, 1);
+	while (!try_cmpxchg(&engine->retire, &first, tl));
+
+	return !first;
+}
+
+void intel_engine_add_retire(struct intel_engine_cs *engine,
+			     struct intel_timeline *tl)
+{
+	if (add_retire(engine, tl))
+		schedule_work(&engine->retire_work);
+}
+
+void intel_engine_init_retire(struct intel_engine_cs *engine)
+{
+	INIT_WORK(&engine->retire_work, engine_retire);
+}
+
+void intel_engine_fini_retire(struct intel_engine_cs *engine)
+{
+	flush_work(&engine->retire_work);
+	GEM_BUG_ON(engine->retire);
+}
+
 static noinline struct i915_request *
 request_alloc_slow(struct intel_timeline *tl, gfp_t gfp)
 {
diff --git a/drivers/gpu/drm/i915/i915_request.h b/drivers/gpu/drm/i915/i915_request.h
index 3a3e7bbf19ff..40caa2f3f4a4 100644
--- a/drivers/gpu/drm/i915/i915_request.h
+++ b/drivers/gpu/drm/i915/i915_request.h
@@ -445,5 +445,9 @@ static inline bool i915_request_has_nopreempt(const struct i915_request *rq)
 }
 
 bool i915_retire_requests(struct drm_i915_private *i915);
+void intel_engine_init_retire(struct intel_engine_cs *engine);
+void intel_engine_add_retire(struct intel_engine_cs *engine,
+			     struct intel_timeline *tl);
+void intel_engine_fini_retire(struct intel_engine_cs *engine);
 
 #endif /* I915_REQUEST_H */
-- 
2.26.0

