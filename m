Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1CAFF1D
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 19:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725930AbfD3Ru7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 13:50:59 -0400
Received: from mga18.intel.com ([134.134.136.126]:48239 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726155AbfD3Ru7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 13:50:59 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Apr 2019 10:50:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,414,1549958400"; 
   d="scan'208";a="153641049"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.174])
  by FMSMGA003.fm.intel.com with SMTP; 30 Apr 2019 10:50:55 -0700
Received: by stinkbox (sSMTP sendmail emulation); Tue, 30 Apr 2019 20:50:54 +0300
From:   Ville Syrjala <ville.syrjala@linux.intel.com>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org,
        Anusha Srivatsa <anusha.srivatsa@intel.com>,
        Manasi Navare <manasi.d.navare@intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.0-stable] drm/i915: Do not enable FEC without DSC
Date:   Tue, 30 Apr 2019 20:50:54 +0300
Message-Id: <20190430175054.21797-1-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <155652995323242@kroah.com>
References: <155652995323242@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit 5aae7832d1b4ec614996ea0f4fafc4d9855ec0b0 upstream.

Currently we enable FEC even when DSC is no used. While that is
theoretically valid supposedly there isn't much of a benefit from
this. But more importantly we do not account for the FEC link
bandwidth overhead (2.4%) in the non-DSC link bandwidth computations.
So the code may think we have enough bandwidth when we in fact
do not.

Cc: stable@vger.kernel.org
Cc: Anusha Srivatsa <anusha.srivatsa@intel.com>
Cc: Manasi Navare <manasi.d.navare@intel.com>
Fixes: 240999cf339f ("i915/dp/fec: Add fec_enable to the crtc state.")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190326144903.6617-1-ville.syrjala@linux.intel.com
Reviewed-by: Manasi Navare <manasi.d.navare@intel.com>
(cherry picked from commit 6fd3134ae3551d4802a04669c0f39f2f5c56f77d)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
---
 drivers/gpu/drm/i915/intel_dp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index dcd1df5322e8..21c6016ccba5 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -1871,6 +1871,9 @@ static bool intel_dp_dsc_compute_config(struct intel_dp *intel_dp,
 	u8 dsc_max_bpc;
 	int pipe_bpp;
 
+	pipe_config->fec_enable = !intel_dp_is_edp(intel_dp) &&
+		intel_dp_supports_fec(intel_dp, pipe_config);
+
 	if (!intel_dp_supports_dsc(intel_dp, pipe_config))
 		return false;
 
@@ -2097,9 +2100,6 @@ intel_dp_compute_config(struct intel_encoder *encoder,
 	if (adjusted_mode->flags & DRM_MODE_FLAG_DBLCLK)
 		return false;
 
-	pipe_config->fec_enable = !intel_dp_is_edp(intel_dp) &&
-				  intel_dp_supports_fec(intel_dp, pipe_config);
-
 	if (!intel_dp_compute_link_config(encoder, pipe_config, conn_state))
 		return false;
 
-- 
2.21.0

