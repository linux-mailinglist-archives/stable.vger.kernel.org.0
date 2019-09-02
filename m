Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B6AEA55D7
	for <lists+stable@lfdr.de>; Mon,  2 Sep 2019 14:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731561AbfIBMYT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Sep 2019 08:24:19 -0400
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:49596 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729893AbfIBMYS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Sep 2019 08:24:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=Date:Message-Id:In-Reply-To:
        Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:References:
        List-Id:List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:
        List-Archive; bh=oiBbowp/nc4jLB0rGwW6B211FgROjAwMe8fO/k0vtP4=; b=jDftagniYNft
        sizqWELp6chDsXiRL76YDnqT4CjErTM5I2OyFWM8Imdm6hTRnwyqvKykql135kvQYj5IfuEq4UI9d
        /JZ6DK37EkRh3j18IKTgXzlobtvuvQi2z27YZdDdbxMvPUB87Mwt8u7BSkH9vi4+ccxgW32loG/Zi
        xJLpc=;
Received: from cpc102320-sgyl38-2-0-cust46.18-2.cable.virginm.net ([82.37.168.47] helo=ypsilon.sirena.org.uk)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <broonie@sirena.co.uk>)
        id 1i4lNO-0003Cd-Ap; Mon, 02 Sep 2019 12:24:06 +0000
Received: by ypsilon.sirena.org.uk (Postfix, from userid 1000)
        id D15402742CCB; Mon,  2 Sep 2019 13:24:05 +0100 (BST)
From:   Mark Brown <broonie@kernel.org>
To:     Alexander Sverdlin <alexander.sverdlin@gmail.com>
Cc:     Hartley Sweeten <hsweeten@visionengravers.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        linux-spi@vger.kernel.org, Lukasz Majewski <lukma@denx.de>,
        Mark Brown <broonie@kernel.org>,
        Russell King <linux@armlinux.org.uk>, stable@vger.kernel.org
Subject: Applied "spi: ep93xx: Repair SPI CS lookup tables" to the spi tree
In-Reply-To: <20190831180402.10008-1-alexander.sverdlin@gmail.com>
X-Patchwork-Hint: ignore
Message-Id: <20190902122405.D15402742CCB@ypsilon.sirena.org.uk>
Date:   Mon,  2 Sep 2019 13:24:05 +0100 (BST)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch

   spi: ep93xx: Repair SPI CS lookup tables

has been applied to the spi tree at

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git for-5.4

All being well this means that it will be integrated into the linux-next
tree (usually sometime in the next 24 hours) and sent to Linus during
the next merge window (or sooner if it is a bug fix), however if
problems are discovered then the patch may be dropped or reverted.  

You may get further e-mails resulting from automated or manual testing
and review of the tree, please engage with people reporting problems and
send followup patches addressing any issues that are reported if needed.

If any updates are required or you are submitting further changes they
should be sent as incremental updates against current git, existing
patches will not be replaced.

Please add any relevant lists and maintainers to the CCs when replying
to this mail.

Thanks,
Mark

From 4fbc485324d2975c54201091dfad0a7dd4902324 Mon Sep 17 00:00:00 2001
From: Alexander Sverdlin <alexander.sverdlin@gmail.com>
Date: Sat, 31 Aug 2019 20:04:02 +0200
Subject: [PATCH] spi: ep93xx: Repair SPI CS lookup tables

The actual device name of the SPI controller being registered on EP93xx is
"spi0" (as seen by gpiod_find_lookup_table()). This patch fixes all
relevant lookup tables and the following failure (seen on EDB9302):

ep93xx-spi ep93xx-spi.0: failed to register SPI master
ep93xx-spi: probe of ep93xx-spi.0 failed with error -22

