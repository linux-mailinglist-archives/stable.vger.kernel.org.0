Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4456015F1BA
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:08:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731704AbgBNPzK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 10:55:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:35942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731705AbgBNPzJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:55:09 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F18C222C4;
        Fri, 14 Feb 2020 15:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695708;
        bh=yU3/HvfUjHjQ53JRdVWT8WNLGIo0vYw31AjxgZcgicY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LxuZNm+aCp4dhNpYlapG3vAgYoIvq+k6YJnUCIjdrZYChltsVoSqmXsSmFazLHOIF
         TBPIjE9ay7CBF6nSnZkFxrs1bq+INUPKxQdsfk6CA0JtwXd6TUnYw3oJ+MEXur75D8
         nLwC8dPYXMWKjum0V9Xy3dSJRDrlOex8ReDT+E0c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sam McNally <sammc@chromium.org>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.5 288/542] ASoC: Intel: sof_rt5682: Ignore the speaker amp when there isn't one.
Date:   Fri, 14 Feb 2020 10:44:40 -0500
Message-Id: <20200214154854.6746-288-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index ad8a2b4bc7092..8a13231dee15d 100644
--- a/sound/soc/intel/boards/sof_rt5682.c
+++ b/sound/soc/intel/boards/sof_rt5682.c
@@ -603,6 +603,14 @@ static int sof_audio_probe(struct platform_device *pdev)
 
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
@@ -663,7 +671,6 @@ static int sof_audio_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&ctx->hdmi_pcm_list);
 
 	sof_audio_card_rt5682.dev = &pdev->dev;
-	mach = (&pdev->dev)->platform_data;
 
 	/* set platform name for each dailink */
 	ret = snd_soc_fixup_dai_links_platform_name(&sof_audio_card_rt5682,
-- 
2.20.1

