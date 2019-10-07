Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75179CDC69
	for <lists+stable@lfdr.de>; Mon,  7 Oct 2019 09:32:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbfJGHcF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 7 Oct 2019 03:32:05 -0400
Received: from skedge04.snt-world.com ([91.208.41.69]:58854 "EHLO
        skedge04.snt-world.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726960AbfJGHcF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Oct 2019 03:32:05 -0400
X-Greylist: delayed 538 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Oct 2019 03:32:04 EDT
Received: from sntmail12r.snt-is.com (unknown [10.203.32.182])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by skedge04.snt-world.com (Postfix) with ESMTPS id 7DAC767A7D3;
        Mon,  7 Oct 2019 09:23:03 +0200 (CEST)
Received: from sntmail12r.snt-is.com (10.203.32.182) by sntmail12r.snt-is.com
 (10.203.32.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Mon, 7 Oct 2019
 09:23:03 +0200
Received: from sntmail12r.snt-is.com ([fe80::e551:8750:7bba:3305]) by
 sntmail12r.snt-is.com ([fe80::e551:8750:7bba:3305%3]) with mapi id
 15.01.1713.004; Mon, 7 Oct 2019 09:23:03 +0200
From:   Schrempf Frieder <frieder.schrempf@kontron.de>
To:     Han Xu <han.xu@nxp.com>, Mark Brown <broonie@kernel.org>
CC:     Schrempf Frieder <frieder.schrempf@kontron.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] spi: spi-fsl-qspi: Clear TDH bits in FLSHCR register
Thread-Topic: [PATCH] spi: spi-fsl-qspi: Clear TDH bits in FLSHCR register
Thread-Index: AQHVfOAOADpafN6rX02KBDhfRCqXYw==
Date:   Mon, 7 Oct 2019 07:23:02 +0000
Message-ID: <20191007071933.26786-1-frieder.schrempf@kontron.de>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-originating-ip: [172.25.9.193]
x-c2processedorg: 51b406b7-48a2-4d03-b652-521f56ac89f3
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-SnT-MailScanner-Information: Please contact the ISP for more information
X-SnT-MailScanner-ID: 7DAC767A7D3.AF040
X-SnT-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-SnT-MailScanner-SpamCheck: 
X-SnT-MailScanner-From: frieder.schrempf@kontron.de
X-SnT-MailScanner-To: broonie@kernel.org, han.xu@nxp.com,
        linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        stable@vger.kernel.org
X-Spam-Status: No
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frieder Schrempf <frieder.schrempf@kontron.de>

Later versions of the QSPI controller (e.g. in i.MX6UL/ULL and i.MX7)
seem to have an additional TDH setting in the FLSHCR register, that
needs to be set in accordance with the access mode that is used (DDR
or SDR).

Previous bootstages such as BootROM or bootloader might have used the
DDR mode to access the flash. As we currently only use SDR mode, we
need to make sure the TDH bits are cleared upon initialization.

Fixes: 84d043185dbe ("spi: Add a driver for the Freescale/NXP QuadSPI controller")
Cc: <stable@vger.kernel.org>
Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
---
 drivers/spi/spi-fsl-qspi.c | 38 +++++++++++++++++++++++++++++++++-----
 1 file changed, 33 insertions(+), 5 deletions(-)

diff --git a/drivers/spi/spi-fsl-qspi.c b/drivers/spi/spi-fsl-qspi.c
index c02e24c01136..63c9f7edaf6c 100644
--- a/drivers/spi/spi-fsl-qspi.c
+++ b/drivers/spi/spi-fsl-qspi.c
@@ -63,6 +63,11 @@
 #define QUADSPI_IPCR			0x08
 #define QUADSPI_IPCR_SEQID(x)		((x) << 24)
 
+#define QUADSPI_FLSHCR			0x0c
+#define QUADSPI_FLSHCR_TCSS_MASK	GENMASK(3, 0)
+#define QUADSPI_FLSHCR_TCSH_MASK	GENMASK(11, 8)
+#define QUADSPI_FLSHCR_TDH_MASK		GENMASK(17, 16)
+
 #define QUADSPI_BUF3CR			0x1c
 #define QUADSPI_BUF3CR_ALLMST_MASK	BIT(31)
 #define QUADSPI_BUF3CR_ADATSZ(x)	((x) << 8)
@@ -95,6 +100,9 @@
 #define QUADSPI_FR			0x160
 #define QUADSPI_FR_TFF_MASK		BIT(0)
 
+#define QUADSPI_RSER			0x164
+#define QUADSPI_RSER_TFIE		BIT(0)
+
 #define QUADSPI_SPTRCLR			0x16c
 #define QUADSPI_SPTRCLR_IPPTRC		BIT(8)
 #define QUADSPI_SPTRCLR_BFPTRC		BIT(0)
@@ -112,9 +120,6 @@
 #define QUADSPI_LCKER_LOCK		BIT(0)
 #define QUADSPI_LCKER_UNLOCK		BIT(1)
 
-#define QUADSPI_RSER			0x164
-#define QUADSPI_RSER_TFIE		BIT(0)
-
 #define QUADSPI_LUT_BASE		0x310
 #define QUADSPI_LUT_OFFSET		(SEQID_LUT * 4 * 4)
 #define QUADSPI_LUT_REG(idx) \
@@ -181,6 +186,12 @@
  */
 #define QUADSPI_QUIRK_BASE_INTERNAL	BIT(4)
 
+/*
+ * Controller uses TDH bits in register QUADSPI_FLSHCR.
+ * They need to be set in accordance with the DDR/SDR mode.
+ */
+#define QUADSPI_QUIRK_USE_TDH_SETTING	BIT(5)
+
 struct fsl_qspi_devtype_data {
 	unsigned int rxfifo;
 	unsigned int txfifo;
@@ -209,7 +220,8 @@ static const struct fsl_qspi_devtype_data imx7d_data = {
 	.rxfifo = SZ_128,
 	.txfifo = SZ_512,
 	.ahb_buf_size = SZ_1K,
-	.quirks = QUADSPI_QUIRK_TKT253890 | QUADSPI_QUIRK_4X_INT_CLK,
+	.quirks = QUADSPI_QUIRK_TKT253890 | QUADSPI_QUIRK_4X_INT_CLK |
+		  QUADSPI_QUIRK_USE_TDH_SETTING,
 	.little_endian = true,
 };
 
@@ -217,7 +229,8 @@ static const struct fsl_qspi_devtype_data imx6ul_data = {
 	.rxfifo = SZ_128,
 	.txfifo = SZ_512,
 	.ahb_buf_size = SZ_1K,
-	.quirks = QUADSPI_QUIRK_TKT253890 | QUADSPI_QUIRK_4X_INT_CLK,
+	.quirks = QUADSPI_QUIRK_TKT253890 | QUADSPI_QUIRK_4X_INT_CLK |
+		  QUADSPI_QUIRK_USE_TDH_SETTING,
 	.little_endian = true,
 };
 
@@ -275,6 +288,11 @@ static inline int needs_amba_base_offset(struct fsl_qspi *q)
 	return !(q->devtype_data->quirks & QUADSPI_QUIRK_BASE_INTERNAL);
 }
 
+static inline int needs_tdh_setting(struct fsl_qspi *q)
+{
+	return q->devtype_data->quirks & QUADSPI_QUIRK_USE_TDH_SETTING;
+}
+
 /*
  * An IC bug makes it necessary to rearrange the 32-bit data.
  * Later chips, such as IMX6SLX, have fixed this bug.
@@ -710,6 +728,16 @@ static int fsl_qspi_default_setup(struct fsl_qspi *q)
 	qspi_writel(q, QUADSPI_MCR_MDIS_MASK | QUADSPI_MCR_RESERVED_MASK,
 		    base + QUADSPI_MCR);
 
+	/*
+	 * Previous boot stages (BootROM, bootloader) might have used DDR
+	 * mode and did not clear the TDH bits. As we currently use SDR mode
+	 * only, clear the TDH bits if necessary.
+	 */
+	if (needs_tdh_setting(q))
+		qspi_writel(q, qspi_readl(q, base + QUADSPI_FLSHCR) &
+			    ~QUADSPI_FLSHCR_TDH_MASK,
+			    base + QUADSPI_FLSHCR);
+
 	reg = qspi_readl(q, base + QUADSPI_SMPR);
 	qspi_writel(q, reg & ~(QUADSPI_SMPR_FSDLY_MASK
 			| QUADSPI_SMPR_FSPHS_MASK
-- 
2.17.1
