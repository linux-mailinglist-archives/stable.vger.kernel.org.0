Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3954E510D4E
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 02:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349881AbiD0AmN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 20:42:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356400AbiD0AmE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 20:42:04 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBC2D38DA4
        for <stable@vger.kernel.org>; Tue, 26 Apr 2022 17:38:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651019925; x=1682555925;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=RmBT1xO53/+kazaWqeW8z7eHMIMTa+q8o02e8VJw9eM=;
  b=AzB22GFCG0aMAdAVWto5LKsgLgkqCNWRGuLYwRA98Dw3QZ2OkbitDQY1
   cGwR0OBZeq5mNLudlhbbxRKkaAwclitts0zB/ls05yKQIt9g7B2+GCCVW
   Y9RFIIJeM5fLYgOLkAfMN/g66GVI0MTU3HAkSUgc5/sHtGKYqO3EOdLZt
   9d8ht4WqO8HO4uedinbsBvTeI6W/U1iqvJHEsDp1dpsjxn0pKUCUu8RWN
   jf1s/8eHVAz9KgomrkizVGuA316nxgw4ubLHC2OZHLJLhyBUzgMDrGOH/
   9RJJ1n75AljEFGR5C0PPz8TDVeDClS2uQa9Hc3QOp5l9jNgNBoje+/R8s
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10329"; a="265929797"
X-IronPort-AV: E=Sophos;i="5.90,292,1643702400"; 
   d="scan'208";a="265929797"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2022 17:38:45 -0700
X-IronPort-AV: E=Sophos;i="5.90,292,1643702400"; 
   d="scan'208";a="679515307"
Received: from anushasr-mobl6.jf.intel.com ([10.165.21.155])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2022 17:38:45 -0700
From:   Anusha Srivatsa <anusha.srivatsa@intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     Anusha Srivatsa <anusha.srivatsa@intel.com>,
        stable@vger.kernel.org, Lucas De Marchi <lucas.demarchi@intel.com>
Subject: [PATCH] drm/i915/dmc: Add MMIO range restrictions
Date:   Tue, 26 Apr 2022 17:35:09 -0700
Message-Id: <20220427003509.267683-1-anusha.srivatsa@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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

BSpec: 49193

Cc: <stable@vger.kernel.org>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Anusha Srivatsa <anusha.srivatsa@intel.com>
---
 drivers/gpu/drm/i915/display/intel_dmc.c      | 48 ++++++++++++++++---
 drivers/gpu/drm/i915/display/intel_dmc_regs.h | 31 ++++++++++++
 2 files changed, 72 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_dmc.c b/drivers/gpu/drm/i915/display/intel_dmc.c
index 257cf662f9f4..ac7896835bfa 100644
--- a/drivers/gpu/drm/i915/display/intel_dmc.c
+++ b/drivers/gpu/drm/i915/display/intel_dmc.c
@@ -97,13 +97,6 @@ MODULE_FIRMWARE(SKL_DMC_PATH);
 #define BXT_DMC_MAX_FW_SIZE		0x3000
 MODULE_FIRMWARE(BXT_DMC_PATH);
 
-#define DMC_DEFAULT_FW_OFFSET		0xFFFFFFFF
-#define PACKAGE_MAX_FW_INFO_ENTRIES	20
-#define PACKAGE_V2_MAX_FW_INFO_ENTRIES	32
-#define DMC_V1_MAX_MMIO_COUNT		8
-#define DMC_V3_MAX_MMIO_COUNT		20
-#define DMC_V1_MMIO_START_RANGE		0x80000
-
 struct intel_css_header {
 	/* 0x09 for DMC */
 	u32 module_type;
@@ -374,6 +367,43 @@ static void dmc_set_fw_offset(struct intel_dmc *dmc,
 	}
 }
 
+static bool dmc_mmio_addr_sanity_check(struct intel_dmc *dmc, const u32 *mmioaddr,
+				       u32 mmio_count, int header_ver, u8 dmc_id)
+{
+	struct drm_i915_private *i915 = container_of(dmc, typeof(*i915), dmc);
+	int i;
+
+	if (header_ver == 1) {
+		for (i = 0; i < mmio_count; i++) {
+			if (mmioaddr[i] < DMC_MMIO_START_RANGE || mmioaddr[i] > DMC_MMIO_END_RANGE)
+				return false;
+		}
+	}
+
+	/* Main DMC MMIO check */
+	if (dmc_id == DMC_FW_MAIN) {
+		for (i = 0; i < mmio_count; i++) {
+			if (mmioaddr[i] < TGL_DMC_MMIO_START(dmc_id) || mmioaddr[i] > TGL_DMC_MMIO_END(dmc_id))
+				return false;
+		}
+	}
+
+	/* Pipe DMC MMIO check */
+	if (IS_DG2(i915) || IS_ALDERLAKE_P(i915)) {
+		for (i = 0; i < mmio_count; i++) {
+			if (mmioaddr[i] < ADLP_PIPE_MMIO_START && mmioaddr[i] > ADLP_PIPE_MMIO_END)
+				return false;
+		}
+	} else if (IS_TIGERLAKE(i915) || IS_DG1(i915) || IS_ALDERLAKE_S(i915)) {
+		for (i = 0; i < mmio_count; i++) {
+			if (mmioaddr[i] < TGL_DMC_MMIO_START(dmc_id) || mmioaddr[i] > TGL_DMC_MMIO_END(dmc_id))
+				return false;
+		}
+	}
+
+	return true;
+}
+
 static u32 parse_dmc_fw_header(struct intel_dmc *dmc,
 			       const struct intel_dmc_header_base *dmc_header,
 			       size_t rem_size, u8 dmc_id)
