Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 038BC59E159
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350483AbiHWLdu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:33:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357551AbiHWLbm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:31:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A84F8FD5C;
        Tue, 23 Aug 2022 02:25:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 25F076126A;
        Tue, 23 Aug 2022 09:25:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24C9CC433D6;
        Tue, 23 Aug 2022 09:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661246749;
        bh=oIHNe4ls1ycyTHniDu6tRrEp7j3f3NiMgFsGvubZ5HQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w3bLrSY573znZlyP3BV9ee9aEgnOD6pIC+y/3N8qOIqdwLqGPQU5Yh91k+qlIs0ED
         KSzMWB/27s6pMtV9eTKmPn+bkZgD59vGzMIzlp2pNJ6ID9mcfPVhkZB6RvMFvINamo
         PrugckaUzV87oiG1neMTu2gli8wAm5B9MoLEwQVg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 208/389] ASoC: codecs: msm8916-wcd-digital: move gains from SX_TLV to S8_TLV
Date:   Tue, 23 Aug 2022 10:24:46 +0200
Message-Id: <20220823080124.327507556@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit 5babb012c847beb6c8c7108fd78f650b7a2c6054 ]

move all the digital gains form using SX_TLV to S8_TLV, these gains are
actually 8 bit gains with 7th signed bit and ranges from -84dB to +40dB

rest of the Qualcomm wcd codecs uses these properly.

Fixes: ef8a4757a6db ("ASoC: msm8916-wcd-digital: Add sidetone support")
Fixes: 150db8c5afa1 ("ASoC: codecs: Add msm8916-wcd digital codec")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20220609111901.318047-2-srinivas.kandagatla@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/msm8916-wcd-digital.c | 46 +++++++++++++-------------
 1 file changed, 23 insertions(+), 23 deletions(-)

diff --git a/sound/soc/codecs/msm8916-wcd-digital.c b/sound/soc/codecs/msm8916-wcd-digital.c
index e4cde214b7b2..6e5bce4f5eb2 100644
--- a/sound/soc/codecs/msm8916-wcd-digital.c
+++ b/sound/soc/codecs/msm8916-wcd-digital.c
@@ -328,8 +328,8 @@ static const struct snd_kcontrol_new rx1_mix2_inp1_mux = SOC_DAPM_ENUM(
 static const struct snd_kcontrol_new rx2_mix2_inp1_mux = SOC_DAPM_ENUM(
 				"RX2 MIX2 INP1 Mux", rx2_mix2_inp1_chain_enum);
 
-/* Digital Gain control -38.4 dB to +38.4 dB in 0.3 dB steps */
-static const DECLARE_TLV_DB_SCALE(digital_gain, -3840, 30, 0);
+/* Digital Gain control -84 dB to +40 dB in 1 dB steps */
+static const DECLARE_TLV_DB_SCALE(digital_gain, -8400, 100, -8400);
 
 /* Cutoff Freq for High Pass Filter at -3dB */
 static const char * const hpf_cutoff_text[] = {
@@ -510,15 +510,15 @@ static int wcd_iir_filter_info(struct snd_kcontrol *kcontrol,
 
 static const struct snd_kcontrol_new msm8916_wcd_digital_snd_controls[] = {
 	SOC_SINGLE_S8_TLV("RX1 Digital Volume", LPASS_CDC_RX1_VOL_CTL_B2_CTL,
-			  -128, 127, digital_gain),
+			-84, 40, digital_gain),
 	SOC_SINGLE_S8_TLV("RX2 Digital Volume", LPASS_CDC_RX2_VOL_CTL_B2_CTL,
-			  -128, 127, digital_gain),
+			-84, 40, digital_gain),
 	SOC_SINGLE_S8_TLV("RX3 Digital Volume", LPASS_CDC_RX3_VOL_CTL_B2_CTL,
-			  -128, 127, digital_gain),
+			-84, 40, digital_gain),
 	SOC_SINGLE_S8_TLV("TX1 Digital Volume", LPASS_CDC_TX1_VOL_CTL_GAIN,
-			  -128, 127, digital_gain),
+			-84, 40, digital_gain),
 	SOC_SINGLE_S8_TLV("TX2 Digital Volume", LPASS_CDC_TX2_VOL_CTL_GAIN,
-			  -128, 127, digital_gain),
+			-84, 40, digital_gain),
 	SOC_ENUM("TX1 HPF Cutoff", tx1_hpf_cutoff_enum),
 	SOC_ENUM("TX2 HPF Cutoff", tx2_hpf_cutoff_enum),
 	SOC_SINGLE("TX1 HPF Switch", LPASS_CDC_TX1_MUX_CTL, 3, 1, 0),
