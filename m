Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D3974800DF
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:51:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239808AbhL0PvU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:51:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239369AbhL0Prx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:47:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A5DCC08EAE5;
        Mon, 27 Dec 2021 07:43:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9EC4061129;
        Mon, 27 Dec 2021 15:43:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52383C36AED;
        Mon, 27 Dec 2021 15:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619805;
        bh=fehFBwRaiCDExcI1epPDjRsquAeukoM1yaQTS23usnU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0g2CAg5vu7a0mVfiNCgHBFykMGYfvba6MVr9JeyvZA6jIEJ+VxuQ8nFZFg7bMD7kC
         hwDopihwYbU/i0EEz/NKwiszkFotrm7FRSs1eN/LkCA5sIzRBwWO3iiEqVVLnS/aTq
         QvfsZeDJjFpipclSGbU2AbQNya/O5wEFpbtz6RaI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Osipenko <digetx@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Thomas Graichen <thomas.graichen@gmail.com>
Subject: [PATCH 5.15 075/128] ASoC: tegra: Restore headphones jack name on Nyan Big
Date:   Mon, 27 Dec 2021 16:30:50 +0100
Message-Id: <20211227151334.010031755@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
References: <20211227151331.502501367@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

commit db635ba4fadf3ba676d07537f3b3f58166aa7b0e upstream.

UCM of Acer Chromebook (Nyan) uses a different name for the headphones
jack. The name was changed during unification of the machine drivers and
UCM fails now to load because of that. Restore the old jack name.

Cc: <stable@vger.kernel.org>
Fixes: cc8f70f ("ASoC: tegra: Unify ASoC machine drivers")
Reported-by: Thomas Graichen <thomas.graichen@gmail.com> # T124 Nyan Big
Tested-by: Thomas Graichen <thomas.graichen@gmail.com> # T124 Nyan Big
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Link: https://lore.kernel.org/r/20211211231146.6137-2-digetx@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/tegra/tegra_asoc_machine.c |    9 ++++++++-
 sound/soc/tegra/tegra_asoc_machine.h |    1 +
 2 files changed, 9 insertions(+), 1 deletion(-)

--- a/sound/soc/tegra/tegra_asoc_machine.c
+++ b/sound/soc/tegra/tegra_asoc_machine.c
@@ -124,10 +124,16 @@ int tegra_asoc_machine_init(struct snd_s
 {
 	struct snd_soc_card *card = rtd->card;
 	struct tegra_machine *machine = snd_soc_card_get_drvdata(card);
+	const char *jack_name;
 	int err;
 
 	if (machine->gpiod_hp_det && machine->asoc->add_hp_jack) {
-		err = snd_soc_card_jack_new(card, "Headphones Jack",
+		if (machine->asoc->hp_jack_name)
+			jack_name = machine->asoc->hp_jack_name;
+		else
+			jack_name = "Headphones Jack";
+
+		err = snd_soc_card_jack_new(card, jack_name,
 					    SND_JACK_HEADPHONE,
 					    &tegra_machine_hp_jack,
 					    tegra_machine_hp_jack_pins,
@@ -660,6 +666,7 @@ static struct snd_soc_card snd_soc_tegra
 static const struct tegra_asoc_data tegra_max98090_data = {
 	.mclk_rate = tegra_machine_mclk_rate_12mhz,
 	.card = &snd_soc_tegra_max98090,
+	.hp_jack_name = "Headphones",
 	.add_common_dapm_widgets = true,
 	.add_common_controls = true,
 	.add_common_snd_ops = true,
--- a/sound/soc/tegra/tegra_asoc_machine.h
+++ b/sound/soc/tegra/tegra_asoc_machine.h
@@ -14,6 +14,7 @@ struct snd_soc_pcm_runtime;
 struct tegra_asoc_data {
 	unsigned int (*mclk_rate)(unsigned int srate);
 	const char *codec_dev_name;
+	const char *hp_jack_name;
 	struct snd_soc_card *card;
 	unsigned int mclk_id;
 	bool hp_jack_gpio_active_low;


