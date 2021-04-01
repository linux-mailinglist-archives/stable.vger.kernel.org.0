Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A6EF35238D
	for <lists+stable@lfdr.de>; Fri,  2 Apr 2021 01:29:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234043AbhDAX3g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Apr 2021 19:29:36 -0400
Received: from mga03.intel.com ([134.134.136.65]:22738 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233789AbhDAX3f (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 1 Apr 2021 19:29:35 -0400
IronPort-SDR: iLWeD33xoiWQ0aictwjbqaxVxArZj565RVOyXLMZbO5KRg4QqxKnn7+JIwcJMa8Y90+qanX8gX
 PJmeAvj8WGdQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9941"; a="192383419"
X-IronPort-AV: E=Sophos;i="5.81,298,1610438400"; 
   d="scan'208";a="192383419"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2021 16:29:35 -0700
IronPort-SDR: wY8ru5DBgv/HsSc2BcI93gx5TmlchX6Bi8a8p8IoBzj63emzHA5R99q3oCfeKsejdTZNyUmv+l
 4MjEdK1jsNZQ==
X-IronPort-AV: E=Sophos;i="5.81,298,1610438400"; 
   d="scan'208";a="419410729"
Received: from ideak-desk.fi.intel.com ([10.237.68.141])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2021 16:29:34 -0700
From:   Imre Deak <imre.deak@intel.com>
To:     gfx-internal-devel@eclists.intel.com
Cc:     stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>
Subject: [PATCH 3/3] drm/i915: Disable LTTPR support when the LTTPR rev < 1.4
Date:   Fri,  2 Apr 2021 02:29:26 +0300
Message-Id: <20210401232927.1711811-4-imre.deak@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210401232927.1711811-1-imre.deak@intel.com>
References: <20210401232927.1711811-1-imre.deak@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Git-Pile: INTEL_DII
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
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210317184901.4029798-4-imre.deak@intel.com
(cherry picked from commit 1663ad4936e0679443a315fe342f99636a2420dd)
---
 .../gpu/drm/i915/display/intel_dp_link_training.c  | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_dp_link_training.c b/drivers/gpu/drm/i915/display/intel_dp_link_training.c
index c10e81a3d64f..be6ac0dd846e 100644
--- a/drivers/gpu/drm/i915/display/intel_dp_link_training.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_link_training.c
@@ -99,17 +99,23 @@ static bool intel_dp_read_lttpr_common_caps(struct intel_dp *intel_dp)
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
