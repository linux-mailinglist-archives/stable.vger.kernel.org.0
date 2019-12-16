Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17B481218B1
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:46:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728099AbfLPR6E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 12:58:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:57520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728569AbfLPR6D (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 12:58:03 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C84D0205ED;
        Mon, 16 Dec 2019 17:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519083;
        bh=lYslgjAVeGe36565v2xmC1jA/tC+3dsA1uoVGkImutY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dT5lAuKAu4VSlSxfGRE0Evv/6tUXYmd8lNgXnm9dh1WT5+YraJrsX4wI2iCcZvZX6
         kkoohqG4nvXUcoQTtu1+S9OV7OZNosjSnTHZKHsDHUZSfaeS2mpRmKtD6Gn+hH8qPT
         I4zpO4VV9gbJ3bFO2VJ0n1x/3Bd60Eg9UPIJ1n5A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.14 148/267] spi: atmel: Fix CS high support
Date:   Mon, 16 Dec 2019 18:47:54 +0100
Message-Id: <20191216174910.582230758@linuxfoundation.org>
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

From: Gregory CLEMENT <gregory.clement@bootlin.com>

commit 7cbb16b2122c09f2ae393a1542fed628505b9da6 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-atmel.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/spi/spi-atmel.c
+++ b/drivers/spi/spi-atmel.c
@@ -1150,10 +1150,8 @@ static int atmel_spi_setup(struct spi_de
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
 


