Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 487D437CCD2
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236514AbhELQr7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:47:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:34162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243602AbhELQli (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:41:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1061A61C4F;
        Wed, 12 May 2021 16:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835520;
        bh=9WbnH3HSVs9b1JA+vBjbssA9+l1Sr1YhxpxqJG4IWxs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oFnWM7ruOGocZfYX6kqvk85iZFGjIwb6N43oVIS4SUYRze9i9osxiirRiLmCDc1fH
         0fZ33FDYkN5OewwMe4cFcdeEVJ1QD3jmmWE/uv+kownvNYVsS06UNW/W1ePB5EguT1
         3lRbSKMTgeTYJBcxMotpk7afd7o5TPDIeHySfbCI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Yannick Fertre <yannick.fertre@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Antonio Borneo <antonio.borneo@st.com>,
        Benjamin Gaignard <benjamin.gaignard@st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Philippe Cornu <philippe.cornu@st.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Vincent Abriou <vincent.abriou@st.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        Yannick Fertre <yannick.fertre@foss.st.com>,
        Philippe Cornu <philippe.cornu@foss.st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 342/677] drm/stm: Fix bus_flags handling
Date:   Wed, 12 May 2021 16:46:28 +0200
Message-Id: <20210512144848.647455738@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit 99e360442f223dd40fc23ae07c7a263836fd27e6 ]

The drm_display_mode_to_videomode() does not populate DISPLAY_FLAGS_DE_LOW
or DISPLAY_FLAGS_PIXDATA_NEGEDGE flags in struct videomode. Therefore, no
matter what polarity the next bridge or display might require, these flags
are never set, and thus the LTDC GCR_DEPOL and GCR_PCPOL bits are never set
and the LTDC behaves as if both DISPLAY_FLAGS_PIXDATA_POSEDGE and
DISPLAY_FLAGS_DE_HIGH were always set.

The fix for this problem is taken almost verbatim from MXSFB driver. In
case there is a bridge attached to the LTDC, the bridge might have extra
polarity requirements, so extract bus_flags from the bridge and use them
for LTDC configuration. Otherwise, extract bus_flags from the connector,
which is the display.

Fixes: b759012c5fa7 ("drm/stm: Add STM32 LTDC driver")
Signed-off-by: Marek Vasut <marex@denx.de>
Signed-off-by: Yannick Fertre <yannick.fertre@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Antonio Borneo <antonio.borneo@st.com>
Cc: Benjamin Gaignard <benjamin.gaignard@st.com>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Philippe Cornu <philippe.cornu@st.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Vincent Abriou <vincent.abriou@st.com>
Cc: Yannick Fertre <yannick.fertre@st.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-stm32@st-md-mailman.stormreply.com
To: dri-devel@lists.freedesktop.org
Tested-by: Yannick Fertre <yannick.fertre@foss.st.com>
Signed-off-by: Philippe Cornu <philippe.cornu@foss.st.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210127110756.125570-1-marex@denx.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/stm/ltdc.c | 33 +++++++++++++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/stm/ltdc.c b/drivers/gpu/drm/stm/ltdc.c
index 7812094f93d6..6f3b523e16e8 100644
--- a/drivers/gpu/drm/stm/ltdc.c
+++ b/drivers/gpu/drm/stm/ltdc.c
@@ -525,13 +525,42 @@ static void ltdc_crtc_mode_set_nofb(struct drm_crtc *crtc)
 {
 	struct ltdc_device *ldev = crtc_to_ltdc(crtc);
 	struct drm_device *ddev = crtc->dev;
+	struct drm_connector_list_iter iter;
+	struct drm_connector *connector = NULL;
+	struct drm_encoder *encoder = NULL;
+	struct drm_bridge *bridge = NULL;
 	struct drm_display_mode *mode = &crtc->state->adjusted_mode;
 	struct videomode vm;
 	u32 hsync, vsync, accum_hbp, accum_vbp, accum_act_w, accum_act_h;
 	u32 total_width, total_height;
+	u32 bus_flags = 0;
 	u32 val;
 	int ret;
 
+	/* get encoder from crtc */
+	drm_for_each_encoder(encoder, ddev)
+		if (encoder->crtc == crtc)
+			break;
+
+	if (encoder) {
+		/* get bridge from encoder */
+		list_for_each_entry(bridge, &encoder->bridge_chain, chain_node)
+			if (bridge->encoder == encoder)
+				break;
+
+		/* Get the connector from encoder */
+		drm_connector_list_iter_begin(ddev, &iter);
+		drm_for_each_connector_iter(connector, &iter)
+			if (connector->encoder == encoder)
+				break;
+		drm_connector_list_iter_end(&iter);
+	}
+
+	if (bridge && bridge->timings)
+		bus_flags = bridge->timings->input_bus_flags;
+	else if (connector)
+		bus_flags = connector->display_info.bus_flags;
+
 	if (!pm_runtime_active(ddev->dev)) {
 		ret = pm_runtime_get_sync(ddev->dev);
 		if (ret) {
@@ -567,10 +596,10 @@ static void ltdc_crtc_mode_set_nofb(struct drm_crtc *crtc)
 	if (vm.flags & DISPLAY_FLAGS_VSYNC_HIGH)
 		val |= GCR_VSPOL;
 
-	if (vm.flags & DISPLAY_FLAGS_DE_LOW)
+	if (bus_flags & DRM_BUS_FLAG_DE_LOW)
 		val |= GCR_DEPOL;
 
-	if (vm.flags & DISPLAY_FLAGS_PIXDATA_NEGEDGE)
+	if (bus_flags & DRM_BUS_FLAG_PIXDATA_DRIVE_NEGEDGE)
 		val |= GCR_PCPOL;
 
 	reg_update_bits(ldev->regs, LTDC_GCR,
-- 
2.30.2



