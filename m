Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55BEC469F04
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:42:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391232AbhLFPpS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:45:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389681AbhLFPkv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:40:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C35DC08ECA6;
        Mon,  6 Dec 2021 07:25:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 79ABEB810AC;
        Mon,  6 Dec 2021 15:25:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4D24C34901;
        Mon,  6 Dec 2021 15:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804311;
        bh=AUgOMdO7WsBgOFypjqkdhpdThsanA11OKIcJOJ8SDKM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hD/BOXPBXLQPK05ztvRs6VeVvA8KQuJ80EUkEQbJ7QqskpdLutuEmPkPdKO1mEZEK
         gcIyvr7JnYN3IclUxtQv9C6kJfE7Llz4c6YcQdsNQJfEGR8Y9axMedV9PMVZxw45qL
         8iFWb5MNAvmupUxPL/9MeMRQlOF6NteYJSoKJ/Zs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lyude Paul <lyude@redhat.com>,
        Jani Nikula <jani.nikula@intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.15 069/207] drm/i915/dp: Perform 30ms delay after source OUI write
Date:   Mon,  6 Dec 2021 15:55:23 +0100
Message-Id: <20211206145612.622414478@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lyude Paul <lyude@redhat.com>

commit a44f42ba7f1ad7d3c17bc7d91013fe814a53c5dc upstream.

While working on supporting the Intel HDR backlight interface, I noticed
that there's a couple of laptops that will very rarely manage to boot up
without detecting Intel HDR backlight support - even though it's supported
on the system. One example of such a laptop is the Lenovo P17 1st
generation.

Following some investigation Ville Syrjälä did through the docs they have
available to them, they discovered that there's actually supposed to be a
30ms wait after writing the source OUI before we begin setting up the rest
of the backlight interface.

This seems to be correct, as adding this 30ms delay seems to have
completely fixed the probing issues I was previously seeing. So - let's
start performing a 30ms wait after writing the OUI, which we do in a manner
similar to how we keep track of PPS delays (e.g. record the timestamp of
the OUI write, and then wait for however many ms are left since that
timestamp right before we interact with the backlight) in order to avoid
waiting any longer then we need to. As well, this also avoids us performing
this delay on systems where we don't end up using the HDR backlight
interface.

V3:
* Move last_oui_write into intel_dp
V2:
* Move panel delays into intel_pps

Signed-off-by: Lyude Paul <lyude@redhat.com>
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Fixes: 4a8d79901d5b ("drm/i915/dp: Enable Intel's HDR backlight interface (only SDR for now)")
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: <stable@vger.kernel.org> # v5.12+
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20211130212912.212044-1-lyude@redhat.com
(cherry picked from commit c7c90b0b8418a97d3aa8b39aae1992908948efad)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_display_types.h    |    3 +++
 drivers/gpu/drm/i915/display/intel_dp.c               |   11 +++++++++++
 drivers/gpu/drm/i915/display/intel_dp.h               |    2 ++
 drivers/gpu/drm/i915/display/intel_dp_aux_backlight.c |    5 +++++
 4 files changed, 21 insertions(+)

--- a/drivers/gpu/drm/i915/display/intel_display_types.h
+++ b/drivers/gpu/drm/i915/display/intel_display_types.h
@@ -1639,6 +1639,9 @@ struct intel_dp {
 	struct intel_dp_pcon_frl frl;
 
 	struct intel_psr psr;
+
+	/* When we last wrote the OUI for eDP */
+	unsigned long last_oui_write;
 };
 
 enum lspcon_vendor {
--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -29,6 +29,7 @@
 #include <linux/i2c.h>
 #include <linux/notifier.h>
 #include <linux/slab.h>
+#include <linux/timekeeping.h>
 #include <linux/types.h>
 
 #include <asm/byteorder.h>
@@ -1864,6 +1865,16 @@ intel_edp_init_source_oui(struct intel_d
 
 	if (drm_dp_dpcd_write(&intel_dp->aux, DP_SOURCE_OUI, oui, sizeof(oui)) < 0)
 		drm_err(&i915->drm, "Failed to write source OUI\n");
+
+	intel_dp->last_oui_write = jiffies;
+}
+
+void intel_dp_wait_source_oui(struct intel_dp *intel_dp)
+{
+	struct drm_i915_private *i915 = dp_to_i915(intel_dp);
+
+	drm_dbg_kms(&i915->drm, "Performing OUI wait\n");
+	wait_remaining_ms_from_jiffies(intel_dp->last_oui_write, 30);
 }
 
 /* If the device supports it, try to set the power state appropriately */
--- a/drivers/gpu/drm/i915/display/intel_dp.h
+++ b/drivers/gpu/drm/i915/display/intel_dp.h
@@ -129,4 +129,6 @@ void intel_dp_pcon_dsc_configure(struct
 				 const struct intel_crtc_state *crtc_state);
 void intel_dp_phy_test(struct intel_encoder *encoder);
 
+void intel_dp_wait_source_oui(struct intel_dp *intel_dp);
+
 #endif /* __INTEL_DP_H__ */
--- a/drivers/gpu/drm/i915/display/intel_dp_aux_backlight.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_aux_backlight.c
@@ -35,6 +35,7 @@
  */
 
 #include "intel_display_types.h"
+#include "intel_dp.h"
 #include "intel_dp_aux_backlight.h"
 #include "intel_panel.h"
 
@@ -106,6 +107,8 @@ intel_dp_aux_supports_hdr_backlight(stru
 	int ret;
 	u8 tcon_cap[4];
 
+	intel_dp_wait_source_oui(intel_dp);
+
 	ret = drm_dp_dpcd_read(aux, INTEL_EDP_HDR_TCON_CAP0, tcon_cap, sizeof(tcon_cap));
 	if (ret != sizeof(tcon_cap))
 		return false;
@@ -204,6 +207,8 @@ intel_dp_aux_hdr_enable_backlight(const
 	int ret;
 	u8 old_ctrl, ctrl;
 
+	intel_dp_wait_source_oui(intel_dp);
+
 	ret = drm_dp_dpcd_readb(&intel_dp->aux, INTEL_EDP_HDR_GETSET_CTRL_PARAMS, &old_ctrl);
 	if (ret != 1) {
 		drm_err(&i915->drm, "Failed to read current backlight control mode: %d\n", ret);


