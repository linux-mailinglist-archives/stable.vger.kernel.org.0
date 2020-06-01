Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B9281EA1DA
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 12:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725974AbgFAK3J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 06:29:09 -0400
Received: from mga14.intel.com ([192.55.52.115]:20803 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725925AbgFAK3I (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 06:29:08 -0400
IronPort-SDR: TpuS8+CmyTL63JvpkuV0z/i0FHL0XIC3At9QbVJQwb8wTvruTwJRmJFO/4c+IFlkSs3to5cN0K
 ihRPqQ5A31Bw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2020 03:29:08 -0700
IronPort-SDR: x9moCRrzQyy15Belms9PbtuKV3MwbscQ2SIBP1rehgoZc0beRQCThSP0SazvcQgRS8N0shSn1B
 jR61Phhy33Yg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,460,1583222400"; 
   d="scan'208";a="470276676"
Received: from unknown (HELO genxfsim-desktop.iind.intel.com) ([10.223.74.178])
  by fmsmga005.fm.intel.com with ESMTP; 01 Jun 2020 03:29:06 -0700
From:   Anshuman Gupta <anshuman.gupta@intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     Anshuman Gupta <anshuman.gupta@intel.com>, stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Subject: [RFC] drm/i915: lpsp with hdmi/dp outputs
Date:   Mon,  1 Jun 2020 15:45:16 +0530
Message-Id: <20200601101516.21018-1-anshuman.gupta@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Gen12 hw are failing to enable lpsp configuration due to PG3 was left on
due to valid usgae count of POWER_DOMAIN_AUDIO.
It is not required to get POWER_DOMAIN_AUDIO ref-count when enabling
a crtc, it should be always i915_audio_component request to get/put
AUDIO_POWER_DOMAIN.

Cc: stable@vger.kernel.org
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Signed-off-by: Anshuman Gupta <anshuman.gupta@intel.com>
---
 drivers/gpu/drm/i915/display/intel_display.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/intel_display.c b/drivers/gpu/drm/i915/display/intel_display.c
index 6c3b11de2daf..f31a579d7a52 100644
--- a/drivers/gpu/drm/i915/display/intel_display.c
+++ b/drivers/gpu/drm/i915/display/intel_display.c
@@ -7356,7 +7356,11 @@ static u64 get_crtc_power_domains(struct intel_crtc_state *crtc_state)
 		mask |= BIT_ULL(intel_encoder->power_domain);
 	}
 
-	if (HAS_DDI(dev_priv) && crtc_state->has_audio)
+	/*
+	 * Gen12 can drive lpsp on hdmi/dp outpus, it doesn't require to
+	 * enable AUDIO power in order to enable a crtc.
+	 */
+	if (INTEL_GEN(dev_priv) < 12 && HAS_DDI(dev_priv) && crtc_state->has_audio)
 		mask |= BIT_ULL(POWER_DOMAIN_AUDIO);
 
 	if (crtc_state->shared_dpll)
-- 
2.26.2

