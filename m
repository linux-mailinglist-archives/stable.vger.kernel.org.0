Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE7D12183B
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:42:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728230AbfLPSAc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:00:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:34562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728949AbfLPSA3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:00:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D12520717;
        Mon, 16 Dec 2019 18:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519229;
        bh=jCcds+R4TRriDObhC7+3/nn/Q7KoNi9RwFqQibwtl3U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I/td3XiSK1g05GDL+wyhlKB+2Kjxx68euDMPorGbJUNc/GloYu0u0dcz076txJund
         D6B7ZD25Nw8dejX6u2JNGWUmM3U70iUeOKuPT6HXAklgs98yuTottK339IyBrLdkDl
         yVCBxZOBPi1C1pVW/A2OlBTHRrCNnYg78gaKSWRg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "H. Nikolaus Schaller" <hns@goldelico.com>,
        Tony Lindgren <tony@atomide.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 248/267] omap: pdata-quirks: remove openpandora quirks for mmc3 and wl1251
Date:   Mon, 16 Dec 2019 18:49:34 +0100
Message-Id: <20191216174916.176895952@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
References: <20191216174848.701533383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: H. Nikolaus Schaller <hns@goldelico.com>

[ Upstream commit 2398c41d64321e62af54424fd399964f3d48cdc2 ]

With a wl1251 child node of mmc3 in the device tree decoded
in omap_hsmmc.c to handle special wl1251 initialization, we do
no longer need to instantiate the mmc3 through pdata quirks.

We also can remove the wlan regulator and reset/interrupt definitions
and do them through device tree.

Fixes: 81eef6ca9201 ("mmc: omap_hsmmc: Use dma_request_chan() for requesting DMA channel")
Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
Cc: <stable@vger.kernel.org> # v4.7+
Acked-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap2/pdata-quirks.c | 93 ------------------------------
 1 file changed, 93 deletions(-)

diff --git a/arch/arm/mach-omap2/pdata-quirks.c b/arch/arm/mach-omap2/pdata-quirks.c
index 6b433fce65a5b..2477f6086de4b 100644
--- a/arch/arm/mach-omap2/pdata-quirks.c
+++ b/arch/arm/mach-omap2/pdata-quirks.c
@@ -307,108 +307,15 @@ static void __init omap3_logicpd_torpedo_init(void)
 }
 
 /* omap3pandora legacy devices */
-#define PANDORA_WIFI_IRQ_GPIO		21
-#define PANDORA_WIFI_NRESET_GPIO	23
 
 static struct platform_device pandora_backlight = {
 	.name	= "pandora-backlight",
 	.id	= -1,
 };
 
-static struct regulator_consumer_supply pandora_vmmc3_supply[] = {
-	REGULATOR_SUPPLY("vmmc", "omap_hsmmc.2"),
-};
-
-static struct regulator_init_data pandora_vmmc3 = {
-	.constraints = {
-		.valid_ops_mask		= REGULATOR_CHANGE_STATUS,
-	},
-	.num_consumer_supplies	= ARRAY_SIZE(pandora_vmmc3_supply),
-	.consumer_supplies	= pandora_vmmc3_supply,
-};
-
-static struct fixed_voltage_config pandora_vwlan = {
-	.supply_name		= "vwlan",
-	.microvolts		= 1800000, /* 1.8V */
-	.gpio			= PANDORA_WIFI_NRESET_GPIO,
-	.startup_delay		= 50000, /* 50ms */
-	.enable_high		= 1,
-	.init_data		= &pandora_vmmc3,
-};
-
-static struct platform_device pandora_vwlan_device = {
-	.name		= "reg-fixed-voltage",
-	.id		= 1,
-	.dev = {
-		.platform_data = &pandora_vwlan,
-	},
-};
-
-static void pandora_wl1251_init_card(struct mmc_card *card)
-{
-	/*
-	 * We have TI wl1251 attached to MMC3. Pass this information to
-	 * SDIO core because it can't be probed by normal methods.
-	 */
-	if (card->type == MMC_TYPE_SDIO || card->type == MMC_TYPE_SD_COMBO) {
-		card->quirks |= MMC_QUIRK_NONSTD_SDIO;
-		card->cccr.wide_bus = 1;
-		card->cis.vendor = 0x104c;
-		card->cis.device = 0x9066;
-		card->cis.blksize = 512;
-		card->cis.max_dtr = 24000000;
-		card->ocr = 0x80;
-	}
-}
-
-static struct omap2_hsmmc_info pandora_mmc3[] = {
-	{
-		.mmc		= 3,
-		.caps		= MMC_CAP_4_BIT_DATA | MMC_CAP_POWER_OFF_CARD,
-		.gpio_cd	= -EINVAL,
-		.gpio_wp	= -EINVAL,
-		.init_card	= pandora_wl1251_init_card,
-	},
-	{}	/* Terminator */
-};
-
-static void __init pandora_wl1251_init(void)
-{
-	struct wl1251_platform_data pandora_wl1251_pdata;
-	int ret;
-
-	memset(&pandora_wl1251_pdata, 0, sizeof(pandora_wl1251_pdata));
-
-	pandora_wl1251_pdata.power_gpio = -1;
-
-	ret = gpio_request_one(PANDORA_WIFI_IRQ_GPIO, GPIOF_IN, "wl1251 irq");
-	if (ret < 0)
-		goto fail;
-
-	pandora_wl1251_pdata.irq = gpio_to_irq(PANDORA_WIFI_IRQ_GPIO);
-	if (pandora_wl1251_pdata.irq < 0)
-		goto fail_irq;
-
-	pandora_wl1251_pdata.use_eeprom = true;
-	ret = wl1251_set_platform_data(&pandora_wl1251_pdata);
-	if (ret < 0)
-		goto fail_irq;
-
-	return;
-
-fail_irq:
-	gpio_free(PANDORA_WIFI_IRQ_GPIO);
-fail:
-	pr_err("wl1251 board initialisation failed\n");
-}
-
 static void __init omap3_pandora_legacy_init(void)
 {
 	platform_device_register(&pandora_backlight);
-	platform_device_register(&pandora_vwlan_device);
-	omap_hsmmc_init(pandora_mmc3);
-	omap_hsmmc_late_init(pandora_mmc3);
-	pandora_wl1251_init();
 }
 #endif /* CONFIG_ARCH_OMAP3 */
 
-- 
2.20.1



