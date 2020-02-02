Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 713D714FD05
	for <lists+stable@lfdr.de>; Sun,  2 Feb 2020 13:09:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbgBBMJD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Feb 2020 07:09:03 -0500
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:42780 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbgBBMJC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 Feb 2020 07:09:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=Date:Message-Id:In-Reply-To:
        Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:References:
        List-Id:List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:
        List-Archive; bh=SaO73ONbQdM0mbDqkJQ7S6ALPlHo+RxgSer8+54eNsc=; b=Hu2Oc6hNzvU7
        ro9DWvxU/LISS94/NYcDE1XLEoS7lVb03Zwrhe/L6shup+YQy56QjZC1A44osRcxpJW/+36KFoRDA
        ymrY/exov98SejEk6watqG9oRt8VpQcqGejFJsdt7Tc/hQE5oM+wRWd0uGORsRCSwp/YQ7qg8RrY1
        qWRF8=;
Received: from [151.216.144.116] (helo=fitzroy.sirena.org.uk)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <broonie@sirena.org.uk>)
        id 1iyE3W-0006sp-J5; Sun, 02 Feb 2020 12:08:50 +0000
Received: by fitzroy.sirena.org.uk (Postfix, from userid 1000)
        id 7B482D00C8C; Sun,  2 Feb 2020 12:08:49 +0000 (GMT)
From:   Mark Brown <broonie@kernel.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     alsa-devel@alsa-project.org, Ben Dooks <ben.dooks@codethink.co.uk>,
        Dmitry Osipenko <digetx@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        Mark Brown <broonie@kernel.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.com>,
        Thierry Reding <thierry.reding@gmail.com>
Subject: Applied "ASoC: tegra: Revert 24 and 32 bit support" to the asoc tree
In-Reply-To:  <20200131091901.13014-1-jonathanh@nvidia.com>
Message-Id:  <applied-20200131091901.13014-1-jonathanh@nvidia.com>
X-Patchwork-Hint: ignore
Date:   Sun,  2 Feb 2020 12:08:49 +0000 (GMT)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch

   ASoC: tegra: Revert 24 and 32 bit support

has been applied to the asoc tree at

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git 

All being well this means that it will be integrated into the linux-next
tree (usually sometime in the next 24 hours) and sent to Linus during
the next merge window (or sooner if it is a bug fix), however if
problems are discovered then the patch may be dropped or reverted.  

You may get further e-mails resulting from automated or manual testing
and review of the tree, please engage with people reporting problems and
send followup patches addressing any issues that are reported if needed.

If any updates are required or you are submitting further changes they
should be sent as incremental updates against current git, existing
patches will not be replaced.

Please add any relevant lists and maintainers to the CCs when replying
to this mail.

Thanks,
Mark

From 961b91a93ea27495022b2bdc3ca0f608f2c97b5f Mon Sep 17 00:00:00 2001
From: Jon Hunter <jonathanh@nvidia.com>
Date: Fri, 31 Jan 2020 09:19:01 +0000
Subject: [PATCH] ASoC: tegra: Revert 24 and 32 bit support

