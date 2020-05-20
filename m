Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19F341DB628
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 16:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727770AbgETOW3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 10:22:29 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:32936 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726964AbgETOW1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 May 2020 10:22:27 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPbv-00035Q-1O; Wed, 20 May 2020 15:22:19 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPbu-007DPM-BB; Wed, 20 May 2020 15:22:18 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Mark Brown" <broonie@kernel.org>,
        "Linus Walleij" <linus.walleij@linaro.org>,
        "Ulf Hansson" <ulf.hansson@linaro.org>,
        "Phil Elwell" <phil@raspberrypi.org>
Date:   Wed, 20 May 2020 15:13:47 +0100
Message-ID: <lsq.1589984008.694832487@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 19/99] mmc: spi: Toggle SPI polarity, do not hardcode it
In-Reply-To: <lsq.1589984008.673931885@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.84-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linus.walleij@linaro.org>

commit af3ed119329cf9690598c5a562d95dfd128e91d6 upstream.

The code in mmc_spi_initsequence() tries to send a burst with
high chipselect and for this reason hardcodes the device into
SPI_CS_HIGH.

This is not good because the SPI_CS_HIGH flag indicates
logical "asserted" CS not always the physical level. In
some cases the signal is inverted in the GPIO library and
in that case SPI_CS_HIGH is already set, and enforcing
SPI_CS_HIGH again will actually drive it low.

Instead of hard-coding this, toggle the polarity so if the
default is LOW it goes high to assert chipselect but if it
is already high then toggle it low instead.

Cc: Phil Elwell <phil@raspberrypi.org>
Reported-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20191204152749.12652-1-linus.walleij@linaro.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/mmc/host/mmc_spi.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/mmc/host/mmc_spi.c
+++ b/drivers/mmc/host/mmc_spi.c
@@ -1149,17 +1149,22 @@ static void mmc_spi_initsequence(struct
 	 * SPI protocol.  Another is that when chipselect is released while
 	 * the card returns BUSY status, the clock must issue several cycles
 	 * with chipselect high before the card will stop driving its output.
+	 *
+	 * SPI_CS_HIGH means "asserted" here. In some cases like when using
+	 * GPIOs for chip select, SPI_CS_HIGH is set but this will be logically
+	 * inverted by gpiolib, so if we want to ascertain to drive it high
+	 * we should toggle the default with an XOR as we do here.
 	 */
-	host->spi->mode |= SPI_CS_HIGH;
+	host->spi->mode ^= SPI_CS_HIGH;
 	if (spi_setup(host->spi) != 0) {
 		/* Just warn; most cards work without it. */
 		dev_warn(&host->spi->dev,
 				"can't change chip-select polarity\n");
-		host->spi->mode &= ~SPI_CS_HIGH;
+		host->spi->mode ^= SPI_CS_HIGH;
 	} else {
 		mmc_spi_readbytes(host, 18);
 
-		host->spi->mode &= ~SPI_CS_HIGH;
+		host->spi->mode ^= SPI_CS_HIGH;
 		if (spi_setup(host->spi) != 0) {
 			/* Wot, we can't get the same setup we had before? */
 			dev_err(&host->spi->dev,

