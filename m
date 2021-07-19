Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16B8A3CDE27
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:47:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344080AbhGSPCI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:02:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:53810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245719AbhGSO7C (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:59:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 14C9B613F3;
        Mon, 19 Jul 2021 15:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709002;
        bh=8pJA+G0n4iUQamhQpf38H+dZlIonVYD4OuPc0iKbylY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B8Lbb/1Q8/Gprt5H2QBg6ETrSSd4F0r6yN9M7c1XB1A7hG6B9qygBcyFe/dE1nlnU
         rm48rV3pMREFuzVFSgeN0jBQcdLSVx76ewPZbhikw3NjC2/Wckeo8WhtC6HZdE53AR
         u6E8XXFNAvKTuz2MfxG0YyysCZWrFbH/jA4VdNyc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 214/421] ASoC: atmel-i2s: Fix usage of capture and playback at the same time
Date:   Mon, 19 Jul 2021 16:50:25 +0200
Message-Id: <20210719144953.755692538@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
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
index d88c1d995036..99cc73150576 100644
--- a/sound/soc/atmel/atmel-i2s.c
+++ b/sound/soc/atmel/atmel-i2s.c
@@ -211,6 +211,7 @@ struct atmel_i2s_dev {
 	unsigned int				fmt;
 	const struct atmel_i2s_gck_param	*gck_param;
 	const struct atmel_i2s_caps		*caps;
+	int					clk_use_no;
 };
 
 static irqreturn_t atmel_i2s_interrupt(int irq, void *dev_id)
@@ -332,9 +333,16 @@ static int atmel_i2s_hw_params(struct snd_pcm_substream *substream,
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
@@ -413,7 +421,7 @@ static int atmel_i2s_hw_params(struct snd_pcm_substream *substream,
 		return -EINVAL;
 	}
 
-	return regmap_write(dev->regmap, ATMEL_I2SC_MR, mr);
+	return regmap_update_bits(dev->regmap, ATMEL_I2SC_MR, mr_mask, mr);
 }
 
 static int atmel_i2s_switch_mck_generator(struct atmel_i2s_dev *dev,
@@ -506,18 +514,28 @@ static int atmel_i2s_trigger(struct snd_pcm_substream *substream, int cmd,
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



