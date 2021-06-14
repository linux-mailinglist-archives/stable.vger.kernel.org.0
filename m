Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1BE23A63B3
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:14:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235210AbhFNLQO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:16:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:45448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234266AbhFNLOL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:14:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6541B6145B;
        Mon, 14 Jun 2021 10:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667743;
        bh=qvfO6rWQb7mAwjSIEGjJoAIEmSpD/qlH9Ekye5y9Tew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q5VEC55CIUCYKkVYQGvju0T9/F0eBdkqIrDJN6ZSW0PqsPUThczkeOnLBZ9m6q2Ic
         xYtEju/MP7fCm4cnHqimYxIKlncMLSXYd6CjuqOql8+qDIBYCBKw5MHFcCVajaTI6H
         6wKy/E3ZzcYOCIXMf26Bm3v10hgALuhqb9rWkSZg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Joe Burmeister <joe.burmeister@devtank.co.uk>,
        Lukas Wunner <lukas@wunner.de>,
        Phil Elwell <phil@raspberrypi.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.12 056/173] spi: bcm2835: Fix out-of-bounds access with more than 4 slaves
Date:   Mon, 14 Jun 2021 12:26:28 +0200
Message-Id: <20210614102700.018037636@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

commit 13817d466eb8713a1ffd254f537402f091d48444 upstream.

Commit 571e31fa60b3 ("spi: bcm2835: Cache CS register value for
->prepare_message()") limited the number of slaves to 3 at compile-time.
The limitation was necessitated by a statically-sized array prepare_cs[]
in the driver private data which contains a per-slave register value.

The commit sought to enforce the limitation at run-time by setting the
controller's num_chipselect to 3:  Slaves with a higher chipselect are
rejected by spi_add_device().

However the commit neglected that num_chipselect only limits the number
of *native* chipselects.  If GPIO chipselects are specified in the
device tree for more than 3 slaves, num_chipselect is silently raised by
of_spi_get_gpio_numbers() and the result are out-of-bounds accesses to
the statically-sized array prepare_cs[].

As a bandaid fix which is backportable to stable, raise the number of
allowed slaves to 24 (which "ought to be enough for anybody"), enforce
the limitation on slave ->setup and revert num_chipselect to 3 (which is
the number of native chipselects supported by the controller).
An upcoming for-next commit will allow an arbitrary number of slaves.

Fixes: 571e31fa60b3 ("spi: bcm2835: Cache CS register value for ->prepare_message()")
Reported-by: Joe Burmeister <joe.burmeister@devtank.co.uk>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: stable@vger.kernel.org # v5.4+
Cc: Phil Elwell <phil@raspberrypi.com>
Link: https://lore.kernel.org/r/75854affc1923309fde05e47494263bde73e5592.1621703210.git.lukas@wunner.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-bcm2835.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/spi/spi-bcm2835.c
+++ b/drivers/spi/spi-bcm2835.c
@@ -68,7 +68,7 @@
 #define BCM2835_SPI_FIFO_SIZE		64
 #define BCM2835_SPI_FIFO_SIZE_3_4	48
 #define BCM2835_SPI_DMA_MIN_LENGTH	96
-#define BCM2835_SPI_NUM_CS		4   /* raise as necessary */
+#define BCM2835_SPI_NUM_CS		24  /* raise as necessary */
 #define BCM2835_SPI_MODE_BITS	(SPI_CPOL | SPI_CPHA | SPI_CS_HIGH \
 				| SPI_NO_CS | SPI_3WIRE)
 
@@ -1195,6 +1195,12 @@ static int bcm2835_spi_setup(struct spi_
 	struct gpio_chip *chip;
 	u32 cs;
 
+	if (spi->chip_select >= BCM2835_SPI_NUM_CS) {
+		dev_err(&spi->dev, "only %d chip-selects supported\n",
+			BCM2835_SPI_NUM_CS - 1);
+		return -EINVAL;
+	}
+
 	/*
 	 * Precalculate SPI slave's CS register value for ->prepare_message():
 	 * The driver always uses software-controlled GPIO chip select, hence
@@ -1288,7 +1294,7 @@ static int bcm2835_spi_probe(struct plat
 	ctlr->use_gpio_descriptors = true;
 	ctlr->mode_bits = BCM2835_SPI_MODE_BITS;
 	ctlr->bits_per_word_mask = SPI_BPW_MASK(8);
-	ctlr->num_chipselect = BCM2835_SPI_NUM_CS;
+	ctlr->num_chipselect = 3;
 	ctlr->setup = bcm2835_spi_setup;
 	ctlr->transfer_one = bcm2835_spi_transfer_one;
 	ctlr->handle_err = bcm2835_spi_handle_err;


