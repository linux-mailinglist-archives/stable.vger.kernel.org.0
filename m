Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8074D4521CC
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:04:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359162AbhKPBGy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:06:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:44602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245385AbhKOTU0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:20:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 72E5163533;
        Mon, 15 Nov 2021 18:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001219;
        bh=r0Iuw4bHx/K7S8hDlq88RVgKdNwWlI32TXlOsx0U5eY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lg1WH9Ig4yJ/pnDPDtq+VSnHk5DlVg1w4qCfP4UapUgqNqbDTVfYgWv/nTsVdzkfn
         AnZNpIJspCHlFqIjtbzgX0YIDFadkcklwYD9PzZAIADtCcYZ0WfmLaI5W3NlvLhXrP
         YLh1NDucvuz9KcXiiMK6MHnKFOtHqOnW207WwEb0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Osipenko <digetx@gmail.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 107/917] ASoC: tegra: Restore AC97 support
Date:   Mon, 15 Nov 2021 17:53:22 +0100
Message-Id: <20211115165432.389374889@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

commit de8fc2b0a3f9930f3cbe801d40758bb1d80b0ad8 upstream.

The device-tree of AC97 codecs need to be parsed differently from I2S
codecs, plus codec device may need to be created. This was missed by the
patch that unified machine drivers into a single driver, fix it. It should
restore audio on Toradex Colibri board.

Cc: <stable@vger.kernel.org>
Fixes: cc8f70f56039 ("ASoC: tegra: Unify ASoC machine drivers")
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Link: https://lore.kernel.org/r/20211024192853.21957-1-digetx@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/tegra/tegra_asoc_machine.c |   63 ++++++++++++++++++++++++++++-------
 sound/soc/tegra/tegra_asoc_machine.h |    1 
 2 files changed, 52 insertions(+), 12 deletions(-)

--- a/sound/soc/tegra/tegra_asoc_machine.c
+++ b/sound/soc/tegra/tegra_asoc_machine.c
@@ -341,9 +341,34 @@ tegra_machine_parse_phandle(struct devic
 	return np;
 }
 
+static void tegra_machine_unregister_codec(void *pdev)
+{
+	platform_device_unregister(pdev);
+}
+
+static int tegra_machine_register_codec(struct device *dev, const char *name)
+{
+	struct platform_device *pdev;
+	int err;
+
+	if (!name)
+		return 0;
+
+	pdev = platform_device_register_simple(name, -1, NULL, 0);
+	if (IS_ERR(pdev))
+		return PTR_ERR(pdev);
+
+	err = devm_add_action_or_reset(dev, tegra_machine_unregister_codec,
+				       pdev);
+	if (err)
+		return err;
+
+	return 0;
+}
+
 int tegra_asoc_machine_probe(struct platform_device *pdev)
 {
-	struct device_node *np_codec, *np_i2s;
+	struct device_node *np_codec, *np_i2s, *np_ac97;
 	const struct tegra_asoc_data *asoc;
 	struct device *dev = &pdev->dev;
 	struct tegra_machine *machine;
@@ -404,17 +429,30 @@ int tegra_asoc_machine_probe(struct plat
 			return err;
 	}
 
-	np_codec = tegra_machine_parse_phandle(dev, "nvidia,audio-codec");
-	if (IS_ERR(np_codec))
-		return PTR_ERR(np_codec);
-
-	np_i2s = tegra_machine_parse_phandle(dev, "nvidia,i2s-controller");
-	if (IS_ERR(np_i2s))
-		return PTR_ERR(np_i2s);
-
-	card->dai_link->cpus->of_node = np_i2s;
-	card->dai_link->codecs->of_node = np_codec;
-	card->dai_link->platforms->of_node = np_i2s;
+	if (asoc->set_ac97) {
+		err = tegra_machine_register_codec(dev, asoc->codec_dev_name);
+		if (err)
+			return err;
+
+		np_ac97 = tegra_machine_parse_phandle(dev, "nvidia,ac97-controller");
+		if (IS_ERR(np_ac97))
+			return PTR_ERR(np_ac97);
+
+		card->dai_link->cpus->of_node = np_ac97;
+		card->dai_link->platforms->of_node = np_ac97;
+	} else {
+		np_codec = tegra_machine_parse_phandle(dev, "nvidia,audio-codec");
+		if (IS_ERR(np_codec))
+			return PTR_ERR(np_codec);
+
+		np_i2s = tegra_machine_parse_phandle(dev, "nvidia,i2s-controller");
+		if (IS_ERR(np_i2s))
+			return PTR_ERR(np_i2s);
+
+		card->dai_link->cpus->of_node = np_i2s;
+		card->dai_link->codecs->of_node = np_codec;
+		card->dai_link->platforms->of_node = np_i2s;
+	}
 
 	if (asoc->add_common_controls) {
 		card->controls = tegra_machine_controls;
@@ -589,6 +627,7 @@ static struct snd_soc_card snd_soc_tegra
 static const struct tegra_asoc_data tegra_wm9712_data = {
 	.card = &snd_soc_tegra_wm9712,
 	.add_common_dapm_widgets = true,
+	.codec_dev_name = "wm9712-codec",
 	.set_ac97 = true,
 };
 
--- a/sound/soc/tegra/tegra_asoc_machine.h
+++ b/sound/soc/tegra/tegra_asoc_machine.h
@@ -13,6 +13,7 @@ struct snd_soc_pcm_runtime;
 
 struct tegra_asoc_data {
 	unsigned int (*mclk_rate)(unsigned int srate);
+	const char *codec_dev_name;
 	struct snd_soc_card *card;
 	unsigned int mclk_id;
 	bool hp_jack_gpio_active_low;


