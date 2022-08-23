Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9170D59D9FE
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352064AbiHWKEV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:04:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352584AbiHWKCK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:02:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87E2D7C329;
        Tue, 23 Aug 2022 01:50:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C7468B81C1C;
        Tue, 23 Aug 2022 08:50:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EEFDC433C1;
        Tue, 23 Aug 2022 08:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244606;
        bh=v5/YKtomldikhe/i3h6gjddah5wV/t0Qwoy5NR3BAPQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GAzXUwRupk6uElk0tOdB83kTX7dJpzZccYvDRXVMLRGuINwQJ1bzG3Z164d0vKhwx
         ujSRn4y6GncUehSLS6nZJGPYokrbQPMufwSD57tyPHkzXf7Jt/+Y+x8G+HKwbujMvA
         5r6i9QlsCwZNBtpISWF0TRlOttjbUwH73fQLDRRU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 122/244] ASoC: codec: tlv320aic32x4: fix mono playback via I2S
Date:   Tue, 23 Aug 2022 10:24:41 +0200
Message-Id: <20220823080103.132900132@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
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

From: Philipp Zabel <p.zabel@pengutronix.de>

commit b4b5f29a076e52181f63e45a2ad1bc88593072e3 upstream.

The two commits referenced below break mono playback via I2S DAI because
they set BCLK to half the required speed. For PCM transport over I2S, the
number of transmitted channels is always 2, even for mono playback.

Fixes: dcd79364bff3 ("ASoC: codec: tlv3204: Enable 24 bit audio support")
Fixes: 40b37136287b ("ASoC: tlv320aic32x4: Fix bdiv clock rate derivation")
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Link: https://lore.kernel.org/r/20220810104156.665452-1-p.zabel@pengutronix.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/tlv320aic32x4.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/sound/soc/codecs/tlv320aic32x4.c
+++ b/sound/soc/codecs/tlv320aic32x4.c
@@ -49,6 +49,8 @@ struct aic32x4_priv {
 	struct aic32x4_setup_data *setup;
 	struct device *dev;
 	enum aic32x4_type type;
+
+	unsigned int fmt;
 };
 
 static int aic32x4_reset_adc(struct snd_soc_dapm_widget *w,
@@ -611,6 +613,7 @@ static int aic32x4_set_dai_sysclk(struct
 static int aic32x4_set_dai_fmt(struct snd_soc_dai *codec_dai, unsigned int fmt)
 {
 	struct snd_soc_component *component = codec_dai->component;
+	struct aic32x4_priv *aic32x4 = snd_soc_component_get_drvdata(component);
 	u8 iface_reg_1 = 0;
 	u8 iface_reg_2 = 0;
 	u8 iface_reg_3 = 0;
@@ -654,6 +657,8 @@ static int aic32x4_set_dai_fmt(struct sn
 		return -EINVAL;
 	}
 
+	aic32x4->fmt = fmt;
+
 	snd_soc_component_update_bits(component, AIC32X4_IFACE1,
 				AIC32X4_IFACE1_DATATYPE_MASK |
 				AIC32X4_IFACE1_MASTER_MASK, iface_reg_1);
@@ -758,6 +763,10 @@ static int aic32x4_setup_clocks(struct s
 		return -EINVAL;
 	}
 
+	/* PCM over I2S is always 2-channel */
+	if ((aic32x4->fmt & SND_SOC_DAIFMT_FORMAT_MASK) == SND_SOC_DAIFMT_I2S)
+		channels = 2;
+
 	madc = DIV_ROUND_UP((32 * adc_resource_class), aosr);
 	max_dosr = (AIC32X4_MAX_DOSR_FREQ / sample_rate / dosr_increment) *
 			dosr_increment;


