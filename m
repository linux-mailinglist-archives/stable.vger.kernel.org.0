Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7BE2FA96B
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 19:57:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390627AbhARS5I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 13:57:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:36286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390622AbhARLka (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:40:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2189221EC;
        Mon, 18 Jan 2021 11:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610969989;
        bh=IbUQRbcRbBZDK/h/m5qGIABeozBzWguqaH07m2pG5v8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IUH2kEmkVYyYJUHrwuvSdh6rbtH5e+l2wmlXhMZHlQXavC6m+kxPXMUnnJB1KuBMr
         sW8S9y+Zlu+URXV1zAby03P2PBUCxYz0nOrn+dcynP+2eDkRf0ZEPZipxRe6A1Plya
         Ot4anxepxDKrwdeZIkZ9TyyLxKKGN2E2U2MqfNRo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.4 67/76] drm/i915/dsi: Use unconditional msleep for the panel_on_delay when there is no reset-deassert MIPI-sequence
Date:   Mon, 18 Jan 2021 12:35:07 +0100
Message-Id: <20210118113344.173255931@linuxfoundation.org>
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

From: Hans de Goede <hdegoede@redhat.com>

commit 00cb645fd7e29bdd20967cd20fa8f77bcdf422f9 upstream.

Commit 25b4620ee822 ("drm/i915/dsi: Skip delays for v3 VBTs in vid-mode")
added an intel_dsi_msleep() helper which skips sleeping if the
MIPI-sequences have a version of 3 or newer and the panel is in vid-mode;
and it moved a bunch of msleep-s over to this new helper.

This was based on my reading of the big comment around line 730 which
starts with "Panel enable/disable sequences from the VBT spec.",
where the "v3 video mode seq" column does not have any wait t# entries.

Given that this code has been used on a lot of different devices without
issues until now, it seems that my interpretation of the spec here is
mostly correct.

But now I have encountered one device, an Acer Aspire Switch 10 E
SW3-016, where the panel will not light up unless we do actually honor the
panel_on_delay after exexuting the MIPI_SEQ_PANEL_ON sequence.

What seems to set this model apart is that it is lacking a
MIPI_SEQ_DEASSERT_RESET sequence, which is where the power-on
delay usually happens.

Fix the panel not lighting up on this model by using an unconditional
msleep(panel_on_delay) instead of intel_dsi_msleep() when there is
no MIPI_SEQ_DEASSERT_RESET sequence.

Fixes: 25b4620ee822 ("drm/i915/dsi: Skip delays for v3 VBTs in vid-mode")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20201118124058.26021-1-hdegoede@redhat.com
(cherry picked from commit 6fdb335f1c9c0845b50625de1624d8445c4c4a07)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/display/vlv_dsi.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/i915/display/vlv_dsi.c
+++ b/drivers/gpu/drm/i915/display/vlv_dsi.c
@@ -797,10 +797,20 @@ static void intel_dsi_pre_enable(struct
 	if (intel_dsi->gpio_panel)
 		gpiod_set_value_cansleep(intel_dsi->gpio_panel, 1);
 	intel_dsi_vbt_exec_sequence(intel_dsi, MIPI_SEQ_POWER_ON);
-	intel_dsi_msleep(intel_dsi, intel_dsi->panel_on_delay);
 
-	/* Deassert reset */
-	intel_dsi_vbt_exec_sequence(intel_dsi, MIPI_SEQ_DEASSERT_RESET);
+	/*
+	 * Give the panel time to power-on and then deassert its reset.
+	 * Depending on the VBT MIPI sequences version the deassert-seq
+	 * may contain the necessary delay, intel_dsi_msleep() will skip
+	 * the delay in that case. If there is no deassert-seq, then an
+	 * unconditional msleep is used to give the panel time to power-on.
+	 */
+	if (dev_priv->vbt.dsi.sequence[MIPI_SEQ_DEASSERT_RESET]) {
+		intel_dsi_msleep(intel_dsi, intel_dsi->panel_on_delay);
+		intel_dsi_vbt_exec_sequence(intel_dsi, MIPI_SEQ_DEASSERT_RESET);
+	} else {
+		msleep(intel_dsi->panel_on_delay);
+	}
 
 	if (IS_GEMINILAKE(dev_priv)) {
 		glk_cold_boot = glk_dsi_enable_io(encoder);


