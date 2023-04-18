Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60F896E6354
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:39:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231825AbjDRMjm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:39:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231827AbjDRMjl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:39:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E292E4699
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:39:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7418D632F9
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:39:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81B4FC4339E;
        Tue, 18 Apr 2023 12:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821578;
        bh=o5GCy2cAMELG+19bVZcwP/A+sF5XSDqbGo3jNeEgsl4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jBQ8W2htp0QF2bGl/i/FrpmLeT/r5L1gZYpbysTyCbPLlVH0AgMpmxxR972bzgD2m
         YWA4hHjcjowzN2VG/DX9lr/tgAFHcAX10PTwp45AOSrJ1DZlbveGhbQAg4BQ57SbhJ
         oKE59Y2oZFYXmEHsT5SvuMNTELdVkPw78UiN2RLM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
        Lionel Landwerlin <lionel.g.landwerlin@intel.com>,
        Andrzej Hajda <andrzej.hajda@intel.com>,
        Matt Roper <matthew.d.roper@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 55/91] i915/perf: Replace DRM_DEBUG with driver specific drm_dbg call
Date:   Tue, 18 Apr 2023 14:21:59 +0200
Message-Id: <20230418120307.516989549@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120305.520719816@linuxfoundation.org>
References: <20230418120305.520719816@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>

[ Upstream commit 2fec539112e89255b6a47f566e21d99937fada7b ]

DRM_DEBUG is not the right debug call to use in i915 OA, replace it with
driver specific drm_dbg() call (Matt).

Signed-off-by: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Acked-by: Lionel Landwerlin <lionel.g.landwerlin@intel.com>
Reviewed-by: Andrzej Hajda <andrzej.hajda@intel.com>
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220707193002.2859653-1-umesh.nerlige.ramappa@intel.com
Stable-dep-of: dc30c0114691 ("drm/i915: fix race condition UAF in i915_perf_add_config_ioctl")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/i915_perf.c | 151 ++++++++++++++++++++-----------
 1 file changed, 100 insertions(+), 51 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_perf.c b/drivers/gpu/drm/i915/i915_perf.c
