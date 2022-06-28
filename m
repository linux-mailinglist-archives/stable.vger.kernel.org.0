Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8343855CF6F
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243139AbiF1CTC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 22:19:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242142AbiF1CS6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 22:18:58 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28601237F6;
        Mon, 27 Jun 2022 19:18:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 717B9CE1E0E;
        Tue, 28 Jun 2022 02:18:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 087DAC341CA;
        Tue, 28 Jun 2022 02:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656382723;
        bh=0hOqHPa5ISSH1m2DSWd+ABVaKaIeDkCCQQKeVJWPqNE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hIxWuf8bgS5Y0BiAlS3nEq5G6uraqAaAx4zCcDys4V2ylEVD8Da2BcvspAp+nzOT4
         0o/NJyoSVVEE815oiDkp7IOZX01rMjQHyITbbRRDxwxt/Tkdt302AY0bEh8Io5Ial+
         frU3342L5yVPuwoX0E/54pRkpocI2OLxdizUNPd9PmQStkc/ciD8KX4o7FI4nR5ddj
         Z5tcJAvSuLDEDHgC0brY7R7wNIxyn01CKh/Ivp8mxsSOCczTjs+kBAEZFSaBdpJTK2
         q5RkPfUto5jd2177YGdFTXgfnML2R67uhNAMuJZlaEAMbJ46NydMqoRAqiTMYBlNwO
         S8nuqRQYEa5EQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lars-Peter Clausen <lars@metafoo.de>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 02/53] spi: cadence: Detect transmit FIFO depth
Date:   Mon, 27 Jun 2022 22:17:48 -0400
Message-Id: <20220628021839.594423-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220628021839.594423-1-sashal@kernel.org>
References: <20220628021839.594423-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lars-Peter Clausen <lars@metafoo.de>

[ Upstream commit 7b40322f7183a92c4303457528ae7cda571c60b9 ]

The depth of the transmit FIFO for the Cadence SPI controller is currently
hardcoded to 128. But the depth is a synthesis configuration parameter of
the core and can vary between different SoCs.

If the configured FIFO size is less than 128 the driver will busy loop in
the cdns_spi_fill_tx_fifo() function waiting for FIFO space to become
available.

Depending on the length and speed of the transfer it can spin for a
significant amount of time. The cdns_spi_fill_tx_fifo() function is called
from the drivers interrupt handler, so it can leave interrupts disabled for
a prolonged amount of time.

In addition the read FIFO will also overflow and data will be discarded.

To avoid this detect the actual size of the FIFO and use that rather than
the hardcoded value.

To detect the FIFO size the FIFO threshold register is used. The register
is sized so that it can hold FIFO size - 1 as its maximum value. Bits that
are not needed to hold the threshold value will always read 0. By writing
0xffff to the register and then reading back the value in the register we
get the FIFO size.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Link: https://lore.kernel.org/r/20220527091143.3780378-1-lars@metafoo.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-cadence.c | 27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-cadence.c b/drivers/spi/spi-cadence.c
index 90b18c32f859..32117722ae8d 100644
--- a/drivers/spi/spi-cadence.c
+++ b/drivers/spi/spi-cadence.c
@@ -93,9 +93,6 @@
 #define CDNS_SPI_ER_ENABLE	0x00000001 /* SPI Enable Bit Mask */
 #define CDNS_SPI_ER_DISABLE	0x0 /* SPI Disable Bit Mask */
 
-/* SPI FIFO depth in bytes */
-#define CDNS_SPI_FIFO_DEPTH	128
-
 /* Default number of chip select lines */
 #define CDNS_SPI_DEFAULT_NUM_CS		4
 
@@ -111,6 +108,7 @@
  * @rx_bytes:		Number of bytes requested
  * @dev_busy:		Device busy flag
  * @is_decoded_cs:	Flag for decoder property set or not
+ * @tx_fifo_depth:	Depth of the TX FIFO
  */
 struct cdns_spi {
 	void __iomem *regs;
@@ -124,6 +122,7 @@ struct cdns_spi {
 	int rx_bytes;
 	u8 dev_busy;
 	u32 is_decoded_cs;
+	unsigned int tx_fifo_depth;
 };
 
 /* Macros for the SPI controller read/write */
@@ -305,7 +304,7 @@ static void cdns_spi_fill_tx_fifo(struct cdns_spi *xspi)
 {
 	unsigned long trans_cnt = 0;
 
-	while ((trans_cnt < CDNS_SPI_FIFO_DEPTH) &&
+	while ((trans_cnt < xspi->tx_fifo_depth) &&
 	       (xspi->tx_bytes > 0)) {
 
 		/* When xspi in busy condition, bytes may send failed,
@@ -468,6 +467,24 @@ static int cdns_unprepare_transfer_hardware(struct spi_master *master)
 	return 0;
 }
 
+/**
+ * cdns_spi_detect_fifo_depth - Detect the FIFO depth of the hardware
+ * @xspi:	Pointer to the cdns_spi structure
+ *
+ * The depth of the TX FIFO is a synthesis configuration parameter of the SPI
+ * IP. The FIFO threshold register is sized so that its maximum value can be the
+ * FIFO size - 1. This is used to detect the size of the FIFO.
+ */
+static void cdns_spi_detect_fifo_depth(struct cdns_spi *xspi)
+{
+	/* The MSBs will get truncated giving us the size of the FIFO */
+	cdns_spi_write(xspi, CDNS_SPI_THLD, 0xffff);
+	xspi->tx_fifo_depth = cdns_spi_read(xspi, CDNS_SPI_THLD) + 1;
+
+	/* Reset to default */
+	cdns_spi_write(xspi, CDNS_SPI_THLD, 0x1);
+}
+
 /**
  * cdns_spi_probe - Probe method for the SPI driver
  * @pdev:	Pointer to the platform_device structure
@@ -540,6 +557,8 @@ static int cdns_spi_probe(struct platform_device *pdev)
 	if (ret < 0)
 		xspi->is_decoded_cs = 0;
 
+	cdns_spi_detect_fifo_depth(xspi);
+
 	/* SPI controller initializations */
 	cdns_spi_init_hw(xspi);
 
-- 
2.35.1

