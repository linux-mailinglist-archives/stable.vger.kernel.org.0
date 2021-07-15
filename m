Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9C293CAB0A
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:14:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243180AbhGOTQf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:16:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:51510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241084AbhGOTPR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:15:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9BA3561158;
        Thu, 15 Jul 2021 19:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626376309;
        bh=jWZGCnsAY9L7zigkpJsKBGOJiuu91rRo/tR1JLcJN4U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1h/AKKBMAEEP1hcUifd68AstLAr5rAjNE0j9LmHRFfhz3cUEkfa7A8be04UYdmiM/
         YLuLvri/jwgW0mXQxEo6HKJjpwjHWXWLE+S4zTkpSgeJOKxCxdxm2zFEK5YXnofQPy
         ckinZe0f83IWvsp9aCh29k+z1k/FX8sXA8dha8nE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Osipenko <digetx@gmail.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.13 217/266] ASoC: tegra: Set driver_name=tegra for all machine drivers
Date:   Thu, 15 Jul 2021 20:39:32 +0200
Message-Id: <20210715182647.815696813@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
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
@@ -139,6 +139,7 @@ static struct snd_soc_dai_link tegra_alc
 
 static struct snd_soc_card snd_soc_tegra_alc5632 = {
 	.name = "tegra-alc5632",
+	.driver_name = "tegra",
 	.owner = THIS_MODULE,
 	.dai_link = &tegra_alc5632_dai,
 	.num_links = 1,
--- a/sound/soc/tegra/tegra_max98090.c
+++ b/sound/soc/tegra/tegra_max98090.c
@@ -182,6 +182,7 @@ static struct snd_soc_dai_link tegra_max
 
 static struct snd_soc_card snd_soc_tegra_max98090 = {
 	.name = "tegra-max98090",
+	.driver_name = "tegra",
 	.owner = THIS_MODULE,
 	.dai_link = &tegra_max98090_dai,
 	.num_links = 1,
--- a/sound/soc/tegra/tegra_rt5640.c
+++ b/sound/soc/tegra/tegra_rt5640.c
@@ -132,6 +132,7 @@ static struct snd_soc_dai_link tegra_rt5
 
 static struct snd_soc_card snd_soc_tegra_rt5640 = {
 	.name = "tegra-rt5640",
+	.driver_name = "tegra",
 	.owner = THIS_MODULE,
 	.dai_link = &tegra_rt5640_dai,
 	.num_links = 1,
--- a/sound/soc/tegra/tegra_rt5677.c
+++ b/sound/soc/tegra/tegra_rt5677.c
@@ -175,6 +175,7 @@ static struct snd_soc_dai_link tegra_rt5
 
 static struct snd_soc_card snd_soc_tegra_rt5677 = {
 	.name = "tegra-rt5677",
+	.driver_name = "tegra",
 	.owner = THIS_MODULE,
 	.dai_link = &tegra_rt5677_dai,
 	.num_links = 1,
--- a/sound/soc/tegra/tegra_sgtl5000.c
+++ b/sound/soc/tegra/tegra_sgtl5000.c
@@ -97,6 +97,7 @@ static struct snd_soc_dai_link tegra_sgt
 
 static struct snd_soc_card snd_soc_tegra_sgtl5000 = {
 	.name = "tegra-sgtl5000",
+	.driver_name = "tegra",
 	.owner = THIS_MODULE,
 	.dai_link = &tegra_sgtl5000_dai,
 	.num_links = 1,
--- a/sound/soc/tegra/tegra_wm8753.c
+++ b/sound/soc/tegra/tegra_wm8753.c
@@ -101,6 +101,7 @@ static struct snd_soc_dai_link tegra_wm8
 
 static struct snd_soc_card snd_soc_tegra_wm8753 = {
 	.name = "tegra-wm8753",
+	.driver_name = "tegra",
 	.owner = THIS_MODULE,
 	.dai_link = &tegra_wm8753_dai,
 	.num_links = 1,
--- a/sound/soc/tegra/tegra_wm8903.c
+++ b/sound/soc/tegra/tegra_wm8903.c
@@ -235,6 +235,7 @@ static struct snd_soc_dai_link tegra_wm8
 
 static struct snd_soc_card snd_soc_tegra_wm8903 = {
 	.name = "tegra-wm8903",
+	.driver_name = "tegra",
 	.owner = THIS_MODULE,
 	.dai_link = &tegra_wm8903_dai,
 	.num_links = 1,
--- a/sound/soc/tegra/tegra_wm9712.c
+++ b/sound/soc/tegra/tegra_wm9712.c
@@ -54,6 +54,7 @@ static struct snd_soc_dai_link tegra_wm9
 
 static struct snd_soc_card snd_soc_tegra_wm9712 = {
 	.name = "tegra-wm9712",
+	.driver_name = "tegra",
 	.owner = THIS_MODULE,
 	.dai_link = &tegra_wm9712_dai,
 	.num_links = 1,
--- a/sound/soc/tegra/trimslice.c
+++ b/sound/soc/tegra/trimslice.c
@@ -94,6 +94,7 @@ static struct snd_soc_dai_link trimslice
 
 static struct snd_soc_card snd_soc_trimslice = {
 	.name = "tegra-trimslice",
+	.driver_name = "tegra",
 	.owner = THIS_MODULE,
 	.dai_link = &trimslice_tlv320aic23_dai,
 	.num_links = 1,


