Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2F929C1CC
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:28:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S369858AbgJ0RZx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:25:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:53648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2900585AbgJ0Ox0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:53:26 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 394DA22264;
        Tue, 27 Oct 2020 14:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810402;
        bh=O1pF7XEIJ80cDTIUmxUVO0dW9tmpz7MfmVvGW/tU8vI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wk3gHDUofs6lzfwe2p6w0tguA623hUxHhu4YW6M2XywwJCf8RSR0j/vVeUGE57Cta
         RcZrscfQztiwAmqF/dGvrgT5c31HzoGv9eOA/cY2TcmKfVIr58iIjMF5v0xFUDOUHA
         jJ0WQWhNra5JJ41BXuQ5rosyOdWiSRRe81AGMlio=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eddie James <eajames@linux.ibm.com>,
        Joel Stanley <joel@jms.id.au>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 127/633] spi: fsi: Implement restricted size for certain controllers
Date:   Tue, 27 Oct 2020 14:47:50 +0100
Message-Id: <20201027135528.657277425@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eddie James <eajames@linux.ibm.com>

[ Upstream commit 49c9fc1d7c101eceaddb655e4f0e062b0c8f403b ]

Some of the FSI-attached SPI controllers cannot use the loop command in
programming the sequencer due to security requirements. Check the
devicetree compatibility that indicates this condition and restrict the
size for these controllers. Also, add more transfers directly in the
sequence up to the length of the sequence register.

Fixes: bbb6b2f9865b ("spi: Add FSI-attached SPI controller driver")
Signed-off-by: Eddie James <eajames@linux.ibm.com>
Reviewed-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Joel Stanley <joel@jms.id.au>
Link: https://lore.kernel.org/r/20200909222857.28653-6-eajames@linux.ibm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsi.c | 65 +++++++++++++++++++++++++++++++++++--------
 1 file changed, 53 insertions(+), 12 deletions(-)

diff --git a/drivers/spi/spi-fsi.c b/drivers/spi/spi-fsi.c
index bb18b407cdcf3..ef5e0826a53c3 100644
--- a/drivers/spi/spi-fsi.c
+++ b/drivers/spi/spi-fsi.c
@@ -24,7 +24,8 @@
 
 #define SPI_FSI_BASE			0x70000
 #define SPI_FSI_INIT_TIMEOUT_MS		1000
-#define SPI_FSI_MAX_TRANSFER_SIZE	2048
+#define SPI_FSI_MAX_XFR_SIZE		2048
+#define SPI_FSI_MAX_XFR_SIZE_RESTRICTED	32
 
 #define SPI_FSI_ERROR			0x0
 #define SPI_FSI_COUNTER_CFG		0x1
@@ -74,6 +75,8 @@ struct fsi_spi {
 	struct device *dev;	/* SPI controller device */
 	struct fsi_device *fsi;	/* FSI2SPI CFAM engine device */
 	u32 base;
+	size_t max_xfr_size;
+	bool restricted;
 };
 
 struct fsi_spi_sequence {
@@ -209,8 +212,12 @@ static int fsi_spi_reset(struct fsi_spi *ctx)
 	if (rc)
 		return rc;
 
-	return fsi_spi_write_reg(ctx, SPI_FSI_CLOCK_CFG,
-				 SPI_FSI_CLOCK_CFG_RESET2);
+	rc = fsi_spi_write_reg(ctx, SPI_FSI_CLOCK_CFG,
+			       SPI_FSI_CLOCK_CFG_RESET2);
+	if (rc)
+		return rc;
+
+	return fsi_spi_write_reg(ctx, SPI_FSI_STATUS, 0ULL);
 }
 
 static int fsi_spi_sequence_add(struct fsi_spi_sequence *seq, u8 val)
@@ -218,8 +225,8 @@ static int fsi_spi_sequence_add(struct fsi_spi_sequence *seq, u8 val)
 	/*
 	 * Add the next byte of instruction to the 8-byte sequence register.
 	 * Then decrement the counter so that the next instruction will go in
-	 * the right place. Return the number of "slots" left in the sequence
-	 * register.
+	 * the right place. Return the index of the slot we just filled in the
+	 * sequence register.
 	 */
 	seq->data |= (u64)val << seq->bit;
 	seq->bit -= 8;
