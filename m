Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC400157A71
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:22:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728714AbgBJMhU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:37:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:58778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728711AbgBJMhU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:37:20 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F405520838;
        Mon, 10 Feb 2020 12:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338240;
        bh=HRQkpN1Mvq7ucN4kQwhBOlr26goTcPiQ9hquQc7J3I8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pc5EY4Bt+tKe+BlApPFAUCyyo/LW1ROzNfDhkCaRD4TSX2PutiYjyFNVRzHNGGZKh
         HU3NT1LFahubSQwOvUt25u44hv+mCHvkLGOgtGX3R5lvGprlcBbF1m9Nb6GU20pChM
         zd8lQtzEIjVZC1oPgsb7E/v3CmVh6y1cW+JNUGPY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Phil Elwell <phil@raspberrypi.org>,
        Mark Brown <broonie@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.4 085/309] mmc: spi: Toggle SPI polarity, do not hardcode it
Date:   Mon, 10 Feb 2020 04:30:41 -0800
Message-Id: <20200210122414.039001849@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/mmc_spi.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/mmc/host/mmc_spi.c
+++ b/drivers/mmc/host/mmc_spi.c
@@ -1134,17 +1134,22 @@ static void mmc_spi_initsequence(struct
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


