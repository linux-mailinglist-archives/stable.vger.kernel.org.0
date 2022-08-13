Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D692591A3F
	for <lists+stable@lfdr.de>; Sat, 13 Aug 2022 14:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239465AbiHMMsZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Aug 2022 08:48:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239464AbiHMMsY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Aug 2022 08:48:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E152513F4F
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 05:48:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A3350B8013C
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 12:48:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C637C433C1;
        Sat, 13 Aug 2022 12:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660394901;
        bh=6xDw9Isplz2u44N7kioN7BMU66JBqqIEPuIF2HRA21M=;
        h=Subject:To:Cc:From:Date:From;
        b=bcuekApfR2UOkp+NYOVwHwuHEbYb8VfmrO+fVXwcg2UE1FvSYY53mfIMbUgIqh4vG
         HIfNe5g3l2lA2hR7ETVjnzVSNBTxxaQ/LmJvDC6ls3fR0JzNny1N9wcHtkU3Y81tIO
         v5NWS5hHpD6Rya2edr/WylmSM45jxp6IhKVQW5hU=
Subject: FAILED: patch "[PATCH] drm/i915: Implement w/a 22010492432 for adl-s" failed to apply to 5.15-stable tree
To:     ville.syrjala@linux.intel.com, matthew.d.roper@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 13 Aug 2022 14:48:03 +0200
Message-ID: <1660394883134129@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d36bdd77b9e6aa7f5cb7b0f11ebbab8e5febf10b Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>
Date: Mon, 13 Jun 2022 23:14:39 +0300
Subject: [PATCH] drm/i915: Implement w/a 22010492432 for adl-s
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

adl-s needs the combo PLL DCO fraction w/a as well.
Gets us slightly more accurate clock out of the PLL.

Cc: stable@vger.kernel.org
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220613201439.23341-1-ville.syrjala@linux.intel.com
Reviewed-by: Matt Roper <matthew.d.roper@intel.com>

diff --git a/drivers/gpu/drm/i915/display/intel_dpll_mgr.c b/drivers/gpu/drm/i915/display/intel_dpll_mgr.c
index 64708e874b13..982e5b945680 100644
--- a/drivers/gpu/drm/i915/display/intel_dpll_mgr.c
+++ b/drivers/gpu/drm/i915/display/intel_dpll_mgr.c
@@ -2459,7 +2459,7 @@ static void icl_wrpll_params_populate(struct skl_wrpll_params *params,
 }
 
 /*
- * Display WA #22010492432: ehl, tgl, adl-p
+ * Display WA #22010492432: ehl, tgl, adl-s, adl-p
  * Program half of the nominal DCO divider fraction value.
  */
 static bool
@@ -2467,7 +2467,7 @@ ehl_combo_pll_div_frac_wa_needed(struct drm_i915_private *i915)
 {
 	return ((IS_PLATFORM(i915, INTEL_ELKHARTLAKE) &&
 		 IS_JSL_EHL_DISPLAY_STEP(i915, STEP_B0, STEP_FOREVER)) ||
-		 IS_TIGERLAKE(i915) || IS_ALDERLAKE_P(i915)) &&
+		 IS_TIGERLAKE(i915) || IS_ALDERLAKE_S(i915) || IS_ALDERLAKE_P(i915)) &&
 		 i915->dpll.ref_clks.nssc == 38400;
 }
 

