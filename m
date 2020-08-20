Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54E5924BC8A
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729619AbgHTMsu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 08:48:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:45700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729048AbgHTJpQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:45:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8DB9222D00;
        Thu, 20 Aug 2020 09:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916656;
        bh=VxJz+B3N9tywaAd9nJ/H+Vb38kntR4F4BgLUfhky2Fk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RYSaO7k2zsseSal4L3DgaRAzZdXsZCCyCSZOBWqsfWrPFgtcSfNRSE6tQbQ3na5wo
         1ycbPGFWWXEajB2VYtAUQipMqmfnufULE5/uDb606YE5KLxDhGl49quJP45YXfAbDW
         ZPEMTcG7rw7v/Mv4zEYxTYANDMBZS9xbyDvd/XkE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Osipenko <digetx@gmail.com>,
        Sameer Pujar <spujar@nvidia.com>,
        Sowjanya Komatineni <skomatineni@nvidia.com>,
        Thierry Reding <treding@nvidia.com>
Subject: [PATCH 5.7 190/204] ASoC: tegra: Use device managed resource APIs to get the clock
Date:   Thu, 20 Aug 2020 11:21:27 +0200
Message-Id: <20200820091615.683726975@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091606.194320503@linuxfoundation.org>
References: <20200820091606.194320503@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sowjanya Komatineni <skomatineni@nvidia.com>

commit 0de6db30ef79b391cedd749801a49c485d2daf4b upstream.

tegra_asoc_utils uses clk_get() to get the clock and clk_put() to free
them explicitly.

This patch updates it to use device managed resource API devm_clk_get()
so the clock will be automatically released and freed when the device is
unbound and removes tegra_asoc_utils_fini() as its no longer needed.

Tested-by: Dmitry Osipenko <digetx@gmail.com>
Reviewed-by: Dmitry Osipenko <digetx@gmail.com>
Reviewed-by: Sameer Pujar <spujar@nvidia.com>
Signed-off-by: Sowjanya Komatineni <skomatineni@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/tegra/tegra_alc5632.c    |    7 +------
 sound/soc/tegra/tegra_asoc_utils.c |   34 +++++++---------------------------
 sound/soc/tegra/tegra_asoc_utils.h |    1 -
 sound/soc/tegra/tegra_max98090.c   |   22 ++++++----------------
 sound/soc/tegra/tegra_rt5640.c     |   22 ++++++----------------
 sound/soc/tegra/tegra_rt5677.c     |    7 +------
 sound/soc/tegra/tegra_sgtl5000.c   |    7 +------
 sound/soc/tegra/tegra_wm8753.c     |   22 ++++++----------------
 sound/soc/tegra/tegra_wm8903.c     |   22 ++++++----------------
 sound/soc/tegra/tegra_wm9712.c     |    8 ++------
 sound/soc/tegra/trimslice.c        |   18 ++++--------------
 11 files changed, 40 insertions(+), 130 deletions(-)

