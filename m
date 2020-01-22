Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B23D0145055
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:45:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730354AbgAVJpl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:45:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:38098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388081AbgAVJol (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:44:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2247D24690;
        Wed, 22 Jan 2020 09:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579686280;
        bh=3kX5CUEDQLzmNuajY/ofqn3Il+qHT64BviXIQ9j8oOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gJCt4wuKGFcyP+WbsPZA8C9/4CzgSNP6qM8A2dfXyRdncZRXuG0T5RmlrtxO5W2Nc
         7QxQ4niog1TgxTnDpdvsmuPk4VnokAx52XmIhX/FLtliwJwjd5tqvFnoPlmgfuiKq/
         CFKt3tfz9DGWGZ75oSDDxfNdLRq/++WyPtWj1ibM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olivier Moysan <olivier.moysan@st.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 014/222] ASoC: stm32: sai: fix possible circular locking
Date:   Wed, 22 Jan 2020 10:26:40 +0100
Message-Id: <20200122092834.402474044@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olivier Moysan <olivier.moysan@st.com>

commit a14bf98c045bf119b7e779f186528e38c6428830 upstream.

In current driver, locks can be taken as follows:
- Register access: take a lock on regmap config and then on clock.
- Master clock provider: take a lock on clock and then on regmap config.
This can lead to the circular locking summarized below.

Remove peripheral clock management through regmap framework, and manage
peripheral clock in driver instead. On register access, lock on clock
is taken first, which allows to avoid possible locking issue.

[ 6696.561513] ======================================================
[ 6696.567670] WARNING: possible circular locking dependency detected
[ 6696.573842] 4.19.49 #866 Not tainted
[ 6696.577397] ------------------------------------------------------
[ 6696.583566] pulseaudio/6439 is trying to acquire lock:
[ 6696.588697] 87b0a25b (enable_lock){..-.}, at: clk_enable_lock+0x64/0x128
[ 6696.595377]
[ 6696.595377] but task is already holding lock:
[ 6696.601197] d858f825 (stm32_sai_sub:1342:(sai->regmap_config)->lock){....}
...
[ 6696.812513]  Possible unsafe locking scenario:
[ 6696.812513]
[ 6696.818418]        CPU0                    CPU1
[ 6696.822935]        ----                    ----
[ 6696.827451]   lock(stm32_sai_sub:1342:(sai->regmap_config)->lock);
[ 6696.833618]                                lock(enable_lock);
[ 6696.839350]                                lock(stm32_sai_sub:1342:
                                              (sai->regmap_config)->lock);
[ 6696.848035]   lock(enable_lock);

Fixes: 03e78a242a15 ("ASoC: stm32: sai: add h7 support")

Signed-off-by: Olivier Moysan <olivier.moysan@st.com>
Link: https://lore.kernel.org/r/20200109083254.478-1-olivier.moysan@st.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/stm/stm32_sai_sub.c |  196 ++++++++++++++++++++++++++++++------------
 1 file changed, 141 insertions(+), 55 deletions(-)

--- a/sound/soc/stm/stm32_sai_sub.c
+++ b/sound/soc/stm/stm32_sai_sub.c
@@ -184,6 +184,56 @@ static bool stm32_sai_sub_writeable_reg(
 	}
 }
 
