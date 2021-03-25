Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F41C7348F15
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 12:26:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230407AbhCYL0D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 07:26:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:33858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230096AbhCYLZ0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 07:25:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3425561A2C;
        Thu, 25 Mar 2021 11:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616671526;
        bh=Ta9/dulXJhPlZ6QYG6Wv2Z+vAWq7VYe95iYaANvGlLA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eC3LOw7fhDGY38wsvaJjgeT9+nWjXWMpC8S1lz1uRZ1NyflOIpjszYl4ydGCHgQCA
         unu6K0xNMzBDe5y6FGnlWRkREfEYdEj7F23Ou6tiGxYzDU0zy+dNsWj34Q96mkjhdT
         QmRV/n8SHZeo0fpMGyhkBPut3qParA73IuTGnBbBxp1JBIakBJdFoDax8aBCcJvb14
         WjU3fgHQSKDZca0yBDvAdPKbu57Q6KQmS1JaPndA1zjP9sZTSnj2Y8BXa3zy45Shx8
         2opQy7WsU9w2SWaBZQbSMMD0FNC2agyFlSWWJ9pcniuiPD1XfIXD/Jtzh+W4h/RyGq
         IPPSI8M7vT7qA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiaxin Yu <jiaxin.yu@mediatek.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.11 20/44] ASoC: mediatek: mt8192: fix tdm out data is valid on rising edge
Date:   Thu, 25 Mar 2021 07:24:35 -0400
Message-Id: <20210325112459.1926846-20-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210325112459.1926846-1-sashal@kernel.org>
References: <20210325112459.1926846-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiaxin Yu <jiaxin.yu@mediatek.com>

[ Upstream commit 8d06b9633a66f41fed520f6eebd163189518ba79 ]

This patch correct tdm out bck inverse register to AUDIO_TOP_CON3[3].

Signed-off-by: Jiaxin Yu <jiaxin.yu@mediatek.com>
Link: https://lore.kernel.org/r/1615516005-781-1-git-send-email-jiaxin.yu@mediatek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8192/mt8192-dai-tdm.c | 4 +++-
 sound/soc/mediatek/mt8192/mt8192-reg.h     | 8 +++++---
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/sound/soc/mediatek/mt8192/mt8192-dai-tdm.c b/sound/soc/mediatek/mt8192/mt8192-dai-tdm.c
index 8383536b7ae0..504293de2c0d 100644
--- a/sound/soc/mediatek/mt8192/mt8192-dai-tdm.c
+++ b/sound/soc/mediatek/mt8192/mt8192-dai-tdm.c
@@ -555,7 +555,9 @@ static int mtk_dai_tdm_hw_params(struct snd_pcm_substream *substream,
 
 	/* set tdm */
 	if (tdm_priv->bck_invert)
-		tdm_con |= 1 << BCK_INVERSE_SFT;
+		regmap_update_bits(afe->regmap, AUDIO_TOP_CON3,
+				   BCK_INVERSE_MASK_SFT,
+				   0x1 << BCK_INVERSE_SFT);
 
 	if (tdm_priv->lck_invert)
 		tdm_con |= 1 << LRCK_INVERSE_SFT;
diff --git a/sound/soc/mediatek/mt8192/mt8192-reg.h b/sound/soc/mediatek/mt8192/mt8192-reg.h
index 562f25c79c34..b9fb80d4afec 100644
--- a/sound/soc/mediatek/mt8192/mt8192-reg.h
+++ b/sound/soc/mediatek/mt8192/mt8192-reg.h
@@ -21,6 +21,11 @@ enum {
 /*****************************************************************************
  *                  R E G I S T E R       D E F I N I T I O N
  *****************************************************************************/
+/* AUDIO_TOP_CON3 */
+#define BCK_INVERSE_SFT                              3
+#define BCK_INVERSE_MASK                             0x1
+#define BCK_INVERSE_MASK_SFT                         (0x1 << 3)
+
 /* AFE_DAC_CON0 */
 #define VUL12_ON_SFT                                   31
 #define VUL12_ON_MASK                                  0x1
@@ -2079,9 +2084,6 @@ enum {
 #define TDM_EN_SFT                                     0
 #define TDM_EN_MASK                                    0x1
 #define TDM_EN_MASK_SFT                                (0x1 << 0)
-#define BCK_INVERSE_SFT                                1
-#define BCK_INVERSE_MASK                               0x1
-#define BCK_INVERSE_MASK_SFT                           (0x1 << 1)
 #define LRCK_INVERSE_SFT                               2
 #define LRCK_INVERSE_MASK                              0x1
 #define LRCK_INVERSE_MASK_SFT                          (0x1 << 2)
-- 
2.30.1

