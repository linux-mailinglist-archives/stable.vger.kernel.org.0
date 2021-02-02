Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC1D30CCA4
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 21:04:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240252AbhBBUC1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 15:02:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:36436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232739AbhBBNrT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:47:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8B4C64F8A;
        Tue,  2 Feb 2021 13:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273301;
        bh=2FfF461/N7rz03vDzriMNY+Aoe2gdbCs3W8z1cfi9WY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RTS/nMWC5xTAF2ivAtMTzYs+px1BdY16YbTHGFXPT8IyaYoqKbZdaI+zVprOj7ZZW
         ZaKhlu/gZ+JpygYNtUcvSZz/ZxielPaKBZ904oerutPztjLO2LRwzhK6ivZwggz9T6
         cSyH2OrlwSUgLHvhLajA7MK9ssb9GQBpHLDiHGH4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.10 056/142] drm/i915/pmu: Dont grab wakeref when enabling events
Date:   Tue,  2 Feb 2021 14:36:59 +0100
Message-Id: <20210202133000.029601297@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

commit 171a8e99828144050015672016dd63494c6d200a upstream.

Chris found a CI report which points out calling intel_runtime_pm_get from
inside i915_pmu_enable hook is not allowed since it can be invoked from
hard irq context. This is something we knew but forgot, so lets fix it
once again.

We do this by syncing the internal book keeping with hardware rc6 counter
on driver load.

v2:
 * Always sync on parking and fully sync on init.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Fixes: f4e9894b6952 ("drm/i915/pmu: Correct the rc6 offset upon enabling")
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Link: https://patchwork.freedesktop.org/patch/msgid/20201214094349.3563876-1-tvrtko.ursulin@linux.intel.com
(cherry picked from commit dbe13ae1d6abaab417edf3c37601c6a56594a4cd)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210118100724.465555-1-chris@chris-wilson.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_pmu.c |   30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

--- a/drivers/gpu/drm/i915/i915_pmu.c
+++ b/drivers/gpu/drm/i915/i915_pmu.c
@@ -184,13 +184,24 @@ static u64 get_rc6(struct intel_gt *gt)
 	return val;
 }
 
-static void park_rc6(struct drm_i915_private *i915)
+static void init_rc6(struct i915_pmu *pmu)
 {
-	struct i915_pmu *pmu = &i915->pmu;
+	struct drm_i915_private *i915 = container_of(pmu, typeof(*i915), pmu);
+	intel_wakeref_t wakeref;
 
-	if (pmu->enable & config_enabled_mask(I915_PMU_RC6_RESIDENCY))
+	with_intel_runtime_pm(i915->gt.uncore->rpm, wakeref) {
 		pmu->sample[__I915_SAMPLE_RC6].cur = __get_rc6(&i915->gt);
+		pmu->sample[__I915_SAMPLE_RC6_LAST_REPORTED].cur =
+					pmu->sample[__I915_SAMPLE_RC6].cur;
+		pmu->sleep_last = ktime_get();
+	}
+}
 
+static void park_rc6(struct drm_i915_private *i915)
+{
+	struct i915_pmu *pmu = &i915->pmu;
+
+	pmu->sample[__I915_SAMPLE_RC6].cur = __get_rc6(&i915->gt);
 	pmu->sleep_last = ktime_get();
 }
 
@@ -201,6 +212,7 @@ static u64 get_rc6(struct intel_gt *gt)
 	return __get_rc6(gt);
 }
 
+static void init_rc6(struct i915_pmu *pmu) { }
 static void park_rc6(struct drm_i915_private *i915) {}
 
 #endif
@@ -613,10 +625,8 @@ static void i915_pmu_enable(struct perf_
 		container_of(event->pmu, typeof(*i915), pmu.base);
 	unsigned int bit = event_enabled_bit(event);
 	struct i915_pmu *pmu = &i915->pmu;
-	intel_wakeref_t wakeref;
 	unsigned long flags;
 
-	wakeref = intel_runtime_pm_get(&i915->runtime_pm);
 	spin_lock_irqsave(&pmu->lock, flags);
 
 	/*
@@ -627,13 +637,6 @@ static void i915_pmu_enable(struct perf_
 	GEM_BUG_ON(bit >= ARRAY_SIZE(pmu->enable_count));
 	GEM_BUG_ON(pmu->enable_count[bit] == ~0);
 
-	if (pmu->enable_count[bit] == 0 &&
-	    config_enabled_mask(I915_PMU_RC6_RESIDENCY) & BIT_ULL(bit)) {
-		pmu->sample[__I915_SAMPLE_RC6_LAST_REPORTED].cur = 0;
-		pmu->sample[__I915_SAMPLE_RC6].cur = __get_rc6(&i915->gt);
-		pmu->sleep_last = ktime_get();
-	}
-
 	pmu->enable |= BIT_ULL(bit);
 	pmu->enable_count[bit]++;
 
@@ -674,8 +677,6 @@ static void i915_pmu_enable(struct perf_
 	 * an existing non-zero value.
 	 */
 	local64_set(&event->hw.prev_count, __i915_pmu_event_read(event));
-
-	intel_runtime_pm_put(&i915->runtime_pm, wakeref);
 }
 
 static void i915_pmu_disable(struct perf_event *event)
@@ -1101,6 +1102,7 @@ void i915_pmu_register(struct drm_i915_p
 	hrtimer_init(&pmu->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	pmu->timer.function = i915_sample;
 	pmu->cpuhp.slot = CPUHP_INVALID;
+	init_rc6(pmu);
 
 	if (!is_igp(i915)) {
 		pmu->name = kasprintf(GFP_KERNEL,


