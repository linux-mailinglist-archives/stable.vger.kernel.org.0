Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B033F17FA13
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:02:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730421AbgCJNCd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:02:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:45426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728950AbgCJNCb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:02:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 853BF20409;
        Tue, 10 Mar 2020 13:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845350;
        bh=FTqXgDMkJbIz3f2wTc6T7PRDMjUY6JpYti4CE5nVUUA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tjda/jIGqIT0mkMAxmKPunFj1btVSX2DT4PAxP9gQVL9u1/g1xz4gV1X/+jYjVKiU
         eK4bdQ107nlyITW27AnEst2g6AoU6uCofXmTp85HO7iXbjAVPJlrQAeHwiLeF2G3tZ
         rzmdHUiIrmfL/PILrHbkcAimt1ftDu0IsXHA2Rng=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Lionel Landwerlin <lionel.g.landwerlin@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.5 150/189] drm/i915/perf: Reintroduce wait on OA configuration completion
Date:   Tue, 10 Mar 2020 13:39:47 +0100
Message-Id: <20200310123655.046462012@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123639.608886314@linuxfoundation.org>
References: <20200310123639.608886314@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 08f56f8f3799b2ed1c5ac7eed6d86a4926289655 upstream.

We still need to wait for the initial OA configuration to happen
before we enable OA report writes to the OA buffer.

Reported-by: Lionel Landwerlin <lionel.g.landwerlin@intel.com>
Fixes: 15d0ace1f876 ("drm/i915/perf: execute OA configuration from command stream")
Closes: https://gitlab.freedesktop.org/drm/intel/issues/1356
Testcase: igt/perf/stream-open-close
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Lionel Landwerlin <lionel.g.landwerlin@intel.com>
Reviewed-by: Lionel Landwerlin <lionel.g.landwerlin@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200302085812.4172450-7-chris@chris-wilson.co.uk
(cherry picked from commit 4b4e973d5eb89244b67d3223b60f752d0479f253)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_perf.c       |   58 +++++++++++++++++++++++----------
 drivers/gpu/drm/i915/i915_perf_types.h |    3 +
 2 files changed, 43 insertions(+), 18 deletions(-)

--- a/drivers/gpu/drm/i915/i915_perf.c
+++ b/drivers/gpu/drm/i915/i915_perf.c
@@ -1950,9 +1950,10 @@ out:
 	return i915_vma_get(oa_bo->vma);
 }
 
