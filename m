Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6404FDD01B
	for <lists+stable@lfdr.de>; Fri, 18 Oct 2019 22:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2443457AbfJRU1A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 16:27:00 -0400
Received: from mo4-p04-ob.smtp.rzone.de ([85.215.255.120]:24615 "EHLO
        mo4-p04-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2443417AbfJRU07 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Oct 2019 16:26:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1571430348;
        s=strato-dkim-0002; d=goldelico.com;
        h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=6hoERFZim5hfupsdAdPBbE1aZZcYzc6LWGFqjHWxpZ4=;
        b=Ig5o8sR8AWMlvEgVOsRIwbX/DU3ldlDS/wJokmgT0twkUNAYMfaO0Bi5vl+3/2tC+l
        0HRAVj2rX+e+vd0hPvd04FmEAfaPIgjOSVTdH0LJ9NxXdAQ7pW4wK8T57U8kIQd8OClk
        1Uipn4smX2mvx8SjGuZfmK7Bh4AbfLklzkmFvK1UlkYi6LYKXRrL1ux1D+j7ivywqhMR
        YDJuexgu8zZLJ4YtV8htM9Yo7ibHOQE0+tssrVpHHryS2jquhJA8jQ/jJiiOf5hVTxco
        cmdxKNe8KvWngmsSo+Ge1WWvC4iFfm0dNZATRaKAgU5U/IHFPdecTyCbhjZHChPF+9lg
        lLKw==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMhflhwDubTJ9o1mfYzBGHXH6F3CFF60="
X-RZG-CLASS-ID: mo00
Received: from iMac.fritz.box
        by smtp.strato.de (RZmta 44.28.1 DYNA|AUTH)
        with ESMTPSA id R0b2a8v9IKPaDUr
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Fri, 18 Oct 2019 22:25:36 +0200 (CEST)
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
To:     =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@armlinux.org.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        David Sterba <dsterba@suse.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Petr Mladek <pmladek@suse.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "H. Nikolaus Schaller" <hns@goldelico.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Yangtao Li <tiny.windzz@gmail.com>,
        Alexios Zavras <alexios.zavras@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Allison Randal <allison@lohutok.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc:     linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mmc@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, letux-kernel@openphoenux.org,
        kernel@pyra-handheld.com, stable@vger.kernel.org
Subject: [PATCH 5/9] omap: pdata-quirks: remove openpandora quirks for mmc3 and wl1251
Date:   Fri, 18 Oct 2019 22:25:26 +0200
Message-Id: <63f59daa6b6e079905ff128b88282cf2c72e3540.1571430329.git.hns@goldelico.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1571430329.git.hns@goldelico.com>
References: <cover.1571430329.git.hns@goldelico.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

With a wl1251 child node of mmc3 in the device tree decoded
in omap_hsmmc.c to handle special wl1251 initialization, we do
no longer need to instantiate the mmc3 through pdata quirks.

We also can remove the wlan regulator and reset/interrupt definitions
and do them through device tree.

Fixes: 81eef6ca9201 ("mmc: omap_hsmmc: Use dma_request_chan() for requesting DMA channel")

Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
Cc: <stable@vger.kernel.org> # 4.7.0
---
 arch/arm/mach-omap2/pdata-quirks.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-omap2/pdata-quirks.c b/arch/arm/mach-omap2/pdata-quirks.c
index d942a3357090..231bf4dc55fa 100644
--- a/arch/arm/mach-omap2/pdata-quirks.c
+++ b/arch/arm/mach-omap2/pdata-quirks.c
@@ -304,14 +304,17 @@ static void __init omap3_logicpd_torpedo_init(void)
 }
 
 /* omap3pandora legacy devices */
-#define PANDORA_WIFI_IRQ_GPIO		21
-#define PANDORA_WIFI_NRESET_GPIO	23
 
 static struct platform_device pandora_backlight = {
 	.name	= "pandora-backlight",
 	.id	= -1,
 };
 
+#if OLD_WL1251
+
+#define PANDORA_WIFI_IRQ_GPIO		21
+#define PANDORA_WIFI_NRESET_GPIO	23
+
 static struct regulator_consumer_supply pandora_vmmc3_supply[] = {
 	REGULATOR_SUPPLY("vmmc", "omap_hsmmc.2"),
 };
@@ -407,15 +410,11 @@ static void __init pandora_wl1251_init(void)
 fail:
 	pr_err("wl1251 board initialisation failed\n");
 }
+#endif
 
 static void __init omap3_pandora_legacy_init(void)
 {
 	platform_device_register(&pandora_backlight);
-	gpiod_add_lookup_table(&pandora_vwlan_gpiod_table);
-	platform_device_register(&pandora_vwlan_device);
-	omap_hsmmc_init(pandora_mmc3);
-	omap_hsmmc_late_init(pandora_mmc3);
-	pandora_wl1251_init();
 }
 #endif /* CONFIG_ARCH_OMAP3 */
 
-- 
2.19.1

