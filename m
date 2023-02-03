Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB9F368957C
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:24:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233416AbjBCKWl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:22:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233404AbjBCKWg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:22:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E75AC305F5
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:22:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C17B961E93
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:22:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A970CC433D2;
        Fri,  3 Feb 2023 10:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675419740;
        bh=ELbqlGDDb+UQ0WFgO9/o22krNJoEoYaraEgDXwcPN1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G58s7tBnbDyPITnfofdWdGqvK7n6PT0pHl1f8kUxdXGNc/LV/gEMvnVkcLR+yNt0O
         wX1wLvdkTf/krP0CbnNn1T1IEqwIxLj60KvXqrykL4egDGpy0EZF7zESotS4HEGtED
         4i2D9caTLkM52Mp4wXMNq56PVSyPiNbox4Fa5BIM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Raul Rangel <rrangel@chromium.org>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 21/28] gpiolib: acpi: Allow ignoring wake capability on pins that arent in _AEI
Date:   Fri,  3 Feb 2023 11:13:09 +0100
Message-Id: <20230203101010.877506293@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101009.946745030@linuxfoundation.org>
References: <20230203101009.946745030@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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



