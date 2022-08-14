Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE9159245F
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 18:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242529AbiHNQce (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 12:32:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242399AbiHNQaQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 12:30:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C0832F6;
        Sun, 14 Aug 2022 09:24:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B198B80B37;
        Sun, 14 Aug 2022 16:24:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 900AAC433D7;
        Sun, 14 Aug 2022 16:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660494288;
        bh=m1gZKUi5CUVetOpsW4uBv/BC7EhgMfjkz6GU/+/uQk0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WrbtPrFO0r9TBFvYUXcn8BZ0E35wtRUChjtzMNNxWY8rRPEpjc5Z+Oz+M54AfEn+l
         4uncqgNHyhSthh0g0yvHYlglnvIiAa5oU/JC/DzNPAvKCWYiKLtBqnrNcc/NnK5wYv
         3UsCJryQ4ii5WSAa1xqWpfeJG0dsmPo6DOhcasz6cKuWLr9l2qRL6EqbyNbrmYT4Uw
         z9bukY4gmY1N7dm7tsq9QBL4A142ncGC7mrHryOp/FZ3yB28ZuSlTjca1ZMYj7Iy29
         hzbuwev92fZSW9KtWwuPPBL6T1BJVy5mleaeGSO5z9RY/LXevuatD1BCihR22EyN8/
         KH/eQ+UwBxNJA==
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
Subject: [PATCH AUTOSEL 5.18 19/39] ASoC: Intel: sof_es8336: ignore GpioInt when looking for speaker/headset GPIO lines
Date:   Sun, 14 Aug 2022 12:23:08 -0400
Message-Id: <20220814162332.2396012-19-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814162332.2396012-1-sashal@kernel.org>
References: <20220814162332.2396012-1-sashal@kernel.org>
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

[ Upstream commit 751e77011f7a43a204bf2a5d02fbf5f8219bc531 ]

This fixes speaker GPIO detection on machines those ACPI tables
list their jack detection GpioInt before output GpioIo.
GpioInt entry can never be the speaker/headphone amplifier control
so it makes sense to only look for GpioIo entries when looking for them.

Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrey Turkin <andrey.turkin@gmail.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20220725194909.145418-5-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_es8336.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/sound/soc/intel/boards/sof_es8336.c b/sound/soc/intel/boards/sof_es8336.c
index 81e12f03ec97..dade1749c444 100644
--- a/sound/soc/intel/boards/sof_es8336.c
+++ b/sound/soc/intel/boards/sof_es8336.c
@@ -57,23 +57,23 @@ static const struct acpi_gpio_params enable_gpio0 = { 0, 0, true };
 static const struct acpi_gpio_params enable_gpio1 = { 1, 0, true };
 
 static const struct acpi_gpio_mapping acpi_speakers_enable_gpio0[] = {
-	{ "speakers-enable-gpios", &enable_gpio0, 1 },
+	{ "speakers-enable-gpios", &enable_gpio0, 1, ACPI_GPIO_QUIRK_ONLY_GPIOIO },
 	{ }
 };
 
 static const struct acpi_gpio_mapping acpi_speakers_enable_gpio1[] = {
-	{ "speakers-enable-gpios", &enable_gpio1, 1 },
+	{ "speakers-enable-gpios", &enable_gpio1, 1, ACPI_GPIO_QUIRK_ONLY_GPIOIO },
 };
 
 static const struct acpi_gpio_mapping acpi_enable_both_gpios[] = {
-	{ "speakers-enable-gpios", &enable_gpio0, 1 },
-	{ "headphone-enable-gpios", &enable_gpio1, 1 },
+	{ "speakers-enable-gpios", &enable_gpio0, 1, ACPI_GPIO_QUIRK_ONLY_GPIOIO },
+	{ "headphone-enable-gpios", &enable_gpio1, 1, ACPI_GPIO_QUIRK_ONLY_GPIOIO },
 	{ }
 };
 
 static const struct acpi_gpio_mapping acpi_enable_both_gpios_rev_order[] = {
-	{ "speakers-enable-gpios", &enable_gpio1, 1 },
-	{ "headphone-enable-gpios", &enable_gpio0, 1 },
+	{ "speakers-enable-gpios", &enable_gpio1, 1, ACPI_GPIO_QUIRK_ONLY_GPIOIO },
+	{ "headphone-enable-gpios", &enable_gpio0, 1, ACPI_GPIO_QUIRK_ONLY_GPIOIO },
 	{ }
 };
 
-- 
2.35.1

