Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F45C40C593
	for <lists+stable@lfdr.de>; Wed, 15 Sep 2021 14:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233060AbhIOMuH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Sep 2021 08:50:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:59688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232824AbhIOMuG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Sep 2021 08:50:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8310461186;
        Wed, 15 Sep 2021 12:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631710128;
        bh=hYFq6IfOi2zMTOFAb52oWKlSAOPvUPZw13kQp4+aUmk=;
        h=Subject:To:Cc:From:Date:From;
        b=m5vQT6mNjveM/BzJpqUXFNRZ0I3qSD6RFUAWDHR9elor+gEmvR69GR4llJTXsL5Ld
         u0pqJju3rEHP5v6JWSitBXt6B2IH1KiDjhiZi69pBFZBR7JniNjDe3KLxP+cgtszN3
         H/4XwjEVAzj/NCKx5f6ny4d+12bJ3EDdN4dIUt7I=
Subject: FAILED: patch "[PATCH] spi: fsi: Reduce max transfer size to 8 bytes" failed to apply to 5.10-stable tree
To:     eajames@linux.ibm.com, broonie@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 15 Sep 2021 14:48:40 +0200
Message-ID: <16317101203945@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 34d34a56a5ea1e54a5af4f34c6ac9df724129351 Mon Sep 17 00:00:00 2001
From: Eddie James <eajames@linux.ibm.com>
Date: Fri, 16 Jul 2021 08:39:14 -0500
Subject: [PATCH] spi: fsi: Reduce max transfer size to 8 bytes

Security changes have forced the SPI controllers to be limited to
8 byte reads. Refactor the sequencing to just handle 8 bytes at a
time.

Signed-off-by: Eddie James <eajames@linux.ibm.com>
Link: https://lore.kernel.org/r/20210716133915.14697-2-eajames@linux.ibm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org

diff --git a/drivers/spi/spi-fsi.c b/drivers/spi/spi-fsi.c
index 87f8829c3995..829770b8ec74 100644
--- a/drivers/spi/spi-fsi.c
+++ b/drivers/spi/spi-fsi.c
@@ -25,16 +25,11 @@
 
 #define SPI_FSI_BASE			0x70000
 #define SPI_FSI_INIT_TIMEOUT_MS		1000
-#define SPI_FSI_MAX_XFR_SIZE		2048
-#define SPI_FSI_MAX_XFR_SIZE_RESTRICTED	8
+#define SPI_FSI_MAX_RX_SIZE		8
+#define SPI_FSI_MAX_TX_SIZE		40
 
 #define SPI_FSI_ERROR			0x0
 #define SPI_FSI_COUNTER_CFG		0x1
-#define  SPI_FSI_COUNTER_CFG_LOOPS(x)	 (((u64)(x) & 0xffULL) << 32)
-#define  SPI_FSI_COUNTER_CFG_N2_RX	 BIT_ULL(8)
-#define  SPI_FSI_COUNTER_CFG_N2_TX	 BIT_ULL(9)
-#define  SPI_FSI_COUNTER_CFG_N2_IMPLICIT BIT_ULL(10)
-#define  SPI_FSI_COUNTER_CFG_N2_RELOAD	 BIT_ULL(11)
 #define SPI_FSI_CFG1			0x2
 #define SPI_FSI_CLOCK_CFG		0x3
 #define  SPI_FSI_CLOCK_CFG_MM_ENABLE	 BIT_ULL(32)
@@ -76,8 +71,6 @@ struct fsi_spi {
 	struct device *dev;	/* SPI controller device */
 	struct fsi_device *fsi;	/* FSI2SPI CFAM engine device */
 	u32 base;
-	size_t max_xfr_size;
-	bool restricted;
 };
 
 struct fsi_spi_sequence {
@@ -241,7 +234,7 @@ static int fsi_spi_reset(struct fsi_spi *ctx)
 	return fsi_spi_write_reg(ctx, SPI_FSI_STATUS, 0ULL);
 }
 
