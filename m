Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8815E61E3BE
	for <lists+stable@lfdr.de>; Sun,  6 Nov 2022 18:04:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbiKFREs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Nov 2022 12:04:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230204AbiKFREV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Nov 2022 12:04:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDB2AF595;
        Sun,  6 Nov 2022 09:04:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98B41B80B2F;
        Sun,  6 Nov 2022 17:04:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ED63C433C1;
        Sun,  6 Nov 2022 17:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667754254;
        bh=tcmw91E/VgJ/lrc8DHnLO8OS8xE5koXY1a4vGdg2D/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R3jX+pydU8VxDY7MiF9thpijGWcHYfntuf7YsIewtKFSkZ64Ag79M/PQbZZlZEtxS
         pZzEHfHIEg0a0sbjCwjwbHVMZkdfdqNI2rfP+kxaZQ3ckq77bduaY/eZygzEVn6QZE
         J0w28vkv70px6fFlAaIKlTmwF0Kb5IypS+jWz8F095oI/+Xvm/YtP3uFrzY//USOgc
         PE7CnSG6sRRzuJl9zXM7/3aCJzZutxMcDCy4rXDtQnju8Bu6Vfzq5z/52jieyDyxrv
         WDyAHFiGAkuJSCEicdHiKTFKJfFmeHnHVTZCYlGqy4IxchpuH671s/CSZXaUkDiSyz
         uz90dr7ITPobg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Siarhei Volkau <lis8215@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, paul@crapouillou.net,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.com,
        linux-mips@vger.kernel.org, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 6.0 13/30] ASoC: codecs: jz4725b: use right control for Capture Volume
Date:   Sun,  6 Nov 2022 12:03:25 -0500
Message-Id: <20221106170345.1579893-13-sashal@kernel.org>
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

From: Siarhei Volkau <lis8215@gmail.com>

[ Upstream commit 1538e2c8c9b7e7a656effcc6e4e7cfe8c1b405fd ]

Line In Bypass control is used as Master Capture at the moment
this is completely incorrect.

Current control routed to Mixer instead of ADC, thus can't affect
Capture path. ADC control shall be used instead.

ADC volume control parameters are different, so the patch fixes that
as well. Manual says (16.6.3.2 Programmable input attenuation amplifier:
PGATM) that gain varies in range 0dB..22.5dB with 1.5dB step.

Signed-off-by: Siarhei Volkau <lis8215@gmail.com>
Link: https://lore.kernel.org/r/20221016132648.3011729-4-lis8215@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/jz4725b.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/sound/soc/codecs/jz4725b.c b/sound/soc/codecs/jz4725b.c
index 72549ee2e789..4363d898a7d4 100644
--- a/sound/soc/codecs/jz4725b.c
+++ b/sound/soc/codecs/jz4725b.c
@@ -136,13 +136,16 @@ enum {
 #define REG_CGR3_GO1L_OFFSET		0
 #define REG_CGR3_GO1L_MASK		(0x1f << REG_CGR3_GO1L_OFFSET)
 
+#define REG_CGR10_GIL_OFFSET		0
+#define REG_CGR10_GIR_OFFSET		4
+
 struct jz_icdc {
 	struct regmap *regmap;
 	void __iomem *base;
 	struct clk *clk;
 };
 
-static const SNDRV_CTL_TLVD_DECLARE_DB_LINEAR(jz4725b_line_tlv, -1500, 600);
+static const SNDRV_CTL_TLVD_DECLARE_DB_SCALE(jz4725b_adc_tlv,     0, 150, 0);
 static const SNDRV_CTL_TLVD_DECLARE_DB_SCALE(jz4725b_dac_tlv, -2250, 150, 0);
 
 static const struct snd_kcontrol_new jz4725b_codec_controls[] = {
@@ -151,11 +154,11 @@ static const struct snd_kcontrol_new jz4725b_codec_controls[] = {
 		       REG_CGR1_GODL_OFFSET,
 		       REG_CGR1_GODR_OFFSET,
 		       0xf, 1, jz4725b_dac_tlv),
-	SOC_DOUBLE_R_TLV("Master Capture Volume",
-			 JZ4725B_CODEC_REG_CGR3,
-			 JZ4725B_CODEC_REG_CGR2,
-			 REG_CGR2_GO1R_OFFSET,
-			 0x1f, 1, jz4725b_line_tlv),
+	SOC_DOUBLE_TLV("Master Capture Volume",
+		       JZ4725B_CODEC_REG_CGR10,
+		       REG_CGR10_GIL_OFFSET,
+		       REG_CGR10_GIR_OFFSET,
+		       0xf, 0, jz4725b_adc_tlv),
 
 	SOC_SINGLE("Master Playback Switch", JZ4725B_CODEC_REG_CR1,
 		   REG_CR1_DAC_MUTE_OFFSET, 1, 1),
-- 
2.35.1

