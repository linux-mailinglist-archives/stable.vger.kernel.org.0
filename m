Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C67B02FE63E
	for <lists+stable@lfdr.de>; Thu, 21 Jan 2021 10:22:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728474AbhAUJV5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jan 2021 04:21:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:41894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728383AbhAUJVl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 Jan 2021 04:21:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5DD762395A;
        Thu, 21 Jan 2021 09:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611220858;
        bh=Ny1jGTuvmijljUHkCpNQfb40xdnkqS7RhGcjw3Z6mKw=;
        h=From:To:Cc:Subject:Date:From;
        b=mwvcsZNsrAjXMeBVD1cqm2o//a2q7fkvW8QGAmwrUYlFkxL77CavBnKS7/zAX+QUj
         CkCYlMqGqJZ9GaHDwUeGul9DIE9JY35r03T2mjWvb99IiBdy3W4exm1qwf6ZCkzGoC
         5t0LK3peQl4rG3stXhAGQep10sjUSy67x31p6Uf+8dL3QHrxjqDkOk6dryytA0KF8P
         64AiS1qktsyEkikf7OEoBNH4VhtrdxJBez7nf72tjYr2WTGnTtgc/58tEKU23uhgND
         G6fDCsbKdX6OH3w26BVeRC5ASIMTwfQJJnbiidZSM3CvttFBXg0/+4LcWytzFSZ/JL
         srL9PdME/uZlg==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        amd-gfx@lists.freedesktop.org,
        Alex Deucher <alexander.deucher@amd.com>,
        Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH -stable] drm/amdgpu/display: drop DCN support for aarch64
Date:   Thu, 21 Jan 2021 10:20:40 +0100
Message-Id: <20210121092040.110267-1-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

commit c241ed2f0ea549c18cff62a3708b43846b84dae3 upstream.

From Ard:

"Simply disabling -mgeneral-regs-only left and right is risky, given that
the standard AArch64 ABI permits the use of FP/SIMD registers anywhere,
and GCC is known to use SIMD registers for spilling, and may invent
other uses of the FP/SIMD register file that have nothing to do with the
floating point code in question. Note that putting kernel_neon_begin()
and kernel_neon_end() around the code that does use FP is not sufficient
here, the problem is in all the other code that may be emitted with
references to SIMD registers in it.

So the only way to do this properly is to put all floating point code in
a separate compilation unit, and only compile that unit with
-mgeneral-regs-only."

Disable support until the code can be properly refactored to support this
properly on aarch64.

Acked-by: Will Deacon <will@kernel.org>
Reported-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[ardb: backport to v5.10 by reverting c38d444e44badc55 instead]
Acked-by: Alex Deucher <alexander.deucher@amd.com> # v5.10 backport
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
The original commit does not apply cleanly to v5.10, as it reverts a
combination of patches, some of which are not present in v5.10.

This patch is a straight revert of c38d444e44badc55, which is the only
change that needs to be backed out from v5.10, and amounts to the same
thing as the original mainline commit.

 drivers/gpu/drm/amd/display/Kconfig                   |  2 +-
 drivers/gpu/drm/amd/display/dc/calcs/Makefile         |  7 --
 drivers/gpu/drm/amd/display/dc/clk_mgr/Makefile       |  7 --
 drivers/gpu/drm/amd/display/dc/dcn10/Makefile         |  7 --
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_resource.c | 81 ++++++++------------
 drivers/gpu/drm/amd/display/dc/dcn20/Makefile         |  4 -
 drivers/gpu/drm/amd/display/dc/dcn21/Makefile         |  4 -
 drivers/gpu/drm/amd/display/dc/dml/Makefile           | 13 ----
 drivers/gpu/drm/amd/display/dc/dsc/Makefile           |  5 --
 drivers/gpu/drm/amd/display/dc/os_types.h             |  4 -
 10 files changed, 32 insertions(+), 102 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/Kconfig b/drivers/gpu/drm/amd/display/Kconfig
index 60dfdd432aba..3c410d236c49 100644
--- a/drivers/gpu/drm/amd/display/Kconfig
+++ b/drivers/gpu/drm/amd/display/Kconfig
@@ -6,7 +6,7 @@ config DRM_AMD_DC
 	bool "AMD DC - Enable new display engine"
 	default y
 	select SND_HDA_COMPONENT if SND_HDA_CORE
