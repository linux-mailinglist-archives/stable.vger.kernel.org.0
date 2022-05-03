Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC86519264
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 01:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234374AbiECXn4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 May 2022 19:43:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244344AbiECXnz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 May 2022 19:43:55 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5779425D6
        for <stable@vger.kernel.org>; Tue,  3 May 2022 16:40:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651621219; x=1683157219;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Yz52W0IvZd9JYisyuVWGfyVVHDPUncGuC5hbmJba1s0=;
  b=Rff2n+qWiWoMExLX571g5qg0KORhHIl8TIiuFCWtTYfQpeis+dRsrTyS
   evqI0r4UPGk8hvYJbKFtUFEOVkCrysqdGCgz67KI37PH7Ic7xzx53ngUX
   c5+mSg4yfGU/6aCVuOtCtktrZnZDImabyJLN70FqF8BVQLzt7EsAOGUmc
   Pg8tj4eaZFsgPZJl4gAMThUORGSZOTFO/Sis3Lx+2aYbx7ByQ+E7iYybS
   EEoNke4RtEMsclvWFpQFhnEoTANeLA0xPvFn9RQnlPA438nQJsM0nAgEO
   oHZc3fmBl168qbXLmuq0v1+q9cNCO2JQmBdJUeAJsDhNpLWXgu6Op2tQq
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10336"; a="248161599"
X-IronPort-AV: E=Sophos;i="5.91,196,1647327600"; 
   d="scan'208";a="248161599"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2022 16:40:19 -0700
X-IronPort-AV: E=Sophos;i="5.91,196,1647327600"; 
   d="scan'208";a="562444206"
Received: from anushasr-mobl6.jf.intel.com ([10.165.21.155])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2022 16:40:18 -0700
From:   Anusha Srivatsa <anusha.srivatsa@intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     Anusha Srivatsa <anusha.srivatsa@intel.com>,
        stable@vger.kernel.org, Lucas De Marchi <lucas.demarchi@intel.com>
Subject: [PATCH] drm/i915/dmc: Add MMIO range restrictions
Date:   Tue,  3 May 2022 16:36:40 -0700
Message-Id: <20220503233640.617433-1-anusha.srivatsa@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Bspec has added some steps that check forDMC MMIO range before
programming them

v2: Fix for CI
v3: move register defines to .h (Anusha)
- Check MMIO restrictions per pipe
- Add MMIO restricton for v1 dmc header as well (Lucas)
v4: s/_PICK/_PICK_EVEN and use it only for Pipe DMC scenario.
- clean up sanity check logic.(Lucas)
- Add MMIO range for RKL as well.(Anusha)

BSpec: 49193

Cc: <stable@vger.kernel.org>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Anusha Srivatsa <anusha.srivatsa@intel.com>
---
 drivers/gpu/drm/i915/display/intel_dmc.c      | 43 +++++++++++++++++++
 drivers/gpu/drm/i915/display/intel_dmc_regs.h | 18 +++++++-
 2 files changed, 60 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/intel_dmc.c b/drivers/gpu/drm/i915/display/intel_dmc.c
index 257cf662f9f4..12d5cb850e39 100644
--- a/drivers/gpu/drm/i915/display/intel_dmc.c
+++ b/drivers/gpu/drm/i915/display/intel_dmc.c
@@ -374,6 +374,44 @@ static void dmc_set_fw_offset(struct intel_dmc *dmc,
 	}
 }
 
