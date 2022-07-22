Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A83BF57E0F9
	for <lists+stable@lfdr.de>; Fri, 22 Jul 2022 13:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbiGVLsT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jul 2022 07:48:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbiGVLsS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jul 2022 07:48:18 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 040C4B9A00
        for <stable@vger.kernel.org>; Fri, 22 Jul 2022 04:48:17 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id m12so6156582lfj.4
        for <stable@vger.kernel.org>; Fri, 22 Jul 2022 04:48:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Q8iRoPPBKHKoGo4hL8GS/tRv9Gd3DvFPlZTbpKRwuI4=;
        b=x78LAqLQ+c7oEZFhMztPt5dsAvSM3qQVd0QG41YgPP8Vm6fHbd9uYCHOdyOAwy76Bx
         PdwsofK+JZBrpimHkvkcF0IEjoIKfsWpHrfCfbIiv/qLXdJFVafRM3ahCMiLLo04fjiq
         YatZd1STTImM4KXp+r51KpieK+tAizQ0wp/hxTiyV8X4dVPFWCpkl+GSMsNHQqhZz8Ri
         5BckFAgO/ODAbmA0QIaqmUKhlL1FVn445tRPTfUC7ja+zYI7JvXukhUrArMhX0JUtusN
         zjJyFo+oWAePhbLzeFGkWpP12lZ781O02prOdb4N7bubIWtnK9+x9vgR0kMVjqN37Lr3
         tnqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Q8iRoPPBKHKoGo4hL8GS/tRv9Gd3DvFPlZTbpKRwuI4=;
        b=mbOloi7fXXHc7bwsozFR/k3IeNtlwGH6gQitnArNLzHZME4xlfDOqgzct98Mj03uxf
         4jwanH3ZCXqaS62MAOJ6/DuHrPUmemrOK+Z2qZYiQKtn29UVdPffCMKblO/vGGOmPsSe
         Tvm6sSySRTWT6yf9aJSX11QRZW0lY6VOOBimRlTFmrsjax3CDXi+48P55j6OoFtcByC5
         rz3oaVn4Omy5hzo2Wrb3G2ZAWmwRmK9/k5CUX7uwkKcfaLEZPNDws9vvxwiXu94BwV3M
         YsuEJYRWC8dqnGSEKpYBF1JsowaDZnOPmUSop5enLFS3Fj0MoYxN/AQl1KIaj7rUoBTh
         4SYA==
X-Gm-Message-State: AJIora8oHjPpPNo6Vn44YMz+WoagcC7Qu7Mt1Bqod1qDSt9cMq31P7yU
        VfU9a3Cb2GzurvOROwWc38EPLDbNyIpJaQ==
X-Google-Smtp-Source: AGRyM1ueFJXNrByg4ku/ovEFrt3BbnNhd6zLtKDM7DQqotMlGdqLqNCCdGlCzmqV+cLv1Ua2FohSiw==
X-Received: by 2002:a05:6512:128e:b0:489:e63d:3042 with SMTP id u14-20020a056512128e00b00489e63d3042mr45492lfs.302.1658490495291;
        Fri, 22 Jul 2022 04:48:15 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id m13-20020a056512358d00b004793b9c2c12sm1013102lfr.124.2022.07.22.04.48.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jul 2022 04:48:14 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     arm@kernel.org, soc@kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>,
        stable@vger.kernel.org, Laurence de Bruxelles <lfdebrux@gmail.com>
Subject: [PATCH] ARM: pxa2xx: Fix GPIO descriptor tables
Date:   Fri, 22 Jul 2022 13:46:11 +0200
Message-Id: <20220722114611.1517414-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Cc: stable@vger.kernel.org
Reported-by: Laurence de Bruxelles <lfdebrux@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
SoC people: please apply this directly for fixes.
---
 arch/arm/mach-pxa/corgi.c     | 2 +-
 arch/arm/mach-pxa/hx4700.c    | 2 +-
 arch/arm/mach-pxa/icontrol.c  | 4 ++--
 arch/arm/mach-pxa/littleton.c | 2 +-
 arch/arm/mach-pxa/magician.c  | 2 +-
 arch/arm/mach-pxa/spitz.c     | 2 +-
 arch/arm/mach-pxa/z2.c        | 4 ++--
 7 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/arm/mach-pxa/corgi.c b/arch/arm/mach-pxa/corgi.c
