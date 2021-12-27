Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D2E247FFB9
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:41:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238582AbhL0Pk6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:40:58 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38854 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239157AbhL0Piw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:38:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8CAA06110F;
        Mon, 27 Dec 2021 15:38:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7088DC36AEA;
        Mon, 27 Dec 2021 15:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619532;
        bh=tNInkdAZZkaXO3IhqaXhNQSRyo0RbBYlB7OgWOC5Cqs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qw/iOO7PS8E37kHbJiZyWRqfDz9AFWkTJlfTh6HpA8i/4RAH7fAdyGfAdcd0W07UC
         0Exn+CVsF2GIWg20gPhXdW8qKBXVyDBVqrcLLIEEX1erZHhGWRSzmg3KwYIiVbAC9A
         +tBuFXlXsTVfYMJ0GEL9TBa4+L67MmZAAukDVSm8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christian Hewitt <christianshewitt@gmail.com>,
        Geraldo Nascimento <geraldogabriel@gmail.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 39/76] ASoC: meson: aiu: Move AIU_I2S_MISC hold setting to aiu-fifo-i2s
Date:   Mon, 27 Dec 2021 16:30:54 +0100
Message-Id: <20211227151326.064690030@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151324.694661623@linuxfoundation.org>
References: <20211227151324.694661623@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

commit ee907afb0c39a41ee74b862882cfe12820c74b98 upstream.

The out-of-tree vendor driver uses the following approach to set the
AIU_I2S_MISC register:
1) write AIU_MEM_I2S_START_PTR and AIU_MEM_I2S_RD_PTR
2) configure AIU_I2S_MUTE_SWAP[15:0]
3) write AIU_MEM_I2S_END_PTR
4) set AIU_I2S_MISC[2] to 1 (documented as: "put I2S interface in hold
   mode")
5) set AIU_I2S_MISC[4] to 1 (depending on the driver revision it always
   stays at 1 while for older drivers this bit is unset in step 4)
6) set AIU_I2S_MISC[2] to 0
7) write AIU_MEM_I2S_MASKS
8) toggle AIU_MEM_I2S_CONTROL[0]
9) toggle AIU_MEM_I2S_BUF_CNTL[0]

Move setting the AIU_I2S_MISC[2] bit to aiu_fifo_i2s_hw_params() so it
resembles the flow in the vendor kernel more closely. While here also
configure AIU_I2S_MISC[4] (documented as: "force each audio data to
left or right according to the bit attached with the audio data")
similar to how the vendor driver does this. This fixes the infamous and
long-standing "machine gun noise" issue (a buffer underrun issue).

Fixes: 6ae9ca9ce986bf ("ASoC: meson: aiu: add i2s and spdif support")
Reported-by: Christian Hewitt <christianshewitt@gmail.com>
Reported-by: Geraldo Nascimento <geraldogabriel@gmail.com>
Tested-by: Christian Hewitt <christianshewitt@gmail.com>
Tested-by: Geraldo Nascimento <geraldogabriel@gmail.com>
Acked-by: Jerome Brunet <jbrunet@baylibre.com>
Cc: stable@vger.kernel.org
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Link: https://lore.kernel.org/r/20211206210804.2512999-3-martin.blumenstingl@googlemail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/meson/aiu-encoder-i2s.c |   33 ---------------------------------
 sound/soc/meson/aiu-fifo-i2s.c    |   19 +++++++++++++++++++
 2 files changed, 19 insertions(+), 33 deletions(-)

--- a/sound/soc/meson/aiu-encoder-i2s.c
+++ b/sound/soc/meson/aiu-encoder-i2s.c
@@ -18,7 +18,6 @@
 #define AIU_RST_SOFT_I2S_FAST		BIT(0)
 
 #define AIU_I2S_DAC_CFG_MSB_FIRST	BIT(2)
-#define AIU_I2S_MISC_HOLD_EN		BIT(2)
 #define AIU_CLK_CTRL_I2S_DIV_EN		BIT(0)
 #define AIU_CLK_CTRL_I2S_DIV		GENMASK(3, 2)
 #define AIU_CLK_CTRL_AOCLK_INVERT	BIT(6)
@@ -36,37 +35,6 @@ static void aiu_encoder_i2s_divider_enab
 				      enable ? AIU_CLK_CTRL_I2S_DIV_EN : 0);
 }
 
