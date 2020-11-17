Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46E352B6499
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:50:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732026AbgKQNdc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:33:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:43418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732047AbgKQNd0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:33:26 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9343F2078E;
        Tue, 17 Nov 2020 13:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620006;
        bh=l2Jw2CD3tgByn9HdhbfrTBIjqlt2hug4S+cpuWnQWY4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dw3tyHMGFGwp//DDeqy+UcNZ0CA63WGMY9DaDp74eeOEbAfiGqzoefuwnE5dicvPc
         BwQhAc2+ksSvKKFgkon0YCTpWPN7w6o2iQzt4wqoKYL8iP8AbuXkDgIFnwZiir53/4
         G9BfqBFol8kwZGV+OzwmMy/2/94BeAr6Iu5vRd5U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tzung-Bi Shih <tzungbi@google.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 076/255] ASoC: mediatek: mt8183-da7219: fix DAPM paths for rt1015
Date:   Tue, 17 Nov 2020 14:03:36 +0100
Message-Id: <20201117122142.649814130@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tzung-Bi Shih <tzungbi@google.com>

[ Upstream commit eb5a558705c7f63d06b4ddd072898b1ca894e053 ]

RT1015's output widget name is "SPO" instead of "Speaker".  Fixes it to
use the correct names.

Signed-off-by: Tzung-Bi Shih <tzungbi@google.com>
Link: https://lore.kernel.org/r/20201019044724.1601476-1-tzungbi@google.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mediatek/mt8183/mt8183-da7219-max98357.c  | 31 +++++++++++++++----
 1 file changed, 25 insertions(+), 6 deletions(-)

diff --git a/sound/soc/mediatek/mt8183/mt8183-da7219-max98357.c b/sound/soc/mediatek/mt8183/mt8183-da7219-max98357.c
index a6c690c5308d3..58b76e985f7f3 100644
--- a/sound/soc/mediatek/mt8183/mt8183-da7219-max98357.c
+++ b/sound/soc/mediatek/mt8183/mt8183-da7219-max98357.c
@@ -624,15 +624,34 @@ static struct snd_soc_codec_conf mt8183_da7219_rt1015_codec_conf[] = {
 	},
 };
 
+static const struct snd_kcontrol_new mt8183_da7219_rt1015_snd_controls[] = {
+	SOC_DAPM_PIN_SWITCH("Left Spk"),
+	SOC_DAPM_PIN_SWITCH("Right Spk"),
+};
+
+static const
+struct snd_soc_dapm_widget mt8183_da7219_rt1015_dapm_widgets[] = {
+	SND_SOC_DAPM_SPK("Left Spk", NULL),
+	SND_SOC_DAPM_SPK("Right Spk", NULL),
+	SND_SOC_DAPM_PINCTRL("TDM_OUT_PINCTRL",
+			     "aud_tdm_out_on", "aud_tdm_out_off"),
+};
+
+static const struct snd_soc_dapm_route mt8183_da7219_rt1015_dapm_routes[] = {
+	{"Left Spk", NULL, "Left SPO"},
+	{"Right Spk", NULL, "Right SPO"},
+	{"I2S Playback", NULL, "TDM_OUT_PINCTRL"},
+};
+
 static struct snd_soc_card mt8183_da7219_rt1015_card = {
 	.name = "mt8183_da7219_rt1015",
 	.owner = THIS_MODULE,
-	.controls = mt8183_da7219_max98357_snd_controls,
-	.num_controls = ARRAY_SIZE(mt8183_da7219_max98357_snd_controls),
-	.dapm_widgets = mt8183_da7219_max98357_dapm_widgets,
-	.num_dapm_widgets = ARRAY_SIZE(mt8183_da7219_max98357_dapm_widgets),
-	.dapm_routes = mt8183_da7219_max98357_dapm_routes,
-	.num_dapm_routes = ARRAY_SIZE(mt8183_da7219_max98357_dapm_routes),
+	.controls = mt8183_da7219_rt1015_snd_controls,
+	.num_controls = ARRAY_SIZE(mt8183_da7219_rt1015_snd_controls),
+	.dapm_widgets = mt8183_da7219_rt1015_dapm_widgets,
+	.num_dapm_widgets = ARRAY_SIZE(mt8183_da7219_rt1015_dapm_widgets),
+	.dapm_routes = mt8183_da7219_rt1015_dapm_routes,
+	.num_dapm_routes = ARRAY_SIZE(mt8183_da7219_rt1015_dapm_routes),
 	.dai_link = mt8183_da7219_dai_links,
 	.num_links = ARRAY_SIZE(mt8183_da7219_dai_links),
 	.aux_dev = &mt8183_da7219_max98357_headset_dev,
-- 
2.27.0



