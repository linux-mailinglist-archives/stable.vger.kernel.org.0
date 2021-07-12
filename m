Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F33BA3C4759
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237013AbhGLGc0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:32:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:52498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236348AbhGLGaD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:30:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1121601FC;
        Mon, 12 Jul 2021 06:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071235;
        bh=4zb0nI70uBJmnk/z8cLE1PcSxMDTyoA7mh/iJBg4bb8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XfNjcrJ8HtfOgr6YVKnc2+O4jD7HYYmVsXzd07czim9GTyDGYl9r75LlpVihqA4ys
         E3rqjOyjHTDcnd++Ca/zAs8p69FTu4y5p4CvU/Y6KvU/9kKSOI/oXVh4BIIotUwbuj
         SSaxRUo17UxZ1Caa7swx04dNLviV5P3egsbOs0q4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 331/348] ASoC: atmel-i2s: Fix usage of capture and playback at the same time
Date:   Mon, 12 Jul 2021 08:11:55 +0200
Message-Id: <20210712060748.062258760@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>

[ Upstream commit 3b7961a326f8a7e03f54a19f02fedae8d488b80f ]

For both capture and playback streams to work at the same time, only the
needed values from a register need to be updated. Also, clocks should be
enabled only when the first stream is started and stopped when there is no
running stream.

Fixes: b543e467d1a9 ("ASoC: atmel-i2s: add driver for the new Atmel I2S controller")
Signed-off-by: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
Link: https://lore.kernel.org/r/20210618150741.401739-2-codrin.ciubotariu@microchip.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/atmel/atmel-i2s.c | 34 ++++++++++++++++++++++++++--------
 1 file changed, 26 insertions(+), 8 deletions(-)

diff --git a/sound/soc/atmel/atmel-i2s.c b/sound/soc/atmel/atmel-i2s.c
index bbe2b638abb5..d870f56c44cf 100644
--- a/sound/soc/atmel/atmel-i2s.c
+++ b/sound/soc/atmel/atmel-i2s.c
@@ -200,6 +200,7 @@ struct atmel_i2s_dev {
 	unsigned int				fmt;
 	const struct atmel_i2s_gck_param	*gck_param;
 	const struct atmel_i2s_caps		*caps;
+	int					clk_use_no;
 };
 
 static irqreturn_t atmel_i2s_interrupt(int irq, void *dev_id)
@@ -321,9 +322,16 @@ static int atmel_i2s_hw_params(struct snd_pcm_substream *substream,
 {
 	struct atmel_i2s_dev *dev = snd_soc_dai_get_drvdata(dai);
 	bool is_playback = (substream->stream == SNDRV_PCM_STREAM_PLAYBACK);
-	unsigned int mr = 0;
+	unsigned int mr = 0, mr_mask;
 	int ret;
 
+	mr_mask = ATMEL_I2SC_MR_FORMAT_MASK | ATMEL_I2SC_MR_MODE_MASK |
+		ATMEL_I2SC_MR_DATALENGTH_MASK;
+	if (is_playback)
+		mr_mask |= ATMEL_I2SC_MR_TXMONO;
+	else
+		mr_mask |= ATMEL_I2SC_MR_RXMONO;
+
 	switch (dev->fmt & SND_SOC_DAIFMT_FORMAT_MASK) {
 	case SND_SOC_DAIFMT_I2S:
 		mr |= ATMEL_I2SC_MR_FORMAT_I2S;
@@ -402,7 +410,7 @@ static int atmel_i2s_hw_params(struct snd_pcm_substream *substream,
 		return -EINVAL;
 	}
 
-	return regmap_write(dev->regmap, ATMEL_I2SC_MR, mr);
+	return regmap_update_bits(dev->regmap, ATMEL_I2SC_MR, mr_mask, mr);
 }
 
 static int atmel_i2s_switch_mck_generator(struct atmel_i2s_dev *dev,
@@ -495,18 +503,28 @@ static int atmel_i2s_trigger(struct snd_pcm_substream *substream, int cmd,
 	is_master = (mr & ATMEL_I2SC_MR_MODE_MASK) == ATMEL_I2SC_MR_MODE_MASTER;
 
 	/* If master starts, enable the audio clock. */
-	if (is_master && mck_enabled)
-		err = atmel_i2s_switch_mck_generator(dev, true);
-	if (err)
-		return err;
+	if (is_master && mck_enabled) {
+		if (!dev->clk_use_no) {
+			err = atmel_i2s_switch_mck_generator(dev, true);
+			if (err)
+				return err;
+		}
+		dev->clk_use_no++;
+	}
 
 	err = regmap_write(dev->regmap, ATMEL_I2SC_CR, cr);
 	if (err)
 		return err;
 
 	/* If master stops, disable the audio clock. */
-	if (is_master && !mck_enabled)
-		err = atmel_i2s_switch_mck_generator(dev, false);
+	if (is_master && !mck_enabled) {
+		if (dev->clk_use_no == 1) {
+			err = atmel_i2s_switch_mck_generator(dev, false);
+			if (err)
+				return err;
+		}
+		dev->clk_use_no--;
+	}
 
 	return err;
 }
-- 
2.30.2



