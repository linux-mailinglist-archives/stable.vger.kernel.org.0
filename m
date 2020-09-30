Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83C1C27F535
	for <lists+stable@lfdr.de>; Thu,  1 Oct 2020 00:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730862AbgI3Wgt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Sep 2020 18:36:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:34919 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730703AbgI3Wgt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Sep 2020 18:36:49 -0400
IronPort-SDR: ICxDLxehVP+2eOk6Ccg0JHKjvck/04Z3UozRNRv6D+y0uCI+kOwdfxIoz0Qm6CkIDmqjQr2Tmp
 +2v2a5049gOw==
X-IronPort-AV: E=McAfee;i="6000,8403,9760"; a="180721167"
X-IronPort-AV: E=Sophos;i="5.77,322,1596524400"; 
   d="scan'208";a="180721167"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2020 15:36:45 -0700
IronPort-SDR: O9ga1uLoeGm5G/hO+TKRJ73W1UcfzHv3xYOyGu1jV6Zcx32IfLp9cOJtH41BTR1X2YKlKi+OxV
 FKzAksqYhcKA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,322,1596524400"; 
   d="scan'208";a="312757391"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.174])
  by orsmga006.jf.intel.com with SMTP; 30 Sep 2020 15:36:43 -0700
Received: by stinkbox (sSMTP sendmail emulation); Thu, 01 Oct 2020 01:36:42 +0300
From:   Ville Syrjala <ville.syrjala@linux.intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org,
        Vandita Kulkarni <vandita.kulkarni@intel.com>,
        Uma Shankar <uma.shankar@intel.com>
Subject: [PATCH] drm/i915: Fix TGL DKL PHY DP vswing handling
Date:   Thu,  1 Oct 2020 01:36:42 +0300
Message-Id: <20200930223642.28565-1-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

The HDMI vs. not-HDMI check got inverted whem the bogus encoder->type
checks were eliminated. So now we're using 0 as the link rate on DP
and potentially non-zero on HDMI, which is exactly the opposite of
what we want. The original bogus check actually worked more correctly
by accident since if would always evaluate to true. Due to this we
now always use the RBR/HBR1 vswing table and never ever the HBR2+
vswing table. That is probably not a good way to get a high quality
signal at HBR2+ rates. Fix the check so we pick the right table.

Cc: stable@vger.kernel.org
Cc: Vandita Kulkarni <vandita.kulkarni@intel.com>
Cc: Uma Shankar <uma.shankar@intel.com>
Fixes: 94641eb6c696 ("drm/i915/display: Fix the encoder type check")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
 drivers/gpu/drm/i915/display/intel_ddi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/intel_ddi.c b/drivers/gpu/drm/i915/display/intel_ddi.c
index 4d06178cd76c..cdcb7b1034ae 100644
--- a/drivers/gpu/drm/i915/display/intel_ddi.c
+++ b/drivers/gpu/drm/i915/display/intel_ddi.c
@@ -2742,7 +2742,7 @@ tgl_dkl_phy_ddi_vswing_sequence(struct intel_encoder *encoder, int link_clock,
 	u32 n_entries, val, ln, dpcnt_mask, dpcnt_val;
 	int rate = 0;
 
-	if (type == INTEL_OUTPUT_HDMI) {
+	if (type != INTEL_OUTPUT_HDMI) {
 		struct intel_dp *intel_dp = enc_to_intel_dp(encoder);
 
 		rate = intel_dp->link_rate;
-- 
2.26.2

