Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03B96679A8D
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 14:51:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234724AbjAXNvO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 08:51:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234722AbjAXNu5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 08:50:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F289F49037;
        Tue, 24 Jan 2023 05:48:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8DF7B81109;
        Tue, 24 Jan 2023 13:42:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DAEAC4339B;
        Tue, 24 Jan 2023 13:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674567754;
        bh=ELbqlGDDb+UQ0WFgO9/o22krNJoEoYaraEgDXwcPN1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WDKSI0A4Gwg6oarSYGytl8RWH7bt36R1HE/j592bsiN639cAbSKnJyDiLcc4Xv8m0
         MTj959sBiGadl0J/aHDlA+3BnQEkY4iFQmUlWFcnAZpdfFJ7JS7TLbct9FRXSV3kbn
         uDp4zBSZHEcNYxMf4oSDvFk3FM2Bjhzo+EDFUz47OkIYPNfFG3nasGbYf9e9w1Ftou
         eEN/Ykol4g+JNQOduxiohcmrck6X6PLD2xIQvrLholm6uPYyxFLP9/TJFxANQi/1AL
         y10Vx43zag3+E/Kp5iWSS820o/bf2BCRN/VuU4g/1ru4t2I4EQAip9s104PnVytbtm
         HGLHmXWwVtnfA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mario Limonciello <mario.limonciello@amd.com>,
        Raul Rangel <rrangel@chromium.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        mika.westerberg@linux.intel.com, linus.walleij@linaro.org,
        brgl@bgdev.pl, linux-gpio@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 24/35] gpiolib: acpi: Allow ignoring wake capability on pins that aren't in _AEI
Date:   Tue, 24 Jan 2023 08:41:20 -0500
Message-Id: <20230124134131.637036-24-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230124134131.637036-1-sashal@kernel.org>
References: <20230124134131.637036-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 0e3b175f079247f0d40d2ab695999c309d3a7498 ]

Using the `ignore_wake` quirk or module parameter doesn't work for any pin
that has been specified in the _CRS instead of _AEI.

Extend the `acpi_gpio_irq_is_wake` check to cover both places.

Suggested-by: Raul Rangel <rrangel@chromium.org>
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/1722#note_1722335
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib-acpi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
index a7d2358736fe..27f234637a15 100644
--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -361,7 +361,7 @@ static bool acpi_gpio_in_ignore_list(const char *ignore_list, const char *contro
 }
 
 static bool acpi_gpio_irq_is_wake(struct device *parent,
-				  struct acpi_resource_gpio *agpio)
+				  const struct acpi_resource_gpio *agpio)
 {
 	unsigned int pin = agpio->pin_table[0];
 
@@ -754,7 +754,7 @@ static int acpi_populate_gpio_lookup(struct acpi_resource *ares, void *data)
 		lookup->info.pin_config = agpio->pin_config;
 		lookup->info.debounce = agpio->debounce_timeout;
 		lookup->info.gpioint = gpioint;
-		lookup->info.wake_capable = agpio->wake_capable == ACPI_WAKE_CAPABLE;
+		lookup->info.wake_capable = acpi_gpio_irq_is_wake(&lookup->info.adev->dev, agpio);
 
 		/*
 		 * Polarity and triggering are only specified for GpioInt
-- 
2.39.0

