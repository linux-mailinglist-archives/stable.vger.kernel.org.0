Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE1D51109A
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 07:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355410AbiD0FpF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 01:45:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbiD0FpF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 01:45:05 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7676715780E
        for <stable@vger.kernel.org>; Tue, 26 Apr 2022 22:41:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651038115; x=1682574115;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=jEErSTSwvO2esYC39wj6u0JtnM2vBVUe/X9VDAalVtc=;
  b=jjxgJnb3IM6k3RwPmx8LLdGODa9c3fy50TxLt50fMgc1nZOCXoK3Ddjh
   T4todn+Zja2sJkUVr/FZfRI7UU+iMrjuAorX+vpjGR1ySbKVi5Q53L16D
   OQKjvSzNQEs2YoaYLkOTDEdPVALlCvd0gXK0IwphjiLnrJyACizyRgzgV
   sMAgDoqPSEwFopxJNwdMBelD5Nl5yKRwx5fzl809qPwYT6ELuPaASFJ62
   J0aXFX+zyea/t2AXzKBPgj94GeqhPHdgY2BbBhTFgJn9ePUck0LZo7ov2
   Z2DSHqw7ryCyxRmqdYZ43HjjYmP/igzN0GmppRA/N0hggLGlfWOmebbXk
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10329"; a="265346095"
X-IronPort-AV: E=Sophos;i="5.90,292,1643702400"; 
   d="scan'208";a="265346095"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2022 22:41:55 -0700
X-IronPort-AV: E=Sophos;i="5.90,292,1643702400"; 
   d="scan'208";a="539548258"