-static void aiu_encoder_i2s_hold(struct snd_soc_component *component,
-				 bool enable)
-{
-	snd_soc_component_update_bits(component, AIU_I2S_MISC,
-				      AIU_I2S_MISC_HOLD_EN,
-				      enable ? AIU_I2S_MISC_HOLD_EN : 0);
-}
-
-static int aiu_encoder_i2s_trigger(struct snd_pcm_substream *substream, int cmd,
-				   struct snd_soc_dai *dai)
-{
-	struct snd_soc_component *component = dai->component;
-
-	switch (cmd) {
-	case SNDRV_PCM_TRIGGER_START:
-	case SNDRV_PCM_TRIGGER_RESUME:
-	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
-		aiu_encoder_i2s_hold(component, false);
-		return 0;
-
-	case SNDRV_PCM_TRIGGER_STOP:
-	case SNDRV_PCM_TRIGGER_SUSPEND:
-	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
-		aiu_encoder_i2s_hold(component, true);
-		return 0;
-
-	default:
-		return -EINVAL;
-	}
-}
-
 static int aiu_encoder_i2s_setup_desc(struct snd_soc_component *component,
 				      struct snd_pcm_hw_params *params)
 {
@@ -353,7 +321,6 @@ static void aiu_encoder_i2s_shutdown(str
 }
 
 const struct snd_soc_dai_ops aiu_encoder_i2s_dai_ops = {
-	.trigger	= aiu_encoder_i2s_trigger,
 	.hw_params	= aiu_encoder_i2s_hw_params,
 	.hw_free	= aiu_encoder_i2s_hw_free,
 	.set_fmt	= aiu_encoder_i2s_set_fmt,
--- a/sound/soc/meson/aiu-fifo-i2s.c
+++ b/sound/soc/meson/aiu-fifo-i2s.c
@@ -20,6 +20,8 @@
 #define AIU_MEM_I2S_CONTROL_MODE_16BIT	BIT(6)
 #define AIU_MEM_I2S_BUF_CNTL_INIT	BIT(0)
 #define AIU_RST_SOFT_I2S_FAST		BIT(0)
+#define AIU_I2S_MISC_HOLD_EN		BIT(2)
+#define AIU_I2S_MISC_FORCE_LEFT_RIGHT	BIT(4)
 
 #define AIU_FIFO_I2S_BLOCK		256
 
@@ -90,6 +92,10 @@ static int aiu_fifo_i2s_hw_params(struct
 	unsigned int val;
 	int ret;
 
+	snd_soc_component_update_bits(component, AIU_I2S_MISC,
+				      AIU_I2S_MISC_HOLD_EN,
+				      AIU_I2S_MISC_HOLD_EN);
+
 	ret = aiu_fifo_hw_params(substream, params, dai);
 	if (ret)
 		return ret;
@@ -117,6 +123,19 @@ static int aiu_fifo_i2s_hw_params(struct
 	snd_soc_component_update_bits(component, AIU_MEM_I2S_MASKS,
 				      AIU_MEM_I2S_MASKS_IRQ_BLOCK, val);
 
+	/*
+	 * Most (all?) supported SoCs have this bit set by default. The vendor
+	 * driver however sets it manually (depending on the version either
+	 * while un-setting AIU_I2S_MISC_HOLD_EN or right before that). Follow
+	 * the same approach for consistency with the vendor driver.
+	 */
+	snd_soc_component_update_bits(component, AIU_I2S_MISC,
+				      AIU_I2S_MISC_FORCE_LEFT_RIGHT,
+				      AIU_I2S_MISC_FORCE_LEFT_RIGHT);
+
+	snd_soc_component_update_bits(component, AIU_I2S_MISC,
+				      AIU_I2S_MISC_HOLD_EN, 0);
+
 	return 0;
 }
 


