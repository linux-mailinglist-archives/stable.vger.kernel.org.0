Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7E61246A5C
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729777AbgHQPei (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:34:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:38672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730067AbgHQPeO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:34:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7E2123357;
        Mon, 17 Aug 2020 15:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678454;
        bh=zWkn7msTWdqSd4W9q862mQxFYapma4IhXp8NLDsgtio=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UWIwJVVh7AvtQBKAvshfcQwHtkb6ruKhTsUSqRogbQ+CF9dzgVqKr9XJnwmlesaX1
         KmEffI5AWE2CLhrYJ3QNypIqQunYszfatAnoVvu+D5/UrKYV460rNQ2wbQJOigSrTn
         86cgkfHWzhQpkv68HZDJ3f2X6ZW3ACWRHI/TryY4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shengjiu Wang <shengjiu.wang@nxp.com>,
        Fabio Estevam <festevam@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 339/464] ASoC: fsl_sai: Fix value of FSL_SAI_CR1_RFW_MASK
Date:   Mon, 17 Aug 2020 17:14:52 +0200
Message-Id: <20200817143850.014737656@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit 5aef1ff2397d021f93d874b57dff032fdfac73de ]

The fifo_depth is 64 on i.MX8QM/i.MX8QXP, 128 on i.MX8MQ, 16 on
i.MX7ULP.

Original FSL_SAI_CR1_RFW_MASK value 0x1F is not suitable for
these platform, the FIFO watermark mask should be updated
according to the fifo_depth.

Fixes: a860fac42097 ("ASoC: fsl_sai: Add support for imx7ulp/imx8mq")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Link: https://lore.kernel.org/r/1596176895-28724-1-git-send-email-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_sai.c | 5 +++--
 sound/soc/fsl/fsl_sai.h | 2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
index 9d436b0c5718a..7031869a023a1 100644
--- a/sound/soc/fsl/fsl_sai.c
+++ b/sound/soc/fsl/fsl_sai.c
@@ -680,10 +680,11 @@ static int fsl_sai_dai_probe(struct snd_soc_dai *cpu_dai)
 	regmap_write(sai->regmap, FSL_SAI_RCSR(ofs), 0);
 
 	regmap_update_bits(sai->regmap, FSL_SAI_TCR1(ofs),
-			   FSL_SAI_CR1_RFW_MASK,
+			   FSL_SAI_CR1_RFW_MASK(sai->soc_data->fifo_depth),
 			   sai->soc_data->fifo_depth - FSL_SAI_MAXBURST_TX);
 	regmap_update_bits(sai->regmap, FSL_SAI_RCR1(ofs),
-			   FSL_SAI_CR1_RFW_MASK, FSL_SAI_MAXBURST_RX - 1);
+			   FSL_SAI_CR1_RFW_MASK(sai->soc_data->fifo_depth),
+			   FSL_SAI_MAXBURST_RX - 1);
 
 	snd_soc_dai_init_dma_data(cpu_dai, &sai->dma_params_tx,
 				&sai->dma_params_rx);
diff --git a/sound/soc/fsl/fsl_sai.h b/sound/soc/fsl/fsl_sai.h
index 76b15deea80c7..6aba7d28f5f34 100644
--- a/sound/soc/fsl/fsl_sai.h
+++ b/sound/soc/fsl/fsl_sai.h
@@ -94,7 +94,7 @@
 #define FSL_SAI_CSR_FRDE	BIT(0)
 
 /* SAI Transmit and Receive Configuration 1 Register */
-#define FSL_SAI_CR1_RFW_MASK	0x1f
+#define FSL_SAI_CR1_RFW_MASK(x)	((x) - 1)
 
 /* SAI Transmit and Receive Configuration 2 Register */
 #define FSL_SAI_CR2_SYNC	BIT(30)
-- 
2.25.1



