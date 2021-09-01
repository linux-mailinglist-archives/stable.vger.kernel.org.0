Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7759D3FDC4A
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245467AbhIAMso (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:48:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:48348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245718AbhIAMql (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:46:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C8ED7610CB;
        Wed,  1 Sep 2021 12:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630500006;
        bh=eWo911t6lUyPuoWquTHUijZQndSb+BwKqfCV5c8yawA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H5WTubntu4Ikbu+4W9TsAJGL4uhDKS9fqetRgd0iBDBy3Oj5VqUQUf3MwbHESBisJ
         gNBZwTxQ8euhJl8lOP2EETjSIlduJKmJ+QCVsC1Bp9Pka6ep638WbX5I73Gu5AqQC8
         Hx/KHDkwV6UJoVEU8p+/bQOF1w1O3SMK4T1kKbCE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
        Imre Deak <imre.deak@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
        Manasi Navare <manasi.d.navare@intel.com>,
        Sean Paul <seanpaul@chromium.org>,
        Uma Shankar <uma.shankar@intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Swati Sharma <swati2.sharma@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.13 024/113] drm/i915/dp: Drop redundant debug print
Date:   Wed,  1 Sep 2021 14:27:39 +0200
Message-Id: <20210901122302.801555137@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122301.984263453@linuxfoundation.org>
References: <20210901122301.984263453@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Swati Sharma <swati2.sharma@intel.com>

commit 71de496cc489b6bae2f51f89da7f28849bf2836e upstream.

drm_dp_dpcd_read/write already has debug error message.
Drop redundant error messages which gives false
status even if correct value is read in drm_dp_dpcd_read().

v2: -Added fixes tag (Ankit)
v3: -Fixed build error (CI)

Fixes: 9488a030ac91 ("drm/i915: Add support for enabling link status and recovery")
Cc: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Cc: Imre Deak <imre.deak@intel.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: José Roberto de Souza <jose.souza@intel.com>
Cc: Manasi Navare <manasi.d.navare@intel.com>
Cc: Sean Paul <seanpaul@chromium.org>
Cc: Uma Shankar <uma.shankar@intel.com>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: <stable@vger.kernel.org> # v5.12+
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Swati Sharma <swati2.sharma@intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210812131107.5531-1-swati2.sharma@intel.com
(cherry picked from commit b6dfa416172939edaa46a5a647457b94c6d94119)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_dp.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -3833,23 +3833,18 @@ static void intel_dp_check_device_servic
 
 static void intel_dp_check_link_service_irq(struct intel_dp *intel_dp)
 {
-	struct drm_i915_private *i915 = dp_to_i915(intel_dp);
 	u8 val;
 
 	if (intel_dp->dpcd[DP_DPCD_REV] < 0x11)
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


