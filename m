Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB2EE3642EB
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240109AbhDSNMf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:12:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:46262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232708AbhDSNLX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:11:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B245361369;
        Mon, 19 Apr 2021 13:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618837852;
        bh=cTv/+ObGpid6q5PCgrkMLnY1hD7lfOHQmZ+Pxd2mqtA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bD9G3r0gxXyaj0x6eBtqVdCCy1bHYjm7UhlUC0l17kRytCfURtgcyWmQt0GndfFOI
         eu9F+PrPt12IcdbuYWWXyOtsR527Du2jS6d82rT2a2wXWaXKXyfG/xoTQPKX4SyLfL
         qfiby+qCTTlxESGOjSTMjjg6H6jK9KU+zRQzKl3s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.11 078/122] drm/i915/display/vlv_dsi: Do not skip panel_pwr_cycle_delay when disabling the panel
Date:   Mon, 19 Apr 2021 15:05:58 +0200
Message-Id: <20210419130532.821962952@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130530.166331793@linuxfoundation.org>
References: <20210419130530.166331793@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit aee6f25e9c911323aa89a200e1bb160c1613ed3d upstream.

After the recently added commit fe0f1e3bfdfe ("drm/i915: Shut down
displays gracefully on reboot"), the DSI panel on a Cherry Trail based
Predia Basic tablet would no longer properly light up after reboot.

I've managed to reproduce this without rebooting by doing:
chvt 3; echo 1 > /sys/class/graphics/fb0/blank;\
echo 0 > /sys/class/graphics/fb0/blank

Which rapidly turns the panel off and back on again.

The vlv_dsi.c code uses an intel_dsi_msleep() helper for the various delays
used for panel on/off, since starting with MIPI-sequences version >= 3 the
delays are already included inside the MIPI-sequences.

The problems exposed by the "Shut down displays gracefully on reboot"
change, show that using this helper for the panel_pwr_cycle_delay is
not the right thing to do. This has not been noticed until now because
normally the panel never is cycled off and directly on again in quick
succession.

Change the msleep for the panel_pwr_cycle_delay to a normal msleep()
call to avoid the panel staying black after a quick off + on cycle.

Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Fixes: fe0f1e3bfdfe ("drm/i915: Shut down displays gracefully on reboot")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210325114823.44922-1-hdegoede@redhat.com
(cherry picked from commit 2878b29fc25a0dac0e1c6c94177f07c7f94240f0)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/vlv_dsi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/display/vlv_dsi.c
+++ b/drivers/gpu/drm/i915/display/vlv_dsi.c
@@ -992,14 +992,14 @@ static void intel_dsi_post_disable(struc
 	 * FIXME As we do with eDP, just make a note of the time here
 	 * and perform the wait before the next panel power on.
 	 */
-	intel_dsi_msleep(intel_dsi, intel_dsi->panel_pwr_cycle_delay);
+	msleep(intel_dsi->panel_pwr_cycle_delay);
 }
 
 static void intel_dsi_shutdown(struct intel_encoder *encoder)
 {
 	struct intel_dsi *intel_dsi = enc_to_intel_dsi(encoder);
 
-	intel_dsi_msleep(intel_dsi, intel_dsi->panel_pwr_cycle_delay);
+	msleep(intel_dsi->panel_pwr_cycle_delay);
 }
 
 static bool intel_dsi_get_hw_state(struct intel_encoder *encoder,


