Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4118E586A0D
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 14:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233842AbiHAMMH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 08:12:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234222AbiHAMKy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 08:10:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 801846BC03;
        Mon,  1 Aug 2022 04:56:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B547B80EAC;
        Mon,  1 Aug 2022 11:56:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C54F7C433C1;
        Mon,  1 Aug 2022 11:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659355003;
        bh=UNsBv5enHLJ3J/h7oyP4hiTFaz+6uZq+D1FX11qoP+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wARRNarHHyRnY2a9M1fqrKIHw/S+vzvBXVCV4bd9eSxY5D2ERhg+CwY0Gfui2rqwA
         5EpUMJgvjjuATxLt1NRO3WscCWAFnW/EfYWjIOU6yU5PmL1ziwk8Y0YikXSb+glnZW
         4PQeYaOBWaXdXbJdN66y+abfP5VlAbcY/KaOHu7E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Laurence de Bruxelles <lfdebrux@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5.18 04/88] ARM: pxa2xx: Fix GPIO descriptor tables
Date:   Mon,  1 Aug 2022 13:46:18 +0200
Message-Id: <20220801114138.238581181@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114138.041018499@linuxfoundation.org>
References: <20220801114138.041018499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

commit c5cdb9286913aa5a5ebb81bcca0c17df3b0e2c79 upstream.

Laurence reports:

"Kernel >5.18 on Zaurus has a bug where the power management code can't
talk to devices, emitting the following errors:

sharpsl-pm sharpsl-pm: Error: AC check failed: voltage -22.
sharpsl-pm sharpsl-pm: Charging Error!
sharpsl-pm sharpsl-pm: Warning: Cannot read main battery!

