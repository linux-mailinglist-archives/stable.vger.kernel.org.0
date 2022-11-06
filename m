Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 464D661E44B
	for <lists+stable@lfdr.de>; Sun,  6 Nov 2022 18:10:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231167AbiKFRKD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Nov 2022 12:10:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231147AbiKFRJn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Nov 2022 12:09:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7573B13DEC;
        Sun,  6 Nov 2022 09:06:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5E0A2B80BED;
        Sun,  6 Nov 2022 17:06:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2713C433D6;
        Sun,  6 Nov 2022 17:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667754378;
        bh=CmcmcPI2VcpXv3yrjN2gijnu1MKsTMCTQ/7zNYKHIAc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CrJmh2RDOG4KGzhMOxi4N6SSU2+/TdXQRbv0CaXk1zD46yVHWsTP/J4PQDFFFUBQY
         Wf27ecrm5ipbQ+i9EVWcMi+l2eURVyVrWsYT3ZPhxsBgGndhZ96MjEWzBMaHxtgAoD
         pfrB8czzGZ384kX3CQ96ABSUk3T/LJvb6/wY9Uim/VrCyP/RSMoT4XOb2yGQN/D/Iv
         JflngA+MzkriyCvJWfZMAjuSuwBXQJbp3vqEHEt46SMkpQ9PhiTDoszm3KVM52/8q2
         aVdjdq8fczwtPcKB/Znc7X4Mblh2iy0T+F0Oyu3/BTGHPQwUrry7t8+GgKC5U2XQN4
         QRwNYlzNo4AwA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Siarhei Volkau <lis8215@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, paul@crapouillou.net,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.com,
        linux-mips@vger.kernel.org, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.10 09/16] ASoC: codecs: jz4725b: use right control for Capture Volume
Date:   Sun,  6 Nov 2022 12:05:46 -0500
Message-Id: <20221106170555.1580584-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221106170555.1580584-1-sashal@kernel.org>
References: <20221106170555.1580584-1-sashal@kernel.org>
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
index 6f3d4ead9150..9dc8d76bf104 100644
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

