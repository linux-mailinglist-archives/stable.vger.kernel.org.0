Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D45311AF06
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:10:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730735AbfLKPKR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:10:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:58500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730729AbfLKPKQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:10:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8B92208C3;
        Wed, 11 Dec 2019 15:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077016;
        bh=WY4vBWzloZIFoF9RuCdF85ivO+hMUaBPhoaIRVUSlMo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tHT/UXiG0QFuxxPWZj1xwAcJdhK8hI/zRUZ+u/qsQbNLR5pkyzUHijDqb0OpZO1tC
         tZPOtGwsHDG5JaWFILjka3vjkb7fom4wyxf/mzrLhSTkWFBDPpb9I4riroxkQuXdwr
         DiSHXR5bmkb+enwBlwq09d9tfVTnuNzLE/9ylOPI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Frieder Schrempf <frieder.schrempf@kontron.de>,
        Han Xu <han.xu@nxp.com>, Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 76/92] spi: spi-fsl-qspi: Clear TDH bits in FLSHCR register
Date:   Wed, 11 Dec 2019 16:06:07 +0100
Message-Id: <20191211150258.542835961@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.977775294@linuxfoundation.org>
References: <20191211150221.977775294@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frieder Schrempf <frieder.schrempf@kontron.de>

commit f6910679e17ad4915f008bd2c614d38052426f7c upstream.

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
Acked-by: Han Xu <han.xu@nxp.com>
Link: https://lore.kernel.org/r/20191007071933.26786-1-frieder.schrempf@kontron.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-fsl-qspi.c |   38 +++++++++++++++++++++++++++++++++-----
 1 file changed, 33 insertions(+), 5 deletions(-)

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
@@ -209,7 +220,8 @@ static const struct fsl_qspi_devtype_dat
 	.rxfifo = SZ_128,
 	.txfifo = SZ_512,
 	.ahb_buf_size = SZ_1K,
-	.quirks = QUADSPI_QUIRK_TKT253890 | QUADSPI_QUIRK_4X_INT_CLK,
+	.quirks = QUADSPI_QUIRK_TKT253890 | QUADSPI_QUIRK_4X_INT_CLK |
+		  QUADSPI_QUIRK_USE_TDH_SETTING,
 	.little_endian = true,
 };
 
@@ -217,7 +229,8 @@ static const struct fsl_qspi_devtype_dat
 	.rxfifo = SZ_128,
 	.txfifo = SZ_512,
 	.ahb_buf_size = SZ_1K,
-	.quirks = QUADSPI_QUIRK_TKT253890 | QUADSPI_QUIRK_4X_INT_CLK,
+	.quirks = QUADSPI_QUIRK_TKT253890 | QUADSPI_QUIRK_4X_INT_CLK |
+		  QUADSPI_QUIRK_USE_TDH_SETTING,
 	.little_endian = true,
 };
 
@@ -275,6 +288,11 @@ static inline int needs_amba_base_offset
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
@@ -710,6 +728,16 @@ static int fsl_qspi_default_setup(struct
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