@@ -553,22 +553,22 @@ static const struct snd_kcontrol_new msm8916_wcd_digital_snd_controls[] = {
 	WCD_IIR_FILTER_CTL("IIR2 Band3", IIR2, BAND3),
 	WCD_IIR_FILTER_CTL("IIR2 Band4", IIR2, BAND4),
 	WCD_IIR_FILTER_CTL("IIR2 Band5", IIR2, BAND5),
-	SOC_SINGLE_SX_TLV("IIR1 INP1 Volume", LPASS_CDC_IIR1_GAIN_B1_CTL,
-			0,  -84, 40, digital_gain),
-	SOC_SINGLE_SX_TLV("IIR1 INP2 Volume", LPASS_CDC_IIR1_GAIN_B2_CTL,
-			0,  -84, 40, digital_gain),
-	SOC_SINGLE_SX_TLV("IIR1 INP3 Volume", LPASS_CDC_IIR1_GAIN_B3_CTL,
-			0,  -84, 40, digital_gain),
-	SOC_SINGLE_SX_TLV("IIR1 INP4 Volume", LPASS_CDC_IIR1_GAIN_B4_CTL,
-			0,  -84,	40, digital_gain),
-	SOC_SINGLE_SX_TLV("IIR2 INP1 Volume", LPASS_CDC_IIR2_GAIN_B1_CTL,
-			0,  -84, 40, digital_gain),
-	SOC_SINGLE_SX_TLV("IIR2 INP2 Volume", LPASS_CDC_IIR2_GAIN_B2_CTL,
-			0,  -84, 40, digital_gain),
-	SOC_SINGLE_SX_TLV("IIR2 INP3 Volume", LPASS_CDC_IIR2_GAIN_B3_CTL,
-			0,  -84, 40, digital_gain),
-	SOC_SINGLE_SX_TLV("IIR2 INP4 Volume", LPASS_CDC_IIR2_GAIN_B4_CTL,
-			0,  -84, 40, digital_gain),
+	SOC_SINGLE_S8_TLV("IIR1 INP1 Volume", LPASS_CDC_IIR1_GAIN_B1_CTL,
+			-84, 40, digital_gain),
+	SOC_SINGLE_S8_TLV("IIR1 INP2 Volume", LPASS_CDC_IIR1_GAIN_B2_CTL,
+			-84, 40, digital_gain),
+	SOC_SINGLE_S8_TLV("IIR1 INP3 Volume", LPASS_CDC_IIR1_GAIN_B3_CTL,
+			-84, 40, digital_gain),
+	SOC_SINGLE_S8_TLV("IIR1 INP4 Volume", LPASS_CDC_IIR1_GAIN_B4_CTL,
+			-84, 40, digital_gain),
+	SOC_SINGLE_S8_TLV("IIR2 INP1 Volume", LPASS_CDC_IIR2_GAIN_B1_CTL,
+			-84, 40, digital_gain),
+	SOC_SINGLE_S8_TLV("IIR2 INP2 Volume", LPASS_CDC_IIR2_GAIN_B2_CTL,
+			-84, 40, digital_gain),
+	SOC_SINGLE_S8_TLV("IIR2 INP3 Volume", LPASS_CDC_IIR2_GAIN_B3_CTL,
+			-84, 40, digital_gain),
+	SOC_SINGLE_S8_TLV("IIR2 INP4 Volume", LPASS_CDC_IIR2_GAIN_B4_CTL,
+			-84, 40, digital_gain),
 
 };
 
-- 
2.35.1



