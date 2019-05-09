Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93DC0191EC
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 21:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727573AbfEISuX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:50:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:43868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727693AbfEISuW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:50:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC45020578;
        Thu,  9 May 2019 18:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557427821;
        bh=uA4kEIfZo9TbnlF7NqgBQomYfFPlnVNdd7ai6kUB0o0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=McwEYcXwWpta9OKjE7nfoigd+OqiKUMN99qPs05J7ubxNt6TQwwVgX3+bgsRKFl4z
         BMX7W3sWNVfx+VqGtjwIxcUADHM6sGz8nnsxi4CxTA1LviI8Po7imwqYcQ4gPiFXRk
         PBcx4Zm52lY37v5zRBaYPp+hOnYq8gusuugK5A/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Hsu <KCHSU0@nuvoton.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 17/95] ASoC: nau8824: fix the issue of the widget with prefix name
Date:   Thu,  9 May 2019 20:41:34 +0200
Message-Id: <20190509181310.549089444@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181309.180685671@linuxfoundation.org>
References: <20190509181309.180685671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 844a4a362dbec166b44d6b9b3dd45b08cb273703 ]

The driver has two issues when machine add prefix name for codec.
(1)The stream name of DAI can't find the AIF widgets.
(2)The drivr can enable/disalbe the MICBIAS and SAR widgets.

The patch will fix these issues caused by prefixed name added.

Signed-off-by: John Hsu <KCHSU0@nuvoton.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/nau8824.c | 46 +++++++++++++++++++++++++++++++-------
 1 file changed, 38 insertions(+), 8 deletions(-)

diff --git a/sound/soc/codecs/nau8824.c b/sound/soc/codecs/nau8824.c
index 468d5143e2c4f..663a208c2f784 100644
--- a/sound/soc/codecs/nau8824.c
+++ b/sound/soc/codecs/nau8824.c
@@ -681,8 +681,8 @@ static const struct snd_soc_dapm_widget nau8824_dapm_widgets[] = {
 	SND_SOC_DAPM_ADC("ADCR", NULL, NAU8824_REG_ANALOG_ADC_2,
 		NAU8824_ADCR_EN_SFT, 0),
 
-	SND_SOC_DAPM_AIF_OUT("AIFTX", "HiFi Capture", 0, SND_SOC_NOPM, 0, 0),
-	SND_SOC_DAPM_AIF_IN("AIFRX", "HiFi Playback", 0, SND_SOC_NOPM, 0, 0),
+	SND_SOC_DAPM_AIF_OUT("AIFTX", "Capture", 0, SND_SOC_NOPM, 0, 0),
+	SND_SOC_DAPM_AIF_IN("AIFRX", "Playback", 0, SND_SOC_NOPM, 0, 0),
 
 	SND_SOC_DAPM_DAC("DACL", NULL, NAU8824_REG_RDAC,
 		NAU8824_DACL_EN_SFT, 0),
@@ -831,6 +831,36 @@ static void nau8824_int_status_clear_all(struct regmap *regmap)
 	}
 }
 
+static void nau8824_dapm_disable_pin(struct nau8824 *nau8824, const char *pin)
+{
+	struct snd_soc_dapm_context *dapm = nau8824->dapm;
+	const char *prefix = dapm->component->name_prefix;
+	char prefixed_pin[80];
+
+	if (prefix) {
+		snprintf(prefixed_pin, sizeof(prefixed_pin), "%s %s",
+			 prefix, pin);
+		snd_soc_dapm_disable_pin(dapm, prefixed_pin);
+	} else {
+		snd_soc_dapm_disable_pin(dapm, pin);
+	}
+}
+
+static void nau8824_dapm_enable_pin(struct nau8824 *nau8824, const char *pin)
+{
+	struct snd_soc_dapm_context *dapm = nau8824->dapm;
+	const char *prefix = dapm->component->name_prefix;
+	char prefixed_pin[80];
+
+	if (prefix) {
+		snprintf(prefixed_pin, sizeof(prefixed_pin), "%s %s",
+			 prefix, pin);
+		snd_soc_dapm_force_enable_pin(dapm, prefixed_pin);
+	} else {
+		snd_soc_dapm_force_enable_pin(dapm, pin);
+	}
+}
+
 static void nau8824_eject_jack(struct nau8824 *nau8824)
 {
 	struct snd_soc_dapm_context *dapm = nau8824->dapm;
@@ -839,8 +869,8 @@ static void nau8824_eject_jack(struct nau8824 *nau8824)
 	/* Clear all interruption status */
 	nau8824_int_status_clear_all(regmap);
 
-	snd_soc_dapm_disable_pin(dapm, "SAR");
-	snd_soc_dapm_disable_pin(dapm, "MICBIAS");
+	nau8824_dapm_disable_pin(nau8824, "SAR");
+	nau8824_dapm_disable_pin(nau8824, "MICBIAS");
 	snd_soc_dapm_sync(dapm);
 
 	/* Enable the insertion interruption, disable the ejection
@@ -870,8 +900,8 @@ static void nau8824_jdet_work(struct work_struct *work)
 	struct regmap *regmap = nau8824->regmap;
 	int adc_value, event = 0, event_mask = 0;
 
-	snd_soc_dapm_force_enable_pin(dapm, "MICBIAS");
-	snd_soc_dapm_force_enable_pin(dapm, "SAR");
+	nau8824_dapm_enable_pin(nau8824, "MICBIAS");
+	nau8824_dapm_enable_pin(nau8824, "SAR");
 	snd_soc_dapm_sync(dapm);
 
 	msleep(100);
@@ -882,8 +912,8 @@ static void nau8824_jdet_work(struct work_struct *work)
 	if (adc_value < HEADSET_SARADC_THD) {
 		event |= SND_JACK_HEADPHONE;
 
-		snd_soc_dapm_disable_pin(dapm, "SAR");
-		snd_soc_dapm_disable_pin(dapm, "MICBIAS");
+		nau8824_dapm_disable_pin(nau8824, "SAR");
+		nau8824_dapm_disable_pin(nau8824, "MICBIAS");
 		snd_soc_dapm_sync(dapm);
 	} else {
 		event |= SND_JACK_HEADSET;
-- 
2.20.1



