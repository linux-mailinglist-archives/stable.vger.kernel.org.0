Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86A364B8F8B
	for <lists+stable@lfdr.de>; Wed, 16 Feb 2022 18:43:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237293AbiBPRnO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Feb 2022 12:43:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233989AbiBPRnN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Feb 2022 12:43:13 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 091F5166A7E
        for <stable@vger.kernel.org>; Wed, 16 Feb 2022 09:43:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645033381; x=1676569381;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=p7jz2CooDnh3wCTyjwRbD6RPNbUIngB4BJvAiEu3ohY=;
  b=WEdi3Etk5AXNHupQok0QT/36TLkGpsTs+PY/bwK+s2D2BgWkfrB1tPYd
   tpqU/PtGBgFyHyAclDUU4ahvlXoai/3U3wiV76S5G5+TrSktJhZxzjmD1
   uPUvS6T5BzJCT+3ZvBhLy2XekewiDaro13D5l1iXQ8uOYRR1mnWhJvOfd
   UeAeQGUt7S2Bvi14lqN5jyG8G6JTaCptQOSjxvNrx6NIjxRUC1l8SbPvA
   b5i0KFmbqX54Uf1NG+MJtciZ38ZSGehEkHJLMRlbdT+dyHnKKD0U3sq3y
   XBhd1eif1waA6frM8waH9M6nPsHaFGrvkvwfyNJP8UbGuNVPpAnYtHyX5
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10260"; a="249513930"
X-IronPort-AV: E=Sophos;i="5.88,374,1635231600"; 
   d="scan'208";a="249513930"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2022 09:43:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,374,1635231600"; 
   d="scan'208";a="540228132"
Received: from stinkpipe.fi.intel.com (HELO stinkbox) ([10.237.72.151])
  by fmsmga007.fm.intel.com with SMTP; 16 Feb 2022 09:42:58 -0800
Received: by stinkbox (sSMTP sendmail emulation); Wed, 16 Feb 2022 19:42:57 +0200
From:   Ville Syrjala <ville.syrjala@linux.intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org,
        Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>
Subject: [PATCH v2 2/6] drm/i915: Fix bw atomic check when switching between SAGV vs. no SAGV
Date:   Wed, 16 Feb 2022 19:42:46 +0200
Message-Id: <20220216174250.4449-3-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220216174250.4449-1-ville.syrjala@linux.intel.com>
References: <20220216174250.4449-1-ville.syrjala@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

If the only thing that is changing is SAGV vs. no SAGV but
the number of active planes and the total data rates end up
unchanged we currently bail out of intel_bw_atomic_check()
early and forget to actually compute the new WGV point
mask and thus won't actually enable/disable SAGV as requested.
This ends up poorly if we end up running with SAGV enabled
when we shouldn't. Usually ends up in underruns.
To fix this let's go through the QGV point mask computation
if anyone else already added the bw state for us.

Cc: stable@vger.kernel.org
Cc: Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>
Fixes: 20f505f22531 ("drm/i915: Restrict qgv points which don't have enough bandwidth.")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
 drivers/gpu/drm/i915/display/intel_bw.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/i915/display/intel_bw.c b/drivers/gpu/drm/i915/display/intel_bw.c
index 23aa8e06de18..d72ccee7d53b 100644
--- a/drivers/gpu/drm/i915/display/intel_bw.c
+++ b/drivers/gpu/drm/i915/display/intel_bw.c
@@ -846,6 +846,13 @@ int intel_bw_atomic_check(struct intel_atomic_state *state)
 	if (num_psf_gv_points > 0)
 		mask |= REG_GENMASK(num_psf_gv_points - 1, 0) << ADLS_PSF_PT_SHIFT;
 
+	/*
+	 * If we already have the bw state then recompute everything
+	 * even if pipe data_rate / active_planes didn't change.
+	 * Other things (such as SAGV) may have changed.
+	 */
+	new_bw_state = intel_atomic_get_new_bw_state(state);
+
 	for_each_oldnew_intel_crtc_in_state(state, crtc, old_crtc_state,
 					    new_crtc_state, i) {
 		unsigned int old_data_rate =
-- 
2.34.1

