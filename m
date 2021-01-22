Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F89B3005E6
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 15:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728677AbhAVOrR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 09:47:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:40744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728678AbhAVOZE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:25:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 906D623B17;
        Fri, 22 Jan 2021 14:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611325177;
        bh=4U5JF/s5J98tUNPv1C0yoy5sEEE66s76dmViGncccU8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s6m+RCn4cgfB+FryineSlnlxFuYpblMP+vgkZc0IuSdFRX973cVMd5twzx6P4EWKQ
         9ApQr8smvKeywRyRDqvD0JF7VH+kzYMKaMRqiLpOylVddsHMZWMZ7TkFQdpZF88veH
         KS2aWF/QEAw0HraGmYqeXQRsvG39dlcufg7BO/10=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Michael Hennerich <michael.hennerich@analog.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 43/43] spi: cadence: cache reference clock rate during probe
Date:   Fri, 22 Jan 2021 15:12:59 +0100
Message-Id: <20210122135737.404893408@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135735.652681690@linuxfoundation.org>
References: <20210122135735.652681690@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

commit 4d163ad79b155c71bf30366dc38f8d2502f78844 upstream.

The issue is that using SPI from a callback under the CCF lock will
deadlock, since this code uses clk_get_rate().

Fixes: c474b38665463 ("spi: Add driver for Cadence SPI controller")
Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
Link: https://lore.kernel.org/r/20210114154217.51996-1-alexandru.ardelean@analog.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-cadence.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/spi/spi-cadence.c
+++ b/drivers/spi/spi-cadence.c
@@ -115,6 +115,7 @@ struct cdns_spi {
 	void __iomem *regs;
 	struct clk *ref_clk;
 	struct clk *pclk;
+	unsigned int clk_rate;
 	u32 speed_hz;
 	const u8 *txbuf;
 	u8 *rxbuf;
@@ -250,7 +251,7 @@ static void cdns_spi_config_clock_freq(s
 	u32 ctrl_reg, baud_rate_val;
 	unsigned long frequency;
 
-	frequency = clk_get_rate(xspi->ref_clk);
+	frequency = xspi->clk_rate;
 
 	ctrl_reg = cdns_spi_read(xspi, CDNS_SPI_CR);
 
@@ -558,8 +559,9 @@ static int cdns_spi_probe(struct platfor
 	master->auto_runtime_pm = true;
 	master->mode_bits = SPI_CPOL | SPI_CPHA | SPI_CS_HIGH;
 
+	xspi->clk_rate = clk_get_rate(xspi->ref_clk);
 	/* Set to default valid value */
-	master->max_speed_hz = clk_get_rate(xspi->ref_clk) / 4;
+	master->max_speed_hz = xspi->clk_rate / 4;
 	xspi->speed_hz = master->max_speed_hz;
 
 	master->bits_per_word_mask = SPI_BPW_MASK(8);