Fixes: 1dfbf334f1236 ("spi: ep93xx: Convert to use CS GPIO descriptors")
Cc: stable@vger.kernel.org
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@gmail.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Lukasz Majewski <lukma@denx.de>
Link: https://lore.kernel.org/r/20190831180402.10008-1-alexander.sverdlin@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm/mach-ep93xx/edb93xx.c       | 2 +-
 arch/arm/mach-ep93xx/simone.c        | 2 +-
 arch/arm/mach-ep93xx/ts72xx.c        | 4 ++--
 arch/arm/mach-ep93xx/vision_ep9307.c | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-ep93xx/edb93xx.c b/arch/arm/mach-ep93xx/edb93xx.c
index 1f0da76a39de..7b7280c21ee0 100644
--- a/arch/arm/mach-ep93xx/edb93xx.c
+++ b/arch/arm/mach-ep93xx/edb93xx.c
@@ -103,7 +103,7 @@ static struct spi_board_info edb93xx_spi_board_info[] __initdata = {
 };
 
 static struct gpiod_lookup_table edb93xx_spi_cs_gpio_table = {
-	.dev_id = "ep93xx-spi.0",
+	.dev_id = "spi0",
 	.table = {
 		GPIO_LOOKUP("A", 6, "cs", GPIO_ACTIVE_LOW),
 		{ },
diff --git a/arch/arm/mach-ep93xx/simone.c b/arch/arm/mach-ep93xx/simone.c
index e2658e22bba1..8a53b74dc4b2 100644
--- a/arch/arm/mach-ep93xx/simone.c
+++ b/arch/arm/mach-ep93xx/simone.c
@@ -73,7 +73,7 @@ static struct spi_board_info simone_spi_devices[] __initdata = {
  * v1.3 parts will still work, since the signal on SFRMOUT is automatic.
  */
 static struct gpiod_lookup_table simone_spi_cs_gpio_table = {
-	.dev_id = "ep93xx-spi.0",
+	.dev_id = "spi0",
 	.table = {
 		GPIO_LOOKUP("A", 1, "cs", GPIO_ACTIVE_LOW),
 		{ },
diff --git a/arch/arm/mach-ep93xx/ts72xx.c b/arch/arm/mach-ep93xx/ts72xx.c
index 582e06e104fd..e0e1b11032f1 100644
--- a/arch/arm/mach-ep93xx/ts72xx.c
+++ b/arch/arm/mach-ep93xx/ts72xx.c
@@ -267,7 +267,7 @@ static struct spi_board_info bk3_spi_board_info[] __initdata = {
  * goes through CPLD
  */
 static struct gpiod_lookup_table bk3_spi_cs_gpio_table = {
-	.dev_id = "ep93xx-spi.0",
+	.dev_id = "spi0",
 	.table = {
 		GPIO_LOOKUP("F", 3, "cs", GPIO_ACTIVE_LOW),
 		{ },
@@ -316,7 +316,7 @@ static struct spi_board_info ts72xx_spi_devices[] __initdata = {
 };
 
 static struct gpiod_lookup_table ts72xx_spi_cs_gpio_table = {
-	.dev_id = "ep93xx-spi.0",
+	.dev_id = "spi0",
 	.table = {
 		/* DIO_17 */
 		GPIO_LOOKUP("F", 2, "cs", GPIO_ACTIVE_LOW),
diff --git a/arch/arm/mach-ep93xx/vision_ep9307.c b/arch/arm/mach-ep93xx/vision_ep9307.c
index a88a1d807b32..cbcba3136d74 100644
--- a/arch/arm/mach-ep93xx/vision_ep9307.c
+++ b/arch/arm/mach-ep93xx/vision_ep9307.c
@@ -242,7 +242,7 @@ static struct spi_board_info vision_spi_board_info[] __initdata = {
 };
 
 static struct gpiod_lookup_table vision_spi_cs_gpio_table = {
-	.dev_id = "ep93xx-spi.0",
+	.dev_id = "spi0",
 	.table = {
 		GPIO_LOOKUP_IDX("A", 6, "cs", 0, GPIO_ACTIVE_LOW),
 		GPIO_LOOKUP_IDX("A", 7, "cs", 1, GPIO_ACTIVE_LOW),
-- 
2.20.1

