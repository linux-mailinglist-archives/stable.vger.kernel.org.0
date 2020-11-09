Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B20052ABA75
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:23:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387784AbgKINTa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:19:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:46864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732846AbgKINT2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:19:28 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06FCD20731;
        Mon,  9 Nov 2020 13:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927967;
        bh=VLse2Z6NhS8fDKFaVBcSRIry1Vxk7y3pzIPZuEQfV0M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lmwAuid5MAy+9fVFdxYsLreC+w+riXKBpAiYArFVds6aswj3o0vB/Ccixatn2R9ze
         SqwJeum/MaYvsQRGTXmdtJrr0BoWn6SCVx+QoZQTqK87hpHJeTtGlNhUwCMyMc5vRn
         /+oIYjwQbrLJpK1s71Tp3CTj9kdG9JkPLjx7cw14=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taras Galchenko <tpgalchenko@gmail.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 082/133] drm/sun4i: frontend: Reuse the ch0 phase for RGB formats
Date:   Mon,  9 Nov 2020 13:55:44 +0100
Message-Id: <20201109125034.664942507@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
References: <20201109125030.706496283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



