Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C082353F78
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239116AbhDEJMS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:12:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:59456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239119AbhDEJMO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:12:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 319786139D;
        Mon,  5 Apr 2021 09:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613927;
        bh=Ta9/dulXJhPlZ6QYG6Wv2Z+vAWq7VYe95iYaANvGlLA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FfCFHWJMGh+PKboci6PxPYT0srswgw0cmz7ze1mSQ4PX97G+WD75hnfA8p2uodqI6
         T5KEl+ZsXzCcLu8d5bhCd0YbvcwUjCJCBzROfsmBZYE/qvcsW3Wg1WFpZiydq34dyC
         UIdcsmlJJARIEC5O53Ig1PSxYme8SdjpyUxWPTDY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiaxin Yu <jiaxin.yu@mediatek.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 019/152] ASoC: mediatek: mt8192: fix tdm out data is valid on rising edge
Date:   Mon,  5 Apr 2021 10:52:48 +0200
Message-Id: <20210405085034.863501797@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085034.233917714@linuxfoundation.org>
References: <20210405085034.233917714@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