-static int emit_oa_config(struct i915_perf_stream *stream,
-			  struct i915_oa_config *oa_config,
-			  struct intel_context *ce)
+static struct i915_request *
+emit_oa_config(struct i915_perf_stream *stream,
+	       struct i915_oa_config *oa_config,
+	       struct intel_context *ce)
 {
 	struct i915_request *rq;
 	struct i915_vma *vma;
@@ -1960,7 +1961,7 @@ static int emit_oa_config(struct i915_pe
 
 	vma = get_oa_vma(stream, oa_config);
 	if (IS_ERR(vma))
-		return PTR_ERR(vma);
+		return ERR_CAST(vma);
 
 	err = i915_vma_pin(vma, 0, 0, PIN_GLOBAL | PIN_HIGH);
 	if (err)
@@ -1983,13 +1984,17 @@ static int emit_oa_config(struct i915_pe
 	err = rq->engine->emit_bb_start(rq,
 					vma->node.start, 0,
 					I915_DISPATCH_SECURE);
+	if (err)
+		goto err_add_request;
+
+	i915_request_get(rq);
 err_add_request:
 	i915_request_add(rq);
 err_vma_unpin:
 	i915_vma_unpin(vma);
 err_vma_put:
 	i915_vma_put(vma);
-	return err;
+	return err ? ERR_PTR(err) : rq;
 }
 
 static struct intel_context *oa_context(struct i915_perf_stream *stream)
@@ -1997,7 +2002,8 @@ static struct intel_context *oa_context(
 	return stream->pinned_ctx ?: stream->engine->kernel_context;
 }
 
-static int hsw_enable_metric_set(struct i915_perf_stream *stream)
+static struct i915_request *
+hsw_enable_metric_set(struct i915_perf_stream *stream)
 {
 	struct intel_uncore *uncore = stream->uncore;
 
@@ -2408,7 +2414,8 @@ static int lrc_configure_all_contexts(st
 	return oa_configure_all_contexts(stream, regs, ARRAY_SIZE(regs));
 }
 
-static int gen8_enable_metric_set(struct i915_perf_stream *stream)
+static struct i915_request *
+gen8_enable_metric_set(struct i915_perf_stream *stream)
 {
 	struct intel_uncore *uncore = stream->uncore;
 	struct i915_oa_config *oa_config = stream->oa_config;
@@ -2450,12 +2457,13 @@ static int gen8_enable_metric_set(struct
 	 */
 	ret = lrc_configure_all_contexts(stream, oa_config);
 	if (ret)
-		return ret;
+		return ERR_PTR(ret);
 
 	return emit_oa_config(stream, oa_config, oa_context(stream));
 }
 
-static int gen12_enable_metric_set(struct i915_perf_stream *stream)
+static struct i915_request *
+gen12_enable_metric_set(struct i915_perf_stream *stream)
 {
 	struct intel_uncore *uncore = stream->uncore;
 	struct i915_oa_config *oa_config = stream->oa_config;
@@ -2488,7 +2496,7 @@ static int gen12_enable_metric_set(struc
 	 */
 	ret = gen12_configure_all_contexts(stream, oa_config);
 	if (ret)
-		return ret;
+		return ERR_PTR(ret);
 
 	/*
 	 * For Gen12, performance counters are context
@@ -2498,7 +2506,7 @@ static int gen12_enable_metric_set(struc
 	if (stream->ctx) {
 		ret = gen12_configure_oar_context(stream, true);
 		if (ret)
-			return ret;
+			return ERR_PTR(ret);
 	}
 
 	return emit_oa_config(stream, oa_config, oa_context(stream));
@@ -2693,6 +2701,20 @@ static const struct i915_perf_stream_ops
 	.read = i915_oa_read,
 };
 
+static int i915_perf_stream_enable_sync(struct i915_perf_stream *stream)
+{
+	struct i915_request *rq;
+
+	rq = stream->perf->ops.enable_metric_set(stream);
+	if (IS_ERR(rq))
+		return PTR_ERR(rq);
+
+	i915_request_wait(rq, 0, MAX_SCHEDULE_TIMEOUT);
+	i915_request_put(rq);
+
+	return 0;
+}
+
 /**
  * i915_oa_stream_init - validate combined props for OA stream and init
  * @stream: An i915 perf stream
@@ -2826,7 +2848,7 @@ static int i915_oa_stream_init(struct i9
 	stream->ops = &i915_oa_stream_ops;
 	perf->exclusive_stream = stream;
 
-	ret = perf->ops.enable_metric_set(stream);
+	ret = i915_perf_stream_enable_sync(stream);
 	if (ret) {
 		DRM_DEBUG("Unable to enable metric set\n");
 		goto err_enable;
@@ -3144,7 +3166,7 @@ static long i915_perf_config_locked(stru
 		return -EINVAL;
 
 	if (config != stream->oa_config) {
-		int err;
+		struct i915_request *rq;
 
 		/*
 		 * If OA is bound to a specific context, emit the
@@ -3155,11 +3177,13 @@ static long i915_perf_config_locked(stru
 		 * When set globally, we use a low priority kernel context,
 		 * so it will effectively take effect when idle.
 		 */
-		err = emit_oa_config(stream, config, oa_context(stream));
-		if (err == 0)
+		rq = emit_oa_config(stream, config, oa_context(stream));
+		if (!IS_ERR(rq)) {
 			config = xchg(&stream->oa_config, config);
-		else
-			ret = err;
+			i915_request_put(rq);
+		} else {
+			ret = PTR_ERR(rq);
+		}
 	}
 
 	i915_oa_config_put(config);
--- a/drivers/gpu/drm/i915/i915_perf_types.h
+++ b/drivers/gpu/drm/i915/i915_perf_types.h
@@ -339,7 +339,8 @@ struct i915_oa_ops {
 	 * counter reports being sampled. May apply system constraints such as
 	 * disabling EU clock gating as required.
 	 */
-	int (*enable_metric_set)(struct i915_perf_stream *stream);
+	struct i915_request *
+		(*enable_metric_set)(struct i915_perf_stream *stream);
 
 	/**
 	 * @disable_metric_set: Remove system constraints associated with using


