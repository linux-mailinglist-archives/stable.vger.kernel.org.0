Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2CA2EF4D2
	for <lists+stable@lfdr.de>; Fri,  8 Jan 2021 16:29:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbhAHP3a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jan 2021 10:29:30 -0500
Received: from mga01.intel.com ([192.55.52.88]:53273 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726795AbhAHP3a (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Jan 2021 10:29:30 -0500
IronPort-SDR: x0x6eVoVo5/Dm1Ta8jNBaiTXQp3WAEf1vCqc17wLfqghoqMzHGahMKU4CvaFief9Z35//Y5stu
 tIsSe4qFbP8w==
X-IronPort-AV: E=McAfee;i="6000,8403,9857"; a="196178399"
X-IronPort-AV: E=Sophos;i="5.79,331,1602572400"; 
   d="scan'208";a="196178399"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2021 07:28:49 -0800
IronPort-SDR: 7Qrub/0/lotRIytBUK740ZAyP/alAL4cAmCBVBlvkEDGdLuM6VrUJS2hLlhDeaow+F4hcwwT5r
 xfv0GkgRs4PQ==
X-IronPort-AV: E=Sophos;i="5.79,331,1602572400"; 
   d="scan'208";a="380153181"
Received: from rgwhiteh-mobl.ger.corp.intel.com (HELO localhost) ([10.213.205.160])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2021 07:28:46 -0800
From:   Jani Nikula <jani.nikula@intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     jani.nikula@intel.com,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, Lyude Paul <lyude@redhat.com>,
        stable@vger.kernel.org
Subject: [PATCH] drm/i915/backlight: fix CPU mode backlight takeover on LPT
Date:   Fri,  8 Jan 2021 17:28:41 +0200
Message-Id: <20210108152841.6944-1-jani.nikula@intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The pch_get_backlight(), lpt_get_backlight(), and lpt_set_backlight()
functions operate directly on the hardware registers. If inverting the
value is needed, using intel_panel_compute_brightness(), it should only
be done in the interface between hardware registers and
panel->backlight.level.

The CPU mode takeover code added in commit 5b1ec9ac7ab5
("drm/i915/backlight: Fix backlight takeover on LPT, v3.") reads the
hardware register and converts to panel->backlight.level correctly,
however the value written back should remain in the hardware register
"domain".

This hasn't been an issue, because GM45 machines are the only known
users of i915.invert_brightness and the brightness invert quirk, and
without one of them no conversion is made. It's likely nobody's ever hit
the problem.

Fixes: 5b1ec9ac7ab5 ("drm/i915/backlight: Fix backlight takeover on LPT, v3.")
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Lyude Paul <lyude@redhat.com>
Cc: <stable@vger.kernel.org> # v5.1+
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
---
 drivers/gpu/drm/i915/display/intel_panel.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_panel.c b/drivers/gpu/drm/i915/display/intel_panel.c
index 67f81ae995c4..7a4239d1c241 100644
--- a/drivers/gpu/drm/i915/display/intel_panel.c
+++ b/drivers/gpu/drm/i915/display/intel_panel.c
@@ -1649,16 +1649,13 @@ static int lpt_setup_backlight(struct intel_connector *connector, enum pipe unus
 		val = pch_get_backlight(connector);
 	else
 		val = lpt_get_backlight(connector);
-	val = intel_panel_compute_brightness(connector, val);
-	panel->backlight.level = clamp(val, panel->backlight.min,
-				       panel->backlight.max);
 
 	if (cpu_mode) {
 		drm_dbg_kms(&dev_priv->drm,
 			    "CPU backlight register was enabled, switching to PCH override\n");
 
 		/* Write converted CPU PWM value to PCH override register */
-		lpt_set_backlight(connector->base.state, panel->backlight.level);
+		lpt_set_backlight(connector->base.state, val);
 		intel_de_write(dev_priv, BLC_PWM_PCH_CTL1,
 			       pch_ctl1 | BLM_PCH_OVERRIDE_ENABLE);
 
@@ -1666,6 +1663,10 @@ static int lpt_setup_backlight(struct intel_connector *connector, enum pipe unus
 			       cpu_ctl2 & ~BLM_PWM_ENABLE);
 	}
 
+	val = intel_panel_compute_brightness(connector, val);
+	panel->backlight.level = clamp(val, panel->backlight.min,
+				       panel->backlight.max);
+
 	return 0;
 }
 
-- 
2.20.1

