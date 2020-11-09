Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA60F2ABA73
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:23:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732305AbgKINT0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:19:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:46806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387742AbgKINTZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:19:25 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CE75206D8;
        Mon,  9 Nov 2020 13:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927964;
        bh=gdMGDMwySHdmXhfimYPXmMMVR+X1bgogAYC8Oh5fkF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VFxFOBMFtcV6B7Emm4Rg2WHDeNN30m+UU2+O2neDr2ULVRZSC7RGA/vmVVizW1U0G
         jieOlv+X0qr16RC81DNfOhbnVGu1Qs55HyFLiIFsfJW4CAQe/J2LrZN0gWU+Xsw4QV
         7fcG+x4rjx0deJ3ikIAaLLEwEVeLrYwEiVd5MFmo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Ripard <maxime@cerno.tech>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 081/133] drm/sun4i: frontend: Rework a bit the phase data
Date:   Mon,  9 Nov 2020 13:55:43 +0100
Message-Id: <20201109125034.617884910@linuxfoundation.org>
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

[ Upstream commit 84c971b356379c621df595bd00c3114579dfa59f ]

The scaler filter phase setup in the allwinner kernel has two different
cases for setting up the scaler filter, the first one using different phase
parameters for the two channels, and the second one reusing the first
channel parameters on the second channel.

The allwinner kernel has a third option where the horizontal phase of the
second channel will be set to a different value than the vertical one (and
seems like it's the same value than one used on the first channel).
However, that code path seems to never be taken, so we can ignore it for
now, and it's essentially what we're doing so far as well.

Since we will have always the same values across each components of the
filter setup for a given channel, we can simplify a bit our frontend
structure by only storing the phase value we want to apply to a given
channel.

Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Acked-by: Jernej Skrabec <jernej.skrabec@siol.net>
Link: https://patchwork.freedesktop.org/patch/msgid/20201015093642.261440-1-maxime@cerno.tech
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sun4i/sun4i_frontend.c | 34 ++++++--------------------
 drivers/gpu/drm/sun4i/sun4i_frontend.h |  6 +----
 2 files changed, 9 insertions(+), 31 deletions(-)

diff --git a/drivers/gpu/drm/sun4i/sun4i_frontend.c b/drivers/gpu/drm/sun4i/sun4i_frontend.c
index ec2a032e07b97..7462801b1fa8e 100644
--- a/drivers/gpu/drm/sun4i/sun4i_frontend.c
+++ b/drivers/gpu/drm/sun4i/sun4i_frontend.c
@@ -443,17 +443,17 @@ int sun4i_frontend_update_formats(struct sun4i_frontend *frontend,
 	 * related to the scaler FIR filter phase parameters.
 	 */
 	regmap_write(frontend->regs, SUN4I_FRONTEND_CH0_HORZPHASE_REG,
-		     frontend->data->ch_phase[0].horzphase);
+		     frontend->data->ch_phase[0]);
 	regmap_write(frontend->regs, SUN4I_FRONTEND_CH1_HORZPHASE_REG,
-		     frontend->data->ch_phase[1].horzphase);
+		     frontend->data->ch_phase[1]);
 	regmap_write(frontend->regs, SUN4I_FRONTEND_CH0_VERTPHASE0_REG,
-		     frontend->data->ch_phase[0].vertphase[0]);
+		     frontend->data->ch_phase[0]);
 	regmap_write(frontend->regs, SUN4I_FRONTEND_CH1_VERTPHASE0_REG,
-		     frontend->data->ch_phase[1].vertphase[0]);
+		     frontend->data->ch_phase[1]);
 	regmap_write(frontend->regs, SUN4I_FRONTEND_CH0_VERTPHASE1_REG,
-		     frontend->data->ch_phase[0].vertphase[1]);
+		     frontend->data->ch_phase[0]);
 	regmap_write(frontend->regs, SUN4I_FRONTEND_CH1_VERTPHASE1_REG,
-		     frontend->data->ch_phase[1].vertphase[1]);
+		     frontend->data->ch_phase[1]);
 
 	/*
 	 * Checking the input format is sufficient since we currently only
@@ -687,30 +687,12 @@ static const struct dev_pm_ops sun4i_frontend_pm_ops = {
 };
 
 static const struct sun4i_frontend_data sun4i_a10_frontend = {
-	.ch_phase		= {
-		{
-			.horzphase = 0,
-			.vertphase = { 0, 0 },
-		},
-		{
-			.horzphase = 0xfc000,
-			.vertphase = { 0xfc000, 0xfc000 },
-		},
-	},
+	.ch_phase		= { 0x000, 0xfc000 },
 	.has_coef_rdy		= true,
 };
 
 static const struct sun4i_frontend_data sun8i_a33_frontend = {
-	.ch_phase		= {
-		{
-			.horzphase = 0x400,
-			.vertphase = { 0x400, 0x400 },
-		},
-		{
-			.horzphase = 0x400,
-			.vertphase = { 0x400, 0x400 },
-		},
-	},
+	.ch_phase		= { 0x400, 0x400 },
 	.has_coef_access_ctrl	= true,
 };
 
diff --git a/drivers/gpu/drm/sun4i/sun4i_frontend.h b/drivers/gpu/drm/sun4i/sun4i_frontend.h
index 0c382c1ddb0fe..2e7b76e50c2ba 100644
--- a/drivers/gpu/drm/sun4i/sun4i_frontend.h
+++ b/drivers/gpu/drm/sun4i/sun4i_frontend.h
@@ -115,11 +115,7 @@ struct reset_control;
 struct sun4i_frontend_data {
 	bool	has_coef_access_ctrl;
 	bool	has_coef_rdy;
-
-	struct {
-		u32	horzphase;
-		u32	vertphase[2];
-	} ch_phase[2];
+	u32	ch_phase[2];
 };
 
 struct sun4i_frontend {
-- 
2.27.0



