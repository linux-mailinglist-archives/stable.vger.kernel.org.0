Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC8F812C89B
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:16:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733080AbfL2R4a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:56:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:46146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733075AbfL2R43 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:56:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF736208C4;
        Sun, 29 Dec 2019 17:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577642189;
        bh=S51rkQSe3fqX9zTUh2WQGGWKBoj1jAt3CYqQB7zmTNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FgW2cRBIVceVKf4zMdxeJGXoR6VNd6hZGvc4nRRGSXnp9pZLhw9L1xrJzeQxiNuvy
         bxP47fhOAKefsWCGQDnvI192IoI5lYNqG2ZgVh+3CnNAUVFPBaOYltTqN7I4B8pnER
         eFEx6Y9Fa34GsUOcLq0/FoZAr6EzPymqP/j3vkM4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 380/434] spi: cadence: Correct handling of native chipselect
Date:   Sun, 29 Dec 2019 18:27:13 +0100
Message-Id: <20191229172727.367467017@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 61acd19f9c56fa0809285346bd0bd4a926ab0da0 ]

To fix a regression on the Cadence SPI driver, this patch reverts
commit 6046f5407ff0 ("spi: cadence: Fix default polarity of native
chipselect").

This patch was not the correct fix for the issue. The SPI framework
calls the set_cs line with the logic level it desires on the chip select
line, as such the old is_high handling was correct. However, this was
broken by the fact that before commit 3e5ec1db8bfe ("spi: Fix SPI_CS_HIGH
setting when using native and GPIO CS") all controllers that offered
the use of a GPIO chip select had SPI_CS_HIGH applied, even for hardware
chip selects. This caused the value passed into the driver to be inverted.
Which unfortunately makes it look like a logical enable the chip select
value.

Since the core was corrected to not unconditionally apply SPI_CS_HIGH,
the Cadence driver, whilst using the hardware chip select, will deselect
the chip select every time we attempt to communicate with the device,
which results in failed communications.

Fixes: 3e5ec1db8bfe ("spi: Fix SPI_CS_HIGH setting when using native and GPIO CS")
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20191126164140.6240-1-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-cadence.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-cadence.c b/drivers/spi/spi-cadence.c
index c36587b42e95..82a0ee09cbe1 100644
--- a/drivers/spi/spi-cadence.c
+++ b/drivers/spi/spi-cadence.c
@@ -168,16 +168,16 @@ static void cdns_spi_init_hw(struct cdns_spi *xspi)
 /**
  * cdns_spi_chipselect - Select or deselect the chip select line
  * @spi:	Pointer to the spi_device structure
- * @enable:	Select (1) or deselect (0) the chip select line
+ * @is_high:	Select(0) or deselect (1) the chip select line
  */
-static void cdns_spi_chipselect(struct spi_device *spi, bool enable)
+static void cdns_spi_chipselect(struct spi_device *spi, bool is_high)
 {
 	struct cdns_spi *xspi = spi_master_get_devdata(spi->master);
 	u32 ctrl_reg;
 
 	ctrl_reg = cdns_spi_read(xspi, CDNS_SPI_CR);
 
-	if (!enable) {
+	if (is_high) {
 		/* Deselect the slave */
 		ctrl_reg |= CDNS_SPI_CR_SSCTRL;
 	} else {
-- 
2.20.1



