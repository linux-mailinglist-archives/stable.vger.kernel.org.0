Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7A08190E2
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 20:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728387AbfEISuK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:50:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:43642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728381AbfEISuJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:50:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD9E021882;
        Thu,  9 May 2019 18:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557427808;
        bh=7mgdfsiTqR7meZCrbYNHoppv2Q7CQEzIo8bMAqhKzjs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E2oNgH5s2YBV3EFUaKzeaZLM/1abaTiag5fDw+C/Jhi2q4CcshniDUgy/puH9SnGy
         BmuFLKUz9P2+lctGX3m68+AS4xUWIUHa3VMGyI5jScQlKHhlaf3zIiSvYtItlDadhU
         5TkEmb2M4hD/eG3dnbMMQO3dkwNDD0At96RR2dhg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olivier Moysan <olivier.moysan@st.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 12/95] ASoC: stm32: sai: fix race condition in irq handler
Date:   Thu,  9 May 2019 20:41:29 +0200
Message-Id: <20190509181310.215961591@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181309.180685671@linuxfoundation.org>
References: <20190509181309.180685671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 26f98e82dd49b7c3cc5ef0edd882aa732a62b672 ]

When snd_pcm_stop_xrun() is called in interrupt routine,
substream context may have already been released.
Add protection on substream context.

Signed-off-by: Olivier Moysan <olivier.moysan@st.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/stm/stm32_sai_sub.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/sound/soc/stm/stm32_sai_sub.c b/sound/soc/stm/stm32_sai_sub.c
index 1653cea936cbd..bc69e68191ad1 100644
--- a/sound/soc/stm/stm32_sai_sub.c
+++ b/sound/soc/stm/stm32_sai_sub.c
@@ -102,6 +102,7 @@
  * @spdif_frm_cnt: S/PDIF playback frame counter
  * @iec958: iec958 data
  * @ctrl_lock: control lock
+ * @irq_lock: prevent race condition with IRQ
  */
 struct stm32_sai_sub_data {
 	struct platform_device *pdev;
@@ -133,6 +134,7 @@ struct stm32_sai_sub_data {
 	unsigned int spdif_frm_cnt;
 	struct snd_aes_iec958 iec958;
 	struct mutex ctrl_lock; /* protect resources accessed by controls */
+	spinlock_t irq_lock; /* used to prevent race condition with IRQ */
 };
 
 enum stm32_sai_fifo_th {
@@ -474,8 +476,10 @@ static irqreturn_t stm32_sai_isr(int irq, void *devid)
 		status = SNDRV_PCM_STATE_XRUN;
 	}
 
-	if (status != SNDRV_PCM_STATE_RUNNING)
+	spin_lock(&sai->irq_lock);
+	if (status != SNDRV_PCM_STATE_RUNNING && sai->substream)
 		snd_pcm_stop_xrun(sai->substream);
+	spin_unlock(&sai->irq_lock);
 
 	return IRQ_HANDLED;
 }
@@ -679,8 +683,11 @@ static int stm32_sai_startup(struct snd_pcm_substream *substream,
 {
 	struct stm32_sai_sub_data *sai = snd_soc_dai_get_drvdata(cpu_dai);
 	int imr, cr2, ret;
+	unsigned long flags;
 
+	spin_lock_irqsave(&sai->irq_lock, flags);
 	sai->substream = substream;
+	spin_unlock_irqrestore(&sai->irq_lock, flags);
 
 	if (STM_SAI_PROTOCOL_IS_SPDIF(sai)) {
 		snd_pcm_hw_constraint_mask64(substream->runtime,
@@ -1061,6 +1068,7 @@ static void stm32_sai_shutdown(struct snd_pcm_substream *substream,
 			       struct snd_soc_dai *cpu_dai)
 {
 	struct stm32_sai_sub_data *sai = snd_soc_dai_get_drvdata(cpu_dai);
+	unsigned long flags;
 
 	regmap_update_bits(sai->regmap, STM_SAI_IMR_REGX, SAI_XIMR_MASK, 0);
 
@@ -1071,7 +1079,9 @@ static void stm32_sai_shutdown(struct snd_pcm_substream *substream,
 
 	clk_rate_exclusive_put(sai->sai_mclk);
 
+	spin_lock_irqsave(&sai->irq_lock, flags);
 	sai->substream = NULL;
+	spin_unlock_irqrestore(&sai->irq_lock, flags);
 }
 
 static int stm32_sai_pcm_new(struct snd_soc_pcm_runtime *rtd,
@@ -1435,6 +1445,7 @@ static int stm32_sai_sub_probe(struct platform_device *pdev)
 
 	sai->pdev = pdev;
 	mutex_init(&sai->ctrl_lock);
+	spin_lock_init(&sai->irq_lock);
 	platform_set_drvdata(pdev, sai);
 
 	sai->pdata = dev_get_drvdata(pdev->dev.parent);
-- 
2.20.1



