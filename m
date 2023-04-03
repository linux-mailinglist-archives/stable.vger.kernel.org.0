Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 210396D4A79
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234116AbjDCOrj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:47:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234045AbjDCOrS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:47:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDDEE16944
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:46:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D5BE661F4C
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:46:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB54EC433D2;
        Mon,  3 Apr 2023 14:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680533200;
        bh=GOXd9LLtlIxzb3c3U7731ypA6ZZjJbJNhuTwL8ZiXNc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TRQier/bXseFWY9rSGN48GcMoG7jx6TCak9dsgEKGYu4w2P6M60Mmkzlnk11m5djh
         mlKJG5bAJjAw1D8XmD6qY8OiXUvxul1GiHaFTL/nhHNJLaH5nEz5jJoHJjJ9sjE7HD
         KfnuTvpVhV7LHbRXmAPv2bdikKfLq64wMWAo9gDc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 093/187] drm/i915/pmu: Use functions common with sysfs to read actual freq
Date:   Mon,  3 Apr 2023 16:08:58 +0200
Message-Id: <20230403140419.038292110@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ashutosh Dixit <ashutosh.dixit@intel.com>

[ Upstream commit 12d4eb20d9d86fae5f84117ff047e966e470f7b9 ]

Expose intel_rps_read_actual_frequency_fw to read the actual freq without
taking forcewake for use by PMU. The code is refactored to use a common set
of functions across sysfs and PMU. Using common functions with sysfs in PMU
solves the issues of missing support for MTL and missing support for older
generations (prior to Gen6). It also future proofs the PMU where sometimes
code has been updated for sysfs and PMU has been missed.

v2: Remove runtime_pm_if_in_use from read_actual_frequency_fw (Tvrtko)

v3: (Tvrtko)
 - Remove goto in __read_cagf
 - Unexport intel_rps_get_cagf and intel_rps_read_punit_req

Fixes: 22009b6dad66 ("drm/i915/mtl: Modify CAGF functions for MTL")
Link: https://gitlab.freedesktop.org/drm/intel/-/issues/8280
Signed-off-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230316004800.2539753-1-ashutosh.dixit@intel.com
(cherry picked from commit 44df42e66139b5fac8db49ee354be279210f9816)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/intel_rps.c | 38 ++++++++++++++++-------------
 drivers/gpu/drm/i915/gt/intel_rps.h |  4 +--
 drivers/gpu/drm/i915/i915_pmu.c     | 10 +++-----
 3 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_rps.c b/drivers/gpu/drm/i915/gt/intel_rps.c
index 9ad3bc7201cba..fc73cfe0e39bb 100644
--- a/drivers/gpu/drm/i915/gt/intel_rps.c
+++ b/drivers/gpu/drm/i915/gt/intel_rps.c
@@ -2074,16 +2074,6 @@ void intel_rps_sanitize(struct intel_rps *rps)
 		rps_disable_interrupts(rps);
 }
 
-u32 intel_rps_read_rpstat_fw(struct intel_rps *rps)
-{
-	struct drm_i915_private *i915 = rps_to_i915(rps);
-	i915_reg_t rpstat;
-
-	rpstat = (GRAPHICS_VER(i915) >= 12) ? GEN12_RPSTAT1 : GEN6_RPSTAT1;
-
-	return intel_uncore_read_fw(rps_to_gt(rps)->uncore, rpstat);
-}
-
 u32 intel_rps_read_rpstat(struct intel_rps *rps)
 {
 	struct drm_i915_private *i915 = rps_to_i915(rps);
@@ -2094,7 +2084,7 @@ u32 intel_rps_read_rpstat(struct intel_rps *rps)
 	return intel_uncore_read(rps_to_gt(rps)->uncore, rpstat);
 }
 
-u32 intel_rps_get_cagf(struct intel_rps *rps, u32 rpstat)
+static u32 intel_rps_get_cagf(struct intel_rps *rps, u32 rpstat)
 {
 	struct drm_i915_private *i915 = rps_to_i915(rps);
 	u32 cagf;
@@ -2117,10 +2107,11 @@ u32 intel_rps_get_cagf(struct intel_rps *rps, u32 rpstat)
 	return cagf;
 }
 
-static u32 read_cagf(struct intel_rps *rps)
+static u32 __read_cagf(struct intel_rps *rps, bool take_fw)
 {
 	struct drm_i915_private *i915 = rps_to_i915(rps);
 	struct intel_uncore *uncore = rps_to_uncore(rps);
+	i915_reg_t r = INVALID_MMIO_REG;
 	u32 freq;
 
 	/*
@@ -2128,22 +2119,30 @@ static u32 read_cagf(struct intel_rps *rps)
 	 * registers will return 0 freq when GT is in RC6
 	 */
 	if (GRAPHICS_VER_FULL(i915) >= IP_VER(12, 70)) {
-		freq = intel_uncore_read(uncore, MTL_MIRROR_TARGET_WP1);
+		r = MTL_MIRROR_TARGET_WP1;
 	} else if (GRAPHICS_VER(i915) >= 12) {
-		freq = intel_uncore_read(uncore, GEN12_RPSTAT1);
+		r = GEN12_RPSTAT1;
 	} else if (IS_VALLEYVIEW(i915) || IS_CHERRYVIEW(i915)) {
 		vlv_punit_get(i915);
 		freq = vlv_punit_read(i915, PUNIT_REG_GPU_FREQ_STS);
 		vlv_punit_put(i915);
 	} else if (GRAPHICS_VER(i915) >= 6) {
-		freq = intel_uncore_read(uncore, GEN6_RPSTAT1);
+		r = GEN6_RPSTAT1;
 	} else {
-		freq = intel_uncore_read(uncore, MEMSTAT_ILK);
+		r = MEMSTAT_ILK;
 	}
 
+	if (i915_mmio_reg_valid(r))
+		freq = take_fw ? intel_uncore_read(uncore, r) : intel_uncore_read_fw(uncore, r);
+
 	return intel_rps_get_cagf(rps, freq);
 }
 
