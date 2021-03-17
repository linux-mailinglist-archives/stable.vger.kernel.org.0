Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE57D33F86D
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 19:49:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232875AbhCQSt1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Mar 2021 14:49:27 -0400
Received: from mga01.intel.com ([192.55.52.88]:39004 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233102AbhCQStN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Mar 2021 14:49:13 -0400
IronPort-SDR: r1EzNtxadpt1r40/4sRCySAoQQ9NRWzMt3vtXznnDS5IsNWEyvXfqVNl/BizCP5tVkyDg3w+zF
 r5xrYKr129qg==
X-IronPort-AV: E=McAfee;i="6000,8403,9926"; a="209499360"
X-IronPort-AV: E=Sophos;i="5.81,257,1610438400"; 
   d="scan'208";a="209499360"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2021 11:49:09 -0700
IronPort-SDR: Ck7fOKTlmeLNnI9Gznlkbt0fDuYk9ODfx2Seu5E3YNRBeDxLEB8BqyCI42SDeUMt+xw9YOBlX6
 OWhHI/IJ1ROQ==
X-IronPort-AV: E=Sophos;i="5.81,257,1610438400"; 
   d="scan'208";a="511828580"
Received: from ideak-desk.fi.intel.com ([10.237.68.141])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2021 11:49:08 -0700
From:   Imre Deak <imre.deak@intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>
Subject: [PATCH v2 3/3] drm/i915: Disable LTTPR support when the LTTPR rev < 1.4
Date:   Wed, 17 Mar 2021 20:49:01 +0200
Message-Id: <20210317184901.4029798-4-imre.deak@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210317184901.4029798-1-imre.deak@intel.com>
References: <20210317184901.4029798-1-imre.deak@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

By the specification the 0xF0000 - 0xF02FF range is only valid if the
LTTPR revision at 0xF0000 is at least 1.4. Disable the LTTPR support
otherwise.

Fixes: 7b2a4ab8b0ef ("drm/i915: Switch to LTTPR transparent mode link training")
Cc: <stable@vger.kernel.org> # v5.11
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
---
 .../gpu/drm/i915/display/intel_dp_link_training.c  | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_dp_link_training.c b/drivers/gpu/drm/i915/display/intel_dp_link_training.c
index d8d90903226f..d92eb192c89d 100644
--- a/drivers/gpu/drm/i915/display/intel_dp_link_training.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_link_training.c
@@ -100,17 +100,23 @@ static bool intel_dp_read_lttpr_common_caps(struct intel_dp *intel_dp)
 		return false;
 
 	if (drm_dp_read_lttpr_common_caps(&intel_dp->aux,
-					  intel_dp->lttpr_common_caps) < 0) {
-		intel_dp_reset_lttpr_common_caps(intel_dp);
-		return false;
-	}
+					  intel_dp->lttpr_common_caps) < 0)
+		goto reset_caps;
 
 	drm_dbg_kms(&dp_to_i915(intel_dp)->drm,
 		    "LTTPR common capabilities: %*ph\n",
 		    (int)sizeof(intel_dp->lttpr_common_caps),
 		    intel_dp->lttpr_common_caps);
 
+	/* The minimum value of LT_TUNABLE_PHY_REPEATER_FIELD_DATA_STRUCTURE_REV is 1.4 */
+	if (intel_dp->lttpr_common_caps[0] < 0x14)
+		goto reset_caps;
+
 	return true;
+
+reset_caps:
+	intel_dp_reset_lttpr_common_caps(intel_dp);
+	return false;
 }
 
 static bool
-- 
2.25.1

