Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E58D75A8851
	for <lists+stable@lfdr.de>; Wed, 31 Aug 2022 23:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbiHaVp6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Aug 2022 17:45:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbiHaVp5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Aug 2022 17:45:57 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C0D3A61DD
        for <stable@vger.kernel.org>; Wed, 31 Aug 2022 14:45:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661982357; x=1693518357;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CgfZOrTzypTOkFjDig+t1xZYrGOLozxvd1kz/gJ6/lU=;
  b=Hj6JGnfbbF6jET4TESDS3ZNYR7JBlj4eE6gJMrTO1wj18IgE4CDWIcSo
   ynTTbjG6tJrEf3xZeYsURZ6SV22Dv11pgJmNOm5xIBft8CH+/XXh8aqb6
   1mftEdkoxAuL4EvWjaKrnLFgPsqbfxGteGwj/inyYjSHGP4f6OO12Ifp0
   HULdFuASQwzySFn4qRr+Ur7GKpNuyFOdPEKhbk1OUnOsmEVxGgMoFxaaH
   RefiDNaxQEqEljm/2Q76B+SrVZTfCWt4aHcv1MZWtw460gHK7gDtytusy
   Fs/tKmxZXrYhQksvHsBxznhZBWFYTn51n/XmJ+e8wME3NcJxjIq/E4cbB
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10456"; a="275953296"
X-IronPort-AV: E=Sophos;i="5.93,279,1654585200"; 
   d="scan'208";a="275953296"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 14:45:41 -0700
X-IronPort-AV: E=Sophos;i="5.93,279,1654585200"; 
   d="scan'208";a="673537277"
Received: from rbabtiwa-mobl.amr.corp.intel.com (HELO rdvivi-mobl4.intel.com) ([10.255.32.165])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 14:45:40 -0700
From:   Rodrigo Vivi <rodrigo.vivi@intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     Rodrigo Vivi <rodrigo.vivi@intel.com>, stable@vger.kernel.org,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Sushma Venkatesh Reddy <sushma.venkatesh.reddy@intel.com>
Subject: [PATCH] drm/i915/slpc: Let's fix the PCODE min freq table setup for SLPC
Date:   Wed, 31 Aug 2022 17:45:38 -0400
Message-Id: <20220831214538.143950-1-rodrigo.vivi@intel.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <874jxtz1e7.wl-ashutosh.dixit@intel.com>
References: <874jxtz1e7.wl-ashutosh.dixit@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We need to inform PCODE of a desired ring frequencies so PCODE update
the memory frequencies to us. rps->min_freq and rps->max_freq are the
frequencies used in that request. However they were unset when SLPC was
enabled and PCODE never updated the memory freq.

v2 (as Suggested by Ashutosh): if SLPC is in use, let's pick the right
   frequencies from the get_ia_constants instead of the fake init of
   rps' min and max.

v3: don't forget the max <= min return

v4: Move all the freq conversion to intel_rps.c. And the max <= min
    check to where it belongs.

v5: (Ashutosh) Fix old comment s/50 HZ/50 MHz and add a doc explaining
    the "raw format"

Fixes: 7ba79a671568 ("drm/i915/guc/slpc: Gate Host RPS when SLPC is enabled")
Cc: <stable@vger.kernel.org> # v5.15+
Cc: Ashutosh Dixit <ashutosh.dixit@intel.com>
Tested-by: Sushma Venkatesh Reddy <sushma.venkatesh.reddy@intel.com>
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
---
 drivers/gpu/drm/i915/gt/intel_llc.c | 19 ++++++-----
 drivers/gpu/drm/i915/gt/intel_rps.c | 50 +++++++++++++++++++++++++++++
 drivers/gpu/drm/i915/gt/intel_rps.h |  2 ++
 3 files changed, 61 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_llc.c b/drivers/gpu/drm/i915/gt/intel_llc.c
index 14fe65812e42..1d19c073ba2e 100644
--- a/drivers/gpu/drm/i915/gt/intel_llc.c
+++ b/drivers/gpu/drm/i915/gt/intel_llc.c
@@ -12,6 +12,7 @@
 #include "intel_llc.h"
 #include "intel_mchbar_regs.h"
 #include "intel_pcode.h"