+static u32 read_cagf(struct intel_rps *rps)
+{
+	return __read_cagf(rps, true);
+}
+
 u32 intel_rps_read_actual_frequency(struct intel_rps *rps)
 {
 	struct intel_runtime_pm *rpm = rps_to_uncore(rps)->rpm;
@@ -2156,7 +2155,12 @@ u32 intel_rps_read_actual_frequency(struct intel_rps *rps)
 	return freq;
 }
 
-u32 intel_rps_read_punit_req(struct intel_rps *rps)
+u32 intel_rps_read_actual_frequency_fw(struct intel_rps *rps)
+{
+	return intel_gpu_freq(rps, __read_cagf(rps, false));
+}
+
+static u32 intel_rps_read_punit_req(struct intel_rps *rps)
 {
 	struct intel_uncore *uncore = rps_to_uncore(rps);
 	struct intel_runtime_pm *rpm = rps_to_uncore(rps)->rpm;
diff --git a/drivers/gpu/drm/i915/gt/intel_rps.h b/drivers/gpu/drm/i915/gt/intel_rps.h
index 9e1cad9ba0e9c..d86ddfee095ed 100644
--- a/drivers/gpu/drm/i915/gt/intel_rps.h
+++ b/drivers/gpu/drm/i915/gt/intel_rps.h
@@ -34,8 +34,8 @@ void intel_rps_mark_interactive(struct intel_rps *rps, bool interactive);
 
 int intel_gpu_freq(struct intel_rps *rps, int val);
 int intel_freq_opcode(struct intel_rps *rps, int val);
-u32 intel_rps_get_cagf(struct intel_rps *rps, u32 rpstat1);
 u32 intel_rps_read_actual_frequency(struct intel_rps *rps);
+u32 intel_rps_read_actual_frequency_fw(struct intel_rps *rps);
 u32 intel_rps_get_requested_frequency(struct intel_rps *rps);
 u32 intel_rps_get_min_frequency(struct intel_rps *rps);
 u32 intel_rps_get_min_raw_freq(struct intel_rps *rps);
@@ -46,10 +46,8 @@ int intel_rps_set_max_frequency(struct intel_rps *rps, u32 val);
 u32 intel_rps_get_rp0_frequency(struct intel_rps *rps);
 u32 intel_rps_get_rp1_frequency(struct intel_rps *rps);
 u32 intel_rps_get_rpn_frequency(struct intel_rps *rps);
-u32 intel_rps_read_punit_req(struct intel_rps *rps);
 u32 intel_rps_read_punit_req_frequency(struct intel_rps *rps);
 u32 intel_rps_read_rpstat(struct intel_rps *rps);
-u32 intel_rps_read_rpstat_fw(struct intel_rps *rps);
 void gen6_rps_get_freq_caps(struct intel_rps *rps, struct intel_rps_freq_caps *caps);
 void intel_rps_raise_unslice(struct intel_rps *rps);
 void intel_rps_lower_unslice(struct intel_rps *rps);
diff --git a/drivers/gpu/drm/i915/i915_pmu.c b/drivers/gpu/drm/i915/i915_pmu.c
index 52531ab28c5f5..6d422b056f8a8 100644
--- a/drivers/gpu/drm/i915/i915_pmu.c
+++ b/drivers/gpu/drm/i915/i915_pmu.c
@@ -393,14 +393,12 @@ frequency_sample(struct intel_gt *gt, unsigned int period_ns)
 		 * case we assume the system is running at the intended
 		 * frequency. Fortunately, the read should rarely fail!
 		 */
-		val = intel_rps_read_rpstat_fw(rps);
-		if (val)
-			val = intel_rps_get_cagf(rps, val);
-		else
-			val = rps->cur_freq;
+		val = intel_rps_read_actual_frequency_fw(rps);
+		if (!val)
+			val = intel_gpu_freq(rps, rps->cur_freq);
 
 		add_sample_mult(&pmu->sample[__I915_SAMPLE_FREQ_ACT],
-				intel_gpu_freq(rps, val), period_ns / 1000);
+				val, period_ns / 1000);
 	}
 
 	if (pmu->enable & config_mask(I915_PMU_REQUESTED_FREQUENCY)) {
-- 
2.39.2