index f3c8f87d25ae0..4b57cc10bd68e 100644
--- a/drivers/gpu/drm/i915/i915_perf.c
+++ b/drivers/gpu/drm/i915/i915_perf.c
@@ -879,8 +879,9 @@ static int gen8_oa_read(struct i915_perf_stream *stream,
 		if (ret)
 			return ret;
 
-		DRM_DEBUG("OA buffer overflow (exponent = %d): force restart\n",
-			  stream->period_exponent);
+		drm_dbg(&stream->perf->i915->drm,
+			"OA buffer overflow (exponent = %d): force restart\n",
+			stream->period_exponent);
 
 		stream->perf->ops.oa_disable(stream);
 		stream->perf->ops.oa_enable(stream);
@@ -1102,8 +1103,9 @@ static int gen7_oa_read(struct i915_perf_stream *stream,
 		if (ret)
 			return ret;
 
-		DRM_DEBUG("OA buffer overflow (exponent = %d): force restart\n",
-			  stream->period_exponent);
+		drm_dbg(&stream->perf->i915->drm,
+			"OA buffer overflow (exponent = %d): force restart\n",
+			stream->period_exponent);
 
 		stream->perf->ops.oa_disable(stream);
 		stream->perf->ops.oa_enable(stream);
@@ -2857,7 +2859,8 @@ static int i915_oa_stream_init(struct i915_perf_stream *stream,
 	int ret;
 
 	if (!props->engine) {
-		DRM_DEBUG("OA engine not specified\n");
+		drm_dbg(&stream->perf->i915->drm,
+			"OA engine not specified\n");
 		return -EINVAL;
 	}
 
@@ -2867,18 +2870,21 @@ static int i915_oa_stream_init(struct i915_perf_stream *stream,
 	 * IDs
 	 */
 	if (!perf->metrics_kobj) {
-		DRM_DEBUG("OA metrics weren't advertised via sysfs\n");
+		drm_dbg(&stream->perf->i915->drm,
+			"OA metrics weren't advertised via sysfs\n");
 		return -EINVAL;
 	}
 
 	if (!(props->sample_flags & SAMPLE_OA_REPORT) &&
 	    (GRAPHICS_VER(perf->i915) < 12 || !stream->ctx)) {
-		DRM_DEBUG("Only OA report sampling supported\n");
+		drm_dbg(&stream->perf->i915->drm,
+			"Only OA report sampling supported\n");
 		return -EINVAL;
 	}
 
 	if (!perf->ops.enable_metric_set) {
-		DRM_DEBUG("OA unit not supported\n");
+		drm_dbg(&stream->perf->i915->drm,
+			"OA unit not supported\n");
 		return -ENODEV;
 	}
 
@@ -2888,12 +2894,14 @@ static int i915_oa_stream_init(struct i915_perf_stream *stream,
 	 * we currently only allow exclusive access
 	 */
 	if (perf->exclusive_stream) {
-		DRM_DEBUG("OA unit already in use\n");
+		drm_dbg(&stream->perf->i915->drm,
+			"OA unit already in use\n");
 		return -EBUSY;
 	}
 
 	if (!props->oa_format) {
-		DRM_DEBUG("OA report format not specified\n");
+		drm_dbg(&stream->perf->i915->drm,
+			"OA report format not specified\n");
 		return -EINVAL;
 	}
 
@@ -2923,20 +2931,23 @@ static int i915_oa_stream_init(struct i915_perf_stream *stream,
 	if (stream->ctx) {
 		ret = oa_get_render_ctx_id(stream);
 		if (ret) {
-			DRM_DEBUG("Invalid context id to filter with\n");
+			drm_dbg(&stream->perf->i915->drm,
+				"Invalid context id to filter with\n");
 			return ret;
 		}
 	}
 
 	ret = alloc_noa_wait(stream);
 	if (ret) {
-		DRM_DEBUG("Unable to allocate NOA wait batch buffer\n");
+		drm_dbg(&stream->perf->i915->drm,
+			"Unable to allocate NOA wait batch buffer\n");
 		goto err_noa_wait_alloc;
 	}
 
 	stream->oa_config = i915_perf_get_oa_config(perf, props->metrics_set);
 	if (!stream->oa_config) {
-		DRM_DEBUG("Invalid OA config id=%i\n", props->metrics_set);
+		drm_dbg(&stream->perf->i915->drm,
+			"Invalid OA config id=%i\n", props->metrics_set);
 		ret = -EINVAL;
 		goto err_config;
 	}
@@ -2967,11 +2978,13 @@ static int i915_oa_stream_init(struct i915_perf_stream *stream,
 
 	ret = i915_perf_stream_enable_sync(stream);
 	if (ret) {
-		DRM_DEBUG("Unable to enable metric set\n");
+		drm_dbg(&stream->perf->i915->drm,
+			"Unable to enable metric set\n");
 		goto err_enable;
 	}
 
-	DRM_DEBUG("opening stream oa config uuid=%s\n",
+	drm_dbg(&stream->perf->i915->drm,
+		"opening stream oa config uuid=%s\n",
 		  stream->oa_config->uuid);
 
 	hrtimer_init(&stream->poll_check_timer,
@@ -3423,7 +3436,8 @@ i915_perf_open_ioctl_locked(struct i915_perf *perf,
 
 		specific_ctx = i915_gem_context_lookup(file_priv, ctx_handle);
 		if (IS_ERR(specific_ctx)) {
-			DRM_DEBUG("Failed to look up context with ID %u for opening perf stream\n",
+			drm_dbg(&perf->i915->drm,
+				"Failed to look up context with ID %u for opening perf stream\n",
 				  ctx_handle);
 			ret = PTR_ERR(specific_ctx);
 			goto err;
@@ -3457,7 +3471,8 @@ i915_perf_open_ioctl_locked(struct i915_perf *perf,
 
 	if (props->hold_preemption) {
 		if (!props->single_context) {
-			DRM_DEBUG("preemption disable with no context\n");
+			drm_dbg(&perf->i915->drm,
+				"preemption disable with no context\n");
 			ret = -EINVAL;
 			goto err;
 		}
@@ -3479,7 +3494,8 @@ i915_perf_open_ioctl_locked(struct i915_perf *perf,
 	 */
 	if (privileged_op &&
 	    i915_perf_stream_paranoid && !perfmon_capable()) {
-		DRM_DEBUG("Insufficient privileges to open i915 perf stream\n");
+		drm_dbg(&perf->i915->drm,
+			"Insufficient privileges to open i915 perf stream\n");
 		ret = -EACCES;
 		goto err_ctx;
 	}
@@ -3586,7 +3602,8 @@ static int read_properties_unlocked(struct i915_perf *perf,
 	props->poll_oa_period = DEFAULT_POLL_PERIOD_NS;
 
 	if (!n_props) {
-		DRM_DEBUG("No i915 perf properties given\n");
+		drm_dbg(&perf->i915->drm,
+			"No i915 perf properties given\n");
 		return -EINVAL;
 	}
 
@@ -3595,7 +3612,8 @@ static int read_properties_unlocked(struct i915_perf *perf,
 						 I915_ENGINE_CLASS_RENDER,
 						 0);
 	if (!props->engine) {
-		DRM_DEBUG("No RENDER-capable engines\n");
+		drm_dbg(&perf->i915->drm,
+			"No RENDER-capable engines\n");
 		return -EINVAL;
 	}
 
@@ -3606,7 +3624,8 @@ static int read_properties_unlocked(struct i915_perf *perf,
 	 * from userspace.
 	 */
 	if (n_props >= DRM_I915_PERF_PROP_MAX) {
-		DRM_DEBUG("More i915 perf properties specified than exist\n");
+		drm_dbg(&perf->i915->drm,
+			"More i915 perf properties specified than exist\n");
 		return -EINVAL;
 	}
 
@@ -3623,7 +3642,8 @@ static int read_properties_unlocked(struct i915_perf *perf,
 			return ret;
 
 		if (id == 0 || id >= DRM_I915_PERF_PROP_MAX) {
-			DRM_DEBUG("Unknown i915 perf property ID\n");
+			drm_dbg(&perf->i915->drm,
+				"Unknown i915 perf property ID\n");
 			return -EINVAL;
 		}
 
@@ -3638,19 +3658,22 @@ static int read_properties_unlocked(struct i915_perf *perf,
 			break;
 		case DRM_I915_PERF_PROP_OA_METRICS_SET:
 			if (value == 0) {
-				DRM_DEBUG("Unknown OA metric set ID\n");
+				drm_dbg(&perf->i915->drm,
+					"Unknown OA metric set ID\n");
 				return -EINVAL;
 			}
 			props->metrics_set = value;
 			break;
 		case DRM_I915_PERF_PROP_OA_FORMAT:
 			if (value == 0 || value >= I915_OA_FORMAT_MAX) {
-				DRM_DEBUG("Out-of-range OA report format %llu\n",
+				drm_dbg(&perf->i915->drm,
+					"Out-of-range OA report format %llu\n",
 					  value);
 				return -EINVAL;
 			}
 			if (!oa_format_valid(perf, value)) {
-				DRM_DEBUG("Unsupported OA report format %llu\n",
+				drm_dbg(&perf->i915->drm,
+					"Unsupported OA report format %llu\n",
 					  value);
 				return -EINVAL;
 			}
@@ -3658,7 +3681,8 @@ static int read_properties_unlocked(struct i915_perf *perf,
 			break;
 		case DRM_I915_PERF_PROP_OA_EXPONENT:
 			if (value > OA_EXPONENT_MAX) {
-				DRM_DEBUG("OA timer exponent too high (> %u)\n",
+				drm_dbg(&perf->i915->drm,
+					"OA timer exponent too high (> %u)\n",
 					 OA_EXPONENT_MAX);
 				return -EINVAL;
 			}
@@ -3686,7 +3710,8 @@ static int read_properties_unlocked(struct i915_perf *perf,
 				oa_freq_hz = 0;
 
 			if (oa_freq_hz > i915_oa_max_sample_rate && !perfmon_capable()) {
-				DRM_DEBUG("OA exponent would exceed the max sampling frequency (sysctl dev.i915.oa_max_sample_rate) %uHz without CAP_PERFMON or CAP_SYS_ADMIN privileges\n",
+				drm_dbg(&perf->i915->drm,
+					"OA exponent would exceed the max sampling frequency (sysctl dev.i915.oa_max_sample_rate) %uHz without CAP_PERFMON or CAP_SYS_ADMIN privileges\n",
 					  i915_oa_max_sample_rate);
 				return -EACCES;
 			}
@@ -3703,13 +3728,15 @@ static int read_properties_unlocked(struct i915_perf *perf,
 			if (copy_from_user(&user_sseu,
 					   u64_to_user_ptr(value),
 					   sizeof(user_sseu))) {
-				DRM_DEBUG("Unable to copy global sseu parameter\n");
+				drm_dbg(&perf->i915->drm,
+					"Unable to copy global sseu parameter\n");
 				return -EFAULT;
 			}
 
 			ret = get_sseu_config(&props->sseu, props->engine, &user_sseu);
 			if (ret) {
-				DRM_DEBUG("Invalid SSEU configuration\n");
+				drm_dbg(&perf->i915->drm,
+					"Invalid SSEU configuration\n");
 				return ret;
 			}
 			props->has_sseu = true;
@@ -3717,7 +3744,8 @@ static int read_properties_unlocked(struct i915_perf *perf,
 		}
 		case DRM_I915_PERF_PROP_POLL_OA_PERIOD:
 			if (value < 100000 /* 100us */) {
-				DRM_DEBUG("OA availability timer too small (%lluns < 100us)\n",
+				drm_dbg(&perf->i915->drm,
+					"OA availability timer too small (%lluns < 100us)\n",
 					  value);
 				return -EINVAL;
 			}
@@ -3768,7 +3796,8 @@ int i915_perf_open_ioctl(struct drm_device *dev, void *data,
 	int ret;
 
 	if (!perf->i915) {
-		DRM_DEBUG("i915 perf interface not available for this system\n");
+		drm_dbg(&perf->i915->drm,
+			"i915 perf interface not available for this system\n");
 		return -ENOTSUPP;
 	}
 
@@ -3776,7 +3805,8 @@ int i915_perf_open_ioctl(struct drm_device *dev, void *data,
 			   I915_PERF_FLAG_FD_NONBLOCK |
 			   I915_PERF_FLAG_DISABLED;
 	if (param->flags & ~known_open_flags) {
-		DRM_DEBUG("Unknown drm_i915_perf_open_param flag\n");
+		drm_dbg(&perf->i915->drm,
+			"Unknown drm_i915_perf_open_param flag\n");
 		return -EINVAL;
 	}
 
@@ -3986,7 +4016,8 @@ static struct i915_oa_reg *alloc_oa_regs(struct i915_perf *perf,
 			goto addr_err;
 
 		if (!is_valid(perf, addr)) {
-			DRM_DEBUG("Invalid oa_reg address: %X\n", addr);
+			drm_dbg(&perf->i915->drm,
+				"Invalid oa_reg address: %X\n", addr);
 			err = -EINVAL;
 			goto addr_err;
 		}
@@ -4060,30 +4091,35 @@ int i915_perf_add_config_ioctl(struct drm_device *dev, void *data,
 	int err, id;
 
 	if (!perf->i915) {
-		DRM_DEBUG("i915 perf interface not available for this system\n");
+		drm_dbg(&perf->i915->drm,
+			"i915 perf interface not available for this system\n");
 		return -ENOTSUPP;
 	}
 
 	if (!perf->metrics_kobj) {
-		DRM_DEBUG("OA metrics weren't advertised via sysfs\n");
+		drm_dbg(&perf->i915->drm,
+			"OA metrics weren't advertised via sysfs\n");
 		return -EINVAL;
 	}
 
 	if (i915_perf_stream_paranoid && !perfmon_capable()) {
-		DRM_DEBUG("Insufficient privileges to add i915 OA config\n");
+		drm_dbg(&perf->i915->drm,
+			"Insufficient privileges to add i915 OA config\n");
 		return -EACCES;
 	}
 
 	if ((!args->mux_regs_ptr || !args->n_mux_regs) &&
 	    (!args->boolean_regs_ptr || !args->n_boolean_regs) &&
 	    (!args->flex_regs_ptr || !args->n_flex_regs)) {
-		DRM_DEBUG("No OA registers given\n");
+		drm_dbg(&perf->i915->drm,
+			"No OA registers given\n");
 		return -EINVAL;
 	}
 
 	oa_config = kzalloc(sizeof(*oa_config), GFP_KERNEL);
 	if (!oa_config) {
-		DRM_DEBUG("Failed to allocate memory for the OA config\n");
+		drm_dbg(&perf->i915->drm,
+			"Failed to allocate memory for the OA config\n");
 		return -ENOMEM;
 	}
 
@@ -4091,7 +4127,8 @@ int i915_perf_add_config_ioctl(struct drm_device *dev, void *data,
 	kref_init(&oa_config->ref);
 
 	if (!uuid_is_valid(args->uuid)) {
-		DRM_DEBUG("Invalid uuid format for OA config\n");
+		drm_dbg(&perf->i915->drm,
+			"Invalid uuid format for OA config\n");
 		err = -EINVAL;
 		goto reg_err;
 	}
@@ -4108,7 +4145,8 @@ int i915_perf_add_config_ioctl(struct drm_device *dev, void *data,
 			     args->n_mux_regs);
 
 	if (IS_ERR(regs)) {
-		DRM_DEBUG("Failed to create OA config for mux_regs\n");
+		drm_dbg(&perf->i915->drm,
+			"Failed to create OA config for mux_regs\n");
 		err = PTR_ERR(regs);
 		goto reg_err;
 	}
@@ -4121,7 +4159,8 @@ int i915_perf_add_config_ioctl(struct drm_device *dev, void *data,
 			     args->n_boolean_regs);
 
 	if (IS_ERR(regs)) {
-		DRM_DEBUG("Failed to create OA config for b_counter_regs\n");
+		drm_dbg(&perf->i915->drm,
+			"Failed to create OA config for b_counter_regs\n");
 		err = PTR_ERR(regs);
 		goto reg_err;
 	}
@@ -4140,7 +4179,8 @@ int i915_perf_add_config_ioctl(struct drm_device *dev, void *data,
 				     args->n_flex_regs);
 
 		if (IS_ERR(regs)) {
-			DRM_DEBUG("Failed to create OA config for flex_regs\n");
+			drm_dbg(&perf->i915->drm,
+				"Failed to create OA config for flex_regs\n");
 			err = PTR_ERR(regs);
 			goto reg_err;
 		}
@@ -4156,7 +4196,8 @@ int i915_perf_add_config_ioctl(struct drm_device *dev, void *data,
 	 */
 	idr_for_each_entry(&perf->metrics_idr, tmp, id) {
 		if (!strcmp(tmp->uuid, oa_config->uuid)) {
-			DRM_DEBUG("OA config already exists with this uuid\n");
+			drm_dbg(&perf->i915->drm,
+				"OA config already exists with this uuid\n");
 			err = -EADDRINUSE;
 			goto sysfs_err;
 		}
@@ -4164,7 +4205,8 @@ int i915_perf_add_config_ioctl(struct drm_device *dev, void *data,
 
 	err = create_dynamic_oa_sysfs_entry(perf, oa_config);
 	if (err) {
-		DRM_DEBUG("Failed to create sysfs entry for OA config\n");
+		drm_dbg(&perf->i915->drm,
+			"Failed to create sysfs entry for OA config\n");
 		goto sysfs_err;
 	}
 
@@ -4173,14 +4215,16 @@ int i915_perf_add_config_ioctl(struct drm_device *dev, void *data,
 				  oa_config, 2,
 				  0, GFP_KERNEL);
 	if (oa_config->id < 0) {
-		DRM_DEBUG("Failed to create sysfs entry for OA config\n");
+		drm_dbg(&perf->i915->drm,
+			"Failed to create sysfs entry for OA config\n");
 		err = oa_config->id;
 		goto sysfs_err;
 	}
 
 	mutex_unlock(&perf->metrics_lock);
 
-	DRM_DEBUG("Added config %s id=%i\n", oa_config->uuid, oa_config->id);
+	drm_dbg(&perf->i915->drm,
+		"Added config %s id=%i\n", oa_config->uuid, oa_config->id);
 
 	return oa_config->id;
 
@@ -4188,7 +4232,8 @@ int i915_perf_add_config_ioctl(struct drm_device *dev, void *data,
 	mutex_unlock(&perf->metrics_lock);
 reg_err:
 	i915_oa_config_put(oa_config);
-	DRM_DEBUG("Failed to add new OA config\n");
+	drm_dbg(&perf->i915->drm,
+		"Failed to add new OA config\n");
 	return err;
 }
 
@@ -4212,12 +4257,14 @@ int i915_perf_remove_config_ioctl(struct drm_device *dev, void *data,
 	int ret;
 
 	if (!perf->i915) {
-		DRM_DEBUG("i915 perf interface not available for this system\n");
+		drm_dbg(&perf->i915->drm,
+			"i915 perf interface not available for this system\n");
 		return -ENOTSUPP;
 	}
 
 	if (i915_perf_stream_paranoid && !perfmon_capable()) {
-		DRM_DEBUG("Insufficient privileges to remove i915 OA config\n");
+		drm_dbg(&perf->i915->drm,
+			"Insufficient privileges to remove i915 OA config\n");
 		return -EACCES;
 	}
 
@@ -4227,7 +4274,8 @@ int i915_perf_remove_config_ioctl(struct drm_device *dev, void *data,
 
 	oa_config = idr_find(&perf->metrics_idr, *arg);
 	if (!oa_config) {
-		DRM_DEBUG("Failed to remove unknown OA config\n");
+		drm_dbg(&perf->i915->drm,
+			"Failed to remove unknown OA config\n");
 		ret = -ENOENT;
 		goto err_unlock;
 	}
@@ -4240,7 +4288,8 @@ int i915_perf_remove_config_ioctl(struct drm_device *dev, void *data,
 
 	mutex_unlock(&perf->metrics_lock);
 
-	DRM_DEBUG("Removed config %s id=%i\n", oa_config->uuid, oa_config->id);
+	drm_dbg(&perf->i915->drm,
+		"Removed config %s id=%i\n", oa_config->uuid, oa_config->id);
 
 	i915_oa_config_put(oa_config);
 
-- 
2.39.2



