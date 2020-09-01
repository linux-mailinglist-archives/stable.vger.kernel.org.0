Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F8E625942B
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731273AbgIAPg1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:36:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:43172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728789AbgIAPgT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:36:19 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF39120E65;
        Tue,  1 Sep 2020 15:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974579;
        bh=W6/sS81Kud92Hldw3CjLGtIZQq/opZIQfLxRti9amqo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G4LYO57u8LW01gEddAamsOQJI4aMF36c4K1q3XCvQxgC85swRKE8KKCfDr9zKm7Tq
         NJBy9hoMkgx9fHZsd6xP1YakZKeyloTE76wLyx8fMmAjv9E6BKZmdAMiMD7MMuJhLI
         zIohxc6G7qejC+A+kpmxuN4htSH4DZoNlFACogfI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Rander Wang <rander.wang@linux.intel.com>,
        Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 002/255] ASoC: intel/skl/hda - fix probe regression on systems without i915
Date:   Tue,  1 Sep 2020 17:07:38 +0200
Message-Id: <20200901151000.926387143@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai Vehmanen <kai.vehmanen@linux.intel.com>

[ Upstream commit ffc6d45d96f07a32700cb6b7be2d3459e63c255a ]

Starting in commit cbc7a6b5a87a ("ASoC: soc-card: add
snd_soc_card_add_dai_link()"), error value from ASoc add_dai_link() is
no longer ignored.

The generic HDA machine driver relied on the old semantics to disable
i915 HDMI/DP audio codec at runtime. If no display codec was present,
add_dai_link() returned an error, but this was ignored and rest of the
card was successfully probed.

Fix the problem by changing the machine driver add_dai_link() to not
return an error in this case.

Fixes: cbc7a6b5a87a ("ASoC: soc-card: add snd_soc_card_add_dai_link()")
Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@linux.intel.com>
Reviewed-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
BugLink: https://github.com/thesofproject/linux/issues/2261
Link: https://lore.kernel.org/r/20200714132804.3638221-1-kai.vehmanen@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/skl_hda_dsp_common.h  |  1 +
 sound/soc/intel/boards/skl_hda_dsp_generic.c | 17 +++++++++++------
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/sound/soc/intel/boards/skl_hda_dsp_common.h b/sound/soc/intel/boards/skl_hda_dsp_common.h
index 507750ef67f30..4b0b3959182e5 100644
--- a/sound/soc/intel/boards/skl_hda_dsp_common.h
+++ b/sound/soc/intel/boards/skl_hda_dsp_common.h
@@ -33,6 +33,7 @@ struct skl_hda_private {
 	int dai_index;
 	const char *platform_name;
 	bool common_hdmi_codec_drv;
+	bool idisp_codec;
 };
 
 extern struct snd_soc_dai_link skl_hda_be_dai_links[HDA_DSP_MAX_BE_DAI_LINKS];
diff --git a/sound/soc/intel/boards/skl_hda_dsp_generic.c b/sound/soc/intel/boards/skl_hda_dsp_generic.c
index 79c8947f840b9..ca4900036ead9 100644
--- a/sound/soc/intel/boards/skl_hda_dsp_generic.c
+++ b/sound/soc/intel/boards/skl_hda_dsp_generic.c
@@ -79,6 +79,9 @@ skl_hda_add_dai_link(struct snd_soc_card *card, struct snd_soc_dai_link *link)
 	link->platforms->name = ctx->platform_name;
 	link->nonatomic = 1;
 
+	if (!ctx->idisp_codec)
+		return 0;
+
 	if (strstr(link->name, "HDMI")) {
 		ret = skl_hda_hdmi_add_pcm(card, ctx->pcm_count);
 
@@ -118,19 +121,20 @@ static char hda_soc_components[30];
 static int skl_hda_fill_card_info(struct snd_soc_acpi_mach_params *mach_params)
 {
 	struct snd_soc_card *card = &hda_soc_card;
+	struct skl_hda_private *ctx = snd_soc_card_get_drvdata(card);
 	struct snd_soc_dai_link *dai_link;
-	u32 codec_count, codec_mask, idisp_mask;
+	u32 codec_count, codec_mask;
 	int i, num_links, num_route;
 
 	codec_mask = mach_params->codec_mask;
 	codec_count = hweight_long(codec_mask);
-	idisp_mask = codec_mask & IDISP_CODEC_MASK;
+	ctx->idisp_codec = !!(codec_mask & IDISP_CODEC_MASK);
 
 	if (!codec_count || codec_count > 2 ||
-	    (codec_count == 2 && !idisp_mask))
+	    (codec_count == 2 && !ctx->idisp_codec))
 		return -EINVAL;
 
-	if (codec_mask == idisp_mask) {
+	if (codec_mask == IDISP_CODEC_MASK) {
 		/* topology with iDisp as the only HDA codec */
 		num_links = IDISP_DAI_COUNT + DMIC_DAI_COUNT;
 		num_route = IDISP_ROUTE_COUNT;
@@ -152,7 +156,7 @@ static int skl_hda_fill_card_info(struct snd_soc_acpi_mach_params *mach_params)
 		num_route = ARRAY_SIZE(skl_hda_map);
 		card->dapm_widgets = skl_hda_widgets;
 		card->num_dapm_widgets = ARRAY_SIZE(skl_hda_widgets);
-		if (!idisp_mask) {
+		if (!ctx->idisp_codec) {
 			for (i = 0; i < IDISP_DAI_COUNT; i++) {
 				skl_hda_be_dai_links[i].codecs = dummy_codec;
 				skl_hda_be_dai_links[i].num_codecs =
@@ -211,6 +215,8 @@ static int skl_hda_audio_probe(struct platform_device *pdev)
 	if (!mach)
 		return -EINVAL;
 
+	snd_soc_card_set_drvdata(&hda_soc_card, ctx);
+
 	ret = skl_hda_fill_card_info(&mach->mach_params);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Unsupported HDAudio/iDisp configuration found\n");
@@ -223,7 +229,6 @@ static int skl_hda_audio_probe(struct platform_device *pdev)
 	ctx->common_hdmi_codec_drv = mach->mach_params.common_hdmi_codec_drv;
 
 	hda_soc_card.dev = &pdev->dev;
-	snd_soc_card_set_drvdata(&hda_soc_card, ctx);
 
 	if (mach->mach_params.dmic_num > 0) {
 		snprintf(hda_soc_components, sizeof(hda_soc_components),
-- 
2.25.1



