Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23E5E45C64C
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351688AbhKXOGj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:06:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:52680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356461AbhKXOEV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 09:04:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E4A463326;
        Wed, 24 Nov 2021 13:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759470;
        bh=Vq5Am5qiF5RHogobmENh/hsKUiPBBXNNrWAEI+RKOOY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l84/swymp2LbB++xCwnorfCaaSLITxrTLaEZOiEyHxMzK37cWa7KwO0AahNpc6G7s
         LdLwgi0WQ8mF93Vt0kuaho4shvToY0Mvq7DC+420j529HRRbAQmiBRD7302JHZOuDi
         mDcC/0s0GjF6s+ruK2C4pNISDEmFe3jLRgo9fApo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.15 253/279] drm/i915: Fix type1 DVI DP dual mode adapter heuristic for modern platforms
Date:   Wed, 24 Nov 2021 12:59:00 +0100
Message-Id: <20211124115727.463612068@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit 1977e8eb40ed53f0cac7db1a78295726f4ac0b24 upstream.

Looks like we never updated intel_bios_is_port_dp_dual_mode() when
the VBT port mapping became erratic on modern platforms. This
is causing us to look up the wrong child device and thus throwing
the heuristic off (ie. we might end looking at a child device for
a genuine DP++ port when we were supposed to look at one for a
native HDMI port).

Fix it up by not using the outdated port_mapping[] in
intel_bios_is_port_dp_dual_mode() and rely on
intel_bios_encoder_data_lookup() instead.

Cc: stable@vger.kernel.org
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/4138
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20211025142147.23897-1-ville.syrjala@linux.intel.com
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit 32c2bc89c7420fad2959ee23ef5b6be8b05d2bde)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_bios.c |   85 ++++++++++++++++++++++--------
 1 file changed, 63 insertions(+), 22 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_bios.c
+++ b/drivers/gpu/drm/i915/display/intel_bios.c
@@ -1692,6 +1692,39 @@ static u8 map_ddc_pin(struct drm_i915_pr
 	return 0;
 }
 
+static u8 dvo_port_type(u8 dvo_port)
+{
+	switch (dvo_port) {
+	case DVO_PORT_HDMIA:
+	case DVO_PORT_HDMIB:
+	case DVO_PORT_HDMIC:
+	case DVO_PORT_HDMID:
+	case DVO_PORT_HDMIE:
+	case DVO_PORT_HDMIF:
+	case DVO_PORT_HDMIG:
+	case DVO_PORT_HDMIH:
+	case DVO_PORT_HDMII:
+		return DVO_PORT_HDMIA;
+	case DVO_PORT_DPA:
+	case DVO_PORT_DPB:
+	case DVO_PORT_DPC:
+	case DVO_PORT_DPD:
+	case DVO_PORT_DPE:
+	case DVO_PORT_DPF:
+	case DVO_PORT_DPG:
+	case DVO_PORT_DPH:
+	case DVO_PORT_DPI:
+		return DVO_PORT_DPA;
+	case DVO_PORT_MIPIA:
+	case DVO_PORT_MIPIB:
+	case DVO_PORT_MIPIC:
+	case DVO_PORT_MIPID:
+		return DVO_PORT_MIPIA;
+	default:
+		return dvo_port;
+	}
+}
+
 static enum port __dvo_port_to_port(int n_ports, int n_dvo,
 				    const int port_mapping[][3], u8 dvo_port)
 {
@@ -2622,35 +2655,17 @@ bool intel_bios_is_port_edp(struct drm_i
 	return false;
 }
 
-static bool child_dev_is_dp_dual_mode(const struct child_device_config *child,
-				      enum port port)
+static bool child_dev_is_dp_dual_mode(const struct child_device_config *child)
 {
-	static const struct {
-		u16 dp, hdmi;
-	} port_mapping[] = {
-		/*
-		 * Buggy VBTs may declare DP ports as having
-		 * HDMI type dvo_port :( So let's check both.
-		 */
-		[PORT_B] = { DVO_PORT_DPB, DVO_PORT_HDMIB, },
-		[PORT_C] = { DVO_PORT_DPC, DVO_PORT_HDMIC, },
-		[PORT_D] = { DVO_PORT_DPD, DVO_PORT_HDMID, },
-		[PORT_E] = { DVO_PORT_DPE, DVO_PORT_HDMIE, },
-		[PORT_F] = { DVO_PORT_DPF, DVO_PORT_HDMIF, },
-	};
-
-	if (port == PORT_A || port >= ARRAY_SIZE(port_mapping))
-		return false;
-
 	if ((child->device_type & DEVICE_TYPE_DP_DUAL_MODE_BITS) !=
 	    (DEVICE_TYPE_DP_DUAL_MODE & DEVICE_TYPE_DP_DUAL_MODE_BITS))
 		return false;
 
-	if (child->dvo_port == port_mapping[port].dp)
+	if (dvo_port_type(child->dvo_port) == DVO_PORT_DPA)
 		return true;
 
 	/* Only accept a HDMI dvo_port as DP++ if it has an AUX channel */
-	if (child->dvo_port == port_mapping[port].hdmi &&
+	if (dvo_port_type(child->dvo_port) == DVO_PORT_HDMIA &&
 	    child->aux_channel != 0)
 		return true;
 
@@ -2660,10 +2675,36 @@ static bool child_dev_is_dp_dual_mode(co
 bool intel_bios_is_port_dp_dual_mode(struct drm_i915_private *i915,
 				     enum port port)
 {
+	static const struct {
+		u16 dp, hdmi;
+	} port_mapping[] = {
+		/*
+		 * Buggy VBTs may declare DP ports as having
+		 * HDMI type dvo_port :( So let's check both.
+		 */
+		[PORT_B] = { DVO_PORT_DPB, DVO_PORT_HDMIB, },
+		[PORT_C] = { DVO_PORT_DPC, DVO_PORT_HDMIC, },
+		[PORT_D] = { DVO_PORT_DPD, DVO_PORT_HDMID, },
+		[PORT_E] = { DVO_PORT_DPE, DVO_PORT_HDMIE, },
+		[PORT_F] = { DVO_PORT_DPF, DVO_PORT_HDMIF, },
+	};
 	const struct intel_bios_encoder_data *devdata;
 
+	if (HAS_DDI(i915)) {
+		const struct intel_bios_encoder_data *devdata;
+
+		devdata = intel_bios_encoder_data_lookup(i915, port);
+
+		return devdata && child_dev_is_dp_dual_mode(&devdata->child);
+	}
+
+	if (port == PORT_A || port >= ARRAY_SIZE(port_mapping))
+		return false;
+
 	list_for_each_entry(devdata, &i915->vbt.display_devices, node) {
-		if (child_dev_is_dp_dual_mode(&devdata->child, port))
+		if ((devdata->child.dvo_port == port_mapping[port].dp ||
+		     devdata->child.dvo_port == port_mapping[port].hdmi) &&
+		    child_dev_is_dp_dual_mode(&devdata->child))
 			return true;
 	}
 