Looking at the recent changes, I found that commit 31455bbda208 ("spi:
pxa2xx_spi: Convert to use GPIO descriptors") replaced the deprecated
SPI chip select platform device code with a gpiod lookup table. However,
this didn't seem to work until I changed the `dev_id` member from the
device name to the bus id. I'm not entirely sure why this is necessary,
but I suspect it is related to the fact that in sysfs SPI devices are
attached under /sys/devices/.../dev_name/spi_master/spiB/spiB.C, rather
than directly to the device."

After reviewing the change I conclude that the same fix is needed
for all affected boards.

Fixes: 31455bbda208 ("spi: pxa2xx_spi: Convert to use GPIO descriptors")
Reported-by: Laurence de Bruxelles <lfdebrux@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220722114611.1517414-1-linus.walleij@linaro.org'
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/mach-pxa/corgi.c     |    2 +-
 arch/arm/mach-pxa/hx4700.c    |    2 +-
 arch/arm/mach-pxa/icontrol.c  |    4 ++--
 arch/arm/mach-pxa/littleton.c |    2 +-
 arch/arm/mach-pxa/magician.c  |    2 +-
 arch/arm/mach-pxa/spitz.c     |    2 +-
 arch/arm/mach-pxa/z2.c        |    4 ++--
 7 files changed, 9 insertions(+), 9 deletions(-)

--- a/arch/arm/mach-pxa/corgi.c
+++ b/arch/arm/mach-pxa/corgi.c
@@ -531,7 +531,7 @@ static struct pxa2xx_spi_controller corg
 };
 
 static struct gpiod_lookup_table corgi_spi_gpio_table = {
-	.dev_id = "pxa2xx-spi.1",
+	.dev_id = "spi1",
 	.table = {
 		GPIO_LOOKUP_IDX("gpio-pxa", CORGI_GPIO_ADS7846_CS, "cs", 0, GPIO_ACTIVE_LOW),
 		GPIO_LOOKUP_IDX("gpio-pxa", CORGI_GPIO_LCDCON_CS, "cs", 1, GPIO_ACTIVE_LOW),
--- a/arch/arm/mach-pxa/hx4700.c
+++ b/arch/arm/mach-pxa/hx4700.c
@@ -635,7 +635,7 @@ static struct pxa2xx_spi_controller pxa_
 };
 
 static struct gpiod_lookup_table pxa_ssp2_gpio_table = {
-	.dev_id = "pxa2xx-spi.2",
+	.dev_id = "spi2",
 	.table = {
 		GPIO_LOOKUP_IDX("gpio-pxa", GPIO88_HX4700_TSC2046_CS, "cs", 0, GPIO_ACTIVE_LOW),
 		{ },
--- a/arch/arm/mach-pxa/icontrol.c
+++ b/arch/arm/mach-pxa/icontrol.c
@@ -140,7 +140,7 @@ struct platform_device pxa_spi_ssp4 = {
 };
 
 static struct gpiod_lookup_table pxa_ssp3_gpio_table = {
-	.dev_id = "pxa2xx-spi.3",
+	.dev_id = "spi3",
 	.table = {
 		GPIO_LOOKUP_IDX("gpio-pxa", ICONTROL_MCP251x_nCS1, "cs", 0, GPIO_ACTIVE_LOW),
 		GPIO_LOOKUP_IDX("gpio-pxa", ICONTROL_MCP251x_nCS2, "cs", 1, GPIO_ACTIVE_LOW),
@@ -149,7 +149,7 @@ static struct gpiod_lookup_table pxa_ssp
 };
 
 static struct gpiod_lookup_table pxa_ssp4_gpio_table = {
-	.dev_id = "pxa2xx-spi.4",
+	.dev_id = "spi4",
 	.table = {
 		GPIO_LOOKUP_IDX("gpio-pxa", ICONTROL_MCP251x_nCS3, "cs", 0, GPIO_ACTIVE_LOW),
 		GPIO_LOOKUP_IDX("gpio-pxa", ICONTROL_MCP251x_nCS4, "cs", 1, GPIO_ACTIVE_LOW),
--- a/arch/arm/mach-pxa/littleton.c
+++ b/arch/arm/mach-pxa/littleton.c
@@ -208,7 +208,7 @@ static struct spi_board_info littleton_s
 };
 
 static struct gpiod_lookup_table littleton_spi_gpio_table = {
-	.dev_id = "pxa2xx-spi.2",
+	.dev_id = "spi2",
 	.table = {
 		GPIO_LOOKUP_IDX("gpio-pxa", LITTLETON_GPIO_LCD_CS, "cs", 0, GPIO_ACTIVE_LOW),
 		{ },
--- a/arch/arm/mach-pxa/magician.c
+++ b/arch/arm/mach-pxa/magician.c
@@ -946,7 +946,7 @@ static struct pxa2xx_spi_controller magi
 };
 
 static struct gpiod_lookup_table magician_spi_gpio_table = {
-	.dev_id = "pxa2xx-spi.2",
+	.dev_id = "spi2",
 	.table = {
 		/* NOTICE must be GPIO, incompatibility with hw PXA SPI framing */
 		GPIO_LOOKUP_IDX("gpio-pxa", GPIO14_MAGICIAN_TSC2046_CS, "cs", 0, GPIO_ACTIVE_LOW),
--- a/arch/arm/mach-pxa/spitz.c
+++ b/arch/arm/mach-pxa/spitz.c
@@ -578,7 +578,7 @@ static struct pxa2xx_spi_controller spit
 };
 
 static struct gpiod_lookup_table spitz_spi_gpio_table = {
-	.dev_id = "pxa2xx-spi.2",
+	.dev_id = "spi2",
 	.table = {
 		GPIO_LOOKUP_IDX("gpio-pxa", SPITZ_GPIO_ADS7846_CS, "cs", 0, GPIO_ACTIVE_LOW),
 		GPIO_LOOKUP_IDX("gpio-pxa", SPITZ_GPIO_LCDCON_CS, "cs", 1, GPIO_ACTIVE_LOW),
--- a/arch/arm/mach-pxa/z2.c
+++ b/arch/arm/mach-pxa/z2.c
@@ -623,7 +623,7 @@ static struct pxa2xx_spi_controller pxa_
 };
 
 static struct gpiod_lookup_table pxa_ssp1_gpio_table = {
-	.dev_id = "pxa2xx-spi.1",
+	.dev_id = "spi1",
 	.table = {
 		GPIO_LOOKUP_IDX("gpio-pxa", GPIO24_ZIPITZ2_WIFI_CS, "cs", 0, GPIO_ACTIVE_LOW),
 		{ },
@@ -631,7 +631,7 @@ static struct gpiod_lookup_table pxa_ssp
 };
 
 static struct gpiod_lookup_table pxa_ssp2_gpio_table = {
-	.dev_id = "pxa2xx-spi.2",
+	.dev_id = "spi2",
 	.table = {
 		GPIO_LOOKUP_IDX("gpio-pxa", GPIO88_ZIPITZ2_LCD_CS, "cs", 0, GPIO_ACTIVE_LOW),
 		{ },


