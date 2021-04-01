Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B6E335238B
	for <lists+stable@lfdr.de>; Fri,  2 Apr 2021 01:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233921AbhDAX3d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Apr 2021 19:29:33 -0400
Received: from mga03.intel.com ([134.134.136.65]:22738 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233789AbhDAX3d (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 1 Apr 2021 19:29:33 -0400
IronPort-SDR: CEMdTKRDVfj/Rf6XetxxvRVvpuChQjMhnq9PIUe2SrXQ0KfK37u9urKXTAa/jB6xOM7/26MEiF
 r6N8Y/Sm8IHQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9941"; a="192383410"
X-IronPort-AV: E=Sophos;i="5.81,298,1610438400"; 
   d="scan'208";a="192383410"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2021 16:29:33 -0700
IronPort-SDR: xzzskEUFVez2QdPtQ7zIC+1eGopM2Z0YWqucbPYvllnxvZ+4qPNHZEhw8OauPPeqKZUIn4HF4t
 NKt+bKyRNI3Q==
X-IronPort-AV: E=Sophos;i="5.81,298,1610438400"; 
   d="scan'208";a="419410716"
Received: from ideak-desk.fi.intel.com ([10.237.68.141])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2021 16:29:31 -0700
From:   Imre Deak <imre.deak@intel.com>
To:     gfx-internal-devel@eclists.intel.com
Cc:     Takashi Iwai <tiwai@suse.de>,
        Santiago Zarate <santiago.zarate@suse.com>,
        Bodo Graumann <mail@bodograumann.de>, stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>
Subject: [PATCH 1/3] drm/i915/ilk-glk: Fix link training on links with LTTPRs
Date:   Fri,  2 Apr 2021 02:29:24 +0300
Message-Id: <20210401232927.1711811-2-imre.deak@intel.com>
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

The spec requires to use at least 3.2ms for the AUX timeout period if
there are LT-tunable PHY Repeaters on the link (2.11.2). An upcoming
spec update makes this more specific, by requiring a 3.2ms minimum
timeout period for the LTTPR detection reading the 0xF0000-0xF0007
range (3.6.5.1).

Accordingly disable LTTPR detection until GLK, where the maximum timeout
we can set is only 1.6ms.

Link training in the non-transparent mode is known to fail at least on
some SKL systems with a WD19 dock on the link, which exposes an LTTPR
(see the References below). While this could have different reasons
besides the too short AUX timeout used, not detecting LTTPRs (and so not
using the non-transparent LT mode) fixes link training on these systems.

While at it add a code comment about the platform specific maximum
timeout values.

v2: Add a comment about the g4x maximum timeout as well. (Ville)

Reported-by: Takashi Iwai <tiwai@suse.de>
Reported-and-tested-by: Santiago Zarate <santiago.zarate@suse.com>
Reported-and-tested-by: Bodo Graumann <mail@bodograumann.de>
References: https://gitlab.freedesktop.org/drm/intel/-/issues/3166
Fixes: b30edfd8d0b4 ("drm/i915: Switch to LTTPR non-transparent mode link training")
Cc: <stable@vger.kernel.org> # v5.11
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210317184901.4029798-2-imre.deak@intel.com
(cherry picked from commit 984982f3ef7b240cd24c2feb2762d81d9d8da3c2)
---
 drivers/gpu/drm/i915/display/intel_dp_aux.c       |  7 +++++++
 .../gpu/drm/i915/display/intel_dp_link_training.c | 15 ++++++++++++---
 2 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_dp_aux.c b/drivers/gpu/drm/i915/display/intel_dp_aux.c
index eaebf123310a..10fe17b7280d 100644
--- a/drivers/gpu/drm/i915/display/intel_dp_aux.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_aux.c
@@ -133,6 +133,7 @@ static u32 g4x_get_aux_send_ctl(struct intel_dp *intel_dp,
 	else
 		precharge = 5;
 
+	/* Max timeout value on G4x-BDW: 1.6ms */
 	if (IS_BROADWELL(dev_priv))
 		timeout = DP_AUX_CH_CTL_TIME_OUT_600us;
 	else
@@ -159,6 +160,12 @@ static u32 skl_get_aux_send_ctl(struct intel_dp *intel_dp,
 	enum phy phy = intel_port_to_phy(i915, dig_port->base.port);
 	u32 ret;
 
+	/*
+	 * Max timeout values:
+	 * SKL-GLK: 1.6ms
+	 * CNL: 3.2ms
+	 * ICL+: 4ms
+	 */
 	ret = DP_AUX_CH_CTL_SEND_BUSY |
 	      DP_AUX_CH_CTL_DONE |
 	      DP_AUX_CH_CTL_INTERRUPT |
diff --git a/drivers/gpu/drm/i915/display/intel_dp_link_training.c b/drivers/gpu/drm/i915/display/intel_dp_link_training.c
index 892d7db7d94f..35cda72492d7 100644
--- a/drivers/gpu/drm/i915/display/intel_dp_link_training.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_link_training.c
@@ -81,6 +81,18 @@ static void intel_dp_read_lttpr_phy_caps(struct intel_dp *intel_dp,
 
 static bool intel_dp_read_lttpr_common_caps(struct intel_dp *intel_dp)
 {
+	struct drm_i915_private *i915 = dp_to_i915(intel_dp);
+
+	if (intel_dp_is_edp(intel_dp))
+		return false;
+
+	/*
+	 * Detecting LTTPRs must be avoided on platforms with an AUX timeout
+	 * period < 3.2ms. (see DP Standard v2.0, 2.11.2, 3.6.6.1).
+	 */
+	if (INTEL_GEN(i915) < 10)
+		return false;
+
 	if (drm_dp_read_lttpr_common_caps(&intel_dp->aux,
 					  intel_dp->lttpr_common_caps) < 0) {
 		memset(intel_dp->lttpr_common_caps, 0,
@@ -126,9 +138,6 @@ int intel_dp_lttpr_init(struct intel_dp *intel_dp)
 	bool ret;
 	int i;
 
-	if (intel_dp_is_edp(intel_dp))
-		return 0;
-
 	ret = intel_dp_read_lttpr_common_caps(intel_dp);
 	if (!ret)
 		return 0;
