Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1DD35923BD
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 18:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbiHNQYG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 12:24:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242076AbiHNQXT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 12:23:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B2B12191;
        Sun, 14 Aug 2022 09:21:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ACED1B80B79;
        Sun, 14 Aug 2022 16:21:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69804C433B5;
        Sun, 14 Aug 2022 16:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660494086;
        bh=+bJaLNnj4pmy29dsPfdJ3cwRoJe/UpZzGD3F4vtamfM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OJKxhmD1PdLOsVpw1sz9MR7k4XL0Fy8MKG24slbEKBcWsLZ+MR6B+adxgg5rRaDNX
         JNQJ8I2Io2/VtjSnYyo5OH0fEghqB1jNQwh8nP4ecs/VfTDcfOv0dqHgJQwNln8qzo
         pXIlPghiTHrvyPqSjPd9iFWRawVzuwpEUBPauvJ2k3hxAp0OpYvBnJpj9N0NPp4mwB
         gT2hl85n4/okkgvH8UueF8BDM8Aws9+/Sl5Cks6JxdLRf86ubCAWGiY+NwhcT8I7ow
         PL5Pm12lNTvxV1MlLCehPDMXSP0BdZa5cRHhLCoL+DFJS7LkeuZGuyuHE079+dhhhJ
         FxnDPR3Gb4nJw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrey Turkin <andrey.turkin@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, cezary.rojewski@intel.com,
        liam.r.girdwood@linux.intel.com, peter.ujfalusi@linux.intel.com,
        yung-chuan.liao@linux.intel.com, ranjani.sridharan@linux.intel.com,
        kai.vehmanen@linux.intel.com, perex@perex.cz, tiwai@suse.com,
        mchehab@kernel.org, akihiko.odaki@gmail.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.19 25/48] ASoC: Intel: sof_es8336: Fix GPIO quirks set via module option
Date:   Sun, 14 Aug 2022 12:19:18 -0400
Message-Id: <20220814161943.2394452-25-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814161943.2394452-1-sashal@kernel.org>
References: <20220814161943.2394452-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Turkin <andrey.turkin@gmail.com>

[ Upstream commit 5e60f1cfb830342304200437121f440b72b54f54 ]

The two GPIO quirk bits only affected actual GPIO selection
when set by the quirks table. They were reported as being
in effect when set via module options but actually did nothing.

Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrey Turkin <andrey.turkin@gmail.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20220725194909.145418-4-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_es8336.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/sound/soc/intel/boards/sof_es8336.c b/sound/soc/intel/boards/sof_es8336.c
index 23d03e0f7759..4d0c361fc277 100644
--- a/sound/soc/intel/boards/sof_es8336.c
+++ b/sound/soc/intel/boards/sof_es8336.c
@@ -77,8 +77,6 @@ static const struct acpi_gpio_mapping acpi_enable_both_gpios_rev_order[] = {
 	{ }
 };
 
-static const struct acpi_gpio_mapping *gpio_mapping = acpi_speakers_enable_gpio0;
-
 static void log_quirks(struct device *dev)
 {
 	dev_info(dev, "quirk mask %#lx\n", quirk);
@@ -272,15 +270,6 @@ static int sof_es8336_quirk_cb(const struct dmi_system_id *id)
 {
 	quirk = (unsigned long)id->driver_data;
 
-	if (quirk & SOF_ES8336_HEADPHONE_GPIO) {
-		if (quirk & SOF_ES8336_SPEAKERS_EN_GPIO1_QUIRK)
-			gpio_mapping = acpi_enable_both_gpios;
-		else
-			gpio_mapping = acpi_enable_both_gpios_rev_order;
-	} else if (quirk & SOF_ES8336_SPEAKERS_EN_GPIO1_QUIRK) {
-		gpio_mapping = acpi_speakers_enable_gpio1;
-	}
-
 	return 1;
 }
 
@@ -529,6 +518,7 @@ static int sof_es8336_probe(struct platform_device *pdev)
 	struct acpi_device *adev;
 	struct snd_soc_dai_link *dai_links;
 	struct device *codec_dev;
+	const struct acpi_gpio_mapping *gpio_mapping;
 	unsigned int cnt = 0;
 	int dmic_be_num = 0;
 	int hdmi_num = 3;
@@ -635,6 +625,17 @@ static int sof_es8336_probe(struct platform_device *pdev)
 	}
 
 	/* get speaker enable GPIO */
+	if (quirk & SOF_ES8336_HEADPHONE_GPIO) {
+		if (quirk & SOF_ES8336_SPEAKERS_EN_GPIO1_QUIRK)
+			gpio_mapping = acpi_enable_both_gpios;
+		else
+			gpio_mapping = acpi_enable_both_gpios_rev_order;
+	} else if (quirk & SOF_ES8336_SPEAKERS_EN_GPIO1_QUIRK) {
+		gpio_mapping = acpi_speakers_enable_gpio1;
+	} else {
+		gpio_mapping = acpi_speakers_enable_gpio0;
+	}
+
 	ret = devm_acpi_dev_add_driver_gpios(codec_dev, gpio_mapping);
 	if (ret)
 		dev_warn(codec_dev, "unable to add GPIO mapping table\n");
-- 
2.35.1

