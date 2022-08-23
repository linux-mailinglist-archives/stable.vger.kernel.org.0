Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3A6C59D728
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351151AbiHWJgt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:36:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351767AbiHWJf6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:35:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F257E97529;
        Tue, 23 Aug 2022 01:40:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98B5BB81C3E;
        Tue, 23 Aug 2022 08:33:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E11C0C433C1;
        Tue, 23 Aug 2022 08:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243635;
        bh=+bJaLNnj4pmy29dsPfdJ3cwRoJe/UpZzGD3F4vtamfM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NJJ659DbvWJb7G2MOeVZ/elNdeDWjsaLc3i3tZkAtFyXtz9qAq6tSnaJslkzBLzjF
         OGVskaCUrD03MGhyOwj71KLpP66j12wdI8UsmTp2GhaMVOAsS6a3ff4rFx9oOJyX+/
         CCl8/DtIy0xIu+k+HmADCNX1wVWI9Xwfsv2njHRA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andrey Turkin <andrey.turkin@gmail.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 340/365] ASoC: Intel: sof_es8336: Fix GPIO quirks set via module option
Date:   Tue, 23 Aug 2022 10:04:01 +0200
Message-Id: <20220823080132.439592982@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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



