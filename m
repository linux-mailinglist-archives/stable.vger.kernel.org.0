Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B3132FA90F
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 19:43:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390735AbhARSmA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 13:42:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:34192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390686AbhARLlI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:41:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 208952245C;
        Mon, 18 Jan 2021 11:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970044;
        bh=o4CJEhv0q6H7UNfe5Vugtt8kugalayN7/GUJluN/pKA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jx7KuDIqcihQLqsVEDeuHMZEiFwYbnT0f91YvlGGzgpbY8WTCMQgUBZyXElrsCsGT
         3im2hTqamLILPSYcq+zjR3pJiOFV0cWMF5xkDz29IqQs2VsNhB93ImB79joUB1kdth
         PlEaxq8ufSdwMljqeR1N//tQnfHkAFYOYSf1ZfeE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, Lyude Paul <lyude@redhat.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.10 014/152] drm/i915/backlight: fix CPU mode backlight takeover on LPT
Date:   Mon, 18 Jan 2021 12:33:09 +0100
Message-Id: <20210118113353.452774942@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jani Nikula <jani.nikula@intel.com>

commit bb83d5fb550bb7db75b29e6342417fda2bbb691c upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/display/intel_panel.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_panel.c
+++ b/drivers/gpu/drm/i915/display/intel_panel.c
@@ -1650,16 +1650,13 @@ static int lpt_setup_backlight(struct in
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
 
@@ -1667,6 +1664,10 @@ static int lpt_setup_backlight(struct in
 			       cpu_ctl2 & ~BLM_PWM_ENABLE);
 	}
 
+	val = intel_panel_compute_brightness(connector, val);
+	panel->backlight.level = clamp(val, panel->backlight.min,
+				       panel->backlight.max);
+
 	return 0;
 }
 


