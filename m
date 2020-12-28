Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88EBE2E42D5
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:29:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392685AbgL1P2i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:28:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:58430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406523AbgL1N5H (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:57:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0304420782;
        Mon, 28 Dec 2020 13:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163811;
        bh=FgAvX5q8uBUQ9ARkg1kdFr4ER2t34gxlaxZVlDPXBsM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DcDvcdGOYKEiRuCfBBMeKjVjG5L7tC2mutg2vreiCSRZIg2Euke563HXnvQRzIjXa
         OV+H4QYssbMc52hOQXvza0X5Ls/C6GgaJRJJceQiZHY6XGAw44B7db1XKI7FiUWxxL
         cK4OSfBykZNi5/Bt62wP0xQXFnXOZ+eQas+xwFbo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Burkart <tom@aussec.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 416/453] spi: atmel-quadspi: Fix AHB memory accesses
Date:   Mon, 28 Dec 2020 13:50:52 +0100
Message-Id: <20201228124957.240440116@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tudor Ambarus <tudor.ambarus@microchip.com>

commit cac8c821059639b015586abf61623c62cc549a13 upstream.

Following error was seen when mounting a 16MByte ubifs:
UBIFS error (ubi0:0 pid 1893): check_lpt_type.constprop.6: invalid type (15) in LPT node type

QSPI_IFR.TFRTYP was not set correctly. When data transfer is enabled
and one wants to access the serial memory through AHB in order to:
 - read in the serial memory, but not a memory data, for example
   a JEDEC-ID, QSPI_IFR.TFRTYP must be written to '0' (both sama5d2
   and sam9x60).
 - read in the serial memory, and particularly a memory data,
   TFRTYP must be written to '1' (both sama5d2 and sam9x60).
 - write in the serial memory, but not a memory data, for example
   writing the configuration or the QSPI_SR, TFRTYP must be written
   to '2' for sama5d2 and to '0' for sam9x60.
 - write in the serial memory in particular to program a memory data,
   TFRTYP must be written to '3' for sama5d2 and to '1' for sam9x60.

Fix the setting of the QSPI_IFR.TFRTYP field.

Fixes: 2d30ac5ed633 ("mtd: spi-nor: atmel-quadspi: Use spi-mem interface for atmel-quadspi driver")
Cc: <stable@vger.kernel.org> # v5.0+
Reported-by: Tom Burkart <tom@aussec.com>
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Link: https://lore.kernel.org/r/20201207135959.154124-2-tudor.ambarus@microchip.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/atmel-quadspi.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/spi/atmel-quadspi.c
+++ b/drivers/spi/atmel-quadspi.c
@@ -284,10 +284,14 @@ static int atmel_qspi_set_cfg(struct atm
 	if (dummy_cycles)
 		ifr |= QSPI_IFR_NBDUM(dummy_cycles);
 
-	/* Set data enable */
-	if (op->data.nbytes)
+	/* Set data enable and data transfer type. */
+	if (op->data.nbytes) {
 		ifr |= QSPI_IFR_DATAEN;
 
+		if (op->addr.nbytes)
+			ifr |= QSPI_IFR_TFRTYP_MEM;
+	}
+
 	/*
 	 * If the QSPI controller is set in regular SPI mode, set it in
 	 * Serial Memory Mode (SMM).
@@ -312,7 +316,7 @@ static int atmel_qspi_set_cfg(struct atm
 			writel_relaxed(icr, aq->regs + QSPI_WICR);
 		writel_relaxed(ifr, aq->regs + QSPI_IFR);
 	} else {
-		if (op->data.dir == SPI_MEM_DATA_OUT)
+		if (op->data.nbytes && op->data.dir == SPI_MEM_DATA_OUT)
 			ifr |= QSPI_IFR_SAMA5D2_WRITE_TRSFR;
 
 		/* Set QSPI Instruction Frame registers */


