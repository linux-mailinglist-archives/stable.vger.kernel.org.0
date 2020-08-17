Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9479124708C
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390440AbgHQSLL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:11:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:55774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388414AbgHQQHb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:07:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 082E320748;
        Mon, 17 Aug 2020 16:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680450;
        bh=DT8BU4KJptWK8m2+MJqZTxLZ1LjVZbHbqPAU9CaDBJk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LmHbrVPgBsW8DjryTY4AHgNoo4OlfHxNAVHLJFFLUYWVX08b9uEKsZT4MQ9pc1wBX
         2z89wn1KmDr1nE7fKhJ5Koqs8hwWcprEwrOFqhC9ZsY0PC/hFe73ILGrqrNpsUNm+7
         nxnBNSUTQTNsndnKKBGMChn5UVQ9B5lpE6I8nwSY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shengjiu Wang <shengjiu.wang@nxp.com>,
        Fabio Estevam <festevam@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 190/270] ASoC: fsl_sai: Fix value of FSL_SAI_CR1_RFW_MASK
Date:   Mon, 17 Aug 2020 17:16:31 +0200
Message-Id: <20200817143805.266473605@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143755.807583758@linuxfoundation.org>
References: <20200817143755.807583758@linuxfoundation.org>
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
index 41b83ecaf0082..914b75c23d1bf 100644
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