--- a/sound/soc/tegra/tegra_alc5632.c
+++ b/sound/soc/tegra/tegra_alc5632.c
@@ -205,13 +205,11 @@ static int tegra_alc5632_probe(struct pl
 	if (ret) {
 		dev_err(&pdev->dev, "snd_soc_register_card failed (%d)\n",
 			ret);
-		goto err_fini_utils;
+		goto err_put_cpu_of_node;
 	}
 
 	return 0;
 
-err_fini_utils:
-	tegra_asoc_utils_fini(&alc5632->util_data);
 err_put_cpu_of_node:
 	of_node_put(tegra_alc5632_dai.cpus->of_node);
 	tegra_alc5632_dai.cpus->of_node = NULL;
@@ -226,12 +224,9 @@ err:
 static int tegra_alc5632_remove(struct platform_device *pdev)
 {
 	struct snd_soc_card *card = platform_get_drvdata(pdev);
-	struct tegra_alc5632 *machine = snd_soc_card_get_drvdata(card);
 
 	snd_soc_unregister_card(card);
 
-	tegra_asoc_utils_fini(&machine->util_data);
-
 	of_node_put(tegra_alc5632_dai.cpus->of_node);
 	tegra_alc5632_dai.cpus->of_node = NULL;
 	tegra_alc5632_dai.platforms->of_node = NULL;
--- a/sound/soc/tegra/tegra_asoc_utils.c
+++ b/sound/soc/tegra/tegra_asoc_utils.c
@@ -175,52 +175,32 @@ int tegra_asoc_utils_init(struct tegra_a
 		return -EINVAL;
 	}
 
-	data->clk_pll_a = clk_get(dev, "pll_a");
+	data->clk_pll_a = devm_clk_get(dev, "pll_a");
 	if (IS_ERR(data->clk_pll_a)) {
 		dev_err(data->dev, "Can't retrieve clk pll_a\n");
-		ret = PTR_ERR(data->clk_pll_a);
-		goto err;
+		return PTR_ERR(data->clk_pll_a);
 	}
 
-	data->clk_pll_a_out0 = clk_get(dev, "pll_a_out0");
+	data->clk_pll_a_out0 = devm_clk_get(dev, "pll_a_out0");
 	if (IS_ERR(data->clk_pll_a_out0)) {
 		dev_err(data->dev, "Can't retrieve clk pll_a_out0\n");
-		ret = PTR_ERR(data->clk_pll_a_out0);
-		goto err_put_pll_a;
+		return PTR_ERR(data->clk_pll_a_out0);
 	}
 
-	data->clk_cdev1 = clk_get(dev, "mclk");
+	data->clk_cdev1 = devm_clk_get(dev, "mclk");
 	if (IS_ERR(data->clk_cdev1)) {
 		dev_err(data->dev, "Can't retrieve clk cdev1\n");
-		ret = PTR_ERR(data->clk_cdev1);
-		goto err_put_pll_a_out0;
+		return PTR_ERR(data->clk_cdev1);
 	}
 
 	ret = tegra_asoc_utils_set_rate(data, 44100, 256 * 44100);
 	if (ret)
-		goto err_put_cdev1;
+		return ret;
 
 	return 0;
-
-err_put_cdev1:
-	clk_put(data->clk_cdev1);
-err_put_pll_a_out0:
-	clk_put(data->clk_pll_a_out0);
-err_put_pll_a:
-	clk_put(data->clk_pll_a);
-err:
-	return ret;
 }
 EXPORT_SYMBOL_GPL(tegra_asoc_utils_init);
 
-void tegra_asoc_utils_fini(struct tegra_asoc_utils_data *data)
-{
-	clk_put(data->clk_cdev1);
-	clk_put(data->clk_pll_a_out0);
-	clk_put(data->clk_pll_a);
-}
-EXPORT_SYMBOL_GPL(tegra_asoc_utils_fini);
-
 MODULE_AUTHOR("Stephen Warren <swarren@nvidia.com>");
 MODULE_DESCRIPTION("Tegra ASoC utility code");
 MODULE_LICENSE("GPL");
--- a/sound/soc/tegra/tegra_asoc_utils.h
+++ b/sound/soc/tegra/tegra_asoc_utils.h
@@ -34,6 +34,5 @@ int tegra_asoc_utils_set_rate(struct teg
 int tegra_asoc_utils_set_ac97_rate(struct tegra_asoc_utils_data *data);
 int tegra_asoc_utils_init(struct tegra_asoc_utils_data *data,
 			  struct device *dev);
-void tegra_asoc_utils_fini(struct tegra_asoc_utils_data *data);
 
 #endif
--- a/sound/soc/tegra/tegra_max98090.c
+++ b/sound/soc/tegra/tegra_max98090.c
@@ -218,19 +218,18 @@ static int tegra_max98090_probe(struct p
 
 	ret = snd_soc_of_parse_card_name(card, "nvidia,model");
 	if (ret)
-		goto err;
+		return ret;
 
 	ret = snd_soc_of_parse_audio_routing(card, "nvidia,audio-routing");
 	if (ret)
-		goto err;
+		return ret;
 
 	tegra_max98090_dai.codecs->of_node = of_parse_phandle(np,
 			"nvidia,audio-codec", 0);
 	if (!tegra_max98090_dai.codecs->of_node) {
 		dev_err(&pdev->dev,
 			"Property 'nvidia,audio-codec' missing or invalid\n");
-		ret = -EINVAL;
-		goto err;
+		return -EINVAL;
 	}
 
 	tegra_max98090_dai.cpus->of_node = of_parse_phandle(np,
@@ -238,40 +237,31 @@ static int tegra_max98090_probe(struct p
 	if (!tegra_max98090_dai.cpus->of_node) {
 		dev_err(&pdev->dev,
 			"Property 'nvidia,i2s-controller' missing or invalid\n");
-		ret = -EINVAL;
-		goto err;
+		return -EINVAL;
 	}
 
 	tegra_max98090_dai.platforms->of_node = tegra_max98090_dai.cpus->of_node;
 
 	ret = tegra_asoc_utils_init(&machine->util_data, &pdev->dev);
 	if (ret)
-		goto err;
+		return ret;
 
 	ret = snd_soc_register_card(card);
 	if (ret) {
 		dev_err(&pdev->dev, "snd_soc_register_card failed (%d)\n",
 			ret);
-		goto err_fini_utils;
+		return ret;
 	}
 
 	return 0;
-
-err_fini_utils:
-	tegra_asoc_utils_fini(&machine->util_data);
-err:
-	return ret;
 }
 
 static int tegra_max98090_remove(struct platform_device *pdev)
 {
 	struct snd_soc_card *card = platform_get_drvdata(pdev);
-	struct tegra_max98090 *machine = snd_soc_card_get_drvdata(card);
 
 	snd_soc_unregister_card(card);
 
-	tegra_asoc_utils_fini(&machine->util_data);
-
 	return 0;
 }
 
--- a/sound/soc/tegra/tegra_rt5640.c
+++ b/sound/soc/tegra/tegra_rt5640.c
@@ -164,19 +164,18 @@ static int tegra_rt5640_probe(struct pla
 
 	ret = snd_soc_of_parse_card_name(card, "nvidia,model");
 	if (ret)
-		goto err;
+		return ret;
 
 	ret = snd_soc_of_parse_audio_routing(card, "nvidia,audio-routing");
 	if (ret)
-		goto err;
+		return ret;
 
 	tegra_rt5640_dai.codecs->of_node = of_parse_phandle(np,
 			"nvidia,audio-codec", 0);
 	if (!tegra_rt5640_dai.codecs->of_node) {
 		dev_err(&pdev->dev,
 			"Property 'nvidia,audio-codec' missing or invalid\n");
-		ret = -EINVAL;
-		goto err;
+		return -EINVAL;
 	}
 
 	tegra_rt5640_dai.cpus->of_node = of_parse_phandle(np,
@@ -184,40 +183,31 @@ static int tegra_rt5640_probe(struct pla
 	if (!tegra_rt5640_dai.cpus->of_node) {
 		dev_err(&pdev->dev,
 			"Property 'nvidia,i2s-controller' missing or invalid\n");
-		ret = -EINVAL;
-		goto err;
+		return -EINVAL;
 	}
 
 	tegra_rt5640_dai.platforms->of_node = tegra_rt5640_dai.cpus->of_node;
 
 	ret = tegra_asoc_utils_init(&machine->util_data, &pdev->dev);
 	if (ret)
-		goto err;
+		return ret;
 
 	ret = snd_soc_register_card(card);
 	if (ret) {
 		dev_err(&pdev->dev, "snd_soc_register_card failed (%d)\n",
 			ret);
-		goto err_fini_utils;
+		return ret;
 	}
 
 	return 0;
-
-err_fini_utils:
-	tegra_asoc_utils_fini(&machine->util_data);
-err:
-	return ret;
 }
 
 static int tegra_rt5640_remove(struct platform_device *pdev)
 {
 	struct snd_soc_card *card = platform_get_drvdata(pdev);
-	struct tegra_rt5640 *machine = snd_soc_card_get_drvdata(card);
 
 	snd_soc_unregister_card(card);
 
-	tegra_asoc_utils_fini(&machine->util_data);
-
 	return 0;
 }
 
--- a/sound/soc/tegra/tegra_rt5677.c
+++ b/sound/soc/tegra/tegra_rt5677.c
@@ -270,13 +270,11 @@ static int tegra_rt5677_probe(struct pla
 	if (ret) {
 		dev_err(&pdev->dev, "snd_soc_register_card failed (%d)\n",
 			ret);
-		goto err_fini_utils;
+		goto err_put_cpu_of_node;
 	}
 
 	return 0;
 
-err_fini_utils:
-	tegra_asoc_utils_fini(&machine->util_data);
 err_put_cpu_of_node:
 	of_node_put(tegra_rt5677_dai.cpus->of_node);
 	tegra_rt5677_dai.cpus->of_node = NULL;
@@ -291,12 +289,9 @@ err:
 static int tegra_rt5677_remove(struct platform_device *pdev)
 {
 	struct snd_soc_card *card = platform_get_drvdata(pdev);
-	struct tegra_rt5677 *machine = snd_soc_card_get_drvdata(card);
 
 	snd_soc_unregister_card(card);
 
-	tegra_asoc_utils_fini(&machine->util_data);
-
 	tegra_rt5677_dai.platforms->of_node = NULL;
 	of_node_put(tegra_rt5677_dai.codecs->of_node);
 	tegra_rt5677_dai.codecs->of_node = NULL;
--- a/sound/soc/tegra/tegra_sgtl5000.c
+++ b/sound/soc/tegra/tegra_sgtl5000.c
@@ -156,13 +156,11 @@ static int tegra_sgtl5000_driver_probe(s
 	if (ret) {
 		dev_err(&pdev->dev, "snd_soc_register_card failed (%d)\n",
 			ret);
-		goto err_fini_utils;
+		goto err_put_cpu_of_node;
 	}
 
 	return 0;
 
-err_fini_utils:
-	tegra_asoc_utils_fini(&machine->util_data);
 err_put_cpu_of_node:
 	of_node_put(tegra_sgtl5000_dai.cpus->of_node);
 	tegra_sgtl5000_dai.cpus->of_node = NULL;
@@ -177,13 +175,10 @@ err:
 static int tegra_sgtl5000_driver_remove(struct platform_device *pdev)
 {
 	struct snd_soc_card *card = platform_get_drvdata(pdev);
-	struct tegra_sgtl5000 *machine = snd_soc_card_get_drvdata(card);
 	int ret;
 
 	ret = snd_soc_unregister_card(card);
 
-	tegra_asoc_utils_fini(&machine->util_data);
-
 	of_node_put(tegra_sgtl5000_dai.cpus->of_node);
 	tegra_sgtl5000_dai.cpus->of_node = NULL;
 	tegra_sgtl5000_dai.platforms->of_node = NULL;
--- a/sound/soc/tegra/tegra_wm8753.c
+++ b/sound/soc/tegra/tegra_wm8753.c
@@ -127,19 +127,18 @@ static int tegra_wm8753_driver_probe(str
 
 	ret = snd_soc_of_parse_card_name(card, "nvidia,model");
 	if (ret)
-		goto err;
+		return ret;
 
 	ret = snd_soc_of_parse_audio_routing(card, "nvidia,audio-routing");
 	if (ret)
-		goto err;
+		return ret;
 
 	tegra_wm8753_dai.codecs->of_node = of_parse_phandle(np,
 			"nvidia,audio-codec", 0);
 	if (!tegra_wm8753_dai.codecs->of_node) {
 		dev_err(&pdev->dev,
 			"Property 'nvidia,audio-codec' missing or invalid\n");
-		ret = -EINVAL;
-		goto err;
+		return -EINVAL;
 	}
 
 	tegra_wm8753_dai.cpus->of_node = of_parse_phandle(np,
@@ -147,40 +146,31 @@ static int tegra_wm8753_driver_probe(str
 	if (!tegra_wm8753_dai.cpus->of_node) {
 		dev_err(&pdev->dev,
 			"Property 'nvidia,i2s-controller' missing or invalid\n");
-		ret = -EINVAL;
-		goto err;
+		return -EINVAL;
 	}
 
 	tegra_wm8753_dai.platforms->of_node = tegra_wm8753_dai.cpus->of_node;
 
 	ret = tegra_asoc_utils_init(&machine->util_data, &pdev->dev);
 	if (ret)
-		goto err;
+		return ret;
 
 	ret = snd_soc_register_card(card);
 	if (ret) {
 		dev_err(&pdev->dev, "snd_soc_register_card failed (%d)\n",
 			ret);
-		goto err_fini_utils;
+		return ret;
 	}
 
 	return 0;
-
-err_fini_utils:
-	tegra_asoc_utils_fini(&machine->util_data);
-err:
-	return ret;
 }
 
 static int tegra_wm8753_driver_remove(struct platform_device *pdev)
 {
 	struct snd_soc_card *card = platform_get_drvdata(pdev);
-	struct tegra_wm8753 *machine = snd_soc_card_get_drvdata(card);
 
 	snd_soc_unregister_card(card);
 
-	tegra_asoc_utils_fini(&machine->util_data);
-
 	return 0;
 }
 
--- a/sound/soc/tegra/tegra_wm8903.c
+++ b/sound/soc/tegra/tegra_wm8903.c
@@ -323,19 +323,18 @@ static int tegra_wm8903_driver_probe(str
 
 	ret = snd_soc_of_parse_card_name(card, "nvidia,model");
 	if (ret)
-		goto err;
+		return ret;
 
 	ret = snd_soc_of_parse_audio_routing(card, "nvidia,audio-routing");
 	if (ret)
-		goto err;
+		return ret;
 
 	tegra_wm8903_dai.codecs->of_node = of_parse_phandle(np,
 						"nvidia,audio-codec", 0);
 	if (!tegra_wm8903_dai.codecs->of_node) {
 		dev_err(&pdev->dev,
 			"Property 'nvidia,audio-codec' missing or invalid\n");
-		ret = -EINVAL;
-		goto err;
+		return -EINVAL;
 	}
 
 	tegra_wm8903_dai.cpus->of_node = of_parse_phandle(np,
@@ -343,40 +342,31 @@ static int tegra_wm8903_driver_probe(str
 	if (!tegra_wm8903_dai.cpus->of_node) {
 		dev_err(&pdev->dev,
 			"Property 'nvidia,i2s-controller' missing or invalid\n");
-		ret = -EINVAL;
-		goto err;
+		return -EINVAL;
 	}
 
 	tegra_wm8903_dai.platforms->of_node = tegra_wm8903_dai.cpus->of_node;
 
 	ret = tegra_asoc_utils_init(&machine->util_data, &pdev->dev);
 	if (ret)
-		goto err;
+		return ret;
 
 	ret = snd_soc_register_card(card);
 	if (ret) {
 		dev_err(&pdev->dev, "snd_soc_register_card failed (%d)\n",
 			ret);
-		goto err_fini_utils;
+		return ret;
 	}
 
 	return 0;
-
-err_fini_utils:
-	tegra_asoc_utils_fini(&machine->util_data);
-err:
-	return ret;
 }
 
 static int tegra_wm8903_driver_remove(struct platform_device *pdev)
 {
 	struct snd_soc_card *card = platform_get_drvdata(pdev);
-	struct tegra_wm8903 *machine = snd_soc_card_get_drvdata(card);
 
 	snd_soc_unregister_card(card);
 
-	tegra_asoc_utils_fini(&machine->util_data);
-
 	return 0;
 }
 
--- a/sound/soc/tegra/tegra_wm9712.c
+++ b/sound/soc/tegra/tegra_wm9712.c
@@ -113,19 +113,17 @@ static int tegra_wm9712_driver_probe(str
 
 	ret = tegra_asoc_utils_set_ac97_rate(&machine->util_data);
 	if (ret)
-		goto asoc_utils_fini;
+		goto codec_unregister;
 
 	ret = snd_soc_register_card(card);
 	if (ret) {
 		dev_err(&pdev->dev, "snd_soc_register_card failed (%d)\n",
 			ret);
-		goto asoc_utils_fini;
+		goto codec_unregister;
 	}
 
 	return 0;
 
-asoc_utils_fini:
-	tegra_asoc_utils_fini(&machine->util_data);
 codec_unregister:
 	platform_device_del(machine->codec);
 codec_put:
@@ -140,8 +138,6 @@ static int tegra_wm9712_driver_remove(st
 
 	snd_soc_unregister_card(card);
 
-	tegra_asoc_utils_fini(&machine->util_data);
-
 	platform_device_unregister(machine->codec);
 
 	return 0;
--- a/sound/soc/tegra/trimslice.c
+++ b/sound/soc/tegra/trimslice.c
@@ -125,8 +125,7 @@ static int tegra_snd_trimslice_probe(str
 	if (!trimslice_tlv320aic23_dai.codecs->of_node) {
 		dev_err(&pdev->dev,
 			"Property 'nvidia,audio-codec' missing or invalid\n");
-		ret = -EINVAL;
-		goto err;
+		return -EINVAL;
 	}
 
 	trimslice_tlv320aic23_dai.cpus->of_node = of_parse_phandle(np,
@@ -134,8 +133,7 @@ static int tegra_snd_trimslice_probe(str
 	if (!trimslice_tlv320aic23_dai.cpus->of_node) {
 		dev_err(&pdev->dev,
 			"Property 'nvidia,i2s-controller' missing or invalid\n");
-		ret = -EINVAL;
-		goto err;
+		return -EINVAL;
 	}
 
 	trimslice_tlv320aic23_dai.platforms->of_node =
@@ -143,32 +141,24 @@ static int tegra_snd_trimslice_probe(str
 
 	ret = tegra_asoc_utils_init(&trimslice->util_data, &pdev->dev);
 	if (ret)
-		goto err;
+		return ret;
 
 	ret = snd_soc_register_card(card);
 	if (ret) {
 		dev_err(&pdev->dev, "snd_soc_register_card failed (%d)\n",
 			ret);
-		goto err_fini_utils;
+		return ret;
 	}
 
 	return 0;
-
-err_fini_utils:
-	tegra_asoc_utils_fini(&trimslice->util_data);
-err:
-	return ret;
 }
 
 static int tegra_snd_trimslice_remove(struct platform_device *pdev)
 {
 	struct snd_soc_card *card = platform_get_drvdata(pdev);
-	struct tegra_trimslice *trimslice = snd_soc_card_get_drvdata(card);
 
 	snd_soc_unregister_card(card);
 
-	tegra_asoc_utils_fini(&trimslice->util_data);
-
 	return 0;
 }
 


