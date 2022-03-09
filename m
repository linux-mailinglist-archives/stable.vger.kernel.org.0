Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71DCE4D380B
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 18:46:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236914AbiCIRKW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 12:10:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237722AbiCIRJ6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 12:09:58 -0500
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56D7D15C180
        for <stable@vger.kernel.org>; Wed,  9 Mar 2022 09:00:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646845257; x=1678381257;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JnZK9lhqJlBQXkkW/PBBapPtcaoeiSrz/+63+mzioOg=;
  b=EH0nZdsh/7FSbqcxx7MJOosFqSnGk9IphWrs03Tox5jkl7swOJZUdlE7
   SJgsQNtj2AbrEF3qyLCWRvamQiH+NHAFmXlFUqg365tyl/i/N9DA1LHJy
   TE/TyK3B7xfyYoLJMsBg6YcGjTvjter8ifE2j5qFpJzkdZzc9jRfSyxkG
   O5Ly+viK4BxQpm4lXSfoObcBRJcvSIZmTGShZCbDpBDHC15nQHbwTftzr
   aK6YTLvptfHCDg/Yx1lSBpmN0+KkdT1rKSGiVsn5kjx7sDtVa1Y0glhMk
   jWR/0ANBxqYJPa3Eoh7zHSv5tK3E0UAr/XVtFrD57utmtA48DQEEbvcSY
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10281"; a="315747090"
X-IronPort-AV: E=Sophos;i="5.90,167,1643702400"; 
   d="scan'208";a="315747090"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2022 08:49:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,167,1643702400"; 
   d="scan'208";a="554190099"
Received: from stinkpipe.fi.intel.com (HELO stinkbox) ([10.237.72.151])
  by orsmga008.jf.intel.com with SMTP; 09 Mar 2022 08:49:52 -0800
Received: by stinkbox (sSMTP sendmail emulation); Wed, 09 Mar 2022 18:49:51 +0200
From:   Ville Syrjala <ville.syrjala@linux.intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
Subject: [PATCH v2 1/8] drm/i915: Treat SAGV block time 0 as SAGV disabled
Date:   Wed,  9 Mar 2022 18:49:41 +0200
Message-Id: <20220309164948.10671-2-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220309164948.10671-1-ville.syrjala@linux.intel.com>
References: <20220309164948.10671-1-ville.syrjala@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

For modern platforms the spec explicitly states that a
SAGV block time of zero means that SAGV is not supported.
Let's extend that to all platforms. Supposedly there should
be no systems where this isn't true, and it'll allow us to:
- use the same code regardless of older vs. newer platform
- wm latencies already treat 0 as disabled, so this fits well
  with other related code
- make it a bit more clear when SAGV is used vs. not
- avoid overflows from adding U32_MAX with a u16 wm0 latency value
  which could cause us to miscalculate the SAGV watermarks on tgl+

Cc: stable@vger.kernel.org
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
 drivers/gpu/drm/i915/intel_pm.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
index 8ee31c9590a7..40a3094e55ca 100644
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -3696,8 +3696,7 @@ skl_setup_sagv_block_time(struct drm_i915_private *dev_priv)
 		MISSING_CASE(DISPLAY_VER(dev_priv));
 	}
 
-	/* Default to an unusable block time */
-	dev_priv->sagv_block_time_us = -1;
+	dev_priv->sagv_block_time_us = 0;
 }
 
 /*
@@ -5644,7 +5643,7 @@ static void skl_compute_plane_wm(const struct intel_crtc_state *crtc_state,
 	result->min_ddb_alloc = max(min_ddb_alloc, blocks) + 1;
 	result->enable = true;
 
-	if (DISPLAY_VER(dev_priv) < 12)
+	if (DISPLAY_VER(dev_priv) < 12 && dev_priv->sagv_block_time_us)
 		result->can_sagv = latency >= dev_priv->sagv_block_time_us;
 }
 
@@ -5677,7 +5676,10 @@ static void tgl_compute_sagv_wm(const struct intel_crtc_state *crtc_state,
 	struct drm_i915_private *dev_priv = to_i915(crtc_state->uapi.crtc->dev);
 	struct skl_wm_level *sagv_wm = &plane_wm->sagv.wm0;
 	struct skl_wm_level *levels = plane_wm->wm;
-	unsigned int latency = dev_priv->wm.skl_latency[0] + dev_priv->sagv_block_time_us;
+	unsigned int latency = 0;
+
+	if (dev_priv->sagv_block_time_us)
+		latency = dev_priv->sagv_block_time_us + dev_priv->wm.skl_latency[0];
 
 	skl_compute_plane_wm(crtc_state, plane, 0, latency,
 			     wm_params, &levels[0],
-- 
2.34.1