@@ -237,9 +244,11 @@ static int fsi_spi_sequence_transfer(struct fsi_spi *ctx,
 				     struct fsi_spi_sequence *seq,
 				     struct spi_transfer *transfer)
 {
+	bool docfg = false;
 	int loops;
 	int idx;
 	int rc;
+	u8 val = 0;
 	u8 len = min(transfer->len, 8U);
 	u8 rem = transfer->len % len;
 	u64 cfg = 0ULL;
@@ -247,22 +256,42 @@ static int fsi_spi_sequence_transfer(struct fsi_spi *ctx,
 	loops = transfer->len / len;
 
 	if (transfer->tx_buf) {
-		idx = fsi_spi_sequence_add(seq,
-					   SPI_FSI_SEQUENCE_SHIFT_OUT(len));
+		val = SPI_FSI_SEQUENCE_SHIFT_OUT(len);
+		idx = fsi_spi_sequence_add(seq, val);
+
 		if (rem)
 			rem = SPI_FSI_SEQUENCE_SHIFT_OUT(rem);
 	} else if (transfer->rx_buf) {
-		idx = fsi_spi_sequence_add(seq,
-					   SPI_FSI_SEQUENCE_SHIFT_IN(len));
+		val = SPI_FSI_SEQUENCE_SHIFT_IN(len);
+		idx = fsi_spi_sequence_add(seq, val);
+
 		if (rem)
 			rem = SPI_FSI_SEQUENCE_SHIFT_IN(rem);
 	} else {
 		return -EINVAL;
 	}
 
+	if (ctx->restricted) {
+		const int eidx = rem ? 5 : 6;
+
+		while (loops > 1 && idx <= eidx) {
+			idx = fsi_spi_sequence_add(seq, val);
+			loops--;
+			docfg = true;
+		}
+
+		if (loops > 1) {
+			dev_warn(ctx->dev, "No sequencer slots; aborting.\n");
+			return -EINVAL;
+		}
+	}
+
 	if (loops > 1) {
 		fsi_spi_sequence_add(seq, SPI_FSI_SEQUENCE_BRANCH(idx));
+		docfg = true;
+	}
 
+	if (docfg) {
 		cfg = SPI_FSI_COUNTER_CFG_LOOPS(loops - 1);
 		if (transfer->rx_buf)
 			cfg |= SPI_FSI_COUNTER_CFG_N2_RX |
@@ -273,6 +302,8 @@ static int fsi_spi_sequence_transfer(struct fsi_spi *ctx,
 		rc = fsi_spi_write_reg(ctx, SPI_FSI_COUNTER_CFG, cfg);
 		if (rc)
 			return rc;
+	} else {
+		fsi_spi_write_reg(ctx, SPI_FSI_COUNTER_CFG, 0ULL);
 	}
 
 	if (rem)
@@ -429,7 +460,7 @@ static int fsi_spi_transfer_one_message(struct spi_controller *ctlr,
 
 		/* Sequencer must do shift out (tx) first. */
 		if (!transfer->tx_buf ||
-		    transfer->len > SPI_FSI_MAX_TRANSFER_SIZE) {
+		    transfer->len > (ctx->max_xfr_size + 8)) {
 			rc = -EINVAL;
 			goto error;
 		}
@@ -453,7 +484,7 @@ static int fsi_spi_transfer_one_message(struct spi_controller *ctlr,
 
 			/* Sequencer can only do shift in (rx) after tx. */
 			if (next->rx_buf) {
-				if (next->len > SPI_FSI_MAX_TRANSFER_SIZE) {
+				if (next->len > ctx->max_xfr_size) {
 					rc = -EINVAL;
 					goto error;
 				}
@@ -498,7 +529,9 @@ static int fsi_spi_transfer_one_message(struct spi_controller *ctlr,
 
 static size_t fsi_spi_max_transfer_size(struct spi_device *spi)
 {
-	return SPI_FSI_MAX_TRANSFER_SIZE;
+	struct fsi_spi *ctx = spi_controller_get_devdata(spi->controller);
+
+	return ctx->max_xfr_size;
 }
 
 static int fsi_spi_probe(struct device *dev)
@@ -546,6 +579,14 @@ static int fsi_spi_probe(struct device *dev)
 		ctx->fsi = fsi;
 		ctx->base = base + SPI_FSI_BASE;
 
+		if (of_device_is_compatible(np, "ibm,fsi2spi-restricted")) {
+			ctx->restricted = true;
+			ctx->max_xfr_size = SPI_FSI_MAX_XFR_SIZE_RESTRICTED;
+		} else {
+			ctx->restricted = false;
+			ctx->max_xfr_size = SPI_FSI_MAX_XFR_SIZE;
+		}
+
 		rc = devm_spi_register_controller(dev, ctlr);
 		if (rc)
 			spi_controller_put(ctlr);
-- 
2.25.1



