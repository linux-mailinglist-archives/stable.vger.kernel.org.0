Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2374A7001
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731097AbfICQfz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:35:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:49086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730904AbfICQ1j (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:27:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 367972343A;
        Tue,  3 Sep 2019 16:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567528058;
        bh=oaZmRc4FyOxGLfeMfooQb/7p67aLl5E2T6k9jg4Dg7U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z9kZiuLQIvmGc3x7H8Y41JqRNHjaWPerHqwJjp97qUteub48Zz+vGyICSQu25LP7H
         Cya10J91r3wpqKdMxFiLEmCanUERG0SvJUbv4xO8PN3QBSbGOj3CUa4akFaXD3zp9b
         a7ByNc2wKTJ0ZawqDyjGMsiNhSEFTtsUeJQ4QQLk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 074/167] spi: spi-gpio: fix SPI_CS_HIGH capability
Date:   Tue,  3 Sep 2019 12:23:46 -0400
Message-Id: <20190903162519.7136-74-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

[ Upstream commit b89fefda7d4e3a649129584d855be233c7465264 ]

spi-gpio is capable of dealing with active-high chip-selects.
Unfortunately, commit 4b859db2c606 ("spi: spi-gpio: add SPI_3WIRE
support") broke this by setting master->mode_bits, which overrides
the setting in the spi-bitbang code.  Fix this.

[Fixed a trivial conflict with SPI_3WIRE_HIZ support -- broonie]

Fixes: 4b859db2c606 ("spi: spi-gpio: add SPI_3WIRE support")
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-gpio.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/spi/spi-gpio.c b/drivers/spi/spi-gpio.c
index 088772ebef9bd..77838d8fd9bb6 100644
--- a/drivers/spi/spi-gpio.c
+++ b/drivers/spi/spi-gpio.c
@@ -410,7 +410,7 @@ static int spi_gpio_probe(struct platform_device *pdev)
 		return status;
 
 	master->bits_per_word_mask = SPI_BPW_RANGE_MASK(1, 32);
-	master->mode_bits = SPI_3WIRE | SPI_CPHA | SPI_CPOL;
+	master->mode_bits = SPI_3WIRE | SPI_CPHA | SPI_CPOL | SPI_CS_HIGH;
 	master->flags = master_flags;
 	master->bus_num = pdev->id;
 	/* The master needs to think there is a chipselect even if not connected */
@@ -437,7 +437,6 @@ static int spi_gpio_probe(struct platform_device *pdev)
 		spi_gpio->bitbang.txrx_word[SPI_MODE_3] = spi_gpio_spec_txrx_word_mode3;
 	}
 	spi_gpio->bitbang.setup_transfer = spi_bitbang_setup_transfer;
-	spi_gpio->bitbang.flags = SPI_CS_HIGH;
 
 	status = spi_bitbang_start(&spi_gpio->bitbang);
 	if (status)
-- 
2.20.1

