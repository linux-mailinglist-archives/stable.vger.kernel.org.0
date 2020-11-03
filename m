Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DDD72A385C
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 02:19:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727438AbgKCBTB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 20:19:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:60558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727424AbgKCBS7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Nov 2020 20:18:59 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CCDA8223AC;
        Tue,  3 Nov 2020 01:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604366338;
        bh=VLse2Z6NhS8fDKFaVBcSRIry1Vxk7y3pzIPZuEQfV0M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=at9LW8jMdKoGBYl7dNXSFxD8wCpJilgUrAQhr4fzkxB4Ezz1v/XBgTn2peUNE1fvb
         Ty5k7UGwsbOqORaxl3et7lf5+YxkRuTpAzPUq2aM7QEWyvu5aShHZaSymN9zILBBMa
         6kc/2Gz4d5BLVCageqLW9JT5BUqs9kYqNF9S15+M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maxime Ripard <maxime@cerno.tech>,
        Taras Galchenko <tpgalchenko@gmail.com>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.9 13/35] drm/sun4i: frontend: Reuse the ch0 phase for RGB formats
Date:   Mon,  2 Nov 2020 20:18:18 -0500
Message-Id: <20201103011840.182814-13-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201103011840.182814-1-sashal@kernel.org>
References: <20201103011840.182814-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Ripard <maxime@cerno.tech>

[ Upstream commit 2db9ef9d9e6ea89a9feb5338f58d1f8f83875577 ]

When using the scaler on the A10-like frontend with single-planar formats,
the current code will setup the channel 0 filter (used for the R or Y
component) with a different phase parameter than the channel 1 filter (used
for the G/B or U/V components).

This creates a bleed out that keeps repeating on of the last line of the
RGB plane across the rest of the display. The Allwinner BSP either applies
the same phase parameter over both channels or use a separate one, the
condition being whether the input format is YUV420 or not.

Since YUV420 is both subsampled and multi-planar, and since YUYV is
subsampled but single-planar, we can rule out the subsampling and assume
that the condition is actually whether the format is single or
multi-planar. And it looks like applying the same phase parameter over both
channels for single-planar formats fixes our issue, while we keep the
multi-planar formats working properly.

Reported-by: Taras Galchenko <tpgalchenko@gmail.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Acked-by: Jernej Skrabec <jernej.skrabec@siol.net>
Link: https://patchwork.freedesktop.org/patch/msgid/20201015093642.261440-2-maxime@cerno.tech
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sun4i/sun4i_frontend.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/sun4i/sun4i_frontend.c b/drivers/gpu/drm/sun4i/sun4i_frontend.c
index 7462801b1fa8e..c4959d9e16391 100644
--- a/drivers/gpu/drm/sun4i/sun4i_frontend.c
+++ b/drivers/gpu/drm/sun4i/sun4i_frontend.c
@@ -407,6 +407,7 @@ int sun4i_frontend_update_formats(struct sun4i_frontend *frontend,
 	struct drm_framebuffer *fb = state->fb;
 	const struct drm_format_info *format = fb->format;
 	uint64_t modifier = fb->modifier;
+	unsigned int ch1_phase_idx;
 	u32 out_fmt_val;
 	u32 in_fmt_val, in_mod_val, in_ps_val;
 	unsigned int i;
@@ -442,18 +443,19 @@ int sun4i_frontend_update_formats(struct sun4i_frontend *frontend,
 	 * I have no idea what this does exactly, but it seems to be
 	 * related to the scaler FIR filter phase parameters.
 	 */
+	ch1_phase_idx = (format->num_planes > 1) ? 1 : 0;
 	regmap_write(frontend->regs, SUN4I_FRONTEND_CH0_HORZPHASE_REG,
 		     frontend->data->ch_phase[0]);
 	regmap_write(frontend->regs, SUN4I_FRONTEND_CH1_HORZPHASE_REG,
-		     frontend->data->ch_phase[1]);
+		     frontend->data->ch_phase[ch1_phase_idx]);
 	regmap_write(frontend->regs, SUN4I_FRONTEND_CH0_VERTPHASE0_REG,
 		     frontend->data->ch_phase[0]);
 	regmap_write(frontend->regs, SUN4I_FRONTEND_CH1_VERTPHASE0_REG,
-		     frontend->data->ch_phase[1]);
+		     frontend->data->ch_phase[ch1_phase_idx]);
 	regmap_write(frontend->regs, SUN4I_FRONTEND_CH0_VERTPHASE1_REG,
 		     frontend->data->ch_phase[0]);
 	regmap_write(frontend->regs, SUN4I_FRONTEND_CH1_VERTPHASE1_REG,
-		     frontend->data->ch_phase[1]);
+		     frontend->data->ch_phase[ch1_phase_idx]);
 
 	/*
 	 * Checking the input format is sufficient since we currently only
-- 
2.27.0

