Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E513548D62
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354493AbiFMLcw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:32:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354402AbiFML32 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:29:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFA85CE03;
        Mon, 13 Jun 2022 03:44:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6095661016;
        Mon, 13 Jun 2022 10:44:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EFE3C34114;
        Mon, 13 Jun 2022 10:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655117044;
        bh=T7aZbuh/Zv3GICEPys+WZtiB+rtdzIMAxatixVfNBjc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uRElThdVaapKmN0b7fCpRrDStKSOe0EPgGDqjks4YUdKcVBP9nCGZo7ts5EgMPzgc
         hcKuVdnIvGuL4QGQD8LU77hDmyC/vi6oU4eHo8vkfgy7nV2N+uDCYYHwrquA+CscmY
         7Y7x9mC0G/Jvslmx85P6nuW2RZ6itR7aJjhPfdis=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Jarzmik <robert.jarzmik@free.fr>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5.4 266/411] ARM: pxa: maybe fix gpio lookup tables
Date:   Mon, 13 Jun 2022 12:08:59 +0200
Message-Id: <20220613094936.736266224@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 2672a4bff6c03a20d5ae460a091f67ee782c3eff upstream.

>From inspection I found a couple of GPIO lookups that are
listed with device "gpio-pxa", but actually have a number
from a different gpio controller.

Try to rectify that here, with a guess of what the actual
device name is.

Acked-by: Robert Jarzmik <robert.jarzmik@free.fr>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Cc: stable@vger.kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/mach-pxa/cm-x300.c  |    8 ++++----
 arch/arm/mach-pxa/magician.c |    2 +-
 arch/arm/mach-pxa/tosa.c     |    4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

--- a/arch/arm/mach-pxa/cm-x300.c
+++ b/arch/arm/mach-pxa/cm-x300.c
@@ -355,13 +355,13 @@ static struct platform_device cm_x300_sp
 static struct gpiod_lookup_table cm_x300_spi_gpiod_table = {
 	.dev_id         = "spi_gpio",
 	.table          = {
-		GPIO_LOOKUP("gpio-pxa", GPIO_LCD_SCL,
+		GPIO_LOOKUP("pca9555.1", GPIO_LCD_SCL - GPIO_LCD_BASE,
 			    "sck", GPIO_ACTIVE_HIGH),
-		GPIO_LOOKUP("gpio-pxa", GPIO_LCD_DIN,
+		GPIO_LOOKUP("pca9555.1", GPIO_LCD_DIN - GPIO_LCD_BASE,
 			    "mosi", GPIO_ACTIVE_HIGH),
-		GPIO_LOOKUP("gpio-pxa", GPIO_LCD_DOUT,
+		GPIO_LOOKUP("pca9555.1", GPIO_LCD_DOUT - GPIO_LCD_BASE,
 			    "miso", GPIO_ACTIVE_HIGH),
-		GPIO_LOOKUP("gpio-pxa", GPIO_LCD_CS,
+		GPIO_LOOKUP("pca9555.1", GPIO_LCD_CS - GPIO_LCD_BASE,
 			    "cs", GPIO_ACTIVE_HIGH),
 		{ },
 	},
--- a/arch/arm/mach-pxa/magician.c
+++ b/arch/arm/mach-pxa/magician.c
@@ -675,7 +675,7 @@ static struct platform_device bq24022 =
 static struct gpiod_lookup_table bq24022_gpiod_table = {
 	.dev_id = "gpio-regulator",
 	.table = {
-		GPIO_LOOKUP("gpio-pxa", EGPIO_MAGICIAN_BQ24022_ISET2,
+		GPIO_LOOKUP("htc-egpio-0", EGPIO_MAGICIAN_BQ24022_ISET2 - MAGICIAN_EGPIO_BASE,
 			    NULL, GPIO_ACTIVE_HIGH),
 		GPIO_LOOKUP("gpio-pxa", GPIO30_MAGICIAN_BQ24022_nCHARGE_EN,
 			    "enable", GPIO_ACTIVE_LOW),
--- a/arch/arm/mach-pxa/tosa.c
+++ b/arch/arm/mach-pxa/tosa.c
@@ -295,9 +295,9 @@ static struct gpiod_lookup_table tosa_mc
 	.table = {
 		GPIO_LOOKUP("gpio-pxa", TOSA_GPIO_nSD_DETECT,
 			    "cd", GPIO_ACTIVE_LOW),
-		GPIO_LOOKUP("gpio-pxa", TOSA_GPIO_SD_WP,
+		GPIO_LOOKUP("sharp-scoop.0", TOSA_GPIO_SD_WP - TOSA_SCOOP_GPIO_BASE,
 			    "wp", GPIO_ACTIVE_LOW),
-		GPIO_LOOKUP("gpio-pxa", TOSA_GPIO_PWR_ON,
+		GPIO_LOOKUP("sharp-scoop.0", TOSA_GPIO_PWR_ON - TOSA_SCOOP_GPIO_BASE,
 			    "power", GPIO_ACTIVE_HIGH),
 		{ },
 	},


