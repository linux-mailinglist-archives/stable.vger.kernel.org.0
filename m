Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 361A8F56E7
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:04:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730481AbfKHTN0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:13:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:38348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391464AbfKHTHf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:07:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74216206A3;
        Fri,  8 Nov 2019 19:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573240055;
        bh=/idMyIy3EstznScmSyy4e32Pa8RU7vF8zAOKGKWH8Qw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HVZV1Y275l4bvTYNsMDjplCQpz8kJhuP4bt+6TR/JM/sKJudJFLSjl2BWvb89Gnem
         QBWJEuHYB/NnkH2EkJdvDDyjnUqKKSF0Dulj6RFaHGVH6YRFMz92Uyws+fyfjj2hTv
         C67eWsOgkyiCcJQRNvAh8bdAZ7Bla0KcfLaCbzlo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephan Gerhold <stephan@gerhold.net>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 031/140] ASoC: msm8916-wcd-digital: add missing MIX2 path for RX1/2
Date:   Fri,  8 Nov 2019 19:49:19 +0100
Message-Id: <20191108174906.056525827@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174900.189064908@linuxfoundation.org>
References: <20191108174900.189064908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit bcab05880f9306e94531b0009c627421db110a74 ]

This patch adds missing MIX2 path on RX1/2 which take IIR1 and
IIR2 as inputs.

Without this patch sound card fails to intialize with below warning:

 ASoC: no sink widget found for RX1 MIX2 INP1
 ASoC: Failed to add route IIR1 -> IIR1 -> RX1 MIX2 INP1
 ASoC: no sink widget found for RX2 MIX2 INP1
 ASoC: Failed to add route IIR1 -> IIR1 -> RX2 MIX2 INP1
 ASoC: no sink widget found for RX1 MIX2 INP1
 ASoC: Failed to add route IIR2 -> IIR2 -> RX1 MIX2 INP1
 ASoC: no sink widget found for RX2 MIX2 INP1
 ASoC: Failed to add route IIR2 -> IIR2 -> RX2 MIX2 INP1

Reported-by: Stephan Gerhold <stephan@gerhold.net>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Tested-by: Stephan Gerhold <stephan@gerhold.net>
Link: https://lore.kernel.org/r/20191009111944.28069-1-srinivas.kandagatla@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/msm8916-wcd-digital.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/sound/soc/codecs/msm8916-wcd-digital.c b/sound/soc/codecs/msm8916-wcd-digital.c
index 1db7e43ec203e..5963d170df432 100644
--- a/sound/soc/codecs/msm8916-wcd-digital.c
+++ b/sound/soc/codecs/msm8916-wcd-digital.c
@@ -243,6 +243,10 @@ static const char *const rx_mix1_text[] = {
 	"ZERO", "IIR1", "IIR2", "RX1", "RX2", "RX3"
 };
 
+static const char * const rx_mix2_text[] = {
+	"ZERO", "IIR1", "IIR2"
+};
+
 static const char *const dec_mux_text[] = {
 	"ZERO", "ADC1", "ADC2", "ADC3", "DMIC1", "DMIC2"
 };
@@ -270,6 +274,16 @@ static const struct soc_enum rx3_mix1_inp_enum[] = {
 	SOC_ENUM_SINGLE(LPASS_CDC_CONN_RX3_B2_CTL, 0, 6, rx_mix1_text),
 };
 
+/* RX1 MIX2 */
+static const struct soc_enum rx_mix2_inp1_chain_enum =
+	SOC_ENUM_SINGLE(LPASS_CDC_CONN_RX1_B3_CTL,
+		0, 3, rx_mix2_text);
+
+/* RX2 MIX2 */
+static const struct soc_enum rx2_mix2_inp1_chain_enum =
+	SOC_ENUM_SINGLE(LPASS_CDC_CONN_RX2_B3_CTL,
+		0, 3, rx_mix2_text);
+
 /* DEC */
 static const struct soc_enum dec1_mux_enum = SOC_ENUM_SINGLE(
 				LPASS_CDC_CONN_TX_B1_CTL, 0, 6, dec_mux_text);
@@ -309,6 +323,10 @@ static const struct snd_kcontrol_new rx3_mix1_inp2_mux = SOC_DAPM_ENUM(
 				"RX3 MIX1 INP2 Mux", rx3_mix1_inp_enum[1]);
 static const struct snd_kcontrol_new rx3_mix1_inp3_mux = SOC_DAPM_ENUM(
 				"RX3 MIX1 INP3 Mux", rx3_mix1_inp_enum[2]);
+static const struct snd_kcontrol_new rx1_mix2_inp1_mux = SOC_DAPM_ENUM(
+				"RX1 MIX2 INP1 Mux", rx_mix2_inp1_chain_enum);
+static const struct snd_kcontrol_new rx2_mix2_inp1_mux = SOC_DAPM_ENUM(
+				"RX2 MIX2 INP1 Mux", rx2_mix2_inp1_chain_enum);
 
 /* Digital Gain control -38.4 dB to +38.4 dB in 0.3 dB steps */
 static const DECLARE_TLV_DB_SCALE(digital_gain, -3840, 30, 0);
@@ -740,6 +758,10 @@ static const struct snd_soc_dapm_widget msm8916_wcd_digital_dapm_widgets[] = {
 			 &rx3_mix1_inp2_mux),
 	SND_SOC_DAPM_MUX("RX3 MIX1 INP3", SND_SOC_NOPM, 0, 0,
 			 &rx3_mix1_inp3_mux),
+	SND_SOC_DAPM_MUX("RX1 MIX2 INP1", SND_SOC_NOPM, 0, 0,
+			 &rx1_mix2_inp1_mux),
+	SND_SOC_DAPM_MUX("RX2 MIX2 INP1", SND_SOC_NOPM, 0, 0,
+			 &rx2_mix2_inp1_mux),
 
 	SND_SOC_DAPM_MUX("CIC1 MUX", SND_SOC_NOPM, 0, 0, &cic1_mux),
 	SND_SOC_DAPM_MUX("CIC2 MUX", SND_SOC_NOPM, 0, 0, &cic2_mux),
-- 
2.20.1



