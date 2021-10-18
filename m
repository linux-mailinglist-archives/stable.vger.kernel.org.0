Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE5EA4313BE
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 11:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231615AbhJRJox (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 05:44:53 -0400
Received: from mga07.intel.com ([134.134.136.100]:21930 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231522AbhJRJod (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 05:44:33 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10140"; a="291682956"
X-IronPort-AV: E=Sophos;i="5.85,381,1624345200"; 
   d="scan'208";a="291682956"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2021 02:42:00 -0700
X-IronPort-AV: E=Sophos;i="5.85,381,1624345200"; 
   d="scan'208";a="493516710"
Received: from ideak-desk.fi.intel.com ([10.237.68.141])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2021 02:41:58 -0700
From:   Imre Deak <imre.deak@intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     Mat Jonczyk <mat.jonczyk@o2.pl>,
        =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, stable@vger.kernel.org
Subject: [PATCH 1/6] drm/i915/dp: Skip the HW readout of DPCD on disabled encoders
Date:   Mon, 18 Oct 2021 12:41:49 +0300
Message-Id: <20211018094154.1407705-2-imre.deak@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211018094154.1407705-1-imre.deak@intel.com>
References: <20211018094154.1407705-1-imre.deak@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Reading out the DP encoders' DPCD during booting or resume is only
required for enabled encoders: such encoders may be modesetted during
the initial commit and the link training this involves depends on an
initialized DPCD. For DDI encoders reading out the DPCD is skipped, do
the same on pre-DDI platforms.

Atm, the first DPCD readout without a sink connected - which is a likely
scneario if the encoder is disabled - leaves intel_dp->num_common_rates
at 0, which resulted in

intel_dp_sync_state()->intel_dp_max_common_rate()

in a

intel_dp->common_rates[-1]

access. This by definition results in an undefined behaviour, though to
my best knowledge in all HW/compiler configurations it actually results
in accessing the array item type value preceding the array. In this
case the preceding value happens to be intel_dp->num_common_rates,
which is 0, so this issue - by luck - didn't cause a user visible
problem.

Nevertheless it's still an undefined behaviour and in CONFIG_UBSAN
builds leads to a kernel BUG() (which revealed this problem for us),
hence CC:stable.

A related problem in case the encoder is enabled but the sink is not
connected or the DPCD readout fails is fixed by the next patch.

v2: Amend the commit message describing the root cause of the
    CONFIG_UBSAN BUG().

Fixes: a532cde31de3 ("drm/i915/tc: Fix TypeC port init/resume time sanitization")
References: https://gitlab.freedesktop.org/drm/intel/-/issues/4297
Reported-and-tested-by: Mat Jonczyk <mat.jonczyk@o2.pl>
Cc: Mat Jonczyk <mat.jonczyk@o2.pl>
Cc: José Roberto de Souza <jose.souza@intel.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Imre Deak <imre.deak@intel.com>
---
 drivers/gpu/drm/i915/display/intel_dp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/i915/display/intel_dp.c b/drivers/gpu/drm/i915/display/intel_dp.c
index 9d8132dd4cc5a..23de500d56b52 100644
--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -2007,6 +2007,9 @@ void intel_dp_sync_state(struct intel_encoder *encoder,
 {
 	struct intel_dp *intel_dp = enc_to_intel_dp(encoder);
 
+	if (!crtc_state)
+		return;
+
 	/*
 	 * Don't clobber DPCD if it's been already read out during output
 	 * setup (eDP) or detect.
-- 
2.27.0

