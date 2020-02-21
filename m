Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C493316732B
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:09:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732428AbgBUIJv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:09:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:44838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732421AbgBUIJt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:09:49 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9621820722;
        Fri, 21 Feb 2020 08:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272588;
        bh=AIbo4S4usFiwy+n5RgPSDhWrfMvr5ydKo17MWKxWy40=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TszAWlqD2w4M+IL4FF+OIsTuipbCwp5eHMf2zNKPqyUEHaQhoqfPW9w4jX3l5zH2S
         TFG5FUrAp0Sn5+ro4yWVsRxilu0RI+EvhG+TydTieuD/xb7Q3qJpMHqYsGcR+izsOF
         jTE3htNrGn8v6LkgWPnrvSXLpfumRm/eCA8wPu20=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sam McNally <sammc@chromium.org>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 182/344] ASoC: Intel: sof_rt5682: Ignore the speaker amp when there isnt one.
Date:   Fri, 21 Feb 2020 08:39:41 +0100
Message-Id: <20200221072405.553800639@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sam McNally <sammc@chromium.org>

[ Upstream commit d4b74e218a8d0d6cf58e546627ab9d4d4f2645ab ]

Some members of the Google_Hatch family include a rt5682 jack codec, but
no speaker amplifier. This uses the same driver (sof_rt5682) as a
combination of rt5682 jack codec and max98357a speaker amplifier. Within
the sof_rt5682 driver, these cases are not currently distinguishable,
relying on a DMI quirk to decide the configuration. This causes an
incorrect configuration when only the rt5682 is present on a
Google_Hatch device.

For CML, the jack codec is used as the primary key when matching,
with a possible speaker amplifier described in quirk_data. The two cases
of interest are the second and third 10EC5682 entries in
snd_soc_acpi_intel_cml_machines[]. The second entry matches the
combination of rt5682 and max98357a, resulting in the quirk_data field
in the snd_soc_acpi_mach being non-null, pointing at
max98357a_spk_codecs, the snd_soc_acpi_codecs for the matched speaker
amplifier. The third entry matches just the rt5682, resulting in a null
quirk_data.

The sof_rt5682 driver's DMI data matching identifies that a speaker
amplifier is present for all Google_Hatch family devices. Detect cases
where there is no speaker amplifier by checking for a null quirk_data in
the snd_soc_acpi_mach and remove the speaker amplifier bit in that case.

Signed-off-by: Sam McNally <sammc@chromium.org>
Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20200103124921.v3.1.Ib87c4a7fbb3fc818ea12198e291b87dc2d5bc8c2@changeid
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_rt5682.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/sound/soc/intel/boards/sof_rt5682.c b/sound/soc/intel/boards/sof_rt5682.c
index 9441ddfeea5e6..06b7d6c6c9a04 100644
--- a/sound/soc/intel/boards/sof_rt5682.c
+++ b/sound/soc/intel/boards/sof_rt5682.c
@@ -594,6 +594,14 @@ static int sof_audio_probe(struct platform_device *pdev)
 
 	dmi_check_system(sof_rt5682_quirk_table);
 
+	mach = (&pdev->dev)->platform_data;
+
+	/* A speaker amp might not be present when the quirk claims one is.
+	 * Detect this via whether the machine driver match includes quirk_data.
+	 */
+	if ((sof_rt5682_quirk & SOF_SPEAKER_AMP_PRESENT) && !mach->quirk_data)
+		sof_rt5682_quirk &= ~SOF_SPEAKER_AMP_PRESENT;
+
 	if (soc_intel_is_byt() || soc_intel_is_cht()) {
 		is_legacy_cpu = 1;
 		dmic_be_num = 0;
@@ -654,7 +662,6 @@ static int sof_audio_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&ctx->hdmi_pcm_list);
 
 	sof_audio_card_rt5682.dev = &pdev->dev;
-	mach = (&pdev->dev)->platform_data;
 
 	/* set platform name for each dailink */
 	ret = snd_soc_fixup_dai_links_platform_name(&sof_audio_card_rt5682,
-- 
2.20.1



