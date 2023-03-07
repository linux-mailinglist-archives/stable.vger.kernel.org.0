Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 766806AEF31
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:21:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232697AbjCGSVe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:21:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232555AbjCGSVJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:21:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7A74B0495
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:15:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E7E561522
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:15:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 304B5C433EF;
        Tue,  7 Mar 2023 18:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212905;
        bh=jE/JI9lgxjdBkgNm44QfHwcZb023OZpMbdroPUhorKM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M94AKG+Pq4ylzlwagYwNWgNPsCPPGvCSbs6Ysi4aZKi8WnughHuvWGM5U1KJYWVDZ
         ZYVZLEpP1209cfouiD+iCyqvmDGs5nOUfSkf058UhBLJqj7XTF58qGXagdTiwHPxjP
         qT0d3K+NIB7vwly6vQfzWigPueljBfWssWTgukGM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 335/885] ASoC: mchp-spdifrx: fix controls that works with completion mechanism
Date:   Tue,  7 Mar 2023 17:54:29 +0100
Message-Id: <20230307170016.745553609@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudiu Beznea <claudiu.beznea@microchip.com>

[ Upstream commit d3681df44e856aab523a6eb7ba15b5e41efcbb1c ]

Channel status get and channel subcode get controls relies on data
returned by controls when certain IRQs are raised. To achieve that
completions are used b/w controls and interrupt service routine. The
concurrent accesses to these controls are protected by
struct snd_card::controls_rwsem.

Issues identified:
- reinit_completion() may be called while waiting for completion
  which should be avoided
- in case of multiple threads waiting, the complete() call in interrupt
  will signal only one waiting thread per interrupt which may lead to
  timeout for the others
- in case of channel status get as the CSC interrupt is not refcounted
  ISR may disable interrupt for threads that were just enabled it.

To solve these the access to controls were protected by a mutex. Along
with this there is no need for spinlock to protect the software cache
reads/updates b/w controls and ISR as the update is happening only when
requested from control, and only one reader can reach the control.

Fixes: ef265c55c1ac ("ASoC: mchp-spdifrx: add driver for SPDIF RX")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/20230130120647.638049-4-claudiu.beznea@microchip.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/atmel/mchp-spdifrx.c | 143 ++++++++++++++++++---------------
 1 file changed, 77 insertions(+), 66 deletions(-)

diff --git a/sound/soc/atmel/mchp-spdifrx.c b/sound/soc/atmel/mchp-spdifrx.c
index 7f359371b31bf..31ffaaf46dec0 100644
--- a/sound/soc/atmel/mchp-spdifrx.c
+++ b/sound/soc/atmel/mchp-spdifrx.c
@@ -217,7 +217,6 @@ struct mchp_spdifrx_ch_stat {
 struct mchp_spdifrx_user_data {
 	unsigned char data[SPDIFRX_UD_BITS / 8];
 	struct completion done;
-	spinlock_t lock;	/* protect access to user data */
 };
 
 struct mchp_spdifrx_mixer_control {
@@ -231,8 +230,6 @@ struct mchp_spdifrx_mixer_control {
 struct mchp_spdifrx_dev {
 	struct snd_dmaengine_dai_dma_data	capture;
 	struct mchp_spdifrx_mixer_control	control;
-	spinlock_t				blockend_lock;	/* protect access to blockend_refcount */
-	int					blockend_refcount;
 	struct mutex				mlock;
 	struct device				*dev;
 	struct regmap				*regmap;
@@ -277,37 +274,11 @@ static void mchp_spdifrx_channel_user_data_read(struct mchp_spdifrx_dev *dev,
 	}
 }
 
-/* called from non-atomic context only */
-static void mchp_spdifrx_isr_blockend_en(struct mchp_spdifrx_dev *dev)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&dev->blockend_lock, flags);
-	dev->blockend_refcount++;
-	/* don't enable BLOCKEND interrupt if it's already enabled */
-	if (dev->blockend_refcount == 1)
-		regmap_write(dev->regmap, SPDIFRX_IER, SPDIFRX_IR_BLOCKEND);
-	spin_unlock_irqrestore(&dev->blockend_lock, flags);
-}
-
-/* called from atomic/non-atomic context */
-static void mchp_spdifrx_isr_blockend_dis(struct mchp_spdifrx_dev *dev)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&dev->blockend_lock, flags);
-	dev->blockend_refcount--;
-	/* don't enable BLOCKEND interrupt if it's already enabled */
-	if (dev->blockend_refcount == 0)
-		regmap_write(dev->regmap, SPDIFRX_IDR, SPDIFRX_IR_BLOCKEND);
-	spin_unlock_irqrestore(&dev->blockend_lock, flags);
-}
-
 static irqreturn_t mchp_spdif_interrupt(int irq, void *dev_id)
 {
 	struct mchp_spdifrx_dev *dev = dev_id;
 	struct mchp_spdifrx_mixer_control *ctrl = &dev->control;
-	u32 sr, imr, pending, idr = 0;
+	u32 sr, imr, pending;
 	irqreturn_t ret = IRQ_NONE;
 	int ch;
 
@@ -322,13 +293,10 @@ static irqreturn_t mchp_spdif_interrupt(int irq, void *dev_id)
 
 	if (pending & SPDIFRX_IR_BLOCKEND) {
 		for (ch = 0; ch < SPDIFRX_CHANNELS; ch++) {
-			spin_lock(&ctrl->user_data[ch].lock);
 			mchp_spdifrx_channel_user_data_read(dev, ch);
-			spin_unlock(&ctrl->user_data[ch].lock);
-
 			complete(&ctrl->user_data[ch].done);
 		}
-		mchp_spdifrx_isr_blockend_dis(dev);
+		regmap_write(dev->regmap, SPDIFRX_IDR, SPDIFRX_IR_BLOCKEND);
 		ret = IRQ_HANDLED;
 	}
 
@@ -336,7 +304,7 @@ static irqreturn_t mchp_spdif_interrupt(int irq, void *dev_id)
 		if (pending & SPDIFRX_IR_CSC(ch)) {
 			mchp_spdifrx_channel_status_read(dev, ch);
 			complete(&ctrl->ch_stat[ch].done);
-			idr |= SPDIFRX_IR_CSC(ch);
+			regmap_write(dev->regmap, SPDIFRX_IDR, SPDIFRX_IR_CSC(ch));
 			ret = IRQ_HANDLED;
 		}
 	}
