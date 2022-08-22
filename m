Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1378259BD74
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 12:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232994AbiHVKRe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 06:17:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232331AbiHVKRc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 06:17:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D30B1900B
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 03:17:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B8A860FC5
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 10:17:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A745C433C1;
        Mon, 22 Aug 2022 10:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661163451;
        bh=G0Bmu1fZfITRvf6AVR5XZG/OLyOqOG19ro4LJDfmJRk=;
        h=Subject:To:Cc:From:Date:From;
        b=QGdRUn0i3gvl4lW3y5ur/S/4j2SPj7hxVD7YdVVdDhh8XaMgLagrKu2RBDUZe68Y0
         1P++bcXL9wOcT4Fw9j02M4XMm78+PUzIANAfQja00D3kMXWGNwCXRTnUxugxujjdBl
         XGIK8PWiQ4uh+Pt1EZsvbMJX00FiSyQxN9rvmJ2M=
Subject: FAILED: patch "[PATCH] ASoC: codec: tlv320aic32x4: fix mono playback via I2S" failed to apply to 5.10-stable tree
To:     p.zabel@pengutronix.de, broonie@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 22 Aug 2022 12:17:28 +0200
Message-ID: <16611634486230@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b4b5f29a076e52181f63e45a2ad1bc88593072e3 Mon Sep 17 00:00:00 2001
From: Philipp Zabel <p.zabel@pengutronix.de>
Date: Wed, 10 Aug 2022 12:41:56 +0200
Subject: [PATCH] ASoC: codec: tlv320aic32x4: fix mono playback via I2S

The two commits referenced below break mono playback via I2S DAI because
they set BCLK to half the required speed. For PCM transport over I2S, the
number of transmitted channels is always 2, even for mono playback.

Fixes: dcd79364bff3 ("ASoC: codec: tlv3204: Enable 24 bit audio support")
Fixes: 40b37136287b ("ASoC: tlv320aic32x4: Fix bdiv clock rate derivation")
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Link: https://lore.kernel.org/r/20220810104156.665452-1-p.zabel@pengutronix.de
Signed-off-by: Mark Brown <broonie@kernel.org>

diff --git a/sound/soc/codecs/tlv320aic32x4.c b/sound/soc/codecs/tlv320aic32x4.c
index 4b74805cdd2e..ffe1828a4b7e 100644
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
@@ -611,6 +613,7 @@ static int aic32x4_set_dai_sysclk(struct snd_soc_dai *codec_dai,
 static int aic32x4_set_dai_fmt(struct snd_soc_dai *codec_dai, unsigned int fmt)
 {
 	struct snd_soc_component *component = codec_dai->component;
+	struct aic32x4_priv *aic32x4 = snd_soc_component_get_drvdata(component);
 	u8 iface_reg_1 = 0;
 	u8 iface_reg_2 = 0;
 	u8 iface_reg_3 = 0;
@@ -653,6 +656,8 @@ static int aic32x4_set_dai_fmt(struct snd_soc_dai *codec_dai, unsigned int fmt)
 		return -EINVAL;
 	}
 
+	aic32x4->fmt = fmt;
+
 	snd_soc_component_update_bits(component, AIC32X4_IFACE1,
 				AIC32X4_IFACE1_DATATYPE_MASK |
 				AIC32X4_IFACE1_MASTER_MASK, iface_reg_1);
@@ -757,6 +762,10 @@ static int aic32x4_setup_clocks(struct snd_soc_component *component,
 		return -EINVAL;
 	}
 
+	/* PCM over I2S is always 2-channel */
+	if ((aic32x4->fmt & SND_SOC_DAIFMT_FORMAT_MASK) == SND_SOC_DAIFMT_I2S)
+		channels = 2;
+
 	madc = DIV_ROUND_UP((32 * adc_resource_class), aosr);
 	max_dosr = (AIC32X4_MAX_DOSR_FREQ / sample_rate / dosr_increment) *
 			dosr_increment;