@@ -443,6 +473,10 @@ static u32 parse_dmc_fw_header(struct intel_dmc *dmc,
 		return 0;
 	}
 
+	if (!dmc_mmio_addr_sanity_check(dmc, mmioaddr, mmio_count, dmc_header->header_ver, dmc_id))
+		drm_err(&i915->drm, "DMC firmware has Wrong MMIO Addresses\n");
+		return 0;
+
 	for (i = 0; i < mmio_count; i++) {
 		dmc_info->mmioaddr[i] = _MMIO(mmioaddr[i]);
 		dmc_info->mmiodata[i] = mmiodata[i];
diff --git a/drivers/gpu/drm/i915/display/intel_dmc_regs.h b/drivers/gpu/drm/i915/display/intel_dmc_regs.h
index d65e698832eb..235d1b721334 100644
--- a/drivers/gpu/drm/i915/display/intel_dmc_regs.h
+++ b/drivers/gpu/drm/i915/display/intel_dmc_regs.h
@@ -11,12 +11,43 @@
 #define DMC_PROGRAM(addr, i)	_MMIO((addr) + (i) * 4)
 #define DMC_SSP_BASE_ADDR_GEN9	0x00002FC0
 #define DMC_HTP_ADDR_SKL	0x00500034
+#define DMC_DEFAULT_FW_OFFSET	0xFFFFFFFF
 #define DMC_SSP_BASE		_MMIO(0x8F074)
 #define DMC_HTP_SKL		_MMIO(0x8F004)
 #define DMC_LAST_WRITE		_MMIO(0x8F034)
 #define DMC_LAST_WRITE_VALUE	0xc003b400
 #define DMC_MMIO_START_RANGE	0x80000
 #define DMC_MMIO_END_RANGE	0x8FFFF
+#define PACKAGE_MAX_FW_INFO_ENTRIES	20
+#define PACKAGE_V2_MAX_FW_INFO_ENTRIES	32
+#define DMC_V1_MAX_MMIO_COUNT		8
+#define DMC_V3_MAX_MMIO_COUNT		20
+#define DMC_V1_MMIO_START_RANGE		0x80000
+#define _TGL_MAIN_MMIO_START		0x8F000
+#define _TGL_MAIN_MMIO_END		0x8FFFF
+#define _TGL_PIPEA_MMIO_START		0x92000
+#define _TGL_PIPEA_MMIO_END		0x93FFF
+#define _TGL_PIPEB_MMIO_START		0x96000
+#define _TGL_PIPEB_MMIO_END		0x97FFF
+#define _TGL_PIPEC_MMIO_START		0x9A000
+#define _TGL_PIPEC_MMIO_END		0x9BFFF
+#define _TGL_PIPED_MMIO_START		0x9E000
+#define _TGL_PIPED_MMIO_END		0x9FFFF
+#define ADLP_PIPE_MMIO_START		0x5F000
+#define ADLP_PIPE_MMIO_END		0x5FFFF
+
+#define TGL_DMC_MMIO_START(pipe)	_PICK(pipe, _TGL_MAIN_MMIO_START,\
+					      _TGL_PIPEA_MMIO_START,\
+					      _TGL_PIPEB_MMIO_START,\
+					      _TGL_PIPEC_MMIO_START,\
+					      _TGL_PIPEB_MMIO_START)
+
+#define TGL_DMC_MMIO_END(pipe)		_PICK(pipe, _TGL_MAIN_MMIO_END,\
+					      _TGL_PIPEA_MMIO_END,\
+					      _TGL_PIPEB_MMIO_END,\
+					      _TGL_PIPEC_MMIO_END,\
+					      _TGL_PIPEB_MMIO_END)
+
 #define SKL_DMC_DC3_DC5_COUNT	_MMIO(0x80030)
 #define SKL_DMC_DC5_DC6_COUNT	_MMIO(0x8002C)
 #define BXT_DMC_DC3_DC5_COUNT	_MMIO(0x80038)
-- 
2.25.1

