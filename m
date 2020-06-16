Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA571FBA9D
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 18:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731840AbgFPPnz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:43:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:33512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731861AbgFPPnw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:43:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BAE14208E4;
        Tue, 16 Jun 2020 15:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322231;
        bh=haZufumXIivprfu8VoTRQ4JkgkKWPzkC5c1Tw18T4LE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ecaak1kPskQaEN9eNgnkPUkVIjmWzrCabd54QhiYyZI4TNynz1lzec8neNGVa/v5o
         MkOckr+OKo4I5e3X8nQhEsbwWtngMbxlPF2/HIxW1OTN2D1kNM82jdjyW42XyXAsjE
         LMD5nqZepVYGczlhO04/FDD6Ak6GJ1Z6LI0/lWQs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 024/163] spi: dw: Fix native CS being unset
Date:   Tue, 16 Jun 2020 17:33:18 +0200
Message-Id: <20200616153108.047634478@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.849127260@linuxfoundation.org>
References: <20200616153106.849127260@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 9aea644ca17b94f82ad7fa767cbc4509642f4420 ]

Commit 6e0a32d6f376 ("spi: dw: Fix default polarity of native
chipselect") attempted to fix the problem when GPIO active-high
chip-select is utilized to communicate with some SPI slave. It fixed
the problem, but broke the normal native CS support. At the same time
the reversion commit ada9e3fcc175 ("spi: dw: Correct handling of native
chipselect") didn't solve the problem either, since it just inverted
the set_cs() polarity perception without taking into account that
CS-high might be applicable. Here is what is done to finally fix the
problem.

DW SPI controller demands any native CS being set in order to proceed
with data transfer. So in order to activate the SPI communications we
must set any bit in the Slave Select DW SPI controller register no
matter whether the platform requests the GPIO- or native CS. Preferably
it should be the bit corresponding to the SPI slave CS number. But
currently the dw_spi_set_cs() method activates the chip-select
only if the second argument is false. Since the second argument of the
set_cs callback is expected to be a boolean with "is-high" semantics
(actual chip-select pin state value), the bit in the DW SPI Slave
Select register will be set only if SPI core requests the driver
to set the CS in the low state. So this will work for active-low
GPIO-based CS case, and won't work for active-high CS setting
the bit when SPI core actually needs to deactivate the CS.

This commit fixes the problem for all described cases. So no matter
whether an SPI slave needs GPIO- or native-based CS with active-high
or low signal the corresponding bit will be set in SER.

Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Fixes: ada9e3fcc175 ("spi: dw: Correct handling of native chipselect")
Fixes: 6e0a32d6f376 ("spi: dw: Fix default polarity of native chipselect")
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Link: https://lore.kernel.org/r/20200515104758.6934-5-Sergey.Semin@baikalelectronics.ru
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-dw.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-dw.c b/drivers/spi/spi-dw.c
index 31e3f866d11a..6c2d8df50507 100644
--- a/drivers/spi/spi-dw.c
+++ b/drivers/spi/spi-dw.c
@@ -128,12 +128,20 @@ void dw_spi_set_cs(struct spi_device *spi, bool enable)
 {
 	struct dw_spi *dws = spi_controller_get_devdata(spi->controller);
 	struct chip_data *chip = spi_get_ctldata(spi);
+	bool cs_high = !!(spi->mode & SPI_CS_HIGH);
 
 	/* Chip select logic is inverted from spi_set_cs() */
 	if (chip && chip->cs_control)
 		chip->cs_control(!enable);
 
-	if (!enable)
+	/*
+	 * DW SPI controller demands any native CS being set in order to
+	 * proceed with data transfer. So in order to activate the SPI
+	 * communications we must set a corresponding bit in the Slave
+	 * Enable register no matter whether the SPI core is configured to
+	 * support active-high or active-low CS level.
+	 */
+	if (cs_high == enable)
 		dw_writel(dws, DW_SPI_SER, BIT(spi->chip_select));
 	else if (dws->cs_override)
 		dw_writel(dws, DW_SPI_SER, 0);
-- 
2.25.1



