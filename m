Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 625EC1CAFBC
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728866AbgEHNTl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:19:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:36956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728840AbgEHMlh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:41:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D96921835;
        Fri,  8 May 2020 12:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941697;
        bh=OuenHsL91OyfoabZnQQPLI6StpAl5FR2BmeWRvv+hB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SBpIA06KRjOvQjxZJcfHU/vzEWRfmc/DuGkbpsJy4y2f6KJ9WusWptZFW30ZYUZTk
         BKTrNyPX9Kq8i8MhrwOSlsuTw5RvqDSTnQi49FlXnvVNIJaO87BsSqaLTqBCgZI3ge
         3PmPzNd/Ac52nykY/LpaxTOxOJ9EW/i1pF5x9pYU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sudip Mukherjee <sudip@vectorindia.org>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.4 135/312] ASoC: tegra_alc5632: check return value
Date:   Fri,  8 May 2020 14:32:06 +0200
Message-Id: <20200508123133.995845962@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>

commit 319c32597fc22a58b946a6146f2be1fd208582e0 upstream.

We have been returning success even if snd_soc_card_jack_new() fails.
Lets check the return value and return error if it fails.

Fixes: 12cc6d1dca4d ("ASoC: tegra_alc5632: Register jacks at the card level")
Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/tegra/tegra_alc5632.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/sound/soc/tegra/tegra_alc5632.c
+++ b/sound/soc/tegra/tegra_alc5632.c
@@ -101,12 +101,16 @@ static const struct snd_kcontrol_new teg
 
 static int tegra_alc5632_asoc_init(struct snd_soc_pcm_runtime *rtd)
 {
+	int ret;
 	struct tegra_alc5632 *machine = snd_soc_card_get_drvdata(rtd->card);
 
-	snd_soc_card_jack_new(rtd->card, "Headset Jack", SND_JACK_HEADSET,
-			      &tegra_alc5632_hs_jack,
-			      tegra_alc5632_hs_jack_pins,
-			      ARRAY_SIZE(tegra_alc5632_hs_jack_pins));
+	ret = snd_soc_card_jack_new(rtd->card, "Headset Jack",
+				    SND_JACK_HEADSET,
+				    &tegra_alc5632_hs_jack,
+				    tegra_alc5632_hs_jack_pins,
+				    ARRAY_SIZE(tegra_alc5632_hs_jack_pins));
+	if (ret)
+		return ret;
 
 	if (gpio_is_valid(machine->gpio_hp_det)) {
 		tegra_alc5632_hp_jack_gpio.gpio = machine->gpio_hp_det;


