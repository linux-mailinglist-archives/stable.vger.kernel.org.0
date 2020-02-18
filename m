Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5210C1631F1
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 21:06:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729149AbgBRUDq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 15:03:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:45132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728958AbgBRUDp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 15:03:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7169524125;
        Tue, 18 Feb 2020 20:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582056224;
        bh=XGjNLypApd/PXrNi3oRTN2rQIAokbNPgdhxPqrHoWwc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EoxMUzKEaWrL7L7Q/OT1mQ6GU8oVkSoDqp5z3MJEH3PXfWRDGaCE+uOzsZ2c7WI3J
         lrDK+HJTkk10mlA/bWzAzfMLY4AiUjus0bEU67pG4LS6ayIOYPvyVIyy525AgPFP0D
         pdwxh50ALW+KOQHAKYwlC+Cbm622acFnEgslicfE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.5 75/80] drm/i915/pmu: Correct the rc6 offset upon enabling
Date:   Tue, 18 Feb 2020 20:55:36 +0100
Message-Id: <20200218190438.951061240@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200218190432.043414522@linuxfoundation.org>
References: <20200218190432.043414522@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 88a9c66d998b1d2dac412fcd458c5d17d70513c8 upstream.

The rc6 residency starts ticking from 0 from BIOS POST, but the kernel
starts measuring the time from its boot. If we start measuruing
I915_PMU_RC6_RESIDENCY while the GT is idle, we start our sampling from
0 and then upon first activity (park/unpark) add in all the rc6
residency since boot. After the first park with the sampler engaged, the
sleep/active counters are aligned.

v2: With a wakeref to be sure

Closes: https://gitlab.freedesktop.org/drm/intel/issues/973
Fixes: df6a42053513 ("drm/i915/pmu: Ensure monotonic rc6")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200114105648.2172026-1-chris@chris-wilson.co.uk
(cherry picked from commit f4e9894b6952a2819937f363cd42e7cd7894a1e4)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_pmu.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/gpu/drm/i915/i915_pmu.c
+++ b/drivers/gpu/drm/i915/i915_pmu.c
@@ -594,8 +594,10 @@ static void i915_pmu_enable(struct perf_
 		container_of(event->pmu, typeof(*i915), pmu.base);
 	unsigned int bit = event_enabled_bit(event);
 	struct i915_pmu *pmu = &i915->pmu;
+	intel_wakeref_t wakeref;
 	unsigned long flags;
 
+	wakeref = intel_runtime_pm_get(&i915->runtime_pm);
 	spin_lock_irqsave(&pmu->lock, flags);
 
 	/*
@@ -605,6 +607,14 @@ static void i915_pmu_enable(struct perf_
 	BUILD_BUG_ON(ARRAY_SIZE(pmu->enable_count) != I915_PMU_MASK_BITS);
 	GEM_BUG_ON(bit >= ARRAY_SIZE(pmu->enable_count));
 	GEM_BUG_ON(pmu->enable_count[bit] == ~0);
+
+	if (pmu->enable_count[bit] == 0 &&
+	    config_enabled_mask(I915_PMU_RC6_RESIDENCY) & BIT_ULL(bit)) {
+		pmu->sample[__I915_SAMPLE_RC6_LAST_REPORTED].cur = 0;
+		pmu->sample[__I915_SAMPLE_RC6].cur = __get_rc6(&i915->gt);
+		pmu->sleep_last = ktime_get();
+	}
+
 	pmu->enable |= BIT_ULL(bit);
 	pmu->enable_count[bit]++;
 
@@ -645,6 +655,8 @@ static void i915_pmu_enable(struct perf_
 	 * an existing non-zero value.
 	 */
 	local64_set(&event->hw.prev_count, __i915_pmu_event_read(event));
+
+	intel_runtime_pm_put(&i915->runtime_pm, wakeref);
 }
 
 static void i915_pmu_disable(struct perf_event *event)


