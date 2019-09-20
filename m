Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF2DB9336
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 16:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728994AbfITOY6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 10:24:58 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35592 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728923AbfITOY5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 10:24:57 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqA-0004va-Rk; Fri, 20 Sep 2019 15:24:54 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqA-0007od-8Z; Fri, 20 Sep 2019 15:24:54 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Geert Uytterhoeven" <geert+renesas@glider.be>,
        "Mark Brown" <broonie@kernel.org>
Date:   Fri, 20 Sep 2019 15:23:35 +0100
Message-ID: <lsq.1568989415.278574693@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 001/132] spi: rspi: Fix register initialization while
 runtime-suspended
In-Reply-To: <lsq.1568989414.954567518@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.74-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit 42bdaaece121b3bb50fd4d1203d6d0170279f9fa upstream.

The Renesas RSPI/QSPI driver performs SPI controller register
initialization in its spi_operations.setup() callback, without calling
pm_runtime_get_sync() first, which may cause spurious failures.

So far this went unnoticed, as this SPI controller is typically used
with a single SPI NOR FLASH containing the boot loader:
  1. If the device's module clock is still enabled (left enabled by the
     bootloader, and not yet disabled by the clk_disable_unused() late
     initcall), register initialization succeeds,
  2. If the device's module clock is disabled, register writes don't
     seem to cause lock-ups or crashes.
     Data received in the first SPI message may be corrupted, though.
     Subsequent SPI messages seem to be OK.
     E.g. on r8a7791/koelsch, one bit is lost while receiving the 6th
     byte of the JEDEC ID for the s25fl512s FLASH, corrupting that byte
     and all later bytes.  But until commit a2126b0a010905e5 ("mtd:
     spi-nor: refine Spansion S25FL512S ID"), the 6th byte was not
     considered for FLASH identification.

Fix this by moving all initialization from the .setup() to the
.prepare_message() callback.  The latter is always called after the
device has been runtime-resumed by the SPI core.

This also makes the driver follow the rule that .setup() must not change
global driver state or register values, as that might break a transfer
in progress.

Fixes: 490c97747d5dc77d ("spi: rspi: Add runtime PM support, using spi core auto_runtime_pm")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Mark Brown <broonie@kernel.org>
[bwh: Backported to 3.16: s/(controller|ctlr)/master/g]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/spi/spi-rspi.c | 39 ++++++++++++++++-----------------------
 1 file changed, 16 insertions(+), 23 deletions(-)

--- a/drivers/spi/spi-rspi.c
+++ b/drivers/spi/spi-rspi.c
@@ -726,28 +726,6 @@ static int qspi_transfer_one(struct spi_
 	}
 }
 
-static int rspi_setup(struct spi_device *spi)
-{
-	struct rspi_data *rspi = spi_master_get_devdata(spi->master);
-
-	rspi->max_speed_hz = spi->max_speed_hz;
-
-	rspi->spcmd = SPCMD_SSLKP;
-	if (spi->mode & SPI_CPOL)
-		rspi->spcmd |= SPCMD_CPOL;
-	if (spi->mode & SPI_CPHA)
-		rspi->spcmd |= SPCMD_CPHA;
-
-	/* CMOS output mode and MOSI signal from previous transfer */
-	rspi->sppcr = 0;
-	if (spi->mode & SPI_LOOP)
-		rspi->sppcr |= SPPCR_SPLP;
-
-	set_config_register(rspi, 8);
-
-	return 0;
-}
-
 static u16 qspi_transfer_mode(const struct spi_transfer *xfer)
 {
 	if (xfer->tx_buf)
@@ -817,8 +795,24 @@ static int rspi_prepare_message(struct s
 				struct spi_message *msg)
 {
 	struct rspi_data *rspi = spi_master_get_devdata(master);
+	struct spi_device *spi = msg->spi;
 	int ret;
 
+	rspi->max_speed_hz = spi->max_speed_hz;
+
+	rspi->spcmd = SPCMD_SSLKP;
+	if (spi->mode & SPI_CPOL)
+		rspi->spcmd |= SPCMD_CPOL;
+	if (spi->mode & SPI_CPHA)
+		rspi->spcmd |= SPCMD_CPHA;
+
+	/* CMOS output mode and MOSI signal from previous transfer */
+	rspi->sppcr = 0;
+	if (spi->mode & SPI_LOOP)
+		rspi->sppcr |= SPPCR_SPLP;
+
+	set_config_register(rspi, 8);
+
 	if (msg->spi->mode &
 	    (SPI_TX_DUAL | SPI_TX_QUAD | SPI_RX_DUAL | SPI_RX_QUAD)) {
 		/* Setup sequencer for messages with multiple transfer modes */
@@ -1119,7 +1113,6 @@ static int rspi_probe(struct platform_de
 	init_waitqueue_head(&rspi->wait);
 
 	master->bus_num = pdev->id;
-	master->setup = rspi_setup;
 	master->auto_runtime_pm = true;
 	master->transfer_one = ops->transfer_one;
 	master->prepare_message = rspi_prepare_message;