+static bool dmc_mmio_addr_sanity_check(struct intel_dmc *dmc, const u32 *mmioaddr,
+				       u32 mmio_count, int header_ver, u8 dmc_id)
+{
+	struct drm_i915_private *i915 = container_of(dmc, typeof(*i915), dmc);
+	u32 start_range, end_range;
+	int i;
+
+	if (dmc_id >= DMC_FW_MAX || dmc_id < DMC_FW_MAIN) {
+		drm_warn(&i915->drm, "Unsupported firmware id %u\n", dmc_id);
+		return false;
+	}
+
+	if (header_ver == 1) {
+		start_range = DMC_MMIO_START_RANGE;
+		end_range = DMC_MMIO_END_RANGE;
+	} else if (dmc_id == DMC_FW_MAIN) {
+		start_range = TGL_MAIN_MMIO_START;
+		end_range = TGL_MAIN_MMIO_END;
+	} else if (IS_DG2(i915) || IS_ALDERLAKE_P(i915)) {
+		start_range = ADLP_PIPE_MMIO_START;
+		end_range = ADLP_PIPE_MMIO_END;
+	} else if (IS_TIGERLAKE(i915) || IS_DG1(i915) || IS_ALDERLAKE_S(i915) ||
+		   IS_ROCKETLAKE(dev_priv)) {
+		start_range = TGL_PIPE_MMIO_START(dmc_id);
+		end_range = TGL_PIPE_MMIO_END(dmc_id);
+	} else {
+		drm_warn(&i915->drm, "Unknown mmio range for sanity check");
+		return false;
+	}
+
+	for (i = 0; i < mmio_count; i++) {
+		if (mmioaddr[i] < start_range || mmioaddr[i] > end_range)
+			return false;
+	}
+
+	return true;
+}
+
 static u32 parse_dmc_fw_header(struct intel_dmc *dmc,
 			       const struct intel_dmc_header_base *dmc_header,
 			       size_t rem_size, u8 dmc_id)
@@ -443,6 +481,11 @@ static u32 parse_dmc_fw_header(struct intel_dmc *dmc,
 		return 0;
 	}
 
+	if (!dmc_mmio_addr_sanity_check(dmc, mmioaddr, mmio_count, dmc_header->header_ver, dmc_id)) {
+		drm_err(&i915->drm, "DMC firmware has Wrong MMIO Addresses\n");
+		return 0;
+	}
+
 	for (i = 0; i < mmio_count; i++) {
 		dmc_info->mmioaddr[i] = _MMIO(mmioaddr[i]);
 		dmc_info->mmiodata[i] = mmiodata[i];
diff --git a/drivers/gpu/drm/i915/display/intel_dmc_regs.h b/drivers/gpu/drm/i915/display/intel_dmc_regs.h
index d65e698832eb..67e14eb96a7a 100644
--- a/drivers/gpu/drm/i915/display/intel_dmc_regs.h
+++ b/drivers/gpu/drm/i915/display/intel_dmc_regs.h
@@ -16,7 +16,23 @@
 #define DMC_LAST_WRITE		_MMIO(0x8F034)
 #define DMC_LAST_WRITE_VALUE	0xc003b400
 #define DMC_MMIO_START_RANGE	0x80000
-#define DMC_MMIO_END_RANGE	0x8FFFF
+#define DMC_MMIO_END_RANGE     0x8FFFF
+#define DMC_V1_MMIO_START_RANGE		0x80000
+#define TGL_MAIN_MMIO_START		0x8F000
+#define TGL_MAIN_MMIO_END		0x8FFFF
+#define _TGL_PIPEA_MMIO_START		0x92000
+#define _TGL_PIPEA_MMIO_END		0x93FFF
+#define _TGL_PIPEB_MMIO_START		0x96000
+#define _TGL_PIPEB_MMIO_END		0x97FFF
+#define ADLP_PIPE_MMIO_START		0x5F000
+#define ADLP_PIPE_MMIO_END		0x5FFFF
+
+#define TGL_PIPE_MMIO_START(dmc_id)	_PICK_EVEN(((dmc_id) - 1), _TGL_PIPEA_MMIO_START,\
+					      _TGL_PIPEB_MMIO_START)
+
+#define TGL_PIPE_MMIO_END(dmc_id)	_PICK_EVEN(((dmc_id) - 1), _TGL_PIPEA_MMIO_END,\
+					      _TGL_PIPEB_MMIO_END)
+
 #define SKL_DMC_DC3_DC5_COUNT	_MMIO(0x80030)
 #define SKL_DMC_DC5_DC6_COUNT	_MMIO(0x8002C)
 #define BXT_DMC_DC3_DC5_COUNT	_MMIO(0x80038)
-- 
2.25.1

