Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2ACE3147B17
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:42:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731547AbgAXJkj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:40:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:38018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732473AbgAXJkh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:40:37 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F577208C4;
        Fri, 24 Jan 2020 09:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579858836;
        bh=m3PiA4eOlYD/JMenRGCtmDRxVjyUho6w+RWUFmixReU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xZKiEyKKiIQ9cWPWYhv+mKSqM46Y/oIilb9IL5+rEc35VwP1q93UdEGGsvv9sZ0TK
         wR2ixdp5a1Kkjp3sqebEhajaX2UEo7zyCuhvPeh9I5Z7Ah9mXtTC15ReSH+xwwvkZk
         kyLHcRkRNYWWdGbAKUYAu06utW2G/jkumicTLc1A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, devicetree@vger.kernel.org,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Adam Ford <aford173@gmail.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Tero Kristo <t-kristo@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Rob Herring <robh@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 054/102] hwrng: omap3-rom - Fix missing clock by probing with device tree
Date:   Fri, 24 Jan 2020 10:30:55 +0100
Message-Id: <20200124092814.500566562@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092806.004582306@linuxfoundation.org>
References: <20200124092806.004582306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 0c0ef9ea6f3f0d5979dc7b094b0a184c1a94716b ]

Commit 0ed266d7ae5e ("clk: ti: omap3: cleanup unnecessary clock aliases")
removed old omap3 clock framework aliases but caused omap3-rom-rng to
stop working with clock not found error.

Based on discussions on the mailing list it was requested by Tero Kristo
that it would be best to fix this issue by probing omap3-rom-rng using
device tree to provide a proper clk property. The other option would be
to add back the missing clock alias, but that does not help moving things
forward with removing old legacy platform_data.

Let's also add a proper device tree binding and keep it together with
the fix.

Cc: devicetree@vger.kernel.org
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Adam Ford <aford173@gmail.com>
Cc: Pali Rohár <pali.rohar@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: Tero Kristo <t-kristo@ti.com>
Fixes: 0ed266d7ae5e ("clk: ti: omap3: cleanup unnecessary clock aliases")
Reported-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Acked-by: Rob Herring <robh@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../devicetree/bindings/rng/omap3_rom_rng.txt | 27 +++++++++++++++++++
 arch/arm/boot/dts/omap3-n900.dts              |  6 +++++
 arch/arm/mach-omap2/pdata-quirks.c            | 12 +--------
 drivers/char/hw_random/omap3-rom-rng.c        | 17 ++++++++++--
 4 files changed, 49 insertions(+), 13 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/rng/omap3_rom_rng.txt

diff --git a/Documentation/devicetree/bindings/rng/omap3_rom_rng.txt b/Documentation/devicetree/bindings/rng/omap3_rom_rng.txt
new file mode 100644
index 0000000000000..f315c9723bd2a
--- /dev/null
+++ b/Documentation/devicetree/bindings/rng/omap3_rom_rng.txt
@@ -0,0 +1,27 @@
+OMAP ROM RNG driver binding
+
+Secure SoCs may provide RNG via secure ROM calls like Nokia N900 does. The
+implementation can depend on the SoC secure ROM used.
+
+- compatible:
+	Usage: required
+	Value type: <string>
+	Definition: must be "nokia,n900-rom-rng"
+
+- clocks:
+	Usage: required
+	Value type: <prop-encoded-array>
+	Definition: reference to the the RNG interface clock
+
+- clock-names:
+	Usage: required
+	Value type: <stringlist>
+	Definition: must be "ick"
+
+Example:
+
+	rom_rng: rng {
+		compatible = "nokia,n900-rom-rng";
+		clocks = <&rng_ick>;
+		clock-names = "ick";
+	};
diff --git a/arch/arm/boot/dts/omap3-n900.dts b/arch/arm/boot/dts/omap3-n900.dts
index 84a5ade1e865b..63659880eeb3f 100644
--- a/arch/arm/boot/dts/omap3-n900.dts
+++ b/arch/arm/boot/dts/omap3-n900.dts
@@ -155,6 +155,12 @@
 		pwms = <&pwm9 0 26316 0>; /* 38000 Hz */
 	};
 
