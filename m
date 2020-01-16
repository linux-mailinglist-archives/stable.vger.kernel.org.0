Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55BB214002E
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:48:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390443AbgAPXTj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:19:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:45588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729923AbgAPXTi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:19:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 879D22072B;
        Thu, 16 Jan 2020 23:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579216778;
        bh=rLsv+qy28V1NQ/0M5cJFMA/bZ0WPRM3Q2uL7EYHh5bM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h/O5zr++szCHxvrA2+DwvfuiZEMdiguWuoiLFwJzFVo+u71BTMz07Hf+6g557UDAC
         W3ZRSN+kd8F+rJjb/a9wJBbP6eJ3ncb2SWC80OlRTMuSMZP6P8/BIIeaHMHZuuihv0
         vowRnAbHZuVOTog0g/GoEgVMzUrDXUZKzSFpcqgA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Kerello <christophe.kerello@st.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.4 007/203] mtd: rawnand: stm32_fmc2: avoid to lock the CPU bus
Date:   Fri, 17 Jan 2020 00:15:24 +0100
Message-Id: <20200116231745.665943525@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Kerello <christophe.kerello@st.com>

commit 4114b17af41272e14939b000ce8f3ed7ba937e3c upstream.

We are currently using nand_soft_waitrdy to poll the status of the NAND
flash. FMC2 enables the wait feature bit (this feature is mandatory for
the sequencer mode). By enabling this feature, we can't poll the status
of the NAND flash, the read status command is stucked in FMC2 pipeline
until R/B# signal is high, and locks the CPU bus.
To avoid to lock the CPU bus, we poll FMC2 ISR register. This register
reports the status of the R/B# signal.

Fixes: 2cd457f328c1 ("mtd: rawnand: stm32_fmc2: add STM32 FMC2 NAND flash controller driver")
Signed-off-by: Christophe Kerello <christophe.kerello@st.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/nand/raw/stm32_fmc2_nand.c |   38 +++++++++++++++++++++++++++++++--
 1 file changed, 36 insertions(+), 2 deletions(-)

--- a/drivers/mtd/nand/raw/stm32_fmc2_nand.c
+++ b/drivers/mtd/nand/raw/stm32_fmc2_nand.c
@@ -37,6 +37,7 @@
 /* Max ECC buffer length */
 #define FMC2_MAX_ECC_BUF_LEN		(FMC2_BCHDSRS_LEN * FMC2_MAX_SG)
 
+#define FMC2_TIMEOUT_US			1000
 #define FMC2_TIMEOUT_MS			1000
 
 /* Timings */
@@ -53,6 +54,8 @@
 #define FMC2_PMEM			0x88
 #define FMC2_PATT			0x8c
 #define FMC2_HECCR			0x94
+#define FMC2_ISR			0x184
+#define FMC2_ICR			0x188
 #define FMC2_CSQCR			0x200
 #define FMC2_CSQCFGR1			0x204
 #define FMC2_CSQCFGR2			0x208
@@ -118,6 +121,12 @@
 #define FMC2_PATT_ATTHIZ(x)		(((x) & 0xff) << 24)
 #define FMC2_PATT_DEFAULT		0x0a0a0a0a
 
+/* Register: FMC2_ISR */
+#define FMC2_ISR_IHLF			BIT(1)
+
+/* Register: FMC2_ICR */
+#define FMC2_ICR_CIHLF			BIT(1)
+
 /* Register: FMC2_CSQCR */
 #define FMC2_CSQCR_CSQSTART		BIT(0)
 
@@ -1322,6 +1331,31 @@ static void stm32_fmc2_write_data(struct
 		stm32_fmc2_set_buswidth_16(fmc2, true);
 }
 
+static int stm32_fmc2_waitrdy(struct nand_chip *chip, unsigned long timeout_ms)
+{
+	struct stm32_fmc2_nfc *fmc2 = to_stm32_nfc(chip->controller);
+	const struct nand_sdr_timings *timings;
+	u32 isr, sr;
+
+	/* Check if there is no pending requests to the NAND flash */
+	if (readl_relaxed_poll_timeout_atomic(fmc2->io_base + FMC2_SR, sr,
+					      sr & FMC2_SR_NWRF, 1,
+					      FMC2_TIMEOUT_US))
+		dev_warn(fmc2->dev, "Waitrdy timeout\n");
+
+	/* Wait tWB before R/B# signal is low */
+	timings = nand_get_sdr_timings(&chip->data_interface);
+	ndelay(PSEC_TO_NSEC(timings->tWB_max));
+
+	/* R/B# signal is low, clear high level flag */
+	writel_relaxed(FMC2_ICR_CIHLF, fmc2->io_base + FMC2_ICR);
+
+	/* Wait R/B# signal is high */
+	return readl_relaxed_poll_timeout_atomic(fmc2->io_base + FMC2_ISR,
+						 isr, isr & FMC2_ISR_IHLF,
+						 5, 1000 * timeout_ms);
+}
+
 static int stm32_fmc2_exec_op(struct nand_chip *chip,
 			      const struct nand_operation *op,
 			      bool check_only)
@@ -1366,8 +1400,8 @@ static int stm32_fmc2_exec_op(struct nan
 			break;
 
 		case NAND_OP_WAITRDY_INSTR:
-			ret = nand_soft_waitrdy(chip,
-						instr->ctx.waitrdy.timeout_ms);
+			ret = stm32_fmc2_waitrdy(chip,
+						 instr->ctx.waitrdy.timeout_ms);
 			break;
 		}
 	}


