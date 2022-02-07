Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 624F54ABD43
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:59:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387191AbiBGLkQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:40:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386657AbiBGLfR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:35:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 516ACC043181;
        Mon,  7 Feb 2022 03:35:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EF8FAB8102E;
        Mon,  7 Feb 2022 11:35:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01F14C004E1;
        Mon,  7 Feb 2022 11:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233713;
        bh=QSzRICIWp+0GChseBdZWcjIxGZHnKp6X93Ah6uWn+to=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gIzCZtlQjkuvD8V8KtlewN6eM2FxVXvAddALChJKOvywZso9NBzGcHW2aj4Q8XU3+
         5D2XSjCKeyCZ0RMi4zWxbDSriFF8ugOEVgbOWARacUYMY7k+JhmurRudODM/DZMqQI
         +MDGZEejixzvVPMVhRzLDqdOUEBneSYK9Jjr1UOs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.16 090/126] ASoC: codecs: lpass-rx-macro: fix sidetone register offsets
Date:   Mon,  7 Feb 2022 12:07:01 +0100
Message-Id: <20220207103807.201367072@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103804.053675072@linuxfoundation.org>
References: <20220207103804.053675072@linuxfoundation.org>
User-Agent: quilt/0.66
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

commit fca041a3ab70a099a6d5519ecb689b6279bd04f3 upstream.

For some reason we ended up with incorrect register offfset calcuations
for sidetone. regmap clearly throw errors when accessing these incorrect
registers as these do not belong to any read/write ranges.
so fix them to point to correct register offsets.

Fixes: f3ce6f3c9a99 ("ASoC: codecs: lpass-rx-macro: add iir widgets")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20220126113549.8853-3-srinivas.kandagatla@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/lpass-rx-macro.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/sound/soc/codecs/lpass-rx-macro.c
+++ b/sound/soc/codecs/lpass-rx-macro.c
@@ -2688,8 +2688,8 @@ static uint32_t get_iir_band_coeff(struc
 	int reg, b2_reg;
 
 	/* Address does not automatically update if reading */
-	reg = CDC_RX_SIDETONE_IIR0_IIR_COEF_B1_CTL + 16 * iir_idx;
-	b2_reg = CDC_RX_SIDETONE_IIR0_IIR_COEF_B2_CTL + 16 * iir_idx;
+	reg = CDC_RX_SIDETONE_IIR0_IIR_COEF_B1_CTL + 0x80 * iir_idx;
+	b2_reg = CDC_RX_SIDETONE_IIR0_IIR_COEF_B2_CTL + 0x80 * iir_idx;
 
 	snd_soc_component_write(component, reg,
 				((band_idx * BAND_MAX + coeff_idx) *
@@ -2718,7 +2718,7 @@ static uint32_t get_iir_band_coeff(struc
 static void set_iir_band_coeff(struct snd_soc_component *component,
 			       int iir_idx, int band_idx, uint32_t value)
 {
-	int reg = CDC_RX_SIDETONE_IIR0_IIR_COEF_B2_CTL + 16 * iir_idx;
+	int reg = CDC_RX_SIDETONE_IIR0_IIR_COEF_B2_CTL + 0x80 * iir_idx;
 
 	snd_soc_component_write(component, reg, (value & 0xFF));
 	snd_soc_component_write(component, reg, (value >> 8) & 0xFF);
@@ -2739,7 +2739,7 @@ static int rx_macro_put_iir_band_audio_m
 	int iir_idx = ctl->iir_idx;
 	int band_idx = ctl->band_idx;
 	u32 coeff[BAND_MAX];
-	int reg = CDC_RX_SIDETONE_IIR0_IIR_COEF_B1_CTL + 16 * iir_idx;
+	int reg = CDC_RX_SIDETONE_IIR0_IIR_COEF_B1_CTL + 0x80 * iir_idx;
 
 	memcpy(&coeff[0], ucontrol->value.bytes.data, params->max);
 