Received: from gforcumx-mobl1.amr.corp.intel.com (HELO ldmartin-desk2) ([10.209.84.57])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2022 22:41:54 -0700
Date:   Tue, 26 Apr 2022 22:41:54 -0700
From:   Lucas De Marchi <lucas.demarchi@intel.com>
To:     Anusha Srivatsa <anusha.srivatsa@intel.com>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [PATCH] drm/i915/dmc: Add MMIO range restrictions
Message-ID: <20220427054154.mrila5bwwk2durvv@ldmartin-desk2>
X-Patchwork-Hint: comment
References: <20220427003509.267683-1-anusha.srivatsa@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220427003509.267683-1-anusha.srivatsa@intel.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 26, 2022 at 05:35:09PM -0700, Anusha Srivatsa wrote:
>Bspec has added some steps that check forDMC MMIO range before
>programming them
>
>v2: Fix for CI
>v3: move register defines to .h (Anusha)
>- Check MMIO restrictions per pipe
>- Add MMIO restricton for v1 dmc header as well (Lucas)
>
>BSpec: 49193
>
>Cc: <stable@vger.kernel.org>
>Cc: Lucas De Marchi <lucas.demarchi@intel.com>
>Signed-off-by: Anusha Srivatsa <anusha.srivatsa@intel.com>
>---
> drivers/gpu/drm/i915/display/intel_dmc.c      | 48 ++++++++++++++++---
> drivers/gpu/drm/i915/display/intel_dmc_regs.h | 31 ++++++++++++
> 2 files changed, 72 insertions(+), 7 deletions(-)
>
>diff --git a/drivers/gpu/drm/i915/display/intel_dmc.c b/drivers/gpu/drm/i915/display/intel_dmc.c
>index 257cf662f9f4..ac7896835bfa 100644
>--- a/drivers/gpu/drm/i915/display/intel_dmc.c
>+++ b/drivers/gpu/drm/i915/display/intel_dmc.c
>@@ -97,13 +97,6 @@ MODULE_FIRMWARE(SKL_DMC_PATH);
> #define BXT_DMC_MAX_FW_SIZE		0x3000
> MODULE_FIRMWARE(BXT_DMC_PATH);
>
>-#define DMC_DEFAULT_FW_OFFSET		0xFFFFFFFF
>-#define PACKAGE_MAX_FW_INFO_ENTRIES	20
>-#define PACKAGE_V2_MAX_FW_INFO_ENTRIES	32
>-#define DMC_V1_MAX_MMIO_COUNT		8
>-#define DMC_V3_MAX_MMIO_COUNT		20
>-#define DMC_V1_MMIO_START_RANGE		0x80000
>-
> struct intel_css_header {
> 	/* 0x09 for DMC */
> 	u32 module_type;
>@@ -374,6 +367,43 @@ static void dmc_set_fw_offset(struct intel_dmc *dmc,
> 	}
> }
>
>+static bool dmc_mmio_addr_sanity_check(struct intel_dmc *dmc, const u32 *mmioaddr,
>+				       u32 mmio_count, int header_ver, u8 dmc_id)
>+{
>+	struct drm_i915_private *i915 = container_of(dmc, typeof(*i915), dmc);
>+	int i;
>+
>+	if (header_ver == 1) {
>+		for (i = 0; i < mmio_count; i++) {
>+			if (mmioaddr[i] < DMC_MMIO_START_RANGE || mmioaddr[i] > DMC_MMIO_END_RANGE)
>+				return false;
>+		}

return missing here

>+	}
>+
>+	/* Main DMC MMIO check */
>+	if (dmc_id == DMC_FW_MAIN) {
>+		for (i = 0; i < mmio_count; i++) {
>+			if (mmioaddr[i] < TGL_DMC_MMIO_START(dmc_id) || mmioaddr[i] > TGL_DMC_MMIO_END(dmc_id))
>+				return false;
>+		}
>+	}
>+
>+	/* Pipe DMC MMIO check */
>+	if (IS_DG2(i915) || IS_ALDERLAKE_P(i915)) {
>+		for (i = 0; i < mmio_count; i++) {
>+			if (mmioaddr[i] < ADLP_PIPE_MMIO_START && mmioaddr[i] > ADLP_PIPE_MMIO_END)
>+				return false;
>+		}

for DG2, main should use TGL_DMC_MMIO_START? and then fail here because
of another missing return above?

>+	} else if (IS_TIGERLAKE(i915) || IS_DG1(i915) || IS_ALDERLAKE_S(i915)) {
>+		for (i = 0; i < mmio_count; i++) {
>+			if (mmioaddr[i] < TGL_DMC_MMIO_START(dmc_id) || mmioaddr[i] > TGL_DMC_MMIO_END(dmc_id))
>+				return false;

this is handling DMC_FW_MAIN twice.


Maybe something like this:

	u32 start, end;

	if (header_ver == 1) {
		start = DMC_MMIO_START_RANGE;
		end = DMC_MMIO_END_RANGE;
	} else if (dmc_id == DMC_FW_MAIN || IS_TIGERLAKE(i915) || IS_DG1(i915) || IS_ALDERLAKE_S(i915)) {
		start = TGL_DMC_MMIO_START(dmc_id);
		end = TGL_DMC_MMIO_END(dmc_id);
	} else if (IS_DG2(i915) || IS_ALDERLAKE_P(i915)) {
		start = ADLP_PIPE_MMIO_START;
		end = ADLP_PIPE_MMIO_END;
	} else {
		drm_warn(&i915->drm, "Unknown mmio range for sanity check");
		return false;
	}

	for (i = 0; i < mmio_count; i++)
		if (mmioaddr[i] < start || mmioaddr[i] > end)
			return false;

	return true;


... untested, and may need tweaks depending on the answer to the
question above on what range to use for ADL-P/DG2 on main DMC.

>+		}
>+	}
>+
>+	return true;
>+}
>+
> static u32 parse_dmc_fw_header(struct intel_dmc *dmc,
> 			       const struct intel_dmc_header_base *dmc_header,
> 			       size_t rem_size, u8 dmc_id)
>@@ -443,6 +473,10 @@ static u32 parse_dmc_fw_header(struct intel_dmc *dmc,
> 		return 0;
> 	}
>
>+	if (!dmc_mmio_addr_sanity_check(dmc, mmioaddr, mmio_count, dmc_header->header_ver, dmc_id))
>+		drm_err(&i915->drm, "DMC firmware has Wrong MMIO Addresses\n");
>+		return 0;