@@ -346,8 +314,6 @@ static irqreturn_t mchp_spdif_interrupt(int irq, void *dev_id)
 		ret = IRQ_HANDLED;
 	}
 
-	regmap_write(dev->regmap, SPDIFRX_IDR, idr);
-
 	return ret;
 }
 
@@ -517,23 +483,51 @@ static int mchp_spdifrx_cs_get(struct mchp_spdifrx_dev *dev,
 {
 	struct mchp_spdifrx_mixer_control *ctrl = &dev->control;
 	struct mchp_spdifrx_ch_stat *ch_stat = &ctrl->ch_stat[channel];
-	int ret;
+	int ret = 0;
+
+	mutex_lock(&dev->mlock);
 
-	regmap_write(dev->regmap, SPDIFRX_IER, SPDIFRX_IR_CSC(channel));
-	/* check for new data available */
-	ret = wait_for_completion_interruptible_timeout(&ch_stat->done,
-							msecs_to_jiffies(100));
-	/* IP might not be started or valid stream might not be present */
-	if (ret <= 0) {
-		dev_dbg(dev->dev, "channel status for channel %d timeout\n",
-			channel);
-		return ret ? : -ETIMEDOUT;
+	/*
+	 * We may reach this point with both clocks enabled but the receiver
+	 * still disabled. To void waiting for completion and return with
+	 * timeout check the dev->trigger_enabled.
+	 *
+	 * To retrieve data:
+	 * - if the receiver is enabled CSC IRQ will update the data in software
+	 *   caches (ch_stat->data)
+	 * - otherwise we just update it here the software caches with latest
+	 *   available information and return it; in this case we don't need
+	 *   spin locking as the IRQ is disabled and will not be raised from
+	 *   anywhere else.
+	 */
+
+	if (dev->trigger_enabled) {
+		reinit_completion(&ch_stat->done);
+		regmap_write(dev->regmap, SPDIFRX_IER, SPDIFRX_IR_CSC(channel));
+		/* Check for new data available */
+		ret = wait_for_completion_interruptible_timeout(&ch_stat->done,
+								msecs_to_jiffies(100));
+		/* Valid stream might not be present */
+		if (ret <= 0) {
+			dev_dbg(dev->dev, "channel status for channel %d timeout\n",
+				channel);
+			regmap_write(dev->regmap, SPDIFRX_IDR, SPDIFRX_IR_CSC(channel));
+			ret = ret ? : -ETIMEDOUT;
+			goto unlock;
+		} else {
+			ret = 0;
+		}
+	} else {
+		/* Update software cache with latest channel status. */
+		mchp_spdifrx_channel_status_read(dev, channel);
 	}
 
 	memcpy(uvalue->value.iec958.status, ch_stat->data,
 	       sizeof(ch_stat->data));
 
-	return 0;
+unlock:
+	mutex_unlock(&dev->mlock);
+	return ret;
 }
 
 static int mchp_spdifrx_cs1_get(struct snd_kcontrol *kcontrol,
@@ -567,29 +561,49 @@ static int mchp_spdifrx_subcode_ch_get(struct mchp_spdifrx_dev *dev,
 				       int channel,
 				       struct snd_ctl_elem_value *uvalue)
 {
-	unsigned long flags;
 	struct mchp_spdifrx_mixer_control *ctrl = &dev->control;
 	struct mchp_spdifrx_user_data *user_data = &ctrl->user_data[channel];
-	int ret;
+	int ret = 0;
+
+	mutex_lock(&dev->mlock);
+
+	/*
+	 * We may reach this point with both clocks enabled but the receiver
+	 * still disabled. To void waiting for completion to just timeout we
+	 * check here the dev->trigger_enabled flag.
+	 *
+	 * To retrieve data:
+	 * - if the receiver is enabled we need to wait for blockend IRQ to read
+	 *   data to and update it for us in software caches
+	 * - otherwise reading the SPDIFRX_CHUD() registers is enough.
+	 */
 
-	reinit_completion(&user_data->done);
-	mchp_spdifrx_isr_blockend_en(dev);
-	ret = wait_for_completion_interruptible_timeout(&user_data->done,
-							msecs_to_jiffies(100));
-	/* IP might not be started or valid stream might not be present */
-	if (ret <= 0) {
-		dev_dbg(dev->dev, "user data for channel %d timeout\n",
-			channel);
-		mchp_spdifrx_isr_blockend_dis(dev);
-		return ret ? : -ETIMEDOUT;
+	if (dev->trigger_enabled) {
+		reinit_completion(&user_data->done);
+		regmap_write(dev->regmap, SPDIFRX_IER, SPDIFRX_IR_BLOCKEND);
+		ret = wait_for_completion_interruptible_timeout(&user_data->done,
+								msecs_to_jiffies(100));
+		/* Valid stream might not be present. */
+		if (ret <= 0) {
+			dev_dbg(dev->dev, "user data for channel %d timeout\n",
+				channel);
+			regmap_write(dev->regmap, SPDIFRX_IDR, SPDIFRX_IR_BLOCKEND);
+			ret = ret ? : -ETIMEDOUT;
+			goto unlock;
+		} else {
+			ret = 0;
+		}
+	} else {
+		/* Update software cache with last available data. */
+		mchp_spdifrx_channel_user_data_read(dev, channel);
 	}
 
-	spin_lock_irqsave(&user_data->lock, flags);
 	memcpy(uvalue->value.iec958.subcode, user_data->data,
 	       sizeof(user_data->data));
-	spin_unlock_irqrestore(&user_data->lock, flags);
 
-	return 0;
+unlock:
+	mutex_unlock(&dev->mlock);
+	return ret;
 }
 
 static int mchp_spdifrx_subcode_ch1_get(struct snd_kcontrol *kcontrol,
@@ -890,11 +904,9 @@ static int mchp_spdifrx_dai_probe(struct snd_soc_dai *dai)
 		     SPDIFRX_MR_AUTORST_NOACTION |
 		     SPDIFRX_MR_PACK_DISABLED);
 
-	dev->blockend_refcount = 0;
 	for (ch = 0; ch < SPDIFRX_CHANNELS; ch++) {
 		init_completion(&ctrl->ch_stat[ch].done);
 		init_completion(&ctrl->user_data[ch].done);
-		spin_lock_init(&ctrl->user_data[ch].lock);
 	}
 
 	/* Add controls */
@@ -1005,7 +1017,6 @@ static int mchp_spdifrx_probe(struct platform_device *pdev)
 	 */
 	clk_set_min_rate(dev->gclk, 48000 * SPDIFRX_GCLK_RATIO_MIN + 1);
 
-	spin_lock_init(&dev->blockend_lock);
 	mutex_init(&dev->mlock);
 
 	dev->dev = &pdev->dev;
-- 
2.39.2