+static int stm32_sai_sub_reg_up(struct stm32_sai_sub_data *sai,
+				unsigned int reg, unsigned int mask,
+				unsigned int val)
+{
+	int ret;
+
+	ret = clk_enable(sai->pdata->pclk);
+	if (ret < 0)
+		return ret;
+
+	ret = regmap_update_bits(sai->regmap, reg, mask, val);
+
+	clk_disable(sai->pdata->pclk);
+
+	return ret;
+}
+
+static int stm32_sai_sub_reg_wr(struct stm32_sai_sub_data *sai,
+				unsigned int reg, unsigned int mask,
+				unsigned int val)
+{
+	int ret;
+
+	ret = clk_enable(sai->pdata->pclk);
+	if (ret < 0)
+		return ret;
+
+	ret = regmap_write_bits(sai->regmap, reg, mask, val);
+
+	clk_disable(sai->pdata->pclk);
+
+	return ret;
+}
+
+static int stm32_sai_sub_reg_rd(struct stm32_sai_sub_data *sai,
+				unsigned int reg, unsigned int *val)
+{
+	int ret;
+
+	ret = clk_enable(sai->pdata->pclk);
+	if (ret < 0)
+		return ret;
+
+	ret = regmap_read(sai->regmap, reg, val);
+
+	clk_disable(sai->pdata->pclk);
+
+	return ret;
+}
+
 static const struct regmap_config stm32_sai_sub_regmap_config_f4 = {
 	.reg_bits = 32,
 	.reg_stride = 4,
@@ -295,7 +345,7 @@ static int stm32_sai_set_clk_div(struct
 
 	mask = SAI_XCR1_MCKDIV_MASK(SAI_XCR1_MCKDIV_WIDTH(version));
 	cr1 = SAI_XCR1_MCKDIV_SET(div);
-	ret = regmap_update_bits(sai->regmap, STM_SAI_CR1_REGX, mask, cr1);
+	ret = stm32_sai_sub_reg_up(sai, STM_SAI_CR1_REGX, mask, cr1);
 	if (ret < 0)
 		dev_err(&sai->pdev->dev, "Failed to update CR1 register\n");
 
@@ -372,8 +422,8 @@ static int stm32_sai_mclk_enable(struct
 
 	dev_dbg(&sai->pdev->dev, "Enable master clock\n");
 
-	return regmap_update_bits(sai->regmap, STM_SAI_CR1_REGX,
-				  SAI_XCR1_MCKEN, SAI_XCR1_MCKEN);
+	return stm32_sai_sub_reg_up(sai, STM_SAI_CR1_REGX,
+				    SAI_XCR1_MCKEN, SAI_XCR1_MCKEN);
 }
 
 static void stm32_sai_mclk_disable(struct clk_hw *hw)
@@ -383,7 +433,7 @@ static void stm32_sai_mclk_disable(struc
 
 	dev_dbg(&sai->pdev->dev, "Disable master clock\n");
 
-	regmap_update_bits(sai->regmap, STM_SAI_CR1_REGX, SAI_XCR1_MCKEN, 0);
+	stm32_sai_sub_reg_up(sai, STM_SAI_CR1_REGX, SAI_XCR1_MCKEN, 0);
 }
 
 static const struct clk_ops mclk_ops = {
@@ -446,15 +496,15 @@ static irqreturn_t stm32_sai_isr(int irq
 	unsigned int sr, imr, flags;
 	snd_pcm_state_t status = SNDRV_PCM_STATE_RUNNING;
 
-	regmap_read(sai->regmap, STM_SAI_IMR_REGX, &imr);
-	regmap_read(sai->regmap, STM_SAI_SR_REGX, &sr);
+	stm32_sai_sub_reg_rd(sai, STM_SAI_IMR_REGX, &imr);
+	stm32_sai_sub_reg_rd(sai, STM_SAI_SR_REGX, &sr);
 
 	flags = sr & imr;
 	if (!flags)
 		return IRQ_NONE;
 
-	regmap_write_bits(sai->regmap, STM_SAI_CLRFR_REGX, SAI_XCLRFR_MASK,
-			  SAI_XCLRFR_MASK);
+	stm32_sai_sub_reg_wr(sai, STM_SAI_CLRFR_REGX, SAI_XCLRFR_MASK,
+			     SAI_XCLRFR_MASK);
 
 	if (!sai->substream) {
 		dev_err(&pdev->dev, "Device stopped. Spurious IRQ 0x%x\n", sr);
@@ -503,8 +553,8 @@ static int stm32_sai_set_sysclk(struct s
 	int ret;
 
 	if (dir == SND_SOC_CLOCK_OUT && sai->sai_mclk) {
-		ret = regmap_update_bits(sai->regmap, STM_SAI_CR1_REGX,
-					 SAI_XCR1_NODIV,
+		ret = stm32_sai_sub_reg_up(sai, STM_SAI_CR1_REGX,
+					   SAI_XCR1_NODIV,
 					 freq ? 0 : SAI_XCR1_NODIV);
 		if (ret < 0)
 			return ret;
@@ -583,7 +633,7 @@ static int stm32_sai_set_dai_tdm_slot(st
 
 	slotr_mask |= SAI_XSLOTR_SLOTEN_MASK;
 
-	regmap_update_bits(sai->regmap, STM_SAI_SLOTR_REGX, slotr_mask, slotr);
+	stm32_sai_sub_reg_up(sai, STM_SAI_SLOTR_REGX, slotr_mask, slotr);
 
 	sai->slot_width = slot_width;
 	sai->slots = slots;
@@ -665,7 +715,7 @@ static int stm32_sai_set_dai_fmt(struct
 	cr1_mask |= SAI_XCR1_CKSTR;
 	frcr_mask |= SAI_XFRCR_FSPOL;
 
-	regmap_update_bits(sai->regmap, STM_SAI_FRCR_REGX, frcr_mask, frcr);
+	stm32_sai_sub_reg_up(sai, STM_SAI_FRCR_REGX, frcr_mask, frcr);
 
 	/* DAI clock master masks */
 	switch (fmt & SND_SOC_DAIFMT_MASTER_MASK) {
@@ -693,7 +743,7 @@ static int stm32_sai_set_dai_fmt(struct
 	cr1_mask |= SAI_XCR1_SLAVE;
 
 conf_update:
-	ret = regmap_update_bits(sai->regmap, STM_SAI_CR1_REGX, cr1_mask, cr1);
+	ret = stm32_sai_sub_reg_up(sai, STM_SAI_CR1_REGX, cr1_mask, cr1);
 	if (ret < 0) {
 		dev_err(cpu_dai->dev, "Failed to update CR1 register\n");
 		return ret;
@@ -730,12 +780,12 @@ static int stm32_sai_startup(struct snd_
 	}
 
 	/* Enable ITs */
-	regmap_write_bits(sai->regmap, STM_SAI_CLRFR_REGX,
-			  SAI_XCLRFR_MASK, SAI_XCLRFR_MASK);
+	stm32_sai_sub_reg_wr(sai, STM_SAI_CLRFR_REGX,
+			     SAI_XCLRFR_MASK, SAI_XCLRFR_MASK);
 
 	imr = SAI_XIMR_OVRUDRIE;
 	if (STM_SAI_IS_CAPTURE(sai)) {
-		regmap_read(sai->regmap, STM_SAI_CR2_REGX, &cr2);
+		stm32_sai_sub_reg_rd(sai, STM_SAI_CR2_REGX, &cr2);
 		if (cr2 & SAI_XCR2_MUTECNT_MASK)
 			imr |= SAI_XIMR_MUTEDETIE;
 	}
@@ -745,8 +795,8 @@ static int stm32_sai_startup(struct snd_
 	else
 		imr |= SAI_XIMR_AFSDETIE | SAI_XIMR_LFSDETIE;
 
-	regmap_update_bits(sai->regmap, STM_SAI_IMR_REGX,
-			   SAI_XIMR_MASK, imr);
+	stm32_sai_sub_reg_up(sai, STM_SAI_IMR_REGX,
+			     SAI_XIMR_MASK, imr);
 
 	return 0;
 }
@@ -763,10 +813,10 @@ static int stm32_sai_set_config(struct s
 	 * SAI fifo threshold is set to half fifo, to keep enough space
 	 * for DMA incoming bursts.
 	 */
-	regmap_write_bits(sai->regmap, STM_SAI_CR2_REGX,
-			  SAI_XCR2_FFLUSH | SAI_XCR2_FTH_MASK,
-			  SAI_XCR2_FFLUSH |
-			  SAI_XCR2_FTH_SET(STM_SAI_FIFO_TH_HALF));
+	stm32_sai_sub_reg_wr(sai, STM_SAI_CR2_REGX,
+			     SAI_XCR2_FFLUSH | SAI_XCR2_FTH_MASK,
+			     SAI_XCR2_FFLUSH |
+			     SAI_XCR2_FTH_SET(STM_SAI_FIFO_TH_HALF));
 
 	/* DS bits in CR1 not set for SPDIF (size forced to 24 bits).*/
 	if (STM_SAI_PROTOCOL_IS_SPDIF(sai)) {
@@ -795,7 +845,7 @@ static int stm32_sai_set_config(struct s
 	if ((sai->slots == 2) && (params_channels(params) == 1))
 		cr1 |= SAI_XCR1_MONO;
 
-	ret = regmap_update_bits(sai->regmap, STM_SAI_CR1_REGX, cr1_mask, cr1);
+	ret = stm32_sai_sub_reg_up(sai, STM_SAI_CR1_REGX, cr1_mask, cr1);
 	if (ret < 0) {
 		dev_err(cpu_dai->dev, "Failed to update CR1 register\n");
 		return ret;
@@ -809,7 +859,7 @@ static int stm32_sai_set_slots(struct sn
 	struct stm32_sai_sub_data *sai = snd_soc_dai_get_drvdata(cpu_dai);
 	int slotr, slot_sz;
 
-	regmap_read(sai->regmap, STM_SAI_SLOTR_REGX, &slotr);
+	stm32_sai_sub_reg_rd(sai, STM_SAI_SLOTR_REGX, &slotr);
 
 	/*
 	 * If SLOTSZ is set to auto in SLOTR, align slot width on data size
@@ -831,16 +881,16 @@ static int stm32_sai_set_slots(struct sn
 		sai->slots = 2;
 
 	/* The number of slots in the audio frame is equal to NBSLOT[3:0] + 1*/
-	regmap_update_bits(sai->regmap, STM_SAI_SLOTR_REGX,
-			   SAI_XSLOTR_NBSLOT_MASK,
-			   SAI_XSLOTR_NBSLOT_SET((sai->slots - 1)));
+	stm32_sai_sub_reg_up(sai, STM_SAI_SLOTR_REGX,
+			     SAI_XSLOTR_NBSLOT_MASK,
+			     SAI_XSLOTR_NBSLOT_SET((sai->slots - 1)));
 
 	/* Set default slots mask if not already set from DT */
 	if (!(slotr & SAI_XSLOTR_SLOTEN_MASK)) {
 		sai->slot_mask = (1 << sai->slots) - 1;
-		regmap_update_bits(sai->regmap,
-				   STM_SAI_SLOTR_REGX, SAI_XSLOTR_SLOTEN_MASK,
-				   SAI_XSLOTR_SLOTEN_SET(sai->slot_mask));
+		stm32_sai_sub_reg_up(sai,
+				     STM_SAI_SLOTR_REGX, SAI_XSLOTR_SLOTEN_MASK,
+				     SAI_XSLOTR_SLOTEN_SET(sai->slot_mask));
 	}
 
 	dev_dbg(cpu_dai->dev, "Slots %d, slot width %d\n",
@@ -870,14 +920,14 @@ static void stm32_sai_set_frame(struct s
 	dev_dbg(cpu_dai->dev, "Frame length %d, frame active %d\n",
 		sai->fs_length, fs_active);
 
-	regmap_update_bits(sai->regmap, STM_SAI_FRCR_REGX, frcr_mask, frcr);
+	stm32_sai_sub_reg_up(sai, STM_SAI_FRCR_REGX, frcr_mask, frcr);
 
 	if ((sai->fmt & SND_SOC_DAIFMT_FORMAT_MASK) == SND_SOC_DAIFMT_LSB) {
 		offset = sai->slot_width - sai->data_size;
 
-		regmap_update_bits(sai->regmap, STM_SAI_SLOTR_REGX,
-				   SAI_XSLOTR_FBOFF_MASK,
-				   SAI_XSLOTR_FBOFF_SET(offset));
+		stm32_sai_sub_reg_up(sai, STM_SAI_SLOTR_REGX,
+				     SAI_XSLOTR_FBOFF_MASK,
+				     SAI_XSLOTR_FBOFF_SET(offset));
 	}
 }
 
@@ -994,9 +1044,9 @@ static int stm32_sai_configure_clock(str
 					return -EINVAL;
 				}
 
-				regmap_update_bits(sai->regmap,
-						   STM_SAI_CR1_REGX,
-						   SAI_XCR1_OSR, cr1);
+				stm32_sai_sub_reg_up(sai,
+						     STM_SAI_CR1_REGX,
+						     SAI_XCR1_OSR, cr1);
 
 				div = stm32_sai_get_clk_div(sai, sai_clk_rate,
 							    sai->mclk_rate);
@@ -1058,12 +1108,12 @@ static int stm32_sai_trigger(struct snd_
 	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
 		dev_dbg(cpu_dai->dev, "Enable DMA and SAI\n");
 
-		regmap_update_bits(sai->regmap, STM_SAI_CR1_REGX,
-				   SAI_XCR1_DMAEN, SAI_XCR1_DMAEN);
+		stm32_sai_sub_reg_up(sai, STM_SAI_CR1_REGX,
+				     SAI_XCR1_DMAEN, SAI_XCR1_DMAEN);
 
 		/* Enable SAI */
-		ret = regmap_update_bits(sai->regmap, STM_SAI_CR1_REGX,
-					 SAI_XCR1_SAIEN, SAI_XCR1_SAIEN);
+		ret = stm32_sai_sub_reg_up(sai, STM_SAI_CR1_REGX,
+					   SAI_XCR1_SAIEN, SAI_XCR1_SAIEN);
 		if (ret < 0)
 			dev_err(cpu_dai->dev, "Failed to update CR1 register\n");
 		break;
@@ -1072,16 +1122,16 @@ static int stm32_sai_trigger(struct snd_
 	case SNDRV_PCM_TRIGGER_STOP:
 		dev_dbg(cpu_dai->dev, "Disable DMA and SAI\n");
 
-		regmap_update_bits(sai->regmap, STM_SAI_IMR_REGX,
-				   SAI_XIMR_MASK, 0);
+		stm32_sai_sub_reg_up(sai, STM_SAI_IMR_REGX,
+				     SAI_XIMR_MASK, 0);
 
-		regmap_update_bits(sai->regmap, STM_SAI_CR1_REGX,
-				   SAI_XCR1_SAIEN,
-				   (unsigned int)~SAI_XCR1_SAIEN);
-
-		ret = regmap_update_bits(sai->regmap, STM_SAI_CR1_REGX,
-					 SAI_XCR1_DMAEN,
-					 (unsigned int)~SAI_XCR1_DMAEN);
+		stm32_sai_sub_reg_up(sai, STM_SAI_CR1_REGX,
+				     SAI_XCR1_SAIEN,
+				     (unsigned int)~SAI_XCR1_SAIEN);
+
+		ret = stm32_sai_sub_reg_up(sai, STM_SAI_CR1_REGX,
+					   SAI_XCR1_DMAEN,
+					   (unsigned int)~SAI_XCR1_DMAEN);
 		if (ret < 0)
 			dev_err(cpu_dai->dev, "Failed to update CR1 register\n");
 
@@ -1101,7 +1151,7 @@ static void stm32_sai_shutdown(struct sn
 	struct stm32_sai_sub_data *sai = snd_soc_dai_get_drvdata(cpu_dai);
 	unsigned long flags;
 
-	regmap_update_bits(sai->regmap, STM_SAI_IMR_REGX, SAI_XIMR_MASK, 0);
+	stm32_sai_sub_reg_up(sai, STM_SAI_IMR_REGX, SAI_XIMR_MASK, 0);
 
 	clk_disable_unprepare(sai->sai_ck);
 
@@ -1169,7 +1219,7 @@ static int stm32_sai_dai_probe(struct sn
 	cr1_mask |= SAI_XCR1_SYNCEN_MASK;
 	cr1 |= SAI_XCR1_SYNCEN_SET(sai->sync);
 
-	return regmap_update_bits(sai->regmap, STM_SAI_CR1_REGX, cr1_mask, cr1);
+	return stm32_sai_sub_reg_up(sai, STM_SAI_CR1_REGX, cr1_mask, cr1);
 }
 
 static const struct snd_soc_dai_ops stm32_sai_pcm_dai_ops = {
@@ -1322,8 +1372,13 @@ static int stm32_sai_sub_parse_of(struct
 	if (STM_SAI_HAS_PDM(sai) && STM_SAI_IS_SUB_A(sai))
 		sai->regmap_config = &stm32_sai_sub_regmap_config_h7;
 
-	sai->regmap = devm_regmap_init_mmio_clk(&pdev->dev, "sai_ck",
-						base, sai->regmap_config);
+	/*
+	 * Do not manage peripheral clock through regmap framework as this
+	 * can lead to circular locking issue with sai master clock provider.
+	 * Manage peripheral clock directly in driver instead.
+	 */
+	sai->regmap = devm_regmap_init_mmio(&pdev->dev, base,
+					    sai->regmap_config);
 	if (IS_ERR(sai->regmap)) {
 		dev_err(&pdev->dev, "Failed to initialize MMIO\n");
 		return PTR_ERR(sai->regmap);
@@ -1420,6 +1475,10 @@ static int stm32_sai_sub_parse_of(struct
 		return PTR_ERR(sai->sai_ck);
 	}
 
+	ret = clk_prepare(sai->pdata->pclk);
+	if (ret < 0)
+		return ret;
+
 	if (STM_SAI_IS_F4(sai->pdata))
 		return 0;
 
@@ -1501,22 +1560,48 @@ static int stm32_sai_sub_probe(struct pl
 	return 0;
 }
 
+static int stm32_sai_sub_remove(struct platform_device *pdev)
+{
+	struct stm32_sai_sub_data *sai = dev_get_drvdata(&pdev->dev);
+
+	clk_unprepare(sai->pdata->pclk);
+
+	return 0;
+}
+
 #ifdef CONFIG_PM_SLEEP
 static int stm32_sai_sub_suspend(struct device *dev)
 {
 	struct stm32_sai_sub_data *sai = dev_get_drvdata(dev);
+	int ret;
+
+	ret = clk_enable(sai->pdata->pclk);
+	if (ret < 0)
+		return ret;
 
 	regcache_cache_only(sai->regmap, true);
 	regcache_mark_dirty(sai->regmap);
+
+	clk_disable(sai->pdata->pclk);
+
 	return 0;
 }
 
 static int stm32_sai_sub_resume(struct device *dev)
 {
 	struct stm32_sai_sub_data *sai = dev_get_drvdata(dev);
+	int ret;
+
+	ret = clk_enable(sai->pdata->pclk);
+	if (ret < 0)
+		return ret;
 
 	regcache_cache_only(sai->regmap, false);
-	return regcache_sync(sai->regmap);
+	ret = regcache_sync(sai->regmap);
+
+	clk_disable(sai->pdata->pclk);
+
+	return ret;
 }
 #endif /* CONFIG_PM_SLEEP */
 
@@ -1531,6 +1616,7 @@ static struct platform_driver stm32_sai_
 		.pm = &stm32_sai_sub_pm_ops,
 	},
 	.probe = stm32_sai_sub_probe,
+	.remove = stm32_sai_sub_remove,
 };
 
 module_platform_driver(stm32_sai_sub_driver);


