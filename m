Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F39C3499087
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:04:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350335AbiAXUBC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:01:02 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:54610 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359280AbiAXT6O (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:58:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E9C160916;
        Mon, 24 Jan 2022 19:58:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 111CFC340EA;
        Mon, 24 Jan 2022 19:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054292;
        bh=WQCIdyoCBqzT1RiVCy6TIWZuU6QVvUeH/y9HpzGEJrU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wLTuJfk0AksQz20HkkHE+WIfjZQFjixYTiWjqGjJ7ysQiTnpVWxZtCsrHB5XK9e9e
         fMxW0dBa+4FtNvIExqIfbr9/FCNUyYeeg2V3LrH2MeuoMByL2KZg/7Zyt0K5nan3hD
         g2bFzW2/47g5FncWQI0vZGNRiQZBF9dCs/8vE2J0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 341/563] drm: rcar-du: Fix CRTC timings when CMM is used
Date:   Mon, 24 Jan 2022 19:41:46 +0100
Message-Id: <20220124184036.217959039@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

[ Upstream commit f0ce591dc9a97067c6e783a2eaccd22c5476144d ]

When the CMM is enabled, an offset of 25 pixels must be subtracted from
the HDS (horizontal display start) and HDE (horizontal display end)
registers. Fix the timings calculation, and take this into account in
the mode validation.

This fixes a visible horizontal offset in the image with VGA monitors.
HDMI monitors seem to be generally more tolerant to incorrect timings,
but may be affected too.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rcar-du/rcar_du_crtc.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
index 1b9738e44909d..065604c5837de 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
@@ -215,6 +215,7 @@ static void rcar_du_crtc_set_display_timing(struct rcar_du_crtc *rcrtc)
 	const struct drm_display_mode *mode = &rcrtc->crtc.state->adjusted_mode;
 	struct rcar_du_device *rcdu = rcrtc->dev;
 	unsigned long mode_clock = mode->clock * 1000;
+	unsigned int hdse_offset;
 	u32 dsmr;
 	u32 escr;
 
@@ -298,10 +299,15 @@ static void rcar_du_crtc_set_display_timing(struct rcar_du_crtc *rcrtc)
 	     | DSMR_DIPM_DISP | DSMR_CSPM;
 	rcar_du_crtc_write(rcrtc, DSMR, dsmr);
 
+	hdse_offset = 19;
+	if (rcrtc->group->cmms_mask & BIT(rcrtc->index % 2))
+		hdse_offset += 25;
+
 	/* Display timings */
-	rcar_du_crtc_write(rcrtc, HDSR, mode->htotal - mode->hsync_start - 19);
+	rcar_du_crtc_write(rcrtc, HDSR, mode->htotal - mode->hsync_start -
+					hdse_offset);
 	rcar_du_crtc_write(rcrtc, HDER, mode->htotal - mode->hsync_start +
-					mode->hdisplay - 19);
+					mode->hdisplay - hdse_offset);
 	rcar_du_crtc_write(rcrtc, HSWR, mode->hsync_end -
 					mode->hsync_start - 1);
 	rcar_du_crtc_write(rcrtc, HCR,  mode->htotal - 1);
@@ -831,6 +837,7 @@ rcar_du_crtc_mode_valid(struct drm_crtc *crtc,
 	struct rcar_du_crtc *rcrtc = to_rcar_crtc(crtc);
 	struct rcar_du_device *rcdu = rcrtc->dev;
 	bool interlaced = mode->flags & DRM_MODE_FLAG_INTERLACE;
+	unsigned int min_sync_porch;
 	unsigned int vbp;
 
 	if (interlaced && !rcar_du_has(rcdu, RCAR_DU_FEATURE_INTERLACED))
@@ -838,9 +845,14 @@ rcar_du_crtc_mode_valid(struct drm_crtc *crtc,
 
 	/*
 	 * The hardware requires a minimum combined horizontal sync and back
-	 * porch of 20 pixels and a minimum vertical back porch of 3 lines.
+	 * porch of 20 pixels (when CMM isn't used) or 45 pixels (when CMM is
+	 * used), and a minimum vertical back porch of 3 lines.
 	 */
-	if (mode->htotal - mode->hsync_start < 20)
+	min_sync_porch = 20;
+	if (rcrtc->group->cmms_mask & BIT(rcrtc->index % 2))
+		min_sync_porch += 25;
+
+	if (mode->htotal - mode->hsync_start < min_sync_porch)
 		return MODE_HBLANK_NARROW;
 
 	vbp = (mode->vtotal - mode->vsync_end) / (interlaced ? 2 : 1);
-- 
2.34.1



