Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6F413EC25
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394182AbgAPRob (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:44:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:35530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394179AbgAPRob (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:44:31 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86B8324748;
        Thu, 16 Jan 2020 17:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196670;
        bh=JjKzewG3WJ8YyYk2XXWWjPF7f9+Ifwp2QYTgE0cFhk4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ELPkryr8XSZsHWx0EkxisEGKvWIspNl2fEr6H5nTGcLgY0hHECqFlLIuPiVhKSxBd
         c4eTCwRAqsykijife9Srcgr3wLRJ19akgjRV1kWnnPp0ea/nUn5feK3N+LKxWQZjzc
         KpndDoIs19llyYxKAf15aJRa8xuWBvyj/0h4Ge+g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Martin Sperl <kernel@martin.sperl.org>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.4 071/174] spi: bcm2835aux: fix driver to not allow 65535 (=-1) cs-gpios
Date:   Thu, 16 Jan 2020 12:41:08 -0500
Message-Id: <20200116174251.24326-71-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116174251.24326-1-sashal@kernel.org>
References: <20200116174251.24326-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index ca655593c5e0..1cedd640705f 100644
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

