Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCDA5DCD7A
	for <lists+stable@lfdr.de>; Fri, 18 Oct 2019 20:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505823AbfJRSIX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 14:08:23 -0400
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:45250 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2505749AbfJRSHP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Oct 2019 14:07:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=Date:Message-Id:In-Reply-To:
        Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:References:
        List-Id:List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:
        List-Archive; bh=KLzPw8Xsa4mTj7W5XGM0fv889qZfAC//m7Lpyu4FikE=; b=dndlkP61ea9f
        ZlOWbCDTs6GOupq8DvM97k1zxXnTYb0YNyn0gvk/FVY4yq+LBMtGmIn1S58/J0crbGaH0lxt/Hy6J
        wg23RM1E2DAfpnwG+snGzmF07sV0iblSD3r10YILz2HFyJjAdlYlPUniARWAZWNYbYCxOzpL/NPCr
        2FkV0=;
Received: from cpc102320-sgyl38-2-0-cust46.18-2.cable.virginm.net ([82.37.168.47] helo=ypsilon.sirena.org.uk)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <broonie@sirena.co.uk>)
        id 1iLWeb-0004HC-D6; Fri, 18 Oct 2019 18:07:09 +0000
Received: by ypsilon.sirena.org.uk (Postfix, from userid 1000)
        id D914D2741DEA; Fri, 18 Oct 2019 19:07:08 +0100 (BST)
From:   Mark Brown <broonie@kernel.org>
To:     Gregory CLEMENT <gregory.clement@bootlin.com>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-spi@vger.kernel.org,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Mark Brown <broonie@kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        <stable@vger.kernel.org>, stable@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Applied "spi: atmel: Fix CS high support" to the spi tree
In-Reply-To: <20191017141846.7523-3-gregory.clement@bootlin.com>
X-Patchwork-Hint: ignore
Message-Id: <20191018180708.D914D2741DEA@ypsilon.sirena.org.uk>
Date:   Fri, 18 Oct 2019 19:07:08 +0100 (BST)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch

   spi: atmel: Fix CS high support

has been applied to the spi tree at

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git for-5.5

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

From 7cbb16b2122c09f2ae393a1542fed628505b9da6 Mon Sep 17 00:00:00 2001
From: Gregory CLEMENT <gregory.clement@bootlin.com>
Date: Thu, 17 Oct 2019 16:18:41 +0200
Subject: [PATCH] spi: atmel: Fix CS high support

Until a few years ago, this driver was only used with CS GPIO. The
only exception is CS0 on AT91RM9200 which has to use internal CS. A
limitation of the internal CS is that they don't support CS High.

So by using the CS GPIO the CS high configuration was available except
for the particular case CS0 on RM9200.

When the support for the internal chip-select was added, the check of
the CS high support was not updated. Due to this the driver accepts
this configuration for all the SPI controller v2 (used by all SoCs
excepting the AT91RM9200) whereas the hardware doesn't support it for
infernal CS.

This patch fixes the test to match the hardware capabilities.

Fixes: 4820303480a1 ("spi: atmel: add support for the internal chip-select of the spi controller")
Cc: <stable@vger.kernel.org>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Link: https://lore.kernel.org/r/20191017141846.7523-3-gregory.clement@bootlin.com
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 drivers/spi/spi-atmel.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-atmel.c b/drivers/spi/spi-atmel.c
index 7a17c3e2a8ee..6e08ae539bc0 100644
--- a/drivers/spi/spi-atmel.c
+++ b/drivers/spi/spi-atmel.c
@@ -1176,10 +1176,8 @@ static int atmel_spi_setup(struct spi_device *spi)
 	as = spi_master_get_devdata(spi->master);
 
 	/* see notes above re chipselect */
-	if (!atmel_spi_is_v2(as)
-			&& spi->chip_select == 0
-			&& (spi->mode & SPI_CS_HIGH)) {
-		dev_dbg(&spi->dev, "setup: can't be active-high\n");
+	if (!as->use_cs_gpios && (spi->mode & SPI_CS_HIGH)) {
+		dev_warn(&spi->dev, "setup: non GPIO CS can't be active-high\n");
 		return -EINVAL;
 	}
 
-- 
2.20.1

