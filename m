Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74D34300C2B
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 20:21:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729034AbhAVSlF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 13:41:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:37760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728500AbhAVOVB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:21:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4BD623AC0;
        Fri, 22 Jan 2021 14:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611324903;
        bh=nnGMVQlWgPgHufE3sp+L4vPltDrGHjcCpMgLKlHs15E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hXxnsR5ih7oI7LREuHwof2R8F1xXFZy5g6nho2mT2trWKjDsMc4UFT79PaR4H8MRk
         B8rzR7egjWrDjr9dmdmexaBeEzt1/RTSSib72AAK1+S6oW0Iuc7mlCmzgtKsZYZtOz
         HOKU2VTNfZ3rbFXPwUYQUj54J8sd9nZXlAsFF7bY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Michael Hennerich <michael.hennerich@analog.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.14 50/50] spi: cadence: cache reference clock rate during probe
Date:   Fri, 22 Jan 2021 15:12:31 +0100
Message-Id: <20210122135737.224434145@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135735.176469491@linuxfoundation.org>
References: <20210122135735.176469491@linuxfoundation.org>
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
@@ -119,6 +119,7 @@ struct cdns_spi {
 	void __iomem *regs;
 	struct clk *ref_clk;
 	struct clk *pclk;
+	unsigned int clk_rate;
 	u32 speed_hz;
 	const u8 *txbuf;
 	u8 *rxbuf;
@@ -258,7 +259,7 @@ static void cdns_spi_config_clock_freq(s
 	u32 ctrl_reg, baud_rate_val;
 	unsigned long frequency;
 
-	frequency = clk_get_rate(xspi->ref_clk);
+	frequency = xspi->clk_rate;
 
 	ctrl_reg = cdns_spi_read(xspi, CDNS_SPI_CR);
 
@@ -628,8 +629,9 @@ static int cdns_spi_probe(struct platfor
 	master->auto_runtime_pm = true;
 	master->mode_bits = SPI_CPOL | SPI_CPHA;
 
+	xspi->clk_rate = clk_get_rate(xspi->ref_clk);
 	/* Set to default valid value */
-	master->max_speed_hz = clk_get_rate(xspi->ref_clk) / 4;
+	master->max_speed_hz = xspi->clk_rate / 4;
 	xspi->speed_hz = master->max_speed_hz;
 
 	master->bits_per_word_mask = SPI_BPW_MASK(8);


