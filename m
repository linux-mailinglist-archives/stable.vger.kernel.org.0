Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6734945A
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727366AbfFQVh0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:37:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:44138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725497AbfFQVUF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:20:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A4F620861;
        Mon, 17 Jun 2019 21:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806403;
        bh=6n+foonixuc31PF4ZuMbKS89R8pdNFk0aCM+W91tW0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dD/KEKgKln2W6R1wwhfIS+Ly5K7JCqjI+hEI8yu7yOH9HhwjX7nn5kleBnvLcB4/+
         atCjuNGoxzVSuOyjw1NDBz1CAS8OiyPr3058I4Rntb3dhiV8zJD4l41johQ8ZfD8pc
         v3/uOH2yDGmO7IEZABudCaXy6EE8QC5kcGOWi7HU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.1 039/115] drm/i915/dsi: Use a fuzzy check for burst mode clock check
Date:   Mon, 17 Jun 2019 23:08:59 +0200
Message-Id: <20190617210802.013103791@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210759.929316339@linuxfoundation.org>
References: <20190617210759.929316339@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit f9a99131ce18d9dddcaa14ec2c436e42f0bbee5e upstream.

Prior to this commit we fail to init the DSI panel on the GPD MicroPC:
https://www.indiegogo.com/projects/gpd-micropc-6-inch-handheld-industry-laptop#/

The problem is intel_dsi_vbt_init() failing with the following error:
*ERROR* Burst mode freq is less than computed

The pclk in the VBT panel modeline is 70000, together with 24 bpp and
4 lines this results in a bitrate value of 70000 * 24 / 4 = 420000.
But the target_burst_mode_freq in the VBT is 418000.

This commit works around this problem by adding an intel_fuzzy_clock_check
when target_burst_mode_freq < bitrate and setting target_burst_mode_freq to
bitrate when that checks succeeds, fixing the panel not working.

Cc: stable@vger.kernel.org
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190524174028.21659-2-hdegoede@redhat.com
(cherry picked from commit 2c1c55252647abd989b94f725b190c700312d053)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_display.c |    2 +-
 drivers/gpu/drm/i915/intel_drv.h     |    1 +
 drivers/gpu/drm/i915/intel_dsi_vbt.c |   11 +++++++++++
 3 files changed, 13 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -11757,7 +11757,7 @@ encoder_retry:
 	return 0;
 }
 
-static bool intel_fuzzy_clock_check(int clock1, int clock2)
+bool intel_fuzzy_clock_check(int clock1, int clock2)
 {
 	int diff;
 
--- a/drivers/gpu/drm/i915/intel_drv.h
+++ b/drivers/gpu/drm/i915/intel_drv.h
@@ -1707,6 +1707,7 @@ int vlv_force_pll_on(struct drm_i915_pri
 		     const struct dpll *dpll);
 void vlv_force_pll_off(struct drm_i915_private *dev_priv, enum pipe pipe);
 int lpt_get_iclkip(struct drm_i915_private *dev_priv);
+bool intel_fuzzy_clock_check(int clock1, int clock2);
 
 /* modesetting asserts */
 void assert_panel_unlocked(struct drm_i915_private *dev_priv,
--- a/drivers/gpu/drm/i915/intel_dsi_vbt.c
+++ b/drivers/gpu/drm/i915/intel_dsi_vbt.c
@@ -871,6 +871,17 @@ bool intel_dsi_vbt_init(struct intel_dsi
 		if (mipi_config->target_burst_mode_freq) {
 			u32 bitrate = intel_dsi_bitrate(intel_dsi);
 
+			/*
+			 * Sometimes the VBT contains a slightly lower clock,
+			 * then the bitrate we have calculated, in this case
+			 * just replace it with the calculated bitrate.
+			 */
+			if (mipi_config->target_burst_mode_freq < bitrate &&
+			    intel_fuzzy_clock_check(
+					mipi_config->target_burst_mode_freq,
+					bitrate))
+				mipi_config->target_burst_mode_freq = bitrate;
+
 			if (mipi_config->target_burst_mode_freq < bitrate) {
 				DRM_ERROR("Burst mode freq is less than computed\n");
 				return false;


