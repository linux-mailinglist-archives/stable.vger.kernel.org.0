Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3FE7341BCD
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 12:54:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbhCSLx6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 07:53:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:27549 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229618AbhCSLxm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Mar 2021 07:53:42 -0400
IronPort-SDR: W1j8q90tmlHfAI1doZEWtIVVy+u9HTNDODakxnn6PQnP0rnhftFvVtBbZf8Zx4XAEXd1EPAeMv
 OxttxkTqzehg==
X-IronPort-AV: E=McAfee;i="6000,8403,9927"; a="189969736"
X-IronPort-AV: E=Sophos;i="5.81,261,1610438400"; 
   d="scan'208";a="189969736"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2021 04:53:41 -0700
IronPort-SDR: KBsffjmVZWGq3TiSIlumY4x3pURp+EmskZ48sD2cNqZ8KXNOQMpcMI9Il7zzmoETDc04hdUtCQ
 XfUGhuWfCKsg==
X-IronPort-AV: E=Sophos;i="5.81,261,1610438400"; 
   d="scan'208";a="413482590"
Received: from koehlcla-mobl.ger.corp.intel.com (HELO localhost) ([10.252.50.135])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2021 04:53:38 -0700
From:   Jani Nikula <jani.nikula@intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     jani.nikula@intel.com, Manasi Navare <manasi.d.navare@intel.com>,
        Animesh Manna <animesh.manna@intel.com>,
        Vandita Kulkarni <vandita.kulkarni@intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] drm/i915/dsc: fix DSS CTL register usage for ICL DSI transcoders
Date:   Fri, 19 Mar 2021 13:53:33 +0200
Message-Id: <20210319115333.8330-1-jani.nikula@intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Use the correct DSS CTL registers for ICL DSI transcoders.

As a side effect, this also brings back the sanity check for trying to
use pipe DSC registers on pipe A on ICL.

Fixes: 8a029c113b17 ("drm/i915/dp: Modify VDSC helpers to configure DSC for Bigjoiner slave")
References: http://lore.kernel.org/r/87eegxq2lq.fsf@intel.com
Cc: Manasi Navare <manasi.d.navare@intel.com>
Cc: Animesh Manna <animesh.manna@intel.com>
Cc: Vandita Kulkarni <vandita.kulkarni@intel.com>
Cc: <stable@vger.kernel.org> # v5.11+
Signed-off-by: Jani Nikula <jani.nikula@intel.com>

---

Untested, I don't have the platform.
---
 drivers/gpu/drm/i915/display/intel_vdsc.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_vdsc.c b/drivers/gpu/drm/i915/display/intel_vdsc.c
index f58cc5700784..a86c57d117f2 100644
--- a/drivers/gpu/drm/i915/display/intel_vdsc.c
+++ b/drivers/gpu/drm/i915/display/intel_vdsc.c
@@ -1014,20 +1014,14 @@ static i915_reg_t dss_ctl1_reg(const struct intel_crtc_state *crtc_state)
 {
 	enum pipe pipe = to_intel_crtc(crtc_state->uapi.crtc)->pipe;
 
-	if (crtc_state->cpu_transcoder == TRANSCODER_EDP)
-		return DSS_CTL1;
-
-	return ICL_PIPE_DSS_CTL1(pipe);
+	return is_pipe_dsc(crtc_state) ? ICL_PIPE_DSS_CTL1(pipe) : DSS_CTL1;
 }
 
 static i915_reg_t dss_ctl2_reg(const struct intel_crtc_state *crtc_state)
 {
 	enum pipe pipe = to_intel_crtc(crtc_state->uapi.crtc)->pipe;
 
-	if (crtc_state->cpu_transcoder == TRANSCODER_EDP)
-		return DSS_CTL2;
-
-	return ICL_PIPE_DSS_CTL2(pipe);
+	return is_pipe_dsc(crtc_state) ? ICL_PIPE_DSS_CTL2(pipe) : DSS_CTL2;
 }
 
 void intel_dsc_enable(struct intel_encoder *encoder,
-- 
2.20.1