-static int fsi_spi_sequence_add(struct fsi_spi_sequence *seq, u8 val)
+static void fsi_spi_sequence_add(struct fsi_spi_sequence *seq, u8 val)
 {
 	/*
 	 * Add the next byte of instruction to the 8-byte sequence register.
@@ -251,8 +244,6 @@ static int fsi_spi_sequence_add(struct fsi_spi_sequence *seq, u8 val)
 	 */
 	seq->data |= (u64)val << seq->bit;
 	seq->bit -= 8;
-
-	return ((64 - seq->bit) / 8) - 2;
 }
 
 static void fsi_spi_sequence_init(struct fsi_spi_sequence *seq)
@@ -261,71 +252,11 @@ static void fsi_spi_sequence_init(struct fsi_spi_sequence *seq)
 	seq->data = 0ULL;
 }
 
-static int fsi_spi_sequence_transfer(struct fsi_spi *ctx,
-				     struct fsi_spi_sequence *seq,
-				     struct spi_transfer *transfer)
-{
-	int loops;
-	int idx;
-	int rc;
-	u8 val = 0;
-	u8 len = min(transfer->len, 8U);
-	u8 rem = transfer->len % len;
-
-	loops = transfer->len / len;
-
-	if (transfer->tx_buf) {
-		val = SPI_FSI_SEQUENCE_SHIFT_OUT(len);
-		idx = fsi_spi_sequence_add(seq, val);
-
-		if (rem)
-			rem = SPI_FSI_SEQUENCE_SHIFT_OUT(rem);
-	} else if (transfer->rx_buf) {
-		val = SPI_FSI_SEQUENCE_SHIFT_IN(len);
-		idx = fsi_spi_sequence_add(seq, val);
-
-		if (rem)
-			rem = SPI_FSI_SEQUENCE_SHIFT_IN(rem);
-	} else {
-		return -EINVAL;
-	}
-
-	if (ctx->restricted && loops > 1) {
-		dev_warn(ctx->dev,
-			 "Transfer too large; no branches permitted.\n");
-		return -EINVAL;
-	}
-
-	if (loops > 1) {
-		u64 cfg = SPI_FSI_COUNTER_CFG_LOOPS(loops - 1);
-
-		fsi_spi_sequence_add(seq, SPI_FSI_SEQUENCE_BRANCH(idx));
-
-		if (transfer->rx_buf)
-			cfg |= SPI_FSI_COUNTER_CFG_N2_RX |
-				SPI_FSI_COUNTER_CFG_N2_TX |
-				SPI_FSI_COUNTER_CFG_N2_IMPLICIT |
-				SPI_FSI_COUNTER_CFG_N2_RELOAD;
-
-		rc = fsi_spi_write_reg(ctx, SPI_FSI_COUNTER_CFG, cfg);
-		if (rc)
-			return rc;
-	} else {
-		fsi_spi_write_reg(ctx, SPI_FSI_COUNTER_CFG, 0ULL);
-	}
-
-	if (rem)
-		fsi_spi_sequence_add(seq, rem);
-
-	return 0;
-}
-
 static int fsi_spi_transfer_data(struct fsi_spi *ctx,
 				 struct spi_transfer *transfer)
 {
 	int rc = 0;
 	u64 status = 0ULL;
-	u64 cfg = 0ULL;
 
 	if (transfer->tx_buf) {
 		int nb;
@@ -363,16 +294,6 @@ static int fsi_spi_transfer_data(struct fsi_spi *ctx,
 		u64 in = 0ULL;
 		u8 *rx = transfer->rx_buf;
 
-		rc = fsi_spi_read_reg(ctx, SPI_FSI_COUNTER_CFG, &cfg);
-		if (rc)
-			return rc;
-
-		if (cfg & SPI_FSI_COUNTER_CFG_N2_IMPLICIT) {
-			rc = fsi_spi_write_reg(ctx, SPI_FSI_DATA_TX, 0);
-			if (rc)
-				return rc;
-		}
-
 		while (transfer->len > recv) {
 			do {
 				rc = fsi_spi_read_reg(ctx, SPI_FSI_STATUS,
@@ -439,6 +360,10 @@ static int fsi_spi_transfer_init(struct fsi_spi *ctx)
 		}
 	} while (seq_state && (seq_state != SPI_FSI_STATUS_SEQ_STATE_IDLE));
 
+	rc = fsi_spi_write_reg(ctx, SPI_FSI_COUNTER_CFG, 0ULL);
+	if (rc)
+		return rc;
+
 	rc = fsi_spi_read_reg(ctx, SPI_FSI_CLOCK_CFG, &clock_cfg);
 	if (rc)
 		return rc;
@@ -459,6 +384,7 @@ static int fsi_spi_transfer_one_message(struct spi_controller *ctlr,
 {
 	int rc;
 	u8 seq_slave = SPI_FSI_SEQUENCE_SEL_SLAVE(mesg->spi->chip_select + 1);
+	unsigned int len;
 	struct spi_transfer *transfer;
 	struct fsi_spi *ctx = spi_controller_get_devdata(ctlr);
 
@@ -471,8 +397,7 @@ static int fsi_spi_transfer_one_message(struct spi_controller *ctlr,
 		struct spi_transfer *next = NULL;
 
 		/* Sequencer must do shift out (tx) first. */
-		if (!transfer->tx_buf ||
-		    transfer->len > (ctx->max_xfr_size + 8)) {
+		if (!transfer->tx_buf || transfer->len > SPI_FSI_MAX_TX_SIZE) {
 			rc = -EINVAL;
 			goto error;
 		}
@@ -486,9 +411,13 @@ static int fsi_spi_transfer_one_message(struct spi_controller *ctlr,
 		fsi_spi_sequence_init(&seq);
 		fsi_spi_sequence_add(&seq, seq_slave);
 
-		rc = fsi_spi_sequence_transfer(ctx, &seq, transfer);
-		if (rc)
-			goto error;
+		len = transfer->len;
+		while (len > 8) {
+			fsi_spi_sequence_add(&seq,
+					     SPI_FSI_SEQUENCE_SHIFT_OUT(8));
+			len -= 8;
+		}
+		fsi_spi_sequence_add(&seq, SPI_FSI_SEQUENCE_SHIFT_OUT(len));
 
 		if (!list_is_last(&transfer->transfer_list,
 				  &mesg->transfers)) {
@@ -496,7 +425,9 @@ static int fsi_spi_transfer_one_message(struct spi_controller *ctlr,
 
 			/* Sequencer can only do shift in (rx) after tx. */
 			if (next->rx_buf) {
-				if (next->len > ctx->max_xfr_size) {
+				u8 shift;
+
+				if (next->len > SPI_FSI_MAX_RX_SIZE) {
 					rc = -EINVAL;
 					goto error;
 				}
@@ -504,10 +435,8 @@ static int fsi_spi_transfer_one_message(struct spi_controller *ctlr,
 				dev_dbg(ctx->dev, "Sequence rx of %d bytes.\n",
 					next->len);
 
-				rc = fsi_spi_sequence_transfer(ctx, &seq,
-							       next);
-				if (rc)
-					goto error;
+				shift = SPI_FSI_SEQUENCE_SHIFT_IN(next->len);
+				fsi_spi_sequence_add(&seq, shift);
 			} else {
 				next = NULL;
 			}
@@ -541,9 +470,7 @@ error:
 
 static size_t fsi_spi_max_transfer_size(struct spi_device *spi)
 {
-	struct fsi_spi *ctx = spi_controller_get_devdata(spi->controller);
-
-	return ctx->max_xfr_size;
+	return SPI_FSI_MAX_RX_SIZE;
 }
 
 static int fsi_spi_probe(struct device *dev)
@@ -582,14 +509,6 @@ static int fsi_spi_probe(struct device *dev)
 		ctx->fsi = fsi;
 		ctx->base = base + SPI_FSI_BASE;
 
-		if (of_device_is_compatible(np, "ibm,fsi2spi-restricted")) {
-			ctx->restricted = true;
-			ctx->max_xfr_size = SPI_FSI_MAX_XFR_SIZE_RESTRICTED;
-		} else {
-			ctx->restricted = false;
-			ctx->max_xfr_size = SPI_FSI_MAX_XFR_SIZE;
-		}
-
 		rc = devm_spi_register_controller(dev, ctlr);
 		if (rc)
 			spi_controller_put(ctlr);

