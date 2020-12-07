Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFA142D12FB
	for <lists+stable@lfdr.de>; Mon,  7 Dec 2020 15:02:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbgLGOBq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Dec 2020 09:01:46 -0500
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:12148 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726168AbgLGOBq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Dec 2020 09:01:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607349705; x=1638885705;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Nzjzi0BHIpaEs5LQPZKGd7A9lTZUVGUv43h4mqHMor4=;
  b=xhzn8UbHFnEdNlG6qULdWHIUWRQbRQuVe82eQnJl2X6g8bzEQfuWVfdN
   GrKE+lQUBxSM2hYypfvbP62ZjqaHXn1plhGfvmR9PcNrdE0hIh+u/tomp
   7KJS+iuq0IkMvVyi/7oB2d/cy7KBCFoqb2GIWz6YrxprzD/6Fj4d3nNpw
   zd4YAnkjJzVRjHGq3hFfBcFTiPvjnYmGfPpAAULjIw+mWLuJIRm+Q7yOo
   uiS5YxQaOF37jrkaqLXUVgncFL8c3mQ7viwO9iUY1avQCLV+dYlFcw5Be
   7WbzxZbPzjMDsPGGmfBeiJ5lqTae72d3LQ27lC6oIVXcWrCMmjO5ov4Vd
   w==;
IronPort-SDR: 5VFUzwtlK/hoT0qJ1iIRCWO42O3/d/CDb6e5rPBDt02KXJqe+RYM/UFYE0I1TPho5qv5inTLkg
 qQNMWDQJs6Pb8B8EWhppoTpDszFlAxA8FhH/4UZcrBiTgWJ+5vNoW3MQfqQaq/68suIvZnS1/Y
 I7DXUBZ5VIJv44Rrgwniz2kagNuOcW3ssxapUf8piEm+KV3wOa+J9eXvuykvHxT0PHvvaHYfRX
 bkAUfb3JCasBeWNT8T1q4YYKGB9K69xQ42aBJZsmSkQrqH0oAs/M8iAhMJV/V852eHuGBkHYCx
 sk0=
X-IronPort-AV: E=Sophos;i="5.78,399,1599548400"; 
   d="scan'208";a="106511666"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Dec 2020 07:00:39 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 7 Dec 2020 07:00:39 -0700
Received: from atudor-ThinkPad-T470p.amer.actel.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Mon, 7 Dec 2020 07:00:36 -0700
From:   Tudor Ambarus <tudor.ambarus@microchip.com>
To:     <broonie@kernel.org>, <linux-spi@vger.kernel.org>
CC:     <nicolas.ferre@microchip.com>, <alexandre.belloni@bootlin.com>,
        <ludovic.desroches@microchip.com>, <bugalski.piotr@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        "Tudor Ambarus" <tudor.ambarus@microchip.com>,
        <stable@vger.kernel.org>, Tom Burkart <tom@aussec.com>
Subject: [PATCH 1/4] spi: atmel-quadspi: Fix AHB memory accesses
Date:   Mon, 7 Dec 2020 15:59:56 +0200
Message-ID: <20201207135959.154124-2-tudor.ambarus@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201207135959.154124-1-tudor.ambarus@microchip.com>
References: <20201207135959.154124-1-tudor.ambarus@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/spi/atmel-quadspi.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/atmel-quadspi.c b/drivers/spi/atmel-quadspi.c
index b44521d4a245..ad913212426e 100644
--- a/drivers/spi/atmel-quadspi.c
+++ b/drivers/spi/atmel-quadspi.c
@@ -365,10 +365,14 @@ static int atmel_qspi_set_cfg(struct atmel_qspi *aq,
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
@@ -393,7 +397,7 @@ static int atmel_qspi_set_cfg(struct atmel_qspi *aq,
 			atmel_qspi_write(icr, aq, QSPI_WICR);
 		atmel_qspi_write(ifr, aq, QSPI_IFR);
 	} else {
-		if (op->data.dir == SPI_MEM_DATA_OUT)
+		if (op->data.nbytes && op->data.dir == SPI_MEM_DATA_OUT)
 			ifr |= QSPI_IFR_SAMA5D2_WRITE_TRSFR;
 
 		/* Set QSPI Instruction Frame registers */
-- 
2.25.1

