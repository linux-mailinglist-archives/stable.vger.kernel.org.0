Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9C563CD9EA
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244038AbhGSOcF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:32:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:45544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244890AbhGSOaH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:30:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0DAD860551;
        Mon, 19 Jul 2021 15:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707446;
        bh=nwTaF573mhMv+FHGykxD2glN9ZKKvMHnRloQgzmAbe4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RsA0yPoRxe0o09pgsU4ut3ihqdn5bFX2olI/D2LR3TH/cggDX5ccFF3h+1ha3nsJU
         ByK2vN014dJDuEzSDR8y4xvSFPyt3MnEVh56K8WjsVILqtfmycqPO98wijss88Phzn
         keYUJVGchjyMCK1Ww5UnKKXHGWLyUB2lIyWPn0W8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Osipenko <digetx@gmail.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.9 166/245] ASoC: tegra: Set driver_name=tegra for all machine drivers
Date:   Mon, 19 Jul 2021 16:51:48 +0200
Message-Id: <20210719144945.775906001@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.288257948@linuxfoundation.org>
References: <20210719144940.288257948@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

commit f6eb84fa596abf28959fc7e0b626f925eb1196c7 upstream.

The driver_name="tegra" is now required by the newer ALSA UCMs, otherwise
Tegra UCMs don't match by the path/name.

All Tegra machine drivers are specifying the card's name, but it has no
effect if model name is specified in the device-tree since it overrides
the card's name. We need to set the driver_name to "tegra" in order to
get a usable lookup path for the updated ALSA UCMs. The new UCM lookup
path has a form of driver_name/card_name.

The old lookup paths that are based on driver module name continue to
work as before. Note that UCM matching never worked for Tegra ASoC drivers
if they were compiled as built-in, this is fixed by supporting the new
naming scheme.

Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Link: https://lore.kernel.org/r/20210529154649.25936-2-digetx@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/tegra/tegra_alc5632.c  |    1 +
 sound/soc/tegra/tegra_max98090.c |    1 +
 sound/soc/tegra/tegra_rt5640.c   |    1 +
 sound/soc/tegra/tegra_rt5677.c   |    1 +
 sound/soc/tegra/tegra_sgtl5000.c |    1 +
 sound/soc/tegra/tegra_wm8753.c   |    1 +
 sound/soc/tegra/tegra_wm8903.c   |    1 +
 sound/soc/tegra/tegra_wm9712.c   |    1 +
 sound/soc/tegra/trimslice.c      |    1 +
 9 files changed, 9 insertions(+)

--- a/sound/soc/tegra/tegra_alc5632.c
+++ b/sound/soc/tegra/tegra_alc5632.c
@@ -149,6 +149,7 @@ static struct snd_soc_dai_link tegra_alc
 
 static struct snd_soc_card snd_soc_tegra_alc5632 = {
 	.name = "tegra-alc5632",
+	.driver_name = "tegra",
 	.owner = THIS_MODULE,
 	.remove = tegra_alc5632_card_remove,
 	.dai_link = &tegra_alc5632_dai,
--- a/sound/soc/tegra/tegra_max98090.c
+++ b/sound/soc/tegra/tegra_max98090.c
@@ -205,6 +205,7 @@ static struct snd_soc_dai_link tegra_max
 
 static struct snd_soc_card snd_soc_tegra_max98090 = {
 	.name = "tegra-max98090",
+	.driver_name = "tegra",
 	.owner = THIS_MODULE,
 	.remove = tegra_max98090_card_remove,
 	.dai_link = &tegra_max98090_dai,
--- a/sound/soc/tegra/tegra_rt5640.c
+++ b/sound/soc/tegra/tegra_rt5640.c
@@ -150,6 +150,7 @@ static struct snd_soc_dai_link tegra_rt5
 
 static struct snd_soc_card snd_soc_tegra_rt5640 = {
 	.name = "tegra-rt5640",
+	.driver_name = "tegra",
 	.owner = THIS_MODULE,
 	.remove = tegra_rt5640_card_remove,
 	.dai_link = &tegra_rt5640_dai,
--- a/sound/soc/tegra/tegra_rt5677.c
+++ b/sound/soc/tegra/tegra_rt5677.c
@@ -198,6 +198,7 @@ static struct snd_soc_dai_link tegra_rt5
 
 static struct snd_soc_card snd_soc_tegra_rt5677 = {
 	.name = "tegra-rt5677",
+	.driver_name = "tegra",
 	.owner = THIS_MODULE,
 	.remove = tegra_rt5677_card_remove,
 	.dai_link = &tegra_rt5677_dai,
--- a/sound/soc/tegra/tegra_sgtl5000.c
+++ b/sound/soc/tegra/tegra_sgtl5000.c
@@ -103,6 +103,7 @@ static struct snd_soc_dai_link tegra_sgt
 
 static struct snd_soc_card snd_soc_tegra_sgtl5000 = {
 	.name = "tegra-sgtl5000",
+	.driver_name = "tegra",
 	.owner = THIS_MODULE,
 	.dai_link = &tegra_sgtl5000_dai,
 	.num_links = 1,
--- a/sound/soc/tegra/tegra_wm8753.c
+++ b/sound/soc/tegra/tegra_wm8753.c
@@ -110,6 +110,7 @@ static struct snd_soc_dai_link tegra_wm8
 
 static struct snd_soc_card snd_soc_tegra_wm8753 = {
 	.name = "tegra-wm8753",
+	.driver_name = "tegra",
 	.owner = THIS_MODULE,
 	.dai_link = &tegra_wm8753_dai,
 	.num_links = 1,
--- a/sound/soc/tegra/tegra_wm8903.c
+++ b/sound/soc/tegra/tegra_wm8903.c
@@ -228,6 +228,7 @@ static struct snd_soc_dai_link tegra_wm8
 
 static struct snd_soc_card snd_soc_tegra_wm8903 = {
 	.name = "tegra-wm8903",
+	.driver_name = "tegra",
 	.owner = THIS_MODULE,
 	.dai_link = &tegra_wm8903_dai,
 	.num_links = 1,
--- a/sound/soc/tegra/tegra_wm9712.c
+++ b/sound/soc/tegra/tegra_wm9712.c
@@ -59,6 +59,7 @@ static struct snd_soc_dai_link tegra_wm9
 
 static struct snd_soc_card snd_soc_tegra_wm9712 = {
 	.name = "tegra-wm9712",
+	.driver_name = "tegra",
 	.owner = THIS_MODULE,
 	.dai_link = &tegra_wm9712_dai,
 	.num_links = 1,
--- a/sound/soc/tegra/trimslice.c
+++ b/sound/soc/tegra/trimslice.c
@@ -103,6 +103,7 @@ static struct snd_soc_dai_link trimslice
 
 static struct snd_soc_card snd_soc_trimslice = {
 	.name = "tegra-trimslice",
+	.driver_name = "tegra",
 	.owner = THIS_MODULE,
 	.dai_link = &trimslice_tlv320aic23_dai,
 	.num_links = 1,