Commit f3ee99087c8ca0ecfdd549ef5a94f557c42d5428 ("ASoC: tegra: Allow
24bit and 32bit samples") added 24-bit and 32-bit support for to the
Tegra30 I2S driver. However, there are two additional commits that are
also needed to get 24-bit and 32-bit support to work correctly. These
commits are not yet applied because there are still some review comments
that need to be addressed. With only this change applied, 24-bit and
32-bit support is advertised by the I2S driver, but it does not work and
the audio is distorted. Therefore, revert this patch for now until the
other changes are also ready.

Furthermore, a clock issue with 24-bit support has been identified with
this change and so if we revert this now, we can also fix that in the
updated version.

Reported-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Tested-by: Dmitry Osipenko <digetx@gmail.com>
Link: https://lore.kernel.org/r/20200131091901.13014-1-jonathanh@nvidia.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org
---
 sound/soc/tegra/tegra30_i2s.c | 25 +++++--------------------
 1 file changed, 5 insertions(+), 20 deletions(-)

diff --git a/sound/soc/tegra/tegra30_i2s.c b/sound/soc/tegra/tegra30_i2s.c
index dbed3c5408e7..d59882ec48f1 100644
--- a/sound/soc/tegra/tegra30_i2s.c
+++ b/sound/soc/tegra/tegra30_i2s.c
@@ -127,7 +127,7 @@ static int tegra30_i2s_hw_params(struct snd_pcm_substream *substream,
 	struct device *dev = dai->dev;
 	struct tegra30_i2s *i2s = snd_soc_dai_get_drvdata(dai);
 	unsigned int mask, val, reg;
-	int ret, sample_size, srate, i2sclock, bitcnt, audio_bits;
+	int ret, sample_size, srate, i2sclock, bitcnt;
 	struct tegra30_ahub_cif_conf cif_conf;
 
 	if (params_channels(params) != 2)
@@ -137,19 +137,8 @@ static int tegra30_i2s_hw_params(struct snd_pcm_substream *substream,
 	switch (params_format(params)) {
 	case SNDRV_PCM_FORMAT_S16_LE:
 		val = TEGRA30_I2S_CTRL_BIT_SIZE_16;
-		audio_bits = TEGRA30_AUDIOCIF_BITS_16;
 		sample_size = 16;
 		break;
-	case SNDRV_PCM_FORMAT_S24_LE:
-		val = TEGRA30_I2S_CTRL_BIT_SIZE_24;
-		audio_bits = TEGRA30_AUDIOCIF_BITS_24;
-		sample_size = 24;
-		break;
-	case SNDRV_PCM_FORMAT_S32_LE:
-		val = TEGRA30_I2S_CTRL_BIT_SIZE_32;
-		audio_bits = TEGRA30_AUDIOCIF_BITS_32;
-		sample_size = 32;
-		break;
 	default:
 		return -EINVAL;
 	}
@@ -181,8 +170,8 @@ static int tegra30_i2s_hw_params(struct snd_pcm_substream *substream,
 	cif_conf.threshold = 0;
 	cif_conf.audio_channels = 2;
 	cif_conf.client_channels = 2;
-	cif_conf.audio_bits = audio_bits;
-	cif_conf.client_bits = audio_bits;
+	cif_conf.audio_bits = TEGRA30_AUDIOCIF_BITS_16;
+	cif_conf.client_bits = TEGRA30_AUDIOCIF_BITS_16;
 	cif_conf.expand = 0;
 	cif_conf.stereo_conv = 0;
 	cif_conf.replicate = 0;
@@ -317,18 +306,14 @@ static const struct snd_soc_dai_driver tegra30_i2s_dai_template = {
 		.channels_min = 2,
 		.channels_max = 2,
 		.rates = SNDRV_PCM_RATE_8000_96000,
-		.formats = SNDRV_PCM_FMTBIT_S32_LE |
-			   SNDRV_PCM_FMTBIT_S24_LE |
-			   SNDRV_PCM_FMTBIT_S16_LE,
+		.formats = SNDRV_PCM_FMTBIT_S16_LE,
 	},
 	.capture = {
 		.stream_name = "Capture",
 		.channels_min = 2,
 		.channels_max = 2,
 		.rates = SNDRV_PCM_RATE_8000_96000,
-		.formats = SNDRV_PCM_FMTBIT_S32_LE |
-			   SNDRV_PCM_FMTBIT_S24_LE |
-			   SNDRV_PCM_FMTBIT_S16_LE,
+		.formats = SNDRV_PCM_FMTBIT_S16_LE,
 	},
 	.ops = &tegra30_i2s_dai_ops,
 	.symmetric_rates = 1,
-- 
2.20.1

