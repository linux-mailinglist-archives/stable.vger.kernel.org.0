Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53EB82F9E68
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 12:39:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390510AbhARLjD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 06:39:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:34108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390474AbhARLiq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:38:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0DC562223E;
        Mon, 18 Jan 2021 11:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610969875;
        bh=ImAx8VLNvSv8MYH4ZZXbLsF/zHT3Dgn5tGRGNHrsbAo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L1QNEgcArIqTF/LdXLuq+l1kPHIQwKhrzrGswv/7PEu9IfA02eSf+EJ6OvphaMtZs
         s8rOyIK29/T5SZUvcI1QUIc4FdI26pwNc2aFie15DE2tlLTO/6A5HZXrJmtfMwvIvu
         tIpJcIhPvGZO+KWB2CaPaqfeoojt8+gqk6BTq4lM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, Lyude Paul <lyude@redhat.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 19/76] drm/i915/backlight: fix CPU mode backlight takeover on LPT
Date:   Mon, 18 Jan 2021 12:34:19 +0100
Message-Id: <20210118113341.913992596@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113340.984217512@linuxfoundation.org>
References: <20210118113340.984217512@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jani Nikula <jani.nikula@intel.com>

[ Upstream commit bb83d5fb550bb7db75b29e6342417fda2bbb691c ]

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
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210108152841.6944-1-jani.nikula@intel.com
(cherry picked from commit 0d4ced1c5bfe649196877d90442d4fd618e19153)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_panel.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_panel.c b/drivers/gpu/drm/i915/display/intel_panel.c
index bc14e9c0285a0..23edc1b8e43fa 100644
--- a/drivers/gpu/drm/i915/display/intel_panel.c
+++ b/drivers/gpu/drm/i915/display/intel_panel.c
@@ -1603,20 +1603,21 @@ static int lpt_setup_backlight(struct intel_connector *connector, enum pipe unus
 		val = pch_get_backlight(connector);
 	else
 		val = lpt_get_backlight(connector);
-	val = intel_panel_compute_brightness(connector, val);
-	panel->backlight.level = clamp(val, panel->backlight.min,
-				       panel->backlight.max);
 
 	if (cpu_mode) {
 		DRM_DEBUG_KMS("CPU backlight register was enabled, switching to PCH override\n");
 
 		/* Write converted CPU PWM value to PCH override register */
-		lpt_set_backlight(connector->base.state, panel->backlight.level);
+		lpt_set_backlight(connector->base.state, val);
 		I915_WRITE(BLC_PWM_PCH_CTL1, pch_ctl1 | BLM_PCH_OVERRIDE_ENABLE);
 
 		I915_WRITE(BLC_PWM_CPU_CTL2, cpu_ctl2 & ~BLM_PWM_ENABLE);
 	}
 
+	val = intel_panel_compute_brightness(connector, val);
+	panel->backlight.level = clamp(val, panel->backlight.min,
+				       panel->backlight.max);
+
 	return 0;
 }
 
-- 
2.27.0



