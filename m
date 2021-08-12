Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72AA63EA4DB
	for <lists+stable@lfdr.de>; Thu, 12 Aug 2021 14:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237146AbhHLMsO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Aug 2021 08:48:14 -0400
Received: from mga05.intel.com ([192.55.52.43]:40725 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233260AbhHLMsO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Aug 2021 08:48:14 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10073"; a="300927763"
X-IronPort-AV: E=Sophos;i="5.84,315,1620716400"; 
   d="scan'208";a="300927763"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2021 05:47:48 -0700
X-IronPort-AV: E=Sophos;i="5.84,315,1620716400"; 
   d="scan'208";a="527809569"
Received: from linux-x299-aorus-gaming-3-pro.iind.intel.com ([10.223.34.130])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2021 05:47:45 -0700
From:   Swati Sharma <swati2.sharma@intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     Swati Sharma <swati2.sharma@intel.com>,
        Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
        Uma Shankar <uma.shankar@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        "Ville Syrj_l_" <ville.syrjala@linux.intel.com>,
        Imre Deak <imre.deak@intel.com>,
        Manasi Navare <manasi.d.navare@intel.com>,
        "Jos_ Roberto de Souza" <jose.souza@intel.com>,
        Sean Paul <seanpaul@chromium.org>, stable@vger.kernel.org
Subject: [PATCH] drm/i915/display: Drop redundant debug print
Date:   Thu, 12 Aug 2021 18:28:45 +0530
Message-Id: <20210812125845.27787-1-swati2.sharma@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

drm_dp_dpcd_read/write already has debug error message.
Drop redundant error messages which gives false
status even if correct value is read in drm_dp_dpcd_read().

Fixes: 9488a030ac91 ("drm/i915: Add support for enabling link status and recovery")
Cc: Swati Sharma <swati2.sharma@intel.com>
Cc: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Cc: Uma Shankar <uma.shankar@intel.com> (v2)
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: "Ville Syrj_l_" <ville.syrjala@linux.intel.com>
Cc: Imre Deak <imre.deak@intel.com>
Cc: Manasi Navare <manasi.d.navare@intel.com>
Cc: Uma Shankar <uma.shankar@intel.com>
Cc: "Jos_ Roberto de Souza" <jose.souza@intel.com>
Cc: Sean Paul <seanpaul@chromium.org>
Cc: <stable@vger.kernel.org> # v5.12+

Link: https://patchwork.freedesktop.org/patch/msgid/20201218103723.30844-12-ankit.k.nautiyal@intel.com
Signed-off-by: Swati Sharma <swati2.sharma@intel.com>
---
 drivers/gpu/drm/i915/display/intel_dp.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_dp.c b/drivers/gpu/drm/i915/display/intel_dp.c
index c386ef8eb200..5c84f51ad41d 100644
--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -3871,16 +3871,12 @@ static void intel_dp_check_link_service_irq(struct intel_dp *intel_dp)
 		return;
 
 	if (drm_dp_dpcd_readb(&intel_dp->aux,
-			      DP_LINK_SERVICE_IRQ_VECTOR_ESI0, &val) != 1 || !val) {
-		drm_dbg_kms(&i915->drm, "Error in reading link service irq vector\n");
+			      DP_LINK_SERVICE_IRQ_VECTOR_ESI0, &val) != 1 || !val)
 		return;
-	}
 
 	if (drm_dp_dpcd_writeb(&intel_dp->aux,
-			       DP_LINK_SERVICE_IRQ_VECTOR_ESI0, val) != 1) {
-		drm_dbg_kms(&i915->drm, "Error in writing link service irq vector\n");
+			       DP_LINK_SERVICE_IRQ_VECTOR_ESI0, val) != 1)
 		return;
-	}
 
 	if (val & HDMI_LINK_STATUS_CHANGED)
 		intel_dp_handle_hdmi_link_status_change(intel_dp);
-- 
2.25.1

