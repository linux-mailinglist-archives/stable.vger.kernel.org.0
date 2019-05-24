Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 173522987C
	for <lists+stable@lfdr.de>; Fri, 24 May 2019 15:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391422AbfEXNGM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 May 2019 09:06:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50552 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391193AbfEXNGM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 May 2019 09:06:12 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1A2DDC4EC4;
        Fri, 24 May 2019 13:06:12 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-112-47.ams2.redhat.com [10.36.112.47])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 81B1E19748;
        Fri, 24 May 2019 13:06:09 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Daniel Vetter <daniel.vetter@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel@lists.freedesktop.org, stable@vger.kernel.org
Subject: [PATCH] drm/i915/dsi: Use a fuzzy check for burst mode clock check
Date:   Fri, 24 May 2019 15:06:07 +0200
Message-Id: <20190524130607.4021-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Fri, 24 May 2019 13:06:12 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/gpu/drm/i915/intel_dsi_vbt.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/gpu/drm/i915/intel_dsi_vbt.c b/drivers/gpu/drm/i915/intel_dsi_vbt.c
index 022bf59418df..a2a9b9d0eeaa 100644
--- a/drivers/gpu/drm/i915/intel_dsi_vbt.c
+++ b/drivers/gpu/drm/i915/intel_dsi_vbt.c
@@ -895,6 +895,17 @@ bool intel_dsi_vbt_init(struct intel_dsi *intel_dsi, u16 panel_id)
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
-- 
2.21.0

