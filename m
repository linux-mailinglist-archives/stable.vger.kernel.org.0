Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 888114EC0B0
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 13:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344147AbiC3Lwi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 07:52:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344258AbiC3LwR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:52:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82415278576;
        Wed, 30 Mar 2022 04:48:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F15A6B81C25;
        Wed, 30 Mar 2022 11:48:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62E13C36AE5;
        Wed, 30 Mar 2022 11:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648640899;
        bh=udRcMs7kmOyAA+RyJhsEG9iF/vW5/VUQI/1wSi442CM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NplZ5+KAqNwzwzknuhNAudxLr3JgjgL37JFGxFDbXr+GHlokHl2L3v1Qe2CB74hIW
         lEMXIfnPKQ9c358wXaKUyUzMs4PdjGbMnvtyHiZ6TxLfa9EFfiaNDKMm2iWIg0LpyO
         rl9IlnnVb3e5eHDco+7hd7EnLs3yTDKJKyrLEb7Sq/CaCavEF8WmZ6jcZ4COxrRrhc
         T5nynL0deVzVW9oZK2P8pK2dd86GXEm0kZDZUVJTrxB5hH9SKysXMaBDhDiXZOREEB
         /AmTFw7ZuxmGmF6jyBDIcwcYW79afX5PlSBgoIOxcP3qxT9dfc1kvNLxQ7U3o1JQ4s
         ckx6YGGHbl8Mw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        =?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.17 59/66] ASoC: Intel: sof_es8336: use NHLT information to set dmic and SSP
Date:   Wed, 30 Mar 2022 07:46:38 -0400
Message-Id: <20220330114646.1669334-59-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330114646.1669334-1-sashal@kernel.org>
References: <20220330114646.1669334-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 651c304df7f6e3fbb4779527efa3eb128ef91329 ]

Since we see a proliferation of devices with various configurations,
we want to automatically set the DMIC and SSP information. This patch
relies on the information extracted from NHLT and partially reverts
existing DMI quirks added by commit a164137ce91a ("ASoC: Intel: add
machine driver for SOF+ES8336")

Note that NHLT can report multiple SSPs, choosing from the
ssp_link_mask in an MSB-first manner was found experimentally to work
fine.

The only thing that cannot be detected is the GPIO type, and users may
want to use the quirk override parameter if the 'wrong' solution is
provided.

Tested-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20220308192610.392950-15-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_es8336.c | 56 +++++++++++++++++++++--------
 1 file changed, 41 insertions(+), 15 deletions(-)

diff --git a/sound/soc/intel/boards/sof_es8336.c b/sound/soc/intel/boards/sof_es8336.c
index 20d577eaab6d..46e453915f82 100644
--- a/sound/soc/intel/boards/sof_es8336.c
+++ b/sound/soc/intel/boards/sof_es8336.c
@@ -228,24 +228,25 @@ static int sof_es8336_quirk_cb(const struct dmi_system_id *id)
 	return 1;
 }
 
+/*
+ * this table should only be used to add GPIO or jack-detection quirks
+ * that cannot be detected from ACPI tables. The SSP and DMIC
+ * information are providing by the platform driver and are aligned
+ * with the topology used.
+ *
+ * If the GPIO support is missing, the quirk parameter can be used to
+ * enable speakers. In that case it's recommended to keep the SSP and DMIC
+ * information consistent, overriding the SSP and DMIC can only be done
+ * if the topology file is modified as well.
+ */
 static const struct dmi_system_id sof_es8336_quirk_table[] = {
-	{
-		.callback = sof_es8336_quirk_cb,
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "CHUWI Innovation And Technology"),
-			DMI_MATCH(DMI_BOARD_NAME, "Hi10 X"),
-		},
-		.driver_data = (void *)SOF_ES8336_SSP_CODEC(2)
-	},
 	{
 		.callback = sof_es8336_quirk_cb,
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "IP3 tech"),
 			DMI_MATCH(DMI_BOARD_NAME, "WN1"),
 		},
-		.driver_data = (void *)(SOF_ES8336_SSP_CODEC(0) |
-					SOF_ES8336_TGL_GPIO_QUIRK |
-					SOF_ES8336_ENABLE_DMIC)
+		.driver_data = (void *)(SOF_ES8336_TGL_GPIO_QUIRK)
 	},
 	{}
 };
@@ -470,11 +471,33 @@ static int sof_es8336_probe(struct platform_device *pdev)
 	card = &sof_es8336_card;
 	card->dev = dev;
 
-	if (!dmi_check_system(sof_es8336_quirk_table))
-		quirk = SOF_ES8336_SSP_CODEC(2);
+	/* check GPIO DMI quirks */
+	dmi_check_system(sof_es8336_quirk_table);
 
-	if (quirk & SOF_ES8336_ENABLE_DMIC)
-		dmic_be_num = 2;
+	if (!mach->mach_params.i2s_link_mask) {
+		dev_warn(dev, "No I2S link information provided, using SSP0. This may need to be modified with the quirk module parameter\n");
+	} else {
+		/*
+		 * Set configuration based on platform NHLT.
+		 * In this machine driver, we can only support one SSP for the
+		 * ES8336 link, the else-if below are intentional.
+		 * In some cases multiple SSPs can be reported by NHLT, starting MSB-first
+		 * seems to pick the right connection.
+		 */
+		unsigned long ssp = 0;
+
+		if (mach->mach_params.i2s_link_mask & BIT(2))
+			ssp = SOF_ES8336_SSP_CODEC(2);
+		else if (mach->mach_params.i2s_link_mask & BIT(1))
+			ssp = SOF_ES8336_SSP_CODEC(1);
+		else  if (mach->mach_params.i2s_link_mask & BIT(0))
+			ssp = SOF_ES8336_SSP_CODEC(0);
+
+		quirk |= ssp;
+	}
+
+	if (mach->mach_params.dmic_num)
+		quirk |= SOF_ES8336_ENABLE_DMIC;
 
 	if (quirk_override != -1) {
 		dev_info(dev, "Overriding quirk 0x%lx => 0x%x\n",
@@ -483,6 +506,9 @@ static int sof_es8336_probe(struct platform_device *pdev)
 	}
 	log_quirks(dev);
 
+	if (quirk & SOF_ES8336_ENABLE_DMIC)
+		dmic_be_num = 2;
+
 	sof_es8336_card.num_links += dmic_be_num + hdmi_num;
 	dai_links = sof_card_dai_links_create(dev,
 					      SOF_ES8336_SSP_CODEC(quirk),
-- 
2.34.1