-	select DRM_AMD_DC_DCN if (X86 || PPC64 || (ARM64 && KERNEL_MODE_NEON)) && !(KCOV_INSTRUMENT_ALL && KCOV_ENABLE_COMPARISONS)
+	select DRM_AMD_DC_DCN if (X86 || PPC64) && !(KCOV_INSTRUMENT_ALL && KCOV_ENABLE_COMPARISONS)
 	help
 	  Choose this option if you want to use the new display engine
 	  support for AMDGPU. This adds required support for Vega and
diff --git a/drivers/gpu/drm/amd/display/dc/calcs/Makefile b/drivers/gpu/drm/amd/display/dc/calcs/Makefile
index 64f515d74410..4674aca8f206 100644
--- a/drivers/gpu/drm/amd/display/dc/calcs/Makefile
+++ b/drivers/gpu/drm/amd/display/dc/calcs/Makefile
@@ -33,10 +33,6 @@ ifdef CONFIG_PPC64
 calcs_ccflags := -mhard-float -maltivec
 endif
 
-ifdef CONFIG_ARM64
-calcs_rcflags := -mgeneral-regs-only
-endif
-
 ifdef CONFIG_CC_IS_GCC
 ifeq ($(call cc-ifversion, -lt, 0701, y), y)
 IS_OLD_GCC = 1
@@ -57,9 +53,6 @@ endif
 CFLAGS_$(AMDDALPATH)/dc/calcs/dcn_calcs.o := $(calcs_ccflags)
 CFLAGS_$(AMDDALPATH)/dc/calcs/dcn_calc_auto.o := $(calcs_ccflags)
 CFLAGS_$(AMDDALPATH)/dc/calcs/dcn_calc_math.o := $(calcs_ccflags) -Wno-tautological-compare
-CFLAGS_REMOVE_$(AMDDALPATH)/dc/calcs/dcn_calcs.o := $(calcs_rcflags)
-CFLAGS_REMOVE_$(AMDDALPATH)/dc/calcs/dcn_calc_auto.o := $(calcs_rcflags)
-CFLAGS_REMOVE_$(AMDDALPATH)/dc/calcs/dcn_calc_math.o := $(calcs_rcflags)
 
 BW_CALCS = dce_calcs.o bw_fixed.o custom_float.o
 
diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/Makefile b/drivers/gpu/drm/amd/display/dc/clk_mgr/Makefile
index 1a495759a034..52b1ce775a1e 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/Makefile
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/Makefile
@@ -104,13 +104,6 @@ ifdef CONFIG_PPC64
 CFLAGS_$(AMDDALPATH)/dc/clk_mgr/dcn21/rn_clk_mgr.o := $(call cc-option,-mno-gnu-attribute)
 endif
 
-# prevent build errors:
-# ...: '-mgeneral-regs-only' is incompatible with the use of floating-point types
-# this file is unused on arm64, just like on ppc64
-ifdef CONFIG_ARM64
-CFLAGS_REMOVE_$(AMDDALPATH)/dc/clk_mgr/dcn21/rn_clk_mgr.o := -mgeneral-regs-only
-endif
-
 AMD_DAL_CLK_MGR_DCN21 = $(addprefix $(AMDDALPATH)/dc/clk_mgr/dcn21/,$(CLK_MGR_DCN21))
 
 AMD_DISPLAY_FILES += $(AMD_DAL_CLK_MGR_DCN21)
diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/Makefile b/drivers/gpu/drm/amd/display/dc/dcn10/Makefile
index 733e6e6e43bd..62ad1a11bff9 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/Makefile
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/Makefile
@@ -31,11 +31,4 @@ DCN10 = dcn10_init.o dcn10_resource.o dcn10_ipp.o dcn10_hw_sequencer.o \
 
 AMD_DAL_DCN10 = $(addprefix $(AMDDALPATH)/dc/dcn10/,$(DCN10))
 
-# fix:
-# ...: '-mgeneral-regs-only' is incompatible with the use of floating-point types
-# aarch64 does not support soft-float, so use hard-float and handle this in code
-ifdef CONFIG_ARM64
-CFLAGS_REMOVE_$(AMDDALPATH)/dc/dcn10/dcn10_resource.o := -mgeneral-regs-only
-endif
-
 AMD_DISPLAY_FILES += $(AMD_DAL_DCN10)
diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_resource.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_resource.c
index a78712caf124..462d3d981ea5 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_resource.c
@@ -1339,47 +1339,6 @@ static uint32_t read_pipe_fuses(struct dc_context *ctx)
 	return value;
 }
 
-/*
- * Some architectures don't support soft-float (e.g. aarch64), on those
- * this function has to be called with hardfloat enabled, make sure not
- * to inline it so whatever fp stuff is done stays inside
- */
-static noinline void dcn10_resource_construct_fp(
-	struct dc *dc)
-{
-	if (dc->ctx->dce_version == DCN_VERSION_1_01) {
-		struct dcn_soc_bounding_box *dcn_soc = dc->dcn_soc;
-		struct dcn_ip_params *dcn_ip = dc->dcn_ip;
-		struct display_mode_lib *dml = &dc->dml;
-
-		dml->ip.max_num_dpp = 3;
-		/* TODO how to handle 23.84? */
-		dcn_soc->dram_clock_change_latency = 23;
-		dcn_ip->max_num_dpp = 3;
-	}
-	if (ASICREV_IS_RV1_F0(dc->ctx->asic_id.hw_internal_rev)) {
-		dc->dcn_soc->urgent_latency = 3;
-		dc->debug.disable_dmcu = true;
-		dc->dcn_soc->fabric_and_dram_bandwidth_vmax0p9 = 41.60f;
-	}
-
-
-	dc->dcn_soc->number_of_channels = dc->ctx->asic_id.vram_width / ddr4_dram_width;
-	ASSERT(dc->dcn_soc->number_of_channels < 3);
-	if (dc->dcn_soc->number_of_channels == 0)/*old sbios bug*/
-		dc->dcn_soc->number_of_channels = 2;
-
-	if (dc->dcn_soc->number_of_channels == 1) {
-		dc->dcn_soc->fabric_and_dram_bandwidth_vmax0p9 = 19.2f;
-		dc->dcn_soc->fabric_and_dram_bandwidth_vnom0p8 = 17.066f;
-		dc->dcn_soc->fabric_and_dram_bandwidth_vmid0p72 = 14.933f;
-		dc->dcn_soc->fabric_and_dram_bandwidth_vmin0p65 = 12.8f;
-		if (ASICREV_IS_RV1_F0(dc->ctx->asic_id.hw_internal_rev)) {
-			dc->dcn_soc->fabric_and_dram_bandwidth_vmax0p9 = 20.80f;
-		}
-	}
-}
-
 static bool dcn10_resource_construct(
 	uint8_t num_virtual_links,
 	struct dc *dc,
@@ -1531,15 +1490,37 @@ static bool dcn10_resource_construct(
 	memcpy(dc->dcn_ip, &dcn10_ip_defaults, sizeof(dcn10_ip_defaults));
 	memcpy(dc->dcn_soc, &dcn10_soc_defaults, sizeof(dcn10_soc_defaults));
 
-#if defined(CONFIG_ARM64)
-	/* Aarch64 does not support -msoft-float/-mfloat-abi=soft */
-	DC_FP_START();
-	dcn10_resource_construct_fp(dc);
-	DC_FP_END();
-#else
-	/* Other architectures we build for build this with soft-float */
-	dcn10_resource_construct_fp(dc);
-#endif
+	if (dc->ctx->dce_version == DCN_VERSION_1_01) {
+		struct dcn_soc_bounding_box *dcn_soc = dc->dcn_soc;
+		struct dcn_ip_params *dcn_ip = dc->dcn_ip;
+		struct display_mode_lib *dml = &dc->dml;
+
+		dml->ip.max_num_dpp = 3;
+		/* TODO how to handle 23.84? */
+		dcn_soc->dram_clock_change_latency = 23;
+		dcn_ip->max_num_dpp = 3;
+	}
+	if (ASICREV_IS_RV1_F0(dc->ctx->asic_id.hw_internal_rev)) {
+		dc->dcn_soc->urgent_latency = 3;
+		dc->debug.disable_dmcu = true;
+		dc->dcn_soc->fabric_and_dram_bandwidth_vmax0p9 = 41.60f;
+	}
+
+
+	dc->dcn_soc->number_of_channels = dc->ctx->asic_id.vram_width / ddr4_dram_width;
+	ASSERT(dc->dcn_soc->number_of_channels < 3);
+	if (dc->dcn_soc->number_of_channels == 0)/*old sbios bug*/
+		dc->dcn_soc->number_of_channels = 2;
+
+	if (dc->dcn_soc->number_of_channels == 1) {
+		dc->dcn_soc->fabric_and_dram_bandwidth_vmax0p9 = 19.2f;
+		dc->dcn_soc->fabric_and_dram_bandwidth_vnom0p8 = 17.066f;
+		dc->dcn_soc->fabric_and_dram_bandwidth_vmid0p72 = 14.933f;
+		dc->dcn_soc->fabric_and_dram_bandwidth_vmin0p65 = 12.8f;
+		if (ASICREV_IS_RV1_F0(dc->ctx->asic_id.hw_internal_rev)) {
+			dc->dcn_soc->fabric_and_dram_bandwidth_vmax0p9 = 20.80f;
+		}
+	}
 
 	pool->base.pp_smu = dcn10_pp_smu_create(ctx);
 
diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/Makefile b/drivers/gpu/drm/amd/display/dc/dcn20/Makefile
index 624cb1341ef1..5fcaf78334ff 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/Makefile
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/Makefile
@@ -17,10 +17,6 @@ ifdef CONFIG_PPC64
 CFLAGS_$(AMDDALPATH)/dc/dcn20/dcn20_resource.o := -mhard-float -maltivec
 endif
 
-ifdef CONFIG_ARM64
-CFLAGS_REMOVE_$(AMDDALPATH)/dc/dcn20/dcn20_resource.o := -mgeneral-regs-only
-endif
-
 ifdef CONFIG_CC_IS_GCC
 ifeq ($(call cc-ifversion, -lt, 0701, y), y)
 IS_OLD_GCC = 1
diff --git a/drivers/gpu/drm/amd/display/dc/dcn21/Makefile b/drivers/gpu/drm/amd/display/dc/dcn21/Makefile
index 51a2f3d4c194..07684d3e375a 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn21/Makefile
+++ b/drivers/gpu/drm/amd/display/dc/dcn21/Makefile
@@ -13,10 +13,6 @@ ifdef CONFIG_PPC64
 CFLAGS_$(AMDDALPATH)/dc/dcn21/dcn21_resource.o := -mhard-float -maltivec
 endif
 
-ifdef CONFIG_ARM64
-CFLAGS_REMOVE_$(AMDDALPATH)/dc/dcn21/dcn21_resource.o := -mgeneral-regs-only
-endif
-
 ifdef CONFIG_CC_IS_GCC
 ifeq ($(call cc-ifversion, -lt, 0701, y), y)
 IS_OLD_GCC = 1
diff --git a/drivers/gpu/drm/amd/display/dc/dml/Makefile b/drivers/gpu/drm/amd/display/dc/dml/Makefile
index dbc7e2abe379..417331438c30 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/Makefile
+++ b/drivers/gpu/drm/amd/display/dc/dml/Makefile
@@ -33,10 +33,6 @@ ifdef CONFIG_PPC64
 dml_ccflags := -mhard-float -maltivec
 endif
 
-ifdef CONFIG_ARM64
-dml_rcflags := -mgeneral-regs-only
-endif
-
 ifdef CONFIG_CC_IS_GCC
 ifeq ($(call cc-ifversion, -lt, 0701, y), y)
 IS_OLD_GCC = 1
@@ -64,13 +60,6 @@ CFLAGS_$(AMDDALPATH)/dc/dml/dcn20/display_mode_vba_20v2.o := $(dml_ccflags)
 CFLAGS_$(AMDDALPATH)/dc/dml/dcn20/display_rq_dlg_calc_20v2.o := $(dml_ccflags)
 CFLAGS_$(AMDDALPATH)/dc/dml/dcn21/display_mode_vba_21.o := $(dml_ccflags)
 CFLAGS_$(AMDDALPATH)/dc/dml/dcn21/display_rq_dlg_calc_21.o := $(dml_ccflags)
-CFLAGS_REMOVE_$(AMDDALPATH)/dc/dml/display_mode_vba.o := $(dml_rcflags)
-CFLAGS_REMOVE_$(AMDDALPATH)/dc/dml/dcn20/display_mode_vba_20.o := $(dml_rcflags)
-CFLAGS_REMOVE_$(AMDDALPATH)/dc/dml/dcn20/display_rq_dlg_calc_20.o := $(dml_rcflags)
-CFLAGS_REMOVE_$(AMDDALPATH)/dc/dml/dcn20/display_mode_vba_20v2.o := $(dml_rcflags)
-CFLAGS_REMOVE_$(AMDDALPATH)/dc/dml/dcn20/display_rq_dlg_calc_20v2.o := $(dml_rcflags)
-CFLAGS_REMOVE_$(AMDDALPATH)/dc/dml/dcn21/display_mode_vba_21.o := $(dml_rcflags)
-CFLAGS_REMOVE_$(AMDDALPATH)/dc/dml/dcn21/display_rq_dlg_calc_21.o := $(dml_rcflags)
 endif
 ifdef CONFIG_DRM_AMD_DC_DCN3_0
 CFLAGS_$(AMDDALPATH)/dc/dml/dcn30/display_mode_vba_30.o := $(dml_ccflags) -Wframe-larger-than=2048
@@ -78,8 +67,6 @@ CFLAGS_$(AMDDALPATH)/dc/dml/dcn30/display_rq_dlg_calc_30.o := $(dml_ccflags)
 endif
 CFLAGS_$(AMDDALPATH)/dc/dml/dml1_display_rq_dlg_calc.o := $(dml_ccflags)
 CFLAGS_$(AMDDALPATH)/dc/dml/display_rq_dlg_helpers.o := $(dml_ccflags)
-CFLAGS_REMOVE_$(AMDDALPATH)/dc/dml/dml1_display_rq_dlg_calc.o := $(dml_rcflags)
-CFLAGS_REMOVE_$(AMDDALPATH)/dc/dml/display_rq_dlg_helpers.o := $(dml_rcflags)
 
 DML = display_mode_lib.o display_rq_dlg_helpers.o dml1_display_rq_dlg_calc.o \
 
diff --git a/drivers/gpu/drm/amd/display/dc/dsc/Makefile b/drivers/gpu/drm/amd/display/dc/dsc/Makefile
index f2624a1156e5..ea29cf95d470 100644
--- a/drivers/gpu/drm/amd/display/dc/dsc/Makefile
+++ b/drivers/gpu/drm/amd/display/dc/dsc/Makefile
@@ -10,10 +10,6 @@ ifdef CONFIG_PPC64
 dsc_ccflags := -mhard-float -maltivec
 endif
 
-ifdef CONFIG_ARM64
-dsc_rcflags := -mgeneral-regs-only
-endif
-
 ifdef CONFIG_CC_IS_GCC
 ifeq ($(call cc-ifversion, -lt, 0701, y), y)
 IS_OLD_GCC = 1
@@ -32,7 +28,6 @@ endif
 endif
 
 CFLAGS_$(AMDDALPATH)/dc/dsc/rc_calc.o := $(dsc_ccflags)
-CFLAGS_REMOVE_$(AMDDALPATH)/dc/dsc/rc_calc.o := $(dsc_rcflags)
 
 DSC = dc_dsc.o rc_calc.o rc_calc_dpi.o
 
diff --git a/drivers/gpu/drm/amd/display/dc/os_types.h b/drivers/gpu/drm/amd/display/dc/os_types.h
index 95cb56929e79..126c2f3a4dd3 100644
--- a/drivers/gpu/drm/amd/display/dc/os_types.h
+++ b/drivers/gpu/drm/amd/display/dc/os_types.h
@@ -55,10 +55,6 @@
 #include <asm/fpu/api.h>
 #define DC_FP_START() kernel_fpu_begin()
 #define DC_FP_END() kernel_fpu_end()
-#elif defined(CONFIG_ARM64)
-#include <asm/neon.h>
-#define DC_FP_START() kernel_neon_begin()
-#define DC_FP_END() kernel_neon_end()
 #elif defined(CONFIG_PPC64)
 #include <asm/switch_to.h>
 #include <asm/cputable.h>
-- 
2.20.1

