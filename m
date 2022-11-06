Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2EF661E3AC
	for <lists+stable@lfdr.de>; Sun,  6 Nov 2022 18:04:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbiKFREQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Nov 2022 12:04:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230197AbiKFREH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Nov 2022 12:04:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1042BF02C;
        Sun,  6 Nov 2022 09:04:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7290860C8F;
        Sun,  6 Nov 2022 17:04:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA515C433D7;
        Sun,  6 Nov 2022 17:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667754243;
        bh=XeV12e9wpqOz2i7cJoJEkFNDL6mHHsHjaONBu5UhXbU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TqEF1X1SRWM0bzvM4tfYDqC0eIA4SWRPXd3+4OBl6lABdErnnL8U7/34pWrEI70n0
         h1rQ1AriKd6zwsZyatXhxs0d7hpjmhQOgT1gqzAUseZADDQLWaUrgeVV3SjSsZ2rZE
         H2z/thAktNEpIRde+xREW7l0yjaahBZyPutGXodkebWY5GUKAz7ty/s8vUkPPJUnHo
         9S3onLOuv+ib29SCkxw+J6zwo8tdPyXl9WO8qtgnjRVIFwan9nK0Fn3NNfBwRzJFHj
         Nl83tChT9A0WBESaigH2j20Aa89umVMb9Jq6Z+eqvfG1CoJyUBExCIw4Iclwvx2jQG
         UPqKfkVrULzDw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Derek Fang <derek.fang@realtek.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, oder_chiou@realtek.com,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 6.0 07/30] ASoC: rt5682s: Fix the TDM Tx settings
Date:   Sun,  6 Nov 2022 12:03:19 -0500
Message-Id: <20221106170345.1579893-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221106170345.1579893-1-sashal@kernel.org>
References: <20221106170345.1579893-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Derek Fang <derek.fang@realtek.com>

[ Upstream commit d94bf16e920047c9b4ea2b57f7b53b4ff5039d9f ]

Complete the missing and correct the TDM Tx settings.

Signed-off-by: Derek Fang <derek.fang@realtek.com>
Link: https://lore.kernel.org/r/20221012031320.6980-1-derek.fang@realtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5682s.c | 15 +++++++++++++--
 sound/soc/codecs/rt5682s.h |  1 +
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/rt5682s.c b/sound/soc/codecs/rt5682s.c
index eb47e7cd485a..95fe993d59cb 100644
--- a/sound/soc/codecs/rt5682s.c
+++ b/sound/soc/codecs/rt5682s.c
@@ -1932,7 +1932,7 @@ static int rt5682s_set_tdm_slot(struct snd_soc_dai *dai, unsigned int tx_mask,
 		unsigned int rx_mask, int slots, int slot_width)
 {
 	struct snd_soc_component *component = dai->component;
-	unsigned int cl, val = 0;
+	unsigned int cl, val = 0, tx_slotnum;
 
 	if (tx_mask || rx_mask)
 		snd_soc_component_update_bits(component,
@@ -1941,6 +1941,16 @@ static int rt5682s_set_tdm_slot(struct snd_soc_dai *dai, unsigned int tx_mask,
 		snd_soc_component_update_bits(component,
 			RT5682S_TDM_ADDA_CTRL_2, RT5682S_TDM_EN, 0);
 
+	/* Tx slot configuration */
+	tx_slotnum = hweight_long(tx_mask);
+	if (tx_slotnum) {
+		if (tx_slotnum > slots) {
+			dev_err(component->dev, "Invalid or oversized Tx slots.\n");
+			return -EINVAL;
+		}
+		val |= (tx_slotnum - 1) << RT5682S_TDM_ADC_DL_SFT;
+	}
+
 	switch (slots) {
 	case 4:
 		val |= RT5682S_TDM_TX_CH_4;
@@ -1961,7 +1971,8 @@ static int rt5682s_set_tdm_slot(struct snd_soc_dai *dai, unsigned int tx_mask,
 	}
 
 	snd_soc_component_update_bits(component, RT5682S_TDM_CTRL,
-		RT5682S_TDM_TX_CH_MASK | RT5682S_TDM_RX_CH_MASK, val);
+		RT5682S_TDM_TX_CH_MASK | RT5682S_TDM_RX_CH_MASK |
+		RT5682S_TDM_ADC_DL_MASK, val);
 
 	switch (slot_width) {
 	case 8:
diff --git a/sound/soc/codecs/rt5682s.h b/sound/soc/codecs/rt5682s.h
index 7353831c73dd..b660a311b6c2 100644
--- a/sound/soc/codecs/rt5682s.h
+++ b/sound/soc/codecs/rt5682s.h
@@ -899,6 +899,7 @@
 #define RT5682S_TDM_RX_CH_8			(0x3 << 8)
 #define RT5682S_TDM_ADC_LCA_MASK		(0x7 << 4)
 #define RT5682S_TDM_ADC_LCA_SFT			4
+#define RT5682S_TDM_ADC_DL_MASK			(0x3 << 0)
 #define RT5682S_TDM_ADC_DL_SFT			0
 
 /* TDM control 2 (0x007a) */
-- 
2.35.1

