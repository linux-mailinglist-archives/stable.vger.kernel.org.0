Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A226F13FEE6
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:40:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391070AbgAPX2Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:28:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:60862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389500AbgAPX2O (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:28:14 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2BB50206D9;
        Thu, 16 Jan 2020 23:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217291;
        bh=yWWbWA/a60bFs6M+W+yu8Q+ZUvBOx7ldAV+THpLEjR8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lmLN5x5T1TpMyc3MatDH2IM6iF+SOEy19mOMmVwaweYe7IQ90B1EzUY4AOKIYspoN
         PYj6daHS1cexiSxrEUaeFH9d10xeGlYWHzjbacK08JUSjQQmmVT0lhVV6qjdmnKzvV
         231O5wvnYjh3+71GHSbRYt9dZCSbhy4IjYyIchyc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olivier Moysan <olivier.moysan@st.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.19 22/84] ASoC: stm32: spdifrx: fix race condition in irq handler
Date:   Fri, 17 Jan 2020 00:17:56 +0100
Message-Id: <20200116231716.272428926@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231713.087649517@linuxfoundation.org>
References: <20200116231713.087649517@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olivier Moysan <olivier.moysan@st.com>

commit 86e1956af4c863d653136fd6e5694adf2054dbaa upstream.

When snd_pcm_stop() is called in interrupt routine,
substream context may have already been released.
Add protection on substream context.

Fixes: 03e4d5d56fa5 ("ASoC: stm32: Add SPDIFRX support")

Signed-off-by: Olivier Moysan <olivier.moysan@st.com>
Link: https://lore.kernel.org/r/20191204154333.7152-3-olivier.moysan@st.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/stm/stm32_spdifrx.c |   24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

--- a/sound/soc/stm/stm32_spdifrx.c
+++ b/sound/soc/stm/stm32_spdifrx.c
@@ -213,6 +213,7 @@
  * @slave_config: dma slave channel runtime config pointer
  * @phys_addr: SPDIFRX registers physical base address
  * @lock: synchronization enabling lock
+ * @irq_lock: prevent race condition with IRQ on stream state
  * @cs: channel status buffer
  * @ub: user data buffer
  * @irq: SPDIFRX interrupt line
@@ -233,6 +234,7 @@ struct stm32_spdifrx_data {
 	struct dma_slave_config slave_config;
 	dma_addr_t phys_addr;
 	spinlock_t lock;  /* Sync enabling lock */
+	spinlock_t irq_lock; /* Prevent race condition on stream state */
 	unsigned char cs[SPDIFRX_CS_BYTES_NB];
 	unsigned char ub[SPDIFRX_UB_BYTES_NB];
 	int irq;
@@ -645,7 +647,6 @@ static const struct regmap_config stm32_
 static irqreturn_t stm32_spdifrx_isr(int irq, void *devid)
 {
 	struct stm32_spdifrx_data *spdifrx = (struct stm32_spdifrx_data *)devid;
-	struct snd_pcm_substream *substream = spdifrx->substream;
 	struct platform_device *pdev = spdifrx->pdev;
 	unsigned int cr, mask, sr, imr;
 	unsigned int flags;
@@ -713,14 +714,19 @@ static irqreturn_t stm32_spdifrx_isr(int
 		regmap_update_bits(spdifrx->regmap, STM32_SPDIFRX_CR,
 				   SPDIFRX_CR_SPDIFEN_MASK, cr);
 
-		if (substream)
-			snd_pcm_stop(substream, SNDRV_PCM_STATE_DISCONNECTED);
+		spin_lock(&spdifrx->irq_lock);
+		if (spdifrx->substream)
+			snd_pcm_stop(spdifrx->substream,
+				     SNDRV_PCM_STATE_DISCONNECTED);
+		spin_unlock(&spdifrx->irq_lock);
 
 		return IRQ_HANDLED;
 	}
 
-	if (err_xrun && substream)
-		snd_pcm_stop_xrun(substream);
+	spin_lock(&spdifrx->irq_lock);
+	if (err_xrun && spdifrx->substream)
+		snd_pcm_stop_xrun(spdifrx->substream);
+	spin_unlock(&spdifrx->irq_lock);
 
 	return IRQ_HANDLED;
 }
@@ -729,9 +735,12 @@ static int stm32_spdifrx_startup(struct
 				 struct snd_soc_dai *cpu_dai)
 {
 	struct stm32_spdifrx_data *spdifrx = snd_soc_dai_get_drvdata(cpu_dai);
+	unsigned long flags;
 	int ret;
 
+	spin_lock_irqsave(&spdifrx->irq_lock, flags);
 	spdifrx->substream = substream;
+	spin_unlock_irqrestore(&spdifrx->irq_lock, flags);
 
 	ret = clk_prepare_enable(spdifrx->kclk);
 	if (ret)
@@ -807,8 +816,12 @@ static void stm32_spdifrx_shutdown(struc
 				   struct snd_soc_dai *cpu_dai)
 {
 	struct stm32_spdifrx_data *spdifrx = snd_soc_dai_get_drvdata(cpu_dai);
+	unsigned long flags;
 
+	spin_lock_irqsave(&spdifrx->irq_lock, flags);
 	spdifrx->substream = NULL;
+	spin_unlock_irqrestore(&spdifrx->irq_lock, flags);
+
 	clk_disable_unprepare(spdifrx->kclk);
 }
 
@@ -912,6 +925,7 @@ static int stm32_spdifrx_probe(struct pl
 	spdifrx->pdev = pdev;
 	init_completion(&spdifrx->cs_completion);
 	spin_lock_init(&spdifrx->lock);
+	spin_lock_init(&spdifrx->irq_lock);
 
 	platform_set_drvdata(pdev, spdifrx);
 


