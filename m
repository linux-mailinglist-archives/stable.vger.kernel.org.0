Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A362814BB39
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:44:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728255AbgA1OKV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:10:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:59120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726697AbgA1OKU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:10:20 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 170C624681;
        Tue, 28 Jan 2020 14:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220619;
        bh=3iagYyoCa+nNB3Jidm/+3b53P4fbZ9mjjofOdLx9dlo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oGO7Hmjpfx2fsYR8yx6vYVaKxTSGOuNoXuQAqUi4/fV5rxKjJt4z8YakvNbVuCTPI
         Gk6lmJVLK4UKSDtS5KLWJoE40w3G74tfU2VCKgJbagC10jerN4ttjFz+M4f0HM6z+v
         rNAaAQJ1A2Uo1BrWRCHMdt+1lzh9ny6aSCnsHp0Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Sperl <kernel@martin.sperl.org>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 072/183] spi: bcm2835aux: fix driver to not allow 65535 (=-1) cs-gpios
Date:   Tue, 28 Jan 2020 15:04:51 +0100
Message-Id: <20200128135837.194143955@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135829.486060649@linuxfoundation.org>
References: <20200128135829.486060649@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Sperl <kernel@martin.sperl.org>

[ Upstream commit 509c583620e9053e43d611bf1614fc3d3abafa96 ]

The original driver by default defines num_chipselects as -1.
This actually allicates an array of 65535 entries in
of_spi_register_master.

There is a side-effect for buggy device trees that (contrary to
dt-binding documentation) have no cs-gpio defined.

This mode was never supported by the driver due to limitations
of native cs and additional code complexity and is explicitly
not stated to be implemented.

To keep backwards compatibility with such buggy DTs we limit
the number of chip_selects to 1, as for all practical purposes
it is only ever realistic to use a single chip select in
native cs mode without negative side-effects.

Fixes: 1ea29b39f4c812ec ("spi: bcm2835aux: add bcm2835 auxiliary spi device...")
Signed-off-by: Martin Sperl <kernel@martin.sperl.org>
Acked-by: Stefan Wahren <stefan.wahren@i2se.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-bcm2835aux.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-bcm2835aux.c b/drivers/spi/spi-bcm2835aux.c
index ca655593c5e0e..1cedd640705f3 100644
--- a/drivers/spi/spi-bcm2835aux.c
+++ b/drivers/spi/spi-bcm2835aux.c
@@ -390,7 +390,18 @@ static int bcm2835aux_spi_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, master);
 	master->mode_bits = BCM2835_AUX_SPI_MODE_BITS;
 	master->bits_per_word_mask = SPI_BPW_MASK(8);
-	master->num_chipselect = -1;
+	/* even though the driver never officially supported native CS
+	 * allow a single native CS for legacy DT support purposes when
+	 * no cs-gpio is configured.
+	 * Known limitations for native cs are:
+	 * * multiple chip-selects: cs0-cs2 are all simultaniously asserted
+	 *     whenever there is a transfer -  this even includes SPI_NO_CS
+	 * * SPI_CS_HIGH: is ignores - cs are always asserted low
+	 * * cs_change: cs is deasserted after each spi_transfer
+	 * * cs_delay_usec: cs is always deasserted one SCK cycle after
+	 *     a spi_transfer
+	 */
+	master->num_chipselect = 1;
 	master->transfer_one = bcm2835aux_spi_transfer_one;
 	master->handle_err = bcm2835aux_spi_handle_err;
 	master->dev.of_node = pdev->dev.of_node;
-- 
2.20.1



