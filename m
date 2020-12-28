Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96D8E2E3EAC
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:31:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504061AbgL1Oav (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:30:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:38964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2504058AbgL1Oav (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:30:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E148207B2;
        Mon, 28 Dec 2020 14:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165810;
        bh=z3Rn+HRS8wfvkY/wVJ7Yjsw5fdpfNmkkCJF+q3y3wtc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VrXpRLIMFmjOBJQmApfEkODRfzEun9uSwlENScGd3JmoM/Gnu0eit1NQjxdRuyg+F
         f5f8+Ki+JC7UpiYph6Ma9tYAZilf8dFKPYtd8hNJ9wAIrBuPhB+OYvH8+Mpzg4cgkI
         iw+YL0+EmVOciqnyCq8V8+uoRcZCsBsf+E2Lj0hg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Burkart <tom@aussec.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 662/717] spi: atmel-quadspi: Fix AHB memory accesses
Date:   Mon, 28 Dec 2020 13:51:00 +0100
Message-Id: <20201228125052.686496870@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
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
@@ -365,10 +365,14 @@ static int atmel_qspi_set_cfg(struct atm
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
@@ -393,7 +397,7 @@ static int atmel_qspi_set_cfg(struct atm
 			atmel_qspi_write(icr, aq, QSPI_WICR);
 		atmel_qspi_write(ifr, aq, QSPI_IFR);
 	} else {
-		if (op->data.dir == SPI_MEM_DATA_OUT)
+		if (op->data.nbytes && op->data.dir == SPI_MEM_DATA_OUT)
 			ifr |= QSPI_IFR_SAMA5D2_WRITE_TRSFR;
 
 		/* Set QSPI Instruction Frame registers */


