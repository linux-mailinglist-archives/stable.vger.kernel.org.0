Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A215F404EAC
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241522AbhIIMNT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:13:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:48310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240866AbhIIMLH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:11:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A981D611EF;
        Thu,  9 Sep 2021 11:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188109;
        bh=i06AM4DVmRVPJBNARjGrF5thGGhhF9wFivOaNz4+sWI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d7KBhoO2Ll0SRI9uqZzHMorBI+3aemWPNuPSJEjQgoyx9ZpM23zSLwK5jPC2imORh
         RqOWgyJVodENQsimjJeKuWSiRRY5T1gxW/3wEmQMlyf0X9Z5sNu2qojIMLONz9kRu/
         ysIGGSeoh82caWLFCYlxbwgo5HEC3JzJ/Z8ppaMmwtYzrRchxCaVVTaMPeJTCK8niA
         pKrraEWlVlenSNKdKifL9IH78CZkdUQs5x+tGbWgV8BQyBAwxZd/FuMFMfvKeTFfTK
         EvuI7bsuBudKW1M3mUvYXNOmZ4p+ddhMDZGuf6L179GuBBROxGjb5HAvuJ20t4nXAr
         Q5gDjAfI8Bt8g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.13 088/219] ASoC: Intel: update sof_pcm512x quirks
Date:   Thu,  9 Sep 2021 07:44:24 -0400
Message-Id: <20210909114635.143983-88-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 22414cade8dfec25ab94df52b3a4f7aa8edb6120 ]

The default SOF topology enables SSP capture and DMICs, even though
both of these hardware capabilities are not always available in
hardware (specific versions of HiFiberry and DMIC kit needed).

For the SSP capture, this leads to annoying "SP5-Codec: ASoC: no
backend capture" and "streamSSP5-Codec: ASoC: no users capture at
close - state 0" errors.

Update the quirks to match what the topology needs, which also allows
for the ability to remove SSP capture and DMIC support.

BugLink: https://github.com/thesofproject/linux/issues/3061
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
Link: https://lore.kernel.org/r/20210802152151.15832-4-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_pcm512x.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/sound/soc/intel/boards/sof_pcm512x.c b/sound/soc/intel/boards/sof_pcm512x.c
index 8620d4f38493..335c212c1961 100644
--- a/sound/soc/intel/boards/sof_pcm512x.c
+++ b/sound/soc/intel/boards/sof_pcm512x.c
@@ -26,11 +26,16 @@
 
 #define SOF_PCM512X_SSP_CODEC(quirk)		((quirk) & GENMASK(3, 0))
 #define SOF_PCM512X_SSP_CODEC_MASK			(GENMASK(3, 0))
+#define SOF_PCM512X_ENABLE_SSP_CAPTURE		BIT(4)
+#define SOF_PCM512X_ENABLE_DMIC			BIT(5)
 
 #define IDISP_CODEC_MASK	0x4
 
 /* Default: SSP5 */
-static unsigned long sof_pcm512x_quirk = SOF_PCM512X_SSP_CODEC(5);
+static unsigned long sof_pcm512x_quirk =
+	SOF_PCM512X_SSP_CODEC(5) |
+	SOF_PCM512X_ENABLE_SSP_CAPTURE |
+	SOF_PCM512X_ENABLE_DMIC;
 
 static bool is_legacy_cpu;
 
@@ -245,8 +250,9 @@ static struct snd_soc_dai_link *sof_card_dai_links_create(struct device *dev,
 	links[id].dpcm_playback = 1;
 	/*
 	 * capture only supported with specific versions of the Hifiberry DAC+
-	 * links[id].dpcm_capture = 1;
 	 */
+	if (sof_pcm512x_quirk & SOF_PCM512X_ENABLE_SSP_CAPTURE)
+		links[id].dpcm_capture = 1;
 	links[id].no_pcm = 1;
 	links[id].cpus = &cpus[id];
 	links[id].num_cpus = 1;
@@ -381,6 +387,9 @@ static int sof_audio_probe(struct platform_device *pdev)
 
 	ssp_codec = sof_pcm512x_quirk & SOF_PCM512X_SSP_CODEC_MASK;
 
+	if (!(sof_pcm512x_quirk & SOF_PCM512X_ENABLE_DMIC))
+		dmic_be_num = 0;
+
 	/* compute number of dai links */
 	sof_audio_card_pcm512x.num_links = 1 + dmic_be_num + hdmi_num;
 
-- 
2.30.2

