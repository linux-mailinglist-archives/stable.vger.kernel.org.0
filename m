Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC6C1517652
	for <lists+stable@lfdr.de>; Mon,  2 May 2022 20:09:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345339AbiEBSM7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 May 2022 14:12:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238752AbiEBSM6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 May 2022 14:12:58 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65847BC3A
        for <stable@vger.kernel.org>; Mon,  2 May 2022 11:09:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651514968; x=1683050968;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=j2yzUHcMo4x2VhHghlF0OghtX1mJ9ps8inCAL59a7Jk=;
  b=gXzrtyc6ew7zMabW+pPJ08UMzbWwEI+I+w1aSGewZQGF73JD7dgX44GX
   9MlxIzzXvPw/KVmMO8vJ6VMPK+sDIWfrHrR6ppFO1xswgY423ZsTm/XS4
   VABemgKGc/2ljk1u9Gf3wgXCbtpwyjuRWMqJNyRHi6WOZkhOcCjJZIqj2
   5g+yg/sUueld3/0Vr1cGK6AIqIRtPW+mwlOVN4p74uXcPl0WL8MA1LfQk
   enLOHCwmQ+geo0zv8xcRz7H9arENnQ3zQ8lTVokfG0qAgzukVk7LiAMD+
   H9hSKjdYrKCjijzo5XOLFYf5G/20IjBS5O+PP4+hd2d46wRZSS3JF9kCd
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10335"; a="254746731"
X-IronPort-AV: E=Sophos;i="5.91,192,1647327600"; 
   d="scan'208";a="254746731"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2022 11:09:28 -0700
X-IronPort-AV: E=Sophos;i="5.91,192,1647327600"; 
   d="scan'208";a="535972177"
Received: from ldmartin-desk2.jf.intel.com ([134.134.244.76])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2022 11:09:28 -0700
Date:   Mon, 2 May 2022 11:09:26 -0700
From:   Lucas De Marchi <lucas.demarchi@intel.com>
To:     "Srivatsa, Anusha" <anusha.srivatsa@intel.com>
Cc:     "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [Intel-gfx] [PATCH] drm/i915/dmc: Add MMIO range restrictions
Message-ID: <20220502180926.in55znr7wbxjbmax@ldmartin-desk2.jf.intel.com>
References: <20220427003509.267683-1-anusha.srivatsa@intel.com>
 <20220427054154.mrila5bwwk2durvv@ldmartin-desk2>
 <93b22db44cf7494086285212d5d7615a@intel.com>
 <20220429204937.ntnicwggcgobmmon@ldmartin-desk2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220429204937.ntnicwggcgobmmon@ldmartin-desk2>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 29, 2022 at 01:49:37PM -0700, Lucas De Marchi wrote:
