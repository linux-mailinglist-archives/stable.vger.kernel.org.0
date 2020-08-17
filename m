Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51DD6246B5E
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387942AbgHQPxr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:53:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:40692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387939AbgHQPxm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:53:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 573682063A;
        Mon, 17 Aug 2020 15:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679621;
        bh=Fiw50jeqkobRhQDGKeJkItSxQGeO+dfc6ICco/9FPvY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uMF5jYdgnvubI/m3Qk1FoWe7UiJWGHahFr9fqHpbzHsbSC1994uSvwrgaNwvKkAM+
         C5b3rrEx4rsoCsvx6E2AUySkAEkIsGvQZS8Y/vFPLZeIots1J1DPvoW92MNKmglg8i
         qCIohrIz8oxncvO29yPijRYf8JGh2wV1L88uWduw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jerome Brunet <jbrunet@baylibre.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 277/393] ASoC: meson: axg-tdm-formatters: fix sclk inversion
Date:   Mon, 17 Aug 2020 17:15:27 +0200
Message-Id: <20200817143833.056492499@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jerome Brunet <jbrunet@baylibre.com>

[ Upstream commit 0d3f01dcdc234001f979a0af0b6b31cb9f25b6c1 ]

After carefully checking, it appears that both tdmout and tdmin require the
rising edge of the sclk they get to be synchronized with the frame sync
event (which should be a rising edge of lrclk).

TDMIN was improperly set before this patch. Remove the sclk_invert quirk
which is no longer needed and fix the sclk phase.

Fixes: 1a11d88f499c ("ASoC: meson: add tdm formatter base driver")
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Link: https://lore.kernel.org/r/20200729154456.1983396-4-jbrunet@baylibre.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/meson/axg-tdm-formatter.c | 11 ++++++-----
 sound/soc/meson/axg-tdm-formatter.h |  1 -
 sound/soc/meson/axg-tdmin.c         |  2 --
 sound/soc/meson/axg-tdmout.c        |  3 ---
 4 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/sound/soc/meson/axg-tdm-formatter.c b/sound/soc/meson/axg-tdm-formatter.c
index 358c8c0d861cd..f7e8e9da68a06 100644
--- a/sound/soc/meson/axg-tdm-formatter.c
+++ b/sound/soc/meson/axg-tdm-formatter.c
@@ -70,7 +70,7 @@ EXPORT_SYMBOL_GPL(axg_tdm_formatter_set_channel_masks);
 static int axg_tdm_formatter_enable(struct axg_tdm_formatter *formatter)
 {
 	struct axg_tdm_stream *ts = formatter->stream;
-	bool invert = formatter->drv->quirks->invert_sclk;
+	bool invert;
 	int ret;
 
 	/* Do nothing if the formatter is already enabled */
@@ -96,11 +96,12 @@ static int axg_tdm_formatter_enable(struct axg_tdm_formatter *formatter)
 		return ret;
 
 	/*
-	 * If sclk is inverted, invert it back and provide the inversion
-	 * required by the formatter
+	 * If sclk is inverted, it means the bit should latched on the
+	 * rising edge which is what our HW expects. If not, we need to
+	 * invert it before the formatter.
 	 */
-	invert ^= axg_tdm_sclk_invert(ts->iface->fmt);
-	ret = clk_set_phase(formatter->sclk, invert ? 180 : 0);
+	invert = axg_tdm_sclk_invert(ts->iface->fmt);
+	ret = clk_set_phase(formatter->sclk, invert ? 0 : 180);
 	if (ret)
 		return ret;
 
diff --git a/sound/soc/meson/axg-tdm-formatter.h b/sound/soc/meson/axg-tdm-formatter.h
index 9ef98e955cb27..a1f0dcc0ff134 100644
--- a/sound/soc/meson/axg-tdm-formatter.h
+++ b/sound/soc/meson/axg-tdm-formatter.h
@@ -16,7 +16,6 @@ struct snd_kcontrol;
 
 struct axg_tdm_formatter_hw {
 	unsigned int skew_offset;
-	bool invert_sclk;
 };
 
 struct axg_tdm_formatter_ops {
diff --git a/sound/soc/meson/axg-tdmin.c b/sound/soc/meson/axg-tdmin.c
index 3d002b4eb939e..88ed95ae886bb 100644
--- a/sound/soc/meson/axg-tdmin.c
+++ b/sound/soc/meson/axg-tdmin.c
@@ -228,7 +228,6 @@ static const struct axg_tdm_formatter_driver axg_tdmin_drv = {
 	.regmap_cfg	= &axg_tdmin_regmap_cfg,
 	.ops		= &axg_tdmin_ops,
 	.quirks		= &(const struct axg_tdm_formatter_hw) {
-		.invert_sclk	= false,
 		.skew_offset	= 2,
 	},
 };
@@ -238,7 +237,6 @@ static const struct axg_tdm_formatter_driver g12a_tdmin_drv = {
 	.regmap_cfg	= &axg_tdmin_regmap_cfg,
 	.ops		= &axg_tdmin_ops,
 	.quirks		= &(const struct axg_tdm_formatter_hw) {
-		.invert_sclk	= false,
 		.skew_offset	= 3,
 	},
 };
diff --git a/sound/soc/meson/axg-tdmout.c b/sound/soc/meson/axg-tdmout.c
index 418ec314b37d4..3ceabddae629e 100644
--- a/sound/soc/meson/axg-tdmout.c
+++ b/sound/soc/meson/axg-tdmout.c
@@ -238,7 +238,6 @@ static const struct axg_tdm_formatter_driver axg_tdmout_drv = {
 	.regmap_cfg	= &axg_tdmout_regmap_cfg,
 	.ops		= &axg_tdmout_ops,
 	.quirks		= &(const struct axg_tdm_formatter_hw) {
-		.invert_sclk = true,
 		.skew_offset = 1,
 	},
 };
@@ -248,7 +247,6 @@ static const struct axg_tdm_formatter_driver g12a_tdmout_drv = {
 	.regmap_cfg	= &axg_tdmout_regmap_cfg,
 	.ops		= &axg_tdmout_ops,
 	.quirks		= &(const struct axg_tdm_formatter_hw) {
-		.invert_sclk = true,
 		.skew_offset = 2,
 	},
 };
@@ -309,7 +307,6 @@ static const struct axg_tdm_formatter_driver sm1_tdmout_drv = {
 	.regmap_cfg	= &axg_tdmout_regmap_cfg,
 	.ops		= &axg_tdmout_ops,
 	.quirks		= &(const struct axg_tdm_formatter_hw) {
-		.invert_sclk = true,
 		.skew_offset = 2,
 	},
 };
-- 
2.25.1



