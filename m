Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8EF312165C
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:28:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbfLPS2j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:28:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:34222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731245AbfLPSOi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:14:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2955B206E0;
        Mon, 16 Dec 2019 18:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576520076;
        bh=qYqBLF8M2/sPdGcgsGh3i5oLOuUEFURULfi2DPiVQ9o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BVYTVpr6ceNIuYycjHEUW3xsdlv64PMGfSb4W7q4rTt6dKjDdHfN0zfo0O2wJwa8Y
         M1aYgy9dY+l9cWGvRWb2h2ZaJoOO2hq96206QUQhLYENLCAdOiTTU9DLKgGLXViNzR
         nCWrtAEXrkriX+ht+Os4kzYQncNdzWZeliq5+RO4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "H. Nikolaus Schaller" <hns@goldelico.com>,
        Tony Lindgren <tony@atomide.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 166/180] omap: pdata-quirks: revert pandora specific gpiod additions
Date:   Mon, 16 Dec 2019 18:50:06 +0100
Message-Id: <20191216174847.036007157@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174806.018988360@linuxfoundation.org>
References: <20191216174806.018988360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: H. Nikolaus Schaller <hns@goldelico.com>

[ Upstream commit 4e8fad98171babe019db51c15055ec74697e9525 ]

This partly reverts the commit efdfeb079cc3 ("regulator: fixed: Convert to
use GPIO descriptor only").

We must remove this from mainline first, so that the following patch
to remove the openpandora quirks for mmc3 and wl1251 cleanly applies
to stable v4.9, v4.14, v4.19 where the above mentioned patch is not yet
present.

Since the code affected is removed (no pandora gpios in pdata-quirks
and more), there will be no matching revert-of-the-revert.

Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
Acked-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap2/pdata-quirks.c | 19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/arch/arm/mach-omap2/pdata-quirks.c b/arch/arm/mach-omap2/pdata-quirks.c
index 6c6f8fce854e2..e5c99e33afae2 100644
--- a/arch/arm/mach-omap2/pdata-quirks.c
+++ b/arch/arm/mach-omap2/pdata-quirks.c
@@ -7,7 +7,6 @@
 #include <linux/clk.h>
 #include <linux/davinci_emac.h>
 #include <linux/gpio.h>
-#include <linux/gpio/machine.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/of_platform.h>
@@ -327,7 +326,9 @@ static struct regulator_init_data pandora_vmmc3 = {
 static struct fixed_voltage_config pandora_vwlan = {
 	.supply_name		= "vwlan",
 	.microvolts		= 1800000, /* 1.8V */
+	.gpio			= PANDORA_WIFI_NRESET_GPIO,
 	.startup_delay		= 50000, /* 50ms */
+	.enable_high		= 1,
 	.init_data		= &pandora_vmmc3,
 };
 
@@ -339,19 +340,6 @@ static struct platform_device pandora_vwlan_device = {
 	},
 };
 
-static struct gpiod_lookup_table pandora_vwlan_gpiod_table = {
-	.dev_id = "reg-fixed-voltage.1",
-	.table = {
-		/*
-		 * As this is a low GPIO number it should be at the first
-		 * GPIO bank.
-		 */
-		GPIO_LOOKUP("gpio-0-31", PANDORA_WIFI_NRESET_GPIO,
-			    NULL, GPIO_ACTIVE_HIGH),
-		{ },
-	},
-};
-
 static void pandora_wl1251_init_card(struct mmc_card *card)
 {
 	/*
@@ -373,6 +361,8 @@ static struct omap2_hsmmc_info pandora_mmc3[] = {
 	{
 		.mmc		= 3,
 		.caps		= MMC_CAP_4_BIT_DATA | MMC_CAP_POWER_OFF_CARD,
+		.gpio_cd	= -EINVAL,
+		.gpio_wp	= -EINVAL,
 		.init_card	= pandora_wl1251_init_card,
 	},
 	{}	/* Terminator */
@@ -411,7 +401,6 @@ fail:
 static void __init omap3_pandora_legacy_init(void)
 {
 	platform_device_register(&pandora_backlight);
-	gpiod_add_lookup_table(&pandora_vwlan_gpiod_table);
 	platform_device_register(&pandora_vwlan_device);
 	omap_hsmmc_init(pandora_mmc3);
 	omap_hsmmc_late_init(pandora_mmc3);
-- 
2.20.1