+#include "intel_rps.h"
 
 struct ia_constants {
 	unsigned int min_gpu_freq;
@@ -55,9 +56,6 @@ static bool get_ia_constants(struct intel_llc *llc,
 	if (!HAS_LLC(i915) || IS_DGFX(i915))
 		return false;
 
-	if (rps->max_freq <= rps->min_freq)
-		return false;
-
 	consts->max_ia_freq = cpu_max_MHz();
 
 	consts->min_ring_freq =
@@ -65,13 +63,8 @@ static bool get_ia_constants(struct intel_llc *llc,
 	/* convert DDR frequency from units of 266.6MHz to bandwidth */
 	consts->min_ring_freq = mult_frac(consts->min_ring_freq, 8, 3);
 
-	consts->min_gpu_freq = rps->min_freq;
-	consts->max_gpu_freq = rps->max_freq;
-	if (GRAPHICS_VER(i915) >= 9) {
-		/* Convert GT frequency to 50 HZ units */
-		consts->min_gpu_freq /= GEN9_FREQ_SCALER;
-		consts->max_gpu_freq /= GEN9_FREQ_SCALER;
-	}
+	consts->min_gpu_freq = intel_rps_get_min_raw_freq(rps);
+	consts->max_gpu_freq = intel_rps_get_max_raw_freq(rps);
 
 	return true;
 }
@@ -130,6 +123,12 @@ static void gen6_update_ring_freq(struct intel_llc *llc)
 	if (!get_ia_constants(llc, &consts))
 		return;
 
+	/*
+	 * Although this is unlikely on any platform during initialization,
+	 * let's ensure we don't get accidentally into infinite loop
+	 */
+	if (consts.max_gpu_freq <= consts.min_gpu_freq)
+		return;
 	/*
 	 * For each potential GPU frequency, load a ring frequency we'd like
 	 * to use for memory access.  We do this by specifying the IA frequency
diff --git a/drivers/gpu/drm/i915/gt/intel_rps.c b/drivers/gpu/drm/i915/gt/intel_rps.c
index de794f5f8594..318bf913c507 100644
--- a/drivers/gpu/drm/i915/gt/intel_rps.c
+++ b/drivers/gpu/drm/i915/gt/intel_rps.c
@@ -2156,6 +2156,31 @@ u32 intel_rps_get_max_frequency(struct intel_rps *rps)
 		return intel_gpu_freq(rps, rps->max_freq_softlimit);
 }
 
+/**
+ * intel_rps_get_max_raw_freq - returns the max frequency in some raw format.
+ * @rps: the intel_rps structure
+ *
+ * Returns the max frequency in a raw format. In newer platforms raw is in
+ * units of 50 MHz.
+ */
+u32 intel_rps_get_max_raw_freq(struct intel_rps *rps)
+{
+	struct intel_guc_slpc *slpc = rps_to_slpc(rps);
+	u32 freq;
+
+	if (rps_uses_slpc(rps)) {
+		return DIV_ROUND_CLOSEST(slpc->rp0_freq,
+					 GT_FREQUENCY_MULTIPLIER);
+	} else {
+		freq = rps->max_freq;
+		if (GRAPHICS_VER(rps_to_i915(rps)) >= 9) {
+			/* Convert GT frequency to 50 MHz units */
+			freq /= GEN9_FREQ_SCALER;
+		}
+		return freq;
+	}
+}
+
 u32 intel_rps_get_rp0_frequency(struct intel_rps *rps)
 {
 	struct intel_guc_slpc *slpc = rps_to_slpc(rps);
@@ -2244,6 +2269,31 @@ u32 intel_rps_get_min_frequency(struct intel_rps *rps)
 		return intel_gpu_freq(rps, rps->min_freq_softlimit);
 }
 
+/**
+ * intel_rps_get_min_raw_freq - returns the min frequency in some raw format.
+ * @rps: the intel_rps structure
+ *
+ * Returns the min frequency in a raw format. In newer platforms raw is in
+ * units of 50 MHz.
+ */
+u32 intel_rps_get_min_raw_freq(struct intel_rps *rps)
+{
+	struct intel_guc_slpc *slpc = rps_to_slpc(rps);
+	u32 freq;
+
+	if (rps_uses_slpc(rps)) {
+		return DIV_ROUND_CLOSEST(slpc->min_freq,
+					 GT_FREQUENCY_MULTIPLIER);
+	} else {
+		freq = rps->min_freq;
+		if (GRAPHICS_VER(rps_to_i915(rps)) >= 9) {
+			/* Convert GT frequency to 50 MHz units */
+			freq /= GEN9_FREQ_SCALER;
+		}
+		return freq;
+	}
+}
+
 static int set_min_freq(struct intel_rps *rps, u32 val)
 {
 	int ret = 0;
diff --git a/drivers/gpu/drm/i915/gt/intel_rps.h b/drivers/gpu/drm/i915/gt/intel_rps.h
index 8fe5a6bbdf66..64e4ef565e52 100644
--- a/drivers/gpu/drm/i915/gt/intel_rps.h
+++ b/drivers/gpu/drm/i915/gt/intel_rps.h
@@ -39,8 +39,10 @@ u32 intel_rps_get_cagf(struct intel_rps *rps, u32 rpstat1);
 u32 intel_rps_read_actual_frequency(struct intel_rps *rps);
 u32 intel_rps_get_requested_frequency(struct intel_rps *rps);
 u32 intel_rps_get_min_frequency(struct intel_rps *rps);
+u32 intel_rps_get_min_raw_freq(struct intel_rps *rps);
 int intel_rps_set_min_frequency(struct intel_rps *rps, u32 val);
 u32 intel_rps_get_max_frequency(struct intel_rps *rps);
+u32 intel_rps_get_max_raw_freq(struct intel_rps *rps);
 int intel_rps_set_max_frequency(struct intel_rps *rps, u32 val);
 u32 intel_rps_get_rp0_frequency(struct intel_rps *rps);
 u32 intel_rps_get_rp1_frequency(struct intel_rps *rps);
-- 
2.37.2

