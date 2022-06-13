Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C942454A03F
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 22:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349069AbiFMUye (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 16:54:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346511AbiFMUxF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 16:53:05 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9171CFFA
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 13:14:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655151282; x=1686687282;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=wcrg5kfG8MZqGU8hkMI9sKsFAm5BOCs7khKirmV/rHY=;
  b=dq1GoozxnlD5KlTxxi9C7esC4rpw6Pxnmbd6vyU18asdpSzceTIekN8F
   8tXviEJ6REuwsep188Z8Pl9FqYl89ZBTnUq70gjuL9hOMutX6bxBNJg7A
   F1NdOz9WrwTuKpzsJA/MKGlYfbr4MHYRCONaA1+hw9KI0KxkaXNtEG7Ob
   0kAg04E0yEintMfKe8T7onnQqUVBd2X9bt1YiK11sXnrPxNl1KCAZKcsV
   URUQM+rG2GVEJBmqAQbDRh5whYmZeRWbvVHLmPPqE5iXlomFa9SLtFo3b
   Ob7eXJQ5LM8u4bha2FWolkGbXdrGZcA1geANssjhHjTIvsvG8FNwchhUl
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10377"; a="279121809"
X-IronPort-AV: E=Sophos;i="5.91,297,1647327600"; 
   d="scan'208";a="279121809"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2022 13:14:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,297,1647327600"; 
   d="scan'208";a="611931676"
Received: from stinkpipe.fi.intel.com (HELO stinkbox) ([10.237.72.163])
  by orsmga008.jf.intel.com with SMTP; 13 Jun 2022 13:14:40 -0700
Received: by stinkbox (sSMTP sendmail emulation); Mon, 13 Jun 2022 23:14:39 +0300
From:   Ville Syrjala <ville.syrjala@linux.intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
Subject: [PATCH] drm/i915: Implement w/a 22010492432 for adl-s
Date:   Mon, 13 Jun 2022 23:14:39 +0300
Message-Id: <20220613201439.23341-1-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

adl-s needs the combo PLL DCO fraction w/a as well.
Get us slightly more accurate clock out of the PLL.

Cc: stable@vger.kernel.org
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
 drivers/gpu/drm/i915/display/intel_dpll_mgr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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
 
-- 
2.35.1

