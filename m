Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD5B749A398
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2368535AbiAXX7X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:59:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1846413AbiAXXPz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:15:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50C84C0604CE;
        Mon, 24 Jan 2022 13:24:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E3ABC61320;
        Mon, 24 Jan 2022 21:24:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7EB7C340E4;
        Mon, 24 Jan 2022 21:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059444;
        bh=TH+ekF/q/S4B463GdM+Q95pPIb/BpaQu6eM3YQyRVhg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pT3VfVKn+sgdzUmeyzhbRHcY2h+F1/VLXHA43kjXuNp+NhAB7eKkCxlkSdkgI7fZi
         oStaB5PA2ov8Fy9ZtKTph5poREiNJzEX5JQAGMjABFKxkiB+3e6vkDw89ex2jHYfFh
         BqaEa6tm2mcA/Vgo8Ntcrtq8TTeoXrbKaF3/J7Jk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0616/1039] drm: rcar-du: Fix CRTC timings when CMM is used
Date:   Mon, 24 Jan 2022 19:40:05 +0100
Message-Id: <20220124184146.042359307@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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
index 5236f917cc68d..f361a604337f6 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
@@ -215,6 +215,7 @@ static void rcar_du_crtc_set_display_timing(struct rcar_du_crtc *rcrtc)
 	const struct drm_display_mode *mode = &rcrtc->crtc.state->adjusted_mode;
 	struct rcar_du_device *rcdu = rcrtc->dev;
 	unsigned long mode_clock = mode->clock * 1000;
+	unsigned int hdse_offset;
 	u32 dsmr;
 	u32 escr;
 
@@ -299,10 +300,15 @@ static void rcar_du_crtc_set_display_timing(struct rcar_du_crtc *rcrtc)
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
@@ -837,6 +843,7 @@ rcar_du_crtc_mode_valid(struct drm_crtc *crtc,
 	struct rcar_du_crtc *rcrtc = to_rcar_crtc(crtc);
 	struct rcar_du_device *rcdu = rcrtc->dev;
 	bool interlaced = mode->flags & DRM_MODE_FLAG_INTERLACE;
+	unsigned int min_sync_porch;
 	unsigned int vbp;
 
 	if (interlaced && !rcar_du_has(rcdu, RCAR_DU_FEATURE_INTERLACED))
@@ -844,9 +851,14 @@ rcar_du_crtc_mode_valid(struct drm_crtc *crtc,
 
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



