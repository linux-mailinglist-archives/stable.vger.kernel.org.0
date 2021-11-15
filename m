Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F156451EF7
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:35:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344432AbhKPAiJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:38:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:45126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344597AbhKOTZE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C2C3063699;
        Mon, 15 Nov 2021 19:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002853;
        bh=xizWIrRy1p+QFp6NVczNGyk8vn/MqFpq6Vbc24WtEzM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ozUmv11QXCLkrFEKSiBXorzZ+ed50AqCu5z4iLJUvH0zZKDlzeiOTn3/Xa+Reb9wT
         dJwqwm3gFDrqSbSuJ7aMkVwJmJHPDPrtPdoVDGE2qAQAMWyeMz1gg9jSjsrKyicoRl
         k2OPBJ/s1K+cPg3cltMoenMqFa1R/r8QoRDIPrNM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Guido=20G=C3=BCnther?= <agx@sigxcpu.org>,
        Lucas Stach <l.stach@pengutronix.de>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 720/917] drm/bridge: nwl-dsi: Add atomic_get_input_bus_fmts
Date:   Mon, 15 Nov 2021 18:03:35 +0100
Message-Id: <20211115165453.318721839@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guido Günther <agx@sigxcpu.org>

[ Upstream commit 2f1495fac8d38bfade18bd7e31fa787cd7815626 ]

Components further up in the chain might ask us for supported formats.

Without this MEDIA_BUS_FMT_FIXED is assumed which then breaks display
output with mxsfb since it can't determine a proper bus format.

We handle the bus formats that correspond to the DSI formats the bridge
can potentially output (see chapter 13.6 of the i.MX 8MQ reference
manual) - which matches what xsfb can input.

Fixes: b776b0f00f24 ("drm: mxsfb: Use bus_format from the nearest bridge if present")

Signed-off-by: Guido Günther <agx@sigxcpu.org>
Reviewed-by: Lucas Stach <l.stach@pengutronix.de>
Reviewed-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/1712f2b952694fd4484dfd8576fbc5b4d7adf042.1633959458.git.agx@sigxcpu.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/nwl-dsi.c | 35 ++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/drivers/gpu/drm/bridge/nwl-dsi.c b/drivers/gpu/drm/bridge/nwl-dsi.c
index ed8ac5059cd26..a7389a0facfb4 100644
--- a/drivers/gpu/drm/bridge/nwl-dsi.c
+++ b/drivers/gpu/drm/bridge/nwl-dsi.c
@@ -939,6 +939,40 @@ static void nwl_dsi_bridge_detach(struct drm_bridge *bridge)
 	drm_of_panel_bridge_remove(dsi->dev->of_node, 1, 0);
 }
 
+static u32 *nwl_bridge_atomic_get_input_bus_fmts(struct drm_bridge *bridge,
+						 struct drm_bridge_state *bridge_state,
+						 struct drm_crtc_state *crtc_state,
+						 struct drm_connector_state *conn_state,
+						 u32 output_fmt,
+						 unsigned int *num_input_fmts)
+{
+	u32 *input_fmts, input_fmt;
+
+	*num_input_fmts = 0;
+
+	switch (output_fmt) {
+	/* If MEDIA_BUS_FMT_FIXED is tested, return default bus format */
+	case MEDIA_BUS_FMT_FIXED:
+		input_fmt = MEDIA_BUS_FMT_RGB888_1X24;
+		break;
+	case MEDIA_BUS_FMT_RGB888_1X24:
+	case MEDIA_BUS_FMT_RGB666_1X18:
+	case MEDIA_BUS_FMT_RGB565_1X16:
+		input_fmt = output_fmt;
+		break;
+	default:
+		return NULL;
+	}
+
+	input_fmts = kcalloc(1, sizeof(*input_fmts), GFP_KERNEL);
+	if (!input_fmts)
+		return NULL;
+	input_fmts[0] = input_fmt;
+	*num_input_fmts = 1;
+
+	return input_fmts;
+}
+
 static const struct drm_bridge_funcs nwl_dsi_bridge_funcs = {
 	.atomic_duplicate_state	= drm_atomic_helper_bridge_duplicate_state,
 	.atomic_destroy_state	= drm_atomic_helper_bridge_destroy_state,
@@ -946,6 +980,7 @@ static const struct drm_bridge_funcs nwl_dsi_bridge_funcs = {
 	.atomic_check		= nwl_dsi_bridge_atomic_check,
 	.atomic_enable		= nwl_dsi_bridge_atomic_enable,
 	.atomic_disable		= nwl_dsi_bridge_atomic_disable,
+	.atomic_get_input_bus_fmts = nwl_bridge_atomic_get_input_bus_fmts,
 	.mode_set		= nwl_dsi_bridge_mode_set,
 	.mode_valid		= nwl_dsi_bridge_mode_valid,
 	.attach			= nwl_dsi_bridge_attach,
-- 
2.33.0