index c546356d0f02..5738496717e2 100644
--- a/arch/arm/mach-pxa/corgi.c
+++ b/arch/arm/mach-pxa/corgi.c
@@ -549,7 +549,7 @@ static struct pxa2xx_spi_controller corgi_spi_info = {
 };
 
 static struct gpiod_lookup_table corgi_spi_gpio_table = {
-	.dev_id = "pxa2xx-spi.1",
+	.dev_id = "spi1",
 	.table = {
 		GPIO_LOOKUP_IDX("gpio-pxa", CORGI_GPIO_ADS7846_CS, "cs", 0, GPIO_ACTIVE_LOW),
 		GPIO_LOOKUP_IDX("gpio-pxa", CORGI_GPIO_LCDCON_CS, "cs", 1, GPIO_ACTIVE_LOW),
diff --git a/arch/arm/mach-pxa/hx4700.c b/arch/arm/mach-pxa/hx4700.c
index 2ae06edf413c..2fd665944103 100644
--- a/arch/arm/mach-pxa/hx4700.c
+++ b/arch/arm/mach-pxa/hx4700.c
@@ -635,7 +635,7 @@ static struct pxa2xx_spi_controller pxa_ssp2_master_info = {
 };
 
 static struct gpiod_lookup_table pxa_ssp2_gpio_table = {
-	.dev_id = "pxa2xx-spi.2",
+	.dev_id = "spi2",
 	.table = {
 		GPIO_LOOKUP_IDX("gpio-pxa", GPIO88_HX4700_TSC2046_CS, "cs", 0, GPIO_ACTIVE_LOW),
 		{ },
diff --git a/arch/arm/mach-pxa/icontrol.c b/arch/arm/mach-pxa/icontrol.c
index 753fe166ab68..624088257cfc 100644
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
@@ -149,7 +149,7 @@ static struct gpiod_lookup_table pxa_ssp3_gpio_table = {
 };
 
 static struct gpiod_lookup_table pxa_ssp4_gpio_table = {
-	.dev_id = "pxa2xx-spi.4",
+	.dev_id = "spi4",
 	.table = {
 		GPIO_LOOKUP_IDX("gpio-pxa", ICONTROL_MCP251x_nCS3, "cs", 0, GPIO_ACTIVE_LOW),
 		GPIO_LOOKUP_IDX("gpio-pxa", ICONTROL_MCP251x_nCS4, "cs", 1, GPIO_ACTIVE_LOW),
diff --git a/arch/arm/mach-pxa/littleton.c b/arch/arm/mach-pxa/littleton.c
index f98dc61e87af..98423a96f440 100644
--- a/arch/arm/mach-pxa/littleton.c
+++ b/arch/arm/mach-pxa/littleton.c
@@ -207,7 +207,7 @@ static struct spi_board_info littleton_spi_devices[] __initdata = {
 };
 
 static struct gpiod_lookup_table littleton_spi_gpio_table = {
-	.dev_id = "pxa2xx-spi.2",
+	.dev_id = "spi2",
 	.table = {
 		GPIO_LOOKUP_IDX("gpio-pxa", LITTLETON_GPIO_LCD_CS, "cs", 0, GPIO_ACTIVE_LOW),
 		{ },
diff --git a/arch/arm/mach-pxa/magician.c b/arch/arm/mach-pxa/magician.c
index 20456a55c4c5..0827ebca1d38 100644
--- a/arch/arm/mach-pxa/magician.c
+++ b/arch/arm/mach-pxa/magician.c
@@ -994,7 +994,7 @@ static struct pxa2xx_spi_controller magician_spi_info = {
 };
 
 static struct gpiod_lookup_table magician_spi_gpio_table = {
-	.dev_id = "pxa2xx-spi.2",
+	.dev_id = "spi2",
 	.table = {
 		/* NOTICE must be GPIO, incompatibility with hw PXA SPI framing */
 		GPIO_LOOKUP_IDX("gpio-pxa", GPIO14_MAGICIAN_TSC2046_CS, "cs", 0, GPIO_ACTIVE_LOW),
diff --git a/arch/arm/mach-pxa/spitz.c b/arch/arm/mach-pxa/spitz.c
index dd88953adc9d..9964729cd428 100644
--- a/arch/arm/mach-pxa/spitz.c
+++ b/arch/arm/mach-pxa/spitz.c
@@ -578,7 +578,7 @@ static struct pxa2xx_spi_controller spitz_spi_info = {
 };
 
 static struct gpiod_lookup_table spitz_spi_gpio_table = {
-	.dev_id = "pxa2xx-spi.2",
+	.dev_id = "spi2",
 	.table = {
 		GPIO_LOOKUP_IDX("gpio-pxa", SPITZ_GPIO_ADS7846_CS, "cs", 0, GPIO_ACTIVE_LOW),
 		GPIO_LOOKUP_IDX("gpio-pxa", SPITZ_GPIO_LCDCON_CS, "cs", 1, GPIO_ACTIVE_LOW),
diff --git a/arch/arm/mach-pxa/z2.c b/arch/arm/mach-pxa/z2.c
index d03520555497..c4d4162a7e6e 100644
--- a/arch/arm/mach-pxa/z2.c
+++ b/arch/arm/mach-pxa/z2.c
@@ -623,7 +623,7 @@ static struct pxa2xx_spi_controller pxa_ssp2_master_info = {
 };
 
 static struct gpiod_lookup_table pxa_ssp1_gpio_table = {
-	.dev_id = "pxa2xx-spi.1",
+	.dev_id = "spi1",
 	.table = {
 		GPIO_LOOKUP_IDX("gpio-pxa", GPIO24_ZIPITZ2_WIFI_CS, "cs", 0, GPIO_ACTIVE_LOW),
 		{ },
@@ -631,7 +631,7 @@ static struct gpiod_lookup_table pxa_ssp1_gpio_table = {
 };
 
 static struct gpiod_lookup_table pxa_ssp2_gpio_table = {
-	.dev_id = "pxa2xx-spi.2",
+	.dev_id = "spi2",
 	.table = {
 		GPIO_LOOKUP_IDX("gpio-pxa", GPIO88_ZIPITZ2_LCD_CS, "cs", 0, GPIO_ACTIVE_LOW),
 		{ },
-- 
2.36.1

