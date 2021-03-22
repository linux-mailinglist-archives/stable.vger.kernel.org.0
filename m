Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F35F34418B
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:35:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231149AbhCVMeO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:34:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:56134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231455AbhCVMdL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:33:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 01FC36199E;
        Mon, 22 Mar 2021 12:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416390;
        bh=j0QFhI8HCGhgTiQpwmtxdHudmHhdOsdih43jzjiJEDY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hZtgVzg85FqMTrz4crbmlPkJCEZ28j8vvaYQMUGhSEtrtCzhun+TdUjXBrl+n4Bsz
         d5+o+AsrsLLD5q5z/a0zmuc3w3PC7Y9pnaieDrDjcALhFfV/Wt5avNcf6uR0SN4+4O
         NrdBl6efg5o1TvbMsAr2FYEoxbxXvL1lQJXssWnE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Marek <jonathan@marek.ca>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 071/120] ASoC: codecs: lpass-wsa-macro: fix RX MIX input controls
Date:   Mon, 22 Mar 2021 13:27:34 +0100
Message-Id: <20210322121932.048812396@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121929.669628946@linuxfoundation.org>
References: <20210322121929.669628946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Marek <jonathan@marek.ca>

[ Upstream commit e4b8b7c916038c1ffcba2c4ce92d5523c4cc2f46 ]

Attempting to use the RX MIX path at 48kHz plays at 96kHz, because these
controls are incorrectly toggling the first bit of the register, which
is part of the FS_RATE field.

Fix the problem by using the same method used by the "WSA RX_MIX EC0_MUX"
control, which is to use SND_SOC_NOPM as the register and use an enum in
the shift field instead.

Fixes: 2c4066e5d428 ("ASoC: codecs: lpass-wsa-macro: add dapm widgets and route")
Signed-off-by: Jonathan Marek <jonathan@marek.ca>
Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20210305005049.24726-1-jonathan@marek.ca
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/lpass-wsa-macro.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/sound/soc/codecs/lpass-wsa-macro.c b/sound/soc/codecs/lpass-wsa-macro.c
index 25f1df214ca5..cd59aa439373 100644
--- a/sound/soc/codecs/lpass-wsa-macro.c
+++ b/sound/soc/codecs/lpass-wsa-macro.c
@@ -1214,14 +1214,16 @@ static int wsa_macro_enable_mix_path(struct snd_soc_dapm_widget *w,
 				     struct snd_kcontrol *kcontrol, int event)
 {
 	struct snd_soc_component *component = snd_soc_dapm_to_component(w->dapm);
-	u16 gain_reg;
+	u16 path_reg, gain_reg;
 	int val;
 
-	switch (w->reg) {
-	case CDC_WSA_RX0_RX_PATH_MIX_CTL:
+	switch (w->shift) {
+	case WSA_MACRO_RX_MIX0:
+		path_reg = CDC_WSA_RX0_RX_PATH_MIX_CTL;
 		gain_reg = CDC_WSA_RX0_RX_VOL_MIX_CTL;
 		break;
-	case CDC_WSA_RX1_RX_PATH_MIX_CTL:
+	case WSA_MACRO_RX_MIX1:
+		path_reg = CDC_WSA_RX1_RX_PATH_MIX_CTL;
 		gain_reg = CDC_WSA_RX1_RX_VOL_MIX_CTL;
 		break;
 	default:
@@ -1234,7 +1236,7 @@ static int wsa_macro_enable_mix_path(struct snd_soc_dapm_widget *w,
 		snd_soc_component_write(component, gain_reg, val);
 		break;
 	case SND_SOC_DAPM_POST_PMD:
-		snd_soc_component_update_bits(component, w->reg,
+		snd_soc_component_update_bits(component, path_reg,
 					      CDC_WSA_RX_PATH_MIX_CLK_EN_MASK,
 					      CDC_WSA_RX_PATH_MIX_CLK_DISABLE);
 		break;
@@ -2071,14 +2073,14 @@ static const struct snd_soc_dapm_widget wsa_macro_dapm_widgets[] = {
 	SND_SOC_DAPM_MUX("WSA_RX0 INP0", SND_SOC_NOPM, 0, 0, &rx0_prim_inp0_mux),
 	SND_SOC_DAPM_MUX("WSA_RX0 INP1", SND_SOC_NOPM, 0, 0, &rx0_prim_inp1_mux),
 	SND_SOC_DAPM_MUX("WSA_RX0 INP2", SND_SOC_NOPM, 0, 0, &rx0_prim_inp2_mux),
-	SND_SOC_DAPM_MUX_E("WSA_RX0 MIX INP", CDC_WSA_RX0_RX_PATH_MIX_CTL,
-			   0, 0, &rx0_mix_mux, wsa_macro_enable_mix_path,
+	SND_SOC_DAPM_MUX_E("WSA_RX0 MIX INP", SND_SOC_NOPM, WSA_MACRO_RX_MIX0,
+			   0, &rx0_mix_mux, wsa_macro_enable_mix_path,
 			   SND_SOC_DAPM_PRE_PMU | SND_SOC_DAPM_POST_PMD),
 	SND_SOC_DAPM_MUX("WSA_RX1 INP0", SND_SOC_NOPM, 0, 0, &rx1_prim_inp0_mux),
 	SND_SOC_DAPM_MUX("WSA_RX1 INP1", SND_SOC_NOPM, 0, 0, &rx1_prim_inp1_mux),
 	SND_SOC_DAPM_MUX("WSA_RX1 INP2", SND_SOC_NOPM, 0, 0, &rx1_prim_inp2_mux),
-	SND_SOC_DAPM_MUX_E("WSA_RX1 MIX INP", CDC_WSA_RX1_RX_PATH_MIX_CTL,
-			   0, 0, &rx1_mix_mux, wsa_macro_enable_mix_path,
+	SND_SOC_DAPM_MUX_E("WSA_RX1 MIX INP", SND_SOC_NOPM, WSA_MACRO_RX_MIX1,
+			   0, &rx1_mix_mux, wsa_macro_enable_mix_path,
 			   SND_SOC_DAPM_PRE_PMU | SND_SOC_DAPM_POST_PMD),
 
 	SND_SOC_DAPM_MIXER_E("WSA_RX INT0 MIX", SND_SOC_NOPM, 0, 0, NULL, 0,
-- 
2.30.1



