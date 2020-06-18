Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4131FE333
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728666AbgFRCHQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:07:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:55308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730726AbgFRBWX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:22:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD79320663;
        Thu, 18 Jun 2020 01:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443342;
        bh=bKtEoWS9zdQ5wFJEzPtSoQQn5aiecDm3/KpROiRLkEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sTVaZjnnaDH8Z5PZhxtik+ptCPCynEVgvEjTvR077hIYM4DEaWl2pEk/LfjmJR5Hc
         OI/lgH4STErGb7ftlgvp1Tt7ci3AJTfHcOMbNNJmosE5iZxFMfWdTMpjf3BrZzKoIB
         9dn1qPJWE7zVlDLIlofrDqt7u95zzMjCzHgvza2k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Osipenko <digetx@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 003/172] ASoC: tegra: tegra_wm8903: Support nvidia, headset property
Date:   Wed, 17 Jun 2020 21:19:29 -0400
Message-Id: <20200618012218.607130-3-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618012218.607130-1-sashal@kernel.org>
References: <20200618012218.607130-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

[ Upstream commit 3ef9d5073b552d56bd6daf2af1e89b7e8d4df183 ]

The microphone-jack state needs to be masked in a case of a 4-pin jack
when microphone and ground pins are shorted. Presence of nvidia,headset
tells that WM8903 CODEC driver should mask microphone's status if short
circuit is detected, i.e headphones are inserted.

Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Link: https://lore.kernel.org/r/20200330204011.18465-3-digetx@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/tegra/tegra_wm8903.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/sound/soc/tegra/tegra_wm8903.c b/sound/soc/tegra/tegra_wm8903.c
index 69bc9461974b..301850df368d 100644
--- a/sound/soc/tegra/tegra_wm8903.c
+++ b/sound/soc/tegra/tegra_wm8903.c
@@ -173,6 +173,7 @@ static int tegra_wm8903_init(struct snd_soc_pcm_runtime *rtd)
 	struct snd_soc_component *component = codec_dai->component;
 	struct snd_soc_card *card = rtd->card;
 	struct tegra_wm8903 *machine = snd_soc_card_get_drvdata(card);
+	int shrt = 0;
 
 	if (gpio_is_valid(machine->gpio_hp_det)) {
 		tegra_wm8903_hp_jack_gpio.gpio = machine->gpio_hp_det;
@@ -185,12 +186,15 @@ static int tegra_wm8903_init(struct snd_soc_pcm_runtime *rtd)
 					&tegra_wm8903_hp_jack_gpio);
 	}
 
+	if (of_property_read_bool(card->dev->of_node, "nvidia,headset"))
+		shrt = SND_JACK_MICROPHONE;
+
 	snd_soc_card_jack_new(rtd->card, "Mic Jack", SND_JACK_MICROPHONE,
 			      &tegra_wm8903_mic_jack,
 			      tegra_wm8903_mic_jack_pins,
 			      ARRAY_SIZE(tegra_wm8903_mic_jack_pins));
 	wm8903_mic_detect(component, &tegra_wm8903_mic_jack, SND_JACK_MICROPHONE,
-				0);
+				shrt);
 
 	snd_soc_dapm_force_enable_pin(&card->dapm, "MICBIAS");
 
-- 
2.25.1