+	rom_rng: rng {
+		compatible = "nokia,n900-rom-rng";
+		clocks = <&rng_ick>;
+		clock-names = "ick";
+	};
+
 	/* controlled (enabled/disabled) directly by bcm2048 and wl1251 */
 	vctcxo: vctcxo {
 		compatible = "fixed-clock";
diff --git a/arch/arm/mach-omap2/pdata-quirks.c b/arch/arm/mach-omap2/pdata-quirks.c
index 33688e1d9acf9..247e3f8acffe6 100644
--- a/arch/arm/mach-omap2/pdata-quirks.c
+++ b/arch/arm/mach-omap2/pdata-quirks.c
@@ -268,14 +268,6 @@ static void __init am3517_evm_legacy_init(void)
 	am35xx_emac_reset();
 }
 
-static struct platform_device omap3_rom_rng_device = {
-	.name		= "omap3-rom-rng",
-	.id		= -1,
-	.dev	= {
-		.platform_data	= rx51_secure_rng_call,
-	},
-};
-
 static void __init nokia_n900_legacy_init(void)
 {
 	hsmmc2_internal_input_clk();
@@ -291,9 +283,6 @@ static void __init nokia_n900_legacy_init(void)
 			pr_warn("RX-51: Not enabling ARM errata 430973 workaround\n");
 			pr_warn("Thumb binaries may crash randomly without this workaround\n");
 		}
-
-		pr_info("RX-51: Registering OMAP3 HWRNG device\n");
-		platform_device_register(&omap3_rom_rng_device);
 	}
 }
 
@@ -538,6 +527,7 @@ static struct of_dev_auxdata omap_auxdata_lookup[] = {
 	OF_DEV_AUXDATA("ti,davinci_mdio", 0x5c030000, "davinci_mdio.0", NULL),
 	OF_DEV_AUXDATA("ti,am3517-emac", 0x5c000000, "davinci_emac.0",
 		       &am35xx_emac_pdata),
+	OF_DEV_AUXDATA("nokia,n900-rom-rng", 0, NULL, rx51_secure_rng_call),
 	/* McBSP modules with sidetone core */
 #if IS_ENABLED(CONFIG_SND_SOC_OMAP_MCBSP)
 	OF_DEV_AUXDATA("ti,omap3-mcbsp", 0x49022000, "49022000.mcbsp", &mcbsp_pdata),
diff --git a/drivers/char/hw_random/omap3-rom-rng.c b/drivers/char/hw_random/omap3-rom-rng.c
index 648e39ce6bd95..8df3cad7c97ae 100644
--- a/drivers/char/hw_random/omap3-rom-rng.c
+++ b/drivers/char/hw_random/omap3-rom-rng.c
@@ -20,6 +20,8 @@
 #include <linux/workqueue.h>
 #include <linux/clk.h>
 #include <linux/err.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
 #include <linux/platform_device.h>
 
 #define RNG_RESET			0x01
@@ -86,14 +88,18 @@ static int omap3_rom_rng_read(struct hwrng *rng, void *data, size_t max, bool w)
 
 static struct hwrng omap3_rom_rng_ops = {
 	.name		= "omap3-rom",
-	.read		= omap3_rom_rng_read,
 };
 
 static int omap3_rom_rng_probe(struct platform_device *pdev)
 {
 	int ret = 0;
 
-	pr_info("initializing\n");
+	omap3_rom_rng_ops.read = of_device_get_match_data(&pdev->dev);
+	if (!omap3_rom_rng_ops.read) {
+		dev_err(&pdev->dev, "missing rom code handler\n");
+
+		return -ENODEV;
+	}
 
 	omap3_rom_rng_call = pdev->dev.platform_data;
 	if (!omap3_rom_rng_call) {
@@ -126,9 +132,16 @@ static int omap3_rom_rng_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static const struct of_device_id omap_rom_rng_match[] = {
+	{ .compatible = "nokia,n900-rom-rng", .data = omap3_rom_rng_read, },
+	{ /* sentinel */ },
+};
+MODULE_DEVICE_TABLE(of, omap_rom_rng_match);
+
 static struct platform_driver omap3_rom_rng_driver = {
 	.driver = {
 		.name		= "omap3-rom-rng",
+		.of_match_table = omap_rom_rng_match,
 	},
 	.probe		= omap3_rom_rng_probe,
 	.remove		= omap3_rom_rng_remove,
-- 
2.20.1



