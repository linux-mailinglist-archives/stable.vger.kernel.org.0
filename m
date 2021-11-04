Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA0194454C6
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 15:15:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231561AbhKDORe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 10:17:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:45250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231654AbhKDORP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Nov 2021 10:17:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E858C611EF;
        Thu,  4 Nov 2021 14:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636035277;
        bh=NSLu/JAumQCLcYGAUPGREwCup2BuiHoPuWBWOjdSVdA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GqPznRnUArVnoQBqHRQ4alWiR0S6VUV+Z2HVCx3U4+yX5JxgYP3tXocBR4S9tx2AF
         TzFVV5rjOON5MzNoesJTKajn1C9cAUNbpudAALTTIMxEl6VPwgdbnhS+q5cNzACygT
         Y/jLF0DNAagw2L5rs774vsmiBVLSV2co42/7P2Ig=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yakui Zhao <yakui.zhao@intel.com>,
        Matt Roper <matthew.d.roper@intel.com>,
        =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.14 08/16] drm/i915: Remove memory frequency calculation
Date:   Thu,  4 Nov 2021 15:12:39 +0100
Message-Id: <20211104141200.123252846@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211104141159.863820939@linuxfoundation.org>
References: <20211104141159.863820939@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: José Roberto de Souza <jose.souza@intel.com>

commit 59be177a909ac320e5f4b2a461ac09e20f35b2d8 upstream.

This memory frequency calculated is only used to check if it is zero,
what is not useful as it will never actually be zero.

Also the calculation is wrong, we should be checking other bit to
select the appropriate frequency multiplier while this code is stuck
with a fixed multiplier.

So here dropping it as whole.

v2:
- Also remove memory frequency calculation for gen9 LP platforms

Cc: Yakui Zhao <yakui.zhao@intel.com>
Cc: Matt Roper <matthew.d.roper@intel.com>
Fixes: 5d0c938ec9cc ("drm/i915/gen11+: Only load DRAM information from pcode")
Signed-off-by: José Roberto de Souza <jose.souza@intel.com>
Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20211013010046.91858-1-jose.souza@intel.com
(cherry picked from commit 83f52364b15265aec47d07e02b0fbf4093ab8554)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_reg.h   |    8 --------
 drivers/gpu/drm/i915/intel_dram.c |   30 ++----------------------------
 2 files changed, 2 insertions(+), 36 deletions(-)

--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -11021,12 +11021,6 @@ enum skl_power_gate {
 #define  DC_STATE_DEBUG_MASK_CORES	(1 << 0)
 #define  DC_STATE_DEBUG_MASK_MEMORY_UP	(1 << 1)
 
-#define BXT_P_CR_MC_BIOS_REQ_0_0_0	_MMIO(MCHBAR_MIRROR_BASE_SNB + 0x7114)
-#define  BXT_REQ_DATA_MASK			0x3F
-#define  BXT_DRAM_CHANNEL_ACTIVE_SHIFT		12
-#define  BXT_DRAM_CHANNEL_ACTIVE_MASK		(0xF << 12)
-#define  BXT_MEMORY_FREQ_MULTIPLIER_HZ		133333333
-
 #define BXT_D_CR_DRP0_DUNIT8			0x1000
 #define BXT_D_CR_DRP0_DUNIT9			0x1200
 #define  BXT_D_CR_DRP0_DUNIT_START		8
@@ -11057,9 +11051,7 @@ enum skl_power_gate {
 #define  BXT_DRAM_TYPE_LPDDR4			(0x2 << 22)
 #define  BXT_DRAM_TYPE_DDR4			(0x4 << 22)
 
-#define SKL_MEMORY_FREQ_MULTIPLIER_HZ		266666666
 #define SKL_MC_BIOS_DATA_0_0_0_MCHBAR_PCU	_MMIO(MCHBAR_MIRROR_BASE_SNB + 0x5E04)
-#define  SKL_REQ_DATA_MASK			(0xF << 0)
 
 #define SKL_MAD_INTER_CHANNEL_0_0_0_MCHBAR_MCMAIN _MMIO(MCHBAR_MIRROR_BASE_SNB + 0x5000)
 #define  SKL_DRAM_DDR_TYPE_MASK			(0x3 << 0)
--- a/drivers/gpu/drm/i915/intel_dram.c
+++ b/drivers/gpu/drm/i915/intel_dram.c
@@ -244,7 +244,6 @@ static int
 skl_get_dram_info(struct drm_i915_private *i915)
 {
 	struct dram_info *dram_info = &i915->dram_info;
-	u32 mem_freq_khz, val;
 	int ret;
 
 	dram_info->type = skl_get_dram_type(i915);
@@ -255,17 +254,6 @@ skl_get_dram_info(struct drm_i915_privat
 	if (ret)
 		return ret;
 
-	val = intel_uncore_read(&i915->uncore,
-				SKL_MC_BIOS_DATA_0_0_0_MCHBAR_PCU);
-	mem_freq_khz = DIV_ROUND_UP((val & SKL_REQ_DATA_MASK) *
-				    SKL_MEMORY_FREQ_MULTIPLIER_HZ, 1000);
-
-	if (dram_info->num_channels * mem_freq_khz == 0) {
-		drm_info(&i915->drm,
-			 "Couldn't get system memory bandwidth\n");
-		return -EINVAL;
-	}
-
 	return 0;
 }
 
@@ -350,24 +338,10 @@ static void bxt_get_dimm_info(struct dra
 static int bxt_get_dram_info(struct drm_i915_private *i915)
 {
 	struct dram_info *dram_info = &i915->dram_info;
-	u32 dram_channels;
-	u32 mem_freq_khz, val;
-	u8 num_active_channels, valid_ranks = 0;
+	u32 val;
+	u8 valid_ranks = 0;
 	int i;
 
-	val = intel_uncore_read(&i915->uncore, BXT_P_CR_MC_BIOS_REQ_0_0_0);
-	mem_freq_khz = DIV_ROUND_UP((val & BXT_REQ_DATA_MASK) *
-				    BXT_MEMORY_FREQ_MULTIPLIER_HZ, 1000);
-
-	dram_channels = val & BXT_DRAM_CHANNEL_ACTIVE_MASK;
-	num_active_channels = hweight32(dram_channels);
-
-	if (mem_freq_khz * num_active_channels == 0) {
-		drm_info(&i915->drm,
-			 "Couldn't get system memory bandwidth\n");
-		return -EINVAL;
-	}
-
 	/*
 	 * Now read each DUNIT8/9/10/11 to check the rank of each dimms.
 	 */


