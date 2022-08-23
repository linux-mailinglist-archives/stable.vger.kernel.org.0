Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 623DF59D807
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349229AbiHWJWc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:22:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350534AbiHWJVw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:21:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BEAA8E0DF;
        Tue, 23 Aug 2022 01:34:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C39B1B81C48;
        Tue, 23 Aug 2022 08:33:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D31CC433C1;
        Tue, 23 Aug 2022 08:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243638;
        bh=K+ir609JSd1Xoem7Z547dEqv671JPfbFvoqdmpiy38o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xF4z6Hncd71Rbvl5XJvwZplrfqO0KKyXiFW/ZHXtaqFZ4u71Cr/WGeBWUcVkp7AK2
         Sjnw+jlvnOvLGoVhHfsQlO5PdWPTvfOdrHbcqhCDgtlaP3GX9/Q8vhRml2xKI63+58
         wVGf6BFcf4jOoUBJv4VUtaseaV1zN13eb6x8v1og=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andrey Turkin <andrey.turkin@gmail.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 341/365] ASoC: Intel: sof_es8336: ignore GpioInt when looking for speaker/headset GPIO lines
Date:   Tue, 23 Aug 2022 10:04:02 +0200
Message-Id: <20220823080132.481528437@linuxfoundation.org>
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
index 4d0c361fc277..d70d8255b8c7 100644
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



