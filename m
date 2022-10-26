Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3172C60DEA5
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 12:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232994AbiJZKLs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 06:11:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233295AbiJZKLr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 06:11:47 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D4F4923E8
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 03:11:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666779107; x=1698315107;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gm81K3zHMYhRuY91zbvRhsMMAkuy90BAvGBGbHXSJ1w=;
  b=NGJufgXguzUmL1WQCTMxKZ8II2HUzaN3qA3RodPjwfVazufyyveMypPD
   4WgeMMRwzNladCz/ml7WOXM1zMH0Ag8eGeB/wJLLQTKARqPgDJy4zVk/m
   E3JGGZI3g3ZmJQYH4xgTuQPByBm9ntgris4uJv23GyW6tTz3sjdsld7RB
   o5b2OvyXMD/Z/UDi/UR3ZgEDlaUYHu9Q+PxiEpCuY6udL2TW8yLbquTK+
   YAmvBnIwzEzN7kdJivORof+loCfh7dz9Vtj0kfPyJ1bhzNrl+wq0MbzOQ
   JJHRqAW6WRqYwVaZkj4akEDh4npvpU1uqYGQCore+kXwTD3Cayl85jn5k
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10511"; a="291213370"
X-IronPort-AV: E=Sophos;i="5.95,214,1661842800"; 
   d="scan'208";a="291213370"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2022 03:11:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10511"; a="695305878"
X-IronPort-AV: E=Sophos;i="5.95,214,1661842800"; 
   d="scan'208";a="695305878"
Received: from stinkpipe.fi.intel.com (HELO stinkbox) ([10.237.72.191])
  by fmsmga008.fm.intel.com with SMTP; 26 Oct 2022 03:11:44 -0700
Received: by stinkbox (sSMTP sendmail emulation); Wed, 26 Oct 2022 13:11:43 +0300
From:   Ville Syrjala <ville.syrjala@linux.intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
Subject: [PATCH 3/8] drm/i915/sdvo: Grab mode_config.mutex during LVDS init to avoid WARNs
Date:   Wed, 26 Oct 2022 13:11:29 +0300
Message-Id: <20221026101134.20865-4-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 2.37.4
In-Reply-To: <20221026101134.20865-1-ville.syrjala@linux.intel.com>
References: <20221026101134.20865-1-ville.syrjala@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

drm_mode_probed_add() is unhappy about being called w/o
mode_config.mutex. Grab it during LVDS fixed mode setup
to silence the WARNs.

Cc: stable@vger.kernel.org
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/7301
Fixes: aa2b88074a56 ("drm/i915/sdvo: Fix multi function encoder stuff")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
 drivers/gpu/drm/i915/display/intel_sdvo.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/i915/display/intel_sdvo.c b/drivers/gpu/drm/i915/display/intel_sdvo.c
index ccf81d616cb4..1eaaa7ec580e 100644
--- a/drivers/gpu/drm/i915/display/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/display/intel_sdvo.c
@@ -2899,8 +2899,12 @@ intel_sdvo_lvds_init(struct intel_sdvo *intel_sdvo, int device)
 	intel_panel_add_vbt_sdvo_fixed_mode(intel_connector);
 
 	if (!intel_panel_preferred_fixed_mode(intel_connector)) {
+		mutex_lock(&i915->drm.mode_config.mutex);
+
 		intel_ddc_get_modes(connector, &intel_sdvo->ddc);
 		intel_panel_add_edid_fixed_modes(intel_connector, false);
+
+		mutex_unlock(&i915->drm.mode_config.mutex);
 	}
 
 	intel_panel_init(intel_connector);
-- 
2.37.4

