Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D34C6694960
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 15:58:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231163AbjBMO6j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 09:58:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231211AbjBMO61 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 09:58:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA1FE1CAE4
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 06:58:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE0EE61161
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:57:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2869C433EF;
        Mon, 13 Feb 2023 14:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300233;
        bh=OBxZm3ZDl2Q56oH8pQ3V/48q6acdgNfKIbrsZ3J5P2w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ClA8U6cL/loQO0QsU2rDn0ECZ6aP4/izDOMfMgjrz66enQzaG3leD+dRfAUvj+Sdi
         Rlr/4ryteOfHosaj1hFNpkHsA4vWiBDgtWecranujf2fNa9xYLHBDtyGFFh6OkCnsT
         oNYPfIYyCmrLBskEq/oDws8N+nB0SZcR7SnzH7HA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.1 114/114] drm/i915: Fix VBT DSI DVO port handling
Date:   Mon, 13 Feb 2023 15:49:09 +0100
Message-Id: <20230213144748.128769395@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit 6a7ff131f17f44c593173c5ee30e2c03ef211685 upstream.

Turns out modern (icl+) VBTs still declare their DSI ports
as MIPI-A and MIPI-C despite the PHYs now being A and B.
Remap appropriately to allow the panels declared as MIPI-C
to work.

Cc: stable@vger.kernel.org
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/8016
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230207064337.18697-2-ville.syrjala@linux.intel.com
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit 118b5c136c04da705b274b0d39982bb8b7430fc5)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_bios.c |   33 ++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_bios.c
+++ b/drivers/gpu/drm/i915/display/intel_bios.c
@@ -2466,6 +2466,22 @@ static enum port dvo_port_to_port(struct
 					  dvo_port);
 }
 
+static enum port
+dsi_dvo_port_to_port(struct drm_i915_private *i915, u8 dvo_port)
+{
+	switch (dvo_port) {
+	case DVO_PORT_MIPIA:
+		return PORT_A;
+	case DVO_PORT_MIPIC:
+		if (DISPLAY_VER(i915) >= 11)
+			return PORT_B;
+		else
+			return PORT_C;
+	default:
+		return PORT_NONE;
+	}
+}
+
 static int parse_bdb_230_dp_max_link_rate(const int vbt_max_link_rate)
 {
 	switch (vbt_max_link_rate) {
@@ -3406,19 +3422,16 @@ bool intel_bios_is_dsi_present(struct dr
 
 		dvo_port = child->dvo_port;
 
-		if (dvo_port == DVO_PORT_MIPIA ||
-		    (dvo_port == DVO_PORT_MIPIB && DISPLAY_VER(i915) >= 11) ||
-		    (dvo_port == DVO_PORT_MIPIC && DISPLAY_VER(i915) < 11)) {
-			if (port)
-				*port = dvo_port - DVO_PORT_MIPIA;
-			return true;
-		} else if (dvo_port == DVO_PORT_MIPIB ||
-			   dvo_port == DVO_PORT_MIPIC ||
-			   dvo_port == DVO_PORT_MIPID) {
+		if (dsi_dvo_port_to_port(i915, dvo_port) == PORT_NONE) {
 			drm_dbg_kms(&i915->drm,
 				    "VBT has unsupported DSI port %c\n",
 				    port_name(dvo_port - DVO_PORT_MIPIA));
+			continue;
 		}
+
+		if (port)
+			*port = dsi_dvo_port_to_port(i915, dvo_port);
+		return true;
 	}
 
 	return false;
@@ -3503,7 +3516,7 @@ bool intel_bios_get_dsc_params(struct in
 		if (!(child->device_type & DEVICE_TYPE_MIPI_OUTPUT))
 			continue;
 
-		if (child->dvo_port - DVO_PORT_MIPIA == encoder->port) {
+		if (dsi_dvo_port_to_port(i915, child->dvo_port) == encoder->port) {
 			if (!devdata->dsc)
 				return false;
 