>On Fri, Apr 29, 2022 at 01:39:03PM -0700, Anusha Srivatsa wrote:
>>
>>
>>>-----Original Message-----
>>>From: De Marchi, Lucas <lucas.demarchi@intel.com>
>>>Sent: Tuesday, April 26, 2022 10:42 PM
>>>To: Srivatsa, Anusha <anusha.srivatsa@intel.com>
>>>Cc: intel-gfx@lists.freedesktop.org; stable@vger.kernel.org
>>>Subject: Re: [PATCH] drm/i915/dmc: Add MMIO range restrictions
>>>
>>>On Tue, Apr 26, 2022 at 05:35:09PM -0700, Anusha Srivatsa wrote:
>>>>Bspec has added some steps that check forDMC MMIO range before
>>>>programming them
>>>>
>>>>v2: Fix for CI
>>>>v3: move register defines to .h (Anusha)
>>>>- Check MMIO restrictions per pipe
>>>>- Add MMIO restricton for v1 dmc header as well (Lucas)
>>>>
>>>>BSpec: 49193
>>>>
>>>>Cc: <stable@vger.kernel.org>
>>>>Cc: Lucas De Marchi <lucas.demarchi@intel.com>
>>>>Signed-off-by: Anusha Srivatsa <anusha.srivatsa@intel.com>
>>>>---
>>>> drivers/gpu/drm/i915/display/intel_dmc.c      | 48 ++++++++++++++++---
>>>> drivers/gpu/drm/i915/display/intel_dmc_regs.h | 31 ++++++++++++
>>>> 2 files changed, 72 insertions(+), 7 deletions(-)
>>>>
>>>>diff --git a/drivers/gpu/drm/i915/display/intel_dmc.c
>>>>b/drivers/gpu/drm/i915/display/intel_dmc.c
>>>>index 257cf662f9f4..ac7896835bfa 100644
>>>>--- a/drivers/gpu/drm/i915/display/intel_dmc.c
>>>>+++ b/drivers/gpu/drm/i915/display/intel_dmc.c
>>>>@@ -97,13 +97,6 @@ MODULE_FIRMWARE(SKL_DMC_PATH);
>>>> #define BXT_DMC_MAX_FW_SIZE		0x3000
>>>> MODULE_FIRMWARE(BXT_DMC_PATH);
>>>>
>>>>-#define DMC_DEFAULT_FW_OFFSET		0xFFFFFFFF
>>>>-#define PACKAGE_MAX_FW_INFO_ENTRIES	20
>>>>-#define PACKAGE_V2_MAX_FW_INFO_ENTRIES	32
>>>>-#define DMC_V1_MAX_MMIO_COUNT		8
>>>>-#define DMC_V3_MAX_MMIO_COUNT		20
>>>>-#define DMC_V1_MMIO_START_RANGE		0x80000
>>>>-
>>>> struct intel_css_header {
>>>> 	/* 0x09 for DMC */
>>>> 	u32 module_type;
>>>>@@ -374,6 +367,43 @@ static void dmc_set_fw_offset(struct intel_dmc
>>>*dmc,
>>>> 	}
>>>> }
>>>>
>>>>+static bool dmc_mmio_addr_sanity_check(struct intel_dmc *dmc, const
>>>u32 *mmioaddr,
>>>>+				       u32 mmio_count, int header_ver, u8
>>>dmc_id) {
>>>>+	struct drm_i915_private *i915 = container_of(dmc, typeof(*i915),
>>>dmc);
>>>>+	int i;
>>>>+
>>>>+	if (header_ver == 1) {
>>>>+		for (i = 0; i < mmio_count; i++) {
>>>>+			if (mmioaddr[i] < DMC_MMIO_START_RANGE ||
>>>mmioaddr[i] > DMC_MMIO_END_RANGE)
>>>>+				return false;
>>>>+		}
>>>
>>>return missing here
>>>
>>>>+	}
>>>>+
>>>>+	/* Main DMC MMIO check */
>>>>+	if (dmc_id == DMC_FW_MAIN) {
>>>>+		for (i = 0; i < mmio_count; i++) {
>>>>+			if (mmioaddr[i] < TGL_DMC_MMIO_START(dmc_id)
>>>|| mmioaddr[i] > TGL_DMC_MMIO_END(dmc_id))
>>>>+				return false;
>>>>+		}
>>>>+	}
>>>>+
>>>>+	/* Pipe DMC MMIO check */
>>>>+	if (IS_DG2(i915) || IS_ALDERLAKE_P(i915)) {
>>>>+		for (i = 0; i < mmio_count; i++) {
>>>>+			if (mmioaddr[i] < ADLP_PIPE_MMIO_START &&
>>>mmioaddr[i] > ADLP_PIPE_MMIO_END)
>>>>+				return false;
>>>>+		}
>>>
>>>for DG2, main should use TGL_DMC_MMIO_START? and then fail here
>>>because of another missing return above?
>>>
>>>>+	} else if (IS_TIGERLAKE(i915) || IS_DG1(i915) ||
>>>IS_ALDERLAKE_S(i915)) {
>>>>+		for (i = 0; i < mmio_count; i++) {
>>>>+			if (mmioaddr[i] < TGL_DMC_MMIO_START(dmc_id)
>>>|| mmioaddr[i] > TGL_DMC_MMIO_END(dmc_id))
>>>>+				return false;
>>>
>>>this is handling DMC_FW_MAIN twice.
>>>
>>>
>>>Maybe something like this:
>>>
>>>	u32 start, end;
>>>
>>>	if (header_ver == 1) {
>>>		start = DMC_MMIO_START_RANGE;
>>>		end = DMC_MMIO_END_RANGE;
>>>	} else if (dmc_id == DMC_FW_MAIN || IS_TIGERLAKE(i915) ||
>>>IS_DG1(i915) || IS_ALDERLAKE_S(i915)) {
>>>		start = TGL_DMC_MMIO_START(dmc_id);
>>>		end = TGL_DMC_MMIO_END(dmc_id);
>>>	} else if (IS_DG2(i915) || IS_ALDERLAKE_P(i915)) {
>>>		start = ADLP_PIPE_MMIO_START;
>>>		end = ADLP_PIPE_MMIO_END;
>>>	} else {
>>>		drm_warn(&i915->drm, "Unknown mmio range for sanity
>>>check");
>>>		return false;
>>>	}
>>>
>>>	for (i = 0; i < mmio_count; i++)
>>>		if (mmioaddr[i] < start || mmioaddr[i] > end)
>>>			return false;
>>>
>>>	return true;
>>>
>>>
>>>... untested, and may need tweaks depending on the answer to the question
>>>above on what range to use for ADL-P/DG2 on main DMC.
>>The above approach is definitely neater.
>>The main DMC offset is the same for all platforms.
>>
>>>>+		}
>>>>+	}
>>>>+
>>>>+	return true;
>>>>+}
>>>>+
>>>> static u32 parse_dmc_fw_header(struct intel_dmc *dmc,
>>>> 			       const struct intel_dmc_header_base
>>>*dmc_header,
>>>> 			       size_t rem_size, u8 dmc_id)
>>>>@@ -443,6 +473,10 @@ static u32 parse_dmc_fw_header(struct intel_dmc
>>>*dmc,
>>>> 		return 0;
>>>> 	}
>>>>
>>>>+	if (!dmc_mmio_addr_sanity_check(dmc, mmioaddr, mmio_count,
>>>dmc_header->header_ver, dmc_id))
>>>>+		drm_err(&i915->drm, "DMC firmware has Wrong MMIO
>>>Addresses\n");
>>>>+		return 0;
>>>
>>>you don't like DMC and decided to fail it for all platforms?
>>
>><facepalm>
>>
>>>>+
>>>> 	for (i = 0; i < mmio_count; i++) {
>>>> 		dmc_info->mmioaddr[i] = _MMIO(mmioaddr[i]);
>>>> 		dmc_info->mmiodata[i] = mmiodata[i]; diff --git
>>>>a/drivers/gpu/drm/i915/display/intel_dmc_regs.h
>>>>b/drivers/gpu/drm/i915/display/intel_dmc_regs.h
>>>>index d65e698832eb..235d1b721334 100644
>>>>--- a/drivers/gpu/drm/i915/display/intel_dmc_regs.h
>>>>+++ b/drivers/gpu/drm/i915/display/intel_dmc_regs.h
>>>>@@ -11,12 +11,43 @@
>>>> #define DMC_PROGRAM(addr, i)	_MMIO((addr) + (i) * 4)
>>>> #define DMC_SSP_BASE_ADDR_GEN9	0x00002FC0
>>>> #define DMC_HTP_ADDR_SKL	0x00500034
>>>>+#define DMC_DEFAULT_FW_OFFSET	0xFFFFFFFF
>>>> #define DMC_SSP_BASE		_MMIO(0x8F074)
>>>> #define DMC_HTP_SKL		_MMIO(0x8F004)
>>>> #define DMC_LAST_WRITE		_MMIO(0x8F034)
>>>> #define DMC_LAST_WRITE_VALUE	0xc003b400
>>>> #define DMC_MMIO_START_RANGE	0x80000
>>>> #define DMC_MMIO_END_RANGE	0x8FFFF
>>>>+#define PACKAGE_MAX_FW_INFO_ENTRIES	20
>>>>+#define PACKAGE_V2_MAX_FW_INFO_ENTRIES	32
>>>>+#define DMC_V1_MAX_MMIO_COUNT		8
>>>>+#define DMC_V3_MAX_MMIO_COUNT		20
>>>
>>>
>>>why are you moving these to _regs?  these describe the DMC header/blob
>>
>>Yeah my mistake. While making the change they seemed like the right thing to do.
>>
>>>
>>>>+#define DMC_V1_MMIO_START_RANGE		0x80000
>>>>+#define _TGL_MAIN_MMIO_START		0x8F000
>>>>+#define _TGL_MAIN_MMIO_END		0x8FFFF
>>>>+#define _TGL_PIPEA_MMIO_START		0x92000
>>>>+#define _TGL_PIPEA_MMIO_END		0x93FFF
>>>>+#define _TGL_PIPEB_MMIO_START		0x96000
>>>>+#define _TGL_PIPEB_MMIO_END		0x97FFF
>>>>+#define _TGL_PIPEC_MMIO_START		0x9A000
>>>>+#define _TGL_PIPEC_MMIO_END		0x9BFFF
>>>>+#define _TGL_PIPED_MMIO_START		0x9E000
>>>>+#define _TGL_PIPED_MMIO_END		0x9FFFF
>>>>+#define ADLP_PIPE_MMIO_START		0x5F000
>>>>+#define ADLP_PIPE_MMIO_END		0x5FFFF
>>>>+
>>>>+#define TGL_DMC_MMIO_START(pipe)	_PICK(pipe,
>>>_TGL_MAIN_MMIO_START,\
>>>
>>>_PICK?  Did you miss my previous review?
>>
>>No. the thing is Main DMC with the Pipe DMCs are not evenly spaced. So using PICK_EVEN is not the right choice here. We also don't need to do _MMIO really.....
>>Unless I am missing something, this seems like the right approach.
>
>Because the name you chose for your variable:
>
>	TGL_DMC_MMIO_START(pipe)   _PICK(pipe,
>
>I was expecting this to be used only with the pipe DMC address, which
>are evenly spaced. It seems the argument you're expecting here is a
>dmc_id. But.... you said:
>
>>The main DMC offset is the same for all platforms.
>
>So, maybe just handle that separately and keep using pipe here? Then you
>can switch to _PICK_EVEN()

usually we have helper functions/macros to do that kind of conversion.

dmc_id to pipe is id - 1. *With the proper range checks* somewhere to
ensure you aren't accessing the wrong address you could even embed the
conversion:

#define TGL_PIPE_DMC_MMIO_START(dmc_id)   _PICK_EVEN((dmc_id - 1), ...

or add a helper macro to avoid the repetition and document what this is
about.

Lucas De Marchi