you don't like DMC and decided to fail it for all platforms?

>+
> 	for (i = 0; i < mmio_count; i++) {
> 		dmc_info->mmioaddr[i] = _MMIO(mmioaddr[i]);
> 		dmc_info->mmiodata[i] = mmiodata[i];
>diff --git a/drivers/gpu/drm/i915/display/intel_dmc_regs.h b/drivers/gpu/drm/i915/display/intel_dmc_regs.h
>index d65e698832eb..235d1b721334 100644
>--- a/drivers/gpu/drm/i915/display/intel_dmc_regs.h
>+++ b/drivers/gpu/drm/i915/display/intel_dmc_regs.h
>@@ -11,12 +11,43 @@
> #define DMC_PROGRAM(addr, i)	_MMIO((addr) + (i) * 4)
> #define DMC_SSP_BASE_ADDR_GEN9	0x00002FC0
> #define DMC_HTP_ADDR_SKL	0x00500034
>+#define DMC_DEFAULT_FW_OFFSET	0xFFFFFFFF
> #define DMC_SSP_BASE		_MMIO(0x8F074)
> #define DMC_HTP_SKL		_MMIO(0x8F004)
> #define DMC_LAST_WRITE		_MMIO(0x8F034)
> #define DMC_LAST_WRITE_VALUE	0xc003b400
> #define DMC_MMIO_START_RANGE	0x80000
> #define DMC_MMIO_END_RANGE	0x8FFFF
>+#define PACKAGE_MAX_FW_INFO_ENTRIES	20
>+#define PACKAGE_V2_MAX_FW_INFO_ENTRIES	32
>+#define DMC_V1_MAX_MMIO_COUNT		8
>+#define DMC_V3_MAX_MMIO_COUNT		20


why are you moving these to _regs?  these describe the DMC header/blob


>+#define DMC_V1_MMIO_START_RANGE		0x80000
>+#define _TGL_MAIN_MMIO_START		0x8F000
>+#define _TGL_MAIN_MMIO_END		0x8FFFF
>+#define _TGL_PIPEA_MMIO_START		0x92000
>+#define _TGL_PIPEA_MMIO_END		0x93FFF
>+#define _TGL_PIPEB_MMIO_START		0x96000
>+#define _TGL_PIPEB_MMIO_END		0x97FFF
>+#define _TGL_PIPEC_MMIO_START		0x9A000
>+#define _TGL_PIPEC_MMIO_END		0x9BFFF
>+#define _TGL_PIPED_MMIO_START		0x9E000
>+#define _TGL_PIPED_MMIO_END		0x9FFFF
>+#define ADLP_PIPE_MMIO_START		0x5F000
>+#define ADLP_PIPE_MMIO_END		0x5FFFF
>+
>+#define TGL_DMC_MMIO_START(pipe)	_PICK(pipe, _TGL_MAIN_MMIO_START,\

_PICK?  Did you miss my previous review?

Lucas De Marchi

>+					      _TGL_PIPEA_MMIO_START,\
>+					      _TGL_PIPEB_MMIO_START,\
>+					      _TGL_PIPEC_MMIO_START,\
>+					      _TGL_PIPEB_MMIO_START)
>+
>+#define TGL_DMC_MMIO_END(pipe)		_PICK(pipe, _TGL_MAIN_MMIO_END,\
>+					      _TGL_PIPEA_MMIO_END,\
>+					      _TGL_PIPEB_MMIO_END,\
>+					      _TGL_PIPEC_MMIO_END,\
>+					      _TGL_PIPEB_MMIO_END)
>+
> #define SKL_DMC_DC3_DC5_COUNT	_MMIO(0x80030)
> #define SKL_DMC_DC5_DC6_COUNT	_MMIO(0x8002C)
> #define BXT_DMC_DC3_DC5_COUNT	_MMIO(0x80038)
>-- 
>2.25.1
>
