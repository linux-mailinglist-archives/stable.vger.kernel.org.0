Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36C39537CD1
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 15:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237552AbiE3NhN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 09:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237627AbiE3Nfd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 09:35:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDC6F939EF;
        Mon, 30 May 2022 06:28:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2486B80DA8;
        Mon, 30 May 2022 13:28:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07F55C385B8;
        Mon, 30 May 2022 13:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917317;
        bh=yWcmRdVyi+FWys7GZ9HWj6oxRlxBcBG6kQKuSmRN7nY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MbNB4qr/P6przBXEvy6yEWNy1KJI51RZMiPTZ7oqOlSN+NISgv1IoHAorhXld4YoB
         G2mv5rj4BJXQKq/ZItAJU+ML/MTgrs1wqb/5ZOocpLXaQU4jOYJtO+O+IaFrfnYkQ2
         J54ZNSI8BBM13mmESHP01L4uUgqyV3TnRLqffUIKnM9pBl7s64J8WLPpTSmErm0FZH
         VdKd2u0JMAGnwR0gT93PMBhL4zaz/5tUYsciN6cCYXjyycTgaEulI9R6Cwhhhy0od8
         ygRTasqqDhtOBB4unqwYkXNYSTas7SqDivs0N4zumyiY1JGmSLgcRipo3W/zgDXM8L
         BGn27ldQbd2MA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Brent Lu <brent.lu@intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, cezary.rojewski@intel.com,
        liam.r.girdwood@linux.intel.com, yang.jie@linux.intel.com,
        perex@perex.cz, tiwai@suse.com, ranjani.sridharan@linux.intel.com,
        akihiko.odaki@gmail.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.18 091/159] ASoC: Intel: sof_ssp_amp: fix no DMIC BE Link on Chromebooks
Date:   Mon, 30 May 2022 09:23:16 -0400
Message-Id: <20220530132425.1929512-91-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530132425.1929512-1-sashal@kernel.org>
References: <20220530132425.1929512-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brent Lu <brent.lu@intel.com>

[ Upstream commit d1c808765deb2bcd35d827402ed4d75d068aae18 ]

The SOF topology supports 2 BE Links(dmic01 and dmic16k) and each
link supports up to four DMICs. However, Chromebook does not implement
ACPI NHLT table so the mach->mach_params.dmic_num is always zero. We
add a quirk so machine driver knows it's running on a Chromebook and
need to create BE Links for DMIC.

Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Signed-off-by: Brent Lu <brent.lu@intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20220509170922.54868-3-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_ssp_amp.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/sound/soc/intel/boards/sof_ssp_amp.c b/sound/soc/intel/boards/sof_ssp_amp.c
index 88530e9de543..ef70c6f27fe1 100644
--- a/sound/soc/intel/boards/sof_ssp_amp.c
+++ b/sound/soc/intel/boards/sof_ssp_amp.c
@@ -9,6 +9,7 @@
 
 #include <linux/acpi.h>
 #include <linux/delay.h>
+#include <linux/dmi.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <sound/core.h>
@@ -78,6 +79,16 @@ struct sof_card_private {
 	bool idisp_codec;
 };
 
+static const struct dmi_system_id chromebook_platforms[] = {
+	{
+		.ident = "Google Chromebooks",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Google"),
+		}
+	},
+	{},
+};
+
 static const struct snd_soc_dapm_widget sof_ssp_amp_dapm_widgets[] = {
 	SND_SOC_DAPM_MIC("SoC DMIC", NULL),
 };
@@ -371,7 +382,7 @@ static int sof_ssp_amp_probe(struct platform_device *pdev)
 	struct snd_soc_dai_link *dai_links;
 	struct snd_soc_acpi_mach *mach;
 	struct sof_card_private *ctx;
-	int dmic_be_num, hdmi_num = 0;
+	int dmic_be_num = 0, hdmi_num = 0;
 	int ret, ssp_codec;
 
 	ctx = devm_kzalloc(&pdev->dev, sizeof(*ctx), GFP_KERNEL);
@@ -383,7 +394,8 @@ static int sof_ssp_amp_probe(struct platform_device *pdev)
 
 	mach = pdev->dev.platform_data;
 
-	dmic_be_num = mach->mach_params.dmic_num;
+	if (dmi_check_system(chromebook_platforms) || mach->mach_params.dmic_num > 0)
+		dmic_be_num = 2;
 
 	ssp_codec = sof_ssp_amp_quirk & SOF_AMPLIFIER_SSP_MASK;
 
-- 
2.35.1

